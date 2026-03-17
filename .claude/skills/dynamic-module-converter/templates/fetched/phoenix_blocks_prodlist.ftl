<div class="backstage-blocksEditor-wrap wra block_77334" data-block-uuid="aaa" data-gjs-type="developer-node-component"  data-block-type="phoenix_blocks_prodlist">
		[@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"  dataIds = "${dataIds!''}" dataGroupId = "${dataGroupId!''}" productGroupId = "${productGroupId!'-1'}"
		 dataType="${dataType!'0'}" jumpMethod="${jumpMethod!'0'}"
		  layoutStyle="${layoutStyle!'0'}" orderBy="${orderBy!'0'}"
		  expandIds="${expandIds!''}" productId="${productId!-1}" currentPageIdForRelated="${pageId!-1}"
		  articleRelatedId="${infoId!-1}"
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
				articleRelatedId: "$articleRelatedId"
				currentPageIdForRelated: "$currentPageIdForRelated"
				}) {
				totalRow
				pageSize
				pageNumber
				extraData{
					coinSymbol
					isB2cPlan
					prodStructureData
					summaryRichTextFlag
				}
				list {
					encodeId
					prodName 
					prodPrice
					prodBrief
					commentStar
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
		<div class="block-prodlist-container-replace">
		<ul class="block-prodlist-lead-container block-prodlist-lead-container-77334 [#if layoutStyle == '1']columns-4[/#if]">
			[#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
			[#list data.productList.list as product]
			<li class="prodlist-site-block" data-pid="${product.encodeId}">
				<div class="top">
					<div class="prodlist-site-block-image labelfather">
						[#if product.photoUrlList?? && product.photoUrlList[0]??]
						<a class="product-image" href="${product.prodUrl!'#'}" title="${product.prodName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">
						<picture>
							<source media="(min-width: 450px)" srcset="${product.photoUrlList[0]!}" />
							<source media="(max-width: 449px)" srcset="${product.photoUrlList[0]!}" />
							<img class="normal-image" loading="lazy" src="${product.photoUrlList[0]!}" alt="${product.prodName!?html}"/>
						</picture>


						</a>
						[/#if]
						<!-- 是否有视频标签 -->
						[#if product.phoenixProductSubVo.hasProdVideo?? && product.phoenixProductSubVo.hasProdVideo == 'true']
							<div class="hasVideo">
								<a  class="paragraph1" href="${product.prodUrl!'#'}" title="${product.prodName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">
									
									<i class="iconfont iconfont_phoenix icon-icon-bofang1"></i>
									[@s.m "PHENIX2_VIDEO" /]
								</a>
							</div>
						[/#if]
					</div>
					<!-- 标题 -->
					<div class="prodlist-site-block-name">
						<a class="titleLabel" href="${product.prodUrl!'#'}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">
						<span class="heading5">${product.prodName!?html}</span>
						</a>
					</div>			
					<!-- 显示字段 -->
					<div class="prodlist-site-block-attribute">

						[#if product.showFieldList??]
							[#list product.showFieldList as field]
								[#if field.fieldType = '0' || field.fieldType = '4' || field.fieldType = '8' ]
									<div class="prodlist-site-attrs paragraph1">
										<div class="prodlist-site-attrlabel">
											[#if field.fieldId == 'prodBrand']
												[@s.m "PHENIX2_BRAND" /]:
											[#elseif field.fieldId == 'prodModel']
												[@s.m "PHENIX2_MODEL" /]:
											[#elseif field.fieldId == 'prodCode']
												[@s.m "PHENIX2_CODE" /]:
											[#else]
												${field.fieldName!''}:
											[/#if]
										</div>
										<div class="prodlist-site-attrvalue">
											[#if field.fieldType = '4']
												[#if field.fieldValue??]
												<span class="inlineblock h20 w20" style="background-color:${field.fieldValue!}"></span>
												[/#if]
											[#else]
												[#if field.fieldValue??]
												<span class="prodlist-site-value">
													${field.fieldValue!}
												</span>
												[/#if]
											[/#if]	
										</div>
									</div> 
										
								[#elseif field.fieldType = '1' || field.fieldType = '2' || field.fieldType = '3']
									<div class="prodlist-site-attrs paragraph1">
										<div class="prodlist-site-attrlabel">
											[#if field.fieldId == 'prodBrand']
												[@s.m "PHENIX2_BRAND" /]:
											[#elseif field.fieldId == 'prodModel']
												[@s.m "PHENIX2_MODEL" /]:
											[#elseif field.fieldId == 'prodCode']
												[@s.m "PHENIX2_CODE" /]:
											[#else]
												${field.fieldName!''}:
											[/#if]
										</div>
										<div class="prodlist-site-attrvalue">
											[#if field.fieldValue??]
												[#list field.fieldValue as values]
													${values!''}&nbsp;
												[/#list]
											[/#if]
										</div>
									</div> 
								[#elseif field.fieldType = '5']
									<div class="prodlist-site-attrs paragraph1">
										<div class="prodlist-site-attrlabel">
											[#if field.fieldId == 'prodBrand']
												[@s.m "PHENIX2_BRAND" /]:
											[#elseif field.fieldId == 'prodModel']
												[@s.m "PHENIX2_MODEL" /]:
											[#elseif field.fieldId == 'prodCode']
												[@s.m "PHENIX2_CODE" /]:
											[#else]
												${field.fieldName!''}:
											[/#if]
										</div>
										<div class="prodlist-site-attrvalue">
											[#if field.fieldId??]
											<a href="javascript:void(0);" class="getFileDownload" data-downloadFildId="${field.fieldId}">${field.fieldValue!}</a>
											[#else]
											<a href="${field.downloadUrl!}" target="_blank">${field.fieldValue!}</a>
											[/#if]
										</div>
									</div> 	

								[#elseif field.fieldType = '101']
									<!-- 简介 -->
									[#if product.prodBrief??]
										<div class="product-introduction paragraph1">
											[#if data.productList.extraData.summaryRichTextFlag =='1']
												${product.prodBrief!}
											[#else]
												${product.prodBrief?html}
											[/#if]
										</div>
									[/#if]
								[#elseif field.fieldType = '100']
										<!-- 星级评价 -->
										<div class="prodlist-site-rate">
											<!-- <div class="prodlist-rate-normal" star-id="${product.commentStar!'5'}" id="prodlist-site-rate_${product_index}">
											</div> -->
											  [#assign comentStrNums = product.commentStar!5]
											  [#if comentStrNums <= 0]
											  	[#assign comentStrNums = 5]
											  [/#if]
											  
											  [#assign fullStars = comentStrNums?floor]
											  [#assign hasHalfStar = (comentStrNums - fullStars) > 0]
											  [#assign emptyStars = 5 - fullStars - (hasHalfStar?then(1,0))]
											  
											  [#list 1..fullStars as itemNum]
											  	<span class="icon ${commentStar_icon_class!'iconfont_phoenix icon-pingjia-fill'}" data-commentStar="${comentStrNums}"></span>
											  [/#list]
											  
											  [#if hasHalfStar]
											  	<span class="icon ${commentStar_icon_class!'iconfont_phoenix icon-star-half'}" data-commentStar="${comentStrNums}"></span>
											  [/#if]
											  
											  [#if emptyStars > 0]
											  	[#list 1..emptyStars as itemNum]
											  	<span class="icon ${commentStar_icon_class!'iconfont_phoenix icon-kongxingxing'}" data-commentStar="${comentStrNums}"></span>
											  	[/#list]
											  [/#if]
										</div>
								[/#if]

							[/#list]
						[/#if]
					</div>

					
					<!-- 价格 -->
					[#if product.enabledTrade?? && product.enabledTrade == 'true']
						<div class="prodlist-site-block-price">
							[#if product.isSkuProd?? && product.isSkuProd == 'true']
								[#if product.prodMinPrice != product.prodMaxPrice]
									<div class="prodlist-discountprice paragraph1">
										[#if data.productList.extraData??]
											<span class="currencySymbol">${data.productList.extraData.coinSymbol!'$'}</span>
										[/#if]
										<span class="needExchangeValue">${product.prodMinPrice?string["0.00"]}</span>
									</div>
									<div class="prodlist-price paragraph1">
										[#if data.productList.extraData??]
											<span class="currencySymbol">${data.productList.extraData.coinSymbol!'$'}</span>
										[/#if]
										<span class="needExchangeMaxValue">${product.prodMaxPrice?string["0.00"]}</span>
									</div>
								[#else]
									<div class="prodlist-discountprice paragraph1">
										[#if data.productList.extraData??]
											<span class="currencySymbol">${data.productList.extraData.coinSymbol!'$'}</span>
										[/#if]
										<span class="needExchangeValue">${product.prodMinPrice?string["0.00"]}</span>
									</div>
								[/#if]
							[#else]
								<div class="prodlist-discountprice paragraph1">
									[#if data.productList.extraData??]
										<span class="currencySymbol">${data.productList.extraData.coinSymbol!'$'}</span>
									[/#if]
									<span class="needExchangeValue">${product.prodPrice?string["0.00"]}</span>
								</div>
							[/#if]	
						</div>
					[/#if]
				</div>
				<!-- 功能按钮 -->
				<div class="prodlist-site-buttons-container margin-rl">
					[#if expandIds?? && expandIds != ""]
					[#assign expandIdsJSON=expandIds?eval /]

					[#if expandIdsJSON?? && expandIdsJSON.functionBtn?? && expandIdsJSON.functionBtn.data??]
						[#list expandIdsJSON.functionBtn.data as functionBtn]
							<!-- 询盘 -->
							[#if data.productList.extraData?? && data.productList.extraData.isB2cPlan == false]
								[#if functionBtn.checked == true && functionBtn.key == 'inquiry']
									<div class="prodlist-site-buttons block-editor-inquire" prodId="${product.encodeId}">
										<a href="javascript:;" target="_self" class="paragraph1">
											<span class="text-wrap buy-wrap">

												<i class="iconfont iconfont_phoenix icon-youxiang" style="font-size:12px"></i>
												[@s.m "phoenix_product_inquire" /] 
											</span>
										</a>
										<form id="prodInquire" action="/phoenix/admin/prod/inquire" method="post" novalidate="">
											<input type="hidden" name="inquireParams">
										</form>
									</div>
								[/#if]
								[#if functionBtn.checked == true && functionBtn.key == 'addInquiry']
									<!-- 加入询盘栏 -->
									<div class="prodlist-site-buttons add-basket" prodId="${product.encodeId}" prodName="${product.prodName!?html}" prodphotourl="${product.photoUrlList[0]!}">
										<a href="javascript:;" target="_self" class="paragraph1">
											<span class="text-wrap buy-wrap">[@s.m "phoenix_product_add_inquire" /]</span>
										</a>
									</div>
								[/#if]
							[/#if]
							[#if data.productList.extraData?? && data.productList.extraData.isB2cPlan == true]
								[#if functionBtn.checked == true && functionBtn.key == 'buyNow']
									<!-- 购买跳转详情 -->
									<div class="prodlist-site-buttons block-editor-buy" prodId="${product.encodeId}">
										<a href="${product.prodUrl}" target="_self">
											<span class="text-wrap buy-wrap">[@s.m "phoenix_product_place_order" /] </span>
										</a>
									</div>
								[/#if]
								[#if functionBtn.checked == true && functionBtn.key == 'addBasket']
									<!-- 加入购物车 -->
									<div id="prodAddCart" class="prodlist-site-buttons editor-prodlist-addcart" prodId="${product.encodeId}">
										<a href="javascript:;" target="_self">
											<span class="text-wrap buy-wrap">[@s.m "phoenix_product_add_cart" /] </span>
										</a>
									</div>
								[/#if]
							[/#if]	
						[/#list]
					[/#if]
				[/#if]
				</div>
			
			</li>
			[/#list]
			[#else]
				<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
			[/#if]
		</ul>
		<input type="hidden" name="totalRow" value="${data.productList.totalRow!'0'}"> 
		<input type="hidden" name="pageNumber" value="${data.productList.pageNumber!'1'}">
		<input type="hidden" name="pageSize" value="${data.productList.pageSize!'20'}">
		<input type="hidden" name="layoutStyle" value="${layoutStyle!'0'}">
		<input type="hidden" name="jumpMethod" value="${jumpMethod!'0'}">
		<input type="hidden" name="productId" value="${productId!'-1'}">
		<input type="hidden" name="dataType" value="${dataType!'0'}">
		<input type="hidden" name="infoId" value="${infoId!'-1'}">

		</div>
		[#if (!loadMethod?? || loadMethod == '0')]
			
			<div class="prodlist-site-pagination-77334 paragraph1 [#if data.productList.pageSize?? && data.productList.totalRow?? && data.productList.totalRow <=  data.productList.pageSize]hide[/#if]">
				<div class="prodlist-laypage-normal" id='prodlist-laypage-normal'></div>
			</div>
		[/#if]
		<script> 
			$(function(){
				window._block_namespaces_['prodlist_editor13'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'aaa_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}', 'productGroupId':'${productGroupId!}'});
			});
		</script>
		<script type="application/ld+json">
			${data.productList.extraData.prodStructureData!""}
    	</script>
	[/@api]
	

	</div>