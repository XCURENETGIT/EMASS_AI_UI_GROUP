<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LTH - <s:message code="condition.select.condition"/></title>
<%@ include file="../base.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/jquery.nouislider.min.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/bootstrap-datetimepicker.min.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/bootstrap-select.min.css"/>"/>

<script type="text/javascript" src="<c:url value="/js/moment.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/Date.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ko.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-select.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/nouislider.js"/>"></script>
<style type="text/css">
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
.bootstrap-select {
	width: auto;
}
.bootstrap-select.btn-group[class*=col-] .dropdown-menu.open{
	left:0;
	right:auto;
}
.selecBtnArea .btn{
	padding: 2px 20px 2px 10px;
}
.selecBtnArea .bootstrap-select{
	margin-top:3px;
	margin-bottom:2px;
}

#selectedCodeTitle {
	display:none;
	border: 1px solid #458A45;
	position: absolute;
	background-color: #5CB85C;
	color: #fff;
	z-index: 999;
	font-size: 15px;
	padding: 3px;
	max-width: 400px;
	word-break: break-all;
}
.bootstrap-select.btn-group .dropdown-menu.inner {
	box-shadow: none !important;
}
</style>
<script type="text/javascript">
function initLayout() {
	$("input").prop("disabled", true);
	$("select").prop("disabled", true);
}
$(document).ready(function(){
	initLayout();
	conditionSetup( );
	//sizeRangeSetup( );
	
	setSelectpicker();
	initInterestUser();
	initUserGroupList();
	
	$('#popCloseBtn').click(function(){ self.close(); });
	
	var conditions = opener.conditions;
	setCondition( conditions );
});

function resetCode(codeType){
	$('#'+codeType+'Val').val('');
	$('#'+codeType+'Str').val('');
	$('#'+codeType+'SelectedArea').hide();
}

function checkRadioBtn( name, val ){
	$('input:radio[name='+name+']:input[value='+val+']').prop('checked',true);
}

function arrayToString( array ){
	if( array == null || array == undefined ) return "";
	else{
		return array.toString();
	}
}

function stringToArray( string ){
	if( string == null || string == undefined || string == '' ) return '';
	else if( typeof string !='string') return string;
	else{
		return string.split(',');
	}
}
function toDateFormat(d) {
	return d.substring(0,4) + '-' + d.substring(4,6) + '-' + d.substring(6,8) + ' ' + d.substring(8,10) + ':' + d.substring(10,12) + ':' + d.substring(12,14);
}
function setCondition( conditionVal ){
	if(conditionVal.query == undefined || conditionVal.query == '') {
		$(".condition").show();
		$(".solrQuery").hide();
		
		var consentStr = opener.consentStr;
		if( consentStr == "") {
			$(".consent").hide();
		} else {
			$('#consentStr').val( consentStr );
			$(".consent").show();	
		}
		
		$('#startDt').val(toDateFormat(conditionVal.startDt));
		$('#endDt').val(toDateFormat(conditionVal.endDt));
		
		$('#searchStrInput').val( conditionVal.searchStr );
		$('#searchField').selectpicker('val', conditionVal.searchField );
		$('#searchField').selectpicker( "refresh" );
		
		$('#senders').val( conditionVal.senders );
		$('#receivers').val( conditionVal.receivers );
		$('#rcvTo').val( conditionVal.rcvTo );
		$('#rcvCc').val( conditionVal.rcvCc );
		$('#rcvBcc').val( conditionVal.rcvBcc );
		$('#rcvJikgub').val( conditionVal.rcvJikgub );
		$('#allOfus').selectpicker( 'val', conditionVal.allOfus );
		
		checkRadioBtn( 'readYnVal', conditionVal.readYn );
		checkRadioBtn( 'receiveSendVal', conditionVal.receiveSend );
		checkRadioBtn( 'ctimeWorkVal', conditionVal.ctimeWork );
		
		checkRadioBtn( 'attachYnVal', conditionVal.attachYn );
		if(conditionVal.attachVal != "") {
			$('#attachList').val( conditionVal.attachStr ).show().attr('title', conditionVal.attachStr);
		}
		
		checkRadioBtn( 'keywordYnVal', conditionVal.keywordYn );
		if(conditionVal.keywordVal != "") {
			$('#keywordList').val( conditionVal.keywordStr ).show().attr('title', conditionVal.keywordStr);
		}
		
		checkRadioBtn( 'regexpYnVal', conditionVal.regexpYn );
		if(conditionVal.regexpVal != "") {
			$('#regexpList').val( conditionVal.regexpStr ).show().attr('title', conditionVal.regexpStr);
		}
		
		if(conditionVal.deptStr != "") {
			$('#deptVal').val( conditionVal.dept );
			setSelectedCodeData("dept", conditionVal.deptVal, conditionVal.deptStr);
		}
		
		checkRadioBtn( 'regexp_drmYnVal', conditionVal.drmYn );
		checkRadioBtn( 'regexp_sctYnVal', conditionVal.sctYn );
		
		$('#sizeStartVal').val( convertFileSize(conditionVal.sizeStartVal) );
		$('#sizeEndVal').val( convertFileSize(conditionVal.sizeEndVal) );
		if( conditionVal.sizeOption == 'B' ) {
			$('#sizeStartVal, #sizeEndVal, #sizeRangeValStr').show();
		} else {
			$('#sizeStartVal').show();
		}
		
		
		$('#sizeFilterSelect').val(conditionVal.sizeOption);
		$('#sizeFilterType').val(conditionVal.sizeType);
		
		$('#sizeFilterSelect').selectpicker( "refresh" );
		
		setTimeout(function(){
			$('#serviceTypeSelect').selectpicker('val', stringToArray(conditionVal.serviceType));
			$('#serviceTypeSelect').selectpicker( "refresh" );
			$('#busiSelect').selectpicker('val', stringToArray(conditionVal.busi) );
			$('#busiSelect').selectpicker( "refresh" );
			
			$('#interGroup').selectpicker('val', conditionVal.interGroup);
			$('#interGroup').selectpicker( "refresh" );
			
			$('#userGroupSeq').selectpicker('val', stringToArray(conditionVal.userGroupSeq) );
			$('#userGroupSeq').selectpicker( "refresh" );
		}, 300);
		
		$('.btn-group').click(function(event) {
			  event.stopPropagation();
		});
	} else {
		$(".condition").hide();
		$(".solrQuery").show();
		
		//resizeTo(656,350);
		
		$('#solrQueryText').val( conditionVal.query );	
	}
}

function conditionSetup( ){
	$('#searchField').selectpicker({
		container:'body',
		width:'120px',
		noneSelectedText:'<s:message code="common.msg.all"/>'
	});
	
	var width = '412px';
	$('#serviceTypeSelect').selectpicker({
		container:'body',
		size: 15,
		width:width,
		searchLabel:true,
		noneSelectedText:'<s:message code="condition.service.all"/>',
		noneResultsText:'<s:message code="common.msg.noresult"/> ',
		selectAllText:'<s:message code="common.msg.select_all"/>',
		deselectAllText:'<s:message code="common.msg.unselect_all"/>'
	});
	$('#sizeFilterSelect').selectpicker({
		container:'body'
	});
	
	$('#busiSelect').selectpicker({
		container:'body',
		size: 15,
		width:width,
		searchLabel:true,
		noneSelectedText:'<s:message code="common.org.busi.all"/>',
		noneResultsText:'<s:message code="common.msg.noresult"/> ',
		selectAllText:'<s:message code="common.msg.select_all"/>',
		deselectAllText:'<s:message code="common.msg.unselect_all"/>'
	});
	
	$('#allOfus').selectpicker({
		container:'body',
		width:width
	});
}

function setSelectpicker(){
	getCodeList('busi');
	getServiceTypeList( );
}

var serviceGroups=[];
var serviceTypes=[];
var specialService=[];
var parentCode = [];
function getServiceGroupList( ){
	var str = '';
	for (var i = 0; i < serviceTypes.length; i++) {
		if( str.indexOf(serviceTypes[i].groupCd ) == -1){
			str += serviceTypes[i].groupCd + ',';
		}
		if(serviceTypes[i].serviceCd.length == 4) {
			specialService.push(serviceTypes[i]);
		}
	}
	serviceGroups = str.substring(0, str.length-1).split(',');
	
	$('#serviceTypeSelect').html(getServiceOptionStr( ));
	getServiceOptionLiveSearch(parentCode);
	$('#serviceTypeSelect').selectpicker('refresh');
}

function getServiceTypeList( ){
	ui.get({
		url : 'getServiceListByAuth.xcn',
		success : function(data, total) {
			serviceTypes = data;
			getServiceGroupList( );
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}

function getServiceOptionStr( ){
	var str = '';
	for (var i = 0; i < serviceGroups.length; i++) {
		var selectedVal = serviceGroups[i];
		var idx = 0;
		for (var j = 0; j < serviceTypes.length; j++) {
			if( selectedVal == serviceTypes[j].groupCd){
				if( idx == 0 ){
					str += '<optgroup label="'+serviceTypes[j].groupNm+'">';
				}
				if( serviceTypes[j].serviceCd.length == 3){
					str += getServiceOptionChildren(serviceTypes[j]);
				} else if ( serviceTypes[j].serviceCd.length == 4 ) continue; 
				else str += '<option value="'+serviceTypes[j].serviceCd+'">'+serviceTypes[j].serviceNm+'</option>';
				idx++;
			}
		}
		if( idx != 0 ) str += '</optgroup>';
	}
	return str;
}
function getServiceOptionChildren(serviceType) {
	var result = '<option value="'+serviceType.serviceCd+'">'+serviceType.serviceNm+'</option>';
	for (var i = 0; i < specialService.length; i++) {
		var service = specialService[i];
		if( service.serviceCd.indexOf(serviceType.serviceCd) > -1 ) {
			if(!parentCode.includes(serviceType.serviceCd)) parentCode.push(serviceType.serviceCd);
			result += '<option value="'+service.serviceCd+'"> └ '+service.serviceNm+'</option>';
		}
	}
	
	return result;
} 
function getServiceOptionLiveSearch(code) {
	var searchWord = "";
	
	for (var i = 0; i < code.length; i++) {
		var pCode = code[i];
		for(var j = 0; j < specialService.length; j++) {
			if( specialService[j].serviceCd.indexOf(pCode) > -1 ) {
				searchWord += specialService[j].serviceNm + " ";
			}
		}
		$('[value=' + pCode + ']').attr('data-tokens', searchWord);
		searchWord = "";
	}
}

function getCodeList( codeType ){
	ui.get({
		url 		: 'getCodeList.xcn',
		codeType	: codeType,
		success 	: function(data, total) {
			$('#'+codeType+'Select').html(getSelectOption( data ));
			$('#'+codeType+'Select').selectpicker('refresh');
		},
		error 		: function(status, message) {
			ui.alertMsg(message);
		},
		complete 	: function() {
		    searchFlag=false;
		}
	});
}
function getSelectOption( data ){
	var str = '';
	for (var i = 0; i < data.length; i++) {
		str += '<option value="'+data[i].code+'">'+data[i].codeName+'</option>';
	}
	return str;
}

function initInterestUser(){
	ui.get({
		url : 'getAdminUserGroupList.xcn',
		success : function(data, total) {
			getInterestUserOptions(data, '');
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}
function initUserGroupList(){
	ui.get({
		url : 'getUserGroupList.xcn',
		logYn : 'Y',
		success : function(data, total) {
			getUserGroupListOptions(data, '');
		},
		error : function(status, message) {
			//ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}
/**
 * 관심사용자 리스트 조회
 */
function getInterestUserOptions(data){
	$('#interGroup').selectpicker({
		container:'body',
		width:'412px',
		noneSelectedText:'-<s:message code="condition.select.interest"/>-'
	});
	
	var result='<option value="">-<s:message code="condition.select.interest"/>-</option>';
	result+='<option value="all"><s:message code="interest.user.all"/></option>';
	for(var i=0 ; i<data.length; i++){
		result+='<option value="' + data[i].groupSeq + '">' +  data[i].groupName + '</option>';
	}
	$("#interGroup").html(result);
	$("#interGroup").selectpicker('refresh');
}
function getUserGroupListOptions(data){
	$('#userGroupSeq').selectpicker({
		container:'body',
		width:'412px',
		noneSelectedText:'-<s:message code="userGroup.navi.title2"/>-'
	});
	
	var result='';
	for(var i=0 ; i<data.length; i++){
		result+='<option value="' + data[i].groupCode + '">' +  data[i].groupName + '</option>';
	}
	$("#userGroupSeq").html(result);
	$("#userGroupSeq").selectpicker('refresh');
}



function setSelectedCodeData( codeType, val, str) {
	$('#'+codeType+'Str').val(str);
	$('#'+codeType+'Val').val(val);
	
	
	if( $('#'+codeType+'Str').val() != '' ){
		var divStr = str;
		if(codeType == "attach") {
			divStr = val;	
		} 
		
		var divStrArray;
		
		if(codeType == "attach") {
			divStrArray = divStr.split("|");
		} else {
			divStrArray = divStr.split(",");
		}
		
		if(divStrArray.length == 1) {
			$('#'+codeType+'StrDiv').text(divStrArray[0]);
		} else {
			$('#'+codeType+'StrDiv').text(divStrArray[0] + "<s:message code='common.msg.etc'/>" + (divStrArray.length - 1)  + "<s:message code='common.msg.cnt'/>");	
		}
			
		$('#'+codeType+'SelectedArea').show();
	}else{
		$('#'+codeType+'SelectedArea').hide();
	}
}


</script>
</head>
<body class="mini-navbar">
	<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="condition.select.search"/></span>
		</div>
	</header>
	<div class="xcn_container" >
		<div class="boxArea" style="padding-bottom:0;">
			<div class="content_body">
				<div id="selectedCodeTitle"></div>
				
				
				<div class="row">
					<div class="col-sm-12">
						<div class="smartfilter">
							<div style="text-align: right;">
								<button type="button" class="btn btn-sm btn-default" accesskey="C" id="popCloseBtn"><i class="glyphicon glyphicon-remove"></i><s:message code="common.msg.close"/></button>
							</div>
						</div>
						<div class="form-group form-inline filterDiv condition consent">
							<label for="consentStr" class="control-label col-xs-3"><s:message code="consent.consent"/></label>
							<div class="input-group">
								<input type="text" class="form-control input-sm" id="consentStr" style="width: 300px;" />
							</div>
						</div>
						
						<div class="form-group form-inline">
							<label for="serviceTypeSelect" class="control-label col-xs-3"><s:message code="condition.service"/></label>
							<select id="serviceTypeSelect" class="selectpicker col-xs" data-style="btn-default btn-sm" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
						</div>
						
						<div class="form-group form-inline">
							<label for="searchField" class="control-label col-xs-3"><s:message code="condition.field.search"/></label>
							<select id="searchField" class="selectpicker col-xs" data-style="btn-default btn-sm">
								<option value=""><s:message code="condition.field.search"/></option>
								<option value="subject"><s:message code="condition.subject"/></option>
								<option value="body"><s:message code="condition.body"/></option>
								<option value="attachname attachname_str"><s:message code="condition.attach_name"/></option>
								<%if(!isOCR){ %>
								<option value="attach"><s:message code="condition.attach"/></option>
								<%}else{ %>
								<option value="attach ocr_attach"><s:message code="condition.attach"/></option>
								<option value="ocr_attach">OCR</option>
								<%} %>
								<option value="host host_str">Host</option>
								<option value="path">Path</option>
								<option value="srcip"><s:message code="condition.source"/> IP</option>
								<option value="dstip"><s:message code="condition.destination"/> IP</option>
								<option value="sender_str"><s:message code="condition.sender"/></option>
								<option value="sname"><s:message code="condition.sender_name"/></option>
								<option value="recvs"><s:message code="condition.recv"/></option>
								<option value="recvs_name"><s:message code="condition.recv_name"/></option>
								<option value="to tname"><s:message code="condition.recv"/>(<s:message code="condition.to"/>)</option>
								<option value="cc cname"><s:message code="condition.recv"/>(<s:message code="condition.cc"/>)</option>
								<option value="bcc bname"><s:message code="condition.recv"/>(<s:message code="condition.bcc"/>)</option>
								<option value="user user_str userid name"><s:message code="common.org.user"/></option>
								<option value="usr_id"><s:message code="common.msg.account"/></option>
							</select>
							<input type="search" class="form-control input-sm" id="searchStrInput" placeholder="<s:message code="condition.search_str"/>" />
						</div>
						
						<div class="form-group form-inline">
							<label for="day_msg" class="control-label col-xs-3"><s:message code="condition.period.setting"/></label>
							<div id="day_msg" style="display:inline-flex;">
								<div class="input-group">
									<div class="input-group date" id="startdatepicker">
										<input type="text" id="startDt" class="input-sm form-control border-radius-none" style="width: 130px;" />
									</div>
								</div>
								&nbsp;
								<div class="input-group" style="line-height: 28px;">~</div>
								&nbsp;
								<div class="input-group">
									<div class="input-group date" id="enddatepicker">
										<input type="text" id="endDt" class="input-sm form-control border-radius-none" style="width: 130px;" />
									</div>
								</div>
							</div>
							<div id="time_msg" style="display: none;">
								<span><s:message code="mail.message.condition_info"/></span>
							</div>
						</div>
						
						<div class="form-inline" id="recvSendGroup">
							<label for="" class="control-label col-xs-3"><s:message code="condition.receive_send"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="receiveSendVal" value="" checked><span class="fa fa-check"></span><s:message code="common.msg.all"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="receiveSendVal" value="I"><span class="fa fa-check"></span><s:message code="condition.receive"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="receiveSendVal" value="O"><span class="fa fa-check"></span><s:message code="condition.send"/></label>	
							<input type="hidden" name="receiveSend" id="receiveSend">
						</div>
						
						<div class="form-inline" id="ctimeWorkGroup">
							<label for="" class="control-label col-xs-3"><s:message code="condition.ctimework"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="ctimeWorkVal" value="" checked><span class="fa fa-check"></span><s:message code="condition.ctimework.all"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="ctimeWorkVal" value="W"><span class="fa fa-check"></span><s:message code="condition.work"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="ctimeWorkVal" value="R"><span class="fa fa-check"></span><s:message code="condition.notwork"/></label>	
							<input type="hidden" name="ctimeWork" id="ctimeWork">
						</div>
							
						<div class="form-inline" id="readYnGroup">
							<label for="" class="control-label col-xs-3"><s:message code="condition.isread"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="readYnVal" value="" checked><span class="fa fa-check"></span><s:message code="common.msg.all"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="readYnVal" value="Y"><span class="fa fa-check"></span><s:message code="condition.read"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="readYnVal" value="N"><span class="fa fa-check"></span><s:message code="condition.unread"/></label>	
							<input type="hidden" name="readYn" id="readYn">
						</div>
						
						<div class="form-group form-inline">
							<label for="receivers" class="control-label col-xs-3"><s:message code="condition.receiver_sender"/></label>
							<div class="input-group">
								<input type="text" class="form-control input-sm" id="receivers" placeholder="<s:message code="condition.recv"/>"/>
							</div>
							<div class="input-group">
								<input type="text" class="form-control input-sm" id="senders" placeholder="<s:message code="condition.sender"/>"/>
							</div>
						</div>
						
						<div class="form-group form-inline">
							<label for="busiSelect" class="control-label col-xs-3"><s:message code="common.org.businm"/></label>
							<div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
								<select id="busiSelect" class="selectpicker col-xs" data-style="btn-default btn-sm" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
							</div>
							<label for="" class="control-label col-xs-3"></label>
						</div>
						
						<div class="form-inline">
							<label for="deptStrDiv" class="control-label col-xs-3"><s:message code="common.org.deptnm"/></label>
							<div class="input-group">
								<div id="deptStrDiv" class="codeSelectedDiv"></div>
							</div>
						</div>
						
						<div class="form-group form-inline">
							<label for="allOfus" class="control-label col-xs-3"><s:message code="condition.allofus"/></label>
							<div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
								<select class="selectpicker col-xs" id="allOfus" data-style="btn-default btn-sm" style="width:100%;">
									<option value=""><s:message code="condition.allofus.all"/></option>
									<option value="IA">1) <s:message code="condition.allofus1"/></option> 
									<option value="EA">2) <s:message code="condition.allofus2"/></option> 
									<option value="PA">3) <s:message code="condition.allofus3"/></option> 
									<option value="IA|EA">4) <s:message code="condition.allofus4"/></option> 
									<option value="EA|PA">5) <s:message code="condition.allofus5"/></option> 
									<option value="IA|PA">6) <s:message code="condition.allofus6"/></option> 
									<option value="IA|IT">7) <s:message code="condition.allofus7"/></option> 
									<option value="ET|EA">8) <s:message code="condition.allofus8"/></option> 
									<option value="PT|PA">9) <s:message code="condition.allofus9"/></option> 
									<option value="IA|ET|IT|EA">10) <s:message code="condition.allofus10"/></option> 
									<option value="IA|IT|PT|PA">11) <s:message code="condition.allofus11"/></option> 
									<option value="ET|EA|PT|PA">12) <s:message code="condition.allofus12"/></option>
									<option value="SO">13) <s:message code="condition.allofus13"/></option>
									<option value="SI">14) <s:message code="condition.allofus14"/></option>
								</select>
							</div>
						</div>
						
						<div class="form-group form-inline">
							<label for="userGroupSeq" class="control-label col-xs-3"><s:message code="userGroup.navi.title2"/></label>
							<div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
								<select id="userGroupSeq" class="selectpicker col-xs" data-style="btn-default btn-sm"></select>
							</div>
							<input type="hidden" id="userGroupStr" >
						</div>
							
						<div class="form-group form-inline">
							<label for="interGroup" class="control-label col-xs-3"><s:message code="interest.user"/></label>
							<div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
								<select id="interGroup" class="selectpicker col-xs" data-style="btn-default btn-sm" ></select>
							</div>
						</div>
						
						<!-- 첨부여부 -->
						<div class="form-inline">
							<label for="" class="control-label col-xs-3"><s:message code="condition.isattached"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="attachYnVal" value="" checked><span class="fa fa-check"></span><s:message code="common.msg.all"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="attachYnVal" value="Y"><span class="fa fa-check"></span><s:message code="condition.exist"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="attachYnVal" value="N"><span class="fa fa-check"></span><s:message code="condition.none"/></label>	
							<input type="text" class="form-control input-sm" id="attachList" style="display: none; width: 220px;"/>
						</div>
						
						<!-- 예약어 -->
						<div class="form-inline">
							<label for="" class="control-label col-xs-3"><s:message code="condition.keyword"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="keywordYnVal" value="" checked><span class="fa fa-check"></span><s:message code="common.msg.all"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="keywordYnVal" value="Y"><span class="fa fa-check"></span><s:message code="condition.exist"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="keywordYnVal" value="N"><span class="fa fa-check"></span><s:message code="condition.none"/></label>	
							<input type="text" class="form-control input-sm" id="keywordList" style="display: none; width: 220px;"/>
						</div>
						
						<!-- 패턴검출 -->
						<div class="form-inline">
							<label for="" class="control-label col-xs-3"><s:message code="condition.regexp.detect"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="regexpYnVal" value="" checked><span class="fa fa-check"></span><s:message code="common.msg.all"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="regexpYnVal" value="Y"><span class="fa fa-check"></span><s:message code="condition.exist"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="regexpYnVal" value="N"><span class="fa fa-check"></span><s:message code="condition.none"/></label>	
							<input type="text" class="form-control input-sm" id="regexpList" style="display: none; width: 220px;"/>
						</div>
						
						<!-- DRM -->
						<div class="form-inline">
							<label for="" class="control-label col-xs-3">DRM</label>
							<label class="radio-inline c-radio"><input type="radio" name="regexp_drmYnVal" value="" checked><span class="fa fa-check"></span><s:message code="common.msg.all"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="regexp_drmYnVal" value="Y"><span class="fa fa-check"></span><s:message code="condition.exist"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="regexp_drmYnVal" value="N"><span class="fa fa-check"></span><s:message code="condition.none"/></label>	
						</div>
						
						<!-- 수신필터 -->
						<div class="form-inline">
							<label for="" class="control-label col-xs-3"><s:message code="condition.sct"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="regexp_sctYnVal" value="" checked><span class="fa fa-check"></span><s:message code="common.msg.all"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="regexp_sctYnVal" value="Y"><span class="fa fa-check"></span><s:message code="condition.exist"/></label>
							<label class="radio-inline c-radio"><input type="radio" name="regexp_sctYnVal" value="N"><span class="fa fa-check"></span><s:message code="condition.none"/></label>	
						</div>
						
						<div class="form-inline">
							<label for="" class="control-label col-xs-3"><s:message code="filterInfo.size"/></label>
							<div class="selecBtnArea">
								<select class="selectpicker col-xs" data-style="btn-primary" id="sizeFilterType">
									<option value=""><s:message code="condition.size.all"/></option>
									<option value="B"><s:message code="condition.size.body"/></option>
									<option value="A"><s:message code="condition.size.attach"/></option>
								</select>
								<select class="selectpicker col-xs" data-style="btn-primary" id="sizeFilterSelect">
									<option value="L"><s:message code="condition.over"/></option>
									<option value="S"><s:message code="condition.below"/></option>
									<option value="B"><s:message code="condition.range"/></option>
								</select>
								<input type="text" class="form-control input-sm" id="sizeStartVal" style="width: 90px; display: none;"/>
								<span id="sizeRangeValStr" style="display: none;"> ~ </span>
								<input type="text" class="form-control input-sm" id="sizeEndVal" style="width: 90px; display: none;"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>