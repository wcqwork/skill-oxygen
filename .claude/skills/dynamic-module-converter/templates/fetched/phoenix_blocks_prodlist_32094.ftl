<div class="qin32094" data-gjs-type="phoenix-container" data-strong="1">
	<div class="backstage-blocksEditor-wrap wra" data-block-uuid="prod_32094"
		data-block-list-setting="dataSelect,pageNumber" data-gjs-type="developer-node-component"
		data-block-type="phoenix_blocks_prodlist"
		data-default-setting={"pageSize":20,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #000);
				--color-match-setting2: var(--ld-Auxiliary1, #000);
			}
		</style>
		[@api method="post" url="/phoenix2/composite/graphql" refreshMethod="${refreshMethod!'0'}"
		showDate="${showDate!'0'}" relatedTypes="${relatedTypes!'0'}" page="${pageNum!1}" limit="${pageSize!'10'}"
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
		extraData {
			paginationUrl
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
		}
		}
		}']

		<div class="proshow-container" data-relatedTypes="${relatedTypes!''}" data-refreshMethod="${refreshMethod!''}" data-sss="${data.productList.extraData.paginationUrl!''}"
			data-showDate="${showDate!''}">
			[#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
			<div class="proshow-top-shell">
				<div class="proshow-top-content">
					<div class="proshow-scroll-box">
						<div class="proshow-scroll-list">
							[#list data.productList.list as productRolling]
							<div class="proshow-scroll-item">
								<div class="proshow-scroll-main">
									<a href="${productRolling.prodUrl}" class="proshow-image" title="${productRolling.prodName!?html}">
										<img src="${productRolling.photoUrlList[0]!}" alt="${productRolling.photoSeoList[0].photoAlt!?html}" title="${productRolling.photoSeoList[0].photoTitle!?html}">
									</a>
									<div class="proshow-caption">
										<div class="divider divider-sm divider-primary"></div>
										<div class="proshow-title">
											<h3>
												<a class="heading5" href="${productRolling.prodUrl}" tabindex="0">${productRolling.prodName!?html}</a>
											</h3>
										</div>
									</div>
								</div>
								<div class="line"></div>
							</div>
							[/#list]
							<a href="/products.html">
								<div class="more">
									<div class="more-detail">
										<div class="more-text paragraph2">[@s.m "phoenix_view_more" /]</div>
										<div class="more-icon">
											<i class="icon iconfont_phoenix icon-jiantouyou"></i>
										</div>
									</div>
								</div>
							</a>
						</div>
					</div>
				</div>
			</div>
			[#else]
			<p style="text-align:center">[@s.m "phoenix_no_content" /]</p>
			[/#if]
		</div>
		<script type="application/ld+json">
			${data.productList.extraData.prodStructureData!""}
		</script>
		[/@api]

		<script>
			$(function () {
        window._block_namespaces_['block32094'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
      });
		</script>
	</div>
</div>