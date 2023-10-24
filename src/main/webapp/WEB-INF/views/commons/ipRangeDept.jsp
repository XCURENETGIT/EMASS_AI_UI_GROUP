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
	$('.dept\\.week').click(function(){
		$("#allWeek").prop("checked", false);
	});
	$("#allWeek").click(function(){
		if($("#allWeek").prop("checked")) {
			$("input[name=dept\\.week]:checkbox").each(function() {
				$(this).prop("checked", true);
			});
		}else{
			$("input[name=dept\\.week]:checkbox").each(function() {
				$(this).prop("checked", false);
			});
		}
	});
	$('input:radio[name="dept\\.auto"]').change(function(){
		if($(this).val() == 'N'){
			$('#dept\\.path').prop("disabled",true);
			$('#dept\\.sepa').prop("disabled",true);
			$('#allWeek').prop("disabled",true);
			$('input:checkbox[name="dept\\.week"]').prop("disabled",true);
			$('select[name=time]').prop("disabled",true);
			$('#directExecuteBtn').prop("disabled",true);
		}else{
			$('#dept\\.path').prop("disabled",false);
			$('#dept\\.sepa').prop("disabled",false);
			$('#allWeek').prop("disabled",false);
			$('input:checkbox[name="dept\\.week"]').prop("disabled",false);
			$('select[name=time]').prop("disabled",false);
			$('#directExecuteBtn').prop("disabled",false);
		}
	});
	$('#setDeptApiBtn').click(function(){
		$('#setDeptApiPop').modal();
	});
	$('#setDeptApiPop').on('show.bs.modal', function() {//shown은 모달이 뜨고 나서 불러와서 변경되는게 보여서 show로 바꿈
		ui.get({
			url : 'getConfList.xcn',
			success : function ( data, total ) {
				setDeptRadioVal(data, 'dept.auto');
				setDeptVal(data, 'dept.path');
				setDeptSelVal(data, 'dept.sepa');
				setDeptCheckVal(data, 'dept.week');
				setDeptSelVal(data,'dept.time');
				if($('input:radio[name="dept\\.auto"]:checked').val() == 'N'){
					$('#dept\\.path').prop("disabled",true);
					$('#dept\\.sepa').prop("disabled",true);
					$('#allWeek').prop("disabled",true);
					$('input:checkbox[name="dept\\.week"]').prop("disabled",true);
					$('select[name=time]').prop("disabled",true);
					$('#directExecuteBtn').prop("disabled",true);
				}else{
					$('#dept\\.path').prop("disabled",false);
					$('#dept\\.sepa').prop("disabled",false);
					$('#allWeek').prop("disabled",false);
					$('input:checkbox[name="dept\\.week"]').prop("disabled",false);
					$('select[name=time]').prop("disabled",false);
					$('#directExecuteBtn').prop("disabled",false);
				}
			},
			error : function (status, message) {
				ui.alertMsg(message);
			},
			complete : function (){
			}
		});
	});
	$('#setDeptApiPop').on('hide.bs.modal', function() {
		getDeptConfig()
	});
	
	$('#setDeptPopBtn').click(function(){
		var checkWeekFlag = '';
		var data = [];
		var columnArray = [];
		$("input[name=dept\\.week]:checkbox").each(function() {
			$(this).is(":checked");
			data.push($(this).is(":checked"));
		});
		if(JSON.stringify(data).indexOf('true') == -1 ){
			checkWeekFlag = true;
		}else{
			checkWeekFlag = false;
		}
		if($('input:radio[name="dept\\.auto"]:checked').val() == 'Y'){
			if( $('#insa\\.path').val() == '' ){
				ui.alertMsg('<s:message code="userInfo.msg.enter.filepath"/>');
				$('#dept\\.path').focus();
				return;
			}
			if( $('#insa\\.sepa').val() == '' ){
				ui.alertMsg('<s:message code="userInfo.msg.enter.colseparator"/>');
				$('#dept\\.sepa').focus();
				return;
			}
			if( !$("#allWeek").prop("checked") && checkWeekFlag){
				ui.alertMsg('<s:message code="userInfo.msg.select.day"/>');
				return;
			}
		}
		var checkedInsaText = ''; 
		var checkedInsa = $('input:radio[name="dept\\.auto"]:checked').val();
		if(checkedInsa=='Y'){
			checkedInsaText = '<s:message code="userInfo.autolink"/>';
		}else{
			checkedInsaText = '<s:message code="userInfo.directlink"/>';
		}
		var data = valueCheckInfo();
		ui.confirmMsg('<s:message code="common.msg.confirm.apply"/>', '', '', function(rs){
			if(rs) {
				ui.on('setDeptPopBtn');
				ui.get({
					url : 'setConf.xcn',
					data : JSON.stringify(data),
					checkedInsaText : checkedInsaText,
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.applied"/>');
						$('#setDeptApiPop').modal('hide');
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						ui.off('setDeptPopBtn');
					}
				});
			}
		});
	});
	$('#directExecuteBtn').click(function(){
		ui.confirmMsg('<s:message code="common.msg.confirm.apply"/>', '', '', function(rs){
			if(rs) {
				ui.on('setDeptPopBtn');
					ui.get({
						url : 'runJob.xcn',
						jobId : "SCHEDULE_DEPT_LOAD",
						success : function(data, total) {
							ui.alertMsg('<s:message code="common.msg.applied"/>');
						},
						error : function(status, message) {
							ui.alertMsg(message);
						},
						complete : function() {
						}
					});
				}
		});
	});
	
	$('#insertBtn').click(function(){
		$("#ipRangePop").modal('show');
		$('#deptByCoStrSpan').html('');
		$('#deptByCoSelectedArea').find('.btn').text(0);
		$('#deptByCoSelectedArea').hide();
		$('#startIp, #endIp, #comment, #deptByCoStrSpan, #deptByCoStr, #deptByCoVal').val('');
		$('.savePopBtn').prop("disabled", false);
		$('#dept').prop('disabled',false);
	});
	
	$('#deleteBtn').click(function(){
		$('#deleteBtn').prop('disabled', true);
		var rows = grid.getSelectedRows();
		var deptNm = grid.getSelectedKey('deptNm');
		if ( rows.length == 0 ) {
			ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
			$('#deleteBtn').prop('disabled', false);
			return;
		}
		
		ui.confirmMsg('<s:message code="filterInfo.msg.confirm.deleteitem"/>', '', '', function(rs){
			if(rs) {
				grid.on();
				ui.get({
					url : 'deleteIpRangeDept.xcn',
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
		var deptCd = $('#deptByCoVal').val().ltrim().rtrim();
		var startIp = $('#startIp').val().ltrim().rtrim();
		var endIp = $('#endIp').val().ltrim().rtrim();
		if ( deptCd == '' ) {
			ui.alertMsg('<s:message code="deptIpRange.msg.select.dept"/>');
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
		var deptNm = $('#deptByCoStr').val();
		$('#hiddenDeptNm').val(deptNm);
		var updateYn = $('#dept').prop('disabled');
		var url = '';
		if(updateYn){
			url = 'updateIpRangeDept.xcn';
			$('#orgStartIp').val(orgStartIp);
			$('#orgEndIp').val(orgEndIp);
		}else{
			url = 'insertIpRangeDept.xcn';
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
	
	$('#dept').click(function(){
		openCodeWindow('deptByCo', $('#coCd_inUser option:selected').val(), $('#deptByCoVal').val(), $('#deptNm').val());
	});
	
	getDeptConfig();
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
		url : 'getIpRangeDeptList.xcn',
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

function importIp(){
	$('#uploadForm').attr('action','<c:url value="/importIprangeDept.xcn"/>');
	
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


function openCodeWindow(id, coCd, oldCode, oldConm){
	$('#oldCode').val(oldCode);
	$('#oldConm').val(oldConm);
	
	var url    = '<c:url value="/commons/selectCodeSingle.do?codeType='+id+'"/>';
	fnOpenWindow('', 'selectCodeWinPopup', 520, 600);
	
	$('#codeParam').attr('target','selectCodeWinPopup');
	$('#codeParam').attr('action', url);
	$('#codeParam').attr('method','post');
	$('#codeParam').submit();
}

function getSelectedCodeData( codeType, data ) {
	var str = '';
	var val = '';
	for(var i=0; i<data.length; i++){
		str += data[i].codeName;
		val += data[i].code;
		
		if( i != data.length-1){
			str +=', ';
			val +=',';
		}
	}
	if( val != '' ){
		str = str.rtrim();
		val = val.trimAll();
	}
	$('#deptByCoStr').val(str);
	$('#deptByCoVal').val(val);
	
	if( $('#deptByCoStr').val() != '' ){
		$('#deptByCoSelectedArea').find('.btn').text(data.length);
		$('#deptByCoSelectedArea').show();
		$('#deptByCoStrSpan').html( $('#deptByCoStr').val() );
	}else{
		$('#deptByCoSelectedArea').find('.btn').text(0);
		$('#deptByCoSelectedArea').hide();
	}
}

function getDeptConfig(){
	ui.get({
		url : 'getConfById.xcn',
		confId : 'dept.auto',
		success : function ( data, total ) {
			
			if(nvl(data, 'N') == 'N' || data.val == 'N') {
				$('#insertBtn').show();
				$('#deleteBtn').show();
				$('#uploadBtn').show();
				$('#deptComment').hide();
			} else {
				$('#insertBtn').hide();
				$('#deleteBtn').hide();
				$('#uploadBtn').hide();
				$('#deptComment').show();
			}
			
		},
		error : function (status, message) {
			ui.alertMsg(message);
		},
		complete : function (){
		}
	});
}
function setDeptRadioVal(data, id){
	for(var i=0 ; i < data.length ; i++){
		if(data[i].confId == id ) {
			$('input:radio[name='+idIndicator(id)+']:input[value='+data[i].val+']').prop("checked", true);
			return;
		}
	}
	$('input:radio[name='+idIndicator('dept.auto')+']:input[value=N]').prop("checked", true);
	
}
function setDeptVal(data, id){
	for(var i=0 ; i < data.length ; i++){
		if(data[i].confId == id ) {
			$('#'+idIndicator(id)).val(data[i].val);
			$('#'+ idIndicator(id) + '\\.defaultVal').text(data[i].defaultVal);
			return;
		}
	}
}

function setDeptSelVal(data, id){
	for(var i=0 ; i < data.length ; i++){
		if(data[i].confId == id ) {
			$('#'+idIndicator(id)).val(data[i].val).attr("selected", "selected");
		}
	}
}
function setDeptCheckVal(data, id){
	for(var i=0 ; i < data.length ; i++){
		if(data[i].confId == id ) {
			var obj =  data[i].val.replace(/\\/g,'');
			var varRegexp = new RegExp("true", "ig");
			if(obj.match(varRegexp).length == 7){
				$('#allWeek').prop('checked',true);
			}else{
				$('#allWeek').prop('checked',false);
			}
			var obj2 = (jQuery.parseJSON(obj))
			$.each(obj2,function(key,value){
				$('input:checkbox[name='+idIndicator(id)+']:input[value='+key+']').prop('checked',value);
			});
			return;
		}
	}
	$('#allWeek').click();
}
function idIndicator(id){
	return id.fReplaceWord('.', '\\.');
}

function valueCheckInfo(){
	var data=[];
	var columnArray = [];
	if($('input:radio[name="dept\\.auto"]:checked').val() == 'N'){
		data.push({confId:'dept.auto', val:'N'});
		return data;
	} else {
		data.push({confId:'dept.auto', val:'Y'});
		data.push({confId:'dept.path', val:$('#'+idIndicator('dept.path')).val()});
		data.push({confId:'dept.sepa', val:$('#'+idIndicator('dept.sepa option:selected')).val()});

		var weekObj = {};
		var week = new Array( 'sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat' );
		$("input[name=dept\\.week]:checkbox").each(function(i, e) {
			weekObj[week[i]] = e.checked;
		});

		data.push({confId:'dept.week', val:JSON.stringify(JSON.stringify(weekObj))});
		data.push({confId:'dept.time', val:$('#'+idIndicator('dept.time option:selected')).val()});
		data.push({confId:'dept.schedule', val:getDeptSchedule()});
		return data;
	}
}
//부서 내부 IP 연동 설정 cron exp
function getDeptSchedule(){
	var week=[];
	$("input[name=dept\\.week]:checked").each(function() {
		week.push($(this).val().toUpperCase());
	});

	var schTime= $("#dept\\.time option:selected").val();
	var schedule=[];
	schedule.push('0'); //sec
	schedule.push('0'); //minute
	schedule.push(schTime); //hour
	schedule.push('?'); //day
	schedule.push('*'); //month
	schedule.push(week.join(',')); //week
	return schedule.join(' ');
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
						<h3 class="modal-title"><s:message code="deptIpRange.iprangepop.title"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-inline">
							<label for="attachTypePopInput" class="control-label col-xs-3"><s:message code="common.org.dept"/></label>
							<button type="button" class="btn btn-sm btn-default" id="dept" style="border-radius: 0;"><span class="glyphicon glyphicon-plus-sign"></span> <s:message code="common.org.choose.dept"/></button>
							<span id="deptByCoSelectedArea" class="codeSelectedBtn">
									<button type="button" class="btn">0</button>
							</span>
							<span id="deptByCoStrSpan"></span>
							<input type="hidden" id="deptNm" class="selectedTitle" name="deptNm">
							<input type="hidden" id="deptByCoStr" class="selectedTitle" name="deptNm">
							<input type="hidden" id="deptByCoVal" name="deptCd">
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
					<h3 class="modal-title"><s:message code="POLICY_SETUP.DEPT_IPRANGE"/>-<s:message code="keyword.msg.upload"/></h3>
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
						<div class="form-inline" style="padding-left:10px;"> 2) <s:message code="deptIpRange.msg.upload.info"/></div>
						<div class="form-inline" style="padding-left: 10px;"> 3) <s:message code="keyword.message.upload.info3"/></div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary uploadPopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="setDeptApiPop" tabindex="-1" role="dialog" aria-labelledby="setDeptApiPop">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="setDeptApiPopForm">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="deptIpRange.set.api"/></h3>
					</div>
					<div class="modal-body" style="margin-right: 17px;min-height: 581px">
						<div>
							<div>
								<p style="font-weight: bold;padding-left: 28px;"><s:message code="deptIpRange.method.insa"/></p>
								<fieldset>
									<div class="form-inline" style="line-height: 35px;height: 35px;margin-left: 15px; padding-bottom: 35px;border-bottom: 2px solid #5d9cec;">
										<label  class="col-sm-4 radio-inline c-radio"><input type="radio" value="N" name="dept.auto"><span class="fa fa-check"></span><s:message code="userInfo.directlink"/></label>
										<label  class="col-sm-4 radio-inline c-radio"><input type="radio" value="Y" name="dept.auto"><span class="fa fa-check"></span><s:message code="userInfo.autolink"/></label>
									</div>
								</fieldset>
							</div>
							<div style="margin-top: 17px;float: left; margin-left: 30px;width:560px;"><p style="font-weight: bold;">[<s:message code="userInfo.set.autolink"/>]</p>
								<div >
									<div style="font-weight: 700;">- <s:message code="userInfo.filepath"/>
										<div class="form-inline" style="border-bottom: 0px;">
											<input type="text" id="dept.path" placeholder="<s:message code="common.message.input.filepath"/>" class="form-control" style="width: 400px;" maxlength="255">
										</div>
									</div>
									<div style="font-weight: 700;">- <s:message code="userInfo.colseparator"/>
										<select id="dept.sepa" class="form-control m-b" style="width: 83px; margin-top: 6px;" >
											<option value="|" selected> | </option>
											<option value=","> , </option>
										</select>
									</div>
									<div style="display: block;font-weight: 700;margin-top: 20px;">
										<div>
											<fieldset>- <s:message code="userInfo.set.day"/>
												<div class="form-group" style="width: 415px;">
													<div class="checkbox c-checkbox">
														<label class="checkbox-inline"><input type="checkbox" value="A" id="allWeek"><span class="fa fa-check"></span><s:message code="userInfo.all"/></label>
														<label class="checkbox-inline" style="margin-left:0;"><input type="checkbox" name="dept.week" class="dept.week" value="sun"><span class="fa fa-check"></span><s:message code="common.sun"/></label>
														<label class="checkbox-inline" style="margin-left:0;"><input type="checkbox" name="dept.week" class="dept.week" value="mon"><span class="fa fa-check"></span><s:message code="common.mon"/></label>
														<label class="checkbox-inline" style="margin-left:0;"><input type="checkbox" name="dept.week" class="dept.week" value="tue"><span class="fa fa-check"></span><s:message code="common.tue"/></label>
														<label class="checkbox-inline" style="margin-left:0;"><input type="checkbox" name="dept.week" class="dept.week" value="wed"><span class="fa fa-check"></span><s:message code="common.wed"/></label>
														<label class="checkbox-inline" style="margin-left:0;"><input type="checkbox" name="dept.week" class="dept.week" value="thu"><span class="fa fa-check"></span><s:message code="common.thu"/></label>
														<label class="checkbox-inline" style="margin-left:0;"><input type="checkbox" name="dept.week" class="dept.week" value="fri"><span class="fa fa-check"></span><s:message code="common.fri"/></label>
														<label class="checkbox-inline" style="margin-left:0;"><input type="checkbox" name="dept.week" class="dept.week" value="sat"><span class="fa fa-check"></span><s:message code="common.sat"/></label>
													</div>
												</div>
											</fieldset>
											<fieldset style="margin-top: 7px;">- <s:message code="userInfo.set.time"/>
												<div class="form-group">
													<div class="col-sm-3" style="padding-top:20px;margin-left: -16px;margin-top:-10px;" >
														<select class="form-control m-b" id="dept.time" name="time" style="width: 200px;">
															<option value="*"><s:message code="userInfo.clock.time"/></option>
															<option value="1"><s:message code="common.time.1"/></option>
															<option value="2"><s:message code="common.time.2"/></option>
															<option value="3"><s:message code="common.time.3"/></option>
															<option value="4"><s:message code="common.time.4"/></option>
															<option value="5"><s:message code="common.time.5"/></option>
															<option value="6"><s:message code="common.time.6"/></option>
															<option value="7"><s:message code="common.time.7"/></option>
															<option value="8"><s:message code="common.time.8"/></option>
															<option value="9"><s:message code="common.time.9"/></option>
															<option value="10"><s:message code="common.time.10"/></option>
															<option value="11"><s:message code="common.time.11"/></option>
															<option value="12"><s:message code="common.time.12"/></option>
															<option value="13"><s:message code="common.time.13"/></option>
															<option value="14"><s:message code="common.time.14"/></option>
															<option value="15"><s:message code="common.time.15"/></option>
															<option value="16"><s:message code="common.time.16"/></option>
															<option value="17"><s:message code="common.time.17"/></option>
															<option value="18"><s:message code="common.time.18"/></option>
															<option value="19"><s:message code="common.time.19"/></option>
															<option value="20"><s:message code="common.time.20"/></option>
															<option value="21"><s:message code="common.time.21"/></option>
															<option value="22"><s:message code="common.time.22"/></option>
															<option value="23"><s:message code="common.time.23"/></option>
															<option value="0"><s:message code="common.time.24"/></option>
														</select>
													</div>
												</div>
											</fieldset>
										</div>
									</div>
									<div class="form-group" style="font-weight: 700;margin-top: 20px;">- <s:message code="userInfo.no.column"/>
									</div>
									<div class="form-inline" style="padding-left:10px;border-bottom:none;"> <s:message code="deptIpRange.msg.upload.info"/></div>
									<div style="display: block;font-weight: 700;margin-top: 20px;">- <s:message code="userInfo.direct.execute"/>
										<button id="directExecuteBtn" type="button" accesskey="D" class="btn btn-success" style="margin-left: 84px"><span class="glyphicon glyphicon-import"><s:message code="userInfo.direct.execute"/></span></button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</form>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary" id="setDeptPopBtn" accesskey="S"><s:message code="common.msg.apply"/></button>
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
							<button type="button" class="btn btn-sm btn-warning" accesskey="S" id="setDeptApiBtn"><span class="glyphicon glyphicon-cog"></span>&nbsp;<s:message code="deptIpRange.set.api"/></button>
							<div id="deptComment" style="margin-left: 455px;margin-top: -15px;font-weight: bold; color:#f25643;display: none;width: 630px;"><s:message code="deptIpRange.msg.insa.auto"/></div>
						</div>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="ipRangeDeptListGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var grid = new Xgrid('ipRangeDeptListGrid', contextRoot);
		grid.onCheckBox();
		grid.autoNumber();
		grid.colAdd('deptNm', '<s:message code="common.org.dept"/>' , 200, 'left', false, 'link');
		grid.colAdd('pdeptNm','<s:message code="common.org.pdept"/>', 200, 'left', false, 'nomal',function ( row, cell, value, columnDef, dataContext ) {
			if(value =='' || value == null) return '-';
			else return value;
		});
		grid.colAdd('startIp', '<s:message code="didBlock.startip"/>', 150, 'center', false, 'nomal');
		grid.colAdd('endIp', '<s:message code="didBlock.endip"/>', 150, 'center', false, 'nomal');
		grid.colAdd('comment', '<s:message code="common.msg.comment"/>', 250, 'left', false, 'nomal');
		grid.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 140, 'center', false, 'nomal');
		grid.onClick = function() {
			if (grid.Col == grid.ColIndex('deptNm')) {
				$("#ipRangePop").modal('show');
				var data = grid.getRowData(grid.Row);
				$('#deptByCoCd').val(data.deptCd);
				$('#deptByCoVal').val(data.deptCd);
				$('#dept').prop('disabled',true);
				$('#deptByCoStrSpan').html(data.deptNm);
				$('#startIp').val(data.startIp);
				$('#endIp').val(data.endIp);
				$('#comment').val(data.comment);
				$('#createDt').val(data.createDt);
				orgStartIp = data.startIp;
				orgEndIp = data.endIp;
				
				if( data.deptCd != '' && data.deptCd != null){
					$('#deptByCoSelectedArea').find('.btn').text(1);
					$('#deptByCoSelectedArea').show();
				}else{
					$('#deptByCoSelectedArea').find('.btn').text(0);
					$('#deptByCoSelectedArea').hide();
				}
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
	<form method="post" id="codeParam">
		<input type="hidden" name="oldCode" id="oldCode"/>
		<input type="hidden" name="oldConm" id="oldConm"/>					
	</form>
</body>
</html>