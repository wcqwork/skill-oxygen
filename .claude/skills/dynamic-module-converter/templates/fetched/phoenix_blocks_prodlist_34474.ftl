<style>
	.block34474 .proshow-custom-list {
		opacity: 0;
	}
	.block34474 .proshow-custom-list.slick-initialized {
		opacity: 1;
		transition: all 0.3s;
	}
</style>
<div data-gjs-type="phoenix-container" data-strong="1">
	[#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
	[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
	<!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
	<style data-collect='1'>
		.block34474 .proshow-custom-item .proshow-custom-caption .pro-text {
			float:right;
		}
		.block34474 .proshow-custom-item .proshow-custom-caption .pro-arrow {
			float:left;
			transform: rotate(180deg);
		}
	</style>
	[/#if]
	<div data-block-uuid="prodlist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,pageNumber,dataOrderBy,dataCustomSortType" data-block-type="phoenix_blocks_prodlist"
		data-default-setting={"pageSize":20,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"1","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[], "customSortType": "0"}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1,#B70000);

				--color-match-ellipses-title-setting1: var(--ld-title3-color, #000);
			}
		</style>
		<div class="block34474">
			[@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"
			dataIds = "${dataIds!''}" dataGroupId = "${dataGroupId!''}" productGroupId = "${productGroupId!'-1'}"
			dataType="${dataType!'0'}" jumpMethod="${jumpMethod!'0'}"
			layoutStyle="${layoutStyle!'0'}" orderBy="${orderBy!'0'}" customSortType="${customSortType!'0'}"
			expandIds="${expandIds!''}" productId="${productId!-1}"
			query='{
				productList(
				conditionDto:{
				searchGroupIds: $dataGroupId
				searchProdIds: $dataIds
				prodType: "$dataType"
				page: $page
				limit: $limit
				orderBy: "$orderBy"
				customSortType: "$customSortType"
				optionsParam: $optionsParam
				prodRelatedId: "$productId"
				prodCateIdByPage: "$productGroupId"
				}) {
					totalRow
					pageSize
					pageNumber
					extraData{
						coinSymbol
						isB2cPlan
						prodStructureData
					}
					list {
						encodeId
						prodName
						prodPrice
						prodBrief
						prodMaxPrice
						prodMinPrice
						prodDiscountPrice
						prodUrl
						photoUrlList
						enabledTrade
						isSkuProd
						showFieldList
						customFieldList
						photoSeoList{
							photoId
							photoUrlNormal
							photoAlt
							photoTitle
						}
						$showField
						phoenixProductSubVo{
							hasProdVideo
						}
					}
				}
			}']

			[#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
			<div class="proshow-top-custom-shell">
				<div class="proshow-top-custom-content">
					<div class="proshow-custom-box">
						<i class="icon iconfont_phoenix icon-jiantouzuo-5 l-fa-angle-left"></i>
						<div class="proshow-custom-list showBox">
							[#list data.productList.list as productRolling]
							<div class="proshow-custom-item">
								<div class="proshow-custom-main">
									<a href="${productRolling.prodUrl}" class="proshow-custom-image" title="${productRolling.prodName!?html}">
										<picture>
											<source media="(min-width: 450px)" srcset="${productRolling.photoUrlList[0]!}" />
											<source media="(max-width: 449px)" srcset="${productRolling.photoUrlList[0]!}" />
											<img alt="${productRolling.photoSeoList[0].photoAlt!}" title="${productRolling.photoSeoList[0].photoTitle!}" class="lazyimg" src="${productRolling.photoUrlList[0]!}"/>
										</picture>
									</a>
									<div class="proshow-custom-caption">
										<h3 class="proshow-title proshow-same heading5">
											<a class="picDescription heading5" href="${productRolling.prodUrl}">${productRolling.prodName!?html}</a>
										</h3>
										<div class="showBtn proshow-same">
											<p class="pro-text paragraph2">[@s.m "phoenix_learn_more" /]</p>
											<p class="pro-arrow"><i class="icon iconfont_phoenix icon-jiantouyou-5" aria-hidden="true"></i></p>
											<a href="${productRolling.prodUrl}"><span class="kong"></span></a>
										</div>
										<i class="pro-shadow"></i>
									</div>
								</div>
							</div>

							[/#list]
						</div>

						<i class="icon iconfont_phoenix icon-jiantouyou-5 l-fa-angle-right"></i>
					</div>
				</div>
			</div>
			[#else]
			<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
			[/#if]

			<script type="application/ld+json">
				${data.productList.extraData.prodStructureData!""}
			</script>
			<script>
				$(function () {
					window._block_namespaces_['block34474'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}','pageNodeId': '${pageNodeId!""}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
				});
			</script>
			[/@api]
		</div>
	</div>
</div>