<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="com.xcurenet.menu.service.MenuVO"%>
<%@page import="java.util.List"%>
<%@page import="com.xcurenet.menu.service.MenuService"%>
<%@page import="com.xcurenet.common.util.SpringContextUtil"%>
<%@page import="com.xcurenet.common.util.config.Config"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%@page import="com.xcurenet.common.ntp.NtpScheduler"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page import="java.util.Locale" %>
<%@ page import="org.springframework.web.servlet.i18n.SessionLocaleResolver" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%
    String uri = new org.springframework.web.util.UrlPathHelper().getOriginatingRequestUri(request);
    if(uri.indexOf("/index.do")>-1) uri = "/ems/index.do";
    if(uri.indexOf("/deviceInfoDetail.do")>-1) uri = "/commons/deviceInfo.do";
    if(uri.indexOf("/deviceInfoDetailHadoop.do")>-1) uri = "/commons/deviceInfo.do";
    if(uri.indexOf("/ems/dashboard.do")>-1) uri += "?" + new org.springframework.web.util.UrlPathHelper().getOriginatingQueryString(request);

    MenuService menuService = SpringContextUtil.getBean(MenuService.class);
    List<MenuVO> menuList = menuService.getMenuList(request);
    String context = request.getContextPath();

//    String headerYn = Common.nvl(Common.getParam(request).get("headerYn"));
//    String headerCloseYn = Common.nvl(Common.getParam(request).get("headerCloseYn"));
//    String menuKey = Common.nvl(Common.getParam(request).get("menuKey"));

    String headerYn = (String) request.getAttribute("headerYn");
    String headerCloseYn = (String) request.getAttribute("headerCloseYn");
    String menuKey = (String) request.getAttribute("menuKey");

    boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
    boolean infoHynixConf = Config.getBoolean("info.hynix.used");
    String infoFeedbackYn = Common.getInfoFeedbackYn(session);
    JSONObject ntpInfo =  NtpScheduler.ntpStatus;

%>

<a href="#0" class="back-to-top cd-top" style="z-index: 99999999"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>
<iframe id="ExcelDown" name="ExcelDown" src="about:blank;" style="display: none;" height="0" width="0" ></iframe>
<div id="replace_html" style="display: none;"></div>


<div class="modal fade" id="changePasswordPop" tabindex="-1" role="dialog" aria-labelledby="changePasswordModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title"><s:message code="OPERATION_MGMT.CHANGE_PW"/></h3>
            </div>
            <div class="modal-body">
                <div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
                    <label for="attachTypePopInput" class=" col-xs-5"><s:message code="base.current.pw"/></label>
                    <input type="password" class="form-control" style="width:250px;" id="current_password" placeholder="<s:message code="base.current.pw"/>" required autocomplete="off">
                </div>
                <div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
                    <label for="attachDescPopInput" class=" col-xs-5"><s:message code="base.changed.pw"/></label>
                    <input type="password" class="form-control" style="width:250px;" id="change_password" placeholder="<s:message code="base.changed.pw"/>" required autocomplete="off">
                </div>
                <div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
                    <label for="attachDescPopInput" class=" col-xs-5"><s:message code="base.changeconfirm.pw"/></label>
                    <input type="password" class="form-control" style="width:250px;" id="current_confirm_password" placeholder="<s:message code="base.changeconfirm.pw"/>" required autocomplete="off">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
                <button type="button" class="btn btn-primary" accesskey="S" id="changePasswordSaveBtn"><s:message code="common.msg.change"/></button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="changeLanguagePop" tabindex="-1" role="dialog" aria-labelledby="changeLanguageModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title"><s:message code="common.msg.language"/></h3>
            </div>
            <div class="modal-body" style="height:120px;">
                <div class="col-sm-12">
                    <span class="help-block m-b-none"><s:message code="setup.message.admin.language"/></span>
                </div>
                <div class="col-sm-12">
                    <select id="adminLang" class="form-control m-b">
                        <option value="ko">한국어(ko)</option>
                        <option value="en">English(en)</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
                <button type="button" class="btn btn-primary" accesskey="S" id="changeLanguageSaveBtn"><s:message code="common.msg.change"/></button>
            </div>
        </div>
    </div>
</div>

<div id="full_menu" style="position: fixed; z-index: 9999;display: inline-block;border: 1px solid #999; border-top: 0px; background: #fdfeff no-repeat url('<c:url value="/img/title/menu_bg.png"/>');left:161px; top: 50px;display:none;">
    <div style="position: absolute; top: 10px; right: 20px; font-size: 20px;">
        <a href="javascript:void(0);" class="menuClose"><img src="<c:url value="/img/btn/menu_close.png"/>" /></a>
    </div>
    <div class="panel-body">
        <div>
            <ul>
                <li style="list-style: square; font-size: 22px; padding: 10px 0px 10px 0px; color: #337ab7; font-weight: bold;"> <s:message code="All.MENU"/></li>
            </ul>
            <%
                for(MenuVO menu : menuList) {
                    if(menu.getPId()!=null) continue;
            %>
            <ul class="menu01" style="float: left; line-height: 30px; padding: 30px; padding-top: 0px;" menuid="<%=menu.getMenuId()%>">
                <li style="list-style: none; margin-top: 0px; margin-bottom: 32x; border-top: 2px solid #333;"></li>
                <li style="font-weight: bold; list-style: none;">
                    <a style="color: #333;" href="<%=context%>/<%=menu.getMenuLink()%>" menuid="<%=menu.getMenuId()%>"><span class="<%=menu.getMenuIcon()%>"></span> <%=menu.getDefaultName()%></a>
                </li>
                <ul class="submenu" style="padding: 5px;">
                    <%
                        for(MenuVO submenu : menuList) {
                            if( !menu.getMenuId().equals(submenu.getPId()) ) continue;
                            if(Common.isEquals(submenu.getMenuId(), "CONSENT_MGMT")) {
                                if(!Config.getBoolean("consent.menu.enable")) continue;
                            }
                            if(Common.isEquals(submenu.getMenuId(), "SEARCH_LOG")) {
                                if(!Config.getBoolean("consent.menu.enable")) continue;
                            }
                    %>
                    <li style="list-style: none;">
                        <a style="color: #333;" href="<%=context%>/<%=submenu.getMenuLink()%>" menuid="<%=submenu.getMenuId()%>"><span class="<%=submenu.getMenuIcon()%>"></span> <%=submenu.getDefaultName()%></a>
                    </li>
                    <ul style="line-height: 20px;">
                        <%
                            for(MenuVO submenu2 : menuList) {
                                if( !submenu.getMenuId().equals(submenu2.getPId()) ) continue;
                                if(Common.isEquals(submenu2.getMenuId(), "STAT_INFOTYPE"))
                                    if(!(Config.getBoolean("info.feedback.used") && Common.isEquals(infoFeedbackYn, "Y"))) continue;
                        %>
                        <li style="list-style: url('<c:url value="/img/line.png"/>');">
                            <a style="color: #333; font-size: 13px;" href="<%=context%>/<%=submenu2.getMenuLink()%>"  menuid="<%=submenu2.getMenuId()%>"><span class="<%=submenu2.getMenuIcon()%>"></span> <%=submenu2.getDefaultName()%></a>
                        </li>
                        <%} %>
                    </ul>
                    <%} %>
                </ul>
            </ul>
            <%} %>
        </div>
    </div>
</div>

<nav class="navbar navbar-default navbar-fixed-top unselectable">
    <div class="top_container" style="width:100%;">
        <div class="navbar-header" style="width: 160px;">
            <a class="navbar-brand" href="javascript:;" id="menuMainBtn" onclick="goMainPage();">EMASS LTH</a>
        </div>
        <div id="navbar">
            <ul class="nav navbar-nav">
                <li id="menu_fold"><a href="javascript:;"><span class="glyphicon glyphicon-align-justify"></span></a></li>
                <%
                    String menuNavi = "";
                    String menuId="";
                    String pMenuId="";
                    String menuName = "";
                    for(MenuVO menu : menuList) {
                        if(menu.getPId()!=null) continue;
                        if(Common.nvl(uri).indexOf(menu.getMenuLink())>-1) {
                            menuId = menu.getMenuId();
                            pMenuId = menu.getTId();
                            menuNavi = menu.getDefaultName();
                            menuName = menu.getDefaultName();
                        }
                %>
                <li class="topMenuLi">
                    <a href="<%=context%>/<%=menu.getMenuLink()%>" class="topMenu <%=menu.getMenuId()%>" menuid="<%=menu.getMenuId()%>"><span class="<%=menu.getMenuIcon()%>"></span> <%=menu.getDefaultName()%></a>
                    <div class="sub-slide">
                        <ul style="padding-top: 10px;">
                            <%
                                for(MenuVO submenu : menuList) {
                                    if( !menu.getMenuId().equals(submenu.getPId()) ) continue;
                                    if(Common.nvl(uri).indexOf(submenu.getMenuLink())>-1) {
                                        menuId = submenu.getMenuId();
                                        pMenuId = submenu.getTId();
                                        menuNavi = menu.getDefaultName() + " &gt; " + submenu.getDefaultName();
                                        menuName = submenu.getDefaultName();
                                    }
                                    if(Common.isEquals(submenu.getMenuId(), "CONSENT_MGMT")) {
                                        if(!Config.getBoolean("consent.menu.enable")) continue;
                                    }
                                    if(Common.isEquals(submenu.getMenuId(), "SEARCH_LOG")) {
                                        if(!Config.getBoolean("consent.menu.enable")) continue;
                                    }
                            %>
                            <li>
                                <a href="<%=context%>/<%=submenu.getMenuLink()%>" menuid="<%=submenu.getMenuId()%>"><span class="<%=submenu.getMenuIcon()%>"></span> <%=submenu.getDefaultName()%></a>
                            </li>
                            <ul>
                                <%
                                    for(MenuVO submenu2 : menuList) {
                                        if( !submenu.getMenuId().equals(submenu2.getPId()) ) continue;
                                        if(Common.nvl(uri).indexOf(submenu2.getMenuLink())>-1) {
                                            menuId = submenu2.getMenuId();
                                            pMenuId = submenu2.getTId();
                                            menuNavi = menu.getDefaultName() + " &gt; " + submenu.getDefaultName() + " &gt; " + submenu2.getDefaultName();
                                            menuName = submenu2.getDefaultName();
                                        }
                                        if(Common.isEquals(submenu2.getMenuId(), "STAT_INFOTYPE")) {
                                            if(!(Config.getBoolean("info.feedback.used") && Common.isEquals(infoFeedbackYn, "Y"))) continue;
                                        }
                                %>
                                <li style="list-style: url('<c:url value="/img/line.png"/>');">
                                    <a href="<%=context%>/<%=submenu2.getMenuLink()%>" menuid="<%=submenu2.getMenuId()%>"><span class="<%=submenu2.getMenuIcon()%>"></span> <%=submenu2.getDefaultName()%></a>
                                </li>
                                <% } %>
                            </ul>
                            <%} %>
                        </ul>
                    </div>
                </li>
                <%}%>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="javascript:;" id="ntpStatus">NTP - <%=Common.nvl(ntpInfo.get("ntpServer")) %>
                    <%if(Common.isEquals(ntpInfo.getString("status"), "sync")) {%>
                    <span class="fa fa-soild fa-circle fa-lg" style="color:lightgreen;"></span>&nbsp;
                    <%} else if(Common.isEquals(ntpInfo.getString("status"), "unsync")) {%>
                    <span class="fa fa-soild fa-circle fa-lg" style="color:orange;"></span>&nbsp;
                    <%} else {%>
                    <span class="fa fa-soild fa-circle fa-lg" style="color:red;"></span>&nbsp;
                    <%}%>
                </a></li>
                <li class="dropdown">
                    <a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-user"></span> ${_USERCREDENTIAL_.adminId}(${_USERCREDENTIAL_.adminName}) <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="javascript:;" id="changeLanguageBtn"><span class="glyphicon glyphicon-text-color"></span> <s:message code="common.msg.language"/></a></li>
                        <c:if test="${_USERCREDENTIAL_.loginType ne 'S'}">
                            <li><a href="javascript:;" id="changePasswordBtn"><span class="glyphicon glyphicon-th-list"></span> <s:message code="OPERATION_MGMT.CHANGE_PW"/></a></li>
                        </c:if>
                        <li><a href="javascript:;" id="logoutBtn"><span class="glyphicon glyphicon-log-out"></span> <s:message code="OPERATION_MGMT.LOGOUT"/></a></li>
                    </ul>
                </li>
                <c:if test="${_USERCREDENTIAL_.firstAdminYn eq 'Y'}">
                    <li><a href="javascript:;" id="systemSettingsMenu"><span class="glyphicon glyphicon-cog"></span> <s:message code="SETTINGS.MENU"/>&nbsp;&nbsp;&nbsp;</a></li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>
<c:set var="menuId" value="<%=menuId%>"/>

<%if(Common.isEquals(headerCloseYn, "Y")){%>
<style>
    .container{top: 75px;}
    #titleClose{display: none;}
    #titleOpen{display: block;}
    .content_header{display: none;}
    .topMenuLi {z-index:99999;}
</style>
<%}%>
<script type="text/javascript">
    var infoFeedbackConf = '<%=infoFeedbackConf%>';
    var infoHynixConf = '<%=infoHynixConf%>';
    var infoFeedbackYn = '<%=infoFeedbackYn%>';

    if($(window).height() < 510) {
        document.write('<style>.container{top: 75px;} #titleClose{display: none;} #titleOpen{display: block;} .content_header{display: none;}</style>');
    }

</script>

<header class="header unselectable">
    <div class="naviBack">
        <img src="<c:url value="/img/title/home_icon.png"/>">
        <span class="navi"><%=menuNavi%></span>
    </div>
    <%if(Common.isEquals(headerYn, "Y")){%>
    <%-- 1 뎁스 설명 --%>
    <div style="position: absolute; top: 60px; right: 300px; z-index: 999;">
        <a href="javascript: void(0)" id="titleOpen" title="open"><img src="<c:url value="/img/btn/down.png"/>" /></a>
    </div>
    <div style="position: absolute; top: 170px; right: 300px; z-index: 999;">
        <a href="javascript: void(0)" id="titleClose" title="close"><img  src="<c:url value="/img/btn/up.png"/>" /></a>
    </div>
    <div class="subTit">
        <h2>
            1뎁스 타이틀
            <span class="tooltip">
                    <a href="#none"><img src="/img/ico_info.png" alt="툴팁"/></a>
                    <span class="tooltiptext">Tooltip text</span>
            </span>
        </h2>
        <div class="page">
            <div class="content_header">
                <div style="padding: 10px; color: #545454;">
                    <h3><%=menuName%></h3>
                    <div class="subMsg">
                        <s:message code="${menuId}.msg.header" text="페이지 설명을 입력하세요.(message_ko.properties 페이지의 : ${menuId}.msg.header  값으로 입력)"/>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%} %>
</header>

<script type="text/javascript">
    menuId = "<%=menuId%>";
    pMenuId = "<%=pMenuId%>";
    menuKey = "<%=menuKey%>";
    if(menuId == 'DASHBOARD_CUSTOM') {
        $('.navbar-nav a, #full_menu a').each(function(){
            var href = $(this).attr('href');
            if(href.indexOf('menuKey='+menuKey) > -1) {
                $(this).addClass('on');
            }
        });
    } else {
        $('.navbar-nav a[menuid="'+menuId+'"]').addClass('on');
        $('#full_menu a[menuid="'+menuId+'"]').addClass('on');
    }
    $('.navbar-nav a[menuid="'+pMenuId+'"]').parent().addClass('on');
    $('#full_menu a[menuid="'+pMenuId+'"]').parent().addClass('on');

    document.title = "EMASS LTH - <%=menuName%>";

    function goMainPage(){
        document.location.href = $('.topMenuLi:eq(0) .topMenu').attr('href');
    }

    function changeMainMenu(val){
        $('.topMenuLi:eq(0) .topMenu').attr('href', '<c:url value="/ems/dashboard.do?menuKey="/>' + val);
    }

    <%--function changeNTP(ntpServer, lv) {--%>
    <%--    var ntpStr = 'NTP - ' + ntpServer;--%>
    <%--    var titleStr = '';--%>

    <%--    if(lv=='info') {--%>
    <%--        ntpStr += '&nbsp;<span class="fa fa-soild fa-circle fa-lg" style="color:lightgreen;"></span>';--%>
    <%--        titleStr = '<s:message code="trap.message.ntp.sync"/>';--%>
    <%--    } else if(lv=='warning') {--%>
    <%--        ntpStr += '&nbsp;<span class="fa fa-soild fa-circle fa-lg" style="color:orange;"></span>';--%>
    <%--        titleStr = '<s:message code="trap.message.ntp.unsync"/>';--%>
    <%--    } else {--%>
    <%--        ntpStr += '&nbsp;<span class="fa fa-soild fa-circle fa-lg" style="color:red;"></span>';--%>
    <%--        titleStr = '<s:message code="trap.message.ntp.unconnect"/>';--%>
    <%--    }--%>

    <%--    $('#ntpStatus').html(ntpStr);--%>
    <%--    $('#ntpStatus').parent().attr('title', titleStr);--%>
    <%--}--%>
</script>
