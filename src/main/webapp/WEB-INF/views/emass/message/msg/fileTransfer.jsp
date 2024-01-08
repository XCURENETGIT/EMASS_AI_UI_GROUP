<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<%
	String adminType = Common.getAdminType(session);
	String firstAdminYn = Common.getFirstAdminYn(session);
%>

<script>
	$(function() {
		$("#xcn_toggleBtn").on("click", function() {
			$("#xcn_Search").toggle("show");
		})
	})

	$(function() {
		$("#showBtn").on("click", function() {
			$("#xcn_Search2").show();
		})
		$("#xcn_toggleBtn2").on("click", function() {
			$("#xcn_Search2").hide();
		})
	})
</script>

<style>

	#wrap {overflow:hidden;}

</style>

<head>
	<title>EMASS LT - <s:message code="DATA_MONITOR.MESSAGE_SERVICE"/></title>
	<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/collection.js"/>"></script>

	<script>
		var messengerListCnt = 0;
		var nodataMsg = '<s:message code="common.msg.nodata"/>';
		var chatting = '<s:message code="eikon.msg.chat"/>';
		var endChat = '<s:message code="eikon.msg.finish"/>';
		var unreadTitle = '<s:message code="eikon.msg.unreadTitle"/>';
		var condition = {
			messageInputFilter: '<s:message code="condition.message.input.filter"/>',
			messageInputPeriod: '<s:message code="condition.message.input.period"/>',
			consentMsgTimecheck: '<s:message code="consent.msg.timecheck"/>',
			messageNumbercheck: '<s:message code="condition.message.numbercheck"/>',
			messageFolderFilter: '<s:message code="condition.message.folder.filter"/>',
			messageSelectFolder: '<s:message code="condition.message.select.folder"/>',
			msgSaved: '<s:message code="common.msg.saved"/>',
			selectInterest: '<s:message code="condition.select.interest"/>',
			interestUserAll: '<s:message code="interest.user.all"/>',
			commonMsgAll: '<s:message code="common.msg.all"/>',
			serviceAll: '<s:message code="condition.service.all"/>',
			messengerAll: '<s:message code="condition.messenger.all"/>',
			orgBusiAll: '<s:message code="common.org.busi.all"/>',
			orgDeptAll: '<s:message code="common.org.dept.all"/>',
			msgSelect_all: '<s:message code="common.msg.select_all"/>',
			msgUnselect_all: '<s:message code="common.msg.unselect_all"/>',
			msgNoresult: '<s:message code="common.msg.noresult"/>',
			msgConnectError: '<s:message code="common.msg.connect.error"/>',
			messageSelectDashboard: '<s:message code="condition.message.select.dashboard"/>',
			msgConfirmSave: '<s:message code="common.msg.confirm.save"/>',
			searchService: '<s:message code="condition.search.service"/>',
			authAlert: '<s:message code="admin.auth.alert"/>',
			noselect: '<s:message code="common.msg.noselect"/>'

		};
		$(document).ready(function () {
			$(window).resize(function () {
				if ($(window).width() < 1700) {
					$('#searchResultBtnArea').addClass('btnCustomPosition');
				} else {
					$('#searchResultBtnArea').removeClass('btnCustomPosition');
				}
			});

			var today = new Date();
			today.setDate(today.getDate() - 2);

			document.getElementById("startDt").valueAsDate = today;
			document.getElementById("endDt").valueAsDate = new Date();

			document.getElementById("startSubDt").valueAsDate = today;
			document.getElementById("endSubDt").valueAsDate = new Date();

			$('#searchBtn').click(function () {
				if (messengerListCnt == 0) {
					ui.alertMsg('<s:message code="eikon.noList"/>');
					return;
				}
				var startDt = $('#startDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '');
				var endDt = $('#endDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '');
				if (startDt == '') {
					ui.alertMsg('<s:message code="message.message.startdt.input"/>');
					return;
				}
				if (endDt == '') {
					ui.alertMsg('<s:message code="message.message.enddt.input"/>');
					return;
				}
				if (startDt > endDt) {
					ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
					return;
				}
				/*      if (getDayInterval(startDt, endDt) > 31) {
                          ui.alertMsg('<s:message code="eikon.msg.select.date"/>');
                    return;
                }*/

				eikon2.getCollectionList(1);
			});
			$("#searchStrInput").keypress(function (e) {
				if (e.keyCode == 13) $('#searchBtn').click();
			}); //통합 검색 엔터키

			$('#searchMsgBtn').click(function () {
				if ($('#searchMsgStrInput').val() == "") $('#searchMsgQueryBtn').click();
				else eikon2.findMessageList(0);
				//eikon.getMessengerDetailList($('#xrootmtr').text(),$('#msgid').text(), $('#srcip').text());
			});
			$('#searchMsgQueryBtn').click(function () {
				var selectedUsrId = $('#selectUserInfo').attr('data-usrid');
				getDetailData(selectedUsrId);
			});
			$("#searchMsgStrInput").keypress(function (e) {
				if (e.keyCode == 13) {
					if ($('#searchMsgStrInput').val() == "") $('#searchMsgQueryBtn').click();
					else $('#searchMsgBtn').click();
				}
			});

			$('#searchMsgUp').click(function () {
				eikon2.findMessageList(--searchOffset);
// 		checkList(--searchOffset);
			});
			$('#searchMsgDn').click(function () {
// 		checkList(++searchOffset);
				eikon2.findMessageList(++searchOffset);
			});
			$('#listCntArea').click(function () {
				//if( $('#messageTotalCnt').html() == 0 || $('#messageTotalCnt').html() == '') return;
				openSelectDiv();
			});
			$('#userCntArea').click(function () {
				if ($('#selectUserInfo').html() == '-') return;
				openSelectUserDiv();
			});

			$('#dept').click(function () {
				var code = $(this).attr('id');
				openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
			});

			$('.txt_down').click(function () {
				downloadList('txt');
				hideSelect();
			});
			$('.excel_down').click(function () {
				downloadList('xlsx');
				hideSelect();
			});
			$('.html_down').click(function () {
				downloadList('html');
				hideSelect();
			});
			$(document).on('click', '.excel_file_down', function () {
				var userid = $('#selectUserInfo').attr('data-name');
				var srcip = $('#selectUserInfo').attr('data-srcip');
				var startDt = $('#startSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '')+"0000000";
				var endDt = $('#endSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '')+"235959";
				var searchStr = '';
				if (userid == '') return;
				eikon2.getCollectionGroupTextExport('<c:url value="/getCollectionGroupAllExport.xcn"/>?userid=' + userid + '&srcip=' + srcip + '&startDt=' + startDt + '&endDt=' + endDt + '&searchStr=' + searchStr+'&limit=1000&facet_detail=true&export=true');
				hideSelect();
			});

			$(document).on('click', '.downAllFile', function(){
				var downloadFlag = false;
				$('.downloadIcon').each ( function ( i, item ) {
					var attachHash = $(this).parents('p').attr('attachhash');
					if( attachHash != ''){
						downloadFlag = true;
					}
				});
				if( !downloadFlag){
					alert('<s:message code="message.message.notfound.attach"/>');
					return;
				}

				var msgIds=[];
				$('.downloadIcon').each ( function ( i, item ) {
					var msgId = $(this).parents('p').attr('msgid');
					msgIds.push(msgId);
				});

				var attachUrl = '<c:url value="/downEmassAttachByMsgId.xcn"/>?msgIds='+msgIds.join(',');
				try {
					AttachDown.location.href = attachUrl;
				} catch (e) {
					AttachDown.src = attachUrl;
				}
			});


			$(document).on('click', '.downloadIcon', function(){
				var msgId = $(this).parents('p').attr('msgid');
				var attachHash = $(this).parents('p').attr('attachhash');
				var attachSize = Number( $(this).parents('p').attr('attachsize') );
				var attachUrl = '<c:url value="/downEmassAttachOne.xcn"/>?msgId='+msgId+'&attachHash='+attachHash;

				if( attachHash == ''){
					alert('<s:message code="message.message.notfound.attach"/>');
					return;
				}

				if ( attachSize == 0 || attachSize == 'NaN' ) attachSize = 1;

				try {
					AttachDown.location.href = attachUrl;
				} catch (e) {
					AttachDown.src = attachUrl;
				}
			});

			$(document).on('mouseover', '.codeSelectedBtn', function (e) {
				$('#selectedCodeTitle').show();
				$('#selectedCodeTitle').css('left', (e.pageX + 5) + 'px');
				$('#selectedCodeTitle').css('top', (e.pageY - 120) + 'px');

				var str = $(this).parent().find('.selectedTitle').val();
				if (str != undefined) str = str.replaceAll('\\|', ',');
				$('#selectedCodeTitle').html(str);
			});

			$(document).on('mousemove', '.codeSelectedBtn', function (e) {
				$('#selectedCodeTitle').css('left', (e.pageX + 5) + 'px');
				$('#selectedCodeTitle').css('top', (e.pageY - 120) + 'px');

				var str = $(this).parent().find('.selectedTitle').val();
				if (str != undefined) str = str.replaceAll('\\|', ',');
				$('#selectedCodeTitle').html(str);
			});

			$(document).on('mouseout', '.codeSelectedBtn', function (e) {
				$('#selectedCodeTitle').hide();
			});

			$(document).on('click', '.codeSelectedBtn', function (e) {
				$('#deptVal, #deptStr').val('');
				$('#deptSelectedArea').hide();
			});

			$(document).on('click', '.me', function (e) {

				var userid = $(this).parent().attr('userid');
				var srcip = $(this).parent().attr('srcip');
				var id = $(this).parent().attr('id');
				updateEmassGenerativeAdminUserid(userid, id, srcip,"G");

				moveTargetHeight(id, false);
			});

			$(document).on('click', '.person', function () {

				if ((isConsent() && $('#consentNo').val() == '') || $(this).attr('userid') == '') {
					return;
				}
				//if($(this).hasClass('active')) return;
				$('.person').each(function () {
					$(this).removeClass('active');
				});

				$(this).addClass('active');
				$('#userid').text($(this).attr('userid'));

				$('#srcip').text($(this).attr('srcip'));
				$('#msgid').text($(this).attr('msgid'));
				$('#usrid').text($(this).attr('usrid'));

				$('#selectUserInfo').attr('data-name', '');
				$('#selectUserInfo').attr('data-srcip', '');
				$('#selectUserInfo').attr('data-usrid', '');
				$('#selectUserInfo').html('');
				$('#searchMsgStrInput').val('');
				$('#startSubDt').val($('#startDt').val());
				$('#endSubDt').val($('#endDt').val());
				focusMsgId = '';
				/*eikon2.getGenerativeDetailList($(this).attr('userid'), $(this).attr('msgid'), $(this).attr('srcip'), $(this).attr('usrid'));*/
			});

			$('input[name="searchType"]:radio').change(function () {
				eikon2.getCollectionList(1);
			});

			$('#groupFileCnt').click(function () {
				fileInfoViewer($('#userid').text(), $('#srcip').text(), $('#usr_id').text());
			});

			$('#groupParticipant').click(function () {
				participantInfoViewer($('#userid').text(), $('#usr_id').text());
			});

			$(document).on('click', '.person', function () {
				var name = $(this).attr('userid');
				var srcip = $(this).attr('srcip');
				var usr_id = $(this).attr('usr_id');
				var userid =  $(this).attr('userid');
				var msgid = $(this).attr('msgid');
				var username= $(this).attr('name');

				$('#selectUserInfo').attr('data-srcip', srcip);
				$('#selectUserInfo').attr('data-name', name);
				$('#selectUserInfo').attr('data-usrid', usr_id);

				$('#selectUserInfo').html(userid+"("+username+")");
				$('#subchatid').html(": "+name);
				$('#srcip').text(srcip);
				$('#usr_id').text(usr_id);
				eikon2.getCollectionDetailList(userid, msgid, srcip, usr_id,"G");
				hideUserSelect();
			});

			initCondition();
			eikon2.init();
// 	$('#searchBtn').click();

		});

		function openCodeWindow(id, oldCode, oldConm) {
			$('#oldCode').val(oldCode);
			$('#oldConm').val(oldConm);

			var url = '<c:url value="/commons/selectCode.do?codeType='+id+'"/>';
			var pop = fnOpenWindow('', 'selectCodeWinPopup', 1200, 700, 'resize');

			$('#codeParam').attr('target', 'selectCodeWinPopup');
			$('#codeParam').attr('action', url);
			$('#codeParam').attr('method', 'post');
			$('#codeParam').submit();
		}

		function openSelectUserDiv() {
			var status = $('#userCntArea').hasClass('clicked');
			if (status) {
				hideUserSelect();
			} else {
				showUserSelect();
			}
		}

		function hideUserSelect() {
			if ($('#selectUser_menu')) {
				$('#selectUser_menu').hide();
				$('#userCntArea').removeClass('clicked');
			}
			$(document).unbind("mousedown", onBodyMouseDownPeriodUser);
		}

		function showUserSelect() {
			$('#selectUser_menu').show();
			$('#userCntArea').addClass('clicked');
			$(document).bind("mousedown", onBodyMouseDownPeriodUser);
		}

		function onBodyMouseDownPeriodUser(event) {
			if (!(event.target.id == "selectUser_menu" || $(event.target).parents("#selectUser_menu").length > 0)) {
				hideUserSelect();
			}
		}

		function openSelectDiv() {
			var status = $('#listCntArea').hasClass('clicked');
			if (status) {
				hideSelect();
			} else {
				showSelect();
			}
		}

		function hideSelect() {
			if ($('#export_menu')) {
				$('#export_menu').hide();
				$('#listCntArea').removeClass('clicked');
			}
			$(document).unbind("mousedown", onBodyMouseDownPeriod);
		}

		function showSelect() {
			$('#export_menu').show();
			$('#listCntArea').addClass('clicked');
			$(document).bind("mousedown", onBodyMouseDownPeriod);
		}

		function onBodyMouseDownPeriod(event) {
			if (!(event.target.id == "export_menu" || $(event.target).parents("#export_menu").length > 0)) {
				hideSelect();
			}
		}


		function downloadList(type) {

			var userid = $('#selectUserInfo').attr('data-name');
			var srcip = $('#selectUserInfo').attr('data-srcip');
			var usr_id = $('#selectUserInfo').attr('usr_id');

			if (userid == '') return;
			var startDt = $('#startSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '')+"000000";
			var endDt = $('#endSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '')+"235959";
			var searchStr = '';

			eikon2.getCollectionGroupTextExport('<c:url value="/getCollectionrGroupTextExport.xcn"/>?userid=' + userid + '&srcip=' + srcip + '&startDt=' + startDt + '&endDt=' + endDt + '&searchStr=' + searchStr + '&type=' + type + '&groupField=sender_str&limit=1000&', userid);
		}


		function searchConsentNo() {
			var url = '<c:url value="/ems/selectConsent.do"/>';
			return fnOpenWindow(url, 'selectConsentWinPopup', 830, 700, 'resize');
		}

		function selectedConsent(obj) {
			if (obj == '') {
				$('#consentNo').val('');
				$('#consentName').text('');
				/* $('#consentIp').val('');
                $('#consentEmail').val(''); */
				$('#consentUserId').val('');
				$('#consentBtn').removeClass('active');
			} else {
				$('#consentNo').val(obj.no);
				$('#consentName').text(obj.name + "[" + obj.userId + ", " + (obj.deptNm == '' ? '<s:message code="consent.select.consentDept"/>' : obj.deptNm) + "]");
				/* $('#consentIp').val(obj.userIp);
                $('#consentEmail').val(obj.userEmail); */
				$('#consentUserId').val(obj.userId);
				$('#consentBtn').addClass('active');
			}
		}

		function initCondition() {
			getGenerativeList();
			getCodeList('busi');
			getCodeList('dept');

			var dateObj = new Date();


			$('#easyDate').change(function () {
				changeDate($(this).val());
			});
			$('#timedatepicker').datetimepicker({
				format: 'YYYY-MM-DD',
				locale: 'ko',
				defaultDate: moment(new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59))
			}).on("dp.change", function (e) {
				var date = $(this).data("DateTimePicker").date().format('YYYY-MM-DD');
				detailDateFocus(date);

				$('#searchMsgStrInput').val('');
				$('#searchResult').html('');
				$('#searchResultArea').hide();
				$('#searchResultBtnArea').hide();
			});

			$('#serviceTypeSelect').selectpicker({
				size: 15,
				width: '300px',
				noneSelectedText: condition.serviceAll,
				noneResultsText: condition.msgNoresult + ' ',
				selectAllText: condition.msgSelect_all,
				deselectAllText: condition.msgUnselect_all,
				liveSearchPlaceholder: condition.searchService
			});

			$('#busiSelect').selectpicker({
				size: 15,
				width: '300px',
				searchLabel: true,
				noneSelectedText: '<s:message code="common.org.busi.all"/>',
				noneResultsText: '<s:message code="common.msg.noresult"/>' + ' ',
				selectAllText: '<s:message code="common.msg.select_all"/>',
				deselectAllText: '<s:message code="common.msg.unselect_all"/>'
			});

			$('#searchField').selectpicker({
				width: '100px',
				noneSelectedText: '<s:message code="common.msg.all"/>'
			});

			$('button[name="attachYn"]').click(function(){
				$(this).addClass('active');
				$('button[name="attachYn"]').not(this).removeClass('active')
				var attachYnValue = $(this).attr('value');

				if (attachYnValue === '') {
					$("#searchField option:eq(1)").prop('disabled', false);
				} else {
					$("#searchField option:eq(1)").prop('disabled', true);
				}

				$('#searchField').selectpicker('refresh');

			});
		}

		function getCodeList(codeType) {
			ui.get({
				url: 'getCodeList.xcn',
				codeType: codeType,
				success: function (data, total) {
					$('#' + codeType + 'Select').html(getSelectOption(data));
					$('#' + codeType + 'Select').selectpicker('refresh');
					$('#' + codeType + 'SelectPop').html(getSelectOption(data));
					$('#' + codeType + 'SelectPop').selectpicker('refresh');
				},
				error: function (status, message) {
					ui.alertMsg('error:' + status);
				},
				complete: function () {
					searchFlag = false;
				}
			});
		}

		function getSelectOption(data) {
			var str = '';
			for (var i = 0; i < data.length; i++) {
				str += '<option value="' + data[i].code + '">' + data[i].codeName + '</option>';
			}
			return str;
		}


		function getCondition() {
			var filterVal = {};

			if (isConsent()) {
				filterVal.consentNo = $('#consentNo').val();
				filterVal.consentName = $('#consentName').text();
				//filterVal.consentIp = $('#consentIp').val();
				//filterVal.consentEmail = $('#consentEmail').val();
				filterVal.consentUserId = $('#consentUserId').val();
			}

			var conArray = [];
			conArray.push(createCondition());
			filterVal.conditions = conArray;

			//console.log(JSON.stringify(filterVal))
			return filterVal;
		}

		function createCondition() {
			var allSelect = new Array();
			var condition = {};
			if ($('#serviceTypeSelect').selectpicker('val') == null) {
				$('#serviceTypeSelect option').each(function () {
					if ($(this).val() != '' && $(this).val() != null) allSelect.push($(this).val());
				});
				condition.serviceType = arrayToString(allSelect);
			} else {
				condition.serviceType = arrayToString($('#serviceTypeSelect').selectpicker('val'));
			}
			condition.searchStr = $('#searchStrInput').val();
			condition.senders = $('#senders').val();
			condition.attachYn = $('button[name=attachYn].active').val();
			condition.busi = arrayToString($('#busiSelect').selectpicker('val'));

			if (condition.busi != '') condition.busiStr = $('#busiSelect').parent().find('.filter-option').text();
			else condition.busiStr = '';

			var dv = $('#deptVal').val().split('|');
			condition.dept = dv.join(',');
			if (condition.dept != '') condition.deptStr = $('#deptStr').val();
			else condition.deptStr = '';
			/* condition.dept = arrayToString($('#deptSelect').selectpicker('val'));
            if(condition.dept != '') condition.deptStr = $('#deptSelect').parent().find('.filter-option').text();
            else condition.deptStr = ''; */

			condition.period = 1;
			condition.startDt =$('#startDt').val()+"000000";
			condition.endDt =$('#endDt').val()+"235959";

			return condition;
		}

		function arrayToString(array) {
			if (array == null || array == undefined) return "";
			else {
				return array.toString();
			}
		}

		function stringToArray(string) {
			if (string == null || string == undefined || string == '') return '';
			else if (typeof string != 'string') return string;
			else {
				return string.split(',');
			}
		}

		function getMessengerList() {
			ui.get({
				url: 'getMessengerList.xcn',
				asyncFlag: false,
				success: function (data, total) {
					messengerListCnt = data.length;
					if (data.length > 0) {
						$('#serviceTypeSelect').html(getSelectOptionMessenger(data));
					}
				},
				error: function (status, message) {
					ui.alertMsg('error:' + status);
				},
				complete: function () {
					searchFlag = false;
				}
			});
		}

		function getSelectOptionMessenger(data) {
			//var str = '<option value="">- <s:message code="eikon.msg.svcType"/> -</option>';
			var str = '';
			for (var i = 0; i < data.length; i++) {
				str += '<option value="' + data[i].code + '">' + data[i].codeName + '</option>';
			}
			return str;
		}

		function getSelectedCodeData(codeType, data) {
			var str = '';
			var val = '';
			for (var i = 0; i < data.length; i++) {
				str += data[i].codeName;
				val += data[i].code;
				if (codeType == 'regexp') {
					var arr = data[i].count.split('@');
					if (arr[0] == 'B') str += '(' + arr[1] + '<s:message code="selectCodeAll.items"/> ~ ' + arr[2] + '<s:message code="selectCodeAll.items"/>)';
					else if (arr[0] == 'L') str += '(' + arr[1] + '<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>)';
					else str += '(' + arr[1] + '<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.below"/>)';
					val += '%' + data[i].count;
				}

				if (i != data.length - 1) {
					str += ', ';
					val += '|';
				}
			}
			if (val != '') {
				str = str.rtrim();
				val = val.trimAll();
			}

			$('#' + codeType + 'Str').val(str);
			$('#' + codeType + 'Val').val(val);

			if ($('#' + codeType + 'Str').val() != '') {
				$('#' + codeType + 'SelectedArea').find('.btn').text(data.length);
				$('#' + codeType + 'SelectedArea').show();
			} else {
				$('#' + codeType + 'SelectedArea').find('.btn').text(0);
				$('#' + codeType + 'SelectedArea').hide();
			}
		}

		function resetCode(codeType) {
			if (codeType == 'deptByCo') $('#deptByCoStrSpan').html('');
			$('#' + codeType + 'Val').val('');
			$('#' + codeType + 'Str').val('');
			$('#' + codeType + 'SelectedArea').hide();
		}
	</script>
</head>
<div id="searchArea">
	<div class="inner_messenger">
		<%--			검색 영역--%>
		<div class="leftSearch p20" id="xcn_Search">
			<div class="leftSearchTab mat8">
				<button class="active" onclick="openCity('Tab01')">파일전송 검색</button>
				<!--<button onclick="openCity('Tab02')">탭 비활성</button>-->
			</div>
			<div id="Tab01">
				<div>
					<h3 class="mat16">기본 검색</h3>
					<%if (consent && Common.isEquals(firstAdminYn, "N") && Common.isNotEquals(adminType, "C")) { %>
					<div class="form-group form-inline not-dashed" style="padding-left: 10px; width: 100%; margin-bottom: 3px;">
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="consentBtn" onclick="searchConsentNo();"><span
								class="glyphicon glyphicon-tags"></span>&nbsp;<s:message code="consent.select.consent"/></button>
						<input type="text" style="width:120px;height:28px;display:none;" readonly="readonly" id="consentNo">
						<input type="hidden" readonly="readonly" id="consentIp">
						<input type="hidden" readonly="readonly" id="consentEmail">
						<input type="hidden" readonly="readonly" id="consentUserId">
						<span id="consentName" style="font-weight: bold;"></span>
					</div>
					<%} %>
					<div>
						<input class="w100" type="text" id="searchStrInput" placeholder="회사명을 입력하세요">
						<input class="w100 mat8" type="text" id="searchStrInput" placeholder="사용자명을 입력하세요">
					</div>
					<div class="optiotab w100 mat8" data-toggle="buttons">
						<button class="active w50" name="attachYn" id="attachAll" value=""><s:message code="condition.isattached.all"/></button>
						<button class="w50" name="attachYn" id="attachY" value="Y"><s:message code="eikon.attach.exist"/></button>
					</div>
					<h3 class="mat16">상세 검색</h3>
					<div>

						<input class="w45 txt_center" type="date" id="startDt"  value="2023-11-20"><span class="w10 dis_inlineblock txt_center">~</span><input class="w45 txt_center" type="date" id="endDt"  value="2023-11-30">
						<input type="text" class="w100 mat8"  placeholder="사업장을 선택하세요" id="senders">
						<input type="text" class="w100 mat8"  placeholder="부서명을 입력하세요" id="senders">
						<div id="selectedCodeTitle" class="infotxt"></div>
						<h5 class="mat16">패턴</h5>
						<div class="optiotab w100 mat4" data-toggle="buttons">
							<button class="active w33" name="attachYn" id="attachAll" value="">전체</button>
							<button class="w33" name="attachYn" id="attachY" value="Y">있음</button>
							<button class="w33" name="attachYn" id="attachY" value="Y">없음</button>
						</div>
						<h5 class="mat8">예약어</h5>
						<div class="optiotab w100 mat4" data-toggle="buttons">
							<button class="active w33" name="attachYn" id="attachAll" value="">전체</button>
							<button class="w33" name="attachYn" id="attachY" value="Y">있음</button>
							<button class="w33" name="attachYn" id="attachY" value="Y">없음</button>
						</div>

					</div>
				</div>

				<div class="fixBtn">
					<div class="xcn_checkbox">
						<input type="checkbox" name="readYn" id="readYn"><label><s:message code="eikon.msg.notRead"/></label>
					</div>
					<button class="fullbtn" type="button" accesskey="Q" id="searchBtn">검색</button>
				</div>
			</div>
		</div>
		<%--			검색 끝!--%>

		<%--			검색 결과 영역--%>
		<div class="messengerList" >
			<div class="messengerBox">
				<div class="subTit p12">
					<h2 class="ma_none pb4">
						<button id="xcn_toggleBtn" class="menu"></button>파일 모아보기
					</h2>
				</div>
				<div class="bortop_dd pt16 pl20 pr20">
				</div>
				<div style="height:740px; overflow: auto;">
					<div class="list-group" id="group_list" style="margin-bottom: 0px;">
						<ul class="people">
							<li class="person">
								<div class="left">
									<p>
										<span class="file_flag_reception"><img src="<c:url value="/img/ico_w_chatshare_fill.png"/>" alt="외부" height="12px">외부</span>
										<span class="chatid">2024_사업계획_v1.0_엑스큐어넷 4층 연구소_데이터응용팀.pdf</span>
									</p>
									<p>
										<span class="name">새절사업장</span> <span class="bar"></span>
										<span class="name">데이터 코어팀</span> <span class="bar"></span>
										<span class="name">수석</span> <span class="bar"></span>
										<span class="name">홍길동</span><span class="bar"></span>
										<span class="name">233KB</span>
									</p>
								</div>
								<div class="right">
									<p><span class="logo"><img src="/venus/img/icon/ico_sns_IGPS.png">OneDrive</span></p>
									<p><span class="time">2023-12-04 10:20:12</span></p>
								</div>
								<div style="clear: both; overflow: hidden;">

									<p class="xcn_file_btn ">


										<button class="btn06 mat32" id="mouse-over-label"><img src="<c:url value="/img/subBtn_eye.png"/>" alt="미리보기">미리보기</button><button class="btn06"><img src="<c:url value="/img/subBtn_file_open.png"/>" alt="열기">열기
										</button><button class="btn06"><img src="<c:url value="/img/subBtn_folder_open.png"/>" alt="폴더">폴더열기</button><button class="btn06"><img src="<c:url value="/img/subBtn_share.png"/>" alt="전달">전달
										</button><button class="btn02"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제">삭제</button><button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="저장">저장
										</button><!--<button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="다른이름">다름이름으로 저장</button>-->

									</p>
								</div>
							</li>
							<li class="person">
								<div class="left">
									<p>

										<span class="chatid">2024_사업계획_v1.0_엑스큐어넷 4층 연구소_데이터응용팀.pdf</span>
									</p>
									<p><span class="name">새절사업장</span> <span class="bar"></span>
										<span class="name">데이터 코어팀</span> <span class="bar"></span>
										<span class="name">수석</span> <span class="bar"></span>
										<span class="name">홍길동</span><span class="bar"></span>
										<span class="name">233KB</span>
									</p>
								</div>
								<div class="right">
									<p><span class="logo"><img src="/venus/img/icon/ico_sns_IGPS.png">OneDrive</span></p>
									<p><span class="time">2023-12-04 10:20:12</span></p>
								</div>
								<div style="clear: both; overflow: hidden;">
									<p class="xcn_file_btn">
										<button class="btn06 mat32"><img src="<c:url value="/img/subBtn_eye.png"/>" alt="미리보기">미리보기</button><button class="btn06"><img src="<c:url value="/img/subBtn_file_open.png"/>" alt="열기">열기
									</button><button class="btn06"><img src="<c:url value="/img/subBtn_folder_open.png"/>" alt="폴더">폴더열기</button><button class="btn06"><img src="<c:url value="/img/subBtn_share.png"/>" alt="전달">전달
									</button><button class="btn02"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제">삭제</button><button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="저장">저장
									</button><!--<button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="다른이름">다름이름으로 저장</button>-->
									</p>
								</div>
							</li>
							<li class="person">
								<div class="left">
									<p>

										<span class="chatid">2024_사업계획_v1.0_엑스큐어넷 4층 연구소_데이터응용팀.pdf</span>
									</p>
									<p><span class="name">새절사업장</span> <span class="bar"></span>
										<span class="name">데이터 코어팀</span> <span class="bar"></span>
										<span class="name">수석</span> <span class="bar"></span>
										<span class="name">홍길동</span><span class="bar"></span>
										<span class="name">233KB</span>
									</p>
								</div>
								<div class="right">
									<p><span class="logo"><img src="/venus/img/icon/ico_sns_IGPS.png">OneDrive</span></p>
									<p><span class="time">2023-12-04 10:20:12</span></p>
								</div>
								<div style="clear: both; overflow: hidden;">
									<p class="xcn_file_btn">
										<button class="btn06 mat32"><img src="<c:url value="/img/subBtn_eye.png"/>" alt="미리보기">미리보기</button><button class="btn06"><img src="<c:url value="/img/subBtn_file_open.png"/>" alt="열기">열기
									</button><button class="btn06"><img src="<c:url value="/img/subBtn_folder_open.png"/>" alt="폴더">폴더열기</button><button class="btn06"><img src="<c:url value="/img/subBtn_share.png"/>" alt="전달">전달
									</button><button class="btn02"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제">삭제</button><button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="저장">저장
									</button><!--<button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="다른이름">다름이름으로 저장</button>-->
									</p>
								</div>
							</li>
							<li class="person">
								<div class="left">
									<p>
										<span class="file_flag_reception"><img src="<c:url value="/img/ico_w_chatshare_fill.png"/>" alt="외부" height="12px">외부</span>
										<span class="chatid">2024_사업계획_v1.0_엑스큐어넷 4층 연구소_데이터응용팀.pdf</span>
									</p>
									<p><span class="name">새절사업장</span> <span class="bar"></span>
										<span class="name">데이터 코어팀</span> <span class="bar"></span>
										<span class="name">수석</span> <span class="bar"></span>
										<span class="name">홍길동</span><span class="bar"></span>
										<span class="name">233KB</span>
									</p>
								</div>
								<div class="right">
									<p><span class="logo"><img src="/venus/img/icon/ico_sns_IGPS.png">OneDrive</span></p>
									<p><span class="time">2023-12-04 10:20:12</span></p>
								</div>
								<div style="clear: both; overflow: hidden;">
									<p class="xcn_file_btn">
										<button class="btn06 mat32"><img src="<c:url value="/img/subBtn_eye.png"/>" alt="미리보기">미리보기</button><button class="btn06"><img src="<c:url value="/img/subBtn_file_open.png"/>" alt="열기">열기
									</button><button class="btn06"><img src="<c:url value="/img/subBtn_folder_open.png"/>" alt="폴더">폴더열기</button><button class="btn06"><img src="<c:url value="/img/subBtn_share.png"/>" alt="전달">전달
									</button><button class="btn02"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제">삭제</button><button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="저장">저장
									</button><!--<button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="다른이름">다름이름으로 저장</button>-->
									</p>
								</div>
							</li>
							<li class="person">
								<div class="left">
									<p>
										<span class="file_flag_reception"><img src="<c:url value="/img/ico_w_chatshare_fill.png"/>" alt="외부" height="12px">외부</span>
										<span class="chatid">2024_사업계획_v1.0_엑스큐어넷 4층 연구소_데이터응용팀.pdf</span>
									</p>
									<p><span class="name">새절사업장</span> <span class="bar"></span>
										<span class="name">데이터 코어팀</span> <span class="bar"></span>
										<span class="name">수석</span> <span class="bar"></span>
										<span class="name">홍길동</span><span class="bar"></span>
										<span class="name">233KB</span>
									</p>
								</div>
								<div class="right">
									<p><span class="logo"><img src="/venus/img/icon/ico_sns_IGPS.png">OneDrive</span></p>
									<p><span class="time">2023-12-04 10:20:12</span></p>
								</div>
								<div style="clear: both; overflow: hidden;">
									<p class="xcn_file_btn">
										<button class="btn06 mat32"><img src="<c:url value="/img/subBtn_eye.png"/>" alt="미리보기">미리보기</button><button class="btn06"><img src="<c:url value="/img/subBtn_file_open.png"/>" alt="열기">열기
									</button><button class="btn06"><img src="<c:url value="/img/subBtn_folder_open.png"/>" alt="폴더">폴더열기</button><button class="btn06"><img src="<c:url value="/img/subBtn_share.png"/>" alt="전달">전달
									</button><button class="btn02"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제">삭제</button><button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="저장">저장
									</button><!--<button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="다른이름">다름이름으로 저장</button>-->
									</p>
								</div>
							</li>
							<li class="person">
								<div class="left">
									<p>
										<span class="file_flag_reception"><img src="<c:url value="/img/ico_w_chatshare_fill.png"/>" alt="외부" height="12px">외부</span>
										<span class="chatid">2024_사업계획_v1.0_엑스큐어넷 4층 연구소_데이터응용팀.pdf</span>
									</p>
									<p><span class="name">새절사업장</span> <span class="bar"></span>
										<span class="name">데이터 코어팀</span> <span class="bar"></span>
										<span class="name">수석</span> <span class="bar"></span>
										<span class="name">홍길동</span><span class="bar"></span>
										<span class="name">233KB</span>
									</p>
								</div>
								<div class="right">
									<p><span class="logo"><img src="/venus/img/icon/ico_sns_IGPS.png">OneDrive</span></p>
									<p><span class="time">2023-12-04 10:20:12</span></p>
								</div>
								<div style="clear: both; overflow: hidden;">
									<p class="xcn_file_btn">
										<button class="btn06 mat32"><img src="<c:url value="/img/subBtn_eye.png"/>" alt="미리보기">미리보기</button><button class="btn06"><img src="<c:url value="/img/subBtn_file_open.png"/>" alt="열기">열기
									</button><button class="btn06"><img src="<c:url value="/img/subBtn_folder_open.png"/>" alt="폴더">폴더열기</button><button class="btn06"><img src="<c:url value="/img/subBtn_share.png"/>" alt="전달">전달
									</button><button class="btn02"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제">삭제</button><button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="저장">저장
									</button><!--<button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="다른이름">다름이름으로 저장</button>-->
									</p>
								</div>
							</li>
							<li class="person">
								<div class="left">
									<p>
										<span class="file_flag_reception"><img src="<c:url value="/img/ico_w_chatshare_fill.png"/>" alt="외부" height="12px">외부</span>
										<span class="chatid">2024_사업계획_v1.0_엑스큐어넷 4층 연구소_데이터응용팀.pdf</span>
									</p>
									<p><span class="name">새절사업장</span> <span class="bar"></span>
										<span class="name">데이터 코어팀</span> <span class="bar"></span>
										<span class="name">수석</span> <span class="bar"></span>
										<span class="name">홍길동</span><span class="bar"></span>
										<span class="name">233KB</span>
									</p>
								</div>
								<div class="right">
									<p><span class="logo"><img src="/venus/img/icon/ico_sns_IGPS.png">OneDrive</span></p>
									<p><span class="time">2023-12-04 10:20:12</span></p>
								</div>
								<div style="clear: both; overflow: hidden;">
									<p class="xcn_file_btn">
										<button class="btn06 mat32"><img src="<c:url value="/img/subBtn_eye.png"/>" alt="미리보기">미리보기</button><button class="btn06"><img src="<c:url value="/img/subBtn_file_open.png"/>" alt="열기">열기
									</button><button class="btn06"><img src="<c:url value="/img/subBtn_folder_open.png"/>" alt="폴더">폴더열기</button><button class="btn06"><img src="<c:url value="/img/subBtn_share.png"/>" alt="전달">전달
									</button><button class="btn02"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제">삭제</button><button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="저장">저장
									</button><!--<button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="다른이름">다름이름으로 저장</button>-->
									</p>
								</div>
							</li>
							<li class="person">
								<div class="left">
									<p>
										<span class="file_flag_reception"><img src="<c:url value="/img/ico_w_chatshare_fill.png"/>" alt="외부" height="12px">외부</span>
										<span class="chatid">2024_사업계획_v1.0_엑스큐어넷 4층 연구소_데이터응용팀.pdf</span>
									</p>
									<p><span class="name">새절사업장</span> <span class="bar"></span>
										<span class="name">데이터 코어팀</span> <span class="bar"></span>
										<span class="name">수석</span> <span class="bar"></span>
										<span class="name">홍길동</span><span class="bar"></span>
										<span class="name">233KB</span>
									</p>
								</div>
								<div class="right">
									<p><span class="logo"><img src="/venus/img/icon/ico_sns_IGPS.png">OneDrive</span></p>
									<p><span class="time">2023-12-04 10:20:12</span></p>
								</div>
								<div style="clear: both; overflow: hidden;">
									<p class="xcn_file_btn">
										<button class="btn06 mat32"><img src="<c:url value="/img/subBtn_eye.png"/>" alt="미리보기">미리보기</button><button class="btn06"><img src="<c:url value="/img/subBtn_file_open.png"/>" alt="열기">열기
									</button><button class="btn06"><img src="<c:url value="/img/subBtn_folder_open.png"/>" alt="폴더">폴더열기</button><button class="btn06"><img src="<c:url value="/img/subBtn_share.png"/>" alt="전달">전달
									</button><button class="btn02"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제">삭제</button><button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="저장">저장
									</button><!--<button class="btn01"><img src="<c:url value="/img/subBtn_save_b.png"/>" alt="다른이름">다름이름으로 저장</button>-->
									</p>
								</div>
							</li>
						</ul>
					</div>
				</div>

				<!-- pagination -->
				<div class="pl20 pr20">
					<div class="pageArea bornone" id="groupPage">
						<div class="total fb600">

						</div>
					</div>
					<s:message code="common.msg.finish_query"/> : <span id="groupResultCnt" class="red fb600">0</span>
				</div>
				<!-- //pagination -->
			</div>

		</div>

		<!-- 대화방 끝!! -->
		<!-- 상세보기 -->
		<div class="fileGroupList">
			<div class="inner_message">

				<div class="messageBtn">
					<div class="btnform">
						<button class="btn01"><img src="<c:url value="/img/subBtn_arrow_left_12.png"/>" alt=""></button>
						<button class="btn01"><img src="<c:url value="/img/subBtn_arrow_right_12.png"/>" alt=""></button>
						<button class="btn05"><img src="<c:url value="/img/subBtn_save.png"/>" alt="저장">저장</button>
						<button class="btn05"><img src="<c:url value="/img/subBtn_mail.png"/>" alt="인쇄">인쇄</button>
						<button class="btn05"><img src="<c:url value="/img/subBtn_settings.png"/>" alt="추가기능">추가기능</button>
						<button class="btn05"><img src="<c:url value="/img/subBtn_link.png"/>" alt="새창">새창</button>
					</div>
					<div class="btnform txt_right">
						<button class="btn05"><img src="<c:url value="/img/subBtn_notification.png"/>" alt="메시지보관">메시지보관</button>
						<select id="" name="">
							<option value="">내보내기</option>
							<option value="">옵션2</option>
							<option value="">옵션3</option>
						</select>
					</div>
				</div>
				<!-- 외부 -->
				<div class="messageCon">
					<div class="top redBg">
						<h4 class="ma_none">
							<span class="file_flag_reception"><img src="<c:url value="/img/ico_w_chatshare_fill.png"/>" alt="외부" height="12px">외부</span>
							2024_사업계획_v1.0_엑스큐어넷 4층 연구소_데이터응용팀.pdf
						</h4>
					</div>
					<div class="conBox">

						<div class="borbottom_dashed pb16 ">
							<p>
								<span class="name">새절사업장</span> <span class="xcn_bar"></span>
								<span class="name">데이터 코어팀</span> <span class="xcn_bar"></span>
								<span class="name">수석</span> <span class="xcn_bar"></span>
								<span class="name">홍길동</span><span class="xcn_bar"></span>
								<span class="name">233KB</span>
							</p>
							<p class="rightBox">
								<span >2023-12-04 10:00:20</span>
							</p>
						</div>
						<div class="pt16">
							내용내용<br/>
							내용 들이갑니다.
						</div>
						<table class="subTable mat8">
							<colgroup>
								<col width="*">
								<col width="*">
								<col width="10%">
							</colgroup>
							<tr>
								<th colspan="3"> 2023.12.04</th>
							</tr>
							<tr>
								<td>ID</td>
								<td class="txt_left">일단 주석처리</td>
								<td class="borleft_none">10:12:32</td>
							</tr>
							<tr>
								<td>ID</td>
								<td class="txt_left">알겠습니다</td>
								<td class="borleft_none">10:12:32</td>
							</tr>
							<tr>
								<td>ID</td>
								<td class="txt_left">일단 주석처리</td>
								<td class="borleft_none">10:12:32</td>
							</tr>
							<tr class="tableActive">
								<td>ID</td>
								<td class="txt_left">알겠습니다</td>
								<td class="borleft_none">10:12:32</td>
							</tr>
						</table>
					</div>

				</div>

				<!-- 내부-->
				<div class="messageCon">
					<div class="top grayBg03">
						<h4 class="ma_none">
							내부 일 때 - 2024_사업계획_v1.0_엑스큐어넷 4층 연구소_데이터응용팀.pdf
						</h4>

					</div>
					<div class="conBox">

						<div class="borbottom_dashed pb16">
							<p>
								<span class="name">새절사업장</span> <span class="xcn_bar"></span>
								<span class="name">데이터 코어팀</span> <span class="xcn_bar"></span>
								<span class="name">수석</span> <span class="xcn_bar"></span>
								<span class="name">홍길동</span><span class="xcn_bar"></span>
								<span class="name">233KB</span>
							</p>
							<p class="rightBox">
								<span >2023-12-04 10:00:20</span>
							</p>
						</div>
						<div class="pt16">
							내용내용<br/>
							내용 들이갑니다.
						</div>
						<table class="subTable mat8">
							<colgroup>
								<col width="*">
								<col width="*">
								<col width="10%">
							</colgroup>
							<tr>
								<th colspan="3"> 2023.12.04</th>
							</tr>
							<tr>
								<td>ID</td>
								<td class="txt_left">일단 주석처리</td>
								<td class="borleft_none">10:12:32</td>
							</tr>
							<tr>
								<td>ID</td>
								<td class="txt_left">알겠습니다</td>
								<td class="borleft_none">10:12:32</td>
							</tr>
							<tr>
								<td>ID</td>
								<td class="txt_left">일단 주석처리</td>
								<td class="borleft_none">10:12:32</td>
							</tr>
							<tr class="tableActive">
								<td>ID</td>
								<td class="txt_left">알겠습니다</td>
								<td class="borleft_none">10:12:32</td>
							</tr>
						</table>
					</div>

				</div>
			</div>

		</div>
		<!-- //상세보기 -->

	</div>
</div>


<div style="width: 0%;height: 0px;">
	<script type="text/javascript">
		LoadInnoFD(1, 1);
	</script>
</div>
<iframe id="AttachDown" src="about:blank;" height="0" width="0" style="display: none;"></iframe>
<!-- Back to top -->
<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>

<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"></input>
	<input type="hidden" name="oldConm" id="oldConm"></input>
</form>
