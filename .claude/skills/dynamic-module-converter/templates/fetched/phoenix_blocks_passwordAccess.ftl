<div class="backstage-blocksEditor-wrap wra block_77462" data-block-uuid="passwordAccess"  data-gjs-type="developer-node-component" data-setting-type="noSetting" data-block-type="phoenix_blocks_passwordAccess" data-default-setting={}>
    <div>
        <form id="editForm" action="/phoenix/admin/pageauth" method="post" novalidate target="coreIframe">
            <div class="psdp-input">
                <div class="pspd-input-wrap">
                     <input type="hidden" name="pageId" value="${referPageId!?html}"/>
                     <input type="hidden" name="redirectUrl" value="${redirectUrl!?html}">
                    <div class="pwd-box">
                        <input class="psdp-pwd" type="password" name="accessPassword" id="accessPassword" placeholder="" autocomplete="off"/>
                        <span id="submit-pwd" class="psdp-btn" type="text"> [@s.m "PHENIX2_OK" /]</span>
                    </div>
                </div>
                <span class="padp-hint" id="notice_accessPassword" style="display:none">[@s.m "PHENIX2_ENTER_PASSWORD_PLEASE" /]</span>
               
            </div>
        </form>
        <script>
            $(function(){
                window._block_namespaces_['passwordAccess_77462'].init({'relationId':'${relationId}','relationType':'${relationType}','pageId':'${pageId}','nodeId':'passwordAccess_${nodeId!""}', 'appId': '${appId!}', 'appIsDev': '${appIsDev!"0"}','appVersion':'${appVersion}'});
            });
        </script>
        <div class="coreIframe"><iframe id="coreIframe" name="coreIframe" src="about:blank" style="display: none"></iframe></div>
	</div>
    
</div>