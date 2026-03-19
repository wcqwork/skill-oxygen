<div data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            div.block35924 .ArticlePicList_ItemContentInnerBox {
                direction: rtl;
            }
            div.block35924 .classification {
                right: 0;
                left: auto;
            }
            .block35924 .slick-dots {      
                direction: ltr!important;
            }            
        </style>
    [/#if]    
  <div class="backstage-blocksEditor-wrap block35924" data-block-uuid="articlelist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber,dataOrderBy,showDate" 
  data-block-type="phoenix_blocks_Articlelist" 
  data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
    <style>
      [data-new-auto-uuid="${pageNodeId!''}"] {
        --color-match-setting1: var(--ld-main1,#f0850d);
        --color-match-setting2: var(--ld-Auxiliary1,#00448d);
        --color-match-setting3: var(--ld-Auxiliary2,#f0850d);
      }
    </style>

    <div class="Article_Container init_style">
        <div class="prev"><i class="icon iconfont_phoenix icon-jiantouzuo-5"></i></div>
        <div class="next"><i class="icon iconfont_phoenix icon-jiantouyou-5"></i></div>
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
                    <div class="articalWrap slick">
                    [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                        <div class="winget">
                        [#list data.articleList.list as article]
                        <div class="ArticlePicList_Item">
                            <!-- 文章分类 -->
                            [#if article.cateName??]
                                <div class="classification paragraph2">${article.cateName!''}</div> 
                            [/#if]
                            <div>
                                <picture class="img">
                                    <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!''}" />
                                    <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!''}" />
                                    <img class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!''}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                                </picture>
                            </div> 
                            <div class="ArticlePicList_ItemContent">
                                <div class="ArticlePicList_ItemContentInner">
                                    <div class="ArticlePicList_ItemContentInnerBox">
                                        <!-- 文章标题 -->
                                        <h3 class="ArticlePicList_ItemContentInnerH5">
                                            <a class="heading5" href="${article.articleUrl!''}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                        </h3>
                                        <!-- 文章发表日期 -->
                                        [#if showDate && showDate == 1]
                                        <time class="time paragraph2">
                                            ${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}/${article.publishTime?date("yyyy-MM-dd")?string('MM')}/${article.publishTime?date("yyyy-MM-dd")?string('dd')}                                        
                                        </time>
                                        [/#if]
                                        <!-- 文章摘要 -->
                                        <div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</div>
                                        <div class="ArticlePicList_ItemContentInnerTrans"></div>
                                    </div>
                                </div>
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
                        window._block_namespaces_['block35924'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                    });
                </script>
                <script type="application/ld+json">
                    ${data.articleList.extraData.articleStructureData!""}
                </script>
            [/@api]
        </div>
    </div>
</div>