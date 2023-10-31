<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LTH - <s:message code="common.msg.setting"/></title>

<%@ include file="./base.jsp"%>
<style type="text/css">
html, body {
	min-width: 600px;
	height : 100%;
	background-color: #fff;
	overflow : auto !important;
}

.form-group {
	border-bottom: 1px dashed #eee;
	padding-top: 13px;
}
</style>
<script type="text/javascript">
$(document).ready(function(){
	var action;
	$(".number-spinner button").mousedown(function () {
		var btn = $(this);
		var input = btn.closest('.number-spinner').find('input');
		btn.closest('.number-spinner').find('button').prop("disabled", false);
		if (btn.attr('data-dir') == 'up') {
			action = setInterval(function(){
				if ( input.attr('max') == undefined || parseInt(input.val()) < parseInt(input.attr('max')) ) {
					input.val(parseInt(input.val())+1);
				} else{
					btn.prop("disabled", true);
					clearInterval(action);
				}
			}, 50);
		} else {
			action = setInterval(function(){
				if ( input.attr('min') == undefined || parseInt(input.val()) > parseInt(input.attr('min')) ) {
					input.val(parseInt(input.val())-1);
				} else{
					btn.prop("disabled", true);
					clearInterval(action);
				}
			}, 50);
		}
	}).mouseup(function(){
		clearInterval(action);
	});
	$('#'+idIndicator('sms.enable')).change(function(){
		changeSMSConf();
	});

	$('#'+idIndicator('mail.audit.used')).change(function(){
		checkMailAudit();
	});
	$('#'+idIndicator('mail.forward.flag')).change(function(){
		changeMailConf();
	});
	
	$('input:radio[name=mail\\.auth]').click(function(){
		changeMailAuth();
	});
	$(".nav-pills a").click(function(){
		$('.applyBtn').prop('disabled',false);
		currentTab = $(this).attr('href');
	});
	
	$('.applyBtn').click(function(){
		$(this).prop('disabled',true);
		var data = valueCheck();
		if(!data) $(this).prop('disabled',false);
		else setConfig(data);
	});

	$('#mailSendBtn').click(function(){
		mailSendTest();
	});
	
	$('#smsSendBtn').click(function(){
		smsSendTest();
	});
	
	ui.on('bodyLoading');
	ui.get({
		url : 'getConfList.xcn',
		success : function ( data, total ) {
			setVal(data, 'default.lang');
			setVal(data, 'system.login.msg');
			setCheckVal(data, 'ui.ipv6');
			setCheckVal(data, 'ui.dashboard.abbreviation');
			setVal(data, 'ui.inout.delimiter');

			setVal(data, 'long.term.unused');
			setVal(data, 'password.change.day');
			setVal(data, 'password.fail.count');
			setVal(data, 'password.restore.minute');
			setVal(data, 'session.timeoutSecond');
			setRadioVal(data, 'session.duplication.type');

			setCheckVal(data, 'consent.menu.enable');
			setCheckVal(data, 'consent.history.enable');

			setCheckVal(data, 'mail.forward.flag');
			setVal(data, 'mail.smtp.host');
			setVal(data, 'mail.smtp.port');
			setVal(data, 'system.mail.addr');
			setCheckVal(data, 'mail.ssl');
			setCheckVal(data, 'mail.audit.used');
			setVal(data, 'mail.audit.receiver');
			setCheckVal(data, 'mail.debug');

			setRadioVal(data, 'mail.auth');
			setVal(data, 'mail.smtp.id');
			setVal(data, 'mail.smtp.password');
			setVal(data, 'mail.subject.prefix');

			setCheckVal(data, 'sms.enable');
			setVal(data, 'sms.server.url');
			setVal(data, 'sms.token');
			
			setRadioVal(data, 'query.type');

			changeMailConf();
			changeSMSConf();
		},
		error : function (status, message) {
			ui.alertMsg(message);
		},
		complete : function (){
			ui.off('bodyLoading');
		}
	});
});

function valueCheck(){
	var data=[];
	var tab = getCurrentTab();
	if(tab == '#systemLang') {
		data.push({confId:'default.lang', val:$('#'+idIndicator('default.lang')).val()});
		data.push({confId:'system.login.msg', val:$('#'+idIndicator('system.login.msg')).val()});
		data.push({confId:'ui.ipv6', val:$('#'+idIndicator('ui.ipv6')).prop('checked')});
		data.push({confId:'ui.dashboard.abbreviation', val:$('#'+idIndicator('ui.dashboard.abbreviation')).prop('checked')});
	} else if(tab == '#account'){
		if(!numberCheck('long.term.unused', '<s:message code="setup.long.term.unused"/>')) return false;
		if(!numberCheck('password.change.day', '<s:message code="setup.password.change.day"/>')) return false;
		if(!numberCheck('password.fail.count', '<s:message code="setup.password.fail.count"/>')) return false;
		if(!numberCheck('password.restore.minute', '<s:message code="setup.password.restore.minute"/>')) return false;
		if(!numberCheck('session.timeoutSecond', '<s:message code="setup.session.timeoutSecond"/>')) return false;

		data.push({confId:'long.term.unused', val:$('#'+idIndicator('long.term.unused')).val()});
		data.push({confId:'password.change.day', val:$('#'+idIndicator('password.change.day')).val()});
		data.push({confId:'password.fail.count', val:$('#'+idIndicator('password.fail.count')).val()});
		data.push({confId:'password.restore.minute', val:$('#'+idIndicator('password.restore.minute')).val()});
		data.push({confId:'session.timeoutSecond', val:$('#'+idIndicator('session.timeoutSecond')).val()});
		data.push({confId:'session.duplication.type', val:$('input:radio[name=session\\.duplication\\.type]:checked').val()});
	} else if(tab=='#consent'){
		data.push({confId:'consent.menu.enable', val:$('#'+idIndicator('consent.menu.enable')).prop('checked')});
		data.push({confId:'consent.history.enable', val:$('#'+idIndicator('consent.history.enable')).prop('checked')});
	} else if(tab=='#mailServer'){
		if($('#'+idIndicator('mail.forward.flag')).prop('checked')){
			if(!emptyCheck('mail.smtp.host', '<s:message code="setup.mail.smtp.host"/>')) return false;
			if(!numberCheck('mail.smtp.port', '<s:message code="setup.mail.smtp.port"/>')) return false;
			if(!emptyCheck('system.mail.addr', '<s:message code="setup.system.mail.addr"/>')) return false;
			if(!emailCheck($('#'+idIndicator('system.mail.addr')).val())) return false;
			var checked = $('input:radio[name=mail\\.auth]:input[value=true]').prop("checked");
			if(checked){
				if(!emptyCheck('mail.smtp.id', '<s:message code="setup.mail.smtp.id"/>')) return false;
				if(!emptyCheck('mail.smtp.password', '<s:message code="setup.mail.smtp.password"/>')) return false;
			}
		}
		if($('#'+idIndicator('mail.audit.used')).prop('checked')){
			$('#'+idIndicator('mail.audit.receiver')).val($('#'+idIndicator('mail.audit.receiver')).val().trimAll())
			if(!emptyCheck('mail.audit.receiver', '<s:message code="mail.audit.receiver.empty.msg"/>')) return false;
			var receivers = $('#'+idIndicator('mail.audit.receiver')).val().split(';');
			for(var i=0 ; i < receivers.length ; i++) {
				if(!emailCheck(receivers[i])) return false;
			}
		}
		
		data.push({confId:'mail.forward.flag', val:$('#'+idIndicator('mail.forward.flag')).prop('checked')});
		data.push({confId:'mail.smtp.host', val:$('#'+idIndicator('mail.smtp.host')).val()});
		data.push({confId:'mail.smtp.port', val:$('#'+idIndicator('mail.smtp.port')).val()});
		data.push({confId:'system.mail.addr', val:$('#'+idIndicator('system.mail.addr')).val()});
		data.push({confId:'mail.ssl', val:$('#'+idIndicator('mail.ssl')).prop('checked')});
		data.push({confId:'mail.auth', val:$('input:radio[name=mail\\.auth]:input[value=true]').prop("checked")});
		data.push({confId:'mail.smtp.id', val:$('#'+idIndicator('mail.smtp.id')).val()});
		data.push({confId:'mail.smtp.password', val:$('#'+idIndicator('mail.smtp.password')).val()});
		data.push({confId:'mail.subject.prefix', val:$('#'+idIndicator('mail.subject.prefix')).val()});
		data.push({confId:'mail.audit.used', val:$('#'+idIndicator('mail.audit.used')).prop('checked')});
		data.push({confId:'mail.audit.receiver', val:$('#'+idIndicator('mail.audit.receiver')).val()});
		data.push({confId:'mail.debug', val:$('#'+idIndicator('mail.debug')).prop('checked')});
	} else if(tab=='#smsServer'){
		if($('#'+idIndicator('sms.enable')).prop('checked')){
			if(!emptyCheck('sms.server.url', '<s:message code="setup.sms.server.url"/>')) return false;
			if(!emptyCheck('sms.token', '<s:message code="setup.sms.token"/>')) return false;
		}
		data.push({confId:'sms.enable', val:$('#'+idIndicator('sms.enable')).prop('checked')});
		data.push({confId:'sms.server.url', val:$('#'+idIndicator('sms.server.url')).val()});
		data.push({confId:'sms.token', val:$('#'+idIndicator('sms.token')).val()});
	} else if(tab=='#searchConf'){
		data.push({confId:'query.type', val:$('input:radio[name=query\\.type]:input:checked').val()});
		data.push({confId:'ui.inout.delimiter', val:$('#'+idIndicator('ui.inout.delimiter')).val()});
	}
	return data;
}

function emptyCheck(id, title){
	var val = $('#'+idIndicator(id)).val();
	if(val=='') {
		ui.alertMsg('<s:message code="setup.input.value" arguments="'+title+'" />');
		return false;
	}
	return true;
}
function numberCheck(id, title){
	var val = $('#'+idIndicator(id)).val();
	var min = Number( $('#'+idIndicator(id)).attr('min') );
	var max = Number( $('#'+idIndicator(id)).attr('max') );
	if(val=='') {
		ui.alertMsg('<s:message code="setup.input.value" arguments="'+title+'" />');
		return false;
	}
	if(!val.isNumber()) {
		ui.alertMsg('<s:message code="setup.input.number" arguments="'+title+'" />');
		return false;
	}
	if(Number(val)>max) {
		ui.alertMsg('<s:message code="setup.range.max" arguments="'+title+','+max+'" />');
		return false;
	}
	if(Number(val)<min) {
		ui.alertMsg('<s:message code="setup.range.min" arguments="'+title+','+min+'" />');
		return false;
	}
	return true;
}

function setConfig(data){
	ui.confirmMsg('<s:message code="common.msg.confirm.apply"/>', '', '', function(rs){
		if(!rs) {
			$('.applyBtn').prop('disabled',false);
			return;
		}
		ui.on('bodyLoading');
		ui.get({
			url : 'setConf.xcn',
			data : JSON.stringify(data),
			success : function ( data, total ) {
				ui.alertMsg('<s:message code="common.msg.applied"/>');
			},
			error : function (status, message) {
				ui.alertMsg(message);
			},
			complete : function (){
				ui.off('bodyLoading');
				$('.applyBtn').prop('disabled',false);
			}
		});
	})
}

function mailSendTest(){
	
	$('#mailSendBtn').prop('disabled',true);
	
	if(!emptyCheck('testMailId', '<s:message code="mail.recv"/>')) {
		$('#mailSendBtn').prop('disabled',false);
		return false;
	}
	if(!emailCheck($('#'+idIndicator('testMailId')).val())) {
		$('#mailSendBtn').prop('disabled',false);
		return false;
	}
	
	var data = valueCheck();
	if(!data) $('#mailSendBtn').prop('disabled',false);
	
	ui.confirmMsg('<s:message code="mail.message.sendmail"/>', '', '', function(rs){
		if(!rs) {
			$('#mailSendBtn').prop('disabled',false);
			return;
		}
		ui.on('bodyLoading');
		ui.get({
			url : 'mailConfTest.xcn',
			testMailId : $('#testMailId').val(), 
			data : JSON.stringify(data),
			success : function ( data, total ) {
				ui.alertMsg('<s:message code="mail.message.success"/>');
			},
			error : function (status, message) {
				ui.alertMsg(message);
			},
			complete : function (){
				ui.off('bodyLoading');
				$('#mailSendBtn').prop('disabled',false);
			}
		});
	})
}

function smsSendTest(){
	$('#smsSendBtn').prop('disabled',true);
	
	if(!emptyCheck('testPhoneNo', '<s:message code="admin.hp"/>')) return false;
	
	var testPhoneNo = $('#testPhoneNo').val()
	if ( !checkPh( testPhoneNo) ) {
		ui.alertMsg( testPhoneNo +'<s:message code="admin.msg.wrong.hp"/>');
		$('#testPhoneNo').focus( );
		return;
	}
	
	var data = valueCheck();
	if(!data) $('#smsSendBtn').prop('disabled',false);
	
	ui.confirmMsg('<s:message code="setup.message.sms.send"/>', '', '', function(rs){
		if(!rs) {
			$('#smsSendBtn').prop('disabled',false);
			return;
		}
		ui.on('bodyLoading');
		ui.get({
			url : 'smsConfTest.xcn',
			testPhoneNo : $('#testPhoneNo').val(), 
			data : JSON.stringify(data),
			success : function ( data, total ) {
				ui.alertMsg('<s:message code="setup.message.sms.success"/>');
			},
			error : function (status, message) {
				ui.alertMsg(message);
			},
			complete : function (){
				ui.off('bodyLoading');
				$('#smsSendBtn').prop('disabled',false);
			}
		});
	})
}

function checkPh(phone) {
	if (/^((01[1|6|7|8|9])[1-9]+[0-9]{6,7})|(010[1-9][0-9]{7})$/.test(phone))
		return true;
	return false;
}

function getVal(data, id){
	for(var i=0 ; i < data.length ; i++){
		if(data[i].confId == id ) return data[i].val;
	}
	return '';
}
function setVal(data, id){
	for(var i=0 ; i < data.length ; i++){
		if(data[i].confId == id ) {
			$('#'+idIndicator(id)).val(data[i].val);
			$('#'+ idIndicator(id) + '\\.defaultVal').text(data[i].defaultVal);
			return;
		}
	}
}

function setCheckVal(data, id){
	for(var i=0 ; i < data.length ; i++){
		if(data[i].confId == id ) {
			$('#'+idIndicator(id)).prop('checked',eval(data[i].val));
			return;
		}
	}
}

function setRadioVal(data, id){
	for(var i=0 ; i < data.length ; i++){
		if(data[i].confId == id ) {
			$('input:radio[name='+idIndicator(id)+']:input[value='+data[i].val+']').prop("checked", true);
			return;
		}
	}
}

function getDefaultVal(data, id){
	for(var i=0 ; i < data.length ; i++){
		if(data[i].confId == id ) return data[i].defaultVal;
	}
	return '';
}
function idIndicator(id){
	return id.fReplaceWord('.', '\\.');
}
function changeSMSConf(){
	var checked = !$('#'+idIndicator('sms.enable')).prop('checked');
	$('#'+idIndicator('sms.server.url')).prop('disabled', checked);
	$('#'+idIndicator('sms.token')).prop('disabled', checked);
	
	$('#'+idIndicator('testPhoneNo')).prop('disabled', checked);
	$('#'+idIndicator('smsSendBtn')).prop('disabled', checked);
}
function checkMailAudit(){
	if(!$('#'+idIndicator('mail.forward.flag')).prop('checked')) $('#'+idIndicator('mail.audit.receiver')).prop('disabled', true);
	else if( $('#'+idIndicator('mail.audit.used')).prop('checked') ) $('#'+idIndicator('mail.audit.receiver')).prop('disabled', false);
	else $('#'+idIndicator('mail.audit.receiver')).prop('disabled', true);
}
function changeMailConf(){
	var checked = !$('#'+idIndicator('mail.forward.flag')).prop('checked');
	$('#'+idIndicator('mail.smtp.host')).prop('disabled', checked);
	$('#'+idIndicator('mail.smtp.port')).prop('disabled', checked);
	$('#'+idIndicator('system.mail.addr')).prop('disabled', checked);
	$('#'+idIndicator('mail.ssl')).prop('disabled', checked);
	$('#'+idIndicator('mail.smtp.id')).prop('disabled', checked);
	$('#'+idIndicator('mail.smtp.password')).prop('disabled', checked);
	
	$('#'+idIndicator('mail.audit.used')).prop('disabled', checked);
	
	$('#'+idIndicator('testMailId')).prop('disabled', checked);
	$('#'+idIndicator('mailSendBtn')).prop('disabled', checked);
	checkMailAudit();
	
	$("input[name="+idIndicator('mail.auth')+"]").prop("disabled", checked);
	$('#'+idIndicator('mail.subject.prefix')).prop('disabled', checked);
	changeMailAuth();
}
function changeMailAuth(){
	var forward = $('#'+idIndicator('mail.forward.flag')).prop('checked');
	var checked = $('input:radio[name=mail\\.auth]:input[value=true]').prop("checked");
	if(forward && checked){
		$('#'+idIndicator('mail.smtp.id')).prop('disabled', false);
		$('#'+idIndicator('mail.smtp.password')).prop('disabled', false);
	} else {
		$('#'+idIndicator('mail.smtp.id')).prop('disabled', true);
		$('#'+idIndicator('mail.smtp.password')).prop('disabled', true);
	}
}
var currentTab = '#systemLang';
function getCurrentTab(){
	return currentTab;
}
</script>
</head>
<body class="mini-navbar" id="bodyLoading">

	<div class="col col-md col-sm-2">

		<div class="panel panel-default">
			<div class="panel-body">
				<ul class="nav nav-pills nav-stacked">
					<li class="p"><p class="text-muted">System Settings</p></li>
					<li class="active"><a data-toggle="tab" href="#systemLang" style="padding: 10px 11px;"> <span class="label label-green pull-right"></span> <em class="fa fa-fw fa-lg fa-language"></em><br> <span><s:message code="setup.setting.system"/></span>
					</a></li>
					<li><a data-toggle="tab" href="#account" style="padding: 10px 11px;"> <span class="label label-green pull-right"></span> <em class="fa fa-fw fa-lg fa-users"></em><br> <span><s:message code="setup.setting.account"/></span>
					</a></li>
					<li><a data-toggle="tab" href="#consent" style="padding: 10px 11px;"> <span class="label label-green pull-right"></span> <em class="fa fa-fw fa-lg fa-gavel"></em><br> <span><s:message code="setup.setting.consent"/></span>
					</a></li>
					<li><a data-toggle="tab" href="#mailServer" style="padding: 10px 11px;"> <span class="label label-green pull-right"></span> <em class="fa fa-fw fa-lg fa-envelope"></em><br> <span><s:message code="setup.setting.mailserver"/></span>
					</a></li>
					<li><a data-toggle="tab" href="#smsServer" style="padding: 10px 11px;"> <span class="label label-green pull-right"></span> <em class="fa fa-fw fa-lg fa-wechat"></em><br> <span><s:message code="setup.setting.smsserver"/></span>
					</a></li>
					<li><a data-toggle="tab" href="#searchConf" style="padding: 10px 11px;"> <span class="label label-green pull-right"></span> <em class="fa fa-fw fa-lg fa-search-plus"></em><br> <span><s:message code="setup.setting.search"/></span>
					</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div class="col col-sm-10 tab-content">
		<div id="systemLang" class="tab-pane fade in active">
			<div class="panel-body">
				<fieldset>
					<legend style="height: 40px;">
						<s:message code="setup.setting.system"/>
						<span class="mb-lg" style="float: right;padding-right: 30px;">
							<button data-toggle="collapse" data-target="#topic-reply" accesskey="A" class="btn btn-primary applyBtn"><s:message code="common.msg.apply"/></button>
						</span>
					</legend>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-6 control-label"><s:message code="setup.setting.system.language"/> (default : <span id="default.lang.defaultVal"></span>)</label>
						<div class="col-sm-10">
							<div class="col-sm-5">
								<select id="default.lang" class="form-control m-b">
									<option value="ko">한국어(ko)</option>
									<option value="en">English(en)</option>
								</select>
							</div>
							<div class="col-sm-12">
								<span class="help-block m-b-none"><s:message code="setup.message.system.language"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-6 control-label"><s:message code="setup.message.login.warn"/></label>
						<div class="col-sm-10">
							<div class="col-sm-5">
								<textarea class="form-control m-b" style="width: 450px;height: 100px;" id="system.login.msg"><s:message code="setup.message.login.message"/></textarea>
							</div>
							<div class="col-sm-12">
								<span class="help-block m-b-none"><s:message code="setup.message.login.print"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<div class="checkbox c-checkbox">
							<label class="col-sm-9 control-label" style="font-weight: 700;"><input type="checkbox" id="ui.ipv6"><span class="fa fa-check"></span>IPv6 <s:message code="common.msg.use"/></label>
						</div>
						<div class="col-sm-10">
							<div class="col-sm-10">
								<span class="help-block m-b-none"><s:message code="setup.message.revitalize.ipv6"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<div class="checkbox c-checkbox">
							<label class="col-sm-9 control-label" style="font-weight: 700;"><input type="checkbox" id="ui.dashboard.abbreviation"><span class="fa fa-check"></span><s:message code="setup.message.thousand.format"/></label>
						</div>
						<div class="col-sm-10">
							<div class="col-sm-10">
								<span class="help-block m-b-none"><s:message code="setup.message.abbreviation"/></span>
							</div>
						</div>
					</div>
				</fieldset>
			</div>
		</div>
		<div id="account" class="tab-pane fade">
			<div class="panel-body">
				<fieldset>
					<legend style="height: 40px;">
						<s:message code="setup.setting.account"/>
						<span class="mb-lg" style="float: right;padding-right: 30px;">
							<button data-toggle="collapse" data-target="#topic-reply" accesskey="A" class="btn btn-primary applyBtn"><s:message code="common.msg.apply"/></button>
						</span>
					</legend>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-6 control-label"><s:message code="setup.long.term.unused"/> (default : <span id="long.term.unused.defaultVal"></span>)</label>
						<div class="col-sm-10">
							<div class="col-sm-5">
								<div class="input-group number-spinner">
									<span class="input-group-btn data-dwn">
										<button class="btn btn-default btn-info" data-dir="dwn">
											<span class="glyphicon glyphicon-minus"></span>
										</button>
									</span> <input type="text" id="long.term.unused" class="form-control text-center" value="60" min="5" max="9999" maxlength="4"> <span class="input-group-btn data-up">
										<button class="btn btn-default btn-info" data-dir="up">
											<span class="glyphicon glyphicon-plus"></span>
										</button>
									</span>
								</div>
							</div>
							<div class="col-sm-12">
								<span class="help-block m-b-none"><s:message code="setup.message.longterm.unused"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-6 control-label"><s:message code="setup.password.change.day"/> (default : <span id="password.change.day.defaultVal"></span>)</label>
						<div class="col-sm-10">
							<div class="col-sm-5">
								<div class="input-group number-spinner">
									<span class="input-group-btn data-dwn">
										<button class="btn btn-default btn-info" data-dir="dwn">
											<span class="glyphicon glyphicon-minus"></span>
										</button>
									</span> <input type="text" id="password.change.day" class="form-control text-center" value="30" min="5" max="9999" maxlength="4"> <span class="input-group-btn data-up">
										<button class="btn btn-default btn-info" data-dir="up">
											<span class="glyphicon glyphicon-plus"></span>
										</button>
									</span>
								</div>
							</div>
							<div class="col-sm-12">
								<span class="help-block m-b-none"><s:message code="setup.message.passwordchange.day"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-6 control-label"><s:message code="setup.password.fail.count"/> (default : <span id="password.fail.count.defaultVal"></span>)</label>
						<div class="col-sm-10">
							<div class="col-sm-5">
								<div class="input-group number-spinner">
									<span class="input-group-btn data-dwn">
										<button class="btn btn-default btn-info" data-dir="dwn">
											<span class="glyphicon glyphicon-minus"></span>
										</button>
									</span> <input type="text" id="password.fail.count" class="form-control text-center" value="" min="2" max="99" maxlength="2"> <span class="input-group-btn data-up">
										<button class="btn btn-default btn-info" data-dir="up">
											<span class="glyphicon glyphicon-plus"></span>
										</button>
									</span>
								</div>
							</div>
							<div class="col-sm-12">
								<span class="help-block m-b-none"><s:message code="setup.message.passwordfail.count"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-6 control-label"><s:message code="setup.password.restore.minute"/> (default : <span id="password.restore.minute.defaultVal"></span>)</label>
						<div class="col-sm-10">
							<div class="col-sm-5">
								<div class="input-group number-spinner">
									<span class="input-group-btn data-dwn">
										<button class="btn btn-default btn-info" data-dir="dwn">
											<span class="glyphicon glyphicon-minus"></span>
										</button>
									</span> <input type="text" id="password.restore.minute" class="form-control text-center" value="" min="1" max="99" maxlength="2"> <span class="input-group-btn data-up">
										<button class="btn btn-default btn-info" data-dir="up">
											<span class="glyphicon glyphicon-plus"></span>
										</button>
									</span>
								</div>
							</div>
							<div class="col-sm-12">
								<span class="help-block m-b-none"><s:message code="setup.message.passwordrestore.minute"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-6 control-label"><s:message code="setup.session.timeoutSecond"/> (default : <span id="session.timeoutSecond.defaultVal"></span>)</label>
						<div class="col-sm-10">
							<div class="col-sm-5">
								<div class="input-group number-spinner">
									<span class="input-group-btn data-dwn">
										<button class="btn btn-default btn-info" data-dir="dwn">
											<span class="glyphicon glyphicon-minus"></span>
										</button>
									</span> <input type="text" id="session.timeoutSecond" class="form-control text-center" value="3600" min="600" max="360000" maxlength="6"> <span class="input-group-btn data-up">
										<button class="btn btn-default btn-info" data-dir="up">
											<span class="glyphicon glyphicon-plus"></span>
										</button>
									</span>
								</div>
							</div>
							<div class="col-sm-12">
								<span class="help-block m-b-none"><s:message code="setup.message.sessiontimeout.second"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-6 control-label"><s:message code="setup.duplication.login"/></label>
						<div class="col-sm-12">
							<label class="col-sm-3 radio-inline c-radio"><input type="radio" name="session.duplication.type" value="N"><span class="fa fa-check"></span><s:message code="setup.duplication.login.permit"/></label>
							<label class="col-sm-6 radio-inline c-radio"><input type="radio" name="session.duplication.type" value="A"><span class="fa fa-check"></span><s:message code="setup.duplication.login.new"/></label>
							<!-- <label class="col-sm-3 radio-inline c-radio"><input type="radio" name="session.duplication.type" value="B"><span class="fa fa-check"></span>기존 사용자 우선</label> -->
						</div>
						<div class="col-sm-12">
							<span class="help-block m-b-none">
								<s:message code="setup.message.duplicationlogin.new"/>
								<!-- <br>
								기존 사용자 우선 : 동일 ID로 이미 로그인한 사용자가 로그아웃 전 까지 신규로 접속 불가 -->
							</span>
						</div>
					</div>
				</fieldset>
			</div>
		</div>
		<div id="consent" class="tab-pane fade">
			<div class="panel-body">
				<fieldset>
					<legend style="height: 40px;">
						<s:message code="setup.setting.consent"/>
						<span class="mb-lg" style="float: right;padding-right: 30px;">
							<button data-toggle="collapse" data-target="#topic-reply" accesskey="A" class="btn btn-primary applyBtn"><s:message code="common.msg.apply"/></button>
						</span>
					</legend>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<div class="checkbox c-checkbox">
							<label class="col-sm-9" style="font-weight: 700;"><input type="checkbox" id="consent.menu.enable"><span class="fa fa-check"></span><s:message code="setup.revitalize.consent"/></label>
						</div>
						<div class="col-sm-10">
							<div class="col-sm-10">
								<span class="help-block m-b-none"><s:message code="setup.message.revitalize.consent"/></span>
							</div>
						</div>
					</div>
				</fieldset>
<!-- 				<fieldset>
					<div class="form-group">
						<div class="checkbox c-checkbox">
							<label class="col-sm-9" style="font-weight: 700;"><input type="checkbox" id="consent.history.enable"><span class="fa fa-check"></span>동의서 조회 이력 활성화</label>
						</div>
					</div>
					<div class="col-sm-12">
						<span class="help-block m-b-none">
							신규 사용자 우선 : 동일 ID로 로그인한 사용자를 로그아웃 시키고 최종 사용자를 로그인 함
						</span>
					</div>
				</fieldset> -->
			</div>
		</div>
		<div id="mailServer" class="tab-pane fade">
			<div class="panel-body">
				<fieldset>
					<legend style="height: 40px;">
						<s:message code="setup.setting.mailserver.setting"/>
						<span class="mb-lg" style="float: right;padding-right: 30px;">
							<button data-toggle="collapse" data-target="#topic-reply" accesskey="A" class="btn btn-primary applyBtn"><s:message code="common.msg.apply"/></button>
						</span>
					</legend>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<div class="checkbox c-checkbox">
							<label class="col-sm-3" style="font-weight: 700;"><input type="checkbox" id="mail.forward.flag"><span class="fa fa-check"></span><s:message code="setup.revitalize.mailserver"/></label>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-3 control-label"><s:message code="setup.mail.smtp.host"/></label>
						<div class="col-sm-10">
							<div class="col-sm-7">
								<div class="input-group m-b ">
									<span class="input-group-addon">@</span> <input type="text" id="mail.smtp.host" placeholder="SMTP Domain" class="form-control">
								</div>
							</div>
							<div class="col-sm-3">
								<input type="text" id="mail.smtp.port" placeholder="Port" class="form-control" min="0" max="65535">
							</div>
							<span style="clear: both;padding-left: 15px;padding-top: 5px" class="help-block m-b-none"><s:message code="setup.message.mail"/></span>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-3 control-label"><s:message code="setup.system.mail.addr"/></label>
						<div class="col-sm-10">
							<div class="col-sm-7">
								<div class="input-group m-b ">
									<span class="input-group-addon">@</span> <input type="text" id="system.mail.addr" placeholder="From Mail Address" class="form-control">
								</div>
							</div>
							<div class="col-sm-12">
								<span class="help-block m-b-none"><s:message code="setup.message.mail.account"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<div class="checkbox c-checkbox">
							<label class="col-sm-12" style="font-weight: 700;"><input type="checkbox" id="mail.ssl"><span class="fa fa-check"></span><s:message code="setup.use.ssl"/></label>
						</div>
						<div class="col-sm-12">
							<div class="col-sm-12">
								<span class="help-block m-b-none"><s:message code="setup.message.use.ssl"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="control-label"><s:message code="setup.certification.setting"/></label>
						<div class="col-sm-12" style="padding-right: 0px;">
							<fieldset>
								<div class="form-group" style="padding-left: 0px;padding-right: 0px;border-bottom: 0px;">
									<label class="col-sm-12 radio-inline c-radio" style="margin-right:0;"><input type="radio" name="mail.auth" value="true"><span class="fa fa-check"></span><s:message code="setup.mail.smtp.account"/></label>
									<div class="col-sm-12" style="padding-left: 0px;padding-right: 0px;">
										<div class="col-sm-6">
											<s:message code="common.msg.id"/>
											<input type="text" id="mail.smtp.id" placeholder="ID" class="form-control">
										</div>
										<div class="col-sm-6">
											<s:message code="admin.pw"/>
											<input type="password" id="mail.smtp.password" placeholder="Password" class="form-control" autocomplete="off">
										</div>
									</div>
								</div>
								<div class="form-group" style="border-bottom: 0px;padding-top: 15px;padding-bottom: 15px;">
									<label class="col-sm-3 radio-inline c-radio"><input type="radio" name="mail.auth" value="false" checked="checked"><span class="fa fa-check"></span><s:message code="setup.certification.none"/></label>
									<div class="col-sm-9">
									</div>
								</div>
							</fieldset>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-3 control-label"><s:message code="setup.prefix.subject"/></label>
						<div class="col-sm-10">
							<div class="col-sm-10">
								<input type="text" id="mail.subject.prefix" placeholder="" class="form-control">
							</div>
							<div class="col-sm-12">
								<span class="help-block m-b-none"><s:message code="setup.message.prefix.subject"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<div class="checkbox c-checkbox">
							<label class="col-sm-10" style="font-weight: 700;"><input type="checkbox" id="mail.audit.used"><span class="fa fa-check"></span><s:message code="mail.audit.used"/></label>
						</div>
						<div class="col-sm-12">
							<div class="col-sm-9">
								<input type="text" id="mail.audit.receiver" placeholder="" class="form-control">
							</div>
						</div>
						<div class="col-sm-12">
							<div class="col-sm-9">
								<span class="help-block m-b-none"><s:message code="mail.audit.receiver"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<div class="checkbox c-checkbox">
							<label class="col-sm-4" style="font-weight: 700;"><input type="checkbox" id="mail.debug"><span class="fa fa-check"></span><s:message code="setup.debug.mailsend"/></label>
						</div>
						<div class="col-sm-12">
							<div class="col-sm-9">
								<span class="help-block m-b-none"><s:message code="setup.message.debug.mailsend"/></span>
							</div>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-4" style="font-weight: 700;"><s:message code="setup.mail.test"/></label>
						<div class="col-sm-12">
							<div class="col-sm-9">
								<input type="text" class="form-control" name="testMailId" id="testMailId" placeholder="<s:message code="mail.recv"/>" style="width: 250px;" maxlength="50">
							</div>
							<div class="col-sm-3" style="text-align: right;">
								<button accesskey="S" class="btn btn-success" id="mailSendBtn"><s:message code="setup.send.test"/></button>
							</div>
							
						</div>
						<div class="col-sm-12">
							<div class="col-sm-9">
								<span class="help-block m-b-none"><s:message code="setup.message.mail.test"/></span>
							</div>
						</div>
					</div>
				</fieldset>
			</div>
		</div>
		<div id="smsServer" class="tab-pane fade">
			<div class="panel-body">
				<fieldset>
					<legend style="height: 40px;">
						<s:message code="setup.sms.server"/>
						<span class="mb-lg" style="float: right;padding-right: 30px;">
							<button data-toggle="collapse" data-target="#topic-reply" accesskey="A" class="btn btn-primary applyBtn"><s:message code="common.msg.apply"/></button>
						</span>
					</legend>
				</fieldset>
				<span class="help-block m-b-none"><s:message code="setup.message.sms.server"/></span>
				<fieldset>
					<div class="form-group">
						<div class="checkbox c-checkbox">
							<label class="col-sm-4" style="font-weight: 700;"><input type="checkbox" id="sms.enable"><span class="fa fa-check"></span><s:message code="setup.revitalize.sms"/></label>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-6 control-label"><s:message code="setup.sms.server.url"/></label>
						<div class="col-sm-10">
							<input type="text" id="sms.server.url" placeholder="SMS Server Address" class="form-control">
							<span class="help-block m-b-none"><s:message code="setup.message.sms.server.url"/></span>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-6 control-label"><s:message code="setup.sms.token"/></label>
						<div class="col-sm-10">
							<input type="text" id="sms.token" placeholder="SMS Certification Key" class="form-control">
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-6 control-label"><s:message code="setup.sms.test"/></label>
						<div class="col-sm-12">
							<div class="col-sm-9 form-inline" style="padding-left:0;">
								<input type="text" class="form-control" name="testPhoneNo" id="testPhoneNo" placeholder="<s:message code="admin.hp"/>" style="width: 250px;" maxlength="50"> <s:message code="admin.enter.minus"/> <span style="padding-left:15px;"><s:message code="admin.msg.hp"/></span>
							</div>
							<div class="col-sm-3" style="text-align: right;">
								<button accesskey="S" class="btn btn-success" id="smsSendBtn"><s:message code="setup.send.test"/></button>
							</div>
							
						</div>
						<div class="col-sm-12">
							<div class="col-sm-9">
								<span class="help-block m-b-none"><s:message code="setup.message.sms.test"/></span>
							</div>
						</div>
					</div>
				</fieldset>
			</div>
		</div>
		<div id="searchConf" class="tab-pane fade">
			<div class="panel-body">
				<fieldset>
					<legend style="height: 40px;">
						<s:message code="setup.setting.search"/>
						<span class="mb-lg" style="float: right;padding-right: 30px;">
							<button data-toggle="collapse" data-target="#topic-reply" accesskey="A" class="btn btn-primary applyBtn"><s:message code="common.msg.apply"/></button>
						</span>
					</legend>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<div class="col-sm-12">
							<label class="control-label" style="padding-left:0;"><s:message code="setup.title.search"/></label>
							<div class="form-group" style="border-bottom: 0px;padding-top: 15px;">
								<s:message code="setup.message.search.comment"/><br/>
								&nbsp;&nbsp;※1) <s:message code="setup.message.search.search1"/><br/>
								&nbsp;&nbsp;※2) <s:message code="setup.message.search.search2"/><br/>
								&nbsp;&nbsp;※3) <s:message code="setup.message.search.search3"/><br/>
							</div>
						</div>
						<div class="col-sm-12" style="padding-right: 0px;">
							<fieldset>
								<div class="form-group" style="padding-left: 0px;padding-right: 0px;border-bottom: 0px;height:25px;">
									<label class="col-sm-9 radio-inline c-radio"><input type="radio" name="query.type" value="A" checked>
										<span class="fa fa-check"></span>
										1. <s:message code="setup.message.search.userinfo"/> + <s:message code="setup.message.search.ipinfo"/>
									</label>
									<div class="col-sm-3" style="padding-left: 0px;padding-right: 0px;">
										
									</div>
								</div>
								<div class="form-group" style="border-bottom: 0px;padding-top: 15px;height:25px;">
									<label class="col-sm-9 radio-inline c-radio"><input type="radio" name="query.type" value="B">
										<span class="fa fa-check"></span>
										2. <s:message code="setup.message.search.userinfo"/>
									</label>
									<div class="col-sm-3">
									</div>
								</div>
								<div class="form-group" style="border-bottom: 0px;padding-top: 15px;height:25px;">
									<label class="col-sm-9 radio-inline c-radio"><input type="radio" name="query.type" value="C" >
										<span class="fa fa-check"></span>
										3. <s:message code="setup.message.search.ipinfo"/>
									</label>
									<div class="col-sm-3">
									</div>
								</div>
							</fieldset>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<div class="form-group">
						<label class="col-sm-9 control-label"><s:message code="message.msg.inout"/> <s:message code="condition.allofus"/></label>
						<div class="col-sm-12">
							<div class="col-sm-12">
								<input type="text" id="ui.inout.delimiter" class="form-control text-left">
								<span class="help-block m-b-none">
									<s:message code="condition.allofus.comment1"/><br/>( <s:message code="condition.allofus.comment2"/> )
								</span>
							</div>
						</div>
					</div>
				</fieldset>
			</div>
		</div>
	</div>
</body>
</html>