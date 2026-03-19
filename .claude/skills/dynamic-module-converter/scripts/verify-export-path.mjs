#!/usr/bin/env node
/**
 * verify-export-path.mjs — 模拟 GrapesJS editor export 路径
 *
 * 验证 dynamic_preview.html + dynamic_block/*.ftl 的外部模板引用模式
 * 能否让 handleGeneralBlock 正确读取 freemakerHtml
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { load } from 'cheerio';
import vm from 'vm';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const dynamicHtml = path.resolve(__dirname, '../../../../src/dynamic_page.html');
const dynamicBlockDir = path.resolve(__dirname, '../../../../src/dynamic_block');

if (!fs.existsSync(dynamicHtml)) {
  console.error('[ERROR] dynamic_page.html 不存在，请先运行 npm run convert');
  process.exit(1);
}

const html = fs.readFileSync(dynamicHtml, 'utf-8');
const $ = load(html);

let passed = 0;
let failed = 0;

function check(name, condition, detail) {
  if (condition) {
    passed++;
    console.log(`  ✅ ${name}: ${detail}`);
  } else {
    failed++;
    console.log(`  ❌ ${name}: ${detail}`);
  }
}

console.log('╔══════════════════════════════════════════╗');
console.log('║  Export Path Simulation                  ║');
console.log('╚══════════════════════════════════════════╝\n');

// Step 1: Find all developer-node-component elements
const nodeComponents = $('[data-gjs-type="developer-node-component"]');
console.log(`[INFO] 找到 ${nodeComponents.length} 个 developer-node-component\n`);

check('DOM中有动态组件', nodeComponents.length > 0, `${nodeComponents.length} 个组件`);

// Step 2: Verify dynamic_block/ directory
check('dynamic_block/ 目录存在', fs.existsSync(dynamicBlockDir), dynamicBlockDir);

const ftlFiles = fs.existsSync(dynamicBlockDir)
  ? fs.readdirSync(dynamicBlockDir).filter(f => f.endsWith('.ftl'))
  : [];
check('dynamic_block/ 包含 .ftl 文件', ftlFiles.length > 0, `${ftlFiles.length} 个 .ftl 文件`);

// Step 3: Extract Model Setup Script
const scripts = $('script');
let modelScript = null;
scripts.each((_, el) => {
  const text = $(el).html() || '';
  if (text.includes('__DYNAMIC_MODULES__')) {
    modelScript = text;
  }
});

check('Model Setup Script 存在', !!modelScript, modelScript ? '已找到' : '未找到');

if (!modelScript) {
  console.log('\n[FATAL] 无法继续测试 — Model Setup Script 缺失');
  process.exit(1);
}

// Step 4: Execute the Model Setup Script in a sandboxed context
const mockWindow = {};
const mockFetch = async (filePath) => {
  const absPath = path.resolve(path.dirname(dynamicHtml), filePath);
  if (!fs.existsSync(absPath)) {
    return { text: async () => '', ok: false };
  }
  const content = fs.readFileSync(absPath, 'utf-8');
  return { text: async () => content, ok: true };
};

const context = vm.createContext({ window: mockWindow, console, fetch: mockFetch });

try {
  const script = new vm.Script(modelScript);
  script.runInContext(context);
  check('Model Setup Script 可执行', true, 'JavaScript 无报错');
} catch (err) {
  check('Model Setup Script 可执行', false, err.message);
  process.exit(1);
}

const dynamicModules = mockWindow.__DYNAMIC_MODULES__;
check('__DYNAMIC_MODULES__ 已注册', !!dynamicModules, dynamicModules ? 'window 对象上已存在' : '未找到');

if (!dynamicModules) {
  console.log('\n[FATAL] 无法继续 — __DYNAMIC_MODULES__ 未找到');
  process.exit(1);
}

check('modules 列表有数据', dynamicModules.modules?.length > 0, `${dynamicModules.modules?.length || 0} 个模块`);
check('templatePaths 对象有数据', Object.keys(dynamicModules.templatePaths || {}).length > 0, `${Object.keys(dynamicModules.templatePaths || {}).length} 个路径映射`);
check('inject 方法存在', typeof dynamicModules.inject === 'function', typeof dynamicModules.inject);

// Step 5: Verify each .ftl file exists and matches templatePaths
console.log('\n--- 验证 .ftl 文件与 templatePaths 映射 ---\n');

for (const mod of (dynamicModules.modules || [])) {
  const templatePath = dynamicModules.templatePaths[mod.uuid];
  check(`  模块 ${mod.uuid} 有 templatePath`, !!templatePath, templatePath || '缺失');

  if (templatePath) {
    const absPath = path.resolve(path.dirname(dynamicHtml), templatePath);
    const ftlExists = fs.existsSync(absPath);
    check(`  ${mod.uuid}.ftl 文件存在`, ftlExists, absPath);

    if (ftlExists) {
      const ftlContent = fs.readFileSync(absPath, 'utf-8');
      const hasFmContent = ftlContent.length > 100;
      check(`  ${mod.uuid}.ftl 内容有效 (>100 chars)`, hasFmContent, `${ftlContent.length} chars`);

      const hasApiCall = ftlContent.includes('@api') || ftlContent.includes('[@api');
      check(`  ${mod.uuid}.ftl 包含 @api 调用`, hasApiCall, hasApiCall ? '✓' : '无 API 调用');

      check(`  handleGeneralBlock 不会触发 isBadHtml (${mod.uuid})`, hasFmContent, hasFmContent ? 'freemakerHtml 有效 → 正常导出' : '⚠ 可能触发 isBadHtml');

      const hasListDirective = ftlContent.includes('[#list');
      check(`  ${mod.uuid}.ftl 包含 [#list] 循环`, hasListDirective, hasListDirective ? '✓' : '无');

      const hasApiClose = ftlContent.includes('[/@api]');
      check(`  ${mod.uuid}.ftl 包含 [/@api] 结束标签`, hasApiClose, hasApiClose ? '✓' : '无');

      const $ftl = load(ftlContent, { decodeEntities: false });
      const ftlRoot = $ftl('body').children().first();
      const ftlRootTag = ftlRoot.length > 0 ? ftlRoot[0].tagName : null;
      check(`  ${mod.uuid}.ftl 根元素是 div`, ftlRootTag === 'div', `根标签: ${ftlRootTag}`);

      const ftlNodeDiv = ftlRoot.find('[data-gjs-type="developer-node-component"]').first();
      const ftlBlockType = ftlNodeDiv.attr('data-block-type') || ftlRoot.attr('data-block-type');
      check(`  ${mod.uuid}.ftl 包含 data-block-type`, !!ftlBlockType, `值: ${ftlBlockType}`);

      const ftlBlockUuid = ftlNodeDiv.attr('data-block-uuid') || ftlRoot.attr('data-block-uuid');
      check(`  ${mod.uuid}.ftl 包含 data-block-uuid`, !!ftlBlockUuid, `值: ${ftlBlockUuid}`);
      check(`  ${mod.uuid}.ftl data-block-uuid 与 uuid 匹配`, ftlBlockUuid === mod.uuid,
        `模块 uuid: ${mod.uuid}, FTL 属性: ${ftlBlockUuid}`);

      const ftlInner = ftlNodeDiv.length > 0
        ? ftlNodeDiv.children().filter((_, el) => el.tagName !== 'style')
        : ftlRoot.children().first();
      check(`  ${mod.uuid}.ftl 内层 div 下有内容元素`, ftlInner.length > 0,
        ftlInner.length > 0 ? `标签: ${ftlInner.first()[0]?.tagName}` : 'FTL 内未找到内容元素');

      const nodeEl = $(`[data-block-uuid="${mod.uuid}"]`);
      const innerEl = nodeEl.children('[class][id]').first().length > 0
        ? nodeEl.children('[class][id]').first()
        : nodeEl.children().first();
      if (innerEl.length > 0) {
        const elClass = innerEl.attr('class') || '';
        const mainClass = elClass.split(' ')[0];
        if (mainClass) {
          check(`  ${mod.uuid}.ftl 保留原始 CSS class "${mainClass}"`, ftlContent.includes(mainClass),
            ftlContent.includes(mainClass) ? '✓' : `FTL 中未找到 "${mainClass}"`);
        }
      }
    }
  }
}

// Step 6: Simulate handleGeneralBlock for each node component
console.log('\n--- 模拟 handleGeneralBlock 流程 ---\n');

nodeComponents.each((i, el) => {
  const uuid = $(el).attr('data-block-uuid');
  const blockType = $(el).attr('data-block-type');
  const appId = $(el).attr('data-app-id');

  console.log(`[${i}] blockType=${blockType}, uuid=${uuid}, appId=${appId}`);

  check(`  [${i}] data-block-uuid 存在`, !!uuid, uuid || '缺失');
  check(`  [${i}] data-block-type 存在`, !!blockType, blockType || '缺失');
  check(`  [${i}] data-app-id 存在`, !!appId, appId || '缺失');

  const ftlPath = path.join(dynamicBlockDir, `${uuid}.ftl`);
  const ftlExists = fs.existsSync(ftlPath);
  check(`  [${i}] 对应 .ftl 文件存在`, ftlExists, ftlPath);

  if (ftlExists) {
    const template = fs.readFileSync(ftlPath, 'utf-8');
    const hasFmContent = template.length > 100;
    check(`  [${i}] freemakerHtml 内容有效 (>100 chars)`, hasFmContent, `${template.length} chars`);
  }

  console.log('');
});

// Step 7: Simulate inject() call
console.log('--- 模拟 inject(editor) 调用 ---\n');

const mockModels = {};
nodeComponents.each((_, el) => {
  const uuid = $(el).attr('data-block-uuid');
  mockModels[uuid] = {};
});

const mockEditor = {
  DomComponents: {
    getWrapper: () => ({
      find: (selector) => {
        const match = selector.match(/data-block-uuid="([^"]+)"/);
        if (match && mockModels[match[1]]) {
          return [{
            set: (key, value) => {
              if (!mockModels[match[1]]) mockModels[match[1]] = {};
              mockModels[match[1]][key] = typeof value === 'string' ? `[${value.length} chars]` : value;
            }
          }];
        }
        return [];
      }
    })
  }
};

try {
  await dynamicModules.inject(mockEditor);
  check('inject(editor) 执行成功', true, '无报错');
} catch (err) {
  check('inject(editor) 执行成功', false, err.message);
}

for (const [uuid, props] of Object.entries(mockModels)) {
  const hasFm = !!props.freemakerHtml;
  const hasAppId = !!props.appId;
  const hasAppIsDev = props.appIsDev === true;

  check(`inject 设置 freemakerHtml (${uuid})`, hasFm, hasFm ? props.freemakerHtml : '未设置');
  check(`inject 设置 appId (${uuid})`, hasAppId, hasAppId ? props.appId : '未设置');
  check(`inject 设置 appIsDev (${uuid})`, hasAppIsDev, hasAppIsDev ? 'true' : String(props.appIsDev));
}

// Summary
console.log(`\n╔══════════════════════════════════════════╗`);
console.log(`║  结果: ${passed}/${passed + failed} 通过`.padEnd(43) + '║');
if (failed > 0) {
  console.log(`║  ❌ ${failed} 项检查失败`.padEnd(43) + '║');
} else {
  console.log('║  ✅ Export 路径模拟全部通过             ║');
}
console.log('╚══════════════════════════════════════════╝');

process.exit(failed > 0 ? 1 : 0);
