<section class="news-articles fade-in" id="news-articles">

  
[@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"
            selectArticleCateType="${dataType!'0'}" selectCateIds="${dataGroupId!''}" selectArticleIds="${dataIds!''}" currentPageIdForRelated="${pageId!-1}"
            orderBy="${orderBy!'0'}" expandIds="${expandIds!''}" articleId="${infoId!-1}" articlePageId="${infoGroupId!-1}"
            prodRelatedId="${productId!-1}"
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
                    articleStatus: "1"
                    prodRelatedId: "$prodRelatedId"
                    currentPageIdForRelated: "$currentPageIdForRelated"
                    }) {
                    totalRow
                    pageSize
                    pageNumber
                    extraData{
                        articleStructureData
                        articleSummaryRichTextFlag
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
<div class="container">
    <div class="grid">
      
[#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
[#list data.articleList.list as article]
<div class="article-card"><a href="${article.articleUrl!''}" class="thumb"><img src="${article.photoUrlNormal!''}" alt="${article.articleTitle!''}"></a>
        <div class="info">
          <h3><a href="${article.articleUrl!''}">${article.articleTitle!''}</a></h3>
          <div class="date">${article.publishTime!''}</div>
        </div>
        <div class="arrow"><span>❯</span></div>
      </div>
[/#list]
[#else]
<div class="no-data">No content available</div>
[/#if]

      
      
    </div>
  </div>
<input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}">
<input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
<input type="hidden" name="pageSize" value="${data.articleList.pageSize!'10'}">
<script>
                \$(function(){
                    window._block_namespaces_['articleList_27472'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'aaa_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}','articlePageId':"${infoGroupId!}"});
                });
            <\/script>
[/@api]

</section>