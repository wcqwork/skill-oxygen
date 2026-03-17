# Template Fetcher Skill

从 Leadong 开发者管理平台自动抓取 FreeMarker 模板到本地，供 `dynamic-module-converter` skill 使用。

**Command**: `/fetch-templates [options]`

## When to Use

- 需要获取/更新管理平台上的动态区块模板
- "抓取模板", "拉取模板", "获取FreeMarker", "sync templates"
- "fetch templates", "download templates", "update templates"
- 搭配 `/convert-dynamic` 前需要先确保本地有最新模板

## Prerequisites

- **Node.js** >= 18
- **Playwright** (`npm i playwright` or `pnpm add playwright`)
- 网络可访问 `dev.leadong.com`

## Architecture

```
Management Platform (dev.leadong.com)
        │
        ▼
┌─────────────────────────────┐
│   1. Login (Playwright)     │ → Session cookie
├─────────────────────────────┤
│   2. Scan App List          │ → Paginated API: /app/faced/list
│      - Filter by appType    │   ?pageNum=N&manageFlag=1&appStatus=1
│      - Filter by keyword    │   Client-side filter on appType field
├─────────────────────────────┤
│   3. For each matched app:  │
│      a. Get file list       │ → /app/faced/file/list?appId=X
│      b. Find view_default   │   frontendType=1 (前台展示)
│      c. Get file content    │ → /app/faced/get/file?fileId=Y
│      d. Extract blockType   │   from data-block-type attribute
│      e. Save .ftl file      │
├─────────────────────────────┤
│   4. Write _registry.json   │ → Full metadata index
└─────────────────────────────┘
```

## Usage

### Basic Commands

```bash
# Fetch all supportNewEditor=1 apps (default)
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs

# Fetch only 动态组件(新版编辑器) type
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs -t dynamic

# Fetch multiple types
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs -t 14,20,50

# List all app types and counts
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs --list-types

# Preview matching apps without downloading
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs --list-apps -t dynamic

# Incremental update (skip existing)
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs -i

# Limit scan to first 3 pages
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs -m 3

# Filter by keyword
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs -k 产品

# Fetch specific app by ID
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs --app-ids auKUfpACdcBh

# Custom output directory
node .claude/skills/template-fetcher/scripts/fetch-templates.mjs -o ./my-templates
```

### CLI Options

| Option | Short | Description | Default |
|--------|-------|-------------|---------|
| `--type <types>` | `-t` | App type filter (comma-separated numbers or aliases) | `supportNewEditor=1` |
| `--status <n>` | `-s` | App status: `1`=近期上线, `4`=全部 | `1` |
| `--max-pages <n>` | `-m` | Max pages to scan (30 apps/page) | all |
| `--start-page <n>` | | Starting page number | `1` |
| `--output <dir>` | `-o` | Output directory | `templates/fetched/` |
| `--incremental` | `-i` | Skip apps already in `_registry.json` | `false` |
| `--dry-run` | | List matching apps, don't download | `false` |
| `--list-types` | | Show app type distribution | |
| `--list-apps` | | List matched apps without downloading | |
| `--app-ids <ids>` | | Fetch specific app IDs only | |
| `--keyword <text>` | `-k` | Filter by app name keyword | |
| `--help` | `-h` | Show help | |

### Type Aliases

| Alias | appType | Label |
|-------|---------|-------|
| `dynamic` | `14` | 动态组件(新版编辑器) |
| `block` | `1` | 区块 |
| `component` | `0` | 组件 |
| `template` | `3` | 模板 |
| `new-block` | `20` | 新版编辑器区块 |
| `4.0-block` | `50` | 4.0区块 |
| `4.0-page` | `51` | 4.0页面 |
| `new-comp` | `13` | 新版组件 |

## Output

### Files

- `templates/fetched/{blockType}.ftl` — FreeMarker template files
- `templates/fetched/{blockType}_{blockUuid}.ftl` — For `phoenix_element_dynamicComponents` variants
- `templates/fetched/_registry.json` — Machine-readable index with all metadata

### Registry Schema

```json
{
  "appId": "auKUfpACdcBh",
  "numericId": 28712,
  "name": "N图册列表",
  "appType": "14",
  "appTypeLabel": "动态组件(新版编辑器)",
  "blockType": "phoenix_blocks_galleryList",
  "blockUuid": "galleryList",
  "fileName": "phoenix_blocks_galleryList.ftl",
  "contentLength": 8883,
  "encodePkId": "ZRUpfAYGKqDO",
  "renderId": 360134,
  "fetchedAt": "2026-03-12T...",
  "status": "ok"
}
```

## Platform API Reference

All APIs are relative to `http://dev.leadong.com` and require session auth (cookie-based).

| Endpoint | Method | Params | Response |
|----------|--------|--------|----------|
| `/app/faced/list` | GET | `pageNum`, `manageFlag=1`, `appStatus` | `{ result: { pageApps[], totalCount } }` |
| `/app/faced/file/list` | GET | `appId`, `frontendType=1`, `terminalType=0`, `styleId=-1` | `{ result: { htmlFiles: { pages[] } } }` |
| `/app/faced/get/file` | GET | `fileId`, `fileType=0`, `terminalType=0`, `styleId=-1` | `{ result: { randerContent } }` |

**Notes**:
- Page size is fixed at 30 (server-controlled)
- `appType` filtering is client-side only; API returns all types per page
- `fileId` = `encodePkId` with last 2 characters removed
- `frontendType=1` = 前台展示 (not backend)

## Integration with dynamic-module-converter

This skill outputs templates that `dynamic-module-converter` consumes:

```
/fetch-templates -t dynamic
    ↓
templates/fetched/*.ftl + _registry.json
    ↓
/convert-dynamic [inject-to-editor.js]
    ↓
inject-to-editor.js with dynamic markers
```

## Workflow for Agent

When user requests `/fetch-templates`:

1. Parse user intent for type/filter/scope
2. Run `node .claude/skills/template-fetcher/scripts/fetch-templates.mjs [options]`
3. Report results: count fetched, any failures
4. If user wants to proceed with conversion, hand off to `/convert-dynamic`
