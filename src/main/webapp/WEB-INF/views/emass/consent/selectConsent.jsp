<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<%
	String codeType = request.getParameter("codeType");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS AI - <s:message code="consent.select.consent"/></title>

	<style>
		html,body{height: 100%; padding: 0px; margin: 0px; min-width: 800px;}
		.container{height: 100%;min-height:400px;}
	</style>
	<script>
        var codeType = '<%=codeType%>';
        var searchFlag = false;
        $(document).ready(function(){
            $('#searchBtn').click(function(){ getData(); });
            $('#searchStr').enter(function(){ getData(); });
            $('#noSelectBtn').click(function(){
                opener.selectedConsent( '' );
                self.close();
            });

            $('#selectBtn').click(function(){
                if( grid.getSelectedRows().length == 0 ) {
                    alert('<s:message code="common.msg.noselect"/>');
                    return;
                }

                ui.confirmMsg('<s:message code="common.msg.confirm.save"/>', '', '', function(rs){
                    if(rs){
                        grid.on();
                        ui.post({
                            url :mode=='insert' ? 'insertInterestUser.xcn' : 'updateInterestUser.xcn',
                            data : $('#userPopForm').serializeAll(),
                            success : function ( data, total ) {

                                ui.alertMsg('<s:message code="common.msg.saved"/>');
                                $('#userPop').modal('hide');
                                getData ( );
                            },
                            error : function (status, message) {
                                ui.alertMsg(message);
                            },
                            complete : function (){
                                grid.off();
                            }

                        });
                    }
                });

                opener.getSelectedCodeData(grid.getData());
                self.close();
            });

            getData();
        });

        function getData(lastRow) {
            if(searchFlag) return;
            if ( lastRow == undefined ) {
                grid.data.length = 0;
                grid.rtnNextPageFunc = getData;
                grid.loadingPage = 0;
            } else {
                grid.loadingPage++;
            }

            grid.on();

            searchFlag=true;
            var type = $('#consentType').val();
            var searchStr = $('#searchStr').val();

            ui.get({
                url : 'getConsentSearchList.xcn',
                type : type,
                searchStr : searchStr,
                success : function(data, total) {
                    grid.appendData(data);
                },
                error : function(status, message) {
                    ui.alertMsg(message);
                },
                complete : function() {
                    searchFlag=false;
                    grid.off();
                }
            });
        }
	</script>

</head>
<body class="mini-navbar msgBody">
<%--<header class="header">--%>
<%--	<div class="naviBack">--%>
<%--		<img src="<c:url value="/img/title/home_icon.png"/>">--%>
<%--		<span class="navi"><span id="code_title"></span><s:message code="consent.select.consent"/></span>--%>
<%--	</div>--%>
<%--</header>--%>


<div class="xcn_container" style="min-width: 650px;">
	<div class="boxArea" style="min-height:inherit;">
		<div class="content_body">
			<div class="p20">
				<h2><span class="bullet02"></span><s:message code="common.msg.similar"/></h2>
				<div class="searchKeywordSearch" style="margin-top:30px;">
					<select class="condition_select" id="consentType" name="consentType">
						<option value="">- <s:message code="consent.type.consent"/> -</option>
						<option value="B"><s:message code="consent.informed.consent"/></option>
						<option value="A"><s:message code="consent.post.consent"/></option>
						<option value="M"><s:message code="consent.monitoring.consent"/></option>
						<option value="E"><s:message code="consent.retire.consent"/></option>
					</select>
					<input class="condition_input_text" type="text" name="serch" placeholder="<s:message code="searchKeyword.search"/>" id="searchStr" style="width:calc(50% - 150px);">
					<button class="form_btn01" id="searchBtn"><span><s:message code="common.search"/></span></button>

				</div>
				<%--					<div>--%>
				<%--						<div id="startdatepicker"><input type="date" id="startDate" name='startDate' style="width: 110px;">--%>
				<%--					</div>--%>
				<div class="xcn_pop_btn">
					<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
				</div>
				<div class="mat16" style="height: 70%;">
					<div id="userListGrid" class="slickGrid gridArea"></div>
				</div>
			</div>
		</div>
	</div>
</div>




<%-- <div class="container">
	<div style="background-image: url('<c:url value="/img/title/n_bg.gif"/>'); border-bottom: 1px solid #3ca00a;">
		<img src="<c:url value="/img/title/home_icon.gif"/>" width="28" height="33">
		<span class="navi"><span id="code_title"></span><s:message code="consent.select.consent"/></span>
	</div>
	<div>&nbsp;</div>
	<div class="content" style="position: absolute; left: 0px; right: 0px; bottom: 20px;top:50px;min-height:300px;min-width:700px;">
		<div style="width: calc(100% - 25px); float: left; padding-left: 20px; height:100%;">
			<div class="panel with-nav-tabs panel-primary" style="height: 100%;">
				<div class="panel-heading">
					<ul class="nav nav-tabs">
						<li class="active"><a href="#result1" data-toggle="tab" style="font-weight: bold;"><s:message code="consent.select.consent"/></a></li>
					</ul>
				</div>
				<div class="panel-body" style="height: calc(100% - 45px);">
					<div class="tab-content" style="height:100%;">
						<div class="tab-pane fade in active" id="result1">
							<div class="resultHeader" style="height:40px;">
								<div class="resultMsgDiv" style="height:35px;">
									<div class="col-xs-5fff text-right" style="position: relative; top:15px;right:0;">
										<div class="form-inline">
											<select class="form-control input-sm" id="consentType" name="consentType"">
												<option value="">- <s:message code="consent.type.consent"/> -</option>
												<option value="B"><s:message code="consent.informed.consent"/></option>
												<option value="A"><s:message code="consent.post.consent"/></option>
												<option value="M"><s:message code="consent.monitoring.consent"/></option>
												<option value="E"><s:message code="consent.retire.consent"/></option>
											</select>
											<div class="input-group">
												<input type="text" class="form-control input-sm" placeholder="<s:message code="consent.name.input"/>" id="searchStr" style="width: 180px;">
												<div class="input-group-btn">
													<button class="btn btn-sm btn-success" type="button" accesskey="Q" id="searchBtn"><i class="glyphicon glyphicon-search"></i></button>
												</div>
											</div>
											<div class="input-group text-right">
												<!-- <button type="button" class="btn btn-sm btn-primary" id="selectBtn"><span class="glyphicon glyphicon-ok"></span>&nbsp;<s:message code="common.msg.save"/></button> -->
												<button type="button" class="btn btn-sm btn-default" accesskey="C" id="noSelectBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="resultBody" style="position: relative;height: calc(100% - 40px);">
								<div class="row" style="height: 100%;">
									<div class="col-sm-12" style="padding: 15px; height: 100%;">
										<div id="userListGrid" class="slickGrid gridArea" style="position: relative; top: 0px; left: 0px; min-height:200px;height:100%;"></div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div> --%>

<script type="text/javascript">
    var grid = new Xgrid('userListGrid', contextRoot);
    grid.autoNumber();
    grid.colAdd('no', '<s:message code="consent.number.consent"/>', 120, 'center', false, 'link');
    grid.colAdd('type', '<s:message code="consent.type.consent"/>', 130, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext){
        if( value == 'B') return '<s:message code="consent.informed.consent"/>';
        else if( value == 'A') return '<s:message code="consent.post.consent"/>';
        else if( value == 'M') return '<s:message code="consent.monitoring.consent"/>';
        else if( value == 'E') return '<s:message code="consent.retire.consent"/>';
    });
    grid.colAdd('name', '<s:message code="common.msg.name"/>', 100, 'center', false, 'nomal');
    grid.colAdd('userId', '<s:message code="common.msg.userid"/>', 100, 'center', false, 'nomal');
    grid.colAdd('deptNm', '<s:message code="common.org.deptnm"/>', 150, 'left', false, 'nomal');
    grid.colAdd('edate', '<s:message code="consent.expiration.date"/>', 120, 'center', false, 'nomal');
    grid.colAdd('createDt', '<s:message code="consent.registered.date"/>', 120, 'center', false, 'nomal');
    grid.colAdd('createNm', '<s:message code="consent.registrant"/>', 100, 'center', false, 'nomal');
    grid.colAdd('userIp', 'IP', 200, 'left', false, 'nomal');
    grid.colAdd('userEmail', 'E-Mail', 250, 'left', false, 'nomal');

    grid.onClick = function() {
        if (grid.Col == grid.ColIndex('no')) {
            opener.selectedConsent( grid.getRowData( grid.Row ) );
            self.close();
        }
    };

    grid.loadHeader(false);
    grid.initData('<s:message code="common.msg.search.click"/>');
</script>
</body>
</html>