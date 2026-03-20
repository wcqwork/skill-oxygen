# Dynamic Module Converter 技术文档

> 静态 HTML → 动态 FreeMarker 模块自动转换工具

## 目录

- [1. 功能概述](#1-功能概述)
- [2. 核心设计原则](#2-核心设计原则)
- [3. 整体架构](#3-整体架构)
- [4. Phase 1: 动态区域识别](#4-phase-1-动态区域识别)
  - [4.1 底向上区块发现 (discoverBlocks)](#41-底向上区块发现-discoverblocks)
  - [4.2 四层评分系统 (detectSection)](#42-四层评分系统-detectsection)
  - [4.3 静态排除与类型修正](#43-静态排除与类型修正)
- [5. Phase 2: 用户确认](#5-phase-2-用户确认)
- [6. Phase 3: 标记注入](#6-phase-3-标记注入)
  - [6.1 HTML 标记注入 (injectMarkers)](#61-html-标记注入-injectmarkers)
  - [6.2 FTL 模板合成 (synthesizeFtl)](#62-ftl-模板合成-synthesizeftl)
  - [6.3 字段映射 (applyFieldMapping)](#63-字段映射-applyfieldmapping)
  - [6.4 二级嵌套 FTL 结构](#64-二级嵌套-ftl-结构)
- [7. Phase 4: 验证](#7-phase-4-验证)
- [8. 输出文件说明](#8-输出文件说明)
- [9. 支持的区块类型](#9-支持的区块类型)
- [10. 验证套件](#10-验证套件)
- [11. 使用方法](#11-使用方法)
- [12. 文件结构](#12-文件结构)

---

## 1. 功能概述

Dynamic Module Converter 是一个自动化工具，将克隆的静态 HTML 页面中的动态数据区域（产品列表、文章列表、分类导航等）自动识别并转换为 FreeMarker 动态模块。

**核心能力**：

- **通用检测**：不依赖特定 HTML 标签（如 `<section>`），使用自底向上算法扫描任意 HTML 结构
- **四层评分**：结构特征 + URL 模式 + 内容启发 + CSS 类名签名，综合判断区块类型
- **保留原始样式**：生成的 FTL 模板以原始 HTML 为骨架，仅添加 FreeMarker 语法，100% 保留原始 CSS class 和结构
- **二级嵌套 FTL**：输出平台标准的 `phoenix-container > developer-node-component` 两层包装结构
- **150+ 自动验证**：DOM 结构、属性完整性、JS 语法、视觉保留、导出路径模拟、边缘用例等全方位验证

**工作流程**：

```
静态 HTML (page.html)
    ↓ Phase 1: 自底向上扫描 + 四层评分
    ↓ Phase 2: 用户确认（--auto 跳过）
    ↓ Phase 3: 标记注入 + FTL 合成
    ↓ Phase 4: 自动验证
    ↓
├── dynamic_page.html          (注入标记的 HTML)
├── dynamic_page_report.json   (检测/注入/验证报告)
└── blocks/
    └── {uuid}.ftl             (合成的 FreeMarker 模板)
```

---

## 2. 核心设计原则

### "Add markers, don't replace structure"

对于被识别为动态模块的区块：

1. **保持**原始静态 HTML 结构和样式 100% 不变
2. **添加**编辑器兼容的属性和类名，使编辑器识别为动态组件
3. **合成** FreeMarker 模板：以原始 HTML 为骨架 + 参考模板的 `@api` 查询 + 字段映射
4. **存储** FTL 为独立 `.ftl` 文件，运行时通过 `fetch()` 加载到编辑器 model

### 编辑器兼容性验证

工具的每个输出都经过了平台编辑器代码的验证：

| 平台机制 | 验证方式 | 状态 |
|---------|---------|------|
| `isComponent` 检查 `developer-node-component` class | 注入的 class 包含该标识 | ✅ |
| `init()` 调用 `closestType(DEV_ELEMENT_TYPE)` | 外层 `developer-component` 满足 | ✅ |
| `handlerSetting` 读取 `data-block-type` | 注入的属性值正确 | ✅ |
| `handleGeneralBlock` 读取 `model.get('freemakerHtml')` | `inject()` 通过 `fetch()` 设置 | ✅ |

---

## 3. 整体架构

```
┌────────────────────────────────────────────────────────────┐
│                   convert-dynamic.mjs                       │
│                                                            │
│  ┌─────────────┐   ┌──────────────┐   ┌────────────────┐  │
│  │ Phase 1     │   │ Phase 2      │   │ Phase 3        │  │
│  │ 动态区域识别 │ → │ 用户确认     │ → │ 标记注入       │  │
│  │             │   │              │   │ + FTL合成      │  │
│  │ discoverBlocks│ │ AUTO_MODE    │   │ injectMarkers  │  │
│  │ detectSection │ │ 或 交互确认   │   │ synthesizeFtl  │  │
│  └──────┬──────┘   └──────┬───────┘   └──────┬─────────┘  │
│         │                 │                   │            │
│         ▼                 ▼                   ▼            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Phase 4: 验证                                        │  │
│  │ validateInjection + generateReport                   │  │
│  └──────────────────────────────────────────────────────┘  │
│                           │                                │
│                           ▼                                │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 输出                                                 │  │
│  │ • dynamic_page.html (注入标记)                       │  │
│  │ • blocks/{uuid}.ftl (合成模板)                │  │
│  │ • dynamic_page_report.json (完整报告)                │  │
│  │ • Model Setup Script (嵌入 HTML)                     │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  依赖:                                                      │
│  • cheerio (HTML 解析)                                      │
│  • uuid (生成唯一标识)                                       │
│  • templates/fetched/*.ftl (参考模板库)                      │
│  • templates/fetched/_registry.json (模板索引)               │
└────────────────────────────────────────────────────────────┘
```

---

## 4. Phase 1: 动态区域识别

### 4.1 底向上区块发现 (discoverBlocks)

不依赖 `<section>` 等特定标签，通用扫描整个 DOM 树寻找动态数据列表。

**算法步骤**：

```
Step 1: 全局递归扫描 (scanForRepeats)
├── 从 <body> 开始深度优先遍历（最深 15 层）
├── 跳过排除标签: head, script, style, noscript, svg, iframe 等
├── 跳过整个子树: <header>, <nav>, <footer>
├── 对每个元素：如果有 ≥3 个子元素
│   ├── 计算每个子元素的「标签签名」
│   │   签名格式: tag|img:bool|a:bool|h:bool|d:S/M/L
│   │   例: "div|img:true|a:true|h:true|d:L"
│   ├── 找出出现次数最多的签名
│   ├── 如果 ≥3 个子元素共享相同签名 → 候选重复容器
│   └── 调用 isDataList() 验证是否为数据列表
│       ├── 子元素数量 ≥3
│       ├── classattr/name 属性同质性（排除混合 widget 容器）
│       ├── CSS class 核心同质性
│       │   去掉修饰类: first/last/active, post-*, product_cat-*,
│       │   product_tag-*, col-* 等后对比
│       └── 平均 DOM 深度 ≥2（浅层导航/图标排除）
└── 收集所有候选容器

Step 2: 向上回溯找语义边界
├── 从每个重复容器向上最多 2 级
├── 寻找包含 h1-h6 标题的父元素作为区块边界
│   例: <section><h2>Products</h2><div class="grid">...</div></section>
│   重复容器 = div.grid, 边界 = <section>
└── 无标题则边界 = 重复容器本身

Step 3: 去重
├── 按重复子元素数量降序排列
├── 合并相同边界的重复容器（保留子元素最多的）
└── 过滤嵌套：如果 A 的重复容器是 B 的子级，排除 A
```

**关键函数**：

| 函数 | 作用 | 输入 | 输出 |
|------|------|------|------|
| `discoverBlocks($)` | 发现所有候选动态区块 | cheerio 实例 | `[{el, $el, repeatingContainer}]` |
| `scanForRepeats(el, depth)` | 递归扫描重复结构 | DOM 元素 | 填充 `repeatingContainers[]` |
| `getTagSignature($, el)` | 计算子元素结构签名 | 子元素 | `"div\|img:true\|a:true\|h:false\|d:M"` |
| `isDataList($, containerEl)` | 验证是否为数据列表 | 容器元素 | `boolean` |

### 4.2 四层评分系统 (detectSection)

对每个发现的区块进行四层独立评分，总分 110 分：

#### Layer 1 — 结构检测 (0-40 分)

`analyzeStructure($, $section)`

```
找到区块内「最佳重复容器」（findRepeatingContainer 最深搜索 10 层）
↓
统计重复子元素数量（相同标签签名）
↓
评分:
  ≥9 个重复项 → 40 分
  ≥5 个重复项 → 35 分
  ≥3 个重复项 → 25 分
  <3 个 → 0 分
↓
返回: { score, itemCount, repeatingContainerEl }
```

#### Layer 2 — URL 模式分析 (0-25 分)

`analyzeURLPatterns($, $scoreTarget)`

```
提取区块内所有 <a href="..."> 链接（排除 #, javascript:void 等）
↓
逐个 URL 匹配类型模式:
  /product/, /p/, /item/, /shop/, /catalog/ → prodList
  /blog/, /news/, /article/, /post/        → articleList
  /gallery/, /photo/, /portfolio/          → galleryList
  /faq/, /help/, /support/                 → FAQList
  youtube.com, vimeo.com, /video/          → videoList
  /download/, /resource/, /docs/           → downloadList
↓
计算匹配比例 (matchRatio = 匹配数 / 总链接数)
  ≥80% 匹配 → 25 分
  ≥50% 匹配 → 12 分
  <50% → 0 分
```

#### Layer 3 — 内容启发 (0-20 分)

`analyzeContent($, $scoreTarget)`

```
对区块文本和 DOM 进行 16 项启发规则检测:

  价格符号 ($, €, ¥)                → prodList (15分)
  CTA 文本 (Add to Cart, Buy Now)   → prodList (20分)
  CSS class (product-card, prod-*)   → prodList (18分)
  DOM 元素 ([class*="product"])      → prodList (14分)

  日期格式 (2024-01-01)             → articleList (15分)
  Read More 文本                     → articleList (10分)
  <time> 或 .date 元素               → articleList (12分)

  <video>/<iframe src="youtube">    → videoList (20分)
  手风琴/折叠结构                    → FAQList (20分)
  文件扩展名 (.pdf, .zip)            → downloadList (15分)

取每种类型的最高分作为该类型的得分
```

#### Layer 4 — CSS 类名签名 (0-25 分)

`analyzeClassSignatures($, $scoreTarget)`

```
收集区块内所有元素的 class 属性
↓
对每种类型的签名正则进行匹配:

  prodList 签名:
    /proshow-scroll-item/, /proshow-custom-item/, /proshow-image/,
    /proshow-caption/, /proList/, /star-goods/, /prodlist-box/ 等

  articleList 签名:
    /ArticlePicList_Item/, /Article_Container/, /articalWrap/,
    /articleList-summary/, /artime/, /Artitem/ 等

  groupProduct 签名:
    /prodCategoty-container/, /site-category-list/, /category-item/,
    /r-tabs-nav/, /r-tabs-tab/ 等

  prodDetail 签名:
    /prodDetail_component/, /blockDetail_container/ 等
↓
评分:
  命中 ≥2 个签名 → 25 分
  命中 ≥1 个签名 → 15 分
  无命中 → 0 分
```

#### 综合判定

```
totalScore = 结构 + URL + 内容 + 类名签名 (满分 110)

isDynamic = detectedType != null AND 满足以下任一条件:
  (1) 结构 ≥25 AND URL > 0
  (2) 结构 ≥25 AND 内容 ≥15
  (3) 结构 ≥25 AND 类名签名 ≥25
  (4) 总分 ≥60 AND 结构 ≥25

confidence = totalScore / 110
```

### 4.3 静态排除与类型修正

**静态模式排除**：即使评分通过，以下 class/id 匹配的区块也会被强制标记为静态（当 URL 得分 = 0、内容得分 ≤12、类名签名 = 0 时）：

```
about-us, why-choose, cta-section, solution, feature, counter,
testimonial, hero-banner, footer, header, nav, contact-us,
spacer, banner, navbar, navigation, menu, lang-switch,
follow, social, logo, form, subscribe, copyright
```

**prodList vs groupProduct 修正**：
- 如果 class/id 包含 `category`/`classif`/`group` → 修正为 `groupProduct`
- 如果类名签名命中 `groupProduct` 但当前检测为 `prodList` → 修正为 `groupProduct`

---

## 5. Phase 2: 用户确认

对每个检测到的区块展示信息供用户确认：

```
🔶 Section 0: "products"
   类型: 产品列表 | 得分: 79/110 | 置信度: 72%
   ├─ 结构检测: 12 个重复子元素 (40/40)
   ├─ URL模式: 100% 链接匹配 prodList 模式 (25/25)
   ├─ 内容启发: 检测到 prodList 特征 (14/20)
   └─ ✅ 标记为动态
```

使用 `--auto` 参数可跳过确认，直接应用所有检测结果。

---

## 6. Phase 3: 标记注入

### 6.1 HTML 标记注入 (injectMarkers)

为每个确认的动态区块注入编辑器标记：

**注入前**（原始 HTML）：

```html
<div class="products elements-grid woodmart-products-holder row">
  <div class="product-grid-item">...</div>
  <div class="product-grid-item">...</div>
  <div class="product-grid-item">...</div>
</div>
```

**注入后**（dynamic_page.html 中）：

```html
<div class="developer-component" data-gjs-type="developer-component">
  <div class="backstage-blocksEditor-wrap developer-node-component
              developer-component-newedit block_5421eed41b11"
       data-gjs-type="developer-node-component"
       data-block-type="phoenix_blocks_prodlist"
       data-block-uuid="5421eed41b11"
       data-new-auto-uuid="5421eed41b11"
       data-app-id="eRKAfpUNFbOE"
       data-freemaker-html-available="true">
    <!-- ↓ 原始 HTML 100% 不变 ↓ -->
    <div class="products elements-grid woodmart-products-holder row">
      <div class="product-grid-item">...</div>
      <div class="product-grid-item">...</div>
      <div class="product-grid-item">...</div>
    </div>
    <!-- ↑ 原始 HTML 100% 不变 ↑ -->
  </div>
</div>
```

**注入的属性说明**：

| 属性 | 值 | 作用 |
|------|-----|------|
| `data-gjs-type="developer-component"` | 外层 | 编辑器组件类型标识 |
| `data-gjs-type="developer-node-component"` | 内层 | 动态节点类型标识 |
| `data-block-type` | 如 `phoenix_blocks_prodlist` | 区块数据源类型 |
| `data-block-uuid` | 12 位唯一 ID | 区块唯一标识 |
| `data-new-auto-uuid` | 同 block-uuid | 编辑器内部自动化 UUID |
| `data-app-id` | 模板应用 ID | 关联模板来源 |
| `data-freemaker-html-available` | `"true"` | 标记有 FTL 内容可用 |

### 6.2 FTL 模板合成 (synthesizeFtl)

核心创新：以**原始 HTML 为骨架**合成 FreeMarker 模板，而非直接复制参考模板。

**合成流程**：

```
输入:
  • 原始 section HTML (来自 page.html)
  • 参考模板 (templates/fetched/*.ftl)
  • 字段映射规则 (FIELD_MAPPING)

Step 1: 提取参考模板的关键元素
  extractApiBlock() →
    ├── apiTag:              [@api method="post" url="..." query='...']
    ├── queryStr:            GraphQL 查询字符串
    ├── initScript:          jQuery 初始化脚本
    ├── outerContainerAttrs: phoenix-container 属性
    ├── nodeComponentAttrs:  developer-node-component 属性
    │   ├── data-block-list-setting
    │   ├── data-default-setting (含完整 JSON 配置)
    │   └── class
    ├── nodeComponentStyle:  CSS 变量样式块
    └── langCodeBlock:       多语言样式条件块

Step 2: 定位原始 HTML 中的重复结构
  findRepeatingContainer() → 找到产品卡片容器
  识别重复子元素 (如 12 个 div.product-grid-item)

Step 3: 字段映射替换 (保留原始结构)
  保留第 1 个列表项作为模板
  删除第 2~N 个重复项
  对模板项内的元素做字段替换:
    <img src="static.jpg"> → <img src="${product.photoUrlList[0]!}">
    <a href="/product/xxx">  → <a href="${product.prodUrl!'#'}">
    <h3>Product Name</h3>   → <h3>${product.prodName!?html}</h3>
    <span class="price">$99 → <span class="price">${product.prodPrice!}

Step 4: 包裹 FreeMarker 指令
  [#if data?? && data.productList??]
  [#list data.productList.list as product]
    <div class="product-grid-item">... (带字段替换的原始 HTML) ...</div>
  [/#list]
  [#else]
    <div class="no-data">No content available</div>
  [/#if]

Step 5: 包裹 @api 数据查询
  根据容器层级判断 @api 位置:
    容器 = 根元素 → @api 包裹整个内部
    容器 ≠ 根元素 → @api 只包裹容器的父级

Step 6: 组装二级嵌套结构
  phoenix-container → langCodeBlock → developer-node-component → style → 原始HTML
```

### 6.3 字段映射 (applyFieldMapping)

每种动态类型有预定义的字段映射规则：

| 类型 | 列表表达式 | 遍历变量 | 图片 | 标题 | 链接 | 价格/日期 |
|------|-----------|---------|------|------|------|----------|
| prodList | `data.productList.list` | `product` | `photoUrlList[0]` | `prodName` | `prodUrl` | `prodPrice` |
| articleList | `data.articleList.list` | `article` | `photoUrlNormal` | `articleTitle` | `articleUrl` | `publishTime` |
| groupProduct | `data.productGroupList` | `group` | `groupPhotoUrlList[0]` | `groupName` | `groupUrl` | - |
| galleryList | `data.galleryList.list` | `gallery` | `photoUrl` | `galleryTitle` | `galleryUrl` | - |
| videoList | `data.videoList.list` | `video` | `videoCoverUrl` | `videoTitle` | `videoUrl` | - |
| FAQList | `data.faqList.list` | `faq` | - | `faqQuestion` | - | - |
| downloadList | `data.downloadList.list` | `download` | - | `downloadTitle` | `downloadUrl` | - |

**映射规则**（`applyFieldMapping` 函数）：

1. **图片** `<img>` → `src` 替换为动态字段，`alt` 替换为名称字段
2. **链接** `<a>` → `href` 替换为 URL 字段，纯文本链接的内容替换为标题字段
3. **标题** `h1-h6` → 不含 `<a>` 的标题直接替换为标题字段
4. **名称容器** `[class*="name"], [class*="title"]` → 替换为标题字段
5. **日期** `[class*="date"], [class*="time"], <time>` → 替换为日期字段
6. **价格** `[class*="price"]` → 替换为价格字段
7. **描述** `[class*="desc"], [class*="brief"], [class*="summary"]` → 替换为描述字段

### 6.4 二级嵌套 FTL 结构

生成的 `.ftl` 文件严格遵循平台标准的两级包装：

```
<div class="block_{uuid}" data-gjs-type="phoenix-container" data-strong="1">
                                                    ← 外层: phoenix-container

    [#assign specialLanCode = ["3", "45", "42", "32", "29"]]
    [#if __current_site_lanCode__?? && ...]         ← 多语言样式条件块
        <style data-collect='1'>...</style>
    [/#if]

    <div class="backstage-blocksEditor-wrap"
         data-block-uuid="{uuid}"
         data-gjs-type="developer-node-component"
         data-block-list-setting="dataSelect,pageNumber"
         data-block-type="phoenix_blocks_prodlist"
         data-default-setting={...JSON配置...}>     ← 内层: developer-node-component

        <style>                                     ← CSS 变量样式块
        [data-new-auto-uuid="${pageNodeId!''}"] {
            --color-match-setting1: var(--ld-main1, #000000);
        }
        </style>

        <div class="products elements-grid ...">    ← 原始 HTML 结构开始
            [@api method="post" url="..." query='...']
                [#list ...]
                    <div class="product-grid-item">...</div>
                [/#list]
                <input type="hidden" name="totalRow" ...>
                <input type="hidden" name="pageNumber" ...>
            [/@api]
        </div>                                      ← 原始 HTML 结构结束

    </div>                                          ← 关闭 developer-node-component
</div>                                              ← 关闭 phoenix-container
```

**结构元素来源**：

| 元素 | 来源 | 提取函数 |
|------|------|---------|
| `phoenix-container` 属性 | 参考模板第 1 个 `<div>` | `extractOuterContainerAttrs()` |
| `developer-node-component` 属性 | 参考模板的 `data-gjs-type="developer-node-component"` div | `extractNodeComponentAttrs()` |
| `data-default-setting` JSON | 参考模板（含大括号平衡解析） | `parseNodeDivAttrs()` |
| CSS 变量 `<style>` | 参考模板 `[data-new-auto-uuid...]` 块 | `extractNodeComponentStyle()` |
| 多语言 `[#assign]` + `[#if]` | 参考模板 | `extractLangCodeBlock()` |
| 内部 HTML + @api | 原始 HTML + 参考模板 GraphQL | `synthesizeFtl()` |

---

## 7. Phase 4: 验证

每个注入的动态模块自动执行 4 项验证：

```
validateInjection($, uuid)
├── DOM 层级检查
│   developer-component > developer-node-component > 原始 HTML
├── 属性完整性
│   data-block-type ✓  data-gjs-type ✓  data-new-auto-uuid ✓
├── FreeMarker 标记
│   data-freemaker-html-available = "true"
└── 原始内容保留
    内层 HTML 长度 > 50 字符，包含 HTML 标签
```

---

## 8. 输出文件说明

### dynamic_page.html

原始 HTML 的增强版本，动态区块被注入了编辑器标记。同时在 `</body>` 前插入 Model Setup Script。

**Model Setup Script** 结构：

```javascript
window.__DYNAMIC_MODULES__ = {
  templatePaths: {
    "5421eed41b11": "blocks/5421eed41b11.ftl"
  },
  modules: [{
    uuid: "5421eed41b11",
    blockType: "phoenix_blocks_prodlist",
    appId: "eRKAfpUNFbOE",
    templatePath: "blocks/5421eed41b11.ftl",
  }],
  inject: async function(editor) {
    // 遍历每个模块，fetch .ftl 文件内容
    // 设置 model.freemakerHtml = ftlContent
    // 设置 model.appId, model.appIsDev
  }
};
```

**编辑器导出流程**：

```
用户点击导出/保存
  ↓
replaceFreemakerCode() 遍历所有 DEV_ELEMENT_TYPE model
  ↓
handleGeneralBlock() 读取 model.get('freemakerHtml')
  ↓
freemakerHtml 存在 → 替换 DOM 为 FreeMarker 源码
  ↓
最终 HTML 包含完整 FreeMarker 模板代码
```

### blocks/{uuid}.ftl

合成的 FreeMarker 模板文件，保留原始 HTML 的 CSS class 和结构，同时包含：

- `[@api]` GraphQL 数据查询
- `[#list]` 循环遍历数据
- FreeMarker 变量插值 (`${product.prodName!?html}`)
- `[#if]` 空数据降级处理
- 分页隐藏字段 (`totalRow`, `pageNumber`, `pageSize`)
- 二级嵌套包装结构

### dynamic_page_report.json

完整的转换报告，包含：

```json
{
  "timestamp": "2026-03-19T...",
  "inputFile": "src/pages/page.html",
  "outputFile": "src/Generate/YYYY-MM-DD_HH-mm-ss/pages/dynamic_page.html",
  "totalSections": 1,
  "dynamicSections": 1,
  "staticSections": 0,
  "detections": [{
    "sectionIndex": 0,
    "sectionDescription": "products",
    "detectedType": "prodList",
    "confidence": 0.72,
    "scores": { "structural": 40, "urlPattern": 25, "contentHeuristic": 14, "classSignature": 0, "total": 79 },
    "evidence": ["结构检测: 12 个重复子元素 (40/40)", ...],
    "isDynamic": true
  }],
  "injections": [{ "success": true, "blockType": "phoenix_blocks_prodlist", "uuid": "5421eed41b11", ... }],
  "validations": [{ "uuid": "5421eed41b11", "checks": [{ "name": "DOM层级", "pass": true }, ...] }]
}
```

---

## 9. 支持的区块类型

| 检测类型 | 平台 blockType | 数据源 | 模板数 |
|---------|---------------|--------|--------|
| prodList | `phoenix_blocks_prodlist` | 产品列表 GraphQL | 22 |
| articleList | `phoenix_blocks_Articlelist` | 文章列表 GraphQL | 41 |
| groupProduct | `phoenix_blocks_groupProduct_new` | 产品分类 GraphQL | 8 |
| prodDetail | `phoenix_blocks_prodDetail` (仅检测) | 产品详情 GraphQL | 1 |
| galleryList | `phoenix_blocks_galleryList` | 图库列表 | 0 (保留检测) |
| videoList | `phoenix_blocks_videoList` | 视频列表 | 0 (保留检测) |
| downloadList | `phoenix_blocks_downloadlist` | 下载列表 | 0 (保留检测) |
| FAQList | `phoenix_blocks_faqList` | FAQ 列表 | 0 (保留检测) |

**类型区分速查**：

| 特征 | prodList | articleList | groupProduct |
|------|----------|-------------|--------------|
| 价格 | ✅ 有 | ❌ 无 | 分类无/产品有 |
| 日期 | ❌ 无 | ✅ 有 | ❌ 无 |
| 分类标签 | ❌ 无 | 可选 | ✅ 有 |
| 特征 class | `proshow-*` | `ArticlePicList_*` | `prodCategoty-*` |
| 嵌套层级 | 单层 | 单层 | 二层 |

---

## 10. 验证套件

工具附带 5 个独立的验证脚本，总计 150+ 检查项：

| 脚本 | npm 命令 | 检查项 | 验证内容 |
|------|---------|--------|---------|
| `verify-output.mjs` | `npm run verify` | ~40 项 | DOM 层级、属性完整性、FTL 文件、静态区块、脚本/CSS 保留 |
| `verify-js-syntax.mjs` | `npm run verify:js` | 每个 `<script>` | JS 语法验证、Model Setup Script 运行时执行 |
| `verify-visual.mjs` | `npm run verify:visual` | ~6 项 | CSS 一致性、顶层元素数量、图片/样式数量、动态区块内容保留 |
| `verify-export-path.mjs` | `npm run verify:export` | ~31 项 | blocks/ 目录、FTL 文件映射、VM 沙箱执行、inject() 模拟 |
| `test-edge-cases.mjs` | `npm run verify:edge` | 9 个场景 | 空文件、无区块、全静态、纯列表、混合内容、少量项、内联脚本、压力测试 |

**一键运行全部验证**：

```bash
npm test
# 等价于: npm run convert && npm run verify:all
```

---

## 11. 使用方法

### 基本用法

```bash
# 安装依赖
npm install

# 转换 page.html (自动模式)
npm run convert

# 指定任意 HTML 文件（输出自动生成到 src/Generate/YYYY-MM-DD_HH-mm-ss/ 下）
node .claude/skills/dynamic-module-converter/scripts/convert-dynamic.mjs \
  --input src/pages/my-page.html --auto

# 指定输入和自定义输出路径
node .claude/skills/dynamic-module-converter/scripts/convert-dynamic.mjs \
  --input src/pages/my-page.html \
  --output custom/path/dynamic_my-page.html \
  --auto

# 转换 + 全套验证
npm test
```

### 参数说明

| 参数 | 必需 | 默认值 | 说明 |
|------|------|--------|------|
| `--input` | ✅ | 无 | 输入的静态 HTML 文件路径 |
| `--output` | ❌ | `src/Generate/YYYY-MM-DD_HH-mm-ss/pages/dynamic_<原文件名>.html` | 输出文件路径（默认自动生成时间戳目录） |
| `--auto` | ❌ | 关闭 | 自动模式，跳过用户确认 |

### 前置条件

1. `templates/fetched/` 目录包含参考 FTL 模板（通过 `/template-fetcher` 获取）
2. `templates/fetched/_registry.json` 模板索引文件存在
3. Node.js 环境，依赖: `cheerio`, `uuid`

---

## 12. 文件结构

```
.claude/skills/dynamic-module-converter/
├── SKILL.md                          ← Skill 入口文档
├── scripts/
│   ├── convert-dynamic.mjs           ← 主转换脚本 (1350 行)
│   │   ├── Phase 1: discoverBlocks + detectSection
│   │   ├── Phase 2: 用户确认 (AUTO_MODE)
│   │   ├── Phase 3: injectMarkers + synthesizeFtl
│   │   ├── Phase 4: validateInjection
│   │   └── 输出: HTML + FTL + Report
│   ├── verify-output.mjs             ← DOM 结构验证
│   ├── verify-js-syntax.mjs          ← JS 语法验证
│   ├── verify-visual.mjs             ← 视觉结构对比
│   ├── verify-export-path.mjs        ← 导出路径模拟
│   └── test-edge-cases.mjs           ← 边缘场景测试
├── references/
│   └── block-type-signatures.md      ← 区块类型特征文档 (从 62 个 FTL 提取)
└── templates/
    └── fetched/                      ← 平台参考模板库
        ├── _registry.json            ← 模板索引 (blockType → fileName → appId)
        ├── phoenix_blocks_prodlist_*.ftl      (22 个)
        ├── phoenix_blocks_Articlelist_*.ftl    (41 个)
        └── phoenix_blocks_groupProduct_new_*.ftl (8 个)

src/                                  ← 转换输出 (自动生成)
├── page.html                         ← 原始静态 HTML
├── dynamic_page.html                 ← 注入标记后的 HTML
├── dynamic_page_report.json          ← 转换报告
└── blocks/
    └── {uuid}.ftl                    ← 合成的 FreeMarker 模板
```
