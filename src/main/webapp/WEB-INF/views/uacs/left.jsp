<%@page import="com.xcurenet.common.util.config.Config"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<div class="nav-side-menu" style="position:fixed;left: 0px; float: left; top:50px; width: 225px;height: 100%;"></div>
<div class="nav-side-menu" style="position:relative;left: 0px; float: left; width: 225px;height: 100%;">
	<div class="menu-list">
		<ul id="menu-content" class="menu-content collapse out" pMenuId="POLICY_SETUP">
			<li menuId="POLICY_NOLOG"><a href="<c:url value="/uacs/filterInfo.do"/>"> <i class="fa fa-unlink fa-lg"></i> <s:message code="POLICY_SETUP.POLICY_NOLOG"/></a></li>
		</ul>
	</div>
</div>