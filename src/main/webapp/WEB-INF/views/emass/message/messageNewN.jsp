<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.xcurenet.audit.service.Operation"%>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="com.xcurenet.common.util.config.Config" %>
<%@ page import="com.xcurenet.common.util.SpringContextUtil" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="com.xcurenet.admin.service.AdminVO" %>
<%@ page import="com.xcurenet.admin.service.impl.AdminServiceImpl" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 메시지 페이지 전용 --%>
<%@ include file="/WEB-INF/fragments/messageScript.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/message.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/messageContent.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/jquery.scrollbar.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/bootstrap-datetimepicker.min.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/zTreeStyle.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/bootstrap-select.min.css"/>"/>

<link rel="stylesheet" href="<c:url value="/css/jquery.layout.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/scrolltabs.css"/>"/>

<script type="text/javascript" src="<c:url value="/js/jquery.scrolltabs.js"/>"></script>

<script type="text/javascript" src="<c:url value="/js/moment.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ko.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-select.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/dropdowns-enhancement.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.scrollbar.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.ztree.all-3.5.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/referrer-killer.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/conditionNew.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ztreeRMenu.js"/>"></script>

<script type="text/javascript" src="<c:url value="/js/ztree.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/filter.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/folder.js"/>"></script>

<script type="text/javascript" src="<c:url value="/js/jquery.layout.js"/>"></script>

<%
    boolean mailUseFlag = Config.getBoolean("mail.forward.flag");
    String epmsgType = Config.getString("message.epmsg.val");
    String epmsgAttach = Config.getString("attach.image.body");
    String recvsJikgub = Config.getString("recvs.jikgub.use");
    String firstAdminYn = Common.getFirstAdminYn(session);
    boolean infoHynixConf = Config.getBoolean("info.hynix.used");
    String rsUppercase = Config.getString("receiver.sender.uppercase");
    String adminType    = Common.getAdminType(session);
    String op_attach_save = Operation.ATTACH_SAVE.getOperation();
    String op_body_save = Operation.BODY_SAVE.getOperation();
    String op_body_print = Operation.BODY_PRINT.getOperation();

    JSONObject param = Common.getParam(request);
    String filterSeq = Common.nvl(param.get("filterSeq"));
    String conditionParam = Common.nvl(param.get("conditionParam"));

    String uri = new org.springframework.web.util.UrlPathHelper().getOriginatingRequestUri(request);
    if (uri.contains("/index.do")) uri = "/ems/index.do";
    if (uri.contains("/deviceInfoDetail.do")) uri = "/commons/deviceInfo.do";
    if (uri.contains("/deviceInfoDetailHadoop.do")) uri = "/commons/deviceInfo.do";
    if (uri.contains("/ems/dashboard.do")) uri += "?" + new org.springframework.web.util.UrlPathHelper().getOriginatingQueryString(request);

	String infoFeedbackMode = Config.getString("info.feedback.mode");

    MenuService menuService = SpringContextUtil.getBean(MenuService.class);
    String menuId = "";
    String menuName = "";
    String headerYn = (String) request.getAttribute("headerYn");
    String headerCloseYn = (String) request.getAttribute("headerCloseYn");
    String menuKey = (String) request.getAttribute("menuKey");
    String menuList = menuService.getMenuList(request); //메뉴리스트 JSON 데이터로 받아옴
    JSONArray menus = Common.toJSONArray(menuList);
    for(int i=0 ; i < menus.size() ; i++) {
        JSONObject menu = menus.getJSONObject(i);
        if(Common.nvl(uri).contains(Common.nvl(menu.get("menuLink")))) {
            menuId = Common.nvl(menu.get("menuId"));
            menuName = Common.nvl(menu.get("defaultName"));
        }
    }

%>

<style>

    @font-face {
        font-family: 'Pretendard';
        font-weight: 900;
        font-display: swap;
        src: local('Pretendard Black'), url("../fonts/woff2/Pretendard-Black.subset.woff2") format('woff2'), url("../fonts/woff/Pretendard-Black.subset.woff") format('woff');
    }

    @font-face {
        font-family: 'Pretendard';
        font-weight: 800;
        font-display: swap;
        src: local('Pretendard ExtraBold'), url("../fonts/woff2/Pretendard-ExtraBold.subset.woff2") format('woff2'), url("../fonts/woff/Pretendard-ExtraBold.subset.woff") format('woff');
    }

    @font-face {
        font-family: 'Pretendard';
        font-weight: 700;
        font-display: swap;
        src: local('Pretendard Bold'), url("../fonts/woff2/Pretendard-Bold.subset.woff2") format('woff2'), url("../fonts/woff/Pretendard-Bold.subset.woff") format('woff');
    }

    @font-face {
        font-family: 'Pretendard';
        font-weight: 600;
        font-display: swap;
        src: local('Pretendard SemiBold'), url("../fonts/woff2/Pretendard-SemiBold.subset.woff2") format('woff2'), url("../fonts/woff/Pretendard-SemiBold.subset.woff") format('woff');
    }

    @font-face {
        font-family: 'Pretendard';
        font-weight: 500;
        font-display: swap;
        src: local('Pretendard Medium'), url("../fonts/woff2/Pretendard-Medium.subset.woff2") format('woff2'), url("../fonts/woff/Pretendard-Medium.subset.woff") format('woff');
    }

    @font-face {
        font-family: 'Pretendard';
        font-weight: 400;
        font-display: swap;
        src: local('Pretendard Regular'), url("../fonts/woff2/Pretendard-Regular.subset.woff2") format('woff2'), url("../fonts/woff/Pretendard-Regular.subset.woff") format('woff');
    }

    @font-face {
        font-family: 'Pretendard';
        font-weight: 300;
        font-display: swap;
        src: local('Pretendard Light'), url("../fonts/woff2/Pretendard-Light.subset.woff2") format('woff2'), url("../fonts/woff/Pretendard-Light.subset.woff") format('woff');
    }

    @font-face {
        font-family: 'Pretendard';
        font-weight: 200;
        font-display: swap;
        src: local('Pretendard ExtraLight'), url("../fonts/woff2/Pretendard-ExtraLight.subset.woff2") format('woff2'), url("../fonts/woff/Pretendard-ExtraLight.subset.woff") format('woff');
    }

    @font-face {
        font-family: 'Pretendard';
        font-weight: 100;
        font-display: swap;
        src: local('Pretendard Thin'), url("../fonts/woff2/Pretendard-Thin.subset.woff2") format('woff2'), url("../fonts/woff/Pretendard-Thin.subset.woff") format('woff');
    }

</style>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>EMASS AI</title>

    <style type="text/css">
        img {    vertical-align: middle !important;}
        body{
            font-size:13px;
        }

        #wrap {overflow:hidden;}
        .ui-widget input {margin-top:4px;}
        .caret {
            display: inline-block;
            width: 0;
            height: 0;
            margin-left: 4px;
            margin-bottom: 3px;
            vertical-align: middle;
            border-top: 4px dashed;
            border-top: 4px solid\9;
            border-right: 4px solid transparent;
            border-left: 4px solid transparent;}
        .scroll_tabs_container div.scroll_tab_inner {height:32px !important; padding:0;}
        .contentList{
            height:100%;border: 0px;width: 100%;overflow: hidden;border:0px;position: absolute;
        }

        .contentBody{
            height:100%;border: 0px;width: 100%;border:0px;position: absolute;
        }
        @media screen and (max-height: 750px) {
            #mainBodyArea .bootstrap-datetimepicker-widget{ top: 200px !important; }
        }
        @media screen and (max-height: 550px) {
            #mainBodyArea .bootstrap-datetimepicker-widget{ top: 200px !important; }
        }

        #mainBodyArea .bootstrap-datetimepicker-widget{
            height: 270px !important;
            overflow: hidden !important;
        }

        .codeSelectedBtn{
            display:inline;left:110%;top:-2px;position:absolute;
        }
        .codeSelectedBtn .btn{
            font-size: 11px;padding-left:2px;padding-right:2px;
        }

        .dropdown-menu > li> div{
            float: left;
        }

        .areaBtn {
            opacity:0.8;cursor:pointer;
        }


        .areaSelected{
            opacity:1.5 !important;
            border:1px solid #1C64D3;
            background-color: #F2F6FF;
        }

        .selectedCnt{
            display: inline-block;
            margin-left: 5px;
        }

        .expandCollapse{
            display: inline;
            width: 0;
            height: 0;
            margin-right: 5px;
            vertical-align: middle;
            color : #000;
        }

        .bootstrap-select.btn-group .dropdown-menu.inner {
            padding-top: 2px;
        }
        .bootstrap-select .dropdown-backdrop {
            pointer-events: none;
        }
        .dropdown-header {
            line-height: 10px;
        }
        .dropdown-menu > li > a.hideCollapsedOptGroupElements{
            display:none;
        }
        /*# sourceMappingURL=bootstrap-select.css.map */


        /* If need to override hideCollapsedOptGroupElements please override it in your specific css files */


        .hideCollapsedOptGroupElements{
            position :static !important;
        }

        .searchKeywordDiv{
            position: absolute;
            top: 120px;
            background-color: #fff;
            z-index: 999;
            left: 305px;
            border: 1px solid #ccc;
            width: 400px;
            display:none;
            height:500px;
        }

        .searchHelpDiv{
            position: absolute;
            top: 100px;
            background-color: #fff;
            z-index: 999;
            left: 305px;
            border: 1px solid #ccc;
            width: 500px;
            display:none;
            height:355px;
        }

        /*연관 검색어 */
        .relationKeywordDiv{
            position: absolute;
            top: 120px;
            background-color: #f4f4f4;
            z-index: 999;
            left: 305px;
            border: 1px solid #ccc;
            width: 400px;
            display:none;
            height:500px;
        }

        /*정규 표현식 */
        .regexSearchDiv{
            position: absolute;
            top: 120px;
            background-color: #f4f4f4;
            z-index: 999;
            left: 305px;
            border: 1px solid #ccc;
            width: 400px;
            display:none;
            height:500px;
        }

        #searchKeywordGrid_statusbar {
            background-color: #fff;
        }
        .searchKeywordInputType {
            cursor: pointer;
            font-weight: normal;
            margin-right: 5px;
        }
        .searchKeywordTab{
            height: 40px;
            background-color: #242330;
            cursor: move;
            color:#fff;
            line-height: 40px;
            padding-left: 10px;
        }
        .searchKeywordCloseBtn{
            float: right;
            padding-right: 10px;
            padding-left: 10px;
            font-size: 15px;
            cursor:pointer;
        }

        .relationKeywordCloseBtn{
            float: right;
            padding-right: 10px;
            padding-left: 10px;
            font-size: 15px;
            cursor:pointer;
        }
        .regexSearchCloseBtn{
            float: right;
            padding-right: 10px;
            padding-left: 10px;
            font-size: 15px;
            cursor:pointer;
        }



        .searchKeywordCloseBtn:hover{
            opacity: 0.5;
        }

        .filterHeaderDiv{
            position: absolute;
            top: 64px;
            background-color: #fff;
            z-index: 999;
            left: 305px;
            border: 1px solid #ccc;
            width: 300px;
            display:none;
            height:500px;
        }
        .filterHeaderTab{
            height: 40px;
            background-color: #242330;
            cursor: move;
            color:#fff;
            line-height: 40px;
            padding-left: 10px;
            font-family: Pretendard;
        }
        /*.filterDateCloseBtn{*/
        /*    float: right;*/
        /*    padding-right: 10px;*/
        /*    padding-left: 10px;*/
        /*    font-size: 14px;*/
        /*    cursor:pointer;*/
        /*}*/
        .filterDateCloseBtn:hover{
            opacity: 0.5;
        }

        .filterIcon, .queryIcon{
            position: absolute;
            right: 5px;
            top: 95px;
            font-size: 15px;
            border-radius: 15px;
            background-color: #f7da23;
            width: 20px;
            text-align: center;
            cursor:pointer;
        }

        .listRow{
            border-bottom:1px solid #ccc;height: 35px;line-height:35px;padding: 0 10px;
        }
        .listRowLeft{
            float:left;
        }
        .listRowRight{
            float:right;
        }

        .resultCntSpan{
            float: right;
            height: 100%;
            padding-top: 9px;
            padding-right:20px;
            margin-left:-10px;
        }

        .ui-layout-west{
            overflow-y:hidden;
        }

        .rightGroup {
            float: right;
        }
        #searchBox {
            position: relative;
            top: 1px;
        }
        .searchBoxSpan label{
            cursor:pointer;
            margin-bottom: 5px;
        }

        .condition_group {
            margin-top: 12px;
            font-size: 13px;
            padding:8px; background-color: #f5f5f5;
            color:#111; text-align: center; font-weight:600;
            border-top:1px solid #ddd;
            font-family: Pretendard;
        }
        .condition_group > i {
            font-size: 14px;
            position: relative;
            top: 0px;
            float: right;
            font-weight: normal;
            color: #333;
            margin-right:10px;
        }
        #filterNamePopInput {line-height: 14px;}

        .queryTextarea{
            width: 260px;height:100%;border: 2px solid #337AB7;padding: 5px 0 0 5px;resize:none;font-size:14px;line-height: 23px;
        }

        #insaFormatClear:hover,#insaFormatOk:hover{
            font-weight: bold;
            cursor: pointer;
            color: #286090;
        }
        #messageFormat option:hover{
            background-color: #d4d4d4;
        }
        .condition_top{
            position: fixed;
            width: 25px;
            background-color: rgba(0, 94, 193, 0.8);
            text-align: center;
            margin-left: 260px;
            z-index: 100000;
            margin-top: 3px;
            -moz-border-radius: 50px;
            -webkit-border-radius: 50px;
            border-radius: 50px;
            height: 25px;
            line-height: 23px;
            font-size: 10px;
            font-weight: bold;
            cursor: pointer;
            color:#fff;
            display: none;
            margin-top:-32px;
        }
        .dropdown-menu {
            /*max-height: 344px !important;*/
        }

        .condition_top_sub{
            position: fixed;
            width: 300px;
            background-color: rgba(0, 94, 193, 0.56);
            height: 2px;
            z-index: 100000;
            display: none;
        }
        #none_btn:hover,#bottom_btn:hover,#right_btn:hover{
            text-decoration: underline;
        }
        .dropdown-menu.open {
            max-width: 260px !important;
            max-height: 430px !important;
        }

        #feedbackSetting {
            position: absolute;
            list-style: none;
            border: 1px solid #ccc;
            width: 150px;
            padding-left: 0px;
            top: 21px;
            border-radius: 4px;
            box-shadow: 0px 6px 12px rgba(0,0,0,0.175);
            background-color: #fff;
        }

        #feedbackSetting a, #feedbackSetting a:hover {
            text-decoration: none;
            display: block;
            width: 100%;
            height: 100%;
            padding: 1px 17px;
            font-size:13px;
            font-weight: 400;
            line-height: 1.4285;
            color: #333;
        }

        #feedbackSetting a:hover {
            background-color: #f5f5f5;
        }

        .reset_btn {
            border: 0px;
            padding:1px 12px 2px 3px;
            height:18px;
            width: 14px;
            background-color: #242330;
            color: #fff;
            font-weight: bold;
        }
        #resultTabs .scroll_tab_left_button, #resultTabs .scroll_tab_right_button{
            top:4px !important;
            background-color:#fbfbfb !important;
        }
        .ui-widget-content a  {
            border: 1px solid #7D7D7D;
        }

        .searchKeywordCloseBtn .glyphicon-remove:before {
            color: white !important;
        }
        .searchHelpDivCloseBtn .glyphicon-remove:before {
            color: white !important;
        }
        .filterDateCloseBtn .glyphicon-remove:before {
            color: white !important;
        }
        .searchHelpDivCloseBtn .glyphicon-remove:before {
            color: white !important;
        }
        .regexSearchCloseBtn .glyphicon-remove:before {
            color: white !important;
        }
        .matchHelpDivCloseBtn .glyphicon-remove:before {
            color: white !important;
        }



    </style>
    <script type="text/javascript">

        let menuList = <%=menuList%>;
        let mainUri = "<%=uri%>";

        var op_attach_save = '<%=op_attach_save%>';
        var op_body_save = '<%=op_body_save%>';
        var op_body_print = '<%=op_body_print%>';
        var mailUseFlag = <%=mailUseFlag%>;
        var firstAdminYn = '<%=firstAdminYn%>';
        var adminEmail = '${_USERCREDENTIAL_.adminEmail}';
        var msgInfoLayout;
        var addTabFlag = false;
        var checkMsgCnt = 10000;
        var re = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\(\=]/gi;

        var filterSeq = '<%=filterSeq%>';
        var conditionParam = '<%=conditionParam%>';
        var isAutoSearch = false; // dashboard에서 자동 검색인지 여부
        var infoFeedbackMode = '<%=infoFeedbackMode%>';
        var readyFlag = false;
        var headerScrollTabs;
        var pageType="";
        var mode='';
        var epmsgType = '<%=epmsgType%>';
        var epmsgAttach ='<%=epmsgAttach%>';
        var recvsJikgub = '<%=recvsJikgub%>';
        var rsUppercase = '<%=rsUppercase%>';
        var message = {
            nosubject:'<s:message code="common.msg.nosubject"/>',
            attach:'<s:message code="consent.attach"/>',
            subject:'<s:message code="condition.subject"/>',
            body:'<s:message code="condition.body"/>',
            attach_name:'<s:message code="condition.attach_name"/>',
            message_info:'<s:message code="DATA_MONITOR.MESSAGE_INFO"/>',
            userinfo:'<s:message code="common.msg.userinfo"/>',
            authAlert:'<s:message code="admin.auth.alert"/>',
            attachSave:'<s:message code="bodyview.attach.save"/>',
            fileName:'<s:message code="bodyview.file.name"/>',
            msgid:'<s:message code="common.msg.msgid"/>',
            pre_ext:'<s:message code="message.msg.pre_ext"/>',
            total_count:'<s:message code="bodyview.total_count"/>',
            msgAuto:'<s:message code="common.msg.auto"/>',
            msgNomsg:'<s:message code="bodyview.message.nomsg"/>',
            bodyPrint:'<s:message code="bodyview.body.print"/>',
            xrootmtr:'<s:message code="condition.xrootmtr"/>',
            bodyView:'<s:message code="bodyview.body.view"/>',
            msgNomail:'<s:message code="bodyview.message.nomail"/>',
            chk_account:'<s:message code="bodyview.message.mail.chk_account"/>',
            msgNocontent:'<s:message code="common.msg.nocontent"/>',
            msgParticipantinfo:'<s:message code="common.msg.participantinfo"/>',
            windowNew:'<s:message code="bodyview.window.new"/>',
            windowTab:'<s:message code="bodyview.window.tab"/>',
            checkboxSelectRequired:'<s:message code="common.msg.checkbox.select.required"/>'
        };

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
            userGroupNaviTitle2:'<s:message code="userGroup.navi.title2"/>',
            interestGroup:'<s:message code="condition.interestGroup"/>',
            epmsgTypeAll:'<s:message code="condition.epmsgType.all"/>'
        };



        $(document).ready(function() {
            if(consent && firstAdminYn != 'Y'){

            }
            if(epmsgType == "" ){
                $('#epmsgList').hide();
            }else{
                $('#epmsgList').show();
            }


            if(epmsgAttach == ""){
                $('#KnoxAttachYN').hide();
            } else if (epmsgAttach == "" || epmsgAttach == "false"){
                $('#KnoxAttachYN').hide();
            } else if (epmsgAttach == "true"){
                $('#KnoxAttachYN').show();
            }


            if(isOCR){
                $('#ocrAttachYn').show();
            }else if (!isOCR){
                $('#ocrAttachYn').hide();
            }

            if(recvsJikgub == "true") {
                $('.recvs_jikgub').show();
                getJikgubList();
            }else{
                $('.recvs_jikgub').hide();
            }


            $(document).keydown(function(e){if( e.keyCode == 27) hideRMenu();});

            $('#searchKeywordSearchBtn').click(function(){getSearchKeywordList( );});
            $('#searchKeywordSearchStr').enter(function(){getSearchKeywordList( );});
            $('#addSearchKeywordBtn').click(function(){insertSearchKeywordList( );});
            $('#delSearchKeywordBtn').click(function(){deleteSearchKeywordList( );});


            $('#searchStrInput').autocomplete({ delay : 0,
                source : function(request, response) {
                    /* 자동 완성 */
                    ui.get({
                        url : 'getSearchKeywordAuto.xcn',
                        searchKeyword : extractLast(request.term),
                        success : function(data, total) {
                            var result = [];
                            for ( var i = 0; i < data.length; i++) {
                                result.push(data[i]['searchKeyword']);
                            }
                            response(result);
                        },
                        error : function(status, message) {
                            ui.alertMsg(message);
                        },
                        complete : function() {
                        }
                    });

                    /* 연관 검색어 */
                    if($(".relationKeywordBtn").is(":checked")) {
                        getRelationKeywordList();
                    };


                },
                search : function() {
                    var term = extractLast(this.value);
                    if (term.length < 1) {
                        return false;
                    }
                },
                focus : function() {
                    return false;
                },
                select : function(event, ui) {
                    var terms = split(this.value);
                    terms.pop();
                    terms.push(ui.item.value);
                    terms.push("");
                    this.value = terms.join("");
                    return false;
                }
            });


            function split(val) {
                return val.split(/,\s*/);
            }
            function extractLast(term) {
                return split(term).pop();
            }



            ui.onBody('msgBody', 0, 0);
            con.init();
            initFilterSetup();
            initFolderSetup();
            getMsgPosition();
            getFilterSearchBox();

            if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ) {
                if (infoFeedbackLlm == 'true'){
                    $('#infoFeedbackDiv').show();
                    $('#secretDocuDiv, #feedbackTypeDiv, #sctDiv').hide();
                }else if(infoHynixConf == 'true'){
                    $('#infoFeedbackDiv, #feedbackBtn, #sctDiv').hide();
                    $('#secretDocuDiv').show();
                }else{
                    $('#infoFeedbackDiv, #feedbackBtn, #sctDiv').show();
                    $('#secretDocuDiv').hide();
                }
            }
            else $('#infoFeedbackDiv, #feedbackBtn, #sctDiv').hide();

            $('.scrollbar-inner').scrollbar();

            $('#searchBtn').click(function(){searchData( );}); //일반 검색 버튼 클릭
            $('#searchQueryBtn').click(function(){toggleSolrQuery();}); //고급 버튼 클릭
            $("#searchStrInput").keypress(function(e){if( e.keyCode == 13) searchData( );}); //통합 검색 엔터키


            var dateObj = new Date();
            $('#startdatepicker').datetimepicker({
                format: 'YYYY-MM-DD HH:mm:ss',
                locale: 'ko',
                sideBySide: true,
                showClose: true,
                showTodayButton: true,
                toolbarPlacement: 'bottom',
                widgetParent:$('#mainBodyArea'),
                defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-7 ) )
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
                showClose: true,
                showTodayButton: true,
                toolbarPlacement: 'bottom',
                widgetParent:$('#mainBodyArea'),
                defaultDate: moment(new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 23, 59, 59 ) )
            }).on("dp.change", function (e) {
                if( easyDateEndFlag ){
                    easyDateEndFlag = false;
                    return;
                }else{
                    $('#easyDate').val('');
                }
            });

            $('#easyDate').change(function(){
                changeDate($(this).val());
            });
            $('#sizeOption').change(function(){
                var val = $(this).val();
                if( val == 'B'){
                    $('#sizeEndVal').prop('disabled', false);
                }else{
                    $('#sizeEndVal').prop('disabled', true);
                }
            });

            $('#messageSort').change(function(){
                $('.dropdown-backdrop').click();
            });
            var formatModifyYn = false;

            $('#messageFormat').change(function(){
                confIconHide();

                $('#insaFormatInputEx').val('');
                $('#insaFormatInput').val('');

                var msgFormatVal = $("#messageFormat option:selected").val();
                var msgFormatValText = $("#messageFormat option:selected").text();
                if(msgFormatVal!='')$('#insaFormatInput').val(msgFormatValText);
                $('#insaFormatInputEx').val(msgFormatVal);

            });
            $('#messageFormat').click(function(){
                confIconHide();

                $('#insaFormatInputEx').val('');
                $('#insaFormatInput').val('');

                var msgFormatVal = $("#messageFormat option:selected").val();
                var msgFormatValText = $("#messageFormat option:selected").text();
                if(msgFormatVal!='')$('#insaFormatInput').val(msgFormatValText);
                $('#insaFormatInputEx').val(msgFormatVal);

            });
            $('#insaFormatClear').click(function(){
                confIconHide();

                $('#insaFormatInput').val('');
                $('#insaFormatInputEx').val('');
                $('#insaFormatInput').attr('data-format','');
            });
            $('#insaFormatOk').click(function(){
                confIconHide();

                var msgFormatValText = $("#messageFormat option:selected").text();
                var insaFormatInputVal = $('#insaFormatInput').val();
                if(msgFormatValText != insaFormatInputVal){
                    $("#insaFormatInputEx").val("");
                    $("#messageFormat").val("");
                    $("#messageFormat").focus();
                    var customInsaFormatInputVal = $('#insaFormatInput').val();
                    customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('name','<s:message code="message.help.sample_name"/>');
                    customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('email','hong@xcurent.com');
                    customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('businm','<s:message code="message.help.sample_bunm"/>');
                    customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('deptnm','<s:message code="message.help.sample_deptnm"/>');
                    customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('jikgubnm','<s:message code="message.help.sample_jikgubnm"/>');
                    customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('ip','192.168.0.1');
                    customInsaFormatInputVal = customInsaFormatInputVal.replaceAll('sabun','20241234');
                    customInsaFormatInputVal = customInsaFormatInputVal.replaceAll(' ','');
                    customInsaFormatInputVal = '<s:message code="message.help.example"/>) '+customInsaFormatInputVal
                    $("#insaFormatInputEx").val(customInsaFormatInputVal)

                }
                var formatArr = ['name','email','businm','deptnm','jikgubnm','ip','sabun'];
                var insaFormatstr = insaFormatInputVal;
                for (var i = 0; i < formatArr.length; i++) {
                    var val = formatArr[i];
                    var idx = insaFormatstr.indexOf(val);
                    if(insaFormatstr.indexOf(val)>-1){
                        insaFormatstr = insaFormatstr.substring(0,idx) + insaFormatstr.substring(idx+val.length,insaFormatstr.length);
                    }
                }
                var err = 0;
                if(insaFormatInputVal == '') err++;
                for (var i=0; i<insaFormatstr.length; i++)  {
                    var chk = insaFormatstr.substring(i,i+1);
                    if(chk.match(/[0-9]|[a-z]|[A-Z]|[\u3131-\u314e|\u314f-\u3163|\uac00-\ud7a3]/)) {
                        err++;
                    }
                }
                if (err > 0) {
                    $('#confError').show();
                    $('#insaFormatInput').css('width','310px');
                    $('#insaFormatInput').animate({'background-color':'#f0ad4e',duration: '500'},
                        function() {
                            $('#insaFormatInput').animate({'background-color':'#fff',duration: '500'});
                        });
                    return;
                }else{
                    $('#confError').hide();
                    $('#insaFormatInput').css('width','330px');
                }
                insaFormatInputVal = insaFormatInputVal.replaceAll(' ','');
                insaFormatInputVal = insaFormatInputVal.replaceAll('name','#name#');
                insaFormatInputVal = insaFormatInputVal.replaceAll('email','#email#');
                insaFormatInputVal = insaFormatInputVal.replaceAll('businm','#businm#');
                insaFormatInputVal = insaFormatInputVal.replaceAll('deptnm','#deptnm#');
                insaFormatInputVal = insaFormatInputVal.replaceAll('jikgubnm','#jikgubnm#');
                insaFormatInputVal = insaFormatInputVal.replaceAll('ip','#ip#');
                insaFormatInputVal = insaFormatInputVal.replaceAll('sabun','#sabun#');
                setConfAdmin('message.user.format',insaFormatInputVal);
            });
            $("#config_toggle").click(function(){
                if(!$('#config_toggle').parent().hasClass('open')){
                    getFormatVal();
                }
            });

            $('#feedbackBtn').click(function(){
                if( $('#feedbackSetting').css('display') == 'block' ) {
                    $('#feedbackSetting').hide();
                    $('#overlay').hide();
                }
                else if ( $('#feedbackSetting').css('display') == 'none' ) {
                    $('#feedbackSetting').show();
                    $('#overlay').show();
                }
            });

            $('[name=subjectbody]').click(function(){
                var val = $(this).is(':checked') == true ? 'Y' : 'N';
                setConfAdminOption('body.snippet.sum.use', val);
            });

            $('[name=summary]').click(function(){
                var val = $(this).is(':checked') == true ? 'Y' : 'N';
                if(val == 'N') {
                    ui.confirmMsg('<s:message code="common.msg.search.warning" />', '', '', function(rs){
                        if(rs){
                            setConfAdminOption('toccbcc.sum.use', val);
                        }else {
                            $('[name=summary]').prop('checked', true);
                        }
                    });
                } else {
                    setConfAdminOption('toccbcc.sum.use', val);
                }
            });

            $('[name=overlapUse]').click(function(){
                var val = $(this).is(':checked') == true ? 'Y' : 'N';
                setConfAdminOption('message.overlap.use', val);
            });

            $('[name=keywordHighlight]').click(function(){
                var val = $(this).is(':checked') == true ? 'Y' : 'N';
                setConfAdminOption('message.keyword.highlight', val);
            });

            $('[name=hostQuery]').click(function(){
                var val = $(this).is(':checked') == true ? 'Y' : 'N';
                setConfAdminOption('host.query.use', val);
            });

            $(document).click(function(e) {
                if(! ($(e.target).is('#feedbackSetting') || $(e.target).is('#feedbackBtn')) ) {
                    $('#feedbackSetting').hide();
                    $('#overlay').hide();
                }
            });

            $('#none_btn').click(function(){
                if(msgInfoLayout != undefined) msgInfoLayout.destroy();

                var westSize = (adminLang == 'ko') ? adminLangLayout.west_ko : adminLangLayout.west_en;
                msgInfoLayout = $('#mainBodyArea').layout({
                    west__size:  westSize,
                    west__maxSize: westSize,
                    west__maskContents:  true,
                    west__spacing_open:3,
                    center__maskContents:  true,
                    // INNER-LAYOUT (child of middle-center-pane)
                    center__childOptions: {
                        center__paneSelector: ".inner-center",
                        center__maskContents:  true,
                        east__paneSelector: ".inner-east",
                        east__maskContents:  true,
                        east__size: 0,
                        east__spacing_open:3,
                        north__spacing_open:0
                    },
                    center__onresize: function(pane, $pane, state, options) {
                    }
                });

                $('.areaBtn').removeClass('areaSelected');
                $(this).addClass('areaSelected');

                setConfAdmin('msgPosition', 'N');
                $('.dropdown-backdrop').click();
            });
            $('#bottom_btn').click(function(){
                if(msgInfoLayout != undefined) msgInfoLayout.destroy();

                var westSize = (adminLang == 'ko') ? adminLangLayout.west_ko : adminLangLayout.west_en;
                var southSize = (adminLang == 'ko') ? adminLangLayout.south_ko : adminLangLayout.south_en;

                msgInfoLayout = $('#mainBodyArea').layout({
                    west__size: westSize,
                    west__maxSize:westSize,
                    west__maskContents:  true,
                    west__spacing_open:3,
                    center__maskContents:  true,
                    // INNER-LAYOUT (child of middle-center-pane)
                    center__childOptions: {
                        center__paneSelector: ".inner-center",
                        center__maskContents:  true,
                        south__paneSelector: ".inner-east",
                        south__maskContents:  true,
                        south__size: southSize,
                        south__spacing_open:3,
                        north__spacing_open:0
                    },
                    center__onresize: function(pane, $pane, state, options) {
                    }
                });

                $('.areaBtn').removeClass('areaSelected');
                $(this).addClass('areaSelected');

                setConfAdmin('msgPosition', 'B');
                $('.dropdown-backdrop').click();
            });



            $('#right_btn').click(function(){

                var westSize = (adminLang == 'ko') ? adminLangLayout.west_ko : adminLangLayout.west_en;
                var eastSize = (adminLang == 'ko') ? adminLangLayout.east_ko : adminLangLayout.east_en;

                if(msgInfoLayout != undefined) msgInfoLayout.destroy();
                msgInfoLayout = $('#mainBodyArea').layout({
                    west__size: westSize,
                    west__maxSize: westSize,
                    west__maskContents:  true,
                    center__maskContents:  true,
                    west__spacing_open:3,
                    // INNER-LAYOUT (child of middle-center-pane)
                    center__childOptions: {
                        center__paneSelector: ".inner-center",
                        center__maskContents:  true,
                        center__spacing_open:3,
                        east__paneSelector: ".inner-east",
                        east__maskContents:  true,
                        east__size: eastSize,
                        east__spacing_open:3,
                        north__spacing_open:0
                    },
                    center__onresize: function(pane, $pane, state, options) {
                    }
                });

                $('.areaBtn').removeClass('areaSelected');
                $(this).addClass('areaSelected');

                setConfAdmin('msgPosition', 'R');
                $('.dropdown-backdrop').click();
            });

            $("#searchBox").change(function(){
                var value = 'N';
                if($("#searchBox").is(":checked")){
                    value = 'Y';
                }
                setConfAdmin('filterSearchBox', value);
            });

            $('.list_icon').click(function(){
                $('#mainBodyArea').layout().toggle('west');
            });

            $('.display_none').click(function(){
                if( $(this).find('i').hasClass('fa-plus-square') ) $(this).find('i').removeClass('fa-plus-square').addClass('fa-minus-square');
                else $(this).find('i').removeClass('fa-minus-square').addClass('fa-plus-square');
                $(this).next().toggle();
            });

            $(document).on('mousedown', '#resultTabs .scroll_tab_inner .tab_li', function(e){
                if($(this).attr('data-index') == '0' || $(this).attr('id') == undefined) return;
                if( e.which == 2 ) {
                    var changeObj = delTab($(this));
                    changeTab(changeObj);
                }
            });
            $(document).on('keyup', '.condition_input_text', function(e){
                if($(this).val() == ''){
                    $(this).parent().find('input:checkbox').prop('disabled', true);
                    $(this).parent().find('input:checkbox').attr('checked', false);
                }else{
                    $(this).parent().find('input:checkbox').prop('disabled', false);
                }
            });
            $('input:radio:not([name=searchKeywordInputType])').click(function(){
                if($(this).attr('name')=='readYn') return;
                if($(this).val()=='Y'){
                    $(this).parent().parent().parent().find('.button_style').prop('disabled', false);

                    if($(this).attr('name')=='attachYn'){
                        $('input:radio[name=realAttYn]').prop('disabled', false);
                        $('input:radio[name=drmYn]').prop('disabled', false);
                    }
                }else if($(this).val()==''){
                    var codeType = $(this).parent().parent().parent().find('.button_style').attr('id');
                    if(codeType != undefined ){
                        codeType = codeType.substring(0, codeType.length-3);
                        resetCode(codeType);
                    }
                    $(this).parent().parent().parent().find('.button_style').prop('disabled', true);
                    $(this).parent().parent().parent().find('input:checkbox').prop('disabled', true);
                    $(this).parent().parent().parent().find('input:checkbox').attr('checked', false);

                    if($(this).attr('name')=='attachYn'){
                        $('input:radio[name=realAttYn]').prop('disabled', true);
                        $('input:radio[name=drmYn]').prop('disabled', true);
                        $('input:radio[name=realAttYn]:input[value=' + idIndicator('') + ']').prop("checked", true);
                        $('input:radio[name=drmYn]:input[value=' + idIndicator('') + ']').prop("checked", true);
                    }
                }else{
                    var codeType = $(this).parent().parent().parent().find('.button_style').attr('id');
                    if(codeType != undefined ){
                        codeType = codeType.substring(0, codeType.length-3);
                        resetCode(codeType);
                    }
                    $(this).parent().parent().parent().find('.button_style').prop('disabled', true);
                    $(this).parent().parent().parent().find('input:checkbox').prop('disabled', true);
                    $(this).parent().parent().parent().find('input:checkbox').attr('checked', false);

                    if($(this).attr('name')=='attachYn'){
                        $('input:radio[name=realAttYn]').prop('disabled', true);
                        $('input:radio[name=drmYn]').prop('disabled', true);
                        $('input:radio[name=realAttYn]:input[value=' + idIndicator('') + ']').prop("checked", true);
                        $('input:radio[name=drmYn]:input[value=' + idIndicator('') + ']').prop("checked", true);
                    }
                }

                if( $(this).attr('name') == 'receive_option'){
                    if($(this).val()==''){
                        $('.receivers_detail').hide();
                        $('#receivers').parent().show();
                    }else{
                        $('#receivers').parent().hide();
                        $('.receivers_detail').show();
                    }
                }
            });

            $('input:radio').each(function(){
                if($(this).val()=='Y'){
                    $(this).parent().parent().parent().find('.button_style').prop('disabled', false);
                }else if($(this).val()==''){
                    $(this).parent().parent().parent().find('.button_style').prop('disabled', true);
                }else{
                    $(this).parent().parent().parent().find('.button_style').prop('disabled', true);
                }
            });
            $('.filter_menu').click(function(){
                if($(this).hasClass('condition_menu_unselected')){
                    $('.filter_menu').addClass('condition_menu_unselected');
                    $(this).removeClass('condition_menu_unselected');
                    if($(this).attr('id')=='msg_condition_menu'){
                        $('#saveFilterTab').hide();
                        $('#message_folderTab').hide();
                        $('#search_top_area').show();

                    }else if($(this).attr('id')=='msg_condition_saver'){
                        $('#search_top_area').hide();
                        $('#message_folderTab').hide();
                        $('#saveFilterTab').show();
                    }else{
                        $('#search_top_area').hide();
                        $('#saveFilterTab').hide();
                        $('#message_folderTab').show();
                    }
                }

                $('#periodSetupMenu').hide();
            });
            //tab click
            $(document).on('click', '.addTabDiv, .resultCntSpan', function(){
                clickHeader($(this));
            });


            /* 검색어 관리 */
            $('.showSearchKeywordBtn').click(function(){
                $('#searchKeywordDiv').show();
            });


            /* 연관 검색어 */
            $(".relationKeywordBtn").change(function(){
                if($(".relationKeywordBtn").is(":checked")){
                    getRelationKeywordList();
                    $('#relationKeywordDiv').show();
                }else{
                    $('#relationKeywordDiv').hide();
                }
            });

            $('.relationKeywordCloseBtn').click(function(){
                $('#relationKeywordDiv').hide();
            });


            // /* 정규식 검색 */
            // $('.regexSearchBtn').click(function(){
            //     getRegexList();
            //     $('#regexSearchDiv').show();
            // });
            // $('.regexSearchCloseBtn').click(function(){
            //     $('#regexSearchDiv').hide();
            // });
            //
            // $('#regexSearchStrBtn').click(function(){
            //     getRegexList();
            // });

            /* 검색 도움말 */
            $('#searchHelpBtn').click(function(e){
                $('#searchHelpDiv').show();
            });
            $('.searchHelpDivCloseBtn').click(function(){
                $('#searchHelpDiv').hide();
            });

            /* 정규식 검색 도움말 */
            $('#regexpHelpBtn').click(function(e){
                $('#regexpHelpDiv').show();
            });
            $('.regexpHelpDivCloseBtn').click(function(){
                $('#regexpHelpDiv').hide();
            });

            /* 수신자, 발신자 입력옵션 도움말 */
            $('#matchHelpBtn').click(function(e){
                $('#matchHelpDiv').show();
            });
            $('.matchHelpDivCloseBtn').click(function(){
                $('#matchHelpDiv').hide();
            });

            $('.showFilterBtn').click(function(){
                $('#periodSetupMenu').hide();
                $('#filterHeaderDiv').show();
            });
            $('.resetCondition').click(function(){
                /* if(!$('#msg_condition_menu').hasClass('condition_menu_unselected')){
                    con.resetFilter('');
                } */
                con.resetFilter('');
            });

            document.addEventListener('keydown', function(event) {
                if (event.ctrlKey) {
                    switch(event.key) {
                        case "ArrowUp":
                        case "ArrowDown":
                        case "ArrowLeft":
                        case "ArrowRight":
                            event.preventDefault();   // 기본 동작 차단
                            event.stopPropagation();  // 이벤트 전파 중단
                            break;
                    }
                }
            }, true);  // 캡처링 단계에서 이벤트를 처리

            $('.saveCondition').click(function(){
                if(!$('#msg_condition_menu').hasClass('condition_menu_unselected')){
                    $('#periodSetupPop').show();
                    $('#periodSetupDatePop').show();
                    $('#periodSetupMenu').css('height', '260px');
                }
                else if(!$('#msg_condition_saver').hasClass('condition_menu_unselected')){
                    if($('#solrQueryText').val()==''){
                        alert('<s:message code="query.make.input"/>');
                        $('#solrQueryText').focus();
                        return;
                    }
                    $('#periodSetupPop').hide();
                    $('#periodSetupDatePop').hide();
                    $('#periodSetupMenu').css('height', '155px');
                }

                if((!$('#msg_condition_menu').hasClass('condition_menu_unselected') && $('.filterIcon').hasClass('hide') )|| (!$('#msg_condition_saver').hasClass('condition_menu_unselected') && $('.queryIcon').hasClass('hide') )){

                    if(!$('#msg_condition_menu').hasClass('condition_menu_unselected')){
                        $('#startdatepickerPop').data("DateTimePicker").date($('#startdatepicker').data("DateTimePicker").date());
                        $('#enddatepickerPop').data("DateTimePicker").date($('#enddatepicker').data("DateTimePicker").date());
                    }
                }else{
                    var filterTree = $.fn.zTree.getZTreeObj("filterTree");
                    var treeNode;

                    if( !$('#msg_condition_menu').hasClass('condition_menu_unselected') ){
                        $('#filterNamePopInput').val($('.filterIcon').attr('title'));
                        treeNode = filterTree.getNodeByParam("id", $('.filterIcon').attr('data-id'), null);
                    }else if(!$('#msg_condition_saver').hasClass('condition_menu_unselected')){
                        $('#filterNamePopInput').val($('.queryIcon').attr('title'));
                        treeNode = filterTree.getNodeByParam("id", $('.queryIcon').attr('data-id'), null);
                    }

                    $('#filterOptionPopSelect').val(treeNode.userDtCd);
                    if(treeNode.userDtCd == 1){
                        $('#startdatepickerPop').data("DateTimePicker").date(treeNode.startDt.toDate());
                        $('#enddatepickerPop').data("DateTimePicker").date(treeNode.endDt.toDate());
                    }else if(treeNode.userDtCd == 2){
                        var dateObj = new Date();
                        $('#startdatepickerPop').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-treeNode.startDt, 00, 00, 00 ) );
                        $('#enddatepickerPop').data("DateTimePicker").date( new Date( dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate()-treeNode.endDt, 23, 59, 59 ) );
                    }else if(treeNode.userDtCd == 3){

                    }

                }
                $('#periodSetupMenu').show();
            });

            $('#saveMsgData').click(function(){
                saveFolderDataGrid( getIframeListObj().grid );
            });

            $('.searchKeywordCloseBtn').click(function(){
                $('#searchKeywordDiv').hide();
            });

            $('.filterDateCloseBtn').click(function(){
                $('#filterHeaderDiv').hide();
            });

            $('#periodSetupMenuCloseBtn').click(function(){
                $('#periodSetupMenu').hide();
            });

            $("#matchHelpDiv").draggable({
                cancel: ".matchHelpDivBody, .matchHelpDivCloseArea",
                scroll: false,
                containment: "#mainBodyArea",
                start: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
                    $('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
                },
                stop: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'', 'user-select':''});
                    $('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
                }
            });
            /* 조건 보관함 */
            $("#filterHeaderDiv").draggable({
                scroll: false,
                containment: "#mainBodyArea",
                start: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
                    $('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
                },
                stop: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'', 'user-select':''});
                    $('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
                }
            });

            /* 검색어 관리 */
            $("#searchKeywordDiv").draggable({
                scroll: false,
                containment: "#mainBodyArea",
                start: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
                    $('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
                },
                stop: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'', 'user-select':''});
                    $('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
                }
            });

            /* 연관 키워드 */
            $("#relationKeywordDiv").draggable({
                cancel: ".filterSearch, .saveFilterTab_tree",
                scroll: false,
                containment: "#mainBodyArea",
                start: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
                    $('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
                },
                stop: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'', 'user-select':''});
                    $('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
                }
            });

            /* 정규 표현식 */
            $("#regexSearchDiv").draggable({
                // cancel: ".filterSearch, .saveFilterTab_tree",
                // scroll: false,
                // containment: "#mainBodyArea",
                // start: function( event, ui ) {
                //     $('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
                //     $('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
                // },
                // stop: function( event, ui ) {
                //     $('#contentListArea').css({pointerEvents:'', 'user-select':''});
                //     $('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
                // }
            });


            $("#searchHelpDiv").draggable({
                cancel: ".searchHelpDivBody, .searchHelpDivCloseArea",
                scroll: false,
                containment: "#mainBodyArea",
                start: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
                    $('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
                },
                stop: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'', 'user-select':''});
                    $('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
                }
            });

            $("#regexpHelpDiv").draggable({
                cancel: ".regexpHelpDivBody, .regexpHelpDivCloseArea",
                scroll: false,
                containment: "#mainBodyArea",
                start: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
                    $('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
                },
                stop: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'', 'user-select':''});
                    $('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
                }
            });

            $("#periodSetupMenu").draggable({
                cancel: ".filterDatePopArea, .filterDateBtnPopArea, .filterDateCloseBtn, input-group-addon",
                scroll: false,
                containment: "#mainBodyArea",
                start: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
                    $('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
                },
                stop: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'', 'user-select':''});
                    $('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
                }
            });

            $("#searchKeywordDiv").resizable({
                maxWidth: 500,
                minHeight: 200,
                minWidth: 300,
                containment: "#mainBodyArea",
                start: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
                    $('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
                },
                stop: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'', 'user-select':''});
                    $('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
                }
            });

            $("#filterHeaderDiv").resizable({
                maxWidth: 300,
                minHeight: 200,
                minWidth: 210,
                containment: "#mainBodyArea",
                start: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'none', 'user-select':'none'});
                    $('#contentBodyArea').css({pointerEvents:'none', 'user-select':'none'});
                },
                stop: function( event, ui ) {
                    $('#contentListArea').css({pointerEvents:'', 'user-select':''});
                    $('#contentBodyArea').css({pointerEvents:'', 'user-select':''});
                }
            });

            $('.filterIcon, .queryIcon').click(function(){
                $(this).addClass('hide');
                $(this).attr('title', '');
                $(this).attr('data-id', '');
            });
            $(document).on('click', '.viewSetup .dropdown-menu, .bootstrap-select .dropdown-menu', function (e) {
                //$(document).on('click', '.viewSetup .dropdown-menu', function (e) {
                e.stopPropagation();
            });

            $(document).on('click', '.all_down_link', function(){
                var searchType = $(this).attr('data-type');
                $('#searchType').val(searchType);
                var title = $(this).text();
                $('#exportTitle').text(title+' '+'<s:message code="common.msg.export"/>');

                $('#exportDialog').modal('show');
            });

            $("#exportDialog").on('show.bs.modal', function() {
                $('input:radio[name=exportDataRange]:input:checked').prop("checked", false);

                var grid = getIframeListObj().grid;
                var rows = grid.getSelectedKey('msgid').length;
                var total = grid.data.length;

                if(total == 0){
                    ui.alertMsg('<s:message code="common.msg.nodata"/>');
                    return false;
                }

                var searchType = $('#searchType').val();
                var consentNo = grid.getValue(0, 'consentNo');
                if( searchType != 'L'){

                    if(isConsent() && consentNo == '' && '<%=adminType%>' != 'C'){
                        alert('<s:message code="download.msg.consent"/>');
                        return false;
                    }
                }

                if(searchType != "L" && searchType.indexOf('L') > -1) {
                    if($('input:radio[name=exportFileType]:input:checked').val() == "xlsx") {
                        $("input:radio[name='bodyInExcel']:radio[value='N']").prop("checked", true);
                        $('#bodyInExcel').show();
                        $('#bodyInExcelMsg').hide();
                        $('#bodyInExcelIdx').hide();
                    }else {
                        $('#bodyInExcel').hide();
                        $('#bodyInExcelMsg').hide();
                        $('#bodyInExcelIdx').hide();
                    }
                } else {
                    $('#bodyInExcel').hide();
                    $('#bodyInExcelMsg').hide();
                    $('#bodyInExcelIdx').hide();
                }


                $('#searchTime').val('');
                $('#searchCondition').val('');
                $('#searchHeader').val('');
                $('#searchTotal').val('');
                $('#dataLength').val('');
                $('#exportFileExt').val('');

                if( (rows > checkMsgCnt) || (rows == 0 && grid.data.length > checkMsgCnt)){
                    $('input:radio[name=exportDataRange]:input[value=A]').parent().click();
                }else{
                    $('input:radio[name=exportDataRange]:input[value=S]').parent().click();
                }
            });

            $( 'input[name="exportDataRange"]:radio' ).change(function(){
                var grid = getIframeListObj().grid;
                var rows = grid.getSelectedKey('msgid').length;
                var total = getIframeListObj().$('#busiCntArea').find('.tab_selected').find('.busiCnt').text();
                total = total.replace(re,"")
                var downTotal = total;
                var exportDataRange = $(this).val();
                if( exportDataRange == 'S'){
                    $('#sizeWarnMsg').hide();

                    if( rows > 0) downTotal = rows;
                    else downTotal = grid.data.length;

                    if( downTotal > checkMsgCnt){
                        ui.alertMsg('<s:message code="download.message.check.total" arguments="'+addCommas(checkMsgCnt)+'" argumentSeparator="|"/>');
                        $('input:radio[name=exportDataRange]:input[value=A]').parent().click();
                        return;
                    }
                }

                var searchType = $('#searchType').val();
                if( searchType.indexOf('L') > -1){
                    $('#exportFileTypeArea').show();
                    if(downTotal > 50000){
                        $('#sizeWarnMsg').show();
                    }else{
                        $('#sizeWarnMsg').hide();
                    }
                }
                else {
                    $('#exportFileTypeArea').hide();
                    $('#sizeWarnMsg').hide();
                }
                $('#exportDataSize').text(addCommas(downTotal));
                $('#searchTotal').val(downTotal);
            });

            $('input[name="exportFileType"]:radio').change( function() {
                var searchType = $('#searchType').val()

                if(searchType != "L" && searchType.indexOf('L') > -1) {
                    if($(this).val() == "xlsx") {
                        $("input:radio[name='bodyInExcel']:radio[value='N']").prop("checked", true);
                        $('#bodyInExcel').show();
                        $('#bodyInExcelMsg').hide();
                        $('#bodyInExcelIdx').hide();
                    }else {
                        $('#bodyInExcel').hide();
                        $('#bodyInExcelMsg').hide();
                        $('#bodyInExcelIdx').hide();
                    }
                } else {
                    $('#bodyInExcel').hide();
                    $('#bodyInExcelMsg').hide();
                    $('#bodyInExcelIdx').hide();
                }
            });

            $('input[name="bodyInExcel"]:radio').change( function() {
                if($(this).val() == "Y") {
                    $('#bodyInExcelMsg').show();
                    var col = JSON.parse(getIframeListObj().grid.getHeaderEXCEL());
                    var colStr = col.map(function(i) { return i.title });
                    $('#nowColIdx').html(setNowColIdx(colStr));
                    $('#bodyInExcelIdx').show();
                }else {
                    $('#bodyInExcelMsg').hide();
                    $('#bodyInExcelIdx').hide();
                }
            });

            $(document).on('click', '.print_link_new', function(){
                var grid = getIframeListObj().grid;
                var title = $(this).attr('rel');
                if (grid.data.length == 0) {
                    alert('<s:message code="common.msg.nodata"/>');
                    return;
                }

                grid.print(title, pMenuId, menuId);
            });
            $('#allDownBtn').click(function(){
                var grid = getIframeListObj().grid;
                var rows = grid.getSelectedKey('msgid').length;
                var total = getIframeListObj().$('#busiCntArea').find('.tab_selected').find('.busiCnt').text();
                total = total.replace(re,"")
                grid.on();
                var bodyInExcel = $('input:radio[name=bodyInExcel]:input:checked').val();
                var header = grid.getHeaderEXCEL();
                if(bodyInExcel == "Y") {
                    header = JSON.parse(header);
                    header.splice($('#nowColIdx').val(),0,{"key":"body","title":"<s:message code='condition.body' />","width":410,"align":"left"});
                    header = JSON.stringify(header);
                }
                var param = JSON.stringify( getIframeListObj().filterValData );
                var dataLength = $('#dataLength_select').selectpicker('val');
                var searchType = $('#searchType').val();
                var exportFileType = $('input:radio[name=exportFileType]:input:checked').val();
                var exportDataRange = $('input:radio[name=exportDataRange]:input:checked').val();

                $('#searchTime').val(getIframeListObj().$('#searchTime').val());
                $('#searchCondition').val(param);
                $('#searchHeader').val(header);
                $('#dataLength').val(dataLength);
                $('#exportFileExt').val(exportFileType);

                if( exportDataRange == 'A'){
                    //중복체크
                    ui.get({
                        url: 'checkDownloadBatchExist.xcn',
                        searchCondition: param,
                        searchTotal: $('#searchTotal').val(),
                        searchType: searchType,
                        exportFileExt: exportFileType,
                        success: function (data, total) {
                            if (data > 0) {
                                downloadBatchExist = true;
                            } else {
                                downloadBatchExist = false;
                            }
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            if (downloadBatchExist) {
                                ui.alertMsg('<s:message code="download.msg.exist" />');
                            } else {
                                $('#isBackground').val('Y');
                                if (searchType == 'B') {
                                    $('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveBatchZip.xcn"/>');
                                    $('#allDownForm').submit();
                                } else if (searchType == 'A') {
                                    $('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveBatchZip.xcn"/>');
                                    $('#allDownForm').submit();
                                } else if (exportFileType == 'xlsx' || exportFileType == 'cell') {
                                    $('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveBatchZip.xcn"/>');
                                    $('#allDownForm').submit();
                                } else if (exportFileType == 'csv') {
                                    $('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveBatchCSV.xcn"/>');
                                    $('#allDownForm').submit();
                                } else if (exportFileType == 'pdf') {
                                    $('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveBatchPDF.xcn"/>');
                                    $('#allDownForm').submit();
                                }
                            }
                        }
                    });

                }else{
                    $('#isBackground').val('N');
                    if( searchType == 'B'){
                        $('.body_link_new').click();
                    }else if(searchType == 'A' ){
                        $('.attach_link_new').click();
                    }
                    else if(searchType == 'LB' || searchType == 'LBA' ){
                        var msgids = grid.getSelectedKey('msgid');
                        if( msgids.length == 0 ){
                            msgids = grid.getKeyData('msgid');
                        }
                        var selected_condition = {};
                        selected_condition.msgids = msgids;
                        selected_condition.sort = $('#messageSort').val();

                        $('#searchCondition').val(JSON.stringify( selected_condition ));
                        $('#searchTotal').val(msgids.length);

                        if(exportFileType == 'xlsx' || exportFileType == 'cell'){
                            $('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveZip.xcn"/>');
                            $('#allDownForm').submit();
                        }else if(exportFileType == 'csv'){
                            $('#allDownForm').attr('action', '<c:url value="/getEmassMessageSaveCSV.xcn"/>');
                            $('#allDownForm').submit();
                        }else if(exportFileType == 'pdf'){
                            $('#allDownForm').attr('action', '<c:url value="/getEmassMessageSavePDF.xcn"/>');
                            $('#allDownForm').submit();
                        }
                    }else{
                        if(exportFileType == 'xlsx'){
                            $('.excel_link_new').click();
                        }else if(exportFileType == 'cell'){
                            $('.cell_link_new').click();
                        }else if(exportFileType == 'csv'){
                            $('.csv_link_new').click();
                        }else if(exportFileType == 'pdf'){
                            $('.pdf_link_new').click();
                        }
                    }
                }

                $('#exportDialog').modal('hide');
                setTimeout(function(){
                    grid.off();
                }, 500);
            });
            $(document).on('click', '.excel_link_new', function(){
                var grid = getIframeListObj().grid;
                var title = $(this).attr('rel');
                var option = $(this).attr('option');
                grid.on();
                setTimeout(function(){
                    excelDownLoad(grid, title, null, null, option);
                }, 200);
            });
            $(document).on('click', '.cell_link_new', function(){
                var grid = getIframeListObj().grid;
                var title = $(this).attr('rel');
                var option = $(this).attr('option');
                grid.on();
                setTimeout(function(){
                    cellDownLoad(grid, title, null, null, option);
                }, 200);
            });

            $(document).on('click', '.pdf_link_new', function(){
                var grid = getIframeListObj().grid;
                var title = $(this).attr('rel');
                var option = $(this).attr('option');
                grid.on();
                setTimeout(function(){
                    pdfDownLoad(grid, title, null, null, option);
                }, 200);
            });
            $(document).on('click', '.csv_link_new', function(){
                var grid = getIframeListObj().grid;
                var title = $(this).attr('rel');
                var option = $(this).attr('option');
                grid.on();
                setTimeout(function(){
                    csvDownLoad(grid, title, null, null, option);
                }, 200);
            });
            $(document).on('click', '.body_link_new', function(){
                var grid = getIframeListObj().grid;
                if (grid.Rows == 0) {
                    alert('<s:message code="common.msg.nodata"/>');
                    return;
                }

                grid.on();
                setTimeout(function(){
                    var msgid = grid.getSelectedKey('msgid');
                    if(msgid.length == 0) msgid = grid.getKeyData('msgid');

                    $('#msgId').val('');
                    $('#msgIds').val('');
                    if(msgid.length==1){
                        $('#msgId').val(msgid.join(','));
                        $('#downForm').attr('action', '<c:url value="/getEmassBodySave.xcn"/>');
                    } else {
                        $('#msgIds').val(msgid.join(','));
                        $('#downForm').attr('action', '<c:url value="/getEmassBodySaveZip.xcn"/>');
                    }
                    $('#downForm').submit();
                    grid.off();
                }, 300);
            });
            $(document).on('click', '.attach_link_new', function(){
                var grid = getIframeListObj().grid;
                if(grid.Rows == 0 ) return;
                grid.on();
                
                var msgids = [];
                setTimeout(function () {
                    var msgid  = grid.getSelectedKey('msgid');
                    var attachcnt  = grid.getSelectedKey('attachcnt');
                    
                    var datas = new Array();
                    if (msgid.length == 0) {
                        msgid = grid.getKeyData('msgid');
                        attachcnt = grid.getKeyData('attachcnt');
                    }
                    $.each(msgid,function (i,e){
                        for(var k =0;k < attachcnt.length ; k++){
                            datas[i] = new Array(e,attachcnt[i]);
                        }
                    });
                    $.each(datas,function (i,e){
                       if(e[1] > 0) msgids.push(e[0]);
                    })
    
                    if(msgids.length == 0) {
                        alert('<s:message code="common.msg.nodata"/>');
                        return;
                    }
                    
                    
                    $('#msgIds').val(msgids.join(','));
                    $('#downForm').attr('action', '<c:url value="/downEmassAttachByMsgId.xcn"/>');
                    $('#downForm').submit();
                    grid.off();
                }, 300);
            });
            $(document).on('click', '.downList', function(){
                var url    = '<c:url value="/commons/downList.do"/>';
                fnOpenWindow(url, 'downInfoPop', 1400, 580, 'resize');
            });
            $('.searchQueryBtn').click(function(){
                queryMakePop();
            });
            $("#config_colse").click(function(){
                $("#config_toggle").click();
            });

            readyCheckParam();
            $('#condition_detail').scroll(function(){
                if($(this).scrollTop()>70){
                    $('.condition_top').fadeIn();
                    $('.condition_top_sub').fadeIn();
                }else{
                    $('.condition_top').fadeOut();
                    $('.condition_top_sub').fadeOut();
                }
            });
            $($('.condition_top')).click(function(){
                $('#condition_detail').animate({
                    scrollTop: $('#condition_detail').offset().top-206
                }, 200);
            });

            initHeaderTab();
            getSearchKeywordList();
            initConfAdminOption();
            
            // 각 그룹별로 단일 선택 설정
            setupSingleSelectCheckbox('senders', ['senders_findByKeyword', 'senders_findByParam']);
            setupSingleSelectCheckbox('receivers', ['receivers_findByKeyword', 'receivers_findByParam']);
            setupSingleSelectCheckbox('m_to', ['m_to_findByKeyword', 'm_to_findByParam']);
            setupSingleSelectCheckbox('m_cc', ['m_cc_findByKeyword', 'm_cc_findByParam']);
            setupSingleSelectCheckbox('m_bcc', ['m_bcc_findByKeyword', 'm_bcc_findByParam']);
        });



        // 체크박스 그룹별 단일 선택 기능
        function setupSingleSelectCheckbox(groupName, checkboxIds) {
            checkboxIds.forEach(function(checkboxId) {
                $('#' + checkboxId).on('change', function() {
                    if($(this).is(':checked') && !$(this).prop('disabled')) {
                        // 같은 그룹의 다른 체크박스들 해제
                        checkboxIds.forEach(function(otherId) {
                            if(otherId !== checkboxId) {
                                $('#' + otherId).prop('checked', false);
                            }
                        });
                    }
                });
            });
        }

        function setNowColIdx(colStr) {
            var result = "";
            for(var i=0; i<colStr.length; i++) {
                result += '<option value="' + (i+1) + '">' + colStr[i] + '</option>';
            }

            return result;
        }

        function readyCheckParam(){
            if(readyFlag){
                checkParam( );
            }else{
                setTimeout(function(){
                    readyCheckParam( );
                }, 500);
            }
        }

        function checkParam(){
            if( filterSeq === 0 || (filterSeq == '' && conditionParam == '')) return;

            else if( filterSeq != ''){
                var data = zTree.getNodeByParam("id", filterSeq);
                if( data == undefined ){
                    alert("<s:message code="common.msg.connect.error"/>");
                    //화면을 대쉬보드로 이동 시킴
                    goMainPage();
                    return;
                }
                if( data.conditions == '') return;

                var filterVal = {};
                if(data.filterType == 'D'){
                    filterVal.conditions = JSON.parse(data.conditions);
                    rtnFilterClick(filterVal, 'searchCondition');
                }else{
                    var newTreeNode = $.extend(true, {}, data);
                    newTreeNode.filterName = newTreeNode.name;
                    newTreeNode.filter_seq = newTreeNode.id;
                    newTreeNode.p_filter_seq = newTreeNode.pId;
                    newTreeNode.filterType = newTreeNode.filterType;

                    var conditions = [];
                    var condition = {};
                    condition.period = newTreeNode.userDtCd;
                    condition.startDt = newTreeNode.startDt;
                    condition.endDt = newTreeNode.endDt;
                    condition.query = createSolrQuery(condition.period, condition.startDt, condition.endDt, newTreeNode.conditions);
                    conditions.push(condition);
                    newTreeNode.conditions = conditions;

                    rtnFilterClick(filterVal, 'searchQuery');
                }
            }else if( conditionParam != '' ){
                isAutoSearch = true; // dashboard에서 자동 검색 플래그 설정
                try{
                    setTimeout(function(){
                        con.setCondition(JSON.parse(conditionParam), '');
                        getIframeListObj().initGrid();
                        searchData( );
                        isAutoSearch = false; // 검색 후 플래그 해제
                    },500);
                }catch(e){
                    console.log('<s:message code="common.msg.data.error"/>');
                    isAutoSearch = false; // 에러 시 플래그 해제
                    //goMainPage();
                }
            }
        }

        function clickHeader(obj){

            if(tabIsSelected(obj)) return;
            $('.listTab_div').css("width","83%");
            var index = $(obj).parents('li').attr('data-index');
            if(index == ''){
                if( addTabFlag ) return;
                con.resetFilter('');
                addTab();
                return;
            }
            con.resetFilter('');
            changeTab($(obj));

        }

        /* tab close class 지정 */
        function tabIsSelected(obj){
            var result = false;


            if($(obj).parents('li').hasClass('select')){
                result = true;
            }

            return result;
        }

        //일반 검색
        function searchData( ){

            // 체크박스 검증: 입력값이 있으면 체크박스가 선택되어야 함 (자동 검색인 경우 제외)
            if(!isAutoSearch) {
                var checkboxGroups = [
                    { inputId: 'senders', checkboxIds: ['senders_findByKeyword', 'senders_findByParam'] },
                    { inputId: 'receivers', checkboxIds: [ 'receivers_findByKeyword', 'receivers_findByParam'] },
                    { inputId: 'm_to', checkboxIds: ['m_to_findByKeyword', 'm_to_findByParam'] },
                    { inputId: 'm_cc', checkboxIds: ['m_cc_findByKeyword', 'm_cc_findByParam'] },
                    { inputId: 'm_bcc', checkboxIds: [ 'm_bcc_findByKeyword', 'm_bcc_findByParam'] }
                ];

                for(var i = 0; i < checkboxGroups.length; i++) {
                    var group = checkboxGroups[i];
                    var inputValue = $('#' + group.inputId).val();
                    if(inputValue && inputValue.trim() !== '') {
                        var hasChecked = false;
                        for(var j = 0; j < group.checkboxIds.length; j++) {
                            var checkboxId = group.checkboxIds[j];
                            if($('#' + checkboxId).is(':checked') && !$('#' + checkboxId).prop('disabled')) {
                                hasChecked = true;
                                break;
                            }
                        }
                        if(!hasChecked) {
                            ui.alertMsg(message.checkboxSelectRequired);
                            searchFlag = false;
                            break;
                        }
                    }
                }
            }
            //체크로직 및 분기
            getList('D');

        }

        //고급 검색식 검색
        function toggleSolrQuery(){
            if($('#solrQueryText').val() == ''){
                alert('<s:message code="query.make.empty.search"/>');
                return;
            }
            getList('Q');
        }
        function getList(type){
            var startSize = $('#sizeStartVal').val();
            var endSize = $('#sizeEndVal').val();

            if(type != 'Q') {

                if((!$.isNumeric(startSize) && startSize != '') || (!$.isNumeric(endSize) && endSize) ) {
                    alert('<s:message code="message.msg.filesize.validity"/>');
                    return;
                }

                if(startSize.length > 12 || endSize.length > 12){
                    alert('<s:message code="message.msg.filesize.validity2"/>');
                    return;
                }

                if(Number(startSize) < 0 || Number(endSize) < 0){
                    alert('<s:message code="message.msg.filesize.minus"/>');
                    return;
                }

                if($('#sizeOption').val() == 'B') {
                    if((startSize == '' && endSize != '') || (startSize != '' && endSize == '')) {
                        alert('<s:message code="message.msg.filesize.rangeStartEnd"/>');
                        return;
                    }

                    if(Number(startSize) > Number(endSize) ){
                        alert('<s:message code="message.msg.filesize.range"/>');
                        return;
                    }
                }

                if( $('#startdatepicker').val() > $('#enddatepicker').val() ) {
                    alert('<s:message code="blockHistoryNonBusi.msg.cannot.startendtime"/>');
                    return;
                }
            } else {
                var search = solrHighlight($('#solrQueryText').val());
                $('#searchQueryStrInput').val(search);
            }

            var filterVal = $.extend(true, {}, getIframeListObj().filterValData);
            if($("input:checkbox[id='researchCheckbox']").is(":checked") && getIframeListObj().searchedFlag){
                addTab();
            }

            getIframeListObj().filterValData = filterVal;
            getIframeListObj().tabType = type;
            getIframeListObj().tabId = $('#resultTabs .select').attr('id');
            getIframeListObj().getList('', con.getFilterVal('', type));
        }

        var tabIdx = 0;
        function addTab(){
            if( addTabFlag ) return;

            addTabFlag = true;
            $('.addTabLi span').removeClass('glyphicon glyphicon-plus').addClass('fa fa-spinner fa-spin');

            tabIdx++;
            addTabHeader(tabIdx);
            addTabBody(tabIdx);
            changeTab($('#result'+tabIdx + ' .addTabDiv'));
        }


        function setFeedback(value) {
            getIframeListObj().setFeedback(value);
        }
        function addTabHeader(idx){
            $('#resultTabs').find('li').last().remove();

            var obj = $('#newTab').clone();
            var liObj = obj.find('.tab_li');
            liObj.attr('id', 'result'+idx);
            liObj.attr('data-index', idx);
            /* 첫 tab 생성시 white색상 close class 고정 */
            obj.find('.tab_close').attr('id', 'result_close'+idx);
            obj.find('.addTabDiv').text('<s:message code="message.msg.newtab"/>');

            //$('#resultTabs').append(obj.html() + $('#addTab').clone().html());

            headerScrollTabs.addTab(obj.html() + $('#addTab').clone().html());
        }
        function addTabBody(idx){
            var contentListHtml = '<iframe src="<c:url value="/ems/contentList.do?gridInit="/>" id="contentList'+(idx+1)+'" class="contentList" style="left:-10000px;"></iframe>';
            var contentBodyHtml = '<iframe src="<c:url value="/ems/contentBodyNew.do"/>" id="contentBody'+(idx+1)+'" class="contentBody" name="contentBody" style="left:-10000px;"></iframe>';

            $('.contentList').css('left', '-10000px');
            $('.contentBody').css('left', '-10000px');
            $('#contentList'+idx).css('left', '0px');
            $('#contentBody'+idx).css('left', '0px');

            $('#contentListArea').append(contentListHtml);
            $('#contentBodyArea').append(contentBodyHtml);
        }

        function setAddTabFlag(flag){
            addTabFlag = flag;

            if(flag) $('.addTabLi span').removeClass('glyphicon glyphicon-plus').addClass('fa fa-spinner fa-spin');
            else $('.addTabLi span').removeClass('fa fa-spinner fa-spin').addClass('glyphicon glyphicon-plus');
        }

        function setResultCnt(id, cnt){
            $('#'+id+' .resultCntSpan').text('('+cnt+')');
        }

        function changeTab(obj){
            if( obj == undefined ) return;

            var parentObjId = obj.parents('li').attr('id');
            var objLi = $('#'+parentObjId);
            var index = objLi.attr('data-index');

            $('.addTabDiv').parents('li').removeClass('select');
            objLi.addClass('select');

            var tabLength = $('#resultTabs').find('li').length-1;
            var selectIdx = $('#resultTabs').find('li').find('.tab_close').parent('.select').index()-1;
            $.each($('#resultTabs').find('li'), function (index, item) {
                if(index == 0 | index == tabLength ) return;

                if (index == selectIdx) {
                    var selected = $('#resultTabs').find('li')[selectIdx];
                    var selectedTab = $(selected).find('div')[0]
                    $(selectedTab).attr('class','tab_close tab_1')
                } else {
                    var selected = $('#resultTabs').find('li')[index];
                    var selectedTab = $(selected).find('div')[0]
                    $(selectedTab).attr('class','tab_close tab_2')
                }
            });


            $('.contentList').css('left', '-10000px');
            $('#contentList'+index).css('left', '0px');
            $('.contentBody').css('left', '-10000px');
            $('#contentBody'+index).css('left', '0px');

            getIframeListObj().initGrid();
            if(getIframeListObj().filterValData == undefined){
                if(!$("input:checkbox[id='researchCheckbox']").is(":checked")){
                    con.resetFilter('');
                }
            }else{
                con.setFilterVal(getIframeListObj().filterValData);

                if( getIframeListObj().tabType == 'Q'){
                    $('#msg_condition_saver').click();
                }else{
                    $('#msg_condition_menu').click();
                }
            }
        }
        //현재 선택된 탭의 탭이름 변경
        function changeTabName(id, text, researchCnt){
            var researchMsg = '';
            if( researchCnt > 0) researchMsg = 'Re'+researchCnt+') ';
            var obj = $('#'+id+' .addTabDiv');
            if(text != undefined && text != ''){
                obj.text(researchMsg + text);
            }else if( !$('#msg_condition_menu').hasClass('condition_menu_unselected') ){
                if($('.filterIcon').hasClass('hide')){
                    obj.text(researchMsg+'<s:message code="message.msg.result.search"/>');
                    obj.attr('title', researchMsg+'<s:message code="message.msg.result.search"/>');
                }else{
                    obj.text(researchMsg+'['+$('.filterIcon').attr('title')+']');
                    obj.attr('title', researchMsg+'['+$('.filterIcon').attr('title')+']');
                }
            }else if(!$('#msg_condition_saver').hasClass('condition_menu_unselected')){
                obj.text('<s:message code="message.msg.deepsearch"/>');
                obj.attr('title', '<s:message code="message.msg.deepsearch"/>');
            }
        }

        function delTab(obj){
            var idx = obj.attr('data-index');
            var changeObj;

            var delId = obj.attr('id');
            if(obj.hasClass('select')){
                if( obj.next().length > 0 && !obj.next().hasClass('addTabLi')){
                    changeObj = obj.next().children().first();
                }else{
                    changeObj = obj.prev().children().first();
                }
            }

            $('#contentList'+idx).remove();
            $('#contentBody'+idx).remove();
            //obj.remove();
            headerScrollTabs.removeTabs(obj)
            return changeObj;
        }

        function deleteSearchKeywordList(){
            var rows = grid.getSelectedKey('skSeq');
            if( rows == '' ) {
                ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                return;
            }
            grid.on();
            ui.confirmMsg( '<s:message code="searchKeyword.msg.confirm.delete"/>', '', '', function(rs){
                if(rs){
                    ui.get({
                        url : 'deleteSearchKeywordList.xcn',
                        skSeq : rows.join(','),
                        success : function ( data, total ) {
                            ui.alertMsg('<s:message code="common.msg.deleted"/>');
                            getSearchKeywordList();
                        },
                        error : function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete : function (){
                            grid.off();
                        }
                    });
                } else {
                    grid.off();
                }
            });
        }

        function insertSearchKeywordList(){
            var searchKeyword = $('#searchKeywordSearchStr').val();
            if( searchKeyword == '' ) {
                ui.alertMsg('<s:message code="searchKeyword.msg.input.insert"/>');
                return;
            }
            grid.on();
            ui.get({
                url : 'insertSearchKeywordList.xcn',
                searchKeyword : searchKeyword,
                success : function(data, total) {
                    $('#searchKeywordSearchStr').val('');
                    getSearchKeywordList();
                    ui.alertMsg('<s:message code="searchKeyword.msg.insert"/>');
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                    grid.off();
                }
            });
        }

        function getSearchKeywordList(){
            var searchKeyword = $('#searchKeywordSearchStr').val();
            ui.get({
                url : 'getSearchKeywordList.xcn',
                searchKeyword : searchKeyword,
                success : function(data, total) {
                    grid.setData(data);
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
        }

        function openMessageFolder(){
            var pop = fnOpenWindow('', 'messageFolder', 1100, 850, 'resize');

            var nodes = $.fn.zTree.getZTreeObj('folderTree').getSelectedNodes();
            $('#paramFolderSeq').val(nodes[0].id);
            $('#paramFolderName').val(nodes[0].name);
            $('#messageFolderForm').submit();

            return pop;
        }

        function getSelectedTab(){
            return $('#resultTabs').find('.select');
        }
        function getSelectedTabIndex(){
            var selectedTabIdx = $('#resultTabs').find('.select').attr('data-index');

            if(selectedTabIdx == undefined){
                selectedTabIdx = $('#resultTabs').find('.tab_li').eq(-2).attr('data-index');
            }
            return selectedTabIdx;
        }
        function getIframeListObj(){
            var contentList = document.getElementById("contentList"+getSelectedTabIndex());

            var listDoc = (contentList.contentWindow) ? contentList.contentWindow : (contentList.contentDocument.document) ? contentList.contentDocument.document : contentList.contentDocument;

            return listDoc;
        }
        function getIframeBodyObj(){
            var contentBody = document.getElementById("contentBody"+getSelectedTabIndex());
            var bodyDoc = (contentBody.contentWindow) ? contentBody.contentWindow : (contentBody.contentDocument.document) ? contentBody.contentDocument.document : contentBody.contentDocument;
            return bodyDoc;
        }
        function getFormatVal(){
            ui.get({
                url : 'getConfAdmin.xcn',
                confId : 'message.user.format',
                success : function(data, total) {
                    var dataVal = '';
                    if( data == null){
                        setConfAdmin('message.user.format','#name#/#email#/#businm#/#deptnm#/#jikgubnm#/#ip#');
                        getFormatVal();
                        return;
                    }
                    dataVal = data.val.replaceAll('#','');
                    $('#insaFormatInput').val(dataVal);
                    $("#messageFormat").val('');
                    $("#messageFormat").focus();
                    $("#messageFormat").find("option").each(function(){
                        if(dataVal==$(this).attr('data-format')){
                            $(this).prop("selected", true);
                            $(this).click();
                        }
                    });
                    if($("#messageFormat").val()==''){
                        dataVal = dataVal.replaceAll('name','<s:message code="message.help.sample_name"/>');
                        dataVal = dataVal.replaceAll('email','hong@xcurent.com');
                        dataVal = dataVal.replaceAll('businm','<s:message code="message.help.sample_bunm"/>');
                        dataVal = dataVal.replaceAll('deptnm','<s:message code="message.help.sample_deptnm"/>');
                        dataVal = dataVal.replaceAll('jikgubnm','<s:message code="message.help.sample_jikgubnm"/>');
                        dataVal = dataVal.replaceAll('ip','192.168.0.1');
                        dataVal = '<s:message code="message.help.example"/>) '+dataVal
                        $("#insaFormatInputEx").val(dataVal);
                    }
                },

                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
        }
        function getMsgPosition(){
            ui.get({
                url : 'getConfAdmin.xcn',
                confId : 'msgPosition',
                success : function(data, total) {
                    if( data == null){
                        $('#none_btn').click();
                        return;
                    }

                    if( data.val == 'R') $('#right_btn').click();
                    else if( data.val == 'B') $('#bottom_btn').click();
                    else $('#none_btn').click();
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
        }
        function getFilterSearchBox(){
            ui.get({
                url : 'getConfAdmin.xcn',
                confId : 'filterSearchBox',
                success : function(data, total) {
                    if( data == null){
                        $('input:checkbox[id="searchBox"]').attr("checked", false);
                        return;
                    }
                    if( data.val == 'Y') $('input:checkbox[id="searchBox"]').attr("checked", true);
                    else $('input:checkbox[id="searchBox"]').attr("checked", false);
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
        }
        function setConfAdmin(confId, val){
            ui.get({
                url : 'setConfAdmin.xcn',
                confId : confId,
                val : val,
                success : function(data, total) {
                    if(confId == 'message.user.format' ){
                        $('#confAccept').show();
                        $('#insaFormatInput').css('width','310px');
                        $('#insaFormatInput').animate({'background-color':'#rgb(137, 222, 120)',duration: '1000'},
                            function() {
                                $('#insaFormatInput').animate({'background-color':'#fff',duration: '1000'});
                            });
                    }
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
        }

        function regexpInfoViewer(row, selectedGrid){
            return getIframeListObj().regexpInfoViewer(row, selectedGrid);
        }

        function userInfoViewer(row, type, selectedGrid){
            return getIframeListObj().userInfoViewer(row, type, selectedGrid);
        }

        function fileInfoViewer( row, selectedGrid ){
            return getIframeListObj().fileInfoViewer( row, selectedGrid );
        }

        function ocrFileInfoViewer( row, selectedGrid ){
            getIframeListObj().ocrFileInfoViewer( row, selectedGrid );
        }

        function searchConsentNo(){
            var url    = '<c:url value="/ems/selectConsent.do"/>';
            return fnOpenWindow(url, 'selectConsentWinPopup', 1000, 700, 'resize');
        }
        function resetConsentNo(){
           $('.listTab_div').css("width","83%");
            $('#consentNo').val('');
            $('#consentName').text('');
            $('#consentShortName').val('');
            $('#consentUserId').val('');
            $('#consentBtn').removeClass('active');
        }
        function selectedConsent( obj ){
            if( obj == ''){
                resetConsentNo();
            }else{
                $('#consentNo').val(obj.no);
                $('#consentName').text(obj.name + "["+obj.userId+", "+obj.deptNm+"]");
                $('#consentShortName').val(obj.name);
                $('#consentUserId').val(obj.userId);
                $('#consentBtn').addClass('active');
            }
        }

        function queryMakePop(  ){
            var url    = '<c:url value="/commons/queryMake.do?statType=users"/>';
            fnOpenWindow(url, 'queryMakePop', 1500, 1000, 'resize');
        }

        function getSearchQuery() {

        }
        function confIconHide() {
            $('#confError').hide();
            $('#confAccept').hide();
            $('#insaFormatInput').css('width','330px');
        }

        function initHeaderTab(){
            if( headerScrollTabs != undefined) headerScrollTabs.destroy();
            headerScrollTabs = $('#resultTabs').scrollTabs({

                click_callback: function(e){
                    if($(e.delegateTarget).hasClass('scroll_tab_last')){
                        clickHeader($(this).find('.addTabDiv'));
                    }else{
                        if($(e.target).hasClass('tab_close')){
                            var changeObj = delTab($(e.target).parent());
                            if(changeObj != undefined) {
                                var resultId = changeObj.attr('id');

                                changeTab($('#'+resultId));
                            }
                        }else{
                            clickHeader($(this).find('.addTabDiv'));
                        }
                    }
                }
            });
        }

        /**
         * 고급검색 쿼리 텍스트 추출 (정규 표현식을 이용한 텍스트만 추출)
         * 하일라이팅을 위한 처리
         */
        function solrHighlight(val){
            var result = '';
            ui.get({
                url : 'getSolrHighlightStr.xcn',
                val : val,
                asyncFlag : false,
                success : function(data, total) {
                    result = data.val;
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
            return result;
        }

        function setConfAdminOption(confId,val){
            ui.get({
                url : 'setConfAdminOption.xcn',
                confId : confId,
                val : val,
                success : function(data, total) {

                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
        }

        var keywordHighlight = true;
        var hostQuery = true;
        var recvSum = true;

        function initConfAdminOption() {
            ui.get({
                url : 'getConfAdminOption.xcn',
                success : function(data, total) {
                    if(data.length > 0 ) {
                        for (var i = 0; i < data.length; i++) {
                            if(data[i]['confId'] == 'body.snippet.sum.use') $('[name=subjectbody]').prop('checked', data[i]['val'] == 'Y' ? true : false);
                            else if(data[i]['confId'] == 'message.overlap.use') $('[name=overlapUse]').prop('checked', data[i]['val'] == 'Y' ? true : false);
                            else if(data[i]['confId'] == 'toccbcc.sum.use') recvSum = data[i]['val'] == 'Y' ? true : false;
                            else if(data[i]['confId'] == 'message.keyword.highlight') keywordHighlight = data[i]['val'] == 'Y' ? true : false;
                            else if(data[i]['confId'] == 'host.query.use') hostQuery = data[i]['val'] == 'Y' ? true : false;
                        }
                    }
                    $('[name=summary]').prop('checked', recvSum);
                    $('[name=keywordHighlight]').prop('checked', keywordHighlight);
                    $('[name=hostQuery]').prop('checked', hostQuery);
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
        }

        function openNologUrlPop(host_path){
            mode = 'insert';
            if(host_path.indexOf('?') > -1) $('#noLogurl').val(host_path.substring(0, host_path.indexOf('?')));
            else $('#noLogurl').val(host_path);
            $("#urlPop").modal('show');
        }

        var downloadBatchExist=true;
        function checkDownloadBatchExist(){

            var grid = getIframeListObj().grid;
            var rows = grid.getSelectedKey('msgid').length;
            var total = getIframeListObj().$('#busiCntArea').find('.tab_selected').find('.busiCnt').text();
            total = total.replace(re,"")
            var header = grid.getHeaderEXCEL();
            var param = JSON.stringify( getIframeListObj().filterValData );
            var dataLength = $('#dataLength_select').selectpicker('val');
            var searchType = $('#searchType').val();
            var exportFileType = $('input:radio[name=exportFileType]:input:checked').val();

            ui.get({
                url : 'checkDownloadBatchExist.xcn',
                searchCondition : param,
                searchTotal : $('#searchTotal').val(),
                searchType : searchType,
                exportFileExt : exportFileType,
                success : function(data, total) {
                    if(data > 0) {
                        downloadBatchExist = true;
                    } else {
                        downloadBatchExist = false;
                    }
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
        }


        function getRelationKeywordList(){
            ui.get({
                url: 'getRelationKeywordList.xcn',
                searchKeyword:  $('#searchStrInput').val(),
                success: function (data, total) {
                    relationKeywordGrid.setData(data);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                }
            });
        }


        function getRegexList(){
            var searchKeyword = $('#regexSearchStr').val();
            ui.get({
                url : 'getRegexPattern.xcn',
                searchStr : searchKeyword,
                success : function(data, total) {
                    regexSearchGrid.setData(data);
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                }
            });
        }



    </script>
</head>
<body> <!--class="mini-navbar msgBody" style="overflow: auto;"-->
<div id="wrap" >
    <tiles:insertAttribute name="top" ignore="true"/>
    <div id="container">
        <tiles:insertAttribute name="lnb" ignore="true"/>
        <div id="contentArea">
            <%-- header --%>
            <tiles:insertAttribute name="header" ignore="true"/>
            <%-- content --%>
            <div class="msg_container">
                <tiles:insertAttribute name="left" ignore="true"/>

                <%-- 검색어 관리 --%>
                <div id="searchKeywordDiv" class="searchKeywordDiv">
                    <div class="searchKeywordTab"><s:message code="searchKeyword.management"/>
                        <div class="searchKeywordCloseBtn" style="position:absolute;top:12px; right:8px;">
                            <span class="glyphicon glyphicon-remove" style="cursor:pointer;font-size:13px;" aria-hidden="true"></span>
                        </div>
                    </div>
                    <div class="searchKeywordSearch" style="padding: 5px 5px 5px 10px; margin-bottom:8px;">
                        <input class="condition_input_text" type="text" name="serch" placeholder="<s:message code="searchKeyword.search"/>" id="searchKeywordSearchStr" style="width:calc(90% - 150px);">
                        <button class="form_btn01" id="searchKeywordSearchBtn"><span><s:message code="common.search"/></span></button>
                        <button class="btn01" id="addSearchKeywordBtn"><img src="<c:url value="/img/subBtn_plus.png"/>" alt="<s:message code="common.msg.add"/>"><span><s:message code="common.msg.add"/></span></button>
                        <button class="btn02"  id="delSearchKeywordBtn"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="<s:message code="common.msg.delete"/>"><span><s:message code="common.msg.delete"/></span></button>
                    </div>
                    <div style="padding-left: 10px;padding-bottom: 10px;">
                        <span style="font-weight: bold; display: inline-block; margin-right: 10px;"><i class="fa fa-caret-right"></i> <s:message code="searchKeyword.inputMode"/></span>
                        <label class="searchKeywordInputType"><input type="radio" name="searchKeywordInputType" value="S" checked="checked"> <span><s:message code="searchKeyword.single"/></span></label>
                        <label class="searchKeywordInputType"><input type="radio" name="searchKeywordInputType" value="A"> <span>AND</span></label>
                        <label class="searchKeywordInputType"><input type="radio" name="searchKeywordInputType" value="O"> <span>OR</span></label>
                    </div>
                    <div id="searchKeywordGrid" class="slickGrid gridArea p12" style="position: relative; top: 0px; left: 0px;min-height:200px;height:calc(100% - 130px);"></div>
                </div>

                <%-- 연관 검색어 리스트 --%>
                <div id="relationKeywordDiv" class="relationKeywordDiv">
                    <div class="searchKeywordTab"><s:message code="condition.relationKeyword"/>
                        <div class="relationKeywordCloseBtn" style="position:absolute;top:12px; right:8px;">
                            <span class="glyphicon glyphicon-remove" style="cursor:pointer;font-size:13px;" aria-hidden="true"></span>
                        </div>

                    </div>
                    <div style="padding-left: 10px; padding-top:10px;padding-bottom: 10px;">
                        <span style="font-weight: bold; display: inline-block; margin-right: 10px;"><i class="fa fa-caret-right"></i> <s:message code="searchKeyword.inputMode"/></span>
                        <label class="relationKeywordInputType"><input type="radio" name="relationKeywordInputType" value="S" checked="checked"> <span><s:message code="searchKeyword.single"/></span></label>
                        <label class="relationKeywordInputType"><input type="radio" name="relationKeywordInputType" value="A"> <span>AND</span></label>
                        <label class="relationKeywordInputType"><input type="radio" name="relationKeywordInputType" value="O"> <span>OR</span></label>
                    </div>
                    <div id="relationKeywordGrid" class="slickGrid gridArea"></div>
                </div>


                <%-- 정규 표현식 모달 --%>
                <div id="regexSearchDiv" class="regexSearchDiv">
                    <div class="searchKeywordTab"><s:message code="condition.regex.appo"/>
                        <div class="regexSearchCloseBtn" style="position:absolute;top:12px; right:8px;">
                            <span class="glyphicon glyphicon-remove" style="cursor:pointer;font-size:13px;" aria-hidden="true"></span>
                        </div>
                    </div>
                    <div style="padding: 5px 5px 5px 10px;">
                        <input  type="text" placeholder="<s:message code="searchKeyword.search"/>" id="regexSearchStr" style="width:calc(100% - 150px);"/>
                        <button class="form_btn01" id="regexSearchStrBtn"><span><s:message code="common.search"/></span></button>
                    </div>
                    <div id="regexSearchGrid" class="slickGrid gridArea"></div>
                </div>


                <%-- 조건 보관함 --%>
                <div id="filterHeaderDiv" class="filterHeaderDiv">
                    <div class="filterHeaderTab"><s:message code="common.msg.conditionBox"/>
                        <div class="filterDateCloseBtn" style="position:absolute;top:12px; right:16px;">
                            <span class="glyphicon glyphicon-remove" style="cursor:pointer;" aria-hidden="true"></span>
                        </div>
                    </div>
                    <div class="rightGroup" style="margin-right:14px; margin-top:4px;">
                        <span class="searchBoxSpan"><label><input type="checkbox" id="searchBox"/><span> <s:message code="common.msg.searchNow"/></span></label></span>
                    </div>
                    <div class="filterSearch" style="padding: 5px 5px 5px 10px;">
                        <input class="condition_input_text" type="text" name="serch" placeholder="<s:message code="filterInfo.search.filter"/>" id="filterSearchStr" style="width:calc(100% - 60px);">
                        <button class="search_btn" id="filterSearchBtn"><span><s:message code="common.search"/></span></button>
                    </div>
                    <div class="scrollbar-inner saveFilterTab_tree">
                        <ul id="filterTree" class="ztree scrollbar"></ul>
                    </div>
                </div>
                <tiles:insertAttribute name="filterNew" ignore="true"/>
                <div class="content mainBodyArea" id="mainBodyArea" style="height:100%; ">
                    <div id="content_left" class="ui-layout-west" style="overflow-y:hidden; z-index:9999; margin-left: 6px;">
                        <div class="section_menu p12">
                            <div style=" display:flex;">
                                <div id="msg_condition_menu" class="filter_menu" style="width: 33.3%;"><div class="filter_icon"><span class="filter_icon_text"><s:message code="condition.select.search1"/></span></div></div>
                                <div id="msg_condition_saver" class="filter_menu condition_menu_unselected" style="width: 33.3%;"><div class="filter_folder_icon"><span class="filter_icon_text"><s:message code="condition.advance_search1"/></span></div></div>
                                <div id="msg_folder" class="filter_menu condition_menu_unselected" style="width: 33.3%;"><div class="msg_folder_icon"><span class="filter_icon_text"><s:message code="filterInfo.messageFolder1"/></span></div></div>
                            </div>
                        </div>
                        <div id="search_top_area" style="height: calc(100% - 100px);min-width:299px; margin-top:-10px;">

                            <div class="condition_save">
                                <a href="javascript:;" class="resetCondition" style="float:left;padding-left:15px;"><i class="fa fa-refresh"></i> <s:message code="condition.reset1"/></a>
                                <a href="javascript:;" class="showFilterBtn"><i class="fa fa-folder-open-o"></i> <s:message code="filterInfo.box"/></a>
                                <span class="filterIcon hide" data-id="" ><i class="fa fa-filter" aria-hidden="true"></i></span>
                                <a href="javascript:;" class="saveCondition" style="padding-right:15px;"><i class="fa fa-floppy-o" aria-hidden="true"></i> <s:message code="condition.save"/></a>
                            </div>
                            <div id="condition_detail" class="section_condition scrollbar-inner" style="margin-top:-10px;">

                                <%-- 연관 검색어 표기--%>
                                <div class="condition_opt" style="margin-top:10px;widht:100%;height:8px;">
                                    <label style="float: left; padding-left: 14px; cursor: pointer">
                                        <input class="relationKeywordBtn" type="checkbox"/>
                                        <span><s:message code="condition.relationKeyword.view"/></span>
                                    </label>
                                    <div  style="float: right;padding-right: 4px;margin-top:4px; margin-bottom: 4px;">
                                        <a href="javascript:;" class="showSearchKeywordBtn" style="color:#111;"><i class="fa fa-cog"></i> <s:message code="searchKeyword.management"/></a>
                                    </div>
                                </div>

                                <div class="condition_option" style="padding-top:15px;">
                                    <div class="condition_item">
                                        <div class="condition_title" style="float: left;"><i class="fa fa-caret-right"></i> <s:message code="condition.search_str"/>
                                            <img style="width: 16px;margin-bottom: 3px;" src="<c:url value="/img/icon/question.png"/>" class="areaBtn" id="searchHelpBtn">
                                        </div>

                                        <div style="margin-top: 5px;">
                                            <input class="condition_input_text" type="text" id="searchStrInput" name="serch" placeholder="<s:message code="common.msg.searchMsg"/>" style="width: 260px;height: 35px;border: 2px solid #1C64D3;padding-left: 5px;">
                                        </div>
                                        <div style="margin-top: 15px;"></div>
                                        <%-- <div style="display: inline;">
                                            <select name="searchArea" class="condition_select" style="margin-top: 5px;" id="searchField">
                                                <option value=""><s:message code="condition.field.search.all"/></option>
                                                <option value="subject"><s:message code="condition.subject"/></option>
                                                <option value="body"><s:message code="condition.body"/></option>
                                                <option value="attachname attachname_str"><s:message code="condition.attach_name"/></option>
                                                <%if(!isOCR){ %>
                                                <option value="attach"><s:message code="condition.attach"/></option>
                                                <%}else{ %>
                                                <option value="attach ocr_attach"><s:message code="condition.attach"/></option>
                                                <option value="ocr_attach">OCR</option>
                                                <%} %>
                                                <option value="host host_str">Host</option>
                                                <option value="path query">Path</option>
                                                <option value="srcip"><s:message code="condition.source"/> IP</option>
                                                <option value="dstip"><s:message code="condition.destination"/> IP</option>
                                                <option value="sender_str"><s:message code="condition.sender"/></option>
                                                <option value="sname"><s:message code="condition.sender_name"/></option>
                                                <option value="recvs"><s:message code="condition.recv"/></option>
                                                <option value="recvs_name"><s:message code="condition.recv_name"/></option>
                                                <option value="to tname"><s:message code="condition.recv"/>(<s:message code="condition.to"/>)</option>
                                                <option value="cc cname"><s:message code="condition.recv"/>(<s:message code="condition.cc"/>)</option>
                                                <option value="bcc bname"><s:message code="condition.recv"/>(<s:message code="condition.bcc"/>)</option>
                                                <option value="user user_str userid name"><s:message code="common.org.user"/></option>
                                                <option value="usr_id"><s:message code="common.msg.account"/></option>
                                            </select>
                                        </div> --%>
                                        <div class="condition_item">
                                            <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.field.search"/></div>
                                            <select id="searchField" title="<s:message code="condition.field.search.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                                                <option value="subject"><s:message code="condition.subject"/></option>
                                                <option value="body"><s:message code="condition.body"/></option>
                                                <option value="attachname attachname_str"><s:message code="condition.attach_name"/></option>
                                                <% if(!isOCR){ %>
                                                <option value="attach"><s:message code="condition.attach"/></option>
                                                <%}else{ %>
                                                <option value="attach ocr_attach"><s:message code="condition.attach"/></option>
                                                <option value="ocr_attach">OCR</option>
                                                <%} %>
                                                <option value="host">Host</option>
                                                <option value="path">Path</option>
                                                <option value="srcip"><s:message code="condition.source"/> IP</option>
                                                <option value="dstip"><s:message code="condition.destination"/> IP</option>
                                                <option value="sender_str org_sender_str"><s:message code="condition.sender"/></option>
                                                <option value="sname org_sname"><s:message code="condition.sender_name"/></option>
                                                <option value="recvs"><s:message code="condition.recv"/></option>
                                                <option value="recvs_name"><s:message code="condition.recv_name"/></option>
                                                <option value="to tname"><s:message code="condition.recv"/>(<s:message code="condition.to"/>)</option>
                                                <option value="cc cname"><s:message code="condition.recv"/>(<s:message code="condition.cc"/>)</option>
                                                <option value="bcc bname"><s:message code="condition.recv"/>(<s:message code="condition.bcc"/>)</option>
                                                <option value="user user_str userid name sabun"><s:message code="common.org.user"/></option>
                                                <option value="usrId"><s:message code="common.msg.account"/></option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.service"/></div>
                                        <select id="serviceType" title="<s:message code="condition.service.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true"></select>
                                    </div>
                                    <!--  대외비 목록 -->
<%--                                    <div class="condition_item" id="epmsgList">--%>
<%--                                        <div class="condition_divider"></div>--%>
<%--                                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.epmsgType.list"/></div>--%>
<%--                                        <select id="initEpmsg" title="<s:message code="condition.epmsgType.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true"data-live-search="true"></select>--%>
<%--                                        <input type="hidden" id="initEpmsgName" />--%>
<%--                                    </div>--%>
                                    <!-- Knox 첨부 여부  -->
                                    <div class="condition_item" id ="KnoxAttachYN">
                                        <div class="condition_divider"></div>
                                        <div class="condition_title"><i class="fa fa-caret-right"></i>  <s:message code="condition.epmsgType.bodyImg"/></div>
                                        <div class="condition_sub_title">
                                            <label class="condition_label"><input type="radio" name="bodyImg" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                                            <label class="condition_label"><input type="radio" name="bodyImg" value="Y"> <span><s:message code="condition.exist"/></span></label>
                                            <label class="condition_label"><input type="radio" name="bodyImg" value="N"> <span><s:message code="condition.none"/></span></label>
                                        </div>
                                    </div>

                                </div>
                                <div class="condition_group display_none">
                                    <s:message code="common.msg.time"/><i class="fa fa-minus-square"></i>
                                </div>
                                <div class="condition_option">
                                    <div class="condition_item">
                                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.period"/></div>
                                        <select name="searchArea" class="condition_select" id="easyDate">
                                            <option value="" selected="selected"><s:message code="condition.select.period"/></option>
                                            <option value="1"><s:message code="condition.today"/></option>
                                            <option value="2"><s:message code="condition.yesterday"/></option>
                                            <option value="3"><s:message code="condition.week" arguments="1"/></option>
                                            <option value="6"><s:message code="condition.month" arguments="1"/></option>
                                            <option value="7"><s:message code="condition.month" arguments="2"/></option>
                                            <option value="8"><s:message code="condition.month" arguments="3"/></option>
                                        </select>
                                        <div style="display: flex; width: 260px; padding-top: 4px;">
                                            <input type="text" id="startdatepicker" class="input-xs form-control border-radius-none" style="padding: 1px 0px 0px 3px;border-radius: 0;font-size: 12px; width: 125px;"/>
                                            <span style="padding:0 2px; padding-top: 4px;">-</span>
                                            <input type="text" id="enddatepicker" class="input-xs form-control border-radius-none"  style="padding: 1px 0px 0px 3px;border-radius: 0;font-size: 12px; width: 125px;"/>
                                        </div>
                                    </div>
                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.work"/></div>
                                        <div class="condition_sub_title">
                                            <label class="condition_label"><input type="radio" name="ctimeWork" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                                            <label class="condition_label"><input type="radio" name="ctimeWork" value="W"> <span><s:message code="condition.work"/></span></label>
                                            <label class="condition_label"><input type="radio" name="ctimeWork" value="R"> <span><s:message code="condition.notwork"/></span></label>
                                        </div>
                                    </div>
                                </div>
                                <!-- SK 하이닉스 비밀문서 관련 검색기능 -->
                                <div id="secretDocuDiv" style="display: none;">
                                    <div class="condition_group display_none">
                                        <s:message code="common.msg.secretInformation"/><i class="fa fa-minus-square"></i>
                                    </div>
                                    <div class="condition_option">
                                        <div class="condition_item">
                                            <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.itype"/></div>
                                            <select id="skInfoType" title="<s:message code="condition.docu.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                                                <option value="1"><s:message code="condition.info.Y"/></option>
                                                <option value="0"><s:message code="condition.info.N"/></option>
                                            </select>
                                        </div>
                                        <div class="condition_divider"></div>
                                        <div class="condition_item">
                                            <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.feedback"/></div>
                                            <select id="skFeedbackType" title="<s:message code="condition.feedback.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                                                <option value="1"><s:message code="condition.info.secretFeedbackY"/></option>
                                                <option value="9"><s:message code="condition.info.feedback9"/></option>
                                                <option value="0"><s:message code="condition.info.secretFeedbackN"/></option>
                                            </select>
                                        </div>
                                        <div class="condition_divider"></div>
                                        <div class="condition_item">
                                            <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.sprob"/>(%)</div>
                                            <select id="skProbType" title="<s:message code="condition.sprob.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                                                <option value="0.5|1.1">50 ~ 100</option>
                                                <option value="0.1|0.5">10 ~ 49</option>
                                                <option value="0|0.1">0 ~ 9</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div id="infoFeedbackDiv" style="display: none;">
                                    <div class="condition_group display_none">
                                        <s:message code="common.msg.information"/><i class="fa fa-minus-square"></i>
                                    </div>
                                    <div class="condition_option">
                                        <div class="condition_item">
                                            <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.infotype"/></div>
                                            <select id="infoType" title="<s:message code="condition.infotype.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                                                  <option value="4"><s:message code="condition.info.class4"/></option>
                                                <%if(Common.isEquals(infoFeedbackMode, "E")){%>
                                                <option value="3"><s:message code="condition.info.class3"/></option>
                                                <%}%>
                                                <option value="2"><s:message code="condition.info.class2"/></option>
                                                <option value="1"><s:message code="condition.info.class1"/></option>
                                            </select>
                                        </div>
                                         <div id="feedbackTypeDiv">
                                        <div class="condition_divider"></div>
                                        <div class="condition_item">
                                            <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.feedback"/></div>
                                            <select id="feedbackType" title="<s:message code="condition.feedback.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                                                <option value="0"><s:message code="condition.info.feedback0"/></option>
                                                <option value="1"><s:message code="condition.info.feedback1"/></option>
                                                <option value="2"><s:message code="condition.info.feedback2"/></option>
                                                <option value="3"><s:message code="condition.info.feedback3"/></option>
                                                <option value="4"><s:message code="condition.info.feedback4"/></option>
                                                <option value="9"><s:message code="condition.info.feedback9"/></option>
                                                <option value="-1"><s:message code="condition.info.feedback-1"/></option>
                                            </select>
                                        </div>
                                        <div class="condition_divider"></div>
                                        <div class="condition_item">
                                            <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.prob"/>(%)</div>
                                            <select id="probType" title="<s:message code="condition.prob.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true" data-live-search="true">
                                                <option value="0.5|1.1">50 ~ 100</option>
                                                <option value="0.1|0.5">10 ~ 49</option>
                                                <option value="0|0.1">0 ~ 9</option>
                                            </select>
                                        </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="condition_group display_none">
                                    <s:message code="condition.user"/><i class="fa fa-minus-square"></i>
                                </div>
                                <div class="condition_option">
                                    <div class="condition_item">
                                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.receive_send"/></div>
                                        <div class="condition_sub_title">
                                            <label class="condition_label"><input type="radio" name="receiveSend" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                                            <label class="condition_label"><input type="radio" name="receiveSend" value="I"> <span><s:message code="condition.receive"/></span></label>
                                            <label class="condition_label"><input type="radio" name="receiveSend" value="O"> <span><s:message code="condition.send"/></span></label>
                                        </div>
                                    </div>
                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                       <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.sender"/> <img style="cursor:help; width: 12px; margin-left: 3px; margin-bottom: 2px;" src="<c:url value="/img/icon/icon_help.png"/>" class="areaBtn" title="<s:message code="condition.partial.match.help"/>"></div>
                                        <%if(Common.isEquals(rsUppercase, "Y")) {%>
                                        <div class="condition_left">&nbsp;<label style="font-weight: normal;"><input type="checkbox" id="senders_upperCase" disabled/><span style="position: relative;top: -2px;font-weight: normal;"> <s:message code="condition.uppercase"/></span></label></div>
                                        <%} %>
                                       <br>
                                        <div class="condition_not" style="font-size: 12px"><label><input type="checkbox" id="senders_not" name="senders_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                                        <div class="condition_not" style="font-size: 12px"><label><input type="checkbox" id="senders_findByKeyword" name="senders_findByKeyword" disabled/><span><s:message code="condition.partial.match"/></span></label></div>
                                        <div class="condition_not" style="font-size: 12px"><label><input type="checkbox" id="senders_findByParam" name="senders_findByParam" disabled/><span><s:message code="condition.exact.match"/></span></label></div>

                                        <input class="condition_input_text" type="text" id="senders" name="serch" placeholder="<s:message code="condition.message.sender"/>">
                                    </div>
                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.detail.recvs"/></div>
                                        <div class="condition_sub_title">
                                            <label class="condition_label"><input type="radio" name="receive_option" id="receive_option_all" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                                            <label class="condition_label"><input type="radio" name="receive_option" id="receive_option_more" value="detail"> <span><s:message code="condition.info.detail"/></span></label>
                                        </div>
                                    </div>
                                     <div class="condition_divider"></div>
                                    <div class="condition_item">
                                         <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.recv"/> <img style="cursor:help; width: 12px; margin-left: 3px; margin-bottom: 2px;" src="<c:url value="/img/icon/icon_help.png"/>" class="areaBtn" title="<s:message code="condition.partial.match.help"/>"></div>
                                        <%if(Common.isEquals(rsUppercase, "Y")) {%>
                                        <div class="condition_left">&nbsp;<label style="font-weight: normal;"><input type="checkbox" id="receivers_upperCase" disabled/><span style="position: relative;top: -2px;font-weight: normal;"> <s:message code="condition.uppercase"/></span></label></div>
                                        <%} %>
                                        <br>
                                        <div class="condition_not" style="font-size: 12px"><label><input type="checkbox" id="receivers_not" name="receivers_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                                        <div class="condition_not" style="font-size: 12px"><label><input type="checkbox" id="receivers_findByKeyword" name="receivers_findByKeyword" disabled/><span><s:message code="condition.partial.match"/></span></label></div>
                                        <div class="condition_not" style="font-size: 12px"><label><input type="checkbox" id="receivers_findByParam" name="receivers_findByParam" disabled/><span><s:message code="condition.exact.match"/></span></label></div>
                                        <input class="condition_input_text" type="text" id="receivers" name="serch" placeholder="<s:message code="condition.message.receiver"/>">
                                    </div>
                                    <div class="receivers_detail" style="display: none;">
                                        <div class="condition_item">
                                            <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.recv"/> (<s:message code="condition.to"/>) <img style="cursor:help; width: 12px; margin-left: 3px; margin-bottom: 2px;" src="<c:url value="/img/icon/icon_help.png"/>" class="areaBtn" title="<s:message code="condition.partial.match.help"/>"></div>
                                            <br>
                                            <div class="condition_not" style="font-size: 12px"><label><input type="checkbox" id="m_to_not" name="m_to_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                                            <div class="condition_not" style="font-size: 12px"><label><input type="checkbox" id="m_to_findByKeyword" name="m_to_findByKeyword" disabled/><span><s:message code="condition.partial.match"/></span></label></div>
                                            <div class="condition_not" style="font-size: 12px"><label><input type="checkbox" id="m_to_findByParam" name="m_to_findByParam" disabled/><span><s:message code="condition.exact.match"/></span></label></div>
                                            <input class="condition_input_text" type="text" id="m_to" name="serch" placeholder="<s:message code="condition.input.to"/>">
                                        </div>
                                        <div class="condition_divider"></div>
                                        <div class="condition_item">
                                            <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.recv"/> (<s:message code="condition.cc"/>) <img style="cursor:help; width: 12px; margin-left: 3px; margin-bottom: 2px;" src="<c:url value="/img/icon/icon_help.png"/>" class="areaBtn" title="<s:message code="condition.partial.match.help"/>"></div>
                                            <br>
                                            <div class="condition_not"  style="font-size: 12px"><label><input type="checkbox" id="m_cc_not" name="m_cc_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                                            <div class="condition_not"  style="font-size: 12px"><label><input type="checkbox" id="m_cc_findByKeyword" name="m_cc_findByKeyword" disabled/><span><s:message code="condition.partial.match"/></span></label></div>
                                            <div class="condition_not"  style="font-size: 12px"><label><input type="checkbox" id="m_cc_findByParam" name="m_cc_findByParam" disabled/><span><s:message code="condition.exact.match"/></span></label></div>
                                            <input class="condition_input_text" type="text" id="m_cc" name="serch" placeholder="<s:message code="condition.input.cc"/>">
                                        </div>
                                        <div class="condition_divider"></div>
                                        <div class="condition_item">
                                            <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.recv"/> (<s:message code="condition.bcc"/>) <img style="cursor:help; width: 12px; margin-left: 3px; margin-bottom: 2px;" src="<c:url value="/img/icon/icon_help.png"/>" class="areaBtn" title="<s:message code="condition.partial.match.help"/>"></div>
                                            <br>
                                            <div class="condition_not"  style="font-size: 12px"><label><input type="checkbox" id="m_bcc_not" name="m_bcc_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                                            <div class="condition_not"  style="font-size: 12px"><label><input type="checkbox" id="m_bcc_findByKeyword" name="m_bcc_findByKeyword" disabled/><span><s:message code="condition.partial.match"/></span></label></div>
                                            <div class="condition_not"  style="font-size: 12px"><label><input type="checkbox" id="m_bcc_findByParam" name="m_bcc_findByParam" disabled/><span><s:message code="condition.exact.match"/></span></label></div>
                                            <input class="condition_input_text" type="text" id="m_bcc" name="serch" placeholder="<s:message code="condition.input.bcc"/>">
                                        </div>
                                    </div>
                                    <div class="condition_divider recvs_jikgub"></div>
                                    <div class="condition_item recvs_jikgub">
                                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.recv_jikgub"/></div>
                                        <div class="condition_not"><label><input type="checkbox" id="recv_jikgub_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                                        <select id="rcvJikgub" title="<s:message code="condition.recv_jikgub.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true"data-live-search="true"></select>
                                    </div>
                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.allofus"/></div>
                                        <select name="searchArea" class="condition_select" id="allOfus">
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
                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.userGroup"/></div>
                                        <div class="condition_not"><label><input type="checkbox" id="userGroupSeq_not" disabled /><span> <s:message code="query.make.except"/></span></label></div>
                                        <select name="searchArea" class="condition_select" id="userGroupSeq"></select>
                                        <input type="hidden" id="userGroupName" />
                                    </div>
                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.interestGroup"/></div>
                                        <div class="condition_not"><label><input type="checkbox" id="interGroup_not" disabled /><span> <s:message code="query.make.except"/></span></label></div>
                                        <select name="searchArea" class="condition_select" id="interGroup"></select>
                                        <input type="hidden" id="interGroupName" />
                                    </div>
                                </div>

                                <div class="condition_group display_none">
                                    <s:message code="condition.organization"/><i class="fa fa-minus-square"></i>
                                </div>
                                <div class="condition_option">
                                    <div class="condition_item">
                                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="common.org.busi"/></div>
                                        <div class="condition_not"><label><input type="checkbox" id="busi_not" disabled /><span> <s:message code="query.make.except"/></span></label></div>
                                        <select id="busi" title="<s:message code="common.org.busi.all"/>" class="selectpicker" data-style="btn-default" multiple data-show-subtext="true" data-actions-box="true"data-live-search="true"></select>
                                        <input type="hidden" id="busiStr" />
                                    </div>
                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                        <span class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="common.org.dept"/></span>
                                        <div class="condition_not"><label><input type="checkbox" id="dept_not" disabled /><span> <s:message code="query.make.except"/></span></label></div>
                                        <div class="condition_sub_title">
                                            <span class="condition_title" style="width: 65px;display: inline-block;"><s:message code="common.org.choose.dept"/></span>
                                            <span class="condition_sub_title">
										<button style="width:61px;position: relative;" id="deptBtn" class="button_style filterAddBtn" title="<s:message code="common.msg.select"/>">
									    		<span class=""></span><s:message code="common.msg.select"/>
											<span id="deptSelectedArea" class="codeSelectedBtn" style="display:none;">
												<span class="btn" title="">0</span>
											</span>
										</button>
									</span>
                                        </div>
                                        <input type="hidden" id="deptVal" />
                                        <input type="hidden" id="deptStr" />
                                    </div>
                                </div>

                                <div class="condition_group display_none">
                                    <s:message code="condition.etc"/><i class="fa fa-minus-square"></i>
                                </div>
                                <div class="condition_option">
                                    <div class="condition_item">
                                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> URL
                                            <img style="cursor:help; width: 16px;margin-bottom: 3px;" src="<c:url value="/img/icon/icon_help.png"/>" class="areaBtn" title="http:// <s:message code="query.make.except"/>">
                                        </div>
                                        <div class="condition_not"><label><input type="checkbox" id="url_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                                        <textarea id=url class="condition_input_text" style="resize: none"></textarea>
                                    </div>
                                    <div class="condition_divider"></div>

                                    <%-- 정규 표현식 검색 --%>
<%--                                    <div class="condition_opt"  style="margin-top:12px;margin-bottom:6px;widht:100%;height:8px;">--%>
<%--                                        <div  style="float: right;padding-right: 4px;margin-top:6px;">--%>
<%--                                            <a href="javascript:;" class="regexSearchBtn"  style="color:#111;"><i class="fa fa-cog"></i> <s:message code="condition.regex.appo"/></a>--%>
<%--                                        </div>--%>
<%--                                    </div>--%>
<%--                                    <div class="condition_item">--%>
<%--                                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.regex.search"/>--%>
<%--                                        </div>--%>
<%--                                        <textarea id=regexPattern class="condition_input_text" style="resize: none"></textarea>--%>
<%--                                    </div>--%>




                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.isread"/></div>
                                        <%if(Common.isEquals(firstAdminYn, "Y")) {%>
                                        <div class="condition_left">&nbsp;<label style="font-weight: normal;"><input type="checkbox" id="adminAllRead"/><span style="position: relative;top: -2px;font-weight: normal;"> <s:message code="common.all.admin"/></span></label></div>
                                        <%} %>
                                        <div class="condition_sub_title">
                                            <label class="condition_label"><input type="radio" name="readYn" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                                            <label class="condition_label"><input type="radio" name="readYn" value="Y"> <span><s:message code="condition.read"/></span></label>
                                            <label class="condition_label"><input type="radio" name="readYn" value="N"> <span><s:message code="condition.unread"/></span></label>
                                        </div>
                                    </div>
                                    <div class="condition_divider"></div>
                                    <div class="condition_item" id="attached_in">
                                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.isattached"/></div>
                                        <div class="condition_sub_title">
                                            <label class="condition_label"><input type="radio" name="attachYn" value="" checked="checked"> <span>All</span></label>
                                            <label class="condition_label"><input type="radio" name="attachYn" value="Y"> <span><s:message code="condition.exist"/></span></label>
                                            <label class="condition_label"><input type="radio" name="attachYn" value="N"> <span><s:message code="condition.none"/></span></label>
                                        </div>
                                        <input type="hidden" id="attachVal" />
                                        <input type="hidden" id="attachStr" />
                                        <div class="condition_sub_title" style="padding-left: 10px;float:left;padding-bottom:5px;">
                                            <span class="condition_title" style="width: 65px;display: inline-block;"><s:message code="condition.select"/></span>
                                            <span class="condition_sub_title">
										<button style="width:61px;position: relative;" id="attachBtn" class="button_style filterAddBtn" title="<s:message code="condition.select"/>">
											<span class=""></span><s:message code="condition.select"/>
											<span id="attachSelectedArea" class="codeSelectedBtn" style="display:none;">
												<span class="btn" title="">0</span>
											</span>
										</button>
									</span>
                                        </div>
                                        <div class="condition_not"><label><input type="checkbox" id="attachYn_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                                        <div class="condition_sub_title" style="padding-left: 10px;">
                                            <span class="condition_title" style="width: 65px;display: inline-block;"> <s:message code="condition.actual.attachment"/></span>
                                            <span class="condition_sub_title">
										<label class="condition_label" style="margin-right: 5px;"><input type="radio" name="realAttYn" value="" checked="checked" disabled="disabled"> <span><s:message code="common.msg.all"/></span></label>
										<label class="condition_label" style="margin-right: 5px;"><input type="radio" name="realAttYn" value="Y" disabled="disabled"> <span><s:message code="condition.onemore"/></span></label>
										<label class="condition_label" style="margin-right: 5px;"><input type="radio" name="realAttYn" value="N" disabled="disabled"> <span><s:message code="condition.none"/></span></label>
									</span>
                                        </div>
                                        <div class="condition_sub_title" style="padding-left: 10px;">
                                            <span class="condition_title" style="width: 65px;display: inline-block;"> DRM</span>
                                            <span class="condition_sub_title">
										<label class="condition_label" style="margin-right: 5px;"><input type="radio" name="drmYn" value="" checked="checked" disabled="disabled"> <span><s:message code="common.msg.all"/></span></label>
										<label class="condition_label" style="margin-right: 5px;"><input type="radio" name="drmYn" value="Y" disabled="disabled"> <span><s:message code="condition.exist"/></span></label>
										<label class="condition_label" style="margin-right: 5px;"><input type="radio" name="drmYn" value="N" disabled="disabled"> <span><s:message code="condition.none"/></span></label>
									</span>
                                        </div>
                                    </div>
                                    <!-- OCR 첨부 여부  -->
                                    <div class="condition_divider"></div>
                                    <div class="condition_item" id ="ocrAttachYn">
                                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.ocr.attach"/></div>
                                        <div class="condition_sub_title">
                                            <label class="condition_label"><input type="radio" name="OCRYn" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                                            <label class="condition_label"><input type="radio" name="OCRYn" value="Y"> <span><s:message code="condition.exist"/></span></label>
                                            <label class="condition_label"><input type="radio" name="OCRYn" value="N"> <span><s:message code="condition.none"/></span></label>
                                        </div>
                                    </div>

                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                        <div class="condition_title condition_left"><i class="fa fa-caret-right"></i> <s:message code="condition.keyword"/></div>
                                        <div class="condition_not"><label><input type="checkbox" id="keywordYn_not" disabled/><span> <s:message code="query.make.except"/></span></label></div>
                                        <div class="condition_sub_title">
                                            <label class="condition_label"><input type="radio" name="keywordYn" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                                            <label class="condition_label"><input type="radio" name="keywordYn" value="Y"> <span><s:message code="condition.exist"/></span></label>
                                            <label class="condition_label"><input type="radio" name="keywordYn" value="N"> <span><s:message code="condition.none"/></span></label>
                                        </div>
                                        <div class="condition_sub_title">
                                            <span class="condition_title" style="width: 65px;display: inline-block;"><s:message code="condition.select"/></span>
                                            <span class="condition_sub_title">
										<button style="width:61px;position: relative;" id="keywordBtn" class="button_style filterAddBtn" title="<s:message code="condition.select"/>">
											<span class=""></span><s:message code="condition.select"/>
											<span id="keywordSelectedArea" class="codeSelectedBtn" style="display:none;">
												<span class="btn" title="">0</span>
											</span>
										</button>
									</span>
                                        </div>
                                        <input type="hidden" id="keywordVal" />
                                        <input type="hidden" id="keywordStr" />
                                    </div>
                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.regexp"/></div>
                                        <div class="condition_sub_title">
                                            <label class="condition_label"><input type="radio" name="regexpYn" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                                            <label class="condition_label"><input type="radio" name="regexpYn" value="Y"> <span><s:message code="condition.exist"/></span></label>
                                            <label class="condition_label"><input type="radio" name="regexpYn" value="N"> <span><s:message code="condition.none"/></span></label>
                                        </div>
                                        <div class="condition_sub_title">
                                            <span class="condition_title" style="width: 65px;display: inline-block;"><s:message code="condition.select"/></span>
                                            <span class="condition_sub_title">
										<button style="width:61px;position: relative;" id="regexpBtn" class="button_style filterAddBtn" title="<s:message code="condition.select"/>">
											<span class=""></span><s:message code="condition.select"/>
											<span id="regexpSelectedArea" class="codeSelectedBtn" style="display:none;">
												<span class="btn" title="">0</span>
											</span>
										</button>
									</span>
                                        </div>
                                        <input type="hidden" id="regexpVal" />
                                        <input type="hidden" id="regexpStr" />
                                    </div>
                                    <div id="sctDiv" style="display: none;">
                                        <div class="condition_divider"></div>
                                        <div class="condition_item">
                                            <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.sct"/></div>
                                            <div class="condition_sub_title">
                                                <label class="condition_label"><input type="radio" name="sctYn" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                                                <label class="condition_label"><input type="radio" name="sctYn" value="Y"> <span><s:message code="condition.exist"/></span></label>
                                                <label class="condition_label"><input type="radio" name="sctYn" value="N"> <span><s:message code="condition.none"/></span></label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.size"/>
                                            <img style="cursor:help; width: 16px;margin-bottom: 2px;" src="<c:url value="/img/icon/icon_help.png"/>" class="areaBtn" title="<s:message code="filterInfo.unit"/> : KByte">
                                        </div>
                                        <div class="condition_sub_title">
                                            <label class="condition_label"><input type="radio" name="sizeType" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                                            <label class="condition_label"><input type="radio" name="sizeType" value="B"> <span><s:message code="condition.size.body"/></span></label>
                                            <label class="condition_label"><input type="radio" name="sizeType" value="A"> <span><s:message code="condition.size.attach"/></span></label>
                                            <label class="condition_label"><input type="radio" name="sizeType" value="T"> <span><s:message code="condition.size.attach.total"/></span></label>
                                        </div>
                                        <div style="padding-top: 6px;">
                                            <input type="text" style="width:60px;" id="sizeStartVal">
                                            <select class="searchSelect" name="attach_size" id="sizeOption">
                                                <option value="L"><s:message code="condition.over"/></option>
                                                <option value="S"><s:message code="condition.below"/></option>
                                                <option value="B"><s:message code="condition.range"/></option>
                                            </select>
                                            <input type="text" style="width:60px;" id="sizeEndVal" disabled> (KBytes)
                                        </div>
                                    </div>
                                    <div class="condition_divider"></div>
                                    <div class="condition_item">
                                        <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="condition.reprocess"/></div>
                                        <div class="condition_sub_title">
                                            <label class="condition_label"><input type="radio" name="reprocessYn" value="" checked="checked"> <span><s:message code="common.msg.all"/></span></label>
                                            <label class="condition_label"><input type="radio" name="reprocessYn" value="Y"> <span><s:message code="condition.exist"/></span></label>
                                            <label class="condition_label"><input type="radio" name="reprocessYn" value="N"> <span><s:message code="condition.none"/></span></label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 검색 버튼 고정 -->
                            <div style="border-top:1px solid #ddd; position: relative; background: #fff;">

                                <div class="condition_top_sub"></div>
                                <div class="condition_top" style="margin-left: 1px;">▲</div>

                                <div class="searchButtonArea p12" style="position: relative;">
                                    <div class="condition_item">
                                        <div style="float: right;margin-bottom: 4px;" >
                                            <label>
                                                <input type="checkbox" name="researchCheckbox" id="researchCheckbox" style="margin-right: 2px;" disabled/>
                                                <span><s:message code="condition.research1"/></span>
                                            </label>
                                        </div>
                                    </div>
                                    <button class="fullbtn" id="searchBtn" ><span><s:message code="common.search1"/></span></button>
                                </div>
                            </div>
                            <!-- //검색 버튼 고정 -->
                        </div>
                        <div class="in" id="saveFilterTab" style="width:100%; height:calc(100% - 90px); margin-top: -10px; display: none;">

                            <div class="condition_save">
                                <a href="javascript:;" class="resetCondition" style="float:left;padding-left:15px;"><i class="fa fa-refresh"></i> <s:message code="condition.reset1"/></a>
                                <a href="javascript:;" class="showFilterBtn"><i class="fa fa-folder-open-o"></i> <s:message code="filterInfo.box"/></a>
                                <span class="queryIcon hide" data-id=""><i class="fa fa-filter" aria-hidden="true"></i></span>
                                <a href="javascript:;" class="saveCondition" style="padding-right:15px;"><i class="fa fa-floppy-o"></i> <s:message code="condition.save"/></a>
                            </div>
                            <div id="query_detail" class="section_condition scrollbar-inner">
                                <div class="condition_option" style="padding-top:0;height:500px;">
                                    <div class="condition_title"><i class="fa fa-caret-right"></i> <s:message code="query.make.query"/></div>
                                    <div class="condition_item" style="height:100%;margin-top:5px; padding-bottom: 20px;">
                                        <textarea class="queryTextarea" name="serch" placeholder="<s:message code="query.make.input1"/>" id="solrQueryText"></textarea>
                                        <input type="hidden" id="searchQueryStrInput">
                                    </div>
                                </div>
                                <div class="condition_option">
                                    <div class="condition_item">
                                        <button type="button" class="btn btn-sm btn-primary searchQueryBtn"><span class="glyphicon glyphicon-check"></span>&nbsp; <span><s:message code="query.make.inputer"/></span></button>
                                    </div>
                                </div>
                            </div>
                            <div class="searchButtonArea p12">
                                <button class="fullbtn" id="searchQueryBtn"><span><s:message code="common.search1"/></span></button>
                            </div>
                        </div>
                        <div class="in" id="message_folderTab" style="width:100%; height:calc(100% - 66px); display: none;">
                            <div style="display: flex;padding: 5px 11px 5px 11px;">
                                <input class="condition_input_text" type="text" name="serch" placeholder="<s:message code="filterInfo.folder.search"/>" id="folderSearchStr" style="width: 250px;">
                                <button class="search_btn" id="folderSearchBtn"><span><s:message code="common.search"/></span></button>
                            </div>
                            <div class="scrollbar-inner saveFilterTab_tree">
                                <ul id="folderTree" class="ztree" style="height:100%;width:100%;overflow:auto;"></ul>
                            </div>
                        </div>
                    </div>
                    <div id="section_cen" style=" width:100px; float:right; z-index:999;" class="ui-layout-center">
                        <div class="viewSetup" style="position: absolute;top:7px;right:10px;z-index: 9;">
                            <div style="display: inline-block; padding-left:10px; vertical-align: top;">

                                <%if( consent && Common.isEquals(firstAdminYn, "N") && Common.isNotEquals(adminType, "C")){ %>
                                <div  style="display: inline-block; padding-left:10px;margin-right:10px;  vertical-align: bottom;">
                                    <button class="btn05" style="width:150px;" accesskey="O" id="consentBtn" onclick="searchConsentNo();"><span class="glyphicon glyphicon-tags"></span>&nbsp;<s:message code="consent.select.consent"/></button>
                                    <button class="reset_btn" accesskey="X" id="resetConsentBtn" onclick="resetConsentNo();">X</button>
                                    <input type="text" style="width:120px;height:28px;display:none;" readonly="readonly" id="consentNo">
                                    <input type="hidden" readonly="readonly" id="consentIp">
                                    <input type="hidden" readonly="readonly" id="consentEmail">
                                    <input type="hidden" readonly="readonly" id="consentUserId">
                                    <span id="consentName" style="font-weight: bold;"></span>
                                    <input type="hidden" readonly="readonly" id="consentShortName">
                                </div>
                                <%} %>

                            <div style="position: relative; display: inline-block;">
                                <a href="javascript:;" class="btn05" style="padding-right:10px; color:#383838; cursor: pointer; font-size: 13px;float: right; margin-right:4px;"data-toggle="dropdown" id="exportMsg"><s:message code="common.msg.export"/><span class="caret"></span></a>
                                <ul class="dropdown-menu dropdown-menu-left" role="menu" style="min-width:100px;font-size:13px;	">
                                    <li style="display:none;"><a href="javascript:void(0);" id="body_link_btn" class="body_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-text-o"></span>&nbsp;<s:message code="condition.body"/></a></li>
                                    <li style="display:none;"><a href="javascript:void(0);" id="attach_link_btn" class="attach_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-archive-o"></span>&nbsp;<s:message code="consent.attach"/></a></li>
                                    <li style="display:none;"><a href="javascript:void(0);" id="excel_link_btn" class="excel_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>" option="Y"><span class="fa fa-file-excel-o"></span>&nbsp;<s:message code="selectCodeAll.list"/> (<s:message code="common.msg.excel"/> xlsx)</a></li>
                                    <li style="display:none;"><a href="javascript:void(0);" id="cell_link_btn" class="cell_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>" option="Y"><span class="fa fa-file-excel-o"></span>&nbsp;<s:message code="selectCodeAll.list"/> (<s:message code="common.msg.hancel"/> cell)</a></li>
                                    <li style="display:none;"><a href="javascript:void(0);" id="csv_link_btn" class="csv_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>" option="Y"><span class="fa fa-file-text"></span>&nbsp;<s:message code="selectCodeAll.list"/> (<s:message code="common.msg.text"/> csv)</a></li>
                                    <li style="display:none;"><a href="javascript:void(0);" id="pdf_link_btn" class="pdf_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>" option="Y"><span class="fa fa-file-pdf-o"></span>&nbsp;<s:message code="selectCodeAll.list"/> (PDF)</a></li>
                                    <c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'LS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
                                        <li><a href="javascript:void(0);" class="all_down_link" data-type="L" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-excel-o"></span>&nbsp;<s:message code="selectCodeAll.list"/></a></li>
                                    </c:if>
                                    <c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'BS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
                                        <li><a href="javascript:void(0);" class="all_down_link" data-type="B" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-text-o"></span>&nbsp;<s:message code="condition.body"/></a></li>
                                    </c:if>
                                    <c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'AS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
                                        <li><a href="javascript:void(0);" class="all_down_link" data-type="A" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-archive-o"></span>&nbsp;<s:message code="consent.attach"/></a></li>
                                    </c:if>
                                    <c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'WS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
                                        <li><a href="javascript:void(0);" class="all_down_link" data-type="LB" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-excel-o"></span>&nbsp;<s:message code="selectCodeAll.list"/>+<s:message code="condition.body"/></a></li>
                                    </c:if>
                                    <c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'CS') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
                                        <li><a href="javascript:void(0);" class="all_down_link" data-type="LBA" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="fa fa-file-excel-o"></span>&nbsp;<s:message code="selectCodeAll.list"/>+<s:message code="condition.body"/>+<s:message code="consent.attach"/></a></li>
                                    </c:if>
                                    <c:if test="${fn:indexOf(_USERCREDENTIAL_.menu, 'LP') > -1 || _USERCREDENTIAL_.menu eq 'ALL'}">
                                        <li><a href="javascript:void(0);" class="print_link_new" data-target="tabGrid" rel="<s:message code="DATA_MONITOR.MESSAGE_INFO"/>"><span class="glyphicon glyphicon-print"></span>&nbsp;<s:message code="selectCodeAll.list"/> <s:message code="common.msg.print"/></a></li>
                                    </c:if>
                                    <li class="dropdown-divider"></li>
                                    <li><a href="javascript:void(0);" class="downList" data-target="tabGrid" ><span class="glyphicon glyphicon-th-list"></span>&nbsp;<s:message code="common.msg.download"/> <s:message code="mail.view.list"/></a></li>
                                </ul>
                            </div>
                                <a href="javascript:;" style="padding-right:10px; color:#383838; cursor: pointer; font-size: 13px;float: right;margin-right:4px;" id="saveMsgData" class="btn05"><s:message code="filterInfo.setMsgFolder1"/></a>
                                <div style="position: relative; display: inline-block;">
                                    <a href="javascript:;" style="padding-right:10px; color:#383838; cursor: pointer; font-size: 13px;float: right;margin-right:4px; display: none;" id="feedbackBtn" class="btn05"><s:message code="condition.feedback"/> <s:message code="common.msg.setting"/><span class="caret"></span></a>
                                    <ul  class="dropdown-menu dropdown-menu-left" role="menu" id="feedbackSetting" style="display: none; z-index: 991; padding: 5px 0px;">
                                        <li><a href="javascript:void(0);" onclick="setFeedback(0);" style="padding-left: 20px;"><span class="feedbackCorrect" style="display: inline-block; position: relative; top: 4px;"></span>&nbsp;<s:message code="condition.info.feedback0"/></a></li>
                                        <li><a href="javascript:void(0);" onclick="setFeedback(1);" style="padding-left: 20px;"><span class="feedbackcommon" style="display: inline-block; position: relative; top: 4px;"></span>&nbsp;<s:message code="condition.info.class1"/></a></li>
                                        <li><a href="javascript:void(0);" onclick="setFeedback(2);" style="padding-left: 20px;"><span class="feedbackInNotOpen" style="display: inline-block; position: relative; top: 4px;"></span>&nbsp;<s:message code="condition.info.class2"/></a></li>
                                        <li><a href="javascript:void(0);" onclick="setFeedback(3);" style="padding-left: 20px;"><span class="feedbackInOpen" style="display: inline-block; position: relative; top: 4px;"></span>&nbsp;<s:message code="condition.info.class3"/></a></li>
                                        <li><a href="javascript:void(0);" onclick="setFeedback(4);" style="padding-left: 20px;"><span class="feedbackInCorrect" style="display: inline-block; position: relative; top: 4px;"></span>&nbsp;<s:message code="condition.info.class4"/></a></li>
                                        <li><a href="javascript:void(0);" onclick="setFeedback(9);" style="padding-left: 20px;"><span class="feedbackDefer" style="display: inline-block; position: relative; top: 4px;"></span>&nbsp;<s:message code="condition.info.feedback9"/></a></li>
                                    </ul>
                                </div>
                                <div style="position: fixed; top: 0px; bottom: 0px; left: 0px; right: 0px; z-index: 990; display: none; width: 100%; height: 100%;" id="overlay"></div>
                            </div>
                            <a href="javascript:;" class="btn05" style="color:#383838;font-size: 13px; margin-left:-4px;" class="dropdown-toggle" data-toggle="dropdown" id="config_toggle">
                                <s:message code="condition.view.setup"/><span class="caret"></span>
                            </a>
                            <div style="display:inline-block;">
                                <button id="none_btn" style="font-size: 11px; font-weight: initial; line-height: 20px; padding-right: 2px;" class="areaBtn btn05"><img src="<c:url value="/img/message/message_none.png"/>"  style="padding-right: 4px;"></button>
                                <button id="bottom_btn" style="font-size: 11px; font-weight: initial; line-height: 20px; padding-right: 2px;" class="areaBtn btn05"><img src="<c:url value="/img/message/message_bottom.png"/>" style="padding-right: 4px;"></button>
                                <button id="right_btn" style="font-size: 11px; font-weight: initial; line-height: 20px; padding-right: 2px;" class="areaBtn btn05"><img src="<c:url value="/img/message/message_right.png"/>" style="padding-right: 4px;"></button>
                            </div>
                            <div class="dropdown-menu dropdown-menu-right"  style="min-width:180px;font-size:13px;min-height: 415px; padding:0;" id="additionalBtn">
                                <div class="listRow" style="padding: 0;">
                                    <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.orderType"/></div>
                                    <select id="messageSort" class="listRowLeft" style="margin-top:5px; margin-left: 5px;">
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
                                <div class="listRow" style="padding: 0;">
                                    <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.view.type5"/></div>
                                    <label style="font-weight: normal; cursor: pointer;"><input type="checkbox" class="listRowLeft" style="margin-top:10px; margin-left: 5px;" name="subjectbody" />&nbsp;&nbsp;<s:message code="common.msg.use"/></label>
                                </div>
                                <div class="listRow" style="padding: 0;">
                                    <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.view.type10"/></div>
                                    <label style="font-weight: normal; cursor: pointer;"><input type="checkbox" class="listRowLeft" style="margin-top:10px; margin-left: 5px;" name="overlapUse" />&nbsp;&nbsp;<s:message code="common.msg.use"/> <s:message code="condition.view.type11"/></label>
                                </div>
                                <div class="listRow" style="padding: 0;">
                                    <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.view.type6"/></div>
                                    <label style="font-weight: normal; cursor: pointer;"><input type="checkbox" class="listRowLeft" style="margin-top:10px; margin-left: 5px;" name="summary" />&nbsp;&nbsp;<s:message code="common.msg.use"/> <s:message code="condition.view.type7"/></label>
                                </div>
                                <div class="listRow" style="padding: 0;">
                                    <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.view.type12"/></div>
                                    <label style="font-weight: normal; cursor: pointer;"><input type="checkbox" class="listRowLeft" style="margin-top:10px; margin-left: 5px;" name="keywordHighlight" />&nbsp;&nbsp;<s:message code="common.msg.use"/> <s:message code="condition.view.type13"/></label>
                                </div>
                                <div class="listRow" style="padding: 0;">
                                    <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 34px;"><s:message code="condition.view.type14"/></div>
                                    <label style="font-weight: normal; cursor: pointer;"><input type="checkbox" class="listRowLeft" style="margin-top:10px; margin-left: 5px;" name="hostQuery" />&nbsp;&nbsp;<s:message code="common.msg.use"/> <s:message code="condition.view.type15"/></label>
                                </div>
                                <div class="listRow" style="width: 575px; border-bottom: none; padding: 0;">
                                    <div class="listRowLeft" style="text-align:center; font-weight: bold; background-color: #eaeaea; width: 120px; height: 202px;padding-top: 70px;"><s:message code="condition.view.type4"/></div>
                                    <div class="listRowLeft" style="padding-left: 5px;">
								<span style="width: 435px; display:block;">
									<input id="insaFormatInput" style="width: 330px;" type="text" value="" data-format="name,emaile,busi,dept,jikgub,ip"/>
									<img src="<c:url value="/img/message/exclamation.png"/>" id="confError" style="display: none; padding-bottom:2px;" title="<s:message code="message.insa.error"/>">
									<img src="<c:url value="/img/message/accept.png"/>" id="confAccept" style="display: none; padding-bottom:2px;" title="<s:message code="message.insa.ok"/>">
									<span style="padding-left: 7px; margin-top:-1px;  width: 45px;" id="insaFormatOk" class="btn01"> <s:message code="common.msg.apply"/> </span>
									<span style="padding-left: 7px; margin-top:-1px;" id="insaFormatClear" class="btn02"> <s:message code="common.msg.remove"/> </span>
								</span>
                                        <span style="width: 435px; display:block;">
									<input  id="insaFormatInputEx" style="width:435px;cursor: auto !important;" disabled type="text" value="<s:message code="message.help.example"/>)" data-format="name,emaile,busi,dept,jikgub,ip"/>
								</span>
                                        <select id="messageFormat" size="8" style="width:435px; margin-top: 10px; padding-top: 2px; height:110px;">
                                            <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_name"/>/hong@xcurent.com/<s:message code="message.help.sample_bunm"/>/<s:message code="message.help.sample_deptnm"/>/<s:message code="message.help.sample_jikgubnm"/>/192.168.0.1/20241234" data-format="name/email/businm/deptnm/jikgubnm/ip/sabun">name/email/businm/deptnm/jikgubnm/ip/sabun</option>
                                            <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_name"/>-hong@xcurent.com-<s:message code="message.help.sample_bunm"/>-<s:message code="message.help.sample_deptnm"/>-<s:message code="message.help.sample_jikgubnm"/>-192.168.0.1-20241234" data-format="name-email-businm-deptnm-jikgubnm-ip-sabun">name-email-businm-deptnm-jikgubnm-ip-sabun</option>
                                            <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_name"/>,hong@xcurent.com,<s:message code="message.help.sample_bunm"/>,<s:message code="message.help.sample_deptnm"/>,<s:message code="message.help.sample_jikgubnm"/>,192.168.0.1,20241234" data-format="name,email,businm,deptnm,jikgubnm,ip,sabun">name,email,businm,deptnm,jikgubnm,ip,sabun</option>
                                            <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_name"/>[hong@xcurent.com,<s:message code="message.help.sample_bunm"/>,<s:message code="message.help.sample_deptnm"/>,<s:message code="message.help.sample_jikgubnm"/>,192.168.0.1,20241234]" data-format="name[email,businm,deptnm,jikgubnm,ip,sabun]">name[email,businm,deptnm,jikgubnm,ip,sabun]</option>
                                            <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_bunm"/>/<s:message code="message.help.sample_deptnm"/>/<s:message code="message.help.sample_name"/>" data-format="businm/deptnm/name">businm/deptnm/name</option>
                                            <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_bunm"/>-<s:message code="message.help.sample_deptnm"/>-<s:message code="message.help.sample_jikgubnm"/>-<s:message code="message.help.sample_name"/>" data-format="businm-deptnm-jikgubnm-name">businm-deptnm-jikgubnm-name</option>
                                            <option value="<s:message code="message.help.example"/>) [<s:message code="message.help.sample_bunm"/>-<s:message code="message.help.sample_deptnm"/>-<s:message code="message.help.sample_jikgubnm"/>]-<s:message code="message.help.sample_name"/>" data-format="[businm-deptnm-jikgubnm]-name">[businm-deptnm-jikgubnm]-name</option>
                                            <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_name"/>,hong@xcurent.com,192.168.0.1" data-format="name,email,ip">name,email,ip</option>
                                            <option value="<s:message code="message.help.example"/>) <s:message code="message.help.sample_name"/>(hong@xcurent.com,192.168.0.1)" data-format="name(email,ip)">name(email,ip)</option>
                                            <option value="" data-format=""> <s:message code="message.user.custom"/></option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <div id="content" class="ui-layout-north" style="position: absolute;left: 0px;right: 0px;bottom: 0px;top: 0px;font-family: 돋움,Dotum;">
                            <div style="position: relative;zoom: 1;z-index: 20;overflow: hidden;">
                                <div class="mail_header">
                                    <div class="leftHideBtn"><button class ="msg_button list_icon"><i class="fa fa-bars" aria-hidden="true"></i></button></div>
                                    <div class="tabWrap" id="headerTabs">
                                        <ul class="listTab_div" id="resultTabs">
                                            <li class="tab_li select" id="result0" data-index="0">
                                                <div class="tab_txt_top addTabDiv" id="result_tab0" style="float:left;">
                                                    <s:message code="message.msg.newtab"/>
                                                </div>
                                                <span class="resultCntSpan"></span>
                                            </li>
                                            <li class="tab_li" data-index="">
                                                <div class="tab_txt_top addTabDiv" style="padding:10px;"><span class="glyphicon glyphicon-plus" style="cursor:pointer;color:#494949; back"></span></div>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="contentListArea" class="inner-center">
                            <iframe src="<c:url value="/ems/contentList.do?gridInit=true"/>" id="contentList0" class="contentList"></iframe>
                            <iframe src="<c:url value="/ems/contentList.do?gridInit="/>" id="contentList1" class="contentList" style="left:-10000px"></iframe>
                        </div>
                        <div id="contentBodyArea" class="inner-east">
                            <iframe src="<c:url value="/ems/contentBodyNew.do"/>" id="contentBody0" class="contentBody" name="contentBody"></iframe>
                            <iframe src="<c:url value="/ems/contentBodyNew.do"/>" id="contentBody1" class="contentBody" name="contentBody" style="left:-10000px;"></iframe>
                        </div>
                    </div>
                </div>
            </div>

             <%--  검색어 도움말  --%>
            <div id="searchHelpDiv" class="searchHelpDiv" style="display:none;">
                <div class="searchKeywordTab"> <i class="glyphicon glyphicon-question-sign"></i>&nbsp;&nbsp;<s:message code="help.msg.title"/>
                    <div class="searchHelpDivCloseBtn" style="position:absolute;top:12px; right:10px;">
                        <span class="glyphicon glyphicon-remove" style="cursor:pointer;font-size:13px;" aria-hidden="true"></span>
                    </div>
                </div>
                <div style="width:100%;padding:5px 5px 5px 10px; margin-bottom:8px;" class="searchHelpDivBody">
                    <div>
                        <div style="height:55px;">
                            <h5 style="font-size:13px;">■ <span style="color:#FF0000;"><s:message code="help.msg.default"/></span></h5>
                        </div>
                        <br/>
                        <div>
                            <span>■ <s:message code="help.msg.all"/></span><br/>
                            <span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.all.ex"/></span><br/>
                            <span style="padding-left:10px;"><s:message code="help.msg.all.explain"/></span><br/>
                        </div>
                        <div style="padding-top:5px;">
                            <span>■ <s:message code="help.msg.except"/></span><br/>
                            <span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.except.ex"/></span><br/>
                            <span style="padding-left:10px;"><s:message code="help.msg.except.explain"/> </span><br/>
                        </div>
                        <div style="padding-top:5px;">
                            <span>■ <s:message code="help.msg.or"/></span><br/>
                            <span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.or.ex"/></span><br/>
                            <span style="padding-left:10px;"><s:message code="help.msg.or.explain"/> </span><br/>
                        </div>
                        <div style="padding-top:5px;">
                            <span>■ <s:message code="help.msg.exact"/></span><br/>
                            <span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.exact.ex"/></span><br/>
                            <span style="padding-left:10px;"><s:message code="help.msg.exact.explain"/> </span><br/>
                        </div>
<%--                        <div style="padding-top:5px;">--%>
<%--                            <span>■ <s:message code="help.msg.exact"/></span><br/>--%>
<%--                            <span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.exact.ex"/></span><br/>--%>
<%--                            <span style="padding-left:10px;"><s:message code="help.msg.exact.explain"/> </span><br/>--%>
<%--                        </div>--%>
<%--                        <div style="padding-top:5px;">--%>
<%--                            <span>■ <s:message code="help.msg.astar"/></span><br/>--%>
<%--                            <span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.astar.ex"/></span><br/>--%>
<%--                            <span style="padding-left:10px;"><s:message code="help.msg.astar.explain"/> </span><br/>--%>
<%--                        </div>--%>
<%--                        <div style="padding-top:5px;">--%>
<%--                            <span>■ <s:message code="help.msg.question"/></span><br/>--%>
<%--                            <span style="padding-left:10px;font-weight: bold;"><s:message code="help.msg.question.ex"/></span><br/>--%>
<%--                            <span style="padding-left:10px;"><s:message code="help.msg.question.explain"/></span><br/>--%>
<%--                        </div>--%>
                    </div>
                </div>
            </div>

            <%--  정규식 검색 도움말  --%>
            <div id="regexpHelpDiv" class="regexpHelpDiv" style="height: 560px; display:none;">
                <div class="searchKeywordTab"> <i class="glyphicon glyphicon-question-sign" style="font-size:18px; top:5px;"></i>&nbsp;&nbsp;<s:message code="help.regexp.title"/>
                    <div class="regexpHelpDivCloseBtn" style="position:absolute;top:12px; right:10px;">
                        <span class="glyphicon glyphicon glyphicon-remove-sign" style="cursor:pointer;font-size:18px;top:1px;" aria-hidden="true"></span>
                    </div>
                </div>
                <div style="width:100%;padding:10px 5px 5px 10px; line-height: 17px; margin-bottom:8px;" class="regexpHelpDivBody">
                    <div>
                        <div style="padding-top:5px;">
                            <span>■ <s:message code="common.live.regexp.search.help.desc"/></span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.desc2"/></span><br/>
                        </div>
                        </br>
                        <div style="padding-top:5px;">
                            <span>■ <s:message code="common.live.regexp.search.help.category1.title"/></span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category1.cont1"/></span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category1.cont2"/> </span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category1.cont3"/> </span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category1.cont4"/> </span><br/>
                        </div>
                        </br>
                        <div style="padding-top:5px;">
                            <span>■ <s:message code="common.live.regexp.search.help.category2.title"/></span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category2.cont1"/></span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category2.cont2"/> </span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category2.cont3"/> </span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category2.cont4"/> </span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category2.cont5"/> </span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category2.cont6"/> </span><br/>
                        </div>
                        </br>
                        <div style="padding-top:5px;">
                            <span>■ <s:message code="common.live.regexp.search.help.category3.title"/></span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category3.cont1"/></span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category3.cont2"/> </span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category3.cont3"/> </span><br/>
                        </div>
                        </br>
                        <div style="padding-top:5px;">
                            <span>■ <s:message code="common.live.regexp.search.help.category4.title"/></span><br/>
                            <span style="padding-left:10px;"><s:message code="common.live.regexp.search.help.category4.cont1"/></span><br/>
                        </div>
                        </br>
                        </br>
                    </div>
                </div>
            </div>

            <%--  수신자, 발신자 입력옵션 도움말  --%>
            <div id="matchHelpDiv" class="regexpHelpDiv" style="height: 250px; display:none;">
                <div class="searchKeywordTab"> <i class="glyphicon glyphicon-question-sign" style="font-size:18px; top:5px;"></i>&nbsp;&nbsp;<s:message code="condition.matchhelp.title"/>
                    <div class="matchHelpDivCloseBtn" style="position:absolute;top:12px; right:10px;">
                        <span class="glyphicon glyphicon glyphicon-remove-sign" style="cursor:pointer;font-size:18px;top:1px;" aria-hidden="true"></span>
                    </div>
                </div>
                <div style="width:100%;padding:10px 5px 5px 10px; line-height: 17px; margin-bottom:8px;" class="matchHelpDivBody">
                    <div>
                        <div style="padding-top:5px;">
                            <s:message code="condition.matchhelp"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="exportDialog" tabindex="-1" role="dialog" aria-labelledby="exportDialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header ">
<%--                            <button type="button" class="close " data-dismiss="modal" aria-label="Close">--%>
<%--                                <span class="glyphicon glyphicon-remove" style="cursor:pointer;"></span>--%>
<%--                            </button>--%>
                            <h3 class="modal-title mal16" id="exportTitle">&nbsp;</h3>
                        </div>
                        <div class="modal-body">
                            <div class="form-inline">
                                <div class="content_body p20">
                                    <table class="table table-bordered" style="margin-bottom:0;width:100%;">
                                        <colgroup>
                                            <col width="210">
                                            <col width="*">
                                        </colgroup>
                                        <tr>
                                            <th>
                                                <s:message code="download.msg.dataArea"/>
                                            </th>
                                            <td>
                                                <div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
                                                    <label class="btn btn-sm btn-default"><input type="radio" name="exportDataRange" id="exportDataSelect" value="S"> <s:message code="download.msg.select.count"/></label>
                                                    <label class="btn btn-sm btn-default active"><input type="radio" name="exportDataRange" id="exportDataAll" value="A" checked> <s:message code="download.msg.search.count"/></label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="exportFileTypeArea">
                                            <th>
                                                <s:message code="download.msg.fileType"/>
                                            </th>
                                            <td>
                                                <div class="btn-group filterBtn" data-toggle="buttons" style="margin-top:3px;">
                                                    <label class="btn btn-sm btn-default active"><input type="radio" name="exportFileType" id="exportExcel" value="xlsx" checked> <s:message code="common.msg.excel"/>(xlsx)</label>
                                                    <label class="btn btn-sm btn-default"><input type="radio" name="exportFileType" id="exportHancel" value="cell"> <s:message code="common.msg.hancel"/>(cell)</label>
                                                    <label class="btn btn-sm btn-default"><input type="radio" name="exportFileType" id="exportText" value="csv"> <s:message code="common.msg.text"/>(csv)</label>
                                                    <label class="btn btn-sm btn-default"><input type="radio" name="exportFileType" id="exportPdf" value="pdf"> <s:message code="selectCodeAll.list"/>(PDF)</label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                <s:message code="download.msg.export.count"/>
                                            </th>
                                            <td>
                                                <span id="exportDataSize" style="line-height:32px;">0</span>
                                            </td>
                                        </tr>
                                        <tr id="bodyInExcel">
                                            <th>
                                                <s:message code="download.msg.body.in.excel"/>
                                            </th>
                                            <td>
                                                <label class="condition_label"><input type="radio" name="bodyInExcel" value="Y"> <span><s:message code="common.msg.include"/></span></label>
                                                <label class="condition_label"><input type="radio" name="bodyInExcel" value="N" checked="checked"> <span><s:message code="common.msg.not.include"/></span></label>
                                            </td>
                                        </tr>
                                        <tr id="bodyInExcelMsg" style="font-weight: bold;display:none;">
                                            <td colspan="2">
                                                <s:message code="download.msg.body.in.excelMsg" />
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="table table-bordered" style="margin-bottom:0;width:100%;margin-top:15px;display:none;" id="bodyInExcelIdx">
                                        <colgroup>
                                            <col width="210">
                                            <col width="*">
                                        </colgroup>
                                        <tr>
                                            <th style="font-weight: bold;">
                                                <s:message code="download.msg.now.col.order" />
                                            </th>
                                            <td>
                                                <select id="nowColIdx" data-style="btn-default">
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="font-weight: bold;">
                                            <td colspan="2">
                                                <s:message code="download.msg.body.col.idx" />
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="table table-bordered" style="margin-bottom:0;width:100%;margin-top:15px;" id="sizeWarnMsg">
                                        <colgroup>
                                            <col width="210">
                                            <col width="*">
                                        </colgroup>
                                        <tr style="font-weight: bold;">
                                            <td colspan="2">
                                                <s:message code="download.msg.warn" arguments="50,000" argumentSeparator="|"/>
                                            </td>
                                        </tr>
                                        <tr style="font-weight: bold;">
                                            <th>
                                                <label for="ruleFile" class="control-label" style="vertical-align: bottom;line-height:35px;">¤ <s:message code="download.msg.file.count"/></label>
                                            </th>
                                            <td>
                                                <select id="dataLength_select" class="selectpicker" data-style="btn-default">
                                                    <option value="20000">20,000</option>
                                                    <option value="30000">30,000</option>
                                                    <option value="40000">40,000</option>
                                                    <option value="50000" selected>50,000</option>
                                                    <option value="100000">100,000</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer p20 txt_center">
                            <button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
                            <button type="button" class="pop_btn02 savePopBtn" accesskey="S" id="allDownBtn"><s:message code="common.msg.export"/></button>
                        </div>
                    </div>
                </div>
                <iframe id="upload_file" name="upload_file" src="" style="display: none;"></iframe>
            </div>


            <div style="display:none;">
                <ul id="newTab">
                    <li class="tab_li"><div class="tab_close"></div><div class="tab_txt_top addTabDiv" style="float:left;"></div><span class="resultCntSpan" style="padding-right:15px;"></span></li>
                </ul>
                <ul id="addTab">
                    <li class="tab_li addTabLi" data-index=""><div class="tab_txt_top addTabDiv" style="padding:10px;"><span class="fa fa-spinner fa-spin" style="cursor:pointer;color:#494949;"></span></div></li>
                </ul>
            </div>
            <%--                <tiles:insertAttribute name="footer" ignore="true"/>--%>
        </div> <!--//ContentArea-->
    </div><!--//Container-->
</div> <!--//wrap-->

<form action="<c:url value="/downEmassAttachByMsgId.xcn"/>" target="ExcelDown" method="post" id="downForm">
    <input type="hidden" name="msgIds" id="msgIds">
    <input type="hidden" name="msgId" id="msgId">
</form>
<form action="<c:url value="/getEmassMessageSaveZip.xcn"/>" target="ExcelDown" method="post" id="allDownForm">
    <input type="hidden" name="searchTime" id="searchTime">
    <input type="hidden" name="searchCondition" id="searchCondition">
    <input type="hidden" name="searchHeader" id="searchHeader">
    <input type="hidden" name="searchType" id="searchType">
    <input type="hidden" name="searchTotal" id="searchTotal">
    <input type="hidden" name="dataLength" id="dataLength">
    <input type="hidden" name="exportFileExt" id="exportFileExt">
</form>
<form action="<c:url value="/ems/messageFolder.do"/>" target="messageFolder" method="post" id="messageFolderForm">
    <input type="hidden" name="paramFolderSeq" id="paramFolderSeq">
    <input type="hidden" name="paramFolderName" id="paramFolderName">
</form>

<script type="text/javascript">
    var grid = new Xgrid('searchKeywordGrid', contextRoot);
    grid.onCheckBox();
    grid.autoNumber();
    grid.colAdd('searchKeyword', '<s:message code="searchKeyword.searchKeyword"/>', 300, 'left', false, 'link');
    grid.loadHeader(true);
    grid.initData('<s:message code="common.msg.search.click"/>');
    grid.onClick = function() {
        if (grid.Col == grid.ColIndex('searchKeyword')) {
            var inputType = $('[name=searchKeywordInputType]:checked').val();
            var data = grid.getRowData(grid.Row);

            if(inputType == 'S') {
                $('#searchStrInput').val(data.searchKeyword);
            } else if(inputType == 'A') {
                if($('#searchStrInput').val() != '') $('#searchStrInput').val($('#searchStrInput').val().trim() + ' +' + data.searchKeyword);
                else $('#searchStrInput').val(data.searchKeyword);
            } else {
                if($('#searchStrInput').val() != '') $('#searchStrInput').val($('#searchStrInput').val().trim() + ' ' + data.searchKeyword);
                else $('#searchStrInput').val(data.searchKeyword);
            }
        }
    };

    /* 연관 검색어 */
    var relationKeywordGrid = new Xgrid('relationKeywordGrid', contextRoot);
    relationKeywordGrid.colAdd('keyword', '<s:message code="condition.relationKeyword.view"/>', 300, 'left', false, 'link');
    relationKeywordGrid.loadHeader(true);
    relationKeywordGrid.initData('<s:message code="common.msg.search.click"/>');
    relationKeywordGrid.onClick = function () {
        if (relationKeywordGrid.Col == relationKeywordGrid.ColIndex('keyword')) {
            var inputType = $('[name=relationKeywordInputType]:checked').val();
            var data = relationKeywordGrid.getRowData(relationKeywordGrid.Row);
            if(inputType == 'S') {
                $('#searchStrInput').val(data.keyword);
            } else if(inputType == 'A') {
                if($('#searchStrInput').val() != '') $('#searchStrInput').val($('#searchStrInput').val().trim() + ' +' + data.keyword);
                else $('#searchStrInput').val(data.keyword);
            } else {
                if($('#searchStrInput').val() != '') $('#searchStrInput').val($('#searchStrInput').val().trim() + ' ' + data.keyword);
                else $('#searchStrInput').val(data.keyword);
            }
        }
    };


    /* 정규 표현식 */
    var regexSearchGrid = new Xgrid('regexSearchGrid', contextRoot);
    regexSearchGrid.colAdd('regexPatternName', '<s:message code="regexPattern.name"/>', 300, 'left', false, 'link');
    regexSearchGrid.colAdd('regexPattern', '<s:message code="condition.regex"/>', 300, 'left', true, 'link');
    regexSearchGrid.loadHeader(true);
    regexSearchGrid.initData('<s:message code="common.msg.search.click"/>');
    regexSearchGrid.onClick = function () {
        if (regexSearchGrid.Col == regexSearchGrid.ColIndex('regexPatternName')) {
            var data = regexSearchGrid.getRowData(regexSearchGrid.Row);
            $('#regexPattern').val(data.regexPattern);
        }
    };


</script>
</body>
</html>