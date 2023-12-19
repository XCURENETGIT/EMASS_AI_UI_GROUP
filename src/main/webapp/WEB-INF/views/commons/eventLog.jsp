<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<head>
	<title></title>
	<script type="text/javascript">
        var searchFlag = false;
        $(document).ready(function () {
            $('#startDatePicker').datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date())
            });

            $('#endDatePicker').datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date())
            });

            $('#searchBtn').click(function () {
                getData();
            });
            $('#deviceIp').change(function () {
                getData();
            });
            $('#eventLevel').change(function () {
                getData();
            });
            $("#deviceIp").html(getDeviceOptions());
            getData();
        });

        function getData(lastRow) {
            if (searchFlag) return;
            if (lastRow == undefined) {
                grid.data.length = 0;
                grid.rtnNextPageFunc = getData;
                grid.loadingPage = 0;
            } else {
                grid.loadingPage++;
            }
            var startDt = $('#startDt').val().replaceAll("-", "");
            var endDt = $('#endDt').val().replaceAll("-", "");
            var deviceIp = $("#deviceIp").val();
            var devision = $("#devision").val();
            var eventLevel = $("#eventLevel").val();
            var deviceNm = $('#deviceIp option:selected').text()
            var eventLevelNm = $('#eventLevel option:selected').text()
            if (deviceIp == '') {
                deviceNm = '<s:message code="common.msg.all"/>'
            }
            if (eventLevel == '') {
                eventLevelNm = '<s:message code="common.msg.all"/>'
            }
            if (startDt > endDt) ui.alertMsg('<s:message code="blockHistoryNonBusi.msg.cannot.startendtime"/>');
            grid.on();
            searchFlag = true;
            ui.get({
                url: 'getSnmpTrapList.xcn',
                startDt: startDt,
                endDt: endDt,
                deviceIp: deviceIp,
                devision: devision,
                eventLevel: eventLevel,
                deviceNm: deviceNm,
                eventLevelNm: eventLevelNm,
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

        function getDeviceOptions() {
            var result = '<option value="">- <s:message code="eventLog.select.device"/> -</option>';
            ui.get({
                url: 'getDeviceList.xcn',
                asyncFlag: false,
                success: function (data, total) {
                    for (var i = 0; i < data.devices.length; i++) {
                        result += '<option value="' + data.devices[i].deviceIp + '">' + data.devices[i].deviceNm + ' (' + data.devices[i].deviceIp + ')</option>';
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
			<div id="startDatePicker"><input type="date" id="startDt" style="width: 110px;">
				<span class="hyphen">~</span></div>
			<div id="endDatePicker"><input type="date" id="endDt" style="width: 110px;"></div>
			<div>
				<select id="deviceIp" style="width: 200px; display: flex; ">
					<option value="">- <s:message code="eventLog.select.device"/> -</option>
				</select>
			</div>
				<select style="display: none;" id="devision">
				</select>
			<div>
				<select id="eventLevel" style="width: 200px;">
					<option value="">- <s:message code="eventLog.eventlevel"/> -</option>
					<option value="I"><s:message code="deviceInfo.interest"/></option>
					<option value="W"><s:message code="deviceInfo.caution"/></option>
					<option value="E"><s:message code="deviceInfo.danger"/></option>
				</select>
			</div>
			<div>
				<button type="button" class="form_btn01" accesskey="Q" id="searchBtn" accesskey="s">조회</button>
			</div>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					장비 이벤트 목록
					<span id="eventLogCount"></span>
				</button>
			</div>
			<div id="eventLogListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>


<script type="text/javascript">
    var grid = new Xgrid('eventLogListGrid', contextRoot);
    grid.autoNumber();
    grid.colAdd('eventDt', '<s:message code="eventLog.eventtime"/>', 160, 'center', false, 'nomal');
    grid.colAdd('deviceNm', '<s:message code="eventLog.devname"/>', 120, 'left', false, 'nomal');
    grid.colAdd('deviceIp', '<s:message code="eventLog.devip"/>', 120, 'center', false, 'nomal');
    grid.colAdd('devision', '<s:message code="eventLog.eventtype"/>', 150, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'CPU') return '<s:message code="eventLog.cpustatus"/>';
        else if (value == 'MEM') return '<s:message code="eventLog.memorystatus"/>';
        else if (value == 'HDD') return '<s:message code="eventLog.hddstatus"/>';
        else if (value == 'CLR') return '<s:message code="eventLog.deletelog"/>';
        else if (value == 'SVC') return '<s:message code="eventLog.svcstatus"/>';
        else if (value == 'PROC') return '<s:message code="eventLog.processstatus"/>';
        else if (value == 'LINK') return '<s:message code="eventLog.networkstatus"/>';
        else if (value == 'TRA') return '<s:message code="eventLog.trafficstatus"/>';
        else if (value == 'SNMP') return '<s:message code="eventLog.snmpstatus"/>';
        return '-';
    });
    grid.colAdd('eventLevel', '<s:message code="eventLog.eventlevel"/>', 100, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == 'I') return '<s:message code="deviceInfo.interest"/>';
        else if (value == 'W') return '<s:message code="deviceInfo.caution"/>';
        else if (value == 'E') return '<s:message code="deviceInfo.danger"/>';
        return '-';
    });
    grid.colAdd('content', '<s:message code="eventLog.info"/>', 500, 'left', false, 'nomal');

    grid.loadExportMenu('<s:message code="eventLog.dev.log"/>');
    grid.loadPageSize();
    grid.loadHeader(true);
    grid.initData('<s:message code="common.msg.search.click"/>');
    grid.changePageSize = function (cnt) {
        getData();
    };
</script>
