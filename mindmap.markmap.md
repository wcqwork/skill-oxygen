# Skill Oxygen

## 核心定位

### 静态HTML转动态模块
### 标记注入而非结构替换
### 100%保留原始样式
### FreeMarker模板合成

## 核心Skills

### Dynamic Module Converter

#### 四阶段转换流程

##### Phase 1: 通用动态区域识别
- 自底向上检测
- 三层评分算法
  - 结构 40%
  - URL 25%
  - 内容 20%

##### Phase 2: 用户确认
- 逐一确认区块类型
- 零自动转换

##### Phase 3: 标记注入
- developer-component包装
- data-block-type属性
- Model Setup Script

##### Phase 3.5: FTL模板合成
- 保留原始HTML结构
- @api查询块
- [#list]循环

##### Phase 4: 渲染验证
- DOM层级检查 73项
- JS语法验证
- 视觉结构对比 25项
- 导出路径模拟 41项

#### 支持22+区块类型
- 产品列表/分组
- 文章列表/详情
- 图库/视频/下载
- FAQ/搜索/站点地图

#### 输出产物
- dynamic_preview.html
- blocks/uuid.ftl
- 报告JSON

### Template Fetcher

#### 抓取平台模板
- Playwright自动登录
- 分页扫描应用列表
- 提取view_default文件

#### 过滤选项
- 按类型 **-t**
- 按关键词 **-k**
- 按JSON配置 **-j**

#### 输出产物
- *.ftl模板文件
- _registry.json索引

### PUA Skill

#### AI激励引擎

##### 三条铁律
- 穷尽一切方案
- 先做后问
- 主动出击

##### 五步方法论
- 闻味道-诊断卡壳
- 揪头发-拉高视角
- 照镜子-自检
- 执行新方案
- 复盘

##### 压力等级L1-L4
##### 七项检查清单

## 技术栈

### Node.js >=18
### Cheerio HTML解析
### Inquirer 交互CLI
### Playwright 浏览器自动化
### FreeMarker 模板引擎
### UUID 唯一标识

## 项目结构

### .claude/skills/

#### dynamic-module-converter/
- scripts/ 转换脚本
- references/ 参考文档
- templates/ 模板文件
- blocks/ 输出区块

#### template-fetcher/
- scripts/ 抓取脚本

#### pua/

### src/

#### pages/ 页面文件
#### Generate/ 转换输出
#### tools/ 开发工具
- api-tester.html
- proxy-server.mjs
- page-renderer.mjs

#### fetch_config/ 抓取配置
#### docs/ 项目文档

## 开发工具

### API测试器
- renderFreemarker接口

### 代理服务器
- CORS代理 :3456

### 页面渲染器
- FTL渲染服务 :3457

## NPM脚本

### npm test
- 转换+验证

### npm run convert
- 执行转换

### npm run verify:all
- 全部验证

### npm run render-server
- 渲染服务

## 工作流程

### 1. /fetch-templates
- 获取模板

### 2. /convert-dynamic
- 转换HTML

### 3. verify:all
- 验证结果
