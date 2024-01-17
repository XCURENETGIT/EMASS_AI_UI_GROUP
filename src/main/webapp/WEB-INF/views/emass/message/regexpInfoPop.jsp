<%@page import="com.xcurenet.common.util.locale.Prop"%>
<%@page import="com.xcurenet.emass.message.service.EmsPiVO"%>
<%@page import="java.util.List"%>
<%@page import="com.xcurenet.common.util.SpringContextUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%@page import="com.xcurenet.emass.message.service.EmsMessageService"%>
<%@ include file="/WEB-INF/fragments/popupScript.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	EmsMessageService emassService = SpringContextUtil.getBean(EmsMessageService.class);
	JSONObject param = Common.getParam ( request );
	String msgId = Common.nvl( param.get("msgId"));
	List<EmsPiVO> pattern =  emassService.getEmassPattern(msgId);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS AI - <s:message code="consent.attach"/> <s:message code="common.msg.information"/></title>
<style type="text/css">
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
table th {
	background-color: #eee;
	text-align: center;

	padding: 4px !important;
	line-height: 1.42857143;
	vertical-align: top;
}
table td {
	padding: 8px !important;
}
.boxArea {
	min-height: 0px;
}
</style>
<script type="text/JavaScript">
var msgId = '<%=msgId%>';
$(document).ready(function(){
	ui.onBody( 'content_body', 0, 0);
	$('#noSelectBtn').click(function(){ self.close();  });
	ui.off( 'content_body' );
});

function getEmassPatternDetail(obj, piId, type, attachName){
	var cnt = $(obj).text();
	if( cnt == 0) {
		$('#detectionCnt').text('');
		$('#detailArea').text('');
		return;
	}
	ui.get({
		url : 'getEmassPatternDetail.xcn',
		msgId : msgId,
		piId : piId,
		type : type,
		attachName : attachName,
		success : function(data, total) {
			if( data.length > 0){
				$('#detectionCnt').text(cnt+'<s:message code="common.msg.cnt"/>');
				var kwds = data[0].kwds.replaceAll(',', '<br/>');
				$('#detailArea').html(kwds);
			}else{
				$('#detectionCnt').text('');
				$('#detailArea').text('');
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
	
}
</script>
</head>
<body>

	<div class="xcn_container" style="min-width: 650px;">
		<div class="boxArea" >
			<div class="content_body">
				<div class="row p20">
					<h2><span class="bullet02"></span><s:message code="bodyview.info.pattern"/></h2>
					<div class="xcn_pop_btn">
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
					</div>
					<div>
						<div class="panel-default" id="">
							<div>
								<table class="mainTable table-bordered mat16" id="patternTable">
									<tr>
										<th colspan="2" style="vertical-align: middle;"><s:message code="common.msg.separator"/></th>
										<th colspan="2" style="vertical-align: middle;">검출정보</th>
									</tr>
									<%
										long piTotal = 0;
										for( int i=0; i < pattern.size(); i++){
											EmsPiVO pi = pattern.get(i);
											String type = Common.nvl(pi.getType());
											String attachName = Common.nvl(pi.getAttachName());
											String piType = "";
											if( Common.isEquals(pi.getType(), "S")) piType = Prop.propFormat("condition.subject", Common.getLocale(session));
											else if( Common.isEquals(pi.getType(), "B")) piType = Prop.propFormat("condition.body", Common.getLocale(session));
											else if( Common.isEquals(pi.getType(), "F")) piType = Prop.propFormat("condition.attach_name", Common.getLocale(session));
											else if( Common.isEquals(pi.getType(), "A")) piType = Prop.propFormat("consent.attach", Common.getLocale(session));
											else piType=Prop.propFormat("DATA_MONITOR.MESSAGE_INFO", Common.getLocale(session));

											String piId = Common.nvl(pi.getPiid());
											String piName = Common.nvl(pi.getPiName());
											if(Common.isEmpty(piName)) piName = Prop.propFormat("bodyview.info.pattern", Common.getLocale(session));
									%>
									<tr>
										<%if(Common.isOrEquals(pi.getType(), "A", "F")){ %>
										<td><%=piType%></td>
										<td style="word-break: break-word;"><%=Common.nvl(pi.getAttachName())%></td>
										<%}else{ %>
										<td colspan="2" style="text-align: center;"><%=piType%></td>
										<%} %>
										<td style="word-break: break-word;"><%=piName%></td>
										<td style="text-align: right;" class="borright_none"><a href="javascript:void(0);" style="text-decoration: underline;" onclick="getEmassPatternDetail(this,'<%=piId%>','<%=pi.getType()%>','<%=attachName%>');"><%=pi.getTotal() %></a></td>
									</tr>
									<%
											piTotal = pi.getTotal()+piTotal;
										} %>
									<tr>
										<th colspan="4" style="text-align: center;font-weight: bold;" class="blueBg bornone">전체<span class="blue fb600"> <%=piTotal %></span></th>
									</tr>
								</table>
							</div>
						</div>
						<div class="panel-default mat8 " >
							<div class="grayBg02" style="overflow: auto; min-height:200px; max-height:450px;">
								<div id="detailArea" class="txt_center mat32" style="vertical-align: middle;">
									<img src="../img/icon/img_nodata02.png"  class="mab8" alt=""><br/>
									<s:message code="common.select.pattern"/>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
<!-- old -->

	<iframe id="AttachDown" src="about:blank;" height="0" width="0" style="display: none;" ></iframe>

</body>
</html>