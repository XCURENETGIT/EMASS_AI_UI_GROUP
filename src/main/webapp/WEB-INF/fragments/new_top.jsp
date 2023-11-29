<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.xcurenet.common.ntp.NtpScheduler" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%
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
                <span id="ntpColor" class="top_flag01"></span>&nbsp;
                <%} else if(Common.isEquals(ntpInfo.getString("status"), "unsync")) {%>
                <span id="ntpColor" class="top_flag02"></span>&nbsp; <%-- 추후 오렌지색 변경 --%>
                <%} else {%>
                <span id="ntpColor" class="top_flag03"></span>&nbsp;  <%-- 추후 레드 변경--%>
                <%}%>
                <span id="ntpStatus" class="fb600">NTP - <%=Common.nvl(ntpInfo.get("ntpServer")) %></span>
            </p>
            <p>
                <span class="graybbb">접속시간:23.10.09</span>
                <span class="graybbb">접속IP:23.10.09</span>
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
        let ntpStr = 'NTP - ' + ntpServer;
        let titleStr = '';
        if(lv==='info') {
            $('#ntpColor').removeClass().addClass('top_flag01');
            titleStr = '<s:message code="trap.message.ntp.sync"/>';
        } else if(lv==='warning') {
            $('#ntpColor').removeClass().addClass('top_flag02');
            titleStr = '<s:message code="trap.message.ntp.unsync"/>';
        } else {
            $('#ntpColor').removeClass().addClass('top_flag03');
            titleStr = '<s:message code="trap.message.ntp.unconnect"/>';
        }
        $('#ntpStatus').html(ntpStr);
        $('#ntpStatus').parent().attr('title', titleStr);
    }
</script>
