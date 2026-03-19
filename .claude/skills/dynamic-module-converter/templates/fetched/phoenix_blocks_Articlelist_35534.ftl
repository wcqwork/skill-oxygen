<div class="block35534" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <style data-collect='1'>
            .block35534 .Box .ArticlePicList_ItemContentInnerBox .articleList-summary {
                text-align: right;
            }
            div.block35534 .Box .Opction .iconFlex .ArticlePicList_ItemContentInnerA {
                padding: 5px 7px 5px 25px;
            }            
            div.block35534 .Box .Opction .iconFlex .buttons {
                margin-left: 0;
                margin-right: 10px;
            }  
            div.block35534 .Box .Flexnumber .ArticlePicList_ItemContentInnerH5 {
                margin-left: 0;
                margin-right: 10px;
            }
            .block35534 .slick-dots {   
                direction: ltr!important;
            }                                  
        </style>
    [/#if]
    <div data-block-uuid="articlelist" data-gjs-type="developer-node-component"
        data-block-list-setting="dataSelect,dataOrderBy,pageNumber" data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":4,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
        <style>
            [data-new-auto-uuid="${pageNodeId!''}"] {
                --color-match-setting1: var(--ld-main1, #FF7A01);
                --color-match-setting2: var(--ld-Auxiliary1, #F41802);
            }
        </style>
        
        <div class="Box">
            <div class="Bottom">
                <div class="jiantou">
                    <div class="Left">
                        <svg t="1661244167990" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="84500" width="16" height="16"><path d="M362.610347 512l396.401777-388.551111a56.547556 56.547556 0 1 0-79.189333-80.782222L245.305458 468.650667A60.757333 60.757333 0 0 0 227.556124 512c0 16.497778 6.485333 32.199111 17.749334 43.349333l434.631111 425.984a56.547556 56.547556 0 0 0 79.075555-80.782222L362.610347 512z" fill="#ffffff" p-id="84501"></path></svg>
                    </div>
                    <div class="Right">
                        <svg t="1661244223193" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="84756" width="16" height="16"><path d="M661.389084 511.544889L264.987307 123.335111a56.547556 56.547556 0 0 1 79.075555-80.782222l434.631111 425.642667c11.377778 11.150222 17.749333 26.851556 17.749334 43.235555a60.643556 60.643556 0 0 1-17.749334 43.349333l-434.631111 425.642667a56.547556 56.547556 0 0 1-79.075555-80.782222l396.401777-388.096z" fill="#ffffff" p-id="84757"></path></svg>
                    </div>
                </div>
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
                            <div class="ListS">
                            [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                                [#list data.articleList.list as article]
                                    <div class="ArticlePicList_Item">
                                        <a class="ArticlePicList_ItemContentInnerAe" href="${article.articleUrl}"></a>
                                        <div class="imgBox">
                                            <picture>
                                                <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
                                                <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />
                                                <img loading="lazy" class="headlines-content-img ArticlePicList_ItemImg lazyimg" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}" />
                                            </picture>
                                        </div> 
                                        <div class="ArticlePicList_ItemContent">
                                            <div class="ArticlePicList_ItemContentInner">
                                                <div class="ArticlePicList_ItemContentInnerBox">
                                                    <div class="Flexnumber">
                                                        <div class="number">01</div>
                                                        <h3 class="ArticlePicList_ItemContentInnerH5 heading5">
                                                            ${article.articleTitle!?html}
                                                        </h3>
                                                    </div>
                                                    <div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</div>
                                                    <div class="ArticlePicList_ItemContentInnerTrans"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="Opction">
                                            <h3 class="ArticlePicList_ItemContentInnerH5 heading5">
                                                ${article.articleTitle!?html}
                                            </h3>
                                            <div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">
                                                ${article.articleSummary!''}
                                            </div>
                                            <div class="bag">
                                                <div class="iconFlex">
                                                    <a class="ArticlePicList_ItemContentInnerA paragraph2" href="${article.articleUrl}">
                                                        <span class="icon">
                                                            <svg t="1661239064660" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="35706" width="20" height="20"><path d="M0 576h448v448h128V576h448V448H576V0.128L448 0v448H0z" p-id="35707" fill="#FF7A01"></path></svg>
                                                        </span>
                                                        <span class="buttons">
                                                            [@s.m "phoenix_read_more" /]
                                                        </span>
                                                    </a>
                                                </div>
                                            </div>        
                                        </div>
                                    </div>
                                [/#list]
                            [#else]
                                <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                            [/#if]
                            </div>
                        [/@api]
                    </div>
                </div>
            </div>
        </div>
		<script>
            $(function () {
                window._block_namespaces_['block35534'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
            });
        </script>
    </div>
</div>