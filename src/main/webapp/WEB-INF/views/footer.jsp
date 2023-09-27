<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%
	String footer_type = Common.nvl(Common.getParam(request).get("footer_type"));
%>
<footer class="unselectable">
<%if(Common.isEmpty(footer_type)){%>
	<div class="row">
		<div class="col-xs-5">
			<!-- <span class="item">
				<a href="#">스킨설정</a>
			</span> -->
		</div>
		<div class="col-xs-7 text-right" style="font-size: 11px;height: 100%;line-height: 20px;">
			<span class="item">
				<s:message code="login.login.date"/> : ${sessionScope.sessionLastLoginDt}
			</span>
			<span class="item"> 
				<s:message code="login.login.ip"/> : <%=Common.nvl(request.getRemoteAddr(), "-")%>
			</span>
		</div>
	</div>
<%}%>
</footer>
