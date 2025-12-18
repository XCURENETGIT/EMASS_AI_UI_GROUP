var popOpenFlag = false;
function initConditionSetup( ){
	setupCondition( );

	$(document).on('click', '.filterAddBtn', function(){
		var code = $(this).attr('id').substring(0, $(this).attr('id').length-3);
		openCodeWindow(code, $('#'+code+'Val').val(), $('#'+code+'Str').val());
	});
	$(document).on('click', '.filterAddBtnPop', function(){
		var code = $(this).attr('id').substring(0, $(this).attr('id').length-6);
		openCodeWindow(code, $('#'+code+'ValPop').val(), $('#'+code+'StrPop').val());
	});
}

function setupCondition( ){
	$('.tab_header').css('position', 'relative');

	$('#filterSaveBtn').click(function(){
		$('#savePathPopDiv').show();
		$('#selectConditionPopDiv').hide();
		saveFilterData( 'save' );
	});

	$('#filterResetBtn').click(function(){
		initCondition( '' );
	});

	$(document).on('mouseover', '.codeSelectedBtn', function(e){
		var endId = '';
		if( popOpenFlag ) endId = 'Pop';

		$('#selectedCodeTitle'+endId).show();
		$('#selectedCodeTitle'+endId).css('right', $(document).width()-e.pageX+'px');
		$('#selectedCodeTitle'+endId).css('top', e.pageY-45+'px');

		var str = $(this).parent().find('.selectedTitle').val();
		if( str != undefined ) str = str.replaceAll('\\|', ',');
		$('#selectedCodeTitle'+endId).html(str);
	});
	$(document).on('mousemove', '.codeSelectedBtn', function(e){
		var endId = '';
		var right = $(document).width()-e.pageX+'px';
		var top = e.pageY-45+'px';
		if( popOpenFlag ){
			endId = 'Pop';
			right = $('#smartFilterSavePop').find('.modal-dialog').width()-e.pageX+175+'px';
			top = e.pageY-90+'px';
		}

		$('#selectedCodeTitle'+endId).css('right', right);
		$('#selectedCodeTitle'+endId).css('top', top);
		var str = $(this).parent().find('.selectedTitle').val();
		if( str != undefined ) str = str.replaceAll('\\|', ',');
		$('#selectedCodeTitle'+endId).html(str);
	});
	$(document).on('mouseout', '.codeSelectedBtn', function(e){
		var endId = '';
		if( popOpenFlag ) endId = 'Pop';
		$('#selectedCodeTitle'+endId).hide();
	});
	$(document).on('click', '.codeSelectedBtn', function(e){
		var endId = '';
		if( popOpenFlag ) endId = 'Pop';
		resetCode($(this).attr('id').substring(0, $(this).attr('id').length-12-endId.length));
		$('#selectedCodeTitle'+endId).hide();
	});

	if (pageType == "DIV") {
		dateInitSetupNew( );		//추후 변경 필요
		conditionSetupNew('');		//추후 변경 필요
	} else {
		dateInitSetup( );
		conditionSetup('');
	}

	conditionSetup('Pop');
	setSelectpicker();

	initInterestUser();
	initUserGroupList();

	//$('th').css('display', 'none');
}

function getSelectedCodeData( codeType, data ) {
	if( codeType == 'senders' || codeType == 'receivers'){
		$('#'+codeType).tagsinput('removeAll');
		for (var i = 0; i < data.length; i++) {
			$('#'+codeType).tagsinput('add', data[i]);
		}
	}else{
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
		if( val != '' ){
			str = str.rtrim();
			val = val.trimAll();
		}
		var endId = '';
		if( popOpenFlag ) endId = 'Pop';
		$('#'+codeType+'Str'+endId).val(str);
		$('#'+codeType+'Val'+endId).val(val);

		if( $('#'+codeType+'Str'+endId).val() != '' ){
			$('#'+codeType+'SelectedArea'+endId).find('.btn').text(data.length);
			$('#'+codeType+'SelectedArea'+endId).show();
		}else{
			$('#'+codeType+'SelectedArea'+endId).find('.btn').text(0);
			$('#'+codeType+'SelectedArea'+endId).hide();
		}
	}

}
function resetCode(codeType){
	var endId = '';
	if( popOpenFlag ) endId = 'Pop';
	if( codeType == 'senders' || codeType == 'receivers'){
		$('#'+codeType+endId).tagsinput('removeAll');
	}else{
		$('#'+codeType+'Val'+endId).val('');
		$('#'+codeType+'Str'+endId).val('');
		$('#'+codeType+'SelectedArea'+endId).hide();
	}
}

function setSelectpicker(){
	getServiceTypeList( );
	getCodeList('busi');
}

var serviceGroups=[];
var serviceTypes=[];
function getServiceGroupList( ){
	var str = '';
	for (var i = 0; i < serviceTypes.length; i++) {
		if( str.indexOf(serviceTypes[i].groupCd ) == -1){
			str += serviceTypes[i].groupCd + ',';
		}
	}
	serviceGroups = str.substring(0, str.length-1).split(',');
	var serviceStr = getServiceOptionStr( );
	$('#serviceTypeSelect').html(serviceStr);
	$('#serviceTypeSelect').selectpicker('refresh');
	$('#serviceTypeSelectPop').html(serviceStr);
	$('#serviceTypeSelectPop').selectpicker('refresh');
}


function getServiceTypeList( ){
	ui.get({
		url : 'getServiceListByAuth.xcn',
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
					str += '<optgroup label="'+serviceTypes[j].groupNm+'">';
				}
				str += '<option value="'+serviceTypes[j].serviceCd+'">'+serviceTypes[j].serviceNm+'</option>';
				idx++;
			}
		}
		if( idx != 0 ) str += '</optgroup>';
	}
	return str;
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

function initInterestUser(){
	ui.get({
		url : 'getInterestSimpleUserList.xcn',
		success : function(data, total) {
			if(pageType == "DIV") {
				getInterestUserOptionsNew(data, '');
			} else {
				getInterestUserOptions(data, '');
			}


			getInterestUserOptions(data, 'Pop');
		},
		error : function(status, message) {
			//ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}


function initUserGroupList(){
	ui.get({
		url : 'getUserGroupList.xcn',
		logYn : 'Y',
		success : function(data, total) {
			if(pageType == "DIV") {
				getUserGroupListOptionsNew(data, '');
			} else {
				getUserGroupListOptions(data, '');
			}
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
	$('#userGroupSeq'+endId).selectpicker({
		container:'body',
		width:'180px',
		noneSelectedText:'-'+condition.userGroupNaviTitle2+'-'
	});

	var result='<option value="">-'+condition.userGroupNaviTitle2+'-</option>';
	for(var i=0 ; i<data.length; i++){
		result+='<option value="' + data[i].groupCode + '">' +  data[i].groupName + '</option>';
	}
	$("#userGroupSeq"+endId).html(result);
	$("#userGroupSeq"+endId).selectpicker('refresh');
}

function getUserGroupListOptionsNew(data, endId){
	$('#userGroupSeq'+endId).selectpicker({
		container:'body',
		width:'180px',
		style:'btn-xs btn-default',
		noneSelectedText:'-'+condition.userGroupNaviTitle2+'-'
	});

	var result='<option value="">-'+condition.userGroupNaviTitle2+'-</option>';
	for(var i=0 ; i<data.length; i++){
		result+='<option value="' + data[i].groupCode + '">' +  data[i].groupName + '</option>';
	}
	$("#userGroupSeq"+endId).html(result);
	$("#userGroupSeq"+endId).selectpicker('refresh');
}


/**
 * 관심사용자 리스트 조회
 */
function getInterestUserOptions(data, endId){
	$('#userSeq'+endId).selectpicker({
		container:'body',
		width:'180px',
		noneSelectedText:'-'+condition.selectInterest+'-'
	});

	var result='<option value="">-'+condition.selectInterest+'-</option>';
	result+='<option value="all">'+condition.interestUserAll+'</option>';
	for(var i=0 ; i<data.length; i++){
		result+='<option value="' + data[i].userSeq + '">' +  data[i].userNm + '</option>';
	}
	$("#userSeq"+endId).html(result);
	$("#userSeq"+endId).selectpicker('refresh');
}

function getInterestUserOptionsNew(data, endId){
	$('#userSeq'+endId).selectpicker({
		container:'body',
		width:'180px',
		style:'btn-xs btn-default',
		noneSelectedText:'-'+condition.selectInterest+'-'
	});

	var result='<option value="">-'+condition.selectInterest+'-</option>';
	result+='<option value="all">'+condition.interestUserAll+'</option>';
	for(var i=0 ; i<data.length; i++){
		result+='<option value="' + data[i].userSeq + '">' +  data[i].userNm + '</option>';
	}
	$("#userSeq"+endId).html(result);
	$("#userSeq"+endId).selectpicker('refresh');
}

function changeRadioVal(type, endId, val ){
	if(val == 'Y'){
		$('#'+type+'BtnArea'+endId).show();
		if( $('#'+type+'Val'+endId).val() != '' ) $('#'+type+'SelectedArea'+endId).show();
	}
	else{
		resetCode(type);
		$('#'+type+'BtnArea'+endId).hide();
		$('#'+type+'SelectedArea'+endId).hide();
	}
}
function conditionSetup( endId ){
	$( 'input[name="attachYn'+endId+'"]:radio' ).change(function(){
		changeRadioVal('attach', endId, $(this).val() );
	});
	$( 'input[name="keywordYn'+endId+'"]:radio' ).change(function(){
		changeRadioVal('keyword', endId, $(this).val() );
	});
	$( 'input[name="regexpYn'+endId+'"]:radio' ).change(function(){
		changeRadioVal('regexp', endId, $(this).val() );
	});

	$('#searchField'+endId).selectpicker({
		container:'body',
		width:'115px',
		noneSelectedText:condition.commonMsgAll
	});

	$('#serviceTypeSelect'+endId).selectpicker({
		container:'body',
		size: 15,
		width:'145px',
		searchLabel:true,
		noneSelectedText:condition.serviceAll,
		noneResultsText:condition.msgNoresult+' ',
		selectAllText:condition.msgSelect_all,
		deselectAllText:condition.msgUnselect_all,
		liveSearchPlaceholder:condition.searchService
	});

	var allofus_width = '475px';
	if( endId != '') allofus_width = '400px';
	$('#allOfus'+endId).selectpicker({
		container:'body',
		width:allofus_width
	});
	$('#sizeFilterType'+endId).selectpicker({
		container:'body',
		width:'90px'
	});
	$('#sizeFilterSelect'+endId).selectpicker({
		container:'body',
		width:'70px'
	});

	$('#busiSelect'+endId).selectpicker({
		container:'body',
		size: 15,
		width:'222px',
		searchLabel:true,
		noneSelectedText:condition.orgBusiAll,
		noneResultsText:condition.msgNoresult+' ',
		selectAllText:condition.msgSelect_all,
		deselectAllText:condition.msgUnselect_all
	});
	$('#dept'+endId).click(function(){
		openCodeWindow('dept', $('#deptVal'+endId).val(), $('#deptStr'+endId).val());
	});

	var size_slider = document.getElementById('size-setup'+endId);
	noUiSlider.create(size_slider, {
		start: [ 0 ],
		connect : 'upper',
		step: 1,
		range: {
			'min': [  0 ],
			'max': [ 10737418240 ]
		}
	});
	size_slider.noUiSlider.on('update', function( values, handle ) {
		var value = parseInt(values[handle]);
		$('#sizeStartVal'+endId).val( value );
		$('#sizeEndVal'+endId).val(0);
		$('#sizeStartValStr'+endId).html( convertFileSize( value ) );
	});

	document.getElementById('sizeStartVal'+endId).addEventListener('change', function(){
		size_slider.noUiSlider.set([this.value, null]);
	});
	document.getElementById('sizeEndVal'+endId).addEventListener('change', function(){
		size_slider.noUiSlider.set([null, this.value]);
	});

	$('#sizeStartValStr'+endId).click(function(){
		$(this).hide();
		$('#sizeStartVal'+endId).show();
		$('#sizeStartVal'+endId).focus();
	});
	$('#sizeStartVal'+endId).focusout(function(){
		$(this).hide();
		$('#sizeStartValStr'+endId).show();
	});
	$('#sizeEndValStr'+endId).click(function(){
		$(this).hide();
		$('#sizeEndVal'+endId).show();
		$('#sizeEndVal'+endId).focus();
	});
	$('#sizeEndVal'+endId).focusout(function(){
		$(this).hide();
		$('#sizeEndValStr'+endId).show();
	});

	$('#sizeStartVal'+endId).keypress(function(e){
		if( e.keyCode == 13){
			$(this).hide();
			$('#sizeStartValStr'+endId).show();
		}
	});
	$('#sizeEndVal'+endId).keypress(function(e){
		if( e.keyCode == 13){
			$(this).hide();
			$('#sizeEndValStr'+endId).show();
		}
	});

	$('#sizeFilterSelect'+endId).change(function(){
		setSizeFilter( 'size-setup'+endId, $(this).val() );
	});

	if( endId == 'Pop'){
		$('input:radio[name=filterTypePop]').change(function () {
			var value = $('input:radio[name=filterTypePop]:input:checked').val();
			if( value == 'D'){
				$('#selectConditionPopArea').show();
				$('#selectQueryPopArea').hide();
			}else{
				$('#selectConditionPopArea').hide();
				$('#selectQueryPopArea').show();

			}
		});

		$('#smartFilterSavePop').on('show.bs.modal', function(){
			getAdminFilterListPop( );

			if( $('#modalType').val() == 'add'){
				$('#startdatepickerPop').data("DateTimePicker").date($('#startdatepicker').data("DateTimePicker").date());
				$('#enddatepickerPop').data("DateTimePicker").date($('#enddatepicker').data("DateTimePicker").date());

				$("#startdatepickerPop").prop('disabled', true);
				$("#enddatepickerPop").prop('disabled', true);
				initCondition('Pop');
			}else if($('#modalType').val() == 'save'){
				$('#filterNamePopInput').val('');
				$('#filterOptionPopSelect').selectpicker('val', '1');
				$('#startDayPop').val('');
				$('#endDayPop').val('');
				$('#normalDateArea').show();
				$('#simpleDateArea').hide();
				$('#noselectDateArea').hide();

				$('#selectConditionPopArea').show();
				$('#selectQueryPopArea').hide();

				var selectedTabIdx = $('#resultTab').find('.active').index();
				var filterType = $('#'+rsKey[selectedTabIdx].contentId).find('.tabValue').attr('data-filterType');
				if( filterType == 'C') filterType = 'D';

				checkRadioBtn( 'filterTypePop', filterType );
				if( filterType == 'Q'){
					$('#selectConditionPopArea').show();
					$('#savePathPopDiv').show();
					$('#selectConditionPopDiv').hide();
					$('#queryInputTextareaPop').val($('#solrQueryText').val());
				}

				setCondition( 'Pop', getCondition('') );
			}
			else{
				var nodes = zTree.getSelectedNodes();
				if (nodes.length > 0) {
					var treeNode = nodes[0];
					var filterType = treeNode.filterType;
					if( filterType == 'D'){
						$('#selectConditionPopArea').show();
						$('#selectQueryPopArea').hide();

						var jsonData = JSON.parse(treeNode.conditions);
						setOnlyCondition( 'Pop', jsonData[jsonData.length-1] );
					}else{
						$('#selectConditionPopArea').hide();
						$('#selectQueryPopArea').show();
						setUserQuery(treeNode);
					}
					$('#filterNamePopInput').val(treeNode.name);
					checkRadioBtn( 'dashboardSelPop', treeNode.dashboard );
					checkRadioBtn( 'filterTypePop', filterType );
				}else{
					alert(condition.msgConnectError);
					return;
				}
			}
		}).on('shown.bs.modal', function(){
			var nodes = zTree.getSelectedNodes();
			if (nodes.length > 0) {
				var treeNode = nodes[0];
				treeNode.tId = 'filterTreePop_'+ treeNode.tId.split('_')[1];
				treeNode.isHover = false;

				var filterTreePop = $.fn.zTree.getZTreeObj("filterTreePop");
				filterTreePop.selectNode(treeNode);
			}
			$('#filterNamePopInput').focus();

			popOpenFlag = true;
		}).on('hidden.bs.modal', function(){
			popOpenFlag = false;
			//$.fn.zTree.destroy("#filterTreePop");
			initCondition( 'Pop' );
			getAdminFilterList( );
		});

		$('#smartFolderSavePop').on('show.bs.modal', function(){
			getAdminFolderListPop( );

		}).on('shown.bs.modal', function(){
			var nodes = zFolderTree.getSelectedNodes();
			if (nodes.length > 0) {
				var treeNode = nodes[0];
				treeNode.tId = 'folderTreePop_'+ treeNode.tId.split('_')[1];
				treeNode.isHover = false;

				var filterTreePop = $.fn.zTree.getZTreeObj("folderTreePop");
				filterTreePop.selectNode(treeNode);
			}

			popOpenFlag = true;
		}).on('hidden.bs.modal', function(){
			popOpenFlag = false;
			getAdminFolderList( );
		});
	}

	$('#messageSort'+endId).selectpicker({
		container:'body',
		size: 15,
		width:'120px',
		dropdownAlignRight:true
	});
	if( endId != '') {
		$('#messageSortDiv .selectpicker').on('changed.bs.select', function (e) {
			searchData( );
		});
	}
}

function conditionSetupNew( endId ){
	$( 'input[name="attachYn'+endId+'"]:radio' ).change(function(){
		changeRadioVal('attach', endId, $(this).val() );
	});
	$( 'input[name="keywordYn'+endId+'"]:radio' ).change(function(){
		changeRadioVal('keyword', endId, $(this).val() );
	});
	$( 'input[name="regexpYn'+endId+'"]:radio' ).change(function(){
		changeRadioVal('regexp', endId, $(this).val() );
	});

	$('#searchField').selectpicker({
		container:'body',
		size: 15,
		width:'170px',
		style:'btn-xs btn-default'
	});

	$('#serviceTypeSelect').selectpicker({
		container:'body',
		size: 15,
		width:'205px',
		searchLabel:true,
		style:'btn-xs btn-default',
		noneSelectedText:condition.serviceAll,
		noneResultsText:condition.msgNoresult+' ',
		selectAllText:condition.msgSelect_all,
		deselectAllText:condition.msgUnselect_all,
		liveSearchPlaceholder:condition.searchService
	});

	var allofus_width = '300px';
	if( endId != '') allofus_width = '400px';
	$('#allOfus'+endId).selectpicker({
		container:'body',
		style:'btn-xs btn-default',
		width:allofus_width
	});

	$('#sizeFilterType'+endId).selectpicker({
		container:'body',
		style:'btn-xs btn-default',
		width:'90px'
	});
	$('#sizeFilterSelect'+endId).selectpicker({
		container:'body',
		style:'btn-xs btn-default',
		width:'65px'
	});

	$('#busiSelect'+endId).selectpicker({
		container:'body',
		size: 15,
		width:'222px',
		searchLabel:true,
		style:'btn-xs btn-default',
		noneSelectedText:condition.orgBusiAll,
		noneResultsText:condition.msgNoresult+' ',
		selectAllText:condition.msgSelect_all,
		deselectAllText:condition.msgUnselect_all
	});
	$('#dept'+endId).click(function(){
		openCodeWindow('dept', $('#deptVal'+endId).val(), $('#deptStr'+endId).val());
	});

	var size_slider = document.getElementById('size-setup'+endId);
	noUiSlider.create(size_slider, {
		start: [ 0 ],
		connect : 'upper',
		step: 1,
		range: {
			'min': [  0 ],
			'max': [ 10737418240 ]
		}
	});
	size_slider.noUiSlider.on('update', function( values, handle ) {
		var value = parseInt(values[handle]);
		$('#sizeStartVal'+endId).val( value );
		$('#sizeEndVal'+endId).val(0);
		$('#sizeStartValStr'+endId).html( convertFileSize( value ) );
	});

	document.getElementById('sizeStartVal'+endId).addEventListener('change', function(){
		size_slider.noUiSlider.set([this.value, null]);
	});
	document.getElementById('sizeEndVal'+endId).addEventListener('change', function(){
		size_slider.noUiSlider.set([null, this.value]);
	});

	$('#sizeStartValStr'+endId).click(function(){
		$(this).hide();
		$('#sizeStartVal'+endId).show();
		$('#sizeStartVal'+endId).focus();
	});
	$('#sizeStartVal'+endId).focusout(function(){
		$(this).hide();
		$('#sizeStartValStr'+endId).show();
	});
	$('#sizeEndValStr'+endId).click(function(){
		$(this).hide();
		$('#sizeEndVal'+endId).show();
		$('#sizeEndVal'+endId).focus();
	});
	$('#sizeEndVal'+endId).focusout(function(){
		$(this).hide();
		$('#sizeEndValStr'+endId).show();
	});

	$('#sizeStartVal'+endId).keypress(function(e){
		if( e.keyCode == 13){
			$(this).hide();
			$('#sizeStartValStr'+endId).show();
		}
	});
	$('#sizeEndVal'+endId).keypress(function(e){
		if( e.keyCode == 13){
			$(this).hide();
			$('#sizeEndValStr'+endId).show();
		}
	});

	$('#sizeFilterSelect'+endId).change(function(){
		setSizeFilter( 'size-setup'+endId, $(this).val() );
	});

	if( endId == 'Pop'){
		$('input:radio[name=filterTypePop]').change(function () {
			var value = $('input:radio[name=filterTypePop]:input:checked').val();
			if( value == 'D'){
				$('#selectConditionPopArea').show();
				$('#selectQueryPopArea').hide();
			}else{
				$('#selectConditionPopArea').hide();
				$('#selectQueryPopArea').show();

			}
		});

		$('#smartFilterSavePop').on('show.bs.modal', function(){
			getAdminFilterListPop( );

			if( $('#modalType').val() == 'add'){
				$('#startdatepickerPop').data("DateTimePicker").date($('#startdatepicker').data("DateTimePicker").date());
				$('#enddatepickerPop').data("DateTimePicker").date($('#enddatepicker').data("DateTimePicker").date());

				$("#startdatepickerPop").prop('disabled', true);
				$("#enddatepickerPop").prop('disabled', true);
				initCondition('Pop');
			}else if($('#modalType').val() == 'save'){
				$('#filterNamePopInput').val('');
				$('#filterOptionPopSelect').selectpicker('val', '1');
				$('#startDayPop').val('');
				$('#endDayPop').val('');
				$('#normalDateArea').show();
				$('#simpleDateArea').hide();
				$('#noselectDateArea').hide();

				$('#selectConditionPopArea').show();
				$('#selectQueryPopArea').hide();

				var selectedTabIdx = $('#resultTab').find('.active').index();
				var filterType = $('#'+rsKey[selectedTabIdx].contentId).find('.tabValue').attr('data-filterType');
				if( filterType == 'C') filterType = 'D';

				checkRadioBtn( 'filterTypePop', filterType );
				if( filterType == 'Q'){
					$('#selectConditionPopArea').show();
					$('#savePathPopDiv').show();
					$('#selectConditionPopDiv').hide();
					$('#queryInputTextareaPop').val($('#solrQueryText').val());
				}

				setCondition( 'Pop', getCondition('') );
			}
			else{
				var nodes = zTree.getSelectedNodes();
				if (nodes.length > 0) {
					var treeNode = nodes[0];
					var filterType = treeNode.filterType;
					if( filterType == 'D'){
						$('#selectConditionPopArea').show();
						$('#selectQueryPopArea').hide();

						var jsonData = JSON.parse(treeNode.conditions);
						setOnlyCondition( 'Pop', jsonData[jsonData.length-1] );
					}else{
						$('#selectConditionPopArea').hide();
						$('#selectQueryPopArea').show();
						setUserQuery(treeNode);
					}
					$('#filterNamePopInput').val(treeNode.name);
					checkRadioBtn( 'dashboardSelPop', treeNode.dashboard );
					checkRadioBtn( 'filterTypePop', filterType );
				}else{
					alert(condition.msgConnectError);
					return;
				}
			}
		}).on('shown.bs.modal', function(){
			var nodes = zTree.getSelectedNodes();
			if (nodes.length > 0) {
				var treeNode = nodes[0];
				treeNode.tId = 'filterTreePop_'+ treeNode.tId.split('_')[1];
				treeNode.isHover = false;

				var filterTreePop = $.fn.zTree.getZTreeObj("filterTreePop");
				filterTreePop.selectNode(treeNode);
			}
			$('#filterNamePopInput').focus();

			popOpenFlag = true;
		}).on('hidden.bs.modal', function(){
			popOpenFlag = false;
			//$.fn.zTree.destroy("#filterTreePop");
			initCondition( 'Pop' );
			getAdminFilterList( );
		});
	}

	$('#messageSort'+endId).selectpicker({
		container:'body',
		size: 15,
		width:'120px',
		dropdownAlignRight:true
	});
	if( endId != '') {
		$('#messageSortDiv .selectpicker').on('changed.bs.select', function (e) {
			searchData( );
		});
	}
}

function setUserQuery(treeNode){
	var newTreeNode = $.extend(true, {}, treeNode);
	var condition = {};
	condition.period = newTreeNode.userDtCd;
	condition.startDt = newTreeNode.startDt;
	condition.endDt = newTreeNode.endDt;
	condition.query = newTreeNode.conditions;

	setOnlyCondition( 'Pop', condition );

	$('#queryInputTextareaPop').val(newTreeNode.conditions);
}

var easyDateStartFlag = false;
var easyDateEndFlag = false;
function dateInitSetup( ){
	var dateObj = new Date();
	$('#startdatepicker').datetimepicker({
		format: 'YYYY-MM-DD HH:mm:ss',
		locale: 'ko',
		sideBySide: true,
		defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-7 ) )
	}).on("dp.change", function (e) {
		if( easyDateStartFlag ){
			easyDateStartFlag = false;
			return;
		}else{
			unSelectRadioVal('easyDate');
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
			unSelectRadioVal('easyDate');
		}
	});

	$('#startdatepickerPop').datetimepicker({
		format: 'YYYY-MM-DD HH:mm:ss',
		locale: 'ko',
		sideBySide: true,
		defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate() ) )
	}).on("dp.change", function (e) {
		if( easyDateEndFlag ){
			easyDateEndFlag = false;
			return;
		}else{
			unSelectRadioVal('easyDatePop');
		}
	});
	$('#enddatepickerPop').datetimepicker({
		format: 'YYYY-MM-DD HH:mm:ss',
		locale: 'ko',
		sideBySide: true,
		defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
	}).on("dp.change", function (e) {
		if( easyDateStartFlag ){
			easyDateStartFlag = false;
			return;
		}else{
			unSelectRadioVal('easyDatePop');
		}
	});

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

	$('input:radio[name=easyDate]').change(function () {
		changeDate($('input:radio[name=easyDate]:input:checked').val());
	});

	$('#filterOptionPopSelect').change(function(){
		var val = $(this).val();

		if( val == '1'){
			$('#normalDateArea').show();
			$('#simpleDateArea').hide();
			$('#noselectDateArea').hide();
		}else if( val == '2'){
			$('#normalDateArea').hide();
			$('#simpleDateArea').show();
			$('#noselectDateArea').hide();
		}else if( val == '3'){
			$('#normalDateArea').hide();
			$('#simpleDateArea').hide();
			$('#noselectDateArea').show();
		}
	});
}

function dateInitSetupNew( ){
	var dateObj = new Date();
	/*
	$('#startdatepicker').datetimepicker({
		widgetParent:'.boxArea',
		format: 'YYYY-MM-DD HH:mm:ss',
		locale: 'ko',
		sideBySide: true,
		defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-7 ) )
	}).on("dp.change", function (e) {
		if( easyDateStartFlag ){
			easyDateStartFlag = false;
			return;
		}else{
			unSelectRadioVal('easyDate');
		}
    }).on('dp.show', function(){
        var datepicker = $("body").find('.bootstrap-datetimepicker-widget:last');
        if (datepicker.hasClass('bottom')) {
           var top = $(this).offset().top + $(this).outerHeight();
           var left = $(this).offset().left;
           datepicker.css({
              'top': top + 'px', 
              'bottom': 'auto',
              'left': left+'px'
           });
        }
    });
	*/
	$('#startdatepicker').datetimepicker({
		format: 'YYYY-MM-DD HH:mm:ss',
		locale: 'ko',
		sideBySide: true,
		defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-7 ) )
	}).on("dp.change", function (e) {
		if( easyDateStartFlag ){
			easyDateStartFlag = false;
			return;
		}else{
			unSelectRadioVal('easyDate');
		}
	});

	$('#enddatepicker').datetimepicker({
		widgetParent:'.boxArea',
		format: 'YYYY-MM-DD HH:mm:ss',
		locale: 'ko',
		sideBySide: true,
		defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
	}).on("dp.change", function (e) {
		if( easyDateEndFlag ){
			easyDateEndFlag = false;
			return;
		}else{
			unSelectRadioVal('easyDate');
		}
	}).on('dp.show', function(){
		var datepicker = $("body").find('.bootstrap-datetimepicker-widget:last');
		if (datepicker.hasClass('bottom')) {
			var top = $(this).offset().top + $(this).outerHeight();
			var left = $(this).offset().left;
			datepicker.css({
				'top': top + 'px',
				'bottom': 'auto',
				'left': left+'px'
			});
		}
	});

	$('#startdatepickerPop').datetimepicker({
		format: 'YYYY-MM-DD HH:mm:ss',
		locale: 'ko',
		sideBySide: true,
		defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate() ) )
	}).on("dp.change", function (e) {
		if( easyDateEndFlag ){
			easyDateEndFlag = false;
			return;
		}else{
			unSelectRadioVal('easyDatePop');
		}
	});
	$('#enddatepickerPop').datetimepicker({
		format: 'YYYY-MM-DD HH:mm:ss',
		locale: 'ko',
		sideBySide: true,
		defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
	}).on("dp.change", function (e) {
		if( easyDateStartFlag ){
			easyDateStartFlag = false;
			return;
		}else{
			unSelectRadioVal('easyDatePop');
		}
	});

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

	$('input:radio[name=easyDate]').change(function () {
		changeDate($('input:radio[name=easyDate]:input:checked').val());
	});

	$('#filterOptionPopSelect').change(function(){
		var val = $(this).val();

		if( val == '1'){
			$('#normalDateArea').show();
			$('#simpleDateArea').hide();
			$('#noselectDateArea').hide();
		}else if( val == '2'){
			$('#normalDateArea').hide();
			$('#simpleDateArea').show();
			$('#noselectDateArea').hide();
		}else if( val == '3'){
			$('#normalDateArea').hide();
			$('#simpleDateArea').hide();
			$('#noselectDateArea').show();
		}
	});
}

//사이즈 필터 공통 설정 function
function setSizeFilter( id, val ){
	var endId = '';
	if( id == 'size-setupPop') endId = 'Pop';

	var sizeIds = {
		sizeRangeValStr:'sizeRangeValStr'+endId,
		sizeStartValStr:'sizeStartValStr'+endId,
		sizeEndValStr:'sizeEndValStr'+endId,
		sizeStartVal:'sizeStartVal'+endId,
		sizeEndVal:'sizeEndVal'+endId
	};

	var size_slider = document.getElementById(id);
	if( size_slider.noUiSlider != undefined ) size_slider.noUiSlider.destroy( );
	$('#'+sizeIds.sizeRangeValStr).hide();
	$('#'+sizeIds.sizeEndValStr).hide();
	var options = {};
	if( val == 'B'){
		options = {
			start: [$('#'+sizeIds.sizeStartVal).val(), $('#'+sizeIds.sizeEndVal).val()==0 ? 10737418240 : $('#'+sizeIds.sizeEndVal).val()],
			behaviour: 'drag-tap',
			step: 1024,
			connect : true,
			range: {
				'min': [  0 ],
				'max': [ 1073741824 ]
			}
		};

		var sizeValues = [
			document.getElementById(sizeIds.sizeStartVal),
			document.getElementById(sizeIds.sizeEndVal)
		];
		var sizeStrValues = [
			document.getElementById(sizeIds.sizeStartValStr),
			document.getElementById(sizeIds.sizeEndValStr)
		];
		noUiSlider.create(size_slider, options);
		size_slider.noUiSlider.on('update', function( values, handle ) {
			var value = parseInt(values[handle]);
			sizeValues[handle].value = value;
			sizeStrValues[handle].innerHTML = convertFileSize( value );
		});
		$('#'+sizeIds.sizeRangeValStr).show();
		$('#'+sizeIds.sizeEndValStr).show();
	}else if(val == 'L'){
		options = {
			start: $('#'+sizeIds.sizeStartVal).val(),
			connect : 'upper',
			step: 1024,
			range: {
				'min': 0,
				'max': 1073741824
			}
		};

		noUiSlider.create(size_slider, options);
		size_slider.noUiSlider.on('update', function( values, handle ) {
			var value = parseInt(values[handle]);
			$('#'+sizeIds.sizeStartVal).val( value );
			$('#'+sizeIds.sizeEndVal).val( 0 );
			$('#'+sizeIds.sizeStartValStr).html( convertFileSize( value ) );
		});

	}else if(val == 'S'){
		options = {
			start: $('#'+sizeIds.sizeStartVal).val(),
			connect : 'lower',
			step: 1024,
			range: {
				'min': 0,
				'max': 1073741824
			}
		};

		noUiSlider.create(size_slider, options);
		size_slider.noUiSlider.on('update', function( values, handle ) {
			var value = parseInt(values[handle]);
			$('#'+sizeIds.sizeStartVal).val( value );
			$('#'+sizeIds.sizeEndVal).val( 0 );
			$('#'+sizeIds.sizeStartValStr).html( convertFileSize( value ) );
		});
	}

	document.getElementById(sizeIds.sizeStartVal).addEventListener('change', function(){
		size_slider.noUiSlider.set([this.value, null]);
	});
	document.getElementById(sizeIds.sizeEndVal).addEventListener('change', function(){
		size_slider.noUiSlider.set([null, this.value]);
	});
}

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

function initCondition( endId ){
	$('#filterName').val('');
	$('#filter_seq').val('');
	$('#p_filter_seq').val('');

	if( isConsent() && endId == ''){
		$('#consentNo').val('');
		$('#consentName').text('');
		//$('#consentIp').val('');
		//$('#consentEmail').val('');
		$('#consentUserId').val('');
		$('#consentBtn').removeClass('active');
	}

	if( endId == ''){
		//$('#researchCheckbox').prop('disabled', false);
		$("input:checkbox[id='researchCheckbox"+endId+"']").prop("checked", false);

		easyDateStartFlag = true;
		easyDateEndFlag = true;

		var dateObj = new Date();
		$('#startdatepicker'+endId).data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-7, 00, 00, 00 ) );
		$('#enddatepicker'+endId).data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) );
		checkRadioBtn( 'easyDate', 3 );

		$('#solrQueryText').val('');
	}else{
		$('#filterNamePopInput').val('');
		$('#filterOptionPopSelect').selectpicker('val', '1');
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
	$('#messageSort'+endId).selectpicker('val', 'ctime desc');
	$('#searchStrInput'+endId).val('');
	$('#serviceTypeSelect'+endId).selectpicker('val', []);
	$('#searchField'+endId).selectpicker('val', '');
	$('#userSeq'+endId).selectpicker('val', '');
	$('#userGroupSeq'+endId).selectpicker('val', '');
	checkRadioBtn( 'regexp_drmYn'+endId, '' );
	checkRadioBtn( 'regexp_sctYn'+endId, '' );
	checkRadioBtn( 'ctimeWork'+endId, '' );

	checkRadioBtn( 'readYn'+endId, '' );
	checkRadioBtn( 'receiveSend'+endId, '' );

	$('#receivers'+endId).val('');
	$('#senders'+endId).val('');

	$('#busiSelect'+endId).selectpicker('val', [] );
	$('#deptStr'+endId).val('');
	$('#deptVal'+endId).val('');
	$('#deptSelectedArea'+endId).hide();

	checkRadioBtn( 'serviceYn'+endId, '' );
	checkRadioBtn( 'attachYn'+endId, '' );
	$('#attachBtnArea'+endId).hide();
	checkRadioBtn( 'keywordYn'+endId, '' );
	$('#keywordBtnArea'+endId).hide();
	checkRadioBtn( 'regexpYn'+endId, '' );
	$('#regexpBtnArea'+endId).hide();

	$('#allOfus'+endId).selectpicker('val', '');

	$('#sizeStartVal'+endId).val(0);
	$('#sizeEndVal'+endId).val(0);
	$('#sizeFilterSelect'+endId).selectpicker('val', 'L');
	setSizeFilter( 'size-setup'+endId, 'L' );
	$('#sizeFilterType'+endId).selectpicker('val', '');
}

function checkRadioBtn( name, val ){
	if(val == null) return;
	if( $.isNumeric(val) ) $('input:radio[name='+name+']:input[value='+val+']').parent().click();
	else $('input:radio[name='+name+']:input[value='+idIndicator(val)+']').parent().click();
}
function unSelectRadioVal( name ){
	easyDateStartFlag = false;
	easyDateEndFlag = false;
	$('input:radio[name='+name+']:input:checked').parent().removeClass('active');
	$('input:radio[name='+name+']:input:checked').prop("checked", false);
}

/**
 * 파라미터 형식으로 조건 생성
 */
function getCondition( endId ){
	var filterVal = {};

	filterVal.filterName = $('#filterName').val();
	filterVal.filter_seq = $('filter_seq').val();
	filterVal.p_filter_seq = $('#p_filter_seq').val();

	if( isConsent() && endId == ''){
		filterVal.consentNo = $('#consentNo').val();
		filterVal.consentName = $('#consentName').text();
		filterVal.consentShortName = $('#consentShortName').val();
		//filterVal.consentIp = $('#consentIp').val();
		//filterVal.consentEmail = $('#consentEmail').val();
		filterVal.consentUserId = $('#consentUserId').val();
	}

	if( endId != '' ){
		var filterName = $('#filterNamePopInput').val();
		var filterTreePop = $.fn.zTree.getZTreeObj("filterTreePop");
		var nodes = filterTreePop.getSelectedNodes();
		var p_filter_seq = nodes[0].id;

		filterVal.filterName = filterName;
		filterVal.filter_seq = nodes[0].id;
		filterVal.p_filter_seq = nodes[0].pId;
		filterVal.filterType = $('input:radio[name=filterTypePop]:input:checked').val();
		filterVal.dashboard = $('input:radio[name=dashboardSelPop]:input:checked').val();
	}
	var conArray = [];
	conArray.push( createCondition( endId ) );
	filterVal.conditions = conArray;

	//console.log(JSON.stringify(filterVal))
	return filterVal;
}

function addCondition(endId, filterVal){
	var filterVal = $.extend(true, {}, filterVal);

	filterVal.filterName = '';
	filterVal.filter_seq = '';
	filterVal.p_filter_seq = '';

	if( isConsent() && endId == ''){
		filterVal.consentNo = $('#consentNo').val();
		filterVal.consentName = $('#consentName').text();
		//filterVal.consentIp = $('#consentIp').val();
		//filterVal.consentEmail = $('#consentEmail').val();
		filterVal.consentUserId = $('#consentUserId').val();
	}

	if( endId != '' ){
		var filterName = $('#filterNamePopInput').val();
		var filterTreePop = $.fn.zTree.getZTreeObj("filterTreePop");
		var nodes = filterTreePop.getSelectedNodes();
		var p_filter_seq = nodes[0].id;

		filterVal.filterName = filterName;
		filterVal.filter_seq = nodes[0].id;
		filterVal.p_filter_seq = nodes[0].pId;
		filterVal.dashboard = $('input:radio[name=dashboardSelPop]:input:checked').val();
	}
	var conArray = [];
	conArray.push( createCondition( endId ) );
	filterVal.conditions = conArray;

	return filterVal;
}

/**
 * 기간 및 결과내 재검색 조건을 제외한 검색식 조건 생성
 */
function createCondition( endId ){
	var condition = {};
	condition.sort = $('#messageSort'+endId).selectpicker('val');
	condition.reSearch = $("input:checkbox[id='researchCheckbox']").is(":checked");
	condition.searchStr = $('#searchStrInput'+endId).val();
	condition.searchField = $('#searchField'+endId).selectpicker('val');
	condition.serviceType = arrayToString($('#serviceTypeSelect'+endId).selectpicker('val'));
	condition.interUser = $('#userSeq'+endId).selectpicker('val');
	if(condition.interUser != '') condition.interUserName = $('#userSeq'+endId).parent().find('.filter-option').text();
	else condition.interUserName = '';

	condition.senders = $('#senders'+endId).val();

	condition.receive_option = $('input:radio[name=receive_option'+endId+']:input:checked').val();
	if (condition.receive_option == '' || condition.receive_option == undefined) {
		condition.receivers = $('#receivers'+endId).val();
		condition.rcvTo = '';
		condition.rcvCc = '';
		condition.rcvBcc = '';
		condition.rcvTo_not = '';
		condition.rcvCc_not = '';
		condition.rcvBcc_not = '';
		condition.rcvTo_findByKeyword = '';
		condition.rcvCc_findByKeyword = '';
		condition.rcvBcc_findByKeyword = '';
		condition.rcvTo_findByParam = '';
		condition.rcvCc_findByParam = '';
		condition.rcvBcc_findByParam = '';
	} else {
		condition.receivers = '';
		condition.rcvTo = $('#m_to'+endId).val() || $('#rcvTo'+endId).val();
		condition.rcvCc = $('#m_cc'+endId).val() || $('#rcvCc'+endId).val();
		condition.rcvBcc = $('#m_bcc'+endId).val() || $('#rcvBcc'+endId).val();
		condition.rcvTo_not = $('input:checkbox[id="m_to_not'+endId+'"]').is(":checked") || $('input:checkbox[id="rcvTo_not'+endId+'"]').is(":checked") ? 'Y' : '';
		condition.rcvCc_not = $('input:checkbox[id="m_cc_not'+endId+'"]').is(":checked") || $('input:checkbox[id="rcvCc_not'+endId+'"]').is(":checked") ? 'Y' : '';
		condition.rcvBcc_not = $('input:checkbox[id="m_bcc_not'+endId+'"]').is(":checked") || $('input:checkbox[id="rcvBcc_not'+endId+'"]').is(":checked") ? 'Y' : '';
		condition.rcvTo_findByKeyword = $('input:checkbox[id="m_to_findByKeyword'+endId+'"]').is(":checked") || $('input:checkbox[id="rcvTo_findByKeyword'+endId+'"]').is(":checked") ? 'Y' : '';
		condition.rcvCc_findByKeyword = $('input:checkbox[id="m_cc_findByKeyword'+endId+'"]').is(":checked") || $('input:checkbox[id="rcvCc_findByKeyword'+endId+'"]').is(":checked") ? 'Y' : '';
		condition.rcvBcc_findByKeyword = $('input:checkbox[id="m_bcc_findByKeyword'+endId+'"]').is(":checked") || $('input:checkbox[id="rcvBcc_findByKeyword'+endId+'"]').is(":checked") ? 'Y' : '';
		if (condition.rcvTo_findByKeyword == 'Y') {
			condition.rcvTo_findByParam = '';
		} else {
			condition.rcvTo_findByParam = $('input:checkbox[id="m_to_findByParam'+endId+'"]').is(":checked") || $('input:checkbox[id="rcvTo_findByParam'+endId+'"]').is(":checked") ? 'Y' : '';
		}
		if (condition.rcvCc_findByKeyword == 'Y') {
			condition.rcvCc_findByParam = '';
		} else {
			condition.rcvCc_findByParam = $('input:checkbox[id="m_cc_findByParam'+endId+'"]').is(":checked") || $('input:checkbox[id="rcvCc_findByParam'+endId+'"]').is(":checked") ? 'Y' : '';
		}
		if (condition.rcvBcc_findByKeyword == 'Y') {
			condition.rcvBcc_findByParam = '';
		} else {
			condition.rcvBcc_findByParam = $('input:checkbox[id="m_bcc_findByParam'+endId+'"]').is(":checked") || $('input:checkbox[id="rcvBcc_findByParam'+endId+'"]').is(":checked") ? 'Y' : '';
		}
	}
	condition.rcvJikgub = $('#rcvJikgub'+endId).val();
	condition.allOfus = $('#allOfus'+endId).val();

	condition.ctimeWork = $('input:radio[name=ctimeWork'+endId+']:input:checked').val();

	condition.busi = arrayToString($('#busiSelect'+endId).selectpicker('val'));
	if(condition.busi != '') condition.busiStr = $('#busiSelect'+endId).parent().find('.filter-option').text();
	else condition.busiStr = '';

	condition.dept = $('#deptVal'+endId).val();
	if(condition.dept != '') condition.deptStr = $('#deptStr'+endId).val();
	else condition.deptStr = '';

	condition.jikgub = $('#jikgubInput'+endId).val();

	condition.readYn = $('input:radio[name=readYn'+endId+']:input:checked').val();
	condition.receiveSend = $('input:radio[name=receiveSend'+endId+']:input:checked').val();

	condition.attachYn = $('input:radio[name=attachYn'+endId+']:input:checked').val();
	condition.attachVal = $('#attachVal'+endId).val();
	condition.attachStr = $('#attachStr'+endId).val();
	condition.keywordYn = $('input:radio[name=keywordYn'+endId+']:input:checked').val();
	condition.keywordVal = $('#keywordVal'+endId).val();
	condition.keywordStr = $('#keywordStr'+endId).val();
	condition.regexpYn = $('input:radio[name=regexpYn'+endId+']:input:checked').val();
	condition.regexpVal = $('#regexpVal'+endId).val();
	condition.regexpStr = $('#regexpStr'+endId).val();

	condition.allOfus = $('#allOfus'+endId).val();

	condition.sizeStartVal = $('#sizeStartVal'+endId).val();
	condition.sizeEndVal = $('#sizeEndVal'+endId).val();
	condition.sizeOption = $('#sizeFilterSelect'+endId).val();
	condition.sizeType = $('#sizeFilterType'+endId).val();

	condition.drmYn = $('input:radio[name=regexp_drmYn'+endId+']:input:checked').val();
	condition.sctYn = $('input:radio[name=regexp_sctYn'+endId+']:input:checked').val();
	condition.userGroupSeq = arrayToString($('#userGroupSeq'+endId).selectpicker('val'));
	if(condition.userGroupSeq != '') condition.userGroupName = $('#userGroupSeq'+endId).parent().find('.filter-option').text();
	else condition.userGroupName = '';

	if( endId != '' ){
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

		var filterType = $('input:radio[name=filterTypePop]:input:checked').val();
		if(filterType == 'Q') condition.query = $('#queryInputTextareaPop').val();
		else condition.query = '';

		condition.filterType = filterType;
	}else{
		condition.period = 1;
		condition.startDt = $('#startdatepicker'+endId).data("DateTimePicker").date().format('YYYYMMDDHHmmss');
		condition.endDt = $('#enddatepicker'+endId).data("DateTimePicker").date().format('YYYYMMDDHHmmss');
		condition.easyDate = $('input:radio[name=easyDate'+endId+']:input:checked').val();
		condition.query = $('#solrQueryText').val();

		var selectedTabIdx = $('#resultTab').find('.active').index();
		condition.filterType = $('#'+rsKey[selectedTabIdx].contentId).find('.tabValue').attr('data-filterType');
	}
	return condition;
}

function setCondition( endId, filterVal ){
	$('#filterName').val(filterVal.name);
	$('#filter_seq').val(filterVal.id);
	$('#p_filter_seq').val(filterVal.pId);

	if( isConsent() && endId == ''){
		$('#consentNo').val(filterVal.consentNo);
		$('#consentName').text(filterVal.consentName);
		//$('#consentIp').val(filterVal.consentIp);
		//$('#consentEmail').val(filterVal.consentEmail);
		$('#consentUserId').val(filterVal.consentUserId);

		if( filterVal.consentNo == '') $('#consentBtn').removeClass('active');
		else $('#consentBtn').addClass('active');
	}
	if( endId != ''){
		checkRadioBtn( 'dashboardSelPop', filterVal.dashboard );
	}

	var conArray = getJson(filterVal.conditions);
	setOnlyCondition( endId, conArray[conArray.length-1] );
}

function setOnlyCondition( endId, condition ){

	if( condition.easyDate == '' ) unSelectRadioVal('easyDate'+endId);
	else checkRadioBtn( 'easyDate'+endId, condition.easyDate );

	if( endId != ''){
		$('#filterOptionPopSelect').selectpicker('val', condition.period );
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
			$('#startdatepicker'+endId).data("DateTimePicker").date(condition.startDt.toDate());
			$('#enddatepicker'+endId).data("DateTimePicker").date(condition.endDt.toDate());
		}else if( condition.period == 2){
			var dateObj = new Date();
			$('#startdatepicker'+endId).data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-condition.startDt, 00, 00, 00 ) );
			$('#enddatepicker'+endId).data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-condition.endDt, 23, 59, 59 ) );
		}else if( condition.startDt != undefined && condition.startDt != ''){
			$('#startdatepicker'+endId).data("DateTimePicker").date(condition.startDt.toDate());
			$('#enddatepicker'+endId).data("DateTimePicker").date(condition.endDt.toDate());
		}

		$('#solrQueryText').val(condition.query);
	}
	if( condition.sort == '') $('#messageSort'+endId).selectpicker('val', 'ctime desc');
	else $('#messageSort'+endId).selectpicker('val', condition.sort);

	$("input:checkbox[id='researchCheckbox"+endId+"']").prop("checked", eval(condition.reSearch == undefined ? false : condition.reSearch));
	$('#searchStrInput'+endId).val(condition.searchStr);
	$('#searchField'+endId).selectpicker('val', condition.searchField );
	$('#serviceTypeSelect'+endId).selectpicker('val', stringToArray(condition.serviceType) );
	$('#userSeq'+endId).selectpicker('val', stringToArray(condition.interUser));

	checkRadioBtn( 'ctimeWork'+endId, condition.ctimeWork );

	$('#senders'+endId).val( condition.senders );

	// receive_option에 따라 수신자 정보 설정
	if (condition.receive_option == '' || condition.receive_option == undefined) {
		// 일반 수신자 모드
		$('#receivers'+endId).val( condition.receivers );
		// 상세 수신자 필드는 초기화
		var m_to_elem = $('#m_to'+endId);
		var m_cc_elem = $('#m_cc'+endId);
		var m_bcc_elem = $('#m_bcc'+endId);
		if (m_to_elem.length > 0) {
			m_to_elem.val('');
		}
		if (m_cc_elem.length > 0) {
			m_cc_elem.val('');
		}
		if (m_bcc_elem.length > 0) {
			m_bcc_elem.val('');
		}
		var rcvTo_elem = $('#rcvTo'+endId);
		var rcvCc_elem = $('#rcvCc'+endId);
		var rcvBcc_elem = $('#rcvBcc'+endId);
		if (rcvTo_elem.length > 0) {
			rcvTo_elem.val('');
		}
		if (rcvCc_elem.length > 0) {
			rcvCc_elem.val('');
		}
		if (rcvBcc_elem.length > 0) {
			rcvBcc_elem.val('');
		}
	} else {
		// 상세 수신자 모드
		$('#receivers'+endId).val('');
		// m_to, m_cc, m_bcc 또는 rcvTo, rcvCc, rcvBcc 중 사용 가능한 것 사용
		var m_to_val = condition.m_to || condition.rcvTo || '';
		var m_cc_val = condition.m_cc || condition.rcvCc || '';
		var m_bcc_val = condition.m_bcc || condition.rcvBcc || '';
		var m_to_elem = $('#m_to'+endId);
		var m_cc_elem = $('#m_cc'+endId);
		var m_bcc_elem = $('#m_bcc'+endId);
		if (m_to_elem.length > 0) {
			m_to_elem.val(m_to_val);
		} else {
			$('#rcvTo'+endId).val(m_to_val);
		}
		if (m_cc_elem.length > 0) {
			m_cc_elem.val(m_cc_val);
		} else {
			$('#rcvCc'+endId).val(m_cc_val);
		}
		if (m_bcc_elem.length > 0) {
			m_bcc_elem.val(m_bcc_val);
		} else {
			$('#rcvBcc'+endId).val(m_bcc_val);
		}
	}

	$('#rcvJikgub'+endId).val( condition.rcvJikgub );
	$('#allOfus'+endId).val( condition.allOfus );


	$('#busiSelect'+endId).selectpicker('val', stringToArray(condition.busi) );

	if(condition.dept != "") {
		$('#deptVal'+endId).val( condition.dept );
		$('#deptStr'+endId).val( condition.deptStr );
		$('#deptSelectedArea').show();
	}else{
		$('#deptVal'+endId).val('');
		$('#deptStr'+endId).val('');
		$('#deptSelectedArea').hide();
	}
	setCodeCount('dept', endId, condition.dept, ',');

	$('#jikgubInput'+endId).val( condition.jikgub );

	checkRadioBtn( 'readYn'+endId, condition.readYn );
	checkRadioBtn( 'receiveSend'+endId, condition.receiveSend );

	checkRadioBtn( 'attachYn'+endId, condition.attachYn );
	setCodeCount('attach', endId, condition.attachVal, '|');
	$('#attachVal'+endId).val( condition.attachVal );
	$('#attachStr'+endId).val( condition.attachStr );
	changeRadioVal('attach', endId, condition.attachYn);

	checkRadioBtn( 'keywordYn'+endId, condition.keywordYn );
	setCodeCount('keyword', endId, condition.keywordVal, '|');
	$('#keywordVal'+endId).val( condition.keywordVal );
	$('#keywordStr'+endId).val( condition.keywordStr );
	changeRadioVal('keyword', endId, condition.keywordYn);

	checkRadioBtn( 'regexpYn'+endId, condition.regexpYn );
	setCodeCount('regexp', endId, condition.regexpVal, '|');
	$('#regexpVal'+endId).val( condition.regexpVal );
	$('#regexpStr'+endId).val( condition.regexpStr );
	changeRadioVal('regexp', endId, condition.regexpYn);

	$('#sizeStartVal'+endId).val(rtnDefaultVal(condition.sizeStartVal, 0));
	$('#sizeEndVal'+endId).val(rtnDefaultVal(condition.sizeEndVal, 0));
	$('#sizeFilterSelect'+endId).selectpicker('val', rtnDefaultVal(condition.sizeOption, 'L'));
	$('#sizeFilterType'+endId).selectpicker('val', rtnDefaultVal(condition.sizeType, ''));

	setSizeFilter( 'size-setup'+endId, rtnDefaultVal(condition.sizeOption, 'L') );

	$('#userGroupSeq'+endId).selectpicker('val', stringToArray(condition.userGroupSeq));
	checkRadioBtn( 'regexp_drmYn'+endId, condition.drmYn );
	checkRadioBtn( 'regexp_sctYn'+endId, condition.sctYn );
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