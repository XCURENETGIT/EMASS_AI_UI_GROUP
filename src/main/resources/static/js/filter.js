function initFilterSetup( ){
	$('.ulBtnArea li').click(function(){
	});

	rMenu = $('#rMenu');
	getAdminFilterList( );

	$('#dateSearch').click(function(){
		var zTree = $.fn.zTree.getZTreeObj("filterTree");
		var nodes = zTree.getSelectedNodes();
		if (nodes.length > 0) {
			var treeNode = $.extend(true, {}, nodes[0]);

			if( treeNode.filterType == 'D'){
				console.log(treeNode)
				var conditions = JSON.parse(treeNode.conditions);
				conditions[conditions.length-1].startDt = $('#startdatepickerAdd').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
				conditions[conditions.length-1].endDt = $('#enddatepickerAdd').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
				treeNode.conditions = conditions;
				rtnFilterClick( treeNode, 'searchCondition' );
			}else{
				treeNode.filterName = treeNode.name;
				treeNode.filter_seq = treeNode.id;
				treeNode.p_filter_seq = treeNode.pId;

				var conditions = [];
				var condition = {};
				condition.period = treeNode.userDtCd;
				condition.startDt = $('#startdatepickerAdd').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
				condition.endDt = $('#enddatepickerAdd').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
				condition.query = createSolrQuery(condition.period, condition.startDt, condition.endDt, treeNode.conditions);
				conditions.push(condition);
				treeNode.conditions = conditions;
				rtnFilterClick( treeNode, 'searchQuery' );
			}


		}else{
			alert(filter.msgConnectError);
		}
		hideRPeriod();
	});

	$('#saveFilterBtn').click(function(){
		var type = $('#modalType').val(); //add, modify
		var filterName = $('#filterNamePopInput').val();
		if( filterName == ''){
			ui.alertMsg(condition.messageInputFilter, function(){
				$('#filterNamePopInput').focus();
			});
			return;
		}

		var period = $('#filterOptionPopSelect').val();
		var startDt = $('#startdatepickerPop').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
		var endDt = $('#enddatepickerPop').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
		if( period == 1 ){
			if( startDt == '' || endDt == ''){
				alert(condition.messageInputPeriod);
				return;
			}if(startDt > endDt) {
				ui.alertMsg(condition.consentMsgTimecheck);
				return;
			}
		}
		else if( period == 2 ){
			startDt = $('#startDayPop').val();
			endDt = $('#endDayPop').val();
			if( startDt == '' ){
				alert(condition.messageInputPeriod);
				$('#startDayPop').focus();
				return;
			}
			if( endDt == '' ){
				alert(condition.messageInputPeriod);
				$('#endDayPop').focus();
				return;
			}
			if(startDt < endDt) {
				ui.alertMsg(condition.messageNumbercheck);
				$('#startDayPop').focus();
				return;
			}
		}

		var filterTreePop = $.fn.zTree.getZTreeObj("filterTreePop");
		var nodes = filterTreePop.getSelectedNodes();
		if( nodes.length == 0 ){
			alert(condition.messageSelectFolder);
			return;
		}

		if( (type == 'add'||type == 'save') && (nodes[0].filterType != 'F' && nodes[0].filterType != 'U') ){
			alert(condition.messageSelectFolder);
			return;
		}
		var param = getCondition('Pop');

		var url = '';
		if( type == 'add' || type == 'save'){
			url = '/insertAdminFilterData.xcn';
			param.p_filter_seq = param.filter_seq
			param.filter_seq = '';
		}else if( type == 'modify'){
			url = '/updateAdminFilterData.xcn';
		}

		ui.confirmMsg(condition.msgConfirmSave, '', '', function(rs){
			if(rs){
				ui.get({
					url : url,
					filterData : JSON.stringify(param),
					success : function(data, total) {
						alert(condition.msgSaved);
						getAdminFilterList( );
						$('#smartFilterSavePop').modal('hide');
					},
					error : function(status, message) {
						ui.alertMsg('error:' + status);
					},
					complete : function() {
					}
				});
			}
		});
	});

	$('#saveAdminFilterBtn').click(function(){
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
				ui.on('filterImportPop');
				$("#filterImportPopForm").ajaxForm({
					target : '#upload_file',
					beforeSubmit: function() {
					},
					success: function(result) {
						if(result.success) {
							getAdminFilterList( );
							ui.alertMsg(filter.msgSaved, function(){
								$('#filterImportPop').modal('hide');
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
						ui.off('filterImportPop');
					}
				}).submit();
			}
		});
	});
	$("#filterImportPop").on('hidden.bs.modal', function() {
		$('#file').val('');
	});

	$('#periodMenuCloseBtn').click(function(){hideRPeriod(); });
	$('#filterSearchBtn').click(function(){getAdminFilterList( ); });
	$("#filterSearchStr").keypress(function(e){if( e.keyCode == 13) getAdminFilterList( ); });
	$('#filterSearchBtn_n').click(function(){
		getAdminFilterList( );
	});
}

function insertAdminFilterData(){
	var filterName = $('#filterNamePopInput').val();
	if( filterName == ''){
		ui.alertMsg(condition.messageInputFilter, function(){
			$('#filterNamePopInput').focus();
		});
		return;
	}

	var period = $('#filterOptionPopSelect').val();
	var startDt = $('#startdatepickerPop').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
	var endDt = $('#enddatepickerPop').data("DateTimePicker").date().format('YYYYMMDDHHmmss');
	if( period == 1 ){
		if( startDt == '' || endDt == ''){
			alert(condition.messageInputPeriod);
			return;
		}if(startDt > endDt) {
			ui.alertMsg(condition.consentMsgTimecheck);
			return;
		}
	}
	else if( period == 2 ){
		startDt = $('#startDayPop').val();
		endDt = $('#endDayPop').val();
		if( startDt == '' ){
			alert(condition.messageInputPeriod);
			$('#startDayPop').focus();
			return;
		}
		if( endDt == '' ){
			alert(condition.messageInputPeriod);
			$('#endDayPop').focus();
			return;
		}
		if(startDt < endDt) {
			ui.alertMsg(condition.messageNumbercheck);
			$('#startDayPop').focus();
			return;
		}
	}

	var param = con.getFilterVal('Pop', 'N');

	var url = url = '/insertAdminFilterData.xcn';
	param.p_filter_seq = param.filter_seq;
	param.filter_seq = '';

	ui.confirmMsg(condition.msgConfirmSave, '', '', function(rs){
		if(rs){
			ui.get({
				url : url,
				filterData : JSON.stringify(param),
				success : function(data, total) {
					alert(condition.msgSaved);
					getAdminFilterList( );
					$('#periodSetupMenu').hide();
					$('#filterNamePopInput').val('');
					$('#filterHeaderDiv').show();
				},
				error : function(status, message) {
					ui.alertMsg('error:' + status);
				},
				complete : function() {
				}
			});
		}
	});
}

function updateAdminFilterData(){
	var filterName = $('#filterNamePopInput').val();
	if( filterName == ''){
		ui.alertMsg(condition.messageInputFilter, function(){
			$('#filterNamePopInput').focus();
		});
		return;
	}

	var param = con.getFilterVal('Pop', 'N');
	var url = 'updateAdminFilterData.xcn';

	ui.confirmMsg(condition.msgConfirmSave, '', '', function(rs){
		if(rs){
			ui.get({
				url : url,
				filterData : JSON.stringify(param),
				success : function(data, total) {
					alert(condition.msgSaved);
					getAdminFilterList( );
					$('#periodSetupMenu').hide();
					$('#filterNamePopInput').val('');
					$('#filterHeaderDiv').show();
				},
				error : function(status, message) {
					ui.alertMsg('error:' + status);
				},
				complete : function() {
				}
			});
		}
	});
}

function createSolrQuery(period, startDt, endDt, addQuery){
	if( period == 2){
		var dateObj = new Date();
		startDt = $('#startdatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-startDt, 00, 00, 00 ) ).date().format('YYYYMMDDHHmmss');
		endDt = $('#enddatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-endDt, 23, 59, 59 ) ).date().format('YYYYMMDDHHmmss');
	}
	if( addQuery.replaceAll(' ', '') == '*:*') return addQuery;
	else if(startDt != undefined && startDt != '' && endDt != undefined && endDt != ''){
		return ' +ctime:['+startDt+' TO '+endDt+'] '+addQuery;
	}else return addQuery;
}

function addFilterData( ){
	$('#rMenu').css('visibility', 'hidden');
	dataDialog( 'add', filter.add, '' );
}

function saveFilterOnTree( type ){
	$('#rMenu').css('visibility', 'hidden');
	$('#savePathPopDiv').hide();
	$('#selectConditionPopDiv').show();
	saveFilterData( type );
}

function saveFilterData( type ){
	$('#modalType').val(type);
	$('#smartFilterSavePop').modal('show');
}

function getAdminFilterList( ){
	var searchStr = $('#filterSearchStr').val();
	ui.get({
		url : 'getAdminFilterList.xcn',
		searchStr : searchStr,
		success : function(data, total) {
			initTree(data);
		},
		error : function(status, message) {
			ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}
function getAdminFilterListPop( ){
	ui.get({
		url : 'getAdminFilterList.xcn',
		success : function(data, total) {
			data.splice(0, 1);
			$.fn.zTree.init($("#filterTreePop"), ztreePop_setting, data);
		},
		error : function(status, message) {
			ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}

function initTree(data){
	$.fn.zTree.init($("#filterTree"), ztree_setting, data);
	zTree = $.fn.zTree.getZTreeObj("filterTree");

	$( window ).bind('keydown', function(e){
		//console.log("e.keyCode = "+e.keyCode);
		var filterTree = $.fn.zTree.getZTreeObj("filterTree");
		var nodes = filterTree.getSelectedNodes();
		if( nodes.length == 0 ){
			return;
		}

		if( e.keyCode == 113 ){
			var filterType = nodes[0].filterType;
			if( filterType == 'R' || filterType == 'U') return;

			zTree.editName(nodes[0]); //F2 key
		}
		else if( e.keyCode == 46 ) { //del key
			//delete filter
		}
		else if( e.keyCode == 27 ) { //esc key
			if($('#rMenu').css('visibility') == 'visible'){
				$('#rMenu').css('visibility', 'hidden');
			}
		}

		if ($('#rMenu').css('visibility') == 'visible'){
			if( e.keyCode == 70 ) { //F 새폴더
				addFilterFolder();
			}
			else if( e.keyCode == 77 ) { //M 이름 변경
				editFilterName();
			}
			else if( e.keyCode == 68 ) { //D 삭제
				deleteFilter( );
			}
			else if( e.keyCode == 65 ) { //A 필터 추가
				if($('#filter_new').css('display') != 'none') saveFilterOnTree( 'add' );
			}
			else if( e.keyCode == 85 ) { //U 필터 수정
				if($('#filter_update').css('display') != 'none') saveFilterOnTree( 'modify' );
			}
			return false;
		}
	});
}

function updateFilterStatus(id, open){
	ui.get({
		url : 'updateFilterStatus.xcn',
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

function updateFilterOrder( filterData ){
	ui.postJson({
		url : 'updateFilterOrder.xcn',
		filterData : filterData,
		success : function(data, total) {
		},
		error : function(status, message) {
			ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}
function exportFilter(url){
	$('#rMenu').css('visibility', 'hidden');
	ui.confirmMsg(filter.msgExportData, '', "small", function(rs){
		if(rs){
			nodeIds=[];
			var nodes = zTree.getSelectedNodes();
			if(nodes.length>0 && nodes[0].id != '1000'){
				nodeIds.push(nodes[0].id);
				getNodeIds(nodes[0].children);
				$('#filter_ids').val(nodeIds.join());
			}else{
				$('#filter_ids').val('');
			}

			$('#exportDownForm').attr('action', url);
			$('#exportDownForm').attr('method','post');
			$('#exportDownForm').submit();
		}
	});
}
function importFilter(){
	$('#rMenu').css('visibility', 'hidden');
	$('#filterImportPop').modal('show');
}
function addFilterFolder()
{
	var nodes = zTree.getSelectedNodes();
	if (nodes.length == 0) {
		return;
	}
	var treeNode = nodes[0];
	if( treeNode.filterType != 'F' && treeNode.filterType != 'U') return;

	$('#rMenu').css('visibility', 'hidden');
	treeNode = zTree.addNodes(treeNode, {id:(-1), pId:treeNode.id, name:filter.folderNew, filterType:'F'});
	zTree.editName(treeNode[0]);
}
/*function addFilterDataSet(iconPath){
	var treeNode = zTree.getNodeByParam("id", 1000, null);//사용자 정의 - 필터
	
	treeNode = zTree.addNodes(treeNode, {id:(-1), pId:1000, name:filter.filterNew, icon: iconPath, filterType:'D'});
	zTree.editName(treeNode[0]);
}*/
function editFilterName()
{
	$('#rMenu').css('visibility', 'hidden');
	var nodes = zTree.getSelectedNodes();
	if (nodes.length == 0) {
		return;
	}
	zTree.editName(nodes[0]);
}
function deleteFilter(){
	$('#rMenu').css('visibility', 'hidden');
	var nodes = zTree.getSelectedNodes();
	if(nodes.length>0){
		nodeInfos=[];
		if(nodes[0].children != undefined){
			getNodeInfo(nodes[0].children);
		}
		nodeInfos.push({id:nodes[0].id, pId:nodes[0].pId, name:nodes[0].name});
	}

	var confirmMsg = "";
	if(nodes[0].filterType != 'F') confirmMsg =filter.msgFilterDelete(nodes[0].name);
	else confirmMsg = filter.msgfolderDelete(nodes[0].name);

	if(nodes[0].children != undefined) confirmMsg = filter.msgAllDelete(nodes[0].name);

	ui.confirmMsg(confirmMsg, filter.folderDelete, "small", function(rs){
		if(rs){
			ui.get({
				url : 'deleteAdminFilter.xcn',
				filterData : JSON.stringify(nodeInfos),
				success : function(data, total) {
					getAdminFilterList( );
				},
				error : function(status, message) {
					ui.alertMsg('error:' + status);
				},
				complete : function() {
				}
			});
		}
	});
}

function saveAdminFilter( id, pId, name, filterType ){
	var url = 'insertAdminFilter.xcn';
	if( id != -1) url = 'updateAdminFilter.xcn';
	ui.get({
		url : url,
		id : id,
		pId : pId,
		name : name,
		filterType : filterType,
		success : function(data, total) {
			getAdminFilterList( );
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