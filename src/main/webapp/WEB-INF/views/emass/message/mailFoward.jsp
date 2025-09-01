<%@page import="org.jsoup.nodes.Document"%>
<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.select.Elements"%>
<%@ page import="com.xcurenet.emass.message.service.EmsMessageService" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.SpringContextUtil" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.xcurenet.emass.message.service.EmsBodyVO" %>
<%@ page import="com.xcurenet.emass.message.service.EmsCreateMessage" %>
<%@ page import="com.xcurenet.emass.message.web.EmsMessageController" %>
<%@ page import="com.xcurenet.admin.service.AdminVO" %>
<%@ page import="com.xcurenet.admin.service.impl.AdminServiceImpl" %>
<%@ page import="com.xcurenet.emass.message.service.MessengerEdcGroupVO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	EmsMessageService emsMessageService = SpringContextUtil.getBean(EmsMessageService.class);
	EmsMessageController emsMessageController = SpringContextUtil.getBean(EmsMessageController.class);
	JSONObject param = Common.getParam ( request );
	String msgId = Common.nvl( param.get("msgId"));
	String xRootMtr = Common.nvl( param.get("xRootMtr"));
	String userCharset = Common.nvl( param.get("userCharset"));
	
	List<String> msgIds = new ArrayList<>();
	List<EmsBodyVO> emsBody = new ArrayList<>();
	List<String> emsBodyStr = new ArrayList<>();
	
	String bodyStr = "";
	String styleStr = "";
	
	if(Common.isNotEmpty(msgId) && Common.isEmpty(xRootMtr)) msgIds.add(msgId);
	else if(Common.isNotEmpty(xRootMtr)) msgIds = emsMessageService.getMsgIds(msgId,xRootMtr);
	
	int idx = 0;
	for(String id : msgIds) {
		emsBody.add(emsMessageService.getEmassBody(id, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession())));
		emsBodyStr.add(Common.nvl(new EmsCreateMessage(request).getHeaderMessage(id, emsMessageController.getBodyStrMasking(userCharset,emsBody.get(idx)), "N", Common.getLocale(request.getSession()), Common.getFirstAdminYn(request.getSession()), Common.getAdminId(request), Common.getAdminType(request.getSession()))));

		Document doc = Jsoup.parse(emsBodyStr.get(idx), Common.UTF8);
		Elements cssEl = doc.getElementsByTag("style");
		styleStr = cssEl.toString();
		Elements bodyEl = doc.getElementsByClass("container");
		bodyStr += (bodyEl.toString().replaceAll("class=\"container\"", "class=\"msg_container\""));
		idx++;
	}
	

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
<title>EMASS AI - <s:message code="common.msg.forward_mail"/></title>

<style type="text/css">
html, body{
	min-width:750px !important;
	overflow-x: auto;
	overflow-y: hidden; 
}
table td{
	padding:2px;
}
#messageContents .boxArea {
	padding: 5px !important;
}
.well.content_box {
	background-color: #fff;
}
.panel {border-radius: 0 !important;}
.panel-default>.panel-heading {background: #EEEFF2 !important;}
</style>

<script type="text/javascript">
var msgId = '<%=msgId%>';
var xRootMtr = '<%=xRootMtr%>';
var userCharset = '<%=userCharset%>';
var adminEmail = '<%=adminEmail%>';

$(document).ready(function(){

    
	/**
	 * 메일 수신자 및 참조 메일 수신자 선택
	 */
	$('#alarmToBtn').click(function(){
		fnOpenWindow('<c:url value="/ems/mailSearchPop.do"/>?type=to', 'mainWritePop', 900, 700, 'fix');
	});
	$('#alarmCCBtn').click(function(){
		fnOpenWindow('<c:url value="/ems/mailSearchPop.do"/>?type=cc', 'mainWritePop', 900, 700, 'fix');
	});
	$('#sendMailBtn').click(function(){
		var subject = $('#mail_subject').val();
		//var attachMsg = $('#mail_body').val();
		var body = $('#mail_body').val() + $('#messageContents')[0].innerHTML;
		var from = $('#sender_name').val();
		var to = $('#alarmTo').val();
		var cc = $('#alarmCC').val();
		
		if( subject == ''){
			alert('<s:message code="mail.message.require.subject"/>');
			return;
		}
		if( to == ''){
			alert('<s:message code="mail.message.require.receiver"/>');
			return;
		}
        $("#emassBody").html('');
        
		ui.confirmMsg('<s:message code="mail.message.sendmail"/>', '', '', function(rs){
			if(rs){
				ui.get({
					url : 'emassMailForward.xcn',
					msgId : msgId,
					xRootMtr: xRootMtr,
					userCharset : userCharset,
					subject : subject,
					body : body,
					from : from,
					to : to,
					cc : cc,
					success : function(data, total) {
						alert('<s:message code="mail.message.success"/>');
						self.close();
					},
					error : function(status, message) {
						ui.alertMsg(message);
					},
					complete : function() {
					}
				});
			}
		});
	});
	
	init();
});

function init(){
	$('#messageContents > div > div > div.boxArea > div > div:nth-child(1) > div > div.panel-heading').css('min-height','40px');
	$('#mail_subject').val("  FW: " + $('#subject')[0].innerText);
	$('#sender_name').val(adminEmail);
	$('#sender_email_addr').text(adminEmail);
	$('#messageContents > div > div > div.boxArea > div > div.row:first').addClass('col-lg-12');
}

</script>
</head>
<body class="mini-navbar msgBody" style="overflow-x: hidden; overflow-y: auto;">
	<!--<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="common.msg.forward_mail"/></span>
		</div>
	</header>-->
	<div class="row p8 grayBg" style="margin:0;">
		<div class="col-xs-10">
			<h2><s:message code="common.msg.forward_mail"/></h2>
		</div>
	</div>
	<div class="row top_space mat16">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					<div style="height: 20px;">
						<i class="fa fa-envelope" aria-hidden="true"></i> <s:message code="common.msg.forward_mail"/>
					</div>
				</div>
				<div class="panel-body text-md">
					<table style="width: 100%;">
						<tr>
							<td style="width: 110px;">
								<button type="button" class="btn btn-sm btn-default disabled" style="font-size:12px;width:100px;"><i class="fa fa-user" aria-hidden="true"></i>&nbsp;<s:message code="mail.sender"/></button>
								<input type="hidden" id="sender_name" name="sender_name">
							</td>
							<td id="sender_email_addr" style="padding-left:5px;">
							</td>
							<td rowspan="3" style="width: 80px;text-align: center;vertical-align: top;padding-top: 2px;">
								<button type="button" class="btn btn-sm btn-default" style="font-size:12px;width:100px;height:96px;" id="sendMailBtn"><i class="fa fa-share" aria-hidden="true"></i>&nbsp;<s:message code="mail.send"/></button>
							</td>
						</tr>
						<tr>
							<td>
								<button type="button" class="btn btn-sm btn-default" style="font-size:12px;width:100px;" id="alarmToBtn"><i class="fa fa-users" aria-hidden="true"></i>&nbsp;<s:message code="condition.to"/></button>
							</td>
							<td>
								<input type="text" name="alarmTo" id="alarmTo" style="width: 99%"/>
							</td>
						</tr>
						<tr>
							<td>
								<button type="button" class="btn btn-sm btn-default" style="font-size:12px;width:100px;" id="alarmCCBtn"><i class="fa fa-user-secret" aria-hidden="true"></i>&nbsp;<s:message code="condition.cc"/> </button>
							</td>
							<td>
								<input type="text" name="alarmCC" id="alarmCC" style="width: 99%"/>
							</td>
						</tr>
						<tr>
							<td style="text-align: center">
								<s:message code="condition.subject"/>
							</td>
							<td colspan="2">
								<input type="text" name="mail_subject" id="mail_subject" style="width: 100%;margin-top:5px;" maxlength="500"/>
							</td>
						</tr>
						<tr>
							<td style="text-align: center">
								<s:message code="common.msg.addContent"/>
							</td>
							<td colspan="2">
								<textarea rows="6" style="width:100%;margin-top:5px;resize: none;" id="mail_body"></textarea>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div id="messageContents" class="row" style="position: relative; top: -28px;">
		<%=bodyStr%>
		<%=styleStr%>
	</div>
	
	
	
	<%-- <div class="mini-navbar msgBody row" style="margin:0;">
		<div class="col-lg-12" id="messageContents">
			<%=bodyStr%>
		</div>
	</div> --%>
</body>
</html>