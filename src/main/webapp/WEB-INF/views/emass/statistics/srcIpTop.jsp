<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<style>

	/* The Modal (background) */
	.coach_modal {
		display: block; /* Hidden by default */
		position: fixed; /* Stay in place */
		z-index: 1; /* Sit on top */
		padding-top: 100px; /* Location of the box */
		left: 40px;
		top: 0;
		width: 100%; /* Full width */
		height: 100%; /* Full height */
		overflow: auto; /* Enable scroll if needed */
		background-color: rgb(0,0,0); /* Fallback color */
		background-color: rgba(0,0,0,0.8); /* Black w/ opacity */
	}

	/* Modal Content */
	.modal-content2 {
		margin: auto;
		padding: 20px;
		width: 93%;
		height:90%;
		background: none;
		border:none;
		color:#fff;
		font-wight:400;

	}
	.coach_logo {opacity: 0.2; font-size:12px; font-weight:300; letter-spacing:1.5px; border-top:1px solid #fff;}
	.coach_logo img { margin-top:80px; height:32px;}
	.coach_tit {margin-top:56px; font-size:18px; font-weight: 300;color:#fff; line-height: 1.5;}
	.coach_name {margin-top:24px; font-size:32px; font-weight: 600;color:#fff; line-height: 1.5;}
	.coach_name span {color:#88B8FF;font-weight: 600;}
	.coach_call {font-size:13px;margin-right:8px; letter-spacing:0.6px;  margin-top:20px; padding:8px 12px; background: #88B8FF; color:#fff; display: inline-block; border-radius: 4px; }
</style>


	<div id="myModal" class="coach_modal">

		<!-- Modal content -->
		<div class="modal-content2">
			<div>
				<div class="coach_name">
					<span>Sysadmin</span>님 환영합니다.
				</div>
				<div class="coach_tit">
					이용하고자 하는 서비스의 기능은 패킷 수집 모듈을 구매하실 경우 이용이 가능합니다.
				</div>
				<p style="padding-bottom:80px;">
					<span class="coach_call"> 영업 연락처
						<a href="mailto:salesteam@xcurenet.com" target="_top">salesteam@xcurenet.com</a>
					</span>
					<span class="coach_call"> 기술 연락처
						<a href="mailto:helpdesk@xcurenet.com" target="_top">helpdesk@xcurenet.com</a>

					</span>
				</p>

			</div>

			<div class="coach_logo">
				<img src="<c:url value="/img/logo_xcurenet.png"/>" alt="logo_xcurenet">
				<p class="mat16">
					Venus EMASS AI
				</p>
			</div>


		</div>

	</div>



<script type="text/javascript">
	function setSublist(data) {
		var element = document.getElementById('sub_1');
		if (element && data && data.length > 0 && data[0].rowKey) {
			var firstRowkey = data[0].rowKey;
			element.innerHTML = '<span>' + firstRowkey + '</span>';
		}
	}

	function getCurrentGrid(){
		var id = Number($('.listChart .active').attr('idx'));
		return tabInfo['tab'+id];
	}

	var grid1 = new Xgrid('basicStatListGrid', contextRoot);
	grid1.autoNumber();
	grid1.colAdd( "rowKey", '<s:message code="consent.user"/>', 230, "left", false, 'link' );
	grid1.colAdd("total", '<s:message code="bodyview.total"/>', 130, "right", false, 'nomal' );
	grid1.loadExportMenu('<s:message code="DATA_MONITOR.STAT_USER"/>');
	grid1.loadPageSize();
	grid1.loadHeader(false);
	grid1.initData('<s:message code="common.msg.search.click"/>');
	grid1.changePageSize = function(cnt){
		getData ('Y');
	};

	var tabInfo={};
	var chartDat={};
	grid1.onClick = function() {
		var valChk = grid1.getValue(grid1.Row, grid1.Col);
		if(valChk == "" || valChk == "-") return;

		if(grid1.getValue(grid1.Row, 'NUM') == '<s:message code="bodyview.total"/>') {
			var key = "";
			for(var i=0; i<grid1.Rows; i++) {
				if(grid1.getValue(i, 'rowKey') == "" || grid1.getValue(i, 'rowKey') == "-") continue;
				else key += grid1.getValue(i, 'rowKey').replaceAll("\"", "\\\"") + ",";
			}
			key = key.substring(0, key.length - 1)
			rowKey = key;
		}else {
			rowKey = grid1.getValue(grid1.Row, 'rowKey').replaceAll("\"", "\\\"");
		}
		rowName = grid1.getValue(grid1.Row, 'rowName');
		colKey = grid1.ColKey(grid1.Col);
		var colKeyNm = colKey;
		if (colKey == 'rowKey' || colKey == 'total' || colKey == 'NUM') {
			colKey = "";
			colKeyNm = '<s:message code="bodyview.total"/>';
		} else if (colKey == "I") {
			colKeyNm = '<s:message code="condition.receive"/>';
		} else if (colKey == "O") {
			colKeyNm = '<s:message code="condition.send"/>';
		} else {
			var xAxis = $('select[name=xAxis]').val();
			if (xAxis == "ctime_hh") colKeyNm = colKey + '<s:message code="common.msg.hour"/>';
		}

		tabID++;
		tabNum ++;
		if( tabNum > 3 ) {
			var delid = $( ".listChart li:nth-child(2)" ).attr('idx');
			$('#detailTab'+delid+' .subtab_close').click();
		}

		var displayName = (rowKey.indexOf(',') > -1) ? '<s:message code="common.msg.all"/>' : rowKey.replaceAll("\\\"", "\"");
		if(rowName!='') displayName = rowName + '&lt;' + rowKey + '&gt;';
		var id = 'tab'+tabID;
        $('.listChart').append($('<li style="display:inline-flex;text-align: center;z-index:1001;" idx="'+tabID+'" id="liTab'+tabID+'"><a data-toggle="tab" href="#tab'+tabID+'" id="detailTab'+tabID+'" style="display: flex; align-items: center; justify-content: center;">'+displayName+' - '+colKeyNm+'<span class="badge mal4"></span><button type="button" class="subtab_close closeBtn">	&#10006;</button></a></li>'));
		$('#basicStatList').after($('<div class="tab-pane fade" id="tab' + tabID + '"><div id="grid'+tabID+'" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; height: 400px"></div></div>'));

		var gid = 'grid'+tabID;
		var gridObj = new Xgrid(gid, contextRoot);
		tabInfo[id] = gridObj;
		$('.nav-tabs a[href="#tab'+tabID+'"]').tab('show');

		setGrid();

		$("#chartCntDiv").hide();
		$('#totalViewDiv').show();
		var dat = grid1.getRowData( grid1.Row );
		chartDat[tabID] = dat;
		printChart(dat);
		gridObj.loadExportMenu('<s:message code="stat.detail.user.list"/>');
		gridObj.loadPageSize();
		gridObj.changePageSize = function(cnt){
			getDetailData('Y');
		};
		getDetailData('Y');
	};

	function getData( flag ) {
		if ( searchFlag ) return;
		var sDate = $('#startdate').val().replaceAll("-", "");
		var eDate = $('#enddate').val().replaceAll("-", "");
		var xAxis = $('button.optionBtn.active').val();
		var xAxis_str = $('button.optionBtn.active').text();
		if (sDate > eDate) ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
		if(sDate === '' || eDate === '') {
			alert('<s:message code="holidayBusiness.msg.enter.date"/>');
			return;
		}

		searchFlag = true;
		grid1.on();
		ui.get({
			url : 'getStatList.xcn',
			startDate: sDate+"000000",
			endDate: eDate+"235959",
			detailQuery:'',
			xAxis : xAxis,
			yAxis : 'userid',
			offset : grid1.data.length,
			limit : grid1.pageSize,
			xAxis_str : xAxis_str,
			success : function(data, total) {
				grid1.colInit();
				grid1.autoNumber();
				grid1.colAdd('rowKey', '<s:message code="consent.user"/>', 230, 'left', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
					if(grid1.getValue(row, 'rowName') != '') {
						return grid1.getValue(row, 'rowName') + '&lt;' + value + '&gt;';
					}
					return value;
				});
				grid1.colAdd('total', '<s:message code="bodyview.total"/>', 130, 'right', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
					if ( value != undefined ) return value.comma();
					else return '';
				});
				for ( var i=0 ; i < data.pivotHeader.length ; i++ ) {
					var Header = data.pivotHeader[i];
					var HeaderNm = "";
					if ( xAxis == "ctime_yyyymmdd") HeaderNm = Header.substr(0,4)+"-"+Header.substr(4,2)+"-"+Header.substr(6,2);
					else if ( xAxis == "ctime_yyyymm") HeaderNm = Header.substr(0,4)+"-"+Header.substr(4,2);
					else if ( xAxis == "direction_svc") {
						if(Header == "I") HeaderNm = '<s:message code="condition.receive"/>';
						else HeaderNm = '<s:message code="condition.send"/>';
					} else if ( xAxis == "ctime_hh") HeaderNm = Header+'<s:message code="common.msg.hour"/>';
					else if(xAxis === 'svc1') HeaderNm = serviceList.search(Header, 'groupCd', 'groupNm');
					else HeaderNm = Header;
					grid1.colAdd( Header, HeaderNm, 90, "right", false, 'link', function ( row, cell, value, columnDef, dataContext ) {
						if ( value != undefined ) return value.comma();
						else return '';
					});
				}
				grid1.loadHeader(false);
				grid1.setData(data.pivotData);

				$('#statlist_cnt').html('<s:message code="common.msg.finish_query"/>:'+grid1.data.length);
				if ( grid1.loadingPage == 0 ) grid1.Select(-1,-1);
				searchFlag = false;

				if( data.pivotData.length > 0 ) {
					for ( var i=0 ; i < data.length ; i++ ) {
						var selected = false;
						if ( i <= 4 ) selected = true;
						else if ( i >= 10 ) break;
						addOption( 'chartListCount', (i+1), (i+1), selected );
					}

					var dat = grid1.getRowData( grid1.Row );
					totalChartDat = dat;
					printChart( dat );
				} else {
					$('#chartArea1').html('<s:message code="common.msg.nodata"/>');
					$('#space').height('7px');
				}
			},
			error : function(status, message) {
				ui.alertMsg(message);
			},
			complete : function() {
				grid1.off();
			}
		});
	}

	function getDetailData( lastRow ) {
		currentgrid = getCurrentGrid();
		if ( searchFlag ) return;

		if ( lastRow == 'Y' || lastRow == undefined ) {
			currentgrid.data.length = 0;
			currentgrid.rtnNextPageFunc = getDetailData;
			currentgrid.loadingPage = 0;
		} else {
			currentgrid.loadingPage++;
		}

		var xAxis = $('button.optionBtn.active').val();
		var xAxis_str = $('button.optionBtn.active').text();
		searchFlag = true;
		currentgrid.on();

		ui.get({
			url : 'getStatDetailList.xcn',
			rowKey : rowKey,
			colKey : colKey,
			startDate : $('#startdate').val().replaceAll("-","")+"000000",
			endDate : $('#enddate').val().replaceAll("-","")+"235959",
			detailQuery: '',
			xAxis : xAxis,
			xAxis_str : xAxis_str,
			yAxis : 'userid',
			offset : currentgrid.data.length,
			limit : currentgrid.pageSize,
			nameStat : 'users',
			success : function(data, total) {
				if ( lastRow == 'Y' || lastRow == undefined ) detailTotal = total;
				currentgrid.appendData(data.emass);
				if ( currentgrid.loadingPage == 0 ) currentgrid.Select(-1,-1);

				$('#detailTab'+tabID+' .badge').html('&nbsp;[' + total.comma() + ']');
				$('#detail_cnt'+tabID).html('<s:message code="common.msg.finish_query"/>: '+currentgrid.data.length);

				searchFlag = false;
			},
			error : function(status, message) {
				ui.alertMsg(message);
			},
			complete : function() {
				currentgrid.off();
			}
		})
	}
</script>

<script>
	// Get the modal
	var modal = document.getElementById("myModal");

	// Get the button that opens the modal
	var btn = document.getElementById("myBtn");

	// Get the <span> element that closes the modal
	var span = document.getElementsByClassName("close")[0];

	// When the user clicks the button, open the modal
	btn.onclick = function() {
		modal.style.display = "block";
	}

	// When the user clicks on <span> (x), close the modal
	span.onclick = function() {
		modal.style.display = "none";
	}

	// When the user clicks anywhere outside of the modal, close it
	window.onclick = function(event) {
		if (event.target == modal) {
			modal.style.display = "none";
		}
	}
</script>
