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
<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>

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
	<div>
		<!-- 검색 -->
		<div class="searchArea">
			<div class="searchSub_full">
				<form id="frm">
					<div class="searchSub_Box">
						<div>
							<select id="unit" name="unit">
								<option value=""><s:message code="analysis.relation.unit"/>:</option>
								<option value="file"><s:message code="consent.attach"/></option>
								<option value="mailid"><s:message code="analysis.relation.mailid"/></option>
								<option value="messenger"><s:message code="analysis.relation.messenger"/></option>
							</select>
						</div>
						<div id="startDatePicker"><input type="date" id="startDate" name='startDate' style="width: 110px;">
							<span class="hyphen">~</span></div>
						<div id="endDatePicker"><input type="date" id="endDate" name='endDate' style="width: 110px;"></div>
						<div class="form-group optiotab">
							<button type="button" id="dateYesterday" accesskey="Y" style="width:72px;"><s:message code="condition.yesterday"/></button>
							<button type="button" id="dateToday" accesskey="T" style="width:72px;"><s:message code="condition.today"/></button>
							<button type="button" id="dateWeek" accesskey="W" ><s:message code="condition.week" arguments="1" argumentSeparator="|"/></button>
							<button type="button" id="dateMonth" accesskey="M" ><s:message code="condition.month" arguments="1" argumentSeparator="|"/></button>
						</div>
						<div>
							<select id="interGroup" name="interGroup" class="input-sm form-control">
								<option value=""><s:message code="interest.user"/></option>
							</select>
						</div>
						<div>
							<input type="text" placeholder="<s:message code="condition.subject"/>" id="title" name="title"style="width: 325px;">
						</div>
					</div>
					<div class="searchSub_Box">

						<div>
							<input type="text" placeholder="<s:message code="condition.from"/>" id="sendUser" name="sendUser" style="width: 160px;">
						</div>
						<div>
							<input type="text" placeholder="<s:message code="condition.to"/>" id="receiveUser" name="receiveUser"  style="width: 160px;">
						</div>
						<div>
							<input type="text" id="keyword" name="keyword" placeholder="<s:message code="condition.keyword"/>" style="width: 160px;" class="input-sm form-control" />
						</div>

						<div>
							<input type="text" id="fileSize" name="fileSize"  style="width: 80px;"placeholder="<s:message code="analysis.relation.attachsize"/>" maxlength="8" /><span class="fs12 mal4">(MByte <s:message code="filterInfo.rangeL"/>)</span>
						</div>
						<div class="btnform">
							<button type="button" accesskey="Q" class="form_btn01" id="btnSearch"><s:message code="common.msg.search"/></button>
							<button type="button" accesskey="Q" class="form_btn02" id="btnReset"><s:message code="condition.reset"/></button>
						</div>
					</div>
				</form>
			</div>
		</div>
		<!-- //검색 -->
		<div class="content">
			<div class="contentSub">
				<div class="chartArea02">
					<!-- 리스트-->
					<div>
						<h3>List</h3>
						<div class="inner_personaldata p20" style="height: 340px; overflow-y: scroll;">
							<div id="basicStatListGrid" class="slickGrid gridArea"></div>
						</div>
					</div>
					<!-- //리스트-->
					<!-- 관계도 -->
					<div>
						<h3><s:message code="analysis.relation.ui.relationships"/></h3>
						<div class="inner_personaldata p20">
							<div id="graph-container" style="height: 300px; overflow:hidden"></div>
						</div>
					</div>
					<!-- //관계도 -->
				</div>
				<!-- 탭 -->
				<div class="subtab">
					<ul class="nav nav-tabs codeTab" id="codeTab">
						<li class="active" ><a data-target="#result0" aria-controls="result0" role="tab" data-toggle="tab">Timeline</a></li>
						<li><a data-target="#result1" aria-controls="result1" role="tab" data-toggle="tab"><s:message code="analysis.relation.ui.selectlist"/> <span class="resultCnt"></span></a></li>
					</ul>
				</div>
				<!-- //탭 -->
				<div>
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

					console.log(data);


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