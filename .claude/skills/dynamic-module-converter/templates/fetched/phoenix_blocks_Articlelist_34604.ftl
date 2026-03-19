<div 
  data-gjs-type="phoenix-container"
  data-strong="1"
>
<style>
    [data-new-auto-uuid="${pageNodeId!''}"] {
        --color-match-setting1: var(--ld-main1, rgb(0, 144, 211));
        --color-match-setting2: var(--ld-Auxiliary1, rgb(0, 0, 0));
        --color-match-setting3: var(--ld-Auxiliary2, rgb(255, 255, 255));
    }
</style>
  <div class="block34604" data-block-uuid="articlelist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,loadMethod,pageNumber,refreshMethod,dataOrderBy,showDate,jumpMethod" 
  data-block-type="phoenix_blocks_Articlelist" 
  data-default-setting={"pageSize":8,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"1","refreshMethod":"0","jumpMethod":"1","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>


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
                        paginationUrl
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
            
            <div class="block-article-container-replace ">
                <div class="block-article-container  articalWrap">
                    [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                        [#list data.articleList.list as article]
                            <div class="ArticlePicList_Item clearfix">
                                [#if jumpMethod?? && jumpMethod == '0']
                                <a href="${article.articleUrl!''}" title="${article.articleTitle!?html}" target ="_blank"></a> 
                                [#else]
                                <a href="${article.articleUrl!''}" title="${article.articleTitle!?html}"></a> 
                                [/#if]
                                <div class="imgBox">
                                    <picture>
                                        <source media="(min-width: 450px)" srcset='${article.photoUrlNormal!}' />
                                        <source media="(max-width: 449px)" srcset='${article.photoUrlNormal!}' />
                                        <img loading="lazy" class="headlines-content-img ArticlePicList_ItemImg" src='${article.photoUrlNormal!}' alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                                    </picture>
                                </div>
                                 <div class="ArticlePicList_ItemContent">
                                    <div class="ArticlePicList_ItemContentInner">
                                        <div class="ArticlePicList_ItemContentInnerBox">
                                            <h3 class="ArticlePicList_ItemContentInnerH5 header5">
                                                [#if jumpMethod?? && jumpMethod == '0']
                                                    <a class="heading5" href="${article.articleUrl!''}" title="${article.articleTitle!?html}" title="${article.articleTitle!?html}" target ="_blank">${article.articleTitle!?html}</a>
                                                [#else]
                                                    <a class="heading5" href="${article.articleUrl!''}" title="${article.articleTitle!?html}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                                [/#if]
                                            </h3>
                                            <p class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</p>
                                            <a class="ArticlePicList_ItemContentInnerA paragraph2" href="${article.articleUrl!''}" title="${article.articleTitle!?html}"><span>[@s.m "phoenix_read_more" /]</span></a>
                                        </div>
                                    </div>
                                </div>
                                [#if jumpMethod?? && jumpMethod == '0']
                                    <a class="iconA" href="${article.articleUrl!''}" title="${article.articleTitle!?html}" title="${article.articleTitle!?html}" target ="_blank">
                                [#else]
                                    <a class="iconA" href="${article.articleUrl!''}" title="${article.articleTitle!?html}" title="${article.articleTitle!?html}">
                                [/#if]
                                    <i class="icon iconfont_phoenix icon-jiantouyou you1"></i>
                                    <i class="icon iconfont_phoenix icon-jiantouyou you2"></i>
                                </a>
                                [#if showDate?? && showDate=='1']
                                <div class="time paragraph2">
                                   <span>${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}</span> ${article.publishTime?date("yyyy-MM-dd")?string('MM')}-${article.publishTime?date("yyyy-MM-dd")?string('dd')}
                                </div> 
                                [/#if]
                            </div>
                        [/#list]
                    [#else]
                        <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                    [/#if]
                </div>
                <input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}"> 
                <input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
                <input type="hidden" name="pageSize" value="${data.articleList.pageSize!'10'}">
                <input type="hidden" name="refreshMethod" value="${refreshMethod!''}">
                <input type="hidden" name="paginationUrl" value="${data.articleList.extraData.paginationUrl!''}">
            </div>

            
            [#if (dataType?? && dataType != '3') && (!loadMethod?? || loadMethod == '0') && !(data.articleList.pageSize?? && data.articleList.totalRow?? && data.articleList.totalRow <=  data.articleList.pageSize)]
                <div class="artclelist-site-pagination">
                    <div class="artclelist-laypage-normal" id='artclelist-laypage-normal'></div>
                </div>
            [/#if]
        	<script>
                $(function(){
                    window._block_namespaces_['block34604'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
            </script>
             <script type="application/ld+json">
                 ${data.articleList.extraData.articleStructureData!""}
            </script>
	[/@api]
  </div>
</div>