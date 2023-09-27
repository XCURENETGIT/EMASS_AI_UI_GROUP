<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title></title>
<%@ include file="../base.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/panelsTab.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/bootstrap-datetimepicker.min.css"/>" />
<script type="text/javascript" src="<c:url value="/js/moment.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/collapse.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ko.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker.min.js"/>"></script>
<style>
</style>
<script>
	var searchFlag = false;
	var busiCd = '00000';
	$(document).ready(function() {
		$('#datePicker').datetimepicker({
			format : 'YYYY-MM-DD',
			locale : 'ko',
			defaultDate : moment(new Date())
		});

		$('#year').change(function() {
			getHoliday();
		});
		$('#insertBtn').click(function() {
			$('#date').prop('disabled', false);
			$("#holidayPop").modal('show');
			$('#holidayPop').attr('mode', 'insert');
			$('#date, #comment').val('');
		});

		var year = new Date().getFullYear();
		var str = '';
		for (var i = year - 8; i < year + 8; i++) {
			if (i == year)
				str += '<option value="'+ i +'" selected>' + i + '</option>';
			else
				str += '<option value="'+ i +'">' + i + '</option>';
		}
		$("#year").html(str);

		$('.savePopBtn').click(function() {
			var mode = $('#holidayPop').attr('mode');

			var date = $('#date').val().ltrim().rtrim();
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
			ui.confirmMsg(confirmMsg, '', '', function(rs) {
				if (rs) {
					grid.on();
					ui.postJson({
						url : url,
						busiCd : busiCd,
						busiNm : '<s:message code="common.msg.all"/>',
						date : date,
						curTab : curTab,
						comment : comment,
						success : function(data, total) {
							ui.alertMsg(successMsg);
							$('#holidayPop').modal('hide');
							getHoliday();
						},
						error : function(status, message) {
							ui.alertMsg(message);
						},
						complete : function() {
							grid.off();
						}
					});
				}
			});
		});

		$('#deleteBtn').click(function() {
			$('#deleteBtn').prop('disabled', true);
			var rows = grid.getSelectedRows();
			if (rows.length == 0) {
				ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
				$('#deleteBtn').prop('disabled', false);
				return;
			}

			ui.confirmMsg('<s:message code="filterInfo.msg.confirm.deleteitem"/>', '', '', function(rs) {
				if (rs) {
					grid.on();
					ui.get({
						busiNm : '<s:message code="common.msg.all"/>',
						curTab : '<s:message code="holidayLegal.delete.holidaylegal"/>',
						url : 'deleteHoliday.xcn',
						deleteData : JSON.stringify(rows),
						success : function(data, total) {
							ui.alertMsg('<s:message code="common.msg.deleted"/>');
							getHoliday();
						},
						error : function(status, message) {
							ui.alertMsg(message);
						},
						complete : function() {
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
			busiNm : '<s:message code="common.msg.all"/>',
			url : 'getHolidayList.xcn',
			curTab : '<s:message code="holidayLegal.search.holidaylegal"/>',
			busiCd : busiCd,
			year : year,
			success : function(data, total) {
				grid.setData(data);
			},
			error : function(status, message) {
				ui.alertMsg(message);
			},
			complete : function() {
			}
		});
	}
</script>
</head>
<body class="mini-navbar">
	<div class="modal fade" id="holidayPop" tabindex="-1" role="dialog" aria-labelledby="holidayModal">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="holidayPopForm">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="holidayLegal.holidaylegal"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-inline">
							<label for="attachTypePopInput" class="control-label col-xs-3"><s:message code="condition.date"/></label>
							<div class='input-group date' id='datePicker'>
								<input type='text' class="input-sm form-control" id='date' /> <span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
						</div>
						<div class="form-inline">
							<label for="attachDescPopInput" class="control-label col-xs-3"><s:message code="common.msg.comment"/></label> <input type="text" class="form-control" name="comment" id="comment" placeholder="<s:message code="common.msg.comment"/>" style="width: 350px;" maxlength="150">
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
						<button type="button" class="btn btn-primary savePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<jsp:include page="../top.jsp"/>
	<div class="container"> 
		<div class="boxArea">
			<div class="content_body">
				<div class="row" style="line-height: 0px;">
					<div class="col-xs-8 text-left">
						<div class="form-group form-inline not-dashed">
							<select class="form-control input-sm" id="year">
								<option value="">- <s:message code="holidayBusiness.select.year"/> -</option>
							</select>
							<button type="button" class="btn btn-sm btn-primary" accesskey="I" id="insertBtn">
								<span class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/>
							</button>
							<button type="button" class="btn btn-sm btn-default" accesskey="D" id="deleteBtn">
								<span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/>
							</button>
						</div>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="holidayLegalListGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		var grid = new Xgrid('holidayLegalListGrid', contextRoot);
		grid.onCheckBox();
		grid.autoNumber();
		grid.colAdd('date', '<s:message code="condition.date"/>', 130, 'center', false, 'link');
		grid.colAdd('comment', '<s:message code="common.msg.comment"/>', 250, 'left', false, 'nomal');
		grid.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 130, 'center', false, 'nomal');
		grid.onClick = function() {
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
	<jsp:include page="../footer.jsp"/>
</body>
</html>