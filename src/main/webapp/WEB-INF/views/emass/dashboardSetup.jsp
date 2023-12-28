<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<%
	String infoFeedbackYn = Common.getInfoFeedbackYn(session);
	String epmsgType = Config.getString("message.epmsg.val");
	boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
%>

<head>
	<title></title>

	<style type="text/css">
		.radio-inline.c-radio {
			margin-left: 0px;
		}

		.ellipsis {
			width: 280px;
			text-overflow: ellipsis;
			overflow: hidden;
			white-space: nowrap;
		}

		.modal-lg {
			width: 1100px;
		}

		.grid-stack-item {
			width: 100%;
			height: 100%;
		}

		.dashIcon, .menuIcon {
			font-size: 18px;
			margin-bottom: 5px;
		}

		.selected {
			background-color: #c2daf8;
		}

		.customClass {
			font-size: 3em !important;
		}

		.grid-stack-item-content .fa {
			display: inline-block;
		}

		.chartDash {
			font-size: 15px !important;
		}

		.conentBatchBtn {
			color: #fff;
			background-color: #2778bf;
			border-color: #2778bf;
		}
	</style>
	<script type="text/javascript">
        <%--var infoFeedbackYn = '<%=infoFeedbackYn%>';--%>
        <%--var infoFeedbackConf = '<%=infoFeedbackConf%>';--%>
        var epmsgType = '<%=epmsgType%>';
        var searchFlag = false;

        var defaultDashKey = [];
        $(document).ready(function () {

            $('#dashboardShareBtn').click(function () {
                var selectDashKey = gridDashboard.getSelectedKey('dashKey');
                var dsKey = selectDashKey.filter(function (el, idx, array) {
                    return defaultDashKey.includes(el);
                });

                if (selectDashKey.length == 0) {
                    ui.alertMsg('<s:message code="selectAdmin.share.select.dashboard"/>');
                    return;
                }

                if (dsKey.length > 0) {
                    ui.alertMsg('<s:message code="selectAdmin.share.include.default"/>');
                    return;
                }

                var url = '<c:url value="/commons/selectAdmin.do?dashKey='+selectDashKey.toString()+'"/>';
                fnOpenWindow(url, 'selectCodeWinPopup', 1200, 700, 'resize');
            });

            $('#dashboardDeleteBtn').click(function () {
                var rows = gridDashboard.getSelectedRows();
                if (rows == '') {
                    ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                    return false;
                }
                var names = gridDashboard.getSelectedKey('dashName');
                ui.confirmMsg('<s:message code="common.msg.confirm.deleteitem" arguments="'+names+'" argumentSeparator="|"/>', '', '', function (rs) {
                    if (rs) {
                        gridDashboard.on();
                        var ckBatch = checkBatchAdminIds(rows);
                        if (ckBatch) {
                            $('#deleteDashBatchPop_msg').val('show');
                            $('#deleteDashBatchPop').modal('show');
                        } else {
                            ui.get({
                                url: 'deleteDashBoardContent.xcn',
                                deleteData: JSON.stringify(rows),
                                success: function (data, total) {
                                    ui.alertMsg('<s:message code="common.msg.deleted"/>');
                                    getDashBoardContent();
                                },
                                error: function (status, message) {
                                    ui.alertMsg(message);
                                },
                                complete: function () {
                                    gridDashboard.off();
                                }
                            });
                        }
                    }
                });
            });

            $('#dashSaveBtn').click(function () {
                $('#adminIds').val('');
                saveDashboard();
            });
            $('#dashShareSaveBtn').click(function () {
                saveDashboard();
            });
            $('#searchStrDashboardBtn').click(function () {
                getDashBoardContent();
            });
            $('#searchStrDashboard').enter(function (e) {
                getDashBoardContent();
            });

            $('#dashboardInsertBtn').click(function () {
                $('#dashKey').val('');
                $('#dashName').val('');
                $('input:radio[name=dashType]:input[value=S]').prop("checked", true);
                $('#dashMultiLeft').val('unread');
                $('#dashMultiRight').val('total');
                $('input:radio[name=dashChart]:input[value=P]').prop("checked", true);
                $('#dashChartX').val('svc1');
                $('#dashChartY').val('total');
                $('#dashIcon').val('tit01');
                $('#dashColor').val('blueBg');
                $('#alarmVal').val(''); //dashCondition
                $('#alarmValStr').val('');
                $('#dashComment').val('');
                $('#dashHtmlSample').html('');
                $('#dashHtml').html('');
                $('#dashDoubleArea').hide();
                $('#dashChartArea').hide();
                $('#dashXYArea').hide();
                $('#dashShareSaveBtn').css('display', 'none');

                setDashContentData();
                $("#setupDashboardContentPop").modal('show');
            });

            $('#dashConditionBtn').click(function () {
                fnOpenWindow('<c:url value="/ems/detailConditionPop.do"/>', 'dashCondition', 700, 850, 'fix');
            });

            $("input[name=dashType]").change(function () {
                var val = $(this).val();
                if (val == 'S' || val == 'L') {
                    $('#dashChartArea').hide();
                    $('#dashXYArea').hide();
                    $('#dashDoubleArea').hide();
                } else if (val == 'D') {
                    $('#dashChartArea').hide();
                    $('#dashXYArea').hide();
                    $('#dashDoubleArea').show();
                } else if (val == 'C') {
                    $('#dashChartArea').show();
                    $('#dashXYArea').show();
                    $('#dashDoubleArea').hide();
                }

                setDashContentData();
            });
            $("input[name=dashChart]").change(function () {
                setDashContentData();
            });

            $('.dashIcon').click(function () {
                $('#dashIcon').val($(this).attr('data-value'));
                setDashContentData();
            });

            $('.dashColor').click(function () {
                $('#dashColor').val($(this).attr('data-value'));
                setDashContentData();
            });

            $('#dashName').bind('change keydown keyup', function () {
                var value = $(this).val();
                if (value == '') value = '<s:message code="dashboardSetup.dashname"/>';
                $('#dashHtmlSample .dash-title').text(value);

                var dashHtml = $('<div>').append($('#dashHtml').val());
                dashHtml.find('.dash-title').text(value);
                $('#dashHtml').val(dashHtml.html());
            });

            $('#deleteBatchCloseBtn').click(function () {
                $('#deleteDashBatchPop').modal('hide');
                gridDashboard.off();
            });

            $('.deleteBtn').click(function () {
                var type = $(this).attr('id');
                var rows = gridDashboard.getSelectedRows();
                $('#deleteDashBatchPop').modal('hide');

                gridDashboard.on();
                ui.get({
                    url: type == 'deleteBatchBtn' ? 'deleteDashBoardContentBatch.xcn' : 'deleteDashBoardContent.xcn',
                    deleteData: JSON.stringify(rows),
                    success: function (data, total) {
                        ui.alertMsg('<s:message code="common.msg.deleted"/>');
                        getDashBoardContent();
                    },
                    error: function (status, message) {
                        ui.alertMsg(message);
                    },
                    complete: function () {
                        gridDashboard.off();
                    }
                });
            });

            getDashBoardContent();
            getDefaultDashBoardContentList();
        });


        function saveDashboard() {
            if ($('#dashName').val().ltrim().rtrim() == '') {
                ui.alertMsg('<s:message code="dashboardSetup.msg.inputTitle"/>', function () {
                    $('#dashName').focus();
                });
                return false;
            }
            if ($('#alarmVal').val().ltrim().rtrim() == '') {
                ui.alertMsg('<s:message code="dashboardSetup.msg.inputCondition"/>', function () {
                    $('#dashConditionBtn').click();
                });
                return false;
            }
            var dashKey = $('#dashKey').val();

            var message = dashKey == '' ? '<s:message code="common.msg.add"/>' : '<s:message code="common.msg.modify"/>';
            var confirmMessage = dashKey == '' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
            ui.confirmMsg(confirmMessage, '', '', function (rs) {
                if (rs) {
                    gridDashboard.on();
                    ui.post({
                        url: dashKey == '' ? 'insertDashBoardContent.xcn' : 'updateDashBoardContent.xcn',
                        data: $('#setupDashboardContentPopForm').serializeAll(),
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            $('#setupDashboardContentPop').modal('hide');
                            getDashBoardContent();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            gridDashboard.off();

                        }
                    });
                }
            });
        }

        function getDashBoardContent(flag) {
            if (searchFlag) return false;

            searchFlag = true;
            gridDashboard.on();
            ui.get({
                url: 'getDashBoardContentList.xcn',
                searchStr: $('#searchStrDashboard').val(),
                success: function (data, total) {
                    gridDashboard.setData(data);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    gridDashboard.off();
                    searchFlag = false;
                }
            });
        }

        function getDefaultDashBoardContentList(flag) {
            ui.get({
                url: 'getDefaultDashBoardContentList.xcn',
                success: function (data, total) {
                    for (var i = 0; i < data.length; i++) {
                        defaultDashKey.push(data[i].dashKey);
                    }
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {

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
            searchDateStr += '<s:message code="condition.clock" arguments="'+alarmVal.startTimeSelect+'" />';
            searchDateStr += ' ~ ';
            if (alarmVal.endDateSelect == 'Y') searchDateStr += '<s:message code="condition.yesterday_str"/> ';
            else if (alarmVal.endDateSelect == 'T') searchDateStr += '<s:message code="condition.today_str"/> ';
            else if (alarmVal.endDateSelect == 'W') searchDateStr += '<s:message code="condition.sevenago"/> ';
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
            if (alarmVal.sizeStartVal != '') {
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

            if (rtnType == undefined) {
                checkPeriod(alarmVal.startDateSelect, alarmVal.startTimeSelect, alarmVal.endDateSelect, alarmVal.endTimeSelect);

                $('#alarmValStr').val(searchStr);
            } else return searchStr;
        }

        function checkPeriod(startDateSelect, startTimeSelect, endDateSelect, endTimeSelect) {

        }

        function setConditionValStr(val, key, notVal) {
            if (val != null && val != '') {
                var str = key + ' : ' + val.replaceAll('\\|', ',');
                if (notVal == 'Y') str += ' [<s:message code="query.make.except"/>]';
                return str + '\n';
            }
            return '';
        }

        function setChartData(type, x, y) {
            if (type == 'P') setPieChartSample();
            else {
                var rtnType = '';
                if (type == 'L') {
                    rtnType = 'line';
                } else if (type == 'A') {
                    rtnType = 'area';
                } else if (type == 'B') {
                    rtnType = 'column'
                }
                setChartSample(rtnType);
            }
        }

        function setDashContentData(data) {
            if (data == undefined) {
                data = {};
                data.dashName = $('#dashName').val() == '' ? '<s:message code="dashboardSetup.dashname"/>' : $('#dashName').val();
                data.dashType = $(":input:radio[name=dashType]:checked").val();
                data.dashMultiLeft = $('#dashMultiLeft').val();
                data.dashMultiRight = $('#dashMultiRight').val();
                data.dashChart = $(":input:radio[name=dashChart]:checked").val();
                data.dashChartX = $('#dashChartX').val();
                data.dashChartY = $('#dashChartY').val();
                data.dashIcon = $('#dashIcon').val() == '' ? 'tit01' : $('#dashIcon').val();
                data.dashColor = $('#dashColor').val() == '' ? 'blueBg' : $('#dashColor').val();
                data.dashCondition = $('#alarmVal').val() == '' ? {} : JSON.parse($('#alarmVal').val());
            }

            var htmlData = '';
            var saveData = '';
            if (data.dashType == 'S') {
                htmlData = $('#singleDataFormat').html();
                $('#dashHtmlSample').css('width', '70%');
                $('#dashHtmlSample').css('height', '120px');
            } else if (data.dashType == 'D') {
                htmlData = $('#dualDataFormat').html();
                $('#dashHtmlSample').css('width', '70%');
                $('#dashHtmlSample').css('height', '120px');
            } else if (data.dashType == 'C') {
                htmlData = $('#chartDataFormat').html();
                $('#dashHtmlSample').css('width', '100%');
                $('#dashHtmlSample').css('height', '300px');
            } else if (data.dashType == 'L') {
                htmlData = $('#listDataFormat').html();
                saveData = $('#listDataFormat .dashTableTbody').clone().remove().html();
                $('#dashHtmlSample').css('width', '100%');
                $('#dashHtmlSample').css('height', '300px');
            } else {
                htmlData = $('#emptyDataFormat').html();
                $('#dashHtmlSample').css('width', '100%');
                $('#dashHtmlSample').css('height', '200px');
            }
            htmlData = htmlData.replaceAll('#dashName#', data.dashName)
                .replaceAll('#dashMultiLeft#', data.dashMultiLeft)
                .replaceAll('#dashMultiRight#', data.dashMultiRight)
                .replaceAll('#chartType#', data.dashChart)
                .replaceAll('#dashColor#', data.dashColor)
                .replaceAll('#dashIcon#', data.dashIcon);

            if (saveData == '') saveData = htmlData;
            $('#dashHtml').val(htmlData);
            $('#dashHtmlSample').html(htmlData);

            setTimeout(function () {
                if (data.dashType == 'S') {
                    setDashData('123,456');
                } else if (data.dashType == 'D') {
                    setDashData('123,456', '1,234');
                } else if (data.dashType == 'C') {
                    setChartData(data.dashChart, '', '');
                } else if (data.dashType == 'L') {
                    setDashDataListSample();
                }
            }, 500);
        }

        function insertDashboardShare(adminData, oldAdmin) {
            var dashKeys = gridDashboard.getSelectedKey('dashKey').toString();
            var oldAdminList = oldAdmin.split(",");

            var deleteData = oldAdminList.filter(function (e, i, a) {
                return !adminData.includes(e);
            });
// 	deleteData.push(adminData.filter(function(e, i, a) {return oldAdminList.includes(e);}));
            var ckMsg = "[ " + gridDashboard.getSelectedKey('dashName') + " ] " + '<s:message code="selectAdmin.share.confirm"/>';
            var adminIds = adminData.toString();
            var delData = deleteData.toString();

            ui.confirmMsg(ckMsg, '', '', function (rs) {
                if (rs) {
                    ui.postJson({
                        url: 'insertDashboardShare.xcn',
                        adminIds: adminIds,
                        dashKeys: dashKeys,
                        deleteData: delData,
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="selectAdmin.share.complete"/>');
                            getDashBoardContent();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                        }
                    });
                }
            });
        }

        function checkBatchAdminIds(datas) {
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].adminIds != null && datas[i].adminIds != undefined && datas[i].adminIds != '') return true;
            }

            return false;
        }
	</script>
</head>

<div class="modal" role="dialog" aria-hidden="true" id="deleteDashBatchPop" aria-labelledby="bootstrap_confirm_title" tabindex="-1">
	<div class="modal-content">
		<div class="modalHead">
			<h2>대시보드 삭제</h2>
			<span class="close" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalbody">
			<div class="row">
				<div class="col-50">
					<s:message code="selectAdmin.share.deleteMsg"/>
				</div>
			</div>
		</div>
		<div class="modalfooter" style="display: block;">
			<button class=" conentBatchBtn" id="deleteBatchBtn"><s:message
					code="selectAdmin.share.delete.batch"/></button>
			<button class="pop_btn02 deleteBtn" id="deleteOneBtn"><s:message code="selectAdmin.share.delete"/></button>
			<button class="pop_btn01" id="deleteBatchCloseBtn"><s:message code="common.msg.cancel"/></button>
		</div>
	</div>
</div>


<div class="modal" id="setupDashboardContentPop" data-backdrop="static">
	<div class="modal-content" style="width: 1000px;">
		<form method="post" id="setupDashboardContentPopForm">
			<div class="modalHead">
				<h2><s:message code="dashboardSetup.addModify"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3>Dashboard 추가/수정</h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						필수 입력 사항입니다.
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-50">
							<h3><s:message code="admin.basic.info"/></h3>
							<div class="row">
								<div class="col-35">
									<label for="dashName" class="fname"><s:message code="dashboardSetup.dashname"/></label>
								</div>
								<div class="col-65">
									<input type="text" class="w100" name="dashName" id="dashName"
									       placeholder="<s:message code="dashboardSetup.dashname"/>" style="width: 250px;" maxlength="20">
									<input type="hidden" name="dashKey" id="dashKey">
								</div>
							</div>
							<div class="row">
								<div class="col-35">
									<label for="dashType" class="fname"><s:message code="dashboardSetup.dashtype"/></label>
								</div>
								<div class="col-65">
									<label class="radio-inline c-radio">
										<input type="radio" name="dashType" value="S" checked><s:message code="dashboardSetup.dashtype.single"/>
									</label>
									<%--								<label class="radio-inline c-radio">--%>
									<%--									<input type="radio" name="dashType" value="D"><s:message code="dashboardSetup.dashtype.multi"/>--%>
									<%--								</label>--%>
									<label class="radio-inline c-radio">
										<input type="radio" name="dashType" value="C"><s:message code="dashboardSetup.dashtype.chart"/>
									</label>
									<label class="radio-inline c-radio">
										<input type="radio" name="dashType" value="L"><s:message code="dashboardSetup.dashtype.list"/>
									</label>
								</div>
							</div>

							<%--							<div id="dashDoubleArea" style="display:none;">--%>
							<%--								<div class="row">--%>
							<%--									<div class="col-35">--%>
							<%--								<label for="dash_x" class="fname"><s:message code="dashboardSetup.multData"/></label>--%>
							<%--									</div>--%>
							<%--									<div class="col-65">--%>
							<%--								<select class="w100" id="dashMultiLeft" name="dashMultiLeft">--%>
							<%--									<option value="read"><s:message code="dashboardSetup.readCount"/></option>--%>
							<%--									<option value="unread" selected><s:message code="dashboardSetup.unreadCount"/></option>--%>
							<%--									<option value="total"><s:message code="dashboardSetup.allCount"/></option>--%>
							<%--								</select>--%>
							<%--								<select class="w100" id="dashMultiRight" name="dashMultiRight">--%>
							<%--									<option value="read"><s:message code="dashboardSetup.readCount"/></option>--%>
							<%--									<option value="unread"><s:message code="dashboardSetup.unreadCount"/></option>--%>
							<%--									<option value="total" selected><s:message code="dashboardSetup.allCount"/></option>--%>
							<%--								</select>--%>
							<%--							</div>--%>
							<%--								</div>--%>
							<%--							</div>--%>

								<div class="row" id="dashChartArea" style="display:none;">
									<div class="col-35">
										<label for="dashChart" class="fname" style="height:60px;"><s:message code="dashboardSetup.chartType"/></label>
									</div>
									<div class="col-65">
										<label class="radio-inline c-radio">
											<input type="radio" name="dashChart" value="P" checked>
											<s:message code="dashboardSetup.dashchart.pie"/>
											<img src="<c:url value="/img/icon/chart_pie.png"/>" width="24" height="24">
										</label>
										<label class="radio-inline c-radio">
											<input type="radio" name="dashChart" value="L">
											<s:message code="dashboardSetup.dashchart.line"/>
											<img src="<c:url value="/img/icon/line.bmp"/>" width="24" height="24">
										</label>
										<label class="radio-inline c-radio">
											<input type="radio" name="dashChart" value="A">
											<s:message code="dashboardSetup.dashchart.area"/>
											<img src="<c:url value="/img/icon/area.bmp"/>" width="24" height="24">
										</label>
										<label class="radio-inline c-radio">
											<input type="radio" name="dashChart" value="B">
											<s:message code="dashboardSetup.dashchart.bar"/>
											<img src="<c:url value="/img/icon/bar.bmp"/>" width="24" height="24">
										</label>
										<input type="hidden" name="dashChartNm" id="hiddenDashChart">
									</div>
								</div>


								<div class="row" id="dashXYArea" style="display:none;">
									<div class="col-35">
										<label for="dash_x" class="fname"><s:message code="dashboardSetup.chartXY"/></label>
									</div>
									<div class="col-65">
										<select class="w100" id="dashChartX" name="dashChartX">
											<option value="svc1"><s:message code="condition.service"/></option>
											<option value="ctime_hh"><s:message code="dashboardSetup.standardTime"/></option>
											<option value="ctime_yyyymmddhh"><s:message code="dashboardSetup.standardDay"/></option>
											<option value="conm"><s:message code="common.org.co"/></option>
											<option value="businm"><s:message code="dashboardSetup.stardardBusi"/></option>
											<option value="ip_businm"><s:message code="dashboardSetup.stardardBusiIp"/></option>
											<option value="deptnm"><s:message code="common.org.dept"/></option>
										</select>
										<select class="w100" id="dashChartY" name="dashChartY">
											<option value="total"><s:message code="common.msg.count"/></option>
										</select>
									</div>
								</div>


							<div class="row">
								<div class="col-35">
									<label for="dashIcon" class="fname" style="height:80px;"><s:message code="dashboardSetup.dashicon"/></label>
								</div>
								<div class="col-65">
									<button type="button" class="btn btn-default dashIcon" data-value="tit01"><img
											src="<c:url value="/img/ico_main_tit01.png"/>"></button>
									<button type="button" class="btn btn-default dashIcon" data-value="tit02"><img
											src="<c:url value="/img/ico_main_tit02.png"/>"></button>
									<button type="button" class="btn btn-default dashIcon" data-value="tit03"><img
											src="<c:url value="/img/ico_main_tit03.png"/>"></button>
									<button type="button" class="btn btn-default dashIcon" data-value="tit04"><img
											src="<c:url value="/img/ico_main_tit04.png"/>"></button>
									<button type="button" class="btn btn-default dashIcon" data-value="tit05"><img
											src="<c:url value="/img/ico_main_tit05.png"/>"></button>
									<button type="button" class="btn btn-default dashIcon" data-value="tit06"><img
											src="<c:url value="/img/ico_main_tit06.png"/>"></button>
									<button type="button" class="btn btn-default dashIcon" data-value="tit07"><img
											src="<c:url value="/img/ico_main_tit07.png"/>"></button>
									<button type="button" class="btn btn-default dashIcon" data-value="tit08"><img
											src="<c:url value="/img/ico_main_tit08.png"/>"></button>
									<button type="button" class="btn btn-default dashIcon" data-value="tit09"><img
											src="<c:url value="/img/ico_main_tit09.png"/>"></button>
									<button type="button" class="btn btn-default dashIcon" data-value="tit10"><img
											src="<c:url value="/img/ico_main_tit10.png"/>"></button>
									<button type="button" class="btn btn-default dashIcon" data-value="tit11"><img
											src="<c:url value="/img/ico_main_tit11.png"/>"></button>
									<button type="button" class="btn btn-default dashIcon" data-value="tit12"><img
											src="<c:url value="/img/ico_main_tit12.png"/>"></button>
									<input type="hidden" id="dashIcon" name="dashIcon"/>
								</div>
							</div>

							<div class="row">
								<div class="col-35">
									<label for="dashColor" class="fname"><s:message code="dashboardSetup.background"/></label>
								</div>
								<div class="col-65">
									<button type="button" class="btn blueBg dashColor" data-value="blueBg">&nbsp;&nbsp;</button>
									<button type="button" class="btn btn-default dashColor" data-value="panel-white">&nbsp;&nbsp;</button>
									<button type="button" class="btn purpleBg dashColor" data-value="purpleBg">&nbsp;&nbsp;</button>
									<button type="button" class="btn greenBg dashColor" data-value="greenBg">&nbsp;&nbsp;</button>
									<button type="button" class="btn redBg dashColor" data-value="redBg">&nbsp;&nbsp;</button>
									<button type="button" class="btn yellowBg dashColor" data-value="yellowBg">&nbsp;&nbsp;</button>
									<input type="hidden" name="dashColor" id="dashColor"/>
								</div>
							</div>

							<div class="row">
								<div class="col-35">
									<label for="useYn" class="fname"><s:message code="common.msg.useyn"/></label>
								</div>
								<div class="col-65">
									<label class="radio-inline c-radio">
										<input type="radio" name="useYn" value="Y" checked>
										<s:message code="common.msg.use"/>
									</label>
									<label class="radio-inline c-radio">
										<input type="radio" name="useYn" value="N">
										<s:message code="common.msg.unuse"/>
									</label>
									<input type="hidden" name="useYnNm" id="hiddenUseYn">
								</div>
							</div>

							<div class="row" style="border-bottom: 1px solid #e5e5e5;">
								<div class="col-35">
									<label for="dashComment" class="fname"><s:message code="common.msg.comment"/></label>
								</div>
								<div class="col-65">
									<input type="text" class="w100" name="dashComment" id="dashComment"
									       placeholder='<s:message code="filterInfo.comment"/>' style="width: 250px;" maxlength="50">
								</div>
							</div>

							<br/>
							<h3><s:message code="condition.filter_setting"/></h3>
							<div class="form-inline not-dashed">
								<button type="button" class="form_btn01_02" accesskey="S" id="dashConditionBtn">조건 설정</button>
							</div>
							<div>
								<textarea class="form-control" style="display:none" name="dashCondition" id="alarmVal"></textarea>
								<textarea class="form-control" style="height: 130px; margin-top: 1px;resize:none;" name="alarmValStr" id="alarmValStr"
								          readonly></textarea>
							</div>
						</div>
						<div class="col-50 mal16">
							<h3><s:message code="urlIpBlock.preview"/></h3>
							<!-- 미리보기 -->
							<div class="grid-stack mainTable" style="height:120px;" id="dashHtmlSample"></div>
							<!-- 미리보기 -->
							<input type=hidden name="html" id="dashHtml"/>
						</div>
						<input type=hidden name="adminIds" id="adminIds"/>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 savePopBtn" accesskey="S" id="dashSaveBtn"><s:message
							code="common.msg.save"/></button>
					<button type="button" class="pop_btn02 savePopBtn conentBatchBtn" accesskey="D" id="dashShareSaveBtn"><s:message
							code="selectAdmin.share.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>


<div class="searchArea">
	<div class="searchSub">
		<div>
			<input type="text" placeholder="<s:message code="dashboardSetup.titleSearch"/>" id="searchStrDashboard"
			       style="width: 200px;">
		</div>

		<button class="form_btn01" type="button" accesskey="K" id="searchStrDashboardBtn">조회</button>
		<button type="button" class="btn01" accesskey="A" id="dashboardInsertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>"
		                                                                               alt="추가"><s:message
				code="common.msg.add"/></button>
		<button type="button" class="btn02" accesskey="E" id="dashboardDeleteBtn"><img src="<c:url value="/img/subBtn_trash.png"/>"
		                                                                               alt="삭제"><s:message
				code="common.msg.delete"/></button>
		<c:if test="${_USERCREDENTIAL_.adminId eq 'sysadmin'}">
			<button type="button" class="btn03" accesskey="S" id="dashboardShareBtn"><span
					class="glyphicon glyphicon-share"></span>&nbsp;<s:message code="common.msg.share"/></button>
		</c:if>
	</div>
</div>
<div class="content xcn_full">
	<div class="contentSub">
		<div class="subtab">
			<button class="active">
				대시보드 관리 목록
				<span id="dashboardSetupCount"></span>
			</button>
		</div>
		<div id="dashboardListGrid" class="slickGrid gridArea"></div>
	</div>
</div>


<script type="text/javascript">
    var gridDashboard = new Xgrid('dashboardListGrid', contextRoot);
    gridDashboard.onCheckBox();
    gridDashboard.autoNumber();
    gridDashboard.colAdd('dashIcon', '<s:message code="dashboardSetup.dashicon"/>', 60, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        // return '<i class="customClass ' + value + '" style="font-size:20px !important;"></i>';
        return '<img src="<c:url value="/img/ico_main_'+ value + '.png"/>">';


    });
    gridDashboard.colAdd('dashName', '<s:message code="dashboardSetup.dashname"/>', 170, 'left', false, 'link');
    gridDashboard.colAdd('dashType', '<s:message code="common.msg.type"/>', 80, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'S') return '<s:message code="dashboardSetup.dashtype.single"/>';
        else if (value == 'D') return '<s:message code="dashboardSetup.dashtype.multi"/>';
        else if (value == 'C') return '<s:message code="dashboardSetup.dashtype.chart"/>';
        else if (value == 'L') return '<s:message code="dashboardSetup.dashtype.list"/>';
        return '-';
    });
    gridDashboard.colAdd('dashColor', '<s:message code="dashboardSetup.background"/>', 90, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        return '<div class="' + value + '" style="width:50px;height:21px;margin:auto;"><div class="panel-heading" style="border-radius:0px;">&nbsp;</div></div>';
    });
    gridDashboard.colAdd('dashChart', '<s:message code="dashboardSetup.chartType"/>', 90, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        var dashType = gridDashboard.getValue(row, 'dashType');
        if (dashType == 'C') {
            if (value == 'P') return '<s:message code="dashboardSetup.dashchart.pie"/>';
            else if (value == 'L') return '<s:message code="dashboardSetup.dashchart.line"/>';
            else if (value == 'A') return '<s:message code="dashboardSetup.dashchart.area"/>';
            else if (value == 'B') return '<s:message code="dashboardSetup.dashchart.bar"/>';
            return '-';
        } else {
            return '-';
        }
    });
    gridDashboard.colAdd('dashComment', '<s:message code="common.msg.comment"/>', 200, 'left', false, 'nomal');
    gridDashboard.colAdd('useYn', '<s:message code="common.msg.useyn"/>', 100, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'Y') return '<s:message code="common.msg.use"/>';
        else if (value == 'N') return '<s:message code="common.msg.unuse"/>';
        return '-';
    });
    gridDashboard.colAdd('dashCondition', '<s:message code="filterInfo.filter"/>', 400, 'left', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        return printAlarmValStr('', JSON.parse(value), 'return');
    });
    if (adminId == 'sysadmin') {
        gridDashboard.colAdd('adminIds', '<s:message code="selectAdmin.share.adminIds"/>', 400, 'left', false, 'nomal');
    }
    gridDashboard.onClick = function () {
        if (gridDashboard.Col == gridDashboard.ColIndex('dashName')) {
            var data = gridDashboard.getRowData(gridDashboard.Row);
            $('#dashKey').val(data.dashKey);
            $('#dashName').val(data.dashName);
            $('input:radio[name=dashType]:input[value=' + data.dashType + ']').prop("checked", true);
            $('#dashMultiLeft').val(data.dashMultiLeft);
            $('#dashMultiRight').val(data.dashMultiRight);
            $('input:radio[name=dashChart]:input[value=' + data.dashChart + ']').prop("checked", true);
            $('#dashChartX').val(data.dashChartX);
            $('#dashChartY').val(data.dashChartY);
            $('#dashIcon').val(data.dashIcon);
            $('#dashColor').val(data.dashColor);
            $('#alarmVal').val(data.dashCondition); //dashCondition
            printAlarmValStr('', JSON.parse(data.dashCondition));
            $('#dashComment').val(data.dashComment);
            $('input:radio[name=useYn]:input[value=' + data.useYn + ']').prop("checked", true);
            $('#adminIds').val(data.adminIds);

            if (data.dashType == 'S' || data.dashType == 'L') {
                $('#dashChartArea').hide();
                $('#dashXYArea').hide();
                $('#dashDoubleArea').hide();
            } else if (data.dashType == 'D') {
                $('#dashChartArea').hide();
                $('#dashXYArea').hide();
                $('#dashDoubleArea').show();
            } else if (data.dashType == 'C') {
                $('#dashChartArea').show();
                $('#dashXYArea').show();
                $('#dashDoubleArea').hide();
            }

            if (data.dashChart == 'P') $('#dashChartX').prop('disabled', true);
            else $('#dashChartX').prop('disabled', false);


            setDashContentData();
            if (data.adminIds != null || data.adminIds != undefined) {
                $('#dashShareSaveBtn').css('display', '');
            } else {
                $('#dashShareSaveBtn').css('display', 'none');
            }
            $("#setupDashboardContentPop").modal('show');
        }
    };
    gridDashboard.loadHeader(true);
    gridDashboard.initData('<s:message code="common.msg.search.click"/>');
</script>
<jsp:include page="./dashboardContent.jsp"/>
