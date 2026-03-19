<div data-gjs-type="phoenix-container" data-strong="1">

	[#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
	[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
	<style data-collect='1'>
		.block35684 .ArticlePicList_Item {
			direction: rtl;
		}
		.block35684 .artclelist-site-pagination a.layui-laypage-prev,
		.block35684 .artclelist-site-pagination a.layui-laypage-next {
			transform: rotate(180deg);
		}	
		@media (min-width: 767px) {
			div.block35684 .articleTile:nth-of-type(1) .textBox {
				padding: 20px 30px 20px 150px;
				margin-left: -15px;
				margin-right: auto;		
			}
			div.block35684 .textBox {
				padding: 20px 30px 20px 80px;
				margin-right: 30px;
				margin-left: -10px;			
			}			
		}			
		div.block35684 .line {
			position: absolute;
			right: 30px;
			left: auto;
		}	
		div.block35684 a.icon i {
			position: absolute;
			right: auto;
			left: 20px;
			transform: rotate(180deg);
		}	
		@media (min-width: 1024px) {
			div.block35684 .articleTile:hover .textBox {
				transform: translate3d(-.25rem,-.25rem,0);
			}			
		}								
	</style>
	[/#if]

	<div class="backstage-blocksEditor-wrap" data-block-uuid="articlelist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,pageNumber,dataOrderBy" data-block-type="phoenix_blocks_Articlelist"
		data-default-setting={"pageSize":7,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #00B1DD);
      			--color-match-setting2: var(--ld-Auxiliary1, #0D0D0D);
				--color-match-setting3: var(--ld-Auxiliary2, #333333);
			}
		</style>

		<div class="block35684">

			[@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"
			selectArticleCateType="${dataType!'0'}" selectCateIds="${dataGroupId!''}" selectArticleIds="${dataIds!''}"
			orderBy="${orderBy!'0'}" expandIds="${expandIds!''}" articleId="${infoId!-1}"
			articlePageId="${infoGroupId!-1}"
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
			<div class="Article_Container articleBox">

				<div class="articleWra">
					[#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
					[#list data.articleList.list as article]
					<div class="ArticlePicList_Item articleTile">
						<div class="imgBox">
							<picture>
								<source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
								<source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />
								<img class="headlines-content-img ArticlePicList_ItemImg articleImg" loading="lazy" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                            </picture>
						</div>
						<div class="ArticlePicList_ItemContent textBox">
							<div class="ArticlePicList_ItemContentInner">
								<div class="ArticlePicList_ItemContentInnerBox">
									<div class="line"></div>
									<a class="ArticlePicList_ItemContentInnerA icon" href="${article.articleUrl!}">
										<i class="icon iconfont_phoenix icon-jiantouyou-5"> </i>
									</a>
									<div class="line02"></div>
									<h3 class="ArticlePicList_ItemContentInnerH5 h5Style">
										<a class="heading5" href="${article.articleUrl!}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
									</h3>
									<div class="articleList-summary ArticlePicList_ItemContentInnerP pStyle paragraph1">${article.articleSummary!''}</div>
									<a class="ArticlePicList_ItemContentInnerA button paragraph2" href="${article.articleUrl!}"><span>[@s.m "phoenix_read_more" /]</span></a>
									<div class="ArticlePicList_ItemContentInnerTrans"></div>
								</div>
							</div>
						</div>
					</div>
					[/#list]

					[#else]
					<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
					[/#if]

				</div>


				<input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}">
				<input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
				<input type="hidden" name="pageSize" value="${data.articleList.pageSize!'10'}">

                [#if (dataType?? && dataType != '3') && !(data.articleList.pageSize?? && data.articleList.totalRow?? && data.articleList.totalRow
				<= data.articleList.pageSize)] <div class="artclelist-site-pagination">
					<div class="artclelist-laypage-normal" id='artclelist-laypage-normal'></div>
			</div>
			[/#if]
			<script>
				$(function(){
                    window._block_namespaces_['block35684'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
			</script>
			<script type="application/ld+json">
				${data.articleList.extraData.articleStructureData!""}
			</script>

		</div>
		[/@api]

	</div>

</div>
</div>