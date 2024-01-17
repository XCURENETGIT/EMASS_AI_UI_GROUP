<%@page import="net.sf.json.JSONObject"%>
<%@ include file="/WEB-INF/fragments/popupScript.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	JSONObject param = Common.getParam ( request );
	String xRootMtr = Common.nvl( param.get("xRootMtr"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS AI - <s:message code="common.msg.userinfo"/></title>
<style type="text/css">
html, body, .row{
	height:100%;
}
.attachExt{
	cursor:pointer;
}
</style>
<script type="text/JavaScript">
var xRootMtr = '<%=xRootMtr%>';
$(document).ready(function(){
	getUserGroupInfo( );
});

function getUserGroupInfo( ){
	grid.on();
	
	ui.get({
		url : 'getMessengerGroupUserList.xcn',
		xRootMtr : xRootMtr,
		groupField : 'sender_str',
		success : function(data, total) {
			grid.appendData(data.groups);
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

	<div class="row">
		<div class="col-lg-12" style="height:100%;">
			<div class="panel panel-default" style="height:100%;">
				<div class="panel-heading" style="height:40px;">
					<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="common.msg.participantinfo"/>
				</div>
				<div class="panel-body" style="height:calc(100% - 40px);">
					<div class="resultBody" style="position: relative;height: 100%;">
						<div class="row" style="height: 100%;">
							<div class="col-sm-12" style="height: 100%;">
								<div id="userGrid" class="slickGrid gridArea" style="height:100%;"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
			var grid = new Xgrid('userGrid', contextRoot);
			grid.autoNumber();
			grid.colAdd('interestUserYn', '<s:message code="message.msg.interest"/>', 40, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == 'Y') return '<div class="interestUserCheck"></div>';
				else if (value == 'N') return '';
			});
			
			grid.colAdd('sender', 'ID', 250, 'left', false, 'nomal');
			grid.colAdd('sname', '<s:message code="common.msg.name"/>', 180, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
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