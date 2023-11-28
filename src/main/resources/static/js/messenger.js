var groupDataSet = [];
var detailDataSet = [];
var prevDetailDataSet = [];
var focusMsgId = '';
var participantDataSet = [];

var groupId = '';
var groupPageId = '';
var detailId = '';

var groupPage = 1;
var groupPageBreak = 10;
var groupMessagePage = 1;
var groupMessagePageBreak = 10;
var detailStartPage = 1;
var detailEndPage = 1;
var detailViewPage = 10;
var detailPageBreak = 100;
var detailLimit = 100;

var selectedSearchData = 1;
var searchOffset = 0;

var resizeTimer;

var detailSearchFlag=true;

var eikon = {
	init : function() {
		//makeSampleData();

		$('#scrollArea').scroll(function(){
			if( searchFlag ) return;
			clearTimeout(resizeTimer);
			var obj=this;
			resizeTimer = setTimeout(function() {
//				if( $('.btnCustomPosition').is(':visible') ) return;
				if( $(obj).scrollTop() < 10) {
					if($($('#timeline_list').children().first().children().first()).hasClass('timeline-panel') || $($('#timeline_list').children().first()).hasClass('timeline-panel')) $('.messenger_prev').css('display','none');
					else $('.messenger_prev').css('display','block');
					$('.messenger_next').css('display','none');
//					$('.messenger_prev').click();
				}
				else if( $('#timeline_list').height() <= $(obj).scrollTop()+$(obj).height()+10){
					if(detailDataSet.length < detailLimit) $('.messenger_next').css('display','none');
					else $('.messenger_next').css('display','block');
					$('.messenger_prev').css('display','none');
//					$('.messenger_next').click();
				}else{
					checkLastMsg(true);
				}
			},100);
		});

		$('.messenger_next, .messenger_prev').on('click', function() {
			var srcip = $('#selectUserInfo').attr('data-srcip');
			var usr_id = $('#selectUserInfo').attr('data-usrid');
			var xrootmtr = $('#xrootmtr').text();
			var msgIds = [];

			if($(this).hasClass('messenger_next')) {

				var msgid = $('.timeline').children().last().attr('id');
				getMessengerMessageNext(xrootmtr, srcip, usr_id, msgid);

			} else {

				var firstData = $('.timeline').children().filter(':eq(1)');
				var msgid = $(firstData).attr('id');
				getMessengerMessagePrev(xrootmtr, srcip, usr_id, msgid);

			}

			$(this).css('display','none');
		});
	},
	getGenerativeList: function (page) {
		/*		$('#startsubdatepicker').data("DateTimePicker").date($('#startdatepicker').data("DateTimePicker").date());
                $('#endsubdatepicker').data("DateTimePicker").date($('#enddatepicker').data("DateTimePicker").date());*/

		getMessengerGenertiveList(page);
	},

	getMessengerList : function(page){
		var searchType = $('input:radio[name=searchType]:input:checked').val();
		$('#startsubdatepicker').data("DateTimePicker").date( $('#startdatepicker').data("DateTimePicker").date() );
		$('#endsubdatepicker').data("DateTimePicker").date( $('#enddatepicker').data("DateTimePicker").date() );
		if( searchType == 'G'){
			getMessengerGroupList(page);
		}else if( searchType == 'GD'){
			getMessengerMessageList(page);
		}
	},
	getMessengerDetailList : function(xRootmtr, msgid){
		eikon.getMessengerDetailList(xRootmtr, msgid, '');
	},
	getMessengerDetailList : function(xRootmtr, msgid, srcip){
		eikon.getMessengerDetailList(xRootmtr, msgid, '', '');
	},
	getMessengerDetailList : function(xRootmtr, msgid, srcip, usr_id){
		if(!isDetailView()){
			alert(condition.authAlert);
			return;
		}
		if(xRootmtr == ''){
			return;
		}

		$('#searchResultArea').hide();
		$('#searchResultBtnArea').hide();
		detailStartPage = 1;
		detailEndPage = 1;
		var startDt = $('#startSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
		var endDt = $('#endSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');

		var data = {
			xRootmtr : xRootmtr,
			startDt : startDt,
			endDt : endDt,
			groupField: 'user_id'
		}
		//참여자 수, 참여자 정보
		ui.get({
			url : 'getMessengerGroupUserList.xcn',
			searchParam : data,
			success : function(data, total) {
				participantDataSet = data.groups;
				userSelectBox(data.groups, srcip, usr_id);
				//getMessengerGroupDetail(xRootmtr, msgid, srcip);
				//$('#groupParticipantCnt').html(total.comma());
			},
			error : function(status, message) {
				ui.alertMsg(message);
			},
			complete : function() {
			}
		});
	},
	getMessengerGroupDetail : function(xRootmtr, msgid, srcip, usr_id){
		searchFlag = true;
		ui.onBody('timeline_list', 0, 60);

		$("#timeline_list").html('');

		$('#searchMsgStrInput').val('');
		$('#searchResult').html('');
		$('#searchResultArea').hide();
		$('#searchResultBtnArea').hide();

		var startDt = $('#startSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
		var endDt = $('#endSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');

		var searchType = $('input:radio[name=searchType]:input:checked').val();
		if(searchType == null || searchType == undefined) searchType = 'G';
		if( searchType == 'G'){
			getMessengerMessageTotal(xRootmtr, srcip, startDt, endDt, usr_id, '');
		} else if( searchType == 'GD') {
			getMessengerMessageTotal(xRootmtr, srcip, startDt, endDt, usr_id, msgid);
		}
	},
	/**
	 * 결과 내 검색
	 */
	findMessageList : function(offset){
		var searchStr = $('#searchMsgStrInput').val();
		var xrootmtr = $('#xrootmtr').text();
		var srcip = $('#srcip').text();
		var usr_id = $('#usr_id').text();
		var startDt = $('#startSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
		var endDt = $('#endSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');

		if( offset < 0 ) searchOffset = $('#searchResult').html() - 1;
		if( offset >= $('#searchResult').html() || offset == 0 ) searchOffset = 0;

		if( searchStr == '' || (xrootmtr == undefined || xrootmtr == '')){
			$('#searchResult').html('');
			$('#searchResultArea').hide();
			$('#searchResultBtnArea').hide();
			return;
		}

		var conditions = {};
		var conArray = [];
		var condition = {};
		condition.searchStr = searchStr;
		condition.startDt = startDt;
		condition.endDt = endDt;
		condition.searchField = 'body.snippet attachname attachname_str attach';
		// condition.searchField = 'body.snippet attachname attachname_str attach';
		conArray.push(condition);
		conditions.conditions = conArray;

		detailSearchFlag = false;

		var data = {
			conditions : conditions,
			xRootMtr : xrootmtr,
			srcip: srcip,
			usr_id: usr_id,
			offset : searchOffset,
		}

		ui.postJson({
			url : 'getMessengerGroupDetailSearch.xcn',
			searchParam  : JSON.stringify( data ),
			success : function(data, total) {

				focusMsgId = data.toString();
				if(total > 0){
					$('#searchResult').html(total);
					$('#searchResultArea').show();
					$('#searchResultBtnArea').show();
					checkList(searchOffset);
				}
				else{
					$('#searchResult').html('0');
					$('#selectCnt').html('0');
					$('#searchResultArea').show();
					$('#searchResultBtnArea').hide();
				}
			},
			error : function(status, message) {
				ui.alertMsg(message);
			},
			complete : function() {
				searchFlag = false;
			}
		});
	},
	getMessengerGroupTextExport : function(attachUrl, xrootmtr){
		if( detailDataSet.length == 0 ) return;

		try {
			AttachDown.location.href = attachUrl;
		} catch (e) {
			AttachDown.src = attachUrl;
		}
	},
	getMessengerGroupAllExport : function(attachUrl){
		if( detailDataSet.length == 0 ) return;

		try {
			AttachDown.location.href = attachUrl;
		} catch (e) {
			AttachDown.src = attachUrl;
		}
	}
};

function getMessengerMessageTotal(xRootmtr, srcip, startDt, endDt, usr_id, msgid){
	//마지막 열람 msgid

	var searchData = {
		xRootMtr : xRootmtr,
		srcip : srcip,
		startDt : startDt,
		endDt : endDt,
		usr_id : usr_id, //기준이 srcip에서 usr_id로 변경되면서 마지막 데이터 기준 변경
		limit : detailLimit
	};


	ui.get({
		url : 'getMessengerMessageTotal.xcn',
		searchData : JSON.stringify(searchData),
		success : function(data, total) {
			$('#groupSubResultCnt').text(data.comma());
			getMessengerMessage(xRootmtr, srcip, usr_id, msgid);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			ui.off();
		}
	});
}

/**
 * 초기 데이터
 * @param xRootmtr
 * @param startTime
 * @param srcip
 * @param usr_id
 * @returns
 */
function getMessengerMessage(xRootmtr, srcip, usr_id, msgid) {
	var startDt = $('#startSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
	var endDt = $('#endSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
	$("#timeline_list").html('');
	var data = {
		xRootMtr  : xRootmtr,
		srcip : srcip,
		startDt  : startDt,
		endDt  : endDt,
		usr_id : usr_id,
		msgid : nvl(msgid),
		limit : detailLimit
	}
	ui.get({
		url : 'getMessengerMessage.xcn',
		searchParam : JSON.stringify(data),
		success : function(data, total) {
			if(data.groups.length > 0) {
				$('.messenger_prev').css('display','block');
			}
			if(data.groups.length == 0) {
				$("#timeline_list").html(noDataMsg());
				$('.messenger_prev').css('display','none');
				$('.messenger_next').css('display','none');
				$('#groupSubResultCnt').text(0);
				return;
			}

			detailDataSet = data.groups;
			prevDetailDataSet = data.groups;
			$("#timeline_list").html(makeList(false));
			Highlight( );
//			updateEmassMessengerAdminXrootMtr(xrootmtr, nvl(focusMsgId, detailDataSet[0].msgid), srcip, usr_id);
		},
		error : function(status, message) {
			searchFlag = false;
			ui.alertMsg(message);
		},
		complete : function() {
			ui.off('timeline_list');
			searchFlag = false;
			setMessengerRead();
		}
	});
}

/**
 * 다음 버튼 ( 최하단의 + 버튼 )
 */
function getMessengerMessageNext(xRootmtr, srcip, usr_id, msgid) {
	var startDt = $('#startSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
	var endDt = $('#endSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
	searchFlag = true;
	ui.get({
		url : 'getMessengerMessageNext.xcn',
		xRootMtr : xRootmtr,
		srcip : srcip,
		startDt : startDt,
		endDt : endDt,
		usr_id : usr_id,
		msgId : msgid,
		limit : detailLimit,
		success : function(data, total) {
			searchFlag = false;
			if(data.groups.length == 0) {
				detailDataSet = [];
				$("#timeline_list").prepend(noNextDataMsg());
				$('.messenger_next').css('display', 'none');
				return;
			}

			if(data.groups.length < detailLimit) {
				$('.messenger_next').css('display', 'none');
			}
			detailDataSet = data.groups;

			/**
			 * 전체 10 페이지가 넘어갈 경우 첫번째 페이지 제거
			 * 최상단에 날짜 출력
			 */
			if($(".pageInfoDiv").size() > detailViewPage-1){
				$('.pageInfoDiv').first().remove();
				var firstObj = $('.pageInfoDiv').first();
				if(!firstObj.children().filter(':first').hasClass('date_li')){
					var date = viewDate(firstObj.children().filter(':first').attr('ctime').substring(0,10));
					firstObj.prepend(date);
				}
			}

			$("#timeline_list").append(makeList(true));
			Highlight( );
		},
		error : function(status, message) {
			searchFlag = false;
			ui.alertMsg(message);
		},
		complete : function() {
			ui.off('timeline_list');
			setMessengerRead();
		}
	});
}

/**
 * 이전 버튼 ( 최상단의 + 버튼 )
 */
function getMessengerMessagePrev(xRootmtr, srcip, usr_id, msgid) {
	var startDt = $('#startSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
	var endDt = $('#endSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
	searchFlag = true;

	var data = {
		xRootMtr : xRootmtr,
		srcip : srcip,
		startDt : startDt,
		endDt : endDt,
		usr_id : usr_id,
		msgId : msgid,
		limit : detailLimit
	};
	ui.get({
		url : 'getMessengerMessagePrev.xcn',
		searchParam : JSON.stringify(data),
		success : function(data, total) {
			searchFlag = false;
			if(data.groups.length == 0) {
				prevDetailDataSet = [];
				$("#timeline_list").prepend(noPrevDataMsg());
				$('.messenger_prev').css('display', 'none');
				return;
			}
			if(data.groups.length < detailLimit) {
				$('.messenger_prev').css('display', 'none');
			}
			prevDetailDataSet = data.groups;

			if($(".pageInfoDiv").size() > detailViewPage-1){
				$(".pageInfoDiv").last().remove();
			}

			$("#timeline_list").prepend(makePrevList());
			$('#scrollArea').scrollTop($(".pageInfoDiv").height());
			Highlight( );
			detailSearchFlag = false;
		},
		error : function(status, message) {
			searchFlag = false;
			ui.alertMsg(message);
		},
		complete : function() {
			ui.off('timeline_list');
			setMessengerRead(prevDetailDataSet);
		}
	});
}

function userSelectBox(data, srcip, usr_id){
	var name = $('#selectUserInfo').attr('data-name');
	var str = '';

	for(var i=0; i<data.length; i++){
		var ip = data[i].srcip == undefined ? Object.keys(data[i].srcIpList[0]).toString() : data[i].srcip;
		var selectUserTitle = ip;
		if( nvl(data[i].name) != '') {
			selectUserTitle = data[i].name;
			if( nvl(data[i].usr_id) != '') selectUserTitle += ' ('+data[i].usr_id+')';
			else if( nvl(data[i].srcip) != '') selectUserTitle += ' ('+data[i].srcip+')';
		}
		else if( nvl(data[i].usr_id) != '') selectUserTitle = data[i].usr_id;
		else if( nvl(data[i].srcip) != '') selectUserTitle = data[i].srcip;

		$('#selectUserInfo').attr('data-srcip', nvl(ip));
		$('#selectUserInfo').attr('data-name', nvl(data[i].name));
		$('#selectUserInfo').attr('data-usrid', nvl(data[i].usr_id));
		$('#selectUserInfo').html(selectUserTitle);

		str += '<li class="selectUser" data-name="'+nvl(data[i].name)+'" data-srcip="'+nvl(ip)+'" data-usrid="'+nvl(data[i].usr_id)+'"><a href="javascript:void(0);">'+selectUserTitle+'</a></li>';
	}
	$('#selectUser_menu').html(str);
	getDetailData(usr_id);
}
function getDetailData(usr_id){
	if(usr_id !=''){
		var idx = 0;
		$('.selectUser').each(function(index){
			var value = $(this).attr('data-usrid');
			if(value == usr_id){
				idx = index;
				return false;
			}
		});
		$('.selectUser:eq('+idx+')').click();
	}else $('.selectUser').first().click();
}

function rtnGroupGenertiveList(data) {
	var str = '';
	for (var i = 0; i < data.length; i++) {

		var className='';
		if( isConsent() && $('#consentNo').val() == '') className='cursor-default';
		str += '<a href="#" class="list-group-item list-group-item-action style="min-height:60px;padding: 5px 15px;">';
		str += '<div class="list-group-item-heading" style="font-size: 20px; margin-left: 15px;">'+data[i].sender+data[i].jikgubNm+'('+data[i].srcip+')'+'</div>';
		str += '<div class="pull-xs-right" style="font-size: 12px; margin-left: 15px; clear: both;">'+data[i].ctime+'</div>';
		str += '<div class="pull-xs-right" style="font-size: 12px; margin-left: 15px; border: 1px solid #ccc; padding: 2px 4px; clear: both;">'+makeMessengerText(data[i].svc)+'</div>';
		//str += '	<h5 class="list-group-item-heading" style="padding-left: 14px;">'+data[i].body_snippet.replaceAll('<', '&lt;').replaceAll('>', '&gt;')+'</h5>';
		/*	str += '	<p class="list-group-item-text" style="float:left;">';*/


		str += "<span style='word-break: break-all'>"+ data[i].body_snippet + "</span>";
		str += "<span style='position:absolute;top:30px; right: 15px;font-size: 11px; padding: 2px 4px; margin-left: 3px;'>";
		str += "</span>";
		str += '</p></a>';
	}
	if( data.length == 0 ){
		str += '<a href="#" class="list-group-item list-group-item-action active" style="cursor:default;height:50px;">';
		str += '	<p class="list-group-item-text" style="line-height:30px;">';
		str += '		<i class="fa fa-envelope fa-sm"></i> ';
		str += nodataMsg; //common.msg.nodata
		str += '</p></a>';
	}

	$('#group_list').html( str );
	$('#group_list').animate({
		scrollTop : 0
	}, 0);

}


function rtnFileList(data, type) {
	var str = '<table border="1"><thead><tr><th>파일 전송 서비스</th><th>파일명/예상 확장자</th><th>미리보기</th></tr></thead><tbody>';

	alert(data.length);
	for (var i = 0; i < data.length; i++) {
		var service = makeMessengerText(data[i].svc)
		var fileName = data[i].attachName;
		var ext = data[i].attachType;
		var srcip = data[i].srcip;
		var fileExtension = "미리보기";

		// 행 추가
		str += '<tr>';
		str += '<td>' + service + data[i].ctime +'<br>'+srcip+'</td>';
		str += '<td>' + fileName + '/' + ext + '</td>';
		str += '<td><button onclick="previewFile(\'' + fileName + '\')">미리보기</button></td>';
		str += '</tr>';
	}

	str += '</tbody></table>';

	$('#group_list').html(str);
	$('#group_list').animate({
		scrollTop: 0
	}, 0);
}


function rtnGroupList(data, type){
	var str = '';
	for (var i = 0; i < data.length; i++) {
		var user_cnt = data[i].user_cnt;
		var svc3 = data[i].svc3;
		var closeFlag = false;
		if( user_cnt == 1 && svc3 == 'L') closeFlag = true;

		var className='';
		if( isConsent() && $('#consentNo').val() == '') className='cursor-default';
		str += '<a href="#" class="list-group-item list-group-item-action '+className+'" xrootmtr="'+nvl(data[i].xrootmtr)+'" msgid="'+data[i].msgid+'" srcip="'+data[i].srcip+'" usrid="'+data[i].usr_id+'" style="min-height:60px;padding: 5px 15px;">';
		str += '<div class="pull-xs-right" style="font-size: 12px; margin-left: 15px;">'+data[i].ctime+'</div>';

		if(type == 'G'){
			if(closeFlag) str += '<span class="tag tag-default tag-pill pull-xs-right">'+endChat+'</span>';
			else str += '<span class="tag tag-success tag-pill pull-xs-right">'+chatting+'</span>';
		}
		str += '	<h5 class="list-group-item-heading" style="padding-left: 14px;">'+data[i].title.replaceAll('<', '&lt;').replaceAll('>', '&gt;')+'</h5>';
		str += '	<p class="list-group-item-text" style="float:left;">';


		if( svc3 == 'C' ) str += '<i class="fa fa-commenting-o fa-sm"></i> ';
		else if( svc3 == 'F' ) str += '<i class="fa fa-floppy-o fa-sm"></i> ';
		else if( svc3 == 'J' ) str += '<i class="fa fa-sign-in fa-sm"></i> ';
		else if( svc3 == 'L' ) str += '<i class="fa fa-sign-out fa-sm"></i> ';

		str += "<span class='maxwidth50'>"+ data[i].message + "</span>";
		str += "<span style='position:absolute;top:30px; right: 15px;font-size: 11px; padding: 2px 4px; margin-left: 3px;'>";
		if(type == 'G' && data[i].unread_cnt > 0) str += '	<span class="tag tag-danger tag-pill pull-xs-right" style="margin-left:2px;" title="'+unreadTitle+'">'+data[i].unread_cnt.comma()+'</span>';
		str += "<span class='pull-xs-right' style='border: 1px solid #ccc; font-size: 11px; padding: 2px 4px; margin-left: 3px;'>"+makeMessengerText(data[i].svc)+"</span>";
		str += "</span>";
		str += '</p></a>';
	}
	if( data.length == 0 ){
		str += '<a href="#" class="list-group-item list-group-item-action active" style="cursor:default;height:50px;">';
		str += '	<p class="list-group-item-text" style="line-height:30px;">';
		str += '		<i class="fa fa-envelope fa-sm"></i> ';
		str += nodataMsg; //common.msg.nodata
		str += '</p></a>';
	}

	$('#group_list').html( str );
	$('#group_list').animate({
		scrollTop : 0
	}, 0);
}
function makeMessengerText( svc ){
	var str = '';
	svc = svc.substring(0, svc.length - 1);

	$('#serviceTypeSelect option').each(function(e){
		if( svc == $(this).val() ) str = $(this).text();
	});
	return str;
}

function getMessengerGroupList (page){
	var readYn = $("input:checkbox[id='readYn']").is(":checked") ? 'N' : '';
	groupPage = page;
	var offset = groupPage*groupPageBreak - groupPageBreak;
	let data = {
		conditions :  getCondition( ) ,
		limit : groupPageBreak,
		offset : offset,
		readYn : readYn
	}
	searchFlag = true;
	ui.onBody('timeline_list', 0, -20);
	ui.postJson({
		url : 'getMessengerGroupList.xcn',
		searchParam : JSON.stringify(data),
		success : function(data, total) {
			rtnGroupList(data.groups, 'G');
			rtnGroupPage(total, page, 'G');
			HighlightGroup( );
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			searchFlag = false;
			ui.off('timeline_list');
		}
	});
};

function getFiletransferList(page){
	var readYn = $("input:checkbox[id='readYn']").is(":checked") ? 'N' : '';
	ui.onBody('timeline_list', 0, -20);

	var searchData = {
		startDate : startDt+"000000"
		, endDate : endDt+"235959"
		, offset : grid1.data.length
		, limit : grid1.pageSize
	}

	ui.postJson({
		url: 'getFiletransferList.xcn',
		searchParam : JSON.stringify(searchData),

		success: function (data, total) {
			alert("성공함");
			rtnFileList(data.groups, 'G');
		},
		error: function (status, message) {

			ui.alertMsg(message);
		},
		complete: function () {
			searchFlag = false;
			ui.off('timeline_list');
		}
	});
}

function getMessengerNoteList(page){

	var readYn = $("input:checkbox[id='readYn']").is(":checked") ? 'N' : '';
	groupPage = page;
	var offset = groupPage*groupPageBreak - groupPageBreak;
	var searchData = {
		serviceType:  'XU1S',
		startDate: '20231012180000',
		endDate: '20231030120000',
		offset:100,
		limit:10
	};
	ui.get({
		url: 'getMessengerNoteList.xcn',
		searchParam : JSON.stringify(searchData),
		success: function (data, total) {
			console.log(data);
			rtnGroupList(data.groups, 'GD');
			rtnGroupPage(total, page, 'GD');
			HighlightGroup( );
		},
		error: function (status, message) {

			ui.alertMsg(message);
		},
		complete: function () {
			searchFlag = false;
			ui.off('timeline_list');
		}
	});
}

function getMessengerGenertiveList(page) { //생성형 AI검색
	var readYn = $("input:checkbox[id='readYn']").is(":checked") ? 'N' : '';
	groupPage = page;
	var offset = groupPage*groupPageBreak - groupPageBreak;
	let data = {
		conditions :  getCondition(),
		limit : groupPageBreak,
		offset : 0,
		readYn : readYn
	}
	ui.get({
		url: 'getMessengerGenertiveList.xcn',
		searchParam : JSON.stringify(data),
		success: function (data, total) {
			console.log(data);
			rtnGroupGenertiveList(data.groups);
			HighlightGroup( );
		},
		error: function (status, message) {

			ui.alertMsg(message);
		},
		complete: function () {
			searchFlag = false;
			ui.off('timeline_list');
		}
	});
}

function getMessengerMessageList (page){

	//JSON.stringify( condition )
	var readYn = $("input:checkbox[id='readYn']").is(":checked") ? 'N' : '';
	groupMessagePage = page;
	var offset = groupMessagePage*groupMessagePageBreak - groupMessagePageBreak;
	searchFlag = true;
	var data = {
		conditions : getCondition( ),
		limit : groupPageBreak,
		offset : offset,
		readYn : readYn

	}
	ui.onBody('timeline_list', 0, -20);
	ui.postJson({
		url : 'getMessengerMessageList.xcn',
		searchParam : JSON.stringify(data),
		success : function(data, total) {
			rtnGroupList(data.groups, 'GD');
			rtnGroupPage(total, page, 'GD');
			HighlightGroup( );
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			searchFlag = false;
			ui.off('timeline_list');
		}
	});
};

function rtnGroupPage(total, page, searchType){
	$('#groupResultCnt').html(total.comma());
	$('#groupPage').html(getPage2(total, page, groupPageBreak, 'eikon.getMessengerList'));

	$('#groupPage a').addClass('btn');
	$('#groupPage a').addClass('btn-sm');
	$('#groupPage a').addClass('btn-primary');
	$('#groupPage a').attr('role','button');
	$('#groupPage .direction').css('margin-right','4px');
	$('#groupPage strong').css('padding-left','10px');
	$('#groupPage strong').css('padding-right','10px');
}



function setMessengerRead(dataSet){
	if(dataSet == null || dataSet == undefined) dataSet = detailDataSet;

	ui.get({
		url : 'setMessengerRead.xcn',
		body : JSON.stringify(dataSet),
//		xRootMtr : rootmtr,
//		srcIp : srcip,
//		usr_id : usr_id, //기준이 srcip에서 usr_id로 변경되면서 마지막 데이터 기준 변경
//		startDt : startDt,
//		endDt : endDt,
//		searchStr : searchStr,
//		limit : detailLimit,
		success : function(data, total) {

		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {}
	});
}
function getPageNum(msgid){
	var idx = -1;
	for (var i = 0; i < detailDataSet.length; i++) {
		if(detailDataSet[i].msgid == msgid){
			idx = i;
			break;
		}
	}
	var rtnValue = Math.ceil((idx)/detailPageBreak);
	if(idx != -1) return rtnValue == 0 ? 1 : rtnValue;
	else return 1;
}

//function detailMessageFocus(msgid){
//	var idx = -1;
//	for (var i = 0; i < detailDataSet.length; i++) {
//		if(detailDataSet[i].msgid == msgid){
//			idx = i;
//			break;
//		}
//	}
//	findList(msgid, idx+1);
//}
//
//function detailDateFocus(date){
//	var idx = -1;
//	for (var i = 0; i < detailDataSet.length; i++) {
//		if(detailDataSet[i].ctime.substring(0, 10) == date){
//			idx = i;
//			break;
//		}
//	}
//	findList('date'+date, idx+1);
//}

function makeList(nextFlag){
	var dataHasFlag = false;
	var str = '<ul class="pageInfoDiv timeline">';
	var usrid = $('#selectUserInfo').attr('data-usrid');
	var srcip = $('#selectUserInfo').attr('data-srcip');
	for(var i=0 ; i < detailDataSet.length ; i++) {
		dataHasFlag = true;
		var obj = detailDataSet[i];
		var chkPati = false;
		if( (nvl(obj.user) != '' && obj.user == obj.sender) || usrid == obj.title || usrid == obj.sender ) chkPati = true;
		str += checkDate(i);

		str+='<li class="timeline-inverted ' +(i==0 && !nextFlag ? 'lastReadLi' : '')+ '" id="'+obj.msgid+'" ctime="'+obj.ctime+'">';

		var svc3 = obj.svc3;
		if(!chkPati){
			if( obj.readYn == 'Y' ) str+='	<div class="timeline-badge custom read">';
			else str+='	<div class="timeline-badge custom unread">';

			if( svc3 == 'C' ) str += '<i class="fa fa-commenting-o fa-sm" style="font-size: 20px;"></i> ';
			else if( svc3 == 'F' ) str += '<i class="fa fa-floppy-o fa-sm"></i> ';
			else if( svc3 == 'J' ) str += '<i class="fa fa-sign-in fa-sm"></i> ';
			else if( svc3 == 'L' ) str += '<i class="fa fa-sign-out fa-sm"></i> ';
			str+='	</div>';
		}

		str+='	<div class="timeline-panel '+(chkPati ? 'panel_right' : 'panel_left' )+'" style="width: calc(100% - 200px);">';
		str+='		<div class="list-group-item cursor-pointer readPoint">';
		str+='			<div class="timeline-heading">';

		var title = obj.title;
		str+='				<h4 class="timeline-title">'+title+'<span class="timeline-date pull-xs-right">'+obj.ctime+'</span></h4>';
		str+='			</div>';
		var addClass = '';
		if( svc3 == 'J' || svc3 == 'L' ) addClass=' text-center'
		str+='			<div class="timeline-body'+addClass+'">';


		if( svc3 == 'F' ){
			var files = '';
			var hashes = '';
			if(obj.message != undefined) files = obj.message.split('|');
			if(obj.attachhash != undefined) hashes = obj.attachhash.split('|');

			for( var j = 0; j < files.length; j++ ){
				str+='<a href="javascript:void(0);" class="file_link" msgid="'+obj.msgid+'" attachhash="'+nvl(hashes[j]).trim()+'">'+nvl(files[j]).trim()+'<br /></a>';
			}
		}
		else str+=''+obj.message.replaceAll('\n', '<br/>')+'';
		str+='			</div>';
		str+='		</div>';
		str+='	</div>';

		if(chkPati){
			if( obj.readYn == 'Y' ) str+='	<div class="timeline-badge custom custom_right read">';
			else str+='	<div class="timeline-badge custom custom_right unread">';

			if( svc3 == 'C' ) str += '<i class="fa fa-commenting-o fa-sm" style="font-size: 20px;"></i> ';
			else if( svc3 == 'F' ) str += '<i class="fa fa-floppy-o fa-sm"></i> ';
			else if( svc3 == 'J' ) str += '<i class="fa fa-sign-in fa-sm"></i> ';
			else if( svc3 == 'L' ) str += '<i class="fa fa-sign-out fa-sm"></i> ';
			str+='	</div>';
		}
		str+='</li>';
	}
	str+='</ul>';
	if(detailDataSet.length < detailLimit) str += noNextDataMsg();


	if(!dataHasFlag){
		str = noDataMsg();
	}

	return str;
}

function makePrevList(){
	var dataHasFlag = false;
	var str = '<ul class="pageInfoDiv timeline">';
	if(prevDetailDataSet.length < detailLimit) str += noPrevDataMsg();
	var usrid = $('#selectUserInfo').attr('data-usrid');
	var srcip = $('#selectUserInfo').attr('data-srcip');

	for(var i=prevDetailDataSet.length - 1 ; i > -1 ; i--) {
		dataHasFlag = true;
		var obj = prevDetailDataSet[i];
		var chkPati = false;
		if( (nvl(obj.user) != '' && obj.user == obj.sender) || usrid == obj.title || usrid == obj.sender ) chkPati = true;

		str += checkDatePre(i);

		str+='<li class="timeline-inverted" id="'+obj.msgid+'" ctime="'+obj.ctime+'">';

		var svc3 = obj.svc3;
		if(!chkPati){
			if( obj.readYn == 'Y' ) str+='	<div class="timeline-badge custom read">';
			else str+='	<div class="timeline-badge custom unread">';

			if( svc3 == 'C' ) str += '<i class="fa fa-commenting-o fa-sm" style="font-size: 20px;"></i> ';
			else if( svc3 == 'F' ) str += '<i class="fa fa-floppy-o fa-sm"></i> ';
			else if( svc3 == 'J' ) str += '<i class="fa fa-sign-in fa-sm"></i> ';
			else if( svc3 == 'L' ) str += '<i class="fa fa-sign-out fa-sm"></i> ';
			str+='	</div>';
		}

		str+='	<div class="timeline-panel '+(chkPati ? 'panel_right' : 'panel_left' )+'" style="width: calc(100% - 200px);">';
		str+='		<div class="list-group-item cursor-pointer readPoint">';
		str+='			<div class="timeline-heading">';

		var title = obj.title;
		str+='				<h4 class="timeline-title">'+title+'<span class="timeline-date pull-xs-right">'+obj.ctime+'</span></h4>';
		str+='			</div>';
		var addClass = '';
		if( svc3 == 'J' || svc3 == 'L' ) addClass=' text-center'
		str+='			<div class="timeline-body'+addClass+'">';


		if( svc3 == 'F' ){
			var files = '';
			var hashes = '';
			if(obj.message != undefined) files = obj.message.split('|');
			if(obj.attachhash != undefined) hashes = obj.attachhash.split('|');

			for( var j = 0; j < files.length; j++ ){
				str+='<a href="javascript:void(0);" class="file_link" msgid="'+obj.msgid+'" attachhash="'+nvl(hashes[j]).trim()+'">'+nvl(files[j]).trim()+'<br /></a>';
			}
		}
		else str+=''+obj.message.replaceAll('\n', '<br/>')+'';
		str+='			</div>';
		str+='		</div>';
		str+='	</div>';

		if(chkPati){
			if( obj.readYn == 'Y' ) str+='	<div class="timeline-badge custom custom_right read">';
			else str+='	<div class="timeline-badge custom custom_right unread">';

			if( svc3 == 'C' ) str += '<i class="fa fa-commenting-o fa-sm" style="font-size: 20px;"></i> ';
			else if( svc3 == 'F' ) str += '<i class="fa fa-floppy-o fa-sm"></i> ';
			else if( svc3 == 'J' ) str += '<i class="fa fa-sign-in fa-sm"></i> ';
			else if( svc3 == 'L' ) str += '<i class="fa fa-sign-out fa-sm"></i> ';
			str+='	</div>';
		}
		str+='</li>';
	}
	str+='</ul>';

	if(!dataHasFlag){
		str = noDataMsg();
	}

	return str;
}

function noDataMsg(){
	var str='<div class="timeline-panel" style="padding-left:10px;">';
	str+='	<span class="list-group-item cursor-text">';
	str+='		<div class="timeline-body" style="text-align: center;">';
	str+=			xcnuiJS.noDataPeriod; //선택한 기간에 데이터가 없습니다.
	str+='		</div>';
	str+='	</span>';
	str+='</div>';
	return str;
}

function noPrevDataMsg(){
	var str='<div class="timeline-panel" style="padding-left:10px;">';
	str+='	<span class="list-group-item cursor-text">';
	str+='		<div class="timeline-body" style="text-align: center;">';
	str+=			xcnuiJS.noDataPrev; //이전 데이터가 없습니다.
	str+='		</div>';
	str+='	</span>';
	str+='</div>';
	return str;
}

function noNextDataMsg(){
	var str='<div class="timeline-panel" style="padding-left:10px;">';
	str+='	<span class="list-group-item cursor-text">';
	str+='		<div class="timeline-body" style="text-align: center;">';
	str+=			xcnuiJS.noDataNext; //다음 데이터가 없습니다.
	str+='		</div>';
	str+='	</span>';
	str+='</div>';
	return str;
}

function checkDate(idx){
	var lastTime = $('.timeline').children().last().attr('ctime');

	if( idx > 0 && detailDataSet[idx].ctime.substring(0, 10) == detailDataSet[idx-1].ctime.substring(0, 10) ){
		return '';
	}
	if( lastTime != undefined && detailDataSet[idx].ctime.substring(0, 10) == lastTime.substring(0, 10) ){
		return '';
	}

	var str = viewDate(detailDataSet[idx].ctime.substring(0, 10));

	return str;
}

function checkDatePre(idx){
	var firstData = $('.timeline').children().filter(':eq(1)');
	var endDate = $(firstData).attr('ctime');

	if( idx==0 && prevDetailDataSet[idx].ctime.substring(0, 10) == endDate.substring(0, 10)) {
		$('.timeline').children().first().remove();
	}
	if( idx < (prevDetailDataSet.length-1) && prevDetailDataSet[idx].ctime.substring(0, 10) == prevDetailDataSet[idx+1].ctime.substring(0, 10) ){
		return '';
	}

	var str = viewDate(prevDetailDataSet[idx].ctime.substring(0, 10));

	return str;
}

function viewDate(dateStr){
	var str = '';
	str+='<li class="date_li" id="date'+dateStr+'">';
	str+='	<div class="date_li_div">';
	str+='		<div class="date_line">';
	str+='			<span class="timeline_date">'+dateStr+'</span>';
	str+='		</div>';
	str+='	</div>';
	str+='</li>';

	return str;
}

//function appendList(){
//	if( searchFlag ) return;
//	console.log("append");
//
//	searchFlag = true;
//	ui.onBody('timeline_list', 0, 60);
//
//	detailEndPage++;
//	var str = makeList(detailEndPage);
//	if( str == ''){
//		detailEndPage--;
//		searchFlag = false;
//		ui.off('timeline_list');
//		return;
//	}
//
//	if($(".pageInfoDiv").size() > detailViewPage-1){
//		$(".pageInfoDiv").first().remove();
//		detailStartPage++;
//	}
//	setTimeout(function(){
//		$("#timeline_list").append(str);
//		Highlight( );
//		ui.off('timeline_list');
//		searchFlag = false;
//	}, 100);
//}
//
//function prependList(){
//	if( searchFlag ) return;
//	console.log("prepend");
//
//	searchFlag = true;
//	ui.onBody('timeline_list', 0, 60);
//
//	detailStartPage--;
//	var str = makeList(detailStartPage);
//	if( str == ''){
//		detailStartPage++;
//		searchFlag = false;
//		ui.off('timeline_list');
//		return;
//	}
//
//	if($(".pageInfoDiv").size() > detailViewPage-1){
//		$(".pageInfoDiv").last().remove();
//		detailEndPage--;
//	}
//	setTimeout(function(){
//		$('#timeline_list').prepend(str);
//		Highlight( );
//		$('#scrollArea').scrollTop($(".pageInfoDiv").height());
//		ui.off('timeline_list');
//		searchFlag = false;
//	}, 100);
//}

function checkList(cnt){
//	selectedSearchData = cnt;
	getMessengerMessage($('#xrootmtr').text(), $('#selectUserInfo').attr('data-srcip'), $('#selectUserInfo').attr('data-usrid'), focusMsgId);
	$('#selectCnt').html(cnt+1);
}

//function findList(id, line){
//	ui.onBody('timeline_list', 0, 60);
//	var selectPage = 1
//	var str = '';
//
//	if(line != -1) {
//		selectPage = Math.ceil((line)/detailPageBreak);
//		if( selectPage == 0 ) selectPage = 1;
//	}
//	if(selectPage < detailStartPage || selectPage > detailEndPage ) str = makeList(selectPage);
//
//	if( str == ''){
//		searchFlag = false;
//	}else{
//		$("#timeline_list").html('').html(str);
//		Highlight( );
//	}
//
//	setTimeout(function(){
//		ui.off('timeline_list');
//
//		detailStartPage=selectPage;
//		detailEndPage=selectPage;
//		moveTargetHeight(id, true);
//		searchFlag = false;
//	}, 50);
//}

function checkLastMsg(){
	var xrootmtr = $('#xrootmtr').text();
	var srcip = $('#srcip').text();
	var usr_id = $('#usr_id').text();
	var lastMsgId = '';
	var topHeight = 200; //영역을 제외한 상단 높이
	var marginBottom = 55; //하단에 최소한으로 보여줄 픽셀 위치 (첫줄이 보이면 읽음)
	//var displayHeight = $('#scrollArea').height(); //화면 출력 영역

	//console.log("displayHeight = "+displayHeight);

	$('#timeline_list div.list-group-item').each(function(){
		var objOffsetTop = $(this).offset().top-topHeight;
		var objHeight = $(this).height();
		//console.log("objHeight = "+objHeight)
		//console.log("objOffsetTop = "+objOffsetTop)
		//console.log(objOffsetTop-(objHeight/2)-marginBottom)
		if(objOffsetTop-(objHeight/2)-marginBottom < 0){
			lastMsgId = $(this).parent().parent().attr('id');
		}else{
			return updateEmassMessengerAdminXrootMtr(xrootmtr, lastMsgId, srcip, usr_id);
		}
	});
}

function moveTargetHeight(id, moveFlag){
	$('.lastReadLi').removeClass('lastReadLi');
	var obj = $('#'+idIndicator(id));
	if(obj.length != 0){
		obj.addClass('lastReadLi');

		if(moveFlag){
			//$("#scrollArea").animate({
			//	scrollTop: obj.position().top
			//}, 10);
			$(location).attr('href', '#'+id);
		}
	}
}
var readTimeFlag = false;
function updateEmassMessengerAdminXrootMtr(xrootmtr, lastMsgId, srcip, usr_id){
	if(srcip == undefined && usr_id == undefined) return;
	if(readTimeFlag) return true;
	readTimeFlag = true;
	moveTargetHeight(lastMsgId, false);

	ui.get({
		url : 'updateEmassMessengerAdminXrootMtr.xcn',
		xRootMtr : xrootmtr,
		msgId : lastMsgId,
		srcip : srcip,
		usr_id: usr_id,
		asyncFlag : false,
		success : function(data, total) {
			return true;
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			setTimeout(function(){
				readTimeFlag = false;
			}, 1000);
		}
	});
	return false;
}

//테스트 데이터 생성
function makeSampleData(){
	for(var i=0 ; i < 50 ; i++) {
		var obj = {};
		obj.title = '김지훈 <응용개발팀>';
		obj.time = '2016-08-06 11:45:22';
		if(i%2 == 1) obj.content = 'Cras sit amet nibh<br>libero...Cras sit amet nibh libero..<br>.Cras sit amet nibh libero...Cras sit amet nibh liber<br><br><br>o...Cras sit amet nibh l<br>ibero...Cras sit amet nibh<br><br> libero...Cras sit amet nibh libero..<br><br><br>.Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...Cras sit amet nibh libero...';
		else obj.content = 'Cras sit amet nibh libero...';
		detailDataSet.push(obj);
	}
}

function idIndicator(id){
	return id.fReplaceWord('.', '\\.');
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

function HighlightGroup( ) {
	setTimeout(function(){
		var searchs = $('#searchStrInput').val().split(/\||\+|\s|\*|\"/);
		if ( searchs.length > 0 ){
			var group_list_obj = $("#group_list").find('code');

			for ( var i=0 ; i < searchs.length ; i++ ) {
				if ( searchs[i] == '' ) continue;
				$( group_list_obj ).highlight(searchs[i], 'BS');
			}
		}
	}, 100);
}

function Highlight( ) {
	setTimeout(function(){
		var searchs = $('#searchStrInput').val().split(/\||\+|\s|\*|\"/);
		if ( searchs.length > 0 ){
			var timeline_list_obj = $("#timeline_list").find('code');

			for ( var i=0 ; i < searchs.length ; i++ ) {
				if ( searchs[i] == '' ) continue;
				$( timeline_list_obj ).highlight(searchs[i], 'BS');
			}
		}
	}, 100);
}




