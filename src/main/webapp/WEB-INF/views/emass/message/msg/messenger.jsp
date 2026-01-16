<%@ page import="com.xcurenet.common.util.Common" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>

	td.day,.dow,.picker-switch,.prev,.next{
		color:#333333 !important;
	}
	.chatList .chatBox .bubble {
		margin-top: 0px;
	}

	.messengerList .messengerBox .people {
		height: 650px;
	}

	.month{
		color: black;
	}


	pre{
		background-color: transparent; !important;
		font-size: 14px;!important;
		color: black;
	}
	code{
		color: black;
	}
	.condition_top_sub{
		position: fixed;
		width: 300px;
		background-color: rgba(0, 94, 193, 0.56);
		height: 2px;
		z-index: 100000;
		display: none;
	}

	.condition_top{
		position: fixed;
		width: 25px;
		background-color: rgba(0, 94, 193, 0.8);
		text-align: center;
		margin-left: 260px;
		z-index: 100000;
		margin-top: 3px;
		-moz-border-radius: 50px;
		-webkit-border-radius: 50px;
		border-radius: 50px;
		height: 25px;
		line-height: 23px;
		font-size: 10px;
		font-weight: bold;
		cursor: pointer;
		color:#fff;
		margin-top:-8px;
	}
</style>


<%
	String adminType = Common.getAdminType(session);
	String firstAdminYn = Common.getFirstAdminYn(session);
%>



<style>

	.timeline-panel:hover{
		cursor: pointer;
	}

	#userCntArea:hover {
		cursor: pointer;
	}

	#wrap {
		overflow: hidden;
	}

	@media screen and (max-width: 1640px) {
		.chatList {
			display: none; /* chatList div를 감춤 */
		}
	}

	span.mini {
		font-size: 13px;
	}


</style>

<script type="text/javascript" src="<c:url value="/js/messenger.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>

<head>

	<style>

	</style>
	<script>
        var messengerListCnt = 0;
        var nodataMsg = '<s:message code="common.msg.nodata"/>';
        var notone = '<s:message code="common.msg.notone"/>';
        var chatting = '<s:message code="eikon.msg.chat"/>';
        var endChat = '<s:message code="eikon.msg.finish"/>';
        var unreadTitle = '<s:message code="eikon.msg.unreadTitle"/>';
        var condition = {
            messageInputFilter: '<s:message code="condition.message.input.filter"/>',
            messageInputPeriod: '<s:message code="condition.message.input.period"/>',
            consentMsgTimecheck: '<s:message code="consent.msg.timecheck"/>',
            messageNumbercheck: '<s:message code="condition.message.numbercheck"/>',
            messageFolderFilter: '<s:message code="condition.message.folder.filter"/>',
            messageSelectFolder: '<s:message code="condition.message.select.folder"/>',
            msgSaved: '<s:message code="common.msg.saved"/>',
            selectInterest: '<s:message code="condition.select.interest"/>',
            interestUserAll: '<s:message code="interest.user.all"/>',
            commonMsgAll: '<s:message code="common.msg.all"/>',
            serviceAll: '<s:message code="condition.service.all"/>',
            messengerAll: '<s:message code="condition.messenger.all"/>',
            orgBusiAll: '<s:message code="common.org.busi.all"/>',
            orgDeptAll: '<s:message code="common.org.dept.all"/>',
            msgSelect_all: '<s:message code="common.msg.select_all"/>',
            msgUnselect_all: '<s:message code="common.msg.unselect_all"/>',
            msgNoresult: '<s:message code="common.msg.noresult"/>',
            msgConnectError: '<s:message code="common.msg.connect.error"/>',
            messageSelectDashboard: '<s:message code="condition.message.select.dashboard"/>',
            msgConfirmSave: '<s:message code="common.msg.confirm.save"/>',
            searchService: '<s:message code="condition.search.service"/>',
            authAlert: '<s:message code="admin.auth.alert"/>',
            noselect: '<s:message code="common.msg.noselect"/>'

        };
        $(document).ready(function () {

            $('#group_list').scroll(function (){
                if (isEnd == true) return false;
                let $groupList = $('#group_list');
                let scrollTop = $groupList.scrollTop();
                let scrollHeight = $groupList[0].scrollHeight;
                if (scrollTop + $groupList.height() >= scrollHeight) {
                    if (!isLoading) return false;
                    eikon.getMessengerList(groupMessagePage + 1);
                    isLoading = false;
                }
            });
            initDateTimePicker('startDt','endDt');
            initDateTimePicker('startSubDt','endSubDt');



            $($('.condition_top')).click(function(){
                $('.chatList').animate({
                    scrollTop: 0
                }, 200);
            });

            window.addEventListener('scroll', function(){
                console.log('123')
            });

            $(window).resize(function () {
                if ($(window).width() < 1700) {
                    $('#searchResultBtnArea').addClass('btnCustomPosition');
                } else {
                    $('#searchResultBtnArea').removeClass('btnCustomPosition');
                }
            });

            $('#showBtn').click(function () {

                var displayValue = $('#xcn_Search2').css('display');

                if(displayValue=="block"){
                    $('#xcn_Search2').css('display', 'none');
                }else{
                    $('#xcn_Search2').css('display', 'block');
                }

            });

            $(document).on('click', '.person', function (){
                var xrootmtr = $(this).attr('xrootmtr');
                var srcip = $(this).attr('srcip');
                var usr_id = $(this).attr('usr_id');
                var userid = $(this).attr('userid');
                var msgid = $(this).attr('msgid');
                var username = $(this).attr('name');

                $('.person').each(function () {
                    $(this).removeClass('active');
                });

                $(this).addClass('active');
                $('#msgid').text(msgid);
                $('#xrootmtr').text(xrootmtr);

                $('#subchatid').html(": " + name);
                $('#srcip').text(srcip);
                $('#usr_id').text(usr_id);
                eikon.getMessengerDetailList(xrootmtr, msgid, null, null);
                hideUserSelect();
            });


            $('#searchBtn').click(function () {
                $('#group_list').scrollTop(0);
                isEnd = false;
                isContextEnd = false;
                if (messengerListCnt == 0) {
                    ui.alertMsg('<s:message code="eikon.noList"/>');
                    return;
                }
                var startDt = $('#startDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '');
                var endDt = $('#endDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '');
                if (startDt == '') {
                    ui.alertMsg('<s:message code="message.message.startdt.input"/>');
                    return;
                }
                if (endDt == '') {
                    ui.alertMsg('<s:message code="message.message.enddt.input"/>');
                    return;
                }
                if (startDt > endDt) {
                    ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
                    return;
                }
                <%--if (getDayInterval(startDt, endDt) > 31) {--%>
                <%--    ui.alertMsg('<s:message code="eikon.msg.select.date"/>');--%>
                <%--    return;--%>
                <%--}--%>
	            setcurrentSchVal();
                eikon.getMessengerList(1);
            });
            $("#searchStrInput").keypress(function (e) {
                if (e.keyCode == 13) $('#searchBtn').click();
            }); //통합 검색 엔터키

            $('#searchMsgBtn').click(function () {
                if ($('#searchMsgStrInput').val() == "") $('#searchMsgQueryBtn').click();
                else eikon.findMessageList(0);
            });
            $('#searchMsgQueryBtn').click(function () {
                var selectedUsrId = $('#selectUserInfo').attr('data-name');
                getDetailData(selectedUsrId);
            });
            $("#searchMsgStrInput").keypress(function (e) {
                if (e.keyCode == 13) {
                    if ($('#searchMsgStrInput').val() == "") $('#searchMsgQueryBtn').click();
                    else $('#searchMsgBtn').click();
                }
            });

            $('#searchMsgUp').click(function () {
                eikon.findMessageList(--searchOffset);
// 		checkList(--searchOffset);
            });
            $('#searchMsgDn').click(function () {
// 		checkList(++searchOffset);
                eikon.findMessageList(++searchOffset);
            });
            $('#listCntArea').click(function () {
                //if( $('#messageTotalCnt').html() == 0 || $('#messageTotalCnt').html() == '') return;
                openSelectDiv();
            });
            $('#userCntArea').click(function () {
                if ($('#selectUserInfo').html() == '-') return;
                openSelectUserDiv();
            });

            $('#dept').click(function () {
                var code = $(this).attr('id');
                openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
            });

            $(document).on('click', '.me', function (e) {
                var xrootmtr = $(this).parent().attr('xrootmtr');
                var srcip = $(this).parent().attr('userid');
                var id = $(this).parent().attr('id');
                // updateEmassMessengerAdminXrootMtr(xrootmtr, id, srcip);

                // moveTargetHeight(id, false);
            });

            $(document).on('click', '.you', function (e) {
                var xrootmtr = $(this).parent().attr('xrootmtr');
                var srcip = $(this).parent().attr('userid');
                var id = $(this).parent().attr('id');
                // updateEmassMessengerAdminXrootMtr(xrootmtr, id, srcip);

                // moveTargetHeight(id, false);
            });

            $(document).on('click', '.downAllFile', function () {
                var downloadFlag = false;
                $('.downloadIcon').each(function (i, item) {
                    var attachHash = $(this).parents('p').attr('attachhash');
                    if (attachHash != '') {
                        downloadFlag = true;
                    }
                });
                if (!downloadFlag) {
                    alert('<s:message code="message.message.notfound.attach"/>');
                    return;
                }

                var msgIds = [];
                $('.downloadIcon').each(function (i, item) {
                    var msgId = $(this).parents('p').attr('msgid');
                    msgIds.push(msgId);
                });

                var attachUrl = '<c:url value="/getEmassAttachInfo4DownHash.xcn"/>?msgIds=' + msgIds.join(',');
                try {
                    AttachDown.location.href = attachUrl;
                } catch (e) {
                    AttachDown.src = attachUrl;
                }
            });

            $(document).on('click', '.filesdown', function () {
                var msgId = $(this).parents('p').attr('msgid');
                var attachHash = $(this).parents('p').attr('attachhash');
                var attachId = $(this).parents('p').attr('id');
                var attachSize = Number($(this).parents('p').attr('attachsize'));
                var attachUrl = '<c:url value="/getEmassAttachInfo4DownHash.xcn"/>?msgIds=' + msgId + '&attachHash=' + attachHash;


                if (attachHash == '') {
                    alert('<s:message code="message.message.notfound.attach"/>');
                    return;
                }

                if (attachSize == 0 || attachSize == 'NaN') attachSize = 1;

                try {
                    AttachDown.location.href = attachUrl;
                } catch (e) {
                    AttachDown.src = attachUrl;
                }
            });

            $(document).on('click', '.downloadIcon', function () {
                var msgId = $(this).parents('p').attr('msgid');
                var attachHash = $(this).parents('p').attr('attachhash');
                var attachId = $(this).parents('p').attr('id');
                var attachSize = Number($(this).parents('p').attr('attachsize'));
                var attachUrl = '<c:url value="/getEmassAttachInfo4DownHash.xcn"/>?msgIds=' + msgId + '&attachHash=' + attachHash;


                if (attachHash == '') {
                    alert('<s:message code="message.message.notfound.attach"/>');
                    return;
                }

                if (attachSize == 0 || attachSize == 'NaN') attachSize = 1;

                try {
                    AttachDown.location.href = attachUrl;
                } catch (e) {
                    AttachDown.src = attachUrl;
                }
            });

            $(document).on('click', '.selectUser', function () {
                console.log("selectUser")
                var name = $(this).attr('data-name');
                var srcip = $(this).attr('data-srcip');
                var usr_id = $(this).attr('data-usrid');
                var xrootmtr = $('#xrootmtr').text();
                var msgid = $('#msgid').text();


                $('#selectUserInfo').attr('data-srcip', srcip);
                $('#selectUserInfo').attr('data-name', name);
                $('#selectUserInfo').attr('data-usrid', usr_id);

                $('#selectUserInfo').html($(this).text());
                $('#srcip').text(srcip);
                $('#usr_id').text(usr_id);
                eikon.getMessengerGroupDetail(xrootmtr, msgid, srcip, usr_id);
                hideUserSelect();
            });


            $(document).on('click', '.downAllFile', function () {
                var downloadFlag = false;
                $('.downloadIcon').each(function (i, item) {
                    var attachHash = $(this).parents('p').attr('attachhash');
                    if (attachHash != '') {
                        downloadFlag = true;
                    }
                });
                if (!downloadFlag) {
                    alert('<s:message code="message.message.notfound.attach"/>');
                    return;
                }

                var msgIds = [];
                $('.downloadIcon').each(function (i, item) {
                    var msgId = $(this).parents('p').attr('msgid');
                    msgIds.push(msgId);
                });

                var attachUrl = '<c:url value="/downEmassAttachByMsgId.xcn"/>?msgIds=' + msgIds;
                try {
                    AttachDown.location.href = attachUrl;
                } catch (e) {
                    AttachDown.src = attachUrl;
                }
            });


            $('.txt_down').click(function () {
                downloadList('txt');
                hideSelect();
            });
            $('.excel_down').click(function () {
                downloadList('xlsx');
                hideSelect();
            });
            $('.html_down').click(function () {
                downloadList('html');
                hideSelect();
            });
            $('.excel_file_down').click(function () {
                var xRootMtr = $('#xrootmtr').text();
                var srcip = $('#srcip').text();
                var usr_id = $('#selectUserInfo').attr('data-name');
                var startDt = $('#startSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '') + "0000000";
                var endDt = $('#endSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '') + "235959";
                var searchStr = '';
                if (xrootmtr == '') return;
                eikon.getMessengerGroupAllExport('<c:url value="/getMessengerGroupAllExport.xcn"/>?xRootMtr=' + xRootMtr  + '&startDt=' + startDt + '&endDt=' + endDt + '&searchStr=' + searchStr + '&limit=1000&facet_detail=true&export=true');
                hideSelect();
            });

            $(document).on('mouseover', '#deptSelectedArea', function (e) {
                $('#selectedCodeTitle').show();
                $('#selectedCodeTitle').css('left', (e.pageX + 5) + 'px');
                $('#selectedCodeTitle').css('top', (e.pageY - 150) + 'px');

                var str = $(this).parent().find('.selectedTitle').val();
                if (str != undefined) str = str.replaceAll('\\|', ',');
                $('#selectedCodeTitle').html(str);
            });

            $(document).on('mousemove', '#deptSelectedArea', function (e) {
                $('#selectedCodeTitle').css('left', (e.pageX + 5) + 'px');
                $('#selectedCodeTitle').css('top', (e.pageY - 120) + 'px');

                var str = $(this).parent().find('.selectedTitle').val();
                if (str != undefined) str = str.replaceAll('\\|', ',');
                $('#selectedCodeTitle').html(str);
            });

            $(document).on('mouseout', '#deptSelectedArea', function (e) {
                $('#selectedCodeTitle').hide();
            });

            $(document).on('mouseover', '#userSelectedArea', function (e) {
                $('#selectedCodeTitle2').show();
                $('#selectedCodeTitle2').css('left', (e.pageX + 5) + 'px');
                $('#selectedCodeTitle2').css('top', (e.pageY - 150) + 'px');

                var str = $(this).parent().find('.selectedTitle').val();
                if (str != undefined) str = str.replaceAll('\\|', ',');
                $('#selectedCodeTitle2').html(str);
            });

            $(document).on('mousemove', '#userSelectedArea', function (e) {
                $('#selectedCodeTitle2').css('left', (e.pageX + 5) + 'px');
                $('#selectedCodeTitle2').css('top', (e.pageY - 150) + 'px');

                var str = $(this).parent().find('.selectedTitle').val();
                if (str != undefined) str = str.replaceAll('\\|', ',');
                $('#selectedCodeTitle2').html(str);
            });

            $(document).on('mouseout', '#userSelectedArea', function (e) {
                $('#selectedCodeTitle2').hide();
            });


            $(document).on('click', '#userSelectedArea', function (e) {
                $('#userVal, #userStr, #userDept, #userJib').val('');
                $('#userSelectedArea').hide();
            });

            $('#user').click(function () {
                var code = $(this).attr('id');
                openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val(), $('#' + code + 'Dept').val(), $('#' + code + 'Jib').val());
            });
            $(document).on('click', '#deptSelectedArea', function (e) {
                $('#deptVal, #deptStr').val('');
                $('#deptSelectedArea').hide();
            });

            $(document).on('click', '#userSelectedArea', function (e) {
                $('#userStr, #userVal').val('');
                $('#userSelectedArea').hide();
            });

            $(document).on('click', '#timeline_list div.list-group-item', function (e) {
                var xrootmtr = $('#xrootmtr').text();
                var srcip = $('#srcip').text();
                var usr_id = $('#usr_id').text();

                var id = $(this).parent().parent().attr('id');
                updateEmassMessengerAdminXrootMtr(xrootmtr, id, srcip, usr_id);

                moveTargetHeight(id, false);
            });

            /*      $(document).on('click', '#group_list a', function () {
					  if ((isConsent() && $('#consentNo').val() == '') || $(this).attr('xrootmtr') == '') {
						  return;
					  }

					  //if($(this).hasClass('active')) return;
					  $('#group_list a').each(function () {
						  $(this).removeClass('active');
					  });

					  $(this).addClass('active');
					  $('#xrootmtr').text($(this).attr('xrootmtr'));

					  $('#srcip').text($(this).attr('srcip'));
					  $('#msgid').text($(this).attr('msgid'));
					  $('#usrid').text($(this).attr('usrid'));

					  $('#selectUserInfo').attr('data-name', '');
					  $('#selectUserInfo').attr('data-srcip', '');
					  $('#selectUserInfo').attr('data-usrid', '');
					  $('#selectUserInfo').attr('data-account', '');
					  $('#selectUserInfo').html('');
					  $('#searchMsgStrInput').val('');
					  $('#startSubDt').val($('#startDt').val());
					  $('#endSubDt').val($('#endDt').val());
					  focusMsgId = '';
					  eikon.getMessengerDetailList($(this).attr('xrootmtr'), $(this).attr('msgid'), $(this).attr('srcip'), $(this).attr('usrid'));
				  });*/


            $('button[name="searchType"]').click(function () {
                $('#group_list').scrollTop(0);
                isEnd=false;
                isContextEnd=false;
                $(this).attr('class', 'active');
                $('button[name="searchType"]').not(this).attr('class', 'tablinks');
	            setcurrentSchVal();
                eikon.getMessengerList(1)
            });
            $('#groupFileCnt').click(function () {
                fileInfoViewer($('#xrootmtr').text(), $('#srcip').text(), $('#usr_id').text());
            });

            $('#groupParticipant').click(function () {
                participantInfoViewer($('#xrootmtr').text(), $('#usr_id').text());
            });

            $(document).on('click', '.file_link', function () {
                var msgId = $(this).attr('msgid');
                var attachHash = $(this).attr('attachhash');
                var attachName = $(this).text();

                var attachUrl = '<c:url value="/getEmassAttachInfo4DownHash.xcn"/>?msgIds=' + msgId + '&attachHash=' + attachHash;

                if (attachHash == '') {
                    alert('<s:message code="message.message.notfound.attach"/>');
                    return;
                }
                try {
                    AttachDown.location.href = attachUrl;
                } catch (e) {
                    AttachDown.src = attachUrl;
                }
            });

            /*            $(document).on('click', '#group_list a', function () {
							var name = $(this).attr('data-name');
							var srcip = $(this).attr('data-srcip');
							var usr_id = $(this).attr('data-usrid');
							var svc12Value = $(this).attr('svc12');
							var xrootmtr = $('#xrootmtr').text();
							var  msgid= $(this).attr('msgid');
							$('#selectUserInfo').attr('data-srcip', srcip);
							$('#selectUserInfo').attr('data-name', name);
							$('#selectUserInfo').attr('data-usrid', usr_id);
							getMessengerAccount(userid,svc12Value);

							$('#selectUserInfo').html($(this).text());
							$('#srcip').text(srcip);
							$('#usr_id').text(usr_id);
							eikon.getMessengerGroupDetail(xrootmtr, msgid, srcip, usr_id);
							hideUserSelect();
						});*/

            initCondition();
            eikon.init();

        });
        function openCodeWindow(id, oldCode, oldConm,oldDept,oldJib) {
            $('#oldCode').val(oldCode);
            $('#oldConm').val(oldConm);
            $('#oldDept').val(oldDept);
            $('#oldJib').val(oldJib);

            var url = '<c:url value="/commons/selectCode.do?codeType='+id+'"/>';
            var pop = fnOpenWindow('', 'selectCodeWinPopup', 1200, 700, 'resize');

            $('#codeParam').attr('target', 'selectCodeWinPopup');
            $('#codeParam').attr('action', url);
            $('#codeParam').attr('method', 'post');
            $('#codeParam').submit();
        }

        function openSelectUserDiv() {
            var status = $('#userCntArea').hasClass('clicked');
            if (status) {
                hideUserSelect();
            } else {
                showUserSelect();
            }
        }


        function initDateTimePicker(sid,eid){
            $('#'+sid).datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
	            showClose: true,
	            showTodayButton: true,
                defaultDate: moment().subtract(7, 'days')
            });
            $('#'+eid).datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
	            showClose: true,
	            showTodayButton: true,
                defaultDate: moment(new Date())
            });
        }

        function hideUserSelect() {
            if ($('#selectUser_menu')) {
                $('#selectUser_menu').hide();
                $('#userCntArea').removeClass('clicked');
            }
            $(document).unbind("mousedown", onBodyMouseDownPeriodUser);
        }

        function showUserSelect() {
            $('#selectUser_menu').show();
            $('#userCntArea').addClass('clicked');
            $(document).bind("mousedown", onBodyMouseDownPeriodUser);
        }

        function onBodyMouseDownPeriodUser(event) {
            if (!(event.target.id == "selectUser_menu" || $(event.target).parents("#selectUser_menu").length > 0)) {
                hideUserSelect();
            }
        }

        function openSelectDiv() {
            var status = $('#listCntArea').hasClass('clicked');
            if (status) {
                hideSelect();
            } else {
                showSelect();
            }
        }

        function hideSelect() {
            if ($('#export_menu')) {
                $('#export_menu').hide();
                $('#listCntArea').removeClass('clicked');
            }
            $(document).unbind("mousedown", onBodyMouseDownPeriod);
        }

        function showSelect() {
            $('#export_menu').show();
            $('#listCntArea').addClass('clicked');
            $(document).bind("mousedown", onBodyMouseDownPeriod);
        }

        function onBodyMouseDownPeriod(event) {
            if (!(event.target.id == "export_menu" || $(event.target).parents("#export_menu").length > 0)) {
                hideSelect();
            }
        }


        function downloadList(type) {
            var xRootMtr = $('#xrootmtr').text();
            //var srcip = $('#selectUserInfo').attr('data-srcip');
            // var srcip = null;
            var usr_id = $('#selectUserInfo').attr('data-usrid');

            if (xRootMtr == null || xRootMtr === '') {
                ui.alertMsg(nodataMsg);
                return;
            }
            var startDt = $('#startSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '')+"000000";
            var endDt = $('#endSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '')+"235959";
            var searchStr = '';
            eikon.getMessengerGroupTextExport('<c:url value="/getMessengerGroupTextExport.xcn"/>?xRootMtr=' + xRootMtr +'&usr_id='+usr_id+ '&startDt=' + startDt + '&endDt=' + endDt + '&searchStr=' + searchStr + '&type=' + type + '&limit=1000', xRootMtr);
        }

        function searchConsentNo() {
            var url = '<c:url value="/ems/selectConsent.do"/>';
            return fnOpenWindow(url, 'selectConsentWinPopup', 830, 700, 'resize');
        }

        function selectedConsent(obj) {
            if (obj == '') {
                $('#consentNo').val('');
                $('#consentName').text('');
                $('#consentUserId').val('');
                $('#consentBtn').removeClass('active');
            } else {
                $('#consentNo').val(obj.no);
                $('#consentName').text(obj.name + "[" + obj.userId + ", " + (obj.deptNm == '' ? '<s:message code="consent.select.consentDept"/>' : obj.deptNm) + "]");
                $('#consentUserId').val(obj.userId);
                $('#consentBtn').addClass('active');
            }
        }

        function initCondition() {
            getMessengerList();
            getCodeList('busi');
            getCodeList('dept');

            var dateObj = new Date();

            $("#xcn_Search2").css("display", "none");


            $('#easyDate').change(function () {
                changeDate($(this).val());
            });

            $('#serviceTypeSelect').selectpicker({
                // container: 'body',
                size: 15,
                width: '300px',
                noneSelectedText: condition.serviceAll,
                noneResultsText: condition.msgNoresult + ' ',
                selectAllText: condition.msgSelect_all,
                deselectAllText: condition.msgUnselect_all,
                liveSearchPlaceholder: condition.searchService
            });

            $('#busiSelect').selectpicker({
                // container: 'body',
                size: 15,
                width: '300px',
                searchLabel: true,
                noneSelectedText: '<s:message code="common.org.busi.all"/>',
                noneResultsText: '<s:message code="common.msg.noresult"/>' + ' ',
                selectAllText: '<s:message code="common.msg.select_all"/>',
                deselectAllText: '<s:message code="common.msg.unselect_all"/>'
            });
            /* $('#deptSelect').selectpicker({
				container:'body',
				size: 15,
				width:'222px',
				searchLabel:true,
				noneSelectedText:'

            <s:message code="common.org.dept.all"/>',
		noneResultsText:'

            <s:message code="common.msg.noresult"/>'+' ',
		selectAllText:'

            <s:message code="common.msg.select_all"/>',
		deselectAllText:'

            <s:message code="common.msg.unselect_all"/>'
	}); */

            $('#searchField').selectpicker({
                container: 'body',
                width: '100px',
                noneSelectedText: '<s:message code="common.msg.all"/>'
            });

            $('button[name="attachYn"]').click(function () {
                $(this).addClass('active');
                $('button[name="attachYn"]').not(this).removeClass('active')
                var attachYnValue = $(this).attr('value');

                if (attachYnValue === '') {
                    $("#searchField option:eq(1)").prop('disabled', false);
                } else {
                    $("#searchField option:eq(1)").prop('disabled', true);
                }

                $('#searchField').selectpicker('refresh');

            });

        }

        function getCodeList(codeType) {
            ui.get({
                url: 'getCodeList.xcn',
                codeType: codeType,
                success: function (data, total) {
                    $('#' + codeType + 'Select').html(getSelectOption(data));
                    $('#' + codeType + 'Select').selectpicker('refresh');
                    $('#' + codeType + 'SelectPop').html(getSelectOption(data));
                    $('#' + codeType + 'SelectPop').selectpicker('refresh');
                },
                error: function (status, message) {
                    ui.alertMsg('error:' + status);
                },
                complete: function () {
                    searchFlag = false;
                }
            });
        }

        function getSelectOption(data) {
            var str = '';
            for (var i = 0; i < data.length; i++) {
                str += '<option value="' + data[i].code + '">' + data[i].codeName + '</option>';
            }
            return str;
        }


        function getCondition() {
            var filterVal = {};

            if (isConsent()) {
                filterVal.consentNo = $('#consentNo').val();
                filterVal.consentName = $('#consentName').text();
                //filterVal.consentIp = $('#consentIp').val();
                //filterVal.consentEmail = $('#consentEmail').val();
                filterVal.consentUserId = $('#consentUserId').val();
            }

            var conArray = [];
            conArray.push(createCondition());
            filterVal.conditions = conArray;

            //console.log(JSON.stringify(filterVal))
            return filterVal;
        }

        function createCondition() {
            var allSelect = new Array();
            var condition = {};
            if ($('#serviceTypeSelect').selectpicker('val') == null) {
                $('#serviceTypeSelect option').each(function () {
                    if ($(this).val() != '' && $(this).val() != null) allSelect.push($(this).val());
                });
                condition.serviceType = arrayToString(allSelect);
            } else {
                condition.serviceType = arrayToString($('#serviceTypeSelect').selectpicker('val'));
            }
            condition.searchStr = $('#searchStrInput').val();
            // condition.senders = $('#senders').val();

            var dv = $('#userEmail').val().split('|');
            condition.senders = dv.join(' ');
            if (condition.senders != '') condition.sendersStr = $('#userStr').val();

            condition.attachYn = $('button[name=attachYn].active').val();
            condition.busi = arrayToString($('#busiSelect').selectpicker('val'));

            if (condition.busi != '') condition.busiStr = $('#busiSelect').parent().find('.filter-option').text();
            else condition.busiStr = '';

            var dv = $('#deptVal').val().split('|');
            condition.dept = dv.join(',');
            if (condition.dept != '') condition.deptStr = $('#deptStr').val();
            else condition.deptStr = '';
            /* condition.dept = arrayToString($('#deptSelect').selectpicker('val'));
			if(condition.dept != '') condition.deptStr = $('#deptSelect').parent().find('.filter-option').text();
			else condition.deptStr = ''; */
            // condition.searchField = 'body_snippet attachname attachname_str attach';
            condition.period = 1;
            condition.startDt =$('#startDt').val()+"000000";
            condition.endDt =$('#endDt').val()+"235959";

            return condition;
        }

        function arrayToString(array) {
            if (array == null || array == undefined) return "";
            else {
                return array.toString();
            }
        }

        function stringToArray(string) {
            if (string == null || string == undefined || string == '') return '';
            else if (typeof string != 'string') return string;
            else {
                return string.split(',');
            }
        }

        function fileInfoViewer(xrootmtr, srcip, usr_id) {
            var startDt = $('#startSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '');
            var endDt = $('#endSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '');
            var searchStr = '';

            var url = '<c:url value="/ems/participantFileInfoPop.do?xrootmtr='+xrootmtr+'&srcip='+srcip+'&usr_id='+usr_id+'&startDt='+startDt+'&endDt='+endDt+'&searchStr='+encodeURI(searchStr)+'"/>';
            var pop = fnOpenWindow(url, 'fileInfoPop', 1000, 400, 'resize');
        }

        function participantInfoViewer(xrootmtr, usr_id) {
            var srcip = $('#srcip').text();
            var startDt = $('#startSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '');
            var endDt = $('#endSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '');
            var searchStr = '';

            var url = '<c:url value="/ems/participantInfoPop.do?xrootmtr='+xrootmtr+'&srcip='+srcip+'&usr_id='+usr_id+'&startDt='+startDt+'&endDt='+endDt+'&searchStr='+searchStr+'"/>';
            var pop = fnOpenWindow(url, 'participant', 1015, 450, 'resize');
        }

        function getParticipantFileList() {
            var xrootmtr = $('#xrootmtr').text();
            ui.get({
                url: 'getMessengerGroupAttachList.xcn',
                xRootMtr: xrootmtr,
                success: function (data, total) {
                    alert(JSON.stringify(data));
                    //getFileList(data);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {

                }
            });
        }

        function getMessengerList() {
            ui.get({
                url: 'getMessengerList.xcn',
                asyncFlag: false,
                success: function (data, total) {
                    messengerListCnt = data.length;
                    if (data.length > 0) {
                        $('#serviceTypeSelect').html(getSelectOptionMessenger(data));
                    }
                },
                error: function (status, message) {
                    ui.alertMsg('error:' + status);
                },
                complete: function () {
                    searchFlag = false;
                }
            });
        }

        function getSelectOptionMessenger(data) {
            //var str = '<option value="">- <s:message code="eikon.msg.svcType"/> -</option>';
            var str = '';
            for (var i = 0; i < data.length; i++) {
				if (data[i].code.startsWith('EME')) str += '<option value="'+data[i].code+'">'+data[i].tempNm1+'</option>';
				else str += '<option value="'+data[i].code+'">'+data[i].codeName+'</option>';
            }
            return str;
        }



        function getSelectedCodeData(codeType, data) {
            var str = '';
            var val = '';
            var dept = '';
            var jib = '';
            var email = '';

            for (var i = 0; i < data.length; i++) {
                str += data[i].codeName;
                val += data[i].code;
                email += data[i].email;

                dept += (data[i].tempNm1 !== undefined) ? data[i].tempNm1 : "";

                jib += (data[i].tempNm2 !== undefined) ? data[i].tempNm2 : "";

                if (i != data.length - 1) {
                    str += ', ';
                    val += '|';
                    dept += '|';
                    jib += '|';
                    email += '|';
                }
            }
            if (val != '') {
                str = str.rtrim();
                val = val.trimAll();
                dept = dept.trimAll();
                jib = jib.trimAll();
                email = email.trimAll();
            }

            $('#' + codeType + 'Str').val(str);
            $('#' + codeType + 'Val').val(val);
            $('#' + codeType + 'Dept').val(dept);
            $('#' + codeType + 'Jib').val(jib);
            $('#' + codeType + 'Email').val(email);


            if ($('#' + codeType + 'Str').val() != '') {
                $('#' + codeType + 'SelectedArea').find('.btn').text(data.length);
                $('#' + codeType + 'SelectedArea').show();
            } else {
                $('#' + codeType + 'SelectedArea').find('.btn').text(0);
                $('#' + codeType + 'SelectedArea').hide();
            }
        }

        function resetCode(codeType) {
            if (codeType == 'deptByCo') $('#deptByCoStrSpan').html('');
            $('#' + codeType + 'Val').val('');
            $('#' + codeType + 'Str').val('');
            $('#' + codeType + 'Dept').val('');
            $('#' + codeType + 'Jib').val('');
            $('#' + codeType + 'SelectedArea').hide();
        }

        function allDown(){

            if ((isConsent() && $('#consentNo').val() == '') || $(this).attr('userkey') == '') {
                return;
            }
            var element = document.getElementById('groupResultCnt');
            var number = parseInt(element.textContent, 10);
            if (number === 0) {
                ui.alertMsg('<s:message code="eikon.noList"/>');
                return;
            }

            var filterVal = {};
            var conArray = [];
            conArray.push(currentSchVal);
            filterVal.conditions = conArray;

            ui.alertMsg('<s:message code="eikon.start.download"/>');
            ui.get({
                url : 'getMessengerGroupTextAllExportZip.xcn',
                data : JSON.stringify(filterVal),
                exportStartDt : currentSchVal.startDt,
                exportEndDt : currentSchVal.endDt,
                success : function(data, total) {
                },
                error : function(status, message) {
                },
                complete : function() {
                }
            });
        }
        function allDownList(){
            var url    = '<c:url value="/commons/downListMessenger.do"/>';
            fnOpenWindow(url, 'downInfoPop', 1400, 580, 'resize');
        }

	</script>
</head>
<div id="searchArea">
	<div class="inner_messenger">
		<%--			검색 영역--%>
		<div class="leftSearch p20"  id="xcn_Search">
			<div class="leftSearchTab mat8">
				<button class="active" onclick="openCity('Tab01')"><s:message code="DATA_MONITOR.MESSAGE_SERVICE"/></button>
				<!--<button onclick="openCity('Tab02')">탭 비활성</button>-->
			</div>
			<div id="Tab01">
				<div>
					<h3 class="mat16"><s:message code="message.msg.default.search"/></h3>
					<%if (consent && Common.isEquals(firstAdminYn, "N") && Common.isNotEquals(adminType, "C")) { %>
					<div class="form-group form-inline not-dashed" style="padding-left: 10px; width: 100%; margin-bottom: 3px;">
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="consentBtn" onclick="searchConsentNo();"><span
								class="glyphicon glyphicon-tags"></span>&nbsp;<s:message code="consent.select.consent"/></button>
						<input type="text" style="width:120px;height:28px;display:none;" readonly="readonly" id="consentNo">
						<input type="hidden" readonly="readonly" id="consentIp">
						<input type="hidden" readonly="readonly" id="consentEmail">
						<input type="hidden" readonly="readonly" id="consentUserId">
						<span id="consentName" style="font-weight: bold;"></span>
					</div>
					<%} %>
					<div>
						<select class="w100" id="serviceTypeSelect" data-style="btn-default" multiple data-show-subtext="true"
						        data-actions-box="true">
						</select>
						<input class="w100 mat8" type="text" id="searchStrInput" placeholder="<s:message code="common.msg.searchMsg"/>">
					</div>
					<h3 class="mat16"><s:message code="message.msg.deepsearch"/></h3>
					<div>
						<div style="display: flex;">
							<input type="text" id="startDt" class="txt_center"  style="width: 140px;">
							<span class="w10 dis_inlineblock txt_center">~</span>
							<input type="text" id="endDt"  class="txt_center"  style="width: 140px;"></div>

						<div class="optiotab w100 mat8">
							<button class="active w50" name="attachYn" id="attachAll" value=""><s:message code="condition.isattached.all"/></button>
							<button class="w50" name="attachYn" id="attachY" value="Y"><s:message code="eikon.attach.exist"/></button>
						</div>

						<select id="busiSelect" class="w100 mat8" data-style="btn-default btn-sm" multiple data-show-subtext="true"
						        data-live-search="true" data-actions-box="true"></select>

						<p class="mat8 formText btnform" data-toggle="buttons">
							<span class="tit"><s:message code="common.org.dept"/></span>
							<button type="button" class="btn01" id="dept"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
									code="common.org.choose.dept"/></button>
							<span id="deptSelectedArea" class="codeSelectedBtn">
										<button type="button" class="btn num_add bornone" style="z-index: 2;">0</button>
									</span>
							<input type="hidden" id="deptStr" class="selectedTitle">
							<input type="hidden" id="deptVal">
						</p>
						<div id="selectedCodeTitle" class="infotxt"></div>
						<p class="mat8 formText btnform" data-toggle="buttons">
							<span class="tit"><s:message code="common.org.user"/></span>
							<button type="button" class="btn01" id="user"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
									code="common.org.choose.user"/></button>
							<span id="userSelectedArea" class="codeSelectedBtn">
										<button type="button" class="btn num_add bornone" style="z-index: 2;">0</button>
									</span>
							<input type="hidden" id="userStr" class="selectedTitle">
							<input type="hidden" id="userVal">
							<input type="hidden" id="userEmail">
							<input type="hidden" id="userDept">
							<input type="hidden" id="userJib">
						</p>
						<div id="selectedCodeTitle2" class="infotxt"></div>
						<%--						<input type="text" class="w100 mat8"  placeholder="<s:message code="eikon.input.participation"/>" id="senders">--%>
					</div>
				</div>

				<div class="fixBtn">
					<div class="xcn_checkbox">
						<input type="checkbox" name="readYn" id="readYn"><s:message code="eikon.msg.notRead"/>
					</div>
					<button class="fullbtn" type="button" accesskey="Q" id="searchBtn"><s:message code="common.search"/></button>
				</div>
			</div>
		</div>
		<%--			검색 끝!--%>
		<%--			검색 결과 영역--%>
		<div class="messengerList">
			<div class="messengerBox"  style="height: 90% !important;">
				<div class="subTit p12">
					<h2 class="ma_none pb4">
						<button id="xcn_toggleBtn" class="menu"></button><s:message code="DATA_MONITOR.MESSAGE_SERVICE"/>
					</h2>
				</div>
				<div class="bortop_dd  borbottom_dd pt16">
					<div class="subtab pl20 pr20">
						<button class="active" name="searchType" value="G" id="G"><s:message code="eikon.msg.chats"/></button>
						<button class="tablinks" name="searchType" value="GD" id="GD"><s:message code="eikon.msg.chatContents"/></button>
					</div>
				</div>
				<div style="height: 100%">
				<div class="list-group" id="group_list" style="margin-bottom: 0px; margin-top:20px;height: 80%!important; overflow: scroll">
					<a href="#" class="list-group-item list-group-item-action active" style="cursor:default; padding:40px; margin:0 20px;">
						<p class="list-group-item-text" style="line-height:30px; text-align: center">
							<img src="<c:url value="/img/icon/img_nodata02.png"/>" width="72" height="72">
						</p>
						<p style="text-align: center">
							<s:message code="eikon.msg.select.condition"/>
						</p>
					</a>
				</div>
				</div>
			</div>
			<%--					페이징--%>
			<!-- pagination -->
			<div class="pl20 pr20">
				<div class="pageArea bornone" id="groupPage">
					<div class="total fb600">
					</div>
				</div>
				<s:message code="common.msg.finish_query"/> : <span id="groupResultCnt" class="red fb600">0</span>
				<div class="myDropdown mal16" style="color: black">
					<span><s:message code="analysis.relation.ui.export"/></span>
					<div class="dropdown-content" style="bottom:100%; min-width: 203px !important;">
						<a href="#" onclick="allDown()"><s:message code="analysis.relation.ui.export2"/></a>
						<a href="#" onclick="allDownList()"><s:message code="common.msg.download"/> <s:message code="mail.view.list"/></a>
					</div>
				</div>
			</div>
			<!-- //pagination -->
			<%--					<div style="height:30px;padding-left:32%; margin-top: 15px;" id="groupPage"></div>--%>
		</div>

		<!-- 대화방 끝!! -->
		<!-- 채팅 -->
		<div class="chatList">
			<div class="chatBox">
				<div class="top">
					<%--					내보내기--%>
					<div class="myDropdown mal16">
						<span><s:message code="analysis.relation.ui.export"/> &#9662;</span>
						<div class="dropdown-content">
							<a href="#" class="excel_down"><s:message code="common.msg.excel"/></a>
							<a href="#" class="txt_down"><s:message code="common.msg.text"/></a>
							<a href="#" class="html_down"><s:message code="eikon.msg.html"/></a>
							<a href="#" class="excel_file_down"><s:message code="common.msg.excel"/>+<s:message code="consent.attach"/></a>
						</div>
					</div>

					<div style="display: flex;">
						<div style=" min-width: 150px; box-sizing: border-box; width: 100%" >
								<span><s:message code="condition.xrootmtr"/>: <span class="chatid"><span id="xrootmtr"></span><span id="srcip" style="display:none;"></span><span
										id="usr_id" style="display:none;"></span><span id="msgid" style="display:none;"></span></span></span>
						</div>

						<div  style=" min-width: 150px; box-sizing: border-box; width: 100%; position: relative;">
							<span> <s:message code="condition.user"/> : </span>
							<span title="<s:message code="condition.user"/>" id="userCntArea">
								<span>
									<span id="selectUserInfo" data-srcip="" data-name="" data-usrid="">-</span>
									<span class="bs-caret"><span class="caret"></span></span>
								</span>
							</span>
							<ul class="dropdown-menu" role="menu" style="min-width: 150px; position: absolute; left: 0; top: 100%;"
							    id="selectUser_menu"></ul>
						</div>
					</div>

					<div class="chatDate">
						<div class="searchSub" style=" min-width: 150px; box-sizing: border-box; width: 100%" >

							<input type="text" id="startSubDt" class="txt_center" style="width: 110px;">
							<span class="hyphen">~</span>
							<input type="text" id="endSubDt" class="txt_center"  style="width: 110px;">
							<button class="form_btn01" type="button" accesskey="M" id="searchMsgQueryBtn"><s:message code="common.search"/></button>
						</div>

						<div class="searchSub txt_right" style=" min-width: 150px; box-sizing: border-box; width: 100%" >
							<input type="text" class="w70" placeholder="<s:message code="condition.research"/>" id="searchMsgStrInput">
							<button class="form_btn01 blackBg" type="button" accesskey="M" id="searchMsgBtn"><s:message code="common.search"/></button>
						</div>
					</div>
				</div>

				<%--					채팅 검색 부분 끝!--%>

				<%--					채팅 본문 내용 보이는 구간 시작  -> ***** 아직 안함 --%>
				<div>
					<div class="form-group form-inline">
						<div class="input-group date" id="timedatepicker" style="margin-left: 5px;display:none;">
							<input type="text" id="timeDt" class="input-sm form-control border-radius-none" style="display:none;"/>
							<span class="input-group-addon startDateBtn border-radius-none">
									<span class="glyphicon glyphicon-calendar"></span>
								</span>
						</div>
						<div class="input-group" id="searchResultArea"
						     style="height:30px;line-height:30px;vertical-align: middle;padding-left:10px;display:none;">
							<div style="float:left;width:50px;text-align: center;">
								<span id="selectCnt" style="color:#fff;">0</span><span style="color:#fff;">/</span><span id="searchResult"
								                                                                                         style="width:50px;color:#fff;">0 &nbsp;</span>
							</div>

						</div>
						<div class="input-group btnCustomPosition" id="searchResultBtnArea" style="display:none;">
							<button class="pop_btn03" type="button" accesskey="U" id="searchMsgUp" style="padding:6px"><i
									class="glyphicon glyphicon-chevron-up"></i></button>
							<button class="pop_btn03" type="button" accesskey="D" id="searchMsgDn" style="padding:6px"><i
									class="glyphicon glyphicon-chevron-down"></i></button>
						</div>
					</div>
				</div>

				<div class="row2" style="height: calc(100% - 160px);">
					<div>
						<div class="messenger_prev" style="margin-bottom:16px" title="<s:message code='eikon.msg.show.prev'/>"><svg xmlns="http://www.w3.org/2000/svg" height="16" width="14" viewBox="0 0 448 512"><!--!Font Awesome Free 6.5.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M246.6 41.4c-12.5-12.5-32.8-12.5-45.3 0l-160 160c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L224 109.3 361.4 246.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3l-160-160zm160 352l-160-160c-12.5-12.5-32.8-12.5-45.3 0l-160 160c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L224 301.3 361.4 438.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3z"/></svg></div>
						<div id="timeline_list">
							<div class="timeline-panel">
								<div class="list-group-item02 cursor-text">
									<div class="timeline-body" style="text-align: center;">
										<s:message code="eikon.select.data"/>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="messenger_next" title="<s:message code='eikon.msg.show.next'/>"><svg xmlns="http://www.w3.org/2000/svg" height="16" width="14" viewBox="0 0 448 512"><!--!Font Awesome Free 6.5.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M246.6 470.6c-12.5 12.5-32.8 12.5-45.3 0l-160-160c-12.5-12.5-12.5-32.8 0-45.3s32.8-12.5 45.3 0L224 402.7 361.4 265.4c12.5-12.5 32.8-12.5 45.3 0s12.5 32.8 0 45.3l-160 160zm160-352l-160 160c-12.5 12.5-32.8 12.5-45.3 0l-160-160c-12.5-12.5-12.5-32.8 0-45.3s32.8-12.5 45.3 0L224 210.7 361.4 73.4c12.5-12.5 32.8-12.5 45.3 0s12.5 32.8 0 45.3z"/></svg></div>
				<div class="p16 white" style="position: fixed; bottom:0; background-color:#606973;">
					<s:message code="eikon.msg.total.cnt"/> : <span id="groupSubResultCnt" class="blue03">0</span>
					<span class="condition_top_sub"></span> &nbsp;&nbsp;&nbsp;
					<span class="condition_top" id="condition_top" style="margin-left: 1px;">▲</span>
				</div>



				<%--	<div class="chat active-chat" data-chat="person2">
						<div class="conversation-start">
							<span>Today, 5:38 PM</span>
						</div>
						<div class="bubble slide_left">
							<div class="you">출근</div>
							<div class="bubbleDate">
								<span>U066A8MA3NJ</span>
								<span>2023.11.19  08:00:00</span>
							</div>
						</div>
						<div class="bubble txt_right slide_right">
							<div class="me">출근</div>
							<div class="bubbleDate">
								<span>U066A8MA3NJ</span>
								<span>2023.11.19  08:00:00</span>
							</div>
						</div>--%>
			</div>
		</div>
		<!-- 채팅 끝! -->
		<!-- 첨부파일 -->
		<div class="rightFile p20" id="xcn_Search2" style="display: none;">
			<div class="subtab">
				<button class="active"><s:message code="consent.attach"/>
				</button>
			</div>
			<div class="rightFileList">
			</div>
		</div>
		<div class="xcn_showbtn">

			<button id="showBtn" class="table_btn02">&#8636;</button>

		</div>
		<%--			첨부파일 끝!!--%>
	</div>
</div>


<div style="width: 0%;height: 0px;">
</div>
<iframe id="AttachDown" src="about:blank;" height="0" width="0" style="display: none;"></iframe>
<!-- Back to top -->
<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>

<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"></input>
	<input type="hidden" name="oldConm" id="oldConm"></input>
	<input type="hidden" name="oldDept" id="oldDept"></input>
	<input type="hidden" name="oldJib" id="oldJib"></input>
</form>

<script>


    let friends = {
            list: document.querySelector("ul.people"),
            all: document.querySelectorAll(".messengerBox .person"),
            name: ""
        },
        chat = {
            container: document.querySelector(".chatList .chatBox"),
            current: null,
            person: null,
            name: document.querySelector(".chatList .chatBox .top .chatid")
        };

    friends.all.forEach((f) => {
        f.addEventListener("mousedown", () => {
            f.classList.contains("active") || setAciveChat(f);
        });
    });

    function setAciveChat(f) {
        friends.list.querySelector(".active").classList.remove("active");
        f.classList.add("active");
        chat.current = chat.container.querySelector(".active-chat");
        chat.person = f.getAttribute("data-chat");
        chat.current.classList.remove("active-chat");
        chat.container
            .querySelector('[data-chat="' + chat.person + '"]')
            .classList.add("active-chat");
        friends.name = f.querySelector(".chatid").innerText;
        chat.name.innerHTML = friends.name;
    }

</script>

<script>
    $(function() {
        $("#xcn_toggleBtn").on("click", function() {
            $("#xcn_Search").toggle("show");
        })
    })
</script>