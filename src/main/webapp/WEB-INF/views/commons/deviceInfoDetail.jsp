<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<%
	String deviceSeq = Common.nvl(request.getParameter("deviceSeq"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title><s:message code="deviceInfo.title"/></title>
	<link rel="stylesheet" href="<c:url value="/css/slider.css"/>"/>
	<link rel="stylesheet" href="<c:url value="/css/jquery.circliful.css"/>">
	<link rel="stylesheet" href="<c:url value="/css/bootstrap-select.min.css"/>"/>

	<script type="text/javascript" src="<c:url value="/js/bootstrap-slider.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/jquery.circliful.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/bootstrap-select.js"/>"></script>


	<style type="text/css">
		.bootstrap-select .inner {
			-moz-transform: none;
		}

		.progress {
			padding-left: 0px;
		}

		.progress-bar {
			text-align: left;
			padding-left: 10px;
		}

		.glyphicon-hdd {
			font-size: 20px;
		}

		.fsImg {
			width: 30px;
		}

		#alarmCri .slider-selection {
			background: #5cb85c;
		}

		#saturationCri .slider-selection {
			background: #f0ad4e;
		}

		#deleteCri .slider-selection {
			background: #729fcf;
		}

		#alarmLv1Text, #saturationLv1Text, #alarmLvText {
			font-weight: bold;
			font-size: 14px;
		}

		table th {
			background-color: #eee;
			text-align: center;
		}

		.memoryTbl td {
			text-align: center;
		}

		.process_normal {
		}

		.process_none {
			color: #FD9C44;
			font-weight: bold;
		}

		.process_warn {
			color: #BE7533;
			font-weight: bold;
		}

		.interface_warn {
			color: #BE7533;
			font-weight: bold;
		}

		.c-checkbox input[type=checkbox]:checked + span {
			background-color: #be7533;
		}

		.bootstrap-select .btn {
			padding: 4px 12px;
		}

		.dropdown-menu > li > a:focus, .dropdown-menu > li > a:hover {
			background-color: rgba(51, 122, 183, 1);
			color: white;
		}

		.panel-heading {
			height: 30px;
			line-height: 28px;
		}

	</style>
	<script type="text/javascript">
        var circlifulOption = {
            animation: 1,
            animationStep: 10,
            foregroundBorderWidth: 3,
            backgroundBorderWidth: 3,
            foregroundColor: '#23B7E5',
            backgroundColor: '#EEF3F7',
            percent: 0,
            textSize: 28,
            pointSize: 10,
            textStyle: 'font-size: 12px;',
            textColor: '#9D9EA0',
            multiPercentage: 1
        };
        var param_deviceSeq = '<%=deviceSeq%>';
        $(document).ready(function () {

            $(document).on('click', '.nav-tabs a', function () {
                getDeviceInfo();
            });

            $('#reflashBtn').click(function () {
                $('#hddInfoTable').children().each(function () {
                    $(this).children().remove();
                });
                getDeviceInfo();
            });

            //장비 목록으로 버튼
            $('#returnListBtn').click(function () {
                location.href = '<c:url value="/commons/deviceInfo.do"/>';
            });


            $('#deviceSelect').selectpicker({
                width: '300px',
                size: 10,
                noneSelectedText: '<s:message code="common.msg.all"/>'
            }).change(function () {
                getDeviceInfo();
            });

            $("#cpuLoadUsage").circliful(circlifulOption);
            $("#memInfoUsage").circliful(circlifulOption);

            //장비 추가
            $('#insertBtn').click(function () {
                $('#deviceAddPop').attr('mode', 'insert');
                $('#deviceAddPop').modal('show');
                $('#deviceIp, #deviceNm, #comment, #sshId, #sshPw').val('');
                $('input:radio[name=deviceType]:input[value=A]').prop("checked", true);
                $('input:radio[name=deviceType]').prop("disabled", false);
            });


            $('#sms_file').click(function () {
                var confId = 'device.hdd.sms.' + $('#deviceSelect').selectpicker('val');
                saveAlarmCheck(confId, $(this).prop('checked'));
            });
            $('#notify_file').click(function () {
                var confId = 'device.hdd.notify.' + $('#deviceSelect').selectpicker('val');
                saveAlarmCheck(confId, $(this).prop('checked'));
            });
            $('#sms_file_cpu').click(function () {
                var confId = 'device.cpu.sms.' + $('#deviceSelect').selectpicker('val');
                saveAlarmCheck(confId, $(this).prop('checked'));
            });
            $('#notify_file_cpu').click(function () {
                var confId = 'device.cpu.notify.' + $('#deviceSelect').selectpicker('val');
                saveAlarmCheck(confId, $(this).prop('checked'));
            });
            $('#sms_file_mem').click(function () {
                var confId = 'device.mem.sms.' + $('#deviceSelect').selectpicker('val');
                saveAlarmCheck(confId, $(this).prop('checked'));
            });
            $('#notify_file_mem').click(function () {
                var confId = 'device.mem.notify.' + $('#deviceSelect').selectpicker('val');
                saveAlarmCheck(confId, $(this).prop('checked'));
            });
            $('#sms_proc').click(function(){
                var confId = 'device.process.sms.'+ $('#deviceSelect').selectpicker('val');
                saveAlarmCheck(confId, $(this).prop('checked'));
            });
            $('#notify_proc').click(function(){
                var confId = 'device.process.notify.'+ $('#deviceSelect').selectpicker('val');
                saveAlarmCheck(confId, $(this).prop('checked'));
            });
            $('#sms_inter').click(function () {
                var confId = 'device.interface.sms.' + $('#deviceSelect').selectpicker('val');
                saveAlarmCheck(confId, $(this).prop('checked'));
            });
            $('#notify_inter').click(function () {
                var confId = 'device.interface.notify.' + $('#deviceSelect').selectpicker('val');
                saveAlarmCheck(confId, $(this).prop('checked'));
            });

            $('.savePopBtn').click(function () {
                if (!checkIP($('#deviceIp').val())) {
                    ui.alertMsg('<s:message code="deviceInfo.msg.ip.wrong"/>');
                    $('#accessIp').focus();
                    return;
                }
                if ($('#deviceIp').val() == '') {
                    ui.alertMsg('<s:message code="deviceInfo.msg.enter.ip"/>');
                    $('#accessIp').focus();
                    return;
                }
                if ($('#deviceNm').val() == '') {
                    ui.alertMsg('<s:message code="deviceInfo.msg.enter.devname"/>');
                    $('#deviceNm').focus();
                    return;
                }
                if ($('#sshId').val() == '') {
                    ui.alertMsg('<s:message code="deviceInfo.msg.enter.devid"/>');
                    $('#sshId').focus();
                    return;
                }
                if ($('#sshPw').val() == '') {
                    ui.alertMsg('<s:message code="deviceInfo.msg.enter.devpw"/>');
                    $('#sshPw').focus();
                    return;
                }

                var id = $('#deviceAddPop').attr('mode');
                if (id == 'insert') insertDevice();
                else if (id == 'modify') modifyDevice();
            });


            //장비 삭제
            $('#deleteBtn').click(function () {
                var deviceSeq = $('#deviceSelect').selectpicker('val');
                $('.deleteBtn').prop('disabled', true);
                ui.confirmMsg('<s:message code="deviceInfo.msg.confirm.deletedev"/>', '', '', function (rs) {
                    if (rs) {
                        ui.get({
                            url: 'deleteDevice.xcn',
                            deviceSeq: deviceSeq,
                            deviceNm: $('#tblDeviceNm').text(),
                            success: function (data, total) {
                                ui.alertMsg('<s:message code="common.msg.deleted"/>');
                                $('#tblDeviceIp').html('');
                                $('#tblDeviceNm').html('');
                                $('#tblDeviceType').html('');
                                $('#tblDeviceType').attr('type', '');
                                $('#tblComment').html('');
                                $('#tblCreatDt').html('');
                                $('#tblSshId').html('');
                                $('#tblSshPw').html('');

                                noConnectionDevice();
                                getDevice();
                            },
                            error: function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete: function () {
                                $('.deleteBtn').prop('disabled', false);
                            }
                        });
                    } else {
                        $('.deleteBtn').prop('disabled', false);
                    }
                });
            });

            $('#modifyBtn').click(function () {
                $('#deviceAddPop').attr('mode', 'modify');
                $('#deviceAddPop').modal('show');

                $('#deviceIp').val($('#tblDeviceIp').text());
                $('#deviceNm').val($('#tblDeviceNm').text());
                $('#comment').val($('#tblComment').text());

                var type = $('#tblDeviceType').attr('type');

                $('input:radio[name=deviceType]:input[value=' + type + ']').prop("checked", true);
                $('input:radio[name=deviceType]').prop("disabled", true);

                $('#sshId').val($('#tblSshId').text());
                $('#sshPw').val($('#tblSshPw').text());
            });

            $(document).on('click', '.alertChangeCpu', function () {
                $('#alertChangeCpuPop').attr('mode', 'insert');
                $('#alertChangeCpuPop').attr('idx', $('.alertChangeCpu').index(this));
                $('#alertChangeCpuPop').attr('cpuLoadLimit', $(this).attr('cpuLoadLimit'));
                $('#alertChangeCpuPop').modal('show');
            });

            $("#alertChangeCpuPop").on('shown.bs.modal', function () {
                $('#alarmCpuLv2Critical').slider('setValue', $(this).attr('cpuLoadLimit'));

                $('#alarmCpuLv2Text').html($(this).attr('cpuLoadLimit'));
                if ($(this).attr('cpuLoadLimit') == '0') {
                    $('#alarmCpuUsed').prop('checked', false);
                    $('#alarmCpuModal').show();

                } else {
                    $('#alarmCpuUsed').prop('checked', true);
                    $('#alarmCpuModal').hide();
                }
                console.log("2")
                console.log($(this).attr('cpuLoadLimit'))
            });

            $(document).on('click', '.alertChangeMemory', function () {
                $('#alertChangeMemoryPop').attr('mode', 'insert');
                $('#alertChangeMemoryPop').attr('idx', $('.alertChangeMemory').index(this));
                $('#alertChangeMemoryPop').attr('memInfoLimit', $(this).attr('memInfoLimit'));
                $('#alertChangeMemoryPop').modal('show');
            });


            $("#alertChangePop").on('shown.bs.modal', function () {
                $('#alarmLv1Critical').slider('setValue', $(this).attr('hddNotifyLimit'));
                $('#alarmLv2Critical').slider('setValue', $(this).attr('hddWarnLimit'));
                $('#alarmLv3Critical').slider('setValue', $(this).attr('hddAlarmLimit'));

                $('#alarmLv1Text').html($(this).attr('hddNotifyLimit'));
                $('#alarmLv2Text').html($(this).attr('hddWarnLimit'));
                $('#alarmLv3Text').html($(this).attr('hddAlarmLimit'));
                if ($(this).attr('hddNotifyLimit') == '0' && $(this).attr('hddWarnLimit') == '0' && $(this).attr('hddAlarmLimit') == '0') {
                    $('#alarmUsed').prop('checked', false);
                    $('#alarmModal').show();

                } else {
                    $('#alarmUsed').prop('checked', true);
                    $('#alarmModal').hide();
                }
            });



            $("#alertChangeMemoryPop").on('shown.bs.modal', function () {
                $('#alarmMemoryLv2Critical').slider('setValue', $(this).attr('memInfoLimit'));

                $('#alarmMemoryLv2Text').html($(this).attr('memInfoLimit'));
                if ($(this).attr('memInfoLimit') == '0') {
                    $('#alarmMemoryUsed').prop('checked', false);
                    $('#alarmMemoryModal').show();

                } else {
                    $('#alarmMemoryUsed').prop('checked', true);
                    $('#alarmMemoryModal').hide();
                }
            });


            //임계치 설정 사용 체크박스
            $('#alarmUsed').click(function () {
                var checked = $('#alarmUsed:checked').length;
                if (checked == 0) {
                    $('#alarmModal').show();
                } else {
                    $('#alarmModal').hide();
                }

                var lv1 = $('#alarmLv1Text').text();
                var lv2 = $('#alarmLv2Text').text();
                var lv3 = $('#alarmLv3Text').text();
                if (lv1 == 0 && lv2 == 0 && lv3 == 0) {
                    $('#alarmLv1Text').html('1');
                    $('#alarmLv2Text').html('1');
                    $('#alarmLv3Text').html('1');
                }

            });

            $(document).on('click', '.alertChange', function () {
                $('#alertChangePop').attr('mode', 'insert');
                $('#alertChangePop').attr('idx', $('.alertChange').index(this));
                $('#alertChangePop').attr('hddNotifyLimit', $(this).attr('hddNotifyLimit'));
                $('#alertChangePop').attr('hddWarnLimit', $(this).attr('hddWarnLimit'));
                $('#alertChangePop').attr('hddAlarmLimit', $(this).attr('hddAlarmLimit'));
                $('#alertChangePop').modal('show');
            });
            $('#alarmLv1Critical').slider().on('slide', function (ev) {
                $('#alarmLv1Text').text(ev.value);
            });
            $('#alarmLv2Critical').slider().on('slide', function (ev) {
                $('#alarmLv2Text').text(ev.value);
            });
            $('#alarmCpuLv2Critical').slider().on('slide', function (ev) {
                $('#alarmCpuLv2Text').text(ev.value);
            });
            $('#alarmMemoryLv2Critical').slider().on('slide', function (ev) {
                $('#alarmMemoryLv2Text').text(ev.value);
            });
            $('#alarmLv3Critical').slider().on('slide', function (ev) {
                $('#alarmLv3Text').text(ev.value);
            });


            //임계치 설정 사용 체크박스
            $('#alarmUsed').click(function () {
                var checked = $('#alarmUsed:checked').length;
                if (checked == 0) {
                    $('#alarmModal').show();
                } else {
                    $('#alarmModal').hide();
                }

                var lv1 = $('#alarmLv1Text').text();
                var lv2 = $('#alarmLv2Text').text();
                var lv3 = $('#alarmLv3Text').text();
                if (lv1 == 0 && lv2 == 0 && lv3 == 0) {
                    $('#alarmLv1Text').html('1');
                    $('#alarmLv2Text').html('1');
                    $('#alarmLv3Text').html('1');
                }

            });

            $('#alarmCpuUsed').click(function () {
                var checked = $('#alarmCpuUsed:checked').length;
                if (checked == 0) {
                    $('#alarmCpuModal').show();
                } else {
                    $('#alarmCpuModal').hide();
                }

                var lv2 = $('#alarmCpuLv2Text').text();
                if (lv2 == 0) {
                    $('#alarmCpuLv2Text').html('1');
                }
            });

            $('#alarmMemoryUsed').click(function () {
                var checked = $('#alarmMemoryUsed:checked').length;
                if (checked == 0) {
                    $('#alarmMemoryModal').show();
                } else {
                    $('#alarmMemoryModal').hide();
                }

                var lv2 = $('#alarmMemoryLv2Text').text();
                if (lv2 == 0) {
                    $('#alarmMemoryLv2Text').html('1');
                }
            });


            $('.saveAlarmPopBtn').click(function () {
                var lv1 = $('#alarmLv1Text').text();
                var lv2 = $('#alarmLv2Text').text();
                var lv3 = $('#alarmLv3Text').text();
                var emgaechi = '';
                var checked = $('#alarmUsed:checked').length;
                if (checked == 0) {
                    lv1 = 0;
                    lv2 = 0;
                    lv3 = 0;
                    emgaechi = '<s:message code="deviceInfo.unuse.critical"/>';
                } else {
                    emgaechi = '<s:message code="deviceInfo.use.critical"/>';
                }

                if (Number(lv1) > Number(lv2)) {
                    alert('<s:message code="deviceInfo.set.lower.caution"/>')
                    return;
                }

                if (Number(lv2) > Number(lv3)) {
                    alert('<s:message code="deviceInfo.set.lower.caution2"/>')
                    return;
                }

                var idx = $('#alertChangePop').attr('idx');
                $('.saveAlarmPopBtn').prop('disabled', true);
                ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function (rs) {
                    if (rs) {
                        ui.get({
                            emgaechi: emgaechi,
                            deviceNm: $('#tblDeviceNm').text(),
                            url: 'device/setHddAlarm.xcn',
                            deviceIp: $.trim($('#tblDeviceIp').text()),
                            index: idx,
                            hddNotifyLimit: lv1,
                            hddWarnLimit: lv2,
                            hddAlarmLimit: lv3,
                            deviceSeq: $('#deviceSelect').selectpicker('val'),
                            success: function (data, total) {
                                ui.alertMsg('<s:message code="common.msg.saved"/>');
                                $('#alertChangePop').modal('hide');
                            },
                            error: function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete: function () {
                                $('.saveAlarmPopBtn').prop('disabled', false);
                                getDeviceStatus();
                            }
                        });
                    } else {
                        $('.saveAlarmPopBtn').prop('disabled', false);
                    }
                });
            });

            $('.saveAlarmCpuPopBtn').click(function () {
                var lv2 = $('#alarmCpuLv2Text').text();
                var emgaechi = '';
                var checked = $('#alarmCpuUsed:checked').length;
                if (checked == 0) {
                    lv2 = 0;
                    emgaechi = '<s:message code="deviceInfo.unuse.critical"/>';
                } else {
                    emgaechi = '<s:message code="deviceInfo.use.critical"/>';
                }

                var idx = $('#alertChangeCpuPop').attr('idx');
                $('.saveAlarmCpuPopBtn').prop('disabled', true);
                ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function (rs) {
                    if (rs) {
                        ui.get({
                            emgaechi: emgaechi,
                            deviceNm: $('#tblDeviceNm').text(),
                            url: 'device/setCpuAlarm.xcn',
                            deviceIp: $.trim($('#tblDeviceIp').text()),
                            index: idx,
                            cpuLoadLimit: lv2,
                            deviceSeq: $('#deviceSelect').selectpicker('val'),
                            success: function (data, total) {
                                ui.alertMsg('<s:message code="common.msg.saved"/>');
                                $('#alertChangeCpuPop').modal('hide');
                            },
                            error: function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete: function () {
                                $('.saveAlarmCpuPopBtn').prop('disabled', false);
                                getDeviceStatus();
                            }
                        });
                    } else {
                        $('.saveAlarmCpuPopBtn').prop('disabled', false);
                    }
                });
            });

            $('.saveAlarmMemoryPopBtn').click(function () {
                var lv2 = $('#alarmMemoryLv2Text').text();
                var emgaechi = '';
                var checked = $('#alarmMemoryUsed:checked').length;
                if (checked == 0) {
                    lv2 = 0;
                    emgaechi = '<s:message code="deviceInfo.unuse.critical"/>';
                } else {
                    emgaechi = '<s:message code="deviceInfo.use.critical"/>';
                }

                var idx = $('#alertChangeMemoryPop').attr('idx');
                $('.saveAlarmMemoryPopBtn').prop('disabled', true);
                ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function (rs) {
                    if (rs) {
                        ui.get({
                            emgaechi: emgaechi,
                            deviceNm: $('#tblDeviceNm').text(),
                            url: 'device/setMemoryAlarm.xcn',
                            deviceIp: $.trim($('#tblDeviceIp').text()),
                            index: idx,
                            memInfoLimit: lv2,
                            deviceSeq: $('#deviceSelect').selectpicker('val'),
                            success: function (data, total) {
                                ui.alertMsg('<s:message code="common.msg.saved"/>');
                                $('#alertChangeMemoryPop').modal('hide');
                            },
                            error: function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete: function () {
                                $('.saveAlarmMemoryPopBtn').prop('disabled', false);
                                getDeviceStatus();
                            }
                        });
                    } else {
                        $('.saveAlarmMemoryPopBtn').prop('disabled', false);
                    }
                });
            });

            //프로세스 재시작 버튼
            $(document).on('click', '.restartBtn', function(){
                var idx = $(this).parent().parent().attr('idx');
                $('.restartBtn').prop('disabled', true);
                ui.confirmMsg('<s:message code="deviceInfo.msg.confirm.restart"/>', '', '', function(rs){
                    if(rs){
                        ui.get({
                            url : 'device/setProcessRestart.xcn',
                            deviceIp : $.trim($('#tblDeviceIp').text()),
                            deviceSeq : $('#deviceSelect').selectpicker('val'),
                            index : idx,
                            success : function ( data, total ) {
                                ui.alertMsg('<s:message code="deviceInfo.msg.processrestart"/>');
                            },
                            error : function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete : function (){
                                $('.restartBtn').prop('disabled', false);
                                getDeviceStatus();
                            }
                        });
                    } else {
                        $('.restartBtn').prop('disabled', false);
                    }
                });
            });

            //프로세스 종료 버튼
            $(document).on('click', '.offBtn', function(){
                var idx = $(this).parent().parent().attr('idx');
                $('.offBtn').prop('disabled', true);
                ui.confirmMsg('<s:message code="deviceInfo.msg.confirm.exitprocess"/>', '', '', function(rs){
                    if(rs){
                        ui.get({
                            url : 'device/setProcessStop.xcn',
                            deviceIp : $.trim($('#tblDeviceIp').text()),
                            index : idx,
                            deviceSeq : $('#deviceSelect').selectpicker('val'),
                            success : function ( data, total ) {
                                ui.alertMsg('<s:message code="deviceInfo.msg.exitprocess"/>');
                            },
                            error : function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete : function (){
                                $('.offBtn').prop('disabled', false);
                                getDeviceStatus();
                            }
                        });
                    } else {
                        $('.offBtn').prop('disabled', false);
                    }
                });
            });

            //프로세스 시작 버튼
            $(document).on('click', '.startBtn', function(){
                var idx = $(this).parent().parent().attr('idx');
                $('.startBtn').prop('disabled', true);
                ui.confirmMsg('<s:message code="deviceInfo.msg.confirm.restart"/>', '', '', function(rs){
                    if(rs){
                        ui.get({
                            url : 'device/setProcessRestart.xcn',
                            deviceIp : $.trim($('#tblDeviceIp').text()),
                            index : idx,
                            deviceSeq : $('#deviceSelect').selectpicker('val'),
                            success : function ( data, total ) {
                                ui.alertMsg('<s:message code="deviceInfo.msg.processstart"/>');
                            },
                            error : function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete : function (){
                                $('.startBtn').prop('disabled', false);
                                getDeviceStatus();
                            }
                        });
                    } else {
                        $('.startBtn').prop('disabled', false);
                    }
                });
            });


            getDevice();
        });


        /**
         * 장비 상태 조회 - SNMP
         */
        var devicePolling;

        function getDeviceStatus() {
            if (devicePolling) window.clearTimeout(devicePolling);
            ui.get({
                url: 'device/getDeviceStatus.xcn',
                deviceIp: $.trim($('#tblDeviceIp').text()),
                success: function (data, total) {
                    if (data == null) {
                        return;
                    }
                    $('#referenceTime').html('<s:message code="deviceInfo.reftime"/> : ' + data.currentDeviceStatusDt);
                    if (data.isConnection) {
                        getDeviceInfo2(data.device);
                        getCpuMemoryUsage(data.cpuMemory);
                        getHDDUsage(data.hdd);
                        getProcessInfo(data.process);
                        getInterfaceInfo(data.interface);
                    } else {
                        noConnectionDevice();
                    }
                },
                error: function (status, message) {
                },
                complete: function () {
                    //var t = Number( $('#refreshTime').attr('val') ) * 1000;
                    devicePolling = window.setTimeout(function () {
                        getDeviceStatus();
                    }, 5000);
                }
            });
        }

        //장비 연결 실패시 화면 reset
        function noConnectionDevice() {
            var str = '-';
            $('#sysInfoHostname').html(str);
            $('#sysConfigOS').html(str);
            $('#sysInfoDate').html(str);
            $('#sysInfoUptime').html(str);
            $('#cpuInfoModel').html(str);

            $("#cpuLoadUsage").empty();
            circlifulOption.percent = 0
            circlifulOption.foregroundColor = getCirclifulColor(circlifulOption.percent);
            $("#cpuLoadUsage").circliful(circlifulOption);

            $("#memInfoUsage").empty();
            circlifulOption.percent = 0;
            circlifulOption.foregroundColor = getCirclifulColor(circlifulOption.percent);
            $("#memInfoUsage").circliful(circlifulOption);

            $('#memInfoTotal').html(str);
            $('#memInfoUsed').html(str);
            $('#memInfoFree').html(str);
            $('#memInfoShared').html(str);
            $('#memInfoCach').html(str);

            $('#hddInfoTable').html('<div class="row text-center" style="height:40px"><s:message code="deviceInfo.msg.notdev"/></div>');
            $('#processTbody').html('<tr><td colspan="7" class="text-center"><s:message code="deviceInfo.msg.notdev"/></td></tr>');
            $('#interfaceTbody').html('<tr><td colspan="10" class="text-center"><s:message code="deviceInfo.msg.notdev"/></td></tr>');
        }

        //장비정보 오른쪽
        function getDeviceInfo2(device) {
            $('#sysInfoHostname').html(device.sysInfoHostname);
            $('#sysConfigOS').html(device.sysConfigOS);
            $('#sysInfoDate').html(device.sysInfoDate);
            $('#sysInfoUptime').html(device.sysInfoUptime);
            $('#cpuInfoModel').html(device.cpuInfoModel);
        }

        //CPU, MEMORY
        function getCpuMemoryUsage(cpuMemory) {
            console.log(cpuMemory);
            $("#cpuLoadUsage").empty();
            $("#memInfoUsage").empty();

            circlifulOption.percent = Number(cpuMemory.cpuLoadUsage);
            circlifulOption.foregroundColor = getCirclifulColor(circlifulOption.percent, 'cpu');

            $("#cpuLoadUsage").circliful(circlifulOption);

            circlifulOption.percent = Number(cpuMemory.memInfoUsage);
            circlifulOption.foregroundColor = getCirclifulColor(circlifulOption.percent, 'mem');
            $("#memInfoUsage").circliful(circlifulOption);

            $('#memInfoTotal').html(cpuMemory.memInfoTotal);
            $('#memInfoUsed').html(cpuMemory.memInfoUsed);
            $('#memInfoFree').html(cpuMemory.memInfoFree);
            $('#memInfoShared').html(cpuMemory.memInfoShared);
            $('#memInfoBuff').html(cpuMemory.memInfoBuff);
            $('#memInfoCach').html(cpuMemory.memInfoCach);
            $('#memInfoSlab').html(cpuMemory.memInfoSlab);
            $('.alertChangeCpu').attr('cpuLoadLimit', cpuMemory.cpuLoadLimit);
            $('.alertChangeMemory').attr('memInfoLimit', cpuMemory.memInfoLimit);
        }

        function getCirclifulColor(rate) {
            if (rate >= 90) return '#BE7533';
            else if (rate >= 80) return '#FD9C44';
            else return '#23B7E5';
        }

        //HDD
        function getHDDUsage(hdd) {
            var str = '';
            for (var i = 0; i < hdd.length; i++) {
                str += '<div class="row" style="height:20px;">';
                str += '	<div class="col-xs-1 fsImg">';
                str += '		<span class="glyphicon glyphicon glyphicon-hdd"></span>';
                str += '	</div>';
                str += '	<div class="col-xs-1" style="width: 120px;">';
                str += '		' + hdd[i].hddInfoMountDir;
                str += '	</div>';
                str += '	<div class="progress col-xs-6" style="min-width: 300px;">';
                str += '		<div class="progress-bar ' + getHddColor(hdd[i]) + ' progress-bar" role="progressbar" aria-valuenow="' + hdd[i].hddInfoUsage + '" aria-valuemin="0" aria-valuemax="100" style="width: ' + hdd[i].hddInfoUsage + '%">';
                str += '		' + hdd[i].hddInfoUsage + '%  ' + getHddText(hdd[i]);
                str += '		</div>';
                str += '	</div>';
                str += '	<div class="col-xs-3">';
                str += '		<span style="position: relative; top: 3px; left: 5px; font-size: 18px;" class="alertChange" hddNotifyLimit="' + hdd[i].hddNotifyLimit + '" hddWarnLimit="' + hdd[i].hddWarnLimit + '" hddAlarmLimit="' + hdd[i].hddAlarmLimit + '"><span class="glyphicon glyphicon-bell" title=""></span></span>';
                /* if (isCC) {
					str+= '		<span style="position: relative; top: 3px; left: 5px; font-size: 18px;" hddNotifyLimit="'+hdd[i].hddNotifyLimit+'" hddWarnLimit="'+hdd[i].hddWarnLimit+'" hddAlarmLimit="'+hdd[i].hddAlarmLimit+'"><span class="glyphicon glyphicon-bell" title=""></span></span>';
				} else {
					str+= '		<a href="javascript:void(0)" style="position: relative; top: 3px; left: 5px; font-size: 18px;" class="alertChange" hddNotifyLimit="'+hdd[i].hddNotifyLimit+'" hddWarnLimit="'+hdd[i].hddWarnLimit+'" hddAlarmLimit="'+hdd[i].hddAlarmLimit+'"><span class="glyphicon glyphicon-bell" title=""></span></a>';
				} */
                str += '		&nbsp;&nbsp;&nbsp;' + hdd[i].hddInfoUsed + '/' + hdd[i].hddInfoBlocks;
                str += '	</div>';
                str += '</div>';
            }
            $('#hddInfoTable').html(str);
        }

        function getHddColor(hdd) {
            if (Number(hdd.hddAlarmLimit) > 0 && Number(hdd.hddAlarmLimit) <= Number(hdd.hddInfoUsage)) return 'progress-bar-danger';
            else if (Number(hdd.hddWarnLimit) > 0 && Number(hdd.hddWarnLimit) <= Number(hdd.hddInfoUsage)) return 'progress-bar-warning';
            else if (Number(hdd.hddNotifyLimit) > 0 && Number(hdd.hddNotifyLimit) <= Number(hdd.hddInfoUsage)) return 'progress-bar-info';
            else return 'progress-bar-success';
        }

        function getHddText(hdd) {
            if (Number(hdd.hddAlarmLimit) > 0 && Number(hdd.hddAlarmLimit) <= Number(hdd.hddInfoUsage)) return '<s:message code="deviceInfo.msg.danger.disk"/>';
            else if (Number(hdd.hddWarnLimit) > 0 && Number(hdd.hddWarnLimit) <= Number(hdd.hddInfoUsage)) return '<s:message code="deviceInfo.msg.caution.disk"/>';
            else if (Number(hdd.hddNotifyLimit) > 0 && Number(hdd.hddNotifyLimit) <= Number(hdd.hddInfoUsage)) return '<s:message code="deviceInfo.msg.interest.disk"/>';
            else return '';
        }

        // PROCESS
        function getProcessInfo(process) {
            var str = '';
            for (var i = 0; i < process.length; i++) {
                str += '<tr class="' + getProcessStatusClass(process[i].procEmassStatus) + '" idx="' + i + '">';
                str += '	<td>' + process[i].procEmassGroupName + '</td>';
                str += '	<td>' + process[i].procEmassProcName + '</td>';
                str += '	<td style="text-align:center;">' + process[i].procEmassVersion + '</td>';
                str += '	<td style="text-align:center;">' + process[i].procEmassProcStime + '</td>';
                str += '	<td style="text-align:center;">' + process[i].procEmassProcRun + '/' + process[i].procEmassProcCnt + '</td>';
                str += '	<td style="text-align:center;">' + getProcessStatusText(process[i].procEmassStatus) + '</td>';
                str += '	<td style="text-align:center;">';
                str += getProcessStatusButton(process[i].procEmassStatus);
                str += '	</td>';
                str += '</tr>';
            }
            $('#processTbody').html(str);
        }

        function getProcessStatusText(status) {
            if (status == 0) return '<s:message code="deviceInfo.usual"/>';
            else if (status == 1) return '<s:message code="deviceInfo.unusual"/>';
            else if (status == 2) return '<s:message code="deviceInfo.unuse"/>';
            else return '-';
        }

        function getProcessStatusClass(status) {
            if (status == 1) return 'process_warn';
            else if (status == 2) return 'process_none';
            else return 'process_normal';
        }

        function getProcessStatusButton(status) {
            var str = '';
            if (status == 0) {
                str += '<button type="button" class="btn btn-sm btn-primary restartBtn"><span class="glyphicon glyphicon-repeat"></span>&nbsp;<s:message code="deviceInfo.restart"/></button>&nbsp;';
                str += '<button type="button" class="btn btn-sm btn-default offBtn"><span class="glyphicon glyphicon-off"></span>&nbsp;<s:message code="deviceInfo.exit"/></button>';
            } else if (status == 1) {
                str += '<button type="button" class="btn btn-sm btn-primary restartBtn"><span class="glyphicon glyphicon-repeat"></span>&nbsp;<s:message code="deviceInfo.restart"/></button>&nbsp;';
                str += '<button type="button" class="btn btn-sm btn-default offBtn"><span class="glyphicon glyphicon-off"></span>&nbsp;<s:message code="deviceInfo.exit"/></button>';
            } else {
                str += '<button type="button" class="btn btn-sm btn-primary startBtn"><span class="glyphicon glyphicon-repeat"></span>&nbsp;<s:message code="deviceInfo.start"/></button>';
            }
            return str;
        }

        function getInterfaceInfo(ifconfig) {
            var str = '';
            for (var i = 0; i < ifconfig.length; i++) {
                str += '<tr class="' + getInterfaceStatusClass(ifconfig[i].netConfState) + '">';
                str += '	<td style="text-align:center;">' + ifconfig[i].netConfDevice + '</td>';
                str += '	<td style="text-align:center;">' + ifconfig[i].netConfType + '</td>';
                str += '	<td style="text-align:center;">' + ifconfig[i].netConfIpAddr + '</td>';
                str += '	<td style="text-align:center;">' + ifconfig[i].netConfMask + '</td>';
                str += '	<td style="text-align:center;">' + ifconfig[i].netConfGatewayIP + '</td>';
                str += '	<td style="text-align:center;">' + ifconfig[i].netConfMacAddr + '</td>';
                str += '	<td style="text-align:center;">' + ifconfig[i].netConfBcast + '</td>';
                str += '	<td style="text-align:right;">' + ifconfig[i].netConfRxByte + '</td>';
                str += '	<td style="text-align:right;">' + ifconfig[i].netConfTxByte + '</td>';
                str += '	<td style="text-align:center;">' + getInterfaceStatusText(ifconfig[i].netConfState) + '</td>';
                str += '</tr>';
            }
            $('#interfaceTbody').html(str);
        }

        function getInterfaceStatusClass(status) {
            if (status == 0) return 'interface_warn';
            else return 'interface_normal';
        }

        function getInterfaceStatusText(status) {
            if (status == 0) return 'down';
            else return 'up';
        }

        function getDevice() {
            ui.get({
                url: 'getDeviceList.xcn',
                success: function (data, total) {
                    makeDeviceTab(data);

                    if (data.devices.length > 0) {
                        $('#modifyBtn, #deleteBtn').prop('disabled', false);
                        getDeviceInfo();
                    } else $('#modifyBtn, #deleteBtn').prop('disabled', true);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        //장비정보 왼쪽
        function getDeviceInfo() {
            var deviceSeq = $('#deviceSelect').selectpicker('val');
            if (deviceSeq != '' && deviceSeq != 'null') {
                ui.get({
                    url: 'getDeviceInfo.xcn',
                    deviceSeq: deviceSeq,
                    success: function (data, total) {
                        if (data == null) return;
                        $('#tblDeviceIp').html(data.deviceIp);
                        $('#tblDeviceNm').html(data.deviceNm);

                        $('#tblDeviceType').attr('type', data.deviceType);
                        if (data.deviceType == 'A') {
                            $('#tblDeviceType').html('<s:message code="selectDevStatus.dev.integrated"/>');
                        } else if (data.deviceType == 'L') {
                            $('#tblDeviceType').html('<s:message code="selectDevStatus.dev.analysis"/>');
                        } else if (data.deviceType == 'C') {
                            $('#tblDeviceType').html('<s:message code="selectDevStatus.dev.logging"/>');
                        } else {
                            $('#tblDeviceType').html('-');
                        }

                        $('#tblComment').html(data.comment);
                        $('#tblCreatDt').html(data.createDt);
                        $('#tblSshId').html(data.sshId);
                        $('#tblSshPw').html(data.sshPw);

                        setAlarmCheck(data);

                        if (devicePolling) window.clearTimeout(devicePolling);
                        getDeviceStatus();
                    },
                    error: function (status, message) {
                        ui.alertMsg(message);
                    },
                    complete: function () {

                    }
                });
            } else {
                getDeviceStatus();
            }
        }


        function saveAlarmCheck(confId, checked) {
            var deviceConfName = '';
            var deviceStatus = '';
            if(confId == 'device.hdd.sms.1'){
                deviceConfName = '<s:message code="deviceInfo.filesystem.sms"/>';
            }
            if(confId == 'device.hdd.notify.1'){
                deviceConfName = '<s:message code="deviceInfo.filesystem.alarm"/>';
            }
            if(confId == 'device.cpu.sms.1'){
                deviceConfName = '<s:message code="deviceInfo.cpu.sms"/>';
            }
            if(confId == 'device.cpu.notify.1'){
                deviceConfName = '<s:message code="deviceInfo.cpu.alarm"/>';
            }
            if(confId == 'device.mem.sms.1'){
                deviceConfName = '<s:message code="deviceInfo.mem.sms"/>';
            }
            if(confId == 'device.mem.notify.1'){
                deviceConfName = '<s:message code="deviceInfo.mem.alarm"/>';
            }
            if(confId == 'device.process.sms.1'){
                deviceConfName = '<s:message code="deviceInfo.process.sms"/>';
            }
            if(confId == 'device.process.notify.1'){
                deviceConfName = '<s:message code="deviceInfo.process.alarm"/>';
            }
            if(confId == 'device.interface.sms.1'){
                deviceConfName = '<s:message code="deviceInfo.interface.sms"/>';
            }
            if(confId == 'device.interface.notify.1'){
                deviceConfName = '<s:message code="deviceInfo.interface.alarm"/>';
            }
            if(checked){
                deviceStatus = ' <s:message code="deviceInfo.check"/>';
            }else{
                deviceStatus = ' <s:message code="deviceInfo.uncheck"/>';
            }
            ui.get({
                url: 'setConfAdmin.xcn',
                confId: confId,
                deviceConfName: deviceConfName,
                deviceStatus: deviceStatus,
                val: (checked == true ? 'Y' : 'N'),
                success: function (data, total) {
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        function setAlarmCheck(data) {
            $('#sms_file').prop('checked', false);
            $('#notify_file').prop('checked', false);
            $('#sms_file_cpu').prop('checked', false);
            $('#notify_file_cpu').prop('checked', false);
            $('#sms_file_mem').prop('checked', false);
            $('#notify_file_mem').prop('checked', false);
            $('#sms_proc').prop('checked', false);
            $('#notify_proc').prop('checked', false);
            $('#sms_inter').prop('checked', false);
            $('#notify_inter').prop('checked', false);

            if(data.hddSmsUseYn=='Y') $('#sms_file').prop('checked', true);
            if(data.hddNotifyUseYn=='Y') $('#notify_file').prop('checked', true);
            if(data.cpuSmsUseYn=='Y') $('#sms_file_cpu').prop('checked', true);
            if(data.cpuNotifyUseYn=='Y') $('#notify_file_cpu').prop('checked', true);
            if(data.memSmsUseYn=='Y') $('#sms_file_mem').prop('checked', true);
            if(data.memNotifyUseYn=='Y') $('#notify_file_mem').prop('checked', true);
            if(data.processSmsUseYn=='Y') $('#sms_proc').prop('checked', true);
            if(data.processNotifyUseYn=='Y') $('#notify_proc').prop('checked', true);
            if(data.interfaceSmsUseYn=='Y') $('#sms_inter').prop('checked', true);
            if(data.interfaceNotifyUseYn=='Y') $('#notify_inter').prop('checked', true);
        }

        //장비 탭 생성
        function makeDeviceTab(data) {
            var options = '';
            var deviceType = '';
            var selected_seq = 0;
            if (param_deviceSeq != '') {
                selected_seq = param_deviceSeq;
            }
            for (var i = 0; i < data.devices.length; i++) {

                if (data.devices[i].deviceType == 'A') {
                    deviceType = '<s:message code="selectDevStatus.dev.integrated"/>';
                } else if (data.devices[i].deviceType == 'L') {
                    deviceType = '<s:message code="selectDevStatus.dev.analysis"/>';
                } else if (data.devices[i].deviceType == 'C') {
                    deviceType = '<s:message code="selectDevStatus.dev.logging"/>';
                }

                options += '<option value="' + data.devices[i].deviceSeq + '">' + data.devices[i].deviceNm + '(' + (deviceType) + ')</option>';
            }
            $('#deviceSelect').html(options);
            $("#deviceSelect").selectpicker('val', selected_seq);
            $("#deviceSelect").selectpicker('refresh');
        }

        //장비 수정
        function modifyDevice() {
            var deviceSeq = $("#deviceSelect").selectpicker('val');
            $('#devSeqHidden').val(deviceSeq);
            $('.savePopBtn').prop('disabled', true);
            ui.confirmMsg('<s:message code="common.msg.confirm.modify"/>', '', '', function (rs) {
                if (rs) {
                    ui.post({
                        url: 'updateDevice.xcn',
                        data : $('#addDevPopForm').serializeAll(),
                        success: function (data, total) {
                            //if(isCC) setHddAlertCC($('#deviceIp').val());
                            ui.alertMsg('<s:message code="common.msg.modified"/>');
                            $('#deviceAddPop').modal('hide');
                            getDevice();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            $('.savePopBtn').prop('disabled', false);
                        }
                    });
                } else {
                    $('.savePopBtn').prop('disabled', false);
                }
            });
        }

        //장비 추가
        function insertDevice() {
            $('#deviceInfoSaveBtn').prop('disabled', true);
            ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function (rs) {
                if (rs) {
                    ui.onBody();
                    ui.get({
                        url: 'insertDevice.xcn',
                        deviceType: $("input[name='deviceType']:checked").val(),
                        deviceNm: $('#deviceNm').val(),
                        deviceIp: $('#deviceIp').val(),
                        sshId: $('#sshId').val(),
                        sshPw: $('#sshPw').val(),
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            $('#deviceAddPop').modal('hide');
                            getDevice();

                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            $('#deviceInfoSaveBtn').prop('disabled', false);
                            ui.off();
                        }
                    });
                } else {
                    $('#deviceInfoSaveBtn').prop('disabled', false);
                }
            });
        }

        function setHddAlertCC(deviceIp) {
            ui.get({
                url: 'device/setHddAlarmCC.xcn',
                deviceIp: deviceIp,
                hddNotifyLimit: '80',
                hddWarnLimit: '90',
                hddAlarmLimit: '85',
                deviceSeq: $('#deviceSelect').selectpicker('val'),
                success: function (data, total) {
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        //선택된 탭
        var currentTab;

        function getCurrentTab() {
            return currentTab == null ? 'coTab' : currentTab;
        }


        function on(id) {
            var obj = $('#' + idIndicator(id));
            var hei = obj.height();
            $(obj).append('<div class="loading_div"><i class="fa fa-spinner fa-spin fa-3x fa-fw"></i></div>');
            $('.loading_div').css({
                "position": "absolute",
                "top": "0px",
                "left": "0px",
                "right": "0px",
                "bottom": "0px",
                "background-color": "#f0f0f0",
                "opacity": "0.3",
                "z-index": "998",
                "text-align": "center"
            });
        }

        function off(id) {
            var obj = $('#' + idIndicator(id) + ' .loading_div');
            obj.remove();
        }
	</script>
</head>
<body class="mini-navbar" id="body">

<div class="modal" id="deviceAddPop" tabindex="-1" role="dialog" aria-labelledby="addDevPopModal">
	<div class="modal-content">
		<form method="post" id="addDevPopForm">
			<div class="modalHead">
				<h2>
					<s:message code="deviceInfo.addDevPop.title"/>
					<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="deviceInfo.addDevPop.title"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="attachTypePopInput" class="fname"><s:message
									code="deviceInfo.select.devtype"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<label for="C"><input type="radio" value="C" name="deviceType" id="C"><s:message
									code="selectDevStatus.dev.logging"/></label>
							<label for="A"><input type="radio" value="A" name="deviceType" id="A"
							                      style="margin-left: 10px;" checked></span><s:message
									code="selectDevStatus.dev.integrated"/></label>
							<label for="L"><input type="radio" value="L" name="deviceType" id="L"
							                      style="margin-left: 10px;"><s:message
									code="selectDevStatus.dev.analysis"/></label>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="deviceIp" class="fname">IP</label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="deviceIp" id="deviceIp" placeholder="IP" required
							       maxlength="64">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="deviceNm" class="fname"><s:message code="common.msg.name"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" id="deviceNm" name="deviceNm" required maxlength="64"
							       placeholder="<s:message code="common.msg.name"/>">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="sshId" class="fname"><s:message code="deviceInfo.ssh.id"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" id="sshId" name="sshId"
							       placeholder="<s:message code="deviceInfo.ssh.id"/>" required maxlength="256">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="sshPw" class="fname"><s:message code="deviceInfo.ssh.pw"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="password" class="w100" id="sshPw" name="sshPw"
							       placeholder="<s:message code="deviceInfo.ssh.pw"/>" required maxlength="512"
							       autocomplete="off">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="comment" class="fname"><s:message code="common.msg.comment"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" id="comment" name="comment"
							       placeholder="<s:message code="common.msg.comment"/>" required maxlength="512">
							<input type="hidden" id="devSeqHidden" name="deviceSeq">
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 savePopBtn" accesskey="S" id="savePopBtn"><s:message
							code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>
<div class="modal" id="alertChangePop" aria-labelledby="alertChangeModal" tabindex="-1" role="dialog"
     data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="alertChangeForm">
			<div class="modalHead">
				<h2><s:message code="deviceInfo.set.critical"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<input type="checkbox" class="mar8" id="alarmUsed"><label class="fname"><s:message
						code="deviceInfo.use.critical"/>
				</div>
				<div class="modalbody">
					<div style="background-color: #000; opacity: .2; position: absolute; top: 40px; left: 20px; right: 20px; bottom: 97px; z-index: 999;"
					     id="alarmModal"></div>
					<div class="row">
						<div class="col-35">
							<label class="fname"><s:message code="deviceInfo.interest"/></label>
						</div>
						<div class="col-65">
							<s:message code="deviceInfo.msg.over.alarmlog"/><br>
							<input style="width: 200px;" type="text" id="alarmLv1Critical" class="span2" value=""
							       data-slider-min="10" data-slider-max="99" data-slider-step="1"
							       data-slider-orientation="horizontal" data-slider-selection="before"
							       data-slider-tooltip="hide" data-slider-id="alarmCri">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label class="fname"><s:message code="deviceInfo.caution"/></label>
						</div>
						<div class="col-65">
							<s:message code="deviceInfo.msg.over.log"/><br>
							<input style="width: 200px;" type="text" id="alarmLv2Critical" class="span2" value=""
							       data-slider-min="10" data-slider-max="99" data-slider-step="1"
							       data-slider-orientation="horizontal" data-slider-selection="before"
							       data-slider-tooltip="hide" data-slider-id="saturationCri">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label class="fname"><s:message code="deviceInfo.danger"/></label>
						</div>
						<div class="col-65">
							<s:message code="deviceInfo.msg.continue.deletelog"/><br>
							<input style="width: 200px;" type="text" id="alarmLv3Critical" class="span2" value=""
							       data-slider-min="50" data-slider-max="99" data-slider-step="1"
							       data-slider-orientation="horizontal" data-slider-selection="before"
							       data-slider-tooltip="hide" data-slider-id="deleteCri">
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 saveAlarmPopBtn" accesskey="S"><s:message
							code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>


<div class="modal" id="alertChangeCpuPop" aria-labelledby="alertChangeCpuModal" tabindex="-1" role="dialog"
     data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="alertChangeCpuForm">
			<div class="modalHead">
				<h2><s:message code="deviceInfo.set.critical"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<input type="checkbox" class="mar8" id="alarmCpuUsed"><label class="fname"><s:message
						code="deviceInfo.use.critical"/>
				</div>
				<div class="modalbody">
					<div style="background-color: #000; opacity: .2; position: absolute; top: 44px; left: 19px; right: 19px; bottom: 95px; z-index: 999;"
					     id="alarmCpuModal"></div>
					<div class="row">
						<div class="col-35">
							<label class="fname"><s:message code="deviceInfo.caution"/></label>
						</div>
						<div class="col-65">
							<input style="width: 200px;" type="text" id="alarmCpuLv2Critical" class="span2" value=""
							       data-slider-min="10" data-slider-max="99" data-slider-step="1"
							       data-slider-orientation="horizontal" data-slider-selection="before"
							       data-slider-tooltip="hide" data-slider-id="saturationCri">
							<label><s:message code="deviceInfo.msg.over.cpu.log"/></label>
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 saveAlarmCpuPopBtn" accesskey="S"><s:message
							code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>

<div class="modal" id="alertChangeMemoryPop" aria-labelledby="alertChangeMemoryModal" tabindex="-1" role="dialog"
     data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="alertChangeMemoryForm">
			<div class="modalHead">
				<h2><s:message code="deviceInfo.set.critical"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<input type="checkbox" class="mar8" id="alarmMemoryUsed"><label class="fname"><s:message
						code="deviceInfo.use.critical"/>
				</div>
				<div class="modalbody">
					<div style="background-color: #000; opacity: .2; position: absolute; top: 44px; left: 19px; right: 19px; bottom: 95px; z-index: 999;"
					     id="alarmMemoryModal"></div>
					<div class="row">
						<div class="col-35">
							<label class="fname"><s:message code="deviceInfo.caution"/></label>
						</div>
						<div class="col-65">
							<input style="width: 200px;" type="text" id="alarmMemoryLv2Critical" class="span2" value=""
							       data-slider-min="10" data-slider-max="99" data-slider-step="1"
							       data-slider-orientation="horizontal" data-slider-selection="before"
							       data-slider-tooltip="hide" data-slider-id="saturationCri">
							<label><s:message code="deviceInfo.msg.over.mem.log"/></label>
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 saveAlarmMemoryPopBtn" accesskey="S"><s:message
							code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>
<div>
	<div>
		<div class="col-xs-9 text-left">
			<div style="display: none"><select id="deviceSelect" class="selectpicker" data-style="btn-default"></select>
			</div>
			<button type="button" class="btn btn-sm btn-primary" accesskey="" id="returnListBtn"
			        style="margin-left: 20px;"><span class="glyphicon glyphicon-arrow-left"></span>&nbsp;<s:message
					code="deviceInfo.returnList"/></button>
			<button type="button" class="btn btn-sm btn-primary" accesskey="M" id="modifyBtn"><span
					class="glyphicon glyphicon-edit"></span>&nbsp;<s:message code="deviceInfo.modify.dev"/></button>
			<button type="button" class="btn btn-sm btn-default" accesskey="D" id="deleteBtn"><span
					class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="deviceInfo.delete.dev"/></button>
			<button type="button" class="btn btn-sm btn-warning" accesskey="R" id="reflashBtn"><span
					class="glyphicon glyphicon-refresh"></span>&nbsp;<s:message code="deviceInfo.refresh"/></button>
		</div>
		<div class="col-xs-3 text-right" style="display: none;">
			<button type="button" class="btn btn-sm btn-purple dropdown-toggle" data-toggle="dropdown">
				<span class="glyphicon glyphicon-download-alt"></span>&nbsp;<s:message
					code="deviceInfo.speed.updatedisplay"/> (<span class="dropdown-text"><s:message
					code="deviceInfo.speed.fast"/></span>) <span val="3" class="caret" id="refreshTime"></span>
			</button>
			<ul class="dropdown-menu dropdown-menu-right" role="menu">
				<li><a href="#" data="2"><s:message code="deviceInfo.speed.fast"/></a></li>
				<li><a href="#" data="4"><s:message code="deviceInfo.speed.normal"/></a></li>
				<li><a href="#" data="7"><s:message code="deviceInfo.speed.slow"/></a></li>
			</ul>
		</div>
		<div class="col-xs-3 text-right" id="referenceTime" style="width:270px;line-height:30px; float: right;">
			<s:message code="deviceInfo.reftime"/> : 2016-05-23 22:15:30
		</div>
	</div>
</div>
<div class="content xcn_full">
	<div class="contentSub" style="font-size: 15px;">

		<div class="tab-content codeContent" style="height:calc(100% - 95px);">
			<div class="row">
				<div class="col-lg-6">
					<div class="panel panel-default">
						<div class="panel-heading">
							<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="deviceInfo.navi.title2"/>
						</div>
						<div class="panel-body">
							<table class="table table-bordered">
								<colgroup>
									<col style="width: 150px;">
									<col>
								</colgroup>
								<tr>
									<th><s:message code="deviceInfo.dev.ip"/></th>
									<td id="tblDeviceIp">-</td>
								</tr>
								<tr>
									<th><s:message code="deviceInfo.dev.name"/></th>
									<td id="tblDeviceNm">-</td>
								</tr>
								<tr>
									<th><s:message code="deviceInfo.dev.type"/></th>
									<td id="tblDeviceType">-</td>
								</tr>
								<tr>
									<th><s:message code="deviceInfo.dev.comment"/></th>
									<td id="tblComment">-</td>
								</tr>
								<tr>
									<th><s:message code="deviceInfo.dev.createdt"/></th>
									<td id="tblCreatDt">-</td>
								</tr>
								<tr style="display: none;">
									<th><s:message code="deviceInfo.dev.sshid"/></th>
									<td id="tblSshId">-</td>
								</tr>
								<tr style="display: none;">
									<th><s:message code="deviceInfo.dev.sshpw"/></th>
									<td id="tblSshPw">-</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="panel panel-default">
						<div class="panel-heading">
							<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="deviceInfo.navi.title2"/>
						</div>
						<div class="panel-body">
							<table class="table table-bordered">
								<colgroup>
									<col style="width: 200px;">
									<col>
								</colgroup>
								<tr>
									<th>System hostname</th>
									<td id="sysInfoHostname">-</td>
								</tr>
								<tr>
									<th>Operation System</th>
									<td id="sysConfigOS">-</td>
								</tr>
								<tr>
									<th>Time on System</th>
									<td id="sysInfoDate">-</td>
								</tr>
								<tr>
									<th>System Uptime</th>
									<td id="sysInfoUptime">-</td>
								</tr>
								<tr>
									<th>CPU</th>
									<td id="cpuInfoModel">-</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-3">
					<div class="panel panel-default">
						<div class="panel-heading">
							<i class="fa fa-bar-chart-o fa-fw"></i> CPU &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<label for="sms_file_cpu"><input class="checkbox" type="checkbox" style="margin-left: 8px;" id="sms_file_cpu"><span class=" checktit">SMS</span></label>
							<label class="notify_file_cpu"><input class="checkbox" type="checkbox" style="margin-left: 8px;" id="notify_file_cpu"><span class=" checktit"><s:message code="deviceInfo.alarm"/></span></label>
							<label>(<s:message code="deviceInfo.set.alarm.critical"/>)</label>
							<span style="float: right;">
									<a href="javascript:void(0)" class="alertChangeCpu"><span
											class="glyphicon glyphicon-bell" style=" color: black;" title=""></span>;&nbsp;</a>
								</span>
						</div>
						<div class="panel-body" style="padding: 0px;">
							<div id="cpuLoadUsage" style="width: 180px;"></div>
						</div>
					</div>
				</div>
				<div class="col-lg-9">
					<div class="panel panel-default">
						<div class="panel-heading">
							<i class="fa fa-bar-chart-o fa-fw"></i> Memory&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<label for="sms_file_mem"><input class="checkbox" type="checkbox" style="margin-left: 8px;" id="sms_file_mem"><span class=" checktit">SMS</span></label>
							<label class="notify_file_mem"><input class="checkbox" type="checkbox" style="margin-left: 8px;" id="notify_file_mem"><span class=" checktit"><s:message
									code="deviceInfo.alarm"/></span></label>
							<label>(<s:message code="deviceInfo.set.alarm.critical"/>)</label>
							<span style="float: right;">
									<a href="javascript:void(0)" class="alertChangeMemory"><span
											class="glyphicon glyphicon-bell" style=" color: black;" title=""></span>;&nbsp;</a>
								</span>
						</div>
						<div class="panel-body" style="padding: 0px;">
							<table style="width: 100%;">
								<colgroup>
									<col width="100">
									<col>
								</colgroup>
								<tr>
									<td>
										<div class="panel-body" style="padding: 0px;">
											<div id="memInfoUsage" style="width: 180px;"></div>
										</div>
									</td>
									<td>
										<table class="table table-bordered memoryTbl">
											<colgroup>
												<col>
												<col>
												<col>
												<col>
												<col>
											</colgroup>
											<tr>
												<th rowspan="2">Total</th>
												<th rowspan="2">Used</th>
												<th colspan="5">Unused</th>
											</tr>
											<tr>
												<th>Free</th>
												<th>Shared</th>
												<th>Buff</th>
												<th>Cache</th>
												<th>Slab</th>
											</tr>
											<tr>
												<td id="memInfoTotal">-</td>
												<td id="memInfoUsed">-</td>
												<td id="memInfoFree">-</td>
												<td id="memInfoShared">-</td>
												<td id="memInfoBuff">-</td>
												<td id="memInfoCach">-</td>
												<td id="memInfoSlab">-</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<div class="panel-heading">
							<div class="form-inline not-dashed">
								<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="deviceInfo.filesystem"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<label for="sms_inter"><input class="checkbox" type="checkbox" id="sms_file" style="margin-left: 8px;"><span
										class=" checktit">SMS</span></label>
								<label class="notify_inter"><input class="checkbox" type="checkbox" id="notify_file" style="margin-left: 8px;"><span class=" checktit"><s:message
										code="deviceInfo.alarm"/></span></label>
								<label>(<s:message code="deviceInfo.set.alarm.critical"/>)</label>
							</div>
						</div>
						<div class="panel-body" id="hddInfoTable">
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<div class="panel-heading">
							<div class="form-inline not-dashed">
								<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="deviceInfo.process"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<label for="sms_proc"><input class="checkbox" type="checkbox" id="sms_proc" style="margin-left: 8px;"><span
										class=" checktit">SMS</span></label>
								<label class="notify_proc"><input class="checkbox" type="checkbox" id="notify_proc" style="margin-left: 8px;"><span class=" checktit"><s:message
										code="deviceInfo.alarm"/></span></label>
								<label>(<s:message code="deviceInfo.set.alarm.change.critical"/>)</label>
							</div>
						</div>
						<div class="panel-body">
							<table class="table table-bordered">
								<thead>
								<tr>
									<th><s:message code="deviceInfo.group"/></th>
									<th><s:message code="deviceInfo.name"/></th>
									<th>Ver.</th>
									<th><s:message code="deviceInfo.stime"/></th>
									<th>Active/Total</th>
									<th><s:message code="deviceInfo.status"/></th>
									<th>Command</th>
								</tr>
								</thead>
								<tbody id="processTbody"></tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<div class="panel-heading">
							<div class="form-inline not-dashed">
								<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="deviceInfo.interface"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<label for="sms_inter"><input class="checkbox" type="checkbox" id="sms_inter" style="margin-left: 8px;"><span class=" checktit">SMS</span></label>
								<label class="notify_inter"><input class="checkbox" type="checkbox" id="notify_inter"><span class=" checktit" style="margin-left: 8px;"><s:message
										code="deviceInfo.alarm"/></span></label>
								<label>(<s:message code="deviceInfo.set.alarm.status2"/>)</label>
							</div>
						</div>
						<div class="panel-body">
							<table class="table table-bordered">
								<thead>
								<tr>
									<th><s:message code="deviceInfo.dev"/></th>
									<th>Type</th>
									<th>IP</th>
									<th>Subnet Mask</th>
									<th>Gateway IP</th>
									<th>MAC</th>
									<th>BroadCast</th>
									<th>RX Packet</th>
									<th>TX Packet</th>
									<th><s:message code="deviceInfo.linkstatus"/></th>
								</tr>
								</thead>
								<tbody id="interfaceTbody"></tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>
</div>
</div>
</body>
