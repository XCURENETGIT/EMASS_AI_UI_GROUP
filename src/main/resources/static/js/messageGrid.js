
		var statGrid;
		function initGrid( currGrid, gridColumn){
			statGrid = currGrid;
			currGrid.autoNumber();
			currGrid.colAdd('msgid', gridColumn.msgid, 100, 'left', false, 'nomal');
			currGrid.colAdd('epmsg_type', gridColumn.epmsg_type, 100, 'center', true, 'nomal');
			currGrid.colAdd('xrootmtr', gridColumn.xrootmtr, 100, 'left', true, 'nomal');
			currGrid.colAdd('interestUserYn', gridColumn.interestUserYn, 40, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == 'Y') return '<div class="interestUserCheck"></div>';
				else if (value == 'N') return '';
			});
			currGrid.colAdd('readYn', gridColumn.readYn, 40, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == 'Y') return '<div class="readY"></div>';
				else if (value == 'N') return '<div class="readN"></div>';
				else return '-';
			});
			if( infoFeedbackConf == 'true' && infoFeedbackYn == 'Y' ) {
			/*currGrid.colAdd('ml_confd_class_label', gridColumn.ml_confd_class, 100, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				value = currGrid.getValue(row, 'ml_confd_class');
				if (value == '4') return mlConfdClassMsg.C4;
				else if (value == '3') return mlConfdClassMsg.C3;
				else if (value == '2') return mlConfdClassMsg.C2;
				else if (value == '1') return mlConfdClassMsg.C1;
				else return mlConfdClassMsg.C0;
			});*/
			currGrid.colAdd('ml_confd_class', gridColumn.ml_confd_class, 100, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == '4') return mlConfdClassMsg.C4;
				else if (value == '3') return mlConfdClassMsg.C3;
				else if (value == '2') return mlConfdClassMsg.C2;
				else if (value == '1') return mlConfdClassMsg.C1;
				else return mlConfdClassMsg.C0;
			});
			/*currGrid.colAdd('ml_confd_feedback_label', gridColumn.ml_confd_feedback, 110, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				value = currGrid.getValue(row, 'ml_confd_feedback');
				if (value == '1') return '<div class="feedbackInCorrect"></div>&nbsp;' + mlConfdClassMsg.C1;
				else if (value == '2') return '<div class="feedbackInCorrect"></div>&nbsp;' + mlConfdClassMsg.C2;
				else if (value == '3') return '<div class="feedbackInCorrect"></div>&nbsp;' + mlConfdClassMsg.C3;
				else if (value == '4') return '<div class="feedbackInCorrect"></div>&nbsp;' + mlConfdClassMsg.C4;
				else if (value == '0') return '<div class="feedbackCorrect"></div>&nbsp;' + mlConfdFeedbackMsg.F0;
				else if (value == '9') return '<div class="feedbackDefer"></div>&nbsp;' + mlConfdFeedbackMsg.F9;
				else return '-';
			});*/
			currGrid.colAdd('ml_confd_feedback', gridColumn.ml_confd_feedback, 110, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == '1') return '<div class="feedbackInCorrect"></div>&nbsp;' + mlConfdClassMsg.C1;
				else if (value == '2') return '<div class="feedbackInCorrect"></div>&nbsp;' + mlConfdClassMsg.C2;
				else if (value == '3') return '<div class="feedbackInCorrect"></div>&nbsp;' + mlConfdClassMsg.C3;
				else if (value == '4') return '<div class="feedbackInCorrect"></div>&nbsp;' + mlConfdClassMsg.C4;
				else if (value == '0') return '<div class="feedbackCorrect"></div>&nbsp;' + mlConfdFeedbackMsg.F0;
				else if (value == '9') return '<div class="feedbackDefer"></div>&nbsp;' + mlConfdFeedbackMsg.F9;
				else return '-';
			});
			currGrid.colAdd('ml_confd_prob', gridColumn.ml_confd_prob, 110, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				return probPercent(value);
			});
			}
			currGrid.colAdd('attachcnt', gridColumn.attachcnt, 35, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
				if (value == '0') return '';
				else return value.comma();
			});
			currGrid.colAdd('inside', gridColumn.inside, 55, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == 'N') return gridColumn.msgout;
				else if (value == 'Y') return gridColumn.msgin;
				else return '-';
			});

			currGrid.colAdd('direction_svc', gridColumn.direction_svc, 55, 'center', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if (value == 'I') return gridColumn.receive;
				else if (value == 'O') return gridColumn.send;
				else return '-';
			});
			currGrid.colAdd('svcNm', gridColumn.svcNm, 180, 'center', false, 'nomal');
			currGrid.colAdd('subject', gridColumn.subject, 410, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				var bodySize = currGrid.getValue(row, 'bodySizeStr');
				var rtnVal = '<a href="javascript:void(0);" onclick="javascript:viewer_open('+row+',\''+bodySize.substring(0,1)+'\');" class="subject_read'+currGrid.getValue(row, 'readYn')+'">'+value+'</a>&nbsp;<a href="javascript:void(0);" onclick="javascript:viewer_open('+row+',\''+bodySize.substring(0,1)+'\');" class="glyphicon glyphicon-new-window new-window"></a>';
				if( ($('#consentNo') != undefined && $('#consentNo').val() == '') || (isConsent( ) && currGrid.getValue(row, 'consentNo') == '') || !isDetailView() ) rtnVal = '<span>'+value+'</span>';
				var kwds = currGrid.getValue(row, 'kwds');
				rtnVal = highlightKeyword(rtnVal, kwds);
				rtnVal = highlightSearchStr(rtnVal, 'subject');
				return rtnVal;
			});
			currGrid.colAdd('ctimeFormat', gridColumn.ctimeFormat, 130, 'center', false, 'nomal');
			currGrid.colAdd('user', gridColumn.user, 120, 'center', false, 'link');
			currGrid.colAdd('businm', gridColumn.businm, 120, 'center', true, 'nomal');
			currGrid.colAdd('deptnm', gridColumn.deptnm, 120, 'center', false, 'nomal');
			currGrid.colAdd('jikgubnm', gridColumn.jikgubnm, 120, 'center', false, 'nomal');
			currGrid.colAdd('sender', gridColumn.sender, 130, 'left', false, 'link');
			currGrid.colAdd('allofus', gridColumn.allofus, 150, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				if( value == undefined || value.length == 0) return '';
				
				for( var i=0; i<value.length; i++){
					if(value[i] == 'IA') value[i] = allofusMsg.IA;
					else if(value[i] == 'ET') value[i] = allofusMsg.ET;
					else if(value[i] == 'IT') value[i] = allofusMsg.IT;
					else if(value[i] == 'EA') value[i] = allofusMsg.EA;
					else if(value[i] == 'PT') value[i] = allofusMsg.PT;
					else if(value[i] == 'PA') value[i] = allofusMsg.PA;
					else if(value[i] == 'SO') value[i] = allofusMsg.SO;
					else if(value[i] == 'SI') value[i] = allofusMsg.SI;
				}
				
				return value;
			});
			currGrid.colAdd('recvsStr', gridColumn.recvs, 220, 'left', false, 'link', function(row, cell, value, columnDef, dataContext) {
				return value;
			}, {sorter:sortUtil.inout});
			currGrid.colAdd('to', gridColumn.to, 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
				var innOutInfo = currGrid.getValue(row, 'toInOutInfo');
				if(value == undefined) value = '';
				return innOutInfo+value;
			});
			currGrid.colAdd('cc', gridColumn.cc, 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
				var innOutInfo = currGrid.getValue(row, 'ccInOutInfo');
				if(value == undefined) value = '';
				return innOutInfo+value;
			});
			currGrid.colAdd('bcc', gridColumn.bcc, 150, 'left', true, 'link', function(row, cell, value, columnDef, dataContext) {
				var innOutInfo = currGrid.getValue(row, 'bccInOutInfo');
				if(value == undefined) value = '';
				return innOutInfo+value;
			});
			currGrid.colAdd('srcip', gridColumn.srcip + ' IP', 100, 'left', false, 'nomal');
			currGrid.colAdd('dstip', gridColumn.dstip + ' IP', 100, 'left', false, 'nomal');
			currGrid.colAdd('attachname', gridColumn.attachname, 220, 'left', false, 'nomal', function(row, cell, value, columnDef, dataContext) {
				var rtnVal = arrayToString(value);
				var kwds = currGrid.getValue(row, 'kwds');
				return highlightKeyword(rtnVal, kwds);
			});
			currGrid.colAdd('sizeStr', gridColumn.sizeStr, 80, 'left', false, 'nomal');
			currGrid.colAdd('bodySizeStr', gridColumn.bodySizeStr, 80, 'left', false, 'nomal', null, {sortField:'body_size'});
			currGrid.colAdd('attachSizeStr', gridColumn.attachSizeStr, 80, 'left', false, 'nomal', null, {sortField:'attachSizeSort'});
			currGrid.colAdd('kwds', gridColumn.kwds, 120, 'left', false, 'nomal');
			currGrid.colAdd('pi_total', gridColumn.pi_total, 70, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
				if (value == '0') return '';
				else return value.comma();
			});
			if ( isOCR ) {
				currGrid.colAdd('ocr_attach_cnt', gridColumn.ocr, 70, 'center', false, 'link', function(row, cell, value, columnDef, dataContext) {
					if (value == '0' || value == '' || value == null || value == undefined ) return '';
					else return value.comma();
				});
			}
			
			currGrid.loadHeader(true);
			currGrid.initData('');
			
			currGrid.onContextMenu = function(row, col, e){
				return;
				
				e.preventDefault();
				if( currGrid.ColIndex('_checkbox_selector') == col || currGrid.ColIndex('NUM') == col){
					return;
				}

				$("#contextMenu")
				.data("row", row)
				.css("top", e.pageY)
				.css("left", e.pageX)
				.show();
				$("body").one("click", function () {
					$("#contextMenu").hide();
				});
				$(document).bind("mousedown", function(event){
					$("#contextMenu").hide();
					$(document).unbind("mousedown", this);
				});
			};
			currGrid.onClick = function() {
				var pid = $(this).get(0).id;
				var row = currGrid.Row;
				var msgid = currGrid.getValue(row, 'msgid');
				if (currGrid.Col == currGrid.ColIndex('attachcnt')) {
					if(currGrid.getValue(row, 'attachcnt') == '') return;
					fileInfoViewer( msgid );
				}else if (currGrid.Col == currGrid.ColIndex('user')) {
					if(currGrid.getValue(row, 'user') == '') return;
					userInfoViewer( msgid, 'user' );
				}else if (currGrid.Col == currGrid.ColIndex('sender')) {
					if(currGrid.getValue(row, 'sender') == '') return;
					userInfoViewer( msgid, 'sender' );
				}else if (currGrid.Col == currGrid.ColIndex('recvsStr')) {
					if(currGrid.getValue(row, 'recvs') == '') return;
					userInfoViewer( msgid, 'recvs');
				}else if (currGrid.Col == currGrid.ColIndex('to')) {
					if(currGrid.getValue(row, 'to') == '') return;
					userInfoViewer( msgid, 'to');
				}else if (currGrid.Col == currGrid.ColIndex('cc')) {
					if(currGrid.getValue(row, 'cc') == '') return;
					userInfoViewer( msgid, 'cc');
				}else if (currGrid.Col == currGrid.ColIndex('bcc')) {
					if(currGrid.getValue(row, 'bcc') == '') return;
					userInfoViewer( msgid, 'bcc');
				}else if(currGrid.Col == currGrid.ColIndex('pi_total')) {
					if(currGrid.getValue(row, 'pi_total') == '') return;
					regexpInfoViewer(msgid);
				}else if (currGrid.Col == currGrid.ColIndex('ocr_attach_cnt')) {
					ocrFileInfoViewer( msgid, currGrid.getValue(row, 'ocr_attach_cnt') );
				}
			};
		}
		function arrayToString(rtnVal) {
			var arrayString = "";
			if(rtnVal) {
				for(var i = 0; i < rtnVal.length; i++) {
					if( i == 0) arrayString += rtnVal[i];
					else arrayString += "," + rtnVal[i];
				}
			} else arrayString = "";
			
			return arrayString;
		}

		function regexpInfoViewer(msgid){
			var url    = contextRoot + '/ems/regexpInfoPop.do?msgId='+msgid;
			return fnOpenWindow(url, 'regexpInfoPop', 1100, 470, 'resize');
		}

		function userInfoViewer(msgid, type){
			var url    = contextRoot + '/ems/userInfoPop.do?msgId='+msgid+'&type='+type;
			return fnOpenWindow(url, type+'InfoPop', 1200, 450, 'resize');
		}

		function fileInfoViewer(msgid){
			var url    = contextRoot + '/ems/fileInfoPop.do?msgId='+msgid;
			return fnOpenWindow(url, 'fileInfoPop', 1015, 400, 'resize');
		}
		function ocrFileInfoViewer( msgid, ocr_attach_cnt ){
			if(ocr_attach_cnt == '') return;
			
			var url    = contextRoot +'/ems/fileInfoPop.do?msgId='+msgid;
			var pop = fnOpenWindow(url, 'ocrFileInfoPop', 1015, 400, 'resize');
		}
		
		function highlightKeyword (rtnVal, keyWords) {
			var rtnValue = '';
			try{
				var obj = $.parseHTML('<div>'+rtnVal+'</div>');
				for(var i = 0; i < keyWords.length; i++) {
					var keyWord = keyWords[i];
					$(obj).highlight(keyWord, 'K');
				}
				rtnValue = $(obj).html();
			}catch(e){
				rtnValue =  rtnVal;
				console.log("highlightKeyword Error..");
			}
			
			return rtnValue;
		}
		
		function highlightSearchStr(rtnVal, column){
			var rtnValue = '';
			try{
				var searchType = parent.$('#searchField').val();
				var searchStr = parent.$('#searchStrInput').val();

				if(column != "subject") {
					rtnVal = rtnVal.replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '\'');
				}
				
				if(searchStr == "") {
					return rtnVal;
				}
				
				var chk = false;
				
				if(searchType == "") {
					chk = true;
				} else if (searchType == "sender_str" || searchType == "sname"){
					if(column == "sender") chk = true;
				} else if (searchType == "recvs" || searchType == "recvs_name"){
					if(column == "recvs" || column == "to" || column == "cc" || column == "bcc") chk = true;
				} else if (searchType == "to tname"){
					if(column == "to" || column == "column") chk = true;
				} else if (searchType == "cc tname"){
					if(column == "cc" || column == "column") chk = true;
				} else if (searchType == "bcc tname"){
					if(column == "bcc" || column == "column") chk = true;
				} else if (searchType == "body"){
					if(column == "subject" ) chk = true;
				} else if (searchType == "attachname attachname_str"){
					if(column == "attachname" ) chk = true;
				} else {
					if(searchType == column) chk = true;
				}	
			
				var search = parent.$('#searchStrInput').val();
				if(chk) {
					var searchArray = [];
					
					search = search.trim();
					
					if(search.indexOf("\"") == 0 && search.charAt(search.length-1) == "\"" && nvl(search.match(/"/g)).length == 2) {
						searchArray[0] = search.substring(1, search.length-1);
					} else {
						search = search.replaceAll('\\|',' ');
						search = search.replaceAll("\\+", "").replaceAll("\\*", "").replaceAll("\\?", "");
						search = search.replaceAll("\"", "");
						searchArray = search.split(" ");
					}
					var obj = $.parseHTML('<div>'+rtnVal+'</div>');
					for(var i = 0; i < searchArray.length; i++) {
						var searchStr =  searchArray[i];
						if( searchStr == ' ' || searchStr == '') continue;
						$(obj).highlight(searchStr, 'S');
					}
					
					rtnValue =  $(obj).html();
				} else {
					rtnValue =  rtnVal;	
				}
				
			} catch(e){
				rtnValue =  rtnVal;
				console.log("highlightSearchStr Error..");
			}
			return rtnValue;
		}
		
		function setGridFeedback(value){
			var data = statGrid.getRowData(statGrid.Row);
			data.ml_confd_feedback = value;
			//statGrid.setValue(statGrid.Row, statGrid.ColIndex('ml_confd_feedback_label'), value);
			statGrid.setValue(statGrid.Row, statGrid.ColIndex('ml_confd_feedback'), value);
		}

		jQuery.fn.highlight = function(pat, type) {
			function innerHighlight(node, pat, type) {
				var skip = 0;
				if (node.nodeType == 3) {
					var pos = node.data.toUpperCase().indexOf(pat);
					if (pos >= 0) {
						var spannode = document.createElement('span');
						if ( type.indexOf('K') > -1) {
							spannode.style.backgroundColor = '#FFAD5B';
						}
						else {
							spannode.style.backgroundColor = '#13C7A3';
						}
						if ( type.indexOf('B') > -1 ) {
							if ( type.indexOf('K') > -1) {
								spannode.style.backgroundColor = '#ccc';
								spannode.style.color = '#000000';
								spannode.style.fontWeight = 'bold';
							} else {
								spannode.style.backgroundColor = '#eee';
								spannode.style.color = '#000000';
								spannode.style.fontWeight = 'bold';
							}
						}

						var sbit = node.splitText( pos );
						sbit.splitText( pat.length );
						spannode.nodeValue = sbit.data;
						var sbitclone = sbit.cloneNode(true);
						spannode.appendChild(sbitclone);
						sbit.parentNode.replaceChild(spannode, sbit);
						skip = 1;
					}
				} else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
					for ( var i = 0; i < node.childNodes.length; ++i) {
						i += innerHighlight(node.childNodes[i], pat, type);
					}
				}
				return skip;
			}
			return this.each(function() {
				innerHighlight(this, pat.toUpperCase(), type);
			});
		};

