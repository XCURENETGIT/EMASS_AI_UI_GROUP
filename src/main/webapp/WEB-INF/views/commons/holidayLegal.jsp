<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<head>
	<script type="text/javascript">
        var searchFlag = false;
        var busiCd = '00000';
        $(document).ready(function () {
            $('#datePicker').datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date())
            });
            initDateTimePicker('startdate',null);

            $('#year').change(function () {
                getHoliday();
            });
            $('#insertBtn').click(function () {
                $('#date').prop('disabled', false);
                $("#holidayPop").modal('show');
                $('#holidayPop').attr('mode', 'insert');
                $('#date, #comment').val('');
            });

            var year = new Date().getFullYear();
            var str = '';
            for (var i = year - 8; i < year + 8; i++) {
                if (i == year)
                    str += '<option value="' + i + '" selected>' + i + '</option>';
                else
                    str += '<option value="' + i + '">' + i + '</option>';
            }
            $("#year").html(str);

            $('.savePopBtn').click(function () {
                var mode = $('#holidayPop').attr('mode');

                var date = $('#startdate').val().ltrim().rtrim();
                var comment = $('#comment').val().ltrim().rtrim();
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
                var curTab = '<s:message code="holidayLegal.add.holidaylegal"/>';
                if (mode == 'modify') {
                    url = 'updateHoliday.xcn';
                    confirmMsg = '<s:message code="common.msg.confirm.modify"/>';
                    successMsg = '<s:message code="common.msg.modified"/>';
                    curTab = '<s:message code="holidayLegal.modify.holidaylegal"/>';
                }
                ui.confirmMsg(confirmMsg, '', '', function (rs) {
                    if (rs) {
                        grid.on();
                        ui.postJson({
                            url: url,
                            busiCd: busiCd,
                            busiNm: '<s:message code="common.msg.all"/>',
                            date: date,
                            curTab: curTab,
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

                ui.confirmMsg('<s:message code="filterInfo.msg.confirm.deleteitem"/>', '', '', function (rs) {
                    if (rs) {
                        grid.on();
                        ui.get({
                            busiNm: '<s:message code="common.msg.all"/>',
                            curTab: '<s:message code="holidayLegal.delete.holidaylegal"/>',
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

            getHoliday();
        });

        /*
		 * 법정 공휴일 목록
		 */
        function getHoliday() {
            var year = $('#year option:selected').val();
            ui.get({
                busiNm: '<s:message code="common.msg.all"/>',
                url: 'getHolidayList.xcn',
                curTab: '<s:message code="holidayLegal.search.holidaylegal"/>',
                busiCd: busiCd,
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
	</script>
</head>

<div class="modal" id="holidayPop" data-backdrop="static"  tabindex="-1" role="dialog">
	<div class="modal-content">
		<form method="post" id="holidayPopForm">
			<div class="modalHead">
				<h2><s:message code="holidayLegal.holidaylegal"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>

			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="holidayLegal.holidaylegal"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="new-row">
						<div class="col-35">
							<label for="attachTypePopInput" class="fname"><s:message code="condition.date"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type='text' class="w40" id='startdate'/>
						</div>
					</div>

					<div class="new-row">
						<div class="col-35">
							<label for="attachDescPopInput" class="fname"><s:message code="common.msg.comment"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input hidden="hidden" />
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
	<div class="searchArea">
		<div class="searchSub">
			<div>
				<select class="w90" id="year" style="width: 80px;">
					<option value="">- <s:message code="holidayBusiness.select.year"/> -</option>
				</select>
			</div>
			<div>
				<button type="button" class="btn01" accesskey="I" id="insertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
				<button type="button" class="btn02" accesskey="D" id="deleteBtn"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
			</div>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					<s:message code="holidayLegal.holidaylegal"/> <s:message code="dashboardSetup.dashtype.list"/>
					<span id="holidayLegalCount"></span>
				</button>
			</div>
			<div id="holidayLegalListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>


<script type="text/javascript">
    var grid = new Xgrid('holidayLegalListGrid', contextRoot);
    grid.onCheckBox();
    grid.autoNumber();
    grid.colAdd('date', '<s:message code="condition.date"/>', 130, 'center', false, 'link');
    grid.colAdd('comment', '<s:message code="common.msg.comment"/>', 250, 'left', false, 'nomal');
    grid.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 150, 'center', false, 'nomal');
    grid.onClick = function () {
        if (grid.Col == grid.ColIndex('date')) {
            $('#holidayPop').attr('mode', 'modify');
            $('#date').val(grid.getValue(grid.Row, 'date')).prop('disabled', true);
            $('#comment').val(grid.getValue(grid.Row, 'comment'));
            $("#holidayPop").modal('show');
        }
    };
    grid.loadExportMenu('<s:message code="holidayLegal.navi.title3"/>');
    grid.loadHeader(false);
</script>
