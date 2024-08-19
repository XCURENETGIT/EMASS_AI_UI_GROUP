<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>

<%
	String adminType = Common.getAdminType(session);
	String firstAdminYn = Common.getFirstAdminYn(session);
%>

<script>
	$(function() {
		$("#xcn_toggleBtn").on("click", function() {
			$("#xcn_Search").toggle("show");
		})
	})

	$(function() {
		$("#showBtn").on("click", function() {
			$("#xcn_Search2").show();
		})
		$("#xcn_toggleBtn2").on("click", function() {
			$("#xcn_Search2").hide();
		})
	})
</script>

<style>

	.messengerList .messengerBox .people {
		height: 650px;
	}

	#wrap {overflow:hidden;}

</style>

<head>
	<title>EMASS AI - <s:message code="DATA_MONITOR.MESSAGE_SERVICE"/></title>
	<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/collection.js"/>"></script>

	<script>
		var messengerListCnt = 0;
		var nodataMsg = '<s:message code="common.msg.nodata"/>';
		var notone = '<s:message code="common.msg.notone"/>';
		var chatting = '<s:message code="eikon.msg.chat"/>';
		var endChat = '<s:message code="eikon.msg.finish"/>';
		var unreadTitle = '<s:message code="eikon.msg.unreadTitle"/>';
		var condition = {
			messageInputFilter: '<s:message code="condition.message.input.filter"/>',
			messageInputPeriod: '<s:message code="condition.message.input.period"/>',
			consentMsgTimecheck: '<s:message code="consent.msg.timecheck"/>',
			messageNumbercheck: '<s:message code="condition.message.numbercheck"/>',
			messageFolderFilter: '<s:message code="condition.message.folder.filter"/>',
			messageSelectFolder: '<s:message code="condition.message.select.folder"/>',
			msgSaved: '<s:message code="common.msg.saved"/>',
			selectInterest: '<s:message code="condition.select.interest"/>',
			interestUserAll: '<s:message code="interest.user.all"/>',
			commonMsgAll: '<s:message code="common.msg.all"/>',
			serviceAll: '<s:message code="condition.service.all"/>',
			messengerAll: '<s:message code="condition.messenger.all"/>',
			orgBusiAll: '<s:message code="common.org.busi.all"/>',
			orgDeptAll: '<s:message code="common.org.dept.all"/>',
			msgSelect_all: '<s:message code="common.msg.select_all"/>',
			msgUnselect_all: '<s:message code="common.msg.unselect_all"/>',
			msgNoresult: '<s:message code="common.msg.noresult"/>',
			msgConnectError: '<s:message code="common.msg.connect.error"/>',
			messageSelectDashboard: '<s:message code="condition.message.select.dashboard"/>',
			msgConfirmSave: '<s:message code="common.msg.confirm.save"/>',
			searchService: '<s:message code="condition.search.service"/>',
			authAlert: '<s:message code="admin.auth.alert"/>',
			noselect: '<s:message code="common.msg.noselect"/>'

		};
		$(document).ready(function () {
            $('#group_list').scroll(function (){
                if (isEnd == true) return false;
                let $groupList = $('#group_list');
                let scrollTop = $groupList.scrollTop();
                let scrollHeight = $groupList[0].scrollHeight;
                if (scrollTop + $groupList.height() >= scrollHeight) {
                    if (!isLoading) return false;
                    eikon2.getFileGroupList(groupPage + 1);
                    isLoading = false;
                }
            });


			$(window).resize(function () {
				if ($(window).width() < 1700) {
					$('#searchResultBtnArea').addClass('btnCustomPosition');
				} else {
					$('#searchResultBtnArea').removeClass('btnCustomPosition');
				}
			});
            initDateTimePicker('startDt','endDt');

/*            var today = new Date();
            today.setDate(today.getDate() - 7);

            document.getElementById("startDt").valueAsDate = today;
            document.getElementById("endDt").valueAsDate = new Date();*/


            $(document).click(function(){
                $('.imgPreviewDiv').hide();
            });

            $(document).on('click', '#attachText', function(){
                var searchkey=$('#searchStrInput').val();

                var msgId = $(this).parents('li').attr('msgid');
                var attachId = $(this).parents('li').attr('id');

                var url = contextRoot + '/ems/attachText.do?msgId='+msgId+'&attachId='+attachId+'&searchKey='+searchkey;
                fnOpenWindow(url, 'attachText', 1050, 800, 'resize');
            });

            $(document).on('mouseover', '.attachName', function(){
                filePreviewEv(this);
            });

/*            $(document).on('click', '#attachOcrText', function(){
  /!*             var searchkey=$('#searchStrInput').val();
                var msgId = $(this).parents('li').attr('msgid');
                var attachId = $(this).parents('li').attr('attachhash');
                var url = contextRoot + '/ems/attachText.do?msgId=' + msgId+ '&attachId=' + attachId + '&searchKey=' + encodeURI(searchkey) + '&ocrYn=Y';
                fnOpenWindow(url, 'attachText', 1050, 800, 'resize');
            });*!/*/

            $(document).on('click', '#attachOcrText', function(){
                var msgId = $(this).parents('li').attr('msgid');
                var attachId = $(this).parents('li').attr('id');
                var url = contextRoot + '/ems/attachText.do?msgId=' + msgId+ '&attachId=' + attachId + '&searchKey=' + '' + '&ocrYn=Y';
                fnOpenWindow(url, 'attachText', 1050, 800, 'resize');
            });


            $('#saveBtn').click ( function ( ) {

                var msgId = $('#conmsg').attr('msgid');
                var charset = $('#bodyEncoding').val();
                var url = contextRoot + '/getEmassBodySave.xcn?msgId='+msgId+'&userCharset='+charset+'&print=N';
                var fileName = msgId+'.html';
                var fileSize = 1;


                try {
                    AttachDown.location.href = url;
                } catch (e) {
                    AttachDown.src = url;
                }

         /*       var information = '[' + message.bodyView + ']' + enter;
                if( detailFlag ) information += message.xrootmtr + ' : ' + xRootMtr + ' ';
                else information += message.msgid + ' : ' + msgId + ' ';
                insertAudit(op_body_save, information);*/
            });

            $('#printBtn').click ( function ( ) {
                var msgId = $('#conmsg').attr('msgid');
                var charset = $('#bodyEncoding').val();

                var url = contextRoot + '/getEmassBodySave.xcn?msgId=' + msgId + '&userCharset=' + charset + '&print=Y';

                    var startDt = $('#startDt').val()+"000000";
                    var endDt = $('#endDt').val()+"235959"


                fnOpenWindow( url, 'message_print', '1000', '800', 'scroll' );


/*                var information = '[' + message.bodyPrint + ']'+enter;
                if( detailFlag ) information += message.xrootmtr + ' : ' + xRootMtr + ' ';
                else information += message.msgid + ' : ' + msgId + ' ';
                insertAudit(op_body_print, information);*/
            });




			$('#searchBtn').click(function () {
                $('#group_list').scrollTop(0);
                isEnd = false;
				if (messengerListCnt == 0) {
					ui.alertMsg('<s:message code="eikon.noList"/>');
					return;
				}
				var startDt = $('#startDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '');
				var endDt = $('#endDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '');
				if (startDt == '') {
					ui.alertMsg('<s:message code="message.message.startdt.input"/>');
					return;
				}
				if (endDt == '') {
					ui.alertMsg('<s:message code="message.message.enddt.input"/>');
					return;
				}
				if (startDt > endDt) {
					ui.alertMsg('<s:message code="consent.msg.timecheck"/>');
					return;
				}
				/*      if (getDayInterval(startDt, endDt) > 31) {
                          ui.alertMsg('<s:message code="eikon.msg.select.date"/>');
                    return;
                }*/
                setcurrentSchVal();
				eikon2.getFileGroupList(1);
			});
			$("#searchStrInput").keypress(function (e) {
				if (e.keyCode == 13) $('#searchBtn').click();
			}); //통합 검색 엔터키

			$('#searchMsgBtn').click(function () {
				if ($('#searchMsgStrInput').val() == "") $('#searchMsgQueryBtn').click();
				else eikon2.findMessageList(0);
				//eikon.getMessengerDetailList($('#xrootmtr').text(),$('#msgid').text(), $('#srcip').text());
			});
			$('#searchMsgQueryBtn').click(function () {
				var selectedUsrId = $('#selectUserInfo').attr('data-usrid');
				getDetailData(selectedUsrId);
			});
			$("#searchMsgStrInput").keypress(function (e) {
				if (e.keyCode == 13) {
					if ($('#searchMsgStrInput').val() == "") $('#searchMsgQueryBtn').click();
					else $('#searchMsgBtn').click();
				}
			});

			$('#searchMsgUp').click(function () {
				eikon2.findMessageList(--searchOffset);
// 		checkList(--searchOffset);
			});
			$('#searchMsgDn').click(function () {
// 		checkList(++searchOffset);
				eikon2.findMessageList(++searchOffset);
			});
			$('#listCntArea').click(function () {
				//if( $('#messageTotalCnt').html() == 0 || $('#messageTotalCnt').html() == '') return;
				openSelectDiv();
			});
			$('#userCntArea').click(function () {
				if ($('#selectUserInfo').html() == '-') return;
				openSelectUserDiv();
			});

			$('#dept').click(function () {
				var code = $(this).attr('id');
				openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val());
			});

            $('#user').click(function () {
                var code = $(this).attr('id');
                openCodeWindow(code, $('#' + code + 'Val').val(), $('#' + code + 'Str').val(), $('#' + code + 'Dept').val(), $('#' + code + 'Jib').val());
            });

            $('.txt_down').click(function () {
				downloadList('txt');
				hideSelect();
			});
			$('.excel_down').click(function () {
				downloadList('xlsx');
				hideSelect();
			});
			$('.html_down').click(function () {
				downloadList('html');
				hideSelect();
			});

			$(document).on('click', '.downAllFile', function(){
				var downloadFlag = false;
				$('.downloadIcon').each ( function ( i, item ) {
					var attachHash = $(this).parents('li').attr('attachhash');
                    console.log(attachHash);
                    if (attachHash == "null"){
                        alert('<s:message code="message.message.notfound.attach"/>');
                        return;
                    }
					if( attachHash != '' ){
						downloadFlag = true;
					}
				});

				if( !downloadFlag){
					alert('<s:message code="message.message.notfound.attach"/>');
					return;
				}

				var msgIds=[];
				$('.downloadIcon').each ( function ( i, item ) {
					var msgId = $(this).parents('li').attr('msgid');

                    if(!msgIds.includes(msgId)){ msgIds.push(msgId);}
				});

				var attachUrl = '<c:url value="/downEmassAttachByMsgId.xcn"/>?msgIds='+msgIds.join(',');
				try {
					AttachDown.location.href = attachUrl;
				} catch (e) {
					AttachDown.src = attachUrl;
				}
			});


			$(document).on('click', '.downloadIcon', function(){
                var msgId = $(this).parents('li').attr('msgid');
                var attachHash = $(this).parents('li').attr('attachhash');
                var attachId = $(this).parents('li').attr('id');
                var attachSize = Number($(this).parents('li').attr('attachsize'));
                if (attachHash == "null" ) {
                    alert('<s:message code="message.message.notfound.attach"/>');
                    return;
                }
              var attachUrl = '<c:url value="/getEmassAttachInfo4DownHash.xcn"/>?msgIds=' + msgId + '&attachHash=' + attachHash;
               //  var attachUrl = contextRoot + '/downEmassAttach.xcn?msgId='+msgId+'&attachId='+attachId;


				if ( attachSize == 0 || attachSize == 'NaN' ) attachSize = 1;

				try {
					AttachDown.location.href = attachUrl;
				} catch (e) {
					AttachDown.src = attachUrl;
				}
			});

            $(document).on('mouseover', '#deptSelectedArea', function (e) {
                $('#selectedCodeTitle').show();
                $('#selectedCodeTitle').css('left', (e.pageX + 5) + 'px');
                $('#selectedCodeTitle').css('top', (e.pageY - 150) + 'px');

                var str = $(this).parent().find('.selectedTitle').val();
                if (str != undefined) str = str.replaceAll('\\|', ',');
                $('#selectedCodeTitle').html(str);
            });

            $(document).on('mousemove', '#deptSelectedArea', function (e) {
                $('#selectedCodeTitle').css('left', (e.pageX + 5) + 'px');
                $('#selectedCodeTitle').css('top', (e.pageY - 120) + 'px');

                var str = $(this).parent().find('.selectedTitle').val();
                if (str != undefined) str = str.replaceAll('\\|', ',');
                $('#selectedCodeTitle').html(str);
            });

            $(document).on('mouseout', '#deptSelectedArea', function (e) {
                $('#selectedCodeTitle').hide();
            });

            $(document).on('mouseover', '#userSelectedArea', function (e) {
                $('#selectedCodeTitle2').show();
                $('#selectedCodeTitle2').css('left', (e.pageX + 5) + 'px');
                $('#selectedCodeTitle2').css('top', (e.pageY - 150) + 'px');

                var str = $(this).parent().find('.selectedTitle').val();
                if (str != undefined) str = str.replaceAll('\\|', ',');
                $('#selectedCodeTitle2').html(str);
            });

            $(document).on('mousemove', '#userSelectedArea', function (e) {
                $('#selectedCodeTitle2').css('left', (e.pageX + 5) + 'px');
                $('#selectedCodeTitle2').css('top', (e.pageY - 150) + 'px');

                var str = $(this).parent().find('.selectedTitle').val();
                if (str != undefined) str = str.replaceAll('\\|', ',');
                $('#selectedCodeTitle2').html(str);
            });

            $(document).on('mouseout', '#userSelectedArea', function (e) {
                $('#selectedCodeTitle2').hide();
            });

            $(document).on('click', '#userSelectedArea', function (e) {
                $('#userVal, #userStr, #userDept, #userJib').val('');
                $('#userSelectedArea').hide();
            });

			$(document).on('click', '.codeSelectedBtn', function (e) {
				$('#deptVal, #deptStr').val('');
				$('#deptSelectedArea').hide();
			});

	/*		$(document).on('click', '.me', function (e) {

				var userkey = $(this).parent().attr('userkey');
				var srcip = $(this).parent().attr('srcip');
				var id = $(this).parent().attr('id');
				updateEmassGenerativeAdminUserid(userkey, id, srcip,"F");

				moveTargetHeight(id, false);
			});*/


            $(document).on('click', '.imgPreviewDiv', function(){
                fullSize(this);
            });



            $(document).on('click', '.person', function () {

				if ((isConsent() && $('#consentNo').val() == '') || $(this).attr('userkey') == '') {
					return;
				}
				//if($(this).hasClass('active')) return;
				$('.person').each(function () {
					$(this).removeClass('active');
				});

				$(this).addClass('active');
				$('#userkey').text($(this).attr('userkey'));

				$('#srcip').text($(this).attr('srcip'));
				$('#msgid').text($(this).attr('msgid'));
				$('#usrid').text($(this).attr('usrid'));

				$('#selectUserInfo').attr('data-name', '');
				$('#selectUserInfo').attr('data-srcip', '');
				$('#selectUserInfo').attr('data-usrid', '');
				$('#selectUserInfo').html('');
				$('#searchMsgStrInput').val('');
				$('#startSubDt').val($('#startDt').val());
				$('#endSubDt').val($('#endDt').val());
				focusMsgId = '';
				/*eikon2.getGenerativeDetailList($(this).attr('userkey'), $(this).attr('msgid'), $(this).attr('srcip'), $(this).attr('usrid'));*/
			});

			$('input[name="searchType"]:radio').change(function () {
				eikon2.getCollectionList(1);
			});

			$('#groupFileCnt').click(function () {
				fileInfoViewer($('#userkey').text(), $('#srcip').text(), $('#usr_id').text());
			});

			$('#groupParticipant').click(function () {
				participantInfoViewer($('#userkey').text(), $('#usr_id').text());
			});

			$(document).on('click', '.person', function () {
				var msgid = $(this).attr('msgid');

				getFileDetailMessage(msgid);
				hideUserSelect();
			});

			initCondition();
			eikon2.init();
// 	$('#searchBtn').click();

		});

        function getPatnName() {
            return patnName;
        }

        function openCodeWindow(id, oldCode, oldConm,oldDept,oldJib) {
            $('#oldCode').val(oldCode);
            $('#oldConm').val(oldConm);
            $('#oldDept').val(oldDept);
            $('#oldJib').val(oldJib);
			var url = '<c:url value="/commons/selectCode.do?codeType='+id+'"/>';
			var pop = fnOpenWindow('', 'selectCodeWinPopup', 1200, 700, 'resize');

			$('#codeParam').attr('target', 'selectCodeWinPopup');
			$('#codeParam').attr('action', url);
			$('#codeParam').attr('method', 'post');
			$('#codeParam').submit();
		}

		function openSelectUserDiv() {
			var status = $('#userCntArea').hasClass('clicked');
			if (status) {
				hideUserSelect();
			} else {
				showUserSelect();
			}
		}

		function hideUserSelect() {
			if ($('#selectUser_menu')) {
				$('#selectUser_menu').hide();
				$('#userCntArea').removeClass('clicked');
			}
			$(document).unbind("mousedown", onBodyMouseDownPeriodUser);
		}

		function showUserSelect() {
			$('#selectUser_menu').show();
			$('#userCntArea').addClass('clicked');
			$(document).bind("mousedown", onBodyMouseDownPeriodUser);
		}

		function onBodyMouseDownPeriodUser(event) {
			if (!(event.target.id == "selectUser_menu" || $(event.target).parents("#selectUser_menu").length > 0)) {
				hideUserSelect();
			}
		}

		function openSelectDiv() {
			var status = $('#listCntArea').hasClass('clicked');
			if (status) {
				hideSelect();
			} else {
				showSelect();
			}
		}

		function hideSelect() {
			if ($('#export_menu')) {
				$('#export_menu').hide();
				$('#listCntArea').removeClass('clicked');
			}
			$(document).unbind("mousedown", onBodyMouseDownPeriod);
		}

		function showSelect() {
			$('#export_menu').show();
			$('#listCntArea').addClass('clicked');
			$(document).bind("mousedown", onBodyMouseDownPeriod);
		}

		function onBodyMouseDownPeriod(event) {
			if (!(event.target.id == "export_menu" || $(event.target).parents("#export_menu").length > 0)) {
				hideSelect();
			}
		}


		function downloadList(export_type) {

			var userkey = $('#selectUserInfo').attr('data-name');
			var srcip = $('#selectUserInfo').attr('data-srcip');

			if (userkey == '') return;
			var startDt = $('#startSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '')+"000000";
			var endDt = $('#endSubDt').val().replaceAll("-", "").replaceAll(":", "").replace(/ /gi, '')+"235959";
			var searchStr = '';

			eikon2.getCollectionGroupTextExport('<c:url value="/getCollectionrGroupTextExport.xcn"/>?userkey=' + userkey + '&srcip=' + srcip + '&startDt=' + startDt + '&endDt=' + endDt + '&searchStr=' + searchStr + '&export_type=' + export_type + '&groupField=sender_str&limit=1000&type=F', userkey);
		}


		function searchConsentNo() {
			var url = '<c:url value="/ems/selectConsent.do"/>';
			return fnOpenWindow(url, 'selectConsentWinPopup', 830, 700, 'resize');
		}

		function selectedConsent(obj) {
			if (obj == '') {
				$('#consentNo').val('');
				$('#consentName').text('');
				/* $('#consentIp').val('');
                $('#consentEmail').val(''); */
				$('#consentUserId').val('');
				$('#consentBtn').removeClass('active');
			} else {
				$('#consentNo').val(obj.no);
				$('#consentName').text(obj.name + "[" + obj.userkey + ", " + (obj.deptNm == '' ? '<s:message code="consent.select.consentDept"/>' : obj.deptNm) + "]");
				/* $('#consentIp').val(obj.userIp);
                $('#consentEmail').val(obj.userEmail); */
				$('#consentUserId').val(obj.userkey);
				$('#consentBtn').addClass('active');
			}
		}

		function initCondition() {

			getFileServiceList();
			getCodeList('busi');
			getCodeList('dept');

			var dateObj = new Date();


			$('#easyDate').change(function () {
				changeDate($(this).val());
			});
			$('#timedatepicker').datetimepicker({
				format: 'YYYY-MM-DD',
				locale: 'ko',
				defaultDate: moment(new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59))
			}).on("dp.change", function (e) {
				var date = $(this).data("DateTimePicker").date().format('YYYY-MM-DD');
				detailDateFocus(date);

				$('#searchMsgStrInput').val('');
				$('#searchResult').html('');
				$('#searchResultArea').hide();
				$('#searchResultBtnArea').hide();
			});

			$('#serviceTypeSelect').selectpicker({
				size: 15,
				width: '300px',
				noneSelectedText: condition.serviceAll,
				noneResultsText: condition.msgNoresult + ' ',
				selectAllText: condition.msgSelect_all,
				deselectAllText: condition.msgUnselect_all,
				liveSearchPlaceholder: condition.searchService
			});

			$('#busiSelect').selectpicker({
				size: 15,
				width: '300px',
				searchLabel: true,
				noneSelectedText: '<s:message code="common.org.busi.all"/>',
				noneResultsText: '<s:message code="common.msg.noresult"/>' + ' ',
				selectAllText: '<s:message code="common.msg.select_all"/>',
				deselectAllText: '<s:message code="common.msg.unselect_all"/>'
			});

			$('#searchField').selectpicker({
				width: '100px',
				noneSelectedText: '<s:message code="common.msg.all"/>'
			});

		}

		function getCodeList(codeType) {
			ui.get({
				url: 'getCodeList.xcn',
				codeType: codeType,
				success: function (data, total) {
					$('#' + codeType + 'Select').html(getSelectOption(data));
					$('#' + codeType + 'Select').selectpicker('refresh');
					$('#' + codeType + 'SelectPop').html(getSelectOption(data));
					$('#' + codeType + 'SelectPop').selectpicker('refresh');
				},
				error: function (status, message) {
					ui.alertMsg('error:' + status);
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


		function getCondition() {
			var filterVal = {};

			if (isConsent()) {
				filterVal.consentNo = $('#consentNo').val();
				filterVal.consentName = $('#consentName').text();
				//filterVal.consentIp = $('#consentIp').val();
				//filterVal.consentEmail = $('#consentEmail').val();
				filterVal.consentUserId = $('#consentUserId').val();
			}

			var conArray = [];
			conArray.push(createCondition());
			filterVal.conditions = conArray;

			//console.log(JSON.stringify(filterVal))
			return filterVal;
		}

		function createCondition() {
			var allSelect = new Array();
			var condition = {};
			if ($('#serviceTypeSelect').selectpicker('val') == null) {
				$('#serviceTypeSelect option').each(function () {
					if ($(this).val() != '' && $(this).val() != null) allSelect.push($(this).val());
				});
				condition.serviceType = arrayToString(allSelect);
			} else {
				condition.serviceType = arrayToString($('#serviceTypeSelect').selectpicker('val'));
			}
			condition.searchStr = $('#searchStrInput').val();
			condition.senders = $('#senders').val();
			condition.busi = arrayToString($('#busiSelect').selectpicker('val'));

			if (condition.busi != '') condition.busiStr = $('#busiSelect').parent().find('.filter-option').text();
			else condition.busiStr = '';

			var dv = $('#deptVal').val().split('|');
			condition.dept = dv.join(',');
			if (condition.dept != '') condition.deptStr = $('#deptStr').val();
			else condition.deptStr = '';
			/* condition.dept = arrayToString($('#deptSelect').selectpicker('val'));
            if(condition.dept != '') condition.deptStr = $('#deptSelect').parent().find('.filter-option').text();
            else condition.deptStr = ''; */

			condition.period = 1;
			condition.startDt =$('#startDt').val()+"000000";
			condition.endDt =$('#endDt').val()+"235959";

			return condition;
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

		function getMessengerList() {
			ui.get({
				url: 'getMessengerList.xcn',
				asyncFlag: false,
				success: function (data, total) {
					messengerListCnt = data.length;
					if (data.length > 0) {
						$('#serviceTypeSelect').html(getSelectOptionMessenger(data));
					}
				},
				error: function (status, message) {
					ui.alertMsg('error:' + status);
				},
				complete: function () {
					searchFlag = false;
				}
			});
		}

		function getSelectOptionMessenger(data) {
			//var str = '<option value="">- <s:message code="eikon.msg.svcType"/> -</option>';
			var str = '';
			for (var i = 0; i < data.length; i++) {
				str += '<option value="' + data[i].code + '">' + data[i].codeName + '</option>';
			}
			return str;
		}

        function allDown(){
            if ((isConsent() && $('#consentNo').val() == '') || $(this).attr('userkey') == '') {
                return;
            }
            var element = document.getElementById('groupResultCnt');
            var number = parseInt(element.textContent, 10);
            if (number === 0) {
                ui.alertMsg('<s:message code="eikon.noList"/>');
                return;
            }

            var filterVal = {};
            var conArray = [];
            conArray.push(currentSchVal);
            filterVal.conditions = conArray;

            ui.alertMsg('<s:message code="eikon.start.download"/>');
            ui.get({
                url : 'getFileAllExportZip.xcn',
                data : JSON.stringify(filterVal),
                exportStartDt : currentSchVal.startDt,
                exportEndDt : currentSchVal.endDt,
                success : function(data, total) {
                },
                error : function(status, message) {
                },
                complete : function() {
                }
            });
        }
        function allDownList(){
            var url    = '<c:url value="/commons/downListMessenger.do"/>';
            fnOpenWindow(url, 'downInfoPop', 1400, 580, 'resize');
        }


        function initDateTimePicker(sid,eid){
            $('#'+sid).datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
	            showClose: true,
	            showTodayButton: true,
                defaultDate: moment().subtract(7, 'days')
            });
            $('#'+eid).datetimepicker({
                format: 'YYYY-MM-DD',
                locale: 'ko',
	            showClose: true,
	            showTodayButton: true,
                defaultDate: moment(new Date())
            });
        }
        function getSelectedCodeData(codeType, data) {
            var str = '';
            var val = '';
            var dept = '';
            var jib = '';

            for (var i = 0; i < data.length; i++) {
                str += data[i].codeName;
                val += data[i].code;

                dept += (data[i].tempNm1 !== undefined) ? data[i].tempNm1 : "";

                jib += (data[i].tempNm2 !== undefined) ? data[i].tempNm2 : "";

                if (i != data.length - 1) {
                    str += ', ';
                    val += '|';
                    dept += '|';
                    jib += '|';
                }
            }
            if (val != '') {
                str = str.rtrim();
                val = val.trimAll();
                dept = dept.trimAll();
                jib = jib.trimAll();
            }

            $('#' + codeType + 'Str').val(str);
            $('#' + codeType + 'Val').val(val);
            $('#' + codeType + 'Dept').val(dept);
            $('#' + codeType + 'Jib').val(jib);

            if ($('#' + codeType + 'Str').val() != '') {
                $('#' + codeType + 'SelectedArea').find('.btn').text(data.length);
                $('#' + codeType + 'SelectedArea').show();
            } else {
                $('#' + codeType + 'SelectedArea').find('.btn').text(0);
                $('#' + codeType + 'SelectedArea').hide();
            }
        }



        function resetCode(codeType) {
            if (codeType == 'deptByCo') $('#deptByCoStrSpan').html('');
            $('#' + codeType + 'Val').val('');
            $('#' + codeType + 'Str').val('');
            $('#' + codeType + 'Dept').val('');
            $('#' + codeType + 'Jib').val('');
            $('#' + codeType + 'SelectedArea').hide();
        }

        function fullSize( obj )
        {
            var imgUrl = $(obj).attr('url');
            var fileName = $(obj).attr('filename');

            console.log(obj);

            console.log(imgUrl);
            console.log(fileName);

            var url = contextRoot + '/ems/imgFullsize.do';

            var winObj = fnOpenWindow('about:blank', "fullSize", 700, 500, "resize" );

            document.imageForm.imgUrl.value = imgUrl;
            document.imageForm.fileName.value = fileName;
            document.imageForm.target = "fullSize";
            document.imageForm.action = url;
            document.imageForm.submit();
            winObj.focus();
        }

        /**
         * 이미지 미리보기 이벤트 발생
         */
        function filePreviewEv( obj )
        {
            var $liParent = $(obj).parents('li');
            var $imgPreviewDiv = $liParent.find('.imgPreviewDiv');
            if ($imgPreviewDiv.length > 0) {
                var fileName = $(obj).attr('attachname');
                var str_loc = fileName.lastIndexOf(".");
                var fileExt = fileName.substring(str_loc + 1);
                fileExt = fileExt.toLowerCase();

                if (fileExt == "jpg" || fileExt == "jpeg" || fileExt == "gif" || fileExt == "png" || fileExt == "bmp") {
                    var msgId = $liParent.attr('msgid');
                    var attachId = $liParent.attr('id');
                    var url = contextRoot + '/downEmassAttach.xcn?msgId=' + msgId + '&attachId=' + attachId;
                    var u = '<c:url value="/img/loading/Loading.gif"/>';
                    var n = '<c:url value="/img/noneImage.png"/>';
                    var urlStr = "<div id='noneImage' style='width: 200px; height: 200px; padding-left:0px;padding-top:50px;text-align:center;'><img src='" + u + "'/></div>";
                    urlStr += "<a href='javascript:void(0)'><img border='0' id='realImage' style='display:none;' width='200px;' height='200px;' src='" + url + "' onerror=\"this.src='" + n + "';\" onload=\"noneImage.style.display='none';this.style.display=''\" /></a>";
                    urlStr += '<div id="fullSizeOverlay" style="display:none; position: absolute; top: 0px; left: 0px; right: 0px; bottom: 0px; background-color: #000; opacity: .7; cursor: pointer;"><div style="background-color: #fff; display: inline-block; opacity: 1 !important; padding: 1px; position: relative; top: 95px; left: 30px;"><s:message code="message.msg.img.big"/></div></div>';

                    $imgPreviewDiv.html(urlStr);
                    $imgPreviewDiv.attr('url', url);
                    $imgPreviewDiv.attr('fileName', fileName);

                    var left = $(obj).offset().left;
                    if ($(obj).offset().left + $imgPreviewDiv.width() > $(window).width()) {
                        left -= $imgPreviewDiv.width() - 20;
                    }
                    $imgPreviewDiv.css('top', $(obj).offset().top + 15);
                    $imgPreviewDiv.css('left', left + 40);
                    setTimeout(function () {
                        $imgPreviewDiv.fadeIn();
                    }, 100);
                }
            }
        }
	</script>
</head>
<div id="searchArea">
	<div class="inner_messenger">
		<%--			검색 영역--%>
		<div class="leftSearch p20" id="xcn_Search">
			<div class="leftSearchTab">
				<button class="active" onclick="openCity('Tab01')"><s:message code="DATA_MONITOR.FILETRANSFER_SERVICE"/></button>

				<!--<button onclick="openCity('Tab02')">탭 비활성</button>-->
			</div>
			<div id="Tab01">
				<div>
					<h3 class="mat16"><s:message code="message.msg.default.search"/></h3>
					<%if (consent && Common.isEquals(firstAdminYn, "N") && Common.isNotEquals(adminType, "C")) { %>
					<div class="form-group form-inline not-dashed" style="padding-left: 10px; width: 100%; margin-bottom: 3px;">
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="consentBtn" onclick="searchConsentNo();"><span
								class="glyphicon glyphicon-tags"></span>&nbsp;<s:message code="consent.select.consent"/></button>
						<input type="text" style="width:120px;height:28px;display:none;" readonly="readonly" id="consentNo">
						<input type="hidden" readonly="readonly" id="consentIp">
						<input type="hidden" readonly="readonly" id="consentEmail">
						<input type="hidden" readonly="readonly" id="consentUserId">
						<span id="consentName" style="font-weight: bold;"></span>
					</div>
					<%} %>
					<div>
						<select class="w100" id="serviceTypeSelect" data-style="btn-default" multiple data-show-subtext="true"
						        data-actions-box="true">
						</select>
						<input class="w100 mat8" type="text" id="searchStrInput" placeholder="<s:message code="common.msg.searchMsg"/>">
					</div>
					<h3 class="mat16"><s:message code="message.msg.deepsearch"/></h3>
					<div>

						<input class="w45 mat8 txt_center" type="text" id="startDt" ><span class="w10 dis_inlineblock txt_center">~</span><input class="w45 txt_center" type="text" id="endDt" >


						<select id="busiSelect" class="w100 mat8" data-style="btn-default btn-sm" multiple data-show-subtext="true"
						        data-live-search="true" data-actions-box="true"></select>

						<p class="mat8 formText btnform" data-toggle="buttons">
							<span class="tit"><s:message code="common.org.dept"/></span>
							<button type="button" class="btn01" id="dept"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
									code="common.org.choose.dept"/></button>
							<span id="deptSelectedArea" class="codeSelectedBtn">
										<button type="button" class="btn num_add bornone"  style="z-index: 2;">0</button>
									</span>
							<input type="hidden" id="deptStr" class="selectedTitle">
							<input type="hidden" id="deptVal">
						</p>
						<div id="selectedCodeTitle" class="infotxt"></div>

						<p class="mat8 formText btnform" data-toggle="buttons">
							<span class="tit"><s:message code="common.org.user"/></span>

							<button class="btn01" id="user"><img src="<c:url value="/img/subBtn_plus.png"/>"><s:message
									code="common.org.choose.user"/></button>
							<span id="userSelectedArea" class="codeSelectedBtn2">
										<button type="button" class="btn num_add bornone"  style="z-index: 2;">0</button>
									</span>
							<input type="hidden" id="userStr" class="selectedTitle">
							<input type="hidden" id="userVal">
							<input type="hidden" id="userDept">
							<input type="hidden" id="userJib">
						</p>
						<div id="selectedCodeTitle2" class="infotxt"></div>
					</div>
				</div>

				<div class="fixBtn">
					<div class="xcn_checkbox">
						<input type="checkbox" name="readYn" id="readYn"><label><s:message code="eikon.msg.notRead"/></label>
					</div>
					<button class="fullbtn" type="button" accesskey="Q" id="searchBtn"><s:message code="common.msg.search"/></button>
				</div>
			</div>
		</div>
		<%--			검색 끝!--%>

		<%--			검색 결과 영역--%>
		<div class="messengerList" >
			<div class="messengerBox" style="height: 90% !important;">
				<div class="subTit p12">
					<h2 class="ma_none pb4">
						<button id="xcn_toggleBtn" class="menu"></button><s:message code="DATA_MONITOR.FILETRANSFER_SERVICE"/>
					</h2>
				</div>
				<div class="bortop_dd pt16 pl20 pr20">
				</div>
				<div style="height: 100%">
					<div class="list-group" id="group_list" style="margin-bottom: 0px; height: 85%!important; overflow: scroll">
						<a href="#" class="list-group-item list-group-item-action active" style="cursor:default; padding:40px; margin:0 20px;">
							<p class="list-group-item-text" style="line-height:30px; text-align: center">
								<img src="<c:url value="/img/icon/img_nodata02.png"/>" width="72" height="72">
							</p>
							<p style="text-align: center">
								<s:message code="eikon.msg.select.condition"/>
							</p>
						</a>
					</div>
				</div>
			</div>

			<!-- pagination -->
			<div class="pl20 pr20">
				<div class="pageArea bornone" id="groupPage">
					<div class="total fb600">
					</div>
				</div>
				<s:message code="common.msg.finish_query"/> : <span id="groupResultCnt" class="red fb600">0</span>
				<div class="myDropdown mal16" style="color: black">
					<span><s:message code="analysis.relation.ui.export"/></span>
					<div class="dropdown-content" style="bottom:20px;     min-width: 203px !important;">
						<a href="#" onclick="allDown()"><s:message code="analysis.relation.ui.export2"/></a>
						<a href="#" onclick="allDownList()"><s:message code="common.msg.download"/> <s:message code="mail.view.list"/></a>
					</div>
				</div>
			</div>
			<!-- //pagination -->
		</div>

		<!-- 대화방 끝!! -->
		<!-- 상세보기 -->
		<div class="fileGroupList">
			<div class="inner_message">

				<div class="messageBtn">
					<div class="btnform">
				<%--		<button class="btn01"><img src="<c:url value="/img/subBtn_arrow_left_12.png"/>" alt=""></button>
						<button class="btn01"><img src="<c:url value="/img/subBtn_arrow_right_12.png"/>" alt=""></button>--%>
						<button class="btn05" id="saveBtn"><img src="<c:url value="/img/subBtn_save.png"/>" alt="저장"><s:message code="common.msg.save"/></button>
						<button class="btn05" id="printBtn"><img src="<c:url value="/img/subBtn_mail.png"/>" alt="인쇄"><s:message code="common.msg.print"/></button>
					</div>
				</div>
			</div>
			<div class="inner_fileList pl16 pr16">
			</div>

		</div>
		<!-- //상세보기 -->


	</div>
</div>

<iframe id="AttachDown" src="about:blank;" height="0" width="0" style="display: none;"></iframe>
<!-- Back to top -->
<a href="#0" class="back-to-top cd-top"><span class="[ fa fa-chevron-up ]"></span> <span class="[ ]">Back to the Top</span></a>

<form method="post" id="codeParam">
	<input type="hidden" name="oldCode" id="oldCode"></input>
	<input type="hidden" name="oldConm" id="oldConm"></input>
	<input type="hidden" name="oldDept" id="oldDept"></input>
	<input type="hidden" name="oldJib" id="oldJib"></input>
</form>

<form name="imageForm" method="post" target="">
	<input type="hidden" name="imgUrl">
	<input type="hidden" name="fileName">
</form>
