<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.xcurenet.common.ntp.NtpScheduler" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<div id="header">
    <div class="allmenu">
        <a href="#"> <img src="<c:url value="/img/icon_top_menu.png"/>" alt="allmenu"></a>
    </div>
    <div class="headerArea">
        <h1><a href="javascript:;" id="menuMainBtn" onclick="goMainPage();"><img src="<c:url value="/img/logo.png"/>" height="24px" alt="emass pro"></a></h1>
        <div class="my_left">
            <span><a href="#"><img src="<c:url value="/img/icon_top_user.png"/>" alt="mypage"></a></span>
            <span>
                <select>

<%--                 <a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-user"></span> ${_USERCREDENTIAL_.adminId}(${_USERCREDENTIAL_.adminName}) <span class="caret"></span></a>--%>
<%--                    <ul class="dropdown-menu">--%>
<%--                        <li><a href="javascript:;" id="changeLanguageBtn"><span class="glyphicon glyphicon-text-color"></span> <s:message code="common.msg.language"/></a></li>--%>
<%--                        <c:if test="${_USERCREDENTIAL_.loginType ne 'S'}">--%>
<%--                            <li><a href="javascript:;" id="changePasswordBtn"><span class="glyphicon glyphicon-th-list"></span> <s:message code="OPERATION_MGMT.CHANGE_PW"/></a></li>--%>
<%--                        </c:if>--%>
<%--                    </ul>--%>


                    <option selected disabled hidden>Sysadmin 시스템관리자</option>
                    <option>언어변경</option>
                    <option>비밀번호 변경</option>
                    <option><li><a href="javascript:;" id="logoutBtn"><span class="glyphicon glyphicon-log-out"></span> <s:message code="OPERATION_MGMT.LOGOUT"/></a></li></option>
                </select>
            </span>
        </div>
        <div class="ipinfo_right">
            <p class="ntp">
                <span class="top_flag01"></span>
                <span class="fb600">NTP-123.123.1.0</span>
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
