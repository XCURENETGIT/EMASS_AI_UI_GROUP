<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<title>Endpoint list</title>
<style type="text/css">

.tbl_list {
	border-top: 2px solid #73abd1;
}

.tbl_list table {
	table-layout: fixed;
	word-break: break-all;
	border-collapse: collapse;
	border-spacing: 0px;
}

.tbl_list table thead td,th {
	background-color: #e8f3f9;
	border-bottom: 1px #d7d7d7 solid;
	border-right: 1px #d7d7d7 solid;
	height: 30px;
	color: #2a2a2a;
	font-family: dotum, Verdana, arial, sans-serif;
	text-align: center;
	font-size: 12px;
	font-weight: bold;
	border-collapse: collapse;
	border-spacing: 0px;
}

.tbl_list table thead td:last-child {
	border-right: 0px;
}

.tbl_list table tbody td {
	padding-left: 10px;
	padding-right: 10px;
	border-bottom: 1px #d7d7d7 solid;
	border-right: 1px #d7d7d7 solid;
	height: 30px;
	color: #2a2a2a;
	font-family: dotum, Verdana, arial, sans-serif;
	font-size: 12px;
	font-weight: none;
	border-collapse: collapse;
	border-spacing: 0px;
}

.tbl_list table tbody td:last-child {
	border-right: 0px;
}
</style>
</head>
<body>
	<h1>Request Pages Table</h1>
	<div class="tbl_list">
		<table>
			<thead>
				<tr>
					<th>Desc</th>
					<th>Path</th>
					<th>Class</th>
					<th>Method</th>
					<th>Param</th>
					<th>Return</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${pages}" var="endPoint">
					<tr>
						<td>${endPoint.desc}</td>
						<td>${endPoint.path}</td>
						<td>${endPoint.cls}</td>
						<td>${endPoint.method}</td>
						<td>${endPoint.param}</td>
						<td>${endPoint.rtn}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>

	<h1>Request Mapping Table</h1>
	<div class="tbl_list">
		<table>
			<thead>
				<tr>
					<th>Desc</th>
					<th>Operation</th>
					<th>Path</th>
					<th>Class</th>
					<th>Method</th>
					<th>Param</th>
					<th>Return</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${endPoints}" var="endPoint">
					<tr>
						<td>${endPoint.desc}</td>
						<td>${endPoint.operation}</td>
						<td>${endPoint.path}</td>
						<td>${endPoint.cls}</td>
						<td>${endPoint.method}</td>
						<td>${endPoint.param}</td>
						<td>${endPoint.rtn}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>