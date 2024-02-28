<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS AI - <s:message code="DATA_MONITOR.STAT_LABEL"/></title>
	<script>
        var searchFlag = false;
        var detailTotal = 0;
        var rowKey = "";
        var colKey = "";
        var chartcnt = 5;
        $(document).ready(function () {
            $('#searchBtn').click(function () {
                getData('Y');
            });

            $('#chartCntDiv .dropdown-menu li a').click(function () {
                chartcnt = $(this).text();
                printChart();
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

            //getData ('Y');
        });

        /**
         * Bar Chart
         */
        var chart = null;
        var xAxis;

        function printChart(dat) {
            var data = [];
            var categories = [];
            var cols = grid1.columns;
            if (dat == undefined) {
                for (var i = 0; i < grid1.data.length; i++) {
                    if ((i + 1) > cnt) break;
                    var tx = [];
                    var rx = [];
                    for (var j = 0; j < cols.length; j++) {
                        if (cols[j].id == 'deviceNm' || cols[j].id == 'NUM') continue;
                        var valArr = (grid1.data[i][cols[j].id]).split('/');
                        if (grid1.data[i][cols[j].id] == '') {
                            tx.push(0);
                            rx.push(0);
                        } else {
                            tx.push(Number(valArr[0]));
                            rx.push(Number(valArr[1]));
                        }
                        if (i == 0) categories.push(cols[j].name);
                    }
                    txNm = '<s:message code="stat.traffic.tx"/>(' + grid1.data[i]["deviceNm"] + ')';
                    rxNm = '<s:message code="stat.traffic.rx"/>(' + grid1.data[i]["deviceNm"] + ')';
                    data.push({name: txNm, data: tx, stack: 'traffic' + i}, {name: rxNm, data: rx, stack: 'traffic' + i});
                }
            } else {
                var tx = [];
                var rx = [];
                for (var j = 0; j < cols.length; j++) {
                    if (cols[j].id == 'deviceNm' || cols[j].id == 'NUM') continue;
                    var valArr = (dat[cols[j].id]).split('/');
                    if (dat[cols[j].id] == '') {
                        tx.push(0);
                        rx.push(0);
                    } else {
                        tx.push(Number(valArr[0]));
                        rx.push(Number(valArr[1]));
                    }
                    categories.push(cols[j].name);
                }
                txNm = '<s:message code="stat.traffic.tx"/>(' + dat["deviceNm"] + ')';
                rxNm = '<s:message code="stat.traffic.rx"/>(' + dat["deviceNm"] + ')';
                data.push({name: txNm, data: tx, stack: 'traffic'}, {name: rxNm, data: rx, stack: 'traffic'});
            }

            var rotation = 40;
            if (xAxis == 'W') rotation = 0;
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
                    labels: {
                        y: 35,
                        rotation: rotation
                    }
                },
                yAxis: {
                    allowDecimals: false,
                    min: 0,
                    title: {
                        text: ''
                    }
                },
                tooltip: {
                    headerFormat: '<b>{point.key}</b><br>',
                    pointFormat: '<span style="color:{series.color}">\u25CF</span> {series.name}: {point.y}(MB)'
                },
                plotOptions: {},
                series: data
            });
        }

	</script>
</head>
<body class="mini-navbar">
<div>
	<!-- 검색 -->
	<div class="searchArea w100">
		<div class="searchSub w100">

			<div id="startdatepicker"><input type="date" id="startdate" style="width: 110px;">
				<span class="hyphen">~</span></div>
			<div id="enddatepicker"><input type="date" id="enddate" style="width: 110px;"></div>


			<div>
				<select id="xAxis" name="xAxis">
					<option value="H"><s:message code="common.msg.time"/></option>
					<option value="M"><s:message code="common.msg.month"/></option>
					<option value="D"><s:message code="common.msg.day"/></option>
					<option value="W"><s:message code="common.msg.week"/></option>
				</select>
			</div>

			<div>
				<button class="form_btn01" id="searchBtn"><s:message code="common.msg.search"/></button>
			</div>
		</div>
	</div>
	<!-- //검색 -->
	<!-- 차트-->
	<div class="content xcn_full">
		<div class="contentSub">
			<h3><span id="chartAreaTitle">TOP <s:message code="DATA_MONITOR.STAT_LABEL"/> CHART </span></h3>
			<span class="sel">
						<div id="totalViewDiv"  class="totalView" style="display:none;">
							<div class="subtab">
							<button type="button" title="<s:message code="stat.view.all"/>"><s:message code="stat.view.all"/></button>
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
			<div class="inner_personaldata p20">
				<div id="chartArea1" style="height: 230px;"></div>
			</div>
			<div class="mat32">
				<div class="subtab">
					<button class="active mt32">
						<s:message code="deviceInfo.navi.title2"/> <s:message code="selectCodeAll.list"/>
						<span id="consentCount"></span>
					</button>
				</div>
				<span style="position:absolute; top: 355px;">
					[ <span style="color: red;">● <s:message code="stat.traffic.tx"/></span>&nbsp;/&nbsp;<span style="color: blue;">● <s:message
						code="stat.traffic.rx"/></span> ]&nbsp; : <s:message code="stat.traffic.unit"/>
				</span>
				<div id="basicStatListGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; height: 400px"></div>
			</div>
		</div>


	</div>
	<!-- //차트-->

</div>
<script type="text/javascript">
    var grid1 = new Xgrid('basicStatListGrid', contextRoot);
    grid1.autoNumber();
    grid1.colAdd("rowKey", '<s:message code="common.msg.device"/>', 230, "left", false, 'link');
    grid1.loadExportMenu('<s:message code="DATA_ANALYSIS.STAT_DEVTRAFFIC"/> [<s:message code="stat.traffic.tx"/> / <s:message code="stat.traffic.rx"/> ] : <s:message code="stat.traffic.unit"/>');
    grid1.loadHeader(false);
    grid1.initData('<s:message code="common.msg.search.click"/>');
    grid1.onClick = function () {
        if (grid1.Col == grid1.ColIndex('deviceNm')) {
            var dat = grid1.getRowData(grid1.Row);
            printChart(dat);
        }
    };

    function getData(flag) {
        if (searchFlag) return;

        var xAxis = $('select[name=xAxis]').val();
        var xAxis_str = $('select[name=xAxis] option:selected').text();
        var sDate = $('#startdate').val().replaceAll("-", "");
        var eDate = $('#enddate').val().replaceAll("-", "");
        if (sDate > eDate) ui.alertMsg('<s:message code="consent.msg.timecheck"/>');

        searchFlag = true;
        grid1.on();
        ui.get({
            url: 'getDeviceTrafficStat.xcn',
            startDt: sDate,
            endDt: eDate,
            xAxis: xAxis,
            xAxis_str: xAxis_str,
            success: function (data, total) {
                grid1.colInit();
                grid1.autoNumber();
                grid1.colAdd('deviceNm', '<s:message code="common.msg.device"/>', 230, 'left', false, 'link');
                for (var i = 0; i < data.header.length; i++) {
                    var header = data.header[i];
                    grid1.colAdd(header.key, header.text, 100, "center", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
                        if (value != undefined) {
                            if (value != '') {
                                var valArr = value.split('/');
                                var value = '<font style="color:red">' + valArr[0] + '</font> / <font style="color:blue">' + valArr[1] + '</font>';
                            }
                            return value;
                        } else return '';
                    });
                }
                grid1.loadHeader(false);
                grid1.setData(data.data);

                $('#statlist_cnt').html('<s:message code="common.msg.finish_query"/>: ' + grid1.data.length + '<span style="color: red;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #000;">[</span> ● <s:message code="stat.traffic.tx"/></span>&nbsp;/&nbsp;<span style="color: blue;">● <s:message code="stat.traffic.rx"/></span>&nbsp;<span style="color: #000;">] : <s:message code="stat.traffic.unit"/></span>');
                if (grid1.loadingPage == 0) grid1.Select(-1, -1);
                searchFlag = false;
                var data = data.data;
                if (data.length > 0) {
                    for (var i = 0; i < data.length; i++) {
                        var selected = false;
                        if (i <= 4) selected = true;
                        else if (i >= 10) break;
                        //addOption( 'chartListCount', (i+1), (i+1), selected );
                    }
                    grid1.Select(0, 0);
                    var dat = grid1.getRowData(grid1.Row);
                    printChart(dat);
                } else {
                    $('#chartArea1').html('<s:message code="common.msg.nodata"/>');
                    $('#space').height('7px');
                }
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