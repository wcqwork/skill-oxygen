# Template Registry — Block Type → Template File Mapping

## Overview

Maps `data-block-type` values to their FreeMarker template files. Templates are stored in `templates/fetched/` (auto-fetched via `template-fetcher` skill).

## Block Types (22+ types)

### Product

| data-block-type | Template File | Label | appId |
|---|---|---|---|
| `phoenix_blocks_prodlist` | `phoenix_blocks_prodlist.ftl` | 产品列表 | — |
| `phoenix_blocks_groupProduct` | `phoenix_blocks_groupProduct.ftl` | 产品分类(旧版) | — |
| `phoenix_blocks_groupProduct_new` | `phoenix_blocks_groupProduct_new.ftl` | 产品分类(新版) | — |

### Article

| data-block-type | Template File | Label | appId |
|---|---|---|---|
| `phoenix_blocks_Articlelist` | `phoenix_blocks_Articlelist.ftl` | 文章列表 | — |
| `phoenix_blocks_articleDetail` | `phoenix_blocks_articleDetail.ftl` | 文章详情 | — |
| `phoenix_blocks_groupArticle_new` | `phoenix_blocks_groupArticle_new.ftl` | 文章分类(新版) | — |

### Download

| data-block-type | Template File | Label | appId |
|---|---|---|---|
| `phoenix_blocks_downloadlist` | `phoenix_blocks_downloadlist.ftl` | 下载列表 | — |
| `phoenix_blocks_downloadGroup_new` | `phoenix_blocks_downloadGroup_new.ftl` | 下载分类(新版) | — |

### Video

| data-block-type | Template File | Label | appId |
|---|---|---|---|
| `phoenix_blocks_videoList` | `phoenix_blocks_videoList.ftl` | 视频列表 | — |
| `phoenix_blocks_videoGroup_new` | `phoenix_blocks_videoGroup_new.ftl` | 视频分类(新版) | — |

### Gallery

| data-block-type | Template File | Label | appId |
|---|---|---|---|
| `phoenix_blocks_galleryList` | `phoenix_blocks_galleryList.ftl` | 图册列表 | — |
| `phoenix_blocks_galleryDetail` | `phoenix_blocks_galleryDetail.ftl` | 图册详情 | — |
| `phoenix_blocks_galleryGroup_new` | `phoenix_blocks_galleryGroup_new.ftl` | 图册分类(新版) | — |

### FAQ

| data-block-type | Template File | Label | appId |
|---|---|---|---|
| `phoenix_blocks_faqList` | `phoenix_blocks_faqList.ftl` | FAQ列表 | — |
| `phoenix_blocks_faqGroup` | `phoenix_blocks_faqGroup.ftl` | FAQ分类(旧版) | — |
| `phoenix_blocks_faqGroup_new` | `phoenix_blocks_faqGroup_new.ftl` | FAQ分类(新版) | — |

### Other Dynamic Types

| data-block-type | Template File | Label | appId |
|---|---|---|---|
| `phoenix_blocks_commentList` | `phoenix_blocks_commentList.ftl` | 评价列表 | — |
| `phoenix_blocks_search` | `phoenix_blocks_search.ftl` | 搜索 | — |
| `phoenix_blocks_searchResult` | `phoenix_blocks_searchResult.ftl` | 搜索结果 | — |
| `phoenix_blocks_keywordindex` | `phoenix_blocks_keywordindex.ftl` | 关键词索引 | — |
| `phoenix_blocks_position` | `phoenix_blocks_position.ftl` | 面包屑导航 | — |
| `phoenix_blocks_memberAccount` | `phoenix_blocks_memberAccount.ftl` | 会员账户 | — |
| `phoenix_blocks_siteMap` | `phoenix_blocks_siteMap.ftl` | 站点地图 | — |

### Element-Level Dynamic Components (页头元素)

These use `phoenix_element_dynamicComponents` as the block type but are differentiated by `blockUuid`:

| data-block-type | blockUuid | Template File | Label |
|---|---|---|---|
| `phoenix_element_dynamicComponents` | `navigation` | `phoenix_element_dynamicComponents_navigation.ftl` | 导航栏 |
| `phoenix_element_dynamicComponents` | `languageBar` | `phoenix_element_dynamicComponents_languageBar.ftl` | 语言栏 |
| `phoenix_element_dynamicComponents` | `searchBox` | `phoenix_element_dynamicComponents_searchBox.ftl` | 搜索框 |
| `phoenix_element_dynamicComponents` | `logo` | `phoenix_element_dynamicComponents_logo.ftl` | Logo |
| `phoenix_element_dynamicComponents` | `share` | `phoenix_element_dynamicComponents_share.ftl` | 分享按钮 |
| `phoenix_element_dynamicComponents` | (other) | `phoenix_element_dynamicComponents_{uuid}.ftl` | 其他元素 |

## Template Sources

1. **Auto-fetched**: Run `/fetch-templates -t dynamic` to download all templates from the management platform
2. **Manual**: Place `.ftl` files in `templates/` directory
3. **Registry**: `templates/fetched/_registry.json` contains full metadata index

## Using Templates

When injecting markers in Phase 3, look up the template by `blockType`:

```javascript
const registry = JSON.parse(fs.readFileSync('templates/fetched/_registry.json'));
const entry = registry.find(r => r.blockType === blockType);
const template = fs.readFileSync(`templates/fetched/${entry.fileName}`, 'utf-8');
```
