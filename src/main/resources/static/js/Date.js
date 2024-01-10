/**
* 날짜관련 자바스크립트 공통함수
*
* 분단위 이하(= 초)는 고려하지 않았습니다.
* YYYYMMDDHHMI 형식의 String => 'Time'으로 칭함
*
* 주로 YYYYMMDD 까지만 쓰인다면 아래 함수들을
* YYYYMMDD 형식의 String => 'Date'로 하여 적당히

* 수정하시거나 아니면 함수를, 예를들어 isValidDate()처럼,
* 추가하시기 바랍니다.
*
*/


/**
* 유효한(존재하는) 월(月)인지 체크
*/
function isValidMonth(mm)
{
	var m = parseInt(mm,10);
	return (m >= 1 && m <= 12);
}

/**
* 유효한(존재하는) 일(日)인지 체크
*/
function isValidDay(yyyy, mm, dd)
{
    var m = parseInt(mm,10) - 1;
    var d = parseInt(dd,10);

    var end = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
    if ((yyyy % 4 == 0 && yyyy % 100 != 0) || yyyy % 400 == 0) {
        end[1] = 29;
    }

    return (d >= 1 && d <= end[m]);
}

/**
* 유효한(존재하는) 시(時)인지 체크
*/
function isValidHour(hh)
{
    var h = parseInt(hh,10);
    return (h >= 1 && h <= 24);
}

/**
* 유효한(존재하는) 분(分)인지 체크
*/
function isValidMin(mi)
{
    var m = parseInt(mi,10);
    return (m >= 1 && m <= 60);
}

/**
* Time 형식인지 체크(느슨한 체크)
*/
function isValidTimeFormat(time)
{
    return (!isNaN(time) && time.length == 12);
}

/**
* 유효하는(존재하는) Time 인지 체크

* ex) var time = form.time.value; //'200102310000'
*     if (!isValidTime(time)) {
*         alert("올바른 날짜가 아닙니다.");
*     }
*/
function isValidTime(time)
{
    var year  = time.substring(0,4);
    var month = time.substring(4,6);
    var day   = time.substring(6,8);
    var hour  = time.substring(8,10);
    var min   = time.substring(10,12);

    if (parseInt(year,10) >= 1900  && isValidMonth(month) &&
        isValidDay(year,month,day) && isValidHour(hour)   &&
        isValidMin(min)) {
        return true;
    }
    return false;
}

/**
* Time 스트링을 자바스크립트 Date 객체로 변환
* parameter time: Time 형식의 String
*/
function toTimeObject(time)
{ //parseTime(time)
    var year  = time.substr(0,4);
    var month = time.substr(4,2) - 1; // 1월=0,12월=11
    var day   = time.substr(6,2);
    var hour  = time.substr(8,2);
    var min   = time.substr(10,2);

    return new Date(year,month,day,hour,min);
}

/**
* 자바스크립트 Date 객체를 Time 스트링으로 변환

* parameter date: JavaScript Date Object
*/
function toTimeString(date)
{ //formatTime(date)
    var year  = date.getFullYear();
    var month = date.getMonth() + 1; // 1월=0,12월=11이므로 1 더함
    var day   = date.getDate();
    var hour  = date.getHours();
    var min   = date.getMinutes();

    if (("" + month).length == 1) { month = "0" + month; }
    if (("" + day).length   == 1) { day   = "0" + day;   }
    if (("" + hour).length  == 1) { hour  = "0" + hour;  }
    if (("" + min).length   == 1) { min   = "0" + min;   }

    return ("" + year + month + day + hour + min);
}

/**
* Time이 현재시각 이후(미래)인지 체크
*/
function isFutureTime(time)
{
    return (toTimeObject(time) > new Date());
}

/**
* Time이 현재시각 이전(과거)인지 체크
*/
function isPastTime(time)
{
    return (toTimeObject(time) < new Date());
}

/**
* 주어진 Time 과 y년 m월 d일 h시 차이나는 Time을 리턴

* ex) var time = form.time.value; //'20000101000'
*     alert(shiftTime(time,0,0,-100,0));
*     => 2000/01/01 00:00 으로부터 100일 전 Time
*/
function shiftTime(time,y,m,d,h)
{ //moveTime(time,y,m,d,h)
    var date = toTimeObject(time);

    date.setFullYear(date.getFullYear() + y); //y년을 더함
    date.setMonth(date.getMonth() + m);       //m월을 더함
    date.setDate(date.getDate() + d);         //d일을 더함
    date.setHours(date.getHours() + h);       //h시를 더함

    return toTimeString(date);
}

/**
* 두 Time이 몇 개월 차이나는지 구함

* time1이 time2보다 크면(미래면) minus(-)
*/
function getMonthInterval(time1,time2)
{ //measureMonthInterval(time1,time2)
    var date1 = toTimeObject(time1);
    var date2 = toTimeObject(time2);

    var years  = date2.getFullYear() - date1.getFullYear();
    var months = date2.getMonth() - date1.getMonth();
    var days   = date2.getDate() - date1.getDate();

    return (years * 12 + months + (days >= 0 ? 0 : -1) );
}

/**
* 두 Time이 며칠 차이나는지 구함
* time1이 time2보다 크면(미래면) minus(-)
*/
function getDayInterval(time1,time2)
{
    var date1 = toTimeObject(time1);
    var date2 = toTimeObject(time2);
    var day   = 1000 * 3600 * 24; //24시간

    return parseInt((date2 - date1) / day, 10);
}

/**
* 두 Time이 몇 시간 차이나는지 구함

* time1이 time2보다 크면(미래면) minus(-)
*/
function getHourInterval(time1,time2)
{
    var date1 = toTimeObject(time1);
    var date2 = toTimeObject(time2);
    var hour  = 1000 * 3600; //1시간

    return parseInt((date2 - date1) / hour, 10);
}

/**
* 현재 시각을 Time 형식으로 리턴

*/
function getCurrentTime()
{
    return toTimeString(new Date());
}

/**
* 현재 시각과 y년 m월 d일 h시 차이나는 Time을 리턴
*/
function getRelativeTime(y,m,d,h)
{
    return shiftTime(getCurrentTime(),y,m,d,h);
}

/**
* 현재 年을 YYYY형식으로 리턴
*/
function getYear()
{
    return getCurrentTime().substr(0,4);
}

/**
* 현재 月을 MM형식으로 리턴
*/
function getMonth()
{
    return getCurrentTime().substr(4,2);
}

/**
* 현재 日을 DD형식으로 리턴

*/
function getDay()
{
    return getCurrentTime().substr(6,2);
}

/**
* 현재 時를 HH형식으로 리턴
*/
function getHour()
{
    return getCurrentTime().substr(8,2);
}

/**
* 오늘이 무슨 요일이야?

* ex) alert('오늘은 ' + getDayOfWeek() + '요일입니다.');
* 특정 날짜의 요일을 구하려면? => 여러분이 직접 만들어 보세요.
*/
function getDayOfWeek()
{
    var now = new Date();
    var day = now.getDay(); //일요일=0,월요일=1,...,토요일=6
    var week = new Array(DateJS.sun,DateJS.mon,DateJS.tue,DateJS.wed,DateJS.thu,DateJS.fri,DateJS.sat);
    return week[day];
}

function getDayOfWeekValue( )
{
	var now = new Date();
    return now.getDay();
}

function getDayOfWeekName( day )
{
    var week = new Array(DateJS.sun,DateJS.mon,DateJS.tue,DateJS.wed,DateJS.thu,DateJS.fri,DateJS.sat);
    return week[day];
}


/**
 * 비교할  시간과의 차이를 시,분,초,M으로 나타낸다.
 * @param time1
 * @return
 */
function differenceTime ( time1 )
{
	var dateObj = new Date(0, 0, 0, 0, 0, 0, ( new Date( ) ).getTime( ) - time1 );
	var hours = dateObj.getHours( );
	var minutes = dateObj.getMinutes( );
	var seconds = dateObj.getSeconds( );
	var milliseconds = dateObj.getMilliseconds( );

	return hours + " " + DateJS.hour + " " + minutes + " " + DateJS.min + " " + seconds + " " + DateJS.sec + " " + milliseconds + " M";
}

//"20020101" 형태의 일자값을 "2002-01-01" 형태로 리턴
function fCompleteDateFormat(pDate) {
	var vDate = pDate.replaceAll(" ", "");
	if (vDate.length === 8) {
		if (!isValidDay(vDate.substring(0, 4), vDate.substring(4, 6), vDate.substring(6, 8))) return "";
		vDate = vDate.substring(0, 4) + "-" + vDate.substring(4, 6) + "-" + vDate.substring(6, 8);
		return vDate;
	} else if(vDate.length === 14) {
		if (!isValidDay(vDate.substring(0, 4), vDate.substring(4, 6), vDate.substring(6, 8))) return "";
		vDate = vDate.substring(0, 4) + "-" + vDate.substring(4, 6) + "-" + vDate.substring(6, 8) + " " + vDate.substring(8, 10) + ":" + vDate.substring(10, 12) + ":" + vDate.substring(12, 14);
		return vDate;
	}
	return '';
}

//"20020101" 형태의 일자값을 "2002-01-01" 형태로 리턴
function fTextToDateFormat( pDate )
{
	var vDate = pDate.replaceAll(" ","");
	if ( vDate.length < 6 ) return pDate;
	if ( vDate.length == 8 ) vDate = vDate.substring(0,4) + "-" + vDate.substring(4,6) + "-" + vDate.substring(6,8);
	else if ( vDate.length == 6 ) vDate = vDate.substring(0,4) + "-" + vDate.substring(4,6);
	return vDate;
}

/**
 * 두 날짜에 해당하는 특정 요일의 목록..
 * @param from 시작일('20120531')
 * @param to   종료일('20120831')
 * @param searchWeek 찾고 싶은 요일('월')
 * @return
 */
function twoDateBetween( from, to, searchWeek )
{
	var betweenDate = [];
	var fromDate = toTimeObject( from );
	var interval = getDayInterval( from, to );
	for ( var i=0 ; i <= interval ; i++ )
	{
		if ( i > 0 ) fromDate.setDate( fromDate.getDate( ) + 1 );
		if ( fromDate.getDay( ) == searchWeek ) betweenDate.push( fromDate.format( 'yyyymmdd' ) );
	}
	return betweenDate;
}

function addDay(day) {
	var today = new Date();
	today.setDate(today.getDate() + parseInt(day));
	
	return getDate(today);
}

function addMonth(day) {
	var today = new Date();
	today.setMonth(today.getMonth() + parseInt(day));
	today.setDate(today.getDate() + 1);
	
	return getDate(today);
}

function addYear(day) {
	var today = new Date();
	today.setFullYear(today.getFullYear() + parseInt(day));
	today.setDate(today.getDate() + 1);
	
	return getDate(today);
}

function getDate(date) {
	var month = date.getMonth() + 1;
	var day = date.getDate();
	return date.getFullYear() + "-" + (month > 9 ? month : ("0" + month)) + "-" + (day > 9 ? day : ("0" + day));
}

var startYear = getYear ( )-5;
var currentYear = getYear ( );
var currentMonth = getMonth ( );


//var gsMonthNamesEng = new Array( 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' );
var gsMonthNamesKr = new Array( DateJS.jan,DateJS.feb,DateJS.mar,DateJS.apr,DateJS.may,DateJS.jun,DateJS.jul,DateJS.aug,DateJS.sep,DateJS.oct,DateJS.nov,DateJS.dec );
//var gsDayNamesEng = new Array( 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' );
var gsDayNamesKr = new Array( DateJS.sunday,DateJS.monday,DateJS.tuesday,DateJS.wednesday,DateJS.thursday,DateJS.friday,DateJS.saturday );
//var gsHourNamesEng = new Array( 'AM', 'PM' );
var gsHourNamesKr = new Array( DateJS.am, DateJS.pm );

// the date format prototype
Date.prototype.format = function( f )
{
	//alert( String( this ) );
    if (!this.valueOf())
        return '';
 
    var d = this;
 
    return f.replace(/(yyyy|mmmm|mmm|mm|dddd|ddd|dd|hh|HH|nn|ss|a\/p)/gi,

        function($1)
        {
            switch ($1)
            {
	            case 'yyyy': return d.getFullYear(); 											//년도 (2011)
	            case 'mmmm': return gsMonthNamesKr[d.getMonth()];								//월 (January)
	            case 'mmm':  return gsMonthNamesKr[d.getMonth()].substr(0, 3);					//월(Jan)
	            case 'mm':   return (d.getMonth() + 1).zf(2);									//월(09)
	            case 'dddd': return gsDayNamesKr[d.getDay()];									//요일(Sunday)
	            case 'ddd':  return gsDayNamesKr[d.getDay()].substr(0, 3);						//요일(Sun)
	            case 'dd':   return d.getDate().zf(2);											//일(01)
	            case 'hh':   return ((h = d.getHours() % 12) ? h : 12).zf(2);					//시간(12간제.)
	            case 'HH':   return d.getHours().zf(2);											//시간(24간제.)
	            case 'nn':   return d.getMinutes().zf(2);										//분(15)
	            case 'ss':   return d.getSeconds().zf(2);										//초(60)
	            case 'a/p':  return d.getHours() < 12 ? gsHourNamesKr[0] : gsHourNamesKr[1]; 	//오전/오후
            }
        }  
    );
};

function getWeekS( dateStr ) {
	//dateStr
}
Date.prototype.addMonths = function (value) {
	var n = this.getDate();
	this.setDate(1);
	this.setMonth(this.getMonth() + value);
	this.setDate(Math.min(n, this.getDaysInMonth()));
	return this;
};
Date.isLeapYear = function (year) { 
    return (((year % 4 === 0) && (year % 100 !== 0)) || (year % 400 === 0)); 
};

Date.getDaysInMonth = function (year, month) {
    return [31, (Date.isLeapYear(year) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month];
};

Date.prototype.isLeapYear = function () { 
    return Date.isLeapYear(this.getFullYear()); 
};

Date.prototype.getDaysInMonth = function () { 
    return Date.getDaysInMonth(this.getFullYear(), this.getMonth());
};

//Returns ISO 8601 week number and year
Date.prototype.getFullWeek = function() {
    var jan1, w, d = new Date(this);
    d.setDate( d.getDate()+4 -( d.getDay( ) || 7 ) );   // Set to nearest Thursday: current date + 4 - current day number, make Sunday's day number 7
    jan1 = new Date( d.getFullYear(), 0, 1);       		// Get first day of year
    w = Math.ceil((((d-jan1)/86400000)+1)/7);   		// Calculate full weeks to nearest Thursday
    return { y:d.getFullYear(), w:w};
};
//Returns ISO 8601 week number
Date.prototype.getWeek = function(){ return this.getFullWeek().w; };
// Zero-Fill
String.prototype.zf = function(l) { return '0'.string(l - this.length) + this; };

//As you can see, it depends on the string prototype, an VB-like string concatenator:

// VB-like string
String.prototype.string = function(l) { var s = '', i = 0; while (i++ < l) { s += this; } return s; };

/*
Just bear in mind there's no check for the l (length) parameter, so you must always provide a number, and finally, you must create a number prototype for it (kind of an override) in order to use it directly on numbers:
*/
Number.prototype.zf = function(l) { return this.toString().zf(l); };


String.prototype.toDate = function() {
	return new Date(this.substr(0,4),this.substr(4,2)-1,this.substr(6,2),this.substr(8,2),this.substr(10,2),this.substr(12,2));
};

