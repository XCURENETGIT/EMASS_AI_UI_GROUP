<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.xcurenet.common.ntp.NtpScheduler" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.menu.service.MenuVO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.xcurenet.menu.service.MenuService" %>
<%@ page import="com.xcurenet.common.util.SpringContextUtil" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%
  String headerYn = (String) request.getAttribute("headerYn");
  String headerCloseYn = (String) request.getAttribute("headerCloseYn");
  String menuKey = (String) request.getAttribute("menuKey");
  JSONObject ntpInfo =  NtpScheduler.ntpStatus;

  String uri = new org.springframework.web.util.UrlPathHelper().getOriginatingRequestUri(request);
  MenuService menuService = SpringContextUtil.getBean(MenuService.class);
  String context = request.getContextPath();

//
//  List<MenuVO> menuList = menuService.getMenuList(request);
//
//  String menuNavi = "";
//  String menuId="";
//  String pMenuId="";
//  String menuName = "";
//  for(MenuVO menu : menuList) {
//    if (menu.getPId() != null) continue;
//    if (Common.nvl(uri).indexOf(menu.getMenuLink()) > -1) {
//      menuId = menu.getMenuId();
//      pMenuId = menu.getTId();
//      menuNavi = menu.getDefaultName();
//      menuName = menu.getDefaultName();
//    }
//  }
%>

<%if(Common.isEquals(headerYn, "Y")){%>
<%-- 1 뎁스 설명 --%>
<div class="subTit">
<%--  <h2>--%>
<%--    <%=menuName%>--%>
<%--    <span class="xcnTooltip">--%>
<%--          <a href="#"> <img src="<c:url value="/img/ico_info.png"/>" alt="툴팁" /> </a>--%>
<%--           <span class="tooltiptext">Tooltip text</span>--%>
<%--    </span>--%>
<%--  </h2>--%>
<%--  <p>    <s:message code="${menuId}.msg.header" text="페이지 설명을 입력하세요.(message_ko.properties 페이지의 : ${menuId}.msg.header  값으로 입력)"/></p>--%>
<%--  <div class="page">--%>
<%--    <span class="navi"><%=menuNavi%></span>--%>
<%--  </div>--%>
</div>
<%} %>