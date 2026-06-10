<%@ page import="java.util.Arrays" %>
<%@ taglib prefix="spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<%
	
	//현재 사용중 생성형 AI 서비스
	String serviceCdArr="";
	String serviceNmArr="";

	//개인 정보 패턴
	String privacyCdArr = String.join(",", Config.activePrivatePatterns);


	
	java.util.List<com.xcurenet.emass.service.service.ServiceTypeVO> serviceInfo = Config.aiServices;
	for (com.xcurenet.emass.service.service.ServiceTypeVO svcVo : serviceInfo) {
		if (!serviceCdArr.isEmpty()) serviceCdArr += ",";
		serviceCdArr += svcVo.getServiceCd();
		
		if (!serviceNmArr.isEmpty()) serviceNmArr += ",";
		serviceNmArr += svcVo.getServiceNm();
	
	}

%>
<link rel="stylesheet" href="<c:url value="/css/ai_dashboard.min.css"/>"/>
<script type="text/javascript" src="<c:url value="/js/echarts.min.js"/>"></script>
<title>EMASS AI - Generative AI</title>
<style>
	.no-hover {
		pointer-events: none;
	}
    .tooltip-inner {
        max-width: 500px !important;
        white-space: normal !important;
        word-break: break-word !important;
        text-align: left !important;
        overflow: visible !important;
    }

    .between :hover{
	    cursor: pointer;
	    text-decoration: underline;
    }
	
    #todayCount{
        pointer-events: auto !important;
        position: relative;
        z-index: 100;
        cursor: pointer;
    }
    #todayAttachCount{
        pointer-events: auto !important;
        position: relative;
        z-index: 100;
        cursor: pointer;
	}
    #todayPiCount{
        pointer-events: auto !important;
        position: relative;
        z-index: 100;
        cursor: pointer;
    }
    #todayPiAttachCount{
        pointer-events: auto !important;
        position: relative;
        z-index: 100;
        cursor: pointer;
    }
	
    #todayKwdCount{
        pointer-events: auto !important;
        position: relative;
        z-index: 9999;
        cursor: pointer;
    }
	
    #todayKwdAttachCount{
        pointer-events: auto !important;
        position: relative;
        z-index: 9999;
        cursor: pointer;
    }

</style>
<div class="dashboard-ai-wrap">
<%-- ROW 1 START --%>
	<ul class="counter-card" id="aiCounter">
		<li class="badge-info">
			<div class="head">
				<strong><s:message code="ai.dashboard"/></strong>
				<div>
                    <span class="fs20 lh-1" data-toggle="tooltip" data-placement="left" title="" data-original-title="<s:message code="ai.dashboard.tooltip"/>">
                      <i class="far fa-fw fa-question-circle"></i>
                    </span>
				</div>
			</div>
			<div class="body">
				<div class="div-item-wrap mt-12">
					<dl class="div-item">
						<dt><s:message code="ai.dashboard.total.sent"/></dt>
						<dd>
							<p id="todayCount" class="js-counter"></p>
						</dd>
					</dl>
					<dl class="div-item">
						<dt><s:message code="ai.dashboard.sent.attach"/></dt>
						<dd>
							<p id="todayAttachCount" class="js-counter"></p>
						</dd>
					</dl>
				</div>
			</div>
		</li>

		<li class="badge-danger">
			<div class="head">
				<strong><s:message code="ai.dashboard.pi"/></strong>
				<div>
                    <span class="fs20 lh-1" data-toggle="tooltip" data-placement="left" title="" data-original-title="<s:message code="ai.dashboard.pi.tooltip"/>">
                      <i class="far fa-fw fa-question-circle"></i>
                    </span>
				</div>
			</div>
			<div class="body">
				<div class="div-item-wrap mt-12">
					<dl class="div-item">
						<dt><s:message code="ai.dashboard.total"/></dt>
						<dd>
							<p id="todayPiCount" class="js-counter"></p>
						</dd>
					</dl>
					<dl class="div-item">
						<dt><s:message code="ai.dashboard.sent.attach"/></dt>
						<dd>
							<p id="todayPiAttachCount" class="js-counter"></p>
						</dd>
					</dl>
				</div>
			</div>
		</li>
		<li class="badge-observe">
			<div class="head">
				<strong><s:message code="ai.dashboard.kwd"/></strong>
				<div>
			        <span class="fs20 lh-1" data-toggle="tooltip" data-placement="left" title="" data-original-title="<s:message code="ai.dashboard.kwd.tooltip"/>">
                      <i class=" far fa-fw fa-question-circle"></i>
					</span>
				</div>
			</div>
			<div class="body">
				<div class="div-item-wrap mt-12">
					<dl class="div-item">
						<dt><s:message code="ai.dashboard.total"/></dt>
						<dd>
							<p id="todayKwdCount" class="js-counter"></p>
						</dd>
					</dl>
					<dl class="div-item">
						<dt><s:message code="ai.dashboard.sent.attach"/></dt>
						<dd>
							<p id="todayKwdAttachCount" class="js-counter"></p>
						</dd>
					</dl>
				</div>
			</div>
		</li>
	</ul>
<%-- ROW 1 END --%>
<%-- ROW 2 START --%>
	<div class="grid w-full h-full gap-20" style="--grid-cols: 1.5fr 2fr">
		<div class="card">
			<div class="card-head">
				<strong class="tit"><s:message code="ai.dashboard.user.top10"/>
				</strong>
				<div>
					<span id="aiUserStatus"></span>
				</div>
			</div>
			<div class="card-body">
				<ul id="aiUserTop10List" class="list-body"></ul>
			</div>
		</div>
		<div class="card">
			<div class="card-head">
				<strong class="tit">
					<s:message code="ai.dashboard.svc.top10"/>
				</strong>
			</div>
			<div class="card-body">
				<div id="aiTop10Svc" class="ui-charts" style="height: 455px"></div>
			</div>
		</div>
	</div>
<%-- ROW 2 END --%>
<div class="grid w-full h-full gap-20" style="--grid-cols: 1fr">
	<div class="card">
		<div class="card-head">
			<strong class="tit">
				<s:message code="ai.dashboard.user.times"/>
<%--				<span>(기준: 오전 08:13:12)</span>--%>
			</strong>
		</div>
		<div class="card-body">
			<div id="aiTime" class="ui-charts" style="height: 600px"></div>
		</div>
	</div>
</div>
<%-- ROW 3 START --%>
<div class="grid w-full h-full gap-20" style="--grid-cols: 1fr 1fr">
	<div class="card">
		<div class="card-head">
			<strong class="tit">
				<s:message code="ai.dashboard.user.pi.top10"/>
			</strong>
			<div>
				<span id="aiUserStatus"></span>
			</div>
		</div>
		<div class="card-body">
			<ul id="aiUserPiTop10List" class="list-body"></ul>
		</div>
	</div>
	<div class="card">
		<div class="card-head">
			<strong class="tit">
				<s:message code="ai.dashboard.user.kwd.top10"/>
			</strong>
<%--			<div><span>총: 150명 / 32,000건</span></div>--%>
		</div>
		<div class="card-body">
			<ul id="aiUserKwdTop10List" class="list-body"></ul>
		</div>
	</div>
</div>
<%-- ROW 3 END --%>
<form method="post" id="getMessageInfo" action="<c:url value="/ems/message.do"/>" target="_self">
	<input type="hidden" name="conditionParam" id="conditionParam"/>
</form>
</div>

<script>
	let currentTime;
	let aiTop10SvcChart; 	//AI 서비스 사용량 비교 Top 10
	let aiTop10SvcChartOption; // AI 서비스 사용량 비교 Top 10 옵션

	let aiTimeChart; 	//AI 서비스 시간대별 차트
	let aiTimeChartOption; // AI 서비스 시간대별 차트 옵션
	

	$(function () {
		aiTop10SvcChart = echarts.init(document.getElementById("aiTop10Svc"), "dark");
		aiTimeChart = echarts.init(document.getElementById("aiTime"), "dark");


		// AI 서비스 사용량 비교 차트 좌측 막대 그래프 mouseOver 시 우측 도넛 그래프 강조 표시
		aiTop10SvcChart.on('mouseover', { seriesType: 'bar' }, function(params) {
			aiTop10SvcChart.dispatchAction({
				type: 'highlight',
				seriesIndex: 2,
				name: params.name
			});
		});
		aiTop10SvcChart.on('mouseout', { seriesType: 'bar' }, function(params) {
			aiTop10SvcChart.dispatchAction({
				type: 'downplay',
				seriesIndex: 2,
				name: params.name
			});
		});


		aiTop10SvcChart.on('click', function(params) {
			if (params.seriesType !== 'bar' && params.seriesType !== 'pie') return;

			var isToday;
			if (params.seriesType === 'bar') isToday = params.seriesName === aiDashboardMsgMaps.today;
			else isToday = params.seriesName === aiDashboardMsgMaps.svcTodayTop10;

			resetAiDashboardCondition();
			if (!isToday) dashCondition.startMinusDay = 7;
			if (currentTimeType == "work") dashCondition.ctimeWork = "W";
			else if (currentTimeType == "nonWork") dashCondition.ctimeWork = "R";
			dashCondition.authorityScope = 'AI_DASHBOARD';
			dashCondition.serviceType = params.data.svc;
			dashCondition.serviceTypeNm = params.name;


			$('#conditionParam').val(makePeriod(dashCondition));
			$('#getMessageInfo').submit();
		});

	});

	function getNowTimeStr() {
		const now = new Date();
		const hh = String(now.getHours()).padStart(2, '0');
		const mm = String(now.getMinutes()).padStart(2, '0');
		const ss = String(now.getSeconds()).padStart(2, '0');
		return `${hh}:${mm}:${ss}`;
	}

	getAiDashboardStats();
	function getAiDashboardStats() {
		ui.post({
			url: '/getAiDashboardStats.xcn',
			success: function (data) {
				if (data != null) {
					aiCountWrite(data)
					renderAiUserList(data.todayAiUsers);
					reloadTop10AiSvcChart(data.todayTop10Info,data.weeklyTop10Info);
					reloadAiTimeChart(data.aiTimeStats);
					renderAiPiUserList(data.todayAiPiUsers);
					renderAiKwdUserList(data.todayAiKwdUsers);
				}
			},
			error: function (err) {
			}
		});
	}

	let totalCount = 0;

	function aiCountWrite(data) {
		updateCounterUp('#todayCount', data.todayCount);
		totalCount = data.todayCount;
		updateCounterUp('#todayAttachCount', data.todayAttachCount);

		updateCounterUp('#todayPiCount', data.todayPiCount);
		updateCounterUp('#todayPiAttachCount', data.todayPiAttachCount);

		updateCounterUp('#todayKwdCount', data.todayKwdCount);
		updateCounterUp('#todayKwdAttachCount', data.todayKwdAttachCount);
	}

	function renderAiUserList(aiUsers) {
		if (aiUsers == null || aiUsers.length === 0) {
			emptyDiv("aiUserTop10List", 440);
			return;
		}
		var $ul = $("#aiUserTop10List");
		var html = "";
		var limit = 10;
		var users = aiUsers.slice(0, limit);

		for (var i = 0; i < users.length; i++) {
			var user = users[i];
			var userId = user.userId || user.srcIp || "unknown";
			var displayName = user.userNm
				? user.userNm + " " + (user.deptNm || '') + '/' + (user.jikgubNm || '')
				: userId;

			var svcInfos = user.svcInfos || [];
			var svcNames = [];
			var totalSvcCount = 0;

			for (var j = 0; j < svcInfos.length; j++) {
				var svc = svcInfos[j];
				var svcName = svc.svcName || svc.svc;
				svcNames.push(svcName);
				totalSvcCount += parseInt(svc.svcCount || "0", 10);
			}

			var svcTooltip = aiDashboardMsgMaps.userSvcs + ": " + svcNames.join(', ');
			html += ''
				+ '<li>'
				+ '<a href="javascript:void(0)" style="cursor: default;" class="between todayTopUser" data-value="' + user.userId+ '">'
				+ '<p>' + displayName + '</p>'
				+ '<div>'
				+ '<span class="icon-ai">'
				+ '<i class="ri-ai-generate-2" data-toggle="tooltip" data-placement="left" data-html="true" title="' + svcTooltip + '"></i>'
				+ '</span>'
				+ '<span class="icon-today" data-toggle="tooltip" data-placement="left" data-html="true" title="' + totalSvcCount + '건">'
				+ '<i class="ri-calendar-event-line"></i> ' + totalSvcCount + '</span>'
				+ '</div>'
				+ '</a>'
				+ '</li>';
		}

		$ul.html(html);
		$('[data-toggle="tooltip"]').tooltip();
	}


	function renderAiPiUserList(aiUsers) {
		if (aiUsers == null || aiUsers.length === 0) {
			emptyDiv("aiUserPiTop10List", 440);
			return;
		}
		var $ul = $("#aiUserPiTop10List");
		var html = "";
		var limit = 10;
		var users = aiUsers.slice(0, limit);

		for (var i = 0; i < users.length; i++) {
			var user = users[i];
			var userId = user.userId || user.srcIp || "unknown";
			var displayName = user.userNm
				? user.userNm + " " + (user.deptNm || '') + '/' + (user.jikgubNm || '')
				: userId;

			var piInfos = user.piInfos || [];
			var piNames = [];
			var totalPiCount = 0;

			for (var j = 0; j < piInfos.length; j++) {
				var pi = piInfos[j];
				var piName = pi.piName || "PI";
				piNames.push(piName);
				totalPiCount += parseInt(pi.piCount || "0", 10);
			}

			var piTooltip = aiDashboardMsgMaps.userPis + ": " + piNames.join(', ');
			html += ''
				+ '<li>'
					+ '<a href="javascript:void(0)" style="cursor: default;" class="between piUser" data-value="' + user.userId+ '">'
				+ '<p>' + displayName + '</p>'
				+ '<div>'
				+ '<span class="icon-ai">'
				+ '<i class="ri-ai-generate-2" data-toggle="tooltip" data-placement="left" data-html="true" title="' + piTooltip + '"></i>'
				+ '</span>'
				+ '<span class="icon-today" data-toggle="tooltip" data-placement="left" data-html="true" title="' + totalPiCount + '건">'
				+ '<i class="ri-calendar-event-line"></i> ' + totalPiCount + '</span>'
				+ '</div>'
				+ '</a>'
				+ '</li>';
		}

		$ul.html(html);
		$('[data-toggle="tooltip"]').tooltip();
	}


	function renderAiKwdUserList(aiUsers) {
		if (aiUsers == null || aiUsers.length === 0) {
			emptyDiv("aiUserKwdTop10List", 440);
			return;
		}
		var $ul = $("#aiUserKwdTop10List");
		var html = "";
		var limit = 10;
		var users = aiUsers.slice(0, limit);

		for (var i = 0; i < users.length; i++) {
			var user = users[i];
			var userId = user.userId || user.srcIp || "unknown";
			var displayName = user.userNm
				? user.userNm + " " + (user.deptNm || '') + '/' + (user.jikgubNm || '')
				: userId;

			var kwdInfos = user.kwdInfos || [];
			var kwdNames = [];
			var totalKwdCount = 0;

			for (var j = 0; j < kwdInfos.length; j++) {
				var kwd = kwdInfos[j];
				var kwdName = kwd.kwd || "keyword";
				kwdNames.push(kwdName);
				totalKwdCount += parseInt(kwd.kwdCount || "0", 10);
			}

			var kwdTooltip = aiDashboardMsgMaps.userkwds + ": " + kwdNames.join(', ');
			html += ''
				+ '<li>'
				+ '<a href="javascript:void(0)"  style="cursor: default;" class="between keywordUser" data-value="' + user.userId+ '">'
				+ '<p>' + displayName + '</p>'
				+ '<div>'
				+ '<span class="icon-ai">'
				+ '<i class="ri-ai-generate-2" data-toggle="tooltip" data-placement="left" data-html="true" title="' + kwdTooltip + '"></i>'
				+ '</span>'
				+ '<span class="icon-today" data-toggle="tooltip" data-placement="left" data-html="true" title="' + totalKwdCount + '건">'
				+ '<i class="ri-calendar-event-line"></i> ' + totalKwdCount + '</span>'
				+ '</div>'
				+ '</a>'
				+ '</li>';
		}
		$ul.html(html);
		$('[data-toggle="tooltip"]').tooltip();
	}




	function updateCounterUp(selector, newVal, duration = 500) {
		const $el = $(selector);
		if ($el.length === 0) return;
		newVal = Number(newVal) || 0;
		const prevVal = Number($el.data('prev')) || 0;
		if (prevVal === newVal && prevVal != 0) return;
		$el.data('prev', newVal);
		$({val: prevVal}).animate(
			{val: newVal},
			{
				duration,
				easing: 'swing',
				step(now) {
					$el.text(Math.floor(now).toLocaleString());
				},
				complete() {
					$el.text(newVal.toLocaleString());
				}
			}
		);
	}


	let top10ChartData = {};
	var currentTimeType = "all";
	var currentActiveLabel = null;
	var EMPTY_DATA = { names: [], values: [], pie: [], total: 0 };
	function reloadTop10AiSvcChart(todayTop10Info, weeklyTop10Info) {
		if (todayTop10Info.length == 0 && weeklyTop10Info.length == 0) {
			emptyDiv("aiTop10Svc", 440);
			return;
		}
		top10ChartData = {
			today: convertSvcData(todayTop10Info),
			weekly: convertSvcData(weeklyTop10Info)
		};
		var todayLabel = aiDashboardMsgMaps.today;
		var weeklyLabel = aiDashboardMsgMaps.weekly;
		currentActiveLabel = todayLabel;
		currentTimeType = "all";

		aiTop10SvcChart.setOption(getAiDataOption(top10ChartData.today, top10ChartData.weekly, todayLabel, "all"), { notMerge: true });

		aiTop10SvcChart.off('legendselectchanged');
		aiTop10SvcChart.on('legendselectchanged', function (params) {
			var name = params.name;
			var selected = params.selected;

			if (name === aiDashboardMsgMaps.all || name === aiDashboardMsgMaps.work || name === aiDashboardMsgMaps.nonWork) {
				var typeMap = {};
				typeMap[aiDashboardMsgMaps.all] = "all";
				typeMap[aiDashboardMsgMaps.work] = "work";
				typeMap[aiDashboardMsgMaps.nonWork] = "nonWork";
				currentTimeType = typeMap[name];
				aiTop10SvcChart.setOption(getAiDataOption(top10ChartData.today, top10ChartData.weekly, currentActiveLabel, currentTimeType), { notMerge: true });
				return;
			}


			if (selected[todayLabel]) currentActiveLabel = todayLabel;
			else if (selected[weeklyLabel]) currentActiveLabel = weeklyLabel;
			if (!currentActiveLabel) { aiTop10SvcChart.clear(); return; }
			aiTop10SvcChart.setOption(getAiDataOption(top10ChartData.today, top10ChartData.weekly, currentActiveLabel, currentTimeType), { notMerge: true });
		});

		aiTop10SvcChart.resize();
	}





	function reloadAiTimeChart(aiTimeStats){
		if(aiTimeStats.length == 0){
			emptyDiv("aiTime", 620);
			return;
		}
		aiTimeChart.setOption(getAiTimeChartOption(aiTimeChart,aiTimeStats));
		aiTimeChart.resize();
	}


    var dashCondition = {
        "searchStr": "",
        "searchField": "",
        "serviceType": "I*",
        "serviceTypeNm": '',
        "interGroup": "",
        "interGroupNm": "-<s:message code="condition.interestGroup"/>-",
        "userGroupSeq": "",
        "userGroupName": "-<s:message code="condition.userGroup"/>-",
        "startDateSelect": "T",
        "startTimeSelect": "00",
        "endDateSelect": "T",
        "endTimeSelect": "23",
		"startMinusDay": "0",
        "senders": "",
        "receivers": "",
        "allOfus": "",
        "busi": "",
        "busiNm":  '<s:message code="common.org.busi.all"/>',
        "dept": "",
        "deptNm": "",
        "receiveSend": "O",
        "ctimeWork": "",
        "readYn": "",
        "attachYn": "",
        "attachVal": "",
        "attachStr": "",
        "keywordYn": "",
        "keywordVal": "",
        "keywordStr": "",
        "regexpYn": "",
        "regexpVal": "",
        "regexpStr": "",
        "drmYn": "",
        "sctYn": "",
        "sizeStartVal": "0",
        "sizeEndVal": "0",
        "sizeOption": "L",
        "sizeType": "",
	    "senders_findByParam" : ""
    };
    var privacyCdArr = '<%=privacyCdArr%>';
    var serviceCdArr =  '<%=serviceCdArr%>';
    var serviceNmArr =  '<%=serviceNmArr%>';


	/** 통합 메시지 조회 시 대시보드 집계 조건과 일치시키기: 선택적 조건 초기화(이전 클릭 값 제거) */
	function resetAiDashboardCondition() {
		dashCondition.senders = "";
		dashCondition.senders_findByParam = "";
		dashCondition.senders_upperCase = "";
		dashCondition.accessUserid = "";
		dashCondition.accessUserid_not = "";
		dashCondition.accessUserid_findByParam = "";
		dashCondition.accessUserid_findByKeyword = "";
		dashCondition.keywordYn = "";
		dashCondition.keywordVal = "";
		dashCondition.keywordStr = "";
		dashCondition.regexpYn = "";
		dashCondition.regexpVal = "";
		dashCondition.regexpStr = "";
		dashCondition.attachYn = "";
		dashCondition.attachVal = "";
		dashCondition.attachStr = "";
		dashCondition.sizeType = "";
		dashCondition.sizeOption = "L";
		dashCondition.ctimeWork = "";
		dashCondition.startMinusDay = 0;
	}
    
    function makePeriod(dashCondition) {
        var endTimeSelect = dashCondition.endTimeSelect;
        var startMinusDay = dashCondition.startMinusDay;
        var startMinusMouth = 0;
        var endMinusDay = 0;
        var dateObj = new Date();
        var startDate = new Date(dateObj);  // 날짜 객체를 복사하여 사용
        startDate.setMonth(dateObj.getMonth() - startMinusMouth);
        startDate.setDate(dateObj.getDate() - startMinusDay);
        var endDate = new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate() - endMinusDay, endTimeSelect, 59, 59);
        dashCondition.startDt = startDate.format('yyyymmdd')+"000000";
        dashCondition.endDt = endDate.format('yyyymmddHHnnss');
        return JSON.stringify(dashCondition);
    }

    $(document).on('click', '#todayCount', function (e) {
        e.preventDefault();
        dashCondition.serviceType = serviceCdArr;
        dashCondition.serviceTypeNm = serviceNmArr;
        $('#conditionParam').val(makePeriod(dashCondition));
       $('#getMessageInfo').submit();
    });

    $(document).on('click', '#todayAttachCount', function (e) {
       e.preventDefault();
        dashCondition.serviceType = serviceCdArr;
        dashCondition.serviceTypeNm = serviceNmArr;
        dashCondition.attachYn = "Y";
        dashCondition.sizeType = "A";
        dashCondition.sizeOption = "L";
        $('#conditionParam').val(makePeriod(dashCondition));
        $('#getMessageInfo').submit();
    });

    $(document).on('click', '#todayPiCount', function (e) {
        e.preventDefault();
        dashCondition.serviceType = serviceCdArr;
        dashCondition.serviceTypeNm = serviceNmArr;
        dashCondition.regexpYn = "Y";
	    dashCondition.regexpVal = privacyCdArr.replaceAll(",", "%L@1|") + "%L@1";
        $('#conditionParam').val(makePeriod(dashCondition));
       $('#getMessageInfo').submit();
    });


    $(document).on('click', '#todayPiAttachCount', function (e) {
	    e.preventDefault();
        dashCondition.serviceType = serviceCdArr;
        dashCondition.serviceTypeNm = serviceNmArr;
        dashCondition.regexpYn = "Y";
        dashCondition.regexpVal = privacyCdArr.replaceAll(",", "%L@1|") + "%L@1";
        dashCondition.attachYn = "Y";
        dashCondition.sizeType = "A";
        dashCondition.sizeOption = "L";
        $('#conditionParam').val(makePeriod(dashCondition));
        $('#getMessageInfo').submit();
    });

    $(document).on('click', '#todayKwdCount', function (e) {
        e.preventDefault();
        dashCondition.serviceType = serviceCdArr;
        dashCondition.serviceTypeNm = serviceNmArr;
        dashCondition.keywordYn = "Y";
        $('#conditionParam').val(makePeriod(dashCondition));
        $('#getMessageInfo').submit();
    });

    $(document).on('click', '#todayKwdAttachCount', function (e) {
        e.preventDefault();
        dashCondition.serviceType = serviceCdArr;
        dashCondition.serviceTypeNm = serviceNmArr;
        dashCondition.keywordYn = "Y";
        dashCondition.attachYn = "Y";
        dashCondition.sizeType = "A";
        dashCondition.sizeOption = "L";
        $('#conditionParam').val(makePeriod(dashCondition));
        $('#getMessageInfo').submit();
    });

	//금일 top 10 유저별 ai 현황
	$(document).on('click', '.todayTopUser', function (e) {
		e.preventDefault();
		let data = $(this).data('value');
		dashCondition.serviceType = serviceCdArr;
		dashCondition.serviceTypeNm = serviceNmArr;
		dashCondition.senders_findByParam = "Y";
		dashCondition.senders = data;
		dashCondition.senders_upperCase = "Y";
		$('#conditionParam').val(makePeriod(dashCondition));
		$('#getMessageInfo').submit();
	});

	$(document).on('click', '.piUser', function (e) {
		e.preventDefault();
		let data = $(this).data('value');
		dashCondition.serviceType = serviceCdArr;
		dashCondition.serviceTypeNm = serviceNmArr;
		dashCondition.senders_findByParam = "Y";
		dashCondition.senders = data;
		dashCondition.senders_upperCase = "Y";
		dashCondition.regexpYn = "Y";
		dashCondition.regexpVal = privacyCdArr.replaceAll(",", "%L@1|") + "%L@1";
		$('#conditionParam').val(makePeriod(dashCondition));
		$('#getMessageInfo').submit();
	});

	$(document).on('click', '.keywordUser', function (e) {
		e.preventDefault();
		let data = $(this).data('value');
		dashCondition.serviceType = serviceCdArr;
		dashCondition.serviceTypeNm = serviceNmArr;
		dashCondition.senders_findByParam = "Y";
		dashCondition.senders = data;
		dashCondition.senders_upperCase = "Y";
		dashCondition.keywordYn = "Y";
		$('#conditionParam').val(makePeriod(dashCondition));
		$('#getMessageInfo').submit();
	});


</script>
<script>
	window.addEventListener("resize", function () {
		aiTop10SvcChart.resize();
		aiTimeChart.resize();
	});

	function emptyDiv(divId, height) {
		var $div = $("#" + divId);
		$div.empty();
		var $innerDiv = $("<div>")
			.css({
				padding: 0,
				height: height + "px",
			})
			.append(
				$("<div>").css({
					display: "flex",
					justifyContent: "center",
					alignItems: "center",
					height: "100%",
					width: "100%",
					fontSize: "16px",
					fontWeight: "bold",
					textAlign: "center",
					color: "#aaa"
				}).text(aiDashboardMsgMaps.noData)
			);
		$div.append($innerDiv);
	}

	var aiDashboardMsgMaps = {
		noData: '<s:message code="ai.dashboard.nodata"/>',
		noInfo: '<s:message code="ai.dashboard.noinfo"/>',
		userSvcs: '<s:message code="ai.dashboard.user.svcs"/>',
		userPis: '<s:message code="ai.dashboard.user.pis"/>',
		userkwds: '<s:message code="ai.dashboard.user.kwds"/>',
		svcTop10Desc: '<s:message code="ai.dashboard.svc.top10.desc"/>',
		svcTodayTop10: '<s:message code="ai.dashboard.svc.today.top10"/>',
		svcWeeklyTop10: '<s:message code="ai.dashboard.svc.weekly.top10"/>',
		svcTodayPercent: '<s:message code="ai.dashboard.svc.today.percent"/>',
		svcWeeklyPercent: '<s:message code="ai.dashboard.svc.weekly.percent"/>',
		svcWeeklyTotal: '<s:message code="ai.dashboard.svc.weekly.total"/>',
		svcTodayTotal: '<s:message code="ai.dashboard.svc.today.total"/>',
		todayPi: '<s:message code="ai.dashboard.user.pi.top10"/>',
		todayKwd: '<s:message code="ai.dashboard.user.kwd.top10"/>',
		today: '<s:message code="ai.dashboard.today"/>',
		weekly: '<s:message code="ai.dashboard.weekly2"/>',
		svcUsed: '<s:message code="ai.dashboard.svc.used"/>',
		all: '<s:message code="DATA_ANALYSIS.STAT_WORD_ALL"/>',
		work: '<s:message code="common.msg.work_time"/>',
		nonWork: '<s:message code="blockHistoryNonBusi.nonworktime"/>'
	}

	function getAiDataOption(todayData, weeklyData, activeLabel, timeType) {
		var todayLabel = aiDashboardMsgMaps.today;
		var weeklyLabel = aiDashboardMsgMaps.weekly;
		var isToday = activeLabel === todayLabel;

		var type = timeType || "all";
		var todaySrc = todayData[type] || todayData.all;
		var weeklySrc = weeklyData[type] || weeklyData.all;

		var activeNames = isToday ? todaySrc.names : weeklySrc.names;
		var pieData = isToday ? todaySrc.pie : weeklySrc.pie;
		var pieTotal = isToday ? todaySrc.total : weeklySrc.total;
		var showZoom = activeNames.length > 15;
		return {
			backgroundColor: "transparent",
			tooltip: {},
			legend: [
				{
					// 전체/업무시간/비업무시간
					top: "0%",
					left: "center",
					selectedMode: "single",
					data: [
						{ name: aiDashboardMsgMaps.all, icon: "roundRect" },
						{ name: aiDashboardMsgMaps.work, icon: "roundRect" },
						{ name: aiDashboardMsgMaps.nonWork, icon: "roundRect" }
					],
					selected: (function() {
						var o = {};
						o[aiDashboardMsgMaps.all] = type === "all";
						o[aiDashboardMsgMaps.work] = type === "work";
						o[aiDashboardMsgMaps.nonWork] = type === "nonWork";
						return o;
					})()
				},
				{

					bottom: "0%",
					left: "24%",
					textAlign: "center",
					selectedMode: "single",
					data: [todayLabel, weeklyLabel],
					selected: (function () {
						var o = {};
						o[todayLabel] = isToday;
						o[weeklyLabel] = !isToday;
						return o;
					})()
				}
			],
			dataZoom: showZoom ? [
				{
					type: "slider",
					yAxisIndex: 0,
					orient: "vertical",
					width: 16,
					left: 3,
					top: "18%",
					bottom: "10%",
					start: 0,
					end: Math.round((15 / activeNames.length) * 100),
					brushSelect: false,
					zoomLock: true,
					borderColor: "transparent",
					fillerColor: "rgba(52, 120, 246, 0.3)",
					handleStyle: { color: "#3478f6" },
					moveHandleStyle: { color: "#3478f6" },
					showDetail: false,
					showDataShadow: false,
				},
				{
					type: "inside",
					yAxisIndex: 0,
					orient: "vertical",
					zoomLock: false
				}
			] : [],
			title: (function () {
				var titles = [
					{
						text: aiDashboardMsgMaps.svcTop10Desc,
						subtext: aiDashboardMsgMaps.svcTodayTop10 + ":" + todaySrc.total + " / " + aiDashboardMsgMaps.svcWeeklyTop10 + ":" + weeklySrc.total,
						top: "6%",
						left: "30%",
						textAlign: "center",
						textStyle: { fontSize: 14 }
					}
				];

				if (isToday) {
					titles.push({
						text: aiDashboardMsgMaps.svcTodayPercent,
						subtext: aiDashboardMsgMaps.svcTodayTotal + " " + todaySrc.total,
						top: "6%",
						left: "75%",
						textAlign: "center",
						textStyle: { fontSize: 14 }
					});
				} else {
					titles.push({
						text: aiDashboardMsgMaps.svcWeeklyPercent,
						subtext: aiDashboardMsgMaps.svcWeeklyTotal + " " + weeklySrc.total,
						top: "6%",
						left: "75%",
						textAlign: "center",
						textStyle: { fontSize: 14 }
					});
				}

				return titles;
			})(),
			grid: [{ top: "18%", bottom: "10%", width: "50%", left: 10, containLabel: true }],
			xAxis: [{ type: "value", splitLine: { show: true } }],
			yAxis: [{ type: "category", data: activeNames, inverse: true, splitLine: { show: false }, axisLabel: {fontSize: 10} }],
			series: [
				{
					name: weeklyLabel,
					type: "bar",
					cursor: "default",
					data: (weeklySrc.values || []).map(function(item, i) {
						return typeof item === 'object' ? item : {
							value: item,
							svc: (weeklySrc.svc || [])[i],
							name: (weeklySrc.names || [])[i]
						};
					}),
					barMaxWidth: 18,
					barMinHeight : 8,
					itemStyle: { color: "#3478f6" }
				},
				{
					name: todayLabel,
					type: "bar",
					cursor: "default",
					data: (todaySrc.values || []).map(function(item, i) {
						return typeof item === 'object' ? item : {
							value: item,
							svc: (todaySrc.svc || [])[i],
							name: (todaySrc.names || [])[i]
						};
					}),
					barMaxWidth: 18,
					barMinHeight : 8,
					itemStyle: { color: "#60eeff" }
				},
				{
					name: isToday ? aiDashboardMsgMaps.svcTodayTop10 : aiDashboardMsgMaps.svcWeeklyTop10,
					type: "pie",
					radius: ["40%", "70%"],
					avoidLabelOverlap: false,
					top: 50,
					bottom: "0%",
					width: "50%",
					left: "50%",
					tooltip: { show: false },
					cursor: "default",
					label: {
						show: false,
						color: "#fff",
						position: "center",
						formatter: function (params) {
							var value = params.value || 0;
							var name = params.name || "";
							var percent = pieTotal ? ((value / pieTotal) * 100).toFixed(1) : 0;
							return name + "\n" + percent + "% (" + value + ")";
						}
					},
					emphasis: {
						cursor: "default",
						label: {
							show: true,
							fontSize: 24,
							fontWeight: "bold"
						}
					},
					labelLine: { show: true },
					data: pieData || []
				},

				{ name: aiDashboardMsgMaps.all, type: "bar", data: [], silent: true, legendHoverLink: false },
				{ name: aiDashboardMsgMaps.work, type: "bar", data: [], silent: true, legendHoverLink: false },
				{ name: aiDashboardMsgMaps.nonWork, type: "bar", data: [], silent: true, legendHoverLink: false }
			]
		};
	}

	function convertSvcData(dataList) {
		if (!dataList) return { all: EMPTY_DATA, work: EMPTY_DATA, nonWork: EMPTY_DATA };
		return {
			all:     parseList(dataList.all     || []),
			work:    parseList(dataList.work    || []),
			nonWork: parseList(dataList.nonWork || [])
		};
	}

	function parseList(list) {
		var names  = [];
		var values = [];
		var svcs   = [];
		var pie    = [];
		var total  = 0;

		for (var i = 0; i < list.length; i++) {
			var item  = list[i];
			var name  = item.svcName || item.svc;
			var svc   = item.svc;
			var count = parseInt(item.svcCount || 0, 10);

			names.push(name);
			values.push(count);
			svcs.push(svc);
			pie.push({ name: name, value: count, svc: svc });
			total += count;
		}

		return { names: names, values: values, svc: svcs, pie: pie, total: total };
	}


    function getAiTimeChartOption(chart, aiTimeStats) {
        function formatTime(hour, minute) {
            return (hour.length === 1 ? "0" + hour : hour) + ":" + (minute.length === 1 ? "0" + minute : minute);
        }

        function getCurrentRoundedTime() {
            var now = new Date();
            var hours = now.getHours();
            var minutes = now.getMinutes();
            var roundedMinutes = Math.floor(minutes / 5) * 5;
            var paddedHour = hours < 10 ? "0" + hours : "" + hours;
            var paddedMinute = roundedMinutes < 10 ? "0" + roundedMinutes : "" + roundedMinutes;
            return paddedHour + ":" + paddedMinute;
        }

        var timeSet = {};
        var svcMap = {};
        for (var i = 0; i < aiTimeStats.length; i++) {
            var item = aiTimeStats[i];
            var timeKey = formatTime(item.hour, item.minute);
            timeSet[timeKey] = true;

            var svc = item.svcName || item.svc;
            if (!svcMap[svc]) svcMap[svc] = {};
            svcMap[svc][timeKey] = parseInt(item.svcCount, 10);
        }

        var timeList = Object.keys(timeSet).sort();

        var currentTimeKey = getCurrentRoundedTime();
        if (timeList.length === 0 || timeList[timeList.length - 1] < currentTimeKey) {
            timeList.push(currentTimeKey);
        }
        var svcNames = Object.keys(svcMap).filter(function (name) {
            return name && name !== "N/A";
        });

        var seriesList = [];
        for (var s = 0; s < svcNames.length; s++) {
            var svc = svcNames[s];
            var dataArr = [];
            for (var j = 0; j < timeList.length; j++) {
                var t = timeList[j];
                dataArr.push(svcMap[svc][t] || 0);
            }

            seriesList.push({
                name: svc,
                type: "line",
                smooth: false,
                step: false,
                data: dataArr,
                lineStyle: { width: 3 },
                silent: true,
                emphasis: {
                    cursor: "default",
                    focus: "self"
				},
                label: {
                    show: false,
                    position: 'right',
                    fontSize: 12,
                    color: '#fff',
                    formatter: function (params) {
                        var opt = chart.getOption();
                        if (!opt || !opt.series) return '';
                        var series = null;
                        for (var k = 0; k < opt.series.length; k++) {
                            if (opt.series[k].name === params.seriesName) { series = opt.series[k]; break; }
                        }
                        if (!series) return '';
                        var lastIdx = (series.data ? series.data.length : 0) - 1;
                        return params.dataIndex === lastIdx ? params.seriesName : '';
                    }
                }
            });
        }
        var tooltipCfg = seriesList.length ? {
            trigger: "axis",
            axisPointer: { type: "line" }
        } : { show: false };

        return {
            backgroundColor: "transparent",
            animationDuration: 1000,
            tooltip: tooltipCfg,
            legend: { show: false },
            xAxis: {
                type: "category",
                data: timeList,
                name: "",
                nameLocation: "middle",
                nameGap: 30,
                axisLabel: { rotate: 45 }
            },
            yAxis: {
                name: aiDashboardMsgMaps.svcUsed
            },
            grid: {
                right: 180,
                left: 60,
                bottom: 120
            },
            dataZoom: [
                { type: "slider", show: true, xAxisIndex: 0, start: 0, end: 100, height: 20, labelFormatter: '' },
                { type: "inside", xAxisIndex: 0, start: 0, end: 100 }
            ],
            series: seriesList
        };
    }


</script>
