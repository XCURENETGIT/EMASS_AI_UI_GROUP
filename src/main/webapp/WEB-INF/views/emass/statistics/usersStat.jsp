<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS LTH - <s:message code="DATA_MONITOR.STAT_LABEL"/></title>
	<style type="text/css">
		.panel-heading .dropdown-menu {
			right: 31px;
			top: 42px;
			left: initial;
		}
	</style>
	<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>
	<script>
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
		$(document).ready(function(){

			$('.optionBtn').click(function () {
				$('.optionBtn').removeClass('active');
				$(this).addClass('active');
				$('#optionHidden').attr("value", $(this).val());
				$('#optionHiddenName').attr("value", $(this).text());

			});


			$('#searchBtn').click(function(){
				closeDetailTab();
				getData ('Y');
			});

			$('#chartCntDiv .dropdown-menu li a').click(function(){
				chartcnt = $(this).text();
				printChart(totalChartDat);
			});

			$('#startdatepicker').datetimepicker({
				format: 'YYYY-MM-DD',
				locale: 'ko',
				defaultDate: moment(new Date())
			});

			$('#enddatepicker').datetimepicker({
				format: 'YYYY-MM-DD',
				locale: 'ko',
				defaultDate: moment(new Date())
			});

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

			$('.listChart').on('click','.close',function(){
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

			$('.print_stat').click(function() {
				var gridDetail = getCurrentGrid();
				if(gridDetail != undefined) {
					if (gridDetail.Rows == 0) {
						alert('<s:message code="common.msg.nodata"/>');
						return;
					}
					gridDetail.print('<s:message code="stat.detail.user.list"/>', pMenuId, menuId);
				} else {
					if (grid1.Rows == 0) {
						alert('<s:message code="common.msg.nodata"/>');
						return;
					}
					grid1.print('<s:message code="DATA_MONITOR.STAT_USER"/>', pMenuId, menuId);
				}
			});

			$('.excel_stat').click(function() {
				var gridDetail = getCurrentGrid();
				if(gridDetail != undefined) {
					excelDownLoad(gridDetail,'<s:message code="stat.detail.user.list"/>');
				} else {
					chart = $('#chartArea1').highcharts();
					var svg = chart.getSVG();
					excelDownLoad(grid1,'<s:message code="DATA_MONITOR.STAT_USER"/>', svg);
				}
			});

			$('.cell_stat').click(function() {
				var gridDetail = getCurrentGrid();
				if(gridDetail != undefined) {
					cellDownLoad(gridDetail,'<s:message code="stat.detail.user.list"/>');
				} else {
					cellDownLoad(grid1,'<s:message code="DATA_MONITOR.STAT_USER"/>');
				}
			});

			$('.pdf_stat').click(function() {
				var gridDetail = getCurrentGrid();
				if(gridDetail != undefined) {
					pdfDownLoad(gridDetail,'<s:message code="stat.detail.user.list"/>');
				} else {
					pdfDownLoad(grid1,'<s:message code="DATA_MONITOR.STAT_USER"/>');
				}
			});

			$('.csv_stat').click(function() {
				var gridDetail = getCurrentGrid();
				if(gridDetail != undefined) {
					csvDownLoad(gridDetail,'<s:message code="stat.detail.user.list"/>');
				} else {
					csvDownLoad(grid1,'<s:message code="DATA_MONITOR.STAT_USER"/>');
				}
			});

			$('.totalView').click(function(){
				$("#chartCntDiv").show();
				$('#totalViewDiv').hide();
				printChart(totalChartDat);
			});

			$('.searchQueryBtn').click(function(){
				queryMakePop();
			});


			//getData ('Y');

		});

		function setGrid( ){
			currentgrid = getCurrentGrid();
			initGrid(currentgrid, messageGridColumn);
		}

		function closeDetailTab()
		{
			var tabFirst = $('.listChart a:first');
			tabFirst.tab('show');
		}

		/*
        function regexpInfoViewer(row){
            var selectedTabIdx = $('.listChart').find('.active').index();
            var grid = window.__grids[selectedTabIdx];
            var msgid = grid.getValue(row, 'msgid');
            if(grid.getValue(row, 'pi_total') == '') return;

            var url    = '<c:url value="/ems/regexpInfoPop.do?msgId='+msgid+'"/>';
	return fnOpenWindow(url, 'regexpInfoPop', 1100, 370, 'resize');
}
function userInfoViewer(row, type){
	var selectedTabIdx = $('.listChart').find('.active').index();
	var grid = window.__grids[selectedTabIdx];
	var msgid = grid.getValue(row, 'msgid');
	if(grid.getValue(row, type) == '') return;

	var url    = '<c:url value="/ems/userInfoPop.do?msgId='+msgid+'&type='+type+'"/>';
	return fnOpenWindow(url, type+'InfoPop', 835, 370, 'resize');
}

function fileInfoViewer( row ){
	var selectedTabIdx = $('.listChart').find('.active').index();
	var grid = window.__grids[selectedTabIdx];
	var msgid = grid.getValue(row, 'msgid');
	if(grid.getValue(row, 'attachcnt') == '') return;

	var url    = '<c:url value="/ems/fileInfoPop.do?msgId='+msgid+'"/>';
	return fnOpenWindow(url, 'fileInfoPop', 1015, 400, 'resize');
}
*/

		function viewer_open( row, bodySize){
			var selectedTabIdx = $('.listChart').find('.active').index();
			var grid = window.__grids[selectedTabIdx];
			var msgid = grid.getValue(row, 'msgid');
			var ctime = $('#searchStrInput').val();

			openMessageBodyPop( grid.id, msgid, $('#searchStrInput').val(), bodySize);

			var readYn = grid.getValue(row, 'readYn');
			grid.setValue(row, grid.ColIndex('readYn'), 'Y');
			grid.Select(row,0);
		}

		function viewer_newOpen(row, bodySize){
			var selectedTabIdx = $('.listChart').find('.active').index();
			var grid = window.__grids[selectedTabIdx];
			var msgid = grid.getValue(row, 'msgid');
			var ctime = $('#searchStrInput').val();
			openMessageBodyPop( '', msgid, $('#searchStrInput').val(), bodySize);

			var readYn = grid.getValue(row, 'readYn');
			grid.setValue(row, grid.ColIndex('readYn'), 'Y');
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
			console.log("grid.Row = "+grid.Row)
			console.log("grid.Rows = "+grid.Rows)
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

		/**
		 * Bar Chart
		 */
		var chart = null;
		var chartxAxis;
		function printChart( dat )
		{
			var data = [];
			var categories = [];
			var cols = grid1.columns;
			var maxDat = 0;
			if( dat == undefined ) {
				for ( var i=0 ; i < grid1.data.length ; i++ ) {
					if ( (i+1) > chartcnt ) break;
					var items = [];
					for ( var j=1 ; j < cols.length ; j++ ) {
						if ( cols[j].id == 'total' || cols[j].id == 'NUM' || cols[j].id == 'rowKey' ) continue;
						if ( grid1.data[i][cols[j].id] == undefined ) items.push(0);
						else items.push( Number( grid1.data[i][cols[j].id] ) );
						if ( i == 0 ) categories.push( cols[j].name );
						if(Number( grid1.data[i][cols[j].id] ) > maxDat) maxDat = Number( grid1.data[i][cols[j].id] );
					}
					if(grid1.data[i]['NUM'] == '<s:message code="bodyview.total"/>') continue;
					else data.push({name:grid1.data[i]['rowKey'], data:items});
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
				chart: {
					type: 'column',
					options3d: {
						enabled: true,
						alpha: 0,
						beta: 0,
						viewDistance: 15,
						depth: 40
					},
					marginTop: 25,
					marginRight: 45
				},
				title: {
					text: null
				},
				exporting: chartAPI.exporting,
				credits: chartAPI.credits,
				xAxis: {
					categories: categories,
					labels : {
						y: 35,
						rotation : rotation
					}
				},
				yAxis: {
					allowDecimals: false,
					min: 0,
					max: maxDat,
					title: {
						text: '(<s:message code="common.msg.count"/>)',
						rotation: 0
					}
				},
				tooltip: {
					headerFormat: '<b>{point.key}</b><br>',
					pointFormat: '<span style="color:{series.color}">\u25CF</span> {series.name}: {point.y} (<s:message code="common.msg.cnt"/>)'
				},
				plotOptions: {
				},
				series: data
			});
		}

		function excelDownLoad(grid, title, svg) {
			if (grid.Rows == 0) {
				alert('<s:message code="common.msg.nodata"/>');
				return;
			}
			var header = grid.getHeaderEXCEL();
			var body = grid.getBodyEXCEL();
			grid.on();
			ui.postJson({
				url : 'utils/xlsxWriter.do',
				title : title,
				header : header,
				body : body,
				pMenuId : pMenuId,
				menuId: menuId,
				svg : svg,
				success : function(data, total) {
					try {
						ExcelDown.location.href = '<c:url value="/utils/xlsxDown.do"/>?path=' + data;
					} catch (e) {
						ExcelDown.src = '<c:url value="/utils/xlsxDown.do"/>?path=' + data;
					}
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
					grid.off();
				}
			});
		}

		function queryMakePop(  ){
			var url    = '<c:url value="/commons/queryMake.do?statType=users"/>';
			fnOpenWindow(url, 'queryMakePop', 1400, 870, 'resize');
		}

		function getSearchQuery() {

		}
	</script>
</head>
<body class="mini-navbar">
<input id="searched_xAxis" type="hidden"/>
<input id="searched_startDate" type="hidden"/>
<input id="searched_endDate" type="hidden"/>
<div class="container">

	<div class="searchArea">
		<div class="searchSub">
			<div id="startdatepicker"><input type="date" id="startdate" style="width: 110px;"> <span
					class="hyphen">~</span></div>
			<div id="enddatepicker"><input type="date" id="enddate" style="width: 110px;"></div>

			<div class="optiotab">
				<button class="optionBtn active" id="ctime_hh" value="ctime_hh"><s:message
						code="common.msg.time"/></button>
				<button class="optionBtn" id="ctime_yyyymmdd" value="ctime_yyyymmdd" class="active"><s:message
						code="common.msg.day"/></button>
				<button class="optionBtn" id="ctime_yyyymm" value="ctime_yyyymm"><s:message
						code="common.msg.month"/></button>
				<button class="optionBtn" id="businm" value="businm"><s:message code="common.org.busi"/></button>
				<button class="optionBtn" id="conm" value="conm"><s:message code="common.org.co"/></button>
				<button class="optionBtn" id="deptnm" value="deptnm"><s:message code="common.org.dept"/></button>
				<button class="optionBtn" id="direction_svc" value="direction_svc"><s:message
						code="condition.receive_send"/></button>
				<button class="optionBtn" id="jikgubnm" value="jikgubnm"><s:message
						code="common.org.jikgub"/></button>
				<input type="hidden" value="ctime_hh" id="optionHidden">
				<input type="hidden" value="시간" id="optionHiddenName">
			</div>
			<div>
				<button class="form_btn01" accesskey="Q" id="searchBtn" accesskey="s">조회</button>
				<button class="form_btn02">조건 초기화</button>
				<button type="button" class="form_btn05"><s:message code="query.make.inputer"/></button>
			</div>
		</div>
		<div class="panel" style="width: 100%;">
			<div>
				<textarea class="solrQueryResultText" rows="1" style="width:100%;" id="solrQueryText" placeholder="<s:message code="condition.input.detail"/>"></textarea>
			</div>
		</div>
		<div class="content" style="padding: 20px;">
			<div >
				<div class="chartArea">
					<div>
						<h3>조회기간</h3>
						<div class="sublist">
							<div>
								<span class="tit">TOP1 검출 사용자</span>
								<p id="sub_1"><span class="text">건</span></p>
							</div>
							<div>
								<span class="tit">예약어 합계</span>
								<p>99999<span class="text">건</span></p>
							</div>
							<div>
								<span class="tit">예약어 합계</span>
								<p>99999<span class="text">건</span></p>
							</div>
							<div>
								<span class="tit">예약어 합계</span>
								<p>99999<span class="text">건</span></p>
							</div>
							<div>
								<span class="tit">예약어 합계</span>
								<p>99999<span class="text">건</span></p>
							</div>
							<div>
								<span class="tit">예약어 합계</span>
								<p>99999<span class="text">건</span></p>
							</div>
						</div>
					</div>
					<div>
						<h3>
							TOP 통계 Chart
							<span class="sel">
						<div id="totalViewDiv" style="display:none;">
							<div class="subtab">
							<button type="button"
									title="<s:message code="stat.view.all"/>"><s:message code="stat.view.all"/></button>
							</div>
						</div>
						<div class="panel-headings" id="chartCntDiv">
								<button type="button" class="btn btn-xs btn-default dropdown-toggle"
										data-toggle="dropdown">
									<s:message code="stat.display.count.chart"/> (<span class="dropdown-text">5</span>) <span
										val="5" class="caret"></span>
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
						<div class="panel panel-default" id="service.logging.count">
							<div class="panel-body">
								<div id="chartArea1" style="height: 160px;"></div>
							</div>
						</div>
					</div>
				</div>
				<!-- 탭 -->
				<div class="row top_space2">
					<div class="col-xs-12">
						<ul class="nav nav-tabs codeTab listChart">
							<li class="active"><a data-toggle="tab" href="#basicStatList" id=" ">LIST</a>
							</li>
						</ul>
						</ul>
					</div>
				</div>
				<!-- 테이블 -->
				<div class="row top_space">
					<div class="col-lg-12 tab-content">
						<div id="basicStatList" class="tab-pane fade in active" style="background-color: white">
							<div id="basicStatListGrid" class="slickGrid gridArea"
								 style="position: relative; top: 0px; left: 0px; height: 400px; text-align: center; "></div>
						</div>
					</div>
				</div>
				<!-- pagination -->
				<div class="pageArea">
					<div class="pagination">
						<a href="#"><img src="../img/ico_page_left2.png" alt=""></a>
						<a href="#"><img src="../img/ico_page_left.png" alt=""></a>
						<a href="#">1</a>
						<a class="active" href="#">2</a>
						<a href="#">3</a>
						<a href="#">4</a>
						<a href="#">5</a>
						<a href="#">6</a>
						<a href="#"><img src="../img/ico_page_right.png" alt=""></a>
						<a href="#"><img src="../img/ico_page_right2.png" alt=""></a>
					</div>
				</div>
				<!-- //pagination -->
			</div>

		</div>
		<!-- content 끝-->
	</div>
	<!--ContentArea-->
</div>
<!--//Container-->
</div>

</div>
<script type="text/javascript">

	function setSublist(data) {
		var element = document.getElementById('sub_1');

		if (element && data && data.length > 0 && data[0].rowKey) {
			// 첫 번째 rowKey 값을 가져오기
			var firstRowkey = data[0].rowKey;

			// span 태그에 동적으로 추가
			element.innerHTML = '<span>' + firstRowkey + '</span>';
		}
	}

	function getCurrentGrid(){
		var id = Number($('.listChart .active').attr('idx'));
		return tabInfo['tab'+id];
	}

	var grid1 = new Xgrid('basicStatListGrid', contextRoot);
	grid1.autoNumber();
	grid1.colAdd( "rowKey", '<s:message code="consent.user"/>', 230, "left", false, 'link' );
	grid1.colAdd("total", '<s:message code="bodyview.total"/>', 130, "right", false, 'nomal' );
	grid1.loadExportMenu('<s:message code="DATA_ANALYSIS.STAT_USER"/>');
	grid1.loadPageSize();
	grid1.loadHeader(false);
	grid1.initData('<s:message code="common.msg.search.click"/>');
	grid1.changePageSize = function(cnt){
		getData ('Y');
	};

	var tabInfo={};
	var chartDat={};
	grid1.onClick = function() {
		var valChk = grid1.getValue(grid1.Row, grid1.Col);
		if(valChk == "" || valChk == "-") return;

		if(grid1.getValue(grid1.Row, 'NUM') == '<s:message code="bodyview.total"/>') {
			var key = "";
			for(var i=0; i<grid1.Rows; i++) {
				if(grid1.getValue(i, 'rowKey') == "" || grid1.getValue(i, 'rowKey') == "-") continue;
				else key += grid1.getValue(i, 'rowKey').replaceAll("\"", "\\\"") + ",";
			}
			key = key.substring(0, key.length - 1)
			rowKey = key;
		}else {
			rowKey = grid1.getValue(grid1.Row, 'rowKey').replaceAll("\"", "\\\"");
		}
		rowName = grid1.getValue(grid1.Row, 'rowName');
		colKey = grid1.ColKey(grid1.Col);
		var colKeyNm = colKey;
		if (colKey == 'rowKey' || colKey == 'total' || colKey == 'NUM') {
			colKey = "";
			colKeyNm = '<s:message code="bodyview.total"/>';
		} else if (colKey == "I") {
			colKeyNm = '<s:message code="condition.receive"/>';
		} else if (colKey == "O") {
			colKeyNm = '<s:message code="condition.send"/>';
		} else {
			var xAxis = $('select[name=xAxis]').val();
			if (xAxis == "ctime_hh") colKeyNm = colKey + '<s:message code="common.msg.hour"/>';
		}

		tabID++;
		tabNum ++;
		if( tabNum > 3 ) {
			var delid = $( ".listChart li:nth-child(2)" ).attr('idx');
			$('#detailTab'+delid+' .close').click();
		}

		var displayName = (rowKey.indexOf(',') > -1) ? '<s:message code="common.msg.all"/>' : rowKey.replaceAll("\\\"", "\"");
		if(rowName!='') displayName = rowName + '&lt;' + rowKey + '&gt;';
		var id = 'tab'+tabID;

		$('.listChart').append($('<li style="display:inline-flex; text-align: center" idx="'+tabID+'" id="liTab'+tabID+'"><a data-toggle="tab" href="#tab'+tabID+'" id="detailTab'+tabID+'" >' + displayName + ' - '+colKeyNm + '<span class="badge"></span><button class="close" type="button" title="<s:message code="stat.delete.tab"/>"> ×</button></a></li>'));
		$('#basicStatList').after($('<div class="tab-pane fade" id="tab' + tabID + '"><div id="grid'+tabID+'" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; height: 400px"></div></div>'));

		var gid = 'grid'+tabID;
		var gridObj = new Xgrid(gid, contextRoot);
		tabInfo[id] = gridObj;
		$('.nav-tabs a[href="#tab'+tabID+'"]').tab('show');



		setGrid();

		$("#chartCntDiv").hide();
		$('#totalViewDiv').show();
		var dat = grid1.getRowData( grid1.Row );
		chartDat[tabID] = dat;
		printChart(dat);
		gridObj.loadExportMenu('<s:message code="stat.detail.user.list"/>');
		gridObj.loadPageSize();
		gridObj.changePageSize = function(cnt){
			getDetailData('Y');
		};
		getDetailData('Y');
	};

	function getData( flag ) {
		if ( searchFlag ) return;
		var xAxis = $('select[name=xAxis]').val();
		var xAxis_str = $('select[name=xAxis] option:selected').text();
		var sDate = $('#startdate').val().replaceAll("-", "");
		var eDate = $('#enddate').val().replaceAll("-", "");
		var xAxis = $('#optionHidden').val();
		var xAxis_str = $('#optionHiddenName').val();
		if (sDate > eDate) ui.alertMsg('<s:message code="consent.msg.timecheck"/>');

		searchFlag = true;
		grid1.on();
		ui.get({
			url : 'getStatList.xcn',
			startDate: sDate+"000000",
			endDate: eDate+"235959",
			detailQuery:$('#solrQueryText').val(),
			xAxis : xAxis,
			yAxis : 'userid',
			offset : grid1.data.length,
			limit : grid1.pageSize,
			xAxis_str : xAxis_str,
			success : function(data, total) {
				console.log(data);
				grid1.colInit();
				grid1.autoNumber();
				grid1.colAdd('rowKey', '<s:message code="consent.user"/>', 230, 'left', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
					if(grid1.getValue(row, 'rowName') != '') {
						return grid1.getValue(row, 'rowName') + '&lt;' + value + '&gt;';
					}
					return value;
				});
				grid1.colAdd('total', '<s:message code="bodyview.total"/>', 130, 'right', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
					if ( value != undefined ) return value.comma();
					else return '';
				});
				for ( var i=0 ; i < data.pivotHeader.length ; i++ ) {
					var Header = data.pivotHeader[i];
					var HeaderNm = "";
					if ( xAxis == "ctime_yyyymmdd") HeaderNm = Header.substr(0,4)+"-"+Header.substr(4,2)+"-"+Header.substr(6,2);
					else if ( xAxis == "ctime_yyyymm") HeaderNm = Header.substr(0,4)+"-"+Header.substr(4,2);
					else if ( xAxis == "direction_svc") {
						if(Header == "I") HeaderNm = '<s:message code="condition.receive"/>';
						else HeaderNm = '<s:message code="condition.send"/>';
					} else if ( xAxis == "ctime_hh") HeaderNm = Header+'<s:message code="common.msg.hour"/>';
					else HeaderNm = Header;
					grid1.colAdd( Header, HeaderNm, 90, "right", false, 'link', function ( row, cell, value, columnDef, dataContext ) {
						if ( value != undefined ) return value.comma();
						else return '';
					});
				}
				grid1.loadHeader(false);
				grid1.setData(data.pivotData);

				$('#statlist_cnt').html('<s:message code="common.msg.finish_query"/>:'+grid1.data.length);
				if ( grid1.loadingPage == 0 ) grid1.Select(-1,-1);
				searchFlag = false;

				if( data.pivotData.length > 0 ) {
					for ( var i=0 ; i < data.length ; i++ ) {
						var selected = false;
						if ( i <= 4 ) selected = true;
						else if ( i >= 10 ) break;
						addOption( 'chartListCount', (i+1), (i+1), selected );
					}

					var dat = grid1.getRowData( grid1.Row );
					totalChartDat = dat;
					printChart( dat );
				} else {
					$('#chartArea1').html('<s:message code="common.msg.nodata"/>');
					$('#space').height('7px');
				}
			},
			error : function(status, message) {
				ui.alertMsg(message);
			},
			complete : function() {
				grid1.off();
			}
		});
	}

	function getDetailData( lastRow ) {
		currentgrid = getCurrentGrid();
		if ( searchFlag ) return;

		if ( lastRow == 'Y' || lastRow == undefined ) {
			currentgrid.data.length = 0;
			currentgrid.rtnNextPageFunc = getDetailData;
			currentgrid.loadingPage = 0;
		} else {
			currentgrid.loadingPage++;
		}

		var xAxis = $('#optionHidden').val();
		var xAxis_str = $('#optionHiddenName').val();

		searchFlag = true;
		currentgrid.on();


		ui.get({
			url : 'getStatDetailList.xcn',
			rowKey : rowKey,
			colKey : colKey,
			startDate : $('#startdate').val().replaceAll("-","")+"000000",
			endDate : $('#enddate').val().replaceAll("-","")+"235959",
			detailQuery:$('#solrQueryText').val(),
			xAxis : xAxis,
			xAxis_str : xAxis_str,
			yAxis : 'userid',
			offset : currentgrid.data.length,
			limit : currentgrid.pageSize,
			nameStat : 'users',
			success : function(data, total) {
				if ( lastRow == 'Y' || lastRow == undefined ) detailTotal = total;
				currentgrid.appendData(data.emass);
				if ( currentgrid.loadingPage == 0 ) currentgrid.Select(-1,-1);

				$('#detailTab'+tabID+' .badge').text('[' + total.comma() + ']');
				$('#detail_cnt'+tabID).html('<s:message code="common.msg.finish_query"/>: '+currentgrid.data.length);

				searchFlag = false;
			},
			error : function(status, message) {
				ui.alertMsg(message);
			},
			complete : function() {
				currentgrid.off();
			}
		})
	}
</script>
</body>
</html>