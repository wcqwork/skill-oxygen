<div class="block35644" data-gjs-type="phoenix-container" data-strong="1">

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

    <div data-block-uuid="prodlist" data-gjs-type="developer-node-component"
        data-block-list-setting="dataSelect,pageNumber" data-block-type="phoenix_blocks_prodlist" data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
        <style>
        [data-new-auto-uuid="${pageNodeId!''}"] {
            --color-match-setting1: var(--ld-main1, #000000);
        }
        </style>
        
        <div class="proList">
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
                    <div class="proshow-top-shell">
                        <div class="proshow-top-content">
                            <div class="proshow-scroll-box">
                                <button class="slick-prev slick-btn">
                                    <svg width="11px" height="18px" viewBox="0 0 11 18" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">                                        
                                        <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" opacity="0.301153274">
                                            <g transform="translate(-85.000000, -2387.000000)" fill="#000000" fill-rule="nonzero">
                                                <g transform="translate(90.945055, 2396.000000) scale(-1, 1) translate(-90.945055, -2396.000000) translate(86.000000, 2387.000000)">
                                                    <path d="M0.271536502,16.3109547 C-0.011038058,16.7348165 -0.152325348,17.1586784 0.271536502,17.5825402 C0.695398352,18.0064021 0.977972931,18.0064021 1.40183478,17.7238275 L9.73778454,9.67045231 C9.73778454,9.38787775 9.87907181,9.24659046 9.87907181,8.9640159 C9.87907181,8.68144134 9.73778452,8.54015405 9.59649725,8.25757947 L1.40183478,0.204204286 C1.11926022,-0.0783702737 0.554111081,-0.0783702737 0.271536502,0.345491556 C-0.011038058,0.628066117 -0.011038058,1.19321526 0.271536502,1.61707712 L7.90104983,8.9640159 L0.271536502,16.3109547 Z" id="路径"></path>
                                                </g>
                                            </g>
                                        </g>
                                    </svg>
                                </button>
                                <button class="slick-next slick-btn">
                                    <svg width="10px" height="18px" viewBox="0 0 10 18" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">                                       
                                        <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" opacity="0.301153274">
                                            <g transform="translate(-114.000000, -2387.000000)" fill="#000000" fill-rule="nonzero">
                                                <g transform="translate(114.000000, 2387.000000)">
                                                    <path d="M0.271536502,16.3109547 C-0.011038058,16.7348165 -0.152325348,17.1586784 0.271536502,17.5825402 C0.695398352,18.0064021 0.977972931,18.0064021 1.40183478,17.7238275 L9.73778454,9.67045231 C9.73778454,9.38787775 9.87907181,9.24659046 9.87907181,8.9640159 C9.87907181,8.68144134 9.73778452,8.54015405 9.59649725,8.25757947 L1.40183478,0.204204286 C1.11926022,-0.0783702737 0.554111081,-0.0783702737 0.271536502,0.345491556 C-0.011038058,0.628066117 -0.011038058,1.19321526 0.271536502,1.61707712 L7.90104983,8.9640159 L0.271536502,16.3109547 Z" id="路径"></path>
                                                </g>
                                            </g>
                                        </g>
                                    </svg>
                                </button>
                                <div class="proshow-scroll-list">
                                    [#list data.productList.list as productRolling]
                                    <div class="proshow-scroll-item">
                                        <div class="proshow-scroll-main">
                                            <a href="${productRolling.prodUrl}" class="proshow-image" title="${productRolling.prodName!?html}">
                                                <img loading="lazy" src="${productRolling.photoUrlList[0]!}" alt="${productRolling.photoSeoList[0].photoAlt!?html}" title="${productRolling.photoSeoList[0].photoTitle!?html}">
                                            </a>
                                            <div class="proshow-caption">
                                                <div class="divider divider-sm divider-primary"></div>
                                                <div class="proshow-title">
                                                    <h3>
                                                        <a class="heading5" href="${productRolling.prodUrl}" tabindex="0">${productRolling.prodName!?html}</a>
                                                    </h3>
                                                    [#if data.productList.extraData?? && data.productList.extraData.isB2cPlan == true && productRolling.shopProdPrice??]
                                                    <div class="prodlist-discountprice paragraph2" id="prodPrice">
                                                        <span class="currencySymbol">${data.productList.extraData.coinSymbol!'$'}</span>
                                                        <span class="needExchangeValue" exchangeValue="${productRolling.shopProdPrice!}">${productRolling.shopProdPrice!}</span>
                                                    </div>
                                                    [/#if]
                                                </div>
                                            </div>
                                            <!-- <div class="addCart"><a class="paragraph2" href="${productRolling.prodUrl}">[@s.m "eRKAfpUNFbOE_add_to_cart" /]</a></div> -->
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
                    [/@api]
                </div>
            </div>
        </div>
        
        <script>
            $(function () {
                window._block_namespaces_['block35644'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
            });
        </script>
    </div>
</div>