<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS PRO - <s:message code="DATA_MONITOR.GENERATIVEAI_SERVICE"/></title>
	<script type="text/javascript" src="<c:url value="/js/messenger.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/collection.js"/>"></script>
	<style>
		.clusterize-scroll{
			overflow: auto;
			height:100%;
		}
		@keyframes ddd{
			from{left:-5px} to{left:5px}
		}
		.lastReadLi .timeline-panel .list-group-item {
			background-color:#D3DBDC !important;
		}
		.lastReadLi .timeline-title, .lastReadLi .timeline-body {

		}
		.lastReadLi .panel_left:after {
			position: absolute !important;
			left: -14px !important;
			border-top: 7px solid transparent !important;
			border-left: 0 solid #D3DBDC !important;
			border-right: 14px solid #D3DBDC !important;
			border-bottom: 7px solid transparent !important;
		}

		.lastReadLi .panel_left:before {
			position: absolute !important;
			left: -13px !important;
			border-top: 8px solid transparent !important;
			border-left: 0px solid #D3DBDC !important;
			border-right: 13px solid #D3DBDC !important;
			border-bottom: 8px solid transparent !important;
		}
		.lastReadLi .panel_right:after {
			position: absolute !important;
			right: -14px !important;
			border-top: 7px solid transparent !important;
			border-left: 14px solid #D3DBDC !important;
			border-right: 0 solid #D3DBDC !important;
			border-bottom: 7px solid transparent !important;
		}

		.lastReadLi .panel_right:before {
			position: absolute !important;
			right: -13px !important;
			border-top: 8px solid transparent !important;
			border-left: 13px solid #D3DBDC !important;
			border-right: 0 solid #D3DBDC !important;
			border-bottom: 8px solid transparent !important;
		}
		:first-child.list-group-item, :last-child.list-group-item {
			border-radius: 0px !important;
		}

		#rightDiv {

		}

		.list-group-item.active, .list-group-item.active:focus, .list-group-item.active:hover {
			z-index: 2;
			color: #fff;
			background-color: #90abc3;
			opacity: .9;
			border-color: #ccc;
		}

		.list-group-item.active .list-group-item-text, .list-group-item.active:focus .list-group-item-text, .list-group-item.active:hover .list-group-item-text {
			color: #fff;
		}

		#groupPage a:hover{
			text-decoration: none;
		}
		#groupPage a:focus{
			text-decoration: none;
		}

		a.list-group-item, button.list-group-item{
			font-weight: normal;
			color: #999;
		}

		.list-group-item-text i {
			font-size: 16px;
		}

		#tab .active.btn, #tab .btn:active {
			background-color: #253f56;
			color: #fff;
			border-bottom-left-radius: 0px;
			border-bottom-right-radius: 0px;;
		}

		.bootstrap-datetimepicker-widget table td.disabled, .bootstrap-datetimepicker-widget table td.disabled:hover{
			color:#E4E4E4;
		}

		.cursor-text{
			cursor:text;
		}
		.cursor-pointer{
			cursor:pointer;
		}

		.maxwidth50{
			width:calc(100% - 50px);
		}

		.cursor-default{
			cursor:default;
		}
		.buttonArea{
			padding:7px;
		}
		.buttonArea:hover{
			background-color:#d4d4d4;
			border:1px solid #adadad;
		}
		.buttonArea:active{
			color:#333;
			background-color:#d4d4d4;
			border:1px solid #adadad;
			-webkit-box-shadow:inset 0 3px 5px rgba(0, 0, 0, .125);
			box-shadow:inset 0 3px 5px rgba(0, 0, 0, .125);
		}
		.input-group-addon:hover{
			background-color:#d4d4d4;
		}
		.clicked{
			background-color:#d4d4d4 !important;
			-webkit-box-shadow:inset 0 3px 5px rgba(0, 0, 0, .125);
			box-shadow:inset 0 3px 5px rgba(0, 0, 0, .125);
		}
		.file_link, .file_link > pre, .file_link > pre > code {
			text-decoration: underline;
			color: blue;
		}
		.file_link > pre {
			display: inline-block;
		}

		.bootstrap-select [data-id=serviceTypeSelect],
		.bootstrap-select [data-id=serviceTypeSelect] {
			width: 180px;
		}
		.bootstrap-select [data-id=deptSelect]
		{
			width: 150px;
		}
		#selectedCodeTitle {
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
		.tag {font-size: 100%; border: 1px solid #ccc; padding-top: 5px !important; }
		.tag-pill{border-radius: 0px !important;}
		.btn-primary {
			color: #fff !important;
			background-color: #253f56 !important;
			border-color: #253f56 !important;
		}

		.loading_div_grid{
			background-color: transparent !important;
		}
		.btnCustomPosition{
			position:inherit;
			top:125px;
			right:30px;
			z-index:999;
		}
		.input-group .show-tick{
			display:inline-block;
		}
		#group_list .ignoreHtmlPre {
			width: 72%;
		}
		.messenger_prev{
			position: relative;
			width: 30px;
			background-color: rgba(0, 94, 193, 0.32);
			text-align: center;
			margin-left: 50.5%;
			z-index: 100000;
			-moz-border-radius: 50px;
			-webkit-border-radius: 50px;
			border-radius: 50px;
			height: 30px;
			line-height: 30px;
			font-size: 10px;
			font-weight: bold;
			cursor: pointer;
			color:#fff;
			display:none;
		}
		.messenger_next{
			position: relative;
			width: 30px;
			background-color: rgba(0, 94, 193, 0.32);
			text-align: center;
			margin-left: 50.5%;
			z-index: 100000;
			-moz-border-radius: 50px;
			-webkit-border-radius: 50px;
			border-radius: 50px;
			height: 30px;
			line-height: 30px;
			font-size: 10px;
			font-weight: bold;
			cursor: pointer;
			color:#fff;
			display:none;
		}
	</style>
	<script type="text/javascript">
            var messengerListCnt = 0;
            var nodataMsg = '<s:message code="common.msg.nodata"/>';
            var chatting = '<s:message code="eikon.msg.chat"/>';
            var endChat = '<s:message code="eikon.msg.finish"/>';
            var unreadTitle = '<s:message code="eikon.msg.unreadTitle"/>';
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
            serviceAll:'<s:message code="condition.service.all"/>',
            messengerAll:'<s:message code="condition.messenger.all"/>',
            orgBusiAll:'<s:message code="common.org.busi.all"/>',
            orgDeptAll:'<s:message code="common.org.dept.all"/>',
            msgSelect_all:'<s:message code="common.msg.select_all"/>',
            msgUnselect_all:'<s:message code="common.msg.unselect_all"/>',
            msgNoresult:'<s:message code="common.msg.noresult"/>',
            msgConnectError:'<s:message code="common.msg.connect.error"/>',
            messageSelectDashboard:'<s:message code="condition.message.select.dashboard"/>',
            msgConfirmSave:'<s:message code="common.msg.confirm.save"/>',
            searchService:'<s:message code="condition.search.service"/>',
            authAlert:'<s:message code="admin.auth.alert"/>',
            noselect:'<s:message code="common.msg.noselect"/>'

        };
            $(document).ready(function(){
            $(window).resize(function() {
                if($(window).width() < 1700){
                    $('#searchResultBtnArea').addClass('btnCustomPosition');
                }else{
                    $('#searchResultBtnArea').removeClass('btnCustomPosition');
                }
            });

            $('#searchBtn').click(function(){
            if( messengerListCnt == 0 ) {
            ui.alertMsg('<s:message code="eikon.noList"/>');
            return;
        }
            var startDt = $('#startDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
            var endDt = $('#endDt').val().replaceAll("-","").replaceAll(":","").replace(/ /gi, '');
            if( startDt == ''){
            ui.alertMsg('<s:message code="message.message.startdt.input"/>');
            return;
        }
            if( endDt == ''){
            ui.alertMsg('<s:message code="message.message.enddt.input"/>');
            return;
        }
            if(startDt > endDt) {
            ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
            return;
        }
            if(getDayInterval(startDt, endDt) > 31) {
            ui.alertMsg('<s:message code="eikon.msg.select.date"/>');
            return;
        }

            getFiletransferList();
        });
            $("#searchStrInput").keypress(function(e){if( e.keyCode == 13) $('#searchBtn').click();}); //통합 검색 엔터키

            $('#searchMsgBtn').click(function(){
            if($('#searchMsgStrInput').val() == "") $('#searchMsgQueryBtn').click();
            else eikon.findMessageList(0);
            //eikon.getMessengerDetailList($('#xrootmtr').text(),$('#msgid').text(), $('#srcip').text());
        });
            $('#searchMsgQueryBtn').click(function(){
            var selectedUsrId = $('#selectUserInfo').attr('data-usrid');
            getDetailData(selectedUsrId);
        });
            $("#searchMsgStrInput").keypress(function(e){
            if( e.keyCode == 13) {
            if($('#searchMsgStrInput').val() == "") $('#searchMsgQueryBtn').click();
            else $('#searchMsgBtn').click();
        }
        });

            $('#searchMsgUp').click(function(){
            eikon.findMessageList(--searchOffset);
// 		checkList(--searchOffset);
        });
            $('#searchMsgDn').click(function(){
// 		checkList(++searchOffset);
            eikon.findMessageList(++searchOffset);
        });
            $('#listCntArea').click(function(){
            //if( $('#messageTotalCnt').html() == 0 || $('#messageTotalCnt').html() == '') return;
            openSelectDiv();
        });
            $('#userCntArea').click(function(){
            if( $('#selectUserInfo').html() == '-') return;
            openSelectUserDiv();
        });

            $('#dept').click(function(){
            var code = $(this).attr('id');
            openCodeWindow(code, $('#'+code+'Val').val(), $('#'+code+'Str').val());
        });


            $(document).on('mouseover', '.codeSelectedBtn', function(e){
            $('#selectedCodeTitle').show();
            $('#selectedCodeTitle').css('left', (e.pageX + 5)+'px');
            $('#selectedCodeTitle').css('top', (e.pageY - 120)+'px');

            var str = $(this).parent().find('.selectedTitle').val();
            if( str != undefined ) str = str.replaceAll('\\|', ',');
            $('#selectedCodeTitle').html(str);
        });

            $(document).on('mousemove', '.codeSelectedBtn', function(e){
            $('#selectedCodeTitle').css('left', (e.pageX + 5)+'px');
            $('#selectedCodeTitle').css('top', (e.pageY - 120)+'px');

            var str = $(this).parent().find('.selectedTitle').val();
            if( str != undefined ) str = str.replaceAll('\\|', ',');
            $('#selectedCodeTitle').html(str);
        });

            $(document).on('mouseout', '.codeSelectedBtn', function(e){
            $('#selectedCodeTitle').hide();
        });

            $(document).on('click', '.codeSelectedBtn', function(e){
            $('#deptVal, #deptStr').val('');
            $('#deptSelectedArea').hide();
        });



            $( 'input[name="searchType"]:radio' ).change(function(){
            getFiletransferList(1);
        });

            $('#groupFileCnt').click(function(){
            fileInfoViewer( $('#xrootmtr').text(), $('#srcip').text(), $('#usr_id').text() );
        });

            $('#groupParticipant').click(function(){
            participantInfoViewer( $('#xrootmtr').text(), $('#usr_id').text() );
        });


            $(document).on('click','.selectUser',function(){
            var name = $(this).attr('data-name');
            var srcip = $(this).attr('data-srcip');
            var usr_id = $(this).attr('data-usrid');
            var xrootmtr = $('#xrootmtr').text();
            var msgid = $('#msgid').text();
            $('#selectUserInfo').attr('data-srcip', srcip);
            $('#selectUserInfo').attr('data-name', name);
            $('#selectUserInfo').attr('data-usrid', usr_id);

            $('#selectUserInfo').html($(this).text());
            $('#srcip').text(srcip);
            $('#usr_id').text(usr_id);
            eikon.getMessengerGroupDetail(xrootmtr, msgid, srcip, usr_id);
            hideUserSelect();
        });

            initCondition();
            eikon.init();
// 	$('#searchBtn').click();

        });

            function openCodeWindow(id, oldCode, oldConm){
            $('#oldCode').val(oldCode);
            $('#oldConm').val(oldConm);

            var url    = '<c:url value="/commons/selectCode.do?codeType='+id+'"/>';
            var pop = fnOpenWindow('', 'selectCodeWinPopup', 1200, 700, 'resize');

            $('#codeParam').attr('target','selectCodeWinPopup');
            $('#codeParam').attr('action', url);
            $('#codeParam').attr('method','post');
            $('#codeParam').submit();
        }

            function initCondition(){
            getFileList();
            getCodeList('busi');
            getCodeList('dept');

            var dateObj = new Date();
            $('#startdatepicker').datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            locale: 'ko',
            sideBySide: true,
            defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate() - 1 ) )
        }).on("dp.change", function (e) {
            if( easyDateStartFlag ){
            easyDateStartFlag = false;
            return;
        }else{
            $('#easyDate').val('');
        }
        });
            $('#enddatepicker').datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            locale: 'ko',
            sideBySide: true,
            defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
        }).on("dp.change", function (e) {
            if( easyDateEndFlag ){
            easyDateEndFlag = false;
            return;
        }else{
            $('#easyDate').val('');
        }
        });

            $('#startsubdatepicker').datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            locale: 'ko',
            widgetParent : '.boxArea',
            sideBySide: true,
            defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-1 ) )
        }).on("dp.change", function (e) {
        }).on('dp.show', function(){
            var datepicker = $("body").find('.bootstrap-datetimepicker-widget:last');
            if (datepicker.hasClass('bottom')) {
            var top = $(this).offset().top + $(this).outerHeight();
            var left = $(this).offset().left;
            datepicker.css({
            'top': (top-80) + 'px',
            'bottom': 'auto',
            'left': left+'px'
        });
        }
        });
            $('#endsubdatepicker').datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            locale: 'ko',
            widgetParent : '.boxArea',
            sideBySide: true,
            defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
        }).on("dp.change", function (e) {
        }).on('dp.show', function(){
            var datepicker = $("body").find('.bootstrap-datetimepicker-widget:last');
            if (datepicker.hasClass('bottom')) {
            var top = $(this).offset().top + $(this).outerHeight();
            var left = $(this).offset().left;
            var rightDivWidth = $('#rightDiv').width();
            if(rightDivWidth < 640) left = left - 280;
            datepicker.css({
            'top': (top-80) + 'px',
            'bottom': 'auto',
            'left': (left)+'px'
        });
        }
        });
            $('#easyDate').change(function(){
            changeDate($(this).val());
        });
            $('#timedatepicker').datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'ko',
            defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
        }).on("dp.change", function (e) {
            var date = $(this).data("DateTimePicker").date().format('YYYY-MM-DD');
            detailDateFocus(date);

            $('#searchMsgStrInput').val('');
            $('#searchResult').html('');
            $('#searchResultArea').hide();
            $('#searchResultBtnArea').hide();
        });

            $('#serviceTypeSelect').selectpicker({
            container:'body',
            size: 15,
            width:'180px',
            noneSelectedText:condition.serviceAll,
            noneResultsText:condition.msgNoresult+' ',
            selectAllText:condition.msgSelect_all,
            deselectAllText:condition.msgUnselect_all,
            liveSearchPlaceholder:condition.searchService
        });

            $('#busiSelect').selectpicker({
            container:'body',
            size: 15,
            width:'180px',
            searchLabel:true,
            noneSelectedText:'<s:message code="common.org.busi.all"/>',
            noneResultsText:'<s:message code="common.msg.noresult"/>'+' ',
            selectAllText:'<s:message code="common.msg.select_all"/>',
            deselectAllText:'<s:message code="common.msg.unselect_all"/>'
        });
            /* $('#deptSelect').selectpicker({
				container:'body',
				size: 15,
				width:'222px',
				searchLabel:true,
				noneSelectedText:'<s:message code="common.org.dept.all"/>',
		noneResultsText:'<s:message code="common.msg.noresult"/>'+' ',
		selectAllText:'<s:message code="common.msg.select_all"/>',
		deselectAllText:'<s:message code="common.msg.unselect_all"/>'
	}); */

            $('#searchField').selectpicker({
            container:'body',
            width:'100px',
            noneSelectedText:'<s:message code="common.msg.all"/>'
        });

            $( 'input[name="attachYn"]:radio' ).change(function(){
            if($(this).val() == '') $("#searchField option:eq(1)").prop('disabled', false);
            else $("#searchField option:eq(1)").prop('disabled', true);

            $('#searchField').selectpicker('refresh');
        });
        }

            function getCodeList( codeType ){
            ui.get({
                url 		: 'getCodeList.xcn',
                codeType	: codeType,
                success 	: function(data, total) {
                    $('#'+codeType+'Select').html(getSelectOption( data ));
                    $('#'+codeType+'Select').selectpicker('refresh');
                    $('#'+codeType+'SelectPop').html(getSelectOption( data ));
                    $('#'+codeType+'SelectPop').selectpicker('refresh');
                },
                error 		: function(status, message) {
                    ui.alertMsg('error:' + status);
                },
                complete 	: function() {
                    searchFlag=false;
                }
            });
        }
            function getSelectOption( data ){
            var str = '';
            for (var i = 0; i < data.length; i++) {
            str += '<option value="'+data[i].code+'">'+data[i].codeName+'</option>';
        }
            return str;
        }


            function arrayToString( array ){
            if( array == null || array == undefined ) return "";
            else{
            return array.toString();
        }
        }
            function stringToArray( string ){
            if( string == null || string == undefined || string == '' ) return '';
            else if( typeof string !='string') return string;
            else{
            return string.split(',');
        }
        }

            function getSelectOptionMessenger( data ){
            //var str = '<option value="">- <s:message code="eikon.msg.svcType"/> -</option>';
            var str = '';
            for (var i = 0; i < data.length; i++) {
            str += '<option value="'+data[i].code+'">'+data[i].codeName+'</option>';
        }
            return str;
        }

            function getSelectedCodeData( codeType, data ) {
            var str = '';
            var val = '';
            for(var i=0; i<data.length; i++){
            str += data[i].codeName;
            val += data[i].code;
            if( codeType == 'regexp' ) {
            var arr = data[i].count.split('@');
            if( arr[0] == 'B' ) str += '(' + arr[1] + '<s:message code="selectCodeAll.items"/> ~ ' + arr[2] + '<s:message code="selectCodeAll.items"/>)';
            else if( arr[0] == 'L' ) str += '(' + arr[1] + '<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>)';
            else str += '(' + arr[1] + '<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.below"/>)';
            val += '%' + data[i].count;
        }

            if( i != data.length-1){
            str +=', ';
            val +='|';
        }
        }
            if( val != '' ){
            str = str.rtrim();
            val = val.trimAll();
        }

            $('#'+codeType+'Str').val(str);
            $('#'+codeType+'Val').val(val);

            if( $('#'+codeType+'Str').val() != '' ){
            $('#'+codeType+'SelectedArea').find('.btn').text(data.length);
            $('#'+codeType+'SelectedArea').show();
        }else{
            $('#'+codeType+'SelectedArea').find('.btn').text(0);
            $('#'+codeType+'SelectedArea').hide();
        }
        }

            function resetCode(codeType){
            if( codeType == 'deptByCo' )  $('#deptByCoStrSpan').html('');
            $('#'+codeType+'Val').val('');
            $('#'+codeType+'Str').val('');
            $('#'+codeType+'SelectedArea').hide();
        }
	</script>
</head>
<div class="container">
	<div class="boxArea">
		<div class="content_body">
			<div class="form-group form-inline not-dashed" style="padding-left: 10px; width: 100%;">
				<div class="input-group">
					<select id="serviceTypeSelect" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true">
					</select>
				</div>
				<div class="input-group" style="width: calc(90% - 300px);">
					<input type="text" class="form-control input-xs"
					       placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStrInput"
					       style="width: 100%;">
					<div class="input-group-btn" style="width:40px;">
						<button class="btn btn-md btn-success" type="button" accesskey="Q" id="searchBtn"><i
								class="glyphicon glyphicon-search"></i></button>
					</div>
				</div>
				<div class="checkbox " style="width:150px;">
					<label><input type="checkbox" name="readYn" id="readYn"><span class="fa fa-check"></span><s:message
							code="eikon.msg.notRead"/></label>
				</div>
			</div>
			<div style="background-color: #eee; margin-top: 5px;">
				<div  style="padding-left: 10px;">
					<div class="input-group select-xs" style="width:98px">
						<select name="searchArea" class="selectpicker" id="easyDate" data-style="btn-default btn-sm">
							<option value="" selected="selected"><s:message code="condition.select.period"/></option>
							<option value="1"><s:message code="condition.today"/></option>
							<option value="2"><s:message code="condition.yesterday"/></option>
							<option value="3"><s:message code="condition.week" arguments="1"/></option>
							<option value="6"><s:message code="condition.month" arguments="1"/></option>
						</select>
					</div>
					<div  style="padding-right:5px;">
						<div class="input-group">
							<div class="input-group date" id="startdatepicker">
								<input type="text" id="startDt" class="input-sm form-control border-radius-none" style="width: 150px;" />
								<span class="input-group-addon startDateBtn border-radius-none"> <span class="glyphicon glyphicon-calendar"></span>
										</span>
							</div>
						</div>
						~
						<div class="input-group">
							<div class="input-group date" id="enddatepicker">
								<input type="text" id="endDt" class="input-sm form-control border-radius-none" style="width: 150px;" />
								<span class="input-group-addon endDateBtn border-radius-none"><span class="glyphicon glyphicon-calendar"></span></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<input type="text" class="form-control input-sm"  placeholder="<s:message code="eikon.input.participation"/>" id="senders">
					</div>
					<div class="form-inline not-dashed" style="padding: 0px; margin: 0px;">
						<div class="btn-group filterBtn" data-toggle="buttons" style="float:left;padding-right:6px;">
							<label class="btn btn-sm btn-default active"><input type="radio" name="attachYn" id="attachAll" value="" checked>&nbsp; <s:message code="condition.isattached.all"/>&nbsp;&nbsp;</label>
							<label class="btn btn-sm btn-default"><input type="radio" name="attachYn" id="attachY" value="Y">&nbsp; <s:message code="eikon.attach.exist"/>&nbsp;&nbsp;</label>
						</div>
						<div class="input-group select-xs" style="width:180px;display:inline-block;">
							<select id="busiSelect" class="selectpicker" data-style="btn-default btn-sm" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
						</div>
						<%-- <div class="input-group select-xs" style="width:150px;display:inline-block;">
							<select id="deptSelect" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-live-search="true" data-actions-box="true"></select>
						</div> --%>
						<div id="selectedCodeTitle"></div>
						<div class="btn-group" data-toggle="buttons" style="margin-top: 0px;">
							<button type="button" class="btn btn-sm btn-default" id="dept"><span class="glyphicon glyphicon-plus-sign"></span>&nbsp;<s:message code="common.org.choose.dept"/></button>
							<span id="deptSelectedArea" class="codeSelectedBtn">
										<button type="button" class="btn"  style="z-index: 2">0</button>
									</span>
							<input type="hidden" id="deptStr" class="selectedTitle">
							<input type="hidden" id="deptVal">
						</div>

					</div>
					<div class="row" style="margin: 0px; margin-left: -1px; overflow: auto; height: calc(100% - 220px);">
						<div class="list-group" id="group_list" style="margin-bottom: 0px;">
							<a href="#" class="list-group-item list-group-item-action active" style="cursor:default;height:50px;">
								<p class="list-group-item-text" style="line-height:30px;">
									<i class="fa fa-envelope fa-sm"></i> <s:message code="eikon.msg.select.condition"/>
								</p>
							</a>
						</div>
					</div>
				</div>
			</div>
			<div style="height:30px;padding-left:32%; margin-top: 15px;" id="groupPage"></div>
		</div>

		</form>
	</div>
</div>
</div>


<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"></input>
	<input type="hidden" name="oldConm" id="oldConm"></input>
</form>

</html>


</script>