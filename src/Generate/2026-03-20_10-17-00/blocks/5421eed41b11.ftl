<div class="block_5421eed41b11" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            .block35644 .proList .proshow-scroll-list .proshow-scroll-item * {
                text-align: center;
            }
            .block35644 .slick-prev, 
            .block35644 .slick-next {
                display: inline-flex!important;
                justify-content: center;
                align-items: center;
            }            
        </style>
    [/#if]

    <div class="backstage-blocksEditor-wrap" data-block-uuid="5421eed41b11" data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber" data-block-type="phoenix_blocks_prodlist" data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
        <style>
        [data-new-auto-uuid="${pageNodeId!''}"] {
            --color-match-setting1: var(--ld-main1, #000000);
        }
        </style>
<div class="products elements-grid align-items-start woodmart-products-holder  woodmart-spacing-30 pagination-pagination row grid-columns-4" data-source="main_loop" data-min_price="" data-max_price="">
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
                                    shopProdPrice
                                    $showField
                                    phoenixProductSubVo{
                                        hasProdVideo
                                    }
                                    photoSeoList{
                                        photoId
                                        photoUrlNormal
                                        photoAlt
                                        photoTitle
                                    }
                                }
                            }
                        }']
				
												
					
						
[#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
[#list data.productList.list as product]
<div class="product-grid-item product without-stars product-no-swatches quick-shop-on quick-view-on woodmart-hover-quick  col-6 col-sm-4 col-md-3 col-lg-3 first  product-in-grid type-product post-15002 status-publish first instock product_cat-electric-adjustable-height-desk product_cat-office-desk product_tag-electric-height-adjustable-table product_tag-office-desk product_tag-office-furniture has-post-thumbnail shipping-taxable product-type-simple" data-loop="1" data-id="15002"><div class="product-element-top">
	<a href="${product.prodUrl!'#'}" class="product-image-link">
		<img width="800" height="800" src="${product.photoUrlList[0]!}" class="attachment-woocommerce_thumbnail size-woocommerce_thumbnail perfmatters-lazy" alt="${product.prodName!?html}" decoding="async" data-src="https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-1.bk_.jpg" data-srcset="https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-1.bk_.jpg 800w, https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-1.bk_-200x200.jpg 200w, https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-1.bk_-768x768.jpg 768w, https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-1.bk_-100x100.jpg 100w" data-sizes="(max-width: 800px) 100vw, 800px"><noscript><img width="800" height="800" src="https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-1.bk_.jpg" class="attachment-woocommerce_thumbnail size-woocommerce_thumbnail" alt="SENDI-MF4M-E04" decoding="async" srcset="https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-1.bk_.jpg 800w, https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-1.bk_-200x200.jpg 200w, https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-1.bk_-768x768.jpg 768w, https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-1.bk_-100x100.jpg 100w" sizes="(max-width: 800px) 100vw, 800px" /></noscript>	</a>
				<div class="hover-img">
				<a href="${product.prodUrl!'#'}">
					<img width="800" height="800" src="${product.photoUrlList[0]!}" class="attachment-woocommerce_thumbnail size-woocommerce_thumbnail perfmatters-lazy" alt="${product.prodName!?html}" decoding="async" data-src="https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-2.jpg" data-srcset="https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-2.jpg 800w, https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-2-200x200.jpg 200w, https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-2-768x768.jpg 768w, https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-2-100x100.jpg 100w" data-sizes="(max-width: 800px) 100vw, 800px"><noscript><img width="800" height="800" src="https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-2.jpg" class="attachment-woocommerce_thumbnail size-woocommerce_thumbnail" alt="SENDI-MF4M-E04 Detal 2" decoding="async" srcset="https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-2.jpg 800w, https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-2-200x200.jpg 200w, https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-2-768x768.jpg 768w, https://www.migefurniture.com/wp-content/uploads/2026/01/SENDI-MF4M-E04-2-100x100.jpg 100w" sizes="(max-width: 800px) 100vw, 800px" /></noscript>				</a>
			</div>
			<div class="woodmart-buttons">
									<div class="quick-view">
				<a href="${product.prodUrl!'#'}" class="open-quick-view" data-id="15002">${product.prodName!?html}</a>
			</div>
			</div>

	<div class="woodmart-add-btn">
			</div>
				<div class="quick-shop-wrapper">
				<div class="quick-shop-close"><span>Close</span></div>
				<div class="quick-shop-form">
				</div>
			</div>
		</div>
<div class="product-title"><a href="${product.prodUrl!'#'}">${product.prodName!?html}</a></div>





	</div>
[/#list]
[#else]
<div class="no-data">No content available</div>
[/#if]

									
					
						
									
					
						
									
					
						
									
					
						
									
					
						
									
					
						
									
					
						
									
					
						
									
					
						
									
					
						
									
					
						
											

			
<input type="hidden" name="totalRow" value="${data.productList.totalRow!'0'}">
<input type="hidden" name="pageNumber" value="${data.productList.pageNumber!'1'}">
<input type="hidden" name="pageSize" value="${data.productList.pageSize!'20'}">
[/@api]
</div>
    </div>
</div>