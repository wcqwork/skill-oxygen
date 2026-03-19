<div data-gjs-type="phoenix-container" data-strong="1">

	[#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
	[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
	<!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
	<style data-collect='1'>
		.block34494 .slick-slide {
			direction: rtl;
		}

		.block34494 .anniue .bbb {
			display: inline-flex;
			align-items: center;
			flex-direction: row-reverse;
		}

		.block34494 .slick-track {
			display: flex;
			flex-direction: row-reverse;
		}
		.block34494 .pnbox {
			position: relative;
			display: flex;
			flex-direction: row-reverse;
			justify-content: flex-end;
		}
		.block34494 .icon-jiantouyou-5 {
			transform: rotate(180deg);
			font-size: 13px;
			display: inline-block;
		}
		.block34494 .proshow-scroll-item .anniu a::after, .block34494 .proshow-scroll-item .anniue a::after {
			right: 0
		}

	</style>
	[/#if]

	<div data-block-uuid="prodlist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,pageNumber" data-block-type="phoenix_blocks_prodlist"
		data-default-setting={"pageSize":9,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, orange);
				--color-match-setting2: var(--ld-Auxiliary1, gray);
			}
		</style>
		<div class="block34494">
			[@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"
			dataIds = "${dataIds!''}" dataGroupId = "${dataGroupId!''}" productGroupId = "${productGroupId!'-1'}"
			dataType="${dataType!'0'}" jumpMethod="${jumpMethod!'0'}"
			layoutStyle="${layoutStyle!'0'}" orderBy="${orderBy!'0'}"
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
			shopProdPriceMax
			prodUrl
			photoUrlList
			photoSeoList{
				photoId
				photoUrlNormal
				photoAlt
				photoTitle
			}
			enabledTrade
			isSkuProd
			showFieldList
			customFieldList
			$showField
			phoenixProductSubVo{
			hasProdVideo
			}
			}
			}
			}']
			<div class="proshow-container">
				[#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
				<div class="proshow-top-shell">
					<div class="proshow-top-content">
						<div class="proshow-scroll-box">
							<div class="proshow-scroll-list slick_list">
								[#list data.productList.list as productRolling]

								<div class="proshow-scroll-item">
									<div class="shuxian"></div>
									<div class="proshow-scroll-main">
										<div class="proshow-caption">
											<h3 class="proshow-title heading5">
												<a href="${productRolling.prodUrl}" class="heading5">${productRolling.prodName!?html}</a>
											</h3>
										</div>
										[#if data.productList.extraData?? && data.productList.extraData.isB2cPlan ==
										true]
										<div class="pro-price">
											<div class="now-price paragraph2">
												<span class="currencySymbol">${data.productList.extraData.coinSymbol!'$'}</span>
												<span class="needExchangeValue" exchangeValue="${productRolling.shopProdPriceMax!}">${productRolling.shopProdPriceMax?string["0.00"]!}</span>
											</div>
										</div>
										[/#if]
										<div class="imgbox">
											<a href="${productRolling.prodUrl}" class="proshow-image"
												title="${productRolling.prodName!?html}">
												<img  class="lazyimg" src="${productRolling.photoUrlList[0]!}" alt="${productRolling.photoSeoList[0].photoAlt!}" title="${productRolling.photoSeoList[0].photoTitle!}">
                                        </a>

										</div>

										<!-- 内容描述-->
										<div class="text paragraph1">${productRolling.prodBrief!}</div>
										<!-- 图面下方按钮 -->
										<div class="anniu">
											<a class="aaa paragraph2" href="${productRolling.prodUrl}">[@s.m "phoenix_view_more" /]
												<i class="icon iconfont_phoenix icon-jiantouyou-5"></i>
											</a>
										</div>
										[#if data.productList.extraData?? && data.productList.extraData.isB2cPlan ==
										true]
										<div class="anniue">
											<a class="bbb paragraph2" href="${productRolling.prodUrl}">
												[@s.m "phoenix_product_list_place_order" /]
												<i class="icon iconfont_phoenix icon-jiantouyou-5"></i>
											</a>
										</div>
										[/#if]
									</div>
								</div>

								[/#list]
							</div>


							<div class="pnbox">
								<div class="prev">
									<i class="icon iconfont_phoenix icon-jiantouzuo-5"></i>
								</div>
								<div class="next">
									<i class="icon iconfont_phoenix icon-jiantouyou-5"></i>
								</div>
							</div>

						</div>
					</div>
				</div>
				[#else]
				<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
				[/#if]
			</div>

			<script>
				$(function(){
                    window._block_namespaces_['block34494'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
			</script>
			<script type="application/ld+json">
				${data.productList.extraData.articleStructureData!""}
			</script>

			[/@api]



		</div>

	</div>

</div>