function showRMenu(mainType, type, x, y) {
	$("#rMenu ul").css('display','');

	if(mainType == "C"){
		$("#f_folder_new").hide();
		$("#f_folder_rename").hide();
		$("#f_folder_delete").hide();
		$("#f_data_new").hide();
		$("#f_data_rename").hide();
		$("#f_data_delete").hide();
		
		$('#filter_export').show();
		if (type == "root") {
			$('#filter_import').show();
			$("#folder_new").show();
			$("#folder_rename").hide();
			$("#folder_delete").hide();
			$("#filter_new").hide();
			$("#filter_rename").hide();
			$("#filter_update").hide();
			$("#filter_delete").hide();
		} else if (type == 'folder') {
			$('#filter_import').hide();
			$("#folder_new").show();
			$("#folder_rename").show();
			$("#folder_delete").show();
			$("#filter_new").hide();
			$("#filter_rename").hide();
			$("#filter_update").hide();
			$("#filter_delete").hide();
		} else {
			$('#filter_import').hide();
			$("#folder_new").hide();
			$("#folder_rename").hide();
			$("#folder_delete").hide();
			$("#filter_new").hide();
			$("#filter_rename").show();
			$("#filter_update").hide(); //수정메뉴 제거
			$("#filter_delete").show();
		}
	}else{
		$('#filter_export').hide();
		$('#filter_import').hide();
		$("#folder_new").hide();
		$("#folder_rename").hide();
		$("#folder_delete").hide();
		$("#filter_new").hide();
		$("#filter_rename").hide();
		$("#filter_update").hide();
		$("#filter_delete").hide();
		
		if (type == "root") {
			$("#f_folder_new").show();
			$("#f_folder_rename").hide();
			$("#f_folder_delete").hide();
			$("#f_data_new").show();
			$("#f_data_rename").hide();
			$("#f_data_delete").hide();
		} else if (type == 'folder') {
			$("#f_folder_new").show();
			$("#f_folder_rename").show();
			$("#f_folder_delete").show();
			$("#f_data_new").show();
			$("#f_data_rename").hide();
			$("#f_data_delete").hide();
		} else {
			$("#f_folder_new").hide();
			$("#f_folder_rename").hide();
			$("#f_folder_delete").hide();
			$("#f_data_new").hide();
			$("#f_data_rename").show();
			$("#f_data_delete").show();
		}
	}
	
	
	if( y+rMenu.height() > $(window).height()) y-=rMenu.height();
	
	rMenu.css("top", function() {
		if($(this).hasClass("adminFolder")) return y + "px";
		else return (y-70) + "px";
	});
	
	rMenu.css({
		"left" : (x) + "px",
		"visibility" : "visible"
	});

	$(document).bind("mousedown", onBodyMouseDown);
}
function hideRMenu() {
	if (rMenu) rMenu.css({"visibility" : "hidden"});
	$(document).unbind("mousedown", onBodyMouseDown);
}
function onBodyMouseDown(event) {
	if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length > 0)) {
		hideRMenu();
	}
}
var addCount = 1;
function addTreeNode() {
	hideRMenu();
	var newNode = {
		name : "newNode " + (addCount++)
	};
	if (zTree.getSelectedNodes()[0]) {
		newNode.checked = zTree.getSelectedNodes()[0].checked;
		zTree.addNodes(zTree.getSelectedNodes()[0], newNode);
	} else {
		zTree.addNodes(null, newNode);
	}
}
function removeTreeNode() {
	hideRMenu();
	var nodes = zTree.getSelectedNodes();
	if (nodes && nodes.length > 0) {
		if (nodes[0].children && nodes[0].children.length > 0) {
			var msg = "If you delete this node will be deleted along with sub-nodes. \n\nPlease confirm!";
			if (confirm(msg) == true) {
				zTree.removeNode(nodes[0]);
			}
		} else {
			zTree.removeNode(nodes[0]);
		}
	}
}