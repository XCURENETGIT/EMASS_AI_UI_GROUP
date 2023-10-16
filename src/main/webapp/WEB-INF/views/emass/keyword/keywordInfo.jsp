<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<title></title>
<style type="text/css">

</style>
<script>
var searchFlag = false;
$(document).ready(function(){
	$('#searchStrGroupBtn').click(function(){ getGroupData(); });
	$('#searchStrGroup').enter(function(){ getGroupData(); });
	
	$('#searchStrKeywordBtn').click(function(){
		var rows = gridGroup.getSelectedRows();
		if( rows == "" ) {
			alert("<s:message code="keyword.msg.select.part"/>")
			return false;
		}
		getKeywordData();
	});
	
	$('#searchStrKeyword').enter(function(){ 
		var rows = gridGroup.getSelectedRows();
		if( rows == "" ) {
			alert("<s:message code="keyword.msg.select.part"/>")
			return false;
		}
		getKeywordData();
	});
	
	$('.groupSavePopBtn').click(function(){
		if( $('#groupName').val().ltrim().rtrim() == '' ) {
			ui.alertMsg('<s:message code="keyword.message.part_name"/>');
			$('#groupName').focus();
			return false;
		}
		var mode = $('#keywordGroupPop').attr('mode');
		var message = mode=='insert' ? '<s:message code="common.msg.add"/>' : '<s:message code="common.msg.modify"/>'; 
		var confirm_msg = mode=='insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
		ui.confirmMsg(confirm_msg, '', '', function(rs){
			if(rs){
				gridGroup.on();
				ui.post({
					url :mode=='insert' ? 'insertKeywordGroup.xcn' : 'updateKeywordGroup.xcn',
					data : $('#keywordGroupPopForm').serializeAll(),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						$('#keywordGroupPop').modal('hide');
						getGroupData ( );
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
	});
	
	$('#groupInsertBtn').click(function(){
		$('#keywordGroupPop input[type=text]').val('');
		$('[name=useYn][value=Y]').prop('checked',true);
		$('#keywordGroupPop').modal('show');
		$('#keywordGroupPop').attr('mode','insert');
		setTimeout(function(){
			$("#groupName").focus();
		}, 500);	
	});
	
	$('#groupDeleteBtn').click(function(){
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
					url : 'deleteKeywordGroup.xcn',
					deleteData : JSON.stringify(rows),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.deleted"/>');
						getGroupData ( );
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
	});
	
	$('.keywordSavePopBtn').click(function(){
		var keywordStr = $('#keywordName').val().ltrim().rtrim();
		if( keywordStr == '' ) {
			ui.alertMsg('<s:message code="keyword.message.insert"/>');
			$('#keywordName').focus();
			return false;
		}
		if( keywordStr.length == 1 ) {
			ui.alertMsg('<s:message code="keyword.message.aword"/>');
			return false;
		}
		if( keywordStr.indexOf(' ') > -1 ) {
			ui.alertMsg('<s:message code="keyword.message.wordspacing"/>');
			return false;
		}
		var mode = $('#keywordPop').attr('mode');
		
		var message = mode=='insert' ? '<s:message code="common.msg.add"/>' : '<s:message code="common.msg.modify"/>';
		var confirmMessage = mode=='insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
		ui.confirmMsg(confirmMessage, '', '', function(rs){
			if(rs){
				gridKeyword.on();
				ui.post({
					url :mode=='insert' ? 'insertKeyword.xcn' : 'updateKeyword.xcn',
					data : $('#keywordPopForm').serializeAll(),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						$('#keywordPop').modal('hide');
						getKeywordData ( );
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						gridKeyword.off();
						
					}
				});
			}
		});
	});
	
	$('#keywordInsertBtn').click(function(){
		if(gridGroup.getSelectedRows().length < 1) {
			alert("<s:message code="keyword.msg.select.part"/>")
			return false;
		}
		
		var selGroupSeq = gridGroup.getRowData(gridGroup.Row).groupSeq;
		var selGroupName = gridGroup.getRowData(gridGroup.Row).groupName;
		
		$('#keywordPop input[type=text]').val('');
		$('#keyGroupSeq').val(selGroupSeq);
		$('#keyGroupName').val(selGroupName);
		$('#keywordPop').attr('mode','insert');
		$('#keywordPop').modal('show');
		setTimeout(function(){
			$("#keywordName").focus();
		}, 500);	
	});
	
	$('#keywordDeleteBtn').click(function(){
		var rows = gridKeyword.getSelectedRows();
		if( rows == '' ) {
			ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
			return false;
		}
		var names = gridKeyword.getSelectedKey('keywordName');
		ui.confirmMsg( '<s:message code="common.msg.confirm.deleteitem" arguments="'+names+'" argumentSeparator="|"/>', '', '', function(rs){
			if(rs){
				gridKeyword.on();
				ui.get({
					url : 'deleteKeyword.xcn',
					deleteData : JSON.stringify(rows),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.deleted"/>');
						getKeywordData ( );
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						gridKeyword.off();
					}
				});
			}
		});
	});
	
	$('#uploadBtn').click(function(){
		$('#uploadPop').modal('show');
	});
	
	$('.uploadPopBtn').click(function(){
		importKeyword();
	});
	
	$("[name=attach]").change(function (){
		fileExtCheck($(this));
	});
	
	getGroupData ();
	
});

function getGroupData( flag ) {
	if ( searchFlag ) return false;
	
	if ( flag == undefined ) {
		gridGroup.data.length = 0;
		gridGroup.loadingPage = 0;
	} else {
		gridGroup.loadingPage++;
	}

	searchFlag = true;
	gridGroup.on();
	ui.get({
		url : 'getKeywordGroupList.xcn',
		searchStr : $('#searchStrGroup').val(),
		//offset : gridGroup.data.length,
		//limit : gridGroup.pageSize,
		success : function(data, total) {
			if ( flag == 'Y' || flag == undefined ) resultTotal = total;
			gridGroup.appendData(data);
			
			if ( gridGroup.loadingPage == 0 ) gridGroup.Select(-1,-1);
			$('#group_cnt').html("<s:message code="common.msg.listcount"/>: "+gridGroup.data.length);
			KeywordDataClear();
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

function KeywordDataClear() {
	gridKeyword.data.remove(0, gridKeyword.data.length);
	gridKeyword.render();
	$('#keyword_cnt').html("");
	gridKeyword.initData('<s:message code="keyword.message.part_select"/>');
}

function getKeywordData( flag ) {
	if ( searchFlag ) return false;
	
	var selGroupSeq = gridGroup.getRowData(gridGroup.Row).groupSeq;
	var selGroupName = gridGroup.getRowData(gridGroup.Row).groupName;
	
	if ( flag == undefined ) {
		gridKeyword.data.length = 0;
		gridKeyword.rtnNextPageFunc = getKeywordData;
		gridKeyword.loadingPage = 0;
	} else {
		gridKeyword.loadingPage++;
	}
	searchFlag = true;
	gridKeyword.on();
	ui.get({
		url : 'getKeywordList.xcn',
		searchStr : $('#searchStrKeyword').val(),
		searchGroupSeq : selGroupSeq,
		searchGroupName : selGroupName,
		//offset : gridKeyword.data.length,
		//limit : gridKeyword.pageSize,
		success : function(data, total) {
			if ( flag == 'Y' || flag == undefined ) //keywordTotal = total;
			gridKeyword.appendData(data);
			
			if ( gridKeyword.loadingPage == 0 ) gridKeyword.Select(-1,-1);
			$('#keyword_cnt').html("<s:message code="common.msg.listcount"/>: "+gridKeyword.data.length);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			gridKeyword.off();
			searchFlag = false;
		}
	});
}

function importKeyword() {
	$('#uploadForm').attr('action', '<c:url value="/importKeyword.xcn"/>');
	
	var attach = $('[name=attach]').val();
	if(attach == "") {
		ui.alertMsg('<s:message code="keyword.msg.upload.file"/>', function () { $("#attach").click(); });
		return;
	}
	
	var fileExt = attach.substring( attach.lastIndexOf( "." )+1, attach.length ).toLowerCase( );
	
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
						getGroupData ();
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
	if ( !(fileExt == "txt" || fileExt == "text" || fileExt == "csv" || fileExt == "xlsx")) {
		ui.alertMsg('<s:message code="keyword.msg.fileext"/>');
		$('#attachSpan').html('<input type="file" class="form-control" name="attach" id="attach" style="width: 350px; border: 0px;">');
		$('#attach').change(function (){fileExtCheck($('#attach'));});
	}
}
</script>
</head>
<body class="mini-navbar">
	<div class="modal fade" id="keywordGroupPop" tabindex="-1" role="dialog" aria-labelledby="keywordGroupPop">
		<div class="modal-dialog" role="document" style="width: 500px;">
			<div class="modal-content">
				<form method="post" id="keywordGroupPopForm" onsubmit="return false;">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="keyword.msg.part_mgnt"/>-<s:message code="common.msg.addmodify"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-group form-inline">
							<label for="groupName" class="control-label col-xs-3"><s:message code="keyword.msg.part_name"/></label>
							<input type="text" class="form-control" name="groupName" id="groupName" style="width: 350px;" maxlength="60">
							<input type="hidden" class="form-control" name="groupSeq" id="groupSeq">
						</div>
						<div class="form-inline top_space">
							<label for="useYn" class="control-label col-xs-3"><s:message code="common.msg.useyn"/></label>
							<label class="radio-inline c-radio">
								<input type="radio" name="useYn" value="Y" checked>
								<span class="fa fa-check"></span><s:message code="common.msg.use"/>
							</label>
							<label class="radio-inline c-radio">
								<input type="radio" name="useYn" value="N">
								<span class="fa fa-check"></span><s:message code="common.msg.unuse"/>
							</label>
						</div>
					</div>
				</form>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary groupSavePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="keywordPop" tabindex="-1" role="dialog" aria-labelledby="keywordPop">
		<div class="modal-dialog" role="document" style="width: 500px;">
			<div class="modal-content">
				<form method="post" id="keywordPopForm">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="DATA_MONITOR.KEYWORD_MGMT"/>-<s:message code="common.msg.addmodify"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-group form-inline">
							<label for="groupName" class="control-label col-xs-3"><s:message code="keyword.msg.part_name"/></label>
							<input type="text" class="form-control" name="groupName" id="keyGroupName" style="width: 350px;" readonly="readonly">
							<input type="hidden" class="form-control" name="groupSeq" id="keyGroupSeq">
						</div>
						<div class="form-group form-inline">
							<label for="keywordName" class="control-label col-xs-3"><s:message code="keyword.msg.keyword"/></label>
							<input type="text" class="form-control" name="keywordName" id="keywordName" style="width: 350px;" maxlength="60">
							<input type="hidden" class="form-control" name="keywordSeq" id="keywordSeq">
						</div>
						<div class="form-group form-inline">
							<label for="keywordDesc" class="control-label col-xs-3"><s:message code="keyword.msg.comment"/></label>
							<input type="text" class="form-control" name="keywordDesc" id="keywordDesc" style="width: 350px;" maxlength="60">
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
						<button type="button" class="btn btn-primary keywordSavePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
					</div>
				</form>
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
					<h3 class="modal-title"><s:message code="DATA_MONITOR.KEYWORD_MGMT"/>-<s:message code="keyword.msg.upload"/></h3>
				</div>
				<div class="modal-body">
					<form method="post" id="uploadForm" enctype="multipart/form-data" target="upload_file">
						<div class="form-group form-inline">
							<label for="keywordDesc" class="control-label col-xs-3"><s:message code="keyword.msg.colseparator"/></label>
							 <select class="form-control input-sm" id="separator" name="separator">
								<option value=",">,</option>
								<option value="|">|</option>
							</select>
							<select class="form-control input-sm" id="encoding" name="encoding">
								<option value="utf-8">UTF-8</option>
								<option value="euc-kr">EUC-KR</option>
							</select>
							
						</div>
						<div class="form-group form-inline">
							<label for="keywordDesc" class="control-label col-xs-3"><s:message code="keyword.select.file"/></label>
							<span id="attachSpan"><input type="file" class="form-control" name="attach" id="attach" style="width: 350px; border: 0px; padding: 0px;"></span>
						</div>
						<div class="form-inline" style="margin-top: 20px; padding-left: 10px;">1) <s:message code="keyword.message.upload.info1"/></div>
						<div class="form-inline" style="padding-left: 10px;">2) <s:message code="keyword.message.upload.info2"/></div>
						<div class="form-inline" style="padding-left: 10px;">3) <s:message code="keyword.message.upload.info3"/></div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary uploadPopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="container">
		<div class="boxArea">
			<div class="content_body">
				<div class="row" style="line-height: 0px; height:100%;">
					<div class="col-xs-5" style="height: 100%; padding-right: 5px;width:470px;">
						<div class="row" style="margin-right:0px;">
							<div class="col-xs-9 text-left" style="padding-right:0;width:calc(100% - 95px);">
								<div class="form-group form-inline not-dashed">
									<div class="input-group">
										<input type="text" class="form-control input-sm" placeholder="<s:message code="keyword.message.part_name"/>" id="searchStrGroup" style="width: 160px;">
										<div class="input-group-btn">
											<button class="btn btn-sm btn-success" type="button" accesskey="G" id="searchStrGroupBtn"><i class="glyphicon glyphicon-search"></i></button>
										</div>
									</div>
									<c:if test="${_USERCREDENTIAL_.firstAdminYn eq 'Y'}">
										<button type="button" class="btn btn-sm btn-primary" accesskey="I" id="groupInsertBtn"><span class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
										<button type="button" class="btn btn-sm btn-default" accesskey="D" id="groupDeleteBtn"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/></button>
									</c:if>
								</div>
							</div>
						</div>
						<div class="row xcn_full top_space">
							<div class="col-xs-12" style="height: 100%;">
								<div id="keywordGroupListGrid" class="slickGrid gridArea"></div>
							</div>
						</div>
					</div>
					<div class="col-xs-7" style="height: 100%; padding-left: 5px;width:calc(100% - 470px);">
						<div class="row">
							<div class="col-xs-8 text-left" style="padding-left:20px;">
								<div class="form-group form-inline not-dashed">
									<div class="input-group">
										<input type="text" class="form-control input-sm" placeholder="<s:message code="keyword.message.insert"/>" id="searchStrKeyword" style="width: 200px;">
										<div class="input-group-btn">
											<button class="btn btn-sm btn-success" type="button" accesskey="K" id="searchStrKeywordBtn"><i class="glyphicon glyphicon-search"></i></button>
										</div>
									</div>
									<c:if test="${_USERCREDENTIAL_.firstAdminYn eq 'Y'}">
										<button type="button" class="btn btn-sm btn-primary" accesskey="A" id="keywordInsertBtn"><span class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
										<button type="button" class="btn btn-sm btn-default" accesskey="E" id="keywordDeleteBtn"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/></button>
										<button type="button" class="btn btn-sm btn-warning" accesskey="U" id="uploadBtn"><span class="glyphicon glyphicon-import"></span>&nbsp;Upload</button>
									</c:if>
								</div>
							</div>
						</div>
						<div class="row xcn_full top_space">
							<div class="col-xs-12" style="height: 100%;">
								<div id="keywordListGrid" class="slickGrid gridArea"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
		var gridGroup = new Xgrid('keywordGroupListGrid', contextRoot);
		gridGroup.onCheckBox();
		gridGroup.autoNumber();
		gridGroup.colAdd('groupName', '<s:message code="keyword.msg.partnm"/>', 183, 'left', false, 'nomal');
		gridGroup.colAdd('useYn', '<s:message code="common.msg.useyn"/>', 100, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
			if(value=='Y') return '<s:message code="common.msg.use"/>';
			else if(value=='N') return '<s:message code="common.msg.unuse"/>';
			return '-';
		});
		if( $('#groupInsertBtn').css('display') == 'inline-block' ) {
			gridGroup.colAdd('open', '<s:message code="common.msg.modify"/>', 80, 'center', false, 'noal',function(row, cell, value, columnDef, dataContext ) {
				 return "<input type='button' value='<s:message code="common.msg.modify"/>' class='btn modifyBtn' style='line-height: 0px; background-color: #337ab7;height: 20px; color:white; vertical-align: 1px; font-weight:bold'/>";
			});
		}
		gridGroup.loadExportMenu('<s:message code="keyword.msg.part_mgnt"/>');
		gridGroup.loadHeader(false);
		gridGroup.initData('<s:message code="common.msg.search.click"/>');
		
		gridGroup.onClick = function() {
			if (gridGroup.Col == gridGroup.ColIndex('open') && $('#groupInsertBtn').css('display') == 'inline-block') {
				var data = gridGroup.getRowData(gridGroup.Row);
				
				$('#groupSeq').val(data.groupSeq);
				$('#groupName').val(data.groupName);
				$('[name=useYn][value='+data.useYn+']').prop('checked',true);
				
				$('#keywordGroupPop').attr('mode','modify');
				$("#groupName").focus();
				$('#keywordGroupPop').modal('show');
			}
		}
		gridGroup.onActiveCellChanged = function() {
			getKeywordData(); 
		}
		
		var gridKeyword = new Xgrid('keywordListGrid', contextRoot);
		gridKeyword.onCheckBox();
		gridKeyword.autoNumber();
		gridKeyword.colAdd('keywordName', '<s:message code="keyword.msg.keyword"/>', 200, 'center', false, 'link');
		gridKeyword.colAdd('keywordDesc', '<s:message code="common.msg.comment"/>', 250, 'center', false, 'nomal');
		gridKeyword.onClick = function() {
			if (gridKeyword.Col == gridKeyword.ColIndex('keywordName')) {
				var data = gridKeyword.getRowData(gridKeyword.Row);
				
				$('#keyGroupSeq').val(data.groupSeq);
				$('#keyGroupName').val(data.groupName);
				$('#keywordSeq').val(data.keywordSeq);
				$('#keywordName').val(data.keywordName);
				$('#keywordDesc').val(data.keywordDesc);
				
				$('#keywordPop').attr('mode','modify');
				$("#keywordName").focus();
				$('#keywordPop').modal('show');
			}
		};
		gridKeyword.loadExportMenu('<s:message code="DATA_MONITOR.KEYWORD_MGMT"/>');
		gridKeyword.loadHeader(false);
		gridKeyword.initData('<s:message code="keyword.message.part_select"/>');
	</script>

</body>

</html>