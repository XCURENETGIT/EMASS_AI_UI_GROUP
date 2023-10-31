<%@page import="java.util.Locale"%>
<%@page import="org.springframework.web.servlet.i18n.SessionLocaleResolver"%>
<%@page import="com.xcurenet.common.util.config.Config"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String contentPath = request.getContextPath();
	boolean isIPv6 = Config.isIPv6;
	boolean isOCR = Config.isOCR;
	boolean consent = Config.getBoolean("consent.menu.enable");
	String systemLanguage = Common.nvl(Locale.getDefault(), "ko");
	String adminLanguage = systemLanguage;
	if(request.getRequestURI().toString().indexOf("login.jsp") == -1) adminLanguage = Common.nvl(session.getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME), "ko");
%>
<script>
	 contextRoot = '<%=contentPath%>';
	 consent = <%=consent%>;
	 isIPv6 = <%=isIPv6%>;
	 isOCR = <%=isOCR%>;
</script>


<link rel="stylesheet" href="<c:url value="/js/css/smoothness/jquery-ui-1.10.3.custom.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/bootstrap.min.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/bootstrap-dialog.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/non-responsive.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/font-awesome.min.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/slick.grid.original.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/slick.columnpicker.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/style.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/custom.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/animate.min.css"/>" />



<% if( Common.isEquals(adminLanguage, "ko")){%>
<script type="text/javascript" src="<c:url value="/js/xcnui_ko.js"/>"></script>
<%}else{%>
<script type="text/javascript" src="<c:url value="/js/xcnui_en.js"/>"></script>
<%}%>

<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.ui.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.form.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.fileDownload.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.event.drag-2.2.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.event.drop-2.2.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.bootstrap-growl.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-dialog.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-notify.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.core.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.grid.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.groupitemmetadataprovider.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.dataview.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.grid.ui_2.0.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sortUtil.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.columnpicker.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slickgrid-print-plugin.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.rowmovemanager.js"/>"></script>

<script type="text/javascript" src="<c:url value="/js/xcnui_2.0.js"/>"></script>

<script type="text/javascript" src="<c:url value="/js/highcharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/highcharts-3d.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/exporting.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/chartAPI.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sockjs-0.3.4.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/stomp.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sha256.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/password.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/Date.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/hotkey.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ipaddr.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ipv6Check.js"/>"></script>



</style>
<script>
var pwchgDt = '${_USERCREDENTIAL_.pwchgDt}';
var adminLang='<%=adminLanguage%>';
var enter = "┌";
var stompClient;
var adminType = '${_USERCREDENTIAL_.adminType}';
var currentPw = '${_USERCREDENTIAL_.adminPw}';
var adminId = '${_USERCREDENTIAL_.adminId}';
var firstAdminYn = '${_USERCREDENTIAL_.firstAdminYn}';
var adminMenu = '${_USERCREDENTIAL_.menu}';
var loginType = '${_USERCREDENTIAL_.loginType}';
var innoFD_Lang = 'kr';
if ( innoFD_Lang == 'kr' ) innoFD_Lang = 'ko';
else innoFD_Lang = 'en';
var leftSize=225;
var menuId = "";
var pMenuId = "";

$(document).ready(function() {
	if( $('.content_header').css('display') == undefined ) {
		$('.container').css('top',' 80px');
	}
	$(document).keydown(function( event ) {
		if(event.keyCode == 32 || event.keyCode == 13) {
			if( $('#bootstrap_alert:visible').length > 0 ) {
				$('#bootstrap_alert:visible').find('button').click();
			}
		}
	});
	
	$('.xcn_full').each(function(e){
		var obj = this;
		var pTop = $(obj).parent().offset().top;
		var cTop = $(obj).offset().top;
		$(obj).outerHeight($(obj).parent().outerHeight() - (cTop - pTop) );
		
 		var parent = $(obj).parent();
		$(parent).sizeChanged( function(element){
			var pTop = $(element).offset().top;
			var cTop = $(element).find('.xcn_full').offset().top;
			$(element).find('.xcn_full').outerHeight($(element).outerHeight() - (cTop - pTop) );
		});
	});

	$('button').easyHotkey();

	$('#TheFirstSaveBtn').click(function(){
		$('#TheFirstSaveBtn').prop('disabled', true);
		var first_adminId = $('#first_adminId').val().trim();
		var first_adminPw = $('#first_adminPw').val().trim();
		var first_c_adminPw = $('#first_c_adminPw').val().trim();
		var first_cur_adminPw = $('#first_cur_adminPw').val().trim();
		var first_accessIp = $('#first_accessIp').val().trim();
		if(first_adminId == '') {
			ui.alertMsg('<s:message code="admin.msg.enter.id"/>');
			$('#first_adminId').focus( );
			$('#TheFirstSaveBtn').prop('disabled', false);
			return;
		}
		if( !idCheck(first_adminId ) ) {
			ui.alertMsg('<s:message code="admin.msg.use.englishid"/>');
			$('#first_adminId').focus( );
			$('#TheFirstSaveBtn').prop('disabled', false);
			return;
		}
		if(first_adminPw == '') {
			ui.alertMsg('<s:message code="admin.msg.enter.pw"/>');
			$('#first_adminPw').focus( );
			$('#TheFirstSaveBtn').prop('disabled', false);
			return;
		}
		if(first_c_adminPw == '') {
			ui.alertMsg('<s:message code="admin.msg.enter.cpw"/>');
			$('#first_c_adminPw').focus( );
			$('#TheFirstSaveBtn').prop('disabled', false);
			return;
		}
		if ( !validationPassword( $('#first_adminId').val(), $('#first_adminPw').val(), "" ) ){
			$('#first_adminPw').focus( );
			$('#TheFirstSaveBtn').prop('disabled', false);
			return;
		}
		if ( !validationPassword( $('#first_c_adminId').val(), $('#first_c_adminPw').val(), "" ) ){
			$('#first_c_adminPw').focus( );
			$('#TheFirstSaveBtn').prop('disabled', false);
			return;
		}
		
		if(first_adminPw != first_c_adminPw) {
			ui.alertMsg('<s:message code="admin.msg.diff.pw"/>');
			$('#first_adminPw').focus( );
			$('#TheFirstSaveBtn').prop('disabled', false);
			return;
		}
		if(first_cur_adminPw == sha256_digest(first_adminPw)) {
			ui.alertMsg('<s:message code="base.same.pw"/>');
			$('#first_adminPw').focus( );
			$('#TheFirstSaveBtn').prop('disabled', false);
			return;
		}
		ui.confirmMsg('<s:message code="base.change.pw"/>', '', '', function(rs){
			if(rs){
				ui.get({
					url 	:'updateAdminInfo.xcn',
					adminId :first_adminId,
					adminPw :sha256_digest(first_adminPw),
					accessIp :first_accessIp,
					/* mysqlUser	:first_deviceId,
					mysqlPw		:first_devicePw, */
					success : function ( data, total ) {
						closeAllPopup();
						$('#TheFirstSaveBtn').prop('disabled', false);
						ui.confirmMsg('<s:message code="base.saved.pw"/>', '', '', function(rs){
							if(rs){
								document.location.href = '<c:url value="/logout.do"/>';
							}
						});
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						//restartTomcat();
						$('#TheFirstSaveBtn').prop('disabled', false);
					}
				});
			}else{
				$('#TheFirstSaveBtn').prop('disabled', false);
			}
				
		});
	});
	
	$('#changePasswordBtn').click(function(){
		$('#current_password').val('');
		$('#change_password').val('');
		$('#current_confirm_password').val('');

		$("#changePasswordPop").modal('show');
	});
	
	$('#changeLanguageBtn').click(function(){
		$('#adminLang').val(adminLang);
		$("#changeLanguagePop").modal('show');
	});
	
	$('#changePasswordSaveBtn').click(function(){
		var current_password = $('#current_password').val().trim();
		var change_password = $('#change_password').val().trim();
		var current_confirm_password = $('#current_confirm_password').val().trim();
		
		if(current_password == '') {
			ui.alertMsg('<s:message code="base.enter.current.pw"/>');
			return;
		}
		if(change_password == '') {
			ui.alertMsg('<s:message code="base.enter.change.pw"/>');
			return;
		}
		if(current_confirm_password == '') {
			ui.alertMsg('<s:message code="base.enter.changeconfirm.pw"/>');
			return;
		}
		
		if(change_password != current_confirm_password) {
			ui.alertMsg('<s:message code="base.different.pw"/>');
			return;
		}
		if(sha256_digest(current_password) != currentPw) {
			ui.alertMsg('<s:message code="base.wrong.pw"/>');
			return;
		}
		
		if(sha256_digest(current_password) == sha256_digest(change_password)) {
			ui.alertMsg('<s:message code="base.same.pw"/>');
			return;
		}
		
		if(!validationPassword('${_USERCREDENTIAL_.adminId}', change_password)) return;
		ui.confirmMsg('<s:message code="base.change.pw"/>', '', '', function(rs){
			if(rs){
				ui.get({
					url : 'updateAdminPassword.xcn',
					adminId : adminId,
					adminPw : sha256_digest(change_password),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="base.saved.pw"/>', function(){
							closeAllPopup();
							document.location.href = '<c:url value="/logout.do"/>';
						});
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
					}
				});
			}
		});
	});
	
	$('#changeLanguageSaveBtn').click(function(){
		var adminLang = $('#adminLang').val();
		
		ui.confirmMsg('<s:message code="common.msg.change.apply"/>', '', '', function(rs){
			if(rs){
				document.location.href = '<c:url value="/changeLocale?locale='+encodeURI(adminLang)+'"/>';
			}
		});
	});
	
	$('#logoutBtn').click(function(){
		ui.get({
			url : 'logout.xcn',
			success : function(data, total) {
				closeAllPopup();
				if(loginType == 'S') document.location.href = '<c:url value="/logoutSSO.do"/>';
				else document.location.href = '<c:url value="/logout.do"/>';
			},
			error : function(status, message) {
				console.log('Audit log insert fail');
			},
			complete : function() {
			}
		});
	});

	$('#systemSettingsMenu').click(function() {
		fnOpenWindow('<c:url value="/conf.do"/>', 'systemConfig', 1100, 800, 'scroll');
	});
	$('#adminSettingsMenu').click(function() {
		fnOpenWindow('<c:url value="/endPoints"/>', 'endPoints', 1300, 650, 'scroll');
	});

	$(window).scroll(function() {
		$(this).scrollTop() > 200 ? $('.back-to-top').addClass('cd-is-visible') : $('.back-to-top').removeClass('cd-is-visible cd-fade-out');
	}).trigger('scroll');

	$('.back-to-top').on('click', function(event) {
		event.preventDefault();
		$('html,body').animate({
			scrollTop : 0
		}, 500);
	});
	
	$('#titleOpen').click(function(){
		$(this).hide();
		$('#titleClose').show('fade');
		$('.content_header').slideDown('fast');
		$('.container').animate({top: '190'}, 200);
	});
	$('#titleClose').click(function(){
		$(this).hide();
		$('#titleOpen').show('fade');
		$('.content_header').slideUp('fast');
		$('.container').animate({top: '75'}, 200);
	});
	
	$('#menu_fold').click(function() {
		if($('#full_menu').is(':visible')) $('#full_menu').slideUp('fast');
		else $('#full_menu').slideDown('fast'); 
	});

	$(document).on('click', '.menuClose', function(){
		$(this).parent().parent().hide();
	});

	$(document).mouseup(function(e){
		if($('#full_menu').has(e.target).length===0){
			$('#full_menu').slideUp('fast');
		}
	});

	$('#full_menu .panel-body').clone().appendTo('#sub_menu');
	$('.topMenuLi').hover(
		function(e){
			$(this).find('.sub-slide').show(); 
		},
		function(e){
			$(this).find('.sub-slide').hide();
		}
	);

	$(document).on('click', '.print_link', function(){
		var grid = getTargetGrid($(this).attr('data-target'));
		var title = $(this).attr('rel');
		if (grid.Rows == 0) {
			alert('<s:message code="common.msg.nodata"/>');
			return;
		}
		
		grid.print(title, pMenuId, menuId);
	});
	$(document).on('click', '.excel_link', function(){
		var grid = getTargetGrid($(this).attr('data-target'));
		var title = $(this).attr('rel');
		var option = $(this).attr('option');
		grid.on();
		setTimeout(function(){
			excelDownLoad(grid, title, null, null, option);
		}, 200);
	});
	$(document).on('click', '.cell_link', function(){
		var grid = getTargetGrid($(this).attr('data-target'));
		var title = $(this).attr('rel');
		var option = $(this).attr('option');
		grid.on();
		setTimeout(function(){
			cellDownLoad(grid, title, null, null, option);
		}, 200);
	});
	
	$(document).on('click', '.pdf_link', function(){
		var grid = getTargetGrid($(this).attr('data-target'));
		var title = $(this).attr('rel');
		var option = $(this).attr('option');
		grid.on();
		setTimeout(function(){
			pdfDownLoad(grid, title, null, null, option);
		}, 200);
	});
	$(document).on('click', '.csv_link', function(){
		var grid = getTargetGrid($(this).attr('data-target'));
		var title = $(this).attr('rel');
		var option = $(this).attr('option');
		grid.on();
		setTimeout(function(){
			csvDownLoad(grid, title, null, null, option);
		}, 200);
	});
	
	$(document).on('click', '.saveNoLogUrlPopBtn', function(){
		$('.saveNoLogUrlPopBtn').prop('disabled', true);
		saveNoLogUrlData();
	});
	
	//목록개수
	var str='';
	str += '<button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown">';
	str += '	<span class="glyphicon glyphicon-list-alt"></span>&nbsp;<s:message code="common.msg.listcnt"/> (<span class="dropdown-text">500</span>) <span val="500" class="caret"></span>';
	str += '</button>';
	str += '<ul class="dropdown-menu dropdown-menu-right" role="menu">';
	str += '	<li><a href="javascript:void(0);" data="100">100</a></li>';
	str += '	<li><a href="javascript:void(0);" data="500">500</a></li>';
	str += '	<li><a href="javascript:void(0);" data="1000">1000</a></li>';
	str += '	<li><a href="javascript:void(0);" data="2000">2000</a></li>';
	str += '	<li><a href="javascript:void(0);" data="3000">3000</a></li>';
	str += '	<li><a href="javascript:void(0);" data="4000">4000</a></li>';
	str += '	<li><a href="javascript:void(0);" data="5000">5000</a></li>';
	str += '</ul>';
	$('.grid-limit').html(str);

	$(document).on('click','.dropdown-menu a', function(){
		$(this).parent().parent().parent().find('.caret').attr('val', $(this).attr('data'));
		$(this).parent().parent().parent().find('.dropdown-text').text($(this).text());
		$(this).parent().parent().parent().find('.caret').trigger( "change" );
	});

	if($('body').attr('id') != 'loginBody' && $('#menu_fold').length > 0 ){
		if(menuId != 'DASHBOARD' && menuId !='MESSAGE_INFO'){
			$('.container').css('min-width', '1260px');
			$('.top_container').css('min-width', '100%');
		}
		
		var socket = new SockJS("<c:url value="/socket"/>");
		socket.onheartbeat = function() {
			console.log('heartbeat');
		};
		socket.disconnect = function(data) {
			console.log('서버 연결이 해제 되었습니다.!');
		};

		stompClient = Stomp.over(socket);
		stompClient.debug = null
		var win_title = document.title;
		var connectCallback = function() {
			stompClient.subscribe('/topic/ntpCheck', function(frame){
				var body = JSON.parse(frame.body);
				var lv = body.status;
				if(lv=='sync') lv = 'info';
				else if(lv=='unsync') lv = 'warning';
				else if(lv=='unconnect') lv = 'danger';
				else lv = 'info';
				
				if(lv=='danger' || lv=='warning') {
					$.notify({
						icon: 'glyphicon glyphicon-warning-sign',
						title: '<strong>'+body.title+'</strong><br>',
						message: body.content
					},{
						type: lv,
						placement: {
							from: "bottom",
							align: "right"
						},
						animate: {
							enter: 'animated fadeInRight',
							exit: 'animated fadeOutRight'
						}
					});
				}
				changeNTP(body.ntpServer, lv);
			});
			stompClient.subscribe('/user/${pageContext.session.id}/logout', function(frame){
				closeAllPopup();
				eval(frame.body);
			});
			stompClient.subscribe('/user/${_USERCREDENTIAL_.adminId}/trap', function(frame){
				var body = JSON.parse(frame.body);
				var lv = body.eventLevel;
				if(lv=='I') lv = 'info';
				else if(lv=='W') lv = 'warning';
				else if(lv=='E') lv = 'danger';
				else lv = 'info';
				
				$.notify({
					icon: 'glyphicon glyphicon-warning-sign',
					title: '<strong>'+body.title+'</strong><br>',
					message: body.content
				},{
					type: lv,
					placement: {
						from: "bottom",
						align: "right"
					},
					animate: {
						enter: 'animated fadeInRight',
						exit: 'animated fadeOutRight'
					}
				});
			});
			stompClient.subscribe('/user/${_USERCREDENTIAL_.adminId}/downloadProgress', function(frame){
				var body = frame.body;
				document.title = 'Download : ' + body + '% ' + win_title;
				if( Number(body) > 99 ) document.title = win_title;
			});
			stompClient.subscribe('/user/${_USERCREDENTIAL_.adminId}/alarm', function(frame){
				var body = JSON.parse(frame.body);
				$.notify({
					icon: 'glyphicon glyphicon-warning-sign',
					title: '<strong>'+body.title+'</strong><br>',
					message: body.content
				},{
					type: 'info',
					placement: {
						from: "bottom",
						align: "right"
					},
					animate: {
						enter: 'animated fadeInRight',
						exit: 'animated fadeOutRight'
					}
				});
			});
			stompClient.subscribe('/user/${_USERCREDENTIAL_.adminId}/exportEnd', function(frame){
				var body = JSON.parse(frame.body);
				var statusStr = body.statusStr;
				var title = "";
				if(statusStr == "Y") title = '<s:message code="download.msg.end"/>';
				else if(statusStr == "C") title = '<s:message code="download.msg.cancel"/>';
				else title = '<s:message code="download.msg.error"/>';
				$.notify({
					icon: 'glyphicon glyphicon-warning-sign',
					title: '<strong>' + title + '</strong><br>',
					message: body.downVal.replaceAll('┌', '<br>')
				},{
					type: 'info',
					placement: {
						from: "bottom",
						align: "right"
					},
					animate: {
						enter: 'animated fadeInRight',
						exit: 'animated fadeOutRight'
					}
				});
			});
		};
		var errorCallback = function(error) {
			console.log(error)
			window.setTimeout(function(){
				stompClient.connect('${pageContext.session.id}', "", connectCallback, errorCallback);
			}, 3000);
		};
		stompClient.connect('${pageContext.session.id}', "", connectCallback, errorCallback);
	}
	
	function setAlive( ){
		stompClient.send("/app/browserAlive", {}, '${pageContext.session.id}');
	}
	if(menuId == '') checkMenuId();
});

var Messenger = {
	msg4:'<s:message code="common.messenger.msg4"/>',
	msg5:'<s:message code="common.messenger.msg5"/>'
};

//데이터베이스 패스워드 유효성 검사 //
//8~15자,특수 문자 1개 이상, 숫자 1개 이상, 대 소문자 조합 조건 모두 충족 해야함
function ccDatabasePw(pw) {
		if (/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&+=]).*$/.test(pw))
			return true;
		return false;
}
function writeExportMenu(target, gridName, title){
	var str = '';
	str += '<li><a href="javascript:void(0);" class="excel_link" data-target="'+gridName+'" rel="'+title+'"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="common.msg.excel"/>(xlsx)</a></li>';
	str += '<li><a href="javascript:void(0);" class="cell_link" data-target="'+gridName+'" rel="'+title+'"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="common.msg.hancel"/>(cell)</a></li>';
	str += '<li><a href="javascript:void(0);" class="csv_link" data-target="'+gridName+'" rel="'+title+'"><span class="fa fa-file-text" style="font-size:16px"></span>&nbsp;<s:message code="common.msg.text"/>(csv)</a></li>';
	str += '<li><a href="javascript:void(0);" class="pdf_link" data-target="'+gridName+'" rel="'+title+'"><span class="fa fa-file-pdf-o" style="font-size:16px"></span>&nbsp;PDF</a></li>';
	str += '<li><a href="javascript:void(0);" class="print_link" data-target="'+gridName+'" rel="'+title+'"><span class="glyphicon glyphicon-print"></span>&nbsp;<s:message code="common.msg.print"/></a></li>';
	$('#'+target).append(str);
}

function loginCheck(firstAdmin){
	adminId = $('#first_adminId').val().trim();
	if(firstAdminYn == '') firstAdminYn = firstAdmin;
	if( ( pwchgDt == '' || pwchgDt == null ) ) {
		$('#first_adminId').prop("disabled",true);
		$('#first_accessIp_div').hide();
		$('#TheFirstChangePw').modal('show');
	}
}

//팝업 전용
function checkMenuId(){
	if(opener){
		try {
			menuId = opener.menuId;
			pMenuId = opener.pMenuId;
		} catch (e) {
			console.error(e);
		}
	}
}

function getTargetGrid(target) {
	for (var i = 0; i < window.__grids.length; i++) {
		if (window.__grids[i].id == target)
			return window.__grids[i];
	}
	return null;
}
//동의서 사용 대상자 여부
function isConsent( ){
	if( consent && firstAdminYn != 'Y' ) return true;
	else return false;
}

function isDetailView( ){
	if( adminMenu == 'ALL' || adminMenu.indexOf("DV") > -1) return true;
	else return false;
}

function renderPrice(frame) {
	var prices = JSON.parse(frame.body);
	$('#fileSend_totalCnt').html(prices.nowToday);
	$('#fileSend_termDtStr').html(prices.rate);
}

// 메시지 본문 조회 팝업
function openMessageBody( title, msgId, searchKey){
	if( !isDetailView() ) return;
	return openMessageBodyPop(title, msgId, searchKey, '');
}
function openMessageBodyPop(title, msgId, searchKey, bodySize){
	if( !isDetailView() ) return;
	if( searchKey == undefined ) searchKey = '';
	
	var url    = '<c:url value="/ems/contentBodyNew.do?msgid='+msgId+'&searchKey='+encodeURI(searchKey)+'&bodySize='+bodySize+'"/>';
	if( title == '' ) title='_blank';
	return fnOpenWindow(url, title, 1600, 700, 'resize');
}

function openMessageBodyUnknownPop(title, msgId, searchKey){
	if( !isDetailView() ) return;
	if( searchKey == undefined ) searchKey = '';
	
	var url    = '<c:url value="/ems/contentBodyUnknown.do?msgid='+msgId+'&searchKey='+encodeURI(searchKey)+'"/>';
	if( title == '' ) title='_blank';
	return fnOpenWindow(url, title, 1000, 700, 'resize');
}

function openGroupMessagePop(){
	var url    = '<c:url value="/ems/contentGroup.do"/>';
	var title='_blank';
	return fnOpenWindow(url, title, 1280, 800, 'resize');
}

// 목록개수 건수 조회
function getPageSize(id){
	return Number( $('#'+id + ' .caret').attr('val') );
}
// 목록개수 건수 적용
function setPageSize(id, val){
	$('#'+id + ' .caret').attr('val', val);
	$('#'+id + ' .dropdown-text').text(val);
}

function csvDownLoad(grid, title, pmenu_id, menu_id, option) {
	if (grid.Rows == 0) {
		grid.off();
		alert('<s:message code="common.msg.nodata"/>');
		return;
	}
	if( pmenu_id == undefined || menu_id == undefined){
		pmenu_id = pMenuId;
		menu_id = menuId;
	}
	var header = grid.getHeaderEXCEL();
	var body = grid.getBodyEXCEL(option);
	grid.on();
	ui.postJson({
		url : 'utils/csvWriter.do',
		title : title,
		header : header,
		body : body,
		pMenuId : pmenu_id,
		menuId: menu_id,
		success : function(data, total) {
			try {
				ExcelDown.location.href = '<c:url value="/utils/csvDown.do"/>?path=' + encodeURI(data);
			} catch (e) {
				ExcelDown.src = '<c:url value="/utils/csvDown.do"/>?path=' + encodeURI(data);
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			grid.off();
		}
	});
}

function pdfDownLoad(grid, title, pmenu_id, menu_id, option) {
	if (grid.Rows == 0) {
		grid.off();
		alert('<s:message code="common.msg.nodata"/>');
		return;
	}
	if( pmenu_id == undefined || menu_id == undefined){
		pmenu_id = pMenuId;
		menu_id = menuId;
	}
	var header = grid.getHeaderEXCEL();
	var body = grid.getBodyEXCEL(option);
	grid.on();
	ui.postJson({
		url : 'utils/pdfWriter.do',
		title : title,
		header : header,
		body : body,
		pMenuId : pmenu_id,
		menuId: menu_id,
		success : function(data, total) {
			try {
				ExcelDown.location.href = '<c:url value="/utils/pdfDown.do"/>?path=' + encodeURI(data);
			} catch (e) {
				ExcelDown.src = '<c:url value="/utils/pdfDown.do"/>?path=' + encodeURI(data);
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			grid.off();
		}
	});
}

function excelDownLoad(grid, title, pmenu_id, menu_id, option) {
	if (grid.Rows == 0) {
		grid.off();
		alert('<s:message code="common.msg.nodata"/>');
		return;
	}
	if( pmenu_id == undefined || menu_id == undefined){
		pmenu_id = pMenuId;
		menu_id = menuId;
	}

	var header = grid.getHeaderEXCEL();
	var body = grid.getBodyEXCEL(option);
	grid.on();
	ui.postJson({
		url : 'utils/xlsxWriter.do',
		title : title,
		header : header,
		body : body,
		pMenuId : pmenu_id,
		menuId: menu_id,
		success : function(data, total) {
			try {
				ExcelDown.location.href = '<c:url value="/utils/xlsxDown.do"/>?path=' + encodeURI(data);
			} catch (e) {
				ExcelDown.src = '<c:url value="/utils/xlsxDown.do"/>?path=' + encodeURI(data);
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			grid.off();
		}
	});
}

function cellDownLoad(grid, title, pmenu_id, menu_id, option) {
	if (grid.Rows == 0) {
		grid.off();
		alert('<s:message code="common.msg.nodata"/>');
		return;
	}
	if( pmenu_id == undefined || menu_id == undefined){
		pmenu_id = pMenuId;
		menu_id = menuId;
	}
	var header = grid.getHeaderEXCEL();
	var body = grid.getBodyEXCEL(option);
	grid.on();
	ui.postJson({
		url : 'utils/cellWriter.do',
		title : title,
		header : header,
		body : body,
		pMenuId : pmenu_id,
		menuId: menu_id,
		success : function(data, total) {
			try {
				ExcelDown.location.href = '<c:url value="/utils/xlsxDown.do"/>?path=' + encodeURI(data);
			} catch (e) {
				ExcelDown.src = '<c:url value="/utils/xlsxDown.do"/>?path=' + encodeURI(data);
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			grid.off();
		}
	});
}


function insertAudit(operation, information){
	ui.get({
		url : 'insertAudit.xcn',
		menuId : menuId,
		pMenuId : pMenuId,
		operation : operation,
		information : information,
		success : function(data, total) {
		},
		error : function(status, message) {
			console.log('Audit log insert fail');
		},
		complete : function() {
		}
	});
}

function restartTomcat(){
	ui.get({
		url : 'restartTomcat.xcn',
		success : function(data, total) {
		},
		error : function(status, message) {
			console.log('restarTomcat fail');
		},
		complete : function() {
		}
	});
}

function chkInteger(val){
	if( val == 0) return true;
	if( !Number(val)){
		return false;
	}
	val = val+'';
	if( val.indexOf('.') > -1){
		return false;
	}
	
	return true;
}

/**
 * IPv4 및 IPv6 한꺼번에 체크 by JGH
 */
function checkIP(ip) {
	return ipv6Check._validate(ip);
}

/**
 * 시작, 끝 IP 유효성 검사
 *
 */
function checkIpRange(sip, eip) {
	var startIp = sip;
	var endIp = eip;
	if ( ipv6Check.storeIP(startIp) != "" ) startIp = ipv6Check.storeIP(startIp);
	if ( ipv6Check.storeIP(endIp) != "" ) endIp = ipv6Check.storeIP(endIp);
	
	var iplen = 3;
	var symbol = '';
	if ( ipv6Check.ver( startIp ) == 6 ) {
		symbol = ':';
		iplen = 4;
	} else symbol = '.';
	var startIPArr = startIp.split(symbol);
	if ( ipv6Check.ver( endIp ) == 6 ) symbol = ':';
	else symbol = '.';
	var endIpArr = endIp.split(symbol);
	var startIpStr="";
	var endIpStr="";
	for ( var i = 0; i < startIPArr.length; i++ )
	{
		startIpStr += prependZero(startIPArr[i],iplen);
	}
	for ( var i = 0; i < endIpArr.length; i++ )
	{
		endIpStr += prependZero(endIpArr[i],iplen);
	}
	if ( strcmp(startIpStr, endIpStr) == 1 ) return false;
	else return true;
}

function strcmp(a, b)
{
	return (a<b?-1:(a>b?1:0));
}

function prependZero(num, len) {
	while(num.toString().length < len) {
		num = "0" + num;
	}
	return num;
}

function probPercent(val) {
	if( val == undefined || val == null || val == -1.0 ) return '-';
	return Math.floor(val * 100);
}

function saveNoLogUrlData() {
	$('#noLogurl').val($.trim($('#noLogurl').val()));
	if( $('#noLogurl').val() == '') {
		alert('<s:message code="filterInfo.msg.enter.url"/>');
		$('.saveNoLogUrlPopBtn').prop('disabled', false);
		return false;
	}
	var url = mode == 'insert' ? 'insertUrlFilter.xcn' : 'updateUrlFilter.xcn';
	var message = mode == 'insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
	ui.confirmMsg(message, '', '', function(rs){
		if(rs){
			ui.onBody('content_body', 0, 0);
			ui.post({
				url : url,
				data : $('#urlPopForm').serializeAll(),
				success : function ( data, total ) {
					ui.alertMsg('<s:message code="common.msg.saved"/>');
					$('#urlPop').modal('hide');
				},
				error : function (status, message) {
					ui.alertMsg(message);
				},
				complete : function (){
					ui.off('content_body');
					$('.saveNoLogUrlPopBtn').prop('disabled', false);
					getTabInfo();
					getData();
				}
			});
		} else {
			$('.saveNoLogUrlPopBtn').prop('disabled', false);
		}
	});
}
</script>
<script for="InnoFD" event="OnDownloadComplete">
document.InnoFD.RemoveAllFiles( );
ui.alertMsg("<s:message code="common.msg.down.complete"/>", null, 2000);
</script>

<script for="InnoFD" event="OnDownloadError">
document.InnoFD.RemoveAllFiles( );
ui.alertMsg("<s:message code="common.msg.down.error"/>", null, 2000);
</script>
	<div class="modal fade" id="urlPop" tabindex="-1" role="dialog" aria-labelledby="urlPop">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="urlPopForm" onsubmit="return false;">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="filterInfo.urlPop.title.add"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-inline">
							<label for="url" class="control-label col-xs-2">URL</label>
							http://<input type="text" class="form-control" name="url" id="noLogurl" placeholder="URL" style="width: 350px;" maxlength="128">
							<input type="hidden" id="urlLogSeq" name="urlLogSeq">
						</div>
						<div class="form-inline" style="padding-left: 10px; color: #f25643;"><s:message code="filterInfo.msg.exceptHttp"/></div>
					</div>
					<input type="hidden" name="tabId"/>
					<input type="hidden" name="tab" />
				</form>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary saveNoLogUrlPopBtn" accesskey="S" id="saveNoLogUrlPopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="TheFirstChangePw" tabindex="-1" role="dialog" aria-labelledby="TheFirstChangePwModal" data-backdrop="static" data-keyboard="false">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<%if(Common.isEquals(adminLanguage, "ko")) {%>
					<div class="modal-header" style="background-color: #253f56;color: white;">
						<h3 class="modal-title">최초 접속 설정</h3>
					</div>
					<div class="modal-body">
						<h5 style="font-weight:900; color:#000; border-bottom: 2px solid #656565; padding: 0 0 9px 14px;">※ 최초 접속시 운용자 정보를 반드시 설정하시기 바랍니다.</h5>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
							<label for="first_adminId" style="padding-top: 8px;" class="control-label col-xs-4">운용자 아이디</label>
							<input type="text" class="form-control" name="first_adminId" id="first_adminId" placeholder="운용자 아이디" required>
							<input type="hidden" class="form-control" name="first_cur_adminPw" id="first_cur_adminPw">
						</div>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
							<label for="first_adminPw" style="padding-top: 8px;" class="control-label col-xs-4">비밀번호</label>
							<input type="password" class="form-control" name="first_adminPw" id="first_adminPw" placeholder="비밀번호" required>
						</div>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
							<label for="first_c_adminPw" style="padding-top: 8px;" class="control-label col-xs-4">비밀번호 확인</label>
							<input type="password" class="form-control" name="first_c_adminPw" id="first_c_adminPw" placeholder="비밀번호 확인" required>
						</div>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;" id="first_accessIp_div">
							<label for="first_accessIp" style="padding-top: 8px;" class="control-label col-xs-4">운용자 접속 IP</label>
							<input type="text" class="form-control" name="first_accessIp" id="first_accessIp" placeholder="운용자 접속 IP" required>
						</div>
					</div>
					<div class="modal-body" style="display: none;">
						<h5 style="font-weight:900; color:#000; border-bottom:2px solid #656565; padding: 0 0 9px 14px;">※ 최초 접속시 데이터베이스 정보를 반드시 설정하시기 바랍니다.</h5>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
							<label for="first_deviceId" style="padding-top: 8px;" class="control-label col-xs-4">데이터베이스 아이디</label>
							<input type="text" class="form-control" name="first_deviceId" id="first_deviceId" placeholder="데이터베이스 아이디" required>
						</div>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
							<label for="first_devicePw" style="padding-top: 8px;" class="control-label col-xs-4">비밀번호</label>
							<input type="password" class="form-control" name="first_devicePw" id="first_devicePw" placeholder="비밀번호" required>
						</div>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
							<label for="first_c_devicePw" style="padding-top: 8px;" class="control-label col-xs-4">비밀번호 확인</label>
							<input type="password" class="form-control" name="first_c_devicePw" id="first_c_devicePw" placeholder="비밀번호 확인" required>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" accesskey="S" id="TheFirstSaveBtn">변경</button>
					</div>
				<%}else{ %>
					<div class="modal-header" style="background-color: #253f56;color: white;">
						<h3 class="modal-title">First access setting</h3>
					</div>
					<div class="modal-body">
						<h5 style="font-weight:900; color:#000; border-bottom: 2px solid #656565; padding: 0 0 9px 14px;">※ Make sure set up the administrator information when you access first time.</h5>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
							<label for="first_adminId" style="padding-top: 8px;" class="control-label col-xs-4">Administrator ID</label>
							<input type="text" class="form-control" name="first_adminId" id="first_adminId" placeholder="Administrator ID" required>
							<input type="hidden" class="form-control" name="first_cur_adminPw" id="first_cur_adminPw">
						</div>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
							<label for="first_adminPw" style="padding-top: 8px;" class="control-label col-xs-4">Password</label>
							<input type="password" class="form-control" name="first_adminPw" id="first_adminPw" placeholder="Password" required>
						</div>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
							<label for="first_c_adminPw" style="padding-top: 8px;" class="control-label col-xs-4">Check password</label>
							<input type="password" class="form-control" name="first_c_adminPw" id="first_c_adminPw" placeholder="Check password" required>
						</div>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;" id="first_accessIp_div">
							<label for="first_accessIp" style="padding-top: 8px;" class="control-label col-xs-4">Administrator access IP address</label>
							<input type="text" class="form-control" name="first_accessIp" id="first_accessIp" placeholder="Administrator access IP address" required>
						</div>
					</div>
					<div class="modal-body" style="display: none;">
						<h5 style="font-weight:900; color:#000; border-bottom:2px solid #656565; padding: 0 0 9px 14px;">※ Make sure set up the database information when you access first time.</h5>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
							<label for="first_deviceId" style="padding-top: 8px;" class="control-label col-xs-4">database ID</label>
							<input type="text" class="form-control" name="first_deviceId" id="first_deviceId" placeholder="database ID" required>
						</div>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
							<label for="first_devicePw" style="padding-top: 8px;" class="control-label col-xs-4">Password</label>
							<input type="password" class="form-control" name="first_devicePw" id="first_devicePw" placeholder="Password" required>
						</div>
						<div class="form-inline" style="border-bottom: 1px dashed #eee;padding: 7px 0px;">
							<label for="first_c_devicePw" style="padding-top: 8px;" class="control-label col-xs-4">Check password</label>
							<input type="password" class="form-control" name="first_c_devicePw" id="first_c_devicePw" placeholder="Check password" required>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" accesskey="S" id="TheFirstSaveBtn">Change</button>
					</div>
				<%} %>
				</div>
			</div>
		</div>