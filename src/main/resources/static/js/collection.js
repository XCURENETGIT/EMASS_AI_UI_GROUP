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
        $('#groupPage').html(getPage2(total, page, groupPageBreak, 'eikon.getGenerativeList'));

        $('#groupPage a').addClass('btn');
        $('#groupPage a').addClass('btn-sm');
        $('#groupPage a').addClass('btn-primary');
        $('#groupPage a').attr('role','button');
        $('#groupPage .direction').css('margin-right','4px');
        $('#groupPage strong').css('padding-left','10px');
        $('#groupPage strong').css('padding-right','10px');
    }


    function rtnGenerativeGroupList(data) {

        var str = '';
        var groupList = document.getElementById("group_list");

        // Clear existing content
        groupList.innerHTML = "";

        // Create a new ul element
        var ul = document.createElement("ul");
        ul.className = "people";

        // Loop through the data and create li elements
        for (var i = 0; i < data.length; i++) {
            var li = document.createElement("li");
            li.className = "person";
            li.setAttribute("data-chat", "person" + (i + 1));

            // Create left div
            var leftDiv = document.createElement("div");
            leftDiv.className = "left";

            var bodySnippet = data[i].body_snippet.length > 40 ? data[i].body_snippet.substring(0, 40) + "..." : data[i].body_snippet;

            var leftContent = "<p><span class='chatid'>" + data[i].userid + "</span>";
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
