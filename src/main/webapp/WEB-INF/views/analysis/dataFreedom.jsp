<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>

<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker-analysis.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/colorbrewer.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>

<style>
	.zero-clipboard {
		position: relative;
	}


	.btn-popover {
		z-index: 999999999;
		text-align: center;
	}

	.btn-popover .glyphicon {
		font-size: 16px;
	}

	.btn--message-popover {
		position: absolute;
		top: 0;
		right: 0;
		text-align: center;
		font-size: 14px;
		margin-right: 20px;
	}

	.popover {
		z-index: 998;
	}

	#termsPopover .popover {
		min-width: 700px;
		width: 700px;
		z-index: 99999;
	}

	#columnPopover .popover {
		min-width: 500px;
		width: 500px;
	}

	#dataPopover .popover {
		min-width: 700px;
		width: 700px;
	}

	.messageList {
		position: absolute;
		min-height: 350px;
		z-index: 1000;
		width: 100%;
		height: 350px;
		left: 0px;
		top: 1px;
	}

	/*
	 * Grid 관련 css
	 */
	.panel {
		border-top-left-radius: 0;
	}

	#messageListGrid .slick-viewport {
		position: absolute !important;
	}

</style>
<s:message code="common.datescript" var="ko"/>
<%@ include file="./analysisBase.jsp" %>
<script>
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


    $(document).ready(function () {
        serviceTypeMap = new HashMap();
        getServiceType(terms);
        columns.add();
        datas.add();

        $('#termsPopover [data-toggle="popover"]').popover({
            html: true,
            content: function () {
                return $('#popover-content-terms').html();
            }
        });
        $('#columnPopover [data-toggle="popover"]').popover({
            html: true,
            content: function () {
                return $('#popover-content-column').html();
            }
        });
        $('#dataPopover [data-toggle="popover"]').popover({
            html: true,
            content: function () {
                return $('#popover-content-data').html();
            }
        });


        $('body').on('click', function (e) {
            $('[data-toggle="popover"]').each(function () {
                //the 'is' for buttons that trigger popups
                //the 'has' for icons within a button that triggers a popup
                if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
                    $(this).popover('hide');
                }
            });
        });

        $('#maxChartCount').text(maxChartCount);

        $(".numberinput").forceNumeric();

        $('#messageListCount .caret').change(function () {
            grid.pageSize = Number($('#messageListCount .caret').attr('val'));
            selectMessageList();
        });

        colInit();

    });
</script>
<div class="searchArea" style="margin:0;">
	<form id="frm">
		<div class="chartArea04">
			<!--LIST-->
			<div>
				<div class="lineTit">
					<h3>LIST</h3>
					<span id="termsPopover" class="btn-popover">
					<a tabindex="0" class="black02" role="button" data-toggle="popover" data-container="#termsPopover" data-html="true"
					   data-placement="bottom" title="<s:message code="analysis.freedom.ui.dest"/>"><span
							class="glyphicon glyphicon-question-sign"></span></a>
					</span>
				</div>
				<div id="termsData"></div>
			</div>
			<!--//LIST-->
			<!--컬럼-->
			<div>
				<div class="lineTit">
					<h3><s:message code="analysis.freedom.ui.column"/></h3>
					<span id="columnPopover" class="btn-popover">
						<a tabindex="0" class="black02" role="button" data-toggle="popover" data-container="#columnPopover" data-html="true"
						   data-placement="bottom" title="<s:message code="analysis.freedom.ui.columnexam"/>"><span
								class="glyphicon glyphicon-question-sign"></span></a>
					</span>
					<div id="popover-content-terms" class="hide">
						<div style="padding-left:10px;">
							<div>1. <s:message code="analysis.freedom.ui.exam18"/></div>
							<div class="form-inline">
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""><s:message code="common.org.user"/></option></select>
								<select class="form-control"><option value="">=</option></select>
								<span><input type="text" class="form-control" style="width: 250px;" value="<s:message code="analysis.freedom.ui.man1"/>" /></span>
								<select class="form-control"><option value=""></option></select>
							</div>
						</div>
						<div style="padding-top:10px;padding-left:10px;">
							<div>2. <s:message code="analysis.freedom.ui.exam19"/></div>
							<div class="form-inline">
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""><s:message code="common.org.user"/></option></select>
								<select class="form-control"><option value="">IN</option></select>
								<span><input type="text" class="form-control" style="width: 250px;" value="<s:message code="analysis.freedom.ui.man1"/>,<s:message code="analysis.freedom.ui.man2"/>" /></span>
								<select class="form-control"><option value=""></option></select>
							</div>
						</div>
						<div style="padding-top:10px;padding-left:10px;">
							<div>3. <s:message code="analysis.freedom.ui.exam20"/></div>
							<div class="form-inline">
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""><s:message code="analysis.freedom.ui.mailtitle"/></option></select>
								<select class="form-control"><option value="">IN</option></select>
								<span><input type="text" class="form-control" style="width: 250px;" value="<s:message code="analysis.freedom.ui.exam2"/>" /></span>
								<select class="form-control"><option value=""></option></select>
							</div>
						</div>
						<div style="padding-top:10px;padding-left:10px;">
							<div>4. <s:message code="analysis.freedom.ui.exam21"/></div>
							<div class="form-inline">
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""><s:message code="analysis.freedom.ui.isattach"/></option></select>
								<select class="form-control"><option value="">=</option></select>
								<span><input type="text" class="form-control" style="width: 250px;" value="Y" /></span>
								<select class="form-control"><option value=""></option></select>
							</div>
						</div>
						<div style="padding-top:10px;padding-left:10px;">
							<div>5. <s:message code="analysis.freedom.ui.exam22"/></div>
							<div class="form-inline">
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""><s:message code="analysis.freedom.ui.size"/></option></select>
								<select class="form-control"><option value="">>=</option></select>
								<span><input type="text" class="form-control" style="width: 250px;" value="1" /></span>
								<select class="form-control"><option value=""></option></select>
							</div>
						</div>
						<div style="padding-top:10px;padding-left:10px;">
							<div>6. <s:message code="analysis.freedom.ui.exam23"/></div>
							<div class="form-inline">
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value="">(</option></select>
								<select class="form-control"><option value=""><s:message code="analysis.freedom.ui.size"/></option></select>
								<select class="form-control"><option value="">>=</option></select>
								<span><input type="text" class="form-control" style="width: 250px;" value="1" /></span>
								<select class="form-control"><option value=""></option></select>
							</div>
							<div class="form-inline">
								<select class="form-control"><option value="">OR</option></select>
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""><s:message code="analysis.freedom.ui.size"/></option></select>
								<select class="form-control"><option value=""><=</option></select>
								<span><input type="text" class="form-control" style="width: 250px;" value="10" /></span>
								<select class="form-control"><option value="">)</option></select>
							</div>
							<div class="form-inline">
								<select class="form-control"><option value="">AND</option></select>
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""><s:message code="analysis.freedom.ui.mailto"/></option></select>
								<select class="form-control"><option value=""><=</option></select>
								<span><input type="text" class="form-control" style="width: 250px;" value="user@test.com" /></span>
								<select class="form-control"><option value=""></option></select>
							</div>
						</div>
						<div style="padding-top:10px;padding-left:10px;">
							<div>7. <s:message code="analysis.freedom.ui.exam24"/></div>
							<div class="form-inline">
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""></option></select>
								<select class="form-control"><option value=""><s:message code="condition.date"/></option></select>
								<select class="form-control"><option value="">=</option></select>
								<span><input type="text" class="form-control" style="width: 100px;" value="2016-06-01" /> ~ <input type="text" class="form-control" style="width: 100px;" value="2016-06-15" /></span>
								<select class="form-control"><option value=""></option></select>
							</div>
						</div>
					</div>

				</div>
				<div id="columnData"></div>

				<div class="zero-clipboard" style="margin-top: 16px;">
					<div id="popover-content-column" class="hide">
						<div style="padding-left:10px;">
							<ul>
								<li><s:message code="analysis.freedom.ui.exam7"/> <span style="color:red;" id="maxChartCount"></span><s:message
										code="analysis.freedom.ui.exam8"/></li>
								<li><s:message code="analysis.freedom.ui.exam9"/></li>
								<li><s:message code="analysis.freedom.ui.exam10"/></li>
							</ul>
						</div>
						<div style="padding-top:10px;padding-left:10px;">
							<div>1. <font color="red"><s:message code="analysis.freedom.ui.exam11"/></font> <s:message
									code="analysis.freedom.ui.exam12"/></div>
							<div class="form-inline">
								<select class="form-control">
									<option value=""><s:message code="analysis.freedom.ui.exam14"/></option>
								</select>
							</div>
						</div>
						<div style="padding-top:10px;padding-left:10px;">
							<div>2. <font color="red"><s:message code="analysis.freedom.ui.exam13"/></font> <s:message
									code="analysis.freedom.ui.exam12"/></div>
							<div class="form-inline">
								<select class="form-control">
									<option value=""><s:message code="common.org.dept"/></option>
								</select>
								<select class="form-control">
									<option value=""><s:message code="common.org.jikgub"/></option>
								</select>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--//컬럼-->
			<!--데이터-->
			<div>
				<div class="lineTit">
					<h3><s:message code="analysis.freedom.ui.data"/></h3>
					<span id="dataPopover" class="btn-popover">
						<a tabindex="0" class="black02" role="button" data-toggle="popover" data-container="#dataPopover" data-html="true"
						   data-placement="bottom" title="<s:message code="analysis.freedom.ui.exam15"/>"><span
								class="glyphicon glyphicon-question-sign"></span></a>
					</span>
				</div>
				<div id="dataData"></div>
				<div class="zero-clipboard" style="margin-top: 16px;">
					<div id="popover-content-data" class="hide">
						<div style="padding-left:10px;">
							<ul style="padding-left:15px;">
								<li><s:message code="analysis.freedom.ui.exam16"/></li>
								<li><s:message code="analysis.freedom.ui.exam17"/></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<!--//데이터-->
			<!--차트종류-->
			<div>
				<h3><s:message code="analysis.freedom.ui.chartkind"/></h3>
				<div class="pt8">
					<img src="<c:url value="/img/icon/img_chart_area_on.png"/>" width="40" height="40" style="cursor:pointer;"
					     onclick="javascript:search('area');"/>
					<img src="<c:url value="/img/icon/img_chart_line_on.png"/>" width="40" height="40" style="cursor:pointer;"
					     onclick="javascript:search('line');"/>
					<img src="<c:url value="/img/icon/img_chart_bar_on.png"/>" width="40" height="40" style="cursor:pointer;"
					     onclick="javascript:search('column');"/>
					<img src="<c:url value="/img/icon/img_chart_pie_on.png"/>" width="40" height="40" style="cursor:pointer;"
					     onclick="javascript:search('pie');"/>
				</div>
			</div>
			<!--//차트종류-->
		</div>
	</form>
	<!-- old
		<div class="boxArea">
			<div class="content_body">
				<div class="panel panel-default" style="min-height:600px;">
					<div class="panel-body" style="height: 100%;padding:0px;">
						<div id="chartDiv" style="height: 100%; padding: 30px;"><s:message code="analysis.freedom.ui.result"/></div>
					</div>
				</div>
			</div>
		</div>-->
	<!-- //old -->
</div>
<div class="boxArea">
	<div class="content_body" style="padding-bottom:16px;">
		<div class="panel panel-default" style="min-height:550px;">
			<div class="panel-body" style="height: 100%;padding:0px;">
				<div id="chartDiv" style="height: 100%; padding: 30px;"><s:message code="analysis.freedom.ui.result"/></div>
			</div>
		</div>
	</div>
</div>
<div id="chartHtml" style="display:none;">
	<div id="dataChart"></div>
</div>

<div id="termsHtml" style="display:none;">
	<div id="termsContentId" class="termsContent" style="margin-bottom:10px;">
		<select id="andOr" name="andOr" onchange="javascirpt:SearchTrue();">
			<option value="and">AND</option>
			<option value="or">OR</option>
		</select>
		<select id="beforePparen" name="beforePparen" onchange="javascirpt:SearchTrue();">
			<option value=""></option>
			<option value="(">(</option>
		</select>
		<select id="termsColumn" name="termsColumn" onchange="javascript:SearchTrue();terms.colChange(this.value, tabIdx, termsIdx);">
			<option value="userid"><s:message code="condition.usrid"/></option>
			<option value="ctime"><s:message code="condition.date"/></option>
			<option value="srcip"><s:message code="condition.source"/> IP</option>
			<option value="sport"><s:message code="condition.source"/> PORT</option>
			<option value="dstip"><s:message code="condition.destination"/> IP</option>
			<option value="dport"><s:message code="condition.destination"/> PORT</option>
			<option value="svc"><s:message code="condition.service"/></option>
			<option value="size"><s:message code="analysis.freedom.ui.size"/>(MB<s:message code="filterInfo.rangeL"/>)</option>
			<option value="host_str">URL</option>
			<option value="sender"><s:message code="condition.sender"/></option>
			<option value="to"><s:message code="condition.recv"/></option>
			<option value="body_snippet"><s:message code="bodyview.body.content"/></option>
			<option value="subject"><s:message code="analysis.freedom.ui.mailtitle"/></option>
			<option value="conm"><s:message code="common.org.conm"/></option>
			<option value="suborgcd"><s:message code="common.org.suborg"/></option>
			<option value="businm"><s:message code="common.org.busi"/></option>
			<option value="deptnm"><s:message code="common.org.dept"/></option>
			<option value="jikgubnm"><s:message code="common.org.jikgub"/></option>
			<option value="attached"><s:message code="analysis.freedom.ui.isattach"/></option>
			<option value="attachname_str"><s:message code="condition.attach_name"/></option>
			<option value="attachtype"><s:message code="common.msg.ext"/></option>
			<option value="kwds"><s:message code="condition.keyword"/></option>
		</select>

		<select id="compare" name="compare" onchange="javascirpt:SearchTrue();">
			<option value="=">=</option>
			<option value="!=">!=</option>
			<option value=">">&gt;</option>
			<option value="<">&lt;</option>
			<option value=">=">&gt;=</option>
			<option value="<=">&lt;=</option>
			<option value="IN">IN</option>
		</select>
		<span id="inputNumber" style="display:none;"><input type="text" id="sizeNum" name="sizeNum" class="btn-xs numberinput"
		                                                    onchange="javascirpt:SearchTrue();" style="width: 250px;height:26px;"
		                                                    placeholder="<s:message code="analysis.freedom.ui.exam25"/>" data-toggle="tooltip"
		                                                    data-placement="top" title="<s:message code="analysis.freedom.ui.exam25"/>"
		                                                    maxlength="7"/></span>
		<span id="inputText"><input type="text" id="context" name="context" class="btn-xs" onchange="javascirpt:SearchTrue();"
		                            style="width: 250px;height:26px;" placeholder="<s:message code="analysis.freedom.ui.exam26"/>"
		                            data-toggle="tooltip" data-placement="top" title="<s:message code="analysis.freedom.ui.exam26"/>"/></span>
		<span id="inputDate" style="display:none;">
				<span id="sdatepicker"><input type="date" id="startDate" name="startDate" style="width: 110px;">
				<span class="hyphen">~</span></span>
			<span id="edatepicker"><input type="date" id="endDate" name="endDate" style="width: 110px;"></span>

			</span>
		<span id="inputServiceType" style="display:none;">
				<select class="" id="serviceCd" name="serviceCd"
				        style="width:250px; height:26px;padding-top:0px;padding-bottom:0px;" onchange="javascirpt:SearchTrue();">
				</select>
			</span>
		<select id="afterPparen" name="afterPparen">
			<option value=""></option>
			<option value=")">)</option>
		</select>
		<button type="button" class="btn01" accesskey="I" id="btnTermsAdd" onclick="javascript:SearchTrue();terms.addTerms;"
		        style="position: absolute; top:0px; right:0;"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message
				code="common.msg.add"/></button>
		<button type="button" class="btn02" accesskey="D" id="btnTermsDel" onclick="javascript:SearchTrue();terms.delTerms;"><img
				src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
	</div>
</div>

<div id="columnHtml" style="display:none;">
	<div id="columnContentId" class="columnContent" style="margin-bottom:10px;">
		<select id="columnData" name="columnData" onchange="javascirpt:SearchTrue();">
			<option value="userid"><s:message code="condition.usrid"/></option>
			<option value="ctime_yyyy"><s:message code="analysis.freedom.ctime_yyyy"/></option>
			<option value="ctime_yyyymm"><s:message code="analysis.freedom.ctime_yyyymm"/></option>
			<option value="ctime_yyyymmdd"><s:message code="analysis.freedom.ctime_yyyymmdd"/></option>
			<option value="ctime_yyyymmddhh"><s:message code="analysis.freedom.ctime_yyyymmddhh"/></option>
			<option value="srcip"><s:message code="condition.source"/> IP</option>
			<option value="sport"><s:message code="condition.source"/> PORT</option>
			<option value="dstip"><s:message code="condition.destination"/> IP</option>
			<option value="dport"><s:message code="condition.destination"/> PORT</option>
			<option value="svc12"><s:message code="condition.service"/></option>
			<option value="host_str">HOST</option>
			<option value="sender_str"><s:message code="condition.sender"/></option>
			<option value="to"><s:message code="condition.recv"/></option>
			<option value="conm"><s:message code="common.org.conm"/></option>
			<option value="suborgcd"><s:message code="common.org.suborg"/></option>
			<option value="businm"><s:message code="common.org.busi"/></option>
			<option value="deptnm"><s:message code="common.org.dept"/></option>
			<option value="jikgubnm"><s:message code="common.org.jikgub"/></option>
			<option value="attached"><s:message code="analysis.freedom.ui.isattach"/></option>
			<option value="attachname_str"><s:message code="condition.attach_name"/></option>
			<option value="kwds"><s:message code="condition.keyword"/></option>
		</select>
		<button type="button" class="btn01" accesskey="I" id="btnTermsAdd" onclick="javascript:SearchTrue();columns.add;"
		        style="position: absolute; top:0px; right:0;"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message
				code="common.msg.add"/></button>
		<button type="button" class="btn02" accesskey="D" id="btnTermsDel" onclick="javascript:SearchTrue();columns.del;"><img
				src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
		<!--<button type="button" id="btnColumnDel" class="btn" style="height:26px;vertical-align: middle;padding:0px 5px 0px 5px;" onclick="javascript:SearchTrue();columns.del;">
			<span class="glyphicon glyphicon-minus"></span>
		</button>
		<button type="button" id="btnColumnAdd" class="btn" style="height:26px;vertical-align: middle;padding:0px 5px 0px 5px;" onclick="javascript:SearchTrue();columns.add;">
			<span class="glyphicon glyphicon-plus"></span>
		</button>-->
	</div>
</div>

<div id="dataHtml" style="display:none;">
	<div id="dataContentId" class="dataContent" style="margin-bottom:10px;">
		<select id="groupBy" name="groupBy" onchange="javascirpt:SearchTrue();">
			<option value="count"><s:message code="analysis.freedom.totcnt"/>(COUNT)</option>
			<option value="sum"><s:message code="analysis.freedom.sum"/>(SUM)</option>
			<option value="avg"><s:message code="analysis.freedom.avg"/>(AVG)</option>
			<option value="max"><s:message code="analysis.freedom.max"/>(MAX)</option>
			<option value="min"><s:message code="analysis.freedom.min"/>(MIN)</option>
		</select>
		<select id="groupData" name="groupData" onchange="javascirpt:SearchTrue();">
			<option value="size"><s:message code="analysis.freedom.totbyte"/></option>
		</select>
		<button type="button" class="btn01" accesskey="I" id="btnDataAdd" onclick="javascript:SearchTrue();datas.add;"
		        style="position: absolute; top:0px; right:0;"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message
				code="common.msg.add"/></button>
		<button type="button" class="btn02" accesskey="D" id="btnDataDel" onclick="javascript:SearchTrue();datas.del;"><img
				src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
		<!--<button type="button" id="btnDataDel" class="btn" style="height:26px;vertical-align: middle;padding:0px 5px 0px 5px;" onclick="javascript:SearchTrue();datas.del;">
			<span class="glyphicon glyphicon-minus"></span>
		</button>
		<button type="button" id="btnDataAdd" class="btn" style="height:26px;vertical-align: middle;padding:0px 5px 0px 5px;" onclick="javascript:SearchTrue();datas.add;">
			<span class="glyphicon glyphicon-plus"></span>
		</button>-->
	</div>
</div>

<div id="messageListDiv" class="messageList" style="display:none">
	<div class="panel panel-default " style=min-height:300px;margin:0px;">
		<div class="panel-heading" style="height: 25px;">
			<i class="fa fa-file-text-o fa-fw"></i> <span><s:message code="analysis.freedom.ui.msglist"/><span class="resultCnt"></span> - <span
				class="selectChartData"></span></span>
			<span class="btn--message-popover">
					<a tabindex="0" class="btn btn-xs" role="button" onclick="javascript:messageListClose();"><span class="glyphicon glyphicon-remove" style="font-size:15px;"></span></a>
				</span>
		</div>
		<div class="panel-body" style="height: 100%;padding:0px;">
			<div class="resultHeader" style="height:35px;margin-top:5px;">
				<div class="form-inline" style="height:42px;">
					<div class="btnArea text-left col-xs-7 form-group">
						<div class="resultMsgDiv" style="height:26px;">
							<span></span>
						</div>
					</div>
					<div class="btnArea text-right col-xs-5" style="padding-right:0;">
						<div class="btn-group">
							<button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown">
								<span class="glyphicon glyphicon-download-alt"></span>&nbsp;<s:message code="common.msg.export"/> <span
									class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-right" role="menu" id="export_menu"></ul>
						</div>
						<div class="btn-group grid-limit listCnt" id="messageListCount"></div>
					</div>
				</div>
			</div>
			<div id="messageList" class="resultBody" style="height:250px;margin-left:15px; margin-right:15px;">
				<div id="messageListGrid" class="slickGrid gridArea" style="position: relative; top: 10px; left: 0px; height:90%;"></div>
				<div id="messageCnt" style="margin-top:12px; color: #f25643; font-weight: bold; font-size: 13px;"></div>
			</div>
		</div>
	</div>
</div>

<!-- Back to top -->
<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>

<script type="text/javascript">
    var chartData;
    var formData = '';
    var columnData = [];
    var isSearch = true;

    function SearchTrue() {
        isSearch = true;
    }

    function search(chartKind) {
        var termsColumn = [];
        var startDate = [];
        var endDate = [];
        for (var ti = 0; ti <= tabIdx; ti++) {
            var termsLength = $("select[id=termsColumn" + ti + "] option:selected").length;
            $.each($("select[id=termsColumn" + ti + "] option:selected"), function (i, val) {
                termsColumn[i] = val.value;
            });
            $.each($("input[id=startDate" + ti + "]"), function (i, val) {
                startDate[i] = val.value;
            });
            $.each($("input[id=endDate" + ti + "]"), function (i, val) {
                endDate[i] = val.value;
            });
            for (var ii = 0; ii < termsLength; ii++) {
                if ((termsColumn[ii] == "ctime" || termsColumn[ii] == "ctime_yyyymmdd") && startDate[ii] > endDate[ii]) {
                    alert("<s:message code="analysis.freedom.ui.msg1"/>");
                    return;
                }


            }
        }

        var beforePparen = 0;
        var afterPparen = 0;
        for (var ti = 0; ti <= tabIdx; ti++) {
            $.each($("select[id=beforePparen" + ti + "] option:selected"), function (i, val) {
                if (val.value == "") {
                    beforePparen++;
                }
            });
            $.each($("select[id=afterPparen" + ti + "] option:selected"), function (i, val) {
                if (val.value == "") {
                    afterPparen++;
                }
            });
        }
        if (beforePparen != afterPparen) {
            alert("<s:message code="analysis.freedom.ui.msg2"/>");
            return;
        }

        //if(isSearch) {
        ui.post({
            url: 'analysis/freedomView.xcn',
            data: $("#frm").serialize() + "&tabIdx=" + tabIdx,
            success: function (data, total) {
                if (data== null) {
                    ui.alertMsg("<s:message code="analysis.freedom.ui.msg3"/>");
                }
                chartData = nameDataTrans(data);
                isSearch = false;
                chartCreate(chartKind);
                formData = $("#frm").serialize() + "&tabIdx=" + tabIdx;

                columnData = [];
                for (var ti = 0; ti <= tabIdx; ti++) {
                    for (var i = columns.currIdx; i <= columns.idx[tabIdx]; i++) {
                        $.each($("#columnContentId" + tabIdx + i + " select[id=columnData" + tabIdx + "] option:selected"), function (i, val) {
                            columnData.push(val.value);
                        });
                    }
                }
            },
            error: function (status, message) {
                ui.alertMsg('error : <s:message code="analysis.freedom.ui.msg4"/>');
            }
        });
        //} else {
        //	chartCreate(chartKind);
        //}
    }

    function chartCreate(chartKind) {
        var freedomChart = new FreedomChart();
        var depth = $("select[id=columnData" + tabIdx + "]").length;
        freedomChart.chart('#dataChart', chartData, chartKind, "form #groupBy" + tabIdx, depth);

    }

    function nameDataTrans(data) {
        for (var i = columns.currIdx; i <= columns.idx[tabIdx]; i++) {
            var col = $("#columnContentId" + tabIdx + i + " select[id=columnData" + tabIdx + "] option:selected").val();
            if (col == 'svc12' || col == 'ctime_yyyy' || col == 'ctime_yyyymm' || col == 'ctime_yyyymmdd' || col == 'ctime_yyyymmddhh') {
                if (i == (columns.currIdx + 0)) {
                    $.each(data, function () {
                        if (col == 'svc12') {
                            this.val = serviceTypeMap.get(this.val);
                        } else {
                            this.val = getDateFormatSize(this.val);
                        }
                    });
                } else if (i == (columns.currIdx + 1)) {
                    for (j in data) {
                        if (data[j].buckets != null) {
                            $.each(data[j].buckets, function () {
                                if (col == 'svc12') {
                                    this.val = serviceTypeMap.get(this.val);
                                } else {
                                    this.val = getDateFormatSize(this.val);
                                }
                            });
                        }
                    }
                }
            }
        }

        // data sort
        data.sort(dataSort);
        $.each(data, function () {
            if (this.buckets != null) {
                this.buckets.sort(dataSort);
            }
        });

        return data;
    }

    function dataSort(a, b) {
        if (a.val == b.val) {
            return 0;
        }
        if ($.isNumeric(a.val)) {
            return Number(a.val) > Number(b.val) ? 1 : -1;
        } else {
            return a.val > b.val ? 1 : -1;
        }
    }

    function getServiceType(term) {
        var result = '';
        ui.get({
            url: 'getServiceList.xcn',
            asyncFlag: false,
            searchStr: '',
            success: function (data, total) {

                $.each(data, function (i, v) {
                    if (!serviceTypeMap.containsKey(this.groupCd)) {
                        serviceTypeMap.put(this.groupCd, this.groupNm);
                    }
                    serviceTypeMap.put(this.serviceCd, this.groupNm + ' > ' + this.serviceNm);
                });

                var serviceType = serviceTypeMap.getAll();
                var lvl1 = "";
                $.each(serviceType, function () {
                    <%-- 			        	if(this.key.length == 1 && this.key != lvl1) {
												result += '<option data-divider="true"></option>';
												lvl1 = this.key;
											} --%>
                    result += '<option value="' + this.key + '">' + this.value + '</option>';
                });

                $("#serviceCd").html(result);
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
            }
        });

        term.addTerms();
    }

    function setQuery(col1, col2, value, isPie) {
        if (isPie) {
            messagePageLinkPie(col1, col2, value);
        } else {
            messagePageLink(col1, col2, value);
        }
    }

    function setSearchdata(col, val) {

        var data = val;
        if (col == 'svc12') {
            data = serviceTypeMap.getKey(val);
        } else if (col == 'ctime_yyyy') {
            data = val.replaceAll('년', '').replaceAll('year', '').replaceAll('Year', '');
        } else if (col == 'ctime_yyyymm') {
            data = val.replaceAll('-', '');
        } else if (col == 'ctime_yyyymmdd') {
            data = val.replaceAll('-', '');
        } else if (col == 'ctime_yyyymmddhh') {
            data = val.replaceAll('-', '').replaceAll(' ', '').replaceAll('시', '');
        }

        return col + ':"' + data + '"';
    }

    function messagePageLink(col1, col2, value) {

        var query = '';
        var title = '';

        if (columns.count == 1) {
            $.each($("#columnContentId" + tabIdx + columns.currIdx + " select[id=columnData" + tabIdx + "] > option"), function () {
                if ($(this).text() == col2) {
                    title += $(this).text() + ':"' + col1 + '" ';
                    if (query.length > 1) query += ' %26%26 ';
                    query += setSearchdata($(this).val(), col1);
                    return true;
                }
            });
        } else {
            var colData = [col1, col2];
            for (var i = 0; i < columnData.length; i++) {
                $.each($("#columnContentId" + tabIdx + columns.currIdx + " select[id=columnData" + tabIdx + "] > option"), function () {
                    if ($(this).val() == columnData[i]) {
                        title += $(this).text() + ':"' + colData[i] + '" ';
                        return true;
                    }
                });
                if (query.length > 1) query += ' %26%26 ';
                query += setSearchdata(columnData[i], colData[i]);
            }
        }

        selectDetail(query);
        $(".selectChartData").html(title);
    }

    function messagePageLinkPie(col1, col2, value) {

        var query = '';
        var title = '';

        if (columns.count == 1 || col2.indexOf('] ') == -1) {
            var col = col2.indexOf('] ') == -1 ? col1 : col2;
            $.each($("#columnContentId" + tabIdx + columns.currIdx + " select[id=columnData" + tabIdx + "] > option"), function () {
                if ($(this).text() == col) {
                    title += $(this).text() + ':"' + col2 + '" ';
                    if (query.length > 1) query += ' %26%26 ';
                    query += setSearchdata($(this).val(), col2);
                    return true;
                }
            });
        } else {
            var colData = col2.split('] ');
            colData[0] = colData[0].substring(1);
            for (var i = 0; i < columnData.length; i++) {
                $.each($("#columnContentId" + tabIdx + columns.currIdx + " select[id=columnData" + tabIdx + "] > option"), function () {
                    if ($(this).val() == columnData[i]) {
                        title += $(this).text() + ':"' + colData[i] + '" ';
                        return true;
                    }
                });
                if (query.length > 1) query += ' %26%26 ';
                query += setSearchdata(columnData[i], colData[i]);
            }
        }

        selectDetail(query);
        $(".selectChartData").html(title);
    }

    var grid = new Xgrid('messageListGrid', contextRoot, 26, {
        commonId: 'selectTotalList',
        status_cnt_id: '#messageCnt',
        more_btn: 'slick_grid_more_btn'
    });

    function colInit() {
        // grid.colInit();   // grid.colInit();
        initGrid(grid, messageGridColumn);
        writeExportMenu('export_menu', 'messageListGrid', '<s:message code="DATA_ANALYSIS.ANALYSIS_CUSTOM"/> - <s:message code="analysis.freedom.ui.msglist"/>');
    }
    grid.loadPageSize();
    grid.changePageSize = function(cnt){
        getData('Y');
    };

    var selectQuery = '';

    function selectDetail(query) {
        selectQuery = query;
        selectMessageList('Y');
    }

    function selectMessageList(flag) {
        $("#messageList").show();
        if (flag == undefined || flag == 'Y') {
            grid.data.length = 0;
            grid.rtnNextPageFunc = selectMessageList;
            grid.loadingPage = 0;
            messageListShow();
        } else {
            grid.loadingPage++;
        }
        grid.pageSize = getPageSize('messageListCount');
        grid.on();


        ui.post({
            url: 'analysis/selectFreedomMessageList.xcn',
            data: $("#frm").serialize() + "&tabIdx=" + tabIdx + "&query=" + selectQuery + "&offset=" + grid.data.length + "&limit=" + grid.pageSize,
            success: function (data, total) {
                resultTotal = total;
                // grid.autoNumber();
                // grid.loadHeader(false);
                grid.appendData(data);
                $(".resultCnt").html('(' + addCommas(total) + ')');
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
                grid.off();
            }
        });
    }

    function messageListClose() {
        $('.messageList').hide();
    }

    function messageListShow() {
        $('.messageList').show();
    }

    /*
	 * Grid 관련 함수
	 */
    function viewer_open(row, bodySize) {
        var msgid = grid.getValue(row, 'msgid');

        openMessageBodyPop(grid.id, msgid, '', bodySize);

        var readYn = grid.getValue(row, 'readYn');
        grid.setValue(row, grid.ColIndex('readYn'), 'Y');
        grid.Select(row, 0);
    }

    function viewer_newOpen(row, bodySize) {
        var msgid = grid.getValue(row, 'msgid');
        openMessageBodyPop('', msgid, '', bodySize);

        var readYn = grid.getValue(row, 'readYn');
        grid.setValue(row, grid.ColIndex('readYn'), 'Y');
    }

    function prevMsg() {
        var row = 0;
        if (grid.Row > 0) {
            row = --grid.Row;
            viewer_open(row);
            grid.Select(row, 0);
            return true;
        }
        return false;
    }

    function nextMsg() {
        var row = 0;
        if (grid.Row < grid.Rows - 1) {
            row = ++grid.Row;
            viewer_open(row);
            grid.Select(row, 0);
            if (grid.Row == grid.Rows - 2) {
                getList(true);
            }
            return true;
        }
        return false;
    }

    var serviceTypeMap;
    var tabIdx = 0;
    var maxChartCount = 50;

    var terms = {
        tabIdx: 0,
        termsIdx: [0],
        addTerms: function (selectIdx) {
            this.termsIdx[tabIdx]++;
            var idx = this.termsIdx[tabIdx];

            var tab_content = $('#termsHtml').html().replaceAll('termsContentId', ('termsContentId' + tabIdx) + idx).replaceAll('btnTermsAdd', ('btnTermsAdd' + tabIdx) + idx).replaceAll('btnTermsDel', ('btnTermsDel' + tabIdx) + idx).replaceAll('addTerms', ('addTerms(\'' + tabIdx) + idx + '\')').replaceAll('delTerms', ('delTerms(\'' + tabIdx) + idx + '\')').replaceAll('tabIdx', tabIdx).replaceAll('termsIdx', idx).replaceAll('andOr', 'andOr' + tabIdx).replaceAll('beforePparen', 'beforePparen' + tabIdx).replaceAll('termsColumn', 'termsColumn' + tabIdx).replaceAll('compare', 'compare' + tabIdx).replaceAll('sizeNum', 'sizeNum' + tabIdx).replaceAll('context', 'context' + tabIdx).replaceAll('afterPparen', 'afterPparen' + tabIdx).replaceAll('serviceCd', 'serviceCd' + tabIdx).replaceAll('inputText', ('inputText' + tabIdx) + idx).replaceAll('inputNumber', ('inputNumber' + tabIdx) + idx).replaceAll('startDate', 'startDate' + tabIdx).replaceAll('endDate', 'endDate' + tabIdx).replaceAll('inputDate', ('inputDate' + tabIdx) + idx).replaceAll('inputServiceType', ('inputServiceType' + tabIdx) + idx).replaceAll('sdatepicker', ('sdatepicker' + tabIdx) + idx).replaceAll('edatepicker', ('edatepicker' + tabIdx) + idx);

            //$(('#btnTermsAdd'+tabIdx)+(idx-1)).hide();
            //$(('#btnTermsDel'+tabIdx)+idx).show();

            if ($('#termsData .termsContent').length == 0) {
                $('#termsData').append(tab_content);
            } else {
                $('#termsData .termsContent').each(function (i, val) {
                    if (this.id == 'termsContentId' + selectIdx) {
                        $(this).after(tab_content);
                        return true;
                    }
                });
            }

            $(('#sdatepicker' + tabIdx) + idx).datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date()),
            });
            $(('#edatepicker' + tabIdx) + idx).datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
                defaultDate: moment(new Date()),
            });

            this.firstSelectReadonly();

            $(".numberinput").forceNumeric();
        },

        delTerms: function (selectIdx) {
            if ($('#termsData .termsContent').length > 1) {
                $('#termsContentId' + selectIdx).remove();
            }
            this.firstSelectReadonly();
        },

        firstSelectReadonly: function () {
            $("#andOr" + tabIdx).prepend("<option value=''></option>");
            $("#andOr" + tabIdx + " option:eq(0)").attr("selected", "selected");
            $("#andOr" + tabIdx).prop("disabled", true);
        },
        colChange: function (value, tabIdx, termsIdx) {
            switch (value) {
                case "ctime" :
                    $(("#inputNumber" + tabIdx) + termsIdx).hide();
                    $(("#inputText" + tabIdx) + termsIdx).hide();
                    $(("#inputDate" + tabIdx) + termsIdx).show();
                    $(("#inputServiceType" + tabIdx) + termsIdx).hide();
                    break;
                case "svc" :
                    $(("#inputNumber" + tabIdx) + termsIdx).hide();
                    $(("#inputText" + tabIdx) + termsIdx).hide();
                    $(("#inputDate" + tabIdx) + termsIdx).hide();
                    $(("#inputServiceType" + tabIdx) + termsIdx).show();
                    break;
                case "size" :
                    $(("#inputNumber" + tabIdx) + termsIdx).show();
                    $(("#inputText" + tabIdx) + termsIdx).hide();
                    $(("#inputDate" + tabIdx) + termsIdx).hide();
                    $(("#inputServiceType" + tabIdx) + termsIdx).hide();
                    break;
                default :
                    $(("#inputNumber" + tabIdx) + termsIdx).hide();
                    $(("#inputText" + tabIdx) + termsIdx).show();
                    $(("#inputDate" + tabIdx) + termsIdx).hide();
                    $(("#inputServiceType" + tabIdx) + termsIdx).hide();
            }
        }
    };

    var columns = {
        count: 0,
        idx: [0],
        currIdx: 1,
        add: function (selectIdx) {
            var columnCount = '2';
            if ($('#columnData .columnContent').length >= columnCount) {
                ui.alertMsg('<s:message code="analysis.freedom.ui.msg5" arguments="'+columnCount+'" argumentSeparator="|" />');
            } else {

                this.idx[tabIdx]++;
                var idx = this.idx[tabIdx];

                var tab_content = $('#columnHtml').html().replaceAll('columnContentId', ('columnContentId' + tabIdx) + idx).replaceAll('btnColumnAdd', ('btnColumnAdd' + tabIdx) + idx).replaceAll('btnColumnDel', ('btnColumnDel' + tabIdx) + idx).replaceAll('columns.add', ('columns.add(\'' + tabIdx) + idx + '\')').replaceAll('columns.del', ('columns.del(\'' + tabIdx) + idx + '\')').replaceAll('tabIdx', tabIdx).replaceAll('columnData', 'columnData' + tabIdx);

                //$(('#btnColumnAdd'+tabIdx)+(idx-1)).hide();
                //$(('#btnColumnDel'+tabIdx)+(idx-1)).show();

                if ($('#columnData .columnContent').length == 0) {
                    $('#columnData').append(tab_content);
                } else {
                    $('#columnData .columnContent').each(function (i, val) {
                        if (this.id == 'columnContentId' + selectIdx) {
                            $(this).after(tab_content);
                            return true;
                        }
                    });
                }

                this.count = $('#columnData .columnContent').length;
                this.currIdx = this.idx[tabIdx] - this.count + 1;
            }
        },
        del: function (selectIdx) {
            if ($('#columnData .columnContent').length > 1) {
                $('#columnContentId' + selectIdx).remove();
            }
            this.count = $('#columnData .columnContent').length;
            this.currIdx = this.idx[tabIdx] - this.count + 1;
        }
    };

    var datas = {
        idx: [0],
        add: function (selectIdx) {
            this.idx[tabIdx]++;
            var idx = this.idx[tabIdx];

            var tab_content = $('#dataHtml').html().replaceAll('dataContentId', ('dataContentId' + tabIdx) + idx).replaceAll('btnDataAdd', ('btnDataAdd' + tabIdx) + idx).replaceAll('btnDataDel', ('btnDataDel' + tabIdx) + idx).replaceAll('datas.add', ('datas.add(\'' + tabIdx) + idx + '\')').replaceAll('datas.del', ('datas.del(\'' + tabIdx) + idx + '\')').replaceAll('tabIdx', tabIdx).replaceAll('termsIdx', idx).replaceAll('groupBy', 'groupBy' + tabIdx).replaceAll('groupData', 'groupData' + tabIdx);

            if ($('#dataData .dataContent').length == 0) {
                $('#dataData').append(tab_content);
            } else {
                $('#dataData .dataContent').each(function (i, val) {
                    if (this.id == 'dataContentId' + selectIdx) {
                        $(this).after(tab_content);
                        return true;
                    }
                });
            }

        },
        del: function (selectIdx) {
            if ($('#dataData .dataContent').length > 1) {
                $('#dataContentId' + selectIdx).remove();
            }
        }
    };

    HashMap = function () {
        this.map = new Array();
    };
    HashMap.prototype = {
        put: function (key, value) {
            this.map.push(eval({"key": key, "value": value}));
        },
        get: function (key) {
            for (i in this.map) {
                if (this.map[i].key === key) return this.map[i].value;
            }
            return key;
        },
        getKey: function (value) {
            for (i in this.map) {
                if (this.map[i].value === value) return this.map[i].key;
            }
            return key;
        },
        getAll: function () {
            return this.map;
        },
        clear: function () {
            this.map = new Array();
        },
        isEmpty: function () {
            return (this.map.size() == 0);
        },
        remove: function (key) {
            for (i in this.map) {
                if (this.map[i].key === key) {
                    delete this.map[i];
                    return true;
                }
            }
            return false;
        },
        containsKey: function (key) {
            for (i in this.map) {
                if (this.map[i].key === key) return true;
            }
            return false;
        },
        toString: function () {
            var temp = '';
            for (i in this.map) {
                if (this.map[i].key != undefined) {
                    temp = temp + ',' + this.map[i].key + ':' + this.map[i].value;
                }
            }
            temp = temp.replace(',', '');
            return temp;
        },
        keySet: function () {
            var keys = new Array();
            for (i in this.map) {
                if (this.map[i].key != undefined) {
                    keys.push(this.map[i].key);
                }
            }
            return keys;
        }
    };

    FreedomChart = function () {
        var title = "";
        var subtitle = "";
        var yAxisTtitle = "";
        var depth = 1;
        var firstName = "";
        var secondName = "";
        var groupByMap = new HashMap();
    }

    FreedomChart.prototype = {

        chart: function (id, data, column, objName, depth) {
            var that = this;
            this.setDiv(objName);
            that.depth = depth;
            that.firstName = $("#columnContentId" + tabIdx + columns.currIdx + " select[id=columnData" + tabIdx + "] option:selected").text();
            that.secondName = $("#columnContentId" + tabIdx + (columns.currIdx + 1) + " select[id=columnData" + tabIdx + "] option:selected").text();
            that.groupByMap = new HashMap();

            $.each($(objName), function (i, obj) {
                var value = $(obj).val();
                var chartData = "";

                that.setTitle($(obj), depth);
                switch (column) {
                    case "list" :
                        break;
                    case "area" :
                        that.lineChartData.init(data, that.depth, value, that);
                        chartData = that.lineChartData;
                        that.lineChart(id + i, chartData, value, column, that);
                        break;
                    case "line" :
                        that.lineChartData.init(data, that.depth, value, that);
                        chartData = that.lineChartData;
                        that.lineChart(id + i, chartData, value, column, that);
                        break;
                    case "column" :
                        that.lineChartData.init(data, that.depth, value, that);
                        chartData = that.lineChartData;
                        that.barChart(id + i, chartData, value, column, that);
                        break;
                    case "pie" :
                        that.pieChartData.init(data, that.depth, value, that);
                        chartData = that.pieChartData;
                        if (depth == 1) {
                            that.pieBasicChart(id + i, chartData, value, column, that);
                        } else {
                            that.pieDonutChart(id + i, chartData, value, column, that);
                        }
                        break;
                }
            });
        },
        setTitle: function (obj, depth) {

            var title = "";
            for (var i = columns.currIdx; i <= columns.idx[tabIdx]; i++) {
                title += $("#columnContentId" + tabIdx + i + " select[id=columnData" + tabIdx + "] option:selected").text() + " - ";
            }
            this.title = title + obj.children("option:selected").text();
            if (obj.val() == "count") {
                this.yAxisTtitle = "<s:message code="analysis.freedom.totcnt"/>";
            } else {
                this.yAxisTtitle = "<s:message code="analysis.freedom.totbyte"/>";
            }
        },
        setSubtitle: function (maxChartCount, length, name) {
            this.subtitle = '<s:message code="analysis.freedom.ui.msg6" arguments="'+name+'|'+maxChartCount+'|'+length+'" argumentSeparator="|"/> ';
        },
        setDiv: function (objName) {
            var chartCount = $(objName).length;
            $('#chartDiv').html("");
            for (var i = 0; i < chartCount; i++) {
                var chart_content = $('#chartHtml').html().replaceAll('dataChart', 'dataChart' + i);
                $('#chartDiv').append(chart_content);
            }
        },
        countSort: function (a, b) {
            if (a.count == b.count) {
                return 0;
            }
            if ($.isNumeric(a.count)) {
                return Number(a.count) < Number(b.count) ? 1 : -1;
            } else {
                return a.count < b.count ? 1 : -1;
            }
        },
        sort: function (a, b) {
            if (a.name == b.name) {
                return 0;
            }
            if ($.isNumeric(a.name)) {
                return Number(a.name) > Number(b.name) ? 1 : -1;
            } else {
                return a.name > b.name ? 1 : -1;
            }
        },
        avgSort: function (a, b) {
            if (a.avg == b.avg) {
                return 0;
            }
            if ($.isNumeric(a.avg)) {
                return Number(a.avg) < Number(b.avg) ? 1 : -1;
            } else {
                return a.avg < b.avg ? 1 : -1;
            }
        },
        sumSort: function (a, b) {
            if (a.sum == b.sum) {
                return 0;
            }
            if ($.isNumeric(a.sum)) {
                return Number(a.sum) < Number(b.sum) ? 1 : -1;
            } else {
                return a.avg < b.avg ? 1 : -1;
            }
        },
        maxSort: function (a, b) {
            if (a.max == b.max) {
                return 0;
            }
            if ($.isNumeric(a.max)) {
                return Number(a.max) < Number(b.max) ? 1 : -1;
            } else {
                return a.max < b.max ? 1 : -1;
            }
        },
        minSort: function (a, b) {
            if (a.min == b.min) {
                return 0;
            }
            if ($.isNumeric(a.min)) {
                return Number(a.min) < Number(b.min) ? 1 : -1;
            } else {
                return a.min < b.min ? 1 : -1;
            }
        },
        sortValue: function (objValue, data) {

            switch (objValue) {
                case "count" :
                    data = data.sort(this.countSort);
                    break;
                case "avg" :
                    data = data.sort(this.avgSort);
                    break;
                case "sum" :
                    data = data.sort(this.sumSort);
                    break;
                case "max" :
                    data = data.sort(this.maxSort);
                    break;
                case "min" :
                    data = data.sort(this.minSort);
                    break;
            }

            return data;
        },
        lineChartData: {
            firstName: '',
            categories: new Array(),
            series: new Array(),
            seriesData: function () {
                this.name = "";
                this.data = new Array();
                this.drilldown = "";
            },
            dataPush: function (name, data, count, size) {
                var isInput = false;
                $.each(this.series, function () {
                    if (this.name == name) {
                        if (count == -1) {
                            if (this.data.length != size) {
                                this.data.push(data);
                            }
                        } else {
                            this.data[count] = data;
                        }
                        isInput = true;
                        return;
                    }
                });
                if (!isInput) {
                    var seriesData = new this.seriesData();
                    seriesData.name = name;
                    seriesData.drilldown = name;
                    if (count == -1) {
                        if (seriesData.data.length != size) {
                            seriesData.data.push(data);
                        }
                    } else {
                        seriesData.data[count] = data;
                    }
                    this.series.push(seriesData);
                }
            },
            init: function (data, depth, objValue, parent) {
                this.firstName = parent.firstName;
                this.categories = new Array();
                this.series = new Array();
                var that = this;
                var objName = "value." + objValue;

                // 입력값이 크면 정렬 함. (1차)
                if (data.length > maxChartCount) {
                    data = parent.sortValue(objValue, data);
                }

                // 입력값이 크면 정렬 함. (2차)
                $.each(data, function (i, value) {
                    if (value.buckets != null) {
                        var bucketsValue = 0;
                        if (value.buckets > maxChartCount) {
                            value.buckets = parent.sortValue(objValue, value.buckets);
                        }
                        $.each(value.buckets, function (j, value2) {
                            if (value.buckets > maxChartCount) {
                                data = data.sort(parent.minSort);
                                bucketsValue += eval("value2." + objValue);
                            }
                        });
                        if (bucketsValue != 0) {
                            obj = bucketsValue;
                        }
                    }
                });

                if (depth == 0) {
                    $.each(data, function (i, value) {
                        if (i > maxChartCount) {
                            parent.setSubtitle(maxChartCount, data.length, parent.firstName);
                            return false;
                        }
                        that.categories.push(value.val);
                        that.dataPush($("select[id=columnData" + tabIdx + "] option:selected").text(), eval(objName), i, data.length);
                    });
                } else {
                    $.each(data, function (i, value) {
                        if (i > maxChartCount) {
                            parent.setSubtitle(maxChartCount, data.length, parent.firstName);
                            return false;
                        }
                        that.categories.push(value.val);

                        if (value.buckets == null) {
                            that.dataPush($("select[id=columnData" + tabIdx + "] option:selected").text(), eval(objName), i, data.length);
                        } else {
                            $.each(value.buckets, function (j, value2) {
                                if (j > maxChartCount) {
                                    parent.setSubtitle(maxChartCount, value.buckets.length, parent.secondName);
                                    return false;
                                }
                                for (var k = 0; k < data.length; k++) {
                                    that.dataPush(value2.val, 0, -1, data.length);
                                }
                                that.dataPush(value2.val, eval("value2." + objValue), i, data.length);
                            });
                        }
                    });
                }
                this.series = this.series.sort(parent.sort);
            }
        },
        pieChartData: {
            colors: Highcharts.colors,
            firstName: '',
            secondName: '',
            firstData: new Array(),
            secondData: new Array(),
            totalCount: 0,
            dataSort: function (a, b) {
                var at = eval("a." + this.objName);
                var bt = eval("b." + this.objName);
                if (at == bt) {
                    return 0;
                }
                if ($.isNumeric(a)) {
                    return Number(at) > Number(bt) ? 1 : -1;
                } else {
                    return at > bt ? 1 : -1;
                }
            },
            firstDataPush: function (name, data, count) {
                this.firstData.push({
                    name: name,
                    y: data / this.totalCount * 100,
                    // color: this.colors[count]
                });
            },
            secondDataPush: function (name, data, count, brightness) {
                this.secondData.push({
                    name: name,
                    y: data / this.totalCount * 100,
                });
            },
            init: function (data, depth, objValue, parent) {
                this.firstName = parent.firstName;
                this.secondName = parent.secondName;
                this.firstData = new Array();
                this.secondData = new Array();
                var that = this;
                var objName = "value." + objValue;

                // 입력값이 크면 정렬 함. (1차)
                if (data.length > maxChartCount) {
                    data = parent.sortValue(objValue, data);
                }

                // 입력값이 크면 정렬 함. (2차)
                $.each(data, function (i, value) {
                    if (value.buckets != null) {
                        var bucketsValue = 0;
                        if (value.buckets > maxChartCount) {
                            value.buckets = parent.sortValue(objValue, value.buckets);
                        }
                        $.each(value.buckets, function (j, value2) {
                            if (value.buckets > maxChartCount) {
                                data = data.sort(parent.minSort);
                                bucketsValue += eval("value2." + objValue);
                            }
                        });
                        if (bucketsValue != 0) {
                            obj = bucketsValue;
                        }
                    }
                });

                $.each(data, function (i, value) {
                    that.totalCount += eval(objName);
                });

                if (depth == 0) {
                    $.each(data, function (i, value) {
                        if (i > maxChartCount) {
                            parent.setSubtitle(maxChartCount, data.length, parent.firstName);
                            return false;
                        }
                        that.firstDataPush(value.val, eval(objName), i);
                    });
                } else {
                    $.each(data, function (i, value) {
                        if (i > maxChartCount) {
                            parent.setSubtitle(maxChartCount, data.length, parent.firstName);
                            return false;
                        }
                        if (value.buckets == null) {
                            that.firstDataPush(value.val, eval(objName), i);
                        } else {
                            that.firstDataPush(value.val, eval(objName), i);
                            var bucketsCount = value.buckets.length;
                            $.each(value.buckets, function (j, value2) {
                                if (j > maxChartCount) {
                                    parent.setSubtitle(maxChartCount, value.buckets.length, parent.secondName);
                                    return false;
                                }
                                that.secondDataPush("[" + value.val + "] " + value2.val, eval("value2." + objValue), i, 0.2 - (j / bucketsCount) / 5);
                            });
                        }
                    });
                }
                this.firstData = this.firstData.sort(parent.sort);
                this.secondData = this.secondData.sort(parent.sort);
            }
        },
        lineChart: function (id, data, objValue, column, parent) {

            $(id).highcharts({
                chart: {
                    type: column,
                    events: {
                        selection: function (event) {
                            var text,
                                label;
                            if (event.xAxis) {
                                text = 'min: ' + Highcharts.numberFormat(event.xAxis[0].min, 2) + ', max: ' + Highcharts.numberFormat(event.xAxis[0].max, 2);
                            } else {
                                text = 'Selection reset';
                            }
                            label = this.renderer.label(text, 100, 120)
                                .attr({
                                    fill: Highcharts.getOptions().colors[0],
                                    padding: 10,
                                    r: 5,
                                    zIndex: 8
                                })
                                .css({
                                    color: '#FFFFFF'
                                })
                                .add();

                            setTimeout(function () {
                                label.fadeOut();
                            }, 1000);
                        }
                    },
                    zoomType: 'x'
                },
                exporting: chartAPI.exporting,
                credits: chartAPI.credits,
                title: {
                    text: this.title
                },
                subtitle: {
                    text: ""
                },
                xAxis: {
                    categories: data.categories
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: ""
                    },
                    labels: {
                        formatter: function () {
                            return parent.setCountKind(objValue, this.value);
                        }
                    }
                },
                plotOptions: {
                    series: {
                        cursor: 'pointer',
                        events: {
                            click: function (event) {
                                setQuery(event.point.category, this.name, event.point.y, false);
                            }
                        }
                    }
                },
                series: data.series
            });
        },
        barChart: function (id, data, objValue, column, parent) {
            $(id).highcharts({
                chart: {
                    type: column,
                    events: {
                        selection: function (event) {
                            var text,
                                label;
                            if (event.xAxis) {
                                text = 'min: ' + Highcharts.numberFormat(event.xAxis[0].min, 2) + ', max: ' + Highcharts.numberFormat(event.xAxis[0].max, 2);
                            } else {
                                text = 'Selection reset';
                            }
                            label = this.renderer.label(text, 100, 120)
                                .attr({
                                    fill: Highcharts.getOptions().colors[0],
                                    padding: 10,
                                    r: 5,
                                    zIndex: 8
                                })
                                .css({
                                    color: '#FFFFFF'
                                })
                                .add();

                            setTimeout(function () {
                                label.fadeOut();
                            }, 1000);
                        }
                    },
                    zoomType: 'x'
                },
                exporting: chartAPI.exporting,
                credits: chartAPI.credits,
                title: {
                    text: this.title
                },
                subtitle: {
                    text: ""
                },
                xAxis: {
                    categories: data.categories
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: ""
                    },
                    labels: {
                        formatter: function () {
                            return parent.setCountKind(objValue, this.value);
                        }
                    },
                },

                tooltip: {
                    headerFormat: '<b>{point.x}</b><br/>',
                    pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
                },
                plotOptions: {
                    series: {
                        cursor: 'pointer',
                        events: {
                            click: function (event) {
                                setQuery(event.point.category, this.name, event.point.y, false);
                            }
                        }
                    },
                    column: {
                        stacking: 'normal'
                    }
                },
                series: data.series
            });
        },
        pieBasicChart: function (id, data, objValue, column, parent) {
            $(id).highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: column
                },
                exporting: chartAPI.exporting,
                credits: chartAPI.credits,
                title: {
                    text: this.title
                },
                subtitle: {
                    text: ""
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    series: {
                        cursor: 'pointer',
                        events: {
                            click: function (event) {
                                setQuery(this.name, event.point.name, event.point.y, true);
                            }
                        }
                    },
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                            style: {
                                color: (Highcharts.colors) || 'black'
                            }
                        }
                    }
                },
                series: [{
                    name: data.firstName,
                    colorByPoint: true,
                    data: data.firstData
                }]
            });
        },
        pieDonutChart: function (id, data, objValue, column, parent) {
            $(id).highcharts({
                chart: {
                    type: column
                },
                exporting: chartAPI.exporting,
                credits: chartAPI.credits,
                title: {
                    text: this.title
                },
                subtitle: {
                    text: ""
                },
                yAxis: {
                    title: {
                        text: ""
                    }
                },
                tooltip: {
                    valueSuffix: '%'
                },
                plotOptions: {
                    series: {
                        cursor: 'pointer',
                        events: {
                            click: function (event) {
                                setQuery(this.name, event.point.name, event.point.y, true);
                            }
                        }
                    },
                    pie: {
                        shadow: false,
                        center: ['50%', '50%']
                    }
                },
                series: [{
                    name: data.firstName,
                    data: data.firstData,
                    size: '60%',
                    dataLabels: {
                        formatter: function () {
                            return this.y > 5 ? this.point.name : null;
                        },
                        color: '#ffffff',
                        distance: -30,
                        style: {
                            textShadow: '0 0 6px #000000, 0 0 3px #000000'
                        }
                    }
                }, {
                    name: data.secondName,
                    data: data.secondData,
                    size: '80%',
                    innerSize: '60%',
                    dataLabels: {
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                        formatter: function () {
                            return this.y > 1 ? '<b>' + this.point.name + ':</b> ' + this.y + '%' : null;
                        }
                    }
                }]
            });
        },
        setCountKind: function (objValue, value) {
            if (objValue == "count") {
                return value;
            } else {
                if (this.value < 1001) {
                    return value + "byte";
                } else if (value > 1000 && value < 1000001) {
                    return Math.round(value / 1000) + "Kb";
                } else if (value > 1000000 && value < 1000000001) {
                    return Math.round(value / 1000 / 1000) + "Mb";
                } else {
                    return Math.round(value / 1000 / 1000 / 1000) + "Gb";
                }
            }
            return value;
        }
    };

</script>