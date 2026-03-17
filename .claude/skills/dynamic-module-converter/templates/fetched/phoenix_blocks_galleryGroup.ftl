<div class="backstage-blocksEditor-wrap wra block_28722" data-block-uuid="galleryGroup"  data-gjs-type="developer-node-component"  data-block-type="phoenix_blocks_galleryGroup" data-default-setting={"dataType":"0","dataGroupId":[],"jumpMethod":"0","translationEntry":[]}>
[@api method="post" url="/phoenix2/composite/graphql" page="${page!'1'}" limit="${pageSize!'10'}"
            selectGalleryType="${dataType!'0'}" cateIds="${dataGroupId!''}" jumpMethod="${jumpMethod!''}"
			query='{
                  galleryCateList(
                      selectCateIds: $cateIds, 
                  ) 
                  {
                    encodeId
                    cateName                  
                    parentCateId			 
                    cateUrl    			 	 
                    subCates
                  }  
			}']
            <div class="block-galleryGroup-container-replace ">
                <ul class="video-box">
                    [#if data?? && data.galleryCateList?? && (data.galleryCateList?size > 0)]
                        [#list data.galleryCateList as group]
                            <li class="grouplist-li-1" data-pid="${group.encodeId}">
                                <div class="one-classify cateName [#if infoGroupId?? && infoGroupId == group.parentCateId ]current[/#if]">
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
                                            <span class="drop cateName [#if infoGroupId?? && infoGroupId == secondGroup.parentCateId ]current[/#if]">
                                               <i class="paragraph1 iconfont iconfont_phoenix icon-dian-1"></i>
                                                <a class="paragraph1" href="${secondGroup.cateUrl!''}" title="${secondGroup.cateName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" >${secondGroup.cateName!?html}</a>
                                            </span>
                                            [#-- 三级菜单 --]
                                            [#if secondGroup.subCates??]	
                                                <ul class="three-classify">
                                                    [#list secondGroup.subCates as thirdGroup]
                                                        <li class="grouplist-li-three">
                                                            <a class="paragraph1 cateName [#if infoGroupId?? && infoGroupId == thirdGroup.parentCateId ]current[/#if]" href="${thirdGroup.cateUrl!''}" title="${thirdGroup.cateName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">${thirdGroup.cateName!?html}</a>

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
                    window._block_namespaces_['galleryGroup28722'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'galleryGroup_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
            </script>
	[/@api]
        
</div>