<div class="backstage-blocksEditor-wrap wra block_77489" data-block-uuid="headerSearch"  data-gjs-type="developer-node-component"  data-block-type="phoenix_element_dynamicComponents" data-default-setting={}>
    [#if componentSetting?? && componentSetting != ""]
        [#assign componentSettingJSON=componentSetting?eval /]
    [/#if]

    [#if componentSettingJSON?? && componentSettingJSON.prodDynamicSetting??]
        [#if componentSettingJSON.prodDynamicSetting[0].blockSetting.searchIconClass?? && componentSettingJSON.prodDynamicSetting[0].blockSetting.searchIconClass != '']
            [#assign icon_class = componentSettingJSON.prodDynamicSetting[0].blockSetting.searchIconClass]
        [/#if]
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
        <div class="header-search">
            <button class="search-icon-btn">
                <i class="search-icon icon ${icon_class!'iconfont_phoenix icon-sousuo-2'}"></i>
            </button>
            <div class="header-search-form">
                <form action="/phoenix/admin/siteSearch/search/v2" class="search-box"  method="get" novalidate>
                    <div class="search-input">
                        <input class="input-text" type="text" name="searchValue" value="${searchValue!''}" placeholder="${dataPlaceholder!''}" autocomplete="off"/>

                        <input type="hidden" name="searchScope" value="${dataExpandIdsArr!'1,2,3,4,5,7,9'}" />
                        <input type="hidden" name="searchType" value="${dataTypeAlt!'1'}" />
                        <input type="hidden" name="searchMethod" value="${dataModeAlt!'1'}" />

                        <input type="hidden" name="linkageRelationId" value="${relationId!''}" />
                        <input type="hidden" name="linkageRelationType" value="${relationType!''}" />
                        <input type="hidden" name="linkagePageId" value="${pageId!''}" />
                        <input type="hidden" name="linkagePageNodeId" value="${nodeId!''}" />
                    </div>
                    <button class="search-btn" type="submit">
                        <i class="search-icon icon ${icon_class!'iconfont_phoenix icon-sousuo-2'}"></i>
                    </button>
                    <div class="close-icon">
                        <i class="search-icon icon iconfont_phoenix icon-cha-2"></i>
                    </div>
                </form>
            </div>
        </div>
    <script>
        $(function(){
            window._block_namespaces_['block_77489'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'headerSearch_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
        });
    </script> 
</div>