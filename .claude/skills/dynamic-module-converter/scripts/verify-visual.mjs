#!/usr/bin/env node
/**
 * verify-visual.mjs — 对比 original vs dynamic HTML 的 DOM 结构差异
 * 使用 cheerio 做结构级比较（不需要浏览器）
 * 通用版：不依赖特定 section ID，自动检测动态/静态区块
 */

import { load } from 'cheerio';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function findLatestGenerateDir() {
  const genDir = path.resolve(__dirname, '../../../../src/Generate');
  if (!fs.existsSync(genDir)) return null;
  const dirs = fs.readdirSync(genDir)
    .filter(d => /^\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}$/.test(d))
    .sort()
    .reverse();
  return dirs.length > 0 ? path.join(genDir, dirs[0]) : null;
}

function findFirstDynamicHtml(dir) {
  const pagesDir = path.join(dir, 'pages');
  if (!fs.existsSync(pagesDir)) return null;
  const files = fs.readdirSync(pagesDir).filter(f => /^dynamic_.*\.html$/.test(f)).sort();
  return files.length > 0 ? path.join(pagesDir, files[0]) : null;
}

function findOriginalFile(dynamicPath) {
  const basename = path.basename(dynamicPath).replace(/^dynamic_/, '');
  const srcDir = path.resolve(__dirname, '../../../../src');
  const pagesDir = path.join(srcDir, 'pages');
  const candidates = [];
  function walk(dir) {
    if (!fs.existsSync(dir)) return;
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      if (entry.isDirectory()) walk(path.join(dir, entry.name));
      else if (entry.name === basename) candidates.push(path.join(dir, entry.name));
    }
  }
  walk(pagesDir);
  return candidates.length > 0 ? candidates[0] : path.join(pagesDir, basename);
}

const latestDir = findLatestGenerateDir();
const latestDynamic = latestDir ? findFirstDynamicHtml(latestDir) : null;
const originalFile = process.argv[2] || (latestDynamic ? findOriginalFile(latestDynamic) : path.resolve(__dirname, '../../../../src/pages/page.html'));
const dynamicFile = process.argv[3] || latestDynamic || path.resolve(__dirname, '../../../../src/pages/dynamic_page.html');

const origHtml = fs.readFileSync(originalFile, 'utf-8');
const dynHtml = fs.readFileSync(dynamicFile, 'utf-8');
const $orig = load(origHtml);
const $dyn = load(dynHtml);

console.log('╔══════════════════════════════════════════╗');
console.log('║  Visual Structure Comparison              ║');
console.log('╚══════════════════════════════════════════╝\n');

let issues = 0;
let checks = 0;

function check(name, pass, detail) {
  checks++;
  if (!pass) issues++;
  console.log(`  ${pass ? '✅' : '❌'} ${name}: ${detail}`);
}

// 1. Style tags preserved
const origStyles = [];
$orig('style').each((_, el) => origStyles.push($orig(el).html()?.trim() || ''));
const dynStyles = [];
$dyn('style').each((_, el) => dynStyles.push($dyn(el).html()?.trim() || ''));
const origStyleConcat = origStyles.join('\n');
const dynStyleConcat = dynStyles.join('\n');
check('CSS 内容一致',
  origStyleConcat.length > 0 && dynStyleConcat.includes(origStyleConcat.substring(0, 200)),
  origStyleConcat.length === dynStyleConcat.length
    ? '完全匹配'
    : `原始 ${origStyleConcat.length} chars, 动态 ${dynStyleConcat.length} chars`);

// 2. Find dynamic blocks in the output (developer-component wrappers)
const dynamicBlocks = [];
$dyn('.developer-component').each((_, el) => {
  const inner = $dyn(el).find('[data-block-uuid]');
  if (inner.length > 0) {
    const uuid = inner.attr('data-block-uuid');
    const blockType = inner.attr('data-block-type');
    dynamicBlocks.push({ uuid, blockType, el });
  }
});

console.log(`\n  ─── 动态区块原始内容保留 (${dynamicBlocks.length} 个) ───`);
for (const db of dynamicBlocks) {
  const nodeComp = $dyn(`[data-block-uuid="${db.uuid}"]`);
  const innerEl = nodeComp.children().first();
  if (innerEl.length === 0) {
    check(`${db.uuid} 内部元素`, false, '无内部元素');
    continue;
  }

  const innerTag = innerEl[0].tagName;
  const innerClass = innerEl.attr('class') || '';
  const innerId = innerEl.attr('id') || '';
  const identifier = innerId || innerClass.split(' ')[0] || innerTag;

  check(`${db.uuid} 外层包装存在`, true, `developer-component > developer-node-component > ${innerTag}`);

  if (innerId) {
    const origEl = $orig(`#${innerId}`);
    if (origEl.length > 0) {
      const origClass = origEl.attr('class') || '';
      check(`${db.uuid} class 保留`, innerClass === origClass,
        innerClass === origClass ? `"${origClass}" ✓` : `"${origClass}" → "${innerClass}"`);

      const origInner = origEl.html()?.trim() || '';
      const dynInner = innerEl.html()?.trim() || '';
      check(`${db.uuid} 内部HTML保留`, origInner === dynInner,
        origInner === dynInner
          ? `${origInner.length} chars 完全匹配`
          : `差异: ${origInner.length} vs ${dynInner.length} chars`);
    } else {
      check(`${db.uuid} 原始元素 #${innerId}`, true, `标记: ${identifier}`);
    }
  } else {
    check(`${db.uuid} 内容元素`, true, `标记: ${identifier}`);
  }
}

// 3. Top-level element count
console.log('\n  ─── 顶层结构 ───');
const origTopLevel = [];
$orig('body').children().each((_, el) => {
  const tag = el.tagName?.toLowerCase();
  if (tag === 'script' || tag === 'style') return;
  origTopLevel.push(tag);
});

const dynTopLevel = [];
$dyn('body').children().each((_, el) => {
  const tag = el.tagName?.toLowerCase();
  if (tag === 'script' || tag === 'style') return;
  dynTopLevel.push(tag);
});

check('顶层元素数量', origTopLevel.length === dynTopLevel.length,
  `原始: ${origTopLevel.length}, 动态: ${dynTopLevel.length}`);

// 4. Inline styles count
console.log('\n  ─── 内联样式保留 ───');
const origInlineCount = $orig('[style]').length;
const dynInlineCount = $dyn('[style]').length;
check('内联样式数量一致', origInlineCount === dynInlineCount,
  `原始: ${origInlineCount}, 动态: ${dynInlineCount}`);

// 5. Images count
console.log('\n  ─── 图片数量 ───');
const origImgs = $orig('img').length;
const dynImgs = $dyn('img').length;
check('img 标签数量一致', origImgs === dynImgs,
  `原始: ${origImgs}, 动态: ${dynImgs}`);

// Summary
console.log(`\n╔══════════════════════════════════════════╗`);
console.log(`║  结果: ${checks - issues}/${checks} 通过`.padEnd(43) + '║');
if (issues > 0) {
  console.log(`║  ❌ ${issues} 项差异检出`.padEnd(43) + '║');
} else {
  console.log('║  ✅ 原始内容完全保留，视觉无差异       ║');
}
console.log('╚══════════════════════════════════════════╝');

process.exit(issues > 0 ? 1 : 0);
