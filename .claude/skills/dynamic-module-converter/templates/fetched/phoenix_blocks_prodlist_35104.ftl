<div class="block35104" data-gjs-type="phoenix-container" data-strong="1">
    <div data-block-uuid="prodlist" data-gjs-type="developer-node-component"
        data-block-list-setting="dataSelect,loadMethod,pageNumber" data-block-type="phoenix_blocks_prodlist" data-default-setting={"pageSize":8,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"draggable":false,"data":[{"fieldName":"星级评价","checked":false,"fieldType":"100","value":"1","fieldId":"starRating"},{"fieldName":"简介","checked":false,"fieldType":"101","value":"2","fieldId":"briefIntroduction"},{"fieldName":"品牌","checked":false,"fieldType":"0","value":"3","fieldId":"prodBrand"},{"fieldName":"型号","checked":false,"fieldType":"0","value":"4","fieldId":"prodModel"},{"fieldName":"编码","checked":false,"fieldType":"0","value":"5","fieldId":"prodCode"}],"label":"显示字段","key":"showField"},"functionBtn":{"draggable":true,"data":[{"checked":false,"label":"询盘","value":"1","key":"inquiry"},{"checked":false,"label":"加入询盘栏","value":"2","key":"addInquiry"},{"checked":false,"label":"立即购买","value":"3","key":"buyNow"},{"checked":false,"label":"加入购物车","value":"4","key":"addBasket"}],"label":"功能按钮","key":"functionBtn"}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
        <style>
        [data-new-auto-uuid="${pageNodeId!''}"] {
            --color-match-setting1: var(--ld-main1, #42b3e5);
            --color-match-setting2: var(--ld-Auxiliary1, #ebf6fb);
        }
        </style>
        
        <div class="pro-duct">
            <div class="proshow-container">
                <div class="wra">
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
                    <div class="block-article-container-replace ">
                        [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                        <div class="proshow-top-shell">
                            <div class="proshow-top-content">
                                <div class="proshow-scroll-box">
                                    <div class="proshow-scroll-list">
                                        [#list data.productList.list as productRolling]
                                        [#assign index= productRolling_index]
                                        [#assign prodBrief='']
                                        [#assign prodDesc='']
                                        [#if productTexts[index]??]
                                            [#assign prodBrief=productTexts[index].prodBrief!'']
                                            [#assign prodDesc=productTexts[index].prodDescript!'']
                                        [/#if]
                                        <div class="proshow-scroll-item">
                                            <div class="proshow-scroll-main">
                                                <div class="img-box">
                                                    <a href="${productRolling.prodUrl}" class="proshow-image" title="${productRolling.prodName!?html}"> </a>
                                                    <img loading="lazy" class="lazyimg" src="${productRolling.photoUrlList[0]!}" alt="${productRolling.photoSeoList[0].photoAlt!?html}" title="${productRolling.photoSeoList[0].photoTitle!?html}">
                                                </div>
                                                <div class="proshow-caption">
                                                    <div class="proshow-title">
                                                        <h3>
                                                            <a class="pro-title-a heading5" href="${productRolling.prodUrl}" tabindex="0">${productRolling.prodName!?html}</a>
                                                        </h3>
                                                    </div>
                                                    <div class="divider divider-sm divider-primary">
                                                        <a class="moreBtn paragraph2" href="${productRolling.prodUrl}" tabindex="0">[@s.m "phoenix_more" /]</a>
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
                    </div>
                    <input type="hidden" name="totalRow" value="${data.productList.totalRow!'0'}"> 
                    <input type="hidden" name="pageNumber" value="${data.productList.pageNumber!'1'}">
                    <input type="hidden" name="pageSize" value="${data.productList.pageSize!'10'}">

                    [#if (dataType?? && dataType != '3') && (!loadMethod?? || loadMethod == '0') && !(data.articleList.pageSize?? && data.articleList.totalRow?? && data.articleList.totalRow <=  data.articleList.pageSize)]
                        <div class="artclelist-site-pagination">
                            <div class="artclelist-laypage-normal" id='artclelist-laypage-normal'></div>
                        </div>
                    [/#if]
                    <script>
                        $(function () {
                            window._block_namespaces_['block35104'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
                        });
                    </script>
                    <script type="application/ld+json">
                        ${data.articleList.extraData.articleStructureData!""}
                    </script>
                    [/@api]
                </div>
            </div>
        </div>
    </div>
</div>