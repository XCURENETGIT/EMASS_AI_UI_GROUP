<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@page import="com.xcurenet.common.util.Common"%>
<%
    String footer_type = Common.nvl(Common.getParam(request).get("footer_type"));
%>

<footer class="unselectable" style="display: none">
    <%if(Common.isEmpty(footer_type)){%>
        <div class="row navbar-fixed-bottom">
            <div class="col-xs-5">
            </div>
            <div class="col-xs-7 text-right " style="font-size: 12px;height: 100%;line-height: 20px;">
                <span class="item"></span>
                <span class="item"></span>
            </div>
        </div>
    <%}%>
</footer>
<iframe id="ExcelDown" name="ExcelDown" src="about:blank;" style="display: none;" height="0" width="0" ></iframe>
