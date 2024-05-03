<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<link rel="stylesheet" href="<c:url value="/css/dashboard.css"/>"/>
<%
	String infoFeedbackYn = Common.getInfoFeedbackYn(session);
	boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
	String adminType = Common.getAdminType(session);
	String systemArch = Config.getString("system.arch");
	pageContext.setAttribute("arch", systemArch);
%>

<style type="text/css">

	#contentArea {
	}


	.filename{
		display: block;
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		max-width: 57% !important;
	}

	.name{
		display: block;
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		/*max-width: 15em !important;*/
	}

	.files :hover {
		cursor: pointer;
		text-decoration: underline;
	}

	.filename:hover {
		cursor: pointer;
		text-decoration: underline;
	}


	.name:hover {
		cursor: pointer;
		text-decoration: underline;
	}

	.rightValue:hover {
		cursor: pointer;
		text-decoration: underline;
	}

	.dash-title:hover {
		cursor: pointer;
		text-decoration: underline;
	}


	.form_btn05:hover {
		color: #fff !important;
	}

	.form_btn05:active {
		color: #fff !important;
	}

	.panel-body {
		padding-top: 15px;
		padding-bottom: 0px;
	}

	#emptyDiv {
		position: absolute;
		top: 110px;
		bottom: 100px;
		left: 0;
		right: 0;
	}

	#emptyDiv p, #emptyDiv h1 {
		text-align: center;
	}

	.empty-dashboard-message {
		margin: 0 auto;
		text-align: center;
		width: 700px;
		padding: 40px;
		overflow: hidden;
	}

	.empty-dashboard-message a {
		color: #1C64D3;
		text-decoration: underline;
	}

	.empty-dashboard-message a:hover {
		color: #1C64D3;
		text-decoration: underline;
	}

	.empty-dashboard-message p {
		line-height: 1.3;
	}

	#emptyDashboard {
		text-align: center;
		padding-top: 25px;
	}

	.customBtn {
		border: 1px solid #ccc;
	}


	.carousel-inner {

	}

	.item {
		padding-top: 10px;
	}

	.addDashboardContent:hover {
		text-decoration: none;
	}

	.card {
		border: 1px solid #ddd;
		background: #fff;
		padding: 14px 80px 18px 36px;
		cursor: pointer;
	}

	.card:hover {
		box-shadow: 0px 12px 12px rgba(0, 0, 0, .12), 0 5px 10px rgba(0, 0, 0, .06);

	}

	.card h4 {
		font-weight: 600;
		color: #000;
	}

	.card p {
		color: #999;
		font-size: 12px;
	}

	.card div {
		color: #111;
		font-size: 16px;
	}

	.card img {
		position: absolute;
		top: 20px;
		right: 15px;
		max-height: 120px;
	}

	.card-1 {
		height: 80px;
		background-color: #F8F8F8;
		padding: 16px;
		border: 2px dashed #ddd;
		margin-bottom: 16px;
	}

	.card-1 > div {
		color: #1C64D3;
		font-weight: 600;
	}

	@media (max-width: 990px) {
		.card {
			margin: 20px;
		}
	}

	.customClose {
		color: #666;
		opacity: 1;
	}

	.customClose:hover {
		color: #999;
	}

	.grid-stack-item-content {
		text-align: left;

	}

	.customClass {
		font-size: 3em !important;
	}

	.chartDash {
		font-size: 15px !important;
	}

	.grid-stack-item-content .fa {
		display: inline-block;

	}

	div#conditionViewDiv {
		position: absolute;
		display: none;
		text-align: left;
		z-index: 1000;
		border: 1px solid #555;
		background-color: #f8f8f8;
		width: 400px;
		overflow: auto;
		word-break: break-all;
	}

	.tCenter {
		text-align: center;
		background-color: #f9f9f9;
	}

	.Center {
		text-align: center;
	}

	.tLeft {
		text-align: left;
	}

	.tRight {
		text-align: right;
	}

	.col-md-3 {
		padding: 0 6px;
	}
</style>
<script type="text/javascript">
    Highcharts.setOptions({
        chart: {
            type: 'column',
            marginTop: 0,
            marginBottom: 0,
            spacingBottom: 0
        },
        global: {useUTC: false},
        gridLineColor: '#fff',
        colors: ['#80599F', '#656C7C', '#598AD3', '#D35976', '#DDDDDD', '#bb6ecb', '#439851', '#33a0c4', '#7558cb', '#97b420'],
        lang: {
            months: ['<s:message code="common.january"/>', '<s:message code="common.february"/>', '<s:message code="common.march"/>', '<s:message code="common.april"/>', '<s:message code="common.may"/>', '<s:message code="common.june"/>', '<s:message code="common.july"/>', '<s:message code="common.august"/>', '<s:message code="common.september"/>', '<s:message code="common.october"/>', '<s:message code="common.november"/>', '<s:message code="common.december"/>'],
            shortMonths: ['<s:message code="common.january"/>', '<s:message code="common.february"/>', '<s:message code="common.march"/>', '<s:message code="common.april"/>', '<s:message code="common.may"/>', '<s:message code="common.june"/>', '<s:message code="common.july"/>', '<s:message code="common.august"/>', '<s:message code="common.september"/>', '<s:message code="common.october"/>', '<s:message code="common.november"/>', '<s:message code="common.december"/>'],
            weekdays: ['<s:message code="common.sunday"/>', '<s:message code="common.monday"/>', '<s:message code="common.tuesday"/>', '<s:message code="common.wednesday"/>', '<s:message code="common.thursday"/>', '<s:message code="common.friday"/>', '<s:message code="common.saturday"/>'],
            contextButtonTitle: '<s:message code="common.msg.char_type"/>',
            thousandsSep: ','
        },
        xAxis: {
            dateTimeLabelFormats: {
                day: '<s:message code="dashboard.display.day" arguments="%b,%d" />'
            }
        },
        yAxis: {
            gridLineColor: '#333',
            gridLineWidth: 0.1
        }
    });

    var systemArch = '<%=systemArch%>';
    var adminType = '<%=adminType%>';
    var date;
    var editMode = 'N';
    var loggingDataSettingVal;
    var fileTopDataSettingVal;

    $.urlParam = function (name) {
        var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
        if (results == null) {
            return null;
        } else {
            return results[1] || 0;
        }
    }
    var menuKey;
    $(document).ready(function () {
        menuKey = $.urlParam('menuKey');
        if (menuKey) dashboardInit();
        else getDefaultMenuKey();

        getLoggingDataSetting();
        getFileDataSetting();

        function isDefaultDashboard(menuKey) {
            ui.get({
                menuKey: menuKey,
                url: 'isDefaultDashboard.xcn',
                success: function (data, total) {
                    if (data === "false") {
                        dashboardInit();
                    } else {
                        document.location.href = '<c:url value="/ems/dashboard.do"/>';
                    }
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }


        $('#setupDashboardBtn').click(function () {
            location.href = '<c:url value="/ems/dashboardSetup.do"/>';
        });

        $('#editDashboardBtn, #editDashboardBtnPop').click(function () {
            editMode = 'Y';
            $('#emptyDiv').hide();
            $('.searchArea').css('top', '150px');
            $('.dashboardHeader').show();
            var grid = $('#dashboardArea').data('gridstack');
            grid.movable('.grid-stack-item', true);
            grid.resizable('.grid-stack-item', true);
        });

        $('#saveDashboardBtn').click(function () {
            ui.confirmMsg('<s:message code="custom.msg.save"/>', '', '', function (rs) {
                if (rs) {
                    $('.dashboardHeader').hide();
                    var grid = $('#dashboardArea').data('gridstack');
                    grid.movable('.grid-stack-item', false);
                    grid.resizable('.grid-stack-item', false);

                    dashboardGrid.saveGrid();
                    $('.searchArea').css('top', '0px');
                    // $('#dashboardArea').css('top', '25px');
                    editMode = 'N';
                }
            });
        });
        $('#cancleDashboardBtn').click(function () {
            ui.confirmMsg('<s:message code="custom.msg.cancle"/>', '', '', function (rs) {
                if (rs) {
                    $('.dashboardHeader').hide();

                    var grid = $('#dashboardArea').data('gridstack');
                    grid.movable('.grid-stack-item', false);
                    grid.resizable('.grid-stack-item', false);

                    getDashBoardList();
                    $('.searchArea').css('top', '0px');
                    // $('#dashboardArea').css('top', '25px');
                    editMode = 'N';
                }
            });

        });
        $(document).on('click', '#addDefaultData', function () {
            ui.get({
                url: 'insertDashBoardDefaultData.xcn',
                success: function (data, total) {
                    ui.alertMsg('<s:message code="custom.msg.addDefaultSet"/> \n\n <s:message code="dashboardMenu.msg.refresh"/>', function () {
                        window.location.reload();
                    });
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        });


        $(document).on('mouseover', '.conditionView', function (e) {
            if ($('#conditionViewDiv').css('display') == 'block') return;
            $('#conditionViewDiv').fadeIn();
            var x = e.clientX;
            var o = $(this).parent().parent().offset();
            $('#conditionViewDiv').css({'top': '100px', 'left': o.left})

            var index = $(this).parent().parent().parent().attr('data-index');

            $('#conditionViewContent').html(printAlarmValStr('', JSON.parse(contentData[index].dashCondition), 'return'));
        });
        $(document).on('mouseout', '.conditionView', function () {
            $('#conditionViewDiv').hide();
        });

        $(document).on('click', '.panel-footer', function () {
            var id = $(this).parents('.grid-stack-item').attr('data-gs-id');
            var dashCondition;

            for (var i = 0; i < contentData.length; i++) {
                if (contentData[i].dashKey == id.split('_')[1]) {
                    dashCondition = contentData[i].dashCondition;
                    break;
                }
            }
            if (dashCondition != undefined) {
                $('#conditionParam').val(makePeriod(dashCondition));
                $('#getMessageInfo').submit();
            }
        });

        $(document).on('click', '.rightValue', function () {
            var id = $(this).parents('.grid-stack-item').attr('data-gs-id');
            var dashCondition;

            for (var i = 0; i < contentData.length; i++) {
                if (contentData[i].dashKey == id.split('_')[1]) {
                    dashCondition = contentData[i].dashCondition;
                    break;
                }
            }
            if (dashCondition != undefined) {
                // console.log(dashCondition);
                $('#conditionParam').val(makePeriod(dashCondition));
                console.log(makePeriod(dashCondition));
                $('#getMessageInfo').submit();
            }
        });

        $(document).on('click', '.bodyOpenBtn', function () {
            var msgid = $(this).attr('data-msgid');
            openMessageBody('', msgid, '');
        });

        $('#dashboardSelect').selectpicker({
            container: 'body',
            width: '200px'
        });

        $(document).on('click', '.addDashboardContent', function () {
            var index = $(this).attr('data-index');


            var obj = getDashPosition(contentData[index].dashKey, contentData[index].dashType, contentData[index].dashChart);
            var id = menuKey + '_' + contentData[index].dashKey;

            var hasFlag = false;
            $('#dashboardArea').find('.grid-stack-item').each(function (index) {
                if ($(this).attr('data-gs-id') == id) {
                    hasFlag = true;
                    return false;
                }
            });
            if (hasFlag) {
                alert('<s:message code="custom.msg.alreadySave"/>');
                return;
            }


            var htmlObj = $(contentData[index].html);
            obj.html = htmlObj;
            //obj.html = contentData[index].html;

            dashboardGrid.addWidget(obj);
        });

        $('#menuLoggingBtn').click(function () {
            $("#loggingDataPop").modal('show');
            $('#loggingDataUseYn').val(loggingDataSettingVal);
        });

        $('#fileTopBtn').click(function () {
            $("#fileTopDataPop").modal('show');
            $('#fileTopDataUseYn').val(fileTopDataSettingVal);
        });


        $('#loggingDataSaveBtn').click(function () {
            saveLoggingData();
        });

        $('#fileTopDataSaveBtn').click(function () {
            saveFileTopData();
        });

        $('#menuDefaultSetupBtn').click(function () {
            var menuName = $('.navi').html();
            ui.confirmMsg('<s:message code="custom.msg.defaultSave"/>', '', '', function (rs) {
                if (rs) {
                    ui.get({
                        url: 'changeDashBoardDefaultMenu.xcn',
                        menuKey: menuKey,
                        menuName: menuName,
                        success: function (data, total) {
                            defaultMenuKey = menuKey;
                            changeMainMenu(menuKey);
                            ui.alertMsg('<s:message code="common.msg.modified"/>');
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                        }
                    });
                }
            });
        })
    });


    function saveLoggingData() {
        ui.confirmMsg('<s:message code="base.change.pw"/>', '', '', function (rs) {
            if (rs) {
                ui.get({
                    url: 'saveLoggingData.xcn',
                    useYn: $('#loggingDataUseYn').val(),
                    success: function (data, total) {
                        $("#loggingDataPop").modal('hide');
                        ui.alertMsg('<s:message code="dashboard.logginDataChange"/>');
                        getLoggingDataSetting();
                    },
                    error: function (status, message) {
                        ui.alertMsg(message);
                    },
                    complete: function () {
                    }
                });
            }
        });
    }

    function saveFileTopData() {
        ui.confirmMsg('<s:message code="base.change.pw"/>', '', '', function (rs) {
            if (rs) {
                ui.get({
                    url: 'saveFileTopData.xcn',
                    useYn: $('#fileTopDataUseYn').val(),
                    success: function (data, total) {
                        $("#fileTopDataPop").modal('hide');
                        ui.alertMsg('<s:message code="dashboard.logginDataChange"/>');
                        getFileDataSetting();
                    },
                    error: function (status, message) {
                        ui.alertMsg(message);
                    },
                    complete: function () {
                    }
                });
            }
        });
    }


    function getLoggingDataSetting() {
        ui.get({
            url: 'getLoggingDataSetting.xcn',
            success: function (data, total) {
                loggingDataSettingVal = data;

                if(editMode == 'Y') {
                    if (loggingDataSettingVal == 'Y') {
                        $('#dashboardInfo').show();
                        $('#dashboardInfo').css('margin-top', '200px');
                        $('#dashboardArea').css('top', '-10px');
                        $('#emptyDiv').hide();
                        getLoggingData();
                    } else {
                        $('#dashboardInfo').hide();
                    }
                }else {
                    if (loggingDataSettingVal == 'Y') {
                        $('#dashboardInfo').show();
                        $('#dashboardInfo').css('margin-top', '200px');
                        $('#dashboardArea').css('top', '-10px');
                        $('#emptyDiv').hide();
                        getLoggingData();
                    } else {
                        console.log("44");
                        $('#dashboardInfo').hide();
                        if (listCnt == 0 && fileTopDataSettingVal != 'Y') $('#emptyDiv').show();
                    }
                }
            },
            error: function (status, message) {
                console.log(message);
            },
            complete: function () {
            }
        });
    }

    function getFileDataSetting() {
        ui.get({
            url: 'getFileDataSetting.xcn',
            success: function (data, total) {
                fileTopDataSettingVal = data;
                console.log("loggingDataSettingVal"+loggingDataSettingVal);
                if(editMode == 'Y') {
                    if (fileTopDataSettingVal == 'Y') {
                        $('#dashboardInfo2').show();
                        // $('#dashboardInfo2').css('margin-top', '200px');
                        $('#dashboardArea').css('top', '-10px');
                        $('#emptyDiv').hide();
                        getFileTopData();
                    } else {
                        $('#dashboardInfo2').hide();
                    }

                }else {
                    if (fileTopDataSettingVal == 'Y') {
                        $('#dashboardInfo2').show();
                        // $('#dashboardInfo2').css('margin-top', '200px');
                        $('#dashboardArea').css('top', '-10px');
                        $('#emptyDiv').hide();
                        getFileTopData();
                    } else {
                        $('#dashboardInfo2').hide();
                        if (listCnt == 0 && loggingDataSettingVal != 'Y') $('#emptyDiv').show();
                    }
                }
            },
            error: function (status, message) {
                console.log(message);
            },
            complete: function () {
            }
        });
    }

    function padZero(num) {
        return num < 10 ? "0" + num : num;
    }

    function makeTableLoggingData(data) {
        var str = "<table class='mainTable'><tr>"
        str += "<th> 구분 </th>";
        for (var i = 0; i < data.length; i++) {
            var year = data[i].date.slice(0, 4);
            var month = data[i].date.slice(4, 6) - 1;
            var day = data[i].date.slice(6, 8);
            var dateObject = new Date(year, month, day);
            var formattedDate = dateObject.getFullYear() + "-" + padZero(dateObject.getMonth() + 1) + "-" + padZero(dateObject.getDate());
            str += "<th>" + formattedDate + "</th>";
        }
        str += "</tr><tr>";
        str += "<td><s:message code="dashboard.loggingData.count2"/></td>";
        for (var i = 0; i < data.length; i++) {
            str += "<td>" + data[i].logging.comma() + "</td>";
        }
        str += "</tr><tr>"
        str += "<td><s:message code="dashboard.loggingData.attach.size"/></td>";
        for (var i = 0; i < data.length; i++) {
            str += "<td>" + data[i].attachStr + "</td>";
        }
        str += "</tr></table></div>"

        $('#loggingCount').html(data.length > 0 ? str : '');
    }

    function printChart2(dat) {
        var visible = true;
        // if(systemArch == 'multiple' && adminType == 'M') visible = false;

        var categories = [];
        var logging = [];
        var attach = [];
        var attachStr = [];
        if (dat.length == 0) {
            $('#loggingChart').html('<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data" width="100px;" height="100px" style="margin:auto; display:block; margin-top:50px;">');
            return false;
        }  else {
            for (var i = 0; i < dat.length; i++) {
                categories.push(getDateFormatSize(dat[i].date));
                logging.push(Number(dat[i].logging));
                attach.push(dat[i].attach == undefined ? 0 : Number(dat[i].attach));
            }
        }
        var rotation = 40;
        if (chartxAxis == 'W') rotation = 0;
        $('#loggingChart').highcharts({
            chart: {
                zoomType: 'xy'
            },
            title: {
                text: ''
            },
            subtitle: {
                text: ''
            },
            exporting: {enabled: false},
            credits: chartAPI.credits,
            xAxis: [{
                categories: categories,
                crosshair: true
            }],
            yAxis: [{
                labels: {
                    format: Number('{value}'),
                    style: {color: Highcharts.getOptions().colors[1]}
                },
                title: {
                    text: '',
                    style: {color: Highcharts.getOptions().colors[1]}
                }
            }, {
                title: {
                    text: '',
                    style: {color: Highcharts.getOptions().colors[0]}
                },
                labels: {
                    format: Number('{value}'),
                    style: {color: Highcharts.getOptions().colors[0]}
                },
                opposite: true,
            }],
            tooltip: {
                formatter: function () {
                    var rs = ['<b>' + this.x + '</b><br />'].concat(
                        this.points ?
                            this.points.map(function (point) {
                                var str = '';
                                if (point.series.name == '<s:message code="dashboard.loggingData.count2"/>') {
                                    str += '<span style="color:' + point.series.color + '">\u25CF</span> ' + point.series.name + ': ' + point.y.comma() + '(<s:message code="common.msg.cnt"/>)<br />';
                                } else if (point.series.name == '<s:message code="dashboard.loggingData.attach.size"/>') str += '<span style="color:' + point.series.color + '">\u25CF</span> ' + point.series.name + ': ' + convertFileSize(point.y) + '<br />';
                                return str;
                            }) : []
                    );
                    if (rs != null && rs != undefined && rs != "") return rs[0] + rs[1] + rs[2];
                    else return [];
                },
                shared: true
            },
            series: [{
                name: '<s:message code="dashboard.loggingData.count2"/>',
                type: 'column',
                yAxis: 1,
                data: logging
            },
                {
                    name: '<s:message code="dashboard.loggingData.attach.size"/>',
                    type: 'spline',
                    data: attach,
                    visible: visible,
                    showInLegend: visible,
                },

            ]
        });

    }

    function printChart3(dat) {
        var data = [];
        var tMax = [];
        var cols = [];
        var categories = [];

        if (dat.length == 0) {
            $('#sizeChart').html('<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data" width="100px;" height="100px" style="margin:auto; display:block; margin-top:50px;"> ');
            return false;
        } else {
            var max = 0;
            for (var i = 0; i < dat.length; i++) {
                var items = [];
                var year = dat[i].date.substring(0, 4);
                var month = dat[i].date.substring(4, 6);
                var day = dat[i].date.substring(6, 8);
                var formattedDate = year + '-' + month + '-' + day;
                items.push(formattedDate);

                items.push(Number(dat[i].bodySize));
                data.push(items);
                if (Number(dat[i].bodySize) > max) {
                    max = Number(dat[i].bodySize);
                }
                tMax.push(max);
            }
        }

        var max = tMax.reduce(function (a, b) {
            return Math.max(a, b);
        });
        var rotation = 40;
        // if ( chartxAxis2 == 'W' ) rotation = 0;
        $('#sizeChart').highcharts({
            chart: {
                type: 'line',
                options3d: {
                    enabled: true,
                    alpha: 0,
                    beta: 0,
                    viewDistance: 15,
                    depth: 40
                },
                marginTop: 25,
                marginRight: 45
            },
            title: {
                text: null
            },
            exporting: {enabled: false},
            credits: chartAPI.credits,
            xAxis: {
                type: 'category'
            },
            yAxis: {
                allowDecimals: false,
                min: 0,
                max: max,
                title: {
                    text: '',
                    rotation: 0
                }
            },
            legend: {
                enabled: false
            },
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.series.color + '">\u25CF</span> ' + convertFileSize(this.point.y);
                }

            },
            plotOptions: {},
            series: [{
                data: data,
                dataLabels: {
                    enabled: true,
                    color: '#000',
                    align: 'center',
                    y: 10, // 10 pixels down from the top
                    style: {
                        fontSize: '11px',
                        fontFamily: 'Gulim, Dotum, Helvetica'
                    },
                    formatter: function () {
                        return convertFileSize(this.point.y);
                    }
                }
            }]
        });
    }


    function getLoggingData() {
        ui.get({
            url: 'getLoggingData.xcn',
            success: function (data, total) {
                makeTableLoggingData(data.data);
                printChart2(data.data);
                getBodySize();
                getTodayTrafficData();
                getTrafficData();
            },
            error: function (status, message) {
                //ui.alertMsg(message);

            },
            complete: function () {

            }
        });
    }

    function getFileTopData() {
        ui.get({
            url: 'getTodayFilePerson.xcn',
            success: function (data, total) {
                filePerson(data);
                fileTop();
            },
            error: function (status, message) {
                //ui.alertMsg(message);

            },
            complete: function () {

            }
        });
    }

    function fileTop() {
        ui.get({
            url: 'getTodayFileTop.xcn',
            success: function (data, total) {

                let str = "";
                if (data.total == 0) {
                    str += '<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data" class="xcn_nodata"width="100px;" height="100px" style=" display: block;"> ';
                } else {

                    str += "<div><ul>";
                    for (let i = 0; i < 4; i++) {
                        let filesSize = getFormattedValue("size", data.fileSize[i]);
                        let filesType = getFormattedValue("type", data.fileType[i]);
                        let leFileName = data.fileName[i];
                        let fileName = getFormattedValue("name", leFileName);
                        str += "<li class='clicks' ' data-value='" + data.fileId[i] + "'>"
                        str += "<span class = 'num'>" + (i + 1) + "</span>";
                        str += "<p class='file blueBg'><span class='filename blue' style='max-width: 180px;'>" + fileName + "</span><span class='Volume'>" + filesSize + "</span></p>";
                        str += "</li>"
                    }
                    str += "</ul></div>";

                    str += "<div class='list'><ul>";
                    for (let i = 4; i < 10; i++) {
                        let leFileName = data.fileName[i];
                        let fileName = getFormattedValue("name", leFileName);
                        let filesSize = getFormattedValue("size", data.fileSize[i]);
                        let filesType = getFormattedValue("type", data.fileType[i]);
                        str += "<li class='clicks' ' data-value='" + data.fileId[i] + "'><span class='num'>" + (i + 1) + "</span>";
                        str += "<p><span class='filename'  style='max-width: 180px;'>" + leFileName + "</span>"
                        str += "<span class='righttext'>" + filesSize + "</span></p></li>"
                    }
                    str += "<ul><div>";
                }


                $('#bigFileTop').html(str);

            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {

            }
        });
    }

    function filePerson(data) {
        let str = "";
        if (data.total == 0) {
            str += '<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data" width="100px;" height="100px" class="xcn_nodata"style=" display: block;">';
            $('#FilePeople').html(str);
        } else {
            str += "<div class='teamList'><ul>";
            for (let i = 0; i < 4; i++) {
                let name = getFormattedValue("size", data.facet[i]);
                let names = getFormattedValue("size", name[0]);
                let bu = getFormattedValue("size", name[1]);
                let count = getFormattedValue("count", name[2]);
                let noName = getFormattedValue("size", name[3]);
                let nameId = name[3];


                str += "<li class='click2' data-value='" + nameId + "'><p class='num'>" + (i + 1) + "</p>";
                str += "<p><span class='name blue'>" + noName + "</span>";
                str += "<span class='team'>" + bu + "</span></p>";
                str += "<p class='teamnum'>";
                str += "<span class='name'>" + count + "</span>";
                str += "</p></li>"
            }
            str += "</ul></div>";
            str += "<div class='list'><ul>";
            for (let i = 4; i < 10; i++) {
                let name = getFormattedValue("ddd", data.facet[i]);
                let names = getFormattedValue("ddd", name[0]);
                let count = getFormattedValue("count", name[2]);
                let noName = getFormattedValue("size", name[3]);
                let nameId = name[3];
                str += "<li class='click2' data-value='" + nameId + "'><span class='num'>" + (i + 1) + "</span>";
                str += "<p><span class='name'>" + noName + "</span>";
                str += "<span class='righttext'>" + count + "</span></p></li>";
            }
            str += "</ul></div>"
            $('#FilePeople').html(str);
        }
    }

    function getFormattedValue(size, value) {
        if (size == "size") return (value === undefined || value === null) ? ' ' : value;
        else if (size == "count") return (value === undefined || value === null) ? ' ' : value.comma() + "<s:message code="common.msg.cnt"/>";
        else return (value === undefined || value === null) ? '-' : value;

    }


    function getTrafficData() {
        ui.get({
            url: 'getTrafficData.xcn',
            success: function (data, total) {
                printChartTraffic(data);

            },
            error: function (status, message) {

            },
            complete: function () {

            }
        });
    }

    function printChartTraffic(dat) {
        var data = [];
        var tMax = [];
        var cols = [];
        var categories = [];

        if (dat.length == 0) {
            $('#con02').html('<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data" width="100px;" height="100px" style ="margin:auto; display:block; margin-top:50px;"> ');
            return false;
        } else {
            var max = 0;
            for (var i = 0; i < dat.length; i++) {
                var items = [];
                items.push(dat[i].date);
                items.push(Number(dat[i].longNum));
                data.push(items);
                if (Number(dat[i].longNum) > max) {
                    max = Number(dat[i].longNum);
                }
                tMax.push(max);
            }
        }

        var max = tMax.reduce(function (a, b) {
            return Math.max(a, b);
        });
        var rotation = 40;
        // if ( chartxAxis2 == 'W' ) rotation = 0;
        $('#con02').highcharts({
            chart: {
                type: 'line',
                options3d: {
                    enabled: true,
                    alpha: 0,
                    beta: 0,
                    viewDistance: 15,
                    depth: 40
                },
                marginTop: 25,
                marginRight: 45
            },
            title: {
                text: null
            },
            exporting: {enabled: false},
            credits: chartAPI.credits,
            xAxis: {
                type: 'category'
            },
            yAxis: {
                allowDecimals: false,
                min: 0,
                max: max,
                title: {
                    text: '',
                    rotation: 0
                }
            },
            legend: {
                enabled: false
            },
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.series.color + '">\u25CF</span> ' + convertFileSize(this.point.y);
                }

            },
            plotOptions: {},
            series: [{
                data: data,
                dataLabels: {
                    enabled: true,
                    color: '#000',
                    align: 'center',
                    y: 10, // 10 pixels down from the top
                    style: {
                        fontSize: '11px',
                        fontFamily: 'Gulim, Dotum, Helvetica'
                    },
                    formatter: function () {
                        return convertFileSize(this.point.y);
                    }
                }
            }]
        });
    }


    function printChartTraffic2(dat) {
        var data = [];
        var tMax = [];
        var cols = [];
        var categories = [];

        if (dat.length == 0) {
            $('#con01').html('<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data" width="100px;" height="100px" style ="margin:auto; display:block; margin-top:50px;"> ');
            return false;
        } else {
            var max = 0;
            for (var i = 0; i < dat.length; i++) {
                var items = [];
                items.push(dat[i].date);
                items.push(Number(dat[i].longNum));
                data.push(items);
                if (Number(dat[i].longNum) > max) {
                    max = Number(dat[i].longNum);
                }
                tMax.push(max);
            }
        }

        var max = tMax.reduce(function (a, b) {
            return Math.max(a, b);
        });
        var rotation = 40;
        // if ( chartxAxis2 == 'W' ) rotation = 0;
        $('#con01').highcharts({
            chart: {
                type: 'column',
                marginTop: 5,
                marginBottom: 28,
                spacingBottom: 0
            },
            title: {
                text: null
            },
            exporting: {enabled: false},
            credits: chartAPI.credits,
            xAxis: {
                type: 'category'
            },
            yAxis: {
                allowDecimals: false,
                min: 0,
                max: max,
                title: {
                    text: '',
                    rotation: 0
                }
            },
            legend: {
                enabled: false
            },
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.series.color + '">\u25CF</span> ' + convertFileSize(this.point.y);
                }

            },
            plotOptions: {},
            series: [{
                data: data
            }]
        });
    }


    function getTodayTrafficData() {
        ui.get({
            url: 'getTodayTrafficData.xcn',
            success: function (data, total) {
                printChartTraffic2(data);

            },
            error: function (status, message) {

            },
            complete: function () {

            }
        });
    }


    function getBodySize() {

        ui.get({
            url: 'getBodySize.xcn',
            success: function (data, total) {
                makeTableSizeData(data.data);
                printChart3(data.data);
            },
            error: function (status, message) {
                //ui.alertMsg(message);

            },
            complete: function () {

            }
        });
    }


    function makeTableSizeData(data) {
        if (data.length == 0) {
            return;
        }
        var str = "<table class='mainTable'><tr>"
        str += "<th> 구분 </th>";
        for (var i = 0; i < data.length; i++) {
            var year = data[i].date.slice(0, 4);
            var month = data[i].date.slice(4, 6) - 1;
            var day = data[i].date.slice(6, 8);
            var dateObject = new Date(year, month, day);
            var formattedDate = dateObject.getFullYear() + "-" + padZero(dateObject.getMonth() + 1) + "-" + padZero(dateObject.getDate());
            str += "<th>" + formattedDate + "</th>";
        }
        str += "</tr><tr>";
        str += "<td> 용량 </td>";
        for (var i = 0; i < data.length; i++) {
            str += "<td>" + data[i].bodySizeStr + "</td>";
        }
        str += "</tr></table></div>"


        $('#sizeTable').html(str);
    }


    var chart = null;
    var chartxAxis;

    function printChart(dat) {
        var visible = true;
        if (systemArch == 'multiple' && adminType == 'M') visible = false;
        var categories = [];
        var logging = [];
        var attach = [];
        if (dat.length == 0) {
            $('#chartArea1').html('<s:message code="common.msg.nodata"/>');
            return false;
        } else {
            for (var i = 0; i < dat.length; i++) {
                categories.push(getDateFormatSize(dat[i].date));
                logging.push(Number(dat[i].logging));
                attach.push(dat[i].attach == undefined ? 0 : Number(dat[i].attach));
            }
        }

        var rotation = 40;
        if (chartxAxis == 'W') rotation = 0;
        $('#chartArea1').highcharts({
            chart: {
                zoomType: 'xy'
            },
            title: {
                text: ''
            },
            subtitle: {
                text: ''
            },
            exporting: {enabled: false},
            credits: chartAPI.credits,
            xAxis: [{
                categories: categories,
                crosshair: true
            }],
            yAxis: [{
                labels: {
                    format: '{value}',
                    style: {color: Highcharts.getOptions().colors[1]}
                },
                title: {
                    text: '',
                    style: {color: Highcharts.getOptions().colors[1]}
                }
            }, {
                title: {
                    text: '',
                    style: {color: Highcharts.getOptions().colors[0]}
                },
                labels: {
                    format: '{value}',
                    style: {color: Highcharts.getOptions().colors[0]}
                },
                opposite: true,
            }],
            tooltip: {
                formatter: function () {
                    var rs = ['<b>' + this.x + '</b><br />'].concat(
                        this.points ?
                            this.points.map(function (point) {
                                var str = '';
                                if (point.series.name == '<s:message code="dashboard.loggingData.count2"/>') {
                                    str += '<span style="color:' + point.series.color + '">\u25CF</span> ' + point.series.name + ': ' + point.y.comma() + '(<s:message code="common.msg.cnt"/>)<br />';
                                } else if (point.series.name == '<s:message code="dashboard.loggingData.attach.size"/>') str += '<span style="color:' + point.series.color + '">\u25CF</span> ' + point.series.name + ': ' + convertFileSize(point.y) + '<br />';
                                return str;
                            }) : []
                    );
                    if (rs != null && rs != undefined && rs != "") return rs[0] + rs[1] + rs[2];
                    else return [];
                },
                shared: true
            },
            series: [{
                name: '<s:message code="dashboard.loggingData.count2"/>',
                type: 'column',
                yAxis: 1,
                data: logging
            },
                {
                    name: '<s:message code="dashboard.loggingData.attach.size"/>',
                    type: 'spline',
                    data: attach,
                    visible: visible,
                    showInLegend: visible
                }]
        });

    }


    var isDefaultPage = false;

    function checkDefaultMenu() {
        var mainLink = $('.topMenuLi:eq(0) .topMenu').attr('href');
        if (menuKey == mainLink.split('=')[1]) {
            isDefaultPage = true;
        }
    }

    function getDefaultMenuKey() {
        //getDashBoardMenu.xcn
        ui.get({
            url: 'getDashBoardMenu.xcn',
            useYn: 'Y',
            defaultMenu: 'Y',
            success: function (data, total) {
                if (data.length > 0) {
                    location.href = '<c:url value="/ems/dashboard.do?menuKey="/>' + data[0].menuKey;
                } else {
                    alert('<s:message code="common.msg.connect.error"/>');
                }
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
            }
        });
    }

    function makePeriod(dashCondition) {
        dashCondition = JSON.parse(dashCondition);

        var startDtSelect = dashCondition.startDateSelect;
        var startTimeSelect = dashCondition.startTimeSelect;
        var endDtSelect = dashCondition.endDateSelect;
        var endTimeSelect = dashCondition.endTimeSelect;

        if (startDtSelect == '' || startDtSelect == undefined) return JSON.stringify(dashCondition);

        var startMinusDay = 0;
        var startMinusMouth = 0;
        var endMinusDay = 0;
        var endMinusMouth = 0;
        if (startDtSelect == 'Y') startMinusDay = 1;
        else if (startDtSelect == 'W') startMinusDay = 7;
        else if (startDtSelect == 'M') startMinusMouth = 1;

        if (endDtSelect == 'Y') endMinusDay = 1;
        else if (endDtSelect == 'W') endMinusDay = 7;
        else if (endDtSelect == 'M') endMinusMouth = 1;

        var dateObj = new Date();
        var startDate = new Date(dateObj.getFullYear(), dateObj.getMonth() - startMinusMouth, dateObj.getDate() - startMinusDay, startTimeSelect, 00, 00);
        var endDate = new Date(dateObj.getFullYear(), dateObj.getMonth() - endMinusMouth, dateObj.getDate() - endMinusDay, endTimeSelect, 59, 59);

        dashCondition.startDt = startDate.format('yyyymmddHHnnss');
        dashCondition.endDt = endDate.format('yyyymmddHHnnss');
        return JSON.stringify(dashCondition);
    }


    var contentData = [];

    function getDashBoardContent() {
        ui.get({
            url: 'getDashBoardContentList.xcn',
            useYn: 'Y',
            menuKey: menuKey,
            success: function (data, total) {
                rtnGetDashBoardContent(data);
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
            }
        });
    }

    var searchFlag;
    var listCnt = 0;

    function getDashBoardList() {
        if (searchFlag) return false;
        timeoutAllClear();

        searchFlag = true;
        ui.get({
            url: 'getDashBoardList.xcn',
            menuKey: menuKey,
            success: function (data, total) {
                listCnt = data.length;
                if (data.length == 0) {
                    if (loggingDataSettingVal != 'Y' && fileTopDataSettingVal != 'Y') $('#emptyDiv').show();
                    else $('#emptyDiv').hide();
                } else $('#emptyDiv').hide();
                dashboardGrid.loadGrid(data);

                getDashBoardContent();
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
                searchFlag = false;
            }
        });
    }

    function setConditionValStr(val, key) {
        if (val != null && val != '') return '■ ' + key + ' : ' + val.replaceAll('\\|', ',') + '<br />';
        return '';
    }

    function checkPeriod(startDateSelect, startTimeSelect, endDateSelect, endTimeSelect) {

    }

    /**
     *  조건 요약 출력
     */
    function printAlarmValStr(alarmCycle, alarmVal, rtnType) {
        var searchStr = '';
        var searchDateStr = '';
        if (alarmVal.startDateSelect == 'Y') searchDateStr += '<s:message code="condition.yesterday_str"/> ';
        else if (alarmVal.startDateSelect == 'T') searchDateStr += '<s:message code="condition.today_str"/> ';
        else if (alarmVal.startDateSelect == 'W') searchDateStr += '<s:message code="condition.sevenago"/> ';
        else if (alarmVal.startDateSelect == 'M') searchDateStr += '<s:message code="condition.month" arguments="1" argumentSeparator="|"/> ';
        searchDateStr += '<s:message code="condition.clock" arguments="'+alarmVal.startTimeSelect+'" />';
        searchDateStr += ' ~ ';
        if (alarmVal.startDateSelect == 'Y') searchDateStr += '<s:message code="condition.yesterday_str"/> ';
        else if (alarmVal.startDateSelect == 'T') searchDateStr += '<s:message code="condition.today_str"/> ';
        else if (alarmVal.startDateSelect == 'W') searchDateStr += '<s:message code="condition.sevenago"/> ';
        else if (alarmVal.startDateSelect == 'M') searchDateStr += '<s:message code="condition.month" arguments="1" argumentSeparator="|"/> ';
        searchDateStr += '<s:message code="condition.time" arguments="'+alarmVal.endTimeSelect+',59,59" />';

        if (alarmCycle != 'H') searchStr = setConditionValStr(searchDateStr, '<s:message code="condition.period"/>');
        else searchStr = setConditionValStr('<s:message code="mail.message.condition_info"/>', '<s:message code="condition.period"/>');

        if (alarmVal.searchStr != '') searchStr += setConditionValStr(alarmVal.searchStr, '<s:message code="condition.search_str"/>');

        if (alarmVal.searchField != '') searchStr += setConditionValStr(alarmVal.serviceFieldNm, '<s:message code="condition.field.search"/>');

        if (infoFeedbackConf == 'true' && infoFeedbackYn == 'Y') {
            if (alarmVal.infoType != '') searchStr += setConditionValStr(alarmVal.infoTypeNm, '<s:message code="condition.infotype"/>');
            if (alarmVal.feedbackType != '') searchStr += setConditionValStr(alarmVal.feedbackTypeNm, '<s:message code="condition.feedback"/>');
            if (alarmVal.probType != '') searchStr += setConditionValStr(alarmVal.probTypeNm, '<s:message code="condition.prob"/>');
        }

        var readYnMsg = '';
        if (alarmVal.readYn == 'Y') readYnMsg = '<s:message code="condition.read"/>';
        else if (alarmVal.readYn == 'N') readYnMsg = '<s:message code="condition.unread"/>';
        if (readYnMsg != '') searchStr += setConditionValStr(readYnMsg, '<s:message code="condition.isread"/>');

        var receiveSendMsg = '';
        if (alarmVal.receiveSend == 'O') receiveSendMsg = '<s:message code="condition.send"/>';
        else if (alarmVal.receiveSend == 'I') receiveSendMsg = '<s:message code="condition.receive"/>';
        if (receiveSendMsg != '') searchStr += setConditionValStr(receiveSendMsg, '<s:message code="condition.receive_send"/>');

        var ctimeWorkMsg = '';
        if (alarmVal.ctimeWork == 'W') ctimeWorkMsg = '<s:message code="condition.work"/>';
        else if (alarmVal.ctimeWork == 'R') ctimeWorkMsg = '<s:message code="condition.notwork"/>';
        if (ctimeWorkMsg != '') searchStr += setConditionValStr(ctimeWorkMsg, '<s:message code="condition.ctimework"/>');

        if (alarmVal.serviceType != '') searchStr += setConditionValStr(alarmVal.serviceTypeNm, '<s:message code="filterInfo.servicetype"/>');
        if (alarmVal.senders != '') searchStr += setConditionValStr(alarmVal.senders, '<s:message code="condition.sender"/>', alarmVal.senders_not);
        if (alarmVal.receivers != '') searchStr += setConditionValStr(alarmVal.receivers, '<s:message code="condition.recv"/>', alarmVal.receivers_not);

        if (alarmVal.rcvTo != '') searchStr += setConditionValStr(alarmVal.rcvTo, '<s:message code="condition.to"/>', alarmVal.rcvTo_not);
        if (alarmVal.rcvCc != '') searchStr += setConditionValStr(alarmVal.rcvCc, '<s:message code="condition.cc"/>', alarmVal.rcvCc_not);
        if (alarmVal.rcvBcc != '') searchStr += setConditionValStr(alarmVal.rcvBcc, '<s:message code="condition.bcc"/>', alarmVal.rcvBcc_not);
        if (alarmVal.rcvJikgub != '') searchStr += setConditionValStr(alarmVal.rcvJikgub, '<s:message code="condition.recv_jikgub"/>');
        if (alarmVal.allOfus != '') searchStr += setConditionValStr(alarmVal.allOfus, '<s:message code="condition.allofus"/>');

        if (alarmVal.busi != '') searchStr += setConditionValStr(alarmVal.busiNm, '<s:message code="common.org.busi"/>', alarmVal.busi_not);
        if (alarmVal.dept != '') searchStr += setConditionValStr(alarmVal.deptNm, '<s:message code="common.org.dept"/>', alarmVal.dept_not);
        if (alarmVal.userGroupSeq != '') searchStr += setConditionValStr(alarmVal.userGroupName, '<s:message code="userGroup.navi.title2"/>', alarmVal.userGroupSeq_not);
        if (alarmVal.interGroup != '') searchStr += setConditionValStr(alarmVal.interGroupNm, '<s:message code="interest.user"/>', alarmVal.interGroup_not);
        if (alarmVal.url != '') searchStr += setConditionValStr(alarmVal.url, 'URL', alarmVal.url_not);
        if (alarmVal.regexPattern != '') searchStr += setConditionValStr(alarmVal.regexPattern, '<s:message code="regexPattern.pattern"/>', alarmVal.regexPattern);

        var attachYnMsg = '';
        if (alarmVal.attachYn == 'Y') attachYnMsg = '<s:message code="condition.exist"/>';
        else if (alarmVal.attachYn == 'N') attachYnMsg = '<s:message code="condition.none"/>';
        if (attachYnMsg != '') searchStr += setConditionValStr(attachYnMsg, '<s:message code="condition.isattached"/>');
        if (alarmVal.attachVal != '') searchStr += setConditionValStr(alarmVal.attachVal, '<s:message code="consent.attach"/>', alarmVal.attachYn_not);

        var keywordYnMsg = '';
        if (alarmVal.keywordYn == 'Y') keywordYnMsg = '<s:message code="condition.exist"/>';
        else if (alarmVal.keywordYn == 'N') keywordYnMsg = '<s:message code="condition.none"/>';
        if (keywordYnMsg != '') searchStr += setConditionValStr(keywordYnMsg, '<s:message code="condition.iskeyword"/>');
        if (alarmVal.keywordVal != '') searchStr += setConditionValStr(alarmVal.keywordStr, '<s:message code="condition.keyword"/>', alarmVal.keywordYn_not);

        var epmsg = '';
        if (alarmVal.epmsgType != '') searchStr += setConditionValStr(alarmVal.epmsgType, '<s:message code="condition.epmsgType.list"/>');

        var regexpYnMsg = '';
        if (alarmVal.regexpYn == 'Y') regexpYnMsg = '<s:message code="condition.exist"/>';
        else if (alarmVal.regexpYn == 'N') regexpYnMsg = '<s:message code="condition.none"/>';
        if (regexpYnMsg != '') searchStr += setConditionValStr(regexpYnMsg, '<s:message code="condition.regexp.isdetect"/>');
        if (alarmVal.regexpVal != '') searchStr += setConditionValStr(alarmVal.regexpStr, '<s:message code="condition.regexp.detect"/>');

        if (alarmVal.drmYn == 'Y') searchStr += setConditionValStr('<s:message code="condition.exist"/>', 'DRM');
        else if (alarmVal.drmYn == 'N') searchStr += setConditionValStr('<s:message code="condition.none"/>', 'DRM');

        if (alarmVal.sctYn == 'Y') searchStr += setConditionValStr('<s:message code="condition.exist"/>', '<s:message code="condition.sct"/>');
        else if (alarmVal.sctYn == 'N') searchStr += setConditionValStr('<s:message code="condition.none"/>', '<s:message code="condition.sct"/>');

        var msgSize = '';
        if (alarmVal.sizeStartVal != '') {
            if (alarmVal.sizeOption == 'B') msgSize = convertFileSize(alarmVal.sizeStartVal) + ' ~ ' + convertFileSize(alarmVal.sizeEndVal);
            else {
                msgSize = convertFileSize(alarmVal.sizeStartVal);
                if (alarmVal.sizeOption == 'L') msgSize += '<s:message code="condition.over"/>';
                else if (alarmVal.sizeOption == 'S') msgSize += '<s:message code="condition.below"/>';
            }
        }
        var rtnMsg = '<s:message code="condition.size.all"/>';
        if (alarmVal.sizeType == 'B') rtnMsg = '<s:message code="condition.size.body"/>';
        else if (alarmVal.sizeType == 'A') rtnMsg = '<s:message code="condition.size.attach"/>';

        if (msgSize != '') searchStr += setConditionValStr(msgSize, rtnMsg);

        if (rtnType == undefined) $('#alarmValStr').val(searchStr);
        else return searchStr;
    }

    function rtnGetDashBoardContent(data) {
        contentData = data;
        var str = '';
        var lineCnt = 4;  // 2,3,4,6 가능
        for (var i = 0; i < data.length; i++) {
            var dashKey = data[i].dashKey;
            var dashName = data[i].dashName;
            var dashType = data[i].dashType;
            var dashMultiLeft = data[i].dashMultiLeft;
            var dashMultiRight = data[i].dashMultiRight;
            var dashChart = data[i].dashChart;
            var dashChartX = data[i].dashChartX;
            var dashChartY = data[i].dashChartY;
            var dashIcon = data[i].dashIcon;
            var dashColor = data[i].dashColor;
            var dashComment = data[i].dashComment;

            var dashTypeMsg = '';
            var dashChartMsg = '';
            if (dashType == 'S') dashTypeMsg = '<s:message code="custom.single"/>';
            else if (dashType == 'D') dashTypeMsg = '<s:message code="custom.double"/>';
            else if (dashType == 'C') {
                dashTypeMsg = '<s:message code="custom.chart"/>';
                if (dashChart == 'P') dashTypeMsg += '(<s:message code="custom.pieChart"/>)';
                else if (dashChart == 'L') dashTypeMsg += '(<s:message code="custom.lineChart"/>)';
                else if (dashChart == 'A') dashTypeMsg += '(<s:message code="custom.areaChart"/>)';
                else if (dashChart == 'B') dashTypeMsg += '(<s:message code="custom.barChart"/>)';
            } else if (dashType == 'L') dashTypeMsg = '<s:message code="custom.list"/>';


            if (i == 0 || i % lineCnt == 0) {
                var className = '';
                if (i == 0) className = 'active';
                str += '<div class="item ' + className + '">';
                str += '	<div class="row" style="margin-right: -5px;margin-left: -5px;">';
            }
            str += '		<div class="col-md-' + (12 / lineCnt) + '">';
            str += '			<a class="addDashboardContent" data-index="' + i + '" href="javascript:;">';

            str += '<div class="card card-1">';
            str += '	<h4><i class="' + data[i].dashIcon + '"></i>' + dashName + '</h4>';
            str += '	<p>' + dashComment + '</p>';
            str += '	<div>' + dashTypeMsg + '</div>';
            str += '	<div style="position: absolute; top: 16px; right: 22px;"><button type="button" class="form_btn03 conditionView" ><s:message code="dashboard.conditionView"/></button></div>';
            str += '</div>';

            str += '			</a>';
            str += '		</div>';

            if (i % lineCnt == (lineCnt - 1) || i == data.length - 1) {
                str += '	</div>';
                str += '</div>';
            }
        }
        if (data.length == 0) {
            $('#selectDashMenu .left').hide();
            $('#selectDashMenu .right').hide();

            str += '<div id="emptyDashboard" class="empty-dashboard-message">';
            str += '	<h3><s:message code="custom.msg.noData"/></h3>';
            str += '	<p><s:message code="custom.msg.newData"/></p>';
            str += '	<p style="margin:3px;"><a class="btn customBtn" href="<c:url value="/ems/dashboardSetup.do"/>"><s:message code="DATA_MONITOR.DASHBOARD_SETUP"/></a></p>';
            if (isDefaultPage) str += '	<p><a class="btn customBtn" href="javascript:;" id="addDefaultData"><s:message code="custom.addDefault"/></a></p>';
            str += '</div>';


        } else {
            $('#selectDashMenu .left').show();
            $('#selectDashMenu .right').show();
        }

        $('#dashboardHeaderArea').html(str);

        $('#selectDashMenu').carousel({
            pause: true,
            interval: false,
        });
    }

    function saveDashboardList(data) {
        ui.postJson({
            url: 'saveDashBoard.xcn',
            data: JSON.stringify(data),
            menuName: $('.navi').html(),
            menuKey: menuKey,
            success: function (data, total) {
                ui.alertMsg('<s:message code="common.msg.saved"/>');
                getDashBoardList();
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {

            }
        });
    }

    function getDashPosition(dashKey, dashType, dashChart) {
        var id = menuKey + '_' + dashKey;
        if (dashType == 'S') {
            return {x: 0, y: 0, width: 2, height: 2, minWidth: 2, minHeight: 2, maxWidth: 3, maxHeight: 2, id: id};
        } else if (dashType == 'D') {
            return {x: 0, y: 0, width: 3, height: 2, minWidth: 3, minHeight: 2, maxWidth: 4, maxHeight: 2, id: id};
        } else if (dashType == 'C') {
            if (dashChart == 'P') {
                return {x: 0, y: 0, width: 4, height: 4, minWidth: 4, minHeight: 4, maxWidth: 6, maxHeight: 6, id: id};
            } else {
                return {x: 0, y: 0, width: 5, height: 4, minWidth: 5, minHeight: 4, maxWidth: 10, maxHeight: 5, id: id};
            }
        } else if (dashType == 'L') {
            return {x: 0, y: 0, width: 5, height: 4, minWidth: 5, minHeight: 3, maxWidth: 6, maxHeight: 8, id: id};
        } else {
            return {x: 0, y: 0, width: 3, height: 2, id: id};
        }
    }


    $(document).on('click', '.clicks', function () {
        let data = $(this).data('value');
        openMessageBodyPop(data, data);
    });

    var dashCondition = {
        "searchStr": "",
        "searchField": "",
        "serviceType": "",
        "serviceTypeNm": "서비스 전체",
        "interGroup": "",
        "interGroupNm": "-관심 사용자 그룹-",
        "userGroupSeq": "",
        "userGroupName": "-사용자 그룹-",
        "startDateSelect": "T",
        "startTimeSelect": "00",
        "endDateSelect": "T",
        "endTimeSelect": "23",
        "senders": "",
        "receivers": "",
        "allOfus": "",
        "busi": "",
        "busiNm": "사업장 전체",
        "dept": "",
        "deptNm": "",
        "receiveSend": "",
        "ctimeWork": "",
        "readYn": "",
        "attachYn": "",
        "attachVal": "",
        "attachStr": "",
        "keywordYn": "",
        "keywordVal": "",
        "keywordStr": "",
        "regexpYn": "",
        "regexpVal": "",
        "regexpStr": "",
        "regexPattern":"",
        "drmYn": "",
        "sctYn": "",
        "sizeStartVal": "0",
        "sizeEndVal": "0",
        "sizeOption": "L",
        "sizeType": ""
    };

    $(document).on('click', '.click2', function () {
        let data = $(this).data('value');
        dashCondition.attachYn = "Y";
        dashCondition.senders = data;
        dashCondition.senders_upperCase = "Y";
        $('#conditionParam').val(makePeriod2(dashCondition));
        $('#getMessageInfo').submit();
    });

    function makePeriod2(dashCondition) {
        var startDtSelect = dashCondition.startDateSelect;
        var startTimeSelect = dashCondition.startTimeSelect;
        var endDtSelect = dashCondition.endDateSelect;
        var endTimeSelect = dashCondition.endTimeSelect;

        if (startDtSelect == '' || startDtSelect == undefined) return JSON.stringify(dashCondition);

        var startMinusDay = 0;
        var endMinusDay = 0;
        if (startDtSelect == 'Y') startMinusDay = 1;
        else if (startDtSelect == 'W') startMinusDay = 7;

        if (endDtSelect == 'Y') endMinusDay = 1;
        else if (endDtSelect == 'W') endMinusDay = 7;

        var dateObj = new Date();
        var startDate = new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate() - startMinusDay, startTimeSelect, 00, 00);
        var endDate = new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate() - endMinusDay, endTimeSelect, 59, 59);

        dashCondition.startDt = startDate.format('yyyymmddHHnnss');
        dashCondition.endDt = endDate.format('yyyymmddHHnnss');
        return JSON.stringify(dashCondition);
    }


    function getDashData() {
        return [];
        /* return [
				{x: 0, y: 0, width: 2, height: 2, minWidth: 2, minHeight: 2, maxWidth: 3, maxHeight: 2, id:'', html:$('#singleDataFormat').html()},
				{x: 3, y: 0, width: 3, height: 2, minWidth: 3, minHeight: 2, maxWidth: 4, maxHeight: 2, id:'', html:$('#dualDataFormat').html()},
				{x: 6, y: 0, width: 4, height: 4, minWidth: 4, minHeight: 4, maxWidth: 6, maxHeight: 6, id:'', html:$('#pieChartDataFormat').html()},
				{x: 0, y: 2, width: 5, height: 4, minWidth: 4, minHeight: 3, maxWidth: 6, maxHeight: 8, id:'', html:$('#listDataFormat').html()},
				{x: 0, y: 6, width: 5, height: 4, minWidth: 5, minHeight: 4, maxWidth: 10, maxHeight: 5, id:'', html:$('#lineChartDataFormat').html()},
				{x: 6, y: 8, width: 3, height: 2, id:'', html:$('#emptyDataFormat').html()}
			]; */
    }

    var dashboardGrid;

    function dashboardInit() {

        var options = {
            acceptWidgets: true,
            cellHeight: 60, //or 80 - default : 60
            verticalMargin: 5,
            alwaysShowResizeHandle: true,
            resizable: {
                autoHide: false,
                handles: 'e, s, w, se, sw' //n, e, s, w, ne, se, sw, nw, all
            }
        };

        $('#dashboardArea').gridstack(options);

        var grid = $('#dashboardArea').data('gridstack');

        dashboardGrid = new function () {
            var obj = this;

            this.serializedData;

            this.grid = $('#dashboardArea').data('gridstack');
            this.loadGrid = function (data) {
                this.serializedData = data;

                obj.grid.removeAll();
                var items = GridStackUI.Utils.sort(this.serializedData);

                _.each(items, function (node) {
                    obj.grid.addWidget(setDateHtml(node), node.x, node.y, node.width, node.height, null, node.minWidth, node.maxWidth, node.minHeight, node.maxHeight, node.id);
                }, this);

                grid.movable('.grid-stack-item', false);
                grid.resizable('.grid-stack-item', false);

                this.on('all');
                getData(data);
                return false;
            }.bind(this);

            this.on = function (id) {
                var hasFlag = false;

                this.serializedData = _.map($('#dashboardArea > .grid-stack-item:visible'), function (el) {
                    el = $(el);
                    var node = el.data('_gridstack_node');
                    var target = node.id;
                    if (node.id == id || id == 'all') {
                        var hei = el.height();
                        el.append('<div class="loading_div"><i class="fa fa-spinner fa-spin fa-3x fa-fw" style="margin-top:' + (hei / 2.5) + 'px"></i></div>');
                        $('.loading_div').css({
                            "position": "absolute",
                            "top": "0px",
                            "left": "10px",
                            "right": "10px",
                            "bottom": "0",
                            "background-color": "none",
                            "opacity": "0",
                            "z-index": "998",
                            "text-align": "center"
                        });
                    }
                }, this);

                return false;

            }.bind(this);

            this.off = function (id) {
                var hasFlag = false;

                this.serializedData = _.map($('#dashboardArea > .grid-stack-item:visible'), function (el) {
                    try {
                        el = $(el);
                        var node = el.data('_gridstack_node');
                        var target = node.id;
                        if (node.id == id || id == 'all') {
                            var obj = el.find('.loading_div');
                            obj.remove();
                        }
                    } catch (e) {
                    }
                }, this);

                return false;

            }.bind(this);


            this.saveGrid = function () {
                this.serializedData = _.map($('#dashboardArea > .grid-stack-item:visible'), function (el) {
                    el = $(el);
                    var node = el.data('_gridstack_node');
                    return {
                        x: node.x,
                        y: node.y,
                        width: node.width,
                        height: node.height,
                        minWidth: node.minWidth,
                        minHeight: node.minHeight,
                        maxWidth: node.maxWidth,
                        maxHeight: node.maxHeight,
                        id: node.id,
                        dashKey: el.find('.gridValues').attr('data-dashKey')
                    };
                }, this);

                saveDashboardList(this.serializedData);
                return false;

            }.bind(this);

            this.clearGrid = function () {
                this.grid.removeAll();
                return false;
            }.bind(this);

            this.addWidget = function (node) {
                this.grid.addWidget(node.html, node.x, node.y, node.width, node.height, true, node.minWidth, node.maxWidth, node.minHeight, node.maxHeight, node.id);
                return false;
            };

            this.deleteWidget = function (item) {
                this.grid.removeWidget(item);
                return false;
            };

            getLoggingDataSetting();
            getFileDataSetting();

            getDashBoardList();
        };

        $('#dashboardArea').on('change', function (event, items) {
            console.log("change!!!!!!!!!!")
        });

        $('#dashboardArea').on('gsresizestop', function (event, elem) {
            console.log("resize end!!!!!!!!!!")
        });

        $(document).on('click', '.customClose', function (event, elem) {
            dashboardGrid.deleteWidget($(this).parents('.grid-stack-item'));
        });

    }

    function setDateHtml(node) {
        var dashCondition = JSON.parse(makePeriod(node.dashCondition));
        var startDtSelect = dashCondition.startDateSelect;
        var endDtSelect = dashCondition.endDateSelect;

        var startDt = dashCondition.startDt;
        var endDt = dashCondition.endDt;
        var startDtStr = startDt.substring(0, 4) + '-' + startDt.substring(4, 6) + '-' + startDt.substring(6, 8) + ' ' + startDt.substring(8, 10) + ':' + startDt.substring(10, 12) + ':' + startDt.substring(12, startDt.length);
        var endDtStr = endDt.substring(0, 4) + '-' + endDt.substring(4, 6) + '-' + endDt.substring(6, 8) + ' ' + endDt.substring(8, 10) + ':' + endDt.substring(10, 12) + ':' + endDt.substring(12, startDt.length);
        var dateMsg = '<s:message code="custom.today"/>';
        if (startDtSelect == 'Y') { //시작: 어제
            dateMsg = '<s:message code="custom.yesterday"/>';
            if (endDtSelect == 'T') dateMsg += '~<s:message code="custom.today"/>';
        } else if (startDtSelect == 'W') { // 시작 : 7일전
            dateMsg = '<s:message code="condition.sevenago"/>';
            if (endDtSelect == 'Y') dateMsg += '~<s:message code="condition.yesterday_str"/>';
            else if (endDtSelect == 'T') dateMsg += '~<s:message code="custom.today"/>';
        } else if (startDtSelect == 'M') { //시작 : 한달전
            dateMsg = '<s:message code="condition.month" arguments="1" argumentSeparator="|"/>';
            if (endDtSelect == 'Y') dateMsg += '~<s:message code="condition.yesterday_str"/>';
            else if (endDtSelect == 'T') dateMsg += '~<s:message code="custom.today"/>';
            else if (endDtSelect == 'W') dateMsg += '~<s:message code="condition.sevenago"/>';
        }

        var obj = $(node.html);
        obj.find('.termDtStr').attr('title', startDtStr + ' ~ ' + endDtStr).text(dateMsg);

        return $('<div>').append(obj.clone()).html();
    }


    function getData(data) {
        for (var i = 0; i < data.length; i++) {
            getSearchData(i, data[i]);
        }
    }

    var timeoutArr = [];

    function getSearchData(i, obj) {
        timeout_clear(timeoutArr[i]);

        var plusTime = i * 200;
        setTimeout(function () {
            ui.get({
                url: 'getDashBoardContentData.xcn',
                dashKey: obj.dashKey,
                success: function (data, total) {
                    rtnGetSearchData(data.data, obj);

                    timeoutArr[i] = setTimeout(function () {
                        getSearchData(i, obj);
                    }, 3600000);

                },
                error: function (status, message) {
                },
                complete: function () {
                }
            });
        }, plusTime);
    }

    function rtnGetSearchData(data, obj) {
        if (obj.dashType == 'S') {
            $('[data-gs-id=' + obj.id + ']').find('.rightValue').text(nvn(data.rightValue)).append("<span class='tit13'></span>");
        } else if (obj.dashType == 'D') {
            $('[data-gs-id=' + obj.id + ']').find('.rightValue').text(nvn(data.rightValue));
            $('[data-gs-id=' + obj.id + ']').find('.leftValue').text(nvn(data.leftValue));
        } else if (obj.dashType == 'C') {
            if (obj.dashChart == 'P') setPieChart($('[data-gs-id=' + obj.id + '] .dashChartArea'), data.chartData);
            else {
                var rtnType = '';
                if (obj.dashChart == 'L') {
                    rtnType = 'line';
                } else if (obj.dashChart == 'A') {
                    rtnType = 'area';
                } else if (obj.dashChart == 'B') {
                    rtnType = 'column'
                }
                setChart($('[data-gs-id=' + obj.id + '] .dashChartArea'), data.chartData, rtnType);
                if ($('[data-gs-id=' + obj.id + '] .dashChartArea').data('data-charttype') != 'P') {
                    var chartXPosition = $('[data-gs-id=' + obj.id + '] .dashChartArea').find('.highcharts-yaxis-title').attr('x');
                    $('[data-gs-id=' + obj.id + '] .dashChartArea').find('.highcharts-yaxis-title').attr('x', chartXPosition - 10);
                }
            }
        } else if (obj.dashType == 'L') {
            setDashDataList($('[data-gs-id=' + obj.id + '] .dashTableTbody'), data.edc, $('[data-gs-id=' + obj.id + ']').attr('data-gs-width'), $('[data-gs-id=' + obj.id + ']').attr('data-gs-height'));
        }
        dashboardGrid.off(obj.id);
    }

    function setPieChart(obj, data) {
        if ($(obj).highcharts() != undefined) {
            $(obj).html('');
        }
        $(obj).highcharts({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: 'pie'
            },
            exporting: {
                enabled: false
            },
            credits: chartAPI.credits,
            title: {
                text: ''
            },
            subtitle: {
                text: ''
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.y:,.0f}<s:message code="common.msg.cnt"/> ({point.percentage:.1f}%)</b>'
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
                },
                series: {
                    animation: {
                        duration: 1000
                    }
                }
            },
            series: [{
                name: '<s:message code="dashboard.rate"/>',
                colorByPoint: true,
                data: data
            }]
        });
    }

    function setChart(obj, data, type) {
        if ($(obj).highcharts() != undefined) {
            $(obj).html('');
        }


        if (data == null) {
            return $(obj).html('<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data" class="xcn_nodata" width="110px;" height="110px"> ');
        }

        var dlength = data.length;
        var allDataZeroSig = 0;

        for (var i = 0; i < dlength; i++) {
            if (data[i].y == null) {
                data[i].y = 0;
                allDataZeroSig++;
            }
        }

        $(obj).highcharts({
            chart: {
                type: type,
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
                    x: 20,
                    y: (dlength == allDataZeroSig) ? -60 : undefined,
                }, gridLineWidth: 0
            },
            yAxis: {
                labels: {
                    formatter: function () {
                        var label = this.axis.defaultLabelFormatter.call(this);
                        if (label < 1) {
                            return Highcharts.numberFormat(this.value, 0);
                        } else {
                            if (/^[0-9]{4}$/.test(label)) return Highcharts.numberFormat(this.value, 0);
                            return label;
                        }
                    }
                },
                type: 'line',
                min: 0,
                title: {
                    text: '',
                    x: -20,
                    y: 20,
                    rotation: 0
                }
            },
            legend: {
                enabled: false
            },
            tooltip: {
                pointFormat: '<s:message code="dashboard.collect.data_count"/> : <b>{point.y:,.0f} (<s:message code="common.msg.cnt"/>)</b>'
            },
            plotOptions: {
                series: {
                    animation: {
                        duration: 1000
                    }
                }
            },
            series: [{
                name: 'chart',
                data: data,
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

    function setDashDataList(obj, data, width, height) {
        var dataLength = height * 2 - 3;
        if (dataLength > 13) dataLength = 13;

        var subjectWidth = 25;
        if (width == 6) subjectWidth = 40;

        var str = '';
        if (data != null) {
            for (var i = 0; i < data.emass.length; i++) {
                if (i == dataLength) break;

                str += '<tr>';
                str += '	<td><i class="bodyOpenBtn fa fa-window-restore" aria-hidden="true" data-msgid="' + data.emass[i].msgid + '"></i></td>';

                var ctime = data.emass[i].ctimeFormat;
                var spCtime = ctime.substring(ctime.indexOf('-') + 1, ctime.length);
                str += '	<td>' + spCtime + '</td>';

                var svcNm = data.emass[i].svcNm;
                var dpSvcNm = svcNm.substring(0, svcNm.indexOf('>'));
                str += '	<td>' + dpSvcNm + '</td>';

                var subject = data.emass[i].subject;
                var addData = '';
                if (subject.length > subjectWidth) addData = '...';
                str += '	<td title="' + subject + '">' + (data.emass[i].subject).substring(0, subjectWidth) + addData + '</td>';
                str += '</tr>';
            }

            if (data.emass.length == 0) {
                str += '<tr>';
                str += '<td colspan="4" style="text-align:center;">';
                str += '<s:message code="common.msg.nodata"/>';
                str += '</td>';
                str += '</tr>';
            }
        }


        $(obj).html(str);
    }

    function timeout_clear(setTime) {
        if (setTime != undefined) clearTimeout(setTime);
        return undefined;
    }

    function timeoutAllClear() {
        for (var i = 0; i < timeoutArr.length; i++) {
            timeout_clear(timeoutArr[i]);
        }

    }

</script>
</head>

<div id="conditionViewDiv">
	<div style="height:30px;background-color:#1C64D3;color:#fff;padding-left:10px;line-height:30px;font-weight: bold;cursor:default;">
		<div style="float:left;width:120px;">
			<s:message code="dashboard.conditionView"/>
		</div>
	</div>
	<div style="width:100%;padding:10px 10px 10px 10px;">
		<div>
			<div id="conditionViewContent"></div>
		</div>
	</div>
</div>

<div class="modal" id="loggingDataPop" tabindex="-1" role="dialog" aria-labelledby="loggingDataModal" data-backdrop="static">
	<div class="modal-content">
		<div class="modalHead">
			<h2><s:message code="dashboard.loggingData.show"/></h2>
			<span class="close" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalCon">
			<div class="modalbody" style="height:120px;">
				<div class="col-sm-12">
					<span class="help-block m-b-none"><s:message code="dashboard.msessage.setting"/></span>
				</div>
				<div class="col-sm-12">
					<select id="loggingDataUseYn" class="form-control m-b">
						<option value="Y"><s:message code="dashboardMenu.use"/></option>
						<option value="N"><s:message code="dashboardMenu.unuse"/></option>
					</select>
				</div>
			</div>
			<div class="modalfooter">
				<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
				<button type="button" class="pop_btn02" accesskey="S" id="loggingDataSaveBtn"><s:message code="common.msg.change"/></button>
			</div>
		</div>
	</div>
</div>

<div class="modal" id="fileTopDataPop" tabindex="-1" role="dialog" aria-labelledby="loggingDataModal" data-backdrop="static">
	<div class="modal-content">
		<div class="modalHead">
			<h2><s:message code="dashboard.fileTop.show"/></h2>
			<span class="close" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalCon">
			<div class="modalbody" style="height:120px;">
				<div class="col-sm-12">
					<span class="help-block m-b-none"><s:message code="dashboard.fileTop.show"/></span>
				</div>
				<div class="col-sm-12">
					<select id="fileTopDataUseYn" class="form-control m-b">
						<option value="Y"><s:message code="dashboardMenu.use"/></option>
						<option value="N"><s:message code="dashboardMenu.unuse"/></option>
					</select>
				</div>
			</div>
			<div class="modalfooter">
				<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
				<button type="button" class="pop_btn02" accesskey="S" id="fileTopDataSaveBtn"><s:message code="common.msg.change"/></button>
			</div>
		</div>
	</div>
</div>


<div class="modal fade" id="fileSendPop" tabindex="-1" role="dialog" aria-labelledby="fileSendModal">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<form method="post" id="fileSendPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="dashboard.setting.trans_file_size"/></h3>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label for="fileSendPopInput" class="control-label"><s:message code="dashboard.file_size"/> (<s:message
								code="stat.traffic.unit2"/>)</label>
						<input type="text" class="form-control" name="fileSize" id="fileSendPopInput"
						       placeholder="<s:message code="dashboard.file_size"/>" required onkeydown="return preventEnter(event);">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="fileSendSaveBtn"><s:message
							code="common.msg.save"/></button>
				</div>
			</form>
		</div>
	</div>
</div>

<div id="xcn_container">
	<div class="dashboardBtnArea" style="z-index:1000;">
		<div class="btn-group">
			<button type="button" class="btn btn-sm form_btn05 dropdown-toggle" data-toggle="dropdown" style="margin-top:18px;">
				<s:message code="custom.work"/> <span class="caret"></span>
			</button>
			<ul class="dropdown-menu dropdown-menu-right" role="menu" style="min-width:120px;">
				<li><a href="javascript:;" id="editDashboardBtn"><span class="fa fa-file-text-o" style="font-size:16px"></span>&nbsp;<s:message
						code="dashboardSetup.addModify"/></a></li>
				<li><a href="javascript:;" id="menuDefaultSetupBtn"><span class="fa fa-file-text-o" style="font-size:16px"></span>&nbsp;<s:message
						code="dashboardMenu.defaultMenu"/></a></li>
				<li><a href="javascript:;" id="menuLoggingBtn"><span class="fa fa-file-text-o" style="font-size:16px"></span>&nbsp;<s:message
						code="dashboard.loggingData.show"/></a></li>
				<li><a href="javascript:;" id="fileTopBtn"><span class="fa fa-file-text-o" style="font-size:16px"></span>&nbsp;<s:message
						code="dashboard.fileTop.show"/></a></li>
				<li class="dropdown-divider"></li>
				<li><a href="javascript:;" id="setupDashboardBtn"><span class="glyphicon glyphicon-th-list"></span>&nbsp;<s:message
						code="DATA_MONITOR.DASHBOARD_SETUP"/></a></li>
			</ul>
		</div>
	</div>
	<div class="dashboardHeader" style="display:none; z-index: 999; position: absolute; top: 16px; left: 0px; right: 0px;">
		<div class="col-xs-12">
			<button type="button" class="form_btn01_02" style="position: absolute;right:162px;top:2px;" id="saveDashboardBtn"><s:message
					code="common.msg.save"/></button>
			<button type="button" class="form_btn04" style="position: absolute;right:90px;top:2px;" id="cancleDashboardBtn">
				<s:message code="common.msg.close"/>
			</button>
		</div>
		<div class="col-xs-12" style="margin-top: 30px;">
			<div class="carousel slide media-carousel" id="selectDashMenu">
				<div class="carousel-inner" id="dashboardHeaderArea"></div>
				<a data-slide="prev" href="#selectDashMenu" class="left carousel-control"
				   style="display:none; font-size: 16px; color: #fff;">&#10094;</a>
				<a data-slide="next" href="#selectDashMenu" class="right carousel-control" style="display:none; font-size: 16px; color: #fff;">&#10095;</a>
			</div>
		</div>
	</div>
	<!-- 대시보드 전체 -->
	<div class="searchArea">
		<div class="mat8">
			<div id="emptyDiv">
				<div class="empty-dashboard-message grayBg02">
					<h2>
						<img src="<c:url value="/img/icon/ico_info.png"/>" alt="!">
						<span class="mat8 fb800 dis_block"><s:message code="custom.msg.empty"/></span>
					</h2>
					<div class="mat24">
						<p><s:message code="custom.msg.insertInfo"/></p>
						<p class="mat8"><a href="<c:url value="/ems/dashboardSetup.do"/>"><s:message code="DATA_MONITOR.DASHBOARD_SETUP"/></a>
							<s:message code="custom.msg.insertInfo1"/></p>
						<p class="mat24">
							<button class="form_btn05 mat8" href="javascript:;" id="editDashboardBtnPop"><s:message code="custom.add"/></button>
						</p>
					</div>
				</div>

			</div>


			<%--			일별 로깅 데이터 정보--%>
			<div id="dashboardInfo" style="display: none">
				<div id="xcn_mainWrap2">
					<div class="container" style="display: flex; justify-content: space-between;">
						<div style="left-padding: 0; width: 50%; height: 350px; min-height: 350px; min-width: 685px;">
							<div class="text_tab">
								<span class="tablinks2" onclick="openCity3(event, 'con03')" id="defaultOpen3"><s:message
										code="dashboard.loggingData.count"/></span>
								<span class="bar"></span>
								<span class="tablinks2" onclick="openCity3(event, 'con04')"><s:message code="dashboard.Data.size"/></span>
							</div>
							<div id="con03" class="text_tabcontent2">
								<div class="h200" id="loggingChart"></div>
								<div id="loggingCount"></div>
							</div>

							<div id="con04" class="text_tabcontent2">
								<div class="h200" id="sizeChart"></div>
								<div id="sizeTable"></div>
							</div>
						</div>

						<div style=" width: 48%; ">
							<div class="text_tab">
								<span class="tablinks" onclick="openCity2(event, 'con01')" id="defaultOpen2"><s:message
										code="dashboard.msg.todayTraffic"/></span>
								<span class="bar"></span>
								<span class="tablinks" onclick="openCity2(event, 'con02')"><s:message code="dashboard.msg.weekTraffic"/></span>
							</div>

							<div id="con01" class="text_tabcontent" style="min-height: 310px ">
								<div id="todayTraffic"></div>
							</div>

							<div id="con02" class="text_tabcontent" style="min-height: 310px ">
								<!-- <div id="weekTraffic"></div> -->
							</div>
						</div>
					</div>

				</div>
			</div>


			<div id="dashboardInfo2" style="display: none">
				<div id="xcn_mainWrap" style="display: block; background-color: transparent">

						<div class="right" style="background-color: transparent">
							<div class="m_grapha mat32" style="margin-top: 0px;">
								<div>
									<h3><s:message code="dashboard.fileSizeTop"/></h3>
									<div class="bigtop10" id="bigFileTop" style="  box-sizing: border-box; width: 100%">
									</div>
								</div>
								<%--		대용량 파일 TOP 10 끝--%>
								<%--			파일 다 사용자 TOP 10--%>
								<div>
									<h3><s:message code="dashboard.fileSendTop"/></h3>
									<div class="filetop10" id="FilePeople" style=" box-sizing: border-box; width: 100%">
									</div>
								</div>
							</div>
						</div>
				</div>
			</div>

				<div>
					<!-- 대시보드 박스 -->
					<div id="xcn_mainWrap_new">
						<div id="dashboardArea" class="grid-stack xcn_con_area">
						</div>
					</div>
					<!-- //대시보드 -->
				</div>

			</div>
		</div>
		<!-- //대시보드 -->
	</div>
	<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>
	<form method="post" id="getMessageInfo" action="<c:url value="/ems/message.do"/>" target="_self">
		<input type="hidden" name="conditionParam" id="conditionParam"/>
	</form>

	<script>
        document.addEventListener("DOMContentLoaded", function () {
            document.getElementById("defaultOpen3").click();
        });

        function openCity3(evt, cityName) {
            var i, tabcontent, tablinks;

            tabcontent = document.getElementsByClassName("text_tabcontent2");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }

            tablinks = document.getElementsByClassName("tablinks2");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].classList.remove("active");
            }
            document.getElementById(cityName).style.display = "block";
            evt.currentTarget.classList.add("active");
        }
	</script>

	<script>
        document.addEventListener("DOMContentLoaded", function () {
            document.getElementById("defaultOpen2").click();
        });

        function openCity2(evt, cityName) {
            var i, tabcontent, tablinks;

            tabcontent = document.getElementsByClassName("text_tabcontent");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }

            tablinks = document.getElementsByClassName("tablinks");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].classList.remove("active");
            }

            document.getElementById(cityName).style.display = "block";
            evt.currentTarget.classList.add("active");
        }
	</script>

	<%@ include file="./dashboardContent.jsp" %>
