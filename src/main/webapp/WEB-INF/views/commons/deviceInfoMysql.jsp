<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<%
	String deviceSeq = Common.nvl(request.getParameter("deviceSeq"));
%>

<style>
	th {
		text-align: center;
		vertical-align: middle;
	}
	.subTable_tr td {
		border-bottom: 1px solid #ddd;
		border-left: 1px solid #ddd;
		background-color: #EEEFF2;
		font-weight: 600;
	}
	.subTable tr {border-bottom: 1px solid #ddd;}
	.subTable td {vertical-align: middle;font-weight: 400;}
	.none_padding{
		padding: 0px !important;
		vertical-align: top !important;
	}
	.left{text-align: left}
	.subTable_bottom {border-bottom: 1px solid #a04ae0 !important;}
	.subTb {
		width: 100%;
	}
	.subTb td{
		line-height: 20px;
		height: 20px;
		padding : 0px;
		width: 100%;
	}
	.subTb tr { background-color: white; }
	.subTb tr:last-child {border-bottom: 0;}

</style>
<script type="text/javascript">
    $(document).ready(function () {
        $('#deviceInsert').click(function () {
            $('#deviceAddPop').modal('show');
        });
    });

    getDevice();

function getDevice(){
    ui.get({
	    url: 'getDeviceList.xcn',
	    success : function (data, total){
            console.log(data.devices);
            if (data.devices.length>1){
                DeviceInfo(data.devices);
            }
	    },
        error : function(status, message) {
            ui.alertMsg(message);
        },
        complete : function() {
        }
    });
}

function DeviceInfo(data){
    var str='';
    for (var i=0; i<data.length; i++){
        let statusStr="";
        let status = data[i].deviceStatus;
        if (status == 'S')statusStr = "성공";
	    else if (status == 'F') statusStr = "실패";
	    else if (status == 'T') statusStr = "연결실패";
        else statusStr = "불일치";

        let device = data[i].currentDevice;
        str += '<tr>';
        str += '<td><input type="checkbox"></td>';
        str += '<td>' + (i+1) + '</td>';
        str += '<td>' + statusStr + '</td>';
        str += '<td>' + data[i].deviceNm + '</td>';
        str += '<td>' + data[i].deviceIp + '</td>';
        str += '<td>역할</td>';
        str += '<td>' + device.load + '</td>';
        str += '<td>' + device.used + '/'+data[i].currentDevice.total+'</td>';
        str += '<td>' + device.date + '</td>';
        str += '<td class="none_padding">' + subTb(device.disk, 'mount') + '</td>';
        str += '<td class="none_padding">' + subTb(device.disk, 'total') + '</td>';
        str += '<td class="none_padding">' + subTb(device.network, 'name') + '</td>';
        str += '<td class="none_padding">' + subTb(device.network, 'ip') + '</td>';
        str += '<td class="none_padding">' + subTb(device.network, 'netmask') + '</td>';
        str += '<td class="none_padding">' + subTb(device.network, 'broadcast') + '</td>';
        str += '<td class="none_padding">' + subTb(device.network, 'rx_bytes') + '</td>';
        str += '<td class="none_padding">' + subTb(device.network, 'rx_dropped') + '</td>';
        str += '<td class="none_padding">' + subTb(device.network, 'rx_errors') + '</td>';
        str += '<td class="none_padding">' + subTb(device.network, 'tx_bytes') + '</td>';
        str += '<td class="none_padding">' + subTb(device.network, 'tx_dropped') + '</td>';
        str += '<td class="none_padding">' + subTb(device.network, 'tx_errors') + '</td>';
        str += '<td class="none_padding">' + subTb(device.network, 'status') + '</td>';
        str+= '</tr>';


        //let diskNum = data[i].currentDevice.disk.length;
        // str += '<tr>';
        // str += '<td rowspan="'+diskNum+'"><input type="checkbox"></td>';
        // str += '<td  rowspan="'+diskNum+'">'+(i+1)+'</td>';
        // str += '<td  rowspan="'+diskNum+'">'+statusStr+'</td>';
        // str += '<td  rowspan="'+diskNum+'">'+data[i].deviceNm+'</td>';
        // str += '<td  rowspan="'+diskNum+'">'+data[i].deviceIp+'</td>';
        // str += '<td  rowspan="'+diskNum+'">역할</td>';
        // str += '<td  rowspan="'+diskNum+'">'+data[i].currentDevice.load+'</td>';
        // str += '<td  rowspan="'+diskNum+'">'+data[i].currentDevice.used+'/'+data[i].currentDevice.total+'</td>';
        // str += '<td  rowspan="'+diskNum+'">'+data[i].currentDevice.date+'</td>';
        // str += '<td  rowspan="1">+data[i]+</td>';
        // str += '<td >ip</td>';
        // str += '<td>ip</td>';
        // str += '<td>ip</td>';
        // str += '<td>ip</td>';
        // str += '<td>ip</td>';
        // str += '<td>ip</td>';
        // str += '<td>ip</td>';
        // str += '<td>ip</td>';
        // str += '<td>ip</td>';
        // str += '<td>ip</td>';
        // str+= '</tr>';
		//
		//
        // for (let j = 0; j<diskNum; j++){
        //     str += '<tr>';
        //     str += '<td>'+data[i].currentDevice.disk[j].total+'</td>';
        //     str += '<td>'+data[i].currentDevice.disk[j].total+'</td>';
		//
        //     str+= '</tr>';
        // }

    }
    $('#deviceBody').html(str);
}
function subTb(data, key) {
    let result = '<table class="subTb">';
    for(let i=0 ; i < data.length ; i++) {
        let msg = nvl(data[i][key]);
        msg = msg === '' ? '&nbsp;' : msg;
        result += '<tr><td>' + msg + '</td></tr>';
    }
    return result + '</table>';
}
</script>

<div class="modal" id="deviceAddPop" aria-labelledby="keywordGroupPop" tabindex="-1" role="dialog">
	<div class="modal-content">
		<form method="post" id="deviceAddPopForm" onsubmit="return false;">
			<div class="modalHead">
				<h2>장비추가</h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3>장비 추가</h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						필수 입력 사항입니다.
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="deviceName" class="fname">이름</label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="deviceName" id="deviceName">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="deviceIp" class="fname">IP</label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="deviceIp" id="deviceIp">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="deviceSSHId" class="fname">SSH 아이디</label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="deviceSSHId" id="deviceSSHId">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="deviceSSHPassword" class="fname">SSH 비밀번호</label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="password" class="w100" name="deviceSSHPassword" id="deviceSSHPassword">
						</div>
					</div>

				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="deviceInfoSaveBtn"><s:message
							code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>


<div class="container">
	<div class="searchArea">
		<div class="searchSub">
			<div>
				<input type="text" placeholder="장비 이름을 입력하세요." id="searchStrGroup" style="width: 220px;">
			</div>
			<button type="button" class="btn01" accesskey="I" id="deviceInsert"><img
					src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
			<button type="button" class="btn02" accesskey="D" id="deviceDelete"><img
					src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
		</div>

		<table class="subTable">
			<thead>
			<tr>
				<th rowspan="2"><input type="checkbox" id="checkBox"></th>
				<th rowspan="2">NO</th>
				<th rowspan="2">상태</th>
				<th rowspan="2">이름</th>
				<th rowspan="2">IP</th>
				<th rowspan="2">역할</th>
				<th rowspan="2">로드평균</th>
				<th rowspan="2">메모리 사용량</th>
				<th rowspan="2">Date</th>
				<th colspan="2" class="subTable_bottom">디스크 사용량</th>
				<th colspan="11" class="subTable_bottom">네트워크 인터페이스</th>
			</tr>
			<tr class="subTable_tr">
				<td>파티션</td>
				<td>사용량</td>
				<td>장치</td>
				<td>IP</td>
				<td>Subnet Mask</td>
				<td>broadcast</td>
				<td>RX</td>
				<td>RX DROP</td>
				<td>RX ERR</td>
				<td>TX</td>
				<td>TX DROP</td>
				<td>TX ERR</td>
				<td>Status</td>
			</tr>
			</thead>
			<tbody id="deviceBody">
			</tbody>
		</table>

	</div>


</div>


	
