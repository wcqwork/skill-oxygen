[#assign expandIdsJSON = {}]
[#assign directoryDataJSON = {}]
<div class="backstage-blocksEditor-wrap wra block_77349" data-block-uuid="articleDetail"  data-gjs-type="developer-node-component" data-block-type="phoenix_blocks_articleDetail" data-default-setting={"dataType":"0","dataId":"-1","expandIds":{"showField":{"draggable":false,"data":[{"fieldName":"发布作者","checked":true,"fieldType":"0","value":"1","fieldId":"articleAuthor"},{"fieldName":"发布日期","checked":true,"fieldType":"0","value":"2","fieldId":"publishTime"},{"fieldName":"浏览量","checked":true,"fieldType":"0","value":"3","fieldId":"realBrowseNum"},{"fieldName":"来源","checked":true,"fieldType":"0","value":"4","fieldId":"articleOrigin"}],"label":"显示字段","key":"showField"},"functionBtn":{"draggable":true,"data":[{"checked":true,"label":"询盘按钮","drag":true,"value":"1","key":"inquiry"},{"expand":{"top":108,"maxHeight":485,"detailSettingContent_second":{"data":[{"iconSvg":"facebook","checked":true,"label":"facebook","value":"0"},{"iconSvg":"twitter1","checked":true,"label":"Twitter","value":"1"},{"iconSvg":"line","checked":true,"label":"Line","value":"2"},{"iconSvg":"wechat","checked":true,"label":"wechat","value":"3"},{"iconSvg":"Linkedin","checked":true,"label":"Linkedin","value":"4"},{"iconSvg":"pinterest","checked":true,"label":"Pinterest","value":"5"},{"iconSvg":"whatsapp","checked":true,"label":"whatsapp","value":"6"},{"iconSvg":"KaKao","checked":true,"label":"KaKao","value":"7"}],"name":"8","label":"选择社交平台","type":"imgList"},"width":236,"show":false,"right":572,"label":"社交分享","type":"icon","zIndex":3},"checked":true,"label":"社交分享","drag":true,"value":"2","key":"share"},{"expand":{"minHeight":1,"top":240,"maxHeight":485,"detailSettingContent_second":{"data":[{"options":[{"label":"新窗口打开","value":"0"},{"label":"当前窗口跳转","value":"1"}],"additionalClass":"basic-lead-ed-option","label":"跳转方式","type":"select","value":"0"},{"options":[{"label":"所有文章","value":"1"},{"label":"相同分类下文章","value":"0"}],"label":"数据源","type":"select","value":"1"}],"name":"0","label":"","type":"all"},"width":236,"show":false,"right":572,"label":"上一个、下一个按钮","type":"icon","zIndex":3},"checked":true,"label":"上一个、下一个按钮","drag":false,"value":"2","key":"preNext"}],"label":"功能按钮","key":"functionBtn"}},"expandSort":["functionBtn","showField"],"directoryData":{"articleCatalogueTop":{"min":0,"max":200,"name":0,"step":10,"label":"顶部偏移量","type":"slider"},"articleCatalogueSwitch":{"name":true,"additionalClass":"basic-lead-ed-option","label":"是否显示","type":"switch"},"articleCataloguePosition":{"name":"1","options":[{"label":"左侧","value":"0"},{"label":"右侧","value":"1"}],"additionalClass":"basic-lead-ed-option","label":"显示位置","placeholder":"请选择","type":"select"},"articleCatalogueTitle":{"name":"此处目录名称","additionalClass":"basic-lead-ed-option","label":"标题","placeholder":"请输入目录","type":"input"},"articleCatalogueFloat":{"name":"1","options":[{"label":"是","value":"0"},{"label":"否","value":"1"}],"additionalClass":"basic-lead-ed-option","label":"是否悬浮","placeholder":"请选择","type":"select"}},"translationEntry":[]}>
    [#--此处文章id和文章数据类型--]
    [#assign infoIdData = dataId]
    [#assign articleTypeData = dataType]
    [#if dataType == "0" && infoId != ""]
        [#assign articleTypeData = '1']
        [#assign infoIdData = infoId]
    [/#if]
    <div style="display:none;" class="article-debug-data">
        dataId: ${dataId};
        dataType: ${dataType};
        infoIdData: ${infoIdData};
        infoId: ${infoId};
        dataType: ${dataType};
    </div>
    [#--此处文章上一个下一个开关和文章上一个下一个数据类型和跳转方式--]
    [#assign switchType = 1]
    [#assign dataSourceType = 0]
    [#assign dataSourceJumpType = 0]
    [#if expandIds?? && expandIds != ""]
        [#assign expandIdsJSON=expandIds?eval /]
        [#if expandIdsJSON?? && expandIdsJSON.functionBtn?? && expandIdsJSON.functionBtn.data??]
            [#list expandIdsJSON.functionBtn.data as functionBtn]
                [#if functionBtn.key == 'preNext']
                    [#if functionBtn.checked == true]
                        [#assign switchType = 1]
                    [#elseif functionBtn.checked == false]
                        [#assign switchType = 0]
                    [/#if]
                    [#if functionBtn.expand?? && functionBtn.expand.detailSettingContent_second?? && functionBtn.expand.detailSettingContent_second.data??]
                        [#list functionBtn.expand.detailSettingContent_second.data as functionBtnPreNext]
                            [#if functionBtnPreNext.label == "跳转方式"]
                                [#assign dataSourceJumpType = functionBtnPreNext.value]
                            [#elseif functionBtnPreNext.label == "数据源"]
                                [#assign dataSourceType = functionBtnPreNext.value]
                            [/#if]
                        [/#list]
                    [/#if]
                [/#if]
            [/#list]
        [/#if]
    [/#if]
    [@api method="post" url="/phoenix2/composite/graphql" dataType="${articleTypeData}"  selectArticleIds="${dataIds!''}"
             expandIds="${expandIds!''}" directoryData="${directoryData!''}" dataId="${infoIdData}" switchType="${switchType}" dataSourceType="${dataSourceType}" dataSourceJumpType="${dataSourceJumpType}"
			query='{
				articleSettingItem(encodeId:"$dataId",articleType: "$dataType",optionsParam:$optionsParam,switchType:"$switchType",dataSourceType:"$dataSourceType") {
                    articleAuthor
                    publishTime
                    realBrowseNum
                    articleOrigin
                    articleTitle
                    photoUrlNormal
                    photoUrlDefine
                    showFieldList
                    articleSummary
                    articleText
                    richTextType
                    articleId
                    articleUrl
                    articlePreviousUrl
                    articlePreviousTitle
                    articleNextUrl
                    articleNextTitle
                    articleStructureData
                }
			}']
            [#if directoryData?? && directoryData != ""]
				[#assign directoryDataJSON=directoryData?eval /]
                [#--文章详情--]
                <div class="block-article 77349">
                    [#if data?? && data.articleSettingItem??]
                        <div class="block-article-container-header">
                                <h1 class="header-title heading2">
                                    ${data.articleSettingItem.articleTitle}
                                </h1>
                                <div class="header-fieldId">
                                    [#if data.articleSettingItem.showFieldList?? && data.articleSettingItem.showFieldList?size > 0]
                                        <div class="content-container">
                                            [#list data.articleSettingItem.showFieldList as field]
                                                [#if field.fieldId?? && field.fieldId == "realBrowseNum"]   
                                                    <div class="brief position paragraph1">[@s.m "phoenix_article_browseNum" /]${field.fieldValue!''}</div>
                                                [/#if]
                                                [#if field.fieldId?? && field.fieldId == "publishTime"]   
                                                    <div class="brief position paragraph1">[@s.m "phoenix_article_publish_time" /]${field.fieldValue!''}</div>
                                                [/#if]
                                                [#if field.fieldId?? && field.fieldId == "articleAuthor"]  
                                                    <div class="classify position paragraph1">[@s.m "phoenix_article_author" /]${field.fieldValue!''}</div>
                                                [/#if]
                                                [#if field.fieldId?? && field.fieldId == "articleOrigin"] 
                                                    <div class="time position paragraph1">[@s.m "phoenix_article_origin" /]<a href="javascript:;" class="paragraph1">${field.fieldValue!''}</a></div>
                                                [/#if]
                                            [/#list]
                                        </div>
                                    [/#if]
                                </div>
                                <div class="header-btn">
                                    [#if expandIds?? && expandIds != ""]
				    	                [#assign expandIdsJSON=expandIds?eval /]
                                            [#if expandIdsJSON?? && expandIdsJSON.functionBtn?? && expandIdsJSON.functionBtn.data??]
				    	                    	[#list expandIdsJSON.functionBtn.data as functionBtn]
                                                    [#--询盘--]
				    	                    		[#if functionBtn.checked == true && functionBtn.key == 'inquiry']
                                                        <div class="header-inquiry">
				    	                    		    	<div class="prodlist-site-buttons block-editor-inquire" prodId="${product.encodeId}">
				    	                    		    		<a href="javascript:;" target="_self">
				    	                    		    			<span class="text-wrap buy-wrap paragraph1">
                                                                        <i class="iconfont iconfont_phoenix icon-youxiang" aria-hidden="true"></i>
				    	                    		    				[@s.m "phoenix_product_inquire" /] 
				    	                    		    			</span>
				    	                    		    		</a>
				    	                    		    		<form id="prodInquire" action="/phoenix/admin/prod/inquire" method="post" novalidate="">
				    	                    		    			<input type="hidden" name="inquireParams">
				    	                    		    		</form>
				    	                    		    	</div>
				    	                    		    </div>
                                                    [/#if]
                                                    [#--分享--]
                                                    [#if functionBtn.checked == true && functionBtn.key == 'share']
                                                        <div class="header-share">
                                                            [#if functionBtn.expand?? && functionBtn.expand.detailSettingContent_second?? && functionBtn.expand.detailSettingContent_second.data??]
                                                                [@web_backend]
                                                                    默认图标
                                                                [/@web_backend]
                                                                [@web_frontend]
                                                                    [#list functionBtn.expand.detailSettingContent_second.data as functionBtnShare]
                                                                        [#if  functionBtnShare.checked == true && functionBtnShare.label == 'facebook' ]
                                                                            <div class="st-custom-button" data-network="facebook">
                                                                            	<img alt="facebook sharing button" src="//platform-cdn.sharethis.com/img/facebook.svg" />
                                                                            </div>
                                                                        [#elseif  functionBtnShare.checked == true && functionBtnShare.label == 'Twitter']
                                                                            <div class="st-custom-button" data-network="twitter">
                                                                            	<img alt="twitter sharing button" src="//platform-cdn.sharethis.com/img/twitter.svg" />
                                                                            </div>
                                                                        [#elseif functionBtnShare.checked == true && functionBtnShare.label == 'Line']
                                                                            <div class="st-custom-button" data-network="line">
                                                                            	<img alt="line sharing button" src="//platform-cdn.sharethis.com/img/line.svg" />
                                                                            </div>
                                                                        [#elseif functionBtnShare.checked == true && functionBtnShare.label == 'wechat']
                                                                            <div class="st-custom-button" data-network="wechat">
                                                                            	<img alt="wechat sharing button" src="//platform-cdn.sharethis.com/img/wechat.svg" />
                                                                            </div>
                                                                        [#elseif functionBtnShare.checked == true && functionBtnShare.label == 'Linkedin']
                                                                            <div class="st-custom-button" data-network="linkedin">
                                                                            	<img alt="linkedin sharing button" src="//platform-cdn.sharethis.com/img/linkedin.svg" />
                                                                            </div>
                                                                        [#elseif functionBtnShare.checked == true && functionBtnShare.label == 'Pinterest']
                                                                            <div class="st-custom-button" data-network="pinterest">
                                                                            	<img alt="pinterest sharing button" src="//platform-cdn.sharethis.com/img/pinterest.svg" />
                                                                            </div>
                                                                        [#elseif functionBtnShare.checked == true && functionBtnShare.label == 'whatsapp']
                                                                            <div class="st-custom-button" data-network="whatsapp">
                                                                            	<img alt="whatsapp sharing button" src="//platform-cdn.sharethis.com/img/whatsapp.svg" />
                                                                            </div>
                                                                        [#elseif functionBtnShare.checked == true && functionBtnShare.label == 'KaKao']
                                                                            <div class="st-custom-button" data-network="kakao">
                                                                            	<img alt="kakao sharing button" src="//platform-cdn.sharethis.com/img/kakao.svg" />
                                                                            </div>
                                                                        [#else]

                                                                        [/#if]

                                                                    [/#list]
                                                                    <div class="st-custom-button" data-network="sharethis">
                                                                    	<img alt="sharethis sharing button" src="//platform-cdn.sharethis.com/img/sharethis.svg" />
                                                                    </div>
                                                                [/@web_frontend]
                                                            [/#if]
                                                        </div>
                                                    [/#if]
				    	                    	[/#list]
				    	                    [/#if]
                                    [/#if]
                                </div>
                        </div>
                        <div class="block-content-box [#if directoryDataJSON.articleCataloguePosition.name?? && directoryDataJSON.articleCataloguePosition.name =='1' ]right[#else]left[/#if]">
                            <div class="block-article-container" style="[#if directoryDataJSON.articleCatalogueSwitch.name?? && directoryDataJSON.articleCatalogueSwitch.name ==true ]width:80%[/#if]">
                                <div class="block-article-container-content">
                                    <div class="content-detail" data-richTextType="${data.articleSettingItem.richTextType}">
                                        [#if data.articleSettingItem.photoUrlNormal?lower_case?contains('/static/assets/images/no_pic.jpg')]
                                        [#else]
                                            <div class="content-img">
                                                <img loading="lazy" href="${data.articleSettingItem.photoUrlNormal!''}" src="${data.articleSettingItem.photoUrlNormal!''}">
                                            </div>
                                        [/#if]
                                        [@retry_render]${data.articleSettingItem.articleText}[/@retry_render]
                                    </div>
                                </div>
                                <div class="block-article-container-prevNext">
                                    [#if switchType?? && switchType==1]
                                        <div class="block-article-container-prev-box paragraph1">
                                            [#--[@s.m "phoenix_article_previous"/]上一篇：--][@s.m "phoenix_product_previous" /]:
                                            [#if dataSourceJumpType==0]
                                                <a class=" paragraph1" href="${data.articleSettingItem.articlePreviousUrl!''}" target='_blank'>${data.articleSettingItem.articlePreviousTitle!''}</a>
                                            [#else]
                                                <a class=" paragraph1" href="${data.articleSettingItem.articlePreviousUrl!''}">${data.articleSettingItem.articlePreviousTitle!''}</a>
                                            [/#if]
                                        </div>
                                        <div class="block-article-container-next-box paragraph1">
                                            [#--[@s.m "phoenix_article_next"/]下一篇：--][@s.m "phoenix_product_next" /]:
                                            [#if dataSourceJumpType==0]
                                                <a class=" paragraph1" href="${data.articleSettingItem.articleNextUrl!''}" target="_blank">${data.articleSettingItem.articleNextTitle!''}</a>
                                            [#else]
                                                <a class=" paragraph1" href="${data.articleSettingItem.articleNextUrl!''}">${data.articleSettingItem.articleNextTitle!''}</a>
                                            [/#if]
                                        </div>
                                    [/#if]
                                </div>
                            </div>
                            <div  class="block-article-container directory [#if directoryDataJSON.articleCatalogueSwitch.name?? && directoryDataJSON.articleCatalogueSwitch.name == true]show[/#if]" style="[#if directoryDataJSON.articleCatalogueFloat.name?? && directoryDataJSON.articleCatalogueFloat.name=='0']position:sticky;[/#if][#if directoryDataJSON.articleCatalogueSwitch.name??]top:${directoryDataJSON.articleCatalogueTop.name!''}px;[/#if]">
                                [#--文章目录--]
                                    <div class="articleDetail-catalog heading2">
                                        ${directoryDataJSON.articleCatalogueTitle.name!""}
                                    </div>
                                    
                                    [#--${directoryDataJSON.articleCataloguePosition.name!""}----目录显示位置0左1右
                                    ${directoryDataJSON.articleCatalogueFloat.name!""}----目录是否悬浮0是1否
                                    ${directoryDataJSON.articleCatalogueTop.name!""}----目录顶部偏移--]
    
                            </div>
                        </div>
                    [/#if]
                </div>
                <input type="hidden" name="articleId" class="articleIdInput" value="${data.articleSettingItem.articleId!''}" /> 
		        <input type="hidden" name="articleUrl" class="articleUrlInput" value="${data.articleSettingItem.articleUrl!''}" />
                <input type="hidden" name="articleCatalogueFloatInput" class="articleCatalogueFloatInput" value="${directoryDataJSON.articleCatalogueFloat.name!'1'}" /> 
		        <input type="hidden" name="articleCatalogueTopInput" class="articleCatalogueTopInput" value="${directoryDataJSON.articleCatalogueTop.name!'0'}" />
                <input type="hidden" class="linkPopupForm linkPopupForm_idHidden_article" name="" id="articleIdHidden" value="${infoId!''}"/>
            [/#if]
        	<script>
                $(function(){
                    window._block_namespaces_['articleDetail_77349'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articleDetail_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
            </script>
            <script type="application/ld+json">
                 ${data.articleSettingItem.articleStructureData!""}
            </script>
	[/@api]
</div>