<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>
<style type="text/css">
	.panel-heading .dropdown-menu {
		right: 31px;
		top: 42px;
		left: initial;
	}

	.highlightSearch {
		background-color: #13C7A3;
	}

	.highlightKeyword {
		background-color: #FFAD5B;
	}
</style>
<script>
	var searchFlag = false;
	var totalCount = 0;
	var totalKeywordCount = 0;
	var rowKey = "";
	var rowName = "";
	var detailTab = "N";
	var chartcnt = 5;
	var currentGrid;
	var tabID = 1;
	var tabNum = 0;
	var totalChartDat
	$(document).ready(function () {

		depthDisplay('N');
		closeDisplay('N');

		$('#searchBtn').click(function () {
			getData('Y');
		});

		$('#chartCntDiv .dropdown-menu li a').click(function () {
			chartcnt = $(this).text();
			printChart(totalChartDat);
		});

		initDateTimePicker('startdate', 'enddate');

		$(".nav-tabs").on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
			var id = $(this).parents('li').attr('idx');
			var hrefNm = $(this).attr('href');
			if (hrefNm == '#basicStatList') {
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

		$('.print_stat').click(function () {
			var gridDetail = getCurrentGrid();
			if (gridDetail != undefined) {
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

		$('.excel_stat').click(function () {
			var gridDetail = getCurrentGrid();
			if (gridDetail != undefined) {
				excelDownLoad(gridDetail, '<s:message code="stat.detail.user.list"/>');
			} else {
				chart = $('#chartArea1').highcharts();
				var svg = chart.getSVG();
				excelDownLoad(grid1, '<s:message code="DATA_MONITOR.STAT_USER"/>', svg);
			}
		});

		$('.cell_stat').click(function () {
			var gridDetail = getCurrentGrid();
			if (gridDetail != undefined) {
				cellDownLoad(gridDetail, '<s:message code="stat.detail.user.list"/>');
			} else {
				cellDownLoad(grid1, '<s:message code="DATA_MONITOR.STAT_USER"/>');
			}
		});

		$('.pdf_stat').click(function () {
			var gridDetail = getCurrentGrid();
			if (gridDetail != undefined) {
				pdfDownLoad(gridDetail, '<s:message code="stat.detail.user.list"/>');
			} else {
				pdfDownLoad(grid1, '<s:message code="DATA_MONITOR.STAT_USER"/>');
			}
		});

		$('.csv_stat').click(function () {
			var gridDetail = getCurrentGrid();
			if (gridDetail != undefined) {
				csvDownLoad(gridDetail, '<s:message code="stat.detail.user.list"/>');
			} else {
				csvDownLoad(grid1, '<s:message code="DATA_MONITOR.STAT_USER"/>');
			}
		});

		$('.totalView').click(function () {
			$("#chartCntDiv").show();
			$('#totalViewDiv').hide();
			printChart(totalChartDat);
		});

		$('#coreKeyword').click(function () {
			var code = $(this).attr('id');
			openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
		});


		// URL 취소 버튼
		$('#urlRemoveBtn').click(function () {
			getData('Y');
		});

		// 키워드 취소 버튼
		$('#keywordRemoveBtn').click(function () {
			getKeywordData();
		});

		// 메시지 그리드 취소 버튼
		$('#messagePanelRemoveBtn').click(function () {
			getKeywordData();
		});

	});

	function setGrid() {
		currentgrid = getCurrentGrid();
		initGrid(currentgrid, messageGridColumn);
	}


	/*
	 * Grid 관련 함수
	 */
	function viewer_open(row, bodySize) {
		var msgid = grid4.getValue(row, 'msgid');
		openMessageBodyPop(grid4.id, msgid, '', bodySize);
		grid4.setValue(row, grid4.ColIndex('readYn'), 'Y');
		grid4.Select(row, 0);
	}

	function viewer_newOpen(row, bodySize) {
		var msgid = grid4.getValue(row, 'msgid');
		openMessageBodyPop(grid4.id, msgid, "");
		grid4.setValue(row, grid4.ColIndex('readYn'), 'Y');
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
		console.log("grid.Row = " + grid.Row)
		console.log("grid.Rows = " + grid.Rows)
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


	function excelDownLoad(grid, title, svg) {
		if (grid.Rows == 0) {
			alert('<s:message code="common.msg.nodata"/>');
			return;
		}
		var header = grid.getHeaderEXCEL();
		var body = grid.getBodyEXCEL();
		grid.on();
		ui.postJson({
			url: 'utils/xlsxWriter.do',
			title: title,
			header: header,
			body: body,
			pMenuId: pMenuId,
			menuId: menuId,
			svg: svg,
			success: function (data, total) {
				try {
					ExcelDown.location.href = '<c:url value="/utils/xlsxDown.do"/>?path=' + data;
				} catch (e) {
					ExcelDown.src = '<c:url value="/utils/xlsxDown.do"/>?path=' + data;
				}
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				grid.off();
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
	}

</script>
</head>
<div>
	<div class="searchArea w100">
		<div class="searchSub w100">
			<div>
				<input type="text" id="startdate" class="txt_center" style="width: 110px;"/>
				<span class="hyphen">~</span>
			</div>
			<div>
				<input type="text" id="enddate" class="txt_center" style="width: 110px;"/>
			</div>
		</div>

		<input type="hidden" id="coreKeywordVal">
		<label for="coreKeywordStr"></label>
		<div class='input-group'>
			<input type="text" id="coreKeywordStr" name="title" class="input-sm form-control" style="width: 300px; " readonly="readonly"/>
			<button class="form_btn01" id="searchBtn"><s:message code="common.msg.search"/></button>
		</div>

	</div>
	<div class="searchSub w100">
	</div>
	<div class="content">
		<%-- contentSub --%>
		<div class="contentSub">
			<div class="col-lg-12">
				<%-- HOST TOP --%>
				<div class="col-lg-4">
					<div class="tabpanel" style="padding: 4px 15px;">
						<h3><s:message code="DATA_ANALYSIS.STAT_HOST_TOP"/> 10</h3>
					</div>
					<div style="padding:7px 10px;"></div>
					<div class="inner_personaldata p20">
						<div id="basicStatList" class="tab-pane fade in active">
							<div id="basicStatListGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px;  min-height: 280px;max-height: 480px;"></div>
						</div>
					</div>
				</div>
				<%-- URL TOP --%>
				<div class="col-lg-4">
					<div class="tabpanel" style="padding: 4px 15px;">
						<h3><s:message code="DATA_ANALYSIS.STAT_URL_TOP"/> 20
							<button class="btn btn-sm btn-default" name="depthDisplay" style="margin-left: 20px;">
								<span id="urlSearchText"></span>
							</button>
							<button class="btn btn-sm btn-default glyphicon glyphicon-remove" id="urlRemoveBtn" style="height: 29px;" name="closeDisplay"/>
						</h3>
					</div>
					<div class="inner_personaldata p20">
						<div id="urlList" class="tab-pane fade in active">
							<div id="urlListGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; min-height: 280px;max-height: 480px;"></div>
						</div>
					</div>
				</div>
				<%-- KEYWORD TOP --%>
				<div class="col-lg-4">
					<div class="tabpanel" style="padding: 4px 15px;">
						<h3><s:message code="DATA_ANALYSIS.STAT_KEYWORD_TOP"/> 20
							<button class="btn btn-sm btn-default" name="depthDisplay" style="margin-left: 20px;">
								<span id="keywordSearchText"></span>
							</button>
							<button class="btn btn-sm btn-default glyphicon glyphicon-remove" id="keywordRemoveBtn" style="height: 29px;" name="closeDisplay"/>
						</h3>
					</div>
					<div class="inner_personaldata p20">
						<div id="keywordList" class="tab-pane fade in active">
							<div id="keywordGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; min-height: 280px;max-height: 480px;"></div>
						</div>
					</div>
				</div>
			</div>
			<%-- 키워드 상세 검색 --%>
			<div class="col-lg-12 tab-content">
				<div id="messagePanel" style="padding: 0;">
					<div class="panel-heading" style="padding: 4px 15px;">
						<h3><s:message code="DATA_ANALYSIS.STAT_KEYWORD_DETAIL_TOP"/> 20
							<button class="btn btn-sm btn-default" name="depthDisplay" style="margin-left: 20px;">
								<span id="messageSearchText"></span>
							</button>
							<button class="btn btn-sm btn-default glyphicon glyphicon-remove" id="messagePanelRemoveBtn" style="height: 29px;" name="closeDisplay"/>
						</h3>
					</div>
					<div class="panel-body">
						<div id="messageList" class="inner_personaldata tab-pane fade in active">
							<div id="messageListGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; height: 400px"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>


<!-- Back to top -->
<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>

<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"></input>
	<input type="hidden" name="oldConm" id="oldConm"></input>
</form>

<script type="text/javascript">
	function getCurrentGrid() {
		var id = Number($('.listChart .active').attr('idx'));
		return tabInfo['tab' + id];
	}

	/* HOST TOP */
	var grid1 = new Xgrid('basicStatListGrid', contextRoot);
	grid1.autoNumber();
	// host
	grid1.colAdd("name", '<s:message code="DATA_ANALYSIS.STAT_WORD_HOST"/>', 230, "left", false, 'link');

	// 수집 건수
	grid1.colAdd("name2", '<s:message code="common.collect.count"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return value.comma() + "<s:message code="selectCodeAll.items"/>";
	});
	// 핵심 키워드 검출 건 수
	grid1.colAdd("count", '<s:message code="common.core.keyword"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return value.comma() + "<s:message code="selectCodeAll.items"/>";
	});
	// 핵심 키워드 검출 비율
	grid1.colAdd("coreKeywordRate", '<s:message code="common.keyword.core.keyword.rate"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		let count = grid1.getValue(row, 'name2'); //수집 건수
		let keywordCount = grid1.getValue(row, 'count'); // 키워드 검출 건수
		let percentage = (keywordCount / count) * 100;
		return percentage.toFixed(2) + "%";
	});
	grid1.loadHeader(false);
	grid1.initData('<s:message code="common.msg.search.click"/>');
	grid1.onClick = function () {
		host = grid1.getValue(grid1.Row, 'name')
		getUrlData(host);
	};


	/* URL TOP */
	var grid2 = new Xgrid('urlListGrid', contextRoot);
	grid2.autoNumber();
	grid2.colAdd("name", 'URL', 230, "left", false, 'link');
	grid2.colAdd("count", '<s:message code="bodyview.total"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return value.comma() + "<s:message code="selectCodeAll.items"/>";
	});
	grid2.loadHeader(false);
	// grid2.loadPageSize();
	grid2.initData('<s:message code="common.msg.search.click"/>');
	grid2.onClick = function () {
		if (grid1.getSelectedRows().length > 0) host = grid1.getValue(grid1.Row, 'name');
		path = grid2.getValue(grid2.Row, 'name');
		getKeywordData(host, path);
	};

	/* 키워드 TOP */
	var grid3 = new Xgrid('keywordGrid', contextRoot);
	grid3.autoNumber();
	grid3.colAdd("name", '키워드', 230, "left", false, 'link');
	grid3.colAdd("count", '<s:message code="bodyview.total"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
		return value.comma() + "<s:message code="selectCodeAll.items"/>";
	});
	grid3.loadHeader(false);
	//	grid3.loadPageSize();
	grid3.initData('<s:message code="common.msg.search.click"/>');
	grid3.onClick = function () {
		// HOST
		if (grid1.getSelectedRows().length > 0) host = grid1.getValue(grid1.Row, 'name');

		// URL
		if (grid2.getSelectedRows().length > 0) {
			path = grid2.getValue(grid2.Row, 'name');
		} else {
			getUrlPaths(host)
			path = paths;
		}
		keyword = grid3.getValue(grid3.Row, 'name');
		getDetailData(host, path, keyword);

	};


	/* 키워드 상세 */
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
	grid4.loadHeader(false);
	// grid4.loadPageSize();
	grid4.changePageSize = function (cnt) {
		getKeywordData('Y');
	};
	initGrid(grid4, messageGridColumn);
	grid4.initData('<s:message code="common.msg.search.click"/>');

	function doSelected(targetGrid, selectedRow) {
		if (targetGrid.Row != selectedRow) {
			return true;
		} else {
			targetGrid.setSelectedRows([]);
			targetGrid.grid.resetActiveCell();
			selectedRow = -1;
			return false;
		}
	}


	var startDate, endDate, coreKeyword, hosts, host, paths, path, keywords, keyword, fullHosts, searchedPaths;

	function clearData() {
		hosts = '';
		host = '';
		paths = '';
		path = '';
		keywords = '';
		keyword = '';
		fullHosts = '';
		searchedPaths = '';
	}

	//HOST TOP
	function getData(flag) {
		clearData();
		if (searchFlag) return;

		coreKeyword = $('#coreKeywordStr').val();
		// 공백제거
		coreKeyword = coreKeyword.split(',').map(str => $.trim(str)).join();
		keywords = coreKeyword;
		startDate = $('#startdate').val().replaceAll("-", "");
		endDate = $('#enddate').val().replaceAll("-", "");
		if (startDate > endDate) {
			ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
			return;
		}
		if (coreKeyword == '') {
			openCodeWindow('coreKeyword', $('#' + 'coreKeyword' + 'Val').val(), $('#' + 'coreKeyword' + 'Str').val());
			return;
		}

		searchFlag = true;
		grid1.on();
		ui.get({
			url: 'getKeywordHost.xcn',
			startDate: startDate + "000000",
			endDate: endDate + "235959",
			coreKeyword: coreKeyword,
			offset: grid1.data.length,
			limit: grid1.pageSize,
			success: function (data, total) {
				totalCount = total;
				totalKeywordCount = data.numFound;
				grid1.setData(data.facet);
				hosts = data.facetHeader.join(',');
				fullHosts = hosts;
				getUrlData();
				depthDisplay('Y');
				closeDisplay('Y');
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

	//URL  TOP
	function getUrlData(host) {
		var searchHosts = (host != '' && host != null) ? host : hosts;
		grid2.on();
		ui.get({
			url: 'getKeywordUrl.xcn',
			startDate: startDate + "000000",
			endDate: endDate + "235959",
			coreKeyword: coreKeyword,
			hosts: searchHosts,
			offset: grid2.data.length,
			limit: grid2.pageSize,
			success: function (data, total) {
				grid2.setData(data.facet);
				paths = data.facetHeader.join('@XCNJOIN@');
				$('#urlSearchText').text('<s:message code="DATA_ANALYSIS.STAT_WORD_HOST"/> : ' + getTruncateSearchText(searchHosts));
				searchedPaths = paths;
				getKeywordData(searchHosts, searchedPaths);
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				grid2.off();
			}
		});
	}

	// 임시
	function getUrlPaths(host) {
		var searchHosts = (host != '' && host != null) ? host : hosts;
		grid2.on();
		ui.get({
			url: 'getKeywordUrl.xcn',
			startDate: startDate + "000000",
			endDate: endDate + "235959",
			coreKeyword: coreKeyword,
			hosts: searchHosts,
			offset: grid2.data.length,
			limit: grid2.pageSize,
			success: function (data, total) {
				paths = data.facetHeader.join('@XCNJOIN@');
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				grid2.off();
			}
		});
	}

	//키워드 TOP
	function getKeywordData(host, path) {
		var searchHosts = (host != '' && host != null) ? host : fullHosts;
		var searchPaths = (path != '' && path != null) ? path : searchedPaths;
		grid3.on();
		ui.get({
			url: 'getKeywordDetail.xcn',
			startDate: startDate + "000000",
			endDate: endDate + "235959",
			coreKeyword: coreKeyword,
			hosts: searchHosts,
			paths: searchPaths,
			success: function (data, total) {
				var keywords = data.facet.filter(obj => coreKeyword.split(',').includes(obj.name));
				grid3.setData(keywords);
				$('#keywordSearchText').text('<s:message code="DATA_ANALYSIS.STAT_WORD_HOST"/> : ' + getTruncateSearchText(searchHosts) + " > " + '<s:message code="DATA_ANALYSIS.STAT_WORD_URL"/> : ' + getTruncateSearchText(searchPaths));
				var kwds = '';
				if (keywords != '' && keywords.length > 0) {
					kwds = keywords.map(obj => obj.name).join(',');
				}
				getDetailData(searchHosts, searchPaths, kwds); // 키워드 상세
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				grid3.off();
			}
		});
	}

	function getDetailData(host, path, keyword) {
		var searchHosts = (host != '' && host != null) ? host : hosts;
		var searchPaths = (path != '' && path != null) ? path : paths;
		var searchKeywords = (keyword != '' && keyword != null) ? keyword : keywords;

		grid4.on();
		ui.get({
			url: 'getKeywordDetailData.xcn',
			startDate: startDate + "000000",
			endDate: endDate + "235959",
			coreKeyword: searchKeywords,
			hosts: searchHosts,
			paths: searchPaths,
			success: function (data, total) {
				$('#messageSearchText').text('<s:message code="DATA_ANALYSIS.STAT_WORD_HOST"/> : ' + getTruncateSearchText(searchHosts) + " > " + '<s:message code="DATA_ANALYSIS.STAT_WORD_URL"/> : ' + getTruncateSearchText(searchPaths) + " > " + '<s:message code="DATA_ANALYSIS.STAT_WORD_KEYWORD"/> : ' + getTruncateSearchText(searchKeywords));
				grid4.setData(data.emass);
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				grid3.off();
				grid4.off();
			}
		});
	}

	function getTruncateSearchText(str) {
		if (str.indexOf(',') > -1 || str.indexOf('@XCNJOIN@')) {
			return '<s:message code="DATA_ANALYSIS.STAT_WORD_ALL"/>'
		} else {
			if (str.length > 40) {
				return str.substring(0, 40) + '...';
			} else {
				return str;
			}
		}
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


	jQuery.fn.highlight = function (pat, type) {
		function innerHighlight(node, pat, type) {
			var skip = 0;
			if (node.nodeType == 3) {
				var pos = node.data.toUpperCase().indexOf(pat);
				if (pos >= 0) {
					var spannode = document.createElement('span');
					if (type.indexOf('K') > -1) {
						spannode.className = 'highlightKeyword';
					} else {
						spannode.className = 'highlightSearch';
					}
					if (type.indexOf('B') > -1) {
						if (type.indexOf('K') > -1) {
							spannode.style.backgroundColor = '#FFAD5B';
							spannode.style.color = '#000000';
							spannode.style.fontWeight = 'bold';
						} else {
							spannode.style.backgroundColor = '#13C7A3';
							spannode.style.color = '#000000';
							spannode.style.fontWeight = 'bold';
						}
					}

					var sbit = node.splitText(pos);
					sbit.splitText(pat.length);
					spannode.nodeValue = sbit.data;
					var sbitclone = sbit.cloneNode(true);
					spannode.appendChild(sbitclone);
					sbit.parentNode.replaceChild(spannode, sbit);
					skip = 1;
				}
			} else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
				for (var i = 0; i < node.childNodes.length; ++i) {
					i += innerHighlight(node.childNodes[i], pat, type);
				}
			}
			return skip;
		}

		return this.each(function () {
			innerHighlight(this, pat.toUpperCase(), type);
		});
	};
</script>
