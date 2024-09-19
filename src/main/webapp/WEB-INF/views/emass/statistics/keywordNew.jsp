<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS LTH - <s:message code="DATA_MONITOR.STAT_LABEL"/></title>
	<link rel="stylesheet" href="<c:url value="/resources/css/bootstrap-datetimepicker.min.css"/>"/>
	<script type="text/javascript" src="<c:url value="/resources/js/moment.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/transition.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/collapse.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/ko.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/bootstrap-datetimepicker.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/messageGrid.js"/>"></script>
	<style type="text/css">
		.panel-heading .dropdown-menu {
			right: 31px;
			top: 42px;
			left: initial;
		}
	</style>
	<script>
		var searchFlag = false;
		var totalCount = 0;
		var rowKey = "";
		var rowName = "";
		var colKey = "";
		var detailTab = "N";
		var chartcnt = 5;
		var currentGrid;
		var tabID = 1;
		var tabNum = 0;
		var totalChartDat
		$(document).ready(function () {


			$('#searchBtn').click(function () {
				getData('Y');
			});

			$('.codeSelectedBtn').click(function () {
				$('#coreKeywordStr').val('');
				$('#coreKeywordVal').val('');
				$('#coreKeywordSelectedArea').find('.btn').text(0);
			})

			$('#clearBtn').click(function(){
				$('#startdate').val(new Date().format('yyyy-mm-dd'));
				$('#enddate').val(new Date().format('yyyy-mm-dd'));
				$('#coreKeywordStr').val('');
				$('#coreKeywordVal').val('');
				$('#coreKeywordSelectedArea').find('.btn').text(0);
			});

			initDateTimePicker('startdate', 'enddate');


			$('.totalView').click(function () {
				$("#chartCntDiv").show();
				$('#totalViewDiv').hide();
				printChart(totalChartDat);
			});

			$('#coreKeyword').click(function () {
				var code = $(this).attr('id');
				openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
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


		});


		function openCodeWindow(id, oldCode, oldConm) {
			$('#oldCode').val(oldCode);
			$('#oldConm').val(oldConm);

			var url = '<c:url value="/commons/selectCode.do?codeType='+id+'"/>';
			var pop = fnOpenWindow('', 'selectCodeWinPopup', 1200, 700, 'resize');

			$('#codeParam').attr('target', 'selectCodeWinPopup');
			$('#codeParam').attr('action', url);
			$('#codeParam').attr('method', 'post');
			$('#codeParam').submit();
		}

		function getSelectedCodeData(codeType, data) {
			var str = '';
			var val = '';
			for (var i = 0; i < data.length; i++) {
				str += data[i].codeName;
				val += data[i].code;

				if (i != data.length - 1) {
					str += ', ';
					val += '|';
				}
			}
			if (val != '') {
				str = str.rtrim();
				val = val.trimAll();
			}
			$('#' + codeType + 'Str').val(str);
			$('#' + codeType + 'Val').val(val);

			if ($('#' + codeType + 'Str').val() != '') {
				$('#' + codeType + 'SelectedArea').find('.btn').text(data.length);
				$('#' + codeType + 'SelectedArea').show();
			} else {
				$('#' + codeType + 'SelectedArea').find('.btn').text(0);
				$('#' + codeType + 'SelectedArea').hide();
			}
		}

	</script>
</head>
<div>
	<div class="searchArea">
		<div class="searchSub">
			<div id="startDatePicker"><input type="text" id="startdate" name='startdate'class="txt_center"  style="width: 110px;">
				<span class="hyphen">~</span></div>
			<div id="enddatepicker"><input type="text" id="enddate" name='enddate'class="txt_center"  style="width: 110px;"></div>

			<div class="form-group optiotab">
				<button type="button" id="dateYesterday" accesskey="Y" style="width:85px;"><s:message code="condition.yesterday"/></button>
				<button type="button" id="dateToday" accesskey="T" style="width:85px;"><s:message code="condition.today"/></button>
				<button type="button" id="dateWeek" accesskey="W"><s:message code="condition.week" arguments="1" argumentSeparator="|"/></button>
				<button type="button" id="dateMonth" accesskey="M"><s:message code="condition.month" arguments="1" argumentSeparator="|"/></button>
			</div>

		<%--						<label for="startdatepicker"></label>--%>
			<%--						<div class='input-group date' id='startdatepicker'>--%>
			<%--							<input type='text' class="input-sm form-control" id='startdate'/>--%>
			<%--							<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>--%>
			<%--								</span>--%>
			<%--						</div>--%>
			<%--						~--%>
			<%--						<div class='input-group date' id='enddatepicker'>--%>
			<%--							<input type='text' class="input-sm form-control" id='enddate'/>--%>
			<%--							<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>--%>
			<%--								</span>--%>
			<%--						</div>--%>

			<button class="btn01" id="coreKeyword"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
					code="keyword.msg.coreKeyword"/></button>
			<span id="coreKeywordSelectedArea" class="codeSelectedBtn">
										<button type="button" class="btn num_add bornone" style="z-index: 2">0</button>
									</span>
			<input type="hidden" id="coreKeywordVal">

			<div class="form-group">
				<label for="coreKeywordStr"></label>
				<div class='input-group'>
					<input type="text" id="coreKeywordStr" name="title" class="input-sm form-control" style="width: 300px; " readonly="readonly"/>
				</div>
			</div>
				<button class="form_btn01" id="searchBtn"><s:message code="common.msg.search"/></button>
				<button class="form_btn02" id="clearBtn"><s:message code="condition.reset"/></button>

			<span>
		<b style="margin-left: 12px;"><s:message code="DATA_ANALYSIS.STAT_HOST_INFO"/> <s:message code="common.core.service"/></b>
						</span>

		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					<s:message code="DATA_STAT.STAT_KEYWORDNEW"/>
				</button>
			</div>
			<div id="basicStatListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>

	<!-- Back to top -->
	<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>

	<form method="post" id="codeParam">
		<input type="hidden" name="oldCode" id="oldCode"></input>
		<input type="hidden" name="oldConm" id="oldConm"></input>
	</form>

	<script>


		function viewer_open( row, bodySize ){

			var msgid = grid1.getValue(row, 'msgId');

			openMessageBodyPop(grid1.id, msgid, "");
			var readYn = grid1.getValue(row, 'readYn');
			grid1.setValue(row, grid1.ColIndex('readYn'), 'Y');
			grid1.Select(row,0);
		}

		function viewer_newOpen(row, bodySize){

			var msgid = grid1.getValue(row, 'msgId');
			openMessageBodyPop(grid1.id, msgid, "");

			var readYn = grid1.getValue(row, 'readYn');
			grid1.setValue(row, grid1.ColIndex('readYn'), 'Y');
		}

		function prevMsg( ) {
			var row = 0;
			if( grid1.Row > 0 ) {
				row = --grid1.Row;
				viewer_open(row);
				grid1.Select(row,0);
				return true;
			}
			return false;
		}

		function nextMsg( ) {

			var row = 0;
			if( grid1.Row < grid1.Rows - 1 ) {
				row = ++grid1.Row;
				viewer_open(row);
				grid1.Select(row,0);
				if( grid1.Row == grid1.Rows - 2  ){
					getList( true );
				}
				return true;
			}
			return false;
		}

		var grid1 = new Xgrid('basicStatListGrid', contextRoot);
		grid1.autoNumber();
		grid1.colAdd("host", 'HOST', 300, "left", false, 'nomal');
		grid1.colAdd("url", 'PATH', 300, "left", false, 'nomal');
		grid1.colAdd("keyword", '<s:message code="keyword.coreKeyword.keyword"/>', 170, "left", false, 'link', function (row, cell, value, columnDef, dataContext) {
			let count = grid1.getValue(row, 'cnt');
			if (count > 1) return value + '<s:message code="condition.view.type8"/> ' + (count - 1) + '<s:message code="condition.view.type9"/>';
			else return value;
		});

		<%--grid1.colAdd("sentence", '<s:message code="keyword.coreKeyword.content"/>', 250, "left", false, 'nomal' );--%>
		grid1.colAdd("deptnm", '<s:message code="common.org.dept"/>', 150, "left", false, 'nomal');
		grid1.colAdd("sender", '<s:message code="common.org.user"/>', 190, "left", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
			value = value.replaceAll("<", "[").replaceAll(">", "]");
			return value;
		});
		grid1.colAdd("ctime", '<s:message code="keyword.coreKeyword.ctime"/>', 150, "center", false, 'nomal');
		grid1.loadExportMenu('<s:message code="DATA_STAT.STAT_KEYWORDNEW"/>');
		grid1.loadPageSize();
		grid1.loadHeader(false);
		grid1.initData('<s:message code="common.msg.search.click"/>');

		grid1.changePageSize = function (cnt) {
			getData();
		};

		grid1.onClick = function () {
			if (grid1.Col == grid1.ColIndex('keyword')) {
				viewer_open(grid1.Row, null);
				// let msgid = grid1.getValue(grid1.Row, 'msgid')
				// openMessageBodyPopSize("", msgid, "");
			}

		};


		var startDate, endDate, coreKeyword, hosts, paths;

		function getData(flag) {
			if (searchFlag) return;

			coreKeyword = $('#coreKeywordStr').val();
			// 공백제거
			coreKeyword = coreKeyword.split(',').map(str => $.trim(str)).join()
			startDate = $('#startdate').val().replaceAll("-", "");
			endDate = $('#enddate').val().replaceAll("-", "");
			if (startDate > endDate) {
				ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
				return;
			}
			if (coreKeyword == '') {
				openCodeWindow('coreKeyword', $('#' + 'coreKeyword' + 'Val').val(), $('#' + 'coreKeyword' + 'Str').val());
				//	ui.alertMsg('<s:message code="keyword.message.insert"/>');
				return;
			}

			searchFlag = true;
			grid1.on();
			ui.get({
				url: 'getKeywordNew.xcn',
				startDate: startDate + "000000",
				endDate: endDate + "235959",
				coreKeyword: coreKeyword,
				offset: grid1.data.length,
				limit: grid1.pageSize,
				success: function (data, total) {
					grid1.setData(data);
					searchFlag = false;
				},
				error: function (status, message) {
					ui.alertMsg(message);
				},
				complete: function () {
					grid1.off();
				}
			});
		}
	</script>
	</body>
</html>
