<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title></title>
	<style type="text/css">
	</style>

	<script>
        var searchFlag = false;

        $(document).ready(function () {

            $('#searchWordSearchBtn').click(function(){
                getGroupData();
            });

            $('#searchWordKeyword').enter(function(){
                getGroupData();
            });

            $("#searchWordRelaNumber").keyup(function (value) { return /^-?\d*[.]?\d*$/.test(value); });

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
                $('#searchWordPop').modal('show');
                setTimeout(function () {
                    $("#searchWordName").focus();
                }, 500);
            });

            $('.searchWordUpdatePopBtn').click(function () {
                var searchWord = $('#searchWordUpdateName').val().ltrim().rtrim();
                if (searchWord == ''){
                    ui.alertMsg("수정할 키워드를 입력해주세요");
                    $('#searchWordUpdateName').focus();
                    return false;
                }
                var keywordId = $('#keywordUpdateId').val();
                var data = {
                    searchWord : searchWord,
                    keywordId : keywordId
                };

                ui.confirmMsg('수정 하시겠습니까?', '', '', function (rs) {
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


            $('.searchWordSavaPopBtn').click(function () {
                var searchWord = $('#searchWordName').val().ltrim().rtrim();
                if (searchWord == '') {
                    ui.alertMsg("키워드를 입력해주세요");
                    $('#searchWordName').focus();
                    return false;
                }
                var relationWord = $('#searchWordRelaName').val().ltrim().rtrim();
                if (relationWord == '') {
                    ui.alertMsg("연관 키워드를 입력해주세요");
                    $('#regexPattern').focus();
                    return false;
                }

                var searchWordRelaNumber = $('#searchWordRelaNumber').val().ltrim().rtrim();
                if (searchWordRelaNumber >= 1) {
                    ui.alertMsg("가중치는 1 이하로 입력해주세요")
                    $('#searchWordRelaNumber').focus();
                    return false;
                }

                if (searchWordRelaNumber == '') {
                    ui.alertMsg("가중치를 입력해주세요")
                    $('#searchWordRelaNumber').focus();
                    return false;
                }

                var data = {
                    searchWord: searchWord,
                    relationWord: relationWord,
                    searchWordRelaNumber: searchWordRelaNumber
                }

                ui.confirmMsg('추가하시겠습니까?', '', '', function (rs) {
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
                ui.confirmMsg('삭제 하겠습니까?', '', '', function (rs) {
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
                ui.confirmMsg('삭제 하겠습니까?', '', '', function (rs) {
                    if (rs) {
                        relaGrid.on();
                        ui.get({
                            url: 'deleteSearchRelaWord.xcn',
                            deleteData: JSON.stringify(rows),
                            keywordId : keywordId,
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

            if (flag == undefined){
                gridSearchWordPattern.data.length = 0;
                gridSearchWordPattern.rtnNextPageFunc =getGroupData;
                gridSearchWordPattern.loadingPage = 0;
            }else {
                gridSearchWordPattern.loadingPage++;
            }
            gridSearchWordPattern.on();
            // relaGrid.on();
            searchFlag = true;

            ui.get({
                url: 'getSearchWord.xcn',
                searchStr : $('#searchWordKeyword').val(),
                offset:gridSearchWordPattern.data.length,
                limit:gridSearchWordPattern.pageSize,
                success: function (data, total) {
                    gridSearchWordPattern.appendData(data);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    gridSearchWordPattern.off();
                    // relaGrid.off();
                    searchFlag = false;
                }
            })


        }

	</script>

</head>
<body class="mini-navbar">


<div class="modal fade" id="searchWordPop" tabindex="-1" role="dialog" aria-labelledby="searchWordPop">
	<div class="modal-dialog" role="document" style="width: 500px;">
		<div class="modal-content">
			<form method="post" id="searchWordPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title">키워드 관리 - 추가</h3>
				</div>
				<div class="modal-body">

					<div class="form-group form-inline">
						<label for="searchWordName" class="control-label col-xs-3">키워드</label>
						<input type="text" class="form-control" name="searchWordName" id="searchWordName"
						       style="width: 350px;" maxlength="60">
						<input type="hidden" class="form-control" name="keywordId" id="keywordId">
					</div>
					<div class="form-group form-inline" name="searchRelInput">
						<label for="searchWordRelaName" class="control-label col-xs-3">연관 키워드</label>
						<input type="text" class="form-control" name="searchWordRelaName" id="searchWordRelaName"
						       style="width: 350px; " maxlength="60">
					</div>
					<div class="form-group form-inline" name="searchRelInput">
						<label for="searchWordRelaNumber" class="control-label col-xs-3">가중치</label>
						<input type="number" step="0.01" class="form-control" name="searchWordRelaNumber"
						       id="searchWordRelaNumber" style="width: 350px; " maxlength="60">
					</div>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary searchWordSavaPopBtn" accesskey="S"><s:message
							code="common.msg.save"/></button>
				</div>
			</form>
		</div>
	</div>
</div>

<div class="modal fade" id="searchWordUpdatePop" tabindex="-1" role="dialog" aria-labelledby="searchWordPop">
	<div class="modal-dialog" role="document" style="width: 500px;">
		<div class="modal-content">
			<form method="post" id="searchWordUpdatePopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title">키워드 관리 - 수정</h3>
				</div>
				<div class="modal-body">

					<div class="form-group form-inline">
						<label for="searchWordUpdateName" class="control-label col-xs-3">키워드</label>
						<input type="text" class="form-control" name="searchWordName" id="searchWordUpdateName"
						       style="width: 350px;" maxlength="60">
						<input type="hidden" class="form-control" name="keywordId" id="keywordUpdateId">
					</div>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary searchWordUpdatePopBtn" accesskey="S">수정</button>
				</div>
			</form>
		</div>
	</div>
</div>


<!--연관 키워드 상세보기, 삭제 -->
<div class="modal fade" id="searchWordUpdatPop" tabindex="-1" role="dialog" aria-labelledby="searchWordUpdatPop">
	<div class="modal-dialog" role="document" style="width: 1000px">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title">연관 키워드 관리 - 삭제</h3>
			</div>
			<div class="modal-body">
				<div class="form-group form-inline">
					<label for="searchWordName" class="control-label col-xs-2">키워드</label>
					<input type="text" class="form-control" name="searchUpdateName" id="searchUpdateName"
					       style="width: 350px;" maxlength="60" readonly="readonly">
					<input type="hidden" class="form-control" name="rekeywordId" id="rekeywordId">
				</div>

				<div class="row top_space">
					<div style="height:500px;" id="selectUserDiv">
						<div id="relaGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message
						code="common.msg.close"/></button>
				<button type="button" class="btn btn-sm btn-primary" accesskey="A" id="searchRelWordInsertBtn"><span
						class="glyphicon glyphicon-plus"></span>연관키워드 추가</button>
				<button type="button" class="btn btn-primary" accesskey="S" id="DeleteRelBtn">삭제</button>
			</div>
		</div>
	</div>
</div>




<div class="col-xs-7" style="height: 100%; padding-left: 5px;width:calc(100%); text-align: center;">
	<div class="row">
		<div class="col-xs-8 text-left" style="padding-left:20px;">
			<div class="form-group form-inline not-dashed">
				<div class="input-group">
					<input type="text" class="form-control input-sm"
					       placeholder="<s:message code="keyword.message.insert"/>" id="searchWordKeyword"
					       style="width: 200px;">
					<div class="input-group-btn">
						<button class="btn btn-sm btn-success" type="button" accesskey="K" id="searchWordSearchBtn"><i
								class="glyphicon glyphicon-search"></i></button>
					</div>
				</div>
				<button type="button" class="btn btn-sm btn-primary" accesskey="A" id="searchWordInsertBtn"><span
						class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
				<button type="button" class="btn btn-sm btn-default" accesskey="E" id="searchWordDeleteBtn"><span
						class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/>
				</button>
			</div>
		</div>
	</div>

	<div class="row xcn_full top_space">
		<div class="col-xs-12" style="height: 100%;">
			<div id="searchWordListGrid" class="slickGrid gridArea"></div>
		</div>

	</div>


</div>


<script type="text/javascript">
    var gridSearchWordPattern = new Xgrid('searchWordListGrid', contextRoot);
    gridSearchWordPattern.onCheckBox();
    gridSearchWordPattern.autoNumber();
    gridSearchWordPattern.colAdd('searchWord', "키워드", 200, 'left', false, 'link');
    gridSearchWordPattern.colAdd('relationWord', "연관 키워드", 1300, 'left', false, 'link');

    gridSearchWordPattern.loadPageSize();
    gridSearchWordPattern.loadHeader(false);

    gridSearchWordPattern.changePageSize = function (cnt){
        getGroupData();
    }

    gridSearchWordPattern.onClick = function () {
        if (gridSearchWordPattern.Col == gridSearchWordPattern.ColIndex('relationWord') && $('#searchRelWordInsertBtn').css('display') == 'inline-block') {
            var data = gridSearchWordPattern.getRowData(gridSearchWordPattern.Row);
            $('#searchUpdateName').val(data.searchWord);
            $('#rekeywordId').val(data.keywordId);

            var relationWords = data.relationWord.split(',');
            var data = [];
            for (var i = 0; i < relationWords.length; i++) {
                data.push({'relationWord': relationWords[i].ltrim().rtrim()});
            }
            relaGrid.setData(data);
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
    relaGrid.colAdd('relationWord', "연관 키워드", 800, 'left', false, 'nomal');

    relaGrid.loadHeader(false);

</script>


</div>

</body>
</html>
