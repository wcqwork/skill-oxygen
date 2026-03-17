<div class="backstage-blocksEditor-wrap wra block_77461" data-block-uuid="searchResult"  data-gjs-type="developer-node-component" data-block-type="phoenix_blocks_searchResult" data-default-setting={"dataLoadMethod":"0","dataPageSize":12,"dataLayoutStyle":"1","dataKeyWord":"0","dataProduct":"Product","dataBlog":"Article","dataVedio":"Video","dataFAQ":"FAQ","dataDownload":"Download","dataAtlas":"Gallery","dataPage":"Page","translationEntry":[]}>
    [@api method="post" url="/phoenix2/composite/graphql" version="v2"
    loadMethod="${dataLoadMethod!''}" limit="${dataPageSize!'12'}" dataLayoutStyle="${dataLayoutStyle!''}" dataKeyWord="${dataKeyWord!''}" page="${pageNum!1}"
    dataAtlas="${dataAtlas!''}" dataBlog="${dataBlog!''}"  dataDownload="${dataDownload!''}" dataFAQ="${dataFAQ!''}" dataPage="${dataPage!''}" dataProduct="${dataProduct!''}" dataVedio="${dataVedio!''}"
    searchValue="${searchValue!''}" searchType="${searchType!''}" searchField="${searchField!''}" searchMethod="${searchMethod!''}" searchScope="${searchScope!''}" subSearchScope="${subSearchScope!''}" 
    query='{
            searchResultList(
                graphqlSearchParamDTO: {searchValue: "$searchValue$", searchType: "$searchType$", searchField: "$searchField$", searchMethod: "$searchMethod$", searchScope: "$searchScope$", subSearchScope:"$subSearchScope$", page: $page$, limit: $limit$}
            ) {
                totalRow
                pageSize
                pageNumber
                list {
                    id
                    nameOrTitle
                    typeCode
                    url
                    photoUrl
                    videoUrl
                    isSkuProd
                    prodPrice
                    prodDiscountPrice
                    shopProdPrice
                    shopProdPriceMax
                    priceDisplayEnabled
                    prodTradeEnabled
                    briefOrSummary
                    briefOrSummaryShort
                    descript
                    descriptShort
                    text
                    textShort
                    author
                    origin
                    rate
                    commentCount
                    isCanAddToCart4ProdList
                    stock
                    skuValueIdStr
                }
                 extraData {
                    scopeStatisticsList {
                        typeCode
                        count
                    }
                    isSingle
                    isB2cPlan
                    coinSymbol
                }
            }
            }']


        <input type="hidden" id="searchValue" value="${searchValue!''}">
        <input type="hidden" id="searchType" value="${searchType!''}">
        <input type="hidden" id="searchField" value="${searchField!''}">
        <input type="hidden" id="searchMethod" value="${searchMethod!''}">
        <input type="hidden" id="searchScope" value="${searchScope!''}">
        <input type="hidden" id="subSearchScope" value="${((subSearchScope!'')!'')?html?replace('"', '&quot;')}">

        <div class="results paragraph1">[@s.m "VgpKAUfrTAFE_PHOENIX2_TOTAL_OF" /] <span style="color:red"> ${data.searchResultList.totalRow!''} </span> [@s.m "VgpKAUfrTAFE_PHOENIX2_RESULTS_WERE_SEARCHED" /]</div>
        <ul class="selece-btn paragraph1">
            
            [#if data?? && data.searchResultList?? && data.searchResultList.extraData?? && data.searchResultList.extraData.scopeStatisticsList??]
                [#list data.searchResultList.extraData.scopeStatisticsList as scopeStatistic]
                    [#if scopeStatistic.typeCode == '1']
                        [#assign assign_product_num = scopeStatistic.count]
                    [/#if]
                    [#if scopeStatistic.typeCode == '2']
                        [#assign assign_article_num = scopeStatistic.count]
                    [/#if]
                    [#if scopeStatistic.typeCode == '3']
                        [#assign assign_dataDownload_num = scopeStatistic.count]
                    [/#if]
                    [#if scopeStatistic.typeCode == '4']
                        [#assign assign_FAQ_num = scopeStatistic.count]
                    [/#if]
                    [#if scopeStatistic.typeCode == '5']
                        [#assign assign_Vedio_num = scopeStatistic.count]
                    [/#if]
                     [#if scopeStatistic.typeCode == '7']
                        [#assign assign_Atlas_num = scopeStatistic.count]
                    [/#if]
                     [#if scopeStatistic.typeCode == '9']
                        [#assign assign_Page_num = scopeStatistic.count]
                    [/#if]
                [/#list]
            [/#if]
            <li data-type="1,2,3,4,5,7,9" class="selected">[@s.m "phoenix_prod_filter_all" /]<span>(${data.searchResultList.totalRow!''})</span></li>
            [#if dataKeyWord??  && dataKeyWord == "1"]
                <li data-type="1">${dataProduct}<span>(${assign_product_num!'0'})</span></li>
                <li data-type="2">${dataBlog}<span>(${assign_article_num!'0'})</span></li>
                <li data-type="3"> ${dataDownload}<span>(${assign_dataDownload_num!'0'})</span></li>
                <li data-type="4">${dataFAQ}<span>(${assign_FAQ_num!'0'})</span></li>
                <li data-type="5">${dataVedio}<span>(${assign_Vedio_num!'0'})</span></li>
                <li data-type="7"> ${dataAtlas}<span>(${assign_Atlas_num!'0'})</span></li>
                <li data-type="9">${dataPage}<span>(${assign_Page_num!'0'})</span></li>
            [#else]
                <li data-type="1">[@s.m "PHENIX2_PRODUCT" /]<span>(${assign_product_num!'0'})</span></li>
                <li data-type="2">[@s.m "PHENIX2_ARTICLE" /]<span>(${assign_article_num!'0'})</span></li>
                <li data-type="3">[@s.m "PHENIX2_DOENLOAD" /]<span>(${assign_dataDownload_num!'0'})</span></li>
                <li data-type="4">[@s.m "PHENIX2_FAQ" /]<span>(${assign_FAQ_num!'0'})</span></li>
                <li data-type="5">[@s.m "PHENIX2_VIDEO" /]<span>(${assign_Vedio_num!'0'})</span></li>
                <li data-type="7">[@s.m "VgpKAUfrTAFE_PHOENIX2_ATLS" /]<span>(${assign_Atlas_num!'0'})</span></li>
                <li data-type="9">[@s.m "PHENIX2_PAGE" /]<span>(${assign_Page_num!'0'})</span></li>
            [/#if]
        </ul>
        <div class="block-listTemp-container-replace [#if dataLayoutStyle == '1']columns-4[/#if]">
            
            <div class="search-grid " id="search-grid">
                [#if data?? && data.searchResultList??]
               
                    [#if data?? && data.searchResultList?? && data.searchResultList.list?? &&  data.searchResultList.list?size > 0]
                        [#list data.searchResultList.list as searchRes]
                            [#if searchRes.typeCode == "1"]
                                <!-- product -->
                                <div class="search-grid-item product" data-pid="${searchRes.id}">
                                    <a class="jump" href="${searchRes.url!''}"></a>
                                    [#if searchRes.photoUrl?? && searchRes.photoUrl !='']
                                        <div class="top-img labelfather">
                                            <img class="lazy prod_img_t12 prod_img_t12_p2" src="${searchRes.photoUrl!''}">
                                        </div>
                                    [/#if]
                                    <div class="bottom-content">
                                        <div class="title titleLabel heading5">[@develop_include appId="29054" styleId="-1" fileName="tags.html"][/@develop_include]${searchRes.nameOrTitle!''}</div>
                                        <div class="prodlist-site-rate">
                                            <div class="prodlist-rate-normal" star-id="${searchRes.rate!'5'}" id="prodlist-site-rate_${searchRes_index}"></div>
                                            <sapn class="num">(${searchRes.commentCount!'0'})</sapn>
                                        </div>
                                        <div class="price">
                                                
                                                <!-- 价格 -->
                                                [#if searchRes.prodTradeEnabled?? && searchRes.prodTradeEnabled == '1' && data.searchResultList.extraData.isB2cPlan == "true"]
                                                    [#if searchRes.isSkuProd?? && searchRes.isSkuProd == '1']
                                                    
                                                            [#if searchRes.shopProdPrice != searchRes.shopProdPriceMax]
                                                                <div class="prodlist-discountprice paragraph1" id="prodPrice">
                                                                    <span class="currencySymbol">${data.searchResultList.extraData.coinSymbol!''}</span>
                                                                    <span class="needExchangeValue" exchangeValue="${searchRes.shopProdPrice!}">${searchRes.shopProdPrice!}</span>
                                                                </div>
                                                                <div class="prodlist-price paragraph1" id="prodPrice">
                                                                    <span class="currencySymbol">${data.searchResultList.extraData.coinSymbol!''}</span>
                                                                    <span class="needExchangeValue" exchangeValue="${searchRes.shopProdPriceMax!}">${searchRes.shopProdPriceMax?string(',###.##')!}</span>
                                                                </div>
                                                            [#else]
                                                                <div class="prodlist-discountprice paragraph1" id="prodPrice">
                                                                    <span class="currencySymbol">${data.searchResultList.extraData.coinSymbol!''}</span>
                                                                    <span class="needExchangeValue" exchangeValue="${searchRes.shopProdPrice!}">${searchRes.shopProdPrice!}</span>
                                                                </div>
                                                            [/#if]
                                                    [#else]
                                                            [#if searchRes.prodDiscountPrice?? && searchRes.prodDiscountPrice != searchRes.prodPrice]
                                                                <div class="prodlist-discountprice" id="prodDiscountPrice">
                                                                    <span class="currencySymbol">${data.searchResultList.extraData.coinSymbol!''}</span>
                                                                    <span class="needExchangeValue" exchangeValue="${searchRes.prodDiscountPrice!}">${searchRes.prodDiscountPrice!}</span>
                                                                </div>
                                                                <div class="prodlist-price paragraph1" id="prodPrice">
                                                                    <span class="currencySymbol">${data.searchResultList.extraData.coinSymbol!''}</span>
                                                                    <span class="needExchangeValue" exchangeValue="${searchRes.prodPrice!}" >${searchRes.prodPrice!}</span>
                                                                </div>
                                                            [#else]
                                                                <div class="prodlist-discountprice paragraph1" id="prodPrice">
                                                                    <span class="currencySymbol">${data.searchResultList.extraData.coinSymbol!''}</span>
                                                                    <span class="needExchangeValue" exchangeValue="${searchRes.prodPrice!}">${searchRes.prodPrice!}</span>
                                                                </div>
                                                            [/#if]
                                                    [/#if]
                                                [/#if]
                                        </div>
                                    </div>
                                </div>
                            [/#if]
                            [#if searchRes.typeCode == "2"]
                                 <!-- article -->
                                <div class="search-grid-item article">
                                   <a class="jump" href="${searchRes.url!''}"></a>
                                   [#if searchRes.photoUrl?? && searchRes.photoUrl !='']
                                        <div class="top-img">
                                            <img class="lazy prod_img_t12 prod_img_t12_p2" src="${searchRes.photoUrl!''}">
                                        </div>
                                    [/#if]
                                    <div class="bottom-content">
                                        <div class="title heading5">[@develop_include appId="29054" styleId="-1" fileName="tags.html"][/@develop_include]${searchRes.nameOrTitle!''}</div>
                                        <div class="desc paragraph1">${searchRes.briefOrSummary}</div>
                                    </div>
                                </div>
                            [/#if]
                            [#if searchRes.typeCode == "3"]
                              <!-- 下载 -->
                                <div class="search-grid-item download">
                                    <a class="jump downFile" data-name= "${searchRes.nameOrTitle!''}"  data-href="${searchRes.url!''}" ></a>
                                    [#if searchRes.photoUrl?? && searchRes.photoUrl !='']
                                        <div class="top-img">
                                            <img class="lazy prod_img_t12 prod_img_t12_p2" src="${searchRes.photoUrl!''}">
                                        </div>
                                    [/#if]
                                    <div class="bottom-content">
                                        <div class="title heading5">[@develop_include appId="29054" styleId="-1" fileName="tags.html"][/@develop_include]${searchRes.nameOrTitle!''}</div>
                                    </div>
                                    <a class="download-btn paragraph1" href="">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 14 14" fill="none">
                                        <path d="M6.64645 9.35355C6.84171 9.54882 7.15829 9.54882 7.35355 9.35355L10.5355 6.17157C10.7308 5.97631 10.7308 5.65973 10.5355 5.46447C10.3403 5.2692 10.0237 5.2692 9.82843 5.46447L7 8.29289L4.17157 5.46447C3.97631 5.2692 3.65973 5.2692 3.46447 5.46447C3.2692 5.65973 3.2692 5.97631 3.46447 6.17157L6.64645 9.35355ZM6.5 0L6.5 9H7.5L7.5 0L6.5 0Z" fill="#333333"/>
                                        <path d="M1 8V12C1 12.5523 1.44772 13 2 13H12C12.5523 13 13 12.5523 13 12V8" stroke="#333333"/>
                                        </svg>
                                        [@s.m "PHENIX2_DOENLOAD" /]
                                    </a>
                                </div>
                             
                            [/#if]
                            [#if searchRes.typeCode == "4"]
                                 <!-- faq -->
                                <div class="search-grid-item faq">
                                    <a class="jump" href="${searchRes.url!''}"></a>
                                    <div class="bottom-content">
                                        <div class="title heading5">[@develop_include appId="29054" styleId="-1" fileName="tags.html"][/@develop_include]${searchRes.nameOrTitle!''}</div>
                                        <div class="desc paragraph1">${searchRes.briefOrSummary}</div>
                                    </div>
                                </div>

                            [/#if]
                            [#if searchRes.typeCode == "5"]
                                  <!-- 视频 -->
                                <div class="search-grid-item video">
                                    <a class="jump" href="${searchRes.url!''}"></a>
                                    [#if searchRes.photoUrl?? && searchRes.photoUrl !='']
                                    <div class="top-img">
                                        <img src="${searchRes.photoUrl!''}" class="lazy prod_img_t12 prod_img_t12_p2">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 30 30" fill="none">
                                        <circle cx="15" cy="15" r="15" fill="white"/>
                                        <path d="M21 15L12 20.1962L12 9.80385L21 15Z" fill="black"/>
                                        </svg>
                                    </div>
                                    [/#if]
                                    <div class="bottom-content">
                                        <div class="title heading5">[@develop_include appId="29054" styleId="-1" fileName="tags.html"][/@develop_include]${searchRes.nameOrTitle!''}</div>
                                        <div class="desc paragraph1">${searchRes.briefOrSummary}</div>
                                    </div>
                                </div>
                            [/#if]
                            [#if searchRes.typeCode == "7"]
                                <!-- 图册 -->
                                <div class="search-grid-item atlas">
                                    <a class="jump" href="${searchRes.url!''}"></a>
                                    [#if searchRes.photoUrl?? && searchRes.photoUrl !='']
                                    <div class="top-img">
                                        <img src="${searchRes.photoUrl!''}" class="lazy prod_img_t12 prod_img_t12_p2">
                                    </div>
                                    [/#if]
                                    <div class="bottom-content">
                                        <div class="title heading5">[@develop_include appId="29054" styleId="-1" fileName="tags.html"][/@develop_include]${searchRes.nameOrTitle!''}</div>
                                        <div class="desc paragraph1">${searchRes.briefOrSummary}</div>
                                    </div>
                                </div>
                            [/#if]

                            [#if searchRes.typeCode == "9"]
                                <!-- page -->
                                <div class="search-grid-item page">
                                    <a class="jump" href="${searchRes.url!''}"></a>
                                    <div class="bottom-content">
                                        <div class="title heading5">[@develop_include appId="29054" styleId="-1" fileName="tags.html"][/@develop_include]${searchRes.nameOrTitle!''}</div>
                                        <div class="desc paragraph1">${searchRes.briefOrSummary}</div>
                                        
                                    </div>
                                </div>
                            [/#if]
                        [/#list]
                    [#else]
                        [@develop_include appId="29054" styleId="-1" fileName="empty.html"][/@develop_include]
                    [/#if]
                [/#if]

            </div>
            <input type="hidden" name="totalRow" value="${data.searchResultList.totalRow}"> 
            <input type="hidden" name="pageNumber" value="${data.searchResultList.pageNumber}">
            <input type="hidden" name="pageSize" value="${data.searchResultList.pageSize}">
           
        </div>
         [#if !loadMethod?? || loadMethod == '0']
            <div class="searchResult-site-pagination-77461 [#if data.searchResultList.totalRow?? && data.searchResultList.pageSize?? && (data.searchResultList.totalRow < data.searchResultList.pageSize || data.searchResultList.totalRow == data.searchResultList.pageSize)]hide[/#if]">
                <div class="searchResult-laypage-normal" id='searchResult-laypage-normal'></div>
            </div>
        [/#if]
        <script>
        $(function(){
            window._block_namespaces_['searchResult_77461'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'searchResult_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
        });
        </script>
    [/@api]
</div>