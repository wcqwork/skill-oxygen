<div class="backstage-blocksEditor-wrap wra block_77457" data-block-uuid="keywordList"  data-gjs-type="developer-node-component" data-setting-type="noSetting" data-block-type="phoenix_blocks_keywordlist" data-default-setting={}>

    [@api method="post" version="v2" url="/phoenix2/composite/graphql" page="${page!1}" limit="${pageSize!'10'}" start="${keywordIndex!''}"
        query='{
        keywordList(conditionDto:{page: $page$, limit: 60, keywordStart: "$start$"}) {
                    totalRow
                    pageSize
                    pageNumber
                    
                    list{
                        encodeId
                        keyword
                        keywordUrl
                    }
                }
			}']
            <div class="block-listTemp-container-replace">
                <p class="select-title heading3">Keywords Starting With the Letter ${keywordIndex!''}</p>
                <div class="list-box">
                [#if data.keywordList?? && data.keywordList.list?? && data.keywordList.list?size != 0]
                    [#list data.keywordList.list as keyword]
                    <p class="list-item"><a class="paragraph1" href="${keyword.keywordUrl}">${keyword.keyword}</a></p>		
                    [/#list]
				[#else]
                   <p class="order-empty">[@s.m "PHENIX2_NO_KEYWORDS" /]!</p>  
                [/#if]
                </div>
                <input type="hidden" name="totalRow" value="${data.keywordList.totalRow!'0'}"> 
                <input type="hidden" name="pageNumber" value="${data.keywordList.pageNumber!'1'}">
                <input type="hidden" name="pageSize" value="${data.keywordList.pageSize!'60'}">
            </div>

            <div class="listTemp-site-pagination-77457 [#if data.keywordList.totalRow?? && data.keywordList.pageSize?? && (data.keywordList.totalRow < data.keywordList.pageSize || data.keywordList.totalRow == data.keywordList.pageSize)]hide[/#if]">
                <div class="listTemp-laypage-normal" id='listTemp-laypage-normal'></div>
            </div>

        	<script>
                $(function(){
                    window._block_namespaces_['keywordList_77457'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'keywordList_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
            </script>
	[/@api]
</div>