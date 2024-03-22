<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<%
	String deviceSeq = Common.nvl(request.getParameter("deviceSeq"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title><s:message code="deviceInfo.title"/></title>
	<link rel="stylesheet" href="<c:url value="/css/slider.css"/>" />
	<link rel="stylesheet" href="<c:url value="/css/jquery.circliful.css"/>">
	<link rel="stylesheet" href="<c:url value="/css/bootstrap-select.min.css"/>"/>
	<link rel="stylesheet" href="<c:url value="/css/sb-admin-2.css"/>" />

	<script type="text/javascript" src="<c:url value="/js/bootstrap-slider.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/jquery.circliful.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/bootstrap-select.js"/>"></script>

	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->

	<style type="text/css">
		body {
			font-family: Helvetica Neue, Helvetica, Arial, sans-serif;
		}
		.progress {
			padding-left: 0px;
		}
		.progress-bar {
			text-align: left;
			padding-left: 10px;
		}
		.glyphicon-hdd {
			font-size: 20px;
		}
		.fsImg {
			width: 30px;
		}
		#alarmCri .slider-selection {
			background: #5cb85c;
		}
		#saturationCri .slider-selection{
			background: #f0ad4e;
		}
		#deleteCri .slider-selection {
			background: #729fcf;
		}
		#alarmLv1Text, #saturationLv1Text, #alarmLvText {
			font-weight: bold;
			font-size: 14px;
		}
		table th {
			background-color: #eee;
			text-align: center;
		}
		.memoryTbl td {
			text-align: center;
		}
		.process_normal {
		}

		.process_none {
			color: #FD9C44;
			font-weight: bold;
		}
		.process_warn {
			color: #BE7533;
			font-weight: bold;
		}
		.interface_warn {
			color: #BE7533;
			font-weight: bold;
		}
		.c-checkbox input[type=checkbox]:checked + span {
			background-color: #be7533;
		}
		.bootstrap-select .btn{
			padding:4px 12px;
		}
		.dropdown-menu > li > a:focus, .dropdown-menu > li > a:hover{
			background-color: rgba(51, 122, 183, 1);
			color: white;
		}
		.huge{
			margin-top: 10px;
		}
	</style>
	<script type="text/javascript">
        var param_deviceSeq = '<%=deviceSeq%>';
        $(document).ready(function(){

            $(document).on('click', '.nav-tabs a', function(){
                getDeviceInfo( );
            });

            $('#deviceSelect').selectpicker({
                container:'body',
                width:'300px',
                size: 10,
                noneSelectedText:'<s:message code="common.msg.all"/>'
            }).change(function(){
                getDeviceInfo( );
            });

            //장비 추가
            $('#insertBtn').click(function(){
                $('#deviceAddPop').attr('mode', 'insert');
                $('#deviceAddPop').modal('show');
                $('#deviceIp, #deviceNm, #comment, #sshId, #sshPw').val('');
                $('#sshId, #sshPw').prop('disabled', false);
                $('input:radio[name=deviceType]:input[value=C]').prop("checked", true);
                $('#deviceSshIdDiv, #deviceSshPwDiv').show();
                $('input:radio[name=deviceType]').prop("disabled", false);
            });

            $('.savePopBtn').click(function(){
                if( !checkIP( $('#deviceIp').val() ) ) {
                    ui.alertMsg( '<s:message code="deviceInfo.msg.ip.wrong"/>');
                    $('#accessIp').focus();
                    return;
                }
                if( $('#deviceIp').val() == '' ) {
                    ui.alertMsg('<s:message code="deviceInfo.msg.enter.ip"/>');
                    $('#accessIp').focus();
                    return;
                }
                /* if( $('input:radio[name=deviceType]:checked').val() == 'A' || $('input:radio[name=deviceType]:checked').val() == 'C' ) {
					if( $('#sshId').val() == '' ) {
						ui.alertMsg('<s:message code="deviceInfo.msg.enter.devid"/>');
				$('#sshId').focus();
				return;
			}
			if( $('#sshPw').val() == '' ) {
				ui.alertMsg('<s:message code="deviceInfo.msg.enter.devpw"/>');
				$('#sshPw').focus();
				return;
			}
		} */
                if( $('#deviceNm').val() == '' ) {
                    ui.alertMsg('<s:message code="deviceInfo.msg.enter.devname"/>');
                    $('#deviceNm').focus();
                    return;
                }
                var id = $('#deviceAddPop').attr('mode');
                if( id == 'insert' ) insertDevice();
                else if( id == 'modify' ) modifyDevice();
            });

            getDevice();
        });

        function getDevice(){
            ui.get({
                url : 'getDeviceList.xcn',
                success : function(data, total) {
                    makeDeviceTab( data.devices );
                    window.setTimeout(function(){
                        //getDevice();
                    }, 5000);
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
        }

        function getStatusMsg(status){
            if( status == 'S') return '<s:message code="deviceInfo.normal"/>';
            else if( status == 'I') return '<s:message code="deviceInfo.interest"/>';
            else if( status == 'W') return '<s:message code="deviceInfo.caution"/>';
            else if( status == 'E') return '<s:message code="deviceInfo.danger"/>';
            else if( status == 'X') return '<s:message code="deviceInfo.critical"/>';
            else if( status == 'C') return '<s:message code="deviceInfo.disconnect"/>';
            return '-';
        }

        //장비 탭 생성
        function makeDeviceTab( data ){
            var str = '';
            for (var i = 0; i < data.length; i++) {
                str += '<div class="col-md-3">';
                if( data[i].deviceStatus == 'S' ) {
                    str += '	<div class="panel panel-green device_status" id="device.status' + (i+1) + '">';
                } else if( data[i].deviceStatus == 'I' || data[i].deviceStatus == 'W' ) {
                    str += '	<div class="panel panel-yellow device_status" id="device.status' + (i+1) + '">';
                } else if( data[i].deviceStatus == 'E' || data[i].deviceStatus == 'X' ) {
                    str += '	<div class="panel panel-red device_status" id="device.status' + (i+1) + '">';
                } else {
                    str += '	<div class="panel panel-gray device_status" id="device.status' + (i+1) + '">';
                }
                str += '		<div class="panel-heading">';
                str += '			<div class="row">';
                str += '				<div class="col-xs-3">';
                if( data[i].deviceType == 'M' ) {
                    str += '					<i class="fa fa-desktop fa-5x"></i>';
                } else if( data[i].deviceType == 'A' ) {
                    str += '					<i class="fa fa-tasks fa-5x"></i>';
                } else if( data[i].deviceType == 'C' ) {
                    str += '					<i class="fa fa-database fa-5x"></i>';
                } else if( data[i].deviceType == 'L' ) {
                    str += '					<i class="fa fa-ioxhost fa-5x"></i>';
                } else {
                    str += '					<i class="fa fa-header fa-5x"></i>';
                }

                str += '					<span style="position: absolute; top: 40px; left: 82px;"></span>';
                str += '				</div>';
                str += '				<div class="col-xs-9 text-right">';
                str += '					<div class="huge" style="font-weight: bold;" id="deviceStatus' + (i+1) + '">'+getStatusMsg(data[i].deviceStatus)+'</div>';
                str += '					<div id="deviceStatus' + (i+1) + 'Time">'+ (data[i].comment == null || data[i].comment=='' ? '<s:message code="deviceInfo.noComment"/>' : data[i].comment ) +'</div>';

	            if( data[i].deviceType == 'A' ) {
                    str += '				<div>[ <s:message code="selectDevStatus.dev.integrated"/> ]</div>';
                } else if( data[i].deviceType == 'C' ) {
                    str += '				<div>[ <s:message code="selectDevStatus.dev.logging"/> ]</div>';
                } else if( data[i].deviceType == 'L' ) {
                    str += '				<div>[ <s:message code="selectDevStatus.dev.analysis"/> ]</div>';
                }
                str += '				</div>';
                str += '			</div>';
                str += '		</div>';
                str += '		<a href="javascript:void(0)" id="deviceStatus' + (i+1) + 'Link" deviceSeq="'+data[i].deviceSeq+'" deviceIp="'+data[i].deviceIp + '" deviceType="' + data[i].deviceType + '">';
                str += '			<div class="panel-footer">';
                str += '				<span class="pull-left dash-title" id="deviceStatus' + (i+1) + 'Title">'+data[i].deviceNm + '(' + data[i].deviceIp +')</span>';
                str += '				<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>';
                str += '				<div class="clearfix"></div>';
                str += '			</div>';
                str += '		</a>';
                str += '	</div>';
                str += '</div>';

                $(document).on('click', '#deviceStatus' + (i+1) + 'Link', function(){
                    var deviceSeq = $(this).attr('deviceSeq');
                    var deviceType = $(this).attr('deviceType');

                    if( deviceType == 'M' ) location.href = '<c:url value="/commons/deviceInfoDetailHadoop.do"/>?deviceSeq=' + deviceSeq;
                    else location.href = '<c:url value="/commons/deviceInfoDetail.do"/>?deviceSeq=' + deviceSeq;
                });
            }
            $('#deviceArea').html( str );
        }

        //장비 추가
        function insertDevice(){
            $('.savePopBtn').prop('disabled', true);
            if ($('#sshId').val().ltrim().rtrim()==''){
                ui.alertMsg('<s:message code="deviceInfo.ssh.id.input"/>')
                $('#sshId').focus();

	            return;
            }
            if ($('#sshPw').val().ltrim().rtrim()==''){
                ui.alertMsg('<s:message code="deviceInfo.ssh.password.input"/>')
                $('#sshId').focus();
	            return;
            }

            ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function(rs){
                if(rs){
                    ui.post({
                        url : 'insertDevice.xcn',
                        data : $('#addDevPopForm').serializeAll(),
                        success : function ( data, total ) {
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            $('#deviceAddPop').modal('hide');
                            getDevice();
                        },
                        error : function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete : function (){
                            $('.savePopBtn').prop('disabled', false);
                        }
                    });
                } else {
                    $('.savePopBtn').prop('disabled', false);
                }
            });
        }

        //선택된 탭
        var currentTab;
        function getCurrentTab(){
            return currentTab==null ? 'coTab' : currentTab;
        }

        function on(id) {
            var obj = $('#'+idIndicator(id));
            var hei = obj.height();
            $(obj).append( '<div class="loading_div"><i class="fa fa-spinner fa-spin fa-3x fa-fw"></i></div>');
            $('.loading_div').css({
                "position" : "absolute",
                "top" : "0px",
                "left" : "0px",
                "right" : "0px",
                "bottom" : "0px",
                "background-color" : "#f0f0f0",
                "opacity" : "0.3",
                "z-index" : "998",
                "text-align" : "center"
            });
        }
        function off(id) {
            var obj = $('#'+idIndicator(id)+' .loading_div');
            obj.remove();
        }

        /**
         * 장비 상태 조회 - SNMP
         */
        var devicePolling;
        function getDeviceStatus(deviceIp){
            console.log( deviceIp );
            //if(devicePolling) window.clearTimeout(devicePolling);
            ui.get({
                url : 'device/getDeviceStatus.xcn',
                deviceIp : deviceIp,
                success : function(data, total) {
                    if(data==null) {
                        return;
                    }

                    if( data.isConnection == undefined && data.deviceType == 'M' ) {

                    } else if( data.isConnection) {

                    }
                },
                error : function(status, message) {
                },
                complete : function() {
                    //var t = Number( $('#refreshTime').attr('val') ) * 1000;
                    devicePolling = window.setTimeout(function(){
                        getDeviceStatus(deviceIp);
                    }, 5000);
                }
            });
        }
	</script>
</head>
<div class="modal" id="deviceAddPop" tabindex="-1" role="dialog" aria-labelledby="addDevPopModal">
	<div class="modal-content">
		<form method="post" id="addDevPopForm">
			<div class="modalHead">
				<h2><s:message code="deviceInfo.addDevPop.title"/>
					<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="deviceInfo.addDevPop.title"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="attachTypePopInput" class="fname"><s:message code="deviceInfo.select.devtype"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<label  for="C"><input type="radio" value="C" name="deviceType" id="C" ><s:message code="selectDevStatus.dev.logging"/></label>
							<label  for="A" ><input type="radio" value="A" name="deviceType" id="A" style="margin-left: 10px;" checked></span><s:message code="selectDevStatus.dev.integrated"/></label>
							<label  for="L"><input type="radio" value="L" name="deviceType" id="L"  style="margin-left: 10px;"  ><s:message code="selectDevStatus.dev.analysis"/></label>
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="deviceIp"  class="fname">IP</label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="deviceIp" id="deviceIp" placeholder="IP" required maxlength="64">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="deviceNm"  class="fname"><s:message code="common.msg.name"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" id="deviceNm" name="deviceNm" required maxlength="64" placeholder="<s:message code="common.msg.name"/>">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="sshId"  class="fname"><s:message code="deviceInfo.ssh.id"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" id="sshId" name="sshId" placeholder="<s:message code="deviceInfo.ssh.id"/>" required maxlength="256">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="sshPw"  class="fname"><s:message code="deviceInfo.ssh.pw"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="password"  class="w100" id="sshPw" name="sshPw"placeholder="<s:message code="deviceInfo.ssh.pw"/>" required maxlength="512" autocomplete="off">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="comment"   class="fname"><s:message code="common.msg.comment"/></label>
						</div>
						<div class="col-65">
							<input type="text"  class="w100" id="comment" name="comment"  placeholder="<s:message code="common.msg.comment"/>" required maxlength="512">
							<input type="hidden" id="devSeqHidden" name="deviceSeq">
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02 savePopBtn" accesskey="S" id="savePopBtn"><s:message
							code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>
<div class="container">
	<div class="boxArea">
		<div class="content_body">
			<div class="row" >
				<div class="col-xs-9 text-left topArea" style="width:calc(100% - 270px); height: 35px;">
					<div class="form-group form-inline not-dashed">
						<button type="button" class="btn01" accesskey="I" id="insertBtn"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message code="deviceInfo.add.dev"/></button>
					</div>
				</div>
			</div>
			<div class="row" id="deviceArea">
			</div>
		</div>
	</div>
</div>
<script type="text/javascript" src="<c:url value="/js/sb-admin-2.js"/>"></script>

</html>