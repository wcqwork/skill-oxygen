<div class="backstage-blocksEditor-wrap wra block_77452" data-block-uuid="siteMap"  data-gjs-type="developer-node-component" data-block-type="phoenix_blocks_siteMap" data-default-setting={}>
      [@api method="post" version="v2" url="/phoenix2/composite/graphql" extraParamJson="${extraParamJson!''}" 
      query='{
          SiteMapList(extraParamJson: "$extraParamJson$") {
            navigates
            productGroups
            articleGroups
          }
        }']
      
      <div class="block-listTemp-container-replace">
        <p class="map-title heading3">[@s.m "PHOENIX2_SITE_MAP" /]</p>
        [#if data.SiteMapList.navigates?? && data.SiteMapList.navigates?size > 0]
          <div class="map-name heading5"> <span>[@s.m "PHOENIX2_PAGE_NAVIGATES" /]</span></div>
          <ul class="map-box paragraph1">
            [#list data.SiteMapList.navigates as level1]
              <li>
                <a href="${level1.showUrl}" title="${level1.showName!?html}"><span class="circle"></span>${level1.showName!?html}</a>
                [#if level1.subs??]
                  <ul class>
                  [#list level1.subs as level2]
                    <li>
                      <a href="${level2.showUrl}" title="${level2.showName!?html}">${level2.showName!?html}</a>
                      [#if level2.subs??]
                        <ul>
                          [#list level2.subs as level3]
                          <li><a href="${level3.showUrl}" title="${level3.showName!?html}">${level3.showName!?html}</a></li>
                          [/#list]
                        </ul>
                      [/#if]
                    </li>				
                  [/#list]
                  </ul>
                [/#if]
              </li>				
              [/#list]
          </ul>
        [/#if]

        [#if data.SiteMapList.productGroups?? && data.SiteMapList.productGroups?size>0]
		    <div class="map-name heading5"><span >[@s.m "PHOENIX2_PRODUCTGROUPS" /]</span></div>
          <ul class="map-box paragraph1">
            [#list data.SiteMapList.productGroups as level1]
              <li>
                <a href="${level1.showUrl}" title="${level1.showName!?html}"><span class="circle"></span>${level1.showName!?html}</a>
                [#if level1.subs??]
                  <ul>
                    [#list level1.subs as level2]
                    <li>
                      <a href="${level2.showUrl}" title="${level2.showName!?html}">${level2.showName!?html}</a>
                      [#if level2.subs??]
                        <ul>
                          [#list level2.subs as level3]
                          <li>
                            <a href="${level3.showUrl}" title="${level3.showName!?html}">${level3.showName!?html}</a>
                            [#if level3.subs??]
                              <ul>
                                [#list level3.subs as level4]
                                <li>
                                  <a href="${level4.showUrl}" title="${level4.showName!?html}">${level4.showName!?html}</a>
                                  [#if level4.subs??]
                                    <ul>
                                      [#list level4.subs as level5]
                                      <li>
                                        <a href="${level5.showUrl}" title="${level5.showName!?html}">${level5.showName!?html}</a>
                                      </li>
                                      [/#list]
                                    </ul>
                                  [/#if]															
                                </li>
                                [/#list]
                              </ul>
                            [/#if]
                          </li>
                          [/#list]
                        </ul>
                      [/#if]
                    </li>				
                    [/#list]
                  </ul>
                [/#if]
              </li>				
            [/#list]
          </ul>
        [/#if]

        [#if data.SiteMapList.articleGroups?? && data.SiteMapList.articleGroups?size>0]
          <div class="map-name heading5"><span>[@s.m "PHOENIX2_ARTICLEGROUPS" /]</span> </div>
          <ul class="map-box paragraph1">
            [#list data.SiteMapList.articleGroups as level1]
            <li>
              <a href="${level1.showUrl}" title="${level1.showName!?html}"><span class="circle"></span>${level1.showName!?html}</a>
              [#if level1.subs??]
                <ul>
                  [#list level1.subs as level2]
                  <li>
                    <a href="${level2.showUrl}" title="${level2.showName!?html}">${level2.showName!?html}</a>
                    [#if level2.subs??]
                      <ul>
                        [#list level2.subs as level3]
                        <li><a href="${level3.showUrl}" title="${level3.showName!?html}">${level3.showName!?html}</a></li>
                        [/#list]
                      </ul>
                    [/#if]
                  </li>				
                  [/#list]
                </ul>
              [/#if]
            </li>				
            [/#list]
          </ul>
        [/#if]

      </div>
      
    <script>
        $(function(){
            window._block_namespaces_['siteMap_77452'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'siteMap_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
        });
    </script>
[/@api]
  
</div>