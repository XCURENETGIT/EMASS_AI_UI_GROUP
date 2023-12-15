<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.web.servlet.i18n.SessionLocaleResolver" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.config.Config"%>
<%@ page import="java.util.Locale" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="com.xcurenet.menu.service.MenuService" %>
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

<link rel="stylesheet" href="<c:url value="/css/emass_style.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/reset.css"/>" />
<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.ui.js"/>"></script>
<% if( Common.isEquals(Common.nvl(Locale.getDefault(), "ko"), "ko")){%>
<script type="text/javascript" src="<c:url value="/js/xcnui_ko.js"/>"></script>
<%}else{%>
<script type="text/javascript" src="<c:url value="/js/xcnui_en.js"/>"></script>
<%}%>


<script type="text/javascript" src="<c:url value="/js/xcnui_2.0.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sha256.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jsbn.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/rsa.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/prng4.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/rng.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-dialog.js"/>"></script>



<script>
  var contextRoot = '<%=contentPath%>';
  var consent = '<%=consent%>';
  var isIPv6 = '<%=isIPv6%>';
  var isOCR = '<%=isOCR%>';

  var pwchgDt = '${_USERCREDENTIAL_.pwchgDt}';
  var adminLang = '<%=adminLanguage%>';
  var enter = "┌";
  var stompClient;
  var adminType = '${_USERCREDENTIAL_.adminType}';
  var currentPw = '${_USERCREDENTIAL_.adminPw}';
  var adminId = '${_USERCREDENTIAL_.adminId}';
  var firstAdminYn = '${_USERCREDENTIAL_.firstAdminYn}';
  var adminMenu = '${_USERCREDENTIAL_.menu}';
  var loginType = '${_USERCREDENTIAL_.loginType}';
  var leftSize = 225;
  var menuId = "";
  var pMenuId = "";

</script>