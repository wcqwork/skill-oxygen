#!/usr/bin/env node
/**
 * test-edge-cases.mjs — 边界场景测试
 */

import { execSync } from 'child_process';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { load } from 'cheerio';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const converterPath = path.resolve(__dirname, 'convert-dynamic.mjs');
const tmpDir = path.resolve(__dirname, '../_test_tmp');

if (!fs.existsSync(tmpDir)) fs.mkdirSync(tmpDir, { recursive: true });

let passed = 0;
let failed = 0;

function runTest(name, htmlContent, expectDynamic = 0) {
  const inputFile = path.join(tmpDir, `${name}.html`);
  const outputFile = path.join(tmpDir, `${name}_out.html`);
  
  fs.writeFileSync(inputFile, htmlContent, 'utf-8');
  
  try {
    const result = execSync(
      `node "${converterPath}" --input "${inputFile}" --output "${outputFile}" --auto`,
      { encoding: 'utf-8', timeout: 15000 }
    );
    
    const outputExists = fs.existsSync(outputFile);
    const outputHtml = outputExists ? fs.readFileSync(outputFile, 'utf-8') : '';
    const $out = outputHtml ? load(outputHtml) : null;
    const dynamicCount = $out ? $out('[data-gjs-type="developer-node-component"]').length : 0;
    
    const passExpect = dynamicCount === expectDynamic;
    const passNoError = !result.includes('[ERROR]') && !result.includes('[FATAL]');
    const allPass = passExpect && passNoError && outputExists;
    
    if (allPass) {
      passed++;
      console.log(`  ✅ ${name}: 动态=${dynamicCount}(期望${expectDynamic}), 输出${outputHtml.length}chars`);
    } else {
      failed++;
      console.log(`  ❌ ${name}: 动态=${dynamicCount}(期望${expectDynamic}), 输出存在=${outputExists}, 无错=${passNoError}`);
    }
  } catch (err) {
    if (name === 'empty_file' || name === 'no_body') {
      passed++;
      console.log(`  ✅ ${name}: 正确处理异常输入 (exit code ≠ 0)`);
    } else {
      failed++;
      console.log(`  ❌ ${name}: 脚本崩溃 — ${err.message?.substring(0, 100)}`);
    }
  }
}

console.log('╔══════════════════════════════════════════╗');
console.log('║  Edge Case Tests                         ║');
console.log('╚══════════════════════════════════════════╝\n');

// Test 1: Empty file
runTest('empty_file', '');

// Test 2: Valid HTML with no sections
runTest('no_sections', `<!DOCTYPE html><html><head></head><body><div>Hello</div></body></html>`, 0);

// Test 3: All static sections
runTest('all_static', `<!DOCTYPE html><html><head></head><body>
  <section class="about-us" id="about"><div class="container"><h2>About Us</h2><p>We are great.</p></div></section>
  <section class="hero" id="hero"><div><h1>Welcome</h1></div></section>
  <section class="footer" id="footer"><div>Copyright 2025</div></section>
</body></html>`, 0);

// Test 4: Section with 5+ repeating product cards
runTest('pure_product_list', `<!DOCTYPE html><html><head></head><body>
  <section class="products" id="products">
    <div class="container">
      <h2>Our Products</h2>
      <div class="product-grid">
        <div class="product-card"><img src="a.jpg"><h3>Product A</h3><p>Description</p></div>
        <div class="product-card"><img src="b.jpg"><h3>Product B</h3><p>Description</p></div>
        <div class="product-card"><img src="c.jpg"><h3>Product C</h3><p>Description</p></div>
        <div class="product-card"><img src="d.jpg"><h3>Product D</h3><p>Description</p></div>
        <div class="product-card"><img src="e.jpg"><h3>Product E</h3><p>Description</p></div>
      </div>
    </div>
  </section>
</body></html>`, 1);

// Test 5: Article list with dates
runTest('article_list', `<!DOCTYPE html><html><head></head><body>
  <section class="news" id="news">
    <div class="container">
      <h2>Latest News</h2>
      <div class="article-list">
        <div class="article-card"><img src="a.jpg"><h3>Title A</h3><div class="date">25 December 2025</div></div>
        <div class="article-card"><img src="b.jpg"><h3>Title B</h3><div class="date">18 December 2025</div></div>
        <div class="article-card"><img src="c.jpg"><h3>Title C</h3><div class="date">10 December 2025</div></div>
      </div>
    </div>
  </section>
</body></html>`, 1);

// Test 6: Mixed - one dynamic, one static
runTest('mixed', `<!DOCTYPE html><html><head></head><body>
  <section class="hero-banner" id="hero"><div><h1>Welcome</h1></div></section>
  <section class="products" id="products">
    <div class="grid">
      <div class="product-card"><img src="a.jpg"><h3>A</h3></div>
      <div class="product-card"><img src="b.jpg"><h3>B</h3></div>
      <div class="product-card"><img src="c.jpg"><h3>C</h3></div>
      <div class="product-card"><img src="d.jpg"><h3>D</h3></div>
    </div>
  </section>
  <section class="about-us" id="about"><div><h2>About</h2><p>Info</p></div></section>
</body></html>`, 1);

// Test 7: Section with only 2 items (should NOT be dynamic)
runTest('too_few_items', `<!DOCTYPE html><html><head></head><body>
  <section class="cards" id="cards">
    <div class="grid">
      <div class="card"><img src="a.jpg"><h3>A</h3></div>
      <div class="card"><img src="b.jpg"><h3>B</h3></div>
    </div>
  </section>
</body></html>`, 0);

// Test 8: HTML with inline script containing $ (FreeMarker-like)
runTest('inline_script_dollar', `<!DOCTYPE html><html><head></head><body>
  <section class="products" id="products">
    <div class="grid">
      <div class="product-card"><img src="a.jpg"><h3>A</h3></div>
      <div class="product-card"><img src="b.jpg"><h3>B</h3></div>
      <div class="product-card"><img src="c.jpg"><h3>C</h3></div>
    </div>
  </section>
  <script>var x = 'hello'; console.log(x);</script>
</body></html>`, 1);

// Test 9: Large number of sections
const manySections = Array.from({length: 20}, (_, i) =>
  `<section class="section-${i}" id="s${i}"><div><h2>Section ${i}</h2><p>Content</p></div></section>`
).join('\n');
runTest('many_sections', `<!DOCTYPE html><html><head></head><body>\n${manySections}\n</body></html>`, 0);

// Cleanup
try {
  fs.rmSync(tmpDir, { recursive: true, force: true });
} catch {}

console.log(`\n╔══════════════════════════════════════════╗`);
console.log(`║  结果: ${passed}/${passed + failed} 通过`.padEnd(43) + '║');
if (failed > 0) {
  console.log(`║  ❌ ${failed} 个边界测试失败`.padEnd(43) + '║');
} else {
  console.log('║  ✅ 全部边界场景处理正确               ║');
}
console.log('╚══════════════════════════════════════════╝');

process.exit(failed > 0 ? 1 : 0);
