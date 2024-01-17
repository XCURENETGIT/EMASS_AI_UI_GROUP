<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<%
	String codeType = request.getParameter("codeType");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS AI - <s:message code="interest.select.user"/></title>
<style>
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
</style>
<script>
var codeType = '<%=codeType%>';
$(document).ready(function(){
	if(codeType == "multi") {
		$('#saveBtn').show();	
	}
	
	$('#searchBtn').click(function(){ getUserList(); });
	$('#searchStr').enter(function(){ getUserList(); });
	$('#noSelectBtn').click(function(){ self.close();  });
	
	$('#selectBtn').click(function(){
		if( grid.getSelectedRows().length == 0 ) {
			alert('<s:message code="common.msg.noselect"/>');
			return;
		}
		
		ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function(rs){
			if(rs){
				grid.on();
				ui.post({
					url :mode=='insert' ? 'insertInterestUser.xcn' : 'updateInterestUser.xcn',
					data : $('#userPopForm').serializeAll(),
					success : function ( data, total ) {
						
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						$('#userPop').modal('hide');
						getData ( );
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						grid.off();
					}
				
				});
			}
		});
		
		opener.getSelectedCodeData(grid.getData());
		self.close();
	});
	
	$('#saveBtn').click(function(){
		if( grid.getSelectedRows().length == 0 ) {
			alert('<s:message code="common.msg.noselect"/>');
			return;
		}
		
		ui.confirmMsg('<s:message code="interest.msg.confirm.save"/>', '', '', function(rs){
			if(rs){
				grid.on();
				
				var obj = grid.getRowData(grid.Row);
				
				ui.get({
					url :'insertInterestMultiUser.xcn',
					userType : 'E',
					userList : JSON.stringify(grid.getSelectedRows()),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						self.close();
						opener.getData ( );
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						grid.off();
					}
				
				});
			}
		});
	});
	
	getUserList();
});

function getUserList(lastRow) {
	grid.pageSize = 500;
	if ( lastRow == undefined ) {
		grid.data.length = 0;
		grid.rtnNextPageFunc = getUserList;
		grid.loadingPage = 0;
	} else {
		grid.loadingPage++;
	}
	
	var searchStr = $('#searchStr').val();
	var searchType = $('#searchType').val();
	grid.on();
	ui.get({
		url 		: 'getUserList.xcn',
		searchStr	: searchStr,
		userType	: 'N',
		searchType	: searchType,
		logYn : "N",
		offset : grid.data.length,
		limit : 500,
		success 	: function(data, total) {
			grid.appendData(data);
		},
		error 		: function(status, message) {
			ui.alertMsg(message);
		},
		complete 	: function() {
			searchFlag=false;
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
			<span class="navi"><span id="code_title"></span><s:message code="interest.select.user"/></span>
		</div>
	</header>
	<div class="xcn_container" style="min-width: 650px;">
		<div class="boxArea">
			<div class="content_body">
				<div class="row">
					<div class="col-xs-10">
						<div class="form-inline not-dashed">
							<div class="input-group text-left">
								<select class="form-control input-sm" id="searchType" style="float: left;">
									<option value="all">- <s:message code="userInfo.all"/> -</option>
									<option value="userId"><s:message code="common.msg.id"/></option>
									<option value="userNm"><s:message code="common.msg.name"/></option>
									<option value="userEmail">E-Mail</option>
									<option value="userIp">IP</option>
									<option value="userDept"><s:message code="common.org.dept"/></option>
								</select>
							</div>
							<div class="input-group text-left">
								<input type="text" class="form-control input-sm" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr" style="width: 250px;">
								<div class="input-group-btn">
									<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
								</div>
							</div>
						</div>
					</div>
					<div class="col-xs-2 text-right">
						<button type="button" class="btn btn-sm btn-primary" accesskey="C" id="saveBtn" style="display: none;"><span class="fa fa-check"></span>&nbsp;<s:message code="common.msg.save"/></button>
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="selectInterestUser" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
		var grid = new Xgrid('selectInterestUser', contextRoot);
			if( codeType == 'multi' ) {
				grid.onCheckBox();
				grid.autoNumber();
				grid.colAdd('userId', '<s:message code="common.msg.id"/>', 120, 'center', false, 'nomal');
			} else {
				grid.autoNumber();
				grid.colAdd('userId', '<s:message code="common.msg.id"/>', 120, 'center', false, 'link');
			}
			grid.colAdd('userNm', '<s:message code="common.msg.name"/>', 120, 'left', false, 'nomal');
			grid.colAdd('userEmail', 'E-Mail', 200, 'left', false, 'nomal');
			grid.colAdd('userIp', 'IP', 170, 'left', false, 'nomal');
			grid.colAdd('coNm', '<s:message code="common.org.co"/>', 135, 'left', false, 'nomal');
			grid.colAdd('busiNm', '<s:message code="common.org.busi"/>', 135, 'left', false, 'nomal');
			grid.colAdd('deptNm', '<s:message code="common.org.dept"/>', 135, 'left', false, 'nomal');
			grid.onClick = function() {
			if (grid.Col == grid.ColIndex('userId')) {
				if( codeType != 'multi' ) {
					if( codeType != 'user' ) {
						ui.confirmMsg('<s:message code="interest.msg.confirm.save"/>', '', '', function(rs){
							if(rs){
								grid.on();
								
								var obj = grid.getRowData(grid.Row);
								
								ui.get({
									url :'insertInterestUser.xcn',
									userType : 'E',
									userNm : obj.userNm,
									userId : obj.userId,
									userIp : obj.userIp,
									userEmail : obj.userEmail,
									comment : '<s:message code="common.org.dept"/>: ' + obj.deptNm + ', <s:message code="common.org.jikgub"/>: ' + obj.jikgubNm,
									success : function ( data, total ) {
										ui.alertMsg('<s:message code="common.msg.saved"/>');
										self.close();
										opener.getData ( );
									},
									error : function (status, message) {
										ui.alertMsg(message);
									},
									complete : function (){
										grid.off();
									}
								
								});
							}
						});
					}
					else {
						opener.selectedUserInfo( grid.getRowData( grid.Row ) );
						self.close();
					}
				}
			}
		};
		grid.loadHeader(false);
		grid.initData('<s:message code="common.msg.search.click"/>');
	</script>
</body>
</html>