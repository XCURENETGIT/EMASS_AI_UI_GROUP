<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title></title>
<style>
.table-striped > tbody > tr:nth-of-type(2n+1){background-color: #fff;}
</style>
<script>
var clickFlag = false;
$(document).ready(function(){
	$('#searchBtn').click(function(){
		
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
	
	$('.print_link2').click(function() {
		if( $('input:checkbox[name="reportMenu"]:checked').length == 0 ) {
			alert('<s:message code="report.msg.select.statitem"/>');
			return;
		}
		print($('#printDiv').html());
	});
	
	$('.excel_link3').click(function() {
		if( $('input:checkbox[name="reportMenu"]:checked').length == 0 ) {
			alert('<s:message code="report.msg.select.statitem"/>');
			return;
		}
		
		var check = 'false';
		$('input:checkbox[name="reportMenu"]:checked').each(function(){
			if($(this).attr('id') == 'user_str' || $(this).attr('id') == 'sender_str') check = 'true';
		});
		
		var htmlData = '<html><head><title></title></head><body>'+$('#printDiv').html().replaceAll("\t", "")+'</body></html>';
		var title = $('#repTitle').text();
		reportExcelDownLoad(title, htmlData, check);
	});
	
	$('#changeTitle').click(function() {
		if( $('#inputTitle').val() == '' ) {
			alert('<s:message code="report.message.subject.update"/>');
			return;
		}
		$('#repTitle').text($('#inputTitle').val());
		$('#divTitle').css('display','none');
		$('#inputTitle').val('');
	});
	
	$('input:checkbox[name="reportMenu"]').change(function() {
		var facetfield = $(this).attr("id");
		var repTitle = $(this).val();
		var repListTitle = "rep"+facetfield;
		
		if ($(this).is(":checked")) {
			dateinit();
			if(facetfield=="device") getReportDevice();
			else getData( facetfield, repTitle );
		} else {
			dateinit();
			$("#"+ repListTitle).remove();
			clickFlag = false;
		}
		
		if($('input:checkbox[name="reportMenu"]:checked').length == 14) {
			clickFlag = true;
		}
	});
	
	$('#selectAll').click(function() {
		if(!clickFlag) {
			$('input[name=reportMenu]:checkbox').each(function(){
				if (!$(this).is(":checked")) {
					$(this).prop("checked",true);
					$(this).change();
				}
			});
			clickFlag = true;
		}
	});
	
	$('#unSelectAll').click(function() {
		$('input[name=reportMenu]:checkbox').each(function(){
			if ($(this).is(":checked")) {
				$(this).prop("checked",false);
				$(this).change();
			}
		});
		clickFlag = false;
	});
	
	dateinit();
});

$(document).on('click', '.panel-heading .btn-clickable', function(e){
	var $this = $(this);
	if( $this.find('i').hasClass('fa-chevron-down')) {
		$this.parent().parent().find('.panel-body').slideUp();
		$this.find('i').removeClass('fa-chevron-down').addClass('fa-chevron-up');
	} else {
		$this.parent().parent().find('.panel-body').slideDown();
		$this.find('i').removeClass('fa-chevron-up').addClass('fa-chevron-down');
	}
})

function dateinit() {
	var currentdate = new Date();
	var datetime = '<s:message code="report.msg.date_str" arguments="'+currentdate.getFullYear()+'|'+(currentdate.getMonth()+1)+'|'+currentdate.getDate()+'" argumentSeparator="|"/> '
	//+ currentdate.getHours() + "시 " + currentdate.getMinutes() + "분 " + currentdate.getSeconds() + "초 ";
	$('#reportDate').html(datetime);
	$('#searchDate').html('<s:message code="report.msg.standard.date"/>: ' + $('#startdate').val() + ' ~ ' + $('#enddate').val());
	if($("input:checkbox[name='reportMenu']:checked").length>0) {
		$('#startdate').prop('disabled',true);
		$('#enddate').prop('disabled',true);
	} else {
		$('#startdate').prop('disabled',false);
		$('#enddate').prop('disabled',false);
	}
}

function titlechange() {
	if($('#divTitle').css('display')=="none")
		$('#divTitle').css('display','block');
	else
		$('#divTitle').css('display','none');
}

function print(printArea)
{
		win = window.open(); 
		self.focus(); 
		win.document.open();
		win.document.write('<html><head><title></title><link rel="stylesheet" href="<c:url value="/css/bootstrap.min.css"/>"/>');
		win.document.write('<link rel="stylesheet" href="<c:url value="/css/bootstrap.min.css"/>" media="print" />');
		win.document.write('<style>html, body {width: 800px; height: 1000px; min-width: 800px; } .table-striped > tbody > tr:nth-of-type(2n+1){background-color: #fff;}');
		win.document.write('table th,td {font: 13px/1.6em "Lucida Grande", "DejaVu Sans", "Bitstream Vera Sans", Verdana, Arial, sans-serif;text-align: center; word-wrap: break-word;white-space: pre-wrap;white-space: -moz-pre-wrap;white-space: -pre-wrap;white-space: -o-pre-wrap;word-break:break-all;} .right {text-align: right;} .left {text-align: left;} </style>');
		win.document.write('<style media="print"> @page a4sheet { size: 21.0cm 29.7cm } .a4 { page: a4sheet; page-break-after: always }');
		win.document.write('.hidden-print { display:none; } .visible-print { display:block; }');
		win.document.write('</style>');
		win.document.write('</head><body>');
		win.document.write(printArea);
 		win.document.write('</body></html>');
		win.document.close();
		ui.get({
			url : 'insertAuditListPrint.xcn',
			pMenuId : pMenuId,
			menuId : menuId,
			success : function ( data, total ) {
				
			},
			error : function (status, message) {
				ui.alertMsg(message);
			},
			complete : function (){
				
			}
		});
		setTimeout(function(){
			win.print();
		}, 500);
		//win.close();
}

function reportExcelDownLoad( title, htmlData, check ) {
	ui.postJson({
		url : 'utils/ReportXlsxWriter.do',
		reportDate : $('#reportDate').text(),
		searchDate : $('#searchDate').text(),
		title : title,
		html : htmlData,
		check : check,
		pMenuId : pMenuId,
		menuId : menuId,
		success : function(data, total) {
			try {
				ExcelDown.location.href = '<c:url value="/utils/xlsxDown.do"/>?path=' + data;
			} catch (e) {
				ExcelDown.src = '<c:url value="/utils/xlsxDown.do"/>?path=' + data;
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}

function getReportDevice() {
	var sDate = $('#startdate').val().replaceAll("-","");
	var eDate = $('#enddate').val().replaceAll("-","");
	if(sDate > eDate) {
		ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
		return;
	}
	var addStr = "";
	var addStrDiv = "";
	addStrDiv += "<div class='col-md-12' id='repdevice'>";
	addStrDiv += "</div>";
	$('#reportList').append(addStrDiv);
	
	addStr += "	<div class='panel panel-default'>";
	addStr += "		<div class='panel-heading'>";
	addStr += "			<h3 class='panel-title'><s:message code='OPERATION_MGMT.DEV_INFO'/></h3>";
	addStr += "		</div>";
	addStr += "		<div class='panel-body' id='tabledevice'>";
	
	ui.get({
		url : 'getReportDeviceList.xcn',
		success : function(data, total) {
				addStr += "	<table class='table table-striped' name='<s:message code='OPERATION_MGMT.DEV_INFO'/>'>";
				addStr += "		<thead>";
				addStr += "			<tr>";
				addStr += "				<th><s:message code='common.msg.number'/></th>";
				addStr += "				<th><s:message code='common.msg.device'/>IP</th>";
				addStr += "				<th><s:message code='common.msg.device_name'/></th>";
				addStr += "				<th><s:message code='common.msg.device_type'/></th>";
				//addStr += "			<th>장비상태</th>";
				addStr += "			</tr>";
				addStr += "		</thead>";
				addStr += "		<tbody>";
				for ( var i=0 ; i < data.length ; i++ ) {
					var dataList = data[i];
					var type = dataList.deviceType;
					var status = dataList.deviceStatus;
					if(type=="C") type='<s:message code="device.msg.division.collect"/>';
					else if(type=="A") type='<s:message code="device.msg.all_in_one"/>';
					else if(type=="L") type='<s:message code="device.msg.division.analysis"/>';
					else type="-";
					
					if(status=="S") status='<s:message code="common.msg.success"/>';
					else if(status=="F") status='<s:message code="common.msg.fail"/>';
					else if(status=="T") status='<s:message code="common.msg.connect_fail"/>';
					else if(status=="D") status='<s:message code="common.msg.inconsistant"/>';
					else status="-";
					addStr += "			<tr>";
					addStr += "				<td>"+(i+1)+"</td>";
					addStr += "				<td class='left'>"+dataList.deviceIP+"</td>";
					addStr += "				<td>"+dataList.deviceName+"</td>";
					addStr += "				<td>"+type+"</td>";
					//addStr += "				<td>"+status+"</td>";
					addStr += "			</tr>";
				}
			addStr += "		</tbody>";
			addStr += "	</table>";
			addStr += "</li>";
			addStr += "		</div>";
			addStr += "	</div> ";
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			$('#repdevice').html(addStr);
		}
	});
}

function getData( facetfield, repTitle ) {
	var sDate = $('#startdate').val().replaceAll("-","");
	var eDate = $('#enddate').val().replaceAll("-","");
	if(sDate > eDate) {
		ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
		return;
	}
	var addStr = "";
	var addStrDiv = "";
	addStrDiv += "<div class='col-md-12' id='rep"+facetfield+"'>";
	addStrDiv += "</div>";
	$('#reportList').append(addStrDiv);
	
	addStr += "	<div class='panel panel-default'>";
	addStr += "		<div class='panel-heading'>";
	addStr += "			<h3 class='panel-title'>"+repTitle+" TOP10"+"</h3>";
	addStr += "		</div>";
	addStr += "		<div class='panel-body' id='table"+facetfield+"'>";
	ui.get({
		url : 'getReportCnt.xcn',
		startDate: sDate+"000000",
		endDate: eDate+"235959",
		facet : facetfield,
		limit : 10,
		success : function(data, total) {
			if(total==0) {
				addStr += "<p><s:message code='common.msg.nodata'/><p>";
				addStr += "</li>";	
			} else {
				addStr += "	<table class='table table-stripe' name='"+repTitle+" TOP10'>";
				addStr += "		<colgroup>";
				addStr += "		<col width='70'>";
				if(facetfield == 'user_str' || facetfield == 'sender_str') {
					addStr += "		<col width='250'>";
					addStr += "		<col width='130'>";
					addStr += "		<col width='130'>";
					addStr += "		<col width='130'>";
					addStr += "		<col width='300'>";
					addStr += "		<col width='150'>";
					addStr += "		<col width='250'>";
					addStr += "		<col width='150'>";
				} else {
					addStr += "		<col width='*'>";
					addStr += "		<col width='150'>";
				}
				addStr += "		</colgroup>";
				addStr += "		<thead>";
				addStr += "			<tr>";
				addStr += "				<th style='text-align:center;'><s:message code='common.msg.rank'/></th>";
				addStr += "				<th style='text-align:left;'>"+repTitle+"</th>";
				if(facetfield == 'user_str' || facetfield == 'sender_str') {
					addStr += "			<th style='text-align:left;'><s:message code='common.msg.id'/></th>";
					addStr += "			<th style='text-align:left;'><s:message code='common.msg.name'/></th>";
					addStr += "			<th style='text-align:left;'><s:message code='common.org.conm'/></th>";
					addStr += "			<th style='text-align:left;'><s:message code='common.org.deptnm'/></th>";
					addStr += "			<th style='text-align:left;'><s:message code='common.org.jikgubnm'/></th>";
					addStr += "			<th style='text-align:left;'>E-Mail</th>";
				} 
				addStr += "				<th style='text-align:right;'><s:message code='common.msg.count'/></th>";
				addStr += "			</tr>";
				addStr += "		</thead>";
				addStr += "		<tbody>";
				for ( var i=0 ; i < data.facet.length ; i++ ) {
					var dataList = data.facet[i];
					addStr += "			<tr>";
					addStr += "				<td style='text-align:center;'>"+(i+1)+"</td>";
					addStr += "				<td class='left' style='text-align:left;'>"+dataList.name+"</td>";
					if(facetfield == 'user_str' || facetfield == 'sender_str') {
						addStr += "				<td class='left' style='text-align:left;'>"+dataList.userId+"</td>";
						addStr += "				<td class='left' style='text-align:left;'>"+dataList.name2+"</td>";
						addStr += "				<td class='left' style='text-align:left;'>"+dataList.conm+"</td>";
						addStr += "				<td class='left' style='text-align:left;'>"+dataList.deptnm+"</td>";
						addStr += "				<td class='left' style='text-align:left;'>"+dataList.jikgubnm+"</td>";
						addStr += "				<td class='left' style='text-align:left;'>"+dataList.email+"</td>";
					}
					addStr += "				<td class='right' style='text-align:right;'>"+dataList.count.comma()+"</td>";
					addStr += "			</tr>";
				}
				addStr += "		</tbody>";
				addStr += "	</table>";
				addStr += "</li>";
				addStr += "		</div>";
				addStr += "	</div> ";
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
			$("#rep"+facetfield).html(addStr);
		}
	});
}

</script>
</head>
<body class="mini-navbar">
	
	<div class="container">
		<div class="boxArea">
			<div class="content_body">
				<div class="row">
					<div class="col-xs-8 form-inline not-dashed">
						<div class="form-group form-inline not-dashed">
							<div class='input-group date' id='startdatepicker'>
								<input type='text' class="input-sm form-control" id='startdate' />
								<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
							~
							<div class='input-group date' id='enddatepicker'>
								<input type='text' class="input-sm form-control" id='enddate' />
								<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
							<div class="form-group form-inline not-dashed" style="color: #f25643; font-weight: bold;">&nbsp;&nbsp;<s:message code="report.message.period"/></div>
						</div>
					</div>
					<div class="col-xs-4 text-right">
						<div class="btn-group">
							<button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown">
								<span class="glyphicon glyphicon-download-alt"></span>&nbsp;<s:message code="common.msg.export"/> <span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-right" style="width:80px;" role="menu">
								<li><a href="#" class="excel_link3"><span class="fa fa-file-excel-o" style="font-size:16px"></span>&nbsp;<s:message code="common.msg.excel"/>(xlsx)</a></li>
								<li><a href="#" class="print_link2"><span class="glyphicon glyphicon-print"></span>&nbsp;<s:message code="common.msg.print"/></a></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="row xcn_full top_space">
					<div class="col-lg-3" style="height: 100%">
						<div class="panel panel-default" style="height: 100%;margin-bottom: 0px">
							<div class="panel-heading">
								<i class="fa fa-bar-chart-o fa-fw"></i> <s:message code="report.msg.select.stat"/>
							</div>
							<div class="panel-body" style="height: calc(100% - 38px);">
								<div class="form-inline btn-group" style="width:100%;margin-bottom: 10px;">
									<button class="btn btn-default" type="button" accesskey="Y" id="selectAll"><s:message code="common.msg.select_all"/></button>
									<button class="btn btn-default" type="button" accesskey="N" id="unSelectAll" style="margin-left: 5px;"><s:message code="common.msg.unselect_all"/></button>
								</div>
								<label class="checkbox-inline c-checkbox" style="margin-left:10px; width:100%;margin-bottom: 10px;">
									<input type="checkbox" name="reportMenu" id="device" value="<s:message code="OPERATION_MGMT.DEV_INFO"/>">
									<span class="fa fa-check"></span><i class="fa fa-desktop fa-fw"></i> <s:message code="OPERATION_MGMT.DEV_INFO"/>
								</label>
								<label class="checkbox-inline c-checkbox" style="width:100%;margin-bottom: 10px;">
									<input type="checkbox" name="reportMenu" id="conm" value="<s:message code="common.org.conm"/>">
									<span class="fa fa-check"></span><i class="fa fa-user fa-fw"></i> <s:message code="common.org.conm"/> TOP10
								</label>
								<label class="checkbox-inline c-checkbox" style="width:100%;margin-bottom: 10px;">
									<input type="checkbox" name="reportMenu" id="deptnm" value="<s:message code="common.org.deptnm"/>">
									<span class="fa fa-check"></span><i class="fa fa-user fa-fw"></i> <s:message code="common.org.deptnm"/> TOP10
								</label>
								<label class="checkbox-inline c-checkbox" style="width:100%;margin-bottom: 10px;">
									<input type="checkbox" name="reportMenu" id="user_str" value="<s:message code="consent.user"/>">
									<span class="fa fa-check"></span><i class="fa fa-user fa-fw"></i> <s:message code="consent.user"/> TOP10
								</label>
								<label class="checkbox-inline c-checkbox" style="width:100%;margin-bottom: 10px;">
									<input type="checkbox" name="reportMenu" id="jikgubnm" value="<s:message code="common.org.jikgubnm"/>">
									<span class="fa fa-check"></span><i class="fa fa-user fa-fw"></i> <s:message code="common.org.jikgubnm"/> TOP10
								</label>
								<label class="checkbox-inline c-checkbox" style="width:100%;margin-bottom: 10px;">
									<input type="checkbox" name="reportMenu" id="sender_str" value="<s:message code="condition.sender"/>">
									<span class="fa fa-check"></span><i class="fa fa-paper-plane-o fa-fw"></i> <s:message code="condition.sender"/> TOP10
								</label>
								<label class="checkbox-inline c-checkbox" style="width:100%;margin-bottom: 10px;">
									<input type="checkbox" name="reportMenu" id="svc12" value="<s:message code="condition.service_type"/>">
									<span class="fa fa-check"></span><i class="fa fa-share-alt fa-fw"></i> <s:message code="condition.service_type"/> TOP10
								</label>
								<label class="checkbox-inline c-checkbox" style="width:100%;margin-bottom: 10px;">
									<input type="checkbox" name="reportMenu" id="kwds" value="<s:message code="condition.keyword"/>">
									<span class="fa fa-check"></span><i class="fa fa-key fa-fw"></i> <s:message code="condition.keyword"/> TOP10
								</label>
								<label class="checkbox-inline c-checkbox" style="width:100%;margin-bottom: 10px;">
									<input type="checkbox" name="reportMenu" id="attachtype" value="<s:message code="condition.attach_type"/>">
									<span class="fa fa-check"></span><i class="fa fa-paperclip fa-fw"></i> <s:message code="condition.attach_type"/> TOP10
								</label>
								<label class="checkbox-inline c-checkbox" style="width:100%;margin-bottom: 10px;">
									<input type="checkbox" name="reportMenu" id="attachname_str" value="<s:message code="condition.attach_name"/>">
									<span class="fa fa-check"></span><i class="fa fa-file-word-o fa-fw"></i> <s:message code="condition.attach_name"/> TOP10
								</label>
								<label class="checkbox-inline c-checkbox" style="width:100%;">
									<input type="checkbox" name="reportMenu" id="host_str" value="URL">
									<span class="fa fa-check"></span><i class="fa fa-info-circle fa-fw"></i> URL TOP10
								</label>
							</div>
						</div>
					</div>
					<div class="col-lg-9" style="height: 100%">
						<div class="panel panel-default" style="height: 100%;margin-bottom: 0px">
							<div class="panel-heading">
								<i class="fa fa-file-text-o fa-fw"></i> Report
							</div>
							<div class="panel-body" style="height: calc(100% - 38px);">
								<div id="printDiv" style="border: 1px solid #ccc; overflow: auto; height: 100%">
									<div class ="a4" id="reportDiv" >
										<div class="form-inline hidden-print" style="display: none; text-align:center" id="divTitle">
											<input type="text" class="input-sm form-control" style="width: 250px;" id="inputTitle" maxlength="16">
											<button type="button" class="btn btn-success btn-sm" id="changeTitle"><s:message code="report.msg.rename_subject"/></button>
										</div>
										<h3 style="text-align: center;"><u><a href="#" onclick="titlechange();" id="repTitle">EMASS LTH Report</a></u></h3>
										<br>
										<p id="reportDate" style="text-align: right; padding-right:15px"></p>
										<br>
										<p id="searchDate" style="text-align: right; padding-right:15px"></p>
										<br>
										<div id="reportList">
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
</body>
</html>