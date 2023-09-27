<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.xcurenet.emass.message.service.EmsKeywordVO"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%@page import="com.xcurenet.emass.message.service.EmsMessageService"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="com.xcurenet.emass.message.service.EmsAttachTextVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	JSONObject param = Common.getParam ( request );
	String msgId = Common.nvl( param.get("msgId"));
	String xRootMtr = Common.nvl( param.get("xRootMtr"));
	String userCharset = Common.nvl( param.get("userCharset"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LTH - <s:message code="common.msg.warning_mail"/></title>
<%@ include file="../../base.jsp"%>
<style type="text/css">
html, body{
	min-width:600px !important;
	overflow-x: auto;
	overflow-y: hidden; 
}
table td{
	padding:2px;
}

</style>

<script type="text/javascript">
var msgId = '<%=msgId%>';
var xRootMtr = '<%=xRootMtr%>';
var userCharset = '<%=userCharset%>';
var adminEmail = '${_USERCREDENTIAL_.adminEmail}';
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
		var body = $('#mail_body').val();
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
		ui.confirmMsg('<s:message code="mail.message.sendmail"/>', '', '', function(rs){
			if(rs){
				ui.get({
					url : 'emassWarningMail.xcn',
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
	$('#sender_name').val(adminEmail);
	$('#sender_email_addr').text(adminEmail);
}

</script>
</head>
<body class="mini-navbar msgBody" style="overflow: auto;">
	<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="common.msg.warning_mail"/></span>
		</div>
	</header>
	<div class="row top_space" style="margin:0;">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					<div style="height: 20px;">
						<i class="fa fa-envelope" aria-hidden="true"></i> <s:message code="common.msg.warning_mail"/>
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
								<s:message code="condition.body"/> 
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
</body>
</html>