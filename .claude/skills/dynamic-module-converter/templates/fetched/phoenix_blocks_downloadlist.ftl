<div class="backstage-blocksEditor-wrap wra block_28242" data-block-uuid="downloadlist" data-dynamic-toolbar="1" data-dynamic-type="downloadList" data-gjs-type="developer-node-component"  data-block-type="phoenix_blocks_downloadlist" data-default-setting={"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","pageSize":10,"page":1,"layoutStyle":"1","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文件名称","fieldId":"fileName","fieldType":"0","value":"2","checked":true},{"fieldName":"摘要","fieldId":"fileSummary","fieldType":"0","value":"3","checked":true},{"fieldName":"所属分类","fieldId":"fileCategory","fieldType":"0","value":"4","checked":true},{"fieldName":"更新时间","fieldId":"updateTime","fieldType":"0","value":"5","checked":true},{"fieldName":"文件大小","fieldId":"fileSize","fieldType":"0","value":"6","checked":true},{"fieldName":"下载次数","fieldId":"downloadNum","fieldType":"0","value":"7","checked":true},{"fieldName":"缩略图","fieldId":"filePhoto","fieldType":"0","value":"1","checked":true},{"fieldName":"下载按钮","fieldId":"fileUrl","fieldType":"0","value":"8","checked":true},{"fieldName":"复制链接","fieldId":"copyLink","fieldType":"0","value":"9","checked":true}]}},"expandSort":["showField"],"downloadType":"0","translationEntry":[]}>
        [#if componentSetting?? && componentSetting != ""]
            [#assign componentSettingJSON=componentSetting?eval /]
            [#if componentSettingJSON?? && componentSettingJSON.dynamicFontTab??]
                [#list componentSettingJSON.dynamicFontTab as item]
                    [#list item.saveData as saveDataItem]
                        [#if saveDataItem.styleKey?? && saveDataItem.styleKey == 'currentFontStyleClass']
                            [#if item.value?? && item.value == 'downloadHeaderFont']
                                [#assign htmlClass_downloadHeaderFont = saveDataItem.defaultFont /]                            
                            [/#if]
                            [#if item.value?? && item.value == 'downloadContentFont']
                                [#assign htmlClass_downloadContentFont = saveDataItem.defaultFont /]                            
                            [/#if]
                        [/#if]
                    [/#list]
                [/#list]
                
            [/#if]
        [/#if]

        [@api method="post" version="v2" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"
            downloadType="${dataType!'0'}" searchDownloadCateIds="${dataGroupId!''}"  cateId="${downloadCateId!'-1'}" searchDownloadIds="${dataIds!''}"
            orderBy="${orderBy!'0'}" expandIds="${expandIds!''}"  downloadway="${downloadType!''}" layoutStyle="${layoutStyle!''}"
			query='{
				downLoadList(conditionDto:{page: $page$, limit: $limit$ ,searchPageDownloadCateIds: "$cateId$", downloadType: "$downloadType$",searchDownloadIds: "$searchDownloadIds$", searchDownloadCateIds: "$searchDownloadCateIds$",displayOrder: "$orderBy$",previewUrlPDF:"$downloadway$",previewUrlIMG:"$downloadway$",optionsParam: $optionsParam }) {
                    totalRow
                    pageSize
                    pageNumber
                    list{
                        fileId 
                        fileName 
                        fileSize 
                        fileType
                        cateId
                        fileCategory
                        fileSummary
                        filePhoto 
                        fileUrl 
                        copyLink
                        downloadNum 
                        accessAuth 
                        accessPassword
                        accessForm
                        updateTime 
                        customFieldList 
                        showFieldList
                        previewUrl
                        siteDomain
                    }
                }
			}']
            <div class="block-download-container-replace style-1">
                [#--[#assign expandIdsJSON=expandIds?eval /]--]
               <input type="hidden" id="copyMsg" value='[@s.m "PHENIX2_COPY_SUCCESS" /]'>
               <ul class="block-download-container header">
                    [#if data?? && data.downLoadList?? && data.downLoadList.list??]
                        [#list data.downLoadList.list as download]
                            [#if download_index == 0]
                                [#list download.showFieldList as showField]
                                    [#if showField.fieldId == "filePhoto"]
                                        <li class="filePhoto ${htmlClass_downloadHeaderFont!'heading5'}">
                                            [@s.m "PHENIX2_THUMBNAIL" /]
                                        </li>
                                    [#elseif  showField.fieldId == "fileName"]
                                        <li class="fileName ${htmlClass_downloadHeaderFont!'heading5'}">
                                             [@s.m "PHENIX2_FILE_NAME" /]
                                        </li>
                                    [#elseif  showField.fieldId == "fileSummary"]
                                        <li class="fileSummary ${htmlClass_downloadHeaderFont!'heading5'}">
                                            [@s.m "PHENIX2_SUMMARY" /]
                                        </li>
                                    [#elseif  showField.fieldId == "fileCategory"]
                                        <li class="fileCategory ${htmlClass_downloadHeaderFont!'heading5'}">
                                           [@s.m "PHENIX2_CATEGORY" /]
                                        </li>
                                    [#elseif  showField.fieldId == "updateTime"]
                                        <li class="updateTime ${htmlClass_downloadHeaderFont!'heading5'}">
                                            [@s.m "PHENIX2_UPDATE_TIME" /]
                                        </li>
                                    [#elseif  showField.fieldId == "fileSize"]
                                        <li class="fileSize ${htmlClass_downloadHeaderFont!'heading5'}">
                                            [@s.m "PHENIX2_FILE_SIZE" /]
                                        </li>
                                    [#elseif  showField.fieldId == "downloadNum"]
                                        <li class="downloadNum ${htmlClass_downloadHeaderFont!'heading5'}">
                                            [@s.m "PHENIX2_DOWNLOAD_COUNT" /]
                                        </li>
                                    [#elseif  showField.fieldId == "copyLink"]
                                        <li class="fileUrl1 ${htmlClass_downloadHeaderFont!'heading5'}">
                                            [@s.m "PHENIX2_COPY_LINK" /]
                                        </li>
                                    [#elseif  showField.fieldId == "fileUrl"]
                                        <li class="fileUrl2 ${htmlClass_downloadHeaderFont!'heading5'}">
                                           [@s.m "PHENIX2_DOWNLOAD_BUTTON" /]
                                        </li>
                                    [#else]
                                        <li class="other ${htmlClass_downloadHeaderFont!'heading5'}">
                                            ${showField.fieldName}
                                        </li>
                                    [/#if]
                                [/#list]
                            [/#if]
                        [/#list]
                    [/#if]
                </ul>
                [#if data?? && data.downLoadList?? && data.downLoadList.list?? && (data.downLoadList.list?size > 0)]
                    [#list data.downLoadList.list as download]
                        <ul class="block-download-container content">
                            [#list download.showFieldList as showField]                   
                                [#if showField.fieldId == "filePhoto"]
                                    <li class="filePhoto">
                                        <span>
                                            <img src="${showField.fieldValue}" />
                                        </span>
                                        
                                    </li>
                                [#elseif  showField.fieldId == "fileName"]
                                    <li class="fileName ${htmlClass_downloadContentFont!'paragraph1'}">
                                       <span> ${showField.fieldValue} </span>
                                    </li>
                                [#elseif  showField.fieldId == "fileSummary"]
                                    <li class="fileSummary ${htmlClass_downloadContentFont!'paragraph1'}">
                                        <span> ${showField.fieldValue} </span>
                                    </li>
                                [#elseif  showField.fieldId == "fileCategory"]
                                    [#assign cateName = fileCategory]
                                    <li class="fileCategory ${htmlClass_downloadContentFont!'paragraph1'}">
                                        <span> ${showField.fieldValue} </span>
                                    </li>
                                [#elseif  showField.fieldId == "updateTime"]
                                    <li class="updateTime ${htmlClass_downloadContentFont!'paragraph1'}">
                                         <span> ${showField.fieldValue} </span>
                                    </li>
                                [#elseif  showField.fieldId == "fileSize"]
                                    <li class="fileSize ${htmlClass_downloadContentFont!'paragraph1'}">
                                         <span> ${showField.fieldValue} </span>
                                    </li>
                                [#elseif  showField.fieldId == "downloadNum"]
                                    <li class="downloadNum ${htmlClass_downloadContentFont!'paragraph1'}">
                                        <span> ${showField.fieldValue} </span>
                                    </li>
                                [#elseif  showField.fieldId == "copyLink"]
                                    <li class="copyLink ${htmlClass_downloadContentFont!'paragraph1'}">
                                       <div class="copyLink-btn" data-url="${download.siteDomain}${showField.fieldValue}">
                                          
                                            <i class="iconfont iconfont_phoenix icon-icon-link"></i>
                                            <span>
                                                [@s.m "PHENIX2_COPY_LINK" /]
                                            </span>
                                       </div>
                                    </li>
                                [#elseif  showField.fieldId == "fileUrl"]
                                   <li class="fileUrl2 ${htmlClass_downloadContentFont!'paragraph1'}">
                                       <input  hidden="true" value="${download.accessAuth}"/>
                                       [#if downloadway == '0']
                                            [#if download.fileType == 'pdf']              
                                                [#if download.accessForm?? && download.accessForm == 'true']  
                                                    <a class="preview-pdf ${htmlClass_downloadContentFont!'paragraph1'}" data-cateid="${download.cateId}" accessform="true" encodeFileId="${download.fileId}" dwnurl="//${download.siteDomain}${showField.fieldValue}">
                                                [#elseif download.accessAuth?? && download.accessAuth == '-2']  
                                                    <a class="preview-pdf ${htmlClass_downloadContentFont!'paragraph1'}" encodeFileId="${download.fileId}"  accessauth="true"  dwnurl="//${download.siteDomain}${showField.fieldValue}">
                                                [#else]  
                                                    <a class="preview-pdf ${htmlClass_downloadContentFont!'paragraph1'}" encodeFileId="${download.fileId}" href="//${download.siteDomain}${showField.fieldValue}" target="_bank">
                                                [/#if]                                                       
                                            [#elseif download.fileType == 'jpg' || download.fileType == 'jpeg' || download.fileType == 'png' || download.fileType == 'gif' || download.fileType == 'svg']
                                                <a class="preview-file ${htmlClass_downloadContentFont!'paragraph1'}" data-cateid="${download.cateId}" [#if download.accessForm?? && download.accessForm == 'true']accessform="true"[/#if]  [#if download.accessAuth?? && download.accessAuth == '-2'] accessauth="true"[/#if]  data-name= "${download.fileName}" encodeFileId="${download.fileId}" data-type="${download.fileType}" data-new_file_url="${download.previewUrl!''}" dwnurl="//${download.siteDomain}${showField.fieldValue}" data-href="${download.siteDomain}${showField.fieldValue}" target="_bank">    
                                            [#else]
                                                <a class="downFile ${htmlClass_downloadContentFont!'paragraph1'}" data-cateid="${download.cateId}" [#if download.accessForm?? && download.accessForm == 'true']accessform="true"[/#if]  [#if download.accessAuth?? && download.accessAuth == '-2'] accessauth="true"[/#if]  data-name= "${download.fileName}" encodeFileId="${download.fileId}" dwnurl="${showField.fieldValue}" data-href="${showField.fieldValue}" download="${download.fileName}">
                                            [/#if]        
                                                <i class="iconfont iconfont_phoenix icon-icon-bofang"></i>
                                                <span>[@s.m "PHENIX2_DOENLOAD" /]</span>
                                            </a>
                                       [#else]
                                        <a class="downFile ${htmlClass_downloadContentFont!'paragraph1'}" [#if download.accessForm?? && download.accessForm == 'true']accessform="true"[/#if] [#if download.accessAuth?? && download.accessAuth == '-2'] accessauth="true"[/#if] data-name= "${download.fileName}" encodeFileId="${download.fileId}" dwnurl="${showField.fieldValue}" data-href="${showField.fieldValue}" >
                                            <i class="iconfont iconfont_phoenix icon-icon-bofang"></i>
                                            <span>[@s.m "PHENIX2_DOENLOAD" /]</span>
                                        </a>
                                        [/#if]
                                    </li>
                                [#else]
                                    <li class="other ${htmlClass_downloadContentFont!'paragraph1'}">
                                         <span> ${showField.fieldValue} </span>
                                    </li>
                                [/#if]
                            [/#list]
                        </ul>
                        
                    [/#list]
                    [#else]
                    <div class="templist-no-data ">[@s.m "phoenix_no_content" /]</div>
                   

                [/#if]
                <input hidden class="access-auth-error-tips" value='[@s.m "phoenix_download_pop_access_password_error"/]' />
                <input type="hidden" name="totalRow" value="${data.downLoadList.totalRow!'0'}"> 
                <input type="hidden" name="pageNumber" value="${data.downLoadList.pageNumber!'1'}">
                <input type="hidden" name="pageSize" value="${data.downLoadList.pageSize!'10'}">
            </div>
            <input value="${loadMethod}" hidden="true"/>
            [#if !loadMethod?? || loadMethod == '0']
                <div class="downloadlist-site-pagination-28242 [#if data.downLoadList.totalRow?? && data.downLoadList.pageSize?? && (data.downLoadList.totalRow < data.downLoadList.pageSize || data.downLoadList.totalRow == data.downLoadList.pageSize)]hide[/#if]">
                    <div class="downloadlist-laypage-normal paragraph1" id='downloadlist-laypage-normal'></div>
                </div>
            [/#if]
        	<script>
                $(function(){
                    window._block_namespaces_['downloadList_28242'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'downloadlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
            </script>
	[/@api]
</div>