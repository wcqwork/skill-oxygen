<div class="backstage-blocksEditor-wrap wra block_28984" data-block-uuid="commentList"  data-gjs-type="developer-node-component" data-block-type="phoenix_blocks_commentList" data-default-setting={"dataType":"0","dataIds":[],"loadMethod":"0","pageSize":10,"page":1,"translationEntry":[]}>
    [@api method="post" version="v2" url="/phoenix2/composite/graphql"
      dataType="${dataType!'2'}" page="${page!1}" dataIds="${dataIds!'[]'}" pageId="${pageId!''}" pageNum="${pageSize!'10'}" loadMethod="${loadMethod}"
        query='{
          commentList(
              conditionDto: {
                page: $page$,           
                limit: $pageNum$,
                selectCommentType: "$dataType$",
	          		selectCommentIds:"$dataIds$",
                pageId:"$pageId$",
              }
            ) {
              totalRow   
              pageSize   
              pageNumber 
              extraData{
                avgCommentStar
              }
              list {
                encodeId   
                commentTitle 
                commentStar 
                remark  
                commentType 
                commentTime   
                adderTime	
                adderNo	
                adderName	
                updaterTime	
                updaterNo	
                updaterName	
                commentContent	
                photos	
                logonName		
                iconUrl    
                replyContent {
                  encodeId
                  commentContent
                }    
            	}
            }
            
}']

      <div class="block-listTemp-container-replace">
          <div class="all_reviews_info">
            <div class="all_star_info">
              <div class="all_star_left need_init_star" data-num="${data.commentList.extraData.avgCommentStar!'0'}">
                <div class="c_star c_star_empty"></div>
                <div class="c_star c_star_empty"></div>
                <div class="c_star c_star_empty"></div>
                <div class="c_star c_star_empty"></div>
                <div class="c_star c_star_empty"></div>
              </div>
              <div class="all_star_right default_font">${data.commentList.extraData.avgCommentStar!'0'}<span>/</span>5</div>
            </div>
            <div class="all_comment_num default_font">${data.commentList.totalRow!'0'} Riew</div>
          </div>
          <ul class="block-listTemp-container block-listTemp-container-28984">
              [#if data?? && data.commentList?? && data.commentList.list?? && (data.commentList.list?size > 0)]
                [#list data.commentList.list as dataItem]
                  <li class="block_listTemp_item">
                    <div class="listTemp_item_star">
                      <div class="star_left need_init_star" data-num="${dataItem.commentStar}">
                        <div class="c_star c_star_empty"></div>
                        <div class="c_star c_star_empty"></div>
                        <div class="c_star c_star_empty"></div>
                        <div class="c_star c_star_empty"></div>
                        <div class="c_star c_star_empty"></div>
                      </div>
                      <div class="time_right default_font">${dataItem.commentTime}</div>
                    </div>
                    <div class="listTemp_item_name title_font">
                      <span>${dataItem.adderName}</span>
                      [#if dataItem.iconUrl?? && dataItem.iconUrl != '']
                      <img class="c_icon_img" src="${dataItem.iconUrl!?html}" alt="icon">
                      [/#if]
                    </div>
                    <div class="listTemp_item_title title_font">${dataItem.commentTitle}</div>
                    <div class="listTemp_item_content need_show_more">
                      <div class="c_content_main default_font">${dataItem.commentContent!?replace('<', '&lt;')?replace('>', '&gt;')?replace('"', '&quot;')?replace('\'', '&#39;')?replace('\n', '<br/>')}</div>
                      <div class="c_read_more title_font hide">
                        ...Read More
                      </div>
                    </div>
                    [#if dataItem.replyContent.commentContent?? ]
                    <div class="listTemp_item_reply">
                      <div class="listTemp_item_reply_name title_font">Reply：</div>
                      <div class="listTemp_item_reply_content need_show_more">
                        <div class="c_content_main default_font">
                          ${dataItem.replyContent.commentContent!?replace('<', '&lt;')?replace('>', '&gt;')?replace('"', '&quot;')?replace('\'', '&#39;')?replace('\n', '<br/>')}
                        </div>
                        <div class="c_read_more title_font hide">
                          ...Read More
                        </div>
                      </div>
                    </div>
                    [/#if]
                    [#if dataItem.photos?? ]
                    <div class="listTemp_item_img">
                      [#list dataItem.photos as photo]
                      <div class="c_img_box">
                        <img class="c_img" data-original="${photo!?html}" src="${photo!?html}" alt="img">
                      </div>
                      [/#list]
                    </div>
                    [/#if]
                  </li>
                [/#list]
                [#else]
              <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
              [/#if]
          </ul>
          <input type="hidden" name="totalRow" value="${data.commentList.totalRow!'0'}"> 
          <input type="hidden" name="pageNumber" value="${data.commentList.pageNumber!'1'}">
          <input type="hidden" name="pageSize" value="${data.commentList.pageSize!'10'}">
      </div>
      [#if !loadMethod?? || loadMethod == '0']
        <div class="listTemp-site-pagination-28984 [#if data.commentList.pageSize?? && data.commentList.totalRow?? && data.commentList.totalRow <=  data.commentList.pageSize]hide[/#if]">
            <div class="listTemp-laypage-normal" id='listTemp-laypage-normal'></div>
        </div>
      [/#if]
    <script>
          $(function(){
              window._block_namespaces_['commentList_28984'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'commentList_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
          });
      </script>
[/@api]
  
</div>