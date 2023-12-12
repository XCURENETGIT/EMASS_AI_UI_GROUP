<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/popupScript.jsp" %>
<head>
<title>EMASS LTH - <s:message code="common.msg.setting"/></title>
	<link rel="stylesheet" href="<c:url value="/css/emass_style.css"/>" />
	<link rel="stylesheet" href="<c:url value="/css/reset.css"/>" />

	<meta http-equiv="X-UA-Compatible" content="IE=edge">

	<style type="text/css">
		.vertical_content{
			visibility: hidden;
		}

		.vertical_content.active{
			visibility: visible;
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

function toggleTab(tabId) {
    var tabButtons = document.getElementsByClassName('tablinks');
    for (var i = 0; i < tabButtons.length; i++) {
        tabButtons[i].classList.remove('active');
    }

    var contentDivs = document.getElementsByClassName('vertical_content');
    for (var i = 0; i < contentDivs.length; i++) {
        contentDivs[i].style.display = 'none';
    }

    document.getElementById(tabId).classList.add('active');

    var clickedButton = document.querySelector('[onclick="toggleTab(\'' + tabId + '\')"]');
    clickedButton.classList.add('active');

    document.getElementById(tabId).style.display = 'block';
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

<div class="contentSub">
	<div class="mab12 txt_left borbottom_dd ">
		<h3 class="mab12">System Settings</h3>
	</div>
	<!-- Menu -->
	<div class="verticaltab">
		<button class="active tablinks" onclick="toggleTab('systemLang')"><span><s:message code="setup.setting.system"/></span></button>
		<button class="tablinks" onclick="toggleTab('account')"><span><s:message code="setup.setting.account"/></span></button>
		<button class="tablinks" onclick="toggleTab('consent')"><span><s:message code="setup.setting.consent"/></span></button>
		<button class="tablinks" onclick="toggleTab('mailServer')"><span><s:message code="setup.setting.mailserver"/></span></button>
		<button class="tablinks" onclick="toggleTab('smsServer')"><span><s:message code="setup.setting.smsserver"/></span></button>
		<button class="tablinks" onclick="toggleTab('searchConf')"><span><s:message code="setup.setting.search"/></span></button>
	<%--	<button   class="tablinks" ><a data-toggle="tab" href="#mailServer"> <span><s:message code="setup.setting.mailserver"/></span>
		</a></button >
		<button  class="tablinks" ><a data-toggle="tab" href="#smsServer"> <span><s:message code="setup.setting.smsserver"/></span>
		</a></button >
		<button  class="tablinks" ><a data-toggle="tab" href="#searchConf"> <span><s:message code="setup.setting.search"/></span>
		</a></button >--%>
	</div>
	<!-- //Menu -->
	<div id="systemLang" class="vertical_content active">
		<div>
			<h2><s:message code="setup.setting.system"/></h2>
			<span class="rightbtn"><button class="pop_btn02 applyBtn" accesskey="A" data-target="#topic-reply" >&#10004;<s:message code="common.msg.apply"/></button></span>
		</div>
		<div class="row bordd p12 clear mat8">
			<ul>
				<li>
					<span class="bullet02"></span><label for="fname" class="fb600"><s:message code="setup.setting.system.language"/> (default : <span id="default.lang.defaultVal"></span>)</label>
					<p class="mat8">
						<select class="w50" id="default.lang">
							<option value="ko">한국어(ko)</option>
							<option value="en">English(en)</option>
						</select>
					</p>
					<p class="info mat4"><s:message code="setup.message.system.language"/></p>
				</li>

				<li>
					<span class="bullet02"></span><label for="fname" class="fb600"><s:message code="setup.message.login.warn"/></label>
					<p class="mat8">
                            <textarea id="system.login.msg" rows="5" class="w100"><s:message code="setup.message.login.message"/></textarea>
					</p>
					<p class="info"><s:message code="setup.message.login.print"/></p>
				</li>

				<li>
					<div class="checkbox">
						<input type="checkbox" class="mar8" id="ui.ipv6">
						<span for="fname" class="fb600 checktit">IPv6 <s:message code="common.msg.use"/></span>
					</div>
					<p class="indenttxt">
						<s:message code="setup.message.revitalize.ipv6"/>
					</p>
				</li>
				<li>
					<div class="checkbox">
						<input type="checkbox" class="mar8" id="ui.dashboard.abbreviation">
						<span for="fname" class="fb600 checktit"><s:message code="setup.message.thousand.format"/></span>
					</div>
					<p class="indenttxt">
						<s:message code="setup.message.abbreviation"/>
					</p>
				</li>
			</ul>
		</div>
	</div>

	<div id="account" class="vertical_content ">
		<div>
			<h2><s:message code="setup.setting.account"/></h2>
			<span class="rightbtn"><button class="pop_btn02 applyBtn"  data-toggle="collapse" data-target="#topic-reply" accesskey="A">&#10004;<s:message code="common.msg.apply"/></button></span>
		</div>
		<div class="row bordd p12 clear mat8 ">
			<ul>
				<li>
					<span class="bullet02"></span><label for="fname" class="fb600"><s:message code="setup.long.term.unused"/> (default : <span id="long.term.unused.defaultVal"></span></label>
					<div class="spinner mat8 ">
						<button type="button" class="spinner_down">-</button>
						<input type="number" class="spinner_input w40" value="20">
						<button type="button" class="spinner_up">+</button>
					</div>
					<p class="info mat4"><s:message code="setup.message.longterm.unused"/></p>
				</li>
				<li>
					<span class="bullet02"></span><label for="fname" class="fb600">비밀번호 변경일 (default : 30)</label>
					<div class="spinner mat8">
						<button type="button" class="spinner_up">+</button>
						<input type="number" class="spinner_input w40" value="10">
						<button type="button" class="spinner_down">-</button>
					</div>
					<p class="info mat4">비밀번호 변경 후 일정기간이 지나면 비밀번호 변경후 접속 되도록 설정 (단위 일)</p>
				</li>
				<li>
					<span class="bullet02"></span><label for="fname" class="fb600">비밀번호 오류 횟수 (default : 5)</label>
					<div class="spinner mat8">
						<button type="button" class="spinner_up">+</button>
						<input type="number" class="spinner_input w40" value="20">
						<button type="button" class="spinner_down">-</button>
					</div>
					<p class="info mat4">비밀번호 변경 후 일정기간이 지나면 비밀번호 변경후 접속 되도록 설정 (단위 일)</p>
				</li>
				<li>
					<span class="bullet02"></span><label for="fname" class="fb600">계정 잠금 시간 (default : 5)</label>
					<div class="spinner mat8">
						<button type="button" class="spinner_up">+</button>
						<input type="number" class="spinner_input w40" value="5">
						<button type="button" class="spinner_down">-</button>
					</div>
					<p class="info mat4">비밀번호 입력 오류 횟수 초과로 잠금 되었을때 해제되는 시간 (단위 분)</p>
				</li>
				<li>
					<span class="bullet02"></span><label for="fname" class="fb600">자동 로그아웃 시간 (default : 600)</label>
					<div class="spinner mat8">
						<button type="button" class="spinner_up">+</button>
						<input type="number" class="spinner_input w40" value="600">
						<button type="button" class="spinner_down">-</button>
					</div>
					<p class="info mat4">로그인 후 시스템 미 사용시 자동 로그아웃 시간 (단위 초)</p>
				</li>
				<li>
					<span class="bullet02"></span><label for="fname" class="fb600">중복 로그인 설정</label>
					<p>
					<div class="optiotab w50 mat8">
						<button class="tablinks w50">중복 로그인 허용</button>
						<button class="active w50">	&#10004; 신규 사용자 우선</button>
					</div>
					</p>
					<p class="info mat4">신규 사용자 우선 : 동일 ID로 로그인한 사용자를 로그아웃 시키고 최종 사용자를 로그인 함.</p>
				</li>
			</ul>
		</div>
	</div>

	<div id="consent" class="vertical_content">
		<div>
			<h2><s:message code="setup.setting.consent"/></h2>
			<span class="rightbtn"><button class="pop_btn02 applyBtn" data-toggle="collapse" data-target="#topic-reply" accesskey="A">&#10004;<s:message code="common.msg.apply"/></button></span>
		</div>
		<div class="row bordd p12 clear mat8">
			<ul>
				<li>
					<div class="checkbox mat8">
						<input type="checkbox" class="mar8" id="consent.menu.enable">
						<span for="fname" class="fb600 checktit"><s:message code="setup.revitalize.consent"/></span>
					</div>
					<p class="indenttxt">
						<s:message code="setup.message.revitalize.consent"/>
					</p>
				</li>
			</ul>
		</div>
	</div>

	<div id="mailServer" class="vertical_content">
		<div>
			<h2><s:message code="setup.setting.mailserver.setting"/></h2>
			<span class="rightbtn"><button class="pop_btn02 applyBtn" data-toggle="collapse" data-target="#topic-reply" accesskey="A">&#10004;<s:message code="common.msg.apply"/></button></span>
		</div>
		<div class="row bordd p12 clear mat8">
			<ul>
				<li>
					<div class="checkbox mat8">
						<input type="checkbox" class="mar8" id="mail.forward.flag">
						<span for="fname" class="fb600 checktit"><s:message code="setup.revitalize.mailserver"/></span>
					</div>
				</li>
				<li class="pl20 grayBg02 ">
					<label for="fname"><s:message code="setup.mail.smtp.host"/></label>
					<p class="mat3">
						<input class="w50" type="text" id="mail.smtp.host" placeholder="SMTP Domain">
						<input class="w20" type="text" id="mail.smtp.port" placeholder="Port" min="0" max="65535">
					</p>
					<p class="info"><s:message code="setup.message.mail"/></p>
				</li>
				<li class="pl20 grayBg02">
					<label for="fname"><s:message code="setup.system.mail.addr"/></label>
					<p  class="mat4">
						<input class="w50" type="text" id="system.mail.addr" placeholder="From Mail Address">
					</p>
					<p class="info"><s:message code="setup.message.mail.account"/></p>
				</li>
				<li class="pl20 grayBg02">
					<div class="checkbox mat8">
						<input type="checkbox" class="mar8"  id="mail.ssl">
						<span for="fname" class="fb400 checktit"><s:message code="setup.use.ssl"/></span>
					</div>
					<p class="info"><s:message code="setup.message.use.ssl"/></p>
				</li>
				<li class="pr20 pl20  pl20 grayBg02">
					<span class="bullet02"></span><label for="fname" class="fb600"><s:message code="setup.certification.setting"/></label>
					<p>
					<div class="optiotab w99 mat8">
						<button class="active tablinks w50">&#10004; <s:message code="setup.mail.smtp.account"/></button>
						<button class="tablinks w50"><s:message code="setup.certification.none"/></button>
					</div>
					</p>
					<div class="hidden mat8">
						<div class="col-50">
							<label for="fname"><s:message code="common.msg.id"/></label>
							<p>
								<input class="w100" type="text"  id="mail.smtp.id" placeholder="ID">
							</p>
						</div>
						<div class="col-50 mal16">
							<label for="fname"><s:message code="admin.pw"/></label>
							<p>
								<input class="w100" type="password"  id="mail.smtp.password" placeholder="Password" autocomplete="off">
							</p>
						</div>
					</div>
				</li>
				<li class="pr20 pl20  grayBg02">
					<span class="bullet02"></span><label for="fname" class="fb600"><s:message code="setup.prefix.subject"/></label>
					<p  class="mat4">
						<input class="w99" type="text" id="mail.subject.prefix" placeholder="">
					</p>
					<p class="info"><s:message code="setup.message.prefix.subject"/></p>
				</li>
				<li class="pr20 pl20  grayBg02">
					<div class="checkbox mat8">
						<input type="checkbox" class="mar8"  id="mail.audit.used">
						<span for="fname" class="fb600 checktit"><s:message code="mail.audit.used"/></span>
					</div>
					<p  class="mat4">
						<input class="w99 dis" type="text" id="mail.audit.receiver" placeholder=""
					</p>
					<p class="info"><s:message code="mail.audit.receiver"/></p>
				</li>
				<li class="pr20 pl20  grayBg02">
					<div class="checkbox mat8">
						<input type="checkbox" class="mar8" id="mail.debug">
						<span for="fname" class="fb600 checktit"><s:message code="setup.debug.mailsend"/></span>
					</div>
					<p class="info"><s:message code="setup.message.debug.mailsend"/></p>
				</li>
				<li class="pr20 pl20  grayBg02">
					<div class="checkbox mat8">
						<input type="checkbox" class="mar8">
						<span for="fname" class="fb600 checktit"><s:message code="setup.mail.test"/></span>
					</div>
					<p  class="mat4">
						<input class="w60" type="text" name="testMailId" id="testMailId" placeholder="<s:message code="mail.recv"/>"  maxlength="50">
						<button class="num_add btnform" accesskey="S" id="mailSendBtn"><s:message code="setup.send.test"/></button>
					</p>
					<p class="info"><s:message code="setup.message.mail.test"/></p>
				</li>
			</ul>
		</div>
	</div>

	<div id="smsServer" class="vertical_content">
		<div>
			<h2><s:message code="setup.sms.server"/></h2>
			<span class="rightbtn"><button class="pop_btn02 applyBtn" data-toggle="collapse" data-target="#topic-reply" accesskey="A"> &#10004;<s:message code="common.msg.apply"/></button></span>
		</div>
		<div class="row bordd p12 clear mat8">
			<span class="infotxt"><s:message code="setup.message.sms.server"/></span>
			<ul>
				<li>
					<div class="checkbox mat16">
						<input type="checkbox" class="mar8" id="sms.enable">
						<span for="fname" class="fb600 checktit"><s:message code="setup.revitalize.sms"/></span>
					</div>
				</li>
				<li class="pr20 pl20  grayBg02 ">
					<label for="fname"><s:message code="setup.sms.server.url"/></label>
					<p class="mat3">
						<input class="w100" type="text" id="sms.server.url" placeholder="SMS Server Address" >
					</p>
					<p class="info"><s:message code="setup.message.sms.server.url"/></p>
				</li>
				<li class="pl20 grayBg02">
					<label for="fname"><s:message code="setup.sms.token"/></label>
					<p  class="mat4">
						<input class="w50" type="text" id="sms.token" placeholder="SMS Certification Key">
					</p>
					<p class="info">보내는 사람 메일 주소를 입력하세요.(ex:user01@xcurenet.com)</p>
				</li>
				<li class="pr20 pl20  grayBg02">
					<span class="bullet02"></span><label for="fname" class="fb600"><s:message code="setup.sms.test"/></label>
					<p  class="mat4">
						<input class="w60" type="text"  name="testPhoneNo" id="testPhoneNo" placeholder="<s:message code="admin.hp"/>" maxlength="50">
						<button class="num_add btnform" accesskey="S" id="smsSendBtn"><s:message code="setup.send.test"/></button>
					</p>
					<p class="info">("-"를 빼고 입력)</p>
					<p class="indenttxt mat4">
						<s:message code="setup.message.sms.test"/>
					</p>
				</li>
			</ul>
		</div>
	</div>

	<div id="searchConf" class="vertical_content">
		<div>
			<h2><s:message code="setup.setting.search"/></h2>
			<span class="rightbtn"><button class="pop_btn02 applyBtn" data-toggle="collapse" data-target="#topic-reply" accesskey="A">&#10004;<s:message code="common.msg.apply"/></button></span>
		</div>
		<div class="row bordd p12 clear mat8">
			<ul>
				<li>
					<span class="bullet02"></span><label for="fname" class="fb600"><s:message code="setup.title.search"/></label>
					<p class="indenttxt mat4">
						<span class="mab12 dis_block"><s:message code="setup.message.search.comment"/><br/>
								&nbsp;&nbsp;※1) <s:message code="setup.message.search.search1"/><br/>
								&nbsp;&nbsp;※2) <s:message code="setup.message.search.search2"/><br/>
								&nbsp;&nbsp;※3) <s:message code="setup.message.search.search3"/><br/>
					</p>
				</li>
				<li class="pr20 pl20  grayBg02 ">
					<div class="radio mat4 w100">
						<div class="radio w100 mat4">
							<input type="radio"  name="query.type" value="A" checked>
							<span >	1. <s:message code="setup.message.search.userinfo"/> + <s:message code="setup.message.search.ipinfo"/></span>
						</div>
						<div class="radio w100 mat4">
							<input type="radio" name="query.type" value="B">
							<span > 2. <s:message code="setup.message.search.userinfo"/></span>
						</div>
						<div class="radio w100 mat4">
							<input type="radio" name="query.type" value="C">
							<span > 3. <s:message code="setup.message.search.ipinfo"/></span>
						</div>
					</div>
				</li>
				<li>
					<span class="bullet02"></span><label for="fname" class="fb600"><s:message code="message.msg.inout"/> <s:message code="condition.allofus"/></label>
					<p class="mat4">
						<input class="w100" type="text" id="ui.inout.delimiter" >
					</p>
					<p class="info"><s:message code="condition.allofus.comment1"/><br/>( <s:message code="condition.allofus.comment2"/> )</p>
				</li>
			</ul>
		</div>
	</div>
</div>



</div>
</body>
</html>