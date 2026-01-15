<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.xcurenet.config.service.ConfigAdminService" %>
<%@ page import="com.xcurenet.common.util.SpringContextUtil" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.xcurenet.audit.service.Operation" %>
<%@ page import="com.xcurenet.config.service.ConfigAdminVO" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ page import="java.util.Locale" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/fragments/messageScript.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/scrolltabs.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/message.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/messageContent.css"/>"/>


<script type="text/javascript" src="<c:url value="/js/jquery.scrolltabs.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.mousewheel.js"/>"></script>
<%
	ConfigAdminService configAdminService = SpringContextUtil.getBean(ConfigAdminService.class);
	
	JSONObject param = Common.getParam(request);
	String gridInit = Common.nvl(param.get("gridInit"));
	String filterSeq = Common.nvl(param.get("filterSeq"));
	String conditionParam = Common.nvl(param.get("conditionParam"));
	String adminType = Common.getAdminType(session);
	String firstAdminYn = Common.getFirstAdminYn(session);
	String infoFeedbackMode = Config.getString("info.feedback.mode");
	String infoFeedbackYn = Common.getInfoFeedbackYn(session);
	String adminId = Common.getAdminId(session);
	ConfigAdminVO configAdminVo = configAdminService.getConfAdmin("message.overlap.use", adminId);
	String overlapUse = "";
	boolean infoFeedbackLlm = Config.getBoolean("info.feedback.llm");
	if(Common.isNotEmpty(configAdminVo)) overlapUse = Common.nvl(configAdminVo.getVal());
	boolean infoFeedbackConf = Config.getBoolean("info.feedback.used");
	boolean infoHynixConf = Config.getBoolean("info.hynix.used");
	
	String op_attach_save = Operation.ATTACH_SAVE.getOperation();
	String op_body_save = Operation.BODY_SAVE.getOperation();
	
	long export_maxCount = Config.getLong("ui.export.maxCount", 1000000);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS AI - <s:message code="DATA_MONITOR.MESSAGE_INFO"/></title>
	<style type="text/css">



        .scroll_tab_left_button, .scroll_tab_right_button {margin-top:4px!important;}
        .scroll_tabs_container .scroll_tab_left_button_disabled {margin-top:4px!important;}
        .scroll_tabs_container .scroll_tab_right_button_disabled {margin-top:4px !important;}
        .slick-column-name input[type=checkbox], slick-cell input[type=checkbox] {margin-top:6px;}
        #messageNewGrid_statusbar {padding:0 12px;}
        .status_rownum {margin-top:10px;}
        html, body {
            min-width: 100px !important;
        }

        .status_rownum{
            margin-top:7px; !important;
        }


        ::-webkit-scrollbar {
            width: 8px;  /* 세로축 스크롤바 폭 너비 */
            height: 6px;  /* 가로축 스크롤바 폭 너비 */
        }

        ::-webkit-scrollbar-thumb {
            background: #999; /* 스크롤바 막대 색상 */
            border-radius: 12px 12px 12px 12px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background-color:#999;
        }

        ::-webkit-scrollbar-track {
            /*background-color:transparent;  스크롤바 뒷 배경 색상 */
        }
        .slick-cell {
            line-height: 18px;
        }
        .slick-cell input[type=checkbox] {
            margin-top: 2px;
        }
        .readY, .readN {
            background-size: 20px 17px;
            margin-top: -1px;
        }
        .subject_readY, .subject_readN, .slick-cell .glyphicon-new-window.new-window {
            position: relative;
        }
        .readY {
            margin-top: 0px;
        }
        .busiCounts{
	        font-weight: bold;
            display: inline-flex; color:#333;
            border:1px solid #ddd;
            padding:3px 8px;
            border-radius: 20px;
            margin-left:-4px;
            margin-top:4px;
        }
        .busiCounts:hover{
            color:#333;
            text-decoration: underline !important;
        }
        .busiCounts:hover > i, .busiCounts:hover > span{
            opacity: 1 !important;
        }

        a.busiCounts i{
            color:#253f56
        }

        .tab_selected > a{
            font-weight: bold;
            color:#fff;
            background-color: #1C64D3;
            padding:4px 12px 3px;
            border-radius: 16px;
            isolation: isolate;
            margin-top:4px;
            border:none;
        }

        .tab_selected > a:hover {color:#fff;}

        .tab_selected > a > i{
            color:#5cb85c;
        }
        a:hover, a:focus{
            text-decoration: none;


        }

        .noSearch{
            cursor:default !important;
        }
        .fa-angle-right {
        }


        .highlightSearch {
            background-color:#13C7A3;
        }

        .highlightKeyword {
            background-color:#FFAD5B;
        }

        #contextMenu {
            background: #242330;
            border: 1px solid gray;
            display: inline-block;
            min-width: 100px;
            -moz-box-shadow: 2px 2px 2px silver;
            -webkit-box-shadow: 2px 2px 2px silver;
            z-index: 99999;
        }
        #contextMenu ul{
            padding-left:0;
            margin-bottom:0;
        }
        #contextMenu ul li {
            padding: 3px 5px;
            cursor: pointer;
            list-style: none outside none;
            background-color: #fff;
            font-size: 11px;
            color: #000;
            width: 130px;
            border-bottom: 1px dotted #B3BABF;
        }
        #contextMenu li:hover {
            background-color: #7C98B4;
            color: #fff;
            font-weight: bold;
        }
	</style>
</head>
<body class="mini-navbar msgBody">
<div id="replace_html" style="display: none;"></div>
<div class="msg_cont_container">
	<div id="mail_list" class="divList unselectable" style="width: 100%; height: 100%; display: block;position: absolute;top: 0;left: 0;bottom: 0;">
		<div style="height: 98%;">
			<div id="busiCntArea" style="padding-left: 5px;padding-right: 15px; margin-left:6px; height:36px;">
				<span class="tab_selected noSearch"><a href="javascript:;" class="busiCounts active" data-busicd=""><!--<i class="fa fa-angle-right" aria-hidden="true"></i> --><s:message code="common.msg.all"/></a></span>
			</div>
			<div id="messageNewGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px;min-height:200px;height:calc(100% - 65px);"></div>
			<input type="hidden" id="searchTime" />
		</div>
	</div>
</div>
<input type="hidden" id="searchStrInput" />
<div id="contextMenu" style="display:none;position:absolute">
	<ul>
		<li style="background-color:#242330;color:#fff;font-weight: bold;cursor:default;"><s:message code="common.msg.menu"/>
			<button type="button" class="close" data-dismiss="modal" aria-label="Close" style="font-size:15px;color:#fff;text-shadow:0 1px 0 #000; opacity:0.7;margin-top:3px;" id="contextMenuCloseBtn">
				<span aria-hidden="true">&times;</span>
			</button>
		</li>
	</ul>
	<ul>
		<li style="background-color:#999;color:#fff;font-weight: bold;cursor:default; padding-left: 5px;"><s:message code="filterInfo.management"/></li>
	</ul>
	<ul>
		<li onclick="saveMsgBtn()" style=" padding-left: 5px;"><div class="msgFolderIcon"></div>&nbsp;<s:message code="filterInfo.setMsgFolder"/></li>
	</ul>
	<% if(infoFeedbackYn.equals("Y") && infoFeedbackConf && !infoFeedbackLlm) {%>
	<ul>
		<li style="background-color:#999;color:#fff;font-weight: bold;cursor:default; padding-left: 5px;"><s:message code="condition.feedback"/> <s:message code="common.msg.setting"/></li>
	</ul>
	<ul>
		<li onclick="setFeedback(0);" style="padding-left: 3px;"><div class="feedbackCorrect"></div>&nbsp;<s:message code="condition.info.feedback0"/></li>
		<li onclick="setFeedback(1);" style="padding-left: 5px;"><div class="feedbackcommon"></div><s:message code="condition.info.class1"/></li>
		<li onclick="setFeedback(2);" style="padding-left: 5px;"><div class="feedbackInNotOpen"></div><s:message code="condition.info.class2"/></li>
		<li onclick="setFeedback(3);" style="padding-left: 5px;"><div class="feedbackInOpen"></div><s:message code="condition.info.class3"/></li>
		<li onclick="setFeedback(4);" style="padding-left: 5px;"><div class="feedbackInCorrect"></div><s:message code="condition.info.class4"/></li>
		<li onclick="setFeedback(9);" style="padding-left: 5px;"><div class="feedbackDefer"></div>&nbsp;<s:message code="condition.info.feedback9"/></li>
	</ul>
	<%} %>
</div>
<%-- 	<iframe src="<c:url value="/ems/overlapInfoPop.do"/>" id="overlapPop" class="overlapPop" target="_blank"></iframe> --%>
</body>
<script type="text/javascript">
    var infoFeedbackYn = '<%=infoFeedbackYn%>';
    var infoFeedbackConf = '<%=infoFeedbackConf%>';
    var infoHynixConf = '<%=infoHynixConf%>';
    var infoFeedbackLlm = '<%=infoFeedbackLlm%>';
    var infoFeedbackMode = '<%=infoFeedbackMode%>';
    var gridInit = "<%=gridInit%>";
    var overlapUse='<%=overlapUse%>';
    var filterValData;
    var busiScrollTabs;
    var tabId='';
    var tabType;
    var searchedFlag = false;
    var pageType = '';

    $(document).ready(function() {
        document.onclick = function(e){ parent.$('.dropdown-backdrop').click(); }

        $('#contextMenuCloseBtn').click(function(){
            $('#contextMenu').hide();
        });
        var msgBodyObj = parent.document.getElementsByClassName('msgBody');
        var conObj = parent.getIframeBodyObj();
        $(conObj,msgBodyObj).click(function(){
            if($('#contextMenu').css('display')=='block')$("#contextMenu").hide();
        });
        $(msgBodyObj).click(function(){
            if($('#contextMenu').css('display')=='block')$("#contextMenu").hide();
        });

// 	getOverLapUse();
        initServiceTab();
        setTimeout(function(){parent.ui.off();}, 1000)
        if(gridInit == 'true') initGrid();

        parent.setAddTabFlag(false);
        parent.readyFlag = true;
    });

    function saveMsgBtn(){
        parent.$('#saveMsgData').click();
        $('#contextMenu').hide();
    }

    function setFeedback(feedback){
        var msgids = grid.getSelectedKey('msgid');
        if( msgids.length == 0 ){
            alert('<s:message code="condition.message.feedback.selectMsg"/>');
            return;
        }

        ui.get({
            url : 'updateEmsFeedback.xcn',
            msgId : msgids.join(','),
            feedback : feedback,
            success : function(data, total) {
                setGridFeedbackMulti(feedback);
            },
            error : function(status, message) {
                ui.alertMsg(message);
            },
            complete : function() {
                $('#contextMenu').hide();
            }
        });
    }

    function initServiceTab(){
        if( busiScrollTabs != undefined) busiScrollTabs.destroy();
        busiScrollTabs = $('#busiCntArea').scrollTabs({
            //scroll_distance: 300,
            //scroll_duration: 300,
            //left_arrow_size: 26,
            //right_arrow_size: 26,
            click_callback: function(e){
                getSubList('', $(this).find('.busiCounts').attr('data-svc1'), $('#searchTime').val() );
            }
        });
    }


    /**
     * 데이터 조회
     */
    var searchFlag=true;
    var bodysnippetVal = '';
    var summaryVal = '';
    function getList(flag, filterVal){
        if(!searchFlag) return;
        searchFlag = false;
        var researchCnt = 0;

        if ( flag == undefined || flag == '') {
            if(tabType=='D' && parent.$("input:checkbox[id='researchCheckbox']").is(":checked")) {
                researchCnt = filterValData.conditions.length-1;
            }
            filterValData = filterVal;
            /* 		console.log("getList filterValData : " + filterValData);
					console.log("getList filterValData1 : " + JSON.stringify(filterValData)); */
            grid.data.length = 0;
            grid.overlapData.length = 0;
            grid.rtnNextPageFunc = getList;
            grid.loadingPage = 0;
            /* console.log("getList filterValData2 : " + JSON.stringify(filterValData)); */

        } else {
            grid.loadingPage++;
        }
		let searchAfter = null;
		if(grid.loadingPage > 0) {
			searchAfter = grid.getValue(grid.data.length-1, 'ctime') + ',' + grid.getValue(grid.data.length-1, 'msgid');
			console.log("searchAfter : " + searchAfter);
		}
        grid.on();
        ui.postJson({
            url : 'getList.xcn',
            data : JSON.stringify( filterValData ),
            pageType : pageType,
            offset : grid.data.length + grid.overlapData.length,
            limit : grid.pageSize,
	        searchAfter : searchAfter,
            overlap : overlapUse,
            success : function(data, total) {

                searchedFlag = true;
                grid.appendData(data.emass);
                if ( grid.loadingPage == 0 ) grid.Select(-1,-1);

                parent.setResultCnt(tabId, total.comma());
                parent.changeTabName(tabId, '', researchCnt);
                setServiceGroupCntInfo(data.facet, total);
                $('#searchTime').val(data.searchTime);

                var query = filterValData.conditions[0].query;
                /* console.log("getList filterValData query1 : " + query); */
                if( query != '' && query != undefined){
                    parent.$('#researchCheckbox').prop('disabled', true);
                }else{
                    parent.$('#researchCheckbox').prop('disabled', false);
                }


                //parent.setValueById('solrQueryText', data.excuteQuery);

                /* selectedTab.find('.resultCnt').html('('+addCommas(total)+')');
				selectedTab.find('.resultCntHidden').html(total);
				$('#'+obj.contentId).find('.solrQueryResultText').val(data.excuteQuery);

				selectedTab.find('img').css('display', 'none');
				rsKey[selectedTabIdx].total = total;
				rsKey[selectedTabIdx].searchTime = data.searchTime;

				if($('#'+rsKey[selectedTabIdx].contentId).find('.tabValue').attr('data-filterType') == 'Q') $('#researchCheckbox').prop('disabled', true);
				else $('#researchCheckbox').prop('disabled', false); */
            },
            error : function(status, message) {
                alert(message);
            },
            complete : function() {
                grid.off();
                searchFlag = true;
            }
        });

    }

    var searchSubFlag=true;
    function getSubList(flag, svc1, searchTime){
        if(!searchSubFlag) return;
        searchSubFlag = false;

        if ( flag == undefined || flag == '') {
            filterValData.addSvcGroup = svc1;
            filterValData.searchTime = searchTime;

            grid.data.length = 0;
            grid.overlapData.length = 0;
            grid.rtnNextPageFunc = getSubList;
            grid.loadingPage = 0;
        } else {
            grid.loadingPage++;
        }
        //changTabHeader(obj.data);

	    let searchAfter = null;
	    console.log("grid.loadingPage : " + grid.loadingPage);
	    if(grid.loadingPage > 0) {
		    searchAfter = grid.getValue(grid.data.length-1, 'ctime') + ',' + grid.getValue(grid.data.length-1, 'msgid');
		    console.log("searchAfter : " + searchAfter);
	    }

        grid.on();
        ui.postJson({
            url : 'getList.xcn',
            data : JSON.stringify( filterValData ),
            pageType : pageType,
            offset : grid.data.length + grid.overlapData.length,
            limit : grid.pageSize,
            overlap : overlapUse,
	        searchAfter : searchAfter,
            success : function(data, total) {
                grid.appendData(data.emass);
                if ( grid.loadingPage == 0 ) grid.Select(-1,-1);

                parent.setValueById('solrQueryText', data.excuteQuery);
            },
            error : function(status, message) {
                alert(message);
            },
            complete : function() {
                grid.off();
                searchSubFlag = true;
            }
        });

    }

    function setServiceGroupCntInfo(data, total){
        busiScrollTabs.clearTabs();
        busiScrollTabs.refreshState();
        busiScrollTabs.addTab('<span class="tab_selected"><a href="javascript:;" class="busiCounts active" data-svc1=""> <s:message code="common.msg.all"/><span class="busiCnt">('+total.comma()+')</span></a></span>');
        if(data != null) {
            for (var i = 0; i < data.length; i++) {
                busiScrollTabs.addTab('<span><a href="javascript:;" class="busiCounts" data-svc1="' + data[i].name + '"><!--<i class="fa fa-angle-right" aria-hidden="true"></i>--> ' + parent.getSvc1Nm(data[i].name) + '<span class="busiCnt">(' + data[i].count.comma() + ')</span></a></span>');
            }
        }
    }

    function arrayToString( array ){
        if( array == null || array == undefined ) return "";
        else{
            return array.toString();
        }
    }
    function highlightSearchStr(rtnVal, column){
        var rtnValue = '';
        var QnoSearchPattern = /[\s\"?/|()+*]/;
        var DnoSearchPattern = /[+*?]/;

        try{
	        if(rtnVal == undefined || rtnVal == '') return;
            var searchType = '';
            var searchStr = '';
            var search = '';

            if(tabType == 'D') {
                searchType = parent.$('#searchField').val();
            }
            searchStr = searchKeyword();
            search = searchStr;

            if(column != "subject") {
                rtnVal = rtnVal.replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
            }
            if(searchStr == "") {
                return rtnVal;
            } else if (searchStr.length <= 2) {
                if(tabType == 'D' && DnoSearchPattern.test(searchStr)) {
                    return rtnVal;
                }
                else if(tabType == 'Q' && QnoSearchPattern.test(searchStr)) {
                    return rtnVal;
                }
            }

            var chk = false;
            if(searchType == "" || searchType == null) {
                chk = true;
            } else if (searchType == "sender_str" || searchType == "sname"  || searchType == "org_sender_str" || searchType == "org_sname"){
                if(column == "sender") chk = true;
            } else if (searchType == "recvs" || searchType == "recvs_name"){
                if(column == "recvs" || column == "to" || column == "cc" || column == "bcc") chk = true;
            } else if (searchType == "to tname"){
                if(column == "to" || column == "column") chk = true;
            } else if (searchType == "cc cname"){
                if(column == "cc" || column == "column") chk = true;
            } else if (searchType == "bcc bname"){
                if(column == "bcc" || column == "column") chk = true;
            } else if (searchType == "subject"){
                if(column == "subject" ) chk = true;
            } else if (searchType == "body"){
                if(column == "body" ) chk = true;
            } else if (searchType == "attachname attachname_str"){
                if(column == "attachname" ) chk = true;
            } else {
                if(searchType == column) chk = true;
            }


            if(chk) {
                var searchArray = [];
                search = search.trim();
                if(search.indexOf("\"") == 0 && search.charAt(search.length-1) == "\"" && nvl(search.match(/"/g)).length == 2) {
                    searchArray[0] = search.substring(1, search.length-1);
                } else {
                    search = search.replaceAll('\\|',' ');
                    search = search.replaceAll("\\+", "").replaceAll("\\?", "");
                    search = search.replaceAll("\"", "");
                    search = search.replaceAll("\\(", "").replaceAll("\\)","");
                    searchArray = search.split(" ");

                }
                var obj = $.parseHTML('<div>'+rtnVal+'</div>');
                for(var i = 0; i < searchArray.length; i++) {
                    var searchStr =  searchArray[i];
                    if(!(searchStr.substr(0,1) == '/' && searchStr.substr(searchStr.length - 1) == '/')) {
                        searchStr = searchStr.replaceAll("\\(","").replaceAll("\\)","");
                        if( searchStr == ' ' || searchStr == '') continue;
                        $(obj).highlight(searchStr, 'S');
                        rtnValue =  $(obj).html();
                    }
                    else {
                        var solrQueryText = searchStr;
                        var re = new RegExp(solrQueryText, 'ig');
                        var matchArray;
                        var first = 0;
                        var last = 0;
                        var resultString = '';

                        while ( (matchArray = re.exec(rtnVal)) != null ) {
                            last = matchArray.index;

                            // 일치하는 모든 문자열을 연결
                            resultString += rtnVal.substring(first, last);

                            // 일치하는 부분에 강조 스타일이 지정된 class 추가
                            resultString += "<span class='highlightSearch'>" + matchArray[0] + "</span>";
                            first = re.lastIndex;
                            // RegExp객체의 lastIndex속성을 이용해 검색 결과의 마지막인덱스 접근 가능
                        }


                        resultString += rtnVal.substring(first, rtnVal.length);
                        rtnVal = resultString;
                        rtnValue = resultString;
                    }
                }


            } else {
                rtnValue =  rtnVal;
            }
        } catch(e){
            rtnValue =  rtnVal;
            console.log("highlightSearchStr Error..");
        }
        return rtnValue;
    }
    function highlightKeyword (rtnVal, keyWords) {
        var rtnValue = '';
        try{
            var obj = $.parseHTML('<div>'+rtnVal+'</div>');
            for(var i = 0; i < keyWords.length; i++) {
                var keyWord = keyWords[i];
                $(obj).highlight(keyWord, 'K');
            }
            rtnValue = $(obj).html();
        }catch(e){
            rtnValue =  rtnVal;
            console.log("highlightKeyword Error..");
        }

        return rtnValue;
    }


    jQuery.fn.highlight = function(pat, type) {
        function innerHighlight(node, pat, type) {
            var skip = 0;
            if (node.nodeType == 3) {
                var pos = node.data.toUpperCase().indexOf(pat);
                if (pos >= 0) {
                    var spannode = document.createElement('span');
                    if ( type.indexOf('K') > -1) {
                        spannode.className = 'highlightKeyword';
                    }
                    else {
                        spannode.className = 'highlightSearch';
                    }
                    if ( type.indexOf('B') > -1 ) {
                        if ( type.indexOf('K') > -1) {
                            spannode.style.backgroundColor = '#ccc';
                            spannode.style.color = '#000000';
                            spannode.style.fontWeight = 'bold';
                        } else {
                            spannode.style.backgroundColor = '#eee';
                            spannode.style.color = '#000000';
                            spannode.style.fontWeight = 'bold';
                        }
                    }

                    var sbit = node.splitText( pos );
                    sbit.splitText( pat.length );
                    spannode.nodeValue = sbit.data;
                    var sbitclone = sbit.cloneNode(true);
                    spannode.appendChild(sbitclone);
                    sbit.parentNode.replaceChild(spannode, sbit);
                    skip = 1;
                }
            } else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
                for ( var i = 0; i < node.childNodes.length; ++i) {
                    i += innerHighlight(node.childNodes[i], pat, type);
                }
            }
            return skip;
        }
        return this.each(function() {
            innerHighlight(this, pat.toUpperCase(), type);
        });
    };

    var selectOverlapData;
    function overlapInfoViewer(row, selectedGrid){
        selectOverlapData = grid.getValue(row, 'overlap');
        if(grid.getValue(row, 'overlap') == '') return;

        window.open("","overlapInfoPop","width=1100, height=620");

        var frmObj = $('<form>',{'id': 'fm_formIO', 'action': contextRoot+'/ems/overlapInfoPop.do', 'method': 'POST', 'target': 'overlapInfoPop'});
        var inpObj = $('<input>',{'name':'body', 'value': JSON.stringify(selectOverlapData.slice(0, 100))});
        var inpObj2 = $('<input>',{'name':'total', 'value': selectOverlapData.length});

        frmObj.append(inpObj);
        frmObj.append(inpObj2);
        $(document.body).append(frmObj);
        $("#fm_formIO").submit();

        inpObj.remove();
        inpObj2.remove();
        frmObj.remove();
// 	$('#overlapPop').css({'width':'1100px', 'height':'620px'}).show();
// 	var url = '<c:url value="/ems/overlapInfoPop.do?data='+encodeURI(JSON.stringify( overlapData ))+'"/>';
// 	return fnOpenWindow(url, 'overlapInfoPop', 1100, 620, 'resize');
    }

    function sendOverlapData(offset, limit){
// 	var offset = offset;
// 	var limit = limit;
        overlapPop.setOverlapData(selectOverlapData.slice(offset, limit));

    }

    function regexpInfoViewer(row, selectedGrid){
        var msgid = grid.getValue(row, 'msgid');
        if(grid.getValue(row, 'pi_total') == '') return;

        var url = '<c:url value="/ems/regexpInfoPop.do?msgId='+msgid+'"/>';
        return fnOpenWindow(url, 'regexpInfoPop', 1100, 620, 'resize');
    }

    function userInfoViewer(row, type, selectedGrid){
        var msgid = grid.getValue(row, 'msgid');
        if(grid.getValue(row, type) == '') return;

        var url = '<c:url value="/ems/userInfoPop.do?msgId='+msgid+'&type='+type+'"/>';
        return fnOpenWindow(url, type+'InfoPop', 1000, 370, 'resize');
    }

    function interestUserInfoViewer( row, selectedGrid ){
        var userid = grid.getValue(row, 'userid');
        if(grid.getValue(row, 'userid') == '') return;
        var url    = '<c:url value="/ems/interestUserInfoPop.do?userid='+userid+'"/>';
        var pop = fnOpenWindow(url, 'interestUserInfoPop', 1015, 400, 'resize');
    }

    function fileInfoViewer( row, selectedGrid ){
        var msgid = grid.getValue(row, 'msgid');
        if(grid.getValue(row, 'attachcnt') == '') return;

        var url    = '<c:url value="/ems/fileInfoPop.do?msgId='+msgid+'&searchKey=' + encodeURI(searchKeyword()) + '"/>';
        var pop = fnOpenWindow(url, 'fileInfoPop', 1015, 400, 'resize');
    }

    function ocrFileInfoViewer( row, selectedGrid ){
        var msgid = grid.getValue(row, 'msgid');
        if(grid.getValue(row, 'ocr_attach_cnt') == '') return;

        var url    = '<c:url value="/ems/fileInfoPop.do?msgId='+msgid+'&searchKey='+ encodeURI(searchKeyword()) +'"/>';
        var pop = fnOpenWindow(url, 'ocrFileInfoPop', 1015, 400, 'resize');
    }

    /**
     * 기본검색의 검색어와, 고급검색어의 검색어를 구분하여 반환한다.
     * 하일라이팅을 위한 처리
     */
    function searchKeyword() {
        return tabType == 'D' ? parent.$('#searchStrInput').val() : parent.$('#searchQueryStrInput').val();
    }

    function viewer_open( row, selectedGrid ){
        var msgid = grid.getValue(row, 'msgid');
        var bodySize = grid.getValue(row, 'bodySizeStr');
        var bodySizeNum = bodySize.substr(0, bodySize.indexOf(' '));
        
        if(parent){
            var obj = parent.getIframeBodyObj();
            var kHigh = parent.keywordHighlight;
            var hostQuery = parent.hostQuery;
            obj.getMessage(msgid, searchKeyword(), bodySizeNum, kHigh.toString(), hostQuery.toString()); //동의서 아이디
            obj.$('#detailPatternDiv, #imgPreviewDiv').hide();
            obj.initHighlight();
        }else{
            openMessageBodyPop( grid.id, msgid, searchKeyword(), bodySizeNum);
        }

		/* 읽음 처리 '열람' 컬럼 Show/hide 여부 */
		if (grid.ColIndex('readYn') == -1) {
			var data = grid.getRowData(row);
			data.readYn = 'Y';

			grid.grid.invalidateRow(row);
			grid.grid.render();
		} else {
			grid.setValue(row, grid.ColIndex('readYn'), 'Y');
		}

    }

    var popWin;
    function viewer_openPop( row, selectedGrid ){
        var msgid = grid.getValue(row, 'msgid');
        var bodySize = grid.getValue(row, 'bodySizeStr');
        var bodySizeNum = bodySize.substr(0, bodySize.indexOf(' '));

        popWin = openMessageBodyPop( grid.id, msgid, searchKeyword(), bodySizeNum);

		var readYn = grid.getValue(row, 'readYn');
		grid.setValue(row, 'readYn', 'Y');
    }

    function viewer_openFocus(row, selectedGrid ){
        if(popWin){
            var msgid = grid.getValue(row, 'msgid');
            popWin.getMessage(msgid, searchKeyword());
        }
    }

    function setGridFeedback(value){
        var data = grid.getRowData(grid.Row);
        data.ml_confd_feedback = value;
        //grid.setValue(grid.Row, grid.ColIndex('ml_confd_feedback_label'), value);
        grid.setValue(grid.Row, grid.ColIndex('ml_confd_feedback'), value);
    }

    function setGridFeedbackMulti(value){
        var idxArr = grid.getSelectedIndex();
        for(var i = 0; i < idxArr.length; i++ ) {
            var data = grid.getRowData(idxArr[i]);
            data.ml_confd_feedback = value;
            //grid.setValue(idxArr[i], grid.ColIndex('ml_confd_feedback_label'), value);
            grid.setValue(idxArr[i], grid.ColIndex('ml_confd_feedback'), value);
        }
    }

    function setGridInfoMulti(value, value1){
        var idxArr = grid.getSelectedIndex();
        for(var i = 0; i < idxArr.length; i++ ) {
            var data = grid.getRowData(idxArr[i]);
            data.ml_confd_class = value;
            data.ml_confd_prob = value1;
            //grid.setValue(idxArr[i], grid.ColIndex('ml_confd_feedback_label'), value);
            grid.setValue(idxArr[i], grid.ColIndex('ml_confd_class'), value);
            grid.setValue(idxArr[i], grid.ColIndex('ml_confd_prob'), value1);
        }
    }

    function viewer_newOpen(row, selectedGrid){
        var msgid = grid.getValue(row, 'msgid');
        var bodySize = grid.getValue(row, 'bodySizeStr');
        var bodySizeNum = bodySize.substr(0, bodySize.indexOf(' '));

        openMessageBodyPop( '', msgid, searchKeyword(), bodySizeNum);

		var readYn = grid.getValue(row, 'readYn');
		grid.setValue(row, 'readYn', 'Y');
    }

    function setReadDisplayChangeRootmtr( rootmtr ){
        setReadDisplayChangeRootmtr( rootmtr, null);
    }

    function setReadDisplayChangeRootmtr( rootmtr, srcip){
        for( var i=0; i<grid.Rows; i++ ){
            if( grid.getValue(i, 'xrootmtr') == rootmtr){
                if( srcip != null && grid.getValue(i, 'srcip') ==  srcip){
					grid.setValue(i, 'readYn', 'Y');
                }
            }
        }
    }

    function prevMsg( ) {
        var row = 0;
        if( grid.Row > 0 ) {
            row = --grid.Row;

            /* if(popWin) viewer_openFocus(row);
			else viewer_open(row); */

            grid.Select(row, grid.Col);
            return true;
        }
        return false;
    }

    function nextMsg( ) {
        var row = 0;
        if( grid.Row < grid.Rows - 1 ) {
            row = ++grid.Row;

            /* if(popWin) viewer_openFocus(row);
			else viewer_open(row); */

            grid.Select(row, grid.Col);

            /* 문서상세보기 next button으로 목록 이동시 재검색 방지 */
            // if( grid.Row == grid.Rows - 2  ){
            // 	getList( true );
            // }

            return true;
        }
        return false;
    }

    function alert(msg){
        parent.alert(msg);
    }

    // var overlapUse='';
    // function getOverLapUse(){
    // 	ui.get({
    // 		url : 'getConfAdmin.xcn',
    // 		confId : 'message.overlap.use',
    // 		success : function(data, total) {
    // 			if(data == null || data == undefined) overlapUse = 'N';
    // 			else overlapUse = data.val;
    // 		},
    // 		error : function(status, message) {
    // 			ui.alertMsg(message);
    // 		},
    // 		complete : function() {
    // 			if(gridInit == 'true') initGrid();
    // 		}
    // 	});
    // }

    var grid;
    function initGrid(){
        if( grid != undefined ) return;

        grid = new Xgrid('messageNewGrid', contextRoot, 20);
        grid.onCheckBox();
        grid.autoNumber();
        grid.colAdd('msgid', '<s:message code="common.msg.msgid"/>', 100, 'left', false, 'nomal');
        grid.colAdd('epmsg_type', '<s:message code="condition.epmsgType.list"/>', 100, 'center', true, 'nomal');
        grid.colAdd('xrootmtr', '<s:message code="common.msg.xrootmtr"/>', 100, 'left', true, 'nomal');

        if(overlapUse == 'Y') {
            grid.colAdd('overlap', '<s:message code="common.overlap.count"/>', 170, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
                var overlapData = value;
                if (overlapData == undefined || overlapData.length == '0') return '';
                else return overlapData.length.comma();
            });
        }
        grid.colAdd('interestUserYn', '<s:message code="message.msg.interest"/>', 60, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
            if (value == 'N') return '';
            /* if (value == 'Y') return '<div class="interestUserCheck"></div>';
			else if (value == 'N') return ''; */
            var value = grid.getValue(row, 'interestGroupColor')
            var str = '';
            if(value != null && value != undefined && value != ''){
                var v = value.split(',');
                for(var i = 0; i < v.length; i++) {
                    str += '<span style="display:inline-block; width: 11px; height: 11px; margin-left: 1px; margin-top:4px; background-color:'+v[i]+'"></span>';
                }
            }
            return str;
        });
        grid.colAdd('readYn', '<s:message code="condition.read"/>', 40, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
            if (value == 'Y') return '<div class="readY"></div>';
            else if (value == 'N') return '<div class="readN"></div>';
            else return '-';
        });

        if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ) {
            var ml_confd_class_str = infoHynixConf == 'true' ? '<s:message code="condition.itype"/>' : '<s:message code="condition.infotype"/>';
            var ml_confd_feedback_str = infoHynixConf == 'true' ? '<s:message code="condition.secretFeedback"/>' : '<s:message code="condition.feedback"/>';
            var ml_confd_prob_str = infoHynixConf == 'true' ? '<s:message code="condition.sprob"/>' : '<s:message code="condition.prob"/>';
            grid.colAdd('ml_confd_class', ml_confd_class_str, 170, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
	            if (infoFeedbackMode == 'E'){
		            if (value == '3') return '<s:message code="condition.info.class4"/>';
		            else if (value == '4') return '<s:message code="condition.info.class3"/>';
		            else if (value == '2') return '<s:message code="condition.info.class2"/>';
		            else if (value == '1') return infoHynixConf == 'true' ? '<s:message code="condition.info.Y"/>' : '<s:message code="condition.info.class1"/>';
		            else if (value == '0') return '<s:message code="condition.info.N"/>'; // for hynix (대외비 문서)
		            else return '<s:message code="common.msg.noinfo"/>';
	            }else {
		            if (value == '4') return '<s:message code="condition.info.class4"/>';
		            else if (value == '3' || value == '2') return '<s:message code="condition.info.class3"/>';
		            else if (value == '1') return infoHynixConf == 'true' ? '<s:message code="condition.info.Y"/>' : '<s:message code="condition.info.class1"/>';
		            else if (value == '0') return '<s:message code="condition.info.N"/>'; // for hynix (대외비 문서)
		            else return infoFeedbackLlm == 'true' ? '' : '<s:message code="common.msg.noinfo"/>';
	            }
            });
			if (infoFeedbackLlm == 'false') {
		        grid.colAdd('ml_confd_feedback', ml_confd_feedback_str, 170, 'left', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
			        if (value == '1') return infoHynixConf == 'true' ? '<div class="feedbackcommon"></div>&nbsp;<s:message code="condition.info.secretFeedbackY"/>' : '<div class="feedbackcommon"></div>&nbsp;<s:message code="condition.info.class1"/>';
			        else if (value == '2') return '<div class="feedbackInNotOpen"></div>&nbsp;<s:message code="condition.info.class2"/>';
			        else if (value == '3') return '<div class="feedbackInOpen"></div>&nbsp;<s:message code="condition.info.class3"/>';
			        else if (value == '4') return '<div class="feedbackInCorrect"></div>&nbsp;<s:message code="condition.info.class4"/>';
			        else if (value == '0') return infoHynixConf == 'true' ? '<div class="feedbackCorrect"></div>&nbsp;<s:message code="condition.info.secretFeedbackN"/>' : '<div class="feedbackCorrect"></div>&nbsp;<s:message code="condition.info.feedback0"/>';
			        else if (value == '9') return '<div class="feedbackDefer"></div>&nbsp;<s:message code="condition.info.feedback9"/>';
			        else if (value == '-1') return '-';
		        });
		        grid.colAdd('ml_confd_prob', ml_confd_prob_str + '(%)', 80, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
			        if (infoHynixConf == 'true') {
				        var sprobRound = Math.round(value * 100) / 100;
				        if (value == undefined || value == null || value == -1.0) return '-';
				        return sprobRound * 100;
			        } else {
				        return probPercent(value);
			        }
		        });
	        }
        }
        grid.colAdd('attachcnt', '<s:message code="message.msg.file"/>', 35, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
            if (value == '0') return '';
            else return value.comma();
        });
        grid.colAdd('inside', '<s:message code="message.msg.inout"/>', 150, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
            if (value == 'N') return '<s:message code="message.msg.out"/>';
            else if (value == 'Y') return '<s:message code="message.msg.in"/>';
            else return '-';
        });

        grid.colAdd('direction_svc', '<s:message code="condition.receive_send"/>', 100, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
            if (value == 'I') return '<s:message code="condition.receive"/>';
            else if (value == 'O') return '<s:message code="condition.send"/>';
            else return '-';
        });

        grid.colAdd('svcNm', '<s:message code="condition.service"/>', 180, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
           if (value == null || value == "undefined") return "null";
           else return value;
        });

        grid.colAdd('subject', '<s:message code="condition.subject"/>', 410, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
	        var body_snippet = grid.getValue(row, 'body_snippet').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
	        if (body_snippet.length > 100) body_snippet = body_snippet.substring(0, 1024) + '...';

	        if (value.length > 1024) value = value.substring(0, 1024) + '...';
	        value = value.replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');

	        value = highlightSearchStr(value, "subject");
	        //예약어 Highlight 처리
	        if (searchKeyword().length == 0 || parent.keywordHighlight.toString() == 'true') {
		        var kwds = nvl(grid.getValue(row, 'kwds_subject')).split(',');
		        if (kwds.length > 0 && kwds[0] != '') {
			        value = highlightKeyword(value, kwds);
		        }
	        }

	        if (value == undefined) value = '<s:message code="common.msg.nosubject"/>';
	        var rtnVal = '<span title="' + body_snippet + '" onclick="" class="subject_read' + grid.getValue(row, 'readYn') + '">' + value + '</span>&nbsp;<a href="javascript:void(0);" onclick="viewer_newOpen(' + row + ')" class="glyphicon glyphicon-new-window new-window"></a>';
	        if ((isConsent() && grid.getValue(row, 'consentNo') == '') || !isDetailView()) rtnVal = '<span>' + value + '</span>';
	        return rtnVal;
        });
	    grid.colAdd('ctimeFormat', '<s:message code="condition.date"/>', 130, 'center', false, 'nomal');
        grid.colAdd('user', '<s:message code="consent.user"/>', 120, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
	        return highlightSearchStr(value, "user");
        });
        grid.colAdd('usrId', '<s:message code="common.msg.account"/>', 110, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
	        return highlightSearchStr(value, "usrId");
        });

        grid.colAdd('businm', '<s:message code="common.org.busi"/>', 120, 'center', true, 'nomal');
        grid.colAdd('ip_businm', '<s:message code="message.actual.business"/>', 120, 'center', true, 'nomal');
        grid.colAdd('deptnm', '<s:message code="common.org.dept"/>', 120, 'center', false, 'nomal');
        grid.colAdd('ip_deptnm', '<s:message code="message.actual.dept"/>', 120, 'center', false, 'nomal');
        grid.colAdd('jikgubnm', '<s:message code="common.org.jikgub"/>', 120, 'center', false, 'nomal');
        grid.colAdd('sender', '<s:message code="condition.sender"/>', 130, 'left', false, 'link', function(row, cell, value, columnDef, dataContext) {
            return highlightSearchStr(value, "sender");
        });
        grid.colAdd('allofus', '<s:message code="condition.allofus"/>', 150, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
            if( value == undefined || value.length == 0) return '';

            for( var i=0; i<value.length; i++){
                if(value[i] == 'IA') value[i] = '<s:message code="condition.allofus1"/>';
                else if(value[i] == 'ET') value[i] = '<s:message code="condition.allofus8"/>';
                else if(value[i] == 'IT') value[i] = '<s:message code="condition.allofus7"/>';
                else if(value[i] == 'EA') value[i] = '<s:message code="condition.allofus2"/>';
                else if(value[i] == 'PT') value[i] = '<s:message code="condition.allofus9"/>';
                else if(value[i] == 'PA') value[i] = '<s:message code="condition.allofus3"/>';
                else if(value[i] == 'SO') value[i] = '<s:message code="condition.allofus13"/>';
                else if(value[i] == 'SI') value[i] = '<s:message code="condition.allofus14"/>';
            }
            return value.join(', ');
        });
        grid.colAdd('recvsStr', '<s:message code="condition.recv"/>', 220, 'left', false, 'link', function(row, cell, value, columnDef, dataContext) {
            return highlightSearchStr(value, "recvs");
        }, {sorter:sortUtil.inout});
        grid.colAdd('to', '<s:message code="condition.to"/>', 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
            var innOutInfo = grid.getValue(row, 'toInOutInfo');
            var rtnVal = arrayToString(value);
	        if (innOutInfo == "" && rtnVal == "") return '';
            else return innOutInfo+highlightSearchStr(rtnVal, "to");
        });
        grid.colAdd('cc', '<s:message code="condition.cc"/>', 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
            var innOutInfo = grid.getValue(row, 'ccInOutInfo');

            var rtnVal = arrayToString(value);
	        if (innOutInfo == "" && rtnVal == "") return '';
            else return innOutInfo+highlightSearchStr(rtnVal, "cc");
        });
        grid.colAdd('bcc', '<s:message code="condition.bcc"/>', 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
            var innOutInfo = grid.getValue(row, 'bccInOutInfo');
            var rtnVal = arrayToString(value);
	        if (innOutInfo == "" && rtnVal == "") return '';
           else return innOutInfo+highlightSearchStr(rtnVal, "bcc");
        });
        grid.colAdd('srcip', '<s:message code="condition.source"/> IP', 100, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
            return highlightSearchStr(value, "srcip");
        }, {sorter:sortUtil.ip});
        grid.colAdd('dstip', '<s:message code="condition.destination"/> IP', 100, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
            return highlightSearchStr(value, "dstip");
        }, {sorter:sortUtil.ip});
        grid.colAdd('attachname', '<s:message code="condition.attach_name"/>', 220, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
            var rtnVal = arrayToString(value);
            return highlightSearchStr(rtnVal, "attachname");
        });
		grid.colAdd('attachtype', '<s:message code="message.msg.pre_ext" />', 220, 'left', true, 'nomal', function(row, cell, value, columnDef, dataContext) {
			var rtnVal = arrayToString(value);
			return rtnVal;
		});
        grid.colAdd('sizeStr', '<s:message code="condition.size.all"/>', 80, 'left', false, 'nomal', null, {sortField:'size'});
        grid.colAdd('bodySizeStr', '<s:message code="condition.size.body"/>', 80, 'left', false, 'nomal', null, {sortField:'body_size'});
        grid.colAdd('attachSizeStr', '<s:message code="condition.size.attach.total"/>', 140, 'left', false, 'nomal', null, {sortField:'attachSizeSort'});
        grid.colAdd('kwds', '<s:message code="condition.keyword"/>', 120, 'left', false, 'nomal');
        grid.colAdd('pi_total', '<s:message code="condition.regexp"/>', 70, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
            if (value == '0') return '';
            else return value.comma();
        });

        if ( isOCR ) {
            grid.colAdd('ocr_attach_cnt', 'OCR <s:message code="message.msg.file"/>', 70, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
                if (value == '0' || value == '' || value == null || value == undefined ) return '';
                else return value.comma();
            });
        }
        grid.colAdd('reprocess', '<s:message code="condition.reprocess"/>', 70, 'center', true, 'nomal', function(row, cell, value, columnDef, dataContext) {
            if (value == 0) return 'No';
            else return 'Yes'
        });

        grid.colAdd('host', 'Host', 220, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
	        return highlightSearchStr(value, "host");
        });
        grid.colAdd('path', 'Path', 180, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
	        return highlightSearchStr(value, "path");
        });
	    grid.colAdd('sabun', '<s:message code="common.msg.userid"/>', 180, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
		    return highlightSearchStr(value, "sabun");
	    });

        grid.loadHeader(true);
        grid.loadPageSize();
        grid.initData('<s:message code="common.msg.search.click"/>');
        grid.onContextMenu = function(row, col, e){
            e.preventDefault();

            $("#contextMenu")
                .data("row", row)
                .css("top", e.pageY)
                .css("left", e.pageX)
                .show();
        };
        grid.onClick = function() {
            if (!isDetailView()) {
                alert(condition.authAlert);
                return;
            }
            
            if($('#contextMenu').css('display')=='block' || $('#contextMenu').css('display')=='inline-block') $('#contextMenu').hide();
            if (grid.Col == grid.ColIndex('attachcnt')) {
                fileInfoViewer( grid.Row );
            }else if (grid.Col == grid.ColIndex('user')) {
                userInfoViewer( grid.Row, 'user' );
            }else if (grid.Col == grid.ColIndex('sender')) {
                userInfoViewer( grid.Row, 'sender' );
            }else if (grid.Col == grid.ColIndex('recvsStr')) {
                if(grid.getValue(grid.Row, 'recvs') != '') 	userInfoViewer( grid.Row, 'recvs');
            }else if (grid.Col == grid.ColIndex('to')) {
                if(grid.getValue(grid.Row, 'to') != '') userInfoViewer( grid.Row, 'to');
            }else if (grid.Col == grid.ColIndex('cc')) {
                if(grid.getValue(grid.Row, 'cc') != '') userInfoViewer( grid.Row, 'cc');
            }else if (grid.Col == grid.ColIndex('bcc')) {
                if(grid.getValue(grid.Row, 'bcc') != '') userInfoViewer( grid.Row, 'bcc');
            }else if(grid.Col == grid.ColIndex('pi_total')) {
                regexpInfoViewer(grid.Row);
            }else if(grid.Col == grid.ColIndex('referer_url')) {
                var referer_url = grid.getValue(grid.Row, 'referer_url');
                if(referer_url !='N') fnOpenWindow(referer_url, '', 1024, 800, 'resize');
            }else if (grid.Col == grid.ColIndex('ocr_attach_cnt')) {
                ocrFileInfoViewer( grid.Row );
            } else if (grid.Col == grid.ColIndex('interestUserYn')) {
                var interestUserYn = grid.getValue(grid.Row, 'interestUserYn');
                if(interestUserYn != '') interestUserInfoViewer(grid.Row);
            } else if (grid.Col == grid.ColIndex('overlap')) {
                overlapInfoViewer( grid.Row );
            }

            if( !(adminMenu != "ALL" && adminMenu.indexOf("DV") < 0) ) {
                if(!parent.$('#none_btn').hasClass('areaSelected')) viewer_open(grid.Row);
                if(popWin) viewer_openFocus(grid.Row);
            } else {
                alert('<s:message code="message.auth.no.detailview"/>');
                return;
            }
        };
        grid.changePageSize = function(cnt){
            parent.getList();
        };
        grid.onDblClick = function(){
            viewer_openPop(grid.Row);
        }
        grid.onActiveRowChanged = function(){
            if( !(adminMenu != "ALL" && adminMenu.indexOf("DV") < 0) ) {
                if(!parent.$('#none_btn').hasClass('areaSelected')) viewer_open(grid.Row);
                if(popWin) viewer_openFocus(grid.Row);
            } else {
                alert('<s:message code="message.auth.no.detailview"/>');
                return;
            }
        }

    }
</script>
</html>
