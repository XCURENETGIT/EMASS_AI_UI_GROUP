<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<head>
	<title></title>
	<link rel="stylesheet" href="<c:url value="/css/panelsTab.css"/>"/>
	<style>
		.checkbox-inline + .checkbox-inline, .radio-inline + .radio-inline { margin-left: 0px;}
		.checkbox-inline, .radio-inline { font-size: 13px;}
		. input, .c-radio input {
			opacity: 1 !important;
			border:1px solid #000;
			padding-left:0px !important;
			position: relative !important;
			margin:-4px 0 0 0; vertical-align:middle;

		}
		.checkbox-inline, .radio-inline {padding:0 !important;}
		.ui_checked { }
	</style>
	<script>
        var searchFlag = false;
        $(document).ready(function () {
            getBusiList();
            $(function () {
                $("#selectableWorkday").selectable({
                    stop: function () {
                        result = selectBoxAsCheckBox('selectableWorkday');
                        var workDays = result.join('');
                        var wd = getContinuityName(workDays, WEEK_NAME_KR);
                        if (wd == "") $('#weekNameSpan').html('<s:message code="holidayBusiness.msg.set.workday"/>');
                        else $('#weekNameSpan').html(wd);
                        for (var i = 0; i < result.length; i++) {
                            if (result[i] == '1') {
                                $("input[name=holidayCheck][value=" + i + "]").prop("checked", true);
                            } else {
                                $("input[name=holidayCheck][value=" + i + "]").prop("checked", false);
                            }
                        }
                    }
                });

                $(".HolidayTimeClass").selectable({
                    stop: function () {
                        var workHours = selectBoxAsCheckBox('HolidayTime_am').join('');
                        workHours = workHours + selectBoxAsCheckBox('HolidayTime_pm').join('');
                        for (var i = 0; i < workHours.length; i++) {
                            if (workHours[i] == '1') {
                                $("input[name=workTime][value=" + i + "]").prop("checked", true);
                            } else {
                                $("input[name=workTime][value=" + i + "]").prop("checked", false);
                            }
                        }
                        var wh = getContinuityName(workHours, HOUR_NAME_KR2);
                        if (wh == "") $('#hourNameSpan').html('<s:message code="holidayBusiness.msg.set.worktime"/>');
                        else $('#hourNameSpan').html(wh);
                        workTimeCenter(wh);
                    }
                });
            });

            $('[name=holidayCheckAll]').change(function () {
                if ($(this).is(':checked')) $('[name=holidayCheck]').prop('checked', true).parent().parent().addClass('ui_checked');
                else $('[name=holidayCheck]').prop('checked', false).parent().parent().removeClass('ui_checked');
            });

            $('[name=workTimeAmAll]').change(function () {
                if ($(this).is(':checked')) $('.amTime [name=workTime]').prop('checked', true).parent().parent().addClass('ui_checked');
                else $('.amTime [name=workTime]').prop('checked', false).parent().parent().removeClass('ui_checked');
            });

            $('[name=workTimePmAll]').change(function () {
                if ($(this).is(':checked')) $('.pmTime [name=workTime]').prop('checked', true).parent().parent().addClass('ui_checked');
                else $('.pmTime [name=workTime]').prop('checked', false).parent().parent().removeClass('ui_checked');
            });

            $('.btn-group .bootstrap-select .show-tick').addClass('open');
            $('.holidayCheck').change(function () {
                var dayVal = new Array();
                $("input[name=holidayCheck]").each(function () {
                    if ($(this).is(":checked")) dayVal.push(1);
                    else dayVal.push(0);
                });
                if ($(this).prop('checked') == true) $(this).parent().parent().addClass('ui_checked');
                else $(this).parent().parent().removeClass('ui_checked');

                var workDays = dayVal.join('');
                var wd = getContinuityName(workDays, WEEK_NAME_KR);
                if (wd == "") $('#weekNameSpan').html('<s:message code="holidayBusiness.msg.set.workday"/>');
                else $('#weekNameSpan').html(wd);
            });

            $('.workTime').change(function () {
                var worktimeVal = new Array();
                $("input[name=workTime]").each(function () {
                    if ($(this).is(":checked")) worktimeVal.push(1);
                    else worktimeVal.push(0);
                });
                if ($(this).prop('checked') == true) $(this).parent().parent().addClass('ui_checked');
                else $(this).parent().parent().removeClass('ui_checked');

                var workHours = getCheckedValByName('workTime').join('');
                var wh = getContinuityName(workHours, HOUR_NAME_KR2);
                if (wh == "") $('#hourNameSpan').html('<s:message code="holidayBusiness.msg.set.worktime"/>');
                else $('#hourNameSpan').html(wh);
            });

            $('#year').change(function () {
                getHoliday();
            });

            $('#datePicker').datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date())
            });

            $('#busiCd').change(function () {
                if ($(this).val() == '') $('div').removeClass('ui_checked');
                getWorkday();
                getHoliday();
            });
            $('#saveBtn').click(function () {
                saveWorkday();
            });
            $('#insertBtn').click(function () {
                var busiCd = $('#busiCd option:selected').val();
                if (busiCd == '') {
                    ui.alertMsg('<s:message code="holidayBusiness.msg.select.busi"/>');
                    return;
                }
                $('#date').attr('disabled', false);
                $("#holidayPop").modal('show');
                $('#holidayPop').attr('mode', 'insert');
                $('#date, #comment').val('');
            });

            var year = new Date().getFullYear();
            var str = '';
            for (var i = year - 8; i < year + 8; i++) {
                if (i == year) str += '<option value="' + i + '" selected>' + i + '</option>';
                else str += '<option value="' + i + '">' + i + '</option>';
            }
            $("#year").html(str);

            $('.savePopBtn').click(function () {
                var mode = $('#holidayPop').attr('mode');

                var date = $('#date').val().ltrim().rtrim();
                var comment = $('#comment').val().ltrim().rtrim();
                var busiCd = $('#busiCd option:selected').val();
                if (date == '') {
                    ui.alertMsg('<s:message code="holidayBusiness.msg.enter.date"/>');
                    return;
                }
                if (comment == '') {
                    ui.alertMsg('<s:message code="holidayBusiness.msg.enter.comment"/>');
                    return;
                }

                var url = 'insertHoliday.xcn';
                var confirmMsg = '<s:message code="common.msg.confirm.add"/>';
                var successMsg = '<s:message code="common.msg.added"/>';
                var curTab = '<s:message code="holidayBusiness.add.busiholiday"/>';
                if (mode == 'modify') {
                    url = 'updateHoliday.xcn';
                    confirmMsg = '<s:message code="common.msg.confirm.modify"/>';
                    successMsg = '<s:message code="common.msg.modified"/>';
                    curTab = '<s:message code="holidayBusiness.modify.busiholiday"/>';
                }
                var busiNm = $('#busiCd option:selected').text();
                ui.confirmMsg(confirmMsg, '', '', function (rs) {
                    if (rs) {
                        grid.on();
                        ui.postJson({
                            url: url,
                            curTab: curTab,
                            busiCd: busiCd,
                            busiNm: busiNm,
                            date: date,
                            comment: comment,
                            success: function (data, total) {
                                ui.alertMsg(successMsg);
                                $('#holidayPop').modal('hide');
                                getHoliday();
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

            $('#deleteBtn').click(function () {
                $('#deleteBtn').prop('disabled', true);
                var rows = grid.getSelectedRows();
                if (rows.length == 0) {
                    ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                    $('#deleteBtn').prop('disabled', false);
                    return;
                }
                var busiNm = $('#busiCd option:selected').text();
                ui.confirmMsg('<s:message code="filterInfo.msg.confirm.deleteitem"/>', '', '', function (rs) {
                    if (rs) {
                        grid.on();
                        ui.get({
                            curTab: '<s:message code="holidayBusiness.delete.busiholiday"/>',
                            busiNm: busiNm,
                            url: 'deleteHoliday.xcn',
                            deleteData: JSON.stringify(rows),
                            success: function (data, total) {
                                ui.alertMsg('<s:message code="common.msg.deleted"/>');
                                getHoliday();
                            },
                            error: function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete: function () {
                                $('#deleteBtn').prop('disabled', false);
                                grid.off();
                            }
                        });
                    } else {
                        $('#deleteBtn').prop('disabled', false);
                    }
                });
            });
        });

        function getCheckedValByName(name) {
            var result = new Array();
            $("[name=" + name + "]").each(function () {
                if ($(this).prop('checked') == true) result.push(1);
                else result.push(0);
            });
            return result;
        }

        function saveWorkday() {
            var busiCd = $('#busiCd option:selected').val();
            var busiNm = $('#busiCd option:selected').text();
            if (busiCd == '') {
                ui.alertMsg('<s:message code="holidayBusiness.msg.add.busi"/>');
                return;
            }

            var workDays = getCheckedValByName('holidayCheck').join('');
            var workHours = getCheckedValByName('workTime').join('');

            if (workDays.indexOf('1') == -1) {
                alert('<s:message code="holidayBusiness.msg.set.workday"/>');
                return;
            }
            if (workHours.indexOf('1') == -1) {
                alert('<s:message code="holidayBusiness.msg.set.worktime"/>');
                return;
            }
            var workDayNm = $('#weekNameSpan').text();
            var workHourNm = $('#hourNameSpan').text();
            var curtab = '<s:message code="holidayBusiness.busiworkday"/>';

            ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function (rs) {
                if (rs) {
                    ui.postJson({
                        url: 'saveWorkday.xcn',
                        curtab: curtab,
                        busiCd: busiCd,
                        busiNm: busiNm,
                        workDay: workDays,
                        workHour: workHours,
                        workDayNm: workDayNm,
                        workHourNm: workHourNm,
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            getWorkday();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                        }
                    });
                } else {
                }
            });
        }

        /*
		 * 업무일,업무시간 조회
		 */
        function getWorkday() {
            var busiCd = $('#busiCd option:selected').val();
            var busiNm = $('#busiCd option:selected').text();
            if (busiCd == '') {
                ui.alertMsg('<s:message code="holidayBusiness.msg.add.busi"/>');
                $("input[name=workTime]").prop("checked", false);
                $("input[name=holidayCheck]").prop("checked", false);
                $('#weekNameSpan').html('<s:message code="holidayBusiness.msg.set.workday"/>');
                $('#hourNameSpan').html('<s:message code="holidayBusiness.msg.set.worktime"/>');
                $("#selectableWorkday li").removeClass("ui-selected");
                $(".HolidayTimeClass li").removeClass("ui-selected");

                return;
            }
            var curtab = '<s:message code="holidayBusiness.busiworkday"/>';
            ui.get({
                url: 'getWorkday.xcn',
                curtab: curtab,
                busiCd: busiCd,
                busiNm: busiNm,
                success: function (data, total) {
                    if (data == null) {
                        data = {};
                        data.workDay = '0000000';
                        data.workHour = '000000000000000000000000';
                    }
                    var wday = data.workDay;
                    for (var i = 0; i < 7; i++) {
                        if (wday.substr(i, 1) == "1") $('.holidayCheck:eq(' + i + ')').prop('checked', true).parent().parent().addClass('ui_checked');
                        else $('.holidayCheck:eq(' + i + ')').prop('checked', false).parent().parent().removeClass('ui_checked');
                    }
                    var whour = data.workHour;
                    for (var i = 0; i < whour.length; i++) {
                        if (whour[i] == '1') $('.workTime:eq(' + i + ')').prop('checked', true).parent().parent().addClass('ui_checked');
                        else $('.workTime:eq(' + i + ')').prop('checked', false).parent().parent().removeClass('ui_checked');
                    }

                    var workHours = getCheckedValByName('workTime').join('');
                    var wd = getContinuityName(wday, WEEK_NAME_KR);
                    var wh = getContinuityName(workHours, HOUR_NAME_KR2);
                    if (wd == "") $('#weekNameSpan').html('<s:message code="holidayBusiness.msg.set.workday"/>');
                    else $('#weekNameSpan').html(wd);
                    if (wh == "") $('#hourNameSpan').html('<s:message code="holidayBusiness.msg.set.worktime"/>');
                    else $('#hourNameSpan').html(wh);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        var short_gsDayNamesKr = 'kr' == 'kr' ? new Array('<s:message code="common.sun"/>', '<s:message code="common.mon"/>', '<s:message code="common.tue"/>', '<s:message code="common.wed"/>', '<s:message code="common.thu"/>', '<s:message code="common.fri"/>', '<s:message code="common.sat"/>') : new Array('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
        var WEEK_NAME_KR = short_gsDayNamesKr;
        var HOUR_NAME_KR2 = new Array(24);
        var cnt = 0;

        function getContinuityName(checkedStr, checkedName) {
            if (checkedStr == null || checkedStr.length == 0) return '';
            for (var i = 0; i < HOUR_NAME_KR2.length; i++) {
                if (i < 10) HOUR_NAME_KR2[i] = "0" + i;
                else HOUR_NAME_KR2[i] = i;
            }
            var tmp = getIntArray(checkedStr);
            var result = '';
            var maxEnd = 0;
            for (var i = 0; i < tmp.length; i++) {
                if (tmp[i] == 0) continue;
                if (i > 0 && i <= maxEnd) continue;
                maxEnd = 0;
                for (var j = i; j < tmp.length; j++) {
                    if (tmp[j] == 0) break;
                    maxEnd = j;
                }
                if (checkedStr.length == 7) {
                    if (i < maxEnd) {
                        result += checkedName[i] + " ~ " + checkedName[maxEnd] + " , ";
                        cnt++;
                    } else {
                        result += checkedName[i] + " , ";
                        cnt++;
                    }
                } else {
                    if (i < maxEnd) {
                        result += checkedName[i] + ":00~" + checkedName[maxEnd] + ":59:59 , ";
                        cnt++;
                    } else {
                        result += checkedName[i] + ":00~" + checkedName[i] + ":59:59 , ";
                        cnt++;
                    }
                    if (checkedName == HOUR_NAME_KR2) result += "";
                }
            }
            if (result.length > 0) result = result.substring(0, result.lastIndexOf(','));
            return result;
        }

        function getIntArray(args) {
            var result = new Array(args);
            for (var i = 0; i < args.length; i++) {
                if (args.charAt(i) == '1') result[i] = 1;
                else result[i] = 0;
            }
            return result;
        }

        /*
		 * 사업장 휴일 목록
		 */
        function getHoliday() {
            var busiCd = $('#busiCd option:selected').val();
            var busiNm = $('#busiCd option:selected').text();
            var workDay = $('#weekNameSpan').text();
            var workHour = $('#hourNameSpan').text();
            var year = $('#year option:selected').val();
            if (busiCd == '') return;
            ui.get({
                url: 'getHolidayList.xcn',
                curTab: '<s:message code="holidayBusiness.search.busiholiday"/>',
                busiCd: busiCd,
                busiNm: busiNm,
                year: year,
                success: function (data, total) {
                    grid.setData(data);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        function getBusiList() {
            var result = '<option value="">-<s:message code="ipRange.msg.select.busi"/>-</option>';
            ui.get({
                url: 'getBusiList.xcn',
                async: false,
                success: function (data, total) {
                    for (var i = 0; i < data.length; i++) {
                        result += '<option value="' + data[i].busiCd + '">(' + data[i].coNm + ') ' + data[i].busiNm + '</option>';
                    }
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    $('#busiCd').html(result);
                    $('#busiCd option:eq(1)').attr('selected', 'selected').trigger('change');

                }
            });
        }
	</script>
</head>

<div class="modal" id="holidayPop" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="holidayPopForm">
			<div class="modalHead">
				<h2><s:message code="holidayBusiness.busiholiday"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="holidayBusiness.busiholiday"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="attachTypePopInput" class="fname"><s:message code="condition.date"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type='date' class="w40" id='date'/>
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="attachDescPopInput" class="fname"><s:message code="common.msg.comment"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="comment" id="comment" placeholder="<s:message code="common.msg.comment"/>" maxlength="150">
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 savePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>


<div>
	<!-- 검색 -->
	<div class="searchArea w100">
		<div class="searchSub w100">
			<div>
				<label for="busiCd" style="display:none;"><s:message code="common.org.busi"/></label>
				<select id="busiCd" name="busiCd" style="min-width: 150px;">
					<option value="">-<s:message code="ipRange.msg.select.busi"/>-</option>
				</select>
			</div>
		</div>
	</div>
	<!-- //검색 -->
	<!-- content -->
	<div class="content">
		<div class="contentSub">
			<div class="chartArea02">
				<!-- 업무구분 -->
				<div>
					<h3><s:message code="holidayBusiness.worktype"/></h3>
					<div class="sel">
						<button type="button" class="btn05" accesskey="S" id="saveBtn">
							<img src="<c:url value="/img/subBtn_save.png"/>" alt="저장"><s:message code="common.msg.save"/>
						</button>
					</div>
					<div class="panel panel-default p20">

						<div class="chartArea03">
							<div>
								<div class="p12 grayBg02 mab12 conTit">
									<s:message code="holidayBusiness.select.workday"/>
								</div>
								<div class="form-group">
									<label class="checkbox-inline  pt8" style="font-weight: bold">
										<input type="checkbox" class="holidayCheckAll" name="holidayCheckAll">
										<s:message code="common.msg.selectUnselect"/>
									</label>
								</div>
								<div class="form-group">
									<label class="checkbox-inline ">
										<input type="checkbox" class="holidayCheck" name="holidayCheck">
										<s:message code="common.sunday"/>
									</label>
								</div>
								<div class="form-group">
									<label class="checkbox-inline ">
										<input type="checkbox" class="holidayCheck" name="holidayCheck" value="0">
										<s:message code="common.monday"/>
									</label>
								</div>
								<div class="form-group">
									<label class="checkbox-inline ">
										<input type="checkbox" class="holidayCheck" name="holidayCheck" value="0">
										<s:message code="common.tuesday"/>
									</label>
								</div>
								<div class="form-group">
									<label class="checkbox-inline ">
										<input type="checkbox" class="holidayCheck" name="holidayCheck" value="0">
										<s:message code="common.wednesday"/>
									</label>
								</div>
								<div class="form-group">
									<label class="checkbox-inline ">
										<input type="checkbox" class="holidayCheck" name="holidayCheck" value="0">
										<s:message code="common.thursday"/>
									</label>
								</div>
								<div class="form-group">
									<label class="checkbox-inline ">
										<input type="checkbox" class="holidayCheck" name="holidayCheck" value="0">
										<s:message code="common.friday"/>
									</label>
								</div>
								<div class="form-group">
									<label class="checkbox-inline ">
										<input type="checkbox" class="holidayCheck" name="holidayCheck" value="0">
										<s:message code="common.saturday"/>
									</label>
								</div>
							</div>
							<div>
								<div class="p12 grayBg02 mab12 conTit">
									<s:message code="holidayBusiness.select.worktimeam"/></div>
								<div class="form-group">
									<label class="checkbox-inline  pt8" style="font-weight: bold">
										<input type="checkbox" class="workTimeAmAll" name="workTimeAmAll">
										<s:message code="common.msg.selectUnselect"/>
									</label>
								</div>
								<%for (int i = 0; i <= 11; i++) {%>
								<div class="form-group">
									<label class="checkbox-inline  amTime">
										<input type="checkbox" class="workTime" name="workTime" value="<%=i%>">
										<%=Common.lPad(i, 2, "0")%>:00
										~ <%=Common.lPad(i, 2, "0")%>:59:59
									</label>
								</div>
								<%}%>
							</div>
							<div>
								<div class="p12 grayBg02 mab12 conTit">
									<s:message code="holidayBusiness.select.worktimepm"/></div>
								<div class="form-group">
									<label class="checkbox-inline  pt8" style="font-weight: bold">
										<input type="checkbox" class="workTimePmAll" name="workTimePmAll">
										<s:message code="common.msg.selectUnselect"/>
									</label>
								</div>
								<%for (int i = 12; i <= 23; i++) {%>
								<div class="form-group">
									<label class="checkbox-inline  pmTime">
										<input type="checkbox" class="workTime" name="workTime" value="<%=i%>">
										<%=Common.lPad(i, 2, "0")%>:00
										~ <%=Common.lPad(i, 2, "0")%>:59:59
									</label>
								</div>
								<%}%>
							</div>
						</div>
						<div class="inner_emass blueBg">
							<p class="col-35"><span class="bullet01"></span><span class="blue mal4"><s:message code="holidayBusiness.workday"/></span></span></p>
							<span id="weekNameSpan" class="col-65 fs14"></span>
						</div>
						<div class="inner_emass blueBg mat8 line_h1_5">
							<p class="col-35"><span class="bullet01"></span><span class="blue mal4"><s:message code="holidayBusiness.worktime"/></span></span></p>
							<span id="hourNameSpan" class="col-65 fs14"></span>
						</div>
					</div>
				</div>
				<!-- //업무구분 -->
				<!-- 사업장 휴일 목록 -->
				<div>
					<h3><s:message code="holidayBusiness.list.busiholiday"/></h3>
					<div class="sel">
						<select id="year">
							<option value="">- <s:message code="holidayBusiness.select.year"/> -</option>
						</select>
						<button type="button" class="btn01" accesskey="I" id="insertBtn">
							<img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/>
						</button>
						<button type="button" class="btn02" accesskey="D" id="deleteBtn"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제">
							<s:message code="common.msg.delete"/>
						</button>
					</div>
					<div>
						<div class="inner_scroll">
							<div style="overflow-x:auto;">
								<div id="holidayListGrid" class="slickGrid gridArea" style=" min-height: 545px;"></div>
							</div>
						</div>
					</div>

				</div>
				<!-- //사업장 휴일 목록 -->
			</div>
		</div>
	</div>
	<!-- //content -->
</div>

<script type="text/javascript">
    var grid = new Xgrid('holidayListGrid', contextRoot);
    grid.onCheckBox();
    grid.autoNumber();
    grid.colAdd('date', '<s:message code="condition.date"/>', 130, 'center', false, 'link');
    grid.colAdd('comment', '<s:message code="common.msg.comment"/>', 250, 'left', false, 'nomal');
    grid.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 130, 'center', false, 'nomal');
    grid.onClick = function () {
        if (grid.Col == grid.ColIndex('date')) {
            $('#holidayPop').attr('mode', 'modify');
            $('#date').val(grid.getValue(grid.Row, 'date')).prop('disabled', true);
            $('#comment').val(grid.getValue(grid.Row, 'comment'));

            $("#holidayPop").modal('show');
        }
    };
    grid.loadHeader(false);
    grid.initData('<s:message code="ipRange.msg.select.busi"/>')
    writeExportMenu('export_menu', 'holidayListGrid', '<s:message code="holidayBusiness.list.busiholiday"/>');
</script>
