<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<script type="text/javascript">
var searchFlag=false;
var orgStartIp ='';
var orgEndIp ='';
$(document).ready(function(){
	$('#searchBtn').click(function(){
		getData();
	});
	$('#searchStrInput').enter(function(){
		getData();
	});
	
	getData();
});

function getData(lastRow) {
	if(searchFlag) return;
	if ( lastRow == undefined ) {
		grid.data.length = 0;
		grid.rtnNextPageFunc = getData;
		grid.loadingPage = 0;
	} else {
		grid.loadingPage++;
	}

	grid.on();
	searchFlag=true;
	var searchStrInput= $("#searchStrInput").val();
	var ipSig = false;
	if(checkIP(searchStrInput)){
		ipSig = true;
	}
	
	ui.get({
		url : 'getIpRangeDeptList.xcn',
		searchStr : searchStrInput,
		adminId : adminId,
		ipSig : ipSig,
		offset : grid.data.length,
		limit : grid.pageSize,
		success : function(data, total) {
			grid.appendData(data);
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			searchFlag=false;
			grid.off();
		}
	});
}
</script>
</head>

<div>
	<div class="searchArea">
		<div class="searchSub">
			<div>
				<input type="text"  placeholder="<s:message code="ipRange.msg.enter.busicomment"/>" id="searchStrInput">
				<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.msg.search"/></button>
			</div>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					부서 내부 ip 확인
					<span id="relationKeywordCount"></span>
				</button>
			</div>
			<div id="ipRangeDeptListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>

	<script type="text/javascript">
		var grid = new Xgrid('ipRangeDeptListGrid', contextRoot);
		grid.onCheckBox();
		grid.autoNumber();
		grid.colAdd('deptNm', '<s:message code="common.org.dept"/>', 200, 'left', false, 'nomal');
		grid.colAdd('pdeptNm','<s:message code="common.org.pdept"/>', 200, 'left', false, 'nomal',function ( row, cell, value, columnDef, dataContext ) {
			if(value =='' || value == null) return '-';
			else return value;
		});
		grid.colAdd('startIp', '<s:message code="didBlock.startip"/>', 150, 'center', false, 'nomal');
		grid.colAdd('endIp', '<s:message code="didBlock.endip"/>', 150, 'center', false, 'nomal');
		grid.colAdd('comment', '<s:message code="common.msg.comment"/>', 250, 'left', false, 'nomal');
		grid.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 140, 'center', false, 'nomal');
        grid.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 140, 'center', false, 'nomal');
        grid.colAdd('createId', '<s:message code="filterInfo.createId"/>', 140, 'center', false, 'nomal');
        grid.colAdd('updateDt', '<s:message code="filterInfo.updateDt"/>', 140, 'center', false, 'nomal');
        grid.colAdd('updateId', '<s:message code="filterInfo.updateId"/>', 140, 'center', false, 'nomal');

        grid.loadExportMenu('<s:message code="ipRange.set.iprange"/>');
		grid.loadPageSize();
		grid.loadHeader(true);
		grid.initData('<s:message code="common.msg.search.click"/>');
		grid.changePageSize = function(cnt){
			getData();
		};
	</script>
	<form method="post" id="codeParam">
		<input type="hidden" name="oldCode" id="oldCode"/>
		<input type="hidden" name="oldConm" id="oldConm"/>					
	</form>
