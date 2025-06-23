<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>
<!DOCTYPE html>
<html lang="ko">
<head>

	<style>

		#similarityDiv {
			display: flex;
			flex-direction: column;
			align-items: flex-start;
		}

		.container {
			position: relative;
			width: fit-content;
		}

		#similarityText {
			width: 1344px;
			height: 180px;
			margin-top: 8px;
			resize: none;
			padding: 10px; /* Add padding to ensure text does not overlap */
			box-sizing: border-box;
		}

		.custom-placeholder {
			position: absolute;
			top: 0;
			left: 0;
			right: 0;
			bottom: 0;
			padding: 10px;
			color: #aaa;
			pointer-events: none;
			display: flex;
			flex-direction: column;
			justify-content: center;
			white-space: pre-wrap; /* Preserve line breaks */
			overflow: hidden;
		}

		#textCount {
			color: #a9a9a9;
			position: absolute;
			bottom: 5px;
			right: 10px;
			padding: 2px 5px; /* Optional: adds padding around the count text */
		}

		.glyphicon-question-sign:before {
			padding-right: 5px;
		}

		.HelpDivBody {
			font-size: 13px;
		}

		.helpContent {
			display: flex;
			align-items: center;
			margin-bottom: 10px;
			line-height: 16px;
			font-size: 14px;
		}
	</style>
	<title></title>
	<script type="text/javascript">
		var searchFlag = false;
		var similarityText, startDate, endDate, tab;

		$(document).ready(function () {

			initDateTimePicker('startdate', 'enddate');

			$('#clearBtn').click(function () {
				$('#startdate').val(new Date().format('yyyy-mm-dd'));
				$('#enddate').val(new Date().format('yyyy-mm-dd'));
				$('#similarityText').val('');
				$('#percent').val('60');
				$('#minDocFreq').val('');
				$('#maxDocFreq').val('');
				$('#minTermFreq').val('');

			});

			$('#recommendBtn').click(function() {
				$('#recommendDiv').show();
			});
			$('#helpDivCloseBtn').click(function(){
				$('#recommendDiv').hide();
			});

			$('#dateYesterday').click(function () {
				$('#startdate').val(addDay(-1));
				$('#enddate').val(addDay(-1));
			});

			$('#dateToday').click(function (e) {
				$('#startdate').val(addDay(0));
				$('#enddate').val(addDay(0));
			});

			$('#dateWeek').click(function () {
				$('#startdate').val(addDay(-7));
				$('#enddate').val(addDay(0));
			});

			$('#dateMonth').click(function () {
				$('#startdate').val(addMonth2(-1));
				$('#enddate').val(addDay(0));
			});

			$('#searchBtn').click(function () {
				getData('Y');
			});

			//textarea 자동 글자수 세기
			$('#similarityText').keyup(function (e) {
				let content = $(this).val();

				if (content.length == 0 || content == '') {
					$('#placeholder').css('display','');
					$('#textCount').text('0 <s:message code='similarity.text.count'/>');
				} else {
					$('#placeholder').css('display','none');
					$('#textCount').text(content.length + '<s:message code='similarity.text.count'/>');
				}

				if (content.length > 500) {
					$(this).val($(this).val().substring(0, 500));
					alert('<s:message code='similarity.text.maxCount'/>');
				}
				;
			});

			$('#typeTab li a').on('click', function () {
				tab = $(this).attr('id');
				getData();
			});
		});

		// 유사도 분석 문장 데이터 조회
		function getData(flag) {
			if (searchFlag) return;

			similarityText = $('#similarityText').val().trim();
			startDate = $('#startdate').val().replaceAll("-", "");
			endDate = $('#enddate').val().replaceAll("-", "");


			if (similarityText == '') {
				ui.alertMsg('<s:message code="similarityText.text.null"/>');
				return;
			}
			if (startDate > endDate) {
				ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
				return;
			}
			grid.on();
			searchFlag = true;
			ui.get({
				url: 'getSimilarity.xcn',
				startDate: startDate + "000000",
				endDate: endDate + "235959",
				tab: tab,
				minTermFreq : $('#minTermFreq').val(),
				minDocFreq : $('#minDocFreq').val(),
				maxDocFreq : $('#maxDocFreq').val(),
				percent : $('#percent').val(),
				similarityText: similarityText,
				success: function (data, total) {
					grid.setData(data.emass);
					searchFlag = false;
				},
				error: function (status, message) {
					ui.alertMsg(message);
				},
				complete: function () {
					grid.off();
				}
			});
		}

		function viewer_newOpen(row, selectedGrid) {
			var msgid = grid.getValue(row, 'msgid');
			openMessageBody('', msgid, '');
		}

		function fileInfoViewer( row, selectedGrid ){
			var msgid = grid.getValue(row, 'msgid');
			if(grid.getValue(row, 'attachcnt') == '') return;

			var url    = '<c:url value="/ems/fileInfoPop.do?msgId='+msgid+ '"/>';
			var pop = fnOpenWindow(url, 'fileInfoPop', 1015, 400, 'resize');
		}

		function ocrFileInfoViewer( row, selectedGrid ){
			var msgid = grid.getValue(row, 'msgid');
			if(grid.getValue(row, 'ocr_attach_cnt') == '') return;

			var url    = '<c:url value="/ems/fileInfoPop.do?msgId='+msgid +'"/>';
			var pop = fnOpenWindow(url, 'ocrFileInfoPop', 1015, 400, 'resize');
		}

		function userInfoViewer(row, type, selectedGrid){
			var msgid = grid.getValue(row, 'msgid');
			if(grid.getValue(row, type) == '') return;

			var url    = '<c:url value="/ems/userInfoPop.do?msgId='+msgid+'&type='+type+'"/>';
			return fnOpenWindow(url, type+'InfoPop', 1000, 370, 'resize');
		}

		function interestUserInfoViewer( row, selectedGrid ){
			var userid = grid.getValue(row, 'userid');
			if(grid.getValue(row, 'userid') == '') return;
			var url    = '<c:url value="/ems/interestUserInfoPop.do?userid='+userid+'"/>';
			var pop = fnOpenWindow(url, 'interestUserInfoPop', 1015, 400, 'resize');
		}

		function regexpInfoViewer(row, selectedGrid){
			var msgid = grid.getValue(row, 'msgid');
			if(grid.getValue(row, 'pi_total') == '') return;

			var url = '<c:url value="/ems/regexpInfoPop.do?msgId='+msgid+'"/>';
			return fnOpenWindow(url, 'regexpInfoPop', 1100, 620, 'resize');
		}

	</script>
</head>
<body class="mini-navbar">
<div>
	<div class="searchArea">
		<div class="searchSub">
			<div id="startDatePicker"><input type="text" class="txt_center" id="startdate" name='startdate' style="width: 110px;">
				<span class="hyphen">~</span></div>
			<div id="endDatePicker"><input type="text" class="txt_center" id="enddate" name='enddate' style="width: 110px;"></div>
			<select id="percent" style="width: 120px;">
				<option value="60"><s:message code="condition.info.similarity"/> 60%~</option>
				<option value="80"><s:message code="condition.info.similarity"/> 80%~</option>
				<option value="100"><s:message code="condition.info.similarity"/> 100%</option>
			</select>
			<div class="form-group optiotab">
				<button type="button" id="dateYesterday" accesskey="Y" style="width:85px;"><s:message code="condition.yesterday"/></button>
				<button type="button" id="dateToday" accesskey="T" style="width:85px;"><s:message code="condition.today"/></button>
				<button type="button" id="dateWeek" accesskey="W"><s:message code="condition.week" arguments="1" argumentSeparator="|"/></button>
				<button type="button" id="dateMonth" accesskey="M"><s:message code="condition.month" arguments="1" argumentSeparator="|"/></button>
			</div>
			<button class="form_btn01" id="searchBtn"><s:message code="common.msg.search"/></button>
			<button class="form_btn02" id="clearBtn"><s:message code="condition.reset"/></button>
		</div>
		<div class="searchSub">
			<div style="padding-top: 5px; font-size: 13px; display: flex; align-items: center;">
				<img  style="width: 16px; margin-right: 5px;" class="areaBtn" id="recommendBtn" src="<c:url value="/img/icon/question.png"/>">
				<label for="minDocFreq"><s:message code="recommend.info.minDocFreq"/>: &nbsp;</label>
				<input type="number" id="minDocFreq" style="width: 80px; text-align: center;" placeholder="1" /> &nbsp;
				<label for="maxDocFreq"><s:message code="recommend.info.maxDocFreq"/>:  &nbsp;</label>
				<input type="number" id="maxDocFreq" style="width: 80px; text-align: center;" placeholder="20" /> &nbsp;
				<label for="minTermFreq"><s:message code="recommend.info.minTermFreq"/>:  &nbsp;</label>
				<input type="number" id="minTermFreq" style="width: 80px; text-align: center;" placeholder="1" /> &nbsp;
			</div>
		</div>
		<div id="recommendDiv" style="position: absolute; width: 500px; height: 308px; display: none; font-size: 13px; background-color: white; z-index: 1040;border: 1px solid #555;">
			<div class="recommendHeader" style="height:30px;background-color:black;color:#fff;padding-left:10px;line-height:30px;font-weight: bold; display: flex; align-items: center;">
				<div style="width:480px;">
					<i class="glyphicon glyphicon-question-sign"></i>&nbsp;<s:message code="common.msg.similar"/> <s:message code="common.msg.help"/>
				</div>
				<div id="helpDivCloseBtn" style="position:absolute; right:10px;">
					<span class="glyphicon glyphicon-remove-circle" style="cursor:pointer;font-size:13px;" aria-hidden="true"></span>
				</div>
			</div>
			<div style="width:100%; padding:10px;" class="recommendDivBody">
				<div style="display: flex; flex-direction: column; justify-content: center; margin-bottom: 5px;">
					<div><s:message code="recommend.info.exeampl1"/></div>
					<div style="padding-top: 10px;"><s:message code="recommend.info.exeampl2"/> </div>
					<div style="padding-top: 10px;"><s:message code="recommend.info.exeampl3"/></div>
				</div>
			</div>
		</div>
		<div class="searchSub">
			<div id="similarityDiv">
				<span style="font-size: 16px; font-weight: bold; padding-top: 5px;">▼<s:message code="similarityText.text.null"/> </span>
				<div class="container">
					<textarea id="similarityText"></textarea>
					<div class="custom-placeholder" id="placeholder">
						<span class="helpContent"><s:message code="similarityText.msg.example1"/></span>
						<span class="helpContent"><s:message code="similarityText.msg.example2"/></span>
						<span class="helpContent"><s:message code='similarityText.msg.example3'/></span>
						<span class="helpContent"><s:message code='similarityText.msg.example4'/></span>
						<span class="helpContent"><s:message code='similarityText.msg.example5'/></span>
					</div>
					<span id="textCount">0<s:message code='similarity.text.count'/></span>
				</div>
			</div>

		</div>

	</div>

	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<div class="subtab">
					<ul class="nav nav-tabs codeTab" id="typeTab">
						<li class="active" style="text-align: center;"><a data-toggle="tab" id="allTab"><s:message code="common.msg.all"/></a></li>
						<li style=" text-align: center"><a data-toggle="tab" id="subjectTab"><s:message code="condition.subject"/></a></li>
						<li style=" text-align: center"><a data-toggle="tab" id="bodyTab"><s:message code="condition.body"/></a></li>
						<li style=" text-align: center"><a data-toggle="tab" id="fileTab"><s:message code="condition.attach"/></a></li>
					</ul>
				</div>
			</div>
			<div id="recommendListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>
</body>

<script type="text/javascript">


	var grid = new Xgrid('recommendListGrid', contextRoot);
	grid.autoNumber();
	grid.colAdd('msgid', '<s:message code="common.msg.msgid"/>', 100, 'left', false, 'nomal');
	grid.colAdd('epmsg_type', '<s:message code="condition.epmsgType.list"/>', 100, 'center', true, 'nomal');
	grid.colAdd('xrootmtr', '<s:message code="common.msg.xrootmtr"/>', 100, 'left', true, 'nomal');
	grid.colAdd('interestUserYn', '<s:message code="message.msg.interest"/>', 40, 'center', false, 'link', function (row, cell, value, columnDef, dataContext) {
		if (value == 'N') return '';
		var value = grid.getValue(row, 'interestGroupColor')
		var str = '';
		if (value != null && value != undefined && value != '') {
			var v = value.split(',');
			for (var i = 0; i < v.length; i++) {
				str += '<span style="display:inline-block; width: 11px; height: 11px; margin-left: 1px; background-color:' + v[i] + '"></span>';
			}
		}
		return str;
	});

	if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ) {
		grid.colAdd('ml_confd_class', '<s:message code="condition.infotype"/>', 100, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
			if (infoFeedbackMode == 'E'){
				if (value == '3') return '<s:message code="condition.info.class4"/>';
				else if (value == '4') return '<s:message code="condition.info.class3"/>';
				else if (value == '2') return '<s:message code="condition.info.class2"/>';
				else if (value == '1') return infoHynixConf == 'true' ? '<s:message code="condition.info.Y"/>' : '<s:message code="condition.info.class1"/>';
				else if (value == '0') return '<s:message code="condition.info.N"/>'; // for hynix (대외비 문서)
				else return '<s:message code="common.msg.noinfo"/>';
			}else {
				if (value == '4') return '<s:message code="condition.info.class4"/>';
				else if (value == '3' || value == '2') return '<s:message code="condition.info.class3"/>';
				else if (value == '1') return infoHynixConf == 'true' ? '<s:message code="condition.info.Y"/>' : '<s:message code="condition.info.class1"/>';
				else if (value == '0') return '<s:message code="condition.info.N"/>'; // for hynix (대외비 문서)
				else return '<s:message code="common.msg.noinfo"/>';
			}
		});

		if (infoFeedbackLlm == 'false') {
			grid.colAdd('ml_confd_feedback', '<s:message code="condition.feedback"/>', 110, 'left', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
				if (value == '1') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class1"/>';
				else if (value == '2') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class2"/>';
				else if (value == '4') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class3"/>';
				else if (value == '3') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class4"/>';
				else if (value == '0') return '<div class="feedbackCorrect"></div>&nbsp;<s:message code="condition.info.feedback0"/>';
				else if (value == '9') return '<div class="feedbackDefer"></div>&nbsp;<s:message code="condition.info.feedback9"/>';
				else return '-';
			});
		}
	}
	grid.colAdd('confidence', '<s:message code="condition.info.similarity"/>(%)', 100, 'right', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return Math.floor(parseInt(value));
	}, {sorter:sortUtil.numeric});

	grid.colAdd('subject', '<s:message code="condition.subject"/>', 410, 'left', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		var body_snippet = grid.getValue(row, 'body_snippet').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
		if (body_snippet.length > 100) body_snippet = body_snippet.substring(0, 1024) + '...';

		if (value.length > 1024) value = value.substring(0, 1024) + '...';
		value = value.replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');

		//예약어 Highlight 처리
		var kwds = grid.getValue(row, 'kwds');
		value = value, kwds;
		value = value;
		if (value == undefined) value = '';

		var rtnVal = '<span title="' + body_snippet + '" onclick="" class="subject_read' + grid.getValue(row, 'readYn') + '">' + value + '</span>&nbsp;<a href="javascript:void(0);" onclick="viewer_newOpen(' + row + ')" class="glyphicon glyphicon-new-window new-window"></a>';
		if ((isConsent() && grid.getValue(row, 'consentNo') == '') || !isDetailView()) rtnVal = '<span>' + value + '</span>';

		return rtnVal;
	});
	<%--grid.colAdd('content', '<s:message code="condition.info.feedback.content"/>', 400, 'left', false, 'nomal');--%>
	grid.colAdd('attachcnt', '<s:message code="message.msg.file"/>', 35, 'center', false, 'link', function (row, cell, value, columnDef, dataContext) {
		if (value == '0') return '';
		else return value.comma();
	});
	grid.colAdd('inside', '<s:message code="message.msg.inout"/>', 55, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		if (value == 'N') return '<s:message code="message.msg.out"/>';
		else if (value == 'Y') return '<s:message code="message.msg.in"/>';
		else return '-';
	});
	grid.colAdd('direction_svc', '<s:message code="condition.receive_send"/>', 55, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		if (value == 'I') return '<s:message code="condition.receive"/>';
		else if (value == 'O') return '<s:message code="condition.send"/>';
		else return '-';
	});
	grid.colAdd('svcNm', '<s:message code="condition.service"/>', 180, 'center', false, 'nomal');
	grid.colAdd('ctimeFormat', '<s:message code="condition.date"/>', 130, 'center', false, 'nomal');
	grid.colAdd('user', '<s:message code="consent.user"/>', 120, 'center', false, 'link');
	grid.colAdd('businm', '<s:message code="common.org.busi"/>', 120, 'center', true, 'nomal');
	grid.colAdd('deptnm', '<s:message code="common.org.dept"/>', 120, 'center', false, 'nomal');
	grid.colAdd('jikgubnm', '<s:message code="common.org.jikgub"/>', 120, 'center', false, 'nomal');
	grid.colAdd('sender', '<s:message code="condition.sender"/>', 130, 'left', false, 'link', function (row, cell, value, columnDef, dataContext) {
		return value;
	});
	grid.colAdd('allOfUs', '<s:message code="condition.allofus"/>', 150, 'left', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		if (value == undefined || value.length == 0) return '';

		for (var i = 0; i < value.length; i++) {
			if (value[i] == 'IA') value[i] = '<s:message code="condition.allofus1"/>';
			else if (value[i] == 'ET') value[i] = '<s:message code="condition.allofus8"/>';
			else if (value[i] == 'IT') value[i] = '<s:message code="condition.allofus7"/>';
			else if (value[i] == 'EA') value[i] = '<s:message code="condition.allofus2"/>';
			else if (value[i] == 'PT') value[i] = '<s:message code="condition.allofus9"/>';
			else if (value[i] == 'PA') value[i] = '<s:message code="condition.allofus3"/>';
			else if (value[i] == 'SO') value[i] = '<s:message code="condition.allofus13"/>';
			else if (value[i] == 'SI') value[i] = '<s:message code="condition.allofus14"/>';
		}
		return value.join(', ');
	});
	grid.colAdd('recvsStr', '<s:message code="condition.recv"/>', 220, 'left', false, 'link', function (row, cell, value, columnDef, dataContext) {
		return value;
	}, {sorter: sortUtil.inout});
	grid.colAdd('to', '<s:message code="condition.to"/>', 150, 'left', true, 'link', function (row, cell, value, columnDef, dataContext) {
		var innOutInfo = grid.getValue(row, 'toInOutInfo');
		var rtnVal = arrayToString(value);
		if (innOutInfo == "") return '';
		else return innOutInfo + rtnVal;
	});
	grid.colAdd('cc', '<s:message code="condition.cc"/>', 150, 'left', true, 'link', function (row, cell, value, columnDef, dataContext) {
		var innOutInfo = grid.getValue(row, 'ccInOutInfo');

		var rtnVal = arrayToString(value);
		if (innOutInfo == "") return '';
		else return innOutInfo + rtnVal;
	});
	grid.colAdd('bcc', '<s:message code="condition.bcc"/>', 150, 'left', true, 'link', function (row, cell, value, columnDef, dataContext) {
		var innOutInfo = grid.getValue(row, 'bccInOutInfo');
		var rtnVal = arrayToString(value);
		if (innOutInfo == "") return '';
		else return innOutInfo + rtnVal;
	});
	grid.colAdd('srcip', '<s:message code="condition.source"/> IP', 100, 'left', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return value;
	}, {sorter: sortUtil.ip});
	grid.colAdd('dstip', '<s:message code="condition.destination"/> IP', 100, 'left', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return value;
	}, {sorter: sortUtil.ip});
	grid.colAdd('attachname', '<s:message code="condition.attach_name"/>', 220, 'left', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		var rtnVal = arrayToString(value);
		return rtnVal;
	});
	grid.loadExportMenu('<s:message code="DATA_ANALYSIS.ANALYSIS_SIMILARITY"/>');
	grid.colAdd('sizeStr', '<s:message code="condition.size.all"/>', 80, 'left', false, 'nomal', null, {sortField: 'size'});
	grid.colAdd('bodySizeStr', '<s:message code="condition.size.body"/>', 80, 'left', false, 'nomal', null, {sortField: 'body_size'});
	grid.colAdd('attachSizeStr', '<s:message code="condition.size.attach.total"/>', 80, 'left', false, 'nomal', null, {sortField: 'attachSizeSort'});
	grid.colAdd('kwds', '<s:message code="condition.keyword"/>', 120, 'left', false, 'nomal');
	grid.colAdd('pi_total', '<s:message code="condition.regexp"/>', 70, 'center', false, 'link', function (row, cell, value, columnDef, dataContext) {
		if (value == '0') return '';
		else return value.comma();
	});

	if (isOCR) {
		grid.colAdd('ocr_attach_cnt', 'OCR <s:message code="message.msg.file"/>', 70, 'center', false, 'link', function (row, cell, value, columnDef, dataContext) {
			if (value == '0' || value == '' || value == null || value == undefined) return '';
			else return value.comma();
		});
	}
	grid.loadHeader(true);
	grid.initData('<s:message code="common.msg.search.click"/>');
	grid.onContextMenu = function (row, col, e) {
		e.preventDefault();

		$("#contextMenu")
			.data("row", row)
			.css("top", e.pageY)
			.css("left", e.pageX)
			.show();
	};
	grid.onClick = function () {
		if ($('#contextMenu').css('display') == 'block' || $('#contextMenu').css('display') == 'inline-block') $('#contextMenu').hide();
		if (grid.Col == grid.ColIndex('attachcnt')) {
			fileInfoViewer(grid.Row);
		} else if (grid.Col == grid.ColIndex('user')) {
			userInfoViewer(grid.Row, 'user');
		} else if (grid.Col == grid.ColIndex('sender')) {
			userInfoViewer(grid.Row, 'sender');
		} else if (grid.Col == grid.ColIndex('recvsStr')) {
			if (grid.getValue(grid.Row, 'recvs') != '') userInfoViewer(grid.Row, 'recvs');
		} else if (grid.Col == grid.ColIndex('to')) {
			if (grid.getValue(grid.Row, 'to') != '') userInfoViewer(grid.Row, 'to');
		} else if (grid.Col == grid.ColIndex('cc')) {
			if (grid.getValue(grid.Row, 'cc') != '') userInfoViewer(grid.Row, 'cc');
		} else if (grid.Col == grid.ColIndex('bcc')) {
			if (grid.getValue(grid.Row, 'bcc') != '') userInfoViewer(grid.Row, 'bcc');
		} else if (grid.Col == grid.ColIndex('pi_total')) {
			regexpInfoViewer(grid.Row);
		} else if (grid.Col == grid.ColIndex('referer_url')) {
			var referer_url = grid.getValue(grid.Row, 'referer_url');
			if (referer_url != 'N') fnOpenWindow(referer_url, '', 1024, 800, 'resize');
		} else if (grid.Col == grid.ColIndex('ocr_attach_cnt')) {
			ocrFileInfoViewer(grid.Row);
		} else if (grid.Col == grid.ColIndex('interestUserYn')) {
			var interestUserYn = grid.getValue(grid.Row, 'interestUserYn');
			if (interestUserYn != '') interestUserInfoViewer(grid.Row);
		}

		if (!(adminMenu != "ALL" && adminMenu.indexOf("DV") < 0)) {
			if (!parent.$('#none_btn').hasClass('areaSelected')) viewer_open(grid.Row);
			if (popWin) viewer_openFocus(grid.Row);
		} else {
			alert('<s:message code="message.auth.no.detailview"/>');
			return;
		}
	};
	grid.onDblClick = function () {
		if (grid.Col == grid.ColIndex('subject')) {
			viewer_newOpen(grid.Row);
		}
	};
</script>
</html>