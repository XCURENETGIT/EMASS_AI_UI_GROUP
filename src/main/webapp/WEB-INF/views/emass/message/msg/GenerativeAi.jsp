<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<%
	String adminType = Common.getAdminType(session);
	String firstAdminYn = Common.getFirstAdminYn(session);
%>

<script>
	$(function() {
		$("#xcn_toggleBtn").on("click", function() {
			$("#xcn_Search").toggle("show");
		})
	})

	$(function() {
		$("#showBtn").on("click", function() {
			$("#xcn_Search2").show();
		})
		$("#xcn_toggleBtn2").on("click", function() {
			$("#xcn_Search2").hide();
		})
	})
</script>

<style>
	@media screen and (max-width: 1640px) {
		.chatList {
			display: none; /* chatList div를 감춤 */
		}
	}
	#wrap {overflow:hidden;}

	span.mini {
		font-size: 13px;
	}

</style>

<head>
	<title>EMASS AI - <s:message code="DATA_MONITOR.MESSAGE_SERVICE"/></title>
	<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/collection.js"/>"></script>

	<script>
        var messengerListCnt = 0;
        var nodataMsg = '<s:message code="common.msg.nodata"/>';
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
            $(window).resize(function () {
                if ($(window).width() < 1700) {
                    $('#searchResultBtnArea').addClass('btnCustomPosition');
                } else {
                    $('#searchResultBtnArea').removeClass('btnCustomPosition');
                }
            });

            var today = new Date();
            today.setDate(today.getDate() - 7);

            document.getElementById("startDt").valueAsDate = today;
            document.getElementById("endDt").valueAsDate = new Date();

            document.getElementById("startSubDt").valueAsDate = today;
            document.getElementById("endSubDt").valueAsDate = new Date();

            $('#searchBtn').click(function () {
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
          /*      if (getDayInterval(startDt, endDt) > 31) {
                    ui.alertMsg('<s:message code="eikon.msg.select.date"/>');
                    return;
                }*/

                eikon2.getCollectionList(1,"G");
            });
            $("#searchStrInput").keypress(function (e) {
                if (e.keyCode == 13) $('#searchBtn').click();
            }); //통합 검색 엔터키

            $('#searchMsgBtn').click(function () {
                var svc12 = $('#selectUserInfo').attr('data-svc12');
                if ($('#searchMsgStrInput').val() == "") $('#searchMsgQueryBtn').click();
                else eikon2.findMessageList(0,svc12);
                //eikon.getMessengerDetailList($('#xrootmtr').text(),$('#msgid').text(), $('#srcip').text());
            });
            $('#searchMsgQueryBtn').click(function () {

                var srcip = $('#selectUserInfo').attr('data-srcip');
                var userkey = $('#selectUserInfo').attr('data-name');
                var svc12 = $('#selectUserInfo').attr('data-svc12');

                eikon2.getCollectionDetailList(userkey, '', srcip, '',svc12);
            });
            $("#searchMsgStrInput").keypress(function (e) {
                if (e.keyCode == 13) {
                    if ($('#searchMsgStrInput').val() == "") $('#searchMsgQueryBtn').click();
                    else $('#searchMsgBtn').click();
                }
            });

            $('#searchMsgUp').click(function () {
                var svc12 = $('#selectUserInfo').attr('data-svc12');
                eikon2.findMessageList(--searchOffset,svc12);
// 		checkList(--searchOffset);
            });
            $('#searchMsgDn').click(function () {
// 		checkList(++searchOffset);
                var svc12 = $('#selectUserInfo').attr('data-svc12');
                eikon2.findMessageList(++searchOffset,svc12);
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

            $('#user').click(function () {
                var code = $(this).attr('id');
                openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
            });

            $(document).on('click', '#userSelectedArea', function (e) {
                $('#userVal, #userVal').val('');
                $('#userSelectedArea').hide();
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
            $(document).on('click', '.excel_file_down', function () {
                var userkey = $('#selectUserInfo').attr('data-name');
                var srcip = $('#selectUserInfo').attr('data-srcip');
                var startDt = $('#startSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '')+"0000000";
                var endDt = $('#endSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '')+"235959";
                var searchStr = '';
                if (userkey == '') return;
                eikon2.getCollectionGroupTextExport('<c:url value="/getCollectionGroupAllExport.xcn"/>?userkey=' + userkey + '&srcip=' + srcip + '&startDt=' + startDt + '&endDt=' + endDt + '&searchStr=' + searchStr+'&limit=1000&facet_detail=true&export=true&type=G');
                hideSelect();
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


            $(document).on('click', '.codeSelectedBtn', function (e) {
                $('#deptVal, #deptStr').val('');
                $('#deptSelectedArea').hide();
            });

            $(document).on('click', '.me', function (e) {

                var userkey = $(this).parent().attr('userkey');
                var srcip = $(this).parent().attr('srcip');
                var svc12 = $(this).attr('svc12');
                var id = $(this).parent().attr('id');
                updateEmassGenerativeAdminUserid(userkey, id, srcip,svc12);

                moveTargetHeight(id, false);
            });

            $(document).on('click', '.person', function () {

                if ((isConsent() && $('#consentNo').val() == '') || $(this).attr('userkey') == '') {
                    return;
                }
                //if($(this).hasClass('active')) return;
                $('.person').each(function () {
                    $(this).removeClass('active');
                });

                $(this).addClass('active');
                $('#userkey').text($(this).attr('userkey'));

                $('#srcip').text($(this).attr('srcip'));
                $('#msgid').text($(this).attr('msgid'));
                $('#usrid').text($(this).attr('usrid'));

                $('#selectUserInfo').attr('data-name', '');
                $('#selectUserInfo').attr('data-srcip', '');
                $('#selectUserInfo').attr('data-usrid', '');
                $('#selectUserInfo').html('');
                $('#searchMsgStrInput').val('');
                $('#startSubDt').val($('#startDt').val());
                $('#endSubDt').val($('#endDt').val());
                focusMsgId = '';
                /*eikon2.getGenerativeDetailList($(this).attr('userkey'), $(this).attr('msgid'), $(this).attr('srcip'), $(this).attr('usrid'));*/
            });

            $('input[name="searchType"]:radio').change(function () {
                eikon2.getCollectionList(1);
            });

            $('#groupFileCnt').click(function () {
                fileInfoViewer($('#userkey').text(), $('#srcip').text(), $('#usr_id').text());
            });

            $('#groupParticipant').click(function () {
                participantInfoViewer($('#userkey').text(), $('#usr_id').text());
            });

            $(document).on('click', '.person', function () {
                var name = $(this).attr('userkey');
                var srcip = $(this).attr('srcip');
                var usr_id = $(this).attr('usr_id');
                var userkey =  $(this).attr('userkey');
                var msgid = $(this).attr('msgid');
                var username= $(this).attr('name');
                var svc12= $(this).attr('svc12');

                $('#selectUserInfo').attr('data-srcip', srcip);
                $('#selectUserInfo').attr('data-name', name);
                $('#selectUserInfo').attr('data-usrid', usr_id);
                $('#selectUserInfo').attr('data-svc12', svc12);

                $('#selectUserInfo').html(userkey+"("+username+")");
                $('#subchatid').html(": "+name);
                $('#srcip').text(srcip);
                $('#usr_id').text(usr_id);
                eikon2.getCollectionDetailList(userkey, msgid, srcip, usr_id,svc12);
                hideUserSelect();
            });

            initCondition();
            eikon2.init();
// 	$('#searchBtn').click();

        });

        function openCodeWindow(id, oldCode, oldConm) {
            $('#oldCode').val(oldCode);
            $('#oldConm').val(oldConm);

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

            var userkey = $('#selectUserInfo').attr('data-name');
            var srcip = $('#selectUserInfo').attr('data-srcip');
            var usr_id = $('#selectUserInfo').attr('usr_id');

            if (userkey == '') return;
            var startDt = $('#startSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '')+"000000";
            var endDt = $('#endSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '')+"235959";
            var searchStr = '';

            eikon2.getCollectionGroupTextExport('<c:url value="/getCollectionrGroupTextExport.xcn"/>?userkey=' + userkey + '&srcip=' + srcip + '&startDt=' + startDt + '&endDt=' + endDt + '&searchStr=' + searchStr + '&type=G' +'&export_type='+type + '&groupField=sender_str&limit=1000&', userkey);
        }


        function searchConsentNo() {
            var url = '<c:url value="/ems/selectConsent.do"/>';
            return fnOpenWindow(url, 'selectConsentWinPopup', 830, 700, 'resize');
        }

        function selectedConsent(obj) {
            if (obj == '') {
                $('#consentNo').val('');
                $('#consentName').text('');
                /* $('#consentIp').val('');
				$('#consentEmail').val(''); */
                $('#consentUserId').val('');
                $('#consentBtn').removeClass('active');
            } else {
                $('#consentNo').val(obj.no);
                $('#consentName').text(obj.name + "[" + obj.userkey + ", " + (obj.deptNm == '' ? '<s:message code="consent.select.consentDept"/>' : obj.deptNm) + "]");
                /* $('#consentIp').val(obj.userIp);
				$('#consentEmail').val(obj.userEmail); */
                $('#consentUserId').val(obj.userkey);
                $('#consentBtn').addClass('active');
            }
        }

        function initCondition() {
            getGenerativeList();
            getCodeList('busi');
            getCodeList('dept');

            $("#xcn_Search2").hide();

            var dateObj = new Date();



            $('#easyDate').change(function () {
                changeDate($(this).val());
            });
            $('#timedatepicker').datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59))
            }).on("dp.change", function (e) {
                var date = $(this).data("DateTimePicker").date().format('YYYY-MM-DD');
                detailDateFocus(date);

                $('#searchMsgStrInput').val('');
                $('#searchResult').html('');
                $('#searchResultArea').hide();
                $('#searchResultBtnArea').hide();
            });

            $('#serviceTypeSelect').selectpicker({
                size: 15,
                width: '300px',
                noneSelectedText: condition.serviceAll,
                noneResultsText: condition.msgNoresult + ' ',
                selectAllText: condition.msgSelect_all,
                deselectAllText: condition.msgUnselect_all,
                liveSearchPlaceholder: condition.searchService
            });

            $('#busiSelect').selectpicker({
                size: 15,
                width: '300px',
                searchLabel: true,
                noneSelectedText: '<s:message code="common.org.busi.all"/>',
                noneResultsText: '<s:message code="common.msg.noresult"/>' + ' ',
                selectAllText: '<s:message code="common.msg.select_all"/>',
                deselectAllText: '<s:message code="common.msg.unselect_all"/>'
            });

            $('#searchField').selectpicker({
                width: '100px',
                noneSelectedText: '<s:message code="common.msg.all"/>'
            });

            $('button[name="attachYn"]').click(function(){
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
            condition.senders = $('#senders').val();
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
                str += '<option value="' + data[i].code + '">' + data[i].codeName + '</option>';
            }
            return str;
        }

        function getSelectedCodeData(codeType, data) {
            var str = '';
            var val = '';
            for (var i = 0; i < data.length; i++) {
                str += data[i].codeName;
                val += data[i].code;
                if (codeType == 'regexp') {
                    var arr = data[i].count.split('@');
                    if (arr[0] == 'B') str += '(' + arr[1] + '<s:message code="selectCodeAll.items"/> ~ ' + arr[2] + '<s:message code="selectCodeAll.items"/>)';
                    else if (arr[0] == 'L') str += '(' + arr[1] + '<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>)';
                    else str += '(' + arr[1] + '<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.below"/>)';
                    val += '%' + data[i].count;
                }

                if (i != data.length - 1) {
                    str += ', ';
                    val += '|';
                }
            }
            if (val != '') {
                str = str.rtrim();
                val = val.trimAll();
            }

            $('#' + codeType + 'Str').val(str);
            $('#' + codeType + 'Val').val(val);

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
            $('#' + codeType + 'SelectedArea').hide();
        }
	</script>
</head>
	<div id="searchArea">
		<div class="inner_messenger">
			<%--			검색 영역--%>
			<div class="leftSearch p20" id="xcn_Search">
				<div class="leftSearchTab">
					<button class="active" onclick="openCity('Tab01')"><s:message code="DATA_MONITOR.GENERATIVEAI_SERVICE"/></button>
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
							<input class="w45 mat8 txt_center" type="date" id="startDt"  value="2023-11-20"><span class="w10 dis_inlineblock txt_center">~</span><input class="w45 txt_center" type="date" id="endDt"  value="2023-11-30">

							<div class="optiotab w100 mat8" data-toggle="buttons">
								<button class="active w50" name="attachYn" id="attachAll" value=""><s:message code="condition.isattached.all"/></button>
								<button class="w50" name="attachYn" id="attachY" value="Y"><s:message code="eikon.attach.exist"/></button>
							</div>

							<select id="busiSelect" class="w100 mat8" data-style="btn-default btn-sm" multiple data-show-subtext="true"
							                                                                         data-live-search="true" data-actions-box="true"></select>

							<p class="mat8 formText btnform" data-toggle="buttons">
								<span class="tit"><s:message code="common.org.choose.dept"/></span>
								<button type="button" class="btn01" id="dept"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
										code="common.org.choose.dept"/></button>
								<span id="deptSelectedArea" class="codeSelectedBtn">
										<button type="button" class="btn num_add bornone"  style="z-index: 2;">0</button>
									</span>
								<input type="hidden" id="deptStr" class="selectedTitle">
								<input type="hidden" id="deptVal">
							</p>
							<div id="selectedCodeTitle" class="infotxt"></div>

							<p class="mat8 formText btnform" data-toggle="buttons">
								<span class="tit"><s:message code="common.org.choose.user"/></span>

							<button class="btn01" id="user"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
									code="common.org.choose.user"/></button>
							<span id="userSelectedArea" class="codeSelectedBtn">
										<button type="button" class="btn num_add bornone"  style="z-index: 2;">0</button>
									</span>
							<input type="hidden" id="userStr" class="selectedTitle">
							<input type="hidden" id="userVal">
							</p>
							<div id="selectedCodeTitle2" class="infotxt"></div>
						</div>
					</div>

					<div class="fixBtn">
						<div class="xcn_checkbox">
							<input type="checkbox" name="readYn" id="readYn"><label><s:message code="eikon.msg.notRead"/></label>
						</div>
						<button class="fullbtn" type="button" accesskey="Q" id="searchBtn">검색</button>
					</div>
				</div>
			</div>
			<%--			검색 끝!--%>

			<%--			검색 결과 영역--%>
			<div class="messengerList" >
				<div class="messengerBox">
					<div class="subTit p12">
						<h2 class="ma_none pb4">
							<button id="xcn_toggleBtn" class="menu"></button><s:message code="DATA_MONITOR.GENERATIVEAI_SERVICE"/>
						</h2>
					</div>
					<div class="bortop_dd pt16 pl20 pr20">
						<div class="subtab">
							<button class="active"><s:message code="eikon.msg.chats"/></button>
						</div>
					</div>
					<div>
						<div class="list-group" id="group_list" style="margin-bottom: 0px;">
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

				<!-- pagination -->
				<div class="pl20 pr20">
					<div class="pageArea bornone" id="groupPage">
						<div class="total fb600">
						</div>
					</div>
					<s:message code="common.msg.finish_query"/> : <span id="groupResultCnt" class="red fb600">0</span>
				</div>
				<!-- //pagination -->
			</div>

			<!-- 대화방 끝!! -->
			<!-- 채팅 -->
			<div class="chatList">

				<div class="chatBox">

					<div class="top">
						<!-- 내보내기 -->
						<div class="myDropdown mal16">
							<span><s:message code="analysis.relation.ui.export"/>&#9662;</span>
							<div class="dropdown-content">
								<a href="#" onclick="downloadList('xlsx')" class="excel_down"><s:message code="common.msg.excel"/></a>
								<a href="#" onclick="downloadList('txt')" class="txt_down"><s:message code="common.msg.text"/></a>
								<a href="#" onclick="downloadList('html')" class="html_down"><s:message code="eikon.msg.html"/></a>
								<a href="#" class="excel_file_down"><s:message code="common.msg.excel"/>+<s:message code="consent.attach"/></a>
							</div>
						</div>
						<!-- //내보내기 -->
						<div>
							<span id="selectUserInfo"  class="chatid" data-srcip="" data-name="" data-usrid=""><s:message code="condition.user"/></span>
						</div>
						<div class="chatDate">
							<div class="searchSub" style="display: flex">
								<div style="display: flex;">
									<div id="startsubdatepicker"><input type="date" id="startSubDt" style="width: 110px;">
										<span class="hyphen">~</span></div>
									<div id="endsubdatepicker"><input type="date" id="endSubDt" style="width: 110px;"></div>
								</div>

								<button class="form_btn01" type="button" accesskey="M" id="searchMsgQueryBtn"><s:message code="common.search"/></button>
							</div>

							<div class="searchSub txt_right">
								<input type="text" class="w70" placeholder="<s:message code="condition.research"/>" id="searchMsgStrInput">
								<button class="form_btn01 blackBg" type="button" accesskey="M" id="searchMsgBtn"><s:message code="common.search"/></button>
							</div>
						</div>
						<%--							<div class="col-lg-12"><span style="font-size: 12px; background-color: #444; color: #fff; display: block; padding-left: 3px; padding-right: 3px;border-top-left-radius:4px;border-top-right-radius:4px;height:20px;padding-top:3px;">&nbsp;<s:message code="condition.xrootmtr"/> : <span id="xrootmtr"></span><span id="srcip" style="display:none;"></span><span id="usr_id" style="display:none;"></span><span id="msgid" style="display:none;"></span></span></div>--%>
					</div>

					<%--					채팅 검색 부분 끝!--%>

					<%--					채팅 본문 내용 보이는 구간 시작  -> ***** 아직 안함 --%>
					<div style="margin-top:-10px;">
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
					<div class="p16 white" style="position: fixed; bottom:0; background-color:#606973; width:100%;">
						<s:message code="eikon.msg.total.cnt"/> : <span id="groupSubResultCnt" class="blue03">0</span>
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
			<div class="rightFile p20" id="xcn_Search2">
				<div class="subtab">
					<button class="active"><s:message code="consent.attach"/>
						<span id="xcn_toggleBtn2" style="font-size:16px; opacity: 0.7; padding:4px;">x</span>
					</button>
				</div>
				<div class="rightFileList" >
				</div>
			</div>
			<div class="xcn_showbtn">

				<button id="showBtn" class="table_btn02">&#8636;</button>

			</div>
			<%--			첨부파일 끝!!--%>
		</div>
	</div>


<iframe id="AttachDown" src="about:blank;" height="0" width="0" style="display: none;"></iframe>
<!-- Back to top -->
<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>

<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"></input>
	<input type="hidden" name="oldConm" id="oldConm"></input>
</form>

<script>
	document.querySelector(".chat[data-chat=person2]").classList.add("active-chat");
	document.querySelector(".person[data-chat=person2]").classList.add("active");

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