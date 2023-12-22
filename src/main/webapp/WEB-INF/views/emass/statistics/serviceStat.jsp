<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<link rel="stylesheet" type="text/css" href="../css/emass_style.css"/>
	<title>EMASS LTH - <s:message code="DATA_MONITOR.STAT_LABEL"/></title>
	<style type="text/css">
		.panel-headings .dropdown-menu {
			right: 8px;
			top: 25px;
			left: initial;
		}

	</style>
	<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>
	<%-- 통계 --%>
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
        var totalChartDatDetail;
        var dataGrid = "";
        var totalChartDat1;
        var parentGrid;
        var totalViewSig=false;
        var tabFlag=false;
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
                var fgrid = getCurrentGrid();
                if(fgrid == undefined || fgrid == null || totalViewSig) {
                    printChart(totalChartDat , grid1);
                } else {
                    printChart(totalChartDat , fgrid);
                }
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
                currentgrid = getCurrentGrid();
                var id = $(this).parents('li').attr('idx');
                var hrefNm = $(this).attr('href');
                var obj = tabInfo[id];
                var liTab = $(this).parents('li').attr('id');

                if(hrefNm=='#basicStatList') {
                    $("#chartCntDiv").show();
                    $('#totalViewDiv').hide();
                    printChart(totalChartDat , grid1);

                }else if(liTab.includes("D")){
                    $("#chartCntDiv").show();
                    $('#totalViewDiv').hide();
                    parentGrid = currentgrid;
                    printChart( totalChartDat , currentgrid);

                }else {
                    $("#chartCntDiv").hide();
                    $('#totalViewDiv').show();
                    var dat = chartDat[id];
                    printChart( dat , parentGrid);
                }
            })

            $('.listChart').on('click','.closeBtn',function(){
                currentgrid = getCurrentGrid();
                var id = 'tab'+ Number($(this).parents('li').attr('idx'));
                var obj = tabInfo[id];
                obj.close();

                var tabID = $(this).parents('a').attr('href');
                $(this).parents('li').remove();
                $(tabID).remove();
                tabNum --;

                if(tabFlag == false){
                    var tabFirst = $('.listChart a:first');
                    tabFirst.tab('show');

                    $("#chartCntDiv").show();
                    $('#totalViewDiv').hide();
                }else if (tabFlag == true){
                    tabFlag = false;
                }
            });

            $('.print_stat').click(function() {
                var gridDetail = getCurrentGrid();
                if(gridDetail != undefined) {
                    if (gridDetail.Rows == 0) {
                        alert('<s:message code="common.msg.nodata"/>');
                        return;
                    }
                    gridDetail.print('<s:message code="stat.detail.service.list"/>', pMenuId, menuId);
                } else {
                    if (grid1.Rows == 0) {
                        alert('<s:message code="common.msg.nodata"/>');
                        return;
                    }
                    grid1.print('<s:message code="DATA_MONITOR.STAT_SVC"/>', pMenuId, menuId);
                }
            });

            $('.excel_stat').click(function() {
                var gridDetail = getCurrentGrid();
                if(gridDetail != undefined) {
                    excelDownLoad(gridDetail,'<s:message code="stat.detail.service.list"/>');
                } else {
                    chart = $('#chartArea1').highcharts();
                    var svg = chart.getSVG();
                    excelDownLoad(grid1,'<s:message code="DATA_MONITOR.STAT_SVC"/>', svg);
                }
            });

            $('.cell_stat').click(function() {
                var gridDetail = getCurrentGrid();
                if(gridDetail != undefined) {
                    cellDownLoad(gridDetail,'<s:message code="stat.detail.service.list"/>');
                } else {
                    cellDownLoad(grid1,'<s:message code="DATA_MONITOR.STAT_SVC"/>');
                }
            });

            $('.pdf_stat').click(function() {
                var gridDetail = getCurrentGrid();
                if(gridDetail != undefined) {
                    pdfDownLoad(gridDetail,'<s:message code="stat.detail.service.list"/>');
                } else {
                    pdfDownLoad(grid1,'<s:message code="DATA_MONITOR.STAT_SVC"/>');
                }
            });

            $('.csv_stat').click(function() {
                var gridDetail = getCurrentGrid();
                if(gridDetail != undefined) {
                    csvDownLoad(gridDetail,'<s:message code="stat.detail.service.list"/>');
                } else {
                    csvDownLoad(grid1,'<s:message code="DATA_MONITOR.STAT_SVC"/>');
                }
            });

            $('.totalView').click(function(){
                $("#chartCntDiv").show();
                $('#totalViewDiv').hide();
                totalViewSig = true;
                printChart(totalChartDat , grid1);
            });
            /*
			$('.selBtn').click(function(){
				var id = $(this).attr('id');
				var coCd = $('#coHidden').val();
				var oldCode = $('#'+id+'Hidden').val();
				var oldConm = $('#'+id+'Text').val();
				$('#oldCode').val(oldCode);
				$('#oldConm').val(oldConm);
				openWindow(id);
			});
			 */

            $('.searchQueryBtn').click(function(){
                queryMakePop();
            });
//	getData ('Y');

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
        function printChart( dat , dataGrid )
        {
            var grid1 =dataGrid;
            var data = [];
            var categories = [];
            var cols = grid1.columns;
            var maxDat = 0;

            if( dat == undefined ) {
                for ( var i=0 ; i < grid1.data.length ; i++ ) {
                    if ( (i+1) > chartcnt ) break;
                    var items = [];
                    for ( var j=1 ; j < cols.length ; j++ ) {
                        if ( cols[j].id == 'total' || cols[j].id == 'NUM' || cols[j].id == 'rowKey' || cols[j].id == 'svcNm' || cols[j].id == 'svcLv1Nm' || cols[j].id == 'svcLv2Nm' || cols[j].id == 'svcLv12Nm' ) continue;
                        if ( grid1.data[i][cols[j].id] == undefined ) items.push(0);
                        else items.push( Number( grid1.data[i][cols[j].id] ) );
                        if ( i == 0 ) categories.push( cols[j].name );
                        if(Number( grid1.data[i][cols[j].id] ) > maxDat) maxDat = Number( grid1.data[i][cols[j].id] );
                    }
                    if(grid1.data[i]['NUM'] == '<s:message code="bodyview.total"/>') continue;
                    else if(grid1.data[i].rowKey.length == 3) {
                        data.push({name:grid1.data[i]['svcLv12Nm'], data:items});
                    }else {
                        data.push({name:grid1.data[i]['svcNm'], data:items});
                    }

                }
            } else {
                var items = [];
                for ( var j=0 ; j < cols.length ; j++ ) {
                    if ( cols[j].id == 'total' || cols[j].id == 'NUM' || cols[j].id == 'rowKey' || cols[j].id == 'svcNm' || cols[j].id == 'svcLv1Nm' || cols[j].id == 'svcLv2Nm' || cols[j].id == 'svcLv12Nm' ) continue;
                    if ( dat[cols[j].id] == undefined || dat[cols[j].id] == '' ) {
                        items.push(0);
                    } else {
                        items.push( Number( dat[cols[j].id] ) );
                    }
                    categories.push( cols[j].name );
                    if(Number( dat[cols[j].id] ) > maxDat) maxDat = Number( dat[cols[j].id] );
                }
                if(dat['NUM'] == '<s:message code="bodyview.total"/>') return;
                else data.push({name:dat['svcLv12Nm'], data:items});
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
                        ExcelDown.location.href = '<c:url value="/utils/xlsxDown.do"/>?path=' + encodeURI(data);
                    } catch (e) {
                        ExcelDown.src = '<c:url value="/utils/xlsxDown.do"/>?path=' + encodeURI(data);
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
        /*
		function openWindow(id){
			var url = '<c:url value="/commons/selectCodeAll.do?codeType='+id+'"/>';
	var pop = fnOpenWindow('', 'selectCodeWinPopup', 860, 500, 'resize');
	$('#userPopForm').attr('target','selectCodeWinPopup');
	$('#userPopForm').attr('action', url);
	$('#userPopForm').attr('method','post');
	$('#userPopForm').submit();
}

function getSelectedCodeText(data){
	var result = '';
	for(var i=0, cnt=data.length ; i < cnt ; i++){
		result += data[i].codeName + ', ';
	}
	if(result!='') result = result.substring(0, result.length-2);
	return result;
}

function getSelectedCodeHidden(data){
	var result = '';
	for(var i=0, cnt=data.length ; i < cnt ; i++){
		result += data[i].code + '|';
	}
	if(result!='') result = result.substring(0, result.length-1);
	return result;
}

function getSelectedCodeData( codeType, data ) {
	$('#'+codeType+'Text').val(getSelectedCodeText(data));
	$('#'+codeType+'Text').attr('title', $('#'+codeType+'Text').val());
	$('#'+codeType+'Hidden').val(getSelectedCodeHidden(data));
}
 */
        function queryMakePop(  ){
            var url    = '<c:url value="/commons/queryMake.do?statType=service"/>';
            fnOpenWindow(url, 'queryMakePop', 1400, 870, 'resize');
        }

        function getSearchQuery() {

        }

        var pColKey = "";
        var pDisplayName = "";
        function clickEvent(dataGrid) {
            if(dataGrid.getData().length == 0) return;
            var grid1 = dataGrid;
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
                rowKey = grid1.getValue(grid1.Row, 'rowKey');
            }
            colKey = grid1.ColKey(grid1.Col);
            var svcNm = grid1.getValue(grid1.Row, 'svcLv12Nm');
            var colKeyNm = colKey;
            if (colKey == 'rowKey' || colKey == 'total' || colKey == 'NUM' || colKey == 'svcNm' || colKey == 'svcLv1Nm' || colKey == 'svcLv2Nm' || colKey == 'svcLv12Nm') {
                if(pColKey != "") {
                    colKey = "";
                }
                colKeyNm = '<s:message code="bodyview.total"/>';

                if(rowKey.length == 3){
                    pColKey = "";
                }
                colKeyNm = '<s:message code="bodyview.total"/>';
            } else if (colKey == "I") {
                pColKey = colKey;
                colKeyNm = '<s:message code="condition.receive"/>';
            } else if (colKey == "O") {
                pColKey = colKey;
                colKeyNm = '<s:message code="condition.send"/>';
            } else {
                pColKey = colKey;
                var xAxis = $('select[name=xAxis]').val();
                if (xAxis == "ctime_hh") colKeyNm = colKey + '<s:message code="common.msg.hour"/>';
            }

            tabID++;
            tabNum ++;
            if( tabNum > 8 ) {
                tabFlag = true;
                var delid = $( ".listChart li:nth-child(2)" ).attr('idx');
                $('#detailTab'+delid+' .close').click();
            }

            var rowKeys = rowKey.split(",");
            svcNm = rowKeys.length > 1 ? '<s:message code="common.msg.all"/>' : grid1.getValue(grid1.Row, 'svcLv12Nm');
            var id = 'tab'+tabID;
            var liTab = " "
            if(rowKey.length == 3){
                colKeyNm = '<s:message code="analysis.usagecompare.ui.detaillist"/>';
                pDisplayName = svcNm;
                liTab ="liTabD"
            }else if( rowKey.length == 4 ){
                svcNm = grid1.getValue(grid1.Row, 'svcNm');
                liTab ="liTabT"
            }else {
                liTab ="liTabT"
                if(pDisplayName != "") {
                    svcNm = pDisplayName + ' <s:message code="userInfo.all"/>';
                } else {
                    svcNm = '<s:message code="userInfo.all"/>';
                }
                pDisplayName = "";
            }
            $('.listChart').append($('<li style="display:inline-flex;text-align: center;z-index:1001;" idx="'+tabID+'" id="liTab'+tabID+'"><a data-toggle="tab" href="#tab'+tabID+'" id="detailTab'+tabID+'" >'+displayName+' - '+colKeyNm+'<span class="badge"></span><button type="button" class="closeBtn" style="float:right"><img src="<c:url value="/img/ico_closed.png"/>" alt="닫기"></button></a></li>'));
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
            gridObj.loadExportMenu('<s:message code="stat.detail.service.list"/> ( ' + svcNm + ' )');
            gridObj.loadPageSize();
            gridObj.changePageSize = function(cnt){
                if(liTab.includes("D")){
                    rowKey = rowKey.substr(0,3);
                    getServiceData('Y');
                    gridObj.onClick = function(){
                        clickEvent(gridObj);
                    };
                }else {
                    rowKey = dat.rowKey;
                    printChart(dat , dataGrid);
                    getDetailData('Y');
                }
            };
            if(rowKey.length == 3){
                getServiceData('Y');
                gridObj.onClick = function(){
                    clickEvent(gridObj);
                };
            }else {
                printChart(dat , dataGrid);
                getDetailData('Y');
            }
        }
	</script>
</head>
<body class="mini-navbar">

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
				<button type="button" class="form_btn05 searchQueryBtn"><s:message code="query.make.inputer"/></button>
			</div>
		</div>
		<div class="panel" style="width: 100%; margin-bottom: 10px">
			<div>
				<textarea class="c" rows="1" style="width:100%;" id="elsQueryText" placeholder="<s:message code="condition.input.detail"/>"></textarea>
			</div>
		</div>
		<div class="content">

			<div class="contentSub">
				<div class="chartAreafull">
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
								</ul>
						</div>
						</span>
						</h3>
						<div class="panel panel-default" id="service.logging.count">
							<div class="panel-body">
								<div id="chartArea1" style="height: 300px;"></div>
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
				<%--				<!-- pagination -->
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
								<!-- //pagination -->--%>
			</div>

		</div>
		<!-- content 끝-->
	</div>
	<!--ContentArea-->
</div>
<!--//Container-->
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
    grid1.colAdd('rowKey', '서비스타입', 100, 'left', true, 'nomal');
    grid1.colAdd('svcLv1Nm', '<s:message code="stat.service.type"/>', 230, 'left', false, 'nomal');
    grid1.colAdd('svcLv2Nm', '<s:message code="condition.service"/>', 230, 'left', false, 'link');
    //grid1.colAdd('svcNm', '상세 서비스명', 230, 'left', false, 'link');
    grid1.colAdd("total", '<s:message code="bodyview.total"/>', 130, "right", false, 'nomal' );
    grid1.loadExportMenu('<s:message code="DATA_ANALYSIS.STAT_SVC"/>');
    grid1.loadPageSize();
    grid1.loadHeader(false);
    grid1.initData('<s:message code="common.msg.search.click"/>');
    grid1.changePageSize = function(cnt){
        getData ('Y');
    };

    var tabInfo={};
    var chartDat={};

    grid1.onClick = function(){
        if(grid1.getValue(grid1.Row, 'NUM') == '<s:message code="bodyview.total"/>') {
            var key = "";
            for(var i=0; i<grid1.Rows; i++) {
                if(grid1.getValue(i, 'rowKey') == "" || grid1.getValue(i, 'rowKey') == "-") continue;
                else key += grid1.getValue(i, 'rowKey').replaceAll("\"", "\\\"") + ",";
            }
            colRowKey = key;
        }else {
            colRowKey = grid1.getValue(grid1.Row, 'rowKey');
        }
        pColKey="";
        clickEvent(grid1);
    };

    function getData( flag ) {
        if ( searchFlag ) return;
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
            yAxis : 'svc12',
            offset : grid1.data.length,
            limit : grid1.pageSize,
            xAxis_str : xAxis_str,
            rowKey : rowKey,
            success : function(data, total) {
                console.log(data);
                /* 통계영역 검색 조건 저장 */
                if (data.search_xAxis != null) $('#searched_xAxis').val(data.search_xAxis);
                if (data.search_startDate != null) $('#searched_startDate').val(data.search_startDate);
                if (data.search_endDate != null) $('#searched_endDate').val(data.search_endDate);

                grid1.colInit();
                grid1.autoNumber();

                grid1.colAdd('svcLv12Nm', '<s:message code="condition.service"/>', 320, 'left', false, 'link');

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
                pivotData(data , grid1 ,"Grid");
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

        var colNum = grid1.Col;
        var isTotalRow = (grid1.Rows == grid1.Row) ? true : false;
        var colId = '';
        if (colNum != '' & colNum != null) colId = grid1.getHeaderId()[grid1.Col].id;


        searchFlag = true;
        currentgrid.on();
        ui.get({
            url : 'getStatDetailList.xcn',
            rowKey : rowKey,
            colKey : pColKey,
            startDate : startDate+"000000",
            endDate : endDate+"235959",
            detailQuery:$('#solrQueryText').val(),
            xAxis : xAxis,
            xAxis_str : xAxis_str,
            yAxis : 'svc12',
            colRowKey : colRowKey,
            offset : currentgrid.data.length,
            limit : currentgrid.pageSize,

            success : function(data, total) {
                if ( lastRow == 'Y' || lastRow == undefined ) detailTotal = total;
                currentgrid.appendData(data.emass);
                if ( currentgrid.loadingPage == 0 ) currentgrid.Select(-1,-1);

                $('#detailTab'+Number($('.listChart .active').attr('idx'))+' .badge').text('[' + total.comma() + ']');
                $('#detail_cnt'+Number($('.listChart .active').attr('idx'))).html('<s:message code="common.msg.finish_query"/>: '+currentgrid.data.length);

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

    function pivotData (data , dataGrid ,value){
        totalChartDat = "";
        var grid1 = dataGrid;
        if( data.pivotData.length > 0 ) {
            for ( var i=0 ; i < data.length ; i++ ) {
                var selected = false;
                if ( i <= 4 ) selected = true;
                else if ( i >= 10 ) break;
                addOption( 'chartListCount', (i+1), (i+1), selected );
            }
            var dat = grid1.getRowData( grid1.Row );
            totalChartDat = dat;
            printChart( dat , grid1);
        } else {
            $('#chartArea1').html('<s:message code="common.msg.nodata"/>');
            $('#space').height('7px');
        }
    }
</script>
</body>
</html>