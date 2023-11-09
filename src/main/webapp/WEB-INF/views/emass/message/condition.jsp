<%@page import="com.xcurenet.common.util.config.Config"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<% boolean isOCRCheck = Config.isOCR; %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>


<style type="text/css">
.bootstrap-select.btn-group[class*=col-] .dropdown-menu.open {
	left: 0;
	right: auto;
}

.selecBtnArea .btn, .select-xs .btn {
	padding: 6px 25px 5px 10px;
	font-size: 12px;
}

.selecBtnArea .bootstrap-select {
	margin-bottom: 2px;
}

.bootstrap-select{
	display:inline-block;
}
.bootstrap-select button{
	border-radius:0;
}

.input-xs {
	height: 22px;
	padding: 2px 5px;
	font-size: 12px;
	line-height: 1.5;
	border-radius: 3px;
}

table, th, tr, td {
	border: 0px !important;
	padding: 2px 4px 3px 4px !important;
	text-align: left;
}

table {
	max-width: 900px;
	margin: auto;
	text-align: center;
}

th {
	padding-top: 2px !important;
	line-height: 30px !important;
}

#detailCondition .panel-body {
	padding-top: 15px;
}

#selectedCodeTitle, #selectedCodeTitlePop {
	display:none;
	border: 1px solid #458A45;
	position: absolute;
	background-color: #5CB85C;
	color: #fff;
	z-index: 999;
	font-size: 15px;
	padding: 3px;
	max-width: 400px;
	word-break: break-all;
}

.border-right-radius-none{
	border-top-right-radius:0;
	border-bottom-right-radius:0;
}
.border-left-radius-none{
	border-top-left-radius:0;
	border-bottom-left-radius:0;
}
.border-radius-none{
	border-radius:0;
}

.filterBtn label{
	border-radius:0;
}
.leftTd{
	
}
.form-inline .input-group > .form-control {
    width: 100% !important;
}
</style>
<script type="text/javascript">
var condition = {
	messageInputFilter:'<s:message code="condition.message.input.filter"/>',
	messageInputPeriod:'<s:message code="condition.message.input.period"/>',
	consentMsgTimecheck:'<s:message code="consent.msg.timecheck"/>',
	messageNumbercheck:'<s:message code="condition.message.numbercheck"/>',
	messageFolderFilter:'<s:message code="condition.message.folder.filter"/>',
	messageSelectFolder:'<s:message code="condition.message.select.folder"/>',
	msgSaved:'<s:message code="common.msg.saved"/>',
	selectInterest:'<s:message code="condition.select.interest"/>',
	interestUserAll:'<s:message code="interest.user.all"/>',
	commonMsgAll:'<s:message code="common.msg.all"/>',
	searchFieldAll:'<s:message code="condition.field.search.all"/>',
	serviceAll:'<s:message code="condition.service.all"/>',
	orgBusiAll:'<s:message code="common.org.busi.all"/>',
	orgDeptAll:'<s:message code="common.org.dept.all"/>',
	msgSelect_all:'<s:message code="common.msg.select_all"/>',
	msgUnselect_all:'<s:message code="common.msg.unselect_all"/>',
	msgNoresult:'<s:message code="common.msg.noresult"/>',
	msgConnectError:'<s:message code="common.msg.connect.error"/>',
	messageSelectDashboard:'<s:message code="condition.message.select.dashboard"/>',
	msgConfirmSave:'<s:message code="common.msg.confirm.save"/>',
	searchService:'<s:message code="condition.search.service"/>',
	delMsgFolderMsg:'<s:message code="filterInfo.delMsgFolderMsg"/>',
	delMsgFoldercomplMsg:'<s:message code="filterInfo.delMsgFoldercomplMsg"/>',
	userGroupNaviTitle2:'<s:message code="userGroup.navi.title2"/>'
};
function openCodeWindow(id, oldCode, oldConm){
	$('#oldCode').val(oldCode);
	$('#oldConm').val(oldConm);
	
	var url    = '<c:url value="/commons/selectCode.do?codeType='+id+'"/>';
	fnOpenWindow('', 'selectCodeWinPopup', 1200, 700, 'resize');
	
	$('#codeParam').attr('target','selectCodeWinPopup');
	$('#codeParam').attr('action', url);
	$('#codeParam').attr('method','post');
	$('#codeParam').submit();
}
</script>
<div class="panel panel-default" style="height:calc(100% - 34px);min-width:770px; margin-left: 10px;" id="detailCondition">
	<div class="panel-body">
		<div id="defaultConditionArea">
			<div id="selectedCodeTitle"></div>
			<table class="table table-bordered" style="margin-bottom:0;width:930px;">
				<colgroup>
					<col width="670">
					<col width="260">
				</colgroup>
				<tr>
					<td class="leftTd">
						<div class="form-group" style="float:left;">
							<div class="form-group form-inline not-dashed" style="float:left;width:356px;">
								<div class="input-group">
									<div class="input-group date" id="startdatepicker" style="width:160px;">
										<input type="text" id="startDt" class="input-xs form-control border-radius-none" />
										<span class="input-group-addon startDateBtn border-radius-none" style="padding: 0px 5px;"> <span class="glyphicon glyphicon-calendar"></span>
										</span>
									</div>
								</div>
								<span>~</span>
								<div class="input-group">
									<div class="input-group date" id="enddatepicker" style="width:160px;">
										<input type="text" id="endDt" class="input-xs form-control border-radius-none"/>
										<span class="input-group-addon endDateBtn border-radius-none" style="padding: 0px 5px;"><span class="glyphicon glyphicon-calendar"></span></span>
									</div>
								</div>
							</div>
						</div>
						<div class="btn-group filterBtn" data-toggle="buttons">
							<label class="btn btn-xs btn-default active"><input type="radio" name="receiveSend" id="receiveSendAll" value="" checked><s:message code="condition.receive_send.all"/></label>
							<label class="btn btn-xs btn-default"><input type="radio" name="receiveSend" id="receiveOnly" value="I"> <s:message code="condition.receive"/></label>
							<label class="btn btn-xs btn-default"><input type="radio" name="receiveSend" id="sendOnly" value="O"> <s:message code="condition.send"/></label>
						</div>
					</td>
					<td>
						<div class="btn-group filterBtn" data-toggle="buttons">
							<label class="btn btn-xs btn-default active"><input type="radio" name="readYn" id="readAll" value="" checked> <s:message code="condition.isread.all"/></label>
							<label class="btn btn-xs btn-default"><input type="radio" name="readYn" id="readY" value="Y"> <s:message code="condition.read"/></label>
							<label class="btn btn-xs btn-default"><input type="radio" name="readYn" id="readN" value="N"> <s:message code="condition.unread"/></label>
						</div>
					</td>
				</tr>
				<tr>
					<td class="leftTd">
						<div class="btn-group filterBtn" data-toggle="buttons" style="float:left;padding-right:15px;">
							<label class="btn btn-xs btn-default" style="padding:1px 6px;"><input type="radio" name="easyDate" value="1"> <s:message code="condition.today"/></label>
							<label class="btn btn-xs btn-default"><input type="radio" name="easyDate" value="2"> <s:message code="condition.yesterday"/></label>
							<label class="btn btn-xs btn-default active"><input type="radio" name="easyDate" value="3" checked> <s:message code="condition.week" arguments="1" argumentSeparator="|"/></label>
							<label class="btn btn-xs btn-default" style="display:none;"><input type="radio" name="easyDate" value="4"> <s:message code="condition.week" arguments="2" argumentSeparator="|"/></label>
							<label class="btn btn-xs btn-default" style="display:none;"><input type="radio" name="easyDate" value="5"> <s:message code="condition.week" arguments="3" argumentSeparator="|"/></label>
							<label class="btn btn-xs btn-default"><input type="radio" name="easyDate" value="6"> <s:message code="condition.month" arguments="1" argumentSeparator="|"/></label>
							<label class="btn btn-xs btn-default"><input type="radio" name="easyDate" value="7"> <s:message code="condition.month" arguments="2" argumentSeparator="|"/></label>
							<label class="btn btn-xs btn-default" style="display:none;"><input type="radio" name="easyDate" value="8"> <s:message code="condition.month" arguments="3" argumentSeparator="|"/></label>
						</div>
						<div class="form-group" style="float:left;">
							<div class="btn-group filterBtn" data-toggle="buttons">
								<label class="btn btn-xs btn-default active"><input type="radio" name="ctimeWork" value="" checked> <s:message code="condition.ctimework.all"/></label>
								<label class="btn btn-xs btn-default"><input type="radio" name="ctimeWork" value="W"> <s:message code="condition.work"/></label>
								<label class="btn btn-xs btn-default"><input type="radio" name="ctimeWork" value="R"> <s:message code="condition.notwork"/></label>
							</div>
						</div>
					</td>
					<td>
						<div class="form-group">
							<div class="btn-group filterBtn" data-toggle="buttons">
								<label class="btn btn-xs btn-default active"><input type="radio" name="attachYn" id="attachAll" value="" checked> <s:message code="condition.isattached.all"/></label>
								<label class="btn btn-xs btn-default"><input type="radio" name="attachYn" id="attachY" value="Y"> <s:message code="condition.exist"/></label>
								<label class="btn btn-xs btn-default"><input type="radio" name="attachYn" id="attachN" value="N"> <s:message code="condition.none"/></label>
							</div>
							<span id="attachBtnArea" style="display:none;">
								<button type="button" class="btn btn-xs btn-default btn-open filterAddBtn" accesskey="A" id="attachBtn"><span class="glyphicon glyphicon-plus-sign"></span> <s:message code="condition.select"/></button>
							</span>
							<span id="attachSelectedArea" class="codeSelectedBtn">
								<button type="button" class="btn">0</button>
							</span>
							<input type="hidden" id="attachStr">
							<input type="hidden" id="attachVal" class="selectedTitle">
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div id="plusConditionArea" style="display:none;">
			<table class="table table-bordered" style="margin-bottom:0;width:930px;">
				<colgroup>
					<col width="670">
					<col width="260">
				</colgroup>
				<tr>
					<td class="leftTd">
						<div class="form-inline not-dashed" style="padding-left:1px;">
							<div class="input-group select-xs" style="width:225px;display:inline-block;">
								<select id="busiSelect" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
							</div>
							<span style="width:5px;">&nbsp;</span>
							<div class="btn-group" data-toggle="buttons">
								<button type="button" class="btn btn-sm btn-default" id="dept" style="border-radius: 0;"><span class="glyphicon glyphicon-plus-sign"></span> <s:message code="common.org.choose.dept"/></button>
								<span id="deptSelectedArea" class="codeSelectedBtn">
									<button type="button" class="btn">0</button>
								</span>
								<input type="hidden" id="deptStr" class="selectedTitle">
								<input type="hidden" id="deptVal">
							</div>
						</div>
					</td>
					<td>
						<div class="form-inline not-dashed">
							<div class="btn-group filterBtn" data-toggle="buttons">
								<label class="btn btn-xs btn-default active"><input type="radio" name="keywordYn" id="keywordAll" value="" checked> <s:message code="condition.keyword.all"/></label>
								<label class="btn btn-xs btn-default"><input type="radio" name="keywordYn" id="keywordY" value="Y"> <s:message code="condition.exist"/></label>
								<label class="btn btn-xs btn-default"><input type="radio" name="keywordYn" id="keywordN" value="N"> <s:message code="condition.none"/></label>
							</div>
							<span id="keywordBtnArea" style="display:none;">
								<button type="button" class="btn btn-xs btn-default btn-open filterAddBtn" accesskey="K" id="keywordBtn"><span class="glyphicon glyphicon-plus-sign"></span> <s:message code="condition.select"/></button>
							</span>
							<span id="keywordSelectedArea" class="codeSelectedBtn">
								<button type="button" class="btn">0</button>
							</span>
							<input type="hidden" id="keywordStr" class="selectedTitle">
							<input type="hidden" id="keywordVal">
						</div>
					</td>
				</tr>	
				<tr>
					<td class="leftTd">
						<div class="form-inline not-dashed">
							<div class="input-group" style="width:480px;padding-right:5px;">
		      					<input type="text" class="form-control input-xs border-radius-none" placeholder="<s:message code="condition.message.sender"/>" id="senders">
							</div>
						</div>
					</td>
					<td>
						<div class="form-inline not-dashed">
							<div class="btn-group filterBtn" data-toggle="buttons">
								<label class="btn btn-xs btn-default active"><input type="radio" name="regexpYn" id="regexpAll" value="" checked> <s:message code="condition.regexp.all"/></label>
								<label class="btn btn-xs btn-default"><input type="radio" name="regexpYn" id="regexpY" value="Y"> <s:message code="condition.exist"/></label>
								<label class="btn btn-xs btn-default"><input type="radio" name="regexpYn" id="regexpN" value="N"> <s:message code="condition.none"/></label>
							</div>
							<span id="regexpBtnArea" style="display:none;">
								<button type="button" class="btn btn-xs btn-default btn-open filterAddBtn" accesskey="P" id="regexpBtn"><span class="glyphicon glyphicon-plus-sign"></span> <s:message code="condition.select"/></button>
							</span>
							<span id="regexpSelectedArea" class="codeSelectedBtn">
								<button type="button" class="btn">0</button>
							</span>
							<input type="hidden" id="regexpStr" class="selectedTitle">
							<input type="hidden" id="regexpVal">
						</div>
					</td>
				</tr>
				<tr>
					<td class="leftTd">
						<div class="form-inline not-dashed">
							<div class="input-group" style="width:480px;padding-right:5px;float:left;">
								<input type="text" class="form-control input-xs border-radius-none" placeholder="<s:message code="condition.message.receiver"/>" id="receivers">
							</div>
						</div>
					</td>
					<td>
						<div class="form-inline not-dashed">
							<div class="btn-group filterBtn" data-toggle="buttons">
								<label class="btn btn-xs btn-default active"><input type="radio" name="regexp_drmYn" id="regexp_drmAll" value="" checked> <s:message code="condition.drm.all"/></label>
								<label class="btn btn-xs btn-default"><input type="radio" name="regexp_drmYn" id="regexp_drmY" value="Y"> <s:message code="condition.exist"/></label>
								<label class="btn btn-xs btn-default"><input type="radio" name="regexp_drmYn" id="regexp_drmN" value="N"> <s:message code="condition.none"/></label>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td class="leftTd">
						<div class="form-inline not-dashed">
							<div class="selecBtnArea" style="width:480px;float: left;padding-right:10px;">
								<select class="selectpicker col-xs" id="allOfus" style="width:100%;">
									<option value=""><s:message code="condition.allofus.all"/></option>
									<option value="IA">1) <s:message code="condition.allofus1"/></option> 
									<option value="EA">2) <s:message code="condition.allofus2"/></option> 
									<option value="PA">3) <s:message code="condition.allofus3"/></option> 
									<option value="IA|EA">4) <s:message code="condition.allofus4"/></option> 
									<option value="EA|PA">5) <s:message code="condition.allofus5"/></option> 
									<option value="IA|PA">6) <s:message code="condition.allofus6"/></option> 
									<option value="IA|IT">7) <s:message code="condition.allofus7"/></option> 
									<option value="ET|EA">8) <s:message code="condition.allofus8"/></option> 
									<option value="PT|PA">9) <s:message code="condition.allofus9"/></option> 
									<option value="IA|ET|IT|EA">10) <s:message code="condition.allofus10"/></option> 
									<option value="IA|IT|PT|PA">11) <s:message code="condition.allofus11"/></option> 
									<option value="ET|EA|PT|PA">12) <s:message code="condition.allofus12"/></option>
									<option value="SO">13) <s:message code="condition.allofus13"/></option>
									<option value="SI">14) <s:message code="condition.allofus14"/></option>
								</select>
							</div> 
						</div>
					</td>
					<td>
						<div class="form-inline not-dashed select-xs">
							<select class="selectpicker" data-style="btn-default" id="userGroupSeq">
							</select>
						</div>
						<input type="hidden" id="userGroupStr" >
					</td>
				</tr>
				<tr>
					<td class="leftTd">
						<div class="form-inline not-dashed">
							<div class="selecBtnArea" style="width:100px;float: left;padding-right:10px;">
								<select class="selectpicker col-xs" data-style="btn-default" id="sizeFilterType">
									<option value=""><s:message code="condition.size.all"/></option>
									<option value="B"><s:message code="condition.size.body"/></option>
									<option value="A"><s:message code="condition.size.attach"/></option>
								</select>
							</div>
							<div class="selecBtnArea" style="width:80px;float: left;padding-right:10px;">
							<!--<select id="busiSelect" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>-->
								<select class="selectpicker col-xs" data-style="btn-default" id="sizeFilterSelect">
									<option value="L"><s:message code="condition.over"/></option>
									<option value="S"><s:message code="condition.below"/></option>
									<option value="B"><s:message code="condition.range"/></option>
								</select>
							</div>
							<div style="width:150px;padding:1px 5px 0px 5px;float: left;">
								<div id="size-setup" style="margin-bottom:10px;"></div>
							</div>
							<div style="width:180px;padding-left:15px;float: left;height:30px;line-height:30px;">
								<span id="sizeStartValStr" style="line-height:20px;"></span><input type="text" id="sizeStartVal" style="width:90px;height:30px;display:none;" maxlength="11">
								<span id="sizeRangeValStr" style="display:none;"> ~ </span>
								<span id="sizeEndValStr" style="display:none;"></span><input type="text" id="sizeEndVal" style="width:90px;height:30px;display:none;" maxlength="11">
							</div>
						</div>
					</td>
					<td>
						<div class="form-inline not-dashed select-xs">
							<select class="selectpicker" data-style="btn-default" id="userSeq">
								<option>-<s:message code="condition.select.interest"/>-</option>
							</select>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>


<div class="modal fade smartFilterSave" id="smartFilterSavePop" tabindex="-1" role="dialog" aria-labelledby="attachModal">
	<input type="hidden" id="modalType"/>
	<div class="modal-dialog modal-lg" role="document" style="width:1200px;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title"><s:message code="condition.save"/></h3>
			</div>
			<div class="modal-body">
				<div class="form-inline">
					<label for="filterNamePopInput" class="control-label col-xs-2"><s:message code="condition.name"/></label>
					<input type="text" class="form-control" style="width:460px;" name="attachName" id="filterNamePopInput" placeholder="<s:message code="condition.name"/>" required maxlength="128">
				</div>
				<div class="form-inline">
					<label for="datePopArea" class="control-label col-xs-2"><s:message code="condition.period"/></label>
					<div id="datePopArea" style="padding-right:15px;">
						<select class="selectpicker col-xs col-xs-3" id="filterOptionPopSelect">
							<option value="1"><s:message code="condition.period.default"/></option>
							<option value="2"><s:message code="condition.period.change"/></option>
							<option value="3"><s:message code="condition.period.input"/></option>
						</select>
						<div id="normalDateArea" style="float:right;">
							<div class="input-group date col-xs-3" id="startdatepickerPop">
								<input type="text" class="form-control" id="startDtPop" style="padding:2px 5px;position: relative;width:160px !important;"/>
								<span class="input-group-addon startDateBtn" style="padding:6px 8px;"> <span class="glyphicon glyphicon-calendar"></span></span>
							</div>
							<span>~</span>
							<div class="input-group date col-xs-3" id="enddatepickerPop">
								<input type="text" class="form-control" id="endDtPop" style="padding:2px 5px;position: relative;width:160px !important;"/>
								<span class="input-group-addon endDateBtn" style="padding:6px 8px;"> <span class="glyphicon glyphicon-calendar"></span></span>
							</div>
						</div>
						<div id="simpleDateArea" style="display:none;float:right;">
							[<s:message code="condition.standard"/>] 
							<input type="text" class="input-xs form-control" id="startDayPop" style="padding:2px 5px;position: relative;width:40px;"/> <s:message code="condition.before"/> ~
							<input type="text" class="input-xs form-control" id="endDayPop" style="padding:2px 5px;position: relative;width:40px;"/> <s:message code="condition.before"/>
						</div>
						<div id="noselectDateArea" style="display:none;height:34px;float:right;">
							<span style="height:34px;line-height: 34px;"><s:message code="condition.message.input"/></span>
						</div>
					</div>
				</div>
				<div class="form-inline" id="dashboardSetup" style="display: none;">
					<label for="dashboardsetupArea" class="control-label col-xs-2"><s:message code="condition.dashboard.setting"/></label>
					<div class="btn-group filterBtn" data-toggle="buttons" id="dashboardsetupArea">
						<label class="btn btn-sm btn-default active"><input type="radio" name="dashboardSelPop" value="" checked> <s:message code="condition.unselect"/></label>
						<label class="btn btn-sm btn-default"><input type="radio" name="dashboardSelPop" value="user.filter1"> <s:message code="condition.position" arguments="1" argumentSeparator="|"/></label>
						<label class="btn btn-sm btn-default"><input type="radio" name="dashboardSelPop" value="user.filter2"> <s:message code="condition.position" arguments="2" argumentSeparator="|"/></label>
						<label class="btn btn-sm btn-default"><input type="radio" name="dashboardSelPop" value="user.filter3"> <s:message code="condition.position" arguments="3" argumentSeparator="|"/></label>
						<label class="btn btn-sm btn-default"><input type="radio" name="dashboardSelPop" value="user.filter4"> <s:message code="condition.position" arguments="4" argumentSeparator="|"/></label>
					</div>
					<div style="float:right;padding-top:7px;">
						<s:message code="condition.message.position"/>
					</div>
				</div>
				<div class="form-inline">
					<label for="filterTypeArea" class="control-label col-xs-2"> <s:message code="condition.filter_type"/></label>
					<div class="btn-group filterBtn" data-toggle="buttons" id="filterTypeArea">
						<label class="btn btn-sm btn-default active"><input type="radio" name="filterTypePop" value="D" checked> <s:message code="condition.condition_filter"/></label>
						<label class="btn btn-sm btn-default"><input type="radio" name="filterTypePop" value="Q"> <s:message code="condition.advance_filter"/></label>
					</div>
				</div>
				<div class="form-inline" id="selectQueryPopArea">
					<label for="queryDataArea" class="control-label col-xs-2"><s:message code="condition.advance"/></label>
					<div class="btn-group filterBtn" data-toggle="buttons" id="queryDataArea">
						<textarea rows="5" id="queryInputTextareaPop" style="width:700px;padding:10px;"></textarea>
					</div>
				</div>
				<div class="form-inline" id="selectConditionPopArea">
					<div class="form-inline" id="savePathPopDiv" style="display:none;">
						<label for="savePathPopArea" class="control-label col-xs-2"><s:message code="condition.savepath"/></label>
						<div class="form-control" id="savePathPopArea" style="height:350px;width:700px;">
							<ul id="filterTreePop" class="ztree scrollbar" style="height:100%;width:100%;overflow:auto;"></ul>
						</div>
					</div>
					<div class="form-inline" id="selectConditionPopDiv">
						<label for="selectedConditionPopArea" class="control-label col-xs-2"><s:message code="condition.filter_setting"/></label>
						<div class="form-control" id="selectedConditionPopArea" style="height:430px;width:950px;">
							<div id="selectedCodeTitlePop"></div>
							<table class="table table-bordered" style="margin-bottom:0;width:100%;">
								<colgroup>
									<col width="135">
									<col width="*">
									<col width="150">
									<col width="230">
								</colgroup>
								<tr>
									<th>
										<s:message code="condition.search_str"/>
									</th>
									<td>
										<input type="search" class="form-control mainInput" id="searchStrInputPop" placeholder=" <s:message code="condition.search_all"/>" style="width:320px;"/>
										<label style="display:none;"><input type="checkbox" name="researchCheckboxPop" id="researchCheckboxPop"><span class="fa fa-check"></span><s:message code="condition.research"/></label>
									</td>
									<th>
										<s:message code="condition.order"/>
									</th>
									<td>
										<div style="float:left;" id="messageSortDivPop">
											<select id="messageSortPop" class="selectpicker" data-style="btn-sm btn-default">
												<option value="ctime desc">▼ <s:message code="condition.date"/></option>
												<option value="ctime asc">▲ <s:message code="condition.date"/></option>
												<option value="pi_total desc">▼ <s:message code="condition.regexp"/></option>
												<option value="pi_total asc">▲ <s:message code="condition.regexp"/></option>
												<option value="size desc">▼ <s:message code="condition.size.all"/></option>
												<option value="size asc">▲ <s:message code="condition.size.all"/></option>
												<option value="body_size desc">▼ <s:message code="condition.size.body"/></option>
												<option value="body_size asc">▲ <s:message code="condition.size.body"/></option>
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th><s:message code="condition.field.search"/></th>
									<td>
										<select id="searchFieldPop" class="selectpicker" data-style="btn-default" style="border-left:1px solid #337ab7;">
											<option value=""><s:message code="condition.field.search"/></option>
											<option value="subject"><s:message code="condition.subject"/></option>
											<option value="body.text"><s:message code="condition.body"/></option>
											<option value="attach.name attach.text"><s:message code="condition.attach_name"/></option>
											<%if(!isOCRCheck){ %>
											<option value="attach"><s:message code="condition.attach"/></option>
											<%}else{ %>
											<option value="attach ocr_attach"><s:message code="condition.attach"/></option>
											<option value="ocr_attach">OCR</option>
											<%} %>
											<option value="http.host">Host</option>
											<option value="filePath">Path</option>
											<option value="network.srcip"><s:message code="condition.source"/> IP</option>
											<option value="network.dstip"><s:message code="condition.destination"/> IP</option>
											<option value="sender_str"><s:message code="condition.sender"/></option>
											<option value="sname"><s:message code="condition.sender_name"/></option>
											<option value="mail.to.email"><s:message code="condition.recv"/></option>
											<option value="mail.to.name mail.cc.name mail.bcc.name"><s:message code="condition.recv_name"/></option>
											<option value="mail.to.name"><s:message code="condition.recv"/>(<s:message code="condition.to"/>)</option>
											<option value="mail.cc.name "><s:message code="condition.recv"/>(<s:message code="condition.cc"/>)</option>
											<option value="mail.bcc.name "><s:message code="condition.recv"/>(<s:message code="condition.bcc"/>)</option>
											<option value="user.name user.id"><s:message code="common.org.user"/></option>
											<option value="account_user"><s:message code="common.msg.account"/></option>
										</select>
										<div class="btn-group filterBtn" data-toggle="buttons" style="display:none;">
											<label class="btn btn-xs btn-default"><input type="radio" name="easyDatePop" value="1"> <s:message code="condition.today"/></label>
											<label class="btn btn-xs btn-default"><input type="radio" name="easyDatePop" value="2"> <s:message code="condition.yesterday"/></label>
											<label class="btn btn-xs btn-default active"><input type="radio" name="easyDatePop" value="3" checked> <s:message code="condition.week" arguments="1" argumentSeparator="|"/></label>
											<label class="btn btn-xs btn-default"><input type="radio" name="easyDatePop" value="4"> <s:message code="condition.week" arguments="2" argumentSeparator="|"/></label>
											<label class="btn btn-xs btn-default" style="display:none;"><input type="radio" name="easyDatePop" value="5"> <s:message code="condition.week" arguments="3" argumentSeparator="|"/></label>
											<label class="btn btn-xs btn-default"><input type="radio" name="easyDatePop" value="6"> <s:message code="condition.month" arguments="1" argumentSeparator="|"/></label>
											<label class="btn btn-xs btn-default"><input type="radio" name="easyDatePop" value="7"> <s:message code="condition.month" arguments="2" argumentSeparator="|"/></label>
											<label class="btn btn-xs btn-default" style="display:none;"><input type="radio" name="easyDatePop" value="8"> <s:message code="condition.month" arguments="3" argumentSeparator="|"/></label>
										</div>
									</td>
									<th>
										<s:message code="condition.ctimework"/>
									</th>
									<td>
										<div class="form-group" style="float:left;">
											<div class="btn-group filterBtn" data-toggle="buttons">
												<label class="btn btn-xs btn-default active"><input type="radio" name="ctimeWorkPop" value="" checked> <s:message code="common.msg.all"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="ctimeWorkPop" value="W"> <s:message code="condition.work"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="ctimeWorkPop" value="R"> <s:message code="condition.notwork"/></label>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th><s:message code="condition.service"/></th>
									<td>
										<select id="serviceTypeSelectPop" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
									</td>
									<th><s:message code="condition.isread"/></th>
									<td>
										<div class="form-group">
											<div class="btn-group filterBtn" data-toggle="buttons">
												<label class="btn btn-xs btn-default active"><input type="radio" name="readYnPop" id="readAllPop" value="" checked> <s:message code="common.msg.all"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="readYnPop" id="readYPop" value="Y"> <s:message code="condition.read"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="readYnPop" id="readNPop" value="N"> <s:message code="condition.unread"/></label>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th><s:message code="condition.organization"/></th>
									<td>
										<div class="form-group">
											<div class="input-group">
												<select id="busiSelectPop" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
											</div>
											<span>&nbsp;&nbsp;</span>
											<div class="btn-group" data-toggle="buttons">
												<button type="button" class="btn btn-sm btn-default" id="deptPop" style="height:34px;border-radius: 0;"><span class="glyphicon glyphicon-plus-sign"></span> <s:message code="common.org.choose.dept"/></button>
												<span id="deptSelectedAreaPop" class="codeSelectedBtn">
													<button type="button" class="btn">0</button>
												</span>
												<input type="hidden" id="deptStrPop" class="selectedTitle">
												<input type="hidden" id="deptValPop">
											</div>
										</div>
									</td>
									<th><s:message code="condition.isattached"/></th>
									<td>
										<div class="form-group">
											<div class="btn-group filterBtn" data-toggle="buttons">
												<label class="btn btn-xs btn-default active"><input type="radio" name="attachYnPop" id="attachAllPop" value="" checked> <s:message code="common.msg.all"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="attachYnPop" id="attachYPop" value="Y"> <s:message code="condition.exist"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="attachYnPop" id="attachNPop" value="N"> <s:message code="condition.none"/></label>
											</div>
											<span id="attachBtnAreaPop" style="display:none;">
												<button type="button" class="btn btn-xs btn-default btn-open filterAddBtnPop" accesskey="A" id="attachBtnPop"><span class="glyphicon glyphicon-plus-sign"></span> <s:message code="condition.select"/></button>
											</span>
											<span id="attachSelectedAreaPop" class="codeSelectedBtn">
												<button type="button" class="btn">0</button>
											</span>
											<input type="hidden" id="attachStrPop">
											<input type="hidden" id="attachValPop" class="selectedTitle">
										</div>
										<div style="width:65px; text-align: right;float: left;">
											
										</div>
									</td>
								</tr>	
								<tr>
									<th><s:message code="condition.receiver_sender"/></th>
									<td>
										<div class="form-group">
											<div class="input-group">
						      					<input type="text" class="form-control input-xs border-radius-none" placeholder="<s:message code="condition.sender"/>" id="sendersPop">
											</div>
											<span>&nbsp;&nbsp;</span>
											<div class="input-group">
												<input type="text" class="form-control input-xs border-radius-none" placeholder="<s:message code="condition.recv"/>" id="receiversPop">
											</div>
										</div>
									</td>
									<th><s:message code="condition.keyword"/></th>
									<td>
										<div class="form-group">
											<div class="btn-group filterBtn" data-toggle="buttons">
												<label class="btn btn-xs btn-default active"><input type="radio" name="keywordYnPop" id="keywordAllPop" value="" checked> <s:message code="common.msg.all"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="keywordYnPop" id="keywordYPop" value="Y"> <s:message code="condition.exist"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="keywordYnPop" id="keywordNPop" value="N"> <s:message code="condition.none"/></label>
											</div>
											<span id="keywordBtnAreaPop" style="display:none;">
												<button type="button" class="btn btn-xs btn-default btn-open filterAddBtnPop" accesskey="K" id="keywordBtnPop"><span class="glyphicon glyphicon-plus-sign"></span> <s:message code="condition.select"/></button>
											</span>
											<span id="keywordSelectedAreaPop" class="codeSelectedBtn">
												<button type="button" class="btn">0</button>
											</span>
											<input type="hidden" id="keywordStrPop" class="selectedTitle">
											<input type="hidden" id="keywordValPop">
										</div>
									</td>
								</tr>
								<tr>
									<th><s:message code="userGroup.navi.title2"/></th>
									<td>
										<div class="select-xs">
											<select class="selectpicker" data-style="btn-default" id="userGroupSeqPop">
											</select>
										</div>
									</td>
									<th><s:message code="condition.regexp"/></th>
									<td>
										<div class="form-group">
											<div class="btn-group filterBtn" data-toggle="buttons">
												<label class="btn btn-xs btn-default active"><input type="radio" name="regexpYnPop" id="regexpAllPop" value="" checked> <s:message code="common.msg.all"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="regexpYnPop" id="regexpYPop" value="Y"> <s:message code="condition.exist"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="regexpYnPop" id="regexpNPop" value="N"> <s:message code="condition.none"/></label>
											</div>
											<span id="regexpBtnAreaPop" style="display:none;">
												<button type="button" class="btn btn-xs btn-default btn-open filterAddBtnPop" accesskey="P" id="regexpBtnPop"><span class="glyphicon glyphicon-plus-sign"></span> <s:message code="condition.select"/></button>
											</span>
											<span id="regexpSelectedAreaPop" class="codeSelectedBtn">
												<button type="button" class="btn">0</button>
											</span>
											<input type="hidden" id="regexpStrPop" class="selectedTitle">
											<input type="hidden" id="regexpValPop">
										</div>
									</td>
								</tr>
								<tr>
									<th><s:message code="interest.user"/></th>
									<td>
										<div class="select-xs">
											<select style="border: 1px solid #999;" id="userSeqPop">
												<option>-<s:message code="condition.select"/>-</option>
											</select>
										</div>
									</td>
									<th><s:message code="condition.receive_send"/></th>
									<td>
										<div class="form-group">
											<div class="btn-group filterBtn" data-toggle="buttons">
												<label class="btn btn-xs btn-default active"><input type="radio" name="receiveSendPop" id="receiveSendAllPop" value="" checked> <s:message code="common.msg.all"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="receiveSendPop" id="receiveOnlyPop" value="I"> <s:message code="condition.receive"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="receiveSendPop" id="sendOnlyPop" value="O"> <s:message code="condition.send"/></label>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th><s:message code="condition.allofus"/></th>
									<td>
										<div class="form-group">
											<div class="selecBtnArea" style="float: left;padding-right:10px;">
												<select class="selectpicker col-xs" id="allOfusPop" style="width:100%;">
													<option value=""><s:message code="condition.allofus.all"/></option>
													<option value="IA">1) <s:message code="condition.allofus1"/></option> 
													<option value="EA">2) <s:message code="condition.allofus2"/></option> 
													<option value="PA">3) <s:message code="condition.allofus3"/></option> 
													<option value="IA|EA">4) <s:message code="condition.allofus4"/></option> 
													<option value="EA|PA">5) <s:message code="condition.allofus5"/></option> 
													<option value="IA|PA">6) <s:message code="condition.allofus6"/></option> 
													<option value="IA|IT">7) <s:message code="condition.allofus7"/></option> 
													<option value="ET|EA">8) <s:message code="condition.allofus8"/></option> 
													<option value="PT|PA">9) <s:message code="condition.allofus9"/></option> 
													<option value="IA|ET|IT|EA">10) <s:message code="condition.allofus10"/></option> 
													<option value="IA|IT|PT|PA">11) <s:message code="condition.allofus11"/></option> 
													<option value="ET|EA|PT|PA">12) <s:message code="condition.allofus12"/></option>
													<option value="SO">13) <s:message code="condition.allofus13"/></option>
													<option value="SI">14) <s:message code="condition.allofus14"/></option>
												</select>
											</div> 
										</div>
									</td>
									<th>DRM</th>
									<td>
										<div class="form-group">
											<div class="btn-group filterBtn" data-toggle="buttons">
												<label class="btn btn-xs btn-default active"><input type="radio" name="regexp_drmYnPop" id="regexp_drmAllPop" value="" checked> <s:message code="condition.drm.all"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="regexp_drmYnPop" id="regexp_drmYPop" value="Y"> <s:message code="condition.exist"/></label>
												<label class="btn btn-xs btn-default"><input type="radio" name="regexp_drmYnPop" id="regexp_drmNPop" value="N"> <s:message code="condition.none"/></label>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th><s:message code="filterInfo.size"/></th>
									<td colspan="3">
										<div class="form-group">
											<div class="selecBtnArea" style="width:100px;float: left;padding-right:10px;">
												<select class="selectpicker col-xs" data-style="btn-default" id="sizeFilterTypePop">
													<option value=""><s:message code="condition.size.all"/></option>
													<option value="B"><s:message code="condition.size.body"/></option>
													<option value="A"><s:message code="condition.size.attach"/></option>
												</select>
											</div>
											<div class="selecBtnArea" style="width:80px;float: left;padding-right:10px;">
												<select class="selectpicker col-xs" data-style="btn-default" id="sizeFilterSelectPop">
													<option value="L"><s:message code="condition.over"/></option>
													<option value="S"><s:message code="condition.below"/></option>
													<option value="B"><s:message code="condition.range"/></option>
												</select>
											</div>
											<div style="width:300px;padding:1px 5px 0px 5px;float: left;">
												<div id="size-setupPop" style="margin-bottom:10px;"></div>
											</div>
											<div style="width:230px;padding-left:20px;float: left;height:30px;line-height:30px;">
												<span id="sizeStartValStrPop" style="line-height:20px;"></span><input type="text" id="sizeStartValPop" style="width:90px;display:none;">
												<span id="sizeRangeValStrPop" style="display:none;"> ~ </span>
												<span id="sizeEndValStrPop" style="display:none;"></span><input type="text" id="sizeEndValPop" style="width:90px;display:none;">
											</div>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="saveFilterBtn"><s:message code="common.msg.save"/></button>
				<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade smartFolderSave" id="smartFolderSavePop" tabindex="-1" data-backdrop="static" data-keyboard="false" role="dialog" aria-labelledby="attachModal">
	<input type="hidden" id="modalFolderType"/>
	<div class="modal-dialog modal-lg" role="document" style="width:700px;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title"><s:message code="filterInfo.setMsgFolder"/></h3>
			</div>
			<div class="modal-body">
				<div class="form-inline" id="saveFolderPathPopDiv">
					<label for="savePathPopArea" class="control-label col-xs-2"><s:message code="condition.savepath"/></label>
					<div class="form-control" id="saveFolderPathPopArea" style="height:350px;width:500px;">
						<ul id="folderTreePop" class="ztree scrollbar" style="height:100%;width:100%;overflow:auto;"></ul>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="saveFolderBtn"><s:message code="common.msg.save"/></button>
				<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
			</div>
		</div>
	</div>
</div>
<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"/>
	<input type="hidden" name="oldConm" id="oldConm"/>					
</form>
