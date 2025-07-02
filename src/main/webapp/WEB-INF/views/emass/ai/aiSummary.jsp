<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/popupScript.jsp" %>
<link rel="stylesheet" href="<c:url value="/css/messageContent.css"/>"/>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS AI PLUS- <s:message code="ai.summary.title"/></title>
	<style>
		input[type="checkbox"] {
			margin-top: 5px;
		}

		button {
			font-family: HelveticaNeue !important;
			font-weight: 400;
			color: #383838;
		}


		.buttonDiv {
			width: 80%;
			z-index: 9;
			background-color: #fff;
			padding-bottom: 5px;
			top: 0px;
			left: 4px;
			right: 0px;
			height: 35px;
			min-width: 600px;
		}


		.buttonDiv .btnleft {
			position: absolute;
			left: 20px;
			top: 12px;
		}

		html, body {
			height: 100%;
			padding: 0px;
			margin: 0px;
			overflow: auto;
			min-width: 600px;
			min-height: 500px;
		}

		/* AI 요약 모달 관련 */
		.aiSummaryTab {
			height: 50px;
			background-color: #f8f8f8;
			color: #242330;
			line-height: 45px;
			padding-left: 20px;
		}

		.aiSummaryTitle {
			font-size: 18px;
		}

		.aiSummaryBody {
			font-family: AppleSDGothicNeo-Regular, "Malgun Gothic", "맑은 고딕", dotum, 돋움, sans-serif;
		}

		.aiSummaryDiv {
			position: absolute;
			background-color: #fff;
			z-index: 999;
			border: 1px solid #ccc;
			width: 600px;
			max-width: 600px;
			height: 680px;
		}

		.aiSummaryDivCloseBtn {
			float: right;
			padding-right: 10px;
			padding-left: 10px;
			font-size: 15px;
			cursor: pointer;
		}

		.aiSummaryDivCloseBtn:hover {
			opacity: 0.5;
		}

		.aiSummaryDivCloseBtn .glyphicon-remove:before {
			color: white !important;
		}


	</style>
	<script type="text/javascript">
		$(document).ready(function () {

			//제목
			$('#aiSummaryTitle').html(limitStringLength(window.opener.$('#subject').html(), 100));
			$('#originalBody').html(limitStringLength(window.opener.$('#emassBody').text(), 200));

			summaryAnalysis('<s:message code="ai.keyword.analysis.prompt"/>', 'keywordSummaryContent', '<s:message code="ai.keyword.analysis.desc"/>');
			summaryAnalysis('<s:message code="ai.analysis.prompt"/>', 'analysisContent', '<s:message code="ai.analysis.desc"/>');
			summaryAnalysis('<s:message code="ai.summary.prompt"/>', 'summaryContent', '<s:message code="ai.summary.desc"/>');


			//키워드 분석
			$(document).on('click', '#aiKeywordAnalysisBtn', function () {
				summaryAnalysis('<s:message code="ai.keyword.analysis.prompt"/>', 'keywordSummaryContent', '<s:message code="ai.keyword.analysis.desc"/>');
			});

			// 내용 분석
			$(document).on('click', '#aiContentAnalysisBtn', function () {
				summaryAnalysis('<s:message code="ai.analysis.prompt"/>', 'analysisContent', '<s:message code="ai.analysis.desc"/>');
			});


			// 내용 요약
			$(document).on('click', '#aiContentSummaryBtn', function () {
				summaryAnalysis('<s:message code="ai.summary.prompt"/>', 'summaryContent', '<s:message code="ai.summary.desc"/>');
			});


			// 번역
			$(document).on('click', '#aiTranslateBtn', function () {
				summaryAnalysis('<s:message code="ai.translate.prompt"/>', 'translateContent', '<s:message code="ai.translate.desc"/>');
			});


			// 복사
			$(document).on('click', '#aiContentCopy', function () {
				selectAllBodyText('aiSummaryDiv');
				document.execCommand('copy');
				window.getSelection().removeAllRanges();
				alert('<s:message code="ai.summary.content.copy"/>');
			});


		});


		/* AI 분석*/
		function summaryAnalysis(query, div, desc) {
			var requestData = {
				chat: limitStringLength(window.opener.$('#emassBody').text(), 2000) + '\n\n\n' + query
			}
			ui.post({
				url: 'getLLMAnalysis.xcn',
				data: requestData,
				beforeSend: function (xhr) {
					$('#' + div).html('');
					$('#' + div + '_loading').show();
				},
				success: function (data, total) {
					$('#' + div).html(desc + '<br><br>' + data.response.fReplaceWord('\n', '.</br>'));
				},
				error: function (status, message) {
					$('#' + div).html(message);
					//	ui.alertMsg(message);
				},
				complete: function () {
					$('#' + div + '_loading').hide();
				}
			});
		}


		function limitStringLength(inputString, maxLength) {
			return inputString.length <= maxLength ? inputString : inputString.substring(0, maxLength) + '...';
		}


		function selectAllBodyText(containerid) {
			if (document.selection) {
				var range = document.body.createTextRange();
				range.moveToElementText(document.getElementById(containerid));
				range.select();
			} else if (window.getSelection) {
				window.getSelection().removeAllRanges();
				var range = document.createRange();
				range.selectNode(document.getElementById(containerid));
				window.getSelection().addRange(range);
			}
		}


	</script>
</head>
<body class="aiSummaryBody">

<div id="aiSummaryDiv" class="aiSummaryDiv">
	<div class="aiSummaryTab">
		<span class="aiSummaryTitle" style="font-weight: bold;"><s:message code="ai.summary.title"/></span>
	</div>
	<div class="row">
		<div class="col-sm-12 align-items-center" style="min-height: 40px; max-height: 100px;">
			<span style="font-weight: bold; font-size: 16px;  width: 70%; margin-left: 14px; margin-top: 20px;  display: block;" id="aiSummaryTitle"> </span>
		</div>
		<div class="col-sm-12 text-center">
			<hr style="border: 1px dashed #63676c; width: 94%; margin: 0 auto;">
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12  margin-left: 60px; margin-top: 10px;  display: block; min-height: 500px;">

			<%-- 키워드 요약--%>
			<div style="width: 94%; margin-left: 14px; min-height: 164px;">
				<div class="panel panel-default">
					<div class="panel-heading" style="font-weight: bold;min-height:35px;">
						<h5 style="font-size: 16px;">내용</h5>
					</div>
					<div class="panel-body" style="height: 450px; overflow:auto;">
						<span id="originalBody"></span>
						<br/><br/>
						<h4>[<s:message code="ai.analysis.keyword"/>]</h4>
						<span id="keywordSummaryContent" style="line-height: 20px; font-size: 14px;">	</span>
						<div id="keywordSummaryContent_loading" style="display: none">
							<img src='<c:url value="/img/loading/Loading.gif"/>' width="42px" height="48px"/>
						</div>
						<br/><br/>
						<h4>[<s:message code="ai.analysis.content"/>]</h4>
						<span id="analysisContent" style="line-height: 20px; font-size: 14px;"></span>
						<div id="analysisContent_loading" style="display: none">
							<img src='<c:url value="/img/loading/Loading.gif"/>' width="42px" height="48px"/>
						</div>
						<br/><br/>
						<h4>[<s:message code="ai.summary.content"/>]</h4>
						<span id="summaryContent" style="line-height: 20px; font-size: 14px;"></span>
						<div id="summaryContent_loading" style="display: none">
							<img src='<c:url value="/img/loading/Loading.gif"/>' width="42px" height="48px"/>
						</div>
						<br/><br/>
						<h4>[<s:message code="ai.translate.content"/>]</h4>
						<span id="translateContent" style="line-height: 20px; font-size: 14px;"></span>
						<div id="translateContent_loading" style="display: none">
							<img src='<c:url value="/img/loading/Loading.gif"/>' width="42px" height="48px"/>
						</div>
						<br/><br/>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row" style="min-height: 50px;">
		<div class="buttonDiv">
			<div class="btnleft">

				<button type="button" class="btn01" id="aiKeywordAnalysisBtn">
					<img alt="" src="/emass/img/ztree/AI2.gif" width="20px;" height="20px;" style="margin-top: -4px!important;">
					<s:message code="ai.summary.keyword"/>
				</button>
				<button type="button" class="btn01" id="aiContentAnalysisBtn">
					<img alt="" src="/emass/img/ztree/AI2.gif" width="20px;" height="20px;" style="margin-top: -4px!important;">
					<s:message code="ai.analysis.content"/>
				</button>
				<button type="button" class="btn01" id="aiContentSummaryBtn">
					<img alt="" src="/emass/img/ztree/AI2.gif" width="20px;" height="20px;" style="margin-top: -4px!important;">
					<s:message code="ai.summary.content"/>
				</button>


				<button type="button" class="btn05" id="aiTranslateBtn">
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-translate" viewBox="0 0 16 16">
						<path d="M4.545 6.714 4.11 8H3l1.862-5h1.284L8 8H6.833l-.435-1.286zm1.634-.736L5.5 3.956h-.049l-.679 2.022z"/>
						<path d="M0 2a2 2 0 0 1 2-2h7a2 2 0 0 1 2 2v3h3a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2v-3H2a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v7a1 1 0 0 0 1 1h7a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zm7.138 9.995q.289.451.63.846c-.748.575-1.673 1.001-2.768 1.292.178.217.451.635.555.867 1.125-.359 2.08-.844 2.886-1.494.777.665 1.739 1.165 2.93 1.472.133-.254.414-.673.629-.89-1.125-.253-2.057-.694-2.82-1.284.681-.747 1.222-1.651 1.621-2.757H14V8h-3v1.047h.765c-.318.844-.74 1.546-1.272 2.13a6 6 0 0 1-.415-.492 2 2 0 0 1-.94.31"/>
					</svg>
					<s:message code="ai.translate"/>
				</button>
				<button type="button" class="btn05" id="aiContentCopy">
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-copy" viewBox="0 0 16 16">
						<path fill-rule="evenodd" d="M4 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zM2 5a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-1h1v1a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h1v1z"/>
					</svg>
					<s:message code="ai.copy"/>
				</button>
			</div>
		</div>
	</div>
</div>
</body>
