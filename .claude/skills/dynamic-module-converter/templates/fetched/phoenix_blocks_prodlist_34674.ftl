<div data-gjs-type="phoenix-container" data-strong="1">

	    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <style data-collect='1'>
            .block34674 .proshow-scroll-list{
                direction: rtl;
                text-align: right;
            }
			.block34674 .moreButn {
				    display: inline-flex !important;
    flex-direction: row-reverse;
			}
        </style>
    [/#if]
	<div data-block-uuid="prodlist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,pageNumber"
		data-block-type="phoenix_blocks_prodlist"
		data-default-setting={"pageSize":4,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #23AC38);;
			}
		</style>
		<div class="block34674">
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
			prodUrl
			photoUrlList
			enabledTrade
			isSkuProd
			photoSeoList{
				photoId
				photoUrlNormal
				photoAlt
				photoTitle
			}
			showFieldList
			customFieldList
			$showField
			phoenixProductSubVo{
			hasProdVideo
			}
			}
			}
			}']
			<div class="proshow-container block-prodlist-container-replace">
				<div class="proList">

[#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
			<div class="proshow-top-shell">
						<div class="proshow-top-content">
							<div class="proshow-scroll-box">
								<button class="btn-scroll btn-scroll-left" ></button>
								<button class="btn-scroll btn-scroll-right" ></button>
								<div class="proshow-scroll-list">
									[#list data.productList.list as productRolling]

									<div class="proshow-scroll-item">
										<div class="proshow-scroll-main">
											<div class="proshow-caption">
												<h3 class="proshow-title heading5">
													<a href="${productRolling.prodUrl}" class="heading5">${productRolling.prodName!?html}</a>
												</h3>
												<div class="prodBrief paragraph1">${productRolling.prodBrief!}</div>
											</div>


											<div class="bottom">
												<div class="imgBox">
													<a href="${productRolling.prodUrl}" class="proshow-image"
														title="${productRolling.prodName!?html}">
														<img src="${productRolling.photoUrlList[0]!}" loading="lazy" alt="${productRolling.photoSeoList[0].photoAlt!}" title="${productRolling.photoSeoList[0].photoTitle!}" >
													</a>
												</div>

												<div class="butn paragraph2">
													<a class="moreButn" href="${productRolling.prodUrl}">
														[@s.m "phoenix_learn_more" /]
														<i class="icon iconfont_phoenix icon-jiantouyou-4" ></i>
													</a>
												</div>
											</div>


										</div>
									</div>
									[/#list]
								</div>
							</div>
						</div>
					</div>
			[#else]
			<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
			[/#if]

					  <input type="hidden" name="totalRow" value="${data.productList.totalRow!'0'}"> 
                <input type="hidden" name="pageNumber" value="${data.productList.pageNumber!'1'}">
                <input type="hidden" name="pageSize" value="${data.productList.pageSize!'10'}">

				</div>
                
			</div>
<script type="application/ld+json">
				${data.productList.extraData.prodStructureData!""}
			</script>

                   [#if !(data.productList.pageSize?? && data.productList.totalRow?? && data.productList.totalRow <=  data.productList.pageSize)]
                    <div class="prodlist-site-pagination">
                        <div class="prodlist-laypage-normal" id='prodlist-laypage-normal'></div>
                    </div>
                [/#if]
			<script>
				$(function () {
					window._block_namespaces_['block34674'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}','pageNodeId': '${pageNodeId!""}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
				});
			</script>
[/@api]
		</div>
	</div>


</div>

</div>

</div>