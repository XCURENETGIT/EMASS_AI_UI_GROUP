<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/popupScript.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS AI - <s:message code="mail.mgnt.form.mail"/></title>
<style>
	body {
		overflow: hidden;

	}
.modal-body {
	padding-top: 5px;
}

/*	#mailPopForm{
		position: absolute;
		top: 120px;
		z-index: 999;
		left: 305px;
		border: 1px solid #ccc;
		width: 400px;
		height:500px;
	}*/


</style>
<script type="text/javascript">
var searchFlag=false;
$(document).ready(function(){
	$('#startDatePicker').datetimepicker({
		format: 'YYYY-MM-DD',
		locale: 'ko',
		defaultDate: moment(new Date())
	});
	
	$('#endDatePicker').datetimepicker({
		format: 'YYYY-MM-DD',
		locale: 'ko',
		defaultDate: moment(new Date())
	});

	$('#searchBtn').click(function(){ getData(); });
	$('#searchStr').enter(function(){ getData(); });
	
	$('#insertBtn').click(function(){
		$("#mailFormPop").modal('show');
		$('#mailFormPop').attr('mode','insert');
		$('#mailFormPop input[type=text], #mailFormPop textarea').val('').prop('disabled',false);
		setTimeout(function(){
			$("#formSubjectSel").focus();
		}, 500);
	});
	
	$('#formSubjectSel').change(function(){
		var formSubject = $('#formSubject').val();
		formSubject += $('#formSubjectSel option:selected').val();
		$('#formSubject').val(formSubject);
		$('#formSubjectSel').val('');
	});
	
	$('#formContentSel').change(function(){
		var formContent = $('#formContent').val();
		formContent += $('#formContentSel option:selected').val();
		$('#formContent').val(formContent);
		$('#formContentSel').val('');
	});
	
	$('.savePopBtn').click(function(){
		insertMailForm();
	});
	
	$('#deleteBtn').click(function(){
		var rowdata = grid.getSelectedRows();
		var formSeqs = grid.getSelectedKey('formSeq');
		if( formSeqs == '' ) {
			ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
			return;
		}
		var subjects = grid.getSelectedKey('formSubject');
		ui.confirmMsg( '<s:message code="common.msg.confirm.deleteitem" arguments="'+subjects+'" argumentSeparator="|"/>', '', '', function(rs){
			if(rs){
				grid.on();
				ui.get({
					url : 'deleteMailForm.xcn',
					deleteData : JSON.stringify(rowdata),
					formSeqs : formSeqs.join(','),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.deleted"/>');
						getData ( );
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						grid.off();
					}
				});
			}
		});
	});
	
	getData();
});

/*
 * 운용자 추가
 */
function insertMailForm(){
	if( $('#formSubject').val().ltrim().rtrim() == '' ) {
		ui.alertMsg('<s:message code="mail.message.select.form_subject"/>');
		$('#formSubjectSel').focus();
		return;
	}
	if( $('#formContent').val().ltrim().rtrim() == '' ) {
		ui.alertMsg('<s:message code="mail.message.select.form_content"/>');
		$('#formContentSel').focus();
		return;
	}
	
	var mode = $('#mailFormPop').attr('mode');
	var message = mode=='insert' ? '<s:message code="common.msg.add"/>' : '<s:message code="common.msg.modify"/>';
	var msg_str = mode=='insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
	ui.confirmMsg(msg_str, '', '', function(rs){
		if(rs){
			grid.on();
			ui.post({
				url 		: mode=='insert' ? 'insertMailForm.xcn' : 'updateMailForm.xcn',
				data		: $('#mailPopForm').serializeAll(),
				success		: function(data, total) {
					$('#mailFormPop').modal('hide');
					ui.alertMsg('<s:message code="common.msg.saved"/>');
					getData ( );
				},
				error		: function(status, message) {
					ui.alertMsg(message);
				},
				complete	: function() {
					grid.off();
				}
			});
		}
	});
}

/*
 * 알람 메일 서식 목록 조회
 */
function getData() {
	if(searchFlag) return;
	
	var searchStr = $("#searchStr").val();
	grid.on();
	searchFlag=true;
	ui.get({
		url 		: 'getMailFormList.xcn',
		searchStr	: searchStr,
		success 	: function(data, total) {
			grid.setData(data);
		},
		error 		: function(status, message) {
			ui.alertMsg(message);
		},
		complete 	: function() {
			searchFlag=false;
			grid.off();
		}
	});
}
</script>
</head>
<body class="mini-navbar msgBody">
<!--모달 -->
<div class="modal" id="mailFormPop" tabindex="-1" role="dialog" aria-labelledby="mailFormPop" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="mailPopForm">
			<div class="modalHead">
				<h2><s:message code="mail.form.setting"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="common.msg.addmodify"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="formSubjectSel" class="fname"><s:message code="mail.form.subject"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<select id='formSubjectSel'>
								<option value="" selected>========= <s:message code="mail.form.sel.text"/> =========</option>
								<option value="<s:message code="mail.reservation.name"/> : #SUBJECT#"><s:message code="mail.reservation.name"/></option>
								<option value="<s:message code="mail.send.time"/> : #SEND_DATE#"><s:message code="mail.send.time"/></option>
								<option value="<s:message code="mail.excute.result"/> : #RESULTCOUNT#"><s:message code="mail.excute.result"/></option>
								<option value="<s:message code="condition.period"/> : #PERIOD#"><s:message code="condition.period"/></option>
							</select>
							<input type="text" class="form-control input-sm" style="width:94%;" name="formSubject" id="formSubject">
							<input type="hidden" class="form-control" name="formSeq" id="formSeq">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="formContentSel" class="fname"><s:message code="mail.form.content"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<select id='formContentSel'>
								<option value="" selected>========= <s:message code="mail.form.sel.text"/> =========</option>
								<option value="<s:message code="mail.reservation.name"/> : #SUBJECT#"><s:message code="mail.reservation.name"/></option>
								<option value="<s:message code="mail.send.time"/> : #SEND_DATE#"><s:message code="mail.send.time"/></option>
								<option value="<s:message code="mail.excute.result"/> : #RESULTCOUNT#"><s:message code="mail.excute.result"/></option>
								<optgroup label="========== <s:message code="condition.select.search"/> ==========">
									<option value="<s:message code="condition.period"/> : #PERIOD#"><s:message code="condition.period"/></option>
									<option value="<s:message code="condition.receive_send"/> : #RECEIVESEND#"><s:message code="condition.receive_send"/></option>
									<option value="<s:message code="condition.search_str"/> : #SEARCHKEY#"><s:message code="condition.search_str"/></option>
									<option value="<s:message code="condition.field.search"/> : #SEARCHFIELD#"><s:message code="condition.field.search"/></option>
									<option value="<s:message code="condition.sender"/> : #SENDERS#"><s:message code="condition.sender"/></option>
									<option value="<s:message code="condition.recv"/> : #RECEIVERS#"><s:message code="condition.recv"/></option>
									<option value="<s:message code="condition.recv"/>(<s:message code="condition.to"/>) : #RCVTO#"><s:message code="condition.recv"/>(<s:message code="condition.to"/>)</option>
									<option value="<s:message code="condition.recv"/>(<s:message code="condition.cc"/>) : #RCVCC#"><s:message code="condition.recv"/>(<s:message code="condition.cc"/>)</option>
									<option value="<s:message code="condition.recv"/>(<s:message code="condition.bcc"/>) : #RCVBCC#"><s:message code="condition.recv"/>(<s:message code="condition.bcc"/>)</option>
									<option value="<s:message code="condition.recv"/>  <s:message code="common.org.jikgub"/> : #RCVJIKGUB#"><s:message code="condition.recv"/> <s:message code="common.org.jikgub"/></option>
									<option value="<s:message code="filterInfo.size"/> : #MESSAGE_SIZE#"><s:message code="filterInfo.size"/></option>
									<option value="<s:message code="condition.isattached"/> : #ATTACHEYN#"><s:message code="condition.isattached"/></option>
									<option value="<s:message code="consent.attach"/> : #ATTACHSTR#"><s:message code="consent.attach"/></option>
									<option value="<s:message code="condition.iskeyword"/> : #KEYWORDYN#"><s:message code="condition.iskeyword"/></option>
									<option value="<s:message code="condition.keyword"/> : #KEYWORDSTR#"><s:message code="condition.keyword"/></option>
									<option value="<s:message code="condition.regexp.isdetect"/> : #REGEXPYN#"><s:message code="condition.regexp.isdetect"/></option>
									<option value="<s:message code="condition.regexp"/>: #REGEXPSTR#"><s:message code="condition.regexp"/></option>
									<option value="<s:message code="common.org.busi"/> : #BUSI#"><s:message code="common.org.busi"/></option>
									<option value="<s:message code="common.org.dept"/> : #DEPT#"><s:message code="common.org.dept"/></option>
									<option value="<s:message code="condition.isread"/> : #READYN#"><s:message code="condition.isread"/></option>
									<option value="<s:message code="filterInfo.servicetype"/> : #SERVICETYPE#"><s:message code="filterInfo.servicetype"/></option>
									<option value="<s:message code="interest.user"/>: #INTERGROUP#"><s:message code="interest.user"/></option>
								</optgroup>
							</select>
							<textarea class="form-control" style="width:100%; height: 170px;" name="formContent" id="formContent"></textarea>
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="formComment" class="fname"><s:message code="mail.form.comment"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="formComment" id="formComment">
						</div>
					</div>

				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 savePopBtn" accesskey="S" id="savePopBtn"><s:message
							code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>

<!-- //모달 -->
	<div class="p12" style="width: 900px; overflow: auto;">
		<h3 class="blue"><span class="bullet01"></span><s:message code="mail.mgnt.form.mail"/></h3>
		<div class="grayBg mat8 popupInner">
			<div>
				<input type="text"  placeholder="<s:message code="mail.message.input.form_subject"/>" id="searchStr" style="width: 250px;">
				<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.msg.search"/></button>
			</div>
			<div class="right_btnBox">
				<button type="button" class="btn01" id="insertBtn" accesskey="I"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
				<button type="button" class="btn02" id="deleteBtn" accesskey="D"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
			</div>
		</div>
	</div>
	<div class="xcn_container">
		<div class="boxArea">
			<div class="content_body">
				<!--<div class="row">
					<div class="col-xs-8 text-left">
						<div class="form-group form-inline not-dashed">
							<div class="input-group">
								<input type="text" class="form-control input-sm" placeholder="<s:message code="mail.message.input.form_subject"/>" id="searchStr" style="width: 250px;">
								<div class="input-group-btn">
									<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
								</div>
							</div>
						</div>
					</div>
					<div class="col-xs-4 text-right">
						<button type="button" class="btn btn-sm btn-primary" accesskey="I" id="insertBtn"><span class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
						<button type="button" class="btn btn-sm btn-default" accesskey="D" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/></button>
					</div>
				</div>-->
				<div class="row xcn_full top_space" >
					<div class="col-xs-12" style="height: 100%; width:900px;">
						<div id="mailFormListGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var grid = new Xgrid('mailFormListGrid', contextRoot);
		grid.onCheckBox();
		grid.autoNumber();
		grid.colAdd('formSeq', '<s:message code="mail.form.number"/>', 40, 'center', true, 'nomal');
		grid.colAdd('formSubject', '<s:message code="mail.form.subject"/>', 458, 'left', false, 'link');
		grid.colAdd('formContent', '<s:message code="mail.form.content"/>', 250, 'left', true, 'nomal');
		grid.colAdd('formComment', '<s:message code="mail.form.comment"/>', 300, 'left', false, 'nomal');

		grid.loadHeader(true);
		grid.initData('<s:message code="common.msg.search.click"/>');
		grid.onClick = function() {
			if (grid.Col == grid.ColIndex('formSubject')) {
				var data = grid.getRowData(grid.Row);

				$('#formSeq').val(data.formSeq);
				$('#formSubject').val(data.formSubject);
				$('#formContent').val(data.formContent);
				$('#formComment').val(data.formComment);

				$("#mailFormPop").modal('show');
				$('#mailFormPop').attr('mode','modify');
			}
		};
	</script>
</body>

<div style="width: 900px; overflow: auto; margin-top:20px;">

	<div>

		<div class="row" >
			<div class="col-xs-12">
				<h3 class="blue"><span class="bullet01"></span><s:message code="mail.select.form.mail"/></h3>
				<div class="grayBg mat8 popupInner">
					<div>
						<input type="text" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr">
						<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.msg.search"/></button>
					</div>
				</div>
				<div>
					<div id="mailFormListGrid" class="slickGrid gridArea"  style="max-height:200px; overflow-y: scroll !important;"></div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-12">
				<div class="form-inline not-dashed">
					<label for="formContent" class="control-label"><s:message code="mail.form.content"/></label>
					<textarea class="form-control" style="width:100%; height: 300px; margin-top: 5px; background-color: #f8f6f6; margin-left: 1px;" name="formContent" id="formContent" readonly="readonly"></textarea>
				</div>
			</div>
		</div>
	</div>
</div>

</div>
<!--
<body class="mini-navbar msgBody">
	<div class="modal fade" id="mailFormPop" tabindex="-1" role="dialog" aria-labelledby="mailFormPop">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<form method="post" id="mailPopForm">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="mail.form.setting"/> - <s:message code="common.msg.addmodify"/></h3>
					</div>
					<div class="modal-body">
						<div class="row form-inline">
							<div class="col-xs-12 text-left">
								<label for="formSubjectSel" class=" col-xs-3" style="padding-left: 0px;"><s:message code="mail.form.subject"/></label>
							</div>
						</div>
						<div class="form-inline top_space not-dashed">
							<select class='form-control input-sm' id='formSubjectSel'>
								<option value="" selected>========= <s:message code="mail.form.sel.text"/> =========</option>
								<option value="<s:message code="mail.reservation.name"/> : #SUBJECT#"><s:message code="mail.reservation.name"/></option>
								<option value="<s:message code="mail.send.time"/> : #SEND_DATE#"><s:message code="mail.send.time"/></option>
								<option value="<s:message code="mail.excute.result"/> : #RESULTCOUNT#"><s:message code="mail.excute.result"/></option>
								<option value="<s:message code="condition.period"/> : #PERIOD#"><s:message code="condition.period"/></option>
							</select>
						</div>
						<div class="form-inline" style="padding-top: 5px;">
							<input type="text" class="form-control input-sm" style="width:94%;" name="formSubject" id="formSubject">(250)
							<input type="hidden" class="form-control" name="formSeq" id="formSeq">
						</div>
						<div class="row form-inline" style="margin-top: 10px;">
							<div class="col-xs-12 text-left">
								<label for="formContentSel" class=" col-xs-3" style="padding-left: 0px;"><s:message code="mail.form.content"/></label>
							</div>
						</div>
						<div class="form-inline top_space not-dashed">
							<select class='form-control input-sm' id='formContentSel'>
								<option value="" selected>========= <s:message code="mail.form.sel.text"/> =========</option>
								<option value="<s:message code="mail.reservation.name"/> : #SUBJECT#"><s:message code="mail.reservation.name"/></option>
								<option value="<s:message code="mail.send.time"/> : #SEND_DATE#"><s:message code="mail.send.time"/></option>
								<option value="<s:message code="mail.excute.result"/> : #RESULTCOUNT#"><s:message code="mail.excute.result"/></option>
								<optgroup label="========== <s:message code="condition.select.search"/> ==========">
									<option value="<s:message code="condition.period"/> : #PERIOD#"><s:message code="condition.period"/></option>
									<option value="<s:message code="condition.receive_send"/> : #RECEIVESEND#"><s:message code="condition.receive_send"/></option>
									<option value="<s:message code="condition.search_str"/> : #SEARCHKEY#"><s:message code="condition.search_str"/></option>
									<option value="<s:message code="condition.field.search"/> : #SEARCHFIELD#"><s:message code="condition.field.search"/></option>
									<option value="<s:message code="condition.sender"/> : #SENDERS#"><s:message code="condition.sender"/></option>
									<option value="<s:message code="condition.recv"/> : #RECEIVERS#"><s:message code="condition.recv"/></option>
									<option value="<s:message code="condition.recv"/>(<s:message code="condition.to"/>) : #RCVTO#"><s:message code="condition.recv"/>(<s:message code="condition.to"/>)</option>
									<option value="<s:message code="condition.recv"/>(<s:message code="condition.cc"/>) : #RCVCC#"><s:message code="condition.recv"/>(<s:message code="condition.cc"/>)</option>
									<option value="<s:message code="condition.recv"/>(<s:message code="condition.bcc"/>) : #RCVBCC#"><s:message code="condition.recv"/>(<s:message code="condition.bcc"/>)</option>
									<option value="<s:message code="condition.recv"/>  <s:message code="common.org.jikgub"/> : #RCVJIKGUB#"><s:message code="condition.recv"/> <s:message code="common.org.jikgub"/></option>
									<option value="<s:message code="filterInfo.size"/> : #MESSAGE_SIZE#"><s:message code="filterInfo.size"/></option>
									<option value="<s:message code="condition.isattached"/> : #ATTACHEYN#"><s:message code="condition.isattached"/></option>
									<option value="<s:message code="consent.attach"/> : #ATTACHSTR#"><s:message code="consent.attach"/></option>
									<option value="<s:message code="condition.iskeyword"/> : #KEYWORDYN#"><s:message code="condition.iskeyword"/></option>
									<option value="<s:message code="condition.keyword"/> : #KEYWORDSTR#"><s:message code="condition.keyword"/></option>
									<option value="<s:message code="condition.regexp.isdetect"/> : #REGEXPYN#"><s:message code="condition.regexp.isdetect"/></option>
									<option value="<s:message code="condition.regexp"/>: #REGEXPSTR#"><s:message code="condition.regexp"/></option>
									<option value="<s:message code="common.org.busi"/> : #BUSI#"><s:message code="common.org.busi"/></option>
									<option value="<s:message code="common.org.dept"/> : #DEPT#"><s:message code="common.org.dept"/></option>
									<option value="<s:message code="condition.isread"/> : #READYN#"><s:message code="condition.isread"/></option>
									<option value="<s:message code="filterInfo.servicetype"/> : #SERVICETYPE#"><s:message code="filterInfo.servicetype"/></option>
									<option value="<s:message code="interest.user"/>: #INTERGROUP#"><s:message code="interest.user"/></option>
								</optgroup>
							</select>
						</div>
						<div class="form-inline">
							<textarea class="form-control" style="width:100%; height: 170px;" name="formContent" id="formContent"></textarea>
						</div>
						<div class="row form-inline" style="margin-top: 10px;">
							<div class="col-xs-12 text-left">
								<label for="formComment" class=" col-xs-3" style="padding-left: 0px;"><s:message code="mail.form.comment"/></label>
							</div>
						</div>
						<div class="form-inline top_space not-dashed">
							<input type="text" class="form-control input-sm" style="width:100%;" name="formComment" id="formComment">
						</div>
					</div>
				</form>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="mail.mgnt.form.mail"/></span>
		</div>
	</header>
	<div class="xcn_container"> 
		<div class="boxArea">
			<div class="content_body">
				<div class="row">
					<div class="col-xs-8 text-left">
						<div class="form-group form-inline not-dashed">
							<div class="input-group">
								<input type="text" class="form-control input-sm" placeholder="<s:message code="mail.message.input.form_subject"/>" id="searchStr" style="width: 250px;">
								<div class="input-group-btn">
									<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
								</div>
							</div>
						</div>
					</div>
					<div class="col-xs-4 text-right">
						<button type="button" class="btn btn-sm btn-primary" accesskey="I" id="insertBtn"><span class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
						<button type="button" class="btn btn-sm btn-default" accesskey="D" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/></button>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="mailFormListGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var grid = new Xgrid('mailFormListGrid', contextRoot);
		grid.onCheckBox();
		grid.autoNumber();
		grid.colAdd('formSeq', '<s:message code="mail.form.number"/>', 40, 'center', true, 'nomal');
		grid.colAdd('formSubject', '<s:message code="mail.form.subject"/>', 458, 'left', false, 'link');
		grid.colAdd('formContent', '<s:message code="mail.form.content"/>', 250, 'left', true, 'nomal');
		grid.colAdd('formComment', '<s:message code="mail.form.comment"/>', 300, 'left', false, 'nomal');

		grid.loadHeader(true);
		grid.initData('<s:message code="common.msg.search.click"/>');
		grid.onClick = function() {
			if (grid.Col == grid.ColIndex('formSubject')) {
				var data = grid.getRowData(grid.Row);
				
				$('#formSeq').val(data.formSeq);
				$('#formSubject').val(data.formSubject);
				$('#formContent').val(data.formContent);
				$('#formComment').val(data.formComment);
				
				$("#mailFormPop").modal('show');
				$('#mailFormPop').attr('mode','modify');
			}
		};
	</script>
</body>-->

</html>