<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%
    String footer_type = Common.nvl(Common.getParam(request).get("footer_type"));
%>
<footer class="unselectable" style="position: fixed; bottom: 0; height: 30px; background-color:none;z-index: -1;width: 100%;">
</footer>
