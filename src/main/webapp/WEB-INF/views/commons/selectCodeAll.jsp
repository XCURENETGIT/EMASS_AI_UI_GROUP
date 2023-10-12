<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/popupScript.jsp"%>
<%
	String codeType = Common.nvl(request.getParameter("codeType"));
	String coCd = Common.nvl(request.getParameter("coCd"));
	String oldCode = Common.nvl(request.getParameter("oldCode"));
	String oldConm = Common.nvl(request.getParameter("oldConm"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title><s:message code="selectCodeAll.title"/></title>
<style>
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
.deleteText{text-decoration:line-through;}
.panel {margin-bottom: 0px !important;}
</style>
<script>
var codeType = '<%=codeType%>';
var coCd = '<%=coCd%>';
var oldCode = '<%=oldCode%>';
var oldConm = '<%=oldConm%>';

$(document).ready(function(){
	var title = '';
	if( codeType == 'co' ) title = '<s:message code="common.org.co"/>';
	else if( codeType == 'busi' ) title = '<s:message code="common.org.busi"/>';
	else if( codeType == 'service' ) title = '<s:message code="selectCodeAll.type.service"/>';
	else if( codeType == 'regexp' ) title = '<s:message code="common.msg.regexp"/>';
	else if( codeType == 'device' ) title = '<s:message code="selectCodeAll.device"/>';
	else if( codeType == "readAuth") title = '<s:message code="userGroup.navi.title2"/>';
	
	$('#code_title').html(title);
	if( $('#busiCd').css('display') == 'none' ) $('#searchStr').css('width','250px');
	$('#addBtn').click(function(){ setSelectedData(); });
	$('#removeBtn').click(function(){ grid2.deleteSelectedRows(); });
	$('#searchBtn').click(function(){ getCodeList(); });
	$('#searchStr').enter(function(){ getCodeList(); });
	$('#noSelectBtn').click(function(){ self.close();  });
	
	$('#selectBtn').click(function(){
		if( grid2.getData().length == 0 ) {
			alert('<s:message code="common.msg.noselect"/>');
			return;
		}
		if( codeType != 'device' ) opener.getSelectedCodeData( codeType, grid2.getData());
		else opener.getSelectedCodeData( grid2.getData() );
		
		if( codeType == 'co' ){
			opener.resetCode( 'busi' );
			opener.busiBtnControl();
			/*부서권한 
			opener.resetCode( 'dept' );
			opener.busiDeptBtnControl();
			*/
		}
		self.close();
	});
	$('#noSelectBtn').click(function(){
		opener.resetCode(codeType);
	});
	
	getCodeList();
	
		
});

function setDeviceCode(){
	
	if( opener.deviceGrid != undefined && opener.deviceGrid.getData().length > 0 ) {
		grid2.setData( opener.deviceGrid.getData() );
	} 
}

function setCode(){
	var codeArr = oldCode.split('|');
	var conmArr = oldConm.split(',');
	var data = [];
	var allData = grid.getData();
	for(var i = 0; i < codeArr.length; i++ ) {
		var useYn = 'Y';
		for( var j=0, cnt=allData.length; j < cnt; j++ ) {
			if( codeArr[i] == allData[j].code){
				useYn = allData[j].useYn;
				break;
			}
		}
		data.push({'code':codeArr[i],'codeName':conmArr[i].rtrim(),'useYn':useYn});
	}
	grid2.setData(data);
}

function setSelectedData() {
	var selectedData = grid2.getData();
	var selectData = grid.getSelectedRows();
	var data = [];
	for( var i=0, total=selectData.length; i < total; i++ ) {
		var flag=true;
		for( var j=0, cnt=selectedData.length; j < cnt; j++ ) {
			if( selectData[i].code == selectedData[j].code ) {
				flag=false;
				break;
			}
		}
		if(flag) data.push({'deviceSeq':selectData[i].deviceSeq, 'code':selectData[i].code,'codeName':selectData[i].codeName,'tempNm1':selectData[i].tempNm1,'tempNm2':selectData[i].tempNm2, 'useYn':selectData[i].useYn});
	}
	if( data.length > 300 || ( selectData.length + selectedData.length ) > 300 ) {
		alert('<s:message code="selectCodeAll.select.max"/>');
		return;
	}
	grid2.appendData( data );
}

function getCodeList() {
	var searchStr = $('#searchStr').val();
	ui.get({
		url 		: 'getCodeListAll.xcn',
		searchStr	: searchStr,
		codeType	: codeType,
		coCd		: coCd,
		success 	: function(data, total) {
			grid.setData(data);
			
			if( codeType != 'device' && opener.$('#'+codeType+'Hidden').val() != '' ) setCode();
			else setDeviceCode();
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
	<div class="modal fade" id="holidayPop" tabindex="-1" role="dialog" aria-labelledby="holidayModal">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="holidayPopForm">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="selectCodeAll.select.co"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-group">
							<label for="attachTypePopInput" class="control-label"><s:message code="selectCodeAll.date"/></label>
							<div class='input-group date' id='datePicker'>
								<input type='text' class="input-sm form-control" id='date' />
								<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
						</div>
						<div class="form-group">
							<label for="attachDescPopInput" class="control-label"><s:message code="common.msg.comment"/></label>
							<input type="text" class="form-control" name="comment" id="comment" placeholder="<s:message code="common.msg.comment"/>" required>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
						<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="savePopBtn"><s:message code="common.msg.save"/></button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="common.msg.select"/></span>
		</div>
	</header>

	<div class="xcn_container" style="min-width: 650px">
		<div class="boxArea">
			<div class="content_body">
				<div style="width: calc(50% - 25px); float: left;height:100%">
					<div class="panel with-nav-tabs panel-primary" style="height: 100%;">
						<div class="panel-heading">
							<ul class="nav nav-tabs">
								<li class="active"><a href="#result1" data-toggle="tab" style="width: 70px; font-weight: bold;"><s:message code="selectCodeAll.list"/></a></li>
							</ul>
						</div>
						<div class="panel-body">
							<div class="tab-content" style="height:calc(100% - 40px);">
								<div class="tab-pane fade in active" id="result1">
									<div class="resultHeader">
										<div class="form-inline not-dashed">
											<select class="form-control input-sm" id="busiCd" name="busiCd" style="display: none;">
												<option value="">- <s:message code="selectCodeAll.select.type.service"/> -</option>
											</select>
											<div class="input-group">
												<input type="text" class="form-control input-sm" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr" style="width: 180px;">
												<div class="input-group-btn">
													<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
												</div>
											</div>
										</div>
									</div>
									<div class="resultBody top_space" style="height: 100%;">
										<div id="coCdGrid" class="slickGrid gridArea"></div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div style="width: 40px; float: left; height: 100%">
					<div style="position: relative; top: 45%; left: 3px;">
						<button class="btn btn-sm btn-primary" type="button" accesskey="I" id="addBtn"><i class="glyphicon glyphicon-arrow-right"></i></button><br /><br />
						<button class="btn btn-sm btn-primary" type="button" accesskey="D" id="removeBtn"><i class="glyphicon glyphicon-arrow-left"></i></button>
					</div>
				</div>
				<div style="width: calc(50% - 25px); float: left; height: 100%">
					<div class="panel with-nav-tabs panel-primary" style="height: 100%;">
						<div class="panel-heading">
							<ul class="nav nav-tabs">
								<li class="active"><a href="#result1" data-toggle="tab" style="width: 110px; font-weight: bold;"><s:message code="selectCodeAll.selected.list"/></a></li>
							</ul>
						</div>
						<div class="panel-body">
							<div class="tab-content" style="height:calc(100% - 40px);">
								<div class="tab-pane fade in active" id="result1">
									<div class="resultHeader">
										<div class="form-inline text-right not-dashed">
											<div class="input-group">
												<button type="button" class="btn btn-sm btn-primary" accesskey="Y" id="selectBtn"><span class="glyphicon glyphicon-ok"></span>&nbsp;<s:message code="common.msg.select"/></button>
											</div>
											<div class="input-group">
												<button type="button" class="btn btn-sm btn-default" accesskey="N" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="selectCodeAll.noselect"/></button>
											</div>
										</div>
									</div>
									<div class="resultBody top_space" style="height: 100%;">
										<div id="coCdGrid2" class="slickGrid gridArea"></div>
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
			grid.setDrag(true);
			grid.onCheckBox();
			grid.autoNumber();
			if( codeType == 'co' ){
				grid.colAdd('code', '<s:message code="common.org.cocd"/>', 100, 'center', false, 'link');
				grid.colAdd('codeName', '<s:message code="common.org.conm"/>', 160, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
					var useYn = grid.getValue(row, 'useYn');
					if(useYn =='N') return '<span class="deleteText">'+value+'</span>';
					else return value;
				});
			} else if( codeType == 'busi' ){
				grid.colAdd('code', '<s:message code="common.org.busicd"/>', 100, 'center', false, 'link');
				grid.colAdd('codeName', '<s:message code="common.org.businm"/>', 160, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
					var useYn = grid.getValue(row, 'useYn');
					if(useYn =='N') return '<span class="deleteText">'+value+'</span>';
					else return value;
				});
			} else if( codeType == 'service' ){
				grid.colAdd('code', '<s:message code="filterInfo.serviceCode"/>', 100, 'center', false, 'link');
				grid.colAdd('codeName', '<s:message code="filterInfo.service"/>', 160, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
					var useYn = grid.getValue(row, 'useYn');
					if(useYn =='N') return '<span class="deleteText">'+value+'</span>';
					else return value;
				});
			} else if( codeType == 'regexp' ){
				grid.colAdd('code', '<s:message code="selectCodeAll.code"/>', 100, 'center', false, 'link');
				grid.colAdd('codeName', '<s:message code="common.msg.regexp"/>', 160, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
					var useYn = grid.getValue(row, 'useYn');
					if(useYn =='N') return '<span class="deleteText">'+value+'</span>';
					else return value;
				});
			}else if( codeType == 'user' || codeType == 'senders' || codeType == 'receivers' ) {
				grid.colAdd('code', '<s:message code="common.msg.id"/>', 100, 'center', false, 'link');
				grid.colAdd('codeName', '<s:message code="common.msg.name"/>', 100, 'left', false, 'nomal');
				grid.colAdd('tempNm1', '<s:message code="common.org.dept"/>', 100, 'center', false, 'nomal');
				grid.colAdd('tempNm2', '<s:message code="common.org.jikgub"/>', 160, 'left', false, 'nomal');
			} else if( codeType == 'device' ) { 
				grid.colAdd('code', '<s:message code="selectCodeAll.devip"/>', 130, 'left', false, 'link');
				grid.colAdd('codeName', '<s:message code="selectCodeAll.devnm"/>', 160, 'left', false, 'nomal');
			} else if( codeType == 'readAuth'){
				grid.colAdd('code', '<s:message code="userGroup.header.groupcode"/>', 130, 'left', false, 'link');
				grid.colAdd('codeName', '<s:message code="userGroup.groupname"/>', 160, 'left', false, 'nomal');
			} else {
				grid.colAdd('code', '<s:message code="selectCodeAll.code"/>', 100, 'center', false, 'link');
				grid.colAdd('codeName', '<s:message code="selectCodeAll.codenm"/>', 160, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
					var useYn = grid.getValue(row, 'useYn');
					if(useYn =='N') return '<span class="deleteText">'+value+'</span>';
					else return value;
				});
			}
			grid.onClick = function() {
			if (grid.Col == grid.ColIndex('code')) {
				setSelectedData();
			}
		};
		grid.loadHeader(false);
		grid.initData('<s:message code="selectCodeAll.select.code"/>')
		grid.onDragStart = function(e,dd){
			$('#coCdGrid2').css({'border':'2px solid #FFA040'});
		};
		grid.onDragEnd = function(e,dd){
			if ($(e.target).parent().parent().attr('id') == 'coCdGrid2') {
				setSelectedData();
			}
			$('#coCdGrid2').css('border','border: 1px solid #EFEFEF;border-top: 2px solid #7A7A7A;');
		};

		var options={};
		options.status_cnt_id='#total_cnt2';
		options.status_cnt_ing_name='<s:message code="selectCodeAll.cnt.select"/>';
		options.status_cnt_end_name='<s:message code="selectCodeAll.cnt.select"/>';
		var grid2 = new Xgrid('coCdGrid2', contextRoot, 26, options);
		grid2.onCheckBox();
		grid2.autoNumber();
		if( codeType == 'co' ){
			grid2.colAdd('code', '<s:message code="common.org.cocd"/>', 100, 'center', false, 'link');
			grid2.colAdd('codeName', '<s:message code="common.org.conm"/>', 160, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				var useYn = grid.getValue(row, 'useYn');
				if(useYn =='N') return '<span class="deleteText">'+value+'</span>';
				else return value;
			});
		} else if( codeType == 'busi' ){
			grid2.colAdd('code', '<s:message code="common.org.busicd"/>', 100, 'center', false, 'link');
			grid2.colAdd('codeName', '<s:message code="common.org.businm"/>', 160, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				var useYn = grid.getValue(row, 'useYn');
				if(useYn =='N') return '<span class="deleteText">'+value+'</span>';
				else return value;
			});
		} else if( codeType == 'service' ){
			grid2.colAdd('code', '<s:message code="filterInfo.serviceCode"/>', 100, 'center', false, 'link');
			grid2.colAdd('codeName', '<s:message code="filterInfo.service"/>', 160, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				var useYn = grid.getValue(row, 'useYn');
				if(useYn =='N') return '<span class="deleteText">'+value+'</span>';
				else return value;
			});
		} else if( codeType == 'regexp' ){
			grid2.colAdd('code', '<s:message code="selectCodeAll.code"/>', 100, 'center', false, 'link');
			grid2.colAdd('codeName', '<s:message code="common.msg.regexp"/>', 160, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				var useYn = grid.getValue(row, 'useYn');
				if(useYn =='N') return '<span class="deleteText">'+value+'</span>';
				else return value;
			});
		} else if( codeType == 'user' || codeType == 'senders' || codeType == 'receivers' ) {
			grid2.colAdd('code', '<s:message code="common.msg.id"/>', 100, 'center', false, 'link');
			grid2.colAdd('codeName', '<s:message code="common.msg.name"/>', 100, 'left', false, 'nomal');
			grid2.colAdd('tempNm1', '<s:message code="common.org.dept"/>', 100, 'center', false, 'nomal');
			grid2.colAdd('tempNm2', '<s:message code="common.org.jikgub"/>', 160, 'left', false, 'nomal');
		} else if( codeType == 'device' ) { 
			grid2.colAdd('code', '<s:message code="selectCodeAll.devip"/>', 130, 'left', false, 'link');
			grid2.colAdd('codeName', '<s:message code="selectCodeAll.devnm"/>', 160, 'left', false, 'nomal');
		} else if( codeType == 'readAuth'){
			grid2.colAdd('code', '<s:message code="userGroup.header.groupcode"/>', 130, 'left', false, 'link');
			grid2.colAdd('codeName', '<s:message code="userGroup.groupname"/>', 160, 'left', false, 'nomal');
		} else {
			grid2.colAdd('code', '<s:message code="selectCodeAll.code"/>', 100, 'center', false, 'link');
			grid2.colAdd('codeName', '<s:message code="selectCodeAll.codenm"/>', 160, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				var useYn = grid2.getValue(row, 'useYn');
				if(useYn =='N') return '<span class="deleteText">'+value+'</span>';
				else return value;
			});
		}
		grid2.onClick = function() {
			if (grid2.Col == grid2.ColIndex('code')) {
				grid2.deleteSelectedRows();
			}
		};
		grid2.loadHeader(false);
		grid2.initData('<s:message code="selectCodeAll.msg.select.data"/>');
	</script>
</body>
</html>