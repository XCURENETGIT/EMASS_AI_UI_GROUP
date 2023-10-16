<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LTH - 시스템 로그</title>
<style type="text/css">
</style>
<script type="text/javascript">
var searchFlag=false;
$(document).ready(function(){
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

	$('#searchBtn').click(function(){
		getData();
	});
	getData();
});

function getData(lastRow) {
	if(searchFlag) return;
	if ( lastRow == undefined ) {
		grid.data.length = 0;
		grid.rtnNextPageFunc = getData;
		grid.loadingPage = 0;
	} else {
		grid.loadingPage++;
	}
	var startDt = $('#startDt').val().replaceAll("-","");
	var endDt = $('#endDt').val().replaceAll("-","");
	var service= $("#service").val();
	if(startDt > endDt) ui.alertMsg('<s:message code="blockHistoryNonBusi.msg.cannot.startendtime"/>');

	grid.on();
	searchFlag=true;
	ui.get({
		url 		: 'getXcnLogList.xcn',
		product 	: 'EMASS',
		startDt 	: startDt,
		endDt 		: endDt,
		service		: service,
		offset 		: grid.data.length,
		limit 		: grid.pageSize,
		success 	: function(data, total) {
			grid.appendData(data);
		},
		error 		: function(status, message) {
			ui.alertMsg(message);
		},
		complete 	: function() {
			searchFlag=false;
			grid.off();
		}
	});
}
</script>
</head>
<body class="mini-navbar">
	<div class="container" style="position: absolute; top: 50px; left: 0px; right: 0px; bottom:0px; min-width: 1000px;min-height:520px;">
		<div class="content mainBodyArea">
			<div class="naviBack">
				<img src="<c:url value="/img/title/home_icon.gif"/>" width="28" height="33">
				<span class="navi"><s:message code="auditLog.navi.title1"/> &gt; <s:message code="OPERATION_MGMT.SYS_LOG"/></span>
			</div>
			<div style="position: absolute; top: 21px; right: 300px; z-index: 999;">
				<a href="javascript: void(0)" id="titleOpen" style="display: none;"><img src="<c:url value="/img/btn/down.png"/>" /></a>
			</div>
			<div style="position: absolute; top: 155px; right: 300px; z-index: 999;">
				<a href="javascript: void(0)" id="titleClose"><img  src="<c:url value="/img/btn/up.png"/>" /></a>
			</div>
			<div class="content_header">
				<div style="padding: 20px; color: #545454;">
					<h3 style="cursor:help;"><s:message code="OPERATION_MGMT.SYS_LOG"/></h3>
					<div class="subMsg">
						<s:message code="xcnlog.msg.msg1"/><br>
						<s:message code="xcnlog.msg.msg2"/>
					</div>
				</div>
			</div>
			<div class="boxArea" style="height:calc(100% - 220px);">
				<div class="well content_box" style="height:100%;">
					<div class="content_body" style="height:100%;">
						<div class="row" style="line-height: 0px;">
							<div class="col-xs-8 text-left">
								<div class="form-group form-inline">
									<div class='input-group date' id='startDatePicker'>
										<input type='text' class="input-sm form-control" id='startDt' />
										<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
										</span>
									</div>
									~
									<div class='input-group date' id='endDatePicker'>
										<input type='text' class="input-sm form-control" id='endDt' />
										<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
										</span>
									</div>
									<div class="form-group">
										<select class="form-control input-sm" id="service">
											<option value="">- <s:message code="xcnlog.log"/> -</option>
											<option value="A"><s:message code="xcnlog.audit"/></option>
											<option value="P"><s:message code="xcnlog.process"/></option>
											<option value="I"><s:message code="xcnlog.integrity"/></option>
											<option value="S"><s:message code="xcnlog.system"/></option>
										</select>
									</div>
									<div class="btn-group">
										<button type="button" class="btn btn-success btn-sm" accesskey="Q" id="searchBtn"><span class="glyphicon glyphicon-search"></span></button>
									</div>
								</div>
							</div>
							<div class="col-xs-4 text-right">
								<div class="btn-group">
									<button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown">
										<span class="glyphicon glyphicon-download-alt"></span>&nbsp;<s:message code="common.msg.export"/> <span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu">
										<li><a href="#" class="excel_link" data-target="xcnLogListGrid" rel='<s:message code="OPERATION_MGMT.SYS_LOG"/>'><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="common.msg.excel"/></a></li>
										<li><a href="#" class="csv_link" data-target="xcnLogListGrid" rel='<s:message code="OPERATION_MGMT.SYS_LOG"/>'><span class="fa fa-file-text" style="font-size:16px"></span>&nbsp;CSV</a></li>
										<li><a href="#" class="print_link" data-target="xcnLogListGrid" rel='<s:message code="OPERATION_MGMT.SYS_LOG"/>'><span class="glyphicon glyphicon-print"></span>&nbsp;<s:message code="common.msg.print"/></a></li>
									</ul>
								</div>
								<div class="btn-group grid-limit" id="listCnt"></div>
							</div>
						</div>
						<div id="xcnLogListGrid" class="slickGrid gridArea" style="position: relative; top: 5px; left: 0px; height:100%;"></div>
						<div id="total_cnt" style="margin-top:12px; color: #f25643; font-weight: bold; font-size: 13px;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var grid = new Xgrid('xcnLogListGrid', contextRoot);
		grid.autoNumber();
		grid.colAdd('ctime', '<s:message code="xcnlog.worktime"/>', 150, 'center', false, 'nomal');
		grid.colAdd('ip', '<s:message code="xcnlog.deviceIp"/>', 150, 'center', false, 'nomal');
		grid.colAdd('module', '<s:message code="xcnlog.module"/>', 150, 'center', false, 'nomal');
		grid.colAdd('service', '<s:message code="xcnlog.log"/>', 200, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext){
			if(value=='A') return '<s:message code="xcnlog.audit"/>';
			else if(value=='P') return '<s:message code="xcnlog.process"/>';
			else if(value=='I') return '<s:message code="xcnlog.integrity"/>';
			else if(value=='S') return '<s:message code="xcnlog.system"/>';
			else return '-';
		});
		grid.colAdd('type', '<s:message code="xcnlog.logtype"/>', 200, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext){
			if(value=='S') return '<s:message code="xcnlog.start"/>';
			else if(value=='E') return '<s:message code="xcnlog.end"/>';
			else if(value=='R') return '<s:message code="xcnlog.working"/>';
			else if(value=='X') return '<s:message code="xcnlog.notwork"/>';
			else if(value=='N') return '<s:message code="xcnlog.damage"/>';
			else if(value=='U') return '<s:message code="xcnlog.notification"/>';
			else if(value=='F') return '<s:message code="xcnlog.saturation"/>';
			else if(value=='D') return '<s:message code="xcnlog.delete"/>';
			else return '-';
		});
		grid.colAdd('info', '<s:message code="xcnlog.info"/>', 400, 'left', false, 'nomal');
		grid.loadHeader(true);
		grid.initData('<s:message code="xcnlog.msg.search"/>');
	</script>
</body>
</html>