<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title></title>
<%@ include file="../base.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/bootstrap-datetimepicker.min.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/vis.min.css"/>"/>
<style>

.btn-popover {
	position: absolute;
	top: 0;
	right: 0;
	text-align: center;
	font-size: 14px;
	padding:3px;
	margin-top:5px;
	margin-right:20px;
}

#chartPopover .popover {
	min-width:610px;
	width:610px;
	height:270px;
}

/*
 * tabGrid 관련 css
 */
</style>
<s:message code="common.datescript" var="ko"/>
<script type="text/javascript" src="<c:url value="/js/jquery.browser.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/d3.v3.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/moment.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/collapse.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/${ko}"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/Date.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>

<%@ include file="./analysisBase.jsp"%>
<script>
var searchFlag = false;
var searchFlagGrid2 = false;
var resultTotal = 0;
var detailTotal = 0;
var rowKey = "";
var colKey = "";
$(document).ready(function(){
	
	$('#dateYesterday').click(function(){
		$("select option[value='t']").show();
		$("select option[value='d']").show();
		$("select option[value='w']").prop("selected", false); 
		
		$('#startDate').val(addDay(-1));
		$('#endDate').val(addDay(-1));
	});

	$('#dateToday').click(function(e){
		$("select option[value='t']").show();
		$("select option[value='d']").show();
		$("select option[value='w']").prop("selected", false); 
		
		$('#startDate').val(addDay(0));
		$('#endDate').val(addDay(0));
	});
	
	$('#dateWeek').click(function(){
		$("select option[value='t']").show();
		$("select option[value='d']").show();
		$("select option[value='w']").prop("selected", false); 
		
		$('#startDate').val(addDay(-7));
		$('#endDate').val(addDay(0));
	});

	$('#dateMonth').click(function(){
		$("select option[value='t']").show();
		$("select option[value='d']").show();
		$("select option[value='w']").prop("selected", false); 
		
		$('#startDate').val(addMonth2(-1));
		$('#endDate').val(addDay(0));
	});

	$('#dateYear').click(function(){
		$("select option[value='t']").hide();
		$("select option[value='d']").hide();
		$("select option[value='w']").prop("selected", true); 
		
		$('#startDate').val(addYear(-1));
		$('#endDate').val(addDay(0));
	});

	$('#startdatepicker').datetimepicker({
		format: 'YYYY-MM-DD',
		locale: 'ko',
		defaultDate: moment(new Date())
	}).on('dp.change',function(event){
		selectDateCount();
	});
	
	$('#enddatepicker').datetimepicker({
		format: 'YYYY-MM-DD',
		locale: 'ko',
		defaultDate: moment(new Date())
	}).on('dp.change',function(event){
		selectDateCount();
	});		
	
	$('#btnSearch').click(function(){
		getUsageChart();
	});

	$('#btnReset').click(function(){
		$("#frm").each(function(){
			this.reset();
		});
		$('#startDate').val(addDay(0));
		$('#endDate').val(addDay(0));
	});
	
	grid1.onClick = function() {
		rowKey = grid1.getValue(grid1.Row, 'val');
		selectDetail(rowKey);		
	};
	
	$("#startDate, #endDate, #unit, #item").keyup(function(event){
		eventEnterSearch(event);
	});

	$('#chartPopover [data-toggle="popover"]').popover({
		html: true,
		content: function() {
			return $('#popover-content-chart').html();
		}
	});
	
	$('#detailListCount .caret').change(function(){ 
		grid2.pageSize = Number( $('#detailListCount .caret').attr('val') );
		selectDetailList('Y');
	});
	
	colInit2('N');
});
function selectDateCount(){
	var startDate = $('#startDate').val();	
	var endDate =  $('#endDate').val();
	
	var startTime = new Date(startDate).getTime();
	var endTime = new Date(endDate).getTime();
	
	var diff = (endTime-startTime)/(1000*60*60*24);
	if(diff > 31){
		$("select option[value='t']").hide();
		$("select option[value='d']").hide();
		$("select option[value='w']").prop("selected", true); 
	}else{
		$("select option[value='t']").show();
		$("select option[value='d']").show();
		$("select option[value='w']").prop("selected", false); 
	}
	if(startDate > endDate) {
		alert('<s:message code="analysis.freedom.ui.msg1"/>');
		return;
	}	
}
function eventEnterSearch(event) {
	if(event.keyCode == 13){
		$("#btnSearch").click();
	}
}
</script>
</head>
<body class="mini-navbar">
	<jsp:include page="../top.jsp">
		<jsp:param name="headerCloseYn" value="Y"/>
	</jsp:include>
	<div class="container"> 
		<div class="boxArea">
			<div class="content_body">
				<form id="frm">
					<div class="row">
						<div class="col-xs-12">
							<div class="form-group form-inline not-dashed">
								<div class="form-group form-inline not-dashed">
									<label for="startdate"><s:message code="condition.period"/>:</label> 
									<div class='input-group date' id='startdatepicker'>
										<input type='text' class="input-sm form-control" id='startDate' name='startDate' />
										<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
										</span>
									</div>
									~
									<div class='input-group date' id='enddatepicker'>
										<input type='text' class="input-sm form-control" id='endDate' name='endDate' />
										<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
										</span>
									</div>
								</div>
								<div class="form-group form-inline not-dashed">
									<button type="button" id="dateYesterday" accesskey="Y" class="btn btn-sm btn-default"><s:message code="condition.yesterday"/></button>
									<button type="button" id="dateToday" accesskey="T" class="btn btn-sm btn-default"><s:message code="condition.today"/></button>
									<button type="button" id="dateWeek" accesskey="W" class="btn btn-sm btn-default"><s:message code="condition.week" arguments="1" argumentSeparator="|"/></button>
									<button type="button" id="dateMonth" accesskey="M" class="btn btn-sm btn-default"><s:message code="condition.month" arguments="1" argumentSeparator="|"/></button>
									<button type="button" id="dateYear" accesskey="E" class="btn btn-sm btn-default"><s:message code="condition.latelyyear" arguments="1" argumentSeparator="|"/></button>
								</div>
							</div>
						</div>
					</div>
					<div class="row top_space">
						<div class="col-xs-12">
							<div class="form-group form-inline not-dashed">
								<div class="form-group">
									<label for="unit"><s:message code="analysis.usagecompare.groupunit"/>:</label>
									<select id="unit" name="unit" class="input-sm form-control">
										<option value="t"><s:message code="analysis.usagecompare.timeunit"/></option>
										<option value="d"><s:message code="analysis.usagecompare.dayunit"/></option>
										<option value="w"><s:message code="analysis.usagecompare.weekunit"/></option>
										<option value="m"><s:message code="analysis.usagecompare.monthunit"/></option>
									</select>
								</div>
								<div class="form-group form-inline not-dashed" style="margin-left: 15px;">
									<label for="item"><s:message code="analysis.usagecompare.searchitem"/>:</label>
									<select id="item" name="item" class="input-sm form-control">
										<option value="totalSize"><s:message code="analysis.relation.ui.packetsize"/></option>
										<option value="fileSize"><s:message code="analysis.relation.attachsize"/></option>
										<option value="inMail"><s:message code="analysis.usagecompare.ui.mailcount"/></option>
										<option value="outMail"><s:message code="analysis.usagecompare.ui.webmailcount"/></option>
										<option value="ftp">FTP(GET/PUT)</option>
									</select>
								</div>
								<div class="form-group form-inline not-dashed">
									<div class="input-group">
										<button type="button" class="btn btn-success btn-sm" accesskey="Q" id="btnSearch"><span class="glyphicon glyphicon-search"></span></button>
									</div>
									<div class="btn-group form-inline not-dashed">
										<button type="button" id="btnReset" accesskey="R" class="btn btn-sm btn-default btn-warning">
											<span class="glyphicon glyphicon-refresh"></span>&nbsp;<s:message code="condition.reset"/>
										</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</form>
				<div class="row top_space">
					<div class="col-xs-12">
						<div class="panel panel-default" >
							<div class="panel-heading">
								<i class="fa fa-area-chart fa-fw"></i><span id="chartAreaTitle"><s:message code="analysis.usagecompare.ui.usagecomparechart"/> </span>
								<span id="chartPopover" class="btn-popover">
									<a tabindex="0" class="btn btn-xs" role="button" data-toggle="popover" data-trigger="focus" data-container="#chartPopover" data-html="true" data-placement="bottom" title="<s:message code="analysis.usagecompare.ui.avgsearchdata"/>"><span class="glyphicon glyphicon-question-sign" style="font-size:20px;"></span></a>
								</span>
								<div id="popover-content-chart" class="hide" style="height:100%;">
									<div style="padding-left:10px;">
										<ul style="padding-left:15px;">
											<li style="margin-bottom:7px;"><font color="red"><s:message code="analysis.usagecompare.timeunit"/></font> : <s:message code="analysis.usagecompare.ui.msg1"/></li>
											<li style="margin-bottom:7px;"><font color="red"><s:message code="analysis.usagecompare.dayunit"/></font> : <s:message code="analysis.usagecompare.ui.msg2"/></li>
											<li style="margin-bottom:7px;"><font color="red"><s:message code="analysis.usagecompare.weekunit"/></font> : <s:message code="analysis.usagecompare.ui.msg3"/></li>
											<li><font color="red"><s:message code="analysis.usagecompare.monthunit"/></font> : <s:message code="analysis.usagecompare.ui.msg4"/></li>
										</ul>
									</div>
								</div>
							</div>
							<div class="panel-body">
								<div id="compareChart" style="height: 250px;"><s:message code="analysis.usagecompare.search"/></div>
							</div>
						</div>
					</div>
				</div>
				<div class="row" style="margin-bottom:5px;">
					<div class="col-lg-4">
						<div class="panel with-nav-tabs" style="height:100%;">
							<div class="panel-heading" style="padding:0;">
								<ul class="nav nav-tabs codeTab">
									<li class="active" ><a data-target="#result0" aria-controls="result0" role="tab" data-toggle="tab"><s:message code="analysis.usagecompare.ui.usersum"/></a></li>
								</ul>
							</div>
							<div class="panel-body" style="padding: 4px 0px 0px 0px;">
								<div class="tab-content" style="height:100%;" id="resultData">
									<div role="tabpanel" class="tab-pane fade active in" id="result0">
										<div id="usageList">
											<div style="min-height:400px;height: 400px;">
												<div id="usageListGrid" class="slickGrid gridArea" style="height: 100%;"></div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-lg-8">
						<div class="panel with-nav-tabs" style="height:100%;">
							<div class="panel-heading" style="padding:0;">
								<ul class="nav nav-tabs codeTab">
									<li class="active" ><a data-target="#result0" aria-controls="result0" role="tab" data-toggle="tab"><s:message code="analysis.usagecompare.ui.detaillist"/></a></li>
								</ul>
							</div>
							<div class="panel-body" style="padding: 4px 0px 0px 0px;">
								<div class="tab-content" style="height:100%;" id="resultData">
									<div role="tabpanel" class="tab-pane fade active in" id="result0">
										<div id="detailList">
											<div style="min-height:400px;height: 400px;">
												<div id="detailListGrid" class="slickGrid gridArea" style="height: 100%;"></div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Back to top -->
	<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>
	
	<script type="text/javascript">

		var unit = "";
		var item = "";
		var itemName = "";
		var seletDate = "";

		var grid1 = new Xgrid('usageListGrid', contextRoot, 26, {status_cnt_id:'#usageCnt'});
		colInit();

		function colInit() {
			var itemVal = $("#item option:selected").val();
			var name = '<s:message code="common.svc.mail"/>';
			var val = ""
			switch(itemVal) {
			case "fileSize" : 
				name = '<s:message code="analysis.usagecompare.ui.filename"/>';
				break;
			case "ftp" : 
				name = '<s:message code="condition.source"/> IP';
				break;
			case "totalSize" : 
				name = '<s:message code="condition.source"/> IP';
				break;
			}

			grid1.colInit();
			grid1.autoNumber();
			grid1.colAdd('val', name, 130, 'left', false, 'link' );
			grid1.colAdd('count', '<s:message code="analysis.relation.ui.collectcount"/>', 100, 'center', false, 'nomal' , function ( row, cell, value, columnDef, dataContext ) {
				if ( value != undefined ) return value.comma();
				else return '';
			} );
			grid1.colAdd('size', '<s:message code="analysis.relation.ui.packetsize"/>', 120, 'right', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
				if ( value != undefined ) return convertFileSize(value);
				else return '';
			} );
			grid1.loadHeader(false);
			grid1.initData('<s:message code="common.msg.search.click"/>');
		}
		var grid2 = new Xgrid('detailListGrid', contextRoot, 26, {commonId:'selectTotalList', status_cnt_id:'#detailCnt', more_btn:'slick_grid_more_btn'});

		function colInit2(reloadYN) {
			grid2.colInit();
			initGrid(grid2, messageGridColumn);
			if(reloadYN != 'Y') {
				grid2.loadExportMenu('<s:message code="analysis.usagecompare.ui.datacompareanalysis"/>');
				grid2.loadPageSize();
				//writeExportMenu('export_menu', 'detailListGrid', '<s:message code="analysis.usagecompare.ui.datacompareanalysis"/> - <s:message code="analysis.freedom.ui.msglist"/>');
			}
		}

		function getUsageChart() {
			if($('#startDate').val() > $('#endDate').val()) {
				alert('<s:message code="analysis.freedom.ui.msg1"/>');
				return;
			}
			var yAxisTitle = '<s:message code="analysis.usagecompare.ui.mailcount"/>';
			if($('#item option:selected').val() == "fileSize" || $('#item option:selected').val() == "ftp" || $('#item option:selected').val() == "totalSize") { 
				yAxisTitle = '<s:message code="analysis.relation.ui.packetsize"/>';
			}
			unit = $('#unit option:selected').val();
			item = $('#item option:selected').val();
			itemName = $('#item option:selected').text();
			ui.get({
				url : 'analysis/selectUsageChart.xcn',
				unit : $('#unit option:selected').val(),
				startDate : $('#startDate').val(),
				endDate : $('#endDate').val(),
				item : $('#item option:selected').val(),
				itemName : $('#item option:selected').text(),
				success : function(data, total) {
					lineChart.title("");
					lineChart.yAxisTitle(yAxisTitle);
					lineChart.chart('#compareChart', data, 'area');

					gridInit();
				},
				error : function(status, message) {
					ui.alertMsg(message);
				}
			});
		}
		
		function gridInit() {
			$('#usageCnt').html('');
			$('#detailCnt').html('');
			$('.resultCnt').html('');
			colInit();
			colInit2('Y');
		}

		var selectDate = '';
		function selectUsageList(date) {
			selectDate = date;
			getGridList('Y');
		}

		function getGridList(flag) {
			if ( searchFlag ) return;

			$("#usageList").show();
			if ( flag == 'Y' || flag == undefined ) {
				grid1.data.length = 0;
				grid1.loadingPage = 0;
				grid1.rtnNextPageFunc = getGridList;
			} else {
				grid1.loadingPage++;
			}
			
			searchFlag = true;
			grid1.on();
			
			ui.get({
				url : 'analysis/selectUsageList.xcn',
				unit : unit,
				date : selectDate,
				item : item,
				itemName : itemName,
				xAxis : unit,
				yAxis : item,
				offset : grid1.data.length,
				limit : grid1.pageSize,
				success : function(data, total) {
					resultTotal = total;
					grid1.autoNumber();
					colInit();
					grid1.loadHeader(false);
					grid1.appendData(data);
					
					//$('#usageCnt').html('<s:message code="analysis.ui.searchend"/>: '+grid1.data.length);
					searchFlag = false;
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
					grid1.off();
				}
			});
		}

		var selectKey = '';
		function selectDetail( key ) {
			selectKey = key;
			selectDetailList('Y');
		}

		function selectDetailList( flag ) {
			if ( searchFlagGrid2 ) return;
			
			$("#detailList").show();
			if ( flag == undefined || flag == 'Y') {
				grid2.data.length = 0;
				grid2.rtnNextPageFunc = selectDetailList;
				grid2.loadingPage = 0;
			} else {
				grid2.loadingPage++;
			}
			grid2.on();

			var yAxis = $('select[name=unit]').val();
			
			ui.get({
				url : 'analysis/selectDetailList.xcn',
				unit : unit,
				date : selectDate,
				item : item,
				itemName : itemName,
				keyword : selectKey,
				offset : grid2.data.length,
				limit : grid2.pageSize,
				success : function(data, total) {
					resultTotal = total;
					grid2.autoNumber();
					grid2.loadHeader(false);
					grid2.appendData(data.list);
					$(".resultCnt").html('('+addCommas(data.total)+')');
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
					grid2.off();
				}
			});
		}

		var lineChart = new function () {

			this.titleName = "";
			this.title = function (titleName) {
				this.titleName = titleName;
			}
			this.yAxisTtitleName = '<s:message code="analysis.usagecompare.ui.mailcount"/>';
			this.yAxisTitle = function (yAxisTtitleName) {
				this.yAxisTtitleName = yAxisTtitleName;
			}

			this.chart = function (id, data, column) {

				return $(id).highcharts({
					chart: {
						type: column,
						events: {
							selection: function (event) {
								var text,
									label;
								if (event.xAxis) {
									text = 'min: ' + Highcharts.numberFormat(event.xAxis[0].min, 2) + ', max: ' + Highcharts.numberFormat(event.xAxis[0].max, 2);
								} else {
									text = 'Selection reset';
								}
								label = this.renderer.label(text, 100, 120).attr({
									fill: Highcharts.getOptions().colors[0],
									padding: 10,
									r: 5,
									zIndex: 8
								}).css({
									color: '#FFFFFF'
								}).add();

								setTimeout(function () {
									label.fadeOut();
								}, 1000);
							}
						},
						/* zoomType: 'x' */
					},
					exporting: chartAPI.exporting,
					credits: chartAPI.credits,
					title: {
						text: this.titleName
					},
					xAxis: {
						categories: data.categories
					},
					yAxis: {
						title: {
							text: this.yAxisTtitleName
						},
						labels: {
							formatter: function() {
								var item = $("#item option:selected").val();
								if(item == "fileSize" || item == "ftp" || item == "totalSize") {
									if(this.value < 1001) {
										return this.value + "byte";
									} else if(this.value > 1000 && this.value < 1000001) {
										return Math.round(this.value / 1000) + "Kb";
									} else if(this.value > 1000000 && this.value < 1000000001) {
										return Math.round(this.value / 1000 / 1000) + "Mb";
									} else {
										return Math.round(this.value / 1000 / 1000 / 1000) + "Gb";
									}
								} else {
									return this.value;
								}
							}
						}
					},
					plotOptions: {
						series: {
							cursor: 'pointer',
							events: {
								click: function (event) {
									selectUsageList(event.point.category);
								}
							}
						}
					},
					legend: {
						layout: 'vertical',
						align: 'right',
						verticalAlign: 'middle',
						borderWidth: 0
					},
					series: data.series
				});
			};
		};

		var barChart = new function () {

			this.titleName = "";
			this.title = function (titleName) {
				this.titleName = titleName;
			}
			this.yAxisTtitleName = '<s:message code="analysis.usagecompare.ui.mailcount"/> ';
			this.yAxisTitle = function (yAxisTtitleName) {
				this.yAxisTtitleName = yAxisTtitleName;
			}

			this.chart = function (id, data, column) {

				return $(id).highcharts({
					chart: {
						type: column,
						events: {
							selection: function (event) {
								var text,
									label;
								if (event.xAxis) {
									text = 'min: ' + Highcharts.numberFormat(event.xAxis[0].min, 2) + ', max: ' + Highcharts.numberFormat(event.xAxis[0].max, 2);
								} else {
									text = 'Selection reset';
								}
								label = this.renderer.label(text, 100, 120)
									.attr({
										fill: Highcharts.getOptions().colors[0],
										padding: 10,
										r: 5,
										zIndex: 8
									})
									.css({
										color: '#FFFFFF'
									})
									.add();

								setTimeout(function () {
									label.fadeOut();
								}, 1000);
							}
						},
						zoomType: 'x'
					},
					exporting: chartAPI.exporting,
					credits: chartAPI.credits,
					title: {
						text: this.titleName
					},
					xAxis: {
						type: 'category'
					},
					yAxis: {
						min: 0,
						title: {
							text: this.yAxisTtitleName
						},
						labels: {
							formatter: function() {
								var item = $("#item option:selected").val();
								if(item == "fileSize" || item == "ftp" || item == "totalSize") {
									if(this.value < 1001) {
										return this.value + "byte";
									} else if(this.value > 1000 && this.value < 1000001) {
										return Math.round(this.value / 1000) + "Kb";
									} else if(this.value > 1000000 && this.value < 1000000001) {
										return Math.round(this.value / 1000 / 1000) + "Mb";
									} else {
										return Math.round(this.value / 1000 / 1000 / 1000) + "Gb";
									}
								} else {
									return this.value;
								}
							}
						}
					},
					legend: {
						layout: 'vertical',
						align: 'right',
						verticalAlign: 'middle',
						borderWidth: 0
					},
					series: data
				});
			};
		};

		/*
		 * tabGrid 관련 함수
		 */
		function viewer_open(row, bodySize ){
			var msgid = grid2.getValue(row, 'msgid');

			openMessageBodyPop( grid2.id, msgid, '', bodySize);
			
			var readYn = grid2.getValue(row, 'readYn');
			grid2.setValue(row, grid2.ColIndex('readYn'), 'Y');
			grid2.Select(row,0);
		}

		function viewer_newOpen(row, bodySize){
			var msgid = grid2.getValue(row, 'msgid');
			openMessageBodyPop( '', msgid, '', bodySize);
			
			var readYn = grid2.getValue(row, 'readYn');
			grid2.setValue(row, grid2.ColIndex('readYn'), 'Y');
		}

		function prevMsg( ) {
			var grid = grid2;
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
			var grid = grid2;
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

	</script>
</body>
</html>