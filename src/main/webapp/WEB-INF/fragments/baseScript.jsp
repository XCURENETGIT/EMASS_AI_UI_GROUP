<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.web.servlet.i18n.SessionLocaleResolver" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.config.Config"%>
<%@ page import="java.util.Locale" %>
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
