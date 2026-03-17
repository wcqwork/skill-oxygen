<div class="backstage-blocksEditor-wrap wra block_77445" data-block-uuid="videoGroup"  data-gjs-type="developer-node-component"  data-block-type="phoenix_blocks_videoGroup" data-default-setting={"dataType":"0","dataGroupId":[],"jumpMethod":"0","translationEntry":[]}>
    [#assign newGroupIds="" /]
    [#if dataType?? && dataType == '0']
        [#assign newGroupIds = "[]" /]
    [#else]
        [#assign newGroupIds = dataGroupId /]
    [/#if]
        [@api method="post" url="/phoenix2/composite/graphql" page="${page!1}" limit="${pageSize!'10'}" dataType="${dataType!'0'}" searchVideoCateIds="${newGroupIds!''}" jumpMethod="${jumpMethod!'0'}"
			query='{
                videoGroupList(selectGroupIds:$searchVideoCateIds) {
                    encodeId
                    groupName
                    groupDescription
                    parentGroupId
                    subGroups
                    groupUrl
                }
            }']
            <div class="block-videoGroup-container-replace ">
                <ul class="video-box">
                    [#if data?? && data.videoGroupList?? && (data.videoGroupList?size > 0)]
                        [#list data.videoGroupList as group]
                            <li class="grouplist-li-1" data-pid="${group.encodeId}">
                                <div class="one-classify groupName [#if infoGroupId?? && infoGroupId == group.encodeId ]current[/#if]">
                                    <span class="one-a">
                                        <a class="heading5" href="${group.groupUrl!''}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" title="${group.groupName!?html}">${group.groupName!?html}</a>
                                    </span>
                                    [#if group.subGroups??]
                                        <span class="drop-down">
                                           <i class="iconfont iconfont_phoenix icon-angle-down"></i>
                                        </span>
                                    [/#if]
                                </div>
                                [#-- 二级菜单 --]
                                [#if group.subGroups?? && group.subGroups?has_content]
                                    <ul class="two-classify">
                                    [#list group.subGroups as secondGroup]
                                        <li class="grouplist-li-two">
                                            <span class="drop groupName [#if infoGroupId?? && infoGroupId == secondGroup.cateId ]current[/#if]">
                                                <i class="paragraph1 iconfont iconfont_phoenix icon-dian-1"></i>
                                                <a class="paragraph1" href="${secondGroup.groupUrl!''}" title="${secondGroup.groupName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" >${secondGroup.groupName!?html}</a>
                                            </span>
                                            [#-- 三级菜单 --]
                                            [#if secondGroup.subGroups??]	
                                                <ul class="three-classify">
                                                    [#list secondGroup.subGroups as thirdGroup]
                                                        <li class="grouplist-li-three">
                                                            <a class="paragraph1" class="groupName [#if infoGroupId?? && infoGroupId == thirdGroup.cateId ]current[/#if]" href="${thirdGroup.groupUrl!''}" title="${thirdGroup.groupName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">${thirdGroup.groupName!?html}</a>

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
            </div>
           
        	<script>
                $(function(){
                    window._block_namespaces_['videoGroup77445'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'videoGroup_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
            </script>
	[/@api]
        
</div>