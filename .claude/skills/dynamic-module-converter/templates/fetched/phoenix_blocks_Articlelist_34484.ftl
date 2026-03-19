<div data-gjs-type="phoenix-container" data-strong="1">

    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
           .block34484 .inner,
           .block34484 .outer{
                direction: rtl;
                text-align: right;
            }
            .block34484 .cate1,
            .block34484 .cate,
            .block34484 .time1,
            .block34484 .title1,
            .block34484 .time {
                left: unset;
                right: 50px;
            }
            .block34484 .slick-dots {    
                direction: ltr!important;
            }  
            div.block34484 .cate::before,
            div.block34484 .cate1::before {
                position: absolute;
                left: auto;
                right: -102%;
            }
            div.block34484 .cate:hover::before,
            div.block34484 .cate1:hover::before {     
                left: auto;
                right: -1%;
            }                                  
        </style>
    [/#if]

	<div class="backstage-blocksEditor-wrap" data-block-uuid="articlelist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,pageNumber,dataOrderBy,showDate"
		data-block-type="phoenix_blocks_Articlelist"
		data-default-setting={"pageSize":5,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1:var(--ld-main1, #58468c);
				--color-match-setting2:var(--ld-Auxiliary1, #fb6692);
			}
		</style>

		<div class="block34484 init-slick">

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

                <div class=" articalWrap">
                    
        <div class="ArtList">
         [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
            [#list data.articleList.list as article]
                <div class="Artitem">
                    <div class="bgc"  ></div>
                    <div class="outer">
                        <div class="imgBox">
                            <a href="${article.articleUrl!}" class="mc" ></a>
                            <picture>
                                <source media="(min-width: 768px)" srcset="${article.photoUrlNormal!}" />
                                <source media="(max-width: 767px)" srcset="${article.photoUrlNormal!}" />
                                <img class="headlines-content-img ArticlePicList_ItemImg " loading="lazy" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                            </picture>
                        </div>
                        [#if article.cateName??] <div class="cate1" ><span>${article.cateName!''}</span></div>[/#if]
                        <h3 class="title1">
                            <a class="heading5" href="${article.articleUrl!}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                        </h3>
                        [#if showDate?? && showDate == '1']
                        <div class="time1 paragraph2">
                            ${article.publishTime?date("yyyy-MM-dd")?string('MMM dd ,yyyy')}
                        </div>
                        [/#if]
                    </div>
                    <div class="inner">
                        <div class="innerBox">
                        [#if article.cateName??] <div class="cate"><span>${article.cateName!''}</span></div>[/#if]
                        <h3 class="title">
                            <a class="heading5" href="${article.articleUrl!}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                        </h3>
                        [#if showDate?? && showDate == '1']
                        <div class="time paragraph2">
                            ${article.publishTime?date("yyyy-MM-dd")?string('MMM dd ,yyyy')}
                        </div>
                        [/#if]
                        <p class="text paragraph1">${article.articleSummary!''}</p>
                        <div class="butn">
                            <a class="ArticlePicList_ItemContentInnerA" href="${article.articleUrl!}"><i class="icon iconfont_phoenix icon-right"></i></a>
                        </div>
                        </div>
                    </div>
                </div>
            [/#list]
            
            </div>
            [#else]
            <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
        [/#if]
    </div>

        	<script>
                $(function(){
                    window._block_namespaces_['block34484'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
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