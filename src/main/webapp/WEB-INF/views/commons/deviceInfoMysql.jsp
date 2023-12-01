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

	.subTable{
		width: 100%;
		table-layout: fixed;
	}

	.subTable_tr th:first-child {
		border-left: 1px solid #ddd;
	}

	.subTable_tr td {
		border-bottom: 1px solid #ddd;
		border-left: 1px solid #ddd;
		background-color: #EEEFF2;
		font-weight: 600;
	}

	.subTable tr {
		border-bottom: 1px solid #ddd;
	}

	.subTable td {
		vertical-align: middle;
		font-weight: 400;
	}
	.subTable th {
		height: 28px;
		line-height: 28px;
		vertical-align: middle;
		font-weight: 600;
		border-top: 0;
	}

	.none_padding {
		padding: 0 !important;
		vertical-align: top !important;
	}

	.left {
		text-align: left !important;
	}

	.subTable_bottom {
		border-bottom: 1px solid #a04ae0 !important;
	}

	.subTb {
		width: 100%;
	}

	.subTb td {
		line-height: 20px;
		height: 25px;
		padding: 2px;
		width: 100%;
	}
	.subTb tr {
		background-color: white;
	}
	.subTb tr:last-child {
		border-bottom: 0;
	}
	.usage {
		position: relative;
		margin: 0;
		line-height: 13px;
	}
	.usage .usage-reading {
		z-index: 2;
		display: block;
		position: relative;
		padding-bottom: 3px;
		border: 1px solid transparent;
		text-align: center;
		color: #424242;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
	.usage .usage-low {background-color: #96C55A;}
	.usage .usage-bar {
		z-index: 1;
	}
	.usage .usage-bar, .usage .usage-bar-rest {
		position: absolute;
		bottom: 0;
		left: 0;
		width: 100%;
		height: 2px;
	}
	.usage .usage-bar-rest {
		z-index: 0;
		background-color: #ddd;
	}
</style>
<script type="text/javascript">
	$(document).ready(function () {
		$('#deviceInsert').click(function () {
			$('#deviceAddPop').modal('show');
		});

		getDevice();
	});

	function getDevice() {
		ui.get({
			url: 'getDeviceList.xcn',
			success: function (data, total) {
				console.log(data.devices);
				if (data.devices.length > 1) {
					deviceInfo(data.devices);
				}
			},
			error: function (status, message) {
				ui.alertMsg(message);
			},
			complete: function () {
			}
		});
	}

	function deviceInfo(data) {

		$("#deviceCount").html(' [' + data.length.comma() + '건]');
		let str = '';
		for (let i = 0; i < data.length; i++) {
			let statusStr = "";
			let status = data[i].deviceStatus;
			if (status == 'S') statusStr = "성공";
			else if (status == 'F') statusStr = "실패";
			else if (status == 'T') statusStr = "연결실패";
			else statusStr = "불일치";

			let device = data[i].currentDevice;
			str += '<tr>';
			str += '<td><input type="checkbox"></td>';
			str += '<td>' + (i + 1) + '</td>';
			str += '<td>' + statusStr + '</td>';
			str += '<td>' + data[i].deviceNm + '</td>';
			str += '<td>' + data[i].deviceIp + '</td>';
			str += '<td>역할</td>';
			str += '<td>' + device.load + '</td>';

			str += '<td>';
			str += '    <span class="usage_rate">' + device.usedRate + '</span>';
			str += '    <span>';
			str += '        <div class="usage">';
			str += '            <span class="usage-reading">' + device.used + ' / ' + data[i].currentDevice.total + '</span>';
			str += '            <span class="usage-bar usage-low" style="width: ' + device.usedRate + '"></span>';
			str += '            <span class="usage-bar-rest"></span>';
			str += '        </div>';
			str += '    </span>';
			str += '</td>';

			str += '<td>' + device.date + '</td>';
			let rows = device.disk.length > device.network.length ? device.disk.length : device.network.length;
			str += '<td class="none_padding">' + subTb(rows, device.disk, 'mount', 'left') + '</td>';
			str += '<td class="none_padding">' + subTbDisk(rows, device.disk) + '</td>';
			str += '<td class="none_padding">' + subTb(rows, device.network, 'name') + '</td>';
			str += '<td class="none_padding">' + subTb(rows, device.network, 'ip') + '</td>';
			str += '<td class="none_padding">' + subTb(rows, device.network, 'netmask') + '</td>';
			str += '<td class="none_padding">' + subTb(rows, device.network, 'broadcast') + '</td>';
			str += '<td class="none_padding">' + subTb(rows, device.network, 'rx_bytes') + '</td>';
			str += '<td class="none_padding">' + subTb(rows, device.network, 'rx_dropped') + '</td>';
			str += '<td class="none_padding">' + subTb(rows, device.network, 'rx_errors') + '</td>';
			//str += '<td class="none_padding">' + subTb(rows, device.network, 'tx_bytes') + '</td>';
			//str += '<td class="none_padding">' + subTb(rows, device.network, 'tx_dropped') + '</td>';
			//str += '<td class="none_padding">' + subTb(rows, device.network, 'tx_errors') + '</td>';
			str += '<td class="none_padding">' + subTb(rows, device.network, 'status') + '</td>';
			str += '</tr>';
		}
		$('#deviceBody').html(str);
	}

	function subTb(rows, data, key, align) {
		if(align === undefined) align = '';
		let result = '<table class="subTb">';
		for (let i = 0; i < rows; i++) {
			if(data[i] !== undefined) {
				let msg = nvl(data[i][key]);
				msg = msg === '' ? '&nbsp;' : msg;
				result += '<tr><td class="' + align + '">' + msg + '</td></tr>';
			} else {
				result += '<tr><td class="' + align + '">&nbsp;</td></tr>';
			}
		}
		return result + '</table>';
	}
	function subTbDisk(rows, data) {
		let result = '<table class="subTb">';
		for (let i = 0; i < rows; i++) {
			if(data[i] !== undefined) {
				let msg = nvl(data[i]['used']) + ' / ' + nvl(data[i]['total']);
				msg = '<span><div class="usage"><span class="usage-reading">' + msg + '</span><span class="usage-bar usage-low" style="width: ' + data[i].use + ';"></span><span class="usage-bar-rest"></span></div></span>';
				result += '<tr><td title="'+data[i].use+'">' + msg + '</td></tr>';
			} else {
				result += '<tr><td>&nbsp;</td></tr>';
			}
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
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="deviceInfoSaveBtn"><s:message code="common.msg.save"/></button>
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
			<button class="form_btn01" accesskey="Q" id="searchBtn" accesskey="s">조회</button>
			<button type="button" class="btn01" accesskey="I" id="deviceInsert"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
			<button type="button" class="btn02" accesskey="D" id="deviceDelete"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					장비 목록
					<span id="deviceCount"></span>
				</button>
			</div>
			<div id="deviceGrid" class="slickGrid gridArea" style="display: inline-block;overflow: auto;width: 100%;">
				<table class="subTable">
					<colgroup>
						<col style="width: 30px;"><!-- check box-->
						<col style="width: 30px;"><!-- No -->
						<col style="width: 50px;"><!-- 상태 -->
						<col style="width: 120px;"><!-- 이름 -->
						<col style="width: 120px;"><!-- IP -->
						<col style="width: 120px;"><!-- 역할 -->
						<col style="width: 120px;"><!-- 로드 -->
						<col style="width: 130px;"><!-- 메모리 사용 -->
						<col style="width: 140px;"><!-- date -->
						<col style="width: 100px;"><!-- 파티션 -->
						<col style="width: 80px;"><!-- 사용량 -->
						<col style="width: 80px;"><!-- 장치 -->
						<col style="width: 100px;"><!-- IP -->
						<col style="width: 100px;"><!-- subnet -->
						<col style="width: 100px;"><!-- broadcast -->
						<col style="width: 70px;"><!-- RX -->
						<col style="width: 70px;"><!-- RX Drop -->
						<col style="width: 70px;"><!-- RX Err -->
						<%--<col style="width: 70px;"><!-- TX -->
						<col style="width: 70px;"><!-- TX Drop -->
						<col style="width: 70px;"><!-- TX Err -->--%>
						<col style="width: 70px;"><!-- Status-->
					</colgroup>
					<thead>
					<tr>
						<th rowspan="2"><input type="checkbox" id="checkBox"/></th>
						<th  rowspan="2">No.</th>
						<th rowspan="2">상태</th>
						<th rowspan="2">이름</th>
						<th rowspan="2">IP</th>
						<th rowspan="2">역할</th>
						<th rowspan="2">로드평균</th>
						<th rowspan="2">메모리 사용량</th>
						<th rowspan="2">Date</th>
						<th colspan="2" class="subTable_bottom">디스크 사용량</th>
						<th colspan="8" class="subTable_bottom">네트워크 인터페이스</th>
					</tr>
					<tr class="subTable_tr">
						<th>파티션</th>
						<th>사용량</th>
						<th>장치</th>
						<th>IP</th>
						<th>Subnet Mask</th>
						<th>BROADCAST</th>
						<th>RX</th>
						<th>RX DROP</th>
						<th>RX ERR</th>
						<%--<th>TX</th>
						<th>TX DROP</th>
						<th>TX ERR</th>--%>
						<th>Status</th>
					</tr>
					</thead>
					<tbody id="deviceBody">
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>