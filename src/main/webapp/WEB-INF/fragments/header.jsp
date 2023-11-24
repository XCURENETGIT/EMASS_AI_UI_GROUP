<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.xcurenet.menu.service.MenuVO" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.SpringContextUtil" %>
<%@ page import="com.xcurenet.menu.service.MenuService" %>
<%@ page import="java.util.List" %>
<%@ page import="com.xcurenet.common.ntp.NtpScheduler" %>
<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String uri = new org.springframework.web.util.UrlPathHelper().getOriginatingRequestUri(request);
	if (uri.contains("/index.do")) uri = "/ems/index.do";
	if (uri.contains("/deviceInfoDetail.do")) uri = "/commons/deviceInfo.do";
	if (uri.contains("/deviceInfoDetailHadoop.do")) uri = "/commons/deviceInfo.do";
	if (uri.contains("/ems/dashboard.do")) uri += "?" + new org.springframework.web.util.UrlPathHelper().getOriginatingQueryString(request);

	MenuService menuService = SpringContextUtil.getBean(MenuService.class);
	String menuId = "";
	String menuName = "";
	String headerYn = (String) request.getAttribute("headerYn");
	String headerCloseYn = (String) request.getAttribute("headerCloseYn");
	String menuKey = (String) request.getAttribute("menuKey");
	String menuList = menuService.getMenuList(request); //메뉴리스트 JSON 데이터로 받아옴
	JSONArray menus = Common.toJSONArray(menuList);
	for(int i=0 ; i < menus.size() ; i++) {
		JSONObject menu = menus.getJSONObject(i);
		if(Common.nvl(uri).contains(Common.nvl(menu.get("menuLink")))) {
			menuId = Common.nvl(menu.get("menuId"));
			menuName = Common.nvl(menu.get("defaultName"));
			break;
		}
	}
%>
<script type="text/javascript">
let menuList = <%=menuList%>;
let mainUri = "<%=uri%>";
</script>
<c:set var="menuId" value="<%=menuId%>"/>
<div class="subTit">
	<h2>
		<%=menuName%>
		<span class="tooltip"><a href="#"><img src="<c:url value="/img/ico_info.png"/>" alt="툴팁"/></a><span class="tooltiptext"></span></span>
	</h2>
	<p><s:message code="${menuId}.msg.header"/></p>
	<div class="page"><a href="#">홈 </a> / <a href="#" class="menu1">1뎁스 메뉴</a> / <a href="#" class="focus"><%=menuName%></a></div>
</div>