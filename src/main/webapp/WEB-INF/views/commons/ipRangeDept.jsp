<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<script type="text/javascript">
var searchFlag=false;
var orgStartIp ='';
var orgEndIp ='';
$(document).ready(function(){
	$('#searchBtn').click(function(){
		getData();
	});

    $('#dept').click(function(){
        openCodeWindow('deptByCo', $('#coCd_inUser option:selected').val(), $('#deptByCoVal').val(), $('#deptNm').val());
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
                        ui.off('setDeptPopBtn');
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
                    attachInit('attachSpan','attachFileName','attach');
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
        attachInit('attachSpan','attachFileName','attach');
    }else $('#attachFileName').html(obj[0].files[0].name);
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

<div class="modal" id="ipRangePop" tabindex="-1" role="dialog" aria-labelledby="ipRangeModal" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="ipRangePopForm">
			<div class="modalHead">
				<h2><s:message code="deptIpRange.iprangepop.title"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="deptIpRange.iprangepop.title"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="attachTypePopInput" class="fname"><s:message code="common.org.dept"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<button class="btn01" type="button"  id="dept"><img src="../img/subBtn_plus.png" alt="추가"><s:message code="common.org.choose.dept"/></button>
							<span id="deptByCoSelectedArea" class="codeSelectedBtn">
									<button type="button" class="btn">0</button>
							</span>
							<span id="deptByCoStrSpan"></span>
							<input type="hidden" id="deptNm" class="selectedTitle" name="deptNm">
							<input type="hidden" id="deptByCoStr" class="selectedTitle" name="deptNm">
							<input type="hidden" id="deptByCoVal" name="deptCd">
							<input type="hidden" name="createId" value="${_USERCREDENTIAL_.adminId}">
							<input type="hidden" name="updateId" value="${_USERCREDENTIAL_.adminId}">
						</div>
					</div>

					<%if (isIPv6) { %>
					<div class="row">
						<div class="col-35">
							<label for="attachTypePopInput" class="fname"><s:message code="didBlock.startip"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="startIp" id="startIp"
							       placeholder="<s:message code="didBlock.startip"/>" required>
							<p>
								<span style='color:grey;'>[ex: IPv4 - 192.168.0.12 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IPv6 - 2002:9b3d:1a32:4:208:74ff:fe39:6c43]</span>
							</p>
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="attachDescPopInput" class="fname"><s:message code="didBlock.endip"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="endIp" id="endIp"
							       placeholder="<s:message code="didBlock.endip"/>" required>
							<p>
								<span style='color:grey;'>[ex: IPv4 - 192.168.0.12 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IPv6 - 2002:9b3d:1a32:4:208:74ff:fe39:6c43]</span>
							</p>
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="attachDescPopInput" class="fname"><s:message code="common.msg.comment"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="comment" id="comment"
							       placeholder="<s:message code="common.msg.comment"/>" maxlength="500">
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="attachTypePopInput" class="fname"></label>
						</div>
						<div class="col-65">
							<input type="hidden" class="w100" name="orgStartIp" id="orgStartIp">
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="attachTypePopInput" class="fname"></label>
						</div>
						<div class="col-65">
							<input type="hidden" class="w100" name="orgEndIp" id="orgEndIp">
						</div>
					</div>

					<%} else {%>

					<div class="row">
						<div class="col-35">
							<label for="attachTypePopInput" class="fname"><s:message code="didBlock.startip"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="startIp" id="startIp"
							       placeholder="<s:message code="didBlock.startip"/>" required>
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="attachDescPopInput" class="fname"><s:message code="didBlock.endip"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="endIp" id="endIp"
							       placeholder="<s:message code="didBlock.endip"/>" required>
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="attachDescPopInput" class="fname"><s:message code="common.msg.comment"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="comment" id="comment"
							       placeholder="<s:message code="common.msg.comment"/>" maxlength="500">
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="attachTypePopInput" class="fname"></label>
						</div>
						<div class="col-65">
							<input type="hidden" class="w100" name="orgStartIp" id="orgStartIp">
						</div>
					</div>


					<div class="row">
						<div class="col-35">
							<label for="attachTypePopInput" class="fname"></label>
						</div>
						<div class="col-65">
							<input type="hidden" class="w100" name="orgEndIp" id="orgEndIp">
						</div>
					</div>


					<%} %>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 savePopBtn" accesskey="S"><s:message
							code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>

<div id="upload_file"></div>
<div class="modal" id="uploadPop" aria-labelledby="uploadPop"  data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="uploadForm" enctype="multipart/form-data" target="upload_file">
			<div class="modalHead">
				<h2><s:message code="deptIpRange.set.iprange"/>-<s:message code="keyword.msg.upload"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="comment" class="fname"><s:message code="keyword.msg.colseparator"/></label>
						</div>
						<div class="col-65">
							<select class="optiotab" id="separator" name="separator">
								<option value=",">,</option>
								<option value="|">|</option>
							</select>
							<select class="optiotab" id="encoding" name="encoding">
								<option value="utf-8">UTF-8</option>
								<option value="euc-kr">EUC-KR</option>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="comment" class="fname"><s:message code="keyword.select.file"/></label>
						</div>
						<div class="col-65">
							<div>
								<label for="attach" class="pop_btn02" style="height: 26px;"><span style="line-height: 1.8;"><s:message code="keyword.select.file"/></span></label>
								<span style="font-family: Pretendard !important;  color:#333; background: #FFF; width:40%; height:26px; line-height: 1.8;  padding:0 8px; vertical-align:middle;  font-size:14px; position: absolute;" id="attachFileName"> <s:message code="keyword.msg.upload.file"/></span>
							</div>
							<span id="attachSpan"><input type="file"  name="attach" id="attach" style="display:none"></span>
						</div>
					</div>
				</div>
				<div class="info"> <s:message code="common.guidance"/>
					<div class="form-inline" style="margin-top:10px;padding-left:10px;"> 1) <s:message code="keyword.message.upload.info1"/></div>
					<div class="form-inline" style="padding-left:10px;"> 2) <s:message code="deptIpRange.msg.upload.info"/></div>
					<div class="form-inline" style="padding-left: 10px;"> 3) <s:message code="keyword.message.upload.info3"/></div>
					<div class="form-inline" style="padding-left: 10px;"> 4) <s:message code="keyword.message.upload.info4"/></div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 uploadPopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>



<div class="modal" id="setDeptApiPop" tabindex="-1" role="dialog" aria-labelledby="setDeptApiPop">
	<div class="modal-content">
		<form method="post" id="setDeptApiPopForm">
		<div class="modalHead">
			<h2><s:message code="deptIpRange.set.api"/></h2>
			<span class="close" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalCon">
			<div class="modalTop">
				<div class="modalTop">
					<h3><s:message code="deptIpRange.method.insa"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
					<fieldset>
						<div>
							<label  class="col-sm-4 radio-inline c-radio">
							<div class="radio">
								<input type="radio"  value="N" name="dept.auto">
								<span class="fa fa-check"></span><s:message code="userInfo.directlink"/>
							</div>
							</label>
							<label  class="col-sm-4 radio-inline c-radio">
							<div class="radio">
								<input type="radio" value="Y" name="dept.auto">
								<span class="fa fa-check"></span><s:message code="userInfo.autolink"/>
							</div>
							</label>
						</div>
					</fieldset>
				</div>
				<div class="modalbody">
						<div class="row">
							<div class="col-35">
								<label  class="fname"><s:message code="userInfo.filepath"/></label>
							</div>
						<div class="col-65">
								<input type="text" class="w100" name="comment" id="dept.path"
								       placeholder="<s:message code="common.message.input.filepath"/>" maxlength="255">
						</div>
						</div>
						<div class="row">
							<div class="col-35">
								<label  class="fname"><s:message code="userInfo.colseparator"/></label>
							</div>
							<div class="col-65">
								<select class="w100" id="dept.sepa">
									<option value="|" selected> | </option>
									<option value=","> , </option>
								</select>
							</div>
						</div>

					<div class="row">
						<div class="col-35">
							<label class="fname"><s:message code="userInfo.set.day"/></label>
						</div>
						<div class="col-65">
							<div class="checkbox"><input type="checkbox" value="A" id="allWeek"></span><label for="allWeek" style="margin-left:3px;" ><span class= "checktit"><s:message
									code="userInfo.all"/></span></label></div>
							<div class="checkbox"><input type="checkbox" name="dept.week" value="sun" id="sun" ><label for="sun" style="margin-left:3px;" ><span class= "checktit"><s:message
									code="common.sun"/></span></label></div>
							<div class="checkbox"><input type="checkbox" name="dept.week" class="dept.week" value="mon"  id="mon"><label for="mon" style="margin-left:3px;"  ><span class= "checktit"><s:message
									code="common.mon"/></span></label></div>
							<div class="checkbox"><input type="checkbox" name="dept.week" class="dept.week" value="tue"  id="tue"><label for="tue" style="margin-left:3px;" ><span class= "checktit"><s:message
									code="common.tue"/></span></label></div>
							<div class="checkbox"><input type="checkbox" name="dept.week" class="dept.week" value="wed"  id="wed"><label for="wed" style="margin-left:3px;" ><span class= "checktit"><s:message
									code="common.wed"/></span></label></div>
							<div class="checkbox"><input type="checkbox" name="dept.week" class="dept.week" value="thu" id="thu"><label for="thu" style="margin-left:3px;" ><span class= "checktit"><s:message
									code="common.thu"/></span></label></div>
							<div class="checkbox"><input type="checkbox" name="dept.week" class="dept.week" value="fri"  id="fri"><label for="fri" style="margin-left:3px;" ><span class= "checktit"><s:message
									code="common.fri"/></span></label></div>
							<div class="checkbox"><input type="checkbox" name="dept.week" class="dept.week" value="sat"  id="sat"><label for="sat"style="margin-left:3px;"  ><span class= "checktit"><s:message
									code="common.sat"/></span></label></div>
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label class="fname"><s:message code="userInfo.set.time"/></label>
						</div>
						<div class="col-65">
							<select  class="w100" id="dept.time" name="time">
								<option value="*"><s:message code="userInfo.clock.time"/></option>
								<option value="1"><s:message code="common.time.01"/></option>
								<option value="2"><s:message code="common.time.02"/></option>
								<option value="3"><s:message code="common.time.03"/></option>
								<option value="4"><s:message code="common.time.04"/></option>
								<option value="5"><s:message code="common.time.05"/></option>
								<option value="6"><s:message code="common.time.06"/></option>
								<option value="7"><s:message code="common.time.07"/></option>
								<option value="8"><s:message code="common.time.08"/></option>
								<option value="9"><s:message code="common.time.09"/></option>
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

					<div class="row">
						<div class="col-35">
							<label  class="fname"><s:message code="userInfo.no.column"/></label>
						</div>
						<div class="col-65">
							<div style="font-size:12px; font-family: Pretendard; "> <s:message code="deptIpRange.msg.upload.info"/> </div>
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label  class="fname"> <s:message code="userInfo.direct.execute"/></label>
						</div>
						<div class="col-65">
							<button id="directExecuteBtn" type="button" accesskey="D" class="form_btn01_02" style="margin-left: 84px"><span><s:message code="userInfo.direct.execute"/></span></button>
						</div>
					</div>
					<div class="modalfooter">
						<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
						<button type="button" class="pop_btn02" id="setDeptPopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
					</div>

				</div>
			</div>
		</div>
		</form>
	</div>
</div>


	<div>
		<div class="searchArea">
			<div class="searchSub">
				<div>
					<input type="text"  placeholder="<s:message code="ipRange.msg.enter.busicomment"/>" id="searchStrInput">
					<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.msg.search"/></button>
				</div>
				<div class="btnform">
				<button type="button" class="btn01" accesskey="I" id="insertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
				<button type="button" class="btn02" accesskey="D" id="deleteBtn"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
				<button type="button" class="btn03" accesskey="U" id="uploadBtn"><span class="glyphicon glyphicon-import"></span>&nbsp;Upload</button>
				<button type="button" class="btn05" accesskey="S"  id="setDeptApiBtn"><span class="glyphicon glyphicon-cog"></span>&nbsp;<s:message code="deptIpRange.set.api"/></button>
				<div id="deptComment" style="margin-left: 455px;margin-top: -15px;font-weight: bold; color:#f25643;display: none;width: 630px;"><s:message code="deptIpRange.msg.insa.auto"/></div>
				</div>
			</div>
		</div>

		<div class="content xcn_full">
			<div class="contentSub">
				<div class="subtab">
					<button class="active">
						<s:message code="POLICY_SETUP.DEPT_IPRANGE"/>
						<span id="relationKeywordCount"></span>
					</button>
				</div>
				<div id="ipRangeDeptListGrid" class="slickGrid gridArea"></div>
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
        grid.colAdd('createId', '<s:message code="filterInfo.createId"/>', 140, 'center', false, 'nomal');
        grid.colAdd('updateDt', '<s:message code="filterInfo.updateDt"/>', 140, 'center', false, 'nomal');
        grid.colAdd('updateId', '<s:message code="filterInfo.updateId"/>', 140, 'center', false, 'nomal');
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