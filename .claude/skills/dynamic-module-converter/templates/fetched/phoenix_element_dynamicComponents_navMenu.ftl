<div class="backstage-blocksEditor-wrap wra block_7748399" data-block-uuid="navMenu" data-gjs-type="developer-node-component" data-block-type="phoenix_element_dynamicComponents" data-default-setting={"componentSetting":{},"customUrlList":[],"navbarNodeStr":[]}>
  [@api method="post" url="/phoenix2/composite/graphql" navbarNodeStr="${navbarNodeStr!''}" extraParamJson="${extraParamJson!''}"
    query='{
      searchNavbarList(navbarDto: {navbarNodeStr:$navbarNodeStr,extraParamJson:$extraParamJson}) 
      {
        scheme
        domainRecord
        urlDetail
      }
  }']
    [#assign navAlign="column" /]
    [#if componentSetting?? && componentSetting != ""]
        [#assign componentSettingJSON=componentSetting?eval /]
    [/#if]
    [#if componentSettingJSON?? && componentSettingJSON.prodDynamicSetting??]
        [#assign navAlign = componentSettingJSON.prodDynamicSetting[0].blockSetting.navAlign /]
    [/#if]

    
    [#if data?? && data.searchNavbarList?? && data.searchNavbarList.urlDetail??]
      [#assign urlDetailJSON=data.searchNavbarList.urlDetail?eval /]
      <div class="nav-Container navAlign_${navAlign}">
        <div class="nav-main-pc">
          <div class="button-prev">
            <i class="icon icon iconfont_phoenix icon-jiantouyou-5 lead_icon"> </i>
          </div>
          <nav class="lea-nav-menu--main lea-nav-menu__container lea-nav-menu--layout-horizontal">
            [#macro menuTree menus depth]
              [#if menus?? && menus?size gt 0]
                <ul class="lea-nav-menu lea-navMenu-depth${depth}">
                  <li class="hide">
                    <a class="lea-menu-item current_nav_active"></a>
                  </li>
                  [#list menus as menu]
                    [#assign navDetail = urlDetailJSON["${menu.encodeRelationId}_${menu.relationType}"] /]
                    [#assign isHasChildren = menu.children?? && menu.children?size gt 0 /]
                    <li class="menu-item menu-item-level${menu_index}">
                      [#assign ishasnofollow =  ''/]
                      [#if menu.isNofollow?? && menu.isNofollow != ""]
                        [#assign ishasnofollow =  'nofollow'/]
                      [/#if]
                      [#assign ishasopennew =  '' /]
                      [#if menu.isOpenNew?? && menu.isOpenNew != ""]
                        [#assign ishasopennew =  '_blank' /]
                      [#else]
                        [#assign ishasopennew =  '_self' /]
                      [/#if]

                      [#assign currentNavActive =  "" /]
                      [#if navDetail.active?? && navDetail.active == "1"]
                        [#assign currentNavActive =  "current_nav_active" /]
                      [#elseif navDetail.active?? && navDetail.active == "0"]
                        [#assign currentNavActive =  "" /]
                      [/#if]
                      <a href="${navDetail.url}" class="lea-menu-item menu-link ${currentNavActive!''}" rel="${ishasnofollow!''}" target="${ishasopennew!''}">
                        <!-- 自定义图片 -->
                        [#if menu.imageUrl?? && menu.imageUrl != ""]
                          <img src="${menu.imageUrl}" />
                        [/#if]
                        <!-- 自定义图标 -->
                        [#if menu.iconClass?? && menu.iconClass != ""]
                          <i class="icon ${menu.iconClass}"></i>
                        [/#if]
                        <span class="navTitle">${menu.navTitle!""}</span>
                        [#if isHasChildren]
                          <!-- 导航图标 -->
                          <span class="sub-arrow">
                            <i class="icon icon iconfont_phoenix icon-jiantouyou-5 lead_icon"></i>
                          </span>
                        [/#if]
                      </a>
                      [#if isHasChildren]
                        [@menuTree menus=menu.children depth=(depth + 1) /]
                      [/#if]
                    </li>
                  [/#list]
                </ul>
              [/#if]
            [/#macro]
            
            [#if navbarNodeStr?? && navbarNodeStr != ""]
              [#assign setting_param = navbarNodeStr?eval /]
              [@menuTree menus=setting_param depth=0 /]
            [/#if]
          </nav>
          <div class="button-next">
            <i class="icon icon iconfont_phoenix icon-jiantouyou-5 lead_icon"> </i>
          </div>
        </div>
        <div class="nav-iphone-menucontainer">
          <div class="nav-iphone-Openmenu">
            <svg t="1641436524841" class="icon" style="vertical-align: middle;" viewBox="0 0 1325 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="5256" width="18" height="18"><path d="M1325.176471 843.294118v180.705882H0v-180.705882h1325.176471z m0-421.647059v180.705882H0V421.647059h1325.176471z m0-421.647059v180.705882H0V0h1325.176471z" p-id="5257"></path></svg>
          </div>
          <div class="nav-iphone-closeMenu">
            <svg t="1641436687989" class="icon" style="vertical-align: middle;" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="5628" width="18" height="18"><path d="M95.573333 1024l417.28-416.597333 415.573334 414.72L1024 926.72 608.512 512 1024 97.28 928.426667 1.877333l-415.573334 414.72L95.573333 0 0 95.402667 417.28 512 0 928.597333z" p-id="5629"></path></svg>
          </div>
        </div>
      </div>
    [#else]
      [@web_backend]
        Please select the navigation bar to display the data
      [/@web_backend]
    [/#if]
    <script> 
      $(function(){
        window._block_namespaces_['navMenu77483'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','pageNodeId':'${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
      });
    </script>
  [/@api]
</div>