<style type="text/css">
	#leftTab .active a{
		background-color: #5FA2DD;
		border:1px solid #ddd;
		border-bottom:0;
		color:#fff;
		box-shadow: none;
	}
	#leftTab .active a:hover{
		background-color: #5FA2DD;
		color:#fff;

	}
	#leftTab li:hover {

	}
	#leftTab li a{
		border:1px solid #ddd;
		border-bottom:0;
		background-color:#fff;
		color:#000;
		box-shadow: inset 0 -8px 7px -9px rgba(0,0,0,.4);
		padding:5px 15px;
	}
	#leftTab li a:hover{
		background-color: #eee;
		color:#000;
	}
	.tabbable{
		height:100%;
	}


	#selectedCodeTitle, #selectedCodeTitlePop {
		display:none;
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

	.bootstrap-select.btn-group[class*=col-] .dropdown-menu.open {
		left: 0;
		right: auto;
	}

	.selecBtnArea .btn, .select-xs .btn {
		padding: 6px 25px 5px 10px;
		font-size: 12px;
	}

	.selecBtnArea .bootstrap-select {
		margin-bottom: 2px;
	}

	.bootstrap-select{
		display:inline-block;
	}
	.bootstrap-select button{
		border-radius:0;
	}

	#smartFilterSavePop .form-inline:not(.not-dashed) {
		border-bottom: 1px dashed #eee;
		padding: 7px 0px;
	}

	.input-xs {
		height: 22px;
		padding: 2px 5px;
		font-size: 12px;
		line-height: 1.5;
		border-radius: 3px;
	}

	#tab0 .form-inline:not(.not-dashed) {
		border-bottom: 1px dashed #eee;

	}

	#tab0 .not-dashed {
		padding-bottom: 0px !important;
	}

	#tab0 .form-inline {
		padding: 3px 0px;
		min-height: 1px;
		width: 100%;
		float: left;
	}

	#tab0 .btn-group-xs>.btn, .btn-xs {
		padding: 4px 5px;
		font-size: 12px;
		line-height: 1.5;
		border-radius: 3px;
	}

	#tab0 .input-xs {
		height: 28px;
		padding: 2px 5px;
		font-size: 12px;
		line-height: 1.5;
		border-radius: 3px;
	}

	.filterHeader{
		width:160px;
		float:left;
	}

	.filterHeader2{
		width:100px;
		float:left;
	}

	#filterNamePopInput.form-control:focus,#queryInputTextareaPop:focus{
		border-color: #4d90fe;
		outline: 0;
		-webkit-box-shadow: none;
		box-shadow: none;
		border-radius: 2px;
		border-width: 0.9px;
	}
	#filterNamePopInput.form-control,#queryInputTextareaPop{
		border-color: #ccc;
		outline: 0;
		-webkit-box-shadow: none;
		box-shadow: none;
		border-radius: 2px;
	}
	.bootstrap-select [data-id=serviceTypePop],.bootstrap-select [data-id=busiPop] {
		height: 23px;
		line-height : 23px;
		vertical-align: top;
		border-radius: 0;
	}
	.bootstrap-select [data-id=serviceTypePop] > span,.bootstrap-select [data-id=busiPop] > span {
		line-height: 23px;
		font-family: dotum, Verdana, arial, sans-serif;
	}
	#dashboardsetupArea .btn,#filterTypeArea .btn {
		border-radius:0;
	}
	.dropdown-menu {
		max-height: 500px;
		overflow-y: auto;
	}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		$('[data-id="serviceTypePop"] , [data-id="busiPop"]').css('width','260px');
		$('#serviceTypePop , #busiPop').selectpicker({
			container:'body',
			size: 15,
			width:'260px',
			noneResultsText:condition.msgNoresult+' ',
			selectAllText:condition.msgSelect_all,
			deselectAllText:condition.msgUnselect_all
		});
		var dateObj = new Date();
		$('#startdatepickerPop').datetimepicker({
			format: 'YYYY-MM-DD HH:mm:ss',
			locale: 'ko',
			sideBySide: true,
			defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-1 ) ),
		}).on("dp.change", function (e) {
		});
		$('#enddatepickerPop').datetimepicker({
			format: 'YYYY-MM-DD HH:mm:ss',
			locale: 'ko',
			sideBySide: true,
			defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-1 ) ),
		}).on("dp.change", function (e) {
		});
		$('.startDateBtn').click(function(){
			$('#startdatepickerPop').focus();
		});
		$('.endDateBtn').click(function(){
			$('#enddatepickerPop').focus();
		});
		$('#smartFilterSavePop').on('show.bs.modal', function() {
			var value = $('input:radio[name=filterTypePop]:input:checked').val();
			if( value == 'D'){
				$('#selectConditionPopArea').show();
				$('#selectQueryPopArea').hide();
			}else{
				$('#selectConditionPopArea').hide();
				$('#selectQueryPopArea').show();
			}
			var value_attached = $('#sizeOptionPop option:selected').val();
			if(value_attached=='over'){
				$('#sizeEndValPop').attr('disabled','disabled');
			}else if(value_attached=='under'){
				$('#sizeEndValPop').attr('disabled','disabled');
			}else{
				$('#sizeEndValPop').removeAttr('disabled');
			}

		});
		$('#sizeOptionPop').change(function () {
			var value_attached = $("#sizeOptionPop option:selected").val();
			if(value_attached=='over'){
				$('#sizeEndValPop').attr('disabled','disabled');
			}else if(value_attached=='under'){
				$('#sizeEndValPop').attr('disabled','disabled');
			}else{
				$('#sizeEndValPop').removeAttr('disabled');
			}
		});
		$('input:radio[name=filterTypePop]').change(function () {
			var value = $('input:radio[name=filterTypePop]:input:checked').val();
			if( value == 'D'){
				$('#selectConditionPopArea').show();
				$('#selectQueryPopArea').hide();
			}else{
				$('#selectConditionPopArea').hide();
				$('#selectQueryPopArea').show();

			}
		});
		$('#filterOptionPopSelect').change(function(){
			var val = $(this).val();

			if( val == '1'){
				$('#normalDateArea').show();
				$('#simpleDateArea').hide();
				$('#noselectDateArea').hide();
			}else if( val == '2'){
				$('#normalDateArea').hide();
				$('#simpleDateArea').show();
				$('#noselectDateArea').hide();
			}else if( val == '3'){
				$('#normalDateArea').hide();
				$('#simpleDateArea').hide();
				$('#noselectDateArea').show();
			}
		});


		$('#saveFilterSetup').click(function(){
			if( !$('#msg_condition_menu').hasClass('condition_menu_unselected') ){
				if($('.filterIcon').hasClass('hide')) insertAdminFilterData();
				else updateAdminFilterData();
			}else if(!$('#msg_condition_saver').hasClass('condition_menu_unselected')){
				if($('.queryIcon').hasClass('hide')) insertAdminFilterData();
				else updateAdminFilterData();
			}
		});
	});
	var filter={
		msgConnectError:'<s:message code="common.msg.connect.error"/>',
		add:'<s:message code="filterInfo.filter.add"/>',
		filterNew:'<s:message code="message.msg.newCondition"/>',
		folderNew:'<s:message code="filterInfo.folder.new"/>',
		folderDelete:'<s:message code="filterInfo.folder.delete"/>',
		msgSelectFile:'<s:message code="filterInfo.incorrect.file"/>',
		msgSaved:'<s:message code="common.msg.saved"/>',
		msgSaveError:'<s:message code="common.msg.save.error"/>',
		msgImportData:'<s:message code="filterInfo.msg.import.data"/>',
		msgExportData:'<s:message code="filterInfo.msg.export.data"/>',
		msgFilterDelete:function(param){
			return '<s:message code="filterInfo.msg.filter.delete" arguments="'+param+'" />';
		},
		msgfolderDelete:function(param){
			return '<s:message code="filterInfo.msg.folder.delete" arguments="'+param+'" />';
		},
		msgAllDelete:function(param){
			return '<s:message code="filterInfo.msg.all.delete" arguments="'+param+'" />';
		},
		selectMsg:'<s:message code="filterInfo.selectMsg"/>',
		selectDelMsg:'<s:message code="filterInfo.selectDelMsg"/>',
		selectMsgFolder:'<s:message code="filterInfo.selectMsgFolder"/>'
	};

	function openCodeWindow(id, oldCode, oldConm){
		$('#oldCode').val(oldCode);
		$('#oldConm').val(oldConm);

		var url    = '<c:url value="/commons/selectCode.do?codeType='+id+'"/>';
		fnOpenWindow('', 'selectCodeWinPopup', 1200, 700, 'resize');

		$('#codeParam').attr('target','selectCodeWinPopup');
		$('#codeParam').attr('action', url);
		$('#codeParam').attr('method','post');
		$('#codeParam').submit();
	}

	function rtnFilterClick(filterVal, type){
		if($("#searchBox").is(":checked")) addTab();

		if( type == 'searchCondition'){
			$('#msg_condition_menu').click();
			if(filterVal.conditions.length > 1){
				var filter = $.extend(true, {}, filterVal);
				filter.conditions.remove(filter.conditions.length-1);
				getIframeListObj().filterValData = filter;
			}
			con.setFilterVal(filterVal);
			//con.setCondition(filterVal.conditions[filterVal.conditions.length-1], '');
			$('.filterIcon').removeClass('hide');
			$('.filterIcon').attr('title', filterVal.name);
			$('.filterIcon').attr('data-id', filterVal.id);

			if($("#searchBox").is(":checked")) searchData();

		}
		else if( type == 'searchQuery'){
			con.resetFilter('');
			$('#msg_condition_saver').click();
			var query = filterVal.conditions[0].query;
			$('#solrQueryText').val(query);
			$('.queryIcon').removeClass('hide');
			$('.queryIcon').attr('title', filterVal.name);
			$('.queryIcon').attr('data-id', filterVal.id);

			if($("#searchBox").is(":checked")) toggleSolrQuery();
		}
	}


</script>
<div id="selectedCodeTitle"></div>
<input type="hidden" id="filterName" />
<input type="hidden" id="filter_seq" />
<input type="hidden" id="p_filter_seq" />
<div id="rMenu" style="z-index:99999;">
	<ul>
		<li style="background-color:#1576A1;color:#fff;font-weight: bold;cursor:default;"><s:message code="filterInfo.menu.filter"/></li>
	</ul>
	<ul>
		<li id="filter_export" onclick="exportFilter('<c:url value="/exportAdminFilter.xcn"/>')">
			<img alt="" src="<c:url value="/img/ztree/export.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="common.msg.export"/></span>
		</li>
		<li id="filter_import" onclick="importFilter()">
			<img alt="" src="<c:url value="/img/ztree/import.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="common.msg.import"/></span>
		</li>
		<li id="folder_new" onclick="addFilterFolder();">
			<img alt="" src="<c:url value="/img/ztree/open_folder.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.folder.new"/>(F)</span>
		</li>
		<li id="folder_rename" onclick="editFilterName();">
			<img alt="" src="<c:url value="/img/ztree/open_folder.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.change.name"/>(M)</span>
		</li>
		<li id="folder_delete" onclick="deleteFilter();">
			<img alt="" src="<c:url value="/img/ztree/open_folder.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="common.msg.delete"/>(D)</span>
		</li>

		<li id="filter_new" onclick="saveFilterOnTree('add');">
			<img alt="" src="<c:url value="/img/ztree/filter.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.filter.new"/>(A)</span>
		</li>
		<li id="filter_rename" onclick="editFilterName();">
			<img alt="" src="<c:url value="/img/ztree/filter.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.change.name"/>(M)</span>
		</li>
		<li id="filter_update" onclick="saveFilterOnTree('modify');">
			<img alt="" src="<c:url value="/img/ztree/edit.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.filter.update"/>(U)</span>
		</li>
		<li id="filter_delete" onclick="deleteFilter();">
			<img alt="" src="<c:url value="/img/ztree/delete.png"/>" style="vertical-align: middle;width: 16px;height: 14px;">
			<span><s:message code="filterInfo.filter.delete"/>(D)</span>
		</li>


		<li id="f_folder_new" onclick="addFolderFolder();">
			<img alt="" src="<c:url value="/img/ztree/open_folder.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.folder.new"/>(F)</span>
		</li>
		<li id="f_folder_rename" onclick="editFolderName();">
			<img alt="" src="<c:url value="/img/ztree/open_folder.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.change.name"/>(M)</span>
		</li>
		<li id="f_folder_delete" onclick="deleteFolder();">
			<img alt="" src="<c:url value="/img/ztree/open_folder.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="common.msg.delete"/>(D)</span>
		</li>

		<%-- <li id="f_data_new" onclick="saveFolderOnTree('add');">
			<img alt="" src="<c:url value="/img/ztree/msgFolder_empty.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.folderAdd"/>(A)</span>
		</li> --%>
		<%-- <li id="f_data_rename" onclick="editFolderName();">
			<img alt="" src="<c:url value="/img/ztree/msgFolder_empty.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.change.name"/>(M)</span>
		</li> --%>
		<%-- <li id="f_data_delete" onclick="deleteFolder();">
			<img alt="" src="<c:url value="/img/ztree/delete.png"/>" style="vertical-align: middle;width: 16px;height: 14px;">
			<span><s:message code="filterInfo.folderDelete"/>(D)</span>
		</li> --%>


	</ul>
</div>

<div id="periodMenu">
	<div style="height:30px;background-color:#253f56;color:#fff;padding-left:10px;line-height:30px;font-weight: bold;cursor:default;">
		<div style="float:left;width:200px;">
			<i class="glyphicon glyphicon-calendar"></i>&nbsp;<s:message code="filterInfo.period.setting"/>
		</div>
		<div style="float:right;padding-right:8px;">
			<span class="glyphicon glyphicon-remove" style="cursor:pointer;" id="periodMenuCloseBtn"></span>
		</div>
	</div>
	<div style="width:100%;padding:10px 10px 0px 10px;">
		<div style="height:25px;">
			<s:message code="filterInfo.message.period"/>
		</div>
		<div class="form-group form-inline" style="width:100%;">
			<div class="input-group" style="width:50px;font-weight: bold;">
				<s:message code="condition.period"/>
			</div>
			<div class="input-group">
				<div class="input-group date" id="startdatepickerAdd" style="width:170px;">
					<input type="text" id="startDtAdd" class="input-sm form-control" />
					<span class="input-group-addon startDateBtnAdd" style="padding: 0px 5px;"> <span class="glyphicon glyphicon-calendar"></span>
					</span>
				</div>
			</div>
			<span>~</span>
			<div class="input-group">
				<div class="input-group date" id="enddatepickerAdd" style="width:170px;">
					<input type="text" id="endDtAdd" class="input-sm form-control"/>
					<span class="input-group-addon endDateBtnAdd" style="padding: 0px 5px;"><span class="glyphicon glyphicon-calendar"></span></span>
				</div>
			</div>
		</div>
	</div>
	<div style="text-align: center;">
		<button type="button" class="btn btn-sm btn-primary" accesskey="T" id="dateSearch" style="font-size:12px;"><i class="glyphicon glyphicon-search"></i>&nbsp;<s:message code="filterInfo.period.apply"/></button>
	</div>
</div>
<div id="periodSetupMenu">
	<div style="height:30px;background-color:#253f56;color:#fff;padding-left:10px;line-height:30px;font-weight: bold;cursor:move;">
		<div style="float:left;width:205px;">
			<i class="glyphicon glyphicon-calendar"></i>&nbsp;<s:message code="filterInfo.newTitle"/>
		</div>
		<div class="filterDateCloseBtn" style="float:right;padding-right:8px;">
			<span class="glyphicon glyphicon-remove" style="cursor:pointer;" id="periodSetupMenuCloseBtn"></span>
		</div>
	</div>
	<div class="filterDatePopArea" style="width:100%;padding:10px 10px 0px 10px;">
		<div class="form-inline">
			<span><s:message code="filterInfo.msg.msgInfo"/></span>
		</div>
		<div class="form-inline">
			<label for="filterNamePopInput" class="control-label filterHeader2"><s:message code="condition.name"/></label>
			<input type="text" class="form-control" style="width:380px;" name="attachName" id="filterNamePopInput" placeholder="<s:message code="condition.name"/>" required maxlength="128">
		</div>
		<div class="form-inline" id="periodSetupPop">
			<label for="datePopArea" class="control-label filterHeader2"><s:message code="condition.period"/></label>
			<div id="datePopArea" style="padding-right:15px;">
				<select name="searchArea" class="condition_select" id="filterOptionPopSelect">
					<option value="1"><s:message code="condition.period.default"/></option>
					<option value="2"><s:message code="condition.period.change"/></option>
					<option value="3"><s:message code="condition.period.input"/></option>
				</select>
			</div>
		</div>
		<div class="form-inline" id="periodSetupDatePop">
			<label for="dateSelectArea" class="control-label filterHeader2"><s:message code="condition.period.setting"/></label>
			<div id="dateSelectArea">
				<div id="normalDateArea">
					<div class="input-group date col-xs-3" id="startdatepickerPop">
						<input type="text" id="startdatepickerPop" class="input-xs form-control border-radius-none" style="padding: 1px 0px 0px 3px; width: 147px; text-align: center; border-radius: 0;"/>
						<span class="input-group-addon startDateBtn" style="padding:2px 8px; border-radius:0;"> <span class="glyphicon glyphicon-calendar"></span></span>
					</div>
					<span>~</span>
					<div class="input-group date col-xs-3" id="enddatepickerPop">
						<input type="text" id="enddatepickerPop" class="input-xs form-control border-radius-none"  style="padding: 1px 0px 0px 3px; width: 147px; text-align: center; border-radius: 0;"/>
						<span class="input-group-addon endDateBtn" style="padding:2px 8px; border-radius:0;"> <span class="glyphicon glyphicon-calendar"></span></span>
					</div>
				</div>
				<div id="simpleDateArea" style="display:none;">
					[<s:message code="condition.standard"/>]
					<input type="text" class="input-xs form-control" id="startDayPop" style="padding:2px 5px;position: relative;width:40px;"/> <s:message code="condition.before"/> ~
					<input type="text" class="input-xs form-control" id="endDayPop" style="padding:2px 5px;position: relative;width:40px;"/> <s:message code="condition.before"/>
				</div>
				<div id="noselectDateArea" style="display:none;height:23px;">
					<span style="height:23px;line-height: 23px;"><s:message code="condition.message.input"/></span>
				</div>
			</div>
		</div>
	</div>
	<div class="filterDateBtnPopArea" style="text-align: center;">
		<button type="button" class="btn btn-sm btn-primary" accesskey="T" id="saveFilterSetup" style="font-size:12px;"><i class="glyphicon glyphicon-search"></i>&nbsp;<s:message code="condition.save"/></button>
	</div>
</div>
<div class="modal fade" id="filterImportPop" tabindex="-1" role="dialog" aria-labelledby="filterImportPop">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<form id="filterImportPopForm" method="post" enctype="multipart/form-data" target="upload_file" action="<c:url value="/importAdminFilter.xcn"/>" >
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="common.msg.import.userfilter"/></h3>
				</div>
				<div class="modal-body">
					<div class="form-inline">
						<label for="ruleFile" class="control-label col-xs-3" style="vertical-align: bottom;"><s:message code="didBlock.select.file"/></label>
						<div id="ruleFile_div">
							<input type="file" class="form-control" name="file" id="file" style="width: 300px;">
						</div>
					</div>
				</div>
			</form>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
				<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="saveAdminFilterBtn"><s:message code="common.msg.save"/></button>
			</div>
		</div>
	</div>
	<iframe id="upload_file" name="upload_file" src="" style="display: none;"></iframe>
</div>
<div class="modal fade smartFolderSave" id="smartFolderSavePop" tabindex="-1" data-backdrop="static" data-keyboard="false" role="dialog" aria-labelledby="attachModal">
	<input type="hidden" id="modalFolderType"/>
	<div class="modal-dialog modal-lg" role="document" style="width:700px;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title"><s:message code="filterInfo.setMsgFolder"/></h3>
			</div>
			<div class="modal-body">
				<div class="form-inline" id="saveFolderPathPopDiv">
					<label for="savePathPopArea" class="control-label col-xs-2"><s:message code="condition.savepath"/></label>
					<div class="form-control" id="saveFolderPathPopArea" style="height:350px;width:500px;">
						<ul id="folderTreePop" class="ztree scrollbar" style="height:100%;width:100%;overflow:auto;"></ul>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="saveFolderBtn"><s:message code="common.msg.save"/></button>
				<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
			</div>
		</div>
	</div>
</div>
<form method="post" id="exportDownForm">
	<input type="hidden" id="filter_ids" name="filter_ids"/>
</form>
<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"/>
	<input type="hidden" name="oldConm" id="oldConm"/>
</form>