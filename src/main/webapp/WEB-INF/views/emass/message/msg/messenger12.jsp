<%@ page import="com.xcurenet.common.util.Common" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%
	String adminType = Common.getAdminType(session);
	String firstAdminYn = Common.getFirstAdminYn(session);
%>

<script type="text/javascript" src="<c:url value="/js/messenger.js"/>"></script>
<!DOCTYPE html>
<html lang="ko">
<head>\
	<title>EMASS LT - <s:message code="DATA_MONITOR.MESSAGE_SERVICE"/></title>

	<style>
		.clusterize-scroll{
			overflow: auto;
			height:100%;
		}
		@keyframes ddd{
			from{left:-5px} to{left:5px}
		}
		.lastReadLi .timeline-panel .list-group-item {
			background-color:#D3DBDC !important;
		}
		.lastReadLi .timeline-title, .lastReadLi .timeline-body {

		}
		.lastReadLi .panel_left:after {
			position: absolute !important;
			left: -14px !important;
			border-top: 7px solid transparent !important;
			border-left: 0 solid #D3DBDC !important;
			border-right: 14px solid #D3DBDC !important;
			border-bottom: 7px solid transparent !important;
		}

		.lastReadLi .panel_left:before {
			position: absolute !important;
			left: -13px !important;
			border-top: 8px solid transparent !important;
			border-left: 0px solid #D3DBDC !important;
			border-right: 13px solid #D3DBDC !important;
			border-bottom: 8px solid transparent !important;
		}
		.lastReadLi .panel_right:after {
			position: absolute !important;
			right: -14px !important;
			border-top: 7px solid transparent !important;
			border-left: 14px solid #D3DBDC !important;
			border-right: 0 solid #D3DBDC !important;
			border-bottom: 7px solid transparent !important;
		}

		.lastReadLi .panel_right:before {
			position: absolute !important;
			right: -13px !important;
			border-top: 8px solid transparent !important;
			border-left: 13px solid #D3DBDC !important;
			border-right: 0 solid #D3DBDC !important;
			border-bottom: 8px solid transparent !important;
		}
		:first-child.list-group-item, :last-child.list-group-item {
			border-radius: 0px !important;
		}

		#rightDiv {

		}

		.list-group-item.active, .list-group-item.active:focus, .list-group-item.active:hover {
			z-index: 2;
			color: #fff;
			background-color: #90abc3;
			opacity: .9;
			border-color: #ccc;
		}

		.list-group-item.active .list-group-item-text, .list-group-item.active:focus .list-group-item-text, .list-group-item.active:hover .list-group-item-text {
			color: #fff;
		}

		#groupPage a:hover{
			text-decoration: none;
		}
		#groupPage a:focus{
			text-decoration: none;
		}

		a.list-group-item, button.list-group-item{
			font-weight: normal;
			color: #999;
		}

		.list-group-item-text i {
			font-size: 16px;
		}

		#tab .active.btn, #tab .btn:active {
			background-color: #253f56;
			color: #fff;
			border-bottom-left-radius: 0px;
			border-bottom-right-radius: 0px;;
		}

		.bootstrap-datetimepicker-widget table td.disabled, .bootstrap-datetimepicker-widget table td.disabled:hover{
			color:#E4E4E4;
		}

		.cursor-text{
			cursor:text;
		}
		.cursor-pointer{
			cursor:pointer;
		}

		.maxwidth50{
			width:calc(100% - 50px);
		}

		.cursor-default{
			cursor:default;
		}
		.buttonArea{
			padding:7px;
		}
		.buttonArea:hover{
			background-color:#d4d4d4;
			border:1px solid ##adadad;
		}
		.buttonArea:active{
			color:#333;
			background-color:#d4d4d4;
			border:1px solid #adadad;
			-webkit-box-shadow:inset 0 3px 5px rgba(0, 0, 0, .125);
			box-shadow:inset 0 3px 5px rgba(0, 0, 0, .125);
		}
		.input-group-addon:hover{
			background-color:#d4d4d4;
		}
		.clicked{
			background-color:#d4d4d4 !important;
			-webkit-box-shadow:inset 0 3px 5px rgba(0, 0, 0, .125);
			box-shadow:inset 0 3px 5px rgba(0, 0, 0, .125);
		}
		.file_link, .file_link > pre, .file_link > pre > code {
			text-decoration: underline;
			color: blue;
		}
		.file_link > pre {
			display: inline-block;
		}

		.bootstrap-select [data-id=serviceTypeSelect],
		.bootstrap-select [data-id=serviceTypeSelect] {
			width: 180px;
		}
		.bootstrap-select [data-id=deptSelect]
		{
			width: 150px;
		}
		#selectedCodeTitle {
			display:none;
			border: 1px solid #458A45;
			position: absolute;
			background-color: #5CB85C;
			color: #fff;
			z-index: 999;
			font-size: 15px;
			padding: 3px;
			max-width: 400px;
			word-break: break-all;
		}
		.tag {font-size: 100%; border: 1px solid #ccc; padding-top: 5px !important; }
		.tag-pill{border-radius: 0px !important;}
		.btn-primary {
			color: #fff !important;
			background-color: #253f56 !important;
			border-color: #253f56 !important;
		}

		.loading_div_grid{
			background-color: transparent !important;
		}
		.btnCustomPosition{
			position:inherit;
			top:125px;
			right:30px;
			z-index:999;
		}
		.input-group .show-tick{
			display:inline-block;
		}
		#group_list .ignoreHtmlPre {
			width: 72%;
		}
		.messenger_prev{
			position: relative;
			width: 30px;
			background-color: rgba(0, 94, 193, 0.32);
			text-align: center;
			margin-left: 50.5%;
			z-index: 100000;
			-moz-border-radius: 50px;
			-webkit-border-radius: 50px;
			border-radius: 50px;
			height: 30px;
			line-height: 30px;
			font-size: 10px;
			font-weight: bold;
			cursor: pointer;
			color:#fff;
			display:none;
		}
		.messenger_next{
			position: relative;
			width: 30px;
			background-color: rgba(0, 94, 193, 0.32);
			text-align: center;
			margin-left: 50.5%;
			z-index: 100000;
			-moz-border-radius: 50px;
			-webkit-border-radius: 50px;
			border-radius: 50px;
			height: 30px;
			line-height: 30px;
			font-size: 10px;
			font-weight: bold;
			cursor: pointer;
			color:#fff;
			display:none;
		}
	</style>
	<script>
		var messengerListCnt = 0;
		var nodataMsg = '<s:message code="common.msg.nodata"/>';
		var chatting = '<s:message code="eikon.msg.chat"/>';
		var endChat = '<s:message code="eikon.msg.finish"/>';
		var unreadTitle = '<s:message code="eikon.msg.unreadTitle"/>';
		var condition = {
			messageInputFilter:'<s:message code="condition.message.input.filter"/>',
			messageInputPeriod:'<s:message code="condition.message.input.period"/>',
			consentMsgTimecheck:'<s:message code="consent.msg.timecheck"/>',
			messageNumbercheck:'<s:message code="condition.message.numbercheck"/>',
			messageFolderFilter:'<s:message code="condition.message.folder.filter"/>',
			messageSelectFolder:'<s:message code="condition.message.select.folder"/>',
			msgSaved:'<s:message code="common.msg.saved"/>',
			selectInterest:'<s:message code="condition.select.interest"/>',
			interestUserAll:'<s:message code="interest.user.all"/>',
			commonMsgAll:'<s:message code="common.msg.all"/>',
			serviceAll:'<s:message code="condition.service.all"/>',
			messengerAll:'<s:message code="condition.messenger.all"/>',
			orgBusiAll:'<s:message code="common.org.busi.all"/>',
			orgDeptAll:'<s:message code="common.org.dept.all"/>',
			msgSelect_all:'<s:message code="common.msg.select_all"/>',
			msgUnselect_all:'<s:message code="common.msg.unselect_all"/>',
			msgNoresult:'<s:message code="common.msg.noresult"/>',
			msgConnectError:'<s:message code="common.msg.connect.error"/>',
			messageSelectDashboard:'<s:message code="condition.message.select.dashboard"/>',
			msgConfirmSave:'<s:message code="common.msg.confirm.save"/>',
			searchService:'<s:message code="condition.search.service"/>',
			authAlert:'<s:message code="admin.auth.alert"/>',
			noselect:'<s:message code="common.msg.noselect"/>'

		};
		$(document).ready(function(){
			$(window).resize(function() {
				if($(window).width() < 1700){
					$('#searchResultBtnArea').addClass('btnCustomPosition');
				}else{
					$('#searchResultBtnArea').removeClass('btnCustomPosition');
				}
			});

			$('#searchBtn').click(function(){
				if( messengerListCnt == 0 ) {
					ui.alertMsg('<s:message code="eikon.noList"/>');
					return;
				}
				var startDt = $('#startDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
				var endDt = $('#endDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
				if( startDt == ''){
					ui.alertMsg('<s:message code="message.message.startdt.input"/>');
					return;
				}
				if( endDt == ''){
					ui.alertMsg('<s:message code="message.message.enddt.input"/>');
					return;
				}
				if(startDt > endDt) {
					ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
					return;
				}
				if(getDayInterval(startDt, endDt) > 31) {
					ui.alertMsg('<s:message code="eikon.msg.select.date"/>');
					return;
				}

				eikon.getMessengerList(1);
			});
			$("#searchStrInput").keypress(function(e){if( e.keyCode == 13) $('#searchBtn').click();}); //통합 검색 엔터키

			$('#searchMsgBtn').click(function(){
				if($('#searchMsgStrInput').val() == "") $('#searchMsgQueryBtn').click();
				else eikon.findMessageList(0);
				//eikon.getMessengerDetailList($('#xrootmtr').text(),$('#msgid').text(), $('#srcip').text());
			});
			$('#searchMsgQueryBtn').click(function(){
				var selectedUsrId = $('#selectUserInfo').attr('data-usrid');
				getDetailData(selectedUsrId);
			});
			$("#searchMsgStrInput").keypress(function(e){
				if( e.keyCode == 13) {
					if($('#searchMsgStrInput').val() == "") $('#searchMsgQueryBtn').click();
					else $('#searchMsgBtn').click();
				}
			});

			$('#searchMsgUp').click(function(){
				eikon.findMessageList(--searchOffset);
// 		checkList(--searchOffset);
			});
			$('#searchMsgDn').click(function(){
// 		checkList(++searchOffset);
				eikon.findMessageList(++searchOffset);
			});
			$('#listCntArea').click(function(){
				//if( $('#messageTotalCnt').html() == 0 || $('#messageTotalCnt').html() == '') return;
				openSelectDiv();
			});
			$('#userCntArea').click(function(){
				if( $('#selectUserInfo').html() == '-') return;
				openSelectUserDiv();
			});

			$('#dept').click(function(){
				var code = $(this).attr('id');
				openCodeWindow(code, $('#'+code+'Val').val(), $('#'+code+'Str').val());
			});

			$('.txt_down').click(function(){
				downloadList('txt');
				hideSelect();
			});
			$('.excel_down').click(function(){
				downloadList('xlsx');
				hideSelect();
			});
			$('.html_down').click(function(){
				downloadList('html');
				hideSelect();
			});
			$('.excel_file_down').click(function(){
				var xrootmtr = $('#xrootmtr').text();
				var srcip = $('#srcip').text();
				var usr_id = $('#usr_id').text();
				var startDt = $('#startSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
				var endDt = $('#endSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
				var searchStr = '';
				if( xrootmtr == '') return;
				eikon.getMessengerGroupAllExport('<c:url value="/getMessengerGroupAllExport.xcn"/>?xRootMtr='+xrootmtr+'&srcip='+srcip+'&usr_id='+usr_id+'&startDt='+startDt+'&endDt='+endDt+'&searchStr='+searchStr);
				hideSelect();
			});

			$(document).on('mouseover', '.codeSelectedBtn', function(e){
				$('#selectedCodeTitle').show();
				$('#selectedCodeTitle').css('left', (e.pageX + 5)+'px');
				$('#selectedCodeTitle').css('top', (e.pageY - 120)+'px');

				var str = $(this).parent().find('.selectedTitle').val();
				if( str != undefined ) str = str.replaceAll('\\|', ',');
				$('#selectedCodeTitle').html(str);
			});

			$(document).on('mousemove', '.codeSelectedBtn', function(e){
				$('#selectedCodeTitle').css('left', (e.pageX + 5)+'px');
				$('#selectedCodeTitle').css('top', (e.pageY - 120)+'px');

				var str = $(this).parent().find('.selectedTitle').val();
				if( str != undefined ) str = str.replaceAll('\\|', ',');
				$('#selectedCodeTitle').html(str);
			});

			$(document).on('mouseout', '.codeSelectedBtn', function(e){
				$('#selectedCodeTitle').hide();
			});

			$(document).on('click', '.codeSelectedBtn', function(e){
				$('#deptVal, #deptStr').val('');
				$('#deptSelectedArea').hide();
			});

			$(document).on('click', '#timeline_list div.list-group-item', function(e){
				var xrootmtr = $('#xrootmtr').text();
				var srcip = $('#srcip').text();
				var usr_id = $('#usr_id').text();
				var id = $(this).parent().parent().attr('id');
				updateEmassMessengerAdminXrootMtr(xrootmtr, id, srcip, usr_id);

				moveTargetHeight(id, false);
			});

			$(document).on('click', '#group_list a', function(){
				if( (isConsent() && $('#consentNo').val() == '') || $(this).attr('userid') == ''){
					return;
				}

				//if($(this).hasClass('active')) return;
				$('#group_list a').each(function(){
					$(this).removeClass('active');
				});

				$(this).addClass('active');
				$('#xrootmtr').text($(this).attr('xrootmtr'));

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
				eikon.getMessengerDetailList($(this).attr('xrootmtr'), $(this).attr('msgid'), $(this).attr('srcip'), $(this).attr('usrid'));
			});

			$( 'input[name="searchType"]:radio' ).change(function(){
				eikon.getMessengerList(1);
			});

			$('#groupFileCnt').click(function(){
				fileInfoViewer( $('#xrootmtr').text(), $('#srcip').text(), $('#usr_id').text() );
			});

			$('#groupParticipant').click(function(){
				participantInfoViewer( $('#xrootmtr').text(), $('#usr_id').text() );
			});

			$(document).on('click','.file_link',function(){
				var msgId = $(this).attr('msgid');
				var attachHash = $(this).attr('attachhash');
				var attachName = $(this).text();

				var attachUrl = '<c:url value="/getEmassAttachInfo4DownHash.xcn"/>?msgIds='+msgId+'&attachHash='+attachHash;

				if( attachHash == ''){
					alert('<s:message code="message.message.notfound.attach"/>');
					return;
				}
				try {
					AttachDown.location.href = attachUrl;
				} catch (e) {
					AttachDown.src = attachUrl;
				}
			});

			$(document).on('click','#group_list a',function(){
				var name = $(this).attr('data-name');
				var srcip = $(this).attr('data-srcip');
				var usr_id = $(this).attr('data-usrid');
				var xrootmtr = $('#xrootmtr').text();
				var msgid = $('#msgid').text();
				$('#selectUserInfo').attr('data-srcip', srcip);
				$('#selectUserInfo').attr('data-name', name);
				$('#selectUserInfo').attr('data-usrid', usr_id);

				$('#selectUserInfo').html($(this).text());
				$('#srcip').text(srcip);
				$('#usr_id').text(usr_id);
				eikon.getMessengerGroupDetail(xrootmtr, msgid, srcip, usr_id);
				hideUserSelect();
			});

			initCondition();
			eikon.init();
// 	$('#searchBtn').click();

		});

		function openCodeWindow(id, oldCode, oldConm){
			$('#oldCode').val(oldCode);
			$('#oldConm').val(oldConm);

			var url    = '<c:url value="/commons/selectCode.do?codeType='+id+'"/>';
			var pop = fnOpenWindow('', 'selectCodeWinPopup', 1200, 700, 'resize');

			$('#codeParam').attr('target','selectCodeWinPopup');
			$('#codeParam').attr('action', url);
			$('#codeParam').attr('method','post');
			$('#codeParam').submit();
		}

		function openSelectUserDiv(){
			var status = $('#userCntArea').hasClass('clicked');
			if( status){
				hideUserSelect();
			}
			else{
				showUserSelect();
			}
		}
		function hideUserSelect() {
			if ($('#selectUser_menu')){
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

		function openSelectDiv(){
			var status = $('#listCntArea').hasClass('clicked');
			if( status){
				hideSelect();
			}
			else{
				showSelect();
			}
		}
		function hideSelect() {
			if ($('#export_menu')){
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


		function downloadList(type){
			var xrootmtr = $('#xrootmtr').text();
			var srcip = $('#srcip').text();
			var usr_id = $('#usr_id').text();
			if( xrootmtr == '') return;
			var startDt = $('#startSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
			var endDt = $('#endSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
			var searchStr = '';

			eikon.getMessengerGroupTextExport('<c:url value="/getMessengerGroupTextExport.xcn"/>?xRootMtr='+xrootmtr+'&srcip='+srcip+'&usr_id='+usr_id+'&startDt='+startDt+'&endDt='+endDt+'&searchStr='+searchStr+'&type='+type+'&groupField=sender_str', xrootmtr);
		}

		function searchConsentNo(){
			var url    = '<c:url value="/ems/selectConsent.do"/>';
			return fnOpenWindow(url, 'selectConsentWinPopup', 830, 700, 'resize');
		}
		function selectedConsent( obj ){
			if( obj == ''){
				$('#consentNo').val('');
				$('#consentName').text('');
				/* $('#consentIp').val('');
                $('#consentEmail').val(''); */
				$('#consentUserId').val('');
				$('#consentBtn').removeClass('active');
			}else{
				$('#consentNo').val(obj.no);
				$('#consentName').text(obj.name + "["+obj.userId+", "+(obj.deptNm == '' ? '<s:message code="consent.select.consentDept"/>' : obj.deptNm)+"]");
				/* $('#consentIp').val(obj.userIp);
                $('#consentEmail').val(obj.userEmail); */
				$('#consentUserId').val(obj.userId);
				$('#consentBtn').addClass('active');
			}
		}

		function initCondition(){
			getMessengerList();
			getCodeList('busi');
			getCodeList('dept');

			var dateObj = new Date();
			$('#startdatepicker').datetimepicker({
				format: 'YYYY-MM-DD HH:mm:ss',
				locale: 'ko',
				sideBySide: true,
				defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate() - 1 ) )
			}).on("dp.change", function (e) {
				if( easyDateStartFlag ){
					easyDateStartFlag = false;
					return;
				}else{
					$('#easyDate').val('');
				}
			});
			$('#enddatepicker').datetimepicker({
				format: 'YYYY-MM-DD HH:mm:ss',
				locale: 'ko',
				sideBySide: true,
				defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
			}).on("dp.change", function (e) {
				if( easyDateEndFlag ){
					easyDateEndFlag = false;
					return;
				}else{
					$('#easyDate').val('');
				}
			});

			$('#startsubdatepicker').datetimepicker({
				format: 'YYYY-MM-DD HH:mm:ss',
				locale: 'ko',
				widgetParent : '.boxArea',
				sideBySide: true,
				defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-1 ) )
			}).on("dp.change", function (e) {
			}).on('dp.show', function(){
				var datepicker = $("body").find('.bootstrap-datetimepicker-widget:last');
				if (datepicker.hasClass('bottom')) {
					var top = $(this).offset().top + $(this).outerHeight();
					var left = $(this).offset().left;
					datepicker.css({
						'top': (top-80) + 'px',
						'bottom': 'auto',
						'left': left+'px'
					});
				}
			});
			$('#endsubdatepicker').datetimepicker({
				format: 'YYYY-MM-DD HH:mm:ss',
				locale: 'ko',
				widgetParent : '.boxArea',
				sideBySide: true,
				defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
			}).on("dp.change", function (e) {
			}).on('dp.show', function(){
				var datepicker = $("body").find('.bootstrap-datetimepicker-widget:last');
				if (datepicker.hasClass('bottom')) {
					var top = $(this).offset().top + $(this).outerHeight();
					var left = $(this).offset().left;
					var rightDivWidth = $('#rightDiv').width();
					if(rightDivWidth < 640) left = left - 280;
					datepicker.css({
						'top': (top-80) + 'px',
						'bottom': 'auto',
						'left': (left)+'px'
					});
				}
			});
			$('#easyDate').change(function(){
				changeDate($(this).val());
			});
			$('#timedatepicker').datetimepicker({
				format: 'YYYY-MM-DD',
				locale: 'ko',
				defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
			}).on("dp.change", function (e) {
				var date = $(this).data("DateTimePicker").date().format('YYYY-MM-DD');
				detailDateFocus(date);

				$('#searchMsgStrInput').val('');
				$('#searchResult').html('');
				$('#searchResultArea').hide();
				$('#searchResultBtnArea').hide();
			});

			$('#serviceTypeSelect').selectpicker({
				container:'body',
				size: 15,
				width:'180px',
				noneSelectedText:condition.serviceAll,
				noneResultsText:condition.msgNoresult+' ',
				selectAllText:condition.msgSelect_all,
				deselectAllText:condition.msgUnselect_all,
				liveSearchPlaceholder:condition.searchService
			});

			$('#busiSelect').selectpicker({
				container:'body',
				size: 15,
				width:'180px',
				searchLabel:true,
				noneSelectedText:'<s:message code="common.org.busi.all"/>',
				noneResultsText:'<s:message code="common.msg.noresult"/>'+' ',
				selectAllText:'<s:message code="common.msg.select_all"/>',
				deselectAllText:'<s:message code="common.msg.unselect_all"/>'
			});
			/* $('#deptSelect').selectpicker({
                container:'body',
                size: 15,
                width:'222px',
                searchLabel:true,
                noneSelectedText:'<s:message code="common.org.dept.all"/>',
		noneResultsText:'<s:message code="common.msg.noresult"/>'+' ',
		selectAllText:'<s:message code="common.msg.select_all"/>',
		deselectAllText:'<s:message code="common.msg.unselect_all"/>'
	}); */

			$('#searchField').selectpicker({
				container:'body',
				width:'100px',
				noneSelectedText:'<s:message code="common.msg.all"/>'
			});

			$( 'input[name="attachYn"]:radio' ).change(function(){
				if($(this).val() == '') $("#searchField option:eq(1)").prop('disabled', false);
				else $("#searchField option:eq(1)").prop('disabled', true);

				$('#searchField').selectpicker('refresh');
			});
		}

		function getCodeList( codeType ){
			ui.get({
				url 		: 'getCodeList.xcn',
				codeType	: codeType,
				success 	: function(data, total) {
					$('#'+codeType+'Select').html(getSelectOption( data ));
					$('#'+codeType+'Select').selectpicker('refresh');
					$('#'+codeType+'SelectPop').html(getSelectOption( data ));
					$('#'+codeType+'SelectPop').selectpicker('refresh');
				},
				error 		: function(status, message) {
					ui.alertMsg('error:' + status);
				},
				complete 	: function() {
					searchFlag=false;
				}
			});
		}
		function getSelectOption( data ){
			var str = '';
			for (var i = 0; i < data.length; i++) {
				str += '<option value="'+data[i].code+'">'+data[i].codeName+'</option>';
			}
			return str;
		}



		function getCondition( ){
			var filterVal = {};

			if( isConsent()){
				filterVal.consentNo = $('#consentNo').val();
				filterVal.consentName = $('#consentName').text();
				//filterVal.consentIp = $('#consentIp').val();
				//filterVal.consentEmail = $('#consentEmail').val();
				filterVal.consentUserId = $('#consentUserId').val();
			}

			var conArray = [];
			conArray.push( createCondition( ) );
			filterVal.conditions = conArray;

			//console.log(JSON.stringify(filterVal))
			return filterVal;
		}

		function createCondition( ){
			var allSelect = new Array();
			var condition = {};
			if( $('#serviceTypeSelect').selectpicker('val') == null ) {
				$('#serviceTypeSelect option').each(function(){
					if( $(this).val() != '' && $(this).val() != null ) allSelect.push( $(this).val() );
				});
				condition.serviceType = arrayToString(allSelect);
			} else {
				condition.serviceType = arrayToString($('#serviceTypeSelect').selectpicker('val'));
			}
			condition.searchStr = $('#searchStrInput').val();
			condition.senders = $('#senders').val();
			condition.attachYn = $('input:radio[name=attachYn]:input:checked').val();
			condition.busi = arrayToString($('#busiSelect').selectpicker('val'));

			if(condition.busi != '') condition.busiStr = $('#busiSelect').parent().find('.filter-option').text();
			else condition.busiStr = '';

			var dv = $('#deptVal').val().split('|');
			condition.dept = dv.join(',');
			if(condition.dept != '') condition.deptStr = $('#deptStr').val();
			else condition.deptStr = '';
			/* condition.dept = arrayToString($('#deptSelect').selectpicker('val'));
            if(condition.dept != '') condition.deptStr = $('#deptSelect').parent().find('.filter-option').text();
            else condition.deptStr = ''; */

			condition.period = 1;
			condition.startDt = $('#startdatepicker').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
			condition.endDt = $('#enddatepicker').data("DateTimePicker").date().format('YYYYMMDDHHmmss');

			return condition;
		}

		function arrayToString( array ){
			if( array == null || array == undefined ) return "";
			else{
				return array.toString();
			}
		}
		function stringToArray( string ){
			if( string == null || string == undefined || string == '' ) return '';
			else if( typeof string !='string') return string;
			else{
				return string.split(',');
			}
		}

		function fileInfoViewer( xrootmtr, srcip, usr_id ){
			var startDt = $('#startSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
			var endDt = $('#endSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
			var searchStr = '';

			var url    = '<c:url value="/ems/participantFileInfoPop.do?xrootmtr='+xrootmtr+'&srcip='+srcip+'&usr_id='+usr_id+'&startDt='+startDt+'&endDt='+endDt+'&searchStr='+encodeURI(searchStr)+'"/>';
			var pop = fnOpenWindow(url, 'fileInfoPop', 1000, 400, 'resize');
		}

		function participantInfoViewer( xrootmtr, usr_id ){
			var srcip = $('#srcip').text();
			var startDt = $('#startSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
			var endDt = $('#endSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
			var searchStr = '';

			var url    = '<c:url value="/ems/participantInfoPop.do?xrootmtr='+xrootmtr+'&srcip='+srcip+'&usr_id='+usr_id+'&startDt='+startDt+'&endDt='+endDt+'&searchStr='+searchStr+'"/>';
			var pop = fnOpenWindow(url, 'participant', 1015, 450, 'resize');
		}

		function getParticipantFileList(){
			var xrootmtr = $('#xrootmtr').text();
			ui.get({
				url : 'getMessengerGroupAttachList.xcn',
				xRootMtr : xrootmtr,
				success : function(data, total) {
					alert( JSON.stringify( data ) );
					//getFileList(data);
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {

				}
			});
		}

		function getMessengerList(){
			ui.get({
				url : 'getMessengerList.xcn',
				asyncFlag : false,
				success : function(data, total) {
					messengerListCnt = data.length;
					if( data.length > 0 ){
						$('#serviceTypeSelect').html( getSelectOptionMessenger( data ) );
					}
				},
				error : function(status, message) {
					ui.alertMsg('error:' + status);
				},
				complete : function() {
					searchFlag=false;
				}
			});
		}

		function getSelectOptionMessenger( data ){
			//var str = '<option value="">- <s:message code="eikon.msg.svcType"/> -</option>';
			var str = '';
			for (var i = 0; i < data.length; i++) {
				str += '<option value="'+data[i].code+'">'+data[i].codeName+'</option>';
			}
			return str;
		}

		function getSelectedCodeData( codeType, data ) {
			var str = '';
			var val = '';
			for(var i=0; i<data.length; i++){
				str += data[i].codeName;
				val += data[i].code;
				if( codeType == 'regexp' ) {
					var arr = data[i].count.split('@');
					if( arr[0] == 'B' ) str += '(' + arr[1] + '<s:message code="selectCodeAll.items"/> ~ ' + arr[2] + '<s:message code="selectCodeAll.items"/>)';
					else if( arr[0] == 'L' ) str += '(' + arr[1] + '<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>)';
					else str += '(' + arr[1] + '<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.below"/>)';
					val += '%' + data[i].count;
				}

				if( i != data.length-1){
					str +=', ';
					val +='|';
				}
			}
			if( val != '' ){
				str = str.rtrim();
				val = val.trimAll();
			}

			$('#'+codeType+'Str').val(str);
			$('#'+codeType+'Val').val(val);

			if( $('#'+codeType+'Str').val() != '' ){
				$('#'+codeType+'SelectedArea').find('.btn').text(data.length);
				$('#'+codeType+'SelectedArea').show();
			}else{
				$('#'+codeType+'SelectedArea').find('.btn').text(0);
				$('#'+codeType+'SelectedArea').hide();
			}
		}

		function resetCode(codeType){
			if( codeType == 'deptByCo' )  $('#deptByCoStrSpan').html('');
			$('#'+codeType+'Val').val('');
			$('#'+codeType+'Str').val('');
			$('#'+codeType+'SelectedArea').hide();
		}
	</script>
</head>
<body class="mini-navbar">
<div class="container">
	<div class="boxArea" style="height:100%;">
		<div class="row" style="height: 100%;">
			<div class="col-sm-7" style="height: 100%; padding: 0px;">
				<div style="width: 100%;">
					<%if( consent && Common.isEquals(firstAdminYn, "N") && Common.isNotEquals(adminType, "C")){ %>
					<div class="form-group form-inline not-dashed" style="padding-left: 10px; width: 100%; margin-bottom: 3px;">
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="consentBtn" onclick="searchConsentNo();"><span class="glyphicon glyphicon-tags"></span>&nbsp;<s:message code="consent.select.consent"/></button>
						<input type="text" style="width:120px;height:28px;display:none;" readonly="readonly" id="consentNo">
						<input type="hidden" readonly="readonly" id="consentIp">
						<input type="hidden" readonly="readonly" id="consentEmail">
						<input type="hidden" readonly="readonly" id="consentUserId">
						<span id="consentName" style="font-weight: bold;"></span>
					</div>
					<%} %>
					<div class="form-group form-inline not-dashed" style="padding-left: 10px; width: 100%;">
						<div class="input-group">
							<select id="serviceTypeSelect" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true">
							</select>
						</div>
						<div class="input-group" style="width: calc(90% - 300px);">
							<input type="text" class="form-control input-xs" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStrInput" style="width: 100%;">
							<div class="input-group-btn" style="width:40px;">
								<button class="btn btn-md btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
							</div>
						</div>
						<div class="checkbox " style="width:150px;">
							<label><input type="checkbox" name="readYn" id="readYn"><span class="fa fa-check"></span><s:message code="eikon.msg.notRead"/></label>
						</div>
					</div>
				</div>
				<div style="background-color: #eee; margin-top: 5px;">
					<div  style="padding-left: 10px;">
						<div class="input-group select-xs" style="width:98px">
							<select name="searchArea" class="selectpicker" id="easyDate" data-style="btn-default btn-sm">
								<option value="" selected="selected"><s:message code="condition.select.period"/></option>
								<option value="1"><s:message code="condition.today"/></option>
								<option value="2"><s:message code="condition.yesterday"/></option>
								<option value="3"><s:message code="condition.week" arguments="1"/></option>
								<option value="6"><s:message code="condition.month" arguments="1"/></option>
							</select>
						</div>
						<div  style="padding-right:5px;">
							<div class="input-group">
								<div class="input-group date" id="startdatepicker">
									<input type="text" id="startDt" class="input-sm form-control border-radius-none" style="width: 150px;" />
									<span class="input-group-addon startDateBtn border-radius-none"> <span class="glyphicon glyphicon-calendar"></span>
										</span>
								</div>
							</div>
							~
							<div class="input-group">
								<div class="input-group date" id="enddatepicker">
									<input type="text" id="endDt" class="input-sm form-control border-radius-none" style="width: 150px;" />
									<span class="input-group-addon endDateBtn border-radius-none"><span class="glyphicon glyphicon-calendar"></span></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<input type="text" class="form-control input-sm"  placeholder="<s:message code="eikon.input.participation"/>" id="senders">
						</div>
						<div class="form-inline not-dashed" style="padding: 0px; margin: 0px;">
							<div class="btn-group filterBtn" data-toggle="buttons" style="float:left;padding-right:6px;">
								<label class="btn btn-sm btn-default active"><input type="radio" name="attachYn" id="attachAll" value="" checked>&nbsp; <s:message code="condition.isattached.all"/>&nbsp;&nbsp;</label>
								<label class="btn btn-sm btn-default"><input type="radio" name="attachYn" id="attachY" value="Y">&nbsp; <s:message code="eikon.attach.exist"/>&nbsp;&nbsp;</label>
							</div>
							<div class="input-group select-xs" style="width:180px;display:inline-block;">
								<select id="busiSelect" class="selectpicker" data-style="btn-default btn-sm" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
							</div>
							<%-- <div class="input-group select-xs" style="width:150px;display:inline-block;">
                                <select id="deptSelect" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
                            </div> --%>
							<div id="selectedCodeTitle"></div>
							<div class="btn-group" data-toggle="buttons" style="margin-top: 0px;">
								<button type="button" class="btn btn-sm btn-default" id="dept"><span class="glyphicon glyphicon-plus-sign"></span>&nbsp;<s:message code="common.org.choose.dept"/></button>
								<span id="deptSelectedArea" class="codeSelectedBtn">
										<button type="button" class="btn"  style="z-index: 2">0</button>
									</span>
								<input type="hidden" id="deptStr" class="selectedTitle">
								<input type="hidden" id="deptVal">
							</div>
						</div>
					</div>
				</div>
				<div style="height:10px;">&nbsp;</div>
				<div style="height:30px;padding-left:10px;border-bottom: 2px solid #A8B8BC;" id="tab">
					<div class="btn-group" data-toggle="buttons" style="float:left;width:300px;">
						<label class="btn btn-secondary btn-sm active">
							<input type="radio" name="searchType" value="G" checked><i class="fa fa-group fa-sm" style="font-size: 12px;"></i> <s:message code="eikon.msg.chats"/>
						</label>
						<label class="btn btn-secondary btn-sm">
							<input type="radio" name="searchType" value="GD"><i class="fa fa-envelope fa-sm" style="font-size: 12px;"></i> <s:message code="eikon.msg.chatContents"/>
						</label>
					</div>
					<div style="float:right;line-height:25px;padding-right:15px;padding-top:5px;color: #f25643; font-weight: bold; font-size: 13px;">
						<s:message code="common.msg.finish_query"/> : <span id="groupResultCnt">0</span>
					</div>
				</div>
				<div class="row" style="margin: 0px; margin-left: -1px; overflow: auto; height: calc(100% - 220px);">
					<div class="list-group" id="group_list" style="margin-bottom: 0px;">
						<a href="#" class="list-group-item list-group-item-action active" style="cursor:default;height:50px;">
							<p class="list-group-item-text" style="line-height:30px;">
								<i class="fa fa-envelope fa-sm"></i> <s:message code="eikon.msg.select.condition"/>
							</p>
						</a>
					</div>
				</div>
				<div style="height:30px;padding-left:32%; margin-top: 15px;" id="groupPage"></div>
			</div>
			<%-- <div class="col-sm-5" style="height: 100%; overflow: hidden; z-index: 999; background: url('<c:url value="/img/timeline_back.jpg"/>') no-repeat; background-size: 100% 100%;" id="rightDiv"> --%>
			<div class="col-sm-5" style="height: calc(100% - 10px); overflow: hidden; z-index: 998; background-color: #90abc3;" id="rightDiv">
				<div class="row" style="margin-top: 15px;">
					<div class="col-lg-12"><span style="font-size: 12px; background-color: #444; color: #fff; display: block; padding-left: 3px; padding-right: 3px;border-top-left-radius:4px;border-top-right-radius:4px;height:20px;padding-top:3px;">&nbsp;<s:message code="condition.xrootmtr"/> : <span id="xrootmtr"></span><span id="srcip" style="display:none;"></span><span id="usr_id" style="display:none;"></span><span id="msgid" style="display:none;"></span></span></div>
					<div class="col-lg-12">
						<div class="panel panel-default" style="text-align: center;margin-bottom:2px; background-color: #efefef;border-top-left-radius:0;border-top-right-radius:0;">
							<div class="panel-body" style="padding:0;">
								<div id="" style="height: 30px;">
									<div class="col-sm-2" style="height: 100%;width:90px;border-left: 1px solid #ccc;padding:7px;" title="" id="userButton">
										<span style="color: #777;padding-left:5px;display:block;float:left;"><i class="glyphicon glyphicon-user"></i> <s:message code="condition.user"/> : </span>
									</div>
									<div class="col-sm-4 buttonArea" style="height: 100%;width:calc(100% - 422px);cursor:pointer;" title="<s:message code="condition.user"/>" id="userCntArea">
										<div style="position: relative;display:block;padding-right: 10px;">
											<span style="color:#777;padding-left:10px;display:block;text-overflow:ellipsis;overflow: hidden;white-space: nowrap;text-align: left;" id="selectUserInfo" data-srcip="" data-name="" data-usrid="">-</span>
											<span class="bs-caret" style="position:absolute;right:5px;top:0;"><span class="caret"></span></span>
										</div>
									</div>
									<div class="col-sm-2 buttonArea" style="height: 100%;width:100px;border-left: 1px solid #ccc;cursor:pointer;" title="<s:message code="eikon.msg.participants.info"/>" id="groupParticipant">
										<span style="color: #777"><i class="fa fa-users"></i> <s:message code="eikon.msg.participants.info"/></span>
									</div>
									<div class="col-sm-2 buttonArea" style="height: 100%;width:100px;border-left: 1px solid #ccc; border-right: 1px solid #ccc;cursor:pointer; " title="<s:message code="consent.attach"/>" id="groupFileCnt">
										<span style="color: #777"><i class="glyphicon glyphicon-floppy-disk"></i> <s:message code="consent.attach"/></span>
									</div>
									<div class="col-sm-2 buttonArea" style="height: 100%;width:128px;cursor:pointer; " title="<s:message code="eikon.msg.export.all"/>" id="listCntArea">
										<span style="color: #777"><i class="glyphicon glyphicon-save"></i><s:message code="eikon.msg.export.all"/></span>
										<span class="bs-caret" style="position:absolute;right:10px;"><span class="caret"></span></span>
									</div>
								</div>
								<ul class="dropdown-menu" role="menu" style="min-width: 180px;position: absolute;left:100px;" id="selectUser_menu"></ul>
								<ul class="dropdown-menu dropdown-menu-right" role="menu" style="min-width: 180px;position: absolute;right:15px;" id="export_menu">
									<li class="attachExist" style="font-weight: bold;">&nbsp;- <s:message code="eikon.msg.chatContents"/></li>
									<li><a href="javascript:void(0);" class="excel_down"><span class="fa fa-file-excel-o" style="font-size: 16px"></span>&nbsp;<s:message code="common.msg.excel"/>(xlsx)</a></li>
									<li><a href="javascript:void(0);" class="txt_down"><span class="fa fa-file-text" style="font-size: 16px"></span>&nbsp;<s:message code="common.msg.text"/>(txt)</a></li>
									<li><a href="javascript:void(0);" class="html_down"><span class="fa fa-file-code-o" style="font-size: 16px"></span>&nbsp;<s:message code="eikon.msg.html"/>(html)</a></li>
									<li class="attachExist">&nbsp;</li>
									<li class="attachExist" style="font-weight: bold;">&nbsp;- <s:message code="eikon.msg.include.attach"/></li>
									<li class="attachExist"><a href="javascript:void(0);" class="excel_file_down"><span class="fa fa-file-excel-o" style="font-size: 16px"></span>&nbsp;<s:message code="common.msg.excel"/>(xlsx)+<s:message code="consent.attach"/></a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
				<div style="padding-bottom: 10px;">
					<div >
						<div class="input-group" style="padding-left:5px;">
							<div class="input-group date" id="startsubdatepicker">
								<input type="text" id="startSubDt" class="input-sm form-control border-radius-none" style="width: 130px;" />
								<span class="input-group-addon startDateBtn border-radius-none"> <span class="glyphicon glyphicon-calendar"></span>
									</span>
							</div>
						</div>
						~
						<div class="input-group">
							<div class="input-group date" id="endsubdatepicker">
								<input type="text" id="endSubDt" class="input-sm form-control border-radius-none" style="width: 130px;" />
								<span class="input-group-addon endDateBtn border-radius-none"><span class="glyphicon glyphicon-calendar"></span></span>
							</div>
						</div>
						<div class="input-group">
							<div class="input-group-btn">
								<button class="btn btn-sm btn-success" type="button" accesskey="M" id="searchMsgQueryBtn"><i class="glyphicon glyphicon-search"></i></button>
							</div>
						</div>
						<div class="input-group" style="padding-left:15px;">
							<input type="text" class="form-control input-sm" style="width: 170px; margin-left: 5px;" placeholder="<s:message code="condition.research"/>" id="searchMsgStrInput">
							<div class="input-group-btn">
								<button class="btn btn-sm btn-primary" type="button" accesskey="M" id="searchMsgBtn"><i class="fa fa-search-plus"></i></button>
							</div>
						</div>
						<div class="input-group date" id="timedatepicker" style="margin-left: 5px;display:none;">
							<input type="text" id="timeDt" class="input-sm form-control border-radius-none" style="display:none;"/>
							<span class="input-group-addon startDateBtn border-radius-none">
									<span class="glyphicon glyphicon-calendar"></span>
								</span>
						</div>
						<div class="input-group" id="searchResultArea" style="height:30px;line-height:30px;vertical-align: middle;padding-left:10px;display:none;">
							<div style="float:left;width:50px;text-align: center;">
								<span id="selectCnt" style="color:#fff;">0</span><span style="color:#fff;">/</span><span id="searchResult" style="width:50px;color:#fff;">0 &nbsp;</span>
							</div>
						</div>
						<div class="input-group btnCustomPosition" id="searchResultBtnArea" style="display:none;">
							<button class="btn btn-md btn-warning" type="button" accesskey="U" id="searchMsgUp" style="padding:6px"><i class="glyphicon glyphicon-chevron-up"></i></button>
							<button class="btn btn-md btn-warning" type="button" accesskey="D" id="searchMsgDn" style="padding:6px"><i class="glyphicon glyphicon-chevron-down"></i></button>
						</div>
					</div>
				</div>
				<div class="row" style="height: calc(100% - 160px);padding:0 3px 0 5px;">
					<div id="scrollArea" class="clusterize-scroll">
						<div class="messenger_prev" title="<s:message code='eikon.msg.show.prev'/>">+</div>
						<div id="timeline_list" style="padding-right:10px;">
							<div class="timeline-panel" style="padding-left:10px;">
								<div class="list-group-item cursor-text">
									<div class="timeline-body" style="text-align: center;">
										<s:message code="eikon.select.data"/>
									</div>
								</div>
							</div>
						</div>
						<div class="messenger_next" title="<s:message code='eikon.msg.show.next'/>">+</div>
					</div>
				</div>
				<div class="row" style="height: 30px;padding:0 3px 0 5px;">
					<div style="line-height:25px;padding-top:5px;color: #f25643; font-weight: bold; font-size: 13px;">
						<s:message code="eikon.msg.total.cnt"/> : <span id="groupSubResultCnt">0</span>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div style="width: 0%;height: 0px;">
	<script type="text/javascript">
		// LoadInnoFD( 1, 1 );
	</script>
</div>
<iframe id="AttachDown" src="about:blank;" height="0" width="0" style="display: none;" ></iframe>
<!-- Back to top -->
<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>

<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"></input>
	<input type="hidden" name="oldConm" id="oldConm"></input>
</form>
</body>
</html>