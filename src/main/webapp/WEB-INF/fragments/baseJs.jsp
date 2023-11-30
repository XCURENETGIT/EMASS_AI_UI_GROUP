<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.xcurenet.common.util.Common"%>
<%@ page import="java.util.Locale" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.ui.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.form.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.fileDownload.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.event.drag-2.2.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.bootstrap-growl.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-dialog.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-notify.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.core.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.numberedtextarea.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.bootstrap.wizard.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.grid.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.groupitemmetadataprovider.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.dataview.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.grid.ui_2.0.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sortUtil.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.columnpicker.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slickgrid-print-plugin.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/slick.rowmovemanager.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sockjs-0.3.4.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/stomp.js"/>"></script>

<%@ include file="/WEB-INF/fragments/common.jsp"%>

<% if( Common.isEquals(Common.nvl(Locale.getDefault(), "ko"), "ko")){%>
<script type="text/javascript" src="<c:url value="/js/xcnui_ko.js"/>"></script>
<%}else{%>
<script type="text/javascript" src="<c:url value="/js/xcnui_en.js"/>"></script>
<%}%>

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

<%-- popup js --%>
<script type="text/javascript" src="<c:url value="/js/Date.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-select.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/codemirror.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sql.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/show-hint.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sql-hint.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/QueryConditionNew.js"/>"></script>


<script  type="text/javascript" src="<c:url value="/js/chartAPI.js" />"   defer></script>
<script type="text/javascript" src="<c:url value="/js/highcharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/highcharts-3d.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/exporting.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/sha256.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/password.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/Date.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/hotkey.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ipaddr.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ipv6Check.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/nouislider.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.circliful.min.js"/>"></script>


<script type="text/javascript" src="<c:url value="/js/InnoFD.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/messenger.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/dropdowns-enhancement.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.scrollbar.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.ztree.all-3.5.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/referrer-killer.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/conditionNew.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ztreeRMenu.js"/>"></script>

<script type="text/javascript" src="<c:url value="/js/ztree.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/filter.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/folder.js"/>"></script>

<script type="text/javascript" src="<c:url value="/js/jquery.scrolltabs.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.mousewheel.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.layout.js"/>"></script>

<script type="text/javascript" src="<c:url value="/js/jquery.browser.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/d3.v3.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/vis.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/timeline.js"/>"></script>
<!-- process mapp -->

<script type="text/javascript" src="<c:url value="/js/colorbrewer.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/geometry.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/processmap.js"/>"></script>
