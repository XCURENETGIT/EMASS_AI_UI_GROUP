<%@page import="com.xcurenet.common.util.Common"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String message = Common.nvl(request.getSession().getAttribute("message"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8;no-cache" />
<title>:: 접근이 금지된 페이지 입니다.</title>
</head>

<body>

<div id="wrap">
    <div id="container" style="padding-left: 150px;">
        <h2>죄송합니다.<br />요청하신 페이지에 접근 권한이 없습니다.</h2>
        <div class="content">
            <p><%=message %></p>
        </div>
    </div>
</div>

</body>
</html>
