<div class="block35074" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <style data-collect='1'>
            .block35074 .proshow-scroll-main .right_title {
                text-align: right;
            }
            .block35074 .proshow-scroll-main .product_dec {
                text-align: right;
            }
            @media (min-width: 768px) {
                div.block35074 .proshow-scroll-main .proshow-title {
                    position: absolute;
                    left: auto;
                    right: 51%;
                }  
            }          
        </style>
    [/#if]
    <div data-block-uuid="prodlist" data-gjs-type="developer-node-component"
        data-block-list-setting="dataSelect,pageNumber" data-block-type="phoenix_blocks_prodlist" data-default-setting={"pageSize":20,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>

        <style>
        [data-new-auto-uuid="${pageNodeId!''}"] {
            --color-match-setting1: var(--ld-main1, #FF9A00);
        }
        </style>
        
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

                    [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                        <div class="proshow-top-shell">
                            <div class="proshow-top-content">
                                <div class="proshow-scroll-box">
                                    <div class="proshow-scroll-list">
                                        [#list data.productList.list as productRolling]
                                            [#assign index= productRolling_index]
                                            [#if index<6]
                                                <div class="proshow-scroll-item" data-pid="${productRolling.encodePkId}">
                                                    <div class="proshow-scroll-main">
                                                        <div class="lebal_box"></div>
                                                        <div class="lebal_img_box"></div>                                                        
                                                        <div class="img_box">
                                                            <div class="proshow-image" style="display: inline;">
                                                                <img class="lazyimg" src="${productRolling.photoUrlList[0]!}" alt="${productRolling.photoSeoList[0].photoAlt!?html}" title="${productRolling.photoSeoList[0].photoTitle!?html}" />
                                                            </div>
                                                        </div>
                                                        <div class="proshow-caption">
                                                            <div class="proshow-title">
                                                                <h3>
                                                                    <a href="${productRolling.prodUrl}" class="right_title heading5" tabindex="0" ><span class="showPositon_title"></span>${productRolling.prodName!?html}</a>
                                                                </h3>
                                                                [#if productRolling.prodBrief?? && productRolling.prodBrief!='']<div class="product_dec paragraph1">${productRolling.prodBrief!}</div>[/#if]
                                                                <a href="${productRolling.prodUrl}" class="right_btn paragraph2">[@s.m "phoenix_view_more" /]</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            [/#if]
                                        [/#list]

                                        [#list data.productList.list as productRolling]
                                            [#assign index= productRolling_index]
                                            [#if index gte 6]
                                                <div class="proshow-scroll-item flag_hide" data-pid="${productRolling.encodePkId}">
                                                    <div class="proshow-scroll-main">
                                                        <div class="lebal_box"></div>
                                                        <div class="lebal_img_box"></div>
                                                        
                                                        <div class="img_box">
                                                            <a href="${productRolling.prodUrl}" class="proshow-image" title="${productRolling.prodName!?html}">
                                                                <img class="lazyimg" src="${productRolling.photoUrlList[0]!}" alt="${productRolling.photoSeoList[0].photoAlt!?html}" title="${productRolling.photoSeoList[0].photoTitle!?html}" />
                                                            </a>
                                                        </div>
                                                        <div class="proshow-caption">
                                                            <div class="proshow-title">
                                                                <h3>
                                                                    <a href="${productRolling.prodUrl}" class="right_title heading5" tabindex="0" ><span class="showPositon_title"></span>${productRolling.prodName!?html}</a>
                                                                </h3>
                                                                [#if productRolling.prodBrief?? && productRolling.prodBrief!='']<div class="product_dec paragraph1">${productRolling.prodBrief!}</div>[/#if]
                                                                <a href="${productRolling.prodUrl}" class="right_btn paragraph2">[@s.m "phoenix_view_more" /]</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            [/#if]
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
        <div class="fy_btn">
            <i class="icon iconfont_phoenix icon-angle-down"></i>         
        </div>
        <script>
            $(function () {
                window._block_namespaces_['block35074'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
            });
        </script>
    </div>
</div>