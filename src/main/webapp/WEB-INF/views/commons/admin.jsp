<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<%
	String certType = Config.getString("cert.type");
	String sso_type = Config.getString("sso_type");
	String googleOtp = Config.getString("google.otp.used");
%>
<head>
	<style type="text/css">
		.radio-inline {
			padding-left: 0px;
		}

		.ellipsis {
			width: 280px;
			text-overflow: ellipsis;
			overflow: hidden;
			white-space: nowrap;
		}

		.modal-lg {
			width: 1200px;
		}
	</style>
	<script type="text/javascript">
        var searchFlag = false;
        var certType = '<%=certType%>';
        var sso_type = '<%=sso_type%>';
        var googleOtp = '<%=googleOtp%>';
        $(document).ready(function () {
            console.log(googleOtp);
            if (certType != '' || sso_type == 'S') $('#certTypeDiv').show();
            else $('#certTypeDiv').hide();

            if (infoFeedbackConf == 'false') {
                $('[name=infoFeedbackYn][value=N]').prop('checked', true);
                $('[name=infoFeedbackYn]').prop('disabled', true);
                $('#infoFeedbackComment').show();
            }

            $('#startDatePicker').datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date())
            });

            $('#endDatePicker').datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date())
            });

            $('#searchBtn').click(function () {
                getData();
            });
            $('#searchStr').enter(function () {
                getData();
            });

            $('#applyPopBtn').click(function () {
                ui.get({
                    adminId: grid.getValue(grid.Row, 'adminId'),
                    url: 'updateAdminStatusOK.xcn',
                    success: function (data, total) {
                        alert('<s:message code="common.msg.applied"/>');
                        $("#statusPop").modal('hide');
                        getData();
                    },
                    error: function (status, message) {
                        ui.alertMsg(message);
                    },
                    complete: function () {

                    }
                });
            });

            $('#loginType').change(function () {
                var value = $(this).val();
                if (value == 'C') {
                    $('#adminPw').prop('disabled', false);
                    $('#c_adminPw').prop('disabled', false);
                } else {
                    $('#adminPw').prop('disabled', true);
                    $('#c_adminPw').prop('disabled', true);
                }
            });

            $('#insertBtn').click(function () {
                $('otpRowDiv').css('display', 'none');
                $("#adminPop").modal('show');
                $('#adminPop').attr('mode', 'insert');
                $('#adminPop input[type=text], #adminPop input[type=password]').val('').prop('disabled', false);
                $('#loginType').val('C');
                $('#loginType').prop('disabled', true);
                /* 부서권한
                $('#coText, #busiText, #deptText, #serviceText, #regexpText, #readAuthText' ).val('').prop('disabled',true);
                $('#coHidden, #busiHidden, #deptHidden, #serviceHidden, #regexpHidden').val('');
                */
                $('#coText, #busiText, #serviceText, #regexpText, #readAuthText').val('').prop('disabled', true);
                $('#coHidden, #busiHidden, #serviceHidden, #regexpHidden').val('');
                $('[name=adminType][value=M]').prop('checked', true);
                $('[name=approbator][value=N]').prop('checked', true);
                $('[name=infoFeedbackYn][value=N]').prop('checked', true);
                $('[name=useYn][value=Y]').prop('checked', true);
                $("[name=workStatus]").prop('checked', false);
                $("[name=chkMenu]").prop('checked', true);
                $('#busi').prop('disabled', true);
                //$('#dept').prop('disabled',true);
                $('.adminType, .adminTypeS').prop('disabled', false);
                setTimeout(function () {
                    $("#adminId").focus();
                }, 500);

                $('#admin_normal').show();
                $('#admin_system').hide();

                $('.adminType').parent().css('display', '');
                $('.adminType').parent().next().css('margin-left', '10');

                if (firstAdminYn == 'Y') {
                    $('.adminType').parent().css('display', '');
                    $('.adminTypeS').parent().css('display', 'none');
                    $('.adminType').parent().next().css('margin-left', '0');
                } else {
                    $('.adminType').parent().css('display', '');
                    $('.adminTypeSys').parent().css('display', 'none');
                    $('.adminTypeS').parent().css('display', 'none');
                    $('.adminType, .adminTypeS').prop('disabled', false);
                    $('.adminType').parent().next().css('margin-left', '10');
                }
                if ($('[name=adminType]').val() == "C") {
                    $("#readAuthDiv").css('display', '');
                } else {
                    $("#readAuthDiv").css('display', 'none');
                }
            });
            $('.selBtn').click(function () {
                var id = $(this).attr('id');
                var coCd = $('#coHidden').val();
                var oldCode = $('#' + id + 'Hidden').val();
                var oldConm = $('#' + id + 'Text').val();
                $('#oldCode').val(oldCode);
                $('#oldConm').val(oldConm);
                openWindow(id);
            });

            $('#savePopBtn').click(function () {
                insertAdmin();
            });

            $('#ipMacBtn').click(function () {
                getSystemIpMacAll("L");
                $("#ipMacPop").modal('show');
                $('#ipMacPop input[type=text]').val('').prop('disabled', false);
                setTimeout(function () {
                    $("#systemIp1").focus();
                }, 500);
            });

            $('#saveIpMacPopBtn').click(function () {
                insertSystemIpMac();
            });

            $('[name=workStatus]').change(function () {
                if (($(this).prop("checked"))) {
                    if ($(this).val() == "R") {
                        $('[name=workStatus][value="O"]').prop("checked", false);
                    } else {
                        $('[name=workStatus][value="R"]').prop("checked", false);
                    }
                }
            });

            $('[name=adminType]').change(function () {
                if ($(this).prop("checked")) {
                    if ($(this).val() == "C") {
                        $('#readAuthDiv').css('display', '');
                    } else {
                        $('#readAuthDiv').css('display', 'none');
                    }
                }
            });

            $('#selAllBodyBtn').click(function () {
                $("#divBodyChk input[name='chkMenu']").prop("checked", true);
            });

            $('#selAllExpBtn').click(function () {
                $("#divExpChk input[name='chkMenu']").prop("checked", true);
            });

            $('#resetAllBodyBtn').click(function () {
                $("#divBodyChk input[name='chkMenu']").prop("checked", false);
            });

            $('#resetAllExpBtn').click(function () {
                $("#divExpChk input[name='chkMenu']").prop("checked", false);
            });

            /*
             * 구글 OTP 초기화
             */
            $('#otpResetBtn').click(function () {
                if ($('#adminId').val() == '') {
                    ui.alertMsg('<s:message code="admin.msg.enter.id"/>');
                    $('#adminId').focus();
                    return;
                }
                var message = '<s:message code="common.msg.otpResetMesssage"/>';
                ui.confirmMsg(message, '', '', function (rs) {
                    ui.get({
                        url: '/otpReset.xcn',
                        adminId: $('#adminId').val(),
                        success: function (data, total) {
                            alert('<s:message code="didBlock.rule.result.success"/>');
                        },
                        error: function (state, message) {
                            alert('<s:message code="didBlock.rule.result.fail"/>');
                        }
                    });
                });

            });

            getData();
        });

        function openWindow(id) {
            var url = '<c:url value="/commons/selectCodeAll.do?codeType='+id+'"/>';
            var pop = fnOpenWindow('', 'selectCodeWinPopup', 860, 500, 'resize');
            $('#userPopForm').attr('target', 'selectCodeWinPopup');
            $('#userPopForm').attr('action', url);
            $('#userPopForm').attr('method', 'post');
            $('#userPopForm').submit();
        }

        /* 부서권한
         function busiDeptBtnControl(){
            if( $('#coHidden').val() == '' ) {
                $('#busi').prop('disabled',true);
                $('#dept').prop('disabled',true);
            }
            else {
                $('#busi').prop('disabled',false);
                $('#dept').prop('disabled',false);
            }
        } */

        function busiBtnControl() {
            if ($('#coHidden').val() == '') {
                $('#busi').prop('disabled', true);
            } else $('#busi').prop('disabled', false);
        }

        function getSelectedCodeText(data) {
            var result = '';
            for (var i = 0, cnt = data.length; i < cnt; i++) {
                result += data[i].codeName + ', ';
            }
            if (result != '') result = result.substring(0, result.length - 2);
            return result;
        }

        function getSelectedCodeHidden(data) {
            var result = '';
            for (var i = 0, cnt = data.length; i < cnt; i++) {
                result += data[i].code + '|';
            }
            if (result != '') result = result.substring(0, result.length - 1);
            return result;
        }

        function getSelectedCodeData(codeType, data) {
            $('#' + codeType + 'Text').val(getSelectedCodeText(data));
            $('#' + codeType + 'Text').attr('title', $('#' + codeType + 'Text').val());
            $('#' + codeType + 'Hidden').val(getSelectedCodeHidden(data));
        }

        function resetCode(codeType) {
            $('#' + codeType + 'Text').val('');
            $('#' + codeType + 'Hidden').val('');
            if (codeType == 'co') {
                //busiDeptBtnControl();
                busiBtnControl();
                resetCode('busi');
                //resetCode('dept');
            }
        }

        /*
         * 운용자 목록 조회
         */
        function getData() {
            if (searchFlag) return;

            var searchStr = $("#searchStr").val();
            var searchUseYn = $('#useYnSelect').val();
            grid.on();
            searchFlag = true;
            ui.get({
                log: 'Y',
                adminId: adminId,
                firstAdminYn: firstAdminYn,
                adminType: adminType,
                url: 'getAdminList.xcn',
                searchUseYn: searchUseYn,
                searchStr: searchStr,
                success: function (data, total) {
                    grid.setData(data);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    searchFlag = false;
                    grid.off();
                }
            });
        }

        /*
         * 운용자 추가
         */
        function insertAdmin() {
            var mode = $('#adminPop').attr('mode');

            if ($('#adminId').val() == '') {
                ui.alertMsg('<s:message code="admin.msg.enter.id"/>');
                $('#adminId').focus();
                return;
            }
            if (mode != 'modify' && !idCheck($('#adminId').val())) {
                ui.alertMsg('<s:message code="admin.msg.use.englishid"/>');
                return;
            }
            if ($('#adminName').val() == '') {
                ui.alertMsg('<s:message code="admin.msg.enter.name"/>');
                $('#adminName').focus();
                return;
            }

            var loginType = $('#loginType').val();
            if (loginType == 'C' || loginType == '') {
                if ($('#adminPw').val() == '') {
                    ui.alertMsg('<s:message code="admin.msg.enter.pw"/>');
                    $('#adminPw').focus();
                    return;
                }
                if ($('#c_adminPw').val() == '') {
                    ui.alertMsg('<s:message code="admin.msg.enter.cpw"/>');
                    $('#c_adminPw').focus();
                    return;
                }
                if ($('#adminPw').val() != $('#c_adminPw').val()) {
                    ui.alertMsg('<s:message code="admin.msg.diff.pw"/>');
                    $('#c_adminPw').focus();
                    return;
                }
                if ($('#oldPw').val() != $('#adminPw').val()) {
                    if (!validationPassword($('#adminId').val(), $('#adminPw').val(), "")) return;
                }
            }

            if ($('#adminEmail').val() == '') {
                ui.alertMsg('<s:message code="admin.msg.enter.email"/>');
                $('#adminEmail').focus();
                return;
            }

            if (!emailCheck($('#adminEmail').val())) {
                $('#adminEmail').focus();
                return;
            }

            var accessIp = $('#accessIp').val();
            if (accessIp != "" && accessIp != null) {
                var tmpIp = accessIp.split(",");
                if (tmpIp.length > 10) {
                    alert('<s:message code="admin.msg.support.ip"/>');
                    $('#accessIp').focus();
                    return;
                }
                for (var i = 0; i < tmpIp.length; i++) {
                    if (tmpIp[i] == "") continue;
                    if (!checkIP(tmpIp[i])) {
                        ui.alertMsg(tmpIp[i] + '\n' + '<s:message code="admin.msg.wrong.connectip"/>');
                        $('#accessIp').focus();
                        return;
                    }
                    for (var j = 0; j < tmpIp.length; j++) {
                        if (i != j) {
                            if (tmpIp[i] == tmpIp[j]) {
                                ui.alertMsg(tmpIp[i] + '\n' + '<s:message code="userInfo.msg.duplicateip"/>');
                                $('#accessIp').focus();
                                return;
                            }
                        }
                    }
                }

            }
            var adminHp = $('#adminHp').val();
            /* if ( adminHp == '' ) {
                ui.alertMsg( '
            <s:message code="admin.msg.enter.hp"/>');
		$('#adminHp').focus( );
		return;
	} */
            if (!checkPh(adminHp)) {
                ui.alertMsg(adminHp + ' <s:message code="admin.msg.wrong.hp"/>');
                $('#adminHp').focus();
                return;
            }

            var message = mode == 'insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
            //var hiddenAdminType = $('#adminType option:selected').text()
            var hiddenAdminType = $(":input:radio[name=adminType]:checked").val();
            var hiddenUseYn = $(":input:radio[name=useYn]:checked").val();
            var hiddenworkStatus = $(":input:checkbox[name=workStatus]:checked").val();

            $('#adminTypeInfo').val(hiddenAdminType);
            if (hiddenAdminType == 'M') $('#hiddenAdminType').val('<s:message code="admin.msg.monitoring.user"/>');
            else $('#hiddenAdminType').val('<s:message code="admin.msg.system.user"/>');
            if (hiddenUseYn == 'Y') $('#hiddenUseYn').val('<s:message code="common.msg.use"/>');
            else $('#hiddenUseYn').val('<s:message code="common.msg.unuse"/>');
            if (hiddenworkStatus == 'R') $('#hiddenWorkStatus').val('<s:message code="common.msg.retirement"/>');
            else if (hiddenworkStatus == 'O') $('#hiddenWorkStatus').val('<s:message code="common.msg.leave"/>');
            else $('#hiddenWorkStatus').val('');

            var menuList = [];
            $.each($("input[name='chkMenu']:checked"), function () {
                menuList.push($(this).val());
            });
            var hiddenMenu = menuList.join(",");
            $('#menuHidden').val(hiddenMenu);

            if (menuList.length == 0) {
                ui.alertMsg('<s:message code="admin.menuNoSelect.alert"/>');
                return;
            }

            ui.confirmMsg(message, '', '', function (rs) {
                if (rs) {
                    grid.on();
                    var pwd = $('#adminPw').val();
                    if ($('#oldPw').val() != $('#adminPw').val()) {
                        $('#adminPw, #c_adminPw').val(sha256_digest($('#adminPw').val()));
                    }
                    ui.post({
                        url: mode == 'insert' ? 'insertAdmin.xcn' : 'updateAdmin.xcn',
                        data: $('#userPopForm').serializeAll(),
                        success: function (data, total) {
                            $('#adminPop').modal('hide');
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            getData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                            $('#adminPw').val(pwd);
                            $('#c_adminPw').val(pwd);
                        },
                        complete: function () {
                            grid.off();
                        }
                    });
                }
            });
        }

        function checkPh(phone) {
            if (/^((01[1|6|7|8|9])[1-9]+[0-9]{6,7})|(010[1-9][0-9]{7})$/.test(phone) || phone == '')
                return true;
            return false;
        }

        function getAdminCodeList(codeType) {
            ui.get({
                url: 'getAdminCodeList.xcn',
                codeType: codeType,
                adminId: $('#adminId').val(),
                asyncFlag: false,
                success: function (data, total) {
                    var codeName = [];
                    var code = [];
                    $('[name=chkMenu]').prop('checked', false);
                    for (var i = 0; i < data.length; i++) {
                        codeName.push(data[i].codeName);
                        if (codeType != 'menu') code.push(data[i].code);
                        else {
                            $('[name=chkMenu][value=' + data[i].code + ']').prop('checked', true);
                        }
                    }

                    if (codeType != 'menu') {
                        $('#' + codeType + 'Text').val(codeName.join(', ')).prop('disabled', true);
                        $('#' + codeType + 'Hidden').val(code.join('|'));
                    }
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    searchFlag = false;
                    grid.off();
                }
            });
        }

        function getSystemIpMacAll(type) {
            var options = '';
            ui.get({
                url: 'getAllIpMacList.xcn',
                success: function (data, total) {
                    for (var i = 0; i < data.length; i++) {
                        if (type == "L") $('#systemIp' + (i + 1)).val(data[i].accessIp);
                        else if (type == "S") options += '<option value="' + data[i].accessIp + '">' + data[i].accessIp + '</option>';
                    }
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    if (type == "S" && $('#accessIp').prop("tagName").toLowerCase() != "select") {
                        $('#accessIp').replaceWith('<select id="accessIp" name="accessIp" class="selectpicker" data-style="btn-default">' + options + '</select>');
                        $('#accessIp').selectpicker({
                            container: 'body',
                            width: '250px',
                            size: 10
                        })
                        $("#accessIp").selectpicker('refresh');
                    }
                }
            });
        }

        function insertSystemIpMac() {
            var systemIp1 = $('#systemIp1').val();
            var systemIp2 = $('#systemIp2').val();
            if (systemIp1 == '' && systemIp2 == '') {
                ui.alertMsg('<s:message code="deviceInfo.msg.enter.ip"/>');
                $('#systemIp1').focus();
                return;
            }
            if (systemIp1 != "" && !checkIP(systemIp1)) {
                ui.alertMsg(systemIp1 + '\n' + '<s:message code="interest.message.ip.wrong"/>');
                $('#systemIp1').focus();
                return;
            }
            if (systemIp2 != "" && !checkIP(systemIp2)) {
                ui.alertMsg(systemIp2 + '\n' + '<s:message code="interest.message.ip.wrong"/>');
                $('#systemIp2').focus();
                return;
            }

            ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function (rs) {
                if (rs) {
                    ui.get({
                        url: 'insertSystemIpMac.xcn',
                        systemIp1: systemIp1,
                        systemIp2: systemIp2,
                        success: function (data, total) {
                            $('#ipMacPop').modal('hide');
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                            $('#systemIp1').val(systemIp1);
                            $('#systemIp2').val(systemIp2);
                        },
                        complete: function () {
                        }
                    });
                }
            });
        }
	</script>
</head>
<div class="modal" id="adminPop">
	<div class="modal-content" style="width: 1230px;">
		<form method="post" id="userPopForm">
			<div class="modalHead">
				<h2><s:message code="admin.adminpop.title"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="admin.adminpop.title"/></h3>
					<p>
					<%--	<span class="red_dot veralign_middle"></span>--%>
					<%--	<s:message code="common.required.msg"/>--%>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-50">
							<span style="font-size: 25px;"><s:message code="admin.basic.info"/></span>
							<br><br>
							<div class="row">
								<div class="col-35">
									<label for="adminId" class="fname"><s:message code="common.msg.id"/></label>
								</div>
								<div class="col-65">
									<input type="text" class="w100" name="adminId" id="adminId" placeholder="<s:message code="common.msg.id"/>" maxlength="10">
								</div>
							</div>
							<div class="row">
								<div class="col-35">
									<label for="adminName" class="fname"><s:message code="common.msg.name"/></label>
								</div>
								<div class="col-65">
									<input type="text" class="w100" name="adminName" id="adminName" placeholder="<s:message code="common.msg.name"/>" maxlength="50">
								</div>
							</div>
							<div class="row">
								<div class="col-35">
									<label for="adminPw" class="fname"><s:message code="admin.pw"/></label>
								</div>
								<div class="col-65">
									<input type="password" class="w100" name="adminPw" id="adminPw" placeholder="<s:message code="admin.pw"/>" maxlength="128" autocomplete="off">
									<input type="hidden" name="oldPw" id="oldPw">
								</div>
							</div>
							<div class="row">
								<div class="col-35">
									<label for="c_adminPw" class="fname"><s:message code="admin.cpw"/></label>
								</div>
								<div class="col-65">
									<input type="password" class="w100" name="c_adminPw" id="c_adminPw" placeholder="<s:message code="admin.cpw"/>" maxlength="128" autocomplete="off">
								</div>
							</div>
							<div class="row">
								<div class="col-35">
									<label for="adminEmail" class="fname">E-Mail</label>
								</div>
								<div class="col-65">
									<input type="text" class="w100" name="adminEmail" id="adminEmail" placeholder="E-Mail" maxlength="600">
								</div>
							</div>
							<div class="row">
								<div class="col-35">
									<label for="adminHp" class="fname"><s:message code="admin.hp"/></label>
								</div>
								<div class="col-65">
									<input type="text" class="w100" name="adminHp" id="adminHp" placeholder="<s:message code="admin.hp"/>" maxlength="50">
									<label><s:message code="admin.enter.minus"/> <span style="padding-left:15px;"><s:message code="admin.msg.hp"/></span></label>
								</div>
							</div>
							<div class="row">
								<div class="col-35">
									<label for="comment" class="fname"><s:message code="admin.purpose"/></label>
								</div>
								<div class="col-65">
									<input type="text" class="w100" name="comment" id="comment" placeholder="<s:message code="admin.purpose"/>" maxlength="500">
								</div>
							</div>

							<div class="row" id="certTypeDiv">
								<div class="col-35">
									<label for="comment" class="fname"><s:message code="admin.connection.methode"/></label>
								</div>
								<div class="col-65">
									<select class="w100" id="loginType">
										<option value="C" selected><s:message code="admin.system.login"/></option>
										<!--<option value="L">외부 시스템 로그인(LDAP 인증)</option> -->
										<option value="S"><s:message code="admin.outside.login"/></option>
									</select>
								</div>
							</div>

							<div class="row" id="certTypeDiv">
								<div class="col-35">
									<label for="adminType" class="fname"><s:message code="admin.admintype"/></label>
								</div>
								<div class="col-65">
									<label class="radio-inline c-radio">
										<input type="radio" name="adminType" class="adminType" value="M">
										<s:message code="admin.monitoring.admin"/>
									</label>
									<label class="radio-inline c-radio">
										<input type="radio" name="adminType" class="adminType adminTypeSys" value="S">
										<s:message code="admin.system.admin"/>
									</label>
									<label class="radio-inline c-radio">
										<input type="radio" name="adminType" class="adminType" value="C">
										CEO <s:message code="admin.monitoring.admin"/>
									</label>
									<label class="radio-inline c-radio">
										<input type="radio" name="adminTypeS" class="adminTypeS" value="" checked="checked">
										<s:message code="admin.chief.admin"/>
									</label>
									<input type="hidden" name="adminTypeNm" id="hiddenAdminType">
									<input type="hidden" name="adminTypeInfo" id="adminTypeInfo">
								</div>
							</div>
							<div class="row">
								<div class="col-35">
									<label for="workStatus" class="fname"><s:message code="common.msg.retirement"/>/<s:message code="common.msg.leave"/></label>
								</div>
								<div class="col-65">
									<label class="checkbox-inline " style="padding-left: 0px;">
										<input type="checkbox" name="workStatus" value="R">
										<s:message code="common.msg.retirement"/>
									</label>
									<label class="checkbox-inline " style="padding-left: 0px;">
										<input type="checkbox" name="workStatus" value="O">
										<s:message code="common.msg.leave"/>
									</label>
									<input type="hidden" name="workStatusNm" id="hiddenWorkStatus">
								</div>
							</div>

							<div class="row">
								<div class="col-35">
									<label for="useYn" class="fname"><s:message code="common.msg.useyn"/></label>
								</div>
								<div class="col-65">
									<label class="radio-inline c-radio">
										<input type="radio" name="useYn" value="Y" checked>
										<s:message code="common.msg.use"/>
									</label>
									<label class="radio-inline c-radio">
										<input type="radio" name="useYn" value="N">
										<s:message code="common.msg.unuse"/>
									</label>
									<input type="hidden" name="useYnNm" id="hiddenUseYn">
								</div>
							</div>

							<br>
							<span style="font-size: 25px;"><s:message code="admin.access.control"/></span><br>
							<br>
							<div class="row">
								<div class="col-35">
									<label for="accessIp" class="fname"><s:message code="admin.connect.ip"/></label>
								</div>
								<div class="col-65">
									<input type="text" class="w100" name="accessIp" id="accessIp" placeholder="<s:message code="userInfo.msg.ip"/>">
									<%if (isIPv6) { %>
									<p style="padding-left:190px; margin-bottom: 0px;">
										<span style='color:grey;'>[ex: IPv4 - 192.168.0.12 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IPv6 - 2002:9b3d:1a32:4:208:74ff:fe39:6c43]</span>
									</p>
									<%} %>
									<button type="button" class="btn btn-primary" accesskey="I" id="selIpBtn" style="display:none;"><s:message code="common.msg.select"/></button>
								</div>
							</div>

							<div class="otpRowDiv" style="display: none">
							<%--OTP재설정--%>
							<br>
							<span style="font-size: 25px;"><s:message code="common.msg.otpReset"/></span>
							<br><br>
							<div class="row">
								<div class="col-35">
									<label for="accessIp" class="fname"><s:message code="common.msg.otpReset"/></label>
								</div>
								<div class="col-65">
									<button type="button" class="form_btn01_02" accesskey="I" id="otpResetBtn"><s:message code="common.msg.otpReset"/></button>
								</div>
							</div>
						</div>
						</div>
						<div class="col-50 mal16">
							<span style="font-size: 25px;"><s:message code="admin.search.auth"/></span>
							<br><br>

							<div class="row">
								<div class="col-35">
									<label for="coCd" class="fname"><s:message code="common.org.co"/></label>
								</div>
								<div class="col-65">
									<button type="button" class="form_btn03 selBtn btn-sm" accesskey="O" id="co">
										<s:message code="common.msg.select"/></button>
									<!-- <span style="display: inline-block; height: 20px; position: relative; top: 7px;" class="ellipsis" id="coText"></span> -->
									<input type="text" id="coText" name="coText" style="border: 0px; background-color: transparent;" disabled="disabled"/>
									<input type="hidden" name="coCd" id="coHidden"/>
									<input type="hidden" name="oldCode" id="oldCode"/>
									<input type="hidden" name="oldConm" id="oldConm"/>
								</div>
							</div>

							<div class="row">
								<div class="col-35">
									<label for="busiCd" class="fname"><s:message code="common.org.busi"/></label>
								</div>
								<div class="col-65">
									<button type="button" class="form_btn03 selBtn btn-sm" id="busi" disabled="disabled"><s:message code="common.msg.select"/></button>
									<!-- <span style="display: inline-block; height: 20px; position: relative; top: 7px;" class="ellipsis" id="busiText"></span> -->
									<input type="text" id="busiText" name="busiText" style="border: 0px; background-color: transparent;" disabled="disabled"/>
									<input type="hidden" name="busiCd" id="busiHidden"/>
								</div>
							</div>
							<!--  부서권한
								<div >
									<label for="deptCd" class=" col-xs-4"><s:message code="common.org.dept"/></label>
									<button type="button" class="btn btn-primary selBtn btn-sm" id="dept" disabled="disabled"><s:message code="common.msg.select"/></button>
									<input type="text" id="deptText" name="deptText" class="ellipsis" style="border: 0px; background-color: #fff;" disabled="disabled" />
									<input type="hidden" name="deptCd" id="deptHidden" />
								</div>
								 -->
							<div class="row">
								<div class="col-35">
									<label for="serviceType" class="fname"><s:message code="filterInfo.servicetype"/></label>
								</div>
								<div class="col-65">
									<button type="button" class="form_btn03 selBtn btn-sm" accesskey="T" id="service">
										<s:message code="common.msg.select"/></button>
									<!-- <span style="display: inline-block; height: 20px; position: relative; top: 7px;" class="ellipsis" id="svcText"></span> -->
									<input type="text" id="serviceText" name="serviceText" style="border: 0px; background-color: transparent;" disabled="disabled"/>
									<input type="hidden" name="service" id="serviceHidden"/>
								</div>
							</div>

							<div class="row">
								<div class="col-35">
									<label for="personalInfo" class="fname"><s:message code="common.msg.regexp"/></label>
								</div>
								<div class="col-65">
									<button type="button" class="form_btn03 selBtn btn-sm" accesskey="P" id="regexp">
										<s:message code="common.msg.select"/></button>
									<!-- <span style="display: inline-block; height: 20px; position: relative; top: 7px;" class="ellipsis" id="patternText"></span> -->
									<input type="text" id="regexpText" name="regexpText" style="border: 0px; background-color: transparent;" disabled="disabled"/>
									<input type="hidden" name="regexp" id="regexpHidden"/>
								</div>
							</div>

							<div class="row" id="readAuthDiv">
								<div class="col-35">
									<label for="personalInfo" class="fname"><s:message code="userGroup.navi.title2"/></label>
								</div>
								<div class="col-65">
									<button type="button" class="form_btn03 selBtn btn-sm" accesskey="R" id="readAuth">
										<s:message code="common.msg.select"/></button>
									<input type="text" id="readAuthText" name="readAuthText" class="ellipsis" style="border: 0px; background-color: transparent;" disabled="disabled"/>
									<input type="hidden" name="readAuth" id="readAuthHidden"/>
								</div>
							</div>

							<div class="row" style="border-bottom: none;">
								<div class="col-65">
									<label for="chkMenu" class="fname"><s:message code="OPERATION_MGMT.BODY_VIEW"/>
										<button class="btn btn-secondary btn-xs" type="button" accesskey="B" id="selAllBodyBtn" style="margin:1px; border: 1px solid #ccc;"><s:message code="common.msg.select_all"/></button>
										<button class="btn btn-secondary btn-xs" type="button" accesskey="C" id="resetAllBodyBtn" style="margin:1px; border: 1px solid #ccc;"><s:message code="common.msg.unselect_all"/></button>

								</div>
								<div id="divBodyChk" class="col-65" style="border: 1px solid #e5e5e5; margin-left: 15px; padding: 15px; display: inline-block; width: 95%;">
									<label class="checkbox-inline " style="padding-left: 0px;">
										<input type="checkbox" name="chkMenu" value="DV" checked>
										<s:message code="common.msg.search"/>
									</label>
									<label class="checkbox-inline " style="padding-left: 0px;">
										<input type="checkbox" name="chkMenu" value="DS" checked>
										<s:message code="common.msg.save"/>
									</label>
									<label class="checkbox-inline " style="padding-left: 0px;">
										<input type="checkbox" name="chkMenu" value="DF" checked>
										<s:message code="common.msg.forward_mail"/>
									</label>
									<label class="checkbox-inline " style="padding-left: 0px;">
										<input type="checkbox" name="chkMenu" value="DP" checked>
										<s:message code="common.msg.print"/>
									</label>
									<input type="hidden" name="menu" id="menuHidden"/>
								</div>
							</div>

							<div class="row">
								<div class="col-65">
									<label for="menuInfo" class="fname"><s:message code="DATA_MONITOR.MESSAGE"/> <s:message code="common.msg.export"/>
										<button class="btn btn-secondary btn-xs" type="button" accesskey="E" id="selAllExpBtn" style="margin:1px; border: 1px solid #ccc;"><s:message code="common.msg.select_all"/></button>
										<button class="btn btn-secondary btn-xs" type="button" accesskey="F" id="resetAllExpBtn" style="margin:1px; border: 1px solid #ccc;"><s:message code="common.msg.unselect_all"/></button>
									</label>
								</div>
								<div id="divExpChk" class="col-65" style="border: 1px solid #e5e5e5; margin-left: 15px; padding: 15px; display: inline-block; width: 95%;">
									<label class="checkbox-inline " style="padding: 2px 0px;"><input type="checkbox" name="chkMenu" value="LS" checked><s:message code="selectCodeAll.list"/></label>
									<label class="checkbox-inline " style="padding: 2px 0px;"><input type="checkbox" name="chkMenu" value="BS" checked><s:message code="condition.body"/></label>
									<label class="checkbox-inline " style="padding: 2px 0px;"><input type="checkbox" name="chkMenu" value="AS" checked><s:message code="consent.attach"/></label>
									<label class="checkbox-inline " style="padding: 2px 0px;"><input type="checkbox" name="chkMenu" value="WS" checked><s:message code="selectCodeAll.list"/>+<s:message code="condition.body"/></label>
									<br>
									<label class="checkbox-inline " style="padding: 2px 0px;">
										<input type="checkbox" name="chkMenu" value="CS" checked>
										<s:message code="selectCodeAll.list"/>+<s:message code="condition.body"/>+<s:message code="consent.attach"/>
									</label>
									<label class="checkbox-inline " style="padding: 2px 0px;">
										<input type="checkbox" name="chkMenu" value="LP" checked>
										<s:message code="selectCodeAll.list"/>
										<s:message code="common.msg.print"/>
									</label>
								</div>
							</div>

							<div class="row">
								<div class="col-35">
									<label for="approbator" class="fname"><s:message code="admin.consent.apply"/></label>
								</div>
								<div class="col-65">
									<label class="radio-inline c-radio">
										<input type="radio" name="approbator" value="N" checked>
										<s:message code="admin.normal.admin"/>
									</label>
									<label class="radio-inline c-radio">
										<input type="radio" name="approbator" value="A">
										<s:message code="admin.apply.user"/>
									</label>
									<input type="hidden" name="approbatorNm" id="hiddenApprobator">
								</div>
							</div>

							<div class="row">
								<div class="col-35">
									<label for="infoFeedbackYn" class="fname"><s:message code="condition.infotype"/>/<s:message code="condition.feedback"/></label>
								</div>
								<div class="col-65">
									<label class="radio-inline c-radio">
										<input type="radio" name="infoFeedbackYn" value="Y">
										<s:message code="common.msg.use"/>
									</label>
									<label class="radio-inline c-radio">
										<input type="radio" name="infoFeedbackYn" value="N" checked>
										<s:message code="common.msg.unuse"/>
									</label>
								</div>

							</div>
							<div class="info" style="background-color: transparent">
								<s:message code="common.guidance"/>
								<div id="msgAuthComment" class="form-inline">
									<div style="padding-left: 15px;"><s:message code="admin.add.msgAuthComment"/></div>
								</div>
								<div id="infoFeedbackComment" class="form-inline">
									<div style="padding-left: 15px;"><s:message code="admin.add.buy"/></div>
								</div>
							</div>
						</div>

					</div>
					<div class="modalfooter">
						<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
						<button type="button" class="pop_btn02 savePopBtn" accesskey="S" id="savePopBtn"><s:message code="common.msg.save"/></button>
					</div>
				</div>
			</div>

		</form>
	</div>
</div>

<div class="modal" id="statusPop">
	<div class="modal-content">
		<form method="post" id="statusPopForm">
			<div class="modalHead">
				<h2><s:message code="admin.statuspop.title"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3>운용자 - 상태 수정</h3>
				</div>
				<div class="modalbody">
					<div class="form-inline">
						<s:message code="admin.message.longterm"/>
						<br/><br/>
						<span style="font-size: 12px;">
							※ <s:message code="admin.message.limit"/>
							<br/>
							※ <s:message code="admin.message.limit.again"/>
						</span>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="applyPopBtn"><s:message code="common.msg.apply"/></button>
				</div>
			</div>
		</form>
	</div>
</div>


<div class="modal" id="ipMacPop" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="ipMacPopForm">
			<div class="modalHead">
				<h2>SYSTEM IP <s:message code="SETTINGS.MENU"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3>SYSTEM IP <s:message code="SETTINGS.MENU"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						필수 입력 사항입니다.
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="systemIp1" class="fname">IP</label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="systemIp1" id="systemIp1" placeholder="<s:message code="admin.msg.enter.ip"/>">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="systemIp2" class="fname">IP</label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="systemIp2" id="systemIp2" placeholder="<s:message code="admin.msg.enter.ip"/>">
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="saveIpMacPopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>


<div>
	<div class="searchArea">
		<div class="searchSub">
			<div>
				<select id="useYnSelect" style="float: left;">
					<option value="">- <s:message code="common.msg.useyn"/> -</option>
					<option value="Y" selected><s:message code="common.msg.use"/></option>
					<option value="N"><s:message code="common.msg.unuse"/></option>
				</select>
			</div>
			<div>
				<input type="text" placeholder="<s:message code="admin.msg.idname"/>" id="searchStr" style="width: 250px;">
				<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.search"/></button>
				<button type="button" class="btn01" accesskey="I" id="insertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/>
				</button>
			</div>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					<s:message code="admin.navi.title2"/> <s:message code="dashboardSetup.dashtype.list"/>
					<span id="adminCount"></span>
				</button>
			</div>
			<div id="adminListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
    var grid = new Xgrid('adminListGrid', contextRoot);
    grid.autoNumber();
    grid.colAdd('workStatus', '<s:message code="common.msg.retirement"/>/<s:message code="common.msg.leave"/>', 90, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'R') return '<s:message code="common.msg.retirement"/>';
        else if (value == 'O') return '<s:message code="common.msg.leave"/>';
        else return '';
    });
    grid.colAdd('adminId', '<s:message code="common.msg.id"/>', 130, 'left', false, 'link');
    grid.colAdd('adminName', '<s:message code="common.msg.name"/>', 130, 'left', false, 'nomal');
    grid.colAdd('adminType', '<s:message code="common.msg.type"/>', 130, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'S') return '<s:message code="admin.system.admin"/>';
        else if (value == 'C') return 'CEO <s:message code="admin.monitoring.admin"/>';
        else return '<s:message code="admin.monitoring.admin"/>';
    });
    grid.colAdd('adminEmail', 'E-mail', 180, 'left', false, 'nomal');
    grid.colAdd('adminHp', 'HP', 150, 'left', false, 'nomal');
    grid.colAdd('useYn', '<s:message code="common.msg.useyn"/>', 100, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'Y') return '<s:message code="common.msg.use"/>';
        else if (value == 'N') return '<s:message code="common.msg.unuse"/>';
        return '-';
    });
    grid.colAdd('accessIp', 'IP', 150, 'left', true, 'nomal');
    grid.colAdd('lastLoginDt', '<s:message code="admin.last.login"/>', 150, 'center', false, 'nomal');
    grid.colAdd('comment', '<s:message code="admin.purpose"/>', 250, 'left', false, 'nomal');
    grid.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 150, 'center', false, 'nomal');
    grid.colAdd('status', '<s:message code="admin.reference"/>', 150, 'left', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value == 'L') return '<s:message code="admin.msg.longterm"/>';
        return '';
    });

    grid.loadExportMenu('<s:message code="admin.navi.title2"/>');
    grid.loadHeader(true);
    grid.initData('<s:message code="common.msg.search.click"/>');
    grid.onClick = function () {
        if (grid.Col == grid.ColIndex('adminId')) {


            $("#adminPop").modal('show');
            $('#adminPop').attr('mode', 'modify');

            if (googleOtp == "false") $('.otpRowDiv').css('display', 'none');
            else $('.otpRowDiv').css('display', '');

            var data = grid.getRowData(grid.Row);

            if (data.adminType == "C") {
                $("#readAuthDiv").css('display', '');
            } else {
                $("#readAuthDiv").css('display', 'none');
            }


            //setTimeout(function(){
            $('#adminId').val(data.adminId).prop('disabled', true);
            $('#adminName').val(data.adminName);
            $('#adminPw').val(data.adminPw);
            $('#c_adminPw').val(data.adminPw);
            $('#adminEmail').val(data.adminEmail);
            $('#adminHp').val(data.adminHp);
            $('#accessIp').val(data.accessIp);
            $('#comment').val(data.comment);
            $('#loginType').val(data.loginType);
            $('#oldPw').val($('#adminPw').val());
            $('[name=adminType][value=' + data.adminType + ']').prop('checked', true);
            $('[name=approbator][value=' + data.approbator + ']').prop('checked', true);
            $('[name=infoFeedbackYn][value=' + data.infoFeedbackYn + ']').prop('checked', true);
            $('[name=useYn][value=' + data.useYn + ']').prop('checked', true);
            $('[name=workStatus]').prop('checked', false);
            $('[name=workStatus][value=' + data.workStatus + ']').prop('checked', true);
            getAdminCodeList('co');
            getAdminCodeList('busi');
            //getAdminCodeList('dept'); 부서권한
            getAdminCodeList('service');
            getAdminCodeList('regexp');
            getAdminCodeList('readAuth');
            getAdminCodeList('menu');
            if (data.firstAdminYn == 'Y') $('[name=chkMenu]').prop('checked', true);

            $('#admin_normal').hide();
            $('#admin_system').hide();
            if (firstAdminYn == 'Y' && data.firstAdminYn == 'Y') {
                $('.adminType').parent().css('display', 'none');
                $('.adminTypeS').parent().css('display', '');
                $('.adminType').parent().next().css('margin-left', '0');
                $('[name=chkMenu]').prop('disabled', true);
                $('#selAllBodyBtn, #resetAllBodyBtn, #selAllExpBtn, #resetAllExpBtn').prop('disabled', true);
            } else if (firstAdminYn == 'Y' && data.firstAdminYn == 'N') {
                $('.adminType').parent().css('display', '');
                $('.adminTypeS').parent().css('display', 'none');
                $('[name=chkMenu]').prop('disabled', false);
                $('#selAllBodyBtn, #resetAllBodyBtn, #selAllExpBtn, #resetAllExpBtn').prop('disabled', false);
            } else {
                $('.adminType').parent().css('display', '');
                $('.adminTypeS').parent().css('display', 'none');
                $('.adminType, .adminTypeS').prop('disabled', true);
                $('.adminType').parent().next().css('margin-left', '10');
                $('[name=chkMenu]').prop('disabled', false);
                $('#selAllBodyBtn, #resetAllBodyBtn, #selAllExpBtn, #resetAllExpBtn').prop('disabled', false);
            }

            if (data.loginType == 'L') {
                $('#loginType').prop('disabled', false);
                $('#adminPw').prop('disabled', true);
                $('#c_adminPw').prop('disabled', true);
            } else if (data.loginType == 'S') {
                $('#loginType').prop('disabled', true);
                $('#adminPw').prop('disabled', true);
                $('#c_adminPw').prop('disabled', true);
            } else {
                $('#loginType').prop('disabled', true);
                $('#adminPw').prop('disabled', false);
                $('#c_adminPw').prop('disabled', false);
            }

            //busiDeptBtnControl();
            busiBtnControl();
        } else if (grid.Col == grid.ColIndex('status')) {
            if (grid.getValue(grid.Row, grid.ColIndex('status')) == 'L') $("#statusPop").modal('show');
        }
    };
</script>
