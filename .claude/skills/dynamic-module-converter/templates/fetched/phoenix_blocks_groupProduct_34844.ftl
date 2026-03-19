<div data-gjs-type="phoenix-container" data-strong="1">
	<div class="backstage-blocksEditor-wrap" data-block-uuid="prodlist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,pageNumber" data-block-type="phoenix_blocks_groupProduct"
		data-default-setting={"pageSize":10,"page":1,"dataType":"1","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>

		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
                --color-match-setting1: var(--ld-main1,#D7000F);
			}
		</style>

		<div class="block34844">

                    <div class="protab-list">
                        <div class="prev">
                            <i class="icon iconfont_phoenix icon-jiantouzuo-5"></i>
                        </div>
                        <div class="next">
                            <i class="icon iconfont_phoenix icon-jiantouyou-5"></i>
                        </div>
                        <ul class="protab-nav"></ul>
                    </div>

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
                                        groupDescription
                                    }
                                }']
                            [#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
                            <div class="hidden-scrollBar">
                                <div class="outer-vertical-nav">
                                    <ul class="r-tabs-nav fix">
                                        [#list data.productGroupList as group]
                                        [#assign temps='']
                                        [#if group_index==0] [#assign temps='first'][#elseif group_index==table_data?size-1] [#assign temps='last'][/#if]
                                        <li class="r-tabs-tab ${temps!}" >
                                            <a class="img" title="${group.groupName!?html}"><img class="catepic" loading="lazy" src="${group.groupPhotoUrlList[0]!''}" title="${group.groupName!?html}" alt="${group.groupName!?html}"></a>
                                            <a class="r-tabs-anchor paragraph2">${group.groupName!''}</a>
                                        </li>
                                        [/#list]

                                    </ul>
                                
                                </div>
                            </div>
                            <div class="tab-container container-ScrollBar">
                                [#list data.productGroupList as group]
                                <div class="tab-container-inner">
                                    <div class="r-tabs-accordion">
                                        <div class="r-tabs-title heading3">${group.groupName!?html}</div>
                                        
                                    <div class="r-tabs-text paragraph1">${group.groupDescription}</div>
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
                                                    photoSeoList{
                                                        photoId
                                                        photoUrlNormal
                                                        photoAlt
                                                        photoTitle
                                                    }
                                                }
                                            }
                                        }']
                                    <div class="r-tabs-panel article-cate-box">
                                        [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                                        <ul class="sitewidget-prodTabList-conta">
                                            [#list data.productList.list as product]
                                            <li class="pro-item">
                                                <div class="prodTabList-wrapper">
                                                    <div class="tabList-wrapper-inner">

                                                        <div class="prodTabList-cell">
                                                            <a href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!''}">
                                                                <img src="${product.photoUrlList[0]!}" alt="${product.photoSeoList[0].photoAlt!}" title="${product.photoSeoList[0].photoTitle!}" />
                                                            </a>
                                                        </div>
                                                    </div>
                                                    <div class="cont">
                                                        <h3>
                                                            <a class="breakWord heading5" href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}" >${product.prodName!''}</a>
                                                        </h3>
                                                        <div class="prodBrief paragraph1">${product.prodBrief!''}</div>
                                                    <a class="more" href="${product.prodUrl!'javascript:void(0)'}">
                                                        <i class="icon iconfont_phoenix icon-jia-2"></i>
                                                    </a>
                                                    </div>
                                                    
                                                </div>

                                            </li>
                                            [/#list]

                                        </ul>
                                        [/#if]
                                    </div>
                                   [/@api]
                                    <div class="line">
                                        <div class="short-line" ></div>
                                    </div>
                                </div>
                                [/#list]

                            </div>
                            [/#if]

                            <script>
                                $(function () {
                                    window._block_namespaces_['block34844'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
                                });
                            </script>


                           [/@api]
                            
                            </div>
                    </div>

		</div>

	</div>
</div>