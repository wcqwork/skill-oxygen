<div data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            .block34914 .articalWrap .ArticlePicList_Item {
                    direction: rtl;
            }
        </style>
    [/#if]
    <style>
        .block34914 .wrapper {
            width: 100%;
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            grid-column-gap: 30px;
        }
    </style>

  <div class="backstage-blocksEditor-wrap block34914" data-block-uuid="articlelist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,loadMethod,pageNumber,dataOrderBy,showDate" 
  data-block-type="phoenix_blocks_Articlelist" 
  data-default-setting={"pageSize":3,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
    <style>
      [data-new-auto-uuid="${pageNodeId!''}"] {
        --color-match-setting1: var(--ld-main1, rgb(255,106,0));
        --color-match-setting2: var(--ld-Auxiliary1, rgb(0, 77, 158));
      }
    </style>
    <div class="Article_Container">
        [@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"
            selectArticleCateType="${dataType!'0'}" selectCateIds="${dataGroupId!''}" selectArticleIds="${dataIds!''}"
            orderBy="${orderBy!'0'}" expandIds="${expandIds!''}" articleId="${infoId!-1}" articlePageId="${infoGroupId!-1}"
			query='{
				articleList(
                    conditionDto:{
                    page: $page
                    limit: $limit
                    optionsParam: $optionsParam
                    selectCateIds: $selectCateIds
                    selectArticleIds: $selectArticleIds
                    selectArticleCateType: "$selectArticleCateType"
                    orderBy: "$orderBy"
                    articleRelatedId: "$articleId"
                    articlePageId: "$articlePageId"
                    }) {
                    totalRow
                    pageSize
                    pageNumber
                    extraData{
                        articleStructureData
                    }
                    list{
                        encodeId
                        articleTitle
                        publishTime
                        articleUrl
                        articleSummary
                        topFlag
                        photoUrlNormal
                        photoUrlDefine
                        cateName
                        cateUrl
                        showFieldList
                        $showField
                        photoSeoList{
                            photoId
                            photoUrlNormal
                            photoAlt
                            photoTitle
                        }
                    }
                }
			}']
            
            <div class="articalWrap34914 articalWrap wrapper">
                [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                    [#list data.articleList.list as article]
                        <div class="ArticlePicList_Item tile">
                            <div class="imgBox">
                                <picture>
                                    <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!''}" />
                                    <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!''}" />
                                    <img class="headlines-content-img ArticlePicList_ItemImg lazyimg" src="${article.photoUrlNormal}" alt="${article.photoSeoList[0].photoAlt!?html}" title="${article.photoSeoList[0].photoTitle!?html}">
                                </picture>
                            </div> 
                            <div class="ArticlePicList_ItemContent textBox">
                                <div class="ArticlePicList_ItemContentInner detail">
                                    <div class="ArticlePicList_ItemContentInnerBox">
                                        [#if showDate && showDate == 1]<time class="time paragraph2">${article.publishTime}</time>[/#if]
                                        <h3 class="ArticlePicList_ItemContentInnerH5 title">
                                            <a class="heading5" href="${article.articleUrl!''}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                        </h3> 
                                        <div class="articleList-summary ArticlePicList_ItemContentInnerP none paragraph1">${article.articleSummary!''}</div>
                                        <a href="${article.articleUrl!''}" title="${article.articleTitle!?html}"><span class="paragraph2">[@s.m "phoenix_view_more"/]<i class="icon iconfont_phoenix icon-angle-double-right"></i></span></a>
                                        <div class="ArticlePicList_ItemContentInnerTrans"></div>
                                    </div>
                                </div>
                            </div>
                        </div>    
                    [/#list]
                [#else]
                    <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                [/#if]
            </div>
            <input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}"> 
            <input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
            <input type="hidden" name="pageSize" value="${data.articleList.pageSize!'10'}">

            [#if (dataType?? && dataType != '3') && (!loadMethod?? || loadMethod == '0') && !(data.articleList.pageSize?? && data.articleList.totalRow?? && data.articleList.totalRow <=  data.articleList.pageSize)]
                <div class="pagination">
                    <div class="artclelist-laypage-normal" id='artclelist-laypage-normal'></div>
                </div>
            [/#if]
        	<script>
                $(function(){
                    window._block_namespaces_['block34914'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
            </script>
             <script type="application/ld+json">
                 ${data.articleList.extraData.articleStructureData!""}
            </script>
	    [/@api]
    </div>
  </div>
</div>