<div id="content_left" class="ui-layout-west" style="overflow-y:hidden">
    <div class="section_menu" style="min-width:299px;">
        <div style=" display:flex;">
            <div id="msg_condition_menu" class="filter_menu" style="width: 33.3%;"><div class="filter_icon"><span class="filter_icon_text"><s:message code="condition.select.search1"/></span></div></div>
            <div id="msg_condition_saver" class="filter_menu condition_menu_unselected" style="width: 33.3%;border-left: 1px solid #cbcbcb;"><div class="filter_folder_icon"><span class="filter_icon_text"><s:message code="condition.advance_search1"/></span></div></div>
            <div id="msg_folder" class="filter_menu condition_menu_unselected" style="width: 33.3%;border-left: 1px solid #cbcbcb;"><div class="msg_folder_icon"><span class="filter_icon_text"><s:message code="filterInfo.messageFolder1"/></span></div></div>
        </div>
    </div>
    <div id="search_top_area" style="height: calc(100% - 55px);min-width:299px;">
        <div class="searchButtonArea">
            <button class="search_btn" id="searchBtn"><span><s:message code="common.search1"/></span></button>
        </div>
        <div class="checkbox c-checkbox" style="width:75px;position: absolute;top: 70px; left:15px;font-size:12px;">
            <label><input type="checkbox" name="researchCheckbox" id="researchCheckbox" disabled><span class="fa fa-check"></span><s:message code="condition.research1"/></label>
        </div>

        <div class="condition_save">
            <a href="javascript:;" class="resetCondition" style="float:left;padding-left:15px;"><i class="fa fa-refresh"></i> <s:message code="condition.reset1"/></a>
            <a href="javascript:;" class="showFilterBtn"><i class="fa fa-folder-open-o"></i> <s:message code="filterInfo.box"/></a>
            <span class="filterIcon hide" data-id=""><i class="fa fa-filter" aria-hidden="true"></i></span>
            <span style="float:right;">&nbsp;|&nbsp;</span>
            <a href="javascript:;" class="saveCondition" style="padding-right:0;"><i class="fa fa-floppy-o"></i> <s:message code="condition.save"/></a>
        </div>
        <div class="condition_top_sub"></div>
        <div class="condition_top">▲</div>
        <div id="condition_detail" class="section_condition scrollbar-inner">
            <div class="condition_option" style="padding-top:15px;">
                <div class="condition_item">
                    <div class="condition_title" style="float: left;"><i class="fa fa-caret-right"></i> <s:message code="condition.search_str"/>
                        <img style="width: 16px;margin-bottom: 2px;" src="<c:url value="/img/icon/question.png"/>" class="areaBtn" id="searchHelpBtn">
                    </div>
                    <div style="float: right; padding-right: 22px;">
                        <a href="javascript:;" class="showSearchKeywordBtn"><i class="fa fa-cog"></i> <s:message code="searchKeyword.management"/></a>
                    </div>
                    <div style="margin-top: 5px;">
                        <input class="condition_input_text" type="text" id="searchStrInput" name="serch" placeholder="<s:message code="common.msg.searchMsg"/>" style="width: 260px;height: 35px;border: 2px solid #337AB7;padding-left: 5px;">
                    </div>
                    <div style="margin-top: 15px;"></div>
                    <%-- <div style="display: inline;">
                        <select name="searchArea" class="condition_select" style="margin-top: 5px;" id="searchField">
                            <option value=""><s:message code="condition.field.search.all"/></option>
                            <option value="subject"><s:message code="condition.subject"/></option>
                            <option value="body"><s:message code="condition.body"/></option>
                            <option value="attachname attachname_str"><s:message code="condition.attach_name"/></option>
                            <%if(!isOCR){ %>
                            <option value="attach"><s:message code="condition.attach"/></option>
                            <%}else{ %>
                            <option value="attach ocr_attach"><s:message code="condition.attach"/></option>
                            <option value="ocr_attach">OCR</option>
                            <%} %>
                            <option value="host host_str">Host</option>
                            <option value="path query">Path</option>
                            <option value="srcip"><s:message code="condition.source"/> IP</option>
                            <option value="dstip"><s:message code="condition.destination"/> IP</option>
                            <option value="sender_str"><s:message code="condition.sender"/></option>
                            <option value="sname"><s:message code="condition.sender_name"/></option>
                            <option value="recvs"><s:message code="condition.recv"/></option>
                            <option value="recvs_name"><s:message code="condition.recv_name"/></option>
                            <option value="to tname"><s:message code="condition.recv"/>(<s:message code="condition.to"/>)</option>
                            <option value="cc cname"><s:message code="condition.recv"/>(<s:message code="condition.cc"/>)</option>
                            <option value="bcc bname"><s:message code="condition.recv"/>(<s:message code="condition.bcc"/>)</option>
                            <option value="user user_str userid name"><s:message code="common.org.user"/></option>
                            <option value="usr_id"><s:message code="common.msg.account"/></option>
                        </select>
                    </div> --%>
                    <div class="condition_item">
                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.field.search"/></div>
                        <select id="searchField" title="<s:message code="condition.field.search.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">

                            <option value="subject"><s:message code="condition.subject"/></option>
                            <option value="body.text"><s:message code="condition.body"/></option>
                            <option value="attach.name"><s:message code="condition.attach_name"/></option>
                            <%if(!isOCR){ %>
                            <option value="attach.text"><s:message code="condition.attach"/></option>
                            <%}else{ %>
                            <option value="attach ocr_attach"><s:message code="condition.attach"/></option>
                            <option value="ocr_attach">OCR</option>
                            <%} %>
                            <option value="http.host">Host</option>
                            <option value="filePath">Path</option>
                            <option value="network.srcip"><s:message code="condition.source"/> IP</option>
                            <option value="network.dstip"><s:message code="condition.destination"/> IP</option>
                            <option value="mail.sender.email"><s:message code="condition.sender"/></option>
                            <option value="mail.sender.name"><s:message code="condition.sender_name"/></option>
                            <option value="mail.to.email,mail.cc.email,mail.bcc.email"><s:message code="condition.recv"/></option>
                            <option value="mail.to.name,mail.cc.name,mail.bcc.name"><s:message code="condition.recv_name"/></option>
                            <option value="mail.to.name"><s:message code="condition.recv"/>(<s:message code="condition.to"/>)</option>
                            <option value="mail.cc.name "><s:message code="condition.recv"/>(<s:message code="condition.cc"/>)</option>
                            <option value="mail.bcc.name "><s:message code="condition.recv"/>(<s:message code="condition.bcc"/>)</option>
                            <option value="user.name,user.id"><s:message code="common.org.user"/></option>
                            <option value="user.id"><s:message code="common.msg.account"/></option>


                        </select>
                    </div>
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item">
                    <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.service"/></div>
                    <select id="serviceType" title="<s:message code="condition.service.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true"></select>
                </div>
                <!--  대외비 목록 -->
                <div class="condition_item" id="epmsgList">
                    <div class="condition_divider"></div>
                    <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.epmsgType.list"/></div>
                    <select id="initEpmsg" title="<s:message code="condition.epmsgType.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true"data-live-search="true"></select>
                    <input type="hidden" id="initEpmsgName" />
                </div>
                <!-- Knox 첨부 여부  -->
                <div class="condition_item" id ="KnoxAttachYN">
                    <div class="condition_divider"></div>
                    <div class="condition_title"><i class="fa fa-caret-right"></i>  <s:message code="condition.epmsgType.bodyImg"/></div>
                    <div class="condition_sub_title">
                        <label class="condition_label"><input type="radio" name="bodyImg" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                        <label class="condition_label"><input type="radio" name="bodyImg" value="Y"> <span><s:message code="condition.exist"/></span></label>
                        <label class="condition_label"><input type="radio" name="bodyImg" value="N"> <span><s:message code="condition.none"/></span></label>
                    </div>
                </div>

            </div>
            <div class="condition_group display_none">
                <s:message code="common.msg.time"/><i class="fa fa-minus-square"></i>
            </div>
            <div class="condition_option">
                <div class="condition_item">
                    <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.period"/></div>
                    <select name="searchArea" class="condition_select" id="easyDate">
                        <option value="" selected="selected"><s:message code="condition.select.period"/></option>
                        <option value="1"><s:message code="condition.today"/></option>
                        <option value="2"><s:message code="condition.yesterday"/></option>
                        <option value="3"><s:message code="condition.week" arguments="1"/></option>
                        <option value="6"><s:message code="condition.month" arguments="1"/></option>
                        <option value="7"><s:message code="condition.month" arguments="2"/></option>
                        <option value="8"><s:message code="condition.month" arguments="3"/></option>
                    </select>
                    <div style="display: flex; width: 260px; padding-top: 4px;">
                        <input type="text" id="startdatepicker" class="input-xs form-control border-radius-none" style="padding: 1px 0px 0px 3px;border-radius: 0;font-size: 11px; width: 125px;"/>
                        <span style="padding-top: 4px;">-</span>
                        <input type="text" id="enddatepicker" class="input-xs form-control border-radius-none"  style="padding: 1px 0px 0px 3px;border-radius: 0;font-size: 11px; width: 125px;"/>
                    </div>
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item">
                    <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.work"/></div>
                    <div class="condition_sub_title">
                        <label class="condition_label"><input type="radio" name="ctimeWork" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                        <label class="condition_label"><input type="radio" name="ctimeWork" value="W"> <span><s:message code="condition.work"/></span></label>
                        <label class="condition_label"><input type="radio" name="ctimeWork" value="R"> <span><s:message code="condition.notwork"/></span></label>
                    </div>
                </div>
            </div>
            <!-- SK 하이닉스 비밀문서 관련 검색기능 -->
            <div id="secretDocuDiv" style="display: none;">
                <div class="condition_group display_none">
                    <s:message code="common.msg.secretInformation"/><i class="fa fa-minus-square"></i>
                </div>
                <div class="condition_option">
                    <div class="condition_item">
                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.itype"/></div>
                        <select id="skInfoType" title="<s:message code="condition.docu.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                            <option value="1"><s:message code="condition.info.Y"/></option>
                            <option value="0"><s:message code="condition.info.N"/></option>
                        </select>
                    </div>
                    <div class="condition_divider"></div>
                    <div class="condition_item">
                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.feedback"/></div>
                        <select id="skFeedbackType" title="<s:message code="condition.feedback.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                            <option value="1"><s:message code="condition.info.secretFeedbackY"/></option>
                            <option value="9"><s:message code="condition.info.feedback9"/></option>
                            <option value="0"><s:message code="condition.info.secretFeedbackN"/></option>
                        </select>
                    </div>
                    <div class="condition_divider"></div>
                    <div class="condition_item">
                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.sprob"/>(%)</div>
                        <select id="skProbType" title="<s:message code="condition.sprob.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                            <option value="0.5|1.1">50 ~ 100</option>
                            <option value="0.1|0.5">10 ~ 49</option>
                            <option value="0|0.1">0 ~ 9</option>
                        </select>
                    </div>
                </div>
            </div>
            <div id="infoFeedbackDiv" style="display: none;">
                <div class="condition_group display_none">
                    <s:message code="common.msg.information"/><i class="fa fa-minus-square"></i>
                </div>
                <div class="condition_option">
                    <div class="condition_item">
                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.infotype"/></div>
                        <select id="infoType" title="<s:message code="condition.infotype.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                            <option value="4"><s:message code="condition.info.class4"/></option>
                            <option value="3"><s:message code="condition.info.class3"/></option>
                            <option value="2"><s:message code="condition.info.class2"/></option>
                            <option value="1"><s:message code="condition.info.class1"/></option>
                        </select>
                    </div>
                    <div class="condition_divider"></div>
                    <div class="condition_item">
                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.feedback"/></div>
                        <select id="feedbackType" title="<s:message code="condition.feedback.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                            <option value="0"><s:message code="condition.info.feedback0"/></option>
                            <option value="1"><s:message code="condition.info.feedback1"/></option>
                            <option value="2"><s:message code="condition.info.feedback2"/></option>
                            <option value="3"><s:message code="condition.info.feedback3"/></option>
                            <option value="4"><s:message code="condition.info.feedback4"/></option>
                            <option value="9"><s:message code="condition.info.feedback9"/></option>
                            <option value="-1"><s:message code="condition.info.feedback-1"/></option>
                        </select>
                    </div>
                    <div class="condition_divider"></div>
                    <div class="condition_item">
                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.prob"/>(%)</div>
                        <select id="probType" title="<s:message code="condition.prob.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                            <option value="0.5|1.1">50 ~ 100</option>
                            <option value="0.1|0.5">10 ~ 49</option>
                            <option value="0|0.1">0 ~ 9</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="condition_group display_none">
                <s:message code="condition.user"/><i class="fa fa-minus-square"></i>
            </div>
            <div class="condition_option">
                <div class="condition_item">
                    <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.receive_send"/></div>
                    <div class="condition_sub_title">
                        <label class="condition_label"><input type="radio" name="receiveSend" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                        <label class="condition_label"><input type="radio" name="receiveSend" value="I"> <span><s:message code="condition.receive"/></span></label>
                        <label class="condition_label"><input type="radio" name="receiveSend" value="O"> <span><s:message code="condition.send"/></span></label>
                    </div>
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item">
                    <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.sender"/></div>
                    <%if(Common.isEquals(rsUppercase, "Y")) {%>
                    <div class="condition_left">&nbsp;<label style="font-weight: normal;"><input type="checkbox" id="senders_upperCase" disabled/><span style="position: relative;top: -2px;font-weight: normal;"> <s:message code="condition.uppercase"/></span></label></div>
                    <%} %>
                    <div class="condition_not"><label><input type="checkbox" id="senders_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                    <input class="condition_input_text" type="text" id="senders" name="serch" placeholder="<s:message code="condition.message.sender"/>">
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item">
                    <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.detail.recvs"/></div>
                    <div class="condition_sub_title">
                        <label class="condition_label"><input type="radio" name="receive_option" id="receive_option_all" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                        <label class="condition_label"><input type="radio" name="receive_option" id="receive_option_more" value="detail"> <span><s:message code="condition.info.detail"/></span></label>
                    </div>
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item">
                    <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.recv"/></div>
                    <%if(Common.isEquals(rsUppercase, "Y")) {%>
                    <div class="condition_left">&nbsp;<label style="font-weight: normal;"><input type="checkbox" id="receivers_upperCase" disabled/><span style="position: relative;top: -2px;font-weight: normal;"> <s:message code="condition.uppercase"/></span></label></div>
                    <%} %>
                    <div class="condition_not"><label><input type="checkbox" id="receivers_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                    <input class="condition_input_text" type="text" id="receivers" name="serch" placeholder="<s:message code="condition.message.receiver"/>">
                </div>
                <div class="receivers_detail" style="display: none;">
                    <div class="condition_item">
                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.recv"/> (<s:message code="condition.to"/>)</div>
                        <div class="condition_not"><label><input type="checkbox" id="m_to_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                        <input class="condition_input_text" type="text" id="m_to" name="serch" placeholder="<s:message code="condition.input.to"/>">
                    </div>
                    <div class="condition_divider"></div>
                    <div class="condition_item">
                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.recv"/> (<s:message code="condition.cc"/>)</div>
                        <div class="condition_not"><label><input type="checkbox" id="m_cc_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                        <input class="condition_input_text" type="text" id="m_cc" name="serch" placeholder="<s:message code="condition.input.cc"/>">
                    </div>
                    <div class="condition_divider"></div>
                    <div class="condition_item">
                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.recv"/> (<s:message code="condition.bcc"/>)</div>
                        <div class="condition_not"><label><input type="checkbox" id="m_bcc_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                        <input class="condition_input_text" type="text" id="m_bcc" name="serch" placeholder="<s:message code="condition.input.bcc"/>">
                    </div>
                </div>
                <div class="condition_divider recvs_jikgub"></div>
                <div class="condition_item recvs_jikgub">
                    <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.recv_jikgub"/></div>
                    <div class="condition_not"><label><input type="checkbox" id="recv_jikgub_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                    <select id="rcvJikgub" title="<s:message code="condition.recv_jikgub.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true"data-live-search="true"></select>
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item">
                    <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.allofus"/></div>
                    <select name="searchArea" class="condition_select" id="allOfus">
                        <option value=""><s:message code="condition.allofus.all"/></option>
                        <option value="IA">1) <s:message code="condition.allofus1"/></option>
                        <option value="EA">2) <s:message code="condition.allofus2"/></option>
                        <option value="PA">3) <s:message code="condition.allofus3"/></option>
                        <option value="IA|EA">4) <s:message code="condition.allofus4"/></option>
                        <option value="EA|PA">5) <s:message code="condition.allofus5"/></option>
                        <option value="IA|PA">6) <s:message code="condition.allofus6"/></option>
                        <option value="IA|IT">7) <s:message code="condition.allofus7"/></option>
                        <option value="ET|EA">8) <s:message code="condition.allofus8"/></option>
                        <option value="PT|PA">9) <s:message code="condition.allofus9"/></option>
                        <option value="IA|ET|IT|EA">10) <s:message code="condition.allofus10"/></option>
                        <option value="IA|IT|PT|PA">11) <s:message code="condition.allofus11"/></option>
                        <option value="ET|EA|PT|PA">12) <s:message code="condition.allofus12"/></option>
                        <option value="SO">13) <s:message code="condition.allofus13"/></option>
                        <option value="SI">14) <s:message code="condition.allofus14"/></option>
                    </select>
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item">
                    <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.userGroup"/></div>
                    <div class="condition_not"><label><input type="checkbox" id="userGroupSeq_not" disabled /><span> <s:message code="query.make.except"/></span></label></div>
                    <select name="searchArea" class="condition_select" id="userGroupSeq"></select>
                    <input type="hidden" id="userGroupName" />
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item">
                    <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.interestGroup"/></div>
                    <div class="condition_not"><label><input type="checkbox" id="interGroup_not" disabled /><span> <s:message code="query.make.except"/></span></label></div>
                    <select name="searchArea" class="condition_select" id="interGroup"></select>
                    <input type="hidden" id="interGroupName" />
                </div>
            </div>

            <div class="condition_group display_none">
                <s:message code="condition.organization"/><i class="fa fa-minus-square"></i>
            </div>
            <div class="condition_option">
                <div class="condition_item">
                    <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="common.org.busi"/></div>
                    <div class="condition_not"><label><input type="checkbox" id="busi_not" disabled /><span> <s:message code="query.make.except"/></span></label></div>
                    <select id="busi" title="<s:message code="common.org.busi.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true"data-live-search="true"></select>
                    <input type="hidden" id="busiStr" />
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item">
                    <span class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="common.org.dept"/></span>
                    <div class="condition_not"><label><input type="checkbox" id="dept_not" disabled /><span> <s:message code="query.make.except"/></span></label></div>
                    <div class="condition_sub_title">
                        <span class="condition_title" style="width: 65px;display: inline-block;"><s:message code="common.org.choose.dept"/></span>
                        <span class="condition_sub_title">
										<button style="width:61px;position: relative;" id="deptBtn" class="button_style filterAddBtn" title="<s:message code="common.msg.select"/>">
											<span class="ui-icon ui-icon-circle-plus icon_style"></span><s:message code="common.msg.select"/>
											<span id="deptSelectedArea" class="codeSelectedBtn" style="display:none;">
												<span class="btn" title="">0</span>
											</span>
										</button>
									</span>
                    </div>
                    <input type="hidden" id="deptVal" />
                    <input type="hidden" id="deptStr" />
                </div>
            </div>

            <div class="condition_group display_none">
                <s:message code="condition.etc"/><i class="fa fa-minus-square"></i>
            </div>
            <div class="condition_option">
                <div class="condition_item">
                    <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> URL
                        <img style="cursor:help; width: 16px;margin-bottom: 2px;" src="<c:url value="/img/icon/icon_help.png"/>" class="areaBtn" title="http:// <s:message code="query.make.except"/>">
                    </div>
                    <div class="condition_not"><label><input type="checkbox" id="url_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                    <textarea id=url class="condition_input_text" style="resize: none"></textarea>
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item">
                    <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.isread"/></div>
                    <div class="condition_sub_title">
                        <label class="condition_label"><input type="radio" name="readYn" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                        <label class="condition_label"><input type="radio" name="readYn" value="Y"> <span><s:message code="condition.read"/></span></label>
                        <label class="condition_label"><input type="radio" name="readYn" value="N"> <span><s:message code="condition.unread"/></span></label>
                    </div>
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item" id="attached_in">
                    <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.isattached"/></div>
                    <div class="condition_sub_title">
                        <label class="condition_label"><input type="radio" name="attachYn" value="" checked="checked"> <span>All</span></label>
                        <label class="condition_label"><input type="radio" name="attachYn" value="Y"> <span><s:message code="condition.exist"/></span></label>
                        <label class="condition_label"><input type="radio" name="attachYn" value="N"> <span><s:message code="condition.none"/></span></label>
                    </div>
                    <input type="hidden" id="attachVal" />
                    <input type="hidden" id="attachStr" />
                    <div class="condition_sub_title" style="padding-left: 10px;float:left;padding-bottom:5px;">
                        <span class="condition_title" style="width: 65px;display: inline-block;"><s:message code="condition.select"/></span>
                        <span class="condition_sub_title">
										<button style="width:61px;position: relative;" id="attachBtn" class="button_style filterAddBtn" title="<s:message code="condition.select"/>">
											<span class="ui-icon ui-icon-circle-plus icon_style"></span><s:message code="condition.select"/>
											<span id="attachSelectedArea" class="codeSelectedBtn" style="display:none;">
												<span class="btn" title="">0</span>
											</span>
										</button>
									</span>
                    </div>
                    <div class="condition_not"><label><input type="checkbox" id="attachYn_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                    <div class="condition_sub_title" style="padding-left: 10px;">
                        <span class="condition_title" style="width: 65px;display: inline-block;"> <s:message code="condition.actual.attachment"/></span>
                        <span class="condition_sub_title">
										<label class="condition_label" style="margin-right: 5px;"><input type="radio" name="realAttYn" value="" checked="checked" disabled="disabled"> <span><s:message code="common.msg.all"/></span></label>
										<label class="condition_label" style="margin-right: 5px;"><input type="radio" name="realAttYn" value="Y" disabled="disabled"> <span><s:message code="condition.onemore"/></span></label>
										<label class="condition_label" style="margin-right: 5px;"><input type="radio" name="realAttYn" value="N" disabled="disabled"> <span><s:message code="condition.none"/></span></label>
									</span>
                    </div>
                    <div class="condition_sub_title" style="padding-left: 10px;">
                        <span class="condition_title" style="width: 65px;display: inline-block;"> DRM</span>
                        <span class="condition_sub_title">
										<label class="condition_label" style="margin-right: 5px;"><input type="radio" name="drmYn" value="" checked="checked" disabled="disabled"> <span><s:message code="common.msg.all"/></span></label>
										<label class="condition_label" style="margin-right: 5px;"><input type="radio" name="drmYn" value="Y" disabled="disabled"> <span><s:message code="condition.exist"/></span></label>
										<label class="condition_label" style="margin-right: 5px;"><input type="radio" name="drmYn" value="N" disabled="disabled"> <span><s:message code="condition.none"/></span></label>
									</span>
                    </div>
                </div>
                <!-- OCR 첨부 여부  -->
                <div class="condition_divider"></div>
                <div class="condition_item" id ="ocrAttachYn">
                    <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.ocr.attach"/></div>
                    <div class="condition_sub_title">
                        <label class="condition_label"><input type="radio" name="OCRYn" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                        <label class="condition_label"><input type="radio" name="OCRYn" value="Y"> <span><s:message code="condition.exist"/></span></label>
                        <label class="condition_label"><input type="radio" name="OCRYn" value="N"> <span><s:message code="condition.none"/></span></label>
                    </div>
                </div>

                <div class="condition_divider"></div>
                <div class="condition_item">
                    <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.keyword"/></div>
                    <div class="condition_not"><label><input type="checkbox" id="keywordYn_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                    <div class="condition_sub_title">
                        <label class="condition_label"><input type="radio" name="keywordYn" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                        <label class="condition_label"><input type="radio" name="keywordYn" value="Y"> <span><s:message code="condition.exist"/></span></label>
                        <label class="condition_label"><input type="radio" name="keywordYn" value="N"> <span><s:message code="condition.none"/></span></label>
                    </div>
                    <div class="condition_sub_title">
                        <span class="condition_title" style="width: 65px;display: inline-block;"><s:message code="condition.select"/></span>
                        <span class="condition_sub_title">
										<button style="width:61px;position: relative;" id="keywordBtn" class="button_style filterAddBtn" title="<s:message code="condition.select"/>">
											<span class="ui-icon ui-icon-circle-plus icon_style"></span><s:message code="condition.select"/>
											<span id="keywordSelectedArea" class="codeSelectedBtn" style="display:none;">
												<span class="btn" title="">0</span>
											</span>
										</button>
									</span>
                    </div>
                    <input type="hidden" id="keywordVal" />
                    <input type="hidden" id="keywordStr" />
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item">
                    <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.regexp"/></div>
                    <div class="condition_sub_title">
                        <label class="condition_label"><input type="radio" name="regexpYn" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                        <label class="condition_label"><input type="radio" name="regexpYn" value="Y"> <span><s:message code="condition.exist"/></span></label>
                        <label class="condition_label"><input type="radio" name="regexpYn" value="N"> <span><s:message code="condition.none"/></span></label>
                    </div>
                    <div class="condition_sub_title">
                        <span class="condition_title" style="width: 65px;display: inline-block;"><s:message code="condition.select"/></span>
                        <span class="condition_sub_title">
										<button style="width:61px;position: relative;" id="regexpBtn" class="button_style filterAddBtn" title="<s:message code="condition.select"/>">
											<span class="ui-icon ui-icon-circle-plus icon_style"></span><s:message code="condition.select"/>
											<span id="regexpSelectedArea" class="codeSelectedBtn" style="display:none;">
												<span class="btn" title="">0</span>
											</span>
										</button>
									</span>
                    </div>
                    <input type="hidden" id="regexpVal" />
                    <input type="hidden" id="regexpStr" />
                </div>
                <div id="sctDiv" style="display: none;">
                    <div class="condition_divider"></div>
                    <div class="condition_item">
                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.sct"/></div>
                        <div class="condition_sub_title">
                            <label class="condition_label"><input type="radio" name="sctYn" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                            <label class="condition_label"><input type="radio" name="sctYn" value="Y"> <span><s:message code="condition.exist"/></span></label>
                            <label class="condition_label"><input type="radio" name="sctYn" value="N"> <span><s:message code="condition.none"/></span></label>
                        </div>
                    </div>
                </div>
                <div class="condition_divider"></div>
                <div class="condition_item">
                    <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.size"/>
                        <img style="cursor:help; width: 16px;margin-bottom: 2px;" src="<c:url value="/img/icon/icon_help.png"/>" class="areaBtn" title="<s:message code="filterInfo.unit"/> : KByte">
                    </div>
                    <div class="condition_sub_title">
                        <label class="condition_label"><input type="radio" name="sizeType" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                        <label class="condition_label"><input type="radio" name="sizeType" value="B"> <span><s:message code="condition.size.body"/></span></label>
                        <label class="condition_label"><input type="radio" name="sizeType" value="A"> <span><s:message code="condition.size.attach"/></span></label>
                    </div>
                    <div style="padding-top: 6px;">
                        <input type="text" style="width:60px;" id="sizeStartVal">
                        <select class="searchSelect" name="attach_size" id="sizeOption">
                            <option value="L"><s:message code="condition.over"/></option>
                            <option value="S"><s:message code="condition.below"/></option>
                            <option value="B"><s:message code="condition.range"/></option>
                        </select>
                        <input type="text" style="width:60px;" id="sizeEndVal" disabled> (KBytes)
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="in" id="saveFilterTab" style="width:100%; height:calc(100% - 66px); display: none;">
        <div class="searchButtonArea">
            <button class="search_btn" id="searchQueryBtn"><span><s:message code="common.search1"/></span></button>
        </div>
        <div class="condition_save">
            <a href="javascript:;" class="resetCondition" style="float:left;padding-left:15px;"><i class="fa fa-refresh"></i> <s:message code="condition.reset1"/></a>
            <a href="javascript:;" class="showFilterBtn"><i class="fa fa-folder-open-o"></i> <s:message code="filterInfo.box"/></a>
            <span class="queryIcon hide" data-id=""><i class="fa fa-filter" aria-hidden="true"></i></span>
            <span style="float:right;">&nbsp;|&nbsp;</span>
            <a href="javascript:;" class="saveCondition" style="padding-right:0;"><i class="fa fa-floppy-o"></i> <s:message code="condition.save"/></a>
        </div>
        <div id="query_detail" class="section_condition scrollbar-inner">
            <div class="condition_option" style="padding-top:0;height:500px;">
                <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="query.make.query"/></div>
                <div class="condition_item" style="height:100%;margin-top:5px; padding-bottom: 20px;">
                    <textarea class="queryTextarea" name="serch" placeholder="<s:message code="query.make.input1"/>" id="solrQueryText"></textarea>
                    <input type="hidden" id="searchQueryStrInput">
                </div>
            </div>
            <div class="condition_option">
                <div class="condition_item">
                    <button type="button" class="btn btn-sm btn-primary searchQueryBtn"><span class="glyphicon glyphicon-check"></span>&nbsp;<s:message code="query.make.inputer"/></button>
                </div>
            </div>
        </div>
    </div>
    <div class="in" id="message_folderTab" style="width:100%; height:calc(100% - 66px); display: none;">
        <div style="display: flex;padding: 5px 5px 5px 10px;">
            <input class="condition_input_text" type="text" name="serch" placeholder="<s:message code="filterInfo.folder.search"/>" id="folderSearchStr" style="width: 250px;">
            <button class="search_btn" id="folderSearchBtn"><span><s:message code="common.search"/></span></button>
        </div>
        <div class="scrollbar-inner saveFilterTab_tree">
            <ul id="folderTree" class="ztree" style="height:100%;width:100%;overflow:auto;"></ul>
        </div>
    </div>
</div>