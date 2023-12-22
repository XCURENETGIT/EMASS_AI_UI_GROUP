
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
        $('#groupPage').html(getPage3(total, page, groupPageBreak, 'eikon.getGenerativeList'));
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
                str += '<a class="active" href="#">' + i + '</a>';
            else
                str += '<a href="#" onclick="' + rtnMethod + '(' + i + ')">' + i + '</a>';
        }

        if (startPageNum + pageSizeNo <= lastPage)
            str += '<a href="#" onclick="' + rtnMethod + '(' + (startPageNum + pageSizeNo) + ')" class="direction"><img src="../img/ico_page_right2.png" alt=""></a>';
        else
            str += '<a href="#" class="direction" style="cursor:default"><img src="../img/ico_page_right2.png" alt=""></a>';

        str += '</div>';

        return str;
    }

    function getGenerativeDetailList(userid, srcip, usr_id, msgid){
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
            msgid : msgid,
            limit : detailLimit,
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
            li.setAttribute("data-chat", "person" + (i + 1));

            var leftDiv = document.createElement("div");
            leftDiv.className = "left";

            var bodySnippet = data[i].body_snippet.length > 40  ? data[i].body_snippet.substring(0, 40) + "..." : data[i].body_snippet;

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
            var imageName =mainContext+"/img/ico_sns_"+ makeMessengerText(data[i].svc).toLowerCase()+".png";
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
            str += '<a href="#" class="list-group-item list-group-item-action active" style="cursor:default;height:50px;">';
            str += '	<p class="list-group-item-text" style="line-height:30px;">';
            str += '		<i class="fa fa-envelope fa-sm"></i> ';
            str += nodataMsg; //common.msg.nodata
            str += '</p></a>';
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
