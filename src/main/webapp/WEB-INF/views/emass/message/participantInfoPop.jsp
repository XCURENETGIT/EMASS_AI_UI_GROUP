<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	JSONObject param = Common.getParam ( request );
	String xrootmtr = Common.nvl( param.get("xrootmtr"));
	String srcip = Common.nvl( param.get("srcip"));
	String usr_id = Common.nvl( param.get("usr_id"));
	String startDt = Common.nvl( param.get("startDt"));
	String endDt = Common.nvl( param.get("endDt"));
	String searchStr = Common.nvl( param.get("searchStr"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LT - <s:message code="common.msg.participantinfo"/></title>
<%@ include file="../../base.jsp"%>
<script type="text/javascript" src="<c:url value="/js/InnoFD.js"/>"></script>
<style type="text/css">
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
.attachExt{
	cursor:pointer;
}
</style>
<script type="text/JavaScript">
var xrootmtr = '<%=xrootmtr%>';
var usr_id = '<%=usr_id%>';
var srcip = '<%=srcip%>';
var startDt = '<%=startDt%>';
var endDt = '<%=endDt%>';
var searchStr = '<%=searchStr%>';
$(document).ready(function(){
	ui.onBody( 'content_body', 0, 0);
	
	getParticipantInfo( );
	ui.off( 'content_body' );
	$('#noSelectBtn').click(function(){ self.close();  });
});

function getParticipantInfo( flag ){
	if(xrootmtr == ''){
		grid.setData([]);
		return;
	}
	grid.on();
	ui.get({
		url : 'getMessengerGroupUserList.xcn',
		xRootMtr : xrootmtr,
		srcip: srcip,
		usr_id: usr_id,
		startDt: startDt,
		endDt: endDt,
		searchStr: searchStr,
		groupField: 'sender_str',
		success : function(data, total) {
			grid.setData(data.groups);
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
<body class="mini-navbar msgBody">
	<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="common.msg.participantinfo"/></span>
		</div>
	</header>
	<div class="xcn_container" style="min-width: 650px;">
		<div class="boxArea">
			<div class="content_body">
				<div class="row">
					<div class="col-xs-12 text-right">
						<button type="button" class="btn btn-sm btn-primary" accesskey="C" id="saveBtn" style="display: none;"><span class="fa fa-check"></span>&nbsp;<s:message code="common.msg.save"/></button>
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="participantGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
			var grid = new Xgrid('participantGrid', contextRoot);
			grid.autoNumber();
			/* grid.colAdd('srcIpList', '<s:message code="condition.source"/> IP', 250, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == null) return '-'; 
				else{
					var str = '';
					console.log(value)
					for(var i=0; i<value.length; i++){
						str += Object.keys(value[i]);
						if(i!=value.length-1) str +=', ';
					}
					return str;
				}
			}); */
			/* grid.colAdd('user', '<s:message code="common.org.user"/>', 250, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == null) return '-'; 
				else return value;
			}); */
			grid.colAdd('usr_id', 'ID', 250, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == null) return '-'; 
				else return value;
			});
			grid.colAdd('sname', '<s:message code="common.msg.name"/>', 180, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == null) return '-'; 
				else return value;
			});
			grid.onClick = function() {
				/* if (grid.Col == grid.ColIndex('code')) {
					setSelectedData();
				} */
			};
			grid.loadHeader(false);
			grid.initData('<s:message code="common.msg.search.click"/>');
		</script>
</body>
</html>