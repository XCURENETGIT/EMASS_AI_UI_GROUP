<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title></title>
<%@ include file="../base.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/bootstrap-datetimepicker.min.css"/>"/>
<script type="text/javascript" src="<c:url value="/js/moment.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/collapse.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ko.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker.min.js"/>"></script>
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
	$('#deviceIp').change(function(){
		getData();
	});
	$('#eventLevel').change(function(){
		getData();
	});
	$("#deviceIp").html(getDeviceOptions());
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
	var deviceIp = $("#deviceIp").val();
	var devision = $("#devision").val();
	var eventLevel = $("#eventLevel").val();
	var deviceNm = $('#deviceIp option:selected').text()
	var eventLevelNm = $('#eventLevel option:selected').text()
	if(deviceIp == ''){
		deviceNm = '<s:message code="common.msg.all"/>'
	}
	if(eventLevel == ''){
		eventLevelNm = '<s:message code="common.msg.all"/>'
	}
	if(startDt > endDt) ui.alertMsg('<s:message code="blockHistoryNonBusi.msg.cannot.startendtime"/>');
	grid.on();
	searchFlag=true;
	ui.get({
		url 		: 'getSnmpTrapList.xcn',
		startDt 	: startDt,
		endDt 		: endDt,
		deviceIp	: deviceIp,
		devision	: devision,
		eventLevel	: eventLevel,
		deviceNm    : deviceNm,
		eventLevelNm: eventLevelNm,
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

function getDeviceOptions(){
	var result = '<option value="">- <s:message code="eventLog.select.device"/> -</option>';
	ui.get({
		url : 'getDeviceList.xcn',
		asyncFlag : false,
		success : function(data, total) {
			for (var i = 0; i < data.devices.length; i++) {
				result+='<option value="' + data.devices[i].deviceIp + '">' +  data.devices[i].deviceNm + ' ('+data.devices[i].deviceIp+')</option>';
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
	return result;
}
</script>
</head>
<body class="mini-navbar">
	
	<jsp:include page="../top.jsp"/>

	<div class="container"> 
		<div class="boxArea">
			<div class="content_body">	
				<div class="row">
					<div class="col-xs-8 text-left">
						<div class="form-group form-inline not-dashed">
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
								<select class="form-control input-sm" id="deviceIp">
									<option value="">- <s:message code="eventLog.select.device"/> -</option>
								</select>
							</div>
							<select style="display: none;" class="form-control input-sm" id="devision">
							</select>
							<div class="form-group">
								<select class="form-control input-sm" id="eventLevel">
									<option value="">- <s:message code="eventLog.eventlevel"/> -</option>
									<option value="I"><s:message code="deviceInfo.interest"/></option>
									<option value="W"><s:message code="deviceInfo.caution"/></option>
									<option value="E"><s:message code="deviceInfo.danger"/></option>
								</select>
							</div>
							<div class="btn-group">
								<button type="button" class="btn btn-success btn-sm" accesskey="Q" id="searchBtn" accesskey="s"><span class="glyphicon glyphicon-search"></span></button>
							</div>
						</div>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="eventLogListGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var grid = new Xgrid('eventLogListGrid', contextRoot);
		grid.autoNumber();
		grid.colAdd('eventDt', '<s:message code="eventLog.eventtime"/>', 160, 'center', false, 'nomal');
		grid.colAdd('deviceNm', '<s:message code="eventLog.devname"/>', 120, 'left', false, 'nomal');
		grid.colAdd('deviceIp', '<s:message code="eventLog.devip"/>', 120, 'center', false, 'nomal');
		grid.colAdd('devision', '<s:message code="eventLog.eventtype"/>', 150, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
			if(value=='CPU') return '<s:message code="eventLog.cpustatus"/>';
			else if(value=='MEM') return '<s:message code="eventLog.memorystatus"/>';
			else if(value=='HDD') return '<s:message code="eventLog.hddstatus"/>';
			else if(value=='CLR') return '<s:message code="eventLog.deletelog"/>';
			else if(value=='SVC') return '<s:message code="eventLog.svcstatus"/>';
			else if(value=='PROC') return '<s:message code="eventLog.processstatus"/>';
			else if(value=='LINK') return '<s:message code="eventLog.networkstatus"/>';
			else if(value=='TRA') return '<s:message code="eventLog.trafficstatus"/>';
			else if(value=='SNMP') return '<s:message code="eventLog.snmpstatus"/>';
			return '-';
		});
		grid.colAdd('eventLevel', '<s:message code="eventLog.eventlevel"/>', 100, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
			if(value=='I') return '<s:message code="deviceInfo.interest"/>';
			else if(value=='W') return '<s:message code="deviceInfo.caution"/>';
			else if(value=='E') return '<s:message code="deviceInfo.danger"/>';
			return '-';
		});
		grid.colAdd('content', '<s:message code="eventLog.info"/>', 500, 'left', false, 'nomal');
		
		grid.loadExportMenu('<s:message code="eventLog.dev.log"/>');
		grid.loadPageSize();
		grid.loadHeader(true);
		grid.initData('<s:message code="common.msg.search.click"/>');
		grid.changePageSize = function(cnt){
			getData();
		};
	</script>

	<jsp:include page="../footer.jsp"/>

</body>
</html>