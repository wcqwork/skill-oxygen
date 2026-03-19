[#assign ishave3d = 'true']
[#assign templateSaveJsonData = '']

<div data-gjs-type="phoenix-container" data-strong="1">
	[#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
	[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
	<style data-collect='1'>
        .block40044 .lead_prodimg_container *,
        .block40044 .lead_slick_thumbs * {
            direction: ltr !important;
        }

        .block40044 .lead_slick_thumbs .slick-track {
            padding: 10px 0;
            margin-left: auto;
            margin-right: 0;
        }

        .block40044 .blockDetail_container_left {
            padding-left: 40px;
            padding-right: 0;
        }

        .block40044 .lead_slick {
            direction: ltr !important;
        }

        .block40044 .container_right_inquiry .prodInquire-inner span {
            margin-left: 10px;
            margin-right: 0;
        }

        @media (max-width: 1000px) {
            .block40044 .blockDetail_container_left {
                padding-left: 20px;
                padding-right: 0;
            }
        }
	</style>
	[/#if]
	<div data-block-uuid="productDetail_40044" data-block-list-setting="dataSelect,pageNumber" data-block-type="phoenix_blocks_prodDetail" data-gjs-type="developer-node-component">
        <div class="prodDetail_component block40044" data-block-uuid="productDetail_40044"  data-default-setting={}>
            <style>
                [data-new-auto-uuid="${pageNodeId!''}"] {
                    --color-match-setting1: var(--ld-main1, #000);
                }
            </style>
            [@api method="post" url="/phoenix2/composite/site/graphql/generateApiParam" apiType="common" dataRange='[{"list":["encodeId","photoUrlList","prodName","commentStar","commentTotal","prodBrief","prodBrand","prodModel","prodCode","customFieldList","productPropVo{propTypeList{name valueList{name}}}","enabledTrade","isSkuProd","prodPrice","shopProdPrice","shopProdPriceMax","minPrice","maxPrice","isCanAddToCart4ProdList","prodUrl","skuValueIdStr","productSkuItem{skuOptionItemListStr skuValueItemListStr}","phoenixProductTextVO{prodDescTitle prodDescTitle1 prodDescTitle2 prodDescTitle3 prodDescTitle4 prodDescript prodDescript1 prodDescript2 prodDescript3 prodDescript4}","phoenixProductSubVo{hasProdVideo}","prodExtraInfo{templateSaveJson}"],"extraData":["coinSymbol","isB2cPlan","prodStructureData"]}]']
                [@api method="post" version="v2" url="/phoenix2/composite/graphql" prodId="${productId!}" query='{
                    productList(conditionDto: {prodId: "$prodId$", page: 0, limit: 1,prodType:"2"}) ${data.newDataRange}
                }']
                    [#if data?? && data.productList?? && data.productList.list??]
                        [#assign specialLanCode = ["3", "45", "42", "32", "29"] ]
                        [#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]
                        <!-- 此处写小语种特殊的css代码。比如下面图1中让两个元素到右边 -->
                        <style data-collect='1'>
                            
                        </style>
                        [/#if]
                        [#list data.productList.list as product]
                        [#if product.prodExtraInfo.templateSaveJson??]
                            <textarea id="prodExtraInfo" style="display:none;opacity: 1">${product.prodExtraInfo.templateSaveJson}</textarea>
                            <!-- 有无数据,有,有权限 -->
                            [#assign ishave3d = 'true']
                                <input type="hidden" name="" id="has3d_state" value="${ishave3d}" />
                                [#assign templateSaveJsonData = product.prodExtraInfo.templateSaveJson]
                            [#else]
                                [#assign ishave3d = 'false']
                                <input type="hidden" name="" id="has3d_state" value="${ishave3d}" />
                                [#assign templateSaveJsonData = '']
                            [/#if]
                            <div style="display: none">
                                <input type="hidden" id="adaptationWindow" value="[@s.m 'ADAPTATIONWINDOW'/]">
                                <input type="hidden" id="yUp" value="[@s.m 'Y-AXISUP'/]">
                                <input type="hidden" id="zUp" value="[@s.m 'Z-AXISUP'/]">
                                <input type="hidden" id="flipUp" value="[@s.m 'FLIPUP'/]">
                                <input type="hidden" id="upwardFixation" value="[@s.m 'UPWARDFIXATION'/]">
                                <input type="hidden" id="freeOrbit" value="[@s.m 'FREEORBIT'/]">
                                <input type="hidden" id="lightMode" value="[@s.m 'LIGHTMODE'/]">
                                <input type="hidden" id="darkMode" value="[@s.m 'DARKMODE'/]">
                                <input type="hidden" id="modelDisplay" value="[@s.m 'MODELDISPLAY'/]">
                                <input type="hidden" id="backgroundColor" value="[@s.m 'BACKGROUNDCOLOR'/]">
                                <input type="hidden" id="environment" value="[@s.m 'ENVIRONMENT'/]">
                                <input type="hidden" id="showEdges" value="[@s.m 'SHOWEDGES'/]">
                                <input type="hidden" id="edgeColor" value="[@s.m 'EDGECOLOR'/]">
                                <input type="hidden" id="restorDefault" value="[@s.m 'RESTOREDEFAULT'/]">
                                <input type="hidden" id="backgroundImage" value="[@s.m 'BACKGROUNDIMAGE'/]">
                                <input type="hidden" id="modelLoading" value="[@s.m 'MODELLOADING'/]">
                                <input type="hidden" id="defaultColor" value="[@s.m 'DefaultColor'/]">
                                <input type="hidden" id="importSettings" value="[@s.m 'ImportSettings'/]">
                                <input type="hidden" id="block40044PageId" value="${pageId!''}">
                            </div>
                            <div class="linePack">
                                [#--产品图片--]
                                <div class="lead_slick_container leftAndRight " data-pid="${product.encodeId}">
                                    <div class="bigBox" data-activeindex="0">
                                        <div class="lead_slick_wrapper labelfather prodetail_labelfather">
                                            <div class="lead_prodimg_container waterfallrow-num2">
                                                [#list product.photoUrlList as photoUrlItem]
                                                <div class="prodSlick-slide">
                                                    <img data-gjs-type="default" class="lead_prod_img" src="${photoUrlItem!}" data-original="${photoUrlItem!}" alt="${product.prodName!?html}" title="${product.prodName!?html}" />
                                                    [#if photoUrlItem_index == 0 && imgMainStyle == 'waterfall']
                                                        <!-- 播放按钮 -->
                                                        <!-- 是否有视频标签 -->
                                                        [#if product.phoenixProductSubVo.hasProdVideo?? && product.phoenixProductSubVo.hasProdVideo == 'true']
                                                            <!-- <div class="playVideo center">
                                                                <svg viewBox="0 0 70 70" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                                    <path d="M34.6877 1.21753C53.1716 1.21753 68.1581 16.2012 68.1581 34.6879C68.1581 53.1718 53.1716 68.1584 34.6877 68.1584C16.201 68.1584 1.21729 53.1718 1.21729 34.6879C1.21729 16.2012 16.2009 1.21753 34.6877 1.21753Z" fill="black" fill-opacity="0.4" stroke="white"/>
                                                                    <path d="M23.3628 21.6767C23.3628 19.1858 25.1361 18.1475 27.3207 19.3492H27.3178L51.147 32.5004C53.3286 33.7079 53.3257 35.665 51.147 36.8696L27.3207 50.0208C25.1332 51.2254 23.3628 50.1696 23.3628 47.6933V21.6767Z" fill="white"/>
                                                                </svg>
                                                            </div>
                                                            <div class="video_container_box hide">
                                                            <div class="innerLink videodetail_task hide">
                                                                <video class="video_detail_palying_src_el video-js" style="max-width:100%;display:block;margin:0 auto" controls="" muted autoplay name="media" src=""></video>
                                                                </div>
                                                                <div class="waiLink videodetail_task hide">
                                                                <iframe frameborder="0" class="video-iframe" src="" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true" oallowfullscreen="true" msallowfullscreen="true" allow="autoplay" allowtransparency=""></iframe>
                                                                </div>
                                                                <div class="closeVideoPayl hide">
                                                                <svg t="1717036105846" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3107" width="32" height="32"><path d="M557.312 513.248l265.28-263.904c12.544-12.48 12.608-32.704 0.128-45.248-12.512-12.576-32.704-12.608-45.248-0.128L512.128 467.904l-263.04-263.84c-12.448-12.48-32.704-12.544-45.248-0.064-12.512 12.48-12.544 32.736-0.064 45.28l262.976 263.776L201.6 776.8c-12.544 12.48-12.608 32.704-0.128 45.248a31.937 31.937 0 0 0 22.688 9.44c8.16 0 16.32-3.104 22.56-9.312l265.216-263.808 265.44 266.24c6.24 6.272 14.432 9.408 22.656 9.408a31.94 31.94 0 0 0 22.592-9.344c12.512-12.48 12.544-32.704 0.064-45.248L557.312 513.248z" fill="" p-id="3108"></path></svg>
                                                                </div>
                                                            </div>     -->
                                                        [/#if]
                                                    [/#if]
                                                </div>
                                                [/#list]
                                            </div>
                                        </div>
                                        <!-- 播放按钮 -->
                                        <!-- 是否有视频标签 -->
                                        [#if product.phoenixProductSubVo.hasProdVideo?? && product.phoenixProductSubVo.hasProdVideo == 'true']
                                            <!-- <div class="playVideo center">
                                                <svg viewBox="0 0 70 70" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                    <path d="M34.6877 1.21753C53.1716 1.21753 68.1581 16.2012 68.1581 34.6879C68.1581 53.1718 53.1716 68.1584 34.6877 68.1584C16.201 68.1584 1.21729 53.1718 1.21729 34.6879C1.21729 16.2012 16.2009 1.21753 34.6877 1.21753Z" fill="black" fill-opacity="0.4" stroke="white"/>
                                                    <path d="M23.3628 21.6767C23.3628 19.1858 25.1361 18.1475 27.3207 19.3492H27.3178L51.147 32.5004C53.3286 33.7079 53.3257 35.665 51.147 36.8696L27.3207 50.0208C25.1332 51.2254 23.3628 50.1696 23.3628 47.6933V21.6767Z" fill="white"/>
                                                </svg>
                                            </div>
                                            <div class="video_container_box hide">
                                            <div class="innerLink videodetail_task hide">
                                                <video class="video_detail_palying_src_el video-js" style="max-width:100%;display:block;margin:0 auto" controls="" muted autoplay name="media" src=""></video>
                                                </div>
                                                <div class="waiLink videodetail_task hide">
                                                <iframe frameborder="0" class="video-iframe" src="" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true" oallowfullscreen="true" msallowfullscreen="true" allow="autoplay" allowtransparency=""></iframe>
                                                </div>
                                                <div class="closeVideoPayl hide">
                                                <svg t="1717036105846" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3107" width="32" height="32"><path d="M557.312 513.248l265.28-263.904c12.544-12.48 12.608-32.704 0.128-45.248-12.512-12.576-32.704-12.608-45.248-0.128L512.128 467.904l-263.04-263.84c-12.448-12.48-32.704-12.544-45.248-0.064-12.512 12.48-12.544 32.736-0.064 45.28l262.976 263.776L201.6 776.8c-12.544 12.48-12.608 32.704-0.128 45.248a31.937 31.937 0 0 0 22.688 9.44c8.16 0 16.32-3.104 22.56-9.312l265.216-263.808 265.44 266.24c6.24 6.272 14.432 9.408 22.656 9.408a31.94 31.94 0 0 0 22.592-9.344c12.512-12.48 12.544-32.704 0.064-45.248L557.312 513.248z" fill="" p-id="3108"></path></svg>
                                                </div>
                                            </div>     -->
                                        [/#if]
                                        <div class="have3d-">
                                        </div> 
                                    </div>
                                </div>
                                [#--产品名称、简介、自定义字段、--]
                                <div class="blockDetail_container">
                                    <div class="container_left_name">
                                        <h1 class="heading2">${product.prodName}</h1>
                                    </div>
                                    <div class="blockDetail_container_left">
                                        <div class="container_left_brief">
                                            <div class="paragraph1">${product.prodBrief}</div>
                                        </div>
                                        <div class="container_right_field">
                                            [#if product?? && ((product.prodBrand?? && product.prodBrand != '') || (product.prodModel?? && product.prodModel != '') || (product.prodCode?? && product.prodCode != '') || (product.customFieldList?? && product.customFieldList?size > 0) || (product.productPropVo.propTypeList?? && product.productPropVo.propTypeList?size > 0))]
                                                <div class="detial-cont-divsions detial-cont-itemspecifics">
                                                    <ul class="pro-itemspecifics-list">
                                                    [#-- 产品型号 --]
                                                    [#if product.prodModel?? && product.prodModel != '']
                                                    <li class="detial-cont-divsions">
                                                        [#if prodProperty_icon_class?? && prodProperty_icon_class != '']
                                                        <span class="icon ${prodProperty_icon_class!''}"></span>
                                                        [/#if]
                                                        [#if !showProperty?has_content || showProperty==true]
                                                        <label class="commentTotal ${htmlClass1!''}">
                                                            [@s.m "PHENIX2_MODEL" /]：
                                                        </label>
                                                        [/#if]
                                                        <p class="${htmlClass2!''}">
                                                        ${product.prodModel}
                                                        </p>
                                                    </li>
                                                    [/#if]
                                                    [#-- 产品品牌 --]
                                                    [#if product.prodBrand?? && product.prodBrand != '']
                                                    <li class="detial-cont-divsions">
                                                        [#if prodProperty_icon_class?? && prodProperty_icon_class != '']
                                                        <span class="icon ${prodProperty_icon_class!''}"></span>
                                                        [/#if]
                                                        [#if !showProperty?has_content || showProperty==true]
                                                        <label class="commentTotal ${htmlClass1!''}">
                                                            [@s.m "phoenix_product_brand" /]：
                                                        </label>
                                                        [/#if]
                                                        <p class="${htmlClass2!''}">
                                                        ${product.prodBrand!}
                                                        </p>
                                                    </li>
                                                    [/#if]
                                                    [#-- 产品编码 --]
                                                    [#if product.prodCode?? && product.prodCode != '']
                                                    <li class="detial-cont-divsions">
                                                        [#if prodProperty_icon_class?? && prodProperty_icon_class != '']
                                                        <span class="icon ${prodProperty_icon_class!''}"></span>
                                                        [/#if]
                                                        [#if !showProperty?has_content || showProperty==true]
                                                        <label class="commentTotal ${htmlClass1!''}">
                                                            [@s.m "phoenix_product_code" /]：
                                                        </label>
                                                        [/#if]
                                                        <p class="${htmlClass2!''}">
                                                        ${product.prodCode!}
                                                        </p>
                                                    </li>
                                                    [/#if]
                                                    [#-- 产品自定义字段 --]
                                                    [#if product.customFieldList?? && product.customFieldList?size > 0]
                                                    [#list product.customFieldList as customField]
                                                    <li class="detial-cont-divsions">
                                                        [#if prodProperty_icon_class?? && prodProperty_icon_class != '']
                                                        <span class="icon ${prodProperty_icon_class!''}"></span>
                                                        [/#if]
                                                        [#if !showProperty?has_content || showProperty==true]
                                                        <label class="commentTotal ${htmlClass1!''}">
                                                            ${customField.fieldName!}：
                                                        </label>
                                                        [/#if]
                                                        <p class="commentTotal_val ${htmlClass2!''}">
                                                        [#if customField.fieldType == '5']
                                                            [#assign filename = customField.fieldValue?split("/")?last]
                                                            <a href="${customField.fieldValue!}" target="_blank">${filename!''}</a>
                                                        [#elseif customField.fieldType == '4']
                                                            <span class="inlineblock" style="background-color:${customField.fieldValue!''};width: 20px;height: 20px;"></span>
                                                        [#elseif customField.fieldType == '1' || customField.fieldType == '2' || customField.fieldType == '3']
                                                            [#list customField.fieldValue as values]
                                                                ${values!''}&nbsp;
                                                            [/#list]
                                                        [#else]
                                                            ${customField.fieldValue!}
                                                        [/#if]
                                                        </p>
                                                    </li>
                                                    [/#list]
                                                    [/#if]
                                                    [#-- 产品私有属性 --]
                                                    [#if product.productPropVo.propTypeList?? && product.productPropVo.propTypeList?size > 0]
                                                    [#list product.productPropVo.propTypeList as itemPropVo]
                                                    <li class="detial-cont-divsions">
                                                        [#if prodProperty_icon_class?? && prodProperty_icon_class != '']
                                                        <span class="icon ${prodProperty_icon_class!''}"></span>
                                                        [/#if]
                                                        [#if !showProperty?has_content || showProperty==true]
                                                        <label class="commentTotal ${htmlClass1!''}">
                                                            ${itemPropVo.name!}：
                                                        </label>
                                                        [/#if]
                                                        [#if itemPropVo.valueList?? && itemPropVo.valueList?size > 0]
                                                        [#list itemPropVo.valueList as itemPropValue]
                                                        <p class="${htmlClass2!''}">
                                                        ${itemPropValue.name!}
                                                        </p>
                                                        [/#list]
                                                        [/#if]
                                                    </li>
                                                    [/#list]
                                                    [/#if]
                                                    </ul>
                                                </div>
                                                [#else]
                                                [@web_backend]
                                                    [@s.m "jIUpKAANJoLZ_Please_add_product_attributes" /]
                                                [/@web_backend]
                                                [/#if]
                                        </div>
                                    </div>

                                    <!-- sku元素位置 -->
                                    <!--[#if product?? && product.productSkuItem??]
                                    [#if product.productSkuItem.skuOptionItemListStr?? && product.productSkuItem.skuOptionItemListStr != ""]
                                    [#assign skuOptionItemListStrObj=product.productSkuItem.skuOptionItemListStr?eval /]
                                    [#if skuOptionItemListStrObj?? && skuOptionItemListStrObj?size > 0] 
                                    <div class="prod_sku" id="${pageNodeId}_prod_sku">                           
                                    <div class="sku_container">        
                                        [#list skuOptionItemListStrObj as skuOptionItem]
                                        <div class="sku_item">
                                            [#if skuOptionItem.skuName??]
                                                <p class="skuName">
                                                    ${skuOptionItem.skuName!''}
                                                </p>
                                            [/#if]
                                            [#if skuOptionItem.transNameList??]
                                            <div class="specBox">
                                                [#list skuOptionItem.transNameList as transName]
                                                    [#assign _currentThumbnaiImage = (skuOptionItem.thumbnailImageList[transName_index] || skuOptionItem.transImageList[transName_index]) /]
                                                    <div class="specOption">
                                                        <span class="skuTransVal">${transName!''}</span>
                                                    </div>
                                                [/#list]
                                            </div>
                                            [/#if]
                                        </div>
                                        [/#list]
                                    </div> 
                                    </div>                           
                                    [/#if]
                                    [/#if]
                                    [/#if]-->



                                    <div class="blockDetail_container_right">
                                        <div class="container_right_inquiry">
                                            <div class="container_right_inquiry_num">
                                                <div class="prodInquire_btn leadPayBtn prodInquireBtn  prodInquire"  data-prodIds="${product.encodeId!''}" data-nodeId="${nodeId!}" data-skuValueIdStr="${product.skuValueIdStr!}" data-inquire-aaa="11111">
                                                    <div class="prodInquire_btn prodInquire-inner">
                                                        [#if prodInquire_icon_class?? && prodInquire_icon_class != '']
                                                            <span class="icon ${prodInquire_icon_class!''}"></span>
                                                        [/#if]
                                                        <span>[@s.m "phoenix_product_inquire" /]</span>
                                                        <svg t="1766026878647" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="29862" width="14" height="14"><path d="M932.096 448.384a40.384 40.384 0 0 0-39.36 39.424v393.856c0 7.872-5.248 13.12-13.12 13.12H91.904c-7.872 0-13.12-5.248-13.12-13.12V93.952c0-7.872 5.248-13.12 13.12-13.12H485.76a40.384 40.384 0 0 0 39.36-39.424 40.384 40.384 0 0 0-39.36-39.36H91.904C41.984 2.048 0 44.032 0 93.952v787.712c0 49.92 41.984 91.904 91.904 91.904h787.712c49.92 0 91.84-42.048 91.84-91.904V487.808a40.384 40.384 0 0 0-39.36-39.424zM380.8 427.392l-39.424 154.88c-2.56 13.184 0 28.928 10.496 36.8a39.488 39.488 0 0 0 28.928 10.496h10.496l154.88-39.36a42.304 42.304 0 0 0 18.432-10.496l370.176-370.24a123.648 123.648 0 0 0 0-173.312 123.648 123.648 0 0 0-173.312 0L391.232 409.024a42.304 42.304 0 0 0-10.496 18.368z m73.472 28.864L819.2 93.952a44.48 44.48 0 0 1 60.416 0 44.48 44.48 0 0 1 0 60.416L517.248 519.296l-81.408 20.992 18.368-84.032z" fill="#2C2C2C" opacity=".802" p-id="29863"></path></svg>
                                                    </div>
                                                    <form class="prodInquireForm" action="/phoenix/admin/prod/inquire" method="post" novalidate=""> <input type="hidden" name="inquireParams"> </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div thumbsSlider="" class="lead_slick">
                                        <div class="arrows prev">
                                            <i class="icon iconfont_phoenix icon-jiantouzuo-5"></i>
                                        </div>
                                        <div class="lead_slick_thumbs">
                                            [#list product.photoUrlList as photoUrlItem]
                                                <div class="lead_slick_slide">
                                                    <img data-gjs-type="default" src="${photoUrlItem!}" alt="${product.prodName!?html}" title="${product.prodName!?html}" />
                                                </div>
                                            [/#list]
                                        </div>
                                        <div class="arrows next">
                                            <i class="icon iconfont_phoenix icon-jiantouyou-5"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            [#--产品描述--]
                            [#--<div class="blockDetail_desc phoenixProductTextVO">
                                [#assign isDesc0 = 'false' /]
                                [#assign isDesc1 = 'false' /]
                                [#assign isDesc2 = 'false' /]
                                [#assign isDesc3 = 'false' /]
                                [#assign isDesc4 = 'false' /]
                                [#assign prodDesc = product.phoenixProductTextVO /]
                                [#if prodDesc??]
                                    [#if prodDesc.prodDescTitle?? && prodDesc.prodDescTitle != '' && prodDesc.prodDescript?? && prodDesc.prodDescript != '']
                                        [#assign isDesc0 = 'true' /]
                                    [/#if]
                                    [#if prodDesc.prodDescTitle1?? && prodDesc.prodDescTitle1 != '' && prodDesc.prodDescript1?? && prodDesc.prodDescript1 != '']
                                        [#assign isDesc1 = 'true' /]
                                    [/#if]
                                    [#if prodDesc.prodDescTitle2?? && prodDesc.prodDescTitle2 != '' && prodDesc.prodDescript2?? && prodDesc.prodDescript2 != '']
                                        [#assign isDesc2 = 'true' /]
                                    [/#if]
                                    [#if prodDesc.prodDescTitle3?? && prodDesc.prodDescTitle3 != '' && prodDesc.prodDescript3?? && prodDesc.prodDescript3 != '']
                                        [#assign isDesc3 = 'true' /]
                                    [/#if]
                                    [#if prodDesc.prodDescTitle4?? && prodDesc.prodDescTitle4 != '' && prodDesc.prodDescript4?? && prodDesc.prodDescript4 != '']
                                        [#assign isDesc4 = 'true' /]
                                    [/#if]
                                    <div class="detial-cont-divsions detial-cont-prodescription">
                                        <ul class="detial-cont-tabslabel fix">
                                            [#if isDesc0?? && isDesc0 == 'true']
                                                <li class="on">
                                                    <a href="javascript:;">
                                                        ${prodDesc.prodDescTitle}
                                                    </a>
                                                </li>
                                            [/#if]
                                            [#if isDesc1?? && isDesc1 == 'true']
                                                <li>
                                                    <a href="javascript:;">
                                                        ${prodDesc.prodDescTitle1}
                                                    </a>
                                                </li>
                                            [/#if]
                                            [#if isDesc2?? && isDesc2 == 'true']
                                                <li>
                                                    <a href="javascript:;">
                                                        ${prodDesc.prodDescTitle2}
                                                    </a>
                                                </li>
                                            [/#if]
                                            [#if isDesc3?? && isDesc3 == 'true']
                                                <li>
                                                    <a href="javascript:;">
                                                        ${prodDesc.prodDescTitle3}
                                                    </a>
                                                </li>
                                            [/#if]
                                            [#if isDesc4?? && isDesc4 == 'true']
                                                <li>
                                                    <a href="javascript:;">
                                                        ${prodDesc.prodDescTitle4}
                                                    </a>
                                                </li>
                                            [/#if]
                                        </ul>
                                    </div>
                                    <div class="prodDetail-editor-container">
                                        [#if isDesc0?? && isDesc0 == 'true']
                                            <div class="prodDesc">
                                                <div class="sliderTable mt10 mb10 sliderTable-index0">
                                                    <div class="inner">
                                                        [@retry_render]${prodDesc.prodDescript!''}[/@retry_render]
                                                    </div>
                                                </div>
                                            </div>
                                        [/#if]
                                        [#if isDesc1?? && isDesc1 == 'true']
                                            <div class="prodDesc hide">
                                                <div class="sliderTable mt10 mb10 sliderTable-index0">
                                                    <div class="inner">
                                                        [@retry_render]${prodDesc.prodDescript1!''}[/@retry_render]
                                                    </div>
                                                </div>
                                            </div>
                                        [/#if]
                                        [#if isDesc2?? && isDesc2 == 'true']
                                            <div class="prodDesc hide">
                                                <div class="sliderTable mt10 mb10 sliderTable-index0">
                                                    <div class="inner">
                                                        [@retry_render]${prodDesc.prodDescript2!''}[/@retry_render]
                                                    </div>
                                                </div>
                                            </div>
                                        [/#if]
                                        [#if isDesc3?? && isDesc3 == 'true']
                                            <div class="prodDesc hide">
                                                <div class="sliderTable mt10 mb10 sliderTable-index0">
                                                    <div class="inner">
                                                        [@retry_render]${prodDesc.prodDescript3!''}[/@retry_render]
                                                    </div>
                                                </div>
                                            </div>
                                        [/#if]
                                        [#if isDesc4?? && isDesc4 == 'true']
                                            <div class="prodDesc hide">
                                                <div class="sliderTable mt10 mb10 sliderTable-index0">
                                                    <div class="inner">
                                                       [@retry_render]${prodDesc.prodDescript4!''}[/@retry_render]
                                                    </div>
                                                </div>
                                            </div>
                                        [/#if]
                                    </div>
                                [#else]
                                
                                [/#if]
                            </div>--]
                            <span  class="currencySymbolReq hide">[@phoenix_currency paramName="currencySymbol" /]</span>
                            [#--选型弹框--]
                            [#--<div class="selection-wrap">
                                <div class="selection-wrap-step1">
                                    <div class="wrap-step1-top">
                                        <div class="wrap-step1-top-prodName">${product.prodName}</div>
                                        <div class="wrap-step1-top-close">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="23" height="23" viewBox="0 0 23 23" fill="none">
                                                <g clip-path="url(#clip0_120_2985)">
                                                <path d="M5.40074 3.77324L5.45345 3.82164L11.9653 10.334L18.2376 4.0617C18.4127 3.88492 18.6497 3.78316 18.8984 3.77794C19.1472 3.77271 19.3882 3.86444 19.5705 4.03371C19.7529 4.20299 19.8622 4.43655 19.8755 4.685C19.8888 4.93345 19.8049 5.17732 19.6416 5.36504L19.5937 5.41774L13.3204 11.6891L19.5932 17.9614C19.7701 18.1364 19.8721 18.3733 19.8775 18.6221C19.8828 18.871 19.7912 19.1121 19.6219 19.2946C19.4527 19.477 19.2191 19.5865 18.9705 19.5998C18.722 19.6131 18.4781 19.5292 18.2903 19.3658L18.2376 19.3169L11.9653 13.0446L5.45345 19.5575C5.27811 19.7329 5.04162 19.8334 4.79367 19.8381C4.54572 19.8427 4.30562 19.7511 4.12384 19.5824C3.94206 19.4137 3.83275 19.1811 3.81888 18.9335C3.80502 18.6859 3.88768 18.4426 4.04949 18.2546L4.09789 18.2019L10.6102 11.6891L4.09836 5.1772C3.92422 5.00165 3.82466 4.76558 3.82052 4.51834C3.81638 4.27109 3.90796 4.03182 4.07614 3.85053C4.24431 3.66924 4.47604 3.55998 4.7229 3.54557C4.96976 3.53117 5.21263 3.61274 5.40074 3.77324Z" fill="white"/>
                                                </g>
                                                <defs>
                                                <clipPath id="clip0_120_2985">
                                                <rect width="23" height="23" fill="white"/>
                                                </clipPath>
                                                </defs>
                                            </svg>
                                            <span>[@s.m "jIUpKAANJoLZ_Close_Model_Selection" /]</span>
                                        </div>
                                    </div>
                                    <div class="wrap-img-box">
                                        [#if product.photoUrlList?? && product.photoUrlList[0]??]
                                            <div class="swiper-slide">
                                                <img data-gjs-type="default" class="video-cover-image" src="${product.photoUrlList[0]!}" alt="${product.prodName!?html}">
                                                <div class="thumbs-list">
                                                    [#list product.photoUrlList as photoUrlItem]
                                                        <div class="swiper-slide-list">
                                                            <img class="thumbs-img" data-gjs-type="default" src="${photoUrlItem!}" alt="${product.prodName!?html}" title="${product.prodName!?html}" />
                                                        </div>
                                                    [/#list]
                                                </div>
                                            </div>
                                            
                                        [/#if]
                                    </div>
                                    <div class="wrap-option-box">
                                        <div class="option-box-sku universalization">
                                            
                                        </div>
                                        <div class="option-box-sku form" style="display:none;">
                                            
                                        </div>
                                        <div class="option-box-btn">
                                            <div class="option-box-btn-back step1">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18" fill="none">
                                                    <path d="M5.1 7.875H15.75V9.375H5.1L7.425 11.7L6.375 12.75L2.25 8.625L6.375 4.5L7.425 5.55L5.1 7.875Z" fill="#A8A8A8"/>
                                                </svg>
                                                [@s.m "jIUpKAANJoLZ_back" /]
                                            </div>
                                            <div class="option-box-btn-back step2 " style="display:none;">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18" fill="none">
                                                    <path d="M5.1 7.875H15.75V9.375H5.1L7.425 11.7L6.375 12.75L2.25 8.625L6.375 4.5L7.425 5.55L5.1 7.875Z" fill="#A8A8A8"/>
                                                </svg>
                                                [@s.m "jIUpKAANJoLZ_back" /]
                                            </div>
                                            <div class="option-box-btn-Continue">
                                                [@s.m "jIUpKAANJoLZ_Continue" /]
                                            </div>
                                            <div class="option-box-btn-Submit" style="display:none;">
                                                [@s.m "jIUpKAANJoLZ_submit" /]
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="selection-wrap-step2">

                                </div>
                            </div>--]

                            <script type="application/ld+json">
                                ${data.productList.extraData.prodStructureData!""}
                            </script>
                            <script>
                                $(function () {
                                    var templateSaveJson = $("#prodExtraInfo").val()
                                    window._block_namespaces_['block40044'].init({
                                        'encodeId':'${product.encodeId!}',
                                        'relationId': '${relationId}',
                                        'relationType': '${relationType}',
                                        'pageId': '${pageId}',
                                        'pageNodeId': '${pageNodeId!""}',
                                        "autoplay": 0,
                                        "loop": 0,
                                        "autoplaySpeed": 3000,
                                        "slidesPerView": 6,
                                        "spaceBetween": 20,
                                        "waterfallRowSpace": 20,
                                        'nodeId': 'block40044_${nodeId!""}',
                                        'appId': '${appId!}',
                                        'appIsDev': '${appIsDev!"0"}',
                                        'appVersion': '${appVersion}',
                                        'templateSaveJson': templateSaveJson,
                                        'svgtips1': '[@s.m "jIUpKAANJoLZ_CUSTOMIZE_YOUR_PRODUCT" /]',
                                        "skuOptionItemList": '${product.productSkuItem.skuOptionItemListStr!?js_string}',
                                        "skuValueItemList": '${product.productSkuItem.skuValueItemListStr!?js_string}',                                                          
                                        "moutedEl": "#${pageNodeId!''}_prod_sku",                
                                        "htmlClass": "",
                                        "htmlClass1": "",
                                        "specificationName":true,
                                        "specificationVal":true,
                                        "specificationImg":true,
                                        "isSkuRowStr":""
                                    });
                                });
                            </script>
                        [/#list]
                    [/#if]
                    
                [/@api]
            [/@api]
        </div>
	</div>
</div>