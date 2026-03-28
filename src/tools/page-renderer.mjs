#!/usr/bin/env node
/**
 * page-renderer.mjs — Node.js 页面渲染服务
 *
 * 读取内联版 HTML（FTL 已嵌入），调用 renderFreemarker API 将 FTL 渲染为真实 HTML，
 * 返回完整的服务端渲染后 document。
 *
 * Usage:
 *   node src/tools/page-renderer.mjs
 *
 * Endpoints:
 *   GET /render?file=<path>   — 读取内联 HTML → 渲染 FTL → 返回完整 HTML document
 *   GET /local?file=<path>    — 静态文件服务
 *   GET /list?dir=<path>      — 列出目录内容
 *   GET /                     — 服务状态
 */

import http from 'node:http';
import fs from 'node:fs';
import nodePath from 'node:path';
import { fileURLToPath } from 'node:url';
import vm from 'node:vm';

const __filename = fileURLToPath(import.meta.url);
const __dirname = nodePath.dirname(__filename);
const PROJECT_ROOT = nodePath.resolve(__dirname, '../..');

const PORT = parseInt(process.env.RENDER_PORT || '3457', 10);

const RENDER_API_URL = 'http://website.leadong.com/phoenix2/composite/render/block/renderFreemarker';

const MIME_MAP = {
  '.html': 'text/html; charset=utf-8',
  '.htm': 'text/html; charset=utf-8',
  '.ftl': 'text/plain; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.mjs': 'application/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.gif': 'image/gif',
};

// ─── Config file support ───

const CONFIG_PATH = nodePath.join(__dirname, '.render-config.json');

function loadConfig() {
  if (fs.existsSync(CONFIG_PATH)) {
    try {
      return JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf-8'));
    } catch (_) { /* ignore */ }
  }
  return {};
}

function decodeJwtPayload(token) {
  if (!token) return null;
  try {
    const parts = token.split('.');
    if (parts.length !== 3) return null;
    return JSON.parse(Buffer.from(parts[1], 'base64').toString('utf-8'));
  } catch (_) { return null; }
}

function checkCredentialStatus(config) {
  const now = Math.floor(Date.now() / 1000);
  const result = { hasAuth: false, hasCookie: false, jwtExp: null, jwtExpDate: null, expired: null, remainingSec: null };

  if (config.authorization) {
    result.hasAuth = true;
    const payload = decodeJwtPayload(config.authorization);
    if (payload && payload.exp) {
      result.jwtExp = payload.exp;
      result.jwtExpDate = new Date(payload.exp * 1000).toLocaleString('zh-CN', { timeZone: 'Asia/Shanghai' });
      result.expired = now > payload.exp;
      result.remainingSec = payload.exp - now;
    }
  }
  if (config.cookie) {
    result.hasCookie = true;
  }
  return result;
}

// ─── Path safety ───

function safePath(requestedPath) {
  const cleaned = decodeURIComponent(requestedPath).replace(/\\/g, '/');
  if (cleaned.includes('..')) return null;
  const abs = nodePath.resolve(PROJECT_ROOT, cleaned);
  if (!abs.startsWith(PROJECT_ROOT)) return null;
  return abs;
}

// ─── Base64 helpers ───

function utf8ToBase64(str) {
  return Buffer.from(str, 'utf-8').toString('base64');
}

function base64ToUtf8(b64) {
  return Buffer.from(b64, 'base64').toString('utf-8');
}

// ─── Parse __DYNAMIC_MODULES__ from inline HTML ───

function parseDynamicModules(html) {
  const scriptRe = /<script[^>]*>([\s\S]*?)<\/script>/gi;
  let targetScript = null;
  let m;
  while ((m = scriptRe.exec(html)) !== null) {
    if (m[1].includes('__DYNAMIC_MODULES__')) {
      targetScript = m[1];
    }
  }
  if (!targetScript) return null;

  const mockWindow = {};
  const context = vm.createContext({ window: mockWindow, console: { log() {}, error() {}, warn() {} } });

  try {
    new vm.Script(targetScript).runInContext(context);
    return mockWindow.__DYNAMIC_MODULES__ || null;
  } catch (err) {
    console.error('[parseDynamicModules] VM exec error:', err.message);
    return null;
  }
}

// ─── Call renderFreemarker API ───

function callRenderApi(ftlContent, credentials) {
  const freemarkerContent = utf8ToBase64(ftlContent);
  const bodyData = JSON.stringify({
    pageId: credentials.pageId,
    relationId: credentials.relationId,
    relationType: credentials.relationType,
    freemarkerContent,
  });

  const url = new URL(credentials.apiUrl || RENDER_API_URL);
  const options = {
    hostname: url.hostname,
    port: url.port || 80,
    path: url.pathname + url.search,
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(bodyData),
      'Accept': 'application/json',
      'Authorization': credentials.authorization || '',
      'Cookie': credentials.cookie || '',
      'p2-module': 'new-editor',
      'Referer': 'http://website.leadong.com/phoenix2/composite/blockEditorUI/index.html',
    },
  };

  return new Promise((resolve, reject) => {
    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          if (json.code !== 200000 && json.code !== 200) {
            reject(new Error(`API code=${json.code}, msg=${json.msg || ''}`));
            return;
          }

          let htmlData = '';
          const src = json.data;

          if (typeof src === 'string') {
            htmlData = src;
          } else if (src && typeof src === 'object') {
            htmlData = src.html || src.content || src.result || src.freemarkerContent || src.renderedContent || '';
            if (typeof htmlData !== 'string') {
              console.log('[callRenderApi] data object keys:', Object.keys(src).join(', '));
              console.log('[callRenderApi] data sample:', JSON.stringify(src).substring(0, 500));
              htmlData = JSON.stringify(src);
            }
          }

          if (!htmlData) {
            htmlData = json.html || json.content || json.result || '';
          }

          if (typeof htmlData === 'string' && htmlData.length > 0) {
            try {
              const decoded = base64ToUtf8(htmlData);
              if (decoded.includes('<') || decoded.includes('&')) htmlData = decoded;
            } catch (_) { /* not base64 */ }
          }
          resolve(htmlData);
        } catch (e) {
          reject(new Error('JSON parse error: ' + e.message + ' | raw: ' + data.substring(0, 200)));
        }
      });
    });
    req.on('error', reject);
    req.setTimeout(30000, () => { req.destroy(); reject(new Error('Request timeout (30s)')); });
    req.write(bodyData);
    req.end();
  });
}

// ─── HTML block replacement ───

function findOpeningTag(html, posInsideTag) {
  let i = posInsideTag;
  while (i > 0 && html[i] !== '<') i--;
  i++;
  let tag = '';
  while (i < html.length && /[a-zA-Z0-9]/.test(html[i])) { tag += html[i]; i++; }
  return tag || 'div';
}

function findMatchingCloseTag(html, startPos, tagName) {
  let depth = 1;
  let i = startPos;
  const openRe = new RegExp(`<${tagName}[\\s>/]`, 'gi');
  const closeRe = new RegExp(`</${tagName}>`, 'gi');
  while (i < html.length && depth > 0) {
    openRe.lastIndex = i;
    closeRe.lastIndex = i;
    const openMatch = openRe.exec(html);
    const closeMatch = closeRe.exec(html);
    if (!closeMatch) return -1;
    if (openMatch && openMatch.index < closeMatch.index) {
      depth++;
      i = openMatch.index + openMatch[0].length;
    } else {
      depth--;
      if (depth === 0) return closeMatch.index;
      i = closeMatch.index + closeMatch[0].length;
    }
  }
  return -1;
}

function replaceBlockContent(html, uuid, renderedHtml) {
  const marker = `data-block-uuid="${uuid}"`;
  const markerPos = html.indexOf(marker);
  if (markerPos === -1) return html;

  const tagEnd = html.indexOf('>', markerPos);
  if (tagEnd === -1) return html;

  const innerStart = tagEnd + 1;
  const tagName = findOpeningTag(html, markerPos);
  const closeIdx = findMatchingCloseTag(html, innerStart, tagName);
  if (closeIdx === -1) return html;

  return html.substring(0, innerStart) + renderedHtml + html.substring(closeIdx);
}

function removeSetupScript(html) {
  return html.replace(/<!-- Dynamic Module Model Setup Script[^>]*-->[\s\S]*?<\/script>/g, '');
}

// ─── Resolve FTL content (inline ftlContents or blocks/ files) ───

function resolveFtlContent(mod, dynamicModules, htmlFilePath) {
  if (dynamicModules.ftlContents && dynamicModules.ftlContents[mod.uuid]) {
    return dynamicModules.ftlContents[mod.uuid];
  }

  if (mod.templatePath) {
    const pageDir = nodePath.dirname(htmlFilePath);
    const ftlAbs = nodePath.resolve(pageDir, mod.templatePath);
    if (fs.existsSync(ftlAbs)) {
      return fs.readFileSync(ftlAbs, 'utf-8');
    }
  }

  const parentDir = nodePath.resolve(nodePath.dirname(htmlFilePath), '..');
  const blocksDir = nodePath.join(parentDir, 'blocks');
  const ftlPath = nodePath.join(blocksDir, `${mod.uuid}.ftl`);
  if (fs.existsSync(ftlPath)) {
    return fs.readFileSync(ftlPath, 'utf-8');
  }

  return null;
}

// ─── Get credentials from request + config ───

function getCredentials(req, parsedUrl) {
  const config = loadConfig();
  return {
    authorization: req.headers['authorization'] || parsedUrl.searchParams.get('token') || config.authorization || '',
    cookie: req.headers['x-cookie'] || parsedUrl.searchParams.get('cookie') || config.cookie || '',
    pageId: req.headers['x-page-id'] || parsedUrl.searchParams.get('pageId') || config.pageId || 'ibpAZjVlKsaE',
    relationId: req.headers['x-relation-id'] || parsedUrl.searchParams.get('relationId') || config.relationId || 'ibpAZjVlKsaE',
    relationType: req.headers['x-relation-type'] || parsedUrl.searchParams.get('relationType') || config.relationType || '5',
    apiUrl: req.headers['x-api-url'] || parsedUrl.searchParams.get('apiUrl') || config.apiUrl || RENDER_API_URL,
  };
}

// ─── Main render handler ───

async function handleRender(req, res, parsedUrl) {
  const filePath = parsedUrl.searchParams.get('file');
  if (!filePath) {
    res.writeHead(400, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Missing file parameter. Usage: /render?file=src/Generate/.../pages/dynamic_preview_inline.html' }));
    return;
  }

  const abs = safePath(filePath);
  if (!abs) {
    res.writeHead(403, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Forbidden path' }));
    return;
  }

  if (!fs.existsSync(abs) || !fs.statSync(abs).isFile()) {
    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'File not found: ' + filePath }));
    return;
  }

  const credentials = getCredentials(req, parsedUrl);

  if (!credentials.authorization && !credentials.cookie) {
    res.writeHead(400, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      error: 'Missing credentials. Provide authorization token via header, query param, or .render-config.json',
      usage: {
        header: 'Authorization: Bearer <token>, X-Cookie: <cookie>',
        query: '/render?file=...&token=<jwt>&cookie=<cookie>',
        config: 'Create src/tools/.render-config.json with { "authorization": "...", "cookie": "..." }',
      },
    }));
    return;
  }

  console.log(`[RENDER] ${filePath}`);
  const startTime = Date.now();

  let html = fs.readFileSync(abs, 'utf-8');
  const dynamicModules = parseDynamicModules(html);

  if (!dynamicModules || !dynamicModules.modules || dynamicModules.modules.length === 0) {
    console.log(`  No dynamic modules found, returning original HTML`);
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    res.end(html);
    return;
  }

  const modules = dynamicModules.modules;
  console.log(`  Found ${modules.length} dynamic module(s)`);

  const results = [];

  for (const mod of modules) {
    const ftlContent = resolveFtlContent(mod, dynamicModules, abs);
    if (!ftlContent) {
      console.log(`  [${mod.uuid}] FTL not found — skipped`);
      results.push({ uuid: mod.uuid, status: 'skipped', reason: 'FTL not found' });
      continue;
    }

    console.log(`  [${mod.uuid}] Rendering ${mod.blockType} (${ftlContent.length} chars)...`);

    try {
      const rendered = await callRenderApi(ftlContent, credentials);
      html = replaceBlockContent(html, mod.uuid, rendered);
      console.log(`  [${mod.uuid}] OK (${rendered.length} chars rendered)`);
      results.push({ uuid: mod.uuid, status: 'ok', renderedLength: rendered.length });
    } catch (err) {
      console.log(`  [${mod.uuid}] FAILED: ${err.message}`);
      results.push({ uuid: mod.uuid, status: 'failed', error: err.message });
    }
  }

  const okCount = results.filter(r => r.status === 'ok').length;

  if (okCount > 0) {
    html = removeSetupScript(html);
  }

  const elapsed = Date.now() - startTime;
  console.log(`  Done in ${elapsed}ms — ${okCount}/${modules.length} rendered`);

  const safeResults = results.map(r => ({
    uuid: r.uuid,
    status: r.status,
    renderedLength: r.renderedLength || 0,
    error: r.error ? r.error.replace(/[^\x20-\x7E]/g, '?') : undefined,
  }));

  res.writeHead(200, {
    'Content-Type': 'text/html; charset=utf-8',
    'X-Render-Count': `${okCount}/${modules.length}`,
    'X-Render-Time': `${elapsed}ms`,
  });
  res.end(html);
}

// ─── Server ───

const server = http.createServer(async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', '*');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const parsedUrl = new URL(req.url, `http://localhost:${PORT}`);

  if (parsedUrl.pathname === '/' || parsedUrl.pathname === '/favicon.ico') {
    const config = loadConfig();
    const status = checkCredentialStatus(config);
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify({
      service: 'Page Renderer',
      port: PORT,
      projectRoot: PROJECT_ROOT,
      credential: status.expired === false ? '✅ 有效' : status.expired === true ? '❌ 已过期' : '⚠️ 未配置',
      endpoints: {
        '/render?file=<path>': '渲染内联 HTML (FTL → real HTML)',
        '/check': '查看凭证状态（过期时间等）',
        '/update-config': 'POST 更新凭证配置',
        '/local?file=<path>': '静态文件服务',
        '/list?dir=<path>': '列出目录',
      },
    }, null, 2));
    return;
  }

  if (parsedUrl.pathname === '/check') {
    const config = loadConfig();
    const status = checkCredentialStatus(config);
    const info = {
      configFile: 'src/tools/.render-config.json',
      authorization: status.hasAuth
        ? { present: true, expired: status.expired, expireDate: status.jwtExpDate,
            remainingHours: status.remainingSec != null ? +(status.remainingSec / 3600).toFixed(1) : null }
        : { present: false },
      cookie: { present: status.hasCookie },
      pageId: config.pageId || null,
      relationId: config.relationId || null,
      hint: status.expired
        ? '凭证已过期，请登录后台获取新的 authorization 和 cookie，更新到 .render-config.json'
        : status.hasAuth ? '凭证有效' : '未配置凭证',
    };
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify(info, null, 2));
    return;
  }

  if (parsedUrl.pathname === '/update-config' && req.method === 'POST') {
    let body = '';
    for await (const chunk of req) body += chunk;
    try {
      const newConfig = JSON.parse(body);
      const existing = loadConfig();
      const merged = { ...existing, ...newConfig };
      fs.writeFileSync(CONFIG_PATH, JSON.stringify(merged, null, 2), 'utf-8');
      const status = checkCredentialStatus(merged);
      res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
      res.end(JSON.stringify({
        success: true,
        message: '配置已更新',
        expired: status.expired,
        expireDate: status.jwtExpDate,
      }, null, 2));
    } catch (err) {
      res.writeHead(400, { 'Content-Type': 'application/json; charset=utf-8' });
      res.end(JSON.stringify({ success: false, error: err.message }));
    }
    return;
  }

  if (parsedUrl.pathname === '/render') {
    try {
      await handleRender(req, res, parsedUrl);
    } catch (err) {
      console.error('[ERROR]', err);
      if (!res.headersSent) {
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: err.message }));
      }
    }
    return;
  }

  if (parsedUrl.pathname === '/local') {
    const fp = parsedUrl.searchParams.get('file');
    if (!fp) { res.writeHead(400, { 'Content-Type': 'text/plain' }); res.end('Missing file parameter'); return; }
    const abs = safePath(fp);
    if (!abs) { res.writeHead(403, { 'Content-Type': 'text/plain' }); res.end('Forbidden path'); return; }
    if (!fs.existsSync(abs) || !fs.statSync(abs).isFile()) {
      res.writeHead(404, { 'Content-Type': 'text/plain' }); res.end('File not found: ' + fp); return;
    }
    const ext = nodePath.extname(abs).toLowerCase();
    const mime = MIME_MAP[ext] || 'application/octet-stream';
    res.writeHead(200, { 'Content-Type': mime });
    fs.createReadStream(abs).pipe(res);
    return;
  }

  if (parsedUrl.pathname === '/list') {
    const dirPath = parsedUrl.searchParams.get('dir');
    if (!dirPath) { res.writeHead(400, { 'Content-Type': 'text/plain' }); res.end('Missing dir parameter'); return; }
    const abs = safePath(dirPath);
    if (!abs) { res.writeHead(403, { 'Content-Type': 'text/plain' }); res.end('Forbidden path'); return; }
    if (!fs.existsSync(abs) || !fs.statSync(abs).isDirectory()) {
      res.writeHead(404, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'Directory not found', path: dirPath }));
      return;
    }
    const entries = fs.readdirSync(abs, { withFileTypes: true }).map(e => ({
      name: e.name, type: e.isDirectory() ? 'dir' : 'file',
    }));
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify(entries));
    return;
  }

  res.writeHead(404, { 'Content-Type': 'text/plain' });
  res.end('Use /render?file=<path> or /check or /local?file=<path> or /list?dir=<path>');
});

server.listen(PORT, () => {
  console.log(`\n  Page Renderer running at http://localhost:${PORT}`);
  console.log(`  Project root: ${PROJECT_ROOT}`);
  console.log(`  Endpoints:`);
  console.log(`    /render?file=REL_PATH    — Render inline HTML (FTL → real HTML)`);
  console.log(`    /local?file=REL_PATH     — Serve local file`);
  console.log(`    /list?dir=REL_PATH       — List directory\n`);

  const config = loadConfig();
  if (config.authorization || config.cookie) {
    console.log(`  Config: .render-config.json loaded ✓`);
    const status = checkCredentialStatus(config);
    if (status.jwtExp) {
      if (status.expired) {
        const agoH = Math.round(-status.remainingSec / 3600);
        console.log(`  ⚠️  JWT 已过期！过期于 ${status.jwtExpDate} (${agoH}小时前)`);
        console.log(`  ⚠️  请更新 src/tools/.render-config.json 中的 authorization 和 cookie`);
      } else {
        const leftH = Math.round(status.remainingSec / 3600);
        console.log(`  ✅ JWT 有效，过期时间: ${status.jwtExpDate} (剩余 ${leftH}小时)`);
      }
    }
  } else {
    console.log(`  Config: No .render-config.json found`);
    console.log(`  Credentials can be passed via:`);
    console.log(`    - Request headers: Authorization, X-Cookie, X-Page-Id`);
    console.log(`    - Query params: ?token=...&cookie=...&pageId=...`);
    console.log(`    - Config file: src/tools/.render-config.json\n`);
  }
  console.log(`  凭证状态检查: http://localhost:${PORT}/check\n`);
});
