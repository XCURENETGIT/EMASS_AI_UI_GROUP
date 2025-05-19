<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title></title>
	<style type="text/css">
		.bootstrap-select {
			width: auto;
		}

		#selectedCodeTitle {
			display: none;
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

	</style>
	<script type="text/javascript">
        var adminId2 = '${_USERCREDENTIAL_.adminId}';
        var searchFlag = false;

        $(document).ready(function () {

	        initDateTimePicker('startDt','endDt');
	        $('#startDt').val(new Date().format('yyyy-mm-dd'));
	        $('#endDt').val(new Date().format('yyyy-mm-dd'));


	        $('#searchBtn').click(function () {
                getData();
            });
            $('#adminId').change(function () {
                getData();
            });

            $("#adminId").html(getAdminOptions());

    /*        getData();*/
        });

        function getData(lastRow) {
            if (searchFlag) return;

            var pDate = '';
            var pAdminId = '';
            var pSeq = '';

            if (lastRow == undefined) {
                grid.data.length = 0;
                grid.rtnNextPageFunc = getData;
                grid.loadingPage = 0;
            } else {
                grid.loadingPage++;
                pDate = lastRow.pdate;
                pAdminId = lastRow.adminId;
                pSeq = lastRow.seq;
            }

            var startDt = $('#startDt').val().replaceAll("-", "");
            var endDt = $('#endDt').val().replaceAll("-", "");
            var adminId = $("#adminId").val();
            var searchType = $("#searchType").val();

            if (startDt > endDt) ui.alertMsg('<s:message code="blockHistoryNonBusi.msg.cannot.startendtime"/>');

            grid.on();
            searchFlag = true;
            ui.get({
                url: 'getSearchLogList.xcn',
                startDt: startDt,
                endDt: endDt,
                adminId: adminId,
                searchType: searchType,
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

        function getAdminOptions() {

            var result = '';

            if (firstAdminYn == 'Y') result += '<option value="">- <s:message code="auditLog.select.admin"/> -</option>';
            ui.get({
                url: 'getAdminList.xcn',
                adminId: adminId,
                firstAdminYn: firstAdminYn,
                adminType: adminType,
                asyncFlag: false,
                success: function (data, total) {
                    for (var i = 0; i < data.length; i++) {
                        result += '<option value="' + data[i].adminId + '">' + data[i].adminName + ' (' + data[i].adminId + ')</option>';
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
	</script>
</head>


<div>
	<div class="searchArea">
		<div class="searchSub">
			<div><input type="text" id="startDt" style="width: 110px;" class="txt_center" />
				<span class="hyphen">~</span></div>
			<div><input type="text" id="endDt" style="width: 110px;" class="txt_center" /></div>
			<div>
				<select id="searchType" style="max-width: 200px;">
					<option value="">- <s:message code="searchLog.consent.type"/> -</option>
					<option value="Y"><s:message code="searchLog.consent.assigned"/></option>
					<option value="N"><s:message code="searchLog.consent.unassigned"/></option>
				</select>
			</div>
			<div>
				<select style="width: 200px;"  id="adminId">
					<option value="">- <s:message code="auditLog.select.admin"/> -</option>
				</select>
			</div>
			<div>
				<button type="button" accesskey="Q" class="form_btn01" id="searchBtn"><s:message code="common.search"/></button>
			</div>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					<s:message code="auditLog.select.admin"/> <s:message code="selectCodeAll.list"/>
					<span id="saerchLogCount"></span>
				</button>
			</div>
			<div id="searchLogListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>
</div>


<script type="text/javascript">
    var grid = new Xgrid('searchLogListGrid', contextRoot);

    var conditions = "";
    var consentStr = "";
    var openWindow;
    grid.autoNumber();
    grid.colAdd('searchDt', '<s:message code="auditLog.worktime"/>', 150, 'center', false, 'link');
    grid.colAdd('searchName', '<s:message code="auditLog.adminid"/>', 120, 'center', false, 'nomal');
    grid.colAdd('consentNo', '<s:message code="consent.number.consent"/>', 150, 'center', false, 'nomal');
    grid.colAdd('searchType', '<s:message code="consent.consent.useyn"/>', 150, 'center', false, 'nomal');
    grid.colAdd('consentName', '<s:message code="common.msg.name"/>', 150, 'center', false, 'nomal');
    grid.colAdd('consentUserId', '<s:message code="common.msg.id"/>', 150, 'center', false, 'nomal');

    grid.loadExportMenu('<s:message code="OPERATION_MGMT.SEARCH_LOG"/>');
    grid.loadPageSize();
    grid.loadHeader(false);
    grid.initData('<s:message code="common.msg.search.click"/>');
    grid.changePageSize = function (cnt) {
        getData('Y');
    };

    grid.onClick = function () {
        if (grid.Col == grid.ColIndex('searchDt')) {
            var windowHeight = 890;

            conditions = JSON.parse(grid.getValue(grid.Row, 'conditions'));
            conditions = conditions[conditions.length - 1];

            consentStr = "";
            if (grid.getValue(grid.Row, 'searchType') == "Y") {
                consentStr = grid.getValue(grid.Row, 'consentNo') + "[" + grid.getValue(grid.Row, 'consentName') + "]";
                windowHeight = 860;
            }

            if (openWindow) {
                openWindow.close();
            }


            if (conditions.query) {
                windowHeight = 273;
            }

            openWindow = fnOpenWindow('<c:url value="/commons/searchLogConditionPop.do"/>', 'searchCondtion', 650, windowHeight, 'fix');
        }
    };
</script>

</body>
</html>