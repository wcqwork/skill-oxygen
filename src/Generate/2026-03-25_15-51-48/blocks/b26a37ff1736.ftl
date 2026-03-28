<div class="block_b26a37ff1736" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
        .block35024 .left .ArticlePicList_ItemContentInnerH5,
        .block35024 .left .ArticlePicList_ItemContentInnerP,
        .block35024 .left .ArticlePicList_ItemContentInnerH5 a,
        .block35024 .art .ArticlePicList_ItemContentInnerBox,
        .block35024 .left .time {
            text-align: right;
            direction: rtl;
        }
        </style>
    [/#if]

    <div class="backstage-blocksEditor-wrap block35024" data-block-uuid="b26a37ff1736" data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber,dataOrderBy,showDate,jumpMethod" data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":4,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"1","expandIds":{"showField":{"draggable":false,"data":[{"fieldName":"文章标题","checked":false,"fieldType":"0","value":"1","fieldId":"articleTitle"},{"fieldName":"文章简介","checked":false,"fieldType":"0","value":"2","fieldId":"articleSummary"},{"fieldName":"日期","checked":false,"fieldType":"0","value":"3","fieldId":"publishTime"},{"fieldName":"文章分类","checked":false,"fieldType":"0","value":"4","fieldId":"cateName"}],"label":"显示字段","key":"showField"}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
        <style>
      [data-new-auto-uuid="${pageNodeId!''}"] {
        --color-match-setting1: var(--ld-main1, rgb(74, 134, 232));
      }
    </style>
<div class="swiper-wrapper">
[@api method="post"  url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"
            selectArticleCateType="${dataType!'0'}" selectCateIds="${dataGroupId!''}" selectArticleIds="${dataIds!''}"
            orderBy="${orderBy!'0'}" expandIds="${expandIds!''}" jumpMethod="${jumpMethod!'0'}" articleId="${infoId!-1}" articlePageId="${infoGroupId!-1}"
			query='{
				articleList(
                    conditionDto:{
                    page: $page
                    limit: $limit
                    optionsParam: $optionsParam
                    selectCateIds: $selectCateIds
                    selectArticleIds: $selectArticleIds
                    selectArticleCateType: "$selectArticleCateType"
                    orderBy: "$orderBy"
                    articleRelatedId: "$articleId"
                    articlePageId: "$articlePageId"
                    }) {
                    totalRow
                    pageSize
                    pageNumber
                    extraData{
                        articleStructureData
                    }
                    list{
                        encodeId
                        articleTitle
                        publishTime
                        articleUrl
                        articleSummary
                        topFlag
                        photoUrlNormal
                        photoUrlDefine
                        cateName
                        cateUrl
                        showFieldList
                        $showField
                        photoSeoList{
                            photoId
                            photoUrlNormal
                            photoAlt
                            photoTitle
                        }
                    }
                }
			}']

        
[#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 4)] <div class="prev"> <i class="icon iconfont_phoenix icon-angle-up lead_icon lead-icon-type"></i> </div> <div class="next"> <i class="icon iconfont_phoenix icon-angle-down lead_icon lead-icon-type"></i> </div> [/#if] <div class="art"> [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
[#list data.articleList.list as article]
<div class="swiper-slide blog-card">
          <div class="blog-card-thumb">
            <img src="${article.photoUrlNormal!''}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
            <span class="category-tag">Interior</span>
          </div>
          <div class="blog-card-meta">
            <span>MARCH 20, 2020</span>
            <span class="sep"></span>
            <span>TOM BLACK</span>
          </div>
          <h5><a href="#">Top 10 Tips for Your Kitchen Interior Design</a></h5>
          <p>A faceting effect livens up and...</p>
        </div>
[/#list]
[#else]
<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
[/#if]
</div>
        
        
      
<script type="application/ld+json">${data.articleList.extraData.articleStructureData!""}</script>
[/@api]
</div>
        <script>
            $(function () {
                window._block_namespaces_['block_b26a37ff1736'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
            });
        </script>
    </div>
</div>