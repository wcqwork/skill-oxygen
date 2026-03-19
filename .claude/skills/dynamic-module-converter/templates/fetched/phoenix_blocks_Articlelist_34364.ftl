<div data-gjs-type="phoenix-container" data-strong="1">
  <div class="backstage-blocksEditor-wrap block34364" data-block-uuid="articlelist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,loadMethod,pageNumber,dataOrderBy,showDate" 
  data-block-type="phoenix_blocks_Articlelist" 
  data-default-setting={"pageSize":8,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"1","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"draggable":false,"data":[{"fieldName":"文章标题","checked":false,"fieldType":"0","value":"1","fieldId":"articleTitle"},{"fieldName":"文章简介","checked":false,"fieldType":"0","value":"2","fieldId":"articleSummary"},{"fieldName":"日期","checked":false,"fieldType":"0","value":"3","fieldId":"publishTime"},{"fieldName":"文章分类","checked":false,"fieldType":"0","value":"4","fieldId":"cateName"}],"label":"显示字段","key":"showField"}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>

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
                        photoSeoList{
                            photoId
                            photoUrlNormal
                            photoAlt
                            photoTitle
                        }
                        cateName
                        cateUrl
                        showFieldList
                        $showField
                    }
                }
			}']
            
            <div class="block-article-container-replace ">
                <div class="block-article-container artwaterfall-container-box articalWrap">
                    [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                    <div class="masonry">
                        [#list data.articleList.list as article]
                                    <div class="artwaterfall-article-box init-style">
                                                
                                        <div class="artwaterfall-article">
                                                <a  href="${article.articleUrl!''}" title="${article.articleTitle!?html}">
                                                    <div class="artwaterfall-img-box">
                                                            <img class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!''}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}" />
                                                    </div>
                                                </a>
                                            <div class="artwaterfall-text-box">
                                                <h3 class="heading5">
                                                    <a class="artwaterfall-title heading5" href="${article.articleUrl!''}" title="${article.articleTitle!?html}">
                                                        ${article.articleTitle!?html}
                                                    </a>
                                                </h3>
                                                <div class="articleList-summary ArticlePicList_ItemContentInnerP artwaterfall-content paragraph1">
                                                    ${article.articleSummary!''}
                                                </div>
                                                <div class="artwaterfall-btn">
                                                    <a href="${article.articleUrl!''}" title="${article.articleTitle!?html}">
                                                        <div >
                                                            <span class="artwaterfall-btn-text paragraph2" >
                                                                [@s.m "phoenix_view_more"/] >>
                                                            </span>
                                                            <span class="artwaterfall-btn-underline">
                                                            </span>
                                                        </div>
                                                    </a>
                                                </div>
                                            </div>
                                            [#if showDate && showDate == 1]
                                            <time class="artwaterfall-date-box paragraph2">
                                                ${article.publishTime!''}
                                            </time>
                                            [/#if]
                                        </div>
                                    </div>
                        [/#list]
                         </div>
                    [#else]
                        <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                    [/#if]
                </div>
                <input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}"> 
                <input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
                <input type="hidden" name="pageSize" value="${data.articleList.pageSize!'10'}">
            </div>

            
            [#if (dataType?? && dataType != '3') && (!loadMethod?? || loadMethod == '0') && !(data.articleList.pageSize?? && data.articleList.totalRow?? && data.articleList.totalRow <=  data.articleList.pageSize)]
                <div class="artclelist-site-pagination">
                    <div class="artclelist-laypage-normal" id='artclelist-laypage-normal'></div>
                </div>
            [/#if]
        	<script>
                $(function(){
                    window._block_namespaces_['block34364'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
            </script>
             <script type="application/ld+json">
                 ${data.articleList.extraData.articleStructureData!""}
            </script>
	[/@api]

 

  </div>
</div>