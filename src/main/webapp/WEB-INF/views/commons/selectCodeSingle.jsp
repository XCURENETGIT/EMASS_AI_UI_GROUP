<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%
	String codeType = Common.nvl( request.getParameter("codeType") );
	String coCd = Common.nvl( request.getParameter("coCd") );
	String oldCode = Common.nvl( request.getParameter("oldCode") );
	String oldConm = Common.nvl( request.getParameter("oldConm") );
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
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 500px;}
.panel {margin-bottom: 0px !important;}
</style>
<script>
var codeType = '<%=codeType%>';
var coCd = '<%=coCd%>';
var oldCode = '<%=oldCode%>';
var oldConm = '<%=oldConm%>';
$(document).ready(function(){
	if( codeType == 'busi' ) $('#code_title, #tabTitle').html('<s:message code="common.org.choose.busi"/>');
	else if( codeType == 'dept' || codeType == 'deptByCo' ) $('#code_title, #tabTitle').html('<s:message code="common.org.choose.dept"/>');
		
	if( $('#busiCd').css('display') == 'none' ) $('#searchStr').css('width','250px');
	
	$('#searchBtn').click(function(){ getCodeList(); });
	$('#searchStr').enter(function(){ getCodeList(); });
	$('#noSelectBtn').click(function(){ self.close();  });
	
	/* $('#selectBtn').click(function(){
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
	}); */
	
	getCodeList();
});

function getCodeList() {
	var tempCode1 = '';
	if( codeType == 'keyword') tempCode1 = $("#keywordGroup option:selected").val();
	var searchStr = $('#searchStr').val();
	ui.get({
		url 		: 'getCodeList.xcn',
		searchStr	: searchStr,
		codeType	: codeType,
		coCd		: coCd,
		tempCode1	: tempCode1,
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
			<span class="navi"><span id="code_title"></span><s:message code="selectCodeSingle.selectitem"/></span>
		</div>
	</header>
	<div class="xcn_container" style="min-width: 500px;">
		<div class="boxArea">
			<div class="content_body">
				<div class="row">
					<div class="col-xs-10">
						<div class="form-inline not-dashed">
							<select class="form-control input-sm" id="busiCd" name="busiCd" style="display: none;">
								<option value="">- <s:message code="common.org.choose.svctype"/> -</option>
							</select>
							<div class="input-group">
		      					<input type="text" class="form-control input-sm" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr" style="width: 180px;">
								<div class="input-group-btn">
									<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
								</div>
							</div>
						</div>
					</div>
					<div class="col-xs-2 text-right">
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="coCdGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
		var grid = new Xgrid('coCdGrid', contextRoot);
		grid.autoNumber();
		if( codeType == 'co' ){
			grid.colAdd('code', '<s:message code="common.org.cocd"/>', 100, 'center', false, 'link');
			grid.colAdd('codeName', '<s:message code="common.org.conm"/>', 260, 'left', false, 'nomal');
		} else if( codeType == 'busi' ){
			grid.colAdd('code', '<s:message code="common.org.busicd"/>', 100, 'center', false, 'link');
			grid.colAdd('codeName', '<s:message code="common.org.businm"/>', 260, 'left', false, 'nomal');
		}  else if( codeType == 'dept' || codeType == 'deptByCo' ){
			grid.colAdd('code', '<s:message code="common.org.deptcd"/>', 100, 'center', false, 'link');
			grid.colAdd('codeName', '<s:message code="common.org.deptnm"/>', 260, 'left', false, 'nomal');
		} else if( codeType == 'attach' ){
			grid.colAdd('code', '<s:message code="common.msg.ext"/>', 100, 'center', false, 'link');
			grid.colAdd('codeName', '<s:message code="condition.attach_type"/>', 260, 'left', false, 'nomal');
		} else if( codeType == 'service' ){
			grid.colAdd('code', '<s:message code="filterInfo.serviceCode"/>', 100, 'center', false, 'link');
			grid.colAdd('codeName', '<s:message code="filterInfo.service"/>', 260, 'left', false, 'nomal');
		} else if( codeType == 'regexp' ){
			grid.colAdd('code', '<s:message code="selectCodeAll.code"/>', 100, 'center', false, 'link');
			grid.colAdd('codeName', '<s:message code="common.msg.regexp"/>', 260, 'left', false, 'nomal');
		} else if( codeType == 'user' || codeType == 'senders' || codeType == 'receivers' ) {
			grid.colAdd('code', '<s:message code="common.msg.id"/>', 100, 'center', false, 'link');
			grid.colAdd('codeName', '<s:message code="common.msg.name"/>', 100, 'left', false, 'nomal');
			grid.colAdd('tempNm1', '<s:message code="common.org.dept"/>', 100, 'center', false, 'nomal');
			grid.colAdd('tempNm2', '<s:message code="common.org.jikgub"/>', 260, 'left', false, 'nomal');
		} else if( codeType == 'keyword') {
			grid.colAdd('tempNm1', '<s:message code="keyword.msg.partnm"/>', 120, 'left', false, 'nomal');
			grid.colAdd('codeName', '<s:message code="keyword.msg.keyword"/>', 230, 'left', false, 'link');
		} else {
			grid.colAdd('code', '<s:message code="selectCodeAll.code"/>', 100, 'center', false, 'link');
			grid.colAdd('codeName', '<s:message code="selectCodeAll.codenm"/>', 260, 'left', false, 'nomal');
		}
	
		grid.onClick = function() {
			if (grid.Col == grid.ColIndex('code')) {
				ui.confirmMsg('<s:message code="common.msg.confirm.apply"/>', '', '', function(rs){
					if(rs) {
						opener.getSelectedCodeData( codeType, grid.getSelectedRows());
						self.close();
					} 
				});
			}
			if( codeType == 'keyword'){
				if (grid.Col == grid.ColIndex('codeName')) {
					setSelectedData();
				}
			}
		};
	
		grid.loadHeader(false);
		grid.initData('<s:message code="selectCodeAll.select.code"/>')
	</script>
</body>
</html>