<div data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            .block34864 .textBox{
                    text-align: right;
            }
        </style>
    [/#if]
<div class="block34864" data-block-uuid="articlelist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,dataOrderBy,showDate"  data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
    <style>
      [data-new-auto-uuid="${pageNodeId!''}"] {
        --color-match-setting1: var(--ld-main1, #878244);
        --color-match-setting2: var(--ld-Auxiliary1, #111);
      }
    </style>
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
                    }
                }
			}']
        <div class="Article_Container">
        <div class="wra">
             [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
            <div class="first">                
                <div class="zhezhao"></div>
                [#list data.articleList.list as article]
                   [#if article_index == 0]
                            <div class="ArticlePicList_ItemContent textBox">
                                <div class="ArticlePicList_ItemContentInner textBox2">
                                    <div class="ArticlePicList_ItemContentInnerBox textBox3">
                                        <div class="top">
                                            <div class="name">${article.cateName!''}</div>
                                            <h3 class="ArticlePicList_ItemContentInnerH5 title"> 
                                                 <a class="artwaterfall-titless" href="${article.articleUrl!''}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                            </h3>
                                             [#if showDate && showDate == 1]
                                            <div class="time"><i class="icon iconfont_phoenix icon-rili lead_icon lead-icon-type"></i> <time>${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}/${article.publishTime?date("yyyy-MM-dd")?string('MM')}/${article.publishTime?date("yyyy-MM-dd")?string('dd')}</time></div>
                                            [/#if]
                                        </div>
                                        <div class="bottom">
                                            
                                            <p class="content articleList-summary ArticlePicList_ItemContentInnerP">${article.articleSummary!''}</p> 
                                             <a class="button ArticlePicList_ItemContentInnerA" href="${article.articleUrl!''}" title="${article.articleTitle!?html}"><span>[@s.m "phoenix_read_more" /]</span><i class="icon iconfont_phoenix icon-jiantouyou lead_icon lead-icon-type"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="imgBox">
                                    <img class="headlines-content-img ArticlePicList_ItemImg" loading="lazy" src="${article.photoUrlNormal!''}" alt="${article.articleTitle!?html}">
                            </div>
                    [/#if]
                [/#list]
            </div>

            <div class="wrapper">
                 [#list data.articleList.list as article]
                <div class="ArticlePicList_Item tile">
                    <div class="ArticlePicList_ItemContent textBox">
                        <div class="ArticlePicList_ItemContentInner textBox2">
                            <div class="ArticlePicList_ItemContentInnerBox textBox3">
                                <div class="top">
                                    <div class="name">${article.cateName!''}</div>
                                    <h3 class="ArticlePicList_ItemContentInnerH5 title">
                                          <a  href="${article.articleUrl!''}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                         </h3>
                                     [#if showDate && showDate == 1]
                                    <div class="time"><i class="icon iconfont_phoenix icon-rili lead_icon lead-icon-type"></i><time>${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}/${article.publishTime?date("yyyy-MM-dd")?string('MM')}/${article.publishTime?date("yyyy-MM-dd")?string('dd')}</time></div>
                                    [/#if]
                                </div>
                                <div class="bottom">
                                    
                                    <p class="content articleList-summary ArticlePicList_ItemContentInnerP">${article.articleSummary!''}</p> 
                                   
                                     <a class="button ArticlePicList_ItemContentInnerA" href="${article.articleUrl!''}" title="${article.articleTitle!?html}"><span>[@s.m "phoenix_read_more" /]</span><i class="icon iconfont_phoenix icon-jiantouyou lead_icon lead-icon-type"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="imgBox">
                        <img class="headlines-content-img ArticlePicList_ItemImg" loading="lazy" src="${article.photoUrlNormal!''}" alt="${article.articleTitle!?html}">
                    </div>
                </div>
                      [/#list]
                </div>
                [#else]
                    <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                 [/#if]
    </div>
<script>
    $(function(){
        window._block_namespaces_['block34864'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
    });
</script>
    <script type="application/ld+json">
        ${data.articleList.extraData.articleStructureData!""}
</script>
</div>
[/@api]
</div>
</div>