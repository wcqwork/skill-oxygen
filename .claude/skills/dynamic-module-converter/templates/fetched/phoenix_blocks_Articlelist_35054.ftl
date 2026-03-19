<div data-gjs-type="phoenix-container" data-strong="1">

    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            .block35054 .ArtContent{
                text-align: right;
            }
            .block35054 .time{
                justify-content: flex-end;
            }
            .block35054 .artclelist-site-pagination,
            .block35054 .artclelist-site-pagination * {
                direction: ltr !important;
            }
        </style>
    [/#if]
    <style>
        .block35054 .art {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
        }

        .block35054 .Art_Item {
            width: 100%;
            position: relative;
            background: #FFFFFF;
            box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.1);
            word-break: break-word;
        }
                
        @media screen and (max-width:768px) {
            .block35054 .art {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media screen and (max-width:510px) {
            .block35054 .art {
                grid-template-columns: 1fr;
            }
        }
    </style>
	<div class="backstage-blocksEditor-wrap" data-block-uuid="articlelist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,pageNumber,dataOrderBy,showDate"
		data-block-type="phoenix_blocks_Articlelist"
		data-default-setting={"pageSize":3,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"draggable":false,"data":[{"fieldName":"文章标题","checked":false,"fieldType":"0","value":"1","fieldId":"articleTitle"},{"fieldName":"文章简介","checked":false,"fieldType":"0","value":"2","fieldId":"articleSummary"},{"fieldName":"日期","checked":false,"fieldType":"0","value":"3","fieldId":"publishTime"},{"fieldName":"文章分类","checked":false,"fieldType":"0","value":"4","fieldId":"cateName"}],"label":"显示字段","key":"showField"}},"expandSort":["showField"],"layoutStyle":"0","showDate":"0","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1:var(--ld-main1, #0089F5);
			}
		</style>

		<div class="block35054">

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
                    }
                }
			}']
            <div class="Article_Container">
 
                 <div class="art block-article-container-replace" >
            [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
            [#list data.articleList.list as article]
            <div class="Art_Item">
                <div class="imgBox">
                    <picture>
                        <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
                        <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />
                        <img class="headlines-content-img ArticlePicList_ItemImg" loading="lazy" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                    </picture>
                </div>
                <div class="ArtContent">
                    <div class="ArtInner">
                        <div class="ArtBox">
                            <h3 class="ArtH5 heading5">
                                <a href="${article.articleUrl!}" title="${article.articleTitle!?html}" class="heading5">${article.articleTitle!?html} </a>
                            </h3>
                            <div class="articleList-summary ArtP paragraph1">${article.articleSummary!''}</div>
                            <div class="butn paragraph2">
                                <a class="ArticlePicList_ItemContentInnerA " href="${article.articleUrl!}">[@s.m "phoenix_read_more" /]</a>
                            </div>

                        </div>
                    </div>
                     [#if showDate?? && showDate == '1']
                    <div class="time paragraph2"><span class="dd">${article.publishTime?date("yyyy-MM-dd")?string('dd')}</span>/${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}-${article.publishTime?date("yyyy-MM-dd")?string('MM')}</div>
                    [/#if]
                </div>

            </div>
            [/#list]
            
            [#else]
           <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
            [/#if]
            
            </div>


                <input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}"> 
                    <input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
                    <input type="hidden" name="pageSize" value="${data.articleList.pageSize!'10'}">

                [#if (dataType?? && dataType != '3') && !(data.articleList.pageSize?? && data.articleList.totalRow?? && data.articleList.totalRow <=  data.articleList.pageSize)]
                    <div class="artclelist-site-pagination">
                        <div class="artclelist-laypage-normal" id='artclelist-laypage-normal'></div>
                    </div>
                [/#if]
        	<script>
                $(function(){
                    window._block_namespaces_['block35054'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
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