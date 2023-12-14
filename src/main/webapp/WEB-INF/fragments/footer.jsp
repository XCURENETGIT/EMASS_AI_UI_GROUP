<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%
    String footer_type = Common.nvl(Common.getParam(request).get("footer_type"));
%>

<footer class="unselectable">
</footer>
<iframe id="ExcelDown" name="ExcelDown" src="about:blank;" style="display: none;" height="0" width="0" ></iframe>
