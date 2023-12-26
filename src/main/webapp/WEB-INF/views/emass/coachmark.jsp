<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<link rel="stylesheet" href="<c:url value="/css/dashboard.css"/>"/>
<%
    String infoFeedbackYn = Common.getInfoFeedbackYn(session);
    boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
    String adminType = Common.getAdminType(session);
    String systemArch = Config.getString("system.arch");
    pageContext.setAttribute("arch", systemArch);
%>
<html>
<head>
    <title>VENUS / EMASS LTH</title>
</head>
<body>
    <div>
        ddddd
        ddddd
    </div>
</body>
</html>
