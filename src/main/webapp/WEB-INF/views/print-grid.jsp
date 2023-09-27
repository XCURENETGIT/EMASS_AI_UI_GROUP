<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>Print</title>
<meta name="description" content="">
<meta name="viewport" content="width=device-width">
<style type="text/css">
/* table{ border-spacing: 0;border-collapse: collapse;table-layout: fixed;}
.table {font:12px "돋움",Dotum,"굴림",Gulim,Helvetica,Sans-serif;padding-right:5px;}
.table th,
.table td{vertical-align:top;word-break:break-all}
.table th{color:#434343;line-height: 25px;border: 1px solid #CDC9C4;}
.table td{color:#434343;line-height: 23px;}
.table thead th{background-repeat: repeat-x;border-collapse: collapse;background-color: #EAEAEA;font-weight: bold;}
.table tbody th{}
.table tfoot th{}
.table tbody td{border: 1px solid #CDC9C4;padding-left: 5px;padding-right: 3px;} */

.center { position:absolute; top:50%; left:50%; width:69px; height:92px; overflow:hidden;margin-top: -50px;margin-left: -50px;}

table.response,table.request{border-collapse:collapse;font-family:dotum;border-top: 2px solid #036;table-layout: fixed;width:100px;border-left: 1px solid #ccc;}
.request th,.response th{padding:7px 4px;font-weight:bold;border-bottom:1px solid #ccc;width:10%;font-size:13px;border-right: 1px solid #ccc;}
.request th{background-color:#edf9fe;}
.response th{background-color:#ffe4e1;}
.response td,.request td{padding:4px;border-bottom:1px solid #ccc;word-break:break-all;font-size:13px;border-right: 1px solid #ccc;}

caption {
	font-size: 17px;
	font-weight: bold;
	margin-bottom: 10px;
}
h1, h2, h3, h4, h5, dl, dt, dd, ul, li, ol, th, td, p, blockquote, form, fieldset, legend, div,body { -webkit-print-color-adjust:exact; }
a {
	text-decoration: none;
	color: #434343;
}
.interestUserCheck{
	background-image:url('<c:url value="/img/icon/star.png"/>');
	background-position: center;
	background-repeat:no-repeat;
	width:16px;
	height:16px;
}

</style>
<script type="text/javascript">
function page_print( ){
}
</script>
</head>
<body onload="page_print();">
<div class="center"><img alt="" src="<c:url value="/img/loading/Loading.gif"/>"></div>
</body>
</html>