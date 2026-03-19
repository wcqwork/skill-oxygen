<div data-gjs-type="phoenix-container" data-strong="1">
	<div class="backstage-blocksEditor-wrap block35284" data-block-uuid="prodlist"
		data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber"
		data-block-type="phoenix_blocks_groupProduct" data-default-setting={}>
		[#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
		[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
			<style data-collect='1'>
				@media (max-width: 992px) {
					div.block35284 .one-title,
					div.block35284 .prodliNew {
						display: flex;
						text-align: right;
						justify-content: flex-end;
					}
					div.block35284 .pre-two .prodliNew {
						padding-right: 0 10px 0 0;
					}					
				}

			</style>
		[/#if]

		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1,#2167A9);
			}
		</style>

		<div class="prodCategoty-with-submenu">
			[@api method="post" url="/phoenix2/composite/graphql"
			selectGroupIds="${dataGroupId!''}"
			expandIds="${expandIds!''}"
			jumpMethod="${jumpMethod!'0'}"
			query='{
			productGroupList(selectGroupIds: $selectGroupIds, optionsParam: $optionsParam) {
			encodeId
			groupName
			groupUrl
			groupPhotoUrlList
			showFieldList
			subGroups
			}
			}']
			<div class="site-category content">
				<div class="pc-title-box">
					<div class="one-menu-title-list block_35284-swiper-container">
						<div class="one-menu-title swiper-wrapper">
							[#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
							[#assign oneIndex = 0]
							[#list data.productGroupList as group]

							[#if group_index == 0]
							<div class="one-title alterColor swiper-slide paragraph2" data-id="35284-${group_index}"
								data-index="${oneIndex}">${group.groupName!''}</div>
							[#else]
							<div class="one-title swiper-slide paragraph2" data-id="35284-${group_index}"
								data-index="${oneIndex}">${group.groupName!''}</div>
							[/#if]
							[#assign oneIndex = oneIndex + 1]
							[/#list]
							[/#if]
						</div>
					</div>
					<div class="two-submenu">
						[#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
						[#list data.productGroupList as group]
						[#if group_index != 0]
						<ul class="pre-two hide">
							[#else]
							<ul class="pre-two">
								[/#if]
								[#if group.subGroups??]
								[#list group.subGroups as subGroup]
								<li class="prodliNew paragraph3" data-index="${subGroup_index}">
									<span class="drop"></span>
									${subGroup.groupName!?html}
								</li>
								[/#list]
								[/#if]
							</ul>
							[/#list]
							[#else]
							<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
							[/#if]
					</div>
				</div>
				<div class="phone-title-box">
					<div class="down-up-box">
						<span class="activeTitle">Product Category1</span>
						<span class="arrow-mobile-btn">
                            <i class="icon iconfont_phoenix icon-jiantouxia-3"></i>
                        </span>
					</div>
					<div class="down-up">
						[#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
						[#assign twoIndex = 0]
						[#list data.productGroupList as group]
						<div class="one-title paragraph2" data-id="35284-${group_index}" data-index="${twoIndex}">${group.groupName!''}</div>
						[#assign twoIndex = twoIndex + 1]
						[#if group.subGroups??]
						[#-- 二级菜单 --]
						<ul class="pre-two">
							[#list group.subGroups as subGroup]
							<li class="prodliNew paragraph3" data-one-index="${group_index}" data-index="${subGroup_index}">
								<span class="drop"></span>
								${subGroup.groupName!?html}
							</li>
							[/#list]
						</ul>
						[/#if]
						[/#list]
						[#else]
						<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
						[/#if]
					</div>
				</div>
				<div class="product-list">
					[#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
					[#list data.productGroupList as group]
					[#if group_index != 0]
					<div class="product-contanter hide" data-id="35284-${group_index}">
						[#else]
						<div class="product-contanter" data-id="35284-${group_index}">
							[/#if]
							[@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"  dataIds = "${dataIds!''}" dataGroupId = "${dataGroupId!''}" productGroupId = "${productGroupId!'-1'}"
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
										showFieldList
										customFieldList
										$showField
										phoenixProductSubVo{
											hasProdVideo
										}
									}
								}
							}']
							[#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size
							> 0)]
							[#if group_index != 0]
							<ul class="pruduct-common one-pruduct-list hide" data-id="35284-${group_index}">
								[#else]
								<ul class="pruduct-common one-pruduct-list" data-id="35284-${group_index}">
									[/#if]
									[#list data.productList.list as product]
									[#if product_index > 7]
									<li class="hide">
										[#else]
									<li>
										[/#if]
										<div class="prodTabList-wrapper">
											<div class="tabList-wrapper-inner">
												<div class="prodTabList-cell">
													<a href="${product.prodUrl!'javascript:void(0)'}"
														title="${product.prodName!?html}">
														<img src="${product.photoUrlList[0]!}" alt="${product.photoSeoList[0].photoAlt!?html}" title="${product.photoSeoList[0].photoTitle!?html}" />
                                                    </a>
												</div>
											</div>
											<h3>
												<a class="prodlist-pro-name heading5" href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}">${product.prodName!''}</a>
											</h3>
											[#-- 产品型号 --]
											[#if product.showFieldList??]
											[#list product.showFieldList as field]
											[#if field.fieldType = '0' ]
											[#if field.fieldValue??]
											<div class="breakWord paragraph2">
												<span >
                                                                    ${field.fieldValue!}
                                                                </span>
											</div>
											[/#if]
											[/#if]
											[/#list]
											[/#if]
										</div>
										<div class="prodlist-site-buttons-container proDetail_content_addTo">
											<div class="block-editor-inquire proDetail_addTo_btn inquireBtn"
												prodId="${product.encodeId}">
												<a href="javascript:;" target="_self" data-id="${product.encodeId!''}"
													id="prodInquire" class="pro-detail-btn pro-detail-inquirebtn paragraph2"
													rel="nofollow">
													<i class="iconfont iconfont_phoenix icon-youxiang-fill" style="font-size:12px"></i>
													[@s.m "phoenix_product_inquire" /]
												</a>
												<form id="prodInquire" action="/phoenix/admin/prod/inquire"
													method="post" novalidate="">
													<input type="hidden" name="inquireParams">
                                                            </form>
											</div>
											<div class="prodlist-site-buttons addToBasket  proDetail_addTo_btn "
												prodId="${product.encodeId}" prodName="${product.prodName!?html}"
												prodphotourl="${product.photoUrlList[0]!}">
												<a href="javascript:;"
													class="pro-detail-btn pro-detail-basket-container" target="_self">
													<i class="icon iconfont_phoenix icon-gouwuche-fill" style="font-size:12px"></i>
													<span class="text-wrap buy-wrap paragraph2">[@s.m "phoenix_product_add_inquire" /]</span>
												</a>
											</div>
										</div>

									</li>
									[/#list]
									<div class="arrow ">
										<span><i class="icon iconfont_phoenix icon-xiangxiayuanjiantouxiajiantouxiangxiamianxing"></i></span>
									</div>
								</ul>

								[/#if]
								[/@api]

								[#if group.subGroups??]
								[#list group.subGroups as subGroup]
								[@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}"
								limit="${pageSize!'6'}" dataGroupId = "${subGroup.encodeId!''}"
								query='{
								productList(
								conditionDto:{
								groupId: "$dataGroupId"
								page: $page
								limit: $limit
								}) {
								list {
								encodeId
								prodName
								prodBrief
								prodUrl
								photoUrlList
								showFieldList
								}
								}
								}']
								[#if data?? && data.productList?? && data.productList.list?? &&
								(data.productList.list?size > 0)]
								<ul class="two-pruduct-list pruduct-common hide"
									data-id="35284-${group_index}-${subGroup_index}">
									[#list data.productList.list as product]
									[#if product_index > 7]
									<li class="hide">
										[#else]
									<li>
										[/#if]
										<div class="prodTabList-wrapper">
											<div class="tabList-wrapper-inner">
												<div class="prodTabList-cell">
													<a href="${product.prodUrl!'javascript:void(0)'}"
														title="${product.prodName!?html}">
														<img src="${product.photoUrlList[0]!}" alt="${product.photoSeoList[0].photoAlt!?html}" title="${product.photoSeoList[0].photoTitle!?html}" />
                                                                    </a>
												</div>
											</div>
											<h3>
												<a class="prodlist-pro-name heading5" href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}">${product.prodName!''}</a>
											</h3>
											[#-- 产品型号 --]
											[#if product.showFieldList??]
											[#list product.showFieldList as field]
											[#if field.fieldType = '0' ]
											[#if field.fieldValue??]
											<div class="breakWord paragraph2">
												<span >
                                                                        ${field.fieldValue!}
                                                                    </span>
											</div>
											[/#if]
											[/#if]
											[/#list]
											[/#if]

										</div>
										<div class="prodlist-site-buttons-container proDetail_content_addTo">
											<div class="block-editor-inquire proDetail_addTo_btn inquireBtn"
												prodId="${product.encodeId}">
												<a href="javascript:;" target="_self" data-id="${product.encodeId!''}"
													id="prodInquire" class="pro-detail-btn pro-detail-inquirebtn paragraph2"
													rel="nofollow">
													<i class="iconfont iconfont_phoenix icon-youxiang-fill" style="font-size:12px"></i>
													[@s.m "phoenix_product_inquire" /]
												</a>
												<form id="prodInquire" action="/phoenix/admin/prod/inquire"
													method="post" novalidate="">
													<input type="hidden" name="inquireParams">
                                                                </form>
											</div>

											<div class="prodlist-site-buttons addToBasket  proDetail_addTo_btn "
												prodId="${product.encodeId}" prodName="${product.prodName!?html}"
												prodphotourl="${product.photoUrlList[0]!}">
												<a href="javascript:;" target="_self">
													<i class="icon iconfont_phoenix icon-gouwuche-fill" style="font-size:12px"></i>
													<span class="text-wrap buy-wrap paragraph2">[@s.m "phoenix_product_add_inquire" /]</span>
												</a>
											</div>
										</div>

									</li>
									[/#list]
									[#if data.productList.list?size < 8] <div class="arrow hide">
										<span><i class="icon iconfont_phoenix icon-xiangxiayuanjiantouxiajiantouxiangxiamianxing"></i></span>
						</div>
						[#else]
						<div class="arrow">
							<span><i class="icon iconfont_phoenix icon-xiangxiayuanjiantouxiajiantouxiangxiamianxing"></i></span>
						</div>
						[/#if]
						</ul>
						[/#if]
						[/@api]
						[/#list]
						[/#if]
					</div>
					[/#list]
					[/#if]
				</div>
			</div>
			<script>
				$(function () {
                    window._block_namespaces_['block35284'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}','pageNodeId': '${pageNodeId!""}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
                });
			</script>
			<script type="application/ld+json">
				${data.productList.extraData.prodStructureData!""}
			</script>
			[/@api]
		</div>
	</div>
</div>