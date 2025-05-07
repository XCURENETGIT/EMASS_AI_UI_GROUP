<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<style>
	.app_icon{
		width: 20px;
		height: 20px;
		vertical-align: middle;
	}
	.tab-content {
		display: none;
	}
	.tab-content.active {
		display: inherit;
	}
	.slickGrid{
		overflow: auto;
		border-bottom: 0;
	}
	table {
		border-collapse: collapse;
		width: 100%;
		border: 1px solid #ddd;
	}

	th {
		border: 0;
		padding: 8px 6px;
		font-size: 14px;
		position: sticky;
		top: 0;
		background-color: gray;
		z-index: 2;
	}

	td {
		border: 0;
		padding: 4px 6px;
		font-size: 14px;
	}

	th {
		background-color: #EEEFF2;
		border: 1px solid #ddd;
		color: #434343;
		font-weight: bold;
		text-align: center;
	}

	.toggle-btn {
		cursor: pointer;
		user-select: none;
	}

	tr:hover {
		background-color: #e6f2ff; /* 연한 파란색 배경 */
	}

	.tree-node {
		display: none;
	}

	.expanded + .tree-node {
		display: table-row;
	}

	.indent-1 {
		padding-left: 50px;
	}

	.checkbox {
		text-align: center;
		margin: 0;
	}

	.checkbox input {
		height: 18px;
		width: 18px;
		margin: 0;
	}
</style>
<body>
<div>
	<div class="searchArea">
		<div>
			<div class="searchSub" style="width:100%;">
				<div style="display: flex; align-items: center;">
					<input type="text" placeholder="<s:message code="agent.msg.enter.svc"/>" id="searchStr" style="width: 280px; margin-right: 8px;">
					<button class="form_btn01" type="button" accesskey="K" id="searchStrBtn" style="margin-right: 5px;"><s:message code="common.search"/></button>
					<button class="form_btn03" id="applyBtn"><s:message code="common.msg.apply"/></button>
				</div>
			</div>
		</div>
	</div>
	<div class="content" style="overflow:hidden;">
		<div>
			<div class="contentSub ">
				<div class="subtab">
					<ul class="nav-tabs">
						<li class="active" style=" text-align: center"><a data-toggle="tab" href="#webList" id="webTab" class="coTabClass"><s:message code="agent.logging.web.service"/></a></li>
						<li style="text-align: center"><a data-toggle="tab" href="#screenShotList" id="screenShotTab"><s:message code="agent.logging.screenshot.service"/></a></li>
					</ul>
				</div>
				<div id="webList" class="tab-content active" style="height:100%;">
					<div class="slickGrid gridArea">
						<table id="tree-table">
							<colgroup>
								<col style="width: 350px;">
								<col style="width: 80px">
								<col>
							</colgroup>
							<thead>
							<tr>
								<th>서비스 카테고리</th>
								<th>활성화</th>
								<th></th>
							</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
				<div id="screenShotList" class="tab-content" style="height:100%;">
					<div class="slickGrid gridArea">
						<table id="screenShot-table">
							<colgroup>
								<col style="width: 350px;">
								<col style="width: 80px">
								<col>
							</colgroup>
							<thead>
							<tr>
								<th>서비스 카테고리</th>
								<th>활성화</th>
								<th></th>
							</tr>
							</thead>
							<tbody>
							<tr>
								<td>▶️ <img class="app_icon" src="<c:url value="/img/icon/kakaotalk.png"/>" alt="">&nbsp;&nbsp;<span class="folder-name">KakaoTalk</span></td>
								<td class="checkbox"><input type="checkbox" name="screenShotCd" value="kakaotalk"></td>
								<td></td>
							</tr>
							<tr>
								<td>▶️ <img class="app_icon" src="<c:url value="/img/icon/whatsapp.png"/>" alt="">&nbsp;&nbsp;<span class="folder-name">WhatsApp</span></td>
								<td class="checkbox"><input type="checkbox" name="screenShotCd" value="whatsapp"></td>
								<td></td>
							</tr>
							<tr>
								<td>▶️ <img class="app_icon" src="<c:url value="/img/icon/telegram.png"/>" alt="">&nbsp;&nbsp;<span class="folder-name">Telegram</span></td>
								<td class="checkbox"><input type="checkbox" name="screenShotCd" value="telegram"></td>
								<td></td>
							</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>

<script type="text/javascript">
	$(document).ready(function () {
		$('#searchStr').enter(function () {
			getAgentService();
		});
		$('#searchStrBtn').click(function (){
			if($('#screenShotTab').parent().hasClass("active")) getDefaultPolicy();
			else getAgentService();
		});
		$('#applyBtn').click(function (){
			if($('#screenShotTab').parent().hasClass("active")) {
				ui.confirmMsg('<s:message code="common.msg.confirm.apply"/>', '', '', function(rs) {
					if (rs) {
						ui.on('screenShotList');
						ui.get({
							url: 'saveAgentDefaultConfig.xcn',
							agentId: 'DEFAULT',
							confId: 'clipboard.screenshotapps',
							confVal: JSON.stringify(getScreenShotValues()),
							success: function (data, total) {
								ui.alertMsg('<s:message code="common.msg.applied"/>');
							},
							error: function (status, message) { ui.alertMsg(message); },
							complete: function () {ui.off('screenShotList');}
						});
					}
				});
			} else {
				ui.confirmMsg('<s:message code="common.msg.confirm.apply"/>', '', '', function(rs) {
					if (rs) {
						ui.on('webList');
						ui.get({
							url: 'applyAgentService.xcn',
							serviceLogging: JSON.stringify(getCheckboxValues()),
							success: function (data, total) {
								ui.alertMsg('<s:message code="common.msg.applied"/>');
								getAgentService();
							},
							error: function (status, message) { ui.alertMsg(message); },
							complete: function () { ui.off('webList'); }
						});
					}
				});
			}
		});
		getAgentService();
		getDefaultPolicy();
	});

	function getDefaultPolicy() {
		ui.on('screenShotList');
		ui.get({
			url: 'getDefaultPolicy.xcn',
			success: function (data) {
				$('input[name="screenShotCd"]').prop('checked', false);
				const apps = JSON.parse(data.find(item => item.confId === "clipboard.screenshotapps")?.confVal);
				if ($.isArray(apps) && apps.length) {
					$.each(apps, function (i, val) {
						$('input[name="screenShotCd"][value="' + val + '"]').prop('checked', true);
					});
				}
			},
			error: function (status, message) {ui.alertMsg(message);},
			complete: function () {ui.off('screenShotList');}
		});
	}


	function getAgentService() {
		ui.on('webList');
		ui.get({
			url: 'getAgentService.xcn',
			searchStr : $('#searchStr').val(),
			success: function (data) {
				const excludedGroupCds = ['X', 'U', 'B', 'M', 'Z', 'F', 'Y'];
				renderServiceTree(data.filter(item => !excludedGroupCds.includes(item.groupCd)));
				updateChildCounts();
			},
			error: function (status, message) {ui.alertMsg(message);},
			complete: function () {ui.off('webList');}
		});
	}

	function renderServiceTree(data) {
		const grouped = {};
		data.forEach(item => {
			if (!grouped[item.groupCd]) {
				grouped[item.groupCd] = {groupNm: item.groupNm, groupCd:item.groupCd, loggingYn:item.loggingYn, children: []};
			}
			grouped[item.groupCd].children.push(item);
		});

		const $tbody = $('#tree-table tbody');
		$tbody.empty();
		Object.values(grouped).forEach(group => {
			const $groupRow = $(`
				<tr>
					<td class="toggle-btn" onclick="toggle(this)">▶️ 📂 <span class="folder-name"></span>(<span class="child-count"></span>)</td>
					<td class="checkbox"><input type="checkbox" name="serviceCd" value="" checked></td>
					<td></td>
				</tr>
			`);
			$groupRow.find('.child-count').text(group.children.length);
			$groupRow.find('.folder-name').text(group.groupNm);
			$groupRow.find('input[name="serviceCd"]').val(group.groupCd).prop('checked', group.loggingYn === 'Y');
			$tbody.append($groupRow);
			group.children.forEach(child => {
				const $childRow = $('<tr class="tree-node" style="display:none;"><td class="indent-1"></td><td></td><td></td></tr>');
				$childRow.find('.indent-1').text('📁 ' + child.serviceNm);
				$tbody.append($childRow);
			});
		});
	}

	//✅ 1. 하위 노드 수 자동 계산 (jQuery)
	function updateChildCounts() {
		$('#tree-table tr').each(function () {
			const $row = $(this);
			const $span = $row.find('.child-count');
			if ($span.length) {
				let count = 0, $next = $row.next();
				while ($next.length && $next.hasClass('tree-node')) {
					count++;
					$next = $next.next();
				}
				$span.text(count);
			}
		});
	}

	function toggle(el) {
		const $row = $(el).closest('tr');
		let $next = $row.next();
		const children = [];
		while ($next.length && $next.hasClass('tree-node')) {
			children.push($next);
			$next = $next.next();
		}
		const isExpanded = $row.hasClass('expanded');
		$row.toggleClass('expanded');
		$(el).html($(el).html().replace(isExpanded ? '🔽' : '▶️', isExpanded ? '▶️' : '🔽'));
		children.forEach($tr => isExpanded ? $tr.hide() : $tr.show());
	}

	function getCheckboxValues() {
		const result = [];
		$('input[name="serviceCd"]').each(function () {
			const value = $(this).val();
			const loggingYn = $(this).is(':checked') ? "Y" : "N";
			result.push({serviceCd : value, loggingYn:loggingYn});
		});
		return result;
	}

	function getScreenShotValues() {
		const result = [];
		$('input[name="screenShotCd"]').each(function () {
			if($(this).is(':checked')) result.push($(this).val());
		});
		return result;
	}

	$(".nav-tabs a").click(function () {
		if($(this).prop("id") === 'screenShotTab') $('#searchStr').prop('disabled', true);
		else $('#searchStr').prop('disabled', false);
	});
</script>