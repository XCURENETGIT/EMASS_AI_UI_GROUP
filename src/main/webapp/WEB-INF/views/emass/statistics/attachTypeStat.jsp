<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>
<style>

</style>
<script>
    Highcharts.setOptions({
        chart: {
            type: 'column',
            marginTop : 15,
            marginBottom : 60,
            spacingBottom: 0
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
        $('#dept').click(function () {
            var code = $(this).attr('id');
            openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
        });

        $('#user').click(function () {
            var code = $(this).attr('id');
            openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
        });


        $(document).on('click', '#userSelectedArea', function (e) {
            $('#userVal, #userVal').val('');
            $('#userSelectedArea').hide();
        });


        $(document).on('click', '#deptSelectedArea', function (e) {
            $('#deptVal, #deptStr').val('');
            $('#deptSelectedArea').hide();
        });

        getServiceList();
        $('.optionBtn').click(function () {
            $('.optionBtn').removeClass('active');
            $(this).addClass('active');
        });

        $('#searchBtn').click(function(){
            closeDetailTab();
            getData ('Y');
        });
        $('#clearBtn').click(function(){
            $('#startdate').val(new Date().format('yyyy-mm-dd'));
            $('#enddate').val(new Date().format('yyyy-mm-dd'));
            $('#deptVal, #deptStr').val('');
            $('#deptSelectedArea').hide();
            $('#userVal, #userVal').val('');
            $('#userSelectedArea').hide();


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


    function initCondition(){
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
	<div class="searchArea w100">
		<div class="searchSub w100">
			<div>
				<input type="date" id="startdate" style="width: 110px;"/>
				<span class="hyphen">~</span>
			</div>
			<div>
				<input type="date" id="enddate" style="width: 110px;"/>
			</div>

			<div class="optiotab">
				<button class="optionBtn active" id="svc1" value="svc1"><s:message code="common.msg.svc"/></button>
				<button class="optionBtn" id="direction_svc" value="direction_svc"><s:message code="condition.receive_send"/></button>
				<button class="optionBtn" id="ctime_hh" value="ctime_hh"><s:message code="common.msg.time"/></button>
				<button class="optionBtn" id="ctime_yyyymmdd" value="ctime_yyyymmdd" class="active"><s:message code="common.msg.day"/></button>
				<button class="optionBtn" id="ctime_yyyymm" value="ctime_yyyymm"><s:message code="common.msg.month"/></button>
				<button class="optionBtn" id="businm" value="businm"><s:message code="common.org.busi"/></button>
				<button class="optionBtn" id="conm" value="conm"><s:message code="common.org.co"/></button>
				<button class="optionBtn" id="deptnm" value="deptnm"><s:message code="common.org.dept"/></button>
				<button class="optionBtn" id="jikgubnm" value="jikgubnm"><s:message code="common.org.jikgub"/></button>
			</div>
			<div>
				<button class="form_btn01" id="searchBtn"><s:message code="common.msg.search"/></button>
				<button class="form_btn02" id="clearBtn"><s:message code="condition.reset"/></button>
			</div>
		</div>
		<div class="searchSub w100">
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


				<button class="btn01" id="user"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
						code="common.org.choose.user"/></button>
				<span id="userSelectedArea" class="codeSelectedBtn">
										<button type="button" class="btn num_add bornone"  style="z-index: 2;">0</button>
									</span>
				<input type="hidden" id="userStr" class="selectedTitle">
				<input type="hidden" id="userVal">


			</div>
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
					</h3>
					<div class="panel-default" id="service.logging.count">
						<div class="inner_personaldata" style="height:180px;">
							<div id="chartArea1" style="height: 100%"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="subtab">
				<div>
					<ul class="nav nav-tabs codeTab listChart">
						<li class="active"><a data-toggle="tab" href="#basicStatList" id="listTab" ><s:message code="stat.display.attachment.title"/></a></li>
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
</form>

<script type="text/javascript">
    function setSublist(data) {
        var element = document.getElementById('sub_1');
        if (element && data && data.length > 0 && data[0].rowKey) {
            var firstRowkey = data[0].rowKey;
            element.innerHTML = '<span>' + firstRowkey + '</span>';
        }
    }

    function getCurrentGrid(){
        var id = Number($('.listChart .active').attr('idx'));
        return tabInfo['tab'+id];
    }

    var grid1 = new Xgrid('basicStatListGrid', contextRoot);
    grid1.autoNumber();
    grid1.colAdd( "rowKey", '<s:message code="condition.attach"/>', 230, "left", false, 'link' );
    grid1.colAdd("total", '<s:message code="bodyview.total"/>', 130, "right", false, 'nomal' );
    grid1.loadExportMenu('<s:message code="DATA_MONITOR.STAT_ATTACHTYPE"/>');
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
            $('#detailTab'+delid+' .subtab_close').click();
        }

        var displayName = (rowKey.indexOf(',') > -1) ? '<s:message code="common.msg.all"/>' : rowKey.replaceAll("\\\"", "\"");
        if(rowName!='') displayName = rowName + '&lt;' + rowKey + '&gt;';
        var id = 'tab'+tabID;
        $('.listChart').append($('<li style="display:inline-flex;text-align: center;z-index:1001;" idx="'+tabID+'" id="liTab'+tabID+'"><a data-toggle="tab" href="#tab'+tabID+'" id="detailTab'+tabID+'" style="display: flex; align-items: center; justify-content: center;">'+displayName+' - '+colKeyNm+'<span class="badge mal4"></span><button type="button" class="subtab_close closeBtn">	&#10006;</button></a></li>'));
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
        gridObj.loadExportMenu('<s:message code="stat.detail.attach.list"/>');
        gridObj.loadPageSize();
        gridObj.changePageSize = function(cnt){
            getDetailData('Y');
        };
        getDetailData('Y');
    };

    function getData( flag ) {
        if ( searchFlag ) return;
        var sDate = $('#startdate').val().replaceAll("-", "");
        var eDate = $('#enddate').val().replaceAll("-", "");
        var xAxis = $('button.optionBtn.active').val();
        var xAxis_str = $('button.optionBtn.active').text();
        if (sDate > eDate) ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
        if(sDate === '' || eDate === '') {
            alert('<s:message code="holidayBusiness.msg.enter.date"/>');
            return;
        }
        var busiStr= arrayToString($('#busiSelect').selectpicker('val'));
        var dv = $('#deptVal').val().split('|');
        var dept = dv.join(',');


        var deptStr='';
        if (dept != '') deptStr = dept;
        else deptStr = '';


        var uv = $('#userVal').val().split('|');
        var user = uv.join(',');


        var userStr='';
        if (user != '') userStr = user;
        else userStr = '';

        searchFlag = true;
        grid1.on();
        ui.get({
            url : 'getStatList.xcn',
            startDate: sDate+"000000",
            endDate: eDate+"235959",
            xAxis : xAxis,
            yAxis : 'attachtype',
            deptStr:deptStr,
            busiStr:busiStr,
            userStr:userStr,
            offset : grid1.data.length,
            limit : grid1.pageSize,
            xAxis_str : xAxis_str,
            xAxis_str : xAxis_str,
            success : function(data, total) {
                grid1.colInit();
                grid1.autoNumber();
                grid1.colAdd('rowKey', '<s:message code="consent.user"/>', 230, 'left', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
                    if(grid1.getValue(row, 'rowName') != '') {
                        return grid1.getValue(row, 'rowName') + '&lt;' + value + '&gt;';
                    }
                    if(grid1.getValue(row, 'rowKey') == '') {
                        return '';
                    }else {
                        return value;
                    }
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
                    else if(xAxis === 'svc1') HeaderNm = serviceList.search(Header, 'groupCd', 'groupNm');
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

        var xAxis = $('button.optionBtn.active').val();
        var xAxis_str = $('button.optionBtn.active').text();
        var busi= arrayToString($('#busiSelect').selectpicker('val'));
        var dv = $('#deptVal').val().split('|');
        var dept = dv.join(',');
        var deptStr='';
        if (dept != '') deptStr = $('#deptStr').val();
        else deptStr = '';

        var uv = $('#userVal').val().split('|');
        var user = uv.join(',');


        var userStr='';
        if (user != '') userStr = $('#userStr').val();
        else userStr = '';

        searchFlag = true;
        currentgrid.on();

        ui.get({
            url : 'getStatDetailList.xcn',
            rowKey : rowKey,
            colKey : colKey,
            deptStr:dept,
            busiStr:busi,
            userStr:userStr,
            startDate :  $('#searched_startDate').val(),
            endDate : $('#searched_endDate').val(),
            xAxis : xAxis,
            xAxis_str : xAxis_str,
            yAxis : 'attachtype',
            nameStat : "attachStat",
            //attachType : selAttach,
            offset : currentgrid.data.length,
            limit : currentgrid.pageSize,
            success : function(data, total) {
                if ( lastRow == 'Y' || lastRow == undefined ) detailTotal = total;
                currentgrid.appendData(data.emass);
                if ( currentgrid.loadingPage == 0 ) currentgrid.Select(-1,-1);

                $('#detailTab'+tabID+' .badge').html('&nbsp;[' + total.comma() + ']');
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