# Dynamic Module Converter Skill (v8 - Universal Detection)

静态 HTML → 动态 FreeMarker 模块自动转换。**通用的自底向上检测算法**自动识别动态区域（不依赖特定标签），注入编辑器标记，**以原始 HTML 为骨架合成 FreeMarker 模板**，同时 **100% 保留原始 HTML 结构和样式**。支持克隆静态页面和平台导出页面两种格式。

**Command**: `/convert-dynamic --input <file.html> [--output <file.html>] [--auto]`

## Quick Start

```bash
# 安装依赖
npm install

# 一键转换 + 全套验证 (150+ 检查项)
npm test

# 单独转换（使用 package.json 中预设路径）
npm run convert

# 指定任意 HTML 文件转换
node .claude/skills/dynamic-module-converter/scripts/convert-dynamic.mjs \
  --input src/pages/clone-wpdemo.archiwp.com/preview.html \
  --auto

# 指定输入（输出自动生成到 src/Generate/YYYY-MM-DD_HH-mm-ss/ 下）
node .claude/skills/dynamic-module-converter/scripts/convert-dynamic.mjs \
  --input src/pages/your-page.html \
  --auto

# 验证套件 (可单独运行)
npm run verify          # DOM结构验证 (73项)
npm run verify:js       # JS语法 + 运行时验证
npm run verify:visual   # 视觉结构对比 (25项)
npm run verify:export   # Export路径模拟 (41项)
npm run verify:edge     # 边界场景测试 (9项)
npm run verify:all      # 全部验证
```

**参数说明**:
- `--input` (必需) 输入的静态 HTML 文件路径
- `--output` (可选) 输出文件路径，默认在同目录生成 `dynamic_<原文件名>.html`
- `--auto` (可选) 自动模式，跳过确认

## When to Use

- 将任意 HTML 页面中的动态区域转为 FreeMarker 模块
- 支持克隆静态页面（`<section>` 结构）和平台导出页面（`sitewidget-*` 结构）
- "转换动态", "动态模块", "convert dynamic", "inject markers"
- "产品列表动态化", "文章列表动态化", "注入FreeMarker"
- 搭配 `/clone-website` 使用：先克隆 → 再转换

## Core Design Principle: "Add markers, don't replace structure"

For sections identified as dynamic modules:

- **Keep** the original static HTML structure and styles 100% intact
- **Add** editor-compatible attributes and classes so the editor recognizes them as dynamic components
- **Synthesize** FreeMarker templates by combining original HTML skeleton with `@api` queries and `[#list]` directives from reference templates
- **Store** synthesized FTL as independent .ftl files in `blocks/`, loaded at runtime via `fetch()`
- **Result**: Editor displays original cloned layout; export outputs FreeMarker template that preserves original CSS classes

## Architecture

```
任意 HTML 文件（克隆静态页面 或 平台导出页面）
    │
    ▼
┌─────────────────────────────────────────────┐
│  Phase 1: 通用动态区域识别 (底向上检测)       │
│  1. 全局扫描: 找所有含 >=3 重复子元素的容器   │
│  2. 向上回溯: 找到合适的区块边界（语义边界）  │
│  3. 去重: 嵌套重复容器只保留外层              │
│  4. 三层评分: 结构 + URL + 内容启发           │
│  不依赖 <section> 标签，支持任意 HTML 结构    │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  Phase 2: 用户确认 (mandatory confirmation)   │
│  展示所有发现的区块让用户逐一确认             │
│  选项: 确认类型 / 修改类型 / 保持静态         │
│  零自动转换 — 必须显式用户批准               │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  Phase 3: 标记注入 (marker injection)         │
│  对确认的动态区块:                            │
│    1. 修改外层包装器类型和类名                │
│    2. 添加 developer-node-component 内层      │
│    3. 原始 HTML 完全不变（标签无关）          │
│    4. Model Setup Script 引用 .ftl 路径       │
│  输入: templates/*.ftl (参考 @api 查询)       │
│  输出: 注入标记的 HTML                        │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  Phase 3.5: FTL 模板合成 (template synthesis)│
│  输入:                                       │
│    1. 原始 section HTML (preview.html)       │
│    2. 参考模板的 @api 查询块                  │
│    3. 字段映射规则 (按类型)                   │
│  处理:                                       │
│    - 保留原始 HTML 结构和 CSS class          │
│    - 提取重复项 → [#list] 循环              │
│    - 静态文本 → FreeMarker 变量替换          │
│    - 外层包上 [@api] 数据查询                │
│  输出: blocks/{uuid}.ftl                     │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  Phase 4: 渲染验证 (render-verify)            │
│    1. DOM 层级正确                            │
│    2. 属性完整                                │
│    3. .ftl 文件存在且内容有效                  │
│    4. 视觉样式不变                            │
│    5. 导出路径正确 (fetch .ftl → model)       │
└─────────────────────────────────────────────┘
```

## What Changes on the Static HTML

### Before (current inject-to-editor.js output)

```html
<div data-gjs-type="developer-component-ai">
  <section class="hot-products">
    <div class="container">
      <div class="product-card">...</div>
      <div class="product-card">...</div>
      <div class="product-card">...</div>
    </div>
  </section>
</div>
```

### After (marker injection applied)

```html
<div class="developer-component" data-gjs-type="developer-component">
  <div class="backstage-blocksEditor-wrap developer-node-component developer-component-newedit block_UNIQUE"
       data-gjs-type="developer-node-component"
       data-block-type="phoenix_blocks_prodlist"
       data-block-uuid="UNIQUE">
    <section class="hot-products">                    <!-- UNCHANGED -->
      <div class="container">                          <!-- UNCHANGED -->
        <div class="product-card">...</div>            <!-- UNCHANGED -->
        <div class="product-card">...</div>            <!-- UNCHANGED -->
        <div class="product-card">...</div>            <!-- UNCHANGED -->
      </div>
    </section>
  </div>
</div>
```

Changes summary:

- Outer `data-gjs-type` changed from `developer-component-ai` to `developer-component`, class `developer-component` added
- New inner wrapper `div` added with `developer-node-component` markers
- **All original HTML inside `<section>` is completely untouched**

### Post-injection model setup (via external .ftl files)

FreeMarker 模板不再内联嵌入 HTML，而是作为独立 .ftl 文件存放在 `blocks/` 目录中。Model Setup Script 通过 `fetch()` 异步加载：

```javascript
// Model Setup Script 中的 inject() 方法
window.__DYNAMIC_MODULES__.inject = async function(editor) {
  for (var i = 0; i < this.modules.length; i++) {
    var mod = this.modules[i];
    var nodeEls = editor.DomComponents.getWrapper()
      .find('[data-block-uuid="' + mod.uuid + '"]');
    if (nodeEls.length > 0) {
      var resp = await fetch(mod.templatePath);  // e.g. "blocks/5ace9069b7fa.ftl"
      var ftlContent = await resp.text();
      nodeEls[0].set('freemakerHtml', ftlContent);
      nodeEls[0].set('appId', mod.appId);
      nodeEls[0].set('appIsDev', true);
    }
  }
};
```

## Verified Technical Feasibility

Each step verified against actual codebase:

1. **Editor recognition**: `isComponent` at `developerComponent/index.ts` checks `el.classList.contains('developer-node-component')` — adding this class is sufficient
2. **Parent binding**: `init()` calls `closestType(DEV_ELEMENT_TYPE)` — the outer `developer-component` wrapper satisfies this
3. **Settings panel**: `handlerSetting` reads `data-block-type` from attributes to call `openPhoenixDataSource` — our injected attribute works
4. **Export replacement**: `handleGeneralBlock` at `PageExportStaticHTML.ts` reads `model.get('freemakerHtml')` and replaces DOM content — our model property is used

## How Export Works

```
User clicks Export/Save
    ↓
replaceFreemakerCode() finds all DEV_ELEMENT_TYPE models
    ↓
handleGeneralBlock() reads model.get('freemakerHtml')
    ↓
freemakerHtml exists? → Replace DOM content with FreeMarker source
No + has appId?       → getFreemakerCodeByAppId (API fetch)
No + no appId?        → isBadHtml = true (error)
    ↓
Final HTML contains FreeMarker template code
```

Key: `inject()` loads .ftl content from `blocks/{uuid}.ftl` via `fetch()` and sets it on the model. As long as `freemakerHtml` is set on the model, export will correctly output FreeMarker.

## Supported `data-block-type` Values (22+ types)

From `dynamicSourceData/hooks/index.ts`:

- **Product**: `phoenix_blocks_prodlist`, `phoenix_blocks_groupProduct`, `phoenix_blocks_groupProduct_new`
- **Article**: `phoenix_blocks_Articlelist`, `phoenix_blocks_groupArticle`, `phoenix_blocks_groupArticle_new`
- **Download**: `phoenix_blocks_downloadlist`, `phoenix_blocks_downloadGroup`, `phoenix_blocks_downloadGroup_new`
- **Video**: `phoenix_blocks_videoList`, `phoenix_blocks_videoGroup`, `phoenix_blocks_videoGroup_new`
- **Gallery**: `phoenix_blocks_galleryList`, `phoenix_blocks_galleryGroup`, `phoenix_blocks_galleryGroup_new`, `phoenix_blocks_galleryDetail`
- **FAQ**: `phoenix_blocks_faqList`, `phoenix_blocks_faqGroup`, `phoenix_blocks_faqGroup_new`
- **Other**: `phoenix_blocks_commentList`, `phoenix_blocks_memberAccount`, `phoenix_blocks_search`, `phoenix_blocks_searchResult`, `phoenix_blocks_siteMap`, `phoenix_blocks_articleDetail`

## Four-Phase Workflow

### Phase 1: Universal Block Discovery + Three-Layer Detection

**Step 1 — Bottom-up Block Discovery (tag-agnostic)**

Unlike previous versions that hardcoded `<section>` selectors, v8 uses a universal bottom-up approach:

1. **Global scan**: Traverse entire DOM (excluding head/script/style/svg), find ALL containers with >=3 structurally identical children
2. **Boundary trace**: From each repeating container, walk up the DOM tree to find the nearest "semantic boundary" — an element with an `id`, a semantic tag (`section`/`article`/`main`/`aside`), or a meaningful class (`container`/`wrapper`/`widget`/`component`/etc.)
3. **Dedup**: If a repeating container is a descendant of another's, only keep the outermost one
4. **Static exclusion**: Skip blocks matching known static patterns (header, footer, nav, placeholder, etc.)

**Step 2 — Three-Layer Scoring** (applied to each discovered block)

**Layer 1 — Structural** Score: 0-40
- Count identical tag signatures among children (tag + img/link/heading presence + depth bucket)
- >=9 items → 40, >=5 → 35, >=3 → 25

**Layer 2 — URL Pattern Analysis** Score: 0-25
- `/product/`, `/p/`, `/item/` → product
- `/blog/`, `/news/`, `/article/` → article
- `/gallery/`, `/photo/` → gallery
- `/faq/`, `/help/` → FAQ
- YouTube/Vimeo/`/video/` → video

**Layer 3 — Content Heuristics** Score: 0-20
- Price regex, currency symbols → product
- CSS class patterns: `prodlist`, `articlelist`, `gallerylist`, etc. → corresponding type
- Date patterns, `<time>` → article
- `<iframe>` / `<video>` → video
- Accordion pattern → FAQ

**Threshold**: totalScore >= 50, or structural >= 25 with valid type

### Phase 2: Mandatory User Confirmation

For EACH discovered block:

- Show: block index, brief description, detected type or "static", confidence, evidence
- User options: **Confirm type** / **Change type** (dropdown) / **Keep static**
- Zero automatic conversion — every dynamic conversion requires explicit user approval

### Phase 3: Marker Injection

For each user-confirmed dynamic block:

1. **Wrap with developer-component**: Add outer `<div class="developer-component" data-gjs-type="developer-component">`
2. **Add inner marker div**: Insert a `developer-node-component` div with `data-block-type`, `data-block-uuid`, and other required attributes
3. **Original HTML**: Completely unchanged — same tags, same classes, same styles (tag-agnostic)
4. **Model Setup Script**: References external .ftl file paths via `templatePaths` mapping; `inject()` uses `fetch()` to load content at runtime

### Phase 3.5: FTL Template Synthesis

For each dynamic section, synthesize a FreeMarker template that preserves the original HTML:

1. **Extract `@api` block** from reference template (`templates/fetched/*.ftl`) — only the GraphQL query and API parameters
2. **Identify repeating items** using the detection result's `repeatingContainer` — e.g. `.product-card` children inside `.carousel-track`
3. **Apply field mapping** per dynamic type:
   - `prodList`: `img src` → `${product.photoUrlList[0]!}`, text → `${product.prodName!?html}`, link → `${product.prodUrl!'#'}`
   - `articleList`: `img src` → `${article.photoUrlNormal!''}`, title → `${article.articleTitle!''}`, date → `${article.publishTime!''}`
   - `groupProduct`: link text → `${group.groupName!?html}`, link → `${group.groupUrl!''}`
4. **Wrap in FreeMarker directives**: `[@api]...[#list]...[/#list]...[/@api]`
5. **Output**: `blocks/{uuid}.ftl` — original HTML structure + dynamic FreeMarker syntax

### Phase 4: Validation

For each converted section:

- **DOM check**: `developer-component` > `developer-node-component` > original HTML
- **Attribute check**: `data-block-type`, `data-block-uuid`, `data-gjs-type` all present
- **FTL file check**: `blocks/{uuid}.ftl` exists and contains valid FreeMarker with `@api` calls
- **Visual check**: Original CSS classes and styles still render correctly
- **Export check**: Simulate export path — `inject()` fetches .ftl from `blocks/`, `handleGeneralBlock()` reads `freemakerHtml`

## Dynamic Type Detection Patterns

| componentType | 识别特征 | 对应数据源 |
|---|---|---|
| `prodList` | 重复卡片（图片+名称+价格）、"Product"相关文字 | 产品列表 GQL |
| `prodDetail` | 产品详情页布局（大图+规格+描述） | 产品详情 GQL |
| `articleList` | 重复卡片（缩略图+标题+日期）、"News/Blog" | 文章列表 GQL |
| `articleDetail` | 文章详情（标题+正文+日期+作者） | 文章详情 GQL |
| `galleryList` | 重复图片网格、图集 | 图库列表 GQL |
| `videoList` | 重复视频缩略图+标题 | 视频列表 GQL |
| `downloadList` | 重复下载项（文件名+大小+按钮） | 下载列表 GQL |
| `FAQList` | 重复问答对（问题+答案折叠） | FAQ 列表 GQL |

**识别策略**（多维度加权）：

1. **结构特征**（权重 40%）：同一父容器下 ≥3 个结构相同的子元素 → 高概率列表
2. **内容语义**（权重 30%）：元素文本/class/alt 属性中含产品/文章/新闻等关键词
3. **字段组合**（权重 20%）：图片+标题+日期 = 文章特征；图片+名称+价格 = 产品特征
4. **模板匹配**（权重 10%）：与已有 FreeMarker 模板结构做相似度比对

## File Structure

```
.claude/skills/dynamic-module-converter/
  SKILL.md                           -- Skill entry point (this file)
  scripts/
    convert-dynamic.mjs              -- Main conversion script (Phase 1-4)
    verify-output.mjs                -- DOM structure + FTL file verification
    verify-js-syntax.mjs             -- JS syntax + runtime verification
    verify-visual.mjs                -- Visual structure comparison (25 checks)
    verify-export-path.mjs           -- GrapesJS export path simulation + FTL validation
    test-edge-cases.mjs              -- Boundary scenario tests (9 cases)
  references/
    dom-structure.md                 -- Marker injection mechanism + export flow
    pattern-rules.md                 -- Three-layer detection algorithm
    template-registry.md             -- block-type -> template mapping (22+ types)
    workflow.md                      -- Per-phase I/O/actor/verification specs
  templates/
    fetched/                         -- Auto-fetched from platform (via template-fetcher)
      *.ftl                          -- FreeMarker template files (40+)
      _registry.json                 -- Machine-readable index

src/                                 -- Project source files
  pages/                             -- HTML pages (source + conversion output)
    clone-wpdemo.archiwp.com/
      preview.html                   -- Original static HTML (cloned page)
      previewNoDesc.html             -- Alternative version without descriptions
  blocks/                            -- Independent FTL files per dynamic module
    {uuid}.ftl                       -- FreeMarker template (one per module)
  reports/                           -- Conversion reports
    dynamic_page_report.json         -- Detection + injection + validation report
  fetch_config/                      -- Template fetch configurations
  tools/                             -- Dev tools (API tester, CORS proxy)
  docs/                              -- Project documentation
```

## Scripts

### `convert-dynamic.mjs`

Main conversion script. Accepts any static HTML and outputs a dynamic version with FreeMarker module markers.

| Arg | Default | Description |
|-----|---------|-------------|
| `--input` | (必需，无默认值) | Input HTML file |
| `--output` | `src/Generate/YYYY-MM-DD_HH-mm-ss/pages/dynamic_<input>.html` | Output HTML file (可选，默认自动生成时间戳目录) |
| `--auto` | off | Skip user confirmation, auto-apply all detections |

Outputs (生成到 `src/Generate/YYYY-MM-DD_HH-mm-ss/` 下):
- `pages/dynamic_<input>.html` — Converted HTML with dynamic module markers (templates referenced, not inlined)
- `reports/dynamic_<input>_report.json` — Detection + injection + validation report (includes ftlOutputPath)
- `blocks/{uuid}.ftl` — Independent FreeMarker template file per dynamic module

### `verify-output.mjs`

73-point verification checklist covering DOM hierarchy, attributes, templates, static preservation, scripts, and CSS.

```bash
node verify-output.mjs <dynamic_file> <original_file>
```

### `verify-js-syntax.mjs`

Validates JavaScript syntax and runtime execution of all embedded scripts, including the Model Setup Script. Detects premature `</script>` tag termination and FreeMarker-only blocks.

### `verify-visual.mjs`

Structural comparison between original and dynamic HTML: CSS integrity, static section content preservation, dynamic section inner HTML, top-level element count, inline styles, and image counts (25 checks).

### `verify-export-path.mjs`

Simulates the GrapesJS editor export flow: verifies `blocks/` directory and .ftl files, executes Model Setup Script in VM sandbox with mock `fetch()`, verifies `__DYNAMIC_MODULES__` registration and `templatePaths` mapping, simulates `handleGeneralBlock()` for each component, and runs `inject(editor)` with mock editor.

### `test-edge-cases.mjs`

Tests 9 boundary scenarios: empty file, no sections, all static, pure product list, article list, mixed content, insufficient items, inline script with `$`, and 20-section stress test.

## Integration with clone-website

```
clone-website                    →  inject-to-editor.js (17 static sections)
    ↓
Phase 1-2: Detect + Confirm     →  User confirms which are dynamic
    ↓
Phase 3: Marker Injection        →  inject-to-editor.js v2 (14 static + 3 dynamic)
```

The `/convert-dynamic` command can run:

- Automatically after `/clone-website` (integrated mode)
- Standalone on any `inject-to-editor.js` file

## Integration with template-fetcher

Templates need to be fetched before conversion:

```
/fetch-templates -t dynamic      →  templates/fetched/*.ftl + _registry.json
    ↓
/convert-dynamic                 →  Uses templates for marker injection
```

## Detection Intelligence (v4 Improvements)

The three-layer detection has been enhanced with:

- **Deep container search** (up to 5 levels deep) to find repeating patterns inside nested structures like `.carousel-track > .product-card`
- **CSS class name semantic analysis** — detects `product-card`, `article-card`, etc. as strong type signals
- **Static section exclusion** — automatically filters out `about-us`, `why-choose`, `solutions`, `cta-section`, `hero-banner`, `footer`, `header`, `contact-us` and similar sections that have repeating sub-elements but are clearly not dynamic data lists
- **Product list vs category distinction** — `prodList` (flat item list) vs `groupProduct` (category navigation) based on item count and link diversity
- **Date format detection** — supports "25 December 2025", ISO dates, `<time>` tags, and `.date` class patterns

## Risk Assessment

- **Original HTML visible in editor but FreeMarker used for export (mismatch)**: Low severity. By design — same as how the editor normally works. Status: **Accepted**
- **Missing `freemakerHtml` on model**: Medium severity. Always verify model property after injection. Status: **Mitigated via data-freemaker-html-available attribute + model setup script**
- **`developer-node-component` init breaks with unknown inner HTML**: Low severity. Tested: `init()` only cares about parent lookup and attribute binding. Status: **Verified safe**
- **Detection false positives/negatives**: Medium severity. Three-layer scoring + static exclusion patterns mitigate most cases. Status: **Mitigated**
- **`data-new-auto-uuid` not set**: Resolved. Now always set to match `data-block-uuid`. Status: **Fixed**

## Verification Results (v7)

Full test suite (`npm test`) against `src/pages/clone-wpdemo.archiwp.com/preview.html` → `src/Generate/<timestamp>/pages/dynamic_preview.html` + `src/Generate/<timestamp>/blocks/*.ftl`:

Key verified facts:
- 3 dynamic modules injected: `groupProduct_new`, `prodlist`, `Articlelist`
- 3 synthesized .ftl files output to `src/Generate/<timestamp>/blocks/` — preserving original CSS classes
- FTL files contain original HTML structure (`.hot-products`, `.product-card`, `.article-card`, etc.)
- FTL files contain `[@api]`, `[#list]`, FreeMarker variable interpolations
- 9 static sections verified 100% unchanged
- All original JS scripts preserved (Hero/Product Carousel, Counter Animation, Fade-in)
- All CSS styles preserved including responsive rules
- `inject(editor)` correctly loads .ftl via `fetch()` and sets `freemakerHtml`, `appId`, `appIsDev`
- 9 edge cases handled: empty, no sections, all static, pure lists, mixed, few items, inline script, 20 sections
