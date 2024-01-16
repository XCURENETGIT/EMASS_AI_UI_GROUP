<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<script type="text/javascript">
    var searchFlag = false;
    $(document).ready(function () {
        $('#searchregexNameBtn').click(function () {
            getGroupData();
        });

        $('#searchregexName').enter(function () {
            getGroupData();
        });

        $('#searchStrKeywordBtn').click(function () {
            var rows = gridGroup.getSelectedRows();
            if (rows == "") {
                alert("<s:message code="keyword.msg.select.part"/>")
                return false;
            }
            getGroupData();
        });

        $('#regexPatternInsertBtn').click(function () {
            $('#regexPatternPop input[type=text]').val('');
            $('#regexPatternPop').attr('mode', 'insert');
            $('#regexPatternPop').modal('show');
            setTimeout(function () {
                $("#regexPatternName").focus();
            }, 500);
        });

        $('#regexSaveButton').click(function () {
            var regexPatternName = $('#regexPatternName').val().ltrim().rtrim();
            if (regexPatternName == '') {
                ui.alertMsg('<s:message code="regexPattern.name.input"/>');
                $('#regexPatternName').focus();
                return false;
            }
            var regexPattern = $('#regexPattern').val().ltrim().rtrim();
            if (regexPattern == '') {
                ui.alertMsg('<s:message code="regexPattern.pattern.input"/>');
                $('#regexPattern').focus();
            }
            var mode = $('#regexPatternPop').attr('mode');
            var confirmMessage = mode == 'insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';

            ui.confirmMsg(confirmMessage, '', '', function (rs) {
                if (rs) {
                    gridRegexPattern.on();
                    ui.post({
                        url: mode == 'insert' ? 'insertRegexPattern.xcn' : 'updateRegexPattern.xcn',
                        data: $('#regexPatternPopForm').serializeAll(),
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            $('#regexPatternPop').modal('hide');
                            getGroupData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            gridRegexPattern.off();
                        }
                    })
                }
            })
        });

        $('#keywordDeleteBtn').click(function () {
            var rows = gridRegexPattern.getSelectedRows();
            if (rows == '') {
                ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                return false;
            }

            ui.confirmMsg('<s:message code="common.msg.confirm.delete"/>', '', '', function (rs) {
                if (rs) {
                    gridRegexPattern.on();
                    ui.get({
                        url: 'deleteRegexPattern.xcn',
                        deleteData: JSON.stringify(rows),
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.deleted"/>');
                            getGroupData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message)
                        },
                        complete: function () {
                            gridRegexPattern.off();
                        }
                    })
                }
            });
        });
        getGroupData();
    });

    function getGroupData(flag) {
        if (searchFlag) return false;
        if (flag == undefined) {
            gridRegexPattern.data.length = 0;
            gridRegexPattern.rtnNextPageFunc = getGroupData;
            gridRegexPattern.loadingPage = 0;
        } else {
            gridRegexPattern.loadingPage++;
        }
        searchFlag = true;
        gridRegexPattern.on();

        ui.get({
            searchStr: $('#searchregexName').val(),
            url: 'getRegexPattern.xcn',
            offset: gridRegexPattern.data.length,
            limit: gridRegexPattern.pageSize,
            success: function (data, total) {
                gridRegexPattern.appendData(data);
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
                gridRegexPattern.off();
                searchFlag = false;
            }
        })

    }
</script>

<div class="modal" id="regexPatternPop" aria-labelledby="regexPatternPop" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="regexPatternPopForm">
			<div class="modalHead">
				<h2><s:message code="DATA_MONITOR.REGEX_PATTERN"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="regexPattern.update"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="regexPatternName" class="fname"><s:message code="regexPattern.name"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="regexPatternName" id="regexPatternName">
							<input type="hidden" name="regexSeq" id="regexSeq">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="regexPattern" class="fname"><s:message code="regexPattern.pattern"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="regexPattern" id="regexPattern">
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="regexSaveButton"><s:message
							code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>

<div>
	<div class="searchArea">
		<div class="searchSub">
			<div>
				<input type="text" placeholder='<s:message code="regexPattern.name.input"/>' id="searchregexName" style="width: 300px;">
				<button class="form_btn01" type="button" accesskey="K" id="searchregexNameBtn"><s:message code="auditLog.oper.SEARCH"/></button>
			</div>
			<button type="button" class="btn01" accesskey="A" id="regexPatternInsertBtn"><img
					src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
			<button type="button" class="btn02" accesskey="E" id="keywordDeleteBtn"><img
					src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					<s:message code="regexPattern.setting"/>
					<span id="regexPatternCount"></span>
				</button>
			</div>
			<div id="regexPatternListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
    var gridRegexPattern = new Xgrid('regexPatternListGrid', contextRoot);
    gridRegexPattern.onCheckBox();
    gridRegexPattern.autoNumber();
    gridRegexPattern.colAdd('regexPatternName', '<s:message code="regexPattern.name"/>', 200, 'left', false, 'link');
    gridRegexPattern.colAdd('regexPattern', '<s:message code="regexPattern.pattern"/>', 500, 'left', false, 'nomal');
    gridRegexPattern.colAdd('regexUser', '<s:message code="condition.user"/>', 200, 'left', false, 'nomal');
    gridRegexPattern.colAdd('regexDt', '<s:message code="consent.registered.date"/>', 200, 'left', false, 'nomal');
    gridRegexPattern.loadPageSize();
    gridRegexPattern.loadHeader(true);

    gridRegexPattern.changePageSize = function (cnt) {
        getGroupData();
    }

    gridRegexPattern.onClick = function () {
        var data = gridRegexPattern.getRowData(gridRegexPattern.Row);
        if (gridRegexPattern.Col == gridRegexPattern.ColIndex('regexPatternName')) {
            $('#regexPatternPop').attr('mode', 'modify');
            $('#regexPatternName').val(data.regexPatternName);
            $('#regexPattern').val(data.regexPattern);
            $('#regexSeq').val(data.regexSeq);
            $('#regexPatternPop').modal('show');
        }
    }
</script>

