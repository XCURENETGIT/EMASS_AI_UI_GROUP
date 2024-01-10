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
	$(document).ready(function () {
        initCondition();

        $('#dept').click(function () {
            var code = $(this).attr('id');
            openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
        });

        $('#user').click(function () {
            var code = $(this).attr('id');
            openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
        });


        $(document).on('click', '#deptSelectedArea', function (e) {
            $('#deptVal, #deptStr').val('');
            $('#deptSelectedArea').hide();
        });

        $(document).on('click', '#userSelectedArea', function (e) {
            $('#userVal, #userVal').val('');
            $('#userSelectedArea').hide();
        });



        $('#searchBtn').click(function () {
			closeDetailTab();
			getData('Y');
            if (codeType == 'deptByCo') $('#deptByCoStrSpan').html('');
            $('#' + codeType + 'Val').val('');
            $('#' + codeType + 'Str').val('');
            $('#' + codeType + 'SelectedArea').hide();
		});

		$('#clearBtn').click(function(){
			$('#startdate').val(new Date().format('yyyy-mm-dd'));
			$('#enddate').val(new Date().format('yyyy-mm-dd'));
		});

		$('#chartCntDiv .dropdown-menu li a').click(function () {
			chartcnt = $(this).text();
			printChart(totalChartDat);
		});

		$('#startdate').val(new Date().format('yyyy-mm-dd'));
		$('#enddate').val(new Date().format('yyyy-mm-dd'));

		$(".nav-tabs").on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
		})

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

		getData('Y');

	});

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
				<input type="date" id="startdate" style="width: 110px;"/>
				<span class="hyphen">~</span>
			</div>
			<div>
				<input type="date" id="enddate" style="width: 110px;"/>
			</div>

			<div>
				<select id="piCount" name="piCount">
					<option value="">기준 유출 건수</option>
					<option value="1" selected="">1건 이상</option>
					<option value="2">2건 이상</option>
					<option value="5">5건 이상</option>
					<option value="10">10건 이상</option>
					<option value="20">20건 이상</option>
					<option value="50">50건 이상</option>
					<option value="100">100건 이상</option>
				</select>
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
	</div>
	<div class="content" style="padding-bottom: 50px;">
		<div class="contentSub">
			<div class="chartAreafull">
				<h3>개인정보 유출 관계 분석</h3>
				<div class="chartBox" style="height: 350px;">
					<div id="infoStatListGrid" class="slickGrid gridArea" style="min-height: 280px;max-height: 280px;display: grid"></div>
				</div>
			</div>
			<div class="subtab">
				<div>
					<ul class="nav nav-tabs codeTab listChart">
						<li class="active"><a data-toggle="tab" href="#privateChart">개인정보 유출 관계도</a></li>
						<li class=""><a data-toggle="tab" href="#privateDetail">개인정보 유출 내역</a></li>
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
<i class="fa fa-calendar" aria-hidden="true" style="font-size: 1px;position: absolute;top: -100px"></i><!-- 유출 관계도에서 사용되는 font-->
<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"></input>
	<input type="hidden" name="oldConm" id="oldConm"></input>
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
		if (value != undefined) return value.comma();
		else return '';
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
	grid1.colAdd('pi_MN', '휴대전화번호', 100, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
		if (value != undefined) return value.comma();
		else return '';
	});
	grid1.colAdd('pi_AN', '주소(도로명, 지번)', 110, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
		if (value != undefined) return value.comma();
		else return '';
	});
	grid1.colAdd('pi_CRN', '자동차 등록번호', 100, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
		if (value != undefined) return value.comma();
		else return '';
	});
	grid1.colAdd('pi_SSN', '사회 보장번호', 100, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
		if (value != undefined) return value.comma();
		else return '';
	});
	grid1.colAdd('pi_IMEI', 'IMEI', 70, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
		if (value != undefined) return value.comma();
		else return '';
	});
	grid1.colAdd('pi_BRN', '사업자 등록번호', 100, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
		if (value != undefined) return value.comma();
		else return '';
	});
	grid1.colAdd('pi_CPN', '법인 등록번호', 100, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
		if (value != undefined) return value.comma();
		else return '';
	});
	grid1.colAdd('pi_MCN', 'MAC 주소', 70, 'right', false, 'link', function (row, cell, value, columnDef, dataContext) {
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
		initProgressbar();
		makeNetwork(grid1.getValue(grid1.Row, 'rowKey'), grid1.ColKey(grid1.Col), grid1.getValue(grid1.Row, grid1.Col));
	};

	var grid2 = new Xgrid('selectGrid', contextRoot);
	initGrid(grid2, messageGridColumn);


	function viewer_open(row, bodySize ){
		var msgid = grid2.getValue(row, 'msgid');
		openMessageBodyPop(grid2.id, msgid, '', bodySize);
		grid.setValue(row, grid2.ColIndex('readYn'), 'Y');
		grid.Select(row, 0);
	}

	function getData(flag) {
		if (searchFlag) return;
		var piCount = $('select[name=piCount]').val();
		var piCount_str = $('select[name=piCount] option:selected').text();
		var sDate = $('#startdate').val().replaceAll("-", "");
		var eDate = $('#enddate').val().replaceAll("-", "");
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


		if (sDate > eDate) ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
		$('#listTab b').remove();
		searchFlag = true;
		grid1.on();
		ui.get({
			url: 'getInfoStatList.xcn',
			startDate: sDate + "000000",
			endDate: eDate + "235959",
			offset: grid1.data.length,
			limit: grid1.pageSize,
			piCount: piCount,
			pMenuId: pMenuId,
			menuId: menuId,
			deptStr:dept,
			busiStr:busi,
            userStr:userStr,

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

		result.push({id:gridData.rowKey, title:title});
		return result;
	}

	function getNodeBySvc(data) {
		var result = [];
		for (var i = 0; i < data.length; i++) {
			var svc1 = data[i]['svc1'];
			var id = data[i]['svcNm'];
			if(svc1 === 'X' || svc1 === 'U') id = data[i]['host'];
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



    }


	var piArr = ['pi_FN', 'pi_SN', 'pi_DN', 'pi_CN', 'pi_PN', 'pi_MN', 'pi_AN', 'pi_CRN', 'pi_SSN', 'pi_IMEI', 'pi_BRN', 'pi_CPN', 'pi_MCN'];
	var piNmArr = ['<s:message code="bodyview.fn"/>', '<s:message code="bodyview.sn"/>', '<s:message code="bodyview.dn"/>', '<s:message code="bodyview.cn"/>', '<s:message code="bodyview.pn"/>', '<s:message code="bodyview.mn"/>', '<s:message code="bodyview.an"/>', '<s:message code="bodyview.crn"/>', '<s:message code="bodyview.ssn"/>', '<s:message code="bodyview.imei"/>', '<s:message code="bodyview.brn"/>', '<s:message code="bodyview.cpn"/>', '<s:message code="bodyview.mcn"/>'];
	var piGroupArr = ['pattern_FN', 'pattern_SN', 'pattern_DN', 'pattern_CN', 'pattern_PN', 'pattern_MN', 'pattern_AN', 'pattern_CRN', 'pattern_SSN', 'pattern_IMEI', 'pattern_BRN', 'pattern_CPN', 'pattern_MCN'];

	function getNodeByPI(data) {
		var result = [];
		for (var i = 0; i < data.length; i++) {
			for (var x = 0; x < piArr.length; x++) {
				var val = data[i][piArr[x]];
				if (val > 0) result.push(piArr[x]);
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

	function makeNetwork(value, type, pi_total){
		var userkey = value;
		var type = type;
		var pi_total = pi_total;
		var piCount = $('#piCount').val();
		ui.postJson({
			url : 'getInfoNetwork.xcn',
			userkey : userkey,
			type : type,
			startDate : $('#startdate').val().replaceAll("-","")+"000000",
			endDate : $('#enddate').val().replaceAll("-","")+"235959",
			piCount : 1,
			offset : 0,
			limit : -1,
			success : function(data, total) {
				grid2.setData(data);
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
								if (nodeLv1[i].id === data[x].userkey && data[x][nodeLv2[j]] > 0) sum += data[x][nodeLv2[j]];
							}
							if (sum > 0) edges.push({from: nodeLv1[i].id, to: nodeLv2[j], arrows: 'to', color: {color: '#3FB168'}, font: {multi: true}, label: sum.comma()});
						}
					}
					for (var i = 0; i < nodeLv2.length; i++) {
						for (var j = 0; j < nodeLv3.length; j++) {
							var sum = 0;
							for (var x = 0; x < data.length; x++) {
								if (data[x][nodeLv2[i]] > 0 && data[x].ctime_yyyymmdd === nodeLv3[j]) sum += data[x][nodeLv2[i]];
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
								if(svc1 === 'X' || svc1 === 'U') id = data[x]['host'];
								if (data[x].ctime_yyyymmdd === nodeLv3[i] && id === nodeLv4[j]) {
									for (var y = 0; y < nodeLv2.length; y++) {
										if(data[x][nodeLv2[y]] > 0) sum += data[x][nodeLv2[y]];
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
						date : {
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
						color:'#FF0000',
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
							enabled:true,
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
					network.on("getConnectedNodes", function(params) {
				});
				network.on("click",function(params){
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
					document.getElementById('bar').style.width = '100%';
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