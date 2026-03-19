<div data-gjs-type="phoenix-container" data-strong="1">

    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
            .block35674 .ArticlePicList_Item {
                direction: rtl;
            }
            .block35674 .Box .Bottom .ArticlePicList_Item .FlexIco {
                flex-direction: row-reverse;
            }
            .block35674 .Box .Bottom .ArticlePicList_Item .FlexIco {
                justify-content: flex-end;
            }
            .block35674 .Box .Top .ArticlePicList_Item:first-child .ArticlePicList_ItemContent {
                left: 0;
                right: auto;
            }
            .block35674 .Box .Top {
                direction: rtl;
            }
            .block35674 .slick-dots {
                direction: ltr!important;
            }
        </style>
    [/#if]

	<div class="backstage-blocksEditor-wrap" data-block-uuid="articlelist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,pageNumber,dataOrderBy,showDate"
		data-block-type="phoenix_blocks_Articlelist"
		data-default-setting={"pageSize":4,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #CC0B08);
			}
		</style>

		<div class="block35674">
            <div class="Box">
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
                            photoSeoList {
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
                        <div class="Top">
                            [#list data.articleList.list as article]
                                <div class="ArticlePicList_Item">
                                    <div class="after"></div>
                                    <div class="ArticlePicList_ItemContent">
                                                    <a class="ArticlePicList_ItemContentInnerA" href="${article.articleUrl!}"></a>
                                        <div class="ArticlePicList_ItemContentInner">
                                            <div class="ArticlePicList_ItemContentInnerBox">
                                            <div class="FlexTie paragraph2">
                                                <div class="article-column-categorys-title" title="${article.cateName!?html}">${article.cateName!?html}</div>
                                                <div class="date"> 
                                                    [#if showDate?? && showDate == '1'] ${article.publishTime?date("yyyy-MM-dd")?string('yyyy-MM-dd')} [/#if]
                                                </div>
                                            </div>
                                                <h3 class="ArticlePicList_ItemContentInnerH5 heading5">${article.articleTitle!?html}</h3> 
                                                <div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</div>
                                                    <a class="ArticlePicList_ItemContentInnerA" href="${article.articleUrl!}"><span></span></a>
                                                <div class="ArticlePicList_ItemContentInnerTrans"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="imgbox">
                                        <picture>
                                            <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
                                            <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />
                                            <img alt="${article.articleTitle!?html}" class="headlines-content-img ArticlePicList_ItemImg" loading="lazy" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}" />
                                        </picture>
                                    </div> 
                                </div>
                            [/#list]
                            <div class="bag">
                                <div class="imgBoxSe">
                                    <img src="//g3.leadongcdn.cn/cloud/lnBpnKpjllSRnjlkroooiq/zhuangshibeijing.png" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                                </div>
                            </div>
                                    </div>
                            <div class="Bottom">
                             [#list data.articleList.list as article]
                                <div class="ArticlePicList_Item ">
                                        <a class="ArticlePicList_ItemContentInnerA" href="${article.articleUrl!}"></a>
                                    <div class="imgBox">
                                        <picture>
                                            <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />
                                            <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />
                                            <img class="headlines-content-img ArticlePicList_ItemImg" loading="lazy" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}" />
                                        </picture>
                                    </div> 
                                    <div class="ArticlePicList_ItemContent">
                                        <div class="ArticlePicList_ItemContentInner">
                                            <div class="ArticlePicList_ItemContentInnerBox">
                                                <h3 class="ArticlePicList_ItemContentInnerH5 heading5">${article.articleTitle!''}</h3>
                                                <div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</div>
                                                <div class="ArticlePicList_ItemContentInnerTrans"></div>
                                                <div class="FlexIco paragraph2">
                                                [#if showDate?? && showDate == '1']   
                                                <div class="date"> 
                                                    <time>${article.publishTime?date("yyyy-MM-dd")?string('yyyy-MM-dd')} </time>
                                                </div>
                                                <!-- <div class="icon">
                                                    <svg t="1661149443389" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2495" width="16" height="16">
                                                    <path d="M661.389084 511.544889L264.987307 123.335111a56.547556 56.547556 0 0 1 79.075555-80.782222l434.631111 425.642667c11.377778 11.150222 17.749333 26.851556 17.749334 43.235555a60.643556 60.643556 0 0 1-17.749334 43.349333l-434.631111 425.642667a56.547556 56.547556 0 0 1-79.075555-80.782222l396.401777-388.096z" fill="#CC0B08" p-id="2496"></path></svg>
                                                </div> -->
                                                [/#if]
                                                </div>
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
                        window._block_namespaces_['block35674'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                    });
                </script>
                <script type="application/ld+json">
                    ${data.articleList.extraData.articleStructureData!""}
                </script>

                </div>

                <div class="Jiantou">
                    <div class="Down">
                        <svg width="50px" height="50px" viewBox="0 0 50 50" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                            <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                <g transform="translate(-935.000000, -1074.000000)" fill="#CC0B08" fill-rule="nonzero">
                                    <g transform="translate(960.000000, 1099.000000) rotate(-180.000000) translate(-960.000000, -1099.000000) translate(935.000000, 1074.000000)">
                                        <path d="M13.0234375,27.3091518 L23.1065848,17.2260045 C24.1512277,16.1813616 25.8498884,16.1813616 26.8945312,17.2260045 L36.9776786,27.3091518 C37.6752232,28.0066964 37.6752232,29.1367188 36.9776786,29.8342634 C36.2801339,30.531808 35.1501116,30.531808 34.452567,29.8342634 L25,20.3822545 L15.5479911,29.8337054 C14.8504464,30.53125 13.7204241,30.53125 13.0228795,29.8337054 C12.6741071,29.484933 12.499442,29.0279018 12.499442,28.5714286 C12.499442,28.1149554 12.6741071,27.6573661 13.0234375,27.3091518 Z M24.4034598,19.7571317 L24.4034598,19.7958817 L24.4034598,19.7571317 Z"></path>
                                        <path d="M46.4285714,25 C46.4285714,36.8158482 36.8158482,46.4285714 25,46.4285714 C13.1841518,46.4285714 3.57142857,36.8158482 3.57142857,25 C3.57142857,13.1841518 13.1841518,3.57142857 25,3.57142857 C36.8158482,3.57142857 46.4285714,13.1841518 46.4285714,25 M50,25 C50,11.1930804 38.8069196,0 25,0 C11.1930804,0 0,11.1930804 0,25 C0,38.8069196 11.1930804,50 25,50 C38.8069196,50 50,38.8069196 50,25 Z"></path>
                                    </g>
                                </g>
                            </g>
                        </svg>
                    </div>
                    <div class="Up">
                        <svg width="50px" height="50px" viewBox="0 0 50 50" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                            <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                <g transform="translate(-935.000000, -1074.000000)" fill="#CC0B08" fill-rule="nonzero">
                                    <g transform="translate(960.000000, 1099.000000) rotate(-180.000000) translate(-960.000000, -1099.000000) translate(935.000000, 1074.000000)">
                                        <path d="M13.0234375,27.3091518 L23.1065848,17.2260045 C24.1512277,16.1813616 25.8498884,16.1813616 26.8945312,17.2260045 L36.9776786,27.3091518 C37.6752232,28.0066964 37.6752232,29.1367188 36.9776786,29.8342634 C36.2801339,30.531808 35.1501116,30.531808 34.452567,29.8342634 L25,20.3822545 L15.5479911,29.8337054 C14.8504464,30.53125 13.7204241,30.53125 13.0228795,29.8337054 C12.6741071,29.484933 12.499442,29.0279018 12.499442,28.5714286 C12.499442,28.1149554 12.6741071,27.6573661 13.0234375,27.3091518 Z M24.4034598,19.7571317 L24.4034598,19.7958817 L24.4034598,19.7571317 Z"></path>
                                        <path d="M46.4285714,25 C46.4285714,36.8158482 36.8158482,46.4285714 25,46.4285714 C13.1841518,46.4285714 3.57142857,36.8158482 3.57142857,25 C3.57142857,13.1841518 13.1841518,3.57142857 25,3.57142857 C36.8158482,3.57142857 46.4285714,13.1841518 46.4285714,25 M50,25 C50,11.1930804 38.8069196,0 25,0 C11.1930804,0 0,11.1930804 0,25 C0,38.8069196 11.1930804,50 25,50 C38.8069196,50 50,38.8069196 50,25 Z"></path>
                                    </g>
                                </g>
                            </g>
                        </svg>
                    </div>
                </div>
                [/@api]
            </div>
		</div>

	</div>
</div>