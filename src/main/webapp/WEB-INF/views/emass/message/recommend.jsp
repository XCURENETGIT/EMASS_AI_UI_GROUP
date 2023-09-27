<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%
	JSONObject param = Common.getParam(request);
	String msgId = Common.nvl(param.get("msgId"));
	String targetDate = Common.nvl(param.get("targetDate"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LTH - 유사 문서 추천</title>
<%@ include file="../../base.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/bootstrap-datetimepicker.min.css"/>"/>
<script type="text/javascript" src="<c:url value="/js/moment.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/collapse.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ko.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker.min.js"/>"></script>
<style>
.modal-body {
	padding-top: 5px;
}
#contextMenu {
	background: #DCE7F3;
	border: 1px solid gray;
	display: inline-block;
	min-width: 100px;
	-moz-box-shadow: 2px 2px 2px silver;
	-webkit-box-shadow: 2px 2px 2px silver;
	z-index: 99999;
}
#contextMenu ul{
	padding-left:0;
	margin-bottom:0;
}
#contextMenu ul li {
	padding: 3px 5px;
	cursor: pointer;
	list-style: none outside none;
	background-color: #DCE7F3;
	font-size: 11px;
	color: #000;
	width: 130px;
	border-bottom: 1px dotted #B3BABF;
}
#contextMenu li:hover {
	background-color: #7C98B4;
	color: #fff;
	font-weight: bold;
}
</style>
<script type="text/javascript">
var searchFlag=false;
var msgId = '<%=msgId%>';
var targetDate = '<%=targetDate%>';
$(document).ready(function(){
	$('#startdatepicker').datetimepicker({
		format: 'YYYY-MM-DD',
		defaultDate: moment(new Date()).subtract(1,'days')
	}).on('dp.change',function(){
		targetDate = $('#startdate').val().replaceAll('-','');
		getData();
	});
	
	$('#contextMenuCloseBtn').click(function(){
		$('#contextMenu').hide();
	});
	
	getData();
});

/*
 * 알람 메일 서식 목록 조회
 */
function getData() {
	if(searchFlag) return;
	
	grid.on();
	searchFlag=true;
	ui.get({
		url 		: 'getRecommendData.xcn',
		msgId		: msgId,
		targetDate	: targetDate,
		success 	: function(data, total) {
			grid.setData(data.emass);
		},
		error 		: function(status, message) {
			ui.alertMsg(message);
			grid.setData([]);
		},
		complete 	: function() {
			searchFlag=false;
			grid.off();
		}
	});
}

function setFeedback(feedback){
	var msgids = grid.getSelectedKey('msgid');
	if( msgids.length == 0 ){
		alert('<s:message code="condition.message.feedback.selectMsg"/>');
		return;
	}
	
	ui.get({
		url : 'updateEmsFeedback.xcn',
		msgId : msgids.join(','),
		feedback : feedback,
		success : function(data, total) {
			setGridFeedbackMulti(feedback);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			$('#contextMenu').hide();
		}
	});
}

function setGridFeedback(value){
	var data = grid.getRowData(grid.Row);
	data.ml_confd_feedback = value;
	//grid.setValue(grid.Row, grid.ColIndex('ml_confd_feedback_label'), value);
	grid.setValue(grid.Row, grid.ColIndex('ml_confd_feedback'), value);
}

function setGridFeedbackMulti(value){
	var idxArr = grid.getSelectedIndex();
	for(var i = 0; i < idxArr.length; i++ ) {
		var data = grid.getRowData(idxArr[i]);
		data.ml_confd_feedback = value;
		//grid.setValue(idxArr[i], grid.ColIndex('ml_confd_feedback_label'), value);
		grid.setValue(idxArr[i], grid.ColIndex('ml_confd_feedback'), value);
	}
}

function arrayToString( array ){
	if( array == null || array == undefined ) return "";
	else{
		return array.toString();
	}
}

function viewer_newOpen(row, selectedGrid){
	var msgid = grid.getValue(row, 'msgid');
	var bodySize = grid.getValue(row, 'bodySizeStr');
	var bodySizeNum = bodySize.substr(0, bodySize.indexOf(' ')); 
	openMessageBodyPop( '', msgid, '', bodySizeNum);
}

function fileInfoViewer( row, selectedGrid ){
	var msgid = grid.getValue(row, 'msgid');
	if(grid.getValue(row, 'attachcnt') == '') return;
	
	var url    = '<c:url value="/ems/fileInfoPop.do?msgId='+msgid+ '"/>';
	var pop = fnOpenWindow(url, 'fileInfoPop', 1015, 400, 'resize');
}

function ocrFileInfoViewer( row, selectedGrid ){
	var msgid = grid.getValue(row, 'msgid');
	if(grid.getValue(row, 'ocr_attach_cnt') == '') return;
	
	var url    = '<c:url value="/ems/fileInfoPop.do?msgId='+msgid +'"/>';
	var pop = fnOpenWindow(url, 'ocrFileInfoPop', 1015, 400, 'resize');
}

function userInfoViewer(row, type, selectedGrid){
	var msgid = grid.getValue(row, 'msgid');
	if(grid.getValue(row, type) == '') return;
	
	var url    = '<c:url value="/ems/userInfoPop.do?msgId='+msgid+'&type='+type+'"/>';
	return fnOpenWindow(url, type+'InfoPop', 1000, 370, 'resize');
}

function interestUserInfoViewer( row, selectedGrid ){
	var userid = grid.getValue(row, 'userid');
	if(grid.getValue(row, 'userid') == '') return;
	var url    = '<c:url value="/ems/interestUserInfoPop.do?userid='+userid+'"/>';
	var pop = fnOpenWindow(url, 'interestUserInfoPop', 1015, 400, 'resize');
}

function regexpInfoViewer(row, selectedGrid){
	var msgid = grid.getValue(row, 'msgid');
	if(grid.getValue(row, 'pi_total') == '') return;
	
	var url = '<c:url value="/ems/regexpInfoPop.do?msgId='+msgid+'"/>';
	return fnOpenWindow(url, 'regexpInfoPop', 1100, 620, 'resize');
}
</script>
</head>
<body class="mini-navbar msgBody">
	<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="common.msg.similar"/></span>
		</div>
	</header>
	<div class="xcn_container"> 
		<div class="boxArea">
			<div class="content_body">
				<div class="row">
					<div class="col-xs-8 text-left">
						<div class="form-group form-inline not-dashed">
							<div class='input-group date' id='startdatepicker'>
								<input type='text' class="input-sm form-control" id='startdate' />
								<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
						</div>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="recommendListGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="contextMenu" style="display:none;position:absolute">
		<ul>
			<li style="background-color:#1576A1;color:#fff;font-weight: bold;cursor:default;"><s:message code="condition.feedback"/> <s:message code="common.msg.setting"/>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close" style="font-size:15px;color:#fff;text-shadow:0 1px 0 #000; opacity:0.7;" id="contextMenuCloseBtn">
					<span aria-hidden="true">&times;</span>
				</button>
			</li>
		</ul>
		<ul>
			<li onclick="setFeedback(0);" style="padding-left: 5px;"><div class="feedbackCorrect"></div>&nbsp;<s:message code="condition.info.feedback0"/></li>
			<li onclick="setFeedback(1);" style="padding-left: 5px;"><div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class1"/></li>
			<li onclick="setFeedback(2);" style="padding-left: 5px;"><div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class2"/></li>
			<li onclick="setFeedback(3);" style="padding-left: 5px;"><div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class3"/></li>
			<li onclick="setFeedback(4);" style="padding-left: 5px;"><div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class4"/></li>
			<li onclick="setFeedback(9);" style="padding-left: 5px;"><div class="feedbackDefer"></div>&nbsp;<s:message code="condition.info.feedback9"/></li>
		</ul>
	</div>
	<script type="text/javascript">
		var grid = new Xgrid('recommendListGrid', contextRoot);
		grid.onCheckBox();
		grid.autoNumber();
		grid.colAdd('msgid', '<s:message code="common.msg.msgid"/>', 100, 'left', false, 'nomal');
 		grid.colAdd('epmsg_type', '<s:message code="condition.epmsgType.list"/>', 100, 'center', true, 'nomal');
		grid.colAdd('xrootmtr', '<s:message code="common.msg.xrootmtr"/>', 100, 'left', true, 'nomal');
		grid.colAdd('interestUserYn', '<s:message code="message.msg.interest"/>', 40, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
			if (value == 'N') return '';
			/* if (value == 'Y') return '<div class="interestUserCheck"></div>';
			else if (value == 'N') return ''; */
			var value = grid.getValue(row, 'interestGroupColor')
			var str = '';
			if(value != null && value != undefined && value != ''){
				var v = value.split(',');
				for(var i = 0; i < v.length; i++) {
					str += '<span style="display:inline-block; width: 11px; height: 11px; margin-left: 1px; background-color:'+v[i]+'"></span>';
				}
			}
			return str;
		});
		grid.colAdd('ml_confd_class', '<s:message code="condition.infotype"/>', 100, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			if (value == '4') return '<s:message code="condition.info.class4"/>';
			else if (value == '3') return '<s:message code="condition.info.class3"/>';
			else if (value == '2') return '<s:message code="condition.info.class2"/>';
			else if (value == '1') return '<s:message code="condition.info.class1"/>';
			else return '<s:message code="common.msg.noinfo"/>';
		});
		grid.colAdd('ml_confd_feedback', '<s:message code="condition.feedback"/>', 110, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			if (value == '1') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class1"/>';
			else if (value == '2') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class2"/>';
			else if (value == '3') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class3"/>';
			else if (value == '4') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class4"/>';
			else if (value == '0') return '<div class="feedbackCorrect"></div>&nbsp;<s:message code="condition.info.feedback0"/>';
			else if (value == '9') return '<div class="feedbackDefer"></div>&nbsp;<s:message code="condition.info.feedback9"/>';
			else return '-';
		});
		grid.colAdd('ml_confd_prob', '<s:message code="condition.prob"/>(%)', 90, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			return probPercent(value);
		});
		grid.colAdd('confidence', '<s:message code="condition.info.feedback.confidence"/>', 100, 'right', false, 'nomal');
		grid.colAdd('subject', '<s:message code="condition.subject"/>', 410, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			var body_snippet = grid.getValue(row, 'body_snippet').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
			if(body_snippet.length > 100) body_snippet = body_snippet.substring(0, 1024)+'...';
			
			if(value.length > 1024) value = value.substring(0, 1024)+'...';
			value = value.replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
			
			//예약어 Highlight 처리
			var kwds = grid.getValue(row, 'kwds');
			value = value, kwds;
			value = value;
			
			var rtnVal = '<span title="'+body_snippet+'" onclick="" class="subject_read'+grid.getValue(row, 'readYn')+'">'+value+'</span>&nbsp;<a href="javascript:void(0);" onclick="viewer_newOpen('+row+')" class="glyphicon glyphicon-new-window new-window"></a>';
			if( (isConsent( ) && grid.getValue(row, 'consentNo') == '') || !isDetailView() ) rtnVal = '<span>'+value+'</span>';
			
			return rtnVal;
		});
		grid.colAdd('content', '<s:message code="condition.info.feedback.content"/>', 400, 'left', false, 'nomal');
		grid.colAdd('attachcnt', '<s:message code="message.msg.file"/>', 35, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
			if (value == '0') return '';
			else return value.comma();
		});
		grid.colAdd('inside', '<s:message code="message.msg.inout"/>', 55, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			if (value == 'N') return '<s:message code="message.msg.out"/>';
			else if (value == 'Y') return '<s:message code="message.msg.in"/>';
			else return '-';
		});
		grid.colAdd('direction_svc', '<s:message code="condition.receive_send"/>', 55, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			if (value == 'I') return '<s:message code="condition.receive"/>';
			else if (value == 'O') return '<s:message code="condition.send"/>';
			else return '-';
		});
		grid.colAdd('svcNm', '<s:message code="condition.service"/>', 180, 'center', false, 'nomal');
		grid.colAdd('ctimeFormat', '<s:message code="condition.date"/>', 130, 'center', false, 'nomal');
		grid.colAdd('user', '<s:message code="consent.user"/>', 120, 'center', false, 'link');
		grid.colAdd('businm', '<s:message code="common.org.busi"/>', 120, 'center', true, 'nomal');
		grid.colAdd('deptnm', '<s:message code="common.org.dept"/>', 120, 'center', false, 'nomal');
		grid.colAdd('jikgubnm', '<s:message code="common.org.jikgub"/>', 120, 'center', false, 'nomal');
		grid.colAdd('sender', '<s:message code="condition.sender"/>', 130, 'left', false, 'link', function(row, cell, value, columnDef, dataContext) {
			return value;
		});
		grid.colAdd('allofus', '<s:message code="condition.allofus"/>', 150, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			if( value == undefined || value.length == 0) return '';
			
			for( var i=0; i<value.length; i++){
				if(value[i] == 'IA') value[i] = '<s:message code="condition.allofus1"/>';
				else if(value[i] == 'ET') value[i] = '<s:message code="condition.allofus8"/>';
				else if(value[i] == 'IT') value[i] = '<s:message code="condition.allofus7"/>';
				else if(value[i] == 'EA') value[i] = '<s:message code="condition.allofus2"/>';
				else if(value[i] == 'PT') value[i] = '<s:message code="condition.allofus9"/>';
				else if(value[i] == 'PA') value[i] = '<s:message code="condition.allofus3"/>';
				else if(value[i] == 'SO') value[i] = '<s:message code="condition.allofus13"/>';
				else if(value[i] == 'SI') value[i] = '<s:message code="condition.allofus14"/>';
			}
			return value.join(', ');
		});
		grid.colAdd('recvsStr', '<s:message code="condition.recv"/>', 220, 'left', false, 'link', function(row, cell, value, columnDef, dataContext) {
			return value;
		}, {sorter:sortUtil.inout});
		grid.colAdd('to', '<s:message code="condition.to"/>', 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
			var innOutInfo = grid.getValue(row, 'toInOutInfo');
			var rtnVal = arrayToString(value);
			return innOutInfo+rtnVal;
		});
		grid.colAdd('cc', '<s:message code="condition.cc"/>', 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
			var innOutInfo = grid.getValue(row, 'ccInOutInfo');
			
			var rtnVal = arrayToString(value);
			return innOutInfo+rtnVal;
		});
		grid.colAdd('bcc', '<s:message code="condition.bcc"/>', 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
			var innOutInfo = grid.getValue(row, 'bccInOutInfo');
			var rtnVal = arrayToString(value);
			return innOutInfo+rtnVal;
		});
		grid.colAdd('srcip', '<s:message code="condition.source"/> IP', 100, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			return value;
		}, {sorter:sortUtil.ip});
		grid.colAdd('dstip', '<s:message code="condition.destination"/> IP', 100, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			return value;
		}, {sorter:sortUtil.ip});
		grid.colAdd('attachname', '<s:message code="condition.attach_name"/>', 220, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			var rtnVal = arrayToString(value);
			return rtnVal;
		});
		grid.colAdd('sizeStr', '<s:message code="condition.size.all"/>', 80, 'left', false, 'nomal', null, {sortField:'size'});
		grid.colAdd('bodySizeStr', '<s:message code="condition.size.body"/>', 80, 'left', false, 'nomal', null, {sortField:'body_size'});
		grid.colAdd('attachSizeStr', '<s:message code="condition.size.attach"/>', 80, 'left', false, 'nomal', null, {sortField:'attachSizeSort'});
		grid.colAdd('kwds', '<s:message code="condition.keyword"/>', 120, 'left', false, 'nomal');
		grid.colAdd('pi_total', '<s:message code="condition.regexp"/>', 70, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
			if (value == '0') return '';
			else return value.comma();
		});
		
		if ( isOCR ) {
			grid.colAdd('ocr_attach_cnt', 'OCR <s:message code="message.msg.file"/>', 70, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
				if (value == '0' || value == '' || value == null || value == undefined ) return '';
				else return value.comma();
			});
		}
		grid.loadHeader(true);
		grid.initData('<s:message code="common.msg.search.click"/>');
		grid.onContextMenu = function(row, col, e){
			e.preventDefault();
			/* if( grid.ColIndex('_checkbox_selector') == col || grid.ColIndex('NUM') == col){
				return;
			} */

			$("#contextMenu")
			.data("row", row)
			.css("top", e.pageY)
			.css("left", e.pageX)
			.show();
			/* $("body").on("click", function () {
				$("#contextMenu").hide();
			});
			$(document).bind("mousedown", function(event){
				$("#contextMenu").hide();
				$(document).unbind("mousedown", this);
			}); */
		};
		grid.onClick = function() {
			if($('#contextMenu').css('display')=='block' || $('#contextMenu').css('display')=='inline-block') $('#contextMenu').hide();
			if (grid.Col == grid.ColIndex('attachcnt')) {
				fileInfoViewer( grid.Row );
			}else if (grid.Col == grid.ColIndex('user')) {
				userInfoViewer( grid.Row, 'user' );
			}else if (grid.Col == grid.ColIndex('sender')) {
				userInfoViewer( grid.Row, 'sender' );
			}else if (grid.Col == grid.ColIndex('recvsStr')) {
				if(grid.getValue(grid.Row, 'recvs') != '') 	userInfoViewer( grid.Row, 'recvs');
			}else if (grid.Col == grid.ColIndex('to')) {
				if(grid.getValue(grid.Row, 'to') != '') userInfoViewer( grid.Row, 'to');
			}else if (grid.Col == grid.ColIndex('cc')) {
				if(grid.getValue(grid.Row, 'cc') != '') userInfoViewer( grid.Row, 'cc');
			}else if (grid.Col == grid.ColIndex('bcc')) {
				if(grid.getValue(grid.Row, 'bcc') != '') userInfoViewer( grid.Row, 'bcc');
			}else if(grid.Col == grid.ColIndex('pi_total')) {
				regexpInfoViewer(grid.Row);
			}else if(grid.Col == grid.ColIndex('referer_url')) {
				var referer_url = grid.getValue(grid.Row, 'referer_url');
				if(referer_url !='N') fnOpenWindow(referer_url, '', 1024, 800, 'resize');
			}else if (grid.Col == grid.ColIndex('ocr_attach_cnt')) {
				ocrFileInfoViewer( grid.Row );
			} else if (grid.Col == grid.ColIndex('interestUserYn')) {
				var interestUserYn = grid.getValue(grid.Row, 'interestUserYn');
				if(interestUserYn != '') interestUserInfoViewer(grid.Row);
			}
			
			if( !(adminMenu != "ALL" && adminMenu.indexOf("DV") < 0) ) {
				if(!parent.$('#none_btn').hasClass('areaSelected')) viewer_open(grid.Row);
				if(popWin) viewer_openFocus(grid.Row);
			} else {
				alert('<s:message code="message.auth.no.detailview"/>');
				return;
			}
		};
		grid.onDblClick = function() {
			if (grid.Col == grid.ColIndex('subject')) {
				viewer_newOpen( grid.Row );
			}
		};
	</script>
</body>
</html>