<%@ page import="net.sf.json.JSONObject" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<%
	String anomalyPatterns = "";
	if(!Common.isEmptyArray(Config.activeAnomalyPatterns)){
		anomalyPatterns = String.join(",", Config.activeAnomalyPatterns);
	}
%>
<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>
<style>
	.interestUserCheck{
		background-image: url('<c:url value="/img/icon/star.png"/>');
		background-position: center;
		background-repeat:no-repeat;
		width:100%;
		height:100%;
	}
</style>
<script>

	Highcharts.setOptions({
		chart: {
			type: 'column',
			marginTop : 25
		},
		global : { useUTC : false },
		gridLineColor: '#fff',
		colors: ['#80599F', '#656C7C', '#598AD3', '#D35976', '#DDDDDD', '#bb6ecb', '#439851', '#33a0c4', '#7558cb', '#97b420'],
		lang: {
			months: [ '<s:message code="common.january"/>', '<s:message code="common.february"/>', '<s:message code="common.march"/>', '<s:message code="common.april"/>', '<s:message code="common.may"/>', '<s:message code="common.june"/>', '<s:message code="common.july"/>', '<s:message code="common.august"/>', '<s:message code="common.september"/>', '<s:message code="common.october"/>', '<s:message code="common.november"/>', '<s:message code="common.december"/>' ],
			shortMonths : [ '<s:message code="common.january"/>', '<s:message code="common.february"/>', '<s:message code="common.march"/>', '<s:message code="common.april"/>', '<s:message code="common.may"/>', '<s:message code="common.june"/>', '<s:message code="common.july"/>', '<s:message code="common.august"/>', '<s:message code="common.september"/>', '<s:message code="common.october"/>', '<s:message code="common.november"/>', '<s:message code="common.december"/>' ],
			weekdays : [ '<s:message code="common.sunday"/>', '<s:message code="common.monday"/>', '<s:message code="common.tuesday"/>', '<s:message code="common.wednesday"/>', '<s:message code="common.thursday"/>', '<s:message code="common.friday"/>', '<s:message code="common.saturday"/>' ],
			contextButtonTitle : '<s:message code="common.msg.char_type"/>',
			thousandsSep : ','
		},
		xAxis: {
			dateTimeLabelFormats: {
				day: '<s:message code="dashboard.display.day" arguments="%b,%d" />'
			}
		},
		yAxis: {
			gridLineColor: '#333',
			gridLineWidth : 0.1
		}
	});
	var patternNameMap = {
		LAOP : '<s:message code="bodyview.laop"/>',
		AOH : '<s:message code="bodyview.aoh"/>',
		FCA : '<s:message code="bodyview.fca"/>',
		ID : '<s:message code="bodyview.id"/>',
		RS : '<s:message code="bodyview.rs"/>',
		EC : '<s:message code="bodyview.ec"/>',
		EF : '<s:message code="bodyview.ef"/>',
		LTO : '<s:message code="bodyview.lto"/>',
		LAO : '<s:message code="bodyview.lao"/>',
		LF : '<s:message code="bodyview.lf"/>',
		STG : '<s:message code="bodyview.stg"/>',
	}

	var searchFlag = false;
	var detailTotal = 0;
	var rowKey = "";
	var rowName = "";
	var colKey = "";
	var detailTab = "N";
	var chartcnt = 5;
	var currentGrid;
	var tabID = 1;
	var tabNum = 0;
	var totalChartDat;
	var serviceList=[];

	$(document).ready(function(){
		initCondition();
		getServiceList();
		initDateTimePicker('startdate','enddate');
		closeDetailTab();
		getData ('Y');

		$('.optionBtn').click(function () {
			$('.optionBtn').removeClass('active');
			$(this).addClass('active');
		});

		$('#dept').click(function () {
			var code = $(this).attr('id');
			openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
		});

		$('#user').click(function () {
			var code = $(this).attr('id');
			openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val(), $('#' + code + 'Dept').val(), $('#' + code + 'Jib').val());
		});


		$(document).on('click', '#deptSelectedArea', function (e) {
			$('#deptVal, #deptStr').val('');
			$('#deptSelectedArea').find('.btn').text(0);
		});

		$(document).on('click', '#userSelectedArea', function (e) {
			$('#userVal, #userStr, #userDept, #userJib').val('');
			$('#userSelectedArea').find('.btn').text(0);
		});
		$('#searchBtn').click(function(){
			closeDetailTab();
			getData ('Y');
		});
		$('#clearBtn').click(function(){
			$('#startdate').val(new Date().format('yyyy-mm-dd'));
			$('#enddate').val(new Date().format('yyyy-mm-dd'));
			$('#deptVal, #deptStr').val('');
			$('#deptSelectedArea').find('.btn').text(0);
			$('#userVal, #userStr, #userDept, #userJib').val('');
			$('#userSelectedArea').find('.btn').text(0);

			$('.optionBtn').removeClass('active');
			$('#svc1').addClass('active');
			$('#busiSelect').selectpicker('val', '');
		});


		$('#chartCntDiv .dropdown-menu li a').click(function(){
			chartcnt = $(this).text();
			printChart(totalChartDat);
		});

		$('#startdate').val(new Date().format('yyyy-mm-dd'));
		$('#enddate').val(new Date().format('yyyy-mm-dd'));

		$(".nav-tabs").on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
			var id = $(this).parents('li').attr('idx');
			var hrefNm = $(this).attr('href');
			if(hrefNm=='#basicStatList') {
				$("#chartCntDiv").show();
				$('#totalViewDiv').hide();
				printChart(totalChartDat);
			} else {
				$("#chartCntDiv").hide();
				$('#totalViewDiv').show();
				var dat = chartDat[id];
				printChart(dat);
			}
		})

		$('.listChart').on('click','.subtab_close',function(){
			var id = 'tab'+ Number($(this).parents('li').attr('idx'));
			var obj = tabInfo[id];
			obj.close();

			var tabID = $(this).parents('a').attr('href');
			$(this).parents('li').remove();
			$(tabID).remove();

			tabNum --;

			var tabFirst = $('.listChart a:first');
			tabFirst.tab('show');
			$("#chartCntDiv").show();
			$('#totalViewDiv').hide();
			printChart(totalChartDat);
		});

		$('.totalView').click(function(){
			$("#chartCntDiv").show();
			$('#totalViewDiv').hide();
			printChart(totalChartDat);
		});
	});

	function getServiceList(){
		ui.get({
			url : 'getServiceGroupList.xcn',
			success : function(data, total) {
				serviceList = data;
			},
			error : function(status, message) {
				ui.alertMsg(message);
			},
			complete : function() {
			}
		});
	}

	function setGrid( ){
		currentgrid = getCurrentGrid();
		initGrid(currentgrid, messageGridColumn);
	}

	function closeDetailTab() {
		var tabFirst = $('.listChart a:first');
		tabFirst.tab('show');
	}

	function viewer_open( row, bodySize){
		var selectedTabIdx = $('.listChart').find('.active').index();
		var grid = window.__grids[selectedTabIdx];
		var msgid = grid.getValue(row, 'msgid');
		var ctime = $('#searchStrInput').val();

		openMessageBodyPop( grid.id, msgid, $('#searchStrInput').val(), bodySize);

		var readYn = grid.getValue(row, 'readYn');
		grid.setValue(row, 'readYn', 'Y');
		grid.Select(row,0);
	}

	function viewer_newOpen(row, bodySize){
		var selectedTabIdx = $('.listChart').find('.active').index();
		var grid = window.__grids[selectedTabIdx];
		var msgid = grid.getValue(row, 'msgid');
		var ctime = $('#searchStrInput').val();
		openMessageBodyPop( '', msgid, $('#searchStrInput').val(), bodySize);

		var readYn = grid.getValue(row, 'readYn');
		grid.setValue(row, 'readYn', 'Y');
	}

	function prevMsg( ) {
		var selectedTabIdx = $('.listChart').find('.active').index();
		var grid = window.__grids[selectedTabIdx];
		var row = 0;
		if( grid.Row > 0 ) {
			row = --grid.Row;
			viewer_open(row);
			grid.Select(row,0);
			return true;
		}
		return false;
	}

	function nextMsg( ) {
		var selectedTabIdx = $('.listChart').find('.active').index();
		var grid = window.__grids[selectedTabIdx];
		var row = 0;
		if( grid.Row < grid.Rows - 1 ) {
			row = ++grid.Row;
			viewer_open(row);
			grid.Select(row,0);
			if( grid.Row == grid.Rows - 2  ){
				getList( true );
			}
			return true;
		}
		return false;
	}


	function initCondition() {
		getCodeList('busi');
		getCodeList('dept');

		$('#busiSelect').selectpicker({
			size: 15,
			width: '300px',
			searchLabel: true,
			noneSelectedText: '<s:message code="common.org.busi.all"/>',
			noneResultsText: '<s:message code="common.msg.noresult"/>' + ' ',
			selectAllText: '<s:message code="common.msg.select_all"/>',
			deselectAllText: '<s:message code="common.msg.unselect_all"/>',
		});
	}
	function getCodeList(codeType) {
		ui.get({
			url: 'getCodeList.xcn',
			codeType: codeType,
			success: function (data, total) {
				$('#' + codeType + 'Select').html(getSelectOption(data));
				$('#' + codeType + 'Select').selectpicker('refresh');
				$('#' + codeType + 'SelectPop').html(getSelectOption(data));
				$('#' + codeType + 'SelectPop').selectpicker('refresh');
			},
			error: function (status, message) {
				ui.alertMsg('error:' + status);
			},
			complete: function () {
				searchFlag = false;
			}
		});
	}

	/**
	 * Bar Chart
	 */
	var chart = null;
	var chartxAxis;
	function printChart( dat )
	{
		var data = [];
		var categories = [];
		var cols = abnlDetectGrid.columns;
		var maxDat = 0;
		if( dat == undefined ) {

			for (var i = 0; i < abnlDetectGrid.data.length; i++) {
				if ((i + 1) > chartcnt ) break;
				var items = [];
				for (var j = 1; j < cols.length; j++) {
					if (cols[j].id == 'total' || cols[j].id == 'NUM' ||  cols[j].id == 'name2' || cols[j].id == 'rowKey') continue;
					if (abnlDetectGrid.data[i][cols[j].id] == undefined) items.push(0);
					else items.push(Number(abnlDetectGrid.data[i][cols[j].id]));
					if (i == 0) categories.push(cols[j].name);
					if (Number(abnlDetectGrid.data[i][cols[j].id]) > maxDat) maxDat = Number(abnlDetectGrid.data[i][cols[j].id]);
				}
				if (abnlDetectGrid.data[i]['NUM'] == '<s:message code="bodyview.total"/>') continue;
				if ((abnlDetectGrid.data[i].NUM == "Total")) continue;
				else data.push({name: abnlDetectGrid.data[i]['rowKey'], data: items});
			}


		} else {
			var items = [];
			for ( var j=0 ; j < cols.length ; j++ ) {
				if ( cols[j].id == 'total' || cols[j].id == 'NUM' || cols[j].id == 'rowKey' ) continue;
				if ( dat[cols[j].id] == undefined || dat[cols[j].id] == '' ) {
					items.push(0);
				} else {
					items.push( Number( dat[cols[j].id] ) );
				}
				categories.push( cols[j].name );
				if(Number( dat[cols[j].id] ) > maxDat) maxDat = Number( dat[cols[j].id] );
			}
			if(dat['NUM'] == '<s:message code="bodyview.total"/>') return;
			else data.push({name:dat['rowKey'], data:items});
		}

		var rotation = 40;
		if ( chartxAxis == 'W' ) rotation = 0;

		$('#chartArea1').highcharts({
			title: {
				text: null
			},
			exporting: chartAPI.exporting,
			credits: chartAPI.credits,
			xAxis: {
				categories: categories
			},
			yAxis: {
				type: 'logarithmic',
				custom: {
					allowNegativeLog: true
				},
				allowDecimals: false,
				title: {
					text: '',
					rotation: 0
				}
			},
			tooltip: {
				headerFormat: '<b>{point.key}</b><br>',
				pointFormat: '<span style="color:{series.color}">\u25CF</span> {series.name}: {point.y} (<s:message code="common.msg.cnt"/>)'
			},
			series: data
		});
	}
</script>
<div>
	<div class="container searchArea w100">
		<div class="searchSub w100">
			<div>
				<input type="text" id="startdate" class="txt_center"  style="width: 110px;"/>
				<span class="hyphen">~</span>
			</div>
			<div>
				<input type="text" id="enddate" class="txt_center"  style="width: 110px;"/>
			</div>
			<div>
				<div>
					<select id="busiSelect" class="selectpicker col-xs" data-style="btn-default btn-sm" multiple
					        data-show-subtext="true" data-actions-box="true"></select>
				</div>
				<button class="btn01" id="dept"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
						code="common.org.choose.dept"/></button>
				<span id="deptSelectedArea" class="codeSelectedBtn">
						<button type="button" class="btn num_add bornone"  style="z-index: 2;">0</button>
				</span>
				<input type="hidden" id="deptStr" class="selectedTitle">
				<input type="hidden" id="deptVal">
				<input type="hidden" id="userDept">
				<input type="hidden" id="userJib">


				<button class="btn01" id="user"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
						code="common.org.choose.user"/></button>
				<span id="userSelectedArea" class="codeSelectedBtn">
										<button type="button" class="btn num_add bornone"  style="z-index: 2;">0</button>
									</span>
				<input type="hidden" id="userStr" class="selectedTitle">
				<input type="hidden" id="userVal">

			</div>
			<div>
				<button class="form_btn01" id="searchBtn"><s:message code="common.msg.search"/></button>
				<button class="form_btn02" id="clearBtn"><s:message code="condition.reset"/></button>
			</div>
	</div>
	<div class="content">
		<div class="contentSub">
			<div class="chartAreafull">
				<div>
					<h3>
						<s:message code="DATA_STAT.STAT_ANOMALY_DETECTION"/> CHART
						<span class="sel">
						<div id="totalViewDiv" style="display:none;">
							<div class="subtab">
								<button type="button" class="totalView" title="<s:message code="stat.view.all"/>"><s:message code="stat.view.all"/></button>
							</div>
						</div>
						<div class="panel-headings" id="chartCntDiv">
							<button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown">
								<s:message code="stat.display.count.chart"/> (<span class="dropdown-text">5</span>) <span val="5" class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-right" role="menu">
								<li><a href="#">5</a></li>
								<li><a href="#">10</a></li>
								<li><a href="#">15</a></li>
								<li><a href="#">20</a></li>
							</ul>
						</div>
						</span>
					</h3>
					<div class="panel-default" id="service.logging.count">
						<div class="inner_personaldata" style="height:300px;">
							<div id="chartArea1" style="height: 100%"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="subtab">
				<div>
					<ul class="nav nav-tabs codeTab listChart">
						<li class="active"><a data-toggle="tab" href="#basicStatList" id="listTab" ><s:message code="abnl.bhav.detect.type"/></a></li>
					</ul>
				</div>
			</div>
			<div class="xcn_full">
				<div class="tab-content">
					<div id="basicStatList" class="tab-pane fade in active">
						<div id="basicStatListGrid" class="slickGrid gridArea" style="min-height: 200px;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"></input>
	<input type="hidden" name="oldConm" id="oldConm"></input>
	<input type="hidden" name="oldDept" id="oldDept"></input>
	<input type="hidden" name="oldJib" id="oldJib"></input>
</form>
<script type="text/javascript">
	function setSublist(data) {
		var element = document.getElementById('sub_1');
		if (element && data && data.length > 0 && data[0].rowKey) {
			var firstRowkey = data[0].rowKey;
			element.innerHTML = '<span>' + firstRowkey + '</span>';
		}
	}

	function getCurrentGrid() {
		var id = Number($('.listChart .active').attr('idx'));
		return tabInfo['tab' + id];
	}

	var abnlDetectGrid = new Xgrid('basicStatListGrid', contextRoot);
	var anomalyPatterns = '<%=anomalyPatterns%>';
	abnlDetectGrid.autoNumber();
	abnlDetectGrid.colAdd("rowKey", '<s:message code="common.org.user"/>', 160, "center", false, 'link', function (row, cell, value, columnDef, dataContext) {

		var userInfo = '';
		var rowKey = value;
		var rowNm = abnlDetectGrid.getRowData(row).name2;

		if(rowNm != null && rowNm != undefined && rowNm != '') userInfo = rowKey +'('+rowNm+')';
		else userInfo = rowKey ;
		return  userInfo;
	});
	if(anomalyPatterns != ''){
		var patternArray = anomalyPatterns.split(',');
		patternArray.forEach(pattern => {
			var columnSize = 200;

			abnlDetectGrid.colAdd('pi_amount.pi_' + pattern, patternNameMap[pattern], columnSize, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
				if (value != undefined) return value.comma();
				else return '0';
			});
		});
	}
	abnlDetectGrid.loadExportMenu('<s:message code="DATA_STAT.STAT_ANOMALY_DETECTION"/>');
	abnlDetectGrid.loadHeader(false);
	abnlDetectGrid.initData('<s:message code="common.msg.search.click"/>');
	abnlDetectGrid.changePageSize = function (cnt) {
		getData('Y');
	};

	var tabInfo = {};
	var chartDat = {};
	abnlDetectGrid.onClick = function () {
		var valChk = abnlDetectGrid.getValue(abnlDetectGrid.Row, abnlDetectGrid.Col);
		if (valChk == "" || valChk == "-") return;

		if (abnlDetectGrid.getValue(abnlDetectGrid.Row, 'NUM') == '<s:message code="bodyview.total"/>') {
			var key = "";
			for (var i = 0; i < abnlDetectGrid.Rows; i++) {
				if (abnlDetectGrid.getValue(i, 'rowKey') == "" || abnlDetectGrid.getValue(i, 'rowKey') == "-") continue;
				else key += abnlDetectGrid.getValue(i, 'rowKey').replaceAll("\"", "\\\"") + ",";
			}
			key = key.substring(0, key.length - 1)
			rowKey = key;
		} else {
			rowKey = abnlDetectGrid.getValue(abnlDetectGrid.Row, 'rowKey').replaceAll("\"", "\\\"");
		}
		console.log("rowkey: "+rowKey);
		rowName = abnlDetectGrid.getValue(abnlDetectGrid.Row, 'rowName');
		colKey = abnlDetectGrid.ColKey(abnlDetectGrid.Col);
		var xAxis =  $('button.optionBtn.active').val();
		var colKeyNm = colKey;
		console.log("cokey: "+colKey);
		if (colKey == 'rowKey' || colKey == 'total' || colKey == 'NUM') {
			colKey = "";
			colKeyNm = '<s:message code="bodyview.total"/>';
		}else{
			colKeyNm =  abnlDetectGrid.ColNm(abnlDetectGrid.Col);
		}

		console.log("111");
		tabID++;
		tabNum++;
		if (tabNum > 3) {
			var delid = $(".listChart li:nth-child(2)").attr('idx');
			$('#detailTab' + delid + ' .subtab_close').click();
		}

		var displayName = (rowKey.indexOf(',') > -1) ? '<s:message code="common.msg.all"/>' : rowKey.replaceAll("\\\"", "\"");
		if (rowName != '') displayName = rowName + '&lt;' + rowKey + '&gt;';
		var id = 'tab' + tabID;
		$('.listChart').append($('<li style="display:inline-flex;text-align: center;z-index:1001;" idx="' + tabID + '" id="liTab' + tabID + '"><a data-toggle="tab" href="#tab' + tabID + '" id="detailTab' + tabID + '" style="display: flex; align-items: center; justify-content: center;">' + displayName + ' - ' + colKeyNm + '<span class="badge mal4"></span><button type="button" class="subtab_close closeBtn">	&#10006;</button></a></li>'));
		$('#basicStatList').after($('<div class="tab-pane fade" id="tab' + tabID + '"><div id="grid' + tabID + '" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; height: 400px"></div></div>'));

		var gid = 'grid' + tabID;
		var gridObj = new Xgrid(gid, contextRoot);
		tabInfo[id] = gridObj;
		$('.nav-tabs a[href="#tab' + tabID + '"]').tab('show');
		setGrid();
		$("#chartCntDiv").hide();
		$('#totalViewDiv').show();
		var dat = abnlDetectGrid.getRowData(abnlDetectGrid.Row);
		chartDat[tabID] = dat;
		printChart(dat);
		console.log("333");
		gridObj.loadExportMenu('<s:message code="DATA_STAT.STAT_ANOMALY_DETECTION"/> ( ' + displayName + ' ) - ' + colKeyNm);
		gridObj.changePageSize = function (cnt) {
			getDetailData('Y');
		};
		getDetailData('Y');
	};

	function openCodeWindow(id, oldCode, oldConm,oldDept,oldJib) {
		$('#oldCode').val(oldCode);
		$('#oldConm').val(oldConm);
		$('#oldDept').val(oldDept);
		$('#oldJib').val(oldJib);

		var url = '<c:url value="/commons/selectCode.do?codeType='+id+'"/>';
		var pop = fnOpenWindow('', 'selectCodeWinPopup', 1200, 700, 'resize');

		$('#codeParam').attr('target', 'selectCodeWinPopup');
		$('#codeParam').attr('action', url);
		$('#codeParam').attr('method', 'post');
		$('#codeParam').submit();
	}



	function getData(flag) {

		if (searchFlag) return;
		var sDate = $('#startdate').val().replaceAll("-", "");
		var eDate = $('#enddate').val().replaceAll("-", "");
		var xAxis = $('button.optionBtn.active').val();
		var xAxis_str = $('button.optionBtn.active').text();
		if (sDate > eDate) ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
		if (sDate === '' || eDate === '') {
			alert('<s:message code="holidayBusiness.msg.enter.date"/>');
			return;
		}

		var busiStr = arrayToString($('#busiSelect').selectpicker('val'));
		var dv = $('#deptVal').val().split('|');
		var dept = dv.join(',');

		var deptStr = '';
		if (dept != '') deptStr = dept;
		else deptStr = '';

		var uv = $('#userVal').val().split('|');
		var user = uv.join(',');

		var userStr = '';
		if (user != '') userStr = user;
		else userStr = '';


		searchFlag = true;
		abnlDetectGrid.on();

		abnlDetectGrid.pageSize=10000

		ui.get({
			url: 'getAbnlDetectStatList.xcn',
			startDate: sDate + "000000",
			endDate: eDate + "235959",
			xAxis: xAxis,
			yAxis: '',
			offset: abnlDetectGrid.data.length,
			limit: abnlDetectGrid.pageSize,
			deptStr: deptStr,
			busiStr: busiStr,
			userStr: userStr,
			xAxis_str: xAxis_str,
			success: function (data, total) {
				abnlDetectGrid.loadHeader(false);
				if(data == null){
					$('#chartArea1').html('<div style="width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;"><img src="<c:url value="/img/icon/img_nodata.png"/>" alt="No Data" width="100px;" height="100px" className="xcn_nodata"/></div>');
					$('#space').height('7px');
					searchFlag = false;
					return;
				}
				abnlDetectGrid.setData(data.pivotData);
				$('#statlist_cnt').html('<s:message code="common.msg.finish_query"/>:' + abnlDetectGrid.data.length);
				if (abnlDetectGrid.loadingPage == 0) abnlDetectGrid.Select(-1, -1);
				searchFlag = false;
				if (data.pivotData.length > 1) {
					for (var i = 0; i < data.length; i++) {
						var selected = false;
						if (i <= 4) selected = true;
						else if (i >= 10) break;
						addOption('chartListCount', (i + 1), (i + 1), selected);
					}

					var dat = abnlDetectGrid.getRowData(abnlDetectGrid.Row);
					totalChartDat = dat;
					printChart(dat);
				} else {
					$('#chartArea1').html('<div style="width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;"><img src="<c:url value="/img/icon/img_nodata.png"/>" alt="No Data" width="100px;" height="100px" className="xcn_nodata"/></div>');
					$('#space').height('7px');
				}
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				abnlDetectGrid.off();
			}
		});
	}

	function getDetailData(lastRow) {
		currentgrid = getCurrentGrid();
		if (searchFlag) return;
		if (lastRow == 'Y' || lastRow == undefined) {
			currentgrid.data.length = 0;
			currentgrid.rtnNextPageFunc = getDetailData;
			currentgrid.loadingPage = 0;
		} else {
			currentgrid.loadingPage++;
		}


		var busi = arrayToString($('#busiSelect').selectpicker('val'));
		var dv = $('#deptVal').val().split('|');
		var dept = dv.join(',');
		var deptStr = '';
		if (dept != '') deptStr = $('#deptStr').val();
		else deptStr = '';

		var uv = $('#userVal').val().split('|');
		var user = uv.join(',');

		var userStr = '';
		if (user != '') userStr = user;
		else userStr = '';

		var xAxis = $('button.optionBtn.active').val();
		var xAxis_str = $('button.optionBtn.active').text();
		searchFlag = true;
		currentgrid.on();
		currentgrid.pageSize = 5000;

		let searchAfter = null;
		if (currentgrid.loadingPage > 0) {
			searchAfter = currentgrid.getValue(currentgrid.data.length-1, 'msgid');
		}

		ui.get({
			url: 'getAbnlDetectStatDetailList.xcn',
			rowKey: rowKey,
			colKey: colKey,
			startDate: $('#startdate').val().replaceAll("-", "") + "000000",
			endDate: $('#enddate').val().replaceAll("-", "") + "235959",
			detailQuery: '',
			xAxis: xAxis,
			xAxis_str: xAxis_str,
			yAxis: 'srcip',
			deptStr: dept,
			busiStr: busi,
			userStr: userStr,
			offset: currentgrid.data.length,
			limit: currentgrid.pageSize,
			searchAfter: searchAfter,
			nameStat: 'users',
			success: function (data, total) {
				if (lastRow == 'Y' || lastRow == undefined) detailTotal = total;
				currentgrid.appendData(data.emass);
				if (currentgrid.loadingPage == 0) currentgrid.Select(-1, -1);

				$('#detailTab' + tabID + ' .badge').html('&nbsp;[' + total.comma() + ']');
				$('#detail_cnt' + tabID).html('<s:message code="common.msg.finish_query"/>: ' + currentgrid.data.length);
				searchFlag = false;
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				currentgrid.off();
			}
		})
	}

	function getSelectedCodeData(codeType, data) {
		var str = '';
		var val = '';
		var dept = '';
		var jib = '';

		for (var i = 0; i < data.length; i++) {
			str += data[i].codeName;
			val += data[i].code;

			dept += (data[i].tempNm1 !== undefined) ? data[i].tempNm1 : "";

			jib += (data[i].tempNm2 !== undefined) ? data[i].tempNm2 : "";

			if (i != data.length - 1) {
				str += ', ';
				val += '|';
				dept += '|';
				jib += '|';
			}
		}
		if (val != '') {
			str = str.rtrim();
			val = val.trimAll();
			dept = dept.trimAll();
			jib = jib.trimAll();
		}

		$('#' + codeType + 'Str').val(str);
		$('#' + codeType + 'Val').val(val);
		$('#' + codeType + 'Dept').val(dept);
		$('#' + codeType + 'Jib').val(jib);

		$('#' + codeType + 'SelectedArea').show();
		if ($('#' + codeType + 'Str').val() != '') {
			$('#' + codeType + 'SelectedArea').find('.btn').text(data.length);
		} else {
			$('#' + codeType + 'SelectedArea').find('.btn').text(0);
		}
	}

</script>