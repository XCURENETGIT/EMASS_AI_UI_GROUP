<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title> </title>
	<style type="text/css">

	</style>
	<script>
        var searchFlag = false;
        $(document).ready(function() {

            $('#searchregexNameBtn').click(function(){
                getGroupData();
            });
            $('#searchregexName').enter(function(){
                getGroupData();
            });

            $('#searchStrKeywordBtn').click(function(){
                var rows = gridGroup.getSelectedRows();
                if( rows == "" ) {
                    alert("<s:message code="keyword.msg.select.part"/>")
                    return false;
                }
                getGroupData();
            });


            $('#regexPatternInsertBtn').click(function(){

                $('#regexPatternPop input[type=text]').val('');
                $('#regexPatternPop').attr('mode','insert');
                $('#regexPatternPop').modal('show');
                setTimeout(function(){
                    $("#regexPatternName").focus();
                }, 500);
            });


            $('.regexPatternSavePopBtn').click(function() {
                var regexPatternName = $('#regexPatternName').val().ltrim().rtrim();
                if (regexPatternName == ''){
                    ui.alertMsg("패턴 정규식 이름을 입력해주세요");
                    $('#regexPatternName').focus();
                    return false;
                }
                var regexPattern = $('#regexPattern').val().ltrim().rtrim();
                if (regexPattern == ''){
                    ui.alertMsg("패턴 정규식을 입력해주세요");
                    $('#regexPattern').focus();
                }

                var mode = $('#regexPatternPop').attr('mode');

                var confirmMessage = mode=='insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';

                var data = {
                    regexPattern : regexPattern,
                    regexPatternName : regexPatternName,
                    regexSeq :  $('#regexSeq').val().ltrim().rtrim()
                }

                ui.confirmMsg(confirmMessage,'','',function (rs){
                    if (rs){
                        gridRegexPattern.on();
                        ui.post({
                            url:mode=='insert' ? 'insertRegexPattern.xcn' : 'updateRegexPattern.xcn',
                            data : data,
                            success : function (data, total){
                                ui.alertMsg('<s:message code="common.msg.saved"/>');
                                $('#regexPatternPop').modal('hide');
                                getGroupData();
                            },
                            error : function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete : function (){
                                gridRegexPattern.off();

                            }
                        })
                    }

                })

            });

            $('#keywordDeleteBtn').click(function(){
                var rows = gridRegexPattern.getSelectedRows();
                if( rows == '' ) {
                    ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                    return false;
                }
                ui.confirmMsg( '삭제 하겠습니까?','', '', function(rs){
                    if (rs){
                        gridRegexPattern.on();
                        ui.get({
                            url: 'deleteRegexPattern.xcn',
                            deleteData : JSON.stringify(rows),
                            success : function (data , total){
                                ui.alertMsg('<s:message code="common.msg.deleted"/>');
                                getGroupData();
                            },
                            error : function (status , message){
                                ui.alertMsg(message)
                            },
                            complete : function (){
                                gridRegexPattern.off();
                            }
                        })
                    }
                });
            });

            getGroupData ();

        });
        function getGroupData(flag) {
            if ( searchFlag ) return false;

            if ( flag == undefined ) {
                gridRegexPattern.data.length = 0;
                gridRegexPattern.rtnNextPageFunc =getGroupData;
                gridRegexPattern.loadingPage = 0;
            } else {
                gridRegexPattern.loadingPage++;
            }
            searchFlag = true;
            gridRegexPattern.on();

            ui.get({
                searchStr : $('#searchregexName').val(),
                url : 'getRegexPattern.xcn',
                offset:gridRegexPattern.data.length,
                limit:gridRegexPattern.pageSize,
                success : function(data, total) {
                        gridRegexPattern.appendData(data);
                },
                error : function (status, message){
                    ui.alertMsg(message);
                },
                complete : function (){
                    gridRegexPattern.off();
                    searchFlag = false;
                }
            })

        }



	</script>
</head>
<body class="mini-navbar">

<div class="modal fade" id="regexPatternPop" tabindex="-1" role="dialog" aria-labelledby="regexPatternPop">
	<div class="modal-dialog" role="document" style="width: 500px;">
		<div class="modal-content">
			<form method="post" id="regexPatternPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title">정규식 패턴 관리 - 추가 및 수정</h3>
				</div>
				<div class="modal-body">

					<div class="form-group form-inline">
						<label for="regexPatternName" class="control-label col-xs-3">정규식패턴 이름</label>
						<input type="text" class="form-control" name="regexPatternName" id="regexPatternName" style="width: 350px;" maxlength="60">
						<input type="hidden" class="form-control" name="regexSeq" id="regexSeq">
					</div>
					<div class="form-group form-inline">
						<label for="regexPattern" class="control-label col-xs-3">정규식 패턴</label>
						<input type="text" class="form-control" name="regexPattern" id="regexPattern" style="width: 350px;" maxlength="60">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary regexPatternSavePopBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</form>
		</div>
	</div>
</div>





<div class="col-xs-7" style="height: 100%; padding-left: 5px;width:calc(100%); text-align: center;" >
	<div class="row">
		<div class="col-xs-8 text-left" style="padding-left:20px;">
			<div class="form-group form-inline not-dashed">
				<div class="input-group">
					<input type="text" class="form-control input-sm"
					       placeholder="정규식 패턴 이름을 입력하세요" id="searchregexName"
					       style="width: 200px;">
					<div class="input-group-btn">
						<button class="btn btn-sm btn-success" type="button" accesskey="K" id="searchregexNameBtn"><i
								class="glyphicon glyphicon-search"></i></button>
					</div>
				</div>
					<button type="button" class="btn btn-sm btn-primary" accesskey="A" id="regexPatternInsertBtn"><span
							class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
					<button type="button" class="btn btn-sm btn-default" accesskey="E" id="keywordDeleteBtn"><span
							class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/>
					</button>
			</div>
		</div>
	</div>

	<div class="row xcn_full top_space">
		<div class="col-xs-12" style="height: 100%;">
			<div id="regexPatternListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>


	<script type="text/javascript">
        var gridRegexPattern = new Xgrid('regexPatternListGrid', contextRoot);
        gridRegexPattern.onCheckBox();
        gridRegexPattern.autoNumber();
        gridRegexPattern.colAdd('regexPatternName',"정규식 패턴 이름",200,'left', false,'link');
        gridRegexPattern.colAdd('regexPattern',"정규식 패턴",500,'left', false,'nomal');
        gridRegexPattern.colAdd('regexUser',"사용자",200,'left', false,'nomal');
        gridRegexPattern.colAdd('regexDt',"등록일",200,'left', false,'nomal');

        gridRegexPattern.loadPageSize();
        gridRegexPattern.loadHeader(false);

        gridRegexPattern.changePageSize = function (cnt){
            getGroupData();
        }

        gridRegexPattern.onClick = function() {
            var data = gridRegexPattern.getRowData(gridRegexPattern.Row);
            if (gridRegexPattern.Col == gridRegexPattern.ColIndex('regexPatternName')) {
                $('#regexPatternPop').attr('mode','modify');
                $('#regexPatternName').val(data.regexPatternName);
                $('#regexPattern').val(data.regexPattern);
                $('#regexSeq').val(data.regexSeq);
                $('#regexPatternPop').modal('show');
            }
        }

	</script>
</div>

</body>


</html>
