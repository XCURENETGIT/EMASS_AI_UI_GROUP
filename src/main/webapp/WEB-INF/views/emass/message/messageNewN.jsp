<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<%
boolean mailUseFlag = Config.getBoolean("mail.forward.flag");
String epmsgType = Config.getString("message.epmsg.val");
String epmsgAttach = Config.getString("attach.image.body");
String recvsJikgub = Config.getString("recvs.jikgub.use");
String firstAdminYn = Common.getFirstAdminYn(session);
boolean infoHynixConf = Config.getBoolean("info.hynix.used");
String rsUppercase = Config.getString("receiver.sender.uppercase");
String adminType    = Common.getAdminType(session);
String op_attach_save = Operation.ATTACH_SAVE.getOperation();
String op_body_save = Operation.BODY_SAVE.getOperation();
String op_body_print = Operation.BODY_PRINT.getOperation();

JSONObject param = Common.getParam(request);
String filterSeq = Common.nvl(param.get("filterSeq"));
String conditionParam = Common.nvl(param.get("conditionParam"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LTH</title>

<style type="text/css">
.contentList{
	height:100%;border: 0px;width: 100%;overflow: hidden;border:0px;position: absolute;
}
.contentBody{
	height:100%;border: 0px;width: 100%;border:0px;position: absolute;
}

@media screen and (max-height: 750px) {
	#mainBodyArea .bootstrap-datetimepicker-widget{ top: 200px !important; }
}
@media screen and (max-height: 550px) {
	#mainBodyArea .bootstrap-datetimepicker-widget{ top: 200px !important; }
}

#mainBodyArea .bootstrap-datetimepicker-widget{
	height: 270px !important;
	overflow: hidden !important;
}

.codeSelectedBtn{
	display:inline;left:110%;top:-2px;position:absolute;
}
.codeSelectedBtn .btn{
	font-size: 11px;padding-left:2px;padding-right:2px;
}

.dropdown-menu > li> div{
	float: left;
}

.areaBtn {
	opacity:0.5;cursor:pointer;
}

.areaSelected{
	opacity:1.5 !important;
}

.selectedCnt{
	display: inline-block;
	margin-left: 5px;
}

.expandCollapse{
	display: inline;
    width: 0;
    height: 0;
    margin-right: 5px;
    vertical-align: middle;
    color : #000;
}

.bootstrap-select.btn-group .dropdown-menu.inner {
	padding-top: 10px;
}
.bootstrap-select .dropdown-backdrop {
	pointer-events: none;
}
.dropdown-header {
	line-height: 10px;
}
.dropdown-menu > li > a.hideCollapsedOptGroupElements{
	display:none;
}
/*# sourceMappingURL=bootstrap-select.css.map */


 /* If need to override hideCollapsedOptGroupElements please override it in your specific css files */


.hideCollapsedOptGroupElements{
	position :static !important;
} 

.searchKeywordDiv{
	position: absolute;
	top: 120px;
	background-color: #f4f4f4;
	z-index: 999;
	left: 305px;
	border: 1px solid #ccc;
	width: 400px;
	display:none;
	height:500px;
}
#searchKeywordGrid_statusbar {
	background-color: #fff;
}
.searchKeywordInputType {
	cursor: pointer;
	font-weight: normal;
	margin-right: 5px;
}
.searchKeywordTab{
	height: 25px;
	background-color: #253f56;
	cursor: move;
	color:#fff;
	line-height: 25px;
	padding-left: 10px;
}
.searchKeywordCloseBtn{
	float: right;
	padding-right: 10px;
	padding-left: 10px;
	font-size: 15px;
	cursor:pointer;
}
.searchKeywordCloseBtn:hover{
	opacity: 0.5;
}

.filterHeaderDiv{
	position: absolute;
	top: 120px;
	background-color: #f4f4f4;
	z-index: 999;
	left: 305px;
	border: 1px solid #ccc;
	width: 300px;
	display:none;
	height:500px;
}
.filterHeaderTab{
	height: 25px;
	background-color: #253f56;
	cursor: move;
	color:#fff;
	line-height: 25px;
	padding-left: 10px;
}
.filterCloseBtn{
	float: right;
	padding-right: 10px;
	padding-left: 10px;
	font-size: 15px;
	cursor:pointer;
}
.filterCloseBtn:hover{
	opacity: 0.5;
}

.filterIcon, .queryIcon{
	position: absolute;
	right: 5px;
	top: 95px;
	font-size: 15px;
	border-radius: 15px;
	background-color: #f7da23;
	width: 20px;
	text-align: center;
	cursor:pointer;
}

.listRow{
	border-bottom:1px solid #ccc;height: 35px;line-height:35px;padding: 0 10px;
}
.listRowLeft{
	float:left;
}
.listRowRight{
	float:right;
}

.resultCntSpan{
	float: right;
	height: 100%;
	padding-top: 8px;
	padding-right:15px;
}

.ui-layout-west{
	overflow-y:hidden;
}

.rightGroup {
	float: right;
}
#searchBox {
	position: relative;
	top: 1px;
}
.searchBoxSpan label{
	cursor:pointer;
}
.condition_group {
	text-align: center;
	border-top: 2px solid #ddd;
	border-bottom: 1px solid #e5e5e5;
	padding: 5px 10px;
	font-size: 13px;
	color: #333;
	font-weight: bold;
	cursor: pointer;
	/* background-color: #ebe6e5; */
	background: linear-gradient(to bottom, rgba(249,249,249,1) 0%,rgba(229,229,229,1) 100%);
}
.condition_group > i {
	font-size: 14px;
	position: relative;
	top: 2px;
	float: right;
	font-weight: normal;
	color: #333;
}
#filterNamePopInput {line-height: 14px;}

.queryTextarea{
	width: 260px;height:100%;border: 2px solid #337AB7;padding: 5px 0 0 5px;resize:none;font-size:12px;line-height: 23px;
}

#insaFormatClear:hover,#insaFormatOk:hover{
	font-weight: bold;
	cursor: pointer;
	color: #286090;
}
#messageFormat option:hover{
	background-color: #d4d4d4;
}
.condition_top{
	position: fixed;
	width: 25px;
	background-color: rgba(0, 94, 193, 0.56);
	text-align: center;
	margin-left: 260px;
	z-index: 100000;
	margin-top: 3px;
	-moz-border-radius: 50px;
	-webkit-border-radius: 50px;
	border-radius: 50px;
	height: 25px;
	line-height: 23px;
	font-size: 10px;
	font-weight: bold;
	cursor: pointer;
	color:#fff;
	display: none;
}
.dropdown-menu {
	max-height: 344px !important;
}
.condition_top_sub{
	position: fixed;
	width: 300px;
	background-color: rgba(0, 94, 193, 0.56);
	height: 2px;
	z-index: 100000;
	display: none;
}
#none_btn:hover,#bottom_btn:hover,#right_btn:hover{
	text-decoration: underline;
}
.dropdown-menu.open {
	max-width: 260px !important;
	max-height: 430px !important;
}

#feedbackSetting {
	position: absolute;
	list-style: none;
	border: 1px solid #ccc;
	width: 150px;
	padding-left: 0px;
	top: 21px;
	border-radius: 4px;
	box-shadow: 0px 6px 12px rgba(0,0,0,0.175);
	background-color: #fff;
}

#feedbackSetting a, #feedbackSetting a:hover {
	text-decoration: none;
	display: block;
	width: 100%;
	height: 100%;
	padding: 1px 17px;
	font-weight: 400;
	line-height: 1.4285;
	color: #333;
}

#feedbackSetting a:hover {
	background-color: #f5f5f5;
}

.reset_btn {
	border: 0px;
	background-color: #ccc;
	color: #fff;
	font-weight: bold;
}
#resultTabs .scroll_tab_left_button, #resultTabs .scroll_tab_right_button{
	top:4px !important;
	background-color:#fbfbfb !important;
}
</style>
<script type="text/javascript">
var op_attach_save = '<%=op_attach_save%>';
var op_body_save = '<%=op_body_save%>';
var op_body_print = '<%=op_body_print%>';
var mailUseFlag = <%=mailUseFlag%>;
var firstAdminYn = '<%=firstAdminYn%>';
var adminEmail = '${_USERCREDENTIAL_.adminEmail}';
var msgInfoLayout;
var addTabFlag = false;
var checkMsgCnt = 10000;
var re = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\(\=]/gi;

var filterSeq = '<%=filterSeq%>';
var conditionParam = '<%=conditionParam%>';
var readyFlag = false;
var headerScrollTabs;
var pageType="";
var mode='';
var epmsgType = '<%=epmsgType%>';
var epmsgAttach ='<%=epmsgAttach%>';
var recvsJikgub = '<%=recvsJikgub%>';
var rsUppercase = '<%=rsUppercase%>';
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
		windowTab:'<s:message code="bodyview.window.tab"/>'		
};

var condition = {
		messageInputFilter:'<s:message code="condition.message.input.filter"/>',
		messageInputPeriod:'<s:message code="condition.message.input.period"/>',
		consentMsgTimecheck:'<s:message code="consent.msg.timecheck"/>',
		messageNumbercheck:'<s:message code="condition.message.numbercheck"/>',
		messageFolderFilter:'<s:message code="condition.message.folder.filter"/>',
		messageSelectFolder:'<s:message code="condition.message.select.folder"/>',
		msgSaved:'<s:message code="common.msg.saved"/>',
		selectInterest:'<s:message code="condition.select.interest"/>',
		interestUserAll:'<s:message code="interest.user.all"/>',
		commonMsgAll:'<s:message code="common.msg.all"/>',
		serviceAll:'<s:message code="condition.service.all"/>',
		orgBusiAll:'<s:message code="common.org.busi.all"/>',
		orgDeptAll:'<s:message code="common.org.dept.all"/>',
		msgSelect_all:'<s:message code="common.msg.select_all"/>',
		msgUnselect_all:'<s:message code="common.msg.unselect_all"/>',
		msgNoresult:'<s:message code="common.msg.noresult"/>',
		msgConnectError:'<s:message code="common.msg.connect.error"/>',
		messageSelectDashboard:'<s:message code="condition.message.select.dashboard"/>',
		msgConfirmSave:'<s:message code="common.msg.confirm.save"/>',
		searchService:'<s:message code="condition.search.service"/>',
		delMsgFolderMsg:'<s:message code="filterInfo.delMsgFolderMsg"/>',
		delMsgFoldercomplMsg:'<s:message code="filterInfo.delMsgFoldercomplMsg"/>',
		userGroupNaviTitle2:'<s:message code="userGroup.navi.title2"/>',
		interestGroup:'<s:message code="condition.interestGroup"/>',
		epmsgTypeAll:'<s:message code="condition.epmsgType.all"/>'
};
	

$(document).ready(function() {
	if(consent && firstAdminYn != 'Y'){
	
	}	
	if(epmsgType == "" ){
		$('#epmsgList').hide();
	}else{
		$('#epmsgList').show();
	}


	if(epmsgAttach == ""){
		$('#KnoxAttachYN').hide();
	} else if (epmsgAttach == "" || epmsgAttach == "false"){
		$('#KnoxAttachYN').hide();
	} else if (epmsgAttach == "true"){
		$('#KnoxAttachYN').show();
	}

	
	if(isOCR){
		$('#ocrAttachYn').show();
	}else if (!isOCR){
		$('#ocrAttachYn').hide();
	}
	
	if(recvsJikgub == "true") {
		$('.recvs_jikgub').show();
		getJikgubList();
	}else{
		$('.recvs_jikgub').hide();
	}
	
	$(document).keydown(function(e){if( e.keyCode == 27) hideRMenu();});
	
	$('#searchKeywordSearchBtn').click(function(){getSearchKeywordList( );});
	$('#searchKeywordSearchStr').enter(function(){getSearchKeywordList( );});
	$('#addSearchKeywordBtn').click(function(){insertSearchKeywordList( );});
	$('#delSearchKeywordBtn').click(function(){deleteSearchKeywordList( );});
	
	$('#searchStrInput').autocomplete({ delay : 0,
		source : function(request, response) {
			ui.get({
				url : 'getSearchKeywordAuto.xcn',
				searchKeyword : extractLast(request.term),
				success : function(data, total) {
					var result = [];
					for ( var i = 0; i < data.length; i++) {
						result.push(data[i]['searchKeyword']);
					}
					response(result);
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
				}
			});
		},
		search : function() {
			var term = extractLast(this.value);
			if (term.length < 1) {
				return false;
			}
		},
		focus : function() {
			return false;
		},
		select : function(event, ui) {
			var terms = split(this.value);
			terms.pop();
			terms.push(ui.item.value);
			terms.push("");
			this.value = terms.join("");
			return false;
		}
	});
	function split(val) {
		return val.split(/,\s*/);
	}
	function extractLast(term) {
		return split(term).pop();
	}
	
	$(document).on('click','#exportMsg',function(){
		if( $('#feedbackBtn').css('display') != 'none' ) $('.dropdown-menu.dropdown-menu-left').css('margin-left','90px');
		else $('.dropdown-menu.dropdown-menu-left').css('margin-left','20px');
	});
	
	ui.onBody('msgBody', 0, 0);
	con.init();
	initFilterSetup();
	initFolderSetup();
	getMsgPosition();
	getFilterSearchBox();

	if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ) {
		if(infoHynixConf == 'true'){
			$('#infoFeedbackDiv, #feedbackBtn, #sctDiv').hide();
			$('#secretDocuDiv').show();
		}else{
			$('#infoFeedbackDiv, #feedbackBtn, #sctDiv').show();
			$('#secretDocuDiv').hide();
		}
	}
	else $('#infoFeedbackDiv, #feedbackBtn, #sctDiv').hide();
	
	$('.scrollbar-inner').scrollbar();
	
	$('#searchBtn').click(function(){searchData( );}); //일반 검색 버튼 클릭
	$('#searchQueryBtn').click(function(){toggleSolrQuery();}); //고급 버튼 클릭
	$("#searchStrInput").keypress(function(e){if( e.keyCode == 13) searchData( );}); //통합 검색 엔터키

	var dateObj = new Date();
	$('#startdatepicker').datetimepicker({
		format: 'YYYY-MM-DD HH:mm:ss',
		locale: 'ko',
		sideBySide: true,
		widgetParent:$('#mainBodyArea'),
		defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-7 ) )
	}).on("dp.change", function (e) {
		if( easyDateStartFlag ){
			easyDateStartFlag = false;
			return;
		}else{
			$('#easyDate').val('');
		}
	});
	$('#enddatepicker').datetimepicker({
		format: 'YYYY-MM-DD HH:mm:ss',
		locale: 'ko',
		sideBySide: true,
		widgetParent:$('#mainBodyArea'),
		defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
	}).on("dp.change", function (e) {
		if( easyDateEndFlag ){
			easyDateEndFlag = false;
			return;
		}else{
			$('#easyDate').val('');
		}
	});
	
	$('#easyDate').change(function(){
		changeDate($(this).val());
	});
	$('#sizeOption').change(function(){
		var val = $(this).val();
		if( val == 'B'){
			$('#sizeEndVal').prop('disabled', false);
		}else{
			$('#sizeEndVal').prop('disabled', true);
		}
	});
	
	$('#messageSort').change(function(){
		$('.dropdown-backdrop').click();
	});
	var formatModifyYn = false;

	$('#messageFormat').change(function(){
		confIconHide();
		
		$('#insaFormatInputEx').val('');
		$('#insaFormatInput').val('');
		
		var msgFormatVal = $("#messageFormat option:selected").val();
		var msgFormatValText = $("#messageFormat option:selected").text();
		if(msgFormatVal!='')$('#insaFormatInput').val(msgFormatValText);
		$('#insaFormatInputEx').val(msgFormatVal);
		
	});
	$('#messageFormat').click(function(){
		confIconHide();
		
		$('#insaFormatInputEx').val('');
		$('#insaFormatInput').val('');

		var msgFormatVal = $("#messageFormat option:selected").val();
		var msgFormatValText = $("#messageFormat option:selected").text();
		if(msgFormatVal!='')$('#insaFormatInput').val(msgFormatValText);
		$('#insaFormatInputEx').val(msgFormatVal);
		
	});
	$('#insaFormatClear').click(function(){
		confIconHide();
		
		$('#insaFormatInput').val('');
		$('#insaFormatInputEx').val('');
		$('#insaFormatInput').attr('data-format','');
	});
	$('#insaFormatOk').click(function(){
		confIconHide();
		
		var msgFormatValText = $("#messageFormat option:selected").text();
		var insaFormatInputVal = $('#insaFormatInput').val();
		if(msgFormatValText != insaFormatInputVal){
			$("#insaFormatInputEx").val("");
			$("#messageFormat").val("");
			$("#messageFormat").focus();
			var customInsaFormatInputVal = $('#insaFormatInput').val();
			customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('name','<s:message code="message.help.sample_name"/>');
			customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('email','hong@xcurent.com');
			customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('businm','<s:message code="message.help.sample_bunm"/>');
			customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('deptnm','<s:message code="message.help.sample_deptnm"/>');
			customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('jikgubnm','<s:message code="message.help.sample_jikgubnm"/>');
			customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('ip','192.168.0.1');
			customInsaFormatInputVal = customInsaFormatInputVal.replaceAll(' ','');
			customInsaFormatInputVal = '<s:message code="message.help.example"/>) '+customInsaFormatInputVal
			$("#insaFormatInputEx").val(customInsaFormatInputVal)
			
		}
		var formatArr = ['name','email','businm','deptnm','jikgubnm','ip'];
		var insaFormatstr = insaFormatInputVal;
		for (var i = 0; i < formatArr.length; i++) {
			var val = formatArr[i];
			var idx = insaFormatstr.indexOf(val);
			if(insaFormatstr.indexOf(val)>-1){
				insaFormatstr = insaFormatstr.substring(0,idx) + insaFormatstr.substring(idx+val.length,insaFormatstr.length);
			}
		}
		var err = 0; 
		if(insaFormatInputVal == '') err++;
		for (var i=0; i<insaFormatstr.length; i++)  { 
			var chk = insaFormatstr.substring(i,i+1); 
			if(chk.match(/[0-9]|[a-z]|[A-Z]|[\u3131-\u314e|\u314f-\u3163|\uac00-\ud7a3]/)) {
				err++; 
			}
		}
		if (err > 0) {
			$('#confError').show();	
			$('#insaFormatInput').css('width','310px');
			$('#insaFormatInput').animate({'background-color':'#f0ad4e',duration: '500'},
				function() {
					$('#insaFormatInput').animate({'background-color':'#fff',duration: '500'});
				});
			return;
		}else{
			$('#confError').hide();	
			$('#insaFormatInput').css('width','330px');
		}
		insaFormatInputVal = insaFormatInputVal.replaceAll(' ','');
		insaFormatInputVal = insaFormatInputVal.replaceAll('name','#name#');
		insaFormatInputVal = insaFormatInputVal.replaceAll('email','#email#');
		insaFormatInputVal = insaFormatInputVal.replaceAll('businm','#businm#');
		insaFormatInputVal = insaFormatInputVal.replaceAll('deptnm','#deptnm#');
		insaFormatInputVal = insaFormatInputVal.replaceAll('jikgubnm','#jikgubnm#');
		insaFormatInputVal = insaFormatInputVal.replaceAll('ip','#ip#');
		setConfAdmin('message.user.format',insaFormatInputVal);
	});
	$("#config_toggle").click(function(){
		 if(!$('#config_toggle').parent().hasClass('open')){
		 	getFormatVal();
		 }
	});
	
	$('#feedbackBtn').click(function(){
		if( $('#feedbackSetting').css('display') == 'block' ) {
			$('#feedbackSetting').hide();
			$('#overlay').hide();
		}
		else if ( $('#feedbackSetting').css('display') == 'none' ) {
			$('#feedbackSetting').show();
			$('#overlay').show();
		}
	});
	
	$('[name=subjectbody]').click(function(){
		var val = $(this).is(':checked') == true ? 'Y' : 'N';
		setConfAdminOption('body.snippet.sum.use', val);
	});
	
	$('[name=summary]').click(function(){
		var val = $(this).is(':checked') == true ? 'Y' : 'N';
		if(val == 'N') {
			ui.confirmMsg('<s:message code="common.msg.search.warning" />', '', '', function(rs){
				if(rs){
					setConfAdminOption('toccbcc.sum.use', val);
				}else {
					$('[name=summary]').prop('checked', true);
				}
			});
		} else {
			setConfAdminOption('toccbcc.sum.use', val);
		}
	});
	
	$('[name=overlapUse]').click(function(){
		var val = $(this).is(':checked') == true ? 'Y' : 'N';
		setConfAdminOption('message.overlap.use', val);
	});
	
	$('[name=keywordHighlight]').click(function(){
		var val = $(this).is(':checked') == true ? 'Y' : 'N';
		setConfAdminOption('message.keyword.highlight', val);
	});

	$('[name=hostQuery]').click(function(){
		var val = $(this).is(':checked') == true ? 'Y' : 'N';
		setConfAdminOption('host.query.use', val);
	});
	
	$(document).click(function(e) {
		if(! ($(e.target).is('#feedbackSetting') || $(e.target).is('#feedbackBtn')) ) {
			$('#feedbackSetting').hide();
			$('#overlay').hide();
		}
	});

	$('#none_btn').click(function(){
		if(msgInfoLayout != undefined) msgInfoLayout.destroy();
		msgInfoLayout = $('#mainBodyArea').layout({
			west__size: 300,
			west__maxSize: 300,
			west__maskContents:  true,
			west__spacing_open:3,
			center__maskContents:  true,
			// INNER-LAYOUT (child of middle-center-pane)
			center__childOptions: {
				center__paneSelector: ".inner-center",
				center__maskContents:  true,
				east__paneSelector: ".inner-east",
				east__maskContents:  true,
				east__size: 0,
				east__spacing_open:3,
				north__spacing_open:0
			},
			center__onresize: function(pane, $pane, state, options) {
			}
		});
		
		$('.areaBtn').removeClass('areaSelected');
		$(this).addClass('areaSelected');
		
		setConfAdmin('msgPosition', 'N');
		$('.dropdown-backdrop').click();
	});
	$('#bottom_btn').click(function(){
		if(msgInfoLayout != undefined) msgInfoLayout.destroy();
		msgInfoLayout = $('#mainBodyArea').layout({
			west__size: 300,
			west__maxSize: 300,
			west__maskContents:  true,
			west__spacing_open:3,
			center__maskContents:  true,
			// INNER-LAYOUT (child of middle-center-pane)
			center__childOptions: {
				center__paneSelector: ".inner-center",
				center__maskContents:  true,
				south__paneSelector: ".inner-east",
				south__maskContents:  true,
				south__size: 400,
				south__spacing_open:3,
				north__spacing_open:0
			},
			center__onresize: function(pane, $pane, state, options) {
			}
		});
		
		$('.areaBtn').removeClass('areaSelected');
		$(this).addClass('areaSelected');
		
		setConfAdmin('msgPosition', 'B');
		$('.dropdown-backdrop').click();
	});
	
	$('#right_btn').click(function(){
		if(msgInfoLayout != undefined) msgInfoLayout.destroy();
		msgInfoLayout = $('#mainBodyArea').layout({
			west__size: 300,
			west__maxSize: 300,
			west__maskContents:  true,
			center__maskContents:  true,
			west__spacing_open:3,
			// INNER-LAYOUT (child of middle-center-pane)
			center__childOptions: {
				center__paneSelector: ".inner-center",
				center__maskContents:  true,
				center__spacing_open:3,
				east__paneSelector: ".inner-east",
				east__maskContents:  true,
				east__size: 680,
				east__spacing_open:3,
				north__spacing_open:0
			},
			center__onresize: function(pane, $pane, state, options) {
			}
		});
		
		$('.areaBtn').removeClass('areaSelected');
		$(this).addClass('areaSelected');
		
		setConfAdmin('msgPosition', 'R');
		$('.dropdown-backdrop').click();
	});
	
	$("#searchBox").change(function(){
		var value = 'N';
		if($("#searchBox").is(":checked")){
			value = 'Y';
		}
		setConfAdmin('filterSearchBox', value);
	});
	
	$('.list_icon').click(function(){
		$('#mainBodyArea').layout().toggle('west');
	});
	
	$('.display_none').click(function(){
		if( $(this).find('i').hasClass('fa-plus-square') ) $(this).find('i').removeClass('fa-plus-square').addClass('fa-minus-square');
		else $(this).find('i').removeClass('fa-minus-square').addClass('fa-plus-square');
		$(this).next().toggle();
	});

	$(document).on('mousedown', '#resultTabs .scroll_tab_inner .tab_li', function(e){
		if($(this).attr('data-index') == '0' || $(this).attr('id') == undefined) return;
		if( e.which == 2 ) {
			var changeObj = delTab($(this));
			changeTab(changeObj);
		}
	});
	$(document).on('keyup', '.condition_input_text', function(e){
		if($(this).val() == ''){
			$(this).parent().find('input:checkbox').prop('disabled', true);
			$(this).parent().find('input:checkbox').attr('checked', false);
		}else{
			$(this).parent().find('input:checkbox').prop('disabled', false);
		}
	});
	$('input:radio:not([name=searchKeywordInputType])').click(function(){
		if($(this).val()=='Y'){
			$(this).parent().parent().parent().find('.button_style').prop('disabled', false);
			
			if($(this).attr('name')=='attachYn'){
				$('input:radio[name=realAttYn]').prop('disabled', false);
				$('input:radio[name=drmYn]').prop('disabled', false);
			}
		}else if($(this).val()==''){
			var codeType = $(this).parent().parent().parent().find('.button_style').attr('id');
			if(codeType != undefined ){
				codeType = codeType.substring(0, codeType.length-3);
				resetCode(codeType);
			}
			$(this).parent().parent().parent().find('.button_style').prop('disabled', true);
			$(this).parent().parent().parent().find('input:checkbox').prop('disabled', true);
			$(this).parent().parent().parent().find('input:checkbox').attr('checked', false);
			
			if($(this).attr('name')=='attachYn'){
				$('input:radio[name=realAttYn]').prop('disabled', true);
				$('input:radio[name=drmYn]').prop('disabled', true);
				$('input:radio[name=realAttYn]:input[value=' + idIndicator('') + ']').prop("checked", true);
				$('input:radio[name=drmYn]:input[value=' + idIndicator('') + ']').prop("checked", true);
			}
		}else{
			var codeType = $(this).parent().parent().parent().find('.button_style').attr('id');
			if(codeType != undefined ){
				codeType = codeType.substring(0, codeType.length-3);
				resetCode(codeType);
			} 
			$(this).parent().parent().parent().find('.button_style').prop('disabled', true);
			$(this).parent().parent().parent().find('input:checkbox').prop('disabled', true);
			$(this).parent().parent().parent().find('input:checkbox').attr('checked', false);
			
			if($(this).attr('name')=='attachYn'){
				$('input:radio[name=realAttYn]').prop('disabled', true);
				$('input:radio[name=drmYn]').prop('disabled', true);
				$('input:radio[name=realAttYn]:input[value=' + idIndicator('') + ']').prop("checked", true);
				$('input:radio[name=drmYn]:input[value=' + idIndicator('') + ']').prop("checked", true);
			}
		}
		
		if( $(this).attr('name') == 'receive_option'){
			if($(this).val()==''){
				$('.receivers_detail').hide();
				$('#receivers').parent().show();
			}else{
				$('#receivers').parent().hide();
				$('.receivers_detail').show();
			}
		}
	});
	
	$('input:radio').each(function(){
		if($(this).val()=='Y'){
			$(this).parent().parent().parent().find('.button_style').prop('disabled', false);
		}else if($(this).val()==''){
			$(this).parent().parent().parent().find('.button_style').prop('disabled', true);
		}else{
			$(this).parent().parent().parent().find('.button_style').prop('disabled', true);
		}
	});
	$('.filter_menu').click(function(){
		if($(this).hasClass('condition_menu_unselected')){
			$('.filter_menu').addClass('condition_menu_unselected');
			$(this).removeClass('condition_menu_unselected');
			if($(this).attr('id')=='msg_condition_menu'){
				$('#saveFilterTab').hide();
				$('#message_folderTab').hide();
				$('#search_top_area').show();
				
			}else if($(this).attr('id')=='msg_condition_saver'){
				$('#search_top_area').hide();
				$('#message_folderTab').hide();
				$('#saveFilterTab').show();
			}else{
				$('#search_top_area').hide();
				$('#saveFilterTab').hide();
				$('#message_folderTab').show();
			}
		}
		
		$('#periodSetupMenu').hide();
	});
	//tab click
	$(document).on('click', '.addTabDiv, .resultCntSpan', function(){
		clickHeader($(this));
	});
	
	$('.showSearchKeywordBtn').click(function(){
		$('#searchKeywordDiv').show();
	});
	
	$('.showFilterBtn').click(function(){
		$('#periodSetupMenu').hide();
		$('#filterHeaderDiv').show();
	});
	$('.resetCondition').click(function(){
		/* if(!$('#msg_condition_menu').hasClass('condition_menu_unselected')){
			con.resetFilter('');
		} */
		con.resetFilter('');
	});
	$('.saveCondition').click(function(){
		if(!$('#msg_condition_menu').hasClass('condition_menu_unselected')){
			$('#periodSetupPop').show();
			$('#periodSetupDatePop').show();
			$('#periodSetupMenu').css('height', '230px');
		}
		else if(!$('#msg_condition_saver').hasClass('condition_menu_unselected')){
			if($('#solrQueryText').val()==''){
				alert('<s:message code="query.make.input"/>');
				$('#solrQueryText').focus();
				return;
			}
			$('#periodSetupPop').hide();
			$('#periodSetupDatePop').hide();
			$('#periodSetupMenu').css('height', '155px');
		}
		
		if((!$('#msg_condition_menu').hasClass('condition_menu_unselected') && $('.filterIcon').hasClass('hide') )|| (!$('#msg_condition_saver').hasClass('condition_menu_unselected') && $('.queryIcon').hasClass('hide') )){
			
			if(!$('#msg_condition_menu').hasClass('condition_menu_unselected')){
				$('#startdatepickerPop').data("DateTimePicker").date($('#startdatepicker').data("DateTimePicker").date());
				$('#enddatepickerPop').data("DateTimePicker").date($('#enddatepicker').data("DateTimePicker").date());
			}
		}else{
			var filterTree = $.fn.zTree.getZTreeObj("filterTree");
			var treeNode;
			
			if( !$('#msg_condition_menu').hasClass('condition_menu_unselected') ){
				$('#filterNamePopInput').val($('.filterIcon').attr('title'));
				treeNode = filterTree.getNodeByParam("id", $('.filterIcon').attr('data-id'), null);
			}else if(!$('#msg_condition_saver').hasClass('condition_menu_unselected')){
				$('#filterNamePopInput').val($('.queryIcon').attr('title'));
				treeNode = filterTree.getNodeByParam("id", $('.queryIcon').attr('data-id'), null);
			}
			
			$('#filterOptionPopSelect').val(treeNode.userDtCd);
			if(treeNode.userDtCd == 1){
				$('#startdatepickerPop').data("DateTimePicker").date(treeNode.startDt.toDate());
				$('#enddatepickerPop').data("DateTimePicker").date(treeNode.endDt.toDate());
			}else if(treeNode.userDtCd == 2){
				var dateObj = new Date();
				$('#startdatepickerPop').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-treeNode.startDt, 00, 00, 00 ) );
				$('#enddatepickerPop').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-treeNode.endDt, 23, 59, 59 ) );
			}else if(treeNode.userDtCd == 3){
				
			}
			
		}
		$('#periodSetupMenu').show();
	});
	
	$('#saveMsgData').click(function(){
		saveFolderDataGrid( getIframeListObj().grid );
	});
	
	$('.searchKeywordCloseBtn').click(function(){
		$('#searchKeywordDiv').hide();
	});
	
	$('.filterCloseBtn').click(function(){
		$('#filterHeaderDiv').hide();
	});
	
	$('#periodSetupMenuCloseBtn').click(function(){
		$('#periodSetupMenu').hide();
	});
	
	$("#searchKeywordDiv").draggable({
		scroll: false,
		containment: "#mainBodyArea",
		start: function( event, ui ) {
			$('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
			$('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
		},
		stop: function( event, ui ) {
			$('#contentListArea').css({pointerEvents:'', 'user-select':''});
			$('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
		}
	});
	
	$("#filterHeaderDiv").draggable({
		cancel: ".filterSearch, .saveFilterTab_tree", 
		scroll: false,
		containment: "#mainBodyArea",
		start: function( event, ui ) {
			$('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
			$('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
		},
		stop: function( event, ui ) {
			$('#contentListArea').css({pointerEvents:'', 'user-select':''});
			$('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
		}
	});
	
	$("#searchHelpDiv").draggable({
		cancel: ".searchHelpDivBody, .searchHelpDivCloseArea", 
		scroll: false,
		containment: "#mainBodyArea",
		start: function( event, ui ) {
			$('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
			$('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
		},
		stop: function( event, ui ) {
			$('#contentListArea').css({pointerEvents:'', 'user-select':''});
			$('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
		}
	});
	
	$("#periodSetupMenu").draggable({ 
		cancel: ".filterDatePopArea, .filterDateBtnPopArea, .filterDateCloseBtn, input-group-addon", 
		scroll: false,
		containment: "#mainBodyArea",
		start: function( event, ui ) {
			$('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
			$('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
		},
		stop: function( event, ui ) {
			$('#contentListArea').css({pointerEvents:'', 'user-select':''});
			$('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
		}
	});
	
	$("#searchKeywordDiv").resizable({
		maxWidth: 500,
		minHeight: 200,
		minWidth: 300,
		containment: "#mainBodyArea",
		start: function( event, ui ) {
			$('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
			$('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
		},
		stop: function( event, ui ) {
			$('#contentListArea').css({pointerEvents:'', 'user-select':''});
			$('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
		}
	});
	
	$("#filterHeaderDiv").resizable({
		maxWidth: 300,
		minHeight: 200,
		minWidth: 210,
		containment: "#mainBodyArea",
		start: function( event, ui ) {
			$('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
			$('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
		},
		stop: function( event, ui ) {
			$('#contentListArea').css({pointerEvents:'', 'user-select':''});
			$('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
		}
	});
	
	$('.filterIcon, .queryIcon').click(function(){
		$(this).addClass('hide');
		$(this).attr('title', '');
		$(this).attr('data-id', '');
	});
	$(document).on('click', '.viewSetup .dropdown-menu, .bootstrap-select .dropdown-menu', function (e) {
	//$(document).on('click', '.viewSetup .dropdown-menu', function (e) {
		e.stopPropagation();
	});
	
	$(document).on('click', '.all_down_link', function(){
		var searchType = $(this).attr('data-type');
		$('#searchType').val(searchType);
		var title = $(this).text();
		$('#exportTitle').text(title+' '+'<s:message code="common.msg.export"/>');
		
		$('#exportDialog').modal('show');
	});
	
	$("#exportDialog").on('show.bs.modal', function() {
		$('input:radio[name=exportDataRange]:input:checked').prop("checked", false);
		
		var grid = getIframeListObj().grid;
		var rows = grid.getSelectedKey('msgid').length;
		var total = grid.data.length;
		
		if(total == 0){
			ui.alertMsg('<s:message code="common.msg.nodata"/>');
			return false;
		}
		
		var searchType = $('#searchType').val();
		var consentNo = grid.getValue(0, 'consentNo');
		if( searchType != 'L'){
			if(isConsent( ) && consentNo == '' && '<%=adminType%>' != 'C'){
				alert('<s:message code="download.msg.consent"/>');
				return false;
			}
		}
		
		if(searchType != "L" && searchType.indexOf('L') > -1) {
			if($('input:radio[name=exportFileType]:input:checked').val() == "xlsx") {
				$("input:radio[name='bodyInExcel']:radio[value='N']").prop("checked", true);
				$('#bodyInExcel').show();
				$('#bodyInExcelMsg').hide();
				$('#bodyInExcelIdx').hide();
			}else {
				$('#bodyInExcel').hide();
				$('#bodyInExcelMsg').hide();
				$('#bodyInExcelIdx').hide();
			}
		} else {
			$('#bodyInExcel').hide();
			$('#bodyInExcelMsg').hide();
			$('#bodyInExcelIdx').hide();
		}
		
		
		$('#searchTime').val('');
		$('#searchCondition').val('');
		$('#searchHeader').val('');
		$('#searchTotal').val('');
		$('#dataLength').val('');
		$('#exportFileExt').val('');
		
		if( (rows > checkMsgCnt) || (rows == 0 && grid.data.length > checkMsgCnt)){
			$('input:radio[name=exportDataRange]:input[value=A]').parent().click();
		}else{
			$('input:radio[name=exportDataRange]:input[value=S]').parent().click();
		}
	});
	
	$( 'input[name="exportDataRange"]:radio' ).change(function(){
		var grid = getIframeListObj().grid;
		var rows = grid.getSelectedKey('msgid').length;
		var total = getIframeListObj().$('#busiCntArea').find('.tab_selected').find('.busiCnt').text();
		total = total.replace(re,"")
		var downTotal = total;
		var exportDataRange = $(this).val();
		if( exportDataRange == 'S'){
			$('#sizeWarnMsg').hide();
			
			if( rows > 0) downTotal = rows;
			else downTotal = grid.data.length;
			
			if( downTotal > checkMsgCnt){
				ui.alertMsg('<s:message code="download.message.check.total" arguments="'+addCommas(checkMsgCnt)+'" argumentSeparator="|"/>');
				$('input:radio[name=exportDataRange]:input[value=A]').parent().click();
				return;
			}
		}
		
		var searchType = $('#searchType').val();
		if( searchType.indexOf('L') > -1){
			$('#exportFileTypeArea').show();
			if(downTotal > 50000){
				$('#sizeWarnMsg').show();
			}else{
				$('#sizeWarnMsg').hide();
			}
		}
		else {
			$('#exportFileTypeArea').hide();
			$('#sizeWarnMsg').hide();
		}
		$('#exportDataSize').text(addCommas(downTotal));
		$('#searchTotal').val(downTotal);
	});
	
	$('input[name="exportFileType"]:radio').change( function() {
		var searchType = $('#searchType').val()
		
		if(searchType != "L" && searchType.indexOf('L') > -1) {
			if($(this).val() == "xlsx") {
				$("input:radio[name='bodyInExcel']:radio[value='N']").prop("checked", true);
				$('#bodyInExcel').show();
				$('#bodyInExcelMsg').hide();
				$('#bodyInExcelIdx').hide();
			}else {
				$('#bodyInExcel').hide();
				$('#bodyInExcelMsg').hide();
				$('#bodyInExcelIdx').hide();
			}
		} else {
			$('#bodyInExcel').hide();
			$('#bodyInExcelMsg').hide();
			$('#bodyInExcelIdx').hide();
		}
	});
	
	$('input[name="bodyInExcel"]:radio').change( function() {
		if($(this).val() == "Y") {
			$('#bodyInExcelMsg').show();
			var col = JSON.parse(getIframeListObj().grid.getHeaderEXCEL());
			var colStr = col.map(function(i) { return i.title });
			$('#nowColIdx').html(setNowColIdx(colStr));
			$('#bodyInExcelIdx').show();
		}else {
			$('#bodyInExcelMsg').hide();
			$('#bodyInExcelIdx').hide();
		}
	});
	
	$(document).on('click', '.print_link_new', function(){
		var grid = getIframeListObj().grid;
		var title = $(this).attr('rel');
		if (grid.data.length == 0) {
			alert('<s:message code="common.msg.nodata"/>');
			return;
		}
		
		grid.print(title, pMenuId, menuId);
	});
	$('#allDownBtn').click(function(){
		var grid = getIframeListObj().grid;
		var rows = grid.getSelectedKey('msgid').length;
		var total = getIframeListObj().$('#busiCntArea').find('.tab_selected').find('.busiCnt').text();
		total = total.replace(re,"")
		grid.on();
		var bodyInExcel = $('input:radio[name=bodyInExcel]:input:checked').val();
		var header = grid.getHeaderEXCEL();
		if(bodyInExcel == "Y") {
			header = JSON.parse(header);
			header.splice($('#nowColIdx').val(),0,{"key":"body","title":"<s:message code='condition.body' />","width":410,"align":"left"});
			header = JSON.stringify(header);
		}
		var param = JSON.stringify( getIframeListObj().filterValData );
		var dataLength = $('#dataLength_select').selectpicker('val');
		var searchType = $('#searchType').val();
		var exportFileType = $('input:radio[name=exportFileType]:input:checked').val();
		var exportDataRange = $('input:radio[name=exportDataRange]:input:checked').val();
		
		$('#searchTime').val(getIframeListObj().$('#searchTime').val());
		$('#searchCondition').val(param);
		$('#searchHeader').val(header);
		$('#dataLength').val(dataLength);
		$('#exportFileExt').val(exportFileType);
		
		if( exportDataRange == 'A'){
			//중복체크
			ui.get({
				url : 'checkDownloadBatchExist.xcn',
				searchCondition : param,
				searchTotal : $('#searchTotal').val(),
				searchType : searchType,
				exportFileExt : exportFileType,
				success : function(data, total) {
					if(data > 0) {
						downloadBatchExist = true;
					} else {
						downloadBatchExist = false;
					}
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
					if(downloadBatchExist) {
						ui.alertMsg('<s:message code="download.msg.exist" />');
					} else {
						$('#isBackground').val('Y');
						if( searchType == 'B'){
							$('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveBatchZip.xcn"/>');
							$('#allDownForm').submit();
						}else if(searchType == 'A' ){
							$('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveBatchZip.xcn"/>');
							$('#allDownForm').submit();
						}else if(exportFileType == 'xlsx' || exportFileType == 'cell'){
							$('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveBatchZip.xcn"/>');
							$('#allDownForm').submit();
						}else if(exportFileType == 'csv'){
							$('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveBatchCSV.xcn"/>');
							$('#allDownForm').submit();
						}else if(exportFileType == 'pdf'){
							$('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveBatchPDF.xcn"/>');
							$('#allDownForm').submit();
						}
					}
				}
			});
			
		}else{
			$('#isBackground').val('N');
			if( searchType == 'B'){
				$('.body_link_new').click();
			}else if(searchType == 'A' ){
				$('.attach_link_new').click();
			}
			else if(searchType == 'LB' || searchType == 'LBA' ){
				var msgids = grid.getSelectedKey('msgid');
				if( msgids.length == 0 ){
					msgids = grid.getKeyData('msgid');
				}
				var selected_condition = {};
				selected_condition.msgids = msgids;
				selected_condition.sort = $('#messageSort').val();
				
				$('#searchCondition').val(JSON.stringify( selected_condition ));
				$('#searchTotal').val(msgids.length);
				
				if(exportFileType == 'xlsx' || exportFileType == 'cell'){
					$('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveZip.xcn"/>');
					$('#allDownForm').submit();
				}else if(exportFileType == 'csv'){
					$('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveCSV.xcn"/>');
					$('#allDownForm').submit();
				}else if(exportFileType == 'pdf'){
					$('#allDownForm').attr('action', '<c:url value="/getEmassMessageSavePDF.xcn"/>');
					$('#allDownForm').submit();
				}
			}else{
				if(exportFileType == 'xlsx'){
					$('.excel_link_new').click();
				}else if(exportFileType == 'cell'){
					$('.cell_link_new').click();
				}else if(exportFileType == 'csv'){
					$('.csv_link_new').click();
				}else if(exportFileType == 'pdf'){
					$('.pdf_link_new').click();
				}
			} 
		}
		
		$('#exportDialog').modal('hide');
		setTimeout(function(){
			grid.off();
		}, 500);
	});
	$(document).on('click', '.excel_link_new', function(){
		var grid = getIframeListObj().grid;
		var title = $(this).attr('rel');
		var option = $(this).attr('option');
		grid.on();
		setTimeout(function(){
			excelDownLoad(grid, title, null, null, option);
		}, 200);
	});
	$(document).on('click', '.cell_link_new', function(){
		var grid = getIframeListObj().grid;
		var title = $(this).attr('rel');
		var option = $(this).attr('option');
		grid.on();
		setTimeout(function(){
			cellDownLoad(grid, title, null, null, option);
		}, 200);
	});
	
	$(document).on('click', '.pdf_link_new', function(){
		var grid = getIframeListObj().grid;
		var title = $(this).attr('rel');
		var option = $(this).attr('option');
		grid.on();
		setTimeout(function(){
			pdfDownLoad(grid, title, null, null, option);
		}, 200);
	});
	$(document).on('click', '.csv_link_new', function(){
		var grid = getIframeListObj().grid;
		var title = $(this).attr('rel');
		var option = $(this).attr('option');
		grid.on();
		setTimeout(function(){
			csvDownLoad(grid, title, null, null, option);
		}, 200);
	});
	$(document).on('click', '.body_link_new', function(){
		var grid = getIframeListObj().grid;
		if (grid.Rows == 0) {
			alert('<s:message code="common.msg.nodata"/>');
			return;
		}

		grid.on();
		setTimeout(function(){
			var msgid = grid.getSelectedKey('msgid');
			if(msgid.length == 0) msgid = grid.getKeyData('msgid');
			
			$('#msgId').val('');
			$('#msgIds').val('');
			if(msgid.length==1){
				$('#msgId').val(msgid.join(','));
				$('#downForm').attr('action', '<c:url value="/getEmassBodySave.xcn"/>');
			} else {
				$('#msgIds').val(msgid.join(','));
				$('#downForm').attr('action', '<c:url value="/getEmassBodySaveZip.xcn"/>');
			}
			$('#downForm').submit();
			grid.off();
		}, 300);
	});
	$(document).on('click', '.attach_link_new', function(){
		var grid = getIframeListObj().grid;
		if (grid.Rows == 0) {
			alert('<s:message code="common.msg.nodata"/>');
			return;
		}
		grid.on();
		setTimeout(function(){
			var msgid = grid.getSelectedKey('msgid');
			if(msgid.length == 0) msgid = grid.getKeyData('msgid');
			
			$('#msgIds').val(msgid.join(','));
			$('#downForm').attr('action', '<c:url value="/downEmassAttachByMsgId.xcn"/>');
			$('#downForm').submit();
			grid.off();
		}, 300);
	});
	$(document).on('click', '.downList', function(){
		var url    = '<c:url value="/commons/downList.do"/>';
		fnOpenWindow(url, 'downInfoPop', 1400, 580, 'resize');
	});
	$('.searchQueryBtn').click(function(){
		queryMakePop();
	});
	$("#config_colse").click(function(){
		$("#config_toggle").click();
	});
	$('#searchHelpBtn').click(function(e){
		$('#searchHelpDiv').css('left', '305px');
		$('#searchHelpDiv').css('top', '230px');
		$('#searchHelpDiv').show();
	});
	$('#searchHelpDivCloseBtn').click(function(){
		$('#searchHelpDiv').hide();
	});
	
	readyCheckParam();
	$('#condition_detail').scroll(function(){
		if($(this).scrollTop()>70){
			$('.condition_top').fadeIn();
			$('.condition_top_sub').fadeIn();
		}else{
			$('.condition_top').fadeOut();
			$('.condition_top_sub').fadeOut();
		}
	});
	$($('.condition_top')).click(function(){
	   $('#condition_detail').animate({
	        scrollTop: $('#condition_detail').offset().top-206
	    }, 200);
	});
	
	initHeaderTab();
	getSearchKeywordList();
	initConfAdminOption();
});
	
function setNowColIdx(colStr) {
	var result = "";
	for(var i=0; i<colStr.length; i++) {
		result += '<option value="' + (i+1) + '">' + colStr[i] + '</option>';
	}
	
	return result;
}

function readyCheckParam(){
	if(readyFlag){
		checkParam( );
	}else{
		setTimeout(function(){
			readyCheckParam( );
		}, 500);
	}
}

function checkParam(){
	if( filterSeq === 0 || (filterSeq == '' && conditionParam == '')) return;

	else if( filterSeq != ''){		
		var data = zTree.getNodeByParam("id", filterSeq);
		if( data == undefined ){
			alert("<s:message code="common.msg.connect.error"/>");
			//화면을 대쉬보드로 이동 시킴
			goMainPage();
			return;
		}
		if( data.conditions == '') return;
		
		var filterVal = {};
		if(data.filterType == 'D'){
			filterVal.conditions = JSON.parse(data.conditions);
			rtnFilterClick(filterVal, 'searchCondition');
		}else{
			var newTreeNode = $.extend(true, {}, data);
			newTreeNode.filterName = newTreeNode.name;
			newTreeNode.filter_seq = newTreeNode.id;
			newTreeNode.p_filter_seq = newTreeNode.pId;
			newTreeNode.filterType = newTreeNode.filterType;
			
			var conditions = [];
			var condition = {};
			condition.period = newTreeNode.userDtCd;
			condition.startDt = newTreeNode.startDt;
			condition.endDt = newTreeNode.endDt;
			condition.query = createSolrQuery(condition.period, condition.startDt, condition.endDt, newTreeNode.conditions);
			conditions.push(condition);
			newTreeNode.conditions = conditions;
	
			rtnFilterClick(filterVal, 'searchQuery');
		}
	}else if( conditionParam != '' ){
		try{
			setTimeout(function(){
				con.setCondition(JSON.parse(conditionParam), '');
				getIframeListObj().initGrid();
				searchData( );
			},500);
		}catch(e){
			console.log(e)
			console.log('<s:message code="common.msg.data.error"/>');
			//goMainPage();
		}
	}
}

function clickHeader(obj){
	
	if($(obj).parents('li').hasClass('select')) return;
	
	var index = $(obj).parents('li').attr('data-index');
	if(index == ''){
		if( addTabFlag ) return;
		con.resetFilter('');
		addTab();
		return;
	}
	con.resetFilter('');
	changeTab($(obj));
}

//일반 검색
function searchData( ){
	//체크로직 및 분기
	getList('D');
}

//고급 검색식 검색
function toggleSolrQuery(){
	if($('#solrQueryText').val() == ''){
		alert('<s:message code="query.make.empty.search"/>');
		return;
	}
	getList('Q');
}
function getList(type){
	var startSize = $('#sizeStartVal').val();
	var endSize = $('#sizeEndVal').val();

	if(type != 'Q') {
		if((!$.isNumeric(startSize) && startSize != '') || (!$.isNumeric(endSize) && endSize) ) {
			alert('<s:message code="message.msg.filesize.validity"/>');
			return;
		}
		
		if(Number(startSize) < 0 || Number(endSize) < 0){
			alert('<s:message code="message.msg.filesize.minus"/>');
			return;
		}
		
		if($('#sizeOption').val() == 'B') {
			if((startSize == '' && endSize != '') || (startSize != '' && endSize == '')) {
				alert('<s:message code="message.msg.filesize.rangeStartEnd"/>');
				return;
			}
			
			if(Number(startSize) > Number(endSize) ){
				alert('<s:message code="message.msg.filesize.range"/>');
				return;
			}
		}
		
		if( $('#startdatepicker').val() > $('#enddatepicker').val() ) {
			alert('<s:message code="blockHistoryNonBusi.msg.cannot.startendtime"/>');
			return;
		}
	} else {
		var search = solrHighlight($('#solrQueryText').val());
		$('#searchQueryStrInput').val(search);
	}
	
	var filterVal = $.extend(true, {}, getIframeListObj().filterValData);
	if($("input:checkbox[id='researchCheckbox']").is(":checked") && getIframeListObj().searchedFlag){
		addTab();
	}
	
	getIframeListObj().filterValData = filterVal;
	getIframeListObj().tabType = type;
	getIframeListObj().tabId = $('#resultTabs .select').attr('id');
	getIframeListObj().getList('', con.getFilterVal('', type));
}

var tabIdx = 0;
function addTab(){
	if( addTabFlag ) return;
	 
	addTabFlag = true;
	$('.addTabLi span').removeClass('glyphicon glyphicon-plus').addClass('fa fa-spinner fa-spin');
	
	tabIdx++;
	addTabHeader(tabIdx);
	addTabBody(tabIdx);
	
	changeTab($('#result'+tabIdx + ' .addTabDiv'));
}


function setFeedback(value) {
	getIframeListObj().setFeedback(value);
}
function addTabHeader(idx){
	$('#resultTabs').find('li').last().remove();
	
	var obj = $('#newTab').clone();
	var liObj = obj.find('.tab_li');
	liObj.attr('id', 'result'+idx);
	liObj.attr('data-index', idx);
	obj.find('.tab_close').attr('id', 'result_close'+idx);
	obj.find('.addTabDiv').text('<s:message code="message.msg.newtab"/>');
	
	//$('#resultTabs').append(obj.html() + $('#addTab').clone().html());
	
	headerScrollTabs.addTab(obj.html() + $('#addTab').clone().html());
}
function addTabBody(idx){
	var contentListHtml = '<iframe src="<c:url value="/ems/contentList.do?gridInit="/>" id="contentList'+(idx+1)+'" class="contentList" style="left:-10000px;"></iframe>';
	var contentBodyHtml = '<iframe src="<c:url value="/ems/contentBodyNew.do"/>" id="contentBody'+(idx+1)+'" class="contentBody" name="contentBody" style="left:-10000px;"></iframe>';
	
	$('.contentList').css('left', '-10000px');
	$('.contentBody').css('left', '-10000px');
	$('#contentList'+idx).css('left', '0px');
	$('#contentBody'+idx).css('left', '0px');
	
	$('#contentListArea').append(contentListHtml);
	$('#contentBodyArea').append(contentBodyHtml);
}

function setAddTabFlag(flag){
	addTabFlag = flag;
	
	if(flag) $('.addTabLi span').removeClass('glyphicon glyphicon-plus').addClass('fa fa-spinner fa-spin');
	else $('.addTabLi span').removeClass('fa fa-spinner fa-spin').addClass('glyphicon glyphicon-plus');
}

function setResultCnt(id, cnt){
	$('#'+id+' .resultCntSpan').text('('+cnt+')');
}

function changeTab(obj){
	if( obj == undefined ) return;
	
	var parentObjId = obj.parents('li').attr('id');
	var objLi = $('#'+parentObjId);
	var index = objLi.attr('data-index');
	
	$('.addTabDiv').parents('li').removeClass('select');

	objLi.addClass('select');
	
	$('.contentList').css('left', '-10000px');
	$('#contentList'+index).css('left', '0px');
	$('.contentBody').css('left', '-10000px');
	$('#contentBody'+index).css('left', '0px');
	
	getIframeListObj().initGrid();
	if(getIframeListObj().filterValData == undefined){
		if(!$("input:checkbox[id='researchCheckbox']").is(":checked")){
			con.resetFilter('');
		}
	}else{
		con.setFilterVal(getIframeListObj().filterValData);
		
		if( getIframeListObj().tabType == 'Q'){
			$('#msg_condition_saver').click();
		}else{
			$('#msg_condition_menu').click();
		}
	}
}
//현재 선택된 탭의 탭이름 변경
function changeTabName(id, text, researchCnt){
	var researchMsg = '';
	if( researchCnt > 0) researchMsg = 'Re'+researchCnt+') ';
	var obj = $('#'+id+' .addTabDiv');
	if(text != undefined && text != ''){
		obj.text(researchMsg + text);
	}else if( !$('#msg_condition_menu').hasClass('condition_menu_unselected') ){
		if($('.filterIcon').hasClass('hide')){
			obj.text(researchMsg+'<s:message code="message.msg.result.search"/>');
			obj.attr('title', researchMsg+'<s:message code="message.msg.result.search"/>');
		}else{
			obj.text(researchMsg+'['+$('.filterIcon').attr('title')+']');
			obj.attr('title', researchMsg+'['+$('.filterIcon').attr('title')+']');
		}
	}else if(!$('#msg_condition_saver').hasClass('condition_menu_unselected')){
		obj.text('<s:message code="message.msg.deepsearch"/>');
		obj.attr('title', '<s:message code="message.msg.deepsearch"/>');
	}
}

function delTab(obj){
	var idx = obj.attr('data-index');
	var changeObj;

	var delId = obj.attr('id');
	if(obj.hasClass('select')){
		if( obj.next().length > 0 && !obj.next().hasClass('addTabLi')){
			changeObj = obj.next().children().first();
		}else{
			changeObj = obj.prev().children().first();
		}
	}
	
	$('#contentList'+idx).remove();
	$('#contentBody'+idx).remove();
	//obj.remove();
	headerScrollTabs.removeTabs(obj)
	return changeObj;
}

function deleteSearchKeywordList(){
	var rows = grid.getSelectedKey('skSeq');
	if( rows == '' ) {
		ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
		return;
	}
	grid.on();
	ui.confirmMsg( '<s:message code="searchKeyword.msg.confirm.delete"/>', '', '', function(rs){
		if(rs){
			ui.get({
				url : 'deleteSearchKeywordList.xcn',
				skSeq : rows.join(','),
				success : function ( data, total ) {
					ui.alertMsg('<s:message code="common.msg.deleted"/>');
					getSearchKeywordList();
				},
				error : function (status, message) {
					ui.alertMsg(message);
				},
				complete : function (){
					grid.off();
				}
			});
		} else {
			grid.off();
		}
	});
}

function insertSearchKeywordList(){
	var searchKeyword = $('#searchKeywordSearchStr').val();
	if( searchKeyword == '' ) {
		ui.alertMsg('<s:message code="searchKeyword.msg.input.insert"/>');
		return;
	}
	grid.on();
	ui.get({
		url : 'insertSearchKeywordList.xcn',
		searchKeyword : searchKeyword,
		success : function(data, total) {
			$('#searchKeywordSearchStr').val('');
			getSearchKeywordList();
			ui.alertMsg('<s:message code="searchKeyword.msg.insert"/>');
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			grid.off();
		}
	});
}

function getSearchKeywordList(){
	var searchKeyword = $('#searchKeywordSearchStr').val();
	ui.get({
		url : 'getSearchKeywordList.xcn',
		searchKeyword : searchKeyword,
		success : function(data, total) {
			grid.setData(data);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}

function openMessageFolder(){
	var pop = fnOpenWindow('', 'messageFolder', 1100, 850, 'resize');

	var nodes = $.fn.zTree.getZTreeObj('folderTree').getSelectedNodes();
	$('#paramFolderSeq').val(nodes[0].id);
	$('#paramFolderName').val(nodes[0].name);
	$('#messageFolderForm').submit();
	
	return pop;
}

function getSelectedTab(){
	return $('#resultTabs').find('.select');
}
function getSelectedTabIndex(){
	var selectedTabIdx = $('#resultTabs').find('.select').attr('data-index');
	
	if(selectedTabIdx == undefined){
		selectedTabIdx = $('#resultTabs').find('.tab_li').eq(-2).attr('data-index');
	}
	return selectedTabIdx;
}
function getIframeListObj(){
	var contentList = document.getElementById("contentList"+getSelectedTabIndex());
 
	var listDoc = (contentList.contentWindow) ? contentList.contentWindow : (contentList.contentDocument.document) ? contentList.contentDocument.document : contentList.contentDocument;

	return listDoc;
}
function getIframeBodyObj(){
	var contentBody = document.getElementById("contentBody"+getSelectedTabIndex());
	var bodyDoc = (contentBody.contentWindow) ? contentBody.contentWindow : (contentBody.contentDocument.document) ? contentBody.contentDocument.document : contentBody.contentDocument;
	return bodyDoc;
}
function getFormatVal(){
	ui.get({
		url : 'getConfAdmin.xcn',
		confId : 'message.user.format',
		success : function(data, total) {
			var dataVal = '';
			if( data == null){
				setConfAdmin('message.user.format','#name#/#email#/#businm#/#deptnm#/#jikgubnm#/#ip#');
				getFormatVal();
				return;
			}
			dataVal = data.val.replaceAll('#','');
			$('#insaFormatInput').val(dataVal);
			$("#messageFormat").val('');
			$("#messageFormat").focus();
			$("#messageFormat").find("option").each(function(){
				if(dataVal==$(this).attr('data-format')){
					$(this).prop("selected", true);
					$(this).click();
				}
			});
			if($("#messageFormat").val()==''){
				dataVal = dataVal.replaceAll('name','<s:message code="message.help.sample_name"/>');
				dataVal = dataVal.replaceAll('email','hong@xcurent.com');
				dataVal = dataVal.replaceAll('businm','<s:message code="message.help.sample_bunm"/>');
				dataVal = dataVal.replaceAll('deptnm','<s:message code="message.help.sample_deptnm"/>');
				dataVal = dataVal.replaceAll('jikgubnm','<s:message code="message.help.sample_jikgubnm"/>');
				dataVal = dataVal.replaceAll('ip','192.168.0.1');
				dataVal = '<s:message code="message.help.example"/>) '+dataVal
				$("#insaFormatInputEx").val(dataVal); 
			}
		},
			
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}
function getMsgPosition(){
	ui.get({
		url : 'getConfAdmin.xcn',
		confId : 'msgPosition',
		success : function(data, total) {
			if( data == null){
				$('#none_btn').click();
				return;
			}
			
			if( data.val == 'R') $('#right_btn').click(); 
			else if( data.val == 'B') $('#bottom_btn').click();
			else $('#none_btn').click();
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}
function getFilterSearchBox(){
	ui.get({
		url : 'getConfAdmin.xcn',
		confId : 'filterSearchBox',
		success : function(data, total) {
			if( data == null){
				$('input:checkbox[id="searchBox"]').attr("checked", false);
				return;
			}
			if( data.val == 'Y') $('input:checkbox[id="searchBox"]').attr("checked", true);
			else $('input:checkbox[id="searchBox"]').attr("checked", false);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}
function setConfAdmin(confId, val){
	ui.get({
		url : 'setConfAdmin.xcn',
		confId : confId,
		val : val,
		success : function(data, total) {
			if(confId == 'message.user.format' ){
				$('#confAccept').show();	
				$('#insaFormatInput').css('width','310px');
				$('#insaFormatInput').animate({'background-color':'#rgb(137, 222, 120)',duration: '1000'},
					function() {
					$('#insaFormatInput').animate({'background-color':'#fff',duration: '1000'});
				});
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}

function regexpInfoViewer(row, selectedGrid){
	return getIframeListObj().regexpInfoViewer(row, selectedGrid);
}

function userInfoViewer(row, type, selectedGrid){
	return getIframeListObj().userInfoViewer(row, type, selectedGrid);
}

function fileInfoViewer( row, selectedGrid ){
	return getIframeListObj().fileInfoViewer( row, selectedGrid );
}

function ocrFileInfoViewer( row, selectedGrid ){
	getIframeListObj().ocrFileInfoViewer( row, selectedGrid );
}

function searchConsentNo(){
	var url    = '<c:url value="/ems/selectConsent.do"/>';
	return fnOpenWindow(url, 'selectConsentWinPopup', 1000, 700, 'resize');
}
function resetConsentNo(){
	$('#consentNo').val('');
	$('#consentName').text('');
	$('#consentShortName').val('');
	$('#consentUserId').val('');
	$('#consentBtn').removeClass('active');
}
function selectedConsent( obj ){
	if( obj == ''){
		resetConsentNo();
	}else{
		$('#consentNo').val(obj.no);
		$('#consentName').text(obj.name + "["+obj.userId+", "+obj.deptNm+"]");
		$('#consentShortName').val(obj.name);
		$('#consentUserId').val(obj.userId);
		$('#consentBtn').addClass('active');
	}
}

function queryMakePop(  ){
	var url    = '<c:url value="/commons/queryMake.do?statType=users"/>';
	fnOpenWindow(url, 'queryMakePop', 1400, 870, 'resize');
}

function getSearchQuery() {
	
}
function confIconHide() {
	$('#confError').hide();
	$('#confAccept').hide();
	$('#insaFormatInput').css('width','330px');
}

function initHeaderTab(){
	if( headerScrollTabs != undefined) headerScrollTabs.destroy();
	headerScrollTabs = $('#resultTabs').scrollTabs({
		
		click_callback: function(e){
			if($(e.delegateTarget).hasClass('scroll_tab_last')){
				clickHeader($(this).find('.addTabDiv'));
			}else{
				if($(e.target).hasClass('tab_close')){
					var changeObj = delTab($(e.target).parent());
					if(changeObj != undefined) {
						var resultId = changeObj.attr('id');
					
						changeTab($('#'+resultId));
					}
				}else{
					clickHeader($(this).find('.addTabDiv'));
				}
			}
		}
	});
}

/**
 * 고급검색 쿼리 텍스트 추출 (정규 표현식을 이용한 텍스트만 추출)
 * 하일라이팅을 위한 처리
 */
function solrHighlight(val){
	var result = '';
	ui.get({
		url : 'getSolrHighlightStr.xcn',
		val : val,
		asyncFlag : false,
		success : function(data, total) {
			result = data.val;
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
	return result;
}

function setConfAdminOption(confId,val){
	ui.get({
		url : 'setConfAdminOption.xcn',
		confId : confId,
		val : val,
		success : function(data, total) {
			
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}

var keywordHighlight = true;
var hostQuery = true;
var recvSum = true;

function initConfAdminOption() {
	ui.get({
		url : 'getConfAdminOption.xcn',
		success : function(data, total) {
			if(data.length > 0 ) {
				for (var i = 0; i < data.length; i++) {
					if(data[i]['confId'] == 'body.snippet.sum.use') $('[name=subjectbody]').prop('checked', data[i]['val'] == 'Y' ? true : false);
					else if(data[i]['confId'] == 'message.overlap.use') $('[name=overlapUse]').prop('checked', data[i]['val'] == 'Y' ? true : false);
					else if(data[i]['confId'] == 'toccbcc.sum.use') recvSum = data[i]['val'] == 'Y' ? true : false;
					else if(data[i]['confId'] == 'message.keyword.highlight') keywordHighlight = data[i]['val'] == 'Y' ? true : false;
					else if(data[i]['confId'] == 'host.query.use') hostQuery = data[i]['val'] == 'Y' ? true : false;
				}
			}
			$('[name=summary]').prop('checked', recvSum);
			$('[name=keywordHighlight]').prop('checked', keywordHighlight);
			$('[name=hostQuery]').prop('checked', hostQuery);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}

function openNologUrlPop(host_path){
	mode = 'insert';
	if(host_path.indexOf('?') > -1) $('#noLogurl').val(host_path.substring(0, host_path.indexOf('?')));
	else $('#noLogurl').val(host_path);
	$("#urlPop").modal('show');
}

var downloadBatchExist=true;
function checkDownloadBatchExist(){
	
	var grid = getIframeListObj().grid;
	var rows = grid.getSelectedKey('msgid').length;
	var total = getIframeListObj().$('#busiCntArea').find('.tab_selected').find('.busiCnt').text();
	total = total.replace(re,"")
	var header = grid.getHeaderEXCEL();
	var param = JSON.stringify( getIframeListObj().filterValData );
	var dataLength = $('#dataLength_select').selectpicker('val');
	var searchType = $('#searchType').val();
	var exportFileType = $('input:radio[name=exportFileType]:input:checked').val();
	
	ui.get({
		url : 'checkDownloadBatchExist.xcn',
		searchCondition : param,
		searchTotal : $('#searchTotal').val(),
		searchType : searchType,
		exportFileExt : exportFileType,
		success : function(data, total) {
			if(data > 0) {
				downloadBatchExist = true;
			} else {
				downloadBatchExist = false;
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
<body class="mini-navbar msgBody" style="overflow: auto;">
	<div class="msg_container">
		<%@ include file="../left.jsp"%>
		<div id="searchKeywordDiv" class="searchKeywordDiv">
			<div class="searchKeywordTab"><s:message code="searchKeyword.management"/>
				<div class="rightGroup"><span class="searchKeywordCloseBtn">&times;</span></div>
			</div>
			<div class="searchKeywordSearch" style="padding: 5px 5px 5px 10px;">
				<input class="condition_input_text" type="text" name="serch" placeholder="<s:message code="searchKeyword.search"/>" id="searchKeywordSearchStr" style="width:calc(100% - 150px);">
				<button class="search_btn" id="searchKeywordSearchBtn"><span><s:message code="common.search"/></span></button>
				<button class="msg_button" id="addSearchKeywordBtn"><span><s:message code="common.msg.add"/></span></button>
				<button class="msg_button" id="delSearchKeywordBtn"><span><s:message code="common.msg.delete"/></span></button>
			</div>
			<div style="padding-left: 10px;">
				<span style="font-weight: bold; display: inline-block; margin-right: 10px;"><i class="fa fa-caret-right"></i> <s:message code="searchKeyword.inputMode"/></span>
				<label class="searchKeywordInputType"><input type="radio" name="searchKeywordInputType" value="S" checked="checked"> <span><s:message code="searchKeyword.single"/></span></label>
				<label class="searchKeywordInputType"><input type="radio" name="searchKeywordInputType" value="A"> <span>AND</span></label>
				<label class="searchKeywordInputType"><input type="radio" name="searchKeywordInputType" value="O"> <span>OR</span></label>
			</div>
			<div id="searchKeywordGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px;min-height:200px;height:calc(100% - 100px);"></div>
		</div>
		<div id="filterHeaderDiv" class="filterHeaderDiv">
			<div class="filterHeaderTab"><s:message code="common.msg.conditionBox"/>
			<div class="rightGroup">
				<span class="searchBoxSpan"><label><input type="checkbox" id="searchBox"/><span> <s:message code="common.msg.searchNow"/></span></label></span>
				<span class="filterCloseBtn">&times;</span></div>
			</div>
			<div class="filterSearch" style="padding: 5px 5px 5px 10px;">
				<input class="condition_input_text" type="text" name="serch" placeholder="<s:message code="filterInfo.search.filter"/>" id="filterSearchStr" style="width:calc(100% - 60px);">
				<button class="search_btn" id="filterSearchBtn"><span><s:message code="common.search"/></span></button>
			</div>
			<div class="scrollbar-inner saveFilterTab_tree">
				<ul id="filterTree" class="ztree scrollbar"></ul>
			</div>
		</div>
		<%@ include file="./filterNew.jsp"%>
		<div class="content mainBodyArea" id="mainBodyArea" style="height:100%;">
			<%@ include file="./searchTab.jsp"%>
			<%@ include file="./center.jsp"%>
		</div>
	</div>
	<div id="searchHelpDiv" style="display: block;position: absolute;top: 130px;right: 350px;display: none;text-align: left;z-index: 1040;border: 1px solid #555;background-color: #f4f4f4;width: 500px;height: 420px;font-size:12px;">
		<div class="searchHelpHeader" style="height:30px;background-color:#253f56;color:#fff;padding-left:10px;line-height:30px;font-weight: bold;cursor:move;">
			<div style="float:left;width:100px;">
				<i class="glyphicon glyphicon-question-sign"></i>&nbsp;<s:message code="help.msg.title"/>
			</div>
			<div style="float:right;padding-right:8px;" class="searchHelpDivCloseArea">
				<span class="glyphicon glyphicon-remove" style="cursor:pointer;" id="searchHelpDivCloseBtn"></span>
			</div>
		</div>
		<div style="width:100%;padding:10px 10px 10px 10px;" class="searchHelpDivBody">
			<div>
				<div style="height:25px;">
					<h5 style="font-size:13px;">■ <span style="color:#FF0000;"><s:message code="help.msg.default"/></span></h5>
				</div>
				<div>
					<span>■ <s:message code="help.msg.all"/></span><br/>
					<span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.all.ex"/></span><br/>
					<span style="padding-left:10px;"><s:message code="help.msg.all.explain"/></span><br/>
				</div>
				<div style="padding-top:5px;">
					<span>■ <s:message code="help.msg.except"/></span><br/>
					<span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.except.ex"/></span><br/>
					<span style="padding-left:10px;"><s:message code="help.msg.except.explain"/> </span><br/>
				</div>
				<div style="padding-top:5px;">
					<span>■ <s:message code="help.msg.or"/></span><br/>
					<span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.or.ex"/></span><br/>
					<span style="padding-left:10px;"><s:message code="help.msg.or.explain"/> </span><br/>
				</div>
				<div style="padding-top:5px;">
					<span>■ <s:message code="help.msg.exact"/></span><br/>
					<span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.exact.ex"/></span><br/>
					<span style="padding-left:10px;"><s:message code="help.msg.exact.explain"/> </span><br/>
				</div>
				<div style="padding-top:5px;">
					<span>■ <s:message code="help.msg.astar"/></span><br/>
					<span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.astar.ex"/></span><br/>
					<span style="padding-left:10px;"><s:message code="help.msg.astar.explain"/> </span><br/>
				</div>
				<div style="padding-top:5px;">
					<span>■ <s:message code="help.msg.question"/></span><br/>
					<span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.question.ex"/></span><br/>
					<span style="padding-left:10px;"><s:message code="help.msg.question.explain"/></span><br/>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="exportDialog" tabindex="-1" role="dialog" aria-labelledby="exportDialog">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title" id="exportTitle">&nbsp;</h3>
				</div>
				<div class="modal-body">
					<div class="form-inline">
						<div class="content_body" style="height:100%;padding-top: 0;">
							<table class="table table-bordered" style="margin-bottom:0;width:100%;">
								<colgroup>
									<col width="210">
									<col width="*">
								</colgroup>
								<tr>
									<th>
										<s:message code="download.msg.dataArea"/>
									</th>
									<td>
										<div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
											<label class="btn btn-sm btn-default"><input type="radio" name="exportDataRange" id="exportDataSelect" value="S"> <s:message code="download.msg.select.count"/></label>
											<label class="btn btn-sm btn-default active"><input type="radio" name="exportDataRange" id="exportDataAll" value="A" checked> <s:message code="download.msg.search.count"/></label>
										</div>
									</td>
								</tr>
								<tr id="exportFileTypeArea">
									<th>
										<s:message code="download.msg.fileType"/>
									</th>
									<td>
										<div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
											<label class="btn btn-sm btn-default active"><input type="radio" name="exportFileType" id="exportExcel" value="xlsx" checked> <s:message code="common.msg.excel"/>(xlsx)</label>
											<label class="btn btn-sm btn-default"><input type="radio" name="exportFileType" id="exportHancel" value="cell"> <s:message code="common.msg.hancel"/>(cell)</label>
											<label class="btn btn-sm btn-default"><input type="radio" name="exportFileType" id="exportText" value="csv"> <s:message code="common.msg.text"/>(csv)</label>
											<label class="btn btn-sm btn-default"><input type="radio" name="exportFileType" id="exportPdf" value="pdf"> <s:message code="selectCodeAll.list"/>(PDF)</label>
										</div>
									</td>
								</tr>
								<tr>
									<th>
										<s:message code="download.msg.export.count"/>
									</th>
									<td>
										<span id="exportDataSize" style="line-height:32px;">0</span>
									</td>
								</tr>
								<tr id="bodyInExcel">
									<th>
										<s:message code="download.msg.body.in.excel"/>
									</th>
									<td>
										<label class="condition_label"><input type="radio" name="bodyInExcel" value="Y"> <span><s:message code="common.msg.include"/></span></label>
										<label class="condition_label"><input type="radio" name="bodyInExcel" value="N" checked="checked"> <span><s:message code="common.msg.not.include"/></span></label>
									</td>
								</tr>
								<tr id="bodyInExcelMsg" style="font-weight: bold;display:none;">
									<td colspan="2">
										<s:message code="download.msg.body.in.excelMsg" />
									</td>
								</tr>
							</table>
							<table class="table table-bordered" style="margin-bottom:0;width:100%;margin-top:15px;display:none;" id="bodyInExcelIdx">
								<colgroup>
									<col width="210">
									<col width="*">
								</colgroup>
								<tr>
									<th style="font-weight: bold;">
										<s:message code="download.msg.now.col.order" />
									</th>
									<td>
										<select id="nowColIdx" data-style="btn-default">
										</select>
									</td>
								</tr>
								<tr style="font-weight: bold;">
									<td colspan="2">
										<s:message code="download.msg.body.col.idx" />
									</td>
								</tr>
							</table>
							<table class="table table-bordered" style="margin-bottom:0;width:100%;margin-top:15px;" id="sizeWarnMsg">
								<colgroup>
									<col width="210">
									<col width="*">
								</colgroup>
								<tr style="font-weight: bold;">
									<td colspan="2">
										<s:message code="download.msg.warn" arguments="50,000" argumentSeparator="|"/>
									</td>
								</tr>
								<tr style="font-weight: bold;">
									<th>
										<label for="ruleFile" class="control-label" style="vertical-align: bottom;line-height:35px;">¤ <s:message code="download.msg.file.count"/></label>
									</th>
									<td>
										<select id="dataLength_select" class="selectpicker" data-style="btn-default">
											<option value="20000">20,000</option>
											<option value="30000">30,000</option>
											<option value="40000">40,000</option>
											<option value="50000" selected>50,000</option>
											<option value="100000">100,000</option>
										</select>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="allDownBtn"><s:message code="common.msg.export"/></button>
				</div>
			</div>
		</div>
		<iframe id="upload_file" name="upload_file" src="" style="display: none;"></iframe>
	</div>
	<div style="display:none;">
		<ul id="newTab">
			<li class="tab_li"><div class="tab_close"></div><div class="tab_txt_top addTabDiv" style="float:left;"></div><span class="resultCntSpan" style="padding-right:15px;"></span></li>
		</ul>
		<ul id="addTab">
			<li class="tab_li addTabLi" data-index=""><div class="tab_txt_top addTabDiv" style="padding:0 10px;"><span class="fa fa-spinner fa-spin" style="cursor:pointer;color:#494949;"></span></div></li>
		</ul>
	</div>


	<form action="<c:url value="/downEmassAttachByMsgId.xcn"/>" target="ExcelDown" method="post" id="downForm">
		<input type="hidden" name="msgIds" id="msgIds">
		<input type="hidden" name="msgId" id="msgId">
	</form>
	<form action="<c:url value="/getEmassMessageSaveZip.xcn"/>" target="ExcelDown" method="post" id="allDownForm">
		<input type="hidden" name="searchTime" id="searchTime">
		<input type="hidden" name="searchCondition" id="searchCondition">
		<input type="hidden" name="searchHeader" id="searchHeader">
		<input type="hidden" name="searchType" id="searchType">
		<input type="hidden" name="searchTotal" id="searchTotal">
		<input type="hidden" name="dataLength" id="dataLength">
		<input type="hidden" name="exportFileExt" id="exportFileExt">
	</form>
	<form action="<c:url value="/ems/messageFolder.do"/>" target="messageFolder" method="post" id="messageFolderForm">
		<input type="hidden" name="paramFolderSeq" id="paramFolderSeq">
		<input type="hidden" name="paramFolderName" id="paramFolderName">
	</form>
	<script type="text/javascript">
		var grid = new Xgrid('searchKeywordGrid', contextRoot);
		grid.onCheckBox();
		grid.autoNumber();
		grid.colAdd('searchKeyword', '<s:message code="searchKeyword.searchKeyword"/>', 300, 'left', false, 'link');
		grid.loadHeader(true);
		grid.initData('<s:message code="common.msg.search.click"/>');
		grid.onClick = function() {
			if (grid.Col == grid.ColIndex('searchKeyword')) {
				var inputType = $('[name=searchKeywordInputType]:checked').val();
				var data = grid.getRowData(grid.Row);
				
				if(inputType == 'S') {
					$('#searchStrInput').val(data.searchKeyword);
				} else if(inputType == 'A') {
					if($('#searchStrInput').val() != '') $('#searchStrInput').val($('#searchStrInput').val().trim() + ' ' + data.searchKeyword);
					else $('#searchStrInput').val(data.searchKeyword);
				} else {
					if($('#searchStrInput').val() != '') $('#searchStrInput').val($('#searchStrInput').val().trim() + '|' + data.searchKeyword);
					else $('#searchStrInput').val(data.searchKeyword);
				}
			}
		};
	</script>
</body>
</html>