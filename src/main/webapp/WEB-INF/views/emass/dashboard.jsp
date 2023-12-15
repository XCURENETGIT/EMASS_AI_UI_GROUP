<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<link rel="stylesheet" href="<c:url value="/css/dashboard.css"/>"/>
<%
	String infoFeedbackYn = Common.getInfoFeedbackYn(session);
	boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
	String adminType = Common.getAdminType(session);
	String systemArch = Config.getString("system.arch");
	pageContext.setAttribute("arch", systemArch);
%>
<title>EMASS LTH - Dashboard</title>
<script type="text/javascript">
    var updateTime = 40000;
    var dashboardGrid;

    function dashboardInit() {
    }

    $.urlParam = function (name) {
        var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
        if (results == null) {
            return null;
        } else {
            return results[1] || 0;
        }
    }

    var menuKey;
    $(document).ready(function () {
        menuKey = $.urlParam('menuKey');
        if (menuKey) dashboardInit();
        else getDefaultMenuKey();

        getTodayKeywordDetection();
        getTodayRiskBehavior();
        getTodayPatternPrivacy();
        getFileSendTotal();
        getServiceDataLogging();

    })
    // 금일 예약어 합계
    var getTodayKeywordDetectionSetTime;

    function getTodayKeywordDetection() {
        if (getTodayKeywordDetectionSetTime != null) window.clearTimeout(getTodayKeywordDetectionSetTime);

        ui.get({
            url: 'getTodayKeywordDetection.xcn',
            searchStr: '',
            success: function (data, total) {
                console.log("data: " + data.total);
                try {
                    $('#TodayKeywordTotalCnt').html(data.total + "<span>건</span>");
                    // off('keyword.message.count');
                } catch (e) {
                }
            },
            error: function (status, message) {
                //ui.alertMsg(message);
            },
            complete: function () {
                getTodayKeywordDetectionSetTime = window.setTimeout(function () {
                    getTodayKeywordDetection();
                }, updateTime);

            }
        });
    }

    //금일 위험행위 메세지 건수
    var getTodayRiskBehaviorSetTime;

    function getTodayRiskBehavior() {
        if (getTodayRiskBehaviorSetTime != null) window.clearTimeout(getTodayRiskBehaviorSetTime);
        ui.get({
            url: 'getTodayRiskBehavior.xcn',
            searchStr: '',
            success: function (data, total) {
                try {
                    $('#getTodayRiskTotalCnt').html(data.total + "<span>건</span>");
                    // off('riskBehavior.message.count');
                } catch (e) {
                }
            },
            error: function (status, message) {
                //ui.alertMsg(message);
            },
            complete: function () {
                getTodayRiskBehaviorSetTime = window.setTimeout(function () {
                    getTodayRiskBehavior();
                }, updateTime);
            }
        });
    }

    //금일 개인정보 메시지
    var getTodayPatternPrivacySetTime;

    function getTodayPatternPrivacy() {
        if (getTodayPatternPrivacySetTime != null) window.clearTimeout(getTodayPatternPrivacySetTime);
        ui.get({
            url: 'getTodayPatternPrivacy.xcn',
            searchStr: '',
            success: function (data, total) {
                $('#TodayPatternPrivacyTotalCnt').html(data.total + "<span>건</span>");
            },
            error: function (status, message) {
                //ui.alertMsg(message);
            },
            complete: function () {
                getTodayPatternPrivacySetTime = window.setTimeout(function () {
                    getTodayPatternPrivacy();
                }, updateTime);
            }
        });
    }

    //금일 1MB 이상 파일전송
    var getFileSendTotalSetTime;

    function getFileSendTotal() {

        if (getFileSendTotalSetTime != null) window.clearTimeout(getFileSendTotalSetTime);
        ui.get({
            url: 'getFileSendTotal.xcn',
            success: function (data, total) {
                $('#TodayfileSendTotalCnt').html(data.total + "<span>건</span>");
            },
            error: function (status, message) {
                //ui.alertMsg(message);
            },
            complete: function () {
                getFileSendTotalSetTime = window.setTimeout(function () {
                    getFileSendTotal();
                }, updateTime);
            }
        });
    }

    //서비스 타입 별 수집 건수(그룹웨어 )
    var getServiceDataLoggingSetTime;

    function getServiceDataLogging() {

        if (getServiceDataLoggingSetTime != null) window.clearTimeout(getServiceDataLoggingSetTime);
        ui.get({
            url: 'getServiceDataLogging.xcn',
            success: function (data, total) {
                console.log(data.facet);
                var GroupWareNum = 17;
                var todayGroupWareSum = data.facet[GroupWareNum][1];
                $('#todayGroupWareSum').html(todayGroupWareSum + "<span>건</span>");

            },
            error: function (status, message) {
                //ui.alertMsg(message);
            },
            complete: function () {
                getServiceDataLoggingSetTime = window.setTimeout(function () {
                    getServiceDataLogging();
                }, updateTime);
            }
        });
    }


</script>


<div id="xcn_mainWrap">
	<%--			대시보드 왼쪽 리스트들--%>
	<div class="left">

		<%--				금일 데이터 수집 건수--%>
		<div class="m_chartArea">
			<div>
				<h3>금일 데이터 수집 건수</h3>
				<%--				*****	여기에 select 넣기--%>
				<div class="mainlist">
					<div class="blueBg bornone">
						<span class="tit01">예약어 합계</span>
						<p id="TodayKeywordTotalCnt">-<span>건</span>
						</p>
					</div>
					<div class="greenBg bornone">
						<span class="tit02">그룹 웨어 데이터</span>
						<p id="todayGroupWareSum">-<span>건</span>
					</div>
					<div class="yellowBg bornone">
						<span class="tit03">비업무시간 데이터</span>
						<%--						******건수 아직 안함!!--%>
						<%--								<p>199,999<span class="text">건</span></p>--%>
					</div>
					<div class="redBg bornone">
						<span class="tit04">위험행위 메시지</span>
						<p id="getTodayRiskTotalCnt">-<span>건</span>
					</div>
					<div class="grayBg bornone">
						<span class="tit05">1MB 이상 파일전송</span>
						<p id="TodayfileSendTotalCnt">-<span>건</span>
					</div>
					<div class="blueBg bornone">
						<span class="tit06">개인정보 메시지</span>
						<p id="TodayPatternPrivacyTotalCnt">-<span>건</span>
					</div>
				</div>
			</div>
		</div>
		<%--금일 데이터 수집 건수 끝 ~~ --%>
		<%--				금일 패턴 수집 건수--%>

		<div class="m_chartArea">
			<div>
				<h3>금일 패턴 수집 건수</h3>
				<div class="mainlist">
					<div>
						<span class="tit07">여권번호 <span class="red_dot"></span> </span>
						<%--							<p class="blue">9,199,999<span class="text">건</span></p>--%>
					</div>
					<div>
						<span class="tit08">운전면허번호</span>
						<%--							<p class="blue">99,999<span class="text">건</span></p>--%>
					</div>
					<div>
						<span class="tit09">외국인등록번호</span>
						<%--							<p class="blue">199,999<span class="text">건</span></p>--%>
					</div>
					<div>
						<span class="tit10">주민번호</span>
						<%--							<p class="blue">99,999<span class="text">건</span></p>--%>
					</div>
					<div>
						<span class="tit11">카드번호</span>
						<%--							<p class="blue">199,999<span class="text">건</span></p>--%>
					</div>
					<div>
						<span class="tit12">확장자 변조 파일 <span class="red_dot"></span> </span>
						<%--							<p class="blue">99,999<span class="text">건</span></p>--%>
					</div>
				</div>
			</div>
		</div>

	</div>
</div>

<%--	<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>--%>
<%--	<form method="post" id="getMessageInfo" action="<c:url value="/ems/message.do"/>" target="_self">--%>
<%--		<input type="hidden" name="conditionParam" id="conditionParam"/>--%>
<%--	</form>--%>

<%@ include file="./dashboardContent.jsp" %>
