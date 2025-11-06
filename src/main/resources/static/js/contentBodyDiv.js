var msgId = '';
var svc = '';
var searchkey = '';
var xRootMtr = '';
var srcip = '';

var userInfoFlag = false;
var fontZoom = 3;
var detailFlag = false;
$(document).ready(function(){
	$('.font_size').click(function(){
		var more = $(this).attr('id');
		var fontSize = parseInt($('#emassBody').css("font-size"));
		if(more == 'small_txt') fontSize -= fontZoom;
		else fontSize += fontZoom;
		$('#emassBody').css({'font-size':fontSize+'px'});
		$('#emassBody *').each(function(){
			var fontSize = parseInt($(this).css("font-size"));
			if(more == 'small_txt') fontSize -= fontZoom;
			else {
				if (fontSize>24) fontSize=14;
				else fontSize += fontZoom;
			}
			$(this).css({'font-size':fontSize+'px'});
		});
	});

	//ui.onBody( 'content_body', 0, 0);
	//getBody('');

	$(document).on('click', '#usersInfoBtn', function(){
		var url = '';

		if( isGroupMessenger( ) && detailFlag ){
			//url = '<c:url value="/ems/userGroupInfoPop.do?xRootMtr='+xRootMtr+'"/>';
			url = contextRoot + '/ems/userGroupInfoPop.do?xRootMtr=' + xRootMtr;
			return fnOpenWindow(url, 'userGroupInfoPop', 835, 370, 'resize');
		}else{
			//url = '<c:url value="/ems/userInfoPop.do?msgId='+msgId+'&type="/>';
			url = contextRoot + '/ems/userInfoPop.do?msgId=' + msgId + '&type=""'
			return fnOpenWindow(url, 'userInfoPop', 835, 370, 'resize');
		}

	});
	$(document).on('click', '.attachText', function(){
		var attachId = $(this).parents('tr').attr('id');
		//var url = '<c:url value="/ems/attachText.do?msgId='+msgId+'&attachId='+attachId+'&searchKey='+searchkey+'"/>';
		var url = contextRoot + '/ems/attachText.do?msgId='+msgId+'&attachId='+attachId+'&searchKey='+searchkey;
		fnOpenWindow(url, 'attachText', 1050, 800, 'resize');
	});

	$(document).on('click', '.attachOcrText', function(){
		var attachId = $(this).parents('tr').attr('id');
		//var url = '<c:url value="/ems/attachText.do?msgId='+msgId+'&attachId='+attachId+'&searchKey='+searchkey+'&ocrYn=Y"/>';
		var url = contextRoot + '/ems/attachText.do?msgId=' + msgId+ '&attachId=' + attachId + '&searchKey=' + searchkey + '&ocrYn=Y';
		fnOpenWindow(url, 'attachText', 1050, 800, 'resize');
	});

	$(document).on('click', '#originalBtn', function(){
		//var url = '<c:url value="/ems/originalText.do?type=original&msgId='+msgId+'"/>';
		var url = contextRoot + '/ems/originalText.do?type=original&msgId=' + msgId;
		fnOpenWindow(url, 'originalText', 1050, 800, 'resize');
	});

	$(document).on('click', '#msgIdBtn', function(){
		if($("#msgIdTr").css("display") == "none") {
			$("#msgIdTr").css("display", "");
		} else {
			$("#msgIdTr").css("display", "none");
		}
	});

	$(document).on('click', '#headerBtn', function(){
		//var url = '<c:url value="/ems/originalText.do?type=header&msgId='+msgId+'"/>';
		var url = contextRoot + '/ems/originalText.do?type=header&msgId=' + msgId;
		fnOpenWindow(url, 'headerText', 1050, 800, 'resize');
	});

	$(document).on('click', '.attachName', function(){
		if(adminMenu != "ALL" && adminMenu.indexOf("AS") < 0 && adminMenu.indexOf("CS") < 0) {
			alert(message.authAlert);
			return;
		}
		if( $(this).parents('tr').hasClass('notfound')) return;

		var attachId = $(this).parents('tr').attr('id');
		var attachName = $(this).attr('attachname');
		var attachSize = Number( $(this).parents('tr').attr('size') );
		//var attachUrl = '<c:url value="/downEmassAttach.xcn"/>?msgId='+msgId+'&attachId='+attachId;
		var attachUrl = contextRoot + '/downEmassAttach.xcn?msgId='+msgId+'&attachId='+attachId;
		if ( attachSize == 0 || attachSize == 'NaN' ) attachSize = 1;

		try {
			AttachDown.location.href = attachUrl;
		} catch (e) {
			AttachDown.src = attachUrl;
		}

		var information = '[' + message.attachSave + '-' + message.fileName + ']' + enter;
		information += message.msgid + ' : '+msgId + enter;
		information += message.fileName + ' : '+attachName + enter
		insertAudit(op_attach_save, information);
	});

	$(document).on('click', '.attachExt', function(){
		if(adminMenu != "ALL" && adminMenu.indexOf("AS") < 0 && adminMenu.indexOf("CS") < 0) {
			alert(message.authAlert);
			return;
		}
		if( $(this).parents('tr').hasClass('notfound')) return;
		var txt = $(this).text();
		var attachId = $(this).parents('tr').attr('id');
		var attachName = $(this).parents('tr').find('.attachName').attr('attachname');
		var attachSize = Number( $(this).parents('tr').attr('size') );
		//var attachUrl = '<c:url value="/downEmassAttach.xcn"/>?msgId='+msgId+'&attachId='+attachId+'&prediction=Y';
		var attachUrl = contextRoot + '/downEmassAttach.xcn?msgId=' + msgId + '&attachId=' + attachId + '&prediction=Y';
		if( attachSize == 0 || attachSize == 'NaN' ) attachSize = 1;
		if(txt != '' && txt != 'unknown') attachName += '.'+txt;

		try {
			AttachDown.location.href = attachUrl;
		} catch (e) {
			AttachDown.src = attachUrl;
		}

		var information = '[' + message.attachSave + '-' + message.pre_ext + ']'+enter;
		information += message.msgid + ' : '+msgId + enter;
		information += message.fileName + ' : '+attachName + enter
		insertAudit(op_attach_save, information);
	});

	$(document).on('click', '.downloadIcon', function(){
		if(adminMenu != "ALL" && adminMenu.indexOf("AS") < 0 && adminMenu.indexOf("CS") < 0) {
			alert(message.authAlert);
			return;
		}
		if( $(this).parents('tr').hasClass('notfound')) return;

		var attachId = $(this).parents('tr').attr('id');
		var attachName = $(this).parents('tr').find('.attachName').attr('attachname');
		var attachSize = Number( $(this).parents('tr').attr('size') );
		//var attachUrl = '<c:url value="/downEmassAttach.xcn"/>?msgId='+msgId+'&attachId='+attachId;
		var attachUrl = contextRoot + '/downEmassAttach.xcn?msgId=' + msgId + '&attachId=' + attachId;
		if ( attachSize == 0 || attachSize == 'NaN' ) attachSize = 1;

		try {
			AttachDown.location.href = attachUrl;
		} catch (e) {
			AttachDown.src = attachUrl;
		}

		var information = '[' + message.attachSave + ']'+enter;
		information += message.msgid + ' : ' + msgId + enter;
		information += message.fileName + ' : ' + attachName + enter
		insertAudit(op_attach_save, information);
	});
	$(document).on('click', '#saveAttachBtn', function(){
		if(adminMenu != "ALL" && adminMenu.indexOf("AS") < 0 && adminMenu.indexOf("CS") < 0) {
			alert(message.authAlert);
			return;
		}
		//var attachUrl = '<c:url value="/downEmassAttach.xcn"/>?msgId='+msgId;
		var attachUrl = contextRoot + '/downEmassAttach.xcn?msgId=' + msgId;
		try {
			AttachDown.location.href = attachUrl;
		} catch (e) {
			AttachDown.src = attachUrl;
		}

		var information = '[' + message.attachSave + ']'+enter;
		information += message.msgid + ' : '+msgId + enter;
		information += message.total_count + ' : ' + $('.downloadIcon').size()+enter;

		insertAudit(op_attach_save, information);
	});

	$('#bodyEncoding').selectpicker({

		container:'body',
		width:'100px',
		noneSelectedText:message.msgAuto
	}).on('changed.bs.select', function (e) {
		var charset = $(this).selectpicker('val');
		getBody(charset);
	});;

	$('#closeBtn').click(function(){
		window.open("about:blank", "_self").close();
	});

	$('#prevBtn').click(function(){
		ui.onBody( 'content_body', 0, 0);
		if(opener) {
			if(!opener.prevMsg()){
				alert(message.msgNomsg);
				ui.off();
			}
		} else {
			prevMsg();
			ui.off();
		}
	});

	$('#nextBtn').click(function(){
		ui.onBody( 'content_body', 0, 0);
		if(opener) {
			if(!opener.nextMsg()){
				alert(message.msgNomsg);
				ui.off();
			}
		} else {
			nextMsg();
			ui.off();
		}
	});

	$('#printBtn').click ( function ( ) {
		var charset = $('#bodyEncoding').selectpicker('val');
		//var url = '<c:url value="/getEmassBodySave.xcn?msgId='+msgId+'&userCharset='+charset+'&print=Y"/>';
		//if( detailFlag ) url = '<c:url value="/getMessengerGroupAllSave.xcn?msgId='+msgId+'&xRootMtr='+xRootMtr+'&print=Y"/>';
		var url = contextRoot + '/getEmassBodySave.xcn?msgId=' + msgId + '&userCharset=' + charset + '&print=Y';
		if( detailFlag ) url = contextRoot + '/getMessengerGroupAllSave.xcn?msgId=' + msgId + '&xRootMtr=' + xRootMtr + '&print=Y';
		fnOpenWindow( url, 'message_print', '1000', '800', 'scroll' );

		var information = '[' + message.bodyPrint + ']'+enter;
		if( detailFlag ) information += message.xrootmtr + ' : ' + xRootMtr + ' ';
		else information += message.msgid + ' : ' + msgId + ' ';
		insertAudit(op_body_print, information);
	});

	$('#saveBtn').click ( function ( ) {
		var charset = $('#bodyEncoding').selectpicker('val');
		//var url = '<c:url value="/getEmassBodySave.xcn?msgId='+msgId+'&userCharset='+charset+'&print=N"/>';
		var url = contextRoot + '/getEmassBodySave.xcn?msgId='+msgId+'&userCharset='+charset+'&print=N';
		var fileName = msgId+'.html';
		var fileSize = 1;

		//if( detailFlag ) url = '<c:url value="/getMessengerGroupAllSave.xcn?msgId='+msgId+'&xRootMtr='+xRootMtr+'&srcip='+srcip+'"/>';
		if( detailFlag ) url = contextRoot + '/getMessengerGroupAllSave.xcn?msgId=' + msgId + '&xRootMtr=' + xRootMtr + '&srcip=' + srcip;

		try {
			AttachDown.location.href = url;
		} catch (e) {
			AttachDown.src = url;
		}

		var information = '[' + message.bodyView + ']' + enter;
		if( detailFlag ) information += message.xrootmtr + ' : ' + xRootMtr + ' ';
		else information += message.msgid + ' : ' + msgId + ' ';
		insertAudit(op_body_save, information);
	});

	$('#mailFowardBtn').click(function(){
		if( !mailUseFlag ){
			alert(message.msgNomail);
			return;
		}

		if( adminEmail == ''){
			alert(message.chk_account);
			return;
		}
		var charset = $('#bodyEncoding').selectpicker('val');
		/*
		$('.content .boxArea .content_box .content_body').contents( ).find('.appendClass').hide();
		var emassBodyStr = $('.content .boxArea .content_box .content_body')[0].innerHTML;
		$('#msgIdStr').val(msgId);
		$('#userCharsetStr').val(charset);
		$('#mailForwardStr').val(emassBodyStr);
		if( detailFlag ) $('#xRootMtrStr').val(xRootMtr);
		console.log("emassBodyStr="+emassBodyStr)
		var url = '<c:url value="mailFoward.do"/>';
		var pop = fnOpenWindow('', 'message_forward', 1000, 800, 'scroll');
		$('#mailForwardForm').attr('target','message_forward');
		$('#mailForwardForm').attr('action', url);
		$('#mailForwardForm').attr('method','post');
		$('#mailForwardForm').submit();
		$('.content .boxArea .content_box .content_body').contents( ).find('.appendClass').show();
		 */
		//var url = '<c:url value="mailFoward.do?msgId='+msgId+'&userCharset='+charset+'"/>';
		//if( detailFlag ) url = '<c:url value="mailFoward.do?xRootMtr='+xRootMtr+'&userCharset='+charset+'"/>';
		var url = contextRoot + '/ems/mailFoward.do?msgId=' + msgId + '&userCharset=' + charset;
		if( detailFlag ) url = contextRoot + 'mailFoward.do?xRootMtr=' + xRootMtr + '&userCharset=' + charset;
		fnOpenWindow( url, 'message_forward', '1000', '800', 'scroll' );
	});

	$('#warnMailBtn').click(function(){
		if( !mailUseFlag ){
			alert(message.msgNomail);
			return;
		}

		if( adminEmail == ''){
			alert(message.chk_account);
			return;
		}
		var charset = $('#bodyEncoding').selectpicker('val');
		//var url = '<c:url value="warningMail.do?msgId='+msgId+'&userCharset='+charset+'"/>';
		//if( detailFlag ) url = '<c:url value="warningMail.do?xRootMtr='+xRootMtr+'&userCharset='+charset+'"/>';
		var url = contextRoot + '/ems/warningMail.do?msgId=' + msgId + '&userCharset=' + charset;
		if( detailFlag ) url = contextRoot + '/ems/warningMail.do?xRootMtr=' + xRootMtr + '&userCharset='+charset;
		fnOpenWindow( url, 'message_warnmail', '700', '420', 'scroll' );
	});

	$(document).on('mouseover', '.userInfoSpan', function(e){
		var obj =  $(this);
		userInfoFlag = true;
		setTimeout(function(){
			if( userInfoFlag ){
				if( obj.attr('recvname') == '' && obj.attr('recvemail') == ''){
					if( nvl(obj.attr('sender')) != ''){
						$('#userNamePop').text(obj.attr('sname'));
						$('#userEmailPop').text(obj.attr('sender'));
					}
					else if( nvl(obj.attr('recvid')) == ''){
						$('#userNamePop').text(obj.attr('srcip'));
					}
					else{
						$('#userNamePop').text(obj.attr('recvid'));
						$('#userEmailPop').text(obj.attr('recvid'));
					}
				}
				else {
					$('#userNamePop').text(obj.attr('recvname'));
					if(obj.attr('recvemail')!= '') $('#userEmailPop').text(obj.attr('recvemail'));
					else $('#userEmailPop').text(nvl(obj.attr('recvid'), nvl(obj.attr('srcip'))));
				}
				if(obj.attr('recvconm') != '') $('#userCoNmPop').text(obj.attr('recvconm'));
				else $('#userCoNmPop').text('');
				if(obj.attr('recvbusinm') != '') $('#userBusiNmPop').text(obj.attr('recvbusinm'));
				else $('#userBusiNmPop').text('');
				if(obj.attr('recvsuborgnm') != '') $('#userSuborgNmPop').text(obj.attr('recvsuborgnm'));
				else $('#userSuborgNmPop').text('');
				if(obj.attr('recvdeptnm') != '') $('#userDeptNmPop').text(obj.attr('recvdeptnm'));
				else $('#userDeptNmPop').text('');
				if(obj.attr('recvjikgubnm') != '') $('#userJikgubNmPop').text(obj.attr('recvjikgubnm'));
				else $('#userJikgubNmPop').text('');

				var left = obj.offset().left;
				if( obj.offset().left+$('#userInfoDiv').width() > $(window).width()){
					left-=$('#userInfoDiv').width()-20;
				}
				$('#userInfoDiv').css('top', obj.offset().top+20);
				$('#userInfoDiv').css('left', left);
				$('#userInfoDiv').fadeIn();
			}
		}, 500);
	});
	$(document).on('mouseout', '.userInfoSpan, #userInfoDiv', function(e){
		userInfoFlag = false;
		setTimeout(function(){
			if( !userInfoFlag ) $('#userInfoDiv').fadeOut();
		}, 1000);
	});
	$(document).on('mouseover', '#userInfoDiv', function(e){
		userInfoFlag = true;
	});
	$(document).bind("mousedown", function(event){
		if (!(event.target.id == "userInfoDiv" || $(event.target).parents("#userInfoDiv").length > 0 || $(event.target).hasClass('userInfoSpan'))) {
			userInfoFlag = false;
			$('#userInfoDiv').fadeOut();
		}
	});
	$(document).bind("mouseup","#emassBody", function(e){
		if ((e.target.id != "emassBody" && $(e.target).parents("#emassBody").length == 0)) {
			if (!(e.target.id == "infoDiv" || $(e.target).parents("#infoDiv").length > 0)) {
				$('#infoDivText').text('');
				$('#infoDiv').fadeOut();
			}
			return;
		}
		var t = selectText();
		if(t.trim() == '') {
			if (!(e.target.id == "infoDiv" || $(e.target).parents("#infoDiv").length > 0)) {
				$('#infoDivText').text('');
				$('#infoDiv').fadeOut();
			}
			return;
		}
		//console.log(unescape( t.fReplaceWord('\\', '%') ) );

		var unescapeTxt = unescape( t.fReplaceWord('\\', '%') );
		if( t == unescapeTxt ) {
			$('#infoDiv').fadeOut();
			return;
		}

		$('#infoDivText').text(unescapeTxt);

		var obj = $(this);
		var left = e.pageX;
		if( left+$('#infoDiv').width() > $(window).width()){
			left-=$('#infoDiv').width()-20;
			if( left <0) left =10;
		}

		var top = (e.pageY-$(document).scrollTop())+10;
		if( top+$('#infoDiv').height() > $(window).height()){
			top-=$('#infoDiv').height()+10;
			if( top < 0) top = 10;
		}
		$('#infoDiv').css('top', top+$(document).scrollTop());
		$('#infoDiv').css('left', left);
		$('#infoDiv').fadeIn();
	});

	//init();
});

function getBody(userCharset){
	if(isGroupMessenger()){
		$('#usridTr').show();
		$('#headerBtn').prop('disabled', true);
		$('#originalBtn').prop('disabled', true);
		$('#usersInfoBtn').html('<span class="glyphicon glyphicon-user"></span>&nbsp;' + message.userinfo);
	}
	$('#fromTr').show();
	$('#toTr').show();
	$('#participantTr').hide();
	$('#rootmtrTr').hide();

	//$('#small_txt').prop('disabled', false);
	//$('#large_txt').prop('disabled', false);
	if( $('#bodyEncoding').prop('disabled')){
		$('#bodyEncoding').prop('disabled', false);
		$('#bodyEncoding').selectpicker('refresh');
	}

	detailFlag = false;

	ui.onBody('content_body', 0, 0);
	ui.get({
		url : 'getEmassBodyStr.xcn',
		msgId : msgId,
		userCharset : userCharset,
		menuId : menuId,
		pMenuId : pMenuId,
		success : function(data, total) {
			if(data==null || nvl( data,'')=='') data = message.msgNocontent;

			if(isGroupMessenger() && (svc.indexOf('J') == 3 || svc.indexOf('L') == 3)) $('#emassBody').html(getAppendGroupBody());
			else $('#emassBody').html(data + getAppendGroupBody());
			$("#emassBody").select();
			Highlight();
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			ui.off('content_body');
		}
	});
}

function getAppendGroupBody(){
	if( !isGroupMessenger()) return '';

	var str = '<br/><br/><br/><br/>';
	str+='<div class="appendClass" style="width:100%;text-align: center;font-size:13px;">';
	//str+='<img src="<c:url value="/resources/img/paper.png"/>" width="64px" height="64px"><br/>';
	str+='<img src="' + contextRoot + '/resources/img/paper.png" width="64px" height="64px"><br/>';
	str+='	<span style="line-height:25px;">'+contentBodyDivJS.thisMsgAllChat+'</span><br/>';
	str+='	<a href="javascript:void(0);" target="_self" onclick="getGroupDetail(\''+xRootMtr+'\');">'+contentBodyDivJS.allMsgView+'</a>';
	str+='</div>';

	var appendMsg = '';
	if(svc.indexOf('J') == 3 ){
		appendMsg = contentBodyDivJS.chatJoin;
		return appendMsg+str;
	}else if(svc.indexOf('L') == 3 ){
		appendMsg = contentBodyDivJS.chatLeave;
		return appendMsg+str;
	}else{
		return str
	}
}

function isGroupMessenger(){
	var isGroup = false;
	if(svc.indexOf('Q') == 0 && xRootMtr != ''){
		isGroup = true;
	}
	return isGroup;
}
var searchFlag = false;
function getGroupDetail(rootmtr){
	searchFlag = true;
	ui.onBody('content_body', 0, 0);
	ui.get({
		url : 'getMessengerGroupUserList.xcn',
		xRootMtr : rootmtr,
		success : function(groupData, total) {
			getParticipantInfo( groupData.groups );

			$("#emassBody").html('');
			ui.get({
				url : 'getMessageGroupDetail.xcn',
				xRootMtr : rootmtr,
				groupField : 'sender_str',
				srcip : srcip,
				readYn : 'Y',
				success : function(data, total) {
					//$('#small_txt').prop('disabled', true);
					//$('#large_txt').prop('disabled', true);
					$('#bodyEncoding').prop('disabled', true);
					$('#bodyEncoding').selectpicker('refresh');

					$("#emassBody").html(printGroupList(data.groups, groupData.groups));
					Highlight();
					//$('#messageTotalCnt').html(data.groups.length.comma());

					searchFlag = false;
					detailFlag = true;

					try{
						opener.setReadDisplayChangeRootmtr( rootmtr, srcip );
					}catch(e){console.log('opener.setReadDisplayChangeRootmtr : opener changed!')}
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
					ui.off('content_body');
				}
			});


		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});



}
function getParticipantInfo( data ){
	$('#participantTr').show();
	$('#rootmtrTr').show();

	$('#usridTr').hide();
	$('#fromTr').hide();
	$('#toTr').hide();
	$('#usersInfoBtn').html('<span class="glyphicon glyphicon-user"></span>&nbsp;' + message.msgParticipantinfo);

	var str = '';
	for(var i=0; i<data.length; i++){
		str +='<span class="userInfoSpan" sname="'+nvl(data[i].sname)+'" sender="'+nvl(data[i].sender)+'" srcip="'+nvl(data[i].srcip)+'" recvid="'+nvl(data[i].usr_id)+'" recvip="" recvemail="" recvname="'+nvl(data[i].name)+'" ';
		str +='recvconm="'+nvl(data[i].conm)+'" recvbusinm="'+nvl(data[i].businm)+'" recvsuborgnm="'+nvl(data[i].suborgnm)+'" recvdeptnm="'+nvl(data[i].deptnm)+'" recvjikgubnm="'+nvl(data[i].jikgubnm)+'" >'+nvl(data[i].sname, data[i].sender)+'; </span>';
	}
	$('#participantDiv').html(str);
}



function printGroupList(detailDataSet, users){
	var str = '<div class="appendClass" style="width:100%;text-align:right;font-size:12px;"><a title='+contentBodyDivJS.backView+' id="returnMsg" target="_parent" class="fullSizeIco" onclick="getBody(\'\');" href="javascript:void(0)">'+contentBodyDivJS.backView+'</a>&nbsp;</div>';
	str += '<table class="g_request">';
	str += '	<colgroup>';
	str += '<col width="120">';
	str += '<col width="*">';
	str += '<col width="80">';
	str += '</colgroup>';
	str += '<tbody>';

	for(var i=0 ; i < detailDataSet.length ; i++) {
		var obj = detailDataSet[i];

		str += checkDate(detailDataSet, i);
		var obj_ctime = obj.ctime;
		str += '<tr>';

		var title = obj.title;
		//var titleTmp = users.search(obj.title, 'usr_id', 'name');
		//if( titleTmp != null ) title += '('+titleTmp+')';

		str += '<th>'+title+'</th>';
		str += '<td>'+obj.message.replaceAll('\n', '<br/>')+'</td>';
		str += '<td>'+obj_ctime.substring(10, obj_ctime.length)+'</td>';
		str += '</tr>';
	}
	str += '</tbody>';
	str += '</table><br/><br/>';
	return str+getBodyStyle();
}
function checkDate(detailDataSet, idx){
	if( idx > 0 && detailDataSet[idx].ctime.substring(0, 10) == detailDataSet[idx-1].ctime.substring(0, 10) ){
		return '';
	}

	var str = '';
	str +='<tr>';
	str +='<th class="date_title" colspan="3">'+detailDataSet[idx].ctime.substring(0, 10)+'</th>';
	str +='</tr>';
	return str;
}

function getBodyStyle(){
	var str = '<style>';
	str +='table.g_response, table.g_request {border-collapse: collapse !important;font-family: Dotum, "Apple SD Gothic Neo", Helvetica, sans-serif !important;border-top: 2px solid #036 !important;width: 100% !important;}';
	str +='.g_request th, .g_response th {padding: 7px !important;font-weight: bold !important;border-bottom: 1px solid #ccc !important;font-size: 13px;text-align:center !important;}';
	str +='.g_request th {background-color: #F6F6F6}';
	str +='.g_response th {background-color: #2DBDDC !important;}';
	str +='.g_response td, .g_request td {padding: 7px !important;border-bottom: 1px solid #ccc !important;word-break: break-all !important;font-size: 13px;}';
	str +='.date_title{background-color: #F2F8FD !important;font-size: 13px;text-align:center !important;}';
	str +='</style>';

	return str;
}

function selectText() {
	var selectionText = "";
	if (document.getSelection) {
		selectionText = document.getSelection().toString();
	} else if (document.selection) {
		selectionText = document.selection.createRange().text;
	}
	return selectionText;
}

function init(){
	var windowName = window.name;
	if(windowName == ''){
		$('#headerIcon').switchClass('fa-object-group', 'fa-object-ungroup');
		$('#headerIcon').attr('title', message.windowNew);
		$('#prevBtn').prop('disabled', true);
		$('#nextBtn').prop('disabled', true);
	}else{
		$('#headerIcon').switchClass('fa-object-ungroup', 'fa-object-group');
		$('#headerIcon').attr('title', message.windowTab);
	}

	self.window.focus( );
	/* setTimeout(function(){
		ui.off( 'content_body' );
	}, 3000); */
}
function loading_off() {
	ui.off( 'content_body' );
}

function getEmassPatternDetail(obj, piId, type, attachName){
	var cnt = $(obj).text();
	if( cnt == 0) {
		$('#detectionCnt').text('');
		$('#detailArea').text('');
		return;
	}
	$('#detailPatternDiv').show();
	//String msgId, String piId, String type
	ui.get({
		url : 'getEmassPatternDetail.xcn',
		msgId : msgId,
		piId : piId,
		type : type,
		attachName : attachName,
		success : function(data, total) {
			if( data.length > 0){
				var kwds = data[0].kwds.replaceAll(',', '<br/>');
				$('#detailArea').html(kwds);
			}else{
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


//////////////////////////////////////////////////////////////////////////////////////////////////
function getMessage(id, search){
	msgId = id;
	searchkey = search;
	ui.get({
		url : 'getEmassMessageNew.xcn',
		msgId : msgId,
		success : function(data, total) {
			setMessage(data);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}
var test;
function setMessage(msg) {

	if(msg == null) {
		$('#buttonDiv').css("display", "none");
		$('#msgDiv').css("display", "none");
		$('#notfoundmsgDiv').css("display", "");
		$('#notfoundconsentDiv').css("display", "none");
		$('#notSelectDiv').css("display", "none");
		return;
	} else {
		console.log(msg);

		if(msg.consentFlag) {
			$('#buttonDiv').css("display", "");
			$('#msgDiv').css("display", "");
			$('#notfoundmsgDiv').css("display", "none");
			$('#notfoundconsentDiv').css("display", "none");
			$('#notSelectDiv').css("display", "none");
		} else {
			$('#buttonDiv').css("display", "none");
			$('#msgDiv').css("display", "none");
			$('#notfoundmsgDiv').css("display", "none");
			$('#notfoundconsentDiv').css("display", "");
			$('#notSelectDiv').css("display", "none");
			return;
		}

	}

	svc = msg.svc;
	xRootMtr = nvl(msg.xrootMtr);
	srcip = nvl(msg.srcIp);
	$('#subject').html(msg.subject);

	if(nvl(msg.svcNm) == "") {
		$('.svcnmSpan').html("");
		$('.svcnmSpan').css("display", "none");
	} else {
		$('.svcnmSpan').html(msg.svcNm);
		$('.svcnmSpan').css("display", "");
	}

	if(nvl(msg.subjectStr) == "") {
		$('#subjectStrDiv #subjectStr').html("");
		$('#subjectStrDiv').css("display", "none");
	} else {
		$('#subjectStrDiv #subjectStr').html(msg.subjectStr);
		$('#subjectStrDiv').css("display", "");
	}

	if(svc.startsWith("Q") && nvl(msg.xrootMtr) != "") {
		$('#usridTr').css("display", "");
		$('#srcTr').css("display", "none");
		$('#destTr').css("display", "none");
		$('#userTr').css("display", "none");

		$('#usridTr #ctimeTd').html(msg.ctime);
		$('#usridTr #userIdTd').html(msg.usrId);

	} else {
		$('#usridTr').css("display", "none");
		$('#srcTr').css("display", "");
		$('#destTr').css("display", "");
		$('#userTr').css("display", "");

		$('#srcipTd').html(msg.srcIp);
		$('#srcTr #ctimeTd').html(msg.ctime);
		$('#dstipTd').html(msg.dstIp);
		$('#bodySizeTd').html(convertFileSize(msg.bodySize));

		$('#userDiv').html(userHtml(msg.userList));
		$('#userTr #userIdTd').html(msg.usrId);
	}

	$('#sendUserDiv').html(userHtml(msg.senderList));

	if(msg.toList.length == 0) {
		$('#toTr').css("display", "none");
		$('#receiveUserDiv').html('');
	} else {
		$('#toTr').css("display", "");
		$('#receiveUserDiv').html(userHtml(msg.toList));
	}

	if(msg.ccList.length == 0) {
		$('#ccTr').css("display", "none");
		$('#ccUserDiv').html('');
	} else {
		$('#ccTr').css("display", "");
		$('#ccUserDiv').html(userHtml(msg.toList));
	}

	if(msg.bccList.length == 0) {
		$('#bccTr').css("display", "none");
		$('#bccUserDiv').html('');
	} else {
		$('#bccTr').css("display", "");
		$('#bccUserDiv').html(userHtml(msg.toList));
	}

	if(nvl(msg.host) == "") {
		$('#hostTr').css("display", "none");
		$('#hostDiv').html();

	} else {
		$('#hostTr').css("display", "");
		$('#hostDiv').html('<a style="word-break: break-all;" target="_blank" href="http://' + nvl(msg.host) + nvl(msg.path) + nvl(msg.query) + '">' + nvl(msg.host) + nvl(msg.path) + nvl(msg.query) + '</a>');
	}

	$('#msgIdDiv').html(msg.msgId);

	if(nvl(msg.attachStr) == "") {
		$('#attachStrDiv #attachStr').html("");
		$('#attachStrDiv').css("display", "none");
	} else {
		$('#attachStrDiv #attachStr').html(msg.attachStr);
		$('#attachStrDiv').css("display", "");
	}

	if(nvl(msg.fileNameStr) == "") {
		$('#fileNameStrDiv #fileNameStr').html("");
		$('#fileNameStrDiv').css("display", "none");
	} else {
		$('#fileNameStrDiv #fileNameStr').html(msg.fileNameStr);
		$('#fileNameStrDiv').css("display", "");
	}

	if(nvl(msg.attachStr) == "" && nvl(msg.fileNameStr) == "") {
		$('fileKwdDiv').css("display", "none");
	} else {
		$('fileKwdDiv').css("display", "");
	}

	setFileDiv(msg);			//file 및 OCR 처리

	setPatterDiv(msg.patterns);

	getBody('');

	if(nvl(msg.bodyStr) == "") {
		$('#bodyStrDiv #bodyStr').html("");
		$('#bodyStrDiv').css("display", "none");
	} else {
		$('#bodyStrDiv #bodyStr').html(msg.bodyStr);
		$('#bodyStrDiv').css("display", "");
	}


	setRead();					//읽음 여부 처리
}


function userHtml(userList) {
	var userDivHtml = "";

	for(var i = 0; i < userList.length; i++) {
		var user = userList[i];

		userDivHtml += '<span class="userInfoSpan"';
		userDivHtml += ' recvid="' + nvl(user.recvId) + '"';
		userDivHtml += ' recvip="' + nvl(user.ip) + '"';
		userDivHtml += ' recvemail="' + nvl(user.email) + '"';
		userDivHtml += ' recvname="' + nvl(user.name) + '"';
		userDivHtml += ' recvconm="' + nvl(user.coNm) + '"';
		userDivHtml += ' recvbusinm="' + nvl(user.busiNm) + '"';
		userDivHtml += ' recvsuborgnm="' + nvl(user.subOrgNm) + '"';
		userDivHtml += ' recvdeptnm="' + nvl(user.deptNm) + '"';
		userDivHtml += ' recvjikgubnm="' + nvl(user.jikgubNm) + '"';
		userDivHtml += '>';
		userDivHtml += user.viewStr
		userDivHtml += ' </span>';
	}

	return userDivHtml
}

function setFileDiv(msg) {
	var fileRows = $('#fileTable tr').length;
	for(var i = fileRows; i > 1; i--) {
		$('#fileTable  > tbody:last > tr:last').remove();
	}

	var fileStr = "";
	var trClass = "found";
	var extClass = "";
	var ocrYn = false;
	if(nvl(msg.attached) == "Y") {
		$('#fileDiv').css("display", "");
		var files = msg.files;
		for(var i = 0; i < files.length;i++) {
			var file = files[i];
			var attachName = file.attachName;
			var attachExt = file.attachExt;

			var ext = attachName.split(".");
			if(nvl(file.attachPath) == "" || file.attachNameExist == "F") trClass = "notfound";
			if(ext.length > 1 && nvl(attachExt) == ext[ext.length-1]) {
				extClass = "";
			} else {
				extClass = " differentExt";
			}

			console.log("ext.length : " + ext.length);
			console.log("attachExt : " + attachExt);
			console.log("ext[ext.length-1] : " + ext[ext.length-1]);
			console.log("extClass : " + extClass);

			if(attachExt == "unknown") {
				attachExt += "(txt)";
			}
			fileStr = '<tr id="' + file.attachId + '" size="' + file.attachSize + '" class="' + trClass + extClass +'" >';
			fileStr += '<td>';
			fileStr += '<span class="attachName" attachname="' + attachName + '"><span class="glyphicon glyphicon-paperclip" style="padding-right:5px;"></span>' + attachName + '</span>';
			if(nvl(file.attachTextPath) != "") {
				fileStr += '<span class="glyphicon glyphicon-search attachText" style="padding-left:5px;cursor:pointer;" title="' + message.attach + ' Text Viewer"></span>';
			}
			if(nvl(file.ocrYn) == "Y") {
				fileStr += '<span class="attachOcrText" style="padding-left:5px;cursor:pointer;" title="' + message.attach + ' OCR Text Viewer">';
				fileStr += '<img alt="" src="' + contextRoot + '/resources/img/ocr.png" style="width: 25px;">';
				fileStr += '</span>';
			}

			fileStr += '<td style="text-align: right;">' + convertFileSize(file.attachSize) + '</td>';
			fileStr += '<td style="text-align: center;"><span class="attachExt"><span class="glyphicon glyphicon-download-alt"></span>&nbsp;' + attachExt +'</span></td>';
			fileStr += '<td style="text-align: center;" class="downloadBtn"><span class="glyphicon glyphicon-download-alt downloadIcon"></span></td>';
			fileStr += '</tr>';
			$('#fileTable').append(fileStr);

			if(nvl(file.ocrYn) == "Y") {
				ocrYn = true;
			}
		}

		if(ocrYn) {
			setOcrFileDiv(msg.files);
			$('#OcrFileDiv').css("display", "");
		} else {
			$('#OcrFileDiv').css("display", "none");
		}
	} else {
		$('#fileDiv').css("display", "none");
		$('#OcrFileDiv').css("display", "none");
	}
}

function setOcrFileDiv(files) {
	var fileRows = $('#ocrFileTable tr').length;
	for(var i = fileRows; i > 0; i--) {
		$('#ocrFileTable  > tbody:last > tr:last').remove();
	}

	var fileStr = "";
	for(var i = 0; i < files.length;i++) {
		var file = files[i];
		if(nvl(file.ocrYn) == "Y") {
			var attachName = file.attachName;
			var attachExt = file.attachExt;

			fileStr = '<tr>';
			fileStr += '<th colspan="2">' + attachName + '</td>';
			fileStr += '</tr>';
			fileStr += '<tr>';
			fileStr += '<td>';
			fileStr += '<img style="max-width: 200px" src="data:image/' + attachExt + ';base64, ' + file.ocrImageStr + '"/>';
			fileStr += '</td>';
			fileStr += '<td>' + file.ocrText.replaceAll("\n", "<br>") + '</td>';
			fileStr += '</tr>';

			$('#ocrFileTable').append(fileStr);
		}
	}
}

function setPatterDiv(patterns) {
	var fileRows = $('#patternTable tr').length;
	for(var i = fileRows; i > 1; i--) {
		$('#patternTable  > tbody:last > tr:last').remove();
	}

	if(patterns.length == 0) {
		$('#patternDiv').css("display", "none");
	} else {
		$('#patternDiv').css("display", "");

		var patternStr = "";
		for(var i = 0; i < patterns.length;i++) {
			var pattern = patterns[i];
			var type = nvl(pattern.type);
			var attachName = nvl(pattern.attachName);

			var piType = "";
			if( type == "S") piType = message.subject;
			else if( type == "B") piType = message.body;
			else if( type == "F") piType = message.attach_name;
			else if( type == "A") piType = message.attach;
			else piType = message.message_info;

			patternStr = '<tr>';
			if(type == "A" || type == "B") {
				patternStr += '<td>' + piType + '</td>';
				patternStr += '<td style="word-break: break-word;">' + attachName + '</td>';
			} else {
				patternStr += '<td colspan="2" style="text-align: center;">' + piType + '</td>';
			}

			patternStr += '<td style="text-align: right;"><a href="javascript:void(0);" onclick="getEmassPatternDetail(this, \'SN\', \''+ type + '\', \''+ attachName + '\')">' + pattern.sn+ '</a></td>';
			patternStr += '<td style="text-align: right;"><a href="javascript:void(0);" onclick="getEmassPatternDetail(this, \'CN\', \''+ type + '\', \''+ attachName + '\')">' + pattern.cn+ '</a></td>';
			patternStr += '<td style="text-align: right;"><a href="javascript:void(0);" onclick="getEmassPatternDetail(this, \'DN\', \''+ type + '\', \''+ attachName + '\')">' + pattern.dn+ '</a></td>';
			patternStr += '<td style="text-align: right;"><a href="javascript:void(0);" onclick="getEmassPatternDetail(this, \'FN\', \''+ type + '\', \''+ attachName + '\')">' + pattern.fn+ '</a></td>';
			patternStr += '<td style="text-align: right;"><a href="javascript:void(0);" onclick="getEmassPatternDetail(this, \'PN\', \''+ type + '\', \''+ attachName + '\')">' + pattern.pn+ '</a></td>';
			patternStr += '<td style="text-align: right;"><a href="javascript:void(0);" onclick="getEmassPatternDetail(this, \'EC\', \''+ type + '\', \''+ attachName + '\')">' + pattern.ec+ '</a></td>';
			patternStr += '<td style="text-align: right;"><a href="javascript:void(0);" onclick="getEmassPatternDetail(this, \'EF\', \''+ type + '\', \''+ attachName + '\')">' + pattern.ef+ '</a></td>';
			patternStr += '<td style="text-align: right;"><a href="javascript:void(0);" onclick="getEmassPatternDetail(this, \'ID\', \''+ type + '\', \''+ attachName + '\')">' + pattern.id+ '</a></td>';
			patternStr += '<td style="text-align: right;">' + pattern.total + '</td>';
			patternStr += '</tr>';

			$('#patternTable').append(patternStr);
		}

	}
}

function setRead() {
	ui.get({
		url : 'setRead.xcn',
		msgId : msgId,
		success : function(data, total) {

		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}
