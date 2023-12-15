<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/popupScript.jsp" %>
<%
    String rsUppercase = Config.getString("receiver.sender.uppercase");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>EMASS LTH - <s:message code="condition.select.condition"/></title>
    <style type="text/css">
        * {
            font-size: 12px;
        }

        html, body {
            height: 100%;
            padding: 0px;
            margin: 0px;
            overflow: auto;
            min-width: 650px;
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
            padding-left: 10px;
        }

        .exceptOption {
            top: 5px;
        }

        .form-inline:not(.not-dashed) {
            padding: 5px 0px;
        }

        .bootstrap-select.btn-group .dropdown-toggle .filter-option {
            padding-top: 2px;
        }

        .filterAddBtn {
            padding: 3px 10px;
        }
    </style>
    <script type="text/javascript">
        var infoFeedbackYn = '<%=infoFeedbackYn%>';
        var infoFeedbackConf = '<%=infoFeedbackConf%>';
        var epmsgType = '<%=epmsgType%>';
        var rsUppercase = '<%=rsUppercase%>';
        $(document).ready(function () {
            conditionSetup();
            sizeRangeSetup();

            setSelectpicker();
            initInterestUser();
            initUserGroupList();
            loadCondition();
            initEpmsg();

            if (infoFeedbackConf == 'true' && infoFeedbackYn == 'Y') $('#infoFeedbackDiv, #feedbackBtn, #sctDiv').show();
            else $('#infoFeedbackDiv, #feedbackBtn, #sctDiv').hide();

            if (epmsgType == "") {
                $('#epmsgList').hide();
            } else {
                $('#epmsgList').show();
            }

            $(document).on('click', '.filterAddBtn', function () {
                var code = $(this).attr('id').substring(0, $(this).attr('id').length - 3);
                openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
            });

            $(document).on('keyup', '.condition_input_text', function (e) {
                if ($(this).val() == '') {
                    $(this).parent().find('input:checkbox').prop('disabled', true);
                    $(this).parent().find('input:checkbox').attr('checked', false);
                } else {
                    $(this).parent().find('input:checkbox').prop('disabled', false);
                }
            });

            $(document).on('mouseover', '.codeSelectedBtn', function (e) {
                $('#selectedCodeTitle').show();

                $('#selectedCodeTitle').css('left', e.clientX + 10 + 'px');
                $('#selectedCodeTitle').css('top', e.clientY - 30 + 'px');

                var str = $(this).parent().find('.selectedTitle').val();
                if (str != undefined) str = str.replaceAll('\\|', ',');
                $('#selectedCodeTitle').html(str);
            });

            $(document).on('mousemove', '.codeSelectedBtn', function (e) {
                $('#selectedCodeTitle').css('left', e.clientX + 10 + 'px');
                $('#selectedCodeTitle').css('top', e.clientY - 30 + 'px');

                var str = $(this).parent().find('.selectedTitle').val();
                if (str != undefined) str = str.replaceAll('\\|', ',');
                $('#selectedCodeTitle').html(str);
            });

            $(document).on('mouseout', '.codeSelectedBtn', function (e) {
                $('#selectedCodeTitle').hide();
            });

            $(document).on('click', '.codeSelectedBtn', function (e) {
                resetCode($(this).attr('id').substring(0, $(this).attr('id').length - 12));
                $('#selectedCodeTitle').hide();
            });

            $('#conditionResetBtn').click(function () {
                initCondition();
            });

            $('#conditionSaveBtn').click(function () {
                try {
                    var alarmVal = getCondition();
                    var alarmCycle = opener.$('#alarmCycleGroup input:radio:checked').val();
                    console.log(JSON.stringify(alarmVal))
                    if (alarmVal.startDateSelect == 'T' && alarmVal.endDateSelect == 'Y') {
                        alert('<s:message code="condition.period.inputCheck"/>');
                        return;
                    } else if ((alarmVal.startDateSelect == 'T' && alarmVal.endDateSelect == 'T') || (alarmVal.startDateSelect == 'Y' && alarmVal.endDateSelect == 'Y')) {
                        if (alarmVal.startTimeSelect > alarmVal.endTimeSelect) {
                            alert('<s:message code="condition.period.inputCheck"/>');
                            return;
                        }
                    }
                    opener.$('#alarmVal').val(JSON.stringify(alarmVal));
                    opener.printAlarmValStr(alarmCycle, alarmVal);
                    self.close();
                } catch (e) {
                    alert('<s:message code="common.msg.connect.error"/>');
                    return;
                }
            });

            $('#dept').click(function () {
                var code = $(this).attr('id');
                openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
            });

            if (opener) {
                var condition = opener.$('#alarmVal').val();
                var cycle = opener.$("input:radio[name='alarmCycleVal']:checked").val();
                if (condition.length > 0) {
                    setCondition(JSON.parse(condition));
                }
                setAlarmCycle(cycle);
            } else {
                initCondition();
            }
        });

        function resetCode(codeType) {
            $('#' + codeType + 'Val').val('');
            $('#' + codeType + 'Str').val('');
            $('#' + codeType + 'SelectedArea').hide();
            $('[name=' + codeType + '_not]').prop('disabled', true);
            $('[name=' + codeType + '_not]').prop('checked', false);
        }

        function loadCondition() {
            var alarmCycle = opener.$('#alarmCycleGroup input:radio:checked').val();
            if (alarmCycle == '' || alarmCycle == null) {
                $('#startDateSelect option[value=W]').hide();
                $('#endDateSelect option[value=W]').hide();
            } else {
                $('#startDateSelect option[value=W]').show();
                $('#endDateSelect option[value=W]').show();
            }
            $('#busiSelect').selectpicker({
                size: 'auto',
                searchLabel: true
            }).on("changed.bs.select", function (e) {
                var value = $(this).selectpicker('val');
                if (value == null) {
                    $('[name=busi_not]').prop('disabled', true);
                    $('[name=busi_not]').prop('checked', false);
                } else {
                    $('[name=busi_not]').prop('disabled', false);
                }
            });
            $('#userGroupSeq').selectpicker({
                size: 'auto',
                searchLabel: true
            }).on("changed.bs.select", function (e) {
                var value = $(this).selectpicker('val');
                if (value == '') {
                    $('[name=userGroupSeq_not]').prop('disabled', true);
                    $('[name=userGroupSeq_not]').prop('checked', false);
                } else {
                    $('[name=userGroupSeq_not]').prop('disabled', false);
                }
            });
            $('#interGroup').selectpicker({
                size: 'auto',
                searchLabel: true
            }).on("changed.bs.select", function (e) {
                var value = $(this).selectpicker('val');
                if (value == '') {
                    $('[name=interGroup_not]').prop('disabled', true);
                    $('[name=interGroup_not]').prop('checked', false);
                } else {
                    $('[name=interGroup_not]').prop('disabled', false);
                }
            });
        }

        function initCondition() {
            if ($('#startDateSelect option:selected').val() != 'Y') {
                $('#startDateSelect').selectpicker('val', 'Y');
            }
            if ($('#startTimeSelect option:selected').val() != '00') {
                $('#startTimeSelect').selectpicker('val', '00');
            }
            if ($('#endDateSelect option:selected').val() != 'Y') {
                $('#endDateSelect').selectpicker('val', 'Y');
            }
            if ($('#endTimeSelect option:selected').val() != '23') {
                $('#endTimeSelect').selectpicker('val', '23');
            }

            $('#searchField').selectpicker('val', '');
            $('#searchStrInput').val('');

            checkRadioBtn('receiveSendVal', '');
            checkRadioBtn('ctimeWorkVal', '');
            checkRadioBtn('readYnVal', '');
            checkRadioBtn('receive_option', '');
            checkRadioBtn('regexp_drmYnVal', '');
            checkRadioBtn('realAttYnVal', '');
            checkRadioBtn('regexp_sctYnVal', '');

            $('#serviceTypeSelect').selectpicker('val', '');
            $('#infoTypeSelect').selectpicker('val', '');
            $('#feedbackTypeSelect').selectpicker('val', '');
            $('#probTypeSelect').selectpicker('val', '');

            $('#receivers,#senders,#rcvTo,#rcvCc,#rcvBcc,#url').val('');

            var arr = ['senders', 'receivers', 'rcvTo', 'rcvCc', 'rcvBcc', 'userGroupSeq', 'interGroup', 'busi', 'dept', 'url', 'attach', 'keyword'];
            for (var i = 0; i < arr.length; i++) {
                $('[name=' + arr[i] + '_not]').prop('disabled', true);
                $('[name=' + arr[i] + '_not]').prop('checked', false);
            }

            if (rsUppercase == "Y") {
                $('input:checkbox[name="senders_upperCase"]').prop("disabled", true);
                $('input:checkbox[name="senders_upperCase"]').prop("checked", false);
                $('input:checkbox[name="receivers_upperCase"]').prop("disabled", true);
                $('input:checkbox[name="receivers_upperCase"]').prop("checked", false);
            }

            $('#allOfus').selectpicker('val', '');

            $('#busiSelect').selectpicker('val', []);
            //$('#deptSelect').selectpicker('val', [] );
            $('#deptStr, #deptVal').val('');
            $('#deptSelectedArea').hide();

            $('#interGroup').selectpicker('val', '');
            $('#userGroupSeq').selectpicker('val', []);

            checkRadioBtn('attachYnVal', '');
            $('#attachBtnArea, #attachSelectedArea').hide();
            $('#attachStr, #attachVal').val('');

            checkRadioBtn('keywordYnVal', '');
            $('#keywordBtnArea, #keywordSelectedArea').hide();
            $('#keywordStr, #keywordVal').val('');
            checkRadioBtn('regexpYnVal', '');
            $('#regexpBtnArea, #regexpSelectedArea').hide();
            $('#regexpStr, #regexpVal').val('');
            $('#userGroupStr').val('');

            $('#sizeStartVal').val(0);
            $('#sizeEndVal').val(0);

            $('#epmsgTypeSelect').selectpicker('val', '');

            $('#sizeFilterType').selectpicker('val', '');
            $('#sizeFilterSelect').selectpicker('val', 'L');
            setSizeFilter('size-setup', 'L');
        }

        function checkRadioBtn(name, val) {
            $('input:radio[name=' + name + ']:input[value=' + val + ']').parent().click();
        }

        /**
         * 기간 및 결과내 재검색 조건을 제외한 검색식 조건 생성
         */
        function getCondition() {
            var condition = {};

            var alarmCycle = opener.$('#alarmCycleGroup input:radio:checked').val();

            condition.searchStr = $('#searchStrInput').val();
            condition.searchField = arrayToString($('#searchField').selectpicker('val'));
            condition.serviceFieldNm = $('#searchField').parent().find('button').attr('title');
            condition.serviceType = arrayToString($('#serviceTypeSelect').selectpicker('val'));
            condition.serviceTypeNm = $('#serviceTypeSelect').parent().find('button').attr('title');

            condition.infoType = arrayToString($('#infoTypeSelect').selectpicker('val'));
            condition.infoTypeNm = $('#infoTypeSelect').parent().find('button').attr('title');
            condition.feedbackType = arrayToString($('#feedbackTypeSelect').selectpicker('val'));
            condition.feedbackTypeNm = $('#feedbackTypeSelect').parent().find('button').attr('title');
            condition.probType = arrayToString($('#probTypeSelect').selectpicker('val'));
            condition.probTypeNm = $('#probTypeSelect').parent().find('button').attr('title');

            condition.interGroup = $('#interGroup').selectpicker('val');
            condition.interGroupNm = $('#interGroup option:selected').text();
            condition.userGroupSeq_not = $('[name=userGroupSeq_not]').is(":checked") ? 'Y' : '';

            condition.userGroupSeq = arrayToString($('#userGroupSeq').selectpicker('val'));
            condition.userGroupName = $('#userGroupSeq option:selected').text();
            condition.interGroup_not = $('[name=interGroup_not]').is(":checked") ? 'Y' : '';

            condition.epmsgType = arrayToString($('#epmsgTypeSelect').selectpicker('val'));
            if (alarmCycle != 'H') {
                condition.startDateSelect = $('#startDateSelect option:selected').val();
                condition.endDateSelect = $('#endDateSelect option:selected').val();
            } else {
                condition.startDateSelect = "";
                condition.endDateSelect = "";
            }
            condition.startTimeSelect = $('#startTimeSelect option:selected').val();
            condition.endTimeSelect = $('#endTimeSelect option:selected').val();

            condition.senders = $('#senders').val();
            if (rsUppercase == "Y") {
                condition.senders_upperCase = $('input:checkbox[name="senders_upperCase"]').is(":checked") ? 'Y' : '';
            }
            condition.senders_not = $('[name=senders_not]').is(":checked") ? 'Y' : '';

            if ($('input:radio[name=receive_option]:input:checked').val() == 'detail' && $('#rcvTo').val() == '' && $('#rcvCc').val() == '' && $('#rcvBcc').val() == '') {
                condition.receive_option = '';
            } else condition.receive_option = $('input:radio[name=receive_option]:input:checked').val();

            if ($('input:radio[name=receive_option]:input:checked').val() == '') {
                condition.receivers = $('#receivers').val();
                condition.receivers_not = $('[name=receivers_not]').is(":checked") ? 'Y' : '';
                if (rsUppercase == "Y") {
                    condition.receivers_upperCase = $('input:checkbox[name="receivers_upperCase"]').is(":checked") ? 'Y' : '';
                }
            } else {
                condition.rcvTo = $('#rcvTo').val();
                condition.rcvCc = $('#rcvCc').val();
                condition.rcvBcc = $('#rcvBcc').val();
                condition.rcvTo_not = $('[name=rcvTo_not]').is(":checked") ? 'Y' : '';
                condition.rcvCc_not = $('[name=rcvCc_not]').is(":checked") ? 'Y' : '';
                condition.rcvBcc_not = $('[name=rcvBcc_not]').is(":checked") ? 'Y' : '';
            }

            condition.rcvJikgub = $('#rcvJikgub').val();
            condition.allOfus = $('#allOfus').val();

            condition.busi = arrayToString($('#busiSelect').selectpicker('val'));
            condition.busiNm = $('#busiSelect').parent().find('button').attr('title');
            condition.busi_not = $('[name=busi_not]').is(":checked") ? 'Y' : '';

            condition.dept = $('#deptVal').val();
            condition.deptNm = $('#deptStr').val();
            condition.dept_not = $('[name=dept_not]').is(":checked") ? 'Y' : '';

            condition.url = $('#url').val();
            condition.url_not = $('[name=url_not]').is(":checked") ? 'Y' : '';

            condition.receiveSend = $('input:radio[name=receiveSendVal]:input:checked').val();
            condition.ctimeWork = $('input:radio[name=ctimeWorkVal]:input:checked').val();
            condition.readYn = $('input:radio[name=readYnVal]:input:checked').val();

            condition.attachYn = $('input:radio[name=attachYnVal]:input:checked').val();
            condition.attachVal = $('#attachVal').val();
            condition.attachStr = $('#attachStr').val();
            condition.attachYn_not = $('[name=attach_not]').is(":checked") ? 'Y' : '';

            condition.keywordYn = $('input:radio[name=keywordYnVal]:input:checked').val();
            condition.keywordVal = $('#keywordVal').val();
            condition.keywordStr = $('#keywordStr').val();
            condition.keywordYn_not = $('[name=keyword_not]').is(":checked") ? 'Y' : '';

            condition.regexpYn = $('input:radio[name=regexpYnVal]:input:checked').val();
            condition.regexpVal = $('#regexpVal').val();
            condition.regexpStr = $('#regexpStr').val();

            condition.drmYn = $('input:radio[name=regexp_drmYnVal]:input:checked').val();
            condition.realAttYn = $('input:radio[name=realAttYnVal]:input:checked').val();
            condition.sctYn = $('input:radio[name=regexp_sctYnVal]:input:checked').val();

            condition.sizeStartVal = $('#sizeStartVal').val() * 1024;
            condition.sizeEndVal = $('#sizeEndVal').val() * 1024;
            condition.sizeOption = nvl($('#sizeFilterSelect').selectpicker('val'));
            condition.sizeType = $('#sizeFilterType').val();

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

        function setCondition(alarmVal) {
            $('#searchStrInput').val(alarmVal.searchStr);

            $('#startDateSelect').selectpicker("refresh");
            $('#startDateSelect').selectpicker('val', alarmVal.startDateSelect);
            $('#startDateSelect').selectpicker("refresh");
            $('#startTimeSelect').selectpicker("refresh");
            $('#startTimeSelect').selectpicker('val', alarmVal.startTimeSelect);
            $('#startTimeSelect').selectpicker("refresh");
            $('#endDateSelect').selectpicker("refresh");
            $('#endDateSelect').selectpicker('val', alarmVal.endDateSelect);
            $('#endDateSelect').selectpicker("refresh");
            $('#endTimeSelect').selectpicker("refresh");
            $('#endTimeSelect').selectpicker('val', alarmVal.endTimeSelect);
            $('#endTimeSelect').selectpicker("refresh");

            $('#senders').val(alarmVal.senders);
            $('#receivers').val(alarmVal.receivers);
            $('#rcvTo').val(alarmVal.rcvTo);
            $('#rcvCc').val(alarmVal.rcvCc);
            $('#rcvBcc').val(alarmVal.rcvBcc);
            $('#rcvJikgub').val(alarmVal.rcvJikgub);
            $('#allOfus').selectpicker('val', alarmVal.allOfus);

            $('[name=senders_not]').prop("disabled", alarmVal.senders == '' ? true : false);
            $('[name=senders_not]').prop("checked", alarmVal.senders_not == 'Y' ? true : false);
            if (rsUppercase == "Y") {
                $('input:checkbox[name="senders_upperCase"]').prop("disabled", alarmVal.senders == '' ? true : false);
                $('input:checkbox[name="senders_upperCase"]').prop("checked", alarmVal.senders_upperCase == 'Y' ? true : false);
            }
            $('[name=receivers_not]').prop("disabled", alarmVal.receivers == '' ? true : false);
            $('[name=receivers_not]').prop("checked", alarmVal.receivers_not == 'Y' ? true : false);
            if (rsUppercase == "Y") {
                $('input:checkbox[name="receivers_upperCase"]').prop("disabled", alarmVal.receivers == '' ? true : false);
                $('input:checkbox[name="receivers_upperCase"]').prop("checked", alarmVal.receivers_upperCase == 'Y' ? true : false);
            }
            $('[name=rcvTo_not]').prop("disabled", (alarmVal.rcvTo == '' || alarmVal.rcvTo == null) ? true : false);
            $('[name=rcvTo_not]').prop("checked", alarmVal.rcvTo_not == 'Y' ? true : false);
            $('[name=rcvCc_not]').prop("disabled", (alarmVal.rcvCc == '' || alarmVal.rcvCc == null) ? true : false);
            $('[name=rcvCc_not]').prop("checked", alarmVal.rcvCc_not == 'Y' ? true : false);
            $('[name=rcvBcc_not]').prop("disabled", (alarmVal.rcvBcc == '' || alarmVal.rcvBcc == null) ? true : false);
            $('[name=rcvBcc_not]').prop("checked", alarmVal.rcvBcc_not == 'Y' ? true : false);

            $('[name=userGroupSeq_not]').prop("disabled", alarmVal.userGroupSeq == '' ? true : false);
            $('[name=userGroupSeq_not]').prop("checked", alarmVal.userGroupSeq_not == 'Y' ? true : false);

            $('[name=interGroup_not]').prop("disabled", alarmVal.interGroup == '' ? true : false);
            $('[name=interGroup_not]').prop("checked", alarmVal.interGroup_not == 'Y' ? true : false);

            $('[name=busi_not]').prop("disabled", alarmVal.busi == '' ? true : false);
            $('[name=busi_not]').prop("checked", alarmVal.busi_not == 'Y' ? true : false);

            $('[name=dept_not]').prop("disabled", alarmVal.dept == '' ? true : false);
            $('[name=dept_not]').prop("checked", alarmVal.dept_not == 'Y' ? true : false);

            $('[name=url_not]').prop("disabled", alarmVal.url == '' ? true : false);
            $('[name=url_not]').prop("checked", alarmVal.url_not == 'Y' ? true : false);

            $('[name=attach_not]').prop("disabled", (alarmVal.attachYn == 'Y' && alarmVal.attachVal != '') ? false : true);
            $('[name=attach_not]').prop("checked", alarmVal.attachYn_not == 'Y' ? true : false);

            $('[name=keyword_not]').prop("disabled", (alarmVal.keywordYn == 'Y' && alarmVal.keywordVal != '') ? false : true);
            $('[name=keyword_not]').prop("checked", alarmVal.keywordYn_not == 'Y' ? true : false);

            checkRadioBtn('receive_option', alarmVal.receive_option);

            checkRadioBtn('readYnVal', alarmVal.readYn);
            checkRadioBtn('receiveSendVal', alarmVal.receiveSend);
            checkRadioBtn('ctimeWorkVal', alarmVal.ctimeWork);

            checkRadioBtn('attachYnVal', alarmVal.attachYn);
            if (alarmVal.attachVal != "") {
                $('#attachVal').val(alarmVal.attachVal);
                setSelectedCodeData("attach", alarmVal.attachVal, alarmVal.attachStr);
            }

            checkRadioBtn('keywordYnVal', alarmVal.keywordYn);
            if (alarmVal.keywordVal != "") {
                $('#keywordVal').val(alarmVal.keywordVal);
                setSelectedCodeData("keyword", alarmVal.keywordVal, alarmVal.keywordStr);
            }

            checkRadioBtn('regexpYnVal', alarmVal.regexpYn);
            if (alarmVal.regexpVal != "") {
                $('#regexpVal').val(alarmVal.regexpVal);
                setSelectedCodeData("regexp", alarmVal.regexpVal, alarmVal.regexpStr);
            }
            if (alarmVal.dept != "") {
                $('#deptVal').val(alarmVal.dept);
                $('#deptStr').val(alarmVal.deptNm);
            }

            if (alarmVal.url != "") $('#url').val(alarmVal.url);

            checkRadioBtn('regexp_drmYnVal', alarmVal.drmYn);
            checkRadioBtn('realAttYnVal', alarmVal.realAttYn);
            checkRadioBtn('regexp_sctYnVal', alarmVal.sctYn);

            $('#sizeStartVal').val(alarmVal.sizeStartVal);
            $('#sizeEndVal').val(alarmVal.sizeEndVal);
            var size_slider = document.getElementById('size-setup');
            setSizeFilter('size-setup', alarmVal.sizeOption);

            $('#sizeFilterSelect').val(alarmVal.sizeOption);
            $('#sizeFilterType').val(alarmVal.sizeType);

            $('#sizeFilterSelect').selectpicker("refresh");

            setTimeout(function () {
                $('#serviceTypeSelect').selectpicker('val', stringToArray(alarmVal.serviceType));
                $('#serviceTypeSelect').selectpicker("refresh");
                $('#infoTypeSelect').selectpicker('val', stringToArray(alarmVal.infoType));
                $('#infoTypeSelect').selectpicker("refresh");
                $('#feedbackTypeSelect').selectpicker('val', stringToArray(alarmVal.feedbackType));
                $('#feedbackTypeSelect').selectpicker("refresh");
                $('#probTypeSelect').selectpicker('val', stringToArray(alarmVal.probType));
                $('#probTypeSelect').selectpicker("refresh");
                $('#busiSelect').selectpicker('val', stringToArray(alarmVal.busi));
                $('#busiSelect').selectpicker("refresh");
                $('#searchField').selectpicker('val', stringToArray(alarmVal.searchField));
                $('#searchField').selectpicker("refresh");
                //$('#deptSelect').selectpicker('val', stringToArray(alarmVal.dept) );
                //$('#deptSelect').selectpicker( "refresh" );

                if ($('#deptVal').val() != '') $('#deptSelectedArea').show();

                else $('#deptSelectedArea').hide();

                $('#interGroup').selectpicker('val', alarmVal.interGroup);
                $('#interGroup').selectpicker("refresh");

                $('#userGroupSeq').selectpicker('val', alarmVal.userGroupSeq);
                $('#userGroupSeq').selectpicker("refresh");

                $('#epmsgTypeSelect').selectpicker('val', stringToArray(alarmVal.epmsgType));
                $('#epmsgTypeSelect').selectpicker("refresh");
            }, 500);
        }

        //사이즈 필터 공통 설정 function
        function setSizeFilter(id, val) {
            var sizeIds = {
                sizeRangeValStr: 'sizeRangeValStr',
                sizeStartValStr: 'sizeStartValStr',
                sizeEndValStr: 'sizeEndValStr',
                sizeStartVal: 'sizeStartVal',
                sizeEndVal: 'sizeEndVal'
            };

            var size_slider = document.getElementById(id);
            if (size_slider.noUiSlider != undefined) size_slider.noUiSlider.destroy();
            $('#' + sizeIds.sizeRangeValStr).hide();
            $('#' + sizeIds.sizeEndValStr).hide();
            var options = {};
            if (val == 'B') {
                options = {
                    start: [$('#' + sizeIds.sizeStartVal).val() / 1024, $('#' + sizeIds.sizeEndVal).val() == 0 ? 10485760 : $('#' + sizeIds.sizeEndVal).val() / 1024],
                    behaviour: 'drag-tap',
                    connect: true,
                    range: {
                        'min': [0],
                        'max': [10485760]
                    }
                };

                var sizeValues = [
                    document.getElementById(sizeIds.sizeStartVal),
                    document.getElementById(sizeIds.sizeEndVal)
                ];
                var sizeStrValues = [
                    document.getElementById(sizeIds.sizeStartValStr),
                    document.getElementById(sizeIds.sizeEndValStr)
                ];
                noUiSlider.create(size_slider, options);
                size_slider.noUiSlider.on('update', function (values, handle) {
                    var value = parseInt(values[handle]);
                    sizeValues[handle].value = value;
                    sizeStrValues[handle].innerHTML = convertFileSizeByKBps(value);
                });
                $('#' + sizeIds.sizeRangeValStr).show();
                $('#' + sizeIds.sizeEndValStr).show();
            } else if (val == 'L') {
                options = {
                    start: $('#' + sizeIds.sizeStartVal).val() / 1024,
                    connect: 'upper',
                    range: {
                        'min': 0,
                        'max': 10485760
                    }
                };

                noUiSlider.create(size_slider, options);
                size_slider.noUiSlider.on('update', function (values, handle) {
                    var value = parseInt(values[handle]);
                    $('#' + sizeIds.sizeStartVal).val(value);
                    $('#' + sizeIds.sizeEndVal).val(0);
                    $('#' + sizeIds.sizeStartValStr).html(convertFileSizeByKBps(value));
                });

            } else if (val == 'S') {
                options = {
                    start: $('#' + sizeIds.sizeStartVal).val() / 1024,
                    connect: 'lower',
                    range: {
                        'min': 0,
                        'max': 10485760
                    }
                };

                noUiSlider.create(size_slider, options);
                size_slider.noUiSlider.on('update', function (values, handle) {
                    var value = parseInt(values[handle]);
                    $('#' + sizeIds.sizeStartVal).val(value);
                    $('#' + sizeIds.sizeEndVal).val(0);
                    $('#' + sizeIds.sizeStartValStr).html(convertFileSizeByKBps(value));
                });
            }
        }

        function sizeRangeSetup() {
            var size_slider = document.getElementById('size-setup');
            noUiSlider.create(size_slider, {
                start: [0],
                connect: 'upper',
                step: 1,
                range: {
                    'min': [0],
                    'max': [1073741824]
                }
            });
            size_slider.noUiSlider.on('update', function (values, handle) {
                var value = parseInt(values[handle]);
                $('#sizeStartVal').val(value);
                $('#sizeEndVal').val(0);
                $('#sizeStartValStr').html(convertFileSizeByKBps(value));
            });

            document.getElementById('sizeStartVal').addEventListener('change', function () {
                size_slider.noUiSlider.set([this.value, null]);
            });
            document.getElementById('sizeEndVal').addEventListener('change', function () {
                size_slider.noUiSlider.set([null, this.value]);
            });

            $('#sizeStartValStr').click(function () {
                $(this).hide();
                $('#sizeStartVal').show();
                $('#sizeStartVal').focus();
            });
            $('#sizeStartVal').focusout(function () {
                $(this).hide();
                $('#sizeStartValStr').show();
            });
            $('#sizeEndValStr').click(function () {
                $(this).hide();
                $('#sizeEndVal').show();
                $('#sizeEndVal').focus();
            });
            $('#sizeEndVal').focusout(function () {
                $(this).hide();
                $('#sizeEndValStr').show();
            });

            $('#sizeFilterSelect').change(function () {
                setSizeFilter('size-setup', $(this).val());
            });
        }

        function conditionSetup() {
            $('input[name="receive_option"]:radio').change(function () {
                if ($(this).val() == '') {
                    $('.receivers_default').show();
                    $('.receivers_detail').hide();
                } else {
                    $('.receivers_default').hide();
                    $('.receivers_detail').show();
                }
            });
            $('input[name="attachYnVal"]:radio').change(function () {
                if ($(this).val() == 'Y') {
                    $('#attachBtnArea').show();

                    $('input:radio[name=realAttYnVal]').prop('disabled', false);
                    $('input:radio[name=regexp_drmYnVal]').prop('disabled', false);
                } else {
                    $('#attachBtnArea, #attachSelectedArea').hide();
                    $('#attachStr, #attachVal').val('');

                    $('input:radio[name=realAttYnVal]').prop('disabled', true);
                    $('input:radio[name=regexp_drmYnVal]').prop('disabled', true);
                    $('input:radio[name=realAttYnVal]:input[value=' + idIndicator('') + ']').prop("checked", true);
                    $('input:radio[name=regexp_drmYnVal]:input[value=' + idIndicator('') + ']').prop("checked", true);
                }

            });
            $('input[name="keywordYnVal"]:radio').change(function () {
                if ($(this).val() == 'Y') $('#keywordBtnArea').show();
                else {
                    $('#keywordBtnArea, #keywordSelectedArea').hide();
                    $('#keywordStr, #keywordVal').val('');
                }
            });
            $('input[name="regexpYnVal"]:radio').change(function () {
                if ($(this).val() == 'Y') $('#regexpBtnArea').show();
                else {
                    $('#regexpBtnArea, #regexpSelectedArea').hide();
                    $('#regexpStr, #regexpVal').val('');
                }
            });

            $('#searchField').selectpicker({
                container: 'body',
                width: '200px',
                noneSelectedText: '<s:message code="common.msg.all"/>'
            });

            var width = '200px';

            $('#serviceTypeSelect').selectpicker({
                container: 'body',
                size: 15,
                width: width,
                searchLabel: true,
                noneSelectedText: '<s:message code="condition.service.all"/>',
                noneResultsText: '<s:message code="common.msg.noresult"/> ',
                selectAllText: '<s:message code="common.msg.select_all"/>',
                deselectAllText: '<s:message code="common.msg.unselect_all"/>'
            });

            $('#infoTypeSelect').selectpicker({
                container: 'body',
                size: 15,
                width: width,
                searchLabel: true,
                noneSelectedText: '<s:message code="condition.infotype.all"/>',
                noneResultsText: '<s:message code="common.msg.noresult"/> ',
                selectAllText: '<s:message code="common.msg.select_all"/>',
                deselectAllText: '<s:message code="common.msg.unselect_all"/>'
            });

            $('#feedbackTypeSelect').selectpicker({
                container: 'body',
                size: 15,
                width: width,
                searchLabel: true,
                noneSelectedText: '<s:message code="condition.feedback.all"/>',
                noneResultsText: '<s:message code="common.msg.noresult"/> ',
                selectAllText: '<s:message code="common.msg.select_all"/>',
                deselectAllText: '<s:message code="common.msg.unselect_all"/>'
            });

            $('#probTypeSelect').selectpicker({
                container: 'body',
                size: 15,
                width: width,
                searchLabel: true,
                noneSelectedText: '<s:message code="condition.prob.all"/>',
                noneResultsText: '<s:message code="common.msg.noresult"/> ',
                selectAllText: '<s:message code="common.msg.select_all"/>',
                deselectAllText: '<s:message code="common.msg.unselect_all"/>'
            });

            $('#sizeFilterSelect').selectpicker({
                container: 'body'
            });

            $('#busiSelect').selectpicker({
                container: 'body',
                size: 15,
                width: width,
                searchLabel: true,
                noneSelectedText: '<s:message code="common.org.busi.all"/>',
                noneResultsText: '<s:message code="common.msg.noresult"/> ',
                selectAllText: '<s:message code="common.msg.select_all"/>',
                deselectAllText: '<s:message code="common.msg.unselect_all"/>'
            });

            getCount('dept');
            getCount('attach');
            getCount('keyword');
            getCount('regexp');

            function getCount(id) {
                setTimeout(function () {
                    if ($('#' + id + 'Str').val() != '') {
                        var l = $('#' + id + 'Str').val().split(',').length;
                        $('#' + id + 'SelectedArea').find('.btn').text(l);
                        $('#' + id + 'SelectedArea').show();
                    } else {
                        $('#' + id + 'SelectedArea').find('.btn').text(0);
                        $('#' + id + 'SelectedArea').hide();
                    }
                }, 100);
            }

            $('#allOfus').selectpicker({
                container: 'body',
                width: width
            });
        }

        function setSelectpicker() {
            getCodeList('busi');
            getServiceTypeList();
        }

        var serviceGroups = [];
        var serviceTypes = [];
        var specialService = [];
        var parentCode = [];

        function getServiceGroupList() {
            var str = '';
            for (var i = 0; i < serviceTypes.length; i++) {
                if (str.indexOf(serviceTypes[i].groupCd) == -1) {
                    str += serviceTypes[i].groupCd + ',';
                }
                if (serviceTypes[i].serviceCd.length == 4) {
                    specialService.push(serviceTypes[i]);
                }
            }
            serviceGroups = str.substring(0, str.length - 1).split(',');

            $('#serviceTypeSelect').html(getServiceOptionStr());
            getServiceOptionLiveSearch(parentCode);
            $('#serviceTypeSelect').selectpicker('refresh');
        }

        function getServiceTypeList() {
            ui.get({
                url: 'getServiceListByAuth.xcn',
                success: function (data, total) {
                    serviceTypes = data;
                    getServiceGroupList();
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        function getServiceOptionStr() {
            var str = '';
            for (var i = 0; i < serviceGroups.length; i++) {
                var selectedVal = serviceGroups[i];
                var idx = 0;
                for (var j = 0; j < serviceTypes.length; j++) {
                    if (selectedVal == serviceTypes[j].groupCd) {
                        if (idx == 0) {
                            str += '<optgroup label="' + serviceTypes[j].groupNm + '">';
                        }
                        if (serviceTypes[j].serviceCd.length == 3) {
                            str += getServiceOptionChildren(serviceTypes[j]);
                        } else if (serviceTypes[j].serviceCd.length == 4) continue;
                        else str += '<option value="' + serviceTypes[j].serviceCd + '">' + serviceTypes[j].serviceNm + '</option>';
                        idx++;
                    }
                }
                if (idx != 0) str += '</optgroup>';
            }
            return str;
        }

        function getServiceOptionChildren(serviceType) {
            var result = '<option value="' + serviceType.serviceCd + '">' + serviceType.serviceNm + '</option>';
            for (var i = 0; i < specialService.length; i++) {
                var service = specialService[i];
                if (service.serviceCd.indexOf(serviceType.serviceCd) > -1) {
                    if (!parentCode.includes(serviceType.serviceCd)) parentCode.push(serviceType.serviceCd);
                    result += '<option value="' + service.serviceCd + '"> └ ' + service.serviceNm + '</option>';
                }
            }

            return result;
        }

        function getServiceOptionLiveSearch(code) {
            var searchWord = "";

            for (var i = 0; i < code.length; i++) {
                var pCode = code[i];
                for (var j = 0; j < specialService.length; j++) {
                    if (specialService[j].serviceCd.indexOf(pCode) > -1) {
                        searchWord += specialService[j].serviceNm + " ";
                    }
                }
                $('[value=' + pCode + ']').attr('data-tokens', searchWord);
                searchWord = "";
            }
        }

        function getCodeList(codeType) {
            ui.get({
                url: 'getCodeList.xcn',
                codeType: codeType,
                success: function (data, total) {
                    $('#' + codeType + 'Select').html(getSelectOption(data));
                    $('#' + codeType + 'Select').selectpicker('refresh');
                },
                error: function (status, message) {
                    ui.alertMsg(message);
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

        function initInterestUser() {
            ui.get({
                url: 'getAdminUserGroupList.xcn',
                success: function (data, total) {
                    getInterestUserOptions(data, '');
                },
                error: function (status, message) {
                    //ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        function initUserGroupList() {
            ui.get({
                url: 'getUserGroupList.xcn',
                logYn: 'Y',
                success: function (data, total) {
                    getUserGroupListOptions(data, '');
                },
                error: function (status, message) {
                    //ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        /**
         *  대외비 목록 조회
         */
        function initEpmsg() {
            $('#epmsgTypeSelect').selectpicker({
                container: 'body',
                size: 15,
                width: '415px',
                noneSelectedText: '<s:message code="condition.epmsgType.all"/>',
                noneResultsText: '<s:message code="common.msg.noresult"/> ',
                selectAllText: '<s:message code="common.msg.select_all"/>',
                deselectAllText: '<s:message code="common.msg.unselect_all"/>'
            });
            var epmsg_type = epmsgType.split(',');
            var result = '';
            for (var i = 0; i < epmsg_type.length; i++) {
                result += '<option value="' + epmsg_type[i] + '">' + epmsg_type[i] + '</option>';
            }
            $("#epmsgTypeSelect").html(result);
            $("#epmsgTypeSelect").selectpicker('refresh');
        }

        /**
         * 관심사용자 리스트 조회
         */
        function getInterestUserOptions(data) {

            $('#interGroup').selectpicker({
                container: 'body',
                width: '412px',
                noneSelectedText: '-<s:message code="condition.select.interest"/>-'
            });

            var result = '<option value="">-<s:message code="condition.select.interest"/>-</option>';
            for (var i = 0; i < data.length; i++) {
                result += '<option value="' + data[i].groupSeq + '">' + data[i].groupName + '</option>';
            }
            $("#interGroup").html(result);
            $("#interGroup").selectpicker('refresh');
        }

        function getUserGroupListOptions(data) {
            $('#userGroupSeq').selectpicker({
                container: 'body',
                width: '412px',
                noneSelectedText: '-<s:message code="userGroup.navi.title2"/>-'
            });

            var result = '<option value="">-<s:message code="userGroup.navi.title2"/>-</option>';
            for (var i = 0; i < data.length; i++) {
                result += '<option value="' + data[i].groupCode + '">' + data[i].groupName + '</option>';
            }
            $("#userGroupSeq").html(result);
            $("#userGroupSeq").selectpicker('refresh');
        }

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
            if (data.length == 0) {
                if (codeType == 'dept') {
                    $('[name=dept_not]').prop('disabled', true);
                    $('[name=dept_not]').prop('checked', false);
                } else {
                    $('[name=' + codeType + '_not]').prop('disabled', true);
                    $('[name=' + codeType + '_not]').prop('checked', false);
                }
            } else {
                if (codeType == 'dept') {
                    $('[name=dept_not]').prop('disabled', false);
                } else {
                    $('[name=' + codeType + '_not]').prop('disabled', false);
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

        function setSelectedCodeData(codeType, val, str) {
            if (val != '') {
                str = str.rtrim();
                val = val.trimAll();
            }

            $('#' + codeType + 'Str').val(str);
            $('#' + codeType + 'Val').val(val);

            if ($('#' + codeType + 'Str').val() != '') {
                $('#' + codeType + 'SelectedArea').show();
            } else {
                $('#' + codeType + 'SelectedArea').hide();
            }
        }

        function setAlarmCycle(cycle) {
            if (cycle == "H") {
                $('#time_msg').show();
                $('#day_msg').hide();
                $('label[for=day_msg]').css('padding-top', '0px');
            } else {
                $('#time_msg').hide();
                $('#day_msg').show();
            }
        }

        function openWindow(id) {
            var url = '<c:url value="/commons/selectCodeAll.do?codeType='+id+'"/>';
            var pop = fnOpenWindow('', 'selectCodeWinPopup', 860, 500, 'resize');
            $('#deptForm').attr('target', 'selectCodeWinPopup');
            $('#deptForm').attr('action', url);
            $('#deptForm').attr('method', 'post');
            $('#deptForm').submit();
        }
    </script>
</head>
<bodyclass
="modal-content">
<div class="modalHead">
    <h2 class="ma_none"><s:message code="condition.select.condition.search"/></h2>
    <div class="btnBox">
        <button type="button" class="form_btn02" accesskey="R" id="conditionResetBtn"><s:message
                code="condition.reset"/></button>
        <button type="button" class="form_btn01_02" accesskey="S" id="conditionSaveBtn"><s:message
                code="condition.select"/></button>
    </div>
</div>
<div class="modalCon">
    <div>
        <div class="content_body">
            <div id="selectedCodeTitle"></div><!-- selectedCodeTitle: 선택된 코드 개수표시용 -->
            <div class="row">
                <ul class="col-sm-12">
                    <li>
                        <label for="searchField" class="col-xs-3"><s:message code="condition.field.search"/></label>
                        <select id="searchField" title="<s:message code="condition.field.search.all"/>"
                                class="selectpicker" data-style="btn-default" multiple data-show-subtext="true"
                                data-actions-box="true" data-live-search="true">
                            <option value="subject"><s:message code="condition.subject"/></option>
                            <option value="body"><s:message code="condition.body"/></option>
                            <option value="attachname attachname_str"><s:message code="condition.attach_name"/></option>
                            <%if (!isOCR) { %>
                            <option value="attach"><s:message code="condition.attach"/></option>
                            <%} else { %>
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
                            <option value="bcc bname"><s:message code="condition.recv"/>(<s:message
                                    code="condition.bcc"/>)
                            </option>
                            <option value="user user_str userid name"><s:message code="common.org.user"/></option>
                            <option value="usr_id"><s:message code="common.msg.account"/></option>
                        </select>
                        <input type="search" class="" id="searchStrInput"
                               placeholder="<s:message code="condition.search_str"/>"/>
                    </li>
                    <li>
                        <label for="serviceTypeSelect" class="col-xs-3"><s:message
                                code="condition.service"/></label>
                        <select id="serviceTypeSelect" class="selectpicker col-xs" data-style="btn-default btn-sm"
                                multiple data-show-subtext="true" data-live-search="true"
                                data-actions-box="true"></select>
                    </li>

                    <li id="epmsgList">
                        <label for="epmsgTypeSelect" class="col-xs-3"><s:message
                                code="condition.epmsgType.list"/></label>
                        <select id="epmsgTypeSelect" class="selectpicker col-xs" data-style="btn-default btn-sm"
                                multiple data-show-subtext="true" data-live-search="true"
                                data-actions-box="true"></select>
                    </li>

                    <li>
                        <label for="day_msg" class="col-xs-3"><s:message
                                code="condition.period.setting"/></label>
                        <div id="day_msg" style="display:inline-flex;">
                            <div class="selecBtnArea" style="width:auto;float: left;">
                                <select class="selectpicker col-xs" data-style="btn-primary" id="startDateSelect"
                                        style="width: 1000px;">
                                    <option value="Y" selected><s:message code="condition.yesterday_str"/></option>
                                    <option value="T"><s:message code="condition.today_str"/></option>
                                    <option value="W"><s:message code="condition.sevenago"/></option>
                                </select>
                            </div>
                            <div class="selecBtnArea" style="width:auto; padding-left: 3px;float: left;">
                                <select class="selectpicker col-xs" data-style="btn-primary" id="startTimeSelect">
                                    <option value="00" selected><s:message code="condition.clock"
                                                                           arguments="0"/></option>
                                    <option value="01"><s:message code="condition.clock" arguments="1"/></option>
                                    <option value="02"><s:message code="condition.clock" arguments="2"/></option>
                                    <option value="03"><s:message code="condition.clock" arguments="3"/></option>
                                    <option value="04"><s:message code="condition.clock" arguments="4"/></option>
                                    <option value="05"><s:message code="condition.clock" arguments="5"/></option>
                                    <option value="06"><s:message code="condition.clock" arguments="6"/></option>
                                    <option value="07"><s:message code="condition.clock" arguments="7"/></option>
                                    <option value="08"><s:message code="condition.clock" arguments="8"/></option>
                                    <option value="09"><s:message code="condition.clock" arguments="9"/></option>
                                    <option value="10"><s:message code="condition.clock" arguments="10"/></option>
                                    <option value="11"><s:message code="condition.clock" arguments="11"/></option>
                                    <option value="12"><s:message code="condition.clock" arguments="12"/></option>
                                    <option value="13"><s:message code="condition.clock" arguments="13"/></option>
                                    <option value="14"><s:message code="condition.clock" arguments="14"/></option>
                                    <option value="15"><s:message code="condition.clock" arguments="15"/></option>
                                    <option value="16"><s:message code="condition.clock" arguments="16"/></option>
                                    <option value="17"><s:message code="condition.clock" arguments="17"/></option>
                                    <option value="18"><s:message code="condition.clock" arguments="18"/></option>
                                    <option value="19"><s:message code="condition.clock" arguments="19"/></option>
                                    <option value="20"><s:message code="condition.clock" arguments="20"/></option>
                                    <option value="21"><s:message code="condition.clock" arguments="21"/></option>
                                    <option value="22"><s:message code="condition.clock" arguments="22"/></option>
                                    <option value="23"><s:message code="condition.clock" arguments="23"/></option>
                                </select>
                            </div>
                            <span style="padding: 5px;float: left;">~</span>
                            <div class="selecBtnArea" style="width:auto;float: left; margin-right: 3px;">
                                <select class="selectpicker col-xs" data-style="btn-primary" id="endDateSelect">
                                    <option value="Y" selected><s:message code="condition.yesterday_str"/></option>
                                    <option value="T"><s:message code="condition.today_str"/></option>
                                    <option value="W"><s:message code="condition.sevenago"/></option>
                                </select>
                            </div>
                            <div class="selecBtnArea" style="width:100%; padding-left:3px;">
                                <select class="selectpicker col-xs" data-style="btn-primary" id="endTimeSelect">
                                    <option value="00"><s:message code="condition.time" arguments="0,59,59"/></option>
                                    <option value="01"><s:message code="condition.time" arguments="1,59,59"/></option>
                                    <option value="02"><s:message code="condition.time" arguments="2,59,59"/></option>
                                    <option value="03"><s:message code="condition.time" arguments="3,59,59"/></option>
                                    <option value="04"><s:message code="condition.time" arguments="4,59,59"/></option>
                                    <option value="05"><s:message code="condition.time" arguments="5,59,59"/></option>
                                    <option value="06"><s:message code="condition.time" arguments="6,59,59"/></option>
                                    <option value="07"><s:message code="condition.time" arguments="7,59,59"/></option>
                                    <option value="08"><s:message code="condition.time" arguments="8,59,59"/></option>
                                    <option value="09"><s:message code="condition.time" arguments="9,59,59"/></option>
                                    <option value="10"><s:message code="condition.time" arguments="10,59,59"/></option>
                                    <option value="11"><s:message code="condition.time" arguments="11,59,59"/></option>
                                    <option value="12"><s:message code="condition.time" arguments="12,59,59"/></option>
                                    <option value="13"><s:message code="condition.time" arguments="13,59,59"/></option>
                                    <option value="14"><s:message code="condition.time" arguments="14,59,59"/></option>
                                    <option value="15"><s:message code="condition.time" arguments="15,59,59"/></option>
                                    <option value="16"><s:message code="condition.time" arguments="16,59,59"/></option>
                                    <option value="17"><s:message code="condition.time" arguments="17,59,59"/></option>
                                    <option value="18"><s:message code="condition.time" arguments="18,59,59"/></option>
                                    <option value="19"><s:message code="condition.time" arguments="19,59,59"/></option>
                                    <option value="20"><s:message code="condition.time" arguments="20,59,59"/></option>
                                    <option value="21"><s:message code="condition.time" arguments="21,59,59"/></option>
                                    <option value="22"><s:message code="condition.time" arguments="22,59,59"/></option>
                                    <option value="23" selected><s:message code="condition.time"
                                                                           arguments="23,59,59"/></option>
                                </select>
                            </div>
                        </div>
                        <div id="time_msg" style="display: none;">
                            <span><s:message code="mail.message.condition_info"/></span>
                        </div>
                    </li>
                    <li class="form-inline" id="ctimeWorkGroup">
                        <label for="" class=" col-xs-3">
                            <s:message code="condition.ctimework"/></label>

                        <label class="radio-inline c-radio"><input type="radio" name="ctimeWorkVal" value=""
                                                                   checked><span class="fa fa-check"><span class="text"><s:message
                                code="condition.ctimework.all"/></span></span></label>
                        <label class="radio-inline c-radio"><input type="radio" name="ctimeWorkVal" value="W"><span
                                class="fa fa-check"><span class="text"><s:message code="condition.work"/></span></span></label>
                        <label class="radio-inline c-radio"><input type="radio" name="ctimeWorkVal" value="R"><span
                                class="fa fa-check"><span class="text"><s:message code="condition.notwork"/></span></span></label>
                        <input type="hidden" name="ctimeWork" id="ctimeWork">


                    </li>
                    <li id="infoFeedbackDiv" style="display: none;">
                        <div>
                            <label for="infoTypeSelect" class=" col-xs-3"><s:message
                                    code="condition.infotype"/></label>
                            <select id="infoTypeSelect" class="selectpicker col-xs" data-style="btn-default btn-sm"
                                    multiple data-show-subtext="true" data-live-search="true" data-actions-box="true">
                                <option value="4"><s:message code="condition.info.class4"/></option>
                                <option value="3"><s:message code="condition.info.class3"/></option>
                                <option value="2"><s:message code="condition.info.class2"/></option>
                                <option value="1"><s:message code="condition.info.class1"/></option>
                            </select>
                        </div>

                        <div>
                            <label for="feedbackTypeSelect" class=" col-xs-3"><s:message
                                    code="condition.feedback"/></label>
                            <select id="feedbackTypeSelect" class="selectpicker col-xs" data-style="btn-default btn-sm"
                                    multiple data-show-subtext="true" data-live-search="true" data-actions-box="true">
                                <option value="0"><s:message code="condition.info.feedback0"/></option>
                                <option value="1"><s:message code="condition.info.feedback1"/></option>
                                <option value="2"><s:message code="condition.info.feedback2"/></option>
                                <option value="3"><s:message code="condition.info.feedback3"/></option>
                                <option value="4"><s:message code="condition.info.feedback4"/></option>
                                <option value="9"><s:message code="condition.info.feedback9"/></option>
                                <option value="-1"><s:message code="condition.info.feedback-1"/></option>
                            </select>
                        </div>

                        <div>
                            <label for="probTypeSelect" class=" col-xs-3"><s:message
                                    code="condition.prob"/></label>
                            <select id="probTypeSelect" class="selectpicker col-xs" data-style="btn-default btn-sm"
                                    multiple data-show-subtext="true" data-live-search="true" data-actions-box="true">
                                <option value="0.5|1.1">50 ~ 100</option>
                                <option value="0.1|0.5">10 ~ 49</option>
                                <option value="0|0.1">0 ~ 9</option>
                            </select>
                        </div>
                    </li>
                    <li class="form-inline" id="recvSendGroup">
                        <label for="" class=" col-xs-3"><s:message code="condition.receive_send"/></label>
                        <label class="radio-inline c-radio"><input type="radio" name="receiveSendVal" value=""
                                                                   checked><span class="fa fa-check"><span class="text"><s:message
                                code="common.msg.all"/></span></span></label>
                        <label class="radio-inline c-radio"><input type="radio" name="receiveSendVal" value="I"><span
                                class="fa fa-check"><span class="text"><s:message code="condition.receive"/></span></span></label>
                        <label class="radio-inline c-radio"><input type="radio" name="receiveSendVal" value="O"><span
                                class="fa fa-check"><span class="text"><s:message code="condition.send"/></span></span></label>
                        <input type="hidden" name="receiveSend" id="receiveSend">
                    </li>
                    <li>
                        <label for="senders" class=" col-xs-3"><s:message code="condition.sender"/></label>
                        <div class="input-group">
                            <input type="text" class="form-control input-sm condition_input_text" id="senders"
                                   placeholder="<s:message code="condition.sender"/>" style="width: 290px;"/>
                            <label class="checkbox-inline c-checkbox exceptOption">
                                <input type="checkbox" name="senders_not" disabled="disabled">
                                <span class="fa fa-check"><span class="text"><s:message code="query.make.except"/></span></span>
                            </label>
                            <%if (Common.isEquals(rsUppercase, "Y")) {%>
                            <label class="checkbox-inline c-checkbox exceptOption">
                                <input type="checkbox" name="senders_upperCase" disabled="disabled">
                                <span class="fa fa-check"><span class="text"><s:message code="condition.uppercase"/></span></span>
                            </label>
                            <%} %>
                        </div>
                    </li>
                    <li class="form-inline">
                        <label for="" class=" col-xs-3"><s:message code="condition.detail.recvs"/></label>
                        <label class="radio-inline c-radio"><input type="radio" name="receive_option"
                                                                   id="receive_option_all" value="" checked><span
                                class="fa fa-check"><span class="text"><s:message code="common.msg.all"/></span></span></label>
                        <label class="radio-inline c-radio"><input type="radio" name="receive_option"
                                                                   id="receive_option_more" value="detail"><span
                                class="fa fa-check"><span class="text"><s:message code="condition.info.detail"/></span></span></label>
                        <input type="hidden" name="receiveSend" id="receiveSend">
                    </li>
                    <li>
                        <label for="receivers" class=" col-xs-3"><s:message code="condition.recv"/></label>
                        <div class="input-group">
                            <input type="text" class="form-control input-sm condition_input_text" id="receivers"
                                   placeholder="<s:message code="condition.recv"/>" style="width: 290px;"/>
                            <label class="checkbox-inline c-checkbox exceptOption">
                                <input type="checkbox" name="receivers_not" disabled="disabled">
                                <span class="fa fa-check"></span><s:message code="query.make.except"/>
                            </label>
                            <%if (Common.isEquals(rsUppercase, "Y")) {%>
                            <label class="checkbox-inline c-checkbox exceptOption">
                                <input type="checkbox" name="receivers_upperCase" disabled="disabled">
                                <span class="fa fa-check"></span><s:message code="condition.uppercase"/>
                            </label>
                            <%} %>
                        </div>
                    </li>
                    <li class="receivers_detail" style="display: none;">
                        <div>
                            <label for="rcvTo" class=" col-xs-3"> ><s:message
                                    code="condition.recv"/>(<s:message code="condition.to"/>)</label>
                            <div class="input-group">
                                <input type="text" class="form-control input-sm condition_input_text" id="rcvTo"
                                       placeholder="<s:message code="condition.to"/>" style="width: 412px;"/>
                                <label class="checkbox-inline c-checkbox exceptOption">
                                    <input type="checkbox" name="rcvTo_not" disabled="disabled">
                                    <span class="fa fa-check"></span><s:message code="query.make.except"/>
                                </label>
                            </div>
                        </div>
                        <div>
                            <label for="rcvCc" class=" col-xs-3"> ><s:message code="condition.recv"/>
                                (<s:message code="condition.cc"/>)</label>
                            <div class="input-group">
                                <input type="text" class="form-control input-sm condition_input_text" id="rcvCc"
                                       placeholder="<s:message code="condition.cc"/>" style="width: 412px;"/>
                                <label class="checkbox-inline c-checkbox exceptOption">
                                    <input type="checkbox" name="rcvCc_not" disabled="disabled">
                                    <span class="fa fa-check"></span><s:message code="query.make.except"/>
                                </label>
                            </div>
                        </div>
                        <div>
                            <label for="rcvBcc" class=" col-xs-3"> ><s:message code="condition.recv"/>
                                (<s:message code="condition.bcc"/>)</label>
                            <div class="input-group">
                                <input type="text" class="form-control input-sm condition_input_text" id="rcvBcc"
                                       placeholder="<s:message code="condition.bcc"/>" style="width: 412px;"/>
                                <label class="checkbox-inline c-checkbox exceptOption">
                                    <input type="checkbox" name="rcvBcc_not" disabled="disabled">
                                    <span class="fa fa-check"></span><s:message code="query.make.except"/>
                                </label>
                            </div>
                        </div>
                    </li>
                    <li>
                        <label for="allOfus" class=" col-xs-3"><s:message
                                code="condition.allofus"/></label>
                        <div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
                            <select class="selectpicker col-xs" id="allOfus" style="width:100%;"
                                    data-style="btn-default btn-sm">
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
                    </li>
                    <li>
                        <label for="userGroupSeq" class=" col-xs-3"><s:message
                                code="userGroup.navi.title2"/></label>
                        <div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
                            <select id="userGroupSeq" class="selectpicker col-xs"
                                    data-style="btn-default btn-sm"></select>
                        </div>
                        <label class="checkbox-inline c-checkbox exceptOption2">
                            <input type="checkbox" name="userGroupSeq_not" disabled="disabled">
                            <span class="fa fa-check"></span><s:message code="query.make.except"/>
                        </label>
                        <input type="hidden" id="userGroupStr">
                    </li>
                    <li>
                        <label for="interGroup" class=" col-xs-3"><s:message code="interest.user"/></label>
                        <div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
                            <select id="interGroup" class="selectpicker col-xs"
                                    data-style="btn-default btn-sm"></select>
                        </div>
                        <label class="checkbox-inline c-checkbox exceptOption2">
                            <input type="checkbox" name="interGroup_not" disabled="disabled">
                            <span class="fa fa-check"></span><s:message code="query.make.except"/>
                        </label>
                    </li>

                    <li>
                        <label for="busiSelect" class=" col-xs-3"><s:message
                                code="condition.organization"/></label>
                        <div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
                            <select id="busiSelect" class="selectpicker col-xs" data-style="btn-default btn-sm" multiple
                                    data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
                            <label class="checkbox-inline c-checkbox exceptOption2">
                                <input type="checkbox" name="busi_not" disabled="disabled">
                                <span class="fa fa-check"></span><s:message code="query.make.except"/>
                            </label>
                            <p>
                            <div class="btn-group" data-toggle="buttons" style="margin-top: 5px;">
                                <button type="button" class="btn01" id="dept" style="border-radius: 0;">
                                    <img src="../img/subBtn_plus.png" alt="부서 추가"><s:message
                                        code="common.org.choose.dept"/></button>
                                <span id="deptSelectedArea" class="codeSelectedBtn" style="z-index: 999;">
									<button type="button" class="btn" style="z-index: 2">0</button>
								</span>
                                <input type="hidden" id="deptStr" class="selectedTitle">
                                <input type="hidden" id="deptVal">
                            </div>
                            <label class="checkbox-inline c-checkbox exceptOption">
                                <input type="checkbox" name="dept_not" disabled="disabled">
                                <span class="fa fa-check"></span><s:message code="query.make.except"/>
                            </label>
                            </p>
                        </div>
                    </li>
                    <li>
                        <label for="url" class=" col-xs-3">URL</label>
                        http://
                        <div class="input-group">
                            <input type="text" class="form-control input-sm condition_input_text" id="url"
                                   placeholder="URL" style="width: 372px;"/>
                            <label class="checkbox-inline c-checkbox exceptOption">
                                <input type="checkbox" name="url_not" disabled="disabled">
                                <span class="fa fa-check"></span><s:message code="query.make.except"/>
                            </label>
                        </div>
                    </li>
                    <li class="form-inline" id="readYnGroup">
                        <label for="" class=" col-xs-3"><s:message code="condition.isread"/></label>
                        <label class="radio-inline c-radio"><input type="radio" name="readYnVal" value="" checked><span
                                class="fa fa-check"><span class="text"><s:message code="common.msg.all"/></span></span></label>
                        <label class="radio-inline c-radio"><input type="radio" name="readYnVal" value="Y"><span
                                class="fa fa-check"><span class="text"><s:message code="condition.read"/></span></span></label>
                        <label class="radio-inline c-radio"><input type="radio" name="readYnVal" value="N"><span
                                class="fa fa-check"><span class="text"><s:message code="condition.unread"/></span></span></label>
                        <input type="hidden" name="readYn" id="readYn">
                    </li>
                    <!-- 첨부여부 -->
                    <li class="form-inline" style="height:90px;">
                        <div class=" col-xs-3">
                            <label for="attachYnVal"><s:message code="condition.isattached"/></label>
                        </div>
                        <div class="col-xs-9" style="padding-left:0px;">
                            <div style="height:35px;line-height:35px;">
                                <label class="radio-inline c-radio"><input type="radio" name="attachYnVal" value=""
                                                                           checked><span
                                        class="fa fa-check"><span class="text"><s:message code="common.msg.all"/></span></span></label>
                                <label class="radio-inline c-radio"><input type="radio" name="attachYnVal"
                                                                           value="Y"><span
                                        class="fa fa-check"><span class="text"><s:message code="condition.exist"/></span></span></label>
                                <label class="radio-inline c-radio"><input type="radio" name="attachYnVal"
                                                                           value="N"><span
                                        class="fa fa-check"><span class="text"><s:message code="condition.none"/></span></span></label>
                                <input type="hidden" name="attachYn" id="attachYn">

                                <span id="attachBtnArea" style="display:none;">
										<button type="button" class="btn btn-sm btn-default btn-open filterAddBtn"
                                                accesskey="A" id="attachBtn"><span
                                                class="glyphicon glyphicon-plus-sign"><s:message
                                                code="condition.select"/></span></button>
									</span>
                                <span id="attachSelectedArea" class="codeSelectedBtn">
										<button type="button" class="btn">0</button>
									</span>
                                <label class="checkbox-inline c-checkbox exceptOption2">
                                    <input type="checkbox" name="attach_not" disabled="disabled">
                                    <span class="fa fa-check"><span class="text"><s:message code="query.make.except"/></span></span>
                                </label>
                                <input type="hidden" id="attachStr">
                                <input type="hidden" id="attachVal" class="selectedTitle">
                            </div>
                            <div style="padding-top:5px;">
                                <label for="" class="" style="width:100px;"><s:message
                                        code="condition.actual.attachment"/></label>


                                <label class="radio-inline c-radio"><input type="radio" name="realAttYnVal" value=""
                                                                           checked disabled="disabled"><span
                                        class="fa fa-check"></span><s:message code="common.msg.all"/></label>
                                <label class="radio-inline c-radio"><input type="radio" name="realAttYnVal" value="Y"
                                                                           disabled="disabled"><span
                                        class="fa fa-check"></span><s:message code="condition.onemore"/></label>
                                <label class="radio-inline c-radio"><input type="radio" name="realAttYnVal" value="N"
                                                                           disabled="disabled"><span
                                        class="fa fa-check"></span><s:message code="condition.none"/></label>
                            </div>
                            <div>
                                <label for="" class="" style="width:100px;">DRM</label>
                                <label class="radio-inline c-radio"><input type="radio" name="regexp_drmYnVal" value=""
                                                                           checked disabled="disabled"><span
                                        class="fa fa-check"></span><s:message code="common.msg.all"/></label>
                                <label class="radio-inline c-radio"><input type="radio" name="regexp_drmYnVal" value="Y"
                                                                           disabled="disabled"><span
                                        class="fa fa-check"></span><s:message code="condition.exist"/></label>
                                <label class="radio-inline c-radio"><input type="radio" name="regexp_drmYnVal" value="N"
                                                                           disabled="disabled"><span
                                        class="fa fa-check"></span><s:message code="condition.none"/></label>
                            </div>
                        </div>
                    </li>

                    <!-- 예약어 -->
                    <li class="form-inline" style="line-height:35px;">
                        <label for="" class=" col-xs-3"><s:message code="condition.keyword"/></label>
                        <label class="radio-inline c-radio"><input type="radio" name="keywordYnVal" value=""
                                                                   checked><span class="fa fa-check"></span><s:message
                                code="common.msg.all"/></label>
                        <label class="radio-inline c-radio"><input type="radio" name="keywordYnVal" value="Y"><span
                                class="fa fa-check"></span><s:message code="condition.exist"/></label>
                        <label class="radio-inline c-radio"><input type="radio" name="keywordYnVal" value="N"><span
                                class="fa fa-check"></span><s:message code="condition.none"/></label>
                        <input type="hidden" name="keywordYn" id="keywordYn">

                        <span id="keywordBtnArea" style="display:none;">
								<button type="button" class="btn btn-sm btn-default btn-open filterAddBtn" accesskey="K"
                                        id="keywordBtn"><span class="glyphicon glyphicon-plus-sign"><s:message
                                        code="condition.select"/></span></button>
							</span>
                        <span id="keywordSelectedArea" class="codeSelectedBtn">
								<button type="button" class="btn">0</button>
							</span>
                        <label class="checkbox-inline c-checkbox exceptOption2">
                            <input type="checkbox" name="keyword_not" disabled="disabled">
                            <span class="fa fa-check"></span><s:message code="query.make.except"/>
                        </label>
                        <input type="hidden" id="keywordStr" class="selectedTitle">
                        <input type="hidden" id="keywordVal">
                    </li>

                    <!-- 패턴검출 -->
                    <li class="form-inline" style="line-height:35px;">
                        <label for="" class=" col-xs-3"><s:message code="condition.regexp.detect"/></label>
                        <label class="radio-inline c-radio"><input type="radio" name="regexpYnVal" value=""
                                                                   checked><span class="fa fa-check"></span><s:message
                                code="common.msg.all"/></label>
                        <label class="radio-inline c-radio"><input type="radio" name="regexpYnVal" value="Y"><span
                                class="fa fa-check"></span><s:message code="condition.exist"/></label>
                        <label class="radio-inline c-radio"><input type="radio" name="regexpYnVal" value="N"><span
                                class="fa fa-check"></span><s:message code="condition.none"/></label>
                        <input type="hidden" name="regexpYn" id="regexpYn">

                        <span id="regexpBtnArea" style="display:none;">
								<button type="button" class="btn btn-sm btn-default btn-open filterAddBtn" accesskey="P"
                                        id="regexpBtn"><span class="glyphicon glyphicon-plus-sign"><s:message
                                        code="condition.select"/></span></button>
							</span>
                        <span id="regexpSelectedArea" class="codeSelectedBtn">
								<button type="button" class="btn">0</button>
							</span>
                        <input type="hidden" id="regexpStr" class="selectedTitle">
                        <input type="hidden" id="regexpVal">
                    </li>

                    <li id="sctDiv" style="display: none;">
                        <!-- 수신필터 SCT -->
                        <div class="form-inline">
                            <label for="" class=" col-xs-3"><s:message code="condition.sct"/></label>
                            <label class="radio-inline c-radio"><input type="radio" name="regexp_sctYnVal" value=""
                                                                       checked><span
                                    class="fa fa-check"></span><s:message code="common.msg.all"/></label>
                            <label class="radio-inline c-radio"><input type="radio" name="regexp_sctYnVal"
                                                                       value="Y"><span
                                    class="fa fa-check"></span><s:message code="condition.exist"/></label>
                            <label class="radio-inline c-radio"><input type="radio" name="regexp_sctYnVal"
                                                                       value="N"><span
                                    class="fa fa-check"></span><s:message code="condition.none"/></label>
                        </div>
                    </li>
                    <li class="filterDiv">
                        <div style="width:110px;float: left;">
                            <h5><s:message code="filterInfo.size"/></h5>
                        </div>
                        <div class="selecBtnArea" style="width:calc(100% - 140px); text-align: right;float: left;">
                            <select class="selectpicker col-xs" data-style="btn-primary" id="sizeFilterType">
                                <option value=""><s:message code="condition.size.all"/></option>
                                <option value="B"><s:message code="condition.size.body"/></option>
                                <option value="A"><s:message code="condition.size.attach"/></option>
                            </select>
                            <select class="selectpicker col-xs" data-style="btn-primary" id="sizeFilterSelect">
                                <option value="L"><s:message code="condition.over"/></option>
                                <option value="S"><s:message code="condition.below"/></option>
                                <option value="B"><s:message code="condition.range"/></option>
                            </select>
                        </div>
                        <div style="clear:both;height:60px;padding:1px 5px 0px 5px;">
                            <div id="size-setup" style="margin-bottom:10px;"></div>
                            <div style="padding-left:5px;">
                                <span id="sizeStartValStr" style="line-height:30px;"></span><input type="text"
                                                                                                   id="sizeStartVal"
                                                                                                   style="width: 90px; display: none;">
                                <span id="sizeRangeValStr" style="display:none;"> ~ </span>
                                <span id="sizeEndValStr" style="display:none;"></span><input type="text" id="sizeEndVal"
                                                                                             style="width:90px; display: none;">
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
<form method="post" id="codeParam">
    <input type="hidden" name="oldCode" id="oldCode"></input>
    <input type="hidden" name="oldConm" id="oldConm"></input>
</form>
</body>
</html>