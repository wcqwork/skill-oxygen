<div class="backstage-blocksEditor-wrap wra block-27492" data-block-uuid="aaa"  data-gjs-type="developer-node-component" data-block-type="phoenix_blocks_groupArticle" data-default-setting={"selectGroupIds":[],"jumpMethod":"0","expandIds":{"showField":{"label":null,"key":"showField","draggable":false,"data":[{"fieldName":"分类图片","fieldId":"groupPhotoUrlList","fieldType":"0","value":"1","checked":true},{"fieldName":"分类名称","fieldId":"groupName","fieldType":"0","value":"2","checked":true}]}},"layoutStyle":"0"}>
		[@api method="post" url="/phoenix2/composite/graphql" jumpMethod="${jumpMethod!'0'}"
			selectGroupIds="${selectGroupIds!''}"
			expandIds="${expandIds!''}"
			query='{
				 articleCateList(selectGroupIds: $selectGroupIds, optionsParam: $optionsParam) {
                    encodeId
                    cateName
                    parentCateId
                    cateUrl
                    subArticles
                    showFieldList
					$showField
				}
			}']
		
		<ul class="block-article-group-list-27492">
			[#if data?? && data.articleCateList?? && (data.articleCateList?size > 0)]
				[#list data.articleCateList as group]
				<li class="grouplist-li-1 [#if layoutStyle == '1']columns-4[/#if]">
					[#if group.showFieldList??]
						[#list group.showFieldList as field]
							[#if field.fieldId?? && field.fieldId =="groupPhotoUrlList"]
								<a class="position" href="${group.cateUrl!''}">
									<div class="img">
										<img src="${group.groupPhotoUrlList[0]}">
									</div>
								</a>
							[/#if]
							[#if field.fieldId?? && field.fieldId =="groupName"]
								<div class="group-box position">
									<div class="one-classify cateName [#if infoGroupId?? && infoGroupId == group.parentCateId ]current[/#if]">
										<span class="one-a">
											<a class="heading5" href="${group.cateUrl!''}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" title="${group.cateName!?html}">${group.cateName!?html}</a>
										</span>
									</div>
									[#-- 二级菜单 --]
									[#if group.subArticles?? && group.subArticles?has_content]
										<ul class="two-classify">
										[#list group.subArticles as secondGroup]
											<li class="grouplist-li-two">
												<span class="drop cateName paragraph1 [#if infoGroupId?? && infoGroupId == secondGroup.parentCateId ]current[/#if]">
													<svg xmlns="http://www.w3.org/2000/svg" width="4" height="4" viewBox="0 0 4 4" fill="none">
														<circle cx="2" cy="2" r="2" fill=""/>
													</svg>
													<a href="${secondGroup.cateUrl!''}" class="paragraph1" title="${secondGroup.cateName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" >${secondGroup.cateName!?html}</a>
												</span>
												[#-- 三级菜单 --]
												[#if secondGroup.subArticles??]	
													<ul class="three-classify">
														[#list secondGroup.subArticles as thirdGroup]
															<li class="grouplist-li-three">
																<a class="cateName paragraph1 [#if infoGroupId?? && infoGroupId == thirdGroup.parentCateId ]current[/#if]" href="${thirdGroup.cateUrl!''}" title="${thirdGroup.cateName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">${thirdGroup.cateName!?html}</a>
																[#-- 四级菜单 --]
																[#if thirdGroup.subArticles??]	
																	<ul class="four-classify">
																		[#list thirdGroup.subArticles as forthGroup]
																			<li class="grouplist-li-three">
																				<a class="cateName paragraph1 [#if infoGroupId?? && infoGroupId == forthGroup.parentCateId ]current[/#if]" href="${forthGroup.cateUrl!''}" title="${forthGroup.cateName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">${forthGroup.cateName!?html}</a>
																				[#-- 五级菜单 --]
																				[#if forthGroup.subArticles??]	
																					<ul class="five-classify">
																						[#list forthGroup.subArticles as fifthGroup]
																							<li class="grouplist-li-three">
																								<a class="cateName paragraph1 [#if infoGroupId?? && infoGroupId == fifthGroup.parentCateId ]current[/#if]" href="${fifthGroup.cateUrl!''}" title="${fifthGroup.cateName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">${fifthGroup.cateName!?html}</a>
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
				window._block_namespaces_['articlelist_group27492'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'aaa_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
			});
		</script>
		
	[/@api]
		
	</div>