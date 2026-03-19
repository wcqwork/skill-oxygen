<div class="block34134" data-gjs-type="phoenix-container" data-strong="1">
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
	<div class="backstage-blocksEditor-wrap wra" data-block-uuid="cyber" data-gjs-type="developer-node-component"
		data-block-type="phoenix_blocks_Articlelist"
		data-block-list-setting="dataSelect,loadMethod,pageNumber,dataOrderBy,showDate"
		data-default-setting={"pageSize":3,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"1","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #62c6ff);
      			--color-match-setting2: var(--ld-Auxiliary1, #37383e);
			}
		</style>

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
		<div class="cont">
			<div class="Article_Container">
				<div class="zh articalWrap block-article-container-replace">
					[#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
					[#list data.articleList.list as article]
					<article class="ArticlePicList_Item">
						<div class="imgBtn">
							<div class="imgBox">
								<div class="img">
									<a class="maskT" href="${article.articleUrl!}"></a>
									<source media="(min-width: 768px)" data-srcset="${article.photoUrlNormal!}" />
									<source media="(max-width: 767px)" data-srcset="${article.photoUrlNormal!}" />
									<img class="headlines-content-img ArticlePicList_ItemImg lazyimg" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">

                                </div>
									<div class="butn">
										<a class="ArticlePicList_ItemContentInnerA paragraph2" href="${article.articleUrl!}">
											<span>[@s.m "phoenix_block_news" /]</span>
										</a>
									</div>
								</div>
							</div>
							<div class="ArticlePicList_ItemContent">
								<div class="ArticlePicList_ItemContentInner">
									<div class="ArticlePicList_ItemContentInnerBox">
										[#if showDate?? && showDate == '1']
										<time class="artime paragraph2">${article.publishTime!}</time>
										[/#if]
										<h3 class="ArticlePicList_ItemContentInnerH5">
											<a class="heading5" href="${article.articleUrl!}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
										</h3>
										<div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph2">${article.articleSummary!''}</div>
										<div class="butn1">
											<a class="ArticlePicList_ItemContentInnerA paragraph2" href="${article.articleUrl!}">
												<span>[@s.m "phoenix_block_news" /]</span>
											</a>
										</div>
									</div>
								</div>
							</div>
					</article>
					[/#list]
					[#else]
					<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
					[/#if]


				</div>

				<input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}">
				<input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
				<input type="hidden" name="pageSize" value="${data.articleList.pageSize!'10'}">

 				[#if (dataType?? && dataType != '3') && (!loadMethod?? || loadMethod == '0')]
				<div
					class="artclelist-site-pagination-34134 [#if data.articleList.pageSize?? && data.articleList.totalRow?? && data.articleList.totalRow <=  data.articleList.pageSize]hide[/#if]">
					<div class="artclelist-laypage-normal" id='artclelist-laypage-normal'></div>
				</div>
				[/#if]
			</div>
		</div>
		<script>
			$(function () {
                    window._block_namespaces_['block34134'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'nodeId':'cyber_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
                });
		</script>
		<script type="application/ld+json">
			${data.articleList.extraData.articleStructureData!""}
		</script>
		[/@api]

	</div>
</div>