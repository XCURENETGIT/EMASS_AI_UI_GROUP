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
	<script>
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
        $(document).ready(function(){
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
                    gridDetail.print('<s:message code="stat.detail.open.list"/>', pMenuId, menuId);
                } else {
                    if (grid1.Rows == 0) {
                        alert('<s:message code="common.msg.nodata"/>');
                        return;
                    }
                    grid1.print('<s:message code="DATA_MONITOR.STAT_ADMINREAD"/>', pMenuId, menuId);
                }
            });

            $('.excel_stat').click(function() {
                var gridDetail = getCurrentGrid();
                if(gridDetail != undefined) {
                    excelDownLoad(gridDetail,'<s:message code="stat.detail.open.list"/>');
                } else {
                    chart = $('#chartArea1').highcharts();
                    var svg = chart.getSVG();
                    excelDownLoad(grid1,'<s:message code="DATA_MONITOR.STAT_ADMINREAD"/>', svg);
                }
            });

            $('.cell_stat').click(function() {
                var gridDetail = getCurrentGrid();
                if(gridDetail != undefined) {
                    cellDownLoad(gridDetail,'<s:message code="stat.detail.open.list"/>');
                } else {
                    cellDownLoad(grid1,'<s:message code="DATA_MONITOR.STAT_ADMINREAD"/>');
                }
            });

            $('.pdf_stat').click(function() {
                var gridDetail = getCurrentGrid();
                if(gridDetail != undefined) {
                    pdfDownLoad(gridDetail,'<s:message code="stat.detail.open.list"/>');
                } else {
                    pdfDownLoad(grid1,'<s:message code="DATA_MONITOR.STAT_ADMINREAD"/>');
                }
            });

            $('.csv_stat').click(function() {
                var gridDetail = getCurrentGrid();
                if(gridDetail != undefined) {
                    csvDownLoad(gridDetail,'<s:message code="stat.detail.open.list"/>');
                } else {
                    csvDownLoad(grid1,'<s:message code="DATA_MONITOR.STAT_ADMINREAD"/>');
                }
            });

            $('.totalView').click(function(){
                $("#chartCntDiv").show();
                $('#totalViewDiv').hide();
                printChart(totalChartDat);
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

        function viewer_open( row, bodySize ){
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
            var url    = '<c:url value="/commons/queryMake.do?statType=adminRead"/>';
            fnOpenWindow(url, 'queryMakePop', 1400, 870, 'resize');
        }

        function getAdminOptions(){

            var result = '';

            if( firstAdminYn == 'Y' ) result += '<option value="">- <s:message code="auditLog.select.admin"/> -</option>';
            ui.get({
                url : 'getAdminList.xcn',
                adminId		: adminId,
                firstAdminYn: firstAdminYn,
                adminType	: adminType,
                asyncFlag : false,
                success : function(data, total) {
                    for(var i=0 ; i < data.length; i++){
                        if( adminType == 'M' && ( adminId != data[i].adminId ) ) continue;
                        result+='<option value="' + data[i].adminId + '">' +  data[i].adminName + ' ('+data[i].adminId+')</option>';
                    }
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
            return result;
        }
	</script>
</head>
<body class="mini-navbar">
<div class="container">
	<div class="boxArea">
		<div class="content_body">
			<div class="row">
				<div class="col-xs-12 text-left">
					<div class="form-group form-inline not-dashed">
						<div class="form-group" style="margin-left: 15px;">
							<label for="baseType"><s:message code="deviceInfo.reftime"/>:</label>
							<select id="baseType" name="baseType" class="input-sm form-control">
								<option value="ctime"><s:message code="analysis.freedom.ctime"/></option>
								<option value="date"><s:message code="analysis.freedom.readdate"/></option>
							</select>
						</div>
						<div class='input-group date' id='startdatepicker'>
							<input type='text' class="input-sm form-control" id='startdate' />
							<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
								</span>
						</div>
						~
						<div class='input-group date' id='enddatepicker'>
							<input type='text' class="input-sm form-control" id='enddate' />
							<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
								</span>
						</div>
						<div class="form-group" style="margin-left: 15px;">
							<label for="adminId"><s:message code="stat.select.admin"/>:</label>
							<select class="form-control input-sm" id="adminId" name="adminId" style="width: 205px;">
								<option value="">- <s:message code="auditLog.select.admin"/> -</option>
							</select>
						</div>
						<div class="form-group" style="margin-left: 15px;">
							<label for="xAxis"><s:message code="stat.area.stat"/>:</label>
							<select id="xAxis" name="xAxis" class="input-sm form-control" style="width:80px">
								<option value="_yyyymmdd"><s:message code="common.msg.day"/></option>
								<option value="_yyyymm"><s:message code="common.msg.month"/></option>
								<option value="_hh"><s:message code="common.msg.time"/></option>
							</select>
						</div>
						<div class="form-group form-inline not-dashed">
							<button type="button" class="btn btn-success btn-sm" accesskey="Q" id="searchBtn" accesskey="s"><span class="glyphicon glyphicon-search"></span></button>
						</div>
					</div>
				</div>
			</div>
			<div class="row top_space" style="border-bottom: 1px dashed #a4c7e4;">
			</div>
			<div class="row top_space2">
				<div class="col-xs-12">
					<ul class="nav nav-tabs codeTab listChart">
						<li class="active" style="width:100px; text-align: center"><a data-toggle="tab" href="#basicStatList" id="listTab" >LIST</a></li>
					</ul>
				</div>
			</div>
			<div class="row top_space">
				<div class="col-lg-12 tab-content">
					<div id="basicStatList" class="tab-pane fade in active">
						<div id="basicStatListGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; height: 400px"></div>
					</div>
				</div>
			</div>
			<div class="row top_space2">
				<div class="col-lg-12">
					<div class="panel panel-default" id="service.logging.count">
						<div class="panel-heading">
							<div class="pull-right" id="totalViewDiv" style="display:none;">
								<button class="totalView btn-info btn-xs" type="button" title="<s:message code="stat.view.all"/>"><s:message code="stat.view.all"/></button>
							</div>
							<div class="pull-right" id="chartCntDiv">
								<button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown">
									<span class="glyphicon glyphicon-download-alt"></span>&nbsp;<s:message code="stat.display.count.chart"/> (<span class="dropdown-text">5</span>) <span val="5" class="caret"></span>
								</button>
								<ul class="dropdown-menu dropdown-menu-right" role="menu">
									<li><a href="#">5</a></li>
									<li><a href="#">10</a></li>
									<li><a href="#">15</a></li>
									<li><a href="#">20</a></li>
								</ul>
							</div>
							<i class="fa fa-bar-chart-o fa-fw"></i><span id="chartAreaTitle">TOP <s:message code="DATA_MONITOR.STAT_LABEL"/> CHART </span>
						</div>
						<div class="panel-body">
							<div id="chartArea1" style="height: 230px;"></div>
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
    function getCurrentGrid(){
        var id = Number($('.listChart .active').attr('idx'));
        return tabInfo['tab'+id];
    }
    var grid1 = new Xgrid('basicStatListGrid', contextRoot);
    grid1.autoNumber();
    grid1.colAdd( "rowKey", '<s:message code="stat.ctime.yyyymmdd"/>', 180, "center", false, 'link' );
    grid1.colAdd( "edcTotal", '<s:message code="stat.ctime.total"/>', 130, "right", false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
        if ( value != undefined ) return value.comma();
        else return '';
    });
    grid1.colAdd("total", '<s:message code="stat.read.total"/>', 130, "right", false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
        if ( value != undefined ) return value.comma();
        else return '';
    });
    grid1.loadExportMenu('<s:message code="DATA_ANALYSIS.STAT_ADMINREAD"/>');
    grid1.loadPageSize();
    grid1.loadHeader(false);
    grid1.initData('<s:message code="common.msg.search.click"/>');
    grid1.changePageSize = function(cnt){
        getData ('Y');
    };

    var tabInfo={};
    var chartDat={};
    grid1.onClick = function() {
        if (grid1.Col == grid1.ColIndex('edcTotal')) return;

        var valChk = grid1.getValue(grid1.Row, grid1.Col);
        if(valChk == "" || valChk == "-") return;

        if(grid1.getValue(grid1.Row, 'NUM') == '<s:message code="bodyview.total"/>') {
            var key = "";
            for(var i=0; i<grid1.Rows; i++) {
                if(grid1.getValue(i, 'rowKey') == "" || grid1.getValue(i, 'rowKey') == "-") continue;
                else key += grid1.getValue(i, 'rowKey').replaceAll("\"", "\\\"") + ",";
            }
            rowKey = key;
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
        tabNum ++;
        if( tabNum > 3 ) {
            var delid = $( ".listChart li:nth-child(2)" ).attr('idx');
            $('#detailTab'+delid+' .close').click();
        }

        var rowKeys = rowKey.split(",");
        var displayName = rowKeys.length > 1 ? '<s:message code="common.msg.all"/>' : rowKey.replaceAll("\\\"", "\"");
        var id = 'tab'+tabID;
        $('.listChart').append($('<li style="display:inline-flex;text-align: center;z-index:1001;" idx="'+tabID+'" id="liTab'+tabID+'"><a data-toggle="tab" href="#tab'+tabID+'" id="detailTab'+tabID+'" >'+displayName+' - '+colKeyNm+'<span class="badge"></span><button class="close" type="button" title="<s:message code="stat.delete.tab"/>">×</button></a></li>'));
        $('#basicStatList').after($('<div class="tab-pane fade" id="tab' + tabID + '"><div id="detail_cnt'+tabID+'" style="margin-top:0px; color: #f25643; font-weight: bold; font-size: 13px;"></div><div id="grid'+tabID+'" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; height: 380px"></div></div>'));

        var gid = 'grid'+tabID;
        var gridObj = new Xgrid(gid, contextRoot);
        tabInfo[id] = gridObj;
        $('.nav-tabs a[href="#tab'+tabID+'"]').tab('show');
        setGrid( );

        $("#chartCntDiv").hide();
        $('#totalViewDiv').show();
        var dat = grid1.getRowData( grid1.Row );
        chartDat[tabID] = dat;
        printChart(dat);
        gridObj.loadExportMenu('<s:message code="stat.detail.open.list"/>');
        gridObj.loadPageSize();
        gridObj.changePageSize = function(cnt){
            getDetailData('Y');
        };
        getDetailData('Y');
    };

    function getData( flag ) {
        if ( searchFlag ) return;
        var dateType = $('#baseType').val();
        var xAxis = $('select[name=xAxis]').val();
        var xAxis_str = $('select[name=xAxis] option:selected').text();
        var sDate = $('#startdate').val().replaceAll("-","");
        var eDate = $('#enddate').val().replaceAll("-","");
        var adminId = $('#adminId').val();

        if(sDate > eDate) ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
        getReadTimeData(sDate, eDate, xAxis, xAxis_str, dateType, adminId);
    }

    function getReadTimeData(sDate, eDate, xAxis, xAxis_str, dateType, adminId) {
        searchFlag = true;
        grid1.on();
        ui.get({
            url : 'getCheckedStatList.xcn',
            startDate: sDate+"000000",
            endDate: eDate+"235959",
            detailQuery:$('#solrQueryText').val(),
            xAxis : 'date' + xAxis,
            yAxis : 'ctime' + xAxis,
            dateType : dateType,
            adminId : adminId,
            offset : grid1.data.length,
            limit : grid1.pageSize,
            xAxis_str : xAxis_str,
            success : function(data, total) {
                grid1.colInit();
                grid1.autoNumber();

                var str = '';
                if( xAxis == '_yyyymmdd') str = '<s:message code="stat.ctime.yyyymmdd"/>';
                else if( xAxis == '_yyyymm') str = '<s:message code="stat.ctime.yyyymm"/>';
                else if( xAxis == '_hh') str = '<s:message code="stat.ctime.hh"/>';

                grid1.colAdd( "rowKey", str, 180, "center", false, 'link' );
                grid1.colAdd( "edcTotal", '<s:message code="stat.ctime.total"/>', 130, "right", false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
                    if ( value != undefined ) return value.comma();
                    else return '';
                });
                grid1.colAdd('total', '<s:message code="stat.read.total"/>', 130, 'right', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
                    if ( value != undefined ) return value.comma();
                    else return '';
                });
                for ( var i=0 ; i < data.pivotHeader.length ; i++ ) {
                    var Header = data.pivotHeader[i];
                    var HeaderNm = "";
                    if ( xAxis == "_yyyymmdd") HeaderNm = Header.substr(0,4)+"-"+Header.substr(4,2)+"-"+Header.substr(6,2);
                    else if ( xAxis == "_yyyymm") HeaderNm = Header.substr(0,4)+"-"+Header.substr(4,2);
                    else if ( xAxis == "_hh") HeaderNm = Header+'<s:message code="common.msg.hour"/>';
                    else HeaderNm = Header;
                    grid1.colAdd( Header, HeaderNm, 90, "right", false, 'link', function ( row, cell, value, columnDef, dataContext ) {
                        if ( value != undefined ) return value.comma();
                        else return '';
                    });
                }
                for ( var i=0 ; i < data.pivotData.length ; i++ ) {
                    var rowKey = data.pivotData[i].rowKey;
                    var dataNm = "";
                    if ( xAxis == "_yyyymmdd") dataNm = nvl(rowKey, " ").substr(0,4)+"-"+nvl(rowKey, " ").substr(4,2)+"-"+nvl(rowKey, " ").substr(6,2);
                    else if ( xAxis == "_yyyymm") dataNm = nvl(rowKey, " ").substr(0,4)+"-"+nvl(rowKey, " ").substr(4,2);
                    else if ( xAxis == "_hh") dataNm = nvl(rowKey, " ") + '<s:message code="common.msg.hour"/>';
                    else dataNm = nvl(rowKey);
                    data.pivotData[i].rowKey = dataNm;
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

        var xAxis = $('select[name=xAxis]').val();
        var xAxis_str = $('select[name=xAxis] option:selected').text();

        var baseType = $("#baseType").val();
        var solrQueryText = "";
        if(baseType == "ctime") {
            solrQueryText = $('#solrQueryText').val();
        }
        searchFlag = true;
        currentgrid.on();
        ui.get({
            url : 'getStatCheckedDetailList.xcn',
            rowKey : rowKey,
            colKey : colKey,
            startDate : $('#startdate').val().replaceAll("-","")+"000000",
            endDate : $('#enddate').val().replaceAll("-","")+"235959",
            detailQuery:solrQueryText,
            xAxis : xAxis,
            xAxis_str : xAxis_str,
            yAxis : 'read_id',
            baseType : baseType,
            adminId : $('#adminId').val(),
            offset : currentgrid.data.length,
            limit : currentgrid.pageSize,
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
        });
    }
</script>
</body>
</html>