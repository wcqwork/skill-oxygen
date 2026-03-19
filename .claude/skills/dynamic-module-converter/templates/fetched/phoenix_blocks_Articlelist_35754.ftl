<div class="block35754" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <style data-collect='1'>
            .block35754 .ArticlePicList_ItemContentInner {
				text-align: right;
			}
            div.block35754 .cont .ricon {
                transform: rotate(180deg);
            }            
            div.block35754 .ArticlePicList_Item:hover .ricon {                         
                left: -40px;
                right: auto;
            }
            div.block35754 .ArticlePicList_Item:hover .ArticlePicList_ItemContentInnerH5 {
                transform: translateX(40px);
            }    
            .block35754 .slick-dots {
                direction: ltr!important;
            }                                
        </style>
    [/#if]
	<div data-block-uuid="articlelist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,dataOrderBy,pageNumber,showDate"
		data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":3,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #004B88);
                --color-match-setting2: var(--ld-Auxiliary1, #cb4c57);
			}
		</style>

		<div class="artWrap">
			<div class="Article_Container">
				<div class="zh">
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
                        [#list data.articleList.list as article]
                        <div class="ArticlePicList_Item">
                            <a class="mc" href="${article.articleUrl}"></a>
                            <div class="ArticlePicList_ItemContent">
                                <div class="ArticlePicList_ItemContentInner">
                                    <div class="ArticlePicList_ItemContentInnerBox">
                                        [#if article.cateName??]
                                        <div class="fenl paragraph2"> ${article.cateName!''} </div>
                                        [/#if]
                                        [#if showDate && showDate == 1]
                                        <div class="time paragraph2">
                                            <time>
                                                ${article.publishTime?date("yyyy-MM-dd")?string('dd')},${article.publishTime?date("yyyy-MM-dd")?string('MM')},${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}
                                            </time>
                                        </div>
                                        [/#if]
                                        <div class="cont">
                                            <h3 class="ArticlePicList_ItemContentInnerH5">
                                                <a class="heading5" href="${article.articleUrl}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                            </h3>
                                            <div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</div>
                                            <div class="ricon"> <i class="icon iconfont_phoenix icon-jiantouyou"></i></div>
                                        </div>
                                        <a class="ArticlePicList_ItemContentInnerA paragraph2" href="${article.articleUrl}"><span>[@s.m "phoenix_read_more" /]</span></a>
                                        <div class="ArticlePicList_ItemContentInnerTrans"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="imgBox">
                                <picture>
                                    <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
                                    <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />
                                    <img loading="lazy" class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                                </picture>
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

		<script>
			$(function () {
                window._block_namespaces_['block35754'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'pageNodeId': '${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
            });
		</script>
	</div>
</div>