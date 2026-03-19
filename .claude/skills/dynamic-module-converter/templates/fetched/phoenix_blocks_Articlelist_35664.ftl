<div data-gjs-type="phoenix-container" data-strong="1">

    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            .block35664 .Main_flex,
            .block35664 .ArticlePicList_Item {
                direction: rtl;
            }
            .block35664 .artclelist-site-pagination .layui-box a.layui-laypage-prev,
            .block35664 .artclelist-site-pagination .layui-box a.layui-laypage-next {
                transform: rotate(180deg);
            }
            .block35664 .artclelist-site-pagination,
            .block35664 .artclelist-site-pagination * {
                direction: rtl;
            }
            .block35664 .ArticlePicList_ItemContentInnerH5 a .line {
                transform: rotate(180deg);
            }
        </style>
    [/#if]
    <style>
        .block35664 .art-main .Main_flex {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
        }
        .block35664 .ArticlePicList_Item {
            width: calc(50% - 10px);
            position: relative;
            margin-bottom: 60px;
        }
        @media only screen and (max-width: 800px) {
            .block35664 .ArticlePicList_Item {
                width: 100%;
            }
        }
    </style>
	<div class="backstage-blocksEditor-wrap" data-block-uuid="articlelist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,loadMethod,pageNumber,dataOrderBy"
		data-block-type="phoenix_blocks_Articlelist"
		data-default-setting={"pageSize":8,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"1","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
                --color-match-setting1: var(--ld-main1,#394447);
                --color-match-setting2: var(--ld-Auxiliary1, #2aa7ea);
                --color-match-setting3: var(--ld-Auxiliary2, #428bca);
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
                            photoSeoList{
                                photoId
                                photoUrlNormal
                                photoAlt
                                photoTitle
                            }
                            cateName
                            cateUrl
                            showFieldList
                            $showField
                        }
                    }
                }']
		<div class="block35664">
            
                <div class="Article_Container">
                    <div class="articalWrap art-main">
                        <div class="Main_flex">
                            [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                                [#list data.articleList.list as article]
                                <div class="ArticlePicList_Item">
                                    <div class="ArticlePicList_ItemContent">
                                        <div class="ArticlePicList_ItemContentInner">
                                            <div class="ArticlePicList_ItemContentInnerBox">
                                                <div class="ArticlePicList_ItemContentInnerH5">
                                                        <a href="${article.articleUrl!}" title="${article.articleTitle!?html}">
                                                            <h3 class="heading5">${article.articleTitle!?html}</h3>
                                                            <span class="line">
                                                                <span class="boder-span"></span>
                                                                <span><i class="icon iconfont_phoenix icon-right"></i></span>
                                                            </span>
                                                        </a>
                                                </a></div>
                                                <div class="ArticlePicList_ItemContentInnerTrans"></div>   
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ArticlePicList_img">
                                        <img class="headlines-content-img ArticlePicList_ItemImg" loading="lazy" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">

                                    </div> 
                                </div>
                            [/#list]
                        </div>
                          
                        [#else]
                             <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                            [/#if]
                    </div>

                </div>
                 <input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}"> 
                        <input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
                        <input type="hidden" name="pageSize" value="${data.articleList.pageSize!'10'}">
[#if (dataType?? && dataType != '3') && (!loadMethod?? || loadMethod == '0') && !(data.articleList.pageSize?? && data.articleList.totalRow?? && data.articleList.totalRow <=  data.articleList.pageSize)]
                <div class="artclelist-site-pagination">
                    <div class="artclelist-laypage-normal" id='artclelist-laypage-normal'></div>
                </div>
            [/#if]
                <script>
                    $(function(){
                        window._block_namespaces_['block35664'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                    });
                </script>
                <script type="application/ld+json">
                    ${data.articleList.extraData.articleStructureData!""}
                </script>
		</div>
[/@api]
	</div>
</div>