<div id="${pageNodeId}" class="backstage-blocksEditor-wrap wra block_28672 crumb_position" data-block-uuid="aaa" data-dynamic-type="position"  data-gjs-type="developer-element-component"  data-block-type="position" data-default-setting={"prefixIcon":"","Separator":"icon-jiantouyou-5","textClass":"paragraph1"}>
    [@api method="post" url="/phoenix2/composite/graphql" pageId="${pageId!''}" extraParamJson="${extraParamJson!''}"
			query=' {
            positionList(positionConditionDto: {pageId: "$pageId", extraParamJson: $extraParamJson}) {
                positionList {
                        positionName
                        positionUrl
                        positionMark
                    }
                }
            }' 
            ]
            <div class="position-container" data-gjs-type="position">
                [#if data?? && data.positionList?? && data.positionList.positionList??]
                    [#if data.positionList.positionList?size > 0]
                        <span class="position-first">
                    [/#if]
                    <i class=" [#if prefixIcon && prefixIcon !=''] prefixc-icon [/#if] iconfont_phoenix ${prefixIcon}" data-gjs-type="leadIcon"></i>
                    [#list data.positionList.positionList as position]
                        [#if position_index + 1 < data.positionList.positionList?size ]
                            <a class="position-link" href="${position.positionUrl}">
                                <span class="lead-text lead-button-text ${textClass!'paragraph1'}">${position.positionName!''}</span>
                            </a>
                            [#if position_index == 0 ]
                                </span>
                            [/#if]
                            <i class="separator-icon iconfont_phoenix ${Separator}" data-gjs-type="separatorIcon"></i>
                            
                        [/#if]

                        [#if position_index + 1 == data.positionList.positionList?size ]
                            <span class="position-link">
                                <span class="lead-text lead-button-text ${textClass!'paragraph1'}">${position.positionName!''}</span>
                            </span>
                        [/#if]
                    [/#list]
                [/#if]
            </div>
	[/@api]
        
</div>