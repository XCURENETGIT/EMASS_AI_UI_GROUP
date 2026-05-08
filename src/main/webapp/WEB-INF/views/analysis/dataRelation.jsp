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
	.tab-content {padding:10px; background-color: #fff !important; border:1px solid #ddd;}
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
		/*padding:3px;*/
		/*margin-top:5px;*/
		margin-right:4px;
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

	.chartAread1 {display: grid; grid-template-columns: 700px 1fr; margin-bottom:24px; column-gap: 12px;}
	.chartAread1 > div {position: relative;}

	.vis-item-content > a {color:black; text-decoration: none; padding:0;margin:0;font-size:12px;}
	.vis-item-content > a:active {}
	.vis-item-content > a:hover {text-decoration:underline;color:black; }


	.subtab {display:inline-block; overflow: hidden; padding:0 !important;}

	.contentSub {position: relative; padding:20px 20px 28px 20px;  *zoom:1; }

</style>
<s:message code="common.datescript" var="ko"/>
<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"></input>
	<input type="hidden" name="oldConm" id="oldConm"></input>
	<input type="hidden" name="oldDept" id="oldDept"></input>
	<input type="hidden" name="oldJib" id="oldJib"></input>
	<input type="hidden" name="oldEmail" id="oldEmail"></input>
</form>

<script>
    var searchFlag = false;
    var resultTotal = 0;
    var detailTotal = 0;
    var rowKey = "";
    var colKey = "";
    var confColor = [<%=colorCode%>];
    var confGroup = [<%=groupName%>];

    $(document).ready(function(){
        initCondition();
		dateDefault();
        initDateTimePicker('startDate','endDate');
        getData ('Y');
        /* 보낸사람 */
        $('#senders').click(function () {
            var code = $(this).attr('id');
            openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val(), $('#' + code + 'Dept').val(), $('#' + code + 'Jib').val());
        });

        /* 받는사람 */
        $('#receivers').click(function () {
            var code = $(this).attr('id');
            openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val(), $('#' + code + 'Dept').val(), $('#' + code + 'Jib').val() ,$('#' + code + 'Email').val());
        });




        $(document).on('click', '#sendersSelectedArea', function (e) {
            $('#sendersStr, #sendersVal,#sendersDept, #sendersJib, #sendersEmail').val('');
            $('#sendersSelectedArea').hide();
        });

        $(document).on('click', '#receiversSelectedArea', function (e) {
            $('#receiversStr, #receiversVal,#receiversDept, #receiversJib, #receiversEmail').val('');
            $('#receiversSelectedArea').hide();
        });



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
            searchReset();
        });


        $('#fileSize').on('keyup', function(){
            var inputValue = $(this).val();
            if(!/^\d+$/.test(inputValue)){
                $(this).val('');
            }
        });

        $("#startDate, #endDate, #dynamicSearch, #senders, #receivers, #keyword, #fileSize").keyup(function(event){
            eventEnterSearch(event);
        });

        $(".numberinput").forceNumeric();

        getInterestUserOptions();
        // console.log(tabGrid);
        console.log(messageGridColumn);

        initGrid(tabGrid, messageGridColumn);

        $('#chartPopover [data-toggle="popover"]').popover({
            html: true,
            content: function() {
                return $('#popover-content-chart').html();
            }
        });

        $('#chartFull').click(function(){
            chartFullView();
        });


    });



    function searchReset() {
        $('#startDate').val(new Date().format('yyyy-mm-dd'));
        $('#endDate').val(new Date().format('yyyy-mm-dd'));
        $('#unit').val('file');
        $('#interGroup,#dynamicSearch, #sendersValVal,#sendersStr,#receiversVal,#receiversStr,#keyword,#fileSize,#sendersVal,#sendersDept,#sendersJib,#sendersEmail,#receiversVal,#receiversDept,#receiversJib,#receiversEmail').val('');
       $('#sendersSelectedArea').hide();
       $('#receiversSelectedArea').hide();
    }

    function eventEnterSearch(event) {
        if(event.keyCode == 13){
            $("#btnSearch").click();
        }
    }

    function dateDefault() {
        $('#startDate').val(addDay(0));
        $('#endDate').val(addDay(0));
    }

    function initCondition(){
        getCodeList('busi');
        getCodeList('dept');

        $('#busiSelect').selectpicker({
            size: 15,
            width: '300px',
            searchLabel: true,
            noneSelectedText: '<s:message code="common.org.busi.all"/>',
            noneResultsText: '<s:message code="common.msg.noresult"/>' + ' ',
            selectAllText: '<s:message code="common.msg.select_all"/>',
            deselectAllText: '<s:message code="common.msg.unselect_all"/>',
        });

    }


    function openCodeWindow(id, oldCode, oldConm,oldDept,oldJib, oldEmail) {
        $('#oldCode').val(oldCode);
        $('#oldConm').val(oldConm);
        $('#oldDept').val(oldDept);
        $('#oldJib').val(oldJib);
        $('#oldEmail').val(oldEmail);



		var url = '<c:url value="/commons/selectCode.do?codeType='+id+'"/>';
		var pop = fnOpenWindow('', 'selectCodeWinPopup', 1200, 700, 'resize');

		$('#codeParam').attr('target', 'selectCodeWinPopup');
		$('#codeParam').attr('action', url);
		$('#codeParam').attr('method', 'post');
		$('#codeParam').submit();
	}



</script>
<div>
	<!-- 검색 -->
	<div class="searchArea">
		<div class="searchSub" style="width: 100%;">
			<div class="searchSub_Box">
				<div id="startDatePicker"><input type="text" class="txt_center"  id="startDate" name='startDate' style="width: 110px;">
					<span class="hyphen">~</span></div>
				<div id="endDatePicker"><input type="text" class="txt_center"  id="endDate" name='endDate' style="width: 110px;"></div>
				<div class="form-group optiotab">
					<button type="button" id="dateYesterday" accesskey="Y" style="width:85px;"><s:message code="condition.yesterday"/></button>
					<button type="button" id="dateToday" accesskey="T" style="width:85px;"><s:message code="condition.today"/></button>
					<button type="button" id="dateWeek" accesskey="W" ><s:message code="condition.week" arguments="1" argumentSeparator="|"/></button>
					<button type="button" id="dateMonth" accesskey="M"><s:message code="condition.month" arguments="1" argumentSeparator="|"/></button>
				</div>
			</div>
			<div class="searchSub_Box">

				<%-- searchType --%>
				<div>
					<select id="unit" name="unit">
						<option value="mailid"><s:message code="analysis.relation.mailid"/></option>
						<option value="messenger"><s:message code="analysis.relation.messenger"/></option>
					</select>
				</div>

				<%-- 동적 검색 내용--%>
				<div>
					<input type="text" id="dynamicSearch" placeholder="<s:message code="common.search"/>" name="dynamicSearch" style="width: 325px;">
				</div>
				<%-- 첨부파일 크기--%>
				<div>
					<input type="text" id="fileSize" name="fileSize"  style="width: 130px;"placeholder="<s:message code="analysis.relation.attachsize"/>" maxlength="8" /><span class="fs12 mal4">(MByte <s:message code="filterInfo.rangeL"/>)</span>
				</div>
				<%-- 예약어 --%>
				<div>
					<input type="text" id="keyword" name="keyword" placeholder="<s:message code="condition.keyword"/>" style="width: 160px;" class="input-sm form-control" />
				</div>



				<%-- 관심 사용자 선택 --%>
				<div>
					<select id="interGroup" name="interGroup" class="input-sm form-control">
						<option value=""><s:message code="interest.user"/></option>
					</select>
				</div>
				<%-- 보낸사람 --%>
				<div>
					<button class="btn01" id="senders"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
							code="common.org.choose.sendUser"/></button>
					<span id="sendersSelectedArea" class="codeSelectedBtn" style="display: none;" >
							<button type="button" class="btn num_add bornone"  style="z-index: 2;" >0</button>
					</span>
					<input type="hidden" id="sendersStr" class="selectedTitle"/>
					<input type="hidden" id="sendersVal"/>
					<input type="hidden" id="sendersDept"/>
					<input type="hidden" id="sendersJib"/>
					<input type="hidden" id="sendersEmail"/>
				</div>

				<%-- 받는사람 --%>
				<div>
					<button class="btn01" id="receivers"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
							code="common.org.choose.receiveUser"/></button>
					<span id="receiversSelectedArea" class="codeSelectedBtn"  style="display: none;">
							<button type="button" class="btn num_add bornone"  style="z-index: 2;">0</button>
						</span>
					<input type="hidden" id="receiversStr" class="selectedTitle"/>
					<input type="hidden" id="receiversVal"/>
					<input type="hidden" id="receiversDept"/>
					<input type="hidden" id="receiversJib"/>
					<input type="hidden" id="receiversEmail"/>
				</div>
				<div class="btnform">
					<button type="button" accesskey="Q" class="form_btn01" id="btnSearch"><s:message code="common.msg.search"/></button>
					<button type="button" accesskey="Q" class="form_btn02" id="btnReset"><s:message code="condition.reset"/></button>
				</div>
			</div>
		</div>
		<!-- //검색 -->
	</div>
	<div class="content">
		<div class="contentSub">
			<div class="chartAread1">
				<!-- 리스트-->
				<div>
					<h3 style="margin-bottom: 9px"> List</h3>
					<div class="inner_personaldata p20" style="height: 542px;"style="overflow-y: scroll;" >
						<div id="basicStatListGrid" class="slickGrid gridArea" style="min-height: 280px;max-height: 480px;"></div>
					</div>
				</div>
				<!-- //리스트-->
				<!-- 관계도 -->
				<div>
					<div class="panel-heading">
						<h3><span><s:message code="analysis.relation.ui.relationships"/></span></h3>
						<%-- 확대 --%>
						<span id="chartFull" class="btn-full" style="display:none">
									<span class="glyphicon glyphicon glyphicon-fullscreen"  data-trigger="focus" data-container="#chartFull" style="font-size:20px; cursor: pointer"></span>
								</span>
						<div id="popover-content-chart" class="hide">
							<div style="padding-left:10px;">
								<ul style="padding-left:15px;">
									<li style="margin-bottom:7px;"><s:message code="analysis.relation.ui.msg1"/></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="inner_personaldata p20">
						<div id="relation_div" >
							<div id="graph-container" style="height: 500px; overflow:hidden">
								<div id="graph"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- //관계도 -->
			<!-- 탭 -->
			<div class="subtab">
				<ul class="nav nav-tabs codeTab" id="codeTab">
					<li class="active" ><a data-target="#result0" aria-controls="result0" role="tab" data-toggle="tab" style="cursor: pointer">Timeline</a></li>
					<li><a data-target="#result1" aria-controls="result1" role="tab" data-toggle="tab" style="cursor: pointer"><s:message code="analysis.relation.ui.selectlist"/> <span class="resultCnt"></span></a></li>
				</ul>
			</div>
			<!-- //탭 -->
			<div>
				<div class="tab-content" style="height:100%"; id="resultData">
					<div role="tabpanel" class="tab-pane fade active in" id="result0">
						<div id="timeline" style="min-height:340px;">
							<div style="padding: 5px;"><s:message code="analysis.relation.ui.notimeline"/></div>
						</div>
					</div>
					<div role="tabpanel" class="tab-pane fade in" id="result1">
						<div id="selectList">
							<div style="min-height:340px;height: 340px;">
								<div id="selectGrid" class="slickGrid gridArea" style="height: 100%; min-height:305px;"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>

	<div id="chartFullDiv" class="chartFull" style="display:none">
		<div class="panel panel-default" style="min-height:800px; height:800px;">
			<div class="panel-heading" style="padding: 9px 15px 1px;">
				<h3><span><s:message code="analysis.relation.ui.relationships"/></span></h3>
				<span class="btn-popover" style="top:1px;">
						<span class="glyphicon glyphicon-remove" style="font-size:20px; cursor: pointer" onclick="javascript:chartFullClose();"/>
				</span>
			</div>
			<div class="panel-body" style="height: 100%;padding:0px;">
				<div id="relation_divFull" >
					<div id="graph-containerFull">
						<div id="graphFull" ></div>
					</div>
				</div>
			</div>
		</div>
	</div>

</div>
<!-- Back to top -->
<%--	<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>--%>

<script type="text/javascript" src="<c:url value="/js/bihisankey.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/usersankey.js"/>"></script>
<script type="text/javascript">

    var unit = '';
    var startDate = '';
    var endDate = '';
    var listData = '';
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
        grid.colAdd('count', '<s:message code="analysis.relation.ui.collectcount"/>', 130, 'center', false, 'nomal' , function ( row, cell, value, columnDef, dataContext ) {
            if ( value != undefined ) return value.comma();
            else return '';
        } );
        grid.colAdd('size', '<s:message code="analysis.relation.ui.packetsize"/>', 150, 'right', false, 'nomal' , function ( row, cell, value, columnDef, dataContext ) {
            if ( value != undefined ) return convertFileSize(value);
            else return '';
        });

        //grid.pageSize = 100;
    }

    var unit, startDate, endDate, dynamicSearch, sendUser, receiveUser, keyword, fileSize, processMapData;

    function getData( flag ) {
        listData = '';
        if($('#startDate').val() > $('#endDate').val()) {
            alert('<s:message code="analysis.relation.ui.msg3"/>');
            return;
        }
        if ( searchFlag ) return;

        /* 보낸 사람 , 받는 사람 */

        var sendUv = $('#sendersEmail').val().split('|');
        var sendUser = sendUv.join(',');
        var sendUserStr ='';
        if (sendUser != '') sendUserStr = sendUser;
        else sendUserStr = '';

        var receiveUv = $('#receiversEmail').val().split('|');
        var receiveUser = receiveUv.join(',');
        var receiveUserStr ='';
        if (receiveUser != '') receiveUserStr = receiveUser;
        else receiveUserStr = '';



        if ( flag == 'Y' || flag == undefined ) {
            grid.data.length = 0;
            grid.loadingPage = 0;
            grid.rtnNextPageFunc = getData;
            unit = $('#unit').val();
            startDate = $('#startDate').val();
            endDate = $('#endDate').val();
            listData = $('#listData').val();
            sendUser = sendUserStr;
            receiveUser = receiveUserStr;
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
            listData : $('#dynamicSearch').val(),
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

        var sendUv = $('#sendersEmail').val().split('|');
        var sendUser = sendUv.join(',');

        var receiveUv = $('#receiversEmail').val().split('|');
        var receiveUser = receiveUv.join(',');

        $("#relation_div").show();
        ui.on("relation_div");
        ui.get({
            url : 'analysis/dataDetailList.xcn',
            listData : data,
            unit : unit,
            startDate : startDate,
            endDate : endDate,
            sendUser : sendUser,
            receiveUser : receiveUser,
            keyword : keyword,
            fileSize : fileSize,
            interGroup : interGroup,
            interGroupName : interGroupName,
            success : function(data, total) {
                console.log(data)
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
            var sendUv = $('#sendersEmail').val().split('|');
            var sendUser = sendUv.join(',');

            var receiveUv = $('#receiversEmail').val().split('|');
            var receiveUser = receiveUv.join(',');

            tabGrid.data.length = 0;
            tabGrid.rtnNextPageFunc = getSelectMessageList;
            tabGrid.loadingPage = 0;
        } else {
            tabGrid.loadingPage++;
        }
        let searchAfter = null;
        if(tabGrid.loadingPage > 0) {
            searchAfter = tabGrid.getValue(tabGrid.data.length-1, 'msgid');
        }

        tabGrid.on();
        ui.get({
            url : 'analysis/dataSelectList.xcn',
            listData : listData,
            unit : unit,
            startDate : startDate,
            endDate : endDate,
            searchAfter : searchAfter,
            sendUser : sendUser,
            receiveUser : receiveUser,
            keyword : keyword,
            fileSize : fileSize,
            interGroup : interGroup,
            interGroupName : interGroupName,
            ip : selectName,
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
                result+='<option value=""><s:message code="condition.select.interest"/></option>';
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
        tabGrid.setValue(row, 'readYn', 'Y');
        tabGrid.Select(row,0);
    }

    function viewer_newOpen(row){
        var msgid = tabGrid.getValue(row, 'msgid');
        openMessageBodyPop( '', msgid, '', bodySize);

        var readYn = tabGrid.getValue(row, 'readYn');
        tabGrid.setValue(row, 'readYn', 'Y');
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

    function getSelectedCodeData(codeType, data) {
        var str = '';
        var email = '';
        var val = '';
        var dept = '';
        var jib = '';

        for (var i = 0; i < data.length; i++) {
            str += data[i].codeName;
            val += data[i].code;
            // email += data[i].email;
            dept += (data[i].tempNm1 !== undefined) ? data[i].tempNm1 : "";

            jib += (data[i].tempNm2 !== undefined) ? data[i].tempNm2 : "";

            email += (data[i].email !== undefined) ? data[i].email : "";

            if (i != data.length - 1) {
                str += ', ';
                val += '|';
                dept += '|';
                jib += '|';
                email += '|';
            }
        }

        if (val != '') {
            str = str.rtrim();
            val = val.trimAll();
            dept = dept.trimAll();
            jib = jib.trimAll();
            email = email.trimAll();
        }

        $('#' + codeType + 'Str').val(str);
        $('#' + codeType + 'Val').val(val);
        $('#' + codeType + 'Dept').val(dept);
        $('#' + codeType + 'Jib').val(jib);
        $('#' + codeType + 'Email').val(email);

        if ($('#' + codeType + 'Str').val() != '') {
            $('#' + codeType + 'SelectedArea').find('.btn').text(data.length);
            $('#' + codeType + 'SelectedArea').show();
        } else {
            $('#' + codeType + 'SelectedArea').find('.btn').text(0);
            $('#' + codeType + 'SelectedArea').hide();
        }
    }



</script>