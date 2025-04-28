<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<script type="text/javascript">
	$(document).ready(function () {
		$('#searchConsumerNm').enter(function () {
			getAgentConsumerList();
		});
		$('#consumerNmBtn').click(function () {
			getAgentConsumerList();
		});
		$('#secretInsertBtn').click(function () {
			$('#consumerNm input[type=text]').val('');
			$('#consumerPop').attr('mode', 'insert').modal('show');
			setTimeout(function () {
				$("#consumerNm").focus();
			}, 500);
		});

		$('#secretDeletePopBtn').click(function(){
			ui.confirmMsg('삭제 하시겠습니까?', '', '', function (rs) {
				const data = grid.getRowData(grid.Row);
				ui.get({
					url: 'deleteAgentConsumer.xcn',
					consumerId: data.consumerId,
					success: function (data, total) {
						ui.alertMsg('<s:message code="common.msg.deleted"/>');
						$('#consumerViewPop').modal('hide');
						getAgentConsumerList();
					},
					error: function (status, message) {
						ui.alertMsg(message);
					},
					complete: function () {
						grid.off();
					}
				});
			});
		});

		$('#secretSavePopBtn').click(function () {
			const consumerNm = $('#consumerNm').val().ltrim().rtrim();
			const expireDate = $('#expireDate').val().ltrim().rtrim();
			if (consumerNm === '') {
				ui.alertMsg('고객사 이름을 입력하세요.');
				$('#consumerNm').focus();
				return false;
			}
			if (expireDate === '') {
				ui.alertMsg('만료 일자를 입력하세요.');
				$('#expireDate').focus();
				return false;
			}

			const confirmMessage = '<s:message code="common.msg.confirm.add"/>';
			ui.confirmMsg(confirmMessage, '', '', function (rs) {
				if (rs) {
					grid.on();
					ui.get({
						url: 'insertAgentConsumer.xcn',
						consumerNm: $('#consumerNm').val(),
						limitAgentCount: $('#limitAgentCount').val(),
						expireDate: $('#expireDate').val(),
						success: function (data, total) {
							ui.alertMsg('<s:message code="common.msg.saved"/>');
							$('#consumerPop').modal('hide');
							getAgentConsumerList();
						},
						error: function (status, message) {
							ui.alertMsg(message);
						},
						complete: function () {
							grid.off();
						}
					});
				}
			});
		});
		getAgentConsumerList();
	});
</script>
<body>

<div class="modal" id="consumerPop" tabindex="-1" role="dialog" aria-labelledby="consumerPop">
	<div class="modal-content">
		<div class="modalHead">
			<h2>고객사 등록</h2>
			<span class="close" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalCon">
			<div class="modalTop" style="height: 16px;">
				<p>
					<span class="red_dot veralign_middle"></span>
					<s:message code="common.required.msg"/>
				</p>
			</div>
			<div class="modalbody">
				<div class="row">
					<div class="col-35">
						<label for="consumerNm" class="fname">고객사 이름</label>
						<span class="red_dot"></span>
					</div>
					<div class="col-65">
						<input type="text" class="w100" name="consumerNm" id="consumerNm" maxlength="125">
					</div>
				</div>
				<div class="row">
					<div class="col-35">
						<label for="limitAgentCount" class="fname">Agent Count Limit</label>
						<span class="red_dot"></span>
					</div>
					<div class="col-65">
						<input type="number" class="w100" name="limitAgentCount" id="limitAgentCount" style="font-size: 12px;">
					</div>
				</div>
				<div class="row">
					<div class="col-35">
						<label for="expireDate" class="fname">Agent Expire Date</label>
						<span class="red_dot"></span>
					</div>
					<div class="col-65">
						<input type="date" class="w100" name="expireDate" id="expireDate">
					</div>
				</div>
			</div>
			<div class="modalfooter">
				<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
				<button type="button" class="pop_btn02" accesskey="S" id="secretSavePopBtn"><s:message code="common.msg.save"/></button>
			</div>
		</div>
	</div>
</div>

<div class="modal" id="consumerViewPop" tabindex="-1" role="dialog" aria-labelledby="consumerViewPop">
	<div class="modal-content">
		<div class="modalHead">
			<h2>고객사 정보</h2>
			<span class="close" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalCon">
			<div class="row">
				<div class="col-35">
					<label for="view_consumerNm" class="fname">고객사 이름</label>
				</div>
				<div class="col-65">
					<input type="text" class="w100" name="view_consumerNm" id="view_consumerNm" maxlength="125">
				</div>
			</div>
			<div class="row">
				<div class="col-35">
					<label for="view_consumerToken" class="fname">Agent Consumer Token</label>
				</div>
				<div class="col-65">
					<input type="text" class="w100" name="view_consumerToken" id="view_consumerToken">
				</div>
			</div>
			<div class="row">
				<div class="col-35">
					<label for="view_apiToken" class="fname">Agent API Token</label>
				</div>
				<div class="col-65">
					<input type="text" class="w100" name="view_apiToken" id="view_apiToken">
				</div>
			</div>
			<div class="row">
				<div class="col-35">
					<label for="view_limitAgentCount" class="fname">Agent Limit</label>
				</div>
				<div class="col-65">
					<input type="number" class="w100" name="view_limitAgentCount" id="view_limitAgentCount" style="font-size: 12px;">
				</div>
			</div>
			<div class="row">
				<div class="col-35">
					<label for="expireDate" class="fname">Agent 만료일</label>
				</div>
				<div class="col-65">
					<input type="date" class="w100" name="view_expireDate" id="view_expireDate">
				</div>
			</div>
		</div>
		<div class="modalfooter">
			<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
			<button type="button" class="pop_btn02" accesskey="S" id="secretDeletePopBtn"><s:message code="common.msg.delete"/></button>
		</div>
	</div>
</div>

<div>
	<div class="searchArea">
		<div>
			<div class="searchSub" style="width:100%;">
				<div style="display: flex; align-items: center;">
					<input type="text" placeholder="고객사 이름을 입력하세요." id="searchConsumerNm" style="width: 280px; margin-right: 8px;">
					<button class="form_btn01" type="button" accesskey="K" id="consumerNmBtn"><s:message code="common.search"/></button>
				</div>
				<div class="btnform">
					<button type="button" class="btn01" accesskey="A" id="secretInsertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
				</div>
			</div>
		</div>
	</div>
	<div class="content" style="overflow:hidden;">
		<div>
			<div class="contentSub ">
				<div id="agentConsumerGrid" class="slickGrid gridArea"></div>
			</div>
		</div>
	</div>
</div>
</body>

<script type="text/javascript">
	const grid = new Xgrid('agentConsumerGrid', contextRoot);
	grid.colAdd('consumerId', '고객사 아이디', 110, 'center', false, 'nomal');
	grid.colAdd('consumerNm', '고객사 이름', 200, 'center', false, 'link');
	grid.colAdd('consumerToken', 'Consumer Token', 350, 'center', false, 'nomal');
	grid.colAdd('apiToken', 'API Key', 350, 'center', false, 'nomal');
	grid.colAdd('limitAgentCount', 'Agent Limit', 150, 'center', false, 'nomal');
	grid.colAdd('expireDate', 'Agent 만료일', 150, 'center', false, 'nomal');
	grid.colAdd('createUser', '생성 계정', 130, 'center', false, 'nomal');
	grid.colAdd('createDt', '생성 시간', 130, 'center', false, 'nomal');

	grid.loadExportMenu('고객사 등록 정보');
	grid.loadHeader(false);
	grid.initData('<s:message code="SETTING.SECRET_KEY"/>');
	grid.onClick = function () {
		if (grid.Col === grid.ColIndex('consumerNm')) modify();
	}

	grid.onDblClick = function () {
		modify();
	}
	function modify(){
		const data = grid.getRowData(grid.Row);
		$('#view_consumerNm').val(data.consumerNm);
		$('#view_consumerToken').val(data.consumerToken);
		$('#view_apiToken').val(data.apiToken);
		$('#view_limitAgentCount').val(data.limitAgentCount);
		$('#view_expireDate').val(data.expireDate);

		$('#consumerViewPop').modal('show');
	}

	function getAgentConsumerList() {
		grid.on();
		ui.get({
			url: 'getAgentConsumerList.xcn',
			consumerNm: $('#searchConsumerNm').val(),
			success: function (data) {
				grid.setData(data);
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {grid.off();}
		});
	}
</script>