<%@page import="com.xcurenet.common.util.SpringContextUtil" %>
<%@page import="net.sf.json.JSONObject" %>
<%@page import="com.xcurenet.emass.message.service.EmsKeywordVO" %>
<%@page import="com.xcurenet.emass.message.service.EmsMessageService" %>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@page import="org.springframework.web.context.WebApplicationContext" %>
<%@page import="com.xcurenet.emass.message.service.EmsAttachTextVO" %>
<%@page import="com.xcurenet.config.service.ConfigAdminService" %>
<%@page import="com.xcurenet.config.service.ConfigAdminVO" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<%@ page import="com.xcurenet.common.util.Common" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	JSONObject param = Common.getParam(request);
	String msgId = Common.nvl(param.get("msgId"));
	String attachId = Common.nvl(param.get("attachId"));
	String searchKey = Common.nvl(param.get("searchKey"));
	String ocrYn = Common.nvl(param.get("ocrYn"));
	int attachTotalLine = 0;

	EmsMessageService emassService = SpringContextUtil.getBean(EmsMessageService.class);
	List<String> attachs = new ArrayList<>();
	List<String> fileNames = new ArrayList<>();

	EmsAttachTextVO vo = emassService.getEmassAttachTextInfo(msgId, attachId, ocrYn);
	if (vo != null) attachTotalLine = vo.getAttachTextTotalLine();

	List<EmsKeywordVO> emsKeywordVOList = emassService.getEmassKeyword(msgId);
	if (emsKeywordVOList != null) {
		for (int i = 0; i < emsKeywordVOList.size(); i++) {
			EmsKeywordVO emsKeywordVO = emsKeywordVOList.get(i);
			String type = emsKeywordVO.getType();
			if (Common.isEquals(type, "A")) attachs.add(emsKeywordVO.getKeyword());
			else if (Common.isEquals(type, "F")) fileNames.add(emsKeywordVO.getKeyword());
		}
	}

	ConfigAdminService configAdminService = SpringContextUtil.getBean(ConfigAdminService.class);
	String adminId = Common.getAdminId(session);
	ConfigAdminVO configAdminVo = configAdminService.getConfAdmin("message.keyword.highlight", adminId);
	boolean keywordHighlight = true;
	if (Common.isNotEmpty(configAdminVo)) keywordHighlight = Common.isEquals(Common.nvl(configAdminVo.getVal()), "Y") ? true : false;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS AI - <s:message code="consent.attach"/> Text Viewer</title>
	<style type="text/css">
		html, body {
			min-width: 600px !important;
			overflow-x: auto;
			overflow-y: hidden;
		}

		.clsKwds { /**예약어 표시**/
			color: #675AB1;
			font-weight: bold;
		}

		.clsHighlight { /**검색어 강조 표시**/
			background: #13C7A3;
			font-weight: bold;
		}

		.clsHighlightKwds { /**예약어 강조 표시**/
			background: #FFAD5B;
			font-weight: bold;
		}

		.btn {
			padding: 3px 10px !important;
		}

		xmp {
			display: block;
			padding: 9.5px;
			margin: 0 0 10px;
			font-size: 13px;
			line-height: 1.4285;
			color: #333;
			word-break: break-all;
			word-wrap: break-word;
			background-color: #f5f5f5;
			border: 1px solid #ddd;
			border-radius: 4px;
		}

		.pageNum {
			border: 1px solid #ccc;
			margin-top: 1px;
			text-align: center;
			cursor: pointer;
			color: #999;
		}

		.panel-body {
			height: 600px;
			padding: 10px;
		}
	</style>

	<script type="text/javascript">
        var searchkey = '<%=searchKey%>';
        var msgId = '<%=msgId%>';
        var attachId = '<%=attachId%>';
        var limit = 30;
        var offset = 0;
        var attachTextTotalLine = '<%=attachTotalLine%>';
        var pageNum = 1;
        var kHighlight = '<%=keywordHighlight%>';


        $(document).ready(function () {

            /* var totalPageA = '';
			for (var i= 0; i < totalPage;  i++) {
				totalPageA+='<a href="#" class="pageNum">'+(i+1)+'</a>';
			}
			$('#totalPage').html(totalPageA);

			$(document).on('click', '.pageNum', function(){
				var thisNum = $(this).text();
				alert(thisNum);
			}); */
            if (attachTextTotalLine > 0) {
                findKeywordPages();
                pageLoad(1);
            }
            $('#textLine').change(function () {
                limit = $('#textLine option:selected').val();
                pageLoad(1);
				findKeywordPages()
            });
            $('#textSize').change(function () {
                var fontSize = $('#textSize option:selected').val();
                $('#attachText').css('font-size', fontSize);
            });

            $(document).on('click', '.pageNum', function () {
                var t = Number($(this).text());
                pageLoad(t);
            });
        });

        function findKeywordPages() {
            var sk = searchkey.replaceAll('\\(', '').replaceAll('\\)', '');
            ui.get({
                url: 'findKeywordPages.xcn',
                msgId: msgId,
                attachId: attachId,
                searchkey: sk,
                ocrYn: '<%=ocrYn%>',
                limit: limit,
                success: function (data, total) {
					pageData = data;
                    makePageNum(pageData);
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {

                }
            });
        }

        function makePageNum(data) {
            if (data.length == 0) {
                $('#attachTextBody').removeClass('col-sm-11').addClass('col-sm-12');
                $('#pageNavi').hide();
            }
            var str = '';
            for (var i = 0; i < data.length; i++) {
                str += '<div class="pageNum">' + data[i] + '</div>';
            }
            $('#pageNaviBody').css('height', $('#attachText').height());
            $('#pageNaviBody').html(str);
        }

        function pageLoad(num) {

            $('.totalPage').html(getPage2(attachTextTotalLine, num, limit, 'pageLoad'));
            $('.totalPage a').addClass('btn05');
            $('.totalPage a').addClass('btn-info');
            $('.totalPage a').attr('role', 'button');
            $('.totalPage .direction').css('margin-right', '4px');
            $('.totalPage strong').addClass('btn');
            $('.totalPage strong').css('color', '#1A73F9');
            $('.totalPage strong').css('border', 'none');
            $('.totalPage strong').css('font-weight', 'bold');
            $('.totalPage strong').css('padding-left', '10px');
            $('.totalPage strong').css('padding-right', '10px');
            ui.onBody('attachText', 0, 0);
            ui.get({
                url: 'getEmassAttachText.xcn',
                msgId: msgId,
                attachId: attachId,
                ocrYn: '<%=ocrYn%>',
                offset: offset + limit * (num - 1),
                limit: limit,
                success: function (data, total) {
                    $('#attachText').text(data);
                    attachHighLight();
                },
                error: function (status, message) {
                    ui.alertMsg(message);
                },
                complete: function () {
                    ui.off('attachText');
                    $("#attachText").scrollTop(0);
                }
            });
        }

        function attachHighLight() {
            var searchs = searchkey.split(" ");
            if (searchs.length > 0) setHighLight(searchs, 'S'); //검색어 하이라이트 처리
            var fileNameStr = '<%=Common.join(fileNames, ", ")%>';
            var attachStr = '<%=Common.join(attachs, ", ")%>';
            var fileNameStrs = fileNameStr.split(', ');
            var attachStrs = attachStr.split(', ');
            if (fileNameStrs.length > 0) {
                if (searchkey.length == 0 || kHighlight.toString() == 'true') setFileNameHighLight(fileNameStrs, 'K'); //검색어 하이라이트 처리
            }
            if (attachStrs.length > 0) {
                if (searchkey.length == 0 || kHighlight.toString() == 'true') setAttachHighLight(attachStrs, 'K'); //검색어 하이라이트 처리
            }
        }


        function setFileNameHighLight(defaultText, type) {
            var attachDiv_obj = $("#attachName");
            for (var i = 0; i < defaultText.length; i++) {
                if (defaultText[i] == '') continue;
                $(attachDiv_obj).highlight(defaultText[i], type);
            }
        }

        function setAttachHighLight(defaultText, type) {
            var body_obj = $("#attachText");
            for (var i = 0; i < defaultText.length; i++) {
                if (defaultText[i] == '') continue;
                $(body_obj).highlight(defaultText[i], 'B' + type);
            }
        }

        function setHighLight(defaultText, type) {
            var body_obj = $("#attachText");
            var subject_obj = $("#attachName");
            for (var i = 0; i < defaultText.length; i++) {
                if (defaultText[i] == '') continue;
                $(body_obj).highlight(defaultText[i], 'B' + type);
                $(subject_obj).highlight(defaultText[i], type);
            }
        }

        jQuery.fn.highlight = function (pat, type) {
            function innerHighlight(node, pat, type) {
                pat = pat.trim().replaceAll("\\(", "").replaceAll("\\)", "");
                var skip = 0;
                if (node.nodeType == 3) {
                    if (pat.substring(0, 1) == '/' && pat.substring(pat.length - 1) == '/') {
                        //var pos = node.data.toUpperCase().indexOf(pat);

                        var solrQueryText = pat.replaceAll('/', '');
                        var re = new RegExp(solrQueryText, 'ig');
                        var matchArray;
                        var first = 0;
                        var last = 0;
                        var resultString = '';
                        while ((matchArray = re.exec(node.data.toString())) != null) {
                            /* last = matchArray.index;
							// 일치하는 모든 문자열을 연결
							resultString += nStr.substring(first, last);

							// 일치하는 부분에 강조 스타일이 지정된 class 추가
							resultString += "<span class='mulfound'>" + matchArray[0] + "</span>";
							first = re.lastIndex;
							// RegExp객체의 lastIndex속성을 이용해 검색 결과의 마지막인덱스 접근 가능 */

                            var pos = matchArray.index;
                            console.log('pos: ' + pos);
                            if (pos >= 0) {
                                var spannode = document.createElement('span');
                                spannode.name = 'spnHighlight';
                                if (type.indexOf('K') > -1) {
                                    spannode.className = 'clsHighlightKwds';
                                } else {
                                    spannode.className = 'clsHighlight';
                                }
                                if (type.indexOf('B') > -1) {
                                    if (type.indexOf('K') > -1) {
                                        spannode.style.backgroundColor = '#FFAD5B';
                                        spannode.style.color = '#000000';
                                        spannode.style.fontWeight = 'bold';
                                    } else {
                                        spannode.style.backgroundColor = '#13C7A3';
                                        spannode.style.color = '#000000';
                                        spannode.style.fontWeight = 'bold';
                                    }
                                }
                                try {
                                    var sbit = node.splitText(pos);
                                    sbit.splitText(matchArray[0].length);
                                    spannode.nodeValue = sbit.data;
                                    var sbitclone = sbit.cloneNode(true);
                                    spannode.appendChild(sbitclone);
                                    sbit.parentNode.replaceChild(spannode, sbit);
                                    skip = 1;
                                } catch (e) {

                                }
                            }
                        }
                    } else {
                        var pos = node.data.toUpperCase().indexOf(pat);
                        if (pos >= 0) {
                            var spannode = document.createElement('span');
                            spannode.name = 'spnHighlight';
                            if (type.indexOf('K') > -1) {
                                spannode.className = 'clsHighlightKwds';
                            } else {
                                spannode.className = 'clsHighlight';
                            }
                            if (type.indexOf('B') > -1) {
                                if (type.indexOf('K') > -1) {
                                    spannode.style.backgroundColor = '#FFAD5B';
                                    spannode.style.color = '#000000';
                                    spannode.style.fontWeight = 'bold';
                                } else {
                                    spannode.style.backgroundColor = '#13C7A3';
                                    spannode.style.color = '#000000';
                                    spannode.style.fontWeight = 'bold';
                                }
                            }

                            var sbit = node.splitText(pos);
                            sbit.splitText(pat.length);
                            spannode.nodeValue = sbit.data;
                            var sbitclone = sbit.cloneNode(true);
                            spannode.appendChild(sbitclone);
                            sbit.parentNode.replaceChild(spannode, sbit);
                            skip = 1;
                        }
                    }
                } else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
                    var cnt = node.childNodes.length;
                    if (node.childNodes.length > 1000) cnt = 1000;
                    for (var i = 0; i < cnt; ++i) {
                        i += innerHighlight(node.childNodes[i], pat, type);
                    }
                }
                return skip;
            }

            return this.each(function () {
                innerHighlight(this, pat.toUpperCase(), type);
            });
        };
	</script>
</head>
<body class="mini-navbar"  style="overflow: auto;">
<div class="msg_body_container" style="overflow: hidden; padding: 5px 10px;">
	<div class="content_body">
		<%if (vo != null) { %>
		<div class="row p20">
			<h2><span class="bullet02"></span><s:message code="consent.attach"/></h2>
			<div class="panel panel-default">
				<div class="panel-heading">
					<div class="row p12 grayBg02">
						<div id="attachName" style="font-weight: bold; font-size:20px;"><%=vo.getAttachName()%>
						</div>
						<div class="mat8"><s:message code="message.msg.pre_ext"/> : <span id="attachExt"><%=vo.getAttachExt()%></span></div>
						<div class="mat8"><s:message code="message.msg.attach_size"/> : <span id="attachSize"><%=vo.getAttachSize()%></span></div>
					</div>
				</div>
				<div class="panel-body" style="padding: 5px; overflow: hidden;">
					<div class="row mat8">
						<div class="col-sm-6">
							<div class="totalPage">
							</div>
						</div>
						<div class="col-sm-6 text-right">
							<div class="btn-group">
								<select id="textLine" class="form-control btn-success btn-sm btn05">
									<option value="30">&nbsp;<s:message code="message.line.view" arguments="30" argumentSeparator="|"/></option>
									<option value="50">&nbsp;<s:message code="message.line.view" arguments="50" argumentSeparator="|"/></option>
									<option value="100">&nbsp;<s:message code="message.line.view" arguments="100" argumentSeparator="|"/></option>
									<option value="300">&nbsp;<s:message code="message.line.view" arguments="300" argumentSeparator="|"/></option>
									<option value="500">&nbsp;<s:message code="message.line.view" arguments="500" argumentSeparator="|"/></option>
								</select>
							</div>
							<div class="btn-group">
								<select id="textSize" class="form-control btn-success btn-sm btn05">
									<option value="11px">&nbsp;<s:message code="message.msg.font_size"/> (<s:message code="message.msg.smaller"/>)
									</option>
									<option value="13px" selected>&nbsp;<s:message code="message.msg.font_size"/> (<s:message
											code="message.msg.small"/>)
									</option>
									<option value="14px">&nbsp;<s:message code="message.msg.font_size"/> (<s:message code="message.msg.normal"/>)
									</option>
									<option value="16px">&nbsp;<s:message code="message.msg.font_size"/> (<s:message code="message.msg.big"/>)
									</option>
									<option value="18px">&nbsp;<s:message code="message.msg.font_size"/> <s:message code="message.msg.bigger"/>)
									</option>
								</select>
							</div>
						</div>
					</div>
					<div class="row top_space">
						<div id="attachTextBody" class="col-sm-11" style="max-height: 500px; overflow-y: auto;">
							<xmp id="attachText" style="min-height: 500px; background-color: #f8f8f8; font-size: 12px; word-wrap: break-word; white-space: pre-wrap; white-space: -moz-pre-wrap; white-space: -pre-wrap; white-space: -o-pre-wrap; word-break: break-all;"></xmp>
						</div>
						<div id="pageNavi" class="col-sm-1" style="width: 70px; padding: 0px;">
							<div style="padding-left: 5px; border-bottom: 2px solid #333; font-weight: bold; margin-bottom: 5px;">Page No.</div>
							<div id="pageNaviBody" style="height:300px; overflow: auto; padding-top: 2px;"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%} else { %>
		<div class="row">
			<div class="col-sm-12">
				<div class="panel panel-default" style="height:180px;">
					<div class="panel-heading" style="font-weight: bold;height:40px;">
						<div class="pull-left"
						     style="cursor:default;width:calc(100% - 200px);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;word-wrap:normal">
							<s:message code="common.msg.information"/>
						</div>
					</div>
					<div class="panel-body css-body">
						<div style="font-size: 20px;font-weight: bold;padding-top:20px;">
							<img src="<c:url value="/img/warn.png"/>" width="60"> <s:message code="message.notfound.attachprev"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%} %>
	</div>
</div>
</body>
</html>



