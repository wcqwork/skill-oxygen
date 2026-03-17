<div class="backstage-blocksEditor-wrap wra block_28864 " data-block-uuid="galleryDetail"  data-gjs-type="developer-node-component"  data-block-type="phoenix_blocks_galleryDetail" data-default-setting={}>
  <div id="galleryDetail_28864_app_${nodeId!''}" class="galleryDetail_28864_app hide" :style="{'height':bodyHeight+'px'}">
    [#assign galleryIdByPage = '0']
    [#if galleryId?? && galleryId != ""]
        [#assign galleryIdByPage = galleryId]
    [#else]
        [#assign galleryIdByPage = '0']
    [/#if]
      [@api method="post" version="v2" url="/phoenix2/composite/graphql" page="${page!'1'}" limit="${pageSize!'1'}"
      selectGalleryType="${dataType!'0'}" selectGalleryIds="${dataIds!''}" galleryIdByPage="${galleryIdByPage!'0'}" 
        query='{
          galleryList(
              conditionDto:{
                page: $page$,
                limit: $limit$,
                selectGalleryType: "$selectGalleryType$",
                selectGalleryIds: "$selectGalleryIds$",
                galleryIdByPage: "$galleryIdByPage$"
            }
            ){
                  totalRow   
                  pageSize   
                  pageNumber 
                  list {
                    encodeId	
                    galleryName		
                    galleryStatus	
                    galleryUrl	
                    galleryDesc	
                    galleryUpdateTime	
                    galleryCate{
                        encodeId 
                        cateName
                    }
                    galleryCover
                    galleryPhotos
                  }
              }
}']
      <div class="inner_container_bg"></div>
      <div v-show="zoomNum != 1 || isMobile" v-on:click="jumpTo('prev')" class="g_svg_icon svg_light full_icon full_to_prev">
        <i class="iconfont iconfont_phoenix icon-jiantouzuo-5" style="color:#A9A29A;font-size:22px;"></i>
      </div>
      <div v-show="zoomNum != 1 || isMobile" v-on:click="jumpTo('next')" class="g_svg_icon svg_light full_icon full_to_next">
        <i class="iconfont iconfont_phoenix icon-jiantouyou-5" style="color:#A9A29A;font-size:22px;"></i>
      </div>
      <div v-show="zoomNum != 1 || isMobile" v-on:click="jumpTo('inputV', 1)" class="g_svg_icon svg_light diyiye full_icon full_to_start" :style="{'bottom': isMobile? '0px': '60px'}"><i class="iconfont iconfont_phoenix icon-icon-xiangzuo2" style="font-size:20px;color:#A9A29A;"></i></div>
      <div v-show="zoomNum != 1 || isMobile" v-on:click="jumpTo('inputV', vPageTotal)" class="g_svg_icon svg_light zuihouyiye full_icon full_to_end" :style="{'bottom': isMobile? '0px': '60px'}"><i class="iconfont iconfont_phoenix icon-icon-xiangyou2" style="font-size:20px;color:#A9A29A;"></i></div>
      <div class="block-listTemp-container-replace inner_container">
        <div class="gallery_main">
          <div class="topToolBar">
            <input class="g_page_num" v-model="inputV"/>
            <div class="g_svg_icon g_rotate">
              <i class="iconfont iconfont_phoenix icon-jian-2" style="font-size:16px;"></i>
            </div>
            <div style="height: 40px;line-height: 44px;">{{vPageTotal}} 页</div>
            <div class="g_svg_icon" style="margin-left:12px;" v-on:click="jumpTo('inputV')">
              <i class="iconfont iconfont_phoenix icon-icon-jiantouyou" style="font-size:22px"></i>
            </div>
          </div>
            <div class=" flipbook block-listTemp-container block-listTemp-container-28864" id="container-28864">
              <div v-show="!isFirstPage && zoomNum == 1 && !isMobile" ignore='1' v-on:click="jumpTo('prev')" class="g_svg_icon svg_light to_prev"><i class="iconfont iconfont_phoenix icon-jiantouzuo-5"></i></div>
              <div v-show="!isLastPage && zoomNum == 1 && !isMobile" ignore='1' v-on:click="jumpTo('next')" class="g_svg_icon svg_light to_next"><i class="iconfont iconfont_phoenix icon-jiantouyou-5"></i></div>
              <div v-show="!isFirstPage && zoomNum == 1 && !isMobile" ignore='1' class="g_svg_icon svg_light diyiye to_start" v-on:click="jumpTo('inputV', 1)"><i class="iconfont iconfont_phoenix icon-icon-xiangzuo2" style="font-size:16px"></i> </div>
              <div v-show="!isLastPage && zoomNum == 1 && !isMobile" ignore='1' class="g_svg_icon svg_light zuihouyiye to_end" v-on:click="jumpTo('inputV', vPageTotal)"><i class="iconfont iconfont_phoenix icon-icon-xiangyou2" style="font-size:16px"></i></div>
              [#if data?? && data.galleryList?? && data.galleryList.list?? ]
              [#list data.galleryList.list as dataItem]
                [#if dataItem_index == 0 && dataItem.galleryPhotos??]
                  [#list dataItem.galleryPhotos as galleryPhoto]
                      [#if galleryPhoto_index == 0]
                        <div ignore='1' class='first_img hide' data-first-src="${galleryPhoto!?html}"></div>
                      [/#if]
                      <div class="flipbook-item-bgm" data-thumb="${galleryPhoto!?html}"></div>
                  [/#list]
                [/#if]
              [/#list]
              [/#if]
            </div>
            <div class="bottomToolBar" v-show="!isMobile">
              <div class="g_svg_icon quanping" v-on:click="fullPageFunc('big')"><i class="iconfont iconfont_phoenix icon-icon-zuida"></i></div>
              <div class="g_svg_icon quxiaoquanping" v-on:click="fullPageFunc('small')"><i class="iconfont iconfont_phoenix icon-icon-zuixiao"></i></div>
              <div class="g_svg_icon fangda" v-on:click="zoomFunc('up')"><i class="iconfont iconfont_phoenix icon-fangda1"></i></div>
              <div class="g_svg_icon suoxiao" v-on:click="zoomFunc('down')"><i class="iconfont iconfont_phoenix icon-suoxiao1"></i></div>
              <div class="g_svg_icon xiazai hide"><i class="iconfont iconfont_phoenix icon-icon-dwn"></i></div>
              <div class="g_svg_icon dayin hide"><i class="iconfont iconfont_phoenix icon-icon-dayin"></i></div>
            </div>
        </div>
        
      </div>
      
      
		[@web_javascript collect="true" pm_script="${settingId!}" jumpTo="${settingId!}"]
$(function(){
		$.getScript("[@web_common_url type='1' urlAppend='/static/assets/script/vue.js' /]", function ()
		{
		window._block_namespaces_['galleryDetail_28864'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'galleryDetail_${nodeId!""}','vNodeId':'${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
		})
		});
      [/@web_javascript]
		
[/@api]
</div>
</div>