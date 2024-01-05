<%@page import="net.sf.json.JSONObject"%>
<%@ include file="/WEB-INF/fragments/popupScript.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	JSONObject param = Common.getParam ( request );
	String msgId = Common.nvl( param.get("msgId"));
	String type = Common.nvl( param.get("type"));
	String inOutInfo = Common.nvl( param.get("inOutInfo"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS PRO - <s:message code="common.msg.userinfo"/></title>
<style type="text/css">
html,body{
	height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
.attachExt{
	cursor:pointer;
}
</style>
<script type="text/JavaScript">
var msgId = '<%=msgId%>';
var type = '<%=type%>';
var inOutInfo = '<%=inOutInfo%>';
$(document).ready(function(){
	getUserInfo( );
	$('#noSelectBtn').click(function(){ self.close();  });
});

function getUserInfo( flag ){
	var uType = '';
	if( type == 'sender') uType = "'F'";
	else if( type == 'recvs') uType = "'T','C','B'";
	else if( type == 'to') uType = "'T'";
	else if( type == 'cc') uType = "'C'";
	else if( type == 'bcc') uType = "'B'";
	else if( type == 'user') uType = "'U'";

	grid.on();
	ui.get({
		url : 'getEmassUserInfo.xcn',
		msgId : msgId,
		uType : uType,
		offset : grid.data.length,
		limit : grid.pageSize,
		success : function(data, total) {
			setInOutCount( data);
			grid.appendData(data);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		    grid.off();
		}
	});
}
function setInOutCount( data){
	var incount = 0;
	var outcount = 0;
	for(var i=0; i<data.length; i++){
		if(data[i].inSide == 'N') outcount++;
		else incount++;
	}
	
	$('#outCount').text(outcount);
	$('#inCount').text(incount);
}
</script>
</head>
<body>
	<!--<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="common.msg.userinfo"/></span>
		</div>
	</header>-->

	<div class="xcn_container" style="min-width: 650px;">
		<div class="boxArea" style="min-height:inherit;">
			<div class="content_body">
				<div class="row p20">
					<h2><span class="bullet02"></span><s:message code="common.msg.userinfo"/></h2>
					<div class="xcn_pop_btn">
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
					</div>
					<div class="mat16" style="height: 100%;">
						<div id="userGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
			var grid = new Xgrid('userGrid', contextRoot);
			grid.autoNumber();
			grid.colAdd('inSide', '<s:message code="message.msg.inout"/>',120, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == 'Y') return '<s:message code="message.msg.in"/>';
				else return '<s:message code="message.msg.out"/>';
			});
			grid.colAdd('utype', '<s:message code="common.msg.information"/>', 80, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == 'U') return '<s:message code="consent.user"/>';
				else if (value == 'F') return '<s:message code="condition.sender"/>';
				else if (value == 'T') return '<s:message code="condition.to"/>';
				else if (value == 'C') return '<s:message code="condition.cc"/>';
				else if (value == 'B') return '<s:message code="condition.bcc"/>';
				else return '-';
			});
			grid.colAdd('recvId', 'ID', 150, 'left', false, 'nomal');
			grid.colAdd('name', '<s:message code="common.msg.name"/>', 80, 'center', false, 'nomal');
			grid.colAdd('ip', 'IP', 90, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == null) return '-'; 
				else return value;
			});
			grid.colAdd('email', 'EMAIL', 200, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == null) return '-'; 
				else return value;
			});
			
			grid.colAdd('jikgubNm', '<s:message code="common.org.jikgub"/>', 80, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == null) return '-'; 
				else return value;
			});
			grid.colAdd('deptNm', '<s:message code="common.org.dept"/>', 100, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == null) return '-'; 
				else return value;
			});
			grid.colAdd('busiNm', '<s:message code="common.org.busi"/>', 100, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == null) return '-'; 
				else return value;
			});
			grid.colAdd('coNm', '<s:message code="common.org.co"/>', 100, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == null) return '-'; 
				else return value;
			});
			grid.onClick = function() {
				if (grid.Col == grid.ColIndex('code')) {
					setSelectedData();
				}
			};
			grid.loadHeader(false);
			grid.initData('<s:message code="common.msg.search.click"/>');
		</script>
</body>
</html>