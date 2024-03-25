<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>

<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>
<script>
    Highcharts.setOptions({
        chart: {
            type: 'column',
            marginTop : 30
        },
        global: {useUTC: false},
        gridLineColor: '#fff',
        colors: ['#80599F', '#656C7C', '#598AD3', '#D35976', '#DDDDDD', '#bb6ecb', '#439851', '#33a0c4', '#7558cb', '#97b420'],
        lang: {
            months: ['<s:message code="common.january"/>', '<s:message code="common.february"/>', '<s:message code="common.march"/>', '<s:message code="common.april"/>', '<s:message code="common.may"/>', '<s:message code="common.june"/>', '<s:message code="common.july"/>', '<s:message code="common.august"/>', '<s:message code="common.september"/>', '<s:message code="common.october"/>', '<s:message code="common.november"/>', '<s:message code="common.december"/>'],
            shortMonths: ['<s:message code="common.january"/>', '<s:message code="common.february"/>', '<s:message code="common.march"/>', '<s:message code="common.april"/>', '<s:message code="common.may"/>', '<s:message code="common.june"/>', '<s:message code="common.july"/>', '<s:message code="common.august"/>', '<s:message code="common.september"/>', '<s:message code="common.october"/>', '<s:message code="common.november"/>', '<s:message code="common.december"/>'],
            weekdays: ['<s:message code="common.sunday"/>', '<s:message code="common.monday"/>', '<s:message code="common.tuesday"/>', '<s:message code="common.wednesday"/>', '<s:message code="common.thursday"/>', '<s:message code="common.friday"/>', '<s:message code="common.saturday"/>'],
            contextButtonTitle: '<s:message code="common.msg.char_type"/>',
            thousandsSep: ','
        },
        xAxis: {
            dateTimeLabelFormats: {
                day: '<s:message code="dashboard.display.day" arguments="%b,%d" />'
            }
        },
        yAxis: {
            gridLineColor: '#333',
            gridLineWidth: 0.1
        }
    });

    var searchFlag = false;
    var detailTotal = 0;
    var rowKey = "";
    var colKey = "";
    var detailTab = "N";
    var chartcnt = 5;
    var currentGrid;
    var tabID = 1;
    var tabNum = 0;
    var totalChartDat;
    $(document).ready(function () {
        getAdminOptions();
        initDateTimePicker('startdate','enddate');

        $('.optionBtn').click(function () {
            $('.optionBtn').removeClass('active');
            $(this).addClass('active');
        });

        $('#searchBtn').click(function () {
            closeDetailTab();
            getData('Y');
        });

        $('#clearBtn').click(function(){
            $('#startdate').val(new Date().format('yyyy-mm-dd'));
            $('#enddate').val(new Date().format('yyyy-mm-dd'));
            $('#baseType').val('ctime');
            $('#adminId').val('');
            $('#xAxis').val('_yyyymmdd');


        });


        $('#chartCntDiv .dropdown-menu li a').click(function(){
            chartcnt = $(this).text();
            printChart(totalChartDat);
        });


		//
        // $('#startdatepicker').datetimepicker({
        //     format: 'YYYY-MM-DD',
        //     locale: 'ko',
        //     defaultDate: moment(new Date())
        // });
		//
        // $('#enddatepicker').datetimepicker({
        //     format: 'YYYY-MM-DD',
        //     locale: 'ko',
        //     defaultDate: moment(new Date())
        // });

        $("#adminId").html(getAdminOptions());

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



        $('.totalView').click(function ( ) {
            $("#chartCntDiv").show();
            $('#totalViewDiv').hide();
            printChart(totalChartDat);
        });

    });

    function getAdminOptions() {

        var result = '';

        if (firstAdminYn == 'Y') result += '<option value="">- <s:message code="auditLog.select.admin"/> -</option>';
        ui.get({
            url: 'getAdminList.xcn',
            adminId: adminId,
            firstAdminYn: firstAdminYn,
            adminType: adminType,
            asyncFlag: false,
            success: function (data, total) {
                for (var i = 0; i < data.length; i++) {
                    if (adminType == 'M' && (adminId != data[i].adminId)) continue;
                    result += '<option value="' + data[i].adminId + '">' + data[i].adminName + ' (' + data[i].adminId + ')</option>';
                }
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
            }
        });
        return result;
    }

    function setGrid() {
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

    function prevMsg() {
        var selectedTabIdx = $('.listChart').find('.active').index();
        var grid = window.__grids[selectedTabIdx];
        var row = 0;
        if (grid.Row > 0) {
            row = --grid.Row;
            viewer_open(row);
            grid.Select(row, 0);
            return true;
        }
        return false;
    }

    function nextMsg() {
        var selectedTabIdx = $('.listChart').find('.active').index();
        var grid = window.__grids[selectedTabIdx];
        var row = 0;
        if (grid.Row < grid.Rows - 1) {
            row = ++grid.Row;
            viewer_open(row);
            grid.Select(row, 0);
            if (grid.Row == grid.Rows - 2) {
                getList(true);
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

    function printChart(dat) {
        var data = [];
        var categories = [];
        var cols = grid1.columns;
        var maxDat = 0;
        if (dat == undefined) {
            for (var i = 0; i < grid1.data.length; i++) {
                if ((i + 1) > chartcnt) break;
                var items = [];
                for (var j = 1; j < cols.length; j++) {
                    if (cols[j].id == 'total' || cols[j].id == 'NUM' || cols[j].id == 'rowKey') continue;
                    if (grid1.data[i][cols[j].id] == undefined) items.push(0);
                    else items.push(Number(grid1.data[i][cols[j].id]));
                    if (i == 0) categories.push(cols[j].name);
                    if (Number(grid1.data[i][cols[j].id]) > maxDat) maxDat = Number(grid1.data[i][cols[j].id]);
                }
                if (grid1.data[i]['NUM'] == '<s:message code="bodyview.total"/>') continue;
                else data.push({name: grid1.data[i]['rowKey'], data: items});
            }
        } else {
            var items = [];
            for (var j = 0; j < cols.length; j++) {
                if (cols[j].id == 'total' || cols[j].id == 'NUM' || cols[j].id == 'rowKey') continue;
                if (dat[cols[j].id] == undefined || dat[cols[j].id] == '') {
                    items.push(0);
                } else {
                    items.push(Number(dat[cols[j].id]));
                }
                categories.push(cols[j].name);
                if (Number(dat[cols[j].id]) > maxDat) maxDat = Number(dat[cols[j].id]);
            }
            if (dat['NUM'] == '<s:message code="bodyview.total"/>') return;
            else data.push({name: dat['rowKey'], data: items});
        }

        var rotation = 40;
        if (chartxAxis == 'W') rotation = 0;
        $('#chartArea1').highcharts({
            title: {
                text: null
            },
            exporting: chartAPI.exporting,
            credits: chartAPI.credits,
            xAxis: {
                categories: categories,
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

<body class="mini-navbar">

<div>
	<!-- 검색영역 -->
	<div class="searchArea w100">
		<div class="searchSub w100">
			<div>
				<select id="baseType" name="baseType" class="input-sm form-control">
					<option value="ctime"><s:message code="analysis.freedom.ctime"/></option>
					<option value="date"><s:message code="analysis.freedom.readdate"/></option>
				</select>
			</div>
			<div id="startdatepicker"><input type="text" id="startdate" style="width: 110px;">
				<span class="hyphen">~</span></div>
			<div id="enddatepicker"><input type="text" id="enddate" style="width: 110px;"></div>

			<div>
				<select class="form-control input-sm" id="adminId" name="adminId" style="width: 205px;">
					<option value="">- <s:message code="auditLog.select.admin"/> -</option>
				</select>
			</div>
			<div>
				<select id="xAxis" name="xAxis" class="input-sm form-control" style="width:80px">
					<option value="_yyyymmdd"><s:message code="common.msg.day"/></option>
					<option value="_yyyymm"><s:message code="common.msg.month"/></option>
					<option value="_hh"><s:message code="common.msg.time"/></option>
				</select>
			</div>
			<div>
				<button class="form_btn01" id="searchBtn"><s:message code="common.msg.search"/></button>
				<button class="form_btn02" id="clearBtn"><s:message code="condition.reset"/></button>
			</div>
		</div>
	</div>
	<!-- //검색영역 -->
	<div class="content">
		<div class="contentSub">
			<div class="chartAreafull">
				<div>
					<h3>
						<span id="chartAreaTitle">TOP <s:message code="DATA_MONITOR.STAT_LABEL"/> CHART
						<span class="sel">
						<div id="totalViewDiv" style="display:none;">
							<div class="subtab">
							<button type="button" class="totalView" title="<s:message code="stat.view.all"/>"><s:message code="stat.view.all"/></button>
							</div>
						</div>
						<div class="panel-headings" id="chartCntDiv">
								<button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown">
									<s:message code="stat.display.count.chart"/> (<span class="dropdown-text">5</span>) <span val="5"
									                                                                                          class="caret"></span>
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
						<div class="inner_personaldata" style="height:230px;">
							<div id="chartArea1" style="height: 100%"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="subtab">
				<div>
					<ul class="nav nav-tabs codeTab listChart">
						<li class="active"><a data-toggle="tab" href="#basicStatList" id="listTab">LIST</a></li>
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
<!-- Back to top -->
<script type="text/javascript">

    function setSublist(data) {
        var element = document.getElementById('sub_1');
        if (element && data && data.length > 0 && data[0].rowKey) {
            var firstRowkey = data[0].rowKey;
            element.innerHTML = '<span>' + firstRowkey + '</span>';
        }
    }


    function getCurrentGrid() {
        var id = Number($('.listChart .active').attr('idx'));;
        return tabInfo['tab'+id];
    }

    var grid1 = new Xgrid('basicStatListGrid', contextRoot);
    grid1.autoNumber();
    grid1.colAdd("rowKey", '<s:message code="stat.ctime.yyyymmdd"/>', 180, "center", false, 'link');
    grid1.colAdd("edcTotal", '<s:message code="stat.ctime.total"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.colAdd("total", '<s:message code="stat.read.total"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.loadExportMenu('<s:message code="DATA_ANALYSIS.STAT_ADMINREAD"/>');
/*    grid1.loadPageSize();
    document.addEventListener("DOMContentLoaded", function() {
        var linkElements = document.querySelectorAll('a[data="5000"]');

        linkElements.forEach(function(linkElement) {
            linkElement.click();
        });
    });

    var elements = document.querySelectorAll('.status_rownum');

    elements.forEach(function(element) {
        element.style.display = 'none';
    });

    document.addEventListener("DOMContentLoaded", function() {
        var linkElements = document.querySelectorAll('a[data="5000"]');

        linkElements.forEach(function(linkElement) {
            linkElement.click();
        });
    });

    var elements = document.querySelectorAll('.status_rownum');

    elements.forEach(function(element) {
        element.style.display = 'none';
    });*/
    grid1.loadHeader(false);
    grid1.initData('<s:message code="common.msg.search.click"/>');
    grid1.changePageSize = function (cnt) {
        getData('Y');
    };

    var tabInfo = {};
    var chartDat = {};
    grid1.onClick = function () {
        if (grid1.Col == grid1.ColIndex('edcTotal')) return;

        var valChk = grid1.getValue(grid1.Row, grid1.Col);
        if(valChk == "" || valChk == "-") return;

        if(grid1.getValue(grid1.Row, 'NUM') == '<s:message code="bodyview.total"/>') {
            var key = "";
            if (grid1.ColKey(grid1.Col) == "total") {
                for (var i = 0; i < grid1.Rows; i++) {
                    if (grid1.getValue(i, 'rowKey') == "" || grid1.getValue(i, 'rowKey') == "-") continue;
                    else key += grid1.getValue(i, 'rowKey').replaceAll("\"", "\\\"") + ",";
                }
                rowKey = key;
            }else rowKey = grid1.ColKey(grid1.Col);
        }else {
            rowKey = grid1.getValue(grid1.Row, 'rowKey').replaceAll("\"", "\\\"");
        }
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
        tabNum++;
        if (tabNum > 3) {
            var delid = $(".listChart li:nth-child(2)").attr('idx');
            $('#detailTab' + delid + ' .subtab_close').click();
        }

        var rowKeys = rowKey.split(",");
        var displayName = rowKeys.length > 1 ? '<s:message code="common.msg.all"/>' : rowKey.replaceAll("\\\"", "\"");
        // if (rowName != '') displayName = rowName + '&lt;' + rowKey + '&gt;';
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
        var dat = grid1.getRowData(grid1.Row);
        chartDat[tabID] = dat;
        printChart(dat);
        gridObj.loadExportMenu('<s:message code="stat.detail.keyword.list"/>');
       /* gridObj.loadPageSize();
        document.addEventListener("DOMContentLoaded", function() {
            var linkElements = document.querySelectorAll('a[data="5000"]');

            linkElements.forEach(function(linkElement) {
                linkElement.click();
            });
        });

        var elements = document.querySelectorAll('.status_rownum');

        elements.forEach(function(element) {
            element.style.display = 'none';
        });
        gridObj.changePageSize = function (cnt) {
            getDetailData('Y');
        };*/
        getDetailData('Y');
    };

    function getData(flag) {
        if (searchFlag) return;
        var dateType = $('#baseType').val();
        var xAxis = $('select[name=xAxis]').val();
        var xAxis_str = $('select[name=xAxis] option:selected').text();
        var sDate = $('#startdate').val().replaceAll("-", "");
        var eDate = $('#enddate').val().replaceAll("-", "");
        var adminId = $('#adminId').val();

        if (sDate > eDate) ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
        getReadTimeData(sDate, eDate, xAxis, xAxis_str, dateType, adminId);
    }

    function getReadTimeData(sDate, eDate, xAxis, xAxis_str, dateType, adminId) {
        searchFlag = true;
        grid1.on();
        grid1.pageSize=5000
        var xAxis = $('select[name=xAxis]').val();
        ui.get({
            url: 'getCheckedStatList.xcn',
            startDate: sDate + "000000",
            endDate: eDate + "235959",
            detailQuery: '',
            xAxis: 'ctime' + xAxis,
            yAxis: 'ctime' + xAxis,
            dateType: dateType,
            adminId: adminId,
            offset: grid1.data.length,
            limit: grid1.pageSize,
            xAxis_str: xAxis_str,
            success: function (data, total) {
                grid1.colInit();
                grid1.autoNumber();
                var str = '';
                if (xAxis == '_yyyymmdd') str = '<s:message code="stat.ctime.yyyymmdd"/>';
                else if (xAxis == '_yyyymm') str = '<s:message code="stat.ctime.yyyymm"/>';
                else if (xAxis == '_hh') str = '<s:message code="stat.ctime.hh"/>';

                grid1.colAdd("rowKey", str, 180, "center", false, 'link')
                grid1.colAdd("edcTotal", '<s:message code="stat.ctime.total"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
                    if (value != undefined) return value.comma();
                    else return '';
                });
                grid1.colAdd('total', '<s:message code="stat.read.total"/>', 130, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
                    if (value != undefined) return value.comma();
                    else return '';
                });
                for (var i = 0; i < data.pivotHeader.length; i++) {
                    var Header = data.pivotHeader[i];
                    var HeaderNm = "";
                    if (xAxis == "_yyyymmdd") HeaderNm = Header.substr(0, 4) + "-" + Header.substr(4, 2) + "-" + Header.substr(6, 2);
                    else if (xAxis == "_yyyymm") HeaderNm = Header.substr(0, 4) + "-" + Header.substr(4, 2);
                    else if (xAxis == "_hh") HeaderNm = Header + '<s:message code="common.msg.hour"/>';
                    else HeaderNm = Header;
                    grid1.colAdd(Header, HeaderNm, 90, "right", false, 'link', function (row, cell, value, columnDef, dataContext) {
                        if (value != undefined) return value.comma();
                        else return '';
                    });
                }
                for (var i = 0; i < data.pivotData.length; i++) {
                    var rowKey = data.pivotData[i].rowKey;
                    var dataNm = "";

                    if (xAxis == "_yyyymmdd") dataNm = nvl(rowKey, " ").substr(0, 4) + "-" + nvl(rowKey, " ").substr(4, 2) + "-" + nvl(rowKey, " ").substr(6, 2);
                    else if (xAxis == "_yyyymm") dataNm = nvl(rowKey, " ").substr(0, 4) + "-" + nvl(rowKey, " ").substr(4, 2);
                    else if (xAxis == "_hh") dataNm = nvl(rowKey, " ") + '<s:message code="common.msg.hour"/>';
                    else dataNm = nvl(rowKey);
                    data.pivotData[i].rowKey = dataNm;
                }

                grid1.loadHeader(false);
                grid1.setData(data.pivotData);

                $('#statlist_cnt').html('<s:message code="common.msg.finish_query"/>:' + grid1.data.length);
                if (grid1.loadingPage == 0) grid1.Select(-1, -1);
                searchFlag = false;

                if (data.pivotData.length > 0) {
                    for (var i = 0; i < data.length; i++) {
                        var selected = false;
                        if (i <= 4) selected = true;
                        else if (i >= 10) break;
                        addOption('chartListCount', (i + 1), (i + 1), selected);
                    }

                    var dat = grid1.getRowData(grid1.Row);
                    totalChartDat = dat;
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
        currentgrid.pageSize=5000
        var xAxis = $('select[name=xAxis]').val();
        var xAxis_str = $('select[name=xAxis] option:selected').text();

        var baseType = $("#baseType").val();
        var solrQueryText = "";
        if (baseType == "ctime") {
            solrQueryText = $('#solrQueryText').val();
        }
        searchFlag = true;
        currentgrid.on();
        ui.get({
            url: 'getStatCheckedDetailList.xcn',
            rowKey: rowKey,
            colKey: colKey,
            startDate: $('#startdate').val().replaceAll("-", "") + "000000",
            endDate: $('#enddate').val().replaceAll("-", "") + "235959",
            detailQuery: solrQueryText,
            xAxis: 'ctime' + xAxis,
            xAxis_str: xAxis_str,
            yAxis: 'ctime' + xAxis,
            dateType: baseType,
            adminId: $('#adminId').val(),
            offset: currentgrid.data.length,
            limit: currentgrid.pageSize,
            success: function (data, total) {
                if ( lastRow == 'Y' || lastRow == undefined ) detailTotal = total;

                currentgrid.appendData(data.emass);
                currentgrid = getCurrentGrid();
                if ( currentgrid.loadingPage == 0 ) currentgrid.Select(-1,-1);

                $('#detailTab'+tabID+' .badge').html('&nbsp;[' + total.comma() + ']');
                $('#detail_cnt'+tabID).html('<s:message code="common.msg.finish_query"/>: '+currentgrid.data.length);

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
</script>
