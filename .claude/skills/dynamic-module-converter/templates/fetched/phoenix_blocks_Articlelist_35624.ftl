<div class="block35624" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <style data-collect='1'>
            .block35624 .title {
                text-align: right;
            }
            div.block35624 span.icon {
                padding-right: 0;
                padding-left: 0.8em;
            }            
            .block35624 .button {
                right: 30px;
                left: auto;
            }
            div.block35624 .arrow {
                margin-left: 0;
                margin-right: 10px;
                transform: rotate(180deg);
                display: inline-block;
            }            
        </style>
    [/#if]
    <div data-block-uuid="articlelist" data-gjs-type="developer-node-component"
        data-block-list-setting="dataSelect,dataOrderBy,loadMethod,pageNumber,showDate" data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":4,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
        <style>
            [data-new-auto-uuid="${pageNodeId!''}"] {
                --color-match-setting1: var(--ld-main1, #2895D7);
                --color-match-setting2: var(--ld-Auxiliary1, #ACC3D1);
            }
        </style>
        
        <div class="backstage-blocksEditor-wrap wrapper">
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
                <div class="block-article-container-replace">
                    [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                        [#list data.articleList.list as article]
                        <div class="ArticlePicList_Item tile">
                            <div class="ArticlePicList_ItemContent textBox">
                                <div class="ArticlePicList_ItemContentInner">
                                    <div class="ArticlePicList_ItemContentInnerBox">
                                        <div class="timeBox">
                                            <span class="icon"><i class="icon iconfont_phoenix icon-rili"></i></span>
                                            <span class="name"> 
                                                [#if article.cateName??]                                                
                                                    [#if article.cateUrl??]
                                                    <a class="article-cate paragraph2" href="${article.cateUrl}" title="${article.cateName!?html}">${article.cateName!?html}</a>
                                                    [#else]
                                                    <span class="article-cate paragraph2">${article.cateName!?html}</span>
                                                    [/#if]
                                                [/#if]
                                            </span>
                                            [#if showDate && showDate == 1]
                                            <div class="time">
                                                <time>
                                                    <span class="time paragraph2">-${article.publishTime?date("yyyy-MM-dd")?string('dd')}/${article.publishTime?date("yyyy-MM-dd")?string('MM')}/${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}</span>
                                                </time>
                                            </div>
                                            [/#if]
                                        </div>
                                        <h3 class="ArticlePicList_ItemContentInnerH5 title">
                                            <a class="heading5" href="${article.articleUrl}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                        </h3>
                                        <p class="articleList-summary ArticlePicList_ItemContentInnerP content paragraph1">${article.articleSummary!''}</p>
                                        <a class="ArticlePicList_ItemContentInnerA button" href="${article.articleUrl}" title="${article.articleTitle!?html}">
                                            <span class="paragraph2">[@s.m "phoenix_read_more" /]</span>
                                            <span class="arrow"><i class="icon iconfont_phoenix icon-jiantouyou"></i></span>
                                        </a>
                                        <div class="ArticlePicList_ItemContentInnerTrans"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="textMask"></div> 
                            <div class="imgBox">
                                <picture>
                                    <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
                                    <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" /> 
                                    <img loading="lazy" class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}"> 
                                </picture>
                            </div>
                        </div>
                        [/#list]
                    [#else]
                        <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                    [/#if]
                    <input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}"> 
                    <input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
                    <input type="hidden" name="pageSize" value="${data.articleList.pageSize!'10'}">
                </div>

                [#if (dataType?? && dataType != '3') && (!loadMethod?? || loadMethod == '0') && !(data.articleList.pageSize?? && data.articleList.totalRow?? && data.articleList.totalRow <=  data.articleList.pageSize)]
                    <div class="artclelist-site-pagination">
                        <div class="artclelist-laypage-normal" id='artclelist-laypage-normal'></div>
                    </div>
                [/#if]
                <script>
                    $(function(){
                        window._block_namespaces_['block35624'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                    });
                </script>
                <script type="application/ld+json">
                    ${data.articleList.extraData.articleStructureData!""}
                </script>
            [/@api]
        </div>
    </div>
</div>