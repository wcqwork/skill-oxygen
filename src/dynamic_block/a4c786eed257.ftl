<section class="hot-products fade-in" id="hot-products">

  <div class="container">
    <div class="section-header">
      <h2>Hot Products</h2>
      <div class="subtitle">To provide reliable personal protective equipment for workers on an ongoing basis.</div>
    </div>
    
[@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'10'}"  dataIds = "${dataIds!''}" dataGroupId = "${dataGroupId!''}" productGroupId = "${productGroupId!'-1'}"
		 dataType="${dataType!'0'}" jumpMethod="${jumpMethod!'0'}"
		  layoutStyle="${layoutStyle!'0'}" orderBy="${orderBy!'0'}"
		  expandIds="${expandIds!''}" productId="${productId!-1}" currentPageIdForRelated="${pageId!-1}"
		  articleRelatedId="${infoId!-1}"
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
				articleRelatedId: "$articleRelatedId"
				currentPageIdForRelated: "$currentPageIdForRelated"
				}) {
				totalRow
				pageSize
				pageNumber
				extraData{
					coinSymbol
					isB2cPlan
					prodStructureData
					summaryRichTextFlag
				}
				list {
					encodeId
					prodName 
					prodPrice
					prodBrief
					commentStar
					prodMaxPrice
					prodMinPrice
					prodDiscountPrice
					prodUrl
					photoUrlList
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
<div class="carousel-track-wrapper" id="productCarouselWrapper">
      <div class="carousel-track" id="productCarousel">
        
[#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
[#list data.productList.list as product]
<div class="product-card"><div class="img-wrap"><img src="${product.photoUrlList[0]!}" alt="${product.prodName!?html}"></div>
          <div class="name">${product.prodName!?html}</div>
        </div>
[/#list]
[#else]
<div class="no-data">No content available</div>
[/#if]

        
        
        
        
        
        
        
        
        
      </div>
    </div>
<input type="hidden" name="totalRow" value="${data.productList.totalRow!'0'}">
<input type="hidden" name="pageNumber" value="${data.productList.pageNumber!'1'}">
<input type="hidden" name="pageSize" value="${data.productList.pageSize!'20'}">
<script> 
			\$(function(){
				window._block_namespaces_['prodlist_editor13'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'aaa_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}', 'productGroupId':'${productGroupId!}'});
			});
		<\/script>
[/@api]

  </div>
</section>