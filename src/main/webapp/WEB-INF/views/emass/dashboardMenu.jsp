<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title></title>
<style type="text/css">
.radio-inline {
	padding-left: 0px;
	margin-left:10px;
	margin-bottom:10px;
}
.ellipsis {
	width:280px;
	text-overflow: ellipsis;
	overflow:hidden;
	white-space:nowrap;
}
.modal-lg{
	width:1100px;
}

.grid-stack-item{
	width:100%;
	height:100%;
}
.dashIcon, .menuIcon{
	font-size:18px;
	margin-bottom: 5px;
}

.selected{
	background-color:#c2daf8;
}
</style>
<script type="text/javascript">
var menuMaxCnt = 5;
var searchFlag = false;
$(document).ready(function() {
	$('#menuInsertBtn').click(function(){
		if(gridMenu.Rows >= menuMaxCnt){
			alert('<s:message code="dashboardMenu.msg.maxCnt" arguments="'+menuMaxCnt+'" />');
			return;
		}
		$('#menuKey').val('');
		$('#menuName').val('');
		$('#menuIcon').val('fa fa-th');
		$('.menuIcon').removeClass('selected');
		$('.menuIcon').first().addClass('selected');
		$('[name=useYn][value=Y]').prop('checked',true);
		$('#defaultMenu').val('');
		$("#setupDashboardMenuPop").modal('show');
	});
	$('#menuDeleteBtn').click(function(){
		var rows = gridMenu.getSelectedRows();
		if( rows == '' ) {
			ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
			return false;
		}
		var names = gridMenu.getSelectedKey('menuName');
		var defaultMenu = gridMenu.getSelectedKey('defaultMenu');
		
		if( defaultMenu.indexOf('Y') > -1 ) {
			ui.alertMsg('<s:message code="dashboardMenu.msg.cannotDel"/>');
			return false;
		}
		
		var defaultMenuFlag = false;
		for(var i=0; i<defaultMenu.length; i++){
			if(defaultMenu[i] == 'Y'){
				defaultMenuFlag = true;
				break;
			}
		}
			
		ui.confirmMsg( '<s:message code="common.msg.confirm.deleteitem" arguments="'+names+'" argumentSeparator="|"/>', '', '', function(rs){
			if(rs){
				gridMenu.on();
				ui.get({
					url : 'deleteDashBoardMenu.xcn',
					deleteData : JSON.stringify(rows),
					success : function ( data, total ) {
						if(defaultMenuFlag) defaultMenuKey = '';
						
						ui.alertMsg('<s:message code="common.msg.deleted"/> \n\n <s:message code="dashboardMenu.msg.refresh"/>', function(){
							window.location.reload();
						});
						//getDashBoardMenu();
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						gridMenu.off();
					}
				});
			}
		});
	});
	
	$('#menuDefaultSetupBtn').click(function(){
		var rows = gridMenu.getSelectedRows();
		if( rows == '' ) {
			ui.alertMsg('<s:message code="dashboardMenu.msg.selectDefault"/>');
			return false;
		}
		if( rows.length > 1 ) {
			ui.alertMsg('<s:message code="dashboardMenu.msg.defaultOne"/>');
			return false;
		}
		var menuKey = gridMenu.getValue(gridMenu.getSelectedIndex(), 'menuKey');
		var menuName = gridMenu.getValue(gridMenu.getSelectedIndex(), 'menuName');
		var useYn = gridMenu.getValue(gridMenu.getSelectedIndex(), 'useYn');
		
		if( useYn != 'Y' ) {
			ui.alertMsg('<s:message code="dashboardMenu.msg.cannotSelect"/>');
			return false;
		}
		
		ui.confirmMsg( '<s:message code="custom.msg.defaultSave"/>', '', '', function(rs){
			if(rs){
				gridMenu.on();
				ui.get({
					url : 'changeDashBoardDefaultMenu.xcn',
					menuName: menuName,
					menuKey : menuKey,
					success : function ( data, total ) {
						defaultMenuKey = menuKey;
						changeMainMenu(menuKey);
						ui.alertMsg('<s:message code="common.msg.modified"/>');
						getDashBoardMenu();
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						gridMenu.off();
					}
				});
			}
		});
	})
	
	$('#menuSaveBtn').click(function(){
		saveMenu();
	});
	
	$('.menuIcon').click(function(){
		$('#menuIcon').val($(this).attr('data-value'));
		
		$('.menuIcon').removeClass('selected');
		$(this).addClass('selected');
		$(this).blur();
	});
	
	getDashBoardMenu();
});

function saveMenu(){
	if( $('#menuName').val().ltrim().rtrim() == '' ) {
		ui.alertMsg('<s:message code="dashboardMenu.msg.inputMenuName"/>');
		$('#menuName').focus();
		return false;
	}
	var menuKey = $('#menuKey').val();
	if( menuKey != '' && $('#defaultMenu').val() =='Y' && $(":input:radio[name=useYn]:checked").val() == 'N'){
		ui.alertMsg('<s:message code="dashboardMenu.msg.cannotUse"/>');
		return false;
	}
	
	var message = menuKey=='' ? '<s:message code="common.msg.add"/>' : '<s:message code="common.msg.modify"/>';
	var confirmMessage = menuKey=='' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
	ui.confirmMsg(confirmMessage, '', '', function(rs){
		if(rs){
			gridMenu.on();
			ui.post({
				url :menuKey=='' ? 'insertDashBoardMenu.xcn' : 'updateDashBoardMenu.xcn',
				data : $('#setupDashboardMenuPopForm').serializeAll(),
				success : function ( data, total ) {
					ui.alertMsg('<s:message code="common.msg.saved"/> \n\n <s:message code="dashboardMenu.msg.refresh"/>', function(){
						window.location.reload();
					});
					//$('#setupDashboardMenuPop').modal('hide');
					//getDashBoardMenu();
				},
				error : function (status, message) {
					ui.alertMsg(message);
				},
				complete : function (){
					gridMenu.off();
					
				}
			});
		}
	});
}

function getDashBoardMenu(flag){
	gridMenu.on();
	ui.get({
		url : 'getDashBoardMenu.xcn',
		success : function(data, total) {
			gridMenu.setData(data);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			gridMenu.off();
		}
	});
}

</script>
</head>
<body class="mini-navbar">
	<div class="modal fade" id="setupDashboardMenuPop" tabindex="-1" role="dialog" aria-labelledby="setupDashboardModal">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="setupDashboardMenuPopForm">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="dashboardMenu.addModify"/></h3>
					</div>
					<div class="modal-body">
						<div class="row">
							<div class="col-md-12">
								<div class="form-inline">
									<label for="menuName" class="control-label col-xs-3"><s:message code="dashboardMenu.menuname"/></label>
									<input type="text" class="form-control" name="menuName" id="menuName" maxlength="60">
									<input type="hidden" class="form-control" name="menuKey" id="menuKey">
									<input type="hidden" class="form-control" name="defaultMenu" id="defaultMenu">
								</div>
								<div class="form-inline">
									<label for="menuIcon" class="control-label col-xs-3" style="height:80px;"><s:message code="dashboardMenu.icon"/></label>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-th"><i class="fa fa-th"></i></button>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-bars"><i class="fa fa-bars"></i></button>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-table"><i class="fa fa-table"></i></button>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-th-large"><i class="fa fa-th-large"></i></button>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-th-list"><i class="fa fa-th-list"></i></button>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-list-ul"><i class="fa fa-list-ul"></i></button>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-list-alt"><i class="fa fa-list-alt"></i></button>
									<br/>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-list"><i class="fa fa-list"></i></button>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-indent"><i class="fa fa-indent"></i></button>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-align-justify"><i class="fa fa-align-justify"></i></button>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-laptop"><i class="fa fa-laptop"></i></button>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-database"><i class="fa fa-database"></i></button>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-briefcase"><i class="fa fa-briefcase"></i></button>
									<button type="button" class="btn btn-default menuIcon" data-value="fa fa-asterisk"><i class="fa fa-asterisk"></i></button>
									<input type="hidden" id="menuIcon" name="menuIcon" />
								</div>
								<div class="form-inline" style="padding-top: 10px;">
									<label for="useYn" class="control-label col-xs-3"><s:message code="common.msg.useyn"/></label>
									<label class="radio-inline c-radio">
										<input type="radio" name="useYn" value="Y" checked>
										<span class="fa fa-check"></span><s:message code="common.msg.use"/>
									</label>
									<label class="radio-inline c-radio">
										<input type="radio" name="useYn" value="N">
										<span class="fa fa-check"></span><s:message code="common.msg.unuse"/>
									</label>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12" style="padding-top:15px;">
								<span><s:message code="dashboardMenu.msg.saveRefresh"/></span>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
						<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="menuSaveBtn"><s:message code="common.msg.save"/></button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<div class="container">
		<div class="boxArea">
			<div class="content_body">
				<div class="row" style="line-height: 0px; height:100%;">
					<div class="col-xs-12" style="height: 100%; padding-right: 5px;">
						<div class="row" style="margin-right:0px;">
							<div class="col-xs-12 text-left" style="padding-right:0;width:calc(100% - 95px);">
								<div class="form-group form-inline not-dashed">
									<button type="button" class="btn btn-sm btn-primary" accesskey="I" id="menuInsertBtn"><span class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
									<button type="button" class="btn btn-sm btn-default" accesskey="D" id="menuDeleteBtn"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/></button>
									&nbsp;
									<button type="button" class="btn btn-sm btn-default" accesskey="A" id="menuDefaultSetupBtn"><span class="fa fa-star"></span>&nbsp;<s:message code="dashboardMenu.defaultMenu"/></button>
								</div>
							</div>
						</div>
						<div class="row xcn_full top_space">
							<div class="col-xs-12" style="height: 100%;">
								<div id="dashboardMenuListGrid" class="slickGrid gridArea"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var gridMenu = new Xgrid('dashboardMenuListGrid', contextRoot);
		gridMenu.onCheckBox();
		gridMenu.autoNumber();
		gridMenu.colAdd('menuIcon', '<s:message code="dashboardMenu.icon"/>', 60, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
			return '<i class="customClass '+value+'" style="font-size:20px;"></i>';
		});
		gridMenu.colAdd('menuName', 'Dashboard <s:message code="dashboardMenu.menuname"/>', 183, 'left', false, 'link');
		gridMenu.colAdd('useYn', '<s:message code="common.msg.useyn"/>', 100, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
			if(value=='Y') return '<s:message code="common.msg.use"/>';
			else if(value=='N') return '<s:message code="common.msg.unuse"/>';
			return '-';
		});
		gridMenu.colAdd('defaultMenu', '<s:message code="dashboardMenu.default"/>', 100, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
			if(value=='Y') return '<i class="fa fa-star" style="font-size:15px;"></i>';
			else return '-';
		});
		gridMenu.loadHeader(false);
		gridMenu.initData('<s:message code="common.msg.search.click"/>');
		
		gridMenu.onClick = function() {
			if (gridMenu.Col == gridMenu.ColIndex('menuName')) {
				var data = gridMenu.getRowData(gridMenu.Row);
				$('#menuKey').val(data.menuKey);
				$('#menuName').val(data.menuName);
				$('#menuIcon').val(data.menuIcon);
				$('.menuIcon').removeClass('selected');
				$('.menuIcon').filter(function(){return $(this).attr('data-value')==data.menuIcon}).addClass('selected');
				$('[name=useYn][value='+data.useYn+']').prop('checked',true);
				$('#defaultMenu').val(data.defaultMenu);
				$("#setupDashboardMenuPop").modal('show');
				
			}
		};
	</script>
</body>
</html>