<div class="backstage-blocksEditor-wrap wra block_28994" id="block_28994" data-block-uuid="submitComment"  data-gjs-type="developer-node-component" data-setting-type="noSetting" data-block-type="phoenix_blocks_submitComment" data-default-setting={}>
      [#assign verifyData="" /]
	  [#assign canSubmitData="" /]
	  [@api method="get" url="/phoenix2/composite/site/abuseCheck/sms/getVerify"]
		[#assign verifyData=data /]
	  <div class="block-listTemp-container-28994 baozhalo" id="submitComment_${nodeId!''}">
		  [@api method="get" url="/phoenix2/composite/comment/isCanSubmit"]
		  [#assign canSubmitData=data /]
			[#if canSubmitData.canSubmit?? && canSubmitData.canSubmit == '1']
			<a href="javascript:;" class="white_btn can_write_btn">[@s.m "PHENIX2_WRITE_A_REVIEW" /]</a>
			[#elseif canSubmitData.canSubmit?? && canSubmitData.canSubmit != '1']
			<a href="${canSubmitData.loginPageUrl!'javascript:;'}" class="white_btn">[@s.m "PHENIX2_WRITE_A_REVIEW" /]</a>
			[/#if]
		  	[#if canSubmitData.canSubmit?? && canSubmitData.canSubmit == '1']
			<form class="comment_main hide" id="comment_form" method="post" enctype="multipart/form-data">
				<input type="hidden" name="resultPage" >
				<input type="hidden" name="prodId" value="${productId!}">
				<input type="hidden" name="articleId" value="${articleId!}">
				<input type="hidden" name="pageId" value="${pageId!''}">
				<div class="c_item">
					<div class="c_item_label">
					  [@s.m "PHENIX2_SCORE" /]
					</div>
					<div class="c_item_value">
						<ul class="c_v_score">
						<li class="fullStar"><a href="javascript:;">1</a></li>
						<li class="fullStar"><a href="javascript:;">2</a></li>
						<li class="fullStar"><a href="javascript:;">3</a></li>
						<li class="fullStar"><a href="javascript:;">4</a></li>
						<li class="fullStar"><a href="javascript:;">5</a></li>
						</ul>
						<input id="commentStar" name="commentStar" type="hidden" value="5" />
					</div>
				</div>
				<div class="comment_is_require c_item">
					<div class="c_item_label">
						[@s.m "PHENIX2_REVIEW_TITLE" /]
					</div>
					<div class="c_item_value">
						<input type="text" class="c_item_value_text" autocomplete="off" name="commentTitle" placeholder='[@s.m "PHENIX2_GIVE_YOUR_REVIEW_A_TITLE" /]'>
					</div>
					<div class="c_item_error"></div>
				</div>
				<div class="comment_is_require c_item">
					<div class="c_item_label">
						[@s.m "PHENIX2_REVIEW_TEXT" /]
					</div>
					<div class="c_item_value">
						<textarea class="c_item_value_text c_textarea" autocomplete="off" name="commentContent"
						placeholder='[@s.m "PHENIX2_WRITE_YOUR_COMMENTS_HERE" /]'></textarea>
					</div>
					<div class="c_item_error"></div>
				</div>
				<div class="c_item">
					<div class="c_item_label">
						[@s.m "PHENIX2_PICTURE" /]
					</div>
					<div class="c_item_value">
						<input type="file" id="file-uploader" class="hide" multiple accept="image/gif, image/jpeg,image/jpg,image/png" />
						<div class="c_v_upload">
							<div class="u_card u_add_more">
								<svg t="1706863046502" class="icon" viewBox="0 0 1036 1024" version="1.1"
								xmlns="http://www.w3.org/2000/svg" p-id="4550" width="20" height="20">
								<path
									d="M967.460547 546.110294 586.925143 546.110294 586.925143 954.949983C586.925143 993.069187 555.99433 1024 517.875127 1024 479.721363 1024 448.82511 993.069187 448.82511 954.949983L448.82511 546.110294 68.255147 546.110294C30.550658 546.110294 0 515.559636 0 477.855147 0 440.150658 30.550658 409.6 68.255147 409.6L448.82511 409.6 448.82511 69.050017C448.82511 30.930813 479.721363 0 517.875127 0 555.99433 0 586.925143 30.930813 586.925143 69.050017L586.925143 409.6 967.460547 409.6C1005.165035 409.6 1035.750253 440.150658 1035.750253 477.855147 1035.750253 515.559636 1005.165035 546.110294 967.460547 546.110294Z"
									p-id="4551" fill="#333333"></path>
								</svg>
							</div>
						</div>
						<p class="c_upload_tip">[@s.m "PHENIX2_ADD_PHOTOS" /]</p>
					</div>
				</div>
				<div class="comment_faptcha comment_is_require c_item ">
					<div class="c_item_label">
						[@s.m "PHENIX2_VERIFY_CODE" /]
					</div>
					<div class="c_item_value c_verify_code">
						<input id="faptcha_server" type="hidden" value="/phoenix/captcha" data-faptchauuid="" data-faptchatype="faptchaServer">
						<input type="hidden" name="faptcha_challenge_field" id="faptcha_challenge_field" value="${verifyData.attr_theme_faptchaChallengeField!''}" data-faptchauuid="" data-faptchatype="faptchaChallengeField">
						<input type="text" class="c_item_value_text c_verify_input" autocomplete="off" name="faptcha_response_field" placeholder='[@s.m "PHENIX2_VERIFY_CODE" /]'>
						<a class="c_verify_code_reload" onclick="phoenixSite.faptcha.reload(&quot;submitComment_${nodeId!''}&quot;);" href="javascript:;">
							<img class="c_verify_code_img" id="faptcha_image_img" src="/phoenix/captcha?action=image&c=${verifyData.attr_theme_faptchaChallengeField!''}" alt="Verify Code">
						</a>
					</div>
					<div class="c_item_error"></div>
				</div>
				<button class="c_form_sub">
					<p class="c_sub_txt">[@s.m "PHENIX2_POST" /]</p>
					<div class="c_sub_loading"></div>
				</button>
			</form>
			[/#if]
			
		[/@api]
      </div>
    <script>
          $(function(){
              window._block_namespaces_['submitComment_28994'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'submitComment_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
          });
      </script>

[/@api]
</div>