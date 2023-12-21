
var chartAPI = {
		height : 350,
		exporting: {
			url : contextRoot + '/exportChart.xcn',
			type : 'image/png',
			filename : 'Export_Chart',
			sourceWidth: $('#chartArea1').width(),
			sourceHeight: $('#chartArea1').height(),
			buttons: {
				contextButton: {
					menuItems: [
					{
						text: '<img src="'+contextRoot+'/img/icon/icon_disk.png" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.imageSave,
						onclick: function () {
							this.exportChart();
						}
					}/*,{
						text: '<br />',
						onclick: function () {}
					},
					{
						text: '<img src="'+contextRoot+'/img/icon/line.bmp" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.curveChart,
						onclick: function () {chartAPI.changeChartType('spline', this);}
					}, {
						text: '<img src="'+contextRoot+'/img/icon/line.bmp" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.polyChart,
						onclick: function () {chartAPI.changeChartType('line', this);}
					}, {
						text: '<img src="'+contextRoot+'/img/icon/line.bmp" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.pointChart,
						onclick: function () {chartAPI.changeChartType('scatter', this);}
					}, {
						text: '<img src="'+contextRoot+'/img/icon/bar.bmp" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.barChart,
						onclick: function () {chartAPI.changeChartType('column', this);}
					}, {
						text: '<img src="'+contextRoot+'/img/icon/area.bmp" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.areaChart,
						onclick: function () {chartAPI.changeChartType('areaspline', this);}
					}*/]
				}
			},
			chartOptions: {
				xAxis: {
					labels: {
						style: {
							fontSize:'6px'
						}
					}
				},
				yAxis: {
					labels: {
						style: {
							fontSize: '6px' 
						}
					},
					title: {
						style: {
							fontSize: '6px'
						}
					}
				},
				legend: {
					itemStyle: {
						fontSize: '6px'
					}
				}
			},
			fallbackToExportServer: false
		},
		exporting3: {
			url : contextRoot + '/export',
			type : 'image/png',
			filename : 'Export_Chart',
			buttons: {
				contextButton: {
					menuItems: [
					{
						text: '<img src="'+contextRoot+'/img/icon/icon_disk.png" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.imageSave,
						onclick: function () {
							this.exportChart();
						}
					},{
						text: '<br />',
						onclick: function () {}
					},
					{
						text: '<img src="'+contextRoot+'/img/icon/line.bmp" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.curveChart,
						onclick: function () {chartAPI.changeChartType('spline', this);}
					}, {
						text: '<img src="'+contextRoot+'/img/icon/line.bmp" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.polyChart,
						onclick: function () {chartAPI.changeChartType('line', this);}
					}, {
						text: '<img src="'+contextRoot+'/img/icon/line.bmp" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.pointChart,
						onclick: function () {chartAPI.changeChartType('scatter', this);}
					}, {
						text: '<img src="'+contextRoot+'/img/icon/bar.bmp" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.barChart,
						onclick: function () {chartAPI.changeChartType('column', this);}
					}, {
						text: '<img src="'+contextRoot+'/img/icon/area.bmp" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.areaChart,
						onclick: function () {chartAPI.changeChartType('areaspline', this);}
					}]
				}
			}
		},
		exporting2: {
			url : contextRoot + '/export',
			type : 'image/png',
			filename : 'Export_Chart',
			width:2000,
			buttons: {
				contextButton: {
					menuItems: [{
						text: '<img src="'+contextRoot+'/img/icon/icon_disk.png" width="16" style="width:16px;height:16px;vertical-align: middle;"> ' + chartAPIJS.imageSave,
						onclick: function () {
							this.exportChart();
						}
					}]
				}
			}
		},
		legend: {
			enabled : true,
			align: 'center',
			verticalAlign: 'bottom',
			x: 0,
			y: 10,
			floating: true,
			backgroundColor: '#ffffff',
			borderColor: '#5B5C60',
			borderWidth: 0,
			shadow: false,
			itemStyle: {
				color: '#434343'
			}
		},
		//backgroundColor : '#232427',
		credits : false,
		scrollbar: {
			barBackgroundColor: '#484848',
			barBorderRadius: 0,
			barBorderWidth: 0,
			buttonBackgroundColor: '#484848',
			buttonBorderWidth: 0,
			buttonBorderRadius: 0,
			trackBackgroundColor: 'none',
			trackBorderWidth: 1,
			trackBorderRadius: 0,
			trackBorderColor: '#CCC'
		},
		changeChartType : function ( type, obj ) {
			if ( type == 'scatter' ) {
				if ( obj.options.chart.options3d.enabled ) obj.options.chart.options3d.enabled = false;
			} else {
				if ( !obj.options.chart.options3d.enabled ) obj.options.chart.options3d.enabled = true;
			}
			obj.options.chart.type=type;
			var s = obj.series;
			for ( var i=0 ; i < s.length ; i++ ) {
				try{
					s[i].update({type:type});
				}catch(e){}
			}
		},
		setSeriesObject : function ( name, data )
		{
			var seriesObject = new Object ( );
			seriesObject.name = name;
			seriesObject.data = data;
			return seriesObject;
		}
};










