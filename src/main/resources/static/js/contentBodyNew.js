var msgId = '';
var svc = '';
var searchkey = '';
var xRootMtr = '';
var xmsgKey = '';
var srcip = '';
var dstip = '';
var usrip = '';
var usr_id = '';
var userInfoFlag = false;
var bodySize_str = '';
var fontZoom = 3;
var detailFlag = false;
var moveY = 0;
var moveX = 0;
var keywordHighlight = 'true';
var hostQuery = 'false';
var count = 0;
let patnName = '';
let patternKyword = [];
let piHighlightList = [
    'SN', 'CN', 'DN', 'FN','PN','MN','AN','CRN','SSN','IMEI','BRN','CPN','MCN'
];
const originalBodyFontSize = 13;

$(document).ready(function () {

    $(document).click(function () {
        $('#imgPreviewDiv').hide();
    });

    $('.font_size').click(function () {
        var more = $(this).attr('id');
        var fontSize = parseInt($('#emassBody').css("font-size"));
        if (more == 'small_txt') fontSize -= fontZoom;
        else {
            if (fontSize > 24) fontSize = 13;
            else fontSize += fontZoom;
        }
        $('#emassBody').css({'font-size': fontSize + 'px'});

        $('#emassBody *').each(function () {
            var fontSize = parseInt($(this).css("font-size"));
            if (more == 'small_txt') fontSize -= fontZoom;
            else fontSize += fontZoom;
            $(this).css({'font-size': fontSize + 'px'});
        });
    });
    //ui.onBody( 'content_body', 0, 0);
    //getBody('');
    document.onclick = function (e) {
        parent.$('.dropdown-backdrop').click();
    }
    document.onkeydown = function (e) {
        if (e.keyCode == 37) {
            if ($('#urlPop').css('display') == 'none') $('#prevBtn').click();
        } else if (e.keyCode == 39) {
            if ($('#urlPop').css('display') == 'none') $('#nextBtn').click();
        } else if (e.keyCode == 65 && e.ctrlKey) {
            if ($('#emassBody').length > 0) selectAllBodyText('emassBody');
            e.preventDefault();
        }
        /*switch (e.keyCode) {
			case 37:
				//alert('left');
				break;
			case 38:
				//alert('up');
				$('#prevBtn').click();
				break;
			case 39:
				//alert('right');
				break;
			case 40:
				//alert('down');
				$('#nextBtn').click();
				break;
		}
		return false;*/
    };
    $(document).on('click', '#copyBodyBtn', function () {
        selectAllBodyText('emassBody');
        document.execCommand('copy');
        window.getSelection().removeAllRanges();
        alert(message.copyBodyMsg);
    });

    $(document).on('click', '#usersInfoBtn', function () {
        var url = '';

//		if( isGroupMessenger( ) && detailFlag ){
//			//url = '<c:url value="/ems/userGroupInfoPop.do?xRootMtr='+xRootMtr+'"/>';
//			url = contextRoot + '/ems/userGroupInfoPop.do?xRootMtr=' + xRootMtr;
//			return fnOpenWindow(url, 'userGroupInfoPop', 835, 370, 'resize');
//		}else{
        //url = '<c:url value="/ems/userInfoPop.do?msgId='+msgId+'&type="/>';
        url = contextRoot + '/ems/userInfoPop.do?msgId=' + msgId + '&type=""'
        return fnOpenWindow(url, 'userInfoPop', 835, 370, 'resize');
        //}

    });
    $(document).on('click', '.attachText', function () {
        var attachId = $(this).parents('tr').attr('id');
        //var url = '<c:url value="/ems/attachText.do?msgId='+msgId+'&attachId='+attachId+'&searchKey='+searchkey+'"/>';
        var url = contextRoot + '/ems/attachText.do?msgId=' + msgId + '&attachId=' + attachId + '&searchKey=' + encodeURI(searchkey);
        fnOpenWindow(url, 'attachText', 1050, 800, 'resize');
    });

    $(document).on('click', '.attachOcrText', function () {
        var attachId = $(this).parents('tr').attr('id');
        //var url = '<c:url value="/ems/attachText.do?msgId='+msgId+'&attachId='+attachId+'&searchKey='+searchkey+'&ocrYn=Y"/>';
        var url = contextRoot + '/ems/attachText.do?msgId=' + msgId + '&attachId=' + attachId + '&searchKey=' + encodeURI(searchkey) + '&ocrYn=Y';
        fnOpenWindow(url, 'attachText', 1050, 800, 'resize');
    });

    $(document).on('click', '#originalBtn', function () {
        //var url = '<c:url value="/ems/originalText.do?type=original&msgId='+msgId+'"/>';
        var url = contextRoot + '/ems/originalText.do?type=original&msgId=' + msgId;
        fnOpenWindow(url, 'originalText', 1050, 800, 'resize');
    });

    $(document).on('click', '#msgIdBtn', function () {
        if ($("#msgIdTr").css("display") == "none") {
            $("#msgIdTr").css("display", "");
        } else {
            $("#msgIdTr").css("display", "none");
        }
    });

    var dateObj = new Date();
    $('#startdatepickerBody').datetimepicker({
        format: 'YYYY-MM-DD',
        locale: 'ko',
        sideBySide: true,
        defaultDate: moment(new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate() - 7))
    });
    $('#enddatepickerBody').datetimepicker({
        format: 'YYYY-MM-DD',
        locale: 'ko',
        sideBySide: true,
        defaultDate: moment(new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()))
    });

    $(document).on('click', '#headerBtn', function () {
        //var url = '<c:url value="/ems/originalText.do?type=header&msgId='+msgId+'"/>';
        var url = contextRoot + '/ems/originalText.do?type=header&msgId=' + msgId;
        fnOpenWindow(url, 'headerText', 1050, 800, 'resize');
    });

    $(document).on('mouseover', '.attachName', function () {
        filePreviewEv(this);
    });

    $(document).on('mouseover', '#imgPreviewDiv, #fullSizeOverlay', function () {
        $('#fullSizeOverlay').show();
    });

    $(document).on('mouseout', '#fullSizeOverlay', function () {
        $('#fullSizeOverlay').hide();
    });

    $(document).on('click', '#imgPreviewDiv', function () {
        fullSize(this);
    });

    /*$(document).on('mouseout', '.attachName', function(e){
		$('#imgPreviewDiv').hide();
	});*/

    $(document).on('click', '.attachName', function () {
        if ((adminMenu != "ALL" && adminMenu.indexOf("AS") < 0 && adminMenu.indexOf("CS") < 0) || (adminMenu != "ALL" && adminMenu.indexOf("DS") < 0)) {
            alert(message.authAlert);
            return;
        }
        if ($(this).parents('tr').hasClass('notfound')) return;

        var attachId = $(this).parents('tr').attr('id');
        var attachName = $(this).attr('attachname');
        var attachSize = Number($(this).parents('tr').attr('size'));
        //var attachUrl = '<c:url value="/downEmassAttach.xcn"/>?msgId='+msgId+'&attachId='+attachId;
        var attachUrl = contextRoot + '/downEmassAttach.xcn?msgId=' + msgId + '&attachId=' + attachId;
        if (attachSize == 0 || attachSize == 'NaN') attachSize = 1;

        try {
            AttachDown.location.href = attachUrl;
        } catch (e) {
            AttachDown.src = attachUrl;
        }

        var information = '[' + message.attachSave + '-' + message.fileName + ']' + enter;
        information += message.msgid + ' : ' + msgId + enter;
        information += message.fileName + ' : ' + attachName + enter
        insertAudit(op_attach_save, information);
    });

    $(document).on('click', '.attachExt', function () {

        if ((adminMenu != "ALL" && adminMenu.indexOf("AS") < 0 && adminMenu.indexOf("CS") < 0) || (adminMenu != "ALL" && adminMenu.indexOf("DS") < 0)) {
            alert(message.authAlert);
            return;
        }
        if ($(this).parents('tr').hasClass('notfound')) return;
        var txt = $(this).text();
        var attachId = $(this).parents('tr').attr('id');
        var attachName = $(this).parents('tr').find('.attachName').attr('attachname');
        var attachSize = Number($(this).parents('tr').attr('size'));
        //var attachUrl = '<c:url value="/downEmassAttach.xcn"/>?msgId='+msgId+'&attachId='+attachId+'&prediction=Y';
        var attachUrl = contextRoot + '/downEmassAttach.xcn?msgId=' + msgId + '&attachId=' + attachId + '&prediction=Y';
        if (attachSize == 0 || attachSize == 'NaN') attachSize = 1;
        if (txt != '' && txt != 'unknown') attachName += '.' + txt;

        try {
            AttachDown.location.href = attachUrl;
        } catch (e) {
            AttachDown.src = attachUrl;
        }

        var information = '[' + message.attachSave + '-' + message.pre_ext + ']' + enter;
        information += message.msgid + ' : ' + msgId + enter;
        information += message.fileName + ' : ' + attachName + enter
        insertAudit(op_attach_save, information);
    });

    $(document).on('click', '.downloadIcon', function () {

        if ((adminMenu != "ALL" && adminMenu.indexOf("AS") < 0 && adminMenu.indexOf("CS") < 0) || (adminMenu != "ALL" && adminMenu.indexOf("DS") < 0)) {
            alert(message.authAlert);
            return;
        }
        if ($(this).parents('tr').hasClass('notfound')) return;

        var attachId = $(this).parents('tr').attr('id');
        var attachName = $(this).parents('tr').find('.attachName').attr('attachname');
        var attachSize = Number($(this).parents('tr').attr('size'));
        //var attachUrl = '<c:url value="/downEmassAttach.xcn"/>?msgId='+msgId+'&attachId='+attachId;
        var attachUrl = contextRoot + '/downEmassAttachOne.xcn?msgId=' + msgId + '&attachId=' + attachId;
        if (attachSize == 0 || attachSize == 'NaN') attachSize = 1;


        try {
            AttachDown.location.href = attachUrl;
        } catch (e) {
            AttachDown.src = attachUrl;
        }

        var information = '[' + message.attachSave + ']' + enter;
        information += message.msgid + ' : ' + msgId + enter;
        information += message.fileName + ' : ' + attachName + enter
        insertAudit(op_attach_save, information);
    });
    $('#saveAttachBtn').click(function (e) {

        if ((adminMenu != "ALL" && adminMenu.indexOf("AS") < 0 && adminMenu.indexOf("CS") < 0) || (adminMenu != "ALL" && adminMenu.indexOf("DS") < 0)) {
            alert(message.authAlert);
            return;
        }

        var fileCount = $(this).parent().parent().parent().find('#fileCntArea').text().replace(/[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi, '');
        var notfoundCount = '';
        $(this).parent().parent().parent().find('#fileTable tr.notfound').each(function (i, item) {
            notfoundCount = i;
        })
        if (fileCount == notfoundCount + 1) {
            alert(message.fileNotFound);
            e.stopPropagation();
            return;
        }
        var attachUrl = contextRoot + '/downEmassAttach.xcn?msgId=' + msgId;
        try {
            AttachDown.location.href = attachUrl;
        } catch (e) {
            AttachDown.src = attachUrl;
        }

        var information = '[' + message.attachSave + ']' + enter;
        information += message.msgid + ' : ' + msgId + enter;
        information += message.total_count + ' : ' + $('.downloadIcon').size() + enter;

        insertAudit(op_attach_save, information);

        e.stopPropagation();
    });

    $('[name=feedback]').change(function () {
        var val = $(this).val();
        updateEmsFeedback(val);
        if (opener) {
            opener.setGridFeedback(val);
        } else {
            parent.getIframeListObj().setGridFeedback(val);
        }

        $('#ml_confd_userid').html('[ ' + adminId + ' ]');
    });

    $('#bodyEncoding').change(function () {
        var charset = $(this).val();
        getBody(charset);
    });

    $('#closeBtn').click(function () {
        window.open("about:blank", "_self").close();
    });

    $('#nextBtn').click(function () {
        ui.onBody('content_body', 0, 0);

        if (opener) {
            if (!opener.nextMsg()) {
                alert(message.msgNomsg);
            }
        } else {
            parent.getIframeListObj().nextMsg();
        }
        ui.off();
    });
    $('#prevBtn').click(function () {
        ui.onBody('content_body', 0, 0);
        if (opener) {
            if (!opener.prevMsg()) {
                alert(message.msgNomsg);
            }
        } else {
            parent.getIframeListObj().prevMsg();
        }
        ui.off();
    });

    $('#openOriginal').click(function () {

        ui.get({
            url: 'getListByRootMtr.xcn',
            xrootmtr: xRootMtr,
            success: function (data, total) {
                if (data.length == 0) {
                    ui.alertMsg('원본 메시지가 존재하지 않습니다.');
                    return;
                }
                openMessageBodyPop('', data[0].msgid, '', data[0].body_size);
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
            }
        });
    });


    $('#openBigContent').click(function () {
        if (opener) {
            var grid = opener.grid;
            var row = grid.Row
            opener.viewer_newOpen(row, grid);
        } else {
            var grid = parent.getIframeListObj().grid;
            var row = grid.Row
            parent.getIframeListObj().viewer_newOpen(row, grid);
        }
    });
    $('#printBtn').click(function () {
        if (adminMenu != "ALL" && adminMenu.indexOf("DP") < 0) {
            alert(contentBodyDivJS.noAuthority);
            return;
        }
        var charset = $('#bodyEncoding').val();
        //var url = '<c:url value="/getEmassBodySave.xcn?msgId='+msgId+'&userCharset='+charset+'&print=Y"/>';
        //if( detailFlag ) url = '<c:url value="/getMessengerGroupAllSave.xcn?msgId='+msgId+'&xRootM
        // tr='+xRootMtr+'&print=Y"/>';
        var url = contextRoot + '/getEmassBodySave.xcn?msgId=' + msgId + '&userCharset=' + charset + '&print=Y';

        if (detailFlag) {
            var startDt = $('#startdatepickerBody').data("DateTimePicker").date().format('YYYYMMDD');
            var endDt = $('#enddatepickerBody').data("DateTimePicker").date().format('YYYYMMDD');

            url = contextRoot + '/getMessengerGroupAllSave.xcn?xRootMtr=' + xRootMtr + '&srcip=' + srcip + '&startDt=' + startDt + '&endDt=' + endDt + '&groupField=usr_id&print=Y&usr_id=' + usr_id;
        }


        fnOpenWindow(url, 'message_print', '1000', '800', 'scroll');


        var information = '[' + message.bodyPrint + ']' + enter;
        if (detailFlag) information += message.xrootmtr + ' : ' + xRootMtr + ' ';
        else information += message.msgid + ' : ' + msgId + ' ';
        insertAudit(op_body_print, information);
    });

    $('#saveBtn').click(function () {
        if (adminMenu != "ALL" && adminMenu.indexOf("DS") < 0) {
            alert(contentBodyDivJS.noAuthority);
            return;
        }

        var charset = $('#bodyEncoding').val();
        //var url = '<c:url value="/getEmassBodySave.xcn?msgId='+msgId+'&userCharset='+charset+'&print=N"/>';
        var url = contextRoot + '/getEmassBodySave.xcn?msgId=' + msgId + '&userCharset=' + charset + '&print=N';
        var fileName = msgId + '.html';
        var fileSize = 1;

        //if( detailFlag ) url = '<c:url value="/getMessengerGroupAllSave.xcn?msgId='+msgId+'&xRootMtr='+xRootMtr+'&srcip='+srcip+'"/>';
        if (detailFlag) {
            var startDt = $('#startdatepickerBody').data("DateTimePicker").date().format('YYYYMMDD');
            var endDt = $('#enddatepickerBody').data("DateTimePicker").date().format('YYYYMMDD');

            url = contextRoot + '/getMessengerGroupAllSave.xcn?msgId=' + msgId + '&xRootMtr=' + xRootMtr + '&srcip=' + srcip + '&startDt=' + startDt + '&endDt=' + endDt + '&groupField=usr_id&usr_id=' + usr_id;
        }

        try {
            AttachDown.location.href = url;
        } catch (e) {
            AttachDown.src = url;
        }

        var information = '[' + message.bodyView + ']' + enter;
        if (detailFlag) information += message.xrootmtr + ' : ' + xRootMtr + ' ';
        else information += message.msgid + ' : ' + msgId + ' ';
        insertAudit(op_body_save, information);
    });

    $('#mailFowardBtn').click(function () {
        if (adminMenu != "ALL" && adminMenu.indexOf("DF") < 0) {
            alert(contentBodyDivJS.noAuthority);
            return;
        }
        if (!mailUseFlag) {
            alert(message.msgNomail);
            return;
        }

        if (adminEmail == '') {
            alert(message.chk_account);
            return;
        }
        var charset = $('#bodyEncoding').val();
        /*
		$('.content .boxArea .content_box .content_body').contents( ).find('.appendClass').hide();
		var emassBodyStr = $('.content .boxArea .content_box .content_body')[0].innerHTML;
		$('#msgIdStr').val(msgId);
		$('#userCharsetStr').val(charset);
		$('#mailForwardStr').val(emassBodyStr);
		if( detailFlag ) $('#xRootMtrStr').val(xRootMtr);
		var url = '<c:url value="mailFoward.do"/>';
		var pop = fnOpenWindow('', 'message_forward', 1000, 800, 'scroll');
		$('#mailForwardForm').attr('target','message_forward');
		$('#mailForwardForm').attr('action', url);
		$('#mailForwardForm').attr('method','post');
		$('#mailForwardForm').submit();
		$('.content .boxArea .content_box .content_body').contents( ).find('.appendClass').show();
		 */
        //var url = '<c:url value="mailFoward.do?msgId='+msgId+'&userCharset='+charset+'"/>';
        //if( detailFlag ) url = '<c:url value="mailFoward.do?xRootMtr='+xRootMtr+'&userCharset='+charset+'"/>';
        var url = contextRoot + '/ems/mailFoward.do?msgId=' + msgId + '&userCharset=' + charset;
        if (detailFlag) url = contextRoot + '/ems/mailFoward.do?msgId=' + msgId + '&xRootMtr=' + xRootMtr + '&userCharset=' + charset;
       fnOpenWindow(url, 'message_forward', '1000', '800', 'scroll');
    });

    $('#warnMailBtn').click(function () {
        if (!mailUseFlag) {
            alert(message.msgNomail);
            return;
        }

        if (adminEmail == '') {
            alert(message.chk_account);
            return;
        }
        var charset = $('#bodyEncoding').val();
        //var url = '<c:url value="warningMail.do?msgId='+msgId+'&userCharset='+charset+'"/>';
        //if( detailFlag ) url = '<c:url value="warningMail.do?xRootMtr='+xRootMtr+'&userCharset='+charset+'"/>';
        var url = contextRoot + '/ems/warningMail.do?msgId=' + msgId + '&userCharset=' + charset;
        if (detailFlag) url = contextRoot + '/ems/warningMail.do?msgId=' + msgId + '&xRootMtr=' + xRootMtr + '&userCharset=' + charset;
        fnOpenWindow(url, 'message_warnmail', '700', '420', 'scroll');
    });

    $('#domainBtn').click(function () {
        var url = contextRoot + '/ems/domainInfo.do?msgId=' + msgId;
        if (detailFlag) url = contextRoot + '/ems/domainInfo.do?xRootMtr=' + xRootMtr + '&userCharset=' + charset;
        if ($('#toTr').css('display') != 'none' || $('#ccTr').css('display') != 'none' || $('#bccTr').css('display') != 'none') {
            fnOpenWindow(url, 'message_domain', '700', '420', 'scroll');
        } else {
            ui.alertMsg(contentBody.noRecvs);
        }
    });

    $(document).on('mouseover', '.userInfoSpan', function (e) {
        var obj = $(this);
        userInfoFlag = true;

        setTimeout(function () {
            if (userInfoFlag) {
                if (obj.attr('recvname') == '' && obj.attr('recvemail') == '') {
                    if (nvl(obj.attr('sender')) != '') {
                        $('#userNamePop').text(obj.attr('sname'));
                        $('#userEmailPop').text(obj.attr('sender'));
                    } else if (nvl(obj.attr('recvid')) == '') {
                        var srcip = '';
                        if (obj.attr('srcip') == undefined) srcip = unknown;
                        else srcip = obj.attr('srcip');
                        $('#userNamePop').text(srcip);
                        $('#userEmailPop').text(obj.text());
                    } else {
                        $('#userNamePop').text(obj.text());
                        $('#userEmailPop').text(obj.text());
                    }
                } else {
                    $('#userNamePop').text(obj.attr('recvname'));
                    if (obj.attr('recvemail') != '') $('#userEmailPop').text(obj.attr('recvemail'));
                    else $('#userEmailPop').text(nvl(obj.attr('recvid'), nvl(obj.attr('srcip'))));
                }
                if (obj.attr('recvconm') != '') $('#userCoNmPop').text(obj.attr('recvconm'));
                else $('#userCoNmPop').text('');
                if (obj.attr('recvbusinm') != '') $('#userBusiNmPop').text(obj.attr('recvbusinm'));
                else $('#userBusiNmPop').text('');
                if (obj.attr('recvsuborgnm') != '') $('#userSuborgNmPop').text(obj.attr('recvsuborgnm'));
                else $('#userSuborgNmPop').text('');
                if (obj.attr('recvdeptnm') != '') $('#userDeptNmPop').text(obj.attr('recvdeptnm'));
                else $('#userDeptNmPop').text('');
                if (obj.attr('recvjikgubnm') != '') $('#userJikgubNmPop').text(obj.attr('recvjikgubnm'));
                else $('#userJikgubNmPop').text('');
                if (obj.attr('recvip') != '') $('#userIpPop').text(obj.attr('recvip'));
                else $('#userIpPop').text('');
                if (obj.attr('recvsabun') != '') $('#userSabunPop').text(obj.attr('recvsabun'));
                else $('#userSabunPop').text('');

                var left = obj.offset().left;
                if (obj.offset().left + $('#userInfoDiv').width() > $(window).width()) {
                    left -= $('#userInfoDiv').width() - 20;
                }
                $('#userInfoDiv').css('top', obj.offset().top + 20);
                $('#userInfoDiv').css('left', left);
                $('#userInfoDiv').fadeIn();
            }
        }, 500);
    });
    $(document).on('mouseout', '.userInfoSpan, #userInfoDiv', function (e) {
        userInfoFlag = false;
        setTimeout(function () {
            if (!userInfoFlag) $('#userInfoDiv').fadeOut();
        }, 1000);
    });
    $(document).on('mouseover', '#userInfoDiv', function (e) {
        userInfoFlag = true;
    });
    $(document).bind("mousedown", function (event) {
        if (!(event.target.id == "userInfoDiv" || $(event.target).parents("#userInfoDiv").length > 0 || $(event.target).hasClass('userInfoSpan'))) {
            userInfoFlag = false;
            $('#userInfoDiv').fadeOut();
        }
    });
    $(document).bind("mouseup", "#emassBody", function (e) {
        if ((e.target.id != "emassBody" && $(e.target).parents("#emassBody").length == 0)) {
            if (!(e.target.id == "infoDiv" || $(e.target).parents("#infoDiv").length > 0)) {
                $('#infoDivText').text('');
                $('#infoDiv').fadeOut();
            }
            return;
        }
        var t = selectText();
        if (t.trim() == '') {
            if (!(e.target.id == "infoDiv" || $(e.target).parents("#infoDiv").length > 0)) {
                $('#infoDivText').text('');
                $('#infoDiv').fadeOut();
            }
            return;
        }

        var unescapeTxt = unescape(t.fReplaceWord('\\', '%'));
        if (t == unescapeTxt) {
            $('#infoDiv').fadeOut();
            return;
        }

        $('#infoDivText').text(unescapeTxt);

        var obj = $(this);
        var left = e.pageX;
        if (left + $('#infoDiv').width() > $(window).width()) {
            left -= $('#infoDiv').width() - 20;
            if (left < 0) left = 10;
        }

        var top = (e.pageY - $(document).scrollTop()) + 10;
        if (top + $('#infoDiv').height() > $(window).height()) {
            top -= $('#infoDiv').height() + 10;
            if (top < 0) top = 10;
        }
        $('#infoDiv').css('top', top + $(document).scrollTop());
        $('#infoDiv').css('left', left);
        $('#infoDiv').fadeIn();
    });

    $('.body_toggle').click(function () {
        var $this = $(this);
        if ($this.hasClass('fileFold')) {
            $this.next().next().toggle();
        }else{
            $this.next().toggle();
        }
    });

    $('#fileHelpBtn').click(function() {
        var $fileHelpDiv = $('#fileHelpDiv');
        if ($fileHelpDiv.css('display') === 'none') {
            $fileHelpDiv.css('display', 'block');
        } else {
            $fileHelpDiv.css('display', 'none');
        }
        event.stopPropagation();
    });

    $('.fileFold, .patternFold').click(function () {
        var foldFileYn = $('#attachDiv').parent().css('display');
        var foldPatternYn = $('#patternTable').parent().parent().css('display');
        var foldVal = '';
        if (foldFileYn == 'none' && foldPatternYn == 'none') {
            foldVal = '["Y","Y"]';
        } else if (foldFileYn == 'none' && foldPatternYn == 'block') {
            foldVal = '["Y","N"]';
        } else if (foldFileYn == 'block' && foldPatternYn == 'none') {
            foldVal = '["N","Y"]';
        } else {
            foldVal = '["N","N"]';
        }
        setConfFoldAdmin(foldVal);
    })
    init();
    //getMessage('20180110104222.HVWRQWHKKC7IPWAJSJN2W2HQIB52JQM2', '');
});

/**
 * 이미지 전체 화면으로 보기
 */
function fullSize(obj) {
    var imgUrl = $(obj).attr('url');
    var fileName = $(obj).attr('filename');

    var url = contextRoot + '/ems/imgFullsize.do';

    var winObj = fnOpenWindow('about:blank', "fullSize", 700, 500, "resize");

    document.imageForm.imgUrl.value = imgUrl;
    document.imageForm.fileName.value = fileName;
    document.imageForm.target = "fullSize";
    document.imageForm.action = url;
    document.imageForm.submit();
    winObj.focus();
}

function selectAllBodyText(containerid) {
    if (document.selection) {
        var range = document.body.createTextRange();
        range.moveToElementText(document.getElementById(containerid));
        range.select();
    } else if (window.getSelection) {
        window.getSelection().removeAllRanges();
        var range = document.createRange();
        range.selectNode(document.getElementById(containerid));
        window.getSelection().addRange(range);
    }
}

function setConfFoldAdmin(val) {
    setCookie('Cookie_foldAdmin', val, 300);
    /*console.log(val)
	ui.get({
		url : 'setConfAdmin.xcn',
		confId : 'message.fold.value',
		val : val,
		success : function(data, total) {
		},
		error : function(status, message) {
			ui.alertMsg(message);
		},
		complete : function() {
		}
	});*/
}

function viewer_open(row, grid) {
    var msgid = grid.getValue(row, 'msgid');
    var bodySize = grid.getValue(row, 'bodySizeStr');
    var bodySizeNum = bodySize.substr(0, bodySize.indexOf(' '));

    openMessageBodyPop(grid.id, msgid, '', bodySizeNum);
}

function getBody(userCharset,bodyStr){
    if (isGroupMessenger()) {
        // $('#usridTr').show();
        $('#ipBusiNmTr').show();
        $('#headerBtn').prop('disabled', true);
        $('#originalBtn').prop('disabled', true);
        $('#usersInfoBtn').html('<span class="glyphicon glyphicon-user"></span>&nbsp;' + message.userinfo);
    } else {
        $('#headerBtn').prop('disabled', false);
        $('#originalBtn').prop('disabled', false);
        $('#usersInfoBtn').html(message.userinfo);
    }
    $('#fromTr').show();
    $('#toTr').show();
    $('#participantTr').hide();
    $('#rootmtrTr').hide();

    //$('#small_txt').prop('disabled', false);
    //$('#large_txt').prop('disabled', false);
    if ($('#bodyEncoding').prop('disabled')) {
        $('#bodyEncoding').prop('disabled', false);
    }

    detailFlag = false;

    ui.onBody('content_body', 0, 0);
    ui.get({
        url: 'getEmassBodyStr.xcn',
        msgId: msgId,
        userCharset: userCharset,
        keywords: bodyStr,
        searchStrInput: parent.$('#searchStrInput').val(),
        menuId: 'MESSAGE_INFO',
        pMenuId: 'DATA_MONITOR',
        success: function (data, total) {
            if(data==null || nvl( data,'')=='') data = message.msgNocontent;
            if(data == BODY_SIZE_OVER) {
                $('#bodySizeOver').show();
                $('#bodySizeOverText').show();
            }else {
                $('#bodySizeOver').hide();
                $('#bodySizeOverText').hide();
                if (isGroupMessenger() && (svc.indexOf('J') == 3 || svc.indexOf('L') == 3)) $('#emassBody').html(getAppendGroupBody());
                else $('#emassBody').html(data + getAppendGroupBody());

                $("#emassBody").select();
                Highlight();
                PatternHighlight();
            }
        },
        error: function (status, message) {
            ui.alertMsg(message);
        },
        complete: function () {
            ui.off('content_body');
        }
    });
}

function getAppendGroupBody() {
    if (!isGroupMessenger()) return '';

    var str = '<br/><br/><br/><br/>';
    str += '<div class="appendClass" style="width:100%; text-align: center; font-size:13px;">';
    str += '<div style="width:100%; text-align: center; font-size:13px; display: inline-block;">';
    str += '<div style="display: inline-block;">';
    str += '<img src="' + contextRoot + '/img/paper.png" width="64px" height="64px"><br/>';
    str += '</div>';
    str += '</div>';
    str += '<span style="line-height:25px;">' + contentBodyDivJS.thisMsgAllChat + '</span><br/>';
    str += '<span style="line-height:25px;">' + contentBodyDivJS.inputDate + '</span><br/>';
    str += '<a href="javascript:void(0);" target="_self" onclick="selectGroupDetail();">' + contentBodyDivJS.allMsgView + '</a>';
    str += '</div>';
    var appendMsg = '';
    if (svc.indexOf('J') == 3) {
        appendMsg = contentBodyDivJS.chatJoin;
        return appendMsg + str;
    } else if (svc.indexOf('L') == 3) {
        appendMsg = contentBodyDivJS.chatLeave;
        return appendMsg + str;
    } else {
        return str;
    }
}

function isGroupMessenger() {
    var isGroup = false;
    if (svc.indexOf('Q') == 0 && xRootMtr != '') {
        isGroup = true;
    }
    return isGroup;
}

function selectGroupDetail() {
    var ctime = $('#ctimeTd').text();
    var dateObj = new Date(ctime);

    $('#startdatepickerBody').data("DateTimePicker").date(new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()));
    $('#enddatepickerBody').data("DateTimePicker").date(new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()));

    showRPeriodBody(($(window).width() / 2) - 220, $(window).height() / 2 - 150);
}

var searchFlag = false;

function getGroupDetail(rootmtr, usrId) {
    if (rootmtr == undefined) rootmtr = xRootMtr;
    if (usrId == undefined) usrId = usr_id;
    searchFlag = true;

    var startDt = $('#startdatepickerBody').data("DateTimePicker").date().format('YYYYMMDD');
    var endDt = $('#enddatepickerBody').data("DateTimePicker").date().format('YYYYMMDD');

    ui.onBody('content_body', 0, 0);
    ui.get({
        url: 'getMessengerGroupUserList.xcn',
        xRootMtr: rootmtr,
        startDt: startDt + "000000",
        endDt: endDt + "235959",
        userkey: usr_id,
        groupField: 'userkey',
        success: function (groupData, total) {
            getUsersInfo(groupData.groups, rootmtr);

            $("#emassBody").html('');
            ui.get({
                url: 'getMessageGroupDetail.xcn',
                xRootMtr: rootmtr,
                groupField: 'usr_id',
                srcip: srcip,
                startDt: startDt + "000000",
                endDt: endDt + "235959",
                usrId: usrId,
                readYn: 'Y',
                success: function (data, total) {
                    //$('#small_txt').prop('disabled', true);
                    //$('#large_txt').prop('disabled', true);
                    $('#bodyEncoding').prop('disabled', true);

                    $("#emassBody").html(printGroupList(data.groups, groupData.groups));
                    Highlight();
                    //$('#messageTotalCnt').html(data.groups.length.comma());

                    searchFlag = false;
                    detailFlag = true;

                    try {
                        opener.setReadDisplayChangeRootmtr(rootmtr, srcip);
                    } catch (e) {
                        console.log('opener.setReadDisplayChangeRootmtr : opener changed!')
                    }

                    if (msgId != '') {
                        //$(location).attr('href', '#'+msgId);
                        var obj = $('#' + idIndicator(msgId));
                        if (obj.length > 0) {
                            obj.parent().parent().css('background-color', '#eee');


                            $("html").animate({
                                scrollTop: obj.position().top - 100
                            }, 100);
                        }
                    }
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    ui.off('content_body');
                    setMessengerRead(rootmtr, srcip);
                }
            });


        },
        error: function (status, message) {
            ui.alertMsg(message);
        },
        complete: function () {
            $('#periodBodyMenu').css({"visibility": "hidden"});
        }
    });
}

function setMessengerRead(rootmtr, srcip) {
    ui.get({
        url: 'setMessengerRead.xcn',
        xRootMtr: rootmtr,
        srcIp: srcip,
        success: function (data, total) {

        },
        error: function (status, message) {
            ui.alertMsg(message);
        },
        complete: function () {
        }
    });
}

function getUsersInfo(data, xrootmtr) {
    $('#participantTr').show();
    $('#rootmtrTr').show();

    $('#srcTr').hide();
    $('#destTr').hide();
    $('#userTr').hide();
    $('#ipBusiNmTr').hide();
    $('#usridTr').hide();
    $('#fromTr').hide();
    $('#toTr').hide();
    $('#rootmtrDiv').text(xrootmtr);

    var str = '';
    for (var i = 0; i < data.length; i++) {
        if (data[i].groupName == 'sender_str') continue;
        str += '<span class="userInfoSpan" sname="' + nvl(data[i].sname) + '" sender="' + nvl(data[i].sender) + '" srcip="' + nvl(data[i].srcip) + '" recvid="' + nvl(data[i].usr_id) + '" recvip="" recvemail="" recvname="' + nvl(data[i].name) + '" ';
        str += 'recvconm="' + nvl(data[i].conm) + '" recvbusinm="' + nvl(data[i].businm) + '" recvsuborgnm="' + nvl(data[i].suborgnm) + '" recvdeptnm="' + nvl(data[i].deptnm) + '" recvjikgubnm="' + nvl(data[i].jikgubnm) + '" >' + nvl(data[i].srcip) + '; </span>';
    }
    $('#participantDiv').html(str);
}

function printGroupList(detailDataSet, users) {
    var str = '<div class="appendClass" style="width:100%;text-align:right;font-size:12px;padding-bottom:2px;">';
    str += '<button class="btn01" style="margin-right: 5px;" title=' + contentBodyDivJS.participantInfo + ' id="participantInfo" target="_parent" onclick="getParticipantInfo(\'\');"><i class="fa fa-users"></i> ' + contentBodyDivJS.participantInfo + '</button>';
    str += '<button class="btn01" title=' + contentBodyDivJS.backView + ' id="returnMsg" target="_parent" class="fullSizeIco" onclick="getBody(\'\');"><i class="fa fa-undo"></i> ' + contentBodyDivJS.backView + '</button>';
    str += '</div>';
    str += '<table class="g_request">';
    str += '	<colgroup>';
    str += '<col width="120">';
    str += '<col width="*">';
    str += '<col width="80">';
    str += '</colgroup>';
    str += '<tbody>';

    for (var i = 0; i < detailDataSet.length; i++) {
        var obj = detailDataSet[i];

        str += checkDate(detailDataSet, i);
        var obj_ctime = obj.ctime;
        str += '<tr>';

        var title = obj.title;
        //var titleTmp = users.search(obj.title, 'usr_id', 'name');
        //if( titleTmp != null ) title += '('+titleTmp+')';

        str += '<th>' + title + '</th>';
        str += '<td><div id="' + obj.msgid + '">' + obj.body_snippet.replaceAll('\n', '<br/>') + '</div></td>';
        str += '<td>' + obj_ctime.substring(10, obj_ctime.length) + '</td>';
        str += '</tr>';
    }
    str += '</tbody>';
    str += '</table><br/><br/>';
    return str + getBodyStyle();
}

function checkDate(detailDataSet, idx) {
    if (idx > 0 && detailDataSet[idx].ctime.substring(0, 10) == detailDataSet[idx - 1].ctime.substring(0, 10)) {
        return '';
    }

    var str = '';
    str += '<tr>';
    str += '<th class="date_title" colspan="3">' + detailDataSet[idx].ctime.substring(0, 10) + '</th>';
    str += '</tr>';
    return str;
}

function getBodyStyle() {
    var str = '<style>';
    str += 'table.g_response, table.g_request {border-collapse: collapse !important;font-family: Dotum, "Apple SD Gothic Neo", Helvetica, sans-serif !important;border-top: 2px solid #036 !important;width: 100% !important;}';
    str += '.g_request th, .g_response th {padding: 7px !important;font-weight: bold !important;border-bottom: 1px solid #ccc !important;font-size: 13px;text-align:center !important;}';
    str += '.g_request th {background-color: #F6F6F6}';
    str += '.g_response th {background-color: #2DBDDC !important;}';
    str += '.g_response td, .g_request td {padding: 7px !important;border-bottom: 1px solid #ccc !important;word-break: break-all !important;font-size: 13px;}';
    str += '.date_title{background-color: #F2F8FD !important;font-size: 13px;text-align:center !important;}';
    str += '</style>';

    return str;
}

function selectText() {
    var selectionText = "";
    if (document.getSelection) {
        selectionText = document.getSelection().toString();
    } else if (document.selection) {
        selectionText = document.selection.createRange().text;
    }
    return selectionText;
}

function init() {
    var windowName = window.name;

    if (windowName.indexOf('No_Title') > -1) {
        //$('#headerIcon').switchClass('fa-object-group', 'fa-object-ungroup');
        //$('#headerIcon').attr('title', message.windowNew);
        $('#prevBtn').prop('disabled', true);
        $('#nextBtn').prop('disabled', true);
        $('#openBigContent').hide();
    } else {
        //$('#headerIcon').switchClass('fa-object-ungroup', 'fa-object-group');
        //$('#headerIcon').attr('title', message.windowTab);
    }

    self.window.focus();
    /* setTimeout(function(){
		ui.off( 'content_body' );
	}, 3000); */
}

function loading_off() {
    ui.off('content_body');
}

function getEmassPatternDetail(obj, piId, type, attachName) {
    var cnt = $(obj).text();
    if (cnt == 0) {
        $('#detectionCnt').text('');
        $('#detailArea').text('');
        return;
    }
    $('#detailPatternDiv').show();
    //String msgId, String piId, String type
    ui.get({
        url: 'getEmassPatternDetail.xcn',
        msgId: msgId,
        piId: piId,
        type: type,
        attachName: attachName,
        success: function (data, total) {
            if (data.length > 0) {
                var kwds = data[0].kwds.replaceAll(',', '<br/>');
                $('#detailArea').html(kwds);
            } else {
                $('#detailArea').text('');
            }
        },
        error: function (status, message) {
            ui.alertMsg(message);
        },
        complete: function () {
        }
    });

}


//////////////////////////////////////////////////////////////////////////////////////////////////
function getMessage(id, search, bodySize, kHighlight, hostQueryUse) {
    $('#emassBody').css({'font-size': originalBodyFontSize + 'px'});

    $('#infoDiv').hide();
    if (opener) $('#openBigContent').hide();
    else $('#openBigContent').show();
    window.getSelection().removeAllRanges();

    bodySize_str = bodySize;
    msgId = id;
    searchkey = search;

    if (kHighlight != undefined) keywordHighlight = kHighlight;
    if (hostQueryUse != undefined) hostQuery = hostQueryUse;

    ui.get({
        url: 'getEmassMessageNew.xcn',
        msgId: msgId,
        consentUserId: parent.$('#consentUserId').val(),
        success: function (data, total) {
            setRead(data); //읽음 여부 처리
            setMessage(data);
        },
        error: function (status, message) {
            ui.alertMsg(message);
        },
        complete: function () {
        }
    });
}

function getProtocolNm(protocol) {
    var p = nvl(protocol);
    if (p == '') return '';
    else if (p == 'h2') return '[http/2]';
    else return '[http/1]';
}

var ocrFiles = [];
var msgData;

function setMessage(msg) {
    msgData = msg;

    $('#helpHostDesc').html('');
   	$('#hostDiv a').attr("title", '');

    window.scrollTo(0, 0);
    if (msg == null) {
            $('#buttonDiv').css("display", "none");
            $('#msgDiv').css("display", "none");
            $('#notfoundmsgDiv').css("display", "");
            $('#notfoundconsentDiv').css("display", "none");
            $('#notSelectDiv').css("display", "none");

        return;
    } else {
        if (msg.consentFlag) {
            $('#buttonDiv').css("display", "");
            $('#msgDiv').css("display", "");
            $('#notfoundmsgDiv').css("display", "none");
            $('#notfoundconsentDiv').css("display", "none");
            $('#notSelectDiv').css("display", "none");
        } else {
            $('#buttonDiv').css("display", "none");
            $('#msgDiv').css("display", "none");
            $('#notfoundmsgDiv').css("display", "none");
            $('#notfoundconsentDiv').css("display", "");
            $('#notSelectDiv').css("display", "none");
            return;
        }

        if (msgData.msgId == null && msg.consentFlag == true) {
            console.log('no data (mongoDb)');
            return;
        }
        var v = msg.ml_confd_class;
        var pr = msg.ml_confd_prob;
        var str = '<span style="display: inline-block; color: #fff; background-color: ' + getinfoTypeBgColor(v) + '; padding: 3px 5px; border-radius: 3px;">' + getinfoTypeStr(v) + '</span>';
        var files = msg.files;
        $('#infoType').html(str);
        $('#probType').html('');
        if (probPercent(pr) != '-') $('#probType').html('<span style="font-weight: bold;">(' + probPercent(pr) + '%)</span>');


        if (msg.ml_confd_feedback == -1) $('[name=feedback]').prop('checked', false);
        else $('[name=feedback][value=' + msg.ml_confd_feedback + ']').prop('checked', true);

        if (!(msg.ml_confd_userid == undefined || msg.ml_confd_userid == null || msg.ml_confd_userid == '')) {
            $('#ml_confd_userid').html('[ ' + msg.ml_confd_userid + ' ]');
        } else {
            $('#ml_confd_userid').html('');
        }
    }
    svc = msg.svc;
    if(svc.indexOf('X') == 0 || svc.indexOf('U') == 0){
        $('#detectPanel').show();
    }else {
        $('#detectPanel').hide();
    }


    xRootMtr = nvl(msg.xrootMtr);
    usr_id = nvl(msg.usrId);
    srcip = nvl(msg.srcIp);
    dstip = nvl(msg.dstIp);
    usrip = nvl(msg.usrIp);


    $('#subject').html(msg.subject);
    /* 문서 원문에 제목이 없을 경우 */
    if (msg.subjectIsEmpty) {
        var html = '<div id="subjectIsEmpty" type="hidden"></div>';
        $('#subject').append(html);
    }

    /* 서비스 타입 알수 없음의 경우  */
    var svcHtml = '<input id="unKnownDocument" type="hidden" value="' + svc + '">';
    $('#subject').append(svcHtml);


    // /* 수신 */
    // if(msg.direction == 'I') {
    // 	$('#recvOrsend').attr('class', 'top blueBg');
    // 	$('#recvOrsend').find('#sub_flag_reception').attr("style","display:none");
    // 	$('#recvOrsend').find('#sub_flag_send').show();
    // 	$('#recvOrsend').find('#subject').attr('class','blue02');
    // }/* 발신 */
    // else if(msg.direction == 'O'){
    // 	$('#recvOrsend').attr('class', 'top redBg');
    // 	$('#recvOrsend').find('#sub_flag_send').attr("style","display:none");
    // 	$('#recvOrsend').find('#sub_flag_reception').show();
    // 	$('#recvOrsend').find('#subject').attr('class','red');
    // }


    if (nvl(msg.svcNm) == "") {
        $('.svcnmSpan').html("");
        $('.svcnmSpan').css("display", "none");
    } else {
        $('.svcnmSpan').html(msg.svcNm + getProtocolNm(msg.protocol));
        $('.svcnmSpan').css("display", "");
    }

    if (xRootMtr != '' && xRootMtr != xmsgKey && msg.svc.startsWith('E')) {
        $('#openOriginal').show();
    } else $('#openOriginal').hide();

    if (nvl(msg.subjectStr) == "") {
        $('#subjectStrDiv #subjectStr').html("");
        $('#subjectStrDiv').css("display", "none");
    } else {
        $('#subjectStrDiv #subjectStr').html(msg.subjectStr);
        $('#subjectStrDiv').css("display", "");
    }

    $('#usridTr').css("display", "none");
    $('#srcTr').css("display", "");
    $('#destTr').css("display", "");
    $('#userTr').css("display", "");

    $('#srcipTd').html(msg.srcIp);
    $('#srcTr #ctimeTd').html(msg.ctime);
    $('#dstipTd').html(msg.dstIp);
    $('#bodySizeTd').html(convertFileSize(msg.size));

    $('#userDiv').html(userHtml(msg.userList, 'userTr', srcip, dstip, usrip));
    $('#userTr #userIdTd').html(msg.usrId);
    $('#userIdTd').html(msg.usrId);


    $('#sendUserDiv').html(userHtml(msg.senderList, 'fromTr', srcip, dstip, usrip));
    if (msg.toList.length == 0) {
        $('#toTr').css("display", "none");
        $('#receiveUserDiv').html('');
    } else {
        $('#toTr').css("display", "");
        $('#receiveUserDiv').html(userHtml(msg.toList, 'toTr', srcip, dstip, usrip));
    }

    if (msg.ccList.length == 0) {
        $('#ccTr').css("display", "none");
        $('#ccUserDiv').html('');
    } else {
        $('#ccTr').css("display", "");
        $('#ccUserDiv').html(userHtml(msg.ccList, 'ccTr', srcip, dstip, usrip));
    }

    if (msg.bccList.length == 0) {
        $('#bccTr').css("display", "none");
        $('#bccUserDiv').html('');
    } else {
        $('#bccTr').css("display", "");
        $('#bccUserDiv').html(userHtml(msg.bccList, 'bccTr', srcip, dstip, usrip));
    }

    if (nvl(msg.ipBusiNm) == "") {
        $('#ipBusiNmDiv').html();
    } else {
        $('#ipBusiNmDiv').html(nvl(msg.ipBusiNm));
    }

    if (nvl(msg.ipDeptNm) == "") {
        $('#ipDeptNmDiv').html();
    } else {
        $('#ipDeptNmDiv').html(nvl(msg.ipDeptNm));
    }

    var docVal = "";
    if (infoHynixConf == 'true' && files.length != 0) {
        for (var i = 0; i < files.length; i++) {
            var file = files[i];

            if (nvl(file.ml_confd_class) == 1) {
                docVal = "비밀 문서";
                break;
            } else if (nvl(file.ml_confd_class) == 0) {
                docVal = "대외비 문서";
            }

        }
        if (nvl(file.ml_confd_class) == "") {
            $('#docTr').css("display", "none");
            $('#docDiv').html();
        } else if (nvl(file.ml_confd_class) != "") {
            $('#docTr').css("display", "");
            $('#docDiv').html(docVal);
        }
    }

    if (nvl(msg.host) == "") {
        $('#hostTr').css("display", "none");
        $('#hostDiv').html();
        $('#hostDescriptionDiv').html();
        $("#hostCategoryDiv").css("display", "none");
    } else {
        $('#hostTr').css("display", "");
        var query = "";
        query = nvl(msg.query);
        var hostDivText = nvl(msg.host) + nvl(msg.path) + query;
        if (hostDivText.indexOf('http://') > -1) hostDivText = nvl(msg.path) + query;

        $('#hostDiv').html('<a style="word-break: break-all;" target="_blank" href="http://' + hostDivText + '">' + hostDivText + '</a>');
        $('#helpHost').attr('title', nvl(msg.host));
        getHostDescription(msg.host);

        if (msg.svc.startsWith("X") || msg.svc.startsWith("U")){
            getHostCategory(msg.host);
        }else{
            $("#hostCategoryDiv").css("display", "none");
        }
    }

    //대외비
    if (nvl(msg.epmsgType) == "") {
        $('#epmsgTr').css("display", "none");
        $('#epmsgDiv').html();

    } else {
        $('#epmsgTr').css("display", "");
        $('#epmsgDiv').html(nvl(msg.epmsgType));
    }

    $('#msgIdDiv').html(msg.msgId);

    if (nvl(msg.attachStr) == "") {
        $('#attachStrDiv #attachStr').html("");
        $('#attachStrDiv').css("display", "none");
    } else {
        $('#attachStrDiv #attachStr').html(msg.attachStr);
        $('#attachStrDiv').css("display", "");
    }

    if (nvl(msg.fileNameStr) == "") {
        $('#fileNameStrDiv #fileNameStr').html("");
        $('#fileNameStrDiv').css("display", "none");
    } else {
        $('#fileNameStrDiv #fileNameStr').html(msg.fileNameStr);
        $('#fileNameStrDiv').css("display", "");
    }

    if (nvl(msg.attachStr) == "" && nvl(msg.fileNameStr) == "") {
        $('fileKwdDiv').css("display", "none");
    } else {
        $('fileKwdDiv').css("display", "");
    }

    setFileDiv(msg);			//file 및 OCR 처리

    if (msg.patterns != null && msg.patterns != undefined && msg.patterns != ''){
        patnName = getPiName(msg.patterns);
        patternKyword = msg.patterns;
    }
    setPatternDiv(msg.patterns);

    // alert(bodySize_str)
    // if(bodySize_str == 0) {
    // 	$('#emassBody').html(message.msgNocontent);
    // }else getBody('');

    if(bodySize_str == 0) {
        $('#emassBody').html(message.msgNocontent);
        Highlight();
    }else getBody('',nvl(msg.bodyStr));

    getBody('');
    if (nvl(msg.bodyStr) == "") {
        $('#bodyStrDiv #bodyStr').html("");
        $('#bodyStrDiv').css("display", "none");
    } else {
        $('#bodyStrDiv #bodyStr').html(msg.bodyStr);
        $('#bodyStrDiv').css("display", "");
    }
}

function getPatnName() {
    return patnName;
}

function getPattern(){
    return patternKyword;
}

function userHtml(userList, tr, srcip, dstip, usrip) {

    var userDivHtml = "";

    var inSideCnt = 0;
    var outSideCnt = 0;
    for (var i = 0; i < userList.length; i++) {
        var user = userList[i];
        if (nvl(user.inSide) == 'N') outSideCnt++;
        else inSideCnt++;
    }
    var str = '';
    if (tr == 'userTr') str = contentBody.user;
    else if (tr == 'fromTr') str = contentBody.from;
    else if (tr == 'toTr') str = contentBody.to;
    else if (tr == 'ccTr') str = contentBody.cc;
    else if (tr == 'bccTr') str = contentBody.bcc;

    $('#userTr > th.fold_clickTh .trTitle').html(contentBody.user);
    $('#fromTr > th.fold_clickTh .trTitle').html(contentBody.from);
    $('#toTr > th.fold_clickTh .trTitle').html(contentBody.to);
    $('#ccTr > th.fold_clickTh .trTitle').html(contentBody.cc);
    $('#bccTr > th.fold_clickTh .trTitle').html(contentBody.bcc);
    setTimeout(function () {
        $('#' + tr + ' > th.fold_clickTh .trTitle').html(str + '(' + outSideCnt + '/' + inSideCnt + ')');
    }, 1);

    for (var i = 0; i < userList.length; i++) {
        var insideClass = "";
        var user = userList[i];


        if (nvl(user.inSide) == 'N') insideClass = 'userOutside';
        else insideClass = 'userInside';


        if ('' != nvl(user.name)) userDivHtml += '<span class="userInfoSpan ' + insideClass + '"';
        else userDivHtml += '<span class="userInfoSpan notuser';


        userDivHtml += ' recvid="' + nvl(user.recvId) + '"';
        userDivHtml += ' recvip="' + chkUserIp(nvl(user.ip), srcip, dstip, usrip) + '"';
        userDivHtml += ' recvemail="' + nvl(user.email) + '"';
        userDivHtml += ' recvname="' + nvl(user.name) + '"';
        userDivHtml += ' recvconm="' + nvl(user.coNm) + '"';
        userDivHtml += ' recvbusinm="' + nvl(user.busiNm) + '"';
        userDivHtml += ' recvsuborgnm="' + nvl(user.subOrgNm) + '"';
        userDivHtml += ' recvdeptnm="' + nvl(user.deptNm) + '"';
        userDivHtml += ' recvjikgubnm="' + nvl(user.jikgubNm) + '"';
        userDivHtml += ' recvsabun="' + nvl(user.sabun) + '"';
        userDivHtml += '>';
        userDivHtml += user.viewStr + (i != userList.length - 1 ? '; ' : '');
        userDivHtml += ' </span>';
    }

    return userDivHtml;
}

function chkUserIp(ipList, srcip, dstip, usrip) {
    var rtnIp = [];
    ;
    var ipLists = ipList.split(',');
    for (var i = 0; i < ipLists.length; i++) {
        var ip = ipLists[i].replaceAll(' ', '');
        if (ip == srcip) rtnIp.push(ip);
        else if (ip == dstip) rtnIp.push(ip);
        else if (ip == usrip) rtnIp.push(ip);
    }
    return rtnIp.join(', ');
}

function getFold() {
    var data = getCookie('Cookie_foldAdmin');
    var foldValarr = [];

    if (data == "") {
        foldValarr = '["Y","Y"]';
        setConfFoldAdmin(foldValarr);
    } else {
        foldValarr = JSON.parse(data);
    }

    if (foldValarr[0] == 'N') {
        $('#attachDiv').parent().css("display", "block");
    } else {
        $('#attachDiv').parent().css("display", "none");
    }
    if (foldValarr[1] == 'N') {
        $('#patternTable').parent().parent().css("display", "block");
    } else {
        $('#patternTable').parent().parent().css("display", "none");
    }
}

function setFileDiv(msg) {
    var fileRows = $('#fileTable tr').length;
    for (var i = fileRows; i > 1; i--) {
        $('#fileTable  > tbody:last > tr:last').remove();
    }
    var fileStr = "";
    var extClass = "";
    var ocrYn = false;
    var files = msg.files;
    if (files.length != 0) {
        $('#fileDiv').css("display", "");
        $('#fileCntArea').text(' (' + files.length + ')');
        for (var i = 0; i < files.length; i++) {
            var file = files[i];
            var attachName = file.attachName;
            var attachHash = file.attachHash;
            var attachSecretYn = file.ml_confd_class;
            var radioFeedback = file.ml_confd_class;
            var attachsprob = file.ml_confd_prob;
            var attachsprobRounds = null;
            var attachExt = file.attachExt;
            var attachNameExist = file.attachNameExist;
            var attachSpace = file.attachSpace;
            var attachSecretYnStr = file.ml_confd_class;
            var msgId = msg.msgId;
            var attachCnt = msg.attachCnt;
            var attachId = file.attachId;
            var attachFeedbackDate = file.mlFeedbackTimeStr;
            var mlFeedbackYN = file.mlFeedbackYN;
            var mlFeedbackComment = file.mlFeedbackComment;
            var features = file.features;
            var mlReason = null;
            var ext = attachName.split(".");
            var trClass = "found";
            if (infoHynixConf == 'true') {
                attachSecretYn == null;
                attachsprob == null;
            }

            //문서 분류
            if (attachSecretYn == 1) {
                attachSecretYnStr = "비밀 문서";
            } else if (attachSecretYn == 0) {
                attachSecretYnStr = "대외비 문서";
            } else {
                attachSecretYnStr = '-';
            }

            //비밀 확률
            attachsprobRounds = Math.round(attachsprob * 100) / 100;

            if (attachsprobRounds == undefined || attachsprobRounds == null || attachsprobRounds == -1.0) attachsprobRounds = '-';
            else attachsprobRounds = Math.floor(attachsprobRounds * 100);

            if (attachFeedbackDate == undefined || attachFeedbackDate == null) attachFeedbackDate = '-';

            if (nvl(file.attachPath) == "") trClass = "notfound";

            if (file.attachSize == 0 || file.attachExt== "N"){ //파일 없음
                extClass =" fileNoSizeNo"
                attachExt="-";
            }else { //파일 있을 경우
                if (attachNameExist == "N"){ //파일명 알수 없음
                    extClass = " fileNameExistN";
                }else if (file.encrypted == 'Y' || attachExt == "enc"){ //암호화 파일
                    extClass = " fileEncrypte";
                }else if (file.drm == "Y" || attachExt == 'drm'){ //DRM 파일
                    extClass = " fileDrm";
                }else if (attachExt == "unknown"){ //파일 확장자 없음
                    extClass = " unknownExt";
                    attachExt = contentBody.unknown;
                    attachExt += "(txt)";
                } else if (!(ext.length > 1 && nvl(attachExt) == ext[ext.length-1])) { //파일 확장자 다른 경우
                    extClass = " differentExt";
                }else{
                    extClass = "";
                }
            }

            fileStr = '';
            fileStr += '<tr msgid="' + msg.msgId + '" id="' + file.attachId + '" size="' + file.attachSize + '" class="' + trClass + extClass + '" >';
            fileStr += '<td>';
            fileStr += '<span class="attach_' + attachExt + ' attach_file_img" style="padding-right:5px;"></span> ';
            fileStr += '<span class="attachName" style="text-decoration: underline;" attachname="' + attachName + '">';
            fileStr += '' + attachName + ' (' + convertFileSize(file.attachSize) + ')</span> ';
            fileStr += '<span class="glyphicon glyphicon-download-alt downloadIcon" style="cursor:pointer"></span>';
            if (extClass == " unknownExt")fileStr +='<span style="margin-left: 5px; float: right"> <i class="fa fa-exclamation fa-lg" aria-hidden="true" style="color:#757373;margin-right: 2px;font-size: 14px;"></i><span style="color: #757373">['+contentBody.unknownExt+']</span></span>'
            if (extClass == " differentExt")fileStr +='<span style="margin-left: 5px;float: right"><i class="fa fa-exclamation fa-lg" aria-hidden="true" style="color:#757373;margin-right: 2px;font-size: 14px;"></i><span style="color: #757373">['+contentBody.differentExt+']</span></span>'
            if (extClass == " fileNameExistN")fileStr +='<span style="margin-left: 5px;float: right"><i class="fa fa-exclamation fa-lg" aria-hidden="true" style="color:#757373;margin-right: 2px;font-size: 14px;"></i><span style="color: #757373">['+contentBody.fileNameExistN+']</span></span>'
            if (extClass == " fileNoSizeNo")fileStr +='<span style="margin-left: 5px;float: right"><i class="fa fa-exclamation fa-lg" aria-hidden="true" style="color:#757373;margin-right: 2px;font-size: 14px;"></i><span style="color: #757373">['+contentBody.fileNoSizeNo+']</span></span>'
            if (extClass == " fileEncrypte")fileStr +='<span style="margin-left: 5px;float: right"><i class="fa fa-exclamation fa-lg" aria-hidden="true" style="color:#757373;margin-right: 2px;font-size: 14px;"></i><span style="color: #757373">['+contentBody.fileEncrypte+']</span></span>'
            if (extClass == " fileDrm")fileStr +='<span style="margin-left: 5px;float: right"><i class="fa fa-exclamation fa-lg" aria-hidden="true" style="color:#757373;margin-right: 2px;font-size: 14px;"></i><span style="color: #757373">['+contentBody.fileDrm+']</span></span>'
            //fileStr += '<td style="text-align: right;">' + convertFileSize(file.attachSize) + '</td>';
            fileStr += '<td style="text-align: center;">';
            if (nvl(file.ocrYn) == "Y") {
                fileStr += '<img alt="" src="' + contextRoot + '/img/view.png" style="width: 15px;">';
                fileStr += '<span class="attachOcrText" style="padding-left:5px; cursor:pointer; text-decoration: underline;">';
                //	fileStr += '<img alt="" src="' + contextRoot + '/img/ocr.png" style="width: 25px;">';
                fileStr += ' ' + contentBody.urlIpBlockPreview + '</span>';
            } else if (nvl(file.attachTextPath) != "") {
                fileStr += '<img alt="" src="' + contextRoot + '/img/text.png" style="width: 15px;">';
                fileStr += '<span class="attachText" style="padding-left:5px; cursor:pointer; text-decoration:underline;"> ' + contentBody.urlIpBlockPreview + '</span>';
            }

            fileStr += '</td>';

            if(extClass == " fileNoSizeNo")	fileStr += '<td style="text-align: center;"><span class="attachExt">&nbsp;' + attachExt +'</span></td>';
            else 	fileStr += '<td style="text-align: center;"><span class="attachExt"><span class="glyphicon glyphicon-download-alt"></span>&nbsp;' + attachExt +'</span></td>';
            fileStr += '<td style="text-align: center;"><span class="attachSpace">' + (nvl(attachSpace) != "" ? 'O' : '-') + '</span></td>';

            //	fileStr += '<td style="text-align: center;" class="downloadBtn"><span class="glyphicon glyphicon-download-alt downloadIcon"></span></td>';
            fileStr += '</tr>';
            $('#fileTable').append(fileStr);

            if (nvl(file.ocrYn) == "Y") {
                ocrFiles.push(file);
                ocrYn = true;
            }
        }

        if (ocrYn) {
            $('#bodyDiv').nextAll().remove();
            setOcrFileDiv(ocrFiles);
            ocrFiles = [];
        } else {
            $('#bodyDiv').nextAll().remove();
        }
    } else {
        $('#bodyDiv').nextAll().remove();
        $('#fileDiv').css("display", "none");
    }
    getFold();
}


function clickFeedbackBtn(i, attachId, msgId, attachFeedbackDate, mlFeedbackYN, mlFeedbackComment, attachSecretYn, attachName, attachHash, features) {
    var con = document.getElementById('feedbackSetting' + i);
    var j = null;

    //feedbackSetting'+i id값을 가진 요소가 있는지 체크
    if (document.getElementById('feedbackSetting' + i)) {
        con.style.display = (con.style.display != 'none') ? "none" : "";
        j = i;
    } else {
        j = Number(i) + 1;
        $('<tr id = "feedbackSetting' + i + '"><td colspan = "9"; id = "feedbackTd[' + i + ']"><div class=condition_label><label class=condition_label><input type=radio id = radio2[' + i + '] name=feedbackYN' + i + ' value=2><span> 분류 맞음</span></label><label class=condition_label><input type=radio id = radio9[' + i + '] name=feedbackYN' + i + ' value=9><span> 결정 보류</span></label><label class=condition_label><input type=radio id = radio1[' + i + '] name=feedbackYN' + i + ' value=1><span> 비밀 문서</span></label><label class=condition_label><input type=radio id = radio0[' + i + '] name=feedbackYN' + i + ' value=0> <span> 대외비 문서</span></label><textarea style=margin-left : 30px; name=feedbackComment id=feedbackComment' + i + ' placeholder=커멘트를입력하세요 rows=1 cols=30></textarea><button class=save_btn; style=margin-left:10px; id=feedbackSaveBtn; onclick="clickFeedbackSaveBtn(' + "\'" + i + "\'" + "," + "\'" + attachId + "\'" + "," + "\'" + msgId + "\'" + "," + "\'" + attachFeedbackDate + "\'" + "," + "\'" + mlFeedbackYN + "\'" + "," + "\'" + mlFeedbackComment + "\'" + "," + "\'" + attachSecretYn + "\'" + "," + "\'" + attachName + "\'" + "," + "\'" + attachHash + "\'" + "," + "\'" + features + "\'" + "," + "\'" + j + "\'" + ');"><span>저장</span></button></div></td></tr>').insertAfter(document.getElementById(attachId));
    }

    ui.get({
        url: 'getMlSecretData.xcn',
        msgId: msgId,
        attachId: attachId,
        success: function (data, total) {
            var mlSecurityYN = data.mlSecurityYN;

            if (mlSecurityYN == 1) {
                document.getElementById('radio1[' + i + ']').disabled = true;
                document.getElementById('radio0[' + i + ']').disabled = false;
            } else if (mlSecurityYN == 0) {
                document.getElementById('radio0[' + i + ']').disabled = true;
                document.getElementById('radio1[' + i + ']').disabled = false;
            }

            if (attachFeedbackDate != '-') {
                ui.get({
                    url: 'getMlFeedbackDate.xcn',
                    msgId: msgId,
                    attachId: attachId,
                    success: function (data, total) {
                        var attachFeedbackDate1 = data.mlFeedbackTime;
                        var mlFeedbackYN1 = data.mlFeedbackYN;
                        var mlFeedbackComment1 = data.mlFeedbackComment;
                        if (attachFeedbackDate1 != '-') {
                            if (mlFeedbackYN1 == '2') {
                                document.getElementById('radio2[' + i + ']').checked = true;
                            } else if (mlFeedbackYN1 == '9') {
                                document.getElementById('radio9[' + i + ']').checked = true;
                            } else if (mlFeedbackYN1 == '1') {
                                document.getElementById('radio1[' + i + ']').checked = true;
                            } else if (mlFeedbackYN1 == '0') {
                                document.getElementById('radio0[' + i + ']').checked = true;
                            }
                            document.getElementById("feedbackComment" + i).value = mlFeedbackComment1;

                        } else if (attachFeedbackDate1 == '-') {
                            $('input:radio[name=feedbackYN' + i + ']').removeAttr("checked");
                            document.getElementById("feedbackComment" + i).value = '';
                        }

                    },
                    error: function (status, message) {
                    },
                    complete: function () {
                    }
                });
            }
        },
        error: function (status, message) {
        },
        complete: function () {
        }
    });

}

function clickFeedbackSaveBtn(i, attachId, msgId, attachFeedbackDate, mlFeedbackYN, mlFeedbackComment, attachSecretYn, attachName, attachHash, features, j) {
    var radioFeedback = $('input[name=feedbackYN' + i + ']:checked').val();
    var feedbackcomment = $("#feedbackComment" + i).val();
    var msgId = msgId;
    var attachId = attachId;
    var attachFeedbackDate = attachFeedbackDate;
    var mlFeedbackYN = mlFeedbackYN;
    var mlFeedbackComment = mlFeedbackComment;
    var attachSecretYn = attachSecretYn;
    var con = document.getElementById('feedbackSetting' + i);
    var attachName = attachName;
    var attachHash = attachHash;
    var features = features;
    var attachSecretYn1 = '';
    var col = null;

    var rowId = i;
    var rowNum = Number(rowId) + 1;
    var colId = 1;
    var row = document.getElementById("fileTable").rows;
    col = row[rowNum].cells;
    ui.get({
        url: 'insertSkFeedback.xcn',
        radioFeedback: radioFeedback,
        feedbackcomment: feedbackcomment,
        attachId: attachId,
        msgId: msgId,
        attachName: attachName,
        attachHash: attachHash,
        success: function (data, total) {
            //2(분류 맞음) ,9(결정보류) , 1(비밀문서), 0(대외비 문서)
            alert("저장되었습니다.");

            if (radioFeedback == '1') {
                attachSecretYn1 = '비밀 문서';
            } else if (radioFeedback == '0') {
                attachSecretYn1 = '대외비 문서';
            }

            if (attachFeedbackDate != undefined || attachFeedbackDate != null) {
                updateSkMlFeedback(msgId, attachId, radioFeedback, attachSecretYn);	//mlResult에 피드백 값 바꿔줌
            }
            getSolrFeedback(msgId, radioFeedback);
            getFeedbackSecretData(i, msgId, attachId, attachFeedbackDate);	//라디오 버튼 누르지 못하게 하려고
            getMlFeedbackDate(i, msgId, attachId, j);

            if (typeof (attachSecretYn1) !== "undefined" && attachSecretYn1 !== null) {
                if (radioFeedback == '1' || radioFeedback == '0') {
                    if (attachSecretYn1 != undefined) {
                        col[colId].textContent = attachSecretYn1;
                    }
                }
            }

        },
        error: function (status, message) {
        },
        complete: function () {
        }
    });

}

function getFeedbackSecretData(i, msgId, attachId, attachFeedbackDate) {
    var attachFeedbackDate = attachFeedbackDate;
    var attachSecretYn = attachSecretYn;
    var radioFeedback = $('input[name=feedbackYN' + i + ']:checked').val();

    ui.get({
        url: 'getFeedbackSecretData.xcn',
        msgId: msgId,
        attachId: attachId,
        success: function (data, total) {

            var updateAttachSecretYn = data.mlSecurityYN;

            if (radioFeedback == '1') {
                radioFeedback = '비밀 문서';
            } else if (radioFeedback == '0') {
                radioFeedback = '대외비 문서';
            }
            if (radioFeedback == '비밀 문서') {
                document.getElementById("radio0[" + i + "]").disabled = false;
                document.getElementById("radio1[" + i + "]").disabled = true;
            } else if (radioFeedback == '대외비 문서') {
                document.getElementById("radio1[" + i + "]").disabled = false;
                document.getElementById("radio0[" + i + "]").disabled = true;
            }

        },
        error: function (status, message) {
        },
        complete: function () {
        }
    });

}

function getFeedbackRadio(msgId, attachId) {	//피드백 이후 피드백내용 라디오버튼에 보여줄때 사용
    var msgId = msgId;
    var attachId = attachId;

    ui.get({
        url: 'getMlFeedbackDate.xcn',
        msgId: msgId,
        attachId: attachId,
        success: function (data, total) {
            d = JSON.stringify(data);
            var attachFeedbackDate1 = data.mlFeedbackTime;
            var mlFeedbackYN1 = data.mlFeedbackYN;
            var mlFeedbackComment1 = data.mlFeedbackComment;
            if (attachFeedbackDate1 != '-') {
                if (mlFeedbackYN1 == '2') {
                    document.getElementById('radio2[' + i + ']').checked = true;
                } else if (mlFeedbackYN1 == '9') {
                    document.getElementById('radio9[' + i + ']').checked = true;
                } else if (mlFeedbackYN1 == '1') {
                    document.getElementById('radio1[' + i + ']').checked = true;
                } else if (mlFeedbackYN1 == '0') {
                    document.getElementById('radio0[' + i + ']').checked = true;
                }
                document.getElementById("feedbackComment" + i).value = mlFeedbackComment1;

            } else if (attachFeedbackDate1 == '-') {

                $("input:radio[name='feedbackYN'+i]").removeAttr("checked");
                document.getElementById("feedbackComment" + i).value = '';
            }

            if (attachSecretYn == '1') {
                attachSecretYn = '비밀 문서'
            } else if (attachSecretYn == '0') {
                attachSecretYn = '대외비 문서'
            }

            if (attachSecretYn == '비밀 문서') {
                document.getElementById("radio1[" + i + "]").disabled = true;
            } else if (attachSecretYn == '대외비 문서') {
                document.getElementById("radio0[" + i + "]").disabled = true;
            }

        },
        error: function (status, message) {
        },
        complete: function () {
        }
    });
}

function getMlFeedbackDate(i, msgId, attachId, j) {
    var i = i;
    var msgId = msgId;
    var attachId = attachId;

    ui.get({
        url: 'getMlFeedbackDate.xcn',
        msgId: msgId,
        attachId: attachId,
        success: function (data, total) {
            attachFeedbackDate = data.mlFeedbackTimeStr;

            var rowId = i;
            var rowNum = Number(rowId) + 1;
            var colId = 8;
            var row = document.getElementById("fileTable").rows;
            col = row[rowNum].cells;

            if (typeof (attachFeedbackDate) !== "undefined" && attachFeedbackDate !== null) {
                col[colId].textContent = attachFeedbackDate;
            }

        },
        error: function (status, message) {
        },
        complete: function () {
        }
    });
}


function mlReason_click(i, attachId, msgId, attachFeedbackDate, mlFeedbackYN, mlFeedbackComment, attachSecretYn, attachName, attachHash, features) {
    var features = features;
    console.log("features : " + features)

    if (features == "null") {
        features = '판단 근거 내용이 없습니다.';
    }

    $("#featuresValue").text(features);
    $("#featureModal").modal('show');
}

function getSolrFeedback(msgId, radioFeedback) {
    var msgId = msgId;
    var radioFeedback = radioFeedback;

    ui.get({
        url: 'getSolrFeedback.xcn',
        msgId: msgId,
        radioFeedback: radioFeedback,
        success: function (status, message) {
        },
        error: function (status, message) {
        },
        complete: function () {
        }
    });
}

function updateSkMlFeedback(msgId, attachId, radioFeedback, attachSecretYn) {
    var msgId = msgId;
    var attachId = attachId;
    var radioFeedback = radioFeedback;
    var attachSecretYn = attachSecretYn;

    ui.get({
        url: 'updateSkMlFeedback.xcn',
        msgId: msgId,
        attachId: attachId,
        radioFeedback: radioFeedback,
        attachSecretYn: attachSecretYn,
        success: function (data, total) {
        },
        error: function (status, message) {
        },
        complete: function () {
        }

    });
}

function setOcrFileDiv(files) {
    let fileStr = "";
    let fileLength = files.length;
    let fileSpace = "";
    let attachView = "";

    for (let i = 0; i < fileLength; i++) {
        let file = files[i];
        let space = nvl(file.attachSpace, "");
        let attachName = file.attachName;
        let attachExt = file.attachExt;

        if (fileStr == "") {
            fileSpace = nvl(file.attachSpace, "");

            fileStr += '<div class="row" id="">';
            fileStr += '	<div class="col-lg-12">';
            fileStr += '		<div class="panel panel-default">';
            fileStr += '				<div class="panel-heading body_toggle" id="">';
            if (file.attachSpace == null) {
                fileStr += '					<i class="fa fa-bar-chart-o fa-fw"></i>' + contentBody.ocrAttach;
            } else {
                fileStr += '					<i class="fa fa-bar-chart-o fa-fw"></i>' + contentBody.ocrBody;
            }
            fileStr += '				</div>';
            fileStr += '				<div class="panel-body css-body">';
            fileStr += '					<div id="attachDiv">';
            fileStr += '						<table class="table table-bordered" id="1">';
            fileStr += '							<colgroup>';
            fileStr += '								<col width="200px">';
            fileStr += '								<col width="*">';
            fileStr += '							</colgroup>';

        }

        attachView += '<tr>';
        attachView += '<th colspan="2">' + attachName + '</th>';
        attachView += '</tr>';
        attachView += '<tr id ="' + i + '">';
        attachView += '<td>';
        attachView += '<img " style="max-width: 200px" src="data:image/' + attachExt + ';base64, ' + file.ocrImageStr + '"/>';
        attachView += '</td>';
        attachView += '<td>' + nvl(file.ocrText).replaceAll("\n", "<br>") + '</td>';
        attachView += '</tr>';

        if (i == (fileLength - 1) || ((i + 1) <= (fileLength - 1) && nvl(files[i + 1].attachSpace, "") != fileSpace)) {
            fileSpace = space;
            fileStr += attachView;

            fileStr += '						</table>';
            fileStr += '					</div>';
            fileStr += '				</div>';
            fileStr += '			</div>';
            fileStr += '		</div>';
            fileStr += '	</div>';
            fileStr += '</div>';

            $('.content_body').append(fileStr);
            fileStr = "";
            attachView = "";
        }
    }
}

function getHostDescription(host) {
    ui.get({
        url: 'getHostDescription.xcn',
        host: host,
        success: function (data, total) {
            $("#hostDescriptionDiv").css("display", "");
            if (data == null){
                $('#hostDescriptionDiv').html("");
            }
            else {
                $('#hostDescriptionDiv').html(data.description);
            }
        },
        error: function (status, message) {
            ui.alertMsg(message);
        },
        complete: function () {
        }
    });
}

function getHostCategory(host){
    ui.get({
        url: 'getHostCategory.xcn',
        host: host,
        success: function (data, total) {
            if (data != null){
                $("#hostCategoryDiv").css("display", "inline-block");
                $('#hostCategory').html(contentBody.category+": "+data.description);
            }

            // if (data == null){
            //     $('#hostDescriptionDiv').html("");
            // }
            // else {
            //     $('#hostDescriptionDiv').html(data.description);
            // }
        },
        error: function (status, message) {
            ui.alertMsg(message);
        },
        complete: function () {
        }
    });
}


function setPatternDiv(patterns) {
    var fileRows = $('#patternTable tr').length;
    for (var i = fileRows; i > 1; i--) {
        $('#patternTable  > tbody:last > tr:last').remove();
    }

    if (patterns.length == 0) {
        $('#patternDiv').css("display", "none");
    } else {
        $('#patternDiv').css("display", "");
        var pattern_total = 0;
        var patternStr = "";
        for (var i = 0; i < patterns.length; i++) {
            var pattern = patterns[i];
            var type = nvl(pattern.type);
            var attachName = nvl(pattern.attachName);
            var piType = "";
            if (type == "S") piType = message.subject;
            else if (type == "B") piType = message.body;
            else if (type == "F") piType = message.attach_name;
            else if (type == "A") piType = message.attach;
            else piType = message.message_info;
            patnName = getPiName(pattern);
            var piId = nvl(pattern.piid);
            patternStr = '<tr>';
            if (type == "A" || type == "F") {
                patternStr += '<td style="text-align: left;padding-left: 10px !important;">' + piType + '</td>';
                patternStr += '<td style="word-break: break-word;">' + attachName + '</td>';
            } else {
                patternStr += '<td colspan="2" style="text-align: left;padding-left: 10px !important;">' + piType + '</td>';
            }
            patternStr += '<td style="word-break: break-word;">' + getPiName(pattern) + '</td>';
            patternStr += '<td style="text-align: right;"><a href="javascript:void(0);" style="text-decoration: underline;" onclick="getEmassPatternDetail(this, \'' + piId + '\', \'' + type + '\', \'' + attachName + '\')">' + pattern.total + '</a></td>';
            patternStr += '</tr>';
            $('#patternTable').append(patternStr);

            pattern_total = pattern.total + pattern_total;
        }
        var countStr = '';
        countStr += '<tr>';
        countStr += '<th colspan="2" style="text-align: center;font-weight: bold;">' + contentBodyDivJS.total + '</th>';
        countStr += '<th colspan="2" style="text-align: right !important;font-weight: bold;">' + pattern_total + '</th>';
        countStr += '</tr>';
        $('#patternCntArea').text(' (' + pattern_total + ')');
        $('#patternTable').append(countStr);
    }
}

function getPiName(pattern) {
    var piName = nvl(pattern.piName);
    if (piName != '') return piName;
    return contentBody.bodyviewInfoPattern;
}


jQuery.fn.highlight = function (pat, type) {
    function innerHighlight(node, pat, type) {
        var skip = 0;
        if (node.nodeType == 3) {
            var pos = node.data.toUpperCase().indexOf(pat);
            if (pos >= 0) {
                var spannode = document.createElement('span');
                if (type.indexOf('K') > -1) {
                    spannode.className = 'highlightKeyword';
                } else {
                    spannode.className = 'highlightSearch';
                }
                if (type.indexOf('B') > -1) {
                    if (type.indexOf('K') > -1) {
                        spannode.style.backgroundColor = '#FFAD5B';
                        spannode.style.color = '#000000';
                        spannode.style.fontWeight = 'bold';
                    } else {
                        spannode.style.backgroundColor = '#13C7A3';
                        spannode.style.color = '#000000';
                        spannode.style.fontWeight = 'bold';
                    }
                }

                var sbit = node.splitText(pos);
                sbit.splitText(pat.length);
                spannode.nodeValue = sbit.data;
                var sbitclone = sbit.cloneNode(true);
                spannode.appendChild(sbitclone);
                sbit.parentNode.replaceChild(spannode, sbit);
                skip = 1;
            }
        } else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
            for (var i = 0; i < node.childNodes.length; ++i) {
                i += innerHighlight(node.childNodes[i], pat, type);
            }
        }
        return skip;
    }

    return this.each(function () {
        innerHighlight(this, pat.toUpperCase(), type);
    });
};

//
// jQuery.fn.highlight = function(pat, type) {
// 	function innerHighlight(node, pat, type) {
// 		pat = pat.trim().replaceAll("\\(","").replaceAll("\\)","");
// 		var skip = 0;
// 		if (node.nodeType == 3) {
// 			if(pat.substring(0,1) == '/' && pat.substring(pat.length - 1) == '/') {
// 				//var pos = node.data.toUpperCase().indexOf(pat);
//
// 				var solrQueryText = pat;
// 				var re = new RegExp(solrQueryText, 'ig');
// 				var matchArray;
// 				var first = 0;
// 				var last = 0;
// 				var resultString = '';
// 				while ( (matchArray = re.exec(node.data.toString())) != null ) {
// 					/* last = matchArray.index;
// 					// 일치하는 모든 문자열을 연결
// 					resultString += nStr.substring(first, last);
//
// 					// 일치하는 부분에 강조 스타일이 지정된 class 추가
// 					resultString += "<span class='mulfound'>" + matchArray[0] + "</span>";
// 					first = re.lastIndex;
// 					// RegExp객체의 lastIndex속성을 이용해 검색 결과의 마지막인덱스 접근 가능 */
//
// 					var pos = matchArray.index;
// 					console.log('pos: ' + pos);
// 					if (pos >= 0) {
// 						var spannode = document.createElement('span');
// 						spannode.name='spnHighlight';
// 						if ( type.indexOf('K') > -1) {
// 							spannode.className = 'clsHighlightKwds';
// 						}
// 						else {
// 							spannode.className = 'clsHighlight';
// 						}
// 						if ( type.indexOf('B') > -1 ) {
// 							if ( type.indexOf('K') > -1) {
// 								spannode.style.backgroundColor = '#FFAD5B';
// 								spannode.style.color = '#000000';
// 								spannode.style.fontWeight = 'bold';
// 							} else {
// 								spannode.style.backgroundColor = '#13C7A3';
// 								spannode.style.color = '#000000';
// 								spannode.style.fontWeight = 'bold';
// 							}
// 						}
// 						try{
// 							var sbit = node.splitText( pos );
// 							sbit.splitText( matchArray[0].length );
// 							spannode.nodeValue = sbit.data;
// 							var sbitclone = sbit.cloneNode(true);
// 							spannode.appendChild(sbitclone);
// 							sbit.parentNode.replaceChild(spannode, sbit);
// 							skip = 1;
// 						} catch(e) {
//
// 						}
// 					}
// 				}
// 			} else {
// 				var posArr = [];
// 				var pos = -1;
// 				var stIdx = 0;
// 				var edIdx = node.data.length;
//
//
// 			}
// 		} else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
// 			var cnt = node.childNodes.length;
// 			if ( node.childNodes.length > 1000 ) cnt = 1000;
// 			for ( var i = 0; i < cnt; ++i) {
// 				i += innerHighlight(node.childNodes[i], pat, type);
// 			}
// 		}
// 		return skip;
// 	}
// 	return this.each(function() {
// 		innerHighlight(this, pat, type);
// 	});
// };


function Highlight() {
    loading_off();
    var searchs = searchkey.split(/\||\+|\s|\*|\"/);
    if (searchs.length > 0) setHighLight(searchs, 'S'); //검색어 하이라이트 처리

    var fileNameStr = [];
    fileNameStr.push(nvl(msgData.fileNameStr));

    var subjectStr = [];
    subjectStr.push(nvl(msgData.subjectStr));

    var bodyStr =  [];
    bodyStr.push(nvl(msgData.bodyStr));



    var fileNameStrs = '';
    if((fileNameStr[0].indexOf(',') > -1))  fileNameStrs =  fileNameStr[0].split(', ');
    else fileNameStrs = fileNameStr.map((r) => r);
    if(fileNameStrs != '') fileNameStrs = fileNameStr.map((r) => r);

    var subjectStrs = '';
    if((subjectStr[0].indexOf(',') > -1))  subjectStrs =  subjectStr[0].split(', ');
    else subjectStrs = subjectStr.map((r) => r);
    if(subjectStrs != '') subjectStrs = subjectStr.map((r) => r);


    var bodyStrs = '';
    if((bodyStr[0].indexOf(',') > -1))  bodyStrs =  bodyStr[0].split(', ');
    else bodyStrs = bodyStr.map((r) => r);
    if(bodyStrs != '') bodyStrs = bodyStrs.map((r) => r);


    if (fileNameStrs.length > 0) {
        if (searchkey.length == 0 || keywordHighlight == 'true') setFileNameHighLight(fileNameStrs, 'K'); //예약어 하이라이트 처리
    }
    if (subjectStrs.length > 0) {
        if (searchkey.length == 0 || keywordHighlight == 'true') setSubjectHighLight(subjectStrs, 'K'); //예약어 하이라이트 처리
    }
    if (bodyStrs.length > 0) {
        if (searchkey.length == 0 || keywordHighlight == 'true') setBodyHighLight(bodyStrs, 'K'); //예약어 하이라이트 처리
    }


}

function PatternHighlight() {
    loading_off();
    if (patternKyword.length == 0) return;

    for(let i = 0; i< patternKyword.length; i++){
       if (piHighlightList.includes(patternKyword[i].piid)){
           setPatternHighLight(patternKyword[i].kwds, 'K');
       }
    }
}


function isImageOk(img) {
    if (!img.complete) {
        return false;
    }
    if (typeof img.naturalWidth != "undefined" && img.naturalWidth == 0) {
        return false;
    }
    return true;
}

function setSubjectHighLight(defaultText, type) {
    var subject_obj = $("#subject");
    for (var i = 0; i < defaultText.length; i++) {
        var  splitText =  defaultText[i].split(' ');
        for (var j = 0; j < splitText.length; j++) {
            if (splitText[j] == '' ) continue;
            $(subject_obj).highlight(splitText[j], type);
        }
    }
}

function setBodyHighLight(defaultText, type) {
    var body_obj = $("#emassBody");
    for (var i = 0; i < defaultText.length; i++) {
        var  splitText =  defaultText[i].split(' ');
        for (var j = 0; j < splitText.length; j++) {
            if (splitText[j] == '' ) continue;
            $(body_obj).highlight(splitText[j], type);
        }
    }
}

function setPatternHighLight(defaultText, type) {
    var body_obj = $("#emassBody");
        var  splitText =  defaultText.split(',');
        for (var j = 0; j < splitText.length; j++) {
            if (splitText[j] == '' ) continue;
            $(body_obj).highlight(splitText[j], type);
         }
}


function setFileNameHighLight(defaultText, type) {
    var attachDiv_obj = $(".attachName");
    for (var i = 0; i < defaultText.length; i++) {
        var  splitText =  defaultText[i].split(' ');
        for (var j = 0; j < splitText.length; j++) {
            if (splitText[j] == '' ) continue;
            $(attachDiv_obj).highlight(splitText[j], type);
        }
    }
}

function setHighLight(defaultText, type) {
    var body_obj = $("#emassBody");
    var subject_obj = $("#subject");
    var srcipTd_obj = $("#srcipTd");
    var dstipTd_obj = $("#dstipTd");
    var userDiv_obj = $("#userDiv");
    var sendUserDiv_obj = $("#sendUserDiv");
    var receiveUserDiv_obj = $("#receiveUserDiv");
    var ccUserDiv_obj = $("#ccUserDiv");
    var bccUserDiv_obj = $("#bccUserDiv");
    var hostDiv_obj = $("#hostDiv");
    var attachDiv_obj = $("#attachDiv");
    for (var i = 0; i < defaultText.length; i++) {
        if (defaultText[i] == '') continue;
        $(body_obj).highlight(defaultText[i], 'B' + type);
        $(srcipTd_obj).highlight(defaultText[i], type);
        $(dstipTd_obj).highlight(defaultText[i], type);
        $(subject_obj).highlight(defaultText[i], type);
        $(userDiv_obj).highlight(defaultText[i], type);
        $(sendUserDiv_obj).highlight(defaultText[i], type);
        $(receiveUserDiv_obj).highlight(defaultText[i], type);
        $(ccUserDiv_obj).highlight(defaultText[i], type);
        $(bccUserDiv_obj).highlight(defaultText[i], type);
        $(hostDiv_obj).highlight(defaultText[i], type);
        $(attachDiv_obj).highlight(defaultText[i], type);
    }
}


//키워드 위치 이동
var currentKeywordFocus = 0;

function nextKeyword() {
    focusKeyword('N');
}

function prevKeyword() {
    focusKeyword('P');
}


function focusKeyword(type) {
    var current_idx = -1;
    var spnHighlight = $('#emassBody').find('body .clsHighlightKwds,.clsHighlight');
    $(spnHighlight).each(function (index, item) {
        if ($(this).attr('focus_current') == 'Y') {
            $(this).css('color', '#000');
            $(this).attr('focus_current', '');
            current_idx = index;
        }
    });
    if (current_idx == -1) {
        current_idx = 0;
    } else {
        if (type == 'N') {
            current_idx++;
        } else {
            current_idx--;
        }
    }
    if (current_idx < 0) current_idx = spnHighlight.length - 1;
    else if (current_idx >= spnHighlight.length) current_idx = 0;

    spnHighlight[current_idx].focus();
    spnHighlight[current_idx].scrollIntoView(true);
    spnHighlight[current_idx].style.color = "#fff";
    spnHighlight[current_idx].style.color = "#fff";
    spnHighlight[current_idx].setAttribute('focus_current', 'Y');
}

function setRead(msgData) {
    return
    var ctime = msgData.ctime.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "");
    var ctime_yyyymmdd = ctime.substring(0, 8);
    var ctime_yyyymm = ctime.substring(0, 6);
    var ctime_yyyy = ctime.substring(0, 4);
    var ctime_hh = ctime.substring(8, 10);

    ui.get({
        url: 'setRead.xcn',
        msgId: msgId,
        ctime: ctime,
        ctime_yyyymmdd: ctime_yyyymmdd,
        ctime_yyyymm: ctime_yyyymm,
        ctime_yyyy: ctime_yyyy,
        ctime_hh: ctime_hh,
        busiCd: msgData.busiCd,
        ipBusicd: msgData.ipBusicd,
        svc: msgData.svc,

        success: function (data, total) {

        },
        error: function (status, message) {
            ui.alertMsg(message);
        },
        complete: function () {
        }
    });
}

function showRPeriodBody(x, y) {
    $("#periodBodyMenu ul").css('display', '');

    if (y + $('#periodBodyMenu').height() > $(window).height()) y -= $('#periodBodyMenu').height();

    $('#periodBodyMenu').css({
        "top": (y + 50) + "px",
        "left": (x - $('.nav-side-menu').width()) + "px",
        "visibility": "visible"
    });

    $('#periodBodyMenuCloseBtn').unbind("mousedown").bind("mousedown", function () {
        $('#periodBodyMenu').css({"visibility": "hidden"});
    });
}

function updateEmsFeedback(feedback) {
    ui.get({
        url: 'updateEmsFeedback.xcn',
        msgId: msgId,
        feedback: feedback,
        success: function (data, total) {

        },
        error: function (status, message) {
            ui.alertMsg(message);
        },
        complete: function () {
        }
    });
}


function getMsgPtns() {
    return msgPtns;
}