# Dynamic Module Converter Skill (v4 - Automated Pipeline)

静态 HTML → 动态 FreeMarker 模块自动转换。三层检测算法自动识别动态区域，注入编辑器标记，关联 FreeMarker 模板，同时 **100% 保留原始 HTML 结构和样式**。

**Command**: `/convert-dynamic [--input <file>] [--output <file>] [--auto]`

## Quick Start

```bash
# 安装依赖
npm install

# 一键转换 + 验证
npm test

# 单独转换
npm run convert

# 单独验证
npm run verify

# 自定义输入/输出
node .claude/skills/dynamic-module-converter/scripts/convert-dynamic.mjs \
  --input src/preview.html \
  --output src/dynamic_preview.html \
  --auto
```

## When to Use

- 克隆网站后需要将静态 section 转为动态模块
- "转换动态", "动态模块", "convert dynamic", "inject markers"
- "产品列表动态化", "文章列表动态化", "注入FreeMarker"
- 搭配 `/clone-website` 使用：先克隆 → 再转换

## Core Design Principle: "Add markers, don't replace structure"

For sections identified as dynamic modules:

- **Keep** the original static HTML structure and styles 100% intact
- **Add** editor-compatible attributes and classes so the editor recognizes them as dynamic components
- **Store** FreeMarker source code on the GrapesJS model (not in DOM) for export
- **Result**: Editor displays original cloned layout; export outputs FreeMarker template

## Architecture

```
静态 HTML (preview.html / inject-to-editor.js)
    │
    ▼
┌─────────────────────────────────────────────┐
│  Phase 1: 动态区域识别 (pattern-detector)     │
│  输入: 静态 HTML                              │
│  分析: 语义 + 结构 + 内容特征                   │
│  输出: dynamic-regions.json                   │
│    [{                                        │
│      sectionIndex: 3,                        │
│      type: "prodList",                       │
│      confidence: 0.95,                       │
│      repeatingItemSelector: ".product-card", │
│      fields: [...]                           │
│    }]                                        │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  Phase 2: 用户确认 (mandatory confirmation)   │
│  展示所有 section 让用户逐一确认              │
│  选项: 确认类型 / 修改类型 / 保持静态         │
│  零自动转换 — 必须显式用户批准               │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  Phase 3: 标记注入 (marker injection)         │
│  对确认的动态 section:                        │
│    1. 修改外层包装器类型和类名                │
│    2. 添加 developer-node-component 内层      │
│    3. 原始 <section> HTML 完全不变            │
│    4. 设置 model 属性 (freemakerHtml 等)      │
│  输入: templates/*.ftl                       │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  Phase 4: 渲染验证 (render-verify)            │
│    1. DOM 层级正确                            │
│    2. 属性完整                                │
│    3. model 属性存在                          │
│    4. 视觉样式不变                            │
│    5. 导出路径正确                            │
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

### Post-injection model setup

```javascript
var components = editor.addComponents(markedHtml);
var outerModel = components[0];
var nodeModel = outerModel.findType('developer-node-component')[0];

nodeModel.set('freemakerHtml', FREEMARKER_TEMPLATE_SOURCE);
nodeModel.set('appId', APP_ID);
nodeModel.set('appIsDev', APP_IS_DEV);
nodeModel.set('appVersion', APP_VERSION);
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

Key: As long as `freemakerHtml` is set on the model, export will correctly output FreeMarker.

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

### Phase 1: Three-Layer Detection

**Layer 1 — Structural (tag-based, class-agnostic)** Score: 0-40

- Find sections with 3+ children sharing identical tag signatures (tag name, nesting depth, presence of img/link/heading)
- Class names are ignored (often minified/hashed)

**Layer 2 — URL Pattern Analysis** Score: 0-25

Extract `<a href>` links from each section:

- `/product/`, `/p/`, `/item/` patterns → product
- `/blog/`, `/news/`, `/article/` patterns → article
- `/gallery/`, `/photo/` patterns → gallery
- `/faq/`, `/help/` patterns → FAQ
- YouTube/Vimeo domains, `/video/` → video

**Layer 3 — Content Heuristics** Score: 0-20

- Price regex (`$`, currency symbols) → product
- Date patterns (`<time>`, ISO dates) → article
- `<iframe>` / `<video>` → video
- Accordion pattern → FAQ

**Threshold**: 50/100 for auto-suggestion. Phase 2 presents ALL sections regardless.

### Phase 2: Mandatory User Confirmation

For EACH section in `inject-to-editor.js`:

- Show: section index, brief description, detected type or "static", confidence, evidence
- User options: **Confirm type** / **Change type** (dropdown) / **Keep static**
- Zero automatic conversion — every dynamic conversion requires explicit user approval

### Phase 3: Marker Injection

For each user-confirmed dynamic section:

1. **Modify outer wrapper**: Change `data-gjs-type` from `developer-component-ai` to `developer-component`, add `class="developer-component"`
2. **Add inner marker div**: Insert a `developer-node-component` div between the outer wrapper and the original `<section>`, with required `data-`* attributes
3. **Original `<section>` HTML**: Completely unchanged — same tags, same classes, same styles
4. **Set model properties**: After `editor.addComponents()`, set `freemakerHtml`, `appId`, `appIsDev` on the `developer-node-component` model

### Phase 4: Validation

For each converted section:

- **DOM check**: `developer-component` > `developer-node-component` > original HTML
- **Attribute check**: `data-block-type`, `data-block-uuid`, `data-gjs-type` all present
- **Model check**: `freemakerHtml` is non-empty string
- **Visual check**: Original CSS classes and styles still render correctly
- **Export check**: Simulate export path — `handleGeneralBlock()` would find `freemakerHtml` and replace

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
    verify-output.mjs                -- Output verification (73-point checklist)
  references/
    dom-structure.md                 -- Marker injection mechanism + export flow
    pattern-rules.md                 -- Three-layer detection algorithm
    template-registry.md             -- block-type -> template mapping (22+ types)
    workflow.md                      -- Per-phase I/O/actor/verification specs
  templates/
    fetched/                         -- Auto-fetched from platform (via template-fetcher)
      *.ftl                          -- FreeMarker template files (40+)
      _registry.json                 -- Machine-readable index
```

## Scripts

### `convert-dynamic.mjs`

Main conversion script. Accepts any static HTML and outputs a dynamic version with FreeMarker module markers.

| Arg | Default | Description |
|-----|---------|-------------|
| `--input` | `src/preview.html` | Input HTML file |
| `--output` | `src/dynamic_preview.html` | Output HTML file |
| `--auto` | off | Skip user confirmation, auto-apply all detections |

Outputs:
- `dynamic_preview.html` — Converted HTML with dynamic module markers
- `dynamic_preview_report.json` — Detection + injection + validation report

### `verify-output.mjs`

73-point verification checklist covering DOM hierarchy, attributes, templates, static preservation, scripts, and CSS.

```bash
node verify-output.mjs <dynamic_file> <original_file>
```

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

## Verification Results (v4)

Last run against `src/preview.html` → `src/dynamic_preview.html`:

- **73/73 checks passed** (100%)
- 3 dynamic modules injected: `groupProduct_new`, `prodlist`, `Articlelist`
- 9 static sections verified unchanged
- All original JS scripts preserved (Hero/Product Carousel, Counter Animation, Fade-in)
- All CSS styles preserved including responsive rules
