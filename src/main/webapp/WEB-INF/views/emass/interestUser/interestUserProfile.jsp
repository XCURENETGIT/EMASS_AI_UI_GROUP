<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>EMASS LTH - 관심 사용자 프로필</title>
<%@ include file="../../base.jsp"%>
<link rel="stylesheet" href="<c:url value="/css/bootstrap-select.min.css"/>"/>

<script type="text/javascript" src="<c:url value="/js/bootstrap-select.js"/>"></script>
<style type="text/css">
.profile-container .profile-header {
    min-height: 175px;
    margin: 15px 15px 0;
    -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.35);
    -moz-box-shadow: 0 1px 2px rgba(0,0,0,.35);
    box-shadow: 1px 1px 2px rgba(0,0,0,.35);
    background-color: #fbfbfb;
}

.profile-container .profile-body .nav-tabs>li.active>a, .profile-container .profile-body .nav-tabs>li.active>a:hover, .profile-container .profile-body .nav-tabs>li.active>a:focus {
    -webkit-box-shadow: none;
    -moz-box-shadow: none;
    box-shadow: none;
    border-top: 0;
    border-bottom: 2px solid #2dc3e8;
    background-color: #fbfbfb;
    top: 2px;
    margin-bottom: 0;
}
.nav-tabs.nav-justified>.active>a, .nav-tabs.nav-justified>.active>a:hover, .nav-tabs.nav-justified>.active>a:focus {
    border: 0;
    border-top: 2px solid #2dc3e8;
    background-color: #fbfbfb;
}

.nav-tabs>li.active>a, .nav-tabs>li.active>a:hover, .nav-tabs>li.active>a:focus {
    color: #262626;
    border: 0;
    border-top: 2px solid #2dc3e8;
    border-bottom-color: transparent;
    background-color: #fbfbfb;
    z-index: 12;
    line-height: 16px;
    margin-top: -2px;
    box-shadow: 0 -2px 3px 0 rgba(0,0,0,.15);
}

.profile-container .profile-body .tab-content {
    margin-top: 30px;
    -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.35);
    -moz-box-shadow: 0 1px 2px rgba(0,0,0,.35);
    box-shadow: 0 1px 2px rgba(0,0,0,.35);
}
.tab-content.tabs-flat {
    -webkit-box-shadow: none;
    -moz-box-shadow: none;
    box-shadow: none;
    border-top: 1px solid #e5e5e5;
}
.tab-content {
    background-color: #fbfbfb;
    padding: 16px 12px;
    position: relative;
    -webkit-box-shadow: 1px 0 10px 1px rgba(0,0,0,.3);
    -moz-box-shadow: 1px 0 10px 1px rgba(0,0,0,.3);
    box-shadow: 1px 0 10px 1px rgba(0,0,0,.3);
}

.profile-container .profile-header .header-avatar {
    width: 125px;
    height: 125px;
    -webkit-border-radius: 50%;
    -webkit-background-clip: padding-box;
    -moz-border-radius: 50%;
    -moz-background-clip: padding;
    border-radius: 50%;
    background-clip: padding-box;
    border: 5px solid #f5f5f5;
    -webkit-box-shadow: 0 0 10px rgba(0,0,0,.15);
    -moz-box-shadow: 0 0 10px rgba(0,0,0,.15);
    box-shadow: 0 0 10px rgba(0,0,0,.15);
    margin: 25px auto;
}

.profile-container .profile-header .profile-info {
    min-height: 175px;
    border-right: 1px solid #eee;
    padding: 15px 40px 25px 0;
}
.profile-container .profile-header .profile-info .header-fullname {
    font: 21px 'Roboto','Lucida Sans','trebuchet MS',Arial,Helvetica;
    margin-top: 5px;
    display: inline-block;
}

.profile-container .profile-header .profile-stats .inlinestats-col:not(:last-child) {
    border-right: 1px solid #eee;
}

.profile-container .profile-header .profile-info .btn-follow {
    position: absolute;
    top: 20px;
    right: 30px;
}
.btn-palegreen, .btn-palegreen:focus {
    background-color: #a0d468 !important;
    border-color: #a0d468;
    color: #fff;
}
.btn, .btn-default, .btn:focus, .btn-default:focus {
    color: #444;
    background-color: #fff;
    border-color: #ccc;
}
.btn-sm {
    font-size: 12px;
    padding: 4px 9px;
    line-height: 1.39;
}
.btn {
    cursor: pointer;
    vertical-align: middle;
    margin: 0;
    position: relative;
    display: inline-block;
    -webkit-box-shadow: 0 1px 0 rgba(0,0,0,.05);
    -moz-box-shadow: 0 1px 0 rgba(0,0,0,.05);
    box-shadow: 0 1px 0 rgba(0,0,0,.05);
    -webkit-transition: all .15s ease;
    -moz-transition: all .15s ease;
    -o-transition: all .15s ease;
    transition: all .15s ease;
    -webkit-border-radius: 2px;
    -webkit-background-clip: padding-box;
    -moz-border-radius: 2px;
    -moz-background-clip: padding;
    border-radius: 2px;
    background-clip: padding-box;
    font-size: 13px;
}

.profile-container .profile-header .profile-stats .stats-col:not(:last-child) {
    border-right: 1px solid #eee;
}
.profile-container .profile-header .profile-stats .stats-col {
    margin: 30px 0;
    text-align: center;
}

.profile-container .profile-header .profile-stats .stats-col .stats-value {
    display: block;
    margin: 0 auto;
    text-align: center;
    font-size: 30px;
    font-family: 'Roboto','Lucida Sans','trebuchet MS',Arial,Helvetica;
}
.pink {
    color: #e75b8d !important;
}

.profile-container .profile-header .profile-stats .inlinestats-col {
    padding-top: 15px;
    text-align: center;
    font-family: 'Roboto','Lucida Sans','trebuchet MS',Arial,Helvetica;
    border-top: 1px solid #eee;
    min-height: 55px;
}

.nav-tabs>li {
    margin-bottom: -2px;
}

</style>
<script type="text/javascript">
var searchFlag=false;
var coCd_for_busi ='';
$(document).ready(function(){
	initInterestUser();	
});

function initInterestUser(){
	ui.get({
		url : 'getInterestSimpleUserList.xcn',
		success : function(data, total) {
			getInterestUserOptions(data, '');
		},
		error : function(status, message) {
			//ui.alertMsg('error:' + status);
		},
		complete : function() {
		}
	});
}

/**
 * 관심사용자 리스트 조회
 */
function getInterestUserOptions(data){
	$('#interestUserSelect').selectpicker({
		container:'body',
		noneSelectedText:'-<s:message code="condition.select.interest"/>-'
	}).change(function(){
		
	});
	
	var result='';
	for(var i=0 ; i<data.length; i++){
		result+='<option value="' + data[i].userSeq + '">' +  data[i].userNm + '</option>';
	}
	$("#interestUserSelect").html(result);
	$("#interestUserSelect").selectpicker('refresh');
}

function changeInfomation(){
	
}

</script>
</head>
<body class="mini-navbar">
	<%@ include file="../../top.jsp"%>

	<div class="container" style="position: absolute; top: 50px; left: 0px; right: 0px; bottom:0px; min-width: 1000px;min-height:520px;">
		<%@ include file="../left.jsp"%>
		<div class="content mainBodyArea">
			<div class="naviBack">
				<img src="<c:url value="/img/title/home_icon.gif"/>" width="28" height="33">
				<span class="navi"><s:message code="DATA_MONITOR"/> &gt; <s:message code="interest.profile"/></span>
			</div>
			<div class="boxArea" style="height:calc(100% - 220px);">
				<div class="well content_box" style="height:100%;">
					<div class="content_body" style="height:100%;">
						<div class="row" >
							<div class="col-md-12">
								<div class="col-xs-8 text-left topArea">
									<div class="form-group form-inline not-dashed">
										<select id="interestUserSelect" class="selectpicker" data-style="btn-default"></select>
									</div>
								</div>
								<div class="col-xs-4 text-right" id="referenceTime" style="height:32px;line-height:32px;vertical-align: bottom;">
									<s:message code="deviceInfo.reftime"/> : 2016-05-23 22:15:30
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="profile-container">
									<div class="profile-header row">
										<div class="col-lg-2 col-md-4 col-sm-12 text-center">
											<img src="<c:url value="/img/test1.jpg"/>" alt="" class="header-avatar">
										</div>
										<div class="col-lg-5 col-md-8 col-sm-12 profile-info">
											<div class="header-fullname" style="margin-bottom:5px;">홍길동(test1234)</div>
											<div class="header-information">
												<table style="width: 100%;">
													<colgroup>
														<col width="60px">
														<col>
														<col width="50px">
														<col>
													</colgroup>
													<tr>
														<th>
															회사 : 
														</th>
														<td>
															엑스큐어넷
														</td>
														<th>
															부서 : 
														</th>
														<td>
															응용개발팀
														</td>
													</tr>
													<tr>
														<th>
															사업장 : 
														</th>
														<td>
															연구소
														</td>
														<th>
															직급 : 
														</th>
														<td>
															대리 
														</td>
													</tr>
													<tr>
														<th>
															Email : 
														</th>
														<td colspan="3">
															test@xcurenet.com
														</td>
													</tr>
													<tr>
														<th>
															IP 주소: 
														</th>
														<td colspan="3">
															15.1.3.141, 15.1.3.142, 15.1.3.143, 15.1.3.144, 15.1.3.145, 15.1.3.146, 15.1.3.147, 15.1.3.148, 15.1.3.149, 15.1.3.150
														</td>
													</tr>
												</table>
											</div>
										</div>
										<div class="col-lg-5 col-md-12 col-sm-12 col-xs-12 profile-stats">
											<div class="row">
												<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12 stats-col">
													<div class="stats-title">데이터 검출 건수</div>
													<div class="stats-value pink">284</div>
												</div>
												<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12 stats-col">
													<div class="stats-title">패턴 검출 건수</div>
													<div class="stats-value pink">8</div>
												</div>
												<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12 stats-col">
													<div class="stats-title">차단 내역 검출 건수</div>
													<div class="stats-value pink">207</div>
												</div>
											</div>
											<div class="row">
												<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 inlinestats-col">
												</div>
												<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 inlinestats-col">
												</div>
												<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 inlinestats-col">
												</div>
											</div>
										</div>
									</div>
									<div class="profile-body">
										<div class="col-lg-12">
											<div class="tabbable">
												<ul class="nav nav-tabs tabs-flat  nav-justified" id="myTab11">
													<li class="active"><a data-toggle="tab"
														href="#overview" aria-expanded="true"> 타임 라인 </a></li>
													<li class="tab-red"><a data-toggle="tab"
														href="#timeline" aria-expanded="false"> 데이터 사용 </a></li>
													<li class="tab-palegreen"><a data-toggle="tab" id="contacttab" href="#contacts" aria-expanded="false">
															프로파일링 </a></li>
													<li class="tab-yellow"><a data-toggle="tab" href="#settings" aria-expanded="false"> 정보 </a></li>
												</ul>
												<div class="tab-content tabs-flat">
													<div id="overview" class="tab-pane active">타임라인</div>
													<div id="timeline" class="tab-pane">데이터 사용</div>
													<div id="contacts" class="tab-pane">프로파일링</div>
													<div id="settings" class="tab-pane">정보</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>