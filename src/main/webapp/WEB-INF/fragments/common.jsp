<%@ page import="org.springframework.web.servlet.i18n.SessionLocaleResolver" %>
<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="java.util.Locale" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	String contentPath = request.getContextPath();
	boolean isIPv6 = Config.isIPv6;
	boolean isOCR = Config.isOCR;
	boolean consent = Config.getBoolean("consent.menu.enable");
	String systemLanguage = Common.nvl(Locale.getDefault(), "ko");
	String adminLanguage = systemLanguage;
	if (request.getRequestURI().toString().indexOf("login.jsp") == -1)
		adminLanguage = Common.nvl(session.getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME), "ko");
%>
<script>
	var contextRoot = '<%=contentPath%>';
	var consent = '<%=consent%>';
	var isIPv6 = '<%=isIPv6%>';
	var isOCR = '<%=isOCR%>';

	/* analysis */
	var messageGridColumn = {
        msgid: '<s:message code="common.msg.msgid"/>',
        userId: '<s:message code="common.msg.id"/>',
        readYn: '<s:message code="condition.read"/>',
        epmsg_type: '<s:message code="condition.epmsgType.list"/>',
        xrootmtr: '<s:message code="common.msg.xrootmtr"/>',
        interestUserYn: '<s:message code="message.msg.interest"/>',
        read_yn: '<s:message code="condition.read"/>',
        ml_confd_class: '<s:message code="condition.infotype"/>',
        ml_confd_feedback: '<s:message code="condition.feedback"/>',
        ml_confd_prob: '<s:message code="condition.prob"/>',
        attachcnt: '<s:message code="message.msg.file"/>',
        inside: '<s:message code="message.msg.inout"/>',
        msgin: '<s:message code="message.msg.in"/>',
        msgout: '<s:message code="message.msg.out"/>',
        direction_svc: '<s:message code="condition.receive_send"/>',
        receive: '<s:message code="condition.receive"/>',
        send: '<s:message code="condition.send"/>',
        svcNm: '<s:message code="condition.service"/>',
        subject: '<s:message code="condition.subject"/>',
        ctimeFormat: '<s:message code="condition.date"/>',
        user: '<s:message code="common.org.user"/>',
        businm: '<s:message code="common.org.businm"/>',
        deptnm: '<s:message code="common.org.dept"/>',
        jikgubnm: '<s:message code="common.org.jikgub"/>',
        sender: '<s:message code="condition.sender"/>',
        allofus: '<s:message code="condition.allofus"/>',
        recvs: '<s:message code="condition.recv"/>',
        to: '<s:message code="condition.to"/>',
        cc: '<s:message code="condition.cc"/>',
        bcc: '<s:message code="condition.bcc"/>',
        srcip: '<s:message code="condition.source"/>',
        dstip: '<s:message code="condition.destination"/>',
        sizeStr: '<s:message code="condition.size.all"/>',
        bodySizeStr: '<s:message code="condition.size.body"/>',
        attachSizeStr: '<s:message code="condition.size.attach.total"/>',
        kwds: '<s:message code="condition.keyword"/>',
        pi_total: '<s:message code="condition.regexp"/>',
        ocr: 'OCR <s:message code="message.msg.file"/>',
        attachname: '<s:message code="condition.attach_name"/>',
        reprocess: '<s:message code="condition.reprocess"/>',
		sabun: '<s:message code="common.msg.userid"/>'
	}

	var baseMsg1 = '<s:message code="analysis.ui.basemsg1"/>';
	var baseMsg2 = '<s:message code="analysis.ui.basemsg2"/>';

	var allofusMsg = {
		IA: '<s:message code="condition.allofus1"/>',
		ET: '<s:message code="condition.allofus8"/>',
		IT: '<s:message code="condition.allofus7"/>',
		EA: '<s:message code="condition.allofus2"/>',
		PT: '<s:message code="condition.allofus9"/>',
		PA: '<s:message code="condition.allofus3"/>',
		SO: '<s:message code="condition.allofus13"/>',
		SI: '<s:message code="condition.allofus14"/>'
	};

	var mlConfdClassMsg = {
		C4: '<s:message code="condition.info.class4"/>',
		C3: '<s:message code="condition.info.class3"/>',
		C2: '<s:message code="condition.info.class2"/>',
		C1: '<s:message code="condition.info.class1"/>',
		C0: '<s:message code="common.msg.noinfo"/>'
	};

	var mlConfdFeedbackMsg = {
		F1: '<s:message code="condition.info.feedback1"/>',
		F2: '<s:message code="condition.info.feedback2"/>',
		F3: '<s:message code="condition.info.feedback3"/>',
		F4: '<s:message code="condition.info.feedback4"/>',
		F0: '<s:message code="condition.info.feedback0"/>',
		F9: '<s:message code="condition.info.feedback9"/>'
	};
	//SK 하이닉스
	var skMlConfdClassMsg = {
		SC2: '<s:message code="condition.info.Y"/>',
		SC1: '<s:message code="condition.info.N"/>',
	};

	var skMlConfdFeedbackMsg = {
		SF1: '<s:message code="condition.info.secretFeedbackY"/>',
		SF2: '<s:message code="condition.info.secretFeedbackN"/>',
	};

	function addMonth2(day) {
		var today = new Date();
		today.setMonth(today.getMonth() + parseInt(day));

		return getDate(today);
	}


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

    var fileTagCode = '<input type="file"  name="attach" id="attach" style="display:none">';


    function attachInit(span,nametag,attach){
        $('#'+span).html(fileTagCode);
        $('#'+nametag).html('<s:message code="keyword.msg.upload.file"/>');
        $('#'+attach).change(function (){fileExtCheck($('#attach'));});
    }

	function reSizeHeight() {
		let h = $(window).height();
		$('.slickGrid').each(function (e) {
			let nHeight = h - $(this).offset().top - 50;
			nHeight = nHeight < 200 ? 200 : nHeight;
			if($(this).offset().top > 0 ) $(this).outerHeight(nHeight);
		});


		$('.highcharts-container').each(function (e) { // 통계화면
			if($(window).width() < $(this).width()) {
				$(this).width($(window).width()-200);
			}
		});

		if($('#svcDataChart').length > 0) { //Default Dashboard 전용
			if( ($(window).width() * 0.25) < $('#svcDataChart .highcharts-container').width() ) {
				$('#svcDataChart .highcharts-container').width($(window).width() * 0.25);
			}
		}
	}

	$(document).ready(function () {
		$(".nav-tabs").on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
			reSizeHeight();
		});

        //언어 설정
		$('#korLan').click(function (){
            var adminLang = (this).getAttribute('data-value');
            ui.confirmMsg('<s:message code="common.msg.change.apply"/>', '', '', function(rs){
                if(rs){
                    document.location.href = '<c:url value="/changeLocale?locale='+encodeURI(adminLang)+'"/>';
                }
            });
		})

        $('#EnLan').click(function (){
            var adminLang = (this).getAttribute('data-value');
            ui.confirmMsg('<s:message code="common.msg.change.apply"/>', '', '', function(rs){
                if(rs){
                    document.location.href = '<c:url value="/changeLocale?locale='+encodeURI(adminLang)+'"/>';
                }
            });
        })

		$(window).keydown(function (event) {
			if (event.keyCode === 32 || event.keyCode === 13) {
				if ($('#bootstrap_alert:visible').length > 0) {
					$('#bootstrap_alert:visible').find('button').click();
				}
			}
		});

		reSizeHeight();
		$(window).sizeChanged(function (element) {
			reSizeHeight();
		});

		$('button').easyHotkey();

		$('#TheFirstSaveBtn').click(function () {
			$('#TheFirstSaveBtn').prop('disabled', true);
			var first_adminId = $('#first_adminId').val().trim();
			var first_adminPw = $('#first_adminPw').val().trim();
			var first_c_adminPw = $('#first_c_adminPw').val().trim();
			var first_cur_adminPw = $('#first_cur_adminPw').val().trim();
			var first_accessIp = $('#first_accessIp').val().trim();
			if (first_adminId == '') {
				ui.alertMsg('<s:message code="admin.msg.enter.id"/>');
				$('#first_adminId').focus();
				$('#TheFirstSaveBtn').prop('disabled', false);
				return;
			}
			if (!idCheck(first_adminId)) {
				ui.alertMsg('<s:message code="admin.msg.use.englishid"/>');
				$('#first_adminId').focus();
				$('#TheFirstSaveBtn').prop('disabled', false);
				return;
			}
			if (first_adminPw == '') {
				ui.alertMsg('<s:message code="admin.msg.enter.pw"/>');
				$('#first_adminPw').focus();
				$('#TheFirstSaveBtn').prop('disabled', false);
				return;
			}
			if (first_c_adminPw == '') {
				ui.alertMsg('<s:message code="admin.msg.enter.cpw"/>');
				$('#first_c_adminPw').focus();
				$('#TheFirstSaveBtn').prop('disabled', false);
				return;
			}
			if (!validationPassword($('#first_adminId').val(), $('#first_adminPw').val(), "")) {
				$('#first_adminPw').focus();
				$('#TheFirstSaveBtn').prop('disabled', false);
				return;
			}
			if (!validationPassword($('#first_c_adminId').val(), $('#first_c_adminPw').val(), "")) {
				$('#first_c_adminPw').focus();
				$('#TheFirstSaveBtn').prop('disabled', false);
				return;
			}

			if (first_adminPw != first_c_adminPw) {
				ui.alertMsg('<s:message code="admin.msg.diff.pw"/>');
				$('#first_adminPw').focus();
				$('#TheFirstSaveBtn').prop('disabled', false);
				return;
			}
			if (first_cur_adminPw == sha256_digest(first_adminPw)) {
				ui.alertMsg('<s:message code="base.same.pw"/>');
				$('#first_adminPw').focus();
				$('#TheFirstSaveBtn').prop('disabled', false);
				return;
			}
			ui.confirmMsg('<s:message code="base.change.pw"/>', '', '', function (rs) {
				if (rs) {
					ui.get({
						url: 'updateAdminInfo.xcn',
						adminId: first_adminId,
						adminPw: sha256_digest(first_adminPw),
						accessIp: first_accessIp,
						/* mysqlUser	:first_deviceId,
						mysqlPw		:first_devicePw, */
						success: function (data, total) {
							closeAllPopup();
							$('#TheFirstSaveBtn').prop('disabled', false);
							ui.confirmMsg('<s:message code="base.saved.pw"/>', '', '', function (rs) {
								if (rs) {
									document.location.href = '<c:url value="/logout.do"/>';
								}
							});
						},
						error: function (status, message) {
							ui.alertMsg(message);
						},
						complete: function () {
							//restartTomcat();
							$('#TheFirstSaveBtn').prop('disabled', false);
						}
					});
				} else {
					$('#TheFirstSaveBtn').prop('disabled', false);
				}

			});
		});

		$('#changePasswordBtn').click(function () {
			$('#current_password').val('');
			$('#change_password').val('');
			$('#current_confirm_password').val('');

			$("#changePasswordPop").modal('show');
		});

		$('#changeLanguageBtn').click(function () {
			$('#adminLang').val(adminLang);
			$("#changeLanguagePop").modal('show');
		});

		$('#changePasswordSaveBtn').click(function () {
			var current_password = $('#current_password').val().trim();
			var change_password = $('#change_password').val().trim();
			var current_confirm_password = $('#current_confirm_password').val().trim();

			if (current_password == '') {
				ui.alertMsg('<s:message code="base.enter.current.pw"/>');
				return;
			}
			if (change_password == '') {
				ui.alertMsg('<s:message code="base.enter.change.pw"/>');
				return;
			}
			if (current_confirm_password == '') {
				ui.alertMsg('<s:message code="base.enter.changeconfirm.pw"/>');
				return;
			}

			if (change_password != current_confirm_password) {
				ui.alertMsg('<s:message code="base.different.pw"/>');
				return;
			}
			if (sha256_digest(current_password) != currentPw) {
				ui.alertMsg('<s:message code="base.wrong.pw"/>');
				return;
			}

			if (sha256_digest(current_password) == sha256_digest(change_password)) {
				ui.alertMsg('<s:message code="base.same.pw"/>');
				return;
			}

			if (!validationPassword('${_USERCREDENTIAL_.adminId}', change_password)) return;
			ui.confirmMsg('<s:message code="base.change.pw"/>', '', '', function (rs) {
				if (rs) {
					ui.get({
						url: 'updateAdminPassword.xcn',
						adminId: adminId,
						adminPw: sha256_digest(change_password),
						success: function (data, total) {
							ui.alertMsg('<s:message code="base.saved.pw"/>', function () {
								closeAllPopup();
								document.location.href = '<c:url value="/logout.do"/>';
							});
						},
						error: function (status, message) {
							ui.alertMsg(message);
						},
						complete: function () {
						}
					});
				}
			});
		});

		$('#changeLanguageSaveBtn').click(function () {
			var adminLang = $('#adminLang').val();
			ui.confirmMsg('<s:message code="common.msg.change.apply"/>', '', '', function (rs) {
				if (rs) {
					document.location.href = '<c:url value="/changeLocale?locale='+encodeURI(adminLang)+'"/>';
				}
			});
		});

		$('#logoutBtn').click(function () {
			ui.get({
				url: 'logout.xcn',
				success: function (data, total) {
					closeAllPopup();
					if (loginType == 'S') document.location.href = '<c:url value="/logoutSSO.do"/>';
					else document.location.href = '<c:url value="/logout.do"/>';
				},
				error: function (status, message) {
					console.log('Audit log insert fail');
				},
				complete: function () {
				}
			});
		});

		$('#systemSettingsMenu').click(function () {
			fnOpenWindow('<c:url value="/conf.do"/>', 'systemConfig', 1100, 800, 'scroll');
		});
		$('#adminSettingsMenu').click(function () {
			fnOpenWindow('<c:url value="/endPoints"/>', 'endPoints', 1300, 650, 'scroll');
		});


		$(document).on('click', '.print_link', function () {
            if( !(adminMenu == 'ALL' || adminMenu.indexOf("DP") > -1 || adminMenu.indexOf("LP") > -1 )) {
                ui.alertMsg('<s:message code="admin.auth.alert"/>')
                return false;

            }

			var grid = getTargetGrid($(this).attr('data-target'));
			var title = $(this).attr('rel');
			if (grid.Rows == 0) {
				alert('<s:message code="common.msg.nodata"/>');
				return;
			}
			grid.print(title, pMenuId, menuId);
		});
		$(document).on('click', '.excel_link', function () {
			var grid = getTargetGrid($(this).attr('data-target'));
			var title = $(this).attr('rel');
			var option = $(this).attr('option');
			grid.on();
			setTimeout(function () {
				excelDownLoad(grid, title, null, null, option);
			}, 200);
		});
		$(document).on('click', '.cell_link', function () {
			var grid = getTargetGrid($(this).attr('data-target'));
			var title = $(this).attr('rel');
			var option = $(this).attr('option');
			grid.on();
			setTimeout(function () {
				cellDownLoad(grid, title, null, null, option);
			}, 200);
		});

		$(document).on('click', '.pdf_link', function () {
			var grid = getTargetGrid($(this).attr('data-target'));
			var title = $(this).attr('rel');
			var option = $(this).attr('option');
			grid.on();
			setTimeout(function () {
				pdfDownLoad(grid, title, null, null, option);
			}, 200);
		});
		$(document).on('click', '.csv_link', function () {
			var grid = getTargetGrid($(this).attr('data-target'));
			var title = $(this).attr('rel');
			var option = $(this).attr('option');
			grid.on();
			setTimeout(function () {
				csvDownLoad(grid, title, null, null, option);
			}, 200);
		});

		$(document).on('click', '.saveNoLogUrlPopBtn', function () {
			$('.saveNoLogUrlPopBtn').prop('disabled', true);
			saveNoLogUrlData();
		});

		//목록개수
		var str = '';
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

		$(document).on('click', '.dropdown-menu a', function () {
			$(this).parent().parent().parent().find('.caret').attr('val', $(this).attr('data'));
			$(this).parent().parent().parent().find('.dropdown-text').text($(this).text());
			$(this).parent().parent().parent().find('.caret').trigger("change");
		});

		if ($('#gnbWrap').length > 0) {
			let socket = new SockJS(contextRoot + "/socket");
			socket.onheartbeat = function () {
				console.log('heartbeat');
			};
			socket.disconnect = function (data) {
				console.log('서버 연결이 해제 되었습니다.!');
			};

			stompClient = Stomp.over(socket);
			stompClient.debug = null
			let win_title = document.title;
			let connectCallback = function () {
				stompClient.subscribe('/topic/ntpCheck', function (frame) {
					let body = JSON.parse(frame.body);
					console.log(body);
					let lv = body.status;
					if (lv === 'sync') lv = 'info';
					else if (lv === 'unsync') lv = 'warning';
					else if (lv === 'unconnect') lv = 'danger';
					else lv = 'info';
					changeNTP(body.ntpServer, lv);
				});
				stompClient.subscribe('/user/${pageContext.session.id}/logout', function (frame) {
					closeAllPopup();
					eval(frame.body);
				});
				stompClient.subscribe('/user/${_USERCREDENTIAL_.adminId}/trap', function (frame) {
					var body = JSON.parse(frame.body);
					var lv = body.eventLevel;
					if (lv === 'I') lv = 'info';
					else if (lv === 'W') lv = 'warning';
					else if (lv === 'E') lv = 'danger';
					else lv = 'info';

					$.notify({
						icon: 'glyphicon glyphicon-warning-sign',
						title: '<strong>' + body.title + '</strong><br>',
						message: body.content
					}, {
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
				stompClient.subscribe('/user/${_USERCREDENTIAL_.adminId}/downloadProgress', function (frame) {
					var body = frame.body;
					document.title = 'Download : ' + body + '% ' + win_title;
					if (Number(body) > 99) document.title = win_title;
				});
				stompClient.subscribe('/user/${_USERCREDENTIAL_.adminId}/alarm', function (frame) {
					var body = JSON.parse(frame.body);
					$.notify({
						icon: 'glyphicon glyphicon-warning-sign',
						title: '<strong>' + body.title + '</strong><br>',
						message: body.content
					}, {
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
				stompClient.subscribe('/user/${_USERCREDENTIAL_.adminId}/exportEnd', function (frame) {
					var body = JSON.parse(frame.body);
					var statusStr = body.statusStr;
					var title = "";
					if (statusStr == "Y") title = '<s:message code="download.msg.end"/>';
					else if (statusStr == "C") title = '<s:message code="download.msg.cancel"/>';
					else title = '<s:message code="download.msg.error"/>';
					$.notify({
						icon: 'glyphicon glyphicon-warning-sign',
						title: '<strong>' + title + '</strong><br>',
						message: body.downVal.replaceAll('┌', '<br>')
					}, {
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
			var errorCallback = function (error) {
				console.log(error)
				window.setTimeout(function () {
					stompClient.connect('${pageContext.session.id}', "", connectCallback, errorCallback);
				}, 3000);
			};
			stompClient.connect('${pageContext.session.id}', "", connectCallback, errorCallback);
		}

		function setAlive() {
			stompClient.send("/app/browserAlive", {}, '${pageContext.session.id}');
		}

		if (menuId == '') checkMenuId();
	});

	var Messenger = {
		msg4: '<s:message code="common.messenger.msg4"/>',
		msg5: '<s:message code="common.messenger.msg5"/>'
	};

	//데이터베이스 패스워드 유효성 검사 //
	//8~15자,특수 문자 1개 이상, 숫자 1개 이상, 대 소문자 조합 조건 모두 충족 해야함
	function ccDatabasePw(pw) {
		if (/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&+=]).*$/.test(pw))
			return true;
		return false;
	}

	function writeExportMenu(target, gridName, title) {
		var str = '';
		str += '<li><a href="javascript:void(0);" class="excel_link" data-target="' + gridName + '" rel="' + title + '"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="common.msg.excel"/>(xlsx)</a></li>';
		str += '<li><a href="javascript:void(0);" class="cell_link" data-target="' + gridName + '" rel="' + title + '"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="common.msg.hancel"/>(cell)</a></li>';
		str += '<li><a href="javascript:void(0);" class="csv_link" data-target="' + gridName + '" rel="' + title + '"><span class="fa fa-file-text" style="font-size:16px"></span>&nbsp;<s:message code="common.msg.text"/>(csv)</a></li>';
		str += '<li><a href="javascript:void(0);" class="pdf_link" data-target="' + gridName + '" rel="' + title + '"><span class="fa fa-file-pdf-o" style="font-size:16px"></span>&nbsp;PDF</a></li>';
		str += '<li><a href="javascript:void(0);" class="print_link" data-target="' + gridName + '" rel="' + title + '"><span class="glyphicon glyphicon-print"></span>&nbsp;<s:message code="common.msg.print"/></a></li>';
		$('#' + target).append(str);
	}

	function loginCheck(firstAdmin) {
		adminId = $('#first_adminId').val().trim();
		if (firstAdminYn == '') firstAdminYn = firstAdmin;
		if ((pwchgDt == '' || pwchgDt == null)) {
			$('#first_adminId').prop("disabled", true);
			$('#first_accessIp_div').hide();
			$('#TheFirstChangePw').modal('show');
		}
	}

	//팝업 전용
	function checkMenuId() {
		if (opener) {
			try {
				menuId = opener.menuId;
				pMenuId = opener.pMenuId;
			} catch (e) {
				console.error(e);
			}
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
		if( consent=="true"  && firstAdminYn != 'Y' ) return true;
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
		return openMessageBodyPop(title, msgId, searchKey);
	}
	function openMessageBodyPop(title, msgId, searchKey){
		if( !isDetailView() ) return;
		if( searchKey == undefined ) searchKey = '';

		var url    = '<c:url value="/ems/contentBodyNew.do?msgid='+msgId+'&searchKey='+searchKey+'"/>';
		if( title == '' ) title='No_Title'+makeDateTime();
		return fnOpenWindow(url, title, 1000, 700, 'resize');
	}

	function openGroupMessagePop(){
		var url    = '<c:url value="/ems/contentGroup.do"/>';
		var title='_blank'+makeDateTime();
		return fnOpenWindow(url, title, 1280, 800, 'resize');
	}

	function makeDateTime(){
		return new Date().format('yyyymmddHHnnss');
	}







	// 목록개수 건수 조회
	function getPageSize(id) {
		return Number($('#' + id + ' .caret').attr('val'));
	}

	// 목록개수 건수 적용
	function setPageSize(id, val) {
		$('#' + id + ' .caret').attr('val', val);
		$('#' + id + ' .dropdown-text').text(val);
	}

	function csvDownLoad(grid, title, pmenu_id, menu_id, option) {
		if (grid.Rows == 0) {
			grid.off();
			alert('<s:message code="common.msg.nodata"/>');
			return;
		}
		if (pmenu_id == undefined || menu_id == undefined) {
			pmenu_id = pMenuId;
			menu_id = menuId;
		}
		var header = grid.getHeaderEXCEL();
		var body = grid.getBodyEXCEL(option);
		grid.on();
		ui.postJson({
			url: 'utils/csvWriter.do',
			title: title,
			header: header,
			body: body,
			pMenuId: pmenu_id,
			menuId: menu_id,
			success: function (data, total) {
				try {
					ExcelDown.location.href = '<c:url value="/utils/csvDown.do"/>?path=' + encodeURI(data);
				} catch (e) {
					ExcelDown.src = '<c:url value="/utils/csvDown.do"/>?path=' + encodeURI(data);
				}
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
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
		if (pmenu_id == undefined || menu_id == undefined) {
			pmenu_id = pMenuId;
			menu_id = menuId;
		}
		var header = grid.getHeaderEXCEL();
		var body = grid.getBodyEXCEL(option);
		grid.on();
		ui.postJson({
			url: 'utils/pdfWriter.do',
			title: title,
			header: header,
			body: body,
			pMenuId: pmenu_id,
			menuId: menu_id,
			success: function (data, total) {
				try {
					ExcelDown.location.href = '<c:url value="/utils/pdfDown.do"/>?path=' + encodeURI(data);
				} catch (e) {
					ExcelDown.src = '<c:url value="/utils/pdfDown.do"/>?path=' + encodeURI(data);
				}
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
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
		if (pmenu_id == undefined || menu_id == undefined) {
			pmenu_id = pMenuId;
			menu_id = menuId;
		}

		var header = grid.getHeaderEXCEL();
		var body = grid.getBodyEXCEL(option);
		grid.on();
		ui.postJson({
			url: 'utils/xlsxWriter.do',
			title: title,
			header: header,
			body: body,
			pMenuId: pmenu_id,
			menuId: menu_id,
			success: function (data, total) {
				try {
                    console.log("Try 블록 진입");
					ExcelDown.location.href = '<c:url value="/utils/xlsxDown.do"/>?path=' + encodeURI(data);
				} catch (e) {
                    console.error("Catch 블록에서 오류 발생:", e);
					ExcelDown.src = '<c:url value="/utils/xlsxDown.do"/>?path=' + encodeURI(data);
				}
			},
			error: function (status, message) {
                 console.error("Error 블록에서 오류 발생:", message);
				ui.alertMsg(message);
			},
			complete: function () {
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
		if (pmenu_id == undefined || menu_id == undefined) {
			pmenu_id = pMenuId;
			menu_id = menuId;
		}
		var header = grid.getHeaderEXCEL();
		var body = grid.getBodyEXCEL(option);
		grid.on();
		ui.postJson({
			url: 'utils/cellWriter.do',
			title: title,
			header: header,
			body: body,
			pMenuId: pmenu_id,
			menuId: menu_id,
			success: function (data, total) {
				try {
					ExcelDown.location.href = '<c:url value="/utils/xlsxDown.do"/>?path=' + encodeURI(data);
				} catch (e) {
					ExcelDown.src = '<c:url value="/utils/xlsxDown.do"/>?path=' + encodeURI(data);
				}
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
				grid.off();
			}
		});
	}


	function insertAudit(operation, information) {
		ui.get({
			url: 'insertAudit.xcn',
			menuId: menuId,
			pMenuId: pMenuId,
			operation: operation,
			information: information,
			success: function (data, total) {
			},
			error: function (status, message) {
				console.log('Audit log insert fail');
			},
			complete: function () {
			}
		});
	}

	function restartTomcat() {
		ui.get({
			url: 'restartTomcat.xcn',
			success: function (data, total) {
			},
			error: function (status, message) {
				console.log('restarTomcat fail');
			},
			complete: function () {
			}
		});
	}

	function chkInteger(val) {
		if (val == 0) return true;
		if (!Number(val)) {
			return false;
		}
		val = val + '';
		if (val.indexOf('.') > -1) {
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
		if (ipv6Check.storeIP(startIp) != "") startIp = ipv6Check.storeIP(startIp);
		if (ipv6Check.storeIP(endIp) != "") endIp = ipv6Check.storeIP(endIp);

		var iplen = 3;
		var symbol = '';
		if (ipv6Check.ver(startIp) == 6) {
			symbol = ':';
			iplen = 4;
		} else symbol = '.';
		var startIPArr = startIp.split(symbol);
		if (ipv6Check.ver(endIp) == 6) symbol = ':';
		else symbol = '.';
		var endIpArr = endIp.split(symbol);
		var startIpStr = "";
		var endIpStr = "";
		for (var i = 0; i < startIPArr.length; i++) {
			startIpStr += prependZero(startIPArr[i], iplen);
		}
		for (var i = 0; i < endIpArr.length; i++) {
			endIpStr += prependZero(endIpArr[i], iplen);
		}
		if (strcmp(startIpStr, endIpStr) == 1) return false;
		else return true;
	}

	function strcmp(a, b) {
		return (a < b ? -1 : (a > b ? 1 : 0));
	}

	function prependZero(num, len) {
		while (num.toString().length < len) {
			num = "0" + num;
		}
		return num;
	}

	function probPercent(val) {
		if (val == undefined || val == null || val == -1.0) return '-';
		return Math.floor(parseInt(val) * 100);
	}

	function saveNoLogUrlData() {
		$('#noLogurl').val($.trim($('#noLogurl').val()));
		if ($('#noLogurl').val() == '') {
			alert('<s:message code="filterInfo.msg.enter.url"/>');
			$('.saveNoLogUrlPopBtn').prop('disabled', false);
			return false;
		}
		var url = mode == 'insert' ? 'insertUrlFilter.xcn' : 'updateUrlFilter.xcn';
		var message = mode == 'insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
		ui.confirmMsg(message, '', '', function (rs) {
			if (rs) {
				ui.onBody('content_body', 0, 0);
				ui.post({
					url: url,
					data: $('#urlPopForm').serializeAll(),
					success: function (data, total) {
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						$('#urlPop').modal('hide');
					},
					error: function (status, message) {
						ui.alertMsg(message);
					},
					complete: function () {
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


    function initDateTimePicker(sid,eid){
        $('#'+sid).datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'ko',
	        showClose: true,
	        showTodayButton: true,
            defaultDate: moment(new Date()),
        });
        $('#'+eid).datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'ko',
	        showClose: true,
	        showTodayButton: true,
            defaultDate: moment(new Date())
        });
    }



</script>