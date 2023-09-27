<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">
function setDashData(rightValue, leftValue){
	if( $('#dashHtmlSample').find('.rightValue') != undefined){
		$('#dashHtmlSample').find('.rightValue').text(rightValue);
	}
	if( $('#dashHtmlSample').find('.leftValue') != undefined){
		$('#dashHtmlSample').find('.leftValue').text(leftValue);
	}
}

function setPieChartSample(){
	$('.dashChartArea').highcharts({
		chart: {
			plotBackgroundColor: null,
			plotBorderWidth: null,
			plotShadow: false,
			type: 'pie'
		},
		exporting : {
			enabled: false
		},
		credits: chartAPI.credits,
		title : {
			text : ''
		},
		subtitle: {
			text: ''
		},
		tooltip: {
			pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
		},
		plotOptions: {
			pie: {
				allowPointSelect: true,
				cursor: 'pointer',
				depth: 35,
				dataLabels: {
					enabled: true,
					format: '{point.name}'
				}
			}
		},
		/* series: [{
			name: '<s:message code="dashboard.rate"/>',
			colorByPoint: true,
			data: data.facet
		}] */
		series: [{
	        name: 'Share',
	        data: [
	            { name: 'Chrome', y: 61.41 },
	            { name: 'Internet Explorer', y: 11.84 },
	            { name: 'Firefox', y: 10.85 },
	            { name: 'Edge', y: 4.67 },
	            { name: 'Safari', y: 4.18 },
	            { name: 'Other', y: 7.05 }
	        ]
	    }]
	});
}
function setChartSample(type){
	$('.dashChartArea').highcharts({
		chart: {
			type: type,
			options3d: {
				enabled: true,
				alpha: 10,
				beta: 0,
				depth: 50,
				viewDistance: 25
			}
		},
		exporting: chartAPI.exporting,
		credits: chartAPI.credits,
		title: {
		    text: ''
		},
		xAxis: {
			type: 'category',
			labels: {
				rotation: -20,
				x: 25,
				style: {
					fontSize: '13px',
					fontFamily: 'DINLig, Verdana, sans-serif'
				}
			},gridLineWidth: 0
		},
		yAxis: {
			type: 'logarithmic',
			min:1,
			title: {
				text: '(<s:message code="common.msg.count"/>)',
				rotation: 0
			}
		},
		legend: {
			enabled: false
		},
		tooltip: {
			pointFormat: '<s:message code="dashboard.collect.data_count"/> : <b>{point.y:,.0f} (<s:message code="common.msg.cnt"/>)</b>'
		},
		series: [{
			name: 'Population',
			data: [
            ['00', 4],
            ['01', 1],
            ['02', 3],
            ['03', 4],
            ['04', 2],
            ['05', 6],
            ['06', 8],
            ['07', 4],
            ['08', 8],
            ['09', 11],
            ['10', 32],
            ['11', 55],
            ['12', 81],
            ['13', 25],
            ['14', 77],
            ['15', 105],
            ['16', 41],
            ['17', 33],
            ['18', 25],
            ['19', 10],
            ['20', 3],
            ['21', 2],
            ['22', 1],
            ['23', 1]
        ],
			dataLabels: {
				enabled: true,
                format: '{point.y:,.0f}',
                style: {
                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                }
			}
		}]
	});
}

function setDashDataListSample(){
	var str ='';
	
	for(var i=0; i<5; i++){
		str += '<tr>';
		str += '	<td><i class="bodyOpenBtn fa fa-window-restore" aria-hidden="true"></i></td>';
		str += '	<td>2018-01-01 11:21:22</td>';
		str += '	<td>Webmail > Naver</td>';
		str += '	<td>Test Mail</td>';
		str += '</tr>';
	}
										
	$('.dashTableTbody').html(str);
}

</script>
<div style="display:none;">
	<div id="singleDataFormat">
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="#dashMultiLeft#" data-dashMultiRight="#dashMultiRight#"></div>
			<div class="grid-stack-item-content">
				<div class="panel #dashColor#">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-2" style="padding-right:0;">
								<i class="customClass #dashIcon#" style="font-size:35px;"></i>
							</div>
							<div class="col-xs-10 text-right" style="padding-left:0;">
								<button type="button" class="customClose">
									<span aria-hidden="true">&times;</span>
								</button>
								<div class="position_top35"><span class="rightValue huge odometerxcn"></span></div>
								<form method="post" action="<c:url value="/ems/message.do"/>" target="_self">
									<input type="hidden" name="conditionParam" />
								</form>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title">#dashName#</span>
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59"><s:message code="condition.today_str"/></div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="dualDataFormat">
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="#dashMultiLeft#" data-dashMultiRight="#dashMultiRight#"></div>
			<div class="grid-stack-item-content">
				<div class="panel #dashColor#">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-3" style="padding-right:0;">
								<i class="customClass #dashIcon# fa-3x"></i>
							</div>
							<div class="col-xs-9 text-right">
								<button type="button" class="customClose">
									<span aria-hidden="true">&times;</span>
								</button>
								<div class="position_top35"><span class="leftValue odometerxcn"></span> / <span class="rightValue huge odometerxcn"> </span></div>
								<form method="post" action="<c:url value="/ems/message.do"/>" target="_self">
									<input type="hidden" name="conditionParam" />
								</form>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title">#dashName#</span>
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59"><s:message code="condition.today_str"/></div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="chartDataFormat">
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="#dashMultiLeft#" data-dashMultiRight="#dashMultiRight#"></div>
			<div class="grid-stack-item-content">
				<div class="panel #dashColor#">
					<div class="panel-body">
						<div class="row">
							<div class="col-xs-12 text-right">
								<button type="button" class="customClose">
									<span aria-hidden="true">&times;</span>
								</button>
								<div class="dashChartArea" data-chartType="#chartType#" style="min-height: 200px;height:100%; width: 100%; margin: 0 auto"></div>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title"><i class="customClass chartDash #dashIcon#" style="font-size:float:left;position:relative;padding-right:4px;"></i>#dashName#</span>
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59"><s:message code="condition.today_str"/></div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="pieChartDataFormat">
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="#dashMultiLeft#" data-dashMultiRight="#dashMultiRight#"></div>
			<div class="grid-stack-item-content">
				<div class="panel #dashColor#">
					<div class="panel-body">
						<div class="row">
							<div class="col-xs-12 text-right">
								<button type="button" class="customClose">
									<span aria-hidden="true">&times;</span>
								</button>
								<div id="pieChart" style="min-height: 200px;height:100%; width: 100%; margin: 0 auto"></div>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title"><i class="customClass chartDash #dashIcon#" style="float:left;top:3px;position:relative;padding-right:4px;"></i>#dashName#</span>
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59"><s:message code="condition.today_str"/></div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="linhartDataFormat">
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="#dashMultiLeft#" data-dashMultiRight="#dashMultiRight#"></div>
			<div class="grid-stack-item-content">
				<div class="panel #dashColor#">
					<div class="panel-body">
						<div class="row">
							<div class="col-xs-12 text-right" style="padding-right:30px;">
								<button type="button" class="customClose">
									<span aria-hidden="true">&times;</span>
								</button>
								<div id="lineChart" style="min-height: 200px;height:100%; width: 100%; margin: 0 auto"></div>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title"><i class="customClass chartDash #dashIcon#" style="float:left;top:3px;position:relative;padding-right:4px;"></i>#dashName#</span>
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59"><s:message code="condition.today_str"/></div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="listDataFormat">
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="#dashMultiLeft#" data-dashMultiRight="#dashMultiRight#"></div>
			<div class="grid-stack-item-content">
				<div class="panel #dashColor#">
					<div class="panel-body">
						<div class="row">
							<div class="col-xs-12 text-right">
								<button type="button" class="customClose">
									<span aria-hidden="true">&times;</span>
								</button>
								<table id="mytable" class="dashboardTable table table-bordred table-striped">
									<thead>
										<tr>
											<th></th>
											<th><s:message code="condition.date"/></th>
											<th><s:message code="condition.service"/></th>
											<th><s:message code="condition.subject"/></th>
										</tr>
									</thead>
									<tbody class="dashTableTbody">
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title"><i class="customClass chartDash #dashIcon#" style="float:left;top:3px;position:relative;padding-right:4px;"></i>#dashName#</span>
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59"><s:message code="condition.today_str"/></div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="emptyDataFormat">
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="#dashMultiLeft#" data-dashMultiRight="#dashMultiRight#"></div>
			<div class="grid-stack-item-content grid-empty"></div>
		</div>
	</div>
</div>