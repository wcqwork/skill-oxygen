<div class="block34974" data-gjs-type="phoenix-container" data-strong="1">
    <div data-block-uuid="articlelist" data-gjs-type="developer-node-component"
        data-block-list-setting="dataSelect,dataOrderBy,pageNumber,showDate" data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
        <style>
            [data-new-auto-uuid="${pageNodeId!''}"] {
                --color-match-setting1: var(--ld-main1, #f90);
            }
        </style>
        
        <div class="Article_Container">
            <div class="articalWrap">
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
                                photoSeoList{
                                    photoId
                                    photoUrlNormal
                                    photoAlt
                                    photoTitle
                                }

                                photoUrlDefine
                                cateName
                                cateUrl
                                showFieldList
                                $showField
                            }
                        }
                    }']
                    [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                    <div class="wrapper">
                        [#list data.articleList.list as article]
                        <div class="ArticlePicList_Item tile">
                            <div class="imgBox">
                                <picture>
                                    <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
                                    <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" /> 
                                    <img loading="lazy" class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}" />
                                </picture>
                            </div>
                            <div class="ArticlePicList_ItemContent textBox">
                                <div class="ArticlePicList_ItemContentInnerBox">
                                    [#if showDate && showDate == 1]
                                    <div class="time paragraph2">
                                        <time>${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}-${article.publishTime?date("yyyy-MM-dd")?string('MM')}-${article.publishTime?date("yyyy-MM-dd")?string('dd')}</time>
                                    </div>
                                    [/#if]
                                    <h3 class="ArticlePicList_ItemContentInnerH3 title heading5"> 
                                        <a href="${article.articleUrl}" title="${article.articleTitle!?html}" class="heading5">${article.articleTitle!?html}</a>
                                    </h3> 
                                    <a class="ArticlePicList_ItemContentInnerA butt paragraph2 link1" href="${article.articleUrl}" ><span>[@s.m "phoenix_view_more" /]</span></a>
                                    
                                    <div class="ArticlePicList_ItemContentInnerTrans"></div>
                                </div>
                            </div>
                            <div class="overlay">
                                <div class="ArticlePicList_ItemContentInnerBox">
                                    [#if showDate && showDate == 1]
                                    <div class="time paragraph2">
                                        <time>${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}-${article.publishTime?date("yyyy-MM-dd")?string('MM')}-${article.publishTime?date("yyyy-MM-dd")?string('dd')}</time>
                                    </div>
                                    [/#if]
                                    <h3 class="ArticlePicList_ItemContentInnerH3 title heading5"> 
                                        <a href="${article.articleUrl}" title="${article.articleTitle!?html}" class="heading5">${article.articleTitle!?html}</a>
                                    </h3> 
                                    <div class="articleList-summary ArticlePicList_ItemContentInnerP content paragraph1">${article.articleSummary!''}</div>
                                    <a class="ArticlePicList_ItemContentInnerA butt paragraph2 link1" href="${article.articleUrl}" ><span>[@s.m "phoenix_view_more" /]</span></a>
                                    <div class="ArticlePicList_ItemContentInnerTrans"></div>
                                </div>
                            </div>
                        </div>
                        [/#list] 
                    </div>
                    [#else]
                        <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                    [/#if]
                [/@api]
            </div>
        </div>

        <script>
            $(function () {
                window._block_namespaces_['block34974'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
            });
        </script>
    </div>
</div>