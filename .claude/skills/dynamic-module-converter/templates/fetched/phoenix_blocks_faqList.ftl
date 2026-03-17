<div class="backstage-blocksEditor-wrap wra block_77449" data-block-uuid="faqList" data-dynamic-toolbar="1" data-dynamic-type="faqList"  data-gjs-type="developer-node-component"  data-block-type="phoenix_blocks_faqList" data-default-setting={}>
    [#if componentSetting?? && componentSetting != ""]
        [#assign componentSettingJSON=componentSetting?eval /]
        [#if componentSettingJSON?? && componentSettingJSON.dynamicFontTab??]
            [#list componentSettingJSON.dynamicFontTab as item]
                [#list item.saveData as saveDataItem]
                    [#if saveDataItem.styleKey?? && saveDataItem.styleKey == 'currentFontStyleClass']
                        [#if item.value?? && item.value == 'faqTitleFont']
                            [#assign htmlClass_faqTitleFont = saveDataItem.defaultFont /]                            
                        [/#if]
                        [#if item.value?? && item.value == 'faqContentFont']
                            [#assign htmlClass_faqContentFont = saveDataItem.defaultFont /]                            
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
                        [#if item.value?? && item.value == 'faqTitleFont']           
                            [#assign htmlTarget_faqTitleFont = fontMap[saveDataItem.defaultFont?upper_case]! 'div' /]
                        [/#if]
                    [/#if]
                [/#list]
            [/#list]
            
        [/#if]
    [/#if]
    [@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!'1'}" limit="${pageSize!'10'}" version="v2" faqQueryType="${dataType!'0'}" searchFaqCateIds="${dataGroupId!''}" searchFaqIds="${dataIds!''}" loadMethod="${loadMethod!''}" cateId="${faqGroupId!'-1'}" orderBy="${orderBy!'0'}" expandIds="${expandIds!''}"  layoutStyle="${layoutStyle!''}" jumpMethod="${jumpMethod!''}"
            query='{ faqList(conditionDto: {page: $page$, limit: $limit$, faqCateIdByPage: "$cateId$", faqQueryType: "$faqQueryType$", searchFaqIds: "$searchFaqIds$", searchFaqCateIds: "$searchFaqCateIds$"}) {
                    totalRow
                    pageSize
                    pageNumber
                    list {
                    faqId
                    faqTitle
                    faqContent
                }
                }
                } ']
      <div class="block-listTemp-container-replace">
          <ul class="faq-box">
            [#if data?? && data.faqList?? && data.faqList.list?? && (data.faqList.list?size > 0)]
                [#list data.faqList.list as list]
                    <li>
                        <${htmlTarget_faqTitleFont!'div'} class="title ${htmlClass_faqTitleFont!'heading5'}">Q:&nbsp;${list.faqTitle!''}</${htmlTarget_faqTitleFont!'div'}>
                        <div class="content">
                            <div style="min-width: 20px;" class="${htmlClass_faqContentFont!'paragraph1'}">A:&nbsp;</div>
                            <div class="faqContent ${htmlClass_faqContentFont!'paragraph1'}"">${list.faqContent!''}</div>
                        </div>
                    </li>
                [/#list]
            [#else]
                <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
            [/#if]
          </ul>
          <input type="hidden" name="totalRow" value="${data.faqList.totalRow!'0'}"> 
          <input type="hidden" name="pageNumber" value="${data.faqList.pageNumber!'1'}">
          <input type="hidden" name="pageSize" value="${data.faqList.pageSize!'10'}">
      </div>
      
      [#if !loadMethod?? || loadMethod == '0']
          <div class="listTemp-site-pagination-77449 [#if data.faqList.pageSize?? && data.faqList.totalRow?? && (data.faqList.totalRow < data.faqList.pageSize || data.faqList.totalRow == data.faqList.pageSize)]hide[/#if]">
              <div class="listTemp-laypage-normal" id='listTemp-laypage-normal'></div>
          </div>
      [/#if]
    <script>
          $(function(){
              window._block_namespaces_['block_77449'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'faqList_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
          });
      </script>
[/@api]
  
</div>