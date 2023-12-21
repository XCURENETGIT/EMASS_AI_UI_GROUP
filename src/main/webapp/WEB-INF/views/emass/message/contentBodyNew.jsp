<%@ page import="com.xcurenet.config.service.ConfigAdminService" %>
<%@ page import="com.xcurenet.config.service.ConfigAdminVO" %>
<%@ page import="com.xcurenet.audit.service.Operation" %>
<%@ page import="com.xcurenet.common.util.SpringContextUtil" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/messageCss.jsp"%>
<%@ include file="/WEB-INF/fragments/messageJs.jsp"%>
<%@ include file="/WEB-INF/fragments/messageScript.jsp"%>
<script type="text/javascript" src="<c:url value="/js/contentBodyNew.js"/>"></script>
<%
	ConfigAdminService configAdminService = SpringContextUtil.getBean(ConfigAdminService.class);
	Map<String, Object> param = Common.getParamMap(request);
	String msgid = Common.nvl(param.get("msgid"));
	String searchKey = Common.nvl(param.get("searchKey"));
	String bodySize = Common.nvl(param.get("bodySize"));
	boolean mailUseFlag = Config.getBoolean("mail.forward.flag");
	String op_attach_save = Operation.ATTACH_SAVE.getOperation();
	String op_body_save = Operation.BODY_SAVE.getOperation();
	String op_body_print = Operation.BODY_PRINT.getOperation();
	String infoFeedbackYn = Common.getInfoFeedbackYn(session);
	boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
	boolean infoHynixConf = Config.getBoolean("info.hynix.used");
	String adminId = Common.getAdminId(session);
	ConfigAdminVO configAdminVo = configAdminService.getConfAdmin("message.keyword.highlight", adminId);
	boolean keywordHighlight = true;
	if(Common.isNotEmpty(configAdminVo)) keywordHighlight = Common.isEquals(Common.nvl(configAdminVo.getVal()), "Y") ? true : false;
	boolean hostQuery = false;
	ConfigAdminVO hostQueryVO = configAdminService.getConfAdmin("host.query.use", adminId);
	if(Common.isNotEmpty(hostQueryVO)) hostQuery = Common.isEquals(Common.nvl(hostQueryVO.getVal()), "Y") ? true : false;

%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
	<title>EMASS LTH - <s:message code="OPERATION_MGMT.BODY_VIEW"/></title>

	<style type="text/css">
		html, body{
			min-width:600px !important;}
		.contents {
			min-width:600px !important;
		}
		.boxArea {
			height: 100% !important;
			min-height: 0px !important;
		}

		#buttonDiv {
			position: fixed;
			width: 100%;
			z-index: 9;
			background-color: #fff;
			padding-bottom: 5px;
			border-bottom: 1px solid #ccc;
			top: 0px;
			left: 0px;
			right: 0px;
			height: 30px;
			width: 100%;
			min-width: 600px;
		}

		.empty-dashboard-message{
			position: absolute;
			top: 35px;
			bottom: 100px;
			left: 0;
			right: 0;
			margin: auto;
			width: 70%;
			height:250px;
		}
		.empty-dashboard-message h2, .empty-dashboard-message p{
			text-align:center;
		}
		.empty-dashboard-message p{
			font-size: 14px;
		}
		.row {
			margin : 0px !important;
		}

		.userOutside{
			background-color:#ffcdcd;
		}
		#infoTable td div {
			word-break:break-all;
		}




		.cd-top {
			background-color: rgb(51, 122, 183) !important;
			bottom: 40px;
			color: rgb(255, 255, 255) !important;
			display: inline-block;
			font-size: 18px;
			line-height: 24px;
			position: fixed;
			opacity: 0;
			right: -158px;
			text-align: center;
			text-decoration: none !important;
			-webkit-transform: scale(2) translate(47px,-10px);
			-moz-transform: scale(2) translate(47px,-10px);
			-o-transform: scale(2) translate(47px,-10px);
			-ms-transform: scale(2) translate(47px,-10px);
			transform: scale(2) translate(47px,-10px);
			-webkit-transition: all 0.3s ease-in-out;
			-moz-transition: all 0.3s ease-in-out;
			-o-transition: all 0.3s ease-in-out;
			-ms-transition: all 0.3s ease-in-out;
			transition: all 0.3s ease-in-out;
			visibility: hidden;
			white-space: nowrap;
			width: auto;
		}
		.cd-top:hover{
			text-decoration: none !important;
			color: #333 !important;
		}


		.cd-top .fa {
			padding: 16px 16px;
			border-right: 1px solid  rgb(71, 142, 203);
		}
		.cd-top span:last-child {
			padding: 13px 14px;
		}

		.cd-is-visible {
			opacity: 0.9;
			-webkit-transform: scale(1) translate(0px,0px);
			-moz-transform: scale(1) translate(0px,0px);
			-o-transform: scale(1) translate(0px,0px);
			-ms-transform: scale(1) translate(0px,0px);
			transform: scale(1) translate(0px,0px);
			visibility: visible;
		}

		.fa-chevron-up {
			background-color: #5a9ad0;
		}
		.fa-chevron-up:hover {
			text-decoration: none;
			opacity: .8;
		}

		.fold_on {
			overflow:hidden;
			height: 15px;
		}
		.fold_clickTd{
			overflow:hidden;
			text-overflow:ellipsis;
		}
		.fold_clickTh:hover {
			text-decoration: underline;
			color: blue;
			cursor: pointer;
		}

		.nologUrlBtn{
			cursor: pointer;
		}

		div#periodBodyMenu {position:absolute; visibility:hidden; top:0;text-align: left;z-index: 999;border: 1px solid #555;background-color: #DCE7F3;}
		.ellipsis {
			white-space:nowrap;overflow:hidden;text-overflow:ellipsis;
		}
	</style>
	<script type="text/javascript">
		var popup_msgId = '<%=msgid%>';
		var popup_searchKey = '<%=searchKey%>';
		var popup_bodySize = '<%=bodySize%>';
		var infoFeedbackYn = '<%=infoFeedbackYn%>';
		var infoFeedbackConf = '<%=infoFeedbackConf%>';
		var infoHynixConf = '<%=infoHynixConf%>';
		var mode='';
		var kHighlight = '<%=keywordHighlight%>';
		var hostQueryUse = '<%=hostQuery%>';


		$(document).ready(function(){

			if(popup_msgId!= '') {
				getMessage(popup_msgId, popup_searchKey, popup_bodySize, kHighlight,hostQueryUse);
			}else{
				$('#notSelectDiv').css("display", '');
			}

			if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ){
				$('#infoFeedbackTr, #recommendBtn').show();
				$('#docTr').hide();
				if( infoHynixConf == 'true'){
					$('#infoFeedbackTr, #recommendBtn').hide();
					$('#docTr').show();
				}
			} else{
				$('#infoFeedbackTr, #recommendBtn').hide();
			}

			$('.fold_clickTr').click(function(){
				if( $(this).find('.fold').hasClass('fold_on') ) $(this).find('.fold').removeClass('fold_on');
				else $(this).find('.fold').addClass('fold_on');
			});

			$('#testx').click(function(){
				console.log($(this).html());
			});

			$('#recommendBtn').click(function(){
				var d = new Date();
				d.setDate(d.getDate() - 1);
				var targetDate = d.format('yyyymmdd');
				fnOpenWindow('<c:url value="/ems/recommend.do" />?msgId='+msgId+'&targetDate='+targetDate, 'recommend', 1300, 800, 'fix');
			});

			$(document).on('click', '#nologUrlBtn', function(){
				var host_path = $('#hostDiv').text();
				mode = 'insert';
				if(popup_msgId!= '') {
					if(host_path.indexOf('?') > -1) $('#noLogurl').val(host_path.substring(0, host_path.indexOf('?')));
					else $('#noLogurl').val(host_path);
					$("#urlPop").modal('show');
				}else{
					parent.openNologUrlPop(host_path);
				}
			});


		});

		/* grid 관련 */




		var contentBody = {
			urlIpBlockPreview:'<s:message code="urlIpBlock.preview"/>',
			bodyviewSn:'<s:message code="bodyview.sn"/>',
			bodyviewCn:'<s:message code="bodyview.cn"/>',
			bodyviewId:'<s:message code="bodyview.id"/>',
			bodyviewPn:'<s:message code="bodyview.pn"/>',
			bodyviewFn:'<s:message code="bodyview.fn"/>',
			bodyviewEc:'<s:message code="bodyview.ec"/>',
			bodyviewDRM:'<s:message code="bodyview.DRM"/>',
			bodyviewEf:'<s:message code="bodyview.ef"/>',
			bodyviewInfoPattern:'<s:message code="bodyview.info.pattern"/>',
			unknown:'<s:message code="bodyview.unknown"/>',
			unknownFileName:'<s:message code="bodyview.unknown.filename"/>',
			user:'<s:message code="consent.user"/>',
			from:'<s:message code="condition.from"/>',
			to:'<s:message code="condition.to"/>',
			cc:'<s:message code="condition.cc"/>',
			bcc:'<s:message code="condition.bcc"/>',
			ocrBody:'<s:message code="bodyview.ocr.preview.body"/>',
			ocrAttach:'<s:message code="bodyview.ocr.preview.attach"/>',
			noRecvs:'<s:message code="common.msg.norecvs"/>'
		};



		function getSimilarDoc(){
			ui.get({
				url : 'getSimilarDoc.xcn',
				success : function ( data, total ) {

				},
				error : function (status, message) {
					ui.alertMsg(message);
				},
				complete : function (){
				}
			});
		}

		function getinfoTypeStr(val) {
			if(val == '4') return '<s:message code="condition.info.class4"/>';
			else if(val == '3') return '<s:message code="condition.info.class3"/>';
			else if(val == '2') return '<s:message code="condition.info.class2"/>';
			else if(val == '1') return '<s:message code="condition.info.class1"/>';
			else return '<s:message code="common.msg.noinfo"/>';
		}
		function getinfoTypeBgColor(val) {
			if(val == '4') return 'red';
			else if(val == '3') return 'orange';
			else if(val == '2') return '#2393e1';
			else if(val == '1') return '#bbb';
			else return '#ccc';
		}

		function initHighlight(){
			$('span').removeClass('clsHighlight');
		}
		/**
		 * 이미지 미리보기 이벤트 발생
		 */
		function filePreviewEv( obj )
		{
			//contentBodyNew.js 파일에서는 Loading.gif 이미지를 호출할 수가 없어 jsp로 function 뺌
			var fileName = $(obj).attr('attachname');
			var str_loc  = fileName.lastIndexOf(".");
			var fileExt = fileName.substring(str_loc+1);
			fileExt = fileExt.toLowerCase( );
			if ( fileExt == "jpg" || fileExt == "jpeg" || fileExt == "gif" || fileExt == "png" || fileExt == "bmp" )
			{
				var msgId = $(obj).parents('ul').attr('msgid');
				var attachId = $(obj).parents('ul').attr('id');
				var url = contextRoot + '/downEmassAttach.xcn?msgId='+msgId+'&attachId='+attachId;
				var u = '<c:url value="/img/loading/Loading.gif"/>';
				var n = '<c:url value="/img/noneImage.png"/>';
				var urlStr = "<div id='noneImage' style='width: 200px; height: 200px; padding-left:0px;padding-top:50px;text-align:center;'><img src='"+u+"'/></div>";
				urlStr += "<a href='javascript:void(0)'><img border='0' id='realImage' style='display:none;' width='200px;' height='200px;' src='"+url+"' onerror=\"this.src='" + n + "';\" onload=\"noneImage.style.display='none';this.style.display=''\" /></a>";
				urlStr += '<div id="fullSizeOverlay" style="display:none; position: absolute; top: 0px; left: 0px; right: 0px; bottom: 0px; background-color: #000; opacity: .7; cursor: pointer;"><div style="background-color: #fff; display: inline-block; opacity: 1 !important; padding: 1px; position: relative; top: 95px; left: 30px;"><s:message code="message.msg.img.big"/></div></div>';

				$('#imgPreviewDiv').html(urlStr);
				$('#imgPreviewDiv').attr('url',url);
				$('#imgPreviewDiv').attr('fileName',fileName);


				var left = $(obj).offset().left;
				if( $(obj).offset().left + $('#imgPreviewDiv').width() > $(window).width()){
					left-=$('#imgPreviewDiv').width()-20;
				}
				$('#imgPreviewDiv').css('top', $(obj).offset().top + 15);
				$('#imgPreviewDiv').css('left', left + 40);
				setTimeout(function(){
					$('#imgPreviewDiv').fadeIn();
				}, 100);




			}
		}

		function getParticipantInfo(){
			var startDt = $('#startdatepickerBody').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
			var endDt = $('#enddatepickerBody').data("DateTimePicker").date().format('YYYYMMDDHHmmss');

			var url    = '<c:url value="/ems/participantInfoPop.do?xrootmtr='+xRootMtr+'&srcip='+srcip+'&usr_id='+usr_id+'&startDt='+startDt+'&endDt='+endDt+'"/>';
			var pop = fnOpenWindow(url, 'participant', 1015, 450, 'resize');
		}

	</script>
</head>
<div class="grayBg02">
	<!-- 메시지 상세 시작 -->
	<div class="inner_message" id="msgDiv" style="display: none">
			<div class="messageBtn">
				<div class="btnform">
					<button class="btn01" id="prevBtn"><img src="../img/subBtn_arrow_left_12.png" alt=""></button>
					<button class="btn01" id="nextBtn"><img src="../img/subBtn_arrow_right_12.png" alt=""></button>
					<button class ="btn05 msg_button" id="saveBtn"><img src="../img/subBtn_save.png" alt="<s:message code="common.msg.save"/>"><s:message code="common.msg.save"/></button>
					<button class="btn05" id="printBtn"><img src="../img/subBtn_mail.png" alt="<s:message code="common.msg.print"/>"><s:message code="common.msg.print"/></button>
					<button class="btn05 msg_button dropdown-toggle" data-toggle="dropdown" ><img src="../img/subBtn_settings.png" data-toggle="dropdown" alt="<s:message code="common.msg.addFunctions"/>"><s:message code="common.msg.addFunctions"/><span class="caret"></span></button>
						<ul class="dropdown-menu dropdown-additionMenu" role="menu" style="min-width:100px;font-size:13px;" id="additionalBtn">
							<li><a href="javascript:void(0);" id="usersInfoBtn"><s:message code="common.msg.userinfo"/></a></li>
							<li class="dropdown-divider"></li>
							<li><a href="javascript:void(0);" id="headerBtn"><s:message code="common.msg.headerInfo"/></a></li>
							<li class="dropdown-divider"></li>
							<li><a href="javascript:void(0);" id="originalBtn"><s:message code="common.msg.originalInfo"/></a></li>
							<li class="dropdown-divider"></li>
							<li><a href="javascript:void(0);" id="domainBtn"><s:message code="common.msg.domainInfo"/></a></li>
							<li class="dropdown-divider"></li>
							<li><a href="javascript:void(0);" id="mailFowardBtn"><s:message code="common.msg.forward_mail"/></a></li>
							<li class="dropdown-divider"></li>
							<li><a href="javascript:void(0);" id="warnMailBtn"><s:message code="common.msg.warning_mail"/></a></li>
							<li class="dropdown-divider"></li>
							<li><a href="javascript:void(0);" id="msgIdBtn">ID</a></li>
						</ul>
					<button class="btn05" id="openBigContent"><img src="../img/subBtn_link.png" alt="새창"><s:message code="bodyview.window.new"/></button>
				</div>
				<div class="btnform txt_right">
					<%-- 메시지 보관--%>
					<%--saveMsgData--%>
					<button class="btn05" id="saveMsgData"><s:message code="filterInfo.setMsgFolder1"/></button>
					<%-- 내보내기--%>
					<button  class="btn05" href="javascript:;" style="padding-right:10px; color:#383838; cursor: pointer; font-size: 12px;left:178px;"data-toggle="dropdown" id="exportMsg"><s:message code="common.msg.export"/><span class="caret"></span></button>
					<ul class="dropdown-menu dropdown-exportMenu" role="menu" style="min-width:100px;font-size:13px;">
						<li style="display:none;"><a href="javascript:void(0);" id="body_link_btn" class="body_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-text-o" style="font-size:16px"></span>&nbsp;<s:message code="condition.body"/></a></li>
						<li style="display:none;"><a href="javascript:void(0);" id="attach_link_btn" class="attach_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-archive-o" style="font-size:16px"></span>&nbsp;<s:message code="consent.attach"/></a></li>
						<li style="display:none;"><a href="javascript:void(0);" id="excel_link_btn" class="excel_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>" option="Y"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/> (<s:message code="common.msg.excel"/> xlsx)</a></li>
						<li style="display:none;"><a href="javascript:void(0);" id="cell_link_btn" class="cell_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>" option="Y"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/> (<s:message code="common.msg.hancel"/> cell)</a></li>
						<li style="display:none;"><a href="javascript:void(0);" id="csv_link_btn" class="csv_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>" option="Y"><span class="fa fa-file-text" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/> (<s:message code="common.msg.text"/> csv)</a></li>
						<li style="display:none;"><a href="javascript:void(0);" id="pdf_link_btn" class="pdf_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>" option="Y"><span class="fa fa-file-pdf-o" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/> (PDF)</a></li>
						<c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'LS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
							<li><a href="javascript:void(0);" class="all_down_link" data-type="L" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/></a></li>
						</c:if>
						<c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'BS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
							<li><a href="javascript:void(0);" class="all_down_link" data-type="B" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-text-o" style="font-size:16px"></span>&nbsp;<s:message code="condition.body"/></a></li>
						</c:if>
						<c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'AS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
							<li><a href="javascript:void(0);" class="all_down_link" data-type="A" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-archive-o" style="font-size:16px"></span>&nbsp;<s:message code="consent.attach"/></a></li>
						</c:if>
						<c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'WS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
							<li><a href="javascript:void(0);" class="all_down_link" data-type="LB" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/>+<s:message code="condition.body"/></a></li>
						</c:if>
						<c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'CS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
							<li><a href="javascript:void(0);" class="all_down_link" data-type="LBA" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="selectCodeAll.list"/>+<s:message code="condition.body"/>+<s:message code="consent.attach"/></a></li>
						</c:if>
						<c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'LP') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
							<li><a href="javascript:void(0);" class="print_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="glyphicon glyphicon-print"></span>&nbsp;<s:message code="selectCodeAll.list"/> <s:message code="common.msg.print"/></a></li>
						</c:if>
						<li class="dropdown-divider"></li>
						<li><a href="javascript:void(0);" class="downList" data-target="tabGrid" ><span class="glyphicon glyphicon-th-list"></span>&nbsp;<s:message code="common.msg.download"/> <s:message code="mail.view.list"/></a></li>
					</ul>
				</div>
			</div>
			<div class="messageCon"> <%--     condition.receive ,  condition.send--%>
					<%--  수신 / 발신 정보 표시 --%>
					<div id="recvOrsend" class="top ">
						<span class="sub_flag_send" id="sub_flag_send" style="display: none"><s:message code="condition.send"/> </span>
						<span class="sub_flag_reception" id="sub_flag_reception" style="display: none"><s:message code="condition.receive"/> </span>
						<h4 class="red02" id="subject"></h4>
						<span class="loca" id="svc"></span>
					</div>

					<div class="conBox">
							<div id="userTr">
								<h5 id="userid"></h5>
								<span class="loca" id="ctimeTd"></span>
							</div>
						<table class="subTable mat8">
							<tr>
								<th><s:message code="bodyview.srcIp"/></th>
								<td class="topline" id="srcipTd"></td>
								<th><s:message code="bodyview.dstIp"/></th>
								<td class="topline" id="dstipTd"></td>
							</tr>
							<tr>
								<th><s:message code="bodyview.body.size"/></th>
								<td id="bodySizeTd"></td>
								<th><s:message code="bodyview.userId"/></th>
								<td id="userIdTd"></td>
							</tr>
							<tr>
								<th><s:message code="bodyview.hostPathInfo"/></th>
								<td colspan="3" class="mal8 tableLink txt_left" id="hostDiv"></td>
							</tr>
						</table>
					</div>
				</div>
				<div id="fileDiv" class="messageCon">
					<div class="top grayBg03">
						<h4><s:message code="bodyview.file.info"/></h4><h4 id="fileCntArea"></h4> <%--뒤에 파일 갯수 표기--%>
						<div class="btn btnform">
							<button class="btn05" id="allDownload"><img src="<c:url value="/img/subBtn_save.png"/>"  alt="확대"> <s:message code="bodyview.file.allDownload"/></button>
						</div>
					</div>
					<ul id="filelist"></ul>
				</div>
				<div class="messageCon" id="bodyDiv">
					<div class="top grayBg03">
							<h4>본문내용</h4>
							<div class="btn btnform">
								<button class="btn05 font_size" id="large_txt"><img src="<c:url value="/img/subBtn_add.png"/>"  alt="<s:message code="bodyview.msg.zoomIn"/>"><s:message code="bodyview.msg.zoomIn"/></button>
								<button class="btn05 font_size" id="small_txt"><img src="<c:url value="/img/subBtn_add02.png"/>" alt="<s:message code="bodyview.msg.zoomOut"/>"><s:message code="bodyview.msg.zoomOut"/></button>
								<button class="btn05" id="copyBodyBtn"><img src="<c:url value="/img/subBtn_copy.png"/>" alt="<s:message code="bodyview.body.contentCopy"/>"><s:message code="bodyview.body.contentCopy"/></button>
								<select class="btn05" name="bodyEncoding" id="bodyEncoding">
									<option value=""><s:message code="common.msg.auto"/></option>
									<option value="utf-8">UTF-8</option>
									<option value="euc-kr">EUC-KR</option>
								</select>
							</div>
							<div class="conBox" id="bodyStrDiv">
								<span><s:message code="condition.body"/> <s:message code="bodyview.find.keyword"/> : </span>
								<span style="font-weight: bold;" id="bodyStr"></span>
							</div>
					</div>
					<div class="conBox" id="emassBody"/>
				</div>
			<div id="imgPreviewDiv"></div>
			<div id="infoDiv" style="overflow-y:auto;display:none;">
				<div id="infoDivTextHeader">
					<i class="fa fa-stop-circle-o" aria-hidden="true"></i>
					<s:message code="common.msg.textdecode"/>(unescape)
				</div>
				<div id="infoDivText">
				</div>
			</div>
			<a href="#0" class="back-to-top cd-top" style="z-index: 99999999"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>
			<iframe id="AttachDown" src="about:blank;" height="0" width="0" style="display: none;" ></iframe>
			<form id="mailForwardForm" method="post">
				<input type="hidden" name="msgId" id="msgIdStr">
				<input type="hidden" name="xRootMtr" id="xRootMtrStr">
				<input type="hidden" name="userCharset" id="userCharsetStr">
				<input type="hidden" name="mailForwardStr" id="mailForwardStr">
			</form>
			<form name="imageForm" method="post" target="">
				<input type="hidden" name="imgUrl">
				<input type="hidden" name="fileName">
			</form>
		</div>
	</div>
<%-- 메시지 상세 끝 --%>


	<div class="boxArea" id="notfoundmsgDiv" style="display: none;">
		<div class="content_body">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default" style="height:180px;">
						<div class="panel-heading" style="font-weight: bold;height:40px;">
							<div class="pull-left" style="cursor:default;width:100%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;word-wrap:normal">
								<s:message code="common.msg.information"/>
							</div>
						</div>
						<div class="panel-body css-body">
							<div style="font-size: 20px;font-weight: bold;padding-top:20px;">
								<img src="<c:url value="/img/warn.png"/>" width="60"> <s:message code="bodyview.message.notfoundmsg"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="featureModal"  style="z-index: 1060;">	<!-- modal -->
		<div class="modal-dialog" role="document">
			<div class="modal-content" style="width: 920px; height:155px;">
				<form method="post" id="mlResultPopForm" onsubmit="return false">
					<div class="modal-header">
						<span>판단 근거</span>
						<table class="table table-bordered">
							<colgroup>
								<col style="width: 180px;"/>
							</colgroup>
							<tr>
								<td scope="row"><label class="form-check-label" id="featuresValue"></label></td>
							</tr>
						</table>
					</div>

				</form>
				<div class="modal-footer" style = "height: 10px;">
					<!-- <button type="button" class="btn btn-primary feedbackSave">피드백 저장</button>  -->
					<button type="button" id = "closeModal" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<div class="boxArea" id="notfoundconsentDiv" style="display: none;">
		<div class="content_body">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default" style="height:180px;">
						<div class="panel-heading" style="font-weight: bold;height:40px;">
							<div class="pull-left" style="cursor:default;width:100%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;word-wrap:normal">
								<s:message code="common.msg.information"/>
							</div>
						</div>
						<div class="panel-body css-body">
							<div style="font-size: 20px;font-weight: bold;padding-top:20px;">
								<img src="<c:url value="/img/warn.png"/>" width="60"> <s:message code="bodyview.message.notfoundconsent"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="msg_body_container" id="notSelectDiv" style="display:none;">
		<div class="boxArea" style="overflow-x:hidden;overflow-y: auto;">
			<div id="emptyDiv" class="empty-dashboard-message">
				<h1 style="text-align:center;font-size:100px;color:#253f56;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i></h1>
				<h2><s:message code="bodyview.select.message"/></h2>
				<p><s:message code="bodyview.message.info"/></p>
			</div>
		</div>
	</div>
	<%-- userInfoDiv --%>
	<div id="userInfoDiv" style="display:none;">
		<div>
			<div style="float:left;">
				<img src="<c:url value="/img/person.png"/>" width="64">
			</div>
			<div style="float:left;width:calc(100% - 65px);height:64px;padding-top:12px;padding-left:10px;">
				<div class="ellipsis" id="userNamePop" style="font-weight: bold;"></div>
				<div class="ellipsis" id="userEmailPop" style="word-break: break-word; font-size:11px;"></div>
			</div>
			<div style="clear:both;width:100%;padding:10px 10px 10px 10px;">
				<div>
					<table style="table-layout: fixed;width:100%;">
						<colgroup>
							<col width="70px">
							<col width="*">
						</colgroup>
						<tr>
							<th><s:message code="common.org.co"/></th>
							<td><div class="ellipsis" id="userCoNmPop"></div></td>
						</tr>
						<tr>
							<th><s:message code="common.org.busi"/></th>
							<td><div class="ellipsis" id="userBusiNmPop"></div></td>
						</tr>
						<tr>
							<th><s:message code="common.org.general"/></th>
							<td><div class="ellipsis" id="userSuborgNmPop"></div></td>
						</tr>
						<tr>
							<th><s:message code="common.org.dept"/></th>
							<td><div class="ellipsis" id="userDeptNmPop"></div></td>
						</tr>
						<tr>
							<th><s:message code="common.org.jikgub"/></th>
							<td><div class="ellipsis" id="userJikgubNmPop"></div></td>
						</tr>
						<tr>
							<th>IP</th>
							<td><div id="userIpPop"></div></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	var op_attach_save = '<%=op_attach_save%>';
	var op_body_save = '<%=op_body_save%>';
	var op_body_print = '<%=op_body_print%>';
	var mailUseFlag = <%=mailUseFlag%>;
	var adminEmail = '${_USERCREDENTIAL_.adminEmail}';

	var message = {
		nosubject:'<s:message code="common.msg.nosubject"/>',
		attach:'<s:message code="consent.attach"/>',
		subject:'<s:message code="condition.subject"/>',
		body:'<s:message code="condition.body"/>',
		attach_name:'<s:message code="condition.attach_name"/>',
		message_info:'<s:message code="DATA_MONITOR.MESSAGE_INFO"/>',
		userinfo:'<s:message code="common.msg.userinfo"/>',
		authAlert:'<s:message code="admin.auth.alert"/>',
		attachSave:'<s:message code="bodyview.attach.save"/>',
		fileName:'<s:message code="bodyview.file.name"/>',
		msgid:'<s:message code="common.msg.msgid"/>',
		pre_ext:'<s:message code="message.msg.pre_ext"/>',
		total_count:'<s:message code="bodyview.total_count"/>',
		msgAuto:'<s:message code="common.msg.auto"/>',
		msgNomsg:'<s:message code="bodyview.message.nomsg"/>',
		bodyPrint:'<s:message code="bodyview.body.print"/>',
		xrootmtr:'<s:message code="condition.xrootmtr"/>',
		bodyView:'<s:message code="bodyview.body.view"/>',
		msgNomail:'<s:message code="bodyview.message.nomail"/>',
		chk_account:'<s:message code="bodyview.message.mail.chk_account"/>',
		msgNocontent:'<s:message code="common.msg.nocontent"/>',
		msgParticipantinfo:'<s:message code="common.msg.participantinfo"/>',
		windowNew:'<s:message code="bodyview.window.new"/>',
		windowTab:'<s:message code="bodyview.window.tab"/>',
		copyBodyMsg:'<s:message code="bodyview.copyBodyMsg"/>',
		fileNotFound:'<s:message code="message.message.notfound.attach"/>'
	};

	function alert(msg){
		ui.alertMsg(msg);
	}
</script>
</html>
<%
	/*
	if ( no_data.isEmpty ( ) )
	{
		String ctime = msg.getCtime().replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "");
		String ctime_yyyymmdd = ctime.substring(0, 8);
		String ctime_yyyymm = ctime.substring(0, 6);
		String ctime_yyyy = ctime.substring(0, 4);
		String ctime_hh = ctime.substring(8, 10);

		String allofus = Common.nvl ( msg.getAllOfUs() );
		String inside = Common.nvl ( msg.getInSide() );
		String attached = Common.nvl ( msg.getAttached() );

		SolrCheckedVO solrCheckedVO = new SolrCheckedVO();
		solrCheckedVO.setId(Common.getAdminId(session));
		solrCheckedVO.setMsgid(msgId);

		solrCheckedService.setRead(solrCheckedVO);
	}
*/
%>
