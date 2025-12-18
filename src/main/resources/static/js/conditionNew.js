var defaultFilterData = {
	"filterName": "",
	"filter_seq" : "",
	"p_filter_seq": "",
	"addServiceGroup":"",
	"searchTime":"",
	"conditions": []
};
var defaultConditions =[];
var defaultCondition = {
	//검색
	"searchStr": "",
	"searchField": "",
	"serviceType": "",

	// 대외비
	// "epmsg_type": "",
	// "initEpmsgName": "",

	//시간
	"easyDate": "",
	"startDt": "20180101000000",
	"endDt": "20180101235959",
	"ctimeWork": "",
	"period": 1,

	//정보
	"infoType":"",
	"feedbackType":"",
	"probType":"",

	//SK 확률정보
	"skInfoType":"",
	"skFeedbackType":"",
	"skProbType":"",

	//사용자
	"receiveSend": "",
	"receivers": "",
	"senders": "",
	"allOfus": "",
	"userGroupSeq": "",
	"userGroupName": "",
	"interGroup": "",
	"interGroupName": "",

	//조직
	"busi": "",
	"busiStr": "",
	"dept": "",
	"deptStr": "",

	//기타
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
	"realAttYn": "",
	"sctYn": "",
	"sizeType": "",
	"sizeStartVal": "0",
	"sizeEndVal": "0",
	"sizeOption": "L",
	"bodyImg" : "",
	"OCRYn" : "",
	//공통
	"sort": "ctime desc",
	"query": "",
	"filterType": "C",
	"reSearch": false,
	"reprocessYn": ""
};

var con = {
	/**
	 * condition 초기화
	 */
	init : function() {
		initCondition('');
		initCondition('Pop');
		initConditionData();

	},
	resetFilter : function( endId ){
		$('#filterName').val('');
		$('#filter_seq').val('');
		$('#p_filter_seq').val('');
		$('.relationKeywordBtn').prop('checked', false);
		$('#relationKeywordDiv').hide();

		if( isConsent() && endId == ''){
			$('#consentNo').val('');
			$('#consentName').text('');
			//$('#consentIp').val('');
			//$('#consentEmail').val('');
			$('#consentUserId').val('');
			$('#consentBtn').removeClass('active');
		}

		if( endId == '' || endId == undefined){
			$('#researchCheckbox').prop('disabled', true);
			$("input:checkbox[id='researchCheckbox"+endId+"']").prop("checked", false);

			easyDateStartFlag = true;
			easyDateEndFlag = true;

			var dateObj = new Date();
			$('#startdatepicker'+endId).data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-7, 00, 00, 00 ) );
			$('#enddatepicker'+endId).data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) );
			checkRadioBtn( 'easyDate', 3 );

			$('#solrQueryText').val('');

			if(!$('.filterIcon').hasClass('hide')) {
				$('.filterIcon').addClass('hide');
				$('.filterIcon').attr('title', '');
				$('.filterIcon').attr('data-id', '');
			}

			if(!$('.queryIcon').hasClass('hide')) {
				$('.queryIcon').addClass('hide');
				$('.queryIcon').attr('title', '');
				$('.queryIcon').attr('data-id', '');
			}
		}else{
			$('#filterNamePopInput').val('');
			$('#filterOptionPopSelect').val('1');
			$('#startDayPop').val('');
			$('#endDayPop').val('');
			$('#normalDateArea').show();
			$('#simpleDateArea').hide();
			$('#noselectDateArea').hide();
			checkRadioBtn( 'dashboardSelPop', '' );

			checkRadioBtn( 'filterTypePop', 'D' );
			$('#selectConditionPopArea').show();
			$('#selectQueryPopArea').hide();
			$('#queryInputTextareaPop').val('');
		}
		$('#messageSort'+endId).val('ctime desc');
		$('#searchStrInput'+endId).val('');
		$('#serviceType'+endId).selectpicker('val', []);

		if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ) {
			$('#infoType'+endId).selectpicker('val', []);
			$('#feedbackType'+endId).selectpicker('val', []);
			$('#probType'+endId).selectpicker('val', []);
			if(infoHynixConf == 'true'){
				$('#skInfoType'+endId).selectpicker('val', []);
				$('#skFeedbackType'+endId).selectpicker('val', []);
				$('#skProbType'+endId).selectpicker('val', []);
			}
		}

		$('#searchField'+endId).selectpicker('val', []);
		$('#easyDate'+endId).val('');
		$('#interGroup'+endId).val('');
		$('#userGroupSeq'+endId).val('');
		checkRadioBtn( 'drmYn'+endId, '' );
		checkRadioBtn( 'realAttYn'+endId, '' );
		checkRadioBtn( 'sctYn'+endId, '' );
		checkRadioBtn( 'ctimeWork'+endId, '' );

		checkRadioBtn( 'bodyImg'+endId, '' );
		checkRadioBtn( 'OCRYn'+endId, '' );
		checkRadioBtn( 'readYn'+endId, '' );
		checkRadioBtn( 'receiveSend'+endId, '' );

		checkRadioBtn( 'receive_option'+endId, '' );
		$('.receivers_detail').hide();
		$('#receivers').parent().show();
		$('#receivers').parent().before().show();

		$('#receivers'+endId).val('');
		$('#m_to'+endId).val('');
		$('#m_cc'+endId).val('');
		$('#m_bcc'+endId).val('');
		$('#senders'+endId).val('');
		$('#rcvJikgub'+endId).selectpicker('val', []);

		// $('#initEpmsg'+endId).selectpicker('val', []);

		$('#busi'+endId).selectpicker('val', [] );
		$('#deptStr'+endId).val('');
		$('#deptVal'+endId).val('');
		setCodeCount('dept', endId, '', ',');

		$('#url'+endId).val('');
		$('#regexPattern'+endId).val('');

		checkRadioBtn( 'serviceYn'+endId, '' );
		checkRadioBtn( 'attachYn'+endId, '' );
		setCodeCount('attach', endId, '', '|');

		checkRadioBtn( 'keywordYn'+endId, '' );
		setCodeCount('keyword', endId, '', '|');

		checkRadioBtn( 'regexpYn'+endId, '' );
		setCodeCount('regexp', endId, '', '|');

		$('#allOfus'+endId).val('');

		$('#sizeStartVal'+endId).val('');
		$('#sizeEndVal'+endId).val('');
		$('#sizeOption'+endId).val('L');
		checkRadioBtn( 'sizeType'+endId, '' );
		checkRadioBtn( 'reprocessYn'+endId, '' );

		$('input:checkbox[id="senders_not"]').prop("checked", false);
		$('input:checkbox[id="senders_not"]').prop("disabled", true);
		$('input:checkbox[id="adminAllRead"]').prop("checked", true);
		$('input:checkbox[id="receivers_not"]').prop("checked", false);
		$('input:checkbox[id="receivers_not"]').prop("disabled", true);
		$('input:checkbox[id="attachYn_not"]').prop("checked", false);
		$('input:checkbox[id="attachYn_not"]').prop("disabled", true);
		$('input:checkbox[id="keywordYn_not"]').prop("checked", false);
		$('input:checkbox[id="keywordYn_not"]').prop("disabled", true);
		$('input:checkbox[id="busi_not"]').prop("checked", false);
		$('input:checkbox[id="busi_not"]').prop("disabled", true);
		$('input:checkbox[id="recv_jikgub_not"]').prop("checked", false);
		$('input:checkbox[id="recv_jikgub_not"]').prop("disabled", true);
		$('input:checkbox[id="dept_not"]').prop("checked", false);
		$('input:checkbox[id="dept_not"]').prop("disabled", true);
		$('input:checkbox[id="userGroupSeq_not"]').prop("checked", false);
		$('input:checkbox[id="userGroupSeq_not"]').prop("disabled", true);
		$('input:checkbox[id="interGroup_not"]').prop("checked", false);
		$('input:checkbox[id="interGroup_not"]').prop("disabled", true);
		if(rsUppercase == "Y") {
			$('input:checkbox[id="senders_upperCase"]').prop("checked", false);
			$('input:checkbox[id="senders_upperCase"]').prop("disabled", true);
			$('input:checkbox[id="receivers_upperCase"]').prop("checked", false);
			$('input:checkbox[id="receivers_upperCase"]').prop("disabled", true);
		}

		$('input:checkbox[id="m_to_not"]').prop("checked", false);
		$('input:checkbox[id="m_to_not"]').prop("disabled", true);
		$('input:checkbox[id="m_to_findByKeyword"]').prop("checked", false);
		$('input:checkbox[id="m_to_findByKeyword"]').prop("disabled", true);
		$('input:checkbox[id="m_to_findByParam"]').prop("checked", false);
		$('input:checkbox[id="m_to_findByParam"]').prop("disabled", true);
		$('input:checkbox[id="m_cc_not"]').prop("checked", false);
		$('input:checkbox[id="m_cc_not"]').prop("disabled", true);
		$('input:checkbox[id="m_cc_findByKeyword"]').prop("checked", false);
		$('input:checkbox[id="m_cc_findByKeyword"]').prop("disabled", true);
		$('input:checkbox[id="m_cc_findByParam"]').prop("checked", false);
		$('input:checkbox[id="m_cc_findByParam"]').prop("disabled", true);
		$('input:checkbox[id="m_bcc_not"]').prop("checked", false);
		$('input:checkbox[id="m_bcc_not"]').prop("disabled", true);
		$('input:checkbox[id="m_bcc_findByKeyword"]').prop("checked", false);
		$('input:checkbox[id="m_bcc_findByKeyword"]').prop("disabled", true);
		$('input:checkbox[id="m_bcc_findByParam"]').prop("checked", false);
		$('input:checkbox[id="m_bcc_findByParam"]').prop("disabled", true);
		$('input:checkbox[id="url_not"]').prop("checked", false);
		$('input:checkbox[id="url_not"]').prop("disabled", true);

		$('#attachBtn').prop("disabled", true);
		$('#keywordBtn').prop("disabled", true);
		$('#regexpBtn').prop("disabled", true);
		$('input:radio[name="realAttYn"]').prop("disabled", true);
		$('input:radio[name="drmYn"]').prop("disabled", true);

	},
	/**
	 * 검색을 위한 filterVal 데이터를 가져온다
	 */
	// type = N : 신규 생성을 위한 데이터
	// type = D : 일반 검색
	// type = Q : 고급 검색
	getFilterVal : function(endId, type) {
		var filterName = '';
		var filter_seq = '';
		var p_filter_seq = '';
		var filterType = '';
		var filterId = type == 'N' ? 1000 : '';

		if(!document.getElementById('msg_condition_menu')) {
			filterType = 'Q';
		}else if(!$('#msg_condition_menu').hasClass('condition_menu_unselected')){
			filterType = 'D';
			if( $('.filterIcon').attr('data-id') != '') filterId = $('.filterIcon').attr('data-id');
		}else if(!$('#msg_condition_saver').hasClass('condition_menu_unselected')){
			filterType = 'Q';
			if( $('.queryIcon').attr('data-id') != '') filterId = $('.queryIcon').attr('data-id');
		}

		if(filterId != ''){
			var filterTree = $.fn.zTree.getZTreeObj("filterTree");
			var treeNode = filterTree.getNodeByParam("id", filterId, null);
			if(treeNode != null){
				if($('#filterNamePopInput').val() == ''){
					filterName = treeNode.name;
				}else{
					filterName = $('#filterNamePopInput').val();
				}
				filter_seq = treeNode.id;
				p_filter_seq = treeNode.pId;
			}
		}

		var filterVal = {
			"filterName": filterName,
			"filter_seq" : filter_seq,
			"p_filter_seq": p_filter_seq,
			"filterType": filterType,
			"conditions": con.getConditions(endId, type)
		};

		if( isConsent() && endId == ''){
			filterVal.consentNo = $('#consentNo').val();
			filterVal.consentName = $('#consentName').text();
			filterVal.consentShortName = $('#consentShortName').val();
			filterVal.consentUserId = $('#consentUserId').val();
		}
		return filterVal;
	},
	/**
	 * filterVal값을 조건에 적용
	 */
	setFilterVal : function(filterVal) {
		if(filterVal.filter_seq != '' && filterVal.filter_seq != undefined){
			var query = filterVal.conditions[0].query;
			if( query != '' && query != undefined){
				$('.queryIcon').removeClass('hide');
				$('.queryIcon').attr('title', filterVal.name);
				$('.queryIcon').attr('data-id', filterVal.id);
				$('.filterIcon').addClass('hide');
				$('.filterIcon').attr('title', '');
				$('.filterIcon').attr('data-id', '');
			}else{
				$('.queryIcon').addClass('hide');
				$('.queryIcon').attr('title', '');
				$('.queryIcon').attr('data-id', '');
				$('.filterIcon').removeClass('hide');
				$('.filterIcon').attr('title', filterVal.name);
				$('.filterIcon').attr('data-id', filterVal.id);
			}
		}else{
			$('.queryIcon').addClass('hide');
			$('.queryIcon').attr('title', '');
			$('.queryIcon').attr('data-id', '');
			$('.filterIcon').addClass('hide');
			$('.filterIcon').attr('title', '');
			$('.filterIcon').attr('data-id', '');
		}
		$('#researchCheckbox').prop('disabled', false);
		if(filterVal.conditions.length > 1){
			$("input:checkbox[id='researchCheckbox']").prop("checked", true);
		}else{
			$("input:checkbox[id='researchCheckbox']").prop("checked", false);
		}

		if(filterVal != undefined) con.setCondition(filterVal.conditions[filterVal.conditions.length-1], '');
	},
	/**
	 * 조건을 JSONArray로 불러온다
	 */
	getConditions : function(endId, type) {
		var array = [];
		if(getIframeListObj().filterValData != undefined && getIframeListObj().filterValData.conditions != undefined && $("input:checkbox[id='researchCheckbox']").is(":checked")){
			array= $.extend(true, [], getIframeListObj().filterValData.conditions);
		}
		array.push(con.getCondition(endId, type));
		return array;
	},
	/**
	 * 조건을 JSONObject로 불러온다.
	 */
	getCondition : function(endId, type) { // type- N: 신규검색
		var condition = {};

		if(!document.getElementById('msg_condition_menu') || !$('#msg_condition_saver').hasClass('condition_menu_unselected')){
			condition.query = $('#solrQueryText').val();
			condition.sort = $('#messageSort').val();

			if(pageType == 'M') condition.svc1_not = 'U';
			else if(pageType == 'U') condition.svc1 = 'U';

			return condition;
		}

		if( endId != '' && endId != undefined){
			condition.easyDate = '';
			var period = $('#filterOptionPopSelect').val();
			var startDt = $('#startdatepicker'+endId).data("DateTimePicker").date().format('YYYYMMDDHHmmss');
			var endDt = $('#enddatepicker'+endId).data("DateTimePicker").date().format('YYYYMMDDHHmmss');
			if( period == 2 ){
				startDt = $('#startDayPop').val();
				endDt = $('#endDayPop').val();
			}else if( period == 3 ){
				startDt = '';
				endDt = '';
			}
			condition.period = period;
			condition.startDt = startDt;
			condition.endDt = endDt;

		}else{
			condition.easyDate = $('#easyDate').val();
			condition.startDt = $('#startdatepicker'+endId).data("DateTimePicker").date().format('YYYYMMDDHHmmss');
			condition.endDt = $('#enddatepicker'+endId).data("DateTimePicker").date().format('YYYYMMDDHHmmss');
			condition.period = 1;

		}

		condition.searchStr = $('#searchStrInput').val();
		condition.searchField = arrayToString($('#searchField').selectpicker('val'));
		condition.serviceType = arrayToString($('#serviceType').selectpicker('val'));

		condition.receiveSend = $('input:radio[name=receiveSend]:input:checked').val();
		condition.receive_option = $('input:radio[name=receive_option]:input:checked').val();

		if(condition.receive_option == ''){
			condition.receivers = $('#receivers').val();
			if(rsUppercase == "Y") {
				condition.receivers_upperCase = $('input:checkbox[id="receivers_upperCase"]').is(":checked") ? 'Y' : '';
			}
			condition.receivers_not = $('input:checkbox[id="receivers_not"]').is(":checked") ? 'Y' : '';
			condition.receivers_findByKeyword = $('input:checkbox[id="receivers_findByKeyword"]').is(":checked") ? 'Y' : '';
			if ($('input:checkbox[id="receivers_findByKeyword"]').is(":checked")) {
				condition.findByParam = ''; // 부분일치
			} else {
				condition.findByParam = $('input:checkbox[id="receivers_findByParam"]').is(":checked") ? 'Y' : '';
			}
		}else{
			condition.receivers = '';
			condition.receivers_not = '';
			condition.receivers_findByKeyword = $('input:checkbox[id="receivers_findByKeyword"]').is(":checked") ? 'Y' : '';
			if ($('input:checkbox[id="receivers_findByKeyword"]').is(":checked")) {
				condition.findByParam = ''; // 부분일치
			} else {
				condition.findByParam = $('input:checkbox[id="receivers_findByParam"]').is(":checked") ? 'Y' : '';
			}
			if(rsUppercase == "Y") {
				condition.receivers_upperCase = '';
			}
			condition.m_to = $('#m_to').val();
			condition.m_to_not = $('input:checkbox[id="m_to_not"]').is(":checked") ? 'Y' : '';
			condition.m_to_findByKeyword = $('input:checkbox[id="m_to_findByKeyword"]').is(":checked") ? 'Y' : '';
			condition.m_to_findByParam = $('input:checkbox[id="m_to_findByParam"]').is(":checked") ? 'Y' : '';
			condition.m_cc = $('#m_cc').val();
			condition.m_cc_not = $('input:checkbox[id="m_cc_not"]').is(":checked") ? 'Y' : '';
			condition.m_cc_findByKeyword = $('input:checkbox[id="m_cc_findByKeyword"]').is(":checked") ? 'Y' : '';
			condition.m_cc_findByParam = $('input:checkbox[id="m_cc_findByParam"]').is(":checked") ? 'Y' : '';
			condition.m_bcc = $('#m_bcc').val();
			condition.m_bcc_not = $('input:checkbox[id="m_bcc_not"]').is(":checked") ? 'Y' : '';
			condition.m_bcc_findByKeyword = $('input:checkbox[id="m_bcc_findByKeyword"]').is(":checked") ? 'Y' : '';
			condition.m_bcc_findByParam = $('input:checkbox[id="m_bcc_findByParam"]').is(":checked") ? 'Y' : '';
		}

		if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ) {
			condition.infoType = arrayToString($('#infoType').selectpicker('val'));
			condition.feedbackType = arrayToString($('#feedbackType').selectpicker('val'));
			condition.probType = arrayToString($('#probType').selectpicker('val'));
			if(infoHynixConf == 'true'){
				condition.skInfoType = arrayToString($('#skInfoType').selectpicker('val'));
				condition.skFeedbackType = arrayToString($('#skFeedbackType').selectpicker('val'));
				condition.skProbType = arrayToString($('#skProbType').selectpicker('val'));
			}
		}

		condition.rcvJikgub = arrayToString($('#rcvJikgub').selectpicker('val'));
		condition.recv_jikgub_not = $('input:checkbox[id="recv_jikgub_not"]').is(":checked") ? 'Y' : '';
		condition.adminAllRead = $('input:checkbox[id="adminAllRead"]').is(":checked") ? 'Y' : '';
		condition.senders = $('#senders').val();
		if(rsUppercase == "Y") {
			condition.senders_upperCase = $('input:checkbox[id="senders_upperCase"]').is(":checked") ? 'Y' : '';
		}
		condition.senders_not = $('input:checkbox[id="senders_not"]').is(":checked") ? 'Y' : '';
		condition.senders_findByKeyword = $('input:checkbox[id="senders_findByKeyword"]').is(":checked") ? 'Y' : '';
		if ($('input:checkbox[id="senders_findByKeyword"]').is(":checked")) {
			condition.senders_findByParam = ''; // 부분일치
		} else {
			condition.senders_findByParam = $('input:checkbox[id="senders_findByParam"]').is(":checked") ? 'Y' : '';
		}

		condition.allOfus = $('#allOfus').val();

		condition.userGroupSeq = $('#userGroupSeq').val();
		condition.userGroupSeq_not = $('input:checkbox[id="userGroupSeq_not"]').is(":checked") ? 'Y' : '';
		if(condition.userGroupSeq != '') condition.userGroupName = $('#userGroupSeq option:selected').text();
		else condition.userGroupName = '';

		condition.interGroup = $('#interGroup').val();
		condition.interGroup_not = $('input:checkbox[id="interGroup_not"]').is(":checked") ? 'Y' : '';
		if(condition.interGroup != '') condition.interGroupName = $('#interGroup option:selected').text();
		else condition.interGroupName = '';

		// condition.epmsgType = arrayToString($('#initEpmsg').selectpicker('val'));

		condition.busi = arrayToString($('#busi').selectpicker('val'));
		condition.busi_not = $('input:checkbox[id="busi_not"]').is(":checked") ? 'Y' : '';

		if(condition.busi != '') condition.busiStr = $('#busi').parent().find('.filter-option').text();
		else condition.busiStr = '';

		condition.dept = $('#deptVal').val();
		condition.dept_not = $('input:checkbox[id="dept_not"]').is(":checked") ? 'Y' : '';

		if(condition.dept != '') condition.deptStr = $('#deptStr').val();
		else condition.deptStr = '';

		condition.url = $('#url').val();
		condition.url_not = $('input:checkbox[id="url_not"]').is(":checked") ? 'Y' : '';

		condition.readYn = $('input:radio[name=readYn]:input:checked').val();
		condition.OCRYn = $('input:radio[name=OCRYn]:input:checked').val();
		condition.bodyImg = $('input:radio[name=bodyImg]:input:checked').val();

		condition.attachYn = $('input:radio[name=attachYn]:input:checked').val();
		condition.attachVal = $('#attachVal').val();
		condition.attachStr = $('#attachStr').val();
		condition.attachYn_not = $('input:checkbox[id="attachYn_not"]').is(":checked") ? 'Y' : '';

		condition.keywordYn = $('input:radio[name=keywordYn]:input:checked').val();
		condition.keywordVal = $('#keywordVal').val();
		condition.keywordStr = $('#keywordStr').val();
		condition.keywordYn_not = $('input:checkbox[id="keywordYn_not"]').is(":checked") ? 'Y' : '';

		condition.regexpYn = $('input:radio[name=regexpYn]:input:checked').val();
		condition.regexpVal = $('#regexpVal').val();
		condition.regexpStr = $('#regexpStr').val();
		condition.regexPattern = $('#regexPattern').val();
		condition.drmYn = $('input:radio[name=drmYn]:input:checked').val();
		condition.realAttYn = $('input:radio[name=realAttYn]:input:checked').val();
		condition.sctYn = $('input:radio[name=sctYn]:input:checked').val();

		if($('#sizeStartVal').val() >= 0){
			condition.sizeStartVal = $('#sizeStartVal').val()*1024;
		}else{
			condition.sizeStartVal = '';
		}
		if($('#sizeEndVal').val() >= 0){
			condition.sizeEndVal = $('#sizeEndVal').val()*1024;
		}else{
			condition.sizeEndVal = '';
		}

		condition.sizeOption = $('#sizeOption').val();
		condition.sizeType = $('input:radio[name=sizeType'+']:input:checked').val();
		condition.reprocessYn = $('input:radio[name=reprocessYn'+']:input:checked').val();

		condition.sort = $('#messageSort').val();
		condition.reSearch = $("input:checkbox[id='researchCheckbox']").is(":checked");
		condition.ctimeWork = $('input:radio[name=ctimeWork'+']:input:checked').val();

		if(pageType == 'M') condition.svc1_not = 'U';
		else if(pageType == 'U') condition.svc1 = 'U';

		return condition;

	},
	/**
	 * JSONObject 형식의 조건을 화면에 셋팅한다.
	 */
	setCondition : function(condition, endId) {

		$('#easyDate').val(condition.easyDate);

		if( endId != '' && endId != undefined){
			$('#filterOptionPopSelect').val( condition.period );
			$('#filterOptionPopSelect').change();

			if( condition.period == 1){
				$('#startdatepicker'+endId).data("DateTimePicker").date(condition.startDt.toDate());
				$('#enddatepicker'+endId).data("DateTimePicker").date(condition.endDt.toDate());
			}else if( condition.period == 2){
				$('#startDayPop').val(condition.startDt);
				$('#endDayPop').val(condition.endDt);
			}
		}
		else{
			if( condition.period == 1){
				$('#startdatepicker').data("DateTimePicker").date(condition.startDt.toDate());
				$('#enddatepicker').data("DateTimePicker").date(condition.endDt.toDate());
			}else if( condition.period == 2){
				var dateObj = new Date();
				$('#startdatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-condition.startDt, 00, 00, 00 ) );
				$('#enddatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-condition.endDt, 23, 59, 59 ) );
			}else if( condition.startDt != undefined && condition.startDt != ''){
				$('#startdatepicker').data("DateTimePicker").date(condition.startDt);
				$('#enddatepicker').data("DateTimePicker").date(condition.endDt);
			}

			$('#solrQueryText').val(condition.query);
		}
		$('#searchStrInput').val(condition.searchStr);
		$('#searchField').selectpicker('val', stringToArray(condition.searchField) );
		$('#serviceType').selectpicker('val', stringToArray(condition.serviceType) );

		if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ) {
			$('#infoType').selectpicker('val', stringToArray(condition.infoType) );
			$('#feedbackType').selectpicker('val', stringToArray(condition.feedbackType) );
			$('#probType').selectpicker('val', stringToArray(condition.probType) );
			if(infoHynixConf == 'true'){
				$('#skInfoType').selectpicker('val', stringToArray(condition.skInfoType) );
				$('#skFeedbackType').selectpicker('val', stringToArray(condition.skFeedbackType) );
				$('#skProbType').selectpicker('val', stringToArray(condition.skProbType) );
			}
		}

		checkRadioBtn( 'receiveSend', condition.receiveSend );
		checkRadioBtn( 'receive_option', condition.receive_option );
		if (condition.receive_option == '') {
			$('#receive_option_all').click();
			$('#receivers').val(condition.receivers);
			var receivers_hasValue = condition.receivers != '' && condition.receivers != null;
			$('input:checkbox[id="receivers_not"]').prop("disabled", !receivers_hasValue);
			$('input:checkbox[id="receivers_not"]').prop("checked", condition.receivers_not == 'Y' ? true : false);
			$('input:checkbox[id="receivers_findByKeyword"]').prop("disabled", !receivers_hasValue);
			$('input:checkbox[id="receivers_findByParam"]').prop("disabled", !receivers_hasValue);
			var receivers_findByParam_checked = condition.findByParam == 'Y' ? true : false;
			var receivers_findByKeyword_checked = condition.findByKeyword == 'Y' ? true :
				(receivers_hasValue && condition.findByKeyword != 'Y' && condition.findByParam != 'Y' ? true : false);
			if (receivers_findByParam_checked) {
				receivers_findByKeyword_checked = false;
			} else if (receivers_findByKeyword_checked) {
				receivers_findByParam_checked = false;
			}
			$('input:checkbox[id="receivers_findByKeyword"]').prop("checked", receivers_findByKeyword_checked);
			$('input:checkbox[id="receivers_findByParam"]').prop("checked", receivers_findByParam_checked);
			if(rsUppercase == "Y") {
				$('input:checkbox[id="receivers_upperCase"]').prop("disabled", condition.receivers == '' ? true : false);
				$('input:checkbox[id="receivers_upperCase"]').prop("checked", condition.receivers_upperCase == 'Y' ? true : false);
			}
		}else{
			// m_to, m_cc, m_bcc와 rcvTo, rcvCc, rcvBcc 중 어느 것을 사용할지 결정
			var m_to_val = (condition.m_to != undefined && condition.m_to != null && condition.m_to != '') ? condition.m_to : (condition.rcvTo != undefined ? condition.rcvTo : '');
			var m_cc_val = (condition.m_cc != undefined && condition.m_cc != null && condition.m_cc != '') ? condition.m_cc : (condition.rcvCc != undefined ? condition.rcvCc : '');
			var m_bcc_val = (condition.m_bcc != undefined && condition.m_bcc != null && condition.m_bcc != '') ? condition.m_bcc : (condition.rcvBcc != undefined ? condition.rcvBcc : '');

			// 체크박스 상태 값도 두 가지 필드명을 모두 확인
			var m_to_not_val = (condition.m_to_not != undefined) ? condition.m_to_not : (condition.rcvTo_not != undefined ? condition.rcvTo_not : '');
			var m_to_findByKeyword_val = (condition.m_to_findByKeyword != undefined) ? condition.m_to_findByKeyword : (condition.rcvTo_findByKeyword != undefined ? condition.rcvTo_findByKeyword : '');
			var m_to_findByParam_val = (condition.m_to_findByParam != undefined) ? condition.m_to_findByParam : (condition.rcvTo_findByParam != undefined ? condition.rcvTo_findByParam : '');

			var m_cc_not_val = (condition.m_cc_not != undefined) ? condition.m_cc_not : (condition.rcvCc_not != undefined ? condition.rcvCc_not : '');
			var m_cc_findByKeyword_val = (condition.m_cc_findByKeyword != undefined) ? condition.m_cc_findByKeyword : (condition.rcvCc_findByKeyword != undefined ? condition.rcvCc_findByKeyword : '');
			var m_cc_findByParam_val = (condition.m_cc_findByParam != undefined) ? condition.m_cc_findByParam : (condition.rcvCc_findByParam != undefined ? condition.rcvCc_findByParam : '');

			var m_bcc_not_val = (condition.m_bcc_not != undefined) ? condition.m_bcc_not : (condition.rcvBcc_not != undefined ? condition.rcvBcc_not : '');
			var m_bcc_findByKeyword_val = (condition.m_bcc_findByKeyword != undefined) ? condition.m_bcc_findByKeyword : (condition.rcvBcc_findByKeyword != undefined ? condition.rcvBcc_findByKeyword : '');
			var m_bcc_findByParam_val = (condition.m_bcc_findByParam != undefined) ? condition.m_bcc_findByParam : (condition.rcvBcc_findByParam != undefined ? condition.rcvBcc_findByParam : '');

			$('#m_to').val(m_to_val);
			$('#m_cc').val(m_cc_val);
			$('#m_bcc').val(m_bcc_val);

			$('#receive_option_more').click();

			// setTimeout 제거 - 동기적으로 체크박스 설정 (searchData 호출 전에 완료되어야 함)
			var m_to_hasValue = m_to_val != '' && m_to_val != null;
			var m_cc_hasValue = m_cc_val != '' && m_cc_val != null;
			var m_bcc_hasValue = m_bcc_val != '' && m_bcc_val != null;

			$('input:checkbox[id="m_to_not"]').prop("disabled", !m_to_hasValue);
			$('input:checkbox[id="m_to_not"]').prop("checked", m_to_not_val == 'Y' ? true : false);
			$('input:checkbox[id="m_to_findByKeyword"]').prop("disabled", !m_to_hasValue);
			$('input:checkbox[id="m_to_findByParam"]').prop("disabled", !m_to_hasValue);
			// m_to_findByKeyword를 먼저 확인 (rcvTo_findByKeyword 우선)
			var m_to_findByKeyword_checked = false;
			var m_to_findByParam_checked = false;
			
			if (m_to_findByKeyword_val == 'Y') {
				// 부분일치가 명시적으로 선택된 경우
				m_to_findByKeyword_checked = true;
				m_to_findByParam_checked = false;
			} else if (m_to_findByParam_val == 'Y') {
				// 전체일치가 명시적으로 선택된 경우
				m_to_findByKeyword_checked = false;
				m_to_findByParam_checked = true;
			} else if (m_to_hasValue) {
				// 값이 있지만 둘 다 선택되지 않은 경우 기본값 (부분일치)
				m_to_findByKeyword_checked = true;
				m_to_findByParam_checked = false;
			}
			
			$('input:checkbox[id="m_to_findByKeyword"]').prop("checked", m_to_findByKeyword_checked);
			$('input:checkbox[id="m_to_findByParam"]').prop("checked", m_to_findByParam_checked);

			$('input:checkbox[id="m_cc_not"]').prop("disabled", !m_cc_hasValue);
			$('input:checkbox[id="m_cc_not"]').prop("checked", m_cc_not_val == 'Y' ? true : false);
			$('input:checkbox[id="m_cc_findByKeyword"]').prop("disabled", !m_cc_hasValue);
			$('input:checkbox[id="m_cc_findByParam"]').prop("disabled", !m_cc_hasValue);

			// m_cc_findByKeyword를 먼저 확인 (rcvCc_findByKeyword 우선)
			var m_cc_findByKeyword_checked = false;
			var m_cc_findByParam_checked = false;
			
			if (m_cc_findByKeyword_val == 'Y') {
				// 부분일치가 명시적으로 선택된 경우
				m_cc_findByKeyword_checked = true;
				m_cc_findByParam_checked = false;
			} else if (m_cc_findByParam_val == 'Y') {
				// 전체일치가 명시적으로 선택된 경우
				m_cc_findByKeyword_checked = false;
				m_cc_findByParam_checked = true;
			} else if (m_cc_hasValue) {
				// 값이 있지만 둘 다 선택되지 않은 경우 기본값 (부분일치)
				m_cc_findByKeyword_checked = true;
				m_cc_findByParam_checked = false;
			}
			
			$('input:checkbox[id="m_cc_findByKeyword"]').prop("checked", m_cc_findByKeyword_checked);
			$('input:checkbox[id="m_cc_findByParam"]').prop("checked", m_cc_findByParam_checked);

			$('input:checkbox[id="m_bcc_not"]').prop("disabled", !m_bcc_hasValue);
			$('input:checkbox[id="m_bcc_not"]').prop("checked", m_bcc_not_val == 'Y' ? true : false);
			$('input:checkbox[id="m_bcc_findByKeyword"]').prop("disabled", !m_bcc_hasValue);
			$('input:checkbox[id="m_bcc_findByParam"]').prop("disabled", !m_bcc_hasValue);
			// m_bcc_findByKeyword를 먼저 확인 (rcvBcc_findByKeyword 우선)
			var m_bcc_findByKeyword_checked = false;
			var m_bcc_findByParam_checked = false;
			
			if (m_bcc_findByKeyword_val == 'Y') {
				// 부분일치가 명시적으로 선택된 경우
				m_bcc_findByKeyword_checked = true;
				m_bcc_findByParam_checked = false;
			} else if (m_bcc_findByParam_val == 'Y') {
				// 전체일치가 명시적으로 선택된 경우
				m_bcc_findByKeyword_checked = false;
				m_bcc_findByParam_checked = true;
			} else if (m_bcc_hasValue) {
				// 값이 있지만 둘 다 선택되지 않은 경우 기본값 (부분일치)
				m_bcc_findByKeyword_checked = true;
				m_bcc_findByParam_checked = false;
			}
			
			$('input:checkbox[id="m_bcc_findByKeyword"]').prop("checked", m_bcc_findByKeyword_checked);
			$('input:checkbox[id="m_bcc_findByParam"]').prop("checked", m_bcc_findByParam_checked);

			if(condition.rcvTo == null) {
				$('#m_to').val( condition.m_to );
				$('input:checkbox[id="m_to_not"]').prop("disabled", condition.m_to == '' ? true : false);
				$('input:checkbox[id="m_to_not"]').prop("checked", condition.m_to_not == 'Y' ? true : false);
			} else {
				$('#m_to').val( condition.rcvTo );
				$('input:checkbox[id="m_to_not"]').prop("disabled", condition.rcvTo == '' ? true : false);
				$('input:checkbox[id="m_to_not"]').prop("checked", condition.rcvTo_not == 'Y' ? true : false);
			}
			if(condition.rcvTo == null) {
				$('#m_cc').val( condition.m_cc );
				$('input:checkbox[id="m_cc_not"]').prop("disabled", condition.m_cc == '' ? true : false);
				$('input:checkbox[id="m_cc_not"]').prop("checked", condition.m_cc_not == 'Y' ? true : false);
			} else {
				$('#m_cc').val( condition.rcvCc );
				$('input:checkbox[id="m_cc_not"]').prop("disabled", condition.rcvCc == '' ? true : false);
				$('input:checkbox[id="m_cc_not"]').prop("checked", condition.rcvCc_not == 'Y' ? true : false);
			}
			if(condition.rcvTo == null) {
				$('#m_bcc').val( condition.m_bcc );
				$('input:checkbox[id="m_bcc_not"]').prop("disabled", condition.m_bcc == '' ? true : false);
				$('input:checkbox[id="m_bcc_not"]').prop("checked", condition.m_bcc_not == 'Y' ? true : false);
			} else {
				$('#m_bcc').val( condition.rcvBcc );
				$('input:checkbox[id="m_bcc_not"]').prop("disabled", condition.rcvBcc == '' ? true : false);
				$('input:checkbox[id="m_bcc_not"]').prop("checked", condition.rcvBcc_not == 'Y' ? true : false);
			}
		}

		$('#senders').val( condition.senders );
		var senders_hasValue = condition.senders != '' && condition.senders != null;
		$('input:checkbox[id="senders_not"]').prop("disabled", !senders_hasValue);
		$('input:checkbox[id="senders_not"]').prop("checked", condition.senders_not == 'Y' ? true : false);
		$('input:checkbox[id="senders_findByKeyword"]').prop("disabled", !senders_hasValue);
		$('input:checkbox[id="senders_findByParam"]').prop("disabled", !senders_hasValue);
		var senders_findByParam_checked = condition.senders_findByParam == 'Y' ? true : false;
		var senders_findByKeyword_checked = condition.senders_findByKeyword == 'Y' ? true :
			(senders_hasValue && condition.senders_findByKeyword != 'Y' && condition.senders_findByParam != 'Y' ? true : false);
		if (senders_findByParam_checked) {
			senders_findByKeyword_checked = false;
		} else if (senders_findByKeyword_checked) {
			senders_findByParam_checked = false;
		}
		$('input:checkbox[id="senders_findByKeyword"]').prop("checked", senders_findByKeyword_checked);
		$('input:checkbox[id="senders_findByParam"]').prop("checked", senders_findByParam_checked);
		if (rsUppercase == "Y") {
			$('input:checkbox[id="senders_upperCase"]').prop("disabled", !senders_hasValue);
			$('input:checkbox[id="senders_upperCase"]').prop("checked", condition.senders_upperCase == 'Y' ? true : false);
		}

		$('input:checkbox[id="adminAllRead"]').prop("checked", condition.adminAllRead == 'Y' ? true : false);

		// $('#initEpmsg').selectpicker('val', stringToArray(condition.epmsgType) );

		$('#userGroupSeq').val(condition.userGroupSeq);
		$('input:checkbox[id="userGroupSeq_not"]').prop("disabled", condition.userGroupSeq == '' ? true : false);
		$('input:checkbox[id="userGroupSeq_not"]').prop("checked", condition.userGroupSeq_not == 'Y' ? true : false);

		$('#allOfus').val( condition.allOfus );
		$('#interGroup').val(condition.interGroup);
		$('input:checkbox[id="interGroup_not"]').prop("disabled", condition.interGroup == '' ? true : false);
		$('input:checkbox[id="interGroup_not"]').prop("checked", condition.interGroup_not == 'Y' ? true : false);

		//$('#rcvTo').val( condition.rcvTo ); //미구현
		//$('#rcvCc').val( condition.rcvCc ); //미구현
		//$('#rcvBcc').val( condition.rcvBcc ); //미구현
		//$('#jikgubInput').val( condition.jikgub ); //미구현

		$('#rcvJikgub').selectpicker('val', stringToArray(condition.rcvJikgub) );
		$('#busi').selectpicker('val', stringToArray(condition.busi) );
		$('input:checkbox[id="busi_not"]').prop("disabled", condition.busi == '' ? true : false);
		$('input:checkbox[id="busi_not"]').prop("checked", condition.busi_not == 'Y' ? true : false);

		$('input:checkbox[id="recv_jikgub_not"]').prop("disabled", condition.rcvJikgub == '' ? true : false);
		$('input:checkbox[id="recv_jikgub_not"]').prop("checked", condition.recv_jikgub_not == 'Y' ? true : false);
		if(condition.dept != "") {
			$('#deptVal').val( condition.dept );
			$('#deptStr').val( condition.deptStr );
			$('#deptSelectedArea').show();
		}else{
			$('#deptVal').val('');
			$('#deptStr').val('');
			$('#deptSelectedArea').hide();
		}
		setCodeCount('dept', endId, condition.dept, ',');
		$('input:checkbox[id="dept_not"]').prop("disabled", condition.dept == '' ? true : false);
		$('input:checkbox[id="dept_not"]').prop("checked", condition.dept_not == 'Y' ? true : false);

		$('#url').val( condition.url );
		$('#regexPattern').val(condition.regexPattern);
		$('input:checkbox[id="url_not"]').prop("disabled", condition.url == '' ? true : false);
		$('input:checkbox[id="url_not"]').prop("checked", condition.url_not == 'Y' ? true : false);

		checkRadioBtn( 'readYn', condition.readYn );
		checkRadioBtn( 'OCRYn', condition.OCRYn );
		checkRadioBtn( 'bodyImg', condition.bodyImg );

		checkRadioBtn( 'attachYn', condition.attachYn );
		setCodeCount('attach', endId, condition.attachVal, '|');
		$('#attachBtn').prop("disabled", condition.attachYn != 'Y' ? true : false);
		$('#attachVal').val( condition.attachVal );
		$('#attachStr').val( condition.attachStr );
		$('input:checkbox[id="attachYn_not"]').prop("disabled", condition.attachVal == '' ? true : false);
		$('input:checkbox[id="attachYn_not"]').prop("checked", condition.attachYn_not == 'Y' ? true : false);

		checkRadioBtn( 'keywordYn', condition.keywordYn );
		setCodeCount('keyword', endId, condition.keywordVal, '|');
		$('#keywordBtn').prop("disabled", condition.keywordYn != 'Y' ? true : false);
		$('#keywordVal').val( condition.keywordVal );
		$('#keywordStr').val( condition.keywordStr );
		$('input:checkbox[id="keywordYn_not"]').prop("disabled", condition.keywordVal == '' ? true : false);
		$('input:checkbox[id="keywordYn_not"]').prop("checked", condition.keywordYn_not == 'Y' ? true : false);

		checkRadioBtn( 'regexpYn', condition.regexpYn );
		setCodeCount('regexp', endId, condition.regexpVal, '|');
		$('#regexpBtn').prop("disabled", condition.regexpYn != 'Y' ? true : false);
		$('#regexpVal').val( condition.regexpVal );
		$('#regexpStr').val( condition.regexpStr );

		checkRadioBtn( 'drmYn', condition.drmYn );
		checkRadioBtn( 'realAttYn', condition.realAttYn );
		$('input:radio[name="realAttYn"]').prop("disabled", condition.attachYn != 'Y' ? true : false);
		$('input:radio[name="drmYn"]').prop("disabled", condition.attachYn != 'Y' ? true : false);

		checkRadioBtn( 'sctYn', condition.sctYn );

		$('#sizeStartVal').val(rtnDefaultVal(condition.sizeStartVal/1024, ''));
		$('#sizeEndVal').val(rtnDefaultVal(condition.sizeEndVal/1024, ''));
		$('#sizeOption').val(rtnDefaultVal(condition.sizeOption, 'L'));
		checkRadioBtn( 'sizeType', condition.sizeType );

		checkRadioBtn( 'ctimeWork', condition.ctimeWork );
		checkRadioBtn( 'reprocessYn', condition.reprocessYn );

		if( condition.sort == '') $('#messageSort').val('ctime desc');
		else $('#messageSort').val(condition.sort);

		//$("input:checkbox[id='researchCheckbox"+"']").prop("checked", eval(condition.reSearch == undefined ? false : condition.reSearch));
	}
}

var easyDateStartFlag = false;
var easyDateEndFlag = false;

/**
 * 달력 간편 설정
 */
function changeDate( val )
{
	easyDateStartFlag = true;
	easyDateEndFlag = true;

	var dateObj = new Date();
	if ( val == "1" ) $('#startdatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 00, 00, 00 ) );
	else if ( val == "2" ) $('#startdatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-1, 00, 00, 00 ) );
	else if ( val == "3" ) $('#startdatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-7, 00, 00, 00 ) );
	else if ( val == "4" ) $('#startdatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-14, 00, 00, 00 ) );
	else if ( val == "5" ) $('#startdatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-21, 00, 00, 00 ) );
	else if ( val == "6" ) $('#startdatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth()-1, dateObj.getDate(), 00, 00, 00 ) );
	else if ( val == "7" ) $('#startdatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth()-2, dateObj.getDate(), 00, 00, 00 ) );
	else if ( val == "8" ) $('#startdatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth()-3, dateObj.getDate(), 00, 00, 00 ) );

	if ( val == "2" ) $('#enddatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-1, 23, 59, 59 ) );
	else if ( val != "" ) $('#enddatepicker').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) );
}

/**
 * 조건값의 초기화 셋팅
 * @param endId
 * @returns
 */
function initCondition(endId){
	if( endId == ''){
		$('#searchField').selectpicker({
			size: 'auto',
			width:'260px',
			searchLabel:true,
			collapseExtend:true,
			noneSelectedText:condition.searchFieldAll,
			noneResultsText:condition.msgNoresult+' ',
			selectAllText:condition.msgSelect_all,
			deselectAllText:condition.msgUnselect_all
		});
		$('#serviceType').selectpicker({
			size: 'auto',
			width:'260px',
			searchLabel:true,
			collapseExtend:true,
			noneSelectedText:condition.serviceAll,
			noneResultsText:condition.msgNoresult+' ',
			selectAllText:condition.msgSelect_all,
			deselectAllText:condition.msgUnselect_all,
			liveSearchPlaceholder:condition.searchService
		});
		// $('#initEpmsg').selectpicker({
		// 	size: 'auto',
		// 	width:'260px',
		// 	searchLabel:true,
		// 	noneSelectedText:condition.epmsgTypeAll,
		// 	noneResultsText:condition.msgNoresult+' ',
		// 	selectAllText:condition.msgSelect_all,
		// 	deselectAllText:condition.msgUnselect_all
		// }).on("changed.bs.select", function (e) {
		// 	var value = $(this).selectpicker('val');
		// });
		$('#rcvJikgub').selectpicker({
			size: 'auto',
			width:'260px',
			searchLabel:true,
			noneSelectedText:condition.recv_jikgubAll,
			noneResultsText:condition.msgNoresult+' ',
			selectAllText:condition.msgSelect_all,
			deselectAllText:condition.msgUnselect_all,
		}).on("changed.bs.select", function (e) {
			var value = $(this).selectpicker('val');
			if(value == null ){
				$('#recv_jikgub_not').prop('disabled', true);
				$('#recv_jikgub_not').prop('checked',false);
			}else{
				$('#recv_jikgub_not').prop('disabled', false);
			}
		});

		$('#busi').selectpicker({
			size: 'auto',
			width:'260px',
			searchLabel:true,
			noneSelectedText:condition.orgBusiAll,
			noneResultsText:condition.msgNoresult+' ',
			selectAllText:condition.msgSelect_all,
			deselectAllText:condition.msgUnselect_all
		}).on("changed.bs.select", function (e) {
			var value = $(this).selectpicker('val');
			if(value == null ){
				$('#busi_not').prop('disabled', true);
				$('#busi_not').prop('checked',false);
			}else{
				$('#busi_not').prop('disabled', false);
			}
		});

		$(document).on('click', '.filterAddBtn', function(){
			var code = $(this).attr('id').substring(0, $(this).attr('id').length-3);
			openCodeWindow(code, $('#'+code+'Val').val(), $('#'+code+'Str').val());
		});

		$('#interGroup').change(function(){
			if($(this).val()==''){
				$('#interGroup_not').prop('checked', false);
				$('#interGroup_not').prop('disabled', true);
			}else{
				$('#interGroup_not').prop('disabled', false);
			}
		});
		$('#userGroupSeq').change(function(){
			if($(this).val()==''){
				$('#userGroupSeq_not').prop('checked', false);
				$('#userGroupSeq_not').prop('disabled', true);
			}else{
				$('#userGroupSeq_not').prop('disabled', false);
			}
		})
	} else if(endId == 'Pop'){
		$(document).on('click', '.filterAddBtnPop', function(){
			var code = $(this).attr('id').substring(0, $(this).attr('id').length-6);
			openCodeWindow(code, $('#'+code+'ValPop').val(), $('#'+code+'StrPop').val());
		});

		var dateObj = new Date();
		$('#startdatepickerAdd').datetimepicker({
			format: 'YYYY-MM-DD HH:mm:ss',
			locale: 'ko',
			sideBySide: true,
			defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-7 ) )
		});
		$('#enddatepickerAdd').datetimepicker({
			format: 'YYYY-MM-DD HH:mm:ss',
			locale: 'ko',
			sideBySide: true,
			defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
		});
	}
}

/**
 * 조건 데이터의 초기값을 불러와서 셋팅한다.
 * @returns
 */
function initConditionData(){
	getServiceTypeList( ); //서비스타입
	getCodeList('busi');   //사업장
	initUserGroupList();   //사용자그룹
	initInterestUser();    //관심사용자
	// initEpmsg();			//대외비 목록
}
var serviceGroups=[];
var serviceTypes=[];
function getJikgubList() {
	ui.get({
		url : 'getJikgubList.xcn',
		success : function(data, total) {
			var str = '';
			for (var i = 0; i < data.length; i++) {
				str += '<option value="'+data[i].jikgubCd+'">'+data[i].jikgubNm+'</option>';
				//console.log(data[i].jikgubCd+"//");

			}
			$('#rcvJikgub').html(str);
			$('#rcvJikgub').selectpicker('refresh');
		},
		error : function(status, message) {
			ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}

/**
 * 대외비 리스트 조회해서 조건에 적용
 */
// function initEpmsg(){
// 	var epmsg_type = epmsgType.split(',');
// 	var result='';
// 	for(var i=0 ; i<epmsg_type.length; i++){
// 		result+='<option value="' + epmsg_type[i]+ '">' +  epmsg_type[i] + '</option>';
// 	}
// 	$("#initEpmsg").html(result);
// 	$('#initEpmsg').selectpicker('refresh');
//
// }

/**
 * 서비스타입 리스트를 불러와서 조건에 적용
 * @returns
 */
var specialService=[];
var parentCode = [];
var parentNm = [];
function getServiceGroupList( ){
	var str = '';
	for (var i = 0; i < serviceTypes.length; i++) {
		if( str.indexOf(serviceTypes[i].groupCd ) == -1){
			str += serviceTypes[i].groupCd + ',';
		}
		if(serviceTypes[i].serviceCd.length == 4) {
			specialService.push(serviceTypes[i]);
		}
	}

	serviceGroups = str.substring(0, str.length-1).split(',');
	var serviceStr = getServiceOptionStr( );
	$('#serviceType').html(serviceStr);
	getServiceOptionLiveSearch(parentCode);
	$('#serviceType').selectpicker('refresh');
	$('#serviceTypePop').html(serviceStr);
	$('#serviceTypePop').selectpicker('refresh');
}
function getServiceTypeList( ){
	var svc1 = '';
	var svc1_not = '';
	if(pageType == 'U') svc1 = pageType;
	if(pageType == 'M') svc1_not = 'U';

	ui.get({
		url : 'getServiceListByAuth.xcn',
		svc1 : svc1,
		svc1_not : svc1_not,
		success : function(data, total) {
			serviceTypes = data;
			getServiceGroupList( );
		},
		error : function(status, message) {
			ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}
function getServiceOptionStr( ){
	var str = '';
	for (var i = 0; i < serviceGroups.length; i++) {
		var selectedVal = serviceGroups[i];
		var idx = 0;
		for (var j = 0; j < serviceTypes.length; j++) {
			if( selectedVal == serviceTypes[j].groupCd){
				if( idx == 0 ){
					str += '<optgroup label="'+serviceTypes[j].groupNm+'" data-collapsible-optgroup= "true" data-load-collapse-optgroup ="false">';
				}
				if( serviceTypes[j].serviceCd.length == 3){
					str += getServiceOptionChildren(serviceTypes[j]);
				} else if ( serviceTypes[j].serviceCd.length == 4 ) continue;
				else str += '<option value="'+serviceTypes[j].serviceCd+'">'+serviceTypes[j].serviceNm+'</option>';

				idx++;
			}
		}
		if( idx != 0 ) str += '</optgroup>';
	}
	return str;
}
function getServiceOptionChildren(serviceType) {
	var result = '<option value="'+serviceType.serviceCd+'">'+serviceType.serviceNm+'</option>';
	for (var i = 0; i < specialService.length; i++) {
		var service = specialService[i];
		if( service.serviceCd.indexOf(serviceType.serviceCd) > -1 ) {
			if(!parentCode.includes(serviceType.serviceCd)) {
				parentCode.push(serviceType.serviceCd);
				parentNm.push(serviceType.serviceNm);
			}
			result += '<option value="'+service.serviceCd+'"> └ '+service.serviceNm+'</option>';
		}
	}

	return result;
}
function getServiceOptionLiveSearch(code) {
	var searchWord = "";
	for (var i = 0; i < code.length; i++) {
		var pCode = code[i];
		for(var j = 0; j < specialService.length; j++) {
			if( specialService[j].serviceCd.indexOf(pCode) > -1 ) {
				searchWord += specialService[j].serviceNm + " ";
			}
		}
		searchWord += parentNm[i];
		$('[value=' + pCode + ']').attr('data-tokens', searchWord);
		searchWord = "";
	}

}


/**
 * 코드 리스트를 불러와서 조건에 적용
 * @param codeType
 * @returns
 */
function getCodeList( codeType ){
	ui.get({
		url 		: 'getCodeList.xcn',
		codeType	: codeType,
		success 	: function(data, total) {
			var optionData = getSelectOption( data );
			$('#'+codeType).html(optionData);
			$('#'+codeType).selectpicker('refresh');
			$('#'+codeType+'Pop').html(optionData);
			$('#'+codeType+'Pop').selectpicker('refresh');
		},
		error 		: function(status, message) {
			ui.alertMsg('error:' + status);
		},
		complete 	: function() {
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

/**
 * 사용자 그룹 데이터를 불러와서 조건에 적용
 * @returns
 */
function initUserGroupList(){
	ui.get({
		url : 'getUserGroupList.xcn',
		logYn : 'Y',
		success : function(data, total) {
			getUserGroupListOptions(data, '');
			getUserGroupListOptions(data, 'Pop');
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});
}
function getUserGroupListOptions(data, endId){
	var result='<option value="">-'+condition.userGroupNaviTitle2+'-</option>';
	for(var i=0 ; i<data.length; i++){
		result+='<option value="' + data[i].groupCode + '">' +  data[i].groupName + '</option>';
	}
	$("#userGroupSeq"+endId).html(result);
}

/**
 * 관심사용자 리스트 조회해서 조건에 적용
 */
function initInterestUser(){
	ui.get({
		url : 'getAdminUserGroupList.xcn',
		success : function(data, total) {
			getInterestUserOptions(data, '');
			//getInterestUserOptions(data, 'Pop');
		},
		error : function(status, message) {
			//ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}
function getInterestUserOptions(data, endId){
	var result='<option value="">-'+condition.interestGroup+'-</option>';
	for(var i=0 ; i<data.length; i++){
		result+='<option value="' + data[i].groupSeq + '">' +  data[i].groupName + '</option>';
	}
	$("#interGroup"+endId).html(result);
}


























function getSvc1Nm(svc1){
	var result = condition.msgNoinfo;
	for(var i=0; i<serviceTypes.length; i++){
		if(serviceTypes[i].groupCd == svc1){
			result = serviceTypes[i].groupNm;
			break;
		}
	}

	return result;
}

function getSvc12Nm(svc12){
	var result = condition.msgNoinfo;
	for(var i=0; i<serviceTypes.length; i++){
		if(serviceTypes[i].serviceCd == svc12){
			result = serviceTypes[i].serviceNm;
			break;
		}
	}

	return result;
}

/**
 * iframe에서 parent로 값을 적용 할 때 사용
 * @returns
 */
function setValueById(id, val){
	$('#'+id).val(val);
}

/**
 * 코드 선탭 팝업에서 호출하는 메소드(선택)
 * @param codeType
 * @param data
 * @returns
 */
function getSelectedCodeData( codeType, data ) {
	var endId = '';
	// if( codeType == 'senders' || codeType == 'receivers'){
	// 	$('#'+codeType).tagsinput('removeAll');
	// 	for (var i = 0; i < data.length; i++) {
	// 		$('#'+codeType).tagsinput('add', data[i]);
	// 	}
	// }else
	// {
	var str = '';
	var val = '';
	for(var i=0; i<data.length; i++){
		str += data[i].codeName;
		val += data[i].code;
		if( codeType == 'regexp' ) {
			var arr = data[i].count.split('@');
			if( arr[0] == 'B' ) {
				if( adminLang == 'ko' ) str += '(' + arr[1] + '건 ~ ' + arr[2] + '건)';
				else str += '(' + arr[1] + 'items ~ ' + arr[2] + 'items)';
			} else if( arr[0] == 'L' ) {
				if( adminLang == 'ko' ) str += '(' + arr[1] + '건 이상)';
				else str += '(' + arr[1] + 'items over)';
			} else {
				if( adminLang == 'ko' ) str += '(' + arr[1] + '건 이하)';
				else str += '(' + arr[1] + 'items below)';
			}
			val += '%' + data[i].count;
		}

		if( i != data.length-1){
			if( codeType == 'dept'){
				str +=', ';
				val +=',';
			}else{
				str +=', ';
				val +='|';
			}
		}
	}

	if(data.length == 0){
		if( codeType == 'dept'){
			$('#'+codeType+'_not'+endId).prop('disabled', true);
			$('#'+codeType+'_not'+endId).prop('checked', false);
		}else{
			$('#'+codeType+'Yn_not'+endId).prop('disabled', true);
			$('#'+codeType+'Yn_not'+endId).prop('checked', false);
		}
	}else{
		if( codeType == 'dept'){
			$('#'+codeType+'_not'+endId).prop('disabled', false);
		}else{
			$('#'+codeType+'Yn_not'+endId).prop('disabled', false);
		}
	}

	if( val != '' ){
		str = str.rtrim();
		val = val.trimAll();
	}
	var endId = '';
	//if( popOpenFlag ) endId = 'Pop';
	$('#'+codeType+'Str'+endId).val(str);
	$('#'+codeType+'Val'+endId).val(val);

	if( $('#'+codeType+'Str'+endId).val() != '' ){
		$('#'+codeType+'SelectedArea'+endId).find('.btn').text(data.length);
		$('#'+codeType+'SelectedArea'+endId).find('.btn').attr('title', str);
		$('#'+codeType+'SelectedArea'+endId).show();
	}else{
		$('#'+codeType+'SelectedArea'+endId).find('.btn').text(0);
		$('#'+codeType+'SelectedArea'+endId).find('.btn').attr('title', '');
		$('#'+codeType+'SelectedArea'+endId).hide();
	}
	// }

}
/**
 * 코드 선탭 팝업에서 호출하는 메소드(선택안함)
 * @param codeType
 * @returns
 */
function resetCode(codeType){
	var endId = '';
	//if( popOpenFlag ) endId = 'Pop';
	// if( codeType == 'senders' || codeType == 'receivers'){
	// 	$('#'+codeType+endId).tagsinput('removeAll');
	// }else{
	$('#'+codeType+'Val'+endId).val('');
	$('#'+codeType+'Str'+endId).val('');
	$('#'+codeType+'SelectedArea'+endId).hide();
	if( codeType == 'dept'){
		$('#'+codeType+'_not'+endId).prop('checked', false);
		$('#'+codeType+'_not'+endId).prop('disabled', true);
	}else{
		$('#'+codeType+'Yn_not'+endId).prop('checked', false);
		$('#'+codeType+'Yn_not'+endId).prop('disabled', true);
	}

	// }
}

function checkRadioBtn( name, val ){
	if(val == null) return;
	if( $.isNumeric(val) ) $('input:radio[name=' + name + ']:input[value=' + val + ']').prop("checked", true);
	else $('input:radio[name=' + name + ']:input[value=' + idIndicator(val) + ']').prop("checked", true);
}

function setCodeCount(codeType, endId, data, separator){
	if( data != '' && data != undefined ){
		$('#'+codeType+'SelectedArea'+endId).find('.btn').text(data.split(separator).length);
		$('#'+codeType+'SelectedArea'+endId).show();
	}else{
		$('#'+codeType+'SelectedArea'+endId).find('.btn').text(0);
		$('#'+codeType+'SelectedArea'+endId).hide();
	}
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

function rtnDefaultVal( val, defaultVal ){
	if( val == undefined ) return defaultVal;
	else return val;
}

function getJson(str) {
	var result;
	try {
		result = JSON.parse(str);
	} catch (e) {
		result = str;
	}
	return result;
}
