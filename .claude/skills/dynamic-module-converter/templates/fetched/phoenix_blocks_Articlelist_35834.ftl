<div class="block35834" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            .block35834 .Article_Container * {
                text-align: right;
                direction: rtl;
            }
            @media screen and (max-width: 768px) {
                div.block35834 h3,
                div.block35834 .ArticlePicList_ItemContentInnerP {
                    left: auto;
                    right: 16px;
                }
                div.block35834 .ArticlePicList_Item.item .time {
                    text-align: right;
                    direction: rtl;
                }                
            }
            .block35834 .artclelist-site-pagination .layui-laypage-prev,
            .block35834 .artclelist-site-pagination .layui-laypage-next {
                transform: rotate(180deg);
            }
            @media (min-width: 767px) {
                div.block35834 .ArticlePicList_ItemContentInnerBox .article_content_right h3 {
                    position: relative;
                    transform: translateX(50%);
                    left: auto;
                    right: 50%;
                }
                div.block35834 .ArticlePicList_ItemContentInnerBox .article_content_right .ArticlePicList_ItemContentInnerP {
                    position: relative;
                    transform: translateX(50%);
                    left: auto;
                    right: 50%;
                } 
                div.block35834 .item:hover .shadow img {
                    left: auto;
                    right: 25%;
                    transform: rotate(180deg);
                }    
                div.block35834 .item:hover .shadow img {
                    transition: left 0.5s, right 0.5s, opacity 0.5s;
                }                
                div.block35834 .item:hover .shadow.no-data img {
                    right: 14.67796610169492%;
                    left: auto;
                }     
            }            
        </style>
    [/#if]
    <div data-block-uuid="articlelist" data-gjs-type="developer-node-component"
        data-block-list-setting="dataSelect,dataOrderBy,loadMethod,pageNumber,showDate" data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":8,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
        <style>
            [data-new-auto-uuid="${pageNodeId!''}"] {
                --color-match-setting1: var(--ld-main1, #DFD8D2);
                --color-match-setting2: var(--ld-Auxiliary1, #000);
            }
        </style>
        
        <div class="Article_Container">
            <div class="backstage-blocksEditor-wrap articalWrap">
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
                <div class="block-article-container-replace ">
                    [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                        [#list data.articleList.list as article]
                        <div class="ArticlePicList_Item item">
                            [#if article.category??]
                            <div class="classification ">${article.category}</div> 
                            [/#if]
                            <div class="ArticlePicList_ItemContent content">
                                <div class="ArticlePicList_ItemContentInner">
                                    <div class="ArticlePicList_ItemContentInnerBox [#if showDate && showDate == 1]use-data[/#if]">  
                                        [#if showDate && showDate == 1]
                                        <div class="time paragraph2">
                                            <i class="font-icon fa fa-calendar"></i> ${article.publishTime?date("yyyy-MM-dd")?string('dd')} <br>
                                            ${article.publishTime?date("yyyy-MM-dd")?string('MMMM')} <br> ${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}
                                        </div>
                                        [/#if]
                                        <div class="article_img">    
                                            <a class="link [#if showDate && showDate == 0]link-no-data[/#if]" href="${article.articleUrl}">           
                                                <picture>                        
                                                    <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />                        
                                                    <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />                        
                                                    <img loading="lazy" class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!?html}" title="${article.photoSeoList[0].photoTitle!?html}">                     
                                                </picture>  
                                            </a> 
                                            <div class="shadow1"></div>           
                                        </div> 
                                        <div class="article_content_right">
                                            <h3 class="ArticlePicList_ItemContentInnerH5">                                
                                                <a class="heading5" href="${article.articleUrl}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                            </h3>
                                            <div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</div>
                                        </div>
                                        <h3 class="ArticlePicList_ItemContentInnerH5 mb-style">                                
                                            <a class="heading5" href="${article.articleUrl}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                        </h3>
                                        <div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1 mb-style">${article.articleSummary!''}</div>
                                        <div class="ArticlePicList_ItemContentInnerTrans"></div>                       
                                    </div> 
                                </div>
                            </div>
                            <div class="shadow [#if showDate?? && showDate == 0]no-data[/#if]">
                                <a class="link" href="${article.articleUrl}"> <img src="//a2.leadongcdn.cn/cloud/lrBpiKpnlpSRoiojnoknip/arrow-left-white.png"></a>  
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
                        window._block_namespaces_['block35834'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                    });
                </script>
                <script type="application/ld+json">
                    ${data.articleList.extraData.articleStructureData!""}
                </script>
            [/@api]
            </div>
        </div>
    </div>
</div>