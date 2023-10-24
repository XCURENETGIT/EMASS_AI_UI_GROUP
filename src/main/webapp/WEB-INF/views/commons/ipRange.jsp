<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title></title>
<style>
</style>
<script type="text/javascript">
var searchFlag=false;
var orgStartIp ='';
var orgEndIp ='';
$(document).ready(function(){
	$('#searchBtn').click(function(){
		getData();
	});


	$('#searchStrInput').enter(function(){
		getData();
	});
	
	$('#insertBtn').click(function(){
		$("#ipRangePop").modal('show');
		$('#busiCd, #startIp, #endIp, #comment').val('');
		$('.savePopBtn').prop("disabled", false);
		$('#busiCd').prop('disabled',false);
	});
	
	$('#deleteBtn').click(function(){
		$('#deleteBtn').prop('disabled', true);
		var rows = grid.getSelectedRows();
		var busiNm = grid.getSelectedKey('busiNm');
		if ( rows.length == 0 ) {
			ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
			$('#deleteBtn').prop('disabled', false);
			return;
		}
		
		ui.confirmMsg('<s:message code="filterInfo.msg.confirm.deleteitem"/>', '', '', function(rs){
			if(rs) {
				grid.on();
				ui.get({
					url : 'deleteIpRange.xcn',
					deleteData : JSON.stringify(rows),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.deleted"/>');
						getData();
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						$('#deleteBtn').prop('disabled', false);
						grid.off();
					}
				});
			} else {
				$('#deleteBtn').prop('disabled', false);
			}
		});
	});

	$('#uploadBtn').click(function(){
		$('#uploadPop').modal('show');
	});
	
	$('.uploadPopBtn').click(function(){
		importIp();
	});
	
	$("[name=attach]").change(function (){
		fileExtCheck($(this));
	});
	
	$('.savePopBtn').click(function(){
		var busiCd = $('#busiCd').val().ltrim().rtrim();
		var startIp = $('#startIp').val().ltrim().rtrim();
		var endIp = $('#endIp').val().ltrim().rtrim();
		if ( busiCd == '' ) {
			ui.alertMsg('<s:message code="ipRange.msg.select.busi"/>');
			return;
		}
		if ( startIp == '' ) {
			ui.alertMsg('<s:message code="ipRange.msg.enter.sip"/>');
			return;
		}
		if ( endIp == '' ) {
			ui.alertMsg('<s:message code="ipRange.msg.enter.eip"/>');
			return;
		}
		if(!checkIP(startIp)){
			ui.alertMsg('<s:message code="ipRange.msg.sip.wrong"/>');
			return;
		}
		if(!checkIP(endIp)){
			ui.alertMsg('<s:message code="ipRange.msg.eip.wrong"/>');
			return;
		}
		if (!checkIpRange(startIp,endIp) )
		{
			ui.alertMsg('<s:message code="ipRange.msg.enter.iprange"/>');
			return;
		}
		var busiNm = $('#busiCd option:selected').text();
		$('#hiddenBusiNm').val(busiNm);
		var updateYn = $('#busiCd').prop('disabled');
		var url = '';
		if(updateYn){
			url = 'updateIpRange.xcn';
			$('#orgStartIp').val(orgStartIp);
			$('#orgEndIp').val(orgEndIp);
		}else{
			url = 'insertIpRange.xcn';
		}
		
		
		ui.confirmMsg('<s:message code="common.msg.confirm.add"/>', '', '', function(rs){
			if(rs){
				grid.on();
				ui.post({
					url : url,
					data : $('#ipRangePopForm').serializeAll(),
					success : function ( data, total ) {
						if(updateYn){
							ui.alertMsg('<s:message code="common.msg.modified"/>');
						}else{
							ui.alertMsg('<s:message code="common.msg.added"/>');
							
						}
						$('#ipRangePop').modal('hide');
						getData();
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						$('.savePopBtn').prop("disabled", false);
						grid.off();
					}
				});
			} else {
				$('.savePopBtn').prop("disabled", false);
			}
		});
	});
	$("#busiCd").html(getBusiOptions());
	getData();
});
function getData(lastRow) {
	if(searchFlag) return;
	if ( lastRow == undefined ) {
		grid.data.length = 0;
		grid.rtnNextPageFunc = getData;
		grid.loadingPage = 0;
	} else {
		grid.loadingPage++;
	}

	grid.on();
	searchFlag=true;
	var searchStrInput= $("#searchStrInput").val();
	var ipSig = false;
	if(checkIP(searchStrInput)){
		ipSig = true;
	}
	
	ui.get({
		url : 'getIpRangeList.xcn',
		searchStr : searchStrInput,
		ipSig : ipSig,
		offset : grid.data.length,
		limit : grid.pageSize,
		success : function(data, total) {
			grid.appendData(data);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			searchFlag=false;
			grid.off();
		}
	});
}
function getBusiOptions(){
	var result = '';
	ui.get({
		url : 'getAllBusiList.xcn',
		asyncFlag : false,
		success : function(data, total) {
			result+='<option value="">- <s:message code="common.org.choose.busi"/> -</option>';
			for(var i=0 ; i<data.length; i++){
				result+='<option value="' + data[i].busiCd + '">' +  data[i].busiNm + '</option>';
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
	return result;
}

function importIp(){
	$('#uploadForm').attr('action','<c:url value="/importIprange.xcn"/>');
	
	var attach = $('[name=attach]').val();
	if(attach == ""){
		ui.alertMsg('<s:message code="keyword.msg.upload.file"/>', function () { $("#attach").click(); });
		return;
	}
	
	var fileExt = attach.substring(attach.lastIndexOf(".") +1 , attach.length).toLowerCase();
	
	ui.confirmMsg('<s:message code="keyword.upload.confirm"/>', '', '', function(rs){
		if(rs){
			loadingOn("uploadPop");
			$("#uploadForm").ajaxForm({
				target : "#upload_file",
				beforeSubmit : function(){
					$('#attachSpan').html('<input type="file" class="form-control" name="attach" id="attach" style="width: 350px; border: 0px;">');
					$('#attach').change(function (){fileExtCheck($('#attach'));});
				},
				success: function(result){
					if(result.success){
						ui.alertMsg('<s:message code="keyword.upload.ok"/>');
						$('#uploadPop').modal('hide');
						getData();
					}else{
						ui.alertMsg(result.message);
					}
				},
				error:function(){
					ui.alertMsg('<s:message code="keyword.upload.error"/>');
				},
				complete : function(){
					loadingOff("uploadPop");
				}
			}).submit();
		}
	});
}

function loadingOn(id){
	var obj = $('#' + id);
	var hei = obj.height();
	$(obj).append( '<div class="loading_div"><i class="fa fa-spinner fa-spin fa-3x fa-fw" style="margin-top:'+(hei/2.5)+'px"></i></div>');
	$('.loading_div').css({
		"top"   : "0px",
		"left"  : "15px",
		"right" : "15px",
		"bottom": "20px",
		"opacity" : "0.3",
		"z-index" : "998",
		"position": "absolute",
		"text-align" : "center",
		"background-color" : "#F0F0F0"
	});
}

function loadingOff(id) {
	var obj = $('#' + id + ' .loading_div');
	obj.remove();
}

function fileExtCheck(obj){
	var fileName = obj.val();
	var fileExt  = fileName.substring(fileName.lastIndexOf(".") +1, fileName.length).toLowerCase();
	if(!(fileExt == "txt" || fileExt == "text" || fileExt == "csv" || fileExt == "xlsx")){
		ui.alertMsg('<s:message code="keyword.msg.fileext"/>');
		$('#attachSpan').html('<input type="file" class="form-control" name="attach" id="attach" style="width: 350px; border: 0px;">');
		$('#attach').change(function (){fileExtCheck($('#attach'));});
	}
}

</script>
</head>
<body class="mini-navbar">

	<div class="modal fade" id="ipRangePop" tabindex="-1" role="dialog" aria-labelledby="ipRangeModal">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="ipRangePopForm">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="ipRange.iprangepop.title"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-inline">
							<label for="attachTypePopInput" class="control-label col-xs-3"><s:message code="common.org.busi"/></label>
							<select class="form-control input-sm" id="busiCd" name="busiCd">
								<option value="">- <s:message code="common.org.choose.busi"/> -</option>
							</select>
							<input type="hidden" name="busiNm" id="hiddenBusiNm">
						</div>
						<%if( isIPv6){ %>
						<div class="form-inline">
							<label for="attachTypePopInput" class="control-label col-xs-3"><s:message code="didBlock.startip"/></label>
							<input type="text" class="form-control" name="startIp" id="startIp" style="width:320px;" placeholder="<s:message code="didBlock.startip"/>" required>
							<p style="padding-left:142px; margin-bottom: 0px;">
								<span style='color:grey;'>[ex: IPv4 - 192.168.0.12 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IPv6 - 2002:9b3d:1a32:4:208:74ff:fe39:6c43]</span>
							</p>
						</div>
						<div class="form-inline">
							<label for="attachDescPopInput" class="control-label col-xs-3"><s:message code="didBlock.endip"/></label>
							<input type="text" class="form-control" name="endIp" id="endIp" style="width:320px;" placeholder="<s:message code="didBlock.endip"/>" required>
							<p style="padding-left:142px; margin-bottom: 0px;">
								<span style='color:grey;'>[ex: IPv4 - 192.168.0.12 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IPv6 - 2002:9b3d:1a32:4:208:74ff:fe39:6c43]</span>
							</p>
						</div>
						<div class="form-inline">
							<label for="attachDescPopInput" class="control-label col-xs-3"><s:message code="common.msg.comment"/></label>
							<input type="text" class="form-control" name="comment" id="comment" style="width:320px;" placeholder="<s:message code="common.msg.comment"/>" maxlength="500">
						</div>
						<div class="form-inline">
							<label for="attachTypePopInput"></label>
							<input type="hidden" class="form-control" name="orgStartIp"  id="orgStartIp">
						</div>
						<div class="form-inline">
							<label for="attachTypePopInput"></label>
							<input type="hidden" class="form-control" name="orgEndIp"  id="orgEndIp">
						</div>
						<%} else {%>
						<div class="form-inline">
							<label for="attachTypePopInput" class="control-label col-xs-3"><s:message code="didBlock.startip"/></label>
							<input type="text" class="form-control" name="startIp" id="startIp" placeholder="<s:message code="didBlock.startip"/>" required>
							
						</div>
						<div class="form-inline">
							<label for="attachDescPopInput" class="control-label col-xs-3"><s:message code="didBlock.endip"/></label>
							<input type="text" class="form-control" name="endIp" id="endIp" placeholder="<s:message code="didBlock.endip"/>" required>
						</div>
						<div class="form-inline">
							<label for="attachDescPopInput" class="control-label col-xs-3"><s:message code="common.msg.comment"/></label>
							<input type="text" class="form-control" name="comment" id="comment" placeholder="<s:message code="common.msg.comment"/>" maxlength="500">
						</div>
						<div class="form-inline">
							<label for="attachTypePopInput"></label>
							<input type="hidden" class="form-control" name="orgStartIp"  id="orgStartIp">
						</div>
						<div class="form-inline">
							<label for="attachTypePopInput"></label>
							<input type="hidden" class="form-control" name="orgEndIp"  id="orgEndIp">
						</div>
						<%} %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary savePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
						<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<div id="upload_file"></div>
	<div class="modal fade" id="uploadPop" role="dialog" aria-labelledby="uplaodPop">
		<div class="modal-dialog" role="document">
			<div class = "modal-content">
				<div class="modal-header">
					<button type = "button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="POLICY_SETUP.BUSI_IPRANGE"/>-<s:message code="keyword.msg.upload"/></h3>
				</div>
				<div class="modal-body">
					<form method="post" id="uploadForm" enctype="multipart/form-data" target="upload_file">
						<div class="form-group form-inline">
							<label for="comment" class="control-label col-xs-3"><s:message code="keyword.msg.colseparator"/></label>
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
							<label for="comment" class="control-label col-xs-3"><s:message code="keyword.select.file"/></label>
							<span id="attachSpan"><input type="file" class="form-control" name="attach" id="attach" style="width: 350px; border: 0px; padding: 0px;"></span>
						</div>
						<div class="form-inline" style="margin-top:20px;padding-left:10px;"> 1) <s:message code="keyword.message.upload.info1"/></div>
						<div class="form-inline" style="padding-left:10px;"> 2) <s:message code="ipRange.msg.upload.info"/></div>
						<div class="form-inline" style="padding-left: 10px;"> 3) <s:message code="keyword.message.upload.info3"/></div>
						<div class="form-inline" style="padding-left: 10px;"> 4) <s:message code="ipRange.msg.upload.info1"/></div>
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
				<div class="row">
					<div class="col-xs-8 text-left">
						<div class="form-group form-inline not-dashed">
							<div class="input-group">
								<input type="text" class="form-control input-sm" placeholder="<s:message code="ipRange.msg.enter.busicomment"/>" id="searchStrInput" style="width: 250px;">
								<div class="input-group-btn">
									<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
								</div>
							</div>
							<button type="button" class="btn btn-sm btn-primary" accesskey="I" id="insertBtn"><span class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
							<button type="button" class="btn btn-sm btn-default" accesskey="D" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/></button>
							<button type="button" class="btn btn-sm btn-warning" accesskey="U" id="uploadBtn"><span class="glyphicon glyphicon-import"></span>&nbsp;Upload</button>
						</div>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="ipRangeListGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var grid = new Xgrid('ipRangeListGrid', contextRoot);
		grid.onCheckBox();
		grid.autoNumber();
		grid.colAdd('busiNm', '<s:message code="common.org.busi"/>', 200, 'left', false, 'link');
		grid.colAdd('startIp', '<s:message code="didBlock.startip"/>', 150, 'center', false, 'nomal');
		grid.colAdd('endIp', '<s:message code="didBlock.endip"/>', 150, 'center', false, 'nomal');
		grid.colAdd('comment', '<s:message code="common.msg.comment"/>', 250, 'left', false, 'nomal');
		grid.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 140, 'center', false, 'nomal');
		grid.onClick = function() {
			if (grid.Col == grid.ColIndex('busiNm')) {
				$("#ipRangePop").modal('show');
				var data = grid.getRowData(grid.Row);
				$('#busiCd').val(data.busiCd).prop('disabled',true);
				$('#startIp').val(data.startIp);
				$('#endIp').val(data.endIp);
				$('#comment').val(data.comment);
				$('#createDt').val(data.createDt);
				orgStartIp = data.startIp;
				orgEndIp = data.endIp;
				
			}
		};
		grid.loadExportMenu('<s:message code="ipRange.set.iprange"/>');
		grid.loadPageSize();
		grid.loadHeader(true);
		grid.initData('<s:message code="common.msg.search.click"/>');
		grid.changePageSize = function(cnt){
			getData();
		};
	</script>
</body>
</html>