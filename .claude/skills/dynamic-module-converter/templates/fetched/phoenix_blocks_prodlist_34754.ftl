<div data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
	[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
	<!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
	<style data-collect='1'>
		.block34754 .prodCategotyGoods {
            transform: translateX(10px);
        }
	</style>
	[/#if]
  <div class="backstage-blocksEditor-wrap block34754" data-block-uuid="prodlist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber" 
  data-block-type="phoenix_blocks_prodlist" 
  data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]} >
    
    <style>
      [data-new-auto-uuid="${pageNodeId!''}"] {
        --color-match-setting1: var(--ld-main1,#E48BA5);
      }
    </style>
    
    <div class="prodCategoty-container">
        <div class="site-category">
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
                                        photoSeoList{
                                            photoId
                                            photoUrlNormal
                                            photoAlt
                                            photoTitle
                                        }
                                        prodUrl
                                        photoUrlList
                                    }
                                }
                            }']
                            <a class="title heading5" href="${group.groupUrl!'javascript:void(0)'}" title="${group.groupName!''}">${group.groupName!''}
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
                                                        <div class="link">
                                                            <div class="imgBox">
                                                                <a class="link" href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!''}">
                                                                    <img class="thumb lazyimg" loading="lazy" src="${product.photoUrlList[0]!}" alt="${product.photoSeoList[0].photoAlt!}" title="${product.photoSeoList[0].photoTitle!}" width="340" height="340">
                                                                </a>
                                                            </div>
                                                            <div class="desc">
                                                                <h3 class="text"><a class="link heading5" href="${product.prodUrl!'javascript:void(0)'}">${product.prodName!''}</a></h3>
                                                                <div class="morebutn">
                                                                    <a class="link paragraph2" href="${product.prodUrl!'javascript:void(0)'}">[@s.m "phoenix_view_more"/]<i class="icon iconfont_phoenix icon-jiantouyou lead_icon"></i></a>
                                                                </div>
                                                            </div>
                                                        </div>
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
                                                                    
            <div class="sitewidget-prodCatalog prodCatalogStyle0">
                    <div class="sitewidget1-hd sitewidget-prodcatalog-thumb">
                        <div class="heading5">
                                [#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
                                    [#list data.productGroupList as group]
                                        [#if group_index == 0]${group.groupName!''}[/#if]
                                    [/#list]
                                [/#if]
                        </div>
                        <span class="sitewidget-thumb"></span>
                    </div>
                    <div class="sitewidget1-bd">
                        <ul class="with-submenu slight-submenu-wrap goodsCateList">
                            [#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
                                    [#list data.productGroupList as group]
                                    <li class="goodsCateItem">
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
                                                        <li><a href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!''}" class="heading5">${product.prodName!''}</a></li>
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
                    <div class="prev" ><i class="icon iconfont_phoenix icon-jiantouzuo"></i></div>
                    <div class="next" ><i class="icon iconfont_phoenix icon-jiantouyou"></i></div>
                    <div class="sprev"><i class="icon iconfont_phoenix icon-jiantouyou-5"></i></div>
                    <div class="snext"><i class="icon iconfont_phoenix icon-jiantouyou-5"></i></div>
                    <div class="prodCategotyGoods"></div> 
                </div>
                <script>
                $(function () {
                    window._block_namespaces_['block34754'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}','pageNodeId': '${pageNodeId!""}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
                });
            </script>
            [/@api]
        </div>  
    </div>  
 
  </div>
</div>