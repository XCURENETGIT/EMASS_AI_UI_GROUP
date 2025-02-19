<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>

<!DOCTYPE html>
<html lang="ko">
<head>
<title></title>
<style type="text/css">
	.panel-heading .dropdown-menu {
		right: 31px;
		top: 42px;
		left: initial;
	}

	.headerLine {
		height: 28px;
	}

	.highlightSearch {
		background-color: #13C7A3;
	}

	.highlightKeyword {
		background-color: #FFAD5B;
	}

	.disabled {
		background-color: #e0e0e0;  /* 배경색을 흐리게 설정 */
		color: #a0a0a0;             /* 텍스트 색상도 흐리게 설정 */
		border: 1px solid #ccc;     /* 테두리 색상도 흐리게 설정 */
		cursor: not-allowed;        /* 마우스 커서를 '사용 불가' 모양으로 변경 */
		pointer-events: none;       /* 클릭 및 기타 상호작용 비활성화 */
	}


	.lastArea {
		position: relative;
		top: 0px;
		left: 0px;
		max-height: calc(100vh - 913px);
	}

	@media screen and (max-height: 1200px) {
		.lastArea { position: relative; top: 0px; left: 0px; max-height: calc(20vh + 40px); }
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
		initDateTimePicker('startdate', 'enddate');
		depthDisplay('N');
		closeDisplay('N');

		// 서비스 타입
		initSelectCondition();
		getServiceTypeForHostPage();
		$("#unclsfiedOnly").prop('checked', false);


		$('#unclsfiedOnly').change(function () {
			if (($(this).prop("checked"))) {
				$('#unclsfiedOnly').val('Y');
			}else{
				$('#unclsfiedOnly').val('N');
			}
		});

		$('#chartCntDiv .dropdown-menu li a').click(function () {
			chartcnt = $(this).text();
			printChart(totalChartDat);
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

		$('#searchBtn').click(function () {
			getData('Y');
		});

		$('.codeSelectedBtn').click(function () {
			$('#coreKeywordStr').val('');
			$('#coreKeywordVal').val('');
			$('#coreKeywordSelectedArea').find('.btn').text(0);
		})
		$('#clearBtn').click(function () {
			$('#startdate').val(new Date().format('yyyy-mm-dd'));
			$('#enddate').val(new Date().format('yyyy-mm-dd'));
			$('#coreKeywordStr').val('');
			$('#coreKeywordVal').val('');
			$('#coreKeywordSelectedArea').find('.btn').text(0);
		});

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
			getUrlData('');
			grid3.initData();
			$('#keywordSearchText').text('');
			grid4.initData();
			$('#messageSearchText').text('');
		});

		// 키워드 취소 버튼
		$('#keywordRemoveBtn').click(function () {
			if($('#keywordSearchText').text('') != ''){
				getKeywordData('');
				grid4.initData();
				$('#messageSearchText').text('');
			}
		});

		// 메시지 그리드 취소 버튼
		$('#messagePanelRemoveBtn').click(function () {
			// getKeywordData();
			if($('#messageSearchText').text() != ''){
				getDetailData('');
			}
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

		if ($('#' + codeType + 'Str').val() != '') {
			$('#' + codeType + 'SelectedArea').find('.btn').text(data.length);
			$('#' + codeType + 'SelectedArea').show();
		} else {
			$('#' + codeType + 'SelectedArea').find('.btn').text(0);
			$('#' + codeType + 'SelectedArea').hide();
		}
	}


	/**
	 * 서비스 타입 불러오기
	 * @returns {string}
	 */
	function getServiceTypeForHostPage(){
		var result = '';
		ui.get({
			url : 'getServiceListForHostPage.xcn',
			asyncFlag : false,
			success : function(data, total) {
				serviceTypes = data;
				getServiceGroupList();
			},
			error : function(status, message) {
				ui.alertMsg(message);
			},
			complete : function() {}
		});
		return result;
	}


	/**
	 * 서비스타입 리스트를 불러와서 조건에 적용
	 * @returns
	 */
	var specialService=[];
	var parentCode = [];
	var parentNm = [];
	function getServiceGroupList( ){
		var str = '';
		for (var i = 0; i < serviceTypes.length; i++) {
			if( str.indexOf(serviceTypes[i].groupCd ) == -1){
				str += serviceTypes[i].groupCd + ',';
			}
			if(serviceTypes[i].serviceCd.length == 4) {
				specialService.push(serviceTypes[i]);
			}
		}

		serviceGroups = str.substring(0, str.length-1).split(',');
		var serviceStr = getServiceOptionStr( );
		$('#serviceType').html(serviceStr);
		getServiceOptionLiveSearch(parentCode);
		$('#serviceType').selectpicker('refresh');
	}


	function getServiceOptionStr( ){
		var str = '';
		for (var i = 0; i < serviceGroups.length; i++) {
			var selectedVal = serviceGroups[i];
			var idx = 0;
			for (var j = 0; j < serviceTypes.length; j++) {
				if( selectedVal == serviceTypes[j].groupCd){
					if( idx == 0 ){
						str += '<optgroup label="'+serviceTypes[j].groupNm+'" data-collapsible-optgroup= "true" data-load-collapse-optgroup ="false">';
					}
					if( serviceTypes[j].serviceCd.length == 3){
						str += getServiceOptionChildren(serviceTypes[j]);
					} else if ( serviceTypes[j].serviceCd.length == 4 ) continue;
					else str += '<option value="'+serviceTypes[j].serviceCd+'">'+serviceTypes[j].serviceNm+'</option>';

					idx++;
				}
			}
			if( idx != 0 ) str += '</optgroup>';
		}
		return str;
	}
	function getServiceOptionChildren(serviceType) {
		var result = '<option value="'+serviceType.serviceCd+'">'+serviceType.serviceNm+'</option>';
		for (var i = 0; i < specialService.length; i++) {
			var service = specialService[i];
			if( service.serviceCd.indexOf(serviceType.serviceCd) > -1 ) {
				if(!parentCode.includes(serviceType.serviceCd)) {
					parentCode.push(serviceType.serviceCd);
					parentNm.push(serviceType.serviceNm);
				}
				result += '<option value="'+service.serviceCd+'"> └ '+service.serviceNm+'</option>';
			}
		}

		return result;
	}

	function getServiceOptionLiveSearch(code) {
		var searchWord = "";
		for (var i = 0; i < code.length; i++) {
			var pCode = code[i];
			for(var j = 0; j < specialService.length; j++) {
				if( specialService[j].serviceCd.indexOf(pCode) > -1 ) {
					searchWord += specialService[j].serviceNm + " ";
				}
			}
			searchWord += parentNm[i];
			$('[value=' + pCode + ']').attr('data-tokens', searchWord);
			searchWord = "";
		}

	}

	function initSelectCondition(){
		$('#serviceType').selectpicker({
			size: 'auto',
			width:'260px',
			searchLabel:true,
			collapseExtend:true,
			noneSelectedText:msgCondition.serviceAll,
			noneResultsText:msgCondition.msgNoresult+' ',
			selectAllText:msgCondition.msgSelect_all,
			deselectAllText:msgCondition.msgUnselect_all,
			liveSearchPlaceholder:msgCondition.searchService
		});
	}


	var msgCondition = {
		messageInputFilter:'<s:message code="condition.message.input.filter"/>',
		messageInputPeriod:'<s:message code="condition.message.input.period"/>',
		consentMsgTimecheck:'<s:message code="consent.msg.timecheck"/>',
		messageNumbercheck:'<s:message code="condition.message.numbercheck"/>',
		messageFolderFilter:'<s:message code="condition.message.folder.filter"/>',
		messageSelectFolder:'<s:message code="condition.message.select.folder"/>',
		msgSaved:'<s:message code="common.msg.saved"/>',
		selectInterest:'<s:message code="condition.select.interest"/>',
		interestUserAll:'<s:message code="interest.user.all"/>',
		commonMsgAll:'<s:message code="common.msg.all"/>',
		serviceAll:'<s:message code="condition.service.all"/>',
		orgBusiAll:'<s:message code="common.org.busi.all"/>',
		orgDeptAll:'<s:message code="common.org.dept.all"/>',
		msgSelect_all:'<s:message code="common.msg.select_all"/>',
		msgUnselect_all:'<s:message code="common.msg.unselect_all"/>',
		msgNoresult:'<s:message code="common.msg.noresult"/>',
		msgConnectError:'<s:message code="common.msg.connect.error"/>',
		messageSelectDashboard:'<s:message code="condition.message.select.dashboard"/>',
		msgConfirmSave:'<s:message code="common.msg.confirm.save"/>',
		searchService:'<s:message code="condition.search.service"/>',
		delMsgFolderMsg:'<s:message code="filterInfo.delMsgFolderMsg"/>',
		delMsgFoldercomplMsg:'<s:message code="filterInfo.delMsgFoldercomplMsg"/>',
		userGroupNaviTitle2:'<s:message code="userGroup.navi.title2"/>',
		interestGroup:'<s:message code="condition.interestGroup"/>',
		epmsgTypeAll:'<s:message code="condition.epmsgType.all"/>'
	};


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
				<div>
					<label class="checkbox-inline " style="padding-left: 0px;">
						<input type="checkbox" id="unclsfiedOnly" value="N">
						<s:message code="keyword.svc.condition"/>
					</label>
				</div>
				<div class="form-group" id="serviceTypeDiv">
					<select id="serviceType" title="<s:message code="condition.service.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true"></select>
				</div>
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
					<b style="margin-left: 10px; padding-left: 10px;font-size: 12px;"><s:message code="DATA_ANALYSIS.STAT_HOST_INFO"/> </b>
				</div>
			</div>
			<div class="content">
				<%-- contentSub --%>
				<div class="contentSub" style="padding:14px 0 14px 0;">
					<div class="col-lg-12">
						<%-- HOST TOP --%>
						<div class="col-lg-4">
							<div class="headerLine">
								<h3><s:message code="DATA_ANALYSIS.STAT_HOST_TOP"/> 10</h3>
							</div>
							<div class="inner_personaldata p12">
								<div id="basicStatList" class="tab-pane fade in active">
									<div id="basicStatListGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px;  min-height: 280px;max-height: calc(100vh - 800px);"></div>
								</div>
							</div>
						</div>
						<%-- URL TOP --%>
						<div class="col-lg-4">
							<div class="headerLine">
								<h3>PATH TOP 20
									<button class="btn btn-sm btn-default" name="depthDisplay" style="margin-left: 10px;">
										<span id="urlSearchText" style="display: inline-block;"></span>
									</button>
									<button class="btn btn-sm btn-default glyphicon glyphicon-remove" id="urlRemoveBtn" style="height: 26px;margin-top:-2px;" name="closeDisplay"/>
									<input type="hidden" id="urlSearchHostVal" />
								</h3>
							</div>
							<div class="inner_personaldata p12">
								<div id="urlList" class="tab-pane fade in active">
									<div id="urlListGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; min-height: 280px;max-height: calc(100vh - 800px);"></div>
								</div>
							</div>
						</div>
						<%-- KEYWORD TOP --%>
						<div class="col-lg-4">
							<div class="headerLine">
								<h3><s:message code="DATA_ANALYSIS.STAT_KEYWORD_TOP"/> 20
									<button class="btn btn-sm btn-default" name="depthDisplay" style="margin-left: 10px;">
										<span id="keywordSearchText" style="display: inline-block;"></span>
									</button>
									<button class="btn btn-sm btn-default glyphicon glyphicon-remove" id="keywordRemoveBtn" style="height: 26px;margin-top:-2px;" name="closeDisplay"/>
									<input type="hidden" id="keywordSearchHostVal" />
									<input type="hidden" id="keywordSearchUrlVal" />
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
									<button class="btn btn-sm btn-default" name="depthDisplay" style="margin-left: 10px;">
										<span id="messageSearchText" style="display: inline-block;"></span>
									</button>
									<button class="btn btn-sm btn-default glyphicon glyphicon-remove" id="messagePanelRemoveBtn" style="height: 26px;margin-top:-2px;" name="closeDisplay"/>
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
		grid1.colAdd("count2", '<s:message code="common.keyword.core.keyword.rate"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
			let percentage = value * 100;
			return percentage.toFixed(2) + "%";
		});
		grid1.loadHeader(false);
		grid1.initData('<s:message code="common.msg.search.click"/>');
		grid1.loadExportMenu('<s:message code="DATA_STAT.STAT_KEYWORDHOST"/> - HOST TOP 10');
		grid1.onClick = function () {
			host = grid1.getValue(grid1.Row, 'name');
			getUrlData(host);
			grid3.initData();
			$('#keywordSearchText').text('');
			grid4.initData();
			$('#messageSearchText').text('');
		};

		/* URL TOP */
		var grid2 = new Xgrid('urlListGrid', contextRoot);
		grid2.autoNumber();
		grid2.colAdd("name", 'PATH', 230, "left", false, 'link');
		grid2.colAdd("count", '<s:message code="bodyview.total"/>', 130, "right", false, 'nomal', function (row, cell, value, columnDef, dataContext) {
			return value.comma() + "<s:message code="selectCodeAll.items"/>";
		});
		grid2.loadHeader(false);
		grid2.loadExportMenu('<s:message code="DATA_STAT.STAT_KEYWORDHOST"/> - PATH TOP 20');
		// grid2.loadPageSize();
		grid2.initData('<s:message code="common.msg.search.click"/>');
		grid2.onClick = function () {
			// if (grid1.getSelectedRows().length > 0) host = grid1.getValue(grid1.Row, 'name');
			path = grid2.getValue(grid2.Row, 'name');
			getKeywordData(path);
			grid4.initData();
			$('#messageSearchText').text('');
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
		grid3.loadExportMenu('<s:message code="DATA_STAT.STAT_KEYWORDHOST"/> - <s:message code="DATA_ANALYSIS.STAT_KEYWORD_TOP"/> 20');
		grid3.onClick = function () {
			// HOST
			// if (grid1.getSelectedRows().length > 0) host = grid1.getValue(grid1.Row, 'name');
			//
			// // URL
			// if (grid2.getSelectedRows().length > 0) {
			// 	path = grid2.getValue(grid2.Row, 'name');
			// } else {
			// 	getUrlPaths(host)
			// 	path = paths;
			// }
			keyword = grid3.getValue(grid3.Row, 'name');
			getDetailData(keyword);

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
		grid4.loadExportMenu('<s:message code="DATA_STAT.STAT_KEYWORDHOST"/> - <s:message code="DATA_ANALYSIS.STAT_KEYWORD_DETAIL_TOP"/> 20');
		grid4.loadHeader(false);
		// grid4.loadPageSize();
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

			searchFlag = true;
			var selectSvcTypes  = arrayToString($('#serviceType').selectpicker('val'));

			grid1.on();
			ui.get({
				url: 'getKeywordHost.xcn',
				startDate: startDate + "000000",
				endDate: endDate + "235959",
				coreKeyword: coreKeyword,
				unclsfiedOnly : $('#unclsfiedOnly').val(),
				serviceCd : selectSvcTypes,
				offset: grid1.data.length,
				limit: grid1.pageSize,
				success: function (data, total) {
					totalCount = total;
					totalKeywordCount = data.numFound;
					grid1.setData(data.facet);
					hosts = data.facetHeader.join(',');
					fullHosts = hosts;

					// if (coreKeyword != '') {
					// 	getUrlData('');
					// }

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
			var searchHosts = host != '' ? host : fullHosts;

			var selectSvcTypes  = arrayToString($('#serviceType').selectpicker('val'));
			grid2.on();
			ui.get({
				url: 'getKeywordUrl.xcn',
				startDate: startDate + "000000",
				endDate: endDate + "235959",
				coreKeyword: coreKeyword,
				unclsfiedOnly : $('#unclsfiedOnly').val(),
				serviceCd : selectSvcTypes,
				hosts: searchHosts,
				offset: grid2.data.length,
				limit: grid2.pageSize,
				success: function (data, total) {
					grid2.setData(data.facet);
					paths = data.facetHeader.join('@XCNJOIN@');
					$('#urlSearchText').text('<s:message code="DATA_ANALYSIS.STAT_WORD_HOST"/> : ' + getTruncateSearchText(host));
					$('#urlSearchHostVal').val(host);

					searchedPaths = paths;

					// if (coreKeyword != '')getKeywordData(searchHosts,searchedPaths);
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
			var searchHosts = ((host != '' && host != null) || host == 'undefined') ? host : hosts;
			grid2.on();

			var selectSvcTypes  = arrayToString($('#serviceType').selectpicker('val'));
			ui.get({
				url: 'getKeywordUrl.xcn',
				startDate: startDate + "000000",
				endDate: endDate + "235959",
				coreKeyword: coreKeyword,
				unclsfiedOnly : $('#unclsfiedOnly').val(),
				serviceCd : selectSvcTypes,
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
		function getKeywordData(path) {
			var host = $('#urlSearchHostVal').val();
			var searchHosts = host != '' ? host : fullHosts;
			var searchPaths = path != '' ? path : searchedPaths;

			var selectSvcTypes  = arrayToString($('#serviceType').selectpicker('val'));
			grid3.on();
			ui.get({
				url: 'getKeywordDetail.xcn',
				startDate: startDate + "000000",
				endDate: endDate + "235959",
				unclsfiedOnly : $('#unclsfiedOnly').val(),
				serviceCd : selectSvcTypes,
				coreKeyword: coreKeyword,
				hosts: searchHosts,
				paths: searchPaths,
				success: function (data, total) {
					var keywords = data.facet.filter(obj => coreKeyword.split(',').includes(obj.name));
					if (coreKeyword == '')  keywords = data.facet.filter(obj => data.pivotHeader[0].split(',').includes(obj.name));
					grid3.setData(keywords);
					$('#keywordSearchText').text('<s:message code="DATA_ANALYSIS.STAT_WORD_HOST"/> : ' + getTruncateSearchText(host) + " > " + 'PATH : ' + getTruncateSearchText(path));
					$('#keywordSearchHostVal').val(host);
					$('#keywordSearchUrlVal').val(path);

					var kwds = '';
					if (keywords != '' && keywords.length > 0) {
						kwds = keywords.map(obj => obj.name).join(',');
					}
					// if (coreKeyword != '')getDetailData(searchHosts,searchPaths,kwds);
				},
				error: function (status, message) {
					ui.alertMsg(message);
				},
				complete: function () {
					grid3.off();
				}
			});
		}

		function getDetailData(keyword) {
			var host = $('#keywordSearchHostVal').val();
			var path = $('#keywordSearchUrlVal').val();
			var searchHosts = host != '' ? host : fullHosts;
			var searchPaths = path != '' ? path : searchedPaths;

			var searchKeywords = keyword != '' ? keyword : keywords;

			var selectSvcTypes  = arrayToString($('#serviceType').selectpicker('val'));
			grid4.on();
			ui.get({
				url: 'getKeywordDetailData.xcn',
				startDate: startDate + "000000",
				endDate: endDate + "235959",
				unclsfiedOnly : $('#unclsfiedOnly').val(),
				serviceCd : selectSvcTypes,
				coreKeyword: searchKeywords,
				hosts: searchHosts,
				paths: searchPaths,
				success: function (data, total) {
					$('#messageSearchText').text('<s:message code="DATA_ANALYSIS.STAT_WORD_HOST"/> : ' + getTruncateSearchText(host) + " > " + 'PATH : ' + getTruncateSearchText(path) + " > " + '<s:message code="DATA_ANALYSIS.STAT_WORD_KEYWORD"/> : ' + getTruncateSearchText(keyword));
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
			if(str == ''){
				return '<s:message code="DATA_ANALYSIS.STAT_WORD_ALL"/>'
			} else {
				if (str.length > 25) {
					return str.substring(0, 25) + '...';
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
</body>
</html>