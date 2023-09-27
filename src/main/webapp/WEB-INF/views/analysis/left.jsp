<%@page import="com.xcurenet.common.util.config.Config"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<div class="nav-side-menu" style="position:fixed;left: 0px; float: left; top:50px; width: 225px;height: 100%;"></div>
<div class="nav-side-menu" style="position:relative;left: 0px; float: left; width: 225px;height: 100%;">
	<div class="menu-list">
		<ul id="menu-content" class="menu-content collapse out" pMenuId="DATA_ANALYSIS">
			<li menuId="ANALYSIS_RELATION"><a href="<c:url value="/analysis/dataRelation"/>"> <i class="fa fa-share-alt fa-lg"></i> <s:message code="DATA_ANALYSIS.ANALYSIS_RELATION"/></a></li>
			<li menuId="ANALYSIS_FLUCTUATION"><a href="<c:url value="/analysis/usageCompare"/>"> <i class="fa fa-area-chart fa-lg"></i> <s:message code="DATA_ANALYSIS.ANALYSIS_FLUCTUATION"/></a></li>
			<li menuId="ANALYSIS_CUSTOM"><a href="<c:url value="/analysis/dataFreedom"/>"> <i class="fa fa-cube fa-lg"></i> <s:message code="DATA_ANALYSIS.ANALYSIS_CUSTOM"/></a></li>
		</ul>
	</div>
</div>