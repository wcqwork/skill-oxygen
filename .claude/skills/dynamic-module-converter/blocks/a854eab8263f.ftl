<div data-gjs-type="phoenix-container" data-strong="1">
[#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
	<!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
    <style data-collect='1'>
		.block34774 .Box .r-tabs-panel .item .Textword .round {
			transform: rotate(180deg); 
		}
		.block34774 .slick-dots {
			position: relative;
			direction: ltr!important;
		}		
	</style>
[/#if]

	<div class="backstage-blocksEditor-wrap" data-block-uuid="prodlist" data-gjs-type="developer-node-component"
		data-block-list-setting="dataSelect,pageNumber" data-block-type="phoenix_blocks_prodlist"
		data-default-setting={"pageSize":4,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"0","refreshMethod":"0","jumpMethod":"0","expandIds":{"functionBtn":{"label":"功能按钮","key":"functionBtn","draggable":true,"data":[{"label":"询盘","key":"inquiry","value":"1","checked":false},{"label":"加入询盘栏","key":"addInquiry","value":"2","checked":false},{"label":"立即购买","key":"buyNow","value":"3","checked":false},{"label":"加入购物车","key":"addBasket","value":"4","checked":false}]},"showField":{"label":"显示字段","key":"showField","draggable":false,"data":[{"fieldName":"星级评价","fieldId":"starRating","fieldType":"100","value":"1","checked":false},{"fieldName":"简介","fieldId":"briefIntroduction","fieldType":"101","value":"2","checked":false},{"fieldName":"品牌","fieldId":"prodBrand","fieldType":"0","value":"3","checked":false},{"fieldName":"型号","fieldId":"prodModel","fieldType":"0","value":"4","checked":false},{"fieldName":"编码","fieldId":"prodCode","fieldType":"0","value":"5","checked":false}]}},"expandSort":["functionBtn","showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>

		<style>
			[data-new-auto-uuid="${pageNodeId!''}"] {
				--color-match-setting1: var(--ld-main1, #C80108);
				--color-match-setting2: var(--ld-Auxiliary1, #EDEDED);
			}
		</style>

		<div class="block34774">

			<div class="Box">
				<div class="prodCategoty-container">
					<div class="site-category">
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
						groupDescription
						}
						}']
						[#if data?? && data.productGroupList?? && (data.productGroupList?size > 0)]
						<div class="hidden-scrollBar">
							<div class="arrowsjantou">
								<div class="leftClick">
									<svg t="1656320458872" class="icon" viewBox="0 0 1024 1024" version="1.1"
										xmlns="http://www.w3.org/2000/svg" p-id="5900" width="28" height="28">
										<path
											d="M362.610347 512l396.401777-388.551111a56.547556 56.547556 0 1 0-79.189333-80.782222L245.305458 468.650667A60.757333 60.757333 0 0 0 227.556124 512c0 16.497778 6.485333 32.199111 17.749334 43.349333l434.631111 425.984a56.547556 56.547556 0 0 0 79.075555-80.782222L362.610347 512z"
											fill="#ffffff" p-id="5901"></path>
									</svg>
								</div>
								<div class="rightClick">
									<svg t="1656320479303" class="icon" viewBox="0 0 1024 1024" version="1.1"
										xmlns="http://www.w3.org/2000/svg" p-id="6076" width="28" height="28">
										<path
											d="M661.389084 511.544889L264.987307 123.335111a56.547556 56.547556 0 0 1 79.075555-80.782222l434.631111 425.642667c11.377778 11.150222 17.749333 26.851556 17.749334 43.235555a60.643556 60.643556 0 0 1-17.749334 43.349333l-434.631111 425.642667a56.547556 56.547556 0 0 1-79.075555-80.782222l396.401777-388.096z"
											fill="#ffffff" p-id="6077"></path>
									</svg>
								</div>
							</div>
							<div class="outer-vertical-nav">
								<ul class="r-tabs-nav fix">
									[#list data.productGroupList as group]
									[#assign temps='']
									[#if group_index==0] [#assign temps='first'][#elseif group_index==table_data?size-1]
									[#assign temps='last'][/#if]
									<li class="r-tabs-tab ${temps!}">
										<div class="imgbox">
											<img class="catepic" src="${group.groupPhotoUrlList[0]!}" alt="${group.groupName!?html}" title="${group.groupName!?html}">
                                                    </div>
											<div class="r-tabs-anchor paragraph2">${group.groupName!''}</div>
											<div class="link_after">
												<div class="after"></div>
											</div>
											<div class="link"></div>
									</li>
									[/#list]
								</ul>
							</div>
						</div>
						<div class="BoxBottom">
							<div class="left">
								<svg t="1656320458872" class="icon" viewBox="0 0 1024 1024" version="1.1"
									xmlns="http://www.w3.org/2000/svg" p-id="5900" width="28" height="28">
									<path
										d="M362.610347 512l396.401777-388.551111a56.547556 56.547556 0 1 0-79.189333-80.782222L245.305458 468.650667A60.757333 60.757333 0 0 0 227.556124 512c0 16.497778 6.485333 32.199111 17.749334 43.349333l434.631111 425.984a56.547556 56.547556 0 0 0 79.075555-80.782222L362.610347 512z"
										fill="#ffffff" p-id="5901"></path>
								</svg>
							</div>
							<div class="right">
								<svg t="1656320479303" class="icon" viewBox="0 0 1024 1024" version="1.1"
									xmlns="http://www.w3.org/2000/svg" p-id="6076" width="28" height="28">
									<path
										d="M661.389084 511.544889L264.987307 123.335111a56.547556 56.547556 0 0 1 79.075555-80.782222l434.631111 425.642667c11.377778 11.150222 17.749333 26.851556 17.749334 43.235555a60.643556 60.643556 0 0 1-17.749334 43.349333l-434.631111 425.642667a56.547556 56.547556 0 0 1-79.075555-80.782222l396.401777-388.096z"
										fill="#ffffff" p-id="6077"></path>
								</svg>
							</div>
							<div class="tab-container container-ScrollBar">
								[#list data.productGroupList as group]
								<div class="tab-container-inner">
									<div class="r-tabs-accordion-title">
										<a class="r-tabs-anchor paragraph2"
											href="javascript:;">${group.groupName!?html}</a>
									</div>
									[@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}"
									limit="${pageSize!'6'}" dataGroupId = "${group.encodeId!''}"
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
										[#if data?? && data.productList?? && data.productList.list?? &&
										(data.productList.list?size > 0)]
										<ul class="sitewidget-prodTabList-cont fix">
											[#list data.productList.list as product]
											<li class="item">
												<div class="prodTabList-wrapper">
													<div class="tabList-wrapper-inner">
														<div class="prodTabList-cell">
															<a href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}">
																<img src="${product.photoUrlList[0]!}" alt="${product.prodName!?html}" alt="${product.photoSeoList[0].photoAlt!?html}" title="${product.photoSeoList[0].photoTitle!?html}"/>
                                                            </a>
														</div>
													</div>
													<div class="Textword">
														<h3>
															<a class="breakWord heading5" href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}">${product.prodName!''}</a>
														</h3>
														<a href="${product.prodUrl!'javascript:void(0)'}" title="${product.prodName!?html}">
															<div class="round">
																<div class="roundRight">
																	<svg t="1656319099437" class="icon"
																		viewBox="0 0 1024 1024" version="1.1"
																		xmlns="http://www.w3.org/2000/svg" p-id="6087"
																		width="14" height="14">
																		<path
																			d="M250.809686 1004.945409a65.525754 65.525754 0 0 1-4.933047-84.513331l5.212276-5.956887L641.358073 514.712245 250.809686 109.085488A65.525754 65.525754 0 0 1 245.783562 24.572158L251.088915 18.615271a60.685784 60.685784 0 0 1 81.907192-5.026123l5.863811 5.305352 434.294274 451.048018c22.338325 23.082936 23.920623 59.382715 4.933047 84.420254l-5.212276 6.049963-434.387351 444.904979a60.685784 60.685784 0 0 1-87.677926-0.372305z"
																			p-id="6088" fill="#ffffff"></path>
																	</svg>
																</div>
															</div>
														</a>
													</div>
													<div class="prodBrief paragraph1">${product.prodBrief!''}</div>
												</div>
											</li>
											[/#list]
										</ul>
										[/#if]
									</div>
									[/@api]
								</div>
								[/#list]
							</div>
						</div>
						[/#if]

						<script>
							$(function () {
                                    window._block_namespaces_['block34774'].init({ 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'nodeId': 'prodlist_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}' });
                                });
						</script>

						[/@api]

					</div>
				</div>
			</div>

		</div>
	</div>
</div>