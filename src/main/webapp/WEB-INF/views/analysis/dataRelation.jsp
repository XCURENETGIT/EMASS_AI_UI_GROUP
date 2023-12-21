<%@ page import="com.xcurenet.emass.service.service.ServiceGroupVO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<!-- process mapp -->
<link rel="stylesheet" href="<c:url value="/css/processmap.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/vis.min.css"/>"/>
<script type="text/javascript" src="<c:url value="/js/colorbrewer.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/geometry.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/processmap.js"/>"></script>

<script type="text/javascript" src="<c:url value="/js/d3.v3.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/vis.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/timeline.js"/>"></script>

<%
	String[] confColor = Config.colors;
	List<ServiceGroupVO> groups = Config.serviceGroups;
	
	String colorCode = "";
	for(int i=0; i < confColor.length; i++) {
		if(i==0) colorCode += "'" + confColor[i] + "'";
		else colorCode += ",'" + confColor[i] + "'";
	};
	
	String groupName = "";
	for(int i=0; i < groups.size(); i++) {
		if(i==0) groupName += "'" + groups.get(i).getGroupNm() + "'";
		else groupName += ",'" + groups.get(i).getGroupNm() + "'";
	};
%>
<style type="text/css">
.btn-popover {
	position: absolute;
	top: 0;
	right: 0;
	text-align: center;
	font-size: 14px;
	padding:3px;
	margin-top:5px;
	margin-right:20px;
}
.btn-full {
	position: absolute;
	top: 0;
	right: 0;
	text-align: center;
	font-size: 14px;
	padding:3px;
	margin-top:5px;
	margin-right:20px;
}

.chartFull {
	position:absolute;
	min-height:800px;
	z-index: 1000;
	width:100%;
	height:800px;
	left:0px;
	top:50px;
	box-shadow: 0px 8px 30px #253f56;
} 
#relation_divFull {
	width:100%; 
	height:750px;
} 

/*
 * tabGrid 관련 css
 */

</style>
<s:message code="common.datescript" var="ko"/>
<script>
var searchFlag = false;
var resultTotal = 0;
var detailTotal = 0;
var rowKey = "";
var colKey = "";
var confColor = [<%=colorCode%>];
var confGroup = [<%=groupName%>];
$(document).ready(function(){

	$('#dateYesterday').click(function(){
		$('#startDate').val(addDay(-1));
		$('#endDate').val(addDay(-1));
	});

	$('#dateToday').click(function(e){
		$('#startDate').val(addDay(0));
		$('#endDate').val(addDay(0));
	});
	
	$('#dateWeek').click(function(){
		$('#startDate').val(addDay(-7));
		$('#endDate').val(addDay(0));
	});
	
	$('#dateMonth').click(function(){
		$('#startDate').val(addMonth2(-1));
		$('#endDate').val(addDay(0));
	});

	$('#startdatepicker').datetimepicker({
		format: 'YYYY-MM-DD',
		locale: 'ko',
		defaultDate: moment(new Date())
	});
	
	$('#enddatepicker').datetimepicker({
		format: 'YYYY-MM-DD',
		locale: 'ko',
		defaultDate: moment(new Date())
	});
	
	$('#btnSearch').click(function(){
		getData ('Y');
	});

	$('#btnReset').click(function(){
		$("#frm").each(function(){
			this.reset();
		});
		$('#startDate').val(addDay(0));
		$('#endDate').val(addDay(0));
	});

	$("#startDate, #endDate, #title, #sendUser, #receiveUser, #keyword, #fileSize").keyup(function(event){
		eventEnterSearch(event);
	});
	
	$(".numberinput").forceNumeric();
	
	getInterestUserOptions();
	
	initGrid(tabGrid, messageGridColumn);

	$('#chartFull').click(function(){
		chartFullView();
	});
});

function eventEnterSearch(event) {
	if(event.keyCode == 13){
		$("#btnSearch").click();
	}
}

</script>
	<div class="container">
		<div class="boxArea">
			<div class="content_body">
				<form id="frm">
					<div class="row">
						<div class="col-xs-12">
							<div class="form-group form-inline not-dashed">
								<div class="form-group">
									<label for="unit"><s:message code="analysis.relation.unit"/>:</label>
									<select id="unit" name="unit" class="input-sm form-control">
										<option value="file"><s:message code="consent.attach"/></option>
										<option value="mailid"><s:message code="analysis.relation.mailid"/></option>
										<option value="messenger"><s:message code="analysis.relation.messenger"/></option>
									</select>
								</div>
								<div class="form-group form-inline not-dashed" style="margin-left: 15px;">
									<label for="startdate"><s:message code="condition.period"/>:</label> 
									<div class='input-group date' id='startdatepicker'>
										<input type='text' class="input-sm form-control" id='startDate' name='startDate' />
										<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
										</span>
									</div>
									~
									<div class='input-group date' id='enddatepicker'>
										<input type='text' class="input-sm form-control" id='endDate' name='endDate' />
										<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
										</span>
									</div>
								</div>
								<div class="form-group form-inline not-dashed">
									<button type="button" id="dateYesterday" accesskey="Y" class="btn btn-sm btn-default"><s:message code="condition.yesterday"/></button>
									<button type="button" id="dateToday" accesskey="T" class="btn btn-sm btn-default"><s:message code="condition.today"/></button>
									<button type="button" id="dateWeek" accesskey="W" class="btn btn-sm btn-default"><s:message code="condition.week" arguments="1" argumentSeparator="|"/></button>
									<button type="button" id="dateMonth" accesskey="M" class="btn btn-sm btn-default"><s:message code="condition.month" arguments="1" argumentSeparator="|"/></button>
								</div>
							</div>
						</div>
					</div>
					<div class="row top_space">
						<div class="col-xs-12">
							<div class="form-group form-inline not-dashed">
								<div class="form-group">
									<label for="title"><s:message code="condition.subject"/>:</label> 
									<div class='input-group'>
										<input type="text" id="title" name="title" class="input-sm form-control" style="width: 200px;" />
									</div>
								</div>
								<div class="form-group form-inline not-dashed" style="margin-left: 15px;">
									<label for="sendUser"><s:message code="condition.from"/>:</label> 
									<div class='input-group'>
										<input type="text" id="sendUser" name="sendUser" class="input-sm form-control" style="width: 170px;" />
									</div>
								</div>
								<div class="form-group form-inline not-dashed" style="margin-left: 15px;">
									<label for="receiveUser"><s:message code="condition.to"/>:</label> 
									<div class='input-group'>
										<input type="text" id="receiveUser" name="receiveUser" class="input-sm form-control" style="width: 170px;" />
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row top_space">
						<div class="col-xs-12">
							<div class="form-group form-inline not-dashed">
								<div class="form-group">
									<label for="interGroup"><s:message code="interest.user"/>:</label>
									<div class='input-group'>
										<select id="interGroup" name="interGroup" class="input-sm form-control">
											<option value=""><s:message code="analysis.ui.all"/></option>
										</select>
									</div>
								</div>
								<div class="form-group form-inline not-dashed" style="margin-left: 15px;">
									<label for="keyword"><s:message code="condition.keyword"/>:</label> 
									<div class='input-group'>
										<input type="text" id="keyword" name="keyword" class="input-sm form-control" />
									</div>
								</div>
								<div class="form-group form-inline not-dashed" style="margin-left: 15px;">
									<label for="fileSize"><s:message code="analysis.relation.attachsize"/>(MByte <s:message code="filterInfo.rangeL"/>):</label> 
									<div class='input-group'>
										<input type="text" id="fileSize" name="fileSize" class="input-sm form-control numberinput" style="width: 90px;" maxlength="7" />
									</div>
									<div class="btn-group form-inline not-dashed">
										<button type="button" class="btn btn-success btn-sm" accesskey="Q" id="btnSearch"><span class="glyphicon glyphicon-search"></span></button>
									</div>
									<div class="btn-group form-inline not-dashed">
										<button type="button" id="btnReset" accesskey="R" class="btn btn-sm btn-warning">
											<span class="glyphicon glyphicon-refresh"></span>&nbsp;<s:message code="condition.reset"/>
										</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</form>
				<div class="row top_space">
					<div class="col-lg-4">
						<div class="panel panel-default" style="height:500px;">
							<div class="panel-heading">
								<i class="fa fa-file-text-o fa-fw"></i> <span>LIST</span>
							</div>
							<div class="panel-body" style="height: calc(100% - 38px); padding: 10px;">
								<div id="basicStatListGrid" class="slickGrid gridArea"></div>
							</div>
						</div>
					</div>
					<div class="col-lg-8">
						<div class="panel panel-default" style="height:500px;">
							<div class="panel-heading">
								<i class="fa fa-share-alt fa-fw"></i> <span><s:message code="analysis.relation.ui.relationships"/></span>
								<div id="popover-content-chart" class="hide">
									<div style="padding-left:10px;">
										<ul style="padding-left:15px;">
											<li style="margin-bottom:7px;"><s:message code="analysis.relation.ui.msg1"/></li>
										</ul>
									</div>
								</div>
								<span id="chartFull" class="btn-full" style="display:none">
									<a tabindex="0" class="btn btn-xs" role="button" data-trigger="focus" data-container="#chartFull" title="<s:message code="analysis.relation.ui.enlarge"/>"><span class="glyphicon glyphicon glyphicon-fullscreen" style="font-size:20px;"></span></a>
								</span>
							</div>
							<div class="panel-body" style="padding: 0;">
								<div id="relation_div" >
									<div class="initText" style="padding:11px;"><s:message code="analysis.relation.ui.msg5"/></div>
									<div id="graph-container" style="height: 421px; overflow:hidden">
										<div id="graph"></div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row" style="margin-bottom:5px;">
					<div class="col-lg-12">
						<div class="panel with-nav-tabs" style="height:100%;">
							<div class="panel-heading" style="padding:0;">
								<ul class="nav nav-tabs codeTab">
									<li class="active" ><a data-target="#result0" aria-controls="result0" role="tab" data-toggle="tab">Timeline</a></li>
									<li><a data-target="#result1" aria-controls="result1" role="tab" data-toggle="tab"><s:message code="analysis.relation.ui.selectlist"/> <span class="resultCnt"></span></a></li>
								</ul>
							</div>
							<div class="panel-body" style="padding: 4px 0px 0px 0px;">
								<div class="tab-content" style="height:100%;" id="resultData">
									<div role="tabpanel" class="tab-pane fade active in" id="result0">
										<div id="timeline" style="min-height:400px;">
											<div style="padding: 5px;"><s:message code="analysis.relation.ui.notimeline"/></div>
										</div>
									</div>
									<div role="tabpanel" class="tab-pane fade in" id="result1">
										<div id="selectList">
											<div style="min-height:400px;height: 400px;">
												<div id="selectGrid" class="slickGrid gridArea" style="height: 100%;"></div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="chartFullDiv" class="chartFull" style="display:none">
		<div class="panel panel-default" style="min-height:800px; height:800px;">
			<div class="panel-heading">
				<i class="fa fa-share-alt fa-fw"></i> <span>관계도</span>
				<span class="btn-popover">
					<a tabindex="0" class="btn btn-xs" role="button" onclick="javascript:chartFullClose();"><span class="glyphicon glyphicon-remove" style="font-size:20px;"></span></a>
				</span>
			</div>
			<div class="panel-body" style="height: 100%;padding:0px;">
				<div id="relation_divFull" style="overflow:hidden;">
					<div id="graph-containerFull">
						<div id="graphFull" ></div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Back to top -->
	<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>
	
	<script type="text/javascript" src="<c:url value="/js/bihisankey.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/usersankey.js"/>"></script>
	<script type="text/javascript">

		var unit = '';
		var startDate = '';
		var endDate = '';
		var title = '';
		var sendUser = '';
		var receiveUser = '';
		var keyword = '';
		var fileSize = '';
		var interGroup = '';
		var interGroupName = '';

		var tabIdx = 0;
		var rsKey = [];
	
		var grid = new Xgrid('basicStatListGrid', contextRoot);
		var tabGrid = new Xgrid('selectGrid', contextRoot, 26, {commonId:'selectTotalList', status_cnt_id:'#selectTotalCnt', more_btn:'slick_grid_more_btn'});
		
		grid.loadExportMenu('<s:message code="DATA_ANALYSIS.ANALYSIS_RELATION"/>');
		grid.loadPageSize();
		grid.changePageSize = function(cnt){
			getData('Y');
		};
		
		tabGrid.loadExportMenu('<s:message code="DATA_ANALYSIS.ANALYSIS_RELATION"/>');
		tabGrid.loadPageSize();
		tabGrid.changePageSize = function(cnt){
			getSelectMessageList('Y');
		};

		colInit();
		grid.loadHeader(false);
		grid.initData('<s:message code="analysis.relation.ui.msg2"/>');
		
		grid.onClick = function() {
			rowKey = grid.getValue(grid.Row, 'val');
			colKey = grid.ColKey(grid.Col);
			if (colKey == 'rowKey' || colKey == 'total' || colKey == 'NUM') {
				colKey = "";
			}
			getDetailData(rowKey);
			
		};
		writeExportMenu('export_menu', 'selectGrid', '<s:message code="DATA_ANALYSIS.ANALYSIS_RELATION"/> - <s:message code="analysis.freedom.ui.msglist"/>');
		
		function colInit() {
			grid.colInit();
			grid.autoNumber();
			grid.colAdd('val', $("#unit option:selected").text(), 200, "left", false, 'link' );
			grid.colAdd('count', '<s:message code="analysis.relation.ui.collectcount"/>', 60, 'center', false, 'nomal' , function ( row, cell, value, columnDef, dataContext ) {
				if ( value != undefined ) return value.comma();
				else return '';
			} );
			grid.colAdd('size', '<s:message code="analysis.relation.ui.packetsize"/>', 100, 'right', false, 'nomal' , function ( row, cell, value, columnDef, dataContext ) {
				if ( value != undefined ) return convertFileSize(value);
				else return '';
			});

			//grid.pageSize = 100;
		}

		var unit, startDate, endDate, title, sendUser, receiveUser, keyword, fileSize, processMapData;

		function getData( flag ) {
			listData = '';
			if($('#startDate').val() > $('#endDate').val()) {
				alert('<s:message code="analysis.relation.ui.msg3"/>');
				return;
			}
			if ( searchFlag ) return;
			if ( flag == 'Y' || flag == undefined ) {
				grid.data.length = 0;
				grid.loadingPage = 0;
				grid.rtnNextPageFunc = getData;

				unit = $('#unit').val();
				startDate = $('#startDate').val();
				endDate = $('#endDate').val();
				title = $('#title').val();
				sendUser = $('#sendUser').val();
				receiveUser = $('#receiveUser').val();
				keyword = $('#keyword').val();
				fileSize = $('#fileSize').val();
				interGroup = $("#interGroup option:selected").val();
				interGroupName = $("#interGroup option:selected").text();
			} else {
				grid.loadingPage++;
			}
			
			searchFlag = true;
			grid.on();
			ui.get({
				url : 'analysis/dataRelationList.xcn',
				unit : unit,
				startDate : startDate,
				endDate : endDate,
				title : title,
				sendUser : sendUser,
				receiveUser : receiveUser,
				keyword : keyword,
				fileSize : fileSize,
				interGroup : interGroup,
				interGroupName : interGroupName,
				offset : grid.data.length,
				limit : grid.pageSize,
				success : function(data, total) {
					if ( flag == 'Y' || flag == undefined ) resultTotal = total;
					grid.autoNumber();
					colInit();
					grid.loadHeader(false);
					grid.appendData(data);
					$('#statlist_cnt').html('<s:message code="analysis.ui.searchend"/>: '+grid.data.length);
					searchFlag = false;
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
					grid.off();
				}
			});
		}

		function chartFullClose() {
			$("#graphFull").html("");
			processmap('graph', processMapData, 1000, 900);
			$('.chartFull').hide();
		}

		function chartFullView() {
			$('.chartFull').show();
			$("#graph").html("");
			processmap('graphFull', processMapData, $("#relation_divFull").width(), $("#relation_divFull").height() - 50);
		}
		var listData = '';
		function getDetailData(data) {
			listData = data;
			$("#relation_div").show();
			ui.on("relation_div");
			ui.get({
				url : 'analysis/dataDetailList.xcn',
				listData : data,
				unit : unit,
				startDate : startDate,
				endDate : endDate,
				title : title,
				sendUser : sendUser,
				receiveUser : receiveUser,
				keyword : keyword,
				fileSize : fileSize,
				interGroup : interGroup,
				interGroupName : interGroupName,
				success : function(data, total) {
					if(data.processmap.isOver) {
						alert('<s:message code="analysis.relation.ui.msg4"/>')
					}
					

					// 차트 확장의 위한 준비
					processMapData = data.processmap;
					$("#chartFull").show();

					processmap('graph', data.processmap, 1000, 900);
					timeline.chart('timeline', data.timeline);
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
					ui.off("relation_div");
				}
			});
		}

		var selectName = '';
		function getSelectList(name){
			selectName = name;
			getSelectMessageList('Y');
		}

		function getSelectMessageList(flag){
			if ( flag == undefined || flag == 'Y') {
				tabGrid.data.length = 0;
				tabGrid.rtnNextPageFunc = getSelectMessageList;
				tabGrid.loadingPage = 0;
			} else {
				tabGrid.loadingPage++;
			}

			tabGrid.on();
			ui.get({
				url : 'analysis/dataSelectList.xcn',
				listData : listData,
				unit : unit,
				startDate : startDate,
				endDate : endDate,
				title : title,
				sendUser : sendUser,
				receiveUser : receiveUser,
				keyword : keyword,
				fileSize : fileSize,
				interGroup : interGroup,
				interGroupName : interGroupName,
				name : selectName,
				offset : tabGrid.data.length,
				limit : tabGrid.pageSize,
				success : function(data, total) {
					$('.codeTab li:eq(1) a').tab('show');
					tabGrid.appendData(data.emass);
					$(".resultCnt").html('('+addCommas(total)+')');
					if ( tabGrid.loadingPage == 0 ) tabGrid.Select(-1,-1);
				},
				error : function(status, message) {
					ui.alertMsg(message);
				},
				complete : function() {
					tabGrid.off();
				}
			});
		}

		/**
		 * 관심사용자 리스트 조회
		 */
		function getInterestUserOptions(){
			ui.get({
				url : 'getAdminUserGroupList.xcn',
				success : function(data, total) {
					 var result = '';
					result+='<option value=""><s:message code="analysis.ui.all"/></option>';
					for(var i=0 ; i<data.length; i++){
						result+='<option value="' + data[i].groupSeq + '">' +  data[i].groupName + '</option>';
					}
					$("#interGroup").html(result);
					
					//off('interestUser.service.amount');
				},
				error : function(status, message) {
					//ui.alertMsg(message);
				},
				complete : function() {
				}
			});
		}

		/*
		 * tabGrid 관련 함수
		 */
		function viewer_open(row, bodySize ){
			var msgid = tabGrid.getValue(row, 'msgid');

			openMessageBodyPop( tabGrid.id, msgid, '', bodySize);
			
			var readYn = tabGrid.getValue(row, 'readYn');
			tabGrid.setValue(row, tabGrid.ColIndex('readYn'), 'Y');
			tabGrid.Select(row,0);
		}

		function viewer_newOpen(row){
			var msgid = tabGrid.getValue(row, 'msgid');
			openMessageBodyPop( '', msgid, '', bodySize);
			
			var readYn = tabGrid.getValue(row, 'readYn');
			tabGrid.setValue(row, tabGrid.ColIndex('readYn'), 'Y');
		}

		function prevMsg( ) {
			var grid = tabGrid;
			var row = 0;
			if( grid.Row > 0 ) {
				row = --grid.Row;
				viewer_open(row);
				grid.Select(row,0);
				return true;
			}
			return false;
		}

		function nextMsg( ) {
			var grid = tabGrid;
			var row = 0;
			if( grid.Row < grid.Rows - 1 ) {
				row = ++grid.Row;
				viewer_open(row);
				grid.Select(row,0);
				if( grid.Row == grid.Rows - 2  ){
					getList( true );
				}
				return true;
			}
			return false;
		}

	</script>