<div class="block34944" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <style data-collect='1'>
            /* .qiaoxin34944 .ArticlePicList_ItemContentInnerTrans time, */
            .qiaoxin34944 .ArticlePicList_ItemContentInnerH5,
            .qiaoxin34944 .ArticlePicList_ItemContentInnerP {
                margin-left: auto;
                margin-right: 10px;
                text-align: right;
            }
            /* .qiaoxin34944 .ArticlePicList_Item:hover .ArticlePicList_ItemContentInnerTrans time {
                margin-left: auto;
                margin-right: 50px;
            } */
            .qiaoxin34944 .ArticlePicList_Item:hover .ArticlePicList_ItemContentInnerA {
                opacity: 1;
                right: 316px;
                z-index: 999;
            }
            .qiaoxin34944 .ArticlePicList_ItemContentInnerTrans div {
                margin-left: 10px;
                margin-right: 50px;
            }
            .qiaoxin34944 .ArticlePicList_ItemContentInnerTrans span {
                margin-left: 10px;
                margin-right: 50px;
                display: block;
            }
            @media screen and (max-width: 1200px) {
                .qiaoxin34944 .ArticlePicList_Item:hover .ArticlePicList_ItemContentInnerA {
                    right: 130px;
                }
            }
        </style>
    [/#if]
	<div data-block-uuid="articlelist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,dataOrderBy,pageNumber,showDate" data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":3,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #49ADA3);
			}
		</style>
		<div class="qiaoxin34944">
			<div class="news">
				<div class="Article_Container">
					<div class="Article_Container-wrap">
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
                                    photoSeoList{
                                        photoId
                                        photoUrlNormal
                                        photoAlt
                                        photoTitle
                                    }
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
                                        [#if showDate && showDate == 1]
                                        <div class="ArticlePicList_ItemContentInnerTrans time paragraph2">
                                            <a class="ArticlePicList_ItemContentInnerA" href="${article.articleUrl}"><i class="icon iconfont_phoenix icon-jiantouyou-5"></i></a>
                                            <time>
                                                <span>${article.publishTime?date("yyyy-MM-dd")?string('MM')}-${article.publishTime?date("yyyy-MM-dd")?string('dd')}</span>
                                                <div>${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}</div>
                                            </time>
                                        </div>
                                        [/#if]
										<div class="wrapper">
											<div class="line"></div>
											<h3 class="ArticlePicList_ItemContentInnerH5 heading5">
												<a href="${article.articleUrl}" title="${article.articleTitle!?html}" class="heading5">${article.articleTitle!?html}</a>
											</h3>
                                            [#if showDate && showDate == 1]
                                            <div class="ArticlePicList_ItemContentInnerTrans1 time paragraph2">
                                                <time>
                                                    <span>${article.publishTime?date("yyyy-MM-dd")?string('MM')}-${article.publishTime?date("yyyy-MM-dd")?string('dd')}</span>
                                                    <div>${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}</div>
                                                </time>
                                            </div>
                                            [/#if]
											<div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</div>
										</div>
										
									</div>
									<div class="img">
										<picture>
											<source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
											<source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />
											<img loading="lazy" class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}" />
                                        </picture>
									</div>
								</div>
							</div>
						</div>
						[/#list]
						[#else]
						<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
						[/#if]
						[/@api]</div>
				</div>
			</div>
		</div>
	</div>
</div>