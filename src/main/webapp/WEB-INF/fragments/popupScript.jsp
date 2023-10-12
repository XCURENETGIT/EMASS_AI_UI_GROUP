<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@page import="com.xcurenet.common.util.config.Config"%>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="java.util.Locale" %>
<%@ page import="org.springframework.web.servlet.i18n.SessionLocaleResolver" %>
<%
    String contentPath = request.getContextPath();
    boolean isIPv6 = Config.isIPv6;
    boolean isOCR = Config.isOCR;
    boolean consent = Config.getBoolean("consent.menu.enable");
    String systemLanguage = Common.nvl(Locale.getDefault(), "ko");
    String adminLanguage = systemLanguage;
    if(request.getRequestURI().toString().indexOf("login.jsp") == -1) adminLanguage = Common.nvl(session.getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME), "ko");

    String firstAdminYn = Common.getFirstAdminYn(session);
    String adminType    = Common.getAdminType(session);
    String statType = Common.nvl(request.getParameter("statType"));
    String infoFeedbackYn = Common.getInfoFeedbackYn(session);
    String epmsgType = Config.getString("message.epmsg.val");
    boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
    boolean infoHynixConf = Config.getBoolean("info.hynix.used");
    String recvsJikgub = Config.getString("recvs.jikgub.use");
%>

<script>
    let contextRoot = '<%=contentPath%>';
    let consent = '<%=consent%>';
    let isIPv6 = '<%=isIPv6%>';
    let isOCR = '<%=isOCR%>';
</script>