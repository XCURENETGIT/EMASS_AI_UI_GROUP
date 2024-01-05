<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/popupScript.jsp" %>
<head>
	<title>EMASS PRO - <s:message code="condition.select.condition"/></title>
	<style type="text/css">
		.bootstrap-select:not([class*=col-]):not([class*=form-control]):not(.input-group-btn) {
			width: 100px;
		}

		.bootstrap-select > button > span {
			font: 13px Pretendard;
		}
		.bootstrap-select.btn-group .dropdown-toggle .filter-option{
			top:3px;
		}

		html, body {
			height: 100px;
			padding: 0px;
			margin: 0px;
			overflow: auto;
			min-width: 650px;
		}
		input[type="radio"]:disabled {appearance: auto; }
		input[type=text],input[type=search] {background: none;}

	</style>
	<script type="text/javascript">
        function initLayout() {
            $("input").prop("disabled", true);
            $("select").prop("disabled", true);
        }

        $(document).ready(function () {
            initLayout();
            conditionSetup();
            //sizeRangeSetup( );

            setSelectpicker();
            initInterestUser();
            initUserGroupList();

            $('#popCloseBtn').click(function () {
                self.close();
            });

            var conditions = opener.conditions;
            setCondition(conditions);
        });

        function resetCode(codeType) {
            $('#' + codeType + 'Val').val('');
            $('#' + codeType + 'Str').val('');
            $('#' + codeType + 'SelectedArea').hide();
        }

        function checkRadioBtn(name, val) {
            $('input:radio[name=' + name + ']:input[value=' + val + ']').prop('checked', true);
        }

        function arrayToString(array) {
            if (array == null || array == undefined) return "";
            else {
                return array.toString();
            }
        }

        function stringToArray(string) {
            if (string == null || string == undefined || string == '') return '';
            else if (typeof string != 'string') return string;
            else {
                return string.split(',');
            }
        }

        function toDateFormat(d) {
            return d.substring(0, 4) + '-' + d.substring(4, 6) + '-' + d.substring(6, 8) + ' ' + d.substring(8, 10) + ':' + d.substring(10, 12) + ':' + d.substring(12, 14);
        }

        function setCondition(conditionVal) {
            if (conditionVal.query == undefined || conditionVal.query == '') {
                $(".condition").show();
                $(".solrQuery").hide();

                var consentStr = opener.consentStr;
                if (consentStr == "") {
                    $(".consent").hide();
                } else {
                    $('#consentStr').val(consentStr);
                    $(".consent").show();
                }

                $('#startDt').val(toDateFormat(conditionVal.startDt));
                $('#endDt').val(toDateFormat(conditionVal.endDt));

                $('#searchStrInput').val(conditionVal.searchStr);
                $('#searchField').selectpicker('val', conditionVal.searchField);
                $('#searchField').selectpicker("refresh");

                $('#senders').val(conditionVal.senders);
                $('#receivers').val(conditionVal.receivers);
                $('#rcvTo').val(conditionVal.rcvTo);
                $('#rcvCc').val(conditionVal.rcvCc);
                $('#rcvBcc').val(conditionVal.rcvBcc);
                $('#rcvJikgub').val(conditionVal.rcvJikgub);
                $('#allOfus').selectpicker('val', conditionVal.allOfus);

                checkRadioBtn('readYnVal', conditionVal.readYn);
                checkRadioBtn('receiveSendVal', conditionVal.receiveSend);
                checkRadioBtn('ctimeWorkVal', conditionVal.ctimeWork);

                checkRadioBtn('attachYnVal', conditionVal.attachYn);
                if (conditionVal.attachVal != "") {
                    $('#attachList').val(conditionVal.attachStr).show().attr('title', conditionVal.attachStr);
                }

                checkRadioBtn('keywordYnVal', conditionVal.keywordYn);
                if (conditionVal.keywordVal != "") {
                    $('#keywordList').val(conditionVal.keywordStr).show().attr('title', conditionVal.keywordStr);
                }

                checkRadioBtn('regexpYnVal', conditionVal.regexpYn);
                if (conditionVal.regexpVal != "") {
                    $('#regexpList').val(conditionVal.regexpStr).show().attr('title', conditionVal.regexpStr);
                }

                if (conditionVal.deptStr != "") {
                    $('#deptVal').val(conditionVal.dept);
                    setSelectedCodeData("dept", conditionVal.deptVal, conditionVal.deptStr);
                }

                checkRadioBtn('regexp_drmYnVal', conditionVal.drmYn);
                checkRadioBtn('regexp_sctYnVal', conditionVal.sctYn);

                $('#sizeStartVal').val(convertFileSize(conditionVal.sizeStartVal));
                $('#sizeEndVal').val(convertFileSize(conditionVal.sizeEndVal));
                if (conditionVal.sizeOption == 'B') {
                    $('#sizeStartVal, #sizeEndVal, #sizeRangeValStr').show();
                } else {
                    $('#sizeStartVal').show();
                }


                $('#sizeFilterSelect').val(conditionVal.sizeOption);
                $('#sizeFilterType').val(conditionVal.sizeType);

                $('#sizeFilterSelect').selectpicker("refresh");

                setTimeout(function () {
                    $('#serviceTypeSelect').selectpicker('val', stringToArray(conditionVal.serviceType));
                    $('#serviceTypeSelect').selectpicker("refresh");
                    $('#busiSelect').selectpicker('val', stringToArray(conditionVal.busi));
                    $('#busiSelect').selectpicker("refresh");

                    $('#interGroup').selectpicker('val', conditionVal.interGroup);
                    $('#interGroup').selectpicker("refresh");

                    $('#userGroupSeq').selectpicker('val', stringToArray(conditionVal.userGroupSeq));
                    $('#userGroupSeq').selectpicker("refresh");
                }, 300);

                $('.btn-group').click(function (event) {
                    event.stopPropagation();
                });
            } else {
                $(".condition").hide();
                $(".solrQuery").show();

                //resizeTo(656,350);

                $('#solrQueryText').val(conditionVal.query);
            }
        }

        function conditionSetup() {
            $('#searchField').selectpicker({
                container: 'body',
                width: '120px',
                noneSelectedText: '<s:message code="common.msg.all"/>'
            });

            var width = '200px';
            $('#serviceTypeSelect').selectpicker({
                container: 'body',
                size: 15,
                width: width,
                searchLabel: true,
                noneSelectedText: '<s:message code="condition.service.all"/>',
                noneResultsText: '<s:message code="common.msg.noresult"/> ',
                selectAllText: '<s:message code="common.msg.select_all"/>',
                deselectAllText: '<s:message code="common.msg.unselect_all"/>'
            });
            $('#sizeFilterSelect').selectpicker({
                container: 'body'
            });

            $('#busiSelect').selectpicker({
                container: 'body',
                size: 15,
                width: width,
                searchLabel: true,
                noneSelectedText: '<s:message code="common.org.busi.all"/>',
                noneResultsText: '<s:message code="common.msg.noresult"/> ',
                selectAllText: '<s:message code="common.msg.select_all"/>',
                deselectAllText: '<s:message code="common.msg.unselect_all"/>'
            });

            $('#allOfus').selectpicker({
                container: 'body',
                width: width
            });
        }

        function setSelectpicker() {
            getCodeList('busi');
            getServiceTypeList();
        }

        var serviceGroups = [];
        var serviceTypes = [];
        var specialService = [];
        var parentCode = [];

        function getServiceGroupList() {
            var str = '';
            for (var i = 0; i < serviceTypes.length; i++) {
                if (str.indexOf(serviceTypes[i].groupCd) == -1) {
                    str += serviceTypes[i].groupCd + ',';
                }
                if (serviceTypes[i].serviceCd.length == 4) {
                    specialService.push(serviceTypes[i]);
                }
            }
            serviceGroups = str.substring(0, str.length - 1).split(',');

            $('#serviceTypeSelect').html(getServiceOptionStr());
            getServiceOptionLiveSearch(parentCode);
            $('#serviceTypeSelect').selectpicker('refresh');
        }

        function getServiceTypeList() {
            ui.get({
                url: 'getServiceListByAuth.xcn',
                success: function (data, total) {
                    serviceTypes = data;
                    getServiceGroupList();
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        function getServiceOptionStr() {
            var str = '';
            for (var i = 0; i < serviceGroups.length; i++) {
                var selectedVal = serviceGroups[i];
                var idx = 0;
                for (var j = 0; j < serviceTypes.length; j++) {
                    if (selectedVal == serviceTypes[j].groupCd) {
                        if (idx == 0) {
                            str += '<optgroup label="' + serviceTypes[j].groupNm + '">';
                        }
                        if (serviceTypes[j].serviceCd.length == 3) {
                            str += getServiceOptionChildren(serviceTypes[j]);
                        } else if (serviceTypes[j].serviceCd.length == 4) continue;
                        else str += '<option value="' + serviceTypes[j].serviceCd + '">' + serviceTypes[j].serviceNm + '</option>';
                        idx++;
                    }
                }
                if (idx != 0) str += '</optgroup>';
            }
            return str;
        }

        function getServiceOptionChildren(serviceType) {
            var result = '<option value="' + serviceType.serviceCd + '">' + serviceType.serviceNm + '</option>';
            for (var i = 0; i < specialService.length; i++) {
                var service = specialService[i];
                if (service.serviceCd.indexOf(serviceType.serviceCd) > -1) {
                    if (!parentCode.includes(serviceType.serviceCd)) parentCode.push(serviceType.serviceCd);
                    result += '<option value="' + service.serviceCd + '"> └ ' + service.serviceNm + '</option>';
                }
            }

            return result;
        }

        function getServiceOptionLiveSearch(code) {
            var searchWord = "";

            for (var i = 0; i < code.length; i++) {
                var pCode = code[i];
                for (var j = 0; j < specialService.length; j++) {
                    if (specialService[j].serviceCd.indexOf(pCode) > -1) {
                        searchWord += specialService[j].serviceNm + " ";
                    }
                }
                $('[value=' + pCode + ']').attr('data-tokens', searchWord);
                searchWord = "";
            }
        }

        function getCodeList(codeType) {
            ui.get({
                url: 'getCodeList.xcn',
                codeType: codeType,
                success: function (data, total) {
                    $('#' + codeType + 'Select').html(getSelectOption(data));
                    $('#' + codeType + 'Select').selectpicker('refresh');
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    searchFlag = false;
                }
            });
        }

        function getSelectOption(data) {
            var str = '';
            for (var i = 0; i < data.length; i++) {
                str += '<option value="' + data[i].code + '">' + data[i].codeName + '</option>';
            }
            return str;
        }

        function initInterestUser() {
            ui.get({
                url: 'getAdminUserGroupList.xcn',
                success: function (data, total) {
                    getInterestUserOptions(data, '');
                },
                error: function (status, message) {
                    //ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        function initUserGroupList() {
            ui.get({
                url: 'getUserGroupList.xcn',
                logYn: 'Y',
                success: function (data, total) {
                    getUserGroupListOptions(data, '');
                },
                error: function (status, message) {
                    //ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }

        /**
         * 관심사용자 리스트 조회
         */
        function getInterestUserOptions(data) {
            $('#interGroup').selectpicker({
                container: 'body',
                width: '200px',
                noneSelectedText: '-<s:message code="condition.select.interest"/>-'
            });

            var result = '<option value="">-<s:message code="condition.select.interest"/>-</option>';
            result += '<option value="all"><s:message code="interest.user.all"/></option>';
            for (var i = 0; i < data.length; i++) {
                result += '<option value="' + data[i].groupSeq + '">' + data[i].groupName + '</option>';
            }
            $("#interGroup").html(result);
            $("#interGroup").selectpicker('refresh');
        }

        function getUserGroupListOptions(data) {
            $('#userGroupSeq').selectpicker({
                container: 'body',
                width: '200px',
                noneSelectedText: '-<s:message code="userGroup.navi.title2"/>-'
            });

            var result = '';
            for (var i = 0; i < data.length; i++) {
                result += '<option value="' + data[i].groupCode + '">' + data[i].groupName + '</option>';
            }
            $("#userGroupSeq").html(result);
            $("#userGroupSeq").selectpicker('refresh');
        }


        function setSelectedCodeData(codeType, val, str) {
            $('#' + codeType + 'Str').val(str);
            $('#' + codeType + 'Val').val(val);


            if ($('#' + codeType + 'Str').val() != '') {
                var divStr = str;
                if (codeType == "attach") {
                    divStr = val;
                }

                var divStrArray;

                if (codeType == "attach") {
                    divStrArray = divStr.split("|");
                } else {
                    divStrArray = divStr.split(",");
                }

                if (divStrArray.length == 1) {
                    $('#' + codeType + 'StrDiv').text(divStrArray[0]);
                } else {
                    $('#' + codeType + 'StrDiv').text(divStrArray[0] + "<s:message code='common.msg.etc'/>" + (divStrArray.length - 1) + "<s:message code='common.msg.cnt'/>");
                }

                $('#' + codeType + 'SelectedArea').show();
            } else {
                $('#' + codeType + 'SelectedArea').hide();
            }
        }


	</script>
</head>


<div class="xcn_container" id="popupWrap" data-backdrop="static">
	<div class="item grayBg02" style="height:900px;">
		<h3 class="grayBg02 borbottom_dashed p12"><span class="bullet02"></span></span>검색 조건</h3>
		<div class="dis popupInner">
			<div class="form-group form-inline filterDiv condition consent">
				<div class="row borbottom_dashed pb8">
					<div class="col-35">
						<label for="consentStr" class="fname"><s:message code="consent.consent"/></label>
					</div>
					<div class="col-65">
						<input type="text" class="w100" id="consentStr" style="width: 200px;"/>
					</div>
				</div>
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="serviceTypeSelect" class="fname"><s:message code="condition.service"/></label>
				</div>
				<div class="col-65">
					<select id="serviceTypeSelect" class="w100" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
				</div>
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="searchField" class="fname"><s:message code="condition.field.search"/></label>
				</div>
				<div class="col-65">
					<select id="searchField" class="select" style="width: 200px;">
						<option value=""><s:message code="condition.field.search"/></option>
						<option value="subject"><s:message code="condition.subject"/></option>
						<option value="body"><s:message code="condition.body"/></option>
						<option value="attachname attachname_str"><s:message code="condition.attach_name"/></option>
						<%if (!isOCR) { %>
						<option value="attach"><s:message code="condition.attach"/></option>
						<%} else { %>
						<option value="attach ocr_attach"><s:message code="condition.attach"/></option>
						<option value="ocr_attach">OCR</option>
						<%} %>
						<option value="host host_str">Host</option>
						<option value="path">Path</option>
						<option value="srcip"><s:message code="condition.source"/> IP</option>
						<option value="dstip"><s:message code="condition.destination"/> IP</option>
						<option value="sender_str"><s:message code="condition.sender"/></option>
						<option value="sname"><s:message code="condition.sender_name"/></option>
						<option value="recvs"><s:message code="condition.recv"/></option>
						<option value="recvs_name"><s:message code="condition.recv_name"/></option>
						<option value="to tname"><s:message code="condition.recv"/>(<s:message code="condition.to"/>)
						</option>
						<option value="cc cname"><s:message code="condition.recv"/>(<s:message code="condition.cc"/>)
						</option>
						<option value="bcc bname"><s:message code="condition.recv"/>(<s:message code="condition.bcc"/>)
						</option>
						<option value="user user_str userid name"><s:message code="common.org.user"/></option>
						<option value="usr_id"><s:message code="common.msg.account"/></option>
					</select>
					<input type="search" class="w100" id="searchStrInput" style="width: 130px;" placeholder="<s:message code="condition.search_str"/>"/>
				</div>
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="day_msg" class="fname"><s:message code="condition.period.setting"/></label>
				</div>
				<div class="col-65">
					<div id="day_msg" style="display:inline-flex;">
						<div class="input-group">
							<div class="fname" id="startdatepicker">
								<input type="text" id="startDt" class="input-sm form-control border-radius-none" style="width: 130px;"/>
							</div>
						</div>
						&nbsp;
						<div class="input-group" style="line-height: 28px;">~</div>
						&nbsp;
						<div class="input-group">
							<div class="fname" id="enddatepicker">
								<input type="text" id="endDt" class="input-sm form-control border-radius-none" style="width: 130px;"/>
							</div>
						</div>
					</div>
					<div id="time_msg" style="display: none;">
						<span><s:message code="mail.message.condition_info"/></span>
					</div>
				</div>
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<div id="recvSendGroup">
						<label for="" class="fname"><s:message code="condition.receive_send"/></label>
					</div>
				</div>
				<div class="col-65">
					<label class="radio-inline c-radio"><input type="radio" name="receiveSendVal" value="" checked> &nbsp<s:message code="common.msg.all"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="receiveSendVal" value="I">&nbsp<s:message code="condition.receive"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="receiveSendVal" value="O">&nbsp<s:message code="condition.send"/></label>
					<input type="hidden" name="receiveSend" id="receiveSend">
				</div>
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<div id="ctimeWorkGroup">
						<label for="" class="fname"><s:message code="condition.ctimework"/></label>
					</div>
				</div>
				<div class="col-65">
					<label class="radio-inline c-radio"><input type="radio" name="ctimeWorkVal" value="" checked>&nbsp<s:message code="condition.ctimework.all"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="ctimeWorkVal" value="W">&nbsp<s:message code="condition.work"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="ctimeWorkVal" value="R">&nbsp<s:message code="condition.notwork"/></label>
					<input type="hidden" name="ctimeWork" id="ctimeWork">
				</div>
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="" class="fname"><s:message code="condition.isread"/></label>
				</div>
				<div class="col-65">
					<label class="radio-inline c-radio"><input type="radio" name="readYnVal" value="" checked>&nbsp<s:message code="common.msg.all"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="readYnVal" value="Y">&nbsp<s:message code="condition.read"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="readYnVal" value="N">&nbsp<s:message code="condition.unread"/></label>
					<input type="hidden" name="readYn" id="readYn">
				</div>
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="receivers" class="fname"><s:message code="condition.receiver_sender"/></label>
				</div>
				<div class="col-65">
					<div>
						<input type="text" class="w100" id="receivers" placeholder="<s:message code="condition.recv"/>" style="width: 130px;"/>

						<input type="text" class="w100" id="senders" placeholder="<s:message code="condition.sender"/>" style="width: 130px;"/>
					</div>
				</div>
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="busiSelect" class="fname"><s:message code="common.org.businm"/></label>
				</div>
				<div class="col-65">
					<div class="w100" data-toggle="buttons" style="margin-top:3px; ">
						<select id="busiSelect" class="w100" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
					</div>
					<label for=""></label>
				</div>
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="deptStrDiv" class="fname"><s:message code="common.org.deptnm"/></label>
				</div>
				<div class="col-65">
					<div id="deptStrDiv" class="codeSelectedDiv"></div>
				</div>
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="allOfus" class="fname"><s:message code="condition.allofus"/></label>
				</div>
				<div class="col-65">
					<div class="w100" data-toggle="buttons" style="margin-top:3px; width: 20% ">
						<select id="allOfus" data-style="btn-default btn-sm" style="width:20%;">
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
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="userGroupSeq" class="fname"><s:message code="userGroup.navi.title2"/></label>
				</div>
				<div class="col-65">
					<div class="w100" data-toggle="buttons" style="margin-top:3px;">
						<select id="userGroupSeq" class="select" data-style="btn-default btn-sm"></select>
					</div>
					<input type="hidden" id="userGroupStr">
				</div>
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="interGroup" class="fname"><s:message code="interest.user"/></label>
				</div>
				<div class="col-65">
					<div class="w100" data-toggle="buttons" style="margin-top:3px;">
						<select id="interGroup" class="selectpicker col-xs" data-style="btn-default btn-sm"></select>
					</div>
				</div>
			</div>

			<!-- 첨부여부 -->
			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="" class="fname"><s:message code="condition.isattached"/></label>
				</div>
				<div class="col-65">
					<label class="radio-inline c-radio"><input type="radio" name="attachYnVal" value="" checked>&nbsp<s:message code="common.msg.all"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="attachYnVal" value="Y">&nbsp<s:message code="condition.exist"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="attachYnVal" value="N">&nbsp<s:message code="condition.none"/></label>
					<input type="text" id="attachList" style="display: none; width: 220px;"/>
				</div>
			</div>

			<!-- 예약어 -->
			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="" class="fname"><s:message code="condition.keyword"/></label>
				</div>
				<div class="col-65">
					<label class="radio-inline c-radio"><input type="radio" name="keywordYnVal" value="" checked>&nbsp<s:message code="common.msg.all"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="keywordYnVal" value="Y">&nbsp<s:message code="condition.exist"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="keywordYnVal" value="N">&nbsp<s:message code="condition.none"/></label>
					<input type="text" id="keywordList" style="display: none; width: 220px;"/>
				</div>
			</div>

			<!-- 패턴검출 -->
			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="" class="fname"><s:message code="condition.regexp.detect"/></label>
				</div>
				<div class="col-65">
					<label class="radio-inline c-radio"><input type="radio" name="regexpYnVal" value="" checked>&nbsp<s:message code="common.msg.all"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="regexpYnVal" value="Y">&nbsp<s:message code="condition.exist"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="regexpYnVal" value="N">&nbsp<s:message code="condition.none"/></label>
					<input type="text" id="regexpList" style="display: none; width: 220px;"/>
				</div>
			</div>

			<!-- DRM -->
			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="" class="fname">DRM</label>
				</div>
				<div class="col-65">
					<label class="radio-inline c-radio"><input type="radio" name="regexp_drmYnVal" value="" checked>&nbsp<s:message code="common.msg.all"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="regexp_drmYnVal" value="Y">&nbsp<s:message code="condition.exist"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="regexp_drmYnVal" value="N">&nbsp<s:message code="condition.none"/></label>
				</div>
			</div>

			<!-- 수신필터 -->
			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="" class="fname"><s:message code="condition.sct"/></label>
				</div>
				<div class="col-65">
					<label class="radio-inline c-radio"><input type="radio" name="regexp_sctYnVal" value="" checked>&nbsp<s:message code="common.msg.all"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="regexp_sctYnVal" value="Y">&nbsp<s:message code="condition.exist"/></label>
					<label class="radio-inline c-radio"><input type="radio" name="regexp_sctYnVal" value="N">&nbsp<s:message code="condition.none"/></label>
				</div>
			</div>

			<div class="row borbottom_dashed pb8">
				<div class="col-35">
					<label for="" class="fname"><s:message code="filterInfo.size"/></label>
				</div>
				<div class="col-65">
						<select  id="sizeFilterType" style="width: 100px; color: #333;background-color: #fff; border-color: #ccc; font-size: 13px;     height: 23px;line-height: 23px;">
							<option value=""><s:message code="condition.size.all"/></option>
							<option value="B"><s:message code="condition.size.body"/></option>
							<option value="A"><s:message code="condition.size.attach"/></option>
						</select>
						<select  id="sizeFilterSelect" >
							<option value="L" style="width: 100px;"><s:message code="condition.over"/></option>
							<option value="S" style="width: 100px;"><s:message code="condition.below"/></option>
							<option value="B" style="width: 100px;"><s:message code="condition.range"/></option>
						</select>
						<input type="text" class="w100" id="sizeStartVal"
						       style="width: 50px; display: none;"/>
						<span id="sizeRangeValStr" style="display: none;"> ~ </span>
						<input type="text" class="w100" id="sizeEndVal"
						       style="width: 50px; display: none;"/>
				</div>
			</div>
		</div>
	</div>
</div>
