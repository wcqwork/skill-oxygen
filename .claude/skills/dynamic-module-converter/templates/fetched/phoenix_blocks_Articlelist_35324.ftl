<div class="block35324" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <style data-collect='1'>
            .block35324 .ArticlePicList_Item:nth-child(2),
            .block35324 .ArticlePicList_Item:nth-child(3),
            .block35324 .ArticlePicList_Item:nth-child(4) {
                left: 0;
                right: auto;
            }
            .block35324 .ArticlePicList_Item {
                direction: ltr !important;
            }
            .block35324 .timeBox .articleType {
                margin-left: 4px;
                margin-right: 0;
            }
        </style>
    [/#if]
	<div data-block-uuid="articlelist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,dataOrderBy,pageNumber,showDate"
		data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":4,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #073e76cc);
                --color-match-setting2: var(--ld-Auxiliary1, #FF9900);
			}
		</style>

		<div class="wz" id="wz">
			<div class="Article_Container">
				<div class="clearfix">
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

                    [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                        [#list data.articleList.list as article]
                        <div class="ArticlePicList_Item">
                            <div class="imgBox">
                                <a class="mc" href="${article.articleUrl}"></a>
                                <picture>
                                    <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
                                    <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />
                                    <img loading="lazy" class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                                </picture>
                            </div>
                            <div class="ArticlePicList_ItemContent">
                                <div class="ArticlePicList_ItemContentInner">
                                    <div class="ArticlePicList_ItemContentInnerBox">
                                        <div class="timeBox">
                                            [#if article.cateName??]
                                            <span class="articleType paragraph2">[${article.cateName!''}]</span>
                                            [/#if]
                                            [#if showDate && showDate == 1]
                                            <div class="time paragraph2">
                                                <time>
                                                    <!-- ${article.publishTime?date("yyyy-MM-dd")?string('MMMM')} -->
                                                    <span>${article.publishTime?date("yyyy-MM-dd")}</span> 
                                                </time>
                                            </div>
                                            [/#if]
                                        </div>
                                        <h3 class="ArticlePicList_ItemContentInnerH5">
                                            <a class="heading5" href="${article.articleUrl}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a> 
                                        </h3>
                                        <p class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</p>
                                        <a class="ArticlePicList_ItemContentInnerA paragraph2" href="${article.articleUrl}"><span>[@s.m "phoenix_read_more" /]</span></a>
                                    </div>
                                </div>
                            </div>

                        </div>
                        [/#list]
					[#else]
                        <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
					[/#if]
					[/@api]
                </div>
			</div>
		</div>
	</div>
</div>