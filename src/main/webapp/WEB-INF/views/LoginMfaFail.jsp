<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/loginScript.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <title>VENUS / EMASS AI</title>
  <meta charset="utf-8">
  <%
    String loginMsg = Config.getString("system.login.msg");
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (request.getProtocol().equals("HTTP/1.1") || request.getProtocol().equals("HTTPS") || request.getProtocol().equals("HTTP/2.0")) response.setHeader("Cache-Control", "no-cache");
    String locale = Config.getString("default.lang");
  %>


  <style type="text/css">
    html, body {
      padding: 0px;
      margin: 0px;
      width: 100%;
      height: 100%;
    }

  </style>
  <script type="text/javascript">
    $(document).ready(function () {
      ui.alertMsg('${fn:escapeXml(result.message)}' + '<br />' + '<s:message code="login.samsung.mfa.refresh"/>', function () {
        document.location.href = '<c:url value="/ems/index.do"/>';
      }, 3000);
      return;
    });
  </script>
</head>
<body id="loginBody">

<textarea style="display: none;" id="message"><%=loginMsg%></textarea>
<input id="welcomeInfo" type="hidden" value="${fn:escapeXml(result.data.welcomeInfo)}"/>

<div id="login">
  <div id="loginWrap">
    <form method="post">
      <div class="imgcontainer">
        <img src="<c:url value="/img/logo_emass.png"/>" alt="EmassPro" class="emass">
      </div>
      <div id="login_container">
        <div>
        </div>
        <div>
        </div>
      </div>
    </form>
  </div>

</div>
</body>
</html>
