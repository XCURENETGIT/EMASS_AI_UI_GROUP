<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<style>
	input[type=url], input[type=number] {
		font-size: 12px;
		height: 26px;
		line-height: 26px;
		border: 1px solid #CCC;
		background: #FFF;
		padding: 0 4px;
		align-items: center;
	}

	.slick-cell.click {
		cursor: pointer;
		color: #00c;
	}
</style>
<script type="text/javascript">
	$(document).ready(function () {
		$('#searchStr').enter(function () {
			getDefaultPolicy();
		});
		$('#searchStrBtn').click(function (){
			getDefaultPolicy();
		});

		$('#clearBtn').click(function (){
			ui.confirmMsg('<s:message code="agent.policy.default.text"/>', '', '', function(rs) {
				if (rs) {
					grid.on();
					ui.get({
						url: 'initAgentDefaultPolicy.xcn',
						success: function (data, total) {
							ui.alertMsg('<s:message code="common.msg.applied"/>');
							getDefaultPolicy();
						},
						error: function (status, message) { ui.alertMsg(message); },
						complete: function () { grid.off(); }
					});
				}
			});
		});

		getDefaultPolicy();

		$('.policyPopBtn').click(function (){
			saveAgentDefaultConfig();
		});
	});

	function saveAgentDefaultConfig() {
		const confVal = $('#confVal').val();
		if ( confVal === '') {
			ui.alertMsg('<s:message code="agent.setting.confval.empty"/>');
			return;
		}

		ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function(rs) {
			if (rs) {
				ui.on('policyPop');
				ui.get({
					url: 'saveAgentDefaultConfig.xcn',
					agentId: 'DEFAULT',
					confId: $('#confId').val(),
					confVal: $('#confVal').val(),
					success: function (data, total) {
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						$('#policyPop').modal('hide');
						getDefaultPolicy();
					},
					error: function (status, message) { ui.alertMsg(message); },
					complete: function () { ui.off('policyPop'); }
				});
			}
		});
	}
</script>
<body>

<div class="modal" id="policyPop" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="policyPopForm" action="javascript:false">
			<div class="modalHead">
				<h2><s:message code="AGENT_SETUP.msg.header"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="agent.setting.confval"/> <s:message code="common.msg.modify"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="category" class="fname"><s:message code="common.category"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="category" id="category" disabled>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="confName" class="fname"><s:message code="dashboardSetup.dashcomment"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="confName" id="confName" disabled>
							<input type="hidden" class="w100" name="confId" id="confId" disabled>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="confVal" class="fname"><s:message code="agent.setting.confval"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65" id="cofValLayer">
							<input type="text" class="w100" name="confVal" id="confVal">
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 policyPopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>

<div>
	<div class="searchArea">
		<div>
			<div class="searchSub" style="width:100%;">
				<div style="display: flex; align-items: center;">
					<input type="text" placeholder="<s:message code="agent.input.category"/>" id="searchStr" style="width: 280px; margin-right: 8px;">
					<button class="form_btn01" type="button" accesskey="K" id="searchStrBtn" style="margin-right: 5px;"><s:message code="common.search"/></button>
					<button class="form_btn02" id="clearBtn"><s:message code="agent.policy.default"/></button>
				</div>
			</div>
		</div>
	</div>
	<div class="content" style="overflow:hidden;">
		<div>
			<div class="contentSub ">
				<div id="defaultPolicyGrid" class="slickGrid gridArea"></div>
			</div>
		</div>
	</div>
</div>
</body>

<script type="text/javascript">
	const grid = new Xgrid('defaultPolicyGrid', contextRoot);
	grid.autoNumber();
	grid.colAdd('category', '<s:message code="common.category"/>', 150, 'left', false, 'nomal');
	grid.colAdd('confName', '<s:message code="dashboardSetup.dashcomment"/>', 400, 'left', false, 'nomal', function (row) {
		return getConfNameText(grid.getRowData(row)['confId'], grid.getRowData(row)['confName']);
	});
	grid.colAdd('confVal', '<s:message code="agent.setting.confval"/>', 700, 'left', false, 'click', function (row, cell, value) {
		if(grid.getRowData(row)['confId'] === 'clipboard.mode') {
			if(value === 'both') return '🛡️ <s:message code="agent.clipboard.mode.both"/>';
			if(value === 'detect') return '🔍 <s:message code="agent.clipboard.mode.detect"/>';
		}
		if(value === 'true') return '✔️ True';
		if(value === 'false') return '✖️ False';
		return '🔹 ' + value;
	});
	grid.loadExportMenu('<s:message code="AGENT_SETUP.msg.header"/>');
	grid.loadHeader(false);
	grid.initData('<s:message code="analysis.usagecompare.search"/>');

	grid.onClick = function () {
		if (grid.Col === grid.ColIndex('confVal')) modify();
	}
	grid.onDblClick = modify;

	function modify(){
		const data = grid.getRowData(grid.Row);
		randerConfValType(data.confId);

		$('#category').val(data.category);
		$('#confId').val(data.confId);
		$('#confName').val(getConfNameText(data.confId, data.confName));
		$('#confVal').val(data.confVal);
		$('#policyPop').modal('show');
	}

	function getDefaultPolicy() {
		grid.on();
		ui.get({
			url: 'getDefaultPolicy.xcn',
			searchStr : $('#searchStr').val(),
			success: function (data) {
				grid.setData(data.filter(item => (item.category !== "Agent Auth" && item.confId !== "usb.allowedDevices")));
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				grid.off();
			}
		});
	}

	function randerConfValType(confId) {
		let result = '';
		if(confId === 'agent.logLevel') {
			result = '<select id="confVal" class="w100"><option value="debug">🛠️ DEBUG</option><option value="info">ℹ️ INFO</option><option value="warn">⚠️ WARN</option><option value="error">❌ ERROR</option></select>';
		} else if (confId === 'clipboard.mode') {
			result = '<select id="confVal" class="w100"><option value="both">🛡️ <s:message code="agent.clipboard.mode.both"/></option><option value="detect">🔍 <s:message code="agent.clipboard.mode.detect"/></option></select>'
		} else if (confId === 'clipboard.enabled' || confId === 'mitm.options.ssl_insecure' || confId === 'mitm.options.websocket' || confId === 'usb.enabled') {
			result = '<select id="confVal" class="w100"><option value="true">✔️ True</option><option value="false">✖️ False</option></select>'
		} else if(confId === 'policy.serverUrl' || confId === 'policy.uploadUrl' || confId === 'proxy.pacUrl') {
			result = '<input id="confVal" class="w100" type="url"/>';
		} else if(confId === 'mitm.port' || confId === 'policy.updateInterval' || confId === 'storage.cleanupInterval' || confId === 'storage.maxFileCount' || confId === 'storage.maxSize' || confId === 'storage.retention' || confId === 'storage.scanInterval') {
			result = '<input id="confVal" class="w100" type="number"/>';
		} else {
			result = '<input id="confVal" class="w100" type="text"/>';
		}
		$('#cofValLayer').html(result);
	}

	function getConfNameText(confId, confName) {
		if(confId === 'agent.email') return '📧 <s:message code="agent.default.agent.email"/>';
		if(confId === 'agent.id') return '🆔 <s:message code="agent.default.agent.id"/>';
		if(confId === 'agent.logLevel') return '📊 <s:message code="agent.default.agent.logLevel"/>';
		if(confId === 'policy.serverUrl') return '🌐 <s:message code="agent.default.policy.serverUrl"/>';
		if(confId === 'policy.updateInterval') return '⏱️ <s:message code="agent.default.policy.updateInterval"/>';
		if(confId === 'policy.uploadUrl') return '📤 <s:message code="agent.default.policy.uploadUrl"/>';
		if(confId === 'clipboard.enabled') return '📋 <s:message code="agent.default.clipboard.enabled"/>';
		if(confId === 'clipboard.mode') return '🔍 <s:message code="agent.default.clipboard.mode"/>';
		if(confId === 'usb.allowedDevices') return '🔌 <s:message code="agent.default.usb.allowedDevices"/>';
		if(confId === 'usb.enabled') return '🛡️ <s:message code="agent.default.usb.enabled"/>';
		if(confId === 'mitm.options.listen_host') return '🎧 <s:message code="agent.default.mitm.options.listen_host"/>';
		if(confId === 'mitm.options.ssl_insecure') return '⚠️ <s:message code="agent.default.mitm.options.ssl_insecure"/>';
		if(confId === 'mitm.options.stream_large_bodies') return '📦 <s:message code="agent.default.mitm.options.stream_large_bodies"/>';
		if(confId === 'mitm.options.websocket') return '🔁 <s:message code="agent.default.mitm.options.websocket"/>';
		if(confId === 'mitm.port') return '🔢 <s:message code="agent.default.mitm.port"/>';
		if(confId === 'proxy.pacUrl') return '🗂️ <s:message code="agent.default.proxy.pacUrl"/>';
		if(confId === 'storage.cleanupInterval') return '🗑️ <s:message code="agent.default.storage.cleanupInterval"/>';
		if(confId === 'storage.maxFileCount') return '📁 <s:message code="agent.default.storage.maxFileCount"/>';
		if(confId === 'storage.maxSize') return '📏 <s:message code="agent.default.storage.maxSize"/>';
		if(confId === 'storage.retention') return '🕒 <s:message code="agent.default.storage.retention"/>';
		if(confId === 'storage.scanInterval') return '🔄 <s:message code="agent.default.storage.scanInterval"/>';
		return confName;
	}
</script>