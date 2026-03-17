<div class="backstage-blocksEditor-wrap wra block-39534" data-block-uuid="groupVideo"  data-gjs-type="developer-node-component" data-show-helperel="1" data-dynamic-toolbar="1" data-block-type="phoenix_blocks_videoGroup_new" data-default-setting={"dataType":"0","dataGroupId":[],"jumpMethod":"0","translationEntry":[]}>
  [#assign pcDefaultStyle = 'allExpand']
  [#assign padDefaultStyle = 'allExpand']
  [#assign phoneDefaultStyle = 'allExpand']
  [#assign closeWay = 'open']
  [#assign expandIconClass = 'iconfont_phoenix icon-angle-up']
  [#assign collapseIconClass = 'iconfont_phoenix icon-angle-down']
  [#assign htmlClass_firstFont = '']
  [#assign htmlClass_secondFont = '']
  [#assign addBlockKeyClass = '']


  [#if componentSetting?? && componentSetting != ""]
      [#assign componentSettingJSON=componentSetting?eval /]
      [#if componentSettingJSON?? && componentSettingJSON.dynamicFontTab??]
          [#list componentSettingJSON.dynamicFontTab as item]
              [#list item.saveData as saveDataItem]
                  [#if saveDataItem.styleKey?? && saveDataItem.styleKey == 'currentFontStyleClass']
                      [#if item.value?? && item.value == 'groupNameFont']
                          [#assign htmlClass_firstFont = saveDataItem.defaultFont /]                            
                      [/#if] 
                      [#if item.value?? && item.value == 'groupSecondFont']
                          [#assign htmlClass_secondFont = saveDataItem.defaultFont /]                            
                      [/#if] 
                  [/#if]
                  [#if saveDataItem.styleKey?? && saveDataItem.styleKey == 'addBlockKeyClass']
                      [#if saveDataItem.defaultFont?? &&  saveDataItem.defaultFont != '']
                          [#assign addBlockKeyClass = saveDataItem.defaultFont /]                            
                      [/#if] 
                  [/#if]
              [/#list]
          [/#list]
      [/#if]


      [#if componentSettingJSON?? && componentSettingJSON.prodDynamicSetting??]
          [#if componentSettingJSON.prodDynamicSetting[0].blockSetting??]
              [#if componentSettingJSON.prodDynamicSetting[0].blockSetting.defaultStyleObj.desktop??]
                  [#assign pcDefaultStyle = componentSettingJSON.prodDynamicSetting[0].blockSetting.defaultStyleObj.desktop]
                  [#assign padDefaultStyle = 'pad_' + componentSettingJSON.prodDynamicSetting[0].blockSetting.defaultStyleObj.desktop]
                  [#assign phoneDefaultStyle = 'phone_' + componentSettingJSON.prodDynamicSetting[0].blockSetting.defaultStyleObj.desktop]

                  [#if componentSettingJSON.prodDynamicSetting[0].blockSetting.defaultStyleObj.tablet??]
                      [#assign padDefaultStyle = 'pad_' + componentSettingJSON.prodDynamicSetting[0].blockSetting.defaultStyleObj.tablet]
                      [#assign phoneDefaultStyle = 'phone_' + componentSettingJSON.prodDynamicSetting[0].blockSetting.defaultStyleObj.tablet]
                  [/#if]
                  [#if componentSettingJSON.prodDynamicSetting[0].blockSetting.defaultStyleObj.mobilePortrait??]
                      [#assign phoneDefaultStyle = 'phone_' + componentSettingJSON.prodDynamicSetting[0].blockSetting.defaultStyleObj.mobilePortrait]
                  [/#if]
              [/#if]

              [#if componentSettingJSON.prodDynamicSetting[0].blockSetting.itemIconClass??]
                  [#assign itemIconClass = componentSettingJSON.prodDynamicSetting[0].blockSetting.itemIconClass]
              [/#if]

              [#if componentSettingJSON.prodDynamicSetting[0].blockSetting.closeWay??]
                  [#assign closeWay = componentSettingJSON.prodDynamicSetting[0].blockSetting.closeWay]
              [/#if]
          [/#if]

          [#if componentSettingJSON.prodDynamicSetting[1].blockSetting??]
              [#if componentSettingJSON.prodDynamicSetting[1].blockSetting.expandIconClass != '']
                  [#assign expandIconClass = componentSettingJSON.prodDynamicSetting[1].blockSetting.expandIconClass]
              [/#if]
              [#if componentSettingJSON.prodDynamicSetting[1].blockSetting.collapseIconClass != '']
                  [#assign collapseIconClass = componentSettingJSON.prodDynamicSetting[1].blockSetting.collapseIconClass]
              [/#if]
          [/#if]
      [/#if]
  [/#if]
  
  [#assign newGroupIds="" /]
  [#if dataType?? && dataType == '0']
      [#assign newGroupIds = "[]" /]
  [#else]
      [#assign newGroupIds = dataGroupId /]
  [/#if]
      [@api method="post" url="/phoenix2/composite/graphql" page="${page!1}" limit="${pageSize!'10'}" dataType="${dataType!'0'}" searchVideoCateIds="${newGroupIds!''}" jumpMethod="${jumpMethod!'0'}"
    query='{
              videoGroupList(selectGroupIds:$searchVideoCateIds) {
                  videoGroupId
                  encodeId
                  groupName
                  groupDescription
                  parentGroupId
                  subGroups
                  groupUrl
              }
          }']
          <ul class="block-product-group-list block-common-group-list ${pcDefaultStyle} ${padDefaultStyle} ${phoneDefaultStyle} ${addBlockKeyClass} 22222222222222" data-closeway="${closeWay}">
              <!-- 特殊标识 用于后台保存样式 -->
              <div class="group-item-li current" style="display: none;">
                  <input type="hidden" class="classify-flex" />
              </div> 
              [#if data?? && data.videoGroupList?? && (data.videoGroupList?size > 0)]
                  [#list data.videoGroupList as group]
                      <li class="group-item-li grouplist-li-first [#if videoGroupId?? && videoGroupId == group.videoGroupId ]current[/#if]" data-pid="${group.encodeId}">
                          <div class="classify-flex [#if group.subGroups??]hasChild[/#if] group_classify_${htmlClass_firstFont!''}">
                              <span class="classify-flex-span">
                                  <a class="groupName ${htmlClass_firstFont!''}" href="${group.groupUrl!''}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" title="${group.groupName!?html}">${group.groupName!?html}</a>
                              </span>
                              [#if group.subGroups??]
                                  <span class="drop-down">
                                      <i class="expand_icon ${expandIconClass!'iconfont_phoenix icon-angle-up'}"></i>
                                      <i class="collapse_icon ${collapseIconClass!'iconfont_phoenix icon-angle-down'}"></i>
                                  </span>
                              [/#if]
                          </div>
                          <div class="group-item-divider"></div>
                          [#-- 二级菜单 --]
                          [#if group.subGroups?? && group.subGroups?has_content]
                              <ul class="two-classify classify-item">
                              [#list group.subGroups as secondGroup]
                                  <li class="grouplist-li-two group-item-li grouplist-li-other [#if videoGroupId?? && videoGroupId == secondGroup.videoGroupId ]current[/#if]">
                                       <div class="classify-flex [#if secondGroup.subGroups??]hasChild[/#if]  group_classify_${htmlClass_secondFont!''}">
                                          <span class="classify-flex-span">
                                              [#if itemIconClass?? && itemIconClass != '']
                                                  <span><i class="${itemIconClass}"></i></span>
                                              [/#if]
                                              <a class="groupName ${htmlClass_secondFont!''}" href="${secondGroup.groupUrl!''}" title="${secondGroup.groupName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" >${secondGroup.groupName!?html}</a>
                                          </span>
                                          [#if secondGroup.subGroups??]
                                              <span class="drop-down">
                                                  <i class="expand_icon ${expandIconClass!'iconfont_phoenix icon-angle-up'}"></i>
                                                  <i class="collapse_icon ${collapseIconClass!'iconfont_phoenix icon-angle-down'}"></i>
                                              </span>
                                          [/#if]
                                      </div>
                                      <div class="group-item-divider"></div>
                                      [#-- 三级菜单 --]
                                      [#if secondGroup.subGroups??]	
                                          <ul class="three-classify classify-item">
                                              [#list secondGroup.subGroups as thirdGroup]
                                                  <li class="grouplist-li-three group-item-li grouplist-li-other [#if videoGroupId?? && videoGroupId == thirdGroup.videoGroupId ]current[/#if]">
                                                      <div class="classify-flex group_classify_${htmlClass_secondFont!''}">
                                                          <span class="classify-flex-span">
                                                              [#if itemIconClass?? && itemIconClass != '']
                                                                  <span><i class="${itemIconClass}"></i></span>
                                                              [/#if]
                                                              <a class="groupName ${htmlClass_secondFont!''} " href="${thirdGroup.groupUrl!''}" title="${thirdGroup.groupName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">${thirdGroup.groupName!?html}</a>
                                                          </span>
                                                      </div>
                                                      <div class="group-item-divider"></div>
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
              [#else]
                  <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
              [/#if]
          </ul>
         
        <script>
              $(function(){
                  window._block_namespaces_['videoGroup39534'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'groupVideo_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
              });
          </script>
[/@api]
      
</div>