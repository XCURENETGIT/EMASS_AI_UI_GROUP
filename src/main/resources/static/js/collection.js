var groupDataSet = [];
var detailDataSet = [];
var prevDetailDataSet = [];
var focusMsgId = '';
var participantDataSet = [];
var detailMsgid=[];

var groupId = '';
var groupPageId = '';
var detailId = '';
var detailCount=0;

var groupPage = 1;
var groupPageBreak = 10;
var groupMessagePage = 1;
var groupMessagePageBreak = 10;
var detailStartPage = 1;
var detailEndPage = 1;
var detailViewPage = 10;
var detailPageBreak = 100;
var detailLimit = 5;

var selectedSearchData = 1;
var searchOffset = 0;

var resizeTimer;

var detailSearchFlag=true;

var eikon2 = {
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
            var userid = $('#selectUserInfo').attr('data-name');
            var msgIds = [];

            if($(this).hasClass('messenger_next')) {

                var msgid = $('.timeline').children().last().attr('id');
                getGenerativeMessageNext(userid, srcip, usr_id, msgid);

            } else {

                var firstData = $('.timeline').children().filter(':eq(1)');
                var msgid = $(firstData).attr('id');
                getGenerativeMessagePrev(userid, srcip, usr_id, msgid);

            }

            $(this).css('display','none');
        });
    },
    getCollectionList : function(page){
        var searchType = $('input:radio[name=searchType]:input:checked').val();
        getCollectionGroupList(page);
    },
    getCollectionDetailList : function(userid, msgid, srcip, usr_id,type){
        searchFlag = true;
        ui.onBody('timeline_list', 0, 60);

        $("#timeline_list").html('');

        $('#searchMsgStrInput').val('');
        $('#searchResult').html('');
        $('#searchResultArea').hide();
        $('#searchResultBtnArea').hide();

        var startDt=$('#startDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
        var endDt=$('#endDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');


        getCollectionMessageTotal(userid, srcip, startDt, endDt, usr_id, '',type);
    },
    getCollectionGroupTextExport : function(attachUrl, userid){
        if( detailDataSet.length == 0 ) return;

        try {
            AttachDown.location.href = attachUrl;
        } catch (e) {
            AttachDown.src = attachUrl;
        }
    },
    getCollectionGroupTextExport : function(attachUrl){
        if( detailDataSet.length == 0 ) return;

        try {
            AttachDown.location.href = attachUrl;
        } catch (e) {
            AttachDown.src = attachUrl;
        }
    },
    /**
     * 결과 내 검색
     */
    findMessageList : function(offset){
        var searchStr = $('#searchMsgStrInput').val();
        var userid = $('#selectUserInfo').attr("data-name");
        var srcip = $('#selectUserInfo').attr("data-srcip");
        var startDt = $('#startSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '')+"0000000";
        var endDt = $('#endSubDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '')+"235959";

        if( offset < 0 ) searchOffset = $('#searchResult').html() - 1;
        if( offset >= $('#searchResult').html() || offset == 0 ) searchOffset = 0;

        if( searchStr == '' || (userid == undefined || userid == '')){
            $('#searchResult').html('');
            $('#searchResultArea').hide();
            $('#searchResultBtnArea').hide();
            return;
        }

        var filterVal = {};
        var conArray = [];
        var condition = {};
        condition.searchStr = searchStr;
        condition.startDt = startDt;
        condition.endDt = endDt;
        condition.searchField = 'body attachname attachname_str attach';
        conArray.push(condition);
        filterVal.conditions = conArray;

        detailSearchFlag = false;

        ui.postJson({
            url : 'getGenerativeGroupDetailSearch.xcn',
            userid : userid,
            srcip: srcip,
            data : JSON.stringify( filterVal ),
            offset : searchOffset,
            success : function(data, total) {
                focusMsgId = data.toString();
                if(total > 0){
                    $('#searchResult').html(total);
                    $('#searchResultArea').show();
                    $('#searchResultBtnArea').show();

                    detailMsgid=data;
                    detailMsgid.sort();
                    console.log(detailMsgid);
                    console.log("현재 번호  "+ detailMsgid[searchOffset]);
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
    }
};


function getCollectionMessageTotal(userid, srcip, startDt, endDt, usr_id, msgid,type){
/*총 갯수 계산하는 함수*/
    ui.get({
        url : 'getCollectionMessageTotal.xcn',
        userid : userid,
        srcip : srcip,
        startDt : startDt+"000000",
        endDt : endDt+"235959",
        usr_id : usr_id,
        limit : 0,
        type:type,
        success : function(data, total) {
            $('#groupSubResultCnt').text(data.comma());
            getCollectionMessage(userid, srcip, usr_id, msgid,type);
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
 * 다음 버튼 ( 최하단의 + 버튼 )
 */
function getGenerativeMessageNext(userid, srcip, usr_id, msgid) {
    var startDt = $('#startDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
    var endDt = $('#endDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
    searchFlag = true;
    ui.get({
        url : 'getGenerativeMessageNext.xcn',
        userid : userid,
        srcip : srcip,
        startDt : startDt+"000000",
        endDt : endDt+"235959",
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

            if(data.groups.length >= detailLimit) {
                $('.messenger_next').css('display', 'block');
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
function getGenerativeMessagePrev(userid, srcip, usr_id, msgid) {

    var startDt = $('#startDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
    var endDt = $('#endDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
    searchFlag = true;
    ui.get({
        url : 'getGenerativeMessagePrev.xcn',
        userid : userid,
        srcip : srcip,
        startDt : startDt+"000000",
        endDt : endDt+"235959",
        usr_id : usr_id,
        msgId : msgid,
        limit : detailLimit,
        success : function(data, total) {
            searchFlag = false;
            if(data.groups.length == 0) {
                prevDetailDataSet = [];
                $("#timeline_list").prepend(noPrevDataMsg());
                $('.messenger_prev').css('display', 'none');
                return;
            }
            if(data.numFound < detailLimit) {
                $('.messenger_prev').css('display', 'none');
            }
            else{
                $('.messenger_prev').css('display', 'block');
            }
            prevDetailDataSet = data.groups;

            if($(".pageInfoDiv").size() > detailViewPage-1){
                $(".pageInfoDiv").last().remove();
            };

           /* $(".conversation-start").children().children()*/

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


function makeMessengerText( svc ){
    var str = '';
    svc = svc.substring(0, svc.length - 1);

    $('#serviceTypeSelect option').each(function(e){
        if( svc == $(this).val() ) str = $(this).text();
    });
    return str;
}



function getCollectionGroupList (page){
    var readYn = $("input:checkbox[id='readYn']").is(":checked") ? 'N' : '';
    groupPage = page;
    var offset = groupPage*groupPageBreak - groupPageBreak;

    searchFlag = true;
    ui.onBody('timeline_list', 0, -20);
    ui.postJson({
        url : 'getCollectionGroupList.xcn',
        data : JSON.stringify( getCondition( )),
        readYn : readYn,
        offset : offset,
        limit : groupPageBreak,
        success : function(data, total) {
            rtnGenerativeGroupList(data.groups)
            rtnnGenerativeGroupPage(total, page);
        },
        error : function(status, message) {
            ui.alertMsg(message);
        },
        complete : function() {
            searchFlag = false;
            ui.off('timeline_list');
        }
    });
}

function setMessengerRead(dataSet){
    if(dataSet == null || dataSet == undefined) dataSet = detailDataSet;

    ui.get({
        url : 'setMessengerRead.xcn',
        body : JSON.stringify(dataSet),
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

function makeFileList(data) {
    var str = '';

    if (data.length === 0) {
        str += '<div class="list-group-item02 ma_none">첨부파일이 없습니다</div>';

    } else {
        str = '<ul>';
        for (var i = 0; i < data.length; i++) {
            str += '<li><p class="fileListdown" attachsize="' + data[i].attachsize + '" msgid="' + data[i].msgid + '" attachhash="' + data[i].attachhash + '"><span class="img"></span><span>';
            str += '<a href="#">' + data[i].attachname + "." + data[i].attachtype + '</a>';
            str += '</span><span style="position: absolute; right: 0; top: 8px;" ><button class="btnchatdown_w downloadIcon"></button></span></p></li>';
        }

        str += '</ul>';
        str += '<div class="top mat16"><div class="myDropdown mal8 downAllFile"><span>전체파일 저장 </span><div class="dropdown-content"></div></div></div>';
    }

    return str;
}



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

        str+='<li class="p20 bubble txt_right slide_right timeline-inverted ' +(i==0 && !nextFlag ? 'lastReadLi' : '')+ '" id="'+obj.msgid+'" ctime="'+obj.ctime+'" userid="'+obj.userid+'" srcip="'+obj.srcip+'">';


        var svc3 = obj.svc3;
        str+='	<div class="me timeline-panel" >';

        if(obj.attached=="Y"){
            var attachhash = obj.attachhash;
            var attachname = obj.attachname;
            var attachsize = obj.attachsize;
            var attachtype = obj.attachtype;

            var attachhashArray = attachhash.split('|');
            var attachnameArray = attachname.split('|');
            var attachsizeArray = attachsize.split('|');
            var attachtypeArray = attachtype.split('|');

            for (var i = 0; i < attachhashArray.length; i++) {
                str += '<p class="filedown file_link" msgid="' + obj.msgid + '" attachhash="' + attachhashArray[i] + '">';
                str += '<span class="img"></span>';
                str += '<span>' + attachnameArray[i] + '.' + attachtypeArray[i] + '<br/>';
                str += attachsizeArray[i] + 'KB</span>';
                str += '<button class="btnchatdown downlodadBtn"></button></p>';

            }
        }

        else {
            if (obj.body_snippet != undefined) str += '' + obj.body_snippet.replaceAll('\n', '<br/>') + '';
        }
        str+='			</div>';

        str+=' <div class="bubbleDate mat4">';
        str+='<span>'+obj.ctime+'</span>';
        str+='<span class="mal4">'+makeMessengerText(obj.svc)+'</span>';
        str+='</div></div>';
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
        str += checkDatePre(i);
        dataHasFlag = true;
        var obj = prevDetailDataSet[i];
        if( (nvl(obj.user) != '' && obj.user == obj.sender) || usrid == obj.title || usrid == obj.sender ) chkPati = true;


        str+='<li class="p20 bubble txt_right slide_right timeline-inverted" id="'+obj.msgid+'" ctime="'+obj.ctime+'" userid="'+obj.userid+'" srcip="'+obj.srcip+'">';

        str+='	<div class="me timeline-panel">';

        if(obj.attached=="Y"){
            str+='<p class="filedown file_link" msgid="'+obj.msgid+'"+ attachhash="'+obj.attachhash+'" +>';
            str+='<span class="img"></span>';
            str+='<span>'+obj.attachname+'.'+obj.attachtype+'<br/>';
            str+=obj.attachsize+'KB</span>';
            str+='<button class="btnchatdown downloadIcon"></button></p>';
        }

        else {
            if (obj.body_snippet != undefined) str += '' + obj.body_snippet.replaceAll('\n', '<br/>') + '';
        }
        str+='			</div>';

        str+=' <div class="bubbleDate mat4">';
        str+='<span>'+obj.ctime+'</span>';
        str+='<span class="mal4">'+makeMessengerText(obj.svc)+'</span>';
        str+='</div></div>';
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
    str+='	<span class="list-group-item02 cursor-text">';
    str+='		<div class="timeline-body" style="text-align: center;">';
    str+=			xcnuiJS.noDataPeriod; //선택한 기간에 데이터가 없습니다.
    str+='		</div>';
    str+='	</span>';
    str+='</div>';
    return str;
}

function noPrevDataMsg(){
    var str='<div class="timeline-panel">';
    str+='	<span class="list-group-item02 cursor-text">';
    str+='		<div class="timeline-body" style="text-align: center;">';
    str+=			xcnuiJS.noDataPrev; //이전 데이터가 없습니다.
    str+='		</div>';
    str+='	</span>';
    str+='</div>';
    return str;
}

function noNextDataMsg(){
    var str='<div class="timeline-panel">';
    str+='	<span class="list-group-item02 cursor-text">';
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

    var str='<div class="conversation-start">';
    str += viewDate(detailDataSet[idx].ctime.substring(0, 10));
    str +='</div>'

    return str;
}

function checkDatePre(idx){
    var firstData = $('.timeline').children().filter(':eq(1)');
    var endDate = $(firstData).attr('ctime');

    if( idx==0 && prevDetailDataSet[idx].ctime.substring(0, 10) == endDate.substring(0, 10)) {

        $('.date_li').remove();
    }
    if( idx < (prevDetailDataSet.length-1) && prevDetailDataSet[idx].ctime.substring(0, 10) == prevDetailDataSet[idx+1].ctime.substring(0, 10) ){
        return '';
    }

    var str='<div class="conversation-start">';
    str += viewDate(prevDetailDataSet[idx].ctime.substring(0, 10));
    str +='</div>'
    return str;
}

function viewDate(dateStr){
    var str = '';
    str+='<li class="date_li" id="date'+dateStr+'">';
    str+='	<div class="date_li_div">';
    str+='		<div class="date_line">';
    str+='			<span>'+dateStr+'</span>';
    str+='		</div>';
    str+='	</div>';
    str+='</li>';

    return str;
}


function checkList(cnt){
//	selectedSearchData = cnt;
    getGenerativeMessage($('#selectUserInfo').attr('data-name'), $('#selectUserInfo').attr('data-srcip'), $('#selectUserInfo').attr('data-usr_id'), detailMsgid[cnt]);
    $('#selectCnt').html(cnt+1);
}



function checkLastMsg(){
    var userid = $('#userid').text();
    var srcip = $('#srcip').text();
    var lastMsgId = '';
    var topHeight = 200; //영역을 제외한 상단 높이
    var marginBottom = 55; //하단에 최소한으로 보여줄 픽셀 위치 (첫줄이 보이면 읽음)
    //var displayHeight = $('#scrollArea').height(); //화면 출력 영역

    //console.log("displayHeight = "+displayHeight);

    $('#timeline_list div.me').each(function(){
        var objOffsetTop = $(this).offset().top-topHeight;
        var objHeight = $(this).height();
        //console.log("objHeight = "+objHeight)
        //console.log("objOffsetTop = "+objOffsetTop)
        //console.log(objOffsetTop-(objHeight/2)-marginBottom)
        if(objOffsetTop-(objHeight/2)-marginBottom < 0){
            lastMsgId = $(this).parent().parent().attr('id');
        }else{
            return updateEmassGenerativeAdminUserid(userid, lastMsgId, srcip);
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
function updateEmassGenerativeAdminUserid(userid, lastMsgId, srcip){ /*읽은위치저장*/
    moveTargetHeight(lastMsgId, false);

    ui.get({
        url : 'updateEmassGenerativeAdminUserid.xcn',
        userid : userid,
        msgId : lastMsgId,
        srcip : srcip,
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



/* 드롭박스 구성*/
function getGenerativeList(){
    ui.get({
        url : 'getGenerativeList.xcn',
        asyncFlag : false,
        success : function(data, total) {
            messengerListCnt = data.length;
            if( data.length > 0 ){
                $('#serviceTypeSelect').html( getSelectOptionMessenger( data ) );
            }
        },
        error : function(status, message) {
            ui.alertMsg('error:' + status);
        },
        complete : function() {
            searchFlag=false;
        }
    });
}
function getNoteServiceList(){
    ui.get({
        url : 'getNoteList.xcn',
        asyncFlag : false,
        success : function(data, total) {
            messengerListCnt = data.length;
            if( data.length > 0 ){
                $('#serviceTypeSelect').html( getSelectOptionMessenger( data ) );
            }
        },
        error : function(status, message) {
            ui.alertMsg('error:' + status);
        },
        complete : function() {
            searchFlag=false;
        }
    });
}


/* 파일전송 드롭박스 구성*/
function getFileList(){
    ui.get({
        url : 'getFileList.xcn',
        asyncFlag : false,
        success : function(data, total) {
            messengerListCnt = data.length;
            if( data.length > 0 ){
                $('#serviceTypeSelect').html( getSelectOptionMessenger( data ) );
            }
        },
        error : function(status, message) {
            ui.alertMsg('error:' + status);
        },
        complete : function() {
            searchFlag=false;
        }
    });
}


function getCondition( ){
    var filterVal = {};

    if( isConsent()){
        filterVal.consentNo = $('#consentNo').val();
        filterVal.consentName = $('#consentName').text();
        //filterVal.consentIp = $('#consentIp').val();
        //filterVal.consentEmail = $('#consentEmail').val();
        filterVal.consentUserId = $('#consentUserId').val();
    }

    var conArray = [];
    conArray.push( createCondition( ) );
    filterVal.conditions = conArray;

    //console.log(JSON.stringify(filterVal))
    return filterVal;
}

function rtnnGenerativeGroupPage(total, page){
    $('#groupResultCnt').html(total.comma());
    $('#groupPage').html(getPage3(total, page, groupPageBreak, 'eikon2.getGenerativeList'));
}

function getPage3(total, pageCount, listSize, rtnMethod){
    var str = "";
    var pageSizeNo = 5; // 화면에 표시할 페이지 수
    var lastPage = Math.ceil(total / listSize); // 전체 페이지 수
    var screenPageNo = Math.ceil(listSize / pageSizeNo); // 전체 스크린(페이지) 수 ,
    var currentScreenPageNo = Math.ceil(pageCount / pageSizeNo); // 사용자가 현재
    var startPageNum = (currentScreenPageNo * pageSizeNo - pageSizeNo) + 1; // 페이지
    var endPageNum = startPageNum + pageSizeNo - 1; // 페이지 끝 넘버
    if (endPageNum > lastPage)
        endPageNum = lastPage;

    if (lastPage == 0) {
        return '';
    }
    if (screenPageNo == 0)
        return;

    str += '<div class="pagination">';

    if (pageCount > pageSizeNo)
        str += '<a href="#" onclick="' + rtnMethod + '(' + (endPageNum - pageSizeNo) + ')" class="direction"><img src="../img/ico_page_left2.png" alt=""></a>';
    else
        str += '<a href="#" class="direction" style="cursor:default"><img src="../img/ico_page_left2.png" alt=""></a>';

    for (var i = startPageNum; i <= endPageNum; i++) {
        if (i == pageCount)
            str += '<a class="active" onclick="' + rtnMethod + '(' + i + ',' + pageCount + ')">' + i + '</a>';
        else
            str += '<a href="#" onclick="' + rtnMethod + '(' + i + ',' + pageCount + ')">' + i + '</a>';
    }



    if (startPageNum + pageSizeNo <= lastPage)
        str += '<a href="#" onclick="' + rtnMethod + '(' + (startPageNum + pageSizeNo) + ')" class="direction"><img src="../img/ico_page_right2.png" alt=""></a>';
    else
        str += '<a href="#" class="direction" style="cursor:default"><img src="../img/ico_page_right2.png" alt=""></a>';

    str += '</div>';

    return str;
}

function getCollectionMessage(userid, srcip, usr_id, msgid,type){
    $("#timeline_list").html('');

    var startDt=$('#startDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
    var endDt=$('#endDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');

    ui.get({
        url : 'getGenerativeMessage.xcn',
        userid : userid,
        srcip : srcip,
        startDt : startDt+"00000",
        endDt : endDt+"235959",
        usr_id : usr_id,
        msgId : nvl(msgid),
        limit : detailLimit,
        type:type,
        success : function(data, total) {
            if(data.groups.length > 0) {
                $('.messenger_prev').css('display','block');
                $('#totalCount').css('display','block');
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

            getCollectionAllfile(userid, srcip, usr_id, msgid,type);


            if(data.numFound < detailLimit)
                $('.messenger_next').css('display','none');
            else $('.messenger_next').css('display','block');

            $("#timeline_list").html(makeList(false));
            Highlight( );
        },
        error : function(status, message) {
            searchFlag = false;
            ui.alertMsg(message);
        },
        complete : function() {
            ui.off('timeline_list');
            searchFlag = false;
        }
    });
}

function getCollectionAllfile(userid, srcip, usr_id, msgid,type){
    var startDt=$('#startDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
    var endDt=$('#endDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');

    ui.get({
        url : 'getCollectionGroupAttachList.xcn',
        userid : userid,
        srcip : srcip,
        usr_id : usr_id,
        startDt: startDt+"000000",
        endDt: endDt+235959,
        searchStr: $('#searchMsgStrInput').val(),
        attachYn : 'Y',
        type:type,
        success : function(data, total) {
            $('.rightFileList').html(makeFileList(data));
        },
        error : function(status, message) {
            ui.alertMsg(message);
        },
        complete : function() {

        }
    });


}



function rtnGenerativeGroupList(data) {

    var str = '';
    var groupList = document.getElementById("group_list");

    groupList.innerHTML = "";

    var ul = document.createElement("ul");
    ul.className = "people";

    for (var i = 0; i < data.length; i++) {
        var li = document.createElement("li");
        li.className = "person";
        li.setAttribute("userid", data[i].userid);
        li.setAttribute("msgid", data[i].msgid);
        li.setAttribute("srcip", data[i].srcip);
        li.setAttribute("usrid", data[i].usrid);
        li.setAttribute("body_snippet", data[i].body_snippet);
        li.setAttribute("name", data[i].name);
        li.setAttribute("data-chat", "person" + (i + 1));

        var leftDiv = document.createElement("div");
        leftDiv.className = "left";

        if(data[i].body_snippet!=undefined) {
            var bodySnippet = data[i].body_snippet.length > 40 ? data[i].body_snippet.substring(0, 40) + "..." : data[i].body_snippet;
        }

        else{
            var bodySnippet="";
        }
        var leftContent = "<p><span class='chatid'>" + data[i].userid +"("+data[i].deptNm+"/"+data[i].jikgubNm+"/"+data[i].name+")"+"</span>";
        if (data[i].attached === 'Y') {
            leftContent += "<span class='file'></span>";
        }
        leftContent += "</p>" +
            "<p><span class='name'>" + data[i].user + "</span><span class='bar'></span><span class='preview'>" + bodySnippet + "</span></p>";

        leftDiv.innerHTML = leftContent;
        li.appendChild(leftDiv);

        // Create right div
        var rightDiv = document.createElement("div");
        rightDiv.className = "right";
        var imageName =mainContext+"/img/icon/ico_sns_"+ data[i].svc+".png";
        var makescv = makeMessengerText(data[i].svc);
        var rightContent = "<p><span class='logo'><img src="+imageName+">"+makescv+"</span></p>";


        if (data[i].unread_cnt > 0) {
            rightContent += "<span class='new'>" + data[i].unread_cnt + "</span>";
        }

        rightContent += "</p><span class='time'>" + data[i].ctime + "</span>";

        rightDiv.innerHTML = rightContent;
        li.appendChild(rightDiv);

        // Append li to ul
        ul.appendChild(li);

    }
    if( data.length == 0 ){
        str += '	<div class="pl20 pr20">';
        str += '    <a href="#" class="list-group-item list-group-item-action active" style="cursor:default;">';
        str += '	    <p class="list-group-item-text" style="line-height:30px; text-align: center">';
        str += '<img src="' + mainContext + '/img/icon/img_nodata02.png" width="72" height="72">';
        str += '	    <BR/>';
        str += nodataMsg; //common.msg.nodata
        str += '</p></a></div>';
        $('#group_list').html( str );
    }

    groupList.appendChild(ul);


}



function createCondition( ){
    var allSelect = new Array();
    var condition = {};
    if( $('#serviceTypeSelect').selectpicker('val') == null ) {
        $('#serviceTypeSelect option').each(function(){
            if( $(this).val() != '' && $(this).val() != null ) allSelect.push( $(this).val() );
        });
        condition.serviceType = arrayToString(allSelect);
    } else {
        condition.serviceType = arrayToString($('#serviceTypeSelect').selectpicker('val'));
    }
    condition.searchStr = $('#searchStrInput').val();
    condition.senders = $('#senders').val();
    condition.attachYn = $('input:radio[name=attachYn]:input:checked').val();
    condition.busi = arrayToString($('#busiSelect').selectpicker('val'));

    if(condition.busi != '') condition.busiStr = $('#busiSelect').parent().find('.filter-option').text();
    else condition.busiStr = '';

    var dv = $('#deptVal').val().split('|');
    condition.dept = dv.join(',');
    if(condition.dept != '') condition.deptStr = $('#deptStr').val();
    else condition.deptStr = '';
    /* condition.dept = arrayToString($('#deptSelect').selectpicker('val'));
    if(condition.dept != '') condition.deptStr = $('#deptSelect').parent().find('.filter-option').text();
    else condition.deptStr = ''; */

    condition.period = 1;
    condition.startDt = $('#startdatepicker').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
    condition.endDt = $('#enddatepicker').data("DateTimePicker").date().format('YYYYMMDDHHmmss');

    return condition;
}
