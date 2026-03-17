<!-- 风格类名 -->
[#assign templateStyle_40074 = templateStyle_40074!"headlogo_40074" /]
[#assign logo_img_40074 = logo_img_40074!"//a0.leadongcdn.cn/attachment/jljlKBqqknRlkSpnqimilkSR7ww7fgzb73r/logo-tongyongyetou3-emotion.svg" /]
[#assign logo_img_hover_40074 = logo_img_hover_40074!"//g0.leadongcdn.cn/attachment/jrjnKBqqknRlkSpnqimilmSR7ww7fgzb73r/logo-tongyongyetou3-emotion2.svg" /]

<div class="${templateStyle_40074}">
  <div class="Box_img" style="max-width: 200px;">
    <div id="hf_lead_${pageNodeSettingId}_lead-image-wrapper" class="lead-component-wrapper lead-container-wrapper" style="margin: 0px;">
        <div id="hf_lead_${pageNodeSettingId}_lead-image-container1" class="lead-image-container lead-image-container-suspension noSuspension" data-logoHoverType="imagedefault">
			<ld-bg-color id="hf_lead_${pageNodeSettingId}_bgcolor1" data-gjs-type="sectionColor" class="lead-bg-color"></ld-bg-color>
			<picture id="hf_lead_${pageNodeSettingId}_picture" class="lead-picture">
				<source id="hf_lead_${pageNodeSettingId}_source1" srcset="${logo_img_40074}"
					media="(min-width: 992px)" />
				<source id="hf_lead_${pageNodeSettingId}_source2" srcset="${logo_img_40074}"
					media="(min-width: 768px)" />
				<img id="hf_lead_${pageNodeSettingId}_source_img" src="${logo_img_40074}" class="lead-img" style="object-fit: cover;" />
			</picture>
		</div>

		<div id="hf_lead_${pageNodeSettingId}_lead-image-container2" class="lead-image-container lead-image-container-suspension yesSuspension" data-logoHoverType="imageSuspension">
			<ld-bg-color id="hf_lead_${pageNodeSettingId}_bgcolor2" data-gjs-type="sectionColor" class="lead-bg-color"></ld-bg-color>
			<picture id="hf_lead_${pageNodeSettingId}_picture_a_1" class="lead-picture">
				<source id="hf_lead_${pageNodeSettingId}_source_two_a_1" srcset="${logo_img_hover_40074}"
					media="(min-width: 992px)" />
				<source id="hf_lead_${pageNodeSettingId}_source_two_a_2" srcset="${logo_img_hover_40074}"
					media="(min-width: 768px)" />
				<img id="hf_lead_${pageNodeSettingId}_source_imgbg_a_2" src="${logo_img_hover_40074}" class="lead-img" style="object-fit: cover;" />
			</picture>
		</div>
    </div>

  </div>
</div>