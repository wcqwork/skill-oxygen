<div data-gjs-type="phoenix-container" data-strong="1">

	[#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
	[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
	<!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
	<style data-collect='1'>
		.block34464 .box {
			direction: ltr!important;
		}
	</style>
	[/#if]
	<style>
		.block34464 .articalWrap {
			display: flex;
			opacity: 0;
		}
		.block34464 .articalWrap.slick-initialized {
			display: block;
			opacity: 1;
			transition: all 0.5s;
		}
		.block34464 .arrowBtn {
			opacity: 0;
		}
		.block34464 .articalWrap.slick-initialized ~ .arrowBtn {
			opacity: 1;
			transition: all 0.5s;
		}
	</style>
	<div class="backstage-blocksEditor-wrap" data-block-uuid="articlelist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,showDate,pageNumber,dataOrderBy"
		data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":8,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, rgb(255, 153, 0));
			}
		</style>

		<div class="block34464">
			<div class="Box">
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
				cateName
				cateUrl
				showFieldList
				photoSeoList{
					photoId
					photoUrlNormal
					photoAlt
					photoTitle
				}
				$showField
				}
				}
				}']
				<div class="Article_Container">
					<div class=" box" style="position:relative;">
						[#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
						<div class="articalWrap">
							[#list data.articleList.list as article]
							<div class="ArticlePicList_Item">
								<div class="image">
									<picture>
										<source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
										<source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />
										<img class="headlines-content-img ArticlePicList_ItemImg" loading="lazy" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}" />
                                    </picture>
								</div>

								<div class="ArticlePicList_ItemContent">
									<div class="ArticlePicList_ItemContentInner">
										<div class="ArticlePicList_ItemContentInnerBox">
											<h3 class="ArticlePicList_ItemContentInnerH5 heading5">
												<a href="${article.articleUrl!}"
													title="${article.articleTitle!?html}" class="heading5">${article.articleTitle!?html}</a>
											</h3>
											[#if showDate?? && showDate == '1']
											<time class="time paragraph2">
												${article.publishTime?date("yyyy-MM-dd")?string('yyyy-MM-dd')}
											</time>
											[/#if]
											<div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">
												${article.articleSummary!''}</div>
											<a class="ArticlePicList_ItemContentInnerA" href="${article.articleUrl!}">
												<span>[@s.m "phoenix_read_more" /]</span>
											</a>

											<div class="ArticlePicList_ItemContentInnerTrans"></div>
										</div>
									</div>
								</div>
							</div>
							[/#list]
						</div>
						<div class="prevArrow arrowBtn"><i class="icon iconfont_phoenix icon-jiantouzuo-5" ></i></div>
						<div class="nextArrow arrowBtn"><i class="icon iconfont_phoenix icon-jiantouyou-5" ></i></div>
						[#else]
						<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
						[/#if]

					</div>

					<script>
						$(function(){
                            window._block_namespaces_['block34464'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
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
</div>