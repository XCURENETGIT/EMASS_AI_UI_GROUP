<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/popupScript.jsp" %>

<head>
	<style>
		/*html, body, .xcn_container {*/
		/*	height: 100%;*/
		/*	padding: 0px;*/
		/*	margin: 0px;*/
		/*	overflow: auto;*/
		/*	min-width: 650px;*/
		/*}*/
	</style>
	<script>
        $(document).ready(function () {
            $('#searchBtn').click(function () {
                getDeviceList();
            });
            $('#searchStr').enter(function () {
                getDeviceList();
            });
            $('#noSelectBtn').click(function () {
                self.close();
            });

            $('#devStatusBtn').click(function () {
                var rows = grid.getSelectedRows();
                if (rows.length == 0) {
                    ui.alertMsg('<s:message code="selectDevStatus.msg.select.device"/>');
                    return;
                }

                ui.confirmMsg('<s:message code="selectDevStatus.msg.ruleapply"/>', '', '', function (rs) {
                    if (rs) {
                        grid.on();
                        ui.get({
                            url: 'ruleApplyIpFilter.xcn',
                            devData: JSON.stringify(rows),
                            success: function (data, total) {
                                alert('<s:message code="selectDevStatus.msg.success.rule"/>');
                                getDeviceList();
                            },
                            error: function (status, message) {
                                ui.alertMsg(message);
                                getDeviceList();
                            },
                            complete: function () {
                                grid.off();
                            }
                        });

                    } else {
                        $('#devStatusBtn').prop('disabled', false);
                    }
                });
            });

            getDeviceList();
        });

        function getDeviceList() {
            var searchStr = $('#searchStr').val();
            grid.on();
            ui.get({
                url: 'getCollectionDevice.xcn',
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
	</script>

</head>
<div class="xcn_container" id="popupWrap">
	<div class="item">
		<h3 class="blue"><span class="bullet01"></span></span><s:message code="selectDevStatus.device.status"/></h3>
		<div class="grayBg mat8 popupInner">
			<div>
				<input type="text" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr"
				       style="width: 250px;">
				<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.search"/></button>
				<button type="button" class="form_btn06" accesskey="R" id="devStatusBtn"><s:message
						code="selectDevStatus.ruleapply"/>
				</button>
			</div>
		</div>

		<div class="pop_tableArea mat16">
			<div id="selectInterestUser" class="slickGrid gridArea"
			     style="height: 500px;"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
    var grid = new Xgrid('selectInterestUser', contextRoot);
    grid.onCheckBox();
    grid.autoNumber();
    grid.colAdd('deviceType', '<s:message code="selectDevStatus.type.device"/>', 100, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'A') return '<s:message code="selectDevStatus.dev.integrated"/>';
        else if (value == 'C') return '<s:message code="selectDevStatus.dev.logging"/>';
        else if (value == 'L') return '<s:message code="selectDevStatus.dev.analysis"/>';
        else return '<s:message code="selectDevStatus.dev.database"/>'
    });
    grid.colAdd('deviceIp', '<s:message code="selectDevStatus.devip"/>', 120, 'left', false, 'nomal');
    grid.colAdd('deviceNm', '<s:message code="selectDevStatus.devnm"/>', 200, 'left', false, 'nomal');
    grid.colAdd('ruleVersion', '<s:message code="selectDevStatus.ruleversion"/>', 100, 'center', false, 'nomal');
    grid.colAdd('ruleDate', '<s:message code="selectDevStatus.ruletime"/>', 180, 'center', false, 'nomal');
    grid.colAdd('createDt', '<s:message code="selectDevStatus.createDt"/>', 150, 'center', false, 'nomal');
    grid.onClick = function () {
        if (grid.Col == grid.ColIndex('userId')) {
            ui.confirmMsg('<s:message code="interest.msg.confirm.save"/>', '', '', function (rs) {
                if (rs) {
                    grid.on();

                    var obj = grid.getRowData(grid.Row);

                    ui.get({
                        url: 'insertInterestUser.xcn',
                        userType: 'E',
                        userNm: obj.userNm,
                        userId: obj.userId,
                        userIp: obj.userIp,
                        userEmail: obj.userEmail,
                        comment: '<s:message code="common.org.dept"/>: ' + obj.deptNm + ', <s:message code="common.org.jikgub"/>: ' + obj.jikgubNm,
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            self.close();
                            opener.getData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            grid.off();
                        }
                    });
                }
            });
            /* else {
				opener.selectedUserInfo( grid.getRowData( grid.Row ) );
				self.close();
			} */
        }
    };
    grid.loadHeader(false);
    grid.initData('<s:message code="common.msg.search.click"/>');
</script>
