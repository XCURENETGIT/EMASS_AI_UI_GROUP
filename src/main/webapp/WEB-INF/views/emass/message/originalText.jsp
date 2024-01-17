<%@page import="com.itextpdf.text.log.SysoCounter"%>
<%@page import="com.xcurenet.common.util.locale.Prop"%>
<%@page import="com.xcurenet.emass.message.service.EmsHeaderVO"%>
<%@page import="com.xcurenet.common.detect.DetectCharset"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="com.xcurenet.emass.message.service.EmsBodyVO"%>
<%@ page import="com.xcurenet.emass.message.service.EmsMessageService" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String default_encoding = "EUC-KR";
	JSONObject param = Common.getParam ( request );
	String msgId = Common.nvl( param.get("msgId"));
	String type = Common.nvl(param.get("type"));

	WebApplicationContext wac = WebApplicationContextUtils.getWebApplicationContext(((HttpServletRequest) request).getSession().getServletContext());
	EmsMessageService emassService = wac.getBean(EmsMessageService.class);
	
	String body = "";
	String title = "";
	String no_data = "";
	if( Common.isEquals(type, "header")){
		title = Prop.propFormat("common.msg.header", Common.getLocale(session));
		EmsHeaderVO headerVo = emassService.getEmassHeader(msgId);
		if (headerVo == null || Common.isEmpty(headerVo.getHeader())){
			body = Prop.propFormat("common.msg.nocontent", Common.getLocale(session));
			no_data = "Y";
		}else{
			String charset = DetectCharset.getCharset(headerVo.getHeader());
			if (charset == null || (charset != "UTF-8" && charset != "EUC-KR")) charset = default_encoding;
			body = Common.toString(headerVo.getHeader(), charset);
		}

	}
	else if( Common.isEquals(type, "original")){
		title = Prop.propFormat("common.msg.original", Common.getLocale(session));
		EmsBodyVO emsBody = emassService.getEmassBody(msgId, Common.getFirstAdminYn(session), Common.getAdminType(session));
		if (emsBody == null || emsBody.getBody() == null){
			body = Prop.propFormat("common.msg.nocontent", Common.getLocale(session));
			no_data = "Y";
		}
		else{
			String charset = DetectCharset.getCharset(emsBody.getBody());
			if (charset == null || (charset != "UTF-8" && charset != "EUC-KR")) charset = default_encoding;
			body = Common.toString(emsBody.getBody(), charset);
		}
	}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS AI- <%=title %> <s:message code="message.msg"/> Viewer</title>
<style type="text/css">
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
xmp {
	word-wrap: break-word;white-space: pre-wrap;white-space: -moz-pre-wrap;white-space: -pre-wrap;white-space: -o-pre-wrap;word-break:break-all;
	font: 12px/1.6em "Lucida Grande", "DejaVu Sans", "Bitstream Vera Sans", Verdana, Arial, sans-serif;
}
</style>
<script type="text/javascript">
var type = '<%=type%>';
var msgId = '<%=msgId%>';
var no_data = '<%=no_data%>';
$(document).ready(function(){
	$('#saveBtn').click(function(){
		saveOriginalText( );
	});
	init();
	$('#noSelectBtn').click(function(){ self.close();  });
	Highlight();
});
function Highlight( ) {
	var bodyStr = nvl(opener.msgData.bodyStr);
	var bodyStrs = bodyStr.split(', ');
	if ( bodyStrs.length > 0 ) setBodyHighLight ( bodyStrs, 'K'); //검색어 하이라이트 처리
}
function setBodyHighLight( defaultText, type){
	var body_obj = $("xmp");
	for ( var i=0 ; i < defaultText.length ; i++ ) {
		if ( defaultText[i] == '' ) continue;
		$( body_obj ).highlight(defaultText[i], 'B'+type);
	}
}
jQuery.fn.highlight = function(pat, type) {
	function innerHighlight(node, pat, type) {
		pat = pat.trim();
		var skip = 0;
		if (node.nodeType == 3) {
			var pos = node.data.toUpperCase().indexOf(pat);
			if (pos >= 0) {
				var spannode = document.createElement('span');
				spannode.name='spnHighlight';
				if ( type.indexOf('K') > -1) {
					spannode.className = 'clsHighlightKwds';
				}
				else {
					spannode.className = 'clsHighlight';
				}
				if ( type.indexOf('B') > -1 ) {
					if ( type.indexOf('K') > -1) {
						spannode.style.backgroundColor = '#FFAD5B';
						spannode.style.color = '#000000';
						spannode.style.fontWeight = 'bold';
					} else {
						spannode.style.backgroundColor = '#13C7A3';
						spannode.style.color = '#000000';
						spannode.style.fontWeight = 'bold';
					}
				}

				var sbit = node.splitText( pos );
				sbit.splitText( pat.length );
				spannode.nodeValue = sbit.data;
				var sbitclone = sbit.cloneNode(true);
				spannode.appendChild(sbitclone);
				sbit.parentNode.replaceChild(spannode, sbit);
				skip = 1;
			}
		} else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
			var cnt = node.childNodes.length;
			if ( node.childNodes.length > 1000 ) cnt = 1000;
			for ( var i = 0; i < cnt; ++i) {
				i += innerHighlight(node.childNodes[i], pat, type);
			}
		}
		return skip;
	}
	return this.each(function() {
		innerHighlight(this, pat.toUpperCase(), type);
	});
};

function init(){
	if( no_data == 'Y') $('#saveBtn').prop('disabled', true);
}
function saveOriginalText( )
{
	var url = '';
	if( type == 'original') url =  '<c:url value="/getEmassOriginalBodyDown.xcn?msgId='+msgId+'"/>';
	else if( type == 'header') url = '<c:url value="/getEmassHeaderDown.xcn?msgId='+msgId+'"/>';
	
	try {
		MessageDown.location.href = url;
	} catch (e) {
		MessageDown.src = url;
	}
}

</script>
</head>
<body class="mini-navbar msgBody">
	<!--<header class="header p20">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="common.msg.view.original"/></span>
		</div>
	</header>-->

	<div class="xcn_container" style="min-width: 650px;">
		<div class="boxArea">
			<div class="content_body ">
				<div class="row p20 grayBg" style="margin:0;">
					<div class="col-xs-10">
						<h2 class="navi"><span id="code_title"></span><s:message code="common.msg.view.original"/></h2>
					</div>
					<div class="col-xs-2 text-right">
						<button type="button" class="btn btn-sm btn-default" id="saveBtn"><span class="glyphicon glyphicon-floppy-save"></span>&nbsp;<s:message code="common.msg.save"/></button>
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
					</div>
				</div>
				<div class="row" style="border-top: 1px solid #ddd; height: calc(100% - 40px);">
					<div class="col-xs-12" style="height: 100%;">
						<div class="panel-body text-md" style="min-height:500px;white-space: pre-wrap; -ms-word-break: break-all; -ms-word-wrap: break-word;"><xmp><%=body%></xmp></div>
						<iframe id="MessageDown" src="about:blank;" height="0" width="0" style="display: none;" ></iframe>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>