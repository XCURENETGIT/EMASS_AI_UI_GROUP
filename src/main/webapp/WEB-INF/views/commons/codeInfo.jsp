<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<style>
	.radio input {
		vertical-align: middle;
	}
	.tab-content {
		display: none;

	}

	.tab-content.active {
		display: inherit;
	}
</style>

<script>
    var searchFlag = false;
    $(document).ready(function () {

        $('#export_menu').hide();
        $('#export_menu2').css('display', '');

        $('#searchBtn').click(function () {
            getData();
        });

	    $('.serviceList').click(function () {
		    var message = '<s:message code="common.msg.confirm.modify"/>';
			var type = $(this).val();
		    ui.confirmMsg(message, '', '', function (rs) {
			    if (rs) {
				    var rows = gridService.getSelectedRows();;
				    ui.get({
					    url: 'updateServiceListUseYn.xcn',
					    type : type,
					    serviceData: JSON.stringify(rows),
					    success: function (data, total) {
						    getData();
					    },
					    error: function (status, message) {

					    },
					    complete: function () {

					    }

				    });
			    }
		    })
	    });

        $('#searchStrInput').keypress(function (e) {
            if (e.which == 13) {
                getData();
            }
        });
        $(".nav-tabs a").click(function () {
            $('#export_menu').hide();
            $('#export_menu2').hide();

            $('#searchStrInput').val('');
            currentTab = $(this).attr('id');
            var options = getAttachOptions();
            if (currentTab == 'attachTab') {
                $('#export_menu').css('display', '');
                $('#searchStrInput').attr('placeholder', '<s:message code="codeInfo.msg.enter.ext"/>');
                var str = '<select class="form-control input-sm" id="attachName" name="attachName">';
                str += options;
                str += '</select>';
                $("#attachPopSelectDiv").html(str);
                $('#useYnDiv').css('display', 'none');
                $('#insertBtn').css('display', '');
                $('#deleteBtn').css('display', '');
                $('#useBtn').css('display', 'none');
                $('#unuseBtn').css('display', 'none');
            } else if (currentTab == 'serviceTab') {
                $('#export_menu2').css('display', '');
                $('#searchStrInput').attr('placeholder', '<s:message code="codeInfo.msg.enter.svc"/>');
                $('#useYnDiv').css('display', '');
                $('#insertBtn').css('display', 'none');
                $('#deleteBtn').css('display', 'none');
	            $('#useBtn').css('display', '');
	            $('#unuseBtn').css('display', '');
            } else {
                $('#useYnDiv').css('display', 'none');
                $('#insertBtn').css('display', '');
                $('#deleteBtn').css('display', '');
            }
            getData();
        });
        $('.savePopBtn').click(function () {
            $('.savePopBtn').prop('disabled', true);
            var attachName = $('#attachName option:selected').val();
            var attachType = $('#attachType').val().ltrim().rtrim();
            if (attachName == '') {
                ui.alertMsg('<s:message code="codeInfo.select.attachname.enter"/>');
                $('.savePopBtn').prop('disabled', false);
                return;
            }
            if (attachType == '') {
                ui.alertMsg('<s:message code="codeInfo.select.attachtype.enter"/>');
                $('.savePopBtn').prop('disabled', false);
                return;
            }
            var mode = $('#attachPop').attr('mode');

            var message = mode == 'insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
            ui.confirmMsg(message, '', '', function (rs) {
                if (rs) {
                    gridAttach.on();
                    ui.post({
                        url: mode == 'insert' ? 'insertAttachType.xcn' : 'updateAttachType.xcn',
                        data: $('#attachPopForm').serializeAll(),
                        success: function (data, total) {

                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            $('#attachPop').modal('hide');
                            getData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            gridAttach.off();
                            $('.savePopBtn').prop('disabled', false);
                        }

                    });
                } else {
                    $('.savePopBtn').prop('disabled', false);
                }

            });
        });

        $('.servicePopBtn').click(function () {
            $('.servicePopBtn').prop('disabled', true);
            var message = '<s:message code="common.msg.confirm.modify"/>';
            ui.confirmMsg(message, '', '', function (rs) {
                if (rs) {
                    gridService.on();
                    ui.post({
                        url: 'updateServiceUseYn.xcn',
                        data: $('#servicePopForm').serializeAll(),
                        success: function (data, total) {

                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            $('#servicePop').modal('hide');
                            getData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            gridService.off();
                            $('.servicePopBtn').prop('disabled', false);
                        }

                    });
                } else {
                    $('.servicePopBtn').prop('disabled', false);
                }

            });
        });
        $('#insertBtn').click(function () {
            var options = getAttachOptions();
            var str = '<select class="form-control input-sm" id="attachName" name="attachName">';
            str += options;
            str += '</select>';
            $("#attachPopSelectDiv").html(str);
            $('#attachType').prop("disabled", false);
            $('#attachPop').attr('mode', 'insert');
            $("#attachPop").modal();

            setTimeout(function () {
                $('#attachName').val('');
                $('#attachType, #attachDesc').val('');
                $('#attachName').focus();
            }, 500);
        });

        $('#deleteBtn').click(function () {
            $('#deleteBtn').prop('disabled', true);

            var rows = gridAttach.getSelectedRows();
            if (rows.length == 0) {
                ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                $('#deleteBtn').prop('disabled', false);
                return;
            }

            ui.confirmMsg('<s:message code="filterInfo.msg.confirm.deleteitem"/>', '', '', function (rs) {
                if (rs) {
                    gridAttach.on();
                    ui.get({
                        url: 'deleteAttachType.xcn',
                        deleteData: JSON.stringify(rows),
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.deleted"/>');
                            getData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            $('#deleteBtn').prop('disabled', false);
                            gridAttach.off();
                        }
                    });

                } else {
                    $('#deleteBtn').prop('disabled', false);
                }
            });
        });
        getData();

    });
    var currentTab;

    function getCurrentTab() {
        return currentTab == null ? 'serviceTab' : currentTab;
    }

    function getData(flag) {
        if (searchFlag) return;
        var grid = getCurrentGrid();
        searchFlag = true;
        grid.on();
        ui.get({
            url: getCurrentSearchUrl(),
            searchStr: $('#searchStrInput').val(),
            searchUseYn: $('#useYnSelect').val(),
            success: function (data, total) {
                if (flag == 'Y' || flag == undefined) resultTotal = total;
                grid.setData(data);
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
                grid.off();
                searchFlag = false;
            }
        });
    }

    function getAttachOptions() {
        var result = '';
        ui.get({
            url: 'getAttachType.xcn',
            asyncFlag: false,
            searchStr: '',
            success: function (data, total) {
                result += '<option value="">-<s:message code="codeInfo.select.attachname"/>-</option>';
                for (var i = 0; i < data.length; i++) {
                    result += '<option value="' + data[i].attachName + '">' + data[i].attachName + '</option>';
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

    function getCurrentSearchUrl() {
        var tab = getCurrentTab();
        if (tab == 'attachTab') return 'getAttachTypeList.xcn';
        else if (tab == 'serviceTab') return 'getServiceListByAll.xcn';
        else if (tab == 'patternTab') return '/';
        else return null;
    }

    function getCurrentGrid() {
        var tab = getCurrentTab();
        if (tab == 'attachTab') return gridAttach;
        else if (tab == 'serviceTab') return gridService;
        else if (tab == 'patternTab') return gridPattern;
        else return null;
    }
</script>


<div class="modal" id="servicePop" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="servicePopForm">
			<div class="modalHead">
				<h2><s:message code="filterInfo.service"/> <s:message code="common.msg.useyn"/>-<s:message code="common.msg.modify"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="filterInfo.service"/> <s:message code="common.msg.useyn"/>-<s:message code="common.msg.modify"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="groupNm" class="fname"><s:message code="filterInfo.serviceSeparate"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="groupNm" id="groupNm" maxlength="60" disabled>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="serviceNm" class="fname"><s:message code="condition.service"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="serviceNm" id="serviceNm" maxlength="60" disabled>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="serviceCd" class="fname"><s:message code="condition.service.code"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="serviceCd" id="serviceCd" maxlength="60" disabled>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="useYn" class="fname"><s:message code="common.msg.useyn"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<div class="radio">
								<input type="radio" name="useYn" value="Y" checked>
								<span><s:message code="common.msg.use"/></span>
							</div>
							<div class="radio">
								<input type="radio" name="useYn" value="N">
								<span><s:message code="common.msg.unuse"/></span>
							</div>
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 servicePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>

<div class="modal" id="attachPop" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="attachPopForm">
			<div class="modalHead">
				<h2><s:message code="codeInfo.attachpop.title"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="codeInfo.attachpop.title"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="attachPopSelectDiv" class="fname"><s:message
									code="condition.attach_type"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<div class="w100" id="attachPopSelectDiv">
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="attachType" class="fname"><s:message code="codeInfo.attchext"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="attachType" id="attachType" placeholder="<s:message code="codeInfo.attchext"/>" maxlength="10">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="attachDesc" class="fname"><s:message code="codeInfo.attachcomment"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="attachDesc" id="attachDesc" placeholder="<s:message code="codeInfo.attachcomment"/>" maxlength="300">
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" accesskey="C" class="pop_btn01" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" accesskey="S" class="pop_btn02 savePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>

<div>
	<div class="searchArea">
		<div class="searchSub">
			<div id="useYnDiv">
				<select id="useYnSelect">
					<option value=""><s:message code="common.msg.all"/></option>
					<option value="Y" selected><s:message code="common.msg.use"/></option>
					<option value="N"><s:message code="common.msg.unuse"/></option>
				</select>
			</div>
			<input type="text" placeholder="<s:message code="codeInfo.msg.enter.svc"/>" id="searchStrInput" style="width: 250px;">
			<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.search"/></button>
			<button class="btn01 serviceList" type="button" accesskey="Q" id="useBtn" value="Y"><img src="<c:url value="/img/subBtn_refresh.png"/>" alt="사용"><s:message code="common.msg.use"/></button>
			<button class="btn01 serviceList" type="button" accesskey="Q" id="unuseBtn" value="N"><img src="<c:url value="/img/subBtn_refresh.png"/>" alt="미사용"><s:message code="common.msg.unuse"/></button>
				<button type="button" class="btn01" accesskey="I" id="insertBtn" style="display: none;"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
				<button type="button" class="btn02" accesskey="D" id="deleteBtn" style="display: none;"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
			</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<ul class="nav-tabs">
					<li class="active" style=" text-align: center"><a data-toggle="tab" href="#serviceList" id="serviceTab" class="coTabClass"><s:message code="condition.service"/></a></li>
					<li style="text-align: center"><a data-toggle="tab" href="#attachList" id="attachTab"><s:message code="codeInfo.filetype"/></a></li>
				</ul>
			</div>
			<div id="attachList" class="tab-content" style="height:100%;">
				<div id="attachListGrid" class="slickGrid gridArea"></div>
			</div>
			<div id="serviceList" class="tab-content active" style="height:100%;">
				<div id="serviceListGrid" class="slickGrid gridArea"></div>
			</div>
			<div id="patternList" class="tab-content" style="height:100%;">
				<div id="patternListGrid" class="slickGrid gridArea"></div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
    var gridAttach = new Xgrid('attachListGrid', contextRoot);
    gridAttach.onCheckBox();
    gridAttach.autoNumber();
    gridAttach.colAdd('attachType', '<s:message code="common.msg.ext"/>', 120, 'center', false, 'nomal');
    gridAttach.colAdd('attachName', '<s:message code="common.msg.type"/>', 200, 'center', false, 'nomal');
    gridAttach.colAdd('attachDesc', '<s:message code="common.msg.comment"/>', 250, 'left', false, 'nomal');
    gridAttach.onClick = function () {
        return;
        if (gridAttach.Col == gridAttach.ColIndex('attachType')) {
            var options = getAttachOptions();
            var str = '<select class="form-control input-sm" id="attachName" name="attachName">';
            str += options;
            str += '</select>';
            $("#attachPopSelectDiv").html(str);
            $('#attachType').prop("disabled", true);
            $('#attachPop').attr('mode', 'modify');
            $('#attachPop').modal('show');
            $("#attachPop").on('shown.bs.modal', function () {
                $('#attachName').val(gridAttach.getValue(gridAttach.Row, 'attachName'));
                $('#attachType').val(gridAttach.getValue(gridAttach.Row, 'attachType'));
                $('#attachDesc').val(gridAttach.getValue(gridAttach.Row, 'attachDesc'));
                $('#attachType').focus();
            });
        }
    };
    gridAttach.loadExportMenu('<s:message code="OPERATION_MGMT.CODE_INFO"/>');
    gridAttach.loadHeader(true);
    gridAttach.initData('<s:message code="common.msg.search.click"/>');

    var gridService = new Xgrid('serviceListGrid', contextRoot);
    gridService.autoNumber();
    gridService.onCheckBox();
    gridService.colAdd('groupNm', '<s:message code="filterInfo.serviceSeparate"/>', 150, 'center', false, 'nomal');
    gridService.colAdd('serviceNm', '<s:message code="condition.service"/>', 170, 'left', false, 'nomal');
    gridService.colAdd('serviceCd', '<s:message code="condition.service.code"/>', 90, 'center', false, 'nomal');
    gridService.colAdd('useYn', '<s:message code="common.msg.useyn"/>', 120, 'center', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value == 'Y') return '<s:message code="common.msg.use"/>';
        else if (value == 'N') return '<s:message code="common.msg.unuse"/>';
        return '-';
    });
    gridService.onClick = function () {
        if (gridService.Col == gridService.ColIndex('useYn')) {
            var data = gridService.getRowData(gridService.Row);

            $('#groupCd').val(data.groupCd);
            $('#groupNm').val(data.groupNm);
            $('#serviceNm').val(data.serviceNm);
            $('#serviceCd').val(data.serviceCd);
            $('[name=useYn][value=' + data.useYn + ']').prop('checked', true);

            $('#servicePop').attr('mode', 'modify');
            $('#servicePop').modal('show');
        }
    }
    gridService.loadExportMenu('<s:message code="OPERATION_MGMT.CODE_INFO"/>');
    gridService.loadHeader(true);
    gridService.initData('<s:message code="common.msg.search.click"/>');
</script>
