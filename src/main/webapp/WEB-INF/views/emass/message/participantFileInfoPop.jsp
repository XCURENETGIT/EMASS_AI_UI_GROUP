<%@page import="com.xcurenet.audit.service.Operation"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ include file="/WEB-INF/fragments/popupScript.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	JSONObject param = Common.getParam ( request );
	String xrootmtr = Common.nvl( param.get("xrootmtr"));
	String srcip = Common.nvl( param.get("srcip"));
	String usr_id = Common.nvl( param.get("usr_id"));
	String startDt = Common.nvl( param.get("startDt"));
	String endDt = Common.nvl( param.get("endDt"));
	String searchStr = Common.nvl( param.get("searchStr"));
	
	String op_attach_save = Operation.ATTACH_SAVE.getOperation();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LT - <s:message code="consent.attach"/> <s:message code="common.msg.information"/></title>

<style type="text/css">
html, body{
	min-width:600px;
}
.attachExt{
	cursor:pointer;
}
table th {
	background-color: #eee;
	text-align: center;
	border: 1px solid #ddd;
	padding: 8px;
	line-height: 1.42857143;
	vertical-align: top;
}
.differentExt{
	background-color:#FFE8E8;
}
.found td .attachName {
	cursor:pointer;
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
</style>
<script type="text/JavaScript">
var xrootmtr = '<%=xrootmtr%>';
var srcip = '<%=srcip%>';
var usr_id = '<%=usr_id%>';
var startDt = '<%=startDt%>';
var endDt = '<%=endDt%>';
var searchStr = '<%=searchStr%>';
var op_attach_save = '<%=op_attach_save%>';
$(document).ready(function(){
	$('#tbodyFile td').text(slickGridJS.searching);
	ui.onBody( 'content_body', 0, 0);
	
	$(document).on('click', '.attachName', function(){
		if( $(this).parents('tr').hasClass('notfound')) return;
		var msgId = $(this).parents('tr').attr('msgid');
		var attachHash = $(this).parents('tr').attr('id');
		var attachName = $(this).attr('attachname');
		var attachSize = Number( $(this).parents('tr').attr('size') );
		var attachUrl = '<c:url value="/getEmassAttachInfo4DownHash.xcn"/>?msgIds='+msgId+'&attachHash='+attachHash;
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
		var attachId = $(this).parents('tr').attr('id');
		var url = '<c:url value="/ems/attachText.do?msgId='+msgId+'&attachId='+attachId+'"/>';
		fnOpenWindow(url, 'attachText', 1050, 800, 'resize');
	});
	
	$(document).on('click', '.attachExt', function(){
		var txt = $(this).text();
		var msgId = $(this).parents('tr').attr('msgid');
		var attachHash = $(this).parents('tr').attr('id');
		var attachName = $(this).parents('tr').find('.attachName').text();
		var attachSize = Number( $(this).parents('tr').attr('size') );
		var attachUrl = '<c:url value="/getEmassAttachInfo4DownHash.xcn"/>?msgIds='+msgId+'&attachHash='+attachHash+'&prediction=Y';
		
		if( attachSize == 0 || attachSize == 'NaN' ) attachSize = 1;
		if(txt != '' && txt != 'unknown') attachName += '.'+txt;
		
		try {
			AttachDown.location.href = attachUrl;
		} catch (e) {
			AttachDown.src = attachUrl;
		}
	});
	
	$(document).on('click', '.downloadIcon', function(){
		var msgId = $(this).parents('tr').attr('msgid');
		var attachHash = $(this).parents('tr').attr('id');
		var attachName = $(this).parents('tr').find('.attachName').text();
		var attachSize = Number( $(this).parents('tr').attr('size') );
		var attachUrl = '<c:url value="/getEmassAttachInfo4DownHash.xcn"/>?msgIds='+msgId+'&attachHash='+attachHash;
		
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
	$(document).on('click', '#saveAttachBtn', function(){
		var downloadFlag = false;
		$('.downloadIcon').each ( function ( i, item ) {
			var attachHash = $(this).parents('tr').attr('id');
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
			var msgId = $(this).parents('tr').attr('msgid');
			msgIds.push(msgId);
		});

		var attachUrl = '<c:url value="/getEmassAttachInfo4DownHash.xcn"/>?msgIds='+msgIds.join(',');
		try {
			AttachDown.location.href = attachUrl;
		} catch (e) {
			AttachDown.src = attachUrl;
		}
	});
	ui.off( 'content_body' );
	
	getParticipantFileList();
});

function getParticipantFileList(){
	if(xrootmtr == ''){
		getFileList( [] );
		return;
	}
    let searchParam = {
        xRootMtr : xrootmtr,
        srcip : srcip,
        usr_id : usr_id,
        startDt: startDt,
        endDt: endDt,
        searchStr: searchStr,
        attachYn : 'Y'
    }
	
	ui.get({
		url : 'getMessengerGroupAttachList.xcn',
        searchParam : JSON.stringify(searchParam),
		success : function(data, total) {
			getFileList(data);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			
		}
	});
}

function getFileList( data ) {
	var str = '';
	for (var i = 0; i < data.length; i++) {
		str += '<tr msgid="'+data[i].msgid+'" id="'+data[i].attachhash+'" size="'+data[i].attachsize+'" class="found">';
		str += '	<td><span class="attachName" attachname='+data[i].attachname+'><span class="glyphicon glyphicon-paperclip" style="padding-right: 5px;"></span>' + data[i].attachname + '</span>';
		str += '	</td>';
		str += '	<td><span>' + changeHtml(data[i].sender) + '</span></td>';
		str += '	<td style="text-align: center;"><span>' + getDateFormat(data[i].ctime) + '</span></td>';
		str += '	<td style="text-align: right;"><span>' + convertFileSize(data[i].attachsize) + '</span></td>';
		str += '	<td style="text-align: center;"><span class="attachExt"><span class="glyphicon glyphicon-download-alt"></span>&nbsp;' + data[i].attachtype + '</span></td>';
		str += '	<td style="text-align: center;"><span class="glyphicon glyphicon-download-alt downloadIcon"></span></td>';
		str += '</tr>';
	}
	if(data.length ==0 ){
		str += '<tr>';
		str += '	<td colspan="6"><s:message code="custom.msg.noData"/></td>';
		str += '</tr>';
	}
	
	$('#tbodyFile').html( str );
}

function changeHtml(str){
	return str.replaceAll('<', '&lt;').replaceAll('>', '&gt;');
}
</script>
</head>
<body style="width: 100%; padding: 20px;min-width:600px;">
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default" id="">
				<div class="panel-heading">
					<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="bodyview.file_info"/>
					<div class="pull-right" style="position: relative;top:-6px;">
						<button type="button" class="btn btn-sm btn-default" id="saveAttachBtn"><span class="glyphicon glyphicon-floppy-save"></span>&nbsp;<s:message code="bodyview.attach.save"/></button>
					</div>
				</div>
				<div class="panel-body">
					<div id="attachDiv">
						<table class="table table-bordered">
							<colgroup>
								<col width="*">
								<col width="20%">
								<col width="16%">
								<col width="10%">
								<col width="15%">
								<col width="13%">
							</colgroup>	
							<tr>
								<th><s:message code="bodyview.file.name"/></th>
								<th><s:message code="message.msg.from"/></th>
								<th><s:message code="message.msg.fromDate"/></th>
								<th style="text-align: center;"><s:message code="message.msg.attach_size"/></th>
								<th style="text-align: center;"><s:message code="message.msg.pre_ext"/></th>
								<th style="text-align: center;"><s:message code="common.msg.download"/></th>
							</tr>
							<tbody id="tbodyFile">
								<tr>
									<td colspan="6"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
<iframe id="AttachDown" src="about:blank;" height="0" width="0" style="display: none;" ></iframe>
</body>
</html>