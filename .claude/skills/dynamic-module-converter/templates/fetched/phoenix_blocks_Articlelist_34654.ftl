<div data-gjs-type="phoenix-container" data-strong="1">

	    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
		[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
			<style data-collect='1'>
				.block34654 .ArticlePicList_Item{
					direction: rtl;
					text-align: right;
				}
				.block34654 .mark23314 .page-more {
					left: unset;
					right:15.36%;
				}
				div.block34654 .mark23314 .page-more {
					right: 20px;
					left: auto;
				}
				.block34654 .mark23314 .page-more svg {
					transform: rotate(180deg);
					position: absolute;
					top: 50%;
					padding-left: 5px;					
				}			
				.block34654 .artclelist-site-pagination a.layui-laypage-prev,
				.block34654 .artclelist-site-pagination a.layui-laypage-next {
					transform: rotate(180deg);
				}									
			</style>
		[/#if]
	<div data-block-uuid="articlelist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,loadMethod,pageNumber,dataOrderBy"
		data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":8,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"1","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1,rgb(255, 193, 7));
      			--color-match-setting2: var(--ld-Auxiliary1,rgb(34, 34, 34));
			}
		</style>
		<div class="block34654">
[@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"
					selectArticleCateType="${dataType!'0'}" selectCateIds="${dataGroupId!''}"
					selectArticleIds="${dataIds!''}"
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
			<div class="Article_Container">
				<div class="articalWrap imgTextBoxs block-article-container-replace">

					

					[#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
					[#list data.articleList.list as article]
					<div class="ArticlePicList_Item item">
						<div class="item-picture">
							<picture style="width: 100%;position:relative;">
								<source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
								<source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />
								<img class="headlines-content-img ArticlePicList_ItemImg"  loading="lazy" style="width: 100%;" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                     </picture>

								<div class="bottom23314">
									<a class="ArticlePicList_ItemContentInnerA page-more"
										href="${article.articleUrl!}"><span class="kong"></span></a>
									<div class="ArticlePicList_ItemContent item-page" style="width:100%;height:100%;">
										<div class="ArticlePicList_ItemContentInner">
											<div class="ArticlePicList_ItemContentInnerBox">
												<h3 class="ArticlePicList_ItemContentInnerH5 page-title heading5">
													<a href="${article.articleUrl!}"
														title="${article.articleTitle!?html}" class="heading5">${article.articleTitle!?html}</a>
												</h3>

												<div class="ArticlePicList_ItemContentInnerTrans"></div>
											</div>
										</div>
									</div>
								</div>
								<div class="mark23314">
									<div class="ArticlePicList_ItemContent item-page" style="width:100%;height:100%;">
										<div class="ArticlePicList_ItemContentInner" style="width:100%;height:100%;">
											<div class="ArticlePicList_ItemContentInnerBox"
												style="width:100%;height:100%;">
												<h3 class="ArticlePicList_ItemContentInnerH5 page-title heading5">
													<a href="${article.articleUrl!}" class="heading5"
														title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
												</h3>
												<div
													class="articleList-summary ArticlePicList_ItemContentInnerP page-sum paragraph1">
													${article.articleSummary!''}</div>
												<a class="ArticlePicList_ItemContentInnerA page-more link1"
													href="${article.articleUrl!}"><span>[@s.m "phoenix_read_more" /]</span>
													<svg width="16" height="16" viewBox="0 0 20 20" fill="none"
														xmlns="http://www.w3.org/2000/svg">
														<path
															d="M15.0378 6.34317L13.6269 7.76069L16.8972 11.0157L3.29211 11.0293L3.29413 13.0293L16.8619 13.0157L13.6467 16.2459L15.0643 17.6568L20.7079 11.9868L15.0378 6.34317Z"
															fill="currentColor" /></svg></a>
												<div class="ArticlePicList_ItemContentInnerTrans"></div>
											</div>
										</div>
									</div>
								</div>
						</div>
					</div>

					[/#list]
					[#else]
					<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
					[/#if]


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
                        window._block_namespaces_['block34654'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
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