<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>EMASS AI - <s:message code="common.msg.download"/> <s:message code="mail.view.list"/></title>
	<style type="text/css">
		html,body{height: 100%; padding: 0px; margin: 0px;overflow: auto;min-width: 650px;}
		.attachExt{
			cursor:pointer;
		}
		.slick-cell input[type="checkbox"], .slick-column-name input[type="checkbox"] {margin-top:4px;}
		.deleteText{
			text-decoration:line-through;
		}


		.modal-header {
			padding: 15px;
			border-bottom: 1px solid #e5e5e5
		}
		.modal-header .close {
			margin-top: -2px
		}

		.modal-title {
			margin: 0;
			line-height: 1.42857143
		}

		.modal-body {
			position: relative;
			padding: 15px
		}

		.modal-footer {
			padding: 15px;
			text-align: right;
			border-top: 1px solid #e5e5e5
		}

		.modal-footer .btn+.btn {
			margin-bottom: 0;
			margin-left: 5px
		}

		.modal-footer .btn-group .btn+.btn {
			margin-left: -1px
		}

		.modal-footer .btn-block+.btn-block {
			margin-left: 0
		}

		.modal-scrollbar-measure {
			position: absolute;
			top: -9999px;
			width: 50px;
			height: 50px;
			overflow: scroll
		}

		.modal {z-index: 99999 !important;}
		.modal-dialog .modal-content {padding: 15px !important;max-width: 500px;}
		.modal-dialog .modal-content .modal-footer button {width: 100% !important; padding: 14px 20px !important; margin: 14px 0 8px 0; background-color: #1C64D3 !important; border: none !important; color: #fff !important; font-size: 16px; cursor: pointer;}
		.modal-dialog .modal-content .modal-footer .bootstrap-dialog-footer-buttons {padding: 8px 0 0 0;font-size: 16px;}
		.modal-dialog .modal-content .modal-footer button:hover{opacity: 0.8 !important;}
		.modal-dialog .modal-content .modal-body .bootstrap-dialog-body .bootstrap-dialog-message{ display: block; font-size: 16px; font-weight: 500; margin-top: 8px; vertical-align: middle; padding: 45px 0 0 0; background:url(../img/ico_contained.png) top center no-repeat; }
		/* 모달 관련 임시.*/
	</style>
	<script type="text/JavaScript">
        var searchFlag=false;
        $(document).ready(function(){
            $('#searchBtn').click(function(){ getData(); });
            $('#noSelectBtn').click(function(){ self.close();  });

            $('#autoRefresh').click(function(){
                if($('input[name="autoRefresh"]').is(":checked")) {
                    getData();
                }
            });

            $('#removeBtn').click(function() {
                var deleteData = grid.getSelectedRows();
                var ingData = deleteData.find(function(v) { return v.statusStr == "I" ||  v.statusStr == "S"});
                if(ingData) {
                    alert('<s:message code="download.msg.delete.exception1" />');
                    return;
                }

                removeDownInfoData(deleteData);
            })

            getData( );
        });

        function getData(lastRow) {
            if(searchFlag) return;
            grid.pageSize = 500;
            if ( lastRow == undefined ) {
                grid.data.length = 0;
                grid.rtnNextPageFunc = getData;
                grid.loadingPage = 0;
            } else {
                grid.loadingPage++;
            }
            searchFlag=true;
            ui.get({
                url 		: 'getDownBatchListMessenger.xcn',
                offset 		: grid.data.length,
                limit 		: grid.pageSize,
                success 	: function(data, total) {
                    grid.appendData(data);
                    if($('input[name="autoRefresh"]').is(":checked")) {
                        window.setTimeout(function(){
                            getData();
                        }, 5000);
                    }
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

        function downFile(downPath,downFileSize) {
            var href = '<c:url value="/downloadMessageFile.do"/>?downFilePath='+downPath+'&downFileSize='+downFileSize;
            $.fileDownload(href, {
                successCallback: function (url) {
                },
                failCallback: function (responseHtml, url) {
                    ui.alertMsg('<s:message code="consent.error.file"/>');
                }
            });
        }

        function cancelDownFile(downSeq) {
            ui.get({
                url 		: 'cancelDownFileMessenger.xcn',
                statusSel	: 'C',
                downSeq		: downSeq,
                success 	: function(data, total) {

                },
                error 		: function(status, message) {
                    ui.alertMsg(message);
                },
                complete 	: function() {
                    getData();
                }
            });
        }

        function removeDownInfoData(data) {
            if(data.length == 0) {
                alert('<s:message code="download.msg.delete.noexist" />');
                return;
            }
            ui.confirmMsg('<s:message code="download.msg.delete.confirm" />','','',function(rs) {
                ui.get({
                    url			: 'removeDownInfoData.xcn',
                    data 		: JSON.stringify(data),
                    success		: function(data, total) {
                        alert('<s:message code="common.msg.deleted" />');
                    },
                    error		: function(status, message) {

                    },
                    complete 	: function() {
                        getData();
                    }
                })
            });
        }
	</script>
</head>
<body class="mini-navbar" style="overflow-y: hidden">

<div class="modal fade" id="downValPop" tabindex="-1" role="dialog" aria-labelledby="downValPop">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title"><s:message code="common.msg.download"/> <s:message code="analysis.freedom.ui.condition"/></h3>
			</div>
			<div class="modal-body">
				<div class="form-inline" id="modal_body_area" style="min-height: 200px;max-height: 400px;overflow: auto;">
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" accesskey="C" class="btn btn-default" data-dismiss="modal"><s:message code="common.msg.close"/></button>
			</div>
		</div>
	</div>
</div>
<!--
	<header class="header">
		<div class="naviBack">
			<img src="<c:url value="/img/title/home_icon.png"/>">
			<span class="navi"><span id="code_title"></span><s:message code="mail.view.list"/></span>
		</div>
	</header>-->
<div class="xcn_container" style="min-width: 650px;">
	<div class="boxArea">
		<div class="content_body">
			<div class="row p20">
				<h2><span class="bullet02"></span><s:message code="mail.view.list"/></h2>
				<div class="col-xs-12 grayBg p20 ">
					<div class="form-inline not-dashed">
						<div class="form-group">
							<select class="form-control input-sm" id="statusSel" style="max-width: 200px;">
								<option value="" selected>- <s:message code="common.msg.download"/> <s:message code="deviceInfo.status"/> <s:message code="common.msg.select"/> -</option>
								<option value="S"><s:message code="common.msg.start"/></option>
								<option value="I"><s:message code="download.msg.progressing"/></option>
								<option value="Y"><s:message code="message.msg.file"/> <s:message code="download.msg.create"/> <s:message code="mail.complete"/></option>
								<option value="X"><s:message code="download.msg.expired"/></option>
								<option value="E"><s:message code="common.msg.noresult"/></option>
								<option value="C"><s:message code="common.msg.cancel"/></option>
							</select>
						</div>
						<div class="btn-group">
							<button type="button" class="form_btn02 btn-sm" accesskey="Q" id="searchBtn">REFRESH</button>
							<button type="button" class="btn02 btn-sm" accesskey="R" id="removeBtn" style="margin-left:5px;"><img
									src="<c:url value="/img/subBtn_trash.png"/>" alt="삭제"><s:message code="common.msg.delete"/></button>

							<span class="inner_emass">
									<label><input type="checkbox" id="autoRefresh" name="autoRefresh" checked="checked"> Auto Refresh</label>
								</span>
						</div>
					</div>
				</div>
			</div>
			<div class="row xcn_full top_space" style="margin-top:-40px;">
				<div class="col-xs-12 p20" style="height: 100%;">
					<div id="downInfoGrid" class="slickGrid gridArea"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
    var grid = new Xgrid('downInfoGrid', contextRoot);
    grid.onCheckBox();
    grid.autoNumber();
    /* grid.colAdd('downSeq', '일련번호', 0, 'center', true, 'nomal'); */
    grid.colAdd('reqDt', '<s:message code="download.msg.request.date"/>', 160, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
        var statStr = grid.getValue(row, 'statusStr');
        if( statStr == 'X' ) return '<span class="deleteText">' + value + '</span>';
        else return value;
    });
    grid.colAdd('downVal', '<s:message code="common.msg.download"/> <s:message code="analysis.freedom.ui.condition"/>', 300, 'left', false, 'link', function ( row, cell, value, columnDef, dataContext ) {
        var statStr = grid.getValue(row, 'statusStr');
        let modifiedString = value.replace(/\[.*?\]┌/, '');
        // console.log(modifiedString);
        if( statStr == 'X' ) return '<span class="deleteText">' + modifiedString.replaceAll('┌', '<br>') + '</span>';
        return modifiedString.replaceAll('┌', '<br>');
    });
    grid.colAdd('downStatus', '<s:message code="download.msg.progress"/> <s:message code="deviceInfo.status"/>', 150, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
        var progClass = "";
        var statStr = grid.getValue(row, 'statusStr');
        var ingRows = grid.getValue(row, 'ingRows').comma();
        var totalRows = grid.getValue(row, 'totalRows').comma();
        if(statStr == 'X' || statStr == 'C' || statStr == 'H' || statStr == 'M') progClass = "progress-bar-danger";
        else if(statStr == 'E') progClass = "progress-bar-warning";
        else if(statStr == 'Y') progClass = "progress-bar-success";
        if(value >= 0 && value <= 100) {
            var rtnVal = '<div class="progress-bar progress-bar-striped '+ progClass +'" role="progressbar" aria-valuenow="'+ value +'" aria-valuemin="0" aria-valuemax="100" style="width:'+value+'%">'+value+'%</div>';
            return rtnVal;
        } else {
            return value;
        }
    });
    grid.colAdd('endDt', '<s:message code="consent.expiration.date"/>', 100, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
        var statStr = grid.getValue(row, 'statusStr');
        if( statStr == 'X' ) return '<span class="deleteText">' + value + '</span>';
        else return value;
    });
    grid.colAdd('statusStr', '<s:message code="common.msg.download"/>', 80, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
        var downVal = grid.getValue(row, 'downVal');
        let newDown = downVal.match(/\[(.*?)\]/)?.[1];
        if(value=='S') return '<s:message code="common.msg.start"/>';
        else if(value=='I') return '<s:message code="download.msg.progressing"/>';
        else if(value=='Y') {
            var downPath = grid.getValue(row, 'downFilePath');
            var rtnVal = '<button type="button" class="btn btn-sm btn-primary"><s:message code="common.msg.download"/></button>';
            return rtnVal;
        }
        else if(value=='X') return '<span class="deleteText"><s:message code="download.msg.expired"/></span>';
        else if(value=='E') return '<s:message code="common.msg.noresult"/>';
        else if(value=='C'){
            return '<s:message code="common.msg.cancel"/>';
        }
        else if(value=='H') return '<s:message code="download.msg.shutdown"/>';
        else if(value=='M') return '<s:message code="download.msg.monitor"/>';
        return '';
    });
    grid.colAdd('downFileSize', '<s:message code="message.msg.attach_size"/>', 100, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
        var statStr = grid.getValue(row, 'statusStr');
        if( statStr == 'X' ) return '<span class="deleteText">' + convertFileSize(value) + '</span>';
        else return convertFileSize(value);
    });
    <%--grid.colAdd('skipCnt', '<s:message code="download.msg.skip" />', 80, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {--%>
    <%--    return value.comma();--%>
    <%--});--%>
    grid.colAdd('cancel', '<s:message code="common.msg.cancel"/>', 80, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {
        var statStr = grid.getValue(row, 'statusStr');
        if( statStr != 'X' && statStr != 'C' && statStr != 'Y' && statStr != 'M' && statStr != 'H') return '<button type="button" class="btn btn-sm btn-warning"><s:message code="common.msg.cancel"/></button>';
        else return '';
    });
    grid.loadHeader(false);
    grid.initData('<s:message code="common.msg.search.click"/>');
    grid.onClick = function() {
        if (grid.Col == grid.ColIndex('downVal')) {
            $("#downValPop").modal('show');

            var downValStr = grid.getValue(grid.Row, 'downVal').replaceAll('┌', '<br>');
            $('#modal_body_area').html(downValStr);
        }
        if (grid.Col == grid.ColIndex('statusStr')) {
            if(grid.getValue(grid.Row, 'statusStr') == 'Y') {
                downFile(grid.getValue(grid.Row, 'downFilePath'), grid.getValue(grid.Row, 'downFileSize'));
            }
        }
        if (grid.Col == grid.ColIndex('cancel')) {
            var statusStr = grid.getValue(grid.Row, 'statusStr');
            if(statusStr != 'X' && statusStr != 'C' && statusStr != 'M' && statusStr != 'H') {
                cancelDownFile(grid.getValue(grid.Row, 'downSeq'));
            }
        }
    };
</script>
</body>
</html>