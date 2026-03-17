<div class="backstage-blocksEditor-wrap wra block_77444" data-block-uuid="downloadGroup"  data-gjs-type="developer-node-component"  data-block-type="phoenix_blocks_downloadGroup" data-default-setting={}>
        [@api method="post" url="/phoenix2/composite/graphql" page="${page!1}" limit="${pageSize!'10'}" dataType="${dataType!'0'}" cateId="${downloadCateId!''}" searchDownloadCateIds="${dataGroupId!''}" jumpMethod="${jumpMethod!'0'}"
			query='{
                downloadCateList(selectGroupIds: $searchDownloadCateIds) {
                    encodeId
                    cateId
                    cateName
                    parentCateId
                    subCates
                    cateUrl
                }
            }']
            <div class="block-downloadGroup-container-replace ">
                <ul class="download-box">
                    [#if data?? && data.downloadCateList?? && (data.downloadCateList?size > 0)]
                        [#list data.downloadCateList as group]
                            <li class="grouplist-li-1" data-pid="${group.encodeId}">
                                <div class="one-classify cateName [#if downloadCateId?? && group.cateId?? && downloadCateId == group.cateId ]current[/#if]">
                                    <span class="one-a">
                                        <a class="heading5" href="${group.cateUrl!''}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" title="${group.cateName!?html}">${group.cateName!?html}</a>
                                    </span>
                                    [#if group.subCates??]
                                        <span class="drop-down">
                                           <i class="iconfont iconfont_phoenix icon-angle-down"></i>
                                        </span>
                                    [/#if]
                                </div>
                                [#-- 二级菜单 --]
                                [#if group.subCates?? && group.subCates?has_content]
                                    <ul class="two-classify">
                                    [#list group.subCates as secondGroup]
                                        <li class="grouplist-li-two">
                                            <span class="drop cateName [#if downloadCateId?? && secondGroup.cateId?? && downloadCateId == secondGroup.cateId ]current[/#if]">
                                                <i class="paragraph1 iconfont iconfont_phoenix icon-dian-1"></i>
                                                <a class="paragraph1" href="${secondGroup.cateUrl!''}" title="${secondGroup.cateName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" >${secondGroup.cateName!?html}</a>
                                            </span>
                                            [#-- 三级菜单 --]
                                            [#if secondGroup.subCates??]	
                                                <ul class="three-classify">
                                                    [#list secondGroup.subCates as thirdGroup]
                                                        <li class="grouplist-li-three">
                                                            <a class="cateName paragraph1 [#if downloadCateId?? && thirdGroup.cateId?? && downloadCateId == thirdGroup.cateId ]current[/#if]" href="${thirdGroup.cateUrl!''}" title="${thirdGroup.cateName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">${thirdGroup.cateName!?html}</a>

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
                    window._block_namespaces_['downloadGroup77444'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'downloadGroup_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
            </script>
	[/@api]
        
</div>