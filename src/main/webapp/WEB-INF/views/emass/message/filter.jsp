<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<link rel="stylesheet" href="<c:url value="/css/zTreeStyle.css"/>"/>

<script type="text/javascript" src="<c:url value="/js/jquery.ztree.all-3.5.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ztree.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ztreeRMenu.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/filter.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/folder.js"/>"></script>

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
</style>
<script type="text/javascript">
var filter={
	msgConnectError:'<s:message code="common.msg.connect.error"/>',
	add:'<s:message code="filterInfo.filter.add"/>',
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

function rtnFilterClick(filterVal, type){
	addTab(filterVal, type);
}

</script>
<div class="row" style="width:240px;height: calc(100% - 80px); margin-left: 5px;">
	<div class="col-sm-12" style="padding-left:0px;height:100%;">
		<div class="panel panel-default with-nav-tabs panel-primary tab_header" style="height:100%;padding-bottom:2px;border-color:#ddd;">
			<div class="panel-heading2" style="height:34px; background-color: #337ab7;">
				<div class="filterTab" style="width:160px; position: relative; top: 8px;">
					<i class="glyphicon glyphicon-tags pull-left"></i>&nbsp;&nbsp;<s:message code="common.msg.box"/>
				</div>
			</div>
			<div class="panel-body tab-content" style="width:100%;height:calc(100% - 34px);padding-top:15px;">
				<div class="tabbable">
					<ul class="nav nav-tabs" id="leftTab">
						<li class="active"><a href="#tab1" data-toggle="tab"><s:message code="filterInfo.filter"/></a></li>
						<li><a href="#tab2" data-toggle="tab"><s:message code="filterInfo.messageFolder"/></a></li>
					</ul>
					<div class="tab-content" style="height:calc(100% - 28px)">
						<div class="tab-pane active" id="tab1">
							<div class="tab-pane fade in active" id="saveFilterTab" style="width:100%;height:100%;">
								<div class="input-group" style="height:25px;">
									<input type="text" class="form-control input-xs" style="position: relative;top:1px;" placeholder=" <s:message code="filterInfo.search.filter"/>" id="filterSearchStr">
									<div class="input-group-btn">
										<button class="btn btn-sm btn-primary input-xs" type="button" id="filterSearchBtn"><i class="glyphicon glyphicon-search"></i></button>
									</div>
								</div>
								<div class="zTreeDemoBackground left" style="clear: both; width:100%;height:calc(100% - 25px);border:1px solid #efefef;">
									<ul id="filterTree" class="ztree scrollbar" style="height:100%;width:100%;overflow:auto;"></ul>
								</div>
							</div>
						</div>
						<div class="tab-pane" id="tab2">
							<div class="tab-pane fade in active" id="saveFolderTab" style="width:100%;height:100%;">
								<div class="input-group" style="height:25px;">
									<input type="text" class="form-control input-xs" style="position: relative;top:1px;" placeholder=" <s:message code="filterInfo.search.filter"/>" id="folderSearchStr">
									<div class="input-group-btn">
										<button class="btn btn-sm btn-primary input-xs" type="button" id="folderSearchBtn"><i class="glyphicon glyphicon-search"></i></button>
									</div>
								</div>
								<div class="zTreeDemoBackground left" style="clear: both; width:100%;height:calc(100% - 25px);border:1px solid #efefef;">
									<ul id="folderTree" class="ztree scrollbar" style="height:100%;width:100%;overflow:auto;"></ul>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div> 
	</div>
</div>
<input type="hidden" id="filterName" />
<input type="hidden" id="filter_seq" />
<input type="hidden" id="p_filter_seq" />
<div id="rMenu">
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
			<img alt="" src="<c:url value="/img/ztree/folder_open.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.folder.new"/>(F)</span>
		</li>
		<li id="folder_rename" onclick="editFilterName();">
			<img alt="" src="<c:url value="/img/ztree/folder_open.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.change.name"/>(M)</span>
		</li>
		<li id="folder_delete" onclick="deleteFilter();">
			<img alt="" src="<c:url value="/img/ztree/folder_open.png"/>" style="vertical-align: middle;width: 16px;">
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
			<img alt="" src="<c:url value="/img/ztree/folder_open.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.folder.new"/>(F)</span>
		</li>
		<li id="f_folder_rename" onclick="editFolderName();">
			<img alt="" src="<c:url value="/img/ztree/folder_open.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.change.name"/>(M)</span>
		</li>
		<li id="f_folder_delete" onclick="deleteFolder();">
			<img alt="" src="<c:url value="/img/ztree/folder_open.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="common.msg.delete"/>(D)</span>
		</li>
		
		<li id="f_data_new" onclick="saveFolderOnTree('add');">
			<img alt="" src="<c:url value="/img/ztree/msgFolder_empty.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.folderAdd"/>(A)</span>
		</li>
		<li id="f_data_rename" onclick="editFolderName();">
			<img alt="" src="<c:url value="/img/ztree/msgFolder_empty.png"/>" style="vertical-align: middle;width: 16px;">
			<span><s:message code="filterInfo.change.name"/>(M)</span>
		</li>
		<li id="f_data_delete" onclick="deleteFolder();">
			<img alt="" src="<c:url value="/img/ztree/delete.png"/>" style="vertical-align: middle;width: 16px;height: 14px;">
			<span><s:message code="filterInfo.folderDelete"/>(D)</span>
		</li>
		
		
	</ul>
</div>

<div id="periodMenu">
	<div style="height:30px;background-color:#1576A1;color:#fff;padding-left:10px;line-height:30px;font-weight: bold;cursor:default;">
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
		<button type="button" class="btn btn-sm btn-primary" accesskey="T" id="dateSearch" style="font-size:12px;"><i class="glyphicon glyphicon-search"></i>&nbsp;<s:message code="filterInfo.search"/></button>
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
<form method="post" id="exportDownForm">
	<input type="hidden" id="filter_ids" name="filter_ids"/>
</form>