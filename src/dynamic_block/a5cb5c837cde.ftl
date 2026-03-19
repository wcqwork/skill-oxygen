<div class="backstage-blocksEditor-wrap wra block_a5cb5c837cde" data-block-uuid="a5cb5c837cde" data-gjs-type="developer-node-component" data-block-type="phoenix_blocks_prodlist">
<ul class="fix grid-container">

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
<body><ul class="fix grid-container">
                                                    
[#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
[#list data.productList.list as product]
<li pte="false" ipte="false" isp="false" class="sitewidget-prodlist-noborder" sku="1" pi="0" pad="0"><div class="66 55 prodlist-box-hover " style="background-color:;">
                                                            <div class="prodlist-display" style="width: 100%;">
                                                                <div class="prodlist-inner prodlist-inner1" style="border:1px solid rgb(221, 221, 221);">
                                                                    <div class="prodlist-picbox labelfather " style="position: static;">
                                                                        <div class="prodlistAsync_label prodlistAsync_label_text_tl">
                                                                            <div></div>
                                                                        </div>
                                                                        <div class="prodlistAsync_label prodlistAsync_label_text_tr">
                                                                            <div></div>
                                                                        </div>
                                                                        <div class="prodlistAsync_label prodlistAsync_label_text_t"></div>
                                                                        <div class="prodlistAsync_label_img_tl">
                                                                            <img src="${product.photoUrlList[0]!}" alt="${product.prodName!?html}">
                                                                        </div>
                                                                        <div class="prodlistAsync_label_img_tr">
                                                                            <img src="${product.photoUrlList[0]!}" alt="${product.prodName!?html}">
                                                                        </div>
                                                                        <div class="prodlistAsync_label_img_r"></div>
                                                                        <div class="prodlist-cell" style="width: 100%;">
                                                                            <a class="prod_img_a_t12 prodList-v3-container-img" data-pid="pCfgFzabODqZ" href="${product.prodUrl!'#'}" target="" title="${product.prodName!?html}">
                                                                                <img class="lazy prod_img_t12 prod_img_t12_p1 img-default-bgc" data-original="//g0.leadongcdn.cn/cloud/lqBplKpqljSRnlkkjmjjkq/qingqiuceshitupian-640-640.png" src="${product.photoUrlList[0]!}" alt="${product.prodName!?html}">
                                                                            </a>
                                                                        </div>
                                                                        <div class="prod_show_icon" style="z-index: 11;">
                                                                            <span class="prod_show_button" data-pid="pCfgFzabODqZ">Quick View</span>
                                                                        </div>
                                                                    </div>
                                                                    <div class="dialog-zzw prodlist-inner">
                                                                        <div class="prodlist-lists-style-nophoto-11-black" id="black"></div>
                                                                        <div class="dialog-container" id="dialogBox">
                                                                            <span class="dialog_close" id="dialog_close" style="background-image: url(//g0.leadongcdn.cn/static/assets/images/close_03.png?1773752617099);"></span>
                                                                            <div class="dialog-container-body">
                                                                                <div class="commod-swiper-container">
                                                                                    <div class="prodetail-slider owl-carousel" data-type="sliders" id="slider-sLAPMoFRwCVj" style="width: calc(100% - 30px);">
                                                                                        <div class="pic-container labelfather master-slider ms-skin-default" style="width: 100%;height: 100%;">
                                                                                            <div class="prodlistAsync_label prodlistAsync_label_text_tl">
                                                                                                <div></div>
                                                                                            </div>
                                                                                            <div class="prodlistAsync_label prodlistAsync_label_text_tr">
                                                                                                <div></div>
                                                                                            </div>
                                                                                            <div class="prodlistAsync_label prodlistAsync_label_text_t"></div>
                                                                                            <div class="prodlistAsync_label_img_tl">
                                                                                                <img src="${product.photoUrlList[0]!}" alt="${product.prodName!?html}">
                                                                                            </div>
                                                                                            <div class="prodlistAsync_label_img_tr">
                                                                                                <img src="${product.photoUrlList[0]!}" alt="${product.prodName!?html}">
                                                                                            </div>
                                                                                            <div class="prodlistAsync_label_img_r"></div>
                                                                                            <a class="swiper-pic" style="display: block; background-image: url(//g0.leadongcdn.cn/cloud/lqBplKpqljSRnlkkjmjjkq/qingqiuceshitupian.png); width: 100%; height: 100%; background-size: cover; background-position: center;" cur-img="//g0.leadongcdn.cn/cloud/lqBplKpqljSRnlkkjmjjkq/qingqiuceshitupian.png" org-img="//g0.leadongcdn.cn/cloud/lqBplKpqljSRnlkkjmjjkq/qingqiuceshitupian.png"></a>
                                                                                        </div>
                                                                                    </div>
                                                                                    <a href="${product.prodUrl!'#'}" class="detail-entrance">${product.prodName!?html}</a>
                                                                                </div>
                                                                                <div class="commod-container">
                                                                                    <div class="commod-name">${product.prodName!?html}</div>
                                                                                    <div class="sku-container sku-choose-container">
                                                                                        ${product.prodBrief!}<table class="this-description-table" data-pid="pCfgFzabODqZ" id="159564314sLAPMoFRwCVj"></table>
                                                                                    </div>
                                                                                    <div class="sku-container order-quan-container" style="margin-top: 0;">
                                                                                        <table class="this-description-table">
                                                                                            <tbody>
                                                                                                <tr>
                                                                                                    <td class="sku-title">${product.prodName!?html}</td>
                                                                                                    <td class="sku-main">
                                                                                                        <div>
                                                                                                            <a href="${product.prodUrl!'#'}" class="order-minus"></a>
                                                                                                            <input value="1" class="order-quan-input" style="text-align: center;" autocomplete="off" type="text">
                                                                                                            <a href="${product.prodUrl!'#'}" class="order-plus"></a>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                    <td class="sku-stock hide">
                                                                                                        <input type="hidden" name="skustock" value="">
                                                                                                        <span class="stock-label">Stock</span>
                                                                                                        <span class="stock-num">0</span>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </tbody>
                                                                                        </table>
                                                                                    </div>
                                                                                    <div class="prodlist-parameter-btns 1 prodlist-parameter-btns-container" style="margin-top:30px;max-width:100%;">
                                                                                        <button prodid="pCfgFzabODqZ" class="InquireAndBasket-11 default-button prodlist-pro-inquire prodlist-pro-inquire-dialog mt10 button_color ">Inquire</button>
                                                                                        <a href="${product.prodUrl!'#'}" rel="nofollow" prodid="pCfgFzabODqZ" prodname="quan1" prodphotourl="//g0.leadongcdn.cn/cloud/lqBplKpqljSRnlkkjmjjkq/qingqiuceshitupian-40-40.png" org-prodphotourl="//g0.leadongcdn.cn/cloud/lqBplKpqljSRnlkkjmjjkq/qingqiuceshitupian-40-40.png" class="prodlist-pro-buynow-btn-dialog InquireAndBasketed InquireAndBasket-11 pro-detail-basket block prodlist-pro-addbasket-btn mt10 button_basket">${product.prodName!?html}</a>
                                                                                    </div>
                                                                                    <input type="hidden" id="isSkuProd" value="1">
                                                                                    <form id="prodPlaceOrder" action="/phoenix/admin/order/confirm" method="post" novalidate="">
                                                                                        <input type="hidden" name="confirmType" value="1">
                                                                                        <input type="hidden" name="extendProp">
                                                                                        <input type="hidden" name="prodIds" id="productId" value="159564314">
                                                                                        <input type="hidden" name="quantity" value="">
                                                                                        <input type="hidden" name="skuValueId" id="skuValueId" data-sku="1" value="BtUhoeTpsdDO">
                                                                                        <input type="hidden" name="skuImgUrl" id="skuImgUrl" value="">
                                                                                    </form>
                                                                                    <form id="prodInquire" action="/phoenix/admin/prod/inquire" method="post" novalidate="">
                                                                                        <input type="hidden" name="inquireParams">
                                                                                    </form>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="prodlist-special" style="right:-1px;"></div>
                                                            <div class="prodlist-parameter-wrap">
                                                                <div class="prodlist-parameter-inner">
                                                                    <a href="${product.prodUrl!'#'}" target="" class="prodlist-pro-name" title="${product.prodName!?html}">${product.prodName!?html}</a>
                                                                    <div class="style_line_9"></div>
                                                                    <div class="prodlist-ops-container" data-pid="pCfgFzabODqZ"></div>
                                                                    <dl class="prodlist-defined-list "></dl>
                                                                    <dl class="prodlist-defined-list"></dl>
                                                                    <div class="comparedDetailAll hide">
                                                                        <dl class="prodlist-defined-list"></dl>
                                                                    </div>
                                                                    <div class="prodlist-parameter-btns prodlist-btn-default 1 prodlist-parameter-btns-container"></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class=""></div>
                                                        <div class="" style="display:none">
                                                            <div class="prodlist-parameter-btns prodlist-btn-default 3" style="margin-top:10px;position:relative;width:200px">
                                                                <a href="${product.prodUrl!'#'}" target="" title="${product.prodName!?html}">${product.prodName!?html}</a>
                                                            </div>
                                                        </div>
                                                    </li>
[/#list]
[#else]
<div class="no-data">No content available</div>
[/#if]

                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                </ul></body>
<input type="hidden" name="totalRow" value="${data.productList.totalRow!'0'}">
<input type="hidden" name="pageNumber" value="${data.productList.pageNumber!'1'}">
<input type="hidden" name="pageSize" value="${data.productList.pageSize!'20'}">
<script> 
			\$(function(){
				window._block_namespaces_['prodlist_editor13'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'aaa_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}', 'productGroupId':'${productGroupId!}'});
			});
		<\/script>
[/@api]
</ul>
</div>