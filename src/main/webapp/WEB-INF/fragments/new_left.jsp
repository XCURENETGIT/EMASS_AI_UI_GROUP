<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%@ page import="com.xcurenet.menu.service.MenuVO" %>
<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ page import="com.xcurenet.common.ntp.NtpScheduler" %>
<%@page import="com.xcurenet.menu.service.MenuVO"%>
<%@page import="java.util.List"%>
<%@page import="com.xcurenet.menu.service.MenuService"%>
<%@ page import="com.xcurenet.common.util.SpringContextUtil" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%
    String uri = new org.springframework.web.util.UrlPathHelper().getOriginatingRequestUri(request);
    if(uri.indexOf("/index.do")>-1) uri = "/ems/index.do";
    if(uri.indexOf("/deviceInfoDetail.do")>-1) uri = "/commons/deviceInfo.do";
    if(uri.indexOf("/deviceInfoDetailHadoop.do")>-1) uri = "/commons/deviceInfo.do";
    if(uri.indexOf("/ems/dashboard.do")>-1) uri += "?" + new org.springframework.web.util.UrlPathHelper().getOriginatingQueryString(request);

    MenuService menuService = SpringContextUtil.getBean(MenuService.class);
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

    String menuList = menuService.getMenuList(request); //메뉴리스트 JSON 데이터로 받아옴


%>


<script type="text/javascript">

var infoFeedbackConf = '<%=infoFeedbackConf%>';
var infoHynixConf = '<%=infoHynixConf%>';
var infoFeedbackYn = '<%=infoFeedbackYn%>';

if($(window).height() < 510) {
    document.write('<style>.container{top: 75px;} #titleClose{display: none;} #titleOpen{display: block;} .content_header{display: none;}</style>');
}


/* 메뉴  관련 ###########################################################################################################*/
let currentMenuId;
let currentMenuTid;

var menuList = <%=menuList%>;
var mainUri = "<%=uri%>";
var mainContext = "<%=context%>";

    $(document).ready(function(){
        createMenuList(0); //init Menu
        document.getElementById("sideBar").style.width = "0";
        $('.menuList').hover(function (e){
            currentMenuId = $(this).attr('menuid');
            document.getElementById("sideBar").style.width = "250px";
            createMenuList(1);

        },function() {
            document.getElementById("sideBar").style.width = "0";
        });
        $('#sideBar').hover(function (){
            currentMenuId = $(this).attr('menuid');
            document.getElementById("sideBar").style.width = "250px";
        }, function() {
            document.getElementById("sideBar").style.width = "0";
        });



    });


    function createMenuList(lv){
        switch (lv){
            case 0 : {
                for(k in menuList){
                    var menuNavi   = "";
                    var menuId = "";
                    var pMenuId = "";
                    var menuName   = "";
                    var html = "";

                    if(menuList[k].pid != null ) continue;
                    if(menuList[k].menuId != null) {
                        html = "";
                        menuNavi = menuList[k].menuNavi;
                        menuId = menuList[k].menuId;
                        pMenuId = menuList[k].pId;
                        menuName = menuList[k].defaultName;
                        html += '<li>';
                        html += '<a href="#" class="topMenu ' + menuList[k].menuId + ' menuList"' + 'menuid=' + menuList[k].menuId + '>';
                        html += '<img src="' + mainContext + menuList[k].menuImgPath + '" alt/>';
                        html += '<span>' + menuName + '</span>';
                        html += '</a>';
                        html += '</li>';
                        $('#gnb').find('#topMenu').append(html);
                    }
                }

            }break;
            case 1 : {
                var html = "";
                $("#sideBar").find('ul').html('');

                var childMenuIdList = [];
                /* 메인 메뉴 */
                for(k in menuList){
                    if(menuList[k].menuId == currentMenuId && menuList[k].pid == null) {
                        html = "";
                        var menuName = menuList[k].defaultName;
                        html += menuName+'';
                        html += '<span closeSubMenu>';
                        html += '<img src="'+ mainContext+"/img/ico_gnb_x.png" + '" alt/>';
                        html += '</span>';
                      $("#sideBar").find("#childMainMenuName").html(html);

                    }else if(menuList[k].pid == currentMenuId && menuList[k].pid != null){
                        childMenuIdList.push(menuList[k].menuId);
                    }

                }
                /* 자식 메뉴 */
                html = '';
                for(c in menuList){
                    if(childMenuIdList.includes((menuList[c].menuId))){
                        html += '<li><span>-</span>';
                        html += '<a menuClick id='+ menuList[c].menuLink +'>' + menuList[c].defaultName + '</a>';
                        html += '<ul  id="'+ menuList[c].menuId +'"  lastMenuUl></ul>';
                        html += '</li>';
                    }
                }
                $("#sideBar").find('ul').append(html);
            }break;
        }
    }

    /* 임시 마우스 오버 ..*/
    $(document).on("mouseover", "a[menuClick]", function(){
        $(this).attr('class','active');
    });
    $(document).on("mouseout", "a[menuClick]", function(){
        $(this).attr('class','');
    });


    $(document).on("click", "span[closeSubMenu]", function(){
        document.getElementById("sideBar").style.width = "0";
    });

    $(document).on("click", "a[menuClick]", function(){
        /* last menu */
        var childMenuId = $(this).next()[0].id;
        var isChild = false;
        var html = '';
        for(l in menuList){
            if(menuList[l].pid == null ) continue;
            if(menuList[l].pid == childMenuId){
                isChild = true;
                html += '<li><span>-</span>';
                html += '<a href="' + mainContext + '/' + menuList[l].menuLink +'"class="topMenu ' + menuList[l].menuId + ' menuList"' + 'menuid=' + menuList[l].menuId + '>';
                html +=  '<span> '+ menuList[l].defaultName +' </span>';
                html += '</a>';
                html += '</li>';
            }
        }
        if(isChild){ /* 자식 메뉴가 있으면 하위 메뉴를 오픈한다*/
            $('#'+childMenuId).html(html);
        }else{ // 자식 메뉴가 없으면 현재 클릭한 메뉴의 주소로 이동;
             var goPage = mainContext +'/' +$(this)[0].id;
            location.replace(goPage)
        }
/* 메뉴 관련 #############################################################################################################*/

});


</script>
<!--Gnb-->
<div id="gnbWrap">
    <!--Menu-->
    <div id="gnb">
        <ul id="topMenu">

        </ul>
    </div>

    <!--//Menu sideBar-->
    <div class="gnbMenu" id="sideBar">
        <h2 id="childMainMenuName"></h2>
        <br>
        <ul></ul>
    </div>

<%--    <a href="mainContext/menuList[k].menuLink" class="topMenu menuList[k].menuId menuList" menuid="menuList[k].menuId">--%>


<%--            <li><span>-</span><a class="active" href="#">통계</a>--%>
<%--                <ul>--%>
<%--                    <li><span>-</span><a href="#">트래픽 추이</a></li>--%>
<%--                    <li><span>-</span><a href="#">목적지 IP TOP100</a></li>--%>
<%--                    <li><span>-</span><a href="#">목적지 포트 TOP 100</a></li>--%>
<%--                    <li><span>-</span><a class="active" href="#">출발지 IP TOP100</a></li>--%>
<%--                    <li><span>-</span><a href="#">IP/non-IP 빈도</a></li>--%>
<%--                    <li><span>-</span><a href="#">웹 URL TOP100</a></li>--%>
<%--                </ul>--%>
<%--            </li>--%>
<%--            <li><span>-</span><a href="#">컨텐츠통계</a>--%>
<%--                <ul>--%>
<%--                    <li><span>-</span><a href="#">메뉴3-1</a></li>--%>
<%--                    <li><span>-</span><a href="#">메뉴3-2</a></li>--%>
<%--                    <li><span>-</span><a href="#">메뉴3-3</a></li>--%>
<%--                    <li><span>-</span><a href="#">메뉴3-4</a></li>--%>
<%--                    <li><span>-</span><a href="#">메뉴3-5</a></li>--%>
<%--                    <li><span>-</span><a href="#">메뉴3-6</a></li>--%>
<%--                    <li><span>-</span><a href="#">메뉴3-7</a></li>--%>
<%--                    <li><span>-</span><a href="#">메뉴3-8</a></li>--%>
<%--                    <li><span>-</span><a href="#">메뉴3-9</a></li>--%>
<%--                    <li><span>-</span><a href="#">메뉴3-10</a></li>--%>
<%--                    <li><span>-</span><a href="#">메뉴3-10</a></li>--%>
<%--                </ul>--%>
<%--            </li>--%>
<%--            <li><span>-</span><a href="#">메뉴4</a></li>--%>
    <div class="setting">
        <a href="javascript:;" id="systemSettingsMenu">
            <c:if test="${_USERCREDENTIAL_.firstAdminYn eq 'Y'}">
                <img src="<c:url value="/img/icon_gnb_setting.png"/>" alt="<s:message code="SETTINGS.MENU"/>" >
                <span><s:message code="SETTINGS.MENU"/></span>
            </c:if>
        </a>
    </div> <%--// setting--%>
</div><!--//Gnb Wrap-->
