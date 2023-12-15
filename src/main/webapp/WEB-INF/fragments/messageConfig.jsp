<%@ page import="org.springframework.web.servlet.i18n.SessionLocaleResolver" %>
<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="java.util.Locale" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String contentPath = request.getContextPath();
  boolean isIPv6 = Config.isIPv6;
  boolean isOCR = Config.isOCR;
  boolean consent = Config.getBoolean("consent.menu.enable");
  String systemLanguage = Common.nvl(Locale.getDefault(), "ko");
  String adminLanguage = systemLanguage;
  if (request.getRequestURI().toString().indexOf("login.jsp") == -1)
    adminLanguage = Common.nvl(session.getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME), "ko");
%>
<script>
  var contextRoot = '<%=contentPath%>';
  var consent = '<%=consent%>';
  var isIPv6 = '<%=isIPv6%>';
  var isOCR = '<%=isOCR%>';


</script>