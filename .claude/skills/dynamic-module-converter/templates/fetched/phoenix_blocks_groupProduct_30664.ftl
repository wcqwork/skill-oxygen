<div data-gjs-type="phoenix-container" data-strong="1">
    
    [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
	[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
	<!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
	<style data-collect='1'>
		.block30664 .prodBrief {
            text-align: right;
        }
        .block30664 .nameAndBrief {
            text-align: right;
        }
        .block30664 .viewMoreBtn {
            right: 50%;
            transform: translateX(50%);
        }
        .block30664 .viewMoreBtn span {
            transform: rotate(180deg);
        }
	</style>
	[/#if]
  <div class="backstage-blocksEditor-wrap block30664" data-block-uuid="prod_30664"  data-gjs-type="developer-node-component" data-block-list-setting="dataSelect,pageNumber,jumpMethod" data-block-type="phoenix_blocks_groupProduct" data-default-setting={"pageSize":6,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>

    <style>
      [data-new-auto-uuid="${pageNodeId!''}"] {
        --color-match-setting1: var(--ld-main1, #233CAE);
        --color-match-setting2: var(--ld-Auxiliary1, #53A0FD);
        --color-match-setting3: var(--ld-Auxiliary2, #2ABA70);
      }
    </style>
      <div class="box">
          <div class="bottom">
              <div class="prodCategoty-container">
                [@api method="post" url="/phoenix2/composite/graphql"
                selectGroupIds="${dataGroupId!''}"
                expandIds="${expandIds!''}"
                jumpMethod="${jumpMethod!'0'}"
                query='{
                    productGroupList(selectGroupIds: $selectGroupIds, optionsParam: $optionsParam) {
                        encodeId
                        groupName
                        groupUrl
                        groupPhotoUrlList
                    }
                }']
                [#assign targetType='']
                [#if !jumpMethod?? || jumpMethod != '1']
                [#assign targetType='_blank']
                [/#if]
                      [#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
                      <div class="hidden-scrollBar">
                          <div class="arrows">
                              <div class="leftBtn">
                                  <svg t="1679385367929" class="icon" viewBox="0 0 1024 1024" version="1.1"
                                      xmlns="http://www.w3.org/2000/svg" p-id="12153" width="32" height="32">
                                      <path d="M143 462h800c27.6 0 50 22.4 50 50s-22.4 50-50 50H143c-27.6 0-50-22.4-50-50s22.4-50 50-50z"
                                          p-id="12154" fill="#2c2c2c"></path>
                                      <path d="M116.4 483.3l212.1 212.1c19.5 19.5 19.5 51.2 0 70.7s-51.2 19.5-70.7 0L45.6 554c-19.5-19.5-19.5-51.2 0-70.7 19.6-19.6 51.2-19.6 70.8 0z"
                                          p-id="12155" fill="#2c2c2c"></path>
                                      <path d="M328.5 328.6L116.4 540.7c-19.5 19.5-51.2 19.5-70.7 0s-19.5-51.2 0-70.7l212.1-212.1c19.5-19.5 51.2-19.5 70.7 0s19.5 51.2 0 70.7z"
                                          p-id="12156" fill="#2c2c2c"></path>
                                  </svg>
                                  <!-- <svg t="1677813272058" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1446" width="48" height="48"><path d="M384 512l192 192 29.866667-29.866667-162.133334-162.133333 162.133334-162.133333-29.866667-29.866667L384 512z" fill="#2c2c2c" p-id="1447"></path></svg> -->
                              </div>
                              <div class="rightBtn">
                                  <svg t="1679385399477" class="icon" viewBox="0 0 1024 1024" version="1.1"
                                      xmlns="http://www.w3.org/2000/svg" p-id="12470" width="32" height="32">
                                      <path d="M881 562H81c-27.6 0-50-22.4-50-50s22.4-50 50-50h800c27.6 0 50 22.4 50 50s-22.4 50-50 50z"
                                          p-id="12471" fill="#2c2c2c"></path>
                                      <path  d="M907.6 540.7L695.5 328.6c-19.5-19.5-19.5-51.2 0-70.7s51.2-19.5 70.7 0L978.4 470c19.5 19.5 19.5 51.2 0 70.7-19.6 19.6-51.2 19.6-70.8 0z"
                                          p-id="12472" fill="#2c2c2c"></path>
                                      <path d="M695.5 695.4l212.1-212.1c19.5-19.5 51.2-19.5 70.7 0s19.5 51.2 0 70.7L766.2 766.1c-19.5 19.5-51.2 19.5-70.7 0s-19.5-51.2 0-70.7z"
                                          p-id="12473" fill="#2c2c2c"></path>
                                  </svg>
                                  <!-- <svg t="1677813292987" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1793" width="48" height="48"><path d="M644.266667 494.933333l-192 192-29.866667-29.866666 162.133333-162.133334-162.133333-162.133333 29.866667-29.866667 192 192z" fill="#2c2c2c" p-id="1794"></path></svg> -->
                              </div>
                          </div>
                          <div class="outer-vertical-nav">
                              <ul class="r-tabs-nav fix tabList slider-nav">
                                  [#list data.productGroupList as group]
                                  <div class="tabs" data-index="${group_index!}" >
                                      <li class="r-tabs-tab[#if group_index==0] first[#elseif group_index==data.productGroupList?size-1] last[/#if] proTab">
                                          <!-- <a class="img2" href="${group.groupUrl}" title="${group.groupName!?html}"> -->
                                          <div class="tabImgBox">
                                              <img class="catepic" src="${group.groupPhotoUrlList[0]!''}" alt="${group.groupName!?html}" title="${group.groupName!?html}">
                                          </div>
                                          <!-- </a> -->
                                          <div class="tabName paragraph2">
                                              ${group.groupName!''}
                                          </div>
                                          <div class="singleArrow">
                                              <svg t="1679384413804" class="icon" viewBox="0 0 1024 1024" version="1.1"
                                                  xmlns="http://www.w3.org/2000/svg" p-id="6735" width="24" height="24">
                                                  <path
                                                      d="M512 56.889c251.364 0 455.111 203.747 455.111 455.111S763.364 967.111 512 967.111 56.889 763.364 56.889 512 260.636 56.889 512 56.889z m-179 532.11l179-179 179 179a28.444 28.444 0 0 0 40.221-40.22l-199.11-199.111a28.444 28.444 0 0 0-40.221 0l-199.111 199.11A28.444 28.444 0 0 0 332.999 589z"
                                                      p-id="6736" fill="#ffffff"></path>
                                              </svg>
                                          </div>
                                      </li>
                                      <div class="mobileShow">
                                          <div class="tab-container-inner" data-pahe="${pageSize!'6'}">
                                            [@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'6'}" dataGroupId = "${group.encodeId!''}" 
                                                    query='{
                                                    productList(
                                                        conditionDto:{
                                                        groupId: "$dataGroupId"
                                                        page: $page
                                                        limit: $limit
                                                        }) {
                                                        list {
                                                            encodeId
                                                            prodName 
                                                            prodBrief
                                                            prodUrl
                                                            photoUrlList
                                                            photoSeoList{
                                                                photoId
                                                                photoUrlNormal
                                                                photoAlt
                                                                photoTitle
                                                            }
                                                        }
                                                    }
                                                }']
  
                                              <div class="r-tabs-panel article-cate-box">
                                                [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                                                  <ul class="sitewidget-prodTabList-cont fix proList">
                                                    [#list data.productList.list as product]
                                                      <li class="proItem">
                                                          <div class="prodTabList-wrapper">
                                                              <div class="tabList-wrapper-inner tabInner">
                                                                  <div class="prodTabList-cell">
                                                                      <a href="${product.prodUrl!'javascript:void(0)'}" target="${targetType!?html}" title="${product.prodName!?html}">
                                                                          <img src="${product.photoUrlList[0]!?html}" alt="${product.photoSeoList[0].photoAlt!?html}" title="${product.photoSeoList[0].photoTitle!?html}" />
                                                                      </a>
                                                                  </div>
                                                              </div>
                                                              <div class="nameAndBrief">
                                                                  <h3>
                                                                      <a class="breakWord heading5" href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}" target="${targetType!?html}">${product.prodName!''}</a>
                                                                  </h3>
                                                                <div class="paragraph1"><div class="prodBrief">${product.prodBrief!''}</div></div>
                                                                <a class="proMoreBtn paragraph2" href="${product.prodUrl!'javascript:void(0)'}" target="${targetType!?html}">[@s.m "phoenix_view_more" /]</a>
                                                              </div>
                                                          </div>
  
                                                      </li>
                                                      [/#list]
  
                                                  </ul>
  
                                                  [/#if]
                                              </div>
  
                                              [/@api]
                                              <a class="viewMoreBtn hide paragraph2" href="${group.groupUrl}">
                                                  [@s.m "phoenix_view_more" /]
                                                  <span>
                                                      <svg t="1679385399477" class="icon" viewBox="0 0 1024 1024"
                                                          version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="12470"
                                                          width="16" height="16">
                                                          <path
                                                              d="M881 562H81c-27.6 0-50-22.4-50-50s22.4-50 50-50h800c27.6 0 50 22.4 50 50s-22.4 50-50 50z"
                                                              p-id="12471" fill="#2c2c2c"></path>
                                                          <path
                                                              d="M907.6 540.7L695.5 328.6c-19.5-19.5-19.5-51.2 0-70.7s51.2-19.5 70.7 0L978.4 470c19.5 19.5 19.5 51.2 0 70.7-19.6 19.6-51.2 19.6-70.8 0z"
                                                              p-id="12472" fill="#2c2c2c"></path>
                                                          <path
                                                              d="M695.5 695.4l212.1-212.1c19.5-19.5 51.2-19.5 70.7 0s19.5 51.2 0 70.7L766.2 766.1c-19.5 19.5-51.2 19.5-70.7 0s-19.5-51.2 0-70.7z"
                                                              p-id="12473" fill="#2c2c2c"></path>
                                                      </svg>
                                                  </span>
                                              </a>
                                          </div>
                                      </div>
                                  </div>
                                  [/#list]
                                  <!-- <li class="move-slider hide"></li> -->
                              </ul>
                          </div>
                      </div>
                      <div class="tab-container container-ScrollBar slider-for hide">
                        [#list data.productGroupList as group]
                          <div class="tab-container-inner" data-tgs="${group.encodeId!''}">

                            [@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!'6'}" dataGroupId = "${group.encodeId!''}" 
                                    query='{
                                    productList(
                                        conditionDto:{
                                        groupId: "$dataGroupId"
                                        page: $page
                                        limit: $limit
                                        }) {
                                        list {
                                            encodeId
                                            prodName 
                                            prodBrief
                                            prodUrl
                                            photoUrlList
                                        }
                                    }
                                }']
                              <div class="r-tabs-panel article-cate-box">
                                [#if data?? && data.productList?? && data.productList.list?? && (data.productList.list?size > 0)]
                                  <ul class="sitewidget-prodTabList-cont fix proList">
                                    [#list data.productList.list as product]
                                      <li class="proItem">
                                          <div class="prodTabList-wrapper">
                                              <div class="tabList-wrapper-inner tabInner">
  
                                                  <div class="prodTabList-cell">
                                                      <a href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}" target="${targetType!''}">
                                                          <img src="${product.photoUrlList[0]!''}" alt="${product.photoSeoList[0].photoAlt!?html}" title="${product.photoSeoList[0].photoTitle!?html}" />
                                                      </a>
                                                  </div>
                                              </div>
                                              <div class="nameAndBrief">
                                                  <h3>
                                                      <a class="breakWord heading5" href="${product.prodUrl!'javascript:void(0)'}" target="${targetType!''}" title="${product.prodName!?html}">${product.prodName!''}</a>
                                                  </h3>                                                  
                                                  <div class="paragraph1"><div class="prodBrief">${product.prodBrief!''}</div></div>
                                                  <a class="proMoreBtn paragraph2" href="${product.prodUrl!'javascript:void(0)'}" target="${targetType!''}">[@s.m "phoenix_view_more" /]</a>
                                              </div>
                                          </div>
  
                                      </li>
                                      [/#list]
  
                                  </ul>
  
                                  [/#if]
                              </div>
  
                              [/@api]
                              <a class="viewMoreBtn hide" href="${group.groupUrl}" target="${targetType!''}">
                                  [@s.m "phoenix_view_more" /]
                                  <span>
                                      <svg t="1679385399477" class="icon" viewBox="0 0 1024 1024" version="1.1"
                                          xmlns="http://www.w3.org/2000/svg" p-id="12470" width="16" height="16">
                                          <path d="M881 562H81c-27.6 0-50-22.4-50-50s22.4-50 50-50h800c27.6 0 50 22.4 50 50s-22.4 50-50 50z"
                                              p-id="12471" fill="#2c2c2c"></path>
                                          <path d="M907.6 540.7L695.5 328.6c-19.5-19.5-19.5-51.2 0-70.7s51.2-19.5 70.7 0L978.4 470c19.5 19.5 19.5 51.2 0 70.7-19.6 19.6-51.2 19.6-70.8 0z"
                                              p-id="12472" fill="#2c2c2c"></path>
                                          <path d="M695.5 695.4l212.1-212.1c19.5-19.5 51.2-19.5 70.7 0s19.5 51.2 0 70.7L766.2 766.1c-19.5 19.5-51.2 19.5-70.7 0s-19.5-51.2 0-70.7z"
                                              p-id="12473" fill="#2c2c2c"></path>
                                      </svg>
                                  </span>
                              </a>
                          </div>
                          [/#list]
                      </div>
                      [/#if]
  

                            <script>
                                $(function(){
                                    window._block_namespaces_['block30664'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','pageNodeId':'${pageNodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
                                });
                            </script>

                      [/@api]
              </div>
          </div>
          <div class="bottomBtn">
              <svg t="1679473561343" class="bottomBtnIcon" viewBox="0 0 1024 1024" version="1.1"
                  xmlns="http://www.w3.org/2000/svg" p-id="1466" width="32" height="32">
                  <path
                      d="M533.333333 477.866667L341.333333 285.866667l29.866667-29.866667 162.133333 162.133333L695.466667 256l29.866666 29.866667-192 192z m0 256L341.333333 541.866667l29.866667-29.866667 162.133333 162.133333 162.133334-162.133333 29.866666 29.866667-192 192z"
                      fill="#2c2c2c" p-id="1467"></path>
              </svg>
          </div>
      </div>

  </div>
</div>