<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.web.servlet.i18n.SessionLocaleResolver" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.config.Config"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="java.util.Locale" %>
<%@ page import="com.xcurenet.config.service.ConfigAdminService" %>
<%@ page import="com.xcurenet.common.util.SpringContextUtil" %>
<%@ page import="com.xcurenet.config.service.ConfigAdminVO" %>
<%@ page import="java.util.Map"%>
<%@ page import="com.xcurenet.audit.service.Operation"%>
<%@ page import="com.xcurenet.emass.message.service.EmsMessageService"%>
<%@ page import="java.util.List" %>
<%@ page import="com.xcurenet.emass.service.service.ServiceGroupVO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String contentPath = request.getContextPath();
    boolean isIPv6 = Config.isIPv6;
    boolean isOCR = Config.isOCR;
    boolean consent = Config.getBoolean("consent.menu.enable");
    String systemLanguage = Common.nvl(Locale.getDefault(), "ko");
    String adminLanguage = systemLanguage;
    if(request.getRequestURI().toString().indexOf("login.jsp") == -1) adminLanguage = Common.nvl(session.getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME), "ko");
%>
<script>
    let contextRoot = '<%=contentPath%>';
    let consent = '<%=consent%>';
    let isIPv6 = '<%=isIPv6%>';
    let isOCR = '<%=isOCR%>';
</script>

<script for="InnoFD" event="OnDownloadComplete">
    document.InnoFD.RemoveAllFiles( );
    ui.alertMsg("<s:message code="common.msg.down.complete"/>", null, 2000);
</script>

<script type="text/javascript" src="<c:url value="/js/chartAPI.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/InnoFD.js"/>"></script>