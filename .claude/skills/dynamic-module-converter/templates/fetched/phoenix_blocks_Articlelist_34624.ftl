<div data-gjs-type="phoenix-container" data-strong="1">

    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <style data-collect='1'>
            .block34624 .ArticlePicList_Item{
                direction: rtl;
                text-align: right;
            }
            .block34624 .ArticlePicList_Item:hover .shortline {
                left: 0;
            }
            div.block34624 .ArticlePicList_Item:nth-child(even) {
                margin: 20px 40px 20px 0;
            }

            div.block34624 .ArticlePicList_Item:nth-child(odd) {
                margin: 20px 0 20px 40px;
            }            
        </style>
    [/#if]
	<div data-block-uuid="articlelist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,pageNumber,dataOrderBy,showDate" data-block-type="phoenix_blocks_Articlelist"
		data-default-setting={"pageSize":4,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, rgb(217, 83, 79));
				--color-match-setting2: var(--ld-Auxiliary1, rgb(51, 51, 51));
			}
		</style>
		<div class="block34624">

			<div class="category">
				<div class="Article_Container">
					<div class="wrapper">

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

                            [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                            [#list data.articleList.list as article]
                        
                            <div class="ArticlePicList_Item">
                                <div class="ArticlePicList_ItemContent">
                                    <div class="ArticlePicList_ItemContentInner">
                                        <div class="ArticlePicList_ItemContentInnerBox">
                                            <h3 class="ArticlePicList_ItemContentInnerH5 heading5" >
                                                <a href="${article.articleUrl!}" title="${article.articleTitle!?html}" class="heading5">${article.articleTitle!?html} </a>
                                            </h3>
                                            <div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</div>
                                            <div class="shortline" >
                                                <div class="longline" ></div>
                                            </div>
                                            [#if showDate?? && showDate == '1']
                                            <div class="time">
                                                <time class="date paragraph2">${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}-${article.publishTime?date("yyyy-MM-dd")?string('MM')}-${article.publishTime?date("yyyy-MM-dd")?string('dd')}</time>
                                            </div>
                                            [/#if]
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


</div>

</div>

</div>