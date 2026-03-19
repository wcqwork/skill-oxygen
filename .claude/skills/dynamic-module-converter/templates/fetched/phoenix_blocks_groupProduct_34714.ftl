<div 
  data-gjs-type="phoenix-container"
  data-strong="1" 
>
  <div class="backstage-blocksEditor-wrap" data-block-uuid="prodlist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber" data-block-type="phoenix_blocks_groupProduct" data-default-setting={"pageSize":10,"page":1,"dataType":"1","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
    
    <style>
      [data-new-auto-uuid="${pageNodeId!''}"] {
        --color-match-setting1: var(--ld-main1, #015EAE);
      }
    </style>
    
    <div class="block34714 init-hide">
    <div class="prodCategoty-container">
        <div class=" site-category" >
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
                    }
                }']
                [#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
                    <ul class="site-category-list clearfix">
                        [#list data.productGroupList as group]             
                        <li class="category-item">
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
                                        }
                                    }
                                }']
                                <a class="title" href="${group.groupUrl!'javascript:void(0)'}" title="${group.groupName!''}">${group.groupName!''}
                                    [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                                    <i class="fa fa-angle-right" aria-hidden="true"></i>
                                    [/#if]
                                </a>
                                [#assign loopLen=0]
                                [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                                    [#assign loopLen=(data.productList.list?size/6)?ceiling]
                                    [#if loopLen>4][#assign loopLen=4][/#if]
                                    <div class="children clearfix children-col-${loopLen!'0'}">
                                        [#list 1..loopLen as i]
                                            <ul class="children-list children-list-col ${i}">
                                                [#list data.productList.list as product]
                                                        <li class="star-goods">
                                                            <div class="imgBox">
                                                                <div class="border"></div>
                                                                <div class="pic">
                                                                    <a class="link" href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}" ><i class="icon iconfont_phoenix icon-jia"></i></a>
                                                                    <img class="thumb" loading="lazy" src="${product.photoUrlList[0]!}" width="340" height="340" alt="${productRolling.photoSeoList[0].photoAlt!}" title="${productRolling.photoSeoList[0].photoTitle!}">
                                                                </div>
                                                            </div>
                                                            <h3 class="text"><a class="heading5" href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}">${product.prodName!''}</a></h3>
                                                        </li>
                                                [/#list]
                                            </ul>
                                        [/#list]
                                    </div>                                    
                                [/#if]
                            [/@api]    

                        </li>
                        [/#list]
                    </ul>
                [/#if]
                                                                        
                <div class="sitewidget-prodCatalog prodCatalogStyle0 prodCategotyTitle">
                        <div class="sitewidget-hd sitewidget-prodcatalog-thumb">
                            <h3 class="sitewidget-prodatcalog-notitle heading5">
                                [#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
                                    [#list data.productGroupList as group]
                                        [#if group_index == 0]${group.groupName!''}[/#if]
                                    [/#list]
                                [/#if]
                            </h3>
                            <span class="sitewidget-thumb"></span>
                        </div>
                        <div class="sprev"><i class="icon iconfont_phoenix icon-jiantouzuo-5"></i></div>
                        <div class="snext"><i class="icon iconfont_phoenix icon-jiantouyou-5"></i></div>
                        <div class="sitewidget-bd">
                            <ul class="with-submenu slight-submenu-wrap goodsCate-list">
                                [#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
                                        [#list data.productGroupList as group]
                                        <li class="goodsCate-item">
                                            <span class="paragraph2">${group.groupName!''}</span>			
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
                                                    }
                                                }
                                            }']
                                                [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                                                    <ul class="with-submenu-li">
                                                        [#list data.productList.list as product]
                                                            <li><a class="heading5" href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}">${product.prodName!''}</a></li>
                                                        [/#list]
                                                    </ul>
                                                [/#if]
                                             [/@api]
                                        </li>
                                    [/#list]
                                [#else]
                                    <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                                [/#if]
                            </ul>
                        </div>

                    </div> 
                    <div class="cont">
                        <ul class="prodCategotyGoods">
                            <li class="star-goods">
                                <div class="imgBox">
                                    <div class="border"></div>
                                    <div class="pic">
                                        <a class="link" ><i class="icon iconfont_phoenix icon-jia"></i></a>
                                        <img class="thumb" loading="lazy" src="" width="340" height="340" style="opacity: 0;" />
                                    </div>
                                </div>
                                <h3 class="text" style="opacity: 0;"><a class="heading5">Product Name</a></h3>
                            </li>                            
                        </ul> 
                        
                        <div class="prev" ><i class="icon iconfont_phoenix icon-jiantouzuo-5"></i></div>
                        <div class="next" ><i class="icon iconfont_phoenix icon-jiantouyou-5"></i></div>
                    </div>
                    <script>
                    $(function () {
                        window._block_namespaces_['block34714'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}','pageNodeId': '${pageNodeId!""}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
                    });
                </script>
             [/@api]
            </div>                                                                 
    </div>
</div>
    
    
  </div>
</div>