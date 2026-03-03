
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
		if(gridItem.data.length > 1000) {
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
<div class="modal" id="userGroupPop" tabindex="-1" role="dialog" aria-labelledby="userGroupPop">
	<div class="modal-content">
		<form method="post" id="userGroupPopForm">
			<div class="modalHead">
				<h2><s:message code="userGroup.grouppop.title"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="userGroup.grouppop.title"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="groupCode" class="fname"><s:message code="userGroup.groupcode"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="groupCode" id="groupCode" maxlength="60">
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="groupName" class="fname"><s:message code="userGroup.groupname"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="groupName" id="groupName" maxlength="300">
						</div>
					</div>

				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="groupSavePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
			</div>
		</form>
	</div>
</div>
<!-- 공통 Group 항목 선택-->
<div class="modal" id="selectPop" aria-labelledby="selectPop">
	<div class="modal-content" style="width: 1200px">
		<div class="modalHead">
			<h2><s:message code="common.org.choose.user"/></h2>
			<span class="close" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalCon">
			<div class="modalbody">
				<div>
					<div>
						<select class="w100" id="popUserType" style="float: left; width: 120px;">
							<option value="">- <s:message code="userInfo.usertype"/> -</option>
							<option value="N"><s:message code="userInfo.normal"/></option>
							<option value="Y">CEO</option>
						</select>
					</div>
					<div>
						<select class="w100" id="popSearchType" style="float: left; width: 120px;">
							<option value="all">- <s:message code="userInfo.all"/> -</option>
							<option value="userId"><s:message code="common.msg.id"/></option>
							<option value="userNm"><s:message code="common.msg.name"/></option>
							<option value="userEmail">E-Mail</option>
							<option value="userIp">IP</option>
							<option value="userDept"><s:message code="common.org.dept"/></option>
						</select>
					</div>
					<div class="input-group">
						<input type="text" class="w100" placeholder="<s:message code="common.msg.searchMsg"/>" id="popSearchStr" style="width: 150px;">
						<button class="form_btn01" type="button" accesskey="Q" id="popSearchBtn"><s:message code="common.search"/>
						</button>
						<div>
						</div>
					</div>
				</div>
				<div class="contentSub" style="padding: 0px;">
					<div id="userSelectGrid" class="slickGrid gridArea" style="height: 300px; height: 300px;"></div>
				</div>
			</div>
			<div class="modalfooter">
				<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal" id="userSave"><s:message code="common.msg.close"/></button>
				<button type="button" class="pop_btn02" accesskey="S" id="saveUserBtn"><s:message code="common.msg.select.save"/></button>
			</div>
		</div>
	</div>
</div>

	<div>
		<div class="searchArea">
			<div style="width:470px; float: left">
				<div class="searchSub" style="width: 470px;">
					<div>
						<input type="text" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStrGroup" style="width: 220px;">
						<button class="form_btn01" type="button"  accesskey="G" id="searchGroupBtn"><s:message code="common.search"/></button>
					</div>
					<div class="btnform">
						<button type="button" class="btn01" accesskey="I" id="groupInsertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
						<button type="button" class="btn02" accesskey="D" id="groupDeleteBtn"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
					</div>
				</div>
				<!--<div class="content xcn_full" style="background-color: transparent">
					<div class="contentSub" style="padding: 0px;">
						<div id="userGroupListGrid" class="slickGrid gridArea"></div>
					</div>
				</div>-->
			</div>

			<div style="width:calc(100% - 470px); padding-left: 16px; float: left">
				<div class="searchSub" style="width:calc(100% - 470px) ">
					<div>
						<input type="text" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStrItem" style="width: 280px;">
						<button class="form_btn01" type="button" accesskey="K" id="searchStrItemBtn"><s:message code="common.search"/></button>
					</div>
						<div class="btnform">
							<button type="button" class="btn01" accesskey="A" id="itemInsertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
							<button type="button" class="btn02" accesskey="E" id="itemDeleteBtn"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
						</div>
				</div>
				<!--<div class="content xcn_full" style=" background-color: transparent">
					<div class="contentSub " style="padding:0 ">
						<div id="userGroupItmeGrid" class="slickGrid gridArea"></div>
					</div>
				</div>-->
			</div>
		</div>

		<div class="content" style="overflow:hidden;">
			<div class="contentSub" style="width:500px; float: left">
				<div id="userGroupListGrid" class="slickGrid gridArea"></div>
			</div>
			<div>
				<div class="contentSub " style="width:calc(100% - 500px); float: left; padding-left:0px !important;">
					<div id="userGroupItmeGrid" class="slickGrid gridArea"></div>
				</div>
			</div>
		</div>
	</div>
</body>
	
	<script type="text/javascript">
		var gridGroup = new Xgrid('userGroupListGrid', contextRoot);
		gridGroup.onCheckBox();
		gridGroup.autoNumber();
		gridGroup.colAdd('groupCode', '<s:message code="userGroup.header.groupcode"/>', 100, 'left', false, 'nomal');
		gridGroup.colAdd('groupName', '<s:message code="userGroup.header.groupname"/>', 198, 'left', false, 'nomal');
		gridGroup.colAdd('open', '<s:message code="common.msg.modify"/>', 80, 'center', false, 'nomal',function(row, cell, value, columnDef, dataContext ) {
			return "<input type='button' value='<s:message code="common.msg.modify"/>' class='table_btn01' style='line-height: 0px;  height: 20px; color:white; vertical-align: 1px; font-weight:bold'/>";
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
		gridItem.colAdd('sabun', '<s:message code="common.msg.userid"/>', 120, 'left', false, 'nomal');
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