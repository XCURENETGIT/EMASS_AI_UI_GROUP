<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>

<!DOCTYPE html>
<html lang="ko">
<head>
	<title></title>
	<style type="text/css">
	</style>
	<script>
		var searchFlag = false;
		var serviceList=[];
		var startDate, endDate, coreKeyword, svc, svc12, keywords, fullSvc, fullSvc12, userStr, busiStr, deptStr;
		function clearData() {
			startDate = '';
			endDate = '';
			coreKeyword = '';
			svc = '';
			svc12 = '';
			keywords = '';
			fullSvc = '';
			fullSvc12 = '';

			grid2.initData();
			grid3.initData();
			grid4.initData();


			$('#keywordSearchText').text('');
			$('#messageSearchText').text('');
			$('#svcSearchText').text('');
		}
		$(document).ready(function () {
			initDateTimePicker('startdate', 'enddate');
			getServiceList();
			initCondition();

			$('#user').click(function () {
				var code = $(this).attr('id');
				openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val(), $('#' + code + 'Dept').val(), $('#' + code + 'Jib').val());
			});

			$('#dept').click(function () {
				var code = $(this).attr('id');
				openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
			});


			$('#dateYesterday').click(function () {
				$('#startdate').val(addDay(-1));
				$('#enddate').val(addDay(-1));
			});

			$('#dateToday').click(function (e) {
				$('#startdate').val(addDay(0));
				$('#enddate').val(addDay(0));
			});

			$('#dateWeek').click(function () {
				$('#startdate').val(addDay(-7));
				$('#enddate').val(addDay(0));
			});

			$('#dateMonth').click(function () {
				$('#startdate').val(addMonth2(-1));
				$('#enddate').val(addDay(0));
			});

			$('#coreKeyword').click(function () {
				var code = $(this).attr('id');
				openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
			});

			$('#clearBtn').click(function () {
				$('#startdate').val(new Date().format('yyyy-mm-dd'));
				$('#enddate').val(new Date().format('yyyy-mm-dd'));
				$('#coreKeywordStr').val('');
				$('#coreKeywordVal').val('');
				$('#coreKeywordSelectedArea').find('.btn').text(0);

				$('#deptVal, #deptStr').val('');
				$('#deptSelectedArea').find('.btn').text(0);

				$('#userVal, #userStr, #userDept, #userJib').val('');
				$('#userSelectedArea').find('.btn').text(0);

				$('#busiSelect').selectpicker('val', '');

				clearData();
			});


			$('.codeSelectedBtn').click(function () {
				$('#coreKeywordStr').val('');
				$('#coreKeywordVal').val('');
				$('#coreKeywordSelectedArea').find('.btn').text(0);
			})

			$('#searchBtn').click(function () {
				getData('Y');
			});

			$('#svcRemoveBtn').click(function () {
				getDetailService('');
				grid3.initData();
				$('#keywordSearchText').text('');
				grid4.initData();
				$('#messageSearchText').text('');
			});

			$('#keywordRemoveBtn').click(function () {
				if($('#keywordSearchText').text('') != ''){
					getServiceKeyword('');
					grid4.initData();
					$('#messageSearchText').text('');
				}
			});

			$('#messagePanelRemoveBtn').click(function () {
				if($('#messageSearchText').text() != ''){
					getDetailData('');
				}
			});

		});

		$(document).on('click', '#deptSelectedArea', function (e) {
			$('#deptVal, #deptStr').val('');
			$('#deptSelectedArea').find('.btn').text(0);
		});

		$(document).on('click', '#userSelectedArea', function (e) {
			$('#userVal, #userStr, #userDept, #userJib').val('');
			$('#userSelectedArea').find('.btn').text(0);
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

		function getSelectOption(data) {
			var str = '';
			for (var i = 0; i < data.length; i++) {
				str += '<option value="' + data[i].code + '">' + data[i].codeName + '</option>';
			}
			return str;
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


		function getServiceList(){
			ui.get({
				url : 'getServiceListByAll.xcn',
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

		function getDetailData(keyword) {
			if (searchFlag) return;

			var svc = $('#keywordSearchSvcVal').val();
			var svc12 = $('#keywordSearchSvc12Val').val();
			var searchSvc = svc != '' ? svc : fullSvc;
			var searchSvc12 = svc12 != '' ? svc12 : fullSvc12;

			var searchKeywords = keyword != '' ? keyword : keywords;

			searchFlag = true;
			grid4.on();
			ui.get({
				url: 'getServiceKeywordDtail.xcn',
				startDate: startDate + "000000",
				endDate: endDate + "235959",
				keyword: searchKeywords,
				svc : searchSvc,
				svc12:searchSvc12,
				busiStr: busiStr,
				deptStr: deptStr,
				userStr: userStr,
				success: function (data, total) {
					var serviceNm = getSvcNm(svc12);
					$('#messageSearchText').text('<s:message code="filterInfo.service"/>: ' + getTruncateSearchText( serviceList.search(svc, 'groupCd', 'groupNm')) + " > " + '<s:message code="condition.info.detail"/> <s:message code="filterInfo.service"/> : ' + getTruncateSearchText(serviceNm) + " > " + '<s:message code="DATA_ANALYSIS.STAT_WORD_KEYWORD"/> : ' + getTruncateSearchText(keyword));
					grid4.setData(data.emass);
				},
				error: function (status, message) {
					ui.alertMsg(message);
				},
				complete: function () {
					grid4.off();
					searchFlag = false;
				}
			});
		}

		function getDetailService(svc) {
			if (searchFlag) return;

			var searchSvc = svc != '' ? svc : fullSvc;


			searchFlag = true;
			grid2.on();
			ui.get({
				url: 'getKeywordServiceDetail.xcn',
				startDate: startDate + "000000",
				endDate: endDate + "235959",
				coreKeyword: coreKeyword,
				busiStr: busiStr,
				busiStr: busiStr,
				deptStr: deptStr,
				userStr: userStr,
				deptStr: deptStr,
				userStr: userStr,
				svc: searchSvc,
				success: function (data, total) {
					grid2.setData(data.facet);
					$('#svcSearchText').text('<s:message code="filterInfo.service"/> : ' + getTruncateSearchText( serviceList.search(svc, 'groupCd', 'groupNm')));
					$('#urlSearchHostVal').val(svc);
					fullSvc12 = data.facetHeader.join(',');
					$('#svcSearchVal').val(svc);
				},
				error: function (status, message) {
					ui.alertMsg(message);
				},
				complete: function () {
					searchFlag = false;
					grid2.off();
				}
			});
		}

		function getServiceKeyword(svc12) {
			if (searchFlag) return;

			var svc = $('#svcSearchVal').val();
			var searchSvc = svc != '' ? svc : fullSvc;
			var searchSvc12 = svc12 != '' ? svc12 : fullSvc12;

			searchFlag = true;
			grid3.on();
			ui.get({
				url: 'getServiceKeyword.xcn',
				startDate: startDate + "000000",
				endDate: endDate + "235959",
				coreKeyword: coreKeyword,
				busiStr: busiStr,
				deptStr: deptStr,
				userStr: userStr,
				svc : searchSvc,
				svc12: searchSvc12,
				success: function (data, total) {
					var keyword = data.facet.filter(obj =>  coreKeyword.split(',').includes(obj.name));
					if (coreKeyword == '')  keyword = data.facet.filter(obj => data.pivotHeader[0].split(',').includes(obj.name));
					grid3.setData(keyword);
					var serviceNm = getSvcNm(svc12);
					$('#keywordSearchText').text('<s:message code="filterInfo.service"/> : ' + getTruncateSearchText(serviceList.search(svc, 'groupCd', 'groupNm')) + " > " + '<s:message code="condition.info.detail"/> <s:message code="filterInfo.service"/> : ' + getTruncateSearchText(serviceNm));
					$('#keywordSearchSvcVal').val(svc);
					$('#keywordSearchSvc12Val').val(svc12);
					},
				error: function (status, message) {
					ui.alertMsg(message);
				},
				complete: function () {
					searchFlag = false;
					grid3.off();
				}
			});
		}

		//Depth 디스플레이
		function depthDisplay(val) {
			if (val == 'Y') $("button[name='depthDisplay']").css('visibility', '');
			else $("button[name='depthDisplay']").css('visibility', 'hidden');
		}

		//Close 디스플레이
		function closeDisplay(val) {
			if (val == 'Y') $("button[name='closeDisplay']").css('visibility', '');
			else $("button[name='closeDisplay']").css('visibility', 'hidden');
		}


		function getData(flag) {
			clearData();

			if (searchFlag) return;
			coreKeyword =  $('#coreKeywordStr').val().split(',').map(str => $.trim(str)).join();
			keywords = coreKeyword;
			startDate = $('#startdate').val().replaceAll("-", "");
			endDate = $('#enddate').val().replaceAll("-", "");
			if (startDate > endDate) {
				ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
				return;
			}

			busiStr = arrayToString($('#busiSelect').selectpicker('val'));
			deptStr = $('#deptVal').val().split('|').join(",");
			userStr = $('#userVal').val().split('|').join(",");
			searchFlag = true;

			grid1.on();
			ui.get({
				url: 'getKeywordService.xcn',
				startDate: startDate + "000000",
				endDate: endDate + "235959",
				coreKeyword: coreKeyword,
				busiStr: busiStr,
				deptStr: deptStr,
				userStr: userStr,
				success: function (data, total) {
					 grid1.setData(data.facet);
					depthDisplay('Y');
					closeDisplay('Y');

					svc = data.facetHeader.join(',');
					fullSvc = svc;

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

		function  getSvcNm(svc12){
			var serviceNm = serviceList.find(function(item) {
				return item.serviceCd == svc12;
			})?.serviceNm || '<s:message code="DATA_ANALYSIS.STAT_WORD_ALL"/>';

			return serviceNm;
		}


		function getTruncateSearchText(str) {
			if(str == '' || str == null){
				return '<s:message code="DATA_ANALYSIS.STAT_WORD_ALL"/>'
			} else {
				if (str.length > 40) {
					return str.substring(0, 40) + '...';
				} else {
					return str;
				}
			}
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

		function getSelectedCodeData(codeType, data) {
			var str = '';
			var val = '';
			for (var i = 0; i < data.length; i++) {
				str += data[i].codeName;
				val += data[i].code;

				if (i != data.length - 1) {
					str += ', ';
					val += '|';
				}
			}
			if (val != '') {
				str = str.rtrim();
				val = val.trimAll();
			}
			$('#' + codeType + 'Str').val(str);
			$('#' + codeType + 'Val').val(val);

			if ($('#' + codeType + 'Str').val() != '') {
				$('#' + codeType + 'SelectedArea').find('.btn').text(data.length);
				$('#' + codeType + 'SelectedArea').show();
			} else {
				$('#' + codeType + 'SelectedArea').find('.btn').text(0);
				$('#' + codeType + 'SelectedArea').hide();
			}
		}

	</script>
</head>
<body class="mini-navbar">
<div>
	<div class="searchArea">
		<div class="searchSub" style="width:auto;">
			<div class="searchSub_Box">
				<div id="startDatePicker"><input type="text" class="txt_center" id="startdate" name='startdate' style="width: 110px;">
					<span class="hyphen">~</span></div>
				<div id="endDatePicker"><input type="text" class="txt_center" id="enddate" name='enddate' style="width: 110px;"></div>
				<div class="form-group optiotab">
					<button type="button" id="dateYesterday" accesskey="Y" style="width:85px;"><s:message code="condition.yesterday"/></button>
					<button type="button" id="dateToday" accesskey="T" style="width:85px;"><s:message code="condition.today"/></button>
					<button type="button" id="dateWeek" accesskey="W"><s:message code="condition.week" arguments="1" argumentSeparator="|"/></button>
					<button type="button" id="dateMonth" accesskey="M"><s:message code="condition.month" arguments="1" argumentSeparator="|"/></button>
				</div>
			</div>
			<button class="btn01" id="coreKeyword">
				<img src="<c:url value="/img/subBtn_plus.png"/>"><s:message code="keyword.msg.coreKeyword"/>
			</button>
			<span id="coreKeywordSelectedArea" class="codeSelectedBtn">
					<button type="button" class="btn num_add bornone" style="z-index: 2">0</button>
				</span>
			<input type="hidden" id="coreKeywordVal"/>
			<div class="form-group">
				<label for="coreKeywordStr"></label>
				<div class='input-group'>
					<input type="text" id="coreKeywordStr" name="title" class="input-sm form-control" style="width: 300px; " readonly="readonly"/>
				</div>
			</div>
			<button class="form_btn01" id="searchBtn"><s:message code="common.msg.search"/></button>
			<button class="form_btn02" id="clearBtn"><s:message code="condition.reset"/></button>
		</div>
		<div class="searchSub w100">
			<div>
				<select id="busiSelect" class="selectpicker col-xs" data-style="btn-default btn-sm" multiple data-show-subtext="true" data-actions-box="true"></select>
			</div>
			<button class="btn01" id="dept"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
					code="common.org.choose.dept"/></button>
			<span id="deptSelectedArea" class="codeSelectedBtn">
				<button type="button" class="btn num_add bornone" style="z-index: 2;">0</button>
			</span>
			<input type="hidden" id="deptStr" class="selectedTitle">
			<input type="hidden" id="deptVal">

			<button class="btn01" id="user"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message code="common.org.choose.user"/></button>
			<span id="userSelectedArea" class="codeSelectedBtn">
				<button type="button" class="btn num_add bornone" style="z-index: 2;">0</button>
			</span>
			<input type="hidden" id="userStr" class="selectedTitle">
			<input type="hidden" id="userVal">
			<input type="hidden" id="userDept">
			<input type="hidden" id="userJib">
		</div>
		<div class="searchSub w100">
			<div>
				<b style="margin-left: 10px; padding-left: 10px;font-size: 12px;"><s:message code="DATA_ANALYSIS.STAT_HOST_INFO"/> </b>
			</div>
		</div>

		<div class="content">
			<%-- contentSub --%>
			<div class="contentSub" style="padding:14px 0 14px 0;">
				<div class="col-lg-12">
					<%-- 서비스 분류 --%>
					<div class="col-lg-4">
						<div class="headerLine">
							<h3><s:message code="filterInfo.service"/> </h3>
						</div>
						<div class="inner_personaldata p12">
							<div id="basicStatList" class="tab-pane fade in active">
								<div id="basicStatListGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px;  min-height: 280px;max-height: calc(100vh - 800px);"></div>
							</div>
						</div>
					</div>
					<%-- 서비스 상세 20 --%>
					<div class="col-lg-4">
						<div class="headerLine">
							<h3><s:message code="condition.info.detail"/> <s:message code="filterInfo.service"/> TOP 20
								<button class="btn btn-sm btn-default" name="depthDisplay" style="margin-left: 10px; visibility: hidden">
									<span id="svcSearchText" style="display: inline-block;"></span>
								</button>
								<button class="btn btn-sm btn-default glyphicon glyphicon-remove" id="svcRemoveBtn" style="height: 26px;margin-top:-2px; visibility: hidden" name="closeDisplay"/>
								<input type="hidden" id="svcSearchVal" />
							</h3>
						</div>
						<div class="inner_personaldata p12">
							<div id="urlList" class="tab-pane fade in active">
								<div id="urlListGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; min-height: 280px;max-height: calc(100vh - 800px);"></div>
							</div>
						</div>
					</div>
					<%-- 키워드 상세 TOP 20 --%>
					<div class="col-lg-4">
						<div class="headerLine">
							<h3><s:message code="DATA_ANALYSIS.STAT_WORD_KEYWORD"/> TOP 20
								<button class="btn btn-sm btn-default" name="depthDisplay" style="margin-left: 10px; visibility: hidden">
									<span id="keywordSearchText" style="display: inline-block;"></span>
								</button>
								<button class="btn btn-sm btn-default glyphicon glyphicon-remove" id="keywordRemoveBtn" style="height: 26px;margin-top:-2px; visibility: hidden" name="closeDisplay"/>
								<input type="hidden" id="keywordSearchSvcVal" />
								<input type="hidden" id="keywordSearchSvc12Val" />
							</h3>
						</div>
						<div class="inner_personaldata p12">
							<div id="keywordList" class="tab-pane fade in active">
								<div id="keywordGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; min-height: 280px;max-height: calc(100vh - 800px);"></div>
							</div>
						</div>
					</div>
					<%-- 키워드 상세 검색 --%>
					<div class="col-lg-12" style="margin-top: 12px;">
						<div class="headerLine">
							<h3><s:message code="DATA_ANALYSIS.STAT_KEYWORD_DETAIL_TOP"/> 20
								<button class="btn btn-sm btn-default" name="depthDisplay" style="margin-left: 10px; visibility: hidden">
									<span id="messageSearchText" style="display: inline-block;"></span>
								</button>
								<button class="btn btn-sm btn-default glyphicon glyphicon-remove" id="messagePanelRemoveBtn" style="height: 26px;margin-top:-2px; visibility: hidden" name="closeDisplay"/>
							</h3>
						</div>
						<div class="inner_personaldata p12">
							<div id="messageList" class="tab-pane fade in active">
								<div id="messageListGrid" class="slickGrid gridArea lastArea"></div>
							</div>
						</div>
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
</body>
<script type="text/javascript">
	// 서비스 분류
	var grid1 = new Xgrid('basicStatListGrid', contextRoot);
	grid1.autoNumber();
	grid1.colAdd("name", '<s:message code="filterInfo.service"/>', 150, "center", false, 'link', function (row, cell, value, columnDef, dataContext) {
		return serviceList.search(value, 'groupCd', 'groupNm');
	});
	grid1.colAdd("name2", '<s:message code="common.collect.count"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return value.comma() + "<s:message code="selectCodeAll.items"/>";
	});

	grid1.colAdd("count", '<s:message code="common.core.keyword"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return value.comma() + "<s:message code="selectCodeAll.items"/>";
	});

	grid1.colAdd("count2", '<s:message code="common.keyword.core.keyword.rate"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		let percentage = value * 100;
		return percentage.toFixed(2) + "%";
	});
	grid1.loadHeader(false);
	grid1.initData('<s:message code="common.msg.search.click"/>');
	grid1.onClick = function () {
		var count = grid1.getValue(grid1.Row,'count');
		if (count == 0) return;
		svc = grid1.getValue(grid1.Row, 'name');
		grid3.initData();
		grid4.initData();
		$('#keywordSearchText').text('');
		$('#messageSearchText').text('');
		getDetailService(svc);
	}
	grid1.loadExportMenu('<s:message code="DATA_STAT.STAT_KEYWORDSERVICE"/> - <s:message code="condition.service"/>');

	// 상세 서비스 top 20
	var grid2 = new Xgrid('urlListGrid', contextRoot);
	grid2.autoNumber();
	grid2.colAdd("name2", '<s:message code="filterInfo.service"/>', 230, "left", false, 'link', function (row, cell, value, columnDef, dataContext) {
		return getSvcNm(value);
	});
	grid2.colAdd("count", '<s:message code="bodyview.total"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return value;
	});
	grid2.loadHeader(false);

	grid2.initData('<s:message code="common.msg.search.click"/>');
	grid2.loadExportMenu('<s:message code="DATA_STAT.STAT_KEYWORDSERVICE"/> - <s:message code="condition.info.detail"/> <s:message code="condition.service"/> TOP 20');
	grid2.onClick = function () {
		var count = grid1.getValue(grid1.Row,'count');
		if (count == 0) return;
		svc12 = grid2.getValue(grid2.Row,'name2');
		grid4.initData();
		$('#messageSearchText').text('');
		getServiceKeyword(svc12);
	};

	var grid3 = new Xgrid('keywordGrid', contextRoot);
	grid3.autoNumber();
	grid3.colAdd("name", '<s:message code="DATA_ANALYSIS.STAT_WORD_KEYWORD"/>', 230, "left", false, 'link', function (row, cell, value, columnDef, dataContext) {
		return value;
	});
	grid3.colAdd("count", '<s:message code="bodyview.total"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return value;
	});
	grid3.loadHeader(false);
	grid3.loadExportMenu('<s:message code="DATA_STAT.STAT_KEYWORDSERVICE"/> - <s:message code="DATA_ANALYSIS.STAT_WORD_KEYWORD"/> TOP 20');
	grid3.initData('<s:message code="common.msg.search.click"/>');
	grid3.onClick = function () {
		keyword = grid3.getValue(grid3.Row, 'name');
		getDetailData(keyword);
	};

	var grid4 = new Xgrid('messageListGrid', contextRoot, 26, {commonId: 'selectTotalList', status_cnt_id: '#messageCnt', more_btn: 'slick_grid_more_btn'});
	grid4.autoNumber();
	grid4.colAdd("detectionKeywordType", '<s:message code="common.keyword.pos"/>', 230, "left", false, 'normal');
	grid4.colAdd("detectionKeywordText", '<s:message code="common.keyword.content"/>', 230, "left", false, 'normal', function (row, cell, value) {
		if (value.length > 1024) value = value.substring(0, 1024) + '...';
		value = value.replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
		var kwds = (grid3.getSelectedRows().length > 0) ? grid3.getValue(grid3.Row, 'name') : $('#coreKeywordStr').val();
		kwds = kwds.split(',');
		kwds = kwds.map(function (kwd) {
			return kwd.trim();
		});
		value = detectHighlightKeyword(value, kwds);
		value = highlightSearchStr(value, "subject");
		return value;
	});
	grid4.loadExportMenu('<s:message code="DATA_STAT.STAT_KEYWORDSERVICE"/> - <s:message code="DATA_ANALYSIS.STAT_KEYWORD_DETAIL_TOP"/> 20');
	grid4.loadHeader(false);
	// grid4.loadPageSize();
	initGrid(grid4, messageGridColumn);
	grid4.initData('<s:message code="common.msg.search.click"/>');


	function detectHighlightKeyword(rtnVal, keyWords) {
		var rtnValue = '';
		try {
			var obj = $.parseHTML('<div>' + rtnVal + '</div>');
			for (var i = 0; i < keyWords.length; i++) {
				var keyWord = keyWords[i];
				$(obj).highlight(keyWord, 'K');
			}
			rtnValue = $(obj).html();
		} catch (e) {
			rtnValue = rtnVal;
			console.log("highlightKeyword Error..");
		}

		return rtnValue;
	}

	/*
 * Grid 관련 함수
 */
	function viewer_open(row, bodySize) {
		var msgid = grid4.getValue(row, 'msgid');
		openMessageBodyPop(grid4.id, msgid, '', bodySize);
		grid4.setValue(row, 'readYn', 'Y');
		grid4.Select(row, 0);
	}

	function viewer_newOpen(row, bodySize) {
		var msgid = grid4.getValue(row, 'msgid');
		openMessageBodyPop(grid4.id, msgid, "");
		grid4.setValue(row, 'readYn', 'Y');
	}

	function prevMsg() {
		var row = 0;
		if (grid4.Row > 0) {
			row = --grid4.Row;
			viewer_open(row);
			grid4.Select(row, 0);
			return true;
		}
		return false;
	}

	function nextMsg() {
		var row = 0;
		if (grid4.Row < grid4.Rows - 1) {
			row = ++grid4.Row;
			viewer_open(row);
			grid4.Select(row, 0);
			if (grid4.Row == grid4.Rows - 2) {
				getDetailData(true);
			}
			return true;
		}
		return false;
	}



</script>
