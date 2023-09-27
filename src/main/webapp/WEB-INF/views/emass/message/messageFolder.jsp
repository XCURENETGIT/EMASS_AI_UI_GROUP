<%@page import="com.xcurenet.audit.service.Operation"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	String folderSeq = Common.nvl(request.getParameter("paramFolderSeq"));
	String folderName = Common.nvl(request.getParameter("paramFolderName"));
	String infoFeedbackYn = Common.getInfoFeedbackYn(session);
	boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LTH - <s:message code="filterInfo.messageFolder"/></title>
<%@ include file="../../base.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/dropdowns-enhancement.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/panelsTab.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/zTreeStyle.css"/>"/>

<script type="text/javascript" src="<c:url value="/js/jquery.ztree.all-3.5.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ztreeRMenu.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/folder.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/InnoFD.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ztree.js"/>"></script>
<style type="text/css">
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {
	border: 0px;
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
<script>
var folderSeq = '<%=folderSeq%>';
var folderName = '<%=folderName%>';
var infoFeedbackYn = '<%=infoFeedbackYn%>';
var infoFeedbackConf = '<%=infoFeedbackConf%>';
var pageType='';
var grid;
var searchFlag = false;
var condition = {
	messageInputFilter:'<s:message code="condition.message.input.filter"/>',
	messageInputPeriod:'<s:message code="condition.message.input.period"/>',
	consentMsgTimecheck:'<s:message code="consent.msg.timecheck"/>',
	messageNumbercheck:'<s:message code="condition.message.numbercheck"/>',
	messageFolderFilter:'<s:message code="condition.message.folder.filter"/>',
	messageSelectFolder:'<s:message code="condition.message.select.folder"/>',
	msgSaved:'<s:message code="common.msg.saved"/>',
	selectInterest:'<s:message code="condition.select.interest"/>',
	interestUserAll:'<s:message code="interest.user.all"/>',
	commonMsgAll:'<s:message code="common.msg.all"/>',
	serviceAll:'<s:message code="condition.service.all"/>',
	orgBusiAll:'<s:message code="common.org.busi.all"/>',
	orgDeptAll:'<s:message code="common.org.dept.all"/>',
	msgSelect_all:'<s:message code="common.msg.select_all"/>',
	msgUnselect_all:'<s:message code="common.msg.unselect_all"/>',
	msgNoresult:'<s:message code="common.msg.noresult"/>',
	msgConnectError:'<s:message code="common.msg.connect.error"/>',
	messageSelectDashboard:'<s:message code="condition.message.select.dashboard"/>',
	msgConfirmSave:'<s:message code="common.msg.confirm.save"/>',
	searchService:'<s:message code="condition.search.service"/>',
	delMsgFolderMsg:'<s:message code="filterInfo.delMsgFolderMsg"/>',
	delMsgFoldercomplMsg:'<s:message code="filterInfo.delMsgFoldercomplMsg"/>',
	moveMsgFolderMsg:'<s:message code="filterInfo.moveMsgFolderMsg"/>',
	moveMsgFoldercomplMsg:'<s:message code="filterInfo.moveMsgFoldercomplMsg"/>',
	userGroupNaviTitle2:'<s:message code="userGroup.navi.title2"/>',
	recv_jikgubAll:'<s:message code="condition.recv_jikgub.all"/>',
	msgNoinfo:'<s:message code="common.msg.noinfo"/>'
};
var filter={
	msgConnectError:'<s:message code="common.msg.connect.error"/>',
	add:'<s:message code="filterInfo.filter.add"/>',
	folderNew:'<s:message code="filterInfo.folder.new"/>',
	folderDelete:'<s:message code="filterInfo.folder.delete"/>',
	msgSelectFile:'<s:message code="filterInfo.incorrect.file"/>',
	msgSaved:'<s:message code="common.msg.saved"/>',
	msgSaveError:'<s:message code="common.msg.save.error"/>',
	msgImportData:'<s:message code="filterInfo.msg.import.data"/>',
	msgExportData:'<s:message code="filterInfo.msg.export.data"/>',
	msgFilterDelete:function(param){
		return '<s:message code="filterInfo.msg.filter.delete" arguments="'+param+'" />';
	},
	msgfolderDelete:function(param){
		return '<s:message code="filterInfo.msg.folder.delete" arguments="'+param+'" />';
	},
	msgAllDelete:function(param){
		return '<s:message code="filterInfo.msg.all.delete" arguments="'+param+'" />';
	},
	selectMsg:'<s:message code="filterInfo.selectMoveMsg"/>',
	selectDelMsg:'<s:message code="filterInfo.selectDelMsg"/>',
	selectMsgFolder:'<s:message code="filterInfo.selectMsgFolder"/>',
	moveMsgFolderSameFolderMsg: '<s:message code="filterInfo.moveMsgFolderSameFolderMsg"/>',
	moveMsgFolderMultiFolderMsg: '<s:message code="filterInfo.moveMsgFolderMultiFolderMsg"/>'
};
var checkMsgCnt = 10000;
var totalCnt;
var staticTreeId = 'folderTreePop';
$(document).ready(function(){
	initGrid();
	initFolderSetup();
	
	$('#noSelectBtn').click(function(){ self.close();  });
	
	$('#contextMenuCloseBtn').click(function(){
		$('#contextMenu').hide();
	});
	
	var msgBodyObj = parent.document.getElementsByClassName('msgBody');
	$(msgBodyObj).click(function(){
		if($('#contextMenu').css('display')=='block'|| $('#contextMenu').css('display')=='inline-block')$("#contextMenu").hide();
	});
	
	$("#exportDialog").on('show.bs.modal', function() {
		$('input:radio[name=exportDataRange]:input:checked').prop("checked", false);
		
		var selectedTabIdx = $('#resultTab').find('.active').index();
		var rows = grid.getSelectedKey('msgid').length;
		var total = totalCnt;

		if(total == 0){
			ui.alertMsg('<s:message code="common.msg.nodata"/>');
			return false;
		}
		
		var searchType = $('#searchType').val();
		var consentNo = grid.getValue(0, 'consentNo');
		if( searchType != 'L'){
			if(isConsent( ) && consentNo == ''){
				alert('<s:message code="download.msg.consent"/>');
				return false;
			}
		}
		
		$('#searchTime').val('');
		$('#searchCondition').val('');
		$('#searchHeader').val('');
		$('#searchTotal').val('');
		$('#dataLength').val('');
		$('#exportFileExt').val('');
		
		if( (rows > checkMsgCnt) || (rows == 0 && grid.data.length > checkMsgCnt)){
			$('input:radio[name=exportDataRange]:input[value=A]').parent().click();
		}else{
			$('input:radio[name=exportDataRange]:input[value=S]').parent().click();
		}
	});
	
	$("#exportDialog").on('hidden.bs.modal', function() {
		$('#searchType').val('');
		$('#searchTime').val('');
		$('#searchCondition').val('');
		$('#searchHeader').val('');
		$('#searchTotal').val('');
		$('#dataLength').val('');
		$('#exportFileExt').val('');
	});
	
	$( 'input[name="exportDataRange"]:radio' ).change(function(){
		var selectedTabIdx = $('#resultTab').find('.active').index();
		var rows = grid.getSelectedKey('msgid').length;
		var total = totalCnt;

		var downTotal = total;
		var exportDataRange = $(this).val();
		if( exportDataRange == 'S'){
			$('#sizeWarnMsg').hide();
			
			if( rows > 0) downTotal = rows;
			else downTotal = grid.data.length;
			
			if( downTotal > checkMsgCnt){
				ui.alertMsg('<s:message code="download.message.check.total" arguments="'+addCommas(checkMsgCnt)+'" argumentSeparator="|"/>');
				$('input:radio[name=exportDataRange]:input[value=A]').parent().click();
				return;
			}
		}
		
		var searchType = $('#searchType').val();
		if( searchType.indexOf('L') > -1){
			$('#exportFileTypeArea').show();
			if(downTotal > 50000){
				$('#sizeWarnMsg').show();
			}else{
				$('#sizeWarnMsg').hide();
			}
		}
		else {
			$('#exportFileTypeArea').hide();
			$('#sizeWarnMsg').hide();
		}
		$('#exportDataSize').text(addCommas(downTotal));
		$('#searchTotal').val(downTotal);
	});
	
	$('#allDownBtn').click(function(){
		var selectedTabIdx = $('#resultTab').find('.active').index();
		var obj = {};
		obj.folderSeq = folderSeq;
		obj.folderName = folderName;
		
		var conditions = [];
		var condition = {};
		condition.sort = 'ctime desc';
		conditions.push(condition);
		obj.conditions = conditions;
		grid.on();

		var header = grid.getHeaderEXCEL();
		var param = JSON.stringify( obj );
		var dataLength = $('#dataLength_select').val();
		var searchType = $('#searchType').val();
		var exportFileType = $('input:radio[name=exportFileType]:input:checked').val();
		var exportDataRange = $('input:radio[name=exportDataRange]:input:checked').val();
		
		$('#searchTime').val(obj.searchTime);
		$('#searchCondition').val(param);
		$('#searchHeader').val(header);
		$('#dataLength').val(dataLength);
		$('#exportFileExt').val(exportFileType);
		
		$('#isBackground').val('N');
		if( searchType == 'B'){
			$('#body_link_btn').click();
		}else if(searchType == 'A' ){
			$('#attach_link_btn').click();
		}
		else if(searchType == 'LB' || searchType == 'LBA' ){
			var msgids = grid.getSelectedKey('msgid');
			if( msgids.length == 0 ){
				msgids = grid.getKeyData('msgid');
			}
			var selected_condition = {};
			selected_condition.msgids = msgids;
			selected_condition.sort = $('#messageSort').val();
			
			$('#searchCondition').val(JSON.stringify( selected_condition ));
			$('#searchTotal').val(msgids.length);
			
			if(exportFileType == 'xlsx' || exportFileType == 'cell'){
				$('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveZip.xcn"/>');
				$('#allDownForm').submit();
			}else if(exportFileType == 'csv'){
				$('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveCSV.xcn"/>');
				$('#allDownForm').submit();
			}else if(exportFileType == 'pdf'){
				$('#allDownForm').attr('action', '<c:url value="/getEmassMessageSavePDF.xcn"/>');
				$('#allDownForm').submit();
			}
		}
		else{
			if(exportFileType == 'xlsx'){
				$('#excel_link_btn').click();
			}else if(exportFileType == 'cell'){
				$('#cell_link_btn').click();
			}else if(exportFileType == 'csv'){
				$('#csv_link_btn').click();
			}else if(exportFileType == 'pdf'){
				$('#pdf_link_btn').click();
			}
		} 
		
		$('#exportDialog').modal('hide');
		setTimeout(function(){
			grid.off();
		}, 500);
	});
	
	if(adminMenu != "ALL" && adminMenu.indexOf("LS") < 0 && adminMenu.indexOf("BS") < 0 && adminMenu.indexOf("AS") < 0 && adminMenu.indexOf("WS") < 0 && adminMenu.indexOf("CS") < 0 && adminMenu.indexOf("LP") < 0) {
		$('#btnExport').prop("disabled",true);
	}
	
	$(document).on('click', '.body_link2', function(){
		if (grid.Rows == 0) {
			alert('<s:message code="common.msg.nodata"/>');
			return;
		}

		grid.on();
		setTimeout(function(){
			var msgid = grid.getSelectedKey('msgid');
			if(msgid.length == 0) msgid = grid.getKeyData('msgid');
			
			$('#msgId').val('');
			$('#msgIds').val('');
			if(msgid.length==1){
				$('#msgId').val(msgid.join(','));
				$('#downForm').attr('action', '<c:url value="/getEmassBodySave.xcn"/>');
			} else {
				$('#msgIds').val(msgid.join(','));
				$('#downForm').attr('action', '<c:url value="/getEmassBodySaveZip.xcn"/>');
			}
			$('#downForm').submit();
			grid.off();
		}, 300);
	});
	
	$(document).on('click', '.attach_link2', function(){
		if (grid.Rows == 0) {
			alert('<s:message code="common.msg.nodata"/>');
			return;
		}
		grid.on();
		setTimeout(function(){
			var msgid = grid.getSelectedKey('msgid');
			if(msgid.length == 0) msgid = grid.getKeyData('msgid');
			
			$('#msgIds').val(msgid.join(','));
			$('#downForm').attr('action', '<c:url value="/downEmassAttachByMsgId.xcn"/>');
			$('#downForm').submit();
			grid.off();
		}, 300);
	});
	
	$(document).on('click', '.all_down_link', function(){
		var searchType = $(this).attr('data-type');
		$('#searchType').val(searchType);
		
		var title = $(this).text();
		$('#exportTitle').text(title+' '+'<s:message code="common.msg.export"/>');
		
		$('#exportDialog').modal('show');
	});
	
	$('#moveFolderBtn').on('click', function(){
		var msgids = grid.getSelectedKey('msgid');
		var consentNo = grid.getSelectedKey('consentNo');

		var folderTreePop = $.fn.zTree.getZTreeObj("folderTreePop");
		var nodes = folderTreePop.getSelectedNodes();
		if( nodes.length == 0 ){
			alert(condition.messageSelectFolder);
			return;
		} else if( nodes.length > 1) {
			alert(filter.moveMsgFolderMultiFolderMsg);
			return;
		}
		
		if( folderSeq == nodes[0].id ) {
			alert(filter.moveMsgFolderSameFolderMsg);
			return;
		}
		
		ui.confirmMsg(condition.moveMsgFolderMsg, '', '', function(rs){
			if(rs){
				ui.get({
					url : 'changeAdminFolderData.xcn',
					folderSeq : nodes[0].id,
					msgIds : msgids.join(','),
					consentNo : consentNo[0],
					oldFolderSeq : folderSeq,
					success : function(data, total) {
						alert(condition.moveMsgFoldercomplMsg);
					},
					error : function(status, message) {
						ui.alertMsg(message);
					},
					complete : function() {
						$('#smartFolderSavePop').modal('hide');
						grid.deleteSelectedRows();
						opener.getAdminFolderList();
						getFolderDataList();
					}
				});
			}
		});
	});
	
	getFolderDataList();
});

function getFolderDataList(flag){
	if(searchFlag) return;
	
	if ( flag == undefined || flag == '') {
		grid.data.length = 0;
		grid.rtnNextPageFunc = getFolderDataList;
		grid.loadingPage = 0;
	} else {
		grid.loadingPage++;
	}
	
	var param = {};
	param.folderSeq = folderSeq;
	param.folderName = folderName;
	
	var conditions = [];
	var condition = {};
	condition.sort = 'ctime desc';
	conditions.push(condition);
	param.conditions = conditions;
	
	searchFlag = true;
	grid.on();
	ui.postJson({
		url : 'getList.xcn',
		data : JSON.stringify( param ),
		pageType : pageType,
		offset : grid.data.length,
		limit : grid.pageSize,
		success : function(data, total) {
			grid.appendData(data.emass);
			if ( grid.loadingPage == 0 ) grid.Select(-1,-1);
			totalCnt = total;
			//$('#totalcnt').html('<s:message code="common.msg.finish_query"/>: '+addCommas(total));
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			searchFlag = false;
			grid.off();
		}
	});
}

function initGrid(){
	grid = new Xgrid('gridTabList', contextRoot);
	grid.onCheckBox();
	grid.autoNumber();
 	grid.colAdd('epmsg_type', '<s:message code="condition.epmsgType.list"/>', 100, 'center', true, 'nomal');
	grid.colAdd('xrootmtr', '<s:message code="common.msg.xrootmtr"/>', 100, 'left', true, 'nomal');
	grid.colAdd('interestUserYn', '<s:message code="message.msg.interest"/>', 40, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
		if (value == 'Y') return '<div class="interestUserCheck"></div>';
		else if (value == 'N') return '';
	});
	grid.colAdd('readYn', '<s:message code="condition.read"/>', 40, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
		if (value == 'Y') return '<div class="readY"></div>';
		else if (value == 'N') return '<div class="readN"></div>';
		else return '-';
	});
	if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ) {
	/* grid.colAdd('ml_confd_class_label', '<s:message code="condition.infotype"/>', 100, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
		value = grid.getValue(row, 'ml_confd_class');
		if (value == '4') return '<s:message code="condition.info.class4"/>';
		else if (value == '3') return '<s:message code="condition.info.class3"/>';
		else if (value == '2') return '<s:message code="condition.info.class2"/>';
		else if (value == '1') return '<s:message code="condition.info.class1"/>';
		else return '<s:message code="common.msg.noinfo"/>';
	}); */
	grid.colAdd('ml_confd_class', '<s:message code="condition.infotype"/>', 100, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
		if (value == '4') return '<s:message code="condition.info.class4"/>';
		else if (value == '3') return '<s:message code="condition.info.class3"/>';
		else if (value == '2') return '<s:message code="condition.info.class2"/>';
		else if (value == '1') return '<s:message code="condition.info.class1"/>';
		else return '<s:message code="common.msg.noinfo"/>';
	});
	/* grid.colAdd('ml_confd_feedback_label', '<s:message code="condition.feedback"/>', 110, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
		value = grid.getValue(row, 'ml_confd_feedback');
		if (value == '1') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class1"/>';
		else if (value == '2') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class2"/>';
		else if (value == '3') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class3"/>';
		else if (value == '4') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class4"/>';
		else if (value == '0') return '<div class="feedbackCorrect"></div>&nbsp;<s:message code="condition.info.feedback0"/>';
		else if (value == '9') return '<div class="feedbackDefer"></div>&nbsp;<s:message code="condition.info.feedback9"/>';
		else return '-';
	}); */
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
	}
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
	grid.colAdd('subject', '<s:message code="condition.subject"/>', 410, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
		var body_snippet = grid.getValue(row, 'body_snippet').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
		if(body_snippet.length > 100) body_snippet = body_snippet.substring(0, 1024)+'...';
		
		if(value.length > 1024) value = value.substring(0, 1024)+'...';
		value = value.replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
		
		//예약어 Highlight 처리
		var kwds = grid.getValue(row, 'kwds');
		value = highlightKeyword(value, kwds);
		value = highlightSearchStr(value, "subject");
		
		var rtnVal = '<a href="javascript:void(0);" title="'+body_snippet+'" onclick="viewer_open('+row+')" class="subject_read'+grid.getValue(row, 'readYn')+'">'+value+'</a>&nbsp;<a href="javascript:void(0);" onclick="viewer_newOpen('+row+')" class="glyphicon glyphicon-new-window new-window"></a>';
		if( (isConsent( ) && grid.getValue(row, 'consentNo') == '') || !isDetailView() ) rtnVal = '<span>'+value+'</span>';
		
		return rtnVal;
	});
	grid.colAdd('ctimeFormat', '<s:message code="condition.date"/>', 130, 'center', false, 'nomal');
	grid.colAdd('user', '<s:message code="consent.user"/>', 120, 'center', false, 'link');
	grid.colAdd('usr_id', '<s:message code="common.msg.account"/>', 110, 'center', false, 'nomal');
	grid.colAdd('businm', '<s:message code="common.org.busi"/>', 120, 'center', true, 'nomal');
	grid.colAdd('deptnm', '<s:message code="common.org.dept"/>', 120, 'center', false, 'nomal');
	grid.colAdd('jikgubnm', '<s:message code="common.org.jikgub"/>', 120, 'center', false, 'nomal');
	grid.colAdd('sender', '<s:message code="condition.sender"/>', 130, 'left', false, 'link', function(row, cell, value, columnDef, dataContext) {
		return highlightSearchStr(value, "sender");
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
	grid.colAdd('recvs', '<s:message code="condition.recv"/>', 220, 'left', false, 'link', function(row, cell, value, columnDef, dataContext) {
		var innOutInfo = grid.getValue(row, 'recvsInOutInfo');
		
		var rtnVal = arrayToString(value);
		return innOutInfo+highlightSearchStr(rtnVal, "recvs");
	});
	grid.colAdd('to', '<s:message code="condition.to"/>', 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
		var innOutInfo = grid.getValue(row, 'toInOutInfo');
		var rtnVal = arrayToString(value);
		return innOutInfo+highlightSearchStr(rtnVal, "to");
	});
	grid.colAdd('cc', '<s:message code="condition.cc"/>', 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
		var innOutInfo = grid.getValue(row, 'ccInOutInfo');
		
		var rtnVal = arrayToString(value);
		return innOutInfo+highlightSearchStr(rtnVal, "cc");
	});
	grid.colAdd('bcc', '<s:message code="condition.bcc"/>', 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
		var innOutInfo = grid.getValue(row, 'bccInOutInfo');
		var rtnVal = arrayToString(value);
		return innOutInfo+highlightSearchStr(rtnVal, "bcc");
	});
	grid.colAdd('srcip', '<s:message code="condition.source"/> IP', 100, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
		return highlightSearchStr(value, "srcip");
	}, {sorter:sortUtil.ip});
	grid.colAdd('dstip', '<s:message code="condition.destination"/> IP', 100, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
		return highlightSearchStr(value, "dstip");
	}, {sorter:sortUtil.ip});
	grid.colAdd('attachname', '<s:message code="condition.attach_name"/>', 220, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
		var rtnVal = arrayToString(value);
		return highlightSearchStr(rtnVal, "attachname");
	});
	grid.colAdd('sizeStr', '<s:message code="condition.size.all"/>', 80, 'left', false, 'nomal', null, {sortField:'size'});
	grid.colAdd('bodySizeStr', '<s:message code="condition.size.body"/>', 80, 'left', false, 'nomal', null, {sortField:'body_size'});
	grid.colAdd('attachSizeStr', '<s:message code="condition.size.attach"/>', 80, 'left', false, 'nomal', null, {sortField:'attachSizeSort'});
	grid.colAdd('kwds', '<s:message code="condition.keyword"/>', 120, 'left', false, 'nomal');
	
	/* grid.colAdd('referer_url', 'Referer', 120, 'left', false, 'link', function(row, cell, value, columnDef, dataContext) {
		if (value == 'N') return '';
		else return value;
	});
	grid.colAdd('referer_url_name', 'Referer site', 120, 'left', false, 'nomal');
	grid.colAdd('referer_url_title', 'Referer title', 120, 'left', false, 'nomal');
	grid.colAdd('referer_url_desc', 'Referer desc', 120, 'left', false, 'nomal'); */
	
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
	grid.loadExportMenu('<s:message code="filterInfo.messageFolder"/>');
	grid.loadPageSize();
	grid.changePageSize = function(cnt){
		getFolderDataList();
	};
	grid.loadHeader(true);
	grid.initData('<s:message code="common.msg.search.click"/>');
	
	grid.onContextMenu = function(row, col, e){
		e.preventDefault();
		$("#contextMenu")
		.data("row", row)
		.css("top", e.pageY)
		.css("left", e.pageX)
		.show();
	};
	
	//writeExportMenu('export_menu'+idx, gridId, '<s:message code="DATA_MONITOR.MESSAGE_INFO"/>', '<s:message code="common.msg.select"/>&nbsp;');
	
	grid.onClick = function() {
		if($('#contextMenu').css('display')=='block' || $('#contextMenu').css('display')=='inline-block') $('#contextMenu').hide();
		if (grid.Col == grid.ColIndex('attachcnt')) {
			opener.fileInfoViewer( grid.Row, grid );
		}else if (grid.Col == grid.ColIndex('user')) {
			opener.userInfoViewer( grid.Row, 'user', grid );
		}else if (grid.Col == grid.ColIndex('sender')) {
			opener.userInfoViewer( grid.Row, 'sender', grid );
		}else if (grid.Col == grid.ColIndex('recvs')) {
			if(grid.getValue(grid.Row, 'recvs') == '') return;
			opener.userInfoViewer( grid.Row, 'recvs', grid);
		}else if (grid.Col == grid.ColIndex('to')) {
			if(grid.getValue(grid.Row, 'to') == '') return;
			opener.userInfoViewer( grid.Row, 'to', grid);
		}else if (grid.Col == grid.ColIndex('cc')) {
			if(grid.getValue(grid.Row, 'cc') == '') return;
			opener.userInfoViewer( grid.Row, 'cc', grid);
		}else if (grid.Col == grid.ColIndex('bcc')) {
			if(grid.getValue(grid.Row, 'bcc') == '') return;
			opener.userInfoViewer( grid.Row, 'bcc', grid);
		}else if(grid.Col == grid.ColIndex('pi_total')) {
			opener.regexpInfoViewer(grid.Row, grid);
		}else if(grid.Col == grid.ColIndex('referer_url')) {
			var referer_url = grid.getValue(grid.Row, 'referer_url');
			if(referer_url=='N') return;
			fnOpenWindow(referer_url, '', 1024, 800, 'resize');
		}else if (grid.Col == grid.ColIndex('ocr_attach_cnt')) {
			opener.ocrFileInfoViewer( grid.Row, grid );
		}
	};
}

function viewer_open( row, selectedGrid ){
	var msgid = grid.getValue(row, 'msgid');
	var bodySize = grid.getValue(row, 'bodySizeStr');
	var bodySizeNum = bodySize.substr(0, bodySize.indexOf(' ')); 
	openMessageBodyPop( grid.id, msgid, '', bodySizeNum);
	
	var readYn = grid.getValue(row, 'readYn');
	grid.setValue(row, grid.ColIndex('readYn'), 'Y');
	grid.Select(row,0);
}

function arrayToString(rtnVal) {
	var arrayString = "";
	if(rtnVal) {
		for(var i = 0; i < rtnVal.length; i++) {
			arrayString += "," + rtnVal[i];
		}
	} else arrayString = "";
	
	return arrayString;
}

function highlightSearchStr(rtnVal, column){
	var rtnValue = '';
	try{
		var searchType = parent.$('#searchField').val();
		var searchStr = parent.$('#searchStrInput').val();

		if(column != "subject") {
			rtnVal = rtnVal.replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
		}
		
		if(searchStr == "") {
			return rtnVal;
		}
		
		var chk = false;
		
		if(searchType == "") {
			chk = true;
		} else if (searchType == "sender_str" || searchType == "sname"){
			if(column == "sender") chk = true;
		} else if (searchType == "recvs" || searchType == "recvs_name"){
			if(column == "recvs" || column == "to" || column == "cc" || column == "bcc") chk = true;
		} else if (searchType == "to tname"){
			if(column == "to" || column == "column") chk = true;
		} else if (searchType == "cc tname"){
			if(column == "cc" || column == "column") chk = true;
		} else if (searchType == "bcc tname"){
			if(column == "bcc" || column == "column") chk = true;
		} else if (searchType == "body"){
			if(column == "subject" ) chk = true;
		} else if (searchType == "attachname attachname_str"){
			if(column == "attachname" ) chk = true;
		} else {
			if(searchType == column) chk = true;
		}	
	
		var search = parent.$('#searchStrInput').val();
		if(chk) {
			var searchArray = [];
			
			search = search.trim();
			
			if(search.indexOf("\"") == 0 && search.charAt(search.length-1) == "\"" && nvl(search.match(/"/g)).length == 2) {
				searchArray[0] = search.substring(1, search.length-1);
			} else {
				search = search.replaceAll('\\|',' ');
				search = search.replaceAll("\\+", "").replaceAll("\\*", "").replaceAll("\\?", "");
				search = search.replaceAll("\"", "");
				searchArray = search.split(" ");
			}
			var obj = $.parseHTML('<div>'+rtnVal+'</div>');
			for(var i = 0; i < searchArray.length; i++) {
				var searchStr =  searchArray[i];
				if( searchStr == ' ' || searchStr == '') continue;
				$(obj).highlight(searchStr, 'S');
			}
			
			rtnValue =  $(obj).html();
		} else {
			rtnValue =  rtnVal;	
		}
		
	} catch(e){
		rtnValue =  rtnVal;
		console.log("highlightSearchStr Error..");
	}
	return rtnValue;
}


function highlightKeyword (rtnVal, keyWords) {
	var rtnValue = '';
	try{
		var obj = $.parseHTML('<div>'+rtnVal+'</div>');
		for(var i = 0; i < keyWords.length; i++) {
			var keyWord = keyWords[i];
			$(obj).highlight(keyWord, 'K');
		}
		rtnValue = $(obj).html();
	}catch(e){
		rtnValue =  rtnVal;
		console.log("highlightKeyword Error..");
	}
	
	return rtnValue;
}


jQuery.fn.highlight = function(pat, type) {
	function innerHighlight(node, pat, type) {
		var skip = 0;
		if (node.nodeType == 3) {
			var pos = node.data.toUpperCase().indexOf(pat);
			if (pos >= 0) {
				var spannode = document.createElement('span');
				if ( type.indexOf('K') > -1) {
					spannode.className = 'highlightKeyword';
				}
				else {
					spannode.className = 'highlightSearch';
				}
				if ( type.indexOf('B') > -1 ) {
					if ( type.indexOf('K') > -1) {
						spannode.style.backgroundColor = '#ccc';
						spannode.style.color = '#000000';
						spannode.style.fontWeight = 'bold';
					} else {
						spannode.style.backgroundColor = '#eee';
						spannode.style.color = '#000000';
						spannode.style.fontWeight = 'bold';
					}
				}

				var sbit = node.splitText( pos );
				sbit.splitText( pat.length );
				spannode.nodeValue = sbit.data;
				var sbitclone = sbit.cloneNode(true);
				spannode.appendChild(sbitclone);
				sbit.parentNode.replaceChild(spannode, sbit);
				skip = 1;
			}
		} else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
			for ( var i = 0; i < node.childNodes.length; ++i) {
				i += innerHighlight(node.childNodes[i], pat, type);
			}
		}
		return skip;
	}
	return this.each(function() {
		innerHighlight(this, pat.toUpperCase(), type);
	});
};

function moveMsgBtn(){
	saveFolderDataGrid(grid);
	if($('#contextMenu').css('display')=='block' || $('#contextMenu').css('display')=='inline-block') $('#contextMenu').hide();
}

function prevMsg( ) {
	var row = 0;
	if( grid.Row > 0 ) {
		row = --grid.Row;
		viewer_open(row);
		grid.Select(row,0);
		return true;
	}
	return false;
}

function nextMsg( ) {
	var row = 0;
	if( grid.Row < grid.Rows - 1 ) {
		row = ++grid.Row;
		viewer_open(row);
		grid.Select(row,0);
		if( grid.Row == grid.Rows - 2  ){
			return false;
		}
		return true;
	}
	return false;
}

function viewer_newOpen(row, selectedGrid){
	var msgid = grid.getValue(row, 'msgid');
	var bodySize = grid.getValue(row, 'bodySizeStr');
	var bodySizeNum = bodySize.substr(0, bodySize.indexOf(' '));
	
	openMessageBodyPop( '', msgid, '',bodySizeNum);
}
</script>
</head>
<body class="mini-navbar msgBody">
	<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="filterInfo.messageFolder"/></span>
		</div>
	</header>
	<div class="xcn_container" style="min-width: 650px;">
		<div class="boxArea">
			<div class="content_body">
				<div class="row">
					<div class="col-xs-12 text-right">
						<button type="button" class="btn btn-sm btn-default" onclick="moveMsgBtn();"><span class="glyphicon glyphicon-transfer"></span>&nbsp;<s:message code="filterInfo.moveMsgFolder"/></button>
						<button type="button" class="btn btn-sm btn-default deleteUserFolderMsg" onclick="deleteFolderData('<s:message code="common.msg.choose.deleteitem"/>');"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="filterInfo.delMsgFolder"/></button>
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="gridTabList" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Back to top -->
	<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>
	<iframe id="ExcelDown" name="ExcelDown" src="about:blank;" style="display: none;" height="0" width="0" ></iframe>
	<div class="modal fade" id="exportDialog" tabindex="-1" role="dialog" aria-labelledby="exportDialog">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title" id="exportTitle">&nbsp;</h3>
				</div>
				<div class="modal-body">
					<div class="form-inline">
						<div class="content_body" style="height:100%;padding-top: 0;">
							<table class="table borderless" style="margin-bottom:0;width:100%;">
								<colgroup>
									<col width="200">
									<col width="*">
								</colgroup>
								<tr>
									<th>
										¤ <s:message code="download.msg.dataArea"/>
									</th>
									<td>
										<div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
											<label class="btn btn-sm btn-default"><input type="radio" name="exportDataRange" id="exportDataSelect" value="S"> <s:message code="download.msg.select.count"/></label>
											<%-- <label class="btn btn-sm btn-default active"><input type="radio" name="exportDataRange" id="exportDataAll" value="A" checked> <s:message code="download.msg.search.count"/></label> --%>
										</div>
									</td>
								</tr>
								<tr id="exportFileTypeArea">
									<th>
										¤ <s:message code="download.msg.fileType"/>
									</th>
									<td>
										<div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
											<label class="btn btn-sm btn-default active"><input type="radio" name="exportFileType" id="exportExcel" value="xlsx" checked> <s:message code="common.msg.excel"/>(xlsx)</label>
											<label class="btn btn-sm btn-default"><input type="radio" name="exportFileType" id="exportHancel" value="cell"> <s:message code="common.msg.hancel"/>(cell)</label>
											<label class="btn btn-sm btn-default"><input type="radio" name="exportFileType" id="exportText" value="csv"> <s:message code="common.msg.text"/>(csv)</label>
											<label class="btn btn-sm btn-default"><input type="radio" name="exportFileType" id="exportPdf" value="pdf"> <s:message code="selectCodeAll.list"/>(PDF)</label>
										</div>
									</td>
								</tr>
								<tr>
									<th>
										¤ <s:message code="download.msg.export.count"/>
									</th>
									<td>
										<span id="exportDataSize" style="line-height:32px;">0</span>
									</td>
								</tr>
							</table>
							<table class="table table-bordered" style="margin-bottom:0;width:100%;margin-top:15px;" id="sizeWarnMsg">
								<colgroup>
									<col width="200">
									<col width="*">
								</colgroup>
								<tr style="font-weight: bold;">
									<td colspan="2">
										<s:message code="download.msg.warn" arguments="50,000" argumentSeparator="|"/>
									</td>
								</tr>
								<tr style="font-weight: bold;">
									<th>
										<label for="ruleFile" class="control-label" style="vertical-align: bottom;line-height:35px;">¤ <s:message code="download.msg.file.count"/></label>
									</th>
									<td>
										<select id="dataLength_select" class="selectpicker" data-style="btn-default">
											<option value="20000">20,000</option>
											<option value="30000">30,000</option>
											<option value="40000">40,000</option>
											<option value="50000" selected>50,000</option>
											<option value="100000">100,000</option>
										</select>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="allDownBtn"><s:message code="common.msg.export"/></button>
				</div>
			</div>
		</div>
		<iframe id="upload_file" name="upload_file" src="" style="display: none;"></iframe>
	</div>
	
	<script type="text/javascript">
	LoadInnoFD( 1, 1 ); 
	</script>
	<form action="<c:url value="/downEmassAttachByMsgId.xcn"/>" target="ExcelDown" method="post" id="downForm">
		<input type="hidden" name="msgIds" id="msgIds">
		<input type="hidden" name="msgId" id="msgId">
	</form>
	<form action="<c:url value="/getEmassMessageSaveZip.xcn"/>" target="ExcelDown" method="post" id="allDownForm">
		<input type="hidden" name="searchTime" id="searchTime">
		<input type="hidden" name="searchCondition" id="searchCondition">
		<input type="hidden" name="searchHeader" id="searchHeader">
		<input type="hidden" name="searchType" id="searchType">
		<input type="hidden" name="searchTotal" id="searchTotal">
		<input type="hidden" name="dataLength" id="dataLength">
		<input type="hidden" name="exportFileExt" id="exportFileExt">
	</form>
	
	<div class="modal fade smartFolderSave" id="smartFolderSavePop" tabindex="-1" data-backdrop="static" data-keyboard="false" role="dialog" aria-labelledby="attachModal">
		<input type="hidden" id="modalFolderType"/>
		<div class="modal-dialog modal-lg" role="document" style="width:700px;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="filterInfo.moveMsgFolder"/></h3>
				</div>
				<div class="modal-body">
					<div class="form-inline" id="saveFolderPathPopDiv">
						<label for="savePathPopArea" class="control-label col-xs-2"><s:message code="condition.savepath"/></label>
						<div class="form-control" id="saveFolderPathPopArea" style="height:350px;width:500px;">
							<ul id="folderTreePop" class="ztree scrollbar" style="height:100%;width:100%;overflow:auto;"></ul>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="moveFolderBtn"><s:message code="common.msg.save"/></button>
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div id="contextMenu" style="display:none;position:absolute">
		<ul>
			<li style="background-color:#1576A1;color:#fff;font-weight: bold;cursor:default;"><s:message code="common.msg.menu"/>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close" style="font-size:15px;color:#fff;text-shadow:0 1px 0 #000; opacity:0.7;" id="contextMenuCloseBtn">
					<span aria-hidden="true">&times;</span>
				</button>
			</li>
		</ul>
		<ul>
			<li style="background-color:#999;color:#fff;font-weight: bold;cursor:default; padding-left: 5px;"><s:message code="filterInfo.management"/></li>
		</ul>
		<ul>
			<li onclick="moveMsgBtn()" style=" padding-left: 5px;"><div class="msgFolderIcon"></div>&nbsp;<s:message code="filterInfo.moveMsgFolder"/></li>
			<li onclick="deleteFolderData('<s:message code="common.msg.choose.deleteitem"/>');" style=" padding-left: 5px;"><div class="msgFolderDelIcon"></div>&nbsp;<s:message code="filterInfo.delMsgFolder"/></li>
		</ul>
	</div>
	
	<div class="adminFolder" id="rMenu" style="z-index:99999;">
		<ul>
			<li style="background-color:#1576A1;color:#fff;font-weight: bold;cursor:default;"><s:message code="filterInfo.menu.filter"/></li>
		</ul>
		<ul>
			<li id="f_folder_new" onclick="addFolderFolder();">
				<img alt="" src="<c:url value="/img/ztree/open_folder.png"/>" style="vertical-align: middle;width: 16px;">
				<span><s:message code="filterInfo.folder.new"/>(F)</span>
			</li>
			<li id="f_folder_rename" onclick="editFolderName();">
				<img alt="" src="<c:url value="/img/ztree/open_folder.png"/>" style="vertical-align: middle;width: 16px;">
				<span><s:message code="filterInfo.change.name"/>(M)</span>
			</li>
			<li id="f_folder_delete" onclick="deleteFolder();">
				<img alt="" src="<c:url value="/img/ztree/open_folder.png"/>" style="vertical-align: middle;width: 16px;">
				<span><s:message code="common.msg.delete"/>(D)</span>
			</li>
		</ul>
	</div>
</body>
</html>