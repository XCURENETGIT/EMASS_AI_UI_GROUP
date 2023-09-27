var zTree, zFolderTree, rMenu, curDragNodes;
var ztree_settingFolder = {
	view: {
		fontCss: getFontCss,
		showLine: false
	},
	check: {
		enable: false
	},
	edit: {
		enable: true,
		showRemoveBtn: false,
		showRenameBtn: false,
		drag: {
			isCopy : false,
			prev: dropPrev,
			inner: dropInner,
			next: dropNext
		}
	},
	data: {
		simpleData: {
			enable: true
		}
	},
	callback: {
		onRightClick: OnRightClick,
		beforeDrag: beforeDrag,
		onDrop: onDrop,
		onCollapse: onCollapse,
		onExpand: onExpand,
		onClick: onDblClick,
		beforeRename : beforeRename
	}
};
var ztree_setting = {
		view: {
			fontCss: getFontCss,
			showLine: false
		},
		check: {
			enable: false
		},
		edit: {
			enable: true,
			showRemoveBtn: false,
			showRenameBtn: false,
			drag: {
				isCopy : false,
				prev: dropPrev,
				inner: dropInner,
				next: dropNext
			}
		},
		data: {
			simpleData: {
				enable: true
			}
		},
		callback: {
			onRightClick: OnRightClick,
			beforeDrag: beforeDrag,
			onDrop: onDrop,
			onCollapse: onCollapse,
			onExpand: onExpand,
			onClick: onDblClick,
			beforeRename : beforeRename
		}
	};
var ztreePop_setting = {
		view: {
			fontCss: getFontCss,
			showLine: false
		},
		check: {
			enable: false
		},
		edit: {
			enable: false,
			showRemoveBtn: false,
			showRenameBtn: false,
			drag: {
				isCopy : false,
			}
		},
		data: {
			simpleData: {
				enable: true
			}
		},
		callback: {
			onRightClick: OnRightClick,
			beforeDrag: beforeDrag,
			onDrop: onDrop,
			onCollapse: onCollapse,
			onExpand: onExpand,
			onClick: onDblClick,
			beforeRename : beforeRename
		}
	};

function getFontCss(treeId, treeNode) {
	return (!!treeNode.highlight) ? {color:"#F25643", "font-weight":"bold"} : {color:"#333", "font-weight":"normal"};
}
var staticTreeId = '';
function OnRightClick(event, treeId, treeNode) {
	staticTreeId = treeId;
	if( treeId == 'folderTreePop') {
		zFolderTree = $.fn.zTree.getZTreeObj("folderTreePop");
	} else if( treeId == 'folderTree' ) {
		zFolderTree = $.fn.zTree.getZTreeObj("folderTree");
	}
	
	if (treeNode ) {
		$.fn.zTree.getZTreeObj(treeId).selectNode(treeNode);

		var filterType = treeNode.filterType;
		var folderType = treeNode.folderType;
		
		if( filterType == 'R' || folderType == 'R' ) {
			return;
		}
		if( filterType == 'U') {
			showRMenu("C", "root", event.pageX, event.pageY);
		}
		else if( filterType == 'F' ){
			showRMenu("C", "folder", event.pageX, event.pageY);
		}
		else if( filterType == 'D' || filterType == 'Q' ){
			showRMenu("C", "node", event.pageX, event.pageY);
		}
		else if( folderType == 'U'){
			showRMenu("F", "root", event.pageX, event.pageY);
		}
		else if( folderType == 'F'){
			showRMenu("F", "folder", event.pageX, event.pageY);
		}
		else if( folderType == 'D'){
			showRMenu("F", "node", event.pageX, event.pageY);
		}

	}
}
function beforeDrag(treeId, treeNodes) {
	if (treeNodes[0].drag == 'false') {
		curDragNodes = null;
		return false;
	}
	curDragNodes = treeNodes;
	return true;
}

function onDrop(event, treeId, treeNodes, targetNode, moveType) {
	nodeInfos=[];
	var tree = $.fn.zTree.getZTreeObj(treeId);
	var node = tree.getNodeByParam("id", treeNodes[0].id);
	
	if(treeId == 'filterTree'){
		var nodes = tree.getNodesByParam("id", "1000", null);
		if(nodes.length>0){
			getNodeInfo(nodes[0].children);
			updateFilterOrder(JSON.stringify(nodeInfos));
		}
	}else{
		var nodes = tree.getNodesByParam("id", "0", null);
		if(nodes.length>0){
			getNodeInfoFolder(nodes[0].children);
			updateFolderOrder(JSON.stringify(nodeInfos));
		}
	}
	
	return true;
}

var nodeInfos=[];
function getNodeInfo(nodes){
	if(nodes == null) return;
	
	for(var i=0 ;i <nodes.length ; i++){
		nodeInfos.push({id:nodes[i].id, pId:nodes[i].pId, filterOrder:i, name:nodes[i].name});
		if(nodes[i].children!=undefined){
			getNodeInfo(nodes[i].children);
		}
	}
}
function getNodeInfoFolder(nodes){
	if(nodes == null) return;
	
	for(var i=0 ;i <nodes.length ; i++){
		nodeInfos.push({id:nodes[i].id, pId:nodes[i].pId, folderOrder:i, name:nodes[i].name, folderType:nodes[i].folderType});
		if(nodes[i].children!=undefined){
			getNodeInfoFolder(nodes[i].children);
		}
	}
}
var nodeIds=[];
function getNodeIds(nodes){
	if(nodes == null) return;
	
	for(var i=0 ;i <nodes.length ; i++){
		nodeIds.push(nodes[i].id);
		if(nodes[i].children!=undefined){
			getNodeIds(nodes[i].children);
		}
	}
}

function dropPrev(treeId, nodes, targetNode) {
	if (targetNode.drag == 'false') {
		return false;
	} else {
		var pNode = targetNode.getParentNode();
		if (pNode == null) {
			return false;
		}
	}
	return true;
}

function dropInner(treeId, nodes, targetNode) {
	if(targetNode == null ) return false;
	else if (targetNode && (targetNode.filterType != 'F' && targetNode.folderType != 'F')) {
		return false;
	} else {
		for (var i=0,l=curDragNodes.length; i<l; i++) {
			if (!targetNode && curDragNodes[i].dropRoot === false) {
				return false;
			} else if (curDragNodes[i].parentTId && curDragNodes[i].getParentNode() !== targetNode && curDragNodes[i].getParentNode().childOuter === false) {
				return false;
			}
		}
	}
	return true;
}
function dropNext(treeId, nodes, targetNode) {
	if (targetNode.drag == 'false') {
		return false;
	} else {
		var pNode = targetNode.getParentNode();
		if (pNode == null) {
			return false;
		}
	}
	return true;
}
function onCollapse( event, treeId, treeNode ){
	if( treeId == 'filterTree'){
		updateFilterStatus(treeNode.id, treeNode.open);
	}else{
		updateFolderStatus(treeNode.id, treeNode.open);
	}
			
}
function onExpand(event, treeId, treeNode) {
	if( treeId == 'filterTree'){
		updateFilterStatus(treeNode.id, treeNode.open);
	}else{
		updateFolderStatus(treeNode.id, treeNode.open);
	}
};
var treeClickFlag = false;
function onDblClick(event, treeId, treeNode) {
	if(treeClickFlag) return;
	treeClickFlag = true;
	
	if( treeId=='filterTree' && treeNode != null && treeNode.filterType == 'D'){
		var newTreeNode = $.extend(true, {}, treeNode);
		var conditions = JSON.parse(newTreeNode.conditions);
		var period = conditions[conditions.length-1].period;
		newTreeNode.conditions = conditions;
		newTreeNode.filterName = newTreeNode.name;
		newTreeNode.filter_seq = newTreeNode.id;
		newTreeNode.p_filter_seq = newTreeNode.pId;
		newTreeNode.filterType = newTreeNode.filterType;
		
		if( period != '3') rtnFilterClick( newTreeNode, 'searchCondition' );
		else {
			//$('#filterVal').val(newTreeNode.conditions);
			showRPeriod(event.pageX, event.pageY);
		}
	}else if( treeId=='filterTree' && treeNode != null && treeNode.filterType == 'Q'){
		var newTreeNode = $.extend(true, {}, treeNode);
		newTreeNode.filterName = newTreeNode.name;
		newTreeNode.filter_seq = newTreeNode.id;
		newTreeNode.p_filter_seq = newTreeNode.pId;
		newTreeNode.filterType = newTreeNode.filterType;
		
		var conditions = [];
		var condition = {};
		condition.period = newTreeNode.userDtCd;
		condition.startDt = newTreeNode.startDt;
		condition.endDt = newTreeNode.endDt;
		condition.query = createSolrQuery(condition.period, condition.startDt, condition.endDt, newTreeNode.conditions);
		conditions.push(condition);
		newTreeNode.conditions = conditions;

		var period = newTreeNode.userDtCd;
		if( period != '3') rtnFilterClick( newTreeNode, 'searchQuery' );
		else {
			$('#solrQueryText').val(newTreeNode.conditions);
			showRPeriod(event.pageX, event.pageY);
		}
	}else if(treeId=='folderTree' && treeNode != null){
		openMessageFolder();
	}
	treeClickFlag = false;
}

function beforeRename(treeId, treeNode, newName, isCancel) {
	if( treeId=='filterTree'){
		if(isCancel){
			getAdminFilterList( );
			return;
		}
		saveAdminFilter( treeNode.id, treeNode.pId, newName, treeNode.filterType );
	}else{
		if(isCancel){
			getAdminFolderList( );
			return;
		}
		saveAdminFolder( treeNode.id, treeNode.pId, newName, treeNode.folderType );
	}
}