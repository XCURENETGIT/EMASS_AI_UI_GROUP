<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	response.setHeader("Cache-control","no-cache,no-store,must-revalidate");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8;no-cache" />
<title>:: 페이지를 찾을 수 없습니다.</title>
</head>
<body>
<div id="wrap">
    <div id="container" style="padding-left: 150px;">
        <h2>죄송합니다.<br />요청하신 페이지를 찾을 수 없습니다.</h2>
        <div class="content">
            <p>방문하시려는 페이지의 주소가 잘못 입력되었거나,<br />페이지의 주소가 변경 혹은 삭제되어 요청하신 페이지를 찾을 수 없습니다.</p>
            <p>입력하신 주소가 정확한지 다시 한번 확인해 주시기 바랍니다.</p>
            <p>감사합니다.</p>
            <%if ( session.getAttribute("userid") != null ){ %>
            <p><a href="<%=request.getContextPath()%>/" target="_self" >메인 화면으로 이동</a></p>
            <%} else {%>
            <p><a href="<%=request.getContextPath()%>/login.do" target="_self" >로그인 페이지로 이동</a></p>
            <%}%>
        </div>
    </div>
</div>

</body>
</html>
