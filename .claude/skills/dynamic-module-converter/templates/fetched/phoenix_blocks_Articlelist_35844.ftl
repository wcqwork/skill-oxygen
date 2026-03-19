<div class="blockphoenix35844" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
	[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
	<!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
	<style data-collect='1'>
		.block35844 {
            transform: translateX(10px);
            direction: rtl !important;
        }
        .blockphoenix35844,
        .block35844 * {
            direction: rtl !important;
        }
	</style>
	[/#if]
    <style>
        .block35844 .artwaterfall-container {
            opacity: 0;
        }
        .block35844 .artwaterfall-container.active {
            opacity: 1;
        }
    </style>
  <div class="backstage-blocksEditor-wrap block35844" data-block-uuid="articlelist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber,dataOrderBy,showDate" 
  data-block-type="phoenix_blocks_Articlelist" 
  data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
    <style>
      [data-new-auto-uuid="${pageNodeId!''}"] {
        --color-match-setting1: var(--ld-main1,#61ce70);

        /* --color-match-ellipses-title-setting1: var(--ld-title5-color, #000);
        --color-match-ellipses-docs-setting1: var(--ld-text1-color, #000); */
      }
    </style>

    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            .block35844 .artwaterfall-text-box {
                text-align: right;
                direction: rtl !important;
            }
        </style>
    [/#if]

    <style styleDefault-block="true">
        .block35844 .artwaterfall-container {
            display: flex;
        }
        .block35844 .artwaterfall-container .artwaterfall-article-box:nth-of-type(n+4) {
            display: none;
        }
    </style>


    <div class="content">
        [@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"
                selectArticleCateType="${dataType!'0'}" selectCateIds="${dataGroupId!''}" selectArticleIds="${dataIds!''}"
                orderBy="${orderBy!'0'}" expandIds="${expandIds!''}" articleId="${infoId!-1}" articlePageId="${infoGroupId!-1}"
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
                        }
                    }
                }']
                <div class="artwaterfall-container-box">
                    <div class="artwaterfall-container">	
                        [#list data.articleList.list as article]
                        <div class="artwaterfall-article-box">
                            <div class="artwaterfall-article">
                                <div class="artwaterfall-img-box">
                                    <a href="${article.articleUrl!''}" title="${article.articleTitle!?html}">
                                        <img class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!''}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                                    </a>
                                </div>
                                <div class="artwaterfall-text-box">
                                    <h3>
                                        <a class="artwaterfall-title heading5" href="${article.articleUrl!''}" title="${article.articleTitle!?html}">
                                            ${article.articleTitle!?html}
                                        </a>
                                    </h3>
                                    
                                    <div class="articleList-summary ArticlePicList_ItemContentInnerP artwaterfall-content paragraph1">
                                        ${article.articleSummary!''}
                                    </div>
                                    <div class="artwaterfall-btn">
                                        <div>
                                            <a class="ArticlePicList_ItemContentInnerA" href="${article.articleUrl!''}" >
                                                <span class="artwaterfall-btn-text paragraph2">
                                                    [@s.m "phoenix_view_more" /] >>
                                                </span>
                                                <span class="artwaterfall-btn-underline"></span>
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                [#if showDate && showDate == 1]
                                <time class="artwaterfall-date-box 666 paragraph2">
                                    ${article.publishTime?date("yyyy-MM-dd")}                                           
                                </time>
                                [/#if]
                            </div>
                        
                        </div>
                        [/#list]
                        
                    </div>
                </div>
                <script>
                    $(function(){
                        window._block_namespaces_['block35844'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                    });
                </script>
                <script type="application/ld+json">
                    ${data.articleList.extraData.articleStructureData!""}
                </script>
        [/@api]
    </div>
  </div>
</div>