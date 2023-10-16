<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<% String adminType = Common.getAdminType(session); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<title></title>
<style type="text/css">
#header-color, #picker-custom {height: 24px; line-height: 24px;}
#header-color {padding-left: 25px;}
</style>
<script>
var adminType = '<%=adminType%>';
var searchFlag=false; 
$(document).ready(function(){
	$('textarea').numberedtextarea();
	
	$('#searchGroupBtn').click(function(){ getUserGroup(); });
	$('#searchStrGroup').enter(function(){ getUserGroup(); });
	
	$('#searchStrItemBtn').click(function(){getItem();});
	$('#searchStrItem').enter(function(){ getItem();});
	
	$('#groupInsertBtn').click(function(){
		$('#userGroupPop input[type=text]').val('');
		$('#groupSeq').val('');
		$('.color-cue-name').hide();
		$('#userGroupPop').attr('mode','insert');
		$('#userGroupPop').modal('show');
		if($('.color-chips').css('display') == 'block') {
			$('.color-box.color-cue').click();
		}
		$('#header-color').val('#5376A3').keyup();
	});
	
	$('#groupSavePopBtn').click(function(){saveUserGroup();});
	
	$('#groupDeleteBtn').click(function(){deleteUerGroup();});
	
	$('#itemInsertBtn').click(function(){
		if(gridGroup.getSelectedRows().length < 1) {
			ui.alertMsg('<s:message code="userGroup.msg.select.group"/>')
			return false;
		}
		if(gridItem.data.length >= 1000) {
			ui.alertMsg('<s:message code="userGroup.msg.user.max"/>');
			return false;
		}
		$('#popSearchStr').val('');
		$('#popUserType').val('');
		$('#popSearchType').val('all');
		
		getUserData();
		$('#selectPop').modal('show');
	});
	
	$('#popSearchBtn').click(function(){getUserData();});
	$('#popSearchStr').enter(function(){getUserData();});
	$('#popUserType').change(function(){getUserData();});
	
	$('#saveUserBtn').click(function(){saveUserGroupItem();});
	$('#saveTextUploadBtn').click(function(){saveTextUploadItem();});
	
	$('#itemDeleteBtn').click(function(){deleteUserGroupItem();});
	
	$('#uploadBtn').click(function(){
		if(gridGroup.getSelectedRows().length < 1) {
			ui.alertMsg('<s:message code="userGroup.msg.select.group"/>')
			return false;
		}
		if(gridItem.data.length >= 1000) {
			ui.alertMsg('<s:message code="userGroup.msg.user.max"/>');
			return false;
		}
		$('#uploadPop').modal('show');
	});
	
	$('#textUploadBtn').click(function(){
		resetTextArea();
		if(gridGroup.getSelectedRows().length < 1) {
			ui.alertMsg('<s:message code="userGroup.msg.select.group"/>')
			return false;
		}
		if(gridItem.data.length >= 1000) {
			ui.alertMsg('<s:message code="userGroup.msg.user.max"/>');
			return false;
		}
		$('#textUploadPop').modal('show');
	});

	$('.uploadPopBtn').click(function(){
		importKeyword();
	});
	
	$("[name=attach]").change(function (){
		fileExtCheck($(this));
	});
	
	getUserGroup ();
	
});

function resetTextArea() {
	$('#textUploadTextArea').val('');
	$('.numberedtextarea-line-numbers').html('<div class="numberedtextarea-number numberedtextarea-number-1">1</div>');
}
function importKeyword() {
	$('#uploadForm').attr('action', '<c:url value="/importAdminGroupUser.xcn"/>');
	
	var attach = $('[name=attach]').val();
	if(attach == "") {
		ui.alertMsg('<s:message code="keyword.msg.upload.file"/>', function () { $("#attach").click(); });
		return;
	}
	
	var fileExt = attach.substring( attach.lastIndexOf( "." )+1, attach.length ).toLowerCase( );
	$('#importGroupSeq').val(gridGroup.getValue(gridGroup.Row, "groupSeq"));
	ui.confirmMsg('<s:message code="keyword.upload.confirm"/>', '', '', function(rs){
		if(rs){
			loadingOn("uploadPop");
			$("#uploadForm").ajaxForm({
				target : '#upload_file',
				beforeSubmit: function() {
					$('#attachSpan').html('<input type="file" class="form-control" name="attach" id="attach" style="width: 350px; border: 0px;">');
					$('#attach').change(function (){fileExtCheck($('#attach'));});
				},
				success: function(result) {
					if(result.success) {
						ui.alertMsg('<s:message code="keyword.upload.ok"/>');
						$('#uploadPop').modal('hide');
						getUserGroupItem ();
					} else {
						ui.alertMsg(result.message);
					}
				},
				error : function(){
					ui.alertMsg('<s:message code="keyword.upload.error"/>');
				},
				complete : function(){
					loadingOff("uploadPop");
				}
			}).submit();
		}
	});
}
function loadingOn(id) {
	
	var obj = $('#' + id);
	var hei = obj.height();
	$(obj).append( '<div class="loading_div"><i class="fa fa-spinner fa-spin fa-3x fa-fw" style="margin-top:'+(hei/2.5)+'px"></i></div>');
	$('.loading_div').css({
		"position" : "absolute",
		"top" : "0px",
		"left" : "15px",
		"right" : "15px",
		"bottom" : "20px",
		"background-color" : "#F0F0F0",
		"opacity" : "0.3",
		"z-index" : "998",
		"text-align" : "center"
	});
}

function loadingOff(id) {
	var obj = $('#' + id + ' .loading_div');
	obj.remove();
}

function fileExtCheck(obj) {
	var fileName = obj.val();
	var fileExt = fileName.substring( fileName.lastIndexOf( "." )+1, fileName.length ).toLowerCase( );
	
	if ( !(fileExt == "txt" || fileExt == "text" || fileExt == "csv" || fileExt == "xls" || fileExt == "xlsx")) {
		ui.alertMsg('<s:message code="keyword.msg.fileext"/>');
		$('#attachSpan').html('<input type="file" class="form-control" name="attach" id="attach" style="width: 350px; border: 0px;">');
		$('#attach').change(function (){fileExtCheck($('#attach'));});
	}
}

function getUserGroup( ) {
	if ( searchFlag ) return false;
	
	searchFlag = true;
	gridGroup.on();
	ui.get({
		url : 'getAdminUserGroupList.xcn',
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
	var groupSeq = gridGroup.getValue(gridGroup.Row, "groupSeq");
	
	searchFlag = true;
	gridItem.on();
	ui.get({
		url : 'getAdminUserGroupItemList.xcn',
		searchStr : $('#searchStrItem').val(),
		groupSeq : groupSeq,
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

	if( $('#groupName').val().ltrim().rtrim() == '' ) {
		ui.alertMsg('<s:message code="userGroup.msg.enter.groupname"/>');
		$('#groupName').focus();
		return false;
	}
	if( $('#header-color').val().ltrim().rtrim() == '' ) {
		ui.alertMsg('<s:message code="userGroup.msg.enter.groupname"/>');
		$('#header-color').focus();
		return false;
	}
	
	$('#groupColor').val($('#header-color').val());

	var mode = $('#userGroupPop').attr('mode');
	var message = mode=='insert' ? '<s:message code="common.msg.add"/>' : '<s:message code="common.msg.modify"/>'; 
	var confirm_msg = mode=='insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
	ui.confirmMsg(confirm_msg, '', '', function(rs){
		if(rs){
			gridGroup.on();
			ui.post({
				url :mode=='insert' ? 'insertAdminUserGroup.xcn' : 'updateAdminUserGroup.xcn',
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
				url : 'deleteAdminUserGroup.xcn',
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
	if(adminType == "C") {
		$('#popUserType').val('Y');
		$('#popUserType').prop('disabled', true);
	}else{
		$('#popUserType').prop('disabled', false);
	}
	var userType= $('#popUserType').val();
	
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

function saveTextUploadItem() {
	var value = $('#textUploadTextArea').val();
	var vs = value.split('\n');
	
	if ( value.replaceAll('\n','').trimAll() == '' ) {
		ui.alertMsg('<s:message code="common.msg.input.contents"/>');
		return;
	}
	
	if(gridItem.data.length + vs.length > 1000) {
		ui.alertMsg('<s:message code="userGroup.msg.user.max"/>');
		return false;
	}
	
	var rows = [];
	for (var i = 0; i < vs.length; i++) {
		rows.push({userId:vs[i].trimAll()});
	}
	
	ui.confirmMsg('<s:message code="common.msg.confirm.add"/>', '', '', function(rs){
		if(rs){
			ui.get({
				url : "insertAdminTextUploadItem.xcn",
				groupSeq	: gridGroup.getValue(gridGroup.Row, 'groupSeq'),
				addData : JSON.stringify(rows),
				success : function ( data, total ) {
					if( data == 0 ) {
						ui.alertMsg('<s:message code="keyword.upload.nocontent"/>');
					}
					else {
						ui.alertMsg('<s:message code="keyword.upload.ok"/>');
						$('#textUploadPop').modal('hide');
						getUserGroupItem();
					}
				},
				error : function (status, message) {
					ui.alertMsg(message);
				},
				complete : function (){
				}
			});
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
				url : "insertAdminUserGroupItem.xcn",
				groupSeq	: gridGroup.getValue(gridGroup.Row, 'groupSeq'),
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

function saveUserGroupItemDirect() {
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
	
	gridSelectUser.on();
	ui.get({
		url : "insertAdminUserGroupItem.xcn",
		groupSeq	: gridGroup.getValue(gridGroup.Row, 'groupSeq'),
		addData : JSON.stringify(rows),
		success : function ( data, total ) {
			ui.notify('<s:message code="interest.message.useradd.info"/>');
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
				url : 'deleteAdminUserGroupItem.xcn',
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
		<div class="modal-dialog modal-sm" role="document" style="height: 300px;width: 400px;">
			<div class="modal-content">
				<form method="post" id="userGroupPopForm" onsubmit="return false;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="userGroup.grouppop.title"/></h3>
				</div>
				<div class="modal-body">
					<div class="form-group" style="padding-top: 10px;">
						<label for="groupName" class="control-label"><s:message code="userGroup.groupname"/></label>
						<input type="text" class="form-control" name="groupName" id="groupName" maxlength="55">
						<input type="hidden" class="form-control" name="groupSeq" id="groupSeq" maxlength="300">
					</div>
					<div class="form-group" style="padding-top: 10px;">
						<label for="groupName" class="control-label"><s:message code="common.msg.color.select"/></label><br /><div style="left: -5px; line-height: 24px;" class="color-picker" id="picker" data-target="header-color"></div>
						<input type="hidden" class="form-control" name="groupColor" id="groupColor" />
					</div>
					<div style="height: 30px;"></div>
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
					<button type="button" class="btn btn-primary" accesskey="S" id="saveUserBtn" ><s:message code="common.msg.select.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div id="upload_file"></div>
	<div class="modal fade" id="uploadPop" role="dialog" aria-labelledby="uploadPop">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="DATA_MONITOR.INTEREST_USER"/>-<s:message code="keyword.msg.upload"/></h3>
				</div>
				<div class="modal-body">
					<form method="post" id="uploadForm" enctype="multipart/form-data" target="upload_file">
						<div class="form-group form-inline">
							<label for="encoding" class="control-label col-xs-3"><s:message code="bodyview.charset"/></label>
							<select class="form-control input-sm" id="encoding" name="encoding">
								<option value="utf-8">UTF-8</option>
								<option value="euc-kr">EUC-KR</option>
							</select>
							<input type="hidden" class="form-control" name="importGroupSeq" id="importGroupSeq" maxlength="300">
						</div>
						<div class="form-group form-inline">
							<label for="keywordDesc" class="control-label col-xs-3"><s:message code="keyword.select.file"/></label>
							<span id="attachSpan"><input type="file" class="form-control" name="attach" id="attach" style="width: 350px; border: 0px; padding: 0px;"></span>
						</div>
						<div class="form-inline" style="margin-top: 20px; padding-left: 10px;">1) <s:message code="interest.message.upload.info1"/></div>
						<div class="form-inline" style="padding-left: 10px;">2) <s:message code="interest.message.upload.info2"/></div>
						<div class="form-inline" style="padding-left: 10px;">3) <s:message code="interest.message.upload.info3"/></div>
						<div class="form-inline" style="padding-left: 10px;">4) <s:message code="interest.message.upload.info4"/></div>
						<div class="form-inline" style="padding-left: 10px;">5) <s:message code="interest.message.upload.info5"/></div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary uploadPopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="textUploadPop" tabindex="-1" role="dialog" aria-labelledby="textUploadPop">
		<div class="modal-dialog" role="document"  style="width: 420px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="DATA_MONITOR.INTEREST_USER"/>-Text Upload</h3>
				</div>
				<div class="modal-body" >
					<textarea rows="25" cols="47" style="border: 1px solid #ccc; " id="textUploadTextArea"></textarea>
				</div>
				<div class="form-inline" style="padding-left: 10px;">1) <s:message code="interest.message.upload.info3"/></div>
				<div class="form-inline" style="padding-left: 10px;">2) <s:message code="interest.message.upload.info4"/></div>
				<div class="form-inline" style="padding-left: 10px;">3) <s:message code="interest.message.upload.info5"/></div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary" accesskey="S" id="saveTextUploadBtn" ><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="container">
		<div class="boxArea">
			<div class="content_body">
				<div class="row" style="height: 100%;">
					<div class="col-xs-5" style="height: 100%; padding-right: 5px;width:470px;">
						<div class="row">
							<div class="col-xs-12 text-left">
								<div class="form-group form-inline not-dashed">
									<div class="input-group">
										<input type="text" class="form-control input-sm" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStrGroup" style="width: 265px;">
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
					</div>
					<div class="col-xs-7" style="height: 100%; padding-left: 5px;width:calc(100% - 470px);">
						<div class="row">
							<div class="col-xs-9 text-left">
								<div class="form-group form-inline not-dashed">
									<div class="input-group">
										<input type="text" class="form-control input-sm" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStrItem" style="width: 280px;">
										<div class="input-group-btn">
											<button class="btn btn-sm btn-success" type="button" accesskey="K" id="searchStrItemBtn"><i class="glyphicon glyphicon-search"></i></button>
										</div>
									</div>
									<button type="button" class="btn btn-sm btn-primary" accesskey="A" id="itemInsertBtn"><span class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
									<button type="button" class="btn btn-sm btn-default" accesskey="E" id="itemDeleteBtn"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/></button>
									<button type="button" class="btn btn-sm btn-warning" accesskey="U" id="uploadBtn"><span class="glyphicon glyphicon-import"></span>&nbsp;Upload</button>
									<button type="button" class="btn btn-sm btn-default" accesskey="U" id="textUploadBtn"><span class="glyphicon glyphicon-import"></span>&nbsp;Text Upload</button>
								</div>
							</div>
						</div>
						<div class="row xcn_full top_space">
							<div class="col-xs-12" style="height: 100%;">
								<div id="userGroupItmeGrid" class="slickGrid gridArea"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		var gridGroup = new Xgrid('userGroupListGrid', contextRoot);
		gridGroup.onCheckBox();
		gridGroup.autoNumber();
		gridGroup.colAdd('groupName', '<s:message code="userGroup.header.groupname"/>', 190, 'left', false, 'nomal');
		gridGroup.colAdd('groupColor', '<s:message code="common.msg.color"/>', 70, 'center', false, 'nomal',function(row, cell, value, columnDef, dataContext ) {
			return "<input type='button' value='' class='btn' style='line-height: 0px; background-color: " + value + "; height: 20px; vertical-align: 1px;'/>";
		});
		gridGroup.colAdd('open', '<s:message code="common.msg.modify"/>', 80, 'center', false, 'nomal',function(row, cell, value, columnDef, dataContext ) {
			return "<input type='button' value='<s:message code="common.msg.modify"/>' class='btn' style='line-height: 0px; background-color: #337ab7;height: 20px; color:white; vertical-align: 1px; font-weight:bold'/>";
		});
		gridGroup.loadExportMenu('<s:message code="userGroup.navi.title2"/>');
		gridGroup.loadHeader(false);
		gridGroup.initData('<s:message code="common.msg.search.click"/>');

		gridGroup.onClick = function() {
			if (gridGroup.Col == gridGroup.ColIndex('open')) {
				var data = gridGroup.getRowData(gridGroup.Row);
				$('#groupSeq').val(data.groupSeq);
				$('#groupName').val(data.groupName);
				$('#header-color').val(data.groupColor);
				$('#userGroupPop').attr('mode','modify');
				$("#groupName").focus();
				$('.color-cue-name').hide();
				$('#userGroupPop').modal('show');
				if($('.color-chips').css('display') == 'block') {
					$('.color-box.color-cue').click();
				}
				$('#header-color').keyup();
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
		gridSelectUser.colAdd('add', '<s:message code="common.msg.add"/>', 80, 'center', false, 'nomal',function(row, cell, value, columnDef, dataContext ) {
			return "<input type='button' value='<s:message code="common.msg.add"/>' class='btn' style='line-height: 0px; background-color: #337ab7;height: 20px; color:white; vertical-align: 1px; font-weight:bold'/>";
		});
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

		gridSelectUser.onClick = function() {
			if (gridSelectUser.Col == gridSelectUser.ColIndex('add')) {
				saveUserGroupItemDirect();
				getUserGroupItem();
			}
		}
		gridSelectUser.loadHeader(false);
	</script>
	<script type="text/javascript" src="<c:url value="/js/colorpicker-colors.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/colorpicker.js"/>"></script>
</body>
</html>