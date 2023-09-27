var gsDayNamesKr = new Array( '일', '월', '화', '수', '목', '금', '토' );
var gsDayNamesEn = new Array( 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' );

function drawTimeTable(id, end_id){
	if(end_id == undefined) end_id = '';
	var header = '<table id="week_time_td'+end_id+'" class="week_time_td">';
	header += '<thead>';
	header += '<tr>';
	header += '	<td></td>';
	header += '	<td colspan="24" style="border: 1px solid #ccc; text-align: center; background-color: #ffffc5; font-weight: bold;">'+(blockRuleDay.msgAm == undefined ? '오전' : blockRuleDay.msgAm)+'</td>';
	header += '	<td colspan="24" style="border: 1px solid #ccc; text-align: center; background-color: #c1f3ff; font-weight: bold;">'+(blockRuleDay.msgPm == undefined ? '오후' : blockRuleDay.msgPm)+'</td>';
	header += '</tr>';
	header += '<tr>';
	header += '	<td class="week_name">&nbsp;</td>';
	for ( var i=0 ; i <= 23 ; i++ ) {
		if( i == 0 ) header += '<td colspan="2" style="text-align: center; border-left: 1px solid #ccc; border-right: 1px solid #bbb; border-bottom: 1px solid #ccc; background-color: #ffffe5;">'+i+'</td>';
		else if( i == 23 ) header += '<td colspan="2" style="text-align: center; border-right: 1px solid #ccc; background-color: #e5ffff; border-bottom: 1px solid #ccc;">'+i+'</td>';
		else if( i < 12 ) header += '<td colspan="2" style="text-align: center; border-right: 1px solid #bbb;background-color: #ffffe5; border-bottom: 1px solid #ccc;">'+i+'</td>';
		else if( i >= 12 ) header += '<td colspan="2" style="text-align: center; border-right: 1px solid #bbb;background-color: #e5ffff; border-bottom: 1px solid #ccc;">'+i+'</td>';
	}
	header += '</tr></thead>';

	var body = '<tbody id="time_body'+end_id+'">';
	var defaultNames=gsDayNamesKr;
	if( blockRuleDay.language == 'en') defaultNames=gsDayNamesEn;
	
	for ( var i=0 ; i < defaultNames.length ; i++ ) {
		body += '<tr><td class="week_name">'+defaultNames[i]+'</td>';
		for ( var j=0 ; j < 48 ; j++ ) {
			if( j == 0 ) body += '<td class="uncheck" style="border-left: 1px solid #ccc;">&nbsp;</td>';
			else if( j == 47 ) body += '<td class="uncheck" style="border-right: 1px solid #ccc;">&nbsp;</td>';
			else if( j == 23 ) body += '<td class="uncheck" style="border-right: 2px solid #bbb;">&nbsp;</td>';
			else if( j % 2 == 1 && j < 47)  body += '<td class="uncheck" style="border-right: 1px solid #bbb;">&nbsp;</td>';
			else body += '<td class="uncheck">&nbsp;</td>';
		}
		body += '<tr>';
	}
	body += '</tbody></table>';
	document.getElementById(id).innerHTML = header + body;
	preventReturn(end_id);
	if(end_id == '')appendEvent(end_id);
}

function preventReturn(end_id) {
	if(end_id == undefined) end_id = '';
	var week_time_td = document.getElementById('week_time_td'+end_id);
	week_time_td.oncontextmenu = new Function( "return false" );
	week_time_td.ondragstart = new Function( "return false" );
	week_time_td.onselectstart = new Function( "return false" );
	$('.week_time_td').on("contextmenu", function(event){ return false; });
	$('.week_time_td').on("selectstart", function(event){ return false; });
	$('.week_time_td').on("dragstart", function(event){ return false; });
}

function appendEvent(end_id) {
	if(end_id == undefined) end_id = '';
	var time_body = document.getElementById('time_body'+end_id);
	for ( var j=0 ; j < time_body.childNodes.length ; j++ ) {
		var timeTr = time_body.childNodes[j];
		for ( var i=0 ; i < timeTr.childNodes.length ; i++ ) {
			if ( timeTr.childNodes[i].nodeName == "TD" ) {
				timeTr.childNodes[i].setAttribute( "value", (i-1) );
				timeTr.childNodes[i].onmousedown = mouseDown;
				timeTr.childNodes[i].onmouseup = mouseUp;
				timeTr.childNodes[i].onmouseover = mouseMove;
			}
		}
	}
}

// 전체선택(Y), 선택 해제(N)
function allTimeSelect(flag) {
	var time_body = document.getElementById('time_body');
	for ( var j=0 ; j < time_body.childNodes.length ; j++ )
	{
		var timeTr = time_body.childNodes[j];
		for ( var i=0 ; i < timeTr.childNodes.length ; i++ ) {
			var tdObj = timeTr.childNodes[i];
			if (tdObj.className == 'week_name') continue;
			if ( tdObj.nodeName == "TD" ) {
				if ( flag == 'Y' ) {
					tdObj.className = checkedColor;
				} else {
					tdObj.className = 'uncheck';
				}
			}
		}
	}
}

//마우스 클릭
document.onmouseup = function() {
	mouseDownFlag = false;
};

// Mouse Down - 마우스 클릭 시 좌표, 색상 보관
var mouseDownFlag = false;
var mouseDownObj = null;
var mouseUpObj = null;
var mouseDownColor = null;
var checkedColor = "check"; //활성화 된 항목의 색상
var firstObj = null;
function mouseDown(event) {
	try {
		var target = this;
		mouseDownFlag = true;
		mouseDownObj = target;
		firstObj = target;
		mouseDownColor = mouseDownObj.className;
		if (mouseDownObj.className == 'week_name') {
			return;
		}
		if (mouseDownObj.className == "uncheck") {
			mouseDownObj.className = "check";
		} else {
			mouseDownObj.className = "uncheck";
		}
	} catch (e) {
		alert(e)
	}
}

function getTarget(event){
	return (event.currentTarget) ? event.currentTarget : event.srcElement;
}
var mouseMoveObj = null;
function mouseMove(event) {
	try {
		if (mouseDownFlag && firstObj.className != 'week_name' ) {
			var target = this;
			mouseMoveObj = target;
			if (mouseMoveObj.className == 'week_name'){
				return;
			}
			
			var multi = false;
			if (mouseDownObj.parentNode != mouseMoveObj.parentNode){
				multi = true;
			}

			var down = Number(mouseDownObj.getAttribute("value"));
			var up = Number(mouseMoveObj.getAttribute("value"));
			var timeTr = mouseMoveObj.parentNode;
			var timeUpTr = mouseMoveObj.parentNode;
			for ( var i = 0; i < timeTr.childNodes.length; i++) {
				if (timeTr.childNodes[i].nodeName == "TD") {
					var tdObj = timeTr.childNodes[i];
					var tdNum = Number(tdObj.getAttribute("value"));
					if (isBetween(down, up, tdNum)) {
						var tdUpObj = timeUpTr.childNodes[i];
						if (mouseDownColor == "uncheck") {
							tdObj.className = 'check';
							if (multi) {
								tdUpObj.className = 'check';
							}
						} else {
							tdObj.className = "uncheck";
							if (multi){
								tdUpObj.className = "uncheck";
							}
						}
					}
				}
			}
		}
	} catch (e) {

	}
}

// 마우스 업 이벤트 - 색상 변경처리
function mouseUp(event) {
	try {
		mouseDownFlag = false;
		var target = event.target || event.srcElement;
		mouseUpObj = target;
		if( firstObj.className == 'week_name' || mouseUpObj.className == 'week_name' ) return;
		
		var multi = false;
		if (mouseDownObj.parentNode != mouseUpObj.parentNode) {
			multi = true;
		}

		var down = Number(mouseDownObj.getAttribute("value"));
		var up = Number(mouseUpObj.getAttribute("value"));
		var timeTr = mouseDownObj.parentNode;
		var timeUpTr = mouseUpObj.parentNode;
		for ( var i = 0; i < timeTr.childNodes.length; i++) {
			if (timeTr.childNodes[i].nodeName == "TD") {
				var tdObj = timeTr.childNodes[i];
				var tdNum = Number(tdObj.getAttribute("value"));
				if (isBetween(down, up, tdNum)) {
					var tdUpObj = timeUpTr.childNodes[i];
					if (mouseDownColor == "uncheck") {
						tdObj.className = checkedColor;
						if (multi){
							tdUpObj.className = checkedColor;
						}
					} else {
						tdObj.className = "uncheck";
						if (multi){
							tdUpObj.className = "uncheck";
						}
					}
				}
			}
		}
		mouseDownColor = null;
	} catch (e) {

	}
}
// 드래그 상태에서 포함되는 TD인지 여부
function isBetween(down, up, tdNum) {
	if (down <= tdNum && up >= tdNum)
		return true;
	else if (up <= tdNum && down >= tdNum)
		return true;
	else
		return false;
}

// 선택된 항목 값 반환
function submitTime() {
	var result = new Array();
	var time_body = document.getElementById('time_body');
	for ( var j = 0; j < time_body.childNodes.length; j++) {
		var timeTr = time_body.childNodes[j];
		for ( var i = 0; i < timeTr.childNodes.length; i++) {
			var tdObj = timeTr.childNodes[i];
			if (tdObj.className == 'week_name') continue;
			if (tdObj.nodeName == "TD") {
				if (tdObj.className == checkedColor)
					result.push(1);
				else
					result.push(0);
			}
		}
	}
	return result.join("");
}

//선택된 항목 값 색상 변경
function setTimeLine(timeStr, id) {
	if( id == undefined ) id = 'time_body';
	var len=0;
	var time_body = document.getElementById(id);
	for ( var j=0 ; j < time_body.childNodes.length ; j++ )
	{
		var timeTr = time_body.childNodes[j];
		for ( var i=0 ; i < timeTr.childNodes.length ; i++ ) {
			var tdObj = timeTr.childNodes[i];
			if (tdObj.className == 'week_name') continue;
			if ( tdObj.nodeName == "TD" ) {
				var onoff = timeStr.substring(len,len+1);
				if ( onoff == '1' ) {
					tdObj.className = checkedColor;
				} else {
					tdObj.className = 'uncheck';
				}
				len++;
			}
		}
	}
}
