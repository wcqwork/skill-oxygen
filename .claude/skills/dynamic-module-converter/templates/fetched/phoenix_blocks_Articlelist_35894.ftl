<div data-gjs-type="phoenix-container" data-strong="1">
  <div class="backstage-blocksEditor-wrap block35894" data-block-uuid="articlelist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber,dataOrderBy,showDate" 
  data-block-type="phoenix_blocks_Articlelist" 
  data-default-setting={"pageSize":8,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
    <style>
      [data-new-auto-uuid="${pageNodeId!''}"] {
        --color-match-setting1: var(--ld-main1,rgb(7, 172, 102));
        --color-match-setting2: var(--ld-Auxiliary1,#333333);
      }
    </style>

    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            
        </style>
    [/#if]


    <div class="Article_Container">
        <div class="prev"></div>
        <div class="next"></div>
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
                                photoSeoList{
                                    photoId
                                    photoUrlNormal
                                    photoAlt
                                    photoTitle
                                }
                                photoUrlNormal
                                photoUrlDefine
                                cateName
                                cateUrl
                                showFieldList
                                $showField
                            }
                        }
                    }']
                    <div class="wrapper" style="display:flex">
                    [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                        [#list data.articleList.list as article]
                        <div class="ArticlePicList_Item tile">
                            [#if showDate && showDate == 1]
                            <time class="time paragraph2">
                                ${article.publishTime?date("yyyy-MM-dd")?string('dd')}.${article.publishTime?date("yyyy-MM-dd")?string('MM')}.${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}                                        
                            </time>
                            [/#if]

                            <div class="line"></div>
                            <div class="bottom">
                                <div class="before"></div>
                                <div class="imgBox">
                                    <a href="${article.articleUrl!''}" title="${article.articleTitle!?html}">
                                        <picture>
                                            <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!''}" />
                                            <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!''}" />
                                            <img class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!''}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                                        </picture>
                                    </a>
                                </div> 
                                <div class="ArticlePicList_ItemContent textBox">
                                    <div class="ArticlePicList_ItemContentInner textWra">
                                        <div class="ArticlePicList_ItemContentInnerBox">
                                            <h3 class="ArticlePicList_ItemContentInnerH5 title heading3">
                                                <a href="${article.articleUrl!''}" title="${article.articleTitle!?html}" class="heading3">${article.articleTitle!?html}</a>
                                            </h3>
                                            <div class="articleList-summary ArticlePicList_ItemContentInnerP content paragraph2">
                                                <p class="paragraph1">
                                                ${article.articleSummary!''}
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                        </div>
                        [/#list]
                    [#else]
                        <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                    [/#if]

                </div>
                <script>
                    $(function(){
                        window._block_namespaces_['block35894'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                    });
                </script>
                <script type="application/ld+json">
                    ${data.articleList.extraData.articleStructureData!""}
                </script>
            [/@api]
        </div>
    </div>
</div>