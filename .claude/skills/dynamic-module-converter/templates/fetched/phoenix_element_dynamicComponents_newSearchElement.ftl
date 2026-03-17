<div class="backstage-blocksEditor-wrap wra block_77581" data-block-uuid="newSearchElement"  data-gjs-type="developer-node-component"  data-block-type="phoenix_element_dynamicComponents" data-default-setting={}>
    [#if componentSetting?? && componentSetting != ""]
        [#assign componentSettingJSON=componentSetting?eval /]
    [/#if]
    [#assign show_searchIcon = true]


    [#if componentSettingJSON?? && componentSettingJSON.prodDynamicSetting??]
        [#if componentSettingJSON.prodDynamicSetting[0].blockSetting.searchIconClass?? && componentSettingJSON.prodDynamicSetting[0].blockSetting.searchIconClass != '']
            [#assign icon_class = componentSettingJSON.prodDynamicSetting[0].blockSetting.searchIconClass]
        [/#if]

        [#if componentSettingJSON.prodDynamicSetting[1].blockSetting.searchIcon??]
            [#assign show_searchIcon = componentSettingJSON.prodDynamicSetting[1].blockSetting.searchIcon]
        [/#if]

        [#if componentSettingJSON.prodDynamicSetting[1].blockSetting.searchIcon?? && componentSettingJSON.prodDynamicSetting[1].blockSetting.searchIcon != '']
            [#assign show_searchIcon = componentSettingJSON.prodDynamicSetting[1].blockSetting.searchIcon]
        [/#if] 
        
        [#if componentSettingJSON.prodDynamicSetting[1].blockSetting.searchInputPlace?? && componentSettingJSON.prodDynamicSetting[1].blockSetting.searchInputPlace != '']
            [#assign searchInputPlace = componentSettingJSON.prodDynamicSetting[1].blockSetting.searchInputPlace]
        [/#if]
        
    [/#if]
    
    [#assign htmlClass='paragraph1' /]
    [#if componentSettingJSON?? && componentSettingJSON.dynamicFontTab??]
        [#list componentSettingJSON.dynamicFontTab[0].saveData as saveDataItem]
            [#if saveDataItem.styleKey?? && saveDataItem.styleKey == 'currentFontStyleClass']
                [#assign htmlClass=saveDataItem.defaultFont /]
            [/#if]
        [/#list]
    [/#if]


    

        [#if dataType == '0']
            [#assign dataTypeAlt = '1']
        [/#if]
        [#if dataType == '1']
            [#assign dataTypeAlt = '2']
        [/#if]

        [#if dataMode == '0']
            [#assign dataModeAlt = '1']
        [/#if]
        [#if dataMode == '1']
            [#assign dataModeAlt = '2']
        [/#if]
        <div class="header-search open">
            <!-- <button class="search-icon-btn">
                <i class="search-icon icon ${icon_class!'iconfont_phoenix icon-sousuo-2'}"></i>
            </button> -->
            <div class="header-search-form">
                <input class="active" type="hidden" />
                <form action="/phoenix/admin/siteSearch/search/v2" class="search-box"  method="get" novalidate>
                    [#if show_searchIcon != false]
                        <button class="search-btn" type="submit">
                            <i class="search-icon icon ${icon_class!'iconfont_phoenix icon-sousuo-2'}"></i>
                        </button>
                    [/#if]

                    <div class="search-input">
                        [#if searchInputPlace?? && searchInputPlace != '']
                            <input class="input-text ${htmlClass}" type="text" name="searchValue" value="${searchValue!''}" placeholder="${searchInputPlace!''}" autocomplete="off"/>
                        [#else]
                            <input class="input-text ${htmlClass}" type="text" name="searchValue" value="${searchValue!''}" placeholder='[@s.m "phoenix_product_search" /]...' autocomplete="off"/>
                        [/#if]

                        <input type="hidden" name="searchScope" value="${dataExpandIdsArr!'1,2,3,4,5,7,9'}" />
                        <input type="hidden" name="subSearchScope" value="${dataExpandSubIdsArr!''}" />
                        <input type="hidden" name="searchType" value="${dataTypeAlt!'1'}" />
                        <input type="hidden" name="searchMethod" value="${dataModeAlt!'1'}" />

                        <input type="hidden" name="linkageRelationId" value="${relationId!''}" />
                        <input type="hidden" name="linkageRelationType" value="${relationType!''}" />
                        <input type="hidden" name="linkagePageId" value="${pageId!''}" />
                        <input type="hidden" name="linkagePageNodeId" value="${nodeId!''}" />
                    </div>
                    <!-- <div class="close-icon">
                        <i class="search-icon icon iconfont_phoenix icon-cha-2"></i>
                    </div> -->
                </form>
            </div>
        </div>
    
    <script>
        $(function(){
            window._block_namespaces_['block_77581'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'headerSearch_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
        });
    </script> 
</div>