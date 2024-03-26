<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<%
	String dashKey = Common.nvl(request.getParameter("dashKey"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title></title>
	<style>
		input[type="checkbox"] {
			margin-top: 5px;
		}
		html, body {
			height: 100%;
			padding: 0px;
			margin: 0px;
			overflow: auto;
			min-width: 900px;
		}

		.panel {
			margin-bottom: 0px !important;
		}
	</style>
	<script>
        var dashKey = '<%=dashKey%>';

        $(document).ready(function () {

            $(document).bind("contextmenu", function (e) {
                return false;
            });

            if ($('#busiCd').css('display') == 'none') $('#searchStr').css('width', '250px');

            $('#addBtn').click(function () {
                setSelectedData();
            });
            $('#removeBtn').click(function () {
                grid2.deleteSelectedRows();
            });
            $('#searchBtn').click(function () {
                getCodeList();
            });
            $('#searchStr').enter(function () {
                getCodeList();
            });
            $('#closeSelectBtn').click(function () {
                self.close();
            });

            $('#selectBtn').click(function () {
                if (grid2.getData().length == 0) {
                    alert('<s:message code="common.msg.noselect"/>');
                    return;
                }
                opener.insertDashboardShare(grid2.getKeyData('adminId'), $('#oldAdminList').val());
                self.close();
            });

            $('#noSelectBtn').click(function () {
                var checkMsg = '';
                if (grid2.getKeyData('adminId').length == 0) {
                    checkMsg = '<s:message code="selectAdmin.noselect.confirm"/>';
                } else {
                    checkMsg = '<s:message code="selectAdmin.noselect.confirm2"/>';
                }
                ui.confirmMsg(checkMsg, '', '', function (rs) {
                    if (rs) {
                        opener.insertDashboardShare([], $('#oldAdminList').val());
                        self.close();
                    }
                });
            });

            getCodeList();
            getShareAdmin();
        });

        function setSelectedData() {
            var selectedData = grid2.getData();
            var selectData = grid.getSelectedRows();
            var data = [];
            for (var i = 0, total = selectData.length; i < total; i++) {
                var flag = true;
                for (var j = 0, cnt = selectedData.length; j < cnt; j++) {
                    if (selectData[i].adminId == selectedData[j].adminId) {
                        flag = false;
                        break;
                    }
                }
                if (flag) {
                    data.push({
                        'adminId': selectData[i].adminId,
                        'adminName': selectData[i].adminName,
                        'adminType': selectData[i].adminType,
                        'adminEmail': selectData[i].adminEmail,
                        'adminHp': selectData[i].adminHp,
                        'useYn': selectData[i].useYn,
                        'status': selectData[i].status,
                        'workStatus': selectData[i].workStatus
                    });
                }
            }
            if (data.length > 300 || (selectData.length + selectedData.length) > 300) {
                alert('<s:message code="selectCodeAll.select.max"/>');
                return;
            }
            grid2.appendData(data);
        }

        function getCodeList() {
            var searchStr = $('#searchStr').val();
            ui.get({
                url: 'getAdminList.xcn',
                searchStr: searchStr,
                success: function (data, total) {
                    grid.setData(data);
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

        function getShareAdmin() {

            ui.get({
                url: "getShareAdmin.xcn",
                dashKey: dashKey,
                success: function (data, total) {
                    var oldAdmin = [];
                    data.forEach(function (rs) {
                        oldAdmin.push(rs.adminId);
                    });
                    $('#oldAdminList').val(oldAdmin);
                    grid2.setData(data);
                },
                error: function (status, message) {

                },
                complete: function () {

                }
            });
        }
	</script>

</head>
<body class="mini-navbar msgBody">

<div class="modal fade" id="holidayPop" tabindex="-1" role="dialog" aria-labelledby="holidayModal">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<form method="post" id="holidayPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="common.org.choose.co"/></h3>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label for="attachTypePopInput" class=""><s:message code="selectCodeAll.date"/></label>
						<div class='input-group date' id='datePicker'>
							<input type='text' class="input-sm form-control" id='date'/>
							<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
								</span>
						</div>
					</div>
					<div class="form-group">
						<label for="attachDescPopInput" class=""><s:message code="common.msg.comment"/></label>
						<input type="text" class="form-control" name="comment" id="comment" placeholder="<s:message code="common.msg.comment"/>"
						       required>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="savePopBtn"><s:message
							code="common.msg.save"/></button>
				</div>
			</form>
		</div>
	</div>
</div>

<!--popup-->
<div id="popupWrap" class="xcn_container">
	<!-- left -->
	<div class="row">
		<div class="item" style="width: calc(50% - 30px);float: left;">
			<h3 class="blue"><span class="bullet01"></span><s:message code="selectCodeAll.list"/></h3>
			<div class="grayBg mat8 popupInner">
				<div>
					<input type="text" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr">
					<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.msg.search"/></button>
				</div>
			</div>
			<!-- 테이블 -->
			<div class="pop_tableArea mat16">
				<!-- 테이블 -->
				<div id="coCdGrid" class="subTable slickGrid gridArea" style="height: calc(100% - 150px)"></div>
			</div>
		</div>
		<div class="item" style="width: 60px;float: left;height: 100%;padding-top: 20%;">
			<button class="pop_btn03 dis_block" type="button" accesskey="I" id="addBtn">
				<img src="<c:url value="/img/ico_double_left.png"/>" alt=">>">
			</button>
			<button class="pop_btn03 dis_block mat8" type="button" accesskey="D" id="removeBtn">
				<img src="<c:url value="/img/ico_double_right.png"/>" alt="<<">
			</button>
		</div>
		<div class="item" style="width: calc(50% - 30px);float: left;">
			<h3 class="blue"><span class="bullet01"></span><s:message code="selectCodeAll.selected.list"/></h3>
			<div class="grayBg mat8 popupInner">
				<div class="txt_right">
					<button class="form_btn03" accesskey="Y" id="selectBtn"><s:message code="common.msg.select"/></button>
					<button class="form_btn04" accesskey="N" id="closeSelectBtn"><s:message code="selectCodeAll.noselect"/></button>
				</div>
			</div>
			<!-- 테이블 -->
			<div class="pop_tableArea mat16">
				<div id="coCdGrid2" class="subTable slickGrid gridArea" style="height: calc(100% - 150px)"></div>
			</div>
		</div>
	</div>
</div>

<%--<div class="xcn_container" style="min-width: 500px" id="popupWrap">--%>
<%--	<div class="content_body">--%>
<%--		<div class="row">--%>
<%--			<div class="item" style="width: calc(50% - 30px);float: left;">--%>
<%--				<h3 class="blue"><span class="bullet01"></span><s:message code="selectCodeAll.list"/></h3>--%>
<%--				<div class="grayBg mat8 popupInner">--%>
<%--						<div class="tab-pane fade in active" id="result1">--%>
<%--							<div class="resultHeader">--%>
<%--								<div class="form-inline">--%>
<%--									<select class="form-control input-sm" id="busiCd" name="busiCd" style="display: none;max-width:155px;">--%>
<%--										<option value="">- <s:message code="selectCodeAll.select.type.service"/> -</option>--%>
<%--									</select>--%>
<%--									<div class="input-group">--%>
<%--										<input type="text" class="form-control input-sm" placeholder="<s:message code="admin.msg.idname"/>"--%>
<%--										       id="searchStr" style="width: 180px;">--%>
<%--										<div class="input-group-btn">--%>
<%--											<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i--%>
<%--													class="glyphicon glyphicon-search"></i></button>--%>
<%--										</div>--%>
<%--									</div>--%>
<%--								</div>--%>
<%--							</div>--%>
<%--							<div class="resultBody top_space" style="height: 100%;">--%>
<%--								<div id="coCdGrid" class="slickGrid gridArea"></div>--%>
<%--							</div>--%>
<%--						</div>--%>
<%--					</div>--%>
<%--		</div>--%>
<%--		<div style="width: 40px; float: left; height: 100%">--%>
<%--			<div style="position: relative; top: 45%; left: 3px;">--%>
<%--				<button class="btn btn-sm btn-primary" type="button" accesskey="I" id="addBtn"><i class="glyphicon glyphicon-arrow-right"></i>--%>
<%--				</button>--%>
<%--				<br/><br/>--%>
<%--				<button class="btn btn-sm btn-primary" type="button" accesskey="D" id="removeBtn"><i class="glyphicon glyphicon-arrow-left"></i>--%>
<%--				</button>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--		<div style="width: calc(50% - 25px); float: left; height: 100%">--%>
<%--			<div class="panel with-nav-tabs panel-primary" style="height: 100%;">--%>
<%--				<div class="panel-body">--%>
<%--					<div class="tab-content" style="height:calc(100% - 40px);">--%>
<%--						<div class="tab-pane fade in active" id="result1">--%>
<%--							<div class="resultHeader">--%>
<%--								<div class="form-inline text-right">--%>
<%--									<div class="input-group">--%>
<%--										<button type="button" class="btn btn-sm btn-primary" accesskey="Y" id="selectBtn"><span--%>
<%--												class="glyphicon glyphicon-ok"></span>&nbsp;<s:message code="common.msg.select"/></button>--%>
<%--									</div>--%>
<%--									<div class="input-group">--%>
<%--										<button type="button" class="btn btn-sm btn-default" accesskey="N" id="noSelectBtn"><span--%>
<%--												class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="selectCodeAll.noselect"/></button>--%>
<%--									</div>--%>
<%--									<div class="input-group">--%>
<%--										<button type="button" class="btn btn-sm btn-default" accesskey="C" id="closeSelectBtn"><span--%>
<%--												class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>--%>
<%--									</div>--%>
<%--								</div>--%>
<%--							</div>--%>
<%--							<div class="resultBody top_space" style="height: 100%;">--%>
<%--								<div id="coCdGrid2" class="slickGrid gridArea"></div>--%>
<%--							</div>--%>
<%--						</div>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--	</div>--%>
<%--</div>--%>
<div class="resultBody top_space" style="height: 100%;">
	<input type="text" class="form-control input-sm" id="oldAdminList" hidden>
</div>

<script type="text/javascript">
    var grid = new Xgrid('coCdGrid', contextRoot);
    grid.setDrag(true);
    grid.onCheckBox();
    grid.autoNumber();
    grid.colAdd('adminId', '<s:message code="common.msg.id"/>', 130, 'left', false, 'link');
    grid.colAdd('adminName', '<s:message code="common.msg.name"/>', 130, 'left', false, 'nomal');
    grid.colAdd('adminType', '<s:message code="common.msg.type"/>', 130, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'S') return '<s:message code="admin.system.admin"/>';
        else return '<s:message code="admin.monitoring.admin"/>';
    });
    grid.colAdd('adminEmail', 'E-mail', 180, 'left', false, 'nomal');
    grid.colAdd('adminHp', 'HP', 150, 'left', false, 'nomal');
    grid.colAdd('useYn', '<s:message code="common.msg.useyn"/>', 100, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'Y') return '<s:message code="common.msg.use"/>';
        else if (value == 'N') return '<s:message code="common.msg.unuse"/>';
        return '-';
    });
    grid.colAdd('status', '<s:message code="admin.reference"/>', 150, 'left', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value == 'L') return '<s:message code="admin.msg.longterm"/>';
        return '';
    });
    grid.colAdd('workStatus', '<s:message code="common.msg.retirement"/>/<s:message code="common.msg.leave"/>', 90, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'R') return '<s:message code="common.msg.retirement"/>';
        else if (value == 'O') return '<s:message code="common.msg.leave"/>';
        else return '';
    });

    grid.onClick = function () {
        if (grid.Col == grid.ColIndex('adminId')) {
            setSelectedData();
        }
    };
    grid.onContextMenu = function () {
        setSelectedData();
    };

    grid.loadHeader(false);
    grid.initData('<s:message code="selectCodeAll.select.code"/>')
    grid.onDragStart = function (e, dd) {
        $('#coCdGrid2').css('border', '2px solid #FFA040');
    };
    grid.onDragEnd = function (e, dd) {
        if ($(e.target).parent().parent().attr('id') == 'coCdGrid2') {
            setSelectedData();
        }
        $('#coCdGrid2').css('border', 'border: 1px solid #EFEFEF;border-top: 2px solid #7A7A7A;');
    };

    var options = {};
    options.status_cnt_id = '#total_cnt2';
    options.status_cnt_ing_name = '<s:message code="selectCodeAll.cnt.select"/>';
    options.status_cnt_end_name = '<s:message code="selectCodeAll.cnt.select"/>';
    var grid2 = new Xgrid('coCdGrid2', contextRoot, 26, options);
    grid2.onCheckBox();
    //grid2.autoNumber();

    grid2.colAdd('adminId', '<s:message code="common.msg.id"/>', 130, 'left', false, 'link');
    grid2.colAdd('adminName', '<s:message code="common.msg.name"/>', 130, 'left', false, 'nomal');
    grid2.colAdd('adminType', '<s:message code="common.msg.type"/>', 130, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'S') return '<s:message code="admin.system.admin"/>';
        else return '<s:message code="admin.monitoring.admin"/>';
    });
    grid2.colAdd('adminEmail', 'E-mail', 180, 'left', false, 'nomal');
    grid2.colAdd('adminHp', 'HP', 150, 'left', false, 'nomal');
    grid2.colAdd('useYn', '<s:message code="common.msg.useyn"/>', 100, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'Y') return '<s:message code="common.msg.use"/>';
        else if (value == 'N') return '<s:message code="common.msg.unuse"/>';
        return '-';
    });
    grid2.colAdd('status', '<s:message code="admin.reference"/>', 150, 'left', false, 'link', function (row, cell, value, columnDef, dataContext) {
        if (value == 'L') return '<s:message code="admin.msg.longterm"/>';
        return '';
    });
    grid2.colAdd('workStatus', '<s:message code="common.msg.retirement"/>/<s:message code="common.msg.leave"/>', 90, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'R') return '<s:message code="common.msg.retirement"/>';
        else if (value == 'O') return '<s:message code="common.msg.leave"/>';
        else return '';
    });

    grid2.onContextMenu = function () {
        grid2.deleteSelectedRows();
    };
    grid2.onClick = function () {
        if (grid2.Col == grid2.ColIndex('adminId')) {
            grid2.deleteSelectedRows();
        }
    };
    grid2.loadHeader(false);
    grid2.initData('<s:message code="selectCodeAll.select.code"/>');
</script>
</body>
</html>