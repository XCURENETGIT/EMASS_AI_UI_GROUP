<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.config.Config"%>
<%@ page import="com.xcurenet.common.ntp.NtpScheduler" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@page import="com.xcurenet.common.util.config.Config"%>

<%
	String context = request.getContextPath();
	boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
	boolean consentMenuEnable = Config.getBoolean("consent.menu.enable");
	boolean infoHynixConf = Config.getBoolean("info.hynix.used");
	String infoFeedbackYn = Common.getInfoFeedbackYn(session);
	JSONObject ntpInfo = NtpScheduler.ntpStatus;
	String menuKey = Common.nvl(Common.getParam(request).get("menuKey"));
%>
<style type="text/css">
	a {cursor: pointer;}

	.clickEvent{
		color: #88B8FF !important;
		font-weight: 400;
	}
</style>

<script type="text/javascript">
	let infoFeedbackConf = '<%=infoFeedbackConf%>';
	let infoHynixConf = '<%=infoHynixConf%>';
	let infoFeedbackYn = '<%=infoFeedbackYn%>';
	let consentMenuEnable = '<%=consentMenuEnable%>';

	if ($(window).height() < 510) {
		document.write('<style>.container{top: 75px;} #titleClose{display: none;} #titleOpen{display: block;} .content_header{display: none;}</style>');
	}

	/* 메뉴  관련 ###########################################################################################################*/
	let currentMenuId;
	let currentMenuTid;
	let mainContext = "<%=context%>";
	let sideBar;

    menuKey = "<%=menuKey%>";
	$(document).ready(function () {
		createMenuList(0); //init Menu
		sideBar = $("#sideBar");

		let currentMenu = null;
		for (let k in menuList) {
			if(mainUri.indexOf(menuList[k].menuLink) > -1){
				currentMenu = menuList[k];
			}
		}
		if(currentMenu != null) {
			menuId = currentMenu.menuId;
			pMenuId = currentMenu.tid;

            $('.subTit .page a.menu1').html($('a[menuid="'+pMenuId+'"] span').text());
			$('a[menuid="'+pMenuId+'"]').addClass('active');
			$('a[menuid="'+pMenuId+'"] img').attr('src', $('a[menuid="'+pMenuId+'"] img').attr('src').replaceAll('.png', '_on.png'));
		}

		$('.menuList').on("click", function (event) {
			$('.menuList').removeClass('active');
			$('.menuList').each(function (index, item) {
				try {
					$(this).find('img').attr('src', $(this).find('img').attr('src').replaceAll('_on.png', '.png'));
				} catch(e) {
					//ignore
				}
			});

			$("#childMainMenuName").html($(this).find('span').text() + '<span closeSubMenu><img src="' + mainContext + "/img/ico_gnb_x.png" + '" alt/></span>');
			$(this).find('img').attr('src', $(this).find('img').attr('src').replaceAll('.png', '_on.png'));
			$(this).addClass('active');

			currentMenuId = $(this).attr('menuid');
			createMenuList(1);
            if (currentMenuId === "DASHBOARD" && menuId ==="DASHBOARD_CUSTOM"){
                $('.topMenuList a').each(function(){
                    var href =$(this).attr('id');
                    if(href.indexOf('menuKey='+menuKey) > -1) {
                        $(this).attr('class', 'active')
                    }
                });
            }else {
                $('a[menuid="' + menuId + '"]').attr('class', 'active')
            }
			sideBar.show();
		});
	});



	// Left Menu외 다른곳 클리 시 자동 닫힘.
	$(document).on("click", function (event) {
		if (!sideBar.is(event.target) && sideBar.has(event.target).length === 0 && !$('#topMenu').is(event.target) && $('#topMenu').has(event.target).length === 0) {
			sideBar.hide();
		}
	});

	function createMenuList(lv) {
		if(lv == 0) {
			let html = '';
			for (let k in menuList) {
				if (menuList[k].menuId == null || menuList[k].pid != null) continue;
				html += '<li>';
				html += '<a href="#" class="topMenu ' + menuList[k].menuId + ' menuList"' + 'menuid=' + menuList[k].menuId + '>';
				html += '<img src="' + mainContext + menuList[k].menuImgPath + '" alt/><span>' + menuList[k].defaultName + '</span>';
				html += '</a>';
				html += '</li>';
			}
			$('#gnb').find('#topMenu').html(html);
		} else {
			let html = '';
			for (let k in menuList) {
				if (menuList[k].pid == currentMenuId && menuList[k].pid != null) {
                    if ((menuList[k].menuId == "SEARCH_LOG") && (consentMenuEnable == "false")) continue;
					html += '<li><span>-</span>';
                    html += '<a menuClick id="' + menuList[k].menuLink + '" url="' + mainContext + '/' + menuList[k].menuLink + '" menuid="' + menuList[k].menuId + '">' + menuList[k].defaultName + '</a>';

                    //html += '<a menuClick id="' + menuList[k].menuLink + '" url="' + mainContext + '/' + menuList[k].menuLink + '" 'menuid=' + menuList[l].menuId + '>' + menuList[k].defaultName + '</a>';
                    html += '<ul  id="' + menuList[k].menuId + '"  lastMenuUl class="topMenuList">';
					for (let l in menuList) {
                        if ((menuList[l].menuId == "CONSENT_MGMT") && (consentMenuEnable == "false")) continue;
						if (menuList[l].pid == null || menuList[l].pid != menuList[k].menuId) continue;
						html += '<li><span>-</span>';
						html += '<a lastChildMenu  url="' + mainContext + '/' + menuList[l].menuLink + '"class="topMenu ' + menuList[l].menuId + ' menuList"' + 'menuid=' + menuList[l].menuId + '>';
						html += '<span> ' + menuList[l].defaultName + ' </span>';
						html += '</a>';
						html += '</li>';
					}
					html += '</ul></li>';
				}
			}
			sideBar.find('ul').html(html);
		}
	}

	/*  마우스 오버 */
	$(document).on("mouseover", "a[menuClick]", function () {
        $(this).addClass('clickEvent');
	});
	$(document).on("mouseout", "a[menuClick]", function () {
        $(this).removeClass('clickEvent');
	});
	$(document).on("mouseover", "a[lastChildMenu]", function () {
        $(this).addClass('clickEvent');
	});
	$(document).on("mouseout", "a[lastChildMenu]", function () {
        $(this).removeClass('clickEvent');
	});


	$(document).on("click", "span[closeSubMenu]", function () {
		sideBar.css("transition", '0.0s');
		sideBar.hide();
	});

	$(document).on("click", "a[lastChildMenu]", function () {
		var tag = $(this)[0];
		location.replace($(tag).attr('url'));
	});

	$(document).on("click", "a[menuClick]", function () {
		var tag = $(this)[0];
		location.replace($(tag).attr('url'));
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
		<ul class="topMenuList"></ul>
	</div>
	<div class="setting">
		<a href="javascript:;" id="systemSettingsMenu">
			<c:if test="${_USERCREDENTIAL_.firstAdminYn eq 'Y'}">
				<img src="<c:url value="/img/icon_gnb_setting.png"/>" alt="<s:message code="SETTINGS.MENU"/>">
				<span><s:message code="SETTINGS.MENU"/></span>
			</c:if>
		</a>
	</div>
	<%--// setting--%>
</div>
<!--//Gnb Wrap-->
