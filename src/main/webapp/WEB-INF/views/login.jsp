<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/loginScript.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>VENUS / EMASS AI</title>
	<meta charset="utf-8">
	<%
		String loginMsg = Config.getString("system.login.msg");
		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);

		if (request.getProtocol().equals("HTTP/1.1") || request.getProtocol().equals("HTTPS") || request.getProtocol().equals("HTTP/2.0") ) response.setHeader("Cache-Control", "no-cache");
		try {
			session.removeAttribute(Common.SESSION_CREDENTIAL);
			session.invalidate();
			request.getSession(true);
		} catch (Exception e){
		}
		String locale = Config.getString("default.lang");
	%>


	<style type="text/css">
		html,body {padding: 0px;margin: 0px;width: 100%;height: 100%;}
		#googleOTPqr { pointer-events: none; }
		#reloadBtn{
			color: #fff;
			background-color: #2778bf;
			border-color: #2778bf;
		}
		#number_confirm {
			position: relative;
		}

		#number_confirm::after {
			content: "";
			position: absolute;
			top: 0;
			right: 0;
			color: red;
			font-size: small;
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

        var firstOTP = false;
        var rsa;
        $(document).ready(function(){
            var userId = getCookie('Cookie_userId');
            $('#userIdInput').val(userId);


            $(".clearBtn").click(function() {
                $("#number_confirm").val('');
            });

            $(document).on('click', '.otpClose', function() {
                $("#pinCode").val('');
            });


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
                                $('#userPwInput').val('');
                                ui.alertMsg(message, function(){
                                    if(data =='PW_EXPIRED') {
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
                    document.location.href = '<c:url value="/ems/dashboard.do"/>';
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
                if (!firstOTP) {
                    $('#googleOTPPop .modal-title').html(
                        title + '  <div style="text-align:right;font-weight:normal;font-size:13px;">Auto Close' + (t--).comma() + ' \'s <span className="close" data-dismiss="modal" class="otpClose">x</span></div>'
                    );
                }
            },1000);

            otpDelay = setTimeout(function(){
                clearInterval(otpInterval);
                clearTimeout(otpDelay);
                if(!firstOTP) $('#googleOTPPop').modal('hide');
                $('#pinCode').val('');
            }, 30000);
        }


        let timeOut=true;

        function sendMail(){
            var userIdInput = $('#userIdInput').val().ltrim().rtrim();

            if(timeOut!=true){
                ui.alertMsg('<s:message code="login.mail.notyet"/>');
            }
            else {
                confirmTimeOut();
                // 버튼 텍스트 변경
                $('#confirmBtn').text('확인하기');
                $('#confirmBtn').attr('onclick', 'confirmNumber()');

                ui.get({
                    url: 'mailSend.xcn',
                    userId: rsa.encrypt(userIdInput),
                    success: function (data) {
                       /* alert("인증코드 발송");*/
                    },
                    error: function (request,status,error,data) {
                        if (error=='MAILNOCHECK') {
                            ui.alertMsg('<s:message code="login.MAILNOCHECK.access"/>');
                        } else {
                            ui.alertMsg('<s:message code="login.MAILNOCHECK.access2"/>');
                        }
                        timeOut=true;
                        $('#unuseAdminPop').modal('hide');
                    }
                })
            }
        }

        function confirmNumber(){

            var userIdInput = $('#userIdInput').val().ltrim().rtrim();
            var number1 = $("#number_confirm").val().ltrim().rtrim();
            if (!number1.trim()) {
                alert("입력 후 확인을 눌러주세요.");
                return;
            }

            ui.get({
                url: 'updateStatus.xcn',
                userId :userIdInput,
                number1 :number1,
                success:function (data,message){
                    $("#unuseAdminPop").modal('hide');
                    $("#unusePop").modal('hide');
                    $('#unusetime').css("display", "none");
                    $('#number').val('');
                    alert("잠금이 해제되었습니다. 다시 로그인하세요");
                    $('#confirmBtn').attr('class', 'form_btn01_02');
                    $('#confirmBtn').attr('onclick', 'sendMail()');
                    $('#number_confirm').html('');
                    $('#confirmBtn').text('인증하기');
                },
                error: function (data,message){
                    alert("코드 입력이 잘못되었습니다");
                }
            });
        }

        function confirmTimeOut() {
            timeOut = false;
            var t = (90000 / 1000) - 1;
            var numberConfirmInput = document.getElementById('number_confirm');

            // 부모 요소에 div 추가
            var displayText = document.createElement('div');
            displayText.style.position = 'absolute';
            displayText.style.top = '0';
            displayText.style.right = '0';
            displayText.style.color = 'red';
            displayText.style.fontSize = 'small';

            // 수정된 부분: number_confirm의 부모에 displayText 추가 대신 number_confirm에 직접 추가
            numberConfirmInput.parentElement.appendChild(displayText);

            var countdownInterval = setInterval(function () {
                displayText.textContent = (t--).comma() + 's';
            }, 1000);

            setTimeout(function () {
                clearInterval(countdownInterval);
                timeOut = true;
                $('#unusePop').modal('hide');
                ui.get({
                    url: 'deleteSession.xcn',
                    success: function () {
                        t = (30000 / 1000) - 1;

                        // displayText 삭제
                        displayText.parentNode.removeChild(displayText);

                        // 버튼 속성 재설정
                        $('#confirmBtn').attr('class', 'form_btn01_02');
                        $('#confirmBtn').attr('onclick', 'sendMail()');
                        $('#number_confirm').html('');
                        $('#confirmBtn').text('인증하기');
                    }
                });
            }, 90000);
        }


	</script>
</head>
<body id="loginBody">

<%--<div class="modal fade" id="unusePop" tabindex="-1" role="dialog" aria-labelledby="unusePop">
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
</div>--%>



<%--장기미사용 본인인증 팝업창--%>
<div class="modal" id="unusePop" tabindex="-1" role="dialog" aria-labelledby="unusePop"
     data-backdrop="static">
	<div class="modal-content">
		<div class="modalHead">
			<h2><s:message code="login.mail.unuse"/></h2>
			<span class="close clearBtn" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalCon">
			<div class="modalbody">
				<h4 class="blue02" style="font-weight: 600;"> <s:message code="login.mail.send"/></h4>

				<div class="row pt8">
					<input type="text" name="number" id="number_confirm" style="width:250px; margin-top: -10px; position: relative;"
					       placeholder="<s:message code="login.mail.code"/>">
					<button type="button" class="form_btn01_02" name="confirmBtn" id="confirmBtn" onclick="sendMail()"><s:message code="login.mail.send"/></button>
					<%--<span id="unusetime"></span>--%>
				</div>
				<div style="font-size: 13px;"><s:message code="login.mail.info"/></div>
			</div>
		</div>
	</div>
</div>
</div>

<div class="modal" id="googleOTPPop" aria-labelledby="googleOTPModal" tabindex="-1" role="dialog" data-backdrop="static">
	<div class="modal-content">
		<div class="modalHead">
			<h2 class="modal-title"><s:message code="login.google.otp"/></h2>
		</div>
		<div class="modalCon">
			<div class="modalbody">
				<div class="row">
					<div class="col-35">
						<label for="secretKey" class="fname"><s:message code="login.google.otp.secretKey"/></label>
					</div>
					<div class="col-65">
						<input type="text" class="w100" id="secretKey" placeholder="<s:message code="login.google.otp.secretKey"/>" disabled>
					</div>
				</div>
				<div class="row" id="otpQRrow">
					<div class="col-35">
						<label for="googleOTPqr" class="fname"><s:message code="login.google.otp.qrcode"/></label>
					</div>
					<div class="col-65">
						<img id="googleOTPqr" alt="Google OTP"/>
					</div>
				</div>
				<div class="row">
					<div class="col-35">
						<label for="pinCode" class="fname"><s:message code="login.google.otp.pin"/></label>
					</div>
					<div class="col-65">
						<input type="text" class="w100" id="pinCode" placeholder="<s:message code="login.google.otp.pin"/>">
					</div>
				</div>
				<div id="otpMessage"></div>
			</div>
			<div class="modalfooter">
				<button type="button" class="pop_btn02" accesskey="R" id="reloadBtn"><s:message code="login.google.otp.reload"/></button>
				<button type="button" class="pop_btn02" accesskey="S" id="secretSaveBtn"><s:message code="login.google.otp.login"/></button>
				<button type="button" class="pop_btn01 otpClose" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
			</div>
		</div>
	</div>
</div>

<div class="modal" id="changePasswordPop" tabindex="-1" role="dialog" aria-labelledby="changePasswordModal"  data-backdrop="static">
	<div class="modal-content">
		<div class="modalHead">
			<h2><s:message code="login.change.password"/></h2>
			<span class="close" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalCon">
			<%--<div class="modalTop">
				<h3>비밀번호 변경</h3>
			</div>--%>
			<div class="modalbody">
				<div class="row">
					<div class="col-35">
						<label for="attachTypePopInput" class="fname"><s:message code="login.current.password"/></label>
					</div>
					<div class="col-65">
						<input type="password" class="w100" id="current_password" placeholder="<s:message code="login.current.password"/>" required autocomplete="off">
					</div>
				</div>
				<div class="row">
					<div class="col-35">
						<label for="attachTypePopInput" class="fname"><s:message code="login.change.password"/></label>
					</div>
					<div class="col-65">
						<input type="password" class="w100" id="change_password" placeholder="<s:message code="login.change.password"/>" required autocomplete="off">
					</div>
				</div>
				<div class="row">
					<div class="col-35">
						<label for="attachTypePopInput" class="fname"><s:message code="login.confirm.password"/></label>
					</div>
					<div class="col-65">
						<input type="password" class="w100" id="current_confirm_password" placeholder="<s:message code="login.confirm.password"/>" required autocomplete="off">
					</div>
				</div>
			</div>
			<div class="modalfooter">
				<button type="button" class="pop_btn01"  accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
				<button type="button" class="pop_btn02" accesskey="S" id="changePasswordSaveBtn"><s:message code="common.msg.change"/></button>

			</div>
		</div>
	</div>
</div>
<div id="changePasswordBtn"></div>
<textarea style="display: none;" id="message"><%=loginMsg%></textarea>

<div id="login">
	<div id="loginWrap">
		<!-- 로그인-->
		<form method="post">
			<div class="imgcontainer">
				<img src="<c:url value="/img/logo_emass.png"/>" alt="EmassPro" class="emass">
			</div>

			<div id="login_container">
				<div>
					<input type="text" placeholder="ID" id="userIdInput" required>
					<input class="mat12" type="password" placeholder="Password" id="userPwInput" autocomplete="off" required>
				</div>
				<div>
					<button id="loginBtn" type="button">로그인</button>
				</div>
			</div>
			<div id="login_switch">
				<label class="switch">
					<input type="checkbox" checked="checked" id="saveLoginId" class="checkbox_align">
					<span class="slider round"></span>
				</label>
				<span class="switchText"><%= Common.isEquals(locale, "ko") ? "로그인 ID 저장" : "Save Login ID" %></span>
			</div>
		</form>
		<!--//로그인-->
	</div>

</div>
<!-- OLD
<div id="login">
	<div class="logo">
		<img src="<c:url value="/img/logo_login.png"/>" alt="EmassPro" class="emass">
	</div>
	<div id="loginWrap">

		<form method="post">
			<div class="imgcontainer">
				<img src="<c:url value="/img/logo_emass.png"/>" alt="EmassPro" class="emass">
			</div>

			<div class="container">
				<input type="text" placeholder="ID" id="userIdInput" required>
				<input type="password" placeholder="Password" id="userPwInput" autocomplete="off" required>
				<button id="loginBtn" type="button">로그인</button>
				<label>
					<input type="checkbox" checked="checked" id="saveLoginId" class="checkbox_align">
						<%= Common.isEquals(locale, "ko") ? "로그인 ID 저장" : "Save Login ID" %>
			</div>
		</form>

	</div>
	<div id="loginText">
		<h3>Enterprise MessAge Scanning System</h3>
	</div>
</div>-->

<style>
	/* The switch - the box around the slider */
	.switch {
		position: relative;
		display: inline-block;
		width: 40px;
		height: 24px;
	}

	/* Hide default HTML checkbox */
	.switch input {
		opacity: 0;
		width: 0;
		height: 0;
	}

	/* The slider */
	.slider {
		position: absolute;
		cursor: pointer;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		background-color: #ccc;
		-webkit-transition: .4s;
		transition: .4s;
	}

	.slider:before {
		position: absolute;
		content: "";
		height: 17px;
		width: 17px;
		left: 3px;
		bottom: 3px;
		background-color: white;
		-webkit-transition: .4s;
		transition: .4s;
	}

	input:checked + .slider {
		background-color: #2196F3;
	}

	input:focus + .slider {
		box-shadow: 0 0 1px #2196F3;
	}

	input:checked + .slider:before {
		-webkit-transform: translateX(16px);
		-ms-transform: translateX(16px);
		transform: translateX(16px);
	}

	/* Rounded sliders */
	.slider.round {
		border-radius: 34px;
	}

	.slider.round:before {
		border-radius: 50%;
	}
</style>
</body>
</html>
