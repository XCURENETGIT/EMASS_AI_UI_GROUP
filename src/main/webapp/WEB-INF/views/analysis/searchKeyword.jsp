<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<style>
	.coach_modal {display: none;position: fixed;z-index: 99999;padding-top: 100px;left: 76px;top: 0;width: 100%;height: 100%;overflow: auto;background-color: rgb(0,0,0);background-color: rgba(0,0,0,0.8); /* Black w/ opacity */}
	.coach_modal .modal-content {margin: auto;padding: 20px;width: 93%;height:90%;background: none;border:none;color:#fff;font-wight:400;z-index: 999999;}
	.coach_modal .coach_logo {font-size:12px; font-weight:300; letter-spacing:1.5px; border-top:1px solid #fff;}
	.coach_modal .coach_logo img { margin-top:80px; height:32px;}
	.coach_modal .coach_tit {margin-top:56px; font-size:18px; font-weight: 300;color:#fff; line-height: 1.5;}
	.coach_modal .coach_name {margin-top:24px; font-size:32px; font-weight: 600;color:#fff; line-height: 1.5;}
	.coach_modal .coach_name span {color:#88B8FF;font-weight: 600;}
	.coach_modal .coach_call {font-size:13px;margin-right:8px; letter-spacing:0.6px;  margin-top:20px; padding:8px 12px; background: #88B8FF; color:#fff; display: inline-block; border-radius: 4px; }
	/* The Modal (background) */
	.coach_modal {
		display: block; /* Hidden by default */
		position: fixed; /* Stay in place */
		padding-top: 100px; /* Location of the box */
		left: 40px;
		top: 0;
		z-index: 55;
		width: 100%; /* Full width */
		height: 100%; /* Full height */
		overflow: auto; /* Enable scroll if needed */
		background-color: rgb(0,0,0); /* Fallback color */
		background-color: rgba(0,0,0,0.8); /* Black w/ opacity */
	}

	/* Modal Content */
	.modal-content {
		margin: auto;
		padding: 20px;
		width: 93%;
		height:90%;
		background: none;
		border:none;
		color:#fff;
		font-wight:400;

	}

</style>
<div id="myModal" class="coach_modal">
	<div class="modal-content">
		<div>
			<div class="coach_name"><span>${_USERCREDENTIAL_.adminName}</span>님 환영합니다.</div>
			<div class="coach_tit">이용하고자 하는 서비스의 기능은 추가 패키지를 구매하실 경우 이용이 가능합니다.</div>
			<p style="padding-bottom:80px;">
				<span class="coach_call"> 영업 연락처<a href="mailto:salesteam@xcurenet.com" target="_top">salesteam@xcurenet.com</a></span>
				<span class="coach_call"> 기술 연락처<a href="mailto:helpdesk@xcurenet.com" target="_top">helpdesk@xcurenet.com</a></span>
			</p>
		</div>
		<div class="coach_logo">
			<img src="<c:url value="/img/logo_xcurenet.png"/>" alt="xcurenet">
			<p class="mat16">Venus EMASS AI</p>
		</div>
	</div>
</div>
<style>
	.table_btn01 {cursor: pointer}
</style>
<script type="text/javascript">

	Highcharts.setOptions({
		chart: {
			type: 'column',
			marginTop: 15,
			marginBottom: 60,
			spacingBottom: 0
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
	$(document).ready(function () {
		initCondition();
		$('#dept').click(function () {
			const code = $(this).attr('id');
			openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
		});

		$('#user').click(function () {
			const code = $(this).attr('id');
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

		let dateObj = new Date();
		$('#clearBtn').click(function () {
			$('#startdate').val(new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate() - 7).format('yyyy-mm-dd'));
			$('#enddate').val(new Date().format('yyyy-mm-dd'));
			$('#deptVal, #deptStr').val('');
			$('#deptSelectedArea').hide();
			$('#userVal, #userVal').val('');
			$('#userSelectedArea').hide();
			$('#busiSelect').selectpicker('val', '');
		});
		$('#searchBtn').click(function () {
			getData();
		});

		$('#startdate').val(new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate() - 7).format('yyyy-mm-dd'));
		$('#enddate').val(new Date().format('yyyy-mm-dd'));

		getData();
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

	function getSelectedBusi() {
		return arrayToString($('#busiSelect').selectpicker('val'));
	}

	function getSelectedDept() {
		return $('#deptVal').val().split('|').join(',');
	}

	function getSelectedUser() {
		return $('#userVal').val().split('|').join(',');
	}

	let searchFlag = false;
	function getData(lastRow) {
		if (searchFlag) return;

		if (lastRow === undefined) {
			grid1.data.length = 0;
			grid1.rtnNextPageFunc = getData;
			grid1.loadingPage = 0;
		} else grid1.loadingPage++;

		const sDate = $('#startdate').val().replaceAll("-", "");
		const eDate = $('#enddate').val().replaceAll("-", "");
		if (sDate > eDate) ui.alertMsg('<s:message code="blockHistoryNonBusi.msg.cannot.startendtime"/>');

		grid1.on();
		searchFlag = true;
		ui.get({
			url: 'getSearchHistoryList.xcn',
			startDt: sDate,
			endDt: eDate,
			deptStr: getSelectedDept(),
			busiStr: getSelectedBusi(),
			userStr: getSelectedUser(),
			offset: grid1.data.length,
			limit: grid1.pageSize,
			success: function (data, total) {
				$("#keywordCount").html(' [' + data['numFound'].comma() + '건]');
				grid1.appendData(data.buckets);
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				searchFlag = false;
				grid1.off();
			}
		});
	}

	var currentKeyword = '';
	function getSearchKeywordTrend(keyword) {
		const sDate = $('#startdate').val().replaceAll("-", "");
		const eDate = $('#enddate').val().replaceAll("-", "");
		currentKeyword = keyword;

		grid2.on();
		ui.get({
			url: 'getSearchKeywordTrend.xcn',
			startDt: sDate,
			endDt: eDate,
			deptStr: getSelectedDept(),
			busiStr: getSelectedBusi(),
			userStr: getSelectedUser(),
			keyword: currentKeyword,
			success: function (data, total) {
				getChart(data);
				getSearchHistoryDetailList();
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				grid2.off();
			}
		});
	}

	function getChart(data) {
		$('#chartArea1').html('');
		Highcharts.chart('chartArea1', {
			chart: {
				zoomType: 'x',
				marginBottom: 65
			},
			credits: chartAPI.credits,
			exporting: chartAPI.exporting2,
			title: {text: ' '},
			xAxis: {
				type: 'datetime',
				maxZoom: 24 * 60 * 60 * 1000, // a day
				title: {text: null}
			},
			yAxis: {
				min: 0,
				title: {text: ''},
				stackLabels: {
					enabled: true,
					style: {
						fontWeight: 'bold',
						color: '#5B5C60'
					}
				},
			},
			tooltip: {
				shared: true
			},
			plotOptions: {
				line: {
					pointPadding: 0.2,
					borderWidth: 0,
					marker: {
						enabled: false
					}
				}
			},
			series: data
		});
	}

	var searchFlag2 = false;

	function getSearchHistoryDetailList(lastRow) {
		if (searchFlag2) return;

		if (lastRow === undefined) {
			grid2.data.length = 0;
			grid2.rtnNextPageFunc = getData;
			grid2.loadingPage = 0;
		} else grid2.loadingPage++;

		const sDate = $('#startdate').val().replaceAll("-", "");
		const eDate = $('#enddate').val().replaceAll("-", "");
		if (sDate > eDate) ui.alertMsg('<s:message code="blockHistoryNonBusi.msg.cannot.startendtime"/>');

		grid2.on();
		searchFlag2 = true;
		ui.get({
			url: 'getSearchHistoryDetailList.xcn',
			startDt: sDate,
			endDt: eDate,
			deptStr: getSelectedDept(),
			busiStr: getSelectedBusi(),
			userStr: getSelectedUser(),
			keyword: currentKeyword,
			offset: grid2.data.length,
			limit: grid2.pageSize,
			success: function (data, total) {
				grid2.appendData(data);
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				searchFlag2 = false;
				grid2.off();
			}
		});
	}

	function openCodeWindow(id, oldCode, oldConm) {
		$('#oldCode').val(oldCode);
		$('#oldConm').val(oldConm);

		fnOpenWindow('', 'selectCodeWinPopup', 1200, 700, 'resize');

		$('#codeParam').attr('target', 'selectCodeWinPopup');
		$('#codeParam').attr('action', '<c:url value="/commons/selectCode.do?codeType='+id+'"/>');
		$('#codeParam').attr('method', 'post');
		$('#codeParam').submit();
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
</script>
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
			<button class="form_btn01" id="searchBtn"><s:message code="common.msg.search"/></button>
			<button class="form_btn02" id="clearBtn"><s:message code="condition.reset"/></button>
		</div>
	</div>
	<div class="searchSub w100">
		<div>
			<select id="busiSelect" class="selectpicker col-xs" data-style="btn-default btn-sm" multiple data-show-subtext="true" data-actions-box="true"></select>
		</div>
		<button class="btn01" id="dept"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message code="common.org.choose.dept"/></button>
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
	</div>
</div>
<div class="content">
	<div class="contentSub">
		<div class="chartArea02" style="grid-template-columns: 490px 1fr;">
			<div>
				<h3>웹 검색어
					<div id="keywordCount" style="display: inline;padding-left: 5px;font-size: 16px;color: #C1924E;"></div>
				</h3>
				<div class="panel-default">
					<div class="inner_personaldata">
						<div id="keywordGrid" style="height: 100%;border: 0;" class="slickGrid"></div>
					</div>
				</div>
			</div>
			<div>
				<h3>웹 검색어 트렌드</h3>
				<div class="panel-default">
					<div class="inner_personaldata" style="height:280px;">
						<div id="chartArea1" style="height: 100%"></div>
					</div>
				</div>
				<h3 class="mat32">웹 검색어 상세</h3>
				<div class="panel-default">
					<div class="inner_personaldata">
						<div id="detailGrid" style="height: 100%;border: 0;" class="slickGrid"></div>
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
	function escapeHtml(str) {
		var map = {
			'&': '&amp;',
			'<': '&lt;',
			'>': '&gt;',
			'"': '&quot;',
			"'": '&#039;'
		};
		return str.replace(/[&<>"']/g, function (m) {
			return map[m];
		});
	}

	function getRawValue(data, key) {
		if (data === undefined) return null;
		return data[key];
	}

	let grid1 = new Xgrid('keywordGrid', contextRoot);
	grid1.autoNumber();
	grid1.colAdd('key', '검색어', 280, "left", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return escapeHtml(value);
	});
	grid1.colAdd('count', '조회 수', 70, "center", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return value.comma();
	});
	grid1.colAdd('open', '트랜드', 70, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return "<input type='button' value='트랜드' class='table_btn01' style='line-height: 0; color:white; height:20px; vertical-align: 1px; font-weight:bold;'/>";
	});

	grid1.loadExportMenu('웹 검색어');
	grid1.loadHeader(false);
	grid1.loadPageSize();
	grid1.initData('<s:message code="common.msg.search.click"/>');
	grid1.onClick = function (row, col, e) {
		if (grid1.Col === grid1.ColIndex('open')) {
			getSearchKeywordTrend(grid1.getValue(row, grid1.ColIndex('key')));
		}
	};

	$('#detailGrid').width($(document).outerWidth() - 630);
	$(document).sizeChanged(function (element) {
		$('#detailGrid').width($(document).outerWidth() - 630);
		try {
			grid2.resizeCanvas();
		} catch (e) {
		}
	});

	let grid2 = new Xgrid('detailGrid', contextRoot);
	grid2.autoNumber();
	grid2.colAdd('ctime', '일시', 140, "center", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return fCompleteDateFormat(value);
	});
	grid2.colAdd('service.desc', '서비스', 150, "center", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return getRawValue(grid2.getRowData(row)['service'], 'desc');
	});
	grid2.colAdd('keyword', '검색어', 200, "left", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return escapeHtml(value);
	});
	grid2.colAdd('user.busiNm', '사업장', 120, "center", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return getRawValue(grid2.getRowData(row)['user'], 'busiNm');
	});
	grid2.colAdd('user.deptNm', '부서', 120, "center", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return getRawValue(grid2.getRowData(row)['user'], 'deptNm');
	});
	grid2.colAdd('user.jikgubNm', '직급', 80, "center", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return getRawValue(grid2.getRowData(row)['user'], 'jikgubNm');
	});
	grid2.colAdd('user.name', '사용자', 80, "center", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return getRawValue(grid2.getRowData(row)['user'], 'name');
	});
	grid2.colAdd('network.srcIp', '사용자 IP', 100, "center", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return getRawValue(grid2.getRowData(row)['network'], 'srcIp');
	});
	grid2.colAdd('http.url', 'URL', 680, "left", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return getRawValue(grid2.getRowData(row)['http'], 'url');
	});

	grid2.loadExportMenu('웹 검색어 상세');
	grid2.loadHeader(false);
	grid2.loadPageSize();
	grid2.initData('<s:message code="common.msg.search.click"/>');
</script>