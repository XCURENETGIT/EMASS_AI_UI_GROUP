<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/popupScript.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS LTH - <s:message code="mail.select.form.mail"/></title>
	<style type="text/css">
		body {
			overflow: hidden;

		}

	</style>
	<script type="text/javascript"
	>
        var searchFlag=false;
        var selectedFormSubject="";
        var selectedFormSeq="";
        $(document).ready(function(){
            $('#chooseBtn').click(function(){
                if(selectedFormSubject=="" || selectedFormSeq=="") {
                    alert("<s:message code="mail.message.select.form"/>");
                    return;
                }

                if ( opener )
                {
                    opener.$('#formSubject').val(selectedFormSubject);
                    opener.$('#alarmFormSeq').val(selectedFormSeq);
                    self.close( );
                }
                else
                {
                    alert("<s:message code="common.msg.connect.error"/>");
                    return;
                }
            });

            $('#cancelBtn').click(function(){
                self.close();
            });

            getData();
        });

        /*
		 * 알람 메일 서식 목록 조회
		 */
        function getData() {
            if(searchFlag) return;

            grid.on();
            searchFlag=true;
            ui.get({
                url 		: 'getMailFormList.xcn',
                success 	: function(data, total) {
                    grid.setData(data);
                },
                error 		: function(status, message) {
                    ui.alertMsg(message);
                },
                complete 	: function() {
                    searchFlag=false;
                    grid.off();
                }
            });
        }
	</script>
</head>
<div style="width: 900px; overflow: auto; margin-top:20px;">

	<div>

		<div class="row" >
			<div class="col-xs-12">
				<h3 class="blue"><span class="bullet01"></span><s:message code="mail.select.form.mail"/>
					<button type="button" class="form_btn04 cencel_right" accesskey="C" id="cancelBtn"><s:message code="common.msg.close"/></button>
				</h3>

				<div class="grayBg mat16 popupInner">
					<div>
						<input type="text" placeholder="<s:message code="common.msg.searchMsg"/>" id="searchStr">
						<button class="form_btn01" type="button" accesskey="Q" id="searchBtn"><s:message code="common.msg.search"/></button>
						<button type="button" class="form_btn03 cencel_right mat8 mar12" accesskey="S" id="chooseBtn"></span>&nbsp;<s:message code="consent.select"/></button>
					</div>
				</div>
				<div class="mat8">
					<div id="mailFormListGrid" class="slickGrid gridArea"  style="max-height:200px; overflow-y: scroll !important;"></div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-12">
				<div class="form-inline not-dashed">
					<label for="formContent" class="control-label"><s:message code="mail.form.content"/></label>
					<textarea class="form-control" style="width:100%; height: 300px; margin-top: 5px; background-color: #f8f6f6; margin-left: 1px;" name="formContent" id="formContent" readonly="readonly"></textarea>
				</div>
			</div>
		</div>
	</div>
</div>

</div>
<%--	<button type="button" class="btn btn-sm btn-primary" accesskey="S" id="chooseBtn"><span class="glyphicon glyphicon-ok"></span>&nbsp;<s:message code="consent.select"/></button>
                <button type="button" class="btn btn-sm btn-default" accesskey="C" id="cancelBtn"><span class="glyphicon glyphicon-remove"></span>&nbsp;<s:message code="common.msg.close"/></button>
                <h3 class="modal-title"><s:message code="mail.select.form.mail"/></h3>
            </div>
            <div class="modal-body" style="margin-right: 17px;">
            <div class="row">
                <div id="mailFormListGrid" class="slickGrid gridArea"></div>
            </div>

                <div class="row" style="margin-top: 30px;">
                    <div class="col-sm-12" style="height: 100%;">
                            <label for="formContent" class=" col-xs-4" style="padding-left: 5px;"><s:message code="mail.form.content"/></label>
                            <textarea class="form-control" style="width:100%; height: 300px; margin-top: 5px; background-color: #f8f6f6; margin-left: 1px;" name="formContent" id="formContent" readonly="readonly"></textarea>
                    </div>
                </div>
            </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" accesskey="C" data-dismiss="modal"><s:message code="common.msg.close"/></button>
            <button type="button" class="btn btn-primary" id="uploadUserPopBtn" accesskey="U"><s:message code="common.msg.save"/></button>
        </div>--%>
<script type="text/javascript">
    var grid = new Xgrid('mailFormListGrid', contextRoot);
    grid.autoNumber();
    grid.colAdd('formSeq', '<s:message code="mail.form.number"/>', 40, 'center', true, 'nomal');
    grid.colAdd('formSubject', '<s:message code="mail.form.subject"/>', 458, 'left', false, 'link');
    grid.colAdd('formContent', '<s:message code="mail.form.content"/>', 250, 'left', true, 'nomal');
    grid.colAdd('formComment', '<s:message code="mail.form.comment"/>', 300, 'left', false, 'nomal');

    grid.loadHeader(true);
    grid.initData('<s:message code="common.msg.search.click"/>');
    grid.onClick = function() {
        if (grid.Col == grid.ColIndex('formSubject')) {
            var data = grid.getRowData(grid.Row);
            $('#formContent').val(data.formContent);
            selectedFormSubject = data.formSubject;
            selectedFormSeq = data.formSeq;
        }
    };
</script>
</body>
</html>