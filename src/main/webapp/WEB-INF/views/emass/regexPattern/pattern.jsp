<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/fragments/baseScript.jsp" %>

<style>
	#code {
		text-transform: uppercase;
	}
</style>
<script type="text/javascript">
    var searchFlag = false;
    $(document).ready(function () {
        $('#searchName').enter(function () {
            getData();
        });

        $('#searchregexNameBtn').click(function () {
            getData();
        });

        $('#PatternInsertBtn').click(function () {
            $('#code,#name,#regex').prop('disabled', false);
            $('#PatternPop input[type=text]').val('');
	        $('#regexDiv').show();
	        $('#patternType').val("C");
            $('#PatternPop').attr('mode', 'insert');
            $('#PatternPop').modal('show');
            setTimeout(function () {
                $("#PatternName").focus();
            }, 500);
        });

        function isValidRegexPattern(pattern) {
            //  정규식 패턴은 특수문자 중 최소 1개, 그리고 영어, 한글, 숫자 중 최소 1개 이상을 포함되어야 합니다.
            var regex = /(?=.*[\W_])(?=.*[a-zA-Z가-힣0-9]).+/;
            return regex.test(pattern);
        }

        $('#SaveButton').click(function () {
            var code = $('#code').val().ltrim().rtrim();
            if (code === '') {
                ui.alertMsg('<s:message code="pattern.code.input"/>');
                $('#PatternName').focus();
                return false;
            }

            var name = $('#name').val().ltrim().rtrim();
            if (name === '') {
                ui.alertMsg('<s:message code="pattern.name.input"/>');
                $('#name').focus();
                return false;
            }

	        if($('#patternType').val() != 'N'){
		        var regex = $('#regex').val().ltrim().rtrim();
		        if (regex === '') {
			        ui.alertMsg('<s:message code="pattern.regex.input"/>');
			        $('#regex').focus();
			        return false;
		        }
		        if (!isValidRegexPattern(regex)) {
			        ui.alertMsg('<s:message code="regexPattern.patter_valid"/>');
			        return false;
		        }
	        }

            var mode = $('#PatternPop').attr('mode');
            var confirmMessage = mode == 'insert' ? '<s:message code="common.msg.confirm.add"/>' : '<s:message code="common.msg.confirm.modify"/>';
            ui.confirmMsg(confirmMessage, '', '', function (rs) {
                if (rs) {
                    grid.on();
                    ui.post({
                        url: mode == 'insert' ? 'insertPattern.xcn' : 'updatePattern.xcn',
                        data: $('#PatternPopForm').serializeAll(),
                        success: function (data, totadl) {
                            ui.alertMsg('<s:message code="common.msg.saved"/>');
                            $('#PatternPop').modal('hide');
                            getData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message);
                        },
                        complete: function () {
                            grid.off();
                        }
                    })
                }
            })
        });

        $('#DeleteBtn').click(function () {
            var rows = grid.getSelectedRows();
            if (rows.length === 0) {
                ui.alertMsg('<s:message code="common.msg.choose.deleteitem"/>');
                return false;
            }
            for (let i = 0; i < rows.length; i++) {
                if (rows[i].regex == '' || rows[i].regex == null || rows[i].regex == undefined) {
                    alert('<s:message code="pattern.basic.delete"/>');
                    return false;
                }
            }

            ui.confirmMsg('<s:message code="common.msg.confirm.delete"/>', '', '', function (rs) {
                if (rs) {
                    grid.on();
                    ui.get({
                        url: 'deletePattern.xcn',
                        deleteData: JSON.stringify(rows),
                        success: function (data, total) {
                            ui.alertMsg('<s:message code="common.msg.deleted"/>');
                            getData();
                        },
                        error: function (status, message) {
                            ui.alertMsg(message)
                        },
                        complete: function () {
                            grid.off();
                        }
                    })
                }
            });
        });
        getData();
    });

    function getData(flag) {
        if (searchFlag) return false;
        if (flag == undefined) {
            grid.data.length = 0;
            grid.rtnNextPageFunc = getData;
            grid.loadingPage = 0;
        } else {
            grid.loadingPage++;
        }
        searchFlag = true;
        grid.on();


        ui.get({
            searchStr: $('#searchName').val(),
            url: 'getPattern.xcn',
            offset: grid.data.length,
            limit: grid.pageSize,
            success: function (data, total) {
                grid.appendData(data);
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
                grid.off();
                searchFlag = false;
            }
        })
    }
</script>


<div class="modal" id="PatternPop" aria-labelledby="PatternPop" data-backdrop="static">
	<div class="modal-content">
		<form method="post" id="PatternPopForm">
			<div class="modalHead">
				<h2><s:message code="SETTING.PATTERN_INFO"/> - <s:message code="common.msg.addmodify"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="SETTING.PATTERN_INFO"/> - <s:message code="common.msg.addmodify"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modalbody">
					<div class="row">
						<div class="col-35">
							<label for="code" class="fname"><s:message code="pattern.code"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="code" id="code">
							<input type="hidden" name="patternSeq" id="patternSeq">
							<input type="hidden" name="patternType" id="patternType">
						</div>
					</div>
					<div class="row">
						<div class="col-35">
							<label for="name" class="fname"><s:message code="pattern.name"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="name" id="name">
						</div>
					</div>
					<div class="row" id="regexDiv">
						<div class="col-35">
							<label for="regex" class="fname"><s:message code="pattern.regexPattern"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input type="text" class="w100" name="regex" id="regex">
						</div>
					</div>
					<div class="row" id="enable">
						<div class="col-35">
							<label for="enable" class="fname"><s:message code="pattern.enable"/></label>
						</div>
						<div class="col-65">
							<label class="radio-inline c-radio">
								<input type="radio" name="enable" value="Y">
								<s:message code="common.msg.use"/>
							</label>
							<label class="radio-inline c-radio">
								<input type="radio" name="enable" value="N">
								<s:message code="common.msg.unuse"/>
							</label>
						</div>
					</div>

				</div>
				<div class="info">
					<s:message code="common.guidance"/>
					<br>
					<div style="width:100%;padding:5px 5px 5px 10px; line-height:20px;">
						<span><s:message code="pattern.info.exeample1"/> </span> <br>
						<span style="color: #1A73F9"><s:message code="pattern.info.exeample2"/></span> <br>
						<span><s:message code="pattern.info.exeample3"/></span> <br>
						<span style="color: #1A73F9"><s:message code="pattern.info.exeample4"/></span> <br>
						<span><s:message code="pattern.info.exeample5"/></span> <br>
						<span style="color: #1A73F9"><s:message code="pattern.info.exeample6"/></span> <br>
						<span><s:message code="pattern.info.exeample7"/></span> <br>
						<span style="color: #1A73F9"><s:message code="pattern.info.exeample8"/></span> <br>
						<span><s:message code="pattern.info.exeample9"/></span> <br>
						<span style="color: #1A73F9"><s:message code="pattern.info.exeample10"/></span> <br>
						<span><s:message code="pattern.info.exeample11"/></span> <br>
						<span style="color: #1A73F9"><s:message code="pattern.info.exeample12"/></span> <br>
						<span style="color: #1A73F9"><s:message code="pattern.info.exeample13"/></span> <br>
						<span><s:message code="pattern.info.exeample14"/></span> <br>
						<span style="color: #1A73F9"><s:message code="pattern.info.exeample15"/></span> <br>
						<span><s:message code="pattern.info.exeample16"/></span> <br>
						<span style="color: #1A73F9"><s:message code="pattern.info.exeample17"/></span> <br>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" accesskey="S" id="SaveButton"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>


<div>
	<div class="searchArea">
		<div class="searchSub">
			<div>
				<input type="text" placeholder='<s:message code="Pattern.name.input"/>' id="searchName" style="width: 300px;">
				<button class="form_btn01" type="button" accesskey="K" id="searchregexNameBtn"><s:message code="auditLog.oper.SEARCH"/></button>
			</div>
			<button type="button" class="btn01" accesskey="A" id="PatternInsertBtn">
				<img src="<c:url value="/img/subBtn_plus.png"/>" alt="<s:message code="common.msg.add"/>"><s:message code="common.msg.add"/>
			</button>
			<button type="button" class="btn02" accesskey="E" id="DeleteBtn">
				<img src="<c:url value="/img/subBtn_trash.png"/>" alt="<s:message code="common.msg.delete"/>"><s:message code="common.msg.delete"/>
			</button>
		</div>
	</div>

	<div class="content xcn_full">
		<div class="contentSub">
			<div class="subtab">
				<button class="active">
					<s:message code="SETTING.PATTERN_INFO"/>
					<span id="regexPatternCount"></span>
				</button>
			</div>
			<div id="patternGrid" class="slickGrid gridArea"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
    var grid = new Xgrid('patternGrid', contextRoot);
    grid.onCheckBox();
    grid.autoNumber();
    grid.colAdd('type', '<s:message code="common.msg.separator"/>', 130, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
	    if (value == 'A') return "<s:message code="common.pattern.danger"/>";
	    else if (value == 'N') return "<s:message code="common.pattern.person"/>";
	    else return '<s:message code="pattern.custom"/>';
    });
    grid.colAdd('code', '<s:message code="pattern.code"/>', 100, 'center', false, 'link');
    grid.colAdd('name', '<s:message code="pattern.name"/>', 200, 'left', false, 'nomal');
    grid.colAdd('regex', '<s:message code="pattern.regexPattern"/>', 500, 'left', false, 'nomal');
    grid.colAdd('enable', '<s:message code="pattern.enable"/>', 130, 'center', false, 'nomal', function (row, cell, value, columnDef, dataContext) {
	    if (value == null || value == '' || value == undefined || value == 'N') return '<s:message code="common.msg.unuse"/>';
	    else  return '<s:message code="common.msg.use"/>';
    });

    grid.loadPageSize();
    grid.loadHeader(true);

    grid.changePageSize = function (cnt) {
        getData();
    }

    grid.onClick = function () {
        var data = grid.getRowData(grid.Row);
        if (grid.Col == grid.ColIndex('code')) {
	        $('#PatternPop').attr('mode', 'modify');
	        $('[name=enable][value=' + data.enable + ']').prop('checked', true);
	        $('#enable').val(data.enable);
			var type = (data.regex === undefined || data.regex === '' || data.regex === null) ?  'N' : 'C';
	        $('#patternType').val(type);
	        if (type == 'N') {
		        // 개인정보 탐지
		        $('#code').val(data.code);
		        $('#name').val(data.name);
		        $('#regex').val('');
		        $('#regexDiv').hide();
		        $('#code,#name,#regex').prop('disabled', true);
	        } else {
		        // 커스텀 패턴
		        $('#code').val(data.code);
		        $('#name').val(data.name);
		        $('#regex').val(data.regex);
		        $('#regexDiv').show();
		        $('#name,#regex').prop('disabled', false);
		        $('#code').prop('disabled', true);
	        }
	        $('#PatternPop').modal('show');
        }
    }
    grid.loadExportMenu('<s:message code="SETTING.PATTERN_INFO"/>');
    grid.loadHeader(false);


</script>