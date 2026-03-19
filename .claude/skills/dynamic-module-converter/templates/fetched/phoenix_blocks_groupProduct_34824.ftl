<div data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
	[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
	<!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
	<style data-collect='1'>
		.block34824 .Box .r-tabs-nav .r-tabs-tab .imgbox {
            margin-left: 20px;
            margin-right: 0;
        }
	</style>
	[/#if]
    <style>
        .block34824 .hidden-scrollBar.swiper-container {
            opacity: 0;
        }
        .block34824 .hidden-scrollBar.swiper-container ~ .BoxBottom {
            opacity: 0;
        }
        .block34824 .hidden-scrollBar.swiper-container ~ .block_35284_BoxBottom_1 {
            opacity: 0;
        }
        .block34824 .hidden-scrollBar.swiper-container.swiper-initialized {
            opacity: 1;
            transition: all 0.5s;
        }
        .block34824 .hidden-scrollBar.swiper-container.swiper-initialized ~ .BoxBottom {
            opacity: 1;
            transition: all 0.5s;
        }
        .block34824 .hidden-scrollBar.swiper-container.swiper-initialized ~ .block_35284_BoxBottom_1 {
            opacity: 1;
            transition: all 0.5s;
        }
    </style>
  <div class="backstage-blocksEditor-wrap block34824" data-block-uuid="prodlist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect" 
  data-block-type="phoenix_blocks_groupProduct" 
  data-default-setting= >
    
    <style>
      [data-new-auto-uuid="${pageNodeId!''}"] {
        --color-match-setting1: var(--ld-main1,#2EAAA8);
        --color-match-setting2: var(--ld-Auxiliary1,#313333);
      }
    </style>
    <div class="Box">
        <div class="prodCategoty-with-submenu">
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
                            subGroups
                            groupPhotoUrlList
                            showFieldList
                        }
                    }']
                    <div class="hidden-scrollBar swiper-container" id="block_35284_swiper_1">
                        [#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
                            <ul class="r-tabs-nav fix">
                                [#list data.productGroupList as group] 
                                <li class="r-tabs-tab ">
                                    <a class="img" href="${group.groupUrl!''}" title="${group.groupName!?html}"><span></span></a>
                                    <div class="imgbox">
                                        <img class="catepic" src="${group.groupPhotoUrlList[0]}" alt="${group.groupName!''}">
                                    </div>
                                    <div class="r-tabs-anchor heading5" title="${group.groupName!''}" href="${group.groupUrl!'javascript:void(0)'}">${group.groupName!''}</div>
                                    <div class="link_item"></div>
                                </li>
                                [/#list]
                            </ul>
                        [/#if]
                        <div class="link_list"></div>
                    </div>
                    <div class="BoxBottom">
                        <div class="tab-container container-ScrollBar swiper-container swiper-no-swiping" id="block_35284_swiper_2">
                            <div class="tab_list swiper-wrapper">
                                [#if data?? && data.productGroupList??]
                                    [#list data.productGroupList as group] 
                                        [#if group.subGroups??] [#-- 二级菜单 --]
                                        <div class="tab-container-inner swiper-slide">
                                            <ul class="sitewidget-prodTabList-cont fix">
                                                [#list group.subGroups as subGroup]
                                                <li class="item">
                                                    <div class="prodTabList-wrapper">
                                                        <div class="tabList-wrapper-inner">
                                                            <div class="prodTabList-cell">
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
                                                                [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                                                                [#list data.productList.list as product]
                                                                    <img class="catepic" src="${product.photoUrlList[0]!}" alt="${product.photoSeoList[0].photoAlt!}" title="${product.photoSeoList[0].photoTitle!}">
                                                                [/#list]
                                                                [/#if] 
                                                                [/@api]
                                                            </div>
                                                        </div>
                                                        <h3 class="Textword heading5" href="${subGroup.groupUrl}" title="${subGroup.groupName!?html}">${subGroup.groupName!?html}</h3>
                                                    </div>
                                                    <a  href="${subGroup.groupUrl}" title="${subGroup.groupName!?html}"></a>
                                                </li>
                                                [/#list]
                                            </ul>
                                            </div>
                                        [#else]
                                            <div class="tab-container-inner swiper-slide">[@s.m "phoenix_no_content" /]</div>
                                        [/#if]
                                    [/#list]
                                [/#if]
                            </div>
                        </div>
                    </div>
                    <div class="block_35284_BoxBottom_1">
                        <div class="tab-container container-ScrollBar">
                            <div class="tab_list">
                                [#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
                                [#list data.productGroupList as group] 
                                    [#if group.subGroups??] [#-- 二级菜单 --]
                                        <div class="tab-container-inner">
                                            <div class="bottomList swiper-container">
                                                <ul class="sitewidget-prodTabList-cont fix swiper-wrapper">
                                                    [#list group.subGroups as subGroup]
                                                    <li class="item swiper-slide">
                                                        <div class="prodTabList-wrapper">
                                                            <div class="tabList-wrapper-inner">
                                                                <div class="prodTabList-cell">
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
                                                                            }
                                                                        }
                                                                    }']
                                                                        [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                                                                        [#list data.productList.list as product]
                                                                            <img class="catepic" src="${product.photoUrlList[0]!}">
                                                                        [/#list]
                                                                        [/#if] 
                                                                    [/@api]
                                                                </div>
                                                            </div>
                                                            <div class="Textword heading5" href="${subGroup.groupUrl}" title="${subGroup.groupName!?html}">${subGroup.groupName!?html}</div>
                                                        </div>
                                                        <a href="${subGroup.groupUrl}" title="${subGroup.groupName!?html}"></a>
                                                    </li>
                                                    [/#list]
                                                </ul>
                                                <div class="swiper-pagination"></div>
                                            </div>
                                        </div>
                                    [#else]
                                        <div class="tab-container-inner">[@s.m "phoenix_no_content" /]</div>
                                    [/#if]
                            
                                [/#list]
                                [#else]
                                    <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                                [/#if]
                            </div>
                        </div>
                    </div>
                    <script>
                    $(function () {
                        window._block_namespaces_['block34824'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}','pageNodeId': '${pageNodeId!""}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
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
</div>