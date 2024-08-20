<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.xcurenet.config.service.ConfigAdminService" %>
<%@ page import="com.xcurenet.config.service.ConfigAdminVO" %>
<%@ page import="com.xcurenet.audit.service.Operation" %>
<%@ page import="com.xcurenet.common.util.SpringContextUtil" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.xcurenet.config.service.ConfigAdminService" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ page import="com.xcurenet.admin.service.AdminVO" %>
<%@ page import="com.xcurenet.admin.service.impl.AdminServiceImpl" %>
<%@ page import="com.xcurenet.common.session.SessionManagement" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/fragments/messageScript.jsp"%>

<link rel="stylesheet" href="<c:url value="/css/bootstrap-datetimepicker.min.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/bootstrap-select.min.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/message.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/messageContent.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/contentBody.css"/>"/>

<script type="text/javascript" src="<c:url value="/js/moment.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/Date.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ko.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-select.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/referrer-killer.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/contentBodyNew.js"/>"></script>
<%
	ConfigAdminService configAdminService = SpringContextUtil.getBean(ConfigAdminService.class);
	Config conf = SpringContextUtil.getBean(Config.class);
	Map<String, Object> param = Common.getParamMap(request);
	String msgid = Common.nvl(param.get("msgid"));
	String searchKey = Common.nvl(param.get("searchKey"));
	String bodySize = Common.nvl(param.get("bodySize"));
	boolean mailUseFlag = Config.getBoolean("mail.forward.flag");
	boolean isLlmEnabled = conf.isLlmEnabled();
	boolean isLlmSingle = Config.getBoolean("llm.single");
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
	
	
	
	AdminVO adminVo = (AdminVO) session.getAttribute("_USERCREDENTIAL_");
	String adminEmail = "";
	if(adminVo != null){
		if(Common.isEmpty(adminVo.getAdminEmail())) {
			AdminServiceImpl adminService = SpringContextUtil.getBean(AdminServiceImpl.class);
			AdminVO result = adminService.getAdmin(adminVo.getAdminId());
			adminEmail = result.getAdminEmail();
		}else{
			adminEmail = adminVo.getAdminEmail();
		}
	}

%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
	<title>EMASS AI - <s:message code="OPERATION_MGMT.BODY_VIEW"/></title>
	<style type="text/css">
		html, body{
			min-width:600px !important;}
		.contents {
			min-width:700px !important;
		}
		.boxArea {
			height: 100% !important;
			min-height: 0px !important;
		}

		.fa-lg{
			vertical-align: -30%; !important;
		}

		.glyphicon-remove:before {
			color: #fff4eb;
		}
		button {font-family: Pretendard !important; font-weight:400; color:#383838;}
		#buttonDiv {
			position: fixed;
			width: 100%;
			z-index: 9;
			background-color: #fff;
			padding-bottom: 5px;
			/*border-bottom: 1px solid #ccc;*/
			top: 0px;
			left: 4px;
			right: 0px;
			height: 35px;
			width: 100%;
			min-width: 675px;
		}



		#buttonDiv .btnright{position: absolute; right:20px; top:12px;}
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


		.userOutside  {margin:2px;}
		.userOutside{
			display: inline-block;
			padding: 2px 6px 2px 0px;
			padding-left: 20px;
			background: #FC5656 url(../img/flag_img_01.png) 5px center no-repeat;
			background-image: 100%;
			color: #fff;
			font-size: 12px;
			font-weight: 600;
			border-radius: 4px;
			margin:4px;
		}
		.userOutside:hover {color:#fff;}

		.userInside  {margin:2px;}
		.userInside{
			display: inline-block;
			padding: 2px 6px 2px 0px;
			padding-left: 20px;
			background: #1C64D3  url(../img/flag_img_01.png) 5px center no-repeat;
			background-image: 100%;
			color: #fff;
			font-size: 12px;
			font-weight: 600;
			border-radius: 4px;
			margin:4px;
		}

		.userInside:hover {color:#fff;}



		.notuser{
			margin:4px;
			display: inline-block;
			padding: 2px 6px 2px 6px;
			background: gray;
			color: #fff;
			font-size: 12px;
			font-weight: 600;
			border-radius: 4px;
		}
		.notuser:hover {color:#fff;}

		#infoTable td div {
			word-break:break-all;
		}
		.fa-chevron-up {
			background-color: #333;
		}
		.fa-chevron-up:hover {
			text-decoration: none;
			opacity: .8;
		}
		.fold_on {
			overflow:hidden;
			height: 19.98px;
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

		div#periodBodyMenu {position:absolute; visibility:hidden; top:0;text-align: left;z-index: 999;border: 1px solid #555;background-color: #fff; font-size: 14px;}
		.ellipsis {
			white-space:nowrap;overflow:hidden;text-overflow:ellipsis;
		}
		.bootstrap-select.btn-group .dropdown-menu.inner {
			box-shadow: none !important;
		}
		.checkbox-inline+.checkbox-inline, .radio-inline+.radio-inline {margin-left:4px;}
/*
		.exceptOption, .exceptOption2 {
			position: relative;
			padding-left: 30px;
		}

		.exceptOption {
			top: 5px;
		}

		.c-checkbox input,
		.c-radio input {
			opacity: 0;
			position: absolute;
			margin-left: 0 !important;
		}
		input[type="checkbox"]:disabled {width:0; height:0; border:none;}*/

		#emassBody table {table-layout: fixed; }
		#emassBody img { width:100%;}
	</style>
	<script type="text/javascript">
		var popup_msgId = '<%=msgid%>';
		var popup_searchKey = '<%=searchKey%>';
		var popup_bodySize = '<%=bodySize%>';
		var infoFeedbackYn = '<%=infoFeedbackYn%>';
		var infoFeedbackConf = '<%=infoFeedbackConf%>';
		var infoHynixConf = '<%=infoHynixConf%>';
		var isLlmSingle = '<%=isLlmSingle%>';
		var mode='';
		var kHighlight = '<%=keywordHighlight%>';
		var hostQueryUse = '<%=hostQuery%>';
		var unknown =  '<s:message code="bodyview.unknown"/>';


		$(document).ready(function(){
			if(popup_msgId!= '') {
				getMessage(popup_msgId, popup_searchKey, popup_bodySize, kHighlight,hostQueryUse);
			}else{
				$('#notSelectDiv').css("display", '');
			}

			if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ){
				$('#infoFeedbackTr').show();
				$('#docTr').hide();
				if( infoHynixConf == 'true'){
					$('#infoFeedbackTr').hide();
					$('#docTr').show();
				}
			} else{
				$('#infoFeedbackTr').hide();
			}

			$('.fold_clickTr').click(function(){
				if( $(this).find('.fold').hasClass('fold_on') ) $(this).find('.fold').removeClass('fold_on');
				else $(this).find('.fold').addClass('fold_on');
			});

			$('#testx').click(function(){
			});

			$('#recommendBtn').click(function(){
				var d = new Date();
				d.setDate(d.getDate() - 1);
				var targetDate = d.format('yyyymmdd');
				var subjectIsEmpty = false;
				var isUnknownDocument = false;
				if($('#subjectIsEmpty').length > 0) subjectIsEmpty = true;
                
                var svcValue = $("#unKnownDocument").val();
                if(svcValue.startsWith("u") > -1) isUnknownDocument = true;
				fnOpenWindow('<c:url value="/ems/recommend.do" />?msgId='+msgId+'&targetDate='+targetDate+'&subjectIsEmpty='+subjectIsEmpty+'&isUnknownDocument='+isUnknownDocument, 'recommend', 1300, 800, 'fix');
			});

			$('#fileHelpDivCloseBtn').click(function(){
				$('#fileHelpDiv').hide();
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

			$(document).on('click', '#helpHost', function(){
				$("#helpView").css("display", "");
				$("#helpHost").css("display", "none");
				ui.get({
					url : 'getLLMAnalysis.xcn',
					chat : '"' + $('#helpHost').attr('title') + '" 통신하는 URL 주소가 어떤 서비스인지 간략하게 알려줄수 있어?',
					success : function ( data, total ) {
						$('#helpHostDesc').html(data.response.fReplaceWord('\n', '.</br>'));
						$('#hostDiv a').attr("title", data.response.fReplaceWord('\n', '.</br>'));

						insertLlmHost($('#helpHost').attr('title'), data.response.fReplaceWord('\n', '.</br>'));
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						$("#helpView").css("display", "none");
						$("#helpHost").css("display", "");
						$("#hostDescriptionDiv").css("display", "none");

					}
				});
			});

			$(document).on('click', '#koreaBody', function(){
				$('#summaryModal h2').html('본문내용 한국어 번역');
				$("#helpView2").css("display", "");
				$("#llmImg1").css("display", "none");
				ui.get({
					url : 'getLLMAnalysis.xcn',
					chat : limitStringLength($('#emassBody').text(), 2000) + '\n\n\n위에 내용을 한글로 번역해줘?',
					success : function ( data, total ) {
						$('#summaryContent').html('아래 내용은 한국어로 번역한 내용입니다.<br><br>' + data.response.fReplaceWord('\n', '.</br>').fReplaceWord('. ', '.</br>'));
						$("#summaryModal").modal('show');
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						$("#helpView2").css("display", "none");
						$("#llmImg1").css("display", "");
					}
				});
			});

			$(document).on('click', '#summaryBody', function(){
				$('#summaryModal h2').html('주제 키워드 분석');
				$("#helpView3").css("display", "");
				$("#llmImg2").css("display", "none");
				ui.get({
					url : 'getLLMAnalysis.xcn',
					chat : limitStringLength($('#emassBody').text(), 2000) + '\n\n\n위에 내용에서 주제키워드 단어로 10개정도 추출해죠?',
					success : function ( data, total ) {
						$('#summaryContent').html('아래 내용은 주제키워드를 분석한 내용입니다.<br><br>' + data.response.fReplaceWord('\n', '.</br>'));
						$("#summaryModal").modal('show');
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						$("#helpView3").css("display", "none");
						$("#llmImg2").css("display", "");

					}
				});
			});

			$(document).on('click', '#serviceBody', function(){
				$('#summaryModal h2').html('내용분석');
				$("#helpView5").css("display", "");
				$("#llmImg4").css("display", "none");
				ui.get({
					url : 'getLLMAnalysis.xcn',
					chat : limitStringLength($('#emassBody').text(), 2000) + '\n\n\n위에 내용을 분석해서 어떤 서비스인지 알려줘?',
					success : function ( data, total ) {
						$('#summaryContent').html('아래 내용은 내용을 분석한 내용입니다.<br><br>' + data.response.fReplaceWord('\n', '.</br>'));
						$("#summaryModal").modal('show');
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						$("#helpView5").css("display", "none");
						$("#llmImg4").css("display", "");
					}
				});
			});

			$(document).on('click', '#contentBody', function(){
				$('#summaryModal h2').html('내용요약');
				$("#helpView4").css("display", "");
				$("#llmImg3").css("display", "none");
				ui.get({
					url : 'getLLMAnalysis.xcn',
					chat : limitStringLength($('#emassBody').text(), 2000) + '\n\n\n위에 내용을 요약해줘?',
					success : function ( data, total ) {
						$('#summaryContent').html('아래 내용은 내용을 분석한 내용입니다.<br><br>' + data.response.fReplaceWord('\n', '.</br>'));
						$("#summaryModal").modal('show');
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						$("#helpView4").css("display", "none");
						$("#llmImg3").css("display", "");
					}
				});
			});

		});



		function limitStringLength(inputString, maxLength) {
			return inputString.length <= maxLength ? inputString : inputString.substring(0, maxLength);
		}

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
			noRecvs:'<s:message code="common.msg.norecvs"/>',
			category:'<s:message code="common.category"/>',
			differentExt: '<s:message code="java.message.differentExt"/>',
			unknownExt:'<s:message code="java.message.unknownExt"/>',
			fileNameExistN:'<s:message code="java.message.fileNameExistN"/>',
			fileNoSizeNo:'<s:message code="java.message.fileNoSizeNo"/>',
			fileEncrypte :'<s:message code="bodyview.ef"/>',
			fileDrm : 'DRM'+'<s:message code="common.org.file"/>'
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

		function insertLlmHost(host, description){

			if (host == '' || host == null) return;
			if (description == '' || description == null) return;
			if (description.startsWith("죄송합니다,")) return;
			if (description.startsWith("죄송하지만")) return;
			if (description.startsWith("Sorry,")) return;
			if (description.startsWith("I'm sorry,")) return;

			ui.get({
				host : host,
				description : description,
				url : 'insertLlmHost.xcn',
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
				var msgId = $(obj).parents('tr').attr('msgid');
				var attachId = $(obj).parents('tr').attr('id');
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
			var startDt = $('#startdatepickerBody').data("DateTimePicker").date().format('YYYYMMDD');
			var endDt = $('#enddatepickerBody').data("DateTimePicker").date().format('YYYYMMDD');

            var url    = '<c:url value="/ems/participantInfoPop.do?xrootmtr='+xRootMtr+'&srcip='+srcip+'&usr_id='+usr_id+'&startDt='+startDt+'&endDt='+endDt+'"/>';
			var pop = fnOpenWindow(url, 'participant', 1015, 450, 'resize');
		}

	</script>
</head>
<div id="periodBodyMenu">
	<div style="height:30px;background-color:black;color:#fff;padding-left:10px;line-height:30px;font-weight: bold;cursor:default;">
		<div style="float:left;width:200px;">
			<i class="glyphicon glyphicon-calendar"></i>&nbsp;<s:message code="filterInfo.period.setting"/>
		</div>
		<div style="float:right;padding-right:8px; padding-top:5px;">
			<span class="glyphicon glyphicon-remove" style="cursor:pointer;" id="periodBodyMenuCloseBtn"></span>
		</div>
	</div>
	<div style="width:100%;padding:10px 10px 0px 10px;">
		<div>
			<s:message code="common.messenger.msg1"/><br/>
			<s:message code="common.messenger.msg2"/><br/>
			<s:message code="common.messenger.msg3"/><br/>
		</div>
		<div class="form-group form-inline" style="width:100%;">
			<div class="input-group" style="width:50px;font-weight: bold;">
				<s:message code="condition.period"/></div>
			<div id="startdatepickerBody" style="display: inline-block"><input type="date" id="startDtAdd" style="width: 140px;">
				<span class="hyphen">~</span></div>
			<div id="enddatepickerBody" style="display: inline-block"><input type="date" id="endDtAdd" style="width: 140px;"></div>
		</div>
	</div>
	<div style="text-align: center;padding-bottom: 15px;">
		<button type="button" class="btn01" accesskey="T" id="dateSearchBody" style="font-size:12px;" onclick="getGroupDetail();"><i class="glyphicon glyphicon-search"></i>&nbsp;<s:message code="common.messenger.all.view"/></button>
	</div>
</div>
<div class="msgBody">
	<div style="display: none;" id="buttonDiv">
		<div class="form-group p12" style="padding:4px 0px 0 5px; padding-top: 6px!important;" id="buttonArea">
			<button class="btn01" id="prevBtn"><img src="../img/icon/ico_arrow_left_b.png/"></button>
			<button class="btn01" id="nextBtn"><img src="../img/icon/ico_arrow_right_b.png/"></button>
			<div class="btnright">

				<button class="btn05" id="openOriginal" style="display: none;"><img src="../img/ico_main_tit12.png/"><s:message code="common.msg.view.original"/></button>
				<button class="btn05" id="saveBtn"><img src="../img/subBtn_save.png/"><s:message code="common.msg.save"/></button>
				<button class="btn05" id="printBtn"><img src="../img/subBtn_mail.png/"><s:message code="common.msg.print"/></button>
				<ul class="dropdown-menu dropdown-menu-left" role="menu" style="left:calc(80% - 102px);right:-1px" id="additionalBtn">
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
				<button class="btn05" id="openBigContent"><img src="../img/subBtn_link.png/"><s:message code="bodyview.window.new"/></button>
				<button class="btn05" id="recommendBtn"><img src="../img/ico_main_tit12.png/"><s:message code="common.msg.similar"/></button>
				<button type="button" class="btn05 dropdown-toggle" data-toggle="dropdown">
					<s:message code="common.msg.addFunctions"/> <span class="caret"></span>
				</button>
			</div>
		</div>
	</div>
	<div class="contents" style="padding-top: 40px;height: 100%;">
		<div class="boxArea" id="msgDiv" style="display: none;">
			<div class="content_body" style="transform: translateZ(0);">
				<div class="row">
					<div class="col-lg-12 mat8">
						<div class="panel panel-default" id="subjectDiv">
							<div class="panel-heading" style="font-weight: bold;min-height:35px;">
								<div id="subject" class="pull-left" style="cursor:default;width:calc(100% - 355px);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;word-wrap:normal;line-height: 25px;" title="subject"></div>
								<div class="pull-right">
									<span class="svcnmSpan"></span>
								</div>
								<div id="subjectStrDiv" style="clear:both;font-size:12px;padding-top:5px;">
									<span><s:message code="condition.subject"/> <s:message code="bodyview.find.keyword"/> : </span>
									<span style="font-weight: bold;" id="subjectStr"></span>
								</div>
							</div>
							<div class="panel-body">
								<div id="infoFeedbackTr" class="pb12" style="display: none;">
									<div class="form-inline not-dashed">
														<span style="display: inline-block;">
															<span id="infoType"></span>
															<span id="probType"></span>
														</span>
														<span style="display: inline-block;">
															<span id="ml_confd_userid"></span>
														</span>
									</div>
									<div class="form-inline not-dashed mat8 mab12">

										<label class="radio-inline c-radio">
											<input type="radio" name="feedback" class="feedback" value="0">
											<span class="fa fa-check"></span>
											<i class="feedbackCorrectBg"><img src="../img/icon/correct.png/" ><s:message code="condition.info.feedback0"/></i>

										</label>
										<label class="radio-inline c-radio">
											<input type="radio" name="feedback" class="feedback" value="9">
											<span class="fa fa-check"></span>
											<i class="feedbackDeferBg"><img src="../img/icon/defer.png/" ><s:message code="condition.info.feedback9"/></i>
										</label>
										<label class="radio-inline c-radio">
											<input type="radio" name="feedback" class="feedback" value="1">
											<span class="fa fa-check"></span>
											<i class="feedbackcommonBg"><img src="../img/icon/common.png/" ><s:message code="condition.info.class1"/></i>
										</label>
										<label class="radio-inline c-radio">
											<input type="radio" name="feedback" class="feedback" value="2">
											<span class="fa fa-check"></span>
											<i class="feedbackInNotOpenBg"><img src="../img/icon/notopen.png/"><s:message code="condition.info.class2"/></i>
										</label>
										<label class="radio-inline c-radio">
											<input type="radio" name="feedback" class="feedback" value="3">
											<span class="fa fa-check"></span>
											<i class="feedbackInOpenBg"><img src="../img/icon/open.png/"><s:message code="condition.info.class3"/></i>

										</label>
										<label class="radio-inline c-radio">
											<input type="radio" name="feedback" class="feedback" value="4">
											<span class="fa fa-check"></span>
											<i class="feedbackInCorrectBg"><img src="../img/icon/incorrect.png/"><s:message code="condition.info.class4"/></i>
										</label>
									</div>
								</div>
								<div id="">
									<table id="infoTable" class="subTable02" style="margin-bottom:0;table-layout:fixed;min-width:500px;">
										<colgroup>
											<col style="width: 110px;">
											<col>
											<col style="width: 125px;">
											<col style="width: 160px;">
										</colgroup>
										<tr id="usridTr">
											<th><s:message code="common.msg.account"/></th>
											<td id="userid">
											</td>
											<th><s:message code="condition.date"/></th>
											<td id="ctimeTd"></td>
										</tr>
										<tr id="srcTr">
											<th><s:message code="condition.source"/> IP</th>
											<td id="srcipTd"  class="topline"></td>
											<th><s:message code="condition.date"/></th>
											<td id="ctimeTd"  class="topline"></td>
										</tr>
										<tr id="destTr">
											<th><s:message code="condition.destination"/> IP</th>
											<td id="dstipTd"></td>
											<th><s:message code="filterInfo.size"/></th>
											<td id="bodySizeTd"></td>
										</tr>
										<tr id="userTr" class="fold_clickTr">
											<th class="fold_clickTh"><span class="fold_icon"></span><span class="trTitle fb600"><s:message code="consent.user"/></span></th>
											<td class="fold_clickTd" id="testx">
												<div id="userDiv" class="fold">
													<span class="userInfoSpan" recvid="revcid" recvip=""></span>
												</div>
											</td>
											<th><s:message code="common.msg.account"/></th>
											<td id="userIdTd" style="word-break: break-all;"></td>
										</tr>
										<tr id="fromTr" class="fold_clickTr">
											<th class="fold_clickTh"><span class="fold_icon"></span><span class="trTitle fb600"><s:message code="condition.from"/></span></th>
											<td class="fold_clickTd" colspan="3">
												<div id="sendUserDiv" class="fold">
												</div>
											</td>
										</tr>

										<tr id="toTr" class="fold_clickTr">
											<th class="fold_clickTh"><span class="fold_icon"></span><span class="trTitle fb600"><s:message code="condition.to"/></span></th>
											<td class="fold_clickTd" colspan="3">
												<div id="receiveUserDiv" class="fold">
												</div>
											</td>
										</tr>
										<tr id="ccTr" class="fold_clickTr">
											<th class="fold_clickTh"><span class="fold_icon"></span><span class="trTitle fb600"><s:message code="condition.cc"/></span></th>
											<td class="fold_clickTd" colspan="3">
												<div id="ccUserDiv" class="fold">
												</div>
											</td>
										</tr>
										<tr id="bccTr" class="fold_clickTr">
											<th class="fold_clickTh"><span class="fold_icon"></span><span class="trTitle fb600"><s:message code="condition.bcc"/></span></th>
											<td class="fold_clickTd" colspan="3">
												<div id="bccUserDiv" class="fold">
												</div>
											</td>
										</tr>
										<tr id="ipBusiNmTr">
											<th><s:message code="message.actual.business"/></th>
											<td>
												<div id="ipBusiNmDiv">
												</div>
											</td>
											<th class="topline"><s:message code="message.actual.dept"/></th>
											<td>
												<div id="ipDeptNmDiv">
												</div>
											</td>
										</tr>
										<tr id="hostTr">
											<th>HOST/Path <i id="nologUrlBtn" class="fa fa-chain-broken nologUrlBtn" aria-hidden="true"></i></th>
											<td colspan="3">
												<%if(isLlmEnabled){%>
												<i id="helpView" class="fa fa-spinner" aria-hidden="true" style="display: none" ></i>
												<img id="helpHost" alt="" src="<c:url value="/img/ztree/AI2.gif"/>" width="23px;" height="23px;">
												<%}%>
												<div id="hostDiv" style="padding-left: 10px;display: inline"></div>
												<%if(isLlmEnabled){%>
												<br>
												<div id="hostCategoryDiv" style="padding: 0px 6px 0px 2px; margin-top: 6px; border-radius: 4px; background-color: #F5F8FF; border: solid 1px #1C64D3; display: none; align-items: center;">
													<img id="hostcategoryImg" alt="" src="<c:url value='/img/ztree/AI2.gif'/>" width="23" height="23" style="margin-right: 4px;">
													<span id="hostCategory" style="color: #375E9A"></span>
												</div>
												<%}%>
												<%if(isLlmEnabled){%>
												<div id="helpHostDesc" style="display: block;padding-top: 10px; padding-bottom: 10px;"></div>
												<%}%>
												<div id="hostDescriptionDiv" style="display:block">
											</td>
										</tr>
										<%if(infoHynixConf){%>
										<tr id="docTr">
											<th><s:message code="condition.itype"/></th>
											<td colspan="3">
												<div id="docDiv">

												</div>
											</td>
										</tr>
										<%}%>
										<tr id="epmsgTr" style="display:none;">
											<th><s:message code="condition.epmsgType.list"/></th>
											<td colspan="3">
												<div id="epmsgDiv">
												</div>
											</td>
										</tr>
										<tr id="msgIdTr" style="display:none;">
											<th><s:message code="common.msg.msgid"/></th>
											<td colspan="3">
												<div id="msgIdDiv">
												</div>
											</td>
										</tr>
										<tr id="participantTr" style="display:none;">
											<th><s:message code="condition.participation"/></th>
											<td colspan="3">
												<div id="participantDiv">
												</div>
											</td>
										</tr>
										<tr id="rootmtrTr" style="display:none;">
											<th><s:message code="condition.xrootmtr"/></th>
											<td colspan="3">
												<div id="rootmtrDiv">
												</div>
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- 파일정보 -->
				<div id="fileDiv" class="row" style="overflow: visible;">
					<div class="col-lg-12">
						<div class="panel panel-default" id="">
							<div class="panel-heading body_toggle fileFold" style="padding:10px 12px 9px;">
								<s:message code="bodyview.file_info"/><span id="fileCntArea" class="blue02 fb600"></span>
								<img  style="width: 16px;margin-bottom: 2px;" class="areaBtn" id="fileHelpBtn" src="<c:url value="/img/icon/question.png"/>">
								<div class="pull-right" style="position: relative; margin-top:-7px;margin-right:2px;">
									<button class ="btn05" accesskey="V" id="saveAttachBtn"><img src="../img/subBtn_save.png/"><s:message code="bodyview.attach.save"/></button>
								</div>
								<div id="fileKwdDiv" style="font-size:12px;">
									<div id="attachStrDiv">
										<span><s:message code="bodyview.attach"/> <s:message code="bodyview.find.keyword"/> : </span>
										<span style="font-weight: bold;" id="attachStr">attachStr</span>
									</div>
									<div id="fileNameStrDiv">
										<span><s:message code="condition.attach_name"/> <s:message code="bodyview.find.keyword"/> : </span>
										<span style="font-weight: bold;" id="fileNameStr">fileNameStr</span>
									</div>
								</div>
							</div>

							<div id="fileHelpDiv" style="position: absolute; width: 395px; height: 205px; display: none; background-color: white; z-index: 1040;border: 1px solid #555;">
								<div class="fileHelpHeader" style="height:30px;background-color:black;color:#fff;padding-left:10px;line-height:30px;font-weight: bold;">
									<div style="float:left;width:250px;">
										<i class="glyphicon glyphicon-question-sign"></i>&nbsp;<s:message code="java.message.file"/>
									</div>
									<div style="float:right;padding-right:8px;" class="fileHelpDivCloseArea">
										<span class="glyphicon glyphicon-remove" style="cursor:pointer; line-height: 2;!important;" id="fileHelpDivCloseBtn" ></span>
									</div>
								</div>
								<div style="width:100%; padding:10px;" class="fileHelpDivBody">
									<div style="display: flex; align-items: center; margin-bottom: 5px;">
										<span style="display:inline-block; width: 20px; height: 20px; margin-right: 5px; background-color:#cbe8f7"></span>
										: <s:message code="java.message.fileNoSizeNo"/>
									</div>
									<div style="display: flex; align-items: center; margin-bottom: 5px;">
										<span style="display:inline-block; width: 20px; height: 20px; margin-right: 5px; background-color:#FFE8E8"></span>
										: <s:message code="java.message.differentExt"/>
									</div>
									<div style="display: flex; align-items: center; margin-bottom: 5px;">
										<span style="display:inline-block; width: 20px; height: 20px; margin-right: 5px; background-color:#FFFAC3"></span>
										: <s:message code="java.message.unknownExt"/>
									</div>
									<div style="display: flex; align-items: center; margin-bottom: 5px;">
										<span style="display:inline-block; width: 20px; height: 20px; margin-right: 5px; background-color:#E0F7DA"></span>
										: <s:message code="java.message.fileNameExistN"/>
									</div>
									<div style="display: flex; align-items: center; margin-bottom: 5px;">
										<span style="display:inline-block; width: 20px; height: 20px; margin-right: 5px; background-color:#e0d2fa"></span>
										: <s:message code="bodyview.ef"/>
									</div>
									<div style="display: flex; align-items: center;">
										<span style="display:inline-block; width: 20px; height: 20px; margin-right: 5px; background-color:#fac989"></span>
										: DRM <s:message code="common.org.file"/>
									</div>
								</div>

							</div>

							<div class="panel-body " style="display:none;">
								<div id="attachDiv">
									<table class="subTable02 table-bordered" id="fileTable">
										<colgroup>
											<col width="*">
											<col width="130">
											<col width="130">
											<col width="140">
										</colgroup>
										<tr>
											<th><s:message code="bodyview.file.name"/></th>
											<%-- <th><s:message code="message.msg.attach_size"/></th> --%>
											<%if(infoHynixConf){%>
											<th><s:message code="condition.itype"/></th>
											<th style="width:1px;"><s:message code="condition.sprob"/></th>
											<th style="width:90px;"><s:message code="condition.mlReason"/></th>
											<%}%>
											<th><s:message code="bodyview.viewerPreview"/></th>
											<th><s:message code="message.msg.pre_ext"/></th>
											<th><s:message code="message.body.image"/></th>
											<%if(infoHynixConf){%>
											<th><s:message code="condition.feedback"/></th>
											<th><s:message code="condition.feedbackDate"/></th>
											<%} %>
										</tr>
										<tr id="" size="" class="found differentExt">
											<td>
												<span class="attachName" attachname=""><span class="glyphicon glyphicon-paperclip" style="padding-right:5px;"></span></span>
												<span class="radioFeedback" ></span>
												<span class="glyphicon glyphicon-search attachText" style="padding-left:5px;cursor:pointer;" title="<s:message code="consent.attach"/> Text Viewer"></span>
												<span class="attachOcrText" style="padding-left:5px;cursor:pointer;" title="<s:message code="consent.attach"/> OCR Text Viewer">
														<img alt="" src="<c:url value="/img/ocr.png"/>" style="width: 25px;">
													</span>
											</td>
											<td style="text-align: right;">getAttachSize</td>
											<td style="text-align: center;"><span class="attachExt"><span class="glyphicon glyphicon-download-alt"></span>&nbsp;getAttachExt</span></td>
											<td style="text-align: center;" class="downloadBtn"><span style ="cursor"class="glyphicon glyphicon-download-alt downloadIcon"></span></td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- //파일정보 -->
				<!-- 패턴정보 -->
				<div class="row" id="patternDiv">
					<div class="col-lg-12">
						<div class="panel panel-default" id="">
							<div class="panel-heading body_toggle patternFold" style="padding:10px 12px 9px;">
								<s:message code="bodyview.info.pattern"/><span id="patternCntArea" class="blue02 fb600"></span>
								<div class="pull-right">
									<span></span>
								</div>
							</div>
							<div class="panel-body" style="display:none;">
								<div>
									<table class="subTable02 table-bordered" id="patternTable">
										<tr>
											<th colspan="2"><s:message code="common.msg.separator"/></th>
											<th colspan="2"><s:message code="bodyview.info.detect"/></th>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- //패턴정보 -->

				<div class="row" id="detailPatternDiv" style="display:none;">
					<div class="col-lg-12">
						<div class="panel panel-default" id="">
							<div class="panel-heading" style="padding:10px 12px 9px;">
								<s:message code="common.msg.detail.pattern"/>
								<div class="pull-right" style="position:relative;top:-7px;">
									<button class="btn05 body_selectBtn" id="hidePatternBtn" onclick="javascript:$('#detailPatternDiv').hide();"><s:message code="bodyview.hide"/></button>
								</div>
							</div>
							<div class="panel-body" id="detailArea" style="overflow: auto;padding-top:10px;">
							</div>
						</div>
					</div>
				</div>

				<!-- LLM AI 정보 -->
				<%if(isLlmEnabled){%>
				<div class="row" id="LLMDIV" >
					<div class="col-lg-12">
						<div class="panel panel-default">
							<div class="panel-heading" style="padding:10px 12px 9px;">
								AI
							</div>
							<div class="panel-body" id="LLMAREA" style="overflow: auto;padding-top:10px;">
								<button class="btn01" id="koreaBody"><i id="helpView2" class="fa fa-spinner" aria-hidden="true" style="display: none" ></i><img id="llmImg1" alt="" src="<c:url value="/img/ztree/AI2.gif"/>" width="23px;" height="23px;" style="margin-top: -6px!important;"><s:message code="llm.info.korea"/></button>
								<button class="btn01" id="summaryBody"><i id="helpView3" class="fa fa-spinner" aria-hidden="true" style="display: none" ></i><img id="llmImg2" alt="" src="<c:url value="/img/ztree/AI2.gif"/>" width="23px;" height="23px;" style="margin-top: -6px!important;"><s:message code="llm.info.keyword"/></button>
								<button class="btn01" id="contentBody"><i id="helpView4" class="fa fa-spinner" aria-hidden="true" style="display: none" ></i><img id="llmImg3" alt="" src="<c:url value="/img/ztree/AI2.gif"/>" width="23px;" height="23px;" style="margin-top: -6px!important;"> <s:message code="llm.info.summary"/></button>
								<%if(!isLlmSingle){%><button class="btn01" id="serviceBody"><i id="helpView5" class="fa fa-spinner" aria-hidden="true" style="display: none" ></i><img id="llmImg4" alt="" src="<c:url value="/img/ztree/AI2.gif"/>" width="23px;" height="23px;" style="margin-top: -6px!important;"></i> <s:message code="llm.info.body"/></button>	<%}%>
							</div>
						</div>
					</div>
				</div>
				<%}%>

				<!-- 본문내용 -->
				<div class="row" id="bodyDiv">
					<div class="col-lg-12">
						<div class="panel panel-default" id="emassBodyDiv">
							<div class="panel-heading " style="padding:10px 12px 9px;">
								<s:message code="bodyview.body.content"/>
								<div class="pull-right" style="position: relative;top:-7px;">
									<span class="select-xs body_selectBtn">
										<s:message code="common.msg.zoom"/> :
									</span>
									<button class="btn05 body_selectBtn font_size" id="large_txt">+</button>
									<button class="btn05 body_selectBtn font_size" id="small_txt">-</button>
									&nbsp;
									<span class="body_selectBtn"> <s:message code="bodyview.charset"/> : </span>
									<span class="select-xs">
											<select name="bodyEncoding" id="bodyEncoding" class="btn05">
												<option value=""><s:message code="common.msg.auto"/></option>
												<option value="utf-8">UTF-8</option>
												<option value="euc-kr">EUC-KR</option>
											</select>
										</span>
									<button class="btn05" id="copyBodyBtn"><i class="fa fa-clone fa-fw"></i> <s:message code="message.msg.copy.body"/></button>
								</div>
								<div id="bodyStrDiv" style="font-size:13px;padding-top:5px;">
									<span><s:message code="condition.body"/> <s:message code="bodyview.find.keyword"/> : </span>
									<span style="font-weight: bold;" class="blue02" id="bodyStr"></span>
								</div>
							</div>
							<div class="panel-body p12" style="padding:0;margin-bottom:70px !important;">
								<div id="emassBody" style="min-height: 150px;overflow-x:auto;width: 100%;display:inline;">
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- //본문내용 -->
			</div>
		</div>

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
			<div class="boxArea" style="overflow-x:hidden;overflow-y: auto; background-color:#f8f8f8;">
				<div id="emptyDiv" class="empty-dashboard-message subTit borradius" style=" padding: 16px; height:280px;">
					<h1 style="text-align:center;font-size:100px;color:#253f56;">
						<!--<i class="fa fa-exclamation-triangle" aria-hidden="true"></i>-->
						<img src="<c:url value="/img/icon/img_nodata02.png"/>" width="100" height="100">
					</h1>
					<h2><s:message code="bodyview.select.message"/></h2>
					<p class="txt_center bornone"><s:message code="bodyview.message.info"/></p>
				</div>
			</div>
		</div>
	</div>
	<!-- 사용자 정보-->
	<div id="userInfoDiv" style="">
		<div>
			<div style="float:left; margin-top:14px; margin-left:16px;">
				<img src="<c:url value="/img/person.png"/>" width="32px">
			</div>
			<div style="float:left;width:calc(100% - 65px);height:56px;padding-top:12px;padding-left:10px;">
				<div class="ellipsis" id="userNamePop" style="font-weight: bold;"></div>
				<div class="ellipsis" id="userEmailPop" style="word-break: break-word; font-size:12px;"></div>
			</div>
			<div style="clear:both;width:100%;padding:0px 10px 10px 10px; margin-top:-10px;">
				<div>
					<table style="table-layout: fixed;width:100%;" class="subTable02">
						<colgroup>
							<col width="85px">
							<col width="*">
						</colgroup>
						<tr>
							<th><s:message code="common.org.co"/></th>
							<td class="topline"><div class="ellipsis" id="userCoNmPop"></div></td>
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
							<td><div class="ellipsis" id="userIpPop"></div></td>
						</tr>
						<tr>
							<th><s:message code="common.msg.userid"/></th>
							<td><div id="userSabunPop"></div></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div class="modal" id="summaryModal">	<!-- modal -->
		<div class="modal-content">
			<div class="modalHead">
				<h2>본문 내용요약</h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div id="summaryContent"></div>
			</div>
		</div>
	</div>

	<!-- //사용자 정보-->
	<div id="imgPreviewDiv"></div>
	<div id="infoDiv" style="overflow-y:auto;display:none;">
		<div id="infoDivTextHeader">
			<i class="fa fa-stop-circle-o" aria-hidden="true"></i>
			<s:message code="common.msg.textdecode"/>(unescape)
		</div>
		<div id="infoDivText">
		</div>
	</div>
</div>
<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>
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

<%--<input type="hidden" id="msgPatterns" />--%>


</body>
<script type="text/javascript">
	var op_attach_save = '<%=op_attach_save%>';
	var op_body_save = '<%=op_body_save%>';
	var op_body_print = '<%=op_body_print%>';
	var mailUseFlag = <%=mailUseFlag%>;
	var adminEmail = '<%=adminEmail%>';

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
