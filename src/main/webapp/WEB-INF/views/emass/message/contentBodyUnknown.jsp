<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<%@page import="com.xcurenet.common.util.config.Config"%>
<%
Map<String, Object> param = Common.getParamMap(request);
String msgid = Common.nvl(param.get("msgid"));
String searchKey = Common.nvl(param.get("searchKey"));
boolean mailUseFlag = Config.getBoolean("mail.forward.flag");
String op_attach_save = Operation.ATTACH_SAVE.getOperation();
String op_body_save = Operation.BODY_SAVE.getOperation();
String op_body_print = Operation.BODY_PRINT.getOperation();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
<title>EMASS PRO - <s:message code="OPERATION_MGMT.BODY_VIEW"/></title>



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
</style>
<script type="text/javascript">
var popup_msgId = '<%=msgid%>';
var popup_searchKey = '<%=searchKey%>';
$(document).ready(function(){
	if(popup_msgId!= '') {
		getMessage(popup_msgId, popup_searchKey);
	}else{
		$('#notSelectDiv').css("display", '');
	}
	
	$('.fold_clickTr').click(function(){
		if( $(this).find('.fold').hasClass('fold_on') ) $(this).find('.fold').removeClass('fold_on');
		else $(this).find('.fold').addClass('fold_on');
	});
	
	$('#testx').click(function(){
		console.log($(this).html());
	});
	
	$(document).on('click', '#nologUrlBtn', function(){
		var host_path = $('#hostDiv').text();
		if(popup_msgId!= '') {
			$('#noLogurl').val(host_path.substring(0, host_path.indexOf('/')));
			$("#urlPop").modal('show');
		}else{
			parent.openNologUrlPop(host_path);
		}
	});
});

var contentBody = {
	urlIpBlockPreview:'<s:message code="urlIpBlock.preview"/>',
	bodyviewSn:'<s:message code="bodyview.sn"/>',
	bodyviewCn:'<s:message code="bodyview.cn"/>',
	bodyviewId:'<s:message code="bodyview.id"/>',
	bodyviewPn:'<s:message code="bodyview.pn"/>',
	bodyviewFn:'<s:message code="bodyview.fn"/>',
	bodyviewEc:'<s:message code="bodyview.ec"/>',
	bodyviewEf:'<s:message code="bodyview.ef"/>',
	bodyviewInfoPattern:'<s:message code="bodyview.info.pattern"/>',
	unknown:'<s:message code="bodyview.unknown"/>',
	unknownFileName:'<s:message code="bodyview.unknown.filename"/>',
	user:'<s:message code="consent.user"/>',
	from:'<s:message code="condition.from"/>',
	to:'<s:message code="condition.to"/>',
	cc:'<s:message code="condition.cc"/>',
	bcc:'<s:message code="condition.bcc"/>'
};

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
	var startDt = $('#startdatepickerBody').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
	var endDt = $('#enddatepickerBody').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
	
	var url    = '<c:url value="/ems/participantInfoPop.do?xrootmtr='+xRootMtr+'&srcip='+srcip+'&usr_id='+usr_id+'&startDt='+startDt+'&endDt='+endDt+'"/>';
	var pop = fnOpenWindow(url, 'participant', 1015, 450, 'resize');
}
</script>
</head>
<body>
	<div id="periodBodyMenu">
		<div style="height:30px;background-color:#337ab7;color:#fff;padding-left:10px;line-height:30px;font-weight: bold;cursor:default;">
			<div style="float:left;width:200px;">
				<i class="glyphicon glyphicon-calendar"></i>&nbsp;<s:message code="filterInfo.period.setting"/>
			</div>
			<div style="float:right;padding-right:8px;">
				<span class="glyphicon glyphicon-remove" style="cursor:pointer;" id="periodBodyMenuCloseBtn"></span>
			</div>
		</div>
		<div style="width:100%;padding:10px 10px 0px 10px;">
			<div>
				<s:message code="common.messenger.msg1"/><br/>
				<s:message code="common.messenger.msg2"/><br/>
				<s:message code="common.messenger.msg3"/><br/>
			</div>
			<div  style="width:100%;">
				<div class="input-group" style="width:50px;font-weight: bold;">
					<s:message code="condition.period"/>
				</div>
				<div class="input-group">
					<div class="input-group date" id="startdatepickerBody" style="width:170px;">
						<input type="text" id="startDtAdd" class="input-sm form-control" />
						<span class="input-group-addon startDateBtnBody" style="padding: 0px 5px;"> <span class="glyphicon glyphicon-calendar"></span>
						</span>
					</div>
				</div>
				<span>~</span>
				<div class="input-group">
					<div class="input-group date" id="enddatepickerBody" style="width:170px;">
						<input type="text" id="endDtAdd" class="input-sm form-control"/>
						<span class="input-group-addon endDateBtnBody" style="padding: 0px 5px;"><span class="glyphicon glyphicon-calendar"></span></span>
					</div>
				</div>
			</div>
		</div>
		<div style="text-align: center;padding-bottom: 15px;">
			<button type="button" class="btn btn-sm btn-primary" accesskey="T" id="dateSearchBody" style="font-size:12px;" onclick="getGroupDetail();"><i class="glyphicon glyphicon-search"></i>&nbsp;<s:message code="common.messenger.all.view"/></button>
		</div>
	</div>
	<div class="msgBody">
		<div style="display: none;" id="buttonDiv">
			<div class="form-group form-inline not-dashed" style="float:left;padding:4px 0px 0 5px;" id="buttonArea">
				<button class ="msg_button" id="prevBtn"><s:message code="common.msg.prev"/></button>
				<button class ="msg_button" id="nextBtn"><s:message code="common.msg.next"/></button>
				<button class ="msg_button" id="saveBtn"><s:message code="common.msg.save"/></button>
				<button class ="msg_button" id="printBtn"><s:message code="common.msg.print"/></button>
				<button type="button" class="msg_button dropdown-toggle" data-toggle="dropdown">
					<s:message code="common.msg.addFunctions"/> <span class="caret"></span>
				</button>
				<ul class="dropdown-menu dropdown-menu-left" role="menu" style="min-width:100px;font-size:13px;left:178px;" id="additionalBtn">
					<li><a href="javascript:void(0);" id="usersInfoBtn"><s:message code="common.msg.userinfo"/></a></li>
					<li class="dropdown-divider"></li>
					<li><a href="javascript:void(0);" id="headerBtn"><s:message code="common.msg.headerInfo"/></a></li>
					<li class="dropdown-divider"></li>
					<li><a href="javascript:void(0);" id="originalBtn"><s:message code="common.msg.originalInfo"/></a></li>
					<li class="dropdown-divider"></li>
					<li><a href="javascript:void(0);" id="mailFowardBtn"><s:message code="common.msg.forward_mail"/></a></li>
					<li class="dropdown-divider"></li>
					<li><a href="javascript:void(0);" id="warnMailBtn"><s:message code="common.msg.warning_mail"/></a></li>
					<li class="dropdown-divider"></li>
					<li><a href="javascript:void(0);" id="msgIdBtn">ID</a></li>
				</ul>
				&nbsp;
				<button class ="msg_button" id="openBigContent"><s:message code="bodyview.window.new"/></button>
			</div>
		</div>
		<div class="contents" style="padding-top: 33px;">
			<div class="boxArea" id="msgDiv" style="display: none;">
				<div class="content_body" style="transform: translateZ(0);">
					<div class="row">
						<div class="col-lg-12">
							<div class="panel panel-default" id="subjectDiv">
								<div class="panel-heading" style="font-weight: bold;min-height:35px;">
									<div id="subject" class="pull-left" style="cursor:default;width:calc(100% - 260px);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;word-wrap:normal;line-height: 25px;" title="subject">
										
									</div>
									<div class="pull-right">
										<span class="svcnmSpan"></span>
									</div>
									<div id="subjectStrDiv" style="clear:both;font-size:12px;padding-top:5px;">
										<span><s:message code="condition.subject"/> <s:message code="bodyview.find.keyword"/> : </span>
										<span style="font-weight: bold;" id="subjectStr"></span>
									</div>
								</div>
								<div class="panel-body css-body">
									<div id="">
										<table id="infoTable" class="table table-bordered" style="margin-bottom:0;table-layout:fixed;min-width:500px;">
											<colgroup>
												<col style="width: 110px;">
												<col>
												<col style="width: 110px;">
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
												<td id="srcipTd"></td>
												<th><s:message code="condition.date"/></th>
												<td id="ctimeTd"></td>
											</tr>
											<tr id="destTr">
												<th><s:message code="condition.destination"/> IP</th>
												<td id="dstipTd"></td>
												<th><s:message code="filterInfo.size"/></th>
												<td id="bodySizeTd"></td>
											</tr>
											<tr id="userTr" class="fold_clickTr">
												<th class="fold_clickTh"><span class="fold_icon"></span><span class="trTitle"><s:message code="consent.user"/></span></th>
												<td class="fold_clickTd" id="testx">
													<div id="userDiv" class="fold">
													<span class="userInfoSpan" recvid="revcid" recvip=""></span>
													</div>
												</td>
												<th><s:message code="common.msg.account"/></th>
												<td id="userIdTd"></td>
											</tr>
											<tr id="fromTr" class="fold_clickTr">
												<th class="fold_clickTh"><span class="fold_icon"></span><span class="trTitle"><s:message code="condition.from"/></span></th>
												<td class="fold_clickTd" colspan="3">
													<div id="sendUserDiv" class="fold">
													</div>
												</td>
											</tr>
											
											<tr id="toTr" class="fold_clickTr">
												<th class="fold_clickTh"><span class="fold_icon"></span><span class="trTitle"><s:message code="condition.to"/></span></th>
												<td class="fold_clickTd" colspan="3">
													<div id="receiveUserDiv" class="fold">
													</div>
												</td>
											</tr>
											<tr id="ccTr" class="fold_clickTr">
												<th class="fold_clickTh"><span class="fold_icon"></span><span class="trTitle"><s:message code="condition.cc"/></span></th>
												<td class="fold_clickTd" colspan="3">
													<div id="ccUserDiv" class="fold">
													</div>
												</td>
											</tr>
											<tr id="bccTr" class="fold_clickTr">
												<th class="fold_clickTh"><span class="fold_icon"></span><span class="trTitle"><s:message code="condition.bcc"/></span></th>
												<td class="fold_clickTd" colspan="3">
													<div id="bccUserDiv" class="fold">
													</div>
												</td>
											</tr>
											<tr id="ipBusiNmTr">
												<th><s:message code="message.actual.business"/></th>
												<td colspan="3">
													<div id="ipBusiNmDiv">
														
													</div>
												</td>
											</tr>
											<tr id="hostTr">
												<th>HOST/Path <i id="nologUrlBtn" class="fa fa-chain-broken nologUrlBtn" aria-hidden="true"></i></th>
												<td colspan="3">
													<div id="hostDiv">
														
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
					
					<div id="fileDiv" class="row">
						<div class="col-lg-12">
							<div class="panel panel-default" id="">
								<div class="panel-heading body_toggle fileFold" >
									<i class="fa fa-file-code-o fa-fw"></i> <s:message code="bodyview.file_info"/><span id="fileCntArea"></span>
									<div class="pull-right" style="position: relative; bottom:1px;">
										<button class ="msg_button" accesskey="V" id="saveAttachBtn"><s:message code="bodyview.attach.save"/></button>
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
								<div class="panel-body css-body" style="display:none;">
									<div id="attachDiv">
										<table class="table table-bordered" id="fileTable">
											<colgroup>
												<col width="*">
												<col width="25%">
												<col width="20%">
											</colgroup>	
											<tr>
												<th><s:message code="bodyview.file.name"/></th>
												<%-- <th><s:message code="message.msg.attach_size"/></th> --%>
												<th><s:message code="bodyview.viewerPreview"/></th>
												<th><s:message code="message.msg.pre_ext"/></th>
												<!-- <th>저장</th> -->
											</tr>
											<tr id="" size="" class="found differentExt">
												<td>
													<span class="attachName" attachname=""><span class="glyphicon glyphicon-paperclip" style="padding-right:5px;"></span></span>
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
					<div class="row" id="patternDiv">
						<div class="col-lg-12">
							<div class="panel panel-default" id="">
								<div class="panel-heading body_toggle patternFold">
									<i class="fa fa-superpowers fa-fw"></i> <s:message code="bodyview.info.pattern"/><span id="patternCntArea"></span>
									<div class="pull-right">
										<span></span>
									</div>
								</div>
								<div class="panel-body css-body" style="display:none;">
									<div>
										<table class="table table-bordered" id="patternTable">
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
					<div class="row" id="detailPatternDiv" style="display:none;">
						<div class="col-lg-12">
							<div class="panel panel-default" id="">
								<div class="panel-heading">
									<i class="fa fa-superpowers fa-fw"></i> <s:message code="common.msg.detail.pattern"/>
									<div class="pull-right" style="position:relative;top:-2px;">
										<button class="msg_button body_selectBtn" id="hidePatternBtn" onclick="javascript:$('#detailPatternDiv').hide();"><s:message code="bodyview.hide"/></button>
									</div>
								</div>
								<div class="panel-body" id="detailArea" style="overflow: auto;padding-top:10px;">
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-12">
							<div class="panel panel-default" id="emassBodyDiv">
								<div class="panel-heading">
									<i class="fa fa-envelope-open-o fa-fw"></i> <s:message code="bodyview.body.content"/>
									<div class="pull-right" style="position: relative;top:-3px;">
										<span class="select-xs body_selectBtn">
											<s:message code="common.msg.zoom"/> : 
										</span>
										<button class="msg_button body_selectBtn font_size" id="large_txt">+</button>
										<button class="msg_button body_selectBtn font_size" id="small_txt">-</button>
										&nbsp;
										<span class="body_selectBtn"> <s:message code="bodyview.charset"/> : </span>
										<span class="select-xs">
											<select name="bodyEncoding" id="bodyEncoding" class="body_select body_selectBtn">
												<option value=""><s:message code="common.msg.auto"/></option>
												<option value="utf-8">UTF-8</option>
												<option value="euc-kr">EUC-KR</option>
											</select>
										</span>
										<button class="msg_button" id="copyBodyBtn"><i class="fa fa-clone fa-fw"></i> <s:message code="message.msg.copy.body"/></button>
									</div>
									<div id="bodyStrDiv" style="font-size:12px;padding-top:5px;">
										<span><s:message code="condition.body"/> <s:message code="bodyview.find.keyword"/> : </span>
										<span style="font-weight: bold;" id="bodyStr"></span>
									</div>
								</div>
								<div class="panel-body" style="padding:0;margin-bottom:70px !important;">
									<div id="emassBody" style="min-height: 150px;overflow-x:auto;width: 100%;display:inline;">
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row" id="OcrFileDiv">
						<div class="col-lg-12">
							<div class="panel panel-default" id="">
								<div class="panel-heading body_toggle" id="">
									<i class="fa fa-bar-chart-o fa-fw"></i><s:message code="bodyview.ocr.preview"/>
								</div>
								<div class="panel-body css-body">
									<div id="attachDiv">
										<table class="table table-bordered" id="ocrFileTable">
											<colgroup>
												<col width="200px">
												<col width="*">
											</colgroup>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
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
						<h1 style="text-align:center;font-size:100px;color:#288cb3;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i></h1>
						<h2><s:message code="bodyview.select.message"/></h2>
						<p><s:message code="bodyview.message.info"/></p>
					</div>
				</div>
			</div>
		</div>
		<div id="userInfoDiv" style="display:none;">
			<div>
				<div style="float:left;">
					<img src="<c:url value="/img/person.png"/>" width="64">
				</div>
				<div style="float:left;width:calc(100% - 65px);height:64px;padding-top:12px;padding-left:10px;">
					<div id="userNamePop" style="font-weight: bold;"></div>
					<div id="userEmailPop"></div>
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
								<td><div id="userCoNmPop"></div></td>
							</tr>
							<tr>
								<th><s:message code="common.org.busi"/></th>
								<td><div id="userBusiNmPop"></div></td>
							</tr>
							<tr>
								<th><s:message code="common.org.general"/></th>
								<td><div id="userSuborgNmPop"></div></td>
							</tr>
							<tr>
								<th><s:message code="common.org.dept"/></th>
								<td><div id="userDeptNmPop"></div></td>
							</tr>
							<tr>
								<th><s:message code="common.org.jikgub"/></th>
								<td><div id="userJikgubNmPop"></div></td>
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
</body>
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
