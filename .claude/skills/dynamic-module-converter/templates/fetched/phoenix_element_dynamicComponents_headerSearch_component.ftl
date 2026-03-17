<div class="headerserach_contaienr_template">
    <!-- 风格类名 -->
[#assign templateStyle_39984 = templateStyle_39984!"search_39984" /]
<div id="hf_lead_${pageNodeSettingId}_39984_headerSearch" class="backstage-blocksEditor-wrap wra ${templateStyle_39984} hasSubSearchScope" data-block-uuid="headerSearch_component"  data-gjs-type="developer-node-component"  data-block-type="phoenix_element_dynamicComponents" data-default-setting={}>
    [#if componentSetting?? && componentSetting != ""]
        [#assign componentSettingJSON=componentSetting?eval /]
    [/#if]

    [#if componentSettingJSON?? && componentSettingJSON.prodDynamicSetting??]
        [#assign icon_class = "iconfont_phoenix icon-sousuo-2" /]
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
                <div class="header-search-form-container">
                    <form action="/phoenix/admin/siteSearch/search/v2" class="search-box"  method="get" novalidate>
                        <div class="search-input">
                            [#if dataPlaceholder?? && dataPlaceholder != ""] 
                                <input class="input-text" type="text" name="searchValue" value="${searchValue!''}" placeholder="${dataPlaceholder!''}" autocomplete="off"/>
                            [#else] 
                                <input class="input-text" type="text" name="searchValue" value="${searchValue!''}" placeholder="[@s.m 'phoenix_product_search' /]..." autocomplete="off"/>
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
                        <button class="search-btn" type="submit">
                            <i class="search-icon icon ${icon_class!'iconfont_phoenix icon-sousuo-2'}"></i>
                        </button>
                    </form>
                    <div class="close-icon">
                        <i class="search-icon icon iconfont_phoenix icon-cha-2"></i>
                    </div>
                </div>
            </div>
            <div class="header-search-mask"></div>
        </div>
        [#if dataKeyWord?? && dataKeyWord == '1' && dataCode??]
            <ul class="recommended-words">
                [#assign dataCodeJSON=dataCode?eval /]
                [#list dataCodeJSON as data]
                    [#if data.value !='']
                        <li>${data.value}</li>
                    [/#if]
                [/#list]
            </ul>
        [/#if]
    
</div>
</div>