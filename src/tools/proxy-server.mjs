import http from 'node:http';
import fs from 'node:fs';
import nodePath from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = nodePath.dirname(__filename);
const PROJECT_ROOT = nodePath.resolve(__dirname, '../..');

const PORT = 3456;

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

function safePath(requestedPath) {
  const cleaned = decodeURIComponent(requestedPath).replace(/\\/g, '/');
  if (cleaned.includes('..')) return null;
  const abs = nodePath.resolve(PROJECT_ROOT, cleaned);
  if (!abs.startsWith(PROJECT_ROOT)) return null;
  return abs;
}

const server = http.createServer(async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', '*');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const parsedUrl = new URL(req.url, `http://localhost:${PORT}`);

  if (parsedUrl.pathname === '/' || parsedUrl.pathname === '/favicon.ico') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('CORS Proxy is running on port ' + PORT);
    return;
  }

  // --- /local?file=RELATIVE_PATH — serve local project files ---
  if (parsedUrl.pathname === '/local') {
    const filePath = parsedUrl.searchParams.get('file');
    if (!filePath) {
      res.writeHead(400, { 'Content-Type': 'text/plain' });
      res.end('Missing file parameter');
      return;
    }
    const abs = safePath(filePath);
    if (!abs) {
      res.writeHead(403, { 'Content-Type': 'text/plain' });
      res.end('Forbidden path');
      return;
    }
    if (!fs.existsSync(abs) || !fs.statSync(abs).isFile()) {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('File not found: ' + filePath);
      return;
    }
    const ext = nodePath.extname(abs).toLowerCase();
    const mime = MIME_MAP[ext] || 'application/octet-stream';
    res.writeHead(200, { 'Content-Type': mime });
    fs.createReadStream(abs).pipe(res);
    return;
  }

  // --- /list?dir=RELATIVE_DIR — list files in a project directory ---
  if (parsedUrl.pathname === '/list') {
    const dirPath = parsedUrl.searchParams.get('dir');
    if (!dirPath) {
      res.writeHead(400, { 'Content-Type': 'text/plain' });
      res.end('Missing dir parameter');
      return;
    }
    const abs = safePath(dirPath);
    if (!abs) {
      res.writeHead(403, { 'Content-Type': 'text/plain' });
      res.end('Forbidden path');
      return;
    }
    if (!fs.existsSync(abs) || !fs.statSync(abs).isDirectory()) {
      res.writeHead(404, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'Directory not found', path: dirPath }));
      return;
    }
    const entries = fs.readdirSync(abs, { withFileTypes: true }).map(e => ({
      name: e.name,
      type: e.isDirectory() ? 'dir' : 'file',
    }));
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify(entries));
    return;
  }

  if (!parsedUrl.pathname.startsWith('/proxy')) {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Use /proxy?url=ENCODED_URL or /local?file=PATH or /list?dir=PATH');
    return;
  }

  const targetUrl = parsedUrl.searchParams.get('url');

  if (!targetUrl) {
    res.writeHead(400, { 'Content-Type': 'text/plain' });
    res.end('Missing url parameter');
    return;
  }

  let body = '';
  for await (const chunk of req) body += chunk;

  const forwardHeaders = { ...req.headers };
  delete forwardHeaders['host'];
  delete forwardHeaders['origin'];
  delete forwardHeaders['referer'];
  delete forwardHeaders['connection'];
  delete forwardHeaders['accept-encoding'];

  // Restore the actual Referer the caller wants
  const callerReferer = forwardHeaders['x-proxy-referer'];
  if (callerReferer) {
    forwardHeaders['referer'] = callerReferer;
    delete forwardHeaders['x-proxy-referer'];
  }
  const callerCookie = forwardHeaders['x-proxy-cookie'];
  if (callerCookie) {
    forwardHeaders['cookie'] = callerCookie;
    delete forwardHeaders['x-proxy-cookie'];
  }

  const target = new URL(targetUrl);
  const options = {
    hostname: target.hostname,
    port: target.port || 80,
    path: target.pathname + target.search,
    method: req.method,
    headers: forwardHeaders,
  };

  const proxyReq = http.request(options, (proxyRes) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.writeHead(proxyRes.statusCode, proxyRes.headers);
    proxyRes.pipe(res, { end: true });
  });

  proxyReq.on('error', (err) => {
    console.error('Proxy error:', err.message);
    res.writeHead(502, { 'Content-Type': 'text/plain' });
    res.end('Proxy error: ' + err.message);
  });

  if (body) proxyReq.write(body);
  proxyReq.end();
});

server.listen(PORT, () => {
  console.log(`\n  CORS Proxy Server running at http://localhost:${PORT}`);
  console.log(`  Project root: ${PROJECT_ROOT}`);
  console.log(`  Endpoints:`);
  console.log(`    /proxy?url=ENCODED_URL    — CORS proxy`);
  console.log(`    /local?file=REL_PATH      — serve local file`);
  console.log(`    /list?dir=REL_PATH        — list directory\n`);
});
