<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>

<style type="text/css">
	.radio-inline {
		padding-left: 0px;
	}
	.radio input {
		vertical-align: middle;
	}

	.tab-content {
		display: none;
	}

	.tab-content.active {
		display: inherit;
	}

	#regexInfo2 {
		white-space: pre-line;  /* 줄바꿈 문자와 연속 공백을 처리 */
		font-size: 13px;
	}
</style>
<script type="text/javascript">
	var searchFlag = false;
	var currentTab;
	var gridObj;
	var url;
	var mode = 'insert';
	var pmenu_id = 'POLICY_SETUP';
	var menu_id = 'POLICY_PATTERN';
	var codeList=[];

	$(document).ready(function () {
		getCodeList("regexp");

		$('.print_link2').click(function () {
			if (gridPattern.Rows == 0) {
				alert('<s:message code="common.msg.nodata"/>');
				return;
			}
			var title = $('.nav-tabs .active a').text();
			gridPattern.print(title, pmenu_id, menu_id);
		});
		$('.excel_link2').click(function () {
			var title = $('.nav-tabs .active a').text();
			setTimeout(function () {
				excelDownLoad(gridPattern, title, pmenu_id, menu_id);
			}, 200);
		});
		$('.csv_link2').click(function () {
			var title = $('.nav-tabs .active a').text();
			setTimeout(function () {
				csvDownLoad(gridPattern, title, pmenu_id, menu_id);
			}, 200);
		});
		$('.cell_link2').click(function () {
			var title = $('.nav-tabs .active a').text();
			setTimeout(function () {
				cellDownLoad(gridPattern, title, pmenu_id, menu_id);
			}, 200);
		});
		$('.pdf_link2').click(function () {
			var title = $('.nav-tabs .active a').text();
			setTimeout(function () {
				pdfDownLoad(gridPattern, title, pmenu_id, menu_id);
			}, 200);
		});

		$('#searchBtn').click(function () {
			getData();
		});
		$('#searchStr').enter(function () {
			getData();
		});


		$("#regexType").on("change", function(){
			$('#searchStr').val('');
			currentTab=$("#regexType option:selected").val();
			getData();
		});


		$('#insertBtn').click(function () {
			$('.savePopBtn').prop('disabled', false);
			mode = 'insert';
			$('#info').html(getSelectOption(codeList));

			$("#info").val($("#regexType option:selected").val());
			if($("#regexType option:selected").val()!=''){
				$("#info").val($("#regexType option:selected").val());
			}

			$('#info').prop('disabled', false);

			<%--if($("#regexType option:selected").val()==''){--%>
			<%--	ui.alertMsg('<s:message code="common.select.pattern"/>')--%>
			<%--	return;--%>
			<%--}--%>
			document.getElementById('info').placeholder = $("#regexType option:selected").text();

/*			if ($("#regexType").val() == 'PN') {
				$('#regexInfo').text('<s:message code="patternExpect.msg.pntab"/>');
			}else if ($("#regexType").val() == 'SN') {
				$('#regexInfo').text('<s:message code="patternExpect.msg.sntab"/>');
			}else if ($("#regexType").val() == 'FN') {
				$('#regexInfo').text('<s:message code="patternExpect.msg.fntab"/>');
			}else if ($("#regexType").val() == 'CN') {
				$('#regexInfo').text('<s:message code="patternExpect.msg.cntab"/>');
			}else if ($("#regexType").val() == 'DN') {
				$('#regexInfo').text('<s:message code="patternExpect.msg.dntab"/>');
			}else{
				$('#regexInfo').text('<s:message code="patternExpect.msg.other"/>');
			}*/

			$('#regexInfo2').text('<s:message code="patternExpect.msg.ast"/>');

			$('#privateType, #pattern, #patternLogSeq').val('');
			$("#PatternExpectModal").modal('show');
		});

		$('.savePopBtn').click(function () {
			$('.savePopBtn').prop('disabled', true);
			var url;
			var popFormId;
			url = mode == 'insert' ? 'insertPatternExcept.xcn' : 'updatePatternExcept.xcn';
			saveData(url, "PatternPopForm");
		});


		$('#deleteBtn').click(function () {
			$('#deleteBtn').prop('disabled', true);

			var rows = gridPattern.getSelectedRows();
			if (rows.length == 0) {
				ui.alertMsg('<s:message code="filterInfo.msg.choose.deleteitem"/>');
				$('#deleteBtn').prop('disabled', false);
				return;
			}

			ui.confirmMsg('<s:message code="filterInfo.msg.confirm.deleteitem"/>', '', '', function (rs) {
				if (rs) {
					gridPattern.on();
					ui.get({
						url: 'deletePatternExcept.xcn',
						deleteData: JSON.stringify(rows),
						success: function (data, total) {
							ui.alertMsg('<s:message code="common.msg.deleted"/>');
							getData();
						},
						error: function (status, message) {
							ui.alertMsg(message);
						},
						complete: function () {
							$('#deleteBtn').prop('disabled', false);
							gridPattern.off();
						}
					});

				} else {
					$('#deleteBtn').prop('disabled', false);
				}
			});
		});
		getData();
	});


	function validationCheck() {
		$('#pattern').val($.trim($('#pattern').val()));

		var str = $('#pattern').val();

		if (str.length === 0) {
			ui.alertMsg('<s:message code="patternExpect.msg.noVal"/>');
			return;
		}

		if (str.split('').every(char => char === '*')) {
			ui.alertMsg('<s:message code="patternExpect.msg.allAst"/>');
			return;
		}

/*
		if (!(str[0] === '*' || str[str.length - 1] === '*')) {

			if (currentTab == 'PNTab') {
				const pattern = /\b([MSRGD][0-9]{8}|[A-Za-z]{2}[0-9]{7}|[MSRGD][A-Za-z][0-9]{7}|[MSRGD][0-9]{1}[A-Za-z][0-9]{6}|[MSRGD][0-9]{2}[A-Za-z][0-9]{5}|[MSRGD][0-9]{3}[A-Za-z][0-9]{4}|[MSRGD][0-9]{4}[A-Za-z][0-9]{3}|[MSRGD][0-9]{5}[A-Za-z][0-9]{2}|[MSRGD][0-9]{6}[A-Za-z][0-9]{1}|[MSRGD][0-9]{7}[A-Za-z])\b/;

				if (!pattern.test(str)) {
					ui.alertMsg('<s:message code="patternExpect.msg.noRegex"/>');
					return;
				}
			} else if (currentTab == 'SNTab') {
				const pattern = /\b[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])[-!@#$%^*|/?~_ ]*?[1-4][0-9]{6}\b/;

				if (!pattern.test(str)) {
					ui.alertMsg('<s:message code="patternExpect.msg.noRegex"/>');
					return;
				}
			} else if (currentTab == 'FNTab') {
				const pattern = /\b[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])[ -]*?[5-8][0-9]{6}\b/;

				if (!pattern.test(str)) {
					ui.alertMsg('<s:message code="patternExpect.msg.noRegex"/>');
					return;
				}
			} else if (currentTab == 'CNTab') {
				const pattern = /\b(?:[0-9][ -]*?){13,16}\b/;

				if (!pattern.test(str)) {
					ui.alertMsg('<s:message code="patternExpect.msg.noRegex"/>');
					return;
				}
			} else if (currentTab == 'DNTab') {
				const pattern = /\b([12][0-9]-[0-9]{2}-[0-9]{6}-[0-9]{2}|(서울|부산|경기|강원|충북|충남|전북|전남|경북|경남|제주|대구|인천|광주|대전|울산)\\s*[0-9]{2}-[0-9]{6}-[0-9]{2})\b/;

				if (!pattern.test(str)) {
					ui.alertMsg('<s:message code="patternExpect.msg.noRegex"/>');
					return;
				}
			}
		}*/
		return true;
	}


	function getCodeList(codeType) {
		ui.get({
			url: 'getCodeList.xcn',
			codeType: codeType,
			success: function (data, total) {
				$('#regexType').html(getSelectOption(data));
				$('#regexType').selectpicker('refresh');
				$('#regexType').html(getSelectOption(data));
				$('#regexType').selectpicker('refresh');

				codeList = data;
			},
			error: function (status, message) {
				ui.alertMsg('error:' + status);
			},
			complete: function () {
			}
		});
	}


	function saveData(url, popFormId) {
		if (!validationCheck()) {
			$('.savePopBtn').prop('disabled', false);
			return;
		}
		var privateType = $('#info option:selected').val();
		if (privateType == ''){
			ui.alertMsg('<s:message code="common.select.pattern"/>')
			return;
		}
		$('[name=privateType]').val(privateType);
		var message = mode == 'insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
		ui.confirmMsg(message, '', '', function (rs) {
			if (rs) {
				gridPattern.on();
				ui.post({
					url: url,
					data: $('#' + popFormId).serializeAll(),
					success: function (data, total) {
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						$("#PatternExpectModal").modal('hide');
						getData();
					},
					error: function (status, message) {
						ui.alertMsg(message);
					},
					complete: function () {
						gridPattern.off();
						$('.savePopBtn').prop('disabled', false);
					}
				});
			} else {
				$('.savePopBtn').prop('disabled', false);
			}
		});
	}


	function getData() {
		if (searchFlag) return;
		gridPattern.on();
		searchFlag = true;
		$('[name=privateType]').val(currentTab);
		ui.get({
			url: "getPatternExceptList.xcn",
			searchStr: $("#searchStr").val(),
			privateType: currentTab,
			offset: gridPattern.data.length,
			limit: gridPattern.pageSize,
			success: function (data, total) {
				gridPattern.setData(data);
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				searchFlag = false;
				gridPattern.off();
			}
		});
	}


	function getSelectOption(data) {
		var str = '';

		str+='<option value="" selected><s:message code="common.msg.all"/></option>';
		for (var i = 0; i < data.length; i++) {

			if (data[i].code != "DRM" && data[i].code != "ID" && data[i].code != "EF" && data[i].code != "EC"&& data[i].code != "IMEI"&& data[i].code != "MCN"&& data[i].code != "LTO"&& data[i].code != "LAO"&& data[i].code != "LF"&& data[i].code != "ID"&& data[i].code != "RS"
				&& data[i].code != "EF"&& data[i].code != "EC"
			) {

				str += '<option value="' + data[i].code + '">' + data[i].codeName + '</option>';
			}
		}
		return str;
	}

	var patternNameMap = {
		SN : '<s:message code="bodyview.sn"/>',
		CN : '<s:message code="bodyview.cn"/>',
		DN : '<s:message code="bodyview.dn"/>',
		FN : '<s:message code="bodyview.fn"/>',
		PN : '<s:message code="bodyview.pn"/>',
		MN : '<s:message code="bodyview.mn"/>',
		AN : '<s:message code="bodyview.an"/>',
		CRN : '<s:message code="bodyview.crn"/>',
		SSN : '<s:message code="bodyview.ssn"/>',
		IMEI : '<s:message code="bodyview.imei"/>',
		BRN : '<s:message code="bodyview.brn"/>',
		CPN : '<s:message code="bodyview.cpn"/>',
		MCN : '<s:message code="bodyview.mcn"/>',
	}
	/**
	 * 패턴명 찾기
	 * @param privateType
	 * @returns {string}
	 */
	function getName(privateType){
		var result = "(" + privateType + ")";
		if(patternNameMap[privateType] !== undefined){
			return patternNameMap[privateType] + result;
		}
		return result;
	}


</script>


</head>

<div class="modal" id="PatternExpectModal" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="PatternPopForm" onsubmit="return false;">
			<div class="modalHead">
				<h2><s:message code="patternExpect.pattern.title"/></h2>
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
							<label for="info" class="fname"><s:message code="bodyview.info.pattern"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<select id="info"></select>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="pattern" class="fname"><s:message code="patternExpect.pattern.info"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input   type="text" class="w100" name="pattern"  id="pattern" maxlength="128" placeholder="<s:message code="patternExpect.pattern.enter"/>" >
							<input type="hidden" id="patternLogSeq" name="patternLogSeq">
						</div>
					</div>
					<input type="hidden" name="privateType"/>
					<input type="hidden" name="tabId"/>
					<div class="info">
						<%--<div id="regexInfo" style="padding-left: 10px; color: #f25643;"> </div>--%>
					<%--	<br>--%>
						<div id="regexInfo2" style="padding-left: 10px; color: #f25643;"> </div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 savePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>

	<div class="searchArea">
		<div class="searchSub">
			<select id="regexType">
			</select>
			<input type="text" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr" style="width: 210px;">
			<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.search"/></button>
			<button type="button" class="btn01" accesskey="I" id="insertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
			<button type="button" class="btn02" accesskey="D" id="deleteBtn"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div id="patternList" style="height:100%;">
				<div id="patternListGrid" class="slickGrid gridArea"></div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	var gridPattern = new Xgrid('patternListGrid', contextRoot);
	gridPattern.onCheckBox();
	gridPattern.autoNumber();
	gridPattern.colAdd('privateType', '<s:message code="bodyview.info.pattern"/>', 200, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext){
		return getName(value);
	});
	gridPattern.colAdd('pattern', '<s:message code="patternExpect.pattern.info"/>', 200, 'center', false, 'link');
	gridPattern.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 180, 'center', false, 'nomal');
	gridPattern.colAdd('createUser', '<s:message code="report.msg.createUser"/>', 180, 'center', false, 'nomal');
	gridPattern.loadExportMenu('<s:message code="POLICY_SETUP.POLICY_PATTERN"/>');
	gridPattern.onClick = function () {
		if (gridPattern.Col == gridPattern.ColIndex('pattern')) {
			$('.savePopBtn').prop('disabled', false);
			mode = 'modify';
			$('[name=privateType]').val($("#regexType option:selected").val());

			$('#info').attr("placeholder",getName(gridPattern.getValue(gridPattern.Row, 'privateType')));
			$('#info').prop('disabled', true);


			$('#info').html(getSelectOption(codeList));
			$("#info").val(gridPattern.getValue(gridPattern.Row, 'privateType'));

			$('#pattern').val(gridPattern.getValue(gridPattern.Row, 'pattern'));
			$('#patternLogSeq').val(gridPattern.getValue(gridPattern.Row, 'patternLogSeq'));

			$("#PatternExpectModal").modal('show');
		}
	};
	gridPattern.loadHeader(true);
	gridPattern.initData('<s:message code="common.msg.search.click"/>');


</script>

