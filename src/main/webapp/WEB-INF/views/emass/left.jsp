<%@page import="com.xcurenet.common.util.config.Config"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<div class="nav-side-menu" style="position: fixed; left: 0px; top: 50px; height: 100%; z-index: 9998; width: 38px;display: none;"></div>
<div class="nav-side-menu" style="position: fixed; left: 0px; top: 50px; height: 100%; z-index: 9998; width: 38px;display: none;">
	<div class="menu-list">
		<ul id="menu-content" class="menu-content collapse out" pMenuId="DATA_MONITOR">
			<li menuId="DASHBOARD"><a href="<c:url value="/ems/index.do"/>"> <i class="fa fa-dashboard fa-lg"></i> <span><s:message code="DATA_MONITOR.DASHBOARD"/></span></a></li>
			
			<%if(Config.getBoolean("eikon.menu.enable")){ %>
			<li data-toggle="collapse" data-target="#messages" class="collapsed">
				<a href="#"> <i class="fa fa-envelope fa-lg"></i> <span><s:message code="DATA_MONITOR.MESSAGE"/></span><span class="arrow"></span></a>
			</li>
			<ul class="collapse subMenu" id="messages">
				<li menuId="MESSAGE_INFO"><a href="<c:url value="/ems/message.do"/>"> <i class="fa fa-envelope fa-lg"></i> <s:message code="DATA_MONITOR.MESSAGE_INFO"/></a></li>
				<li menuId="MESSAGE_SERVICE"><a href="<c:url value="/ems/msg/messenger.do"/>"> <i class="fa fa-envelope fa-lg"></i> <s:message code="DATA_MONITOR.MESSAGE_SERVICE"/></a></li>
				<li menuId="GENERATIVEAI_SERVICE"><a href="<c:url value="/ems/msg/generativeAi.do"/>"> <i class="fa fa-envelope fa-lg"></i> <s:message code="DATA_MONITOR.GENERATIVEAI_SERVICE"/></a></li>
				<li menuId="FILETRANSFER_SERVICE"><a href="<c:url value="/ems/msg/fileTransfer.do"/>"> <i class="fa fa-envelope fa-lg"></i> <s:message code="DATA_MONITOR.FILETRANSFER_SERVICE"/></a></li>
				<li menuId="NOTE_SERVICE"><a href="<c:url value="/ems/msg/note.do"/>"> <i class="fa fa-envelope fa-lg"></i> <s:message code="DATA_MONITOR.NOTE_SERVICE"/></a></li>
			</ul>
			<%}else{ %>
			<li menuId="MESSAGE_INFO"><a href="<c:url value="/ems/message.do"/>"> <i class="fa fa-envelope fa-lg"></i> <span><s:message code="DATA_MONITOR.MESSAGE_INFO"/></span></a></li>
			<%} %>
			<li menuId="INTEREST_USER"><a href="<c:url value="/ems/interestUser.do"/>"> <i class="fa fa-male fa-lg"></i> <span><s:message code="DATA_MONITOR.INTEREST_USER"/></span></a></li>
			<li menuId="RELATION_KEYWORD"><a href="<c:url value="/ems/searchWordInfo.do"/>"> <i class="fa fa-male fa-lg"></i> <span><s:message code="DATA_MONITOR.RELATION_KEYWORD"/></span></a></li>
			<li menuId="REGEX_PATTERN"><a href="<c:url value="/ems/regexPatternInfo.do"/>"> <i class="fa fa-male fa-lg"></i> <span><s:message code="DATA_MONITOR.REGEX_PATTERN"/></span></a></li>
			<!-- <li data-toggle="collapse" data-target="#interestuser" class="collapsed">
				<a href="#"> <i class="fa fa-male fa-lg"></i> <s:message code="DATA_MONITOR.INTEREST_USER"/><span class="arrow"></a>
			</li>
			<ul class="collapse subMenu" id="interestuser">
				<li menuId="INTEREST_USER"><a href="<c:url value="/ems/interestUser.do"/>"> <i class="fa fa-male fa-lg"></i> <s:message code="DATA_MONITOR.INTEREST_USER"/></a></li>
				<li menuId="INTEREST_USER_PROFILE"><a href="<c:url value="/ems/interestUserProfile.do"/>"> <i class="fa fa-male fa-lg"></i> 관심 사용자 프로필</a></li>
			</ul>
 			-->
			<li data-toggle="collapse" data-target="#statistics" class="collapsed">
				<a href="#"><i class="fa fa-area-chart fa-lg"></i> <span><s:message code="DATA_ANALYSIS.STAT_LABEL"/></span> <span class="arrow"></span></a>
			</li>

			<ul class="collapse subMenu" id="statistics">
				<li menuId="STAT_USER"><a href="<c:url value="/ems/usersStat.do"/>"> <i class="fa fa-pie-chart fa-lg"></i> <s:message code="DATA_ANALYSIS.STAT_USER"/></a></li>
				<li menuId="STAT_INTEREST"><a href="<c:url value="/ems/interestUserStat.do"/>"> <i class="fa fa-pie-chart fa-lg"></i> <s:message code="DATA_ANALYSIS.STAT_INTEREST"/></a></li>
				<li menuId="STAT_SENDER"><a href="<c:url value="/ems/senderStat.do"/>"> <i class="fa fa-pie-chart fa-lg"></i> <s:message code="DATA_ANALYSIS.STAT_SENDER"/></a></li>
				<li menuId="STAT_SVC"><a href="<c:url value="/ems/serviceStat.do"/>"> <i class="fa fa-pie-chart fa-lg"></i> <s:message code="DATA_ANALYSIS.STAT_SVC"/></a></li>
				<li menuId="STAT_KWD"><a href="<c:url value="/ems/keywordStat.do"/>"> <i class="fa fa-pie-chart fa-lg"></i> <s:message code="DATA_ANALYSIS.STAT_KWD"/></a></li>
				<li menuId="STAT_ATTACHTYPE"><a href="<c:url value="/ems/attachTypeStat.do"/>"> <i class="fa fa-pie-chart fa-lg"></i> <s:message code="DATA_ANALYSIS.STAT_ATTACHTYPE"/></a></li>
				<li menuId="STAT_ATTACHNAME"><a href="<c:url value="/ems/attachNameStat.do"/>"> <i class="fa fa-pie-chart fa-lg"></i> <s:message code="DATA_ANALYSIS.STAT_ATTACHNAME"/></a></li>
				<li menuId="STAT_URL"><a href="<c:url value="/ems/hostStat.do"/>"> <i class="fa fa-pie-chart fa-lg"></i> <s:message code="DATA_ANALYSIS.STAT_URL"/></a></li>
				<li menuId="STAT_ADMINREAD"><a href="<c:url value="/ems/adminReadStat.do"/>"> <i class="fa fa-pie-chart fa-lg"></i> <s:message code="DATA_ANALYSIS.STAT_ADMINREAD"/></a></li>
				<li menuId="STAT_DEVTRAFFIC"><a href="<c:url value="/ems/trafficStat.do"/>"> <i class="fa fa-pie-chart fa-lg"></i> <s:message code="DATA_ANALYSIS.STAT_DEVTRAFFIC"/></a></li>
				<%if(Config.isOCR){%>
				<li menuId="STAT_OCR"><a href="<c:url value="/ems/ocrStat.do"/>"> <i class="fa fa-pie-chart fa-lg"></i> OCR <s:message code="DATA_ANALYSIS.STAT_LABEL"/></a></li>
				<%}%>
			</ul>
						
			<li menuId="STAT_REPORT"><a href="<c:url value="/ems/report.do"/>"> <i class="fa fa-file-text-o fa-lg"></i> <span><s:message code="DATA_MONITOR.STAT_REPORT"/></span></a></li>
			
			<li menuId="RESERVATION_ALARM"><a href="<c:url value="/ems/reservationAlarm.do"/>">  <i class="fa fa-calendar fa-lg"></i> <span><s:message code="DATA_MONITOR.RESERVATION_ALARM"/></span></a></li>
			<li menuId="KEYWORD_MGMT"><a href="<c:url value="/ems/keywordInfo.do"/>"> <i class="fa fa-tasks fa-lg"></i> <span><s:message code="DATA_MONITOR.KEYWORD_MGMT"/></span></a></li>
			<%if(Config.getBoolean("consent.history.enable")){%>
			<%-- <li><a href="<c:url value="/ems/consent.do"/>"> <i class="fa fa-newspaper-o fa-lg"></i> 동의서 조회내역</a></li> --%>
			<%}if(Config.getBoolean("consent.menu.enable")){ %>
			<li menuId="CONSENT_MGMT"><a href="<c:url value="/ems/consent.do"/>"> <i class="fa fa-flask fa-lg"></i> <span><s:message code="DATA_MONITOR.CONSENT_MGMT"/></span></a></li>
			<%}%>
		</ul>
	</div>
</div>
