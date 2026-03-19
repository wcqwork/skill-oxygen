<div data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
	[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            .block35334 .product .productRow {
                left: 15px;
                right: auto;
            }
            .block35334 .productline {
                margin-left: 0;
                margin-right: auto;
                display: block;
                height: 3px;
            }
            @media (min-width: 769px) {
                .block35334 .productGroup {
                    width: calc(100% - 100px);
                    margin-left: 0;
                    margin-right: auto;
                }
            }
            .block35334 .preAndNext {
                direction: ltr !important;
            }
            .block35334 .lines,
            .block35334 .lines * {
                direction: ltr !important;
                text-align: left;
            }
        </style>
	[/#if]
    <div class="backstage-blocksEditor-wrap block35334" data-block-uuid="prodlist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber" 
    data-block-type="phoenix_blocks_groupProduct">
    <!-- data-default-setting={}  -->
    
        <style>
        [data-new-auto-uuid="${pageNodeId!''}"] {
            --color-match-setting1: var(--ld-main1,#0073B6);
            --color-match-setting2: var(--ld-Auxiliary1, #fff);

            --color-match-ellipses-title-setting1: var(--ld-title3-color, #000);
            --color-match-ellipses-docs-setting1: var(--ld-text1-color, #000);
        }
        </style>
        <div class="prodCategoty-container">
            <div class="container site-category">
                [@api method="post" url="/phoenix2/composite/graphql"
                    selectGroupIds="${dataGroupId!''}"
                    expandIds="${expandIds!''}"
                    jumpMethod="${jumpMethod!'0'}"
                    query='{
                        productGroupList(selectGroupIds: $selectGroupIds, optionsParam: $optionsParam) {
                            encodeId
                            groupName
                            groupUrl
                            groupPhotoUrlList
                            showFieldList
                            groupDescription
                            subGroups
                        }
                    }']
                    [#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
                    <ul class="site-category-list clearfix">
                        <div class="preAndNext" style="display: none;">
                            <div class="slick-prev-qk"><i class="icon iconfont_phoenix icon-jiantouzuo-5 rows"></i></div>
                            <div class="slick-next-qk"><i class="icon iconfont_phoenix icon-jiantouyou-5 rows"></i></div>
                        </div>	
                        <div class="no_padding_201912192038" style="display: none;">
                            [#list data.productGroupList as group]  
                            <div class="slick-item">
                                <li class="category-item">
                                    <div class="productGroup">
                                        <input type="hidden" value="${group.groupPhotoUrlList[0]}" name="${group.encodeId!?html}" data-type="${pageType!'1'}">
                                        [#if group.groupPhotoUrlList[0]?? && (group.groupPhotoUrlList[0]?contains("png") || group.groupPhotoUrlList[0]?contains("jpg"))]
                                        <div class="col_lg_2019122418 col_sm_2019122424">
                                            <div class="col_lg_201912248">
                                                <div class="col_box img_box">
                                                    <div class="img">
                                                        <img  class="lazyimg" src="${group.groupPhotoUrlList[0]!''}" alt="${group.groupName!?html}" title="${group.groupName!?html}" style="object-fit: contain;"/>
                                                    </div>
                                                </div>	
                                            </div>
                                        </div>
                                        [/#if]
                                                    
                                        <div class="col_lg_201912246 col_sm_2019122424 distance">
                                            <div class="col_box text_box">  
                                                <div class='title2 heading3'>${group.groupName!''}</div>
                                                <div class="text">
                                                    <div class="groupDes paragraph1">${group.groupDescription!''}</div>
                                                </div>
                                                
                                                <div class="button">
                                                    <a class="blocks-button paragraph2"  href="${group.groupUrl!'javascript:void(0)'}">
                                                        [@s.m "phoenix_view_more"/]
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>	
                                
                                    <div class="lines">
                                        <div class="arrow"></div>
                                    </div>
                                    [@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'6'}" dataGroupId = "${group.encodeId!''}" 
                                        query='{
                                        productList(
                                            conditionDto:{
                                            groupId: "$dataGroupId"
                                            page: $page
                                            limit: $limit
                                            }) {
                                            list {
                                                encodeId
                                                prodName 
                                                prodBrief
                                                prodUrl
                                                photoUrlList
                                                showFieldList
                                                photoSeoList{
                                                    photoId
                                                    photoUrlNormal
                                                    photoAlt
                                                    photoTitle
                                                }
                                            }
                                        }
                                    }']
                                    [#assign loopLen=0]
                                    [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                                    [#assign loopLen=(data.productList.list?size/4)?ceiling]
                                    [#if loopLen>4][#assign loopLen=4][/#if]
                                                        
                                    <div class="productShows children clearfix children-col-${loopLen!'0'}" data-list="${data.productList.list?size}">
                                        [#list 1..loopLen as i]
                                        <ul  class="children-list children-list-col">
                                        [#list data.productList.list as product]
                                        [#if product_index < i*4 && (product_index+1) > (i-1)*4]
                                            <li class="product star-goods">
                                                <a class="link" href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}">	
                                                    <span class="productImg">
                                                        <img class="lazyimg" src="${product.photoUrlList[0]!''}" alt="${product.photoSeoList[0].photoAlt!?html}" title="${product.photoSeoList[0].photoTitle!?html}" style="object-fit: cover;"/>
                                                    </span>
                                                
                                                    <span class="productDes"> 
                                                        <h3 class="productTitle heading5">${product.prodName!''}</h3>
                                                        <span class="productline"> </span>
                                                        <span class="productRow"><i class="icon iconfont_phoenix icon-jiantouyou-5 rows"></i></span>
                                                    </span>
                                                </a>
                                            </li>
                                        [/#if]
                                        [/#list]		
                                        </ul>
                                        [/#list]
                                    </div>
                                [/#if]
                                [/@api]    
                                </li>
                            </div>
                            [/#list]	
                        </div>
                        </ul>

                    [#else]
                        <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                    [/#if]
                    <script>
                    $(function () {
                        window._block_namespaces_['block35334'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}','pageNodeId': '${pageNodeId!""}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
                    });
                    </script>
                    <script type="application/ld+json">
                        ${data.productList.extraData.prodStructureData!""}
                    </script>
                [/@api]
            </div>
        </div>
    </div>
</div>