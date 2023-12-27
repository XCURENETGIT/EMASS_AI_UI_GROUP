<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>EMASS PRO</title>

	<tiles:insertAttribute name="baseCss" ignore="true"/>
	<tiles:insertAttribute name="baseJs" ignore="true"/>

</head>
<body id="mainBody">
<div id="wrap">
	<tiles:insertAttribute name="top" ignore="true"/>
	<div id="container">
		<tiles:insertAttribute name="lnb" ignore="true"/>
		<div id="contentArea">
				<tiles:insertAttribute name="header" ignore="true"/>
			    <tiles:insertAttribute name="content" ignore="true"/>
<%--				<div class="tiles-inner-body"><tiles:insertAttribute name="content" ignore="true"/></div>--%>
		</div> <!--//ContentArea-->
	</div><!--//Container-->
</div> <!--//wrap-->
</body>
<tiles:insertAttribute name="footer" ignore="true"/>
</html>
