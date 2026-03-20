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
const inputFile = process.argv[2] || latestDynamic || path.resolve(__dirname, '../../../../src/pages/dynamic_page.html');
const originalFile = process.argv[3] || (latestDynamic ? findOriginalFile(latestDynamic) : path.resolve(__dirname, '../../../../src/pages/page.html'));

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

  // Check inner content element preserved (tag-agnostic)
  const innerContent = $node.children().first();
  check('内部内容元素保留', innerContent.length > 0,
    innerContent.length > 0 ? `标签: <${innerContent[0]?.tagName}>, class: ${(innerContent.attr('class') || '').substring(0, 50)}` : '无内容元素');

  if (innerContent.length > 0) {
    const contentId = innerContent.attr('id');
    const contentClass = innerContent.attr('class');
    if (contentId) {
      check('内容元素 id 保留', true, `id: ${contentId}`);
      if ($orig) {
        const origEl = $orig(`#${contentId}`);
        if (origEl.length > 0) {
          const origChildren = origEl.children().length;
          const newChildren = innerContent.children().length;
          check('子元素数量一致', origChildren === newChildren,
            `原始: ${origChildren}, 转换后: ${newChildren}`);
        }
      }
    } else if (contentClass) {
      check('内容元素 class 保留', true, `class: ${contentClass.substring(0, 60)}`);
    }
  }

  // Check CSS class chain
  const blockClass = `block_${uuid}`;
  check(`class 包含 block_${uuid}`, $node.hasClass(blockClass), `${$node.attr('class')?.includes(blockClass)}`);
  check('class 包含 backstage-blocksEditor-wrap', $node.hasClass('backstage-blocksEditor-wrap'), 'OK');
  check('class 包含 developer-component-newedit', $node.hasClass('developer-component-newedit'), 'OK');
});

// ─── Check 3: Model Setup Script + blocks/ 验证 ═══
console.log('\n═══ 3. Model Setup Script + FTL 文件验证 ═══');
const modelScriptFound = html.includes('__DYNAMIC_MODULES__');
const pathMatches = html.match(/TEMPLATE_PATHS\["[^"]+"\]/g);
const pathsInScript = pathMatches ? pathMatches.length : 0;

check('Model Setup Script 存在', modelScriptFound, modelScriptFound ? '已找到' : '未找到');
check('templatePaths 映射存在', pathsInScript > 0, `${pathsInScript} 个路径映射`);
check('路径数量匹配模块数量', pathsInScript === devComponents.length,
  `路径映射: ${pathsInScript}, 模块: ${devComponents.length}`);

const dynamicBlockDir = path.resolve(path.dirname(inputFile), '..', 'blocks');
const blockDirExists = fs.existsSync(dynamicBlockDir);
check('blocks/ 目录存在', blockDirExists, dynamicBlockDir);

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

        const $ftl = load(ftlContent, { decodeEntities: false });
        const ftlRoot = $ftl('body').children().first();
        const ftlRootTag = ftlRoot.length > 0 ? ftlRoot[0].tagName : null;
        check(`FTL ${uuid} 根元素是 div`, ftlRootTag === 'div', `根标签: ${ftlRootTag}`);

        const isPhoenixContainer = ftlRoot.attr('data-gjs-type') === 'phoenix-container';
        check(`FTL ${uuid} 外层是 phoenix-container`, isPhoenixContainer, `data-gjs-type: ${ftlRoot.attr('data-gjs-type')}`);

        const ftlNodeDiv = ftlRoot.find('[data-gjs-type="developer-node-component"]').first();
        const hasNodeDiv = ftlNodeDiv.length > 0;
        check(`FTL ${uuid} 包含 developer-node-component 内层`, hasNodeDiv, hasNodeDiv ? '✓' : '未找到内层 div');

        const ftlBlockType = ftlNodeDiv.attr('data-block-type') || ftlRoot.attr('data-block-type');
        check(`FTL ${uuid} 包含 data-block-type`, !!ftlBlockType, `值: ${ftlBlockType}`);

        const ftlBlockUuid = ftlNodeDiv.attr('data-block-uuid') || ftlRoot.attr('data-block-uuid');
        check(`FTL ${uuid} 包含 data-block-uuid`, !!ftlBlockUuid, `值: ${ftlBlockUuid}`);
        check(`FTL ${uuid} data-block-uuid 与文件名匹配`, ftlBlockUuid === uuid,
          `文件名 uuid: ${uuid}, 属性值: ${ftlBlockUuid}`);

        if (hasNodeDiv) {
          const hasListSetting = !!ftlNodeDiv.attr('data-block-list-setting');
          check(`FTL ${uuid} 内层有 data-block-list-setting`, hasListSetting,
            hasListSetting ? `值: ${ftlNodeDiv.attr('data-block-list-setting')}` : '缺失');

          const hasDefaultSetting = ftlContent.includes('data-default-setting=');
          check(`FTL ${uuid} 内层有 data-default-setting`, hasDefaultSetting, hasDefaultSetting ? '✓' : '缺失');
        }

        const ftlInner = hasNodeDiv ? ftlNodeDiv.children().filter((_, el) => el.tagName !== 'style') : ftlRoot.children().first();
        check(`FTL ${uuid} 内层 div 下有内容元素`, ftlInner.length > 0,
          ftlInner.length > 0 ? `标签: ${ftlInner.first()[0]?.tagName}` : 'FTL 内未找到内容元素');

        const innerEl = $node.children('[class][id]').first().length > 0
          ? $node.children('[class][id]').first()
          : $node.children().first();
        if (innerEl.length > 0) {
          const elClass = innerEl.attr('class') || '';
          const mainClass = elClass.split(' ')[0];
          if (mainClass) {
            check(`FTL ${uuid} 保留原始 CSS class "${mainClass}"`, ftlContent.includes(mainClass),
              ftlContent.includes(mainClass) ? '✓' : `FTL 中未找到 class "${mainClass}"`);
          }
        }
      }
    }
  });
}

// ─── Check 4: Static elements unchanged ───
console.log('\n═══ 4. 静态区块完整性 ═══');
if ($orig) {
  let staticChecked = 0;
  const sampledIds = new Set();
  $orig('[id]').each((_, el) => {
    const id = $orig(el).attr('id');
    if (!id || sampledIds.has(id)) return;
    sampledIds.add(id);

    const newEl = $(`#${id}`);
    if (newEl.length === 0) return;

    const isInDynamic = newEl.closest('.developer-component').length > 0;
    if (!isInDynamic) {
      const origClass = $orig(el).attr('class') || '';
      const newClass = newEl.attr('class') || '';
      if (origClass && origClass === newClass) {
        staticChecked++;
      } else if (origClass && origClass !== newClass) {
        check(`静态元素 #${id} class 未变`, false,
          `原始: "${origClass}" → 转换后: "${newClass}"`);
      }
    }
  });
  console.log(`  [INFO] 验证了 ${staticChecked} 个静态元素 class 未变`);
}

// ─── Check 5: Original JS scripts preserved ───
console.log('\n═══ 5. 原始脚本保留 ═══');
if ($orig) {
  const origScriptCount = $orig('script').length;
  const dynScriptCount = $('script').length;
  check('脚本标签数量', dynScriptCount >= origScriptCount,
    `原始: ${origScriptCount}, 动态: ${dynScriptCount} (动态版含 Model Setup Script)`);
} else {
  const scriptCount = $('script').length;
  check('脚本标签存在', scriptCount > 0, `${scriptCount} 个 script 标签`);
}

// ─── Check 6: CSS styles preserved ───
console.log('\n═══ 6. CSS 样式保留 ═══');
const styleTag = $('style');
check('style 标签保留', styleTag.length > 0, `${styleTag.length} 个 style 标签`);
if ($orig) {
  const origStyleCount = $orig('style').length;
  check('style 标签数量', styleTag.length >= origStyleCount,
    `原始: ${origStyleCount}, 动态: ${styleTag.length}`);
}
if (styleTag.length > 0) {
  const allStyleText = [];
  styleTag.each((_, el) => allStyleText.push($(el).html() || ''));
  const styleText = allStyleText.join('\n');
  check('CSS 包含 @media 响应式规则', styleText.includes('@media'),
    styleText.includes('@media') ? '✓' : '无 @media 规则');
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
