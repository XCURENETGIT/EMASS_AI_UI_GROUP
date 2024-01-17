<%@page import="com.xcurenet.audit.service.Operation"%>
<%@page import="com.xcurenet.emass.message.service.EmsAttachVO"%>
<%@page import="java.util.List"%>
<%@page import="com.xcurenet.common.util.SpringContextUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%@page import="com.xcurenet.emass.message.service.EmsMessageService"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/fragments/messageCss.jsp"%>
<%@ include file="/WEB-INF/fragments/messageJs.jsp"%>
<%@ include file="/WEB-INF/fragments/messageScript.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	EmsMessageService emassService = SpringContextUtil.getBean(EmsMessageService.class);
	JSONObject param = Common.getParam ( request );
	String msgId = Common.nvl( param.get("msgId"));
	String searchKey = Common.nvl ( param.get ( "searchKey" ) );
	String noFiles = "";
	boolean consentFlag = false;
	List<EmsAttachVO> files = emassService.getEmassAttachInfoConsent(msgId, Common.getFirstAdminYn(session), Common.getAdminType(session));
	if (files == null || files.size() == 0){
		noFiles = "Y";
	}else{
		consentFlag = files.get(0).isConsentFlag();
	}
	
	String op_attach_save = Operation.ATTACH_SAVE.getOperation();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS AI - <s:message code="consent.attach"/> <s:message code="common.msg.information"/></title>

<style type="text/css">
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
.attachExt{
	cursor:pointer;
}
/*
.boxArea {
	min-height: 0px;
}
table th {
	background-color: #eee;
	text-align: center;
	border: 1px solid #ddd;
	padding: 8px;
	line-height: 1.42857143;
	vertical-align: top;
	font-size:13px;
}
.differentExt{
	background-color:#FFE8E8;
}
.found td .attachName {
	cursor:pointer;
	text-decoration: underline;
}
.found td .attachName:hover {
	text-decoration: underline;
}
.notfound td .attachName {
	text-decoration:line-through;
	cursor:default;
}
.found .attachExt, .found .downloadBtn{
	cursor:pointer;
}
.attachName:hover{
	color:#0A246A;
}
.downloadIcon{
	cursor:pointer;
}
.ocr_img {
	background-image: url('<c:url value="/img/ocr1.png"/>');
	background-size: 120px 120px;
}

.row {padding:0; margin:0;}
h2 {padding:0; margin:0;}
#attachDiv table th{
	font-weight: normal;
	height: 26px;
	line-height: 26px;
	padding:1px;
	border-top: 1px solid #a9b1c2;
	border-bottom: 1px solid #cdc9c4;
	border-radius: 0px;
	font-weight: bold;
}
#attachDiv table td{
	height: 26px;
	line-height: 26px;
	padding:1px 8px;
	border-right: 1px solid #ECEAE9;
	border-bottom: 1px solid #ECEAE9;
	vertical-align: middle;
}
#attachDiv table th:last-child{
	border-right: none;
}
#attachDiv table td:last-child{
	border-right: none;
}
#attachDiv tr:nth-child(even){
	background-color: #FAFAFA;
	border-bottom: 1px solid #ECEAE9;
}
#attachDiv tr:nth-child(odd){
	background-color: #FFF;
	border-bottom: 1px solid #ECEAE9;
}
div#imgPreviewDiv{position:absolute; display:none; text-align: left;z-index: 99999;border: 1px solid #555;background-color: #fff;}

*/
</style>
<script type="text/JavaScript">
var searchkey = '<%=searchKey%>';
var msgId = '<%=msgId%>';
var op_attach_save = '<%=op_attach_save%>';
$(document).ready(function(){
	ui.onBody( 'content_body', 0, 0);

	$('#noSelectBtn').click(function(){ self.close();  });

	$(document).click(function(){
		$('#imgPreviewDiv').hide();
	});
	
	$(document).on('mouseover', '.attachName', function(){
		filePreviewEv(this);
	});
	
	$(document).on('mouseover', '#imgPreviewDiv, #fullSizeOverlay', function(){
		$('#fullSizeOverlay').show();
	});
	
	$(document).on('mouseout', '#fullSizeOverlay', function(){
		$('#fullSizeOverlay').hide();
	});
	
	$(document).on('click', '#imgPreviewDiv', function(){
		fullSize(this);
	});
	
	$(document).on('click', '.attachName', function(){
		if(adminMenu != "ALL" && ( adminMenu.indexOf("AS") < 0 || adminMenu.indexOf("CS") < 0 )) {
			alert('<s:message code="admin.auth.alert"/>');
			return;
		}
		if( $(this).parents('tr').hasClass('notfound')) {
			alert('<s:message code="message.message.notfound.attach"/>');
			return;
		}
		
		var attachId = $(this).parents('tr').attr('id');
		var attachName = $(this).attr('attachname');
		var attachSize = Number( $(this).parents('tr').attr('size') );
		var attachUrl = '<c:url value="/downEmassAttach.xcn"/>?msgId='+msgId+'&attachId='+attachId;
		if ( attachSize == 0 || attachSize == 'NaN' ) attachSize = 1;

		try {
			AttachDown.location.href = attachUrl;
		} catch (e) {
			AttachDown.src = attachUrl;
		}

		var information = '[<s:message code="bodyview.attach.save"/>-<s:message code="bodyview.file.name"/>]'+enter;
		information += '<s:message code="common.msg.msgid"/> : '+msgId + enter;
		information += '<s:message code="bodyview.file.name"/> : '+attachName + enter
		insertAudit(op_attach_save, information);
	});
	
	$(document).on('click', '.attachText', function(){
		if(adminMenu != "ALL" && adminMenu.indexOf("DV") < 0 ) {
			alert('<s:message code="admin.auth.alert"/>');
			return;
		}
		var attachId = $(this).parents('tr').attr('id');
		var url = '<c:url value="/ems/attachText.do?msgId='+msgId+'&attachId='+attachId+'&searchKey=' + encodeURI(searchkey)+'"/>';
		fnOpenWindow(url, 'attachText', 1050, 800, 'resize');
	});
	
	$(document).on('click', '.attachOcrText', function(){
		if(adminMenu != "ALL" && adminMenu.indexOf("DV") < 0 ) {
			alert('<s:message code="admin.auth.alert"/>');
			return;
		}
		var attachId = $(this).parents('tr').attr('id');
		var url = '<c:url value="/ems/attachText.do?msgId='+msgId+'&attachId='+attachId+'&searchKey=' + encodeURI(searchkey)+'&ocrYn=Y"/>';
		fnOpenWindow(url, 'attachText', 1050, 800, 'resize');
	});
	
	$(document).on('click', '.attachExt', function(){
		if(adminMenu != "ALL" && adminMenu.indexOf("AS") < 0 && adminMenu.indexOf("CS") < 0) {
			alert('<s:message code="admin.auth.alert"/>');
			return;
		}
		var txt = $(this).text();
		var attachId = $(this).parents('tr').attr('id');
		var attachName = $(this).parents('tr').find('.attachName').text();
		var attachSize = Number( $(this).parents('tr').attr('size') );
		var attachUrl = '<c:url value="/downEmassAttach.xcn"/>?msgId='+msgId+'&attachId='+attachId+'&prediction=Y';
		if( attachSize == 0 || attachSize == 'NaN' ) attachSize = 1;
		if(txt != '' && txt != 'unknown') attachName += '.'+txt;
		
		try {
			AttachDown.location.href = attachUrl;
		} catch (e) {
			AttachDown.src = attachUrl;
		}
	});
	
	$(document).on('click', '.downloadIcon', function(){
		if(adminMenu != "ALL" && adminMenu.indexOf("AS") < 0 && adminMenu.indexOf("CS") < 0) {
			alert('<s:message code="admin.auth.alert"/>');
			return;
		}
		var attachId = $(this).parents('tr').attr('id');
		var attachName = $(this).parents('tr').find('.attachName').text();
		var attachSize = Number( $(this).parents('tr').attr('size') );
		var attachUrl = '<c:url value="/downEmassAttach.xcn"/>?msgId='+msgId+'&attachId='+attachId;
		if ( attachSize == 0 || attachSize == 'NaN' ) attachSize = 1;
		
		try {
			AttachDown.location.href = attachUrl;
		} catch (e) {
			AttachDown.src = attachUrl;
		}
	});
	$(document).on('click', '#saveAttachBtn', function(){
		if(adminMenu != "ALL" && adminMenu.indexOf("AS") < 0 && adminMenu.indexOf("CS") < 0) {
			alert('<s:message code="admin.auth.alert"/>');
			return;
		}
		var attachUrl = '<c:url value="/downEmassAttach.xcn"/>?msgId='+msgId;
		try {
			AttachDown.location.href = attachUrl;
		} catch (e) {
			AttachDown.src = attachUrl;
		}
	});
	ui.off( 'content_body' );
});

/**
 * 이미지 전체 화면으로 보기
 */
function fullSize( obj )
{
	var imgUrl = $(obj).attr('url');
	var fileName = $(obj).attr('filename');
	
	var url = contextRoot + '/ems/imgFullsize.do';
	
	var winObj = fnOpenWindow('about:blank', "fullSize", 700, 500, "resize" );
	
	document.imageForm.imgUrl.value = imgUrl;
	document.imageForm.fileName.value = fileName;
	document.imageForm.target = "fullSize";
	document.imageForm.action = url;
	document.imageForm.submit();
	winObj.focus();
}

/**
 * 이미지 미리보기 이벤트 발생
 */
function filePreviewEv( obj )
{
	var fileName = $(obj).attr('attachname');
	var str_loc  = fileName.lastIndexOf(".");
	var fileExt = fileName.substring(str_loc+1);
	fileExt = fileExt.toLowerCase( );
	if ( fileExt == "jpg" || fileExt == "jpeg" || fileExt == "gif" || fileExt == "png" || fileExt == "bmp" )
	{
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
</script>
</head>
<body>

<div class="xcn_container" style="min-width: 650px;">
	<div class="boxArea" style="min-height:inherit;">
		<div class="content_body">
			<div class="row p20">
				<h2><span class="bullet02"></span><s:message code="bodyview.file_info"/></h2>
				<div class="xcn_pop_btn">
					<%if( consentFlag ){ %>
					<button type="button" class="btn btn-sm btn-default" accesskey="V" id="saveAttachBtn"><span class="glyphicon glyphicon-floppy-save"></span>&nbsp;<s:message code="bodyview.attach.save"/></button>
					<%} %>
					<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
				</div>
				<div class="mat16" style="height: 100%;">
					<div id="attachDiv">
						<table class="subTable table">
							<colgroup>
								<col width="*">
								<col width="15%">
								<col width="13%">
								<col width="20%">
								<col width="13%">
							</colgroup>
							<tr>
								<th><s:message code="bodyview.file.name"/></th>
								<th style="text-align: center;"><s:message code="bodyview.viewerPreview"/></th>
								<th style="text-align: center;"><s:message code="message.msg.attach_size"/></th>
								<th style="text-align: center;"><s:message code="message.msg.pre_ext"/></th>
								<th style="text-align: center;"><s:message code="common.msg.download"/></th>
							</tr>
							<%
								for( int i=0; i < files.size(); i++){
									EmsAttachVO file = files.get(i);
									boolean checkExt = false;
									String [] ext = Common.toArray(file.getAttachName(), ".");
									if( ext.length > 1 && Common.isEquals((file.getAttachExt()).toLowerCase(), (ext[ext.length-1]).toLowerCase() )) checkExt = true;
							%>
							<tr id="<%=file.getAttachId()%>" size="<%=file.getAttachSize()%>" class="<%=(Common.isEmpty(file.getAttachPath())==true ? "notfound" : "found")%> <%=checkExt ? "" : "differentExt" %>" >
								<td>
									<span style="padding-right:5px;" class="attach_<%=file.getAttachExt() %> attach_file_img"></span>
									<span class="<%= (file.isConsentFlag() ? "attachName" : "") %>" attachname="<%=file.getAttachName()%>">
											<%=file.getAttachName()%>
										</span>
								</td>
								<td style="text-align: center;">
									<%if( Common.isEquals(file.getOcrYn(), "Y") && file.isConsentFlag()){ %>
									<img src="<c:url value="/img/view.png"/>"style="width: 15px;"/>
									<span class="attachOcrText" style="padding-left:5px; cursor:pointer; text-decoration: underline;" title="<s:message code="consent.attach"/> OCR Text Viewer">
											<s:message code="urlIpBlock.preview"/>
										</span>
									<%}%>
									<%if( Common.isNotEmpty(file.getAttachTextPath()) && file.isConsentFlag()){ %>
									<img src="<c:url value="/img/text.png"/>"style="width: 15px;"/>
									<span class="attachText" style="padding-left:5px; cursor:pointer; text-decoration: underline;" title="<s:message code="consent.attach"/> Text Viewer">
											<s:message code="urlIpBlock.preview"/>
										</span>
									<%}%>
								</td>

								<td style="text-align: right;"><%=Common.convertFileSize(file.getAttachSize())%></td>
								<td style="text-align: center;">
										<span class="<%= (file.isConsentFlag() ? "attachExt" : "") %>">
										<%if(file.isConsentFlag()){%>
											<span class="glyphicon glyphicon-download-alt"></span>&nbsp;<%=file.getAttachExt()%><%=Common.isEquals(file.getAttachExt(), "unknown") ? "(txt)" : ""%>
										<%}%>
										</span>
								</td>
								<td style="text-align: center;"><span class="glyphicon glyphicon-download-alt <%= (file.isConsentFlag() ? "downloadIcon" : "") %>"></span></td>
							</tr>
							<%} %>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- old
	<div id="imgPreviewDiv"></div>
	<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="bodyview.file_info"/></span>
		</div>
	</header>
	<div class="xcn_container" style="min-width: 650px;">
		<div class="boxArea" style="min-height:inherit;">
			<div class="content_body">
				<div class="row">
					<div class="col-xs-12 text-right">
						<%if( consentFlag ){ %>
							<button type="button" class="btn btn-sm btn-default" accesskey="V" id="saveAttachBtn"><span class="glyphicon glyphicon-floppy-save"></span>&nbsp;<s:message code="bodyview.attach.save"/></button>
						<%} %>
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="attachDiv">
							<table class="table table-bordered">
								<colgroup>
									<col width="*">
									<col width="15%">
									<col width="13%">
									<col width="20%">
									<col width="13%">
								</colgroup>	
								<tr>
									<th><s:message code="bodyview.file.name"/></th>
									<th style="text-align: center;"><s:message code="bodyview.viewerPreview"/></th>
									<th style="text-align: center;"><s:message code="message.msg.attach_size"/></th>
									<th style="text-align: center;"><s:message code="message.msg.pre_ext"/></th>
									<th style="text-align: center;"><s:message code="common.msg.download"/></th>
								</tr>
								<%
								for( int i=0; i < files.size(); i++){
									EmsAttachVO file = files.get(i);
									boolean checkExt = false;
									String [] ext = Common.toArray(file.getAttachName(), ".");
									if( ext.length > 1 && Common.isEquals((file.getAttachExt()).toLowerCase(), (ext[ext.length-1]).toLowerCase() )) checkExt = true;
								%>
								<tr id="<%=file.getAttachId()%>" size="<%=file.getAttachSize()%>" class="<%=(Common.isEmpty(file.getAttachPath())==true ? "notfound" : "found")%> <%=checkExt ? "" : "differentExt" %>" >
									<td>
										<span style="padding-right:5px;" class="attach_<%=file.getAttachExt() %> attach_file_img"></span>
										<span class="<%= (file.isConsentFlag() ? "attachName" : "") %>" attachname="<%=file.getAttachName()%>">
											<%=file.getAttachName()%>
										</span>
									</td>
									<td style="text-align: center;">
									<%if( Common.isEquals(file.getOcrYn(), "Y") && file.isConsentFlag()){ %>
										<img src="<c:url value="/img/view.png"/>"style="width: 15px;"/>
										<span class="attachOcrText" style="padding-left:5px; cursor:pointer; text-decoration: underline;" title="<s:message code="consent.attach"/> OCR Text Viewer">
											<s:message code="urlIpBlock.preview"/>
										</span>
									<%}%>
									<%if( Common.isNotEmpty(file.getAttachTextPath()) && file.isConsentFlag()){ %>
									<img src="<c:url value="/img/text.png"/>"style="width: 15px;"/>
										<span class="attachText" style="padding-left:5px; cursor:pointer; text-decoration: underline;" title="<s:message code="consent.attach"/> Text Viewer">
											<s:message code="urlIpBlock.preview"/>
										</span>
									<%}%>
									</td>
									
									<td style="text-align: right;"><%=Common.convertFileSize(file.getAttachSize())%></td>
									<td style="text-align: center;">
										<span class="<%= (file.isConsentFlag() ? "attachExt" : "") %>">
										<%if(file.isConsentFlag()){%>
											<span class="glyphicon glyphicon-download-alt"></span>&nbsp;<%=file.getAttachExt()%><%=Common.isEquals(file.getAttachExt(), "unknown") ? "(txt)" : ""%>
										<%}%>
										</span>
									</td>
									<td style="text-align: center;"><span class="glyphicon glyphicon-download-alt <%= (file.isConsentFlag() ? "downloadIcon" : "") %>"></span></td>
								</tr>
								<%} %>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>-->
	<iframe id="AttachDown" src="about:blank;" height="0" width="0" style="display: none;" ></iframe>
	<form name="imageForm" method="post" target="">
		<input type="hidden" name="imgUrl">
		<input type="hidden" name="fileName">
	</form>
</body>
</html>