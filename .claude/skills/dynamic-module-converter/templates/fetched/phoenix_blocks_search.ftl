<div class="backstage-blocksEditor-wrap wra block_77459" data-block-uuid="search"  data-gjs-type="developer-node-component"  data-block-type="phoenix_blocks_search" data-default-setting={"dataExpandIdsArr":"1,2,3,4,5,7,9","dataExpandSubIdsArr":"{&quot;1&quot;:&quot;1,4,2,7,8,6,11,9,10,5&quot;,&quot;2&quot;:&quot;1,3&quot;,&quot;3&quot;:&quot;1,2&quot;,&quot;4&quot;:&quot;1,2&quot;,&quot;5&quot;:&quot;1,2&quot;,&quot;7&quot;:&quot;1,2&quot;}","dataPlaceholder":"","dataExpandIds":{"showField":{"label":"字段","key":"showField","draggable":false,"data":[{"expand":{"expandSort":["showField"],"top":164,"maxHeight":485,"width":278,"show":false,"right":284,"label":"产品","type":"icon","detailSettingContent":{"name":"1","options":{"showField":{"draggable":false,"data":[{"fieldName":"产品名称","checked":true,"fieldType":"0","value":"1","fieldId":"name_or_title"},{"fieldName":"产品简介","checked":true,"fieldType":"0","value":"4","fieldId":"brief_or_summary"},{"fieldName":"型号","checked":true,"placeholder":"数值参与搜索","fieldType":"0","value":"2","fieldId":"models"},{"fieldName":"品牌","checked":true,"placeholder":"数值参与搜索","fieldType":"0","value":"7","fieldId":"more5"},{"fieldName":"商品编码","checked":true,"placeholder":"数值参与搜索","fieldType":"0","value":"8","fieldId":"more6"},{"fieldName":"自定义字段","checked":true,"placeholder":"数值参与搜索","fieldType":"0","value":"6","fieldId":"field_values"},{"fieldName":"产品私有属性","checked":true,"placeholder":"数值参与搜索","fieldType":"0","value":"11","fieldId":"cate_prop_values"},{"fieldName":"SKU编码","checked":true,"fieldType":"0","value":"9","fieldId":"sku_code"},{"fieldName":"条形码","checked":true,"fieldType":"0","value":"10","fieldId":"sku_bar_code"},{"fieldName":"产品描述","checked":true,"placeholder":"富文本文字参与搜索","fieldType":"0","value":"5","fieldId":"descript"}],"label":"字段","key":"showField"}},"label":"","type":"checkbox"},"zIndex":2},"fieldName":"产品","checked":true,"fieldType":"0","value":"1","fieldId":"invitationCode"},{"expand":{"expandSort":["showField"],"top":164,"maxHeight":485,"width":278,"show":false,"right":284,"label":"文章","type":"icon","detailSettingContent":{"name":"1","options":{"showField":{"draggable":false,"data":[{"fieldName":"标题","checked":true,"fieldType":"0","value":"1","fieldId":"name_or_title"},{"fieldName":"文章内容","checked":true,"fieldType":"0","value":"3","fieldId":"text"}],"label":"字段","key":"showField"}},"label":"","type":"checkbox"},"zIndex":2},"fieldName":"文章","checked":true,"fieldType":"0","value":"2","fieldId":"sexFlag"},{"expand":{"expandSort":["showField"],"top":164,"maxHeight":485,"width":278,"show":false,"right":284,"label":"视频","type":"icon","detailSettingContent":{"name":"1","options":{"showField":{"draggable":false,"data":[{"fieldName":"视频名称","checked":true,"fieldType":"0","value":"1","fieldId":"name_or_title"},{"fieldName":"视频描述","checked":true,"fieldType":"0","value":"2","fieldId":"brief_or_summary"}],"label":"字段","key":"showField"}},"label":"","type":"checkbox"},"zIndex":2},"fieldName":"视频","checked":true,"fieldType":"0","value":"5","fieldId":"companyFlag"},{"expand":{"expandSort":["showField"],"top":164,"maxHeight":485,"width":278,"show":false,"right":284,"label":"图册","type":"icon","detailSettingContent":{"name":"1","options":{"showField":{"draggable":false,"data":[{"fieldName":"图册名称","checked":true,"fieldType":"0","value":"1","fieldId":"name_or_title"},{"fieldName":"图册描述","checked":true,"fieldType":"0","value":"2","fieldId":"brief_or_summary"}],"label":"字段","key":"showField"}},"label":"","type":"checkbox"},"zIndex":2},"fieldName":"图册","checked":true,"fieldType":"0","value":"7","fieldId":"telFlag"},{"expand":{"expandSort":["showField"],"top":164,"maxHeight":485,"width":278,"show":false,"right":284,"label":"下载","type":"icon","detailSettingContent":{"name":"1","options":{"showField":{"draggable":false,"data":[{"fieldName":"文件名称","checked":true,"fieldType":"0","value":"1","fieldId":"name_or_title"},{"fieldName":"摘要","checked":true,"fieldType":"0","value":"2","fieldId":"brief_or_summary"}],"label":"字段","key":"showField"}},"label":"","type":"checkbox"},"zIndex":2},"fieldName":"下载","checked":true,"fieldType":"0","value":"3","fieldId":"btdFlag"},{"expand":{"expandSort":["showField"],"top":164,"maxHeight":485,"width":278,"show":false,"right":284,"label":"FAQ","type":"icon","detailSettingContent":{"name":"1","options":{"showField":{"draggable":false,"data":[{"fieldName":"FAQ标题","checked":true,"fieldType":"0","value":"1","fieldId":"name_or_title"},{"fieldName":"FAQ内容","checked":true,"fieldType":"0","value":"2","fieldId":"descript"}],"label":"字段","key":"showField"}},"label":"","type":"checkbox"},"zIndex":2},"fieldName":"FAQ","checked":true,"fieldType":"0","value":"4","fieldId":"webUrlFlag"},{"fieldName":"页面","checked":true,"fieldType":"0","value":"9","fieldId":"addressFlag"}]}},"dataType":"0","dataMode":"0","dataKeyWord":"1","dataCode":[{"placeholder":"请输入","value":""},{"placeholder":"请输入","value":""},{"placeholder":"请输入","value":""},{"placeholder":"请输入","value":""},{"placeholder":"请输入","value":""},{"placeholder":"请输入","value":""}]}>
    [@api method="post" url="/phoenix2/composite/graphql"
            dataPlaceholder="${dataPlaceholder!''}" dataExpandIds="${dataExpandIds!''}" dataType="${dataType!'1'}" dataExpandIdsArr="${dataExpandIdsArr!'1,2,3,4,5,7,9'}" dataExpandSubIdsArr="${dataExpandSubIdsArr!''}"
            dataMode="${dataMode!'1'}" dataKeyWord="${dataKeyWord!''}"  dataCode="${dataCode!''}" 
			query='' ]
            <div>
                [#if dataType == '0']
                    [#assign dataTypeAlt = '1']
                [/#if]
                [#if dataType == '1']
                    [#assign dataTypeAlt = '2']
                [/#if]

                [#if dataMode == '0']
                    [#assign dataModeAlt = '1']
                [/#if]
                [#if dataMode == '1']
                    [#assign dataModeAlt = '2']
                [/#if]

                <form action="/phoenix/admin/siteSearch/search/v2"  method="get" novalidate>
                    <div class="search-box">
                        <div class="search-input">
                            <input class="input-text" type="text" name="searchValue" value="${searchValue!''}" placeholder="${dataPlaceholder!''}" autocomplete="off"/>

                            <input type="hidden" name="searchScope" value="${dataExpandIdsArr!'1,2,3,4,5,7,9'}" />
                            <input type="hidden" name="subSearchScope" value="${dataExpandSubIdsArr!''}" />
                            <input type="hidden" name="searchType" value="${dataTypeAlt!'1'}" />
                            <input type="hidden" name="searchMethod" value="${dataModeAlt!'1'}" />

                            <input type="hidden" name="linkageRelationId" value="${relationId!''}" />
                            <input type="hidden" name="linkageRelationType" value="${relationType!''}" />
                            <input type="hidden" name="linkagePageId" value="${pageId!''}" />
                            <input type="hidden" name="linkagePageNodeId" value="${nodeId!''}" />
                        </div>
                         <button class="search-btn" type="submit">
                            
                            <i class="iconfont iconfont_phoenix icon-sousuo-2"></i>
                        </button>
                    </div>
                </form>
                [#if dataKeyWord?? && dataKeyWord == '1' && dataCode??]
                <ul class="recommended-words">
                    [#assign dataCodeJSON=dataCode?eval /]
                    [#list dataCodeJSON as data]
                        [#if data.value !='']
                            <li class="paragraph1">${data.value}</li>
                        [/#if]
                    [/#list]
                </ul>
                [/#if]
               
                
            </div>
            <script>
                $(function(){
                    window._block_namespaces_['search77459'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'search_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
            </script>  
    [/@api]
</div>