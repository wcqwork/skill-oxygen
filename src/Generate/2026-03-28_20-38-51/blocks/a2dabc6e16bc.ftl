<div class="block_a2dabc6e16bc" data-gjs-type="phoenix-container" data-strong="1">
    <div class="backstage-blocksEditor-wrap block34604" data-block-uuid="a2dabc6e16bc" data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,loadMethod,pageNumber,refreshMethod,dataOrderBy,showDate,jumpMethod" data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":8,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"1","refreshMethod":"0","jumpMethod":"1","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
<div class="swiper-wrapper">
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

        
[#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
[#list data.articleList.list as article]
<div class="swiper-slide blog-card">
          <div class="blog-card-thumb">
            <img src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
            <span class="category-tag">${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}</span>
          </div>
          <div class="blog-card-meta">
            <span>MARCH 20, 2020</span>
            <span class="sep"></span>
            <span>TOM BLACK</span>
          </div>
          <h5><a href="${article.articleUrl!''}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a></h5>
          <p>${article.articleSummary!''}</p>
        </div>
[/#list]
[#else]
<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
[/#if]

        
        
      
<input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}">
<input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
<input type="hidden" name="pageSize" value="${data.articleList.pageSize!'10'}">
<script type="application/ld+json">${data.articleList.extraData.articleStructureData!""}</script>
[/@api]
</div>
        <script>
            $(function () {
                window._block_namespaces_['block_a2dabc6e16bc'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
            });
        </script>
    </div>
</div>