<div class="block35714" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <style data-collect='1'>
            .block35714 .proshow-scroll-list {
                transform: translateX(10px);
            }
            .block35714 .proshow-scroll-list .proshow-scroll-item .proDetail_content_addTo .inquireBtn {
                margin-left: 3.5px;
                margin-right: 0;
            }
            .block35714 .proshow-scroll-list .proshow-scroll-item .proDetail_content_addTo .addToBasket {
                margin-left: 0;
                margin-right: 3.5px;
            }
        </style>
    [/#if]
    <style>
        .block35714 .proshow-scroll-list {
            display: flex;
            opacity: 0;
        }
        .block35714 .proshow-scroll-list.slick-initialized {
            display: block;
            opacity: 1;
            transition: all 0.5s;
        }
        .block35714 .LeftJ {
            opacity: 0;
        }
        .block35714 .proshow-scroll-list.slick-initialized ~ .LeftJ {
            opacity: 1;
            transition: all 0.5s;
        }
        .block35714 .RightJ {
            opacity: 0;
        }
        .block35714 .proshow-scroll-list.slick-initialized ~ .RightJ {
            opacity: 1;
            transition: all 0.5s;
        }
    </style>
	<div data-block-uuid="prodlist" data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber"
		data-block-type="phoenix_blocks_prodlist" data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"draggable":false,"data":[{"fieldName":"星级评价","checked":false,"fieldType":"100","value":"1","fieldId":"starRating"},{"fieldName":"简介","checked":false,"fieldType":"101","value":"2","fieldId":"briefIntroduction"},{"fieldName":"品牌","checked":false,"fieldType":"0","value":"3","fieldId":"prodBrand"},{"fieldName":"型号","checked":false,"fieldType":"0","value":"4","fieldId":"prodModel"},{"fieldName":"编码","checked":false,"fieldType":"0","value":"5","fieldId":"prodCode"},{"fieldName":"测试字段四","checked":false,"fieldType":"4","value":"6","fieldId":"oEpAfKHqcSIt"},{"fieldName":"测试字段三","checked":false,"fieldType":"2","value":"7","fieldId":"soKpUAHVcIRj"},{"fieldName":"测试字段五","checked":false,"fieldType":"5","value":"8","fieldId":"nCKAUpwBcSoO"},{"fieldName":"测试字段六","checked":false,"fieldType":"1","value":"9","fieldId":"fWfAKpwqRTUt"},{"fieldName":"测试字段七","checked":false,"fieldType":"8","value":"10","fieldId":"jPKfUpwqceVE"},{"fieldName":"1","checked":false,"fieldType":"0","value":"11","fieldId":"epfKUAHCNOeE"},{"fieldName":"测试字段二","checked":false,"fieldType":"1","value":"12","fieldId":"jqAfKUcLHybZ"},{"fieldName":"测试字段一","checked":false,"fieldType":"3","value":"13","fieldId":"ZCpUKAGuDErW"}],"label":"显示字段","key":"showField"},"functionBtn":{"draggable":true,"data":[{"checked":true,"label":"询盘","value":"1","key":"inquiry"},{"checked":true,"label":"加入询盘栏","value":"2","key":"addInquiry"}],"label":"功能按钮","key":"functionBtn"}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"0","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, rgb(0, 144, 211));
				--color-match-setting2: var(--ld-Auxiliary1, rgb(0, 0, 0));
                --color-match-setting3: var(--ld-Auxiliary2, rgb(255, 255, 255));
			}
		</style>

		<div class="Box">
			<div class="proshow-container">
				<div class="backstage-blocksEditor-wrap wra">
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
                                    productGroupList {
                                        groupName
                                    }                                    
                                }
                            }
                        }']
                    [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
					<div class="proshow-top-shell">
						<div class="proshow-top-content">
							<div class="proshow-scroll-box">
								<div class="proshow-scroll-list">
									[#list data.productList.list as productRolling]
									<div class="proshow-scroll-item">
										<a href="${productRolling.prodUrl}" class="proshow-image" title="${productRolling.prodName!?html}"></a>
										<div class="proshow-scroll-main">
											<div class="imgBox">
												<img loading="lazy" class="lazyimg" src="${productRolling.photoUrlList[0]!}" alt="${productRolling.photoSeoList[0].photoAlt!?html}" title="${productRolling.photoSeoList[0].photoTitle!?html}" />
                                            </div>
                                            <div class="proshow-caption">
                                                <div class="Cls paragraph2">
                                                    [#if productRolling.productGroupList?? && (productRolling.productGroupList?size > 0)]
                                                        [#list productRolling.productGroupList as group]
                                                            <input type="hidden" value="${group.groupName!''}" />
                                                            [#if group_index=0]${group.groupName!''}[/#if]
                                                        [/#list]
                                                    [#else]
                                                        <div class="templist-no-data" style="visibility: hidden;">[@s.m "phoenix_no_content" /]</div>
                                                    [/#if]
                                                </div>
                                                <h3 class="proshow-title heading5">
                                                    ${productRolling.prodName!?html}
                                                </h3>
                                            </div>
                                        </div>
                                        <div class="proDetail_content_addTo prodlist-site-buttons-container">
                                            [#if expandIds?? && expandIds != ""]
                                                [#assign expandIdsJSON=expandIds?eval /]
                                                [#if expandIdsJSON?? && expandIdsJSON.functionBtn?? && expandIdsJSON.functionBtn.data??]
                                                    [#list expandIdsJSON.functionBtn.data as functionBtn]
                                                        <!-- 询盘 -->
                                                        [#if data.productList.extraData?? && data.productList.extraData.isB2cPlan == false]
                                                            [#if functionBtn.checked == true && functionBtn.key == 'inquiry']
                                                                <div class="prodlist-site-buttons block-editor-inquire proDetail_addTo_btn inquireBtn block-editor-inquire" prodId="${productRolling.encodeId}">
                                                                    <a href="javascript:;" target="_self">
                                                                        <span class="text-wrap buy-wrap paragraph2">
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
                                                                <div class="prodlist-site-buttons proDetail_addTo_btn addToBasket" prodId="${productRolling.encodeId}" prodName="${productRolling.prodName!?html}" prodphotourl="${productRolling.photoUrlList[0]!}">
                                                                    <a href="javascript:;" target="_self">
                                                                        <span class="text-wrap buy-wrap paragraph2"><i class="icon iconfont_phoenix icon-gouwuche" style="font-size:12px"></i>[@s.m "phoenix_product_add_inquire" /]</span>
                                                                    </a>
                                                                </div>
                                                            [/#if]
                                                        [/#if]
                                                    [/#list]
                                                [/#if]
                                            [/#if]
                                        </div>
                                    </div>
                                    [/#list]
									</div>
                                    <div class="LeftJ">
                                        <svg t="1675331389087" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="29013" width="20" height="20">
                                            <path d="M362.610347 512l396.401777-388.551111a56.547556 56.547556 0 1 0-79.189333-80.782222L245.305458 468.650667A60.757333 60.757333 0 0 0 227.556124 512c0 16.497778 6.485333 32.199111 17.749334 43.349333l434.631111 425.984a56.547556 56.547556 0 0 0 79.075555-80.782222L362.610347 512z" fill="#0090D3" p-id="29014"></path>
                                        </svg>
                                    </div>
                                    <div class="RightJ">
                                        <svg t="1675331438740" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="29301" width="20" height="20">
                                            <path d="M661.389084 511.544889L264.987307 123.335111a56.547556 56.547556 0 0 1 79.075555-80.782222l434.631111 425.642667c11.377778 11.150222 17.749333 26.851556 17.749334 43.235555a60.643556 60.643556 0 0 1-17.749334 43.349333l-434.631111 425.642667a56.547556 56.547556 0 0 1-79.075555-80.782222l396.401777-388.096z" fill="#0090D3" p-id="29302"></path>
                                        </svg>
                                    </div>
								</div>
							</div>
						</div>
						[#else]
                            <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
						[/#if]
						[/@api]
					</div>
				</div>
			</div>

			<script>
				$(function () {
                window._block_namespaces_['block35714'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
            });
			</script>
		</div>
	</div>