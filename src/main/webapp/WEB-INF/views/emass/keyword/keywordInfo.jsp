<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<script>
var searchFlag = false;
$(document).ready(function(){
	$('#searchStrGroupBtn').click(function(){ getGroupData(); });
	$('#searchStrGroup').enter(function(){ getGroupData(); });
	
	$('#searchStrKeywordBtn').click(function(){
		var rows = gridGroup.getSelectedRows();
		if( rows == "" ) {
			alert("<s:message code="keyword.msg.select.part"/>")
			return false;
		}
		getKeywordData();
	});
	
	$('#searchStrKeyword').enter(function(){ 
		var rows = gridGroup.getSelectedRows();
		if( rows == "" ) {
			alert("<s:message code="keyword.msg.select.part"/>")
			return false;
		}
		getKeywordData();
	});
	
	$('#groupSavePopBtn').click(function(){
		if( $('#groupName').val().ltrim().rtrim() == '' ) {
			ui.alertMsg('<s:message code="keyword.message.part_name"/>');
			$('#groupName').focus();
			return false;
		}
		var mode = $('#keywordGroupPop').attr('mode');
		var message = mode=='insert' ? '<s:message code="common.msg.add"/>' : '<s:message code="common.msg.modify"/>'; 
		var confirm_msg = mode=='insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
		ui.confirmMsg(confirm_msg, '', '', function(rs){
			if(rs){
				gridGroup.on();
				ui.post({
					url :mode=='insert' ? 'insertKeywordGroup.xcn' : 'updateKeywordGroup.xcn',
					data : $('#keywordGroupPopForm').serializeAll(),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						$('#keywordGroupPop').modal('hide');
						getGroupData ( );
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						gridGroup.off();
					}
				});
			}
		});
	});
	
	$('#groupInsertBtn').click(function(){
		$('#keywordGroupPop input[type=text]').val('');
		$('[name=useYn][value=Y]').prop('checked',true);
		$('#keywordGroupPop').modal('show');
		$('#keywordGroupPop').attr('mode','insert');
		setTimeout(function(){
			$("#groupName").focus();
		}, 500);	
	});
	
	$('#groupDeleteBtn').click(function(){
		var rows = gridGroup.getSelectedRows();
		if( rows == '' ) {
			ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
			return false;
		}
		var names = gridGroup.getSelectedKey('groupName');
		ui.confirmMsg( '<s:message code="common.msg.confirm.deleteitem" arguments="'+names+'" argumentSeparator="|"/>', '', '', function(rs){
			if(rs){
				gridGroup.on();
				ui.get({
					url : 'deleteKeywordGroup.xcn',
					deleteData : JSON.stringify(rows),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.deleted"/>');
						getGroupData ();
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						gridGroup.off();
					}
				});
			}
		});
	});
	
	$('#keywordSavePopBtn').click(function(){
		var keywordStr = $('#keywordName').val().ltrim().rtrim();
		if( keywordStr == '' ) {
			ui.alertMsg('<s:message code="keyword.message.insert"/>');
			$('#keywordName').focus();
			return false;
		}
		if( keywordStr.length == 1 ) {
			ui.alertMsg('<s:message code="keyword.message.aword"/>');
			return false;
		}
		if( keywordStr.indexOf(' ') > -1 ) {
			ui.alertMsg('<s:message code="keyword.message.wordspacing"/>');
			return false;
		}
		var mode = $('#keywordPop').attr('mode');
		
		var message = mode=='insert' ? '<s:message code="common.msg.add"/>' : '<s:message code="common.msg.modify"/>';
		var confirmMessage = mode=='insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
		ui.confirmMsg(confirmMessage, '', '', function(rs){
			if(rs){
				gridKeyword.on();
				ui.post({
					url :mode=='insert' ? 'insertKeyword.xcn' : 'updateKeyword.xcn',
					data : $('#keywordPopForm').serializeAll(),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.saved"/>');
						$('#keywordPop').modal('hide');
						getKeywordData ( );
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						gridKeyword.off();
						
					}
				});
			}
		});
	});
	
	$('#keywordInsertBtn').click(function(){
		if(gridGroup.getSelectedRows().length < 1) {
			alert("<s:message code="keyword.msg.select.part"/>")
			return false;
		}
		
		var selGroupSeq = gridGroup.getRowData(gridGroup.Row).groupSeq;
		var selGroupName = gridGroup.getRowData(gridGroup.Row).groupName;
		
		$('#keywordPop input[type=text]').val('');
		$('#keyGroupSeq').val(selGroupSeq);
		$('#keyGroupName').val(selGroupName);
		$('#keywordPop').attr('mode','insert');
		$('#keywordPop').modal('show');
		setTimeout(function(){
			$("#keywordName").focus();
		}, 500);	
	});
	
	$('#keywordDeleteBtn').click(function(){
		var rows = gridKeyword.getSelectedRows();
		if( rows == '' ) {
			ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
			return false;
		}
		var names = gridKeyword.getSelectedKey('keywordName');
		ui.confirmMsg( '<s:message code="common.msg.confirm.deleteitem" arguments="'+names+'" argumentSeparator="|"/>', '', '', function(rs){
			if(rs){
				gridKeyword.on();
				ui.get({
					url : 'deleteKeyword.xcn',
					deleteData : JSON.stringify(rows),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.deleted"/>');
						getKeywordData ( );
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						gridKeyword.off();
					}
				});
			}
		});
	});
	
	$('#uploadBtn').click(function(){
		$('#uploadPop').modal('show');
	});
	
	$('.uploadPopBtn').click(function(){
		importKeyword();
	});
	
	$("[name=attach]").change(function (){
		fileExtCheck($(this));
	});
	
	getGroupData ();
	
});

function getGroupData( flag ) {
	if ( searchFlag ) return false;
	
	if ( flag == undefined ) {
		gridGroup.data.length = 0;
		gridGroup.loadingPage = 0;

	} else {
		gridGroup.loadingPage++;
	}

	searchFlag = true;
	gridGroup.on();
	ui.get({
		url : 'getKeywordGroupList.xcn',
		searchStr : $('#searchStrGroup').val(),
		//offset : gridGroup.data.length,
		//limit : gridGroup.pageSize,
		success : function(data, total) {
			if ( flag == 'Y' || flag == undefined ) resultTotal = total;
			gridGroup.appendData(data);
			
			if ( gridGroup.loadingPage == 0 ) gridGroup.Select(-1,-1);
			$('#group_cnt').html("<s:message code="common.msg.listcount"/>: "+gridGroup.data.length);
			KeywordDataClear();
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			gridGroup.off();
			searchFlag = false;
		}
	});
}

function KeywordDataClear() {
	gridKeyword.data.remove(0, gridKeyword.data.length);
	gridKeyword.render();
	$('#keyword_cnt').html("");
	gridKeyword.initData('<s:message code="keyword.message.part_select"/>');
}

function getKeywordData( flag ) {
	if ( searchFlag ) return false;
	
	var selGroupSeq = gridGroup.getRowData(gridGroup.Row).groupSeq;
	var selGroupName = gridGroup.getRowData(gridGroup.Row).groupName;
	
	if ( flag == undefined ) {
		gridKeyword.data.length = 0;
		gridKeyword.rtnNextPageFunc = getKeywordData;
		gridKeyword.loadingPage = 0;
	} else {
		gridKeyword.loadingPage++;
	}
	searchFlag = true;
	gridKeyword.on();
	ui.get({
		url : 'getKeywordList.xcn',
		searchStr : $('#searchStrKeyword').val(),
		searchGroupSeq : selGroupSeq,
		searchGroupName : selGroupName,
		//offset : gridKeyword.data.length,
		//limit : gridKeyword.pageSize,
		success : function(data, total) {
			if ( flag == 'Y' || flag == undefined ) //keywordTotal = total;
			gridKeyword.appendData(data);
			
			if ( gridKeyword.loadingPage == 0 ) gridKeyword.Select(-1,-1);
			$('#keyword_cnt').html("<s:message code="common.msg.listcount"/>: "+gridKeyword.data.length);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			gridKeyword.off();
			searchFlag = false;
		}
	});
}

function importKeyword() {
	$('#uploadForm').attr('action', '<c:url value="/importKeyword.xcn"/>');
	
	var attach = $('[name=attach]').val();
	if(attach == "") {
		ui.alertMsg('<s:message code="keyword.msg.upload.file"/>', function () { $("#attach").click(); });
		return;
	}
	
	var fileExt = attach.substring( attach.lastIndexOf( "." )+1, attach.length ).toLowerCase( );
    $('#importGroupSeq').val(gridGroup.getValue(gridGroup.Row, "groupSeq"));

	ui.confirmMsg('<s:message code="keyword.upload.confirm"/>', '', '', function(rs){
		if(rs){
			loadingOn("uploadPop");
			$("#uploadForm").ajaxForm({
				target : '#upload_file',
				beforeSubmit: function() {
					$('#attachSpan').html('<input type="file" class="form-control" name="attach" id="attach" style="width: 350px; border: 0px;">');
					$('#attach').change(function (){fileExtCheck($('#attach'));});
				},
				success: function(result) {
					if(result.success) {
						ui.alertMsg('<s:message code="keyword.upload.ok"/>');
						$('#uploadPop').modal('hide');
						getGroupData ();
					} else {
						ui.alertMsg(result.message);
					}
				},
				error : function(){
					ui.alertMsg('<s:message code="keyword.upload.error"/>');
				},
				complete : function(){
					loadingOff("uploadPop");
				}
			}).submit();
		}
	});
}

function loadingOn(id) {
	
	var obj = $('#' + id);
	var hei = obj.height();
	$(obj).append( '<div class="loading_div"><i class="fa fa-spinner fa-spin fa-3x fa-fw" style="margin-top:'+(hei/2.5)+'px"></i></div>');
	$('.loading_div').css({
		"position" : "absolute",
		"top" : "0px",
		"left" : "15px",
		"right" : "15px",
		"bottom" : "20px",
		"background-color" : "#F0F0F0",
		"opacity" : "0.3",
		"z-index" : "998",
		"text-align" : "center"
	});
}

function loadingOff(id) {
	var obj = $('#' + id + ' .loading_div');
	obj.remove();
}

function fileExtCheck(obj) {
	var fileName = obj.val();
	var fileExt = fileName.substring( fileName.lastIndexOf( "." )+1, fileName.length ).toLowerCase( );
	if ( !(fileExt == "txt" || fileExt == "text" || fileExt == "csv" || fileExt == "xlsx")) {
		ui.alertMsg('<s:message code="keyword.msg.fileext"/>');
		$('#attachSpan').html('<input type="file" class="form-control" name="attach" id="attach" style="width: 350px; border: 0px;">');
		$('#attach').change(function (){fileExtCheck($('#attach'));});
	}
}
</script>

<div class="modal" id="keywordGroupPop" aria-labelledby="keywordGroupPop" tabindex="-1" role="dialog">
	<div class="modal-content">
		<form method="post" id="keywordGroupPopForm" onsubmit="return false;">
			<div class="modalHead">
				<h2><s:message code="keyword.msg.part_mgnt"/>-<s:message code="common.msg.addmodify"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3>예약어 그룹 추가</h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						필수 입력 사항입니다.
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="groupName" class="fname"><s:message code="keyword.msg.part_name"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="groupName" id="groupName" maxlength="55">
							<input type="hidden" class="w100" name="groupSeq" id="groupSeq">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="useYn" class=""><s:message code="common.msg.useyn"/></label>
							<span class="red_dot"></span>
						</div>
						<label class="radio-inline c-radio">
							<input type="radio" name="useYn" value="Y" checked>
							<s:message code="common.msg.use"/>
						</label>
						<label class="radio-inline c-radio">
							<input type="radio" name="useYn" value="N">
							<s:message code="common.msg.unuse"/>
						</label>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="groupSavePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>

<div class="modal" id="keywordPop"  tabindex="-1" role="dialog" aria-labelledby="keywordPop">
	<div class="modal-content">
		<form method="post" id="keywordPopForm">
			<div class="modalHead">
				<h2><s:message code="DATA_MONITOR.KEYWORD_MGMT"/>-<s:message code="common.msg.addmodify"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3>예약어 그룹 추가</h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						필수 입력 사항입니다.
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="groupName" class="fname"><s:message code="keyword.msg.part_name"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="groupName" id="keyGroupName"  readonly="readonly">
							<input type="hidden" class="w100" name="groupSeq" id="keyGroupSeq">
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="keywordName" class="fname"><s:message code="keyword.msg.keyword"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="keywordName" id="keywordName" maxlength="60">
							<input type="text" class="w100" name="keywordSeq" id="keywordSeq">
						</div>
					</div>

					<div class="row">
						<div class="col-35">
							<label for="keywordDesc" class="fname"><s:message code="keyword.msg.comment"/></label>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="keywordDesc" id="keywordDesc" maxlength="60">
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="keywordSavePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>

<div id="upload_file"></div>
<div class="modal" id="uploadPop" aria-labelledby="uploadPop">
	<div class="modal-content">
		<form method="post" id="uploadForm" enctype="multipart/form-data" target="upload_file">
			<div class="modalHead">
				<h2><s:message code="DATA_MONITOR.KEYWORD_MGMT"/>-<s:message code="keyword.msg.upload"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="encoding" class="fname"><s:message code="bodyview.charset"/></label>
						</div>
						<div class="col-65">
							<select class="optiotab" id="encoding" name="encoding">
								<option value="utf-8">UTF-8</option>
								<option value="euc-kr">EUC-KR</option>
							</select>
							<input type="hidden" class="" name="importGroupSeq" id="importGroupSeq" maxlength="300">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="keywordDesc" class="fname"><s:message code="keyword.select.file"/></label>
						</div>
						<div class="col-65">
							<span id="attachSpan"><input type="file" class="form-control" name="attach" id="attach" style="width: 350px; border: 0px; padding: 0px;"></span>
						</div>
					</div>
				</div>
				<div class="info"> 안내 사항
					<div class="form-inline" style="padding-left: 10px;">1) <s:message code="interest.message.upload.info1"/></div>
					<div class="form-inline" style="padding-left: 10px;">2) <s:message code="interest.message.upload.info2"/></div>
					<div class="form-inline" style="padding-left: 10px;">3) <s:message code="interest.message.upload.info3"/></div>
					<div class="form-inline" style="padding-left: 10px;">4) <s:message code="interest.message.upload.info4"/></div>
					<div style="padding-left: 10px;">5) <s:message code="interest.message.upload.info5"/></div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>


<div class="container">
	<div class="searchArea">
		<div style="width:470px; float: left">
			<div class="searchSub" style="width: 470px;">
				<div>
					<input type="text" placeholder="<s:message code="keyword.message.part_name"/>" id="searchStrGroup" style="width: 220px;">
					<button class="form_btn01" type="button" accesskey="G" id="searchGroupBtn">검색</button>
				</div>
				<div class="btnform">
				<button type="button" class="btn01" accesskey="I" id="groupInsertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
				<button type="button" class="btn02" accesskey="D" id="groupDeleteBtn"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
				</div>
				</div>
			<div class="content xcn_full" style="background-color: transparent">
				<div class="contentSub" style="padding: 0px;">
					<div id="keywordGroupListGrid" class="slickGrid gridArea"></div>
				</div>
			</div>
		</div>

		<div style="width:calc(100% - 470px); padding-left: 16px; float: left">
			<div class="searchSub" style="width:calc(100% - 470px) ">
				<div>
					<input type="text" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStrKeyword" style="width: 280px;">
					<button class="form_btn01" type="button" accesskey="K" id="searchStrKeywordBtn">검색</button>
				</div>
				<c:if test="${_USERCREDENTIAL_.firstAdminYn eq 'Y'}">
				<div class="btnform">
					<button type="button" class="btn01" accesskey="A" id="keywordInsertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
					<button type="button" class="btn02" accesskey="E" id="keywordDeleteBtn"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
					<button type="button" class="btn03" accesskey="U" id="uploadBtn"><img src="<c:url value="/img/subBtn_upload.png"/>" alt="업로드">Upload</button>
				</div>
				</c:if>
			</div>
			<div class="content xcn_full" style=" background-color: transparent">
				<div class="contentSub " style="padding:0 ">
					<div id="keywordListGrid" class="slickGrid gridArea"></div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
	<script type="text/javascript">
		var gridGroup = new Xgrid('keywordGroupListGrid', contextRoot);
		gridGroup.onCheckBox();
		gridGroup.autoNumber();
		gridGroup.colAdd('groupName', '<s:message code="keyword.msg.partnm"/>', 183, 'left', false, 'nomal');
		gridGroup.colAdd('useYn', '<s:message code="common.msg.useyn"/>', 100, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
			if(value=='Y') return '<s:message code="common.msg.use"/>';
			else if(value=='N') return '<s:message code="common.msg.unuse"/>';
			return '-';
		});
		if( $('#groupInsertBtn').css('display') == 'inline-block' ) {
			gridGroup.colAdd('open', '<s:message code="common.msg.modify"/>', 80, 'center', false, 'noal',function(row, cell, value, columnDef, dataContext ) {
				 return "<input type='button' value='<s:message code="common.msg.modify"/>' class='table_btn01' style='line-height: 0px; color:white; vertical-align: 1px; font-weight:bold;'/>";
			});
		}
		gridGroup.loadExportMenu('<s:message code="keyword.msg.part_mgnt"/>');
		gridGroup.loadHeader(false);
		<%--//gridGroup.initData('<s:message code="common.msg.search.click"/>');--%>
		
		gridGroup.onClick = function() {
			if (gridGroup.Col == gridGroup.ColIndex('open') && $('#groupInsertBtn').css('display') == 'inline-block') {
				var data = gridGroup.getRowData(gridGroup.Row);

				$('#groupSeq').val(data.groupSeq);
				$('#groupName').val(data.groupName);
				$('[name=useYn][value='+data.useYn+']').prop('checked',true);

				$('#keywordGroupPop').attr('mode','modify');
				$("#groupName").focus();
				$('#keywordGroupPop').modal('show');
			}
		}
		gridGroup.onActiveCellChanged = function() {
			getKeywordData();
		}
		
		var gridKeyword = new Xgrid('keywordListGrid', contextRoot);
		gridKeyword.onCheckBox();
		gridKeyword.autoNumber();
		gridKeyword.colAdd('keywordName', '<s:message code="keyword.msg.keyword"/>', 200, 'center', false, 'link');
		gridKeyword.colAdd('keywordDesc', '<s:message code="common.msg.comment"/>', 250, 'center', false, 'nomal');
		gridKeyword.onClick = function() {
			if (gridKeyword.Col == gridKeyword.ColIndex('keywordName')) {
				var data = gridKeyword.getRowData(gridKeyword.Row);
				
				$('#keyGroupSeq').val(data.groupSeq);
				$('#keyGroupName').val(data.groupName);
				$('#keywordSeq').val(data.keywordSeq);
				$('#keywordName').val(data.keywordName);
				$('#keywordDesc').val(data.keywordDesc);
				
				$('#keywordPop').attr('mode','modify');
				$("#keywordName").focus();
				$('#keywordPop').modal('show');
			}
		};
		gridKeyword.loadExportMenu('<s:message code="DATA_MONITOR.KEYWORD_MGMT"/>');
		gridKeyword.loadHeader(false);
		gridKeyword.initData('<s:message code="keyword.message.part_select"/>');
	</script>
