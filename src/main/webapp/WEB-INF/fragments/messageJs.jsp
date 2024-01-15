<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 메시지 페이지 전용 --%>

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
<script type="text/javascript" src="<c:url value="/js/jquery.scrolltabs.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/moment.js"/>"></script>


<% if( Common.isEquals(Common.nvl(Locale.getDefault(), "ko"), "ko")){%>
<script type="text/javascript" src="<c:url value="/js/xcnui_ko.js"/>"></script>
<%}else{%>
<script type="text/javascript" src="<c:url value="/js/xcnui_en.js"/>"></script>
<%}%>
<script type="text/javascript" src="<c:url value="/js/xcnui_2.0.js"/>"></script>


<script type="text/javascript" src="<c:url value="/js/ko.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/transition.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-datetimepicker.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/bootstrap-select.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/dropdowns-enhancement.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/hotkey.js"/>"></script>

<script type="text/javascript" src="<c:url value="/js/jquery.scrollbar.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ztree.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.ztree.all-3.5.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/referrer-killer.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/ztreeRMenu.js"/>"></script>


<script type="text/javascript" src="<c:url value="/js/filter.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/folder.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/date.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/conditionNew.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.layout.js"/>"></script>






