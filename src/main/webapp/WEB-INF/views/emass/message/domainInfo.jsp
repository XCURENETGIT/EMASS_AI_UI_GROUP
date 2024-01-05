<%@page import="net.sf.json.JSONObject"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	JSONObject param = Common.getParam ( request );
	String msgId = Common.nvl( param.get("msgId"));
	String type = Common.nvl( param.get("type"));
	String inOutInfo = Common.nvl( param.get("inOutInfo"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS PRO - <s:message code="common.msg.domainInfo"/></title>
<style type="text/css">
html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
.attachExt{
	cursor:pointer;
}
.slick-group-title[level='0'] {
      font-weight: bold;
    }
</style>
<script type="text/JavaScript">
var msgId = '<%=msgId%>';
var type = '<%=type%>';
var inOutInfo = '<%=inOutInfo%>';
var dataView;
$(document).ready(function(){
	$('#noSelectBtn').click(function(){ self.close();  });
	
	$('#inoutType,#recvType').on('change', function() {
		getRecvDomainInfo();
	});
	
	getRecvDomainInfo();
});

function getRecvDomainInfo(inside) {
	var recvsType = $('#recvType').val();
	var inside = $('#inoutType').val();
	
	if(inside == 'B') {
		inside = 'N';
	} else if(inside == 'L'){
		inside = 'Y';
	}
	
	dataView.beginUpdate();
	dataView.setItems([]);
	dataView.endUpdate();
	
	ui.get({
		url : 'getRecvDomainInfo.xcn',
		msgId : msgId,
		inside : inside,
		recvsType : recvsType,
		success: function(data, total) {
			data.map((d,i) => {
				d.id = i+1;
			})
			dataView.beginUpdate();
			if(data.length == 0) {
				$('#userGrid .grid-canvas' ).html ( '<div class="ui-widget-content slick-row even nodata_msg"><div class="slick-cell l0 r4 slick-init-msg"><s:message code="common.msg.nodata" /></div></div>' );
			} else {
				$('#userGrid .grid-canvas' ).html ('');
				
				dataView.setItems(data);
				dataView.setGrouping({
					getter: "domain",
					formatter: function (g) {
					  return '<s:message code="common.msg.domain" />:  ' + g.value + '  <span style="color:green">(' + g.count + ' <s:message code="common.msg.cnt" />)</span>';
					},
					lazyTotalsCalculation: true
				});
			}
			dataView.endUpdate();
			$('#recvsResultCnt').html(data.length.comma());
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			
		}
	})
}

function comparer(a, b) {
	var x = a[sortcol], y = b[sortcol];
	return (x == y ? 0 : (x > y ? 1 : -1));
}
</script>
</head>
<body class="mini-navbar msgBody">
	<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="common.msg.domainInfo"/></span>
		</div>
	</header>

	<div class="xcn_container" style="min-width: 650px;">
		<div class="boxArea" style="min-height:inherit;">
			<div class="content_body">
				<div class="row">
					<div class="col-xs-9">
						<div class="form-inline not-dashed">
							<div class="form-group">
								<select class="form-control input-sm" id="recvType" style="max-width: 200px;">
									<option value="" selected>- <s:message code="common.recv.type" /> -</option>
									<option value="T"><s:message code="condition.to"/></option>
									<option value="C"><s:message code="condition.cc"/></option>
									<option value="B"><s:message code="condition.bcc"/></option>
								</select>
								<select class="form-control input-sm" id="inoutType" style="max-width: 200px;">
									<option value="" selected>- <s:message code="message.msg.inout" /> -</option>
									<option value="L"><s:message code="message.msg.in" /></option>
									<option value="B"><s:message code="message.msg.out" /></option>
								</select>
								<div style="float:right;line-height:25px;padding-right:15px;padding-top:5px;color: #f25643; font-weight: bold; font-size: 13px;">
									&nbsp;&nbsp;<s:message code="common.msg.finish_query"/> : <span id="recvsResultCnt">0</span>
								</div>
							</div>
						</div>
					</div>
					<div class="col-xs-3 text-right">
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-xs-12" style="height: 100%;">
						<div id="userGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var groupItemMetadataProvider = new Slick.Data.GroupItemMetadataProvider();
		dataView = new Slick.Data.DataView({
		    groupItemMetadataProvider: groupItemMetadataProvider,
		    inlineFilters: true
		  });
		
		var grid = new Xgrid('userGrid', contextRoot, null, null, dataView);
		grid.grid.registerPlugin(groupItemMetadataProvider);
		grid.colAdd('utype', '<s:message code="common.msg.information"/>', 80, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			if (value == 'U') return '<s:message code="consent.user"/>';
			else if (value == 'F') return '<s:message code="condition.sender"/>';
			else if (value == 'T') return '<s:message code="condition.to"/>';
			else if (value == 'C') return '<s:message code="condition.cc"/>';
			else if (value == 'B') return '<s:message code="condition.bcc"/>';
			else return '-';
		});
		grid.colAdd('recvId', 'ID', 190, 'left', false, 'nomal');
		grid.colAdd('name', '<s:message code="common.msg.name"/>', 150, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			if(value == null) return '-';
			else return value;
		});
		grid.colAdd('deptNm', '<s:message code="common.org.dept"/>', 100, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			if (value == null) return '-'; 
			else return value;
		});
		grid.colAdd('busiNm', '<s:message code="common.org.busi"/>', 100, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
			if (value == null) return '-'; 
			else return value;
		});
		
		grid.loadHeader(false); 
		dataView.onRowCountChanged.subscribe(function (e, args) {
			grid.grid.invalidate();
			grid.grid.updateRowCount();
			grid.grid.render( );
			dataView.refresh();
		});
		
		dataView.onRowsChanged.subscribe(function (e, args) {
			grid.grid.invalidate();
			grid.grid.invalidateRow(args.rows);
			grid.grid.render( );
			dataView.refresh();
		});
		grid.grid.onSort.subscribe(function (e, args) {
			sortdir = args.sortCols[0].sortAsc ? 1 : -1;
			sortcol = args.sortCols[0].sortCol.field;
			
			if ($.browser.msie && $.browser.version <= 8) {
			  // use numeric sort of % and lexicographic for everything else
			  dataView.fastSort(sortcol, args.sortAsc);
			}
			else {
			  // using native sort with comparer
			  // preferred method but can be very slow in IE with huge datasets
			  dataView.sort(comparer, args.sortCols[0].sortAsc);
			}
			
			grid.grid.invalidate();
			grid.grid.render();
		});
	</script>
</body>
</html>