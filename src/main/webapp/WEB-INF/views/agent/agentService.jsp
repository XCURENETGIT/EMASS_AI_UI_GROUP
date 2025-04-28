<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<style>
	.slickGrid{
		overflow: auto;
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
				<div id="defaultPolicyGrid" class="slickGrid gridArea">
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
			getAgentService();
		});
		$('#applyBtn').click(function (){
			console.log(getCheckboxValues());
			ui.confirmMsg('<s:message code="common.msg.confirm.apply"/>', '', '', function(rs) {
				if (rs) {
					ui.on('tree-table');
					ui.get({
						url: 'applyAgentService.xcn',
						serviceLogging: JSON.stringify(getCheckboxValues()),
						success: function (data, total) {
							ui.alertMsg('<s:message code="common.msg.applied"/>');
							getAgentService();
						},
						error: function (status, message) { ui.alertMsg(message); },
						complete: function () { ui.off('tree-table'); }
					});
				}
			});
		});
		getAgentService();
	});

	function getAgentService() {
		ui.on('tree-table');
		ui.get({
			url: 'getAgentService.xcn',
			searchStr : $('#searchStr').val(),
			success: function (data) {
				const excludedGroupCds = ['X', 'U', 'B', 'M', 'Z', 'F'];
				renderServiceTree(data.filter(item => !excludedGroupCds.includes(item.groupCd)));
				updateChildCounts();
			},
			error: function (status, message) {ui.alertMsg(message);},
			complete: function () {ui.off('tree-table');}
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
</script>