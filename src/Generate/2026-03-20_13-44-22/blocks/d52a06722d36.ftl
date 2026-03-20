<div class="block_d52a06722d36" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
	[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
		<!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
		<style data-collect='1'>
			div.block34134 .butn {
				position: absolute;
				left: auto;
				right: 25px;
			}
		</style>
	[/#if]

    <div class="backstage-blocksEditor-wrap wra" data-block-uuid="d52a06722d36" data-gjs-type="developer-node-component" data-block-type="phoenix_blocks_Articlelist" data-block-list-setting="dataSelect,loadMethod,pageNumber,dataOrderBy,showDate" data-default-setting={"pageSize":3,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"1","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
        <style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #62c6ff);
      			--color-match-setting2: var(--ld-Auxiliary1, #37383e);
			}
		</style>
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
<div class="swiper-slide blog-card"><div class="blog-card-thumb">
            <img src="${article.photoUrlNormal!''}" alt="${article.articleTitle!''}">
            <span class="category-tag">Interior</span>
          </div>
          <div class="blog-card-meta">
            <span>${article.publishTime!''}</span>
            <span class="sep"></span>
            <span>TOM BLACK</span>
          </div>
          <h5><a href="${article.articleUrl!''}">${article.articleTitle!''}</a></h5>
          <p>${article.articleSummary!''}</p>
        </div>
[/#list]
[#else]
<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
[/#if]

        
        
      
<input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}">
<input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
<input type="hidden" name="pageSize" value="${data.articleList.pageSize!'10'}">
<script type="application/ld+json">
${data.articleList.extraData.articleStructureData!""}
</script>
[/@api]
</div>
        <script>
            $(function () {
                window._block_namespaces_['block_d52a06722d36'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
            });
        </script>
    </div>
</div>