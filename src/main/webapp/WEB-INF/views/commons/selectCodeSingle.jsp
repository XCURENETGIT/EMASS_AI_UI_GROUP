<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
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
<div class="xcn_container" style="padding: 10px; overflow: auto;">
	<!-- left -->
	<div class="row">
			<h3 class="blue"><span class="bullet01"></span><s:message code="selectCodeSingle.selectitem"/></h3>
			<div class="grayBg mat8 popupInner">
				<div>
					<input type="text" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr">
					<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.msg.search"/></button>
				</div>
			</div>
			<!-- 테이블 -->
			<div class="pop_tableArea mat16">
				<!-- 테이블 -->
				<div id="coCdGrid" class="slickGrid gridArea"></div>
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