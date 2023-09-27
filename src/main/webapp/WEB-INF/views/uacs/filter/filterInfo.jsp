<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title><s:message code="filterInfo.title"/></title>
<%@ include file="../../base.jsp"%>
<style type="text/css">
.radio-inline {
	padding-left: 0px;
}
.ellipsis {
	width:320px;
	text-overflow: ellipsis;
	overflow:hidden;
	white-space:nowrap;
}
.form-inline.exam {
	font-size: 12px;
	padding-left: 15px;
}
</style>
<script type="text/javascript">
var searchFlag=false;
var currentTab;
var gridObj;
var url;
var mode = 'insert';
var pmenu_id = 'POLICY_SETUP';
var menu_id = 'POLICY_NOLOG';

$(document).ready(function(){
	
	$('.print_link2').click(function() {
		if (gridObj.Rows == 0) {
			alert('<s:message code="common.msg.nodata"/>');
			return;
		}
		var title = $('.nav-tabs .active a').text();
		gridObj.print(title, pmenu_id, menu_id);
	});
	$('.excel_link2').click(function() {
		var title = $('.nav-tabs .active a').text();
		setTimeout(function(){
			excelDownLoad(gridObj, title, pmenu_id, menu_id);
		}, 200);
	});
	$('.csv_link2').click(function() {
		var title = $('.nav-tabs .active a').text();
		setTimeout(function(){
			csvDownLoad(gridObj, title, pmenu_id, menu_id);
		}, 200);
	});
	$('.cell_link2').click(function() {
		var title = $('.nav-tabs .active a').text();
		setTimeout(function(){
			cellDownLoad(gridObj, title, pmenu_id, menu_id);
		}, 200);
	});
	$('.pdf_link2').click(function() {
		var title = $('.nav-tabs .active a').text();
		setTimeout(function(){
			pdfDownLoad(gridObj, title, pmenu_id, menu_id);
		}, 200);
	});
	
	$('#searchBtn').click(function(){ getData (); });
	$('#searchStr').enter(function(){ getData (); });
	$('#serviceType').change(function(){ getData(); });
	$('#idServiceCd, #domainServiceCd, #subjectServiceCd, #sizeServiceCd, #attachServiceCd').html( getserviceType() );
	
	$('#sizeCondition').change(function(){
		var sizeCondition = $(this).val();
		$('#highSize').prop('disabled', false);
		if(sizeCondition!='B'){
			$('#highSize').prop('disabled', true);
		}
	});
	
	$(' .nologCheck input:checkbox').change(function(){
		var id = $(this).attr('id');
		if ($(this).is(":checked")) {
			if( id == 'userIpAll' ) {
				$('#userSIp, #userEIp').prop('disabled', true);
			} else if( id == 'userPortAll' ) {
				$('#userSPort, #userEPort').prop('disabled', true);
			} else if( id == 'serverIpAll' ) {
				$('#serverSIp, #serverEIp').prop('disabled', true);
			} else if( id == 'serverPortAll' ) {
				$('#serverSPort, #serverEPort').prop('disabled', true);
			}
		} else {
			if( id == 'userIpAll' ) {
				$('#userSIp, #userEIp').prop('disabled', false);
			} else if( id == 'userPortAll' ) {
				$('#userSPort, #userEPort').prop('disabled', false);
			} else if( id == 'serverIpAll' ) {
				$('#serverSIp, #serverEIp').prop('disabled', false);
			} else if( id == 'serverPortAll' ) {
				$('#serverSPort, #serverEPort').prop('disabled', false);
			}
		}
	});
	
	$(".nav-tabs a").click(function(){
		$('#serviceType, #searchStr').val('').prop('disabled', false);
		$('#searchStr').val('');
		currentTab = $(this).attr('id');
		$('[name=tabId]').val( currentTab );
		$('#serviceType').html( getserviceType() );
		getTabInfo();
		getData();
	});
	
	$('.selBtn').click(function(){
		openWindow('device');
	});
	
	$('#devStatusBtn').click(function(){
		openDevStatus();
	});
	
	$('#insertBtn').click(function(){
		$('#sizeServiceCd').prop('disabled', false);
		$('.savePopBtn').prop('disabled', false);
		mode = 'insert';
		$('#idServiceCd, #domainServiceCd, #subjectServiceCd, #sizeServiceCd, #attachServiceCd').val('');
		$('#userId, #domain, #noLogurl, #subject, #lowSize, #highSize').val('');
		$('#sizeCondition').val('B').trigger( "change" );
		
		$('#idLogSeq, #domainLogSeq, #urlLogSeq, #subjectLogSeq, #sizeLogSeq, #attachLogSeq').val('');

		if( currentTab == 'idTab' ) {
			$("#idPop").modal('show');
		} else if( currentTab == 'ipTab' ) {
			$("#ipPop").modal('show');
			$('input:radio[name=ipVer]:input[value=4]').prop("checked", true);
			$('#userIpAll, #userPortAll, #serverIpAll, #serverPortAll').prop('checked', false);
			$('#userSIp, #userEIp, #userSPort, #userEPort, #serverSIp, #serverEIp, #serverSPort, #serverEPort, #comment').val('').prop('disabled',false);
			$('#ipLogSeq').val('');
			deviceGrid.initData('<s:message code="common.msg.nodata"/>');
		} else if( currentTab == 'domainTab' ) {
			$("#domainPop").modal('show');
		} else if( currentTab == 'urlTab' ) {
			$("#urlPop").modal('show');
		} else if( currentTab == 'subjectTab' ) {
			$("#subjectPop").modal('show');
		} else if( currentTab == 'sizeTab' ) {
			$("#sizePop").modal('show');
		} else if( currentTab == 'attachTab' ) {
			$("#attachPop").modal('show');
		}
	});

	$('.savePopBtn').click(function(){
		$('.savePopBtn').prop('disabled', true);
		var url;
		var popFormId;
		var flag = false;
		if( currentTab == 'idTab' ) {
			url = mode == 'insert' ? 'insertIdFilter.xcn' : 'updateIdFilter.xcn';
			popFormId = 'idPopForm';
			$('[name=serviceNm]').val( $('#idServiceCd option:selected').text());
		} else if( currentTab == 'ipTab' ) {
			url = mode == 'insert' ? 'insertIpFilter.xcn' : 'updateIpFilter.xcn';
			popFormId = 'ipPopForm';
			$('#deviceInfo').val( JSON.stringify(deviceGrid.getData()) );
		} else if( currentTab == 'domainTab' ) {
			url = mode == 'insert' ? 'insertDomainFilter.xcn' : 'updateDomainFilter.xcn';
			popFormId = 'domainPopForm';
			$('[name=serviceNm]').val( $('#domainServiceCd option:selected').text());
		} else if( currentTab == 'urlTab' ) {
			url = mode == 'insert' ? 'insertUrlFilter.xcn' : 'updateUrlFilter.xcn';
			popFormId = 'urlPopForm';
		} else if( currentTab == 'subjectTab' ) {
			url = mode == 'insert' ? 'insertSubjectFilter.xcn' : 'updateSubjectFilter.xcn';
			popFormId = 'subjectPopForm';
			$('[name=serviceNm]').val( $('#subjectServiceCd option:selected').text());
		} else if( currentTab == 'sizeTab' ) {
			url = mode == 'insert' ? 'insertSizeFilter.xcn' : 'updateSizeFilter.xcn';
			popFormId = 'sizePopForm';
			$('[name=serviceNm]').val( $('#sizeServiceCd option:selected').text());
		}
		$('[name=tab]').val( tabIdToText(currentTab) );
		saveData(url, popFormId);
	});
	
	
	
	$('#deleteBtn').click(function(){
		$('#deleteBtn').prop('disabled', true);
		
		var rows = gridObj.getSelectedRows();
		if ( rows.length == 0 ) {
			ui.alertMsg('<s:message code="filterInfo.msg.choose.deleteitem"/>');
			$('#deleteBtn').prop('disabled', false);
			return;
		}
		
		var deleteUrl;
		if( currentTab == 'idTab' ) {
			deleteUrl = 'deleteIdFilter.xcn';
		} else if( currentTab == 'ipTab' ) {
			deleteUrl = 'deleteIpFilter.xcn';
		} else if( currentTab == 'domainTab' ) {
			deleteUrl = 'deleteDomainFilter.xcn';
		} else if( currentTab == 'urlTab' ) {
			deleteUrl = 'deleteUrlFilter.xcn';
		} else if( currentTab == 'subjectTab' ) {
			deleteUrl = 'deleteSubjectFilter.xcn';
		} else if( currentTab == 'sizeTab' ) {
			deleteUrl = 'deleteSizeFilter.xcn';
		}

		ui.confirmMsg('<s:message code="filterInfo.msg.confirm.deleteitem"/>', '', '', function(rs){
			if(rs) {
				gridObj.on();
				ui.get({
					url : deleteUrl,
					deleteData : JSON.stringify(rows),
					tab : tabIdToText(currentTab),
					success : function ( data, total ) {
						ui.alertMsg('<s:message code="common.msg.deleted"/>');
						getData();
					},
					error : function (status, message) {
						ui.alertMsg(message);
					},
					complete : function (){
						$('#deleteBtn').prop('disabled', false);
						gridObj.off();
					}
				});

			} else {
				$('#deleteBtn').prop('disabled', false);
			}
		});
	});
	
	$('#idTab').click();
});

function openDevStatus(){
	var url    = '<c:url value="/uacs/selectDevStatus.do" />';
	var pop = fnOpenWindow('', 'selectDevStatusWinPopup', 1200, 700, 'resize');

	$('#ipPopForm').attr('target','selectDevStatusWinPopup');
	$('#ipPopForm').attr('action', url);
	$('#ipPopForm').attr('method','post');
	$('#ipPopForm').submit();
}

function openWindow(id){
	var url    = '<c:url value="/commons/selectCodeAll.do?codeType='+id+'"/>';
	var pop = fnOpenWindow('', 'selectCodeWinPopup', 860, 500, 'resize');
	$('#ipPopForm').attr('target','selectCodeWinPopup');
	$('#ipPopForm').attr('action', url);
	$('#ipPopForm').attr('method','post');
	$('#ipPopForm').submit();
}

function getSelectedCodeData( data ) {
	deviceGrid.setData( eval( JSON.stringify(data) ) );
}

function validationCheck(){
	$('#userId').val($.trim($('#userId').val()));
	$('#domain').val($.trim($('#domain').val()));
	$('#url').val($.trim($('#url').val()));
	$('#subject').val($.trim($('#subject').val()));
	$('#lowSize').val($.trim($('#lowSize').val()));
	$('#highSize').val($.trim($('#highSize').val()));
	$('#userSIp').val($.trim($('#userSIp').val()));
	$('#userEIp').val($.trim($('#userEIp').val()));
	$('#userSPort').val($.trim($('#userSPort').val()));
	$('#userEPort').val($.trim($('#userEPort').val()));
	$('#serverSIp').val($.trim($('#serverSIp').val()));
	$('#serverEIp').val($.trim($('#serverEIp').val()));
	$('#serverSPort').val($.trim($('#serverSPort').val()));
	$('#serverEPort').val($.trim($('#serverEPort').val()));
	
	
	if( currentTab == 'idTab' ) {
		if( $('#userId').val() == '') {
			alert('<s:message code="filterInfo.msg.enter.id"/>');
			return false;
		}
		if($('#idServiceCd').val() ==''){
			alert('<s:message code="filterInfo.msg.select.service"/>');
			return false;
		}
	} else if( currentTab == 'ipTab' ) {
		var ipVer = $('input:radio[name="ipVer"]:checked').val();
		if( !$('#userIpAll').is(':checked') ) {
			if( $('#userSIp').val() == '' || $('#userEIp').val() == '' ) {
				alert('<s:message code="filterInfo.msg.enter.userip"/>');
				return false;
			}
			if( ( ipv6Check.ver( $('#userSIp').val() ) != ipv6Check.ver( $('#userEIp').val() ) ) || ipVer != ipv6Check.ver( $('#userSIp').val() ) || ipVer != ipv6Check.ver( $('#userEIp').val() ) ) {
				ui.alertMsg( '<s:message code="deviceInfo.msg.ip.wrong"/>');
				$('#userSIp').focus();
				return false;
			}
			if( !checkIP( $('#userSIp').val() ) || !checkIP( $('#userEIp').val() ) ) {
				ui.alertMsg( '<s:message code="deviceInfo.msg.ip.wrong"/>');
				$('#userSIp').focus();
				return false;
			}
			if( !checkIpRange( $('#userSIp').val(), $('#userEIp').val() ) ) {
				$($('#userSIp')).message('<s:message code="didBlock.msg.cannot.startend"/>');
				return false;
			}
		}
		if( !$('#userPortAll').is(':checked') ) {
			if( $('#userSPort').val() == '' || $('#userEPort').val() == '' ) {
				alert('<s:message code="filterInfo.msg.enter.userport"/>');
				return false;
			}
			if( ($('#userSPort').val() < 1 || $('#userSPort').val() > 65535) || !$('#userSPort').val().isNumber() ) {
				ui.alertMsg( '<s:message code="filterInfo.msg.wrong.userport"/>');
				$('#userSPort').focus();
				return false;
			}
			if( ($('#userEPort').val() < 1 || $('#userEPort').val() > 65535) || !$('#userEPort').val().isNumber() ) {
				ui.alertMsg( '<s:message code="filterInfo.msg.wrong.userport"/>');
				$('#userEPort').focus();
				return false;
			}
		}
		if( !$('#serverIpAll').is(':checked') ) {
			if( $('#serverSIp').val() == '' || $('#serverEIp').val() == '' ) {
				alert('<s:message code="filterInfo.msg.enter.serverip"/>');
				return false;
			}
			if( ( ipv6Check.ver( $('#serverSIp').val() ) != ipv6Check.ver( $('#serverEIp').val() ) ) || ipVer != ipv6Check.ver( $('#serverSIp').val() ) || ipVer != ipv6Check.ver( $('#serverEIp').val() ) ) {
				ui.alertMsg( '<s:message code="deviceInfo.msg.ip.wrong"/>');
				$('#userSIp').focus();
				return false;
			}
			if( !checkIP( $('#serverSIp').val() ) || !checkIP( $('#serverEIp').val() )) {
				ui.alertMsg( '<s:message code="deviceInfo.msg.ip.wrong"/>');
				$('#userSIp').focus();
				return false;
			}
			if( !checkIpRange( $('#serverSIp').val(), $('#serverEIp').val() ) ) {
				$($('#serverSIp')).message('<s:message code="didBlock.msg.cannot.startend"/>');
				return false;
			}
		}
		if( !$('#serverPortAll').is(':checked') ) {
			if( $('#serverSPort').val() == '' || $('#serverEPort').val() == '' ) {
				alert('<s:message code="filterInfo.msg.enter.serverport"/>');
				return false;
			}
			if( ($('#serverSPort').val() < 1 || $('#serverSPort').val() > 65535) || !$('#serverSPort').val().isNumber() ) {
				ui.alertMsg( '<s:message code="filterInfo.msg.wrong.serverport"/>');
				$('#serverSPort').focus();
				return false;
			}
			if( ($('#serverEPort').val() < 1 || $('#serverEPort').val() > 65535) || !$('#serverEPort').val().isNumber() ) {
				ui.alertMsg( '<s:message code="filterInfo.msg.wrong.serverport"/>');
				$('#serverEPort').focus();
				return false;
			}
		}
		
		
		
	} else if( currentTab == 'domainTab' ) {
		if( $('#domain').val() == '') {
			alert('<s:message code="filterInfo.msg.enter.domain"/>');
			return false;
		}
		if($('#domainServiceCd').val() ==''){
			alert('<s:message code="filterInfo.msg.select.service"/>');
			return false;
		}
	} else if( currentTab == 'urlTab' ) {
		if( $('#url').val() == '') {
			alert('<s:message code="filterInfo.msg.enter.url"/>');
			return false;
		}
	} else if( currentTab == 'subjectTab' ) {
		if( $('#subject').val() == '') {
			alert('<s:message code="filterInfo.msg.enter.subject"/>');
			return false;
		}
		if($('#subjectServiceCd').val() ==''){
			alert('<s:message code="filterInfo.msg.select.service"/>');
			return false;
		}
	} else if( currentTab == 'sizeTab' ) {
		if($('#sizeServiceCd').val() ==''){
			alert('<s:message code="filterInfo.msg.select.service"/>');
			return false;
		}
		
		if( $('#lowSize').val() < 1 || $('#lowSize').val() > 1073741824){
			alert('<s:message code="filterInfo.msg.overflow"/>');
			$('#lowSize').focus();
			return;
		}
		
		var sizeCondition = $('#sizeCondition').val();
		if( $('#lowSize').val() == '') {
			alert('<s:message code="filterInfo.msg.enter.size"/>');
			return false;
		}
		if(sizeCondition=='B' && $('#highSize').val() == '' ) {
			alert('<s:message code="filterInfo.msg.enter.size"/>');
			return false;
		}
		if( !$('#lowSize').val().isNumber() ) {
			alert('<s:message code="filterInfo.msg.enter.sizenumber"/>');
			return false;
		}
		if(sizeCondition=='B'){
			if( Number( $('#lowSize').val() ) > Number( $('#highSize').val() ) ) {
				ui.alertMsg('<s:message code="filterInfo.msg.cannot.startend"/>');
				$('.savePopBtn').prop('disabled', false);
				return;
			}
			if( !$('#highSize').val().isNumber() ) {
				alert('<s:message code="filterInfo.msg.enter.sizenumber"/>');
				return false;
			}
			
			if(!chkInteger($('#highSize').val())){
				alert('<s:message code="dashboard.message.input.only_number"/>');
				$('#highSize').focus();
				return;
			}
			if( $('#highSize').val() > 1073741824 ){
				alert('<s:message code="filterInfo.msg.overflow"/>');
				$('#highSize').focus();
				return;
			}
		}
		
		if( !chkInteger($('#lowSize').val()) ){
			alert('<s:message code="dashboard.message.input.only_number"/>');
			$('#lowSize').focus();
			return;
		}
	}
	return true;
}
function saveData(url, popFormId) {
	if(!validationCheck()) {
		$('.savePopBtn').prop('disabled', false);
		return;
	}
	var message = mode=='insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
	ui.confirmMsg(message, '', '', function(rs){
		if(rs){
		    gridObj.on();
			ui.post({
				url : url,
				data : $('#'+popFormId).serializeAll(),
				success : function ( data, total ) {
					ui.alertMsg('<s:message code="common.msg.saved"/>');
					$('#'+popFormId.substring(0,popFormId.length-4)).modal('hide');
					getData ( );
				},
				error : function (status, message) {
					ui.alertMsg(message);
				},
				complete : function (){
					gridObj.off();
					$('.savePopBtn').prop('disabled', false);
				}
			});
		} else {
			$('.savePopBtn').prop('disabled', false);
		}
	});
}

function getTabInfo() {
	var msg = '<s:message code="filterInfo.msg.nologging"/>';
	var ph = '<s:message code="filterInfo.msg.enter.id"/>';
	$('#devStatusBtn').hide();
	
	if( currentTab == 'idTab' ) {
		gridObj = gridId;
		url = 'getIdFilterList.xcn';
		ph = '<s:message code="filterInfo.msg.enter.id"/>';
	} else if( currentTab == 'ipTab' ) {
		$('#serviceType').val('').prop('disabled', true);
		gridObj = gridIp;
		url = 'getIpFilterList.xcn';
		ph = '<s:message code="filterInfo.msg.enter.ip"/>';
		$('#devStatusBtn').show();
	} else if( currentTab == 'domainTab' ) {
		gridObj = gridDomain;
		url = 'getDomainFilterList.xcn';
		ph = '<s:message code="filterInfo.msg.enter.domain"/>';
	} else if( currentTab == 'urlTab' ) {
		$('#serviceType').val('').prop('disabled', true);
		gridObj = gridUrl;
		url = 'getUrlFilterList.xcn';
		ph = '<s:message code="filterInfo.msg.enter.url"/>';
	} else if( currentTab == 'subjectTab' ) {
		gridObj = gridSubject;
		url = 'getSubjectFilterList.xcn';
		ph = '<s:message code="filterInfo.msg.enter.subject"/>';
	} else if( currentTab == 'sizeTab' ) {
		$('#searchStr').val('').prop('disabled', true);
		gridObj = gridSize;
		url = 'getSizeFilterList.xcn';
		ph = '';
		msg = '<s:message code="filterInfo.msg.logging"/>';
	} else if( currentTab == 'attachTab' ) {
		gridObj = gridAttach;
		url = 'getAttachFilterList.xcn';
		ph = '<s:message code="filterInfo.msg.enter.attach"/>';
		msg = '<s:message code="filterInfo.msg.loggingAttach"/>';
	}
	$('#noticeMsg').html( msg );
	$('#searchStr').attr('placeholder',ph);
}

function tabIdToText(currentTab){
	var str = '';
	if( currentTab == 'idTab' ) str = 'ID';
	else if( currentTab == 'ipTab' ) str = 'Ip';
	else if( currentTab == 'domainTab' ) str = 'Domain';
	else if( currentTab == 'urlTab' ) str = 'URL';
	else if( currentTab == 'subjectTab' ) str = '<s:message code="filterInfo.subject"/>';
	else if( currentTab == 'sizeTab' ) str = '<s:message code="filterInfo.size"/>';
	return str;
}

function getData( ) {
	if(searchFlag) return;

	gridObj.on();
	searchFlag=true;
	ui.get({
		url : url,
		searchStr : $("#searchStr").val(),
		serviceCd : $('#serviceType').val(),
		serviceText : $('#serviceType option:selected').text(),
		tab : tabIdToText(currentTab),
		offset : gridObj.data.length,
		limit : gridObj.pageSize,
		success : function(data, total) {
			gridObj.setData(data);
			$('#total_cnt2').html($('#total_cnt').text());
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		    searchFlag=false;
		    gridObj.off();
		}
	});
}

function getserviceType(){
	var result = '';
	ui.get({
		url : 'getServiceList.xcn',
		asyncFlag : false,
		searchStr :'',
		success : function(data, total) {
			result+='<option value="">-<s:message code="filterInfo.servicetype"/>-</option>';
			for(var i=0 ; i<data.length; i++){
				result+='<option value="' + data[i].serviceCd + '">['+ data[i].groupNm + '] ' +  data[i].serviceNm + '</option>';
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {}
	});
	return result;
}

function getIdOptions(){
    var result = '';
	ui.get({
		url : 'getServiceList.xcn',
		asyncFlag : false,
		searchStr :'',
		success : function(data, total) {
			result+='<option value="">-<s:message code="filterInfo.select.service"/>-</option>';
			for(var i=0 ; i<data.length; i++){
				result+='<option value="' + data[i].serviceCd + '">' +  data[i].serviceNm + '</option>';
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
	return result;
}

function getPdeptOptions(){
    var result = '';
	ui.get({
		url : 'getDeptList.xcn',
		asyncFlag : false,
		searchStr :'',
		success : function(data, total) {
			result+='<option value="">-<s:message code="filterInfo.select.pdept"/>-</option>';
			for(var i=0 ; i<data.length; i++){
				result+='<option value="' + data[i].pDeptCd + '">' +  data[i].pDeptNm + '</option>';
			}
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
	return result;
}
</script>
</head>
<body class="mini-navbar">
	<div class="modal fade" id="idPop" tabindex="-1" role="dialog" aria-labelledby="idPop">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="idPopForm" onsubmit="return false;">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="filterInfo.idpop.title"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-inline">
							<label for="userId" class="control-label col-xs-3">ID</label>
							<input type="text" class="form-control" name="userId" id="userId" placeholder="ID" maxlength="30">
							<input type="hidden" id="idLogSeq" name="idLogSeq">
						</div>
						<div class="form-inline">
							<label for="idServiceCd" class="control-label col-xs-3"><s:message code="filterInfo.service"/></label>
							<select class="form-control input-sm" id="idServiceCd" name="serviceCd">
								<option value="">-<s:message code="filterInfo.select.service"/>-</option>
							</select>
							<input type="hidden" name="serviceNm" />
							<input type="hidden" name="tab" />
						</div>
					</div>
					<input type="hidden" name="tabId"/>
				</form>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="savePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="ipPop" tabindex="-1" role="dialog" aria-labelledby="idPop"> 
		<%if( isIPv6){ %>
		<div class="modal-dialog modal-lg" role="document">
		<%} else {%>
		<div class="modal-dialog" role="document">
		<%} %>
			<div class="modal-content">
				<form method="post" id="ipPopForm">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="filterInfo.ippop.title"/></h3>
					</div>
					<div class="modal-body">
						<%if( isIPv6){ %>
						<div class="form-inline">
							<label for="ipVer" class="control-label col-xs-3">IP <s:message code="didBlock.version"/></label>
							<label class="radio-inline c-radio" style="margin-left:-10px;">
								<input type="radio" name="ipVer" value="4" checked>
								<span class="fa fa-check"></span>IPv4
							</label>
							<label class="radio-inline c-radio">
								<input type="radio" name="ipVer" value="6">
								<span class="fa fa-check"></span>IPv6
							</label>
						</div>
						<div class="form-inline">
							<label for="userSIp" class="control-label col-xs-2"><s:message code="filterInfo.userip"/></label>
							<label class="checkbox-inline c-checkbox nologCheck" style="padding-left: 0px;">
								<input type="checkbox" name="userIpAll" id="userIpAll" value="Y">
								<span class="fa fa-check"></span><s:message code="common.msg.all"/>
							</label>
							<input type="text" class="form-control" name="userSIp" id="userSIp" placeholder="<s:message code="filterInfo.sip"/>" style="width: 320px;">
							~
							<input type="text" class="form-control" name="userEIp" id="userEIp" placeholder="<s:message code="filterInfo.eip"/>" style="width: 320px;">
							<p style="padding-left:205px; margin-bottom: 0px;">
								<span style="color:grey;">[example: IPv4 - 192.168.0.12 / IPv6 - 2002:9b3d:1a32:4:208:74ff:fe39:6c43]</span>
							</p>
						</div>
						<div class="form-inline">
							<label for="userSPort" class="control-label col-xs-2"><s:message code="filterInfo.userport"/></label>
							<label class="checkbox-inline c-checkbox nologCheck" style="padding-left: 0px;">
								<input type="checkbox" name="userPortAll" id="userPortAll" value="Y">
								<span class="fa fa-check"></span><s:message code="common.msg.all"/>
							</label>
							<input type="text" class="form-control" name="userSPort" id="userSPort" placeholder="<s:message code="filterInfo.sport"/>" maxlength="5" style="width: 150px">
							&nbsp;~&nbsp;
							<input type="text" class="form-control" name="userEPort" id="userEPort" placeholder="<s:message code="filterInfo.eport"/>" maxlength="5" style="width: 150px">
							<s:message code="filterInfo.portrange"/>
						</div>
						
						<div class="form-inline">
							<label for="serverSIp" class="control-label col-xs-2"><s:message code="filterInfo.serverip"/></label>
							<label class="checkbox-inline c-checkbox nologCheck" style="padding-left: 0px;">
								<input type="checkbox" name="serverIpAll" id="serverIpAll" value="Y">
								<span class="fa fa-check"></span><s:message code="common.msg.all"/>
							</label>
							<input type="text" class="form-control" name="serverSIp" id="serverSIp" placeholder="<s:message code="filterInfo.sip"/>" style="width: 320px;">
							~
							<input type="text" class="form-control" name="serverEIp" id="serverEIp" placeholder="<s:message code="filterInfo.eip"/>" style="width: 320px;">
							<p style="padding-left:205px; margin-bottom: 0px;">
								<span style="color:grey;">[example: IPv4 - 192.168.0.12 / IPv6 - 2002:9b3d:1a32:4:208:74ff:fe39:6c43]</span>
							</p>
							<!-- <input type="hidden" id="domainLogSeq" name="domainLogSeq"> -->
						</div>
						<div class="form-inline">
							<label for="serverSPort" class="control-label col-xs-2"><s:message code="filterInfo.serverport"/></label>
							<label class="checkbox-inline c-checkbox nologCheck" style="padding-left: 0px;">
								<input type="checkbox" name="serverPortAll" id="serverPortAll" value="Y">
								<span class="fa fa-check"></span><s:message code="common.msg.all"/>
							</label>
							<input type="text" class="form-control" name="serverSPort" id="serverSPort" placeholder="<s:message code="filterInfo.sport"/>" maxlength="5" style="width: 150px">
							&nbsp;~&nbsp;
							<input type="text" class="form-control" name="serverEPort" id="serverEPort" placeholder="<s:message code="filterInfo.eport"/>" maxlength="5" style="width: 150px">
							<s:message code="filterInfo.portrange"/>
						</div>
						<div class="form-inline">
							<label for="comment" class="control-label col-xs-3"><s:message code="filterInfo.comment"/></label>
							<input type="text" class="form-control" name="comment" id="comment" placeholder="<s:message code="filterInfo.comment"/>" maxlength="128" style="width: 380px;margin-left: -12px;">
							<input type="hidden" name="ipLogSeq" id="ipLogSeq" />
						</div>
						<div class="form-inline not-dashed" style="padding-top: 20px;">
							<div style="position: relative; top: 15px;">
								<label for="" class="control-label col-xs-2" style=""><s:message code="filterInfo.applydevice"/></label>
								<input type="hidden" name="deviceInfo" id="deviceInfo" />
							</div>
							<div style="text-align: right;">
								<button type="button" class="btn btn-primary selBtn" accesskey="A" id="selDeviceBtn"><s:message code="common.msg.select"/></button>
							</div>
							<div id="deviceGrid" class="slickGrid gridArea" style="position: relative; top: 5px; left: 0px; height:300px;"></div>
						</div>
						<%} else {%>
						<div class="form-inline" style="display:none;">
							<label for="ipVer" class="control-label col-xs-3">IP <s:message code="didBlock.version"/></label>
							<label class="radio-inline c-radio" style="margin-left:-10px;">
								<input type="radio" name="ipVer" value="4" checked>
								<span class="fa fa-check"></span>IPv4
							</label>
							<label class="radio-inline c-radio">
								<input type="radio" name="ipVer" value="6">
								<span class="fa fa-check"></span>IPv6
							</label>
						</div>
						<div class="form-inline">
							<label for="userSIp" class="control-label col-xs-3"><s:message code="filterInfo.userip"/></label>
							<label class="checkbox-inline c-checkbox nologCheck" style="padding-left: 0px;">
								<input type="checkbox" name="userIpAll" id="userIpAll" value="Y">
								<span class="fa fa-check"></span><s:message code="common.msg.all"/>
							</label>
							<input type="text" class="form-control" name="userSIp" id="userSIp" placeholder="<s:message code="filterInfo.sip"/>" style="width: 150px;">
							~
							<input type="text" class="form-control" name="userEIp" id="userEIp" placeholder="<s:message code="filterInfo.eip"/>" style="width: 150px;">
						</div>
						<div class="form-inline">
							<label for="userSPort" class="control-label col-xs-3"><s:message code="filterInfo.userport"/></label>
							<label class="checkbox-inline c-checkbox nologCheck" style="padding-left: 0px;">
								<input type="checkbox" name="userPortAll" id="userPortAll" value="Y">
								<span class="fa fa-check"></span><s:message code="common.msg.all"/>
							</label>
							<input type="text" class="form-control" name="userSPort" id="userSPort" placeholder="<s:message code="filterInfo.sport"/>" maxlength="5" style="width: 100px">
							~
							<input type="text" class="form-control" name="userEPort" id="userEPort" placeholder="<s:message code="filterInfo.eport"/>" maxlength="5" style="width: 100px">
							<s:message code="filterInfo.portrange"/>
						</div>
						
						<div class="form-inline">
							<label for="serverSIp" class="control-label col-xs-3"><s:message code="filterInfo.serverip"/></label>
							<label class="checkbox-inline c-checkbox nologCheck" style="padding-left: 0px;">
								<input type="checkbox" name="serverIpAll" id="serverIpAll" value="Y">
								<span class="fa fa-check"></span><s:message code="common.msg.all"/>
							</label>
							<input type="text" class="form-control" name="serverSIp" id="serverSIp" placeholder="<s:message code="filterInfo.sip"/>" style="width: 150px;">
							~
							<input type="text" class="form-control" name="serverEIp" id="serverEIp" placeholder="<s:message code="filterInfo.eip"/>" style="width: 150px;">
							<!-- <input type="hidden" id="domainLogSeq" name="domainLogSeq"> -->
						</div>
						<div class="form-inline">
							<label for="serverSPort" class="control-label col-xs-3"><s:message code="filterInfo.serverport"/></label>
							<label class="checkbox-inline c-checkbox nologCheck" style="padding-left: 0px;">
								<input type="checkbox" name="serverPortAll" id="serverPortAll" value="Y">
								<span class="fa fa-check"></span><s:message code="common.msg.all"/>
							</label>
							<input type="text" class="form-control" name="serverSPort" id="serverSPort" placeholder="<s:message code="filterInfo.sport"/>" maxlength="5" style="width: 100px">
							~
							<input type="text" class="form-control" name="serverEPort" id="serverEPort" placeholder="<s:message code="filterInfo.eport"/>" maxlength="5" style="width: 100px">
							<s:message code="filterInfo.portrange"/>
						</div>
						<div class="form-inline">
							<label for="comment" class="control-label col-xs-3"><s:message code="filterInfo.comment"/></label>
							<input type="text" class="form-control" name="comment" id="comment" placeholder="<s:message code="filterInfo.comment"/>" maxlength="128" style="width: 380px">
							<input type="hidden" name="ipLogSeq" id="ipLogSeq" />
						</div>
						<div class="form-inline not-dashed" style="padding-top: 20px;">
							<div style="position: relative; top: 15px;">
								<label for="" class="control-label col-xs-3" style=""><s:message code="filterInfo.applydevice"/></label>
								<input type="hidden" name="deviceInfo" id="deviceInfo" />
							</div>
							<div style="text-align: right;">
								<button type="button" class="btn btn-primary selBtn" accesskey="A" id="selDeviceBtn"><s:message code="common.msg.select"/></button>
							</div>
							<div id="deviceGrid" class="slickGrid gridArea" style="position: relative; top: 5px; left: 0px; height:300px;"></div>
						</div>
						<%} %>
					</div>
					<input type="hidden" name="tabId"/>
				</form>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="savePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="domainPop" tabindex="-1" role="dialog" aria-labelledby="domainPop">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="domainPopForm" onsubmit="return false;">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="filterInfo.domainpop.title"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-inline">
							<label for="domain" class="control-label col-xs-3">Domain</label>
							<input type="text" class="form-control" name="domain" id="domain" placeholder="Domain" maxlength="128">
							<input type="hidden" id="domainLogSeq" name="domainLogSeq">
						</div>
						<div class="form-inline">
							<label for="domainServiceCd" class="control-label col-xs-3"><s:message code="filterInfo.service"/></label>
							<select class="form-control input-sm" id="domainServiceCd" name="serviceCd">
								<option value="">-<s:message code="filterInfo.select.service"/>-</option>
							</select>
							<input type="hidden" name="serviceNm" />
							<input type="hidden" name="tab" />
						</div>
					</div>
					<input type="hidden" name="tabId"/>
				</form>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="savePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="urlPop" tabindex="-1" role="dialog" aria-labelledby="urlPop">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="urlPopForm" onsubmit="return false;">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="filterInfo.urlPop.title"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-inline">
							<label for="url" class="control-label col-xs-2">URL</label>
							http://<input type="text" class="form-control" name="url" id="url" placeholder="URL" style="width: 350px;" maxlength="128">
							<input type="hidden" id="urlLogSeq" name="urlLogSeq">
						</div>
						<div class="form-inline" style="padding-left: 10px; color: #f25643;"><s:message code="filterInfo.msg.exceptHttp"/></div>
					</div>
					<input type="hidden" name="tabId"/>
					<input type="hidden" name="tab" />
				</form>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="savePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="subjectPop" tabindex="-1" role="dialog" aria-labelledby="subjectPop">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="subjectPopForm" onsubmit="return false;">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="filterInfo.subjectPop.title"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-inline">
							<label for="subject" class="control-label col-xs-3"><s:message code="filterInfo.subject"/></label>
							<input type="text" class="form-control" name="subject" id="subject" placeholder="<s:message code="filterInfo.subject"/>" style="width: 350px;" maxlength="255">
							<input type="hidden" id="subjectLogSeq" name="subjectLogSeq">
						</div>
						<div class="form-inline">
							<label for="domainServiceCd" class="control-label col-xs-3"><s:message code="filterInfo.service"/></label>
							<select class="form-control input-sm" id="subjectServiceCd" name="serviceCd">
								<option value="">-<s:message code="filterInfo.select.service"/>-</option>
							</select>
							<input type="hidden" name="serviceNm" />
							<input type="hidden" name="tab" />
						</div>
						<div class="form-inline exam">1) <s:message code="filterInfo.exam.text1"/></div>
						<div class="form-inline exam">2) <s:message code="filterInfo.exam.text2"/></div>
						<div class="form-inline exam">3) <s:message code="filterInfo.exam.text3"/></div>
						<div class="form-inline exam">4) <s:message code="filterInfo.exam.text4"/></div>
						<div class="form-inline exam">5) <s:message code="filterInfo.exam.text5"/></div>
						<div class="form-inline exam">6) <s:message code="filterInfo.exam.text6"/></div>
					</div>
					<input type="hidden" name="tabId"/>
				</form>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="savePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="sizePop" tabindex="-1" role="dialog" aria-labelledby="sizePop">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="sizePopForm" onsubmit="return false;">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="filterInfo.sizePop.title"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-inline">
							<input type="hidden" id="sizeLogSeq" name="sizeLogSeq">
							<label for="sizeServiceCd" class="control-label col-xs-3"><s:message code="filterInfo.service"/></label>
							<select class="form-control input-sm" id="sizeServiceCd" name="serviceCd">
								<option value="">-<s:message code="filterInfo.select.service"/>-</option>
							</select>
							<input type="hidden" name="serviceNm" />
							<input type="hidden" name="tab" />
						</div>
						<div class="form-inline">
							<label for="lowSize" class="control-label col-xs-3"><s:message code="filterInfo.msgSize"/></label>
							<input type="text" class="form-control" name="lowSize" id="lowSize" style="width: 120px;" pattern="[0-9]+([\,])?" step="1" min="1" max="1073741824">
							<select class="form-control input-sm" id="sizeCondition" name="sizeCondition">
								<option value="B"><s:message code="filterInfo.range"/></option>
								<option value="L"><s:message code="filterInfo.rangeL"/></option>
								<option value="S"><s:message code="filterInfo.rangeS"/></option>
							</select>
							<input type="text" class="form-control" name="highSize" id="highSize" style="width: 120px;">
						</div>
						<div class="form-inline" style="padding-left: 10px; color: #f25643;">※ <s:message code="filterInfo.unit"/>: Byte</div>
						<div class="form-inline" style="padding-left: 10px; color: #f25643;">※ <s:message code="filterInfo.range"/> : 1 ~ 1,073,741,824 Byte(1,024 MB)</div>
					</div>
					<input type="hidden" name="tabId"/>
				</form>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="savePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="attachPop" tabindex="-1" role="dialog" aria-labelledby="attachPop">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<form method="post" id="attachPopForm" onsubmit="return false;">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h3 class="modal-title"><s:message code="filterInfo.attachPop.title"/></h3>
					</div>
					<div class="modal-body">
						<div class="form-inline">
							<label for="attach" class="control-label col-xs-3"><s:message code="filterInfo.attach"/></label>
							<input type="text" class="form-control" name="attach" id="attach" disabled="disabled" placeholder="<s:message code="filterInfo.attach"/>" style="width: 350px;" maxlength="255">
							<input type="hidden" id="attachLogSeq" name="attachLogSeq">
							<button type="button" class="btn btn-primary" accesskey="C" data-dismiss="modal"><s:message code="common.msg.select"/></button>
						</div>
						<div class="form-inline">
							<label for="attach" class="control-label col-xs-3"><s:message code="didBlock.code.input"/></label>
							<input type="text" class="form-control" name="attach" id="attach" placeholder="<s:message code="filterInfo.attach"/> <s:message code="filterInfo.msg.separate.comma"/> style="width: 350px;" maxlength="255">
							<input type="hidden" id="attachLogSeq" name="attachLogSeq">
						</div>
						<div class="form-inline">
							<label for="attachServiceCd" class="control-label col-xs-3"><s:message code="filterInfo.service"/></label>
							<select class="form-control input-sm" id="attachServiceCd" name="serviceCd">
								<option value="">-<s:message code="filterInfo.select.service"/>-</option>
							</select>
							<input type="hidden" name="serviceNm" />
							<input type="hidden" name="tab" />
						</div>
					</div>
					<input type="hidden" name="tabId"/>
				</form>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="savePopBtn"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</div>
	</div>
	
	<jsp:include page="../../top.jsp"/>

	<div class="container"> 
		<div class="boxArea">
			<div class="content_body">
				<div class="row">
					<div class="col-xs-12"> 
						<ul class="nav nav-tabs codeTab">
							<li class="active" style=" text-align: center;"><a data-toggle="tab" href="#idList" id="idTab">ID</a></li>
							<li style=" text-align: center"><a data-toggle="tab" href="#ipList" 				id="ipTab"	>IP</a></li>
							<li style=" text-align: center"><a data-toggle="tab" href="#domainList" 			id="domainTab"	>Domain</a></li>
							<li style=" text-align: center"><a data-toggle="tab" href="#urlList"		 		id="urlTab">URL</a></li>
							<li style=" text-align: center"><a data-toggle="tab" href="#subjectList" 			id="subjectTab"><s:message code="filterInfo.subject"/></a></li>
							<li style=" text-align: center"><a data-toggle="tab" href="#sizeList" 				id="sizeTab"><s:message code="filterInfo.size"/></a></li>
							<li style=" text-align: center; display: none;"><a data-toggle="tab" href="#attachList" 			id="attachTab"><s:message code="filterInfo.attach"/></a></li>
						</ul>
					</div>
				</div>
				<div class="row top_space">
					<span style="color: #f25643; font-weight: bold;padding-left:10px;" id="noticeMsg"><s:message code="filterInfo.msg.nologging"/></span>
				</div>
				<div class="row top_space">
					<div class="col-xs-12 text-left">
						<div class="form-group form-inline not-dashed">
							<div class="form-group">
								<select class="form-control input-sm" id="serviceType" name="serviceType" style="min-width: 150px;">
									<option value="">-<s:message code="filterInfo.msg.select.service"/>-</option>
								</select>
							</div>
							<div class="input-group">
		      					<input type="text" class="form-control input-sm" id="searchStr" style="width: 210px;">
								<div class="input-group-btn">
									<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
								</div>
							</div>
	  						<button type="button" class="btn btn-sm btn-primary" accesskey="I" id="insertBtn"><span class="glyphicon glyphicon-plus"></span>&nbsp;<s:message code="common.msg.add"/></button>
							<button type="button" class="btn btn-sm btn-default" accesskey="D" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span>&nbsp;<s:message code="common.msg.delete"/></button>
							<button type="button" class="btn btn-sm btn-danger" accesskey="R" id="devStatusBtn" style="display: none;"><span class="glyphicon glyphicon-flash"></span>&nbsp;<s:message code="filterInfo.ruleapply"/></button>
						</div>
					</div>
 					<%-- <div class="col-xs-2 text-right">
 						<div class="btn-group">
							<button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown">
								<span class="glyphicon glyphicon-download-alt"></span>&nbsp;<s:message code="common.msg.export"/> <span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-right" role="menu">
								<li><a href="#" class="excel_link2"><span class="fa fa-file-excel-o"></span>&nbsp;<s:message code="common.msg.excel"/>(xlsx)</a></li>
								<li><a href="#" class="cell_link2"><span class="fa fa-file-excel-o"></span>&nbsp;<s:message code="common.msg.hancel"/>(cell)</a></li>
								<li><a href="#" class="csv_link2"><span class="fa fa-file-text"></span>&nbsp;<s:message code="common.msg.text"/>(csv)</a></li>
								<li><a href="#" class="pdf_link2"><span class="fa fa-file-pdf-o"></span>&nbsp;PDF</a></li>
								<li><a href="#" class="print_link2"><span class="glyphicon glyphicon-print"></span>&nbsp;<s:message code="common.msg.print"/></a></li>
							</ul>
						</div>
					</div> --%>
				</div>
				<div class="tab-content codeContent xcn_full top_space">
					<div id="idList" class="tab-pane fade in active" style="height:100%;">
						<div id="idListGrid" class="slickGrid gridArea"></div>
					</div>
					<div id="ipList" class="tab-pane fade" style="height:100%;">
						<div id="ipListGrid" class="slickGrid gridArea"></div>
					</div>
					<div id="domainList" class="tab-pane fade" style="height:100%;">
						<div id="domainListGrid" class="slickGrid gridArea"></div>
					</div>
					<div id="urlList" class="tab-pane fade" style="height:100%;">
						<div id="urlListGrid" class="slickGrid gridArea"></div>
					</div>
					<div id="subjectList" class="tab-pane fade" style="height:100%;">
						<div id="subjectListGrid" class="slickGrid gridArea"></div>
					</div>
					<div id="sizeList" class="tab-pane fade" style="height:100%;">
						<div id="sizeListGrid" class="slickGrid gridArea"></div>
					</div>
					<div id="attachList" class="tab-pane fade" style="height:100%;">
						<div id="attachListGrid" class="slickGrid gridArea"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
		var gridId = new Xgrid('idListGrid', contextRoot);
		gridId.onCheckBox();
		gridId.autoNumber();
		gridId.colAdd('userId', 'ID',150, 'left', false, 'link');
		gridId.colAdd('groupNm', '<s:message code="filterInfo.serviceSeparate"/>', 150, 'center', false, 'nomal');
		gridId.colAdd('serviceNm', '<s:message code="filterInfo.service"/>', 150, 'center', false, 'nomal');
		gridId.colAdd('serviceCd', '<s:message code="filterInfo.serviceCode"/>', 100, 'center', false, 'nomal');
		gridId.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 180, 'center', false, 'nomal');
		gridId.loadExportMenu('<s:message code="POLICY_SETUP.POLICY_NOLOG"/>-ID');
		gridId.onClick = function() {
			if (gridId.Col == gridId.ColIndex('userId')) {
				$('.savePopBtn').prop('disabled', false);
				mode = 'modify';
				$("#idPop").modal('show');
				$('#userId').val(gridId.getValue(gridId.Row, 'userId'));
				$('#idServiceCd').val(gridId.getValue(gridId.Row, 'serviceCd'));
				$('#idLogSeq').val(gridId.getValue(gridId.Row, 'idLogSeq'));
			}
		}; 
		gridId.loadHeader(true);
		gridId.initData('<s:message code="common.msg.search.click"/>');
		
		var gridIp = new Xgrid('ipListGrid', contextRoot);
		gridIp.onCheckBox();
		gridIp.autoNumber();
		gridIp.colAdd('userIpDesc', '<s:message code="filterInfo.userip"/>', 170, 'center', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
			if( value == 'All' ) return '<s:message code="common.msg.all"/>';
			else return value;
		});
		gridIp.colAdd('userPortDesc', '<s:message code="filterInfo.userport"/>', 100, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
			if( value == 'All' ) return '<s:message code="common.msg.all"/>';
			else return value;
		});
		gridIp.colAdd('serverIpDesc', '<s:message code="filterInfo.serverip"/>', 170, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
			if( value == 'All' ) return '<s:message code="common.msg.all"/>';
			else return value;
		});
		gridIp.colAdd('serverPortDesc', '<s:message code="filterInfo.serverport"/>', 100, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
			if( value == 'All' ) return '<s:message code="common.msg.all"/>';
			else return value;
		});
		gridIp.colAdd('deviceNm', '<s:message code="filterInfo.applydevice"/>', 150, 'center', false, 'nomal');
		gridIp.colAdd('comment', '<s:message code="filterInfo.comment"/>', 150, 'center', false, 'nomal');
		gridIp.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 150, 'center', false, 'nomal');
		gridIp.loadExportMenu('<s:message code="POLICY_SETUP.POLICY_NOLOG"/>-IP');
		gridIp.onClick = function() {
			if (gridIp.Col == gridIp.ColIndex('userIpDesc')) {
				
				mode = 'modify';
				$("#ipPop").modal('show');
				$('#userIpAll, #userPortAll, #serverIpAll, #serverPortAll').prop('checked', false);
				$('#userSIp, #userEIp, #userSPort, #userEPort, #serverSIp, #serverEIp, #serverSPort, #serverEPort').val('').prop('disabled',false);
				$('#ipLogSeq').val('');
				
				var data = gridIp.getRowData( gridIp.Row );
				
				$('#ipLogSeq').val( data.ipLogSeq );
				$('input:radio[name=ipVer]:input[value='+ipv6Check.ver(data.userSIp)+']').prop("checked", true);
				
				if( data.userIpDesc == 'All' ) {
					$('#userIpAll').prop('checked', true);
					$('#userSIp, #userEIp').prop('disabled', true);
				} else {
					$('#userSIp').val( $.trim( data.userIpDesc.split('~')[0] ) );
					$('#userEIp').val( $.trim( data.userIpDesc.split('~')[1] ) );
				}
				
				if( data.userPortDesc == 'All' ) {
					$('#userPortAll').prop('checked', true);
					$('#userSPort, #userEPort').prop('disabled', true);
				} else {
					$('#userSPort').val( $.trim( data.userPortDesc.split('~')[0] ) );
					$('#userEPort').val( $.trim( data.userPortDesc.split('~')[1] ) );
				}
				
				if( data.serverIpDesc == 'All' ) {
					$('#serverIpAll').prop('checked', true);
					$('#serverSIp, #serverEIp').prop('disabled', true);
				} else {
					$('#serverSIp').val( $.trim( data.serverIpDesc.split('~')[0] ) );
					$('#serverEIp').val( $.trim( data.serverIpDesc.split('~')[1] ) );
				}
				
				if( data.serverPortDesc == 'All' ) {
					$('#serverPortAll').prop('checked', true);
					$('#serverSPort, #serverEPort').prop('disabled', true);
				} else {
					$('#serverSPort').val( $.trim( data.serverPortDesc.split('~')[0] ) );
					$('#serverEPort').val( $.trim( data.serverPortDesc.split('~')[1] ) );
				}
				
				$('#comment').val( data.comment );
				
				deviceGrid.on();
				ui.get({
					url 		: 'getSelectDeviceList.xcn',
					deviceSeq	: data.deviceSeq,
					success 	: function(data, total) {
						deviceGrid.setData(data);
					},
					error 		: function(status, message) {
						ui.alertMsg(message);
					},
					complete 	: function() {
					    deviceGrid.off();
					}
				});
			}
		}; 
		gridIp.loadHeader(true);
		gridIp.initData('<s:message code="common.msg.search.click"/>');
		
		
		var gridDomain = new Xgrid('domainListGrid', contextRoot);
		gridDomain.onCheckBox();
		gridDomain.autoNumber();
		gridDomain.colAdd('domain', 'Domain', 150, 'left', false, 'link');
		gridDomain.colAdd('groupNm', '<s:message code="filterInfo.serviceSeparate"/>', 150, 'center', false, 'nomal');
		gridDomain.colAdd('serviceNm', '<s:message code="filterInfo.service"/>', 150, 'center', false, 'nomal');
		gridDomain.colAdd('serviceCd', '<s:message code="filterInfo.serviceCode"/>', 100, 'center', false, 'nomal');
		gridDomain.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 180, 'center', false, 'nomal');
		gridDomain.loadExportMenu('<s:message code="POLICY_SETUP.POLICY_NOLOG"/>-Domain');
		gridDomain.onClick = function() {
			if (gridDomain.Col == gridDomain.ColIndex('domain')) {
				$('.savePopBtn').prop('disabled', false);
				mode = 'modify';
				$("#domainPop").modal('show');
				$('#domain').val(gridDomain.getValue(gridDomain.Row, 'domain'));
				$('#domainServiceCd').val(gridDomain.getValue(gridDomain.Row, 'serviceCd'));
				$('#domainLogSeq').val(gridDomain.getValue(gridDomain.Row, 'domainLogSeq'));
			}
		}; 
		gridDomain.loadHeader(true);
		gridDomain.initData('<s:message code="common.msg.search.click"/>');
		
		
		var gridUrl = new Xgrid('urlListGrid', contextRoot);
		gridUrl.onCheckBox();
		gridUrl.autoNumber();
		gridUrl.colAdd('url', 'URL', 300, 'left', false, 'link');
		gridUrl.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 180, 'center', false, 'nomal');
		gridUrl.loadExportMenu('<s:message code="POLICY_SETUP.POLICY_NOLOG"/>-URL');
		gridUrl.onClick = function() {
			if (gridUrl.Col == gridUrl.ColIndex('url')) {
				$('.savePopBtn').prop('disabled', false);
				mode = 'modify';
				$("#urlPop").modal('show');
				$('#noLogurl').val(gridUrl.getValue(gridUrl.Row, 'url'));
				$('#urlLogSeq').val(gridUrl.getValue(gridUrl.Row, 'urlLogSeq'));
			}
		}; 
		gridUrl.loadHeader(true);
		gridUrl.initData('<s:message code="filterInfo.createDt"/>');
		
		
		var gridSubject = new Xgrid('subjectListGrid', contextRoot);
		gridSubject.onCheckBox();
		gridSubject.autoNumber();
		gridSubject.colAdd('subject', '<s:message code="filterInfo.subject"/>', 150, 'left', false, 'link');
		gridSubject.colAdd('groupNm', '<s:message code="filterInfo.serviceSeparate"/>', 150, 'center', false, 'nomal');
		gridSubject.colAdd('serviceNm', '<s:message code="filterInfo.service"/>', 150, 'center', false, 'nomal');
		gridSubject.colAdd('serviceCd', '<s:message code="filterInfo.serviceCode"/>', 100, 'center', false, 'nomal');
		gridSubject.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 180, 'center', false, 'nomal');
		gridSubject.loadExportMenu('<s:message code="POLICY_SETUP.POLICY_NOLOG"/>-<s:message code="filterInfo.subject"/>');
		gridSubject.onClick = function() {
			if (gridSubject.Col == gridSubject.ColIndex('subject')) {
				$('.savePopBtn').prop('disabled', false);
				mode = 'modify';
				$("#subjectPop").modal('show');
				$('#subject').val(gridSubject.getValue(gridSubject.Row, 'subject'));
				$('#subjectServiceCd').val(gridSubject.getValue(gridSubject.Row, 'serviceCd'));
				$('#subjectLogSeq').val(gridSubject.getValue(gridSubject.Row, 'subjectLogSeq'));
			}
		}; 
		gridSubject.loadHeader(true);
		gridSubject.initData('<s:message code="filterInfo.createDt"/>');
		
		
		var gridSize = new Xgrid('sizeListGrid', contextRoot);
		gridSize.onCheckBox();
		gridSize.autoNumber();
		gridSize.colAdd('groupNm', '<s:message code="filterInfo.serviceSeparate"/>', 150, 'center', false, 'nomal');
		gridSize.colAdd('serviceNm', '<s:message code="filterInfo.service"/>', 150, 'center', false, 'link');
		gridSize.colAdd('serviceCd', '<s:message code="filterInfo.serviceCode"/>', 100, 'center', false, 'nomal');
		gridSize.colAdd('size', '<s:message code="filterInfo.msgSize"/>(<s:message code="filterInfo.unit"/> Byte)', 320, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
			var sizeCondition = gridSize.getValue(row, 'sizeCondition');
			var lowSize = gridSize.getValue(row, 'lowSize').comma();
			var highSize = gridSize.getValue(row, 'highSize').comma();
			if(sizeCondition=='B') return lowSize + ' Byte ~ ' + highSize + 'Byte';
			else if(sizeCondition=='L') return lowSize + ' Byte <s:message code="filterInfo.rangeL"/>';
			else if(sizeCondition=='S') return lowSize + ' Byte <s:message code="filterInfo.rangeS"/>';
			else return '-';
		});
		gridSize.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 180, 'center', false, 'nomal');
		gridSize.loadExportMenu('<s:message code="POLICY_SETUP.POLICY_NOLOG"/>-<s:message code="filterInfo.size"/>');
		gridSize.onClick = function() {
			if (gridSize.Col == gridSize.ColIndex('serviceNm')) {
				$('#sizeServiceCd').prop('disabled', true);
				$('.savePopBtn').prop('disabled', false);
				mode = 'modify';
				$("#sizePop").modal('show');
				$('#lowSize').val(gridSize.getValue(gridSize.Row, 'lowSize'));
				$('#highSize').val(gridSize.getValue(gridSize.Row, 'highSize'));
				$('#sizeCondition').val(gridSize.getValue(gridSize.Row, 'sizeCondition'));
				$('#sizeServiceCd').val(gridSize.getValue(gridSize.Row, 'serviceCd'));
				$('#sizeLogSeq').val(gridSize.getValue(gridSize.Row, 'sizeLogSeq'));
			}
		}; 
		gridSize.loadHeader(true);
		gridSize.initData('<s:message code="filterInfo.createDt"/>');

		
		var gridAttach = new Xgrid('attachListGrid', contextRoot);
		gridAttach.onCheckBox();
		gridAttach.autoNumber();
		gridAttach.colAdd('attach', '<s:message code="filterInfo.attach"/>', 350, 'left', false, 'link');
		gridAttach.colAdd('groupNm', '<s:message code="filterInfo.serviceSeparate"/>', 150, 'center', false, 'nomal');
		gridAttach.colAdd('serviceNm', '<s:message code="filterInfo.service"/>', 150, 'center', false, 'nomal');
		gridAttach.colAdd('serviceCd', '<s:message code="filterInfo.serviceCode"/>', 100, 'center', false, 'nomal');
		gridAttach.colAdd('createDt', '<s:message code="filterInfo.createDt"/>', 180, 'center', false, 'nomal');
		gridAttach.loadExportMenu('<s:message code="POLICY_SETUP.POLICY_NOLOG"/>-<s:message code="filterInfo.subject"/>');
		gridAttach.onClick = function() {
			if (gridAttach.Col == gridAttach.ColIndex('attach')) {
				$('.savePopBtn').prop('disabled', false);
				mode = 'modify';
				$("#subjectPop").modal('show');
				$('#subject').val(gridSubject.getValue(gridSubject.Row, 'subject'));
				$('#subjectServiceCd').val(gridSubject.getValue(gridSubject.Row, 'serviceCd'));
				$('#subjectLogSeq').val(gridSubject.getValue(gridSubject.Row, 'subjectLogSeq'));
			}
		}; 
		gridAttach.loadHeader(true);
		gridAttach.initData('<s:message code="filterInfo.createDt"/>');

		
		var deviceGrid = new Xgrid('deviceGrid', contextRoot);
		deviceGrid.autoNumber();
		deviceGrid.colAdd('code', '<s:message code="filterInfo.dev.ip"/>',170, 'left', false, 'nomal');
		deviceGrid.colAdd('codeName', '<s:message code="filterInfo.dev.name"/>',300, 'left', false, 'nomal');
		deviceGrid.onClick = function() {
			if (deviceGrid.Col == deviceGrid.ColIndex('code')) {
				
			}
		}; 
		deviceGrid.loadHeader(true);
		deviceGrid.initData('<s:message code="common.msg.nodata"/>');
	</script>

	<jsp:include page="../../footer.jsp"/>
</body>
</html>