#!/usr/bin/env node
/**
 * verify-js-syntax.mjs — 验证 dynamic_preview.html 中嵌入的 JS 脚本语法正确性
 * 
 * 重点检查:
 * 1. Model Setup Script 中 TEMPLATE_PATHS 路径映射正确性
 * 2. 原始 JS 脚本未被破坏
 * 3. 所有 <script> 标签内容可被 V8 解析
 */

import fs from 'fs';
import path from 'path';
import vm from 'vm';
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

const latestDir = findLatestGenerateDir();
const latestDynamic = latestDir ? findFirstDynamicHtml(latestDir) : null;
const inputFile = process.argv[2] || latestDynamic || path.resolve(__dirname, '../../../../src/pages/dynamic_page.html');

if (!fs.existsSync(inputFile)) {
  console.error(`[FATAL] 文件不存在: ${inputFile}`);
  process.exit(1);
}

const html = fs.readFileSync(inputFile, 'utf-8');

console.log('╔══════════════════════════════════════╗');
console.log('║  JS Syntax Verification              ║');
console.log('╚══════════════════════════════════════╝\n');

const scriptRegex = /<script[^>]*>([\s\S]*?)<\/script>/gi;
let match;
let scriptIndex = 0;
let totalScripts = 0;
let passedScripts = 0;
let failedScripts = 0;
const issues = [];

while ((match = scriptRegex.exec(html)) !== null) {
  scriptIndex++;
  totalScripts++;
  const scriptContent = match[1].trim();
  
  if (!scriptContent) {
    console.log(`  [SKIP] Script #${scriptIndex}: 空脚本`);
    passedScripts++;
    continue;
  }

  if (scriptContent.startsWith('{') || scriptContent.includes('"@context"')) {
    console.log(`  [SKIP] Script #${scriptIndex}: JSON-LD (非 JS)`);
    passedScripts++;
    continue;
  }

  const isModelSetup = scriptContent.includes('__DYNAMIC_MODULES__');
  const label = isModelSetup ? 'Model Setup Script' : `Script #${scriptIndex}`;
  const preview = scriptContent.substring(0, 80).replace(/\n/g, ' ');

  try {
    new vm.Script(scriptContent, { filename: `script_${scriptIndex}.js` });
    passedScripts++;
    console.log(`  ✅ ${label}: 语法正确 (${scriptContent.length} chars)`);
    
    if (isModelSetup) {
      const pathCount = (scriptContent.match(/TEMPLATE_PATHS\["/g) || []).length;
      console.log(`     └─ 包含 ${pathCount} 个 FTL 路径映射`);
      
      const hasInject = scriptContent.includes('inject:') || scriptContent.includes('.inject');
      console.log(`     └─ inject() 方法: ${hasInject ? '存在' : '缺失'}`);
      
      const hasModules = scriptContent.includes('modules:');
      console.log(`     └─ modules 定义: ${hasModules ? '存在' : '缺失'}`);

      const hasTemplatePaths = scriptContent.includes('templatePaths:');
      console.log(`     └─ templatePaths 定义: ${hasTemplatePaths ? '存在' : '缺失'}`);

      try {
        const mockFetch = async () => ({ text: async () => '', ok: true });
        const context = vm.createContext({
          window: {},
          document: { querySelectorAll: () => [] },
          console: { log: () => {}, error: () => {} },
          fetch: mockFetch,
        });
        vm.runInContext(scriptContent, context);
        console.log(`     └─ 运行时执行: ✅ 无异常`);
        
        if (context.window.__DYNAMIC_MODULES__) {
          const dm = context.window.__DYNAMIC_MODULES__;
          console.log(`     └─ modules 数量: ${dm.modules?.length || 0}`);
          console.log(`     └─ templatePaths 数量: ${Object.keys(dm.templatePaths || {}).length}`);
          
          for (const mod of dm.modules || []) {
            const tmplPath = dm.templatePaths[mod.uuid];
            const status = tmplPath ? '✅' : '⚠️';
            console.log(`     └─ ${status} ${mod.blockType} (${mod.uuid}): ${tmplPath || '路径缺失'}`);
          }
        }
      } catch (runtimeErr) {
        console.log(`     └─ 运行时执行: ❌ ${runtimeErr.message}`);
        issues.push({ script: label, type: 'runtime', error: runtimeErr.message });
      }
    }
  } catch (syntaxErr) {
    failedScripts++;
    console.log(`  ❌ ${label}: 语法错误!`);
    console.log(`     └─ ${syntaxErr.message}`);
    console.log(`     └─ 预览: ${preview}...`);
    issues.push({ script: label, type: 'syntax', error: syntaxErr.message });
  }
}

console.log('\n╔══════════════════════════════════════╗');
console.log(`║  结果: ${passedScripts}/${totalScripts} 脚本通过`.padEnd(39) + '║');
if (failedScripts > 0) {
  console.log(`║  ❌ ${failedScripts} 个脚本有语法错误`.padEnd(39) + '║');
}
if (issues.length > 0) {
  console.log('║  发现问题:                           ║');
  for (const issue of issues) {
    console.log(`║  - ${issue.script}: ${issue.type}`.padEnd(39) + '║');
  }
}
if (failedScripts === 0 && issues.length === 0) {
  console.log('║  ✅ 全部通过，无语法/运行时错误      ║');
}
console.log('╚══════════════════════════════════════╝');

process.exit(failedScripts > 0 ? 1 : 0);
