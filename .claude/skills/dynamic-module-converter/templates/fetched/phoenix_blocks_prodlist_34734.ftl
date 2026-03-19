<div data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            div.block34714 .pro-item .cont .more {
                position: absolute;
                left: 20px;
                right: auto;
            }
            div.block34714 .content_area .group .group_content {
                display: inline-flex;
                justify-content: flex-start;
            }  
            div.block34714 .content_area .group .group_content .img {
                display: inline-block;
                margin-right: 20px;
                margin-left: auto;
            } 
            div.block34714 .content_area .group .group_content .title {
                position: absolute;
                left: auto;
                right: 50%;
            }      
            div.block34714 .r-tabs-accordion .r-tabs-title {
                text-align: center;
            }                                       
        </style>
    [/#if]
	<div class="backstage-blocksEditor-wrap" data-block-uuid="prodlist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,pageNumber" data-block-type="phoenix_blocks_prodlist"
		data-default-setting={"pageSize":4,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>

		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1,#D7000F);
			}
		</style>

		<div class="block34714">

                <div class="content_area">
                <!-- 将产品分类名称和图片插入此处 -->
                <div class="prodCategotyGroup">
                    <div class="prev arrow"><i class="icon iconfont_phoenix icon-jiantouzuo-5"></i></div>
                    <div class="next arrow"><i class="icon iconfont_phoenix icon-jiantouyou-5"></i></div>
                    <div class="group slick swiper-container"><div class="swiper-wrapper"></div></div>
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
                                                    photoSeoList{
                                                        photoId
                                                        photoUrlNormal
                                                        photoAlt
                                                        photoTitle
                                                    }
                                                    photoUrlList
                                                }
                                            }
                                        }']
                                        <div class="group_content swiper-slide">
                                            <a class="img" title="${group.groupName!?html}"><img class="catepic" loading="lazy" src="${group.groupPhotoUrlList[0]!''}" alt="${group.groupName!?html}" title="${group.groupName!?html}"></a>
                                            <a class="title paragraph2" href="javascript:void(0)" title="${group.groupName!''}">${group.groupName!''}</a>
                                        </div>
                                        <div class="r-tabs-accordion">
                                            <div class="r-tabs-title heading3">${group.groupName!?html}</div>
                                            <div class="r-tabs-text paragraph1">${group.groupDescription}</div>
                                        </div>
                                         [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                                        <ul class="prodTabList-conta">
                                            <div class="swiper-container">
                                            <div class="swiper-wrapper">
                                            [#list data.productList.list as product]
                                            <li class="pro-item swiper-slide">
                                                <div class="prodTabList-wrapper">
                                                    <div class="tabList-wrapper-inner">
                                                        <div class="prodTabList-cell">
                                                            <a class="href" href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}">
                                                                <img loading="lazy" src="${product.photoUrlList[0]!}" alt="${product.photoSeoList[0].photoAlt!}" title="${product.photoSeoList[0].photoTitle!}" />
                                                            </a>
                                                        </div>
                                                    </div>
                                                    <div class="cont">
                                                        <h3 class="heading5"><a class="breakWord heading5" href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}">${product.prodName!''}</a></h3>
                                                        <div class="prodBrief paragraph1">${product.prodBrief!''}</div>
                                                        <a class="more" href="${product.prodUrl!'javascript:void(0)'}">
                                                            <i class="icon iconfont_phoenix icon-jia-2"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </li>
                                            [/#list]
                                            </div>
                                            <div class="swiper-scrollbar">
                                                <div class="swiper-scrollbar-drag"></div>
                                            </div>
                                            </div>
                                        </ul>
                                        [/#if]
                                    [/@api]                               
                                </li>
                                [/#list]
                            </ul>
                        [/#if]   

                        <script>

                        $(function () {
                            window._block_namespaces_['block34714'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
                        });
                    </script>

                    [/@api]  
                    </div>                                                                
                    </div>
                </div>

		</div>

	</div>
</div>