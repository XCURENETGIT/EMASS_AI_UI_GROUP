<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<head>
	<title>EMASS PRO - <s:message code="DATA_MONITOR.CONSENT_MGMT"/></title>
	<style type="text/css">
		.ellipsis {
			text-overflow: ellipsis;
			overflow: hidden;
			white-space: nowrap;
		}
	</style>
	<script type="text/javascript">
        var searchFlag = false;
        $(document).ready(function () {
            $('#searchBtn').click(function () {
                getData();
            });
            $('#searchStr').enter(function () {
                getData();
            });

            $("input:checkbox[name='alarmType']").change(function () {
                var alarmType = $(this).val();
                var checked = $(this).is(":checked");
                if (alarmType == "E") {
                    if (checked) {
                        $('#alarmMailYn').val('Y');
                    } else {
                        $('#alarmMailYn').val('N');
                    }
                } else if (alarmType == "S") { //SMS
                    if (checked) {
                        $('#alarmSmsYn').val('Y');
                    } else {
                        $('#alarmSmsYn').val('N');
                    }
                } else if (alarmType == "M") { //화면
                    if (checked) {
                        $('#alarmMonitorYn').val('Y');
                    } else {
                        $('#alarmMonitorYn').val('N');
                    }
                }
            });

            $('#alarmSetup').change(function () {
                changeAlarmSetup();
            });

            function changeAlarmSetup() {
                var checked = !$('#alarmSetup').prop('checked');
                if (!checked) $('#alarmYn').val('Y');
                else $('#alarmYn').val('N');
                $("input:radio[name='registrantYn']").prop('disabled', checked);
                $("input:checkbox[name='alarmType']").prop('disabled', checked);
            }

            $('.savePopBtn').click(function () {
                var mode = $('#consentPop').attr('mode');

                if ($('#name').val() == '') {
                    ui.alertMsg('<s:message code="consent.select.user"/>');
                    return;
                }
                if ($('#alarmYn').val() == 'Y' && !$("input:checkbox[name='alarmType']").is(':checked')) {
                    ui.alertMsg('<s:message code="consent.select.alarm.type"/>');
                    return;
                }
                var sdate = $('#sdate').val().replace(/[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi, '');
                var edate = $('#edate').val().replace(/[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi, '');
                if (sdate > edate) {
                    ui.alertMsg('<s:message code="consent.wrong.date"/>');
                    return;
                }
                ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function (rs) {
                    if (rs) {
                        if (mode == 'insert') $('#consentPopForm').attr('action', '<c:url value="/insertConsent.xcn"/>');
                        else $('#consentPopForm').attr('action', '<c:url value="/updateConsent.xcn"/>');

                        $('#no, #name, #userId, #deptNm, #createNm').prop('disabled', false);
                        $("#consentPopForm").ajaxForm({
                            target: '#return',
                            beforeSubmit: function () {
                                $('#no, #name, #userId, #deptNm, #createNm').prop('disabled', true);
                                $('#attachSpan').html('<input type="file" class="w100" name="attach" id="attach" style="width: 350px; border: 0px; padding: 0px; background-color: transparent">');
                            },
                            success: function (result) {
                                if (result.success) {
                                    $("#consentPop").attr('mode', '');
                                    ui.alertMsg('<s:message code="common.msg.saved"/>');
                                    $('#consentPop').modal('hide');
                                    getData();
                                } else {
                                    ui.alertMsg('<s:message code="consent.saved.fail"/>');
                                }
                            },
                            error: function () {
                                ui.alertMsg('<s:message code="consent.saved.fail"/>');
                            },
                            complete: function () {
                            }
                        }).submit();
                    }
                });
            });

            $("#consentPop").on('show.bs.modal', function () {
                $('#sdate').prop('disabled', true);
                $('#fileDeleteYn').val('');
                if ($("#consentPop").attr('mode') == 'insert') {
                    $('#attachSpan').html('<input type="file" class="w100" name="attach" id="attach" style="width: 350px; border: 0px; padding: 0px; background-color: transparent">').show();
                    $('#attachNameSpan').hide();
                    ui.get({
                        url: 'getConsentSeq.xcn',
                        success: function (data, total) {
                            $('#no').val(data.newSeq);
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {

                        }
                    });
                }
            });

            $("#consentPop").on('hidden.bs.modal', function () {
                if ($("#consentPop").attr('mode') == 'insert') {
                    ui.get({
                        url: 'deleteConsentSeq.xcn',
                        consentNo: $('#no').val(),
                        success: function (data, total) {
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {

                        }
                    });
                }
            });

            $('#attachNameA').click(function () {
                var no = $('#no').val();
                var href = '<c:url value="/downloadConsentFile.do"/>?no=' + no;
                ui.on('consentPop');
                $.fileDownload(href, {
                    successCallback: function (url) {
                        ui.off('consentPop');
                    },
                    failCallback: function (responseHtml, url) {
                        ui.off('consentPop');
                        ui.alertMsg('<s:message code="consent.error.file"/>');
                    }
                });
            });

            $('#approveBtn').click(function () {
                updateApproval('A');
            });
            $('#returnBtn').click(function () {
                updateApproval('R');
            });
            $('#cancelApproveBtn').click(function () {
                updateApproval('C');
            });

            $('#insertBtn').click(function () {
                $('#consentPop').attr('mode', 'insert');
                $('#consentPop').modal('show');
                $('#user').show();
                $('#approve, #return').hide();

                $('#type').val('B');
                $('#name, #userId, #deptNm, #createId, #userIp, #purpose').val('');
                $('#alarmSetup').prop('checked', false).change();
                $('[name=registrantYn][value=Y]').prop('checked', true);
                $('[name=alarmType]').prop('checked', false);

                var d = new Date();
                var d2 = new Date().addMonths(1);
                var sdate = d.getFullYear() + '-' + ((d.getMonth() + 1) < 10 ? '0' + (d.getMonth() + 1) : (d.getMonth() + 1)) + '-' + (d.getDate() < 10 ? '0' + d.getDate() : d.getDate());
                var edate = d2.getFullYear() + '-' + ((d2.getMonth() + 1) < 10 ? '0' + (d2.getMonth() + 1) : (d2.getMonth() + 1)) + '-' + (d2.getDate() < 10 ? '0' + d2.getDate() : d2.getDate());
                $('#sdate').val(sdate);
                $('#edate').val(edate);

                $('#createNm').val('${_USERCREDENTIAL_.adminName}');
                $('#createId').val('${_USERCREDENTIAL_.adminId}');
                $('#createDt').val($('#sdate').val());
                $('#approveBtn, #returnBtn, #cancelApproveBtn').hide();
            });

            /* $('#deleteBtn').click(function(){
				var rows = grid.getSelectedKey('userId');
				grid.on();
				ui.confirmMsg( ''+rows+'를하시겠습니까?', '', '', function(rs){
						if(rs){
							 ui.get({
									url : 'deleteUser.xcn',
									userId : rows.join(','),
									success : function ( data, total ) {
										ui.alertMsg('삭제 되었습니다.');
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
			}); */

            $('#attachModifyBtn').click(function () {
                $('#fileDeleteYn').val('Y');
                $('#attachNameA').hide();
                $('#attachNameB').html('<input type="file" class="w100" name="attach" id="attach" style="width: 350px; border: 0px; padding: 0px; background-color: transparent">');
                $('#attachModifyBtn, #attachDeleteBtn').hide();
            });
            $('#attachDeleteBtn').click(function () {
                $('#fileDeleteYn').val('Y');
                $('#attachNameA').css('text-decoration', 'line-through');
            });
            $('#attachCancelBtn').click(function () {
                $('#fileDeleteYn').val('');
                $('#attachNameA').css('text-decoration', 'none').show();
                $('#attachNameB').html('');
                $('#attachModifyBtn, #attachDeleteBtn').show();
            });

            $('#startdatepicker, #sdateDiv').datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date())
            });

            $('#enddatepicker').datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date())
            });
            $('#edateDiv').datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date().addMonths(1))
            });

            $('.selBtn').click(function () {
                openWindow('user')
            });

            getData();
        });

        function updateApproval(type) {
            var str = '';
            if (type == 'A') str = '<s:message code="consent.approved"/>';
            else if (type == 'R') str = '<s:message code="consent.rejected"/>';
            else if (type == 'C') str = '<s:message code="consent.approved.canceled"/>';

            ui.confirmMsg('<s:message code="consent.msg.update" arguments="'+str+'" argumentSeparator="|"/>', '', '', function (rs) {
                if (rs) {
                    ui.get({
                        url: 'updateApproval.xcn',
                        //data : $('#consentPopForm').serializeAll(),
                        no: $('#no').val(),
                        type: $('#type').val(),
                        name: $('#name').val(),
                        userId: $('#userId').val(),
                        deptNm: $('#deptNm').val(),
                        edate: $('#edate').val(),
                        appCd: type,
                        alarmYn: $('#alarmYn').val(),
                        registrantYn: $("input:radio[name='registrantYn']:checked").val(),
                        alarmMailYn: $('#alarmMailYn').val(),
                        alarmSmsYn: $('#alarmSmsYn').val(),
                        alarmMonitorYn: $('#alarmMonitorYn').val(),
                        createNm: $('#createNm').val(),
                        createId: $('#createId').val(),
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="consent.msg.finish" arguments="'+str+'" argumentSeparator="|"/>');
                            $('#consentPop').modal('hide');
                            getData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {

                        }

                    });
                }

            });
        }

        function openWindow(id) {
            var url = '<c:url value="/ems/selectInterestUser.do?codeType=user"/>';
            return fnOpenWindow(url, 'selectUserWinPopup', 1200, 700, 'resize');
        }

        function selectedUserInfo(obj) {
            $('#name').val(obj.userNm);
            $('#userId').val(obj.userId);
            $('#deptNm').val(obj.deptNm);
            $('#userIp').val(obj.userIp);
        }

        function getData(lastRow) {
            if (searchFlag) return;
            if (lastRow == undefined) {
                grid.data.length = 0;
                grid.rtnNextPageFunc = getData;
                grid.loadingPage = 0;
            } else {
                grid.loadingPage++;
            }
            var startDate = $('#startDate').val();
            var endDate = $('#endDate').val();
            startDate = $('#startDate').val().replaceAll("-", "");
            endDate = $('#endDate').val().replaceAll("-", "");
            if (startDate > endDate) {
                ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
                return;
            }
            grid.on();

            searchFlag = true;
            var type = $('#consentType').val();
            var consentStatus = $('#consentStatus').val();
            var createNm = $('#createNm').val();
            var searchStr = $('#searchStr').val();

            ui.get({
                url: 'getConsentList.xcn',
                startDate: startDate,
                endDate: endDate,
                type: type,
                typeStr: $('#consentType option:selected').text(),
                consentStatus: consentStatus,
                consentStatusStr: $('#consentStatus option:selected').text(),
                createNm: createNm,
                searchStr: searchStr,
                offset: grid.data.length,
                limit: grid.pageSize,
                success: function (data, total) {
                    grid.appendData(data);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    searchFlag = false;
                    grid.off();
                }
            });
        }
	</script>
</head>
<div id="return"></div>
<div class="modal" id="consentPop" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="consentPopForm" enctype="multipart/form-data" target="upload_file">
			<div class="modalHead">
				<h2><s:message code="consent.consent"/> - <s:message code="common.msg.addmodify"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="consent.consent"/> - <s:message code="common.msg.addmodify"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						필수 입력 사항입니다.
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="no" class="fname"><s:message code="consent.number"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="no" id="no" disabled="disabled">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="type" class="fname"><s:message code="consent.type"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<select id="type" name="type">
								<option value="B"><s:message code="consent.informed.consent"/></option>
								<option value="A"><s:message code="consent.post.consent"/></option>
								<option value="M"><s:message code="consent.monitoring.consent"/></option>
								<option value="E"><s:message code="consent.retire.consent"/></option>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="name" class="fname"><s:message code="consent.user"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="name" id="name" disabled="disabled" style="width: 265px;">
							<button type="button" class="form_btn03 selBtn" accesskey="U" id="user"><s:message code="consent.select"/></button>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="userId" class="fname"><s:message code="common.msg.id"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="userId" id="userId" disabled="disabled">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="deptNm" class="fname"><s:message code="common.org.dept"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="deptNm" id="deptNm" disabled="disabled">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="generalSelect_inUser" class="fname"><s:message code="consent.expiration.date"/></label>
						</div>
						<div class="col-65">
							<div style="display: flex;">
								<div id="sdateDiv"><input type="date" id="sdate" style="width: 110px;">
									<span class="hyphen">~</span></div>&nbsp;
								<div id="edateDiv"><input type="date" id="edate" style="width: 110px;"></div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="createNm" class="fname"><s:message code="consent.registrant"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="createNm" id="createNm" disabled="disabled">
							<input type="hidden" name="createId" id="createId">
							<input type="hidden" id="userIp" name="userIp"/>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="createDt" class="fname"><s:message code="consent.registered.date"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="createDt" id="createDt" disabled="disabled">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="purpose" class="fname"><s:message code="consent.purpose.search"/></label>
						</div>
						<div class="col-65">
						<textarea class="form-control" name="purpose" id="purpose" style="width:350px; max-width: 350px; max-height:100px; height:80px;" rows="4" maxlength="5000"></textarea>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="attach" class="fname"><s:message code="consent.attach"/></label>
						</div>
						<div class="col-65">
						<span id="attachSpan"><input type="file" class="w100" name="attach" id="attach" style="width: 350px; border: 0px; padding: 0px; background-color: transparent"></span>
							<span id="attachNameSpan" style="display: none;">
								<a href="#" id="attachNameA" class="ellipsis" style="width: 260px; display: inline-block;"></a>
								<a href="#" id="attachNameB"></a>&nbsp;
								<button type="button" class="btn btn-default btn-xs" accesskey="M" id="attachModifyBtn"><s:message code="common.msg.modify"/></button>
								<button type="button" class="btn btn-default btn-xs" accesskey="D" id="attachDeleteBtn"><s:message code="common.msg.delete"/></button>
								<button type="button" class="btn btn-default btn-xs" accesskey="X" id="attachCancelBtn"><s:message code="common.msg.cancel"/></button>
							</span>
							<input type="hidden" id="fileDeleteYn" name="fileDeleteYn"/>
						</div>
					</div>
					<div class="row">
						<div style="margin-left:185px;">
							<div class="checkbox">
								<label class="fname" style="font-weight: 700;"><input type="checkbox" id="alarmSetup">
									<s:message code="consent.alarm.setup"/></label>
								<input type="hidden" name="alarmYn" id="alarmYn" value="N"/>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="registrantYn" class="fname"><s:message code="consent.alarm.to"/></label>
						</div>
						<div class="col-65">
							<label class="radio-inline c-radio" style="padding-left: 0px;">
								<input type="radio" name="registrantYn" value="Y" checked>
								<s:message code="consent.registrant.only"/>
							</label>
							<label class="radio-inline c-radio">
								<input type="radio" name="registrantYn" value="N">
								<s:message code="consent.approbator.all"/>
							</label>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="alarmType" class="fname"><s:message code="consent.alarm.type"/></label>
						</div>
						<div class="col-65">
							<label class="checkbox-inline " style="padding-left: 0px;">
								<input type="checkbox" name="alarmType" value="E">
								<s:message code="mail.msg"/>
							</label>
							<label class="checkbox-inline " style="padding-left: 0px;">
								<input type="checkbox" name="alarmType" value="S">
								SMS
							</label>
							<label class="checkbox-inline " style="padding-left: 0px;">
								<input type="checkbox" name="alarmType" value="M">
								</span><s:message code="mail.alert_message"/>
							</label>
							<input type="hidden" name="alarmMailYn" id="alarmMailYn" value="N"/>
							<input type="hidden" name="alarmSmsYn" id="alarmSmsYn" value="N"/>
							<input type="hidden" name="alarmMonitorYn" id="alarmMonitorYn" value="N"/>
						</div>
					</div>
				</div>
				<div class="modalfooter">

						<button type="button" class="pop_btn01" accesskey="N" id="returnBtn" style="display: none;">
							<s:message code="consent.rejected"/></button>
						<button type="button" class="pop_btn02" accesskey="R" id="cancelApproveBtn" style="display: none;"><s:message code="consent.approved.canceled"/></button>
						<button type="button" class="pop_btn02" accesskey="A" id="approveBtn" style="display: none;">
							<s:message code="consent.approved"/></button>
						&nbsp;&nbsp;
						<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal" ><s:message code="common.msg.close"/></button>
						<button type="button" class="pop_btn02 savePopBtn" accesskey="S" id="savePopBtn"><s:message code="common.msg.save"/></button>

				</div>
			</div>
		</form>
	</div>
</div>

<iframe id="upload_file" name="upload_file" src="" style="display: none;"></iframe>
<div>
	<div class="searchArea">
		<div class="searchSub">
			<div class="searchSub">
				<div id="startdatepicker"><input type="date" id="startDate" style="width: 110px;">
					<span class="hyphen">~</span></div>
				<div id="enddatepicker"><input type="date" id="endDate" style="width: 110px;"></div>

				<select id="consentType" style="float: left;">
					<option value="">- <s:message code="consent.type.consent"/> -</option>
					<option value="B"><s:message code="consent.informed.consent"/></option>
					<option value="A"><s:message code="consent.post.consent"/></option>
					<option value="M"><s:message code="consent.monitoring.consent"/></option>
					<option value="E"><s:message code="consent.retire.consent"/></option>
				</select>
				&nbsp;&nbsp;&nbsp;
				<select id="consentStatus" style="float: left; margin-left:8px;">
					<option value="all">- <s:message code="consent.status.approved"/> -</option>
					<option value=""><s:message code="consent.wait"/></option>
					<option value="A"><s:message code="consent.approved"/></option>
					<option value="R"><s:message code="consent.rejected"/></option>
					<option value="C"><s:message code="common.msg.cancel"/></option>
				</select>
				<input type="text" placeholder="<s:message code="consent.name.input"/>" id="searchStr"
				       style="width: 200px;">
				<button class="form_btn01" type="button" accesskey="Q" id="searchBtn">조회</button>
				<button type="button" class="btn01" accesskey="I" id="insertBtn"><img
						src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
			</div>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					동의서 관리 목록
					<span id="consentCount"></span>
				</button>
			</div>
			<div id="userListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
    var grid = new Xgrid('userListGrid', contextRoot);
    grid.autoNumber();
    grid.colAdd('no', '<s:message code="consent.number.consent"/>', 150, 'center', false, 'link');
    grid.colAdd('type', '<s:message code="consent.type"/>', 130, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'B') return '<s:message code="consent.informed.consent"/>';
        else if (value == 'A') return '<s:message code="consent.post.consent"/>';
        else if (value == 'M') return '<s:message code="consent.monitoring.consent"/>';
        else if (value == 'E') return '<s:message code="consent.retire.consent"/>';
    });
    grid.colAdd('appCd', '<s:message code="consent.status.approved"/>', 100, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == '') return '<s:message code="consent.wait"/>';
        else if (value == 'A') return '<s:message code="consent.approved"/>';
        else if (value == 'R') return '<s:message code="consent.rejected"/>';
        else if (value == 'C') return '<s:message code="common.msg.cancel"/>';
    });
    grid.colAdd('name', '<s:message code="common.msg.name"/>', 100, 'center', false, 'nomal');
    grid.colAdd('userId', '<s:message code="common.msg.userid"/>', 100, 'center', false, 'nomal');
    grid.colAdd('deptNm', '<s:message code="common.org.deptnm"/>', 150, 'left', false, 'nomal');
    grid.colAdd('edate', '<s:message code="consent.expiration.date"/>', 120, 'center', false, 'nomal');
    grid.colAdd('fileName', '<s:message code="consent.attach"/>', 80, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value != null) return '<img src="<c:url value="/img/icon/attach.png"/>" />';
        else return '';
    });
    grid.colAdd('createDt', '<s:message code="consent.registered.date"/>', 120, 'center', false, 'nomal');
    grid.colAdd('createNm', '<s:message code="consent.registrant"/>', 100, 'center', false, 'nomal');
    grid.colAdd('userIp', 'IP', 200, 'left', false, 'nomal');
    grid.colAdd('userEmail', 'E-Mail', 250, 'left', false, 'nomal');

    grid.onClick = function () {
        if (grid.Col == grid.ColIndex('no')) {
            $('#consentPop').attr('mode', 'modify');
            $('#consentPop').modal('show');
            $('#user').hide();

            var obj = grid.getRowData(grid.Row);
            console.log(obj);

            ui.get({
                url: 'getApprobator.xcn',
                success: function (data, total) {
                    if (data == 'N') {
                        $('#approveBtn, #returnBtn, #cancelApproveBtn').hide();
                    } else {
                        if (obj.appCd == '' || obj.appCd == 'C') {
                            $('#approveBtn, #returnBtn').show();
                            $('#cancelApproveBtn').hide();
                        } else if (obj.appCd == 'A') {
                            $('#returnBtn, #cancelApproveBtn').show();
                            $('#approveBtn').hide();
                        } else if (obj.appCd == 'R') {
                            $('#approveBtn').show();
                            $('#returnBtn, #cancelApproveBtn').hide();
                        }
                    }
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {

                }
            });

            $('#no').val(obj.no);
            $('#type').val(obj.type);
            $('#name').val(obj.name);
            $('#userId').val(obj.userId);
            $('#deptNm').val(obj.deptNm);
            $('#sdate').val(obj.createDt.substring(0, 10));
            $('#edate').val(obj.edate);
            $('#createNm').val(obj.createNm);
            $('#createId').val(obj.createId);
            $('#createDt').val(obj.createDt);
            $('#purpose').val(obj.purpose);
            $('#userIp').val(obj.userIp);
            $('#alarmYn').val(obj.alarmYn);
            if (obj.alarmYn == 'Y') {
                $('[name=registrantYn][value=' + obj.registrantYn + ']').prop('checked', true);
                $('[name=alarmType]').prop('checked', false);
                if (obj.alarmMailYn == 'Y') {
                    $('#alarmMailYn').val('Y');
                    $('[name=alarmType][value="E"]').prop('checked', true);
                }
                if (obj.alarmSmsYn == 'Y') {
                    $('#alarmSmsYn').val('Y');
                    $('[name=alarmType][value="S"]').prop('checked', true);
                }
                if (obj.alarmMonitorYn == 'Y') {
                    $('#alarmMonitorYn').val('Y');
                    $('[name=alarmType][value="M"]').prop('checked', true);
                }
                $('#alarmSetup').prop('checked', true).change();
            } else {
                $('#alarmSetup').prop('checked', false).change();
                $('[name=registrantYn][value=Y]').prop('checked', true);
                $('[name=alarmType]').prop('checked', false);
            }
            if (obj.attachedYn == 'Y') {
                $('#attachSpan').hide();
                $('#attachNameA').html(obj.fileName);
                $('#attachNameA').attr('title', obj.fileName);
                $('#attachNameSpan').show();

                $('#attachCancelBtn').click();
            } else {
                $('#attachSpan').html('<input type="file" class="w100" name="attach" id="attach" style="width: 350px; border: 0px; padding: 0px; background-color: transparent">').show();
                $('#attachNameSpan').hide();
            }
        }
    };

    grid.onDblClick = function () {
        if (grid.Col == grid.ColIndex('attachedYn')) {
            var no = grid.getValue(grid.Row, 'no');
            var href = '<c:url value="/downloadConsentFile.do"/>?no=' + no;
            ui.on('consentPop');
            $.fileDownload(href, {
                successCallback: function (url) {
                    ui.off('consentPop');
                },
                failCallback: function (responseHtml, url) {
                    ui.off('consentPop');
                    ui.alertMsg('<s:message code="consent.error.file"/>');
                }
            });
        }
    };
    grid.loadExportMenu('<s:message code="DATA_MONITOR.CONSENT_MGMT"/>');
    grid.loadPageSize();
    grid.loadHeader(false);
    grid.initData('<s:message code="common.msg.search.click"/>');
    grid.changePageSize = function (cnt) {
        getData();
    };
</script>
