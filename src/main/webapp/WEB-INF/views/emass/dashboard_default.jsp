<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<link rel="stylesheet" href="<c:url value="/css/dashboard.css"/>"/>
<style>



	.filename{
		display: block;
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		max-width: 50%!important;
	}

	.name{
		display: block;
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		max-width: 92% !important;
	}

	.files :hover{
		cursor: pointer;
		text-decoration: underline;
	}

	th {
		text-align: center;
	}
	.click P:hover{
		cursor: pointer;
		text-decoration: underline;
	}

	.filename:hover{
		cursor: pointer;
		text-decoration: underline;
	}

	.name:hover{
		cursor: pointer;
		text-decoration: underline;
	}
	.righttext:hover{
		cursor: pointer;
		text-decoration: underline;
	}
</style>
<title>EMASS AI - Dashboard</title>
<script type="text/javascript">



    Highcharts.setOptions({
        chart: {
            type: 'column',
            marginTop: 25
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
        "drmYn": "",
        "sctYn": "",
        "sizeStartVal": "0",
        "sizeEndVal": "0",
        "sizeOption": "L",
        "sizeType": ""
    };
    $(document).ready(function() {
        function makePeriod(dashCondition) {
            dashCondition = JSON.parse(dashCondition);
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


        getTodayKeywordDetection();
        getTodayRiskBehavior();
        getTodayPatternPrivacy();
        getFileSendTotal();
        getServiceDataLogging();
        getFileTop();
        getTodayNotWork();
        getTodayDataStatus();
        getTodayFilePerson();
        getLoggingData();
        getBodySize();
        getTrafficData();
        getTodayTrafficData();
        TodayPassportData();
        getTodayDriveData();
        TodayForeignerData();
        TodaySecurityData();
        TodayCardNumberData();
        getExtensionModulation();


        function TodayPassportData() {
            ui.get({
                url: 'getTodayPattern.xcn',
                patternType:'pi_amount.pi_PN',
                success: function (data, total) {
                    $('#TodayPasswordTotalCnt').html(data.total + "<span class='tit13'></span>");
                },
                error: function (status, message) {
                },
                complete: function () {
                }
            });
        }

        function TodayForeignerData() {
            ui.get({
                url: 'getTodayPattern.xcn',
                patternType:'pi_amount.pi_FN',
                success: function (data, total) {
                    $('#TodayForeignerTotalCnt').html(data.total + " <span class='tit13'></span>");
                },
                error: function (status, message) {
                },
                complete: function () {

                }
            });
        }

        function TodaySecurityData() {
            ui.get({
                url: 'getTodayPattern.xcn',
                patternType:'pi_amount.pi_SN',
                success: function (data, total) {
                    $('#TodaySecurityTotalCnt').html(data.total + " <span class='tit13'></span>");
                },
                error: function (status, message) {
                },
                complete: function () {

                }
            });
        }

        function TodayCardNumberData() {
            ui.get({
                url: 'getTodayPattern.xcn',
                patternType:'pi_amount.pi_CN',
                success: function (data, total) {
                    $('#TodayCardNumberTotalCnt').html(data.total + " <span class='tit13'></span>");
                },
                error: function (status, message) {
                },
                complete: function () {

                }
            });
        }


        function getTodayDriveData() {
            ui.get({
                url: 'getTodayPattern.xcn',
                patternType:'pi_amount.pi_DN',
                success: function (data, total) {
                    $('#TodayDriveTotalCnt').html(data.total + "<span class='tit13'></span>");
                },
                error: function (status, message) {

                },
                complete: function () {

                }
            });
        }

        function getExtensionModulation() {

            ui.get({
                url: 'getTodayPattern.xcn',
                patternType:'pi_amount.pi_EC',
                success: function (data, total) {
                    $('#TodayExtensionModulationTotalCnt').html(data.total + " <span class='tit13'></span>");
                },
                error: function (status, message) {

                },
                complete: function () {

                }
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


        function printChartTraffic2(dat) {
            var data = [];
            var tMax = [];
            var cols = [];
            var categories = [];

            if (dat.length == 0) {
                $('#con01').html('<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data" width="100px;" height="100px" style ="margin:auto; display:block; margin-top:16px;"> ');
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



        function printChartTraffic(dat) {
            var data = [];
            var tMax = [];
            var cols = [];
            var categories = [];

            if (dat.length == 0) {
                $('#con02').html('<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data" width="100px;" height="100px" style ="margin:auto; display:block; margin-top:16px;"> ');
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
            str += "<th>  </th>";
            for (var i = 0; i < data.length; i++) {
                var year = data[i].date.slice(0, 4);
                var month = data[i].date.slice(4, 6) - 1;
                var day = data[i].date.slice(6, 8);
                var dateObject = new Date(year, month, day);
                var formattedDate = dateObject.getFullYear() + "-" + padZero(dateObject.getMonth() + 1) + "-" + padZero(dateObject.getDate());
                str += "<th>" + formattedDate + "</th>";
            }
            str += "</tr><tr>";
            str += "<td> <s:message code="analysis.freedom.ui.size"/> </td>";
            for (var i = 0; i < data.length; i++) {
                str += "<td>" + data[i].bodySizeStr + "</td>";
            }
            str += "</tr></table></div>"


            $('#sizeTable').html(str);
        }


        function getLoggingData() {
            ui.get({
                url: 'getLoggingData.xcn',
                success: function (data, total) {
                    makeTableLoggingData(data.data);
                    printChart2(data.data);
                },
                error: function (status, message) {
                    //ui.alertMsg(message);

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
            str += "<th>  </th>";
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
        //금일 파일 다사용자 TOP 10
        function getTodayFilePerson() {

            ui.get({
                url: 'getTodayFilePerson.xcn',
                searchStr: '',
                success: function (data, total) {
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
                            let noName = getFormattedValue("size",name[3]);
                            let nameId = name[3];


                            str += "<li class='click2' data-value='" + nameId + "'><p class='num'>" + (i + 1) + "</p>";
                            str+="<p><span class='name blue' title='"+noName+"'>" + noName + "</span>";
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
                            let noName = getFormattedValue("size",name[3]);
                            let nameId = name[3];
                            str += "<li class='click2' data-value='" + nameId + "'><span class='num'>" + (i + 1) + "</span>";
                            str += "<p><span class='name' title='"+noName+"'>" + noName + "</span>";
                            str += "<span class='righttext'>" + count + "</span></p></li>";
                        }
                        str += "</ul></div>"
                        $('#FilePeople').html(str);
                    }


                },
                error: function (status, message) {
                    //ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        function getFormattedValue(size, value) {
            if (size == "size") return (value === undefined || value === null) ? ' ' : value;
            else if (size == "count") return (value === undefined || value === null) ? ' ' : value.comma();
            else return (value === undefined || value === null) ? '-' : value;

        }


        // 금일 예약어 합계

        function getTodayKeywordDetection() {

            ui.get({
                url: 'getTodayKeywordDetection.xcn',
                searchStr: '',
                success: function (data, total) {

                    try {
                        $('#TodayKeywordTotalCnt').html(data.total + "<span class='tit13'></span>");
                        // off('keyword.message.count');
                    } catch (e) {
                    }
                },
                error: function (status, message) {
                    //ui.alertMsg(message);
                },
                complete: function () {

                }
            });
        }

        //금일 비업무시간 건수
        function getTodayNotWork() {
            ui.get({
                url: 'getTodayNotWork.xcn',
                searchStr: '',
                success: function (data, total) {
                    try {
                        $('#todayNotWork').html(data.total + "<span class='tit13'></span>");
                        // off('riskBehavior.message.count');
                    } catch (e) {
                    }
                },
                error: function (status, message) {
                    //ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        //금일 위험행위 메세지 건수
        function getTodayRiskBehavior() {
            ui.get({
                url: 'getTodayRiskBehavior.xcn',
                searchStr: '',
                success: function (data, total) {
                    try {
                        $('#getTodayRiskTotalCnt').html(data.total + "<span class='tit13'></span>");
                        // off('riskBehavior.message.count');
                    } catch (e) {
                    }
                },
                error: function (status, message) {
                    //ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        //금일 개인정보 메시지
        function getTodayPatternPrivacy() {

            ui.get({
                url: 'getTodayPatternPrivacy.xcn',
                searchStr: '',
                success: function (data, total) {
                    $('#TodayPatternPrivacyTotalCnt').html(data.total + " <span class='tit13'></span>");
                },
                error: function (status, message) {
                    //ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }


        //파일 top10
        function getFileTop() {
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
                            str += "<p class='file blueBg' style='min-width: 140px;'><span class='filename blue' title='"+fileName+"'>" + fileName + "</span><span class='Volume'>" + filesSize + "</span></p>";
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
                            str += "<p><span class='filename' title='"+fileName+"'>" + fileName + "</span>"
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

        function generateFileList(startIndex, endIndex, fileSizeArray, fileTypeArray) {
            let listStr = "";
            if (startIndex == 0) listStr += "<div><ul>";
            else listStr += "<div class='list'><ul>"
            for (let i = startIndex; i < endIndex; i++) {
                let filesSize = getFormattedValue("size", fileSizeArray[i]);
                let filesType = getFormattedValue("type", fileTypeArray[i]);

                listStr += "<li>";
                listStr += "<span class='num'>" + (i + 1) + "</span>";
                listStr += "<p><span style='width: 10px'>" + filesType + "</span>";
                listStr += "&nbsp; &nbsp; &nbsp;"
                listStr += "<span class='righttext'>" + filesSize + "</span></p>";
                listStr += "</li>";
            }


            listStr += "</ul></div>";

            return listStr;
        }


        //금일 1MB 이상 파일전송
        function getFileSendTotal() {
            ui.get({
                url: 'getFileSendTotal.xcn',
                success: function (data, total) {
                    $('#TodayfileSendTotalCnt').html(data.total + " <span class='tit13'></span>");
                },
                error: function (status, message) {
                    //ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        function areAllValuesZero(arr) {
            for (const item of arr) {
                if (item[1] !== 0) {
                    return false; // 만약 0이 아닌 값이 있다면 false 반환
                }
            }
            return true; // 모든 값이 0일 경우 true 반환
        }

        //서비스 타입 별 수집 건수(그룹웨어), 금일 서비스별 데이터 수집 비율
        function getServiceDataLogging() {
            ui.get({
                url: 'getServiceDataLogging.xcn',
                success: function (data, total) {
                    var todayGroupWareSum = 0;
                    for (var i = 0; i < data.facet.length; i++) {
                        if (data.facet[i][0] == "그룹웨어") {
                            todayGroupWareSum = data.facet[i][1];
                            break;
                        }
                    }
                    $('#todayGroupWareSum').html(todayGroupWareSum + " <span class='tit13'></span>");

                    if (areAllValuesZero(data.facet))  $('#svcDataChart').html('<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data" width="150px;" height="150px" style="margin: auto; display: block;"> ');
                    else printChart(data.facet);

                },
                error: function (status, message) {
                    //ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }



        var chart2 = null;
        var chartxAxis2;

        function printChart3(dat) {
            var data = [];
            var tMax = [];
            var cols = [];
            var categories = [];

            if (dat.length == 0) {
                $('#sizeChart').html('<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data"class ="xcn_nodata" width="100px;" height="100px" style="display: block;"> ');
                return false;
            }
            else {
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


        var chart = null;
        var chartxAxis;

        function printChart2(dat) {
            var visible = true;
            // if(systemArch == 'multiple' && adminType == 'M') visible = false;

            var categories = [];
            var logging = [];
            var attach = [];
            var attachStr = [];
            if (dat.length == 0) {
                $('#loggingChart').html('<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data" width="100px;" height="100px" class="xcn_nodata"style=" display: block;">');
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


        var chart = null;

        function printChart(data) {
            $('#svcDataChart').html('');

            if (data.length == 0) {
                $('#svcDataChart').html('<img src="' + '<c:url value="/img/icon/img_nodata.png"/>' + '" alt="No Data" width="100px;" height="100px"> ');
                return;
            }
            $('#svcDataChart').highcharts({
                exporting: {
                    enabled: false
                },
                credits: chartAPI.credits,
                title: {
                    text: ''
                },
                xAxis: {
                    type: 'category',
                },
                yAxis: {
                    type: 'logarithmic',
                    min: 1,
                    title: {
                        text: '',
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

        $(document).on('click', '.clicks', function () {
            let data = $(this).data('value');
            openMessageBodyPop('', data);
        });

        $(document).on('click', '.click2', function () {
            let data = $(this).data('value');
            dashCondition.attachYn = "Y";
            dashCondition.senders = data;
            dashCondition.senders_upperCase = "Y";
            $('#conditionParam').val(makePeriod2(dashCondition));
            $('#getMessageInfo').submit();
        });


        $(document).on('click', '.files', function () {
            var size = $(this).data('value'); // 범위
            var rowKey = $(this).data('row-key').toUpperCase(); //종류
            if (rowKey == 'XLSX' || rowKey == 'DOC') {
                dashCondition.attachStr = "MS-OFFICE";
            } else if (rowKey == 'PDF') {
                dashCondition.attachStr = "PDF"
            } else if (rowKey == 'JPG' || rowKey == 'GIF' || rowKey == 'PNG') {
                dashCondition.attachStr = "그림"
            }
            dashCondition.sizeStartVal = '' + (size * 1024 * 1024);
            dashCondition.sizeOption = "B";
            dashCondition.attachYn = "Y";
            dashCondition.sizeType = "T";
            dashCondition.attachVal = rowKey;
            if (size == 0) {
                dashCondition.sizeOption = "S";
                dashCondition.sizeStartVal = ''+(10*1024 * 1024);
                dashCondition.sizeEndVal = '';
            } else if (size == 201) {
                dashCondition.sizeOption = "L";
                dashCondition.sizeStartVal = '' + (201 * 1024 *1024);
                dashCondition.sizeEndVal = "";
            } else if (size == 11) {
                dashCondition.sizeEndVal = '' + (50 * 1024 *1024);
            } else {
                dashCondition.sizeEndVal = '' + ((size+49) * 1024 * 1024);
            }
            $('#conditionParam').val(makePeriod2(dashCondition));
            $('#getMessageInfo').submit();

        });


        $(document).on('click', '.click P', function () {
            var dat = $(this).parent().data('value');
            if (dat == 'reserved') {
                dashCondition.keywordYn = "Y";
            } else if (dat == 'groupWare') {
                dashCondition.serviceType = "EBD,EBB,EAA,EMM,EMB,EWS,EPU,ESC,EMF,EMU";
                dashCondition.serviceTypeNm = "게시, 게시판, 결재, 메일, 모바일, 웹서비스, 일반, 일정 명함, 파일 다운로드, 기타";
            } else if (dat == 'work') {
                dashCondition.ctimeWork = "R";
            } else if (dat == 'danger') {
                dashCondition.regexpYn = "Y";
                dashCondition.regexpVal = "EC%L@1|EF%L@1|ID%L@1";
                dashCondition.regexpStr = "확장자 변조 파일(1건 이상),암호화 파일(1건 이상),송수신자 동일아이디(1건 이상)";
            } else if (dat == 'file') {
                dashCondition.sizeType="A";
                dashCondition.sizeOption = "L";
                dashCondition.sizeStartVal = ''+(1024*1024);
            } else if (dat == 'person') {
                dashCondition.regexpYn = "Y";
                dashCondition.regexpVal = "MN%L@1|CN%L@1|AN%L@1|SN%L@1|CRN%L@1|DN%L@1|FN%L@1|PN%L@1|SSN%L@1|BRN%L@1|CPN%L@1|MCN%L@1";
                dashCondition.regexpStr = "휴대전화번호(1건 이상),카드번호(1건 이상),주소(1건 이상),주민번호(1건 이상),자동차 등록 번호(1건 이상),운전면허 번호(1건 이상),외국인 등록번호(1건 이상),여권번호(1건 이상),사회 보장번호(1건 이상),사업자 등록번호(1건 이상), 법인 등록번호(1건 이상),MAC 주소(1건 이상)";
            } else if (dat == 'passport') {
                dashCondition.regexpYn = "Y";
                dashCondition.regexpVal = "PN%L@1"
                dashCondition.regexpStr = "여권번호(1건 이상)"
            } else if (dat == 'drive') {
                dashCondition.regexpYn = "Y";
                dashCondition.regexpVal = "DN%L@1"
                dashCondition.regexpStr = "운전면허 번호(1건 이상)"
            } else if (dat == 'foreigner') {
                dashCondition.regexpYn = "Y";
                dashCondition.regexpVal = "FN%L@1"
                dashCondition.regexpStr = "외국인 등록번호(1건 이상)"
            } else if (dat == 'social') {
                dashCondition.regexpYn = "Y";
                dashCondition.regexpVal = "SN%L@1"
                dashCondition.regexpStr = "주민번호(1건 이상)"
            } else if (dat == 'card') {
                dashCondition.regexpYn = "Y";
                dashCondition.regexpVal = "CN%L@1"
                dashCondition.regexpStr = "카드번호(1건 이상)"
            } else if (dat == 'extension') {
                dashCondition.regexpYn = "Y";
                dashCondition.regexpVal = "EC%L@1"
                dashCondition.regexpStr = "확장자 변조 파일(1건 이상)"
            }

            $('#conditionParam').val(makePeriod2(dashCondition));
            $('#getMessageInfo').submit();

        });
    });
    //금일 첨부파일 수집 현황
    function getTodayDataStatus(rowSearchkey) {
        var max = Number.MAX_SAFE_INTEGER;
        ui.get({
            url: 'getTodayDataStatus.xcn',
            range: "0,11534336,52428800,1065025536,1585446912,2113929216,2147483647",
            searchStr: '',
            success: function (data, total) {
                if (rowSearchkey == null) rowSearchkey = "xlsx";
                getTodayFileList(data, rowSearchkey);

            },
            error: function (status, message) {
                //ui.alertMsg(message);

            },
            complete: function () {

            }
        });
    }



    function getTodayFileList(data, rowSearchkey) {
        let array = [0, 0, 0, 0, 0, 0];
        let arrayStr = ["~10MB", "~50MB", "~100MB", "~150MB", "~200MB", "201MB~"]
        let arrays = ["0","11","51","101","151","201"];
        let targetKey;
        if (data.pivotData) {
            // 여기에 쿼리 쓰기

            for (var i = 0; i < data.pivotData.length; i++) {
                if (data.pivotData[i].rowKey == rowSearchkey) {
                    targetKey = data.pivotData[i];
                    break;
                }
            }
        }else targetKey = 0;

        for (const key in targetKey) {

            // console.log("key: "+key);
            if (!isNaN(parseInt(key))) {
                const numericKey = parseFloat(key);
                if (numericKey ==  0) {
                    array[0] += targetKey[key];
                } else if (numericKey == 11534336) {
                    array[1] += targetKey[key];
                } else if (numericKey == 52428800) {
                    array[2] += targetKey[key];
                } else if (numericKey == 1065025536) {
                    array[3] += targetKey[key];
                }  else if (numericKey == 1585446912) {
                    array[4] += targetKey[key];
                } else {
                    array[5] += targetKey[key];
                }
            }
        }

        var str = "<div class='tabcontent'>";
        str += "<ul>";
        for (let i = 0; i < 6; i++) {
            str += "<li class='files' data-row-key='" + rowSearchkey + "' data-value='" + arrays[i] + "'><p>";
            str += arrayStr[i]
            str += "<span>" + array[i].comma() + "</span>";
            str += "</p></li>"
        }
        str += "</ul>";
        str += "</div>";
        $('#dataStatus').html(str);
    }



</script>


<div id="xcn_mainWrap">
	<%--			대시보드 왼쪽 리스트들--%>
	<div class="left">

		<%--				금일 데이터 수집 건수--%>
		<div class="m_chartArea">
			<div>
				<h3><s:message code="dashboard.todayData_count"/>
				</h3>
				<%--				*****	여기에 select 넣기--%>
				<div class="mainlist">
					<div class="blueBg bornone click" data-value="reserved">
						<span class="tit01"><s:message code="dashboard.keywordSum"/></span>
						<p id="TodayKeywordTotalCnt">-
						</p>
					</div>
					<div class="greenBg bornone click" data-value="groupWare">
						<span class="tit02"><s:message code="common.svc.groupware"/> <s:message code="analysis.freedom.ui.data"/> </span>
						<p id="todayGroupWareSum">-
					</div>
					<div class="yellowBg bornone click" data-value="work">
						<span class="tit03"><s:message code="condition.notwork"/> <s:message code="analysis.freedom.ui.data"/></span>
						<p id="todayNotWork">-
					</div>
					<div class="redBg bornone click" data-value="danger">
						<span class="tit04"><s:message code="dashboard.msg.regexp_count.danger"/> <s:message code="analysis.freedom.ui.data"/></span>
						<p id="getTodayRiskTotalCnt">-
					</div>
					<div class="grayBg bornone click" data-value="file">
						<span class="tit05"><s:message code="dashboard.msg.over_msg" arguments="1"/></span>
						<p id="TodayfileSendTotalCnt">-
					</div>
					<div class="blueBg bornone click" data-value="person">
						<span class="tit06"><s:message code="dashboard.msg.regexp_count"/></span>
						<p id="TodayPatternPrivacyTotalCnt">-
					</div>
				</div>
			</div>
		</div>

		<form method="post" id="getMessageInfo" action="<c:url value="/ems/message.do"/>" target="_self" >
			<input type="hidden" name="conditionParam" id="conditionParam" />
		</form>

		<%--금일 데이터 수집 건수 끝 ~~ --%>
		<%--				금일 패턴 수집 건수--%>

		<div class="m_chartArea">
			<div>
				<h3><s:message code="dashboard.todaayPatternCount"/></h3>
				<div class="mainlist">
					<div class="click" data-value="passport">
						<span class="tit07" ><s:message code="bodyview.pn"/></span>
						<p class="blue" id="TodayPasswordTotalCnt">-</p>
					</div>
					<div class="click" data-value="drive">
						<span class="tit08"><s:message code="bodyview.dn"/></span>
						<p class="blue" id="TodayDriveTotalCnt">-</p>
					</div>
					<div class="click" data-value="foreigner">
						<span class="tit09"><s:message code="bodyview.fn"/></span>
						<p class="blue" id="TodayForeignerTotalCnt">-</p>
					</div>
					<div class="click" data-value="social">
						<span class="tit10"><s:message code="bodyview.sn"/></span>
						<p class="blue" id="TodaySecurityTotalCnt">-</p>
					</div>
					<div class="click" data-value="card">
						<span class="tit11"><s:message code="bodyview.cn"/></span>
						<p class="blue" id="TodayCardNumberTotalCnt">-</p>
					</div>
					<div class="click" data-value="extension">
						<span class="tit12"><s:message code="bodyview.ec"/></span>
						<p class="blue" id="TodayExtensionModulationTotalCnt">-</p>
					</div>
				</div>
			</div>
		</div>
		<%--				금일 패턴 수집 건수 끝!!--%>
		<%--			금일 서비스별 데이터 수집 비율 시작--%>
		<div class="m_grapha">
			<div class="graphaBox click" data-value="service">
				<h3><s:message code="dashboard.msg.serviceRate"/></h3>
				<div class="bordd" id="svcDataChart" style="display: flex;justify-content: center; align-items: center">
				</div>
			</div>
			<%--			금일 서비스별 데이터 수집 비율 끝!!--%>

			<%--			금일 첨부파일 수집 현황 시작!!--%>
			<div class="graphaBox">
				<h3><s:message code="dashboard.msg.todayFileType"/></h3>
				<%--				<div class="bordd"  style="display: flex;justify-content: center; align-items: center">--%>
				<div class="bordd" style=" min-width: 400px; box-sizing: border-box; width: 100%">
					<div class="main_tab">
						<button class="tablink excel" onclick="openCity('xlsx', this, '#268770')" id="defaultOpen">EXCEL</button>
						<button class="tablink word" onclick="openCity('doc', this, '#3770C3')">DOC</button>
						<button class="tablink pdf" onclick="openCity('pdf', this, '#E7443A')">PDF</button>
						<button class="tablink jpg" onclick="openCity('jpg', this, '#9A52D2')">JPG</button>
						<button class="tablink gif" onclick="openCity('gif', this, '#EA8323')">GIF</button>
						<button class="tablink png" onclick="openCity('png', this, '#268770')">PNG</button>

						<%--						<button class="tablink exe" onclick="openCity('exe', this, '#B7433B')">EXE</button>--%>
						<%--						<button class="tablink html" onclick="openCity('html', this, '#EA8323')">HTML</button>
												<button class="tablink java" onclick="openCity('java', this, '#9A52D2')">JAVA</button>--%>
						<!-- 배경 컬러 코드
						 회색:#777777
						 초록:#268770
						 청록:#0F97B5
						 보라:#9A52D2
						 분홍:#E33E83
						 빨강:#E7443A
						 자주:#B7433B
						 파랑:#3770C3
						 연두:#3B9A45
						 주황:#EA8323
						 -->
					</div>
					<div id="dataStatus">
					</div>
				</div>
			</div>
			<%--			금일 첨부파일 수집 현황 끝--%>
		</div>
	</div>
	<%--	왼쪽 끝--
	<%--	오른쪽 시작--%>
	<div class="right">
		<div >
			<%--			금일 트래픽 추이, 종류 시작--%>
			<div class="text_tab">
				<span class="tablinks" onclick="openCity2(event, 'con01')" id="defaultOpen2"><s:message code="dashboard.msg.todayTraffic"/></span>
				<span class="bar"></span>
				<span class="tablinks" onclick="openCity2(event, 'con02')"><s:message code="dashboard.msg.weekTraffic"/></span>
			</div>

			<div id="con01" class="text_tabcontent">
				<div id="todayTraffic"></div>
			</div>

			<div id="con02" class="text_tabcontent" >
				<%--				<div id="weekTraffic"></div>--%>
			</div>
		</div>
		<%--			금일 트래픽 추이, 종류 끝--%>
		<%--		일별 용량, 로컬 데이터 정보 시작--%>
		<div>
			<div class="text_tab mat32">
				<span class="tablinks2" onclick="openCity3(event, 'con03')" id="defaultOpen3"><s:message code="dashboard.loggingData.count"/></span>
				<span class="bar"></span>
				<span class="tablinks2" onclick="openCity3(event, 'con04')"><s:message code="dashboard.Data.size"/></span>
			</div>
			<div id="con03" class="text_tabcontent2">
				<div class="h200" id="loggingChart" ></div>
				<div id="loggingCount"></div>
			</div>

			<div id="con04" class="text_tabcontent2">
				<div class="h200" id="sizeChart" ></div>
				<div id="sizeTable"></div>
			</div>
		</div>
		<%--		일별 용량, 로컬 데이터 정보 끝--%>
		<%--		대용량 파일 TOP 10 시작--%>
		<div class="m_grapha mat32">
			<div>
				<h3><s:message code="dashboard.fileSizeTop"/></h3>
				<div class="bigtop10" id="bigFileTop" style=" " >
				</div>
			</div>
			<%--		대용량 파일 TOP 10 끝--%>
			<%--			파일 다 사용자 TOP 10--%>
			<div>
				<h3><s:message code="dashboard.fileSendTop"/></h3>
				<div class="filetop10" id="FilePeople"  style="" >
				</div>
			</div>

		</div>
	</div>

</div>


<script>
    function openCity(cityName, elmnt, color) {
        var i, tabcontent, tablink;
        tabcontent = document.getElementsByClassName("tabcontent");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablink");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].style.backgroundColor = "#f5f5f5";
            tablinks[i].style.color = "black";
        }
        elmnt.style.backgroundColor = color;
        elmnt.style.color = "white";
        getTodayDataStatus(cityName);
    }

    document.addEventListener("DOMContentLoaded", function () {
        document.getElementById("defaultOpen").click();
    });
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
