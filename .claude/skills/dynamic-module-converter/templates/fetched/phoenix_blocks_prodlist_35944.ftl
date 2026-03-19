<div class="block35944" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <style data-collect='1'>
            .block35934 .ArticlePicList_ItemContentInnerBox {
                text-align: right;
            }
            @media (min-width: 767px) {
                div.block35944 .block35944_section .block35944_main {
                    padding-right: 0;
                    padding-left: 30%;
                }                
                div.block35944 .block35944_section .block35944_thumb {
                    position: absolute;
                    right: auto;
                    left: 34%;
                } 
            }           
        </style>
    [/#if]
	<div data-block-uuid="prodlist" data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber"
		data-block-type="phoenix_blocks_prodlist" data-default-setting={"pageSize":8,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #8d1111);
			}
		</style>

        <section class="block35944_section" style="top: 0;height: 0;">
            <main class="block35944_main">
                <section >
                    <div class="block35944_line"></div>
                </section>
            </main>
        </section>

		<div class="content_top">
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
                        photoSeoList{
                            photoId
                            photoUrlNormal
                            photoAlt
                            photoTitle
                        }
                    }
                }
            }']
			<section class="block35944_section">
				[#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
				<main class="block35944_main">
					<section style="padding-top: 16px;">
						<h3 class="block35944_title heading5">${data.productList.list[0].prodName!''}</h3>
						<span class="block35944_brief paragraph2">${data.productList.list[0].prodBrief}</span>
						<div class="block35944_btnBox">
                            <a class="block35944_btn paragraph2" href="">
							    [@s.m "phoenix_learn_more" /]
							</a>
						</div>
					</section>
				</main>
				<aside class="block35944_slide">
					<div class="block35944_slideBox">
						<div class="block35944_prev">
							<i class="icon iconfont_phoenix icon-angle-up"></i>
							<span><</span>
						</div>
						<div class="block35944_list">
							[#list data.productList.list as productRolling]
                            [#assign index= productRolling_index]
                            [#assign prodBrief='']
                            [#assign prodDesc='']
                            [#if productTexts[index]??]
                                [#assign prodBrief=productTexts[index].prodBrief!'']
                                [#assign prodDesc=productTexts[index].prodDescript!'']
                            [/#if]
							<div class="block35944_item" data-prodname="${productRolling.prodName!?html}" data-prodbrief="${productRolling.prodBrief!?html}" data-url="${productRolling.prodUrl}" data-photourl="${productRolling.photoUrlList[0]!}">
								<div class="block35944_itemPic">
									<img loading="lazy" class="lazyimg" src="${productRolling.photoUrlList[0]!}" alt="${productRolling.photoSeoList[0].photoAlt!?html}" title="${productRolling.photoSeoList[0].photoTitle!?html}">
                                </div>
                            </div>
                            [/#list]
						</div>
                        <div class="block35944_next">
                            <i class="icon iconfont_phoenix icon-angle-down"></i>
                            <span>></span>
                        </div>
                    </div>
				</aside>
				<div class="block35944_thumb">
					<img class="lazyimg" data-original="" alt="">
                </div>
                [#else]
                    <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                [/#if]
			</section>
			[/@api]
		</div>

		<script>
			$(function () {
                window._block_namespaces_['block35944'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
            });
		</script>
	</div>
</div>