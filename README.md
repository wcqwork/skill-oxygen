# Skill Oxygen

静态 HTML 页面到动态 FreeMarker 模块的自动化转换工具集。

## 项目简介

Skill Oxygen 是一个基于 Claude Code 的工具集，主要用于将克隆的静态 HTML 页面转换为可在 Leadong 平台编辑器中使用的动态 FreeMarker 模块。项目采用**标记注入而非结构替换**的核心设计理念，100% 保留原始 HTML 结构和样式。

## 核心功能

### 1. Dynamic Module Converter

**静态 HTML → 动态 FreeMarker 模块自动转换**

- 通用的自底向上检测算法，自动识别动态区域（不依赖特定标签）
- 支持克隆静态页面和平台导出页面两种格式
- 注入编辑器标记，以原始 HTML 为骨架合成 FreeMarker 模板
- 支持 22+ 种区块类型（产品列表、文章列表、图库、视频、FAQ 等）

```bash
# 一键转换 + 全套验证
npm test

# 指定 HTML 文件转换
node .claude/skills/dynamic-module-converter/scripts/convert-dynamic.mjs \
  --input src/pages/your-page.html --auto
```

### 2. Template Fetcher

**从开发平台抓取 FreeMarker 模板**

- 基于 Playwright 自动登录并抓取模板
- 支持按类型、关键词、JSON 配置文件过滤
- 输出标准化的模板文件和索引

```bash
# 抓取动态组件模板
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs -t dynamic

# 从 JSON 配置抓取
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs \
  --from-json ./src/fetch_config/prod.json
```

### 3. PUA Skill

**AI 激励引擎**

- 通用方法论，适用于所有任务类型
- 5 步问题解决流程
- 7 项检查清单
- 压力升级机制

## 项目结构

```
skill-oxygen/
├── .claude/skills/                    # Claude Code Skills
│   ├── dynamic-module-converter/      # 动态模块转换器
│   │   ├── scripts/                   # 转换和验证脚本
│   │   ├── templates/fetched/         # 抓取的 FreeMarker 模板
│   │   └── references/                # 参考文档
│   ├── template-fetcher/              # 模板抓取器
│   └── pua/                           # AI 激励引擎
├── src/
│   ├── pages/                         # 源页面
│   │   └── clone-wpdemo.archiwp.com/  # 克隆的演示页面
│   ├── Generate/                      # 转换输出（按时间戳）
│   │   └── YYYY-MM-DD_HH-mm-ss/
│   │       ├── pages/                 # 转换后的 HTML
│   │       ├── blocks/                # 合成的 .ftl 文件
│   │       └── reports/               # 检测和验证报告
│   ├── tools/                         # 开发工具
│   │   ├── api-tester.html            # API 测试页面
│   │   ├── proxy-server.mjs           # CORS 代理服务器
│   │   └── page-renderer.mjs          # FTL 渲染服务
│   ├── fetch_config/                  # 模板抓取配置
│   └── docs/                          # 项目文档
└── package.json
```

## 快速开始

### 安装依赖

```bash
npm install
```

### 完整转换流程

```bash
# 1. 抓取模板（首次或更新时）
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs -t dynamic

# 2. 转换 HTML 页面
npm run convert

# 3. 运行验证套件
npm run verify:all

# 或者一键执行
npm test
```

### 页面渲染服务

```bash
# 启动渲染服务
npm run render-server

# 访问渲染页面
# http://localhost:3457/render?file=src/Generate/<timestamp>/pages/dynamic_preview_inline.html
```

## NPM 脚本

| 命令 | 说明 |
|------|------|
| `npm test` | 转换 + 全套验证 |
| `npm run convert` | 执行转换 |
| `npm run verify` | DOM 结构验证 (73 项) |
| `npm run verify:js` | JS 语法验证 |
| `npm run verify:visual` | 视觉结构对比 |
| `npm run verify:export` | 导出路径模拟 |
| `npm run verify:edge` | 边界场景测试 |
| `npm run verify:all` | 全部验证 |
| `npm run render-server` | 启动页面渲染服务 |

## 技术栈

- **Node.js** >= 18
- **Cheerio** - HTML 解析
- **Inquirer** - 交互式 CLI
- **Playwright** - 浏览器自动化（模板抓取）
- **FreeMarker** - 模板引擎

## 转换流程

```
静态 HTML 页面
      │
      ▼
┌─────────────────────────────┐
│ Phase 1: 通用动态区域识别    │
│ - 自底向上检测重复结构       │
│ - 三层评分算法              │
│ - 静态区块排除              │
└─────────────────────────────┘
      │
      ▼
┌─────────────────────────────┐
│ Phase 2: 用户确认           │
│ - 展示检测到的区块          │
│ - 逐一确认/修改类型         │
└─────────────────────────────┘
      │
      ▼
┌─────────────────────────────┐
│ Phase 3: 标记注入           │
│ - 添加编辑器兼容属性        │
│ - 保留原始 HTML 结构        │
└─────────────────────────────┘
      │
      ▼
┌─────────────────────────────┐
│ Phase 3.5: FTL 模板合成     │
│ - 提取 @api 查询块          │
│ - 合成 FreeMarker 模板      │
│ - 输出独立 .ftl 文件        │
└─────────────────────────────┘
      │
      ▼
┌─────────────────────────────┐
│ Phase 4: 渲染验证           │
│ - DOM 层级检查              │
│ - 属性完整性                │
│ - FTL 文件有效性            │
│ - 视觉样式一致性            │
└─────────────────────────────┘
```

## 支持的区块类型

| 类型 | data-block-type | 说明 |
|------|-----------------|------|
| 产品列表 | `phoenix_blocks_prodlist` | 产品卡片列表 |
| 产品分组 | `phoenix_blocks_groupProduct` | 产品分类导航 |
| 文章列表 | `phoenix_blocks_Articlelist` | 新闻/博客列表 |
| 文章详情 | `phoenix_blocks_articleDetail` | 文章详情页 |
| 图库列表 | `phoenix_blocks_galleryList` | 图片网格/列表 |
| 视频列表 | `phoenix_blocks_videoList` | 视频缩略图列表 |
| 下载列表 | `phoenix_blocks_downloadlist` | 文件下载项 |
| FAQ 列表 | `phoenix_blocks_faqList` | 问答折叠列表 |
| 搜索 | `phoenix_blocks_search` | 站内搜索 |
| 站点地图 | `phoenix_blocks_siteMap` | 网站地图 |

## 开发工具

### API 测试器

打开 `src/tools/api-tester.html` 可测试 renderFreemarker API 接口。

### 代理服务器

```bash
node src/tools/proxy-server.mjs
# 启动在 http://localhost:3456
```

### 页面渲染器

```bash
node src/tools/page-renderer.mjs
# 启动在 http://localhost:3457
```

## 相关文档

- [动态模块转换器指南](src/docs/dynamic-module-converter-guide.md)
- [DOM 结构参考](.claude/skills/dynamic-module-converter/references/dom-structure.md)
- [检测规则](.claude/skills/dynamic-module-converter/references/pattern-rules.md)
- [工作流程](.claude/skills/dynamic-module-converter/references/workflow.md)

## License

ISC
