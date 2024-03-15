<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<%
	String infoFeedbackYn = Common.getInfoFeedbackYn(session);
	boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title></title>
	<style type="text/css">
		.radio-inline {
			padding-left: 0px;
		}

		.ellipsis {
			width: 320px;
			text-overflow: ellipsis;
			overflow: hidden;
			white-space: nowrap;
		}
		.nav {
			padding-left: 0;
			margin-bottom: 0;
			list-style: none
		}

		.nav>li {
			position: relative;
			display: block;
		}

		.nav>li>a {
			position: relative;
			display: block;
			padding: 12px 20px;
			min-width: 160px;
			color: #333333;
			background-color: #f8f8f8;
		}

		.nav>li>a:focus, .nav>li>a:hover {
			text-decoration: none;
			background-color: #eee
		}

		.nav>li.disabled>a {
			color: #777
		}

		.nav>li.disabled>a:focus, .nav>li.disabled>a:hover {
			color: #777;
			text-decoration: none;
			cursor: not-allowed;
			background-color: transparent
		}



		.nav .nav-divider {
			height: 1px;
			margin: 9px 0;
			overflow: hidden;
			background-color: #e5e5e5
		}

		.nav>li>a>img {
			max-width: none
		}


		.bootstrap-select {
			width: auto;
			min-width: 120px;
			vertical-align: middle;
		}

		.bootstrap-select.btn-group[class*=col-] .dropdown-menu.open {
			left: 0;
			right: auto;
		}

		.selecBtnArea .btn {
			padding: 2px 20px 2px 10px;
		}

		.selecBtnArea .bootstrap-select {
			margin-top: 3px;
			margin-bottom: 2px;
		}

		.noUi-connect {
			background-color: #286090;
		}

		#selectedCodeTitle {
			display: none;
			border: 1px solid #458A45;
			position: absolute;
			background-color: #5CB85C;
			color: #fff;
			z-index: 999;
			padding: 3px;
			max-width: 400px;
			word-break: break-all;
		}

		.bootstrap-select.btn-group .dropdown-menu.inner {
			box-shadow: none !important;
		}

		.exceptOption, .exceptOption2 {
			position: relative;
			padding-left: 30px;
		}

		.exceptOption {
			top: 5px;
		}

		.form-inline:not(.not-dashed) {

		}

		.bootstrap-select.btn-group .dropdown-toggle .filter-option {
			padding-top: 2px;
		}

		.filterAddBtn {
			padding: 3px 10px;
		}
		.c-checkbox input,
		.c-radio input {
			opacity: 0;
			position: absolute;
			margin-left: 0 !important;
		}
		input[type="checkbox"]:disabled {width:0; height:0; border:none;}

	</style>


	<script type="text/javascript">

        var searchFlag = false;
        $(document).ready(function () {
            $('#rootwizard').bootstrapWizard({
                onNext: function (tab, navigation, index) {
                    var error_message = '';
                    var error_count = 0;
                    if (index == 1) {
                        if ($('#alarmName').val().ltrim().rtrim() == '') {
                            ui.alertMsg('<s:message code="mail.message.input.alarm_name"/>');
                            $('#alarmName').focus();
                            return false;
                        }

                        if ($("input:checkbox[name='alarmType']:checked").length < 1) {
                            ui.alertMsg('<s:message code="mail.message.select.alarm_type"/>');
                            return false;
                        }
                    } else if (index == 2) {
                        if ($('#mailField').css('display') != 'none') {
                            if ($('#alarmTo').val().ltrim().rtrim() == '') {
                                ui.alertMsg('<s:message code="mail.message.select.recv"/>');
                                $('#alarmTo').focus();
                                return false;
                            }
                            if ($('#formSubject').val().ltrim().rtrim() == '') {
                                ui.alertMsg('<s:message code="mail.message.select.form_mail"/>');
                                $('#formSubject').focus();
                                return false;
                            }
                            var csvYn = $("input:radio[name='csvYnVal']:checked").val();
                            var excelMaxCnt = $('#excelMaxCnt').val();
                            var maxCsvExcel = 10000000;
                            var maxXlsxExcel = 10000;
                            if (csvYn == 'Y' && excelMaxCnt > maxCsvExcel) {
                                ui.alertMsg('<s:message code="mail.message.max.cnt" arguments="CSV, '+maxCsvExcel+'" />');
                                $('#excelMaxCnt').focus();
                                return false;
                            } else if (csvYn == 'N' && excelMaxCnt > maxXlsxExcel) {
                                ui.alertMsg('<s:message code="mail.message.max.cnt" arguments="XLSX, '+maxXlsxExcel+'" />');
                                $('#excelMaxCnt').focus();
                                return false;
                            }
                        }
                    } else if (index == 3) {

                    }
                },
                onTabShow: function (tab, navigation, index) {
                    var total = 3;
                    var current = index + 1;
                    if (current >= total) {
                        $('#rootwizard').find('.pager .next').hide();
                        $('#rootwizard').find('.pager .finish').show();
                        $('#rootwizard').find('.pager .finish').removeClass('disabled');
                    } else {
                        $('#rootwizard').find('.pager .next').show();
                        $('#rootwizard').find('.pager .finish').hide();
                    }
                }
            });

            $('#rootwizard .finish').click(function () {
                if ($('#alarmName').val().ltrim().rtrim() == '') {
                    ui.alertMsg('<s:message code="mail.message.input.alarm_name"/>');
                    $('#alarmName').focus();
                    return;
                }

                if ($("input:checkbox[name='alarmType']:checked").length < 1) {
                    ui.alertMsg('<s:message code="mail.message.select.alarm_type"/>');
                    return;
                }
                if ($('#mailField').css('display') != 'none') {
                    if ($('#alarmTo').val().ltrim().rtrim() == '') {
                        ui.alertMsg('<s:message code="mail.message.select.recv"/>');
                        $('#alarmTo').focus();
                        return;
                    }
                    if ($('#formSubject').val().ltrim().rtrim() == '') {
                        ui.alertMsg('<s:message code="mail.message.select.form_mail"/>');
                        $('#formSubject').focus();
                        return;
                    }
                    var csvYn = $("input:radio[name='csvYnVal']:checked").val();
                    var excelMaxCnt = $('#excelMaxCnt').val();
                    var maxCsvExcel = 10000000;
                    var maxXlsxExcel = 10000;
                    if (csvYn == 'Y' && excelMaxCnt > maxCsvExcel) {
                        ui.alertMsg('<s:message code="mail.message.max.cnt" arguments="CSV, '+maxCsvExcel+'" />');
                        $('#excelMaxCnt').focus();
                        return;
                    } else if (csvYn == 'N' && excelMaxCnt > maxXlsxExcel) {
                        ui.alertMsg('<s:message code="mail.message.max.cnt" arguments="XLSX, '+maxXlsxExcel+'" />');
                        $('#excelMaxCnt').focus();
                        return;
                    }
                }
                insertAlarm();
            });

            $('#startDatePicker').datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date())
            });

            $('#endDatePicker').datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date())
            });

            $('#alarmSmsYn').val('N');
            $('#alarmMonitorYn').val('N');

            $('#searchBtn').click(function () {
                getData();
            });
            $('#searchStr').enter(function () {
                getData();
            });

            $('#insertBtn').click(function () {
                modalinit();
                $('#finish').text('<s:message code="common.msg.add"/>');
                $('#resvAlarmPop').attr('mode', 'insert');
                $('#resvAlarmPop').modal({
                    backdrop: 'static',
                    keyboard: true,
                    show: true
                });
                setTimeout(function () {
                    $("#alarmName").focus();
                }, 500);
            });

            $('#deleteBtn').click(function () {
                var alarmSeqs = grid.getSelectedKey('alarmSeq');
                if (alarmSeqs == '') {
                    ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                    return;
                }
                var alarmNames = grid.getSelectedKey('alarmName');
                ui.confirmMsg('<s:message code="common.msg.confirm.deleteitem" arguments="'+alarmNames+'" argumentSeparator="|"/>', '', '', function (rs) {
                    if (rs) {
                        grid.on();
                        ui.postJson({
                            url: 'deleteAlarm.xcn',
                            alarmSeqs: alarmSeqs.join(','),
                            alarmNames: alarmNames.join(','),
                            success: function (data, total) {
                                ui.alertMsg('<s:message code="common.msg.deleted"/>');
                                getData();
                            },
                            error: function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete: function () {
                                grid.off();
                            }
                        });
                    }
                });
            });

            $("input:checkbox[name='alarmType']").change(function () {
                var alarmType = $(this).val();
                var checked = $(this).is(":checked");
                if (alarmType == "E") {
                    if (checked) {
                        $('#alarmMailYn').val('Y');
                        $('#mailField').show();
                        $('#alertField').hide();
                    } else {
                        $('#alarmMailYn').val('N');
                        $('#mailField').hide();
                    }
                } else if (alarmType == "S") { //SMS
                    if (checked) {
                        $('#alarmSmsYn').val('Y');
                        $('#smsField').show();
                        $('#alertField').hide();
                    } else {
                        $('#alarmSmsYn').val('N');
                        $('#smsField').hide();
                    }
                } else {					//화면
                    if (checked) {
                        $('#alarmMonitorYn').val('Y');
                        $('#monitorField').show();
                        $('#alertField').hide();
                    } else {
                        $('#alarmMonitorYn').val('N');
                        $('#monitorField').hide();
                    }
                }
                if ($("input:checkbox[name='alarmType']:checked").length < 1) {
                    $('#alertField').show();
                }
            });

            $("input:radio[name='alarmCycleVal']").change(function () {
                var alarmCycle = $(this).val();
                alarmCycleChange(alarmCycle);
            });

            /**
             * 메일 수신자 및 참조 메일 수신자 선택
             */
            $('#alarmToBtn').click(function () {
                fnOpenWindow('<c:url value="/ems/mailSearchPop.do"/>?type=to', 'alarmToCC', 900, 700, 'fix');
            });

            $('#alarmCCBtn').click(function () {
                fnOpenWindow('<c:url value="/ems/mailSearchPop.do"/>?type=cc', 'alarmToCC', 900, 700, 'fix');
            });

            $('#mailFormBtn').click(function () {
                fnOpenWindow('<c:url value="/ems/mailForm.do"/>', 'mailForm', 900, 680, 'fix');
            });

            $('#mailFormSelBtn').click(function () {
                fnOpenWindow('<c:url value="/ems/mailFormSelectPop.do"/>', 'mailFormSel', 900, 690, 'fix');
            });

            $('#alarmValBtn').click(function () {
                fnOpenWindow('<c:url value="/ems/detailConditionPop.do"/>', 'alarmVal', 700, 1310, 'fix');
            });

            modalinit();
            getData();

        });

        function alarmCycleChange(alarmCycle) {
            var str = "";
            if (alarmCycle == "W") {
                str += "<select name='alarmWeek' id='alarmWeek'>";
                var day = ["<s:message code='common.sunday' />", "<s:message code='common.monday' />", "<s:message code='common.tuesday' />", "<s:message code='common.wednesday' />", "<s:message code='common.thursday' />", "<s:message code='common.friday' />", "<s:message code='common.saturday' />"];
                for (var i = 0; i < day.length; i++) {
                    var selected = '';
                    if (i == 1) selected = 'selected';
                    else selected = '';
                    str += "<option value='" + (i + 1) + "' " + selected + ">" + day[i] + "</option>";
                }
                str += "</select>&nbsp;&nbsp;";
            }
            if (alarmCycle == "W" || alarmCycle == "D") {
                str += "<select name='alarmTime' id='alarmTime'>";
                for (var i = 0; i <= 23; i++) {
                    str += "<option value='" + i + "'>" + "<s:message code='condition.clock' arguments='"+i+"' />" + "</option>";
                }
                str += "</select>";
            } else {
                str += "<p class='infotxt'><s:message code='mail.message.excute.oclock'/></p>";
                str += "<input type='hidden' class='form-control' name='alarmTime' value='24' />";
            }
            $("#alarmTimeDiv").html(str);
        }

        function modalinit() {
            $(".tabDiv").find("a[href='#tab1']").trigger('click');
            var str = "";
            str += "<select name='alarmTime' id='alarmTime'>";
            for (var i = 0; i <= 23; i++) {
                str += "<option value='" + i + "'>" + "<s:message code='condition.clock' arguments='"+i+"' />" + "</option>";
            }
            str += "</select>";
            $("#alarmTimeDiv").html(str);

            $('[name=useYnVal]').parent().removeClass('active');
            $('[name=alarmCycleVal]').parent().removeClass('active');
            $('[name=csvYnVal]').parent().removeClass('active');

            $('#excelMaxCnt').val('');
            $('#resvAlarmPop input[type=text]').val('').prop('disabled', false);
            $('#resvAlarmPop textarea').val('').prop('disabled', false);
            $('[name=useYnVal][value=Y]').click();
            $('[name=csvYnVal][value=N]').parent().addClass('active');
            $('[name=alarmCycleVal][value=D]').click();
            $('[name=alarmType]').prop('checked', false);
            $('#alertField').show();
            $('#mailField').hide();
            $('#smsField').hide();
            $('#monitorField').hide();

            $('#alarmMailYn').val('N');
            $('#alarmSmsYn').val('N');
            $('#alarmMonitorYn').val('N');
        }

        /*
		 * 예약 알람 목록 조회
		 */
        function getData() {
            if (searchFlag) return;

            var searchStr = $("#searchStr").val();
            grid.on();
            searchFlag = true;
            ui.get({
                url: 'getAlarmList.xcn',
                searchStr: searchStr,
                success: function (data, total) {
                    grid.setData(data);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    searchFlag = false;
                    grid.off();
                }
            });
        }

        /*
		 * 예약 알람 추가
		 */
        function insertAlarm() {
            if ($('#alarmVal').val().ltrim().rtrim() == '') {
                ui.alertMsg('<s:message code="mail.message.select.alarm_condition"/>');
                $('#alarmVal').focus();
                return;
            }
            var mode = $('#resvAlarmPop').attr('mode');
            var message = mode == 'insert' ? '<s:message code="common.msg.add"/>' : '<s:message code="common.msg.modify"/>';
            var msg_str = mode == 'insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';

            var alarmCycleVal = $("input:radio[name='alarmCycleVal']:checked").val();
            var useYnVal = $("input:radio[name='useYnVal']:checked").val();
            var csvYnVal = $("input:radio[name='csvYnVal']:checked").val();

            if (alarmCycleVal == "" || alarmCycleVal == undefined) alarmCycleVal = "D";
            if (useYnVal == "" || useYnVal == undefined) useYnVal = "Y";
            if (csvYnVal == "" || csvYnVal == undefined) csvYnVal = "N";

            $('#alarmCycle').val(alarmCycleVal);
            $('#useYn').val(useYnVal);
            $('#csvYn').val(csvYnVal);

            ui.confirmMsg(msg_str, '', '', function (rs) {
                if (rs) {
                    grid.on();
                    ui.post({
                        url: mode == 'insert' ? 'insertAlarm.xcn' : 'updateAlarm.xcn',
                        data: $('#alarmPopForm').serializeAll(),
                        success: function (data, total) {
                            $('#resvAlarmPop').modal('hide');
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            getData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            grid.off();
                            modalinit();
                        }
                    });
                }
            });
        }

        /**
         *  조건 요약 출력
         */
        function printAlarmValStr(alarmCycle, alarmVal, rtnType) {
            var searchStr = '';
            var searchDateStr = '';
            if (alarmVal.startDateSelect == 'Y') searchDateStr += '<s:message code="condition.yesterday_str"/> ';
            else if (alarmVal.startDateSelect == 'T') searchDateStr += '<s:message code="condition.today_str"/> ';
            else if (alarmVal.startDateSelect == 'W') searchDateStr += '<s:message code="condition.sevenago"/> ';
            else if (alarmVal.startDateSelect == 'M') searchDateStr += '<s:message code="condition.month" arguments="1" argumentSeparator="|"/> ';
            searchDateStr += '<s:message code="condition.clock" arguments="'+alarmVal.startTimeSelect+'" />';
            searchDateStr += ' ~ ';
            if (alarmVal.endDateSelect == 'Y') searchDateStr += '<s:message code="condition.yesterday_str"/> ';
            else if (alarmVal.endDateSelect == 'T') searchDateStr += '<s:message code="condition.today_str"/> ';
            else if (alarmVal.endDateSelect == 'W') searchDateStr += '<s:message code="condition.sevenago"/> ';
            else if (alarmVal.endDateSelect == 'M') searchDateStr += '<s:message code="condition.month" arguments="1" argumentSeparator="|"/>';
            searchDateStr += '<s:message code="condition.time" arguments="'+alarmVal.endTimeSelect+',59,59" />';

            if (alarmCycle != 'H') searchStr = setConditionValStr(searchDateStr, '<s:message code="condition.period"/>');
            else searchStr = setConditionValStr('<s:message code="mail.message.condition_info"/>', '<s:message code="condition.period"/>');

            if (alarmVal.searchStr != '') searchStr += setConditionValStr(alarmVal.searchStr, '<s:message code="condition.search_str"/>');

            if (alarmVal.searchField != '') searchStr += setConditionValStr(alarmVal.serviceFieldNm, '<s:message code="condition.field.search"/>');

            if (infoFeedbackConf == 'true' && infoFeedbackYn == 'Y') {
                if (alarmVal.infoType != '') searchStr += setConditionValStr(alarmVal.infoTypeNm, '<s:message code="condition.infotype"/>');
                if (alarmVal.feedbackType != '') searchStr += setConditionValStr(alarmVal.feedbackTypeNm, '<s:message code="condition.feedback"/>');
                if (alarmVal.probType != '') searchStr += setConditionValStr(alarmVal.probTypeNm, '<s:message code="condition.prob"/>');
            }

            var ocrYnMsg = '';
            if (alarmVal.ocrYn == 'Y') ocrYnMsg = '<s:message code="condition.exist"/>';
            else if (alarmVal.ocrYn == 'N') ocrYnMsg = '<s:message code="condition.none"/>';
            if (ocrYnMsg != '') searchStr += setConditionValStr(ocrYnMsg, '<s:message code="condition.ocr.attach"/>');

            var reprocessMsg = '';
            if (alarmVal.reprocessYn == 'Y') reprocessMsg = '<s:message code="condition.exist"/>';
            else if (alarmVal.reprocessYn == 'N') reprocessMsg = '<s:message code="condition.unread"/>';
            if (reprocessMsg != '') searchStr += setConditionValStr(reprocessMsg, '<s:message code="condition.reprocess"/>');

            var readYnMsg = '';
            if (alarmVal.readYn == 'Y') readYnMsg = '<s:message code="condition.read"/>';
            else if (alarmVal.readYn == 'N') readYnMsg = '<s:message code="condition.unread"/>';
            if (readYnMsg != '') searchStr += setConditionValStr(readYnMsg, '<s:message code="condition.isread"/>');

            var receiveSendMsg = '';
            if (alarmVal.receiveSend == 'O') receiveSendMsg = '<s:message code="condition.send"/>';
            else if (alarmVal.receiveSend == 'I') receiveSendMsg = '<s:message code="condition.receive"/>';
            if (receiveSendMsg != '') searchStr += setConditionValStr(receiveSendMsg, '<s:message code="condition.receive_send"/>');

            var ctimeWorkMsg = '';
            if (alarmVal.ctimeWork == 'W') ctimeWorkMsg = '<s:message code="condition.work"/>';
            else if (alarmVal.ctimeWork == 'R') ctimeWorkMsg = '<s:message code="condition.notwork"/>';
            if (ctimeWorkMsg != '') searchStr += setConditionValStr(ctimeWorkMsg, '<s:message code="condition.ctimework"/>');

            if (alarmVal.serviceType != '') searchStr += setConditionValStr(alarmVal.serviceTypeNm, '<s:message code="filterInfo.servicetype"/>');
            if (alarmVal.senders != '') searchStr += setConditionValStr(alarmVal.senders, '<s:message code="condition.sender"/>', alarmVal.senders_not);
            if (alarmVal.receivers != '') searchStr += setConditionValStr(alarmVal.receivers, '<s:message code="condition.recv"/>', alarmVal.receivers_not);

            if (alarmVal.epmsgType != '') searchStr += setConditionValStr(alarmVal.epmsgType, '<s:message code="condition.epmsgType.list"/>');

            if (alarmVal.rcvTo != '') searchStr += setConditionValStr(alarmVal.rcvTo, '<s:message code="condition.to"/>', alarmVal.rcvTo_not);
            if (alarmVal.rcvCc != '') searchStr += setConditionValStr(alarmVal.rcvCc, '<s:message code="condition.cc"/>', alarmVal.rcvCc_not);
            if (alarmVal.rcvBcc != '') searchStr += setConditionValStr(alarmVal.rcvBcc, '<s:message code="condition.bcc"/>', alarmVal.rcvBcc_not);
            if (alarmVal.rcvJikgub != '') searchStr += setConditionValStr(alarmVal.rcvJikgub, '<s:message code="condition.recv_jikgub"/>');
            if (alarmVal.allOfus != '') searchStr += setConditionValStr(alarmVal.allOfus, '<s:message code="condition.allofus"/>');

            if (alarmVal.busi != '') searchStr += setConditionValStr(alarmVal.busiNm, '<s:message code="common.org.busi"/>', alarmVal.busi_not);
            if (alarmVal.dept != '') searchStr += setConditionValStr(alarmVal.deptNm, '<s:message code="common.org.dept"/>', alarmVal.dept_not);
            if (alarmVal.userGroupSeq != '') searchStr += setConditionValStr(alarmVal.userGroupName, '<s:message code="userGroup.navi.title2"/>', alarmVal.userGroupSeq_not);
            if (alarmVal.interGroup != '') searchStr += setConditionValStr(alarmVal.interGroupNm, '<s:message code="interest.user"/>', alarmVal.interGroup_not);
            if (alarmVal.url != '') searchStr += setConditionValStr(alarmVal.url, 'URL', alarmVal.url_not);

            var attachYnMsg = '';
            if (alarmVal.attachYn == 'Y') attachYnMsg = '<s:message code="condition.exist"/>';
            else if (alarmVal.attachYn == 'N') attachYnMsg = '<s:message code="condition.none"/>';
            if (attachYnMsg != '') searchStr += setConditionValStr(attachYnMsg, '<s:message code="condition.isattached"/>');
            if (alarmVal.attachVal != '') searchStr += setConditionValStr(alarmVal.attachVal, '<s:message code="consent.attach"/>', alarmVal.attachYn_not);

            if (alarmVal.realAttYn == 'Y') searchStr += setConditionValStr('<s:message code="condition.onemore"/>', '<s:message code="condition.actual.attachment"/>');
            else if (alarmVal.realAttYn == 'N') searchStr += setConditionValStr('<s:message code="condition.none"/>', '<s:message code="condition.actual.attachment"/>');

            var keywordYnMsg = '';
            if (alarmVal.keywordYn == 'Y') keywordYnMsg = '<s:message code="condition.exist"/>';
            else if (alarmVal.keywordYn == 'N') keywordYnMsg = '<s:message code="condition.none"/>';
            if (keywordYnMsg != '') searchStr += setConditionValStr(keywordYnMsg, '<s:message code="condition.iskeyword"/>');
            if (alarmVal.keywordVal != '') searchStr += setConditionValStr(alarmVal.keywordStr, '<s:message code="condition.keyword"/>', alarmVal.keywordYn_not);

            var regexpYnMsg = '';
            if (alarmVal.regexpYn == 'Y') regexpYnMsg = '<s:message code="condition.exist"/>';
            else if (alarmVal.regexpYn == 'N') regexpYnMsg = '<s:message code="condition.none"/>';
            if (regexpYnMsg != '') searchStr += setConditionValStr(regexpYnMsg, '<s:message code="condition.regexp.isdetect"/>');
            if (alarmVal.regexpVal != '') searchStr += setConditionValStr(alarmVal.regexpStr, '<s:message code="condition.regexp.detect"/>');

            if (alarmVal.drmYn == 'Y') searchStr += setConditionValStr('<s:message code="condition.exist"/>', 'DRM');
            else if (alarmVal.drmYn == 'N') searchStr += setConditionValStr('<s:message code="condition.none"/>', 'DRM');

            if (alarmVal.sctYn == 'Y') searchStr += setConditionValStr('<s:message code="condition.exist"/>', '<s:message code="condition.sct"/>');
            else if (alarmVal.sctYn == 'N') searchStr += setConditionValStr('<s:message code="condition.none"/>', '<s:message code="condition.sct"/>');

            var msgSize = '';
            if (alarmVal.sizeStartVal != null) {
                if (alarmVal.sizeOption == 'B') msgSize = convertFileSize(alarmVal.sizeStartVal) + ' ~ ' + convertFileSize(alarmVal.sizeEndVal);
                else {
                    msgSize = convertFileSize(alarmVal.sizeStartVal);
                    if (alarmVal.sizeOption == 'L') msgSize += '<s:message code="condition.over"/>';
                    else if (alarmVal.sizeOption == 'S') msgSize += '<s:message code="condition.below"/>';
                }
            }
            var rtnMsg = '<s:message code="condition.size.all"/>';
            if (alarmVal.sizeType == 'B') rtnMsg = '<s:message code="condition.size.body"/>';
            else if (alarmVal.sizeType == 'A') rtnMsg = '<s:message code="condition.size.attach"/>';

            if (msgSize != '') searchStr += setConditionValStr(msgSize, rtnMsg);

            if (rtnType == undefined) $('#alarmValStr').val(searchStr);
            else return searchStr;
        }

        function setConditionValStr(val, key, notVal) {
            if (val != null && val != '') {
                var str = key + ' : ' + val.replaceAll('\\|', ',');
                if (notVal == 'Y') str += ' [<s:message code="query.make.except"/>]';
                return str + '\n';
            }
            return '';
        }

        function getDayOfWeekText(val) {
            if (val == 1) return '<s:message code="common.sunday"/>';
            else if (val == 2) return '<s:message code="common.monday"/>';
            else if (val == 3) return '<s:message code="common.tuesday"/>';
            else if (val == 4) return '<s:message code="common.wednesday"/>';
            else if (val == 5) return '<s:message code="common.thursday"/>';
            else if (val == 6) return '<s:message code="common.friday"/>';
            else if (val == 7) return '<s:message code="common.saturday"/>';
            else return '-';
        }
	</script>
</head>
<body class="mini-navbar">
<div class="modal fade" id="resvAlarmPop" tabindex="-1" role="dialog" aria-labelledby="resvAlarmPop">
	<div class="modal-dialog modal-md" role="document">
		<div class="modal-content">
			<form method="post" id="alarmPopForm">
				<div class="modalHead">
					<h2 class="ma_none"><s:message code="mail.reservation.setting"/> <span class="text">( <s:message
							code="common.msg.addmodify"/> )</span></h2>
					<span class="close" data-dismiss="modal" aria-label="Close">&times;</span>
				</div>
				<div class="modalCon">
					<div>
						<div>
							<div id="rootwizard">
								<div class="navbar">
									<div class="navbar-inner">
										<div class="tabDiv">
											<ul>
												<li>
													<a href="#tab1" data-toggle="tab">
														<span class="stepper">Step 01</span>
														<s:message code="mail.reservation_alarm.setting"/>
													</a>
												</li>
												<li>
													<span class="stepperimg">  &#10148;</span>
												</li>
												<li>
													<a href="#tab2" data-toggle="tab">
														<span class="stepper">Step 02</span>
														<s:message code="mail.select.form"/>
													</a>
												</li>
												<li>
													<span class="stepperimg">  &#10148; </span>
												</li>
												<li>
													<a href="#tab3" data-toggle="tab">
														<span class="stepper">Step 03</span>
														<s:message code="condition.select.condition"/>
													</a>
												</li>
											</ul>
										</div>
									</div>
								</div>
						<%--		<p class="txt_right fs12">
									<span class="red_dot veralign_middle"></span>
									<s:message code="mail.input.item"/>
								</p>--%>
								<!-- 탭 -->

								<div class="tab-content modalbody">
									<!--예약 알림 설정-->
									<div class="tab-pane" id="tab1">
										<div class="progress">
											<div class="progress-bar progress-bar-striped" role="progressbar"
											     aria-valuenow="33" aria-valuemin="0" aria-valuemax="100"
											     style="width: 33%;">
												1<s:message code="mail.step"/>
											</div>
										</div>

										<div class="row">
											<div class="col-35">
												<label for="fname"><s:message code="mail.reservation.name"/></label>
												<%--<span class="red_dot"></span>--%>
											</div>
											<div class="col-65">
												<input type="text" class="w100" name="alarmName" id="alarmName"
												       placeholder="<s:message code="mail.reservation.name"/>"
												       maxlength="256">
												<input type="hidden" class="w100" name="alarmSeq" id="alarmSeq"/>
											</div>
										</div>

										<div class="row" id="">
											<div class="col-35">
												<label for=""><s:message code="common.msg.useyn"/></label>
											</div>
											<div class="col-65">
												<div class="radiotab w100">
													<label class="w50">
														<input type="radio" name="useYnVal" value="Y" checked><span
															class="fa fa-check"><span class="text">
														<s:message code="common.msg.use"/></span></span></label><label
														class="w50">
													<input type="radio" name="useYnVal" value="N"><span
														class="fa fa-check"><span class="text">
													    <s:message code="common.msg.unuse"/></span></span></label>
													<input type="hidden" name="useYn" id="useYn">
												</div>
											</div>
										</div>
										<div class="row" id="alarmType">
											<div class="col-35">
												<label for="alarmType"><s:message code="mail.alarm_type"/></label>
											</div>
											<div class="col-65">
												<div class="radiotab w100">
													<label class="w33">
														<input type="checkbox" name="alarmType" value="E" checked><span
															class="fa fa-check"><span class="text">
														<s:message code="mail.msg"/></span></span></label><label
														class="w33">
													<input type="checkbox" name="alarmType" value="S"><span
														class="fa fa-check"><span class="text">
														SMS</span></span></label><label class="w33">
													<input type="checkbox" name="alarmType" value="M"><span
														class="fa fa-check"><span class="text">
														<s:message code="mail.alert_message"/></span></span></label>
													<input type="hidden" name="alarmMailYn" id="alarmMailYn"/>
													<input type="hidden" name="alarmSmsYn" id="alarmSmsYn"/>
													<input type="hidden" name="alarmMonitorYn" id="alarmMonitorYn"/>
												</div>
											</div>
										</div>

										<div class="row" id="alarmCycleGroup">
											<div class="col-35">
												<label for="alarmCycleVal"><s:message
														code="mail.execute_cycle"/></label>
											<%--	<span class="red_dot"></span>--%>
											</div>
											<div class="col-65">
												<div class="radiotab w100">
													<label class="w33">
														<input type="radio" name="alarmCycleVal" value="W" checked><span
															class="fa fa-check"><span class="text">
														<s:message
																code="common.msg.everyweek"/></span></span></label><label
														class="w33">
													<input type="radio" name="alarmCycleVal" value="D"><span
														class="fa fa-check"><span class="text">
														<s:message
																code="common.msg.everyday"/></span></span></label><label
														class="w33">
													<input type="radio" name="alarmCycleVal" value="H"><span
														class="fa fa-check"><span class="text">
														<s:message code="common.msg.everyhour"/></span></span></label>
													<input type="hidden" name="alarmCycle" id="alarmCycle">
												</div>
											</div>
										</div>

										<div class="row">
											<div class="col-35">
												<label for="alarmTime"><s:message code="mail.execute_time"/></label>
											</div>
											<div class="col-65">
												<div id="alarmTimeDiv"></div>
											</div>
										</div>


									</div>
									<!--//예약 알림 설정-->

									<!--서식 선택-->
									<div class="tab-pane" id="tab2">
										<div class="progress">
											<div class="progress-bar progress-bar-striped" role="progressbar"
											     aria-valuenow="66" aria-valuemin="0" aria-valuemax="100"
											     style="width: 66%;">
												2<s:message code="mail.step"/>
											</div>
										</div>
										<div id="alertField" class="row">
											<div class="col-35">
												<label class=""><s:message code="mail.alarm_type"/></label>
											</div>
											<div class="col-65">
												<div class="infotxt"><s:message code="mail.message.selectform"/></div>
											</div>
										</div>

										<div id="mailField" class="row">
											<div class="col-35">
												<label for="alarmTo"><s:message
														code="mail.recv"/></label><%--<span class="red_dot"></span>--%>
											</div>
											<div class="col-65">
												<input type="text" class="input-sm w75" name="alarmTo"
													   id="alarmTo" readonly="readonly"/>
												<button class="form_btn03" type="button"
														accesskey="T" id="alarmToBtn"><s:message
														code="consent.select"/></button>
											</div>
											<div class="clear pt16"></div>
											<div class="col-35">
												<label for="alarmCCMail"><s:message
														code="mail.recv.cc"/></label>
											</div>
											<div class="col-65">
												<input type="text" class="w75 input-sm" name="alarmCC"
													   id="alarmCC" readonly="readonly"/>
												<button class="form_btn03" type="button"
														accesskey="B" id="alarmCCBtn"><s:message
														code="consent.select"/></button>
											</div>
											<div class="clear pt16"></div>
											<div class="col-35">
												<label for="mailFormSelBtn"><s:message
														code="mail.form.mail"/></label><%--<span class="red_dot"></span>--%>
											</div>
											<div class="col-65">

												<input type="text" class="w75 input-sm" name="formSubject"
													   id="formSubject" readonly="readonly"/>
												<input type="hidden" class="w75" name="alarmFormSeq"
													   id="alarmFormSeq"/>
												<button class="form_btn03" type="button"
														accesskey="M" id="mailFormSelBtn"><s:message
														code="consent.select"/></button>

											</div>
											<div class="clear pt16"></div>
											<div class="col-35"  id="csvYnGroup">
												<label for="csvYnVal"><s:message
														code="mail.file_type.attach"/></label>
											</div>
											<div class="col-65">
												<div class="radiotab w100">
													<label class="w50">
														<input type="radio" name="csvYn" value="Y" checked><span
															class="fa fa-check"><span class="text">
														XLSX</span></span></label><label
														class="w50">

													<input type="radio" name="csvYn" value="N"><span
														class="fa fa-check"><span class="text">
													    CSV</span></span></label>

												</div>
											</div>
											<!--<div class="col-65">
												<div>
													<label  class="col-sm-4 radio-inline c-radio">
														<input type="radio" name="csvYn" value="N" checked>
														<span class="fa fa-check"></span>XLSX
													</label>

													<label class="radio-inline c-radio"><input type="radio" name="csvYn" value="Y">
														<span class="fa fa-check"></span>CSV</label>
												</div>

												<p class="infotxt"> <s:message code="mail.max.cnt"/>
													<input type="text" class="input-sm" id="excelMaxCnt"
														   name="excelMaxCnt"></p>

											</div>-->



										</div>


										<!-- old
										<div id="mailField">

											<div class="form-inline">
												<label for="alarmTo" class=" col-xs-4">*<s:message
														code="mail.recv"/></label>

												<div class="input-group col-xs-8 mab12">

													<input type="text" class="input-sm w99" name="alarmTo"
													       id="alarmTo" readonly="readonly"/>
													<span class="input-group-btn mal16" style="width: 25px;">
															<button class="form_btn03" type="button"
																	accesskey="T" id="alarmToBtn"><s:message
																	code="consent.select"/></button>
													</span>
												</div>
											</div>
											<div class="form-inline">
												<label for="alarmCCMail" class=" col-xs-4"><s:message
														code="mail.recv.cc"/></label>
												<div class="input-group col-xs-8">
														<span class="input-group-btn" style="width: 25px;">
															<button class="btn btn-primary btn-sm" type="button"
															        accesskey="B" id="alarmCCBtn"><s:message
																	code="consent.select"/></button>
														</span>
													<input type="text" class="form-control input-sm" name="alarmCC"
													       id="alarmCC" readonly="readonly"/>
												</div>
											</div>
											<div class="form-inline">
												<label for="mailFormSelBtn" class=" col-xs-4">*<s:message
														code="mail.form.mail"/></label>
												<div class="input-group col-xs-8">
														<span class="input-group-btn" style="width: 25px;">
															<button class="btn btn-primary btn-sm" type="button"
															        accesskey="M" id="mailFormSelBtn"><s:message
																	code="consent.select"/></button>
														</span>
													<input type="text" class="form-control input-sm" name="formSubject"
													       id="formSubject" readonly="readonly"/>
													<input type="hidden" class="form-control" name="alarmFormSeq"
													       id="alarmFormSeq"/>
												</div>
											</div>

											<div class="form-inline" id="csvYnGroup">
												<label for="csvYnVal" class=" col-xs-4"><s:message
														code="mail.file_type.attach"/></label>
												<label  class="col-sm-4 radio-inline c-radio">
													<input type="radio" name="csvYn" value="N" checked>
													<span class="fa fa-check"></span>XLSX
												</label>

												<label class="radio-inline c-radio"><input type="radio" name="csvYn" value="Y">
													<span class="fa fa-check"></span>CSV</label>
												<span> <s:message code="mail.max.cnt"/>
													<input type="text" class="input-sm" id="excelMaxCnt"
														name="excelMaxCnt"></span>
											</div>

										</div>-->
										<div style="display: none;" id="smsField">

											<div class="col-35 fs14 pt8" >
												<label class="">SMS <s:message code="mail.msg.form"/></label>
											</div>
											<div class="col-65 fs14 pt8">
												<p><s:message code="mail.message.setup.sms"/></p>
											</div>

											<!--<div class="form-inline">
												<div class="col-xs-4">
													<label class="">SMS <s:message code="mail.msg.form"/></label>
												</div>
												<div>
													<p><s:message code="mail.message.setup.sms"/></p>
												</div>
											</div>-->
										</div>
										<div style="display: none;" id="monitorField">
											<div class="col-35 fs14 pt8" >
												<label class=""><s:message
														code="mail.alert_message"/></label>
											</div>
											<div class="col-65 fs14 pt8">
												<p><s:message code="mail.message.executed.alert_message"/></p>
											</div>
											<!--<div class="form-inline">
												<label for="smsFormatBtn" class=" col-xs-4"><s:message
														code="mail.alert_message"/></label>
												<p><s:message code="mail.message.executed.alert_message"/></p>
											</div>-->
										</div>
										<div class="clear pt8"></div>
										<!--<div class="form-inline" style="text-align: right; font-weight: bold; font-size: 13px;">
											<s:message code="mail.input.item"/>
										</div>-->
									</div>
									<!--//서식 선택-->
									<!-- 조건선택-->
									<div class="tab-pane" id="tab3">
										<div class="progress">
											<div class="progress-bar progress-bar-striped" role="progressbar"
											     aria-valuenow="100" aria-valuemin="" aria-valuemax="100"
											     style="width: 100%;">
												3<s:message code="mail.step"/>
											</div>
										</div>

										<div class="mab12">
											<button type="button" class="form_btn01" id="alarmValBtn" accesskey="L">
												<s:message code="condition.select.condition"/></button>
											<span class="info mal16"><s:message code="mail.set.item"/></span>
										</div>
										<textarea class="form-control" style="display:none" name="alarmVal"
										          id="alarmVal"></textarea>
										<textarea class="form-control" style="height: 230px; margin-top: 1px;"
										          name="alarmValStr" id="alarmValStr" readonly></textarea>
										<!--<div class="form-inline" style="text-align: right; font-weight: bold; font-size: 13px;">
											<span class="red_dot"></span><s:message code="mail.set.item"/>
										</div>-->
									</div>
									<!-- //조건선택-->
									<ul class="pager wizard">
										<li class="previous"><a href="#"><img src="../img/subBtn_arrow_left_12.png"
										                                      class="mar8" alt=""> <s:message
												code="common.msg.prev"/></a></li>
										<li class="next"><a href="#" ><s:message code="common.msg.next"/><img src="../img/subBtn_arrow_right_12.png" class="mal8" alt=""></a></li>
										<li class="next finish"><a href="javascript:;" id="finish"><s:message code="mail.complete"/><img src="../img/subBtn_arrow_right_12.png" class="mal8" alt=""></a></li>
									</ul>
								</div>
								<!-- //탭 -->
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>

<div class="modal" id="resvAlarmLogPop" aria-labelledby="resvAlarmLogPop" data-backdrop="static">
	<div class="modal-content">
		<div class="modalHead">
			<h2><s:message code="mail.excute.list.alarm"/></h2>
			<span class="close" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalCon">
			<div class="modalbody">
				<div class="contentSub" style="padding: 0px;">
					<div id="alarmLogListGrid" class="slickGrid gridArea"  style="height: 400px;">
					</div>
				</div>
			</div>
			<div class="modalfooter">
				<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal">
					<s:message code="common.msg.close"/></button>
			</div>
		</div>
	</div>
</div>




<div>
	<div class="searchArea">
		<div class="searchSub">
			<input type="text" placeholder="<s:message code="mail.message.input.alarm_name"/>" id="searchStr">
			<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.msg.search"/></button>
			<button type="button" class="btn01" id="insertBtn" accesskey="I"><img
					src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
			<button type="button" class="btn02" id="deleteBtn" accesskey="D"><img
					src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
			<button type="button" class="btn03" id="mailFormBtn" accesskey="M">
				<span class="glyphicon glyphicon-import"></span>&nbsp;<s:message code="mail.mgnt.form"/></button>
		</div>
	</div>

	<div class="content">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					예약알림 목록
				</button>
			</div>
			<div id="alarmListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>


<script type="text/javascript">
    var grid = new Xgrid('alarmListGrid', contextRoot);
    grid.onCheckBox();
    grid.autoNumber();
    grid.colAdd('alarmSeq', '<s:message code="mail.reservation.number"/>', 40, 'center', true, 'nomal');
    grid.colAdd('alarmName', '<s:message code="mail.reservation.name"/>', 250, 'left', false, 'link');
    grid.colAdd('alarmType', '<s:message code="mail.reservation.alarm_type"/>', 170, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        var str = value;
        str = str.replace('M', '<s:message code="mail.alert_message"/>');
        str = str.replace('S', 'SMS');
        str = str.replace('E', '<s:message code="mail.msg"/>');
        return str;
    });
    grid.colAdd('alarmCycle', '<s:message code="mail.execute_cycle"/>', 90, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'D') return '<s:message code="common.msg.everyday"/>';
        else if (value == 'H') return '<s:message code="common.msg.everyhour"/>';
        else if (value == 'W') return '<s:message code="common.msg.everyweek"/>';
        return '-';
    });
    grid.colAdd('alarmTime', '<s:message code="mail.execute_time"/>', 120, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (grid.getValue(row, 'alarmCycle') == 'W') {
            return getDayOfWeekText(grid.getValue(row, 'alarmWeek')) + ' <s:message code="condition.clock" arguments="'+value+'" />';
        } else {
            if (value == '24') return '<s:message code="common.msg.everyhour"/>';
            else return '<s:message code="condition.clock" arguments="'+value+'" />';
        }
    });
    grid.colAdd('userNm', '<s:message code="consent.registrant"/>', 130, 'center', false, 'nomal');
    grid.colAdd('alarmTo', '<s:message code="mail.msg"/>(<s:message code="condition.to"/>)', 200, 'left', false, 'nomal');
    grid.colAdd('alarmCC', '<s:message code="mail.msg"/>(<s:message code="condition.cc"/>)', 200, 'left', false, 'nomal');
    grid.colAdd('createDt', '<s:message code="consent.registered.date"/>', 130, 'center', false, 'nomal');
    grid.colAdd('useYn', '<s:message code="common.msg.useyn"/>', 80, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'Y') return '<s:message code="common.msg.use"/>';
        else if (value == 'N') return '<s:message code="common.msg.unuse"/>';
        return '-';
    });
    grid.colAdd('alarmLog', '<s:message code="mail.excute.result"/>', 80, 'center', false, 'link', function (row, cell, value, columnDef, dataContext) {
        return '<s:message code="mail.view.list"/>';
    });

    grid.loadExportMenu('<s:message code="DATA_MONITOR.RESERVATION_ALARM"/>');
    grid.loadHeader(true);
    grid.initData('<s:message code="common.msg.search.click"/>');
    grid.onClick = function () {
        if (grid.Col == grid.ColIndex('alarmName')) {
            var alarmSeq = grid.getRowData(grid.Row).alarmSeq;
            ui.get({
                url: 'getAlarm.xcn',
                alarmSeq: alarmSeq,
                success: function (data, total) {
                    $('#alarmSeq').val(data.alarmSeq);
                    $('#alarmName').val(data.alarmName);
                    $('#alarmTo').val(data.alarmTo);
                    $('#alarmCC').val(data.alarmCC);
                    $('#alarmFormSeq').val(data.alarmFormSeq);
                    $('#alarmVal').val(data.alarmVal);
                    $('#formSubject').val(data.formSubject);
                    $('#excelMaxCnt').val(data.excelMaxCnt);
                    $('[name=useYnVal]').parent().removeClass('active');
                    $('[name=alarmCycleVal]').parent().removeClass('active');
                    $('[name=csvYnVal]').parent().removeClass('active');

                    $('[name=useYnVal][value=' + data.useYn + ']').parent().addClass('active');
                    $('[name=alarmCycleVal][value=' + data.alarmCycle + ']').parent().addClass('active');
                    $('[name=csvYnVal][value=' + data.csvYn + ']').parent().addClass('active');

                    $('input:radio[name=useYnVal]:input[value=' + data.useYn + ']').prop('checked', true);
                    $('input:radio[name=alarmCycleVal]:input[value=' + data.alarmCycle + ']').prop('checked', true);
                    $('input:radio[name=csvYnVal]:input[value=' + data.csvYn + ']').prop('checked', true);
                    alarmCycleChange(data.alarmCycle);

                    if (data.alarmWeek != '') {
                        $('#alarmWeek').val(data.alarmWeek);
                    }
                    if (data.alarmTime != '24') {
                        $('#alarmTime').val(data.alarmTime);
                    }

                    $('[name=alarmType]').prop('checked', false);
                    if (data.alarmType.indexOf('E') > -1 || data.alarmMailYn == 'Y') {
                        $('[name=alarmType][value="E"]').prop('checked', true);
                        $('#mailField').show();
                    }
                    if (data.alarmType.indexOf('S') > -1 || data.alarmSmsYn == 'Y') {
                        $('[name=alarmType][value="S"]').prop('checked', true);
                        $('#smsField').show();
                    }
                    if (data.alarmType.indexOf('M') > -1 || data.alarmMonitorYn == 'Y') {
                        $('[name=alarmType][value="M"]').prop('checked', true);
                        $('#monitorField').show();
                    }
                    $("input:checkbox[name='alarmType']").change();
                    printAlarmValStr(data.alarmCycle, JSON.parse(data.alarmVal));

                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    $(".tabDiv").find("a[href='#tab1']").trigger('click');
                    $('#finish').text('<s:message code="common.msg.modify"/>');
                    $('#resvAlarmPop').attr('mode', 'modify');
                    $("#resvAlarmPop").modal('show');
                }
            });

        }
        if (grid.Col == grid.ColIndex('alarmLog')) {
            var alarmSeq = grid.getRowData(grid.Row).alarmSeq;
            ui.get({
                url: 'getAlarmLog.xcn',
                alarmSeq: alarmSeq,
                success: function (data, total) {
                    gridLog.setData(data);
                    $('#log_total_cnt').html('<s:message code="common.msg.finish_query"/>: ' + gridLog.data.length);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    $("#resvAlarmLogPop").modal('show');
                }
            });
        }
    };
    var gridLog = new Xgrid('alarmLogListGrid', contextRoot);
    gridLog.autoNumber();
    gridLog.colAdd('executeDt', '<s:message code="mail.execute.date"/>', 160, 'center', false, 'nomal');
    gridLog.colAdd('rcnt', '<s:message code="mail.excute.result"/>', 160, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    gridLog.loadExportMenu('<s:message code="mail.excute.list.alarm"/>');
    gridLog.loadHeader(false);
    gridLog.initData('<s:message code="common.msg.search.click"/>');
    gridLog.onClick = function () {
        if (gridLog.Col == gridLog.ColIndex('rcnt')) {
            var alarmLogSeq = gridLog.getRowData(gridLog.Row).alarmLogSeq;
            fnOpenWindow('<c:url value="/ems/alarmLogPop.do" />?alarmLogSeq=' + alarmLogSeq, 'alarmLogPop', 1300, 800, 'fix');
        }
    };
</script>
<script>
    @
    if $enable - transitions {
    @keyframes
        progress - bar - stripes
        {
            0 % {background-position - x
        :
            $progress - height;
        }
        }
    }
</script>
</body>
</html>
