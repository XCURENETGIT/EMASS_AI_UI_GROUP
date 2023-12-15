<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>--%>
<%--<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>--%>
<%--<%@page import="com.xcurenet.common.util.Common"%>--%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<%
	String deviceSeq = Common.nvl(request.getParameter("deviceSeq"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title><s:message code="deviceInfo.title"/></title>
<%--<%@ include file="../base.jsp"%>--%>
<%--<link rel="stylesheet" href="<c:url value="/css/slider.css"/>" />--%>
<%--<link rel="stylesheet" href="<c:url value="/css/jquery.circliful.css"/>">--%>
<%--<link rel="stylesheet" href="<c:url value="/css/bootstrap-select.min.css"/>"/>--%>
<%--<link rel="stylesheet" href="<c:url value="/css/beyond.min.css"/>" />--%>


<%--<script type="text/javascript" src="<c:url value="/js/jquery.circliful.min.js"/>"></script>--%>
<%--<script type="text/javascript" src="<c:url value="/js/jquery.nestable.min.js"/>"></script>--%>
<%--<script type="text/javascript" src="<c:url value="/js/bootstrap-slider.js"/>"></script>--%>
<%--<script type="text/javascript" src="<c:url value="/js/bootstrap-select.js"/>"></script>--%>
<%--<script type="text/javascript" src="<c:url value="/js/hotkey.js"/>"></script>--%>

<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<![endif]-->

<style type="text/css">
.top_space2 {
	padding-top: 15px;
}

.table{margin-bottom: 0px !important;}
.fsImg {
	width: 30px;
}
#alarmCri .slider-selection {
	background: #5cb85c;
}
#saturationCri .slider-selection{
	background: #f0ad4e;
}
#deleteCri .slider-selection {
	background: #729fcf;
}
#alarmLv1Text, #saturationLv1Text, #alarmLvText {
	font-weight: bold;
	font-size: 14px;
}
.table-bordered th {
	background-color: #fbfbfb;
	text-align: center;
}
.memoryTbl td {
	text-align: center;
}
.process_normal {
}

.process_none {
	color: #FD9C44;
	font-weight: bold;
}
.process_warn {
	color: #BE7533;
	font-weight: bold;
}
.interface_warn {
	color: #BE7533;
	font-weight: bold;
}
.c-checkbox input[type=checkbox]:checked + span {
	background-color: #be7533;
}
.bootstrap-select .btn{
	padding:4px 12px;
}
.dropdown-menu > li > a:focus, .dropdown-menu > li > a:hover{
	background-color: rgba(51, 122, 183, 1);
	color: white;
}

button[data-id=deviceSelect] {
	display: none !important;
}


/* Work Progress table */
.panel.work-progress-table {
	border: medium none;

	-webkit-border-radius: 0;
	-moz-border-radius: 0;
	-ms-border-radius: 0;
	-o-border-radius: 0;
	border-radius: 0;

	box-shadow: none;
	float: left;
	margin: 0;
	width: 100%;
}
.panel.work-progress-table > .panel-heading {
	background: none repeat scroll 0 0 #fbfbfb;

	-webkit-border-radius: 0;
	-moz-border-radius: 0;
	-ms-border-radius: 0;
	-o-border-radius: 0;
	border-radius: 0;

	color: #333333;
	float: left;
	font-size: 16px;
	font-weight: normal;
	letter-spacing: 0.3px;
	padding: 17px 30px 11px;
	width: 100%;
}

.work-progress-table > .panel-heading > div > i {
	color: #888888;
	float: left;
	font-family: Lato;
	font-size: 11px;
	font-style: normal;
	letter-spacing: 0.3px;
	line-height: 10px;
	margin-bottom: 10px;
	margin-top: 7px;
	width: 100%;
}
.panel-default > .panel-heading > .dropdown {
	float: right;
	margin-top: -22px;
}
.work-progress-table td .progress {
	background: none repeat scroll 0 0 #e8e8e8;

	-webkit-box-shadow: none;
	-moz-box-shadow: none;
	-ms-box-shadow: none;
	-o-box-shadow: none;
	box-shadow: none;

	height: 6px;
	margin: 7px 0 0;
	overflow: visible;
}
.work-progress-table td .progress > .progress-bar {
	-webkit-box-shadow: none;
	-moz-box-shadow: none;
	-ms-box-shadow: none;
	-o-box-shadow: none;
	box-shadow: none;

	position: relative;
}
.work-progress-table td .progress > .progress-bar > span {
	background: none repeat scroll 0 0 #8d8d8d;
	font-size: 10px;
	height: 18px;
	line-height: 18px;
	margin-top: -9px;
	position: absolute;
	right: 0;
	top: 50%;
	width: 40px;
	cursor:default;
}
.work-progress-table .table th {
	padding: 10px 10px;
}
.work-progress-table .table td {
	padding: 15px 10px;
}
.work-progress-table .table td {
	font-family: Lato;
	font-size: 13px;
	letter-spacing: 0.3px;
	padding: 15px 10px;
}

.support-ticket .removed, .edit-remove > li > .remove, .friend-list li > span.offline:before {
background: -moz-linear-gradient(top, #ff5959 0%, #ff3b3b 100%);
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#ff3b3b), color-stop(100%,#f9f9f9));
background: -webkit-linear-gradient(top, #ff5959 0%,#ff3b3b 100%);
background: -o-linear-gradient(top, #ff5959 0%,#ff3b3b 100%);
background: -ms-linear-gradient(top, #ff5959 0%,#ff3b3b 100%);
background: linear-gradient(to bottom, #ff5959 0%,#ff3b3b 100%);
color: #fff;
}

.panel-heading{
	font-weight: bold;
}
.font14{
	font-size:14px;
}
.cursor_default{
	cursor:default;
}

caption {
	font-weight: bold;
}
.table-bordered>tbody>tr>td, .table-bordered>tbody>tr>th, .table-bordered>tfoot>tr>td, .table-bordered>tfoot>tr>th, .table-bordered>thead>tr>td, .table-bordered>thead>tr>th {
	border: 1px solid #ddd !important;
}
.progress {
	margin-bottom: 0px !important;
}
</style>
<script type="text/javascript">
var circlifulOption={
	animation: 1,
	animationStep: 10,
	foregroundBorderWidth: 3,
	backgroundBorderWidth: 3,
	foregroundColor: '#23B7E5',
	backgroundColor: '#EEF3F7',
	percent: 0,
	textSize: 28,
	pointSize : 10,
	textStyle: 'font-size: 12px;',
	textColor: '#9D9EA0',
	multiPercentage: 1
};
var param_deviceSeq = '<%=deviceSeq%>';

$(document).ready(function(){
	$("[data-toggle=tooltip]").tooltip( );
	
	$(document).on('click', '.nav-tabs a', function(){
		getDeviceInfo( );
	});
	
	$('#refreshBtn').click(function(){
		$('#hddInfoTable').children().each(function(){
			$(this).children().remove();
		});
		getDeviceInfo( );
	});
	
	$('#deviceSelect').selectpicker({
		container:'body',
		width:'0px',
		size: 10,
		noneSelectedText:'<s:message code="common.msg.all"/>'
	}).change(function(){
		getDeviceInfo( );
	});
	
	//장비 목록으로 버튼
	$('#returnListBtn').click(function(){
		location.href = '<c:url value="/commons/deviceInfo.do"/>';
	});
	
	//장비 추가
	$('#insertBtn').click(function(){
		$('#addDevPop').attr('mode', 'insert');
		$('#addDevPop').modal('show');
		$('#deviceIp, #deviceNm, #comment, #sshId, #sshPw').val('');
		$('input:radio[name=deviceType]:input[value=A]').prop("checked", true);
		$('input:radio[name=deviceType]').prop("disabled", false);
	});
	
	$('#sms_file').click(function(){
		var confId = 'device.hdd.sms.'+ $('#deviceSelect').selectpicker('val');
		saveAlarmCheck(confId, $(this).prop('checked'));
	});
	$('#notify_file').click(function(){
		var confId = 'device.hdd.notify.'+ $('#deviceSelect').selectpicker('val');
		saveAlarmCheck(confId, $(this).prop('checked'));
	});
	$('#sms_proc').click(function(){
		var confId = 'device.process.sms.'+ $('#deviceSelect').selectpicker('val');
		saveAlarmCheck(confId, $(this).prop('checked'));
	});
	$('#notify_proc').click(function(){
		var confId = 'device.process.notify.'+ $('#deviceSelect').selectpicker('val');
		saveAlarmCheck(confId, $(this).prop('checked'));
	});
	$('#sms_inter').click(function(){
		var confId = 'device.interface.sms.'+ $('#deviceSelect').selectpicker('val');
		saveAlarmCheck(confId, $(this).prop('checked'));
	});
	$('#notify_inter').click(function(){
		var confId = 'device.interface.notify.'+ $('#deviceSelect').selectpicker('val');
		saveAlarmCheck(confId, $(this).prop('checked'));
	});
	
	$('.savePopBtn').click(function(){
		if( !checkIP( $('#deviceIp').val() ) ) {
			ui.alertMsg( '<s:message code="deviceInfo.msg.ip.wrong"/>');
			$('#accessIp').focus();
			return;
		}
		if( $('#deviceIp').val() == '' ) {
			ui.alertMsg('<s:message code="deviceInfo.msg.enter.ip"/>');
			$('#accessIp').focus();
			return;
		}
		if( $('input:radio[name=deviceType]:checked').val() == 'C' ) {
			if( $('#sshId').val() == '' ) {
				ui.alertMsg('<s:message code="deviceInfo.msg.enter.devid"/>');
				$('#sshId').focus();
				return;
			}
			if( $('#sshPw').val() == '' ) {
				ui.alertMsg('<s:message code="deviceInfo.msg.enter.devpw"/>');
				$('#sshPw').focus();
				return;
			}
		}
		var id = $('#addDevPop').attr('mode');
		if( id == 'insert' ) insertDevice();
		else if( id == 'modify' ) modifyDevice();
	});
	
	$('.saveAlarmPopBtn').click(function(){
		var lv1 = $('#alarmLv1Text').text( );
		var lv2 = $('#alarmLv2Text').text( );
		var lv3 = $('#alarmLv3Text').text( );
		var emgaechi = '';
		var checked = $('#alarmUsed:checked').length;
		if( checked == 0) {
			lv1 = 0; lv2 = 0; lv3 = 0;
			emgaechi = '<s:message code="deviceInfo.unuse.critical"/>'; 
		}else{
			emgaechi = '<s:message code="deviceInfo.use.critical"/>'; 
		}
		
		if ( Number( lv1 ) > Number( lv2 ) ) {
			alert('<s:message code="deviceInfo.set.lower.caution"/>')
			return;
		}
		
		var idx = $('#alertChangePop').attr('idx');
		$('.saveAlarmPopBtn').prop('disabled', true);
		ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function(rs){
			if(rs){
				ui.get({
					emgaechi : emgaechi,
					deviceNm : $('#tblDeviceNm').text(),
					url : 'device/setHddAlarm.xcn',
					deviceIp : $.trim($('#tblDeviceIp').text()),
					index : idx,
					hddNotifyLimit : lv1,
					hddWarnLimit : lv2,
					hddAlarmLimit : lv3,
					deviceSeq : $('#deviceSelect').selectpicker('val'),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						$('#alertChangePop').modal('hide');
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						$('.saveAlarmPopBtn').prop('disabled', false);
						getDeviceStatus();
					}
				});
			} else {
				$('.saveAlarmPopBtn').prop('disabled', false);
			}
		});
	});
	
	//장비 삭제
	$('#deleteBtn').click(function(){
		var deviceSeq = $('#deviceSelect').selectpicker('val');
		$('.deleteBtn').prop('disabled', true);
		ui.confirmMsg('<s:message code="deviceInfo.msg.confirm.deletedev"/>', '', '', function(rs){
			if(rs){
				ui.get({
					url : 'deleteDevice.xcn',
					deviceSeq : deviceSeq,
					deviceNm : $('#tblDeviceNm').text(),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.deleted"/>');
						/* $('#tblDeviceIp').html('');
						$('#tblDeviceNm').html('');
						$('#tblDeviceType').html('');
						$('#tblDeviceType').attr('type','');
						$('#tblComment').html('');
						$('#tblCreatDt').html('');
						$('#tblSshId').html('');
						$('#tblSshPw').html('');
						
						noConnectionDevice();
						getDevice(); */
						window.setTimeout(function(){
							location.href = '<c:url value="/commons/deviceInfo.do"/>';
						}, 3000);
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						//$('.deleteBtn').prop('disabled', false);
						window.setTimeout(function(){
							location.href = '<c:url value="/commons/deviceInfo.do"/>';
						}, 3000);
					}
				});
			} else {
				$('.deleteBtn').prop('disabled', false);
			}
		});
	});
	
	$('#modifyBtn').click(function(){
		$('#addDevPop').attr('mode', 'modify');
		$('#addDevPop').modal('show');
		
		$('#deviceIp').val( $('#tblDeviceIp').text() );
		$('#deviceNm').val( $('#tblDeviceNm').text() );
		$('#comment').val( $('#tblComment').text() );
		
		var type = $('#tblDeviceType').attr('type');
		
		$('input:radio[name=deviceType]:input[value='+type+']').prop("checked", true);
		$('input:radio[name=deviceType]').prop("disabled", true);
		
		if( type == 'C' ) {
			$('#sshId').val( $('#tblSshId').text() );
			$('#sshPw').val( $('#tblSshPw').text() );
			$('#deviceSshIdDiv, #deviceSshPwDiv').show();
		} else {
			$('#deviceSshIdDiv, #deviceSshPwDiv').hide();
		}
	});
	
	$("#alertChangePop").on('shown.bs.modal', function() {
		$('#alarmLv1Critical').slider('setValue', $(this).attr('hddNotifyLimit'));
		$('#alarmLv2Critical').slider('setValue', $(this).attr('hddWarnLimit'));
		$('#alarmLv3Critical').slider('setValue', $(this).attr('hddAlarmLimit'));

		$('#alarmLv1Text').html($(this).attr('hddNotifyLimit'));
		$('#alarmLv2Text').html($(this).attr('hddWarnLimit'));
		$('#alarmLv3Text').html($(this).attr('hddAlarmLimit'));
		if( $(this).attr('hddNotifyLimit') == '0' && $(this).attr('hddWarnLimit') == '0' && $(this).attr('hddAlarmLimit') == '0' ) {
			$('#alarmUsed').prop('checked', false);
			$('#alarmModal').show();
			
		} else {
			$('#alarmUsed').prop('checked', true);
			$('#alarmModal').hide();
		}
	});
	
	//임계치 설정 사용 체크박스
	$('#alarmUsed').click(function(){
		var checked = $('#alarmUsed:checked').length;
		if( checked == 0) { $('#alarmModal').show(); }
		else { $('#alarmModal').hide(); }
		
		var lv1 = $('#alarmLv1Text').text( );
		var lv2 = $('#alarmLv2Text').text( );
		var lv3 = $('#alarmLv3Text').text( );
		if( lv1 == 0 && lv2 == 0 && lv3 == 0 ) {
			$('#alarmLv1Text').html('1');
			$('#alarmLv2Text').html('1');
			$('#alarmLv3Text').html('1');
		}
		
	});
	
	$(document).on('click', '.alertChange', function(){
		$('#alertChangePop').attr('mode', 'insert');
		$('#alertChangePop').modal('show');
		$('#alertChangePop').attr('idx', $('.alertChange').index(this));
		$('#alertChangePop').attr('hddNotifyLimit', $(this).attr('hddNotifyLimit'));
		$('#alertChangePop').attr('hddWarnLimit', $(this).attr('hddWarnLimit'));
		$('#alertChangePop').attr('hddAlarmLimit', $(this).attr('hddAlarmLimit'));
	});
	$('#alarmLv1Critical').slider().on('slide', function(ev){
		$('#alarmLv1Text').text(ev.value);
	});
	$('#alarmLv2Critical').slider().on('slide', function(ev){
		$('#alarmLv2Text').text(ev.value);
	});
	$('#alarmLv3Critical').slider().on('slide', function(ev){
		$('#alarmLv3Text').text(ev.value);
	});
	
	//프로세스 재시작 버튼
	$(document).on('click', '.restartBtn', function(){
		var idx = $(this).parent().parent().attr('idx');
		$('.restartBtn').prop('disabled', true);
		ui.confirmMsg('<s:message code="deviceInfo.msg.confirm.restart"/>', '', '', function(rs){
			if(rs){
				ui.get({
					url : 'device/setProcessRestart.xcn',
					deviceIp : $.trim($('#tblDeviceIp').text()),
					deviceSeq : $('#deviceSelect').selectpicker('val'),
					index : idx,
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="deviceInfo.msg.processrestart"/>');
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						$('.restartBtn').prop('disabled', false);
						getDeviceStatus();
					}
				});
			} else {
				$('.restartBtn').prop('disabled', false);
			}
		});
	});
	
	//프로세스 종료 버튼
	$(document).on('click', '.offBtn', function(){
		var idx = $(this).parent().parent().attr('idx');
		$('.offBtn').prop('disabled', true);
		ui.confirmMsg('<s:message code="deviceInfo.msg.confirm.exitprocess"/>', '', '', function(rs){
			if(rs){
				ui.get({
					url : 'device/setProcessStop.xcn',
					deviceIp : $.trim($('#tblDeviceIp').text()),
					index : idx,
					deviceSeq : $('#deviceSelect').selectpicker('val'),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="deviceInfo.msg.exitprocess"/>');
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						$('.offBtn').prop('disabled', false);
						getDeviceStatus();
					}
				});
			} else {
				$('.offBtn').prop('disabled', false);
			}
		});
	});
	
	//프로세스 시작 버튼
	$(document).on('click', '.startBtn', function(){
		var idx = $(this).parent().parent().attr('idx');
		$('.startBtn').prop('disabled', true);
		ui.confirmMsg('<s:message code="deviceInfo.msg.confirm.restart"/>', '', '', function(rs){
			if(rs){
				ui.get({
					url : 'device/setProcessRestart.xcn',
					deviceIp : $.trim($('#tblDeviceIp').text()),
					index : idx,
					deviceSeq : $('#deviceSelect').selectpicker('val'),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="deviceInfo.msg.processstart"/>');
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						$('.startBtn').prop('disabled', false);
						getDeviceStatus();
					}
				});
			} else {
				$('.startBtn').prop('disabled', false);
			}
		});
	});
	
	$('.dataOpen').click(function(){
		var targetClass = $(this).attr('data-target');
		$('.'+targetClass).hide();
	});
	
	getDevice();
	getDeviceInfo();
	chartInit();
});

function chartInit(){
	$('#hdfsInfoChart').highcharts({
		chart: {
			type: 'pie',
			options3d: {
				enabled: true,
				alpha: 45
			},
			backgroundColor:'#FBFBFB',
			marginTop: 0
		},
		title: {
			text: null
		},
		subtitle:{
			text: '<b>Configured Capacity</b>'
		},
		exporting: false,
		credits: chartAPI.credits,
		plotOptions: {
			pie: {
				allowPointSelect: true,
				innerSize: 100,
				depth: 45
			}
		},
		tooltip: {
			headerFormat: '<b>{point.key}</b><br>',
			formatter:function(){
				return '<span style="color:'+this.point.color+'">'+this.point.name+'</span>';
			}
		},
		series: []
	});
	
	$('#hbaseInfoChart').highcharts({
		chart: {
			type: 'pie',
			options3d: {
				enabled: true,
				alpha: 45
			},
			backgroundColor:'#FBFBFB',
			marginTop: 0
		},
		title: {
			text: null
		},
		subtitle:{
			text: '<b>Hbase Memory</b>'
		},
		exporting: false,
		credits: chartAPI.credits,
		plotOptions: {
			pie: {
				allowPointSelect: true,
				innerSize: 100,
				depth: 45
			}
		},
		tooltip: {
			headerFormat: '<b>{point.key}</b><br>',
			formatter:function(){
				return '<span style="color:'+this.point.color+'">'+this.point.name+'</span>';
			}
		},
		series: []
	});
}
function setHdfsStatus(hdfs){
	if( hdfs == undefined ) return;
	statusCheck('hdfsStatus', hdfs.status, 'HDFS');
	
	setHdfsInfo(hdfs);
	setHdfsDetailInfo(hdfs);
}

function setHbaseStatus(hbase){
	if( hbase == undefined ) return;
	statusCheck('hbaseStatus', hbase.status, 'HBase');
	
	setHbaseInfo(hbase);
	setHbaseDetailInfo(hbase);
}

function setSolrStatus(solr){
	if( solr == undefined ) return;
	statusCheck('solrStatus', solr.status, 'Solr');
	
	setSolrDetailInfo(solr);
}

function setKafkaStatus(kafka){
	if( kafka == undefined ) return;
	statusCheck('kafkaStatus', kafka.status, 'Kafka');
	
	setKafkaInfo(kafka);
}

function statusCheck(id, status, btnName){
	var $target = $('#'+id);
	var $targetTop = $('#'+id+'Top');
	
	$target.removeClass('label-success').removeClass('label-info').removeClass('label-warning').removeClass('label-danger').removeClass('label-default');
	if( status == 'S'){//정상
		$target.addClass('label-success');
		$target.html(getStatusMsg(status));
		$targetTop.addClass('label-success');
		$targetTop.attr('title', getStatusMsg(status));
		$targetTop.html(btnName);
	}else if( status == 'I'){//관심
		$target.addClass('label-info');
		$target.html(getStatusMsg(status));
		$targetTop.addClass('label-info');
		$targetTop.attr('title', getStatusMsg(status));
		$targetTop.html(btnName);
	}else if( status == 'W'){//경고
		$target.addClass('label-warning');
		$target.html(getStatusMsg(status));
		$targetTop.addClass('label-warning');
		$targetTop.attr('title', getStatusMsg(status));
		$targetTop.html(btnName);
	}else if( status == 'E'){//에러
		$target.addClass('label-danger');
		$target.html(getStatusMsg(status));
		$targetTop.addClass('label-danger');
		$targetTop.attr('title', getStatusMsg(status));
		$targetTop.html(btnName);
	}else if( status == 'X'){//치명
		$target.addClass('label-danger');
		$target.html(getStatusMsg(status));
		$targetTop.attr('title', getStatusMsg(status));
		$targetTop.addClass('label-danger');
		$targetTop.html(btnName);
	}else if( status == 'C'){//연결오류
		$target.addClass('label-default');
		$target.html(getStatusMsg(status));
		$targetTop.addClass('label-default');
		$targetTop.attr('title', getStatusMsg(status));
		$targetTop.html(btnName);
	}
}

function getStatusMsg(status){
	if( status == 'S') return '<s:message code="deviceInfo.normal"/>';
	else if( status == 'I') return '<s:message code="deviceInfo.interest"/>';
	else if( status == 'W') return '<s:message code="deviceInfo.caution"/>';
	else if( status == 'E') return '<s:message code="deviceInfo.danger"/>';
	else if( status == 'X') return '<s:message code="deviceInfo.critical"/>';
	else if( status == 'C') return '<s:message code="deviceInfo.disconnect"/>';
	return '-';
}

function getProcessMsg(str) {
	if( str == 'Normal' ) return '<s:message code="deviceInfo.normal"/>';
	else if( str == 'Dead' ) return '<s:message code="deviceInfo.disconnect"/>';
	return '-';
}

function setHdfsInfo(hdfs){
	var dataArr = [];
	dataArr.push(hdfs.hdfsActiveNamenode);
	dataArr.push(hdfs.hdfsStandbyNamenode);
	dataArr.push(hdfs.hdfsStartTime);
	dataArr.push(nvl(hdfs.hdfsDeadNodes.join(', '), '-'));
	dataArr.push(nvl(hdfs.hdfsDecomNodes.join(', '), '-'));
	dataArr.push(hdfs.hdfsTotalBlocks.comma());
	dataArr.push(hdfs.hdfsTotalFiles.comma());
	dataArr.push(convertFileSize(hdfs.hdfsBlockPoolUsed) + ' (' + hdfs.hdfsBlockPoolUsedPercent + '%)');
	
	$('#hdfsTbody').find('td').each(function(idx){
		$(this).html(dataArr[idx]);
	});
	setHdfsChartData(hdfs);
}

function setHbaseInfo(hbase){
	var dataArr = [];
	dataArr.push(hbase.hbaseActiveMaster);
	dataArr.push(hbase.hbaseAverageLoad);
	dataArr.push(hbase.hbaseStartTime);
	dataArr.push(hbase.hbaseNumRegionServers);
	dataArr.push(hbase.hbaseDeadRegionServers);
	dataArr.push(convertFileSize(hbase.hbaseMemHeapUsed) + ' / '+ convertFileSize(hbase.hbaseMemHeapMax) + ' (' +hbase.hbaseMemHeapUsedPercent+ '%)');
	dataArr.push(convertFileSize(hbase.hbaseMemNonHeapUsed) + ' / '+ (hbase.hbaseMemNonHeapMax < 0 ? '-' : convertFileSize(hbase.hbaseMemNonHeapMax)) + ' (' +(hbase.hbaseMemNonHeapUsedPercent < 0 ? '-' : hbase.hbaseMemNonHeapUsedPercent)+ '%)');
	
	$('#hbaseTbody').find('td').each(function(idx){
		$(this).html(dataArr[idx]);
	});
	setHbaseChartData(hbase);
}

function setKafkaInfo(kafka){
	var dataArr = [];
	dataArr.push(kafka.kafkaController);
	dataArr.push(kafka.kafkaTopicBytesInPerSec + ' / '+ kafka.kafkaTopicBytesOutPerSec);
	dataArr.push(kafka.kafkaLeaderCount.comma());
	dataArr.push(kafka.kafkaTopicMessagesInPerSec);
	dataArr.push(kafka.kafkaPartitionCount.comma());
	dataArr.push(kafka.kafkaProducerRequestsPerSec);
	dataArr.push(kafka.kafkaUnderReplicatedPartitions);
	dataArr.push(kafka.kafkaProducerRequestQueueTime + ' / '+ kafka.kafkaProducerResponseQueueTime);
	dataArr.push(kafka.kafkaIsrExpandsPerSec);
	dataArr.push(convertFileSize(kafka.kafkaProducerPurgatorySize));
	dataArr.push(kafka.kafkaIsrShrinksPerSec);
	dataArr.push(kafka.kafkaConsumerRequestsPerSec);
	dataArr.push(kafka.kafkaActiveControllerCount.comma());
	dataArr.push(nvl(kafka.kafkaConsumerRequestQueueTime,'-') + ' / '+ nvl(kafka.kafkaConsumerResponseQueueTime,'-'));
	dataArr.push(kafka.kafkaOfflinePartitionsCount.comma());
	dataArr.push(convertFileSize(kafka.kafkaConsumerPurgatorySize));
	
	$('#kafkaTbody').find('td').each(function(idx){
		$(this).html(dataArr[idx]);
	});
}

function setHdfsChartData(hdfs){
	var chart = $('#hdfsInfoChart').highcharts();
	if(chart.series.length == 0 ){
		var data = {};
		var list = [];
		var hdfsUsed = {};
		var hdfsRemaining = {};
		var hdfsNonDfsUsed = {};
		hdfsNonDfsUsed.y = Number(hdfs.hdfsNonDfsUsed);
		hdfsNonDfsUsed.name = 'Non DFS Used<br/>' + convertFileSize(hdfs.hdfsNonDfsUsed);
		hdfsNonDfsUsed.color = '#7B7B7F';
		list.push(hdfsNonDfsUsed);
		hdfsUsed.y = Number(hdfs.hdfsUsed);
		hdfsUsed.name = 'DFS Used<br/>' + convertFileSize(hdfs.hdfsUsed);
		hdfsUsed.color = '#8085E9';
		list.push(hdfsUsed);
		hdfsRemaining.y = Number(hdfs.hdfsRemaining);
		hdfsRemaining.name = 'DFS Remaining<br/>' + convertFileSize(hdfs.hdfsRemaining);
		hdfsRemaining.color = '#A6EB97';
		hdfsRemaining.sliced = true;
		hdfsRemaining.selected = true;
		list.push(hdfsRemaining);
		data.data = list;
		chart.addSeries(data);
	}else{
		var data = [];
		data.push(Number(hdfs.hdfsNonDfsUsed));
		data.push(Number(hdfs.hdfsUsed));
		data.push(Number(hdfs.hdfsRemaining));
		chart.series[0].setData(data);
	}
	chart.setTitle(null, { text: '<b>Configured Capacity : '+convertFileSize(hdfs.hdfsCapacity)+'<b>'});
}

function setHbaseChartData(hbase){
	var chart = $('#hbaseInfoChart').highcharts();
	if(chart.series.length == 0 ){
		var data = {};
		var list = [];
		var hbaseUsed = {};
		var hbaseRemaining = {};
		var hbaseNonHeapUsed = {};
		hbaseNonHeapUsed.y = Number(hbase.hbaseMemNonHeapUsed);
		hbaseNonHeapUsed.name = 'Non Heap Used<br/>' + convertFileSize(hbase.hbaseMemNonHeapUsed);
		hbaseNonHeapUsed.color = '#7B7B7F';
		list.push(hbaseNonHeapUsed);
		hbaseUsed.y = Number(hbase.hbaseMemHeapUsed);
		hbaseUsed.name = 'Heap Used<br/>' + convertFileSize(hbase.hbaseMemHeapUsed);
		hbaseUsed.color = '#8085E9';
		list.push(hbaseUsed);
		hbaseRemaining.y = Number(hbase.hbaseMemRemaining);
		hbaseRemaining.name = 'Memory Remaining<br/>' + convertFileSize(Number(hbase.hbaseMemRemaining));
		hbaseRemaining.color = '#A6EB97';
		hbaseRemaining.sliced = true;
		hbaseRemaining.selected = true;
		list.push(hbaseRemaining);
		data.data = list;
		chart.addSeries(data);
	}else{
		var data = [];
		data.push(Number(hbase.hbaseMemNonHeapUsed));
		data.push(Number(hbase.hbaseMemHeapUsed));
		data.push(Number(hbase.hbaseMemRemaining));
		chart.series[0].setData(data);
	}
	chart.setTitle(null, { text: '<b>Hbase Memory : '+convertFileSize(hbase.hbaseMemHeapMax)+'<b>'});
}

function setHdfsDetailInfo(hdfs){
	var deadNodes = hdfs.DeadNodes;
	var decomNodes = hdfs.DecomNodes;
	var liveNodes = hdfs.LiveNodes;
	var str = '';
	for (var i=0; i < deadNodes.length; i++){
		str += makeHdfsOperationData(deadNodes[i].hdfsDeadNodeName, '-', 0, 0, '-', '-', 'D');
	}
	for (var j=0; j < liveNodes.length; j++){
		var used = Number(liveNodes[j].hdfsDnUsed) + Number(liveNodes[j].hdfsDnNonDfsUsed);
		str += makeHdfsOperationData(liveNodes[j].hdfsDnServerName, convertFileSize(used), convertFileSize(used), liveNodes[j].hdfsPercent, liveNodes[j].hdfsDnNumBlocks.comma(), convertFileSize(liveNodes[j].hdfsDnBlockPoolUsed) + ' ('+liveNodes[j].hdfsDnBlockPoolUsedPercent+'%)', 'N');
	}
	$('#hdfsOperationTbody').html(str);
	
	var decomStr = '';
	if( decomNodes.length == 0) $('#hdfsDecomArea').hide();
	else{
		for (var k=0; k < decomNodes.length; k++){
			decomStr += makeHdfsDecomData(decomNodes[k].hdfsDecomName, decomNodes[k].hdfsDecomUnderReplicatedBlocks.comma(), decomNodes[k].hdfsDecomOnlyReplicas.comma(), decomNodes[k].hdfsDecomUnderReplicateInOpenFiles.comma(), 'N');
		}
		$('#hdfsDecomTbody').html(decomStr);
		$('#hdfsDecomArea').show();
	}
}

function setHbaseDetailInfo(hbase){
	var regionServers = hbase.RegionServers;
	var str = '';
	
	var deadRegionServers = (hbase.hbaseDeadRegionServers != undefined && hbase.hbaseDeadRegionServers != '') ? (hbase.hbaseDeadRegionServers).split(',') : [];
	
	for (var j=0; j < deadRegionServers.length; j++){
		str += '<tr>';
		str += '	<td style="text-align:center;vertical-align: bottom;"><span class="label label-danger font14">' + getProcessMsg('Dead') + '</span></td>';
		str += '	<td>'+deadRegionServers[j]+'</td>';
		str += '	<td> - </td>';
		str += '	<td> - </td>';
		str += '	<td> - </td>';
		str += '	<td> - </td>';
		str += '	<td> - </td>';
		str += '	<td> - </td>';
		str += '</tr>';
	}
	
	for (var i=0; i < regionServers.length; i++){
		str += '<tr>';
		
		var deadRegion = hbase.hbaseDeadRegionServers;
		if( deadRegion.indexOf(regionServers[i].regsvrServerName) > -1 ) str += '	<td><span class="label label-danger font14">' + getProcessMsg('Dead') + '</span></td>';
		else str += '	<td style="text-align:center;vertical-align: bottom;"><span class="label label-success font14">' + getProcessMsg('Normal') + '</span></td>';

		str += '	<td>'+regionServers[i].regsvrServerName+'</td>';
		str += '	<td>'+regionServers[i].regsvrRegionCount.comma()+'</td>';
		str += '	<td>'+regionServers[i].regsvrMemStoreCount.comma() + ' / '+ convertFileSize(regionServers[i].regsvrMemStoreSize)+'</td>';
		str += '	<td>'+regionServers[i].regsvrHlogFileCount.comma() + ' / '+ convertFileSize(regionServers[i].regsvrHlogFileSize)+'</td>';
		str += '	<td>'+regionServers[i].regsvrStoreFileCount.comma() + ' / '+ convertFileSize(regionServers[i].regsvrStoreFileSize)+'</td>';
		str += '	<td>'+convertFileSize(regionServers[i].regsvrStoreFileIndexSize)+'</td>';
		str += '	<td>'+convertFileSize(regionServers[i].regsvrStaticIndexSize)+'</td>';
		str += '</tr>';
	}
	
	$('#hbaseOperationTbody').html(str);
}

function setSolrDetailInfo(solr){
	var deadCores = solr.DeadCores;
	var liveCores = solr.LiveCores;
	
	var str = '';
	
	for (var j=0; j < deadCores.length; j++){
		str += '<tr>';
		str += '	<td style="text-align:center;vertical-align: bottom;"><span class="label label-danger font14">' + getProcessMsg('Dead') + '</span></td>';
		str += '	<td>'+deadCores[j].solrCoreName+'</td>';
		str += '	<td>'+deadCores[j].solrCoreState+'</td>';
		str += '	<td> - </td>';
		str += '	<td> - </td>';
		str += '	<td> - </td>';
		str += '	<td> - </td>';
		str += '	<td> - </td>';
		str += '</tr>';
	}
	
	for (var i=0; i < liveCores.length; i++){
		str += '<tr>';
		str += '	<td style="text-align:center;vertical-align: bottom;"><span class="label label-success font14">' + getProcessMsg('Normal') + '</span></td>';
		str += '	<td>'+liveCores[i].solrCoreName+'</td>';
		str += '	<td>'+liveCores[i].solrCoreState+'</td>';
		
		var isLeader = '';
		if( liveCores[i].solrCoreIsLeader == 'true' && liveCores[i].solrCoreIsFollower == 'false' ) isLeader = 'Leader';
		else isLeader = 'Follower';
		
		str += '	<td>'+isLeader+'</td>';
		str += '	<td>'+liveCores[i].solrCoreNumDocs+'</td>';
		str += '	<td>'+convertFileSize(liveCores[i].solrCoreIndexSize)+'</td>';
		str += '	<td>'+liveCores[i].solrCoreRequests+' / '+liveCores[i].solrCoreTimeouts+' / '+liveCores[i].solrCoreErrors+'</td>';
		str += '	<td>'+liveCores[i].solrCoreAvgTimePerRequest+'</td>';
		str += '</tr>';
	}
	
	$('#solrOperationTbody').html(str);
}

function makeHdfsOperationData(host, sizeInfo, size, percent, blockNum, blockInfo, status){
	var str = ''; 
	str += '<tr>';
	if(status == 'N') str += '	<td style="text-align:center;vertical-align: bottom;"><span class="label label-success font14">' + getProcessMsg('Normal') + '</span></td>';
	else if(status == 'D') str += '	<td><span class="label label-danger font14">' + getProcessMsg('Dead') + '</span></td>';
	str += '	<td>'+host+'</td>';
	str += '	<td>'+sizeInfo+'</td>';
	str += '	<td>';
	str += makePrograss(size, percent);
	str += '	</td>';
	str += '	<td>'+blockNum+'</td>';
	str += '	<td>'+blockInfo+'</td>';
	str += '</tr>';
	return str;
}
function makeHdfsDecomData(host, replicated_blocks, nolive_blocks, files_replicated_blocks, status){
	var str = '';
	str += '<tr>';
	if(status == 'N') str += '	<td style="text-align:center;vertical-align: bottom;"><span class="label label-success font14">' + getProcessMsg('Normal') + '</span></td>';
	else if(status == 'D') str += '	<td><span class="label label-danger font14">' + getProcessMsg('Dead') + '</span></td>';
	str += '	<td>'+host+'</td>';
	str += '	<td>'+replicated_blocks+'</td>';
	str += '	<td>'+nolive_blocks+'</td>';
	str += '	<td>'+files_replicated_blocks+'</td>';
	str += '</tr>';
	return str;
}

function makePrograss(value, percent){
	//percent = Number(percent).toFixed(2);
	var str = '';
	str +='<div class="progress">';
	str +='	<div style="width: '+percent+'%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="'+percent+'" role="progressbar" class="progress-bar progress-bar-success">';
	str +='		<span data-toggle="tooltip" data-placement="bottom" title="'+value+'">'+percent+'%</span>';
	str +='	</div>';
	str +='</div>';
	return str;
}

/**
 * 장비 상태 조회 - SNMP 
 */
var devicePolling;
function getDeviceStatus(){
	if(devicePolling) window.clearTimeout(devicePolling);
	
	ui.get({
		url : 'device/getDeviceStatus.xcn',
		deviceIp : $.trim($('#tblDeviceIp').text()),
		success : function(data, total) {
			if(data==null) {
				return;
			}
			$('#referenceTime').html( '<s:message code="deviceInfo.reftime"/> : ' + data.currentDeviceStatusDt);
			if( data.hadoopDeviceStatus.edcMetrics != undefined){
				setHdfsStatus(data.hadoopDeviceStatus.edcMetrics.hdfs);
				setHbaseStatus(data.hadoopDeviceStatus.edcMetrics.hbase);
				setSolrStatus(data.hadoopDeviceStatus.edcMetrics.solrCloud);
				setKafkaStatus(data.hadoopDeviceStatus.edcMetrics.kafka);
				$('#hdfsStatus, #hbaseStatus, #solrStatus, #kafkaStatus').show();
			} else {
				initData();
			}
		},
		error : function(status, message) {
		},
		complete : function() {
			//var t = Number( $('#refreshTime').attr('val') ) * 1000;
			devicePolling = window.setTimeout(function(){
				getDeviceStatus();
			}, 5000);
		}
	});
}

function initData() {
	$('#hdfsTbody td, #hdfsTbody td, #hbaseTbody td, #kafkaTbody td').html('-');
	$('#hdfsOperationTbody, #hbaseOperationTbody, #solrOperationTbody').html('');
	$('#hdfsDecomTbody').html('');
	$('#hdfsStatus, #hbaseStatus, #solrStatus, #kafkaStatus').hide();
	$('#hdfsInfoChart, #hbaseInfoChart').html('');
}

//장비 연결 실패시 화면 reset
function noConnectionDevice(){
	var str = '-';
	$('#sysInfoHostname').html(str);
	$('#sysConfigOS').html(str);
	$('#sysInfoDate').html(str);
	$('#sysInfoUptime').html(str);
	$('#cpuInfoModel').html(str);
}

function getDevice(){
	ui.get({
		url : 'getDeviceListDetail.xcn',
		success : function(data, total) {
			makeDeviceTab( data );
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}

//장비정보 왼쪽
function getDeviceInfo( ){
	var deviceSeq = param_deviceSeq;
	if( deviceSeq !='' && deviceSeq != 'null' ) {
		ui.get({
			url : 'getDeviceInfo.xcn',
			deviceSeq : deviceSeq,
			success : function(data, total) {
				if( data == null) return;
				
				$('#tblDeviceIp').html( data.deviceIp );
				$('#tblDeviceNm').html( data.deviceNm );

				$('#tblDeviceType').attr('type', data.deviceType);
				if( data.deviceType =='A' ) {
					$('#tblDeviceType').html('<s:message code="deviceInfo.integraldev"/>');
				} else if( data.deviceType =='L' ) {
					$('#tblDeviceType').html('<s:message code="deviceInfo.analdev"/>');
				} else if( data.deviceType =='C' ) {
					$('#tblDeviceType').html('<s:message code="deviceInfo.loggingdev"/>');
				} else if( data.deviceType =='H' ) {
					$('#tblDeviceType').html('<s:message code="deviceInfo.hadoopdevH"/>');
				} else if( data.deviceType =='M' ) {
					$('#tblDeviceType').html('<s:message code="deviceInfo.hadoopdevM"/>');
				} else {
					$('#tblDeviceType').html('-');
				}
				
				$('#tblComment').html( data.comment );
				$('#tblCreatDt').html( data.createDt );
				$('#tblSshId').html( data.sshId );
				$('#tblSshPw').html( data.sshPw );

				setAlarmCheck(data);

				if(devicePolling) window.clearTimeout(devicePolling);
				getDeviceStatus();
			},
			error : function(status, message) {
				ui.alertMsg(message);
			},
			complete : function() {
				
			}
		});
	} else {
		getDeviceStatus();
	}
}

function saveAlarmCheck(confId, checked){
	var deviceConfName = '';
	var deviceStatus = '';
	if(confId == 'device.hdd.sms.1'){
		deviceConfName = '<s:message code="deviceInfo.filesystem.sms"/>';
	}
	if(confId == 'device.hdd.notify.1'){
		deviceConfName = '<s:message code="deviceInfo.filesystem.alarm"/>';
	}
	if(confId == 'device.process.sms.1'){
		deviceConfName = '<s:message code="deviceInfo.process.sms"/>';
	}
	if(confId == 'device.process.notify.1'){
		deviceConfName = '<s:message code="deviceInfo.process.alarm"/>';
	}
	if(confId == 'device.interface.sms.1'){
		deviceConfName = '<s:message code="deviceInfo.interface.sms"/>';
	}
	if(confId == 'device.interface.notify.1'){
		deviceConfName = '<s:message code="deviceInfo.interface.alarm"/>';
	}
	if(checked){
		deviceStatus = ' <s:message code="deviceInfo.check"/>';
	}else{
		deviceStatus = ' <s:message code="deviceInfo.uncheck"/>';
	}
	ui.get({
		url : 'setConfAdmin.xcn',
		confId : confId,
		deviceConfName : deviceConfName,
		deviceStatus : deviceStatus,
		val : (checked==true ? 'Y' : 'N'),
		success : function(data, total) {
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}

function setAlarmCheck(data){
	$('#sms_file').prop('checked', false);
	$('#notify_file').prop('checked', false);
	$('#sms_proc').prop('checked', false);
	$('#notify_proc').prop('checked', false);
	$('#sms_inter').prop('checked', false);
	$('#notify_inter').prop('checked', false);

	if(data.hddSmsUseYn=='Y') $('#sms_file').prop('checked', true);
	if(data.hddNotifyUseYn=='Y') $('#notify_file').prop('checked', true);
	if(data.processSmsUseYn=='Y') $('#sms_proc').prop('checked', true);
	if(data.processNotifyUseYn=='Y') $('#notify_proc').prop('checked', true);
	if(data.interfaceSmsUseYn=='Y') $('#sms_inter').prop('checked', true);
	if(data.interfaceNotifyUseYn=='Y') $('#notify_inter').prop('checked', true);
}

//장비 탭 생성
function makeDeviceTab( data ){
	var options='';
	var deviceType='';
	var selected_seq = 0;
	if(param_deviceSeq!=''){
		selected_seq = param_deviceSeq;
	}
	for (var i = 0; i < data.length; i++) {

		if(data[i].deviceType=='A') {
			deviceType ='<s:message code="deviceInfo.integraldev"/>';
		} else if(data[i].deviceType=='L') {
			deviceType ='<s:message code="deviceInfo.analdev"/>';
		} else if(data[i].deviceType=='C') {
			deviceType ='<s:message code="deviceInfo.loggingdev"/>';
		} else if(data[i].deviceType=='M') {
			deviceType ='<s:message code="deviceInfo.hadoopdevM"/>';
		} else if(data[i].deviceType=='H') {
			deviceType ='<s:message code="deviceInfo.hadoopdevH"/>';
		} 
		options+='<option value="'+data[i].deviceSeq+'">'+data[i].deviceNm+'('+(deviceType)+')</option>';
	}
	$('#deviceSelect').html( options );
	$("#deviceSelect").selectpicker('val', selected_seq);
	$("#deviceSelect").selectpicker('refresh');
}

//장비 수정
function modifyDevice(){
	var deviceSeq = $("#deviceSelect").selectpicker('val');
	$('#devSeqHidden').val( deviceSeq );
	$('.savePopBtn').prop('disabled', true);
	ui.confirmMsg('<s:message code="common.msg.confirm.modify"/>', '', '', function(rs){
		if(rs){
			ui.post({
				url : 'updateDevice.xcn',
				data : $('#addDevPopForm').serializeAll(),
				success : function ( data, total ) {
					ui.alertMsg('<s:message code="common.msg.modified"/>');
					$('#addDevPop').modal('hide');
					getDevice();
					getDeviceInfo();
				},
				error : function (status, message) {
					ui.alertMsg(message);
				},
				complete : function (){
					$('.savePopBtn').prop('disabled', false);
				}
			});
		} else {
			$('.savePopBtn').prop('disabled', false);
		}
	});
}

//장비 추가
function insertDevice(){
	$('.savePopBtn').prop('disabled', true);
	ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function(rs){
		if(rs){
			ui.post({
				url : 'insertDevice.xcn',
				data : $('#addDevPopForm').serializeAll(),
				success : function ( data, total ) {
					ui.alertMsg('<s:message code="common.msg.saved"/>');
					$('#addDevPop').modal('hide');
					getDevice();
				},
				error : function (status, message) {
					ui.alertMsg(message);
				},
				complete : function (){
					$('.savePopBtn').prop('disabled', false);
				}
			});
		} else {
			$('.savePopBtn').prop('disabled', false);
		}
	});
}

//선택된 탭
var currentTab;
function getCurrentTab(){
	return currentTab==null ? 'coTab' : currentTab;
}


function on(id) {
	var obj = $('#'+idIndicator(id));
	var hei = obj.height();
	$(obj).append( '<div class="loading_div"><i class="fa fa-spinner fa-spin fa-3x fa-fw"></i></div>');
	$('.loading_div').css({
		"position" : "absolute",
		"top" : "0px",
		"left" : "0px",
		"right" : "0px",
		"bottom" : "0px",
		"background-color" : "#f0f0f0",
		"opacity" : "0.3",
		"z-index" : "998",
		"text-align" : "center"
	});
}
function off(id) {
	var obj = $('#'+idIndicator(id)+' .loading_div');
	obj.remove();
}
</script>
</head>
<body class="mini-navbar" id="body">
	<div class="modal fade" id="addDevPop" tabindex="-1" role="dialog" aria-labelledby="addDevPopModal">
		<div class="modal-dialog" role="document" style="width: 700px;">
			<div class="modal-content">
				<form method="post" id="addDevPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="deviceInfo.addDevPop.title"/></h3>
				</div>
				<div class="modal-body">
					<div>
						<p style="font-weight: bold;padding-left: 28px;"><s:message code="deviceInfo.select.devtype"/></p>
						<fieldset>
							<div id="deviceType" class="form-inline radio" style="line-height: 35px;height: 35px; padding-bottom: 35px;border-bottom: 2px solid #5d9cec;">
								<label class="col-sm-4 radio-inline c-radio" style="padding-left:0;padding-right:0;margin-left:0;margin-right:0;"><input type="radio" value="C" name="deviceType"><span class="fa fa-check"></span><s:message code="deviceInfo.loggingdev"/></label>
								<label class="col-sm-4 radio-inline c-radio" style="padding-left:0;padding-right:0;margin-left:0;margin-right:0;"><input type="radio" value="M" name="deviceType"><span class="fa fa-check"></span><s:message code="deviceInfo.hadoopdevM"/></label>
								<label class="col-sm-4 radio-inline c-radio" style="padding-left:0;padding-right:0;margin-left:0;margin-right:0;"><input type="radio" value="H" name="deviceType"><span class="fa fa-check"></span><s:message code="deviceInfo.hadoopdevH"/></label>
							</div>
						</fieldset>
					</div>
				
					<div id="deviceIpDiv" class="form-inline">
						<label for="deviceIp" class=" col-xs-3">IP</label>
						<input type="text" class="form-control" name="deviceIp" id="deviceIp" placeholder="IP" style="width: 400px;" required maxlength="64">
					</div>
					<div class="form-inline">
						<label for="deviceNm" class=" col-xs-3"><s:message code="common.msg.name"/></label>
						<input type="text" class="form-control" name="deviceNm" id="deviceNm" placeholder="<s:message code="common.msg.name"/>" style="width: 400px;" required maxlength="256">
					</div>
					<div class="form-inline">
						<label for="comment" class=" col-xs-3"><s:message code="common.msg.comment"/></label>
						<input type="text" class="form-control" name="comment" id="comment" placeholder="<s:message code="common.msg.comment"/>" style="width: 400px;" required maxlength="512">
						<input type="hidden" id="devSeqHidden" name="deviceSeq">
					</div>
					<div id="deviceSshIdDiv" class="form-inline">
						<label for="sshId" class=" col-xs-3"><s:message code="deviceInfo.ssh.id"/></label>
						<input type="text" class="form-control" name="sshId" id="sshId" placeholder="<s:message code="deviceInfo.ssh.id"/>" style="width: 400px;" required maxlength="256">
					</div>
					<div id="deviceSshPwDiv" class="form-inline">
						<label for="sshPw" class=" col-xs-3"><s:message code="deviceInfo.ssh.pw"/></label>
						<input type="password" class="form-control" name="sshPw" id="sshPw" placeholder="<s:message code="deviceInfo.ssh.pw"/>" style="width: 400px;" required maxlength="512" autocomplete="off">
					</div>
					<div id="alertDiv" class="form-inline" style="display:none;">
						<label for="alertDeviceCC" class=" col-xs-12"><s:message code="deviceInfo.set.critical.default"/></label>
						<img src="<c:url value="/img/alertDeviceCC.png"/>" style="width: 560px; height: 200px;">
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
	
	<div class="modal fade" id="alertChangePop" tabindex="-1" role="dialog" aria-labelledby="alertChangeModal">
		<div class="modal-dialog" role="document" style="width: 760px">
			<div class="modal-content">
				<form method="post" id="alertChangeForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="deviceInfo.set.critical"/></h3>
				</div>
				<div class="modal-body">
					<div style="padding-bottom: 50px;">
						<div class="form-inline col-xs-6">
							<label class="checkbox c-checkbox"><input type="checkbox" id="alarmUsed"><span class="fa fa-check"></span><s:message code="deviceInfo.use.critical"/></label>
						</div>
					</div>
					<div style="background-color: #000; opacity: .2; position: absolute; top: 50px; left: 0px; right: 0px; bottom: 0px; z-index: 999;" id="alarmModal"></div>
					<div class="form-inline">
						<label for="ip" class=" col-xs-1"><s:message code="deviceInfo.interest"/></label>
						<div class="row" style="padding-left: 100px; font-size: 12px;">
							<label>
								<s:message code="deviceInfo.msg.over.alarmlog"/>
							</label>
						</div>
						<div class="row" style="padding-left: 110px;">
							<input style="width: 200px;" type="text" id="alarmLv1Critical" class="span2" value="" data-slider-min="10" data-slider-max="99" data-slider-step="1" data-slider-orientation="horizontal" data-slider-selection="before"data-slider-tooltip="hide" data-slider-id="alarmCri">
						</div>
					</div>
					<div class="form-inline">
						<label for="ip" class=" col-xs-1"><s:message code="deviceInfo.caution"/></label>
						<div class="row" style="padding-left: 100px; font-size: 12px;">
							<label>
								<s:message code="deviceInfo.msg.over.log"/>
							</label>
						</div>
						<div class="row" style="padding-left: 110px;">
							<input style="width: 200px;" type="text" id="alarmLv2Critical" class="span2" value="" data-slider-min="10" data-slider-max="99" data-slider-step="1" data-slider-orientation="horizontal" data-slider-selection="before"data-slider-tooltip="hide" data-slider-id="saturationCri">
						</div>
					</div>
					<div class="form-inline">
						<label for="ip" class=" col-xs-1"><s:message code="deviceInfo.danger"/></label>
						<div class="row" style="padding-left: 100px; font-size: 12px;">
							<label>
								<s:message code="deviceInfo.msg.continue.deletelog"/>
							</label>
						</div>
						<div class="row" style="padding-left: 110px;">
							<input style="width: 200px;" type="text" id="alarmLv3Critical" class="span2" value="" data-slider-min="50" data-slider-max="99" data-slider-step="1" data-slider-orientation="horizontal" data-slider-selection="before"data-slider-tooltip="hide" data-slider-id="deleteCri">
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary saveAlarmPopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
				</form>
			</div>
		</div>
	</div>


	<div class="container"> 
		<div class="boxArea">
			<div class="content_body">
				<div class="row" >
					<div class="col-xs-9 text-left topArea" style="width:calc(100% - 270px);">
						<div class="form-group form-inline not-dashed">
							<button type="button" class="btn btn-sm btn-primary" accesskey="" id="returnListBtn"><span class="glyphicon glyphicon-arrow-left"></span>&nbsp;<s:message code="deviceInfo.returnList"/></button>
							<select id="deviceSelect" class="selectpicker" data-style="btn-default" style="display:none;"></select>
							<button type="button" class="btn btn-sm btn-primary" accesskey="M" id="modifyBtn"><span class="glyphicon glyphicon-edit"></span>&nbsp;<s:message code="deviceInfo.modify.dev"/></button>
							<button type="button" class="btn btn-sm btn-default" accesskey="D" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="deviceInfo.delete.dev"/></button>
							<button type="button" class="btn btn-sm btn-warning" accesskey="R" id="refreshBtn"><span class="glyphicon glyphicon-refresh"></span>&nbsp;<s:message code="deviceInfo.refresh"/></button>
						</div>
					</div>
					<div class="col-xs-3 text-right" style="display: none;">
						<button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown">
							<span class="glyphicon glyphicon-download-alt"></span>&nbsp;<s:message code="deviceInfo.speed.updatedisplay"/> (<span class="dropdown-text"><s:message code="deviceInfo.speed.fast"/></span>) <span val="3" class="caret" id="refreshTime"></span>
						</button>
						<ul class="dropdown-menu dropdown-menu-right" role="menu">
							<li><a href="#" data="2"><s:message code="deviceInfo.speed.fast"/></a></li>
							<li><a href="#" data="4"><s:message code="deviceInfo.speed.normal"/></a></li>
							<li><a href="#" data="7"><s:message code="deviceInfo.speed.slow"/></a></li>
						</ul>
					</div>
					<div class="col-xs-3 text-right" id="referenceTime" style="width:270px;line-height:30px;">
						<s:message code="deviceInfo.reftime"/> : 2016-05-23 22:15:30
					</div>
				</div>

				<div class="row top_space">
					<div class="col-lg-12">
						<div class="panel panel-default">
							<div class="panel-heading">
								<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="deviceInfo.navi.title2"/>
								<div style="float:right;">
									<span class="label font14 label-success cursor_default"><s:message code="deviceInfo.normal"/></span>
									<span class="label font14 label-info cursor_default"><s:message code="deviceInfo.interest"/></span>
									<span class="label font14 label-warning cursor_default"><s:message code="deviceInfo.caution"/></span>
									<span class="label font14 label-danger cursor_default"><s:message code="deviceInfo.danger"/>/<s:message code="deviceInfo.critical"/></span>
									<span class="label font14 label-default cursor_default"><s:message code="deviceInfo.disconnect"/></span>
								</div>
							</div>
							<div class="panel-body">
								<table class="table table-bordered">
									<colgroup>
										<col width="250"/>
										<col>
									</colgroup>	
									<tr>
										<th><s:message code="deviceInfo.dev.ip"/></th>
										<td id="tblDeviceIp">-</td>
									</tr>
									<tr>
										<th><s:message code="deviceInfo.dev.name"/></th>
										<td id="tblDeviceNm">-</td>
									</tr>
									<tr>
										<th><s:message code="deviceInfo.dev.type"/></th>
										<td id="tblDeviceType">-</td>
									</tr>
									<tr>
										<th><s:message code="deviceInfo.dev.comment"/></th>
										<td id="tblComment">-</td>
									</tr>
									<tr>
										<th><s:message code="deviceInfo.dev.createdt"/></th>
										<td id="tblCreatDt">-</td>
									</tr>
									<tr>
										<th><s:message code="common.msg.device_status"/></th>
										<td id="tblDevStatus">
											<span id="hdfsStatusTop" class="label font14 cursor_default"></span>
											<span id="hbaseStatusTop" class="label font14 cursor_default"></span>
											<span id="solrStatusTop" class="label font14 cursor_default"></span>
											<span id="kafkaStatusTop" class="label font14 cursor_default"></span>
										</td>
									</tr>
									<tr style="display: none;">
										<th><s:message code="deviceInfo.dev.sshid"/></th>
										<td id="tblSshId">-</td>
									</tr>
									<tr style="display: none;">
										<th><s:message code="deviceInfo.dev.sshpw"/></th>
										<td id="tblSshPw">-</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>

				<div class="row top_space2">
					<div class="col-lg-12">
						<div class="panel panel-default">
							<div class="panel-heading">
								<i class="fa fa-bar-chart-o fa-fw"></i> HDFS (Hadoop Distributed File System)&nbsp;<span id="hdfsStatus" class="label font14"></span>
							</div>
							<div class="panel-body" id="hdfsDiv">
								<div class="row">
									<div class="col-md-6">
										<table class="table table-bordered">
											<caption>Summary</caption>
											<colgroup>
												<col width="250"/>
												<col width="*"/>
											</colgroup>
											<tbody id="hdfsTbody">
												<tr>
													<th>Active NameNode</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Stand By NameNode</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Start Time</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Dead Nodes</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Decommissioning Nodes</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Total Blocks</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Total Files</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Block Pool Used</th>
													<td> - </td>
												</tr>
											</tbody>
										</table>
									</div>
									<div class="col-md-6" style="margin-top: 33px;">
										<div id="hdfsInfoChart" style="height: 273px;border: 1px solid #ddd;padding-right: 2px;"></div>
									</div>
								</div>

								<div class="hdfsDetailArea top_space2">
									<div class="deviceListDiv">
										<table class="table table-bordered">
											<caption>In operation</caption>
											<thead>
												<tr>
													<th>Status</th>
													<th>Node</th>
													<th>DataNode Used</th>
													<th style="width:25%">Capacity</th>
													<th>Blocks</th>
													<th>Block pool used</th>
												</tr>
											</thead>
											<tbody id="hdfsOperationTbody"></tbody>
										</table>
									</div>
									<div id="hdfsDecomArea">
										<table class="table table-bordered">
											<caption>Decommissioning</caption>
											<thead>
												<tr>
													<th>Status</th>
													<th>Node</th>
													<th>Under replicated blocks</th>
													<th>Blocks with no live replicas</th>
													<th>Under Replicated Blocks <br/>In files under construction</th>
												</tr>
											</thead>
											<tbody id="hdfsDecomTbody"></tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
					
					
				<div class="row top_space2">
					<div class="col-lg-12">
						<div class="panel panel-default">
							<div class="panel-heading">
								<i class="fa fa-bar-chart-o fa-fw"></i> HBase&nbsp;<span id="hbaseStatus" class="label font14"></span>
							</div>
							<div class="panel-body">
								<div class="row">
									<div class="col-md-6">
										<table class="table table-bordered">
											<caption>Summary</caption>
											<colgroup>
												<col width="250"/>
												<col width="*"/>
											</colgroup>
											<tbody  id="hbaseTbody"  height="273">
												<tr>
													<th>Active Master</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Average Load</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Start Time</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Region Servers Count</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Dead Region Servers</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Heap Memory</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Non Heap Memory</th>
													<td> - </td>
												</tr>

											</tbody>
										</table>
									</div>
									<div class="col-md-6" style="margin-top: 33px;">
										<div id="hbaseInfoChart" style="height: 273px;border: 1px solid #ddd;padding-right: 2px;"></div>
									</div>
								</div>

								<div class="top_space2">
									<div class="deviceListDiv">
										<table class="table table-bordered">
											<caption>In operation</caption>
											<thead>
												<tr>
													<th>Status</th>
													<th>Node</th>
													<th>Region Count</th>
													<th>Memory Store(Count/Size)</th>
													<th>Hlog File(Count/Size)</th>
													<th>Store File(Count/Size)</th>
													<th>Store File Index Size</th>
													<th>Static Index Size</th>
												</tr>
											</thead>
											<tbody id="hbaseOperationTbody"></tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row top_space2">
					<div class="col-lg-12">
						<div class="panel panel-default">
							<div class="panel-heading">
								<i class="fa fa-bar-chart-o fa-fw"></i> SolrCloud&nbsp;<span id="solrStatus" class="label font14"></span>
							</div>
							<div class="panel-body">
								<div class="col-md-12">
									<div class="deviceListDiv">
										<table class="table table-bordered">
											<thead>
												<tr>
													<th>Status</th>
													<th>Core Name</th>
													<th>Core State</th>
													<th>Leader/Follower</th>
													<th>Document Count</th>
													<th>Index Size</th>
													<th>Request/Timeout/Error</th>
													<th>Average Time per Request</th>
												</tr>
											</thead>
											<tbody id="solrOperationTbody"></tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row top_space2">
					<div class="col-lg-12">
						<div class="panel panel-default">
							<div class="panel-heading">
								<i class="fa fa-bar-chart-o fa-fw"></i> Kafka&nbsp;<span id="kafkaStatus" class="label font14"></span>
							</div>
							<div class="panel-body">
								<div class="col-md-12">
									<div class="deviceListDiv">
										<table class="table table-bordered">
											<colgroup>
												<col width="320"/>
												<col width="*"/>
												<col width="320"/>
												<col width="*"/>
											</colgroup>
											<tbody class="infoTbody" id="kafkaTbody">
												<tr>
													<th>Controller</th>
													<td> - </td>
													<th>Topic Bytes Per Second(In/Out)</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Leader Count</th>
													<td> - </td>
													<th>Topic Messages In Per Second</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Partition Count</th>
													<td> - </td>
													<th>Producer Requests Per Second</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Under Replicated Partitions</th>
													<td> - </td>
													<th>Producer QueueTime(Request/Response)</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Isr(in-sync replica) Expands Per Second</th>
													<td> - </td>
													<th>Producer Purgatory Size</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Isr(in-sync replica) Shrinks Per Second</th>
													<td> - </td>
													<th>Consumer Requests Per Second</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Active Controller Count</th>
													<td> - </td>
													<th>Consumer QueueTime(Request/Response)</th>
													<td> - </td>
												</tr>
												<tr>
													<th>Offline Partitions Count</th>
													<td> - </td>
													<th>Consumer Purgatory Size</th>
													<td> - </td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>