function initFolderSetup( ){
	rMenu = $('#rMenu');
	getAdminFolderList( );

	$('#saveAdminFolderBtn').click(function(){
		if( $('#file').val() == '' ) {
			ui.alertMsg(filter.msgSelectFile);
			return;
		}
		if($('#file').val().indexOf('.flt') == -1){
			ui.alertMsg(filter.msgSelectFile);
			return;
		}
		ui.confirmMsg(filter.msgImportData, '', '', function(rs){
			if(rs){
				ui.on('folderImportPop');
				$("#folderImportPopForm").ajaxForm({
					target : '#upload_file',
					beforeSubmit: function() {
					},
					success: function(result) {
						if(result.success) {
							getAdminFolderList( );
							ui.alertMsg(filter.msgSaved, function(){
								$('#folderImportPop').modal('hide');
								$('#file').val('');

							});
						} else {
							ui.alertMsg(filter.msgSaveError+'\n'+result.message);
						}
					},
					error : function(){
						ui.alertMsg(filter.msgSaveError);
					},
					complete : function(){
						ui.off('folderImportPop');
					}
				}).submit();
			}
		});
	});

	$('#saveFolderBtn').click(function(){
		var selectedTabIdx = $('#resultTab').find('.active').index();

		var grid;
		if(selectedTabIdx > -1) grid = window.__grids[selectedTabIdx];
		else grid = getIframeListObj().grid;

		var msgids = grid.getSelectedKey('msgid');
		var consentNo = grid.getSelectedKey('consentNo');

		if( msgids.length == 0 ){
			alert(filter.selectMsg);
			return;
		}

		var folderTreePop = $.fn.zTree.getZTreeObj("folderTreePop");
		var nodes = folderTreePop.getSelectedNodes();
		if( nodes.length == 0 ){
			alert(condition.messageSelectFolder);
			return;
		}

		/*if( nodes[0].folderType != 'D'){
			//alert(condition.messageSelectFolder);
			alert(filter.selectMsgFolder);
			return;
		}*/

		ui.confirmMsg(condition.msgConfirmSave, '', '', function(rs){
			if(rs){
				ui.onBody( 'smartFolderSavePop', 0, 0);
				ui.get({
					url : '/insertAdminFolderData.xcn',
					folderSeq : nodes[0].id,
					msgIds : msgids.join(','),
					consentNo : consentNo[0],
					success : function(data, total) {
						alert(condition.msgSaved);
						getAdminFolderList( );
						//grid.unSelectAll();
						$('#smartFolderSavePop').modal('hide');
					},
					error : function(status, message) {
						ui.alertMsg('error:' + status);
					},
					complete : function() {
						ui.off();
					}
				});
			}
		});
	});

	$('#smartFolderSavePop').on('show.bs.modal', function(){
		getAdminFolderListPop( );

	}).on('shown.bs.modal', function(){
		var nodes = zFolderTree.getSelectedNodes();
		if (nodes.length > 0) {
			var treeNode = nodes[0];
			treeNode.tId = 'folderTreePop_'+ treeNode.tId.split('_')[1];
			treeNode.isHover = false;

			var filterTreePop = $.fn.zTree.getZTreeObj("folderTreePop");
			filterTreePop.selectNode(treeNode);
		}

		popOpenFlag = true;
	}).on('hidden.bs.modal', function(){
		popOpenFlag = false;
		getAdminFolderList( );
	});

	$("#folderImportPop").on('hidden.bs.modal', function() {
		$('#file').val('');
	});

	$('#periodMenuCloseBtn').click(function(){hideRPeriod(); });
	$('#folderSearchBtn').click(function(){getAdminFolderList( ); });
	$("#folderSearchStr").keypress(function(e){if( e.keyCode == 13) getAdminFolderList( ); });
	$('#folderSearchBtn_n').click(function(){getAdminFolderList( ); });
}

function addFolderData( ){
	$('#rMenu').css('visibility', 'hidden');
	dataDialog( 'add', filter.add, '' );
}

function saveFolderOnTree( type ){
	/*$('#rMenu').css('visibility', 'hidden');
	$('#savePathPopDiv').hide();
	$('#selectConditionPopDiv').show();
	saveFolderData( type );*/

	var nodes = zFolderTree.getSelectedNodes();
	if (nodes.length == 0) {
		return;
	}
	var treeNode = nodes[0];
	if( treeNode.folderType != 'F' && treeNode.folderType != 'U') return;

	var newFolderMessage = folderJS.newMsgFolder;
	$('#rMenu').css('visibility', 'hidden');
	treeNode = zFolderTree.addNodes(treeNode, {id:(-1), pId:treeNode.id, name:newFolderMessage, folderType:'D', icon:'/emass/resources/img/ztree/msgFolder_empty.png'});
	zFolderTree.editName(treeNode[0]);


}

function saveFolderData( ){
	var selectedTabIdx = $('#resultTab').find('.active').index();
	var grid = window.__grids[selectedTabIdx];
	saveFolderDataGrid(grid);
}

function saveFolderDataGrid( grid ){
	var msgids = grid.getSelectedKey('msgid');
	if( msgids.length == 0 ){
		alert(filter.selectMsg);
		return;
	}
	$('#modalFolderType').val('save');
	$('#smartFolderSavePop').modal('show');
}

function getAdminFolderList( ){
	var searchStr = $('#folderSearchStr').val();
	ui.get({
		url : 'getAdminFolderList.xcn',
		searchStr : searchStr,
		success : function(data, total) {
			initFolderTree(data);
		},
		error : function(status, message) {
			ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}

function getAdminFolderListPop( ){
	ui.get({
		url : 'getAdminFolderList.xcn',
		success : function(data, total) {
			$.fn.zTree.init($("#folderTreePop"), ztreePop_setting, data);
		},
		error : function(status, message) {
			ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}

function initFolderTree(data){
	$.fn.zTree.init($("#folderTree"), ztree_settingFolder, data);
	zFolderTree = $.fn.zTree.getZTreeObj("folderTree");

	if( staticTreeId == 'folderTreePop' ) {
		$.fn.zTree.init($("#folderTreePop"), ztreePop_setting, data);
		zFolderTree = $.fn.zTree.getZTreeObj("folderTreePop");
	}

	$( window ).bind('keydown', function(e){
		//console.log("e.keyCode = "+e.keyCode);
		var nodes = zFolderTree.getSelectedNodes();
		if( nodes.length == 0 ){
			return;
		}

		if( e.keyCode == 113 ){
			var folderType = nodes[0].folderType;
			if( folderType == 'R' || folderType == 'U') return;

			zFolderTree.editName(nodes[0]); //F2 key
		}
		else if( e.keyCode == 46 ) { //del key
			//delete folder
		}
		else if( e.keyCode == 27 ) { //esc key
			if($('#rMenu').css('visibility') == 'visible'){
				$('#rMenu').css('visibility', 'hidden');
			}
		}

		if ($('#rMenu').css('visibility') == 'visible'){
			if( e.keyCode == 70 ) { //F 새폴더
				addFolderFolder();
			}
			else if( e.keyCode == 77 ) { //M 이름 변경
				editFolderName();
			}
			else if( e.keyCode == 68 ) { //D 삭제
				deleteFolder( );
			}
			else if( e.keyCode == 65 ) { //A 필터 추가
				if($('#folder_new').css('display') != 'none') saveFolderOnTree( 'add' );
			}
			else if( e.keyCode == 85 ) { //U 필터 수정
				if($('#folder_update').css('display') != 'none') saveFolderOnTree( 'modify' );
			}
			return false;
		}
	});
}

function deleteFolderData(alertMsg){
	if($('#contextMenu').css('display')=='block')$("#contextMenu").hide();
	var rows = grid.getSelectedRows();
	if( rows == '' && alertMsg != undefined) {
		ui.alertMsg(alertMsg);
		return false;
	}
	var msgids = grid.getSelectedKey('msgid');
	if( msgids.length == 0 ){
		alert(filter.selectDelMsg);
		return;
	}
	ui.confirmMsg(condition.delMsgFolderMsg, '', '', function(rs){
		if(rs){
			ui.get({
				url : '/deleteAdminFolderData.xcn',
				folderSeq : folderSeq,
				folder_name : folderName,
				msgIds : msgids.join(','),
				consentNo : '',
				success : function(data, total) {
					alert(condition.delMsgFoldercomplMsg);
					grid.deleteSelectedRows();
					opener.getAdminFolderList();
				},
				error : function(status, message) {
					ui.alertMsg('error:' + status);
				},
				complete : function() {
					getFolderDataList();
				}
			});
		}
	});
}

function updateFolderStatus(id, open){
	ui.get({
		url : 'updateFolderStatus.xcn',
		id : id,
		open : open,
		success : function(data, total) {
		},
		error : function(status, message) {
			ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}

function updateFolderOrder( folderData ){
	ui.postJson({
		url : 'updateFolderOrder.xcn',
		folderData : folderData,
		success : function(data, total) {
		},
		error : function(status, message) {
			ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}
function exportFolder(url){
	$('#rMenu').css('visibility', 'hidden');
	ui.confirmMsg(filter.msgExportData, '', "small", function(rs){
		if(rs){
			nodeIds=[];
			var nodes = zFolderTree.getSelectedNodes();
			if(nodes.length>0 && nodes[0].id != '1000'){
				nodeIds.push(nodes[0].id);
				getNodeIds(nodes[0].children);
				$('#folder_ids').val(nodeIds.join());
			}else{
				$('#folder_ids').val('');
			}

			$('#exportDownForm').attr('action', url);
			$('#exportDownForm').attr('method','post');
			$('#exportDownForm').submit();
		}
	});
}
function importFolder(){
	$('#rMenu').css('visibility', 'hidden');
	$('#folderImportPop').modal('show');
}
function addFolderFolder()
{
	var nodes = zFolderTree.getSelectedNodes();
	if (nodes.length == 0) {
		return;
	}
	var treeNode = nodes[0];
	if( treeNode.folderType != 'F' && treeNode.folderType != 'U') return;

	$('#rMenu').css('visibility', 'hidden');
	treeNode = zFolderTree.addNodes(treeNode, {id:(-1), pId:treeNode.id, name:filter.folderNew, folderType:'F'});
	zFolderTree.editName(treeNode[0]);
}
function editFolderName()
{
	$('#rMenu').css('visibility', 'hidden');
	var nodes = zFolderTree.getSelectedNodes();
	if (nodes.length == 0) {
		return;
	}
	zFolderTree.editName(nodes[0]);
}
function deleteFolder(){
	$('#rMenu').css('visibility', 'hidden');

	var nodes = zFolderTree.getSelectedNodes();
	if(nodes.length>0){
		nodeInfos=[];
		if(nodes[0].children != undefined){
			getNodeInfoFolder(nodes[0].children);
		}
		nodeInfos.push({id:nodes[0].id, pId:nodes[0].pId, name:nodes[0].name, folderType:nodes[0].folderType});
	}

	var confirmMsg = "";
	if(nodes[0].folderType != 'F') confirmMsg =filter.msgfolderDelete(nodes[0].name);
	else confirmMsg = filter.msgfolderDelete(nodes[0].name);

	if(nodes[0].children != undefined) confirmMsg = filter.msgAllDelete(nodes[0].name);

	ui.confirmMsg(confirmMsg, filter.folderDelete, "small", function(rs){
		if(rs){
			ui.onBody( 'container', 0, 0);
			ui.get({
				url : 'deleteAdminFolder.xcn',
				folderData : JSON.stringify(nodeInfos),
				success : function(data, total) {
					getAdminFolderList( );
					if( opener != null ) opener.getAdminFolderList( );
				},
				error : function(status, message) {
					ui.alertMsg('error:' + status);
				},
				complete : function() {
					ui.off();
				}
			});
		}
	});
}

function saveAdminFolder( id, pId, name, folderType ){
	var url = 'insertAdminFolder.xcn';
	if( id != -1) url = 'updateAdminFolder.xcn';
	ui.get({
		url : url,
		id : id,
		pId : pId,
		name : name,
		folderType : folderType,
		success : function(data, total) {
			getAdminFolderList( );
			if( opener != null ) opener.getAdminFolderList( );
		},
		error : function(status, message) {
			ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}
function hideRPeriod() {
	if ($('#periodMenu')) $('#periodMenu').css({"visibility" : "hidden"});
	$(document).unbind("mousedown", onBodyMouseDownPeriod);
}
function showRPeriod(x, y) {
	$("#periodMenu ul").css('display','');

	if( y+$('#periodMenu').height() > $(window).height()) y-=$('#periodMenu').height();

	$('#periodMenu').css({
		"top" : (y-50) + "px",
		"left" : (x-$('.nav-side-menu').width()) + "px",
		"visibility" : "visible"
	});
	$(document).bind("mousedown", onBodyMouseDownPeriod);
}

function onBodyMouseDownPeriod(event) {
	if (!(event.target.id == "periodMenu" || $(event.target).parents("#periodMenu").length > 0)) {
		hideRPeriod();
	}
}