#!/usr/bin/env node
/**
 * verify-output.mjs — 验证 dynamic_preview.html 的转换结果
 * 
 * 检查项:
 * 1. DOM 层级正确性
 * 2. 属性完整性
 * 3. FreeMarker 模板内容存在
 * 4. 原始 HTML 完整性
 * 5. 视觉样式保留
 * 6. 静态区块未被修改
 */

import { load } from 'cheerio';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = process.argv[2] || path.resolve(__dirname, '../../../../src/dynamic_preview.html');
const originalFile = process.argv[3] || path.resolve(__dirname, '../../../../src/preview.html');

if (!fs.existsSync(inputFile)) {
  console.error(`[FATAL] 文件不存在: ${inputFile}`);
  process.exit(1);
}

const html = fs.readFileSync(inputFile, 'utf-8');
const $ = load(html);

let originalHtml = '';
let $orig = null;
if (fs.existsSync(originalFile)) {
  originalHtml = fs.readFileSync(originalFile, 'utf-8');
  $orig = load(originalHtml);
}

let totalChecks = 0;
let passedChecks = 0;
let failedChecks = 0;

function check(name, condition, detail) {
  totalChecks++;
  if (condition) {
    passedChecks++;
    console.log(`  ✅ ${name}: ${detail}`);
  } else {
    failedChecks++;
    console.log(`  ❌ ${name}: ${detail}`);
  }
}

console.log('╔══════════════════════════════════════╗');
console.log('║  Dynamic Module Verification Report  ║');
console.log('╚══════════════════════════════════════╝\n');

// ─── Check 1: Find all dynamic modules ───
console.log('═══ 1. 动态模块发现 ═══');
const devComponents = $('div.developer-component');
console.log(`  找到 ${devComponents.length} 个动态模块\n`);
check('动态模块数量', devComponents.length > 0, `${devComponents.length} 个模块`);

// ─── Check 2: Per-module validation ───
console.log('\n═══ 2. 逐模块验证 ═══');
devComponents.each((i, outer) => {
  const $outer = $(outer);
  const $node = $outer.find('[data-gjs-type="developer-node-component"]');
  const uuid = $node.attr('data-block-uuid');
  const blockType = $node.attr('data-block-type');

  console.log(`\n  ─── Module ${i + 1}: ${blockType} (${uuid}) ───`);

  check('外层 data-gjs-type', $outer.attr('data-gjs-type') === 'developer-component',
    `值: ${$outer.attr('data-gjs-type')}`);

  check('外层 class', $outer.hasClass('developer-component'),
    `class: ${$outer.attr('class')}`);

  check('内层 data-gjs-type', $node.attr('data-gjs-type') === 'developer-node-component',
    `值: ${$node.attr('data-gjs-type')}`);

  check('内层 developer-node-component class', $node.hasClass('developer-node-component'),
    `class 包含 developer-node-component`);

  check('data-block-type 存在', !!blockType, `值: ${blockType}`);
  check('data-block-uuid 存在', !!uuid, `值: ${uuid}`);
  check('data-new-auto-uuid 存在', !!$node.attr('data-new-auto-uuid'), `值: ${$node.attr('data-new-auto-uuid')}`);

  check('data-new-auto-uuid 匹配 data-block-uuid',
    $node.attr('data-new-auto-uuid') === uuid,
    `auto-uuid: ${$node.attr('data-new-auto-uuid')} vs block-uuid: ${uuid}`);

  check('data-app-id 存在', !!$node.attr('data-app-id'), `值: ${$node.attr('data-app-id')}`);

  check('data-freemaker-html-available',
    $node.attr('data-freemaker-html-available') === 'true',
    `值: ${$node.attr('data-freemaker-html-available')}`);

  // Check inner section preserved
  const innerSection = $node.find('section');
  check('内部 <section> 保留', innerSection.length > 0, `找到 ${innerSection.length} 个 section`);

  if (innerSection.length > 0) {
    const sectionId = innerSection.attr('id');
    const sectionClass = innerSection.attr('class');
    check('section id 保留', !!sectionId, `id: ${sectionId}`);
    check('section class 保留', !!sectionClass, `class: ${sectionClass}`);

    if ($orig && sectionId) {
      const origSection = $orig(`#${sectionId}`);
      if (origSection.length > 0) {
        const origChildren = origSection.children().length;
        const newChildren = innerSection.children().length;
        check('子元素数量一致', origChildren === newChildren,
          `原始: ${origChildren}, 转换后: ${newChildren}`);
      }
    }
  }

  // Check CSS class chain
  const blockClass = `block_${uuid}`;
  check(`class 包含 block_${uuid}`, $node.hasClass(blockClass), `${$node.attr('class')?.includes(blockClass)}`);
  check('class 包含 backstage-blocksEditor-wrap', $node.hasClass('backstage-blocksEditor-wrap'), 'OK');
  check('class 包含 developer-component-newedit', $node.hasClass('developer-component-newedit'), 'OK');
});

// ─── Check 3: Model Setup Script + dynamic_block/ 验证 ═══
console.log('\n═══ 3. Model Setup Script + FTL 文件验证 ═══');
const modelScriptFound = html.includes('__DYNAMIC_MODULES__');
const pathMatches = html.match(/TEMPLATE_PATHS\["[^"]+"\]/g);
const pathsInScript = pathMatches ? pathMatches.length : 0;

check('Model Setup Script 存在', modelScriptFound, modelScriptFound ? '已找到' : '未找到');
check('templatePaths 映射存在', pathsInScript > 0, `${pathsInScript} 个路径映射`);
check('路径数量匹配模块数量', pathsInScript === devComponents.length,
  `路径映射: ${pathsInScript}, 模块: ${devComponents.length}`);

const dynamicBlockDir = path.join(path.dirname(inputFile), 'dynamic_block');
const blockDirExists = fs.existsSync(dynamicBlockDir);
check('dynamic_block/ 目录存在', blockDirExists, dynamicBlockDir);

if (blockDirExists) {
  const ftlFiles = fs.readdirSync(dynamicBlockDir).filter(f => f.endsWith('.ftl'));
  check('FTL 文件数量匹配模块数量', ftlFiles.length === devComponents.length,
    `FTL 文件: ${ftlFiles.length}, 模块: ${devComponents.length}`);

  devComponents.each((i, outer) => {
    const $node = $(outer).find('[data-gjs-type="developer-node-component"]');
    const uuid = $node.attr('data-block-uuid');
    if (uuid) {
      const ftlPath = path.join(dynamicBlockDir, `${uuid}.ftl`);
      const ftlExists = fs.existsSync(ftlPath);
      check(`FTL 文件 ${uuid}.ftl 存在`, ftlExists, ftlPath);
      if (ftlExists) {
        const ftlContent = fs.readFileSync(ftlPath, 'utf-8');
        check(`FTL 文件 ${uuid}.ftl 内容非空`, ftlContent.length > 0, `${ftlContent.length} chars`);

        check(`FTL ${uuid} 包含 [@api] 调用`, ftlContent.includes('[@api'), ftlContent.includes('[@api') ? '✓' : '无 @api');
        check(`FTL ${uuid} 包含 [#list] 循环`, ftlContent.includes('[#list'), ftlContent.includes('[#list') ? '✓' : '无 [#list]');
        check(`FTL ${uuid} 包含 [/@api]`, ftlContent.includes('[/@api]'), ftlContent.includes('[/@api]') ? '✓' : '无 [/@api]');

        const innerSection = $node.find('section');
        if (innerSection.length > 0) {
          const sectionClass = innerSection.attr('class') || '';
          const mainClass = sectionClass.split(' ')[0];
          if (mainClass) {
            check(`FTL ${uuid} 保留原始 CSS class "${mainClass}"`, ftlContent.includes(mainClass),
              ftlContent.includes(mainClass) ? '✓' : `FTL 中未找到 class "${mainClass}"`);
          }
        }
      }
    }
  });
}

// ─── Check 4: Static sections unchanged ───
console.log('\n═══ 4. 静态区块完整性 ═══');
if ($orig) {
  const origSections = $orig('body > section, body > div > section');
  const newSections = $('body > section, body > div > section, body > div.developer-component section');

  let staticChecked = 0;
  origSections.each((_, origEl) => {
    const id = $orig(origEl).attr('id');
    if (!id) return;

    const newEl = $(`#${id}`);
    if (newEl.length === 0) return;

    const isInDynamic = newEl.closest('.developer-component').length > 0;
    if (!isInDynamic) {
      staticChecked++;
      const origClass = $orig(origEl).attr('class');
      const newClass = newEl.attr('class');
      check(`静态区块 #${id} class 未变`, origClass === newClass,
        `原始: "${origClass}" → 转换后: "${newClass}"`);
    }
  });
  console.log(`  [INFO] 验证了 ${staticChecked} 个静态区块`);
}

// ─── Check 5: Original JS scripts preserved ───
console.log('\n═══ 5. 原始脚本保留 ═══');
const hasHeroCarousel = html.includes('HERO CAROUSEL');
const hasProductCarousel = html.includes('PRODUCT CAROUSEL');
const hasCounterAnimation = html.includes('COUNTER ANIMATION');
const hasFadeIn = html.includes('SCROLL FADE-IN');

check('Hero Carousel 脚本保留', hasHeroCarousel, hasHeroCarousel ? '✓' : '丢失');
check('Product Carousel 脚本保留', hasProductCarousel, hasProductCarousel ? '✓' : '丢失');
check('Counter Animation 脚本保留', hasCounterAnimation, hasCounterAnimation ? '✓' : '丢失');
check('Fade-in 脚本保留', hasFadeIn, hasFadeIn ? '✓' : '丢失');

// ─── Check 6: CSS styles preserved ───
console.log('\n═══ 6. CSS 样式保留 ═══');
const styleTag = $('style');
check('style 标签保留', styleTag.length > 0, `${styleTag.length} 个 style 标签`);
if (styleTag.length > 0) {
  const styleText = styleTag.html();
  check('CSS 包含 .hot-products', styleText.includes('.hot-products'), '✓');
  check('CSS 包含 .product-categories', styleText.includes('.product-categories'), '✓');
  check('CSS 包含 .news-articles', styleText.includes('.news-articles'), '✓');
  check('CSS 包含响应式规则', styleText.includes('@media'), '✓');
}

// ─── Summary ───
console.log('\n╔══════════════════════════════════════╗');
console.log(`║  验证完成: ${passedChecks}/${totalChecks} 通过`.padEnd(39) + '║');
if (failedChecks > 0) {
  console.log(`║  ❌ ${failedChecks} 项检查失败`.padEnd(39) + '║');
} else {
  console.log('║  ✅ 全部通过                         ║');
}
console.log('╚══════════════════════════════════════╝');

process.exit(failedChecks > 0 ? 1 : 0);
