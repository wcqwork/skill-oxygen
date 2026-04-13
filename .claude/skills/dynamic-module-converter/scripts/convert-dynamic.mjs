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
import http from 'http';
import { fileURLToPath } from 'url';
import inquirer from 'inquirer';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ─── CLI Args ───
const args = process.argv.slice(2);
function getArg(name) {
  const idx = args.indexOf(name);
  return idx !== -1 && args[idx + 1] ? args[idx + 1] : null;
}
const AUTO_MODE = args.includes('--auto');
const RENDER_MODE = args.includes('--render');

if (args.includes('--help') || args.includes('-h')) {
  console.log('Usage: node convert-dynamic.mjs --input <file.html> [--output <file.html>] [--auto] [--render]');
  console.log('  --input        必需，输入的静态 HTML 文件路径');
  console.log('  --output       可选，输出文件路径（默认在同目录生成 dynamic_<原文件名>.html）');
  console.log('  --auto         可选，自动模式，跳过确认');
  console.log('  --render       可选，生成后调用 renderFreemarker API 将动态区块渲染为真实数据');
  console.log('  --api-url      renderFreemarker API 地址 (默认 http://website.leadong.com/phoenix2/composite/render/block/renderFreemarker)');
  console.log('  --token        API Authorization Token');
  console.log('  --cookie       API Cookie');
  console.log('  --page-id      pageId (默认 ibpAZjVlKsaE)');
  console.log('  --relation-id  relationId (默认 ibpAZjVlKsaE)');
  console.log('  --relation-type relationType (默认 5)');
  process.exit(0);
}

const RENDER_CONFIG = {
  apiUrl: getArg('--api-url') || 'http://website.leadong.com/phoenix2/composite/render/block/renderFreemarker',
  token: getArg('--token') || '',
  cookie: getArg('--cookie') || '',
  pageId: getArg('--page-id') || 'ibpAZjVlKsaE',
  relationId: getArg('--relation-id') || 'ibpAZjVlKsaE',
  relationType: getArg('--relation-type') || '5',
};

const inputArg = getArg('--input');
if (!inputArg) {
  console.error('[ERROR] 缺少必需参数 --input');
  console.error('Usage: node convert-dynamic.mjs --input <file.html> [--output <file.html>] [--auto]');
  process.exit(1);
}
const inputFile = path.resolve(inputArg);

function getTimestamp() {
  const d = new Date();
  const pad = n => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}_${pad(d.getHours())}-${pad(d.getMinutes())}-${pad(d.getSeconds())}`;
}

function findSrcDir(from) {
  let dir = path.resolve(from);
  while (dir !== path.dirname(dir)) {
    if (path.basename(dir) === 'src') return dir;
    dir = path.dirname(dir);
  }
  return path.resolve(path.dirname(from), '..');
}
const srcDir = findSrcDir(path.dirname(inputFile));
const generateDir = path.join(srcDir, 'Generate', getTimestamp());
const outputFile = getArg('--output')
  ? path.resolve(getArg('--output'))
  : path.join(generateDir, 'pages', 'dynamic_' + path.basename(inputFile));

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

// ═══════════════════════════════════════════════════════════
//  Module B: Intelligent Template Selection
// ═══════════════════════════════════════════════════════════

function loadAllTemplates(blockType) {
  const entries = registry.filter(r => r.blockType === blockType && r.status === 'ok');
  const results = [];
  for (const entry of entries) {
    try {
      const content = fs.readFileSync(path.join(TEMPLATES_DIR, entry.fileName), 'utf-8');
      results.push({ content, entry });
    } catch { /* skip */ }
  }
  return results;
}

/**
 * Extract tag skeleton from a DOM element (ignoring class names).
 * Returns an array of paths like ["div>a>img", "div>div>h3>a", "div>span"]
 */
function extractTagSkeleton($, el, prefix, paths, maxDepth) {
  if (!el || !el.tagName) return;
  if ((maxDepth || 0) > 10) return;
  const tag = el.tagName.toLowerCase();
  if (EXCLUDED_TAGS.has(tag)) return;
  const currentPath = prefix ? `${prefix}>${tag}` : tag;
  const children = $(el).children();
  if (children.length === 0) {
    paths.push(currentPath);
  } else {
    children.each((_, child) => {
      extractTagSkeleton($, child, currentPath, paths, (maxDepth || 0) + 1);
    });
  }
}

/**
 * Extract list item DOM from a FTL template's [#list] loop body.
 */
function extractTemplateListItem(templateContent) {
  // Try to extract the first list item from [#list]...[/#list]
  const simpleMatch = templateContent.match(/\[#list\s+\S+\s+as\s+\w+\]\s*\n?([\s\S]*?)\[\/#list\]/);
  if (!simpleMatch || !simpleMatch[1]) return null;
  const rawContent = simpleMatch[1].trim();
  if (!rawContent) return null;

  // Find the top-level [#else] (not nested inside [#if]...[/#if])
  const topLevelElseIdx = findTopLevelElse(rawContent);
  const itemBlock = topLevelElseIdx !== -1 ? rawContent.substring(0, topLevelElseIdx).trim() : rawContent;
  if (!itemBlock) return null;

  // Find the first opening HTML tag — that's the list item wrapper
  const tagMatch = itemBlock.match(/<(\w+)[\s>]/);
  if (!tagMatch) return null;
  const tag = tagMatch[1];

  // Use balanced tag matching to find the correct closing tag
  const openIdx = itemBlock.indexOf(tagMatch[0]);
  const closeTag = `</${tag}>`;
  const itemHtml = extractBalancedTag(itemBlock, openIdx, tag);
  return itemHtml || itemBlock.substring(openIdx);
}

/**
 * Find a top-level [#else] that is NOT nested inside [#if]...[/#if].
 */
function findTopLevelElse(content) {
  let depth = 0;
  let i = 0;
  while (i < content.length) {
    if (content.startsWith('[#if', i) || content.startsWith('[#if ', i)) {
      depth++;
      i += 4;
    } else if (content.startsWith('[/#if]', i)) {
      depth--;
      i += 6;
    } else if (content.startsWith('[#else]', i) && depth === 0) {
      return i;
    } else {
      i++;
    }
  }
  return -1;
}

/**
 * Extract a balanced HTML tag starting at openIdx.
 * Handles nested tags of the same name correctly.
 */
function extractBalancedTag(html, openIdx, tagName) {
  const openRe = new RegExp(`<${tagName}[\\s>]`, 'gi');
  const closeRe = new RegExp(`</${tagName}>`, 'gi');
  let depth = 0;
  let i = openIdx;

  // Skip past the opening tag
  openRe.lastIndex = i;
  const firstOpen = openRe.exec(html);
  if (!firstOpen || firstOpen.index !== openIdx) return null;
  depth = 1;
  i = firstOpen.index + firstOpen[0].length;

  while (i < html.length && depth > 0) {
    openRe.lastIndex = i;
    closeRe.lastIndex = i;
    const nextOpen = openRe.exec(html);
    const nextClose = closeRe.exec(html);

    if (!nextClose) return null; // unbalanced

    if (nextOpen && nextOpen.index < nextClose.index) {
      depth++;
      i = nextOpen.index + nextOpen[0].length;
    } else {
      depth--;
      if (depth === 0) {
        return html.substring(openIdx, nextClose.index + nextClose[0].length);
      }
      i = nextClose.index + nextClose[0].length;
    }
  }
  return null;
}

/**
 * Compute structural similarity between two tag skeleton arrays.
 * Returns a score between 0 and 1.
 */
function computeStructuralSimilarity(skeletonA, skeletonB) {
  if (skeletonA.length === 0 && skeletonB.length === 0) return 1;
  if (skeletonA.length === 0 || skeletonB.length === 0) return 0;

  // Normalize paths: strip prefixes to just keep depth + tag sequence
  function normalizePath(p) {
    return p.split('>').map(s => s.trim()).join('>');
  }
  const setA = new Set(skeletonA.map(normalizePath));
  const setB = new Set(skeletonB.map(normalizePath));

  // Jaccard similarity
  let intersection = 0;
  for (const p of setA) {
    if (setB.has(p)) intersection++;
  }
  const union = new Set([...setA, ...setB]).size;
  const jaccard = union > 0 ? intersection / union : 0;

  // Also compare depth distribution similarity
  function depthHist(skeleton) {
    const hist = {};
    for (const p of skeleton) {
      const d = p.split('>').length;
      hist[d] = (hist[d] || 0) + 1;
    }
    return hist;
  }
  const histA = depthHist(skeletonA);
  const histB = depthHist(skeletonB);
  const allDepths = new Set([...Object.keys(histA), ...Object.keys(histB)]);
  let depthSim = 0;
  let depthTotal = 0;
  for (const d of allDepths) {
    const a = histA[d] || 0;
    const b = histB[d] || 0;
    depthSim += Math.min(a, b);
    depthTotal += Math.max(a, b);
  }
  const depthScore = depthTotal > 0 ? depthSim / depthTotal : 0;

  return jaccard * 0.7 + depthScore * 0.3;
}

/**
 * Select the best matching template for the given original HTML section.
 * Falls back to loadTemplate() if no good match found.
 */
function selectBestTemplate($, $section, blockType, detection) {
  const allTemplates = loadAllTemplates(blockType);
  if (allTemplates.length === 0) return null;
  if (allTemplates.length === 1) return allTemplates[0];

  // Extract original HTML list item skeleton
  const container = findRepeatingContainer($, $section);
  if (!container) return allTemplates[0];

  const children = $(container).children();
  if (children.length < 1) return allTemplates[0];

  const firstChild = children.first()[0];
  const origPaths = [];
  extractTagSkeleton($, firstChild, '', origPaths);

  // Also collect original HTML class names for bonus matching
  const origClasses = [];
  $section.find('*').each((_, el) => {
    const cls = el.attribs?.class;
    if (cls) origClasses.push(cls);
  });
  const origClassStr = origClasses.join(' ').toLowerCase();

  let bestTemplate = allTemplates[0];
  let bestScore = -1;

  for (const tmpl of allTemplates) {
    const listItemHtml = extractTemplateListItem(tmpl.content);
    if (!listItemHtml) continue;

    // Parse template list item and extract skeleton
    const $tmpl = load(listItemHtml, { decodeEntities: false, xmlMode: false });
    const tmplRoot = $tmpl('body').children().first()[0];
    if (!tmplRoot) continue;

    const tmplPaths = [];
    extractTagSkeleton($tmpl, tmplRoot, '', tmplPaths);

    let score = computeStructuralSimilarity(origPaths, tmplPaths);

    // Bonus: class name matches from template
    const tmplClasses = [];
    $tmpl('*').each((_, el) => {
      const cls = el.attribs?.class;
      if (cls) tmplClasses.push(cls);
    });
    const tmplClassStr = tmplClasses.join(' ').toLowerCase();

    // Check for shared significant class fragments
    const tmplClassTokens = tmplClassStr.split(/\s+/).filter(c => c.length > 4);
    let classHits = 0;
    for (const token of tmplClassTokens) {
      if (origClassStr.includes(token)) classHits++;
    }
    if (tmplClassTokens.length > 0) {
      score += (classHits / tmplClassTokens.length) * 0.3;
    }

    if (score > bestScore) {
      bestScore = score;
      bestTemplate = tmpl;
    }
  }

  console.log(`   [模板选择] 从 ${allTemplates.length} 个候选中选择 ${bestTemplate.entry.fileName} (相似度: ${bestScore.toFixed(3)})`);
  return bestTemplate;
}

// ═══════════════════════════════════════════════════════════
//  Module A: Structure-Aligned Field Mapping
// ═══════════════════════════════════════════════════════════

/**
 * Extract a variable table from a template list item HTML.
 * Each entry: { tagPath, attr, variable, tagName }
 *   tagPath: simplified path like "div>a>img"
 *   attr: "src", "href", "text", "alt", "title"
 *   variable: the FreeMarker expression like "${product.prodName!?html}"
 */
function extractVariableTable(templateListItemHtml) {
  const variables = [];
  const fmVarRe = /\$\{[^}]+\}/g;

  const $ = load(templateListItemHtml, { decodeEntities: false, xmlMode: false });

  function getTagPath(el) {
    const parts = [];
    let cur = el;
    while (cur && cur.tagName) {
      parts.unshift(cur.tagName.toLowerCase());
      cur = cur.parent;
      if (cur && (cur.tagName === 'body' || cur.tagName === 'html' || cur.tagName === '[document]')) break;
    }
    return parts.join('>');
  }

  // Scan all elements for FreeMarker variables in attributes and text
  $('*').each((_, el) => {
    const tagPath = getTagPath(el);
    const tag = el.tagName?.toLowerCase();
    if (!tag) return;

    // Check attributes
    for (const [attr, val] of Object.entries(el.attribs || {})) {
      if (typeof val === 'string' && fmVarRe.test(val)) {
        fmVarRe.lastIndex = 0;
        let m;
        while ((m = fmVarRe.exec(val)) !== null) {
          // Classify the variable semantically
          const varName = m[0];
          const semantic = classifyVariable(varName);
          variables.push({ tagPath, attr, variable: varName, tagName: tag, semantic });
        }
        fmVarRe.lastIndex = 0;
      }
    }

    // Check direct text content (not children's text)
    const directText = $(el).contents().filter((_, node) => node.type === 'text').text().trim();
    if (directText && fmVarRe.test(directText)) {
      fmVarRe.lastIndex = 0;
      let m;
      while ((m = fmVarRe.exec(directText)) !== null) {
        const varName = m[0];
        const semantic = classifyVariable(varName);
        variables.push({ tagPath, attr: 'text', variable: varName, tagName: tag, semantic });
      }
      fmVarRe.lastIndex = 0;
    }
  });

  return variables;
}

/**
 * Classify a FreeMarker variable by its semantic role.
 */
function classifyVariable(varExpr) {
  const lower = varExpr.toLowerCase();
  if (/photourllist|photourlnormal|photo.*url/i.test(lower)) return 'img';
  if (/photoalt|photo.*alt/i.test(lower)) return 'imgAlt';
  if (/phototitle|photo.*title/i.test(lower)) return 'imgTitle';
  if (/produrl|articleurl|groupurl|prod_url|article_url/i.test(lower)) return 'url';
  if (/prodname|articleTitle|groupname/i.test(lower)) return 'title';
  if (/prodprice|shopprodprice|proddiscountprice|prodmaxprice|prodminprice/i.test(lower)) return 'price';
  if (/prodbri|articlesummary|articlebrief/i.test(lower)) return 'desc';
  if (/publishtime|createtime|updatetime/i.test(lower)) return 'date';
  if (/catename|cateurl/i.test(lower)) return 'category';
  if (/coinsymbol|currency/i.test(lower)) return 'currency';
  return 'other';
}

/**
 * Build a simplified tag path for a DOM element (class-agnostic).
 */
function buildTagPath($, el) {
  const parts = [];
  let cur = el;
  while (cur && cur.tagName) {
    const tag = cur.tagName.toLowerCase();
    if (tag === 'body' || tag === 'html' || tag === '[document]') break;
    parts.unshift(tag);
    cur = cur.parent;
  }
  return parts.join('>');
}

/**
 * Structure-aligned field mapping: align template variable positions
 * to original HTML DOM positions and replace values.
 *
 * Strategy priority:
 *   1. Exact tag path match
 *   2. Fuzzy tag path match (same tag sequence, depth differs by 1-2)
 *   3. Semantic fallback (attribute value characteristics)
 *   4. Legacy FIELD_MAPPING fallback
 */
function alignAndMapFields($local, $item, variableTable, detectedType) {
  if (!variableTable || variableTable.length === 0) {
    // Fallback to legacy mapping
    const mapping = FIELD_MAPPING[detectedType];
    if (mapping) return applyFieldMapping($local, $item, mapping);
    return $local.html($item);
  }

  // Build index of all elements in original HTML item
  const origElements = [];
  $item.find('*').each((_, el) => {
    origElements.push({
      el,
      tagPath: buildTagPath($local, el),
      tagName: el.tagName?.toLowerCase(),
    });
  });
  // Also include the item root itself
  origElements.unshift({
    el: $item[0],
    tagPath: buildTagPath($local, $item[0]),
    tagName: $item[0].tagName?.toLowerCase(),
  });

  const applied = new Set();

  // Pass 1: Exact tag path match
  for (const v of variableTable) {
    if (applied.has(v)) continue;
    const match = origElements.find(oe => oe.tagPath === v.tagPath && oe.tagName === v.tagName);
    if (match) {
      if (applyVariable($local, match.el, v)) applied.add(v);
    }
  }

  // Pass 2: Fuzzy path match — same leaf tags, depth difference ≤ 2
  const HEADING_TAGS = new Set(['h1','h2','h3','h4','h5','h6']);
  function tagsEquivalent(a, b) {
    if (a === b) return true;
    // Treat all heading levels as equivalent
    if (HEADING_TAGS.has(a) && HEADING_TAGS.has(b)) return true;
    return false;
  }

  for (const v of variableTable) {
    if (applied.has(v)) continue;
    const vParts = v.tagPath.split('>');
    const vLeaf = vParts[vParts.length - 1];
    const candidates = origElements.filter(oe => {
      const oParts = oe.tagPath.split('>');
      const oLeaf = oParts[oParts.length - 1];
      if (!tagsEquivalent(oLeaf, vLeaf)) return false;
      if (Math.abs(oParts.length - vParts.length) > 2) return false;
      // Check at least 50% tags in common from the tail (with heading equivalence)
      const minLen = Math.min(oParts.length, vParts.length);
      let commonTail = 0;
      for (let i = 1; i <= minLen; i++) {
        if (tagsEquivalent(oParts[oParts.length - i], vParts[vParts.length - i])) commonTail++;
        else break;
      }
      return commonTail >= Math.ceil(minLen * 0.5);
    });
    if (candidates.length > 0) {
      // Pick candidate with closest depth
      candidates.sort((a, b) => {
        const da = Math.abs(a.tagPath.split('>').length - vParts.length);
        const db = Math.abs(b.tagPath.split('>').length - vParts.length);
        return da - db;
      });
      if (applyVariable($local, candidates[0].el, v)) applied.add(v);
    }
  }

  // Pass 3: Semantic fallback — match by attribute value characteristics
  for (const v of variableTable) {
    if (applied.has(v)) continue;
    if (v.semantic === 'other') continue;

    const match = findBySemantic($local, $item, origElements, v);
    if (match) {
      if (applyVariable($local, match.el, v)) applied.add(v);
    }
  }

  // Report coverage
  const total = variableTable.filter(v => v.semantic !== 'other' && v.semantic !== 'currency').length;
  const mapped = [...applied].filter(v => v.semantic !== 'other' && v.semantic !== 'currency').length;
  if (total > 0) {
    console.log(`   [字段映射] 覆盖率: ${mapped}/${total} (${(mapped/total*100).toFixed(0)}%)`);
  }

  // Reconstruct outer tag
  const outerTag = $item[0].tagName;
  const outerAttrs = $item[0].attribs || {};
  let outerAttrStr = '';
  for (const [k, val] of Object.entries(outerAttrs)) {
    outerAttrStr += ` ${k}="${val}"`;
  }
  return `<${outerTag}${outerAttrStr}>${$item.html()}</${outerTag}>`;
}

/**
 * Apply a FreeMarker variable to a DOM element at the specified attribute.
 */
function applyVariable($, el, v) {
  const $el = $(el);
  if (v.attr === 'text') {
    const elTag = el.tagName?.toLowerCase();
    const isLeafLike = $el.children().length === 0 || (elTag === 'a' && $el.find('img').length === 0);
    const isAllowedTag = elTag === 'a' || ['h1','h2','h3','h4','h5','h6','p','span','div','time','li'].includes(elTag);
    // Skip if has complex children (images, links, headings) unless it's a leaf-like element
    if (!isLeafLike && !isAllowedTag) return false;
    if ($el.find('a, img').length > 0 && elTag !== 'a') {
      // Has links or images inside — skip text replacement to avoid destroying structure
      return false;
    }
    const currentText = $el.text().trim();
    if (!currentText && $el.children().length > 0) return false;
    $el.html(v.variable);
    return true;
  } else if (v.attr === 'src' || v.attr === 'href' || v.attr === 'alt' || v.attr === 'title' || v.attr === 'srcset' || v.attr === 'data-srcset') {
    if ($el.attr(v.attr) !== undefined || v.attr === 'alt' || v.attr === 'title') {
      $el.attr(v.attr, v.variable);
      return true;
    }
  }
  return false;
}

/**
 * Find an element by semantic role when path matching fails.
 */
function findBySemantic($, $item, origElements, v) {
  switch (v.semantic) {
    case 'img': {
      // Find img elements with src containing http
      const imgs = origElements.filter(oe => oe.tagName === 'img');
      if (imgs.length > 0 && v.attr === 'src') return imgs[0];
      return null;
    }
    case 'imgAlt': {
      const imgs = origElements.filter(oe => oe.tagName === 'img');
      if (imgs.length > 0 && v.attr === 'alt') return imgs[0];
      return null;
    }
    case 'imgTitle': {
      const imgs = origElements.filter(oe => oe.tagName === 'img');
      if (imgs.length > 0 && v.attr === 'title') return imgs[0];
      return null;
    }
    case 'url': {
      if (v.attr !== 'href') return null;
      const links = origElements.filter(oe => oe.tagName === 'a' && $(oe.el).attr('href'));
      // Match by position: if the variable's template path includes 'img', find link wrapping img
      if (v.tagPath.includes('img') || (v.tagPath.split('>').length <= 3)) {
        const imgLink = links.find(l => $(l.el).find('img').length > 0);
        if (imgLink) return imgLink;
      }
      if (links.length > 0) return links[0];
      return null;
    }
    case 'title': {
      // Find heading or link with text
      const headings = origElements.filter(oe => ['h1','h2','h3','h4','h5','h6'].includes(oe.tagName));
      if (headings.length > 0) {
        if (v.attr === 'text') return headings[0];
        // Check for link inside heading
        const hLink = origElements.find(oe => oe.tagName === 'a' && headings.some(h => $(h.el).find('a').length > 0) && oe.tagPath.includes(headings[0].tagPath));
        if (hLink && v.attr === 'text') return hLink;
      }
      return null;
    }
    case 'price': {
      // Find element containing price-like text
      const priceEl = origElements.find(oe => {
        const text = $(oe.el).text().trim();
        return /[\$€¥£₹]\s*\d|^\d+\.\d{2}$/.test(text);
      });
      return priceEl || null;
    }
    case 'date': {
      const dateEl = origElements.find(oe => {
        return oe.tagName === 'time' || /date|time|artime/i.test($(oe.el).attr('class') || '');
      });
      return dateEl || null;
    }
    case 'desc': {
      // Find paragraph-like element with substantial text
      const descEl = origElements.find(oe => {
        if (!['p', 'div', 'span'].includes(oe.tagName)) return false;
        const text = $(oe.el).text().trim();
        const cls = ($(oe.el).attr('class') || '').toLowerCase();
        return (text.length > 20 && text.length < 500) || /desc|brief|summary|excerpt/i.test(cls);
      });
      return descEl || null;
    }
    default:
      return null;
  }
}

// ─── Detection Configuration ───
const URL_PATTERNS = {
  prodList:     [/\/product\b/i, /\/p\//i, /\/item\b/i, /\/shop\b/i, /\/goods\b/i, /\/catalog\b/i, /\/products\b/i],
  articleList:  [/\/blog\b/i, /\/news\b/i, /\/article\b/i, /\/post\b/i, /\/press\b/i, /\/events?\b/i, /\/case\b/i],
  galleryList:  [/\/gallery\b/i, /\/photo\b/i, /\/album\b/i, /\/image\b/i, /\/portfolio\b/i, /\/works\b/i],
  FAQList:      [/\/faq\b/i, /\/help\b/i, /\/support\b/i, /\/question\b/i],
  videoList:    [/youtube\.com/i, /vimeo\.com/i, /\/video\b/i, /youtu\.be/i],
  downloadList: [/\/download\b/i, /\/resource\b/i, /\/file\b/i, /\/docs\b/i, /\/resources\b/i],
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

const CLASS_SIGNATURES = {
  prodList: [
    /proshow-scroll-item/i, /proshow-custom-item/i, /proshow-image/i,
    /proshow-caption/i, /proshow-title/i, /prodlist-discountprice/i,
    /\bproList\b/, /proshow-container/i, /\bstar-goods\b/i,
    /prodlist-box/i, /prodlist-inner/i,
  ],
  articleList: [
    /ArticlePicList_Item/i, /Article_Container/i, /articalWrap/i,
    /articleList-summary/i, /\bartime\b/i, /headlines-content-img/i,
    /\bArtitem\b/i,
  ],
  groupProduct: [
    /prodCategoty-container/i, /site-category-list/i, /\bcategory-item\b/i,
    /goodsCate-list/i, /\br-tabs-nav\b/i, /\br-tabs-tab\b/i,
    /prodTabList/i, /sitewidget-prodCatalog/i,
  ],
  prodDetail: [
    /prodDetail_component/i, /blockDetail_container/i,
    /lead_prodimg_container/i, /\blead_slick\b/i,
  ],
  videoList: [
    /video-list/i, /\bvideoList\b/i, /video-grid/i, /video-card/i,
  ],
  galleryList: [
    /gallery-list/i, /\bgalleryList\b/i, /gallery-grid/i, /\blightbox\b/i,
  ],
  downloadList: [
    /download-list/i, /\bdownloadList\b/i, /download-item/i,
  ],
  FAQList: [
    /faq-list/i, /\bfaqList\b/i, /faq-item/i, /\baccordion\b/i,
  ],
};

function analyzeClassSignatures($, $section) {
  const allClasses = [];
  $section.find('*').each((_, el) => {
    const cls = el.attribs?.class;
    if (cls) allClasses.push(cls);
  });
  const joined = allClasses.join(' ');

  let bestType = null;
  let bestScore = 0;

  for (const [type, patterns] of Object.entries(CLASS_SIGNATURES)) {
    const hitCount = patterns.filter(p => p.test(joined)).length;
    let score = 0;
    if (hitCount >= 2) score = 25;
    else if (hitCount >= 1) score = 15;
    if (score > bestScore) {
      bestScore = score;
      bestType = type;
    }
  }

  return { score: bestScore, type: bestType };
}

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

  const MODIFIER_PATTERNS = [
    /\bfirst\b/, /\blast\b/, /\bactive\b/, /\bcurrent\b/, /\beven\b/, /\bodd\b/,
    /\bpost-\d+\b/, /\bstatus-\w+\b/, /\binstock\b/, /\boutofstock\b/,
    /\btype-\w+\b/, /\bdata-loop-\d+\b/,
    /\bproduct_cat-[\w-]+\b/, /\bproduct_tag-[\w-]+\b/,
    /\bcategory-[\w-]+\b/, /\btag-[\w-]+\b/,
    /\bcol-\w+-\d+\b/, /\bcol-\d+\b/,
  ];
  function coreClasses(cls) {
    return cls.split(/\s+/).filter(c => c && !MODIFIER_PATTERNS.some(p => p.test(c))).sort().join(' ');
  }
  const uniqueBase = new Set(classNames.map(c => coreClasses(c)));
  if (uniqueBase.size > Math.ceil(children.length * 0.5)) return false;

  const arr = children.toArray();
  const avgDepth = arr.reduce((sum, c) => sum + $(c).find('*').length, 0) / arr.length;

  if (avgDepth < 2) {
    return false;
  }

  if (avgDepth < 3) {
    const hasRichContent = arr.some(c => {
      const $c = $(c);
      return $c.find('img').length > 0 && $c.find('h1,h2,h3,h4,h5,h6,p,span').length > 0;
    });
    if (!hasRichContent) return false;
  }

  return true;
}

function discoverBlocks($) {
  const repeatingContainers = [];

  const SCAN_SKIP_TAGS = new Set(['body', 'html']);
  const SKIP_ANCESTOR_TAGS = new Set(['header', 'nav', 'footer']);

  function isInsideSkipAncestor($, el) {
    let cur = el;
    while (cur && cur.parent) {
      cur = cur.parent;
      if (cur.tagName && SKIP_ANCESTOR_TAGS.has(cur.tagName.toLowerCase())) return true;
      if (cur.tagName === 'body' || cur.tagName === 'html') break;
    }
    return false;
  }

  function scanForRepeats(el, depth) {
    if (depth > 15) return;
    const tag = el.tagName?.toLowerCase();
    if (!tag || EXCLUDED_TAGS.has(tag)) return;
    if (SKIP_ANCESTOR_TAGS.has(tag)) {
      return;
    }
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
  const classSignature = analyzeClassSignatures($, $scoreTarget);

  const typeVotes = {};
  if (structural.score > 0 && urlAnalysis.type) {
    typeVotes[urlAnalysis.type] = (typeVotes[urlAnalysis.type] || 0) + urlAnalysis.score;
  }
  if (contentAnalysis.type) {
    typeVotes[contentAnalysis.type] = (typeVotes[contentAnalysis.type] || 0) + contentAnalysis.score;
  }
  if (classSignature.type) {
    typeVotes[classSignature.type] = (typeVotes[classSignature.type] || 0) + classSignature.score;
  }

  let detectedType = null;
  const totalScore = structural.score + urlAnalysis.score + contentAnalysis.score + classSignature.score;

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

  if (isStaticOverride && urlAnalysis.score === 0 && contentAnalysis.score <= 12 && classSignature.score === 0) {
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
  if (classSignature.score > 0) {
    evidence.push(`类名签名: 匹配 ${classSignature.type} 模板特征 (${classSignature.score}/25)`);
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

  if (classSignature.type === 'groupProduct' && detectedType === 'prodList') {
    detectedType = 'groupProduct';
  }

  const isDynamic = detectedType !== null && (
    (structural.score >= 25 && urlAnalysis.score > 0) ||
    (structural.score >= 25 && contentAnalysis.score >= 15) ||
    (structural.score >= 25 && classSignature.score >= 25) ||
    (totalScore >= 60 && structural.score >= 25)
  );

  return {
    sectionIndex: index,
    sectionDescription: desc,
    detectedType: isDynamic ? detectedType : null,
    confidence: totalScore / 110,
    scores: {
      structural: structural.score,
      urlPattern: urlAnalysis.score,
      contentHeuristic: contentAnalysis.score,
      classSignature: classSignature.score,
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

  const outerContainerAttrs = extractOuterContainerAttrs(templateContent);
  const nodeComponentAttrs = extractNodeComponentAttrs(templateContent);
  const nodeComponentStyle = extractNodeComponentStyle(templateContent);
  const langCodeBlock = extractLangCodeBlock(templateContent);

  const listDirective = extractListDirective(templateContent);
  const hiddenInputs = extractHiddenInputs(templateContent);
  const jsonLd = extractJsonLd(templateContent);

  return {
    apiTag, queryStr,
    outerContainerAttrs, nodeComponentAttrs, nodeComponentStyle, langCodeBlock,
    ...listDirective,
    hiddenInputs,
    jsonLd,
  };
}

function extractListDirective(templateContent) {
  const nullCheckMatch = templateContent.match(/\[#if\s+(data\?\?[\s\S]*?)\]\s*\n\s*\[#list/);
  const nullCheck = nullCheckMatch ? nullCheckMatch[1].replace(/\s+/g, ' ').trim() : '';

  const listMatch = templateContent.match(/\[#list\s+(data\.\w+(?:\.\w+)*)\s+as\s+(\w+)\]/);
  const listExpr = listMatch ? listMatch[1] : '';
  const itemVar = listMatch ? listMatch[2] : '';

  const noDataMatch = templateContent.match(/<div\s+class="templist-no-data">[^<]*<\/div>/);
  const noDataHtml = noDataMatch ? noDataMatch[0] : '<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>';

  return { nullCheck, listExpr, itemVar, noDataHtml };
}

function extractHiddenInputs(templateContent) {
  const inputs = [];
  const re = /<input\s+type="hidden"\s+name="(totalRow|pageNumber|pageSize)"[^>]*>/g;
  let m;
  while ((m = re.exec(templateContent)) !== null) {
    inputs.push(m[0].trim());
  }
  return inputs;
}

function extractJsonLd(templateContent) {
  const match = templateContent.match(/<script\s+type="application\/ld\+json">[\s\S]*?<\/script>/);
  if (!match) return '';
  return match[0].replace(/^\s+/gm, '').trim();
}

function extractOuterContainerAttrs(templateContent) {
  const divMatch = templateContent.match(/<div\s[^>]*>/s);
  if (!divMatch) return {};
  const divTag = divMatch[0];
  const attrs = {};
  const re = /([\w-]+)="([^"]*)"/g;
  let m;
  while ((m = re.exec(divTag)) !== null) {
    attrs[m[1]] = m[2];
  }
  return attrs;
}

function extractNodeComponentAttrs(templateContent) {
  const nodeRe = /<div\s[^>]*data-gjs-type="developer-node-component"[^>]*>/s;
  const match = templateContent.match(nodeRe);
  if (!match) {
    const altRe = /<div[^>]*developer-node-component[^>]*>/s;
    const altMatch = templateContent.match(altRe);
    if (!altMatch) return {};
    return parseNodeDivAttrs(altMatch[0]);
  }
  return parseNodeDivAttrs(match[0]);
}

function parseNodeDivAttrs(divTag) {
  const attrs = {};

  const simpleAttrRe = /\b(data-(?!default-setting)[\w-]+)="([^"]*)"/g;
  let m;
  while ((m = simpleAttrRe.exec(divTag)) !== null) {
    attrs[m[1]] = m[2];
  }

  const classMatch = divTag.match(/\bclass="([^"]*)"/);
  if (classMatch) attrs['class'] = classMatch[1];

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

function extractNodeComponentStyle(templateContent) {
  const nodeIdx = templateContent.indexOf('developer-node-component');
  if (nodeIdx === -1) return '';
  const afterNode = templateContent.substring(nodeIdx);
  const styleMatch = afterNode.match(/<style>\s*\[data-new-auto-uuid[^<]*<\/style>/s);
  return styleMatch ? styleMatch[0] : '';
}

function extractLangCodeBlock(templateContent) {
  const langMatch = templateContent.match(/\[#assign\s+specialLanCode[\s\S]*?\[#if[\s\S]*?\[\/#if\]/);
  return langMatch ? langMatch[0] : '';
}

// ═══════════════════════════════════════════════════════════
//  FTL Synthesis: field mapping for HTML variable replacement ONLY
//  All FreeMarker directives (@api, [#list], hiddenInputs, JSON-LD)
//  are extracted from reference templates — never hardcoded here.
// ═══════════════════════════════════════════════════════════

const FIELD_MAPPING = {
  prodList: {
    fields: {
      img: '${product.photoUrlList[0]!}',
      imgAlt: '${product.prodName!?html}',
      title: '${product.prodName!?html}',
      url: '${product.prodUrl!\'#\'}',
      price: '${product.prodPrice!}',
      desc: '${product.prodBrief!}',
    },
  },
  articleList: {
    fields: {
      img: '${article.photoUrlNormal!\'\'}',
      imgAlt: '${article.articleTitle!\'\'}',
      title: '${article.articleTitle!\'\'}',
      url: '${article.articleUrl!\'\'}',
      date: '${article.publishTime!\'\'}',
      desc: '${article.articleSummary!\'\'}',
    },
  },
  groupProduct: {
    fields: {
      img: '${group.groupPhotoUrlList[0]!}',
      imgAlt: '${group.groupName!?html}',
      title: '${group.groupName!?html}',
      url: '${group.groupUrl!\'\'}',
      desc: '',
    },
  },
};

// ═══════════════════════════════════════════════════════════
//  FTL Synthesis: core function
// ═══════════════════════════════════════════════════════════

function synthesizeFtl($, $section, detection, templateData, uuid, blockType) {
  const apiBlock = extractApiBlock(templateData.content);
  if (!apiBlock) return templateData.content;

  if (!apiBlock.nullCheck || !apiBlock.listExpr || !apiBlock.itemVar) {
    console.warn(`[WARN] 参考模板中未找到 [#if]/[#list] 指令，回退为原始模板`);
    return templateData.content;
  }

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

  // Module A: Structure-aligned field mapping
  const templateListItemHtml = extractTemplateListItem(templateData.content);
  let dynamicItemHtml;
  if (templateListItemHtml) {
    const variableTable = extractVariableTable(templateListItemHtml);
    dynamicItemHtml = alignAndMapFields($local, $local(sameTagChildren[0]), variableTable, detection.detectedType);
  } else {
    // Fallback to legacy mapping
    const mapping = FIELD_MAPPING[detection.detectedType];
    dynamicItemHtml = mapping
      ? applyFieldMapping($local, $local(sameTagChildren[0]), mapping)
      : $local.html($local(sameTagChildren[0]));
  }

  for (let i = sameTagChildren.length - 1; i >= 1; i--) {
    $local(sameTagChildren[i]).remove();
  }

  const listOpen = `[#if ${apiBlock.nullCheck}]\n[#list ${apiBlock.listExpr} as ${apiBlock.itemVar}]`;
  const listClose = `[/#list]\n[#else]\n${apiBlock.noDataHtml}\n[/#if]`;

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
  const isBodyOrRoot = !containerParentTag || containerParentTag === 'body' || containerParentTag === 'html' || containerParentTag === '[document]';
  const useContainerParentAsApiScope = !isBodyOrRoot && containerParentTag !== sectionTag;

  const hiddenInputsStr = apiBlock.hiddenInputs.length > 0 ? '\n' + apiBlock.hiddenInputs.join('\n') : '';
  const jsonLdStr = apiBlock.jsonLd ? '\n' + apiBlock.jsonLd : '';

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
      hiddenInputsStr +
      jsonLdStr + '\n' +
      `[/@api]\n` +
      afterCp +
      `</${sectionTag}>`;
  } else {
    sectionHtmlFinal =
      `<${sectionTag}${attrStr}>\n` +
      `${apiOpen}\n` +
      sectionInnerHtml +
      hiddenInputsStr +
      jsonLdStr + '\n' +
      `[/@api]\n` +
      `</${sectionTag}>`;
  }

  sectionHtmlFinal = unescapeFreeMarkerDirectives(sectionHtmlFinal);

  const outerDiv = buildOuterContainer(uuid, apiBlock.outerContainerAttrs);
  const langBlock = apiBlock.langCodeBlock ? `\n    ${apiBlock.langCodeBlock}\n` : '';
  const innerDiv = buildInnerNodeComponent(apiBlock.nodeComponentAttrs, uuid, blockType);
  const nodeStyle = apiBlock.nodeComponentStyle || '';
  const nodeStyleStr = nodeStyle ? `\n        ${nodeStyle}` : '';

  const initScript = buildInitScript(uuid);

  return `${outerDiv}${langBlock}\n    ${innerDiv}${nodeStyleStr}\n${sectionHtmlFinal}\n${initScript}\n    </div>\n</div>`;
}

function buildInitScript(uuid) {
  return `        <script>\n            $(function () {\n                window._block_namespaces_['block_${uuid}'].init({ 'relationId': '\${relationId}', 'relationType': '\${relationType}', 'pageId': '\${pageId}', 'pageNodeId': '\${pageNodeId!""}', 'appId': '\${appId!}', 'appIsDev': '\${appIsDev!"0"}', 'appVersion': '\${appVersion}' });\n            });\n        </script>`;
}

function buildOuterContainer(uuid, outerAttrs) {
  const gjsType = outerAttrs?.['data-gjs-type'] || 'phoenix-container';
  const strong = outerAttrs?.['data-strong'] || '1';
  return `<div class="block_${uuid}" data-gjs-type="${gjsType}" data-strong="${strong}">`;
}

function buildInnerNodeComponent(nodeAttrs, uuid, blockType) {
  const attrs = { ...nodeAttrs };
  attrs['data-block-uuid'] = uuid;
  if (blockType) attrs['data-block-type'] = blockType;
  attrs['data-gjs-type'] = 'developer-node-component';

  let attrStr = '';
  for (const [k, v] of Object.entries(attrs)) {
    if (k === 'class') continue;
    if (k === 'data-default-setting') {
      attrStr += ` ${k}=${v}`;
    } else {
      attrStr += ` ${k}="${v}"`;
    }
  }

  const existingClass = attrs['class'] || '';
  const hasBackstage = existingClass.includes('backstage-blocksEditor-wrap');
  const classStr = hasBackstage ? existingClass : `backstage-blocksEditor-wrap ${existingClass}`.trim();

  return `<div class="${classStr}"${attrStr}>`;
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

  $root.find('[class*="category"], [class*="cate"], [class*="tag"]').each((_, el) => {
    const $el = $frag(el);
    const tag = el.tagName?.toLowerCase();
    if (['a','img'].includes(tag)) return;
    if ($el.find('a, img, h1, h2, h3, h4, h5, h6').length > 0) return;
    const cls = (el.attribs?.class || '').toLowerCase();
    if (/nav|menu|filter/.test(cls)) return;
    const text = $el.text().trim();
    if (text && text.length > 0 && text.length < 100) {
      if (mapping.fields.cateName) {
        $el.html(mapping.fields.cateName);
      } else if (mapping.itemVar === 'article' && mapping.fields.desc) {
        $el.html("${article.cateName!''}");
      }
    }
  });

  const dateEls = $root.find('[class*="date"], [class*="time"], [class*="meta"], time');
  dateEls.each((_, el) => {
    const $el = $frag(el);
    if (mapping.fields.date) {
      const childSpans = $el.children('span');
      if (childSpans.length > 1) {
        const firstSpan = childSpans.first();
        const dateText = firstSpan.text().trim();
        if (dateText && /\d/.test(dateText)) {
          firstSpan.html(mapping.fields.date);
        }
      } else if ($el.children().length === 0) {
        $el.html(mapping.fields.date);
      }
    }
  });

  const priceEls = $root.find('[class*="price"]');
  priceEls.each((_, el) => {
    const $el = $frag(el);
    if (mapping.fields.price) {
      $el.html(mapping.fields.price);
    }
  });

  const descEls = $root.find('[class*="desc"], [class*="brief"], [class*="summary"], [class*="excerpt"]');
  descEls.each((_, el) => {
    const $el = $frag(el);
    if ($el.find('a, img').length > 0) return;
    if (mapping.fields.desc) {
      $el.html(mapping.fields.desc);
    }
  });

  if (mapping.fields.desc) {
    const headingParent = $root.find('h1, h2, h3, h4, h5, h6').first().parent();
    if (headingParent.length) {
      headingParent.children('p').each((_, el) => {
        const $el = $frag(el);
        if ($el.find('a, img').length > 0) return;
        const cls = (el.attribs?.class || '').toLowerCase();
        if (cls && /desc|brief|summary|excerpt/.test(cls)) return;
        const text = $el.text().trim();
        if (text && text.length > 5 && text.length < 500) {
          $el.html(mapping.fields.desc);
        }
      });
    }
  }

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

  // Module B: Intelligent template selection
  const templateData = selectBestTemplate($, $section, blockType, detection);
  if (!templateData) {
    // Fallback to legacy single template loading
    const fallback = loadTemplate(blockType);
    if (!fallback) return { success: false, reason: `未找到模板: ${blockType}` };
    return injectMarkersWithTemplate($, $section, detection, fallback, blockType);
  }

  return injectMarkersWithTemplate($, $section, detection, templateData, blockType);
}

function injectMarkersWithTemplate($, $section, detection, templateData, blockType) {
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

function validateFtlContent(ftlContent, _detectedType) {
  const checks = [];

  checks.push({
    name: 'FTL-@api标签',
    pass: /\[@api\s/.test(ftlContent) && /\[\/@api\]/.test(ftlContent),
    detail: /\[@api\s/.test(ftlContent) && /\[\/@api\]/.test(ftlContent)
      ? '[@api]...[/@api] 完整 ✓'
      : '缺少 @api 开闭标签',
  });

  checks.push({
    name: 'FTL-列表循环',
    pass: /\[#list\s/.test(ftlContent) && /\[\/#list\]/.test(ftlContent),
    detail: /\[#list\s/.test(ftlContent) ? '[#list] 循环存在 ✓' : '缺少 [#list] 循环',
  });

  checks.push({
    name: 'FTL-空数据处理',
    pass: /templist-no-data/.test(ftlContent),
    detail: /templist-no-data/.test(ftlContent) ? 'no-data 处理 ✓' : '缺少 templist-no-data 处理',
  });

  const hasHiddenInputs = /name="totalRow"/.test(ftlContent);
  if (hasHiddenInputs) {
    const apiCloseIdx = ftlContent.lastIndexOf('[/@api]');
    const hiddenIdx = ftlContent.lastIndexOf('name="totalRow"');
    const hiddenBeforeApiClose = apiCloseIdx > 0 && hiddenIdx > 0 && hiddenIdx < apiCloseIdx;
    checks.push({
      name: 'FTL-hiddenInputs位置',
      pass: hiddenBeforeApiClose,
      detail: hiddenBeforeApiClose ? 'hidden inputs 在 [/@api] 内 ✓' : 'hidden inputs 应在 [/@api] 关闭前',
    });
  }

  const hasJsonLd = /application\/ld\+json/.test(ftlContent);
  if (hasJsonLd) {
    checks.push({
      name: 'FTL-JSON-LD',
      pass: true,
      detail: 'JSON-LD 结构化数据 ✓',
    });
  }

  const hasInitScript = /window\._block_namespaces_/.test(ftlContent);
  checks.push({
    name: 'FTL-初始化脚本',
    pass: hasInitScript,
    detail: hasInitScript ? 'block init script ✓' : '缺少 _block_namespaces_ 初始化脚本',
  });

  if (hasInitScript) {
    const apiCloseIdx = ftlContent.lastIndexOf('[/@api]');
    const initIdx = ftlContent.lastIndexOf('_block_namespaces_');
    const initAfterApiClose = apiCloseIdx > 0 && initIdx > 0 && initIdx > apiCloseIdx;
    checks.push({
      name: 'FTL-initScript位置',
      pass: initAfterApiClose,
      detail: initAfterApiClose ? 'init script 在 [/@api] 外部 ✓' : 'init script 应在 [/@api] 关闭后',
    });
  }

  const hasOuterDiv = /class="block_\w+"/.test(ftlContent) && /data-gjs-type="phoenix-container"/.test(ftlContent);
  checks.push({
    name: 'FTL-外层容器',
    pass: hasOuterDiv,
    detail: hasOuterDiv ? 'phoenix-container 外层 ✓' : '缺少 phoenix-container 外层容器',
  });

  const hasInnerDiv = /data-gjs-type="developer-node-component"/.test(ftlContent);
  checks.push({
    name: 'FTL-内层节点组件',
    pass: hasInnerDiv,
    detail: hasInnerDiv ? 'developer-node-component ✓' : '缺少 developer-node-component 内层',
  });

  return checks;
}

// ═══════════════════════════════════════════════════════════
//  Generate export script (model setup)
// ═══════════════════════════════════════════════════════════

function generateModelSetupScript(injections, dynamicBlockDir, outputFile) {
  const outputDir = path.dirname(path.resolve(outputFile));
  const absBlockDir = path.resolve(dynamicBlockDir);
  const relDir = path.relative(outputDir, absBlockDir).replace(/\\/g, '/');
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
//  Generate inline version (FTL embedded in HTML)
// ═══════════════════════════════════════════════════════════

function generateInlineModelSetupScript(injections) {
  const lines = [];
  lines.push(`<!-- Dynamic Module Model Setup Script (Inline) -->`);
  lines.push(`<script>`);
  lines.push(`(function() {`);
  lines.push(`  var FTL_CONTENTS = {};`);

  for (const inj of injections) {
    if (!inj.success || !inj.freemakerContent) continue;
    const escaped = JSON.stringify(inj.freemakerContent).replace(/<\//g, '<\\/');
    lines.push(`  FTL_CONTENTS["${inj.uuid}"] = ${escaped};`);
  }

  lines.push('');
  lines.push(`  window.__DYNAMIC_MODULES__ = {`);
  lines.push(`    ftlContents: FTL_CONTENTS,`);
  lines.push(`    modules: [`);

  for (const inj of injections) {
    if (!inj.success) continue;
    lines.push(`      {`);
    lines.push(`        uuid: "${inj.uuid}",`);
    lines.push(`        blockType: "${inj.blockType}",`);
    lines.push(`        appId: "${inj.appId}",`);
    lines.push(`        templateFile: "${inj.templateFile}",`);
    lines.push(`      },`);
  }

  lines.push(`    ],`);
  lines.push(`    inject: function(editor) {`);
  lines.push(`      if (!editor) return;`);
  lines.push(`      for (var i = 0; i < this.modules.length; i++) {`);
  lines.push(`        var mod = this.modules[i];`);
  lines.push(`        var ftlContent = this.ftlContents[mod.uuid];`);
  lines.push(`        if (!ftlContent) continue;`);
  lines.push(`        var nodeEls = editor.DomComponents.getWrapper().find('[data-block-uuid="' + mod.uuid + '"]');`);
  lines.push(`        if (nodeEls.length > 0) {`);
  lines.push(`          var nodeModel = nodeEls[0];`);
  lines.push(`          nodeModel.set('freemakerHtml', ftlContent);`);
  lines.push(`          nodeModel.set('appId', mod.appId);`);
  lines.push(`          nodeModel.set('appIsDev', true);`);
  lines.push(`        }`);
  lines.push(`      }`);
  lines.push(`    }`);
  lines.push(`  };`);
  lines.push(`})();`);
  lines.push(`</script>`);

  return lines.join('\n');
}

function extractFtlInnerContent(ftlContent, uuid) {
  const marker = `data-block-uuid="${uuid}"`;
  const markerPos = ftlContent.indexOf(marker);
  if (markerPos === -1) return ftlContent;

  const tagEndPos = ftlContent.indexOf('>', markerPos);
  if (tagEndPos === -1) return ftlContent;

  const innerStart = tagEndPos + 1;
  const tagName = findOpeningTag(ftlContent, markerPos);
  const closeIdx = findMatchingCloseTag(ftlContent, innerStart, tagName);
  if (closeIdx === -1) return ftlContent;

  return ftlContent.substring(innerStart, closeIdx);
}

function generateInlineHtml(outputHtml, injections) {
  let html = outputHtml;

  for (const inj of injections) {
    if (!inj.success || !inj.freemakerContent) continue;

    const ftlInner = extractFtlInnerContent(inj.freemakerContent, inj.uuid);

    const uuidAttr = `data-block-uuid="${inj.uuid}"`;
    const nodeStart = html.indexOf(uuidAttr);
    if (nodeStart === -1) continue;

    const tagClose = html.indexOf('>', nodeStart);
    if (tagClose === -1) continue;

    const afterTag = tagClose + 1;
    const tagName = findOpeningTag(html, nodeStart);
    const closeIdx = findMatchingCloseTag(html, afterTag, tagName);
    if (closeIdx === -1) continue;

    html = html.substring(0, afterTag) + ftlInner + html.substring(closeIdx);
  }

  const oldScriptMarker = '<!-- Dynamic Module Model Setup Script -->';
  const oldScriptStart = html.indexOf(oldScriptMarker);
  if (oldScriptStart !== -1) {
    const scriptEndTag = '</script>';
    const scriptEnd = html.indexOf(scriptEndTag, oldScriptStart);
    if (scriptEnd !== -1) {
      const afterScript = scriptEnd + scriptEndTag.length;
      const inlineScript = generateInlineModelSetupScript(injections);
      html = html.substring(0, oldScriptStart) + inlineScript + html.substring(afterScript);
    }
  }

  return html;
}

// ═══════════════════════════════════════════════════════════
//  Phase 5 helpers: API rendering
// ═══════════════════════════════════════════════════════════

function utf8ToBase64(str) {
  return Buffer.from(str, 'utf-8').toString('base64');
}

function base64ToUtf8(b64) {
  return Buffer.from(b64, 'base64').toString('utf-8');
}

async function callRenderFreemarkerApi(ftlContent, config) {
  const freemarkerContent = utf8ToBase64(ftlContent);
  const bodyData = JSON.stringify({
    pageId: config.pageId,
    relationId: config.relationId,
    relationType: config.relationType,
    freemarkerContent,
  });

  const url = new URL(config.apiUrl);
  const options = {
    hostname: url.hostname,
    port: url.port || 80,
    path: url.pathname + url.search,
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(bodyData),
      'Accept': 'application/json',
      'Authorization': config.token,
      'Cookie': config.cookie,
      'p2-module': 'new-editor',
      'Referer': 'http://website.leadong.com/phoenix2/composite/blockEditorUI/index.html',
    },
  };

  return new Promise((resolve, reject) => {
    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          if (json.code !== 200000 && json.code !== 200) {
            reject(new Error(`API code=${json.code}, msg=${json.msg || ''}`));
            return;
          }
          let htmlData = json.data || json.html || json.content || json.result || '';
          if (typeof htmlData === 'string' && htmlData.length > 0) {
            try {
              const decoded = base64ToUtf8(htmlData);
              if (decoded.includes('<') || decoded.includes('&')) htmlData = decoded;
            } catch (_) {}
          }
          resolve(htmlData);
        } catch (e) {
          reject(new Error('JSON parse error: ' + e.message));
        }
      });
    });
    req.on('error', reject);
    req.write(bodyData);
    req.end();
  });
}

function findOpeningTag(html, posInsideTag) {
  let i = posInsideTag;
  while (i > 0 && html[i] !== '<') i--;
  i++;
  let tag = '';
  while (i < html.length && /[a-zA-Z0-9]/.test(html[i])) {
    tag += html[i];
    i++;
  }
  return tag || 'div';
}

function findMatchingCloseTag(html, startPos, tagName) {
  let depth = 1;
  let i = startPos;
  const openRe = new RegExp(`<${tagName}[\\s>/]`, 'gi');
  const closeRe = new RegExp(`</${tagName}>`, 'gi');

  while (i < html.length && depth > 0) {
    openRe.lastIndex = i;
    closeRe.lastIndex = i;
    const openMatch = openRe.exec(html);
    const closeMatch = closeRe.exec(html);
    if (!closeMatch) return -1;
    if (openMatch && openMatch.index < closeMatch.index) {
      depth++;
      i = openMatch.index + openMatch[0].length;
    } else {
      depth--;
      if (depth === 0) return closeMatch.index;
      i = closeMatch.index + closeMatch[0].length;
    }
  }
  return -1;
}

// ═══════════════════════════════════════════════════════════
//  Interactive Block Confirmation (Phase 2)
// ═══════════════════════════════════════════════════════════

const AVAILABLE_TYPES = [
  { value: 'prodList', name: '📦 产品列表 (prodList)' },
  { value: 'groupProduct', name: '🗂️ 产品分类 (groupProduct)' },
  { value: 'articleList', name: '📝 文章列表 (articleList)' },
  { value: 'groupArticle', name: '📑 文章分类 (groupArticle)' },
  { value: 'galleryList', name: '🖼️ 图库列表 (galleryList)' },
  { value: 'videoList', name: '🎬 视频列表 (videoList)' },
  { value: 'downloadList', name: '📥 下载列表 (downloadList)' },
  { value: 'FAQList', name: '❓ FAQ列表 (FAQList)' },
  { value: 'commentList', name: '💬 评价列表 (commentList)' },
];

/**
 * 打印区块摘要卡片
 */
function printBlockCard(det, $) {
  const width = 60;
  const line = '─'.repeat(width - 2);

  console.log('\n' + `┌${line}┐`);

  // 标题行
  const title = `区块 ${det.sectionIndex}: ${det.sectionDescription || '未命名'}`;
  console.log(`│ ${title.padEnd(width - 4)} │`);

  console.log(`├${line}┤`);

  // 检测类型
  const typeLabel = det.detectedType ? (TYPE_LABELS[det.detectedType] || det.detectedType) : '静态';
  const typeIcon = det.isDynamic ? '🔶' : '⬜';
  console.log(`│ ${typeIcon} 检测类型: ${(typeLabel + ' '.repeat(20)).substring(0, 20)} │`);

  // 置信度条
  const conf = Math.round(det.confidence * 100);
  const filledLen = Math.round(conf / 5);
  const barFill = '█'.repeat(filledLen);
  const barEmpty = '░'.repeat(20 - filledLen);
  console.log(`│ 置信度:   [${barFill}${barEmpty}] ${String(conf).padStart(3)}% │`);

  // 评分明细
  const { structural, urlPattern, contentHeuristic, classSignature, total } = det.scores;
  console.log(`│ 评分:     结构(${structural}) + URL(${urlPattern}) + 内容(${contentHeuristic}) + 类名(${classSignature}) = ${total} │`);

  // 重复项数量
  console.log(`│ 重复项:   ${det.itemCount || '?'} 个 ${(det.repeatingItemTag || 'div') + ' '.repeat(20)}.substring(0, 20) │`);

  // 证据
  if (det.evidence && det.evidence.length > 0) {
    console.log(`├${line}┤`);
    console.log(`│ 证据:`.padEnd(width - 1) + '│');
    det.evidence.slice(0, 3).forEach(e => {
      const truncated = e.length > width - 6 ? e.substring(0, width - 9) + '...' : e;
      console.log(`│   • ${(truncated + ' '.repeat(width - 6 - truncated.length)).substring(0, width - 6)} │`);
    });
  }

  console.log(`└${line}┘`);
}

/**
 * 预览区块 HTML (截取前 500 字符)
 */
function getBlockPreview($, $el, maxLength = 800) {
  const html = $el.html() || '';
  if (html.length <= maxLength) return html;
  return html.substring(0, maxLength) + '\n... (已截断)';
}

/**
 * 交互式区块确认
 * @param {Array} detections - 所有检测结果
 * @param {CheerioAPI} $ - cheerio 实例
 * @returns {Promise<Array>} - 用户确认后的检测结果
 */
async function interactiveBlockConfirmation(detections, $) {
  console.log('\n╔════════════════════════════════════════════════════════╗');
  console.log('║  Phase 2: 交互式确认                                    ║');
  console.log('║  逐个确认区块类型，或保持静态                            ║');
  console.log('╚════════════════════════════════════════════════════════╝\n');

  const confirmedDetections = [];
  let currentIndex = 0;

  for (const det of detections) {
    currentIndex++;
    console.log(`\n[ ${currentIndex}/${detections.length} ]`);

    // 打印区块卡片
    printBlockCard(det, $);

    // 构建选项
    const defaultType = det.detectedType || 'static';
    const choices = [
      {
        value: 'confirm',
        name: `✓ 确认: ${det.detectedType ? TYPE_LABELS[det.detectedType] || det.detectedType : '保持静态'}`,
      },
      {
        value: 'dynamic',
        name: '🔶 标记为动态 (修改类型...)',
      },
      {
        value: 'static',
        name: '⬜ 保持静态 (不转换)',
      },
      {
        value: 'preview',
        name: '👁 预览 HTML 片段',
      },
      {
        value: 'details',
        name: '📋 查看完整评分',
      },
    ];

    let decision = null;
    let selectedType = det.detectedType;

    while (decision === null || decision === 'preview' || decision === 'details') {
      const answer = await inquirer.prompt([
        {
          type: 'list',
          name: 'action',
          message: '请选择操作:',
          choices,
          default: 'confirm',
          pageSize: 6,
        },
      ]);

      decision = answer.action;

      if (decision === 'preview') {
        console.log('\n── HTML 预览 ──────────────────────────────────────────');
        const preview = getBlockPreview($, det.$el);
        console.log(preview);
        console.log('───────────────────────────────────────────────────────');
        continue;
      }

      if (decision === 'details') {
        console.log('\n── 完整评分详情 ────────────────────────────────────────');
        console.log(`  结构评分 (structural):     ${det.scores.structural}/40`);
        console.log(`  URL模式 (urlPattern):      ${det.scores.urlPattern}/25`);
        console.log(`  内容启发 (contentHeuristic): ${det.scores.contentHeuristic}/20`);
        console.log(`  类名签名 (classSignature): ${det.scores.classSignature}/25`);
        console.log(`  总分:                      ${det.scores.total}/110`);
        console.log(`  置信度:                    ${(det.confidence * 100).toFixed(1)}%`);
        console.log(`  重复子元素:                ${det.itemCount} 个`);
        console.log(`  重复容器类名:              ${det.repeatingContainer || '未知'}`);
        console.log('───────────────────────────────────────────────────────');
        continue;
      }

      if (decision === 'dynamic') {
        // 选择动态类型
        const typeAnswer = await inquirer.prompt([
          {
            type: 'list',
            name: 'blockType',
            message: '选择动态类型:',
            choices: AVAILABLE_TYPES,
            pageSize: 10,
            default: det.detectedType || 'prodList',
          },
        ]);
        selectedType = typeAnswer.blockType;
        decision = 'dynamic';
      }
    }

    // 应用用户决策
    if (decision === 'static') {
      confirmedDetections.push({
        ...det,
        isDynamic: false,
        userDecision: 'static',
      });
      console.log(`  ⬜ 已标记为静态`);
    } else if (decision === 'confirm') {
      // 保持原检测状态
      confirmedDetections.push({
        ...det,
        userDecision: det.isDynamic ? 'confirm-dynamic' : 'confirm-static',
      });
      console.log(`  ${det.isDynamic ? '✅' : '⬜'} 已确认${det.isDynamic ? '动态' : '静态'}`);
    } else if (decision === 'dynamic') {
      confirmedDetections.push({
        ...det,
        detectedType: selectedType,
        isDynamic: true,
        userDecision: 'override-dynamic',
      });
      console.log(`  ✅ 已标记为动态类型: ${TYPE_LABELS[selectedType] || selectedType}`);
    }
  }

  // 汇总
  const dynamicCount = confirmedDetections.filter(d => d.isDynamic).length;
  const staticCount = confirmedDetections.length - dynamicCount;

  console.log('\n╔════════════════════════════════════════════════════════╗');
  console.log('║  确认结果汇总                                           ║');
  console.log('╠════════════════════════════════════════════════════════╣');
  console.log(`║  动态区块: ${String(dynamicCount).padStart(2)} 个                                        ║`);
  console.log(`║  静态区块: ${String(staticCount).padStart(2)} 个                                        ║`);
  console.log(`║  总计:     ${String(confirmedDetections.length).padStart(2)} 个                                        ║`);
  console.log('╚════════════════════════════════════════════════════════╝\n');

  // 最终确认
  const finalConfirm = await inquirer.prompt([
    {
      type: 'confirm',
      name: 'proceed',
      message: '确认以上选择，开始转换?',
      default: true,
    },
  ]);

  if (!finalConfirm.proceed) {
    console.log('[INFO] 用户取消操作');
    process.exit(0);
  }

  return confirmedDetections;
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
    console.log(`   类型: ${typeLabel} | 得分: ${det.scores.total}/110 | 置信度: ${conf}%`);
    if (det.evidence.length > 0) {
      det.evidence.forEach(e => console.log(`   ├─ ${e}`));
    }
    console.log(`   └─ ${det.isDynamic ? '✅ 标记为动态' : '⬜ 保持静态'}`);
    console.log('');
  }

  const dynamicDetectionsPreview = detections.filter(d => d.isDynamic);
  console.log(`[RESULT] 共 ${dynamicDetectionsPreview.length} / ${detections.length} 个区块被识别为动态\n`);

  // ─── Phase 2: Interactive Confirmation (or auto mode) ───
  let confirmedDetections;
  if (!AUTO_MODE) {
    // 交互模式: 逐一确认
    confirmedDetections = await interactiveBlockConfirmation(detections, $);
  } else {
    // 自动模式: 接受所有检测结果
    confirmedDetections = detections;
    console.log('[INFO] 自动模式: 接受所有检测结果');
  }

  // 更新动态区块列表
  const dynamicDetections = confirmedDetections.filter(d => d.isDynamic);
  console.log(`[RESULT] 确认后共 ${dynamicDetections.length} / ${confirmedDetections.length} 个动态区块\n`);

  if (dynamicDetections.length === 0) {
    console.log('[INFO] 无动态区块需要转换，输出原始 HTML');
    fs.mkdirSync(path.dirname(outputFile), { recursive: true });
    fs.writeFileSync(outputFile, html, 'utf-8');
    console.log(`[OUTPUT] ${outputFile}`);
    return;
  }

  // ─── Template availability check ───
  const availableBlockTypes = new Set(registry.filter(r => r.status === 'ok').map(r => r.blockType));
  const availableTypeLabels = [...availableBlockTypes].map(bt => {
    const entry = Object.entries(BLOCK_TYPE_MAP).find(([_, v]) => v === bt);
    return entry ? `${entry[0]}(${bt})` : bt;
  });
  console.log(`[INFO] 可用参考模板类型: ${availableTypeLabels.slice(0, 5).join(', ')}${availableTypeLabels.length > 5 ? '...' : ''}`);

  const noTemplateDets = dynamicDetections.filter(d => {
    const bt = BLOCK_TYPE_MAP[d.detectedType];
    return !bt || !availableBlockTypes.has(bt);
  });
  if (noTemplateDets.length > 0) {
    console.log('');
    for (const d of noTemplateDets) {
      const bt = BLOCK_TYPE_MAP[d.detectedType] || '?';
      console.log(`⚠️  [WARN] Section ${d.sectionIndex} "${d.sectionDescription}" 类型 ${d.detectedType}(${bt}) 无可用参考模板`);
      console.log(`   将跳过 FTL 生成，请先运行 /fetch-templates 获取该类型的参考模板`);
    }
    console.log('');
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
  console.log('═══ Phase 4: 验证 (HTML注入) ═══');
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

  console.log('\n═══ Phase 4: 验证 (FTL结构) ═══');
  const dynamicTypeMap = {};
  for (const det of dynamicDetections) {
    for (const inj of injections) {
      if (inj.success && inj.blockType === BLOCK_TYPE_MAP[det.detectedType]) {
        dynamicTypeMap[inj.uuid] = det.detectedType;
      }
    }
  }

  for (const inj of injections) {
    if (!inj.success || !inj.freemakerContent) continue;
    const detectedType = dynamicTypeMap[inj.uuid] || null;
    const ftlChecks = validateFtlContent(inj.freemakerContent, detectedType);
    const existingValidation = allValidations.find(v => v.uuid === inj.uuid);
    if (existingValidation) {
      existingValidation.checks.push(...ftlChecks);
    }

    const allPass = ftlChecks.every(c => c.pass);
    console.log(`[${allPass ? '✅' : '❌'}] ${inj.blockType} (${inj.uuid}) FTL结构`);
    for (const c of ftlChecks) {
      console.log(`   ${c.pass ? '✓' : '✗'} ${c.name}: ${c.detail}`);
    }
  }

  console.log('');

  // ─── Write .ftl files to blocks/ ───
  const dateDir = path.resolve(path.dirname(outputFile), '..');
  const dynamicBlockDir = path.join(dateDir, 'blocks');

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
  const modelScript = generateModelSetupScript(injections, dynamicBlockDir, outputFile);
  const finalHtml = $.html();
  const bodyEnd = finalHtml.lastIndexOf('</body>');
  let outputHtml;
  if (bodyEnd !== -1) {
    outputHtml = finalHtml.substring(0, bodyEnd) + '\n' + modelScript + '\n' + finalHtml.substring(bodyEnd);
  } else {
    outputHtml = finalHtml + '\n' + modelScript;
  }

  // ─── Write output ───
  fs.mkdirSync(path.dirname(outputFile), { recursive: true });
  fs.writeFileSync(outputFile, outputHtml, 'utf-8');
  console.log(`[OUTPUT] 已生成: ${outputFile}`);

  // ─── Generate inline version (FTL embedded in HTML) ───
  const inlineHtml = generateInlineHtml(outputHtml, injections);
  const inlineFile = outputFile.replace(/\.html$/, '_inline.html');
  fs.writeFileSync(inlineFile, inlineHtml, 'utf-8');
  console.log(`[OUTPUT] 已生成内联版: ${inlineFile}`);

  const reportFileName = path.basename(outputFile).replace(/\.html$/, '_report.json');
  const reportsDir = path.join(dateDir, 'reports');
  fs.mkdirSync(reportsDir, { recursive: true });
  const reportFile = path.join(reportsDir, reportFileName);
  const report = generateReport(
    detections.map(d => ({ ...d, el: undefined, $el: undefined })),
    injections,
    allValidations,
    dynamicBlockDir,
  );
  fs.writeFileSync(reportFile, JSON.stringify(report, null, 2), 'utf-8');
  console.log(`[REPORT] 已生成: ${reportFile}`);

  // ─── Phase 5 (optional): Render dynamic blocks via API ───
  let renderCount = 0;
  if (RENDER_MODE) {
    console.log('\n═══ Phase 5: API 渲染动态区块 ═══');

    if (!RENDER_CONFIG.token && !RENDER_CONFIG.cookie) {
      console.log('[WARN] 未提供 --token 或 --cookie，将跳过 API 渲染');
      console.log('[TIP]  使用方式: --render --token <JWT> --cookie <COOKIE>');
    } else {
      const successInjections = injections.filter(i => i.success && i.freemakerContent);
      let renderHtml = outputHtml;

      for (const inj of successInjections) {
        const ftlPath = path.join(dynamicBlockDir, `${inj.uuid}.ftl`);
        if (!fs.existsSync(ftlPath)) {
          console.log(`   ⚠️  ${inj.uuid}.ftl 文件不存在，跳过`);
          continue;
        }

        console.log(`[RENDER] ${inj.uuid} (${inj.blockType})...`);
        try {
          const ftlContent = fs.readFileSync(ftlPath, 'utf-8');
          const renderedHtml = await callRenderFreemarkerApi(ftlContent, RENDER_CONFIG);

          const uuidAttr = `data-block-uuid="${inj.uuid}"`;
          const nodeStart = renderHtml.indexOf(uuidAttr);
          if (nodeStart !== -1) {
            const tagClose = renderHtml.indexOf('>', nodeStart);
            if (tagClose !== -1) {
              const afterTag = tagClose + 1;
              const tagName = findOpeningTag(renderHtml, nodeStart);
              const closeIdx = findMatchingCloseTag(renderHtml, afterTag, tagName);
              if (closeIdx !== -1) {
                renderHtml = renderHtml.substring(0, afterTag) + renderedHtml + renderHtml.substring(closeIdx);
                renderCount++;
                console.log(`   ✅ 渲染成功 (${renderedHtml.length} chars)`);
              } else {
                console.log(`   ⚠️  无法找到 ${inj.uuid} 的匹配闭合标签`);
              }
            }
          } else {
            console.log(`   ⚠️  在输出 HTML 中未找到 ${uuidAttr}`);
          }
        } catch (err) {
          console.log(`   ❌ API 调用失败: ${err.message}`);
        }
      }

      if (renderCount > 0) {
        fs.writeFileSync(outputFile, renderHtml, 'utf-8');
        console.log(`\n[OUTPUT] 已更新渲染结果: ${outputFile} (${renderCount} 个区块已渲染)`);
      }
    }
  }

  // ─── Summary ───
  const ftlCount = injections.filter(i => i.success && i.freemakerContent).length;
  console.log('\n╔════════════════════════════════════════════════════════╗');
  console.log('║  转换完成                                              ║');
  console.log('╠════════════════════════════════════════════════════════╣');
  console.log(`║  总区块数: ${String(detections.length).padEnd(5)} | 动态: ${String(dynamicDetections.length).padEnd(5)} | 静态: ${String(detections.length - dynamicDetections.length).padEnd(5)} ║`);
  console.log(`║  成功注入: ${String(injections.filter(i => i.success).length).padEnd(5)} | 失败: ${String(injections.filter(i => !i.success).length).padEnd(5)} | FTL文件: ${String(ftlCount).padEnd(5)} ║`);
  if (RENDER_MODE) {
    console.log(`║  API渲染: ${String(renderCount).padEnd(5)} 个区块已替换为真实数据              ║`);
  }
  console.log('╠════════════════════════════════════════════════════════╣');
  console.log(`║  输出目录: ${path.relative(process.cwd(), dateDir).replace(/\\/g, '/')}`);
  console.log(`║  ├── pages/   → dynamic_page.html + _inline.html`);
  console.log(`║  ├── blocks/  → ${ftlCount} 个 .ftl 文件`);
  console.log(`║  └── reports/ → report.json`);
  console.log('╚════════════════════════════════════════════════════════╝');
}

main().catch(err => {
  console.error('[FATAL]', err);
  process.exit(1);
});
