<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>EMASS AI :: 페이지 오류 입니다.</title>
</head>

<body>

<div id="wrap">
    <div id="container" style="padding-left: 150px;">
        <h2>죄송합니다.<br />서버 에러가 발생 하였습니다.</h2>
        <div class="content">
            <p>문제가 지속 될 경우 서버 담당자에게 문의 하시기 바랍니다.</p>
            <%if ( session.getAttribute(com.xcurenet.common.util.Common.SESSION_CREDENTIAL) != null ){ %>
            <p><a href="javascript:void(0)" onclick="top.location.href='<%=request.getContextPath()%>/index.do'" target="_self">메인 화면으로 이동</a></p>
            <%} else {%>
            <p><a href="javascript:void(0)" onclick="top.location.href='<%=request.getContextPath()%>/login.do'" target="_self">로그인 페이지로 이동</a></p>
            <%}%>
        </div>
    </div>
</div>

</body>
</html>
