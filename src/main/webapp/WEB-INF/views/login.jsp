<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<script type="text/javascript" src="<c:url value="/js/sha256.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jsbn.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/rsa.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/prng4.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/rng.js"/>"></script>
<link rel="stylesheet" href="<c:url value="/css/emass_style.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/reset.css"/>" />
<!DOCTYPE html>
<html>
<head>
<title>VENUS / EMASS LTH</title>
<meta charset="utf-8">
<%
	String loginMsg = Config.getString("system.login.msg");
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	if (request.getProtocol().equals("HTTP/1.1")) response.setHeader("Cache-Control", "no-cache");
	try {
		session.removeAttribute(Common.SESSION_CREDENTIAL);
		session.invalidate();
		request.getSession(true);
	} catch (Exception e){
	}

	String locale = Config.getString("default.lang");
%>

<style type="text/css">
html,body {padding: 0px;margin: 0px;background-color:#fff;height: 98%;}
#googleOTPqr { pointer-events: none; }
#reloadBtn{
	color: #fff;
	background-color: #2778bf;
	border-color: #2778bf;
}
</style>
<script type="text/javascript">
var loginMsg = '';
loginMsg += '\n';
loginMsg += '\n';
loginMsg += '         *****  {0}  *****';
loginMsg += '\n';
loginMsg += '\n';
loginMsg += '<s:message code="login.lastlogin.date"/> : {1}\n';
loginMsg += '<s:message code="login.lastlogin.ip"/> : {2}\n';
loginMsg += '\n';
loginMsg += '<s:message code="login.currentlogin.date"/> : {3}\n';
loginMsg += '<s:message code="login.currentlogin.ip"/> : {4}\n';


function MM_preloadImages() { //v3.0
	var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
	var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
	if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
	var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
	var p,i,x;  if(!d) d=document;
	if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);
	}
	if(!(x=d[n])&&d.all) x=d.all[n];
	for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	if(!x && d.getElementById) x=d.getElementById(n); return x;
}
function MM_swapImage() { //v3.0
	var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
var firstOTP = false;
var rsa;
$(document).ready(function(){
	var userId = getCookie('Cookie_userId');
	$('#userIdInput').val(userId);

	if($('#userIdInput').val() != '') {
		$('#saveLoginId').prop('checked', true);
		$('#userPwInput').focus();
	} else $('#userIdInput').focus();

	$("#secretSaveBtn").click(function() {
		var userIdInput = $('#userIdInput').val().ltrim().rtrim();
		var userPwInput = $('#userPwInput').val().ltrim().rtrim();
		let pinCode = $("#pinCode").val().replaceAll(" ","");
		let numRegExp = /^[0-9]*$/;

		if(pinCode == '') {
			let msg = '';

			if(firstOTP) {
				msg = '<s:message code="login.google.otp.create.secretKey"/>';
			}

			msg = '<s:message code="login.google.otp.input.pincode"/>';
			ui.alertMsg(msg);
			return;
		}

		if(!numRegExp.test(pinCode)) {
			ui.alertMsg('<s:message code="login.google.otp.input.pincode2"/>');
			return;
		}

		ui.on('loginBody');
		ui.get({
			url : 'secretKeySave.xcn',
			pinCode : rsa.encrypt(pinCode),
			secretKey : rsa.encrypt($("#secretKey").val().ltrim().rtrim()),
			userId : rsa.encrypt(userIdInput),
			firstOTP : firstOTP,
			success : function ( data, total ) {
				$("#googleOTPPop").modal("hide");
				successLogin(data, userIdInput, userPwInput);
			},
			error : function (status, message, data) {
				$('#pinCode').val('');
				ui.alertMsg(message, function(){
					$('#pinCode').focus();
				}, 3000);
			},
			complete : function (){
				ui.off('loginBody');
			}
		});
	});

	$('#googleOTPPop').on('shown.bs.modal',function() {
		$('#pinCode').focus();
	});

	$('#loginBtn').click(function(){
		var userIdInput = $('#userIdInput').val().ltrim().rtrim();
		var userPwInput = $('#userPwInput').val().ltrim().rtrim();
		if( userIdInput == '' ){
			ui.alertMsg('<s:message code="login.input.id"/>');
			return;
		}
		if( userPwInput == '' ){
			ui.alertMsg('<s:message code="login.input.password"/>');
			return;
		}
		rsa = new RSAKey();
		ui.on('loginBody');
		ui.get({
			url : 'getRSAKey.xcn',
			success : function ( data ) {
				rsa.setPublic(data.publicKeyModulus, data.publicKeyExponent);

				ui.get({
					url : 'loginProcess.xcn',
					userId : rsa.encrypt(userIdInput),
					userPw : rsa.encrypt(userPwInput),
					success : function ( data, total ) {
						//구글 OTP
						if(data.secretKey != null || data.secretKey != undefined) {
							$("#googleOTPPop").modal("show");
							$('#googleOTPPop .modal-title').html('<s:message code="login.google.otp"/>');
							$("#secretKey").val(data.secretKey);
							if(data.qrCodeURL != null || data.qrCodeURL != undefined) {
								$('#otpQRrow').css("display", "block");
								$('#secretKeyRow').css("display","block");
								$('#reloadBtn').css("display","inline-block");
								$("#googleOTPqr").attr("src",data.qrCodeURL);
								$('#otpMessage').html('<s:message code="login.google.otp.first.login"/>');
								firstOTP = true;
							} else {
								$('#otpQRrow').css("display", "none");
								$('#secretKeyRow').css("display","none");
								$('#reloadBtn').css("display","none");
								$('#otpMessage').html('<s:message code="login.google.otp.message1"/>');
								firstOTP = false;
							}
							otpTimeOut();
						} else {
							successLogin(data, userIdInput, userPwInput);
						}
					},
					error : function (status, message, data) {
						ui.alertMsg(message, function(){
							if(data =='PW_EXPIRED') {
                                $('#userPwInput').val('');
								currentPw = sha256_digest(userPwInput);
								adminId = userIdInput;
								$('#changePasswordBtn').click();
							}
                            else if(data=='USER_LOCK'){
                                $("#unusePop").modal("show");
							}
						}, 3000);
					},
					complete : function (){
						ui.off('loginBody');
					}
				});

			},
			error : function (status, message) {
				$('#adminPw').val('');
				alert(message);
				ui.off();
			},
			complete : function (){
			}
		});
	});

	$('#userIdInput').enter(function(){
		if( $('#userIdInput').val() != '' ) $('#userPwInput').focus();
	});
	$('#userPwInput').enter(function(){
		if( $('#userPwInput').val() != '' ) $('#loginBtn').click();
	});

	$("#pinCode").enter(function() {
		if( $('#pinCode').val() != '' ) $('#secretSaveBtn').click();
	});

	$('#reloadBtn').on('click', function() {
		reloadOTPgenerate();
		$('#pinCode').focus();
	});
});

function showUnusePop(){
    $("#unusePop").modal("hide");
    $('#unuseAdminPop').modal('show');
}

let timeOut=true;

function sendMail(){
    var userIdInput = $('#userIdInput').val().ltrim().rtrim();

    if(timeOut!=true){
        alert("아직 유효 메일이 남아있습니다");
    } else {
        ui.get({
            url: 'mailSend.xcn',
            userId: rsa.encrypt(userIdInput),
            success: function (data) {
                confirmTimeOut();
                alert("인증코드 발송");
            },
            error: function (request,status,error,data) {
                alert("R: "+request+"S: "+status+" E: "+error+" D: "+data);
                if (error=='MAILNOCHECK') {
                    alert("메일서버가 비활성화 상태 입니다. 관리자에게 문의하시길 바랍니다");
                } else {
                    alert("인증코드 발송에 실패하였습니다 관리자에게 문의하시길 바랍니다");
                }
                timeOut=true;
                $('#unuseAdminPop').modal('hide');
            }
        })
    }
}

function confirmNumber(){
    var userIdInput = $('#userIdInput').val().ltrim().rtrim();
    var number1 = $("#number").val().ltrim().rtrim();;

        ui.get({
	        url: 'updateStatus.xcn',
            userId :userIdInput,
	        number1 :number1,
	        success:function (data,message){
                $("#unuseAdminPop").modal('hide');
                $('#unusetime').css("display", "none");
                $('#number').val('');
                alert("잠금이 해제되었습니다. 다시 로그인하세요");

            },
            error: function (data,message){
                alert("코드 입력이 잘못되었습니다");
            }
        });
}

function reloadOTPgenerate(){
	var userIdInput = $('#userIdInput').val().ltrim().rtrim();
	ui.on('googleOTPPop');
	ui.get({
		url : 'reloadGoogleOTP.xcn',
		userId : rsa.encrypt(userIdInput),
		success : function ( data, total ) {
			//구글 OTP 재발급
			$('#googleOTPPop .modal-title').html('<s:message code="login.google.otp"/>');
			$('#otpQRrow').css("display", "block");
			$("#googleOTPqr").attr("src",data.qrCodeURL);
			$("#secretKey").val(data.secretKey);
			$('#otpMessage').html('<s:message code="login.google.otp.first.login"/>');
			firstOTP = true;
			otpTimeOut();
		},
		error : function (status, message, data) {
			$('#googleOTPPop').modal('hide');
			alert(message);
		},
		complete : function (){
			ui.off();
		}
	});
}

function successLogin(data, userId, userPw) {
	var adminName=nvl(data.adminName,'-');
	var	msg = '';
	if( ( data.pwchgDt=='' || data.pwchgDt == null ) || (( data.pwchgDt=='' || data.pwchgDt == null ) && data.firstAdminYn == 'Y') ){
		$('#first_adminId').val(userId);
		$('#first_cur_adminPw').val(sha256_digest(userPw));
		msg = '<s:message code="login.first.access"/>';
		loginCheck(data.firstAdminYn);
		return;
	}else{
		if($('#saveLoginId').is(':checked')) {
			var userId = $('#userIdInput').val();
			setCookie('Cookie_userId', userId, 30);
		} else {
			setCookie('Cookie_userId', '', -1);
		}
		msg = $('#message').val() + data.welcomeInfo;
	}

	ui.alertMsg(msg, function(){
		if( data.menuKey != undefined && data.menuKey != ''){
			document.location.href = '<c:url value="/ems/dashboard.do?menuKey="/>'+data.menuKey;
		}else{
			document.location.href = '<c:url value="/ems/index.do"/>';
		}
	}, 3000);
}
var otpInterval;
var otpDelay;
function otpTimeOut() {
	clearInterval(otpInterval);
	clearTimeout(otpDelay);
	var title = $('#googleOTPPop .modal-title').html();
	var t = (30000/1000)-1;
	otpInterval = setInterval(function(){
		if(!firstOTP) $('#googleOTPPop .modal-title').html(title + '  <div style="float:right;text-align:right;font-weight:normal;font-size:13px;">Auto Close ' + (t--).comma() + ' \'s</div>' );
	},1000);

	otpDelay = setTimeout(function(){
		clearInterval(otpInterval);
		clearTimeout(otpDelay);
		 $('#googleOTPPop').modal('hide');
	}, 30000);
}
function confirmTimeOut() {
     timeOut=false;
    $('#unusetime').css("display", "block");
    var t =(90000/1000)-1;
         setInterval(function(){
       $('#unuseAdminPop #unusetime').html((t--).comma() + 's' );
    },1000);
        setTimeout(function(){
            timeOut =true;
         $('#unuseAdminPop').modal('hide');
            $('#unusetime').css("display","none");
            t= (30000/1000)-1;
            ui.get({
                url: 'deleteSession.xcn'
            });


    }, 90000);
}


</script>


<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>EMASS PRO</title>


</head>
<body id="loginBody">
<%--
<div class="modal fade" id="unusePop" tabindex="-1" role="dialog" aria-labelledby="unusePop">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title">운용자 계정 잠금</h3>
			</div>

			<div class="modal-footer">
				<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal">종료하기</button>
				<button type="button" class="btn btn-primary" accesskey="S" onclick="showUnusePop()">본인인증 후 변경하기</button>

			</div>
		</div>
	</div>
</div>

&lt;%&ndash;장기미사용 본인인증 팝업창&ndash;%&gt;
<div class="modal fade" id="unuseAdminPop" tabindex="-1" role="dialog" aria-labelledby="unuseAdminPop">
	<div class="modal-dialog" role="document" style="height: 500px;">
		<div class="modal-content" style="height: 100%;">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title">운용자 계정 잠금</h3>
			</div>
			<div class="modal-body">
				<label class="control-label col-xs-4">이메일 본인인증</label>
				<div id="unusetime"></div>
				<br><br>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<button type="button" name="sendBtn" id="sendBtn" onclick="sendMail()">메일 보내기</button><br>
					<input type="text" name="number" id="number" style="width:250px; margin-top: -10px" placeholder="인증코드 입력">
					<button type="button" name="confirmBtn" id="confirmBtn" onclick="confirmNumber()">인증하기</button>
				</div>
			</div>
		</div>
	</div>
</div>


<div class="modal fade" id="googleOTPPop" tabindex="-1" role="dialog" aria-labelledby="googleOTPModal">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title"><s:message code="login.google.otp"/></h3>
			</div>
			<div class="modal-body">
				<div class="form-inline" id="secretKeyRow" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="secretKey" class="control-label col-xs-4"><s:message code="login.google.otp.secretKey"/></label>
					<input type="text" class="form-control" id="secretKey" placeholder="<s:message code="login.google.otp.secretKey"/>" disabled>
				</div>
				<div class="form-inline" id="otpQRrow" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="googleOTPqr" class="control-label col-xs-4" style="margin-top:45px;"><s:message code="login.google.otp.qrcode"/></label>
					<img id="googleOTPqr" style="width:100px; height:100px;" alt="Google OTP"/>
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="pinCode" class="control-label col-xs-4"><s:message code="login.google.otp.pin"/></label>
					<input type="text" class="form-control" id="pinCode" placeholder="<s:message code="login.google.otp.pin"/>">
				</div>
				<div class="form-inline" id="otpMessage" style="border-bottom: 1px dashed #eee;padding: 7px 0px;"></div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" accesskey="R" id="reloadBtn"><s:message code="login.google.otp.reload"/></button>
				<button type="button" class="btn btn-primary" accesskey="S" id="secretSaveBtn"><s:message code="login.google.otp.login"/></button>
				<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="changePasswordPop" tabindex="-1" role="dialog" aria-labelledby="changePasswordModal">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title"><s:message code="login.change.password"/></h3>
			</div>
			<div class="modal-body">
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="attachTypePopInput" class="control-label col-xs-4"><s:message code="login.current.password"/></label>
					<input type="password" class="form-control" id="current_password" placeholder="<s:message code="login.current.password"/>" required autocomplete="off">
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="attachDescPopInput" class="control-label col-xs-4"><s:message code="login.change.password"/></label>
					<input type="password" class="form-control" id="change_password" placeholder="<s:message code="login.change.password"/>" required autocomplete="off">
				</div>
				<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
					<label for="attachDescPopInput" class="control-label col-xs-4"><s:message code="login.confirm.password"/></label>
					<input type="password" class="form-control" id="current_confirm_password" placeholder="<s:message code="login.confirm.password"/>" required autocomplete="off">
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
				<button type="button" class="btn btn-primary" accesskey="S" id="changePasswordSaveBtn"><s:message code="common.msg.change"/></button>

			</div>
		</div>
	</div>
</div>--%>


<div id="changePasswordBtn"></div>
<textarea style="display: none;" id="message"><%=loginMsg%></textarea>
<div id="login">
	<div class="logo">
		<img src="<c:url value="/img/logo_login.png"/>" alt="EmassPro" class="emass">
	</div>
	<div id="loginWrap">
		<!-- 로그인-->
		<form method="post" id="loginForm">
			<div class="imgcontainer">
				<img src="<c:url value="/img/logo_emass.png"/>" alt="EmassPro" class="emass">
			</div>

			<div class="container">
				<input type="text"  id="userIdInput"  value=""/>
				<input type="password" class="input1"  id="userPwInput"  value="" autocomplete="off"/>

				<button id="loginBtn" type="button">로그인</button>
				<label>
					<input id="saveLoginId" type="checkbox" checked="checked" name="remember" class="checkbox_align">
					<%if(Common.isEquals(locale, "ko")) {%> 로그인 ID 저장
					<%}else{ %> Save Login ID
					<%} %>
				</label>
			</div>
		</form>
		<!--//로그인-->
	</div>
	<div id="loginText">
		<h3>Enterprise MessAge Scanning System</h3>
		<p>온라인(네트워크) 정보유출을 방지하기 위하여<br/>사용자의 전달 메시지 내용에 대하여 로깅 감시하는 시스템입니다.</p>
	</div>
</div>
</body>
</html>
