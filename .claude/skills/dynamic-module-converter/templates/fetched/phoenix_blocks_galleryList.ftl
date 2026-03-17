<div class="backstage-blocksEditor-wrap wra block_28712" data-block-uuid="galleryList" data-dynamic-toolbar="1" data-dynamic-type="galleryList" data-gjs-type="developer-node-component"  data-block-type="phoenix_blocks_galleryList" data-default-setting={"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","pageSize":10,"page":1,"layoutStyle":"0","expandIds":{"showField":{"draggable":false,"data":[{"fieldName":"封面","checked":true,"fieldType":"0","value":"1","fieldId":"photoUrl"},{"fieldName":"图册名称","checked":true,"fieldType":"0","value":"2","fieldId":"galleryName"},{"fieldName":"图册描述","checked":true,"fieldType":"0","value":"3","fieldId":"galleryDesc"},{"fieldName":"图册分类","checked":true,"fieldType":"0","value":"4","fieldId":"galleryGroup"},{"fieldName":"日期","checked":true,"fieldType":"0","value":"5","fieldId":"updateTime"}],"label":"显示字段","key":"showField"}},"expandSort":["showField"],"jumpMethod":"0","translationEntry":[]}>
    [#if componentSetting?? && componentSetting != ""]
        [#assign componentSettingJSON=componentSetting?eval /]
        [#if componentSettingJSON?? && componentSettingJSON.dynamicFontTab??]
            [#list componentSettingJSON.dynamicFontTab as item]
                [#list item.saveData as saveDataItem]
                    [#if saveDataItem.styleKey?? && saveDataItem.styleKey == 'currentFontStyleClass']
                        [#if item.value?? && item.value == 'galleryTitleFont']
                            [#assign htmlClass_galleryTitleFont = saveDataItem.defaultFont /]                            
                        [/#if]
                        [#if item.value?? && item.value == 'galleryDocsFont']
                            [#assign htmlClass_galleryDocsFont = saveDataItem.defaultFont /]                            
                        [/#if]
                        [#if item.value?? && item.value == 'galleryTypeFont']
                            [#assign htmlClass_galleryTypeFont = saveDataItem.defaultFont /]                            
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
                        [#if item.value?? && item.value == 'galleryTitleFont']             
                            [#assign htmlTarget_galleryTitleFont = fontMap[saveDataItem.defaultFont?upper_case]! 'div' /]
                        [/#if]
                    [/#if]
                [/#list]
            [/#list]
            
        [/#if]
    [/#if]
    [@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!'1'}" limit="${pageSize!'10'}"
      selectGalleryType="${dataType!'0'}" dataGroupId="${dataGroupId!''}" selectGalleryIds="${dataIds!''}" loadMethod="${loadMethod!''}"
      orderBy="${orderBy!'0'}" expandIds="${expandIds!''}"  layoutStyle="${layoutStyle!''}" cateId="${galleryCateId!-1}" jumpMethod="${jumpMethod!''}"
        query='{
          galleryList(
              conditionDto:{
                page: $page,
                limit: $limit,
                selectGalleryType: "$selectGalleryType",
                selectGalleryIds: $selectGalleryIds,
                cateIds: $dataGroupId,
                orderBy: "$orderBy",
                cateIdByPage: "$cateId",
                galleryIdByPage: "0"
                }
            ){
                  totalRow
                  pageSize
                  pageNumber
                  list {
                    encodeId	
                    galleryName		
                    galleryStatus	
                    galleryUrl	
                    galleryDesc	
                    galleryUpdateTime	
                    galleryCate{
                        encodeId
                        cateName
                    }
                    galleryCover
                  }
              }
            
        }']
      <div class="block-listTemp-container-replace">
          <ul class="block-listTemp-container block-listTemp-container-28712">
              [#if data?? && data.galleryList?? && data.galleryList.list?? && (data.galleryList.list?size > 0)]
                    [#list data.galleryList.list as dataItem]
                    <li class="block_listTemp_item [#if layoutStyle?? && layoutStyle == '0'] block_listTemp_item_3[#elseif layoutStyle?? && layoutStyle == '1'] block_listTemp_item_4[/#if]">
                        [#if expandIds?? && expandIds != ""]
                        [#assign expandIdsJSON=expandIds?eval /]
                            [#if expandIdsJSON?? && expandIdsJSON.showField?? && expandIdsJSON.showField.data??]
                                [#list expandIdsJSON.showField.data as showField]
                                    [#if showField.checked == true && showField.fieldId == 'photoUrl']
                                    <div class="listTemp_item_container">
                                        <div class="listTemp_item_auto_height listTemp_item_cover">
                                            <a href="${dataItem.galleryUrl!?html}" class="to_detail" [#if jumpMethod?? && jumpMethod == '0'] target="_blank" [/#if]>
                                                <img src="${dataItem.galleryCover!?html}" alt="${dataItem.galleryName!?html}">
                                            </a>
                                        </div>
                                    </div>
                                    [#elseif showField.checked == true && showField.fieldId == 'galleryGroup' && dataItem.galleryCate.cateName != '']
                                    <div class="default_font listTemp_item_group ${htmlClass_galleryTypeFont!'paragraph1'}">${dataItem.galleryCate.cateName}</div>
                                    [#elseif showField.checked == true && showField.fieldId == 'galleryName' && dataItem.galleryName != '']
                                    <${htmlTarget_galleryTitleFont!'div'} class="title_font listTemp_item_title ${htmlClass_galleryTitleFont!'heading5'}">
                                        <a class="" href="${dataItem.galleryUrl!?html}" title="${dataItem.galleryName!?html}" [#if jumpMethod?? && jumpMethod == '0'] target="_blank" [/#if]>${dataItem.galleryName}</a>
                                    </${htmlTarget_galleryTitleFont!'div'}>
                                    [#elseif showField.checked == true && showField.fieldId == 'galleryDesc' && dataItem.galleryDesc != '']
                                    <div class="default_font listTemp_item_desc ${htmlClass_galleryDocsFont!'paragraph1'}">${dataItem.galleryDesc}</div>
                                    [#elseif showField.checked == true && showField.fieldId == 'updateTime' && dataItem.galleryUpdateTime != '']
                                    <div class="default_font listTemp_item_time paragraph1">${dataItem.galleryUpdateTime}</div>
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
          <input type="hidden" name="totalRow" value="${data.galleryList.totalRow!'0'}"> 
          <input type="hidden" name="pageNumber" value="${data.galleryList.pageNumber!'1'}">
          <input type="hidden" name="pageSize" value="${data.galleryList.pageSize!'10'}">
      </div>
      
      [#if !loadMethod?? || loadMethod == '0']
          <div class="listTemp-site-pagination-28712 [#if data.galleryList.pageSize?? && data.galleryList.totalRow?? && data.galleryList.totalRow <=  data.galleryList.pageSize]hide[/#if]">
              <div class="listTemp-laypage-normal paragraph1" id='listTemp-laypage-normal'></div>
          </div>
      [/#if]
    <script>
          $(function(){
              window._block_namespaces_['galleryList_28712'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'galleryList_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
          });
      </script>
[/@api]
  
</div>