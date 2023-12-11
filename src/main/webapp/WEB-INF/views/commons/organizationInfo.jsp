<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title></title>
	<style type="text/css">
		.tab-content{
			display: none;
			background: #ededed;
			padding: 15px;
		}

		.tab-content.active{
			display: inherit;
		}
	</style>
	<script type="text/javascript">
        var searchFlag=false;
        var coCdPDept='';
        $(document).ready(function(){



            $('#export_menu_co').css('display', '');
            $('#export_menu_busi').hide();
            $('#export_menu_general').hide();
            $('#export_menu_dept').hide();
            $('#export_menu_jikgub').hide();
            $('#export_menu_jikin').hide();

            $('#searchBtn').click(function(){
                getData ();
            });
            $('#searchStrInput').enter(function(e){
                getData ();
            });

            $('.print_link2').click(function() {
                var grid = getCurrentGrid();
                var title = $('.nav-tabs .active a').text();
                grid.print(title);
            });
            $('.excel_link2').click(function() {
                var grid = getCurrentGrid();
                var title = $('.nav-tabs .active a').text();
                excelDownLoad(grid, title);
            });
            $('.csv_link2').click(function() {
                var grid = getCurrentGrid();
                var title = $('.nav-tabs .active a').text();
                csvDownLoad(grid, title);
            });
            //$('#coNmPopSelect_inDept').change(function(){
            $(document).on("change","#coNmPopSelect_inDept",function(){
                coCdPDept = $('#coCdDept_inSelect option:selected').val()
                var pdeptOptions = getPdeptOptions();
                var str = '<select class="form-control input-sm" id="pDeptCd_inSelect" name="pDeptCd">';
                str += pdeptOptions;
                str += '</select>';
                $("#pDeptPopSelect_inDept").html(str);
                if(coCdPDept==''){
                    $('#pDeptCd_inSelect').prop("disabled",true);
                }else{
                    $('#pDeptCd_inSelect').prop("disabled",false);
                }
            });

            $(".nav-tabs a").click(function(){
                $('#searchStrInput').val('');

                $('#export_menu_co').hide();
                $('#export_menu_busi').hide();
                $('#export_menu_general').hide();
                $('#export_menu_dept').hide();
                $('#export_menu_jikgub').hide();
                $('#export_menu_jikin').hide();

                currentTab = $(this).attr('id');
                var options = getCoOptions();
                var pdeptOptions = getPdeptOptions();

                if(currentTab=='coTab'){
                    $('#export_menu_co').css('display','');
                    $('#searchStrInput').attr('placeholder','<s:message code="organizationInfo.enter.cocdconm"/>');
                } else if(currentTab=='busiTab'){
                    $('#export_menu_busi').css('display','');
                    $('#searchStrInput').attr('placeholder','<s:message code="organizationInfo.enter.busicdbusinm"/>');
                    var str = '<select class="form-control input-sm" id="coCdBusi_inSelect" name="coCd">';
                    str += options;
                    str += '</select>';
                    $("#coNmPopSelect_inBusi").html(str);
                } else if(currentTab=='generalTab'){
                    $('#export_menu_general').css('display','');
                    $('#searchStrInput').attr('placeholder','<s:message code="organizationInfo.enter.generalcdgeneralnm"/>');
                    var str = '<select class="form-control input-sm" id="coCdGeneral_inSelect" name="coCd">';
                    str += options;
                    str += '</select>';
                    $("#coNmPopSelect_inGeneral").html(str);
                } else if(currentTab=='deptTab'){
                    $('#export_menu_dept').css('display','');
                    $('#searchStrInput').attr('placeholder','<s:message code="organizationInfo.enter.deptcddeptnm"/>');
                    var str = '<select class="form-control input-sm" id="coCdDept_inSelect" name="coCd">';
                    str += options;
                    str += '</select>';
                    $("#coNmPopSelect_inDept").html(str);
                    var str = '<select class="form-control input-sm" id="pDeptCd_inSelect" name="pDeptCd">';
                    str += pdeptOptions;
                    str += '</select>';
                    $("#pDeptPopSelect_inDept").html(str);
                    $('#pDeptCd_inSelect').prop("disabled",true);
                } else if(currentTab=='jikgubTab'){
                    $('#export_menu_jikgub').css('display','');
                    $('#searchStrInput').attr('placeholder','<s:message code="organizationInfo.enter.jikgubcdjikgubnm"/>');
                } else if(currentTab=='jikinTab'){
                    $('#export_menu_jikin').css('display','');
                    $('#searchStrInput').attr('placeholder','<s:message code="organizationInfo.enter.jikincdjikinnm"/>');
                }
                /* $(this).tab('show'); */
                getData();
            });


            $('.savePopBtn').click(function(){
                $('.savePopBtn').prop('disabled', true);
                var tab = getCurrentTab();
                var insertTab = '';
                var grid = getCurrentGrid();
                if(tab=='coTab'){
                    var coCdPopInput = $('#coCdPopInput').val().ltrim().rtrim();
                    var coNmPopInput = $('#coNmPopInput').val().ltrim().rtrim();
                    if( coCdPopInput == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.enter.cocd"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( coNmPopInput == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.enter.conm"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( coCdPopInput.indexOf(',') > -1 ){
                        ui.alertMsg('<s:message code="common.error.code.comma"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    insertTab = '<s:message code="common.org.co"/>';
                }
                if(tab=='busiTab'){
                    var coNmTextBusi = $('#coCdBusi_inSelect option:selected').text();
                    $('#coNmHidden').val(coNmTextBusi);
                    var coCdBusi_inSelect = $('#coCdBusi_inSelect option:selected').val();
                    var busiCdPopInput = $('#busiCdPopInput').val().ltrim().rtrim();
                    var busiNmPopInput = $('#busiNmPopInput').val().ltrim().rtrim();
                    if( coCdBusi_inSelect == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.select.cocd"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( busiCdPopInput == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.select.busicd"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( busiNmPopInput == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.select.businm"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( busiCdPopInput.indexOf(',') > -1 ){
                        ui.alertMsg('<s:message code="common.error.code.comma"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    insertTab = '<s:message code="common.org.busi"/>';
                }
                if(tab=='generalTab'){
                    var coNmTextGeneral = $('#coCdGeneral_inSelect option:selected').text();
                    $('#coNmHiddenGeneral').val(coNmTextGeneral);
                    var coCdGeneral_inSelect = $('#coCdGeneral_inSelect option:selected').val();
                    var generalCdPopInput = $('#generalCdPopInput').val().ltrim().rtrim();
                    var generalNmPopInput = $('#generalNmPopInput').val().ltrim().rtrim();
                    if( coCdGeneral_inSelect == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.select.cocd"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( generalCdPopInput == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.enter.generalcd"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( generalNmPopInput == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.enter.generalnm"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( generalCdPopInput.indexOf(',') > -1 ){
                        ui.alertMsg('<s:message code="common.error.code.comma"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    insertTab = '<s:message code="common.org.general"/>';
                }
                if(tab=='deptTab'){
                    var coNmTextDept = $('#coCdDept_inSelect option:selected').text();
                    var parentDeptNm = $('#pDeptCd_inSelect option:selected').text();
                    $('#coNmHiddenDept').val(coNmTextDept);
                    $('#parentHiddenDept').val(parentDeptNm);
                    var coCdDept_inSelect = $('#coCdDept_inSelect option:selected').val();
                    var pDeptCd_inSelect = $('#pDeptCd_inSelect option:selected').val();
                    var deptCdPopInput = $('#deptCdPopInput').val().ltrim().rtrim();
                    var deptNmPopInput = $('#deptNmPopInput').val().ltrim().rtrim();
                    if( coCdDept_inSelect == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.select.cocd"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( deptCdPopInput == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.enter.deptcd"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( deptNmPopInput == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.enter.deptnm"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( deptCdPopInput.indexOf(',') > -1 ){
                        ui.alertMsg('<s:message code="common.error.code.comma"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    insertTab = '<s:message code="common.org.dept"/>';
                }
                if(tab=='jikgubTab'){
                    var jikgubCdPopInput = $('#jikgubCdPopInput').val().ltrim().rtrim();
                    var jikgubNmPopInput = $('#jikgubNmPopInput').val().ltrim().rtrim();
                    if( jikgubCdPopInput == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.enter.jikgubcd"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( jikgubNmPopInput == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.enter.jikgubnm"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( jikgubCdPopInput.indexOf(',') > -1 ){
                        ui.alertMsg('<s:message code="common.error.code.comma"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    insertTab = '<s:message code="common.org.jikgub"/>';
                }
                if(tab=='jikinTab'){
                    var jikinCdPopInput = $('#jikinCdPopInput').val().ltrim().rtrim();
                    var jikinNmPopInput = $('#jikinNmPopInput').val().ltrim().rtrim();
                    if( jikinCdPopInput == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.enter.jikincd"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( jikinNmPopInput == '' ){
                        ui.alertMsg('<s:message code="organizationInfo.enter.jikinnm"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    if( jikinCdPopInput.indexOf(',') > -1 ){
                        ui.alertMsg('<s:message code="common.error.code.comma"/>');
                        $('.savePopBtn').prop('disabled', false);
                        return;
                    }
                    insertTab = '<s:message code="common.org.jikin"/>';
                }
                var mode = getCurrentPopMode();

                var popId = 'coTab';
                if(tab == 'coTab') popId = 'coPop';
                else if(tab == 'busiTab') popId = 'busiPop';
                else if(tab == 'generalTab') popId = 'generalPop';
                else if(tab == 'deptTab') popId = 'deptPop';
                else if(tab == 'jikgubTab') popId = 'jikgubPop';
                else if(tab == 'jikinTab') popId = 'jikinPop';
                var message = mode=='insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
                var coNm = $('#coCdBusi_inSelect option:selected').text();
                ui.confirmMsg(message, '', '', function(rs){
                    if(rs){
                        grid.on();
                        ui.post({
                            tab : insertTab,
                            url : mode=='insert' ? setCurrentInsertUrl() : setCurrentUpdateUrl(),
                            data : getCurrentPopForm(),
                            success : function ( data, total ) {
                                ui.alertMsg('<s:message code="common.msg.saved"/>');
                                $('#'+popId+'').modal('hide');
                                getData ( );
                            },
                            error : function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete : function (){
                                grid.off();
                                $('.savePopBtn').prop('disabled', false);
                            }
                        });
                    } else {
                        $('.savePopBtn').prop('disabled', false);
                    }
                });
            });

            $('#insertBtn').click(function(){
                $('.savePopBtn').prop('disabled', false);
                var tab = getCurrentTab();
                if(tab=='coTab'){
                    $('#coCdPopInput').prop("disabled", false);
                    $('#coPop').attr('mode', 'insert');
                    $("#coPop").modal('show');
                    setTimeout(function(){
                        $('#coCdPopInput, #coNmPopInput').val('');
                        $('#coCdPopInput').focus();
                    },500);
                } else if(tab=='busiTab'){
                    $('#coCdBusi_inSelect').prop("disabled", false);
                    $('#busiCdPopInput').prop("disabled", false);
                    $('#busiPop').attr('mode', 'insert');
                    $('#busiPop').modal('show');
                    setTimeout(function(){
                        $('#coCdBusi_inSelect, #busiCdPopInput, #busiNmPopInput').val('');
                        $('#coCdBusi_inSelect').focus();
                    },500);
                } else if(tab=='generalTab'){
                    $('#generalPop').attr('mode', 'insert');
                    $('#generalPop').modal('show');
                    $('#coCdGeneral_inSelect').prop("disabled", false);
                    $('#generalCdPopInput').prop("disabled", false);
                    $('#coCdGeneral_inSelect, #generalCdPopInput, #generalNmPopInput').val('');
                    setTimeout(function(){
                        $('#coCdGeneral_inSelect, #generalCdPopInput, #generalNmPopInput').val('');
                        $('#coCdGeneral_inSelect').focus();
                    },500);

                }else if(tab=='deptTab'){
                    $('#deptCdPopInput').prop("disabled", false);
                    $('#deptPop').attr('mode', 'insert');
                    $('#deptPop').modal('show');
                    $('#deptCdPopInput, #deptNmPopInput').val('');
                    $('#deptCdPopInput').focus();
                    $('#coCdDept_inSelect, #pDeptCd_inSelect, #deptCdPopInput, #deptNmPopInput').val('');
                    $('#coCdDept_inSelect').focus();

                }else if(tab=='jikgubTab'){
                    $('#jikgubCdPopInput').prop("disabled", false);
                    $('#jikgubPop').attr('mode', 'insert');
                    $('#jikgubPop').modal('show');
                    $('#jikgubCdPopInput, #jikgubNmPopInput').val('');
                    $('#jikgubCdPopInput').focus();
                }else if(tab=='jikinTab'){
                    $('#jikinCdPopInput').prop("disabled", false);
                    $('#jikinPop').attr('mode', 'insert');
                    $('#jikinPop').modal('show');
                    $('#jikinCdPopInput, #jikinNmPopInput').val('');
                    $('#jikinCdPopInput').focus();
                }
            });

            $('#deleteBtn').click(function(){
                $('#deleteBtn').prop('disabled', true);
                var grid = getCurrentGrid();
                var rows = grid.getSelectedKey('coCd');
                var rowsNm = grid.getSelectedKey('coNm');
                var tab = getCurrentTab();
                if(tab == 'coTab'){
                    popId = 'coPop';
                }
                else if(tab == 'busiTab'){
                    rows = grid.getSelectedKey('busiCd');
                    rowsNm = grid.getSelectedKey('busiNm');
                }
                else if(tab == 'generalTab'){
                    rows = grid.getSelectedKey('generalCd');
                    rowsNm = grid.getSelectedKey('generalNm');
                }
                else if(tab == 'deptTab'){
                    rows = grid.getSelectedKey('deptCd');
                    rowsNm = grid.getSelectedKey('deptNm');
                }
                else if(tab == 'jikgubTab'){
                    rows = grid.getSelectedKey('jikgubCd');
                    rowsNm = grid.getSelectedKey('jikgubNm');
                }
                else if(tab == 'jikinTab'){
                    rows = grid.getSelectedKey('jikinCd');
                    rowsNm = grid.getSelectedKey('jikinNm');
                }

                if ( rows.length == 0 ) {
                    ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                    $('#deleteBtn').prop('disabled', false);
                    return;
                }
                if( rows.includes('C00-00') ) {
                    ui.alertMsg('<s:message code="organizationInfo.cannot.delete"/>');
                    $('#deleteBtn').prop('disabled', false);
                    return;
                }
                ui.confirmMsg('<s:message code="common.msg.confirm.deleteitem" arguments="'+rows+'" argumentSeparator="|"/>', '', '', function(rs){
                    if(rs){
                        grid.on();
                        var param = {};
                        param.url = setCurrentDeleteUrl();
                        if(tab == 'coTab'){
                            param.coCd = rows.join(',');
                            param.coNm = rowsNm.join(',');
                        }
                        else if(tab == 'busiTab'){
                            param.busiCd = rows.join(',');
                            param.busiNm = rowsNm.join(',');
                        }
                        else if(tab == 'generalTab'){
                            param.generalCd = rows.join(',');
                            param.generalNm = rowsNm.join(',');
                        }
                        else if(tab == 'deptTab'){
                            param.deptCd = rows.join(',');
                            param.deptNm = rowsNm.join(',');
                        }
                        else if(tab == 'jikgubTab'){
                            param.jikgubCd = rows.join(',');
                            param.jikgubNm = rowsNm.join(',');
                        }
                        else if(tab == 'jikinTab'){
                            param.jikinCd = rows.join(',');
                            param.jikinNm = rowsNm.join(',');
                        }


                        param.success = function ( data, total ) {
                            ui.alertMsg('<s:message code="common.msg.deleted"/>');
                            $('#deleteBtn').prop('disabled', false);
                            getData ( );
                        };
                        param.error = function (status, message) {
                            ui.alertMsg(message);
                        };
                        param.complete = function (){
                            grid.off();
                        };

                        ui.get(param);

                    } else {
                        $('#deleteBtn').prop('disabled', false);
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
                    if(nvl(data, 'N') == 'N' || data.val == 'N') {
                        $('#insertBtn').show();
                        $('#deleteBtn').show();
                    } else {
                        $('#insertBtn').hide();
                        $('#deleteBtn').hide();
                    }
                },
                error : function (status, message) {
                    ui.alertMsg(message);
                },
                complete : function (){
                }
            });
        }

        //선택된 탭
        var currentTab;
        function getCurrentTab(){
            return currentTab==null ? 'coTab' : currentTab;
        }
        //선택된 탭의 그리드
        function getCurrentGrid(){
            var tab = getCurrentTab();
            if(tab=='coTab') return gridCo;
            else if(tab=='busiTab') return gridBusi;
            else if(tab=='generalTab') return gridGeneral;
            else if(tab=='deptTab') return gridDept;
            else if(tab=='jikgubTab') return gridJikgub;
            else if(tab=='jikinTab') return gridJikin;
            else return  null;
        }
        //선택된 탭의 검색 주소
        function getCurrentSearchUrl(){
            var tab = getCurrentTab();
            if(tab=='coTab') return 'getCoList.xcn';
            else if(tab=='busiTab') return 'getBusiList.xcn';
            else if(tab=='generalTab') return 'getGeneralList.xcn';
            else if(tab=='deptTab') return 'getDeptList.xcn';
            else if(tab=='jikgubTab') return 'getJikgubList.xcn';
            else if(tab=='jikinTab') return 'getJikinList.xcn';
            else return  null;
        }
        //선택된 탭의 입력 주소
        function setCurrentInsertUrl(){
            var tab = getCurrentTab();
            if(tab=='coTab') return 'insertCo.xcn';
            else if(tab=='busiTab') return 'insertBusi.xcn';
            else if(tab=='generalTab') return 'insertGeneral.xcn';
            else if(tab=='deptTab') return 'insertDept.xcn';
            else if(tab=='jikgubTab') return 'insertJikgub.xcn';
            else if(tab=='jikinTab') return 'insertJikin.xcn';
            else return  null;
        }
        //선택된 탭의 수정 주소
        function setCurrentUpdateUrl(){
            var tab = getCurrentTab();
            if(tab=='coTab') return 'updateCo.xcn';
            else if(tab=='busiTab') return 'updateBusi.xcn';
            else if(tab=='generalTab') return 'updateGeneral.xcn';
            else if(tab=='deptTab') return 'updateDept.xcn';
            else if(tab=='jikgubTab') return 'updateJikgub.xcn';
            else if(tab=='jikinTab') return 'updateJikin.xcn';
            else return  null;
        }
        //선택된 탭의 삭제 주소
        function setCurrentDeleteUrl(){
            var tab = getCurrentTab();
            if(tab=='coTab') return 'deleteCo.xcn';
            else if(tab=='busiTab') return 'deleteBusi.xcn';
            else if(tab=='generalTab') return 'deleteGeneral.xcn';
            else if(tab=='deptTab') return 'deleteDept.xcn';
            else if(tab=='jikgubTab') return 'deleteJikgub.xcn';
            else if(tab=='jikinTab') return 'deleteJikin.xcn';
            else return  null;
        }
        /* //선택된 탭의 페이징 div 아이디
		function getCurrentPagingId(){
			var tab = getCurrentTab();
			if(tab=='coTab') return 'coListPaging';
			else if(tab=='busiTab') return 'busiListPaging';
			else if(tab=='generalTab') return 'generalListPaging';
			else if(tab=='deptTab') return 'deptListPaging';
			else if(tab=='jikgubTab') return 'jikgubListPaging';
			else if(tab=='jikinTab') return 'jikinListPaging';
			else return  null;
		} */
        //선택된 탭의 모드
        function getCurrentPopMode(){
            var tab = getCurrentTab();
            if(tab=='coTab') return $('#coPop').attr('mode');
            else if(tab=='busiTab') return $('#busiPop').attr('mode');
            else if(tab=='generalTab') return $('#generalPop').attr('mode');
            else if(tab=='deptTab') return $('#deptPop').attr('mode');
            else if(tab=='jikgubTab') return $('#jikgubPop').attr('mode');
            else if(tab=='jikinTab') return $('#jikinPop').attr('mode');
            else return  null;
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


        //데이터 검색
        function getData( flag ) {
            if (searchFlag) return;
            var tab = getCurrentTab();
            if(tab=='coTab') tab = '<s:message code="common.org.co"/>';
            else if(tab=='busiTab') tab = '<s:message code="common.org.busi"/>';
            else if(tab=='generalTab') tab = '<s:message code="common.org.general"/>';
            else if(tab=='deptTab')  tab = '<s:message code="common.org.dept"/>';
            else if(tab=='jikgubTab')  tab = '<s:message code="common.org.jikgub"/>';
            else if(tab=='jikinTab') tab = '<s:message code="common.org.jikin"/>';
            else tab="";
            var grid = getCurrentGrid();

            if ( flag == undefined ) {
                grid.data.length = 0;
                grid.rtnNextPageFunc = getData;
                grid.loadingPage = 0;
            } else {
                grid.loadingPage++;
            }

            searchFlag = true;
            grid.on();
            ui.get({
                tab : tab,
                url : getCurrentSearchUrl(),
                searchStr : $('#searchStrInput').val(),
                offset : grid.data.length,
                limit : grid.pageSize,
                success : function(data, total) {
                    if ( flag == 'Y' || flag == undefined ) resultTotal = total;
                    grid.appendData(data);

                    $('#resultCnt').html(grid.data.length);
                    if ( grid.loadingPage == 0 ) grid.Select(-1,-1);
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                    grid.off();
                    searchFlag = false;
                }
            });
        }
        /* function changePage(pageNum){
			var grid = getCurrentGrid();
			grid.loadingPage = pageNum-1;
			getData('N')
		} */

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

        function getPdeptOptions(){
            var result = '';
            ui.get({
                url : 'getDeptListByCo.xcn',
                asyncFlag : false,
                searchStr :'',
                coCd:coCdPDept,
                success : function(data, total) {
                    result+='<option value="">-<s:message code="common.org.choose.pdept"/>-</option>';
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
	</script>
</head>
<body class="mini-navbar" >

<div class="modal" id="coPop" tabindex="-1" role="dialog" aria-labelledby="coModal">
	<div class="modal-content">
		<form method="post" id="coPopForm">
			<div class="modalHead">
				<h2><s:message code="common.org.co"/>-<s:message code="common.msg.addmodify"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3>회사 추가</h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						필수 입력 사항입니다.
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="coCdPopInput"><s:message code="common.org.cocd"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" name="coCd" id="coCdPopInput" placeholder="<s:message code="common.org.cocd"/>" required maxlength="20">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="coNmPopInput"><s:message code="common.org.conm"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" name="coNm" id="coNmPopInput" placeholder="<s:message code="common.org.conm"/>" required maxlength="20">
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" class="savePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>

<div class="modal" id="busiPop" tabindex="-1" role="dialog" aria-labelledby="busiModal">
	<div class="modal-content">
		<form method="post" id="busiPopForm">
			<div class="modalHead">
				<h2><s:message code="common.org.busi"/>-<s:message code="common.msg.addmodify"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3>사업장 추가</h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						필수 입력 사항입니다.
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="busiCdPopInput"><s:message code="common.org.co"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<div id="coNmPopSelect_inBusi"></div>
							<input type="hidden" name="coNm" id="coNmHidden">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="busiCdPopInput"><s:message code="common.org.busicd"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" name="busiCd" id="busiCdPopInput" placeholder="<s:message code="common.org.busicd"/>" required maxlength="20">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="busiNmPopInput"><s:message code="common.org.businm"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="form-control" name="busiNm" id="busiNmPopInput" placeholder="<s:message code="common.org.businm"/>" required maxlength="20">
						</div>
					</div>

					<div class="modalfooter">
						<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
						<button type="button" class="pop_btn02" accesskey="S" class="savePopBtn"><s:message code="common.msg.save"/></button>
					</div>
				</div>
			</div>
		</form>
	</div>
</div>


<div class="container">
	<div class="searchArea">
		<div class="searchSub">
			<div>
				<input type="text" placeholder="<s:message code="ipRange.msg.enter.busicomment"/>" id="searchStrInput">
				<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message
						code="common.msg.search"/></button>
			</div>
			<div class="btnform">
				<button type="button" class="btn01" accesskey="I" id="insertBtn"><img
						src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
				<button type="button" class="btn02" accesskey="D" id="deleteBtn"><img
						src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/>
				</button>
			</div>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<div class="row">
					<div class="col-xs-12">
						<ul class="nav nav-tabs codeTab" id="codeTab">
							<li class="active" style=" text-align: center"><a data-toggle="tab" href="#coList"
							                                                  id="coTab"><s:message
									code="common.org.co"/></a></li>
							<li style=" text-align: center"><a data-toggle="tab" href="#busiList"
							                                   id="busiTab"><s:message code="common.org.busi"/></a></li>
							<li style=" text-align: center"><a data-toggle="tab" href="#generalList"
							                                   id="generalTab"><s:message
									code="common.org.general"/></a></li>
							<li style=" text-align: center"><a data-toggle="tab" href="#deptList"
							                                   id="deptTab"><s:message code="common.org.dept"/></a></li>
							<li style=" text-align: center"><a data-toggle="tab" href="#jikgubList"
							                                   id="jikgubTab"><s:message code="common.org.jikgub"/></a>
							</li>
							<li style=" text-align: center"><a data-toggle="tab" href="#jikinList"
							                                   id="jikinTab"><s:message code="common.org.jikin"/></a>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div id="coList" class="tab-content active"style="height:100%;">
				<div id="coListGrid" class="slickGrid gridArea"></div>
			</div>
			<div id="busiList" class="tab-content" style="height:100%;">
				<div id="busiListGrid" class="slickGrid gridArea"></div>
			</div>
			<div id="generalList" class="tab-content" style="height:100%;">
				<div id="generalListGrid" class="slickGrid gridArea"></div>
			</div>
			<div id="deptList" class="tab-content" style="height:100%;">
				<div id="deptListGrid" class="slickGrid gridArea"></div>
			</div>
			<div id="jikgubList" class="tab-content" style="height:100%;">
				<div id="jikgubListGrid" class="slickGrid gridArea"></div>
			</div>
			<div id="jikinList" class="tab-content" style="height:100%;">
				<div id="jikinListGrid" class="slickGrid gridArea"></div>
			</div>
		</div>
	</div>
</div>
</div>
</body>
<script type="text/javascript">
    var gridCo = new Xgrid('coListGrid', contextRoot);
    gridCo.onCheckBox();
    gridCo.autoNumber();
    gridCo.colAdd('coCd', '<s:message code="common.org.cocd"/>', 120, 'center', false, 'link');
    gridCo.colAdd('coNm', '<s:message code="common.org.conm"/>', 200, 'left', false, 'nomal');
    gridCo.onClick = function() {
        if( $('#insertBtn').css('display') == 'none' ) return;
        if (gridCo.Col == gridCo.ColIndex('coCd')) {
            $('#coCdPopInput').prop("disabled", true);
            $('#coPop').attr('mode', 'modify');
            $('#coCdPopInput').val(gridCo.getValue(gridCo.Row, 'coCd'));
            $('#coNmPopInput').val(gridCo.getValue(gridCo.Row, 'coNm'));
            $('#coPop').modal('show');
            $('#coNmPopInput').focus();
        }
    };
    gridCo.loadExportMenu('<s:message code="organizationInfo.co"/>');
    gridCo.loadPageSize();
    gridCo.loadHeader(true);
    gridCo.initData('<s:message code="common.msg.search.click"/>');
    gridCo.changePageSize = function(cnt){
        getData();
    };

    var gridBusi = new Xgrid('busiListGrid', contextRoot);
    gridBusi.onCheckBox();
    gridBusi.autoNumber();

    gridBusi.colAdd('busiCd', '<s:message code="common.org.busicd"/>', 120, 'center', false, 'link');
    gridBusi.colAdd('busiNm', '<s:message code="common.org.businm"/>', 200, 'left', false, 'nomal');
    gridBusi.colAdd('coNm', '<s:message code="common.org.conm"/>', 200, 'left', false, 'nomal');
    gridBusi.onClick = function() {
        if( $('#insertBtn').css('display') == 'none' ) return;
        if (gridBusi.Col == gridBusi.ColIndex('busiCd')) {
            $('#coCdBusi_inSelect').prop("disabled", true);
            $('#busiCdPopInput').prop("disabled", true);
            $('#busiPop').attr('mode', 'modify');
            $('#busiPop').modal('show');
            $('#busiCdPopInput').val(gridBusi.getValue(gridBusi.Row, 'busiCd'));
            $('#busiNmPopInput').val(gridBusi.getValue(gridBusi.Row, 'busiNm'));
            $('#coCdBusi_inSelect').val(gridBusi.getValue(gridBusi.Row, 'coCd'));
            $('#busiNmPopInput').focus();
        }
    };
    gridBusi.loadExportMenu('<s:message code="organizationInfo.busi"/>');
    gridBusi.loadPageSize();
    gridBusi.loadHeader(true);
    gridBusi.initData('<s:message code="common.msg.search.click"/>');
    gridBusi.changePageSize = function(cnt){
        getData();
    };

    var gridGeneral = new Xgrid('generalListGrid', contextRoot);
    gridGeneral.onCheckBox();
    gridGeneral.autoNumber();

    gridGeneral.colAdd('generalCd', '<s:message code="common.org.generalcd"/>', 120, 'center', false, 'link');
    gridGeneral.colAdd('generalNm', '<s:message code="common.org.generalnm"/>', 200, 'left', false, 'nomal');
    gridGeneral.colAdd('coNm', '<s:message code="common.org.conm"/>', 200, 'left', false, 'nomal');
    gridGeneral.onClick = function() {
        if( $('#insertBtn').css('display') == 'none' ) return;
        if (gridGeneral.Col == gridGeneral.ColIndex('generalCd')) {
            $('#coCdGeneral_inSelect').prop("disabled", true);
            $('#generalCdPopInput').prop("disabled", true);
            $('#generalPop').attr('mode', 'modify');
            $('#generalPop').modal('show');
            $('#generalCdPopInput').val(gridGeneral.getValue(gridGeneral.Row, 'generalCd'));
            $('#generalNmPopInput').val(gridGeneral.getValue(gridGeneral.Row, 'generalNm'));
            $('#coCdGeneral_inSelect').val(gridGeneral.getValue(gridGeneral.Row, 'coCd'));
            $('#generalNmPopInput').focus();
        }
    };
    gridGeneral.loadExportMenu('<s:message code="organizationInfo.general"/>');
    gridGeneral.loadPageSize();
    gridGeneral.loadHeader(true);
    gridGeneral.initData('<s:message code="common.msg.search.click"/>');
    gridGeneral.changePageSize = function(cnt){
        getData();
    };

    var gridDept = new Xgrid('deptListGrid', contextRoot);
    gridDept.onCheckBox();
    gridDept.autoNumber();
    gridDept.colAdd('deptCd', '<s:message code="common.org.deptcd"/>', 120, 'center', false, 'link');
    gridDept.colAdd('deptNm', '<s:message code="common.org.deptnm"/>', 200, 'left', false, 'nomal');
    gridDept.colAdd('pdeptCd', '<s:message code="common.org.pdeptcd"/>', 120, 'center', false, 'nomal');
    gridDept.colAdd('pdeptNm', '<s:message code="common.org.pdeptnm"/>', 200, 'left', false, 'nomal');
    gridDept.colAdd('coNm', '<s:message code="common.org.conm"/>', 200, 'left', false, 'nomal');
    gridDept.onClick = function() {
        if( $('#insertBtn').css('display') == 'none' ) return;
        if (gridDept.Col == gridDept.ColIndex('deptCd')) {
            $('#deptCdPopInput').prop("disabled", true);
            $('#deptPop').attr('mode', 'modify');
            $('#deptPop').modal('show');
            $('#deptCdPopInput').val(gridDept.getValue(gridDept.Row, 'deptCd'));
            $('#deptNmPopInput').val(gridDept.getValue(gridDept.Row, 'deptNm'));
            $('#coCdDept_inSelect').val(gridDept.getValue(gridDept.Row, 'coCd'));
            $('#pDeptCd_inSelect').val(gridDept.getValue(gridDept.Row, 'pdeptCd'));
            $('#deptNmPopInput').focus();
        }
    };
    gridDept.loadExportMenu('<s:message code="organizationInfo.dept"/>');
    gridDept.loadPageSize();
    gridDept.loadHeader(true);
    gridDept.initData('<s:message code="common.msg.search.click"/>');
    gridDept.changePageSize = function(cnt){
        getData();
    };

    var gridJikgub = new Xgrid('jikgubListGrid', contextRoot);
    gridJikgub.onCheckBox();
    gridJikgub.autoNumber();
    gridJikgub.colAdd('jikgubCd', '<s:message code="common.org.jikgubcd"/>', 120, 'center', false, 'link');
    gridJikgub.colAdd('jikgubNm', '<s:message code="common.org.jikgubnm"/>', 200, 'left', false, 'nomal');
    gridJikgub.onClick = function() {
        if( $('#insertBtn').css('display') == 'none' ) return;
        if (gridJikgub.Col == gridJikgub.ColIndex('jikgubCd')) {
            $('#jikgubCdPopInput').prop("disabled", true);
            $('#jikgubPop').attr('mode', 'modify');
            $('#jikgubPop').modal('show');
            $('#jikgubCdPopInput').val(gridJikgub.getValue(gridJikgub.Row, 'jikgubCd'));
            $('#jikgubNmPopInput').val(gridJikgub.getValue(gridJikgub.Row, 'jikgubNm'));
            $('#jikgubNmPopInput').focus();
        }
    };
    gridJikgub.loadExportMenu('<s:message code="organizationInfo.jikgub"/>');
    gridJikgub.loadPageSize();
    gridJikgub.loadHeader(true);
    gridJikgub.initData('<s:message code="common.msg.search.click"/>');
    gridJikgub.changePageSize = function(cnt){
        getData();
    };

    var gridJikin = new Xgrid('jikinListGrid', contextRoot);
    gridJikin.onCheckBox();
    gridJikin.autoNumber();
    gridJikin.colAdd('jikinCd', '<s:message code="common.org.jikincd"/>', 120, 'center', false, 'link');
    gridJikin.colAdd('jikinNm', '<s:message code="common.org.jikinnm"/>', 200, 'left', false, 'nomal');
    gridJikin.onClick = function() {
        if( $('#insertBtn').css('display') == 'none' ) return;
        if (gridJikin.Col == gridJikin.ColIndex('jikinCd')) {
            $('#jikinCdPopInput').prop("disabled", true);
            $('#jikinPop').attr('mode', 'modify');
            $('#jikinPop').modal('show');
            $('#jikinCdPopInput').val(gridJikin.getValue(gridJikin.Row, 'jikinCd'));
            $('#jikinNmPopInput').val(gridJikin.getValue(gridJikin.Row, 'jikinNm'));
            $('#jikinNmPopInput').focus();
        }
    };
    gridJikin.loadExportMenu('<s:message code="organizationInfo.jikin"/>');
    gridJikin.loadPageSize();
    gridJikin.loadHeader(true);
    gridJikin.initData('<s:message code="common.msg.search.click"/>');
    gridJikin.changePageSize = function(cnt){
        getData();
    };
</script>

</body>
</html>