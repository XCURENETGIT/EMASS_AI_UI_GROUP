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
