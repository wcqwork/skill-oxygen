# 安全漏洞扫描分析报告

**项目**: skill-oxygen
**扫描日期**: 2026-03-28
**风险等级**: 高危
**用途**: 开发自用

---

## 执行摘要

| 指标 | 数值 |
|------|------|
| 发现漏洞总数 | 6 |
| 🔴 高危 | 3 |
| 🟡 中危 | 2 |
| 🟢 低危 | 1 |

**整体评估**: 该项目存在多个严重安全问题，主要涉及敏感信息泄露和服务器安全配置。由于标注为"开发自用"，建议在部署前进行修复。

---

## 漏洞详情

### 1. [高危] 敏感凭证信息泄露

**文件**: `src/tools/.render-config.json`

**描述**: JWT Token 和完整的 Cookie 字符串以明文形式存储在配置文件中，且该文件已被追踪到 git 仓库。

**风险**:
- 凭证泄露可导致未授权访问第三方服务
- Cookie 包含会话信息，可被用于身份冒用
- JWT 有效期至 2026-03-31，泄露窗口期长

**影响范围**: `src/tools/.render-config.json:1-12`

**修复建议**:
1. 立即将 `.render-config.json` 添加到 `.gitignore`
2. 使用 `.render-config.example.json` 作为模板
3. 从 git 历史中移除敏感文件: `git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch src/tools/.render-config.json'`

---

### 2. [高危] 开放代理服务器 (SSRF)

**文件**: `src/tools/proxy-server.mjs`

**描述**: 代理服务器允许向任意 URL 发起请求，未实施白名单或目标限制。

```javascript
// src/tools/proxy-server.mjs:114
const targetUrl = parsedUrl.searchParams.get('url');
// 无 URL 验证，可代理到任何地址
```

**风险**:
- 攻击者可通过代理访问内网服务
- 可用于绕过防火墙访问受限资源
- 可发起对第三方服务的攻击

**修复建议**:
1. 实施目标 URL 白名单
2. 禁止访问私有 IP 地址 (10.x, 172.16-31.x, 192.168.x, 127.x, 169.254.x)
3. 限制允许代理的协议 (仅 HTTP/HTTPS)

```javascript
// 示例修复代码
const PRIVATE_IP_REGEX = /^(10\.|172\.(1[6-9]|2\d|3[01])\.|192\.168\.|127\.|169\.254\.|::1|0\.0\.0\.0)/;
function isPrivateIP(hostname) {
  return PRIVATE_IP_REGEX.test(hostname);
}
```

---

### 3. [高危] 凭证通过 URL 传递

**文件**: `src/tools/page-renderer.mjs:292-301`

**描述**: 敏感凭证 (authorization, cookie) 可通过 URL 查询参数传递。

```javascript
// src/tools/page-renderer.mjs:292-301
function getCredentials(req, parsedUrl) {
  return {
    authorization: ... parsedUrl.searchParams.get('token') || ...
    cookie: ... parsedUrl.searchParams.get('cookie') || ...
  };
}
```

**风险**:
- URL 参数会被记录在服务器日志、代理日志、浏览器历史
- 凭证可能被第三方脚本窃取
- 违反安全最佳实践

**修复建议**:
1. 移除 URL 参数传递凭证的功能
2. 仅允许通过 HTTP Header 传递敏感信息
3. 在文档中明确说明安全使用方式

---

### 4. [中危] 过于宽松的 CORS 配置

**文件**: `src/tools/proxy-server.mjs:36-38`, `src/tools/page-renderer.mjs:408-410`

**描述**: CORS 配置允许任意域名访问。

```javascript
res.setHeader('Access-Control-Allow-Origin', '*');
res.setHeader('Access-Control-Allow-Headers', '*');
```

**风险**:
- 任意网站可向服务发起请求
- 可能导致 CSRF 攻击
- 敏感数据可被跨域读取

**修复建议**:
1. 限制 `Access-Control-Allow-Origin` 为特定域名
2. 在开发环境使用 `localhost`，生产环境使用实际域名
3. 对于敏感端点，要求 `Origin` 头验证

---

### 5. [中危] VM 沙箱潜在逃逸风险

**文件**: `src/tools/page-renderer.mjs:111-132`

**描述**: 使用 `vm` 模块执行不可信脚本，虽然做了部分限制，但 Node.js VM 沙箱并非完全隔离。

```javascript
// src/tools/page-renderer.mjs:123
const context = vm.createContext({
  window: mockWindow,
  console: { log() {}, error() {}, warn() {} }
});
```

**风险**:
- VM 沙箱在 Node.js 中不是安全边界
- 通过原型链污染可能逃逸沙箱
- 可能执行任意代码

**修复建议**:
1. 如果执行不可信代码，考虑使用 `vm2` 或独立的 worker 进程
2. 限制执行时间 (`vm.Script.runInContext` 的 timeout 参数)
3. 对于当前用例，确保 `__DYNAMIC_MODULES__` 来源可信

---

### 6. [低危] 缺少请求速率限制

**文件**: `src/tools/page-renderer.mjs`, `src/tools/proxy-server.mjs`

**描述**: 服务端点未实施速率限制。

**风险**:
- 可能被用于 DoS 攻击
- 资源耗尽

**修复建议**:
1. 添加基于 IP 的请求速率限制
2. 对于 `/render` 端点，限制并发请求数

---

## 良好安全实践

项目中已实施的安全措施:

1. **路径安全检查** - `safePath()` 函数防止路径遍历
   ```javascript
   function safePath(requestedPath) {
     if (cleaned.includes('..')) return null;
     if (!abs.startsWith(PROJECT_ROOT)) return null;
     return abs;
   }
   ```

2. **JWT 过期检查** - `checkCredentialStatus()` 函数检查凭证有效性

---

## 修复优先级

| 优先级 | 漏洞 | 预计修复时间 |
|--------|------|--------------|
| P0 | 敏感凭证信息泄露 | 15 分钟 |
| P0 | 开放代理服务器 | 1 小时 |
| P1 | 凭证通过 URL 传递 | 30 分钟 |
| P2 | CORS 配置 | 15 分钟 |
| P3 | VM 沙箱风险 | 1 小时 |
| P3 | 速率限制 | 30 分钟 |

---

## 结论

项目当前存在 3 个高危安全漏洞，主要集中在：

1. **凭证管理** - 敏感信息以明文存储并可能被提交到版本控制
2. **网络安全** - 开放代理和宽松的 CORS 配置
3. **数据传输** - 敏感信息通过不安全渠道传递

**建议**: 在将服务暴露到公网前，至少修复所有 P0 级别的漏洞。对于开发自用场景，建议在本地网络隔离环境中运行，并定期轮换凭证。

---

*报告生成时间: 2026-03-28*
*扫描工具: Claude Code Security Audit*
