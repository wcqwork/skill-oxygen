<div class="block34724" data-gjs-type="phoenix-container" data-strong="1">
    <style>
        @media (min-width: 790px) {
            .block34724 .relative-article-style1  {
                display: flex;
                opacity: 0;
            }

            .block34724 .relative-article-style1.slick-initialized {
                display: block;
                opacity: 1;
                transition: all 0.5s;
            }

            .block34724 .owl-nav {
                opacity: 0;
            }
            
            .block34724 .relative-article-style1.slick-initialized + .owl-nav {
                opacity: 1;
                transition: all 0.5s;
            }
        }
    </style>
    <div data-block-uuid="gallery_34724" data-gjs-type="developer-node-component"
		data-block-list-setting="relatedTypes,pageNumber,showDate"
		data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"refreshMethod":"0","expandSort":["showField"],"showDate":"1","relatedTypes":"0","translationEntry":[]}>
        <style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
                --color-match-setting1: var(--ld-main1, #00276b);
			}
		</style>

        <div class="wra artList" class="relateProducts_block">
			<div class="relative-article">
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
                                    photoSeoList{
                                        photoId
                                        photoUrlNormal
                                        photoAlt
                                        photoTitle
                                    }
                                    photoUrlDefine
                                    cateName
                                    cateUrl
                                    showFieldList
                                    $showField
                                    articleAuthor
                                }
                            }
                        }']

                        [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                            <ul class="relative-article-style1 fix multiple-items">
                                [#list data.articleList.list as article]
                                <li>
                                    <div class="img">
                                        <a href="${article.articleUrl!''}">
                                            <img height="250" width="1250" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}" ></img>
                                        </a>
                                    </div>
                                    <h3 class="article-cont">
                                        <a href="${article.articleUrl!''}" class="heading5">${article.articleTitle!?html}</a>
                                    </h3>
                                    <div class="article-detail">
                                        [#if article.articleAuthor?? && article.articleAuthor?default("")?trim?length gt 1]
                                        <div class="author paragraph2">[@s.m "UAfUKpKsjHrZ_by_config" /]<span>${article.articleAuthor!}</span></div>
                                        [/#if]
                                        [#if article.articleAuthor?? && article.articleAuthor?default("")?trim?length gt 1 && showDate && showDate == 1]
                                        <div class="line">|</div>
                                        [/#if]
                                        [#if showDate && showDate == 1]
                                        <div class="time paragraph2">
                                            <time>${article.publishTime!}</time>
                                        </div>
                                        [/#if]
                                    </div>
                                </li>
                                [/#list]
                            </ul>
                        [#else]
                            <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                        [/#if]
					[/@api]

                <div class="owl-nav">
					<div class="owl-prev">
                        <i class="icon iconfont_phoenix icon-next2"></i>
					</div>
					<div class="owl-next">
                        <i class="icon iconfont_phoenix icon-right"></i>
					</div>
				</div>
			</div>
        </div>

        <script>
			$(function () {
                window._block_namespaces_['block34724'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
            });
		</script>
    </div>
</div>