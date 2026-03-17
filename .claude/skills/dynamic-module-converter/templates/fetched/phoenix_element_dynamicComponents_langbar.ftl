<div class="backstage-blocksEditor-wrap wra block_77569" data-block-uuid="langbar" data-gjs-type="developer-node-component" data-block-type="phoenix_element_dynamicComponents" data-default-setting={}>
  [@api method="post" url="/phoenix2/composite/graphql"
    query='{
      siteLanCodeList{
			currentSiteLanCode
        	siteLanCodes {
          	lanCode
          	lanCodeName
          	lanCodeIndexUrl
        	}
        	allLanCodes {
         		lanCode
          	lanCodeName
        	}
      }
  }']
  	[#if componentSetting?? && componentSetting != ""]
        [#assign componentSettingJSON=componentSetting?eval /]
    [/#if]
	[#assign languageStyleVal = "dropDown"]
	[#assign languageIconVal = true]
	[#assign languageNationalVal = false]
	[#assign languageNameVal = true]
	[#assign languageDropDownIconVal = true]
	[#if componentSettingJSON?? && componentSettingJSON.prodDynamicSetting??]
		[#-- 两个风格--]
		[#if componentSettingJSON.prodDynamicSetting[1].blockSetting.languageStyle]
			[#assign languageStyleVal = componentSettingJSON.prodDynamicSetting[1].blockSetting.languageStyle /]
		[/#if]
		[#-- 图标--]
		[#if componentSettingJSON.prodDynamicSetting[1].blockSetting.languageIcon]
			[#assign languageIconVal = componentSettingJSON.prodDynamicSetting[1].blockSetting.languageIcon /]
		[#else]
			[#assign languageIconVal = false]
		[/#if]
		[#-- 国旗--]
		[#if componentSettingJSON.prodDynamicSetting[1].blockSetting.languageNational]
			[#assign languageNationalVal = componentSettingJSON.prodDynamicSetting[1].blockSetting.languageNational /]
		[#else]
			[#assign languageNationalVal = false]
		[/#if]
		[#-- 名称--]
		[#if componentSettingJSON.prodDynamicSetting[1].blockSetting.languageName]
			[#assign languageNameVal = componentSettingJSON.prodDynamicSetting[1].blockSetting.languageName /]
		[#else]
			[#assign languageNameVal = false]
		[/#if]
		[#-- 下拉图标--]
		[#if componentSettingJSON.prodDynamicSetting[1].blockSetting.languageDropDownIcon]
			[#assign languageDropDownIconVal = componentSettingJSON.prodDynamicSetting[1].blockSetting.languageDropDownIcon /]
		[#else]
			[#assign languageDropDownIconVal = false]
		[/#if]

		[#if componentSettingJSON.prodDynamicSetting[0].blockSetting.languageSetting.languageCheckList]
			[#assign languageCheckList = componentSettingJSON.prodDynamicSetting[0].blockSetting.languageSetting.languageCheckList /]
		[/#if]
		[#if componentSettingJSON.prodDynamicSetting[0].blockSetting.languageSetting.checkKeyList]
			[#assign checkKeyList = componentSettingJSON.prodDynamicSetting[0].blockSetting.languageSetting.checkKeyList /]
		[/#if]
		[#if componentSettingJSON.prodDynamicSetting[0].blockSetting.languageSetting.checkKeyList]
			[#assign firstValidObject = componentSettingJSON.prodDynamicSetting[0].blockSetting.languageSetting.firstValidObject /]
		[/#if]

		[#-- 两个图标类名--]
		[#if componentSettingJSON.prodDynamicSetting[2].blockSetting.buttonIconClass]
			[#assign icon_class = componentSettingJSON.prodDynamicSetting[2].blockSetting.buttonIconClass /]
		[/#if]
		[#if componentSettingJSON.prodDynamicSetting[2].blockSetting.dropDown_buttonIconClass]
			[#assign dropDown_icon_class = componentSettingJSON.prodDynamicSetting[2].blockSetting.dropDown_buttonIconClass /]
		[/#if]
    [/#if]
	
	[#if languageCheckList?? && languageCheckList?size gt 0 && checkKeyList?? && checkKeyList?size gt 0]
		[#-- class
		defaultContainer 默认文字
		defaultContainer_hover 默认文字悬浮
		langDropDownText 下拉文字
		langDropDownText_hover 下拉文字悬浮
		langIcon 图标
		langIcon_hover 悬浮
		lang_borderStyles 边框
		lang_borderStyles_hover 边框悬浮
		lang_prodBgColor 背景
		lang_prodBgColor_hover 边框悬浮
		languageSpaceRow 上下左右内间距
		languageMarginSpaceColumn 语言栏行间距
		languageMarginSpaceRow 语言栏行间距右间距

		
		--]
	    [#if languageStyleVal?? && languageStyleVal == "dropDown"]
			[#assign currentSiteLanCode = data.siteLanCodeList.currentSiteLanCode /]
			[#assign currentLanCodeInfo = {} /]
			[#list data.siteLanCodeList.siteLanCodes as lanCodeInfo]
			  [#if lanCodeInfo.lanCode == currentSiteLanCode]
			    [#assign currentLanCodeInfo = lanCodeInfo]
			  [/#if]
			[/#list]
			<div class="lang-content lang-dropdown-content languageSpaceRow lang_borderStyles lang_prodBgColor">
				[#if languageIconVal?? && languageIconVal?string == 'true']
					<span class="langIcon lanbarSwitch icon ${icon_class!'iconfont_phoenix icon-yuyanlan-shi'} lang-flat languageIconSpace"></span>
				[/#if]
				[#if languageNationalVal?? && languageNationalVal?string == 'true']
					[#if firstValidObject??]
						<span class="languageNational lanbarSwitch langImg lang-sprites-slide sprites sprites-${firstValidObject.lanCode!'0'} languageNationalSpace"></span>
					[/#if]
				[/#if]
				[#if languageNameVal?? && languageNameVal?string == 'true']
					<span class="paragraph1 lanbarSwitch languageName languageNameSpace defaultContainer">
						[#if firstValidObject??]
							${firstValidObject.lanCodeName}
						[/#if]
					</span>
				[/#if]
				[#if languageDropDownIconVal?? && languageDropDownIconVal?string == 'true']
					<span class="langIcon lanbarSwitch icon  ${dropDown_icon_class!'iconfont_phoenix icon-angle-down'} lang-dropdown" style="margin-left:4px;"></span>
				[/#if]
				<ul class="lang-menu" style="display: none;">
					[#list languageCheckList as language]
						[#if checkKeyList?seq_contains(language.lanCode)]
							<li class="lang-item langTile langDropDownText "> 
								<a class="langImgBox" href='${language.lanCodeIndexUrl!"javascript:void(0)"}'>
									[#if languageNationalVal?? && languageNationalVal?string == 'true']
										<span class="langImg lang-sprites-slide sprites sprites-${language.lanCode!''} languageNationalSpace"></span>
									[/#if]
									<span class="langNa " title="${language.lanCodeName!''}">${language.lanCodeName!''}</span>
								</a>
							</li>
						[/#if]
					[/#list]
				</ul>
			</div>
		[#else]
			<div class="lang-content lang-side-content  languageMarginSpaceColumn ">
				[#if languageIconVal?? && languageIconVal?string == 'true']
					<span class="langIcon lanbarSwitch icon ${icon_class!'iconfont_phoenix icon-yuyanlan-shi'} lang-flat languageIconSpace"></span>
				[/#if]
				[#list languageCheckList as language]
					[#if checkKeyList?seq_contains(language.lanCode)]
						<a class="langImgBox languageSpaceRow languageMarginSpaceRow lang_borderStyles lang_prodBgColor" href='${language.lanCodeIndexUrl!"javascript:void(0)"}'>
							[#if languageNationalVal?? && languageNationalVal?string == 'true']
								<span class="langImg lang-sprites-slide sprites sprites-${language.lanCode!''} languageNationalSpace"></span>
							[/#if]
							[#if languageNameVal?? && languageNameVal?string == 'true']
								<span class="defaultContainer languageName languageNameSpace" title="${language.lanCodeName!''}">${language.lanCodeName!''}</span>
							[/#if]
						</a>
					[/#if]
				[/#list]
			</div>
		[/#if]
	[#else]
		[#--默认数据情况--]
		[#if languageStyleVal?? && languageStyleVal == "dropDown"]
        	<div class="defaultData lang-content lang-dropdown-content languageSpaceRow lang_borderStyles lang_prodBgColor">

				[#if languageIconVal?? && languageIconVal?string == 'true']
					<span class="langIcon lanbarSwitch lanbarSwitch icon ${icon_class!'iconfont_phoenix icon-yuyanlan-shi'} lang-flat languageIconSpace"></span>
				[/#if]

				[#if languageNationalVal?? && languageNationalVal?string == 'true']
					[#list data.siteLanCodeList.siteLanCodes as language]
						[#if language_index==0]
							<span class="languageNational lanbarSwitch langImg lang-sprites-slide sprites sprites-${language.lanCode!'0'} languageNationalSpace"></span>
						[/#if]
					[/#list]
					
				[/#if]
				[#if languageNameVal?? && languageNameVal?string == 'true']
					<span class="paragraph1 lanbarSwitch languageName languageNameSpace defaultContainer" style="line-height: 19px;">
						[#list data.siteLanCodeList.siteLanCodes as language]
							[#if language_index==0]
								${language.lanCodeName!''}
							[/#if]
						[/#list]
					</span>
				[/#if]
				[#if languageDropDownIconVal?? && languageDropDownIconVal?string == 'true']
					<span class="langIcon icon lanbarSwitch  ${dropDown_icon_class!'iconfont_phoenix icon-angle-down'} lang-dropdown" style="margin-left:4px;"></span>
				[/#if]
				<ul class="lang-menu lang-default-menu" style="display: none;">
					[#list data.siteLanCodeList.siteLanCodes as language]
						<li class="lang-item langTile langDropDownText "> 
							<a class="langImgBox" href='${language.lanCodeIndexUrl!"javascript:void(0)"}'>
								[#if languageNationalVal?? && languageNationalVal?string == 'true']
									<span class="langImg lang-sprites-slide sprites sprites-${language.lanCode!''} languageNationalSpace"></span>
								[/#if]
								<span class="langNa " title="${language.lanCodeName!''}">${language.lanCodeName!''}</span>
							</a>
						</li>
					[/#list]
				</ul>
			</div>
		[#else]
			<div class="defaultData lang-content lang-side-content  languageMarginSpaceColumn ">
				[#if languageIconVal?? && languageIconVal?string == 'true']
					<span class="langIcon lanbarSwitch icon ${icon_class!'iconfont_phoenix icon-yuyanlan-shi'} lang-flat languageIconSpace"></span>
				[/#if]
				
				[#list data.siteLanCodeList.siteLanCodes as language]
					<a class="langImgBox languageSpaceRow languageMarginSpaceRow lang_borderStyles lang_prodBgColor" href='${language.lanCodeIndexUrl!"javascript:void(0)"}'>
						[#if languageNationalVal?? && languageNationalVal?string == 'true']
							<span class="langImg lang-sprites-slide sprites sprites-${language.lanCode!''} languageNationalSpace"></span>
						[/#if]
						[#if languageNameVal?? && languageNameVal?string == 'true']
							<span class="defaultContainer languageName languageNameSpace" title="${language.lanCodeName!''}">${language.lanCodeName!''}</span>
						[/#if]
					</a>
				[/#list]
			</div>
		[/#if]
	[/#if]
    <script> 
      $(function(){
        window._block_namespaces_['block_77569'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','pageNodeId':'${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
      });
    </script>
[/@api]
</div>