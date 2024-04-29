<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<head>
	<title></title>
	<%
		String api_insaYn = Common.nvl(Config.getString("api.insa.useyn"));
	%>

	<style type="text/css">
		.hide {
			display: none;
		}
		#selectedCodeTitle, #selectedCodeTitlePop {
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
		/* .sortableColumn,.uploadSortableColumn { width: 40%;padding: 0;}
		.sortableColumn li,.uploadSortableColumn li {
			font-weight:bold;
			color: #333;
			padding: 3px;
			margin-top: 2px;
		}
		.sortableColumn li span,.uploadSortableColumn li span {float: left;} */
	</style>
	<script type="text/javascript">
        var api_insaYn = '<%=api_insaYn%>';
        var searchFlag=false;
        var coCd_for_busi = '';
        var insa_schedule = '';
        var current_select_count = 11;
        var accountMainDelimeter = '<%=Config.getString("account.main.delimiter", "%")%>';
        var accountSubDelimeter = '<%=Config.getString("account.sub.delimiter", "$")%>';
        var datas = {
            idx : 0,
            add : function(selectIdx, svc, account, disabledFlag){
                if(disabledFlag == undefined) disabledFlag = false;

                this.idx++;
                var idx = this.idx;
                $('#dataHtml input, #dataHtml select, #dataHtml button').prop('disabled', disabledFlag);
                var tab_content = $('#dataHtml').html().replaceAll('dataContentId', ('dataContentId')+idx)
                    .replaceAll('btnDataAdd', ('btnDataAdd')+idx)
                    .replaceAll('btnDataDel', ('btnDataDel')+idx)
                    .replaceAll('datas.add', ('datas.add(\'')+idx+'\')')
                    .replaceAll('datas.del', ('datas.del(\'')+idx+'\')')
                    .replaceAll('userAccountSvc_inUser', 'userAccountSvc_inUser'+idx)
                    .replaceAll('userAccountText_inUser', 'userAccountText_inUser'+idx);

                if($('#userAccountSelectDiv .dataContent').length == 0 || selectIdx == '') {
                    $('#userAccountSelectDiv').append(tab_content);
                } else {
                    $('#userAccountSelectDiv .dataContent').each(function(i, val) {
                        if(this.id == 'dataContentId'+selectIdx) {
                            $(this).after(tab_content);
                            return false;
                        }
                    });
                }
                if(svc != undefined && account != undefined){
                    $('#userAccountText_inUser'+idx).val(account);
                    $('#userAccountSvc_inUser'+idx).val(svc);
                }
            },
            del : function(selectIdx){
                if($('#userAccountSelectDiv .dataContent').length > 1) {
                    $('#dataContentId'+selectIdx).remove();
                }
            },
            reset : function(){
                $('#userAccountSelectDiv').html('');
            },
            getAccountData : function(){
                var resultData = [];

                $('#userAccountSelectDiv .dataContent').each(function(i, val) {
                    var subValue = '';
                    var svc = $(this).find('.userAccountSvc').val();
                    var account = $(this).find('.userAccountText').val();

                    if(svc != '' && account != ''){
                        subValue = svc + accountSubDelimeter + account;
                        resultData.push(subValue);
                    }

                });

                return resultData.join(accountMainDelimeter);
            },
            setAccountData : function (userAccountStr, disabledFlag){

                datas.reset();
                if(userAccountStr == '' || userAccountStr == null){
                    datas.add();
                    return;
                }

                var userAccounts = userAccountStr.split(accountMainDelimeter);
                for(var i=0; i<userAccounts.length; i++){
                    var userAccount = userAccounts[i].split(accountSubDelimeter);
                    if(userAccount.length != 2) continue;

                    datas.add('', userAccount[0], userAccount[1], disabledFlag);
                }
            }
        };
        $(document).ready(function(){

            $('#dept').click(function(){
                openCodeWindow('deptByCo', $('#coCd_inUser option:selected').val(), $('#deptByCoVal').val(), $('#deptByCoStr').val());
            });

            $('#uploadUserPop').on('shown.bs.modal', function() {
                $( "#uploadSortableColumn" ).sortable();
                $( "#uploadSortableColumn" ).disableSelection();
            });

            $('#setUserPop').on('show.bs.modal', function() {//shown은 모달이 뜨고 나서 불러와서 변경되는게 보여서 show로 바꿈
                ui.get({
                    url : 'getConfList.xcn',
                    success : function ( data, total ) {
                        setInsaButtonVal(data, 'insa.auto');
                        setInsaRadioVal(data, 'insa.basepoint');
                        setInsaRadioVal(data, 'insa.dept.basepoint');
                        setInsaVal(data, 'insa.path');
                        setInsaSelVal(data, 'insa.sepa');
                        setInsaCheckVal(data, 'insa.week');
                        setInsaSelVal(data,'insa.time');
                        //setInsaColumnVal(data,'insa.cols');
                        var options = makeInsaOptions;
                        makeInsaSelectBox(options,data);
                        if ($('button[name="insa\\.auto"][value="N"]').hasClass("active")) {
                            $('#insa\\.path').prop("disabled",true);
                            $('#insa\\.sepa').prop("disabled",true);
                            $('#allWeek').prop("disabled",true);
                            $('input:checkbox[name="insa\\.week"]').prop("disabled",true);
                            $('select[name=time]').prop("disabled",true);
                            $('[name=insa\\.basepoint]').prop("disabled",true);
                            $('[name=insa\\.dept\\.basepoint]').prop("disabled",true);
                            $('select[name=insa\\.select]').prop("disabled",true);
                            $('#addSelectBox').prop("disabled",true);
                            $('#directExecuteBtn').prop("disabled",true);
                        }else{
                            $('#insa\\.path').prop("disabled",false);
                            $('#insa\\.sepa').prop("disabled",false);
                            $('#allWeek').prop("disabled",false);
                            $('input:checkbox[name="insa\\.week"]').prop("disabled",false);
                            $('select[name=time]').prop("disabled",false);
                            $('[name=insa\\.basepoint]').prop("disabled",false);
                            $('[name=insa\\.dept\\.basepoint]').prop("disabled",false);
                            $('select[name=insa\\.select]').prop("disabled",false);
                            $('#addSelectBox').prop("disabled",false);
                            $('#directExecuteBtn').prop("disabled",false);
                        }
                    },
                    error : function (status, message) {
                        ui.alertMsg(message);
                    },
                    complete : function (){
                    }
                });
            });
            $('#setUserPop').on('hide.bs.modal', function() {
                getInsaConfig()
            });



            $(document).on('mouseover', '.codeSelectedBtn', function(e){
                $('#selectedCodeTitle').show();
                $('#selectedCodeTitle').css('right', (($(document).width()-e.pageX)-724)+'px');
                $('#selectedCodeTitle').css('top', e.pageY-120+'px');

                var str = $(this).parent().find('.selectedTitle').val();
                if( str != undefined ) str = str.replaceAll('\\|', ',');
                $('#selectedCodeTitle').html(str);
            });
            $(document).on('mousemove', '.codeSelectedBtn', function(e){
                var right = (($(document).width()-e.pageX)-724)+'px';
                var top = e.pageY-120+'px';

                $('#selectedCodeTitle').css('right', right);
                $('#selectedCodeTitle').css('top', top);
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

            $('button[name="insa.auto"]').click(function(){
                if($(this).val() == 'N'){
                    $(this).addClass('active');
                    $('button[name="insa.auto"]').not(this).removeClass('active');
                    $('#insa\\.path').prop("disabled",true);
                    $('#insa\\.sepa').prop("disabled",true);
                    $('#allWeek').prop("disabled",true);
                    $('input:checkbox[name="insa\\.week"]').prop("disabled",true);
                    $('select[name=time]').prop("disabled",true);
                    $('select[name=insa\\.select]').prop("disabled",true);
                    $('[name=insa\\.basepoint]').prop("disabled",true);
                    $('[name=insa\\.dept\\.basepoint]').prop("disabled",true);
                    $('#addSelectBox').prop("disabled",true);
                    $('#directExecuteBtn').prop("disabled",true);
                }else{
                    $(this).addClass('active');
                    $('button[name="insa.auto"]').not(this).removeClass('active');
                    $('#insa\\.path').prop("disabled",false);
                    $('#insa\\.sepa').prop("disabled",false);
                    $('#allWeek').prop("disabled",false);
                    $('input:checkbox[name="insa\\.week"]').prop("disabled",false);
                    $('select[name=time]').prop("disabled",false);
                    $('[name=insa\\.basepoint]').prop("disabled",false);
                    $('[name=insa\\.dept\\.basepoint]').prop("disabled",false);
                    $('select[name=insa\\.select]').prop("disabled",false);
                    $('#addSelectBox').prop("disabled",false);
                    $('#directExecuteBtn').prop("disabled",false);
                }
            });
            $('.insa\\.week').click(function(){
                $("#allWeek").prop("checked", false);
            });
            $("#allWeek").click(function(){
                if($("#allWeek").prop("checked")) {
                    $("input[name=insa\\.week]:checkbox").each(function() {
                        $(this).prop("checked", true);
                    });
                }else{
                    $("input[name=insa\\.week]:checkbox").each(function() {
                        $(this).prop("checked", false);
                    });
                }
            });

            $('#setUserPopBtn').click(function(){
                var checkWeekFlag = '';
                var data = [];
                var columnArray = [];
                $("input[name=insa\\.week]:checkbox").each(function() {
                    $(this).is(":checked");
                    data.push($(this).is(":checked"));
                });
                if(JSON.stringify(data).indexOf('true') == -1 ){
                    checkWeekFlag = true;
                }else{
                    checkWeekFlag = false;
                }
                if ($('button[name="insa\\.auto"].active').val() == 'Y') {
                    if( $('#insa\\.path').val() == '' ){
                        ui.alertMsg('<s:message code="userInfo.msg.enter.filepath"/>');
                        $('#insa\\.path').focus();
                        return;
                    }
                    if( $('#insa\\.sepa').val() == '' ){
                        ui.alertMsg('<s:message code="userInfo.msg.enter.colseparator"/>');
                        $('#insa\\.sepa').focus();
                        return;
                    }
                    if( !$("#allWeek").prop("checked") && checkWeekFlag){
                        ui.alertMsg('<s:message code="userInfo.msg.select.day"/>');
                        return;
                    }
                    $('select.insaSelctClass option:selected').each(function(){
                        columnArray.push($(this).val());
                    });
                    var varRegexp_userId = new RegExp("userId", "ig");
                    if(JSON.stringify(columnArray).match(varRegexp_userId)==null){
                        ui.alertMsg('<s:message code="userInfo.msg.select.idcol"/>');
                        return;
                    }
                    if(JSON.stringify(columnArray).match(varRegexp_userId).length > 1){
                        ui.alertMsg('<s:message code="userInfo.msg.select.idcolone"/>')
                        return;
                    }

                    var varRegexp_userNm = new RegExp("userNm", "ig");
                    if(JSON.stringify(columnArray).match(varRegexp_userNm)==null){
                        ui.alertMsg('<s:message code="userInfo.msg.select.namecol"/>');
                        return;
                    }
                    if(JSON.stringify(columnArray).match(varRegexp_userNm).length > 1){
                        ui.alertMsg('<s:message code="userInfo.msg.select.namecolone"/>')
                        return;
                    }

                    var varRegexp_coCd = new RegExp("coNm", "ig");
                    if(JSON.stringify(columnArray).match(varRegexp_coCd) !=null && JSON.stringify(columnArray).match(varRegexp_coCd).length > 1){
                        ui.alertMsg('<s:message code="userInfo.msg.select.cocolone"/>')
                        return;
                    }
                    var varRegexp_busiCd = new RegExp("busiNm", "ig");
                    if(JSON.stringify(columnArray).match(varRegexp_busiCd) !=null && JSON.stringify(columnArray).match(varRegexp_busiCd).length > 1){
                        ui.alertMsg('<s:message code="userInfo.msg.select.busicolone"/>')
                        return;
                    }
                    var varRegexp_deptCd = new RegExp("deptNm", "ig");
                    if(JSON.stringify(columnArray).match(varRegexp_deptCd) !=null && JSON.stringify(columnArray).match(varRegexp_deptCd).length > 1){
                        ui.alertMsg('<s:message code="userInfo.msg.select.deptcolone"/>')
                        return;
                    }
                    var varRegexp_jikgubCd = new RegExp("jikgubNm", "ig");
                    if(JSON.stringify(columnArray).match(varRegexp_jikgubCd) !=null && JSON.stringify(columnArray).match(varRegexp_jikgubCd).length > 1){
                        ui.alertMsg('<s:message code="userInfo.msg.select.jikgubcolone"/>')
                        return;
                    }
                    var varRegexp_jikinCd = new RegExp("jikinNm", "ig");
                    if(JSON.stringify(columnArray).match(varRegexp_jikinCd) !=null && JSON.stringify(columnArray).match(varRegexp_jikinCd).length > 1){
                        ui.alertMsg('<s:message code="userInfo.msg.select.jikincolone"/>')
                        return;
                    }
                    var varRegexp_generalCd = new RegExp("generalNm", "ig");
                    if(JSON.stringify(columnArray).match(varRegexp_generalCd) !=null && JSON.stringify(columnArray).match(varRegexp_generalCd).length > 1){
                        ui.alertMsg('<s:message code="userInfo.msg.select.generalcolone"/>')
                        return;
                    }
                    var varRegexp_ceo = new RegExp("ceo", "ig");
                    if(JSON.stringify(columnArray).match(varRegexp_ceo) !=null && JSON.stringify(columnArray).match(varRegexp_ceo).length > 1){
                        ui.alertMsg('<s:message code="userInfo.msg.select.ceocolone"/>')
                        return;
                    }
                }
                var checkedInsaText = '';
                var checkedInsa = $('input:radio[name="insa\\.auto"]:checked').val();
                if(checkedInsa=='Y'){
                    checkedInsaText = '<s:message code="userInfo.autolink"/>';
                }else{
                    checkedInsaText = '<s:message code="userInfo.directlink"/>';
                }
                var data = valueCheckInfo();
                ui.confirmMsg('<s:message code="common.msg.confirm.apply"/>', '', '', function(rs){
                    if(rs) {
                        ui.on('setUserPopBtn');
                        ui.get({
                            url : 'setConf.xcn',
                            data : JSON.stringify(data),
                            checkedInsaText : checkedInsaText,
                            success : function ( data, total ) {
                                ui.alertMsg('<s:message code="common.msg.applied"/>');
                                $('#setUserPop').modal('hide');
                            },
                            error : function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete : function (){
                                ui.off('setUserPopBtn');
                            }
                        });
                    }
                });
            });
            $('#setInfoBtn').click(function(){
                $('#setUserPop').modal();
            });
            $('#uploadInfoBtn').click(function(){
                $('#uploadUserPop').modal();
            });
            $('#searchBtn').click(function(){
                getData ();
            });
            $('#searchStr').enter(function(e){
                getData ();
            });
            $('#userType').change(function(){
                getData();
            });

            $('.savePopBtn').click(function(){
                var mode = $('#userPop').attr('mode');
                if( $('#userId').val() == '' ){
                    ui.alertMsg('<s:message code="userInfo.msg.enter.id"/>');
                    $('#userId').focus();
                    return;
                }
                if( $('#userNm').val() == '' ){
                    ui.alertMsg('<s:message code="userInfo.msg.enter.name"/>');
                    $('#userNm').focus();
                    return;
                }

                var ip = $('#userIp').val().trimAll();
                var email = $('#userEmail').val().trimAll();
                if ( email != "" ) {
                    var tmpEmail = email.split(",");
                    for ( var i=0 ; i < tmpEmail.length ; i++ ) {
                        if ( tmpEmail[i] == "" ) continue;
                        if ( !emailCheck( tmpEmail[i] ) ) {
                            $('#userEmail').focus( );
                            return;
                        }
                    }
                }
                if ( ip != "" && ip != null ) {
                    var tmpIp = ip.split(",");
                    if ( tmpIp.length > 20 ) {
                        alert( '<s:message code="userInfo.msg.support.ip"/>');
                        $('#userIp').focus( );
                        return;
                    }
                    for ( var i=0 ; i < tmpIp.length ; i++ ) {
                        if ( tmpIp[i] == "" ) continue;
                        if ( !checkIP( tmpIp[i] ) ) {
                            alert( tmpIp[i] + '\n' + '<s:message code="deviceInfo.msg.ip.wrong"/>');
                            $('#userIp').focus( );
                            return;
                        }
                        for ( var j=0 ; j < tmpIp.length ; j++ ) {
                            if ( i != j ) {
                                if ( tmpIp[i] == tmpIp[j] ) {
                                    alert( tmpIp[i] + '\n' + '<s:message code="userInfo.msg.duplicateip"/>');
                                    $('#userIp').focus( );
                                    return;
                                }
                            }
                        }
                    }
                }
                var ceo_inUser = $('#ceo_inUser option:selected').text();
                $('#ceoHiddenNm').val(ceo_inUser);
                var coCd_inUser = $('#coCd_inUser option:selected').text();
                $('#coHiddenNm').val(coCd_inUser);
                var busiCd_inUser = $('#busiCd_inUser option:selected').text();
                $('#busiHiddenNm').val(busiCd_inUser);
                $('#deptHiddenNm').val($('#deptByCoStrSpan').text());
                var jikgubCd_inUser = $('#jikgubCd_inUser option:selected').text();
                $('#jikgubHiddenNm').val(jikgubCd_inUser);
                var generalCd_inUser = $('#generalCd_inUser option:selected').text();
                if(generalCd_inUser == '-<s:message code="common.org.choose.general"/>-'){
                    $('#generalHiddenNm').val('<s:message code="userInfo.notselect"/>');
                }else{
                    $('#generalHiddenNm').val(generalCd_inUser);
                }
                var jikinCd_inUser = $('#jikinCd_inUser option:selected').text();
                $('#jikinHiddenNm').val(jikinCd_inUser);

                $('#userAccountStrHidden').val(datas.getAccountData());

                var message = mode=='insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
                ui.confirmMsg(message, '', '', function(rs){
                    if(rs){
                        grid.on();
                        ui.post({
                            url :mode=='insert' ? 'insertUser.xcn' : 'updateUser.xcn',
                            data : $('#userPopForm').serializeAll(),
                            success : function ( data, total ) {

                                ui.alertMsg('<s:message code="common.msg.saved"/>');
                                $('#userPop').modal('hide');
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

            $('#insertBtn').click(function(){
                $('#userPop').attr('mode', 'insert');
                var options = getCoOptions();
                var busiOptions = getBusiOptions();
                var generalOptions = getGeneralOptions();
                var deptOptions = getDeptOptions();
                var jikgubOptions = getJikgubOptions();
                var jikinOptions = getJikinOptions();
                var userAccountSvcOptions = getUserAccountSvcOptions();

                var str = '<select class="form-control input-sm" id="coCd_inUser" name="coCd" style=" min-width: 197px;">';
                str += options;
                str += '</select>';
                $("#coSelect_inUser").html(str);

                var strBusi = '<select class="form-control input-sm" id="busiCd_inUser" name="busiCd" style=" min-width: 197px;">';
                strBusi += busiOptions;
                strBusi += '</select>';
                $("#busiSelect_inUser").html(strBusi);

                var strGeneral = '<select class="form-control input-sm" id="generalCd_inUser" name="generalCd" style=" min-width: 197px;">';
                strGeneral += generalOptions;
                strGeneral += '</select>';
                $("#generalSelect_inUser").html(strGeneral);

                var strJikgub = '<select class="form-control input-sm" id="jikgubCd_inUser" name="jikgubCd" style=" min-width: 197px;">';
                strJikgub += jikgubOptions;
                strJikgub += '</select>';
                $("#jikgubSelect_inUser").html(strJikgub);

                var strJikin = '<select class="form-control input-sm" id="jikinCd_inUser" name="jikinCd" style=" min-width: 197px;">';
                strJikin += jikinOptions;
                strJikin += '</select>';
                $("#jikinSelect_inUser").html(strJikin);

                var strUserAccountSvc = '<select class="form-control input-sm userAccountSvc" id="userAccountSvc_inUser" style=" min-width: 150px;">';
                strUserAccountSvc += userAccountSvcOptions;
                strUserAccountSvc += '</select>';
                $("#userAccountSvcDiv").html(strUserAccountSvc);
                datas.reset();
                datas.add();

                $('#userId').prop("disabled", false);
                $('#userNm').prop("disabled", false);
                $('#userPop').attr('mode', 'insert');
                $('#userPop').modal();

                $('#userId,#userNm,#coCd_inUser,#busiCd_inUser,#generalCd_inUser,#deptCd_inUser,#jikgubCd_inUser,#jikinCd_inUser,#userIp,#userEmail').val('');
                $('#ceo_inUser').val('N');
                coSelectDisabled();
                $('#busiCdPopInput').focus();
            });


            $('#deleteBtn').click(function(){
                var rows = grid.getSelectedKey('userId');
                var rowsNm = grid.getSelectedKey('userNm');
                if( rows == '' ) {
                    ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                    return;
                }
                grid.on();
                ui.confirmMsg( '<s:message code="userInfo.msg.confirm.delete"/>', '', '', function(rs){
                    if(rs){
                        ui.get({
                            url : 'deleteUser.xcn',
                            userId : rows.join(','),
                            userNm : rowsNm.join(','),
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
                    } else {
                        grid.off();
                    }
                });
            });
            $('#ceo_y').click(function(){
                getData();
            });
            $('#ceo_n').click(function(){
                getData();
            });
            $(document).on("change","#coCd_inUser",function(){
                coCd_for_busi = $('#coCd_inUser option:selected').val()

                var busiOptions = getBusiOptions();
                var strBusi = '<select class="form-control input-sm" id="busiCd_inUser" name="busiCd" style=" min-width: 197px;">';
                strBusi += busiOptions;
                strBusi += '</select>';
                $("#busiSelect_inUser").html(strBusi);

                var generalOptions = getGeneralOptions();
                var strGeneral = '<select class="form-control input-sm" id="generalCd_inUser" name="generalCd" style=" min-width: 197px;">';
                strGeneral += generalOptions;
                strGeneral += '</select>';
                $("#generalSelect_inUser").html(strGeneral);

                coSelectDisabled('change');
            });
            //총괄 상세조회 팝업
            $('#generalSchPop').click(function(){
                $('#schGeneralPop').modal('show');
            });
            //부서 상세조회 팝업
            $('#deptSchPop').click(function(){
                $('#schDeptPop').modal('show');
            });
            //직급 상세조회 팝업
            $('#jikgubSchPop').click(function(){
                $('#schJikgubPop').modal('show');
            });

            $('#makeInfoBtn').click(function(){
                ui.confirmMsg( '<s:message code="userInfo.msg.confirm.insa"/>', '', '', function(rs){
                    if(rs){
                        grid.on();
                        ui.get({
                            url : 'makeInfoUser',
                            comment : '<s:message code="userInfo.apply.insa"/>',
                            success : function(data, total) {
                                ui.alertMsg('<s:message code="userInfo.msg.apply.insa"/>');
                            },
                            error : function(status, message) {
                                ui.alertMsg(message);
                            },
                            complete : function() {
                                grid.off();
                            }
                        });
                    }
                });
            });

            $(document).on("change",".insaSelctClass",function(){
                if($(this).val() == 'delete' && current_select_count>11){

                    $(this).prevAll('.num_list').first().remove();
                    $(this).remove();
                    current_select_count = current_select_count-1;
                    $('.num_list').each(function(index) {
                        $(this).text(index + 1);
                    });
                }else if($(this).val() == 'delete' && current_select_count==11){
                    ui.alertMsg('<s:message code="userInfo.msg.colneed"/>');
                    $(this).val('').attr("selected", "selected");
                }
            });
            $('#addSelectBox').click(function(){
                if(current_select_count<20){
                    var options = makeInsaOptions;
                    var str = '';
                    str += '<span class="num_list mat8">'+(current_select_count+1)+'</span><select class="w90 insaSelctClass"id="COL'+current_select_count+'" name="insa.select">';
                    str += options;
                    str += '</select>';
                    $("#insaSelect").append(str);

                    current_select_count = current_select_count+1;
                }else{
                    ui.alertMsg('<s:message code="userInfo.msg.colcreate"/>');
                }
            });

            $('#directExecuteBtn').click(function(){
                ui.confirmMsg('<s:message code="common.msg.confirm.apply"/>', '', '', function(rs){
                    if(rs) {
                        ui.on('setUserPopBtn');
                        ui.get({
                            url : 'runJob.xcn',
                            jobId : "SCHEDULE_INSA_LOAD",
                            success : function(data, total) {
                                ui.alertMsg('<s:message code="common.msg.applied"/>');
                            },
                            error : function(status, message) {
                                ui.alertMsg(message);
                            },
                            complete : function() {
                                ui.off('setUserPopBtn');
                            }
                        });
                    }
                });
            });
            getInsaConfig();
            getData();
        });

        function getInsaConfig(){
            ui.get({
                url : 'getConfById.xcn',
                confId : 'insa.auto',
                success : function ( data, total ) {
                    if(api_insaYn == 'Y') $('#setInfoBtn').hide();
                    else $('#setInfoBtn').show();

                    if((nvl(data, 'N') == 'N' || data.val == 'N') && api_insaYn != 'Y') {
                        $('#insertBtn').show();
                        $('#deleteBtn').show();
                        $('#makeInfoBtn').show();
                        $('#insaComment').hide();
                    } else {
                        $('#insertBtn').hide();
                        $('#deleteBtn').hide();
                        $('#makeInfoBtn').hide();
                        $('#insaComment').show();
                    }

                },
                error : function (status, message) {
                    ui.alertMsg(message);
                },
                complete : function (){
                }
            });
        }

        function setInsaVal(data, id){
            for(var i=0 ; i < data.length ; i++){
                if(data[i].confId == id ) {
                    $('#'+idIndicator(id)).val(data[i].val);
                    $('#'+ idIndicator(id) + '\\.defaultVal').text(data[i].defaultVal);
                    return;
                }
            }
        }

        function setInsaSelVal(data, id){
            for(var i=0 ; i < data.length ; i++){
                if(data[i].confId == id ) {
                    $('#'+idIndicator(id)).val(data[i].val).attr("selected", "selected");
                }
            }
        }
        function transName(value){
            if(value == 'userId'){
                return '<s:message code="userInfo.need.id"/>';
            }
            else if(value == 'userNm'){
                return '<s:message code="userInfo.need.name"/>';
            }
            else if(value == 'coNm'){
                return '<s:message code="common.org.co"/>';
            }
            else if(value == 'generalNm'){
                return '<s:message code="common.org.general"/>';
            }
            else if(value == 'busiNm'){
                return '<s:message code="common.org.busi"/>';
            }
            else if(value == 'deptNm'){
                return '<s:message code="common.org.dept"/>';
            }
            else if(value == 'jikinNm'){
                return '<s:message code="common.org.jikin"/>';
            }
            else if(value == 'jikgubNm'){
                return '<s:message code="common.org.jikgub"/>';
            }
            else if(value == 'ceo'){
                return '<s:message code="userInfo.usertype"/>(CEO/Y,N)';
            }
            else if(value == 'userIp'){
                return 'IP';
            }
            else if(value == 'userEmail'){
                return 'E-mail';
            }
        }
        function setInsaColumnVal(data, id){
            for(var i=0 ; i < data.length ; i++){
                if(data[i].confId == id ) {
                    var arr =  data[i].val.replace(/\\/g,'');
                    var arr2 = jQuery.parseJSON(arr)
                    var str = '';
                    for(var i=0 ; i < arr2.length ; i++){
                        str += "<li class='ui-state-default' value="+arr2[i].col+"><span class='ui-icon ui-icon-arrowthick-2-n-s'></span>"+transName(arr2[i].col)+"</li>";
                    }
                    $("#insa\\.cols" ).html(str);
                }
            }
        }
        function setInsaCheckVal(data, id){
            for(var i=0 ; i < data.length ; i++){
                if(data[i].confId == id ) {
                    var obj =  data[i].val.replace(/\\/g,'');
                    var varRegexp = new RegExp("true", "ig");
                    if(obj.match(varRegexp).length == 7){
                        $('#allWeek').prop('checked',true);
                    }else{
                        $('#allWeek').prop('checked',false);
                    }
                    var obj2 = (jQuery.parseJSON(obj))
                    $.each(obj2,function(key,value){
                        $('input:checkbox[name='+idIndicator(id)+']:input[value='+key+']').prop('checked',value);
                    });
                    return;
                }
            }
            $('#allWeek').click();
        }

        function setInsaRadioVal(data, id){
            for(var i=0 ; i < data.length ; i++){
                if(data[i].confId == id ) {
                    $('input:radio[name='+idIndicator(id)+']:input[value='+data[i].val+']').prop("checked", true);
                    return;
                }
            }
            $('input:radio[name='+idIndicator('insa.auto')+']:input[value=N]').prop("checked", true);

        }

        function setInsaButtonVal(data, id) {
            for (var i = 0; i < data.length; i++) {
                if (data[i].confId == id) {
                    if(data[i].val=="N"){
                        $('button[name=' + idIndicator('insa.auto') + '][value=N]').addClass("active");
                        $('button[name=' + idIndicator('insa.auto') + '][value=Y]').removeClass("active");
                    }else{
                        $('button[name=' + idIndicator('insa.auto') + '][value=Y]').addClass("active");
                        $('button[name=' + idIndicator('insa.auto') + '][value=N]').removeClass("active");
                    }
                    return;
                }
            }
            $('button[name=' + idIndicator('insa.auto') + '][value=N]').addClass("active");
        }

        /*function setInsaButtonVal(data, id){
			for(var i=0 ; i < data.length ; i++){
				if(data[i].confId == id ) {
					return;
				}
			}
			$('input:radio[name='+idIndicator('insa.auto')+']:input[value=N]').prop("checked", true);

		}*/


        function setInsa_schedule(insa_schedule){
            var data = [];
            data.push({confId:'insa.schedule', val:insa_schedule});
            return data;
        }
        function idIndicator(id){
            return id.fReplaceWord('.', '\\.');
        }
        function coSelectDisabled(mode){
            var coCd_for_disabled = $("#coCd_inUser option:selected").val();

            if(coCd_for_disabled == '' ){
                $('#busiCd_inUser').prop('disabled',true);
                $('#generalCd_inUser').prop('disabled',true);
                $('#dept').prop('disabled',true);
                $('#busiCd_inUser').val('');
                $('#generalCd_inUser').val('');
                resetCode('deptByCo');
            }else{
                $('#busiCd_inUser').prop('disabled',false);
                $('#generalCd_inUser').prop('disabled',false);
                $('#dept').prop('disabled',false);
                if( mode == 'change' ) resetCode('deptByCo');
            }
        }
        //선택된 탭의 폼 값 입력 함수
        function getCurrentPopForm(){
            var tab = getCurrentTab();
            if(tab=='coTab') return $('#coPopForm').serializeAll();
            else if(tab=='busiTab') return $('#busiPopForm').serializeAll();
            else if(tab=='generalTab') return $('#generalPopForm').serializeAll();
            else if(tab=='deptTab') return $('#deptPopForm').serializeAll();
            else if(tab=='jikgubTab') return $('#jikgubPopForm').serializeAll();
            else if(tab=='jikinTab') return $('#jikinPopForm').serializeAll();
            else return  null;
        }

        function getData(lastRow) {
            if(searchFlag) return;
            if ( lastRow == undefined ) {
                grid.data.length = 0;
                grid.rtnNextPageFunc = getData;
                grid.loadingPage = 0;
            } else {
                grid.loadingPage++;
            }

            grid.on();

            searchFlag=true;
            var userTypeNm = $('#userType option:selected').text()
            var searchTypeNm = $('#searchType option:selected').text()
            var userType = $('#userType').val();
            if(userTypeNm=="- <s:message code="userInfo.usertype"/> -") userTypeNm = '<s:message code="userInfo.all"/>';
            var searchType = $('#searchType').val();
            if(searchTypeNm=="- <s:message code="userInfo.all"/> -") searchTypeNm = '<s:message code="userInfo.all"/>';
            var searchStr = $('#searchStr').val();
            ui.get({
                url : 'getUserList.xcn',
                userTypeNm : userTypeNm,
                searchTypeNm : searchTypeNm,
                userType : userType,
                searchType : searchType,
                searchStr : searchStr,
                logYn : "Y",
                offset : grid.data.length,
                limit : grid.pageSize,
                success : function(data, total) {
                    grid.appendData(data);
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                    searchFlag=false;
                    grid.off();
                }
            });
        }

        function getUserAccountSvcOptions(){
            var result = '';
            ui.get({
                url : 'getMessengerList.xcn',
                asyncFlag : false,
                success : function(data, total) {
                    result+='<option value="">-<s:message code="filterInfo.select.service"/>-</option>';
                    for(var i=0; i<data.length; i++) {
                        result += '<option value="'+data[i].code+'">'+data[i].codeName+'</option>';
                    }
                },
                error : function(status, message) {
                    ui.alertMsg('error:' + status);
                },
                complete : function() {
                    searchFlag=false;
                }
            });

            return result;
        }

        function getCoOptions(){
            var result = '';
            ui.get({
                url : 'getCoList.xcn',
                asyncFlag : false,
                searchStr :'',
                success : function(data, total) {
                    result+='<option value="">-<s:message code="common.org.choose.co"/>-</option>';
                    for(var i=0 ; i<data.length; i++){
                        result+='<option value="' + data[i].coCd + '">' +  data[i].coNm + '</option>';
                    }
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
            return result;
        }

        function getBusiOptions(){
            var result = '';
            ui.get({
                url : 'getBusiListByCo.xcn',
                asyncFlag : false,
                coCd :coCd_for_busi,
                success : function(data, total) {
                    result+='<option value="">-<s:message code="common.org.choose.busi"/>-</option>';
                    for(var i=0 ; i<data.length; i++){
                        result+='<option value="' + data[i].busiCd + '">' +  data[i].busiNm + '</option>';
                    }
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
            return result;
        }
        function getGeneralOptions(){
            var result = '';
            ui.get({
                url : 'getGeneralListByCo.xcn',
                asyncFlag : false,
                searchStr :'',
                coCd:coCd_for_busi,
                success : function(data, total) {
                    result+='<option value="">-<s:message code="common.org.choose.general"/>-</option>';
                    for(var i=0 ; i<data.length; i++){
                        result+='<option value="' + data[i].generalCd + '">' +  data[i].generalNm + '</option>';
                    }
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
            return result;
        }
        function getDeptOptions(){
            var result = '';
            ui.get({
                url : 'getDeptListByCo.xcn',
                asyncFlag : false,
                searchStr :'',
                coCd:coCd_for_busi,
                success : function(data, total) {
                    result+='<option value="">-<s:message code="common.org.choose.dept"/>-</option>';
                    for(var i=0 ; i<data.length; i++){
                        result+='<option value="' + data[i].deptCd + '">' +  data[i].deptNm + '</option>';
                    }
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
            return result;
        }
        function getJikgubOptions(){
            var result = '';
            ui.get({
                url : 'getJikgubList.xcn',
                asyncFlag : false,
                searchStr :'',
                success : function(data, total) {
                    result+='<option value="">-<s:message code="common.org.choose.jikgub"/>-</option>';
                    for(var i=0 ; i<data.length; i++){
                        result+='<option value="' + data[i].jikgubCd + '">' +  data[i].jikgubNm + '</option>';
                    }
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
            return result;
        }
        function getJikinOptions(){
            var result = '';
            ui.get({
                url : 'getJikinList.xcn',
                asyncFlag : false,
                searchStr :'',
                success : function(data, total) {
                    result+='<option value="">-<s:message code="common.org.choose.jikin"/>-</option>';
                    for(var i=0 ; i<data.length; i++){
                        result+='<option value="' + data[i].jikinCd + '">' +  data[i].jikinNm + '</option>';
                    }
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
            return result;
        }
        function allSelectOptions(){
            var options = getCoOptions();
            var busiOptions = getBusiOptions();
            var generalOptions = getGeneralOptions();
            var deptOptions = getDeptOptions();
            var jikgubOptions = getJikgubOptions();
            var jikinOptions = getJikinOptions();
            var userAccountSvcOptions = getUserAccountSvcOptions();
            var str = '<select class="form-control input-sm" id="coCd_inUser" name="coCd" style=" min-width: 197px;">';
            str += options;
            str += '</select>';
            $("#coSelect_inUser").html(str);

            var strBusi = '<select class="form-control input-sm" id="busiCd_inUser" name="busiCd" style=" min-width: 197px;">';
            strBusi += busiOptions;
            strBusi += '</select>';
            $("#busiSelect_inUser").html(strBusi);

            var strGeneral = '<select class="form-control input-sm" id="generalCd_inUser" name="generalCd" style=" min-width: 197px;">';
            strGeneral += generalOptions;
            strGeneral += '</select>';
            $("#generalSelect_inUser").html(strGeneral);

            var strJikgub = '<select class="form-control input-sm" id="jikgubCd_inUser" name="jikgubCd" style=" min-width: 197px;">';
            strJikgub += jikgubOptions;
            strJikgub += '</select>';
            $("#jikgubSelect_inUser").html(strJikgub);

            var strJikin = '<select class="form-control input-sm" id="jikinCd_inUser" name="jikinCd" style=" min-width: 197px;">';
            strJikin += jikinOptions;
            strJikin += '</select>';
            $("#jikinSelect_inUser").html(strJikin);

            var strUserAccountSvc = '<select class="form-control input-sm userAccountSvc" id="userAccountSvc_inUser" style=" min-width: 150px;">';
            strUserAccountSvc += userAccountSvcOptions;
            strUserAccountSvc += '</select>';
            $("#userAccountSvcDiv").html(strUserAccountSvc);
        }
        function valueCheckInfo(){
            var data=[];
            var columnArray = [];
            if ($('button[name="insa\\.auto"][value="N"]').hasClass("active")) {
                data.push({ confId: 'insa.auto', val: 'N' });
                return data;
            }else {
                data.push({confId:'insa.auto', val:'Y'});
                data.push({confId:'insa.basepoint', val:$('input:radio[name="insa\\.basepoint"]:checked').val()});
                data.push({confId:'insa.dept.basepoint', val:$('input:radio[name="insa\\.dept\\.basepoint"]:checked').val()});
                data.push({confId:'insa.path', val:$('#'+idIndicator('insa.path')).val()});
                //data.push({confId:'insa.sepa', val:$('#'+idIndicator('insa.sepa')).val()});
                data.push({confId:'insa.sepa', val:$('#'+idIndicator('insa.sepa option:selected')).val()});

                var weekObj = {};
                var week = new Array( 'sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat' );
                $("input[name=insa\\.week]:checkbox").each(function(i, e) {
                    weekObj[week[i]] = e.checked;
                });

                data.push({confId:'insa.week', val:JSON.stringify(JSON.stringify(weekObj))});
                data.push({confId:'insa.time', val:$('#'+idIndicator('insa.time option:selected')).val()});
                $('select.insaSelctClass option:selected').each(function(){
                    columnArray.push($(this).val());
                });
                data.push({confId:'insa.cols', val:JSON.stringify(JSON.stringify(columnArray))});
                /* $('#insa\\.cols li').each(function(i){
					columnArray.push({col:$(this).attr('value')});
				});
				data.push({confId:'insa.cols', val:JSON.stringify(JSON.stringify(columnArray))}); */
                data.push({confId:'insa.schedule', val:getInsaSchedule()});
                return data;
            }
        }
        //인사 연동 설정 cron exp
        function getInsaSchedule(){
            var week=[];
            $("input[name=insa\\.week]:checked").each(function() {
                week.push($(this).val().toUpperCase());
            });

            var schTime= $("#insa\\.time option:selected").val();
            var schedule=[];
            schedule.push('0'); //sec
            schedule.push('0'); //minute
            schedule.push(schTime); //hour
            schedule.push('?'); //day
            schedule.push('*'); //month
            schedule.push(week.join(',')); //week
            return schedule.join(' ');
        }
        function makeInsaSelectBox(options,data){

            var arr = ''
            var arr2 = ''
            for(var i=0 ; i < data.length ; i++){
                if(data[i].confId == 'insa.cols' ) {
                    arr = data[i].val.replace(/\\/g,'');
                    if(arr!='')arr2 = jQuery.parseJSON(arr);
                    //arr =  data[i].val.replace(/\\/g,'');

                }
            }
            var str = '';
            //console.log(arr)
            if(arr==''){
                for(var i=0 ; i<current_select_count; i++){
                    str += '<span class="num_list mat8">'+(i+1)+'</span>';
                    str += '<select class="w90 insaSelctClass" id="COL'+i+'" name="insa.select">';
                    str += options;
                    str += '</select>';
                }
            }else{
                for(var i=0 ; i<arr2.length; i++){
                    str += '<span class="num_list mat8">'+(i+1)+'</span>';
                    str += '<select class="w90 insaSelctClass" id="COL'+i+'" name="insa.select">';
                    str += options;
                    str += '</select>';
                }
            }
            $("#insaSelect").html(str);
            if(arr==null||arr==''){
                for(var i=0 ; i<current_select_count; i++){
                    $("#COL"+i+" option:eq("+i+")").attr("selected", true);
                }
            }else{
                //alert(arr2.length)
                current_select_count = arr2.length;
                for(var i=0 ; i<arr2.length; i++){
                    $("#COL"+i+"").val(arr2[i]).attr("selected", true);
                    //$("#COL"+i+" option:eq("+i+")").attr("selected", true);
                }
            }
        }
        function makeInsaOptions(){
            var result = '';
            result+='<option value="userId"><s:message code="common.msg.id"/></option>';
            result+='<option value="userNm"><s:message code="common.msg.name"/></option>';
            result+='<option value="userEmail">E-mail(<s:message code="userInfo.duplicate.possible"/>)</option>';
            result+='<option value="userIp">IP(<s:message code="userInfo.duplicate.possible"/>)</option>';
            result+='<option value="coCd"><s:message code="common.org.cocd"/></option>';
            result+='<option value="coNm"><s:message code="common.org.conm"/></option>';
            result+='<option value="generalNm"><s:message code="common.org.generalnm"/></option>';
            result+='<option value="busiNm"><s:message code="common.org.businm"/></option>';
            result+='<option value="deptNm"><s:message code="common.org.deptnm"/></option>';
            result+='<option value="jikgubNm"><s:message code="common.org.jikgubnm"/></option>';
            result+='<option value="jikinNm"><s:message code="common.org.jikinnm"/></option>';
            result+='<option value="">skip this column(<s:message code="userInfo.duplicate.possible"/>)</option>';
            result+='<option value="delete" style="background-color:black;color:white;"><s:message code="common.msg.delete"/></option>';
            return result;
        }

        function openCodeWindow(id, coCd, oldCode, oldConm){
            $('#oldCode').val(oldCode);
            $('#oldConm').val(oldConm);

            var url    = '<c:url value="/commons/selectCodeSingle.do?codeType='+id+'&coCd='+coCd+'"/>';
            fnOpenWindow('', 'selectCodeWinPopup', 520, 600);

            $('#codeParam').attr('target','selectCodeWinPopup');
            $('#codeParam').attr('action', url);
            $('#codeParam').attr('method','post');
            $('#codeParam').submit();
        }
        function getSelectedCodeData( codeType, data ) {
            var str = '';
            var val = '';
            for(var i=0; i<data.length; i++){
                str += data[i].codeName;
                val += data[i].code;

                if( i != data.length-1){
                    if( codeType == 'deptByCo'){
                        str +=', ';
                        val +=',';
                    }else{
                        str +=', ';
                        val +='|';
                    }
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
                if(codeType == 'deptByCo' ) $('#deptByCoStrSpan').html( $('#'+codeType+'Str').val() );
            }else{
                $('#'+codeType+'SelectedArea').find('.btn').text(0);
                $('#'+codeType+'SelectedArea').hide();
            }
        }
        function resetCode(codeType){
            if( codeType == 'deptByCo' )  $('#deptByCoStrSpan').html('');
            $('#'+codeType+'Val').val('');
            $('#'+codeType+'Str').val('');
            $('#'+codeType+'SelectedArea').hide();
        }
        function userModify(grid){
            ui.on('setUserPopBtn');
            ui.get({
                url : 'getUserAccountInfo.xcn',
                userId : grid.getValue(grid.Row, 'userId'),
                success : function ( data, total ) {
                    allSelectOptions();
                    $('#userId').prop("disabled", true);
                    $('#userPop').attr('mode', 'modify');
                    $('#userPop').modal('show');
                    $('#userId').val(grid.getValue(grid.Row, 'userId'));
                    $('#userNm').val(grid.getValue(grid.Row, 'userNm'));
                    $('#coCd_inUser').val(grid.getValue(grid.Row, 'coCd'));
                    $('#busiCd_inUser').val(grid.getValue(grid.Row, 'busiCd'));
                    $('#generalCd_inUser').val(grid.getValue(grid.Row, 'generalCd'));
                    $('#deptByCoVal').val(grid.getValue(grid.Row, 'deptCd'));
                    $('#deptByCoStr').val(grid.getValue(grid.Row, 'deptNm'));
                    $('#deptByCoStrSpan').html(grid.getValue(grid.Row, 'deptNm'));

                    if( $('#deptByCoStr').val() != '' ){
                        $('#deptByCoSelectedArea').find('.btn').text(1);
                        $('#deptByCoSelectedArea').show();
                        $('#deptByCoStrSpan').html( $('#deptByCoStr').val() );
                    }else{
                        $('#deptByCoSelectedArea').find('.btn').text(0);
                        $('#deptByCoSelectedArea').hide();
                    }

                    $('#jikgubCd_inUser').val(grid.getValue(grid.Row, 'jikgubCd'));
                    $('#jikinCd_inUser').val(grid.getValue(grid.Row, 'jikinCd'));
                    $('#userIp').val(grid.getValue(grid.Row, 'userIp'));
                    $('#userEmail').val(grid.getValue(grid.Row, 'userEmail'));
                    $('#ceo_inUser').val(grid.getValue(grid.Row, 'ceo'));
                    coSelectDisabled();


                    var modifyCannotFlag = false;
                    if( $('#insertBtn').css('display') == 'none' ) modifyCannotFlag = true;
                    datas.setAccountData(data, modifyCannotFlag);
                    userInfoPopStat(modifyCannotFlag);
                },
                error : function (status, message) {
                    ui.alertMsg(message);
                },
                complete : function (){
                    ui.off('setUserPopBtn');
                }
            });
        }
        function userInfoPopStat(flag){
            $('#userId, #userNm, #coCd_inUser, #busiCd_inUser, #generalCd_inUser, #deptByCoVal, #deptByCoStr').prop("disabled", flag);
            $('#dept, #jikgubCd_inUser, #jikinCd_inUser, #userIp, #userEmail, #ceo_inUser').prop("disabled", flag);
            $('.userAccountSvc, .userAccountText .userBtnData').prop("diabled", flag);

            if(flag){
                $('#dept').addClass('disabledClass');
                $('.userPopFooter').hide();
            }
            else{
                $('#dept').removeClass('disabledClass');
                $('.userPopFooter').show();
            }

        }
	</script>
</head>
<div class="modal fade" id="schGeneralPop" tabindex="-1" role="dialog" aria-labelledby="schGeneralModal" style="z-index: 10000;">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<form method="post" id="shcGeneralPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="userInfo.search.general"/></h3>
				</div>
				<div class="modal-body">
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</form>
		</div>
	</div>
</div>
<div class="modal fade" id="schDeptPop" tabindex="-1" role="dialog" aria-labelledby="schDeptModal" style="z-index: 10000;">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<form method="post" id="shcDeptPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="userInfo.search.dept"/></h3>
				</div>
				<div class="modal-body">
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</form>
		</div>
	</div>
</div>
<div class="modal fade" id="schJikgubPop" tabindex="-1" role="dialog" aria-labelledby="schJikgubModal" style="z-index: 10000;">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<form method="post" id="shcJikgubPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="userInfo.search.jikgub"/></h3>
				</div>
				<div class="modal-body">
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</form>
		</div>
	</div>
</div>

<div class="modal" id="setUserPop" tabindex="-1" role="dialog" aria-labelledby="setUserPop">
	<div class="modal-content">
		<div class="modalHead">
			<h2><s:message code="userInfo.set.insa"/></h2>
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
			</button>
		</div>
		<div class="modalCon">
			<div class="modalTop">
				<h3><s:message code="userInfo.method.insa"/></h3>
				<div class="optiotab w100 mat8">
					<button class="tablinks w50" value="N" name="insa.auto"><s:message code="userInfo.directlink"/></button>
					<button class="tablinks w50"  value="Y" name="insa.auto"><s:message code="userInfo.autolink"/></button>
				</div>
			</div>
			<div class="modalbody">
				<form method="post" id="setUserPopForm">
					<h4 class="blue02" style="position: relative; font-size:14px; font-weight: 600; margin-bottom:8px;"><s:message code="userInfo.set.autolink"/></h4>
					<div class="row bortop_dd pt8">
						<div class="col-50">
							<div class="radio w100 mat8">
								<label for="fname"><s:message code="userInfo.basepoint"/></label>
								<div class="radio w100 mat4">
									<input type="radio"  value="F" id="insa.basepoint01" name="insa.basepoint" checked="checked">
									<label for="insa.basepoint01"><span><s:message code="userInfo.basepoint.file"/></span></label>
								</div>
								<div class="radio w100 mat4">
									<input type="radio" value="I" name="insa.basepoint" id="insa.basepoint02">
									<label for="insa.basepoint02"><span><s:message code="userInfo.basepoint.ip"/></span></label>
								</div>
							</div>
							<div class="mat16">
								<label for="fname"><s:message code="userInfo.filepath"/></label>
								<input class="w100 mat8" type="text" id="insa.path" placeholder="<s:message code="common.message.input.filepath"/>">
							</div>
							<div class="mat16">
								<label for="fname"><s:message code="userInfo.colseparator"/></label>
								<select class="w100" id="insa.sepa">
									<option value="|" selected> | </option>
									<option value=","> , </option>
								</select>
							</div>
							<div class="mat16">
								<div class="col-35">
									<label for="fname"><s:message code="userInfo.set.day"/></label>
								</div>
								<div class="col-65 txt_right">
									<div class="checkbox">
										<input type="checkbox" checked="checked"  value="A" id="allWeek">
										<span><s:message code="userInfo.all"/></span>
									</div>
								</div>
								<div class="clear">
									<div class="checkbox" style="margin-left: 4px;"><label for="sun"><input type="checkbox" name="insa.week" value="sun" id="sun"><span><s:message code="common.sun"/></span></label></div>
									<div class="checkbox" style="margin-right: 10px;"><label for="mon"><input type="checkbox" name="insa.week"value="mon" id="mon"><span><s:message code="common.mon"/></span></label></div>
									<div class="checkbox" style="margin-right: 10px;"><label for="tue"><input type="checkbox" name="insa.week" value="tue" id="tue"><span><s:message code="common.tue"/></span></label></div>
									<div class="checkbox" style="margin-right: 10px;"><label for="wed"><input type="checkbox" name="insa.week" value="wed" id="wed"><span><s:message code="common.wed"/></span></label></div>
									<div class="checkbox" style="margin-right: 10px;"><label for="thu"><input type="checkbox" name="insa.week" value="thu" id="thu"><span><s:message code="common.thu"/></span></label></div>
									<div class="checkbox" style="margin-right: 10px;"><label for="fri"><input type="checkbox" name="insa.week" value="fri" id="fri"><span><s:message code="common.fri"/></span></label></div>
									<div class="checkbox" style="margin-right: 10px;"><label for="sat"><input type="checkbox" name="insa.week" value="sat" id="sat"><span><s:message code="common.sat"/></span></label></div>
								</div>
							</div>
							<div class="mat16">
								<label for="fname"><s:message code="userInfo.set.time"/></label>
								<select class="w100" id="insa.time" name="time">
									<option value="*"><s:message code="userInfo.clock.time"/></option>
									<option value="1"><s:message code="common.time.01"/></option>
									<option value="2"><s:message code="common.time.02"/></option>
									<option value="3"><s:message code="common.time.03"/></option>
									<option value="4"><s:message code="common.time.04"/></option>
									<option value="5"><s:message code="common.time.05"/></option>
									<option value="6"><s:message code="common.time.06"/></option>
									<option value="7"><s:message code="common.time.07"/></option>
									<option value="8"><s:message code="common.time.08"/></option>
									<option value="9"><s:message code="common.time.09"/></option>
									<option value="10"><s:message code="common.time.10"/></option>
									<option value="11"><s:message code="common.time.11"/></option>
									<option value="12"><s:message code="common.time.12"/></option>
									<option value="13"><s:message code="common.time.13"/></option>
									<option value="14"><s:message code="common.time.14"/></option>
									<option value="15"><s:message code="common.time.15"/></option>
									<option value="16"><s:message code="common.time.16"/></option>
									<option value="17"><s:message code="common.time.17"/></option>
									<option value="18"><s:message code="common.time.18"/></option>
									<option value="19"><s:message code="common.time.19"/></option>
									<option value="20"><s:message code="common.time.20"/></option>
									<option value="21"><s:message code="common.time.21"/></option>
									<option value="22"><s:message code="common.time.22"/></option>
									<option value="23"><s:message code="common.time.23"/></option>
									<option value="0"><s:message code="common.time.24"/></option>
								</select>
							</div>
							<div class="mat16">
								<div class="col-35">
									<label for="fname"><s:message code="userInfo.direct.execute"/></label>
								</div>
								<div class="col-65 txt_right">
									<button type="button"  class="form_btn01_02" id="directExecuteBtn" accesskey="D"><s:message code="userInfo.direct.execute"/></button>
								</div>
							</div>
						</div>
						<div class="col-50 mal16">
							<label for="fname"><s:message code="userInfo.dept.basepoint"/></label>
							<div class="radio mat4 w100">
								<div class="radio w100 mat4">
									<input type="radio" value="F" name="insa.dept.basepoint" checked="checked" id="insa.dept.basepoint01">
									<label for="insa.dept.basepoint01"><span ><s:message code="userInfo.basepoint.file"/></span></label>
								</div>
								<div class="radio w100 mat4">
									<input type="radio" value="I" name="insa.dept.basepoint" id="insa.dept.basepoint02">
									<label for="insa.dept.basepoint02"><span ><s:message code="userInfo.dept.basepoint.ip"/></span></label>
								</div>
							</div>
							<div class="mat16">
								<div class="col-35">
									<label for="fname"><s:message code="userInfo.no.column"/></label>
								</div>
								<div class="col-65 txt_right">
									<button id="addSelectBox" type="button" accesskey="A" class="btn01 btnform"> <img src="../img/subBtn_plus.png" alt="추가"><s:message code="common.msg.add"/></button>
								</div>
								<p class="clear w100">
								<div id="insaSelect"  class="w90">
								</div>
								</p>
							</div>
						</div>
					</div>
				</form>
			</div>
			<div class="modalfooter">
				<button class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
				<button class="pop_btn02" id="setUserPopBtn" accesskey="S"><s:message code="common.msg.apply"/></button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="uploadUserPop" tabindex="-1" role="dialog" aria-labelledby="uploadUserPop">
	<div class="modal-dialog" role="document" style="width: 800px;">
		<div class="modal-content">
			<form method="post" id="uploadUserPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title">IMPORT</h3>
				</div>
				<div class="modal-body" style="margin-right: 17px;">
					<ul>
						<li style="margin-top: 10px;"><p style="font-weight: bold;">IMPORT</p>
							<ul style="margin-left: -35px;">
								<li style="display: inline-block;font-weight: 700;">- <s:message code="userInfo.filepath"/>
									<div class="fileinput fileinput-new" data-provides="fileinput">
										<span class="btn btn-default btn-file"><input type="file" id="insa.upload.path"/></span>
										<span class="fileinput-filename"></span><span class="fileinput-new"></span>
									</div>
								</li>
								<li style="display: inline-block;padding-left: 33px;font-weight: 700;">- <s:message code="userInfo.colseparator"/>
									<div class="form-inline" style="border-bottom: 0px;">
										<input type="text" class="form-control" id="insa.upload.sepa" style="width: 35px;">
									</div>
								</li>
								<li style="margin-top: 0px; display: block;font-weight: 700;">- <s:message code="userInfo.no.column"/>
									<ol id="insa.upload.cols" class="uploadSortableColumn" style="margin-top: 10px;padding-left: 18px;">
										<li class="ui-state-default" value="userId"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><s:message code="userInfo.need.id"/></li>
										<li class="ui-state-default" value="userNm"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><s:message code="userInfo.need.name"/></li>
										<li class="ui-state-default" value="userEmail"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>E-mail</li>
										<li class="ui-state-default" value="userIp"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>IP</li>
										<li class="ui-state-default" value="coCd"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><s:message code="common.org.co"/></li>
										<li class="ui-state-default" value="generalCd"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><s:message code="common.org.general"/></li>
										<li class="ui-state-default" value="busiCd"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><s:message code="common.org.busi"/></li>
										<li class="ui-state-default" value="deptCd"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><s:message code="common.org.dept"/></li>
										<li class="ui-state-default" value="jikgubCd"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><s:message code="common.org.jikgub"/></li>
										<li class="ui-state-default" value="jikinCd"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><s:message code="common.org.jikin"/></li>
										<li class="ui-state-default" value="ceo"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><s:message code="userInfo.usertype"/>(CEO/Y,N)</li>
									</ol>
								</li>
							</ul>
						</li>
					</ul>
				</div>
			</form>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
				<button type="button" class="btn btn-primary" id="uploadUserPopBtn" accesskey="U"><s:message code="common.msg.save"/></button>
			</div>
		</div>
	</div>
</div>
<div class="modal"  id="userPop" tabindex="-1" role="dialog" aria-labelledby="userPop">
	<div class="modal-content">
		<form method="post" id="userPopForm">
			<div class="modalHead">
				<h2><s:message code="userInfo.userPop.title"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="userInfo.userPop.title"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="ceo_inUser" class="fname"><s:message code="userInfo.usertype"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<select id="ceo_inUser" class="w100" name="ceo">
								<option value="N"><s:message code="userInfo.normal"/></option>
								<option value="Y">CEO</option>
							</select>
							<input type="hidden" id="ceoHiddenNm" name="ceoNm">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="userId" class="fname"><s:message code="common.msg.id"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="userId" id="userId" placeholder="<s:message code="common.msg.id"/>" maxlength="50">
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="userNm" class="fname"><s:message code="common.msg.name"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="userNm" id="userNm" placeholder="<s:message code="common.msg.name"/>" maxlength="255">
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="coSelect_inUser" class="fname"><s:message code="common.org.co"/></label>
						</div>
						<div class="col-65">
							<div class="form-group" id="coSelect_inUser"></div>
							<input type="hidden" id="coHiddenNm" name="coNm">
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="busiSelect_inUser" class="fname"><s:message code="common.org.busi"/></label>
						</div>
						<div class="col-65">
							<div class="form-group" id="busiSelect_inUser"></div>
							<input type="hidden" id="busiHiddenNm" name="busiNm">
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="deptSelect_inUser" class="fname"><s:message code="common.org.dept"/></label>
						</div>
						<div class="col-65">
						<button class="btn01" type="button"  id="dept"><img src="../img/subBtn_plus.png" alt="추가"><s:message code="common.org.choose.dept"/></button>
						<span id="deptByCoSelectedArea" class="codeSelectedBtn">
									<button type="button" class="btn">0</button>
							</span>
						<span id="deptByCoStrSpan"></span>
							<input type="hidden" id="deptByCoStr" class="selectedTitle" name="deptNm">
							<input type="hidden" id="deptByCoVal" name="deptCd">
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="jikgubSelect_inUser" class="fname"><s:message code="common.org.jikgub"/></label>
						</div>
						<div class="col-65">
							<div id="jikgubSelect_inUser"></div>
							<input type="hidden" id="jikgubHiddenNm" name="jikgubNm">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="generalSelect_inUser" class="fname"><s:message code="common.org.general"/></label>
						</div>
						<div class="col-65">
							<div id="generalSelect_inUser"></div>
							<input type="hidden" id="generalHiddenNm" name="generalNm">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="jikinSelect_inUser" class="fname"><s:message code="common.org.jikin"/></label>
						</div>
						<div class="col-65">
							<div id="jikinSelect_inUser"></div>
							<input type="hidden" id="jikinHiddenNm" name="jikinHiddenNm">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="userIp" class="fname">IP</label>
						</div>
						<div class="col-65">
							<div id="jikinSelect_inUser"></div>
							<input type="text" class="w100" name="userIp" id="userIp" placeholder="<s:message code="userInfo.msg.ip"/>">
							<%if( isIPv6){ %>
							<p>
								<span style='color:grey;'>[ex: IPv4 - 192.168.0.12 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IPv6 - 2002:9b3d:1a32:4:208:74ff:fe39:6c43]</span>
							</p>
							<%} %>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="userEmail" class="fname">E-Mail</label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="userEmail" id="userEmail" placeholder="<s:message code="userInfo.msg.email"/>">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="userAccountSelectDiv" class="fname"><s:message code="common.messenger.account"/></label>
						</div>
						<div class="col-65">
							<div class="form-group" id="userAccountSelectDiv"></div>
							<input type="hidden" id="userAccountStrHidden" name="userAccountStr">
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

<div class="container">
	<div class="searchArea">
		<div class="searchSub">
			<div>
				<select id="userType" style="float: left;">
					<option value="">- <s:message code="userInfo.usertype"/> -</option>
					<option value="N"><s:message code="userInfo.normal"/></option>
					<option value="Y">CEO</option>
				</select>
			</div>
			<div>
				<select id="searchType" style="float: left;">
					<option value="all">- <s:message code="userInfo.all"/> -</option>
					<option value="userId"><s:message code="common.msg.id"/></option>
					<option value="userNm"><s:message code="common.msg.name"/></option>
					<option value="userEmail">E-Mail</option>
					<option value="userIp">IP</option>
					<option value="userDept"><s:message code="common.org.dept"/></option>
				</select>
				</select>
			</div>
			<div>
				<input type="text"  placeholder="<s:message code="ipRange.msg.enter.busicomment"/>" id="searchStr">
				<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.msg.search"/></button>
			</div>
			<div class="btnform">
				<button type="button" class="btn01" accesskey="I" id="insertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
				<button type="button" class="btn02" accesskey="D" id="deleteBtn"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
				<button type="button" class="btn03" accesskey="U" id="makeInfoBtn"><span class="glyphicon glyphicon-import"></span>&nbsp;<s:message code="userInfo.info.insa"/></button>
				<button type="button" class="btn05" <%=Common.isEquals(api_insaYn, "Y") ? "hide" : "" %>" accesskey="S"  id="setInfoBtn"><span class="glyphicon glyphicon-cog"></span>&nbsp;<s:message code="userInfo.set.insa"/></button>
				<div id="insaComment"><s:message code="userInfo.msg.insa.auto"/></div>
			</div>
		</div>
	</div>

	<div class="content xcn_full">
		<div class="contentSub">
			<div id="userListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>

<div id="dataHtml" style="display:none;">
	<div id="dataContentId" class="dataContent" style="margin-bottom:10px;">
		<div class="userAccountSvcDiv" id="userAccountSvcDiv"></div>
		<input type="text" class="userAccountText" id="userAccountText_inUser" placeholder="" style="width: 170px;">
		<button type="button" id="btnDataDel" class="btn userBtnData" style="height:25px;vertical-align: middle;padding:0px 5px 0px 5px;" onclick="datas.del;">
			<span class="glyphicon glyphicon-minus"></span>
		</button>
		<button type="button" id="btnDataAdd" class="btn userBtnData" style="height:25px;vertical-align: middle;padding:0px 5px 0px 5px;" onclick="datas.add;">
			<span class="glyphicon glyphicon-plus"></span>
		</button>
	</div>
</div>

<script type="text/javascript">

    var grid = new Xgrid('userListGrid', contextRoot);
    grid.onCheckBox();
    grid.autoNumber();

    grid.colAdd('userId', '<s:message code="common.msg.id"/>', 120, 'center', false, 'link');
    grid.colAdd('userNm', '<s:message code="common.msg.name"/>', 200, 'left', false, 'nomal');
    grid.colAdd('userEmail', 'E-Mail', 250, 'left', false, 'nomal');
    grid.colAdd('userIp', 'IP', 250, 'left', false, 'nomal');
    grid.colAdd('coNm', '<s:message code="common.org.co"/>', 120, 'left', false, 'nomal');
    grid.colAdd('generalNm', '<s:message code="common.org.general"/>', 120, 'left', false, 'nomal');
    grid.colAdd('busiNm', '<s:message code="common.org.busi"/>', 120, 'left', false, 'nomal');
    grid.colAdd('deptNm', '<s:message code="common.org.dept"/>', 120, 'left', false, 'nomal');
    grid.colAdd('jikgubNm', '<s:message code="common.org.jikgub"/>', 80, 'left', false, 'nomal');
    grid.colAdd('jikinNm', '<s:message code="common.org.jikin"/>', 80, 'left', false, 'nomal');
    grid.colAdd('ceo', '<s:message code="userInfo.usertype"/>', 80, 'center', false, 'normal', function(row, cell, value, columnDef, dataContext){
        var ceo = grid.getValue(row, 'ceo');
        if(ceo=='Y')return 'CEO';
        else return '';
    });
    grid.onClick = function() {
        if (grid.Col == grid.ColIndex('userId')) {
            if( $('#insertBtn').css('display') == 'none' ) return;
            allSelectOptions();
            $('#userId').prop("disabled", true);
            $('#userPop').attr('mode', 'modify');
            $('#userPop').modal('show');
            $('#userId').val(grid.getValue(grid.Row, 'userId'));
            $('#userNm').val(grid.getValue(grid.Row, 'userNm'));
            $('#coCd_inUser').val(grid.getValue(grid.Row, 'coCd'));
            $('#busiCd_inUser').val(grid.getValue(grid.Row, 'busiCd'));
            $('#generalCd_inUser').val(grid.getValue(grid.Row, 'generalCd'));
            $('#deptByCoVal').val(grid.getValue(grid.Row, 'deptCd'));
            $('#deptByCoStr').val(grid.getValue(grid.Row, 'deptNm'));
            $('#deptByCoStrSpan').html(grid.getValue(grid.Row, 'deptNm'));

            if( $('#deptByCoStr').val() != '' ){
                $('#deptByCoSelectedArea').find('.btn').text(1);
                $('#deptByCoSelectedArea').show();
                $('#deptByCoStrSpan').html( $('#deptByCoStr').val() );
            }else{
                $('#deptByCoSelectedArea').find('.btn').text(0);
                $('#deptByCoSelectedArea').hide();
            }

            $('#jikgubCd_inUser').val(grid.getValue(grid.Row, 'jikgubCd'));
            $('#jikinCd_inUser').val(grid.getValue(grid.Row, 'jikinCd'));
            $('#userIp').val(grid.getValue(grid.Row, 'userIp'));
            $('#userEmail').val(grid.getValue(grid.Row, 'userEmail'));
            $('#ceo_inUser').val(grid.getValue(grid.Row, 'ceo'));
            coSelectDisabled();

            if (grid.Col == grid.ColIndex('userId')) {
                userModify(grid);
            }
        }
    };
    grid.loadExportMenu('<s:message code="userInfo.navi.title2"/>');
    grid.loadPageSize();
    grid.loadHeader(true);
    grid.initData('<s:message code="common.msg.search.click"/>');
    grid.changePageSize = function(cnt){
        getData();
    };
</script>

<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"/>
	<input type="hidden" name="oldConm" id="oldConm"/>
</form>
