<div class="block37344" data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <style data-collect='1'>
            div.block37344 .articalWrap .ArticlePicList_ItemContentInnerH5,
            div.block37344 .articalWrap .ArticlePicList_ItemContentInnerP,
            .block37344 .articalWrap .ArticlePicList_ItemContentInnerBox {    
                text-align: right;
                direction: rtl;
            }         
        </style>
    [/#if]
	<div data-block-uuid="articlelist" data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,dataOrderBy,loadMethod,pageNumber,showDate"
		data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":9,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #678499);
			}
		</style>

		<div class="artical-content init-style">                        
            [@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'9'}"
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
            <div class="articalWrap [#if data.articleList.pageSize?? && data.articleList.pageSize < 4]little-article-wrap[/#if]">
            <div class="block-article-container-replace">
                [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                    <input type="hidden" id="listSize" value="${data.articleList.list?size}">
                    [#if data.articleList.pageSize?? && data.articleList.pageSize > 3]
                    <!-- 设置显示的多余3个 -->
                    <!-- 前3个轮播 -->
                    <div class="slick-box slick slick-box-37344">
                        <div class="prev arrow-btn"><i class="icon iconfont_phoenix icon-jiantouzuo-5"></i></div>
                        <div class="next arrow-btn"><i class="icon iconfont_phoenix icon-jiantouyou-5"></i></div>                    
                        <div class="slick-wrapper">
                            [#list data.articleList.list as article]
                                    [#if article_index lt 3]
                                    <div class="ArticlePicList_Item slick-slide">                                
                                        <!-- 文章发表日期 -->
                                        [#if showDate && showDate == 1]
                                            <div class="time">
                                                <span class="day">${article.publishTime?date("yyyy-MM-dd")?string('dd')}</span> <span class="month">${article.publishTime?date("yyyy-MM-dd")?string('MMM')}</span>
                                            </div>
                                        [/#if] 
                                        
                                        <div class="left-img">  
                                            <a data-gjs-type="default" href="${article.articleUrl}" class="heading5" title="${article.articleTitle!?html}">                                 
                                                <picture>                        
                                                    <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />                        
                                                    <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />                        
                                                    <img loading="lazy" class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!?html}" title="${article.photoSeoList[0].photoTitle!?html}">                     
                                                </picture>  
                                            </a>                                  
                                        </div>                                     
                                        <div class="ArticlePicList_ItemContent">
                                            <div class="ArticlePicList_ItemContentInner">
                                                <div class="ArticlePicList_ItemContentInnerBox">
                                                    <h3 class="ArticlePicList_ItemContentInnerH5 heading5">
                                                        <a data-gjs-type="default" href="${article.articleUrl}" class="heading5" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                                    </h3>
                                                    <p class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</p>
                                                    <a class="ArticlePicList_ItemContentInnerA paragraph2" href="${article.articleUrl}"><span>[@s.m "phoenix_read_more" /]</span><span style="margin-left: 6px;"> →</span></a>
                                                    <div class="ArticlePicList_ItemContentInnerTrans"></div>
                                                </div>
                                            </div>
                                        </div>
                                                                                
                                    </div> 
                                    [/#if]
                            [/#list]
                        </div>                    
                    </div>
                    [/#if]
                    <div class="other-article-box [#if data.articleList.pageSize?? && data.articleList.pageSize < 4]little-article-box[/#if]">
                        <div class="list-box">  
                            [#list data.articleList.list as article]                                                                   
                            <div class="ArticlePicList_Item ArticlePicList_Item-gt3">
                                    <!-- 文章发表日期 -->
                                [#if showDate && showDate == 1]
                                    <div class="time">
                                        <span class="day">${article.publishTime?date("yyyy-MM-dd")?string('dd')}</span> <span class="month">${article.publishTime?date("yyyy-MM-dd")?string('MMM')}</span>
                                    </div>
                                [/#if] 
                                <div class="top-img">
                                    <a data-gjs-type="default" class="heading5" href="${article.articleUrl}" title="${article.articleTitle!?html}">
                                        <picture>                        
                                            <source media="(min-width: 450px)" srcset="${article.photoUrlNormal!}" />                        
                                            <source media="(max-width: 449px)" srcset="${article.photoUrlNormal!}" />                        
                                            <img loading="lazy" class="headlines-content-img ArticlePicList_ItemImg" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!?html}" title="${article.photoSeoList[0].photoTitle!?html}">                     
                                        </picture>
                                    </a>
                                </div> 
                                <div class="ArticlePicList_ItemContent">
                                    <div class="ArticlePicList_ItemContentInner">
                                        <div class="ArticlePicList_ItemContentInnerBox">
                                            <h3 class="ArticlePicList_ItemContentInnerH5 heading5">
                                                <a data-gjs-type="default" class="heading5" href="${article.articleUrl}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                            </h3>
                                            <p class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</p>
                                            <a class="ArticlePicList_ItemContentInnerA paragraph2" href="${article.articleUrl}"><span>[@s.m "phoenix_read_more" /]</span><span style="margin-left: 6px;"> →</span></a>
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
                <input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}"> 
                <input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
                <input type="hidden" name="pageSize" value="${data.articleList.pageSize!'9'}">
            </div>
            </div>
            [#if (dataType?? && dataType != '3') && (!loadMethod?? || loadMethod == '0') && !(data.articleList.pageSize?? && data.articleList.totalRow?? && data.articleList.totalRow <=  data.articleList.pageSize)]
                <div class="artclelist-site-pagination">
                    <div class="artclelist-laypage-normal" id='artclelist-laypage-normal'></div>
                </div>
            [/#if]
            <script>
                $(function(){
                    window._block_namespaces_['block37344'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                });
            </script>            
			[/@api]                        		
		</div>       
	</div>
</div>