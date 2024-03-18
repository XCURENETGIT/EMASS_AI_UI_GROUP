<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%@page import="com.xcurenet.emass.message.service.SolrEdcVO"%>
<%@ include file="/WEB-INF/fragments/popupScript.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%
	JSONObject param = Common.getParam ( request );
	JSONArray overLapdata = Common.toJSONArray(param.get("body"));
	List<SolrEdcVO> emass = new ArrayList<SolrEdcVO>(overLapdata);
	int total = Common.nvz(param.get("total"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS AI - <s:message code="message.overlap.poptitle"/></title>
<style type="text/css">
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {
	border: 0px;
}
.slick-cell {line-height: 18px;}
.slick-cell span:not(.highlightSearch,.highlightKeyword) {
	display: block;
}
.slick-cell input[type=checkbox] {
	margin-top: 2px;
}
#subjectVal, #senderVal {
	display: inline-block;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	position: relative;
    top: 5px;
}

.ocTitle {
	display: inline-block;
}
</style>
<script>
var searchFlag = false;
var infoFeedbackYn = '<%=infoFeedbackYn%>';
var infoFeedbackConf = '<%=infoFeedbackConf%>';
var total = '<%=total%>';
var datas = <%=emass%>;
var grid;
var limit = 100;
opener.overlapPop = this;
$(document).ready(function(){
	$('#noSelectBtn').click(function(){ self.close();  });
	$('#totalCnt').html(total.comma());
	$('#subjectVal').html(datas[0].subject);
	$('#senderVal').html(datas[0].sender);
	$('#subjectVal').attr("title", datas[0].subject);
	$('#senderVal').attr("title", datas[0].sender);
	drawGrid();
	
	setOverlapData();
	
	grid.grid.onViewportChanged.subscribe(function(scope, e, args){
		var bottom = grid.grid.getViewport().bottom;
		var rows = grid.data.length;
		if(bottom >= rows && rows > 0) {
			opener.sendOverlapData(rows, rows + limit);
		}
	});
});

function setNextBtn() {
	$(grid.target + '_statusbar .nextpage').html('');
	if ( total < 100 || grid.data.length == total) {
		$(grid.target + '_statusbar .status_count').html('Total Record: ' + grid.Rows.comma());
	} else {
		$(grid.target + '_statusbar .status_count').html('Record ' + grid.Rows.comma() + ' (scroll for more)');
		$(grid.target + '_statusbar .nextpage').html('<a href="javascript:;" id="'+grid.more_btn+'" onClick="opener.sendOverlapData(grid.data.length, grid.data.length + limit);">Next</a>');
	}
	
}

function setOverlapData(flag) {
	grid.on();
	if ( flag == undefined) {
		grid.data.length = 0;
		grid.loadingPage = 0;
        console.log(datas)
		grid.appendData(datas);
	} else {
		grid.loadingPage++;
		grid.appendData(flag);
	}
	
	grid.off();
	setNextBtn();
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
			var rows = grid.data.length;
			opener.sendOverlapData(rows, rows + limit);
		}
		return true;
	}
	return false;
}

function arrayToString( array ){
	if( array == null || array == undefined ) return "";
	else{
		return array.toString();
	}
}
function highlightSearchStr(rtnVal, column){
	var rtnValue = '';
	var QnoSearchPattern = /[\s\"?/|()+*]/;
	var DnoSearchPattern = /[+*?]/;
	try{
		
		var searchType = '';
		var searchStr = '';
		var search = '';
		
		if(tabType == 'D') {
			searchType = parent.$('#searchField').val();
		}
		searchStr = '';
		search = searchStr;
		
		if(column != "subject") {
			rtnVal = rtnVal.replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
		}
		if(searchStr == "") {
			return rtnVal;
		} else if (searchStr.length <= 2) {
			if(tabType == 'D' && DnoSearchPattern.test(searchStr)) {
				return rtnVal;
			}
			else if(tabType == 'Q' && QnoSearchPattern.test(searchStr)) {
				return rtnVal;
			}
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
	
	var url    = '<c:url value="/ems/fileInfoPop.do?msgId='+msgid+'"/>';
	var pop = fnOpenWindow(url, 'fileInfoPop', 1015, 400, 'resize');
}

function ocrFileInfoViewer( row, selectedGrid ){
	var msgid = grid.getValue(row, 'msgid');
	if(grid.getValue(row, 'ocr_attach_cnt') == '') return;
	
	var url    = '<c:url value="/ems/fileInfoPop.do?msgId='+msgid+'"/>';
	var pop = fnOpenWindow(url, 'ocrFileInfoPop', 1015, 400, 'resize');
}

function viewer_open( row, selectedGrid ){
	var msgid = grid.getValue(row, 'msgid');
	var bodySize = grid.getValue(row, 'bodySizeStr');
	var bodySizeNum = bodySize.substr(0, bodySize.indexOf(' '));
	
	openMessageBodyPop( grid.id, msgid, '', bodySizeNum);
	var readYn = grid.getValue(row, 'readYn');
	grid.setValue(row, grid.ColIndex('readYn'), 'Y');

}

var popWin;
function viewer_openPop( row, selectedGrid ){
	var msgid = grid.getValue(row, 'msgid');
	var bodySize = grid.getValue(row, 'bodySizeStr');
	var bodySizeNum = bodySize.substr(0, bodySize.indexOf(' '));
	
	popWin = openMessageBodyPop( grid.id, msgid, '', bodySizeNum);
	
	var readYn = grid.getValue(row, 'readYn');
	grid.setValue(row, grid.ColIndex('readYn'), 'Y');
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
	var bodySize = grid.getValue(row, 'bodySizeStr');
	var bodySizeNum = bodySize.substr(0, bodySize.indexOf(' '));
	
	openMessageBodyPop( '', msgid, '', bodySizeNum);
	
	var readYn = grid.getValue(row, 'readYn');
	grid.setValue(row, grid.ColIndex('readYn'), 'Y');
}

function drawGrid() {
	grid = new Xgrid('messageNewGrid', contextRoot, 20);
//	grid.onCheckBox();
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
		
		var rtnVal = '<span title="'+body_snippet+'" onclick="" class="subject_read'+grid.getValue(row, 'readYn')+'">'+value+'</span>&nbsp;<a href="javascript:void(0);" onclick="viewer_newOpen('+row+')" class="glyphicon glyphicon-new-window new-window"></a>';
		if( (isConsent( ) && grid.getValue(row, 'consentNo') == '') || !isDetailView() ) rtnVal = '<span>'+value+'</span>';
		
		return rtnVal;
	});
	grid.colAdd('ctimeFormat', '<s:message code="condition.date"/>', 130, 'center', false, 'nomal');
	grid.colAdd('user', '<s:message code="consent.user"/>', 120, 'center', false, 'link');
	grid.colAdd('usrId', '<s:message code="common.msg.account"/>', 110, 'center', false, 'nomal');
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
// 	grid.loadPageSize();
	grid.setPageSize(100);
	grid.initData('<s:message code="common.msg.search.click"/>');
	
	//writeExportMenu('export_menu'+idx, gridId, '<s:message code="DATA_MONITOR.MESSAGE_INFO"/>', '<s:message code="common.msg.select"/>&nbsp;');
	
	//grid.initData('검색 조건을 설정 후 검색 버튼을 클릭하시기 바랍니다.');
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
		
// 		if( !(adminMenu != "ALL" && adminMenu.indexOf("DV") < 0) ) {
// 			if(!parent.$('#none_btn').hasClass('areaSelected')) viewer_open(grid.Row);
// 			if(popWin) viewer_openFocus(grid.Row);
// 		} else {
// 			alert('<s:message code="message.auth.no.detailview"/>');
// 			return;
// 		}
	};
// 	grid.changePageSize = function(cnt){
// 		setOverlapData(100);
// 	};
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
</head>
<body class="mini-navbar">

	<div class="xcn_container" style="min-width: 650px;">
		<div class="boxArea">
			<div class="content_body">
				<div class="p20">
					<h2><span class="bullet02"></span> <s:message code="message.overlap.poptitle"/></h2>
						<h3 class="ocTitle"><s:message code="condition.subject"/> : <span id="subjectVal"></span></h3> &nbsp;
						</br><h3 class="ocTitle"><s:message code="condition.sender"/> : <span id="senderVal"></span> </h3>
						</br><h3><s:message code="common.overlap.count"/> : <span id="totalCnt"></span></h3>
					<div class="xcn_pop_btn">
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
					</div>
					<div class="mat16" style="height: 70%;">
						<div id="messageNewGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Back to top -->
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
										<label for="ruleFile" class="" style="vertical-align: bottom;line-height:35px;">¤ <s:message code="download.msg.file.count"/></label>
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
						<label for="savePathPopArea" class=" col-xs-2"><s:message code="condition.savepath"/></label>
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
</body>

</html>