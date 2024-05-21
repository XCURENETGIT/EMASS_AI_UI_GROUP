<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.Locale" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>
<script type="text/javascript">
    var searchFlag = false;
    var adminLanguage = '<%=adminLanguage%>';
    
    
    $(document).ready(function () {
        
        if(adminLanguage == 'ko'){
            $('#ko_regExp_help').css("display",'');
            $('#en_regExp_help').css("display",'none');
		}else{
            $('#en_regExp_help').css("display",'');
            $('#ko_regExp_help').css("display",'none');
		}
        
    
        $('#searchregexNameBtn').click(function () {
            getGroupData();
        });

        $('#searchregexName').enter(function () {
            getGroupData();
        });

        $('#searchStrKeywordBtn').click(function () {
            var rows = gridGroup.getSelectedRows();
            if (rows == "") {
                alert("<s:message code="keyword.msg.select.part"/>")
                return false;
            }
            getGroupData();
        });

        $('#regexPatternInsertBtn').click(function () {
            $('#regexPatternPop input[type=text]').val('');
            $('#regexPatternPop').attr('mode', 'insert');
            $('#regexPatternPop').modal('show');
            setTimeout(function () {
                $("#regexPatternName").focus();
            }, 500);
        });

        function isValidRegexPattern(pattern) {
            //  정규식 패턴은 특수문자 중 최소 1개, 그리고 영어, 한글, 숫자 중 최소 1개 이상을 포함되어야 합니다.
            var regex = /(?=.*[\W_])(?=.*[a-zA-Z가-힣0-9]).+/;
            return regex.test(pattern);
        }



        $('#regexSaveButton').click(function () {
            var regexPatternName = $('#regexPatternName').val().ltrim().rtrim();
            if (regexPatternName == '') {
                ui.alertMsg('<s:message code="regexPattern.name.input"/>');
                $('#regexPatternName').focus();
                return false;
            }
            var regexPattern = $('#regexPattern').val().ltrim().rtrim();
            if (regexPattern == '') {
                ui.alertMsg('<s:message code="regexPattern.pattern.input"/>');
                $('#regexPattern').focus();
            }
         if (!isValidRegexPattern(regexPattern)){
             ui.alertMsg('<s:message code="regexPattern.patter_valid"/>');
             return  false;
         }


            var mode = $('#regexPatternPop').attr('mode');
            var confirmMessage = mode == 'insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';

            ui.confirmMsg(confirmMessage, '', '', function (rs) {
                if (rs) {
                    gridRegexPattern.on();
                    ui.post({
                        url: mode == 'insert' ? 'insertRegexPattern.xcn' : 'updateRegexPattern.xcn',
                        data: $('#regexPatternPopForm').serializeAll(),
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            $('#regexPatternPop').modal('hide');
                            getGroupData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            gridRegexPattern.off();
                        }
                    })
                }
            })
        });

        $('#keywordDeleteBtn').click(function () {
            var rows = gridRegexPattern.getSelectedRows();
            if (rows == '') {
                ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                return false;
            }

            ui.confirmMsg('<s:message code="common.msg.confirm.delete"/>', '', '', function (rs) {
                if (rs) {
                    gridRegexPattern.on();
                    ui.get({
                        url: 'deleteRegexPattern.xcn',
                        deleteData: JSON.stringify(rows),
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.deleted"/>');
                            getGroupData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message)
                        },
                        complete: function () {
                            gridRegexPattern.off();
                        }
                    })
                }
            });
        });
        getGroupData();
    });

    function getGroupData(flag) {
        if (searchFlag) return false;
        if (flag == undefined) {
            gridRegexPattern.data.length = 0;
            gridRegexPattern.rtnNextPageFunc = getGroupData;
            gridRegexPattern.loadingPage = 0;
        } else {
            gridRegexPattern.loadingPage++;
        }
        searchFlag = true;
        gridRegexPattern.on();

        ui.get({
            searchStr: $('#searchregexName').val(),
            url: 'getRegexPattern.xcn',
            offset: gridRegexPattern.data.length,
            limit: gridRegexPattern.pageSize,
            success: function (data, total) {
                gridRegexPattern.appendData(data);
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
                gridRegexPattern.off();
                searchFlag = false;
            }
        })

    }
</script>

<div class="modal" id="regexPatternPop" aria-labelledby="regexPatternPop" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="regexPatternPopForm">
			<div class="modalHead">
				<h2><s:message code="DATA_MONITOR.REGEX_PATTERN"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="regexPattern.update"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="regexPatternName" class="fname"><s:message code="regexPattern.name"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="regexPatternName" id="regexPatternName">
							<input type="hidden" name="regexSeq" id="regexSeq">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="regexPattern" class="fname"><s:message code="regexPattern.pattern"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="regexPattern" id="regexPattern">
						</div>
					</div>
				</div>
				<div class="info">
					<s:message code="common.guidance"/>
					<br>
					<div id="ko_regExp_help" style="width:100%;padding:5px 5px 5px 10px; line-height:20px;">
						<span>. 모든 문자와 일치합니다.  </span> <br>
						<span style="color: #1A73F9">ab.     # matches 'aba', 'abb', 'abz' </span> <br>
						<span>? 앞의 문자를 0회 또는 1회 반복합니다. 앞의 문자를 선택적으로 만드는 데 자주 사용됩니다. </span> <br>
						<span style="color: #1A73F9">abc?     # matches 'ab' and 'abc' </span> <br>
						<span>+ 앞의 문자를 한 번 이상 반복합니다. </span> <br>
						<span style="color: #1A73F9">ab+     # matches 'ab', 'abb', 'abbb', </span> <br>
						<span>* 앞의 문자를 0번 이상 반복합니다.  </span> <br>
						<span style="color: #1A73F9">ab+     # matches 'ab', 'abb', 'abbb'</span> <br>
						<span>{} 앞의 문자가 반복될 수 있는 최소 및 최대 횟수입니다. </span> <br>
						<span style="color: #1A73F9">a{2}    # matches 'aa' </span> <br>
						<span style="color: #1A73F9">a{2,4}  # matches 'aa', 'aaa', and 'aaaa' </span> <br>
						<span style="color: #1A73F9">a{2,}   # matches 'a` repeated two or more times </span> <br>

						<span>| OR 연산자. 왼쪽 또는 오른쪽 중 가장 긴 패턴이 일치하면 일치가 성공합니다. </span> <br>
						<span style="color: #1A73F9">abc|xyz  # matches 'abc' and 'xyz'</span> <br>
						<span>( … ) 그룹을 형성합니다. 그룹을 사용하여 표현식의 일부를 단일 문자로 처리할 수 있습니다. </span> <br>
						<span style="color: #1A73F9">abc(def)?  # matches 'abc' and 'abcdef' but not 'abcd'</span> <br>
						<span>[ … ] 괄호 안의 문자 중 하나를 일치시킵니다. </span> <br>
						<span style="color: #1A73F9">[abc]   # matches 'a', 'b', 'c'</span> <br>
						<span >ex ) 이메일 주소 검증 : [a-zA-Z0-9\\.\\%\\+\\-]+\\@[a-zA-Z0-9\\.\\-]+.[a-zA-Z]{2,}</span>
					</div>
					<div id="en_regExp_help" style="width:100%;padding:5px 5px 5px 10px; line-height:20px; display: none" >
						<span>. Matches any character.   </span> <br>
						<span style="color: #1A73F9">ab.     # matches 'aba', 'abb', 'abz', etc. </span> <br>
						<span>? Repeat the preceding character zero or one times. Often used to make the preceding character optional. </span> <br>
						<span style="color: #1A73F9">abc?     # matches 'ab' and 'abc' </span> <br>
						<span>+ Repeat the preceding character one or more times. </span> <br>
						<span style="color: #1A73F9">ab+     # matches 'ab', 'abb', 'abbb', </span> <br>
						<span>* Repeat the preceding character zero or more times.   </span> <br>
						<span style="color: #1A73F9">ab+     # matches 'ab', 'abb', 'abbb', etc.</span> <br>
						<span>{} Minimum and maximum number of times the preceding character can repeat.  </span> <br>
						<span style="color: #1A73F9">a{2}    # matches 'aa' </span> <br>
						<span style="color: #1A73F9">a{2,4}  # matches 'aa', 'aaa', and 'aaaa' </span> <br>
						<span style="color: #1A73F9">a{2,}   # matches 'a` repeated two or more times </span> <br>
						
						<span>| OR operator. The match will succeed if the longest pattern on either the left side OR the right side matches. </span> <br>
						<span style="color: #1A73F9">abc|xyz  # matches 'abc' and 'xyz'</span> <br>
						<span>( … ) Forms a group. You can use a group to treat part of the expression as a single character.  </span> <br>
						<span style="color: #1A73F9">abc(def)?  # matches 'abc' and 'abcdef' but not 'abcd'</span> <br>
						<span>[ … ] Match one of the characters in the brackets. </span> <br>
						<span style="color: #1A73F9">[abc]   # matches 'a', 'b', 'c'</span> <br>
						<span >ex ) Email address verification : [a-zA-Z0-9\\.\\%\\+\\-]+\\@[a-zA-Z0-9\\.\\-]+.[a-zA-Z]{2,}</span>
					</div>
<%--					<s:message code="filterInfo.msg.ip.add"/>--%>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message
							code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="regexSaveButton"><s:message
							code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>

<div>
	<div class="searchArea">
		<div class="searchSub">
			<div>
				<input type="text" placeholder='<s:message code="regexPattern.name.input"/>' id="searchregexName" style="width: 300px;">
				<button class="form_btn01" type="button" accesskey="K" id="searchregexNameBtn"><s:message code="auditLog.oper.SEARCH"/></button>
			</div>
			<button type="button" class="btn01" accesskey="A" id="regexPatternInsertBtn"><img
					src="<c:url value="/img/subBtn_plus.png"/>" alt="추가"><s:message code="common.msg.add"/></button>
			<button type="button" class="btn02" accesskey="E" id="keywordDeleteBtn"><img
					src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>
		</div>
	</div>
	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					<s:message code="regexPattern.setting"/>
					<span id="regexPatternCount"></span>
				</button>
			</div>
			<div id="regexPatternListGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
    var gridRegexPattern = new Xgrid('regexPatternListGrid', contextRoot);
    gridRegexPattern.onCheckBox();
    gridRegexPattern.autoNumber();
    gridRegexPattern.colAdd('regexPatternName', '<s:message code="regexPattern.name"/>', 200, 'left', false, 'link');
    gridRegexPattern.colAdd('regexPattern', '<s:message code="regexPattern.pattern"/>', 500, 'left', false, 'nomal');
    gridRegexPattern.colAdd('regexUser', '<s:message code="condition.user"/>', 200, 'left', false, 'nomal');
    gridRegexPattern.colAdd('regexDt', '<s:message code="consent.registered.date"/>', 200, 'left', false, 'nomal');
    gridRegexPattern.loadPageSize();
    gridRegexPattern.loadHeader(true);

    gridRegexPattern.changePageSize = function (cnt) {
        getGroupData();
    }

    gridRegexPattern.onClick = function () {
        var data = gridRegexPattern.getRowData(gridRegexPattern.Row);
        if (gridRegexPattern.Col == gridRegexPattern.ColIndex('regexPatternName')) {
            $('#regexPatternPop').attr('mode', 'modify');
            $('#regexPatternName').val(data.regexPatternName);
            $('#regexPattern').val(data.regexPattern);
            $('#regexSeq').val(data.regexSeq);
            $('#regexPatternPop').modal('show');
        }
    }
    gridRegexPattern.loadExportMenu('<s:message code="DATA_MONITOR.REGEX_PATTERN"/>');
    gridRegexPattern.loadHeader(false);
</script>

