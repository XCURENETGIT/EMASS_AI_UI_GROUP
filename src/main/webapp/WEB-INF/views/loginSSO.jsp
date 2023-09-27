<%@page import="com.xcurenet.common.util.config.Config"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%@page import="com.xcurenet.onelogin.saml2.SamlSSOAuth"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<title>VENUS / EMASS LTH</title>
<meta charset="utf-8">
<%
	String loginMsg = Config.getString("system.login.msg");
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	if (request.getProtocol().equals("HTTP/1.1")) response.setHeader("Cache-Control", "no-cache");
	try{
		session.removeAttribute(Common.SESSION_CREDENTIAL);
		session.invalidate();
		request.getSession(true);
	}catch(Exception e){}
	
	String sso_type = Config.getString("sso_type");
	if(Common.isEquals(sso_type, "S")){
		SamlSSOAuth auth = new SamlSSOAuth(request, response);
		auth.login();
	}
%>
<script type="text/javascript">

</script>
</head>
<body id="loginBody">
	<div id="container" style="padding-left: 150px;">
        <h2>죄송합니다.<br />SSO 연동 설정이 되어있지 않습니다.</h2>
        <div class="content">
            <p>SSO를 통해서 접속설정이 정확한지 다시 한번 확인해 주시기 바랍니다.</p>
            <p>감사합니다.</p>
            <p><a href="<%=request.getContextPath()%>/login.do" target="_self" >로그인 페이지로 이동</a></p>
        </div>
    </div>
</body>
</html>
