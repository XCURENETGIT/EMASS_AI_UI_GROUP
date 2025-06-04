<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<script type="text/javascript">
    var searchFlag = false;
    $(document).ready(function () {
        $('#searchWordSearchBtn').click(function () {
            getGroupData();
        });

        $('#searchWordKeyword').enter(function () {
            getGroupData();
        });

        $("#searchWordRelaNumber").keyup(function (value) {
            return /^-?\d*[.]?\d*$/.test(value);
        });

        $('#searchRelWordInsertBtn').click(function () {
            $('#searchWordUpdatPop').modal('hide');
            $('#searchWordPop input[type=text]').val('');
            $('#searchWordPop').modal('show');
            var data = gridSearchWordPattern.getRowData(gridSearchWordPattern.Row).searchWord;
            $('#searchWordName').val(data);
            $('#searchWordName').attr('readonly', true);
            setTimeout(function () {
                $("#searchWordName").focus();
            }, 500);
        });

        $('#searchWordInsertBtn').click(function () {
            $('#searchWordPop input[type=text]').val('');
            $('#searchWordName').attr('readonly', false);
            $('#searchWordPop').attr('mode', 'insert');
            $('#searchWordRelaNumber').val('');
            $('#searchWordPop').modal('show');
            setTimeout(function () {
                $("#searchWordName").focus();
            }, 500);
        });

        $('#relationKeywordUpdateBtn').click(function () {
            var searchWord = $('#searchWordUpdateName').val().ltrim().rtrim();
            if (searchWord == '') {
                ui.alertMsg('<s:message code="condition.relationKeyword.updateKeyword.input"/>');
                $('#searchWordUpdateName').focus();
                return false;
            }
            var keywordId = $('#keywordUpdateId').val();
            var data = {
                searchWord: searchWord,
                keywordId: keywordId
            };

            ui.confirmMsg('<s:message code="common.msg.confirm.modify"/>', '', '', function (rs) {
                if (rs) {
                    gridSearchWordPattern.on();
                    ui.post({
                        url: 'updateSearchWord.xcn',
                        data: data,
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            $('#searchWordUpdatePop').modal('hide');
                            getGroupData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            gridSearchWordPattern.off();
                        }
                    });
                }
            });
        });


        $('#RelationKeywordSaveBtn').click(function () {
            var searchWord = $('#searchWordName').val().ltrim().rtrim();
            if (searchWord == '') {
                ui.alertMsg('<s:message code="condition.searchWord.input"/>');
                $('#searchWordName').focus();
                return false;
            }
            var relationWord = $('#searchWordRelaName').val().ltrim().rtrim();
            if (relationWord == '') {
                ui.alertMsg('<s:message code="condition.relationSearchWord.input"/>');
                $('#regexPattern').focus();
                return false;
            }

            var searchWordRelaNumber = $('#searchWordRelaNumber').val().ltrim().rtrim();
            if (searchWordRelaNumber >= 1) {
                ui.alertMsg('<s:message code="condition.searchWordWeightdown.input"/>')
                $('#searchWordRelaNumber').focus();
                return false;
            }

            if (searchWordRelaNumber == '') {
                ui.alertMsg('<s:message code="condition.searchWordWeight.input"/>')
                $('#searchWordRelaNumber').focus();
                return false;
            }

            var data = {
                searchWord: searchWord,
                relationWord: relationWord,
                searchWordRelaNumber: searchWordRelaNumber
            }

            ui.confirmMsg('<s:message code="common.msg.confirm.add"/>', '', '', function (rs) {
                if (rs) {
                    gridSearchWordPattern.on();
                    ui.post({
                        url: 'insertSearchWord.xcn',
                        data: data,
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            getGroupData();
                            $('#searchWordPop').modal('hide');
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            gridSearchWordPattern.off();
                        }
                    });
                }
            });
        });

        $('#searchWordDeleteBtn').click(function () {
            var rows = gridSearchWordPattern.getSelectedRows();
            if (rows == '') {
                ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                return false;
            }
	        ui.confirmMsg('<s:message code="searchKeyword.msg.confirm.delete2"/>', '', '', function (rs) {
                if (rs) {
                    gridSearchWordPattern.on();
                    ui.get({
                        url: 'deleteSearchWord.xcn',
                        deleteData: JSON.stringify(rows),
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.deleted"/>');
                            getGroupData();

                        },
                        error: function (status, message) {
                            ui.alertMsg(message)
                        },
                        complete: function () {
                            gridSearchWordPattern.off();
                        }
                    })
                }
            });
        });

        $('#DeleteRelBtn').click(function () {
            var rows = relaGrid.getSelectedRows();
            var keywordId = $('#rekeywordId').val();
            if (rows == '') {
                ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                return false;
            }
            ui.confirmMsg('<s:message code="searchKeyword.msg.confirm.delete"/>', '', '', function (rs) {
                if (rs) {
                    relaGrid.on();
                    ui.get({
                        url: 'deleteSearchRelaWord.xcn',
                        deleteData: JSON.stringify(rows),
                        keywordId: keywordId,
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.deleted"/>');
                            $('#searchWordUpdatPop').modal('hide');
                            getGroupData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message)
                        },
                        complete: function () {
                            relaGrid.off();
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
            gridSearchWordPattern.data.length = 0;
            gridSearchWordPattern.rtnNextPageFunc = getGroupData;
            gridSearchWordPattern.loadingPage = 0;
        } else {
            gridSearchWordPattern.loadingPage++;
        }
        gridSearchWordPattern.on();
        searchFlag = true;

        ui.get({
            url: 'getSearchWord.xcn',
            searchStr: $('#searchWordKeyword').val(),
            offset: gridSearchWordPattern.data.length,
            limit: gridSearchWordPattern.pageSize,
            success: function (data, total) {
                gridSearchWordPattern.appendData(data);
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
                gridSearchWordPattern.off();
                searchFlag = false;
            }
        });
    }
</script>

<div class="modal" id="searchWordPop" aria-labelledby="searchWordPop" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="searchWordPopForm">
			<div class="modalHead">
				<h2><s:message code="SETTING.RELATION_KEYWORD"/> - <s:message code="common.msg.add"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="SETTING.RELATION_KEYWORD"/> <s:message code="common.msg.add"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="searchWordName" class="fname"><s:message code="common.keyword"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="form-control" name="searchWordName" id="searchWordName">
							<input type="hidden" class="form-control" name="keywordId" id="keywordId">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="searchWordRelaName" class="fname"><s:message code="common.relationKeyword"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="searchWordRelaName" id="searchWordRelaName">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="searchWordRelaNumber" class="fname"><s:message code="common.weight"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="number" step="0.01" class="w100" name="searchWordRelaNumber"
							       id="searchWordRelaNumber">
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="RelationKeywordSaveBtn"><s:message
							code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>


<div class="modal" id="searchWordUpdatePop" aria-labelledby="searchWordPop" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="searchWordUpdatePopForm">
			<div class="modalHead">
				<h2><s:message code="SETTING.RELATION_KEYWORD"/> - <s:message code="common.msg.modify"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="SETTING.RELATION_KEYWORD"/> <s:message code="common.msg.modify"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="searchWordUpdateName" class="fname"><s:message code="common.keyword"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="searchWordName" id="searchWordUpdateName">
							<input type="hidden" class="w100" name="keywordId" id="keywordUpdateId">
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="relationKeywordUpdateBtn"><s:message code="common.msg.modify"/></button>
				</div>
			</div>
		</form>
	</div>
</div>


<!--연관 키워드 상세보기, 삭제 -->
<div class="modal" id="searchWordUpdatPop" aria-labelledby="searchWordUpdatPop" data-backdrop="static">
	<div class="modal-content">
		<div class="modalHead">
			<h2><s:message code="SETTING.RELATION_KEYWORD"/> - <s:message code="common.msg.delete"/></h2>
			<span class="close" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalCon">
			<div class="modalTop">
				<button type="button" class="pop_btn01" accesskey="A" id="searchRelWordInsertBtn"><s:message code="common.relationKeyword"/> <s:message code="common.msg.add"/></button>
				<button type="button" class="pop_btn02" accesskey="S" id="DeleteRelBtn"><s:message code="common.msg.delete"/></button>
			</div>
			<div class="modalbody">
				<div class="row" style="float: right">
				</div>
				<div class="row">
					<div class="col-35">
						<label for="searchWordName" class="fname"><s:message code="common.keyword"/></label>
					</div>
					<div class="col-65">
						<input type="text" class="w100" name="searchUpdateName" id="searchUpdateName" readonly="readonly">
						<input type="hidden" class="form-control" name="rekeywordId" id="rekeywordId">
					</div>
				</div>
					<div class="contentSub" style="padding: 0px;">
						<div id="relaGrid" class="slickGrid gridArea"  style="height: 400px;">
					</div>
				</div>
			</div>
			<div class="modalfooter">
				<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal">
					<s:message code="common.msg.close"/></button>
			</div>
		</div>
	</div>
</div>

<div>
	<div class="searchArea">
		<div class="searchSub">
			<div>
				<input type="text" placeholder="<s:message code="condition.searchWord.input"/>" id="searchWordKeyword" style="width: 300px;">
				<button class="form_btn01" type="button" accesskey="K" id="searchWordSearchBtn"><s:message code="auditLog.oper.SEARCH"/></button>
			</div>
			<button type="button" class="btn01" accesskey="A" id="searchWordInsertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
			<button type="button" class="btn02" accesskey="E" id="searchWordDeleteBtn"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					<s:message code="SETTING.RELATION_KEYWORD"/> <s:message code="selectCodeAll.list"/>
					<span id="relationKeywordCount"></span>
				</button>
			</div>
			<div id="searchWordListGrid" class="slickGrid gridArea" ></div>
		</div>
	</div>
</div>

<script type="text/javascript">
    var gridSearchWordPattern = new Xgrid('searchWordListGrid', contextRoot);
    gridSearchWordPattern.onCheckBox();
    gridSearchWordPattern.autoNumber();
    gridSearchWordPattern.colAdd('searchWord', '<s:message code="common.keyword"/>', 200, 'left', false, 'link');
    gridSearchWordPattern.colAdd('relationWord', '<s:message code="common.relationKeyword"/>', 1300, 'left', false, 'link');
    gridSearchWordPattern.loadExportMenu('<s:message code="common.relationKeyword"/><s:message code="selectCodeAll.list"/>');
    gridSearchWordPattern.loadPageSize();
    gridSearchWordPattern.loadHeader(true);

    gridSearchWordPattern.changePageSize = function (cnt) {
        getGroupData();
    }

    gridSearchWordPattern.onClick = function () {
        if (gridSearchWordPattern.Col == gridSearchWordPattern.ColIndex('relationWord')) {
            var data = gridSearchWordPattern.getRowData(gridSearchWordPattern.Row);
            $('#searchUpdateName').val(data.searchWord);
            $('#rekeywordId').val(data.keywordId);

            var result = [];
            if (data.relationWord != null) {
                var relationWords = data.relationWord.split(',');
                for (var i = 0; i < relationWords.length; i++) {
                    result.push({'relationWord': relationWords[i].ltrim().rtrim()});
                }
            }
            relaGrid.setData(result);
            $('#searchWordUpdatPop').modal('show');
        }
        if (gridSearchWordPattern.Col == gridSearchWordPattern.ColIndex('searchWord')) {
            var data = gridSearchWordPattern.getRowData(gridSearchWordPattern.Row);
            $('#searchWordUpdateName').val(data.searchWord);
            $('#keywordUpdateId').val(data.keywordId);
            $('#searchWordUpdatePop').modal('show');
        }
    }

    var relaGrid = new Xgrid('relaGrid', contextRoot);
    relaGrid.onCheckBox();
    relaGrid.autoNumber();
    relaGrid.colAdd('relationWord', "<s:message code="common.relationKeyword"/>", 400, 'left', false, 'nomal');
    relaGrid.loadHeader(true);
</script>