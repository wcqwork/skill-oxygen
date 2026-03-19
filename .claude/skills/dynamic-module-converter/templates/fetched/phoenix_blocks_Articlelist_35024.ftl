<div data-gjs-type="phoenix-container" data-strong="1">
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
    [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
        <style data-collect='1'>
        .block35024 .left .ArticlePicList_ItemContentInnerH5,
        .block35024 .left .ArticlePicList_ItemContentInnerP,
        .block35024 .left .ArticlePicList_ItemContentInnerH5 a,
        .block35024 .art .ArticlePicList_ItemContentInnerBox,
        .block35024 .left .time {
            text-align: right;
            direction: rtl;
        }
        </style>
    [/#if]
<div class="block35024" data-block-uuid="articlelist"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber,dataOrderBy,showDate,jumpMethod"  data-block-type="phoenix_blocks_Articlelist" data-default-setting={"pageSize":4,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"1","expandIds":{"showField":{"draggable":false,"data":[{"fieldName":"文章标题","checked":false,"fieldType":"0","value":"1","fieldId":"articleTitle"},{"fieldName":"文章简介","checked":false,"fieldType":"0","value":"2","fieldId":"articleSummary"},{"fieldName":"日期","checked":false,"fieldType":"0","value":"3","fieldId":"publishTime"},{"fieldName":"文章分类","checked":false,"fieldType":"0","value":"4","fieldId":"cateName"}],"label":"显示字段","key":"showField"}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
    <style>
      [data-new-auto-uuid="${pageNodeId!''}"] {
        --color-match-setting1: var(--ld-main1, rgb(74, 134, 232));
      }
    </style>
          [@api method="post"  url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"
            selectArticleCateType="${dataType!'0'}" selectCateIds="${dataGroupId!''}" selectArticleIds="${dataIds!''}"
            orderBy="${orderBy!'0'}" expandIds="${expandIds!''}" jumpMethod="${jumpMethod!'0'}" articleId="${infoId!-1}" articlePageId="${infoGroupId!-1}"
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
    <div class="backstage-blocksEditor-wrap">
        <div class="left"></div>
        [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 4)]
        <div class="prev">
            <i class="icon iconfont_phoenix icon-angle-up lead_icon lead-icon-type"></i>
        </div>
        <div class="next">
            <i class="icon iconfont_phoenix icon-angle-down lead_icon lead-icon-type"></i>
        </div> 
        [/#if] 
    <div class="art">    
            [#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]
                [#list data.articleList.list as article]
                    <div class="ArticlePicList_Item">
                         <div class="imgBox">
                            <img class="headlines-content-img ArticlePicList_ItemImg"  loading="lazy" src="${article.photoUrlNormal!''}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">
                        </div> 
                        <div class="ArticlePicList_ItemContent">
                            <div class="ArticlePicList_ItemContentInner">
                                <div class="ArticlePicList_ItemContentInnerBox">
                                    <h3 class="ArticlePicList_ItemContentInnerH5">
                                       <a target="[#if jumpMethod == '0']_blank[#else]_self[/#if]" class="heading5" href="${article.articleUrl!''}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>
                                    </h3>
                                    <div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph1">${article.articleSummary!''}</div>                                    
                                    [#if showDate && showDate == 1]
                                    <div class="time paragraph2">
                                        <time>${article.publishTime?date("yyyy-MM-dd")?string('yyyy')}/${article.publishTime?date("yyyy-MM-dd")?string('MM')}/${article.publishTime?date("yyyy-MM-dd")?string('dd')}</time>
                                    </div> 
                                    [/#if]                                   
                                    <div class="butn">
                                        <div class="right">
                                            <a target="[#if jumpMethod == '0']_blank[#else]_self[/#if]" class="ArticlePicList_ItemContentInnerA" href="${article.articleUrl!''}"><i class="icon iconfont_phoenix icon-jiantouyou-5 lead_icon lead-icon-type"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                [/#list]
                [#else]
                <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                [/#if]
        </div>
            </div>
<script>
$(function(){
        window._block_namespaces_['block35024'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'articlelist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
    });
</script>
    <script type="application/ld+json">
        ${data.articleList.extraData.articleStructureData!""}
</script>
    </div>
    [/@api]
</div>
</div>