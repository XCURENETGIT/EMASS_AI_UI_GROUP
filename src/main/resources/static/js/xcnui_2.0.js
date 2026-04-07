/*
 * xcnui v2.0 | (c) 2015 Xcurenet.com | xcurenet/license
 *
 * import javascript
 * jquery v1.11.0
 */
var errorCallBackMsg1 = xcnuiJS.errorCallbackMsg1;
var errorCallBackMsg2 = xcnuiJS.errorCallbackMsg2;
var errorCallBackMsg3 = xcnuiJS.errorCallbackMsg3;
var ui = {
	init : function() {
		try {
			sessionVerification();
		} catch (e) {
		}
	},
	get : function(param) {
		this.init();

		var url = param.url;
		var successCallBack = param.success;
		var errorCallBack = param.error;
		var completeCallBack = param.complete;

		var asyncFlag = param.asyncFlag;
		if (asyncFlag == undefined)
			asyncFlag = true;

		delete param.url;
		delete param.success;
		delete param.error;
		delete param.complete;
		delete param.asyncFlag;

		var result = true;
		$.ajax({
			async		: asyncFlag,
			type		: 'POST',
			dataType	: 'json',
			data		: param,
			cache		: false,
			url			: contextRoot + '/' + url,
			beforeSend	: function(request) {
				request.setRequestHeader("x-requested-with", 'com.xcurenet.lars');
			},
			success		: function(options, success, xhr) {
				var statusCode = xhr.status;
				if (xhr.status == 200) {
					var json = JSON.parse(xhr.responseText);
					if (!eval(json.success)) {
						result = errorCallBack(-1, json.message, json.data, json.total);
					} else {
						result = successCallBack(json.data, json.total);
					}
				} else {
					if (xhr.status == 401) {
						top.location.href = contextRoot + '/login.do';
					} else if(xhr.status == 203){
						var json = JSON.parse(xhr.responseText);
						result = errorCallBack(-1, errorCallBackMsg3, json.data);
					} else {
						var json = JSON.parse(xhr.responseText);
						result = errorCallBack(xhr.status, errorCallBackMsg1, json.data);
					}
				}
			},
			error		: function(xhr, textStatus, response) {
				if (xhr.status == 401) {
					top.location.href = contextRoot + '/login.do';
				} else if(xhr.status == 203){
					ui.alert(errorCallBackMsg3);
					top.location.href = contextRoot + '/login.do';
				} else {
					if(xhr.status==0) return;
					if(xhr.status != 500) result = errorCallBack(xhr.status, errorCallBackMsg2);
					else result = errorCallBack(xhr.status, errorCallBackMsg1);
				}
			},
			complete	: function() {
				if (completeCallBack != undefined)
					return completeCallBack();
			}
		});
		return result;
	},
	postJson : function(param) {
		this.init();

		var url = param.url;
		var successCallBack = param.success;
		var errorCallBack = param.error;
		var completeCallBack = param.complete;

		var asyncFlag = param.asyncFlag;
		if (asyncFlag == undefined)
			asyncFlag = true;

		delete param.url;
		delete param.success;
		delete param.error;
		delete param.complete;
		delete param.asyncFlag;

		var result = true;
		$.ajax({
			async		: asyncFlag,
			type		: 'POST',
			dataType	: 'json',
			data		: param,
			cache		: false,
			url			: contextRoot + '/' + url,
			beforeSend	: function(request) {
				request.setRequestHeader("x-requested-with", 'com.xcurenet.lars');
			},
			success		: function(options, success, xhr) {
				var statusCode = xhr.status;
				if (xhr.status == 200) {
					var json = JSON.parse(xhr.responseText);
					if (!eval(json.success)) {
						result = errorCallBack(-1, json.message, json.data, json.total);
					} else {
						result = successCallBack(json.data, json.total);
					}
				} else {
					if (xhr.status == 401) {
						top.location.href = contextRoot + '/login.do';
					} else if(xhr.status == 203){
						var json = JSON.parse(xhr.responseText);
						result = errorCallBack(xhr.status, errorCallBackMsg3, json.data);
					}
					else {
						var json = JSON.parse(xhr.responseText);
						result = errorCallBack(xhr.status, errorCallBackMsg1, json.data);
					}
				}
			},
			error		: function(xhr, textStatus, response) {
				if (xhr.status == 401) {
					top.location.href = contextRoot + '/login.do';
				}  else if(xhr.status == 203){
					ui.alert(errorCallBackMsg3);
					top.location.href = contextRoot + '/login.do';
				} else {
					if(xhr.status==0) return;
					if(xhr.status != 500) result = errorCallBack(xhr.status, errorCallBackMsg2);
					else result = errorCallBack(xhr.status, errorCallBackMsg1);
				}
			},
			complete	: function() {
				if (completeCallBack != undefined)
					return completeCallBack();
			}
		});
		return result;
	},
	post : function(param) {
		this.init();

		var url = param.url;
		var successCallBack = param.success;
		var errorCallBack = param.error;
		var completeCallBack = param.complete;

		var asyncFlag = param.asyncFlag;
		if (asyncFlag == undefined)
			asyncFlag = true;

		delete param.url;
		delete param.success;
		delete param.error;
		delete param.complete;
		delete param.asyncFlag;

		var result = true;
		$.ajax({
			async		: asyncFlag,
			type		: 'POST',
			cache		: false,
			// dataType : 'json',
			data		: param.data,
			url			: contextRoot + '/' + url,
			beforeSend	: function(request) {
				request.setRequestHeader("x-requested-with", 'com.xcurenet.lars');
			},
			success		: function(options, success, xhr) {
				if (xhr.status == 200) {
					var json = JSON.parse(xhr.responseText);
					if (!eval(json.success)) {
						result = errorCallBack(-1, json.message, json.data, json.total);
					} else {
						result = successCallBack(json.data, json.total);
					}
				} else {
					if (xhr.status == 401) {
						top.location.href = contextRoot + '/login.do';
					} else if(xhr.status == 203){
						var json = JSON.parse(xhr.responseText);
						result = errorCallBack(xhr.status, errorCallBackMsg3, json.data);
					} else {
						var json = JSON.parse(xhr.responseText);
						result = errorCallBack(errorCallBackMsg1, xhr.responseText, json.data);
					}
				}
			},
			error		: function(xhr, textStatus, response) {
				if (xhr.status == 401) {
					top.location.href = contextRoot + '/login.do';
				}  else if(xhr.status == 203){
					ui.alert(errorCallBackMsg3);
					top.location.href = contextRoot + '/login.do';
				} else {
					if(xhr.status==0) return;
					if(xhr.status != 500) result = errorCallBack(errorCallBackMsg2, xhr.statusText);
					else result = errorCallBack(errorCallBackMsg1, xhr.statusText);
				}
			},
			complete	: function() {
				if (completeCallBack != undefined)
					return completeCallBack();
			}
		});
		return result;
	},
	on : function(target) {
		if ($('#loading_div_' + target).get().length > 0)
			$('#loading_div_' + target).remove(); // 한번 지우고 새로 처리 해야 한다.
		if ($('#loading_div_' + target).get().length == 0) {
			var top = $('#' + target).position().top;
			var left = $('#' + target).position().left;
			var width = $('#' + target).width();
			var height = $('#' + target).height();
			var offset = $('#' + target).offset();
			$('#' + target).append(
					'<div class="loading_div_grid" id="loading_div_' + target + '"><img id="loading_img_' + target + '" src="' + contextRoot + '/img/loading/Loading.gif"/></div>');
			$('#loading_div_' + target).css({
				"position" : "absolute",
				"top" : top + "px",
				"left" : left + "px",
				"width" : (width - 3) + "px",
				"height" : (height - 3) + "px",
				"background-color" : "#F0F0F0",
				"opacity" : "0.3",
				"z-index" : "9998",
				"text-align" : "center"
			});
			$('#loading_img_' + target).css({
				"margin-top" : ((height / 2) - 46) + "px",
				"width" : "69px"
			});
		} else {
			$('#loading_div_' + target).show();
		}
	},
	onCustom : function(target, top, left) {
		if ($('#loading_div_' + target).get().length > 0)
			$('#loading_div_' + target).remove(); // 한번 지우고 새로 처리 해야 한다.
		if ($('#loading_div_' + target).get().length == 0) {
			var width = $('#' + target).width();
			var height = $('#' + target).height();
			$('#' + target).append(
					'<div class="loading_div_grid" id="loading_div_' + target + '"><img id="loading_img_' + target + '" src="' + contextRoot + '/img/loading/Loading.gif"/></div>');
			$('#loading_div_' + target).css({
				"position" : "absolute",
				"top" : top + "px",
				"left" : left + "px",
				"right" : "0px",
				"bottom" : "0px",
				"z-index" : "9998",
				"text-align" : "center",
				"background-color" : "#F0F0F0",
				"opacity" : "0.3"
			});
			$('#loading_img_' + target).css({
				"margin-top" : ((height / 2) - 46) + "px",
				"width" : "69px"
			});
		} else {
			$('#loading_div_' + target).show();
		}
	},
	onBody : function(targetId, top, left) {
		if(top == undefined) top = 0;
		if(left == undefined) left = 0;
		var target = 'body_all';
		if(targetId != undefined) target = targetId;
		if ($('#loading_div_' + target).get().length > 0)
			$('#loading_div_' + target).remove(); // 한번 지우고 새로 처리 해야 한다.
		if ($('#loading_div_' + target).get().length == 0) {
			$('body').append('<div class="loading_div_grid" id="loading_div_' + target + '"><img id="loading_img_' + target + '" src="' + contextRoot + '/img/loading/Loading.gif"/></div>');
			$('#loading_div_' + target).css({
				"position" : "absolute",
				"width" : "100%",
				"height" : "100%",
				"top" : top+"%",
				"left" : "0px",
				"right" : "0px",
				"bottom" : "0px",
				"z-index" : "9998",
				"text-align" : "center",
				"background-color" : "#F0F0F0",
				"opacity" : "0.3"
			});
			var width = $('#loading_div_' + target).width();
			var height = $('#loading_div_' + target).height();
			$('#loading_img_' + target).css({
				"margin-top" : ((height / 2) - 46) + "px",
				"width" : "69px",
				"margin-left" : left + "%"
			});
		} else {
			$('#loading_div_' + target).show();
		}
	},
	off : function(target) {
		if ($('#loading_div_' + target).get().length > 0) {
			$('#loading_div_' + target).hide();
		} else {
			$('.loading_div_grid').hide();
		}
	},
	mobileOn : function() {
		$.mobile.loading('show', {
			html : "<span><img src=contextRoot+'/resources/css/images/ajax-loader.gif' /></span>"
		});
	},
	mobileOff : function() {
		$.mobile.loading('hide');
	},
	alertMsg : function(msg, callBack, timeOut) {
		var dialogInstance = BootstrapDialog.alert({
			id : 'bootstrap_alert',
			title : 'EMASS AI',
			message: msg,
			closable: true,
			draggable: true,
			buttonLabel : xcnuiJS.confirm,
			callback: function(result) {
				if (callBack != null && callBack != undefined){
					setTimeout(function(){
						callBack();
					}, 300);
				}
			}
		});

		if(timeOut!=undefined && timeOut != '') {
			var title = dialogInstance.getTitle();
			var t = (timeOut/1000)-1;
			var interval = setInterval(function(){
				dialogInstance.setTitle(title + '  <div class="auto_close">Auto Close ' + (t--).comma() + ' \'s</div>' );
			},1000);

			setTimeout(function(){
				clearInterval(interval);
				dialogInstance.close();
			}, timeOut);
		}
		setTimeout(function(){
			$('#bootstrap_alert:visible').find('button').focus();
		}, 500);
		return;

		//alert(msg);
		//return;
		var dialogSize = BootstrapDialog.SIZE_SMALL;
		if (size == 'nomal')
			dialogSize = BootstrapDialog.SIZE_NORMAL;
		else if (size == 'small')
			dialogSize = BootstrapDialog.SIZE_SMALL;
		else if (size == 'wide')
			dialogSize = BootstrapDialog.SIZE_WIDE;
		else if (size == 'large')
			dialogSize = BootstrapDialog.SIZE_LARGE;

		var dialogInstance = BootstrapDialog.show({
			size : dialogSize,
			title : (title == undefined || title == '') ? '[Venus/EMASS LT] System Message' : title,
			message : msg,
			draggable : true,
			buttons : [ {
				label : xcnuiJS.confirm,
				hotkey : 32,
				action : function(dialogItself) {
					dialogItself.close();
					if(callBack!=undefined && callBack != '') {
						//callBack();
					}
				}
			} ],
			callBack : function(){
				alert();
			}
		});

		if(timeOut!=undefined && timeOut != '') {
			setTimeout(function(){
				dialogInstance.close();
			}, timeOut);
		}
	},
	confirmMsg : function(msg, title, size, callBack) {
		var dialogSize = BootstrapDialog.SIZE_SMALL;
		if (size == 'nomal')
			dialogSize = BootstrapDialog.SIZE_NORMAL;
		else if (size == 'small')
			dialogSize = BootstrapDialog.SIZE_SMALL;
		else if (size == 'wide')
			dialogSize = BootstrapDialog.SIZE_WIDE;
		else if (size == 'large')
			dialogSize = BootstrapDialog.SIZE_LARGE;

		BootstrapDialog.confirm({
			//size : dialogSize,
			id : 'bootstrap_confirm',
			title : (title == undefined || title == '') ? 'EMASS AI' : title,
			message : msg,
			draggable : true,
			btnOKLabel : xcnuiJS.confirm,
			btnOKHotkey : 32,
			btnCancelLabel : xcnuiJS.cancel,
			btnCancelHotkey : 27,
			callback : callBack
		});
	},
	page : function(pageId, targetGrid, total, rtnMethod) {
		var pageSizeNo = 10; // 화면에 표시할 페이지 수
		var listSize = targetGrid.pageSize;
		var pageCount = targetGrid.loadingPage + 1;
		var lastPage = Math.ceil(total / listSize); // 전체 페이지 수
		var screenPageNo = Math.ceil(listSize / pageSizeNo); // 전체 스크린(페이지) 수
		// , 1,2,3
		var currentScreenPageNo = Math.ceil(pageCount / pageSizeNo); // 사용자가
		// 현재
		// 보고있는
		// 스크린(페이지)
		// 넘버
		var startPageNum = (currentScreenPageNo * pageSizeNo - pageSizeNo) + 1; // 페이지
		// 시작
		// 넘버
		var endPageNum = startPageNum + pageSizeNo - 1; // 페이지 끝 넘버
		if (endPageNum > lastPage)
			endPageNum = lastPage;
		var result = '';

		if (lastPage == 0)
			return result;
		if (screenPageNo == 0)
			return;

		if (pageCount > pageSizeNo)
			result = '<li><a href="#" onclick="' + rtnMethod + '(' + (endPageNum - pageSizeNo) + ')">' + xcnuiJS.prev + '</a></li>';
		else
			result = '<li class="disabled"><a href="#">' + xcnuiJS.prev + '</a></li>';

		for (var i = startPageNum; i <= endPageNum; i++) {
			result += '<li><a href="#" onclick="' + rtnMethod + '(' + i + ')">' + (i) + '</a></li>';
		}
		if (startPageNum + pageSizeNo <= lastPage)
			result += '<li><a href="#" onclick="' + rtnMethod + '(' + (startPageNum + pageSizeNo) + ')">'+ xcnuiJS.next +'</a></li>';
		else
			result += '<li class="disabled"><a href="#">' + xcnuiJS.next + '</a></li>';

		$('#' + pageId).html(result);
		$('#' + pageId + '>li').each(function() {
			if ($(this).find('a').html() == pageCount) {
				$(this).addClass('active');
			} else
				$(this).removeClass('active');
		});
	},
	hover : function ( target, seconds, mouseOver, mouseOut ) {
		var tipTimer = null;
		function clearTipTimer() {
		    if ( tipTimer ) {
		    	clearTimeout(tipTimer);
		        tipTimer = null;
		    }
		}
		$(target).hover( function(e){
			clearTipTimer( );
			var obj = this;
			var event = e;
			tipTimer = setTimeout(function() {
				tipTimer = null;
				mouseOver( obj, event );
			}, seconds );
		},
		function(e) {
			clearTipTimer( );
			mouseOut(this, e);
		});
	}
}
//includes 가 익스플로러에 적용되지 않아 추가로 넣은 로직
if (![].includes) {
	  Array.prototype.includes = function(searchElement /*, fromIndex*/ ) {
	    'use strict';
	    var O = Object(this);
	    var len = parseInt(O.length) || 0;
	    if (len === 0) {
	      return false;
	    }
	    var n = parseInt(arguments[1]) || 0;
	    var k;
	    if (n >= 0) {
	      k = n;
	    } else {
	      k = len + n;
	      if (k < 0) {k = 0;}
	    }
	    var currentElement;
	    while (k < len) {
	      currentElement = O[k];
	      if (searchElement === currentElement ||
	         (searchElement !== searchElement && currentElement !== currentElement)) {
	        return true;
	      }
	      k++;
	    }
	    return false;
	  };
	}

function alert(msg) {
	ui.alertMsg(msg);
}


var sessionVerificationTime = null;
function sessionVerification() {
	return;
	if (sessionVerificationTime != null)
	clearTimeout(sessionVerificationTime);
	sessionVerificationTime = window.setTimeout(function() {
		ui.get({
			url : 'sessionVerification.xcn',
			adminId : window.__session_adminId,
			adminName : window.__session_adminName,
			success : function(data, total) {
			},
			error : function(status, message) {
			},
			complete : function() {
				sessionVerification();
			}
		});
	}, (sessionTimeoutSecond + 3) * 1000);
}

/**
 * validation check.
 *
 * @param id
 * @param msg
 * @returns {Boolean}
 */
function validation(id, msg) {
	var val = $('#' + id).val();
	if (val.trim() == '') {
		alert(msg);
		$('#' + id).focus();
		return false;
	} else
		return true;
}

/**
 * solr 검색시 특수문자 체크
 *
 * @param userid
 * @returns {Boolean}
 */
function specialCharCheck(str) {
	var sc = '\\:[]\"\/';
	for (var i = 0; i < sc.length; i++) {
		if (str.indexOf(sc[i]) > -1) {
			alert(xcnuiJS.notUseChar + ' [ ' + sc[i] + ' ]');
			return false;
		}
	}
	return true;
}

/**
 * CC 인증위한 인증정보재사용 방지
 */
function getServerTime() {
	var result={};
	$.ajax(
	{
		async		: false,
		type		: "POST",
		url			: contextRoot + '/' + 'getServerTime.xcn',
		success		: function( data, status, xhr ) {
			result = data;
		}
	});
	return result;
}

/**
 * 페이지 하단으로 이동
 */
function goBottom() {
	$('body, html').animate({
		scrollTop : $(document).height()
	}, 1000);
}

function ui_debug(errmsg, url, linenum) {
	ui.console('error', errmsg);
	return true;
}

function gridDefaultOption() {
	var options = {
		enableCellNavigation : true,
		enableColumnReorder : true,
		editable : true,
		rowHeight : 25
	};
	return options;
}
function formatter(row, cell, value, columnDef, dataContext) {
	return value;
}
function checkGridData(data) {
	if (data.length == 0) {
		data[0] = {
			id : xcnuiJS.noData
		};
		data.getItemMetadata = function() {
			return {
				"columns" : {
					0 : {
						"colspan" : "*"
					}
				}
			};
		};
	}
	return data;
}
function initGridData(data, str) {
	if (data.length == 0) {
		data[0] = {
			no : str
		};
		data.getItemMetadata = function() {
			return {
				"columns" : {
					0 : {
						"colspan" : "*"
					}
				}
			};
		};
	} else {
		data.getItemMetadata = function() {
			return {
				"columns" : {
					0 : {
						"colspan" : "*"
					}
				}
			};
		};
	}

	return data;
}

function getNameValues(name) {
	var obj = document.getElementsByName(name);
	var result = new Array();
	if (obj != null) {
		for (var i = 0; i < obj.length; i++) {
			result.push(obj[i].value);
		}
	} else
		return null;
	return result.join(",");
}

String.prototype.isNumber = function() {
	var val = this;
	if (isNaN(val))
		return false;
	return true;
};

String.prototype.isOrEquals = function() {
	var x = this;
	for (var i = 0; i < arguments.length; i++) {
		if (arguments[i] instanceof Array) {
			for (var j = 0; j < arguments[i].length; j++) {
				if (x == arguments[i][j])
					return true;
			}
		} else {
			if (x == arguments[i])
				return true;
		}
	}
	return false;
};
Number.prototype.isOrEquals = function() {
	var x = this;
	for (var i = 0; i < arguments.length; i++) {
		if (x == arguments[i])
			return true;
	}
	return false;
};

/**
 * JSON Array 에서 특정 키에 해당하는 Value를 리턴한다. (예:회사 코드를 주었을때 회사 명칭을 리턴)
 *
 * @param search_code 찾고자 하는 코드
 * @param key_label JSON Object에서 키 비교할 라벨
 * @param value_label 특정 키에 해당하는 값을 찾았을 경우 리턴 받을 JSON Object 라벨
 * @returns code
 */
Array.prototype.search = function(search_code, key_label, value_label) {
	for ( var i in this) {
		if (this[i][key_label] == search_code)
			return this[i][value_label];
	}
	return null;
};

Array.prototype.removeAt = function(index) {
	this.splice(index, 1);
};
Array.prototype.unique = function() {
	var a = [];
	for (var i=0, l=this.length; i<l; i++)
		if (a.indexOf(this[i]) === -1) a.push(this[i]);
	return a;
}

/**
 * String format Code ex: 'The {0} is dead. Don\'t code {0}. Code {1} that is open source!'.format('ASP', 'PHP');
 *
 * @returns {String}
 */
String.prototype.format = function() {
	var formatted = this;
	if (arguments.length == 0) {
		for (var i = 0; i < 100; i++) {
			var regexp = new RegExp('\\{' + i + '\\}', 'gi');
			formatted = formatted.replace(regexp, '');
		}
	}
	for (var i = 0; i < arguments.length; i++) {
		var regexp = new RegExp('\\{' + i + '\\}', 'gi');
		formatted = formatted.replace(regexp, arguments[i]);
	}
	return formatted;
};

/**
 * load
 *
 * @param totalLen
 * @param strReplace
 * @return
 */
String.prototype.LPad = function(totalLen, strReplace) {
	var strAdd = "";
	var diffLen = totalLen - this.length; // 최대크기에서 원본 문자열의 크기를 뺀 후 저장
	for (var i = 0; i < diffLen; ++i) {
		strAdd += strReplace; // 대체 문자열을 원본 문자열 앞에 추가하여 저장
	}
	return strAdd + this; // 대체 문자열로 채운 문자열과 원본 문자열을 반환
};

/**
 * load
 *
 * @param totalLen
 * @param strReplace
 * @return
 */
Number.prototype.LPad = function(totalLen, strReplace) {
	return String(this).LPad(totalLen, strReplace);
};

String.prototype.fReplaceWord = function(pFindWord, pReplaceWord) {
	var vTempArray;
	var vReturnString = "";
	vTempArray = this.split(pFindWord);
	for (var i = 0; i < vTempArray.length - 1; i++) {
		vReturnString += vTempArray[i] + pReplaceWord;
	}
	vReturnString += vTempArray[vTempArray.length - 1];
	return vReturnString;
};

String.prototype.html = function() {
	return this.replaceAll('<', '&lt;').replaceAll('>', '&gt;');
};

/**
 * 문자열 변경
 *
 *
 * @param {Object} pFindWord
 * @param {Object} pReplaceWord
 */
String.prototype.replaceAll = function(oStr, rStr) {
	if (rStr == undefined)
		rStr = '';
	var regexp = new RegExp(oStr, 'ig');
	return this.replace(regexp, rStr);
};
String.prototype.ltrim = function() {
	var re = /\s*((\S+\s*)*)/;
	return this.replace(re, "$1");
};
String.prototype.rtrim = function() {
	var re = /((\s*\S+)*)\s*/;
	return this.replace(re, "$1");
};
String.prototype.rtrim = function() {
	var re = /((\s*\S+)*)\s*/;
	return this.replace(re, "$1");
};
String.prototype.lrtrim = function() {
	return this.ltrim().rtrim();
};

String.prototype.trim = function() {
	return this.replace(/(^\s*)|(\s*$)/gi, "");
};
/**
 * 문자열 공백 제거(전부)
 */
String.prototype.trimAll = function() {
	var result = "";
	for (var i = 0; i < this.length; i++) {
		if (this.charAt(i) != " ")
			result += this.charAt(i);
	}
	return result;
};

String.prototype.endsWith = function(suffix) {
	return this.indexOf(suffix, this.length - suffix.length) !== -1;
};

String.prototype.comma = function() {
	x = this.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}
	return x1 + x2;
};
Number.prototype.comma = function() {
	x = String(this).split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}
	return x1 + x2;
};
function nvl(obj, defaultVal) {
	if (obj == null || obj == undefined || obj == '' || obj == 'null') {
		if (defaultVal != undefined)
			return defaultVal;
		else
			return '';
	} else
		return obj;
}
function nvn(obj) {
	if (obj == null || obj == undefined)
		return 0;
	else
		return obj;
}

function addOption(objName, key, value, selected) {
	var cocdObj = ui.get(objName);
	var oOption = document.createElement("OPTION");
	oOption.text = value;
	oOption.value = key;
	oOption.selected = selected;
	cocdObj.add(oOption);
}

/**
 * 페이지 네비게이션 ( 파라미터에 정수로 보내줘야함 )
 *
 * @param total - 전체 건수
 * @param pageCount - 현재 페이지 수
 * @param rtnMethod - 조회 메소드
 * @returns {String}
 */
function getPage(total, pageCount, rtnMethod) {
	var str = "";
	var pageSizeNo = 5; // 화면에 표시할 페이지 수
	var lastPage = Math.ceil(total / listSize); // 전체 페이지 수
	var screenPageNo = Math.ceil(listSize / pageSizeNo); // 전체 스크린(페이지) 수 ,
	// 1,2,3
	var currentScreenPageNo = Math.ceil(pageCount / pageSizeNo); // 사용자가 현재
	// 보고있는 스크린(페이지) 넘버
	var startPageNum = (currentScreenPageNo * pageSizeNo - pageSizeNo) + 1; // 페이지
	// 시작 넘버
	var endPageNum = startPageNum + pageSizeNo - 1; // 페이지 끝 넘버
	if (endPageNum > lastPage)
		endPageNum = lastPage;
	if (lastPage == 0) {
		return '';
	}
	if (screenPageNo == 0)
		return;

	if (pageCount > pageSizeNo)
		str += '<a href="#" class="pre" onclick="' + rtnMethod + '(' + (endPageNum - pageSizeNo) + ')"><img src="../ext/img/btn_pg2_l.gif" alt="Prev" width="13" height="14"></a>';
	else
		str += '<a href="#" class="pre"><img src="../ext/img/btn_pg2_l.gif" alt="Prev" width="13" height="14"></a>';
	for (var i = startPageNum; i <= endPageNum; i++) {
		if (i == pageCount)
			str += '<strong>' + i + '</strong>\n';
		else {
			if (i == startPageNum)
				str += '<a href="#" class="frst" onclick="' + rtnMethod + '(' + i + ')">' + i + '</a>\n';
			else
				str += '<a href="#" onclick="' + rtnMethod + '(' + i + ')">' + i + '</a>\n';
		}
	}
	if (startPageNum + pageSizeNo < lastPage)
		str += '<a href="#" class="next" onclick="' + rtnMethod + '(' + (startPageNum + pageSizeNo) + ')"><img src="../ext/img/btn_pg2_r.gif" alt="Next" width="13" height="14"></a>';
	else
		str += '<a href="#" class="next"><img src="../ext/img/btn_pg2_r.gif" alt="Next" width="13" height="14"></a>';

	return str;
}

/**
 * 페이지 네비게이션 ( 파라미터에 정수로 보내줘야함 )
 *
 * @param total - 전체 건수
 * @param pageCount - 현재 페이지 수
 * @param rtnMethod - 조회 메소드
 * @returns {String}
 */
function getPage2(total, pageCount, listSize, rtnMethod) {
	var str = "";
	var pageSizeNo = 5; // 화면에 표시할 페이지 수
	var lastPage = Math.ceil(total / listSize); // 전체 페이지 수
	var screenPageNo = Math.ceil(listSize / pageSizeNo); // 전체 스크린(페이지) 수 ,
	var currentScreenPageNo = Math.ceil(pageCount / pageSizeNo); // 사용자가 현재
	var startPageNum = (currentScreenPageNo * pageSizeNo - pageSizeNo) + 1; // 페이지
	var endPageNum = startPageNum + pageSizeNo - 1; // 페이지 끝 넘버
	if (endPageNum > lastPage)
		endPageNum = lastPage;

	if (lastPage == 0) {
		return '';
	}
	if (screenPageNo == 0)
		return;

	if (pageCount > pageSizeNo)
		str += '<a href="#" onclick="' + rtnMethod + '(' + (endPageNum - pageSizeNo) + ')" class="direction"><span>&lsaquo;</span> ' + xcnuiJS.prev + '</a>';
	else
		str += '<a href="#" class="direction" style="cursor:default"><span>&lsaquo;</span> ' + xcnuiJS.prev + '</a>';

	for (var i = startPageNum; i <= endPageNum; i++) {
		if (i == pageCount)
			str += '<strong>' + i + '</strong>\n';
		else {
			if (i == startPageNum)
				str += '<a href="#" onclick="' + rtnMethod + '(' + i + ')">' + i + '</a>\n';
			else
				str += '<a href="#" onclick="' + rtnMethod + '(' + i + ')">' + i + '</a>\n';
		}
	}
	if (startPageNum + pageSizeNo <= lastPage)
		str += '<a href="#" onclick="' + rtnMethod + '(' + (startPageNum + pageSizeNo) + ')" class="direction">' + xcnuiJS.next + ' <span>&rsaquo;</span></a>';
	else
		str += '<a href="#" class="direction" style="cursor:default">' + xcnuiJS.next + ' <span>&rsaquo;</span></a>';

	return str;
}

/**
 * 파일 사이즈(long) 값을 용량 단위로 변환한다.
 *
 * @param bytes
 * @returns {String}
 */
function convertFileSize(bytes) {
	var thresh = 1024;
	if (bytes < thresh)
		return bytes + 'B';
	var units = [ 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB' ];
	var u = -1;
	do {
		bytes /= thresh;
		++u;
	} while (bytes >= thresh);
	return bytes.toFixed(1) + '' + units[u];
};

function convertFileSizeByKBps(bytes) {
	var thresh = 1024;
	if (bytes < thresh)
		return bytes + 'KB';
	var units = [ 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB' ];
	var u = -1;
	do {
		bytes /= thresh;
		++u;
	} while (bytes >= thresh);
	return bytes.toFixed(1) + '' + units[u];
};

function changeForecastExt(fileName, fileExt) {
	var dot = fileName.lastIndexOf('.');
	if (dot == -1)
		dot = fileName.length;
	if (fileExt != 'unknown')
		return fileName.substring(0, dot) + '.' + fileExt; // 파일 예상확장자로 반환
	if (dot == fileName.length)
		return fileName + '.txt'; // 파일 예상확장자와, 실제 파일의 확장자가 없다면 txt로 반환
	return fileName; // 실제 파일의 확장자로 반환
}

/**
 * 숫자 콤마 표시
 *
 * @param nStr
 * @returns
 */
function addCommas(nStr) {
	nStr += '';
	x = nStr.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}
	return x1 + x2;
}

/**
 * 라디오 버튼 값
 *
 * @param name
 * @returns
 */
function getRadioValue(name) {
	if ($('input[name=' + name + ']:radio:checked').length > 0) {
		return $('input[name=' + name + ']:radio:checked').val();
	} else {
		return 0;
	}
}

/**
 * id, stat를 parameter로 받으며 stat를 true로 받을 경우 toggle상태 확인 후 display:none 해제 stat를 false로 받을 경우 toggle상태 확인 후 display:none 설정 stat가 undefined의 경우 toggle상태 확인 후 반대로 설정
 */
function checkToggle(id, stat) {
	if (stat == undefined) {
		if ($('#' + id).is($('#' + id).show()))
			$('#' + id).toggle('blind', {
				percent : 0
			}, 0);
		else
			$('#' + id).toggle('blind', {
				percent : 0
			}, 0);
	} else {
		if (stat) {
			if (!$('#' + id).is($('#' + id).show()))
				$('#' + id).toggle('blind', {
					percent : 0
				}, 0);
		} else {
			if ($('#' + id).is($('#' + id).show()))
				$('#' + id).toggle('blind', {
					percent : 0
				}, 0);
		}
	}
}

/**
 * 팝업 윈도우 OPEN
 *
 * @param fileName
 * @param windowName
 * @param theWidth
 * @param theHeight
 * @param etcParam
 * @return
 */
function fnOpenWindow(fileName, windowName, theWidth, theHeight, etcParam) {
	if (etcParam == "fix")
		etcParam = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0";
	else if (etcParam == "resize")
		etcParam = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1";
	else if (etcParam == "scroll")
		etcParam = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1";
	else if (etcParam == "scrollfix")
		etcParam = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0";
	else if (etcParam == "menubar")
		etcParam = "toolbar=0,location=0,directories=0,status=0,menubar=1,scrollbars=1,resizable=1";
	else if (etcParam == "all")
		etcParam = "toolbar=1,location=1,directories=0,status=1,menubar=1,scrollbars=1,resizable=1";
	else if (etcParam == "fullscreen")
		etcParam = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,channelmode=yes,type=fullWindow,top=0,left=0";

	var winHeight = document.body.clientHeight; // 현재창의 높이
	var winWidth = document.body.clientWidth; // 현재창의 너비
	var winX = window.screenX || window.screenLeft || 0;// 현재창의 x좌표
	var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표
	var popX = winX + (winWidth - theWidth) / 2;
	var popY = winY + (winHeight - theHeight) / 2;

	var top = (screen.availHeight / 2) - (theHeight / 2);
	var left = (screen.availWidth / 2) - (theWidth / 2);
	var sz = ",top=" + top + ",left=" + left;
	sz = '';

	objNewWin = window.open(fileName, windowName, etcParam + ",width=" + theWidth + ",height=" + theHeight + sz);
	try {
		objNewWin.focus();
	} catch (e) {}
	try {
		top.__windows.push(objNewWin);
	} catch (e) {}
	try {
		opener.__windows.push(objNewWin);
	} catch (e) {}
	try {
		parent.__windows.push(objNewWin);
	} catch (e) {}
	try {
		opener.parent.__windows.push(objNewWin);
	} catch (e) {}
	return objNewWin;
}

window.__windows = [];
function closeAllPopup() {
	for (var i = 0; i < __windows.length; i++) {
		try {
			if (__windows[i] && !__windows[i].closed) {
				__windows[i].close();
			}
		} catch (e) {
		}
	}
}

function viewMenu(info) {
	var de = document.documentElement;
	var b = document.body;
	var scroll_X = document.all ? (!de.scrollLeft ? b.scrollLeft : de.scrollLeft) : (window.pageXOffset ? window.pageXOffset : window.scrollX);
	var scroll_Y = document.all ? (!de.scrollTop ? b.scrollTop : de.scrollTop) : (window.pageYOffset ? window.pageYOffset : window.scrollY);
	var pointX = window.event.clientX + scroll_X;
	var pointY = window.event.clientY + scroll_Y;
	$('#menu_div').css('top', pointY);
	$('#menu_div').css('left', pointX);
	$('#menu_div').show('slow');

}

function menuClose(nodeId) {
	$('#' + nodeId).hide('fast');
}
function hiddenMenuForce() {
	menuClose('menu_div');
}

function hiddenMenu(e) {
	var evt = e ? e : event;
	if (evt.srcElement && isMenu(evt.srcElement, 'menu_click'))
		return;
	else if (evt.target && isMenu(evt.target, 'menu_click'))
		return;

	var result = false;
	if (evt.srcElement)
		result = isMenu(evt.srcElement, 'menu_div');
	else if (evt.target)
		result = isMenu(evt.target, 'menu_div');

	if (!result)
		menuClose('menu_div');
}
function isMenu(srcElement, nodeId) {
	if (srcElement.parentNode == null)
		return false;
	else if (srcElement.parentNode.id != null && srcElement.parentNode.id == nodeId)
		return true;
	else
		return isMenu(srcElement.parentNode, nodeId);
}

function openAddTarget() {
	menuClose('menu_div');
	$("#addTarget").dialog({
		bgiframe : true,
		width : 550,
		height : 380,
		modal : true,
		draggable : false,
		resizable : false,
		show : "blind",
		open : function(event, ui) {
			// drawChart( );
		}
	});
}

function closeTargetPage() {
	$('#addTarget').dialog('close');
}

/**
 * 해당하는 키에 쿠키를 반환한다.
 *
 * @param cKey
 * @return
 */
function getCookie(cKey) {
	var allcookies = document.cookie;
	var cookies = allcookies.split(";");
	for (var i = 0; i < cookies.length; i++) {
		var keyValues = cookies[i].split("=");
		if (keyValues[0].replace(' ', '') == cKey)
			return unescape(keyValues[1]);
	}
	return "";
}
/**
 * Set Cookie 쿠키를 등록한다
 *
 * @param cKey
 * @param cValue
 * @param expireDate
 * @return
 */
function setCookie(cKey, cValue, expireDate) {
	var today = new Date();
	today.setDate(today.getDate() + parseInt(expireDate));

	document.cookie = cKey + '=' + escape(cValue) + '; path=/; expires=' + today.toGMTString() + ';';
}
jQuery.browser = {};
jQuery.browser.mozilla = /mozilla/.test(navigator.userAgent.toLowerCase()) && !/webkit/.test(navigator.userAgent.toLowerCase());
jQuery.browser.webkit = /webkit/.test(navigator.userAgent.toLowerCase());
jQuery.browser.opera = /opera/.test(navigator.userAgent.toLowerCase());
jQuery.browser.msie = navigator.appName == 'Microsoft Internet Explorer'
		|| ((navigator.appName == 'Netscape') && (new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})").exec(navigator.userAgent) != null));
jQuery.browser.chrome = /chrome/.test(navigator.userAgent.toLowerCase());
var IEvresion = 0;

if ($.browser.msie) {
	var ua = window.navigator.userAgent;
	var msie = ua.indexOf("MSIE ");
	IEvresion = parseInt(ua.substring(msie + 5, ua.indexOf(".", msie)));
}

function checkDate(date) {
	return !/Invalid|NaN/.test(getCheckDate(date));
}
function getCheckDate(time) {
	var year = Number(time.substring(0, 4));
	var month = Number(time.substring(5, 7)) - 1;
	var day = Number(time.substring(8, 10));
	return new Date(year, month, day);
}

function getDateFormat(time) {
	return time.substring(0, 4) + "-" + time.substring(4, 6) + "-" + time.substring(6, 8) + " " + time.substring(8, 10) + ":" + time.substring(10, 12) + ":" + time.substring(12, 14);
}

function getDateFormatSize(time) {
	var result = time;
	switch(time.length) {
	case 4 :
		result = time + xcnuiJS.year;
		break;
	case 6 :
		result = time.substring(0, 4) + "-" + time.substring(4, 6);
		break;
	case 8 :
		result = time.substring(0, 4) + "-" + time.substring(4, 6) + "-" + time.substring(6, 8);
		break;
	case 10 :
		result = time.substring(0, 4) + "-" + time.substring(4, 6) + "-" + time.substring(6, 8) + " " + time.substring(8, 10) + xcnuiJS.hour;
		break;
	case 12 :
		result = time.substring(0, 4) + "-" + time.substring(4, 6) + "-" + time.substring(6, 8) + " " + time.substring(8, 10) + ":" + time.substring(10, 12);
		break;
	case 14 :
		result = time.substring(0, 4) + "-" + time.substring(4, 6) + "-" + time.substring(6, 8) + " " + time.substring(8, 10) + ":" + time.substring(10, 12) + ":" + time.substring(12, 14);
		break;

	}
	return result;
}
/**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
 * IP 유효성 체크 ---------------------------------------------
 * 정상적인 IP인지 체크 정상
 * 예1) 222.107.254.169
 * 정상 예2) 222.7.54.69
 * 비정상 예1) 022.107.254.169
 * 비정상 예2) 222107.254.169
 * 비정상 예3) 222.107.254.1699
 * 비정상 예4) 222.107.254.
 * 비정상 예5) 222.107.254
 * 비정상 예6) 222.107.254.169:80
 *************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************/
/*
 * function checkIP( ip ) { var ipObj = ip.split("."); if ( ipObj.length == 4 ) { for ( var i=0 ; i < ipObj.length ; i++ ) { if ( Number( ipObj[i] ) > 255 ) return false; } } else return false; return true; }
 */
/*
function checkIP(ip) {
	if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(ip))
		return true;
	return false;
}
*/
/**
 * 시작, 끝 IP 유효성 검사
 *
 */
/*
function checkIpRange(sip, eip) {
	if (inet_aton(sip) > inet_aton(eip))
		return false;
	return true;
}
*/
function checkIpSize(sip, eip, size) {
	var chk_sip = '';
	var chk_eip = '';
	var sips = sip.split('.');
	var eips = eip.split('.');
	for (var i = 0; i < size; i++) {
		chk_sip += sips[i] + '.';
		chk_eip += eips[i] + '.';
	}
	if (chk_sip == chk_eip)
		return true;
	else
		false;
}
function inet_aton(dot) {
	var d = dot.split('.');
	return ((((((+d[0]) * 256) + (+d[1])) * 256) + (+d[2])) * 256) + (+d[3]);
}
function inet_ntoa(num) {
	var d = num % 256;
	for (var i = 3; i > 0; i--) {
		num = Math.floor(num / 256);
		d = num % 256 + '.' + d;
	}
	return d;
}

/**
 * IP v4, v6 Valid Check.
 */
function ipValidCheck(ip) {
	if (/^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$|^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$|^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$/
			.test(ip)) {
		return true;
	}
	var perlipv6regex = "^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$";
	var regex = "/" + perlipv6regex + "/";
	if (/^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$/
			.test(ip)) {
		return true;
	}
	return false;
}

function idCheck( id ){
	// id 유효성을 검증하는 정규식입니다 .
	var reg_exp = /^[a-zA-Z][a-zA-Z0-9.]{3,11}$/;
	var match = reg_exp.exec( id );

	if (match == null || id.length <  5 || id.length > 12) {
		return false;
	}
	return true;
}

/**
 * DHTML email validation script
 */
function emailCheck(str) {
	var message = "[" + str + "]\n" + xcnuiJS.notEmail;
	str = str.replaceAll(" ", "");
	// if
	// (/^[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+)*@[0-9a-zA-Z-]+(\.)+([0-9a-zA-Z-]+)(\.0-9a-zA-Z-)*$/.test(
	// str ) == false ) { alert(message); return false; }
	if (/^([0-9a-zA-Z_.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,6}$/.test(str) == false) {
		alert(message);
		return false;
	}
	return true;
}

function emailLengthCheck(str) {
	var message = "[" + str + "]\n" + xcnuiJS.emailMax;
	str = str.replaceAll(" ", "");
	if (str.length > 50) {
		alert(message);
		return false;
	}
	return true;
}

/**
 * 숫자 콤마 입력
 */
function numberFormat(obj) {
	obj.value = numberToComma(obj.value);
}
function formatToNumber(obj) {
	obj.value = obj.value.replaceAll(",", "");
}

function numberToComma(strValue) {
	var regExp0 = new RegExp(",", "g");
	var regExp1 = new RegExp("(-?[0-9]+)([0-9]{3})");
	var regExp2 = new RegExp("[\.]([0-9]+)[\,]([0-9]+)");
	strValue = strValue.replace(regExp0, "");
	while (regExp1.test(strValue))
		strValue = strValue.replace(regExp1, "$1,$2");
	while (regExp2.test(strValue))
		strValue = strValue.replace(regExp2, ".$1$2");
	return strValue;
}

/**
 * 숫자만 입력 가능 IP 영역에서 사용
 *
 * @param kv
 * @return
 */
function inputIpNumbercheck(kv, nextFocs) {
	var keypress = String.fromCharCode(kv.keyCode);
	try {
		if (keypress == ".") {
			if (ui.get(nextFocs)) {
				ui.get(nextFocs).focus();
				ui.get(nextFocs).select();
			}
		}
	} catch (e) {
	}

	// if ( kv.srcElement.value.length == 2 )
	// {kv.srcElement.nextSibling.nextSibling.focus(
	// );kv.srcElement.nextSibling.nextSibling.select( );} //세자리 입력 시 자동으로 다음
	// 포커스 진행 다음번에..

	var isStr = /^[0-9]$/;
	if (!isStr.test(keypress)) {
		event.returnValue = false;
	}
}

function checkMAC(teststr) {
	var regex = /^([0-9a-f]{2}([:]|$)){6}$|([0-9a-f]{4}([.]|$)){3}$/i;
	if (regex.test(teststr)) {
		return true;
	}
	return false;
}

// /////////////////////////통계 공통 사용 함수//////////////////////////////
function stringSplit(strData, strIndex) {
	var stringList = new Array();
	while (strData.indexOf(strIndex) != -1) {
		stringList[stringList.length] = strData.substring(0, strData.indexOf(strIndex));
		strData = strData.substring(strData.indexOf(strIndex) + (strIndex.length), strData.length);
	}
	stringList[stringList.length] = strData;
	return stringList;
}

/**
 * Checkbox Checked Value
 *
 * @param {Object} obj
 */
function getSelectedCheckBox(name) {
	var obj = document.getElementsByName(name);
	var result = new Array();
	if (obj != null) {
		for (var i = 0; i < obj.length; i++) {
			if (obj[i].checked) {
				result.push(obj[i].value);
			}
		}
	} else
		return null;

	return result.join("|");
}

/**
 * 파일명 규칙 처리 \\/:*?"<>| 금칙어는 파일명으로 할당할 수 없다. 변경 시켜버림
 */
function fileNameReplace(fileName) {
	var text_title = fileName;
	var deny_pattern = /[\\/:*?"<>|#$%!^]/gi;
	return text_title.replace(deny_pattern, "");
}

/**
 * EMASS LT 데이터 본문 조회 팝업 호출
 *
 * @param msgid
 * @param ctime
 * @param searchkey
 */
function openContentBody(msgid, ctime, searchkey, openType) {
	if (openType == undefined)
		openType = '';
	return fnOpenWindow(contextRoot + "/search/ContentBody.jsp?msgid=" + msgid + "&ctime=" + ctime + "&searchkey=" + searchkey + "&menuId=M_002&openType=" + openType, "popupMsgWin", "1000", "800",
			"fullscreen");
}

/**
 * 파일의 확장자가 이미지인지?
 *
 * @param extension
 */
var images = [ 'jpg', 'jpeg', 'gif', 'png', 'bmp', 'tif', 'tiff' ];
function isImage(fileName) {
	var ext = fileName.split('.').pop().toLowerCase();
	for (var i = 0; i < images.length; i++) {
		if (images[i] == ext)
			return true;
	}
	return false;
}

/**
 * XAS - 메일 이미지 체크
 *
 * @param extension
 */
var images_mail = [ 'jpg', 'jpeg', 'png', 'bmp', 'tif', 'tiff' ];
function isMailImage(fileName) {
	var ext = fileName.split('.').pop().toLowerCase();
	for ( var i in images_mail) {
		if (images_mail[i] == ext)
			return true;
	}
	return false;
}

/**
 * 이미지 로딩 콜백 처리.
 */
var onImgLoad = function(selector, callback) {
	$(selector).each(function() {
		if (this.complete || /* for IE 10- */$(this).height() > 0) {
			callback.apply(this);
		} else {
			$(this).on('load', function() {
				callback.apply(this);
			});
		}
	});
};

function rePosition(x, y, w, h) {
	var width = $(document).width();
	var height = $(document).height();
	if ((x + w) > width)
		x = width - w;
	if ((y + h) > height)
		y = height - h;
	return {
		x : x,
		y : y
	};
}

var current_hover = false;
function preview(x, y, msgid, ctime, fileid) {
	current_hover = true;
	$('#prev_layer').hide();
	ctime = ctime.replaceAll('-', '').replaceAll(':', '').replaceAll(' ', '');
	ui.call({
		path : 'com.search.MessageInfo',
		mode : 'getFileInfo',
		msgId : msgid,
		ctime : ctime
	}, function(data, flag) {
		if (data.length > 0) {
			var fileId = data[0]['ATTACHID'];
			if (data.length > 1)
				fileId = '';
			if (fileid != undefined)
				fileId = fileid;
			ui.call({
				path : 'com.search.MessageInfo',
				mode : 'getFileSummary',
				msgId : msgid,
				fileId : fileId,
				ctime : ctime
			}, function(data, flag) {
				var img = isImage(data[0]['ATTACHNAME']);
				if (img && data.length == 1) { // 이미지
					// 미리보기...
					$('#prev_layer').width('300px');
					$('#prev_layer').height('200px');
					$('#prev_layer').css('left', rePosition(x, y, 300, 350).x + 10);
					$('#prev_layer').css('top', rePosition(x, y, 300, 350).y + 10);
					$('#prev_layer').html('<img id="prev_image" class="preview_image" src="' + contextRoot + '/attach?msgId=' + msgid + '&fileId=' + fileId + '&ctime=' + ctime + '">');
					$('#prev_layer').show();
				} else { // 첨부파일 미리보기
					var str = '';
					if (data.length == 1) {
						str = data[0]['SUMMARY'];
					} else if (data.length > 1) {
						for (var i = 0; i < data.length; i++) {
							str += (i + 1) + '. ' + data[i]['ATTACHNAME'] + '\n';
						}
					}
					if (str == '') {
						str = xcnuiJS.previewing;
						$('#prev_layer').width('250px');
						$('#prev_layer').height('40px');
						$('#prev_layer').css('left', rePosition(x, y, 250, 30).x + 10);
						$('#prev_layer').css('top', rePosition(x, y, 250, 30).y + 10);
					} else {
						$('#prev_layer').width('400px');
						$('#prev_layer').height('250px');
						$('#prev_layer').css('left', rePosition(x, y, 400, 250).x + 10);
						$('#prev_layer').css('top', rePosition(x, y, 400, 250).y + 10);
					}
					$('#prev_layer').html('<textarea class="preview_box">' + str + '</textarea>');
					if (current_hover)
						$('#prev_layer').show();
					else
						$('#prev_layer').hide();
				}
			});
		} else { // 데이터 없을 경우
			$('#prev_layer').css('left', rePosition(x, y, 250, 13).x + 10);
			$('#prev_layer').css('top', rePosition(x, y, 250, 13).y + 10);
			$('#prev_layer').width('250px');
			$('#prev_layer').height('13px');
			$('#prev_layer').html('<textarea class="preview_box">' + xcnuiJS.notFileInfo + '</textarea>');
			$('#prev_layer').show();
		}
	});
}

$.fn.serializeAll = function() {
	var data = $(this).serializeArray();
	$(':disabled[name]', this).each(function() {
		var type = $(this).attr('type');
		if(type=='radio'){
			if($(this).prop("checked")) data.push({ name : this.name, value : $(this).val() });
		} else data.push({ name : this.name, value : $(this).val() });

	});
	return data;
};

$.fn.enter = function(fn) {
	return this.each(function() {
		$(this).bind('enterPress', fn);
		$(this).keyup(function(e) {
			if (e.keyCode == 13) {
				$(this).trigger("enterPress");
			}
		});
	});
};

$.fn.required = function() {
	if ($(this).val().trimAll() == '') {
		$(this).message($(this).attr('title') + ' is required.');
		return false;
	} else {
		return true;
	}
};

$.fn.message = function(msg) {
	var obj = $(this);
	ui.alertMsg(msg, function(){
		setTimeout(function(){
			$(obj).focus().select();
		}, 200);
	});
	return $(this).focus().select();
};

$.fn.setPreview = function(opt) {
	"use strict"
	var defaultOpt = {
		inputFile : $(this),
		img : null,
		w : 200,
		h : 200
	};
	$.extend(defaultOpt, opt);

	var previewImage = function() {
		if (!defaultOpt.inputFile || !defaultOpt.img)
			return;
		var inputFile = defaultOpt.inputFile.get(0);
		var img = defaultOpt.img.get(0);
		// FileReader
		if (window.FileReader) {
			// image 파일만
			if (!inputFile.files[0].type.match(/image\//))
				return;
			// preview
			try {
				var reader = new FileReader();
				reader.onload = function(e) {
					$(defaultOpt.img).attr('src', e.target.result);
					$(defaultOpt.img).css('height', defaultOpt.h + 'px');
					$(defaultOpt.img).css('width', defaultOpt.w + 'px');
					$(defaultOpt.img).show();
				}
				reader.readAsDataURL(inputFile.files[0]);
			} catch (e) {
				// exception...
			}
			// img.filters (MSIE)
		} else if (img.filters) {
			inputFile.select();
			inputFile.blur();
			var imgSrc = document.selection.createRange().text;
			img.style.width = defaultOpt.w + 'px';
			img.style.height = defaultOpt.h + 'px';
			img.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enable='true',sizingMethod='scale',src=\"" + imgSrc + "\")";
			img.style.display = '';
		}
	};
	// onchange
	$(this).change(function() {
		var img = [ 'jpg', 'jpeq', 'bmp', 'png', 'tif', 'gif' ];
		var img_val = $(this).val().toLowerCase();
		var imgx = img_val.match(/\.([^\.]+)$/);
		if (img_val.indexOf('.') == -1 || !imgx[1].isOrEquals(img)) {
			alert('Available extensions(' + img.join('/') + ')');
			$(this).parent().html('<input type="file" name="image_btn" id="image_btn" />');
			img_val = '../ext/img/kr/content/add_user.png';
			defaultOpt.img.attr('src', img_val);
			reEventPreview();
			return;
		}
		previewImage();
	});
};
function reEventPreview() {
	var opt = {
		img : $('#img_preview'),
		w : 100,
		h : 120
	};
	$('#image_btn').setPreview(opt);
}

/**
 * 인사정보 관련 Phoenix 업로드
 *
 * KEYWORD, STOPWORDS, USER, FILTER, IPRANGE, IMAGE, DEVICE, WORKDAY
 *
 * @param type
 */
function makeInfo(type) {
	ui.call({
		path : 'com.common.info.MakeInfo_exec',
		mode : 'makeInfo',
		type : type
	}, function(data, flag) {
	});
}
/**
 * 룰 관련 사항 변경 시 호출
 */
function addRuleApply(type) {
	if (type == undefined)
		type = 'R';
	ui.call({
		path : 'com.setup.Rule',
		mode : 'addRuleApply',
		apply_type : type
	}, function(data, flag) {
	});
}

/**
 * 입력 최대값 체크
 */
String.prototype.bytes = function() {
	var str = this;
	var l = 0;
	for (var i = 0; i < str.length; i++) {
		l += (str.charCodeAt(i) > 128) ? 3 : 1;
	}
	return l;
};

function Host() {
	var Dns = location.href.split("//");
	Dns = Dns[0] + "//" + Dns[1].substr(0, Dns[1].indexOf("/"));
	return Dns;
}

var notification = {
	max : 4,
	cnt : 0,
	isPlay : false,
	play : function() {
		if (this.isPlay) {
			this.stop();
		}
		this.isPlay = true;
		this.loop();
	},
	stop : function() {
		this.cnt = 100;
	},
	loop : function() {
		var obj = this;
		$('.notification').fadeToggle('slow', 'swing', function() {
			if (obj.cnt > obj.max) {
				$('.notification').hide();
				obj.isPlay = false;
				obj.cnt = 0;
				return;
			}
			obj.cnt++;
			obj.loop();
		});
	}
};

function getChoice_lea_code_C() {
	grid_choice_lea_code_C.on();
	ui.mysql({
		queryId : 'getLea',
		lea_text : $('#txt_search_choice_lea_code_C').val()
	}, function(data, flag) {
		grid_choice_lea_code_C.setData(data);
		grid_choice_lea_code_C.off();
	});
}

function xcn_scroll(elem) {
	var docViewTop = $(window).scrollTop();
	var docViewBottom = docViewTop + $(window).height();

	var elemTop = $(elem).offset().top;
	var elemBottom = elemTop + $(elem).height();

	return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));
}

function getTimeFormat(num) {
	var hour = Math.floor(num / 3600);
	var min = Math.floor(num % 3600 / 60);
	var sec = Math.floor(num % 3600 % 60);
	hour = hour < 10 ? '0' + hour : hour;
	min = min < 10 ? '0' + min : min;
	sec = sec < 10 ? '0' + sec : sec;
	if (hour > 0)
		return hour + ':' + min + ':' + sec;
	else
		return min + ':' + sec;
}

function idIndicator(id){
    return id.fReplaceWord('.', '\\.');
}

function getBrowserType() {
	var agt = navigator.userAgent.toLowerCase();
	if (agt.indexOf("chrome") != -1)
		return 'Chrome';
	if (agt.indexOf("opera") != -1)
		return 'Opera';
	if (agt.indexOf("staroffice") != -1)
		return 'Star Office';
	if (agt.indexOf("webtv") != -1)
		return 'WebTV';
	if (agt.indexOf("beonex") != -1)
		return 'Beonex';
	if (agt.indexOf("chimera") != -1)
		return 'Chimera';
	if (agt.indexOf("netpositive") != -1)
		return 'NetPositive';
	if (agt.indexOf("phoenix") != -1)
		return 'Phoenix';
	if (agt.indexOf("firefox") != -1)
		return 'Firefox';
	if (agt.indexOf("safari") != -1)
		return 'Safari';
	if (agt.indexOf("skipstone") != -1)
		return 'SkipStone';
	if (agt.indexOf("msie") != -1)
		return 'Internet Explorer';
	if (agt.indexOf("netscape") != -1)
		return 'Netscape';
	if (agt.indexOf("mozilla/5.0") != -1)
		return 'Mozilla';
	else
		return null;
}
function getInternetExplorerVersion() {
	var word;
	var version = "N/A";
	var agent = navigator.userAgent.toLowerCase();
	var name = navigator.appName;
	if (name == "Microsoft Internet Explorer")
		word = "msie ";
	else {
		if (agent.search("trident") > -1)
			word = "trident/.*rv:";
		else if (agent.search("edge/") > -1)
			word = "edge/";
	}
	var reg = new RegExp(word + "([0-9]{1,})(\\.{0,}[0-9]{0,1})");
	if (reg.exec(agent) != null)
		version = RegExp.$1 + RegExp.$2;
	return version;
}

$.ui.dialog.prototype.options.show = {
	effect : 'slide',
	duration : 100
};
$.ui.dialog.prototype.options.hide = {
	effect : 'slide',
	duration : 100
};
$.ui.dialog.prototype.options.autoReposition = true;
(function($) {
	$.ui.dialog.prototype.fullscreen = false;
	var old = $.ui.dialog.prototype._createTitlebar;
	$.ui.dialog.prototype._createTitlebar = function() {
		old.call(this);
		var oldHeight = this.options.height, oldWidth = this.options.width;
		this.fullScreen = $("<span class='full_screen'></span>").appendTo(this.uiDialogTitlebar);
		this._on(this.fullScreen, {
			click : function(event) {
				event.preventDefault ? event.preventDefault() : (event.returnValue = false);
				if (this.fullscreen) {
					this._setOptions({
						height : oldHeight,
						width : oldWidth
					});
				} else {
					$('body').css('overflow-x', 'hidden')
					this._setOptions({
						height : window.innerHeight,
						width : window.innerWidth
					});
				}
				this.fullscreen = !this.fullscreen;
				this._position("center");
			}
		});
		this.closeBtn = $("<span class='close_btn'></span>").appendTo(this.uiDialogTitlebar);
		this._on(this.closeBtn, {
			click : function(event) {
				this.close();
			}
		});
		this._on('.ui-dialog-title', {
			dblclick : function(event) {
				this.fullScreen.click();
			}
		});
		this._on('.vjs-tech', {
			dblclick : function(event) {
				this.fullScreen.click();
			}
		});
	};
	$.ui.dialog.prototype._originalOpen = $.ui.dialog.prototype.open;
	$.ui.dialog.prototype.open = function() {
		$('body').css('overflow-x', 'hidden');
		$.ui.dialog.prototype._originalOpen.apply(this, arguments);
	};

	$.ui.dialog.prototype._originalClose = $.ui.dialog.prototype.close;
	$.ui.dialog.prototype.close = function() {
		$('body').css('overflow-x', 'auto');
		$.ui.dialog.prototype._originalClose.apply(this, arguments);
	};
})(jQuery);

(function(jQuery) {
    jQuery.fn.forceNumeric = function (options) {
        var opts = jQuery.extend({}, jQuery.fn.forceNumeric.defaults, options);

        return this.each(function () {
            var o = jQuery.meta ? jQuery.extend({}, opts, $this.data()) : opts;
            $(this).keydown(function (e) {
                var key = e.which || e.keyCode;

                if (!e.shiftKey && !e.altKey && !e.ctrlKey &&
                // numbers
                    key >= 48 && key <= 57 ||
                // Numeric keypad
                    key >= 96 && key <= 105 ||
                // Backspace and Tab and Enter
                   key == 8 || key == 9 || key == 13 ||
                // Home and End
                   key == 35 || key == 36 ||
                // left and right arrows
                   key == 37 || key == 39 ||
                // Del and Ins
                   key == 46 || key == 45) {
                   var v=$(this).val();

                   return true;
                } else if (e.ctrlKey){
                    //ctrl-c       ctrl-v       ctrl-x
                    if (key==67 || key==86  || key==90)
                        return true;
                }
                return false;
            });

            $(this).blur(function (e) {
                var v=jQuery.trim($(this).val());
                if (v=='') {
                    return;
                }

                if(o.fixDecimals!=-1) {
                    var num = parseFloat(v);

					if(isNaN(num)) {
						$(this).val("");
						return;
					}
                    var numSix =  num.toFixed(o.fixDecimals);
                    $(this).val(numSix);
                }

            });


        });
        jQuery.fn.forceNumeric.defaults = {
                fixDecimals : -1
            };
    };
})(jQuery);