<div id="section_cen" style="" class="ui-layout-center">
    <%if( consent && Common.isEquals(firstAdminYn, "N") && Common.isNotEquals(adminType, "C")){ %>
    <div style="position: absolute;z-index: 1;padding-top: 1px;padding-left: 5px;">
        <button class="search_btn" style="width:150px;" accesskey="O" id="consentBtn" onclick="searchConsentNo();"><span class="glyphicon glyphicon-tags"></span>&nbsp;<s:message code="consent.select.consent"/></button>
        <button class="reset_btn" accesskey="X" id="resetConsentBtn" onclick="resetConsentNo();">X</button>
        <input type="text" style="width:120px;height:28px;display:none;" readonly="readonly" id="consentNo">
        <input type="hidden" readonly="readonly" id="consentIp">
        <input type="hidden" readonly="readonly" id="consentEmail">
        <input type="hidden" readonly="readonly" id="consentUserId">
        <span id="consentName" style="font-weight: bold;"></span>
        <input type="hidden" readonly="readonly" id="consentShortName">
    </div>
    <%} %>
    <div class="viewSetup" style="position: absolute;top:40px;right:10px;z-index: 9;">
        <div style="display: inline-block; padding-left:10px;vertical-align: bottom;">
            <a href="javascript:;" style="padding-right:10px; color:#383838; cursor: pointer; font-size: 12px;float: right;"data-toggle="dropdown" id="exportMsg"><s:message code="common.msg.export"/></a>
            <ul class="dropdown-menu dropdown-menu-left" role="menu" style="min-width:100px;font-size:13px;">
                <li style="display:none;"><a href="javascript:void(0);" id="body_link_btn" class="body_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-text-o" style="font-size:16px"></span>&nbsp;<s:message code="condition.body"/></a></li>
                <li style="display:none;"><a href="javascript:void(0);" id="attach_link_btn" class="attach_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-archive-o" style="font-size:16px"></span>&nbsp;<s:message code="consent.attach"/></a></li>
                <li style="display:none;"><a href="javascript:void(0);" id="excel_link_btn" class="excel_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>" option="Y"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/> (<s:message code="common.msg.excel"/> xlsx)</a></li>
                <li style="display:none;"><a href="javascript:void(0);" id="cell_link_btn" class="cell_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>" option="Y"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/> (<s:message code="common.msg.hancel"/> cell)</a></li>
                <li style="display:none;"><a href="javascript:void(0);" id="csv_link_btn" class="csv_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>" option="Y"><span class="fa fa-file-text" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/> (<s:message code="common.msg.text"/> csv)</a></li>
                <li style="display:none;"><a href="javascript:void(0);" id="pdf_link_btn" class="pdf_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>" option="Y"><span class="fa fa-file-pdf-o" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/> (PDF)</a></li>
                <c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'LS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
                    <li><a href="javascript:void(0);" class="all_down_link" data-type="L" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/></a></li>
                </c:if>
                <c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'BS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
                    <li><a href="javascript:void(0);" class="all_down_link" data-type="B" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-text-o" style="font-size:16px"></span>&nbsp;<s:message code="condition.body"/></a></li>
                </c:if>
                <c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'AS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
                    <li><a href="javascript:void(0);" class="all_down_link" data-type="A" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-archive-o" style="font-size:16px"></span>&nbsp;<s:message code="consent.attach"/></a></li>
                </c:if>
                <c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'WS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
                    <li><a href="javascript:void(0);" class="all_down_link" data-type="LB" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/>+<s:message code="condition.body"/></a></li>
                </c:if>
                <c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'CS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
                    <li><a href="javascript:void(0);" class="all_down_link" data-type="LBA" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/>+<s:message code="condition.body"/>+<s:message code="consent.attach"/></a></li>
                </c:if>
                <c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'LP') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
                    <li><a href="javascript:void(0);" class="print_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="glyphicon glyphicon-print"></span>&nbsp;<s:message code="selectCodeAll.list"/> <s:message code="common.msg.print"/></a></li>
                </c:if>
                <li class="dropdown-divider"></li>
                <li><a href="javascript:void(0);" class="downList" data-target="tabGrid" ><span class="glyphicon glyphicon-th-list"></span>&nbsp;<s:message code="common.msg.download"/> <s:message code="mail.view.list"/></a></li>
            </ul>
            <a href="javascript:;" style="padding-right:10px; color:#383838; cursor: pointer; font-size: 12px;float: right;" id="saveMsgData"><s:message code="filterInfo.setMsgFolder1"/></a>
            <a href="javascript:;" style="padding-right:10px; color:#383838; cursor: pointer; font-size: 12px;float: right; display: none;" id="feedbackBtn"><s:message code="condition.feedback"/> <s:message code="common.msg.setting"/></a>
            <ul id="feedbackSetting" style="display: none; z-index: 991; padding: 5px 0px;">
                <li><a href="javascript:void(0);" onclick="setFeedback(0);" style="padding-left: 20px;"><span class="feedbackCorrect" style="display: inline-block; position: relative; top: 0px;"></span>&nbsp;<s:message code="condition.info.feedback0"/></a></li>
                <li><a href="javascript:void(0);" onclick="setFeedback(1);" style="padding-left: 20px;"><span class="feedbackInCorrect" style="display: inline-block; position: relative; top: 0px;"></span>&nbsp;<s:message code="condition.info.class1"/></a></li>
                <li><a href="javascript:void(0);" onclick="setFeedback(2);" style="padding-left: 20px;"><span class="feedbackInCorrect" style="display: inline-block; position: relative; top: 0px;"></span>&nbsp;<s:message code="condition.info.class2"/></a></li>
                <li><a href="javascript:void(0);" onclick="setFeedback(3);" style="padding-left: 20px;"><span class="feedbackInCorrect" style="display: inline-block; position: relative; top: 0px;"></span>&nbsp;<s:message code="condition.info.class3"/></a></li>
                <li><a href="javascript:void(0);" onclick="setFeedback(4);" style="padding-left: 20px;"><span class="feedbackInCorrect" style="display: inline-block; position: relative; top: 0px;"></span>&nbsp;<s:message code="condition.info.class4"/></a></li>
                <li><a href="javascript:void(0);" onclick="setFeedback(9);" style="padding-left: 20px;"><span class="feedbackDefer" style="display: inline-block; position: relative; top: 0px;"></span>&nbsp;<s:message code="condition.info.feedback9"/></a></li>
            </ul>
            <div style="position: fixed; top: 0px; bottom: 0px; left: 0px; right: 0px; z-index: 990; display: none; width: 100%; height: 100%;" id="overlay"></div>
        </div>
        <a href="javascript:;" style="color:#383838;font-size: 12px;" class="dropdown-toggle" data-toggle="dropdown" id="config_toggle">
            <s:message code="condition.view.setup"/><span class="caret"></span>
        </a>
        <div class="dropdown-menu dropdown-menu-right"  style="min-width:180px;font-size:12px; height: 380px; padding:0;" id="additionalBtn">
            <div class="listRow" style="padding: 0;">
                <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.view.stype"/></div>
                <div class="listRowLeft" style="height: 20px;line-height: 15px;position: relative;top: 7px;padding: 0 3px;margin-left: 5px;">
                    <a id="none_btn" style="font-size: 11px; font-weight: initial; line-height: 20px; padding-right: 5px;" class="areaBtn"><img src="<c:url value="/img/message/message_none.jpg"/>"  style="padding-right: 4px;padding-bottom: 2px"><s:message code="condition.view.type1"/> </a>
                    <a id="bottom_btn" style="font-size: 11px; font-weight: initial; line-height: 20px; padding-right: 5px;" class="areaBtn"><img src="<c:url value="/img/message/message_bottom.jpg"/>" style="padding-right: 4px;padding-bottom: 2px"><s:message code="condition.view.type2"/></a>
                    <a id="right_btn" style="font-size: 11px; font-weight: initial; line-height: 20px; padding-right: 5px;" class="areaBtn"><img src="<c:url value="/img/message/message_right.jpg"/>" style="padding-right: 4px;padding-bottom: 2px"><s:message code="condition.view.type3"/></a>


                </div>
                <!-- <button class ="msg_button" id="config_colse" style="height: 22px; line-height: 19px; float: right; margin-top: 5px;margin-right: 10px;">닫기</button> -->
            </div>
            <div class="listRow" style="padding: 0;">
                <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.orderType"/></div>
                <select id="messageSort" class="listRowLeft" style="margin-top:5px; margin-left: 5px;">
                    <option value="ctime desc">▼ <s:message code="condition.date"/></option>
                    <option value="ctime asc">▲ <s:message code="condition.date"/></option>
                    <option value="pi_total desc">▼ <s:message code="condition.regexp"/></option>
                    <option value="pi_total asc">▲ <s:message code="condition.regexp"/></option>
                    <option value="size desc">▼ <s:message code="condition.size.all"/></option>
                    <option value="size asc">▲ <s:message code="condition.size.all"/></option>
                    <option value="body_size desc">▼ <s:message code="condition.size.body"/></option>
                    <option value="body_size asc">▲ <s:message code="condition.size.body"/></option>
                </select>
            </div>
            <div class="listRow" style="padding: 0;">
                <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.view.type5"/></div>
                <label style="font-weight: normal; cursor: pointer;"><input type="checkbox" class="listRowLeft" style="margin-top:10px; margin-left: 5px;" name="subjectbody" />&nbsp;&nbsp;<s:message code="common.msg.use"/></label>
            </div>
            <div class="listRow" style="padding: 0;">
                <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.view.type10"/></div>
                <label style="font-weight: normal; cursor: pointer;"><input type="checkbox" class="listRowLeft" style="margin-top:10px; margin-left: 5px;" name="overlapUse" />&nbsp;&nbsp;<s:message code="common.msg.use"/> <s:message code="condition.view.type11"/></label>
            </div>
            <div class="listRow" style="padding: 0;">
                <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.view.type6"/></div>
                <label style="font-weight: normal; cursor: pointer;"><input type="checkbox" class="listRowLeft" style="margin-top:10px; margin-left: 5px;" name="summary" />&nbsp;&nbsp;<s:message code="common.msg.use"/> <s:message code="condition.view.type7"/></label>
            </div>
            <div class="listRow" style="padding: 0;">
                <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.view.type12"/></div>
                <label style="font-weight: normal; cursor: pointer;"><input type="checkbox" class="listRowLeft" style="margin-top:10px; margin-left: 5px;" name="keywordHighlight" />&nbsp;&nbsp;<s:message code="common.msg.use"/> <s:message code="condition.view.type13"/></label>
            </div>
            <div class="listRow" style="padding: 0;">
                <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.view.type14"/></div>
                <label style="font-weight: normal; cursor: pointer;"><input type="checkbox" class="listRowLeft" style="margin-top:10px; margin-left: 5px;" name="hostQuery" />&nbsp;&nbsp;<s:message code="common.msg.use"/> <s:message code="condition.view.type15"/></label>
            </div>
            <div class="listRow" style="width: 575px; border-bottom: none; padding: 0;">
                <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 202px;padding-top: 70px;"><s:message code="condition.view.type4"/></div>
                <div class="listRowLeft" style="padding-left: 5px;">
								<span style="width: 435px; display:block;">
									<input id="insaFormatInput" style="width: 330px;" type="text" value="" data-format="name,emaile,busi,dept,jikgub,ip"/>
									<img src="<c:url value="/img/message/exclamation.png"/>" id="confError" style="display: none; padding-bottom:2px;" title="<s:message code="message.insa.error"/>">
									<img src="<c:url value="/img/message/accept.png"/>" id="confAccept" style="display: none; padding-bottom:2px;" title="<s:message code="message.insa.ok"/>">
									<span style="padding-left: 7px;" id="insaFormatOk"> <s:message code="common.msg.apply"/> </span>
									<span style="padding-left: 7px;" id="insaFormatClear"> <s:message code="common.msg.remove"/> </span>
								</span>
                    <span style="width: 435px; display:block;">
									<input  id="insaFormatInputEx" style="width:435px;cursor: auto !important;" disabled type="text" value="<s:message code="message.help.example"/>)" data-format="name,emaile,busi,dept,jikgub,ip"/>
								</span>
                    <select id="messageFormat" size="8" style="width:435px; margin-top: 10px; padding-top: 2px; height:110px;">
                        <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_name"/>/hong@xcurent.com/<s:message code="message.help.sample_bunm"/>/<s:message code="message.help.sample_deptnm"/>/<s:message code="message.help.sample_jikgubnm"/>/192.168.0.1" data-format="name/email/businm/deptnm/jikgubnm/ip">name/email/businm/deptnm/jikgubnm/ip</option>
                        <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_name"/>-hong@xcurent.com-<s:message code="message.help.sample_bunm"/>-<s:message code="message.help.sample_deptnm"/>-<s:message code="message.help.sample_jikgubnm"/>-192.168.0.1" data-format="name-email-businm-deptnm-jikgubnm-ip">name-email-businm-deptnm-jikgubnm-ip</option>
                        <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_name"/>,hong@xcurent.com,<s:message code="message.help.sample_bunm"/>,<s:message code="message.help.sample_deptnm"/>,<s:message code="message.help.sample_jikgubnm"/>,192.168.0.1" data-format="name,email,businm,deptnm,jikgubnm,ip">name,email,businm,deptnm,jikgubnm,ip</option>
                        <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_name"/>[hong@xcurent.com,<s:message code="message.help.sample_bunm"/>,<s:message code="message.help.sample_deptnm"/>,<s:message code="message.help.sample_jikgubnm"/>,192.168.0.1]" data-format="name[email,businm,deptnm,jikgubnm,ip]">name[email,businm,deptnm,jikgubnm,ip]</option>
                        <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_bunm"/>/<s:message code="message.help.sample_deptnm"/>/<s:message code="message.help.sample_name"/>" data-format="businm/deptnm/name">businm/deptnm/name</option>
                        <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_bunm"/>-<s:message code="message.help.sample_deptnm"/>-<s:message code="message.help.sample_jikgubnm"/>-<s:message code="message.help.sample_name"/>" data-format="businm-deptnm-jikgubnm-name">businm-deptnm-jikgubnm-name</option>
                        <option value="<s:message code="message.help.example"/>) [<s:message code="message.help.sample_bunm"/>-<s:message code="message.help.sample_deptnm"/>-<s:message code="message.help.sample_jikgubnm"/>]-<s:message code="message.help.sample_name"/>" data-format="[businm-deptnm-jikgubnm]-name">[businm-deptnm-jikgubnm]-name</option>
                        <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_name"/>,hong@xcurent.com,192.168.0.1" data-format="name,email,ip">name,email,ip</option>
                        <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_name"/>(hong@xcurent.com,192.168.0.1)" data-format="name(email,ip)">name(email,ip)</option>
                        <option value="" data-format=""> <s:message code="message.user.custom"/></option>
                    </select>
                </div>
            </div>
        </div>
    </div>
    <div id="content" class="ui-layout-north" style="position: absolute;left: 0px;right: 0px;bottom: 0px;top: 0px;font-family: 돋움,Dotum;">
        <div style="position: relative;zoom: 1;z-index: 20;overflow: hidden;">
            <div class="mail_header">
                <div class="leftHideBtn"><button class ="msg_button list_icon"><i class="fa fa-bars" aria-hidden="true"></i></button></div>
                <div class="tabWrap" id="headerTabs">
                    <ul class="listTab_div" id="resultTabs">
                        <li class="tab_li select" id="result0" data-index="0">
                            <div class="tab_txt_top addTabDiv" id="result_tab0" style="float:left;">
                                <s:message code="message.msg.newtab"/>
                            </div>
                            <span class="resultCntSpan" style="padding-right:0px;"></span>
                        </li>
                        <li class="tab_li" data-index="">
                            <div class="tab_txt_top addTabDiv" style="padding:0 10px;"><span class="glyphicon glyphicon-plus" style="cursor:pointer;color:#494949;"></span></div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div id="contentListArea" class="inner-center">
        <iframe src="<c:url value="/ems/contentList.do?gridInit=true"/>" id="contentList0" class="contentList"></iframe>
        <iframe src="<c:url value="/ems/contentList.do?gridInit="/>" id="contentList1" class="contentList" style="left:-10000px"></iframe>
    </div>
    <div id="contentBodyArea" class="inner-east">
        <iframe src="<c:url value="/ems/contentBodyNew.do"/>" id="contentBody0" class="contentBody" name="contentBody"></iframe>
        <iframe src="<c:url value="/ems/contentBodyNew.do"/>" id="contentBody1" class="contentBody" name="contentBody" style="left:-10000px;"></iframe>
    </div>
</div>