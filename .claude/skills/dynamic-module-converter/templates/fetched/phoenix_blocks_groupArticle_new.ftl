<div class="backstage-blocksEditor-wrap wra block-39514" data-block-uuid="groupArticle"  data-show-helperel="1" data-dynamic-toolbar="1" data-gjs-type="developer-node-component" data-block-type="phoenix_blocks_groupArticle_new" data-component-type="tree" data-default-setting={"selectGroupIds":[],"jumpMethod":"0","expandIds":{"showField":{"label":null,"key":"showField","draggable":false,"data":[{"fieldName":"分类名称","fieldId":"groupName","fieldType":"0","value":"2","checked":true}]}},"layoutStyle":"0","translationEntry":[]}>
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

        [@api method="post" url="/phoenix2/composite/graphql" jumpMethod="${jumpMethod!'0'}"
			selectGroupIds="${selectGroupIds!''}"
			expandIds="${expandIds!''}"
			query='{
				 articleCateList(selectGroupIds: $selectGroupIds, optionsParam: $optionsParam) {
					cateId
                    encodeId
                    cateName
                    parentCateId
                    cateUrl
                    subArticles
                    showFieldList
				}
			}']
		
		[#assign isGroupName = '1' /]
		[#if expandIds?? && expandIds != ""]
				[#assign expandIdsJSON=expandIds?eval /]
				[#list expandIdsJSON.showField.data as group]
					[#if group.fieldId == 'groupName' && group.checked]
						[#assign isGroupName = '1' /]
					[/#if]
				[/#list]
		[/#if]
		<ul class="block-article-group-list block-common-group-list ${pcDefaultStyle} ${padDefaultStyle} ${phoneDefaultStyle} ${addBlockKeyClass} 22222222222222" data-closeway="${closeWay}">
			<!-- 特殊标识 用于后台保存样式 -->
			<div class="group-item-li current" style="display: none;">
				<input type="hidden" class="classify-flex" />
			</div>
			[#if data?? && data.articleCateList?? && (data.articleCateList?size > 0)]
			[#if isGroupName == '1']
				[#list data.articleCateList as group]
				<li class="group-item-li grouplist-li-first [#if infoGroupId?? && infoGroupId == group.cateId ]current[/#if]" data-pid="${group.encodeId}">
					<div class="classify-flex [#if group.subArticles??]hasChild[/#if] group_classify_${htmlClass_firstFont!''}">
                        <span class="classify-flex-span">
                            <a class="groupName ${htmlClass_firstFont!''}" href="${group.cateUrl!''}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" title="${group.cateName!?html}">${group.cateName!?html}</a>
                        </span>
						[#if group.subArticles??]
							<span class="drop-down">
                                <i class="expand_icon ${expandIconClass!'iconfont_phoenix icon-angle-up'}"></i>
                                <i class="collapse_icon ${collapseIconClass!'iconfont_phoenix icon-angle-down'}"></i>
                            </span>
						[/#if]
					</div>
                    <div class="group-item-divider"></div>
					[#-- 二级菜单 --]
					[#if group.subArticles?? && group.subArticles?has_content]
						<ul class="two-classify classify-item">
						[#list group.subArticles as secondGroup]
							<li class="grouplist-li-two group-item-li grouplist-li-other [#if infoGroupId?? && infoGroupId == secondGroup.cateId ]current[/#if]">
                                <div class="classify-flex [#if secondGroup.subArticles??]hasChild[/#if] group_classify_${htmlClass_secondFont!''}">
                                    <span class="classify-flex-span">
                                        [#if itemIconClass?? && itemIconClass != '']
											<span><i class="${itemIconClass}"></i></span>
										[/#if]
                                        <a class="groupName ${htmlClass_secondFont!''}" href="${secondGroup.cateUrl!''}" title="${secondGroup.cateName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]" >${secondGroup.cateName!?html}</a>
                                    </span>
                                    [#if secondGroup.subArticles??]
                                        <span class="drop-down">
                                            <i class="expand_icon ${expandIconClass!'iconfont_phoenix icon-angle-up'}"></i>
                                            <i class="collapse_icon ${collapseIconClass!'iconfont_phoenix icon-angle-down'}"></i>
                                        </span>
                                    [/#if]
                                </div>
                                <div class="group-item-divider"></div>
								[#-- 三级菜单 --]
								[#if secondGroup.subArticles??]	
									<ul class="three-classify classify-item">
										[#list secondGroup.subArticles as thirdGroup]
											<li class="grouplist-li-three group-item-li grouplist-li-other [#if infoGroupId?? && infoGroupId == thirdGroup.cateId ]current[/#if]">
                                                <div class="classify-flex [#if thirdGroup.subArticles??]hasChild[/#if] group_classify_${htmlClass_secondFont!''}">
                                                    <span class="classify-flex-span">
                                                        [#if itemIconClass?? && itemIconClass != '']
															<span><i class="${itemIconClass}"></i></span>
														[/#if]
                                                        <a class="groupName ${htmlClass_secondFont!''} " href="${thirdGroup.cateUrl!''}" title="${thirdGroup.cateName!?html}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">${thirdGroup.cateName!?html}</a>
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
			[/#if]	
			[#else]
				<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
			[/#if]
		</ul>
		
		<script>
			$(function(){
				window._block_namespaces_['articlelist_group39514'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'groupArticle_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
			});
		</script>
		
	[/@api]
		
	</div>