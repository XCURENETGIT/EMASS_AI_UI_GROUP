<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LTH - Scheduler</title>
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
$(document).ready(function(){
	$('#searchBtn').click(function(){
		getData();
	});
	$('#runBtn').click(function(){
		if(grid.Row == undefined || grid.Row == -1) {
			ui.alertMsg('Job을 선택 하세요.');
			return;
		}
		var jobId = grid.getValue(grid.Row, 'jobId');
		grid.on();
		ui.get({
			url : 'runJob.xcn',
			jobId : jobId,
			success : function(data, total) {
				ui.alertMsg('Job을 실행 하였습니다.');
				getData();
			},
			error : function(status, message) {
				ui.alertMsg(message);
			},
			complete : function() {
				grid.off();
			}
		});
	});
	
	getData();
});

function getData(lastRow) {
	grid.on();
	ui.get({
		url : 'getJobList.xcn',
		success : function(data, total) {
			grid.setData(data);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			grid.off();
		}
	});
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
						<div class="form-group form-inline">
							<div class="btn-group">
								<button type="button" class="btn btn-success btn-sm" accesskey="Q" id="searchBtn"><span title="refresh" class="glyphicon glyphicon-repeat"></span> REFRESH</button>
							</div>
							<div class="btn-group">
								<button type="button" class="btn btn-primary btn-sm" accesskey="E" id="runBtn"><span title="Run" class="glyphicon glyphicon-play"></span> Run Job</button>
							</div>
						</div>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="scheduleListGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var grid = new Xgrid('scheduleListGrid', contextRoot);
		grid.autoNumber();
		grid.colAdd('description', 		'Job Name', 			200, 'left',		false, 'bold');
		grid.colAdd('jobId', 			'Job ID', 				180, 'center', 		false, 'nomal');
		grid.colAdd('cronExp', 			'Cron Expression', 		200, 'center', 		false, 'nomal');
		grid.colAdd('previousFireTime', 'Previous Fire Time', 	150, 'center', 		false, 'nomal');
		grid.colAdd('nextFireTime', 	'Next Fire Time', 		150, 'center', 		false, 'nomal');
		grid.colAdd('startTime', 		'Start Time', 			150, 'center', 		false, 'nomal');
		grid.colAdd('jobClass', 		'Job Class', 			250, 'center', 		false, 'nomal');
		grid.loadHeader(true);
		grid.initData('검색하시기 바랍니다.');
	</script>
</body>
</html>