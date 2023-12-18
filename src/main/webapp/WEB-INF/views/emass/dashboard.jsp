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
		//
        // getTodayKeywordDetection();
        // getTodayRiskBehavior();
        // getTodayPatternPrivacy();
        // getFileSendTotal();
        // getServiceDataLogging();
        // getFile();
		//

		getTodayDataStatus();


    })

	function getTodayDataStatus(){
		ui.get({
			url: 'getTodayDataStatus.xcn',
			searchStr: '',
			success: function (data, total) {
				console.log("data: " + data);

			},
			error: function (status, message) {
				//ui.alertMsg(message);
			},
			complete: function () {

			}
		});
	}


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

    //서비스 타입 별 수집 건수(그룹웨어), 금일 서비스별 데이터 수집 비율
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

                printChart(data.facet);

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

    //첨부파일 수집 현황
    var getFileSetTime;
    function getFile() {
        if (getFileSetTime != null) window.clearTimeout(getFileSetTime);
        ui.get({
            url: 'getTodayFile.xcn',
            success: function (data, total) {

            },
            error: function (status, message) {
                //ui.alertMsg(message);
            },
            complete: function () {
                getFileSetTime = window.setTimeout(function () {
                    getFile();
                }, updateTime);
            }
        });
    }


    // //금일 패턴 수집 건수
    // var getServicePatternSetTime;
    // function getServiceDataLogging() {
    //
    //     if (getServicePatternSetTime != null) window.clearTimeout(getServicePatternSetTime);
    //     ui.get({
    //         url: 'getAllTodayPatternPrivacy.xcn',
    //         success: function (data, total) {
    //             // console.log(data.facet);
    //
    //         },
    //         error: function (status, message) {
    //             //ui.alertMsg(message);
    //         },
    //         complete: function () {
    //             getServicePatternSetTime = window.setTimeout(function () {
    //                 getServiceDataLogging();
    //             }, updateTime);
    //         }
    //     });
    // }


    var chart = null;

    function printChart(data) {
        $('#svcDataChart').html('');

        if (data.length == 0) {
            $('#svcDataChart').html('<s:message code="dashboard.message.nodata.today"/>');
            return;
        }
        $('#svcDataChart').highcharts({
            chart: {
                type: 'column',
                options3d: {
                    enabled: true,
                    alpha: 10,
                    beta: 0,
                    depth: 50,
                    viewDistance: 25
                }
            },
            exporting: {
                enabled: false
            },
            credits: {
                enabled: false
            },
            title: {
                text: ''
            },
            xAxis: {
                type: 'category',
                labels: {
                    rotation: -20,
                    x: 25,
                    style: {
                        fontSize: '13px',
                        fontFamily: 'DINLig, Verdana, sans-serif'
                    }
                }, gridLineWidth: 0
            },
            yAxis: {
                type: 'logarithmic',
                min: 1,
                title: {
                    text: '(<s:message code="common.msg.count"/>)',
                    rotation: 0
                }
            },
            legend: {
                enabled: false
            },
            tooltip: {
                pointFormat: '<s:message code="dashboard.collect.data_count"/> : <b>{point.y:,.0f} (<s:message code="common.msg.cnt"/>)</b>'
            },
            series: [{
                name: 'Population',
                data: data,
                dataLabels: {
                    enabled: true,
                    format: '{point.y:,.0f}',
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                }
            }]
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
		<%--				금일 패턴 수집 건수 끝!!--%>
		<%--			금일 서비스별 데이터 수집 비율 시작--%>
		<div class="m_grapha">
			<div class="graphaBox">
				<h3>금일 서비스별 데이터 수집 비율</h3>
				<div class="bordd" id="svcDataChart">
				</div>
			</div>
			<%--			금일 서비스별 데이터 수집 비율 끝!!--%>

			<%--			금일 첨부파일 수집 현황 시작!!--%>
			<div class="graphaBox">
				<h3>금일 첨부파일 수집 현황</h3>
				<div class="bordd">
					<div class="main_tab">
						<button class="tablink ppt" onclick="openCity('PPT', this, '#E7443A')" id="defaultOpen">PPT</button>
						<button class="tablink word" onclick="openCity('Word', this, '#3770C3')">Word</button>
						<button class="tablink excel" onclick="openCity('Excel', this, '#3B9A45')">Excel</button>
						<button class="tablink pdf" onclick="openCity('PDF', this, '#B7433B')">PDF</button>
					</div>
					<div id="PPT" class="tabcontent">
						<ul>
							<li>
								<p>
									~10MB
									<span>199,999 건</span>
								</p>
							</li>
							<li>
								<p>
									~50MB
									<span>1 건</span>
								</p>
							</li>
							<li>
								<p>
									~100MB
									<span>9,999 건</span>
								</p>
							</li>
							<li>
								<p>
									~150MB
									<span>77 건</span>
								</p>
							</li>
							<li>
								<p>
									~200MB
									<span>9,999 건</span>
								</p>
							</li>
							<li>
								<p>
									~250MB
									<span>9,999 건</span>
								</p>
							</li>
						</ul>
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
<script>

    function openCity(cityName, elmnt, color) {
        var i, tabcontent, tablink;
        tabcontent = document.getElementsByClassName("tabcontent");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablink");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].style.backgroundColor = "#f5f5f5";
            tablinks[i].style.color = "black";
        }
        document.getElementById(cityName).style.display = "block";
        elmnt.style.backgroundColor = color;
        elmnt.style.color = "white";

    }

    // Get the element with id="defaultOpen" and click on it
    document.getElementById("defaultOpen").click();

</script>

<script>
    function openCity2(evt, cityName) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("text_tabcontent");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(cityName).style.display = "block";
        evt.currentTarget.className += " active";
    }

    document.getElementById("defaultOpen2").click();

</script>

<script>
    function openCity3(evt, cityName) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("text_tabcontent2");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablinks2");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(cityName).style.display = "block";
        evt.currentTarget.className += " active";
    }

    document.getElementById("defaultOpen3").click();


</script>
