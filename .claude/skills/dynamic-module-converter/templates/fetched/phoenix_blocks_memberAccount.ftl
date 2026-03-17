<div class="backstage-blocksEditor-wrap wra block_29014" id="block_29014" data-block-uuid="memberAccount"
	data-gjs-type="developer-node-component" data-block-type="phoenix_blocks_memberAccount"
	data-default-setting={"dataType":"0","dataLogin":"-1","dataEmail":"1","dataPrivacy":"1","dataCode":"1","expandIds":{"showField":{"label":"字段","labelExpand":"必填","key":"showField","draggable":false,"data":[{"fieldName":"邀请码","fieldId":"invitationCode","fieldType":"0","value":"1","checked":true,"required":"1"},{"fieldName":"性别","fieldId":"sexFlag","fieldType":"0","value":"2","checked":true,"required":"1"},{"fieldName":"出生日期","fieldId":"btdFlag","fieldType":"0","value":"3","checked":true,"required":"1"},{"fieldName":"网站","fieldId":"webUrlFlag","fieldType":"0","value":"4","checked":true,"required":"1"},{"fieldName":"公司名称","fieldId":"companyFlag","fieldType":"0","value":"5","checked":true,"required":"1"},{"fieldName":"国家/地区","fieldId":"countryAreaFlag","fieldType":"0","value":"6","checked":true,"required":"1"},{"fieldName":"电话","fieldId":"telFlag","fieldType":"0","value":"7","checked":true,"required":"1"},{"fieldName":"传真","fieldId":"faxFlag","fieldType":"0","value":"8","checked":true,"required":"1"},{"fieldName":"地址","fieldId":"addressFlag","fieldType":"0","value":"9","checked":true,"required":"1"}]}},"expandSort":["showField"],"dataRegister":"-1","dataModify":"-1","translationEntry":[]}>
	[@api method="get" url="/phoenix2/composite/site/abuseCheck/sms/getVerify"]
	[#assign hasEncodeUid=false /]
	[#if !((encodeUid?? && (encodeUid == 'null' || encodeUid == '')) || !encodeUid??)]
		[#assign hasEncodeUid=true /]
	[/#if]
	<div class="block-listTemp-container-29014">
		[#--
		${dataType!''} 0登录，1注册，2忘记密码，3修改密码
		${dataLogin!''} 登录跳转页面，例：默认跳转页 "-1",指定跳转页 "agUAfKpRQEra"
		${dataEmail!''} 邮箱验证 0关闭，1开启
		${dataPrivacy!''} 隐私策略 0关闭，1开启
		${dataCode!''} 验证码 0关闭，1开启
		${expandIds!''} 展示字段
		${dataRegister!''} 注册跳转页面，例：默认跳转页 "-1",指定跳转页 "agUAfKpRQEra"
		${dataModify!''} 修改密码跳转页面，例：默认跳转页 "-1",指定跳转页 "agUAfKpRQEra"
		--]
		 <input type="hidden" id="msg1" value='[@s.m "PHENIX2_PASSWORD_REQUIREMENTS_AGAIN" /]'>
		 <input type="hidden" id="msg2" value='[@s.m "PHENIX2_ENTER_EMAIL_PLEASE" /]'>
		 <input type="hidden" id="msg3" value='[@s.m "PHENIX2_ENTER_PASSWORD_PLEASE" /]'>
		 <input type="hidden" id="msg4" value='[@s.m "PHENIX2_EMAIL_FORMAT" /]'>
		 <input type="hidden" id="msg5" value='[@s.m "PHENIX2_PASSWORD_MISMATCH" /]'>
		 <input type="hidden" id="msg6" value='[@s.m "PHENIX2_ENTER_CAPTCHA" /]'>
		 <input type="hidden" id="msg7" value='[@s.m "PHENIX2_CAPTCHA_LENGTH" /]'>
		 <input type="hidden" id="msg8" value='[@s.m "PHENIX2_CAPTCHA_ERROR" /]'>
		 <input type="hidden" id="msg9" value='[@s.m "PHENIX2_EMAIL_ALREADY_ASSOCIATED" /]'>
		 <input type="hidden" id="msg10" value='[@s.m "PHENIX2_ACCOUNT_EXISTS" /]'>
		 <input type="hidden" id="msg11" value='[@s.m "PHENIX2_EMAIL_NOT_EXIST" /]'>
		<div class="type_main login_main [#if hasEncodeUid || (!hasEncodeUid && dataType?? && dataType != 0)]hide[/#if]" id="login_form_${nodeId!''}" data-type="signin">
			<div class="type_title">
				 [@s.m "PHENIX2_SIGN_IN" /]
			</div>
			<form class="comment_main" id="login_form" action="javascript:void(0)">
				<input type="hidden" name="redirectUrl">
				<input type="hidden" name="redirectPageId" value="${dataLogin!''}">
				<input type="hidden" name="orgCode" value="${data.orgCode!''}">
				<div class="c_item">
					<div class="c_item_label">
						<span class="r_icon">*</span>
						<span>[@s.m "PHENIX2_ACCOUNT" /]</span>
					</div>
					<div class="c_item_value">
						<input type="text" class="c_item_value_text" name="loginName" autocomplete="off" placeholder='[@s.m "PHENIX2_ENTER_EMAIL_PLEASE" /]'>
			</div>
						<div class="c_item_error">
							[@s.m "PHENIX2_INVALID_EMAIL_ADDRESS" /]
						</div>
					</div>
					<div class="c_item" id="login_pw">
						<div class="c_item_label">
							<span class="r_icon">*</span>
							<span>[@s.m "PHENIX2_PASSWORD" /]</span>
						</div>
						<div class="c_item_value">
							<input type="password" class="c_item_value_text" name="password" placeholder='[@s.m "PHENIX2_ENTER_PASSWORD_PLEASE" /]' autocomplete="off">
			</div>
							<div class="c_item_error">
								[@s.m "PHENIX2_PASSWORD_ERROR" /]
							</div>
						</div>
						<div class="c_item hide" id="is_login_code">
							<div class="c_item_label">
								<span class="r_icon">*</span>
								<span>[@s.m "PHENIX2_VERIFY_CODE" /]</span> 
							</div>
							<div class="c_item_value c_verify_code">
								<input id="faptcha_server" type="hidden" value="/phoenix/captcha" data-faptchauuid=""
				data-faptchatype="faptchaServer">
								<input type="hidden" name="faptcha_challenge_field" id="faptcha_challenge_field"
				value="${data.attr_theme_faptchaChallengeField!''}" data-faptchauuid="" data-faptchatype="faptchaChallengeField">
								<input type="text" class="c_item_value_text c_verify_input" name="faptcha_response_field" placeholder='[@s.m "PHENIX2_VERIFY_CODE" /]' autocomplete="off">
								<a class="c_verify_code_reload" onclick="phoenixSite.faptcha.reload('login_form_${nodeId!''}');" href="javascript:;">
									<img class="c_verify_code_img" id="faptcha_image_img" src="/phoenix/captcha?action=image&c=${data.attr_theme_faptchaChallengeField!''}" alt="Verify Code">
				</a>
							</div>
							<div class="c_item_error">
								[@s.m "PHENIX2_INVALID_EMAIL_ADDRESS" /]
							</div>
						</div>
						<button class="c_form_sub">
			<p class="c_sub_txt">[@s.m "PHENIX2_SIGN_IN" /]</p>
			<div class="c_sub_loading"></div>
			</button>
			</form>
			<div class="type_footer">
				<span>
			[@s.m "PHENIX2_DONT_HAVE_ACCOUNT" /] 
			<a class="type_f_link link_to_register" href="javascript:;">[@s.m "PHENIX2_SIGN_UP" /]</a>
			<a class="type_f_link link_to_forgot" href="javascript:;">[@s.m "PHENIX2_FORGOT_PASSWORD" /]</a>
			</span>
			</div>
		</div>
		<div class="type_main register_main [#if hasEncodeUid || (!hasEncodeUid && dataType?? && dataType != 1)]hide[/#if]" id="register_form_${nodeId!''}" data-type="register">
			<div class="type_title">
				[@s.m "PHENIX2_CREATE_ACCOUNT" /]
			</div>
			<form class="comment_main" id="register_form" action="javascript:void(0)">
				<input type="hidden" name="redirectPageId" value="${dataRegister!''}">
				<input type="hidden" name="emailTestFlag" value="${dataEmail!''}">
				<input type="hidden" name="verifyFlag" value="${dataEmail!''}">
				<input type="hidden" name="registStyle" value="email">
				<input type="hidden" name="refererHold" value="">
				<input type="hidden" name="country">
				<div class="c_item c_is_default c_item_is_require">
					<div class="c_item_label">
						<span class="r_icon">*</span>
						<span>[@s.m "PHENIX2_EMAIL" /]</span>
					</div>
					<div class="c_item_value">
						<input type="text" class="c_item_value_text" name="email" placeholder='[@s.m "PHENIX2_ENTER_EMAIL" /]' autocomplete="off">
			</div>
						<div class="c_item_error">
							[@s.m "PHENIX2_INVALID_EMAIL_ADDRESS" /]
						</div>
					</div>
					<div class="c_item c_is_default c_item_is_require">
						<div class="c_item_label">
							<span class="r_icon">*</span>
							<span>[@s.m "PHENIX2_PASSWORD" /]</span>
						</div>
						<div class="c_item_value">
							<input type="password" class="c_item_value_text" name="password" placeholder='[@s.m "PHENIX2_ENTER_PASSWORD" /]' autocomplete="off">
			</div>
							<div class="c_item_error">
								[@s.m "PHENIX2_PASSWORD_REQUIREMENTS" /]
							</div>
						</div>
						<div class="c_item c_is_default c_item_is_require">
							<div class="c_item_label">
								<span class="r_icon">*</span>
								<span>[@s.m "PHENIX2_CONFIRM_PASSWORD" /]</span>
							</div>
							<div class="c_item_value">
								<input type="password" class="c_item_value_text" name="confirmPassword" placeholder='[@s.m "PHENIX2_ENTER_PASSWORD" /]' autocomplete="off">
			</div>
								<div class="c_item_error">
									[@s.m "PHENIX2_PASSWORD_INCONSISTENT" /].
								</div>
							</div>
							[#if expandIds?? && expandIds != ""]
							[#assign expandIdsJSON=expandIds?eval /]
							[#if expandIdsJSON?? && expandIdsJSON.showField?? && expandIdsJSON.showField.data??]
							[#list expandIdsJSON.showField.data as showField]
							[#if showField.checked == true]
							<div class="c_item [#if showField.required?? && showField.required == '1']c_item_is_require[/#if]"
								data-name="${showField.fieldId}" data-fieldType="${showField.fieldType}" data-error-txt="Not Empty">
								<div class="c_item_label">
									<span class="r_icon">*</span>
									<span>${showField.fieldName}</span>
								</div>
								<div class="c_item_value">
									[#if showField.fieldType == '0'] [#-- 默认字段 --]
									[#if showField.fieldId == 'btdFlag']
									<input type="text" readonly class="c_item_value_text textBox flexDate" format="yyyy-MM-dd" name="${showField.fieldId}" autocomplete="off">
						[#elseif showField.fieldId == 'countryAreaFlag']
											<select id="new_userCountry" class="c_item_value_text" name="${showField.fieldId}">
												<option disabled selected value="nochoose">[@s.m "PHENIX2_SELECT_COUNTRY_OR_REGION" /]</option>
											</select>
									[#elseif showField.fieldId == 'sexFlag']
									<div class="c_radio">
													<label for="is_male">
											<input type="radio" name="${showField.fieldId}" id="is_male" value="male" checked>
											<span>[@s.m "PHENIX2_MALE" /]</span>
										</label>
													<label for="is_female">
											<input type="radio" name="${showField.fieldId}" id="is_female" value="female" >
											<span>[@s.m "PHENIX2_FEMALE" /]</span>
										</label>
													<label for="is_confidential">
											<input type="radio" name="${showField.fieldId}" id="is_confidential" value="confidential" >
											<span>[@s.m "PHENIX2_CONFIDENTIAL" /]</span>
										</label>
												</div>
												[#else]
												<input type="text" class="c_item_value_text" name="${showField.fieldId}" autocomplete="off">
												[/#if]
									[#elseif  showField.fieldType == '1'] [#-- 自定义字段 文本 --]
												<input type="text" class="c_item_value_text" name="${showField.fieldId}" autocomplete="off">
									[#elseif  showField.fieldType == '2'] [#-- 自定义字段 下拉 --]
												<select class="c_item_value_text" name="${showField.fieldId}">
													[#list showField.fieldValueList as cusFieldItem]
														<option value="${cusFieldItem.value}">${cusFieldItem.value}</option>
													[/#list]
												</select>
									[/#if]
								</div>
								<div class="c_item_error"></div>
							</div>
							[/#if]
							[/#list]
							[/#if]
							[/#if]
							[#if dataCode?? && dataCode == '1']
							<div class="c_item c_item_is_require" data-name='verifyCode'>
								<div class="c_item_label">
									<span class="r_icon">*</span>
									<span>[@s.m "PHENIX2_VERIFY_CODE" /]</span>
								</div>
								<div class="c_item_value c_verify_code">
									<input id="faptcha_server" type="hidden" value="/phoenix/captcha" data-faptchauuid=""
				data-faptchatype="faptchaServer">
									<input type="hidden" name="faptcha_challenge_field" id="faptcha_challenge_field"
				value="${data.attr_theme_faptchaChallengeField!''}" data-faptchauuid="" data-faptchatype="faptchaChallengeField">
									<input type="text" class="c_item_value_text c_verify_input" name="faptcha_response_field" placeholder='[@s.m "PHENIX2_VERIFY_CODE" /]' autocomplete="off">
									<a class="c_verify_code_reload" onclick="phoenixSite.faptcha.reload('register_form_${nodeId!''}');" href="javascript:;">
										<img class="c_verify_code_img" id="faptcha_image_img" src='/phoenix/captcha?action=image&c=${data.attr_theme_faptchaChallengeField!""}' alt="Verify Code">
									</a>
								</div>
								<div class="c_item_error">
									[@s.m "PHENIX2_VERIFY_CODE" /]
								</div>
								
							</div>
							[/#if]
							[#if dataPrivacy?? && dataPrivacy == '1']
							<div class="c_item c_privacy_policy">
								[@s.m "PHENIX2_SUBMIT_AGREE" /]
							</div>
							[/#if]
							<button class="c_form_sub">
			<p class="c_sub_txt">[@s.m "PHENIX2_CREATE_ACCOUNT" /]</p>
			<div class="c_sub_loading"></div>
			</button>
			</form>
			<div class="type_footer">
				<span>
			[@s.m "PHENIX2_HAVE_ACCOUNT" /] <a class="type_f_link link_to_login" href="javascript:;">[@s.m "PHENIX2_SIGN_IN" /]</a>
			</span>
			</div>
		</div>
		<div class="type_main forgot_pw_main [#if hasEncodeUid || (!hasEncodeUid && dataType?? && dataType != 2)]hide[/#if]" id="fpw_form_${nodeId!''}" data-type="forgotpw">
			<div class="type_title">
				[@s.m "PHENIX2_FORGOT_PASSWORD" /]
			</div>
			<form class="comment_main" id="fpw_form" action="javascript:void(0)">
				<input type="hidden" name="respMsgType" value="1">
				<div class="c_item">
					<div class="c_item_label">
						<span class="r_icon">*</span>
						<span>[@s.m "PHENIX2_EMAIL" /] </span>
					</div>
					<div class="c_item_value">
						<input type="text" class="c_item_value_text" name="account" placeholder='[@s.m "PHENIX2_ENTER_EMAIL" /]' autocomplete="off">
			</div>
						<div class="c_item_error"></div>
					</div>
					<div class="c_item">
						<div class="c_item_label">
							<span class="r_icon">*</span>
							<span>[@s.m "PHENIX2_VERIFY_CODE" /]</span>
						</div>
						<div class="c_item_value c_verify_code">
							<input id="faptcha_server" type="hidden" value="/phoenix/captcha" data-faptchauuid=""
				data-faptchatype="faptchaServer">
							<input type="hidden" name="faptcha_challenge_field" id="faptcha_challenge_field"
				value="${data.attr_theme_faptchaChallengeField!''}" data-faptchauuid="" data-faptchatype="faptchaChallengeField">
							<input type="text" class="c_item_value_text c_verify_input" name="faptcha_response_field" placeholder='[@s.m "PHENIX2_VERIFY_CODE" /]' autocomplete="off">
							<a class="c_verify_code_reload" onclick="phoenixSite.faptcha.reload('fpw_form_${nodeId!''}');" href="javascript:;">
								<img class="c_verify_code_img" id="faptcha_image_img" src="/phoenix/captcha?action=image&c=${data.attr_theme_faptchaChallengeField!''}" alt="Verify Code">
							</a>
						</div>
						<div class="c_item_error"></div>
					</div>
					<button class="c_form_sub">
			<p class="c_sub_txt">[@s.m "PHENIX2_SEND_RESET_INSTRUCTIONS" /]</p>
			<div class="c_sub_loading"></div>
			</button>
			</form>
			<div class="type_footer">
				<a class="type_f_link link_to_login" href="javascript:;">[@s.m "PHENIX2_GO_BACK_TO_SIGN_IN" /]</a>
			</div>
		</div>
		<div class="type_main change_pw_main [#if !hasEncodeUid && (dataType?? && dataType != 3)]hide[/#if]" id="cpw_form_${nodeId!''}" data-type="changepw">
			<div class="type_title">
				[@s.m "PHENIX2_CHANGE_PASSWORD" /]
			</div>
			<form class="comment_main" id="cpw_form" action="javascript:void(0)">
				<input type="hidden" name="redirectPageId" value="${dataModify!''}">
				<input type="hidden" name="respMsgType" value="1">
				<input type="hidden" name="uid" value="${encodeUid!''}" />
				<input type="hidden" name="t" value="${token!''}" />
				<div class="c_item">
					<div class="c_item_label">
						<span class="r_icon">*</span>
						<span>[@s.m "PHENIX2_NEW_PASSWORD" /]</span>
					</div>
					<div class="c_item_value">
						<input type="password" class="c_item_value_text" name="password" autocomplete="off" placeholder='[@s.m "PHENIX2_ENTER_NEW_PASSWORD" /]'>
			</div>
						<div class="c_item_error"></div>
					</div>
					<div class="c_item">
						<div class="c_item_label">
							<span class="r_icon">*</span>
							<span>[@s.m "PHENIX2_CONFIRM_PASSWORD" /]</span>
						</div>
						<div class="c_item_value">
							<input type="password" class="c_item_value_text" name="confirmPassword" autocomplete="off" placeholder='[@s.m "PHENIX2_ENTER_PASSWORD" /]'>
			</div>
							<div class="c_item_error"></div>
						</div>
						<button class="c_form_sub">
			<p class="c_sub_txt">[@s.m "PHENIX2_CONFIRM" /]</p>
			<div class="c_sub_loading"></div>
			</button>
			</form>
			<div class="type_footer">
				<a class="type_f_link link_to_login" href="javascript:;">[@s.m "PHENIX2_GO_BACK_TO_SIGN_IN" /]</a>
			</div>
		</div>
		<div class="type_main type_success new_register_success hide">
			<div class="new_r_title">[@s.m "PHENIX2_ACCOUNT_ACTIVATION" /]</div>
			<div class="new_r_icon ">
			
				<i class="iconfont iconfont_phoenix icon-icon-youjian"></i>
			</div>
			<div class="new_r_tip ">[@s.m "PHENIX2_ACTIVATION_EMAIL_SENT" /] </div>
			<div class="new_r_footer">
				<span>[@s.m "PHENIX2_ALREADY_A_MEMBER" /]</span><a class="type_f_link link_to_login" href="javascript:;">[@s.m "PHENIX2_SIGN_IN_HERE" /]</a>
			</div>
		</div>
		<div class="type_main type_success new_forgotpw_success hide">
			<div class="new_r_title">[@s.m "PHENIX2_ACCOUNT_ACTIVATION" /]</div>
			<div class="new_r_icon ">

				<i class="iconfont iconfont_phoenix icon-icon-youjian"></i>
			</div>
			<div class="new_r_tip "></div>
			<div class="new_r_footer">
				<span>[@s.m "PHENIX2_ALREADY_A_MEMBER" /]</span><a class="type_f_link link_to_login" href="javascript:;">[@s.m "PHENIX2_SIGN_IN_HERE" /]</a>
			</div>
		</div>
	</div>
		[@web_javascript collect="true" pm_script="${settingId!}" jumpTo="${settingId!}"]
		$(function () {
			$('head').append('<link href="[@web_common_url type='1' urlAppend='/static/assets/widget/script/plugins/select2/select2.css' /]" rel="stylesheet" />')
			$.getScript("[@web_common_url type='1' urlAppend='/static/assets/widget/script/plugins/select2/select2.js' /]", function () {
				$.getScript("[@web_common_url type='1' urlAppend='/static/assets/script/plugins/cryptojs/crypto-js.js' /]", function() {
					var params = { 'relationId': '${relationId}', 'relationType': '${relationType}', 'pageId': '${pageId}', 'nodeId': 'memberAccount_${nodeId!""}', 'oldNodeId': '${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}', 'appVersion': '${appVersion}','_tripleDesKey_':"${data._tripleDesKey_!''}",'_tripleDesIv_':"${data._tripleDesIv_!''}" }
					params.i18l = {
						more: '[@s.m "phoenix_read_more_2" /]'
					}
					window._block_namespaces_['memberAccount_29014'].init(params);
				})
			});
		});
      [/@web_javascript]
	  [/@api]
</div>