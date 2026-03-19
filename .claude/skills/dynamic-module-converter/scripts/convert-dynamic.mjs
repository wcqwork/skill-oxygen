#!/usr/bin/env node
/**
 * convert-dynamic.mjs — 静态 HTML → 动态 FreeMarker 模块自动转换
 *
 * 三层检测 + 标记注入 + FreeMarker 模板关联
 * Usage: node convert-dynamic.mjs --input <preview.html> [--output <dynamic_preview.html>] [--auto]
 */

import { load } from 'cheerio';
import { v4 as uuidv4 } from 'uuid';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ─── CLI Args ───
const args = process.argv.slice(2);
function getArg(name) {
  const idx = args.indexOf(name);
  return idx !== -1 && args[idx + 1] ? args[idx + 1] : null;
}
const AUTO_MODE = args.includes('--auto');

if (args.includes('--help') || args.includes('-h')) {
  console.log('Usage: node convert-dynamic.mjs --input <file.html> [--output <file.html>] [--auto]');
  console.log('  --input   必需，输入的静态 HTML 文件路径');
  console.log('  --output  可选，输出文件路径（默认在同目录生成 dynamic_<原文件名>.html）');
  console.log('  --auto    可选，自动模式，跳过确认');
  process.exit(0);
}

const inputArg = getArg('--input');
if (!inputArg) {
  console.error('[ERROR] 缺少必需参数 --input');
  console.error('Usage: node convert-dynamic.mjs --input <file.html> [--output <file.html>] [--auto]');
  process.exit(1);
}
const inputFile = path.resolve(inputArg);
const outputFile = getArg('--output')
  ? path.resolve(getArg('--output'))
  : path.join(path.dirname(inputFile), 'dynamic_' + path.basename(inputFile));

// ─── Template Registry ───
const TEMPLATES_DIR = path.resolve(__dirname, '../templates/fetched');
let registry = [];
try {
  registry = JSON.parse(fs.readFileSync(path.join(TEMPLATES_DIR, '_registry.json'), 'utf-8'));
} catch (e) {
  console.warn('[WARN] _registry.json 不存在或解析失败，将使用空注册表');
}

function loadTemplate(blockType) {
  const entry = registry.find(r => r.blockType === blockType && r.status === 'ok');
  if (!entry) return null;
  try {
    const content = fs.readFileSync(path.join(TEMPLATES_DIR, entry.fileName), 'utf-8');
    return { content, entry };
  } catch {
    return null;
  }
}

// ─── Detection Configuration ───
const URL_PATTERNS = {
  prodList:     [/\/product\b/i, /\/p\//i, /\/item\b/i, /\/shop\b/i, /\/goods\b/i],
  articleList:  [/\/blog\b/i, /\/news\b/i, /\/article\b/i, /\/post\b/i, /\/press\b/i],
  galleryList:  [/\/gallery\b/i, /\/photo\b/i, /\/album\b/i, /\/image\b/i],
  FAQList:      [/\/faq\b/i, /\/help\b/i, /\/support\b/i, /\/question\b/i],
  videoList:    [/youtube\.com/i, /vimeo\.com/i, /\/video\b/i, /youtu\.be/i],
  downloadList: [/\/download\b/i, /\/resource\b/i, /\/file\b/i],
};

const CONTENT_HEURISTICS = [
  { type: 'prodList',     score: 15, test: (text) => /[\$€¥£₹]\s*\d|USD|price|pricing/i.test(text) },
  { type: 'prodList',     score: 20, test: (text) => /add\s*to\s*cart|buy\s*now|shop\s*now|order\s*now/i.test(text) },
  { type: 'articleList',  score: 15, test: (text) => /\b\d{1,2}\s+(january|february|march|april|may|june|july|august|september|october|november|december)\s+\d{4}\b/i.test(text) || /\d{4}-\d{2}-\d{2}/.test(text) },
  { type: 'articleList',  score: 10, test: (text) => /read\s*more|continue\s*reading|learn\s*more/i.test(text) },
  { type: 'videoList',    score: 20, test: (_t, $el) => {
    const videos = $el.find('video').length;
    const iframes = $el.find('iframe').filter((_, el) => {
      const src = (el.attribs?.src || '').toLowerCase();
      if (!src || src === 'about:blank') return false;
      return /youtube|vimeo|youtu\.be|wistia|dailymotion|video/i.test(src);
    }).length;
    return (videos + iframes) > 0;
  }},
  { type: 'FAQList',      score: 20, test: (text, $el) => {
    const hasQA = /\?\s*$/.test(text) || $el.find('[class*="accordion"], [class*="collapse"], [class*="faq"], details').length > 0;
    return hasQA;
  }},
  { type: 'downloadList', score: 15, test: (text) => /\.(pdf|zip|rar|doc|docx|xls|xlsx)\b/i.test(text) || /\b(MB|KB|GB)\b/.test(text) },
  { type: 'articleList',  score: 12, test: (_t, $el) => $el.find('time, [class*="date"], [class*="time"]').length > 0 },
  { type: 'prodList',     score: 18, test: (_t, $el) => {
    const classes = ($el.html() || '').toLowerCase();
    return /product[-_]?card|prod[-_]?card|product[-_]?item|prod[-_]?item|product[-_]?list/i.test(classes);
  }},
  { type: 'articleList',  score: 18, test: (_t, $el) => {
    const classes = ($el.html() || '').toLowerCase();
    return /article[-_]?card|news[-_]?card|blog[-_]?card|article[-_]?item|news[-_]?item/i.test(classes);
  }},
  { type: 'prodList',     score: 14, test: (_t, $el) => {
    return $el.find('[class*="product"], [class*="prod"]').filter((_, el) => {
      const cls = (el.attribs?.class || '').toLowerCase();
      return /product|prod/.test(cls) && !/production|productivity|produce/.test(cls);
    }).length >= 3;
  }},
  { type: 'prodList',     score: 18, test: (_t, $el) => $el.find('[class*="prodlist"], [class*="prod-list"], [class*="product-list"], [class*="prodList"]').length > 0 },
  { type: 'articleList',  score: 18, test: (_t, $el) => $el.find('[class*="articlelist"], [class*="article-list"], [class*="news-list"], [class*="articleList"]').length > 0 },
  { type: 'galleryList',  score: 18, test: (_t, $el) => $el.find('[class*="gallerylist"], [class*="gallery-list"], [class*="galleryList"]').length > 0 },
  { type: 'downloadList', score: 18, test: (_t, $el) => $el.find('[class*="downloadlist"], [class*="download-list"], [class*="downloadList"]').length > 0 },
  { type: 'videoList',    score: 18, test: (_t, $el) => $el.find('[class*="videolist"], [class*="video-list"], [class*="videoList"]').length > 0 },
  { type: 'FAQList',      score: 18, test: (_t, $el) => $el.find('[class*="faqlist"], [class*="faq-list"], [class*="faqList"]').length > 0 },
];

const BLOCK_TYPE_MAP = {
  prodList:          'phoenix_blocks_prodlist',
  groupProduct:      'phoenix_blocks_groupProduct_new',
  articleList:       'phoenix_blocks_Articlelist',
  groupArticle:      'phoenix_blocks_groupArticle_new',
  galleryList:       'phoenix_blocks_galleryList',
  videoList:         'phoenix_blocks_videoList',
  downloadList:      'phoenix_blocks_downloadlist',
  FAQList:           'phoenix_blocks_faqList',
  commentList:       'phoenix_blocks_commentList',
  articleDetail:     'phoenix_blocks_articleDetail',
};

const TYPE_LABELS = {
  prodList:       '产品列表',
  groupProduct:   '产品分类',
  articleList:    '文章列表',
  groupArticle:   '文章分类',
  galleryList:    '图册列表',
  videoList:      '视频列表',
  downloadList:   '下载列表',
  FAQList:        'FAQ列表',
  commentList:    '评价列表',
  articleDetail:  '文章详情',
};

// ═══════════════════════════════════════════════════════════
//  PHASE 1: Three-Layer Detection
// ═══════════════════════════════════════════════════════════

// ─── Block Discovery (tag-agnostic) ───
const EXCLUDED_TAGS = new Set(['head','script','style','noscript','link','meta','svg','iframe','br','hr']);

function isDataList($, containerEl) {
  const children = $(containerEl).children();
  if (children.length < 3) return false;

  const classattrs = new Set();
  const names = new Set();
  children.each((_, c) => {
    const ca = $(c).attr('classattr') || $(c).attr('data-classattr') || '';
    if (ca) classattrs.add(ca.replace(/-\d{14}$/, ''));
    const nm = $(c).attr('name') || $(c).attr('data-alias') || '';
    if (nm) names.add(nm);
  });
  if (classattrs.size > 1) return false;
  if (names.size > 1) return false;

  const classNames = [];
  children.each((_, c) => classNames.push($(c).attr('class') || ''));
  const uniqueBase = new Set(classNames.map(c => c.split(/\s+/).sort().join(' ')));
  if (uniqueBase.size > Math.ceil(children.length * 0.5)) return false;

  const arr = children.toArray();
  const avgDepth = arr.reduce((sum, c) => sum + $(c).find('*').length, 0) / arr.length;

  if (avgDepth < 2) {
    return false;
  }

  if (avgDepth < 3) {
    const hasRichContent = arr.some(c => {
      const $c = $(c);
      return ($c.find('img').length > 0 && $c.find('h1,h2,h3,h4,h5,h6,p,span').length > 0) ||
             $c.find('a[href]').length > 0;
    });
    if (!hasRichContent) return false;
  }

  return true;
}

function discoverBlocks($) {
  const repeatingContainers = [];

  const SCAN_SKIP_TAGS = new Set(['body', 'html']);

  function scanForRepeats(el, depth) {
    if (depth > 15) return;
    const tag = el.tagName?.toLowerCase();
    if (!tag || EXCLUDED_TAGS.has(tag)) return;
    const children = $(el).children();
    if (children.length >= 3 && !SCAN_SKIP_TAGS.has(tag)) {
      const sigs = {};
      children.each((_, child) => {
        const sig = getTagSignature($, child);
        sigs[sig] = (sigs[sig] || 0) + 1;
      });
      const maxEntry = Object.entries(sigs).sort((a, b) => b[1] - a[1])[0];
      if (maxEntry && maxEntry[1] >= 3 && isDataList($, el)) {
        repeatingContainers.push({ el, count: maxEntry[1], sig: maxEntry[0] });
      }
    }
    children.each((_, child) => scanForRepeats(child, depth + 1));
  }
  scanForRepeats($('body')[0], 0);

  const visited = new Set();
  const blocks = [];

  repeatingContainers.sort((a, b) => b.count - a.count);

  for (const rc of repeatingContainers) {
    let boundary = rc.el;
    const parent = $(boundary).parent();
    if (parent.length && !parent.is('body') && !parent.is('html') && !parent.is('[document]')) {
      const hasHeading = parent.children('h1,h2,h3,h4,h5,h6').length > 0 ||
        parent.children('.sitewidget-hd').length > 0;
      if (hasHeading) {
        boundary = parent[0];
      } else {
        const gp = parent.parent();
        if (gp.length && !gp.is('body') && !gp.is('html')) {
          const gpHasHeading = gp.children('h1,h2,h3,h4,h5,h6').length > 0 ||
            gp.children('.sitewidget-hd').length > 0;
          if (gpHasHeading) boundary = gp[0];
        }
      }
    }

    if (visited.has(boundary)) {
      const existing = blocks.find(b => b.el === boundary);
      if (existing && rc.count > existing.repeatingContainer.count) {
        existing.repeatingContainer = rc;
      }
      continue;
    }
    visited.add(boundary);
    blocks.push({ el: boundary, $el: $(boundary), repeatingContainer: rc });
  }

  const filtered = blocks.filter((block) => {
    for (const other of blocks) {
      if (other === block) continue;
      if ($.contains(other.repeatingContainer.el, block.repeatingContainer.el)) {
        return false;
      }
    }
    return true;
  });

  return filtered;
}

function getTagSignature($, el) {
  const tag = el.tagName;
  const children = $(el).children();
  const hasImg = children.find('img').length > 0 || $(el).find('img').length > 0;
  const hasLink = children.find('a').length > 0 || $(el).find('a').length > 0;
  const hasHeading = $(el).find('h1,h2,h3,h4,h5,h6').length > 0;
  const depth = $(el).find('*').length;
  const depthBucket = depth < 3 ? 'S' : depth < 10 ? 'M' : 'L';
  return `${tag}|img:${hasImg}|a:${hasLink}|h:${hasHeading}|d:${depthBucket}`;
}

function analyzeStructure($, $section) {
  const noResult = { score: 0, itemCount: 0, repeatingSelector: null, repeatingContainer: null, repeatingItemTag: null, repeatingContainerEl: null };
  const container = findRepeatingContainer($, $section);
  if (!container) return noResult;

  const children = $(container).children();
  if (children.length < 3) return noResult;

  const sigs = {};
  children.each((_, child) => {
    const sig = getTagSignature($, child);
    sigs[sig] = (sigs[sig] || 0) + 1;
  });

  const maxSig = Object.entries(sigs).sort((a, b) => b[1] - a[1])[0];
  if (!maxSig) return noResult;

  const count = maxSig[1];
  if (count < 3) return { ...noResult, itemCount: count };

  let score = 0;
  if (count >= 9) score = 40;
  else if (count >= 5) score = 35;
  else score = 25;

  const containerClass = $(container).attr('class') || '';
  const containerTag = container.tagName;

  return { score, itemCount: count, repeatingSelector: maxSig[0], repeatingContainer: containerClass || containerTag, repeatingItemTag: containerTag, repeatingContainerEl: container };
}

function findRepeatingContainer($, $section) {
  const candidates = [];

  function collectCandidates(el, depth) {
    if (depth > 10) return;
    if ($(el).children().length >= 2) candidates.push(el);
    $(el).children().each((_, child) => collectCandidates(child, depth + 1));
  }
  collectCandidates($section[0], 0);

  let bestContainer = null;
  let bestCount = 0;

  for (const cand of candidates) {
    const children = $(cand).children();
    if (children.length < 3) continue;
    const sigs = {};
    children.each((_, child) => {
      const sig = getTagSignature($, child);
      sigs[sig] = (sigs[sig] || 0) + 1;
    });
    const maxEntry = Object.entries(sigs).sort((a, b) => b[1] - a[1])[0];
    if (maxEntry && maxEntry[1] > bestCount) {
      bestCount = maxEntry[1];
      bestContainer = cand;
    }
  }

  return bestContainer;
}

function analyzeURLPatterns($, $section) {
  const links = [];
  $section.find('a[href]').each((_, el) => {
    const href = $(el).attr('href');
    if (href && href !== '#' && href !== 'javascript:void(0)' && href !== 'javascript:;') {
      links.push(href);
    }
  });

  if (links.length === 0) return { score: 0, type: null, matchRatio: 0 };

  let bestType = null;
  let bestRatio = 0;

  for (const [type, patterns] of Object.entries(URL_PATTERNS)) {
    const matchCount = links.filter(href => patterns.some(p => p.test(href))).length;
    const ratio = matchCount / links.length;
    if (ratio > bestRatio) {
      bestRatio = ratio;
      bestType = type;
    }
  }

  if (!bestType || bestRatio < 0.5) return { score: 0, type: null, matchRatio: 0 };

  const baseScore = bestType === 'FAQList' || bestType === 'downloadList' ? 20 : 25;
  let score = 0;
  if (bestRatio >= 0.8) score = baseScore;
  else if (bestRatio >= 0.5) score = Math.round(baseScore * 0.5);

  return { score, type: bestType, matchRatio: bestRatio };
}

function analyzeContent($, $section) {
  const text = $section.text();
  const results = {};

  for (const h of CONTENT_HEURISTICS) {
    const hit = h.test(text, $section);
    if (hit) {
      if (!results[h.type]) results[h.type] = 0;
      results[h.type] = Math.max(results[h.type], h.score);
    }
  }

  if (Object.keys(results).length === 0) return { score: 0, type: null, evidence: [] };

  const best = Object.entries(results).sort((a, b) => b[1] - a[1])[0];
  return { score: best[1], type: best[0], evidence: Object.keys(results) };
}

function detectSection($, $section, index) {
  const structural = analyzeStructure($, $section);
  const $scoreTarget = structural.repeatingContainerEl
    ? $(structural.repeatingContainerEl)
    : $section;
  const urlAnalysis = analyzeURLPatterns($, $scoreTarget);
  const contentAnalysis = analyzeContent($, $scoreTarget);

  const typeVotes = {};
  if (structural.score > 0 && urlAnalysis.type) {
    typeVotes[urlAnalysis.type] = (typeVotes[urlAnalysis.type] || 0) + urlAnalysis.score;
  }
  if (contentAnalysis.type) {
    typeVotes[contentAnalysis.type] = (typeVotes[contentAnalysis.type] || 0) + contentAnalysis.score;
  }

  let detectedType = null;
  const totalScore = structural.score + urlAnalysis.score + contentAnalysis.score;

  if (Object.keys(typeVotes).length > 0) {
    detectedType = Object.entries(typeVotes).sort((a, b) => b[1] - a[1])[0][0];
  }

  if (structural.score > 0 && !detectedType) {
    const text = $scoreTarget.text().toLowerCase();
    const className = ($scoreTarget.attr('class') || '').toLowerCase();
    const id = ($scoreTarget.attr('id') || '').toLowerCase();
    const combined = text + ' ' + className + ' ' + id;

    if (/product|prod|item|shop|goods|catalog/i.test(combined)) detectedType = 'prodList';
    else if (/article|news|blog|post|press|event/i.test(combined)) detectedType = 'articleList';
    else if (/gallery|photo|album|image/i.test(combined)) detectedType = 'galleryList';
    else if (/video|media|watch/i.test(combined)) detectedType = 'videoList';
    else if (/download|resource|file/i.test(combined)) detectedType = 'downloadList';
    else if (/faq|question|help|support/i.test(combined)) detectedType = 'FAQList';
  }

  const className = ($section.attr('class') || '').toLowerCase();
  const sectionId = ($section.attr('id') || '').toLowerCase();
  const combinedIdClass = className + ' ' + sectionId;
  const STATIC_PATTERNS = [
    /about[-_\s]?us/i, /why[-_\s]?choose/i, /cta[-_\s]?section/i,
    /solution/i, /feature/i, /counter/i, /testimonial/i,
    /hero[-_\s]?banner/i, /footer/i, /header\d*/i, /\bnav\b/i,
    /contact[-_\s]?us/i, /spacer/i, /banner/i,
    /placeholder/i, /onlineservice/i, /quicknav/i, /langbar/i,
    /navbar/i, /navmenu/i, /nav[-_]?bar/i, /blocknavbar/i,
    /navigation/i, /menu/i, /lang[-_]?switch/i, /switch[-_]?lang/i,
    /follow/i, /social/i, /logo/i, /\bform\b/i, /subscribe/i,
    /online[-_]?service/i, /copyright/i,
  ];
  let isStaticOverride = STATIC_PATTERNS.some(p => p.test(combinedIdClass));

  if (isStaticOverride && urlAnalysis.score === 0 && contentAnalysis.score <= 12) {
    detectedType = null;
  }

  const sectionClass = ($section.attr('class') || '');
  const heading = $section.find('h1,h2,h3').first().text().trim().substring(0, 60);
  const desc = heading || sectionId || sectionClass.split(' ')[0] || `Section ${index}`;

  const evidence = [];
  if (structural.score > 0) {
    evidence.push(`结构检测: ${structural.itemCount} 个重复子元素 (${structural.score}/40)`);
  }
  if (urlAnalysis.score > 0) {
    evidence.push(`URL模式: ${(urlAnalysis.matchRatio * 100).toFixed(0)}% 链接匹配 ${urlAnalysis.type} 模式 (${urlAnalysis.score}/25)`);
  }
  if (contentAnalysis.score > 0) {
    evidence.push(`内容启发: 检测到 ${contentAnalysis.evidence.join(', ')} 特征 (${contentAnalysis.score}/20)`);
  }

  if (detectedType === 'prodList' && structural.score > 0) {
    const hasCategory = /categor|classif|分类|group/i.test(combinedIdClass);
    const itemsHaveDistinctLinks = new Set();
    $scoreTarget.find('a[href]').each((_, el) => {
      const href = $(el).attr('href');
      if (href && href !== '#') itemsHaveDistinctLinks.add(href);
    });
    if (hasCategory || (structural.itemCount <= 5 && structural.itemCount >= 3 && itemsHaveDistinctLinks.size >= structural.itemCount * 0.5)) {
      if (hasCategory) detectedType = 'groupProduct';
    }
  }

  const isDynamic = detectedType !== null && (
    (structural.score >= 25 && urlAnalysis.score > 0) ||
    (structural.score >= 25 && contentAnalysis.score >= 15) ||
    (totalScore >= 60 && structural.score >= 25)
  );

  return {
    sectionIndex: index,
    sectionDescription: desc,
    detectedType: isDynamic ? detectedType : null,
    confidence: totalScore / 85,
    scores: {
      structural: structural.score,
      urlPattern: urlAnalysis.score,
      contentHeuristic: contentAnalysis.score,
      total: totalScore,
    },
    evidence,
    itemCount: structural.itemCount,
    isDynamic,
    repeatingContainer: structural.repeatingContainer,
    repeatingItemTag: structural.repeatingItemTag,
  };
}

// ═══════════════════════════════════════════════════════════
//  FTL Synthesis: extract @api block from reference template
// ═══════════════════════════════════════════════════════════

function extractApiBlock(templateContent) {
  const apiOpenMatch = templateContent.match(/\[@api\s[^\]]*\]/s);
  if (!apiOpenMatch) return null;

  const apiTag = apiOpenMatch[0];
  const queryMatch = apiTag.match(/query\s*=\s*'(\{[\s\S]*?\})'\s*\]/);
  const queryStr = queryMatch ? queryMatch[1] : '';

  const initScriptMatch = templateContent.match(/<script>\s*\$\(function\(\)\{[\s\S]*?\}\);\s*<\/script>/);
  const initScript = initScriptMatch ? initScriptMatch[0] : '';

  const rootDataAttrs = extractRootDataAttrs(templateContent);

  return { apiTag, queryStr, initScript, rootDataAttrs };
}

function extractRootDataAttrs(templateContent) {
  const divMatch = templateContent.match(/<div\s[^>]*>/s);
  if (!divMatch) return {};

  const divTag = divMatch[0];
  const attrs = {};

  const simpleAttrRe = /data-(?!default-setting)([\w-]+)="([^"]*)"/g;
  let m;
  while ((m = simpleAttrRe.exec(divTag)) !== null) {
    attrs[`data-${m[1]}`] = m[2];
  }

  const settingIdx = divTag.indexOf('data-default-setting=');
  if (settingIdx !== -1) {
    const valueStart = settingIdx + 'data-default-setting='.length;
    const ch = divTag[valueStart];
    if (ch === '{') {
      let depth = 0;
      let end = valueStart;
      for (let i = valueStart; i < divTag.length; i++) {
        if (divTag[i] === '{') depth++;
        else if (divTag[i] === '}') { depth--; if (depth === 0) { end = i + 1; break; } }
      }
      attrs['data-default-setting'] = divTag.substring(valueStart, end);
    } else if (ch === '"') {
      const closeQuote = divTag.indexOf('"', valueStart + 1);
      if (closeQuote !== -1) attrs['data-default-setting'] = divTag.substring(valueStart + 1, closeQuote);
    }
  }

  return attrs;
}

// ═══════════════════════════════════════════════════════════
//  FTL Synthesis: field mapping config per dynamic type
// ═══════════════════════════════════════════════════════════

const FIELD_MAPPING = {
  prodList: {
    listExpr: 'data.productList.list',
    itemVar: 'product',
    nullCheck: 'data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)',
    fields: {
      img: '${product.photoUrlList[0]!}',
      imgAlt: '${product.prodName!?html}',
      title: '${product.prodName!?html}',
      url: '${product.prodUrl!\'#\'}',
      price: '${product.prodPrice!}',
      desc: '${product.prodBrief!}',
    },
    hiddenInputs: [
      '<input type="hidden" name="totalRow" value="${data.productList.totalRow!\'0\'}">',
      '<input type="hidden" name="pageNumber" value="${data.productList.pageNumber!\'1\'}">',
      '<input type="hidden" name="pageSize" value="${data.productList.pageSize!\'20\'}">',
    ],
  },
  articleList: {
    listExpr: 'data.articleList.list',
    itemVar: 'article',
    nullCheck: 'data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)',
    fields: {
      img: '${article.photoUrlNormal!\'\'}',
      imgAlt: '${article.articleTitle!\'\'}',
      title: '${article.articleTitle!\'\'}',
      url: '${article.articleUrl!\'\'}',
      date: '${article.publishTime!\'\'}',
      desc: '${article.articleSummary!\'\'}',
    },
    hiddenInputs: [
      '<input type="hidden" name="totalRow" value="${data.articleList.totalRow!\'0\'}">',
      '<input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!\'1\'}">',
      '<input type="hidden" name="pageSize" value="${data.articleList.pageSize!\'10\'}">',
    ],
  },
  groupProduct: {
    listExpr: 'data.productGroupList',
    itemVar: 'group',
    nullCheck: 'data?? && data.productGroupList?? && (data.productGroupList?size > 0)',
    fields: {
      img: '${group.groupPhotoUrlList[0]!}',
      imgAlt: '${group.groupName!?html}',
      title: '${group.groupName!?html}',
      url: '${group.groupUrl!\'\'}',
      desc: '',
    },
    hiddenInputs: [],
  },
  galleryList: {
    listExpr: 'data.galleryList.list',
    itemVar: 'gallery',
    nullCheck: 'data?? && data.galleryList?? && data.galleryList.list?? && (data.galleryList.list?size > 0)',
    fields: {
      img: '${gallery.photoUrl!\'\'}',
      imgAlt: '${gallery.galleryTitle!\'\'}',
      title: '${gallery.galleryTitle!\'\'}',
      url: '${gallery.galleryUrl!\'\'}',
    },
    hiddenInputs: [],
  },
  videoList: {
    listExpr: 'data.videoList.list',
    itemVar: 'video',
    nullCheck: 'data?? && data.videoList?? && data.videoList.list?? && (data.videoList.list?size > 0)',
    fields: {
      img: '${video.videoCoverUrl!\'\'}',
      imgAlt: '${video.videoTitle!\'\'}',
      title: '${video.videoTitle!\'\'}',
      url: '${video.videoUrl!\'\'}',
    },
    hiddenInputs: [],
  },
  FAQList: {
    listExpr: 'data.faqList.list',
    itemVar: 'faq',
    nullCheck: 'data?? && data.faqList?? && data.faqList.list?? && (data.faqList.list?size > 0)',
    fields: {
      title: '${faq.faqQuestion!\'\'}',
      desc: '${faq.faqAnswer!\'\'}',
      url: '',
    },
    hiddenInputs: [],
  },
  downloadList: {
    listExpr: 'data.downloadList.list',
    itemVar: 'download',
    nullCheck: 'data?? && data.downloadList?? && data.downloadList.list?? && (data.downloadList.list?size > 0)',
    fields: {
      title: '${download.downloadTitle!\'\'}',
      url: '${download.downloadUrl!\'\'}',
      desc: '${download.downloadBrief!\'\'}',
    },
    hiddenInputs: [],
  },
};

// ═══════════════════════════════════════════════════════════
//  FTL Synthesis: core function
// ═══════════════════════════════════════════════════════════

function synthesizeFtl($, $section, detection, templateData, uuid, blockType) {
  const mapping = FIELD_MAPPING[detection.detectedType];
  if (!mapping) return templateData.content;

  const apiBlock = extractApiBlock(templateData.content);
  if (!apiBlock) return templateData.content;

  const sectionHtml = $.html($section);
  const $local = load(sectionHtml, { decodeEntities: false, xmlMode: false });
  const $body = $local('body');
  const sectionEl = $body.children().first();
  if (!sectionEl || sectionEl.length === 0) return templateData.content;

  const container = findRepeatingContainer($local, sectionEl);
  if (!container) return templateData.content;

  const $container = $local(container);
  const children = $container.children();
  if (children.length < 2) return templateData.content;

  const firstChild = children.first();
  const repeatingTag = firstChild[0].tagName;

  const sameTagChildren = [];
  children.each((_, child) => {
    if (child.tagName === repeatingTag) sameTagChildren.push(child);
  });
  if (sameTagChildren.length < 2) return templateData.content;

  const dynamicItemHtml = applyFieldMapping($local, $local(sameTagChildren[0]), mapping);

  for (let i = sameTagChildren.length - 1; i >= 1; i--) {
    $local(sameTagChildren[i]).remove();
  }

  const listOpen = `[#if ${mapping.nullCheck}]\n[#list ${mapping.listExpr} as ${mapping.itemVar}]`;
  const listClose = `[/#list]\n[#else]\n<div class="no-data">No content available</div>\n[/#if]`;

  $local(sameTagChildren[0]).replaceWith(`\n${listOpen}\n${dynamicItemHtml}\n${listClose}\n`);

  const containerParent = $container.parent();
  const apiOpen = apiBlock.apiTag.replace(/data-block-uuid="[^"]*"/, `data-block-uuid="${uuid}"`);

  const sectionTag = sectionEl[0].tagName;
  const sectionAttrs = sectionEl[0].attribs;
  let attrStr = '';
  for (const [k, v] of Object.entries(sectionAttrs)) {
    attrStr += ` ${k}="${v}"`;
  }

  const sectionInnerHtml = sectionEl.html();
  const containerParentTag = containerParent[0]?.tagName;
  const useContainerParentAsApiScope = containerParentTag && containerParentTag !== sectionTag;

  const initScriptStr = apiBlock.initScript
    ? apiBlock.initScript.replace(/\$\(function/, '\\$(function').replace(/<\/script/g, '<\\/script')
    : '';
  const hiddenInputsStr = mapping.hiddenInputs.length > 0 ? '\n' + mapping.hiddenInputs.join('\n') : '';

  let sectionHtmlFinal;
  if (useContainerParentAsApiScope) {
    const cpOuterHtml = $local.html(containerParent);
    const cpIdx = sectionInnerHtml.indexOf(cpOuterHtml);
    const beforeCp = cpIdx >= 0 ? sectionInnerHtml.substring(0, cpIdx) : '';
    const afterCp = cpIdx >= 0 ? sectionInnerHtml.substring(cpIdx + cpOuterHtml.length) : '';
    sectionHtmlFinal =
      `<${sectionTag}${attrStr}>\n` +
      beforeCp +
      `\n${apiOpen}\n` +
      cpOuterHtml +
      hiddenInputsStr + '\n' +
      (initScriptStr ? initScriptStr + '\n' : '') +
      `[/@api]\n` +
      afterCp +
      `</${sectionTag}>`;
  } else {
    sectionHtmlFinal =
      `<${sectionTag}${attrStr}>\n` +
      `${apiOpen}\n` +
      sectionInnerHtml +
      hiddenInputsStr + '\n' +
      `[/@api]\n` +
      `</${sectionTag}>`;
  }

  sectionHtmlFinal = unescapeFreeMarkerDirectives(sectionHtmlFinal);

  const wrapperDiv = buildWrapperDiv(apiBlock.rootDataAttrs, uuid, blockType);
  return `${wrapperDiv}\n${sectionHtmlFinal}\n</div>`;
}

function buildWrapperDiv(rootDataAttrs, uuid, blockType) {
  const attrs = { ...rootDataAttrs };
  attrs['data-block-uuid'] = uuid;
  if (blockType) attrs['data-block-type'] = blockType;
  if (!attrs['data-gjs-type']) attrs['data-gjs-type'] = 'developer-node-component';

  let attrStr = '';
  for (const [k, v] of Object.entries(attrs)) {
    if (k === 'data-default-setting') {
      attrStr += ` ${k}=${v}`;
    } else {
      attrStr += ` ${k}="${v}"`;
    }
  }
  return `<div class="backstage-blocksEditor-wrap wra block_${uuid}"${attrStr}>`;
}

function unescapeFreeMarkerDirectives(html) {
  return html
    .replace(/&amp;&amp;/g, '&&')
    .replace(/&gt;/g, '>')
    .replace(/&lt;(\/?#)/g, '<$1')
    .replace(/&lt;(\/?@)/g, '<$1');
}

function applyFieldMapping($local, $item, mapping) {
  const innerHtml = $item.html();
  const $frag = load(innerHtml, { decodeEntities: false });
  const $root = $frag.root();

  $root.find('img').each((_, img) => {
    const $img = $frag(img);
    if (mapping.fields.img) {
      $img.attr('src', mapping.fields.img);
    }
    if (mapping.fields.imgAlt) {
      $img.attr('alt', mapping.fields.imgAlt);
    }
  });

  $root.find('a').each((_, a) => {
    const $a = $frag(a);
    const href = $a.attr('href');
    if (href && mapping.fields.url) {
      $a.attr('href', mapping.fields.url);
    }
    if ($a.find('img').length === 0) {
      const text = $a.text().trim();
      if (text && text.length > 0 && text.length < 200) {
        if (mapping.fields.title) {
          $a.html(mapping.fields.title);
        }
      }
    }
    if (mapping.fields.imgAlt && $a.attr('title')) {
      $a.attr('title', mapping.fields.imgAlt);
    }
  });

  const headings = $root.find('h1, h2, h3, h4, h5, h6');
  headings.each((_, h) => {
    const $h = $frag(h);
    if ($h.find('a').length > 0) return;
    if (mapping.fields.title) {
      $h.html(mapping.fields.title);
    }
  });

  $root.find('[class*="name"], [class*="title"]').each((_, el) => {
    const $el = $frag(el);
    const tag = el.tagName?.toLowerCase();
    if (['h1','h2','h3','h4','h5','h6','a','img'].includes(tag)) return;
    if ($el.find('a, img, h1, h2, h3, h4, h5, h6').length > 0) return;
    const text = $el.text().trim();
    if (text && text.length > 0 && mapping.fields.title) {
      $el.html(mapping.fields.title);
    }
  });

  const dateEls = $root.find('[class*="date"], [class*="time"], time');
  dateEls.each((_, el) => {
    const $el = $frag(el);
    if (mapping.fields.date) {
      $el.html(mapping.fields.date);
    }
  });

  const priceEls = $root.find('[class*="price"]');
  priceEls.each((_, el) => {
    const $el = $frag(el);
    if (mapping.fields.price) {
      $el.html(mapping.fields.price);
    }
  });

  const descEls = $root.find('[class*="desc"], [class*="brief"], [class*="summary"]');
  descEls.each((_, el) => {
    const $el = $frag(el);
    if ($el.find('a, img').length > 0) return;
    if (mapping.fields.desc) {
      $el.html(mapping.fields.desc);
    }
  });

  const outerTag = $item[0].tagName;
  const outerAttrs = $item[0].attribs || {};
  let outerAttrStr = '';
  for (const [k, v] of Object.entries(outerAttrs)) {
    outerAttrStr += ` ${k}="${v}"`;
  }

  return `<${outerTag}${outerAttrStr}>${$frag.html()}</${outerTag}>`;
}

// ═══════════════════════════════════════════════════════════
//  PHASE 3: Marker Injection
// ═══════════════════════════════════════════════════════════

function injectMarkers($, $section, detection) {
  const blockType = BLOCK_TYPE_MAP[detection.detectedType];
  if (!blockType) return { success: false, reason: `未知动态类型: ${detection.detectedType}` };

  const templateData = loadTemplate(blockType);
  if (!templateData) return { success: false, reason: `未找到模板: ${blockType}` };

  const uuid = uuidv4().replace(/-/g, '').substring(0, 12);
  const appId = templateData.entry.appId || '';

  const synthesizedFtl = synthesizeFtl($, $section, detection, templateData, uuid, blockType);

  const originalHtml = $.html($section);

  const wrappedHtml =
`<div class="developer-component" data-gjs-type="developer-component">` +
`<div class="backstage-blocksEditor-wrap developer-node-component developer-component-newedit block_${uuid}" ` +
`data-gjs-type="developer-node-component" ` +
`data-block-type="${blockType}" ` +
`data-block-uuid="${uuid}" ` +
`data-new-auto-uuid="${uuid}" ` +
`data-app-id="${appId}" ` +
`data-freemaker-html-available="true">` +
originalHtml +
`</div></div>`;

  $section.replaceWith(wrappedHtml);

  return {
    success: true,
    blockType,
    uuid,
    appId,
    templateFile: templateData.entry.fileName,
    freemakerHtmlLength: synthesizedFtl.length,
    freemakerContent: synthesizedFtl,
  };
}

// ═══════════════════════════════════════════════════════════
//  PHASE 4: Validation
// ═══════════════════════════════════════════════════════════

function validateInjection($, uuid) {
  const checks = [];

  const outerEl = $(`.developer-component`).filter((_, el) => {
    return $(el).find(`[data-block-uuid="${uuid}"]`).length > 0;
  });

  checks.push({
    name: 'DOM层级',
    pass: outerEl.length > 0,
    detail: outerEl.length > 0
      ? 'developer-component > developer-node-component > 原始HTML ✓'
      : '外层包装器未找到',
  });

  const nodeEl = outerEl.find(`[data-block-uuid="${uuid}"]`);
  const hasBlockType = !!nodeEl.attr('data-block-type');
  const hasGjsType = nodeEl.attr('data-gjs-type') === 'developer-node-component';
  const hasAutoUuid = !!nodeEl.attr('data-new-auto-uuid');

  checks.push({
    name: '属性完整性',
    pass: hasBlockType && hasGjsType && hasAutoUuid,
    detail: `block-type:${hasBlockType} gjs-type:${hasGjsType} auto-uuid:${hasAutoUuid}`,
  });

  const hasFmFlag = nodeEl.attr('data-freemaker-html-available') === 'true';
  checks.push({
    name: 'FreeMarker标记',
    pass: hasFmFlag,
    detail: hasFmFlag ? 'freemakerHtml 标记已设置 ✓' : 'freemakerHtml 标记缺失',
  });

  const innerHtml = nodeEl.html() || '';
  const hasOriginalContent = innerHtml.includes('<') && innerHtml.length > 50;
  checks.push({
    name: '原始内容保留',
    pass: hasOriginalContent,
    detail: hasOriginalContent ? `内容完整 (${innerHtml.length} chars) ✓` : '内容丢失或过短',
  });

  return checks;
}

// ═══════════════════════════════════════════════════════════
//  Generate export script (model setup)
// ═══════════════════════════════════════════════════════════

function generateModelSetupScript(injections, dynamicBlockDir) {
  const relDir = path.basename(dynamicBlockDir);
  const scriptLines = [];
  scriptLines.push(`<!-- Dynamic Module Model Setup Script -->`);
  scriptLines.push(`<script>`);
  scriptLines.push(`(function() {`);
  scriptLines.push(`  var TEMPLATE_PATHS = {};`);

  for (const inj of injections) {
    if (!inj.success) continue;
    scriptLines.push(`  TEMPLATE_PATHS["${inj.uuid}"] = "${relDir}/${inj.uuid}.ftl";`);
  }

  scriptLines.push('');
  scriptLines.push(`  window.__DYNAMIC_MODULES__ = {`);
  scriptLines.push(`    templatePaths: TEMPLATE_PATHS,`);
  scriptLines.push(`    modules: [`);

  for (const inj of injections) {
    if (!inj.success) continue;
    scriptLines.push(`      {`);
    scriptLines.push(`        uuid: "${inj.uuid}",`);
    scriptLines.push(`        blockType: "${inj.blockType}",`);
    scriptLines.push(`        appId: "${inj.appId}",`);
    scriptLines.push(`        templateFile: "${inj.templateFile}",`);
    scriptLines.push(`        templatePath: "${relDir}/${inj.uuid}.ftl",`);
    scriptLines.push(`      },`);
  }

  scriptLines.push(`    ],`);
  scriptLines.push(`    inject: async function(editor) {`);
  scriptLines.push(`      if (!editor) return;`);
  scriptLines.push(`      for (var i = 0; i < this.modules.length; i++) {`);
  scriptLines.push(`        var mod = this.modules[i];`);
  scriptLines.push(`        var nodeEls = editor.DomComponents.getWrapper().find('[data-block-uuid="' + mod.uuid + '"]');`);
  scriptLines.push(`        if (nodeEls.length > 0) {`);
  scriptLines.push(`          var resp = await fetch(mod.templatePath);`);
  scriptLines.push(`          var ftlContent = await resp.text();`);
  scriptLines.push(`          var nodeModel = nodeEls[0];`);
  scriptLines.push(`          nodeModel.set('freemakerHtml', ftlContent);`);
  scriptLines.push(`          nodeModel.set('appId', mod.appId);`);
  scriptLines.push(`          nodeModel.set('appIsDev', true);`);
  scriptLines.push(`        }`);
  scriptLines.push(`      }`);
  scriptLines.push(`    }`);
  scriptLines.push(`  };`);
  scriptLines.push(`})();`);
  scriptLines.push(`</script>`);

  return scriptLines.join('\n');
}

// ═══════════════════════════════════════════════════════════
//  Generate separate JSON report
// ═══════════════════════════════════════════════════════════

function generateReport(allDetections, injections, validations, dynamicBlockDir) {
  return {
    timestamp: new Date().toISOString(),
    inputFile,
    outputFile,
    dynamicBlockDir,
    totalSections: allDetections.length,
    dynamicSections: allDetections.filter(d => d.isDynamic).length,
    staticSections: allDetections.filter(d => !d.isDynamic).length,
    detections: allDetections,
    injections: injections.map(inj => {
      const { freemakerContent, ...rest } = inj;
      if (rest.success) {
        rest.ftlOutputPath = path.join(dynamicBlockDir, `${rest.uuid}.ftl`);
      }
      return rest;
    }),
    validations,
  };
}

// ═══════════════════════════════════════════════════════════
//  MAIN
// ═══════════════════════════════════════════════════════════

async function main() {
  console.log('╔════════════════════════════════════════════════════════╗');
  console.log('║  Dynamic Module Converter v1.0                        ║');
  console.log('║  静态 HTML → 动态 FreeMarker 模块自动转换             ║');
  console.log('╚════════════════════════════════════════════════════════╝');
  console.log('');

  if (!fs.existsSync(inputFile)) {
    console.error(`[ERROR] 输入文件不存在: ${inputFile}`);
    process.exit(1);
  }

  console.log(`[INPUT]  ${inputFile}`);
  console.log(`[OUTPUT] ${outputFile}`);
  console.log(`[MODE]   ${AUTO_MODE ? '自动模式' : '交互模式 (使用 --auto 跳过确认)'}`);
  console.log('');

  const html = fs.readFileSync(inputFile, 'utf-8');
  const $ = load(html);

  // ─── Phase 1: Detection (tag-agnostic, bottom-up) ───
  console.log('═══ Phase 1: 动态区域检测 ═══');
  const discoveredBlocks = discoverBlocks($);
  const sections = discoveredBlocks.map((b, i) => ({
    el: b.el,
    $el: b.$el,
    index: i,
  }));

  console.log(`[INFO] 找到 ${sections.length} 个可分析区块\n`);

  const detections = [];
  for (const sec of sections) {
    const detection = detectSection($, sec.$el, sec.index);
    detections.push({ ...detection, el: sec.el, $el: sec.$el });
  }

  // Print detection results
  for (const det of detections) {
    const icon = det.isDynamic ? '🔶' : '⬜';
    const typeLabel = det.detectedType ? (TYPE_LABELS[det.detectedType] || det.detectedType) : '静态';
    const conf = (det.confidence * 100).toFixed(0);
    console.log(`${icon} Section ${det.sectionIndex}: "${det.sectionDescription}"`);
    console.log(`   类型: ${typeLabel} | 得分: ${det.scores.total}/85 | 置信度: ${conf}%`);
    if (det.evidence.length > 0) {
      det.evidence.forEach(e => console.log(`   ├─ ${e}`));
    }
    console.log(`   └─ ${det.isDynamic ? '✅ 标记为动态' : '⬜ 保持静态'}`);
    console.log('');
  }

  const dynamicDetections = detections.filter(d => d.isDynamic);
  console.log(`[RESULT] 共 ${dynamicDetections.length} / ${detections.length} 个区块被识别为动态\n`);

  if (dynamicDetections.length === 0) {
    console.log('[INFO] 未检测到动态区块，输出原始 HTML');
    fs.writeFileSync(outputFile, html, 'utf-8');
    return;
  }

  // ─── Phase 2: In auto mode, accept all detected ───
  if (!AUTO_MODE) {
    console.log('[INFO] 交互模式: 以上检测结果将全部应用（当前版本等同 --auto）');
    console.log('[TIP] 后续版本将支持逐一确认/修改类型/保持静态\n');
  }

  // ─── Phase 3: Marker Injection ───
  console.log('═══ Phase 3: 标记注入 ═══');
  const injections = [];

  for (const det of dynamicDetections.reverse()) {
    console.log(`[INJECT] Section ${det.sectionIndex}: ${det.sectionDescription} → ${BLOCK_TYPE_MAP[det.detectedType]}`);
    const result = injectMarkers($, det.$el, det);
    injections.push(result);

    if (result.success) {
      console.log(`   ✅ UUID: ${result.uuid} | 模板: ${result.templateFile} (${result.freemakerHtmlLength} chars)`);
    } else {
      console.log(`   ❌ 注入失败: ${result.reason}`);
    }
  }

  injections.reverse();
  console.log('');

  // ─── Phase 4: Validation ───
  console.log('═══ Phase 4: 验证 ═══');
  const allValidations = [];

  for (const inj of injections) {
    if (!inj.success) continue;
    const checks = validateInjection($, inj.uuid);
    allValidations.push({ uuid: inj.uuid, blockType: inj.blockType, checks });

    const allPass = checks.every(c => c.pass);
    console.log(`[${allPass ? '✅' : '❌'}] ${inj.blockType} (${inj.uuid})`);
    for (const c of checks) {
      console.log(`   ${c.pass ? '✓' : '✗'} ${c.name}: ${c.detail}`);
    }
  }

  console.log('');

  // ─── Write .ftl files to dynamic_block/ ───
  const outputDir = path.dirname(outputFile);
  const dynamicBlockDir = path.join(outputDir, 'dynamic_block');

  if (fs.existsSync(dynamicBlockDir)) {
    fs.rmSync(dynamicBlockDir, { recursive: true, force: true });
  }
  fs.mkdirSync(dynamicBlockDir, { recursive: true });

  console.log('═══ FTL 文件输出 ═══');
  for (const inj of injections) {
    if (!inj.success || !inj.freemakerContent) continue;
    const ftlPath = path.join(dynamicBlockDir, `${inj.uuid}.ftl`);
    fs.writeFileSync(ftlPath, inj.freemakerContent, 'utf-8');
    console.log(`   📄 ${inj.uuid}.ftl (${inj.freemakerContent.length} chars) → ${ftlPath}`);
  }
  console.log('');

  // ─── Generate model setup script ───
  const modelScript = generateModelSetupScript(injections, dynamicBlockDir);
  const finalHtml = $.html();
  const bodyEnd = finalHtml.lastIndexOf('</body>');
  let outputHtml;
  if (bodyEnd !== -1) {
    outputHtml = finalHtml.substring(0, bodyEnd) + '\n' + modelScript + '\n' + finalHtml.substring(bodyEnd);
  } else {
    outputHtml = finalHtml + '\n' + modelScript;
  }

  // ─── Write output ───
  fs.writeFileSync(outputFile, outputHtml, 'utf-8');
  console.log(`[OUTPUT] 已生成: ${outputFile}`);

  const reportFile = outputFile.replace(/\.html$/, '_report.json');
  const report = generateReport(
    detections.map(d => ({ ...d, el: undefined, $el: undefined })),
    injections,
    allValidations,
    dynamicBlockDir,
  );
  fs.writeFileSync(reportFile, JSON.stringify(report, null, 2), 'utf-8');
  console.log(`[REPORT] 已生成: ${reportFile}`);

  // ─── Summary ───
  const ftlCount = injections.filter(i => i.success && i.freemakerContent).length;
  console.log('\n╔════════════════════════════════════════════════════════╗');
  console.log('║  转换完成                                              ║');
  console.log('╠════════════════════════════════════════════════════════╣');
  console.log(`║  总区块数: ${String(detections.length).padEnd(5)} | 动态: ${String(dynamicDetections.length).padEnd(5)} | 静态: ${String(detections.length - dynamicDetections.length).padEnd(5)} ║`);
  console.log(`║  成功注入: ${String(injections.filter(i => i.success).length).padEnd(5)} | 失败: ${String(injections.filter(i => !i.success).length).padEnd(5)} | FTL文件: ${String(ftlCount).padEnd(5)} ║`);
  console.log(`║  输出目录: dynamic_block/                              ║`);
  console.log('╚════════════════════════════════════════════════════════╝');
}

main().catch(err => {
  console.error('[FATAL]', err);
  process.exit(1);
});
