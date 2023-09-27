<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%
	String codeType = request.getParameter("codeType");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title><s:message code="selectCodeSingle.title"/></title>
<%@ include file="../base.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/panelsTab.css"/>"/>
<script type="text/javascript" src="<c:url value="/js/moment.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/collapse.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ko.js"/>"></script>
<style>
html,body{height: 100%; padding: 0px; margin: 0px;}
.container{height: 100%;}
.content {height: 100%;}
</style>
<script>
var codeType = '<%=codeType%>';
$(document).ready(function(){
	if( codeType == 'busi' ) $('#tabTitle').html('<s:message code="common.org.choose.busi"/>');
	else if( codeType == 'dept' ) $('#tabTitle').html('<s:message code="common.org.choose.dept"/>');
		
	if( $('#busiCd').css('display') == 'none' ) $('#searchStr').css('width','250px');
	
	$('#searchBtn').click(function(){ getCodeList(); });
	$('#searchStr').enter(function(){ getCodeList(); });
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
	
	getCodeList();
});

function getCodeList() {
	var searchStr = $('#searchStr').val();
	var url = '';
	if( codeType == 'busi' ) url = 'getBusiList.xcn';
	else if( codeType == 'dept' ) url = 'getDeptList.xcn';
	
	ui.get({
		url 		: url,
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
	<div class="container">
		<div style="background-image: url('<c:url value="/img/title/n_bg.gif"/>'); border-bottom: 1px solid #3ca00a;">
			<img src="<c:url value="/img/title/home_icon.gif"/>" width="28" height="33">
			<span class="navi"><span id="code_title"></span><s:message code="selectCodeSingle.selectitem"/></span>
		</div>
		<div>&nbsp;</div>
		<div class="row content" style="padding: 10px; position: absolute; top: 50px; left: 0px; right: 0px; bottom: 0px;">
			<div style="width: calc(100% - 25px); float: left; padding-left: 20px; height:calc(100% - 70px);">
				<div class="panel with-nav-tabs panel-primary" style="height: 100%;">
					<div class="panel-heading">
						<ul class="nav nav-tabs">
							<li class="active"><a href="#result1" data-toggle="tab" style="font-weight: bold;" id="tabTitle"><s:message code="common.org.choose.user"/></a></li>
						</ul>
					</div>
					<div class="panel-body" style="height: 100%;">
						<div class="tab-content" style="height:calc(100% - 100px);">
							<div class="tab-pane fade in active" id="result1">
								<div class="resultHeader" style="height:50px;">
									<div class="resultMsgDiv" style="height:35px;">
										<div class="col-xs-5fff text-right" style="position: relative; top:15px;right:0;">
											<div class="form-inline">
												<select class="form-control input-sm" id="busiCd" name="busiCd" style="display: none;">
													<option value="">- <s:message code="common.org.choose.svctype"/> -</option>
												</select>
												<div class="input-group">
							      					<input type="text" class="form-control input-sm" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr" style="width: 180px;">
													<div class="input-group-btn">
														<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
													</div>
												</div>
												<div class="input-group text-right">
													<!-- <button type="button" class="btn btn-sm btn-primary" id="selectBtn"><span class="glyphicon glyphicon-ok"></span>&nbsp;<s:message code="common.msg.save"/></button> -->
													<button type="button" class="btn btn-sm btn-default" accesskey="N" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="resultBody" style="position: relative;height: 100%;">
									<div class="row" style="height: 100%;">
										<div class="col-sm-12" style="padding: 15px; height: 100%;">
											<div id="coCdGrid" class="slickGrid gridArea" style="position: relative; top: -15px; left: 0px; min-height:200px;height:450px;"></div>
											<div id="total_cnt" style="margin-top:0px; color: #f25643; font-weight: bold; font-size: 13px;"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
		var grid = new Xgrid('coCdGrid', contextRoot);
			grid.autoNumber();
			if( codeType == 'busi' ) {
				grid.colAdd('busiCd', '<s:message code="selectCodeSingle.code"/>', 120, 'center', false, 'link');
				grid.colAdd('busiNm', '<s:message code="selectCodeSingle.codename"/>', 350, 'left', false, 'nomal');
			} else if( codeType == 'dept' ) {
				grid.colAdd('deptCd', '<s:message code="selectCodeSingle.code"/>', 120, 'center', false, 'link');
				grid.colAdd('deptNm', '<s:message code="selectCodeSingle.codename"/>', 350, 'left', false, 'nomal');
			}
			grid.loadHeader(false);
			grid.initData('<s:message code="common.msg.nodata"/>');
			
			grid.onClick = function() {
				if (grid.Col == grid.ColIndex('busiCd') || grid.Col == grid.ColIndex('deptCd')) {
					var obj = grid.getRowData( grid.Row );
					opener.selectedCodeInfo( obj, codeType );
					self.close();
				}
			};
	</script>
</body>
</html>