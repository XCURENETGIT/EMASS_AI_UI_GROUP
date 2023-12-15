<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LTH - Dashboard</title>
<%@ include file="../base.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/morris.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/sb-admin-2.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/odometer-theme-default.css"/>" />
<script type="text/javascript" src="<c:url value="/js/odometer.min.js"/>"></script>

<style type="text/css">
@font-face{
	font-family:"DINLig";
	src:url('<c:url value="/fonts/DINLig.eot"/>');
	src:url('<c:url value="/fonts/DINLig.eot"/>?#iefix') format('embedded-opentype'),
	url('<c:url value="/fonts/din-light-webfont.woff"/>') format('woff'),
	url('<c:url value="/fonts/DINLig.ttf"/>') format('truetype');
	src:local(※), url('<c:url value="/fonts/din-light-webfont.woff"/>') format('woff');
}

.termDtStr{
	font-size: 13px;
	padding-top: 10px;
	font-family: "DINLig", Helvetica, Arial, sans-serif !important;
}
#deviceStatus1Time, #deviceStatus2Time {
	font-size: 13px;
	font-family: "DINLig", Helvetica, Arial, sans-serif !important;
}
.odometerxcn{
	font-family: "DINLig", Helvetica, Arial, sans-serif !important;
}

#userFilter1_totalCnt, #userFilter2_totalCnt, #userFilter3_totalCnt, #userFilter4_totalCnt {
	/* color: #337AB7; */
}

#userSeq { width: 100%;}

<%if(Config.getBoolean("ui.dashboard.abbreviation")) {%>
.huge {
	font-size: 27px !important;
}
.medium {
	font-size: 27px !important;
}

.unRead {
	font-size: 27px !important;
}
<%}%>
</style>
<script type="text/javascript">
/* window.odometerxcnOptions = {
	auto: false,
	selector: '.odometerxcn',
	format: '(,ddd)',
	duration: 3000,
	theme: 'default',
	animation: 'count'
}; */

Highcharts.setOptions({
	global : { useUTC : false },
	gridLineColor: '#fff',
	colors: ['#5a92c8', '#988125', '#7494ff', '#509384', '#35a4ea', '#bb6ecb', '#439851', '#33a0c4', '#7558cb', '#97b420'],
	lang: {
		months: [ '<s:message code="common.january"/>', '<s:message code="common.february"/>', '<s:message code="common.march"/>', '<s:message code="common.april"/>', '<s:message code="common.may"/>', '<s:message code="common.june"/>', '<s:message code="common.july"/>', '<s:message code="common.august"/>', '<s:message code="common.september"/>', '<s:message code="common.october"/>', '<s:message code="common.november"/>', '<s:message code="common.december"/>' ],
		shortMonths : [ '<s:message code="common.january"/>', '<s:message code="common.february"/>', '<s:message code="common.march"/>', '<s:message code="common.april"/>', '<s:message code="common.may"/>', '<s:message code="common.june"/>', '<s:message code="common.july"/>', '<s:message code="common.august"/>', '<s:message code="common.september"/>', '<s:message code="common.october"/>', '<s:message code="common.november"/>', '<s:message code="common.december"/>' ],
		weekdays : [ '<s:message code="common.sunday"/>', '<s:message code="common.monday"/>', '<s:message code="common.tuesday"/>', '<s:message code="common.wednesday"/>', '<s:message code="common.thursday"/>', '<s:message code="common.friday"/>', '<s:message code="common.saturday"/>' ],
		contextButtonTitle : '<s:message code="common.msg.char_type"/>',
		thousandsSep : ','
	},
	xAxis: {
		gridLineColor: '#333',
		gridLineWidth : 0.3,
		dateTimeLabelFormats: {
			day: '<s:message code="dashboard.display.day" arguments="%b,%d" />'
		}
	},
	yAxis: {
		gridLineColor: '#333',
		gridLineWidth : 0.3
	}
});
Highcharts.getOptions().colors = Highcharts.map(Highcharts.getOptions().colors, function (color) {
	return {
		radialGradient: { cx: 0.5, cy: 0.3, r: 0.7 },
		stops: [
			[0, color],
			[1, Highcharts.Color(color).brighten(-0.2).get('rgb')] // darken
		]
	};
});
</script>
<script>
var updateTime=40000;
var auditInterUserYn='N';

function getDefaultMenuKey(){
	//getDashBoardMenu.xcn
	ui.get({
		url : 'getDashBoardMenu.xcn',
		useYn : 'Y',
		defaultMenu : 'Y',
		success : function(data, total) {
			if(data.length > 0){
				location.href = '<c:url value="/ems/dashboard.do?menuKey="/>'+data[0].menuKey;
			}else{
				alert('<s:message code="common.msg.connect.error"/>');
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}

$(document).ready(function() {
	getDefaultMenuKey();
	return;
	onAll();
	
	getDashboard();
	setTimeout(function(){
		getTodayDataStatus();
	}, 200);
	setTimeout(function(){
		getTodayPatternPrivacy();
	}, 400);
	setTimeout(function(){
		getTodayRiskBehavior();
	}, 600);
	setTimeout(function(){
		getTodayKeywordDetection();
	}, 800);
	setTimeout(function(){
		getServiceDataLogging();
	}, 1200);
	setTimeout(function(){
		getFileSendTotal();
	}, 1400);
	setTimeout(function(){
		getInterestUserOptions();
	}, 1600);
	setTimeout(function(){
		getAdminFilterAmount();
	}, 1800);
	
	$('#fillSendBtn').click(function(){
		$('#fileSendPopInput').val('');
		$('#fileSendPop').attr('mode', 'modify');
		$("#fileSendPop").modal('show');
	});
	
	$('#userSeq').change(function(){
		var userSeq = $('#userSeq option:selected').val();
		var interestUserNm = $('#userSeq option:selected').text();
		ui.get({
			url : 'setConfAdmin.xcn',
			confId : 'interestUser.user',
			val : userSeq,
			interestUserNm : interestUserNm,
			auditInterUserYn : auditInterUserYn,
			success : function(data, total) {
			},
			error : function(status, message) {
				ui.alertMsg(message);
			},
			complete : function() {
				auditInterUserYn = 'N';
			}
		});
		getInterestUserService();
	});
	
	$('#fileSendSaveBtn').click(function(){
		var fileSizeStr = $('#fileSendPopInput').val().replace(/ /g, '');
		if( fileSizeStr == '' ) {
			ui.alertMsg('<s:message code="dashboard.message.input.filesize"/>');
			return;
		}
		if(!fileSizeStr.isNumber() || fileSizeStr.indexOf('-')>-1 || fileSizeStr.indexOf('.')>-1) {
			ui.alertMsg('<s:message code="dashboard.message.input.only_number"/>');
			return;
		}
		var maxFileSize=10240
		if(fileSizeStr > maxFileSize) {
			ui.alertMsg('<s:message code="dashboard.message.max_file_size" arguments="'+maxFileSize+'" />');
			return;
		}
		saveDashBoardConfig( 'file.send', fileSizeStr, "" );
	});
	
	$('#devStatus1Btn').click(function(){
		var options = getDeviceOptions();
		var str = '<select class="form-control input-sm" id="devStatus" name="devStatus">';
		str += options;
		str += '</select>';
		$("#devStatusPopSelect").html(str);
		
		$('#devStatusPop').attr('devDivId', 'device.status1');
		$("#devStatusPop").modal('show');
		var devSeq = $('#'+idIndicator('device.status1')).attr('deviceSeq');
		$('#devStatus').val( devSeq );
	});
	
	$('#devStatus2Btn').click(function(){
		var options = getDeviceOptions();
		var str = '<select class="form-control input-sm" id="devStatus" name="devStatus">';
		str += options;
		str += '</select>';
		$("#devStatusPopSelect").html(str);
		
		$('#devStatusPop').attr('devDivId', 'device.status2');
		$("#devStatusPop").modal('show');
		var devSeq = $('#'+idIndicator('device.status2')).attr('deviceSeq');
		$('#devStatus').val( devSeq );
	});
	
	$('#devSaveBtn').click(function(){
		saveDashBoardConfig ( $('#devStatusPop').attr('devDivId'), $('#devStatus').val(), $('#devStatus option:selected').text() );
	});
	
	$('#todayDataStatusLink').click(function(){
		$('#todayDataStatusForm').submit();
	});
	
	$('#todayPatternPrivacyLink').click(function(){
		$('#todayPatternPrivacyForm').submit();
	});
	
	$('#todayRiskBehaviorLink').click(function(){
		$('#todayRiskBehaviorForm').submit();
	});
	
	$('#todayKeywordDetectionLink').click(function(){
		$('#todayKeywordDetectionForm').submit();
	});
	
	$('#todayInterestUserLink').click(function(){
		$('#todayInterestUserForm').submit();
	});
	
	$('#todayFileSendLink').click(function(){
		$('#todayFileSendForm').submit();
	});
});

/**
 * 관심사용자 리스트 조회
 */
function getInterestUserOptions(){
	ui.get({
		url : 'getInterestSimpleUserList.xcn',
		success : function(data, total) {
			 var result = '';
			result+='<option value="">-<s:message code="consent.select"/>-</option>';
			result+='<option value="all">-<s:message code="interest.user.all"/>-</option>';
			for(var i=0 ; i<data.length; i++){
				result+='<option value="' + data[i].userSeq + '">' +  data[i].userNm + '</option>';
			}
			$("#userSeq").html(result);
			
			if( data.length > 0 ) {
				ui.get({
					url : 'getConfAdmin.xcn',
					confId : 'interestUser.user',
					success : function(data, total) {
						if(data != null){
							setTimeout(function(){
								auditInterUserYn = 'Y';
								$('#userSeq').val( data.val ).change();
							}, 100);
						}
					},
					error : function(status, message) {
						ui.alertMsg(message);
					},
					complete : function() {
					}
				});
			}
			off('interestUser.service.amount');
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}



/*
 * 대시보드 설정 저장
 */
function saveDashBoardConfig( key, val, str ) {
	ui.get({
		url : 'saveDashBoardConfig.xcn',
		dashKey : key,
		dashVal : val,
		dashValStr : str,
		adminId : '${_USERCREDENTIAL_.adminId}',
		success : function(data, total) {
			if( data > 0 ) {
				if( key == 'device.status1' || key == 'device.status2' ) {
					alert('<s:message code="dashboard.message.changed.device"/>');
					$("#devStatusPop").modal('hide');
					if( key == 'device.status1' ) {
						$('#'+idIndicator('device.status1')).attr('deviceSeq',val);
						getDeviceStatus1();
					} else if( key == 'device.status2' ) {
						$('#'+idIndicator('device.status2')).attr('deviceSeq',val);
						getDeviceStatus2();
					}
				}
				else if( key == 'file.send') {
					alert('<s:message code="dashboard.message.changed.file_size"/>');
					$("#fileSendPop").modal('hide');
					getFileSize();
					getFileSendTotal();
				}
			}
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
			
		}
	});
}

/*
 * 정상/비정상 장비 깜빡거림
 */
function getDeviceStatusColor( id, code ) {
	var id = idIndicator(id);
	window.setInterval(function(){
		if( code != 'S' ) {
			if($('#'+id).hasClass('panel-green')) {
				$('#'+id).removeClass('panel-green');
				$('#'+id).addClass('panel-red');
			} else {
				$('#'+id).removeClass('panel-red');
				$('#'+id).addClass('panel-green');
			}
		}
		else {
			$('#'+id).addClass('panel-green');
		}
	}, 1000);
}
function offAll(){
	$('.loading_div').remove();
}
function onAll(){
	$('.panel').each(function(){
		if($(this).attr('id')!=undefined){
			on($(this).attr('id'));
		}
	});
}
function on(id) {
	var obj = $('#'+idIndicator(id));
	var hei = obj.height();
	$(obj).append( '<div class="loading_div"><i class="fa fa-spinner fa-spin fa-3x fa-fw" style="margin-top:'+(hei/2.5)+'px"></i></div>');
	$('.loading_div').css({
		"position" : "absolute",
		"top" : "0px",
		"left" : "15px",
		"right" : "15px",
		"bottom" : "20px",
		"background-color" : "#F0F0F0",
		"opacity" : "0.3",
		"z-index" : "998",
		"text-align" : "center"
	});
}
function off(id) {
	var obj = $('#'+idIndicator(id)+' .loading_div');
	obj.remove();
}

var getAdminFilterAmountSetTime;
function getAdminFilterAmount(){

	if(getAdminFilterAmountSetTime!=null) window.clearTimeout(getAdminFilterAmountSetTime);
	ui.get({
		url : 'getAdminFilterAmount.xcn',
		searchStr :'',
		success : function(data, total) {
			$('#userFilter1_totalCnt').html(data['user.filter1'].total);
			$('#userFilter2_totalCnt').html(data['user.filter2'].total);
			$('#userFilter3_totalCnt').html(data['user.filter3'].total);
			$('#userFilter4_totalCnt').html(data['user.filter4'].total);
			
			$('#userFilter1_termDtStr').html(data['user.filter1'].termDtStr);
			$('#userFilter2_termDtStr').html(data['user.filter2'].termDtStr);
			$('#userFilter3_termDtStr').html(data['user.filter3'].termDtStr);
			$('#userFilter4_termDtStr').html(data['user.filter4'].termDtStr);
			
			$('#userFilter1_title').html(data['user.filter1'].filterNm);
			$('#userFilter2_title').html(data['user.filter2'].filterNm);
			$('#userFilter3_title').html(data['user.filter3'].filterNm);
			$('#userFilter4_title').html(data['user.filter4'].filterNm);
			
			$('#userFilter1Link').attr('href', '<c:url value="/ems/message.do?filterSeq='+data['user.filter1'].filterSeq+'"/>')
			$('#userFilter2Link').attr('href', '<c:url value="/ems/message.do?filterSeq='+data['user.filter2'].filterSeq+'"/>')
			$('#userFilter3Link').attr('href', '<c:url value="/ems/message.do?filterSeq='+data['user.filter3'].filterSeq+'"/>')
			$('#userFilter4Link').attr('href', '<c:url value="/ems/message.do?filterSeq='+data['user.filter4'].filterSeq+'"/>')
			
			off('user.filter1');
			off('user.filter2');
			off('user.filter3');
			off('user.filter4');
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
			getAdminFilterAmountSetTime = window.setTimeout(function(){
				getAdminFilterAmount();
			}, updateTime);
		}
	});
}

/*
 * 금일 데이터 수집 현황
 */
var getTodayDataStatusSetTime;
function getTodayDataStatus( ) {
	
	if(getTodayDataStatusSetTime!=null) window.clearTimeout(getTodayDataStatusSetTime);
	ui.get({
		url : 'getTodayDataStatus.xcn',
		searchStr :'',
		success : function(data, total) {
			$('#todayDataStatus_unRead').html(data.unRead);
			$('#todayDataStatus_totalCnt').html(data.total);
			$('#todayDataStatus_termDtStr').html(data.termDtStr);
			var val = '{startDt:"'+data.startDt+'",endDt:"'+data.endDt+'"}';
			$('#todayDataStatusForm [name=conditionParam]').val( val );
			off('today.logging.status');
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
			getTodayDataStatusSetTime = window.setTimeout(function(){
				getTodayDataStatus();
			}, updateTime);
		}
	});
}

/*
 * 개인정보 메시지 건수
 */
var getTodayPatternPrivacySetTime;
function getTodayPatternPrivacy( ) {
	
	if(getTodayPatternPrivacySetTime!=null) window.clearTimeout(getTodayPatternPrivacySetTime);
	ui.get({
		url : 'getTodayPatternPrivacy.xcn',
		searchStr :'',
		success : function(data, total) {
			$('#getTodayPatternPrivacy_unRead').html(data.unRead);
			$('#getTodayPatternPrivacy_totalCnt').html(data.total);
			$('#getTodayPatternPrivacy_termDtStr').html(data.termDtStr);
			var val = '{startDt:"'+data.startDt+'",endDt:"'+data.endDt+'",regexpYn:"Y",regexpVal:"CN%L@1|FN%L@1|SN%L@1|PN%L@1|DN%L@1",regexpStr:"<s:message code="bodyview.cn"/>(1<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>), <s:message code="bodyview.fn"/>(1<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>), <s:message code="bodyview.sn"/>(1<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>), <s:message code="bodyview.pn"/>(1<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>), <s:message code="bodyview.dn"/>(1<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>)"}';
			$('#todayPatternPrivacyForm [name=conditionParam]').val( val );
			off('personal.message.count');
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
			getTodayPatternPrivacySetTime = window.setTimeout(function(){
				getTodayPatternPrivacy();
			}, updateTime);
		}
	});
}

/*
 * 위험행위 메시지 건수
 */
var getTodayRiskBehaviorSetTime;
function getTodayRiskBehavior( ) {
	
	if(getTodayRiskBehaviorSetTime!=null) window.clearTimeout(getTodayRiskBehaviorSetTime);
	ui.get({
		url : 'getTodayRiskBehavior.xcn',
		searchStr :'',
		success : function(data, total) {
			try {
				$('#getTodayRiskBehavior_unRead').html(data.unRead);
				$('#getTodayRiskBehavior_totalCnt').html(data.total);
				$('#getTodayRiskBehavior_termDtStr').html(data.termDtStr);
				var val = '{startDt:"'+data.startDt+'",endDt:"'+data.endDt+'",regexpYn:"Y",regexpVal:"EC%L@1|EF%L@1|ID%L@1", regexpStr:"<s:message code="bodyview.ec"/>(1<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>), <s:message code="bodyview.ef"/>(1<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>), <s:message code="bodyview.id"/>(1<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>)"}';
				$('#todayRiskBehaviorForm [name=conditionParam]').val( val );
				off('riskBehavior.message.count');
			} catch(e){
			}
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
			getTodayRiskBehaviorSetTime = window.setTimeout(function(){
				getTodayRiskBehavior();
			}, updateTime);
		}
	});
}

/*
 * 키워드(예약어)
 */
var getTodayKeywordDetectionSetTime;
function getTodayKeywordDetection( ) {
	if(getTodayKeywordDetectionSetTime!=null) window.clearTimeout(getTodayKeywordDetectionSetTime);
	ui.get({
		url : 'getTodayKeywordDetection.xcn',
		searchStr :'',
		success : function(data, total) {
            alert(data);
			try {
				$('#getTodayKeywordDetection_unRead').html(data.unRead);
				$('#getTodayKeywordDetection_totalCnt').html(data.total);
				$('#getTodayKeywordDetection_termDtStr').html(data.termDtStr);
				var val = '{startDt:"'+data.startDt+'",endDt:"'+data.endDt+'",keywordYn:"Y"}';
				$('#todayKeywordDetectionForm [name=conditionParam]').val( val );
				off('keyword.message.count');
			}catch(e){
			}
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
			getTodayKeywordDetectionSetTime = window.setTimeout(function(){
				getTodayKeywordDetection();
			}, updateTime);
			
		}
	});
}

/*
 * 서비스별 데이터 수집건수(바 차트)
 */
var getServiceDataLoggingSetTime;
function getServiceDataLogging( ) {

	if(getServiceDataLoggingSetTime!=null) window.clearTimeout(getServiceDataLoggingSetTime);
	ui.get({
		url : 'getServiceDataLogging.xcn',
		success : function(data, total) {
			$('#service_logging_termDtStr').html(data.termDtStr);
			printChart(data.facet);
			off('service.logging.count');
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
			getServiceDataLoggingSetTime = window.setTimeout(function(){
				getServiceDataLogging();
			}, updateTime);
		}
	});
}

/*
 * 관심 사용자 서비스 사용률
 */
var getInterestUserServiceSetTime;
function getInterestUserService( ) {

	if(getInterestUserServiceSetTime!=null) window.clearTimeout(getInterestUserServiceSetTime);
	ui.get({
		url : 'getInterestUserService.xcn',
		userSeq : $('#userSeq').val(),
		success : function(data, total) {
			if(data.userSeq == '') {
				$('#userDataChart').html('<s:message code="interest.select.interest"/>');
			} else {
				printChart2(data);
			}
			off('interestUser.service.amount');
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
			getInterestUserServiceSetTime = window.setTimeout(function(){
				getInterestUserService();
			}, updateTime);
		}
	});
}

/*
 * 전체 관심 사용자 메시지 건수
 */
var getInterestUserMailSetTime;
function getInterestUserMail( ) {
	
	if(getInterestUserMailSetTime!=null) window.clearTimeout(getInterestUserMailSetTime);
	
	ui.get({
		url : 'getInterestUserMail.xcn',
		userSeq : $('#userSeq').val(),
		success : function(data, total) {
			$('#getInterestUserMail_totalCnt').html(data.total);
			$('#getInterestUserMail_termDtStr').html(data.termDtStr);
			var val = '{startDt:"'+data.startDt+'",endDt:"'+data.endDt+'","interUser":"all"}';
			$('#todayInterestUserForm [name=conditionParam]').val( val );
			off('interestUser.mail.count');
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
			getInterestUserMailSetTime = window.setTimeout(function(){
				getInterestUserMail();
			}, updateTime);
		}
	});
}

/*
 * 파일 전송 메시지 건수
 */
var getFileSendTotalSetTime;
function getFileSendTotal( ) {

	if(getFileSendTotalSetTime!=null) window.clearTimeout(getFileSendTotalSetTime);
	ui.get({
		url : 'getFileSendTotal.xcn',
		success : function(data, total) {
			$('#fileSend_termDtStr').html(data.termDtStr);
			$('#fileSend_totalCnt').html(data.total);
			var fileSizeToByte = parseInt(data.fileSize) * 1024 * 1024;
			var val = '{startDt:"'+data.startDt+'",endDt:"'+data.endDt+'","sizeStartVal":"'+fileSizeToByte+'","sizeEndVal":"0","sizeOption":"L","sizeType":"A"}';
			$('#todayFileSendForm [name=conditionParam]').val( val );
			off('file.send');
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
			getFileSendTotalSetTime = window.setTimeout(function(){
				getFileSendTotal();
			}, updateTime);
		}
	});
}

function reDefineDeviceStatus(code) {
	if( code == 'C' ) return '<s:message code="dashboard.disconnect"/>';     //접속 불가
	else if( code == 'I' ) return '<s:message code="dashboard.interest"/>'; //관심
	else if( code == 'W' ) return '<s:message code="dashbaord.warn"/>';     //주의
	else if( code == 'E' ) return '<s:message code="dashboard.danger"/>';   //위험
	else if( code == 'X' ) return '<s:message code="deviceInfo.critical"/>';   //심각
	else return '<s:message code="dashboard.clear"/>';                      //정상
}

function reDefineDeviceType(code) {
	return '';
	if( code == 'I' ) return '<s:message code="device.msg.all_in_one.device"/>';
	else if( code == 'C' ) return '<s:message code="device.msg.collect"/>';
	else if( code == 'A' ) return '<s:message code="device.msg.analysis"/>';
	else if( code == 'D' ) return '<s:message code="device.msg.db"/>';
}
function reDefineDeviceTime(t){
	if(t != '') {
		var ts = t.substring(11);
		var hour = ts.substring(0,2);
		var min = ts.substring(3,5);
		var sec = ts.substring(6,8);
		return '<s:message code="condition.time" arguments="'+hour+','+min+','+sec+'"/>';
	}
	return '-';
}
/*
 * 장비 영역1
 */
var getDeviceStatus1SetTime;
var deviceLinkDetail = '<c:url value="/commons/deviceInfoDetail.do?deviceSeq="/>';
var deviceLinkDetailHadoop = '<c:url value="/commons/deviceInfoDetailHadoop.do?deviceSeq="/>';
function getDeviceStatus1() {
	if(getDeviceStatus1SetTime!=null) window.clearTimeout(getDeviceStatus1SetTime);
	var deviceSeq = nvl($('#'+idIndicator('device.status1')).attr('deviceSeq'));
	if(deviceSeq==''){
		$('#deviceStatus1Link').attr('href', '#');
		$('#deviceStatus1').html('-');
		$('#deviceStatus1Title').html('<s:message code="dashboard.message.select.device"/>');
		$('#deviceStatus1Time').html('');
		off('device.status1');
		return;
	}

	ui.get({
		url : 'device/getDeviceStatusByDeviceSeq.xcn',
		deviceSeq : deviceSeq,
		success : function(data, total) {
			var status = '';
			try{
				status = data.currentDeviceStatus;
				if(data.deviceType=="M") {
					$('#deviceStatus1Link').attr('href', deviceLinkDetailHadoop + deviceSeq);
					status = data.hadoopDeviceStatus.currentDeviceStatus;
				} else $('#deviceStatus1Link').attr('href', deviceLinkDetail + deviceSeq);
				$('#deviceStatus1').html(reDefineDeviceStatus(status));
				
				if(status == 'E' || status == 'X') $('#'+idIndicator('device.status1')).removeClass('panel-green').removeClass('panel-yellow').removeClass('panel-gray').addClass('panel-red');
				else if(status == 'I' || status == 'W') $('#'+idIndicator('device.status1')).removeClass('panel-red').removeClass('panel-green').removeClass('panel-gray').addClass('panel-yellow');
				else if(status == 'C') $('#'+idIndicator('device.status1')).removeClass('panel-red').removeClass('panel-green').removeClass('panel-yellow').addClass('panel-gray');
				else $('#'+idIndicator('device.status1')).removeClass('panel-red').removeClass('panel-gray').removeClass('panel-yellow').addClass('panel-green');
				$('#deviceStatus1Title').html(reDefineDeviceType(data.deviceType)+''+data.deviceName+'('+data.deviceIP+')');
				$('#deviceStatus1Time').html(reDefineDeviceTime(data.currentDeviceStatusDt));
			} catch(e){console.log(e)}
		},
		error : function(status, message) {
		},
		complete : function() {
			off('device.status1');
			getDeviceStatus1SetTime = window.setTimeout(function(){
				getDeviceStatus1();
			}, 5000);
		}
	});
}

/*
 * 장비 영역2
 */
var getDeviceStatus2SetTime;
function getDeviceStatus2() {
	if(getDeviceStatus2SetTime!=null) window.clearTimeout(getDeviceStatus2SetTime);
	var deviceSeq = nvl($('#'+idIndicator('device.status2')).attr('deviceSeq'));
	if(deviceSeq==''){
		$('#deviceStatus2Link').attr('href', '#');
		$('#deviceStatus2').html('-');
		$('#deviceStatus2Title').html('<s:message code="dashboard.message.select.device"/>');
		$('#deviceStatus2Time').html('');
		off('device.status2');
		return;
	}

	ui.get({
		url : 'device/getDeviceStatusByDeviceSeq.xcn',
		deviceSeq : deviceSeq,
		success : function(data, total) {
			var status = '';
			try{
				status = data.currentDeviceStatus;
				if(data.deviceType=="M") {
					$('#deviceStatus2Link').attr('href', deviceLinkDetailHadoop + deviceSeq);
					status = data.hadoopDeviceStatus.currentDeviceStatus;
				} else $('#deviceStatus2Link').attr('href', deviceLinkDetail + deviceSeq);
				$('#deviceStatus2').html(reDefineDeviceStatus(status));
				
				if(status == 'E' || status == 'X') $('#'+idIndicator('device.status2')).removeClass('panel-green').removeClass('panel-yellow').removeClass('panel-gray').addClass('panel-red');
				else if(status == 'I' || status == 'W') $('#'+idIndicator('device.status2')).removeClass('panel-red').removeClass('panel-green').removeClass('panel-gray').addClass('panel-yellow');
				else if(status == 'C') $('#'+idIndicator('device.status2')).removeClass('panel-red').removeClass('panel-green').removeClass('panel-yellow').addClass('panel-gray');
				else $('#'+idIndicator('device.status2')).removeClass('panel-red').removeClass('panel-gray').removeClass('panel-yellow').addClass('panel-green');
				$('#deviceStatus2Title').html(reDefineDeviceType(data.deviceType)+''+data.deviceName+'('+data.deviceIP+')');
				$('#deviceStatus2Time').html(reDefineDeviceTime(data.currentDeviceStatusDt));
			} catch(e){console.log(e)}
		},
		error : function(status, message) {
		},
		complete : function() {
			off('device.status2');
			getDeviceStatus1SetTime = window.setTimeout(function(){
				getDeviceStatus2();
			}, 5000);
		}
	});
}

/*
 * 파일 전송 메시지 건수(파일 사이즈 조회)
 */
function getFileSize( ) {
	ui.get({
		url : 'getDashBoardConfig.xcn',
		adminId : '${_USERCREDENTIAL_.adminId}',
		dashKey : 'file.send',
		success : function(data, total) {
			if( data != null ) {
				var str = '<s:message code="dashboard.msg.over_msg" arguments="'+data.dashVal+'"/>';
				$('#fileSize').html(str);
			}
			else {
				var str = '<s:message code="dashboard.msg.over_msg" arguments="0"/>';
				$('#fileSize').html(str);
			}
			off('file.send');
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
			
		}
	});
}

function getUserFilter( data ) {
	$('#userFilter1_totalCnt').html(data.total);
	$('#userFilter1_termDtStr').html(data.termDtStr);
	
	var str = '<s:message code="dashboard.msg.over_msg" arguments="'+data.fileSize+'"/>';
	$('#fileSize').html(str);
}

function getDeviceOptions(){
    var result = '';
	ui.get({
		asyncFlag : false,
		url : 'getDeviceStatusList.xcn',
		searchStr :'',
		success : function(data, total) {
			result+='<option value="">-<s:message code="dashboard.select.device"/>-</option>';
			for(var i=0 ; i<data.length; i++){
				result+='<option value="' + data[i].deviceSeq + '">' + reDefineDeviceType( data[i].deviceType ) + '-' + data[i].deviceName + '(' + data[i].deviceIP + ')' + '</option>';
			}
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
		}
	});
	return result;
}

var chart = null;
function printChart(data) {
	$('#svcDataChart').html('');
	
	if(data.length == 0 ) {
		$('#svcDataChart').html('<s:message code="dashboard.message.nodata.today"/>');
		return;
	}
	$('#svcDataChart').highcharts({
		chart: {
			type: 'column',
			options3d: {
				enabled: true,
				alpha: 10,
				beta: 0,
				depth: 50,
				viewDistance: 25
			}
		},
		exporting : {
			enabled: false
		},
		credits : {
			enabled: false
		},
		title: {
		    text: ''
		},
		xAxis: {
			type: 'category',
			labels: {
				rotation: -20,
				x: 25,
				style: {
					fontSize: '13px',
					fontFamily: 'DINLig, Verdana, sans-serif'
				}
			},gridLineWidth: 0
		},
		yAxis: {
			type: 'logarithmic',
			min:1,
			title: {
				text: '(<s:message code="common.msg.count"/>)',
				rotation: 0
			}
		},
		legend: {
			enabled: false
		},
		tooltip: {
			pointFormat: '<s:message code="dashboard.collect.data_count"/> : <b>{point.y:,.0f} (<s:message code="common.msg.cnt"/>)</b>'
		},
		series: [{
			name: 'Population',
			data: data,
			dataLabels: {
				enabled: true,
				format: '{point.y:,.0f}',
				style: {
					color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
				}
			}
		}]
	});
}

function printChart2(data) {
	$('#userDataChart').html('');

	if(data.length == 0 ) {
		$('#userDataChart').html('<s:message code="common.msg.nodata"/>');
		return;
	}

	$('#userDataChart').highcharts({
		chart: {
			plotBackgroundColor: null,
			plotBorderWidth: null,
			plotShadow: false,
			type: 'pie'
		},
		exporting : {
			enabled: false
		},
		credits : {
			enabled: false
		},
		title : {
			text : ''
		},
		subtitle: {
			text: data.termDtStr
		},
		tooltip: {
			pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
		},
		plotOptions: {
			pie: {
				allowPointSelect: true,
				cursor: 'pointer',
				depth: 35,
				dataLabels: {
					enabled: true,
					format: '{point.name}'
				}
			}
		},
		series: [{
			name: '<s:message code="dashboard.rate"/>',
			colorByPoint: true,
			data: data.facet
		}]
	});
}

/*
 * 대시보드 설정
 */
function getDashboard( ) {
	ui.get({
		asyncFlag : false,
		url : 'getDashBoardConfigs.xcn',
		success : function(data, total) {
			for(var i = 0; i < data.length; i++ ) {
				var obj = $('#'+idIndicator(data[i].dashKey));
				var cls = data[i].dashClass;
				$(obj).removeClass('panel-gray').addClass(cls);
				
				if( data[i].dashKey == 'file.send' ){
					var str = '<s:message code="dashboard.msg.over_msg" arguments="'+data[i].dashVal+'"/>';
					$('#fileSize').html( str );
				}
				if( data[i].dashKey == 'device.status1' ) {
					$('#'+idIndicator('device.status1')).attr('deviceSeq',data[i].dashVal);
					getDeviceStatus1();
				}
				if( data[i].dashKey == 'device.status2' ) {
					$('#'+idIndicator('device.status2')).attr('deviceSeq',data[i].dashVal);
					getDeviceStatus2();
				}
			}
			
			//getInterestUserMail();
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}
function idIndicator(id){
	return id.fReplaceWord('.', '\\.');
}

function preventEnter(e){
	if(e.keyCode == 13) return false;
}
</script>
</head>
<body class="mini-navbar">
	<div class="modal fade" id="fileSendPop" tabindex="-1" role="dialog" aria-labelledby="fileSendModal">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="fileSendPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="dashboard.setting.trans_file_size"/></h3>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label for="fileSendPopInput" class=""><s:message code="dashboard.file_size"/> (<s:message code="stat.traffic.unit2"/>)</label>
						<input type="text" class="form-control" name="fileSize" id="fileSendPopInput" placeholder="<s:message code="dashboard.file_size"/>" required onkeydown="return preventEnter(event);">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="fileSendSaveBtn"><s:message code="common.msg.save"/></button>
				</div>
				</form>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="devStatusPop" tabindex="-1" role="dialog" aria-labelledby="devStatusModal">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="devStatusPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="dashboard.setting.device"/></h3>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label for="devStatusPopSelect" class=""><s:message code="dashboard.select.device"/></label>
						<div id="devStatusPopSelect">
						
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="devSaveBtn"><s:message code="common.msg.save"/></button>
				</div>
				</form>
			</div>
		</div>
	</div>
	
	<jsp:include page="../top.jsp">
		<jsp:param name="headerYn" value="N"/>
	</jsp:include>
	<div class="container"> 
		<div class="boxArea">
			<div class="content_body">
				<div class="row">
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-gray" id="today.logging.status">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-3">
										<i class="fa fa-envelope fa-5x"></i>
									</div>
									<div class="col-xs-9 text-right">
										<div class="unRead"><span id="todayDataStatus_unRead" class="odometerxcn">0</span> / <span id="todayDataStatus_totalCnt" class="huge odometerxcn">0</span></div>
										<div id="todayDataStatus_termDtStr" class="termDtStr"><s:message code="condition.hour" arguments="00" />~<s:message code="condition.hour" arguments="23" /></div>
										<form method="post" action="<c:url value="/ems/message.do"/>" target="_self" id="todayDataStatusForm">
											<input type="hidden" name="conditionParam" />
										</form>
									</div>
								</div>
							</div>
							<a href="#" id="todayDataStatusLink">
								<div class="panel-footer">
									<span class="pull-left dash-title"><s:message code="dashboard.msg.data_count"/></span>
									<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
									<div class="clearfix"></div>
								</div>
							</a>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-gray" id="personal.message.count">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-3">
										<i class="fa fa-user fa-5x"></i>
									</div>
									<div class="col-xs-9 text-right">
										<div class="unRead"><span id="getTodayPatternPrivacy_unRead" class="odometerxcn">0</span> / <span id="getTodayPatternPrivacy_totalCnt" class="huge odometerxcn">0</span></div>
										<div id="getTodayPatternPrivacy_termDtStr" class="termDtStr"><s:message code="condition.hour" arguments="00" />~<s:message code="condition.hour" arguments="23" /></div>
										<form method="post" action="<c:url value="/ems/message.do"/>" target="_self" id="todayPatternPrivacyForm">
											<input type="hidden" name="conditionParam" />
										</form>
									</div>
								</div>
							</div>
							<a href="#" id="todayPatternPrivacyLink">
								<div class="panel-footer">
									<span class="pull-left dash-title"><s:message code="dashboard.msg.regexp_count"/></span>
									<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
									<div class="clearfix"></div>
								</div>
							</a>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-gray" id="riskBehavior.message.count">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-3">
										<i class="fa fa-warning fa-5x"></i>
									</div>
									<div class="col-xs-9 text-right">
										<div class="unRead"><span id="getTodayRiskBehavior_unRead" class="odometerxcn">0</span> / <span id="getTodayRiskBehavior_totalCnt" class="huge odometerxcn">0</span></div>
										<div id="getTodayRiskBehavior_termDtStr" class="termDtStr"><s:message code="condition.hour" arguments="00" />~<s:message code="condition.hour" arguments="23" /></div>
										<form method="post" action="<c:url value="/ems/message.do"/>" target="_self" id="todayRiskBehaviorForm">
											<input type="hidden" name="conditionParam" />
										</form>
									</div>
								</div>
							</div>
							<a href="#" id="todayRiskBehaviorLink">
								<div class="panel-footer">
									<span class="pull-left dash-title"><s:message code="dashboard.msg.regexp_count.danger"/></span>
									<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
									<div class="clearfix"></div>
								</div>
							</a>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-gray" id="keyword.message.count">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-3">
										<i class="fa fa-font fa-5x"></i>
									</div>
									<div class="col-xs-9 text-right">
										<div class="unRead"><span id="getTodayKeywordDetection_unRead" class="odometerxcn">0</span> / <span id="getTodayKeywordDetection_totalCnt" class="huge odometerxcn">0</span></div>
										<div id="getTodayKeywordDetection_termDtStr" class="termDtStr"><s:message code="condition.hour" arguments="00" />~<s:message code="condition.hour" arguments="23" /></div>
										<form method="post" action="<c:url value="/ems/message.do"/>" target="_self" id="todayKeywordDetectionForm">
											<input type="hidden" name="conditionParam" />
										</form>
									</div>
								</div>
							</div>
							<a href="#" id="todayKeywordDetectionLink">
								<div class="panel-footer">
									<span class="pull-left dash-title"><s:message code="dashboard.msg.keyword"/></span>
									<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
									<div class="clearfix"></div>
								</div>
							</a>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-gray" id="user.filter1">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-3">
										<i class="fa fa-star-o fa-5x"></i>
									</div>
									<div class="col-xs-9 text-right">
										<div class="huge odometerxcn" id="userFilter1_totalCnt">0</div>
										<div id="userFilter1_termDtStr" class="termDtStr"><s:message code="condition.hour" arguments="00" />~<s:message code="condition.hour" arguments="23" /></div>
									</div>
								</div>
							</div>
							<a href="<c:url value="/ems/message.do"/>" id="userFilter1Link">
								<div class="panel-footer">
									<span class="pull-left dash-title" id="userFilter1_title"><s:message code="dashboard.msg.filter.user"/>1</span>
									<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
									<div class="clearfix"></div>
								</div>
							</a>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-gray" id="user.filter2">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-3">
										<i class="fa fa-star-o fa-5x"></i>
									</div>
									<div class="col-xs-9 text-right">
										<div class="huge odometerxcn" id="userFilter2_totalCnt">0</div>
										<div id="userFilter2_termDtStr" class="termDtStr"><s:message code="condition.hour" arguments="00" />~<s:message code="condition.hour" arguments="23" /></div>
									</div>
								</div>
							</div>
							<a href="<c:url value="/ems/message.do"/>" id="userFilter2Link">
								<div class="panel-footer">
									<span class="pull-left dash-title" id="userFilter2_title"><s:message code="dashboard.msg.filter.user"/>2</span>
									<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
									<div class="clearfix"></div>
								</div>
							</a>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-gray" id="user.filter3">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-3">
										<i class="fa fa-star-o fa-5x"></i>
									</div>
									<div class="col-xs-9 text-right">
										<div class="huge odometerxcn" id="userFilter3_totalCnt">0</div>
										<div id="userFilter3_termDtStr" class="termDtStr"><s:message code="condition.hour" arguments="00" />~<s:message code="condition.hour" arguments="23" /></div>
									</div>
								</div>
							</div>
							<a href="<c:url value="/ems/message.do"/>" id="userFilter3Link">
								<div class="panel-footer">
									<span class="pull-left dash-title" id="userFilter3_title"><s:message code="dashboard.msg.filter.user"/>3</span>
									<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
									<div class="clearfix"></div>
								</div>
							</a>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-gray" id="user.filter4">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-3">
										<i class="fa fa-star-o fa-5x"></i>
									</div>
									<div class="col-xs-9 text-right">
										<div class="huge odometerxcn" id="userFilter4_totalCnt">0</div>
										<div id="userFilter4_termDtStr" class="termDtStr"><s:message code="condition.hour" arguments="00" />~<s:message code="condition.hour" arguments="23" /></div>
									</div>
								</div>
							</div>
							<a href="<c:url value="/ems/message.do"/>" id="userFilter4Link">
								<div class="panel-footer">
									<span class="pull-left dash-title" id="userFilter4_title"><s:message code="dashboard.msg.filter.user"/>4</span>
									<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
									<div class="clearfix"></div>
								</div>
							</a>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-8">
						<div class="panel panel-default" id="service.logging.count">
							<div class="panel-heading">
								<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="dashboard.msg.service"/>
								<div class="pull-right">
									<span id="service_logging_termDtStr">-</span>
								</div>
							</div>
							<div class="panel-body">
								<div id="svcDataChart" style="height: 230px;width:100%;"></div>
							</div>
						</div>
					</div>
					<div class="col-lg-4">
						<div class="panel panel-default" id="interestUser.service.amount">
							<div class="panel-heading">
								<i class="fa fa-bell fa-fw"></i> <s:message code="dashboard.msg.interest.service_rate"/>
								<div class="pull-right pull-middle" style="width: 30%;">
									<select style="border: 1px solid #999;" id="userSeq">
										<option>-<s:message code="consent.select"/>-</option>
									</select>
								</div>
							</div>
							<div class="panel-body">
								<div id="userDataChart" style="height: 230px;"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-gray device_status" id="device.status1">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-3">
										<a href="javascript:void(0);" class="iconSetting" id="devStatus1Btn">
											<i class="fa fa-tasks fa-5x"></i>
											<span style="position: absolute; top: 40px; left: 82px;"><span class="fa fa-cog fa-spin fa-3x fa-fw" style="font-size: 25px;"></span></span>
										</a>
									</div>
									<div class="col-xs-9 text-right">
										<div class="huge" id="deviceStatus1">-</div>
										<div id="deviceStatus1Time"></div>
									</div>
								</div>
							</div>
							<a href="<c:url value="/commons/deviceInfo.do?deviceSeq="/>" id="deviceStatus1Link">
								<div class="panel-footer">
									<span class="pull-left dash-title" id="deviceStatus1Title">-</span>
									<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
									<div class="clearfix"></div>
								</div>
							</a>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-gray device_status" id="device.status2">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-3">
										<a href="javascript:void(0);" class="iconSetting" id="devStatus2Btn">
											<i class="fa fa-database fa-5x"></i>
											<span style="position: absolute; top: 40px; left: 72px;"><span class="fa fa-cog fa-spin fa-3x fa-fw" style="font-size: 25px;"></span></span>
										</a>
									</div>
									<div class="col-xs-9 text-right">
										<div class="huge" id="deviceStatus2">-</div>
										<div id="deviceStatus2Time"></div>
									</div>
								</div>
							</div>
							<a href="<c:url value="/commons/deviceInfo.do?deviceSeq="/>" id="deviceStatus2Link">
								<div class="panel-footer">
									<span class="pull-left dash-title" id="deviceStatus2Title">-</span>
									<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
									<div class="clearfix"></div>
								</div>
							</a>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-gray" id="interestUser.mail.count">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-3">
										<i class="fa fa-users fa-5x"></i>
									</div>
									<div class="col-xs-9 text-right">
										<div class="huge odometerxcn" id="getInterestUserMail_totalCnt">0</div>
										<div id="getInterestUserMail_termDtStr" class="termDtStr"><s:message code="condition.hour" arguments="00" />~<s:message code="condition.hour" arguments="23" /></div>
										<form method="post" action="<c:url value="/ems/message.do"/>" target="_self" id="todayInterestUserForm">
											<input type="hidden" name="conditionParam" />
										</form>
									</div>
								</div>
							</div>
							<a href="#" id='todayInterestUserLink'>
								<div class="panel-footer">
									<span class="pull-left dash-title"><s:message code="dashboard.msg.interest.all"/></span>
									<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
									<div class="clearfix"></div>
								</div>
							</a>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-gray" id="file.send">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-3">
										<a href="javascript:void(0);" class="iconSetting" id="fillSendBtn">
											<i class="fa fa-save fa-5x"></i>
											<span style="position: absolute; top: 40px; left: 72px;"><span class="fa fa-cog fa-spin fa-3x fa-fw" style="font-size: 25px;"></span></span>
										</a>
									</div>
									<div class="col-xs-9 text-right">
										<div class="huge odometerxcn" id="fileSend_totalCnt">0</div>
										<div id="fileSend_termDtStr" class="termDtStr">-</div>
										<form method="post" action="<c:url value="/ems/message.do"/>" target="_self" id="todayFileSendForm">
											<input type="hidden" name="conditionParam" />
										</form>
									</div>
								</div>
							</div>
							<a href="#" id="todayFileSendLink">
								<div class="panel-footer">
									<span class="pull-left dash-title"><span id="fileSize"><s:message code="dashboard.msg.over_msg" arguments="0"/></span></span>
									<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
									<div class="clearfix"></div>
								</div>
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>
	<script type="text/javascript" src="<c:url value="/js/sb-admin-2.js"/>"></script>
</body>
</html>