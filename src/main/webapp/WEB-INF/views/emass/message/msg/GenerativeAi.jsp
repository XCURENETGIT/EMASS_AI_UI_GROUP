<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS LTH - <s:message code="DATA_MONITOR.GENERATIVEAI_SERVICE"/></title>
	<style type="text/css">
	</style>
	<script type="text/javascript">

        var messengerListCnt = 0;
        var nodataMsg = '<s:message code="common.msg.nodata"/>';
        var chatting = '<s:message code="eikon.msg.chat"/>';
        var endChat = '<s:message code="eikon.msg.finish"/>';
        var unreadTitle = '<s:message code="eikon.msg.unreadTitle"/>';
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
            messengerAll:'<s:message code="condition.messenger.all"/>',
            orgBusiAll:'<s:message code="common.org.busi.all"/>',
            orgDeptAll:'<s:message code="common.org.dept.all"/>',
            msgSelect_all:'<s:message code="common.msg.select_all"/>',
            msgUnselect_all:'<s:message code="common.msg.unselect_all"/>',
            msgNoresult:'<s:message code="common.msg.noresult"/>',
            msgConnectError:'<s:message code="common.msg.connect.error"/>',
            messageSelectDashboard:'<s:message code="condition.message.select.dashboard"/>',
            msgConfirmSave:'<s:message code="common.msg.confirm.save"/>',
            searchService:'<s:message code="condition.search.service"/>',
            authAlert:'<s:message code="admin.auth.alert"/>',
            noselect:'<s:message code="common.msg.noselect"/>'

        };

        $(document).ready(function () {
            var options = getCoOptions();
            initCondition();

            var str = '<select class="form-control input-sm" id="coCd_inUser" name="coCd" style=" min-width: 197px;">';
            str += options;
            str += '</select>';
            $("#coSelect_inUser").html(str);

            var busiOptions = getBusiOptions();

            var strBusi = '<select class="form-control input-sm" id="busiCd_inUser" name="busiCd" style=" min-width: 197px;">';
            strBusi += busiOptions;
            strBusi += '</select>';
            $("#busiSelect_inUser").html(strBusi);

            $('#searchBtn').click(function(){

            /*    if( messengerListCnt == 0 ) {
                    ui.alertMsg('<s:message code="eikon.noList"/>');
                    return;
                }*/
                var startDt = $('#startDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
                var endDt = $('#endDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');

                if( startDt == ''){
                    ui.alertMsg('<s:message code="message.message.startdt.input"/>');
                    return;
                }
                if( endDt == ''){
                    ui.alertMsg('<s:message code="message.message.enddt.input"/>');
                    return;
                }
                if(startDt > endDt) {
                    ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
                    return;
                }
                if(getDayInterval(startDt, endDt) > 31) {
                    ui.alertMsg('<s:message code="eikon.msg.select.date"/>');
                    return;
                }
                eikon.getGenerativeList(1);

	           });
        });

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

        function getSelectOptionMessenger( data ){
            //var str = '<option value="">- <s:message code="eikon.msg.svcType"/> -</option>';
            var str = '';
            for (var i = 0; i < data.length; i++) {
                str += '<option value="'+data[i].code+'">'+data[i].codeName+'</option>';
            }
            return str;
        }


        function getCoOptions() {
            var result = '';
            ui.get({
                url: 'getCoList.xcn',
                asyncFlag: false,
                searchStr: '',
                success: function (data, total) {
                    result += '<option value="">-<s:message code="common.org.choose.co"/>-</option>';
                    for (var i = 0; i < data.length; i++) {
                        result += '<option value="' + data[i].coCd + '">' + data[i].coNm + '</option>';
                    }
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
            return result;
        }

        function getBusiOptions() {
            var result = '';
            ui.get({
                url: 'getBusiListByCo.xcn',
                asyncFlag: false,
                coCd:  $('#coCd_inUser option:selected').val(),
                success: function (data, total) {
                    result += '<option value="">-<s:message code="common.org.choose.busi"/>-</option>';
                    for (var i = 0; i < data.length; i++) {
                        result += '<option value="' + data[i].busiCd + '">' + data[i].busiNm + '</option>';
                    }
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
            return result;
        }

        function getDeptOptions() {
            var result = '';
            ui.get({
                url: 'getDeptListByCo.xcn',
                asyncFlag: false,
                searchStr: '',
                coCd: coCd_for_busi,
                success: function (data, total) {
                    result += '<option value="">-<s:message code="common.org.choose.dept"/>-</option>';
                    for (var i = 0; i < data.length; i++) {
                        result += '<option value="' + data[i].deptCd + '">' + data[i].deptNm + '</option>';
                    }
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
            return result;
        }

        function initCondition(){
            getGenerativeList();

        $('#serviceTypeSelect').selectpicker({
            container:'body',
            size: 15,
            width:'180px',
            noneSelectedText:condition.serviceAll,
            noneResultsText:condition.msgNoresult+' ',
            selectAllText:condition.msgSelect_all,
            deselectAllText:condition.msgUnselect_all,
            liveSearchPlaceholder:condition.searchService

        });

            var dateObj = new Date();
            $('#startdatepicker').datetimepicker({
                format: 'YYYY-MM-DD HH:mm:ss',
                locale: 'ko',
                sideBySide: true,
                defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate() - 1 ) )
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
                defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
            }).on("dp.change", function (e) {
                if( easyDateEndFlag ){
                    easyDateEndFlag = false;
                    return;
                }else{
                    $('#easyDate').val('');
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
      /*      condition.busi = arrayToString($('#busiSelect').selectpicker('val'));

            if(condition.busi != '') condition.busiStr = $('#busiSelect').parent().find('.filter-option').text();
            else condition.busiStr = '';

            var dv = $('#deptVal').val().split('|');
            condition.dept = dv.join(',');
            if(condition.dept != '') condition.deptStr = $('#deptStr').val();
            else condition.deptStr = '';*/
            /* condition.dept = arrayToString($('#deptSelect').selectpicker('val'));
			if(condition.dept != '') condition.deptStr = $('#deptSelect').parent().find('.filter-option').text();
			else condition.deptStr = ''; */

            condition.period = 1;
            condition.startDt = $('#startdatepicker').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
            condition.endDt = $('#enddatepicker').data("DateTimePicker").date().format('YYYYMMDDHHmmss');

            return condition;
        }

        function arrayToString( array ){
            if( array == null || array == undefined ) return "";
            else{
                return array.toString();
            }
        }
        function stringToArray( string ){
            if( string == null || string == undefined || string == '' ) return '';
            else if( typeof string !='string') return string;
            else{
                return string.split(',');
            }
        }
	</script>

<div class="container">
	<div class="boxArea">
		<div class="content_body">
			<div class="form-group form-inline not-dashed" style="padding-left: 10px; width: 100%;">
				<div class="input-group">
					<select id="serviceTypeSelect" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true">
					</select>
				</div>
				<div class="input-group" style="width: calc(90% - 300px);">
					<input type="text" class="form-control input-xs"
					       placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStrInput"
					       style="width: 100%;">
					<div class="input-group-btn" style="width:40px;">
						<button class="btn btn-md btn-success" type="button" accesskey="Q" id="searchBtn"><i
								class="glyphicon glyphicon-search"></i></button>
					</div>
				</div>
				<div class="checkbox c-checkbox" style="width:150px;">
					<label><input type="checkbox" name="readYn" id="readYn"><span class="fa fa-check"></span><s:message
							code="eikon.msg.notRead"/></label>
				</div>
			</div>
			<div style="background-color: #eee; margin-top: 5px;">
				<div class="form-group form-inline" style="padding-left: 10px;">
					<div class="input-group select-xs" style="width:98px">
						<select name="searchArea" class="selectpicker" id="easyDate" data-style="btn-default btn-sm">
							<option value="" selected="selected"><s:message code="condition.select.period"/></option>
							<option value="1"><s:message code="condition.today"/></option>
							<option value="2"><s:message code="condition.yesterday"/></option>
							<option value="3"><s:message code="condition.week" arguments="1"/></option>
							<option value="6"><s:message code="condition.month" arguments="1"/></option>
						</select>
					</div>
					<div class="form-group form-inline" style="padding-right:5px;">
						<div class="input-group">
							<div class="input-group date" id="startdatepicker">
								<input type="text" id="startDt" class="input-sm form-control border-radius-none" style="width: 150px;" />
								<span class="input-group-addon startDateBtn border-radius-none"> <span class="glyphicon glyphicon-calendar"></span>
										</span>
							</div>
						</div>
						~
						<div class="input-group">
							<div class="input-group date" id="enddatepicker">
								<input type="text" id="endDt" class="input-sm form-control border-radius-none" style="width: 150px;" />
								<span class="input-group-addon endDateBtn border-radius-none"><span class="glyphicon glyphicon-calendar"></span></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<input type="text" class="form-control input-sm"  placeholder="<s:message code="eikon.input.participation"/>" id="senders">
					</div>
					<div class="form-inline not-dashed" style="padding: 0px; margin: 0px;">
						<div class="btn-group filterBtn" data-toggle="buttons" style="float:left;padding-right:6px;">
							<label class="btn btn-sm btn-default active"><input type="radio" name="attachYn" id="attachAll" value="" checked>&nbsp; <s:message code="condition.isattached.all"/>&nbsp;&nbsp;</label>
							<label class="btn btn-sm btn-default"><input type="radio" name="attachYn" id="attachY" value="Y">&nbsp; <s:message code="eikon.attach.exist"/>&nbsp;&nbsp;</label>
						</div>
						<label for="busiSelect_inUser"><s:message code="common.org.busi"/></label>
						<div class="form-group" id="busiSelect_inUser"></div>
						<input type="hidden" id="busiHiddenNm" name="busiNm">

						<%--부서--%>
						<label for="deptSelect_inUser"><s:message code="common.org.dept"/></label>
						<div class="btn-group" data-toggle="buttons">
							<button type="button" class="btn btn-sm btn-default" id="dept"
							        style="border-radius: 0;"><span class="glyphicon glyphicon-plus-sign"></span>
								<s:message code="common.org.choose.dept"/></button>
							<span id="deptByCoSelectedArea" class="codeSelectedBtn">
									<button type="button" class="btn">0</button>
								</span>
							<span id="deptByCoStrSpan"></span>
							<input type="hidden" id="deptByCoStr" class="selectedTitle" name="deptNm">
							<input type="hidden" id="deptByCoVal" name="deptCd">
						</div>
							<input type="hidden" id="deptStr" class="selectedTitle">
							<input type="hidden" id="deptVal">
						</div>
					<div class="row" style="margin: 0px; margin-left: -1px; overflow: auto; height: calc(100% - 220px);">
						<div class="list-group" id="group_list" style="margin-bottom: 0px;">
							<a href="#" class="list-group-item list-group-item-action active" style="cursor:default;height:50px;">
								<p class="list-group-item-text" style="line-height:30px;">
									<i class="fa fa-envelope fa-sm"></i> <s:message code="eikon.msg.select.condition"/>
								</p>
							</a>
						</div>
					</div>
				</div>
			</div>
		<div style="height:30px;padding-left:32%; margin-top: 15px;" id="groupPage"></div>
	</div>

			</form>
		</div>
	</div>
</div>


<script type="text/javascript">

    var grid1 = new Xgrid('basicStatListGrid', contextRoot);



</script>