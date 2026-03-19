<div data-gjs-type="phoenix-container" data-strong="1">

    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            .block35724 .ArticlePicList_ItemContentInnerH5,
            .block35724 .time {
                direction: rtl !important;
                text-align: right;
                margin-left: auto;
            }
            .block35724 .ArticlePicList_ItemContentInnerA {
                right: auto;
                left: 20px;
                transform: translateY(-50%) rotate(180deg);
            }
        </style>
    [/#if]
    <style>
        .block35724 {
            opacity: 0;
        }
    </style>
	<div class="backstage-blocksEditor-wrap" data-block-uuid="articlelist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,dataOrderBy,showDate"
		data-block-type="phoenix_blocks_Articlelist"
		data-default-setting={"pageSize":4,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1:var(--ld-main1, #E60012);
			}
		</style>

		<div class="block35724">
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
                <div class="Article_Container">
                        <div class="articalWrap">
                            [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                                [#list data.articleList.list as article]
                                    <div class="ArticlePicList_Item">
                                        <div class="ArticlePicList_ItemContent">
                                            <div class="ArticlePicList_ItemContentInner">
                                                <div class="ArticlePicList_ItemContentInnerBox">
                                                    [#if showDate?? && showDate == '1']
                                                    <div class="time paragraph2">
                                                        <span class="md">${article.publishTime?date("yyyy-MM-dd")?string('MM-dd')}</span><span class="year">${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}</span>
                                                    </div>
                                                    [/#if]
                                                    <h3 class="ArticlePicList_ItemContentInnerH5 heading5">
                                                        <a href="${article.articleUrl!}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                                    </h3>
                                                    <div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</div>
                                                    <a class="ArticlePicList_ItemContentInnerA paragraph2" href="${article.articleUrl!}"><span><i class="icon iconfont_phoenix icon-jiantouyou"></i></span></a>
                                                    <div class="ArticlePicList_ItemContentInnerTrans"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="imgBox">
                                            <a href="${article.articleUrl!}">
                                            <picture>
                                                <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
                                                <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />
                                                <img class="headlines-content-img ArticlePicList_ItemImg" loading="lazy" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                                            </picture>
                                            </a>
                                        </div> 
                                    </div>
                                [/#list]
                                [#else]
                                <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                            [/#if]
                        
                        </div>


                <script>
                    $(function(){
                        window._block_namespaces_['block35724'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                    });
                </script>
                <script type="application/ld+json">
                    ${data.articleList.extraData.articleStructureData!""}
                </script>

                </div>
                [/@api]
		</div>

	</div>
</div>