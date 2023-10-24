<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@page import="com.xcurenet.common.util.config.Config"%>
<%
%>
<div class="nav-side-menu" style="position:fixed;left: 0px; top:50px; width: 225px;height: 100%;z-index: 9998"></div>
<div class="nav-side-menu" style="position:fixed;left: 0px; top:50px; width: 225px;height: 100%;z-index: 9998">
	<div class="menu-list">
		<ul id="menu-content" class="menu-content collapse out" pMenuId="OPERATION_MGMT">
			<li menuId="DEV_INFO"><a href="<c:url value="/commons/deviceInfo.do"/>"> <i class="fa fa-desktop fa-lg"></i> <s:message code="OPERATION_MGMT.DEV_INFO"/></a></li>
			<li menuId="DEV_EVENTLOG"><a href="<c:url value="/commons/eventLog.do"/>"> <i class="fa fa-cog fa-bell"></i> <s:message code="OPERATION_MGMT.DEV_EVENTLOG"/></a></li>
			<li menuId="ORG_MGMT"><a href="<c:url value="/commons/organizationInfo.do"/>"> <i class="fa fa-users fa-lg"></i> <s:message code="POLICY_SETUP.ORG_MGMT"/></a></li>
			<li menuId="USER_MGMT"><a href="<c:url value="/commons/userInfo.do"/>"> <i class="fa fa-user fa-lg"></i> <s:message code="POLICY_SETUP.USER_MGMT"/></a></li>
			<li menuId="USER_GROUP_MGMT"><a href="<c:url value="/commons/userGroup.do"/>"> <i class="fa fa-user-circle fa-lg"></i> <s:message code="OPERATION_MGMT.USER_GROUP_MGMT"/></a></li>
			<li menuId="BUSI_IPRANGE"><a href="<c:url value="/commons/ipRange.do"/>"> <i class="fa fa-building fa-lg"></i> <s:message code="POLICY_SETUP.BUSI_IPRANGE"/></a></li>
			<li menuId="CODE_INFO"><a href="<c:url value="/commons/codeInfo.do"/>"> <i class="fa fa-list-ul fa-lg"></i> <s:message code="OPERATION_MGMT.CODE_INFO"/></a></li>
			<li menuId="ADMIN_MGMT"><a href="<c:url value="/commons/admin.do"/>"> <i class="fa fa-unlock-alt fa-lg"></i> <s:message code="OPERATION_MGMT.ADMIN_MGMT"/></a></li>
			<li data-toggle="collapse" data-target="#holidays" class="collapsed">
				<a href="#"> <i class="fa fa-calendar fa-lg"></i> <s:message code="OPERATION_MGMT.HOLIDAY_LABEL"/><span class="arrow"></span></a>
			</li>
			<ul class="collapse subMenu" id="holidays">
				<li menuId="HOLIDAY_BUSI"><a href="<c:url value="/commons/holidayBusiness.do"/>"> <i class="fa fa-calendar-check-o fa-lg"></i> <s:message code="OPERATION_MGMT.HOLIDAY_BUSI"/></a></li>
				<li menuId="HOLIDAY_LEGAL"><a href="<c:url value="/commons/holidayLegal.do"/>"> <i class="fa fa-calendar-o fa-lg"></i> <s:message code="OPERATION_MGMT.HOLIDAY_LEGAL"/></a></li>
			</ul>
			<%if(Config.getBoolean("consent.menu.enable")){ %>
				<li menuId="SEARCH_LOG"><a href="<c:url value="/commons/searchLog.do"/>"> <i class="fa fa-pencil fa-lg"></i> <s:message code="OPERATION_MGMT.SEARCH_LOG"/></a></li>
			<%} %>
			<li menuId="AUDIT_LOG"><a href="<c:url value="/commons/auditLog.do"/>"> <i class="fa fa-pencil-square fa-lg"></i> <s:message code="OPERATION_MGMT.AUDIT_LOG"/></a></li>
			<%-- <c:if test="${(_USERCREDENTIAL_.firstAdminYn eq 'Y')}">
			<li><a href="<c:url value="/commons/xcnLog.do"/>"> <i class="fa fa-exclamation fa-lg"></i> <s:message code="OPERATION_MGMT.SYS_LOG"/></a></li>
			</c:if> --%>
			<%-- <li><a href="<c:url value="/commons/scheduler.do"/>"> <i class="fa fa-calendar fa-lg"></i>Shceduler</a></li> --%>
		</ul>
	</div>
</div>