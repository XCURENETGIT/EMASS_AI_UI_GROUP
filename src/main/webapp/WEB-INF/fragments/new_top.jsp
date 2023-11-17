<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.xcurenet.common.ntp.NtpScheduler" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%

String headerYn = (String) request.getAttribute("headerYn");
String headerCloseYn = (String) request.getAttribute("headerCloseYn");
String menuKey = (String) request.getAttribute("menuKey");

boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
boolean infoHynixConf = Config.getBoolean("info.hynix.used");
String infoFeedbackYn = Common.getInfoFeedbackYn(session);
JSONObject ntpInfo =  NtpScheduler.ntpStatus;

%>


<div id="header">
    <div class="allmenu">
        <a href="#"> <img src="<c:url value="/img/icon_top_menu.png"/>" alt="allmenu"></a>
    </div>
    <div class="headerArea">
        <h1><a href="javascript:;" id="menuMainBtn" onclick="goMainPage();"><img src="<c:url value="/img/logo.png"/>" height="24px" alt="emass pro"></a></h1>
        <div class="my_left">
            <span><a href="#"><img src="<c:url value="/img/icon_top_user.png"/>" alt="mypage"></a></span>
            <div class="myDropdown">
                <span>${_USERCREDENTIAL_.adminId}(${_USERCREDENTIAL_.adminName})</span>
                <div class="dropdown-content">
                 <a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-user"></span> ${_USERCREDENTIAL_.adminId}(${_USERCREDENTIAL_.adminName}) <span class="caret"></span></a>
                    <c:if test="${_USERCREDENTIAL_.loginType ne 'S'}">
                     <a href="javascript:;" id="changePasswordBtn"><span class="glyphicon glyphicon-th-list"></span> <s:message code="OPERATION_MGMT.CHANGE_PW"/></a>
                    </c:if>
                  <a href="javascript:;" id="logoutBtn"><span class="glyphicon glyphicon-log-out"></span> <s:message code="OPERATION_MGMT.LOGOUT"/>
                </div>
              </div>
        </div>
        <div class="ipinfo_right">
            <p class="ntp">
                <%if(Common.isEquals(ntpInfo.getString("status"), "sync")) {%>
                <span class="top_flag01"></span>&nbsp;
                <%} else if(Common.isEquals(ntpInfo.getString("status"), "unsync")) {%>
                <span class="top_flag01"></span>&nbsp; <%-- 추후 오렌지색 변경 --%>
                <%} else {%>
                <span class="top_flag01"></span>&nbsp;  <%-- 추후 레드 변경--%>
                <%}%>
                <a href="javascript:;"  class="graybbb" id="ntpStatus"> NTP - <%=Common.nvl(ntpInfo.get("ntpServer")) %>  </a>
            </p>
            <p>
                <a href="#"><img src="<c:url value="/img/icon_top_bell.png"/>" alt="알림"></a>
            </p>
        </div>

    </div>
</div>


<script type="text/javascript">

    function goMainPage(){
        document.location.href = $('.topMenuLi:eq(0) .topMenu').attr('href');
    }

    function changeMainMenu(val){
        $('.topMenuLi:eq(0) .topMenu').attr('href', '<c:url value="/ems/dashboard.do?menuKey="/>' + val);
    }

    function changeNTP(ntpServer, lv) {
        var ntpStr = 'NTP - ' + ntpServer;
        var titleStr = '';

        if(lv=='info') {
            ntpStr += '&nbsp;<span class="fa fa-soild fa-circle fa-lg" style="color:lightgreen;"></span>';
            titleStr = '<s:message code="trap.message.ntp.sync"/>';
        } else if(lv=='warning') {
            ntpStr += '&nbsp;<span class="fa fa-soild fa-circle fa-lg" style="color:orange;"></span>';
            titleStr = '<s:message code="trap.message.ntp.unsync"/>';
        } else {
            ntpStr += '&nbsp;<span class="fa fa-soild fa-circle fa-lg" style="color:red;"></span>';
            titleStr = '<s:message code="trap.message.ntp.unconnect"/>';
        }

        $('#ntpStatus').html(ntpStr);
        $('#ntpStatus').parent().attr('title', titleStr);
    }
</script>
