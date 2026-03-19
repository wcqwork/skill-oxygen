<div data-gjs-type="phoenix-container" data-strong="1">
    <style>
        .block35864 .proshow-custom-list  {
            display: flex;
            opacity: 0;
        }

        .block35864 .proshow-custom-list.slick-initialized {
            display: block;
            opacity: 1;
            transition: all 0.5s;
        }

        .block35864 .iconfont_phoenix {
            opacity: 0;
        }

        .block35864 .proshow-custom-list.slick-initialized ~ .iconfont_phoenix {
            opacity: 1;
            transition: all 0.5s;
        }
    </style>
    <div class="backstage-blocksEditor-wrap block35864" data-block-uuid="prodlist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber" 
    data-block-type="phoenix_blocks_prodlist" 
    data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]} >
    
        <style>
        [data-new-auto-uuid="${pageNodeId!''}"] {
            --color-match-setting1: var(--ld-main1,rgb(183,0,0));
            /* --color-match-setting2: var(--ld-Auxiliary1,rgb(248,182,27)); */
        }
        </style>
        
        <div class="proshow-container zyw_product_container gxTest3 block-prodlist-container-replace">
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
                                    photoSeoList{
                                        photoId
                                        photoUrlNormal
                                        photoAlt
                                        photoTitle
                                    }
                                    isSkuProd
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
                <div class="proshow-top-shell">
                    <div class="proshow-top-custom-content">
                         <div class="proshow-custom-box">
                            <div class="proshow-custom-list showBox">
                                [#list data.productList.list as productRolling]
                                [#assign index= productRolling_index]
                                <div class="proshow-custom-item">
                                    <div class="proshow-custom-main">
                                        <a href="${productRolling.prodUrl}" class="proshow-custom-image" title="${productRolling.prodName!?html}">
                                            <img src="${productRolling.photoUrlList[0]}" alt="${productRolling.photoSeoList[0].photoAlt!}" title="${productRolling.photoSeoList[0].photoTitle!}" />
                                        </a>
                                        <div class="proshow-custom-caption">
                                            <h3 class="proshow-title proshow-same">
                                                <a class="picDescription heading5" href="${productRolling.prodUrl}" tabindex="0">${productRolling.prodName!?html}</a>
                                            </h3>
                                            <div class="showBtn proshow-same">
                                                <p class="pro-text paragraph2">[@s.m "dCAfKUpiPnGE_more" /]</p>
                                                <p class="pro-arrow"><i class="icon iconfont_phoenix icon-jiantouyou-5" aria-hidden="true"></i></p>
                                                <a href="${productRolling.prodUrl}" tabindex="0"><span></span></a>
                                            </div>
                                            <i class="pro-shadow"></i>
                                        </div>
                                    </div>
                                </div>
                                [/#list]                             
                            </div>
                            <i class="icon iconfont_phoenix icon-jiantouzuo-5"></i>
                            <i class="icon iconfont_phoenix icon-jiantouyou-5"></i>
                        </div>
                    </div>
                </div>
                [#else]
                    <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                [/#if]

                
                <script>
                $(function () {
                    window._block_namespaces_['block35864'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}','pageNodeId': '${pageNodeId!""}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
                });
                </script>
                <script type="application/ld+json">
                    ${data.productList.extraData.prodStructureData!""}
                </script>
            [/@api]
        </div>
    </div>
</div>