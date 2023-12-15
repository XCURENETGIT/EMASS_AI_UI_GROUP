<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/dashboard.css"/>"/>
<%
	String infoFeedbackYn = Common.getInfoFeedbackYn(session);
	boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
	String adminType = Common.getAdminType(session);
	String systemArch = Config.getString("system.arch");
	pageContext.setAttribute("arch", systemArch);
%>


<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LTH - Dashboard</title>



<style type="text/css">
.panel-body {
	padding-top: 15px;
	padding-bottom: 0px;
}
#emptyDiv{
	position: absolute;
	top: 35px;
	bottom: 100px;
	left: 0;
	right: 0;
}
#emptyDiv p, #emptyDiv h1{
	text-align: center;
}
.empty-dashboard-message{
	margin: auto;
	width: 700px;
	height: 200px;
}

#emptyDashboard{
	text-align: center;
	padding-top: 25px;
}
.customBtn{
	border:1px solid #ccc;
}


.carousel-inner{
	height:160px;
}
.item{
	padding-top:10px;
}

.addDashboardContent:hover{
	text-decoration: none;	
}
.card{
	border: 1px solid #efefef;
	border-radius: 4px;
	background: #fff;
	box-shadow: 0 6px 10px rgba(0,0,0,.08), 0 0 6px rgba(0,0,0,.05);
	transition: .3s transform cubic-bezier(.155,1.105,.295,1.12),.3s box-shadow,.3s -webkit-transform cubic-bezier(.155,1.105,.295,1.12);
	padding: 14px 80px 18px 36px;
	cursor: pointer;
}

.card:hover{
  box-shadow: 0px 15px 20px rgba(0,0,0,.12), 0 5px 10px rgba(0,0,0,.06);
}

.card h4{
  font-weight: 600;
  color:#000;
}

.card p{
	color:#999;
	font-size:12px;
}

.card div{
	color:#000;
}

.card img{
  position: absolute;
  top: 20px;
  right: 15px;
  max-height: 120px;
}

.card-1{
	/* background-image: url(<c:url value="/img/components-card.png"/>); */
	background-color: #efefef;
	background-repeat: no-repeat;
	background-position: left;
	background-size: 5px;
	height:125px;
	border: 2px dashed #ccc;
}

@media(max-width: 990px){
  .card{
    margin: 20px;
  }
} 
.customClose {
	color: #666;
	opacity: 1;
}
.customClose:hover {
	color: #999;
}
.grid-stack-item-content{
	text-align: left;
}
.customClass {
	font-size: 3em !important;
}
.chartDash {
	font-size: 15px !important;
}
.grid-stack-item-content .fa {
	display: inline-block;
}
div#conditionViewDiv{
	position: absolute;
	display: none;
	text-align: left;
	z-index: 1000;
	border: 1px solid #555;
	background-color: #DCE7F3;
	width:400px;
	overflow: auto;
	word-break: break-all;
}
.tCenter {text-align: center; background-color: #f9f9f9;}
.Center {text-align: center;}
.tLeft {text-align: left;}
.tRight {text-align: right;}
</style>
<script type="text/javascript">
var infoFeedbackYn = '<%=infoFeedbackYn%>';
var infoFeedbackConf = '<%=infoFeedbackConf%>';
var systemArch = '<%=systemArch%>';
var adminType = '<%=adminType%>';
var date;
var editMode = 'N';

$.urlParam = function(name){
	var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
	if (results==null){
		return null;
	}
	else{
		return results[1] || 0;
	}
}
var menuKey;
$(document).ready(function() {
	menuKey = $.urlParam('menuKey');
	if(menuKey) dashboardInit();
	else getDefaultMenuKey();
	
	$('#fileSizeDatepicker ').datetimepicker({
		format:'YYYY-MM-DD',
		defaultDate: moment(new Date())
	}).on('dp.change',function(){
		fileSize();
	});
	
	$('#fileCountDatepicker').datetimepicker({
		format: 'YYYY-MM-DD',
		defaultDate: moment(new Date())
	}).on('dp.change',function(){
		fileCount(); 
	});
	
	$('#startdatepicker ').datetimepicker({
		format: 'YYYY-MM-DD',
		defaultDate: moment(new Date())
	}).on('dp.change',function(){
		getLoggingData();
	});
	
	getLoggingDataSetting();
	checkDefaultMenu();
	checkMonitorDB();
	
	$('#fileSize').on('click', 'td', function (e) {
		var trid = $(this).closest('td').attr('id');
		if(trid == undefined) return;
		date = $('#fileSizeDate').val();
		fnOpenWindow('<c:url value="/ems/monitorMessage.do" />?srcip='+size[trid].srcIp+'&dstip='+size[trid].dstIp+'&host='+size[trid].host + '&date='+date, 'monitorLogPop', 1300, 800, 'fix');
	});
	
	$('#fileCount').on('click', 'td', function (e) {
		var trid = $(this).closest('td').attr('id');  
		if(trid == undefined) return;
		date = $('#fileCountDate').val();
		fnOpenWindow('<c:url value="/ems/monitorMessage.do" />?srcip='+count[trid].srcIp+'&dstip='+count[trid].dstIp+'&host='+count[trid].host + '&date='+date, 'monitorLogPop', 1300, 800, 'fix');
	});
	
	$('#setupDashboardBtn').click(function(){
		location.href = '<c:url value="/ems/dashboardSetup.do"/>';
	});

	$('#editDashboardBtn, #editDashboardBtnPop').click(function(){
		editMode = 'Y';
		$('#emptyDiv').hide();
		$('.dashboardHeader').show();
		var grid = $('#dashboardArea').data('gridstack');
		grid.movable('.grid-stack-item', true);
		grid.resizable('.grid-stack-item', true);
		
		if(loggingDataSettingVal == 'Y') $('#dashboardInfo').css('margin-top','200px');
		else $('#dashboardArea').css('top','200px');
	});
	
	$('#saveDashboardBtn').click(function(){
		ui.confirmMsg('<s:message code="custom.msg.save"/>', '', '', function(rs){
			if(rs){
				$('.dashboardHeader').hide();
				var grid = $('#dashboardArea').data('gridstack');
				grid.movable('.grid-stack-item', false);
				grid.resizable('.grid-stack-item', false);
				
				dashboardGrid.saveGrid();
				if(loggingDataSettingVal == 'Y') $('#dashboardInfo').css('margin-top','25px');
				else $('#dashboardArea').css('top','25px');
				editMode = 'N';
			}
		});
	});
	$('#cancleDashboardBtn').click(function(){
		ui.confirmMsg('<s:message code="custom.msg.cancle"/>', '', '', function(rs){
			if(rs){
				$('.dashboardHeader').hide();
		
				var grid = $('#dashboardArea').data('gridstack');
				grid.movable('.grid-stack-item', false);
				grid.resizable('.grid-stack-item', false);
				
				getDashBoardList();
				if(loggingDataSettingVal == 'Y') $('#dashboardInfo').css('margin-top','25px');
				else $('#dashboardArea').css('top','25px');
				editMode = 'N';
			}
		});
		
	});
	$(document).on('click', '#addDefaultData', function(){
		ui.get({
			url : 'insertDashBoardDefaultData.xcn',
			success : function ( data, total ) {
				ui.alertMsg('<s:message code="custom.msg.addDefaultSet"/> \n\n <s:message code="dashboardMenu.msg.refresh"/>', function(){
					window.location.reload();
				});
			},
			error : function (status, message) {
				ui.alertMsg(message);
			},
			complete : function (){
			}
		});
	});
	
	
	$(document).on('mouseover', '.conditionView', function(e){
		if( $('#conditionViewDiv').css('display') == 'block' ) return;
		$('#conditionViewDiv').fadeIn();
		var x = e.clientX;
		var o = $(this).parent().parent().offset();
		$('#conditionViewDiv').css({'top':'250px','left':o.left})
		
		var index = $(this).parent().parent().parent().attr('data-index');
		
		$('#conditionViewContent').html( printAlarmValStr('', JSON.parse(contentData[index].dashCondition),'return') );
	});
	$(document).on('mouseout', '.conditionView', function(){
		$('#conditionViewDiv').hide();
	});
	
	$(document).on('click', '.panel-footer', function(){
		var id = $(this).parents('.grid-stack-item').attr('data-gs-id');
		var dashCondition;
		for(var i=0; i<contentData.length; i++){
			if(contentData[i].dashKey == id.split('_')[1]){
				dashCondition = contentData[i].dashCondition;
				break;
			}
		}
		if(dashCondition != undefined){
			$('#conditionParam').val(makePeriod(dashCondition));
			$('#getMessageInfo').submit();
		}
	});
	
	$(document).on('click', '.bodyOpenBtn', function(){
		var msgid = $(this).attr('data-msgid');
		openMessageBody( '', msgid, '');
	});
	
	$('#dashboardSelect').selectpicker({
		container:'body',
		width:'200px'
	});
	
	$(document).on('click', '.addDashboardContent', function(){
		var index = $(this).attr('data-index');
		
		var obj = getDashPosition(contentData[index].dashKey, contentData[index].dashType, contentData[index].dashChart);
		var id = menuKey +'_'+contentData[index].dashKey;
		
		var hasFlag = false;
		$('#dashboardArea').find('.grid-stack-item').each(function(index){
			if($(this).attr('data-gs-id') == id){
				hasFlag = true;
				return false;
			}
		});
		if( hasFlag){
			alert('<s:message code="custom.msg.alreadySave"/>');
			return;
		}
		
		
		var htmlObj = $(contentData[index].html);
		obj.html = htmlObj;
		//obj.html = contentData[index].html;
		
		dashboardGrid.addWidget(obj);
	});
	
	$('#menuLoggingBtn').click(function(){
		$("#loggingDataPop").modal('show');
		$('#loggingDataUseYn').val(loggingDataSettingVal);
	});
	
	$('#loggingDataSaveBtn').click(function(){
		saveLoggingData();
	});
	
	$('#menuDefaultSetupBtn').click(function(){
		var menuName = $('.navi').html();
		ui.confirmMsg( '<s:message code="custom.msg.defaultSave"/>', '', '', function(rs){
			if(rs){
				ui.get({
					url : 'changeDashBoardDefaultMenu.xcn',
					menuKey : menuKey,
					menuName : menuName,
					success : function ( data, total ) {
						defaultMenuKey = menuKey;
						changeMainMenu(menuKey);
						ui.alertMsg('<s:message code="common.msg.modified"/>');
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
					}
				});
			}
		});
	})
});

function saveLoggingData(){
	ui.confirmMsg('<s:message code="base.change.pw"/>', '', '', function(rs){
		if(rs){
			ui.get({
				url : 'saveLoggingData.xcn',
				useYn : $('#loggingDataUseYn').val(),
				success : function(data, total) {
					$("#loggingDataPop").modal('hide');
					ui.alertMsg('<s:message code="dashboard.logginDataChange"/>');
					getLoggingDataSetting();
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
				}
			});
		}
	});
}

var chart = null;
var chartxAxis;
function printChart( dat ) {
	var visible = true;
	if(systemArch == 'multiple' && adminType == 'M') visible = false;
	
	var categories = [];
	var logging = [];
	var attach = [];
	if( dat.length == 0) {
		$('#chartArea1').html('<s:message code="common.msg.nodata"/>');
		return false;
	} else {
		for ( var i=0 ; i < dat.length ; i++ ) {
			categories.push(getDateFormatSize(dat[i].date));
			logging.push(Number(dat[i].logging));
			attach.push(dat[i].attach == undefined ? 0 : Number(dat[i].attach));
		}
	}
	
	var rotation = 40;
	if ( chartxAxis == 'W' ) rotation = 0;
	$('#chartArea1').highcharts({
		chart: {
	        zoomType: 'xy'
	    },
	    title: {
	        text: ''
	    },
	    subtitle: {
	        text: ''
	    },
	    exporting: {enabled: false},
	    credits: chartAPI.credits,
	    xAxis: [{
	        categories: categories,
	        crosshair: true
	    }],
	    yAxis: [{
	        labels: {
	            format: '{value}',
	            style: {color: Highcharts.getOptions().colors[1]}
	        },
	        title: {
	            text: '',
	            style: {color: Highcharts.getOptions().colors[1]}
	        }
	    }, {
	        title: {
	            text: '',
	            style: {color: Highcharts.getOptions().colors[0]}
	        },
	        labels: {
	            format: '{value}',
	            style: {color: Highcharts.getOptions().colors[0]}
	        },
	        opposite: true,
	    }],
	    tooltip: {
	    	formatter: function () {
	    		var rs = ['<b>' + this.x + '</b><br />'].concat(
					this.points ?
						this.points.map(function (point) {
							var str = '';
							if( point.series.name == '<s:message code="dashboard.loggingData.count2"/>') {
								str += '<span style="color:' + point.series.color + '">\u25CF</span> ' + point.series.name + ': ' + point.y.comma() + '(<s:message code="common.msg.cnt"/>)<br />';
							}
							else if(point.series.name == '<s:message code="dashboard.loggingData.attach.size"/>') str += '<span style="color:' + point.series.color + '">\u25CF</span> ' + point.series.name + ': ' + convertFileSize(point.y) + '<br />';
							return str;
						}) : []
				);
	            if(rs != null && rs !=undefined && rs != "") return rs[0] + rs[1] + rs[2];
	            else return [];
	        },
	        shared: true
	    },
	    series: [{
	        name: '<s:message code="dashboard.loggingData.count2"/>',
	        type: 'column',
	        yAxis: 1,
	        data: logging
	    },
	    {
	        name: '<s:message code="dashboard.loggingData.attach.size"/>',
	        type: 'spline',
	        data: attach,
	        visible : visible,
	        showInLegend: visible
	    }]
	});
	
}

var chart2 = null;
var chartxAxis2;
function printHdfsChart( dat )
{
	var data = [];
	var cols = [];
	var categories = [];
	var tMax = [];
	
	if( dat.length == 0) {
		$('#chartArea2').html('<s:message code="common.msg.nodata"/>');
		return false;
	} else {
		for ( var i=0 ; i < dat.length ; i++ ) {
			var items = [];
			items.push(dat[i].date);
			items.push(Number(dat[i].used));
			data.push(items);
			tMax.push(dat[i].total);
		}
	}
	
	var max = tMax.reduce(function(a,b){
		return Math.max(a,b);
	});
	var rotation = 40;
	if ( chartxAxis2 == 'W' ) rotation = 0;
	$('#chartArea2').highcharts({
		chart: {
			type: 'line',
			options3d: {
				enabled: true,
				alpha: 0,
				beta: 0,
				viewDistance: 15,
				depth: 40
			},
			marginTop: 25,
			marginRight: 45
		},
		title: {
			text: null
		},
		exporting: {enabled: false},
		credits: chartAPI.credits,
		xAxis: {
			type: 'category'
		},
		yAxis: {
			allowDecimals: false,
			min: 0,
			max: max,
			title: {
				text: '',
				rotation: 0
			}
		},
		legend: {
	        enabled: false
	    },
		tooltip: {
			formatter: function () {
	            return '<span style="color:' + this.series.color + '">\u25CF</span> ' + convertFileSize(this.point.y);
	        }

		},
		plotOptions: {
		},
		series: [{
			data : data,
			dataLabels: {
	            enabled: true,
	            color: '#000',
	            align: 'center',
	            y: 10, // 10 pixels down from the top
	            style: {
	                fontSize: '11px',
	                fontFamily: 'Gulim, Dotum, Helvetica'
	            },
	            formatter: function () {
		            return convertFileSize(this.point.y);
		        }
	        }
		}]
	});
}

var isDefaultPage = false;

function checkDefaultMenu(){
	var mainLink = $('.topMenuLi:eq(0) .topMenu').attr('href');
	if(menuKey == mainLink.split('=')[1]){
		isDefaultPage = true;
	}
}

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

function makePeriod(dashCondition){
	dashCondition = JSON.parse(dashCondition);

	var startDtSelect = dashCondition.startDateSelect;
	var startTimeSelect = dashCondition.startTimeSelect;
	var endDtSelect = dashCondition.endDateSelect;
	var endTimeSelect = dashCondition.endTimeSelect;
	
	if(startDtSelect == '' || startDtSelect == undefined) return JSON.stringify(dashCondition);
	
	var startMinusDay = 0;
	var endMinusDay = 0;
	if(startDtSelect == 'Y') startMinusDay = 1;
	else if(startDtSelect == 'W') startMinusDay = 7;
	
	if(endDtSelect == 'Y') endMinusDay = 1;
	else if(endDtSelect == 'W') endMinusDay = 7;
	
	var dateObj = new Date();
	var startDate = new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-startMinusDay, startTimeSelect, 00, 00 );
	var endDate = new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-endMinusDay, endTimeSelect, 59, 59 );
	
	dashCondition.startDt = startDate.format('yyyymmddHHnnss');
	dashCondition.endDt = endDate.format('yyyymmddHHnnss');
	return JSON.stringify(dashCondition);
}


var contentData = [];
function getDashBoardContent(){
	ui.get({
		url : 'getDashBoardContentList.xcn',
		useYn : 'Y',
		menuKey : menuKey,
		success : function(data, total) {
			rtnGetDashBoardContent(data);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}
var searchFlag;
var listCnt = 0;
function getDashBoardList(){
	if ( searchFlag ) return false;
	timeoutAllClear();
	
	searchFlag = true;
	ui.get({
		url : 'getDashBoardList.xcn',
		menuKey : menuKey,
		success : function(data, total) {
			listCnt = data.length;
			if(data.length == 0) {
				if(loggingDataSettingVal == 'Y') $('#emptyDiv').hide();
				else $('#emptyDiv').show();
			}
			else $('#emptyDiv').hide();
			
			dashboardGrid.loadGrid(data);
			
			getDashBoardContent();
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			searchFlag = false;
		}
	});
}

function setConditionValStr( val, key ){
	if(val!=null && val != '') return '■ ' + key + ' : ' + val.replaceAll('\\|',',') + '<br />';
	return '';
}

function checkPeriod(startDateSelect, startTimeSelect, endDateSelect, endTimeSelect){
	
}

/**
 *  조건 요약 출력
 */
 function printAlarmValStr( alarmCycle, alarmVal, rtnType )
 {
 	var searchStr  = '';
 	console.log('알람: '+JSON.stringify(alarmVal));
 	var searchDateStr = '';
 	if ( alarmVal.startDateSelect == 'Y' ) searchDateStr += '<s:message code="condition.yesterday_str"/> ';
 	else if ( alarmVal.startDateSelect == 'T' ) searchDateStr += '<s:message code="condition.today_str"/> ';
 	else if ( alarmVal.startDateSelect == 'W' ) searchDateStr += '<s:message code="condition.sevenago"/> ';
 	searchDateStr += '<s:message code="condition.clock" arguments="'+alarmVal.startTimeSelect+'" />';
 	searchDateStr += ' ~ ';
 	if ( alarmVal.endDateSelect == 'Y' ) searchDateStr += '<s:message code="condition.yesterday_str"/> ';
 	else if ( alarmVal.endDateSelect == 'T' ) searchDateStr += '<s:message code="condition.today_str"/> ';
 	else if ( alarmVal.endDateSelect == 'W' ) searchDateStr += '<s:message code="condition.sevenago"/> ';
 	searchDateStr += '<s:message code="condition.time" arguments="'+alarmVal.endTimeSelect+',59,59" />';
 	
 	if(alarmCycle != 'H') searchStr = setConditionValStr( searchDateStr, '<s:message code="condition.period"/>');
 	else searchStr = setConditionValStr( '<s:message code="mail.message.condition_info"/>', '<s:message code="condition.period"/>');
 	
 	if(alarmVal.searchStr != '') searchStr += setConditionValStr( alarmVal.searchStr, '<s:message code="condition.search_str"/>' );
 	
 	if(alarmVal.searchField != '') searchStr += setConditionValStr( alarmVal.serviceFieldNm, '<s:message code="condition.field.search"/>' );
 	
 	if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ) {
		if(alarmVal.infoType != '') searchStr += setConditionValStr( alarmVal.infoTypeNm, '<s:message code="condition.infotype"/>' );
		if(alarmVal.feedbackType != '') searchStr += setConditionValStr( alarmVal.feedbackTypeNm, '<s:message code="condition.feedback"/>' );
		if(alarmVal.probType != '') searchStr += setConditionValStr( alarmVal.probTypeNm, '<s:message code="condition.prob"/>' );
	}
 	
 	var readYnMsg = '';
 	if ( alarmVal.readYn == 'Y' ) readYnMsg = '<s:message code="condition.read"/>';
 	else if ( alarmVal.readYn == 'N' ) readYnMsg = '<s:message code="condition.unread"/>';
 	if(readYnMsg!='') searchStr += setConditionValStr( readYnMsg, '<s:message code="condition.isread"/>');
 	
 	var receiveSendMsg = '';
 	if ( alarmVal.receiveSend == 'O' ) receiveSendMsg = '<s:message code="condition.send"/>';
 	else if ( alarmVal.receiveSend == 'I' ) receiveSendMsg = '<s:message code="condition.receive"/>';
 	if(receiveSendMsg!='') searchStr += setConditionValStr( receiveSendMsg, '<s:message code="condition.receive_send"/>');
 	
 	var ctimeWorkMsg = '';
 	if ( alarmVal.ctimeWork == 'W' ) ctimeWorkMsg = '<s:message code="condition.work"/>';
 	else if ( alarmVal.ctimeWork == 'R' ) ctimeWorkMsg = '<s:message code="condition.notwork"/>';
 	if(ctimeWorkMsg!='') searchStr += setConditionValStr( ctimeWorkMsg, '<s:message code="condition.ctimework"/>');
 	
 	if(alarmVal.serviceType != '') searchStr += setConditionValStr( alarmVal.serviceTypeNm, '<s:message code="filterInfo.servicetype"/>' );
 	if(alarmVal.senders!='') searchStr += setConditionValStr( alarmVal.senders, '<s:message code="condition.sender"/>', alarmVal.senders_not);
 	if(alarmVal.receivers!='') searchStr += setConditionValStr( alarmVal.receivers, '<s:message code="condition.recv"/>', alarmVal.receivers_not);
 	
 	if(alarmVal.rcvTo!='') searchStr += setConditionValStr( alarmVal.rcvTo, '<s:message code="condition.to"/>', alarmVal.rcvTo_not);
 	if(alarmVal.rcvCc!='') searchStr += setConditionValStr( alarmVal.rcvCc, '<s:message code="condition.cc"/>', alarmVal.rcvCc_not);
 	if(alarmVal.rcvBcc!='') searchStr += setConditionValStr( alarmVal.rcvBcc, '<s:message code="condition.bcc"/>', alarmVal.rcvBcc_not);
 	if(alarmVal.rcvJikgub!='') searchStr += setConditionValStr( alarmVal.rcvJikgub, '<s:message code="condition.recv_jikgub"/>');
 	if(alarmVal.allOfus!='') searchStr += setConditionValStr( alarmVal.allOfus, '<s:message code="condition.allofus"/>');
 	
 	if(alarmVal.busi != '') searchStr += setConditionValStr( alarmVal.busiNm, '<s:message code="common.org.busi"/>', alarmVal.busi_not);
 	if(alarmVal.dept != '') searchStr += setConditionValStr( alarmVal.deptNm, '<s:message code="common.org.dept"/>', alarmVal.dept_not);
 	if(alarmVal.userGroupSeq != '') searchStr += setConditionValStr( alarmVal.userGroupName, '<s:message code="userGroup.navi.title2"/>', alarmVal.userGroupSeq_not);
 	if(alarmVal.interGroup != '') searchStr += setConditionValStr( alarmVal.interGroupNm, '<s:message code="interest.user"/>', alarmVal.interGroup_not );
 	if(alarmVal.url != '') searchStr += setConditionValStr( alarmVal.url, 'URL', alarmVal.url_not);
 	
 	var attachYnMsg = '';
 	if ( alarmVal.attachYn == 'Y' ) attachYnMsg = '<s:message code="condition.exist"/>';
 	else if ( alarmVal.attachYn == 'N' ) attachYnMsg = '<s:message code="condition.none"/>';
 	if(attachYnMsg!='') searchStr += setConditionValStr( attachYnMsg, '<s:message code="condition.isattached"/>');
 	if(alarmVal.attachVal!='') searchStr += setConditionValStr( alarmVal.attachVal, '<s:message code="consent.attach"/>', alarmVal.attachYn_not);
 	
 	var keywordYnMsg = '';
 	if ( alarmVal.keywordYn == 'Y' ) keywordYnMsg = '<s:message code="condition.exist"/>';
 	else if ( alarmVal.keywordYn == 'N' ) keywordYnMsg = '<s:message code="condition.none"/>';
 	if(keywordYnMsg!='') searchStr += setConditionValStr( keywordYnMsg, '<s:message code="condition.iskeyword"/>');
 	if(alarmVal.keywordVal!='') searchStr += setConditionValStr( alarmVal.keywordStr, '<s:message code="condition.keyword"/>', alarmVal.keywordYn_not);
 	
 	var epmsg='';
 	if(alarmVal.epmsgType !='') searchStr += setConditionValStr (alarmVal.epmsgType, '<s:message code="condition.epmsgType.list"/>');
 	
 	var regexpYnMsg = '';
 	if ( alarmVal.regexpYn == 'Y' ) regexpYnMsg = '<s:message code="condition.exist"/>';
 	else if ( alarmVal.regexpYn == 'N' ) regexpYnMsg = '<s:message code="condition.none"/>';
 	if(regexpYnMsg!='') searchStr += setConditionValStr( regexpYnMsg, '<s:message code="condition.regexp.isdetect"/>');
 	if(alarmVal.regexpVal!='') searchStr += setConditionValStr( alarmVal.regexpStr, '<s:message code="condition.regexp.detect"/>' );
 	
 	if(alarmVal.drmYn=='Y') searchStr += setConditionValStr( '<s:message code="condition.exist"/>' , 'DRM');
 	else if(alarmVal.drmYn=='N') searchStr += setConditionValStr( '<s:message code="condition.none"/>', 'DRM' );
 	
 	if(alarmVal.sctYn=='Y') searchStr += setConditionValStr( '<s:message code="condition.exist"/>' , '<s:message code="condition.sct"/>');
 	else if(alarmVal.sctYn=='N') searchStr += setConditionValStr( '<s:message code="condition.none"/>', '<s:message code="condition.sct"/>' );
 	
 	var msgSize = '';
 	if(alarmVal.sizeStartVal != '')
 	{
 		if(alarmVal.sizeOption == 'B') msgSize = convertFileSize(alarmVal.sizeStartVal) + ' ~ ' + convertFileSize(alarmVal.sizeEndVal);
 		else 
 		{
 			msgSize = convertFileSize(alarmVal.sizeStartVal);
 			if(alarmVal.sizeOption == 'L') msgSize += '<s:message code="condition.over"/>';
 			else if(alarmVal.sizeOption == 'S') msgSize += '<s:message code="condition.below"/>';
 		}
 	}
 	var rtnMsg = '<s:message code="condition.size.all"/>';
 	if( alarmVal.sizeType =='B') rtnMsg = '<s:message code="condition.size.body"/>';
 	else if( alarmVal.sizeType =='A') rtnMsg = '<s:message code="condition.size.attach"/>';
 	
 	if(msgSize!='') searchStr += setConditionValStr( msgSize, rtnMsg );
 	
 	if( rtnType == undefined) $('#alarmValStr').val(searchStr);
 	else return searchStr;
 }

function rtnGetDashBoardContent(data){
	contentData = data;
	var str = '';
	var lineCnt = 4;  // 2,3,4,6 가능
	for(var i=0; i<data.length; i++){
		var dashKey = data[i].dashKey;
		var dashName = data[i].dashName;
		var dashType = data[i].dashType;
		var dashMultiLeft = data[i].dashMultiLeft;
		var dashMultiRight = data[i].dashMultiRight;
		var dashChart = data[i].dashChart;
		var dashChartX = data[i].dashChartX;
		var dashChartY = data[i].dashChartY;
		var dashIcon = data[i].dashIcon;
		var dashColor = data[i].dashColor;
		var dashComment = data[i].dashComment;
		
		var dashTypeMsg = '';
		var dashChartMsg = '';
		if(dashType == 'S') dashTypeMsg = '<s:message code="custom.single"/>';
		else if(dashType == 'D') dashTypeMsg = '<s:message code="custom.double"/>';
		else if(dashType == 'C'){
			dashTypeMsg = '<s:message code="custom.chart"/>';
			if(dashChart =='P') dashTypeMsg += '(<s:message code="custom.pieChart"/>)';
			else if(dashChart =='L') dashTypeMsg += '(<s:message code="custom.lineChart"/>)';
			else if(dashChart =='A') dashTypeMsg += '(<s:message code="custom.areaChart"/>)';
			else if(dashChart =='B') dashTypeMsg += '(<s:message code="custom.barChart"/>)';
		}
		else if(dashType == 'L') dashTypeMsg = '<s:message code="custom.list"/>';
		
		
		if(i==0 || i%lineCnt == 0 ){
			var className = '';
			if( i==0) className = 'active';
			str += '<div class="item '+className+'">';
			str += '	<div class="row" style="margin-right: -5px;margin-left: -5px;">';
		}
		str += '		<div class="col-md-'+(12/lineCnt)+'">';
		str += '			<a class="addDashboardContent" data-index="'+i+'" href="javascript:;">';
		/* str += '				<h3>'+dashName+'</h3>';
		str += '				<div>'+dashComment+'</div>';
		str += '				';
		str += '				'; */
		
		str += '<div class="card card-1">';
		str += '	<h4><i class="'+data[i].dashIcon+'"></i>&nbsp;'+dashName+'</h4>';
		str += '	<p>'+dashComment+'</p>';
		str += '	<div>'+dashTypeMsg+'</div>';
		str += '	<div style="position: absolute; top: 95px; right: 20px;"><button type="button" class="btn btn-default btn-xs conditionView" ><s:message code="dashboard.conditionView"/></button></div>';
		//str += '	<div><span class="btn '+dashColor+'">&nbsp;&nbsp;</span></div>';
		str += '</div>';
		
		str += '			</a>';
		str += '		</div>';
		
		if(i%lineCnt == (lineCnt-1) || i == data.length-1){
			str += '	</div>';
			str += '</div>';
		}
	}
	if(data.length == 0){
		$('#selectDashMenu .left').hide();
		$('#selectDashMenu .right').hide();
		
		str += '<div id="emptyDashboard" class="empty-dashboard-message">';
		str += '	<h3><s:message code="custom.msg.noData"/></h3>';
		str += '	<p><s:message code="custom.msg.newData"/></p>';
		str += '	<p style="margin:3px;"><a class="btn customBtn" href="<c:url value="/ems/dashboardSetup.do"/>"><s:message code="DATA_MONITOR.DASHBOARD_SETUP"/></a></p>';
		if(isDefaultPage) str += '	<p><a class="btn customBtn" href="javascript:;" id="addDefaultData"><s:message code="custom.addDefault"/></a></p>';
		str += '</div>';
		
		
		
	}else{
		$('#selectDashMenu .left').show();
		$('#selectDashMenu .right').show();
	}
	
	$('#dashboardHeaderArea').html(str);
	
	$('#selectDashMenu').carousel({
		pause: true,
		interval: false,
	});
}

function saveDashboardList(data){
	ui.postJson({
		url :'saveDashBoard.xcn',
		data : JSON.stringify(data),
		menuName : $('.navi').html(),
		menuKey : menuKey,
		success : function ( data, total ) {
			ui.alertMsg('<s:message code="common.msg.saved"/>');
			getDashBoardList();
		},
		error : function (status, message) {
			ui.alertMsg(message);
		},
		complete : function (){
			
		}
	});
}

function getDashPosition(dashKey, dashType, dashChart){
	var id = menuKey+'_'+dashKey;
	if(dashType == 'S'){
		return {x: 0, y: 0, width: 2, height: 2, minWidth: 2, minHeight: 2, maxWidth: 3, maxHeight: 2, id:id};
	}else if(dashType == 'D'){
		return {x: 0, y: 0, width: 3, height: 2, minWidth: 3, minHeight: 2, maxWidth: 4, maxHeight: 2, id:id};
	}else if(dashType == 'C'){
		if( dashChart == 'P'){
			return {x: 0, y: 0, width: 4, height: 4, minWidth: 4, minHeight: 4, maxWidth: 6, maxHeight: 6, id:id};	
		}else {
			return {x: 0, y: 0, width: 5, height: 4, minWidth: 5, minHeight: 4, maxWidth: 10, maxHeight: 5, id:id};
		}
	}else if(dashType == 'L'){
		return {x: 0, y: 0, width: 5, height: 4, minWidth: 5, minHeight: 3, maxWidth: 6, maxHeight: 8, id:id};
	}else{
		return {x: 0, y: 0, width: 3, height: 2, id:id};
	}
}

function getDashData(){
	return [];
	/* return [
			{x: 0, y: 0, width: 2, height: 2, minWidth: 2, minHeight: 2, maxWidth: 3, maxHeight: 2, id:'', html:$('#singleDataFormat').html()},
			{x: 3, y: 0, width: 3, height: 2, minWidth: 3, minHeight: 2, maxWidth: 4, maxHeight: 2, id:'', html:$('#dualDataFormat').html()},
			{x: 6, y: 0, width: 4, height: 4, minWidth: 4, minHeight: 4, maxWidth: 6, maxHeight: 6, id:'', html:$('#pieChartDataFormat').html()},
			{x: 0, y: 2, width: 5, height: 4, minWidth: 4, minHeight: 3, maxWidth: 6, maxHeight: 8, id:'', html:$('#listDataFormat').html()},
			{x: 0, y: 6, width: 5, height: 4, minWidth: 5, minHeight: 4, maxWidth: 10, maxHeight: 5, id:'', html:$('#lineChartDataFormat').html()},
			{x: 6, y: 8, width: 3, height: 2, id:'', html:$('#emptyDataFormat').html()}
		]; */
}
var dashboardGrid;
function dashboardInit(){
	var options = {
		acceptWidgets:true,
		cellHeight: 60, //or 80 - default : 60
		verticalMargin: 10,
		alwaysShowResizeHandle:true,
		resizable:{
			autoHide: false, 
			handles: 'e, s, w, se, sw' //n, e, s, w, ne, se, sw, nw, all
		}
	};
	
	$('#dashboardArea').gridstack(options);
	
	var grid = $('#dashboardArea').data('gridstack');
	
	dashboardGrid = new function () {
		var obj = this;
		
		this.serializedData;

		this.grid = $('#dashboardArea').data('gridstack');
		
		this.loadGrid = function (data) {
			this.serializedData = data;
			
			obj.grid.removeAll();
			var items = GridStackUI.Utils.sort(this.serializedData);

			_.each(items, function (node) {
				obj.grid.addWidget(setDateHtml(node), node.x, node.y, node.width, node.height, null, node.minWidth, node.maxWidth, node.minHeight, node.maxHeight, node.id);
			}, this);
			
			grid.movable('.grid-stack-item', false);
			grid.resizable('.grid-stack-item', false);
			
			this.on('all');
			getData(data);
			return false;
		}.bind(this);
		
		this.on = function (id) {
			var hasFlag = false;
			
			this.serializedData = _.map($('#dashboardArea > .grid-stack-item:visible'), function (el) {
				el = $(el);
				var node = el.data('_gridstack_node');
				var target = node.id;
				if( node.id == id || id == 'all'){
					var hei = el.height();
					el.append( '<div class="loading_div"><i class="fa fa-spinner fa-spin fa-3x fa-fw" style="margin-top:'+(hei/2.5)+'px"></i></div>');
					$('.loading_div').css({
						"position" : "absolute",
						"top" : "0px",
						"left" : "10px",
						"right" : "10px",
						"bottom" : "0",
						"background-color" : "#F0F0F0",
						"opacity" : "0.3",
						"z-index" : "998",
						"text-align" : "center"
					});
				}
			}, this);
			
			return false;
			
		}.bind(this);
		
		this.off = function (id) {
			var hasFlag = false;
			
			this.serializedData = _.map($('#dashboardArea > .grid-stack-item:visible'), function (el) {
				try{
					el = $(el);
					var node = el.data('_gridstack_node');
					var target = node.id;
					if( node.id == id || id == 'all'){
						var obj = el.find('.loading_div');
						obj.remove();
					}
				}catch(e){}
			}, this);
			
			return false;
			
		}.bind(this);
		
		

		this.saveGrid = function () {
			this.serializedData = _.map($('#dashboardArea > .grid-stack-item:visible'), function (el) {
				el = $(el);
				var node = el.data('_gridstack_node');
				return {
					x: node.x,
					y: node.y,
					width: node.width,
					height: node.height,
					minWidth: node.minWidth, 
					minHeight: node.minHeight, 
					maxWidth: node.maxWidth, 
					maxHeight: node.maxHeight,
					id: node.id,
					dashKey : el.find('.gridValues').attr('data-dashKey')
				};
			}, this);
			
			saveDashboardList(this.serializedData);
			return false;
			
		}.bind(this);

		this.clearGrid = function () {
			this.grid.removeAll();
			return false;
		}.bind(this);
		
		this.addWidget = function (node) {
			this.grid.addWidget(node.html, node.x, node.y, node.width, node.height, true, node.minWidth, node.maxWidth, node.minHeight, node.maxHeight, node.id);
			return false;
		};
		
		this.deleteWidget = function (item) {
			this.grid.removeWidget(item);
			return false;
		};

		getDashBoardList();
	};
	
	$('#dashboardArea').on('change', function(event, items) {
		console.log("change!!!!!!!!!!")
	});
	
	$('#dashboardArea').on('gsresizestop', function(event, elem) {
		console.log("resize end!!!!!!!!!!")
	});
	
	$(document).on('click', '.customClose', function(event, elem){
		dashboardGrid.deleteWidget($(this).parents('.grid-stack-item'));
	});
	
}

function setDateHtml(node){
	var dashCondition = JSON.parse(makePeriod(node.dashCondition));	
	
	var startDtSelect = dashCondition.startDateSelect;
	var endDtSelect = dashCondition.endDateSelect;
	
	var startDt = dashCondition.startDt;
	var endDt = dashCondition.endDt;

	var startDtStr = startDt.substring(0, 4) +'-'+ startDt.substring(4, 6) +'-'+ startDt.substring(6, 8)+' '+startDt.substring(8, 10) + ':'+startDt.substring(10, 12)+':'+startDt.substring(12, startDt.length);
	var endDtStr = endDt.substring(0, 4) +'-'+ endDt.substring(4, 6) +'-'+ endDt.substring(6, 8)+' '+endDt.substring(8, 10) + ':'+endDt.substring(10, 12)+':'+endDt.substring(12, startDt.length);
	var dateMsg = '<s:message code="custom.today"/>';
	if( startDtSelect == 'Y' ){
		dateMsg = '<s:message code="custom.yesterday"/>';
		if( endDtSelect == 'T' ) dateMsg += '~<s:message code="custom.today"/>';
	}
	
	var obj = $(node.html);
	obj.find('.termDtStr').attr('title', startDtStr + ' ~ '+endDtStr).text(dateMsg);
	
	return $('<div>').append(obj.clone()).html();
}

var loggingDataSettingVal;
function getLoggingDataSetting(){
	var loggingchartArea = $('#chartArea1').parent().parent().parent();
	var loggingChartTable = $('#loggingDataTable').parent().parent().parent();
	
	ui.get({
		url : 'getLoggingDataSetting.xcn',
		success : function(data, total) {
			loggingDataSettingVal = data;
			
			if(editMode == 'Y') {
				if(loggingDataSettingVal == 'Y') {
					$('#dashboardInfo').show();
					$('#dashboardInfo').css('margin-top','200px');
					$('#dashboardArea').css('top','-10px');
					getLoggingData();
					if(systemArch == 'multiple' && adminType == 'M'){
// 						$('#tableRow').append($('#chartRow'));
						loggingChartTable.after(loggingchartArea);
						$('#chartRow').css('top','');
						$('#tableLoading').css('height', '165px');
					}else{
						getHdfsData();						
					}
				}
				else {
					$('#dashboardInfo').hide();
					$('#dashboardArea').css('top','200px');
				}
			} else {
				if(loggingDataSettingVal == 'Y') {
					$('#dashboardInfo').show();
					$('#dashboardInfo').css('margin-top','25px');
					$('#dashboardArea').css('top','-10px');
					getLoggingData();
					if(systemArch == 'multiple' && adminType == 'M'){
						loggingChartTable.after(loggingchartArea);
						$('#chartRow').css('top','');
						$('#tableLoading').css('height', '165px');
					}else{
						getHdfsData();						
					}
					$('#emptyDiv').hide();
				}
				else {
					$('#dashboardInfo').hide();
					$('#dashboardArea').css('top','25px');
					if(listCnt == 0)  $('#emptyDiv').show();
				}
			}
		},
		error : function(status, message) {
			console.log(message);
		},
		complete : function() {
		}
	});
}

function getLoggingData(){
	ui.get({
		url : 'getLoggingData.xcn',
		date : $('#startdate').val(),
		systemArch : systemArch,
		success : function(data, total) {
			makeTableLoggingData(data.data);
			printChart(data.data);
		},
		error : function(status, message) {
			console.log(message);
		},
		complete : function() {
		}
	});
}

function makeTableLoggingData(data){
	var str = '<tr><th class="tCenter" style="width: 200px;"><s:message code="common.msg.separator"/></th>';
	for (var i = 0; i < data.length; i++) {
		str += '<th class="tCenter">' + getDateFormatSize(data[i].date) + '</th>';
	}
	str += '</tr>';
	str += '<tr><th class="tCenter"><s:message code="dashboard.loggingData.count2"/></th>';
	for (var i = 0; i < data.length; i++) {
		str += '<td class="tRight">' + nvn(data[i].logging).comma() + '</td>'; 
	}
	str += '</tr>';
	if(systemArch == 'standalone' || (systemArch == 'multiple' && adminType != 'M')){
		str += '<tr><th class="tCenter"><s:message code="dashboard.loggingData.attach.size"/></th>';
		for (var i = 0; i < data.length; i++) {
			str += '<td class="tRight">' + convertFileSize(data[i].attach) + '</td>'; 
		}
		str += '</tr>';		
	}
	if(data.length == 0) $('#loggingDataTable').css('border','0px');
	$('#loggingDataTable').html(data.length > 0 ? str : '<s:message code="common.msg.nodata"/>');
}

function getHdfsData(){
	ui.get({
		url : 'getHdfsData.xcn',
		success : function(data, total) {
			makeTableHdfsData(data);
			printHdfsChart(data);
		},
		error : function(status, message) {
			console.log(message);
		},
		complete : function() {
		}
	});
}

function makeTableHdfsData(data){
	var col1 = '<tr><th class="tCenter"><s:message code="common.msg.separator"/></th>';
	var col2 = '<tr><th class="tCenter">Remaining</th>';
	var col3 = '<tr><th class="tCenter">Used</th>';
	var col4 = '<tr><th class="tCenter">Total</th>';
	var col5 = '<tr><th class="tCenter">Used(%)</th>';
	var rs = '';
	
	for (var i = 0; i < data.length; i++) {
		col1 += '<th class="tCenter">' + data[i].date + '</th>';
		col2 += '<td class="tRight">' + convertFileSize(data[i].remaining) + '</td>';
		col3 += '<td class="tRight">' + convertFileSize(data[i].used) + '</td>';
		col4 += '<td class="tRight">' + convertFileSize(data[i].total) + '</td>';
		col5 += '<td class="tRight">' + data[i].usedP + '%</td>';
	}
	col1 += '</tr>';
	col2 += '</tr>';
	col3 += '</tr>';
	col4 += '</tr>';
	col5 += '</tr>';
	
	rs = col1 + col2 + col3 + col4 + col5;
	
	$('#hdfsDataTable').html(rs);
}


function getData(data){
	for(var i=0; i<data.length; i++){
		getSearchData(i, data[i]);
	}
}
var timeoutArr = [];
function getSearchData(i, obj){
	timeout_clear( timeoutArr[i] );
	
	var plusTime = i*200;
	setTimeout(function(){
		ui.get({
			url : 'getDashBoardContentData.xcn',
			dashKey : obj.dashKey,
			success : function(data, total) {
				rtnGetSearchData(data.data, obj);
				
				timeoutArr[i] = setTimeout(function(){
					getSearchData(i, obj);
				}, 3600000);
				
			},
			error : function(status, message) {
				console.log(message);
			},
			complete : function() {
			}
		});
	}, plusTime);
}

function rtnGetSearchData(data, obj){
	if(obj.dashType == 'S'){
		$('[data-gs-id='+obj.id+']').find('.rightValue').text(nvn(data.rightValue));
	}else if(obj.dashType == 'D'){
		$('[data-gs-id='+obj.id+']').find('.rightValue').text(nvn(data.rightValue));
		$('[data-gs-id='+obj.id+']').find('.leftValue').text(nvn(data.leftValue));
	}else if(obj.dashType == 'C'){
		if(obj.dashChart == 'P') setPieChart($('[data-gs-id='+obj.id+'] .dashChartArea'), data.chartData);
			else {
				var rtnType = '';
				if(obj.dashChart=='L'){
					rtnType='line';
				}else if(obj.dashChart=='A'){
					rtnType='area';
				}else if(obj.dashChart=='B'){
					rtnType='column'
				}
				setChart($('[data-gs-id='+obj.id+'] .dashChartArea'), data.chartData, rtnType);
				if($('[data-gs-id='+obj.id+'] .dashChartArea').data('data-charttype') != 'P'){
					var chartXPosition = $('[data-gs-id='+obj.id+'] .dashChartArea').find('.highcharts-yaxis-title').attr('x');
					$('[data-gs-id='+obj.id+'] .dashChartArea').find('.highcharts-yaxis-title').attr('x',chartXPosition-10);
				}
			}
	}else if(obj.dashType == 'L'){
		setDashDataList($('[data-gs-id='+obj.id+'] .dashTableTbody'), data.edc, $('[data-gs-id='+obj.id+']').attr('data-gs-width'), $('[data-gs-id='+obj.id+']').attr('data-gs-height'));
	}
	dashboardGrid.off(obj.id);
}

function setPieChart(obj, data){
	if($(obj).highcharts() != undefined){
		$(obj).html('');
	}
	$(obj).highcharts({
		chart: {
			plotBackgroundColor: null,
			plotBorderWidth: null,
			plotShadow: false,
			type: 'pie'
		},
		exporting : {
			enabled: false
		},
		credits: chartAPI.credits,
		title : {
			text : ''
		},
		subtitle: {
			text: ''
		},
		tooltip: {
			pointFormat: '{series.name}: <b>{point.y:,.0f}<s:message code="common.msg.cnt"/> ({point.percentage:.1f}%)</b>'
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
			},
			series: {
				animation: {
				duration: 1000
				}
			}
		},
		series: [{
			name: '<s:message code="dashboard.rate"/>',
			colorByPoint: true,
			data: data
		}]
	});
}
function setChart(obj, data, type){
	if($(obj).highcharts() != undefined){
		$(obj).html('');
	}
	
	var dlength = data.length;
	var allDataZeroSig = 0;
	
	for (var i = 0; i < dlength; i++) {
		if(data[i].y == null){
			data[i].y = 0;
			allDataZeroSig++;
		}
	}
	
	$(obj).highcharts({
		chart: {
			type: type,
			options3d: {
				enabled: true,
				alpha: 10,
				beta: 0,
				depth: 50,
				viewDistance: 25
			}
		},
		exporting: chartAPI.exporting,
		credits: chartAPI.credits,
		title: {
		    text: ''
		},
		xAxis: {
			type: 'category',
			labels: {
				rotation: -20,
				x: 20,
				y: (dlength == allDataZeroSig) ? -60 : undefined,
				style: {
					fontSize: '13px',
					fontFamily: 'DINLig, Verdana, sans-serif'
				},
			},gridLineWidth: 0
		},
		yAxis: {
			labels:{
				formatter: function () {
					var label = this.axis.defaultLabelFormatter.call(this);
					if(label < 1) {
						return Highcharts.numberFormat(this.value, 0);
					}
					else{
						if (/^[0-9]{4}$/.test(label)) return Highcharts.numberFormat(this.value, 0);
						return label;	
					}
				}
			},
			type: 'line',
			min:0,
			title: {
				text: '(<s:message code="common.msg.count"/>)',
				x: -20,
				y: 20,
				rotation: 0
			}
		},
		legend: {
			enabled: false
		},
		tooltip: {
			pointFormat: '<s:message code="dashboard.collect.data_count"/> : <b>{point.y:,.0f} (<s:message code="common.msg.cnt"/>)</b>'
		},
		plotOptions: {
			series: {
				animation: {
				duration: 1000
				}
			}
		},
		series: [{
			name: 'chart',
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

function setDashDataList(obj, data, width, height){
	var dataLength = height*2-3;
	if( dataLength > 13) dataLength = 13;
	
	var subjectWidth = 25;
	if( width == 6) subjectWidth = 40;
	
	var str ='';
	for(var i=0; i<data.emass.length; i++){
		if(i == dataLength) break;
		
		str += '<tr>';
		str += '	<td><i class="bodyOpenBtn fa fa-window-restore" aria-hidden="true" data-msgid="'+data.emass[i].msgid+'"></i></td>';
		
		var ctime = data.emass[i].ctimeFormat;
		var spCtime = ctime.substring(ctime.indexOf('-')+1, ctime.length);
		str += '	<td>'+spCtime+'</td>';
		
		var svcNm = data.emass[i].svcNm;
		var dpSvcNm = svcNm.substring(0, svcNm.indexOf('>'));
		str += '	<td>'+dpSvcNm+'</td>';

		var subject = data.emass[i].subject;
		var addData = '';
		if(subject.length > subjectWidth) addData = '...';
		str += '	<td title="'+subject+'">'+(data.emass[i].subject).substring(0, subjectWidth)+addData+'</td>';
		str += '</tr>';
	}
	
	if(data.emass.length == 0){
		str += '<tr>';
		str += '<td colspan="4" style="text-align:center;">';
		str += '<s:message code="common.msg.nodata"/>';
		str += '</td>';
		str += '</tr>';
	}
										
	$(obj).html(str);
}

function timeout_clear( setTime )
{
	if ( setTime != undefined ) clearTimeout(setTime);
	return undefined;
}
function timeoutAllClear(){
	for(var i=0; i<timeoutArr.length; i++){
		timeout_clear(timeoutArr[i]);
	}
	
}

var size;
function fileSize(){
	date = $('#fileSizeDate').val();
	ui.get({
		url : 'getFilSizeData.xcn',
		date : date,
		success : function(data, total) {
			size=data;
			makeFileSizeTable(data);
		},
		error : function(status, message) {
			console.log(message);
		},
		complete : function() {
		}
	});
	return size;
}

function makeFileSizeTable(data){
	var col1 = '<tr><th class="tCenter">No.</th>';
	var col2 = '';
	var rs = '';
	
	col1 += '<th class="tCenter"><s:message code="condition.source"/> IP</th>';
	col1 += '<th class="tCenter"><s:message code="condition.destination"/> IP</th>';
	col1 += '<th class="tCenter">URL</th>';
	col1 += '<th class="tCenter" ><s:message code="filterInfo.size"/></th>';
	
	if( data.length == 0){
		col2 += '<tr>';	
		col2 += '<td colspan="5" class="Center"> <s:message code="custom.msg.noData"/> </td>';
		col2 += '</tr>';
	}else{
		for (var i = 0; i < data.length; i++) {
			col2 += '<tr> <th class="tCenter">'+ (i+1) +'</th>';				
			col2 += '<td class="Center">' + data[i].srcIp + '</td>';
			col2 += '<td class="Center">' + data[i].dstIp + '</td>';
			col2 += '<td class="Left">' + data[i].host + '</td>';
			col2 += '<td id="'+ (i) +'" class="Center" style ="text-decoration:underline; color:blue; cursor: pointer">' + convertFileSize(data[i].size) + '</td>';
			col2 += '</tr>';
		}
	}
	col1 += '</tr>';
	rs = col1 +col2;
	
	$('#fileSize').html(rs);
}

var count;
function fileCount(){
	date = $('#fileCountDate').val();
	ui.get({
		url : 'getFileCount.xcn',
		date : date,
		success : function(data, total) {
			count=data;
			makeFileCountTable(data);
		},
		error : function(status, message) {
			console.log(message);
		},
		complete : function() {
		}
	});
	return count;
}

function makeFileCountTable(data){
	var col1 = '<tr><th class="tCenter">No.</th>';
	var col2 = '';
	var rs = '';
	
	col1 += '<th class="tCenter"><s:message code="condition.source"/> IP </th>';
	col1 += '<th class="tCenter"><s:message code="condition.destination"/> IP</th>';
	col1 += '<th class="tCenter">URL</th>';
	col1 += '<th class="tCenter"><s:message code="common.msg.count"/></th>';
	
	if( data.length == 0){
		col2 += '<tr>';	
		col2 += '<td colspan="4" class="Center"> <s:message code="custom.msg.noData"/>  </td>';
		col2 += '</tr>';
	}else{
		for (var i = 0; i < data.length; i++) {
			col2 += '<tr> <th class="tCenter">'+ (i+1) +'</th>';	
			col2 += '<td class="Center">' + data[i].srcIp + '</td>';
			col2 += '<td class="Center">' + data[i].dstIp + '</td>';
			col2 += '<td class="tLeft">' + data[i].host + '</td>';
			col2 += '<td class="Center" id="'+ i +'" style ="text-decoration:underline; color:blue; cursor: pointer">'+ nvn( data[i].statCnt).comma() +'</td>';	
			col2 += '</tr>';
		}
	}
	col1 += '</tr>';
	rs = col1 +col2;
	
	$('#fileCount').html(rs);
}

function checkMonitorDB(){
	ui.get({
		url:"checkMonitorDB.xcn",
		success: function(data, total) {
			if(data == 1) {
				fileSize();
				fileCount();
			} else {
				$("#monitorRow").hide();
			}
		},
		error: function(status, msg) {
			
		},
		complete:function(){
			
		}
	});
}

</script>
</head>
<body class="mini-navbar">
	<div id="conditionViewDiv">
		<div style="height:30px;background-color:#1576A1;color:#fff;padding-left:10px;line-height:30px;font-weight: bold;cursor:default;">
			<div style="float:left;width:120px;">
				<i class="glyphicon glyphicon-question-sign"></i>&nbsp;<s:message code="dashboard.conditionView"/>
			</div>
		</div>
		<div style="width:100%;padding:10px 10px 10px 10px;">
			<div>
				<div id="conditionViewContent"></div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="loggingDataPop" tabindex="-1" role="dialog" aria-labelledby="loggingDataModal">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="dashboard.loggingData.show"/></h3>
				</div>
				<div class="modal-body" style="height:120px;">
					<div class="col-sm-12">
						<span class="help-block m-b-none"><s:message code="dashboard.msessage.setting"/></span>
					</div>
					<div class="col-sm-12">
						<select id="loggingDataUseYn" class="form-control m-b">
							<option value="Y"><s:message code="dashboardMenu.use"/></option>
							<option value="N"><s:message code="dashboardMenu.unuse"/></option>
						</select>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary" accesskey="S" id="loggingDataSaveBtn"><s:message code="common.msg.change"/></button>
				</div>
			</div>
		</div>
	</div>
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
	<div class="container">
		<div class="dashboardBtnArea" style="z-index:1000;">
			<div class="btn-group">
				<button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown">
					<span class="fa fa-file-text-o"></span>&nbsp;<s:message code="custom.work"/> <span class="caret"></span>
				</button>
				<ul class="dropdown-menu dropdown-menu-right" role="menu" style="min-width:120px;">
					<li><a href="javascript:;" id="editDashboardBtn"><span class="fa fa-file-text-o" style="font-size:16px"></span>&nbsp;<s:message code="dashboardSetup.addModify"/></a></li>
					<li><a href="javascript:;" id="menuDefaultSetupBtn"><span class="fa fa-file-text-o" style="font-size:16px"></span>&nbsp;<s:message code="dashboardMenu.defaultMenu"/></a></li>
					<li><a href="javascript:;" id="menuLoggingBtn"><span class="fa fa-file-text-o" style="font-size:16px"></span>&nbsp;<s:message code="dashboard.loggingData.show"/></a></li>
					<li class="dropdown-divider"></li>
					<li><a href="javascript:;" id="setupDashboardBtn"><span class="glyphicon glyphicon-th-list"></span>&nbsp;<s:message code="DATA_MONITOR.DASHBOARD_SETUP"/></a></li>
				</ul>
			</div>
		</div>
		<div class="dashboardHeader" style="display:none; z-index: 999; position: absolute; top: -1px; left: 0px; right: 0px;">
			<div class="col-xs-12">
				<button type="button" class="btn btn-sm btn-primary" style="position: absolute;right:175px;top:1px;" id="saveDashboardBtn">
					<span class="fa fa-check"></span>&nbsp;<s:message code="common.msg.save"/>
				</button>
				<button type="button" class="btn btn-sm btn-default" style="position: absolute;right:100px;top:1px;" id="cancleDashboardBtn">
					<span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/>
				</button>
			</div>
			<div class="col-xs-12" style="margin-top: 30px;">
				<div class="carousel slide media-carousel" id="selectDashMenu">
					<div class="carousel-inner" id="dashboardHeaderArea"></div>
					<a data-slide="prev" href="#selectDashMenu" class="left carousel-control" style="display:none; font-size: 24px; color: #fff;">‹</a>
					<a data-slide="next" href="#selectDashMenu" class="right carousel-control" style="display:none; font-size: 24px; color: #fff;">›</a>
				</div>
			</div>
		</div>
		<div class="boxArea">
			<div class="content_body">
				<div id="emptyDiv" class="empty-dashboard-message" style="display:none;">
					<h1><s:message code="custom.msg.empty"/></h1>
					<p><s:message code="custom.msg.insertInfo"/></p>
					<p><a href="<c:url value="/ems/dashboardSetup.do"/>"><s:message code="DATA_MONITOR.DASHBOARD_SETUP"/></a> <s:message code="custom.msg.insertInfo1"/></p>
					<p><a class="btn customBtn" href="javascript:;" id="editDashboardBtnPop"><s:message code="custom.add"/></a></p>
				</div>
				<div>
					<div id="dashboardInfo" style="margin-top: 25px; display: none;">
						<div class="row" id="tableRow">
							<div class="col-lg-6">
								<div class="panel panel-default">
									<div class="panel-heading">
										<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="dashboard.loggingData.count"/>
										<div class="form-group form-inline not-dashed" style="position: relative; top: -6px; float: right;">
											<div class="input-group date" id="startdatepicker">
												<input type="text" class="input-sm form-control" id="startdate" />
												<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
												</span>
											</div>
										</div>
									</div>
									
									<div class="panel-body" id="tableLoading" style="height: 207px;">
										<table id="loggingDataTable" class="table table-bordered">
											
										</table>
									</div>
								</div>
							</div>
							<c:choose>
								<c:when test="${arch eq 'multiple' && _USERCREDENTIAL_.adminType eq 'M'}"></c:when>
								<c:otherwise>
									<div class="col-lg-6">
										<div class="panel panel-default">
											<div class="panel-heading">
												<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="dashboard.loggingData.size"/>
											</div>
											<div class="panel-body">
												<table id="hdfsDataTable" class="table table-bordered">
													
												</table>
											</div>
										</div>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="row" id="chartRow" style="position: relative; top: -10px;">
							<div class="col-lg-6">
								<div class="panel panel-default">
									<div class="panel-heading">
										<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="dashboard.loggingData.count.trend"/>
									</div>
									<div class="panel-body">
										<div id="chartArea1" style="height: 150px;"></div>
									</div>
								</div>
							</div>
							<c:choose>
								<c:when test="${arch eq 'multiple' && _USERCREDENTIAL_.adminType eq 'M'}"></c:when>
								<c:otherwise>
									<div class="col-lg-6">
										<div class="panel panel-default">
											<div class="panel-heading">
												<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="dashboard.loggingData.size.trend"/>
											</div>
											<div class="panel-body">
												<div id="chartArea2" style="height: 150px;"></div>
											</div>
										</div>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="row" id="monitorRow" style="position: relative; top: -10px;">
							<div class="col-lg-6">
								<div class="panel panel-default">
									<div class="panel-heading">
										<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="dashboard.filesize"/>									
										<div class="form-group form-inline not-dashed" style="position: relative; top: -6px; float: right;">
											<span style="font-size:11px"> <s:message code="dashboard.filesizemsg"/>	</span>
											<div class="input-group date" id="fileSizeDatepicker" style="width:134px;"> 
												<input type="text" class="input-sm form-control" id="fileSizeDate" />
												<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
												</span>
											</div>
										</div>
									</div>
									
									<div class="panel-body " id="fileSizeBody" style="height: 410px;">
										<table id="fileSize" class="table table-bordered">
											
										</table>
									</div>
								</div>
							</div>
							<div class="col-lg-6">
								<div class="panel panel-default">
									<div class="panel-heading">
										<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="dashboard.filecount"/>
										<div class="form-group form-inline not-dashed" style="position: relative; top: -6px; float: right;">
											<span style="font-size:11px"> <s:message code="dashboard.filesizemsg"/>	</span>
											<div class="input-group date" id="fileCountDatepicker" style="width:134px;">
												<input type="text" class="input-sm form-control" id="fileCountDate" />
												<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
												</span>
											</div>
										</div>
									</div>
									
									<div class="panel-body " id="fileCountBody" style="height: 410px;">
										<table id="fileCount" class="table table-bordered">
											
										</table>
									</div>
								</div>
							</div>
						</div>
												
					</div>
					<div class="grid-stack" id="dashboardArea" style="height:100%; top: -10px;">
						
					</div>
				</div>
			</div>
		</div>
	</div>
	<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>
	<form method="post" id="getMessageInfo" action="<c:url value="/ems/message.do"/>" target="_self" >
		<input type="hidden" name="conditionParam" id="conditionParam" />
	</form>
	
	<%@ include file="./dashboardContent.jsp"%>
</body>
</html>