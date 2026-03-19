<div data-gjs-type="phoenix-container" data-strong="1" class="">
[#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
	<!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
    <style data-collect='1'>
        div.block37324 .time {
            margin-left: 0;
            margin-right: 5px;
        }
        div.block37324 .slick-dots {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: row-reverse;
        }
        div.block37324 .ArticlePicList_ItemContentInnerBox {
            direction: rtl;
        }
        div.block37324 .classification {
            right: 0;
            left: auto;
        }                
	</style>
[/#if]

    <div class="block37324 init-style">
        <div class="wrapper">
            <div class="tile">
                <div data-gjs-type="componentWrapper" draggable="true" class="lead-component-wrapper lead-container-wrapper imgWra" style="margin:0px;">
                    <div data-gjs-type="images" class="lead-image-container imgBox" >
                        <picture data-gjs-type="pictureType" class="lead-picture">
                            <source data-gjs-type="sourceType" srcset="//rmrorwxhmnojlq5p.leadongcdn.com/cloud/ljBpjKiilpSRmkmjmjrijq/3.jpg" media="(min-width: '992px')">
                            <source data-gjs-highlightable="true" id="ir2b9w" data-gjs-type="sourceType" srcset="//rmrorwxhmnojlq5p.leadongcdn.com/cloud/ljBpjKiilpSRmkmjmjrijq/3.jpg" media="(min-width: '768px')">
                            <img data-gjs-highlightable="true" id="irkzft" data-gjs-type="imageType" src="//rmrorwxhmnojlq5p.leadongcdn.com/cloud/ljBpjKiilpSRmkmjmjrijq/3.jpg" width="875" height="14" alt="3" class="lead-img">
                        </picture>
                    </div>
                </div>

                <div data-gjs-type="text" draggable="true" class="lead-text textBox ">
                    <div class="ql-editor">
                        <h2 style="text-align: center;" class="heading2">
                            <span style="color: rgba(255, 255, 255, 1);">The Service Attitude Of The Logistics Company Is Very Good</span>
                        </h2>
                        <div style="text-align: center;">
                            <br>
                            <span style="color: rgb(255, 255, 255);">There's no difference. It's really worth more.</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tile">
               <div class="backstage-blocksEditor-wrap " data-block-uuid="articlelist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber,dataOrderBy,showDate" 
                data-block-type="phoenix_blocks_Articlelist" 
                data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
                    <style>
                    [data-new-auto-uuid="${pageNodeId!''}"] {
                        --color-match-setting1: var(--ld-main1, #aa6ecf);
                    }
                    </style>

                    <div class="Article_Container">
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
                                [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                                    <div class="slide-wra">
                                        [#list data.articleList.list as article]
                                        <div class="ArticlePicList_Item article-tile">
                                            <div class="article-img">
                                                <a href="${article.articleUrl!''}" title="${article.articleTitle!?html}" >
                                                    <picture>
                                                        <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!''}" />
                                                        <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!''}" />
                                                        <img class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!''}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                                                    </picture>
                                                </a>
                                            </div>
                                            <div class="ArticlePicList_ItemContent article-text">
                                                <div class="ArticlePicList_ItemContentInner">
                                                    <div class="ArticlePicList_ItemContentInnerBox">
                                                        <div class="icon-cate">
                                                            <!-- 文章分类 -->
                                                            [#if article.cateName??]
                                                                <div class="classification paragraph2">
                                                                    <span>${article.cateName!''}</span>
                                                                </div> 
                                                            [/#if]
                                                        </div>
                                                        <div class="textWra">
                                                            <!-- 文章标题 -->
                                                            <h3 class="ArticlePicList_ItemContentInnerH5 h5Style">
                                                                <a class="heading5" href="${article.articleUrl!''}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                                            </h3>
                                                            <p class="articleList-summary ArticlePicList_ItemContentInnerP pStyle paragraph1">${article.articleSummary!''}</p>
                                                        </div>
                                                            <!-- 文章发表日期 -->
                                                        [#if showDate && showDate == 1]
                                                        <div class="timeBox">
                                                            <span><i class="iconfont_phoenix icon-shizhong paragraph2"></i></span>
                                                            <time class="time paragraph2">
                                                                ${article.publishTime?date("yyyy-MM-dd")?string('MMMM')} ${article.publishTime?date("yyyy-MM-dd")?string('dd')},${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}                                        
                                                            </time>
                                                        </div>
                                                        [/#if]
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        [/#list]
                                    </div>
                                [#else]
                                    <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                                [/#if]
                                <script>
                                    $(function(){
                                        window._block_namespaces_['block37324'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
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
    </div>
</div>