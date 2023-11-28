<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <title>EMASS LT - <s:message code="DATA_MONITOR.STAT_LABEL"/></title>
  <link rel="stylesheet" href="<c:url value="/css/bootstrap-datetimepicker.min.css"/>"/>
  <link rel="stylesheet" href="<c:url value="/css/vis.min.css"/>"/>
  <link rel="stylesheet" href="<c:url value="/css/font-awesome.min.css"/>"/>
  <script type="text/javascript" src="<c:url value="/js/moment.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/collapse.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/ko.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker.min.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/vis.min.js"/>"></script>
  <%@ include file="../../analysis/analysisBase.jsp"%>
  <style type="text/css">
    .panel-heading .dropdown-menu {
      right: 31px;
      top: 42px;
      left: initial;
    }

    .panel-body {
      padding : 12px 8px 12px 8px !important;
    }


    #loadingBar {
      position: absolute;
      top: 39px;
      left: 11px;
      width: 1252px;
      height: 545px;
      background-color: rgba(210, 232, 255, 0.8);
      -webkit-transition: all 0.5s ease;
      -moz-transition: all 0.5s ease;
      -ms-transition: all 0.5s ease;
      -o-transition: all 0.5s ease;
      transition: all 0.5s ease;
      opacity: 1;
    }

    #text {
      position: absolute;
      top: 4px;
      left: 530px;
      width: 30px;
      height: 50px;
      margin: auto auto auto auto;
      font-size: 16px;
      color: #5a5a5a;
      font-weight: bold;
    }
    #text_loading {
      position: absolute;
      top: -45px;
      left: 8px;
      width: 500px;
      height: 50px;
      margin: auto auto auto auto;
      font-size: 24px;
      color: #5a5a5a;
      font-weight: bold;
    }


    div.outerBorder {
      position:relative;
      top:350px;
      width:600px;
      height:44px;
      margin:auto auto auto auto;
      border:8px solid rgba(0,0,0,0.1);
      background: rgb(252,252,252); /* Old browsers */
      background: -moz-linear-gradient(top,  rgba(252,252,252,1) 0%, rgba(237,237,237,1) 100%); /* FF3.6+ */
      background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(252,252,252,1)), color-stop(100%,rgba(237,237,237,1))); /* Chrome,Safari4+ */
      background: -webkit-linear-gradient(top,  rgba(252,252,252,1) 0%,rgba(237,237,237,1) 100%); /* Chrome10+,Safari5.1+ */
      background: -o-linear-gradient(top,  rgba(252,252,252,1) 0%,rgba(237,237,237,1) 100%); /* Opera 11.10+ */
      background: -ms-linear-gradient(top,  rgba(252,252,252,1) 0%,rgba(237,237,237,1) 100%); /* IE10+ */
      background: linear-gradient(to bottom,  rgba(252,252,252,1) 0%,rgba(237,237,237,1) 100%); /* W3C */
      filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fcfcfc', endColorstr='#ededed',GradientType=0 ); /* IE6-9 */
      border-radius:72px;
      box-shadow: 0px 0px 10px rgba(0,0,0,0.2);
    }

    #border {
      position: absolute;
      top: 3px;
      left: 10px;
      width: 500px;
      height: 22px;
      margin: auto auto auto auto;
      box-shadow: 0px 0px 4px rgba(0,0,0,0.2);
      border-radius: 10px;
    }

    #bar {
      position:absolute;
      top:1px;
      left:0px;
      width:20px;
      height:20px;
      margin:auto auto auto auto;
      border-radius:11px;
      border:2px solid rgba(30,30,30,0.05);
      background: rgb(0, 173, 246); /* Old browsers */
      box-shadow: 2px 0px 4px rgba(0,0,0,0.4);
    }

  </style>
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
        if(hrefNm=='#infoStatList') {
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


      getData ('Y');

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

    function prevMsg( ) {
      var row = 0;
      if( grid2.Row > 0 ) {
        row = --grid2.Row;
        //viewer_openPop(row);
        grid2.Select(row,0);
        return true;
      }
      return false;
    }

    function nextMsg( ) {
      var row = 0;
      if( grid2.Row < grid2.Rows - 1 ) {
        row = ++grid2.Row;
        viewer_openPop(row);
        grid2.Select(row,0);
        if( grid2.Row == grid2.Rows - 2  ){
//				getList( true );
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
          data.push({name:grid1.data[i]['rowKey'], data:items});
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
        data.push({name:dat['rowKey'], data:items});
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
    function initProgressbar(){
      $('#loadingBar').removeAttr("style");
      document.getElementById('bar').style.width = '0px';
      document.getElementById('text').innerHTML = '0%';
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
            <label for="startdatepicker"><s:message code="condition.select.period"/>:</label>
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
            <div class="form-group" style="margin: 0px 3px 0px 6px;">
              <label for="piCount"><s:message code="condition.infoStat.cnt"/>:</label>
              <select id="piCount" name="piCount" class="input-sm form-control">
                <option value="1" selected><s:message code="condition.infoStat.cnt1"/></option>
                <option value="2"><s:message code="condition.infoStat.cnt2"/></option>
                <option value="5"><s:message code="condition.infoStat.cnt5"/></option>
                <option value="10"><s:message code="condition.infoStat.cnt10"/></option>
                <option value="20"><s:message code="condition.infoStat.cnt20"/></option>
                <option value="50"><s:message code="condition.infoStat.cnt50"/></option>
                <option value="100"><s:message code="condition.infoStat.cnt100"/></option>
              </select>
            </div>
            <div class="form-group form-inline not-dashed">
              <button type="button" class="btn btn-success btn-sm" accesskey="Q" id="searchBtn" accesskey="s"><span class="glyphicon glyphicon-search"></span></button>
              <%-- <button type="button" class="btn btn-sm btn-primary searchQueryBtn"><span class="glyphicon glyphicon-check"></span>&nbsp;<s:message code="query.make.inputer"/></button> --%>
            </div>
          </div>
        </div>
      </div>
      <div class="row top_space">
        <div class="col-lg-4">
          <div class="panel panel-default">
            <div class="panel-heading piCountNum">
              <i class="fa fa-file-text-o fa-fw"></i> <span><s:message code="DATA_ANALYSIS.ANALYSIS_INFO"/></span>
            </div>
            <div class="panel-body" style="height: calc(100% - 270px); padding: 10px;">
              <div id="infoStatListGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; height: 500px"></div>
            </div>
            <%-- 통계영역 검색 조건 --%>
            <input id="searched_xAxis" type="hidden"/>
            <input id="searched_startDate" type="hidden"/>
            <input id="searched_endDate" type="hidden"/>
          </div>
        </div>
        <div class="col-lg-8">
          <div class="panel panel-default">
            <div class="panel-heading">
              <i class="fa fa-share-alt fa-fw"></i> <span><s:message code="analysis.infostat.chart"/></span>
              <div id="popover-content-chart" class="hide">
                <div style="padding-left:10px;">
                  <ul style="padding-left:15px;">
                    <li style="margin-bottom:7px;"><s:message code="analysis.relation.ui.msg1"/></li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="panel-body">
              <div id="mynetwork" style="border:1px solid lightgray;height: 516px;"></div>
              <div id="loadingBar" style="display: none;">
                <div class="outerBorder">
                  <div id="text">0%</div>
                  <div id="border">
                    <div id="bar"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="row" style="margin-bottom:5px;">
        <div class="col-lg-12">
          <div class="panel with-nav-tabs" style="height:100%;">
            <div class="panel-heading" style="padding:0;">
              <ul class="nav nav-tabs codeTab">
                <li class="active"><a data-target="#result" aria-controls="result" role="tab" data-toggle="tab"><s:message code="analysis.relation.ui.selectlist"/> <span class="resultCnt"></span></a></li>
              </ul>
            </div>
            <div class="panel-body" style="padding: 4px 0px 0px 0px;">
              <div class="tab-content" style="height:100%;" id="resultData">
                <div role="tabpanel" class="tab-pane fade active in" id="result">
                  <div id="selectList">
                    <div style="min-height:400px;height: 400px;">
                      <div id="selectGrid" class="slickGrid gridArea" style="height: 100%;"></div>
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

  function getCurrentGrid(){
    var id = Number($('.listChart .active').attr('idx'));
    return tabInfo['tab'+id];
  }

  var grid1 = new Xgrid('infoStatListGrid', contextRoot);
  grid1.autoNumber();
  grid1.colAdd('val', '<s:message code="consent.user"/>', 150, 'left', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
    if(grid1.getValue(row, 'rowName') != '')  return grid1.getValue(row, 'rowName') + '&lt;' + value + '&gt;';
    return value;
  });
  grid1.colAdd('total', '<s:message code="bodyview.total"/>', 40, 'right', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
    if ( value != undefined ) return value.comma();
    else return 0;
  });
  grid1.colAdd('pi_SN', '<s:message code="bodyview.sn"/>', 60, 'right', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
    if ( value != undefined ) return value.comma();
    else return 0;
  });
  grid1.colAdd('pi_CN', '<s:message code="bodyview.cn"/>',60, 'right', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
    if ( value != undefined ) return value.comma();
    else return 0;
  });
  grid1.colAdd('pi_DN', '<s:message code="bodyview.dn"/>', 80, 'right', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
    if ( value != undefined ) return value.comma();
    else return 0;
  });
  grid1.colAdd('pi_FN', '<s:message code="bodyview.fn"/>', 90, 'right', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
    if ( value != undefined ) return value.comma();
    else return 0;
  });
  grid1.colAdd('pi_PN', '<s:message code="bodyview.pn"/>', 60, 'right', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
    if ( value != undefined ) return value.comma();
    else return 0;
  });

  grid1.loadExportMenu('<s:message code="DATA_ANALYSIS.ANALYSIS_INFO"/>');
  grid1.loadPageSize();
  grid1.loadHeader(false);
  grid1.initData('<s:message code="common.msg.search.click"/>');
  grid1.changePageSize = function(cnt){
    getData ('Y');
  };
  grid1.onClick = function() {
    initProgressbar();
    if (grid1.Col == grid1.ColIndex('val')||grid1.Col == grid1.ColIndex('total')) {
      var data = grid1.getRowData(grid1.Row);
      makeNetwork(grid1.getValue(grid1.Row, 'rowName'),'',grid1.getValue(grid1.Row, 'total'));
    }if(grid1.Col == grid1.ColIndex('pi_SN')){
      makeNetwork(grid1.getValue(grid1.Row, 'val'),'SN',grid1.getValue(grid1.Row, 'pi_SN'));
    }if(grid1.Col == grid1.ColIndex('pi_CN')){
      makeNetwork(grid1.getValue(grid1.Row, 'val'),'CN',grid1.getValue(grid1.Row, 'pi_CN'));
    }if(grid1.Col == grid1.ColIndex('pi_DN')){
      makeNetwork(grid1.getValue(grid1.Row, 'val'),'DN',grid1.getValue(grid1.Row, 'pi_DN'));
    }if(grid1.Col == grid1.ColIndex('pi_FN')){
      makeNetwork(grid1.getValue(grid1.Row, 'val'),'FN',grid1.getValue(grid1.Row, 'pi_FN'));
    }if(grid1.Col == grid1.ColIndex('pi_PN')){
      makeNetwork(grid1.getValue(grid1.Row, 'val'),'PN',grid1.getValue(grid1.Row, 'pi_PN'));
    }
  };

  var grid2 = new Xgrid('selectGrid', contextRoot);
  grid2.autoNumber();
  grid2.colAdd('interestUserYn', '<s:message code="message.msg.interest"/>', 40, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
    if (value == 'Y') return '<div class="interestUserCheck"></div>';
    else if (value == 'N') return '';
  });
  grid2.colAdd('readYn', '<s:message code="condition.read"/>', 40, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
    if (value == 'Y') return '<div class="readY"></div>';
    else if (value == 'N') return '<div class="readN"></div>';
    else return '-';
  });
  grid2.colAdd('attachCnt', '<s:message code="message.msg.file"/>', 35, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
    if (value == '0') return '';
    else return value.comma();
  });
  grid2.colAdd('sender_inside', '<s:message code="message.msg.inout"/>', 55, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
    if (value == 'N') return '<s:message code="message.msg.out"/>';
    else if (value == 'Y') return '<s:message code="message.msg.in"/>';
    else return '-';
  });

  grid2.colAdd('directionSvc', '<s:message code="condition.receive_send"/>', 55, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
    if (value == 'I') return '<s:message code="condition.receive"/>';
    else if (value == 'O') return '<s:message code="condition.send"/>';
    else return '-';
  });

  grid2.colAdd('service_svc_Nm', '<s:message code="condition.service"/>', 180, 'center', false, 'nomal');
  grid2.colAdd('subject', '<s:message code="condition.subject"/>', 410, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
    var body_snippet = grid2.getValue(row, 'body_snippet').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
    if(body_snippet.length > 100) body_snippet = body_snippet.substring(0, 1024)+'...';

    if(value.length > 1024) value = value.substring(0, 1024)+'...';
    value = value.replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');

    //예약어 Highlight 처리
    var kwds = grid2.getValue(row, 'kwds');
    value = highlightKeyword(value, kwds);
    value = highlightSearchStr(value, "subject");

    var rtnVal = '<span title="'+body_snippet+'" onclick="" class="subject_read'+grid2.getValue(row, 'readYn')+'">'+value+'</span>&nbsp;<a href="javascript:void(0);" onclick="viewer_openPop('+row+')" class="glyphicon glyphicon-new-window new-window"></a>';
    if( (isConsent( ) && grid2.getValue(row, 'consentNo') == '') || !isDetailView() ) rtnVal = '<span>'+value+'</span>';

    return rtnVal;
  });
  grid2.colAdd('ctime', '<s:message code="condition.date"/>', 130, 'center', false, 'nomal');
  grid2.colAdd('user_name', '<s:message code="consent.user"/>', 120, 'center', false, 'link');
  grid2.colAdd('usrId', '<s:message code="common.msg.account"/>', 110, 'center', false, 'nomal');
  grid2.colAdd('sender_busiNm', '<s:message code="common.org.busi"/>', 120, 'center', true, 'nomal');
  grid2.colAdd('sender_deptNm', '<s:message code="common.org.dept"/>', 120, 'center', false, 'nomal');
  grid2.colAdd('sender_jikgubNm', '<s:message code="common.org.jikgub"/>', 120, 'center', false, 'nomal');
  grid2.colAdd('user_name', '<s:message code="condition.sender"/>', 130, 'left', false, 'link', function(row, cell, value, columnDef, dataContext) {
    return highlightSearchStr(value, "sender");
  });
  grid2.colAdd('allOfUs', '<s:message code="condition.allofus"/>', 150, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
    if( value == undefined || value.length == 0) return '';

    for( var i=0; i<value.length; i++){
      if(value[i] == 'IA') value[i] = '<s:message code="condition.allofus1"/>';
      else if(value[i] == 'ET') value[i] = '<s:message code="condition.allofus8"/>';
      else if(value[i] == 'IT') value[i] = '<s:message code="condition.allofus7"/>';
      else if(value[i] == 'EA') value[i] = '<s:message code="condition.allofus2"/>';
      else if(value[i] == 'PT') value[i] = '<s:message code="condition.allofus9"/>';
      else if(value[i] == 'PA') value[i] = '<s:message code="condition.allofus3"/>';
    }
   // return value.join(', ');
  });
  grid2.colAdd('recvs', '<s:message code="condition.recv"/>', 220, 'left', false, 'link', function(row, cell, value, columnDef, dataContext) {
    var innOutInfo = grid2.getValue(row, 'recvsInOutInfo');

    var rtnVal = arrayToString(value);
    return innOutInfo+highlightSearchStr(rtnVal, "recvs");
  });
  grid2.colAdd('to', '<s:message code="condition.to"/>', 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
    var innOutInfo = grid2.getValue(row, 'toInOutInfo');
    var rtnVal = arrayToString(value);
    return innOutInfo+highlightSearchStr(rtnVal, "to");
  });
  grid2.colAdd('cc', '<s:message code="condition.cc"/>', 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
    var innOutInfo = grid2.getValue(row, 'ccInOutInfo');

    var rtnVal = arrayToString(value);
    return innOutInfo+highlightSearchStr(rtnVal, "cc");
  });
  grid2.colAdd('bcc', '<s:message code="condition.bcc"/>', 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
    var innOutInfo = grid2.getValue(row, 'bccInOutInfo');
    var rtnVal = arrayToString(value);
    return innOutInfo+highlightSearchStr(rtnVal, "bcc");
  });
  grid2.colAdd('network_srcIp', '<s:message code="condition.source"/> IP', 100, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
    return highlightSearchStr(value, "network_srcIp");
  }, {sorter:sortUtil.ip});
  grid2.colAdd('network_dstIp', '<s:message code="condition.destination"/> IP', 100, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
    return highlightSearchStr(value, "network_dstIp");
  }, {sorter:sortUtil.ip});
  grid2.colAdd('attach_Name', '<s:message code="condition.attach_name"/>', 220, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
    var rtnVal = arrayToString(value);
    return highlightSearchStr(rtnVal, "attach_attach_Name");
  });
  grid2.colAdd('size', '<s:message code="condition.size.all"/>', 80, 'left', false, 'nomal', null, {sortField:'size'});
  grid2.colAdd('body_size', '<s:message code="condition.size.body"/>', 80, 'left', false, 'nomal', null, {sortField:'body_size'});
  grid2.colAdd('attach_sizeStr', '<s:message code="condition.size.attach"/>', 80, 'left', false, 'nomal', null, {sortField:'attachSizeSort'});
  grid2.colAdd('kwdInfo_kwds', '<s:message code="condition.keyword"/>', 120, 'left', false, 'nomal');
  grid2.colAdd('piTotal', '<s:message code="condition.regexp"/>', 70, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
    if (value == '0') return '';
    else return 0;
  });

  if ( isOCR ) {
    grid2.colAdd('ocr_attach_cnt', 'OCR <s:message code="message.msg.file"/>', 70, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
      if (value == '0' || value == '' || value == null || value == undefined ) return '';
      else return value.comma();
    });
  }
  grid2.loadExportMenu('<s:message code="DATA_ANALYSIS.ANALYSIS_INFO"/>');
  grid2.loadPageSize();
  grid2.loadHeader(false);
  grid2.initData('<s:message code="common.msg.search.click"/>');

  grid2.onClick = function() {
    if (grid.Col == grid.ColIndex('attachcnt')) {
      fileInfoViewer( grid.Row );
    }else if (grid.Col == grid.ColIndex('user')) {
      userInfoViewer( grid.Row, 'user' );
    }else if (grid.Col == grid.ColIndex('sender')) {
      userInfoViewer( grid.Row, 'sender' );
    }else if (grid.Col == grid.ColIndex('recvs')) {
      if(grid.getValue(grid.Row, 'recvs') != '') 	userInfoViewer( grid.Row, 'recvs');
    }else if (grid.Col == grid.ColIndex('to')) {
      if(grid.getValue(grid.Row, 'to') != '') userInfoViewer( grid.Row, 'to');
    }else if (grid.Col == grid.ColIndex('cc')) {
      if(grid.getValue(grid.Row, 'cc') != '') userInfoViewer( grid.Row, 'cc');
    }else if (grid.Col == grid.ColIndex('bcc')) {
      if(grid.getValue(grid.Row, 'bcc') != '') userInfoViewer( grid.Row, 'bcc');
    }else if(grid.Col == grid.ColIndex('total')) {
      regexpInfoViewer(grid.Row);
    }else if(grid.Col == grid.ColIndex('referer_url')) {
      var referer_url = grid.getValue(grid.Row, 'referer_url');
      if(referer_url !='N') fnOpenWindow(referer_url, '', 1024, 800, 'resize');
    }else if (grid.Col == grid.ColIndex('ocr_attach_cnt')) {
      ocrFileInfoViewer( grid.Row );
    }

    if( !(adminMenu != "ALL" && adminMenu.indexOf("DV") < 0) ) {
      if(!parent.$('#none_btn').hasClass('areaSelected')) viewer_open(grid.Row);
      if(popWin) viewer_openFocus(grid.Row);
    } else {
      alert('<s:message code="message.auth.no.detailview"/>');
      return;
    }
  };
  grid2.changePageSize = function(cnt){
    //parent.getList();
  };
  grid2.onDblClick = function(){
    viewer_openPop(grid2.Row);
  }

  var popWin;
  function viewer_openPop( row ){
    var _id = grid2.getValue(row, '_id');

    popWin = openMessageBodyPop( grid2.id, _id);
    var readYn = grid2.getValue(row, 'readYn');
    grid2.setValue(row, grid2.ColIndex('readYn'), 'Y');
  }

  function getData( flag ) {
    if ( searchFlag ) return;
    var sDate = $('#startdate').val().replaceAll("-","");
    var eDate = $('#enddate').val().replaceAll("-","");
    if(sDate > eDate) ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
    var piCount_str = $('select[name=piCount] option:selected').text();
    var piCount = $('select[name=piCount]').val();


    $('#listTab b').remove();
    searchFlag = true;
    grid1.on();

    var searchData = {
      piCount_str :$('select[name=piCount] option:selected').text()
      , startDate : sDate+"000000"
      , endDate : eDate+"235959"
      , offset : grid1.data.length
      , limit : grid1.pageSize
      , pMenuId : pMenuId
      , piCount : $('select[name=piCount]').val()
      , menuId: menuId
    }

    ui.get({
      url : 'getInfoStatList.xcn',
      searchParam : JSON.stringify(searchData),
      success : function(data, total) {
        console.log(data);
        if(data.search_xAxis != null) $('#searched_xAxis').val(data.search_xAxis);
        if(data.search_startDate != null) $('#searched_startDate').val(data.search_startDate);
        if(data.search_endDate != null) $('#searched_endDate').val(data.search_endDate);
        grid1.setData(data.pivotData);
        $('#statlist_cnt').html('<s:message code="common.msg.finish_query"/>:'+grid1.data.length);
        if ( grid1.loadingPage == 0 ) grid1.Select(-1,-1);
        $('#listTab').append("<b> ["+piCount_str+"] 기준</b>");
        $("#listTab").data( "value",piCount);
        $('.piCountNum').attr('piCountNum',piCount);
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

  function getNodeByField(field, data) {
    var result = [];
    for(var i=0 ; i < data.length ; i++) {

      var val = data[i][field];
      result.push(val);
    }
    return result.unique();
  }
  function getNodeByFieldNoneUnique(field, data) {
    var result = [];
    for(var i=0 ; i < data.length ; i++) {
      var val = data[i][field];
      result.push(val);
    }
    return result;
  }

  var piArr= ['pi_FN', 'pi_SN', 'pi_DN', 'pi_CN', 'pi_PN'];
  var piNmArr= ['<s:message code="bodyview.fn"/>', '<s:message code="bodyview.sn"/>', '<s:message code="bodyview.dn"/>', '<s:message code="bodyview.cn"/>', '<s:message code="bodyview.pn"/>'];
  var piGroupArr= ['pattern_FN', 'pattern_SN', 'pattern_DN', 'pattern_CN', 'pattern_PN'];
  function getNodeByPI(data) {
    var result = [];
    for(var i=0 ; i < data.length ; i++) {
      for(var x=0 ; x < piArr.length ; x++) {
        var val = data[i][piArr[x]];
        if(val > 0) result.push(piArr[x]);
      }
    }
    return result.unique();
  }

  function getPatternInfo(pId){
    var result = {};
    var idx = piArr.indexOf(pId);
    result.pi_Nm = piNmArr[idx];
    result.pattern_group = piGroupArr[idx];
    return result;
  }
  function getTimeFormat(time){
    var result = time.substring(8,14);
    result = result.substring(0, 2) + ":" + result.substring(2, 4) + ":" + result.substring(4, 6);
    return result;
  }
  function getDateFormat(date){
    var result = date;
    var result = result.substring(0, 4) + "-" + result.substring(4, 6) + "-" + result.substring(6, 8);
    return result;
  }
  function makeNetwork(value,type,total){
    var user_str = value;
    var type = type;
    var total = total;
    var piCount = $('.piCountNum').attr('piCountNum');

    let data = {
      startDate : $('#startdate').val().replaceAll("-","")+"000000",
      endDate : $('#enddate').val().replaceAll("-","")+"235959",
      piCount : piCount,
      offset : 0,
      limit : -1,
      user_str : user_str,
      type : type,
    }
    ui.postJson({
      url : 'test_getInfoNetwork.xcn',
      searchParam : JSON.stringify(data),
      success : function(data, total) {

        grid2.setData(data.emass);
   /*     for(var i=0; i<data.emass.length; i++) {
          alert(data.emass[j]._id);
          alert(data.emass[j].user_name);
        }
*/
        var nodes= [];
        var edges = [];
        if(total==0){
          nodes.push({ id: 'noneData', font: { multi: 'html'}, title: '<s:message code="analysis.infostat.notleak"/>', label: '<s:message code="analysis.infostat.notleak"/>',group:'noneData'});
        }

        //원래 ctime 20231116155436/20231115155221/2023-11-15 09:48:05 citmeYYYYmmDD 20231116/20231115


        var nodeLv1 = getNodeByField('user_id', data.emass);
        var nodeLv2 = getNodeByPI(data.emass);
        /* 					var nodeLv3 = getNodeByField('svc', data); */
        var nodeLv3 = getNodeByField('ctimeYYYYMMDD', data.emass);
        var nodeLv4 = getNodeByField('ctime', data.emass);
        var nodeLv5 = getNodeByField('msgid', data.emass);
        var nodeLv6 = getNodeByFieldNoneUnique('subject', data.emass);


        var nodeUnion = nodeLv1.concat(nodeLv2).concat(nodeLv3).concat(nodeLv4).concat(nodeLv5);
        var height = 35;
        var width = 140;
        var idx=0;
        for(var i=0 ; i < nodeLv1.length ; i++) {
          nodes.push({ id: nodeLv1[i], font: { multi: 'html'}, title: nodeLv1[i], label: nodeLv1[i],group:'user'});
        }
        for(var i=0 ; i < nodeLv2.length ; i++) {
          var pi= getPatternInfo(nodeLv2[i]);
          nodes.push({ id: nodeLv2[i], font: { multi: 'html'}, title: pi.pi_Nm, label: pi.pi_Nm,group:pi.pattern_group});
        }
        for(var i=0 ; i < nodeLv3.length ; i++) {
          nodes.push({ id: nodeLv3[i], font: { multi: 'html'}, title: getDateFormat(nodeLv3[i]), label: getDateFormat(nodeLv3[i]),group:'date'});
        }
        for(var i=0 ; i < nodeLv4.length ; i++) {
          nodes.push({ id: nodeLv4[i], font: { multi: 'html'}, title: getTimeFormat(nodeLv4[i]), label: getTimeFormat(nodeLv4[i]),group:'time'});
        }
        for(var i=0 ; i < nodeLv5.length ; i++) {
          nodes.push({ id: nodeLv5[i], font: { multi: 'html'}, title: nodeLv6[i],group:'msg'});
        }


        for(var i=0 ; i < nodeLv1.length ; i++) {
          for(var j=0 ; j < nodeLv2.length ; j++) {
            var sum = 0;
            for(var x=0 ; x < data.emass.length; x++) {
              if(nodeLv1[i] == data.emass[x].user_id && data.emass[x][nodeLv2[j]] > 0)
                sum += data.emass[x][nodeLv2[j]];
            }
            if(sum > 0) edges.push({from: nodeLv1[i], to: nodeLv2[j],value:(sum)/(total*4) ,arrows:'to',color:{color:'#3FB168'}, font: { multi: true }, label: sum});
          }
        }

        for(var i=0 ; i < nodeLv2.length ; i++) {
          for(var j=0 ; j < nodeLv3.length ; j++) {

            var sum = 0;
            for(var x=0 ; x < data.emass.length ; x++) {
              if(data.emass[x][nodeLv2[i]] > 0 && data.emass[x].ctimeYYYYMMDD == nodeLv3[j])
                sum += data.emass[x][nodeLv2[i]];
            }
            if(sum > 0) edges.push({from: nodeLv2[i], to: nodeLv3[j],arrows:'to',value:(sum)/(total*4), color:{color:'#2A6727'},font: { multi: true}, label: sum});
          }
        }

        for(var i=0 ; i < nodeLv3.length ; i++) {
          for(var j=0 ; j < nodeLv4.length ; j++) {
            var sum = 0;
            for(var x=0 ; x < data.emass.length ; x++) {
              if(data.emass[x].ctimeYYYYMMDD == nodeLv3[i] && data.emass[x].ctime == nodeLv4[j]) {
                for(var z=0 ; z < piArr.length ; z++) {
                  sum += data.emass[x][piArr[z]];
                }
              }
            }
            if(sum > 0) edges.push({from: nodeLv3[i], to: nodeLv4[j],arrows:'to',value:(sum)/(total*4), font: { multi: true },color:{color:'#808000'}, label: sum});
          }
        }

        for(var i=0 ; i < nodeLv4.length ; i++) {
          for(var j=0 ; j < nodeLv5.length ; j++) {
            var sum = 0;
            for(var x=0 ; x < data.emass.length ; x++) {
              if(data.emass[x].ctime == nodeLv4[i] && data.emass[x].msgid == nodeLv5[j]) {
                for(var z=0 ; z < piArr.length ; z++) {
                  sum += data.emass[x][piArr[z]];
                }
              }
            }
            if(sum > 0) edges.push({from: nodeLv4[i], to: nodeLv5[j],arrows:'to',value:(sum)/(total*4), font: { multi: true },color:{color:'#FFC000'}, label: sum});
          }
        }
        var container = document.getElementById('mynetwork');
        var data_ = {
          nodes: nodes,
          edges: edges
        };


        var options = {
          groups: {
            noneData: {
              shape: 'icon',
              icon: {
                face: 'FontAwesome',
                code: '\uf06a',
                size: 50,
                color: '#337ab7'
              },
            },
            user: {
              shape: 'icon',
              icon: {
                face: 'FontAwesome',
                code: '\uf007',
                size: 50,
                color: '#337ab7'
              },
            },
            pattern_CN: {
              shape: 'icon',
              icon: {
                face: 'FontAwesome',
                code: '\uf09d',
                size: 50,
                color: '#717171'
              },
            },
            pattern_SN: {
              shape: 'icon',
              icon: {
                face: 'FontAwesome',
                code: '\uf2bb',
                size: 50,
                color: '#D8A90A'
              },
            },
            pattern_PN: {
              shape: 'icon',
              icon: {
                face: 'FontAwesome',
                code: '\uf298',
                size: 50,
                color: '#F4A75D'
              },
            },
            pattern_DN: {
              shape: 'icon',
              icon: {
                face: 'FontAwesome',
                code: '\uf5de',
                size: 50,
                color: '#B2B2B2'
              },
            },
            pattern_FN: {
              shape: 'icon',
              icon: {
                face: 'FontAwesome',
                code: '\uf2c2',
                size: 50,
                color: '#414141'
              },
            },
            msg: {
              shape: 'icon',
              icon: {
                face: 'FontAwesome',
                code: '\uf199',
                size: 50,
                color: '#A9D539'
              },
              nodeDistance: 10,
              hierarchicalRepulsion: {
                nodeDistance: 10,
              }
            }

          },
          edges: {
            color:'#FF0000',
            font: {
              size: 13,
              bold: {
                color: '#808080'
              }
            },
            arrowStrikethrough: true,
          },
          nodes: {
            shape: 'box',
            font: {
              bold: {
                color: '#808080'
              }
            }
          },
          manipulation: false,
          layout: {
            hierarchical: {
              enabled: true,
              levelSeparation:300,
              direction: 'LR',
              sortMethod: 'directed'
            }
          },
          physics: {
            stabilization: {
              enabled:true,
              iterations:1000,
              updateInterval:10
            },
            hierarchicalRepulsion: {
              nodeDistance: 100
            },
            /* "barnesHut": {
				"gravitationalConstant": 2,
				"centralGravity": 0,
				"springLength": 0,
				"springConstant": 0,
			}, */
            barnesHut: {
              gravitationalConstant: -26,
              centralGravity: 0.005,
              springLength: 230,
              springConstant: 0.18
            },
          }
        };
        var network = new vis.Network(container, data_, options);
        network.on("getConnectedNodes", function(params) {
          // console.log("getConnectedNodes"+JSON.stringify(params))
        });
        network.on("click",function(params){
          /* 	console.log(network.getConnectedNodes('pi_SN'));
		  console.log(network.getConnectedNodes('pi_SN', 'from'));
		  console.log(network.getConnectedNodes('pi_SN', 'to'));
		  var clickArr = network.getConnectedNodes('pi_SN');
		  console.log(network.clustering.findNode('118.220.10.87')); */
          console.log(params.nodes[0]);
        });
        //현재 선택된 노드의 아이디를 가지고 옴
        var mySelectionOrder = [];
        var previouslySelected = {};
        network.on('select', function(params) {
          var selected = {};
          params.nodes.forEach(function(n) {
            if ( ! previouslySelected[n]) {
              mySelectionOrder.push(n);
            }
            selected[n] = true;
          });
          mySelectionOrder = mySelectionOrder.filter(
                  function(e, i, a) { return selected[e]; });
          previouslySelected = selected;
        });
        network.on("stabilizationProgress", function(params) {
          var maxWidth = 496;
          var minWidth = 20;
          var widthFactor = params.iterations/params.total;
          var width = Math.max(minWidth,maxWidth * widthFactor);
          document.getElementById('bar').style.width = width + 'px';
          document.getElementById('text').innerHTML = Math.round(widthFactor*100) + '%';
        });
        network.once("stabilizationIterationsDone", function() {
          document.getElementById('text').innerHTML = '100%';
          document.getElementById('bar').style.width = '496px';
          document.getElementById('loadingBar').style.opacity = 0;
          // really clean the dom element
          setTimeout(function () {document.getElementById('loadingBar').style.display = 'none';}, 500);
        });
      },
      error : function(status, message) {
        alert(message);
      },
      complete : function() {
      }
    });


  }
</script>
</body>
</html>