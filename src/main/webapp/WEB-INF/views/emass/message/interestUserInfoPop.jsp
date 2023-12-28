<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>--%>
<%--<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>--%>
<%@ include file="/WEB-INF/fragments/popupScript.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	JSONObject param = Common.getParam ( request );
	String userId = Common.nvl( param.get("userid"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LTH - <s:message code="common.msg.interestuserinfo"/></title>
<style type="text/css">
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
</style>
<script type="text/JavaScript">
var userId = '<%=userId%>';
$(document).ready(function(){
	getInterestUserInfo( );
	$('#noSelectBtn').click(function(){ self.close();  });
});

function getInterestUserInfo( ){
	grid.on();
	ui.get({
		url : 'getInterestUserInfo.xcn',
		userId : userId,
		success : function(data, total) {
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
</script>
</head>
<body>
<div class="xcn_container" style="min-width: 650px;">
	<div class="boxArea" style="min-height:inherit;">
		<div class="content_body">
			<div class="row p20">
				<h2><span class="bullet02"></span><s:message code="common.msg.interestuserinfo"/></h2>
				<div class="xcn_pop_btn">
					<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
				</div>
				<div class="mat16" style="height: 100%;">
					<div id="interestuserGrid" class="slickGrid gridArea"></div>
				</div>
			</div>
		</div>
	</div>
</div>

<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="common.msg.interestuserinfo"/></span>
		</div>
	</header>


	<script type="text/javascript">
			var grid = new Xgrid('interestuserGrid', contextRoot);
			grid.autoNumber();
			grid.colAdd('groupName', '<s:message code="condition.interestGroup"/>', 150, 'left', false, 'nomal');
			grid.colAdd('userId', '<s:message code="condition.usrid"/>', 80, 'center', false, 'nomal');
			grid.colAdd('userNm', '<s:message code="condition.user"/>', 90, 'center', false, 'nomal');
			grid.loadHeader(false);
			grid.initData('<s:message code="common.msg.search.click"/>');
		</script>
</body>
</html>