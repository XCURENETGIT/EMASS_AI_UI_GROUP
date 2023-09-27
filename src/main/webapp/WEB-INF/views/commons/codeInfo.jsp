<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title></title>
<%@ include file="../base.jsp"%>
<script>
var searchFlag = false;
$(document).ready(function(){
	
	$('#export_menu').hide();
	$('#export_menu2').css('display', '');
	
	$('#searchBtn').click(function(){
		getData();
	});
	
	$('#searchStrInput').keypress(function(e){
		if ( e.which == 13 ) {
			getData();
		}
	});
	$(".nav-tabs a").click(function(){
		$('#export_menu').hide();
		$('#export_menu2').hide();

		$('#searchStrInput').val('');
		currentTab = $(this).attr('id');
		var options = getAttachOptions();
		if(currentTab=='attachTab'){
			$('#export_menu').css('display', '');
			$('#searchStrInput').attr('placeholder','<s:message code="codeInfo.msg.enter.ext"/>');
			var str = '<select class="form-control input-sm" id="attachName" name="attachName">';
				str += options;
				str += '</select>';
			$("#attachPopSelectDiv").html(str);
			$('#useYnDiv').css('display','none');
			$('#insertBtn').css('display','');
			$('#deleteBtn').css('display','');
		}else if(currentTab=='serviceTab'){
			$('#export_menu2').css('display', '');
			$('#searchStrInput').attr('placeholder','<s:message code="codeInfo.msg.enter.svc"/>');
			$('#useYnDiv').css('display','');
			$('#insertBtn').css('display','none');
			$('#deleteBtn').css('display','none');
		}else{
			$('#useYnDiv').css('display','none');
			$('#insertBtn').css('display','');
			$('#deleteBtn').css('display','');
		}
		getData();
	});
	$('.savePopBtn').click(function(){
		$('.savePopBtn').prop('disabled', true);
		var attachName = $('#attachName option:selected').val();
		var attachType = $('#attachType').val().ltrim().rtrim();
		if( attachName == '' ){
			ui.alertMsg('<s:message code="codeInfo.select.attachname.enter"/>');
			$('.savePopBtn').prop('disabled', false);
			return;
		}
		if( attachType == '' ){
			ui.alertMsg('<s:message code="codeInfo.select.attachtype.enter"/>');
			$('.savePopBtn').prop('disabled', false);
			return;
		}
		var mode = $('#attachPop').attr('mode');
		
		var message = mode=='insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>'; 
		ui.confirmMsg(message, '', '', function(rs){
			if(rs){
				gridAttach.on();
				ui.post({
					url :mode=='insert' ? 'insertAttachType.xcn' : 'updateAttachType.xcn',
					data : $('#attachPopForm').serializeAll(),
					success : function ( data, total ) {
						
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						$('#attachPop').modal('hide');
						getData ( );
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						gridAttach.off();
						$('.savePopBtn').prop('disabled', false);
					}
				
				});
			}else{
				$('.savePopBtn').prop('disabled', false);
			}
			
		});
	});
	
	$('.servicePopBtn').click(function(){
		$('.servicePopBtn').prop('disabled', true);
		var message = '<s:message code="common.msg.confirm.modify"/>'; 
		ui.confirmMsg(message, '', '', function(rs){
			if(rs){
				gridService.on();
				ui.post({
					url : 'updateServiceUseYn.xcn',
					data : $('#servicePopForm').serializeAll(),
					success : function ( data, total ) {
						
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						$('#servicePop').modal('hide');
						getData ( );
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						gridService.off();
						$('.servicePopBtn').prop('disabled', false);
					}
				
				});
			}else{
				$('.servicePopBtn').prop('disabled', false);
			}
			
		});
	});
	$('#insertBtn').click(function(){
		var options = getAttachOptions();
			var str = '<select class="form-control input-sm" id="attachName" name="attachName">';
			str += options;
			str += '</select>';
			$("#attachPopSelectDiv").html(str);
			$('#attachType').prop("disabled", false);
			$('#attachPop').attr('mode', 'insert');
			$("#attachPop").modal();
			
			setTimeout(function(){
				$('#attachName').val('');
				$('#attachType, #attachDesc').val('');
				$('#attachName').focus();
			},500);
	});
	
	$('#deleteBtn').click(function(){
		$('#deleteBtn').prop('disabled', true);
		
		var rows = gridAttach.getSelectedRows();
		if ( rows.length == 0 ) {
			ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
			$('#deleteBtn').prop('disabled', false);
			return;
		}

		ui.confirmMsg('<s:message code="filterInfo.msg.confirm.deleteitem"/>', '', '', function(rs){
			if(rs) {
				gridAttach.on();
				ui.get({
					url : 'deleteAttachType.xcn',
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
						gridAttach.off();
					}
				});

			} else {
				$('#deleteBtn').prop('disabled', false);
			}
		});
	});
	getData ();
	
});
var currentTab;
function getCurrentTab(){
    return currentTab==null ? 'serviceTab' : currentTab;
}
function getData( flag ) {
	if ( searchFlag ) return;
	var grid = getCurrentGrid();
	searchFlag = true;
	grid.on();
	ui.get({
		url : getCurrentSearchUrl(),
		searchStr : $('#searchStrInput').val(),
		searchUseYn	: $('#useYnSelect').val(),
		success : function(data, total) {
			if ( flag == 'Y' || flag == undefined ) resultTotal = total;
			grid.setData(data);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		    grid.off();
			searchFlag = false;
		}
	});
}

function getAttachOptions(){
    var result = '';
	ui.get({
		url : 'getAttachType.xcn',
		asyncFlag : false,
		searchStr :'',
		success : function(data, total) {
			result+='<option value="">-<s:message code="codeInfo.select.attachname"/>-</option>';
			for(var i=0 ; i<data.length; i++){
				result+='<option value="' + data[i].attachName + '">' +  data[i].attachName + '</option>';
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
function getCurrentSearchUrl(){
	var tab = getCurrentTab();
	if(tab=='attachTab') return 'getAttachTypeList.xcn';
	else if(tab=='serviceTab') return 'getServiceListByAll.xcn';
	else if(tab=='patternTab') return '/';
	else return  null;
}
function getCurrentGrid(){
	var tab = getCurrentTab();
	if(tab=='attachTab') return gridAttach;
	else if(tab=='serviceTab') return gridService;
	else if(tab=='patternTab') return gridPattern;
	else return  null;
}
</script>
</head>
<body class="mini-navbar">

	<div class="modal fade" id="servicePop" tabindex="-1" role="dialog" aria-labelledby="servicePop">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="servicePopForm">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="filterInfo.service"/> <s:message code="common.msg.useyn"/>-<s:message code="common.msg.modify"/></h3>
					</div>
					<div class="modal-body">
					
						<div class="form-inline">
							<label for="groupNm" class="control-label col-xs-4"><s:message code="filterInfo.serviceSeparate"/></label>
							<input type="text" class="form-control" name="groupNm" id="groupNm" maxlength="60" disabled>
						</div>
						<div class="form-inline">
							<label for="serviceNm" class="control-label col-xs-4"><s:message code="condition.service"/></label>
							<input type="text" class="form-control" name="serviceNm" id="serviceNm" maxlength="60" disabled>
						</div>
						<div class="form-inline">
							<label for="serviceCd" class="control-label col-xs-4"><s:message code="condition.service.code"/></label>
							<input type="text" class="form-control" name="serviceCd" id="serviceCd" maxlength="60" disabled>
						</div>
						<div class="form-inline">
							<label for="useYn" class="control-label col-xs-4"><s:message code="common.msg.useyn"/></label>
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
					<button type="button" class="btn btn-primary servicePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="attachPop" tabindex="-1" role="dialog" aria-labelledby="attachModal">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="attachPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="codeInfo.attachpop.title"/></h3>
				</div>
				<div class="modal-body">
					<div class="form-inline">
						<label for="attachPopSelectDiv" class="control-label col-xs-4"><s:message code="condition.attach_type"/></label>
						<div class="form-group" id="attachPopSelectDiv"></div>
					</div>
					<div class="form-inline">
						<label for="attachType" class="control-label col-xs-4"><s:message code="codeInfo.attchext"/></label>
						<input type="text" class="form-control" name="attachType" id="attachType" placeholder="<s:message code="codeInfo.attchext"/>" maxlength="10" >
					</div>
					<div class="form-inline">
						<label for="attachDesc" class="control-label col-xs-4"><s:message code="codeInfo.attachcomment"/></label>
						<input type="text" class="form-control" name="attachDesc" id="attachDesc" placeholder="<s:message code="codeInfo.attachcomment"/>" maxlength="300" >
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" accesskey="C" class="btn btn-default" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" accesskey="S" class="btn btn-primary savePopBtn"><s:message code="common.msg.save"/></button>
				</div>
				</form>
			</div>
		</div>
	</div>
	
	<jsp:include page="../top.jsp"/>
	<div class="container"> 
		<div class="boxArea">
			<div class="content_body">
				<div class="row">
					<div class="col-xs-12"> 
						<ul class="nav nav-tabs codeTab">
							<li class="active" style=" text-align: center"><a data-toggle="tab" href="#serviceList" id="serviceTab" class="coTabClass"><s:message code="condition.service"/></a></li>
							<li style="text-align: center"><a data-toggle="tab" href="#attachList" id="attachTab" class="coTabClass"><s:message code="codeInfo.filetype"/></a></li>
						</ul>
					</div>
				</div>
				<div class="row top_space">
					<div class="col-xs-8 text-left">
						<div class="form-group form-inline not-dashed">
							<div class="input-group" id="useYnDiv">
								<select class="form-control input-sm" id="useYnSelect" style="float: left;">
									<option value=""><s:message code="common.msg.all"/></option>
									<option value="Y" selected><s:message code="common.msg.use"/></option>
									<option value="N"><s:message code="common.msg.unuse"/></option>
								</select>
							</div>
							<div class="input-group">
								<input type="text" class="form-control input-sm" placeholder="<s:message code="codeInfo.msg.enter.svc"/>" id="searchStrInput" style="width: 250px;">
								<div class="input-group-btn">
									<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
								</div>
							</div>
							<button type="button" class="btn btn-sm btn-primary" accesskey="I" id="insertBtn" style="display: none;"><span class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
							<button type="button" class="btn btn-sm btn-default" accesskey="D" id="deleteBtn" style="display: none;"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/></button>
						</div>
					</div>
				</div>
				<div class="tab-content codeContent xcn_full top_space">
					<div id="attachList" class="tab-pane fade" style="height:100%;">
						<div id="attachListGrid" class="slickGrid gridArea"></div>
					</div>
					<div id="serviceList" class="tab-pane fade in active" style="height:100%;">
						<div id="serviceListGrid" class="slickGrid gridArea"></div>
					</div>
					<div id="patternList" class="tab-pane fade" style="height:100%;">
						<div id="patternListGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var gridAttach = new Xgrid('attachListGrid', contextRoot);
		gridAttach.onCheckBox();
		gridAttach.autoNumber();
		gridAttach.colAdd('attachType', '<s:message code="common.msg.ext"/>', 120, 'center', false, 'nomal');
		gridAttach.colAdd('attachName', '<s:message code="common.msg.type"/>', 200, 'center', false, 'nomal');
		gridAttach.colAdd('attachDesc', '<s:message code="common.msg.comment"/>', 250, 'left', false, 'nomal');
		gridAttach.onClick = function() {
			return;
			if (gridAttach.Col == gridAttach.ColIndex('attachType')) {
				var options = getAttachOptions();
				var str = '<select class="form-control input-sm" id="attachName" name="attachName">';
				str += options;
				str += '</select>';
				$("#attachPopSelectDiv").html(str);
				$('#attachType').prop("disabled", true);
				$('#attachPop').attr('mode', 'modify');
				$('#attachPop').modal('show');
				$("#attachPop").on('shown.bs.modal', function() {
					$('#attachName').val(gridAttach.getValue(gridAttach.Row, 'attachName'));
					$('#attachType').val(gridAttach.getValue(gridAttach.Row, 'attachType'));
					$('#attachDesc').val(gridAttach.getValue(gridAttach.Row, 'attachDesc'));
					$('#attachType').focus();
				});
			}
		};
		gridAttach.loadExportMenu('<s:message code="codeInfo.info.filetype"/>');
		gridAttach.loadHeader(true);
		gridAttach.initData('<s:message code="common.msg.search.click"/>');
		
		var gridService = new Xgrid('serviceListGrid', contextRoot);
		gridService.autoNumber();
		gridService.colAdd('groupNm', '<s:message code="filterInfo.serviceSeparate"/>', 150, 'center', false, 'nomal');
		gridService.colAdd('serviceNm', '<s:message code="condition.service"/>', 170, 'left', false, 'nomal');
		gridService.colAdd('serviceCd', '<s:message code="condition.service.code"/>', 90, 'center', false, 'nomal');
		gridService.colAdd('useYn', '<s:message code="common.msg.useyn"/>', 120, 'center', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
			if(value=='Y') return '<s:message code="common.msg.use"/>';
			else if(value=='N') return '<s:message code="common.msg.unuse"/>';
			return '-';
		});
		gridService.onClick = function() {
			if (gridService.Col == gridService.ColIndex('useYn')) {
				var data = gridService.getRowData(gridService.Row);
				
				$('#groupCd').val(data.groupCd);
				$('#groupNm').val(data.groupNm);
				$('#serviceNm').val(data.serviceNm);
				$('#serviceCd').val(data.serviceCd);
				$('[name=useYn][value='+data.useYn+']').prop('checked',true);
				
				$('#servicePop').attr('mode','modify');
				$('#servicePop').modal('show');
			}
		}
		gridService.loadExportMenu('<s:message code="codeInfo.info.svc"/>');
		gridService.loadHeader(true);
		gridService.initData('<s:message code="common.msg.search.click"/>');
	</script>
	<jsp:include page="../footer.jsp"/>
</body>
</html>