<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/popupScript.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/message.css"/>"/> <%-- message css--%>
<link rel="stylesheet" href="<c:url value="/css/messageContent.css"/>"/> <%-- message css--%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS PRO - <s:message code="query.make.title"/></title>
	<style type="text/css">
		html, body, .row{
			height:100%;
		}
		.input-xs {
			height: 22px;
			padding: 2px 5px;
			font-size: 12px;
			line-height: 1.5;
			border-radius: 3px;
			font-weight: normal;
		}

		#queryHelpPop {
			display:none;
			border: 1px solid #202d82;
			position: absolute;
			background-color: #99ace6;
			color: #fff;
			z-index: 999;
			font-size: 12px;
			padding: 3px;
			max-width: 400px;
			word-break: break-all;
		}

		.header {
			text-align: center;
			background-color: #ededed;
		}
		/* th {background-color: #ededed;} */

		#selectedCodeTitle {
			display:none;
			border: 1px solid #458A45;
			position: absolute;
			background-color: #5CB85C;
			color: #fff;
			z-index: 999;
			font-size: 15px;
			padding: 3px;
			max-width: 400px;
			word-break: break-all;
		}
		table.table-condensed tr {
			border-bottom: 0px !important;
			padding: 0px;
		}
		/* table.tbl_contition th, td {
            font-size: 12px;
            line-height: 25px !important;
        }
        table.tbl_contition {
            max-width: 900px;
            margin: auto;
        }
        table.tbl_contition tr:not(.not-dashed) {
            border-bottom: 1px dashed #cccccc;
            padding: 7px 0px;
        } */

		div#solrQueryHelpDiv{position:absolute; display:none; text-align: left;z-index: 1040;border: 1px solid #555;background-color: #DCE7F3;width:540px;height:550px;}

		.CodeMirror {
			border-top: 1px solid black;
			border-bottom: 1px solid black;
		}

		.CodeMirror .cm-operator {
			color: orange;
		}

		.CodeMirror-scroll {
			max-width:	695px;
		}
		table.tbl_contition input{border-radius : 0px;}
		table.tbl_contition {width: 100%;border: 0;border-top: 2px solid #5F8AEA;table-layout: fixed;}
		table.tbl_contition th {color: #333;height: 27px;font-size: 12px;}
		table.tbl_contition td {color: #333;height: 27px; padding: 3px;font-size: 12px;}
		table.tbl_contition thead th {border-bottom: 1px solid #ccc;background: #f8f8f8}
		table.tbl_contition tbody th {border-bottom: 1px solid #ddd;background: #EAEAEA;text-align: right;padding-right: 10px;padding-left: 0px;}
		table.tbl_contition tfoot th {border-bottom: 1px solid #ddd}
		table.tbl_contition tbody td {border-bottom: 1px solid #ddd}
		table.tbl_contition .header {text-align: center;}
		table.table-condensed th {background : #fff !important;}
		table.table-condensed th, table.table-condensed td {
			line-height: 25px !important;
			border-bottom : 0px !important;
			font-size: 14px !important;
			padding: 3px  !important;
		}
		.border-radius-none{
			border-radius:0;
		}
		.btn-group-xs>.btn, .btn-xs {
			border-radius:0;
		}
		.queryHelp {font-size: 14px;}

		.helpMsg {
			float: left;height:100%;border: 1px solid #555;background-color: #f4f4f4;width:510px;font-size: 12px; margin-left:20px;padding: 10px;
		}
		.helpMsg span{
			line-height:23px;
		}
	</style>
	<script type="text/javaScript">
		var isConsent = false;
		var erroColumn = "";

		var statType = "<%=statType%>";
		var isOCR = <%=isOCR%>;
		var infoFeedbackYn = '<%=infoFeedbackYn%>';
		var infoFeedbackConf = '<%=infoFeedbackConf%>';
		var epmsgType = '<%=epmsgType%>';
		var recvsJikgub = '<%=recvsJikgub%>';
		var infoHynixConf = '<%=infoHynixConf%>';
		var fieldArr = ["service.svc","directionSvc","day.work","user.businm","user.deptnm","http.host","mail.sender.name","network.srcIp"
			,"mail.to.name","network.dstIp","mail.cc.name","mail.bcc.name","allofus","attached","attachExistCnt","attach.drm","kwd.kwd","kwd.kwds"
			,"pi.id","pi.type","pi.attachNm","pi.kwds","pi.amount","user.id","user.name","user.id","size","body.size","attach.size","xmsgattr"
		];

		<%if( consent && Common.isEquals(firstAdminYn, "N") ){ %>
		isConsent = true;
		<%}%>

		var easyDateStartFlag = false;
		var easyDateEndFlag = false;


		/* elastic search 관련 */

		/* ----- 쿼리 ----- */
		var els_all_search = "*:*";

		var els_open_bracket = "[";
		var els_close_bracket = "]";
		var els_open_parentheses = "(";
		var els_close_parentheses = ")";

		var els_backslash = "\\";
		var els_quotes = "\"";
		var els_space = " ";
		var els_comma = ",";
		var els_colon = ":";
		var els_special_char = "*";
		var els_or_query = " ";
		var els_and_query = "+";
		var els_except_query = "-";

		/* ----- 필드 ----- */

		/*서비스*/
		var fld_service = "service.svc";
		/*수/발신*/
		var fld_directionSvc = "directionSvc";
		/*업무시간구분*/
		var fld_day = "day.work";
		/*사업장명*/
		var fld_businm= "user.businm";
		/*부서명*/
		var fld_deptnm = "user.deptnm";
		/*URL*/
		var fld_url = "http.host";
		/*발신자*/
		var fld_sender = ["mail.sender.name","network.srcIp"];
		/*수신자*/
		var fld_recvs = ["mail.to.name","network.dstIp"];
		/*수신자 2*/
		var fld_ccSender = ["mail.cc.name","mail.bcc.name"];
		/*OCR*/
		/*수신자 구분*/
		var fld_allofus = "allOfUs";

		/*첨부 여부*/
		var fld_attached = "attached";

		/* 첨부 파일 실제 존재*/
		var fld_attachexistcnt = "attachExistCnt";

		/*DRM*/
		var fld_drm = "attach.drm";
		/*예약어*/
		var fld_kwd = ["kwd.kwd","kwd.kwds"];
		/*패턴*/
		var fld_pi = ["pi.id","pi.type","pi.attachNm","pi.kwds","pi.amount"];
		/*사용자*/
		var fld_user = ["user.id","user.name"];

		/*사용자 그룹*/ /*관심 사용자 그룹*/

		var fld_userGroup = "user.id";

		/*크기 (전체,본문,첨부파일)  */
		var fld_size = ["size","body.size","attach.size"];

		/*KNOX 메일 종류*/
		var fld_mailType = "xmsgattr";

		/* ml */
		var fld_ml = ["ml.mlConfdClass","ml.mlConfdFeedback","ml.mlConfdProb"];


		$(document).ready(function(){
			initServiceTypeList( );
			initUserGroupList();
			initInterUserGroupList();
			if(recvsJikgub == "true") {
				initJikgubList();
				$('#recvs_poidTr').show();
			} else {
				$('#recvs_poidTr').hide();
			}
			initSetDisplay();
			initEpmsg();

			if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ) {
				if(infoHynixConf == 'true'){
					$('#skInfoTypeTr, #skFeedbackTypeTr, #skProbTypeTr, #sctTr').show();
				}else{
					$('#infoTypeTr, #feedbackTypeTr, #probTypeTr, #sctTr').show();
				}

			}
			else $('#infoTypeTr, #feedbackTypeTr, #probTypeTr, #sctTr').hide();

			if(epmsgType == "" ){
				$('#epmsgTypeTr').hide();
			}else{
				$('#epmsgTypeTr').show();
			}
			var dateObj = new Date();
			$('#startdate').datetimepicker({
				format: 'YYYY-MM-DD HH:mm:ss',
				locale: 'ko',
				sideBySide: true,
				defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-7 ) )
			});
			$('#enddate').datetimepicker({
				format: 'YYYY-MM-DD HH:mm:ss',
				locale: 'ko',
				sideBySide: true,
				defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
			});

			$('#serviceTypeSelect').selectpicker({
				container:'body',
				size: 15,
				width:'205px',
				searchLabel:true,
				style:'btn-xs btn-default',
				noneSelectedText:'<s:message code="condition.service.all"/>',
				noneResultsText:'<s:message code="common.msg.noresult"/>'+' ',
				selectAllText:'<s:message code="common.msg.select_all"/>',
				deselectAllText:'<s:message code="common.msg.unselect_all"/>',
				liveSearchPlaceholder:'<s:message code="condition.search.service"/>'
			});

			$('#infoTypeSelect').selectpicker({
				container:'body',
				size: 15,
				width:'205px',
				searchLabel:true,
				style:'btn-xs btn-default',
				noneSelectedText:'<s:message code="condition.infotype.all"/>',
				noneResultsText:'<s:message code="common.msg.noresult"/>'+' ',
				selectAllText:'<s:message code="common.msg.select_all"/>',
				deselectAllText:'<s:message code="common.msg.unselect_all"/>',
				liveSearchPlaceholder:'<s:message code="condition.search.infoType"/>'
			});

			$('#feedbackTypeSelect').selectpicker({
				container:'body',
				size: 15,
				width:'205px',
				searchLabel:true,
				style:'btn-xs btn-default',
				noneSelectedText:'<s:message code="condition.feedback.all"/>',
				noneResultsText:'<s:message code="common.msg.noresult"/>'+' ',
				selectAllText:'<s:message code="common.msg.select_all"/>',
				deselectAllText:'<s:message code="common.msg.unselect_all"/>',
				liveSearchPlaceholder:'<s:message code="condition.search.feedback"/>'
			});

			$('#probTypeSelect').selectpicker({
				container:'body',
				size: 15,
				width:'205px',
				searchLabel:true,
				style:'btn-xs btn-default',
				noneSelectedText:'<s:message code="condition.prob.all"/>',
				noneResultsText:'<s:message code="common.msg.noresult"/>'+' ',
				selectAllText:'<s:message code="common.msg.select_all"/>',
				deselectAllText:'<s:message code="common.msg.unselect_all"/>',
				liveSearchPlaceholder:'<s:message code="condition.search.prob"/>'
			});

			$('#allOfus').selectpicker({
				container:'body',
				size: 15,
				style:'btn-xs btn-default',
				noneSelectedText:'<s:message code="condition.allofus.all"/>'
			});

			$('#epmsgTypeSelect').selectpicker({
				container:'body',
				size: 15,
				style:'btn-xs btn-default',
				noneSelectedText:'<s:message code="condition.epmsgType.all"/>'
			});

			$('#recvs_poid').selectpicker({
				container:'body',
				size: 15,
				style:'btn-xs btn-default',
				noneSelectedText:'<s:message code="condition.recv_jikgub.all"/>'
			});

			$(document).on('mouseover', '.queryHelp', function(e){
				$('#queryHelpPop').html($(this).attr("data-helptext"));
				$('#queryHelpPop').show();
				$('#queryHelpPop').css('left', e.clientX + 10 + 'px');
				$('#queryHelpPop').css('top', e.clientY-40+'px');

			});

			$(document).on('mouseout', '.queryHelp', function(e){
				$('#queryHelpPop').hide();
			});

			var Querytext=$("#solrQueryText", opener.document).val();

			setQueryMakeCondition(Querytext.split(" "));

			if(Querytext != ''){
				var queryType="Querytext";
				queryMake(queryType, "");
			}

			$('.queryAdd').click(function () {
				var queryType = $(this).attr("data-queryType");
				queryMake (queryType, els_space+els_and_query+els_space);
			});

			$('.queryOr').click(function () {
				var queryType = $(this).attr("data-queryType");
				queryMake (queryType, els_space+els_or_query+els_space);
			});

			$('.queryMinus').click(function () {
				var queryType = $(this).attr("data-queryType");
				queryMake (queryType, els_space+els_except_query+els_space);
			});

			$(document).on('click', '.filterAddBtn', function(){
				var code = $(this).attr('id').substring(0, $(this).attr('id').length-3);
				openCodeWindow(code, $('#'+code+'Val').val(), $('#'+code+'Str').val());
			});

			$(document).on('mouseover', '.codeSelectedBtn', function(e){
				$('#selectedCodeTitle').show();
				$('#selectedCodeTitle').css('left', e.clientX + 10 + 'px');
				$('#selectedCodeTitle').css('top', e.clientY-40+'px');

				var str = $(this).parent().find('.selectedTitle').val();
				if( str != undefined ) str = str.replaceAll('\\|', ',');
				$('#selectedCodeTitle').html(str);
			});
			$(document).on('mousemove', '.codeSelectedBtn', function(e){
				$('#selectedCodeTitle').css('left', e.clientX + 10 + 'px');
				$('#selectedCodeTitle').css('top', e.clientY-40+'px');

				var str = $(this).parent().find('.selectedTitle').val();
				if( str != undefined ) str = str.replaceAll('\\|', ',');
				$('#selectedCodeTitle').html(str);
			});

			$(document).on('mouseout', '.codeSelectedBtn', function(e){
				$('#selectedCodeTitle').hide();
			});

			$(document).on('click', '.codeSelectedBtn', function(e){
				resetCode($(this).attr('id').substring(0, $(this).attr('id').length-12));
				$('#selectedCodeTitle').hide();
			});

			$('[name=attachYn]').change(function(){
				if($(this).val() == "Y") $('#attachBtn').prop('disabled',false);
				else {
					$('#attachBtn').prop('disabled',true);
					resetCode('attach');
				}
			});

			$('[name=keywordYn]').change(function(){
				if($(this).val() == "Y") $('#keywordBtn').prop('disabled',false);
				else {
					$('#keywordBtn').prop('disabled',true);
					resetCode('keyword');
				}
			});

			$('[name=regexpYn]').change(function(){
				if($(this).val() == "Y") $('#regexpBtn').prop('disabled',false);
				else {
					$('#regexpBtn').prop('disabled',true);
					resetCode('regexp');
				}
			});

			$('#queryExecuteBtn').click(function () {

				var solrQueryText = editor.getValue();
				if(solrQueryText.trim() == "") {
					ui.alertMsg("<s:message code="message.message.query.input"/>");
					return;
				}


				var queryChk = validateQuery(solrQueryText);
				if(!queryChk[0]) {
					if(queryChk[1] == "field") {
						if(queryChk[2] == "") {
							ui.alertMsg('<s:message code="query.make.message.field.not"/>');
						} else {
							ui.alertMsg('<s:message code="query.make.message.field.valid" arguments="' + queryChk[2] + '" />');
						}
					}

					if(queryChk[1] == "bracket") {
						var arguments = "'(', ')'";
						ui.alertMsg('<s:message code="query.make.message.bracket" arguments="' + arguments + '" argumentSeparator="|"/>');
					}

					if(queryChk[1] == "square") {
						var arguments = "'[', ']'";
						ui.alertMsg('<s:message code="query.make.message.bracket" arguments="' + arguments + '" argumentSeparator="|"/>');
					}

					if(queryChk[1] == "quote") {
						ui.alertMsg('<s:message code="query.make.message.quote"/>');
					}

					return;
				}

				opener.$('#solrQueryText').val(editor.getValue());
				opener.getSearchQuery();

				if(isConsent) {
					if( $('#consentNo').val() == ''){

						opener.$('#consentNo').val('');
						opener.$('#consentName').text('');
						opener.$('#consentShortName').val('');
						opener.$('#consentUserId').val('');
						opener.$('#consentBtn').removeClass('active');
					}else{
						opener.$('#consentNo').val($('#consentNo').val());
						opener.$('#consentName').text($('#consentName').text());
						opener.$('#consentShortName').val($('#consentShortName').val());
						opener.$('#consentUserId').val($('#consentUserId').val());
						opener.$('#consentBtn').addClass('active');
					}
				}
				self.close();
			});

			$("#sizeFilterSelect").change(function(){
				var selectedCode = $(this).val();
				if( selectedCode == 'B' ) {
					$('#lowcount, #highcount').prop('disabled', false);
					$('#lowcount').focus();
				} else {
					$('#lowcount').prop('disabled', false);
					$('#highcount').prop('disabled', true).focus();
				}
			});
			setTimeout(function() { setDisplayCondtion(queryCon); },300);
		});

		function initSetDisplay() {
			//if(statType == "users") {
			if(statType != "") {
				$("#ctimeTr").css("display", "none");
				$("#queryExecuteBtn").prop('innerHTML', '<i class="glyphicon glyphicon-search"></i>&nbsp;<s:message code="common.msg.select"/>');
			}

			if(statType == "interestUser") {
				$("#userTr").css("display", "none");
				$("#userGroupTr").css("display", "none");
			}

			if(statType == "attachType") {
				$("#attachtypeexceptTr").css("display", "");
			}

			if(statType == "attachName") {
				$("#attachstrexceptTr").css("display", "");
			}

		}
		function initServiceTypeList( ){

			var url = 'getServiceListByAuth.xcn';
			if(statType == "sender") {
				url = 'getSendMailServiceListByOption.xcn';
			}

			ui.get({
				url : url,
				success : function(data, total) {
					serviceTypes = data;
					getServiceGroupList( );
				},
				error : function(status, message) {
					ui.alertMsg('error:' + status);
				},
				complete : function() {
				}
			});
		}

		var serviceTypes=[];
		var specialService=[];
		var parentCode = [];
		function getServiceGroupList( ){
			var str = '';
			for (var i = 0; i < serviceTypes.length; i++) {
				if( str.indexOf(serviceTypes[i].groupCd ) == -1){
					str += serviceTypes[i].groupCd + ',';
				}
				if(serviceTypes[i].serviceCd.length == 4) {
					specialService.push(serviceTypes[i]);
				}
			}
			serviceGroups = str.substring(0, str.length-1).split(',');
			var serviceStr = getServiceOptionStr( );
			$('#serviceTypeSelect').html(serviceStr);
			getServiceOptionLiveSearch(parentCode);
			$('#serviceTypeSelect').selectpicker('refresh');
		}

		function getServiceOptionStr( ){
			var str = '';
			for (var i = 0; i < serviceGroups.length; i++) {
				var selectedVal = serviceGroups[i];
				var idx = 0;
				for (var j = 0; j < serviceTypes.length; j++) {
					if( selectedVal == serviceTypes[j].groupCd){
						if( idx == 0 ){
							str += '<optgroup label="'+serviceTypes[j].groupNm+'">';
						}
						if( serviceTypes[j].serviceCd.length == 3){
							str += getServiceOptionChildren(serviceTypes[j]);
						} else if ( serviceTypes[j].serviceCd.length == 4 ) continue;
						else str += '<option value="'+serviceTypes[j].serviceCd+'">'+serviceTypes[j].serviceNm+'</option>';
						idx++;
					}
				}
				if( idx != 0 ) str += '</optgroup>';
			}
			return str;
		}
		function getServiceOptionChildren(serviceType) {
			var result = '<option value="'+serviceType.serviceCd+'">'+serviceType.serviceNm+'</option>';
			for (var i = 0; i < specialService.length; i++) {
				var service = specialService[i];
				if( service.serviceCd.indexOf(serviceType.serviceCd) > -1 ) {
					if(!parentCode.includes(serviceType.serviceCd)) parentCode.push(serviceType.serviceCd);
					result += '<option value="'+service.serviceCd+'"> └ '+service.serviceNm+'</option>';
				}
			}

			return result;
		}
		function getServiceOptionLiveSearch(code) {
			var searchWord = "";

			for (var i = 0; i < code.length; i++) {
				var pCode = code[i];
				for(var j = 0; j < specialService.length; j++) {
					if( specialService[j].serviceCd.indexOf(pCode) > -1 ) {
						searchWord += specialService[j].serviceNm + " ";
					}
				}
				$('[value=' + pCode + ']').attr('data-tokens', searchWord);
				searchWord = "";
			}
		}
		function initUserGroupList(){
			ui.get({
				url : 'getConUserGroupList.xcn',
				logYn : 'Y',
				success : function(data, total) {
					getUserGroupListOptions(data);
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
				}
			});
		}
		function getUserGroupListOptions(data){
			$('#userGroupSeq').selectpicker({
				container:'body',
				size: 15,
				style:'btn-xs btn-default',
				noneSelectedText:'-<s:message code="userGroup.navi.title2"/>-'
			});

			var result='';
			for(var i=0 ; i<data.length; i++){
				result+='<option value="' + data[i].groupCode + '">' +  data[i].groupName + '</option>';
			}
			$("#userGroupSeq").html(result);
			$("#userGroupSeq").selectpicker('refresh');
		}
		function initInterUserGroupList(){
			ui.get({
				url : 'getConAdminUserGroupList.xcn',
				logYn : 'Y',
				success : function(data, total) {
					getInterUserGroupListOptions(data);
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
				}
			});
		}
		function getInterUserGroupListOptions(data){
			$('#interUserGroupSeq').selectpicker({
				container:'body',
				size: 15,
				style:'btn-xs btn-default',
				noneSelectedText:'-<s:message code="condition.interestGroup"/>-'
			});

			var result='';
			for(var i=0 ; i<data.length; i++){
				result+='<option value="' + data[i].groupSeq + '">' +  data[i].groupName + '</option>';
			}
			$("#interUserGroupSeq").html(result);
			$("#interUserGroupSeq").selectpicker('refresh');
		}

		function initJikgubList(){
			ui.get({
				url : 'getJikgubList.xcn',
				logYn : 'Y',
				success : function(data, total) {
					getJikgubListOptions(data);
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
				}
			});
		}

		function getJikgubListOptions(data){
			var result='';
			for(var i=0 ; i<data.length; i++){
				result+='<option value="' + data[i].jikgubCd + '">' +  data[i].jikgubNm + '</option>';
			}
			$("#recvs_poid").html(result);
			$("#recvs_poid").selectpicker('refresh');
		}
		/*
        function validateParentheses(queryText) {

            var leftParentheses = queryText.match(/[(]/gi);
            var rightParentheses = queryText.match(/[)]/gi);

            var leftCnt = 0;
            var rightCnt = 0;

            if(leftParentheses != null) leftCnt = leftParentheses.length;
            if(rightParentheses != null) rightCnt = rightParentheses.length;

            if(leftCnt == rightCnt) {
                return false;
            } else {
                return true;
            }
        }
        */

		/*
         * rtn [check, errorType, column]
         * check : true, false
         * errorType : field
         *
         */
		function validateQuery(queryText) {
			var startIndex = -1;
			var EndIndex = -1;
			var field = "";
			var rtn = [false, "column", ""];
			var isQuote = true;


			var lBkCnt = 0;		// '(' Count
			var rBkCnt = 0;		// ')' Count

			var lSBkCnt = 0;	// '[' Count
			var rSBkCnt = 0;	// ']' Count

			var preChr = "";


			//Field 뒤 blank 제거 (msgid    :XXXXXX ==> msgid:XXXXXX)
			queryText = queryBlankRemove(queryText);

			for(var i = 0; i < queryText.length; i++) {
				var chr = queryText.charAt(i);

				if(chr == '"') {
					if(preChr != '\\') {
						if(isQuote) {isQuote = false;}
						else {isQuote = true;}
					}
				}

				if(isQuote) {
					if(chr == '(') {
						lBkCnt++;
					}
					if(chr == ')') {
						rBkCnt++;
					}
					if(chr == '[') {
						lSBkCnt++;
					}
					if(chr == ']') {
						rSBkCnt++;
					}
				}


				if(chr == '+' || chr == '-' || chr == '(' || chr == ' ') {
					startIndex = i;
				}
				if(chr == ':') {
					endIndex = i;
					field = queryText.substring(startIndex+1, endIndex).rtrim();
					rtn[0] = true;
					if(fieldArr.indexOf(field) == -1) {
						rtn[0] = false;
						rtn[1] = "field";
						rtn[2] = field;
						break;
					}
				}

				preChr = chr;
			}

			if(rtn[0]) {
				if(lBkCnt != rBkCnt) {
					rtn[0] = false;
					rtn[1] = "bracket";
				}

				if(lSBkCnt != rSBkCnt) {
					rtn[0] = false;
					rtn[1] = "square";
				}

				if(!isQuote) {
					rtn[0] = false;
					rtn[1] = "quote";
				}
			}

			return rtn;
		}


		function queryBlankRemove(queryText) {
			var preChr = "";
			var rtn = "";
			var isQuote = true;
			for(var i = 0; i < queryText.length; i++) {
				var chr = queryText.charAt(i);

				if(chr == '"') {
					if(preChr != '\\') {
						if(isQuote) {isQuote = false;}
						else {isQuote = true;}
					}
				}
				if(isQuote) {
					if((preChr == ' ' && chr == ' ') || (preChr == ' ' && chr == ':') ) {
					} else {
						rtn += preChr;
					}
				} else {
					rtn += preChr;
				}
				preChr = chr;
			}
			rtn += preChr;
			return rtn;
		}

		function queryMake (queryType, queryAddMinus) {
			if(queryType == "userGroup") {
				queryMakeUserGroup(queryAddMinus);
			} else if(queryType == "interUserGroup") {
				queryMakeInterUserGroup(queryAddMinus);
			} else {
				var solrQueryText = editor.getValue();
				var addQueryText = "";
				switch (queryType) {

					case "Querytext":
						addQueryText=$("#solrQueryText", opener.document).val();
						break;
					case "ctime": // 시간
						var startDt = $('#startdate').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
						var endDt = $('#enddate').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
						addQueryText = queryAddMinus + "ctime:[" + startDt + " TO " + endDt + "]";
						break;
					case "svc":  // 서비스
						var service = $('#serviceTypeSelect').selectpicker('val');
						if(service) {
							addQueryText = queryAddMinus +  "service.svc"+els_colon+els_open_parentheses;
							for(var i = 0; i < service.length; i++) {
								if(i > 0) {
									addQueryText += " "
								}
								if( service[i] == 'EMMAX' ) {
// 							addQueryText += "EMMR* EMMS* EMMG* EMMP* EMMD* EMMU* EMML* EMM1* EMM2* EMM3* EMM4* EMMT* EMMO* EMMB* EMMK*";
									continue;
								}
								else addQueryText += service[i] + "*";
							}
							if(service.indexOf("EMMAX") > -1) {
								addQueryText += els_except_query+els_space+"service.svc"+els_colon+els_open_parentheses+"EMMA"+els_close_parentheses;
							}
							addQueryText += els_close_parentheses;
						}
						break;
					case "direction_svc":
						if($('#receiveSend:checked').length > 0) {
							addQueryText = queryAddMinus + "directionSvc"+els_colon + $('#receiveSend:checked').val();
						}
						break;
					case "work":
						if($('[name=work]:checked').length > 0) {
							addQueryText = queryAddMinus + "day.work"+els_colon + $('[name=work]:checked').val();
						}
						break;
					case "ml_confd_class":
						var infoType = $('#infoTypeSelect').selectpicker('val');
						if(infoType) {
							addQueryText = queryAddMinus + "ml.mlConfdClass"+els_colon+els_open_parentheses;
							for(var i = 0; i < infoType.length; i++) {
								if(i > 0) {
									addQueryText += " "
								}
								addQueryText += '"' + infoType[i] + '"';
							}
							addQueryText += ")";
						}
						break;
					case "ml_confd_feedback":
						var feedback = $('#feedbackTypeSelect').selectpicker('val');
						if(feedback) {
							addQueryText = queryAddMinus + "ml.mlConfdFeedback"+els_colon+els_open_parentheses;
							for(var i = 0; i < feedback.length; i++) {
								if(i > 0) {
									addQueryText += " "
								}
								addQueryText += '"' + feedback[i] + '"';
							}
							addQueryText += els_close_parentheses;
						}
						break;
					case "ml_confd_prob":
						var prob = $('#probTypeSelect').selectpicker('val');
						console.log(prob);
						if(prob) {
							addQueryText = queryAddMinus + els_open_parentheses;
							for(var i = 0; i < prob.length; i++) {
								if(i > 0) {
									addQueryText += " "
								}
								var sp = prob[i].split('|');
								addQueryText += 'mlConfdProb'+els_colon+els_open_bracket + sp[0] + ' TO ' + sp[1] + els_close_bracket;
							}
							addQueryText += els_close_parentheses;
						}
						break;
					case "busi":
						var busiNm = $('#busi').val();
						if(busiNm != "") {
							addQueryText = queryAddMinus + "user.businm"+els_colon+els_open_parentheses;

							var busiNmNmArr = busiNm.split("|");

							for(var i = 0; i < busiNmNmArr.length; i++) {
								if(i > 0) {
									addQueryText += " "
								}
								addQueryText += busiNmNmArr[i].ltrim().rtrim() + "*";
							}

							addQueryText += els_close_parentheses;
						}
						break;
					case "dept":
						var deptNm = $('#dept').val();
						if(deptNm != "") {
							addQueryText = queryAddMinus + "user.deptnm"+els_colon+els_open_parentheses;

							var deptNmArr = deptNm.split("|");

							for(var i = 0; i < deptNmArr.length; i++) {
								if(i > 0) {
									addQueryText += " "
								}
								addQueryText += deptNmArr[i].ltrim().rtrim() + "*";
							}

							addQueryText += els_close_parentheses;
						}
						break;
					case "host":
						var host = $('#host').val();
						if(host != "") {
							addQueryText = queryAddMinus + els_open_parentheses;

							var hostArr = host.split("|");
							var hostStr = "";

							for(var i = 0; i < hostArr.length; i++) {
								if(i > 0) {
									hostStr += " "
								}
								hostStr += hostArr[i].ltrim().rtrim() + "*";
							}
							addQueryText += " http.host"+els_colon+els_open_parentheses + hostStr + els_close_parentheses;
							addQueryText += els_close_parentheses;
						}
						break;
					case "sender":
						var sender = $('#sender').val();
						if(sender != "") {
							addQueryText = queryAddMinus  + els_open_parentheses;

							var senderArr = sender.split("|");
							var senderStr = "";

							for(var i = 0; i < senderArr.length; i++) {
								if(i > 0) {
									senderStr += " "
								}
								senderStr += senderArr[i].ltrim().rtrim() + "*";
							}
							addQueryText += "mail.sender.name"+els_colon+els_open_parentheses + senderStr + els_close_parentheses;
							addQueryText += "network.srcIp"+els_colon+els_open_parentheses + senderStr + els_close_parentheses;
							addQueryText += els_close_parentheses;
						}
						break;
					case "receive":
						var receive = $('#receive').val();
						if(receive != "") {
							addQueryText = queryAddMinus + "(";

							var receiveArr = receive.split("|");
							var receiveStr = "";


							for(var i = 0; i < receiveArr.length; i++) {
								if(i > 0) {
									receiveStr += " "
								}
								receiveStr += "*" + receiveArr[i].ltrim().rtrim() + "*";
							}

							addQueryText += "mail.to.name"+els_colon+els_open_parentheses + receiveStr + els_close_parentheses;
							addQueryText += "network.dstIp"+els_colon+els_open_parentheses + receiveStr + els_close_parentheses;
							addQueryText += els_close_parentheses;
						}
						break;
					case "receiveEtc":
						var receiveEtcObj = $('input:checkbox[name=receiveEtc]:checked');
						var receiveEtcArr = $('#receiveEctVal').val().split("|");
						var receiveEtcStr = "";
						if(receiveEtcObj.length > 0 && receiveEtcArr.length > 0) {
							addQueryText = queryAddMinus + els_open_parentheses;
						}
						for(var i = 0; i < receiveEtcArr.length; i++) {
							if(i > 0) {
								receiveEtcStr += " "
							}
							receiveEtcStr += "*" + receiveEtcArr[i].ltrim().rtrim() + "*"
						}
						for(var i = 0; i < receiveEtcObj.length; i++) {
							if(i > 0) {
								addQueryText += " "
							}
							addQueryText += receiveEtcObj[i].value + els_colon+els_open_parentheses + receiveEtcStr + els_close_parentheses;
						}

						if(receiveEtcObj.length > 0 && receiveEtcArr.length > 0) {
							addQueryText += els_close_parentheses;
						}
						break;

					case "ocr":
						var ocrStr = $('#ocr').val();
						if(ocrStr != "") {
							addQueryText = queryAddMinus + "ocr.attach"+els_colon+els_open_parentheses;

							var ocrStrArr = ocrStr.split("|");

							for(var i = 0; i < ocrStrArr.length; i++) {
								if(i > 0) {
									addQueryText += " "
								}
								addQueryText += ocrStrArr[i].ltrim().rtrim() + "*";
							}

							addQueryText += els_close_parentheses;
						}
						break;

					case "allofus":
						var allOfus = $('#allOfus').val();
						if(allOfus != "") {
							addQueryText = queryAddMinus + "allofus"+ els_colon + els_open_parentheses + $('#allOfus').val() + els_close_parentheses;
						}
						break;
					case "attach":
						if($('#attachYn:checked').length > 0) {
							addQueryText = queryAddMinus + "attached"+ els_colon + els_open_parentheses + $('#attachYn:checked').val() + els_close_parentheses;
						}

						/*				if($('#attachVal').val() != "") {  //선택
                                            if($('#attachYn:checked').length > 0) {
                                                addQueryText += " ";
                                            }

                                            addQueryText += queryAddMinus + "attachtype:(";

                                            var valArr = $('#attachVal').val().split("|");

                                            for(var i = 0; i < valArr.length; i++) {
                                                if(i > 0) {
                                                    addQueryText += " "
                                                }
                                                addQueryText += valArr[i].toLowerCase();
                                            }
                                            addQueryText += ")";
                                        }*/

						resetCode('attach');


						break;

					case "attachexistcnt":
						if(queryAddMinus == '+') addQueryText = els_and_query+els_space+"attachExistCnt"+els_colon+els_open_bracket+'1 TO * '+els_close_bracket;
						else addQueryText = els_and_query+els_space+"attachExistCnt"+els_colon+els_open_bracket;
						break;
					case "recvs_poid":
						var jikgubcd = $('#recvs_poid').selectpicker('val');

						if(jikgubcd){
							addQueryText = queryAddMinus + "recvs_poid:(";

							for(var i = 0; i < jikgubcd.length; i++) {
								if(i > 0) {
									addQueryText += " "
								}
								addQueryText += '' + jikgubcd[i] + '*';
							}
							addQueryText += ")";
						}
						break;
					case "keyword":
						if($('#keywordYn:checked').length > 0) {
							addQueryText = queryAddMinus + "kwd.kwd"+els_colon + $('#keywordYn:checked').val();
						}

						if($('#keywordVal').val() != "") {
							if($('#keywordYn:checked').length > 0) {
								addQueryText += " ";
							}
							addQueryText += queryAddMinus + "kwds"+els_colon+els_open_parentheses;

							var valArr = $('#keywordStr').val().split(", ");

							for(var i = 0; i < valArr.length; i++) {
								if(i > 0) {
									addQueryText += " "
								}
								addQueryText += valArr[i];
							}
							addQueryText += els_close_parentheses;
						}

						resetCode('keyword');
						break;
					case "regexp":
						if($('#regexpYn:checked').length > 0) {
							if($('#regexpYn:checked').val() == "Y") {
								addQueryText = queryAddMinus + "pi.amount"+els_colon+els_open_bracket+'1 TO * '+els_close_bracket;
							} else {
								addQueryText = queryAddMinus + "pi.amount"+els_colon+"0";
							}

						}

						// if($('#regexpVal').val() != "") {
						// 	if($('#regexpYn:checked').length > 0) {
						// 		addQueryText += " ";
						// 	}
						// 	addQueryText += queryAddMinus + els_open_bracket;
						//
						// 	var valArr = $('#regexpVal').val().split("|");
						//
						// 	for(var i = 0; i < valArr.length; i++) {
						// 		if(i > 0) {
						// 			addQueryText += " "
						// 		}
						//
						// 		var valIdArr = valArr[i].split("%");
						//
						// 		if(!fieldArr.includes("pi_" + valIdArr[0])) fieldArr.push("pi_" + valIdArr[0]);
						//
						// 		addQueryText += "pi_" + valIdArr[0] + ":[";
						//
						// 		var valCntArr = valIdArr[1].split("@");
						//
						// 		if( valCntArr[0] == 'B' ) {
						// 			addQueryText += valCntArr[1] + " TO " + valCntArr[2] + "]";
						// 		} else if( valCntArr[0] == 'L' ) {
						// 			addQueryText += valCntArr[1] + " TO *]";
						// 		} else {
						// 			addQueryText += "* TO " + valCntArr[1] + "]";
						// 		}
						//
						// 	}
						// 	addQueryText += ")";
						// }
						//
						resetCode('regexp');


						break;

					case "drm":
						addQueryText = queryAddMinus + "attach.drm"+els_colon+"*";
						break;

					case "sct":
						addQueryText = queryAddMinus + "pi_sct:*";
						break;

					case "user":
						var user = $('#user').val();
						if(user != "") {
							addQueryText = queryAddMinus + els_open_parentheses;

							var userArr = user.split("|");
							var userStr = "";

							for(var i = 0; i < userArr.length; i++) {
								if(i > 0) {
									userStr += " "
								}
								userStr += userArr[i].ltrim().rtrim() + "*";
							}
							//els_colon+els_open_bracket
							addQueryText += "user.id"+els_colon+els_open_parentheses + userStr + els_close_parentheses
									+"user.name"+els_colon+els_open_parentheses + userStr + els_close_parentheses
							addQueryText += els_close_parentheses;
						}
						break;

					case "size":
						var sizeFilterType = $('#sizeFilterType').val();
						var sizeFilterSelect = $('#sizeFilterSelect').val();

						var lowcount = $('#lowcount').val();
						var highcount = $('#highcount').val();


						if(lowcount != "" || (sizeFilterSelect == "B" && (lowcount != "" || highcount != ""))) {
							addQueryText = queryAddMinus;
							if(sizeFilterType == "B") {
								addQueryText += "body.size"+els_colon+els_open_bracket;
							} else if(sizeFilterType == "A") {
								addQueryText += "attach.size"+els_colon+els_open_bracket;
							} else {
								addQueryText += "size"+els_colon+els_open_bracket;
							}

							if(sizeFilterSelect == "B") {
								addQueryText += lowcount + " TO " +  highcount + els_close_bracket;
							} else if(sizeFilterSelect == "L") {
								addQueryText += lowcount + " TO *"+ els_close_bracket;
							} if(sizeFilterSelect == "S") {
								addQueryText += "* TO " +  lowcount + els_close_bracket;
							}
						}
						break;

					case "epmsg_type":
						var epmsgType = $('#epmsgTypeSelect').selectpicker('val');

						if(epmsgType){
							addQueryText = queryAddMinus + "xmsgattr"+els_colon+els_open_bracket;

							for(var i = 0; i < epmsgType.length; i++) {
								if(i > 0) {
									addQueryText += " "
								}
								addQueryText += '' + epmsgType[i] + '*';
							}
							addQueryText += els_close_bracket;
						}

						break;

					case "attachtypeexcept":
						addQueryText = queryAddMinus;
						addQueryText += "attachtype:unknown";
						break;

					case "attachstrexcept":
						addQueryText = queryAddMinus;
						addQueryText += "attachname_str:noname";
						break;

				}

				if(addQueryText == "") return;

				if(solrQueryText == "*:*" || solrQueryText == "") {
					solrQueryText = addQueryText;
				} else {
					solrQueryText += " " + addQueryText;
				}

				editor.setValue(solrQueryText);
			}
		}

		function queryMakeUserGroup(queryAddMinus) {
			var userGroupSeq = arrayToString($('#userGroupSeq').selectpicker('val'));

			if(userGroupSeq == "") return;

			ui.get({
				url : 'getUserGroupUserList.xcn',
				groupCodes : userGroupSeq,
				success : function(data, total) {
					setUserGroupQuery(data, queryAddMinus);
				},
				error : function(status, message) {

				},
				complete : function() {
				}
			});
		}

		function queryMakeInterUserGroup(queryAddMinus) {
			var interUserGroupSeq = arrayToString($('#interUserGroupSeq').selectpicker('val'));

			if(interUserGroupSeq == "") return;

			ui.get({
				url : 'getInterUserGroupUserList.xcn',
				groupCodes : interUserGroupSeq,
				success : function(data, total) {
					setInterUserGroupQuery(data, queryAddMinus);
				},
				error : function(status, message) {

				},
				complete : function() {
				}
			});
		}

		function setUserGroupQuery(data, queryAddMinus) {
			var solrQueryText = editor.getValue();
			var addQueryText = "";

			if(data.length > 0) {
				addQueryText = queryAddMinus + "( "

				for(var i=0; i < data.length; i++) {
					var user = data[i];
					var userId = user.userId;

					if(userId != null) {
						addQueryText += "(userid:" + userId + ") ";
					}
				}
				addQueryText += ")";

				if(solrQueryText == "*:*" || solrQueryText == "") {
					solrQueryText = addQueryText;
				} else {
					solrQueryText += " " + addQueryText;
				}
				editor.setValue(solrQueryText);

			}

		}

		function setInterUserGroupQuery(data, queryAddMinus) {
			var solrQueryText = editor.getValue();
			var addQueryText = "";

			if(data.length > 0) {
				addQueryText = queryAddMinus + "( "

				for(var i=0; i < data.length; i++) {
					var user = data[i];
					var userId = user.userId;

					if(userId != null) {
						addQueryText += "(userid:" + userId + ") ";
					}
				}
				addQueryText += ")";

				if(solrQueryText == "*:*" || solrQueryText == "") {
					solrQueryText = addQueryText;
				} else {
					solrQueryText += " " + addQueryText;
				}
				editor.setValue(solrQueryText);

			}

		}

		function arrayToString( array ){
			if( array == null || array == undefined ) return "";
			else{
				return array.toString();
			}
		}

		function openCodeWindow(id, oldCode, oldConm){
			$('#oldCode').val(oldCode);
			$('#oldConm').val(oldConm);

			var url    = '<c:url value="/commons/selectCode.do?codeType='+id+'"/>';
			fnOpenWindow('', 'selectCodeWinPopup', 1200, 700, 'resize');

			$('#codeParam').attr('target','selectCodeWinPopup');
			$('#codeParam').attr('action', url);
			$('#codeParam').attr('method','post');
			$('#codeParam').submit();
		}

		function getSelectedCodeData( codeType, data ) {
			if( codeType == 'senders' || codeType == 'receivers'){
				$('#'+codeType).tagsinput('removeAll');
				for (var i = 0; i < data.length; i++) {
					$('#'+codeType).tagsinput('add', data[i]);
				}
			}else{
				var str = '';
				var val = '';
				for(var i=0; i<data.length; i++){
					str += data[i].codeName;
					val += data[i].code;
					if( codeType == 'regexp' ) {
						var arr = data[i].count.split('@');
						if( arr[0] == 'B' ) {
							if( adminLang == 'ko' ) str += '(' + arr[1] + '건 ~ ' + arr[2] + '건)';
							else str += '(' + arr[1] + 'items ~ ' + arr[2] + 'items)';
						} else if( arr[0] == 'L' ) {
							if( adminLang == 'ko' ) str += '(' + arr[1] + '건 이상)';
							else str += '(' + arr[1] + 'items over)';
						} else {
							if( adminLang == 'ko' ) str += '(' + arr[1] + '건 이하)';
							else str += '(' + arr[1] + 'items below)';
						}
						val += '%' + data[i].count;
					}

					if( i != data.length-1){
						str +=', ';
						val +='|';
					}
				}
				if( val != '' ){
					str = str.rtrim();
					val = val.trimAll();
				}

				$('#'+codeType+'Str').val(str);
				$('#'+codeType+'Val').val(val);

				if( $('#'+codeType+'Str').val() != '' ){
					$('#'+codeType+'SelectedArea').find('.btn').text(data.length);
					$('#'+codeType+'SelectedArea').show();
				}else{
					$('#'+codeType+'SelectedArea').find('.btn').text(0);
					$('#'+codeType+'SelectedArea').hide();
				}
			}

		}

		function resetCode(codeType){
			$('#'+codeType+'Val').val('');
			$('#'+codeType+'Str').val('');
			$('#'+codeType+'SelectedArea').hide();
		}

		function searchConsentNo(){
			var url    = '<c:url value="/ems/selectConsent.do"/>';
			return fnOpenWindow(url, 'selectConsentWinPopup', 830, 700, 'resize');
		}

		function selectedConsent( obj ){
			if( obj == ''){
				$('#consentNo').val('');
				$('#consentName').text('');
				$('#consentShortName').val('');
				/* $('#consentIp').val('');
                $('#consentEmail').val(''); */
				$('#consentUserId').val('');
				$('#consentBtn').removeClass('active');
			}else{
				$('#consentNo').val(obj.no);
				$('#consentName').text(obj.name + "["+obj.userId+", "+obj.deptNm+"]");
				$('#consentShortName').val(obj.name);
				/* $('#consentIp').val(obj.userIp);
                $('#consentEmail').val(obj.userEmail); */
				$('#consentUserId').val(obj.userId);
				$('#consentBtn').addClass('active');
			}
		}

		function initEpmsg(){
			$('#epmsgTypeSelect').selectpicker({
				container:'body',
				size: 15,
				style:'btn-xs btn-default',
				noneSelectedText:'<s:message code="condition.epmsgType.all"/>'
			});

			var epmsg_type = epmsgType.split(',');
			var result='';
			for(var i=0 ; i<epmsg_type.length; i++){
				result+='<option value="' + epmsg_type[i]+ '">' +  epmsg_type[i] + '</option>';
			}
			$("#epmsgTypeSelect").html(result);
			$("#epmsgTypeSelect").selectpicker('refresh');

		}
	</script>
</head>
<body style="overflow: auto;">
<div class="xcn_container" style="overflow: hidden;">
	<div class="boxArea">
		<div class="row">
			<div class="col-lg-12" style="height:100%;">
				<div class="panel panel-default" style="height:100%;">
					<div class="panel-heading" style="height:40px;">
						<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="query.make.title"/>
					</div>
					<div class="panel-body" style="height:calc(100% - 30px);">
						<div style="float: left;height:100%;width:800px;overflow-y: auto;" >
							<div id="queryHelpPop"></div>
							<div id="selectedCodeTitle"></div>
							<%if( consent && Common.isEquals(firstAdminYn, "N") && Common.isNotEquals(adminType, "C") ){ %>
							<div style="padding-left:10px;padding-bottom:3px;">
								<button type="button" class="btn btn-xs btn-default" accesskey="O" id="consentBtn" style="position: relative;top:-1px;" onclick="searchConsentNo();"><span class="glyphicon glyphicon-tags"></span>&nbsp;<s:message code="consent.select.consent"/></button>
								<input type="text" class="border-radius-none" style="width:120px;height:28px;display:none;" readonly="readonly" id="consentNo">
								<input type="hidden" readonly="readonly" id="consentIp">
								<input type="hidden" readonly="readonly" id="consentEmail">
								<input type="hidden" readonly="readonly" id="consentUserId">
								<span id="consentName" style="font-weight: bold;"></span>
								<input type="hidden" readonly="readonly" id="consentShortName">
							</div>
							<%} else {%>
							<%} %>
							<table class="tbl_contition" style="height:calc(100% - 30px);width:770px;">
								<colgroup>
									<col style="width: 115px;">
									<col style="width: 320px;">
									<col style="width: 46px;">
									<col style="width: 46px;">
									<col style="width: 36px;">
									<col style="width: 200px;">
									<col style="width: 15px;">
								</colgroup>
								<tr class="not-dashed">
									<th class="header"><s:message code="common.msg.separator"/></th>
									<th class="header"><s:message code="query.make.value"/></th>
									<th class="header">AND</th>
									<th class="header">OR</th>
									<th class="header"><s:message code="query.make.except"/></th>
									<th class="header"><s:message code="analysis.freedom.ui.column"/></th>
									<th class="header"></th>
								</tr>
								<tr id="ctimeTr">
									<th><s:message code="condition.period"/></th>
									<td>
										<div  style="float:left;width:320px;">
											<div class="input-group">
												<div class="input-group date" id="startdate" style="width:150px;">
													<input type="text" id="queryStartDt" class="input-xs form-control border-radius-none" />
													<span class="input-group-addon startDateBtn border-radius-none" style="padding: 0px 5px;"> <span class="glyphicon glyphicon-calendar"></span>
														</span>
												</div>
											</div>
											<span>~</span>
											<div class="input-group">
												<div class="input-group date" id="enddate" style="width:150px;">
													<input type="text" id="queryEndDt" class="input-xs form-control border-radius-none"/>
													<span class="input-group-addon endDateBtn border-radius-none" style="padding: 0px 5px;"><span class="glyphicon glyphicon-calendar"></span></span>
												</div>
											</div>
										</div>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="ctime">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="ctime">OR</button></td>
									<td></td>
									<td>ctime</td>
									<td></td>
								</tr>
								<tr>
									<th><s:message code="condition.service"/></th>
									<td>
										<select id="serviceTypeSelect" class="selectpicker small border-radius-none border-radius-none" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="svc">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="svc">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="svc"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>svc</td>
									<td></td>
								</tr>
								<tr>
									<th><s:message code="condition.receive_send"/></th>
									<td>
										<div class="btn-group filterBtn" data-toggle="buttons">
											<label class="btn btn-xs btn-default active"><input type="radio" class="border-radius-none" name="receiveSend" id="receiveSend" value="I" checked> <s:message code="condition.receive"/></label>
											<label class="btn btn-xs btn-default"><input type="radio" name="receiveSend" class="border-radius-none" id="receiveSend" value="O"> <s:message code="condition.send"/></label>
										</div>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="direction_svc">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="direction_svc">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="direction_svc"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>direction_svc</td>
									<td><span class="fa fa-question queryHelp" data-helptext="<s:message code="condition.receive"/>:I <s:message code="condition.send"/>:O"></span></td>
								</tr>
								<tr>
									<th><s:message code="condition.ctimework"/></th>
									<td>
										<div class="btn-group filterBtn" data-toggle="buttons">
											<label class="btn btn-xs btn-default active"><input type="radio" class="border-radius-none" name="work" id="work" value="W" checked> <s:message code="condition.work"/></label>
											<label class="btn btn-xs btn-default"><input type="radio" class="border-radius-none" name="work" id="nonwork" value="R"> <s:message code="condition.notwork"/></label>
										</div>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="work">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="work">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="work"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>work</td>
									<td><span class="fa fa-question queryHelp" data-helptext="<s:message code="condition.work"/>:W <s:message code="condition.notwork"/>:R"></span></td>
								</tr>
								<tr id="infoTypeTr" style="display: none;">
									<th><s:message code="condition.infotype"/></th>
									<td>
										<select id="infoTypeSelect" class="selectpicker small border-radius-none border-radius-none" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true">
											<option value="4"><s:message code="condition.info.class4"/></option>
											<option value="3"><s:message code="condition.info.class3"/></option>
											<option value="2"><s:message code="condition.info.class2"/></option>
											<option value="1"><s:message code="condition.info.class1"/></option>
										</select>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="ml_confd_class">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="ml_confd_class">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="ml_confd_class"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>ml_confd_class</td>
									<td></td>
								</tr>
								<tr id="feedbackTypeTr" style="display: none;">
									<th><s:message code="condition.feedback"/></th>
									<td>
										<select id="feedbackTypeSelect" class="selectpicker small border-radius-none border-radius-none" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true">
											<option value="0"><s:message code="condition.info.feedback0"/></option>
											<option value="1"><s:message code="condition.info.feedback1"/></option>
											<option value="2"><s:message code="condition.info.feedback2"/></option>
											<option value="3"><s:message code="condition.info.feedback3"/></option>
											<option value="4"><s:message code="condition.info.feedback4"/></option>
											<option value="9"><s:message code="condition.info.feedback9"/></option>
											<option value="-1"><s:message code="condition.info.feedback-1"/></option>
										</select>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="ml_confd_feedback">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="ml_confd_feedback">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="ml_confd_feedback"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>ml_confd_feedback</td>
									<td></td>
								</tr>
								<tr id="probTypeTr" style="display: none;">
									<th><s:message code="condition.prob"/></th>
									<td>
										<select id="probTypeSelect" class="selectpicker small border-radius-none border-radius-none" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true">
											<option value="0.5|1.0">50 ~ 100</option>
											<option value="0.1|0.49">10 ~ 49</option>
											<option value="0|0.09">0 ~ 9</option>
										</select>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="ml_confd_prob">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="ml_confd_prob">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="ml_confd_prob"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>ml_confd_prob</td>
									<td></td>
								</tr>
								<!-- sk 하이닉스  -->
								<tr id="skInfoTypeTr" style="display: none;">
									<th><s:message code="condition.infotype"/></th>
									<td>
										<select id="infoTypeSelect" class="selectpicker small border-radius-none border-radius-none" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true">
											<option value="1"><s:message code="condition.info.Y"/></option>
											<option value="0"><s:message code="condition.info.N"/></option>
										</select>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="ml_confd_class">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="ml_confd_class">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="ml_confd_class"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>ml_confd_class</td>
									<td></td>
								</tr>
								<tr id="skFeedbackTypeTr" style="display: none;">
									<th><s:message code="condition.feedback"/></th>
									<td>
										<select id="feedbackTypeSelect" class="selectpicker small border-radius-none border-radius-none" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true">
											<%-- <option value="1"><s:message code="condition.info.secretFeedbackY"/></option> --%>
											<option value="1"><s:message code="condition.info.feedback10"/></option>
											<option value="9"><s:message code="condition.info.feedback9"/></option>
											<option value="0"><s:message code="condition.info.feedback-1"/></option>
											<%-- <option value="0"><s:message code="condition.info.secretFeedbackN"/></option> --%>
										</select>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="ml_confd_feedback">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="ml_confd_feedback">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="ml_confd_feedback"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>ml_confd_feedback</td>
									<td></td>
								</tr>
								<tr id="skProbTypeTr" style="display: none;">
									<th><s:message code="condition.prob"/></th>
									<td>
										<select id="probTypeSelect" class="selectpicker small border-radius-none border-radius-none" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true">
											<option value="0.5|1.0">50 ~ 100</option>
											<option value="0.1|0.49">10 ~ 49</option>
											<option value="0|0.09">0 ~ 9</option>
										</select>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="ml_confd_prob">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="ml_confd_prob">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="ml_confd_prob"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>ml_confd_prob</td>
									<td></td>
								</tr>
								<tr>
									<th><s:message code="common.org.businm"/></th>
									<td>
										<input type="text" class="form-control input-xs border-radius-none" id="busi" placeholder="<s:message code="common.org.businm"/>" style="width: 313px;">
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="busi">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="busi">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="busi"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>businm</td>
									<td><span class="fa fa-question queryHelp" data-helptext="<s:message code="query.make.multi.message"/><br><s:message code="query.make.impossible.unknown"/>"></span></td>
								</tr>
								<tr>
									<th><s:message code="common.org.deptnm"/></th>
									<td>
										<input type="text" class="form-control input-xs border-radius-none" id="dept" placeholder="<s:message code="common.org.deptnm"/>" style="width: 313px;">
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="dept">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="dept">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="dept"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>deptnm</td>
									<td><span class="fa fa-question queryHelp" data-helptext="<s:message code="query.make.multi.message"/><br><s:message code="query.make.impossible.unknown"/>"></span></td>
								</tr>
								<tr>
									<th>URL</th>
									<td>
										<input type="text" class="form-control input-xs border-radius-none" id="host" placeholder="URL" style="width: 313px;">
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="host">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="host">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="host"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>host, host_str</td>
									<td><span class="fa fa-question queryHelp" data-helptext="<s:message code="query.make.multi.message"/>"></span></td>
								</tr>
								<tr>
									<th><s:message code="condition.sender"/></th>
									<td>
										<input type="text" class="form-control input-xs border-radius-none" id="sender" placeholder="<s:message code="condition.sender"/>" style="width: 313px;">
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="sender">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="sender">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="sender"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>sender_str, sname, srcip</td>
									<td><span class="fa fa-question queryHelp" data-helptext="<s:message code="query.make.multi.message"/><br>sender_str:<s:message code="condition.sender"/><br>sname:<s:message code="condition.sender_name"/><br>srcip:<s:message code="condition.source"/>IP"></span></td>
								</tr>
								<tr>
									<th><s:message code="condition.recv"/></th>
									<td>
										<input type="text" class="form-control input-xs border-radius-none" id="receive" placeholder="<s:message code="condition.recv"/>" style="width: 313px;">
									</td>
									<td ><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="receive">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="receive">OR</button></td>
									<td ><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="receive"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>recvs, recvs_name, dstip</td>
									<td ><span class="fa fa-question queryHelp" data-helptext="<s:message code="query.make.multi.message"/><br>recvs:<s:message code="condition.recv"/><br>recvs_name:<s:message code="condition.recv_name"/><br>dstip:<s:message code="condition.destination"/>IP"></span></td>
								</tr>
								<tr>
									<th><s:message code="condition.recv"/><br>(TO, CC, BCC)</th>
									<td>
										<label class="checkbox-inline  input-xs" style="padding-left: 20px">
											<input type="checkbox" class="border-radius-none" name="receiveEtc" value="mail.to.name">
											<span class="fa fa-check"></span><s:message code="condition.to"/>
										</label>
										<label class="checkbox-inline  input-xs">
											<input type="checkbox" class="border-radius-none" name="receiveEtc" value="mail.cc.name">
											<span class="fa fa-check"></span><s:message code="condition.cc"/>
										</label>
										<label class="checkbox-inline  input-xs">
											<input type="checkbox" class="border-radius-none" name="receiveEtc" value="mail.bcc.name">
											<span class="fa fa-check"></span><s:message code="condition.bcc"/>
										</label>
										<input type="text" class="form-control input-xs border-radius-none" id="receiveEctVal" placeholder="<s:message code="condition.recv"/>" style="width: 313px;">
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="receiveEtc">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="receiveEtc">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="receiveEtc"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>to, cc, bcc <br>tname, cname, bname</td>
									<td><span class="fa fa-question queryHelp" data-helptext="<s:message code="query.make.multi.message"/><br>to:<s:message code="condition.to"/><br>cc:<s:message code="condition.cc"/><br>bcc:<s:message code="condition.bcc"/><br>tname:<s:message code="condition.to.name"/><br>cname:<s:message code="condition.cc.name"/><br>bname:<s:message code="condition.bcc.name"/>"></span></td>
								</tr>
								<%if(isOCR) { %>
								<tr>
									<th>OCR</th>
									<td>
										<input type="text" class="form-control input-xs border-radius-none" id="ocr" placeholder="OCR" style="width: 313px;">
									</td>
									<td ><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="ocr">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="ocr">OR</button></td>
									<td ><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="ocr"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>ocr_attach</td>
									<td ><span class="fa fa-question queryHelp" data-helptext="<s:message code="query.make.multi.message"/>"></span></td>
								</tr>
								<%}%>
								<tr>
									<th><s:message code="condition.allofus"/></th>
									<td>
										<select class="selectpicker small border-radius-none" data-style="btn-default" id="allOfus" style="width:100%;" class="border-radius-none'">
											<option value=""><s:message code="condition.allofus.all"/></option>
											<option value="IA">1) <s:message code="condition.allofus1"/></option>
											<option value="EA">2) <s:message code="condition.allofus2"/></option>
											<option value="PA">3) <s:message code="condition.allofus3"/></option>
											<option value="IA EA">4) <s:message code="condition.allofus4"/></option>
											<option value="EA PA">5) <s:message code="condition.allofus5"/></option>
											<option value="IA PA">6) <s:message code="condition.allofus6"/></option>
											<option value="IA IT">7) <s:message code="condition.allofus7"/></option>
											<option value="ET EA">8) <s:message code="condition.allofus8"/></option>
											<option value="PT PA">9) <s:message code="condition.allofus9"/></option>
											<option value="IA ET IT EA">10) <s:message code="condition.allofus10"/></option>
											<option value="IA IT PT PA">11) <s:message code="condition.allofus11"/></option>
											<option value="ET EA PT PA">12) <s:message code="condition.allofus12"/></option>
											<option value="SO">13) <s:message code="condition.allofus13"/></option>
											<option value="SI">14) <s:message code="condition.allofus14"/></option>
										</select>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="allofus">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="allofus">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="allofus"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>allofus</td>
									<td></td>
								</tr>
								<tr>
									<th><s:message code="condition.isattached"/></th>
									<td>
										<div class="form-group">
											<div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
												<label class="btn btn-xs btn-default"><input type="radio" class="border-radius-none" name="attachYn" id="attachYn" value="Y"> <s:message code="condition.exist"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" class="border-radius-none" name="attachYn" id="attachYn" value="N"> <s:message code="condition.none"/></label>
											</div>
											<span id="attachBtnArea">
													<button type="button" class="btn btn-xs btn-default btn-open filterAddBtn" id="attachBtn" disabled="disabled"><span class="glyphicon glyphicon-plus-sign"><s:message code="condition.select"/></span></button>
												</span>
											<span id="attachSelectedArea" class="codeSelectedBtn">
													<button type="button" class="btn" style="z-index: 2">0</button>
												</span>
											<input type="hidden" id="attachStr">
											<input type="hidden" id="attachVal" class="selectedTitle">
										</div>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="attach">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="attach">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="attach"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>attached, attachtype</td>
									<td><span class="fa fa-question queryHelp" data-helptext="attached:Y/N<br>attachtype:<s:message code="codeInfo.navi.title1"/> &gt; <s:message code="codeInfo.navi.title2"/> <s:message code="codeInfo.filetype"/> <s:message code="common.msg.tab"/> <s:message code="common.msg.ext"/>"></span></td>
								</tr>

								<tr>
									<th><s:message code="condition.actual.attachment"/></th>
									<td>
										<s:message code="condition.onemore"/>:AND / <s:message code="condition.none"/>:<s:message code="query.make.except"/>(-)
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="attachexistcnt">AND</button></td>
									<td style="text-align: center;"></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="attachexistcnt"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>attachexistcnt</td>
									<td></td>
								</tr>

								<tr>
									<th>DRM</th>
									<td>
										<s:message code="condition.exist"/>:AND / <s:message code="condition.none"/>:<s:message code="query.make.except"/>(-)
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="drm">AND</button></td>
									<td style="text-align: center;"></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="drm"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>pi_DRM</td>
									<td></td>
								</tr>

								<tr>
									<th><s:message code="condition.keyword"/></th>
									<td>
										<div class="form-group">
											<div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
												<label class="btn btn-xs btn-default"><input type="radio" class="border-radius-none" name="keywordYn" id="keywordYn" value="Y"> <s:message code="condition.exist"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" class="border-radius-none" name="keywordYn" id="keywordYn" value="N"> <s:message code="condition.none"/></label>
											</div>
											<span id="attachBtnArea">
													<button type="button" class="btn btn-xs btn-default btn-open filterAddBtn" id="keywordBtn" disabled="disabled"><span class="glyphicon glyphicon-plus-sign"><s:message code="condition.select"/></span></button>
												</span>
											<span id="keywordSelectedArea" class="codeSelectedBtn">
													<button type="button" class="btn">0</button>
												</span>
											<input type="hidden" id="keywordStr" class="selectedTitle">
											<input type="hidden" id="keywordVal">
										</div>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="keyword">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="keyword">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="keyword"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>kwd, kwds</td>
									<td><span class="fa fa-question queryHelp" data-helptext="kwd:Y/N<br>kwds:<s:message code="condition.keyword"/>"></span></td>
								</tr>

								<tr>
									<th><s:message code="condition.regexp"/></th>
									<td>
										<div class="form-group">
											<div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
												<label class="btn btn-xs btn-default"><input type="radio" class="border-radius-none" name="regexpYn" id="regexpYn" value="Y"> <s:message code="condition.exist"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" class="border-radius-none" name="regexpYn" id="regexpYn" value="N"> <s:message code="condition.none"/></label>
											</div>
											<span id="attachBtnArea">
													<button type="button" class="btn btn-xs btn-default btn-open filterAddBtn" id="regexpBtn" disabled="disabled"><span class="glyphicon glyphicon-plus-sign"><s:message code="condition.select"/></span></button>
												</span>
											<span id="regexpSelectedArea" class="codeSelectedBtn">
													<button type="button" class="btn">0</button>
												</span>
											<input type="hidden" id="regexpStr" class="selectedTitle">
											<input type="hidden" id="regexpVal">
										</div>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="regexp">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="regexp">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="regexp"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>pi_total, pi_XX</td>
									<td><span class="fa fa-question queryHelp" data-helptext="pi_total:pi_total:[1 TO *] / pi_total:0<br>pi_XX:pi_<s:message code="common.msg.regexp"/><s:message code="filterInfo.serviceCode"/> <s:message code="message.msg.example"/>)pi_EF:[ 1 TO * ]"></span></td>
								</tr>

								<tr id="sctTr" style="display: none;">
									<th><s:message code="condition.sct"/></th>
									<td>
										<s:message code="condition.exist"/>:AND / <s:message code="condition.none"/>:<s:message code="query.make.except"/>(-)
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="sct">AND</button></td>
									<td style="text-align: center;"></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="sct"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>pi_sct</td>
									<td></td>
								</tr>

								<tr id="userTr">
									<th><s:message code="common.org.user"/></th>
									<td>
										<input type="text" class="form-control input-xs border-radius-none" id="user" placeholder="<s:message code="common.org.user"/>" style="width: 313px;">
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="user">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="user">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="user"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>user, user_str, userid, name</td>
									<td><span class="fa fa-question queryHelp" data-helptext="<s:message code="query.make.multi.message"/><br>user:<s:message code="query.make.user"/><br>user_str:<s:message code="query.make.user_str"/><br>userid:<s:message code="common.org.user"/>ID<br>name:<s:message code="common.msg.name"/>"></span></td>
								</tr>

								<tr id="userGroupTr">
									<th><s:message code="userGroup.navi.title2"/></th>
									<td>
										<select class="selectpicker small border-radius-none border-radius-none" data-style="btn-default" id="userGroupSeq" multiple>
										</select>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="userGroup">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="userGroup">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="userGroup"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>userid</td>
									<td><span class="fa fa-question queryHelp" data-helptext="userid:<s:message code="common.org.user"/>ID"></span></td>
								</tr>

								<tr id="interUserGroupTr">
									<th><s:message code="condition.interestGroup"/></th>
									<td>
										<select class="selectpicker small border-radius-none border-radius-none" data-style="btn-default" id="interUserGroupSeq" multiple>
										</select>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="interUserGroup">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="interUserGroup">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="interUserGroup"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>userid</td>
									<td><span class="fa fa-question queryHelp" data-helptext="userid:<s:message code="common.org.user"/>ID"></span></td>
								</tr>

								<tr id="recvs_poidTr" display="none">
									<th><s:message code="condition.recv_jikgub"/></th>
									<td>
										<select class="selectpicker small border-radius-none border-radius-none" data-style="btn-default" id="recvs_poid" multiple>
										</select>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="recvs_poid">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="recvs_poid">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="recvs_poid"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>recvs_poid</td>
									<td><span class="fa fa-question queryHelp" data-helptext="recvs_poid:<s:message code="common.org.jikgubcd"/>"></span></td>
								</tr>

								<tr>
									<th><s:message code="filterInfo.size"/></th>
									<td>
										<div  style="float:left;width:320px;">
											<select class="input-xs border-radius-none" id="sizeFilterType" style="padding: 0px;">
												<option value=""><s:message code="condition.size.all"/></option>
												<option value="B"><s:message code="condition.size.body"/></option>
												<option value="A"><s:message code="condition.size.attach"/></option>
											</select>
											<input type="text" class="form-control input-xs border-radius-none" name="lowcount" id="lowcount" style="width: 80px;vertical-align:top;text-align: right;padding: 2px 0px"/>
											<select class="input-xs border-radius-none" data-style="btn-info" id="sizeFilterSelect" style="padding: 0px;">
												<option value="L"><s:message code="condition.over"/></option>
												<option value="S"><s:message code="condition.below"/></option>
												<option value="B"><s:message code="condition.range"/></option>
											</select>
											<input type="text" class="form-control input-xs border-radius-none" name="highcount" id="highcount" style="width: 80px;vertical-align:top;text-align: right;padding: 2px 0px" disabled="disabled"/>
										</div>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="size">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="size">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="size"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>size, body_size, attachsize</td>
									<td><span class="fa fa-question queryHelp" data-helptext="<s:message code="filterInfo.unit"/> : bytes<br>size : <s:message code="condition.size.all"/><br>body_size : <s:message code="condition.size.body"/><br>attachsize : <s:message code="condition.size.attach"/>"></span></td>
								</tr>
								<tr id="epmsgTypeTr">
									<th><s:message code="condition.epmsgType.list"/></th>
									<td>
										<select class="selectpicker small border-radius-none border-radius-none" data-style="btn-default" id="epmsgTypeSelect" multiple>
										</select>
									</td>
									<td><button type="button" class="btn btn-xs btn-success queryAdd" data-queryType="epmsg_type">AND</button></td>
									<td style="text-align: center;"><button type="button" class="btn btn-xs btn-info queryOr" data-queryType="epmsg_type">OR</button></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="epmsg_type"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>epmsg_type</td>
									<td><span class="fa fa-question queryHelp" data-helptext="epmsg_type:<s:message code="condition.epmsgType.list"/>"></span></td>
								</tr>
								<tr id="attachtypeexceptTr" style="display: none;">
									<th><s:message code="query.make.except"/></th>
									<td>
										<s:message code="query.make.except.unknown"/>
									</td>
									<td></td>
									<td style="text-align: center;"></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="attachtypeexcept"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>attachtype</td>
									<td></td>
								</tr>
								<tr id="attachstrexceptTr" style="display: none;">
									<th><s:message code="query.make.except"/></th>
									<td>
										<s:message code="query.make.except.noname"/>
									</td>
									<td></td>
									<td style="text-align: center;"></td>
									<td><button type="button" class="btn btn-xs btn-warning queryMinus" data-queryType="attachstrexcept"><i class="glyphicon glyphicon-minus"></i></button></td>
									<td>attachname_str</td>
									<td></td>
								</tr>
								<tr>
									<th style="font-size:16px;"><s:message code="query.make.query"/></th>
									<td colspan="6">
										<textarea id="solrQueryText"></textarea>
									</td>
								</tr>
								<tr class="not-dashed">
									<td colspan="7" style="padding: 5px 1px 0px 1px !important">
										<div style="text-align: center;">
											<button type="button" class="btn btn-sm btn-primary" accesskey="E" id="queryExecuteBtn" style="font-size:12px;"><i class="glyphicon glyphicon-search"></i>&nbsp;<s:message code="message.msg.excute.query"/></button>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="helpMsg">
							<div style="height:25px;">
								<h5>■ <s:message code="message.msg.struct.query"/> :&nbsp;<span style="color:#FF0000;">&lt;AND/OR&gt;&lt;<s:message code="common.msg.field"/>&gt;:&lt;<s:message code="message.msg.message.input"/>&gt;</span></h5>
							</div>
							<div style="padding-left:10px;">
								<span>● AND/OR</span><br/>
								<span style="padding-left:10px;">AND : + &nbsp;&nbsp;&nbsp;OR : <s:message code="message.msg.space"/></span><br/>
								<span>● <s:message code="common.msg.field"/></span><br/>
								<span style="padding-left:10px;"><s:message code="message.msg.field_name"/>  <s:message code="message.msg.reference"/></span><br/>
								<span>● <s:message code="message.msg.message.input"/></span><br/>
								<span style="padding-left:10px;"><s:message code="message.help.comment1"/></span><br/>
								<span style="padding-left:10px;font-weight: bold;">1. <s:message code="message.help.explain1"/> :<span style="padding-left:10px;color:#FF0000">(<s:message code="message.msg"/>1 <s:message code="message.msg"/>2)</span></span><br/>
								<span style="padding-left:20px;"><s:message code="message.msg.example"/>) +srcip:(1.1.1.1 1.1.1.2)</span>
								<span style="padding-left:20px;"><s:message code="message.help.example1"/></span><br/>
								<div style="border-bottom:1px dashed #ccc;"></div>
								<span style="padding-left:10px;font-weight: bold;">2. <s:message code="message.help.explain2"/> :<span style="padding-left:10px;color:#FF0000">[<s:message code="message.msg"/>1 TO <s:message code="message.msg"/>2]</span></span><br/>
								<span style="padding-left:20px;"><s:message code="message.msg.example"/>) +ctime:[20160101000000 TO 20160102235959]</span><br/>
								<span style="padding-left:20px;"><s:message code="message.help.example2"/></span><br/>
								<div style="border-bottom:1px dashed #ccc;"></div>
								<span style="padding-left:10px;font-weight: bold;">3. <s:message code="message.help.explain3"/> :<span style="padding-left:10px;color:#FF0000">"<s:message code="message.msg"/>"</span></span><br/>
								<span style="padding-left:20px;"><s:message code="message.msg.example"/>) +sname:"<s:message code="message.help.sample_name"/>"</span><br/>
								<span style="padding-left:20px;"><s:message code="message.help.example3"/></span><br/>
								<div style="border-bottom:1px dashed #ccc;"></div>
								<span style="padding-left:10px;font-weight: bold;">4. ?, * <s:message code="message.msg.use"/> :<span style="padding-left:10px;color:#FF0000"><s:message code="message.msg"/>1* <s:message code="message.msg"/>2?</span></span><br/>
								<span style="padding-left:20px;"><s:message code="message.msg.example"/>) +ctime:201601*</span><br/>
								<span style="padding-left:20px;"><s:message code="message.help.example4"/></span><br/>
								<div style="border-bottom:1px dashed #ccc;"></div>
							</div>
							<div>
								<span>■ <s:message code="message.help.example.multi_query"/></span><br/>
								<span style="padding-left:10px;font-weight: bold;">+ctime:201601??09* +(srcip:1.1.1.1 dstip:1.1.1.1)</span><br/>
								<span style="padding-left:10px;"><s:message code="message.help.multi_example1"/> </span><br/>
								<span style="padding-left:10px;"><s:message code="message.help.multi_example2"/></span><br/>
								<span>■ <s:message code="message.help.example.etc_query"/></span><br/>
								<span style="padding-left:10px;font-weight: bold;">+attached:Y</span><br/>
								<span style="padding-left:10px;"><s:message code="message.help.etc_example1"/></span><br/>
								<span style="padding-left:10px;font-weight: bold;">+kwd:Y -sname:<s:message code="message.help.sample_name"/>*</span><br/>
								<span style="padding-left:10px;"><s:message code="message.help.etc_example2"/></span><br/>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"/>
	<input type="hidden" name="oldConm" id="oldConm"/>
</form>
</body>
<script>
	var editor = CodeMirror.fromTextArea(document.getElementById("solrQueryText"), {
		extraKeys: {"Ctrl-Space": "autocomplete"},
		lineNumbers: true,
		mode: 'text/x-solr',
		lineWrapping:true
	});
	editor.setSize("100%", "75px");

</script>

</html>