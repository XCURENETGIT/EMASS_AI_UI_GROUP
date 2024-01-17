/*
 * XCN Language File for English
 * chartAPI.js
 * Date.js
 * ko.js
 * password.js
 * slick.grid.ui_2.0.js
 * _2.0.js
 */

var chartAPIJS={
	imageSave:'Save Image',
	curveChart:'Curve chart',
	polyChart:'Line chart',
	pointChart:'The scatter plot chart',
	barChart:'Bar chart',
	areaChart:'Area(curve) chart'
};
var DateJS={
		sun:'Sun',
		mon:'Mon',
		tue:'Tue',
		wed:'Wed',
		thu:'Thu',
		fri:'Fri',
		sat:'Sat',
		hour:'hour',
		min:'minute',
		sec:'second',
		jan:'January',
		feb:'February',
		mar:'March',
		apr:'April',
		may:'May',
		jun:'June',
		jul:'July',
		aug:'August',
		sep:'September',
		oct:'October',
		nov:'November',
		dec:'December',
		sunday:'Sunday',
		monday:'Monday',
		tuesday:'Tuesday',
		wednesday:'Wednesday',
		thursday:'Thursday',
		friday:'Friday',
		saturday:'Saturday',
		am:'AM',
		pm:'PM'
};
var languageJS={ //ko.js
		months:'January_February_March_April_May_June_July_August_September_October_November_December',
		monthsShort:'Jan_Feb_Mar_Apr_May_Jun_Jul_Aug_Sep_Oct_Nov_Dec',
		weekdays:'Sunday_Monday_Tuesday_Wednesday_Thursday_Friday_Saturday',
		weekdaysShort:'Sun_Mon_Tue_Wed_Thu_Fri_Sat',
		weekdaysMin:'Su_Mo_Tu_We_Th_Fr_Sa',
		LT:'h:m A',
		LTS:'h:m:s A',
		LL:'D MMMM, YYYY',
		LLL:'D MMMM, YYYY LT',
		LLLL:'dddd, D MMMM, YYYY LT',
		sameDay:'[Today at] LT',
		nextDay:'[Tomorrow at] LT',
		nextWeek:'dddd [at] LT',
		lastDay:'[Yesterday at] LT',
		lastWeek:'[Last] dddd [at] LT',
		future:'in %s',
        past:'%s ago',
        s:'a few seconds',
        ss:'%d seconds',
        m:'a minute',
        mm:'%d minutes',
        h:'an hour',
        hh:'%d hours',
        d:'a day',
        dd:'%d days',
        M:'a month',
        MM:'%d months',
        y:'a year',
        yy:'%d years',
        
        ordinalParse:/\d{1,2}(th|st|nd|rd)/,
        ordinal:function (number) {
            var b = number % 10,
            output = (~~ (number % 100 / 10) === 1) ? 'th' :
            (b === 1) ? 'st' :
            (b === 2) ? 'nd' :
            (b === 3) ? 'rd' : 'th';
        return number + output;
        },
        meridiemParse:/[ap]\.?m?\.?/i,
        am:'AM',
        pm:'PM'
};
var passwordJS={
		pwMix:'Password can be used numeric, alphabet and special character, and character count is between 9 and 12.',
		notPast:'You can not use the password that is used in past.',
		notAccount:'The password can not be same with ID.',
		notUp:'The password is not more than 9 digits.',
		notDown:'The password is not less than 12 digits.',
		notCombination:'The combinations do not match.',
		combiMsg1:'The combinations are as follows.',
		combiMsg2:'1.alphabet(A-z)',
		combiMsg3:'2.number(0-9)',
		combiMsg4:'3.special character(!@#$%^&*()[]\|<>?,./)',
		combiMsg5:'It is necessary to include all of the above three items.',
		notContinue:'The password cannot be used sequential character over 3 times continuously.(123, 321, abc, cba)',
		notAsc:'The password cannot be used ascending character over 3 times continuously.',
		notDesc:'The password cannot be used descending character over 3 times continuously.'
};
var slickGridJS={
		searchCnt:'search count',
		searchSuccess:'Search finished',
		searching:'Searching..',
		noData:'No data to display.',
		exportData:'Export',
		excel:'Excel',
		hancell:'Hancell',
		text:'Text',
		print:'Print',
		listCnt:'List count'
};
var xcnuiJS={
		errorCallbackMsg1:'An error occurred while data processing.\nPlease contact administrator.',
		errorCallbackMsg2:'An error occured while communicating with server.\nPlease contact administrator.',
		errorCallbackMsg3:'The message is no longer available.',
		confirm:'OK',
		cancel:'Cancel',
		prev:'previous',
		next:'next',
		notUseChar:'Contains special characters that can not be used.',
		noData:'No data to display.',
		year:'year',
		hour:'hour',
		notEmail:'This is not a valid e-mail format.',
		emailMax:'E-Mail characters can be up to 50 characters.',
		previewing:'File preview operation is in progress.\nPlease try again in a few minutes.',
		notFileInfo:'File information does not exist.',
		noDataPeriod:'There is no data in the selected time period.',
		noDataPrev:'There is no previous data.',
		noDataNext:'There is no next data.'
};
var folderJS={
		newMsgFolder:'New message folder'
};
var contentBodyDivJS={
		thisMsgAllChat:'You can see all the contents of the current message conversation.',
		allMsgView:'View all chats',
		chatJoin:'JOIN',
		chatLeave:'LEAVE',
		backView:'Back',
		inputDate:'Search after enter date.',
		total:'Total',
		participantInfo:'Participants Information',
		noAuthority:'You do not have the authority.'
}

var filelist = {
	srcIp:'Departure IP',
	dstIp:'Destination IP',
	bodySize:'Size',
	userId:'Access account',
	fileinfo:'File Information',
	allSave:'Full save',
	noname:'Name unknown',
	save:'save',
	preview:'preview',
	allfileSave:'전체파일저장'
};