<%@ include file="/WEB-INF/fragments/popupScript.jsp" %>
<%
	String id = Common.nvl(request.getParameter("id"));
	String codeType = Common.nvl(request.getParameter("codeType"));
	String coCd = Common.nvl(request.getParameter("coCd"));
	String oldCode = Common.nvl(request.getParameter("oldCode"));
	String oldConm = Common.nvl(request.getParameter("oldConm"));
	String oldDept = Common.nvl(request.getParameter("oldDept"));
	String oldJib = Common.nvl(request.getParameter("oldJib"));
	String oldEmail = Common.nvl(request.getParameter("oldEmail"));
%>
<style>
	input[type="checkbox"] {
		margin-top: 5px;
	}
</style>
<script>
    var id = '<%=id%>';
    var codeType = '<%=codeType%>';
    var coCd = '<%=coCd%>';
    var oldCode = '<%=oldCode%>';
    var oldConm = '<%=oldConm%>';
    var oldDept = '<%=oldDept%>';
    var oldJib = '<%=oldJib%>';
    var oldEmail = '<%=oldEmail%>';
    var addFlag = true;

    $(document).ready(function () {
        $(document).bind("contextmenu", function (e) {
            return false;
        });

        var title = '';
        if (codeType == 'co') title = '<s:message code="common.org.co"/>';
        else if (codeType == 'busi') title = '<s:message code="common.org.busi"/>';
        else if (codeType == 'dept' || codeType == 'deptByCo') title = '<s:message code="common.org.dept"/>';
        else if (codeType == 'attach') title = '<s:message code="consent.attach"/>';
        else if (codeType == 'service') title = '<s:message code="selectCodeAll.type.service"/>';
        else if (codeType == 'regexp') {
            title = '<s:message code="common.msg.regexp"/>';
            $('#highcount').prop('disabled', true);
            $("#count_condition").change(function () {
                var selectedCode = $(this).val();
                if (selectedCode == 'B') {
                    $('#lowcount, #highcount').prop('disabled', false);
                    $('#lowcount').focus();
                } else {
                    $('#lowcount').prop('disabled', false);
                    $('#highcount').prop('disabled', true).focus();
                }
            });
        } else if (codeType == 'senders') title = '<s:message code="condition.sender"/>';
        else if (codeType == 'receivers') title = '<s:message code="condition.recv"/>';
        else if (codeType == 'user') title = '<s:message code="common.org.user"/>';
        else if (codeType == 'keyword') {
            title = '<s:message code="keyword.msg.keyword"/>';
            getKeywordGroupList();

            $("#keywordGroup").change(function () {
                getCodeList();
            });
        }else if (codeType == 'coreKeyword'){
	        title = '<s:message code="keyword.msg.coreKeyword"/>';

        };

        $('#code_title').html(title);
        if ($('#busiCd').css('display') == 'none') $('#searchStr').css('width', '250px');

        $('#addBtn').click(function () {
            setSelectedData();
        });
        $('#removeBtn').click(function () {
            grid2.deleteSelectedRows();
        });
        $('#searchBtn').click(function () {
            getCodeList();
        });
        $('#searchStr').enter(function () {
            getCodeList();
        });
        $('#noSelectBtn').click(function () {
            opener.getSelectedCodeData(codeType, []);
            self.close();
        });

        $('#selectBtn').click(function () {
            if (grid2.getData().length == 0) {
                alert('<s:message code="common.msg.noselect"/>');
                return;
            }
            // if (id != null && id != '') codeType = id; //조건 추가
            if (codeType != null && codeType == 'senders' && grid2.getData().length > 1) {
                alert('<s:message code="common.warn.sendUser"/>');
                return;
            }

            opener.getSelectedCodeData(codeType, grid2.getData());
            if (codeType == 'co') {
                opener.resetCode('busi');
                opener.busiBtnControl();
            }
            self.close();
        });

        $('#saveCountBtn').click(function () {
            var conditionCode = $('#count_condition').val();
            var lowcount = $('#lowcount').val().replace(/ /g, '');
            var highcount = $('#highcount').val().replace(/ /g, '');

            if (!lowcount.isNumber() || lowcount.indexOf('-') > -1 || lowcount.indexOf('.') > -1 || lowcount == '') {
                ui.alertMsg('<s:message code="dashboard.message.input.only_number"/>');
                return;
            }
            if (conditionCode == 'B') {
                if (!highcount.isNumber() || highcount.indexOf('-') > -1 || highcount.indexOf('.') > -1 || highcount == '') {
                    ui.alertMsg('<s:message code="dashboard.message.input.only_number"/>');
                    return;
                }

                if (Number(lowcount) > Number(highcount)) {
                    ui.alertMsg('<s:message code="selectCodeAll.msg.cannot.startend"/>');
                    return;
                }
            }

            var str = '';
            if (conditionCode == 'B') str = conditionCode + '@' + lowcount + '@' + highcount;
            else str = conditionCode + '@' + lowcount;

            grid2.setValue(grid2.Row, 'count', str);
            $('#countPop').modal('hide');
        });

        $('#noSelectBtn').click(function () {
            opener.resetCode(codeType);
        });

        getCodeList();

        if (codeType != 'senders' && codeType != 'receivers' && codeType != 'user' && codeType != 'coreKeyword' && codeType != 'attach' && codeType != 'keyword' && codeType != 'regexp' && codeType != 'dept') {
            if (opener.$('#' + codeType + 'Hidden').val() != '') setCode();
        } else {
            if (oldCode != '') setCode();
        }
    });

    function getKeywordGroupList() {
        ui.get({
            url: 'getKeywordGroupList.xcn',
            useYn: '',
            success: function (data, total) {

                var str = '<option value="">- <s:message code="keyword.msg.part_name"/> -</option>';
                for (var i = 0; i < data.length; i++) {
                    str += '<option value="' + data[i].groupSeq + '">' + data[i].groupName + '</option>';
                }
                $('#keywordGroup').html(str);
                $('#keywordGroup').css('display', '');
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
            }
        });
    }

    function setCode() {
        var codeArr = (oldCode.indexOf("|") > -1) ? oldCode.split('|') : oldCode.split(',');
        var conmArr =  oldConm.split(',');
        var deptArr = oldDept.split('|');
        var jibArr =  oldJib.split('|');
        var emailArr =  oldEmail.split('|');
        var dataArr = [];
        
        $.each(codeArr, function (i, d) {
            var dataObj = {
                 code : d
				,conm : conmArr[i]
				,dept : (deptArr[i] == undefined) ? '' : deptArr[i]
				,jib : (jibArr[i] == undefined) ? '' : jibArr[i]
				,email : (emailArr[i] == undefined) ? '' : emailArr[i]

			}
            dataArr.push(dataObj);
        });
        
        var data = [];
        if (codeType == 'regexp') {
            $.each(dataArr, function (i, d) {
                var code = d.code.split('%');
                data.push({
                    'code': code[0],
                    'codeName': d.conm.substring(0, d.conm.indexOf('(')),
                    'count':  code[1]
                });
            });
        } else if (codeType == 'user'||codeType == 'senders'||codeType == 'receivers') {
            $.each(dataArr, function (i, d) {
                console.log(d)
                data.push({'code': d.code, 'codeName':  d.conm , 'tempNm1': d.dept, 'tempNm2': d.jib, 'email': d.email});
            });
		} else  {
            $.each(dataArr, function (i, d) {
                data.push({'code': d.code, 'codeName': d.conm});
            });
        }

		if (dataArr != null && dataArr != '' && dataArr != undefined) grid2.setData(data);
    
    }

    function setSelectedData() {
        var selectedData = grid2.getData();
        var selectData = grid.getSelectedRows();
        var data = [];

        for (var i = 0, total = selectData.length; i < total; i++) {
            var flag = true;
            for (var j = 0, cnt = selectedData.length; j < cnt; j++) {
                if (selectData[i].code == selectedData[j].code) {
                    flag = false;
                    break;
                }
            }
            console.log(selectData[i].email);
            if (flag) {
                if (codeType == 'regexp') data.push({
                    'code': selectData[i].code,
                    'codeName': selectData[i].codeName,
                    'count': 'L@1',
                    'tempNm1': selectData[i].tempNm1,
                    'tempNm2': selectData[i].tempNm2
                });
                else data.push({
                    'code': selectData[i].code,
                    'codeName': selectData[i].codeName,
                    'tempNm1':selectData[i].tempNm1,
                    'tempNm2': selectData[i].tempNm2,
                    'email': selectData[i].email
                });
            }
        }

        if (data.length > 300 || (data.length + selectedData.length) > 300) {
            if (addFlag) {
                ui.confirmMsg('<s:message code="condition.speed"/>', '', '', function (rs) {
                    if (rs) {
                        grid2.appendData(data);
                        addFlag = false;
                    }
                });
            } else grid2.appendData(data);
        } else grid2.appendData(data);
    }

    function getCodeList() {
        var tempCode1 = '';
        if (codeType == 'keyword') tempCode1 = $("#keywordGroup option:selected").val();
        var searchStr = $('#searchStr').val();
        ui.get({
            url: 'getCodeList.xcn',
            searchStr: searchStr,
            codeType: codeType,
            coCd: coCd,
            tempCode1: tempCode1,
            success: function (data, total) {
                grid.setData(data);
            },
            error: function (status, message) {
                ui.alertMsg(message);
            },
            complete: function () {
                searchFlag = false;
                grid.off();
            }
        });
    }
</script>

<div class="modal" id="countPop" tabindex="-1" role="dialog" aria-labelledby="countPop">
	<div class="modal-content" style="width: 520px;">
		<form method="post" id="countPopForm">
			<div class="modalHead">
				<h2><s:message code="common.msg.regexp_count_setting"/></h2>
				<span class="close" data-dismiss="modal">&times;</span>
			</div>
			<div class="modalCon">
				<div class="modalTop">
					<h3><s:message code="common.msg.regexp_count_setting"/></h3>
					<p>
						<span class="red_dot veralign_middle"></span>
						<s:message code="common.required.msg"/>
					</p>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-35">
							<label for="lowcount" class="fname"><s:message code="common.msg.regexp_count_setting"/></label>
							<span class="red_dot"></span>
						</div>
						<div class="col-65">
							<input style="width: 70px;" type="text" class="w100" name="lowcount" id="lowcount"/>
							<select style="width: 70px;" class="w100" id="count_condition" name="count_condition">
								<option value="B"><s:message code="condition.range"/></option>
								<option value="L" selected="selected"><s:message code="condition.over"/></option>
								<option value="S"><s:message code="condition.below"/></option>
							</select>
							<input style="width: 70px;" type="text" class="w100" name="highcount" id="highcount"/>
						</div>
					</div>
				</div>
				<div class="modalfooter">
					<button type="button" class="pop_btn01" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="pop_btn02" id="saveCountBtn" accesskey="S"><s:message code="common.msg.save"/></button>
				</div>
			</div>
		</form>
	</div>
</div>
</div>

<div class="modal fade" id="holidayPop" tabindex="-1" role="dialog" aria-labelledby="holidayModal">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<form method="post" id="holidayPopForm">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h3 class="modal-title"><s:message code="common.org.choose.co"/></h3>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label for="attachTypePopInput" class=""><s:message code="selectCodeAll.date"/></label>
						<div class='input-group date' id='datePicker'>
							<input type='text' class="input-sm form-control" id='date'/>
							<span class="input-group-addon"> <span class="glyphicon glyphicon-calendar"></span>
								</span>
						</div>
					</div>
					<div class="form-group">
						<label for="attachDescPopInput" class=""><s:message code="common.msg.comment"/></label>
						<input type="text" class="form-control" name="comment" id="comment" placeholder="<s:message code="common.msg.comment"/>"
						       required>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
					<button type="button" class="btn btn-primary savePopBtn" accesskey="S" id="savePopBtn"><s:message
							code="common.msg.save"/></button>
				</div>
			</form>
		</div>
	</div>
</div>


<!--popup-->
<div id="popupWrap" class="xcn_container">
	<!-- left -->
	<div class="row">
		<div class="item" style="width: calc(50% - 30px);float: left;">
			<h3 class="blue"><span class="bullet01"></span><s:message code="selectCodeAll.list"/></h3>
			<div class="grayBg mat8 popupInner">
				<div>
					<input type="text" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr">
					<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.msg.search"/></button>
				</div>
			</div>
			<!-- 테이블 -->
			<div class="pop_tableArea mat16">
				<!-- 테이블 -->
				<div id="coCdGrid" class="subTable slickGrid gridArea" style="height: calc(100% - 150px)"></div>
			</div>
		</div>
		<div class="item" style="width: 60px;float: left;height: 100%;padding-top: 20%;">
			<button class="pop_btn03 dis_block" type="button" accesskey="I" id="addBtn">
				<img src="<c:url value="/img/ico_double_left.png"/>" alt=">>">
			</button>
			<button class="pop_btn03 dis_block mat8" type="button" accesskey="D" id="removeBtn">
				<img src="<c:url value="/img/ico_double_right.png"/>" alt="<<">
			</button>
		</div>
		<div class="item" style="width: calc(50% - 30px);float: left;">
			<h3 class="blue"><span class="bullet01"></span><s:message code="selectCodeAll.selected.list"/></h3>
			<div class="grayBg mat8 popupInner">
				<div class="txt_right">
					<button class="form_btn03" accesskey="Y" id="selectBtn"><s:message code="common.msg.select"/></button>
					<button class="form_btn04" accesskey="N" id="noSelectBtn"><s:message code="selectCodeAll.noselect"/></button>
				</div>
			</div>
			<!-- 테이블 -->
			<div class="pop_tableArea mat16">
				<div id="coCdGrid2" class="subTable slickGrid gridArea" style="height: calc(100% - 150px)"></div>
			</div>
		</div>
	</div>
</div>
<!--//popup-->


<script type="text/javascript">
    var grid = new Xgrid('coCdGrid', contextRoot);
    grid.setDrag(true);
    grid.onCheckBox();
    grid.autoNumber();
    if (codeType == 'co') {
        grid.colAdd('code', '<s:message code="common.org.cocd"/>', 100, 'center', false, 'link');
        grid.colAdd('codeName', '<s:message code="common.org.conm"/>', 260, 'left', false, 'nomal');
    } else if (codeType == 'busi') {
        grid.colAdd('code', '<s:message code="common.org.busicd"/>', 100, 'center', false, 'link');
        grid.colAdd('codeName', '<s:message code="common.org.businm"/>', 260, 'left', false, 'nomal');
    } else if (codeType == 'dept' || codeType == 'deptByCo') {
        grid.colAdd('code', '<s:message code="common.org.deptcd"/>', 150, 'center', false, 'link');
        grid.colAdd('codeName', '<s:message code="common.org.deptnm"/>', 260, 'left', false, 'nomal');
    } else if (codeType == 'attach') {
        grid.colAdd('code', '<s:message code="common.msg.ext"/>', 100, 'center', false, 'link');
        grid.colAdd('codeName', '<s:message code="condition.attach_type"/>', 260, 'left', false, 'nomal');
    } else if (codeType == 'service') {
        grid.colAdd('code', '<s:message code="filterInfo.serviceCode"/>', 100, 'center', false, 'link');
        grid.colAdd('codeName', '<s:message code="filterInfo.service"/>', 260, 'left', false, 'nomal');
    } else if (codeType == 'regexp') {
        grid.colAdd('code', '<s:message code="selectCodeAll.code"/>', 100, 'center', false, 'link');
        grid.colAdd('codeName', '<s:message code="common.msg.regexp"/>', 260, 'left', false, 'nomal');
    } else if (codeType == 'user' || codeType == 'senders' || codeType == 'receivers') {
        grid.colAdd('code', '<s:message code="common.msg.id"/>', 100, 'center', false, 'link');
        grid.colAdd('codeName', '<s:message code="common.msg.name"/>', 100, 'left', false, 'nomal');
        grid.colAdd('tempNm1', '<s:message code="common.org.dept"/>', 100, 'center', false, 'nomal');
        grid.colAdd('tempNm2', '<s:message code="common.org.jikgub"/>', 150, 'left', false, 'nomal');
        /*grid.colAdd('email', '<s:message code="common.org.email"/>', 260, 'left', false, 'nomal');*/
    } else if (codeType == 'keyword') {
        grid.colAdd('tempNm1', '<s:message code="keyword.msg.partnm"/>', 120, 'left', false, 'nomal');
        grid.colAdd('codeName', '<s:message code="keyword.msg.keyword"/>', 230, 'left', false, 'link');
    }else if (codeType == 'coreKeyword'){
	    grid.colAdd('tempNm1', '<s:message code="keyword.msg.partnm"/>', 120, 'left', false, 'nomal');
	    grid.colAdd('codeName', '<s:message code="keyword.msg.keyword"/>', 230, 'left', false, 'link');
    } else {
        grid.colAdd('code', '<s:message code="selectCodeAll.code"/>', 100, 'center', false, 'link');
        grid.colAdd('codeName', '<s:message code="selectCodeAll.codenm"/>', 260, 'left', false, 'nomal');
    }

    grid.onClick = function () {
        if (grid.Col == grid.ColIndex('code')) {
            setSelectedData();
        }
        if (codeType == 'keyword') {
            if (grid.Col == grid.ColIndex('codeName')) {
                setSelectedData();
            }
        }
    };
    grid.onContextMenu = function () {
        setSelectedData();
    };

    grid.loadHeader(false);
    grid.initData('<s:message code="selectCodeAll.select.code"/>')
    /*
			grid.onDragStart = function(e,dd){
				$('#coCdGrid2').css('border', '2px solid #FFA040');
			};
			grid.onDragEnd = function(e,dd){
				if ($(e.target).parent().parent().attr('id') == 'coCdGrid2') {
					setSelectedData();
				}
				$('#coCdGrid2').css('border','border: 1px solid #EFEFEF;border-top: 2px solid #7A7A7A;');
			};
	*/

    var options = {};
    options.status_cnt_id = '#total_cnt2';
    options.status_cnt_ing_name = '<s:message code="selectCodeAll.cnt.select"/>';
    options.status_cnt_end_name = '<s:message code="selectCodeAll.cnt.select"/>';
    var grid2 = new Xgrid('coCdGrid2', contextRoot, 26, options);
    grid2.onCheckBox();
    grid2.autoNumber();

    if (codeType == 'co') {
        grid2.colAdd('code', '<s:message code="common.org.cocd"/>', 100, 'center', false, 'link');
        grid2.colAdd('codeName', '<s:message code="common.org.conm"/>', 260, 'left', false, 'nomal');
    } else if (codeType == 'busi') {
        grid2.colAdd('code', '<s:message code="common.org.busicd"/>', 100, 'center', false, 'link');
        grid2.colAdd('codeName', '<s:message code="common.org.businm"/>', 260, 'left', false, 'nomal');
    } else if (codeType == 'dept' || codeType == 'deptByCo') {
        grid2.colAdd('code', '<s:message code="common.org.deptcd"/>', 150, 'center', false, 'li nk');
        grid2.colAdd('codeName', '<s:message code="common.org.deptnm"/>', 260, 'left', false, 'nomal');
    } else if (codeType == 'attach') {
        grid2.colAdd('code', '<s:message code="common.msg.ext"/>', 100, 'center', false, 'link');
        grid2.colAdd('codeName', '<s:message code="condition.attach_type"/>', 260, 'left', false, 'nomal');
    } else if (codeType == 'service') {
        grid2.colAdd('code', '<s:message code="filterInfo.serviceCode"/>', 100, 'center', false, 'link');
        grid2.colAdd('codeName', '<s:message code="filterInfo.service"/>', 260, 'left', false, 'nomal');
    } else if (codeType == 'regexp') {
        grid2.colAdd('code', '<s:message code="selectCodeAll.code"/>', 100, 'center', false, 'link');
        grid2.colAdd('codeName', '<s:message code="common.msg.regexp"/>', 160, 'left', false, 'nomal');
        grid2.colAdd('count', '<s:message code="common.msg.regexp_count"/>', 160, 'center', false, 'link', function (row, cell, value, columnDef, dataContext) {
            var str = '';
            if (value != undefined && value != '') {
                str = value.split('@');
                if (str[0] == 'B') return str[1] + '<s:message code="selectCodeAll.items"/> ~ ' + str[2] + '<s:message code="selectCodeAll.items"/>';
                else if (str[0] == 'L') return str[1] + '<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.over"/>';
                else return str[1] + '<s:message code="selectCodeAll.items"/> <s:message code="selectCodeAll.below"/>';
            } else return '';
        });
    } else if (codeType == 'user' || codeType == 'senders' || codeType == 'receivers') {
        grid2.colAdd('code', '<s:message code="common.msg.id"/>', 100, 'center', false, 'link');
        grid2.colAdd('codeName', '<s:message code="common.msg.name"/>', 100, 'left', false, 'nomal');
        grid2.colAdd('tempNm1', '<s:message code="common.org.dept"/>', 100, 'center', false, 'nomal');
        grid2.colAdd('tempNm2', '<s:message code="common.org.jikgub"/>', 160, 'left', false, 'nomal');
       /* grid2.colAdd('email', '<s:message code="common.org.email"/>', 260, 'left', false, 'nomal');*/
    } else if (codeType == 'keyword') {
        grid2.colAdd('codeName', '<s:message code="keyword.msg.keyword"/>', 260, 'left', false, 'link');
    } else {
        grid2.colAdd('code', '<s:message code="selectCodeAll.code"/>', 100, 'center', false, 'link');
        grid2.colAdd('codeName', '<s:message code="selectCodeAll.codenm"/>', 260, 'left', false, 'nomal');
    }
    grid2.onContextMenu = function () {
        grid2.deleteSelectedRows();
    };
    grid2.onClick = function () {
        if ((codeType == 'keyword' || codeType == 'coreKeyword') && grid2.Col == grid2.ColIndex('codeName')) {
            grid2.deleteSelectedRows();
        } else if (grid2.Col == grid2.ColIndex('code')) {
            grid2.deleteSelectedRows();
        } else if (grid2.Col == grid2.ColIndex('count')) {
            $('#countPop').modal();

            var val = grid2.getValue(grid2.Row, 'count').split('@');
            if (val[0] == 'B') {
                $('#lowcount, #highcount').prop('disabled', false);
                $('#count_condition').val(val[0]);
                $('#lowcount').val(val[1]);
                $('#highcount').val(val[2]);
            } else {
                $('#highcount').prop('disabled', true).val('');
                $('#count_condition').val(val[0]);
                $('#lowcount').val(val[1]);
            }

            setTimeout(function () {
                $('#lowcount').focus();
            }, 500);
        }
    };
    grid2.loadHeader(false);
    grid2.initData('<s:message code="selectCodeAll.select.code"/>');


</script>