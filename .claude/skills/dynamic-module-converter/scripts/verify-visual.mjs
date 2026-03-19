#!/usr/bin/env node
/**
 * verify-visual.mjs — 对比 original vs dynamic HTML 的 DOM 结构差异
 * 使用 cheerio 做结构级比较（不需要浏览器）
 */

import { load } from 'cheerio';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const originalFile = process.argv[2] || path.resolve(__dirname, '../../../../src/preview.html');
const dynamicFile = process.argv[3] || path.resolve(__dirname, '../../../../src/dynamic_preview.html');

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

// 1. Style tag identical
const origStyle = $orig('style').html()?.trim() || '';
const dynStyle = $dyn('style').html()?.trim() || '';
check('CSS 内容一致', origStyle === dynStyle,
  origStyle === dynStyle ? '完全匹配' : `差异: 原始 ${origStyle.length} vs 动态 ${dynStyle.length} chars`);

// 2. Each static section's inner HTML identical
const staticSectionIds = [
  'hero-banner', 'full-range-products', 'about-us',
  'solutions-header', 'solutions-cards', 'why-choose',
  'news-images', 'cta-section', 'news-events-header'
];

console.log('\n  ─── 静态区块 HTML 完整性 ───');
for (const id of staticSectionIds) {
  const origEl = $orig(`#${id}`);
  const dynEl = $dyn(`#${id}`);
  
  if (origEl.length === 0) {
    check(`#${id}`, false, '原始文件中不存在');
    continue;
  }
  if (dynEl.length === 0) {
    check(`#${id}`, false, '动态文件中不存在');
    continue;
  }
  
  const origInner = origEl.html()?.trim();
  const dynInner = dynEl.html()?.trim();
  check(`#${id} 内容一致`, origInner === dynInner,
    origInner === dynInner ? `${origInner.length} chars 完全匹配` : `差异检出! 原始 ${origInner.length} vs 动态 ${dynInner.length}`);
}

// 3. Dynamic sections - original inner HTML preserved
const dynamicSectionIds = ['product-categories', 'hot-products', 'news-articles'];
console.log('\n  ─── 动态区块原始内容保留 ───');
for (const id of dynamicSectionIds) {
  const origEl = $orig(`#${id}`);
  const dynEl = $dyn(`#${id}`);
  
  if (origEl.length === 0 || dynEl.length === 0) {
    check(`#${id}`, false, '元素缺失');
    continue;
  }
  
  const origInner = origEl.html()?.trim();
  const dynInner = dynEl.html()?.trim();
  check(`#${id} 内部HTML保留`, origInner === dynInner,
    origInner === dynInner ? `${origInner.length} chars 完全匹配` : `差异! ${origInner.length} vs ${dynInner.length}`);
  
  // Check it's wrapped
  const wrapper = dynEl.closest('.developer-component');
  check(`#${id} 外层包装存在`, wrapper.length > 0,
    wrapper.length > 0 ? 'developer-component 包装 ✓' : '包装缺失');
  
  // Verify class/id/attrs unchanged
  const origClass = origEl.attr('class');
  const dynClass = dynEl.attr('class');
  check(`#${id} class 不变`, origClass === dynClass,
    `"${origClass}" → "${dynClass}"`);
  
  const origId = origEl.attr('id');
  const dynId = dynEl.attr('id');
  check(`#${id} id 不变`, origId === dynId, `"${origId}" → "${dynId}"`);
}

// 4. No extra/missing top-level elements
console.log('\n  ─── 顶层结构 ───');
const origTopLevel = [];
$orig('body').children().each((_, el) => {
  const tag = el.tagName?.toLowerCase();
  if (tag === 'script' || tag === 'style') return;
  const id = $orig(el).attr('id') || $orig(el).attr('class')?.split(' ')[0] || tag;
  origTopLevel.push(id);
});

const dynTopLevel = [];
$dyn('body').children().each((_, el) => {
  const tag = el.tagName?.toLowerCase();
  if (tag === 'script' || tag === 'style') return;
  const cls = $dyn(el).attr('class')?.split(' ')[0] || '';
  const id = $dyn(el).attr('id') || cls || tag;
  dynTopLevel.push(id);
});

// Dynamic file should have same count (wrappers replace sections)
check('顶层元素数量', origTopLevel.length === dynTopLevel.length,
  `原始: ${origTopLevel.length}, 动态: ${dynTopLevel.length}`);

// 5. Inline styles not broken
console.log('\n  ─── 内联样式保留 ───');
const origInlineStyles = [];
$orig('[style]').each((_, el) => {
  origInlineStyles.push({ tag: el.tagName, style: $orig(el).attr('style') });
});
const dynInlineStyles = [];
$dyn('[style]').each((_, el) => {
  dynInlineStyles.push({ tag: el.tagName, style: $dyn(el).attr('style') });
});

check('内联样式数量一致', origInlineStyles.length === dynInlineStyles.length,
  `原始: ${origInlineStyles.length}, 动态: ${dynInlineStyles.length}`);

// 6. Images count
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
