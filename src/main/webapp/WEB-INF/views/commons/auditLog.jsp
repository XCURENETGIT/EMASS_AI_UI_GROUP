<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<style>
#modal_body_area {min-height: 200px;max-height: 400px;overflow: auto;font-size: 13px;line-height: 24px;}
</style>
<script type="text/javascript">
    var adminId2 = '${_USERCREDENTIAL_.adminId}';
    var searchFlag = false;
    var menuArr = [];
    menuArr.push({id: 'SYSTEM', name: '<s:message code="SYSTEM"/>', p_id: null});
    menuArr.push({id: 'DATA_MONITOR', name: '<s:message code="DATA_MONITOR"/>', p_id: null});
    menuArr.push({id: 'DATA_ANALYSIS', name: '<s:message code="DATA_ANALYSIS"/>', p_id: null});
    menuArr.push({id: 'POLICY_SETUP', name: '<s:message code="POLICY_SETUP"/>', p_id: null});
    menuArr.push({id: 'OPERATION_MGMT', name: '<s:message code="OPERATION_MGMT"/>', p_id: null});

    menuArr.push({id: 'CONNECTION', name: '<s:message code="SYSTEM.CONNECTION"/>', p_id: 'SYSTEM'});
    menuArr.push({id: 'DASHBOARD', name: '<s:message code="DATA_MONITOR.DASHBOARD"/>', p_id: 'DATA_MONITOR'});
    menuArr.push({
        id: 'DASHBOARD_MENU',
        name: '<s:message code="DATA_MONITOR.DASHBOARD_MENU"/>',
        p_id: 'DATA_MONITOR'
    }); //대시보드 메뉴
    menuArr.push({
        id: 'DASHBOARD_SETUP',
        name: '<s:message code="DATA_MONITOR.DASHBOARD_SETUP"/>',
        p_id: 'DATA_MONITOR'
    }); //대시보드 관리
    menuArr.push({id: 'MESSAGE_INFO', name: '<s:message code="DATA_MONITOR.MESSAGE_INFO"/>', p_id: 'DATA_MONITOR'}); //메시지 정보
    menuArr.push({
        id: 'MESSAGE_SERVICE',
        name: '<s:message code="DATA_MONITOR.MESSAGE_SERVICE"/>',
        p_id: 'DATA_MONITOR'
    }); //메신저 모아보기
    menuArr.push({
        id: 'GENERATIVEAI_SERVICE',
        name: '<s:message code="DATA_MONITOR.GENERATIVEAI_SERVICE"/>',
        p_id: 'DATA_MONITOR'
    }); //생성형AI 모아보기
    menuArr.push({id: 'NOTE_SERVICE', name: '<s:message code="DATA_MONITOR.NOTE_SERVICE"/>', p_id: 'DATA_MONITOR'}); //노트 모아보기
    menuArr.push({
        id: 'FILETRANSFER_SERVICE',
        name: '<s:message code="DATA_MONITOR.FILETRANSFER_SERVICE"/>',
        p_id: 'DATA_MONITOR'
    }); //파일전송 모아보기
    menuArr.push({
        id: 'INTEREST_USER',
        name: '<s:message code="DATA_MONITOR.INTEREST_USER"/>',
        p_id: 'DATA_MONITOR'
    }); //관심 사용자 관리
    menuArr.push({id: 'STAT_REPORT', name: '<s:message code="DATA_MONITOR.STAT_REPORT"/>', p_id: 'DATA_MONITOR'}); //리포트
    menuArr.push({
        id: 'RESERVATION_ALARM',
        name: '<s:message code="DATA_MONITOR.RESERVATION_ALARM"/>',
        p_id: 'DATA_MONITOR'
    }); //예약 알림
    menuArr.push({id: 'KEYWORD_MGMT', name: '<s:message code="DATA_MONITOR.KEYWORD_MGMT"/>', p_id: 'DATA_MONITOR'}); //예약어 관리
    menuArr.push({id: 'CONSENT_MGMT', name: '<s:message code="DATA_MONITOR.CONSENT_MGMT"/>', p_id: 'DATA_MONITOR'}); //동의서 관리
    menuArr.push({
        id: 'BUSI_IPRANGE_VIEW',
        name: '<s:message code="DATA_MONITOR.BUSI_IPRANGE_VIEW"/>',
        p_id: 'DATA_MONITOR'
    }); //사업장 내부 IP 확인
    menuArr.push({
        id: 'DEPT_IPRANGE_VIEW',
        name: '<s:message code="DATA_MONITOR.DEPT_IPRANGE_VIEW"/>',
        p_id: 'DATA_MONITOR'
    }); //부서 내부 IP 확인
    menuArr.push({
        id: 'RELATION_KEYWORD',
        name: '<s:message code="DATA_MONITOR.RELATION_KEYWORD"/>',
        p_id: 'DATA_MONITOR'
    }); //연관 검색어 관리
    menuArr.push({
        id: 'REGEX_PATTERN',
        name: '<s:message code="DATA_MONITOR.REGEX_PATTERN"/>',
        p_id: 'DATA_MONITOR'
    }); //정규식 패턴 관리
    menuArr.push({
        id: 'ANALYSIS_RELATION',
        name: '<s:message code="DATA_ANALYSIS.ANALYSIS_RELATION"/>',
        p_id: 'DATA_ANALYSIS'
    }); //데이터 관계 분석
    menuArr.push({
        id: 'ANALYSIS_FLUCTUATION',
        name: '<s:message code="DATA_ANALYSIS.ANALYSIS_FLUCTUATION"/>',
        p_id: 'DATA_ANALYSIS'
    }); //사용량 증감 분석
    menuArr.push({
        id: 'ANALYSIS_CUSTOM',
        name: '<s:message code="DATA_ANALYSIS.ANALYSIS_CUSTOM"/>',
        p_id: 'DATA_ANALYSIS'
    }); //데이터 자유 분석
    menuArr.push({
        id: 'ANALYSIS_INFO',
        name: '<s:message code="DATA_ANALYSIS.ANALYSIS_INFO"/>',
        p_id: 'DATA_ANALYSIS'
    }); //개인정보 유출관계 분석
    menuArr.push({id: 'STAT_USER', name: '<s:message code="DATA_ANALYSIS.STAT_USER"/>', p_id: 'DATA_ANALYSIS'}); //사용자 통계
    menuArr.push({
        id: 'STAT_INTEREST',
        name: '<s:message code="DATA_ANALYSIS.STAT_INTEREST"/>',
        p_id: 'DATA_ANALYSIS'
    }); //관심 사용자 통계
    menuArr.push({id: 'STAT_SENDER', name: '<s:message code="DATA_ANALYSIS.STAT_SENDER"/>', p_id: 'DATA_ANALYSIS'}); //발신자 통계
    menuArr.push({id: 'STAT_SVC', name: '<s:message code="DATA_ANALYSIS.STAT_SVC"/>', p_id: 'DATA_ANALYSIS'}); //서비스타입 통계
    menuArr.push({id: 'STAT_KWD', name: '<s:message code="DATA_ANALYSIS.STAT_KWD"/>', p_id: 'DATA_ANALYSIS'}); //예약어 통계
    menuArr.push({
        id: 'STAT_ATTACHTYPE',
        name: '<s:message code="DATA_ANALYSIS.STAT_ATTACHTYPE"/>',
        p_id: 'DATA_ANALYSIS'
    }); //첨부파일 통계
    menuArr.push({
        id: 'STAT_ATTACHNAME',
        name: '<s:message code="DATA_ANALYSIS.STAT_ATTACHNAME"/>',
        p_id: 'DATA_ANALYSIS'
    }); //첨부파일명 통계
    menuArr.push({id: 'STAT_URL', name: '<s:message code="DATA_ANALYSIS.STAT_URL"/>', p_id: 'DATA_ANALYSIS'}); //URL 통계
    menuArr.push({
        id: 'STAT_ADMINREAD',
        name: '<s:message code="DATA_ANALYSIS.STAT_ADMINREAD"/>',
        p_id: 'DATA_ANALYSIS'
    }); //운용자 열람 통계
    menuArr.push({
        id: 'STAT_DEVTRAFFIC',
        name: '<s:message code="DATA_ANALYSIS.STAT_DEVTRAFFIC"/>',
        p_id: 'DATA_ANALYSIS'
    }); //장비 트래픽 통계
    menuArr.push({id: 'STAT_OCR', name: '<s:message code="DATA_ANALYSIS.STAT_OCR"/>', p_id: 'DATA_ANALYSIS'}); //OCR 통계
    menuArr.push({id: 'POLICY_NOLOG', name: '<s:message code="POLICY_SETUP.POLICY_NOLOG"/>', p_id: 'POLICY_SETUP'}); //데이터 미로깅 정책
    menuArr.push({id: 'DEV_INFO', name: '<s:message code="OPERATION_MGMT.DEV_INFO"/>', p_id: 'OPERATION_MGMT'}); //장비 정보
    menuArr.push({
        id: 'DEV_EVENTLOG',
        name: '<s:message code="OPERATION_MGMT.DEV_EVENTLOG"/>',
        p_id: 'OPERATION_MGMT'
    }); //장비 이벤트 로그
    menuArr.push({id: 'ORG_MGMT', name: '<s:message code="POLICY_SETUP.ORG_MGMT"/>', p_id: 'OPERATION_MGMT'}); //조직 관리
    menuArr.push({id: 'USER_MGMT', name: '<s:message code="POLICY_SETUP.USER_MGMT"/>', p_id: 'OPERATION_MGMT'}); //사용자 관리
    menuArr.push({
        id: 'USER_GROUP_MGMT',
        name: '<s:message code="POLICY_SETUP.USER_GROUP_MGMT"/>',
        p_id: 'OPERATION_MGMT'
    }); //사용자 그룹
    menuArr.push({
        id: 'BUSI_IPRANGE',
        name: '<s:message code="POLICY_SETUP.BUSI_IPRANGE"/>',
        p_id: 'OPERATION_MGMT'
    }); //사업장 내부 IP 설정
    menuArr.push({
        id: 'DEPT_IPRANGE',
        name: '<s:message code="POLICY_SETUP.DEPT_IPRANGE"/>',
        p_id: 'OPERATION_MGMT'
    }); //사업장 내부 IP 설정
    menuArr.push({id: 'CODE_INFO', name: '<s:message code="OPERATION_MGMT.CODE_INFO"/>', p_id: 'OPERATION_MGMT'}); //코드 정보
    menuArr.push({id: 'ADMIN_MGMT', name: '<s:message code="OPERATION_MGMT.ADMIN_MGMT"/>', p_id: 'OPERATION_MGMT'}); //운용자 관리
    menuArr.push({
        id: 'HOLIDAY_BUSI',
        name: '<s:message code="OPERATION_MGMT.HOLIDAY_LABEL"/>',
        p_id: 'OPERATION_MGMT'
    }); //업무/휴일 설정
    menuArr.push({id: 'SEARCH_LOG', name: '<s:message code="OPERATION_MGMT.SEARCH_LOG"/>', p_id: 'OPERATION_MGMT'}); //조회 이력
    menuArr.push({id: 'AUDIT_LOG', name: '<s:message code="OPERATION_MGMT.AUDIT_LOG"/>', p_id: 'OPERATION_MGMT'}); //운용자 감사 로그

    var operationArr = [];
    operationArr.push({id: 'DOWNLOAD', name: '<s:message code="auditLog.oper.DOWNLOAD"/>'});
    operationArr.push({id: 'LOGIN', name: '<s:message code="auditLog.oper.LOGIN"/>'});
    operationArr.push({id: 'LOGOUT', name: '<s:message code="auditLog.oper.LOGOUT"/>'});
    operationArr.push({id: 'CHG_PWD', name: '<s:message code="auditLog.oper.CHG_PWD"/>'});
    operationArr.push({id: 'CHG_INTEREST', name: '<s:message code="auditLog.oper.CHG_INTEREST"/>'});
    operationArr.push({id: 'CHG_DEV', name: '<s:message code="auditLog.oper.CHG_DEV"/>'});
    operationArr.push({id: 'CHG_FILESIZE', name: '<s:message code="auditLog.oper.CHG_FILESIZE"/>'});
    operationArr.push({id: 'SEARCH', name: '<s:message code="auditLog.oper.SEARCH"/>'});
    operationArr.push({id: 'SEARCH_EXPERT', name: '<s:message code="auditLog.oper.SEARCH_EXPERT"/>'});
    operationArr.push({id: 'INSERT', name: '<s:message code="auditLog.oper.INSERT"/>'});
    operationArr.push({id: 'UPDATE', name: '<s:message code="auditLog.oper.UPDATE"/>'});
    operationArr.push({id: 'DELETE', name: '<s:message code="auditLog.oper.DELETE"/>'});
    operationArr.push({id: 'SAVE', name: '<s:message code="auditLog.oper.SAVE"/>'});
    operationArr.push({id: 'RETURN', name: '<s:message code="auditLog.oper.RETURN"/>'});
    operationArr.push({id: 'APPROVE', name: '<s:message code="auditLog.oper.APPROVE"/>'});
    operationArr.push({id: 'CANCEL', name: '<s:message code="auditLog.oper.CANCEL"/>'});
    operationArr.push({id: 'RULE_APPLY', name: '<s:message code="auditLog.oper.RULE_APPLY"/>'});
    operationArr.push({id: 'UPLOAD', name: '<s:message code="auditLog.oper.UPLOAD"/>'});
    operationArr.push({id: 'MAIL_SEND', name: '<s:message code="auditLog.oper.MAIL_SEND"/>'});
    operationArr.push({id: 'BODY_VIEW', name: '<s:message code="auditLog.oper.BODY_VIEW"/>'});
    operationArr.push({id: 'BODY_SAVE', name: '<s:message code="auditLog.oper.BODY_SAVE"/>'});
    operationArr.push({id: 'ATTACH_SAVE', name: '<s:message code="auditLog.oper.ATTACH_SAVE"/>'});
    operationArr.push({id: 'HEADER_SAVE', name: '<s:message code="auditLog.oper.HEADER_SAVE"/>'});
    operationArr.push({id: 'ORI_BODY_SAVE', name: '<s:message code="auditLog.oper.ORI_BODY_SAVE"/>'});
    operationArr.push({id: 'BODY_PRINT', name: '<s:message code="auditLog.oper.BODY_PRINT"/>'});
    operationArr.push({id: 'PRINT', name: '<s:message code="auditLog.oper.PRINT"/>'});
    operationArr.push({id: 'IMPORT', name: '<s:message code="auditLog.oper.IMPORT"/>'});
    operationArr.push({id: 'EXPORT', name: '<s:message code="auditLog.oper.EXPORT"/>'});


    function getParentMenu() {
        var result = [];
        for (var i = 0; i < menuArr.length; i++) {
            if (menuArr[i].p_id == null) {
                result.push(menuArr[i]);
            }
        }
        return result;
    }

    function getMenu(p_id) {
        var result = [];
        for (var i = 0; i < menuArr.length; i++) {
            if (menuArr[i].p_id == p_id) {
                result.push(menuArr[i]);
            }
        }
        return result;
    }

    $(document).ready(function () {

        $('#startDatePicker').datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'ko',
            defaultDate: moment(new Date())
        });

        $('#endDatePicker').datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'ko',
            defaultDate: moment(new Date())
        });

        $('#searchBtn').click(function () {
            getData();
        });

        $('#adminId').change(function () {
            getData();
        });
        $('#pMenuId').change(function () {
            getData();
        });
        $('#menuId').change(function () {
            getData();
        });
        $("#adminId").html(getAdminOptions());
        $("#searchStr").keypress(function (e) {
            if (e.keyCode == 13) getData();
        });

        var str = '<option value="">- <s:message code="auditLog.select.pmenu"/> -</option>';
        var category = getParentMenu();
        for (var i = 0; i < category.length; i++) {
            str += '<option value="' + category[i].id + '">' + category[i].name + '</option>';
        }
        $('#pMenuId').html(str);

        $('#pMenuId').change(function () {
            var str = '<option value="">- <s:message code="auditLog.select.menu"/> -</option>';
            var menu = getMenu($(this).val());
            for (var i = 0; i < menu.length; i++) {
                str += '<option value="' + menu[i].id + '">' + menu[i].name + '</option>';
            }
            $('#menuId').html(str);
        });

        getData();
    });

    function getData(lastRow) {
        if (searchFlag) return;

        var pDate = '';
        var pAdminId = '';
        var pSeq = '';
        if (lastRow == undefined) {
            grid.data.length = 0;
            grid.rtnNextPageFunc = getData;
            grid.loadingPage = 0;
        } else {
            grid.loadingPage++;
            pDate = lastRow.pdate;
            pAdminId = lastRow.adminId;
            pSeq = lastRow.seq;
        }
        var startDt = $('#startDt').val().replaceAll("-", "");
        var endDt = $('#endDt').val().replaceAll("-", "");
        var adminId = $("#adminId").val();
        var pMenuId = $("#pMenuId").val();
        var menuId = $("#menuId").val();
        var searchStr = $('#searchStr').val();
        var operation = '';

        if (startDt > endDt) ui.alertMsg('<s:message code="blockHistoryNonBusi.msg.cannot.startendtime"/>');

        var options = $('#adminId option');

        /* if( adminId == '' ) {
			adminId = $.map(options ,function(option) {
				if( option.value != '') return option.value;
			}).join(',');
		} */
        grid.on();
        searchFlag = true;
        ui.get({
            url: 'getAuditList.xcn',
            pDate: pDate,
            pAdminId: pAdminId,
            pSeq: pSeq,
            adminId2: adminId2,
            firstAdminYn: firstAdminYn,
            adminType: adminType,
            startDt: startDt,
            endDt: endDt,
            adminId: adminId,
            pMenuId: pMenuId,
            menuId: menuId,
            operation: operation,
            searchStr: searchStr,
            offset: grid.data.length,
            limit: grid.pageSize,
            success: function (data, total) {
                grid.appendData(data);
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
                searchFlag = false;
                grid.off();
            }
        });
    }

    function getAdminOptions() {

        var result = '';

        if (firstAdminYn == 'Y') result += '<option value="">- <s:message code="auditLog.select.admin"/> -</option>';
        ui.get({
            url: 'getAdminList.xcn',
            adminId: adminId,
            firstAdminYn: firstAdminYn,
            adminType: adminType,
            asyncFlag: false,
            success: function (data, total) {
                for (var i = 0; i < data.length; i++) {
                    result += '<option value="' + data[i].adminId + '">' + data[i].adminName + ' (' + data[i].adminId + ')</option>';
                }
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
            }
        });
        return result;
    }
</script>
<div id="auditLogPop" class="modal">
	<div class="modal-content">
		<div class="modalHead">
			<h2><s:message code="auditLog.auditlogpop.title"/></h2>
			<span class="close" data-dismiss="modal">&times;</span>
		</div>
		<div class="modalCon">
			<div class="modalTop">
				<h3><s:message code="auditLog.information.msg"/></h3>
<%--				<p>
					<span class="red_dot veralign_middle"></span>
					<s:message code="common.required.msg"/>
				</p>--%>
			</div>
			<div class="modalbody">
				<div class="form-inline" id="modal_body_area"></div>
			</div>
			<div class="modalfooter">
				<button class="pop_btn01" data-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>

<div class="container">
	<div class="searchArea">
		<div class="searchSub">
			<div id="startDatePicker"><input type="date" id="startDt" style="width: 110px;">
				<span class="hyphen">~</span></div>
			<div id="endDatePicker"><input type="date" id="endDt" style="width: 110px;"></div>
			<div>
				<input type="text"  placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr" style="width: 300px;">
				<button class="form_btn01" accesskey="Q" id="searchBtn" accesskey="s">조회</button>
			</div>
		</div>
		<div class="searchSub">
			<div>
				<select id="adminId" style="width: 205px;">
					<option value="">- <s:message code="auditLog.select.admin"/> -</option>
				</select>
			</div>
			<div>
				<select id="pMenuId" style="width: 200px;">
					<option value="">- <s:message code="auditLog.select.pmenu"/> -</option>
				</select>
			</div>
			<div>
				<select id="menuId" style="width: 200px;">
					<option value="">- <s:message code="auditLog.select.menu"/> -</option>
				</select>
			</div>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub" style="height: 800px;">
			<div class="subtab">
				<button class="active">
					운용자 감사로그 목록
					<span></span>
				</button>
			</div>
			<div id="auditLogListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>
<script type="text/javascript">
    var grid = new Xgrid('auditLogListGrid', contextRoot, 60);
    grid.autoNumber();
    grid.colAdd('date', '<s:message code="auditLog.worktime"/>', 140, 'center', false, 'nomal');
    grid.colAdd('adminId', '<s:message code="auditLog.adminid"/>', 120, 'center', false, 'nomal');
    grid.colAdd('adminName', '<s:message code="auditLog.adminname"/>', 130, 'center', false, 'nomal');
    grid.colAdd('adminIp', '<s:message code="auditLog.adminip"/>', 120, 'center', false, 'nomal');
    grid.colAdd('pmenuId', '<s:message code="auditLog.pmenu"/>', 200, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        return menuArr.search(value, 'id', 'name');
    });
    grid.colAdd('menuId', '<s:message code="auditLog.menu"/>', 200, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        return menuArr.search(value, 'id', 'name');
    });
    grid.colAdd('operation', '<s:message code="auditLog.operation"/>', 200, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
        return operationArr.search(value, 'id', 'name');
    });
    grid.colAdd('information', '<s:message code="auditLog.information"/>', 400, 'left', false, 'link', function (row, cell, value, columnDef, dataContext) {
        return value.replaceAll('┌', '<br>');
    });

    grid.loadExportMenu('<s:message code="OPERATION_MGMT.AUDIT_LOG"/>');
    grid.loadPageSize();
    grid.loadHeader(false);

    grid.initData('<s:message code="common.msg.search.click"/>');
    grid.changePageSize = function (cnt) {
        getData();
    };
    grid.onClick = function () {
        if (grid.Col == grid.ColIndex('information')) {
            $("#auditLogPop").modal('show');

            var info = grid.getValue(grid.Row, 'information').replaceAll('┌', '<br>');
            $('#modal_body_area').html(info);
        }
    };
</script>