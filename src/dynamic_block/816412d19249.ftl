<section class="product-categories fade-in" id="product-categories">

  <div class="container">
    
[@api method="post" url="/phoenix2/composite/graphql" jumpMethod="${jumpMethod!'0'}"
			selectGroupIds="${selectGroupIds!''}"
			expandIds="${expandIds!''}"
			query='{
				 productGroupList(selectGroupIds: $selectGroupIds, optionsParam: $optionsParam) {
					encodeId
					groupName
					groupUrl
					parentGroupId
					subGroups
					showFieldList
				}
			}']
<div class="grid">
      <div class="main-card">
        <img src="//g3.leadongcdn.cn/cloud/jiBpjKiilpSRikimnnjrjo/default_img.png" alt="Body Protection">
        <div class="overlay">
          <div class="brand-label">Laan Protection Technology</div>
          <h3><span>Body Protection</span></h3>
          <div class="sub">Chemical Protective Suits</div>
          <div class="card-desc">It is devoted to the research, development, production and sales of occupational health and personal protective equipment.</div>
          <a href="#" class="view-link">View More</a>
        </div>
      </div>
      <div class="side-grid">
        
[#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
[#list data.productGroupList as group]
<div class="side-card"><img src="${group.groupPhotoUrlList[0]!}" alt="${group.groupName!?html}">
          <div class="overlay">
            <div class="brand-label">Laan Protection Technology</div>
            <h3>${group.groupName!?html}</h3>
            <div class="sub">Protection</div>
            <a href="${group.groupUrl!''}" class="view-link">${group.groupName!?html}</a>
          </div>
        </div>
[/#list]
[#else]
<div class="no-data">No content available</div>
[/#if]

        
        
        
      </div>
    </div>
<script>
			\$(function(){
				window._block_namespaces_['prodlist_group39404'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'groupProduct_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});

			});
		<\/script>
[/@api]

  </div>
</section>