<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/popupScript.jsp"%>
<%
	String type = Common.nvl(request.getParameter("type"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%if(type.equals("to")) { %>
	<title>EMASS AI - <s:message code="mail.select.recv"/></title>
	<%} else if(type.equals("cc")){ %>
	<title>EMASS AI - <s:message code="mail.select.recv.cc"/></title>
	<%} %>
	<style type="text/css">
		html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;min-height: 500px;}
	</style>
	<script type="text/javascript">
        var searchFlag=false;
        $(document).ready(function(){
            $('#searchBtn').click(function(){ getData(); });
            $('#searchStr').enter(function(){ getData(); });
            $('#noSelectBtn').click(function(){ self.close(); });

            $('#cancelBtn').click(function(){
                self.close();
            });
            $('#toBtn').click(function(){
                addToMail();
            });

            $('#ccBtn').click(function(){
                addCCMail();
            });

            $('#addToCCBtn').click(function(){
                if ( opener ) {
                    opener.$('#alarmTo').val($("#toMailAddr").val().replaceAll(" ",""));
                    opener.$('#alarmCC').val($("#ccMailAddr").val().replaceAll(" ",""));
                    self.close( );
                } else {
                    alert("<s:message code="common.msg.connect.error"/>");
                    return;
                }
            });

            $('#toMailInit').click(function() {
                $('#toMailAddr').val('');
            });

            $('#ccMailInit').click(function() {
                $('#ccMailAddr').val('');
            });

            init();
            getData();
        });

        function init() {
            if ( opener ) {
                $("#toMailAddr").val(opener.$('#alarmTo').val().replaceAll(" ",""));
                $("#ccMailAddr").val(opener.$('#alarmCC').val().replaceAll(" ",""));
            } else {
                alert("<s:message code="common.msg.connect.error"/>");
                return;
            }
        }

        function addToMail() {
            var to = $("#toMailAddr").val().replaceAll(" ","");
            var cc = $("#ccMailAddr").val().replaceAll(" ","");
            var selected = grid.getSelectedKey('adminEmail');
            var email = "";
            for (var i=0; i<selected.length; i++) {
                var mailAddr = selected[i];
                if (duplicationCheck(mailAddr, to) && duplicationCheck(mailAddr, cc) && duplicationCheck(mailAddr, email)) email += mailAddr + ";";
            }

            if(to != "") {
                if ( to.substring(to.length-1, to.length) != ";") to += ";";
            }
            $("#toMailAddr").val(to + email);
        }

        function addCCMail() {
            var to = $("#toMailAddr").val().replaceAll(" ","");
            var cc = $("#ccMailAddr").val().replaceAll(" ","");
            var selected = grid.getSelectedKey('adminEmail');
            var email = "";
            for (var i=0; i<selected.length; i++) {
                var mailAddr = selected[i];
                if (duplicationCheck(mailAddr, to) && duplicationCheck(mailAddr, cc) && duplicationCheck(mailAddr, email)) email += mailAddr + ";";
            }
            if(cc != "") {
                if ( cc.substring(cc.length-1, cc.length) != ";") cc += ";";
            }
            $("#ccMailAddr").val(cc + email);
        }

        function duplicationCheck( email, receiver ) {
            email = email.replaceAll(" ","");
            var to = receiver.replaceAll(" ","");
            var toArr = to.split(";");
            for ( var i=0 ; i < toArr.length ; i++ ) {
                if ( toArr[i] == email ) return false;
            }
            return true;
        }

        /*
		 * 운용자 이메일 목록 조회
		 */
        function getData() {
            if(searchFlag) return;
            var searchStr = $("#searchStr").val();
            grid.on();
            searchFlag=true;
            ui.get({
                url 		: 'getAdminEmailList.xcn',
                searchStr	: searchStr,
                success 	: function(data, total) {
                    grid.setData(data);
                },
                error 		: function(status, message) {
                    ui.alertMsg(message);
                },
                complete 	: function() {
                    searchFlag=false;
                    grid.off();
                }
            });
        }
	</script>
</head>
<body class="mini-navbar msgBody">
<!--<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<%if(type.equals("to")) { %>
			<span class="navi"><span id="code_title"></span><s:message code="mail.select.recv"/></span>
			<%} else if(type.equals("cc")){ %>
			<span class="navi"><span id="code_title"></span><s:message code="mail.select.recv.cc"/></span>
			<%} %>
		</div>
	</header>-->
<div class="xcn_container">
	<div style="overflow: auto; margin-top:10px;">
		<div >
			<div class="row">
				<div class="col-xs-12">
					<h3 class="blue"><span class="bullet01"></span>
						<%if(type.equals("to")) { %>
						<span class="navi"><span id="code_title"></span><s:message code="mail.select.recv"/></span>
						<%} else if(type.equals("cc")){ %>
						<span class="navi"><span id="code_title"></span><s:message code="mail.select.recv.cc"/></span>
						<%} %>
						<button type="button" class="form_btn04 cencel_right" accesskey="C" id="cancelBtn"><s:message code="common.msg.close"/></button>
					</h3>
					<div class="grayBg mat16 popupInner">
						<div>
							<input type="text" class=" input-sm" placeholder="<s:message code="mail.message.input.id_name_email"/>" id="searchStr" style="width: 250px;">
							<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.msg.search"/></button>
							<button type="button" class="form_btn03 cencel_right mat8 mar12" accesskey="S" id="addToCCBtn"></span><s:message code="consent.select"/></button>
						</div>
					</div>
					<!--<div class="form-group form-inline not-dashed">
							<div class="input-group">
								<input type="text" class="form-control input-sm" placeholder="<s:message code="mail.message.input.id_name_email"/>" id="searchStr" style="width: 250px;">
								<div class="input-group-btn">
									<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
								</div>
							</div>
						</div>-->
				</div>
				<!--<div class="col-xs-4 text-right">
						<button type="button" class="btn btn-sm btn-primary" accesskey="S" id="addToCCBtn"><span class="glyphicon glyphicon-ok"></span>&nbsp;<s:message code="consent.select"/></button>
						<button type="button" class="btn btn-sm btn-default" accesskey="C" id="cancelBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
					</div>-->
			</div>
			<div class="row top_space" style="height: calc(100% - 220px);">
				<div class="col-xs-12" style="height: 100%;">
					<div id="emailListGrid" class="slickGrid gridArea"></div>
				</div>
			</div>
			<div class="row" style="margin-top: 30px;">
				<div class="col-sm-12">
					<div class= "row form-inline" style="line-height: 0px;">
						<div class="col-xs-2">
							<h4 accesskey="T" id="toBtn" style="margin-top:12px;"><s:message code="mail.recv"/></h4>
						</div>
						<div class="col-xs-10">
							<input type="text" class="form-control input-sm" style="width:94%; margin-left:-40px;" id="toMailAddr" readonly="readonly"/>
							<button type="button" class="btn02" accesskey="S" id="toMailInit"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
						</div>
					</div>
					<div class= "row form-inline" style="line-height: 0px;">
						<div class="col-xs-2">
							<h4 accesskey="T" id="toBtn" style="margin-top:12px;"><s:message code="mail.recv.cc"/></h4>
						</div>
						<div class="col-xs-10">
							<input type="text" class="form-control input-sm" style="width:94%; margin-left:-40px;" id="ccMailAddr" readonly="readonly"/>
							<button type="button" class="btn02"  id="ccMailInit"><img src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
						</div>
						<!--<div class="col-xs-3">
								<button type="button" class="btn btn-sm btn-primary" accesskey="B" id="ccBtn"><s:message code="mail.recv.cc"/></button>
							</div>
							<div class="col-xs-9">
								<input type="text" class="form-control input-sm" style="width:100%; margin-left:-50px;" id="ccMailAddr" readonly="readonly"/>
								<a href="#" style="color: black;"><span class="glyphicon glyphicon-remove" id="ccMailInit"></span></a>
							</div>-->
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
    var grid = new Xgrid('emailListGrid', contextRoot);
    var type = '<%=type%>';
    grid.autoNumber();
    grid.colAdd('adminId', '<s:message code="common.msg.id"/>', 100, 'center', false, 'nomal');
    grid.colAdd('adminName', '<s:message code="common.msg.name"/>', 120, 'center', false, 'nomal');
    grid.colAdd('adminType', '<s:message code="common.msg.type"/>', 130, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
        if(value=='S') return '<s:message code="common.msg.system_user"/>';
        else return '<s:message code="common.msg.monitoring_user"/>';
    });
    grid.colAdd('adminEmail', 'E-mail', 150, 'left', false, 'nomal');
    grid.colAdd('coNm', '<s:message code="common.org.co"/>', 120, 'center', false, 'nomal');
    grid.colAdd('busiNm', '<s:message code="common.org.busi"/>', 120, 'center', false, 'nomal');

    grid.loadHeader(false);
    grid.initData('<s:message code="common.msg.search.click"/>');
    grid.onDblClick = function() {
        if(type=='to') addToMail();
        else addCCMail();
    };
</script>
</body>
</html>