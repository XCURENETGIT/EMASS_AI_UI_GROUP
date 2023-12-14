<%@ page import="org.springframework.web.servlet.i18n.SessionLocaleResolver" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"  %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <tiles:insertAttribute name="baseCss" />
    <tiles:insertAttribute name="baseJs" />
</head>
<body>
    <tiles:insertAttribute name="body"/>
    <tiles:insertAttribute name="footer" ignore="true"/>
</body>
</html>
