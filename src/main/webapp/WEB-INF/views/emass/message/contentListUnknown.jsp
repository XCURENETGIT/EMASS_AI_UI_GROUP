<%@page import="com.xcurenet.audit.service.Operation"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	JSONObject param = Common.getParam(request);
	String gridInit = Common.nvl(param.get("gridInit"));
	String filterSeq = Common.nvl(param.get("filterSeq"));
	String conditionParam = Common.nvl(param.get("conditionParam"));
	String adminType = Common.getAdminType(session);
	String firstAdminYn = Common.getFirstAdminYn(session);

	String op_attach_save = Operation.ATTACH_SAVE.getOperation();
	String op_body_save = Operation.BODY_SAVE.getOperation();	
	
	long export_maxCount = Config.getLong("ui.export.maxCount", 1000000);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS PRO - <s:message code="DATA_MONITOR.MESSAGE_INFO"/></title>


<style type="text/css">
html, body {
	min-width: 100px !important;
}
.slick-cell {line-height: 18px;}
.slick-cell span:not(.highlightSearch,.highlightKeyword) {
	display: block;
}
.slick-cell input[type=checkbox] {
	margin-top: 2px;
}
.readY, .readN {
	background-size: 20px 17px;
	margin-top: -1px;
}
.subject_readY, .subject_readN, .slick-cell .glyphicon-new-window.new-window {
	position: relative;
	top: -4px;
}
.readY {
	margin-top: 0px;
}
.busiCounts{
	display: inline-block;color:#000;
}
.busiCounts:hover{
	color: #000 !important;
	text-decoration: underline !important;
}
.busiCounts:hover > i, .busiCounts:hover > span{
	opacity: 1 !important;
}

a.busiCounts i{
	color:#253f56
}

.tab_selected > a{
	font-weight: bold;
}

.tab_selected > a > i{
	color:#5cb85c;
}
a:hover, a:focus{
	text-decoration: none;
}

.noSearch{
	cursor:default !important;
}
.fa-angle-right {
}


.highlightSearch {
	background-color:#13C7A3;
}

.highlightKeyword {
	background-color:#FFAD5B;
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

.grid_rowcount button, .status_func button {
	background-color: #288cb3 !important;
}
</style>
</head>
<body class="mini-navbar msgBody">
	<div id="replace_html" style="display: none;"></div>
	<div class="msg_cont_container">
		<div id="mail_list" class="divList unselectable" style="width: 100%; height: 100%; display: block;position: absolute;top: 0;left: 0;bottom: 0;">
			<div style="height: 100%;">
				<div id="busiCntArea" style="height: 30px; line-height: 30px; padding-left: 5px;padding-right: 15px;">
					<span class="tab_selected noSearch"><a href="javascript:;" class="busiCounts active" data-busicd=""><i class="fa fa-angle-right" aria-hidden="true"></i> <s:message code="common.msg.all"/></a></span>
				</div>
				<div id="messageNewGridUnknown" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px;min-height:200px;height:calc(100% - 60px);"></div>
				<input type="hidden" id="searchTime" />
			</div>
		</div>
	</div>
	<input type="hidden" id="searchStrInput" />
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
			<li onclick="saveMsgBtn()" style=" padding-left: 5px;"><div class="msgFolderIcon"></div>&nbsp;<s:message code="filterInfo.setMsgFolder"/></li>
		</ul>
		<ul>
			<li style="background-color:#999;color:#fff;font-weight: bold;cursor:default; padding-left: 5px;"><s:message code="condition.feedback"/> <s:message code="common.msg.setting"/></li>
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
</body>
<script type="text/javascript">
var gridInit = "<%=gridInit%>";
var filterValData;
var busiScrollTabs;
var tabId='';
var tabType;
var searchedFlag = false;
var pageType = 'U';

$(document).ready(function() {
	document.onclick = function(e){ parent.$('.dropdown-backdrop').click(); }
	
	$('#contextMenuCloseBtn').click(function(){
		$('#contextMenu').hide();
	});
	var msgBodyObj = parent.document.getElementsByClassName('msgBody');
	var conObj = parent.getIframeBodyObj();
	$(conObj,msgBodyObj).click(function(){
		if($('#contextMenu').css('display')=='block')$("#contextMenu").hide();
	});
	$(msgBodyObj).click(function(){
		if($('#contextMenu').css('display')=='block')$("#contextMenu").hide();
	});
	
	initServiceTab();
	setTimeout(function(){parent.ui.off();}, 500)
	if(gridInit == 'true') initGrid();
	
	parent.setAddTabFlag(false);
	parent.readyFlag = true;
});

function saveMsgBtn(){
	parent.$('#saveMsgData').click();
	$('#contextMenu').hide();
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

function initServiceTab(){
	if( busiScrollTabs != undefined) busiScrollTabs.destroy();
	busiScrollTabs = $('#busiCntArea').scrollTabs({
		//scroll_distance: 300,
		//scroll_duration: 300,
		//left_arrow_size: 26,
		//right_arrow_size: 26,
		click_callback: function(e){
			getSubList('', $(this).find('.busiCounts').attr('data-svc12'), $('#searchTime').val() );
		}
	});
}


/**
 * 데이터 조회
 */
var searchFlag=true;
var bodysnippetVal = '';
var summaryVal = '';
function getList(flag, filterVal){
	if(!searchFlag) return;
	searchFlag = false;
	var researchCnt = 0;
	
	if ( flag == undefined || flag == '') {
		if(tabType=='D' && parent.$("input:checkbox[id='researchCheckbox']").is(":checked")) {
			researchCnt = filterValData.conditions.length-1;
		}
		filterValData = filterVal;
		
		grid.data.length = 0;
		grid.rtnNextPageFunc = getList;
		grid.loadingPage = 0;
	} else {
		grid.loadingPage++;
	}
	
	grid.on();

	/* 검색 데이터 전송 객체 */
	var searchData = {
		filterData : filterValData
		,pageType : pageType
		,offset : grid.data.length + grid.overlapData.length
		,limit : grid.pageSize
		,overlap : overlapUse
	}

	ui.postJson({
		url : 'getList.xcn',
		searchData : JSON.stringify( searchData ),
		success : function(data, total) {
			searchedFlag = true;
			grid.appendData(data.emass);
			if ( grid.loadingPage == 0 ) grid.Select(-1,-1);
			
			parent.setResultCnt(tabId, total.comma());
			parent.changeTabName(tabId, '', researchCnt);
			setServiceGroupCntInfo(data.facet, total);
			$('#searchTime').val(data.searchTime);
			
			var query = filterValData.conditions[0].query;
			if( query != '' && query != undefined){
				parent.$('#researchCheckbox').prop('disabled', true);
			}else{
				parent.$('#researchCheckbox').prop('disabled', false);
			}

			
			//parent.setValueById('solrQueryText', data.excuteQuery);
			
			/* selectedTab.find('.resultCnt').html('('+addCommas(total)+')');
			selectedTab.find('.resultCntHidden').html(total);
			$('#'+obj.contentId).find('.solrQueryResultText').val(data.excuteQuery);
			
			selectedTab.find('img').css('display', 'none');
			rsKey[selectedTabIdx].total = total;
			rsKey[selectedTabIdx].searchTime = data.searchTime;
			
			if($('#'+rsKey[selectedTabIdx].contentId).find('.tabValue').attr('data-filterType') == 'Q') $('#researchCheckbox').prop('disabled', true);
			else $('#researchCheckbox').prop('disabled', false); */
		},
		error : function(status, message) {
			alert(message);
		},
		complete : function() {
			grid.off();
			searchFlag = true;
		}
	});
	
}

var searchSubFlag=true;
function getSubList(flag, svc12, searchTime){
	if(!searchSubFlag) return;
	searchSubFlag = false;

	if ( flag == undefined || flag == '') {
		filterValData.addSvcGroup = svc12;
		filterValData.searchTime = searchTime;
		
		grid.data.length = 0;
		grid.rtnNextPageFunc = getSubList;
		grid.loadingPage = 0;
	} else {
		grid.loadingPage++;
	}
	//changTabHeader(obj.data);
	
	grid.on();
	ui.postJson({
		url : 'getList.xcn',
		data : JSON.stringify( filterValData ),
		pageType : pageType,
		offset : grid.data.length,
		limit : grid.pageSize,
		success : function(data, total) {
			grid.appendData(data.emass);
			if ( grid.loadingPage == 0 ) grid.Select(-1,-1);
			
			parent.setValueById('solrQueryText', data.excuteQuery);
		},
		error : function(status, message) {
			alert(message);
		},
		complete : function() {
			grid.off();
			searchSubFlag = true;
		}
	});
	
}

function setServiceGroupCntInfo(data, total){
	busiScrollTabs.clearTabs();
	busiScrollTabs.refreshState();
	busiScrollTabs.addTab('<span class="tab_selected"><a href="javascript:;" class="busiCounts active" data-svc12=""><i class="fa fa-angle-right" aria-hidden="true"></i> <s:message code="common.msg.all"/><span class="busiCnt">('+total.comma()+')</span></a></span>');
	for(var i=0; i<data.length; i++){
		busiScrollTabs.addTab('<span><a href="javascript:;" class="busiCounts" data-svc12="'+data[i].name2+'"><i class="fa fa-angle-right" aria-hidden="true"></i> '+parent.getSvc12Nm(data[i].name2)+'<span class="busiCnt">('+data[i].count.comma()+')</span></a></span>'); 
	}
}

function arrayToString( array ){
	if( array == null || array == undefined ) return "";
	else{
		return array.toString();
	}
}
function highlightSearchStr(rtnVal, column){
	var rtnValue = '';
	try{
		
		var searchType = '';
		var searchStr = '';
		var search = '';
		
		if(tabType == 'D') {
			searchType = parent.$('#searchField').val();
		}
		searchStr = searchKeyword();
		search = searchStr;
		
		if(column != "subject") {
			rtnVal = rtnVal.replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
		}
		if(searchStr == "") {
			return rtnVal;
		}
		var chk = false;
		if(searchType == "" || searchType == null) {
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
		} else if (searchType == "subject"){
			if(column == "subject" ) chk = true;
		} else if (searchType == "body"){
			if(column == "body" ) chk = true;
		} else if (searchType == "attachname attachname_str"){
			if(column == "attachname" ) chk = true;
		} else {
			if(searchType == column) chk = true;
		}
		
		if(chk) {
			var searchArray = [];
			
			search = search.trim();
			if(search.indexOf("\"") == 0 && search.charAt(search.length-1) == "\"" && nvl(search.match(/"/g)).length == 2) {
				searchArray[0] = search.substring(1, search.length-1);
			} else {
				search = search.replaceAll('\\|',' ');
				search = search.replaceAll("\\+", "").replaceAll("\\*", "").replaceAll("\\?", "");
				search = search.replaceAll("\"", "");
				search = search.replaceAll("\\(", "").replaceAll("\\)","");
				searchArray = search.split(" ");
			}
			var obj = $.parseHTML('<div>'+rtnVal+'</div>');
			for(var i = 0; i < searchArray.length; i++) {
				var searchStr =  searchArray[i];
				if(!(searchStr.substr(0,1) == '/' && searchStr.substr(searchStr.length - 1) == '/')) {
					searchStr = searchStr.replaceAll("\\(","").replaceAll("\\)","");
					if( searchStr == ' ' || searchStr == '') continue;
					$(obj).highlight(searchStr, 'S');
					rtnValue =  $(obj).html();
				}
				else {
					var solrQueryText = searchStr.replaceAll('/','');
					var re = new RegExp(solrQueryText, 'ig');
					var matchArray;
					var first = 0;
					var last = 0;
					var resultString = '';
					
					while ( (matchArray = re.exec(rtnVal)) != null ) {
						last = matchArray.index;

						// 일치하는 모든 문자열을 연결
						resultString += rtnVal.substring(first, last);

						// 일치하는 부분에 강조 스타일이 지정된 class 추가
						resultString += "<span class='highlightSearch'>" + matchArray[0] + "</span>";
						first = re.lastIndex;
						// RegExp객체의 lastIndex속성을 이용해 검색 결과의 마지막인덱스 접근 가능
					}
					resultString += rtnVal.substring(first, rtnVal.length);
					rtnVal = resultString;
					rtnValue = resultString;
				}
			}
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

function regexpInfoViewer(row, selectedGrid){
	var msgid = grid.getValue(row, 'msgid');
	if(grid.getValue(row, 'pi_total') == '') return;
	
	var url = '<c:url value="/ems/regexpInfoPop.do?msgId='+msgid+'"/>';
	return fnOpenWindow(url, 'regexpInfoPop', 1100, 620, 'resize');
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

function fileInfoViewer( row, selectedGrid ){
	var msgid = grid.getValue(row, 'msgid');
	if(grid.getValue(row, 'attachcnt') == '') return;
	
	var url    = '<c:url value="/ems/fileInfoPop.do?msgId='+msgid+'&searchKey=' + encodeURI(searchKeyword()) + '"/>';
	var pop = fnOpenWindow(url, 'fileInfoPop', 1015, 400, 'resize');
}

function ocrFileInfoViewer( row, selectedGrid ){
	var msgid = grid.getValue(row, 'msgid');
	if(grid.getValue(row, 'ocr_attach_cnt') == '') return;
	
	var url    = '<c:url value="/ems/fileInfoPop.do?msgId='+msgid+'&searchKey='+ encodeURI(searchKeyword()) +'"/>';
	var pop = fnOpenWindow(url, 'ocrFileInfoPop', 1015, 400, 'resize');
}

/**
 * 기본검색의 검색어와, 고급검색어의 검색어를 구분하여 반환한다.
 * 하일라이팅을 위한 처리
 */
function searchKeyword() {
	return tabType == 'D' ? parent.$('#searchStrInput').val() : parent.$('#searchQueryStrInput').val();
}

function viewer_open( row, selectedGrid ){
	var msgid = grid.getValue(row, 'msgid');
	if(parent){
		var obj = parent.getIframeBodyObj();
		obj.getMessage(msgid, searchKeyword());
		obj.$('#detailPatternDiv, #imgPreviewDiv').hide();
		obj.initHighlight();
	}else{
		openMessageBodyUnknownPop( grid.id, msgid, searchKeyword());
	}
	var readYn = grid.getValue(row, 'readYn');
	grid.setValue(row, grid.ColIndex('readYn'), 'Y');

}

var popWin;
function viewer_openPop( row, selectedGrid ){
	var msgid = grid.getValue(row, 'msgid');
	
	popWin = openMessageBodyUnknownPop( grid.id, msgid, searchKeyword());
	
	var readYn = grid.getValue(row, 'readYn');
	grid.setValue(row, grid.ColIndex('readYn'), 'Y');
}

function viewer_openFocus(row, selectedGrid ){
	if(popWin){
		var msgid = grid.getValue(row, 'msgid');
		popWin.getMessage(msgid, searchKeyword());
	}
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

function viewer_newOpen(row, selectedGrid){
	var msgid = grid.getValue(row, 'msgid');
	openMessageBodyUnknownPop( '', msgid, searchKeyword());
	
	var readYn = grid.getValue(row, 'readYn');
	grid.setValue(row, grid.ColIndex('readYn'), 'Y');
}

function setReadDisplayChangeRootmtr( rootmtr ){
	setReadDisplayChangeRootmtr( rootmtr, null);
}

function setReadDisplayChangeRootmtr( rootmtr, srcip){
	for( var i=0; i<grid.Rows; i++ ){
		if( grid.getValue(i, 'xrootmtr') == rootmtr){
			if( srcip != null && grid.getValue(i, 'srcip') ==  srcip){
				grid.setValue(i, grid.ColIndex('readYn'), 'Y');
			}
		}
	}
}

function prevMsg( ) {
	var row = 0;
	if( grid.Row > 0 ) {
		row = --grid.Row;
		
		/* if(popWin) viewer_openFocus(row);
		else viewer_open(row); */
		
		grid.Select(row, grid.Col);
		return true;
	}
	return false;
}

function nextMsg( ) {
	var row = 0;
	if( grid.Row < grid.Rows - 1 ) {
		row = ++grid.Row;

		/* if(popWin) viewer_openFocus(row);
		else viewer_open(row); */
		
		grid.Select(row, grid.Col);
		if( grid.Row == grid.Rows - 2  ){
			getList( true );
		}
		return true;
	}
	return false;
}

function alert(msg){
	parent.alert(msg);
}

var grid;
function initGrid(){
	if( grid != undefined ) return;
	
	grid = new Xgrid('messageNewGridUnknown', contextRoot, 20);
	grid.onCheckBox();
	grid.autoNumber();
	grid.colAdd('msgid', '<s:message code="common.msg.msgid"/>', 100, 'left', false, 'nomal');
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
	grid.colAdd('readYn', '<s:message code="condition.read"/>', 40, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
		if (value == 'Y') return '<div class="readY"></div>';
		else if (value == 'N') return '<div class="readN"></div>';
		else return '-';
	});
	
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
	
	grid.colAdd('svcLv2Nm', '<s:message code="condition.service"/>', 100, 'center', false, 'nomal');
	grid.colAdd('url', 'HOST/Path', 410, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
		var host = grid.getValue(row, 'host');
		var path = grid.getValue(row, 'path');
		var hostData = host + path;
		if(hostData.indexOf('http://') > -1 ) hostData = path;
		
		var rtnVal = '<span title="'+hostData+'" onclick="" class="subject_read'+grid.getValue(row, 'readYn')+'">'+hostData+'</span>&nbsp;<a href="javascript:void(0);" onclick="viewer_newOpen('+row+')" class="glyphicon glyphicon-new-window new-window"></a>';
		if( (isConsent( ) && grid.getValue(row, 'consentNo') == '') || !isDetailView() ) rtnVal = '<span>'+hostData+'</span>';
		
		return rtnVal;
	}); 
	
	grid.colAdd('host', 'HOST', 150, 'left', true, 'nomal', function(row, cell, value, columnDef, dataContext) {
		var rtnVal = '<span title="'+value+'" onclick="" class="subject_read'+grid.getValue(row, 'readYn')+'">'+value+'</span>&nbsp;<a href="javascript:void(0);" onclick="viewer_newOpen('+row+')" class="glyphicon glyphicon-new-window new-window"></a>';
		if( (isConsent( ) && grid.getValue(row, 'consentNo') == '') || !isDetailView() ) rtnVal = '<span>'+value+'</span>';
		return rtnVal;
	});
	grid.colAdd('path', 'PATH', 280, 'left', true, 'nomal', function(row, cell, value, columnDef, dataContext) {
		var rtnVal = '<span title="'+value+'" onclick="" class="subject_read'+grid.getValue(row, 'readYn')+'">'+value+'</span>';
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
	grid.colAdd('recvsStr', '<s:message code="condition.recv"/>', 220, 'left', false, 'link', function(row, cell, value, columnDef, dataContext) {
		return highlightSearchStr(value, "recvs");
	}, {sorter:sortUtil.inout});
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
	
	grid.loadHeader(true);
	grid.loadPageSize();
	grid.initData('<s:message code="common.msg.search.click"/>');
	
	//writeExportMenu('export_menu'+idx, gridId, '<s:message code="DATA_MONITOR.MESSAGE_INFO"/>', '<s:message code="common.msg.select"/>&nbsp;');
	
	//grid.initData('검색 조건을 설정 후 검색 버튼을 클릭하시기 바랍니다.');
	grid.onContextMenu = function(row, col, e){
		return false;
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
	grid.changePageSize = function(cnt){
		parent.getList();
	};
	grid.onDblClick = function(){
		viewer_openPop(grid.Row);
	}
	grid.onActiveRowChanged = function(){
		if( !(adminMenu != "ALL" && adminMenu.indexOf("DV") < 0) ) {
			if(!parent.$('#none_btn').hasClass('areaSelected')) viewer_open(grid.Row);
			if(popWin) viewer_openFocus(grid.Row);
		} else {
			alert('<s:message code="message.auth.no.detailview"/>');
			return;
		}
	}
	
}
</script>
</html>