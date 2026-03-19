# Block Type Signatures

从 62 个 FTL 模板中提取的区块类型特征文档。供 `convert-dynamic.mjs` 的检测算法参考，提高静态 HTML 到动态区块的识别准确率。

## 模板覆盖统计

| blockType | 模板数量 | 检测类型名 |
|-----------|----------|------------|
| `phoenix_blocks_prodlist` | 22 | `prodList` |
| `phoenix_blocks_Articlelist` | 41 | `articleList` |
| `phoenix_blocks_groupProduct_new` | 8 | `groupProduct` |
| `phoenix_blocks_prodDetail` | 1 | `prodDetail` |

无模板但保留检测逻辑: `galleryList`, `videoList`, `downloadList`, `FAQList`, `commentList`

---

## 1. prodList (产品列表)

### GraphQL API

```
productList(conditionDto: { page, limit, orderBy, searchGroupIds, searchProdIds, prodType }) {
  totalRow, pageSize, pageNumber,
  list { encodeId, prodName, prodPrice, prodUrl, photoUrlList, prodBrief, ... }
}
```

### FreeMarker 变量

- 列表: `data.productList.list`
- 遍历变量: `product` 或 `productRolling`
- 核心字段: `prodName`, `prodPrice`, `prodUrl`, `photoUrlList[0]`, `prodBrief`
- 价格字段: `prodPrice`, `shopProdPrice`, `prodDiscountPrice`, `prodMaxPrice`, `prodMinPrice`
- 图片 SEO: `photoSeoList[0].photoAlt`, `photoSeoList[0].photoTitle`

### CSS Class 特征词 (高置信度)

从模板中出现的特征类名，按覆盖率排序：

| 类名模式 | 出现模板数 | 说明 |
|----------|-----------|------|
| `proshow-scroll-item` | 11/22 | 滚动布局的列表项 |
| `proshow-custom-item` | 11/22 | 自定义布局的列表项 |
| `proshow-image` | 11/22 | 产品图片容器 |
| `proshow-caption` | 11/22 | 产品标题区域 |
| `proshow-title` | 11/22 | 产品名称 |
| `proshow-container` | 11/22 | 外层容器 |
| `proList` | 11/22 | 根级类名 |
| `prodlist-discountprice` | 8/22 | 折扣价 |
| `star-goods` | 5/22 | 列表项 (另一种布局) |
| `prodlist-box` | 3/22 | 产品卡片盒子 |
| `img-box` | 3/22 | 图片盒子 |

### HTML 结构签名

**布局 A (proshow 系列, 11 模板)**:
```
div.proList
  > div.proshow-container
    > div.proshow-scroll-box / div.proshow-custom-box
      > div.proshow-scroll-list / div.proshow-custom-list
        > div.proshow-scroll-item / div.proshow-custom-item  (重复)
          > a.proshow-image > img
          > div.proshow-caption > h3.proshow-title > a
```

**布局 B (star-goods 系列, 5 模板)**:
```
ul
  > li.star-goods  (重复)
    > div.prodlist-box
      > div.imgBox > a > img
      > h3 > a
      > span.price
```

**布局 C (prodlist-inner 系列, 6 模板)**:
```
ul.fix.grid-container
  > li  (重复)
    > div.prodlist-box-hover
      > div.prodlist-display
        > div.prodlist-inner
          > div.prodlist-picbox > a > img
          > div.prodlist-name > a
          > div.prodlist-price
```

### 内容特征

- 必有价格（`$`, `€`, `¥` 等货币符号，或 `prodPrice`/`shopProdPrice`）
- 必有产品链接（`/product/` 或动态 `prodUrl`）
- 常见 CTA: "Add to Cart", "Buy Now", "Shop Now", "Inquiry"
- 每个列表项包含: 图片 + 标题 + 价格（可选: 简介、折扣价）

### URL 模式

- `/product/`, `/p/`, `/item/`, `/shop/`, `/goods/`
- 新增建议: `/catalog/`, `/products/`, `/category/`

### 与 groupProduct 的区分

| 特征 | prodList | groupProduct |
|------|----------|--------------|
| 分类标签/Tab | 无 | 有 (r-tabs-nav, site-category-list) |
| 嵌套层级 | 单层列表 | 二层 (分类 > 产品) |
| class 关键词 | `proshow-*`, `prodlist-*` | `prodCategoty-*`, `site-category-*` |

---

## 2. articleList (文章列表)

### GraphQL API

```
articleList(conditionDto: { page, limit, searchGroupIds, articleType }) {
  totalRow, pageSize, pageNumber,
  list { encodeId, articleTitle, articleSummary, articleUrl, publishTime, photoUrlNormal, cateName, cateUrl, ... }
}
```

### FreeMarker 变量

- 列表: `data.articleList.list`
- 遍历变量: `article`
- 核心字段: `articleTitle`, `articleSummary`, `articleUrl`, `publishTime`, `photoUrlNormal`
- 分类字段: `cateName`, `cateUrl`
- 图片 SEO: `photoSeoList[0].photoAlt`, `photoSeoList[0].photoTitle`

### CSS Class 特征词 (高置信度)

| 类名模式 | 出现模板数 | 说明 |
|----------|-----------|------|
| `ArticlePicList_Item` | 39/41 | 文章列表项 |
| `ArticlePicList_ItemImg` | 39/41 | 文章图片 |
| `ArticlePicList_ItemContent` | 39/41 | 文章内容区 |
| `Article_Container` | 39/41 | 外层容器 |
| `articalWrap` | 39/41 | 文章包装器 |
| `articleList-summary` | 30/41 | 摘要 |
| `artime` | 38/41 | 发布时间 |
| `headlines-content-img` | 20/41 | 头条图片 |
| `Artitem` | 38/41 | 文章项别名 |

### HTML 结构签名

**主流布局 (39 模板)**:
```
div.Article_Container
  > div.articalWrap
    > article.ArticlePicList_Item / div.ArticlePicList_Item  (重复)
      > div.ArticlePicList_ItemImg > a > img
      > div.ArticlePicList_ItemContent
        > div.ArticlePicList_ItemContentInner
          > h3/h5.ArticlePicList_ItemContentInnerH5 > a
          > div.articleList-summary
          > span.artime
```

### 内容特征

- 必有日期（`publishTime` 格式: `2024-01-01`, `January 1, 2024`）
- 常有摘要文本
- 常见 CTA: "Read More", "Continue Reading", "Learn More"
- 每个列表项包含: 图片 + 标题 + 日期（可选: 摘要、分类）

### URL 模式

- `/blog/`, `/news/`, `/article/`, `/post/`, `/press/`
- 新增建议: `/events/`, `/case/`, `/case-study/`

---

## 3. groupProduct (产品分类)

### GraphQL API

```
productGroupList(conditionDto: { ... }) {
  list { encodeId, groupName, groupUrl, groupPhotoUrlList, subGroups { ... } }
}
```

加上每个分类下的 `productList` 查询。

### FreeMarker 变量

- 分类列表: `data.productGroupList`
- 分类变量: `group`
- 分类字段: `groupName`, `groupUrl`, `groupPhotoUrlList[0]`, `subGroups`
- 产品列表: 嵌套 `productList.list`，变量同 prodList

### CSS Class 特征词 (高置信度)

| 类名模式 | 出现模板数 | 说明 |
|----------|-----------|------|
| `prodCategoty-container` | 5/8 | 产品分类根容器 |
| `site-category-list` | 4/8 | 分类列表 |
| `category-item` | 4/8 | 分类项 |
| `goodsCate-list` | 3/8 | 商品分类列表 |
| `r-tabs-nav` | 3/8 | Tab 导航 |
| `r-tabs-tab` | 3/8 | Tab 项 |
| `prodTabList` | 2/8 | 产品 Tab 列表 |
| `sitewidget-prodCatalog` | 2/8 | 平台产品目录组件 |
| `star-goods` | 5/8 | 产品项 (共享 prodList) |

### HTML 结构签名

**Tab 布局 (3 模板)**:
```
div.prodCategoty-container
  > ul.r-tabs-nav
    > li.r-tabs-tab  (分类标签, 重复)
      > a
  > div.tab-container
    > div.tab-container-inner  (每个分类的产品, 重复)
      > ul > li.star-goods  (产品项)
```

**侧边栏布局 (4 模板)**:
```
div.prodCategoty-container
  > div.site-category
    > ul.site-category-list
      > li.category-item  (分类项, 重复)
        > a.title
        > div.children > ul.children-list
          > li.star-goods  (产品项)
```

### 与 prodList 的区分要点

- 有分类/Tab 结构 (`r-tabs-nav`, `site-category-list`)
- 二层嵌套 (分类列表 + 产品列表)
- class 中含 `categot[y|ie]`, `category`, `group`, `tab`

---

## 4. prodDetail (产品详情)

### GraphQL API

```
productList(conditionDto: { limit: 1, searchProdIds: $dataIds }) {
  list { prodName, prodPrice, photoUrlList, prodBrief, phoenixProductSubVo { ... }, productSkuItem { ... } }
}
```

### FreeMarker 变量

- 单产品: `data.productList.list[0]` 或直接取 `product`
- 核心字段: `prodName`, `prodPrice`, `photoUrlList`, `prodBrief`
- 详情字段: `phoenixProductSubVo.hasProdVideo`, `phoenixProductTextVO`, `productSkuItem`

### CSS Class 特征词 (高置信度)

| 类名模式 | 出现模板数 | 说明 |
|----------|-----------|------|
| `prodDetail_component` | 1/1 | 根容器 |
| `blockDetail_container` | 1/1 | 详情容器 |
| `lead_prodimg_container` | 1/1 | 主图容器 |
| `lead_slick` | 1/1 | 图片轮播 |
| `lead_prod_img` | 1/1 | 产品图片 |

### HTML 结构签名

```
div.prodDetail_component
  > div.blockDetail_container
    > div.lead_slick_container
      > div.lead_prodimg_container
        > div.prodSlick-slide  (图片轮播)
          > img.lead_prod_img
    > div.prodDetail_info
      > h1 (产品名)
      > div.price
      > div.description
```

### 检测要点

- 非列表型，无重复子项
- 有大图轮播 + 详细参数区
- class 中含 `prodDetail`, `blockDetail`, `lead_prod`

---

## 5. 无模板类型 (保留检测)

以下类型当前无 FTL 模板，但检测逻辑保留以备扩展：

### galleryList (图册列表)

- URL: `/gallery/`, `/photo/`, `/album/`, `/portfolio/`, `/works/`
- 内容: 图片网格，`lightbox` 类名
- class: `gallery-list`, `galleryList`, `gallery-grid`, `lightbox`

### videoList (视频列表)

- URL: `youtube.com`, `vimeo.com`, `/video/`
- 内容: `<video>` 或视频平台 `<iframe>`
- class: `video-list`, `videoList`, `video-grid`, `video-card`

### downloadList (下载列表)

- URL: `/download/`, `/resource/`, `/file/`, `/docs/`, `/resources/`
- 内容: `.pdf`, `.zip`, `.doc` 等文件扩展名, `MB`/`KB`/`GB` 大小
- class: `download-list`, `downloadList`, `download-item`

### FAQList (FAQ 列表)

- URL: `/faq/`, `/help/`, `/support/`
- 内容: 手风琴/折叠结构, 问号结尾
- class: `faq-list`, `faqList`, `faq-item`, `accordion`

---

## 6. 类型区分速查表

| 特征 | prodList | articleList | groupProduct | prodDetail |
|------|----------|-------------|--------------|------------|
| 列表项数 | >=3 | >=3 | 分类>=2, 每组>=1 | 1 (非列表) |
| 价格 | 有 | 无 | 分类无, 产品有 | 有 |
| 日期 | 无 | 有 (publishTime) | 无 | 无 |
| 分类标签 | 无 | 可选 (cateName) | 有 (groupName) | 无 |
| 图片 | photoUrlList | photoUrlNormal | groupPhotoUrlList | photoUrlList |
| 特征 class | `proshow-*` | `ArticlePicList_*` | `prodCategoty-*` | `prodDetail_*` |
| 嵌套 | 单层 | 单层 | 二层 | 非列表 |
