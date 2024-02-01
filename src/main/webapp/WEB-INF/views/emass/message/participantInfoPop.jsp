<%@page import="net.sf.json.JSONObject" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ include file="/WEB-INF/fragments/popupScript.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	JSONObject param = Common.getParam(request);
	String xrootmtr = Common.nvl(param.get("xrootmtr"));
	String srcip = Common.nvl(param.get("srcip"));
	String usr_id = Common.nvl(param.get("usr_id"));
	String startDt = Common.nvl(param.get("startDt"));
	String endDt = Common.nvl(param.get("endDt"));
	String searchStr = Common.nvl(param.get("searchStr"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS AI - <s:message code="common.msg.participantinfo"/></title>
	<style type="text/css">
		html, body {
			height: 100%;
			padding: 0px;
			margin: 0px;
			overflow: auto;
			min-width: 650px;
		}

		.attachExt {
			cursor: pointer;
		}
	</style>
	<script type="text/JavaScript">
        var xrootmtr = '<%=xrootmtr%>';
        var usr_id = '<%=usr_id%>';
        var srcip = '<%=srcip%>';
        var startDt = '<%=startDt%>';
        var endDt = '<%=endDt%>';
        var searchStr = '<%=searchStr%>';
        $(document).ready(function () {
            ui.onBody('content_body', 0, 0);

            getParticipantInfo();
            ui.off('content_body');
            $('#noSelectBtn').click(function () {
                self.close();
            });
        });

        function getParticipantInfo(flag) {
            if (xrootmtr == '') {
                grid.setData([]);
                return;
            }
            grid.on();
            var data = {
                xrootmtr: xrootmtr,
                srcip: srcip,
                usr_id: usr_id,
                startDt: startDt,
                endDt: endDt,
                searchStr: searchStr,
                groupField: ''
            };
            ui.get({
                url: 'getMessengerGroupUserList.xcn',
                xrootmtr: data.xrootmtr,
                startDt: data.startDt + "000000",
                endDt: data.endDt + "235959",
                groupField: 'userkey',
                success: function (data, total) {
                    grid.setData(data.groups);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    grid.off();
                }
            });
        }
	</script>
</head>

<div class="xcn_container" style="min-width: 650px;">
	<div class="boxArea" style="min-height:inherit;">
		<div class="content_body">
			<div class="p20">
				<h2><span class="bullet01"></span><s:message code="common.msg.participantinfo"/></h2>
				<div class="xcn_pop_btn">
					<button type="button" class="btn btn-sm btn-primary" accesskey="C" id="saveBtn" style="display: none;"><span
							class="fa fa-check"></span>&nbsp;<s:message code="common.msg.save"/></button>
					<button type="button" class="btn btn05" accesskey="C" id="noSelectBtn"><span
							class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
				</div>
				<div class="mat16"  style="height: 70%;">
					<div id="participantGrid" class="slickGrid gridArea"></div>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
    var grid = new Xgrid('participantGrid', contextRoot);
    grid.autoNumber();
    grid.colAdd('srcip', 'ID', 250, 'left', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == null) return '-';
        else return value;
    });
    grid.colAdd('usr_id', '<s:message code="common.msg.name"/>', 180, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        if (value == null) return '-';
        else return value;
    });
    grid.onClick = function () {
        /* if (grid.Col == grid.ColIndex('code')) {
			setSelectedData();
		} */
    };
    grid.loadHeader(false);
    grid.initData('<s:message code="common.msg.search.click"/>');
</script>
</body>
</html>