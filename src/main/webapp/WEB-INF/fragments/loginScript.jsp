<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.web.servlet.i18n.SessionLocaleResolver" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.config.Config"%>
<%@ page import="java.util.Locale" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
String contentPath = request.getContextPath();
boolean isIPv6 = Config.isIPv6;
boolean isOCR = Config.isOCR;
boolean consent = Config.getBoolean("consent.menu.enable");
String adminLanguage = Common.nvl(Locale.getDefault(), "ko");
if(!request.getRequestURI().contains("login.jsp")) adminLanguage = Common.nvl(session.getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME), "ko");
%>
<link rel="stylesheet" href="<c:url value="/css/bootstrap-dialog.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/sb-admin-2.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/panelsTab.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/emass_style.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/reset.css"/>" />
<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.ui.js"/>"></script>
<% if( Common.isEquals(Common.nvl(Locale.getDefault(), "ko"), "ko")){%>
<script type="text/javascript" src="<c:url value="/js/xcnui_ko.js"/>"></script>
<%}else{%>
<script type="text/javascript" src="<c:url value="/js/xcnui_en.js"/>"></script>
<%}%>

<script type="text/javascript" src="<c:url value="/js/sb-admin-2.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/xcnui_2.0.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sha256.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jsbn.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/rsa.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/prng4.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/rng.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-dialog.js"/>"></script>

<script>
var contextRoot = '<%=contentPath%>';
var consent = '<%=consent%>';
var isIPv6 = '<%=isIPv6%>';
var isOCR = '<%=isOCR%>';

var pwchgDt = '${_USERCREDENTIAL_.pwchgDt}';
var adminLang = '<%=adminLanguage%>';
var enter = "┌";
var stompClient;
var adminType = '${_USERCREDENTIAL_.adminType}';
var currentPw = '${_USERCREDENTIAL_.adminPw}';
var adminId = '${_USERCREDENTIAL_.adminId}';
var firstAdminYn = '${_USERCREDENTIAL_.firstAdminYn}';
var adminMenu = '${_USERCREDENTIAL_.menu}';
var loginType = '${_USERCREDENTIAL_.loginType}';
var leftSize = 225;
var menuId = "";
var pMenuId = "";

$(window).keydown(function (event) {
  if (event.keyCode === 32 || event.keyCode === 13) {
    if ($('#bootstrap_alert:visible').length > 0) {
      $('#bootstrap_alert:visible').find('button').click();
    }
  }
});

$(document).ready(function() {



    $('#TheFirstSaveBtn').click(function(){
        $('#TheFirstSaveBtn').prop('disabled', true);
        var first_adminId = $('#first_adminId').val().trim();
        var first_adminPw = $('#first_adminPw').val().trim();
        var first_c_adminPw = $('#first_c_adminPw').val().trim();
        var first_cur_adminPw = $('#first_cur_adminPw').val().trim();
        var first_accessIp = $('#first_accessIp').val().trim();
        if(first_adminId == '') {
            ui.alertMsg('<s:message code="admin.msg.enter.id"/>');
            $('#first_adminId').focus( );
            $('#TheFirstSaveBtn').prop('disabled', false);
            return;
        }
        if( !idCheck(first_adminId ) ) {
            ui.alertMsg('<s:message code="admin.msg.use.englishid"/>');
            $('#first_adminId').focus( );
            $('#TheFirstSaveBtn').prop('disabled', false);
            return;
        }
        if(first_adminPw == '') {
            ui.alertMsg('<s:message code="admin.msg.enter.pw"/>');
            $('#first_adminPw').focus( );
            $('#TheFirstSaveBtn').prop('disabled', false);
            return;
        }
        if(first_c_adminPw == '') {
            ui.alertMsg('<s:message code="admin.msg.enter.cpw"/>');
            $('#first_c_adminPw').focus( );
            $('#TheFirstSaveBtn').prop('disabled', false);
            return;
        }
        if ( !validationPassword( $('#first_adminId').val(), $('#first_adminPw').val(), "" ) ){
            $('#first_adminPw').focus( );
            $('#TheFirstSaveBtn').prop('disabled', false);
            return;
        }
        if ( !validationPassword( $('#first_c_adminId').val(), $('#first_c_adminPw').val(), "" ) ){
            $('#first_c_adminPw').focus( );
            $('#TheFirstSaveBtn').prop('disabled', false);
            return;
        }

        if(first_adminPw != first_c_adminPw) {
            ui.alertMsg('<s:message code="admin.msg.diff.pw"/>');
            $('#first_adminPw').focus( );
            $('#TheFirstSaveBtn').prop('disabled', false);
            return;
        }
        if(first_cur_adminPw == sha256_digest(first_adminPw)) {
            ui.alertMsg('<s:message code="base.same.pw"/>');
            $('#first_adminPw').focus( );
            $('#TheFirstSaveBtn').prop('disabled', false);
            return;
        }
        ui.confirmMsg('<s:message code="base.change.pw"/>', '', '', function(rs){
            if(rs){
                ui.get({
                    url 	:'updateAdminInfo.xcn',
                    adminId :first_adminId,
                    adminPw :sha256_digest(first_adminPw),
                    accessIp :first_accessIp,
                    /* mysqlUser	:first_deviceId,
					mysqlPw		:first_devicePw, */
                    success : function ( data, total ) {
                        closeAllPopup();
                        $('#TheFirstSaveBtn').prop('disabled', false);
                        ui.confirmMsg('<s:message code="base.saved.pw"/>', '', '', function(rs){
                            if(rs){
                                document.location.href = '<c:url value="/logout.do"/>';
                            }
                        });
                    },
                    error : function (status, message) {
                        ui.alertMsg(message);
                    },
                    complete : function (){
                        //restartTomcat();
                        $('#TheFirstSaveBtn').prop('disabled', false);
                    }
                });
            }else{
                $('#TheFirstSaveBtn').prop('disabled', false);
            }

        });
    });

    $('#changePasswordBtn').click(function(){
        $('#current_password').val('');
        $('#change_password').val('');
        $('#current_confirm_password').val('');

        $("#changePasswordPop").modal('show');
    });

    $('#changeLanguageBtn').click(function(){
        $('#adminLang').val(adminLang);
        $("#changeLanguagePop").modal('show');
    });

    $('#changePasswordSaveBtn').click(function(){
        var current_password = $('#current_password').val().trim();
        var change_password = $('#change_password').val().trim();
        var current_confirm_password = $('#current_confirm_password').val().trim();

        if(current_password == '') {
            ui.alertMsg('<s:message code="base.enter.current.pw"/>');
            return;
        }
        if(change_password == '') {
            ui.alertMsg('<s:message code="base.enter.change.pw"/>');
            return;
        }
        if(current_confirm_password == '') {
            ui.alertMsg('<s:message code="base.enter.changeconfirm.pw"/>');
            return;
        }

        if(change_password != current_confirm_password) {
            ui.alertMsg('<s:message code="base.different.pw"/>');
            return;
        }
        if(sha256_digest(current_password) != currentPw) {
            ui.alertMsg('<s:message code="base.wrong.pw"/>');
            return;
        }

        if(sha256_digest(current_password) == sha256_digest(change_password)) {
            ui.alertMsg('<s:message code="base.same.pw"/>');
            return;
        }

        if(!validationPassword('${_USERCREDENTIAL_.adminId}', change_password)) return;
        ui.confirmMsg('<s:message code="base.change.pw"/>', '', '', function(rs){
            if(rs){
                ui.get({
                    url : 'updateAdminPassword.xcn',
                    adminId : adminId,
                    adminPw : sha256_digest(change_password),
                    success : function ( data, total ) {
                        ui.alertMsg('<s:message code="base.saved.pw"/>', function(){
                            closeAllPopup();
                            document.location.href = '<c:url value="/logout.do"/>';
                        });
                    },
                    error : function (status, message) {
                        ui.alertMsg(message);
                    },
                    complete : function (){
                    }
                });
            }
        });
    });

});

function validationPassword( uid, upw, bpw )
{
    var com_msg = passwordJS.pwMix + '\n';

    password = upw.toLowerCase();
    var num_length = [9, 12]; 	// 패스워드 길이
    var totalStressCnt = 3; 	// 패스워드 조합 강도
    var sameChar = 3; 			// 패스워드 연속된 동일 문자

    var lower = 'abcdefghijklmnopqrstuvwxyz';
    var sChar = "!@#$%^&*()[]\|<>?,./";
    var number = '1234567890';
    if( sha256_digest( upw ) == bpw )
    {
        alert( passwordJS.noPast );
        return false;
    }

    if ( uid == upw )
    {
        alert( passwordJS.notAccount );
        return false;
    }

    if ( password.length < num_length[0] ){
        alert( com_msg + passwordJS.notUp );
        return false;
    }

    if ( password.length > num_length[1] ){
        alert( com_msg + passwordJS.notDown );
        return false;
    }

    var discordanceChar = false;
    for ( var i=0 ; i < password.length ; i++ )
    {
        var lo = lower.indexOf( password.charAt(i) );
        var sc = sChar.indexOf( password.charAt(i) );
        var nu = number.indexOf( password.charAt(i) );
        if ( lo < 0 && sc < 0 && nu < 0 ) discordanceChar = true;
    }
    ///if ( discordanceChar ) {
    //	alert( com_msg + '지원되지 않는 문자가 포함 되어 있습니다.\n지원되는 문자는 아래와 같습니다.\n1.영소(a-z)\n2.영대(A-Z)\n3.숫자(0-9)\n4.특수문자(!@#$%^&*()[]\|<>?,./)' );
    //	return false;
    //}

    var lowerFlag = false;
    var sCharFlag = false;
    var numberFlag = false;
    for ( var i=0 ; i < password.length ; i++ )
    {
        if ( lower.indexOf( password.charAt(i) ) > -1 ) lowerFlag = true;
        if ( sChar.indexOf( password.charAt(i) ) > -1 ) sCharFlag = true;
        if ( number.indexOf( password.charAt(i) ) > -1 ) numberFlag = true;
    }
    var totalSequenceCnt = 0;
    if ( lowerFlag ) totalSequenceCnt++;
    if ( sCharFlag ) totalSequenceCnt++;
    if ( numberFlag ) totalSequenceCnt++;
    if ( totalSequenceCnt < totalStressCnt ) {
        //alert( com_msg + passwordJS.notCombination + '\n' + passwordJS.combiMsg1 + '\n' + passwordJS.combiMsg2 + '\n' + passwordJS.combiMsg3 + '\n' + passwordJS.combiMsg4 + '\n' + '위 3가지 중 ' + totalStressCnt + '가지 항목 이상을 포함해야 합니다.' );
        alert( com_msg + passwordJS.notCombination + '\n' + passwordJS.combiMsg1 + '\n' + passwordJS.combiMsg2 + '\n' + passwordJS.combiMsg3 + '\n' + passwordJS.combiMsg4 + '\n' + passwordJS.combiMsg5 );
        return false;
    }

    var chr_pass_0;
    var chr_pass_1;
    var chr_pass_2;

    var SamePass_0 = 0;
    var SamePass_1 = 1;
    var SamePass_2 = 1;
    for( var i=0 ; i < password.length ; i++)
    {
        chr_pass_0 = password.charAt(i);
        chr_pass_1 = password.charAt(i+1);
        chr_pass_2 = password.charAt(i+2);

        if( chr_pass_0 == chr_pass_1 && chr_pass_1 == chr_pass_2 )
        {
            SamePass_0 = sameChar; //동일문자 카운트

        }

        if( chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1 ) SamePass_1++;
        if( chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1 ) SamePass_2++;
    }
    if ( SamePass_0 >= sameChar ) {
        alert( com_msg + passwordJS.notContinue);
        return;
    }

    if ( SamePass_1 > 1 ) {
        alert( com_msg + passwordJS.notAsc );
        return;
    }

    if ( SamePass_2 > 1 ) {
        alert( com_msg + passwordJS.notDesc );
        return;
    }
    return true;
}
</script>

<script for="InnoFD" event="OnDownloadComplete">
    document.InnoFD.RemoveAllFiles( );
    ui.alertMsg("<s:message code="common.msg.down.complete"/>", null, 2000);
</script>

<script for="InnoFD" event="OnDownloadError">
    document.InnoFD.RemoveAllFiles( );
    ui.alertMsg("<s:message code="common.msg.down.error"/>", null, 2000);
</script>
<div class="modal fade" id="urlPop" tabindex="-1" role="dialog" aria-labelledby="urlPop">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<form method="post" id="urlPopForm" onsubmit="return false;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="filterInfo.urlPop.title.add"/></h3>
				</div>
				<div class="modal-body">
					<div class="form-inline">
						<label for="url" class="control-label col-xs-2">URL</label>
						http://<input type="text" class="form-control" name="url" id="noLogurl" placeholder="URL" style="width: 350px;" maxlength="128">
						<input type="hidden" id="urlLogSeq" name="urlLogSeq">
					</div>
					<div class="form-inline" style="padding-left: 10px; color: #f25643;"><s:message code="filterInfo.msg.exceptHttp"/></div>
				</div>
				<input type="hidden" name="tabId"/>
				<input type="hidden" name="tab" />
			</form>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
				<button type="button" class="btn btn-primary saveNoLogUrlPopBtn" accesskey="S" id="saveNoLogUrlPopBtn"><s:message code="common.msg.save"/></button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="TheFirstChangePw" tabindex="-1" role="dialog" aria-labelledby="TheFirstChangePwModal" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<%if(Common.isEquals(adminLanguage, "ko")) {%>
			<div class="modal-header" style="background-color: #253f56;color: white;">
				<h3 class="modal-title">최초 접속 설정</h3>
			</div>
			<div class="modal-body">
				<h5 style="font-weight:900; color:#000; border-bottom: 2px solid #656565; padding: 0 0 9px 14px;">※ 최초 접속시 운용자 정보를 반드시 설정하시기 바랍니다.</h5>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="first_adminId" style="padding-top: 8px;" class="control-label col-xs-4">운용자 아이디</label>
					<input type="text" class="form-control" name="first_adminId" id="first_adminId" placeholder="운용자 아이디" required>
					<input type="hidden" class="form-control" name="first_cur_adminPw" id="first_cur_adminPw">
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="first_adminPw" style="padding-top: 8px;" class="control-label col-xs-4">비밀번호</label>
					<input type="password" class="form-control" name="first_adminPw" id="first_adminPw" placeholder="비밀번호" required>
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="first_c_adminPw" style="padding-top: 8px;" class="control-label col-xs-4">비밀번호 확인</label>
					<input type="password" class="form-control" name="first_c_adminPw" id="first_c_adminPw" placeholder="비밀번호 확인" required>
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;" id="first_accessIp_div">
					<label for="first_accessIp" style="padding-top: 8px;" class="control-label col-xs-4">운용자 접속 IP</label>
					<input type="text" class="form-control" name="first_accessIp" id="first_accessIp" placeholder="운용자 접속 IP" required>
				</div>
			</div>
			<div class="modal-body" style="display: none;">
				<h5 style="font-weight:900; color:#000; border-bottom:2px solid #656565; padding: 0 0 9px 14px;">※ 최초 접속시 데이터베이스 정보를 반드시 설정하시기 바랍니다.</h5>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="first_deviceId" style="padding-top: 8px;" class="control-label col-xs-4">데이터베이스 아이디</label>
					<input type="text" class="form-control" name="first_deviceId" id="first_deviceId" placeholder="데이터베이스 아이디" required>
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="first_devicePw" style="padding-top: 8px;" class="control-label col-xs-4">비밀번호</label>
					<input type="password" class="form-control" name="first_devicePw" id="first_devicePw" placeholder="비밀번호" required>
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="first_c_devicePw" style="padding-top: 8px;" class="control-label col-xs-4">비밀번호 확인</label>
					<input type="password" class="form-control" name="first_c_devicePw" id="first_c_devicePw" placeholder="비밀번호 확인" required>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" accesskey="S" id="TheFirstSaveBtn">변경</button>
			</div>
			<%}else{ %>
			<div class="modal-header" style="background-color: #253f56;color: white;">
				<h3 class="modal-title">First access setting</h3>
			</div>
			<div class="modal-body">
				<h5 style="font-weight:900; color:#000; border-bottom: 2px solid #656565; padding: 0 0 9px 14px;">※ Make sure set up the administrator information when you access first time.</h5>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="first_adminId" style="padding-top: 8px;" class="control-label col-xs-4">Administrator ID</label>
					<input type="text" class="form-control" name="first_adminId" id="first_adminId" placeholder="Administrator ID" required>
					<input type="hidden" class="form-control" name="first_cur_adminPw" id="first_cur_adminPw">
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="first_adminPw" style="padding-top: 8px;" class="control-label col-xs-4">Password</label>
					<input type="password" class="form-control" name="first_adminPw" id="first_adminPw" placeholder="Password" required>
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="first_c_adminPw" style="padding-top: 8px;" class="control-label col-xs-4">Check password</label>
					<input type="password" class="form-control" name="first_c_adminPw" id="first_c_adminPw" placeholder="Check password" required>
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;" id="first_accessIp_div">
					<label for="first_accessIp" style="padding-top: 8px;" class="control-label col-xs-4">Administrator access IP address</label>
					<input type="text" class="form-control" name="first_accessIp" id="first_accessIp" placeholder="Administrator access IP address" required>
				</div>
			</div>
			<div class="modal-body" style="display: none;">
				<h5 style="font-weight:900; color:#000; border-bottom:2px solid #656565; padding: 0 0 9px 14px;">※ Make sure set up the database information when you access first time.</h5>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="first_deviceId" style="padding-top: 8px;" class="control-label col-xs-4">database ID</label>
					<input type="text" class="form-control" name="first_deviceId" id="first_deviceId" placeholder="database ID" required>
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="first_devicePw" style="padding-top: 8px;" class="control-label col-xs-4">Password</label>
					<input type="password" class="form-control" name="first_devicePw" id="first_devicePw" placeholder="Password" required>
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="first_c_devicePw" style="padding-top: 8px;" class="control-label col-xs-4">Check password</label>
					<input type="password" class="form-control" name="first_c_devicePw" id="first_c_devicePw" placeholder="Check password" required>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" accesskey="S" id="TheFirstSaveBtn">Change</button>
			</div>
			<%} %>
		</div>
	</div>
</div>