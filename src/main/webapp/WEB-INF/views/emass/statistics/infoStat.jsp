<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>

<link rel="stylesheet" href="<c:url value="/css/vis.min.css"/>"/>
<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/vis.min.js"/>"></script>
<%@ include file="../../analysis/analysisBase.jsp" %>
<style>
    #loadingBar {
        position: absolute;
        top: 5px;
        left: 11px;
        right: 11px;
        height: 545px;
        transition: all 0.5s ease;
        opacity: 1;
    }
    #text {
        position: absolute;
        top: 4px;
        left: 530px;
        width: 30px;
        height: 50px;
        font-size: 16px;
        color: #5a5a5a;
        font-weight: bold;
        z-index: 9999;
    }
    #text_loading {
        position: absolute;
        top: -45px;
        left: 8px;
        height: 50px;
        font-size: 24px;
        color: #5a5a5a;
        font-weight: bold;
    }

    div.outerBorder {
        position:relative;
        top: 0;
        left : 0;
        right : 0;
        height:44px;
    }

    #border {
        position: absolute;
        top: 3px;
        left: 10px;
        right: 10px;
        height: 22px;
    }

    #bar {
        position:absolute;
        top:1px;
        left:0;
        right: 0;
        width:20px;
        height:20px;
        border-radius:11px;
        border:2px solid rgba(30,30,30,0.05);
        background: rgb(0, 173, 246); /* Old browsers */
        box-shadow: 2px 0px 4px rgba(0,0,0,0.4);
    }
    .interestUserCheck{
        background-image: url('<c:url value="/img/icon/star.png"/>');
        background-position: center;
        background-repeat:no-repeat;
        width:100%;
        height:100%;
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

    var patternCountStr =  '<s:message code="bodyview.pattern_count"/>';
    var docCountStr = '<s:message code="bodyview.doc_count"/>';
    
    $(document).ready(function () {
        initCondition();
        initDateTimePicker('startdate','enddate');
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
            $('#deptSelectedArea').hide();
        });

        $(document).on('click', '#userSelectedArea', function (e) {
            $('#userVal, #userStr, #userDept, #userJib').val('');
            $('#userSelectedArea').hide();
        });


        $('#searchBtn').click(function () {
            $(".resultCnt").html('');

            if($('#piType').val() == 'pattern') {
                $('#privateChartTab').trigger('click');
                $('#privateDetailTab').trigger('click');
            }else {
                $('#privateDetailTab').trigger('click');
                $('#privateChartTab').trigger('click');
            }
            
			
            
            if ($('#piCount').val() === '' || $('#piCount').val() === null || $('#piCount').val() === undefined) {
                ui.alertMsg('<s:message code="piCount.msg.nonSelect"/>');
                return;
            }

            getData('Y');
            // if (codeType != null) {
            //     if (codeType == 'deptByCo') $('#deptByCoStrSpan').html('');
            //     $('#' + codeType + 'Val').val('');
            //     $('#' + codeType + 'Str').val('');
            //     $('#' + codeType + 'SelectedArea').hide();
            // }
        });

        $('#clearBtn').click(function () {
            $('#startdate').val(new Date().format('yyyy-mm-dd'));
            $('#enddate').val(new Date().format('yyyy-mm-dd'));
            $('#deptVal, #deptStr').val('');
            $('#deptSelectedArea').hide();
            $('#userVal, #userStr, #userDept, #userJib').val('');
            $('#userSelectedArea').hide();
            $('#busiSelect').selectpicker('val', '');
            $('#piCount').val('');
            $("[name=piType]").val('sum');
        });

        $('#chartCntDiv .dropdown-menu li a').click(function () {
            chartcnt = $(this).text();
            printChart(totalChartDat);
        });

        $('#startdate').val(new Date().format('yyyy-mm-dd'));
        $('#enddate').val(new Date().format('yyyy-mm-dd'));

        $(".nav-tabs").on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
        })

        $('#privateDetailTab').attr('href',"#");
        $("[name=oneVal]").css('display','none');
        
        $('#piType').change(function () {
            if($('#piType').val() == 'sum') {
                $('#piCount').val('');
                $('#privateDetailTab').attr('href',"#");
                $('#privateChartTab').attr('href',"#privateChart");
                $("[name=oneVal]").css('display','none');
            } else {
                $('#piCount').val('');
                $("[name=oneVal]").css('display','');
                $('#privateDetailTab').attr('href',"#privateDetail");
                $('#privateChartTab').attr('href',"#");
            }
        });
		
		
        $('.listChart').on('click', '.close', function () {
            var id = 'tab' + Number($(this).parents('li').attr('idx'));

            var obj = tabInfo[id];
            obj.close();

            var tabID = $(this).parents('a').attr('href');
            $(this).parents('li').remove();
            $(tabID).remove();

            tabNum--;

            var tabFirst = $('.listChart a:first');
            tabFirst.tab('show');
            $("#chartCntDiv").show();
            $('#totalViewDiv').hide();
            printChart(totalChartDat);
        });

        $('.totalView').click(function () {
            $("#chartCntDiv").show();
            $('#totalViewDiv').hide();
            printChart(totalChartDat);
        });

    });



    function setGrid() {
        currentgrid = getCurrentGrid();
        initGrid(currentgrid, messageGridColumn);
    }

    function closeDetailTab() {
        var tabFirst = $('.listChart a:first');
        tabFirst.tab('show');
    }

    function prevMsg() {
        var row = 0;
        if (grid2.Row > 0) {
            row = --grid2.Row;
            //viewer_openPop(row);
            grid2.Select(row, 0);
            return true;
        }
        return false;
    }

    function nextMsg() {
        var row = 0;
        if (grid2.Row < grid2.Rows - 1) {
            row = ++grid2.Row;
            viewer_openPop(row);
            grid2.Select(row, 0);
            if (grid2.Row == grid2.Rows - 2) {
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
                data.push({name: grid1.data[i]['rowKey'], data: items});
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
            data.push({name: dat['rowKey'], data: items});
        }

        var rotation = 40;
        if (chartxAxis == 'W') rotation = 0;
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
            plotOptions: {},
            series: data
        });
    }

    function getSearchQuery() {
    }

    function initProgressbar() {
        $('#loadingBar').removeAttr("style");
        document.getElementById('bar').style.width = '0px';
        document.getElementById('text').innerHTML = '0%';
    }
</script>

<div>
	<div class="searchArea w100">
		<div class="searchSub w100">
			<div>
				<input type="text" id="startdate" class="txt_center"  style="width: 110px;"/>
				<span class="hyphen">~</span>
			</div>
			<div>
				<input type="text" id="enddate" class="txt_center"  style="width: 110px;"/>
			</div>
			
			<div>
				<select id="piType" name="piType" style="width: 150px;"/>
					<option value="sum" selected>   <s:message code="condition.regexp.cnt"/> </option>  <%-- 문서 건수 --%>
					<option value="pattern"><s:message code="condition.sum.cnt"/> </option>   <%-- 총 패턴 검출--%>
				</select>
			</div>
			<div>
				<select id="piCount" name="piCount">
					<%if (Common.isEquals(systemLanguage,"ko"))  {%>
						<option value=""><s:message code="condition.infoStat.cnt"/></option>
				    	<option value="1" name="oneVal">1<s:message code="condition.infoStat.cnt.more"/></option>
						<option value="10">10<s:message code="condition.infoStat.cnt.more"/></option>
						<option value="50">50<s:message code="condition.infoStat.cnt.more"/></option>
						<option value="100">100<s:message code="condition.infoStat.cnt.more"/></option>
						<option value="200">200<s:message code="condition.infoStat.cnt.more"/></option>
						<option value="300">300<s:message code="condition.infoStat.cnt.more"/></option>
						<option value="500">500<s:message code="condition.infoStat.cnt.more"/></option>
					<%} %>
					<%if (Common.isEquals(systemLanguage,"en"))  {%>
					<option value=""><s:message code="condition.infoStat.cnt"/></option>
					<option value="1" name="oneVal"><s:message code="condition.infoStat.cnt.more"/> 1</option>
					<option value="10" ><s:message code="condition.infoStat.cnt.more"/> 10</option>
					<option value="50"><s:message code="condition.infoStat.cnt.more"/> 50</option>
					<option value="100"><s:message code="condition.infoStat.cnt.more"/> 100</option>
					<option value="200"><s:message code="condition.infoStat.cnt.more"/> 200</option>
					<option value="300"><s:message code="condition.infoStat.cnt.more"/> 300</option>
					<option value="500"><s:message code="condition.infoStat.cnt.more"/> 500</option>
					<%} %>
				</select>
			</div>
			
			<div>
				<button class="form_btn01" id="searchBtn"><s:message code="common.msg.search"/></button>
				<button class="form_btn02" id="clearBtn"><s:message code="condition.reset"/></button>
			</div>
		</div>
		<div class="searchSub w100">
			<div>
				<select id="busiSelect" class="selectpicker col-xs" data-style="btn-default btn-sm" multiple data-show-subtext="true" data-actions-box="true"></select>
			</div>
			<button class="btn01" id="dept"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
					code="common.org.choose.dept"/></button>
			<span id="deptSelectedArea" class="codeSelectedBtn">
				<button type="button" class="btn num_add bornone"  style="z-index: 2;">0</button>
			</span>
			<input type="hidden" id="deptStr" class="selectedTitle">
			<input type="hidden" id="deptVal">
			
			<button class="btn01" id="user"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message code="common.org.choose.user"/></button>
			<span id="userSelectedArea" class="codeSelectedBtn">
				<button type="button" class="btn num_add bornone"  style="z-index: 2;">0</button>
			</span>
			<input type="hidden" id="userStr" class="selectedTitle">
			<input type="hidden" id="userVal">
			<input type="hidden" id="userDept">
			<input type="hidden" id="userJib">
		</div>
	</div>
	<div class="content" style="padding-bottom: 50px;">
		<div class="contentSub">
			<div class="chartAreafull">
				<h3><s:message code="DATA_ANALYSIS.ANALYSIS_INFO"/></h3>
				<div class="chartBox" style="height: 350px;">
					<div id="infoStatListGrid" class="slickGrid gridArea" style="min-height: 280px;max-height: 280px;display: grid"></div>
				</div>
			</div>
			<div class="subtab">
				<div>
					<ul class="nav nav-tabs codeTab listChart">
						<li class="active"><a data-toggle="tab"  id="privateChartTab" href="#privateChart"><s:message code="analysis.infostat.chart"/></a></li>
						<li class=""> <a data-toggle="tab"  id="privateDetailTab" href="#privateDetail"><s:message code="analysis.infostat.list"/><span class="resultCnt"></span></a></li>
					</ul>
				</div>
			</div>
			<div>
				<div class="tab-content" style="min-height: 800px;height: 800px;">
					<div id="privateChart" class="tab-pane fade in active" style="min-height: 800px;height: 800px;">
						<div class="slickGrid gridArea" style="min-height: 800px;height: 800px;">
							<div id="mynetwork" style="display: grid; border:1px solid lightgray;min-height: 800px;height: 800px;">
								<img src="<c:url value='/img/icon/img_nodata.png'/>" alt="No Data" width="100px;" height="100px" style ="margin:auto; display:block;">
							</div>
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
					<div id="privateDetail" class="tab-pane fade in">
						<div id="selectGrid" class="slickGrid gridArea" style="min-height: 800px;height: 800px;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<i class="fa fa-calendar" aria-hidden="true" style="font-size: 1px;position: absolute;top: -100px"></i>
<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"></input>
	<input type="hidden" name="oldConm" id="oldConm"></input>
	<input type="hidden" name="oldDept" id="oldDept"></input>
	<input type="hidden" name="oldJib" id="oldJib"></input>
</form>

<script type="text/javascript">
    function getCurrentGrid() {
        var id = Number($('.listChart .active').attr('idx'));
        return tabInfo['tab' + id];
    }

    var grid1 = new Xgrid('infoStatListGrid', contextRoot);
    grid1.autoNumber();
    grid1.colAdd('rowKey', '<s:message code="consent.user"/>', 350, 'left', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (grid1.getValue(row, 'rowName') != '') return grid1.getValue(row, 'rowName') + '/' + grid1.getValue(row, 'jikgubnm') + '/' + grid1.getValue(row, 'deptnm') + '&lt;' + value + '&gt;';
        return value;
    });



    grid1.colAdd('pi_total', '<s:message code="bodyview.total"/>', 100, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if($('#piType').val() == 'sum') {
            if (value != undefined) return value.comma();
            else return '';
        }else return '<s:message code="bodyview.total.details"/>';
    });
    

    grid1.colAdd('pi_SN', '<s:message code="bodyview.sn"/>', 70, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    
    grid1.colAdd('pi_CN', '<s:message code="bodyview.cn"/>', 70, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.colAdd('pi_DN', '<s:message code="bodyview.dn"/>', 80, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.colAdd('pi_FN', '<s:message code="bodyview.fn"/>', 100, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.colAdd('pi_PN', '<s:message code="bodyview.pn"/>', 70, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.colAdd('pi_MN', '<s:message code="bodyview.mn"/>', 100, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.colAdd('pi_AN', '<s:message code="bodyview.an"/>', 110, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.colAdd('pi_CRN', '<s:message code="bodyview.crn"/>', 100, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.colAdd('pi_SSN', '<s:message code="bodyview.ssn"/>', 100, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.colAdd('pi_IMEI', 'IMEI', 70, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.colAdd('pi_BRN', '<s:message code="bodyview.brn"/>', 100, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.colAdd('pi_CPN', '<s:message code="bodyview.cpn"/>', 100, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
    grid1.colAdd('pi_MCN', '<s:message code="bodyview.mcn"/>', 70, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value != undefined) return value.comma();
        else return '';
    });
	

    grid1.loadExportMenu('<s:message code="DATA_ANALYSIS.ANALYSIS_INFO"/>');
    grid1.loadPageSize();
    grid1.loadHeader(false);
    grid1.initData('<s:message code="common.msg.search.click"/>');
    grid1.changePageSize = function (cnt) {
        getData('Y');
    };
    grid1.onClick = function () {
        if (grid1.Col === grid1.ColIndex('rowKey')) return;
        if($('#piType').val() != 'pattern') {
            initProgressbar();
            makeNetwork(grid1.getValue(grid1.Row, 'rowKey'), grid1.ColKey(grid1.Col), grid1.getValue(grid1.Row, grid1.Col));
        }else{
            detail_pi_total = grid1.getValue(grid1.Row, grid1.Col);
            getInfoDetailList("Y",grid1.getValue(grid1.Row, 'rowKey'), grid1.ColKey(grid1.Col));
		}
      
    };

    var grid2 = new Xgrid('selectGrid', contextRoot);
    grid2.autoNumber();
    grid2.colAdd('interestUserYn', '<s:message code="message.msg.interest"/>', 40, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
        if (value == 'N') return '';
        var value = grid2.getValue(row, 'interestGroupColor')
        var str = '';
        if(value != null && value != undefined && value != ''){
            var v = value.split(',');
            for(var i = 0; i < v.length; i++) {
                str += '<span style="display:inline-block; width: 11px; height: 11px; margin-left: 1px; background-color:'+v[i]+'"></span>';
            }
        }
        return str;
    });

    grid2.colAdd('readYn', '<s:message code="condition.read"/>', 40, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
        if (value == 'Y') return '<div class="readY"></div>';
        else if (value == 'N') return '<div class="readN"></div>';
        else return '-';
    });

    grid2.colAdd('attachcnt', '<s:message code="message.msg.file"/>', 35, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
        if (value == '0') return '';
        else return value.comma();
    });
    grid2.colAdd('inside', '<s:message code="message.msg.inout"/>', 55, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
        if (value == 'N') return '<s:message code="message.msg.out"/>';
        else if (value == 'Y') return '<s:message code="message.msg.in"/>';
        else return '-';
    });

    grid2.colAdd('direction_svc', '<s:message code="condition.receive_send"/>', 55, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
        if (value == 'I') return '<s:message code="condition.receive"/>';
        else if (value == 'O') return '<s:message code="condition.send"/>';
        else return '-';
    });

    grid2.colAdd('svcNm', '<s:message code="condition.service"/>', 180, 'center', false, 'nomal');
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
    grid2.colAdd('ctimeFormat', '<s:message code="condition.date"/>', 130, 'center', false, 'nomal');
    grid2.colAdd('user', '<s:message code="consent.user"/>', 120, 'center', false, 'link');
    grid2.colAdd('usr_id', '<s:message code="common.msg.account"/>', 110, 'center', false, 'nomal');
    grid2.colAdd('businm', '<s:message code="common.org.busi"/>', 120, 'center', true, 'nomal');
    grid2.colAdd('deptnm', '<s:message code="common.org.dept"/>', 120, 'center', false, 'nomal');
    grid2.colAdd('jikgubnm', '<s:message code="common.org.jikgub"/>', 120, 'center', false, 'nomal');
    grid2.colAdd('sender', '<s:message code="condition.sender"/>', 130, 'left', false, 'link', function(row, cell, value, columnDef, dataContext) {
        return highlightSearchStr(value, "sender");
    });
    grid2.colAdd('allofus', '<s:message code="condition.allofus"/>', 150, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
        if( value == undefined || value.length == 0) return '';

        for( var i=0; i<value.length; i++){
            if(value[i] == 'IA') value[i] = '<s:message code="condition.allofus1"/>';
            else if(value[i] == 'ET') value[i] = '<s:message code="condition.allofus8"/>';
            else if(value[i] == 'IT') value[i] = '<s:message code="condition.allofus7"/>';
            else if(value[i] == 'EA') value[i] = '<s:message code="condition.allofus2"/>';
            else if(value[i] == 'PT') value[i] = '<s:message code="condition.allofus9"/>';
            else if(value[i] == 'PA') value[i] = '<s:message code="condition.allofus3"/>';
        }
        return value.join(', ');
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
    grid2.colAdd('srcip', '<s:message code="condition.source"/> IP', 100, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
        return highlightSearchStr(value, "srcip");
    }, {sorter:sortUtil.ip});
    grid2.colAdd('dstip', '<s:message code="condition.destination"/> IP', 100, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
        return highlightSearchStr(value, "dstip");
    }, {sorter:sortUtil.ip});
    grid2.colAdd('attachname', '<s:message code="condition.attach_name"/>', 220, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
        var rtnVal = arrayToString(value);
        return highlightSearchStr(rtnVal, "attachname");
    });
    grid2.colAdd('sizeStr', '<s:message code="condition.size.all"/>', 80, 'left', false, 'nomal', null, {sortField:'size'});
    grid2.colAdd('bodySizeStr', '<s:message code="condition.size.body"/>', 80, 'left', false, 'nomal', null, {sortField:'body_size'});
    grid2.colAdd('attachSizeStr', '<s:message code="condition.size.attach.total"/>', 80, 'left', false, 'nomal', null, {sortField:'attachSizeSort'});
    grid2.colAdd('kwds', '<s:message code="condition.keyword"/>', 120, 'left', false, 'nomal');



    if ( isOCR ) {
        grid2.colAdd('ocr_attach_cnt', 'OCR <s:message code="message.msg.file"/>', 70, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
            if (value == '0' || value == '' || value == null || value == undefined ) return '';
            else return value.comma();
        });
    }
    grid2.loadExportMenu('<s:message code="DATA_ANALYSIS.ANALYSIS_INFO"/>');
    grid2.loadHeader(false);
    grid2.loadPageSize();
    grid2.changePageSize = function(cnt){
       // getInfoDetailList('Y');
    };
    grid2.initData('<s:message code="common.msg.search.click"/>');

    grid2.onClick = function() {

        var msgid = grid2.getValue(grid2.Row, 'msgid');

        if (grid2.Col == grid2.ColIndex('attachcnt')) {
            fileInfoViewer( msgid);
        }else if (grid2.Col == grid2.ColIndex('user')) {
            userInfoViewer( msgid, 'user' );
        }else if (grid2.Col == grid2.ColIndex('sender')) {
            userInfoViewer( msgid, 'sender' );
        }else if (grid2.Col == grid2.ColIndex('recvs')) {
            if(grid2.getValue(grid2.Row, 'recvs') != '') 	userInfoViewer( grid2.Row, 'recvs');
        }else if (grid2.Col == grid2.ColIndex('to')) {
            if(grid2.getValue(grid2.Row, 'to') != '') userInfoViewer( grid2.Row, 'to');
        }else if (grid2.Col == grid2.ColIndex('cc')) {
            if(grid2.getValue(grid2.Row, 'cc') != '') userInfoViewer( grid2.Row, 'cc');
        }else if (grid2.Col == grid2.ColIndex('bcc')) {
            if(grid2.getValue(grid2.Row, 'bcc') != '') userInfoViewer( grid2.Row, 'bcc');
        }else if(grid2.Col == grid2.ColIndex('pi_total')) {
            regexpInfoViewer(msgid);
        }else if(grid2.Col == grid2.ColIndex('referer_url')) {
            var referer_url = grid2.getValue(grid2.Row, 'referer_url');
            if(referer_url !='N') fnOpenWindow(referer_url, '', 1024, 800, 'resize');
        }else if (grid2.Col == grid2.ColIndex('ocr_attach_cnt')) {
            ocrFileInfoViewer( msgid);
        }else {

            if (!(adminMenu != "ALL" && adminMenu.indexOf("DV") < 0)) {
                if (!parent.$('#none_btn').hasClass('areaSelected')) viewer_open(grid2.Row);
                if (popWin) viewer_openFocus(grid2.Row);
            } else {
                alert('<s:message code="message.auth.no.detailview"/>');
                return;
            }
        }
    };

    // grid2.onDblClick = function(){
    //     viewer_open(grid2.Row);
    // }

    function viewer_open(row, bodySize) {
        var msgid = grid2.getValue(row, 'msgid');
        openMessageBodyPop(grid2.id, msgid, '', bodySize);
        grid2.setValue(row, grid2.ColIndex('readYn'), 'Y');
        grid2.Select(row, 0);
    }

    function getData(flag) {
        if (searchFlag) return;
        grid2.initData('<s:message code="common.msg.search.click"/>');
        var piCount = $('select[name=piCount]').val();
        var piType = $("select[name=piType] option:selected").val();
        var piCount_str = $('select[name=piCount] option:selected').text();
        var sDate = $('#startdate').val().replaceAll("-", "");
        var eDate = $('#enddate').val().replaceAll("-", "");
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

        if (sDate > eDate) ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
        $('#listTab b').remove();
        searchFlag = true;
        grid1.on();
        ui.get({
            url: 'getInfoStatList.xcn',
            piType:piType,
            startDate: sDate + "000000",
            endDate: eDate + "235959",
            offset: grid1.data.length,
            limit: grid1.pageSize,
            piCount: piCount,
            pMenuId: pMenuId,
            menuId: menuId,
            deptStr: deptStr,
            busiStr: busiStr,
            userStr: userStr,
            success: function (data, total) {
                grid1.setData(data);
                if (grid1.loadingPage == 0) grid1.Select(-1, -1);
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

    function getNodeByUser(data) {
        const result = [];
        const gridData = grid1.getRowData(grid1.Row);
        let title = '';
        if (gridData.rowName !== '') title = gridData.rowName + '/' + gridData.jikgubnm + '/' + gridData.deptnm + '<' + gridData.rowKey + '>';
        else title = gridData.rowKey;

        result.push({id: gridData.rowKey, title: title});
        return result;
    }

    function getNodeBySvc(data) {
        var result = [];
        for (var i = 0; i < data.length; i++) {
            var svc1 = data[i]['svc1'];
            var id = data[i]['svcNm'];
            if (svc1 === 'X' || svc1 === 'U') id = data[i]['host'];
            result.push(id);
        }
        return result.unique();
    }

    function getNodeByField(field, data) {
        var result = [];
        for (var i = 0; i < data.length; i++) {
            var val = data[i][field];
            result.push(val);
        }
        return result.unique();
    }


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

    function getSelectOption(data) {
        var str = '';
        for (var i = 0; i < data.length; i++) {
            str += '<option value="' + data[i].code + '">' + data[i].codeName + '</option>';
        }
        return str;
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


    var piArr = ['pi_FN', 'pi_SN', 'pi_DN', 'pi_CN', 'pi_PN', 'pi_MN', 'pi_AN', 'pi_CRN', 'pi_SSN', 'pi_IMEI', 'pi_BRN', 'pi_CPN', 'pi_MCN'];
    var piNmArr = ['<s:message code="bodyview.fn"/>', '<s:message code="bodyview.sn"/>', '<s:message code="bodyview.dn"/>', '<s:message code="bodyview.cn"/>', '<s:message code="bodyview.pn"/>', '<s:message code="bodyview.mn"/>', '<s:message code="bodyview.an"/>', '<s:message code="bodyview.crn"/>', '<s:message code="bodyview.ssn"/>', '<s:message code="bodyview.imei"/>', '<s:message code="bodyview.brn"/>', '<s:message code="bodyview.cpn"/>', '<s:message code="bodyview.mcn"/>'];
    var piGroupArr = ['pattern_FN', 'pattern_SN', 'pattern_DN', 'pattern_CN', 'pattern_PN', 'pattern_MN', 'pattern_AN', 'pattern_CRN', 'pattern_SSN', 'pattern_IMEI', 'pattern_BRN', 'pattern_CPN', 'pattern_MCN'];

    function getNodeByPI(data) {
        var result = [];
        for (var i = 0; i < data.length; i++) {
            for (var x = 0; x < piArr.length; x++) {
                var val = data[i]['piMap'][piArr[x]];
                if (val > 0 ) result.push(piArr[x]);
            }
        }
        return result.unique();
    }

    function getPatternInfo(pId) {
        var result = {};
        var idx = piArr.indexOf(pId);
        result.pi_Nm = piNmArr[idx];
        result.pattern_group = piGroupArr[idx];
        return result;
    }

    function getTimeFormat(time) {
        var result = time.substring(8, 14);
        result = result.substring(0, 2) + ":" + result.substring(2, 4) + ":" + result.substring(4, 6);
        return result;
    }

    function getDateFormat(date) {
        return date.substring(0, 4) + "-" + date.substring(4, 6) + "-" + date.substring(6, 8);
    }

    let detail_pi_total = 0;
    function getInfoDetailList(flag,value,type) {

        if ( flag == 'Y' || flag == undefined ) {
            grid2.data.length = 0;
            grid2.rtnNextPageFunc = getInfoDetailList;
            grid2.loadingPage = 0;
        } else {
            grid2.loadingPage++;
        }

        var userkey = value;

        if(userkey==undefined){
            userkey=flag.userkey;
        }

        var type = type;

        if(type==undefined){
            type= grid1.ColKey(grid1.Col);
        }
		
        var piCount = $('#piCount').val();
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
        else userStr = ''

	    let searchAfter = null;
        if(grid2.loadingPage > 0) {
            searchAfter = grid2.getValue(grid2.data.length-1, 'msgid');
        }
			
        grid2.on();
        ui.postJson({
            url: 'getInfoDetailList.xcn',
            userkey: userkey,
            type: type,
            startDate: $('#startdate').val().replaceAll("-", "") + "000000",
            endDate: $('#enddate').val().replaceAll("-", "") + "235959",
            piCount: piCount,
            offset: grid2.data.length,
            limit: grid2.pageSize,
            deptStr: deptStr,
            busiStr: busiStr,
	        searchAfter :searchAfter,
            userStr: userStr,
            success: function (data, total) {
             	$(".resultCnt").html(' ' + patternCountStr + '(' +addCommas(detail_pi_total)+') '+ docCountStr+  '('+addCommas(total)+')');

                grid2.appendData(data);
                if ( grid2.loadingPage == 0 ) grid2.Select(-1,-1);
            },
            error: function (status, message) {
                alert(message);
            },
            complete: function () {
                grid2.off();
            }
        });
    }



    function makeNetwork(value, type, pi_total) {
        var userkey = value;
        var type = type;
        var pi_total = pi_total;
        var piCount = $('#piCount').val();
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
        ui.postJson({
            url: 'getInfoNetwork.xcn',
            userkey: userkey,
            type: type,
            startDate: $('#startdate').val().replaceAll("-", "") + "000000",
            endDate: $('#enddate').val().replaceAll("-", "") + "235959",
            piCount: piCount,
            offset: 0,
            limit: -1,
            deptStr: deptStr,
            busiStr: busiStr,
            userStr: userStr,
            success: function (data, total) {
                /*	grid2.setData(data);*/
                var nodes = [];
                var edges = [];
             
                if (pi_total === 0) {
                    nodes.push({
                        id: 'noneData',
                        font: {multi: 'html'},
                        title: '<s:message code="analysis.infostat.notleak"/>',
                        label: '<s:message code="analysis.infostat.notleak"/>',
                        group: 'noneData'
                    });
                } else {

                    var nodeLv1 = getNodeByUser(data);
                    var nodeLv2 = type === 'pi_total' ? getNodeByPI(data) : [type];
                    var nodeLv3 = getNodeByField('ctime_yyyymmdd', data);
                    var nodeLv4 = getNodeBySvc(data);
                    

                    for (var i = 0; i < nodeLv1.length; i++) {
                        nodes.push({id: nodeLv1[i].id, font: {multi: 'html'}, title: nodeLv1[i].title, label: nodeLv1[i].title, group: 'user'});
                    }
                    for (var i = 0; i < nodeLv2.length; i++) {
                        if (type === nodeLv2[i] || type === 'pi_total') {
                            var pi = getPatternInfo(nodeLv2[i]);
                            nodes.push({id: nodeLv2[i], font: {multi: 'html'}, title: pi.pi_Nm, label: pi.pi_Nm, group: pi.pattern_group});
                        }
                    }
                    for (var i = 0; i < nodeLv3.length; i++) {
                        nodes.push({id: nodeLv3[i], font: {multi: 'html'}, title: getDateFormat(nodeLv3[i]), label: getDateFormat(nodeLv3[i]), group: 'date'});
                    }
                    for (var i = 0; i < nodeLv4.length; i++) {
                        nodes.push({id: nodeLv4[i], font: {multi: 'html'}, title: nodeLv4[i], label: nodeLv4[i], group: 'msg'});
                    }


                    for (var i = 0; i < nodeLv1.length; i++) {
                        for (var j = 0; j < nodeLv2.length; j++) {
                            var sum = 0;
                            for (var x = 0; x < data.length; x++) {
                                if (nodeLv1[i].id === data[x].userkey && data[x]['piMap'][nodeLv2[j]] > 0  ) sum += data[x]['piMap'][nodeLv2[j]];
                            }
                            if (sum > 0) edges.push({from: nodeLv1[i].id, to: nodeLv2[j], arrows: 'to', color: {color: '#3FB168'}, font: {multi: true}, label: sum.comma()});
                        }
                    }
                    for (var i = 0; i < nodeLv2.length; i++) {
                        for (var j = 0; j < nodeLv3.length; j++) {
                            var sum = 0;
                            for (var x = 0; x < data.length; x++) {
                                if (data[x]['piMap'][nodeLv2[i]] > 0 && data[x].ctime_yyyymmdd === nodeLv3[j]) sum += data[x]['piMap'][nodeLv2[i]];
                            }
                            if (sum > 0) edges.push({from: nodeLv2[i], to: nodeLv3[j], arrows: 'to', color: {color: '#2A6727'}, font: {multi: true}, label: sum.comma()});
                        }
                    }

                    for (var i = 0; i < nodeLv3.length; i++) {
                        for (var j = 0; j < nodeLv4.length; j++) {
                            var sum = 0;
                            for (var x = 0; x < data.length; x++) {
                                var svc1 = data[x].svc1;
                                var id = data[x]['svcNm'];
                                if (svc1 === 'X' || svc1 === 'U') id = data[x]['host'];
                                if (data[x].ctime_yyyymmdd === nodeLv3[i] && id === nodeLv4[j]) {
                                    for (var y = 0; y < nodeLv2.length; y++) {
                                        if (data[x]['piMap'][nodeLv2[y]] > 0  ) sum += data[x]['piMap'][nodeLv2[y]];
                                    }
                                }
                            }
                            if (sum > 0) edges.push({from: nodeLv3[i], to: nodeLv4[j], arrows: 'to', color: {color: '#2A6727'}, font: {multi: true}, label: sum.comma()});
                        }
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
                                size: 30,
                                color: '#222222'
                            },
                        },
                        msg: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf26b',
                                size: 30,
                                color: '#238AE6'
                            },
                            nodeDistance: 10,
                            hierarchicalRepulsion: {
                                nodeDistance: 10,
                            }
                        },
                        date: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf073',
                                size: 30,
                                color: '#222222'
                            },
                            nodeDistance: 10,
                            hierarchicalRepulsion: {
                                nodeDistance: 10,
                            }
                        },
                        user: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf2bd',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_CN: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf09d',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_SN: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf2bb',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_PN: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf072',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_DN: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf1b9',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_FN: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf2c2',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_MN: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf10b',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_AN: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf041',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_CRN: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf207',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_SSN: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf2c2',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_IMEI: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf2c1',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_BRN: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf298',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_CPN: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf022',
                                size: 30,
                                color: '#222222'
                            },
                        },
                        pattern_MCN: {
                            shape: 'icon',
                            icon: {
                                face: 'FontAwesome',
                                code: '\uf233',
                                size: 30,
                                color: '#222222'
                            },
                        }
                    },
                    edges: {
                        color: '#FF0000',
                        font: {
                            size: 13
                        },
                        arrowStrikethrough: true,
                    },
                    nodes: {
                        shape: 'box',
                    },
                    manipulation: false,
                    layout: {
                        hierarchical: {
                            enabled: true,
                            levelSeparation: 300,
                            direction: 'LR',
                            sortMethod: 'directed'
                        }
                    },
                    physics: {
                        stabilization: {
                            enabled: true,
                            iterations: 1000,
                            updateInterval: 10
                        },
                        hierarchicalRepulsion: {
                            nodeDistance: 100
                        },
                        barnesHut: {
                            gravitationalConstant: -26,
                            centralGravity: 0.005,
                            springLength: 230,
                            springConstant: 0.18
                        },
                    }
                };
                var network = new vis.Network(container, data_, options);
                network.on("getConnectedNodes", function (params) {
                });
                network.on("click", function (params) {
                    console.log(params.nodes[0]);
                });
                //현재 선택된 노드의 아이디를 가지고 옴
                var mySelectionOrder = [];
                var previouslySelected = {};
                network.on('select', function (params) {
                    var selected = {};
                    params.nodes.forEach(function (n) {
                        if (!previouslySelected[n]) {
                            mySelectionOrder.push(n);
                        }
                        selected[n] = true;
                    });
                    mySelectionOrder = mySelectionOrder.filter(
                        function (e, i, a) {
                            return selected[e];
                        });
                    previouslySelected = selected;
                });
                network.on("stabilizationProgress", function (params) {
                    var maxWidth = 496;
                    var minWidth = 20;
                    var widthFactor = params.iterations / params.total;
                    var width = Math.max(minWidth, maxWidth * widthFactor);
                    document.getElementById('bar').style.width = width + 'px';
                    document.getElementById('text').innerHTML = Math.round(widthFactor * 100) + '%';
                });
                network.once("stabilizationIterationsDone", function () {
                    document.getElementById('text').innerHTML = '100%';
                    document.getElementById('bar').style.width = '100%';
                    document.getElementById('loadingBar').style.opacity = 0;
                    // really clean the dom element
                    setTimeout(function () {
                        document.getElementById('loadingBar').style.display = 'none';
                    }, 500);
                });
            },
            error: function (status, message) {
                alert(message);
            },
            complete: function () {
            }
        });
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

        if ($('#' + codeType + 'Str').val() != '') {
            $('#' + codeType + 'SelectedArea').find('.btn').text(data.length);
            $('#' + codeType + 'SelectedArea').show();
        } else {
            $('#' + codeType + 'SelectedArea').find('.btn').text(0);
            $('#' + codeType + 'SelectedArea').hide();
        }
    }

</script>