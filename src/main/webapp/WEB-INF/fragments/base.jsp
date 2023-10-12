<%@ page import="com.xcurenet.common.util.Common" %>
<%@ page import="java.util.Locale" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>


<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />


<%-- popup css --%>
<link rel="stylesheet" href="<c:url value="/css/jquery.nouislider.min.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/bootstrap-datetimepicker.min.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/bootstrap-select.min.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/codemirror.css"/>"/>
<link rel="stylesheet" href="<c:url value="/css/show-hint.css"/>"/>

<link rel="stylesheet" href="<c:url value="/css/odometer-theme-default.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/gridstack.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/dashboard.css"/>"/>



<% if( Common.isEquals(Common.nvl(Locale.getDefault(), "ko"), "ko")){%>
<script type="text/javascript" src="<c:url value="/js/xcnui_ko.js"/>"></script>
<%}else{%>
<script type="text/javascript" src="<c:url value="/js/xcnui_en.js"/>"></script>
<%}%>


<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.ui.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.form.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.fileDownload.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.event.drag-2.2.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.event.drop-2.2.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.bootstrap-growl.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-dialog.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-notify.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.core.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.grid.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.groupitemmetadataprovider.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.dataview.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.grid.ui_2.0.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sortUtil.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.columnpicker.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slickgrid-print-plugin.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.rowmovemanager.js"/>"></script>

<script type="text/javascript" src="<c:url value="/js/xcnui_2.0.js"/>"></script>

<script type="text/javascript" src="<c:url value="/js/odometer.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/lodash.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/gridstack.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/gridstack.jQueryUI.js"/>"></script>




<%-- analysisScript js --%>
<script type="text/javascript" src="<c:url value="/js/moment.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/collapse.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ko.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/messageGrid.js"/>"></script>

<%-- popup js --%>
<script type="text/javascript" src="<c:url value="/js/Date.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-select.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/codemirror.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sql.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/show-hint.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sql-hint.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/QueryConditionNew.js"/>"></script>




