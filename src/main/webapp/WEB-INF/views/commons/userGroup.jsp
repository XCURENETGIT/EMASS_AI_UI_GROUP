
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title></title>
<style type="text/css">

</style>
<script>
var searchFlag=false; 
$(document).ready(function(){
	$('#searchGroupBtn').click(function(){ getUserGroup(); });
	$('#searchStrGroup').enter(function(){ getUserGroup(); });
	
	$('#searchStrItemBtn').click(function(){getItem();});
	$('#searchStrItem').enter(function(){ getItem();});
	
	$('#groupInsertBtn').click(function(){
		$('#userGroupPop input[type=text]').val('');
		$('#groupCode').prop("disabled",false);
		$('#userGroupPop').modal('show');
		$('#userGroupPop').attr('mode','insert');
	});
	
	$('#groupSavePopBtn').click(function(){saveUserGroup();});
	
	$('#groupDeleteBtn').click(function(){deleteUerGroup();});
	
	$('#itemInsertBtn').click(function(){
		if(gridGroup.getSelectedRows().length < 1) {
			ui.alertMsg('<s:message code="userGroup.msg.select.group"/>')
			return false;
		}
		if(gridItem.data.length > 9) {
			ui.alertMsg('<s:message code="userGroup.msg.user.max"/>');
			return false;
		}
		
		getUserData();
		$('#selectPop').modal('show');
	});
	
	$('#popSearchBtn').click(function(){getUserData();});
	$('#popSearchStr').enter(function(){getUserData();});
	$('#popUserType').change(function(){getUserData();});
	
	$('#saveUserBtn').click(function(){saveUserGroupItem();});
	
	$('#itemDeleteBtn').click(function(){deleteUserGroupItem();});
	
	getUserGroup ();
	
});

function getUserGroup( ) {
	if ( searchFlag ) return false;
	
	searchFlag = true;
	gridGroup.on();
	ui.get({
		url : 'getUserGroupList.xcn',
		searchStr : $('#searchStrGroup').val(),
		success : function(data, total) {
			gridGroup.setData(data);
			$('#group_cnt').html("<s:message code="common.msg.listcount"/>: "+gridGroup.data.length);
			itemClear();
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			gridGroup.off();
			searchFlag = false;
		}
	});
}

function itemClear() {
	gridItem.data.remove(0, gridItem.data.length);
	gridItem.render();
	$('#item_cnt').html("");
	gridItem.initData('<s:message code="userGroup.msg.select.group"/>');
}	

function getItem() { 
	var rows = gridGroup.getSelectedRows();
	if( rows == "" ) {
		alert('<s:message code="userGroup.msg.select.group"/>')
		return false;
	}
	getUserGroupItem();
}

function getUserGroupItem( ) {
	if ( searchFlag ) return false;
	var groupCode = gridGroup.getValue(gridGroup.Row, "groupCode");
	
	searchFlag = true;
	gridItem.on();
	ui.get({
		url : 'getUserGroupItemList.xcn',
		searchStr : $('#searchStrItem').val(),
		groupCode : groupCode,
		success : function(data, total) {
			gridItem.setData(data);
			$('#item_cnt').html("<s:message code="common.msg.listcount"/>: "+gridItem.data.length);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			gridItem.off();
			searchFlag=false;
		}
	});
}

function saveUserGroup() {
	if( $('#groupCode').val().ltrim().rtrim() == '' ) {
		ui.alertMsg('<s:message code="userGroup.msg.enter.groupcode"/>');
		$('#groupCode').focus();
		return false;
	}
	if( $('#groupName').val().ltrim().rtrim() == '' ) {
		ui.alertMsg('<s:message code="userGroup.msg.enter.groupname"/>');
		$('#groupName').focus();
		return false;
	}
	var mode = $('#userGroupPop').attr('mode');
	var message = mode=='insert' ? '<s:message code="common.msg.add"/>' : '<s:message code="common.msg.modify"/>'; 
	var confirm_msg = mode=='insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
	ui.confirmMsg(confirm_msg, '', '', function(rs){
		if(rs){
			gridGroup.on();
			ui.post({
				url :mode=='insert' ? 'insertUserGroup.xcn' : 'updateUserGroup.xcn',
				data : $('#userGroupPopForm').serializeAll(),
				success : function ( data, total ) {
					ui.alertMsg('<s:message code="common.msg.saved"/>');
					$('#userGroupPop').modal('hide');
					getUserGroup ( );
				},
				error : function (status, message) {
					ui.alertMsg(message);
				},
				complete : function (){
					gridGroup.off();
				}
			});
		}
	});
}

function deleteUerGroup () {
	var rows = gridGroup.getSelectedRows();
	if( rows == '' ) {
		ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
		return false;
	}
	var names = gridGroup.getSelectedKey('groupName');
	ui.confirmMsg( '<s:message code="common.msg.confirm.deleteitem" arguments="'+names+'" argumentSeparator="|"/>', '', '', function(rs){
		if(rs){
			gridGroup.on();
			ui.get({
				url : 'deleteUserGroup.xcn',
				delData : JSON.stringify(rows),
				success : function ( data, total ) {
					ui.alertMsg('<s:message code="common.msg.deleted"/>');
					getUserGroup ( );
				},
				error : function (status, message) {
					ui.alertMsg(message);
				},
				complete : function (){
					gridGroup.off();
				}
			});
		}
	});
}

function getUserData() {
	
	gridSelectUser.on();

	var userTypeNm = $('#popUserType option:selected').text()
	var searchTypeNm = $('#popSearchType option:selected').text()
	var userType = $('#popUserType').val();
	if(userTypeNm=="- <s:message code="userInfo.usertype"/> -") userTypeNm = '<s:message code="userInfo.all"/>';
	var searchType = $('#popSearchType').val();
	if(searchTypeNm=="- <s:message code="userInfo.all"/> -") searchTypeNm = '<s:message code="userInfo.all"/>';
	var searchStr = $('#popSearchStr').val();
	
	ui.get({
		url : 'getUserList.xcn',
		userTypeNm : userTypeNm,
		searchTypeNm : searchTypeNm,
		userType : userType,
		searchType : searchType,
		searchStr : searchStr,
		logYn : "N",
		success : function(data, total) {
			gridSelectUser.setData(data);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			gridSelectUser.off();
		}
	});
}

function saveUserGroupItem() {
	var rows = gridSelectUser.getSelectedRows();
	$('#saveUserBtn').prop('disabled', true);
	if ( rows.length == 0 ) {
		ui.alertMsg('<s:message code="common.msg.noselect"/>');
		$('#saveUserBtn').prop('disabled', false);
		return;
	}
	
	if(gridItem.data.length + rows.length > 1000) {
		ui.alertMsg('<s:message code="userGroup.msg.user.max"/>');
		$('#saveUserBtn').prop('disabled', false);
		return false;
	}
	
	ui.confirmMsg('<s:message code="common.msg.confirm.add"/>', '', '', function(rs){
		if(rs){
			gridSelectUser.on();
			ui.get({
				url : "insertUserGroupItem.xcn",
				groupCode	: gridGroup.getValue(gridGroup.Row, 'groupCode'),
				addData : JSON.stringify(rows),
				success : function ( data, total ) {
					ui.alertMsg('<s:message code="common.msg.saved"/>');
					$("#selectPop").modal('hide');
					getUserGroupItem();
				},
				error : function (status, message) {
					ui.alertMsg(message);
				},
				complete : function (){
					gridSelectUser.off();
					$('#saveUserBtn').prop('disabled', false);
				}
			});
		} else {
			$('#saveUserBtn').prop('disabled', false);
		}
	});
}

function deleteUserGroupItem (){
	var rows = gridItem.getSelectedRows();
	if( rows == '' ) {
		ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
		return false;
	}
	var names = gridItem.getSelectedKey('userNm');
	ui.confirmMsg( '<s:message code="common.msg.confirm.deleteitem" arguments="'+names+'" argumentSeparator="|"/>', '', '', function(rs){
		if(rs){
			gridItem.on();
			ui.get({
				url : 'deleteUserGroupItem.xcn',
				delData : JSON.stringify(rows),
				success : function ( data, total ) {
					ui.alertMsg('<s:message code="common.msg.deleted"/>');
					getUserGroupItem();
				},
				error : function (status, message) {
					ui.alertMsg(message);
				},
				complete : function (){
					gridItem.off();
				}
			});
		}
	});
}
</script>
</head>
<body class="mini-navbar">
	<div class="modal fade" id="userGroupPop" tabindex="-1" role="dialog" aria-labelledby="userGroupPop">
		<div class="modal-dialog modal-sm" role="document">
			<div class="modal-content">
				<form method="post" id="userGroupPopForm" onsubmit="return false;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="userGroup.grouppop.title"/></h3>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label for="groupCode" class="control-label"><s:message code="userGroup.groupcode"/></label>
						<input type="text" class="form-control" name="groupCode" id="groupCode" maxlength="60">
					</div>
					<div class="form-group" style="padding-top: 10px;">
						<label for="groupName" class="control-label"><s:message code="userGroup.groupname"/></label>
						<input type="text" class="form-control" name="groupName" id="groupName" maxlength="300">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary" accesskey="S" id="groupSavePopBtn"><s:message code="common.msg.save"/></button>
				</div>
				</form>
			</div>
		</div>
	</div>
	
	<!-- 공통 Group 항목 선택-->
	<div class="modal fade" id="selectPop" tabindex="-1" role="dialog" aria-labelledby="selectPop">
		<div class="modal-dialog" role="document"  style="width: 1000px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="common.org.choose.user"/></h3>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-xs-12 text-left">
							<div class="form-group form-inline not-dashed">
								<div class="input-group">
									<select class="form-control input-sm" id="popUserType" style="float: left;">
										<option value="">- <s:message code="userInfo.usertype"/> -</option>
										<option value="N"><s:message code="userInfo.normal"/></option>
										<option value="Y">CEO</option>
									</select>
								</div>
								<div class="input-group">
									<select class="form-control input-sm" id="popSearchType" style="float: left;">
										<option value="all">- <s:message code="userInfo.all"/> -</option>
										<option value="userId"><s:message code="common.msg.id"/></option>
										<option value="userNm"><s:message code="common.msg.name"/></option>
										<option value="userEmail">E-Mail</option>
										<option value="userIp">IP</option>
										<option value="userDept"><s:message code="common.org.dept"/></option>
									</select>
								</div>
								<div class="input-group">
									<input type="text" class="form-control input-sm" placeholder="<s:message code="common.msg.searchMsg"/>" id="popSearchStr" style="width: 180px;">
									<div class="input-group-btn">
										<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="popSearchBtn"><i class="glyphicon glyphicon-search"></i></button>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row top_space">
						<div style="height:500px;" id="selectUserDiv">
							<div id="userSelectGrid" class="slickGrid gridArea"></div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary" accesskey="S" id="saveUserBtn" ><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="container">
		<div class="boxArea">
			<div class="content_body">
				<div class="row" style="height: 100%;">
					<div class="col-xs-5" style="height: 100%;">
						<div class="row">
							<div class="col-xs-9 text-left">
								<div class="form-group form-inline not-dashed">
									<div class="input-group">
										<input type="text" class="form-control input-sm" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStrGroup" style="width: 160px;">
										<div class="input-group-btn">
											<button class="btn btn-sm btn-success" type="button" accesskey="G" id="searchGroupBtn"><i class="glyphicon glyphicon-search"></i></button>
										</div>
									</div>
									<button type="button" class="btn btn-sm btn-primary" accesskey="I" id="groupInsertBtn"><span class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
									<button type="button" class="btn btn-sm btn-default" accesskey="D" id="groupDeleteBtn"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/></button>
								</div>
							</div>
						</div>
						<div class="row xcn_full top_space">
							<div class="col-xs-12" style="height: 100%;">
								<div id="userGroupListGrid" class="slickGrid gridArea"></div>
							</div>
						</div>
						<!-- <div id="group_cnt" style="margin-top:12px; color: #f25643; font-weight: bold; font-size: 13px; padding-top: 3px;"></div> -->
					</div>
					<div class="col-xs-7" style="height: 100%;">
						<div class="row">
							<div class="col-xs-9 text-left">
								<div class="form-group form-inline not-dashed">
									<div class="input-group">
										<input type="text" class="form-control input-sm" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStrItem" style="width: 200px;">
										<div class="input-group-btn">
											<button class="btn btn-sm btn-success" type="button" accesskey="K" id="searchStrItemBtn"><i class="glyphicon glyphicon-search"></i></button>
										</div>
									</div>
									<button type="button" class="btn btn-sm btn-primary" accesskey="A" id="itemInsertBtn"><span class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
									<button type="button" class="btn btn-sm btn-default" accesskey="E" id="itemDeleteBtn"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/></button>
								</div>
							</div>
						</div>
						<div class="row xcn_full top_space">
							<div class="col-xs-12" style="height: 100%;">
								<div id="userGroupItmeGrid" class="slickGrid gridArea"></div>
							</div>
						</div>
						<!-- <div id="item_cnt" style="margin-top:12px; color: #f25643; font-weight: bold; font-size: 13px; padding-top: 3px;"></div> -->
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
		var gridGroup = new Xgrid('userGroupListGrid', contextRoot);
		gridGroup.onCheckBox();
		gridGroup.autoNumber();
		gridGroup.colAdd('groupCode', '<s:message code="userGroup.header.groupcode"/>', 100, 'left', false, 'nomal');
		gridGroup.colAdd('groupName', '<s:message code="userGroup.header.groupname"/>', 198, 'left', false, 'nomal');
		gridGroup.colAdd('open', '<s:message code="common.msg.modify"/>', 80, 'center', false, 'nomal',function(row, cell, value, columnDef, dataContext ) {
			return "<input type='button' value='<s:message code="common.msg.modify"/>' class='btn' style='line-height: 0px; background-color: #337ab7;height: 20px; color:white; vertical-align: 1px; font-weight:bold'/>"; 
		});
		gridGroup.loadExportMenu('<s:message code="userGroup.navi.title2"/>');
		gridGroup.loadHeader(false);
		gridGroup.initData('<s:message code="common.msg.search.click"/>');
		
		gridGroup.onActiveCellChanged = function() {
			if (gridGroup.Col == gridGroup.ColIndex('open')) {
				var data = gridGroup.getRowData(gridGroup.Row);
				
				$('#groupCode').val(data.groupCode);
				$('#groupCode').prop("disabled",true);
				$('#groupName').val(data.groupName);
				$('#userGroupPop').attr('mode','modify');
				$("#groupName").focus();
				$('#userGroupPop').modal('show');
			}
			getUserGroupItem(); 
		}
		
		var gridItem = new Xgrid('userGroupItmeGrid', contextRoot);
		gridItem.onCheckBox();
		gridItem.autoNumber();
		gridItem.colAdd('userId', '<s:message code="common.msg.id"/>', 120, 'center', false, 'nomal');
		gridItem.colAdd('userNm', '<s:message code="common.msg.name"/>', 150, 'left', false, 'nomal');
		gridItem.colAdd('userEmail', 'E-Mail', 250, 'left', false, 'nomal');
		gridItem.colAdd('userIp', 'IP', 150, 'left', false, 'nomal');
		gridItem.colAdd('coNm', '<s:message code="common.org.co"/>', 120, 'left', false, 'nomal');
		gridItem.colAdd('generalNm', '<s:message code="common.org.general"/>', 120, 'left', false, 'nomal');
		gridItem.colAdd('busiNm', '<s:message code="common.org.busi"/>', 120, 'left', false, 'nomal');
		gridItem.colAdd('deptNm', '<s:message code="common.org.dept"/>', 120, 'left', false, 'nomal');
		gridItem.colAdd('jikgubNm', '<s:message code="common.org.jikgub"/>', 80, 'left', false, 'nomal');
		gridItem.colAdd('jikinNm', '<s:message code="common.org.jikin"/>', 80, 'left', false, 'nomal');
		gridItem.colAdd('ceo', '<s:message code="userInfo.usertype"/>', 80, 'center', false, 'normal', function(row, cell, value, columnDef, dataContext){
			var ceo = gridItem.getValue(row, 'ceo');
			if(ceo=='Y')return 'CEO';
			else return '';
		});
		gridItem.loadExportMenu('<s:message code="userGroup.navi.title2"/>');
		gridItem.loadHeader(false);
		gridItem.initData('<s:message code="userGroup.msg.select.group"/>');
		
		//User Group Add
		var gridSelectUser = new Xgrid('userSelectGrid', contextRoot);
		gridSelectUser.onCheckBox();
		gridSelectUser.autoNumber();
		gridSelectUser.colAdd('userId', '<s:message code="common.msg.id"/>', 120, 'center', false, 'nomal');
		gridSelectUser.colAdd('userNm', '<s:message code="common.msg.name"/>', 150, 'left', false, 'nomal');
		gridSelectUser.colAdd('userEmail', 'E-Mail', 250, 'left', false, 'nomal');
		gridSelectUser.colAdd('userIp', 'IP', 150, 'left', false, 'nomal');
		gridSelectUser.colAdd('coNm', '<s:message code="common.org.co"/>', 120, 'left', false, 'nomal');
		gridSelectUser.colAdd('generalNm', '<s:message code="common.org.general"/>', 120, 'left', false, 'nomal');
		gridSelectUser.colAdd('busiNm', '<s:message code="common.org.busi"/>', 120, 'left', false, 'nomal');
		gridSelectUser.colAdd('deptNm', '<s:message code="common.org.dept"/>', 120, 'left', false, 'nomal');
		gridSelectUser.colAdd('jikgubNm', '<s:message code="common.org.jikgub"/>', 80, 'left', false, 'nomal');
		gridSelectUser.colAdd('jikinNm', '<s:message code="common.org.jikin"/>', 80, 'left', false, 'nomal');
		gridSelectUser.colAdd('ceo', '<s:message code="userInfo.usertype"/>', 80, 'center', false, 'normal', function(row, cell, value, columnDef, dataContext){
			var ceo = gridSelectUser.getValue(row, 'ceo');
			if(ceo=='Y')return 'CEO';
			else return '';
		});
		gridSelectUser.loadHeader(false);
	</script>
	
</body>
</html>