[#assign isAlaBolanguageStr = '' ]
[#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
    [#assign isAlaBolanguage = 'alaboyulanguage' ]
[/#if]
<div class="backstage-blocksEditor-wrap wra block_27472 ${isAlaBolanguage}" data-block-uuid="aaa" data-dynamic-type="articleList"  data-dynamic-toolbar="1"  data-gjs-type="developer-node-component"  data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"文章标题","fieldId":"articleTitle","fieldType":"0","value":"1","checked":true},{"fieldName":"文章简介","fieldId":"articleSummary","fieldType":"0","value":"2","checked":true},{"fieldName":"日期","fieldId":"publishTime","fieldType":"0","value":"3","checked":true},{"fieldName":"文章分类","fieldId":"cateName","fieldType":"0","value":"4","checked":true}]}},"expandSort":["showField"],"layoutStyle":"0"}>
        [#if componentSetting?? && componentSetting != ""]
            [#assign componentSettingJSON=componentSetting?eval /]
            [#if componentSettingJSON?? && componentSettingJSON.dynamicFontTab??]
                [#list componentSettingJSON.dynamicFontTab as item]
                    [#list item.saveData as saveDataItem]
                        [#if saveDataItem.styleKey?? && saveDataItem.styleKey == 'currentFontStyleClass']
                            [#if item.value?? && item.value == 'articleTitleFont']
                                [#assign htmlClass_articleTitleFont = saveDataItem.defaultFont /]                            
                            [/#if]
                            [#if item.value?? && item.value == 'articleDecFont']
                                [#assign htmlClass_articleDecFont = saveDataItem.defaultFont /]                            
                            [/#if]
                            [#if item.value?? && item.value == 'articleDateFont']
                                [#assign htmlClass_articleDateFont = saveDataItem.defaultFont /]                            
                            [/#if]
                            [#if item.value?? && item.value == 'articleCateFont']
                                [#assign htmlClass_articleCateFont = saveDataItem.defaultFont /]                            
                            [/#if]
                        [/#if]
                        [#if saveDataItem.styleKey?? && saveDataItem.styleKey == 'currentFontName']
                            [#assign fontMap = {
                                'H1': 'h1',
                                'H2': 'h2',
                                'H3': 'h3',
                                'H4': 'h4',
                                'H5': 'h5',
                                'H6': 'h6',
                                'DIV': 'div',
                                'P': 'p',
                                'P1': 'p',
                                'P2': 'p',
                                'P3': 'p'
                            } /]
                            [#if item.value?? && item.value == 'articleTitleFont']                           
                                [#assign htmlTarget_articleTitleFont = fontMap[saveDataItem.defaultFont?upper_case]! 'div' /]
                            [/#if]

                        [/#if]
                    [/#list]
                [/#list]
                
            [/#if]
        [/#if]

        [@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"
            selectArticleCateType="${dataType!'0'}" selectCateIds="${dataGroupId!''}" selectArticleIds="${dataIds!''}" currentPageIdForRelated="${pageId!-1}"
            orderBy="${orderBy!'0'}" expandIds="${expandIds!''}" articleId="${infoId!-1}" articlePageId="${infoGroupId!-1}"
            prodRelatedId="${productId!-1}"
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
                    articleStatus: "1"
                    prodRelatedId: "$prodRelatedId"
                    currentPageIdForRelated: "$currentPageIdForRelated"
                    }) {
                    totalRow
                    pageSize
                    pageNumber
                    extraData{
                        articleStructureData
                        articleSummaryRichTextFlag
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
            <div class="block-article-container-replace">
                <ul class="block-article-container container-4-3 [#if layoutStyle == '1']columns-4[/#if]">
                    [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                        [#list data.articleList.list as article]
                            <li>
                                <div>
                                    <a class="img-container" href="${article.articleUrl!''}"  target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">
                                        <img loading="lazy" title="${article.articleTitle!''}"  alt="${article.articleTitle!''}" src="${article.photoUrlNormal!''}">
                                    </a>
                                    [#if article.showFieldList?? && article.showFieldList?size > 0]
                                        <div class="content-container">
                                            [#list article.showFieldList as field]
                                                [#if field.fieldId?? && field.fieldId == "articleTitle"]
                                                 <${htmlTarget_articleTitleFont!'div'} class="title ${htmlClass_articleTitleFont!'heading5'}"> <a class="position" href="${article.articleUrl!''}" target="[#if !jumpMethod?? || jumpMethod != '1']_blank[/#if]">${article.articleTitle!''}</a></${htmlTarget_articleTitleFont!'div'}>
                                                [/#if]
                                                [#if field.fieldId?? && field.fieldId == "articleSummary"]   
                                                    <div class="brief position  ${htmlClass_articleDecFont!'paragraph1'}">
                                                        [#if data.articleList.extraData.articleSummaryRichTextFlag == '1']
                                                            ${article.articleSummary!}
                                                        [#else]
                                                            ${article.articleSummary?html}
                                                        [/#if]
                                                    </div>
                                                [/#if]
                                                [#if field.fieldId?? && field.fieldId == "cateName"]  
                                                    <div class="classify position  ${htmlClass_articleCateFont!'paragraph1'}">${article.cateName!''}</div>
                                                [/#if]
                                                [#if field.fieldId?? && field.fieldId == "publishTime"]  
                                                <time class="time position  ${htmlClass_articleDateFont!'paragraph2'}">${article.publishTime!''}</time>
                                                [/#if]
                                            [/#list]
                                        </div>
                                    [/#if]
                                </div>
                            </li>
                        [/#list]
                    [#else]
                        <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                    [/#if]
                </ul>
                <input type="hidden" name="totalRow" value="${data.articleList.totalRow!'0'}"> 
                <input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!'1'}">
                <input type="hidden" name="pageSize" value="${data.articleList.pageSize!'10'}">
                <input type="hidden" name="productId" value="${productId!'-1'}">
                <input type="hidden" name="dataType" value="${dataType!'0'}">
                <input type="hidden" name="infoId" value="${infoId!'-1'}">
            </div>
            [#if (!loadMethod?? || loadMethod == '0')]
                <div class="artclelist-site-pagination-27472 paragraph1 [#if data.articleList.pageSize?? && data.articleList.totalRow?? && data.articleList.totalRow <=  data.articleList.pageSize]hide[/#if]">
                    <div class="artclelist-laypage-normal" id='artclelist-laypage-normal'></div>
                </div>
            [/#if]
        	<script>
                $(function(){
                    window._block_namespaces_['articleList_27472'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'aaa_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}','articlePageId':"${infoGroupId!}"});
                });
            </script>
             <script type="application/ld+json">
                 ${data.articleList.extraData.articleStructureData!""}
            </script>
	[/@api]
        
</div>