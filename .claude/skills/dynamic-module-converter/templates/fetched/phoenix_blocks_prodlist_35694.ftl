<div data-gjs-type="phoenix-container" data-strong="1">
	[#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
	[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
	<!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
	<style data-collect='1'>
		.block35694 .content {
			text-align: center !important;   
		}
		.block35694 .title a {
			text-align: center !important;  
		}
	</style>
	[/#if]
	<div class="backstage-blocksEditor-wrap" data-block-uuid="productlist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,pageNumber"
		data-block-type="phoenix_blocks_prodlist"
		data-default-setting={"pageSize":10,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>
		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1:var(--ld-main1, rgb(208, 47, 53, 0.94));
			}
		</style>

		<div class="block35694">
            [@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"  dataIds = "${dataIds!''}" dataGroupId = "${dataGroupId!''}" productGroupId = "${productGroupId!'-1'}"
		 dataType="${dataType!'0'}" jumpMethod="${jumpMethod!'0'}"
		  layoutStyle="${layoutStyle!'0'}" orderBy="${orderBy!'0'}"
		  expandIds="${expandIds!''}" productId="${productId!-1}"
			query='{
			productList(
				conditionDto:{
				searchGroupIds: $dataGroupId
				searchProdIds: $dataIds
				prodType: "$dataType"
				page: $page
				limit: $limit
				orderBy: "$orderBy"
				optionsParam: $optionsParam
				prodRelatedId: "$productId"
				prodCateIdByPage: "$productGroupId"
				}) {
				totalRow
				pageSize
				pageNumber
				extraData{
					coinSymbol
					isB2cPlan
					prodStructureData
				}
				list {
					encodeId
					prodName 
					prodPrice
					prodBrief
					prodMaxPrice
					prodMinPrice
					prodDiscountPrice
					prodUrl
					photoUrlList
					photoSeoList{
						photoId
						photoUrlNormal
						photoAlt
						photoTitle
					}
					enabledTrade
					isSkuProd
					showFieldList
					customFieldList
					$showField
					phoenixProductSubVo{
						hasProdVideo
					}
				}
			}
		}']
            
            <div class="proshow-container">
                <div class=" wra" >
                     [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                     <div class="proshow-top-shell">
                        <div class="proshow-top-content">
                            <div class="proshow-scroll-box"> 
                                <div class="proshow-scroll-list wrapper"> 
                                    [#list data.productList.list as productRolling]
                                        <div class="proshow-scroll-item tile">
                                            <div class="proshow-scroll-main">
                                                <div class="imgBox">
                                                    <a href="${productRolling.prodUrl}" class="proshow-image" title="${productRolling.prodName!?html}">
                                                        <img src="${productRolling.photoUrlList[0]!}" alt="${productRolling.photoSeoList[0].photoAlt!}" title="${productRolling.photoSeoList[0].photoTitle!}">
                                                        </a>

                                                    <div class="proshow-caption textBox">
                                                        <div class="iconBox">
                                                            <i class="icon iconfont_phoenix icon-jia-2"></i>
                                                        </div>
                                                        <div class="proshow-title title">
                                                            <div class="heading5"> <a href="${productRolling.prodUrl}" class="heading5">${productRolling.prodName!?html}</a> </div>
                                                        </div>
                                                        <div class="paragraph1 content" >${productRolling.prodBrief!}</div>
                                                        <a class="paragraph2 btn" href="${productRolling.prodUrl}"> <span> [@s.m "phoenix_view_more" /] </span></a>
                                                    </div>
                                                </div>

                                                <div class="titleBox">
                                                    <div class="proshow-title title">
                                                        <h3 class="heading5"> <a href="${productRolling.prodUrl}" class="heading5" >${productRolling.prodName!?html}</a> </h3>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    [/#list]
                                    
                                    </div>

                            </div>
                        </div>
                    </div>
                    [#else] 
                    <div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>
                    [/#if]
                </div>
            </div>


                    <script>
                        $(function(){
                            window._block_namespaces_['block35694'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'productlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                        });
                    </script>
                    <script type="application/ld+json">
                        ${data.productList.extraData.articleStructureData!""}
                    </script>

                [/@api]
		</div>

	</div>
</div>