<div class="block35434" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <style data-collect='1'>
            .block35434 .item .content {
                text-align: right;
            }
            .block35434 .item .content .time {
                left: auto;
                right: 30px;
            }
            .block35434 .item .classification {
                left: auto;
                right: 30px;
            }
            div.block35434 .item .content h3,
            div.block35434 .item .content p.articleList-summary,
            div.block35434 .item .content .article_href {
                left: auto;
                right: 30px;
            } 
            .block35434 .slick-dots {
                direction: ltr!important;
            }      
            div.block35434 .classification {
                clip-path: polygon(10% 0, 100% 0, 100% 100%, 0% 100%);
            }                            
        </style>
    [/#if]
	<div data-block-uuid="articlelist" data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,dataOrderBy,pageNumber,showDate"
		data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":8,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #678499);
                --color-match-setting2: var(--ld-Auxiliary1, #D8E2E8);
			}
		</style>

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

            [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
			<input type="hidden" id="listSize" value="${data.articleList.list?size}">
			<div class="swiper-container">
				<div class="swiper-wrapperss">
                    [#list data.articleList.list as article]
					<div class="ArticlePicList_Item item swiper-slide">
						<div class="article_img">
							<picture>
								<source media="(min-width: 768px)" srcset="${article.photoUrlNormal!}" />
								<source media="(max-width: 767px)" srcset="${article.photoUrlNormal!}" />
								<img loading="lazy" class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                            </picture>
						</div>
						[#if article.cateName??]
						    <div class="classification paragraph2">${article.cateName!''} </div> 
                        [/#if] 
                        <div class="ArticlePicList_ItemContent content">
							<div class="ArticlePicList_ItemContentInner">
								<div class="ArticlePicList_ItemContentInnerBox">
									<!-- 文章标题 -->
									<h3 class="ArticlePicList_ItemContentInnerH5">
										<a class="heading5" href="${article.articleUrl}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
									</h3>
									<!-- 文章发表日期 -->
                                    [#if showDate && showDate == 1]
                                    <div class="time paragraph2">
                                        <time><i class="icon iconfont_phoenix icon-rili"></i>${article.publishTime?date("yyyy-MM-dd")?string('dd')} ${article.publishTime?date("yyyy-MM-dd")?string('MMMM')} ${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}</time>
                                    </div>
                                    [/#if]
									<!-- 文章摘要 -->
									<p class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">
										${article.articleSummary!''}
                                    </p>
									<!-- 文章链接 -->
									<a class="ArticlePicList_ItemContentInnerA article_href paragraph2" href="${article.articleUrl}"><span>/ [@s.m "phoenix_read_more" /]</span></a>
									<div class="ArticlePicList_ItemContentInnerTrans"></div>
								</div>
							</div>
						</div>
					</div>
					[/#list]
				</div>
			</div>
			[#else]
                <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
			[/#if]
			[/@api]
		</div>

		<script>
			$(function () {
                window._block_namespaces_['block35434'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
            });
		</script>
	</div>
</div>