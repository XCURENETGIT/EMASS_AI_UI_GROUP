<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title><s:message code="selectDevStatus.title"/></title>
<%@ include file="../../base.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/panelsTab.css"/>"/>
<script type="text/javascript" src="<c:url value="/js/moment.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/collapse.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ko.js"/>"></script>
<style>
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
</style>
<script>
$(document).ready(function(){
	$('#searchBtn').click(function(){ getDeviceList(); });
	$('#searchStr').enter(function(){ getDeviceList(); });
	$('#noSelectBtn').click(function(){ self.close();  });
	
	$('#devStatusBtn').click(function(){
		var rows = grid.getSelectedRows();
		if( rows.length == 0 ) {
			ui.alertMsg('<s:message code="selectDevStatus.msg.select.device"/>');
			return;
		}
		
		ui.confirmMsg('<s:message code="selectDevStatus.msg.ruleapply"/>', '', '', function(rs){
			if(rs) {
				grid.on();
				ui.get({
					url : 'ruleApplyIpFilter.xcn',
					devData : JSON.stringify(rows),
					success : function ( data, total ) {
						alert('<s:message code="selectDevStatus.msg.success.rule"/>');
						getDeviceList();
					},
					error : function (status, message) {
						ui.alertMsg(message);
						getDeviceList();
					},
					complete : function (){
						grid.off();
					}
				});

			} else {
				$('#devStatusBtn').prop('disabled', false);
			}
		});
	});
	
	getDeviceList();
});

function getDeviceList() {
	var searchStr = $('#searchStr').val();
	grid.on();
	ui.get({
		url 		: 'getCollectionDevice.xcn',
		searchStr	: searchStr,
		success 	: function(data, total) {
		    grid.setData(data);
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
			<span class="navi"><span id="code_title"></span><s:message code="selectDevStatus.device.status"/></span>
		</div>
	</header>
	
	<div class="xcn_container" style="min-width: 650px;">
		<div class="boxArea">
			<div class="content_body">
				<div class="row">
					<div class="col-xs-10">
						<div class="form-inline not-dashed">
							<div class="input-group text-left">
								<input type="text" class="form-control input-sm" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr" style="width: 250px;">
								<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
								<button type="button" class="btn btn-sm btn-danger" accesskey="R" id="devStatusBtn"><span class="glyphicon glyphicon-flash"></span>&nbsp;<s:message code="selectDevStatus.ruleapply"/></button>
							</div>
						</div>
					</div>
					<div class="col-xs-2 text-right">
						<button type="button" class="btn btn-sm btn-default" accesskey="N" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
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
			grid.onCheckBox();
			grid.autoNumber();
			grid.colAdd('deviceType', '<s:message code="selectDevStatus.type.device"/>', 100, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == 'I') return '<s:message code="selectDevStatus.dev.integrated"/>';
				else if (value == 'C') return '<s:message code="selectDevStatus.dev.logging"/>';
				else if (value == 'C') return '<s:message code="selectDevStatus.dev.analysis"/>';
				else return '<s:message code="selectDevStatus.dev.database"/>'
			});
			grid.colAdd('deviceIp', '<s:message code="selectDevStatus.devip"/>', 120, 'left', false, 'nomal');
			grid.colAdd('deviceNm', '<s:message code="selectDevStatus.devnm"/>', 200, 'left', false, 'nomal');
			grid.colAdd('ruleVersion', '<s:message code="selectDevStatus.ruleversion"/>', 100, 'center', false, 'nomal');
			grid.colAdd('ruleDate', '<s:message code="selectDevStatus.ruletime"/>', 180, 'center', false, 'nomal');
			grid.colAdd('createDt', '<s:message code="selectDevStatus.createDt"/>', 150, 'center', false, 'nomal');
			grid.onClick = function() {
			if (grid.Col == grid.ColIndex('userId')) {
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
				/* else {
					opener.selectedUserInfo( grid.getRowData( grid.Row ) );
					self.close();
				} */
			}
		};
		grid.loadHeader(false);
		grid.initData('<s:message code="common.msg.search.click"/>');
	</script>
</body>
</html>