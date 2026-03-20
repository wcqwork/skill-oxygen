import http from 'node:http';

const PORT = 3456;

const server = http.createServer(async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', '*');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  if (req.url === '/' || req.url === '/favicon.ico') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('CORS Proxy is running on port ' + PORT);
    return;
  }

  // URL format: /proxy?url=ENCODED_TARGET_URL
  if (!req.url.startsWith('/proxy')) {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Use /proxy?url=ENCODED_URL');
    return;
  }

  const parsed = new URL(req.url, `http://localhost:${PORT}`);
  const targetUrl = parsed.searchParams.get('url');

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
  console.log(`  Usage: http://localhost:${PORT}/proxy?url=ENCODED_TARGET_URL\n`);
});
