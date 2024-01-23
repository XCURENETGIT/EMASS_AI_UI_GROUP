<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<!--
장비 이벤트수치 레벨
disk 사용율 85 주의
disk 사용율 90 경고
disk 사용율 95 심각
장비 연결 Fail 심각
네트워크 Status DOWN 심각
RX ERR 1 주의
로드평균 10 주의
로드평균 20 경고
로드평균 40 심각
메모리 사용율 90 주의
메모리 사용율 95 경고
메모리 사용율 98 심각
Date 1분 경고
-->
<style>
	th {
		text-align: center;
		vertical-align: middle;
	}


	.subTable {
		width: 100%;
		table-layout: fixed;
	}

	.subTable_tr th:first-child {
		border-left: 1px solid #ddd;
	}

	.fname{
		padding-left: 10px;
	}

	.subTable_tr td {
		border-bottom: 1px solid #ddd;
		border-left: 1px solid #ddd;
		background-color: #EEEFF2;
		font-weight: 600;
	}

	.subTable tr {
		border-bottom: 1px solid #ddd;
	}

	.subTable td {
		vertical-align: middle;
		font-weight: 400;
	}

	.subTable th {
		height: 28px;
		line-height: 28px;
		vertical-align: middle;
		font-weight: 600;
		border-top: 0;
	}

	.none_padding {
		padding: 0 !important;
		vertical-align: top !important;
	}

	.left {
		text-align: left !important;
	}

	.subTable_bottom {
		border-bottom: 1px solid #a04ae0 !important;
	}

	.subTb {
		width: 100%;
	}

	.subTb td {
		line-height: 20px;
		height: 25px;
		padding: 2px;
		width: 100%;
	}

	.subTb tr {
		background-color: white;
	}

	.subTb tr:last-child {
		border-bottom: 0;
	}
	.reserveConf{
		display: none;
	}

	.usage {
		position: relative;
		margin: 0;
		line-height: 13px;
	}

	.usage .usage-reading {
		z-index: 2;
		display: block;
		position: relative;
		padding-bottom: 3px;
		border: 1px solid transparent;
		text-align: center;
		color: #424242;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.usage .usage-low {
		background-color: #96C55A;
	}

	.usage .usage-bar {
		z-index: 1;
	}

	.usage .usage-bar, .usage .usage-bar-rest {
		position: absolute;
		bottom: 0;
		left: 0;
		width: 100%;
		height: 2px;
	}

	.usage .usage-bar-rest {
		z-index: 0;
		background-color: #ddd;
	}

</style>
<script type="text/javascript">
    $(document).ready(function () {
        $('#deviceInsert').click(function () {
            $('#deviceAddPop').modal('show');
            $('.reserveConf').css('display', 'none');

            clearDeviceForm();

        });

        $('#deviceDelete').click(function () {
            let deviceSeqs = [];
            $("input[name='checkDevice']:checked").each(function () {
                deviceSeqs.push($(this).attr('deviceseq'));
            });
            if (deviceSeqs.length === 0) {
                ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                return;
            }

            ui.confirmMsg('<s:message code="common.msg.confirm.delete"/>', '', '', function (rs) {
                ui.onBody();
                ui.get({
                    url: 'deleteDevice.xcn',
                    deviceSeq: deviceSeqs.join(','),
                    success: function (data, total) {
                        ui.alertMsg('<s:message code="common.msg.deleted"/>');
                        getDevice();
                    },
                    error: function (status, message) {
                        ui.alertMsg(message);
                    },
                    complete: function () {
                        ui.off();
                    }
                });
            });
        });

        $('#checkAll').click(function () {
            $('input:checkbox[name="checkDevice"]').prop('checked', $(this).prop('checked'));
        });

        $(document).on('click', '.tableLink', function (event) {
            event.stopPropagation();
            let device = findDevice($(this).attr("deviceSeq"));

            $('#deviceAddPop').attr('deviceSeq', device.deviceSeq);
            $('input:radio[name="deviceType"]:radio[value="' + device.deviceType + '"]').prop('checked', true);
            $('#deviceName').val(device.deviceNm);
            $('#deviceIp').val(device.deviceIp);
            $('#sshId').val(device.sshId);
            $('#sshPw').val(device.sshPw);

            // 체크박스 설정
            $('#sms_file_cpu').prop('checked', device.cpuSmsUseYn === 'Y');
            $('#notify_file_cpu').prop('checked', device.cpuNotifyUseYn === 'Y');
            $('#sms_file_mem').prop('checked', device.memSmsUseYn === 'Y');
            $('#notify_file_mem').prop('checked', device.memNotifyUseYn === 'Y');
            $('#sms_file').prop('checked', device.hddSmsUseYn === 'Y');
            $('#notify_file').prop('checked', device.hddNotifyUseYn === 'Y');
            $('#sms_proc').prop('checked', device.processSmsUseYn === 'Y');
            $('#notify_proc').prop('checked', device.processNotifyUseYn === 'Y');
            $('#sms_inter').prop('checked', device.interfaceSmsUseYn === 'Y');
            $('#notify_inter').prop('checked', device.interfaceNotifyUseYn === 'Y');

            $('#deviceAddPop').modal('show');
            $('.reserveConf').css('display', 'block');
        });

        $('#deviceType').change(function () {
            getDevice();
        });
        $('#searchStr').enter(function () {
            getDevice();
        });
        $('#searchBtn').click(function () {
            getDevice();
        });

        $('#deviceInfoSaveBtn').click(function () {

            if ($('#deviceName').val() === '') {
                ui.alertMsg('<s:message code="deviceInfo.msg.enter.devname"/>');
                $('#deviceNm').focus();
                return;
            }
            if ($('#deviceIp').val() === '') {
                ui.alertMsg('<s:message code="deviceInfo.msg.enter.ip"/>');
                $('#accessIp').focus();
                return;
            }

            if (!checkIP($('#deviceIp').val())) {
                ui.alertMsg('<s:message code="deviceInfo.msg.ip.wrong"/>');
                $('#accessIp').focus();
                return;
            }
            if ($('#sshId').val() === '') {
                ui.alertMsg('<s:message code="deviceInfo.ssh.id.input"/>');
                $('#sshId').focus();
                return;
            }
            if ($('#sshPw').val() === '') {
                ui.alertMsg('<s:message code="deviceInfo.ssh.password.input"/>');
                $('#sshPw').focus();
                return;
            }



            var deviceSeq = $('#deviceAddPop').attr('deviceSeq');
            if (typeof deviceSeq !== 'undefined') {
                valueCheck();
            }

            let id = $('#deviceAddPop').attr('mode');
            if (id === 'insert')
                insertDevice();
            else if (id === 'modify')
                modifyDevice();
        });
        getDevice();

    });


    function valueCheck() {
        var data = [];
        var deviceSeq = $('#deviceAddPop').attr('deviceSeq');

        // 각각의 체크박스에 대해 처리
        data.push({confId: 'device.hdd.sms.' + deviceSeq, val: $('#sms_file').prop('checked') ? 'Y' : 'N'});
        data.push({confId: 'device.hdd.notify.' + deviceSeq, val: $('#notify_file').prop('checked') ? 'Y' : 'N'});
        data.push({confId: 'device.cpu.sms.' + deviceSeq, val: $('#sms_file_cpu').prop('checked') ? 'Y' : 'N'});
        data.push({confId: 'device.cpu.notify.' + deviceSeq, val: $('#notify_file_cpu').prop('checked') ? 'Y' : 'N'});
        data.push({confId: 'device.mem.sms.' + deviceSeq, val: $('#sms_file_mem').prop('checked') ? 'Y' : 'N'});
        data.push({confId: 'device.mem.notify.' + deviceSeq, val: $('#notify_file_mem').prop('checked') ? 'Y' : 'N'});
        data.push({confId: 'device.process.sms.' + deviceSeq, val: $('#sms_proc').prop('checked') ? 'Y' : 'N'});
        data.push({confId: 'device.process.notify.' + deviceSeq, val: $('#notify_proc').prop('checked') ? 'Y' : 'N'});
        data.push({confId: 'device.interface.sms.' + deviceSeq, val: $('#sms_inter').prop('checked') ? 'Y' : 'N'});
        data.push({
            confId: 'device.interface.notify.' + deviceSeq,
            val: $('#notify_inter').prop('checked') ? 'Y' : 'N'
        });

        saveAlarmCheck(data);
    }

    function saveAlarmCheck(data) {

        ui.get({
            url: 'setConfAdmin_list.xcn',
            data: JSON.stringify(data),
            success: function (data, total) {
                modifyDevice();
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
            }
        });
    }


    let deviceList = [];

    function getDevice() {
        $('#checkAll').prop('checked', false);

        ui.onBody();
        ui.get({
            url: 'getDeviceList.xcn',
            deviceType: $('#deviceType').val(),
            searchStr: $('#searchStr').val(),
            success: function (data, total) {
                if (data.devices != null && data.devices.length > 0) {
                    deviceList = data.devices;
                    deviceInfo(data.devices);
                } else {
                    $("#deviceCount").html(' [0건]');
                    $('#deviceBody').html('<tr><td colspan="19"><s:message code="common.msg.nodata"/></td></tr>');
                }
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
                ui.off();
            }
        });
    }

    function findDevice(deviceSeq) {
        for (let i = 0; i < deviceList.length; i++) {
            if (deviceList[i].deviceSeq === deviceSeq) return deviceList[i];
        }
        return null;
    }

    function deviceInfo(data) {
        $("#deviceCount").html(' [' + data.length.comma() + '<s:message code="selectCodeAll.items"/>]');
        let str = '';
        for (let i = 0; i < data.length; i++) {
            let device = nvJson(data[i].currentDevice);
            let statusStr = getStatusName(data[i].currentDevice.status);
            str += '<tr>';
            str += '<td><input type="checkbox" name="checkDevice" deviceSeq="' + data[i].deviceSeq + '"></td>';
            str += '<td>' + (i + 1) + '</td>';
            str += '<td>' + statusStr + '</td>';
            str += '<td><a href="#" deviceSeq="' + data[i].deviceSeq + '" class="tableLink slick-cell link ">' + data[i].deviceNm + '</a></td>';
            str += '<td>' + data[i].deviceIp + '</td>';
            str += '<td>' + getDeviceTypeName(data[i].deviceType) + '</td>';
            str += '<td>' + device.load + '</td>';

            str += '<td>';
            str += '    <span class="usage_rate">' + nvl(device.usedRate) + '</span>';
            str += '    <span>';
            str += '        <div class="usage">';
            str += '            <span class="usage-reading">' + nvn(device.used) + ' / ' + nvn(device.total) + '</span>';
            str += '            <span class="usage-bar usage-low" style="width: ' + device.usedRate + '"></span>';
            str += '            <span class="usage-bar-rest"></span>';
            str += '        </div>';
            str += '    </span>';
            str += '</td>';

            str += '<td>' + nvl(device.date) + '</td>';
            let rows = device.disk.length > device.network.length ? device.disk.length : device.network.length;
            str += '<td class="none_padding">' + subTb(rows, device.disk, 'mount', 'left') + '</td>';
            str += '<td class="none_padding">' + subTbDisk(rows, device.disk) + '</td>';
            str += '<td class="none_padding">' + subTb(rows, device.network, 'name') + '</td>';
            str += '<td class="none_padding">' + subTb(rows, device.network, 'ip') + '</td>';
            str += '<td class="none_padding">' + subTb(rows, device.network, 'netmask') + '</td>';
            str += '<td class="none_padding">' + subTb(rows, device.network, 'broadcast') + '</td>';
            str += '<td class="none_padding">' + subTb(rows, device.network, 'rx_bytes') + '</td>';
            str += '<td class="none_padding">' + subTb(rows, device.network, 'rx_dropped') + '</td>';
            str += '<td class="none_padding">' + subTb(rows, device.network, 'rx_errors') + '</td>';
            //str += '<td class="none_padding">' + subTb(rows, device.network, 'tx_bytes') + '</td>';
            //str += '<td class="none_padding">' + subTb(rows, device.network, 'tx_dropped') + '</td>';
            //str += '<td class="none_padding">' + subTb(rows, device.network, 'tx_errors') + '</td>';
            str += '<td class="none_padding">' + subTb(rows, device.network, 'status') + '</td>';
            str += '</tr>';
        }
        $('#deviceBody').html(str);
    }

    function nvJson(data) {
        try {
            if (data === undefined || data.network === undefined || data.load === undefined || data.disk === undefined) {
                return {load: 0, disk: [], network: []};
            } else return data;
        } catch (e) {
            return {load: 0, disk: [], network: []};
        }
    }

    function getStatusName(code) {
        if (code === 'S') return '<s:message code="trap.message.tra.status1"/>';
        else if (code === 'W') return '<s:message code="deviceInfo.caution"/>';
        else if (code === 'E') return '<s:message code="dashboard.warning"/>';
        else if (code === 'C') return '<s:message code="deviceInfo.critical"/>';
        else if (code === 'N') return '<s:message code="common.msg.connect_fail"/>';
        else return '';
    }

    function getDeviceTypeName(code) {
        if (code === 'C') return '<s:message code="selectDevStatus.dev.logging"/>';
        else if (code === 'A') return '<s:message code="selectDevStatus.dev.integrated"/>';
        else if (code === 'L') return '<s:message code="selectDevStatus.dev.analysis"/>';
        else return '';
    }

    function subTb(rows, data, key, align) {
        if (align === undefined) align = '';
        let result = '<table class="subTb">';
        for (let i = 0; i < rows; i++) {
            if (data[i] !== undefined) {
                let msg = nvl(data[i][key]);
                msg = msg === '' ? '&nbsp;' : msg;
                result += '<tr><td class="' + align + '">' + msg + '</td></tr>';
            } else {
                result += '<tr><td class="' + align + '">&nbsp;</td></tr>';
            }
        }
        return result + '</table>';
    }

    function subTbDisk(rows, data) {
        let result = '<table class="subTb">';
        for (let i = 0; i < rows; i++) {
            if (data[i] !== undefined) {
                let msg = nvl(data[i]['used']) + ' / ' + nvl(data[i]['total']);
                msg = '<span><div class="usage"><span class="usage-reading">' + msg + '</span><span class="usage-bar usage-low" style="width: ' + data[i].use + ';"></span><span class="usage-bar-rest"></span></div></span>';
                result += '<tr><td title="' + data[i].use + '">' + msg + '</td></tr>';
            } else {
                result += '<tr><td>&nbsp;</td></tr>';
            }
        }
        return result + '</table>';
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
                    deviceNm: $('#deviceName').val(),
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

    function modifyDevice() {
        console.log("dfsad");
        $('#deviceInfoSaveBtn').prop('disabled', true);
        ui.confirmMsg('<s:message code="common.msg.confirm.modify"/>', '', '', function (rs) {
            if (rs) {
                ui.onBody()
                ui.get({
                    url: 'updateDevice.xcn',
                    deviceSeq: $('#deviceAddPop').attr('deviceSeq'),
                    deviceType: $("input[name='deviceType']:checked").val(),
                    deviceNm: $('#deviceName').val(),
                    deviceIp: $('#deviceIp').val(),
                    sshId: $('#sshId').val(),
                    sshPw: $('#sshPw').val(),
                    success: function (data, total) {
                        ui.alertMsg('<s:message code="common.msg.modified"/>');
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

    function clearDeviceForm() {
        // 라디오 버튼 초기화
        $("input[name='deviceType']").prop('checked', false);

        // 텍스트 입력 필드 초기화
        $('#deviceName').val('');
        $('#deviceIp').val('');
        $('#sshId').val('');
        $('#sshPw').val('');

        // 체크박스 초기화
        $('input[type="checkbox"]').prop('checked', false);
    }


</script>

<div class="modal" id="deviceAddPop" aria-labelledby="keywordGroupPop" tabindex="-1" role="dialog"
     data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="deviceAddPopForm" onsubmit="return false;">
			<div class="modalHead">
				<h2><s:message code="deviceInfo.addDevPop.title"/></h2>
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
					<form method="post" id="addDevPopForm">
						<h4 class="blue02 pb8" style="position: relative; font-size:14px; font-weight: 600; margin-bottom:8px;">장비 설정</h4>
						<div class="row">
							<div class="col-35">
								<label for="deviceName" class="fname"><s:message code="common.msg.device"/> <s:message
										code="common.msg.type"/></label>
								<span class="red_dot"></span>
							</div>
							<div class="col-65">
								<div class="radio">
									<input type="radio" value="C" name="deviceType" checked>
									<span><s:message code="selectDevStatus.dev.logging"/></span>
								</div>
								<div class="radio">
									<input type="radio" value="A" name="deviceType">
									<span><s:message code="selectDevStatus.dev.integrated"/></span>
								</div>
								<div class="radio">
									<input type="radio" value="L" name="deviceType">
									<span><s:message code="selectDevStatus.dev.analysis"/></span>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-35">
								<label for="deviceName" class="fname"><s:message code="selectCodeAll.devnm"/></label>
								<span class="red_dot"></span>
							</div>
							<div class="col-65">
								<input type="text" class="w100" name="deviceName" id="deviceName">
							</div>
						</div>
						<div class="row">
							<div class="col-35">
								<label for="deviceIp" class="fname">IP</label>
								<span class="red_dot"></span>
							</div>
							<div class="col-65">
								<input type="text" class="w100" name="deviceIp" id="deviceIp">
							</div>
						</div>
						<div class="row">
							<div class="col-35">
								<label for="deviceSSHId" class="fname"><s:message code="device.msg.ssh_id"/></label>
								<span class="red_dot"></span>
							</div>
							<div class="col-65">
								<input type="text" class="w100" name="sshId" id="sshId">
							</div>
						</div>
						<div class="row">
							<div class="col-35">
								<label for="deviceSSHPassword" class="fname"><s:message
										code="device.msg.ssh_password"/></label>
								<span class="red_dot"></span>
							</div>
							<div class="col-65">
								<input type="password" class="w100" name="sshPw" id="sshPw">
							</div>
						</div>
						<div class="reserveConf">
						<h4 class="blue02 bortop_dd pt8 pd8" style="position: relative; font-size:14px; font-weight: 600; margin-bottom:8px;">예약 설정</h4>
						<div class="row" >
							<div class="col-35">
								<label for="deviceSSHPassword" class="fname">CPU</label>
							</div>
							<div class="col-65">
								<div class="checkbox">
									<input type="checkbox"  class="mar8" id="sms_file_cpu"><label for="sms_file_cpu" ><span class= "checktit">SMS</span></label>
									<input type="checkbox" class="mar8" style="margin-left: 8px;" id="notify_file_cpu"><label for="notify_file_cpu" ><span class="checktit"><s:message code="deviceInfo.alarm"/></span></label>
									(<s:message code="deviceInfo.set.alarm.critical"/>)
								</div>
							</div>
						</div>
						<div class="row"  >
							<div class="col-35">
								<label for="deviceSSHPassword" class="fname">MEMORY</label>
							</div>
							<div class="col-65">
								<div class="checkbox">
									<input type="checkbox" class="mar8" id="sms_file_mem"><label for="sms_file_mem" ><span class= "checktit">SMS</span>
									<input type="checkbox" class="mar8" style="margin-left: 8px;" id="notify_file_mem"><label for="notify_file_mem" ><span class="checktit"><s:message code="deviceInfo.alarm"/></span></label>
									(<s:message code="deviceInfo.set.alarm.critical"/>)
								</div>
							</div>
						</div>

						<div class="row" >
							<div class="col-35">
								<label for="deviceSSHPassword" class="fname"><s:message
										code="deviceInfo.filesystem"/></label>
							</div>
							<div class="col-65">
									<div class="checkbox">
										<input type="checkbox" class="mar8" id="sms_file"><label for="sms_file" ><span class= "checktit">SMS</span></label>
										<input type="checkbox" class="mar8" style="margin-left: 8px;" id="notify_file"><label for="notify_file" ><span class="checktit"><s:message code="deviceInfo.alarm"/></span></label>
										(<s:message code="deviceInfo.set.alarm.critical"/>)
									</div>
							</div>
						</div>
						<div class="row" >
							<div class="col-35">
								<label for="deviceSSHPassword" class="fname"> <s:message
										code="deviceInfo.process"/></label>
							</div>
							<div class="col-65">
								<div class="checkbox">
									<input type="checkbox" class="mar8" id="sms_proc"><label for="sms_proc" ><span class= "checktit">SMS</span></label>
									<input type="checkbox" class="mar8"  style="margin-left: 8px;" id="notify_proc"><label for="notify_proc" ><span class="checktit"><s:message code="deviceInfo.alarm"/></span></label>
										(<s:message code="deviceInfo.set.alarm.status"/>)
								</div>
							</div>
						</div>
						<div class="row" >
							<div class="col-35">
								<label for="deviceSSHPassword" class="fname"><s:message
										code="deviceInfo.interface"/></label>
							</div>
							<div class="col-65">
								<div class="checkbox">
									<input type="checkbox" class="mar8" id="sms_inter"><label for="sms_inter" ><span class= "checktit">SMS</span></label>
									<input type="checkbox"  class="mar8" style="margin-left: 8px;" id="notify_inter"><label for="notify_inter" ><span class="checktit"><s:message code="deviceInfo.alarm"/></span></label>
								(<s:message code="deviceInfo.set.alarm.status"/>)
								</div>
							</div>
						</div>
						</div>
					</form>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="deviceInfoSaveBtn"><s:message
							code="common.msg.save"/></button>

				</div>
			</div>
		</form>
	</div>
</div>


<div>
	<div class="searchArea">
		<div class="searchSub">
			<div>
				<select id="deviceType" style="display: inline;margin-right: 4px">
					<option value="">- <s:message code="selectCodeAll.device"/> <s:message code="common.msg.type"/> -
					</option>
					<option value="C"><s:message code="selectDevStatus.dev.logging"/></option>
					<option value="A"><s:message code="selectDevStatus.dev.integrated"/></option>
					<option value="L"><s:message code="selectDevStatus.dev.analysis"/></option>
				</select>
				<input type="text" placeholder="장비 이름 / IP를 입력하세요." id="searchStr" style="width: 220px;">
				<button class="form_btn01" accesskey="Q" id="searchBtn" accesskey="s"><s:message
						code="auditLog.oper.SEARCH"/></button>
			</div>
			<div class="btnform">
				<button type="button" class="btn01" accesskey="I" id="deviceInsert"><img
						src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
				<button type="button" class="btn02" accesskey="D" id="deviceDelete"><img
						src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/>
				</button>
			</div>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					<s:message code="selectCodeAll.device"/> <s:message code="selectCodeAll.list"/>
					<span id="deviceCount"></span>
				</button>
			</div>
			<div id="deviceGrid" class="slickGrid gridArea" style="display: inline-block;overflow: auto;width: 100%;">
				<table class="subTable">
					<colgroup>
						<col style="width: 30px;"><!-- check box-->
						<col style="width: 30px;"><!-- No -->
						<col style="width: 50px;"><!-- 상태 -->
						<col style="width: 120px;"><!-- 이름 -->
						<col style="width: 120px;"><!-- IP -->
						<col style="width: 120px;"><!-- 역할 -->
						<col style="width: 120px;"><!-- 로드 -->
						<col style="width: 130px;"><!-- 메모리 사용 -->
						<col style="width: 140px;"><!-- date -->
						<col style="width: 100px;"><!-- 파티션 -->
						<col style="width: 80px;"><!-- 사용량 -->
						<col style="width: 80px;"><!-- 장치 -->
						<col style="width: 100px;"><!-- IP -->
						<col style="width: 100px;"><!-- subnet -->
						<col style="width: 100px;"><!-- broadcast -->
						<col style="width: 70px;"><!-- RX -->
						<col style="width: 70px;"><!-- RX Drop -->
						<col style="width: 70px;"><!-- RX Err -->
						<%--<col style="width: 70px;"><!-- TX -->
						<col style="width: 70px;"><!-- TX Drop -->
						<col style="width: 70px;"><!-- TX Err -->--%>
						<col style="width: 70px;"><!-- Status-->
					</colgroup>
					<thead>
					<tr>
						<th rowspan="2"><input type="checkbox" id="checkAll"/></th>
						<th rowspan="2">No.</th>
						<th rowspan="2"><s:message code="common.msg.device_status"/></th>
						<th rowspan="2"><s:message code="deviceInfo.dev.name"/></th>
						<th rowspan="2"><s:message code="deviceInfo.dev.ip"/></th>
						<th rowspan="2"><s:message code="common.msg.device_type"/></th>
						<th rowspan="2"><s:message code="deviceInfo.dev.loadAvg"/></th>
						<th rowspan="2"><s:message code="common.msg.device_memory"/></th>
						<th rowspan="2"><s:message code="selectCodeAll.date"/></th>
						<th colspan="2" class="subTable_bottom">
							<s:message code="common.disk"/>
							<s:message code="common.msg.amountuse"/>/th>
						<th colspan="8" class="subTable_bottom"><s:message code="eventLog.networkInterface"/></th>
					</tr>
					<tr class="subTable_tr">
						<th><s:message code="deviceInfo.partition"/></th>
						<th><s:message code="common.msg.amountuse"/></th>
						<th><s:message code="deviceInfo.dev"/></th>
						<th>IP</th>
						<th>Subnet Mask</th>
						<th>BROADCAST</th>
						<th>RX</th>
						<th>RX DROP</th>
						<th>RX ERR</th>
						<%--<th>TX</th>
						<th>TX DROP</th>
						<th>TX ERR</th>--%>
						<th>Status</th>
					</tr>
					</thead>
					<tbody id="deviceBody">
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>