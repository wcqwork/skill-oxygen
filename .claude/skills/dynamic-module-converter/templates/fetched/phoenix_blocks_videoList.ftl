<div class="backstage-blocksEditor-wrap wra block_28592" id="block_28592" data-block-uuid="videoList" data-dynamic-toolbar="1" data-dynamic-type="videoList"  data-gjs-type="developer-node-component"  data-block-type="phoenix_blocks_videoList" data-default-setting={"dataType":"0","dataIds":[],"dataGroupId":[],"loadMethod":"0","pageSize":6,"page":1,"layoutStyle":"0","expandIds":{"showField":{"draggable":false,"data":[{"fieldName":"视频附图","checked":true,"fieldType":"0","value":"1","fieldId":"photoUrl"},{"fieldName":"所属分类","checked":true,"fieldType":"0","value":"4","fieldId":"videoGroup"},{"fieldName":"视频名称","checked":true,"fieldType":"0","value":"2","fieldId":"videoName"},{"fieldName":"简介","checked":true,"fieldType":"0","value":"3","fieldId":"videoDesc"},{"fieldName":"时间","checked":true,"fieldType":"0","value":"5","fieldId":"updateTime"}],"label":"显示字段","key":"showField"}},"expandSort":["showField"],"jumpMethod":"0","playType":"0","autoPlayType":"0","translationEntry":[]}>
        [#if componentSetting?? && componentSetting != ""]
            [#assign componentSettingJSON=componentSetting?eval /]
            [#if componentSettingJSON?? && componentSettingJSON.dynamicFontTab??]
                [#list componentSettingJSON.dynamicFontTab as item]
                    [#list item.saveData as saveDataItem]
                        [#if saveDataItem.styleKey?? && saveDataItem.styleKey == 'currentFontStyleClass']
                            [#if item.value?? && item.value == 'videoNameFont']
                                [#assign htmlClass_videoNameFont = saveDataItem.defaultFont /]                            
                            [/#if]
                            [#if item.value?? && item.value == 'videoTypeFont']
                                [#assign htmlClass_videoTypeFont = saveDataItem.defaultFont /]                            
                            [/#if]
                            [#if item.value?? && item.value == 'videoBriefFont']
                                [#assign htmlClass_videoBriefFont = saveDataItem.defaultFont /]                            
                            [/#if]
                        [/#if]
                        [#if saveDataItem.styleKey?? && saveDataItem.styleKey == 'currentFontName']
                            [#assign fontMap = {
                                'H1': 'h1',
                                'H2': 'h2',
                                'H3': 'h3',
                                'H4': 'h4',
                                'H5': 'h5',
                                'H6': 'h6',
                                'DIV': 'div',
                                'P': 'p',
                                'P1': 'p',
                                'P2': 'p',
                                'P3': 'p'
                            } /]
                            [#if item.value?? && item.value == 'videoNameFont']                           
                                [#assign htmlTarget_videoNameFont = fontMap[saveDataItem.defaultFont?upper_case]! 'div' /]
                            [/#if]
                        [/#if]
                    [/#list]
                [/#list]
                
            [/#if]
        [/#if]
        
        [@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"
            dataType="${dataType!'0'}" groupIds="${dataGroupId!''}" selectVideoIds="${dataIds!''}" cateId="${videoGroupId!-1}"
            loadType="${loadType!'0'}" jumpMethod="${jumpMethod!'0'}" expandIds="${expandIds!''}"  playType="${playType!''}" layoutStyle="${layoutStyle!''}"
			query='{
                videoList(
                    conditionDto: {
                    page: $page,
                    limit: $limit,
                    selectVideoType: "$dataType",
                    groupIds: $groupIds,
                    selectVideoIds: $selectVideoIds,
                    groupIdByPage:"$cateId"
                    }
                ) {
                    totalRow
                    pageSize
                    pageNumber
                    extraData{
                        videoStructureData
                    }
                    list {
                        encodeId
                        videoName
                        videoDesc
                        videoUrl
                        videoDetailUrl
                        photoUrl
                        videoGroup {
                          encodeId
                          groupName
                          groupDescription
                          parentGroupId
                          groupUrl
                        }
                        updateTime
                        videoSource
                    }
                }
            }']
            <div class="block-video-container-replace">
                <ul class="block-video-container block-video-container-28592">
                    [#if data?? && data.videoList?? && data.videoList.list?? && (data.videoList.list?size > 0)]
					[#list data.videoList.list as video]
                        <li data-index="${video_index}" class="block_video_item [#if layoutStyle?? && layoutStyle == '0'] block_video_item_3[#elseif layoutStyle?? && layoutStyle == '1'] block_video_item_4[/#if]">
                            [#if expandIds?? && expandIds != ""]
				    	        [#assign expandIdsJSON=expandIds?eval /]
                                [#if expandIdsJSON?? && expandIdsJSON.showField?? && expandIdsJSON.showField.data??]
                                    [#list expandIdsJSON.showField.data as showField]
                                        [#if showField.checked == true && showField.fieldId == 'photoUrl']
                                        <div class="video_item_container">
                                            <div class="video_item_auto_height video_item_cover">
                                                <div class="video_item_play_icon pop_video" data-src="${video.videoDetailUrl!?html}">
                                                   
                                                    <span class="play_back"></span>
                                                    <i class="play_icon iconfont iconfont_phoenix icon-icon-bofang1"></i>
                                                   
                                                </div>
                                                <a href="${video.videoDetailUrl!?html}" class="to_detail" [#if jumpMethod?? && jumpMethod == '0'] target="_blank" [/#if]>
                                                   
                                                    [#if video.photoUrl?? && video.photoUrl!="" && !video.photoUrl?contains("/assets/images/no_pic") ]
                                                        <img src="${video.photoUrl!?html}" alt="${video.videoName!?html}">
                                                    [#elseif video.videoSource?? && video.videoSource == '0']
                                                        [#if video.videoUrl?contains("mediaType=m3u8")]
                                                            [#assign url=video.videoUrl + "&vframe/jpg/offset/1" /]
                                                        [#else]
                                                            [#assign url=video.videoUrl + "?vframe/jpg/offset/1" /]
                                                        [/#if]
                                                        <img src="${url!''}" alt="${video.videoName!?html}">
                                                    [#else]
                                                       <img src="${video.photoUrl!?html}" alt="${video.videoName!?html}">
                                                     [/#if]
                                                </a>
                                            </div>
                                            <div class="video_item_auto_height video_item_movie hide" dara='${video.videoSource}'>
                                                [#if video.videoSource?? && video.videoSource == '0']
                                                    [#if (autoPlayType?? && autoPlayType=='1') || (playType?? && playType=='1')]
                                                        <video class="video_play_dom video-js" muted id="video_play_id_${video_index}" data-ism3u8="${video.videoUrl?contains('mediaType=m3u8')}" data-src="${video.videoUrl!?html}" data-video-index="${video_index}" data-source="${video.videoSource}" controls frameborder="0" preload="auto">
                                                            [#if video.videoUrl?contains('mediaType=m3u8')]
                                                            <source type="application/x-mpegurl">
                                                            [#else]
                                                            <source type="video/mp4">
                                                            [/#if]
                                                        </video>
                                                    [/#if]
                                                [#elseif video.videoSource?? && video.videoSource == '1']
                                                    <iframe class="video_play_dom" data-source="${video.videoSource}" frameborder="0" data-src="${video.videoUrl!?html}" style="position: absolute;top: 0;left: 0;width: 100%;height: 100%;" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true" oallowfullscreen="true" msallowfullscreen="true"></iframe>
                                                [/#if]
                                            </div>
                                        </div>
                                        [#elseif showField.checked == true && showField.fieldId == 'videoGroup' && video.videoGroup??]
                                        <div class="default_font video_item_group">
                                            [#--${video.videoGroup.groupName}--]
                                            [#list video.videoGroup as videoGroupItem]
                                                <a href="${videoGroupItem.groupUrl}" class="video_item_group_a ${htmlClass_videoTypeFont!'paragraph1'}" target="_blank">${videoGroupItem.groupName}</a>
                                            [/#list]
                                        </div>
                                        [#elseif showField.checked == true && showField.fieldId == 'videoName' && video.videoName != '']
                                        <${htmlTarget_videoNameFont!'div'} class="title_font video_item_title ${htmlClass_videoNameFont!'heading5'}">
                                            <a href="${video.videoDetailUrl!?html}" class="pop_video_info" data-video-src="${video.videoUrl!?html}"  [#if jumpMethod?? && jumpMethod == '0'] target="_blank" [/#if]>${video.videoName}</a>
                                        </${htmlTarget_videoNameFont!'div'}>
                                        [#elseif showField.checked == true && showField.fieldId == 'videoDesc' && video.videoDesc != '']
                                        <div class="default_font video_item_desc ${htmlClass_videoBriefFont!'paragraph1'}">${video.videoDesc}</div>
                                        [#elseif showField.checked == true && showField.fieldId == 'updateTime' && video.updateTime != '']
                                        <div class="default_font video_item_time paragraph2">${video.updateTime}</div>
                                        [/#if]
                                    [/#list]
                                [/#if]
                            [/#if]
                        </li>
                    [/#list]
                    [#else]
                    <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
					[/#if]
                </ul>
                <input type="hidden" name="totalRow" value="${data.videoList.totalRow!'0'}"> 
                <input type="hidden" name="pageNumber" value="${data.videoList.pageNumber!'1'}">
                <input type="hidden" name="pageSize" value="${data.videoList.pageSize!'10'}">
                <input type="hidden" name="playType" value="${playType!''}">
                <input type="hidden" name="autoPlayType" value="${autoPlayType!''}">
                <input type="hidden" name="jumpMethod" value="${jumpMethod!'0'}">
            </div>
            
            [#if !loadMethod?? || loadMethod == '0']
                <div class="videolist-site-pagination-28592 [#if data.videoList.pageSize?? && data.videoList.totalRow?? && data.videoList.totalRow <=  data.videoList.pageSize]hide[/#if]">
                    <div class="videolist-laypage-normal" id='videolist-laypage-normal'></div>
                </div>
            [/#if]
        	<script>
                $(function(){
                    window._block_namespaces_['videoList_28592'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'videoList_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
            </script>
            <script type="application/ld+json">
                ${data.videoList.extraData.videoStructureData!"" }
            </script>  
	[/@api]
        
</div>