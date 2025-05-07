<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<style>
	.notify_content{
		line-height: 50px;
		padding-left: 27px;
	}
	.onLine {
		margin-top: 0;
	}
	.onLine, .offLine {
		background-size: 17px 17px;
		margin-top: -1px;
		background-repeat: no-repeat;
		padding-left: 29px;
		background-position-y: 4px;
		background-position-x: 2px;
	}
	.onLine {
		background-image: url(../img/ico_check.png);
	}
	.offLine {
		background-image: url(../img/ico_contained.png););
	}
	#usbDeviceList label {
		border: 1px solid #CCC;
		width: 300px;
		font-size: 12px;
		height: 26px;
		line-height: 26px;
		background: #FFF;
		padding: 0 4px;
		align-items: center;
		margin-bottom: 3px;
	}
	#usbDeviceList label input {
		vertical-align: middle;
	}
</style>
<script type="text/javascript">
	$(document).ready(function () {
		$('#agentId').enter(function () {
			getAgentStatus();
		});
		$('#agentIdBtn').click(function () {
			getAgentStatus();
		});
		$('#status').change(function () {
			getAgentStatus();
		});
		$('#savePopBtn').click(function () {
			saveAgentConfig();
		});
		$('#downBtn').click(function () {
			try {
				const iframe = document.getElementById('AttachDown');
				iframe.src = contextRoot + '/agentDownload.xcn';
			} catch (error) {
				console.error("파일 다운로드 실패:", error);
			}
		});

		getAgentStatus();
	});

	function agentOff(data) {
		for (let i = 0; i < data.length; i++) {
			let title = '[Agent] Connection Fail';
			let content = '[' + data[i].agentId + '] ' + data[i].userNm + ' <' + data[i].clientIp + '>';
			$.notify({
				icon: 'glyphicon glyphicon-warning-sign',
				title: '<strong>' + title + '</strong><br>',
				message: '<p class="notify_content">' + content + '</p>'
			}, {
				type: 'info',
				placement: {
					from: 'bottom',
					align: 'right'
				},
				animate: {
					enter: 'animated fadeInRight',
					exit: 'animated fadeOutRight'
				}
			});
		}
	}

	function saveAgentConfig() {
		const agentId = $('#agentIdPop').text();
		const logLevel = $('#logLevel').val();
		const clipboardEnabled = $('input[name="clipboardEnabled"]:checked').val() === 'true';
		const clipboardMode = $('#clipboardMode').val();
		const usbEnabled = $('input[name="usbEnabled"]:checked').val() === 'true';
		const usbAllowedDevices = $('input[name="usbAllowedDevices"]').map(function() { return $(this).val(); }).get();

		ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function(rs) {
			if (rs) {
				ui.on('agentPop');
				ui.get({
					url: 'saveAgentConfig.xcn',
					agentId: agentId,
					logLevel: logLevel,
					clipboardEnabled: clipboardEnabled,
					clipboardMode: clipboardMode,
					usbEnabled: usbEnabled,
					usbAllowedDevices: JSON.stringify(usbAllowedDevices),
					success: function (data, total) {
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						$('#agentPop').modal('hide');
					},
					error: function (status, message) { ui.alertMsg(message); },
					complete: function () { ui.off('agentPop'); }
				});
			}
		});
	}
</script>
<body>
<div class="modal"  id="agentPop" tabindex="-1" role="dialog" aria-labelledby="agentPop">
	<div class="modal-content" style="width: 700px;">
		<form method="post" id="agentPopForm" action="javascript:false">
			<div class="modalHead">
				<h2><s:message code="agent.agentPop.title"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="agent.agentPop.sub.title"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="agentIdPop" class="fname">Agent ID</label>
						</div>
						<div class="col-65">
							<label id="agentIdPop"></label>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="userInfo" class="fname"><s:message code="common.msg.userinfo"/></label>
						</div>
						<div class="col-65">
							<label id="userInfo"></label>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="clientIp" class="fname">Agent IP</label>
						</div>
						<div class="col-65">
							<label id="clientIp"></label>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="logLevel" class="fname"><s:message code="agent.agentPop.logLevel"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<select id="logLevel" class="w100" name="logLevel">
								<option value="debug">🛠️ DEBUG</option>
								<option value="info">ℹ️ INFO</option>
								<option value="warn">⚠️ WARN</option>
								<option value="error">❌ ERROR</option>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="clipboardEnabled" class="fname"><s:message code="agent.agentPop.clipboard.enabled"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<label class="radio-inline c-radio">
								<input type="radio" name="clipboardEnabled" value="true" checked> <s:message code="common.msg.use"/>
							</label>
							<label class="radio-inline c-radio">
								<input type="radio" name="clipboardEnabled" value="false" disabled> <s:message code="common.msg.unuse"/>
							</label>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="clipboardMode" class="fname"><s:message code="agent.agentPop.clipboard.mode"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<select id="clipboardMode" class="w100">
								<option value="off">🛑 <s:message code="agent.clipboard.mode.off"/></option>
								<option value="detect">🔍 <s:message code="agent.clipboard.mode.detect"/></option>
								<option value="clear">♻️ <s:message code="agent.clipboard.mode.clear"/></option>
								<option value="both">🔄 <s:message code="agent.clipboard.mode.both"/></option>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="usbEnabled" class="fname"><s:message code="agent.agentPop.usb.enabled"/></label>
						</div>
						<div class="col-65">
							<label class="radio-inline c-radio">
								<input type="radio" name="usbEnabled" value="true" checked> <s:message code="common.msg.use"/>
							</label>
							<label class="radio-inline c-radio">
								<input type="radio" name="usbEnabled" value="false"> <s:message code="common.msg.unuse"/>
							</label>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="usbAllowedDevices" class="fname"><s:message code="agent.agentPop.usb.allowedDevices"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65 usb-control">
							<input type="text" id="usbDeviceInput" class="w70" placeholder="🖥️ Enter USB Device ID" style="margin-bottom: 5px;">
							<button type="button" id="btnDataAdd1" class="btn userBtnData" style="height:25px;vertical-align: middle;padding:0 5px 0 5px;" onclick="addUsb();">
								<span class="glyphicon glyphicon-plus"></span>
							</button>
							<button type="button" id="btnDataDel1" class="btn userBtnData" style="height:25px;vertical-align: middle;padding:0 5px 0 5px;" onclick="delUsb();">
								<span class="glyphicon glyphicon-minus"></span>
							</button>
							<div id="usbDeviceList"></div>
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 savePopBtn" accesskey="S" id="savePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>
<div>
	<div class="searchArea">
		<div>
			<div class="searchSub" style="width:100%;">
				<div>
					<select id="status" style="width: 200px;">
						<option value="">- <s:message code="agent.registered"/> -</option>
						<option value="Y">🟢 Active</option>
						<option value="N">⛔ Inactive</option>
						<option value="X">❓ Unregistered</option>
					</select>
				</div>
				<div style="display: flex; align-items: center;">
					<input type="text" placeholder="<s:message code="agent.status.search.text"/>" id="agentId" style="width: 280px; margin-right: 8px;">
					<button class="form_btn01" type="button" accesskey="K" id="agentIdBtn"><s:message code="common.search"/></button>
					<button type="button" class="btn01" style="margin-left: 5px;" accesskey="D" id="downBtn"><img src="<c:url value="/img/subBtn_upload.png"/>" alt="Agent Download"><s:message code="agent.install.download"/></button>
				</div>
			</div>
		</div>
	</div>
	<div class="content" style="overflow:hidden;">
		<div>
			<div class="contentSub ">
				<div class="subtab">
					<button class="active" style="cursor: default">
						<s:message code="agent.registered"/>
						<span id="agentStatusInfo">[]</span>
					</button>
				</div>
				<div id="agentStatusGrid" class="slickGrid gridArea"></div>
			</div>
		</div>
	</div>
</div>
<iframe id="AttachDown" src="about:blank;" height="0" width="0" style="display: none;" ></iframe>
</body>
<script type="text/javascript">
	const grid = new Xgrid('agentStatusGrid', contextRoot);
	grid.autoNumber();
	grid.colAdd('sendMail', '<s:message code="agent.install.text"/>', 120, 'center', false, 'link', function (row) {
		if (grid.getRowData(row)['userEmail'] && !grid.getRowData(row)['agentId']) return '📧 발송'
		return '';
	});
	grid.colAdd('status', 'Agent <s:message code="deviceInfo.status"/>', 120, 'left', false, 'nomal', function (row) {
		if (!grid.getRowData(row)['agentId']) return '❓ Unregistered';
		else if (grid.getRowData(row)['status'] === 'Y') return '🟢 Active';
		return '⛔ Inactive';
	});
	grid.colAdd('userNm', '<s:message code="common.msg.name"/>', 100, 'center', false, 'nomal');
	grid.colAdd('userId', '<s:message code="common.msg.id"/>', 120, 'left', false, 'nomal');
	grid.colAdd('userEmail', 'E-Mail', 250, 'left', false, 'nomal');
	grid.colAdd('deptNm', '<s:message code="common.org.dept"/>', 200, 'left', false, 'nomal');
	grid.colAdd('agentId', 'Agent ID', 330, 'left', false, 'link');
	grid.colAdd('clientIp', 'Agent IP', 120, 'left', false, 'nomal');
	grid.colAdd('lastLoginDt', '<s:message code="agent.last.response.time"/>', 150, 'center', false, 'nomal');
	grid.colAdd('durationDt', '<s:message code="agent.duration.response.time"/>', 120, 'center', false, 'nomal', function (row) {
		return getTimeDifferenceString(grid.getRowData(row)['lastLoginDt']);
	});
	grid.loadExportMenu('<s:message code="POLICY_SETUP.AGENT_STATUS"/>');
	grid.loadHeader(false);
	grid.initData('<s:message code="analysis.usagecompare.search"/>');
	grid.onClick = function() {
		if (grid.Col === grid.ColIndex('agentId')) showModal();
		if (grid.Col === grid.ColIndex('sendMail')) sendMail();
	};
	grid.onDblClick = showModal;

	function sendMail() {
		if(!grid.getRowData(grid.Row)['userEmail']) return;

		if (!grid.getRowData(grid.Row)['agentId']) {
			ui.confirmMsg('<s:message code="mail.message.sendmail"/>', '', '', function(rs) {
				if (rs) {
					grid.on();
					ui.get({
						url: 'sendInstallMail.xcn',
						email : grid.getRowData(grid.Row)['userEmail'],
						success: function (data) {
							alert('<s:message code="mail.message.success"/>')
						},
						error: function (status, message) {ui.alertMsg(message);},
						complete: function () {grid.off();}
					});
				}
			});
		}
	}

	// Agent 설정 팝업
	function showModal() {
		if(!grid.getRowData(grid.Row)['agentId']) {
			alert('<s:message code="agent.agentPop.notInstall"/>')
			return;
		}
		$('#agentIdPop').text(nvl(grid.getRowData(grid.Row)['agentId'], '-'));
		const deptNm = nvl(grid.getRowData(grid.Row)['deptNm'], '-');
		const userNm = nvl(grid.getRowData(grid.Row)['userNm'], '-');
		const userEmail = nvl(grid.getRowData(grid.Row)['userEmail'], '-');
		$('#userInfo').text(deptNm + ' / ' + userNm + ' / ' + userEmail);
		$('#clientIp').text(nvl(grid.getRowData(grid.Row)['clientIp'], '-'));

		grid.on();
		ui.get({
			url: 'getPolicyList.xcn',
			agentId: $('#agentIdPop').text(),
			success: function (data) {
				$('#logLevel').val(getConfValById(data, 'agent.logLevel'));
				$('input[name="clipboardEnabled"][value="' + getConfValById(data, 'clipboard.enabled') + '"]').prop('checked', true);
				$('#clipboardMode').val(getConfValById(data, 'clipboard.mode'));
				$('input[name="usbEnabled"][value="' + getConfValById(data, 'usb.enabled') + '"]').prop('checked', true);

				initAllowedUsb();
				const allowedDevices = JSON.parse(getConfValById(data, 'usb.allowedDevices'));
				if ($.isArray(allowedDevices) && allowedDevices.length) {
					$.each(allowedDevices, function (i, val) {
						addUsbTag(val);
					});
				}
				clipboardStatus();
				usbStatus();
				$('#agentPop').modal('show');
			},
			error: function (status, message) {ui.alertMsg(message);},
			complete: function () {grid.off();}
		});
	}

	$('input[name="clipboardEnabled"]').on('change', function () {
		clipboardStatus();
	});
	$('input[name="usbEnabled"]').on('change', function () {
		usbStatus();
	});

	function clipboardStatus() {
		const clipboardEnabled = $('input[name="clipboardEnabled"]:checked').val() === 'true';
		$('#clipboardMode').prop('disabled', !clipboardEnabled);
	}

	function usbStatus() {
		const usbEnabled = $('input[name="usbEnabled"]:checked').val() === 'true';
		$('#usbDeviceInput').prop('disabled', !usbEnabled);
		$('#btnDataAdd1').prop('disabled', !usbEnabled);
		$('#btnDataDel1').prop('disabled', !usbEnabled);
	}

	// USB 허용 디바이스 초기화
	function initAllowedUsb(){
		$('#usbDeviceList').html('')
	}

	// Array의 키를 이용한 값 찾기
	function getConfValById(confList, id) {
		const item = confList.find(conf => conf.confId === id);
		return item ? item.confVal : null;
	}

	// Agent 상태 요약 정보
	function getAgentStatusSummary() {
		ui.get({
			url: 'getAgentStatusSummary.xcn',
			success: function (data) {
				const info = '&nbsp;&nbsp;❓ UnRegistered : ' + data.UNREGISTERED.comma() + ' 🟢 Active : ' + data.ACTIVE.comma() + ' ⛔ Inactive : ' + data.INACTIVE.comma();
				$('#agentStatusInfo').html(info);
			},
			error: function (status, message) {ui.alertMsg(message);}
		});
	}

	// Agent 상태 조회
	function getAgentStatus() {
		grid.on();
		getAgentStatusSummary();
		ui.get({
			url: 'getAgentStatus.xcn',
			agentId: $('#agentId').val(),
			status: $('#status').val(),
			success: function (data) {
				grid.setData(data);
			},
			error: function (status, message) { ui.alertMsg(message); },
			complete: function () { grid.off(); }
		});
	}

	function getTimeDifferenceString(pastTimeStr) {
		if(!pastTimeStr) return '-';
		const pastTime = new Date(pastTimeStr.replace(' ', 'T'));
		const now = new Date();
		const diffMs = now - pastTime;
		if (diffMs < 0) return "Invalid time information.";
		const diffSec = Math.floor(diffMs / 1000);
		const hours = Math.floor(diffSec / 3600);
		const minutes = Math.floor((diffSec % 3600) / 60);
		const seconds = diffSec % 60;
		return (
			String(hours).padStart(2, '0') + ':' +
			String(minutes).padStart(2, '0') + ':' +
			String(seconds).padStart(2, '0')
		);
	}

	// USB 허용 디바이스 추가
	function addUsb() {
		const $input = $('#usbDeviceInput');
		const value = $.trim($input.val());
		$input.val('');
		addUsbTag(value)
	}

	// USB 허용 디바이스 추가
	function addUsbTag(value) {
		const $list = $('#usbDeviceList');
		if (value === '') {
			alert('<s:message code="agent.allowed.usb.input.id"/>');
			return;
		}
		const exists = $list.find('input[type="checkbox"]').filter(function () {
			return $(this).val() === value;
		}).length > 0;

		if (exists) {
			alert('<s:message code="agent.allowed.usb.already.id"/>');
			return;
		}
		const $label = $('<label><input type="checkbox" name="usbAllowedDevices" value="'+value+'"> '+value+'</label>');
		$list.append($label);
	}

	// USB 허용 디바이스 삭제
	function delUsb() {
		const $checked = $('#usbDeviceList input[type="checkbox"]:checked');
		if ($checked.length === 0) {
			alert('<s:message code="agent.allowed.usb.delete.id"/>');
			return;
		}
		$checked.each(function () {
			$(this).closest('label').remove();
		});
	}
</script>