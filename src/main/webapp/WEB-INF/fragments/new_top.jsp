<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.xcurenet.common.ntp.NtpScheduler" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.xcurenet.config.service.ConfigAdminService" %>
<%@ page import="com.xcurenet.common.util.SpringContextUtil" %>
<%@ page import="javax.json.Json" %>
<%@ page import="javax.json.JsonObject" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%
	String lo = Common.getLocale(session).toString();
	JSONObject ntpInfo = NtpScheduler.ntpStatus;
%>
<iframe id="ExcelDown" name="ExcelDown" src="about:blank;" style="display: none;" height="0" width="0" ></iframe>C

<div class="modal" id="changePasswordPop" data-backdrop="static">
	<div class="modal-content">
		<div class="modalHead">
			<h2><s:message code="OPERATION_MGMT.CHANGE_PW"/></h2>
			<span class="close" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalCon">
			<div class="modalTop">
				<h3>비밀번호 변경</h3>
				<p>
					<span class="red_dot veralign_middle"></span>
					필수 입력 사항입니다.
				</p>
			</div>
			<div class="modalbody">
				<div class="row">
					<div class="col-35">
						<label for="attachTypePopInput" class="fname"><s:message code="base.current.pw"/></label>
						<span class="red_dot"></span>
					</div>
					<div class="col-65">
						<input type="password" class="w100" id="current_password" placeholder="<s:message code="base.current.pw"/>" required
						       autocomplete="off">
					</div>
				</div>
				<div class="row">
					<div class="col-35">
						<label for="attachDescPopInput" class="fname"><s:message code="base.changed.pw"/></label>
						<span class="red_dot"></span>
					</div>
					<div class="col-65">
						<input type="password" class="w100" id="change_password" placeholder="<s:message code="base.changed.pw"/>" required
						       autocomplete="off">
					</div>
				</div>
				<div class="row">
					<div class="col-35">
						<label for="attachDescPopInput" class="fname"><s:message code="base.changeconfirm.pw"/></label>
						<span class="red_dot"></span>
					</div>
					<div class="col-65">
						<input type="password" class="w100" id="current_confirm_password"
						       placeholder="<s:message code="base.changeconfirm.pw"/>" required autocomplete="off">
					</div>
				</div>
			</div>

			<div class="modalfooter">
				<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
				<button type="button" class="pop_btn02" accesskey="S" id="changePasswordSaveBtn"><s:message code="common.msg.change"/></button>
			</div>
		</div>
	</div>
</div>


<div id="header">
	<div class="allmenu">
		<a href="#"> <img src="<c:url value="/img/icon_top_menu.png"/>" alt="allmenu"></a>
	</div>
	<div class="headerArea">
		<h1><a href="<c:url value="/ems/dashboard.do"/>" id="menuMainBtn" onclick="goMainPage();"><img
				src="<c:url value="/img/logo.png"/>" height="24px" alt="EMASS AI"></a></h1>
		<div class="my_left">
			<span><a href="#"><img src="<c:url value="/img/icon_top_user.png"/>" alt="mypage"></a></span>
			<div class="myDropdown">
				<span>${_USERCREDENTIAL_.adminId}(${_USERCREDENTIAL_.adminName})</span>
				<span> &#9662;</span>
				<div class="dropdown-content">
					<c:if test="${_USERCREDENTIAL_.loginType ne 'S'}">
						<a href="javascript:;" id="changePasswordBtn"></span>
							<s:message code="OPERATION_MGMT.CHANGE_PW"/></a>
					</c:if>
					<a href="javascript:;" id="logoutBtn">
						<s:message code="OPERATION_MGMT.LOGOUT"/></a>
				</div>
			</div>
			<div class="myDropdown">
				<%if (Common.isEquals(lo, "ko")) {%>
				<span><img src="<c:url value="/img/icon_top_kor.png"/>" alt="kor"></span>
				<span id="spanLan">KOR &#9662;</span>
				<% } else {%>
				<span><img src="<c:url value="/img/icon_top_eng.png"/>" alt="eng"></span>
				<span id="spanLan">ENG &#9662;</span>
				<%}%>
				<div class="dropdown-content" >
					<a id="korLan" data-value="ko"><img src="<c:url value="/img/icon_top_kor.png"/>" alt="KOR">&nbsp;KOR</a>

					<a id="EnLan" data-value="en" ><img src="<c:url value="/img/icon_top_eng.png"/>" alt="ENG">&nbsp;ENG</a>
				</div>
			</div>
		</div>

		<div class="ipinfo_right">
			<p class="ntp">
				<%if (Common.isEquals(ntpInfo.getString("status"), "sync")) {%>
				<span id="ntpColor" class="top_flag01"></span>&nbsp;
				<%} else if (Common.isEquals(ntpInfo.getString("status"), "unsync")) {%>
				<span id="ntpColor" class="top_flag02"></span>&nbsp; <%-- 추후 오렌지색 변경 --%>
				<%} else {%>
				<span id="ntpColor" class="top_flag03"></span>&nbsp; <%-- 추후 레드 변경--%>
				<%}%>

				<%if (!Common.isEquals(ntpInfo.getString("ntpServer"), "")) {%>
				<span id="ntpStatus" class="fb600">Chrony - <%=Common.nvl(ntpInfo.get("ntpServer")) %></span>
				<%} else {%>
				<span id="ntpStatus" class="fb600">Chrony - <s:message code="trap.message.Chrony.server.nosearch"/></span>
				<%}%>
			</p>
			<p>
				<span class="graybbb"><s:message code="login.login.date"/> : ${sessionScope.sessionLastLoginDt}</span>
				<span class="graybbb"><s:message code="login.login.ip"/> : <%=Common.nvl(request.getRemoteAddr(), "-")%></span>
			</p>

			<p>
				<a href="#"><img src="<c:url value="/img/icon_top_bell.png"/>" alt="알림"></a>
			</p>
		</div>


	</div>
</div>
<div id="replace_html" style="display: none;"></div>

<script type="text/javascript">

    function goMainPage() {
        document.location.href = $('.topMenuLi:eq(0) .topMenu').attr('href');
    }

    function changeMainMenu(val) {
        $('.topMenuLi:eq(0) .topMenu').attr('href', '<c:url value="/ems/dashboard.do?menuKey="/>' + val);
    }
    function changeNTP(ntpServer, lv) {
        let ntpStr = 'Chrony - ' + ntpServer;
        if (ntpServer =="") ntpStr = 'Chrony - ' + '<s:message code="trap.message.Chrony.server.nosearch"/>';
        let titleStr = '';
        if (lv === 'info') {
            $('#ntpColor').removeClass().addClass('top_flag01');
            titleStr = '<s:message code="trap.message.Chrony.sync"/>';
        } else if (lv === 'warning') {
            $('#ntpColor').removeClass().addClass('top_flag02');
            titleStr = '<s:message code="trap.message.Chrony.unsync"/>';
        } else {
            $('#ntpColor').removeClass().addClass('top_flag03');
            titleStr = '<s:message code="trap.message.Chrony.unconnect"/>';
        }
        $('#ntpStatus').html(ntpStr);
        $('#ntpStatus').parent().attr('title', titleStr);
    }


</script>
