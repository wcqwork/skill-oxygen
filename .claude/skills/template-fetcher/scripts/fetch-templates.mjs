#!/usr/bin/env node

/**
 * Template Fetcher — Automated FreeMarker template downloader from Leadong dev platform.
 *
 * Usage: node fetch-templates.mjs [options]
 * See SKILL.md for full documentation.
 */

import { chromium } from 'playwright';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const BASE_URL = 'http://dev.leadong.com';
const LOGIN_URL = `${BASE_URL}/login`;
const APP_LIST_URL = `${BASE_URL}/app/faced/list`;
const FILE_LIST_URL = `${BASE_URL}/app/faced/file/list`;
const FILE_CONTENT_URL = `${BASE_URL}/app/faced/get/file`;

const CREDENTIALS = {
  username: 'leadong-yiyongjie',
  password: '538421769yyjtt',
};

const PAGE_SIZE = 30;

const TYPE_ALIASES = {
  dynamic: '14',
  block: '1',
  component: '0',
  template: '3',
  'new-block': '20',
  '4.0-block': '50',
  '4.0-page': '51',
  'new-comp': '13',
};

const TYPE_LABELS = {
  '0': '组件',
  '1': '区块',
  '3': '模板',
  '4': '容器控件',
  '7': '最小节点容器',
  '9': '内置插件',
  '12': '未知(12)',
  '13': '新版组件',
  '14': '动态组件(新版编辑器)',
  '15': '未知(15)',
  '20': '新版编辑器区块',
  '50': '4.0区块',
  '51': '4.0页面',
};

const NEW_EDITOR_TYPES = new Set(['14', '20', '50', '51', '13', '12', '15']);

function parseArgs(argv) {
  const args = {
    types: null,
    status: '1',
    maxPages: Infinity,
    startPage: 1,
    output: path.resolve(__dirname, '../../dynamic-module-converter/templates/fetched'),
    incremental: false,
    dryRun: false,
    listTypes: false,
    listApps: false,
    appIds: null,
    keyword: null,
    fromJson: null,
    help: false,
  };

  for (let i = 2; i < argv.length; i++) {
    const arg = argv[i];
    switch (arg) {
      case '-t': case '--type':
        args.types = argv[++i].split(',').map(t => TYPE_ALIASES[t] || t);
        break;
      case '-s': case '--status':
        args.status = argv[++i];
        break;
      case '-m': case '--max-pages':
        args.maxPages = parseInt(argv[++i], 10);
        break;
      case '--start-page':
        args.startPage = parseInt(argv[++i], 10);
        break;
      case '-o': case '--output':
        args.output = path.resolve(argv[++i]);
        break;
      case '-i': case '--incremental':
        args.incremental = true;
        break;
      case '--dry-run':
        args.dryRun = true;
        break;
      case '--list-types':
        args.listTypes = true;
        break;
      case '--list-apps':
        args.listApps = true;
        break;
      case '--app-ids':
        args.appIds = argv[++i].split(',');
        break;
      case '-k': case '--keyword':
        args.keyword = argv[++i];
        break;
      case '-j': case '--from-json':
        args.fromJson = argv[++i];
        break;
      case '-h': case '--help':
        args.help = true;
        break;
    }
  }
  return args;
}

function printHelp() {
  console.log(`
Template Fetcher — Download FreeMarker templates from Leadong dev platform

Usage: node fetch-templates.mjs [options]

Options:
  -t, --type <types>    App type filter (comma-separated numbers or aliases)
  -s, --status <n>      App status: 1=近期上线, 4=全部 (default: 1)
  -m, --max-pages <n>   Max pages to scan (30 apps/page)
  --start-page <n>      Starting page number (default: 1)
  -o, --output <dir>    Output directory
  -i, --incremental     Skip apps already in _registry.json
  --dry-run             List matching apps, don't download
  --list-types          Show app type distribution
  --list-apps           List matched apps without downloading
  --app-ids <ids>       Fetch specific app IDs only (comma-separated)
  -k, --keyword <text>  Filter by app name keyword
  -j, --from-json <paths>  Load app list from local JSON file(s) (comma-separated),
                           skip paginated scan. Supports encodePkId and appNo fields.
  -h, --help            Show this help

Type Aliases: dynamic=14, block=1, component=0, template=3,
             new-block=20, 4.0-block=50, 4.0-page=51, new-comp=13
`);
}

async function login(page) {
  console.log('Logging in...');
  await page.goto(LOGIN_URL, { waitUntil: 'networkidle' });
  await page.fill('input[name="username"], input[type="text"]', CREDENTIALS.username);
  await page.fill('input[name="password"], input[type="password"]', CREDENTIALS.password);
  await page.click('button[type="submit"], .login-btn, button:has-text("登录")');
  await page.waitForURL('**/app/**', { timeout: 15000 });
  console.log('Login successful');
}

async function fetchAppList(page, pageNum, appStatus) {
  const url = `${APP_LIST_URL}?pageNum=${pageNum}&manageFlag=1&appStatus=${appStatus}`;
  const response = await page.evaluate(async (url) => {
    const resp = await fetch(url, { credentials: 'include' });
    return resp.json();
  }, url);
  return response.result || { pageApps: [], totalCount: 0 };
}

function matchApp(app, args) {
  if (args.appIds) {
    return args.appIds.includes(app.encodePkId);
  }
  if (args.keyword && !app.appName.includes(args.keyword)) {
    return false;
  }
  if (args.types) {
    return args.types.includes(String(app.appType));
  }
  return app.supportNewEditor === '1' || app.supportNewEditor === 1 || NEW_EDITOR_TYPES.has(String(app.appType));
}

async function fetchFileList(page, appId) {
  const url = `${FILE_LIST_URL}?appId=${appId}&frontendType=1&terminalType=0&styleId=-1`;
  const response = await page.evaluate(async (url) => {
    const resp = await fetch(url, { credentials: 'include' });
    return resp.json();
  }, url);
  const pages = response?.result?.htmlFiles?.pages || [];
  return pages;
}

async function fetchFileContent(page, fileId) {
  const url = `${FILE_CONTENT_URL}?fileId=${fileId}&fileType=0&terminalType=0&styleId=-1`;
  const response = await page.evaluate(async (url) => {
    const resp = await fetch(url, { credentials: 'include' });
    return resp.json();
  }, url);
  return response?.result?.randerContent || '';
}

function extractBlockType(htmlContent) {
  const blockTypeMatch = htmlContent.match(/data-block-type=["']([^"']+)["']/);
  const blockUuidMatch = htmlContent.match(/data-block-uuid=["']([^"']+)["']/);
  return {
    blockType: blockTypeMatch?.[1] || null,
    blockUuid: blockUuidMatch?.[1] || null,
  };
}

function getFileName(blockType, blockUuid, appNo) {
  if (!blockType) return null;
  if (appNo) {
    return `${blockType}_${appNo}.ftl`;
  }
  if (blockType === 'phoenix_element_dynamicComponents' && blockUuid) {
    return `${blockType}_${blockUuid}.ftl`;
  }
  return `${blockType}.ftl`;
}

async function main() {
  const args = parseArgs(process.argv);

  if (args.help) {
    printHelp();
    process.exit(0);
  }

  fs.mkdirSync(args.output, { recursive: true });

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();
  const page = await context.newPage();

  try {
    await login(page);

    const allApps = [];

    if (args.fromJson) {
      const jsonPaths = args.fromJson.split(',');
      for (const jp of jsonPaths) {
        const resolved = path.resolve(jp.trim());
        console.log(`Loading apps from JSON: ${resolved}`);
        const raw = JSON.parse(fs.readFileSync(resolved, 'utf-8'));
        const apps = Array.isArray(raw) ? raw : [raw];
        for (const app of apps) {
          if (args.keyword && !app.appName.includes(args.keyword)) continue;
          allApps.push(app);
        }
      }
      console.log(`Loaded ${allApps.length} apps from JSON file(s)`);
    } else {
      let pageNum = args.startPage;
      let totalCount = Infinity;

      console.log('Scanning app list...');

      while (pageNum <= args.startPage + args.maxPages - 1) {
        const result = await fetchAppList(page, pageNum, args.status);
        totalCount = result.totalCount || 0;
        const apps = result.pageApps || [];

        if (apps.length === 0) break;

        for (const app of apps) {
          if (matchApp(app, args)) {
            allApps.push(app);
          }
        }

        const scanned = pageNum * PAGE_SIZE;
        process.stdout.write(`\rScanned page ${pageNum} (${Math.min(scanned, totalCount)}/${totalCount} apps, ${allApps.length} matched)`);

        if (scanned >= totalCount) break;
        pageNum++;
      }

      console.log(`\n`);
    }

    console.log(`Found ${allApps.length} matching apps`);

    if (args.listTypes) {
      const typeCounts = {};
      const firstPageResult = await fetchAppList(page, 1, args.status);
      console.log(`\nTotal apps: ${firstPageResult.totalCount}`);
      console.log('\nNote: Full type distribution requires scanning all pages.');
      console.log('Scanned apps type distribution:');
      for (const app of allApps) {
        const label = TYPE_LABELS[app.appType] || `未知(${app.appType})`;
        typeCounts[label] = (typeCounts[label] || 0) + 1;
      }
      for (const [label, count] of Object.entries(typeCounts).sort((a, b) => b[1] - a[1])) {
        console.log(`  ${label}: ${count}`);
      }
      return;
    }

    if (args.listApps) {
      console.log('\nMatched apps:');
      for (const app of allApps) {
        const label = TYPE_LABELS[app.appType] || `type=${app.appType}`;
        const noTag = app.appNo ? ` appNo:${app.appNo}` : '';
        console.log(`  [${app.encodePkId}] ${app.appName} (${label}${noTag})`);
      }
      return;
    }

    if (args.dryRun) {
      console.log('\n[DRY RUN] Would download templates for:');
      for (const app of allApps) {
        const noTag = app.appNo ? ` appNo:${app.appNo}` : '';
        console.log(`  ${app.appName} (${app.encodePkId}${noTag})`);
      }
      return;
    }

    const registryPath = path.join(args.output, '_registry.json');
    let existingRegistry = [];
    if (fs.existsSync(registryPath)) {
      try { existingRegistry = JSON.parse(fs.readFileSync(registryPath, 'utf-8')); } catch {}
    }
    const existingIds = new Set(existingRegistry.map(r => r.appId));

    const registry = [...existingRegistry];
    let downloaded = 0;
    let skipped = 0;
    let failed = 0;

    for (let i = 0; i < allApps.length; i++) {
      const app = allApps[i];
      const appId = app.encodePkId;

      if (args.incremental && existingIds.has(appId)) {
        skipped++;
        continue;
      }

      const appLabel = app.appNo ? `${app.appName} (appNo:${app.appNo})` : app.appName;
      process.stdout.write(`\r[${i + 1}/${allApps.length}] Fetching: ${appLabel}...`);

      try {
        const files = await fetchFileList(page, appId);
        if (files.length === 0) {
          console.log(` (no files)`);
          failed++;
          continue;
        }

        const viewFile = files[0];
        const fileId = viewFile.encodePkId;
        const content = await fetchFileContent(page, fileId);

        if (!content) {
          console.log(` (empty content)`);
          failed++;
          continue;
        }

        const { blockType, blockUuid } = extractBlockType(content);
        const fileName = getFileName(blockType, blockUuid, app.appNo) || `unknown_${appId}.ftl`;
        const filePath = path.join(args.output, fileName);

        fs.writeFileSync(filePath, content, 'utf-8');

        const existingIdx = registry.findIndex(r => r.appId === appId);
        const entry = {
          appId,
          appNo: app.appNo || null,
          numericId: viewFile.renderId,
          name: app.appName,
          appType: String(app.appType),
          appTypeLabel: TYPE_LABELS[app.appType] || `未知(${app.appType})`,
          blockType: blockType || 'unknown',
          blockUuid: blockUuid || null,
          fileName,
          contentLength: content.length,
          encodePkId: viewFile.encodePkId,
          renderId: viewFile.renderId,
          fetchedAt: new Date().toISOString(),
          status: 'ok',
        };

        if (existingIdx >= 0) {
          registry[existingIdx] = entry;
        } else {
          registry.push(entry);
        }

        downloaded++;
      } catch (err) {
        console.log(` ERROR: ${err.message}`);
        failed++;
      }
    }

    fs.writeFileSync(registryPath, JSON.stringify(registry, null, 2), 'utf-8');

    console.log(`\n\nDone!`);
    console.log(`  Downloaded: ${downloaded}`);
    console.log(`  Skipped:    ${skipped}`);
    console.log(`  Failed:     ${failed}`);
    console.log(`  Registry:   ${registryPath} (${registry.length} entries)`);

  } finally {
    await browser.close();
  }
}

main().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});
