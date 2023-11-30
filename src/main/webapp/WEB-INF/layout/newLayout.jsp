<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
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
		<tiles:insertAttribute name="left" ignore="true"/>
		<div id="contentArea">
			<tiles:insertAttribute name="header" ignore="true"/>
			<tiles:insertAttribute name="body" ignore="true"/>
			<tiles:insertAttribute name="footer" ignore="true"/>
		</div> <!--//ContentArea-->
	</div><!--//Container-->
</div> <!--//wrap-->
</body>
</html>
