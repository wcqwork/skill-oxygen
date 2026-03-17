<div class="backstage-blocksEditor-wrap wra block-27452" data-block-uuid="aaa"  data-gjs-type="developer-node-component" data-block-type="phoenix_blocks_groupProduct" data-default-setting={"selectGroupIds":[],"jumpMethod":"0","expandIds":{"showField":{"label":null,"key":"showField","draggable":false,"data":[{"fieldName":"分类图片","fieldId":"groupPhotoUrlList","fieldType":"0","value":"1","checked":true},{"fieldName":"分类名称","fieldId":"groupName","fieldType":"0","value":"2","checked":true}]}},"layoutStyle":"0"}>
		[@api method="post" url="/phoenix2/composite/graphql"
			selectGroupIds="${selectGroupIds!''}"
			expandIds="${expandIds!''}"
			query='{
				 productGroupList(selectGroupIds: $selectGroupIds, optionsParam: $optionsParam) {
					encodeId
					groupName
					groupUrl
					groupPhotoUrlList
					groupDescription
					parentGroupId
					subGroups
					showFieldList
					$showField
				}
			}']
		<ul class="block-product-group-list-27452">
			
			[#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
				[#list data.productGroupList as group]
				<li class="grouplist-li-1 [#if layoutStyle == '1']columns-4[/#if]" data-pid="${group.encodeId}">
					[#if group.showFieldList??]
						[#list group.showFieldList as field]
					
							[#if field.fieldId?? && field.fieldId =="groupPhotoUrlList"]	
								<a href="${group.groupUrl!''}" class="position">
									<div class="img">
										<img src="${group.groupPhotoUrlList[0]}">
									</div>
								</a>
							[/#if]
							[#if field.fieldId?? && field.fieldId =="groupName"]
							<div class="group-box position">
								<div class="one-classify groupName [#if productGroupId?? && productGroupId == group.prodGroupId ]current[/#if]">
									<span class="one-a">
										<a class="heading5" href="${group.groupUrl!''}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" title="${group.groupName!?html}">${group.groupName!?html}</a>
									</span>
								</div>
								[#-- 二级菜单 --]
								[#if group.subGroups?? && group.subGroups?has_content]
									<ul class="two-classify">
									[#list group.subGroups as secondGroup]
										<li class="grouplist-li-two">
											<span class="drop groupName [#if productGroupId?? && productGroupId == secondGroup.prodGroupId ]current[/#if]">
											
												<i class="paragraph1 iconfont iconfont_phoenix icon-dian-1"></i>
												<a class="paragraph1" href="${secondGroup.groupUrl!''}" title="${secondGroup.groupName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" >${secondGroup.groupName!?html}</a>
											</span>
											[#-- 三级菜单 --]
											[#if secondGroup.subGroups??]	
												<ul class="three-classify">
													[#list secondGroup.subGroups as thirdGroup]
														<li class="grouplist-li-three">
															<a class="groupName paragraph1 [#if productGroupId?? && productGroupId == thirdGroup.prodGroupId ]current[/#if]" href="${thirdGroup.groupUrl!''}" title="${thirdGroup.groupName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">${thirdGroup.groupName!?html}</a>
															[#-- 四级菜单 --]
															[#if thirdGroup.subGroups??]	
																<ul class="four-classify">
																	[#list thirdGroup.subGroups as forthGroup]
																		<li class="grouplist-li-three">
																			<a class="groupName paragraph1 [#if productGroupId?? && productGroupId == forthGroup.prodGroupId ]current[/#if]" href="${forthGroup.groupUrl!''}" title="${forthGroup.groupName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">${forthGroup.groupName!?html}</a>
																			[#-- 五级菜单 --]
																			[#if forthGroup.subGroups??]	
																				<ul class="five-classify">
																					[#list forthGroup.subGroups as fifthGroup]
																						<li class="grouplist-li-three">
																							<a class="groupName paragraph1 [#if productGroupId?? && productGroupId == fifthGroup.prodGroupId ]current[/#if]" href="${fifthGroup.groupUrl!''}" title="${fifthGroup.groupName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">${fifthGroup.groupName!?html}</a>
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
							</div>
							[/#if]
						[/#list]
					[/#if]
				</li>
				[/#list]
			[#else]
				<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
			[/#if]
		</ul>
		<script> 
			$(function(){
				window._block_namespaces_['grouplist_editor'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'aaa_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
			});
		</script>
	[/@api]
	</div>