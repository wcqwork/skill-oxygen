<div data-gjs-type="phoenix-container" data-strong="1">
    <div class="backstage-blocksEditor-wrap block35344" data-block-uuid="prodlist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber" 
    data-block-type="phoenix_blocks_prodlist" 
    data-default-setting={"pageSize":6,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]} >
    
        <style>
        [data-new-auto-uuid="${pageNodeId!''}"] {
            --color-match-setting1: var(--ld-main1, #16709B);
        }
        </style>
        
        <div class="proshow-container zyw_product_container gxTest3">
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
                                    photoSeoList{
                                        photoId
                                        photoUrlNormal
                                        photoAlt
                                        photoTitle
                                    }
                                    showFieldList
                                    customFieldList
                                    shopProdPrice
                                    $showField
                                    phoenixProductSubVo{
                                        hasProdVideo
                                    }
                                }
                            }
                        }']
                [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                <div class="proshow-top-shell block-prodlist-container-replace">
                    <div class="proshow-top-content">
                        <div class="proshow-scroll-box ">
                            <div class="proshow-scroll-list tw">
                                [#list data.productList.list as productRolling]
                                [#assign index= productRolling_index]        
                                <div class="proshow-scroll-item twitem twitemborder">
                                    <div class="righticon">
                                        <a href="${productRolling.prodUrl}"  tabindex="0">  →</a>
                                    </div>
                                    <div class="proshow-scroll-main">
                                    <div class="imgcontainer"> 
                                        <img class="lazyimg" src="${productRolling.photoUrlList[0]!''}" alt="${productRolling.photoSeoList[0].photoAlt!}" title="${productRolling.photoSeoList[0].photoTitle!}">
                                    </div>
                                        <div class="proshow-caption banner-description">
                                            <div class="proshow-title">
                                                <h3 class="title_container heading5">
                                                    <a href="${productRolling.prodUrl}"  tabindex="0" class="twitem-name heading5">
                                                        ${productRolling.prodName!?html}
                                                    </a>
                                                </h3>
                                            </div>
                                                <div class="divider divider-sm divider-primary twitem-docs paragraph1">
                                                ${productRolling.prodBrief}
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
                <input type="hidden" name="pageSize" value="${data.productList.pageSize!'20'}">
                <input type="hidden" name="layoutStyle" value="${layoutStyle!'0'}">
                <input type="hidden" name="jumpMethod" value="${jumpMethod!'0'}">

                [#if data.productList.pageSize?? && data.productList.totalRow?? && data.productList.totalRow <=  data.productList.pageSize]
                <div class="prodlist-site-pagination-77334 hide">
                [#else]
                <div class="prodlist-site-pagination-77334">
                [/#if]
                    <div class="prodlist-laypage-normal" id='prodlist-laypage-normal'></div>
                </div>
                <script>
                $(function () {
                    window._block_namespaces_['block35344'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}','pageNodeId': '${pageNodeId!""}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
                });
                </script>
                <script type="application/ld+json">
                    ${data.productList.extraData.prodStructureData!""}
                </script>
            [/@api]
        </div>
    </div>
</div>