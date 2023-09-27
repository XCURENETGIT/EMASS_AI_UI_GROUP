/*
 * XCN Language File for English
 * chartAPI.js
 * Date.js
 * ko.js
 * password.js
 * slick.grid.ui_2.0.js
 * xcnui_2.0.js
 */

var chartAPIJS={
	imageSave:'이미지 저장',
	curveChart:'곡선차트',
	polyChart:'꺾은선차트',
	pointChart:'산점도차트',
	barChart:'막대형차트',
	areaChart:'영역(곡선)형차트'
};
var DateJS={
		sun:'일',
		mon:'월',
		tue:'화',
		wed:'수',
		thu:'목',
		fri:'금',
		sat:'토',
		hour:'시',
		min:'분',
		sec:'초',
		jan:'1월',
		feb:'2월',
		mar:'3월',
		apr:'4월',
		may:'5월',
		jun:'6월',
		jul:'7월',
		aug:'8월',
		sep:'9월',
		oct:'10월',
		nov:'11월',
		dec:'12월',
		sunday:'일요일',
		monday:'월요일',
		tuesday:'화요일',
		wednesday:'수요일',
		thursday:'목요일',
		friday:'금요일',
		saturday:'토요일',
		am:'오전',
		pm:'오후'
};
var languageJS={ //ko.js
		months:'1월_2월_3월_4월_5월_6월_7월_8월_9월_10월_11월_12월',
		monthsShort:'1월_2월_3월_4월_5월_6월_7월_8월_9월_10월_11월_12월',
		weekdays:'일요일_월요일_화요일_수요일_목요일_금요일_토요일',
		weekdaysShort:'일_월_화_수_목_금_토',
		weekdaysMin:'일_월_화_수_목_금_토',
		LT:'A h시 m분',
		LTS:'A h시 m분 s초',
		LL:'YYYY년 MMMM D일',
		LLL:'YYYY년 MMMM D일 A h시 m분',
		LLLL:'YYYY년 MMMM D일 dddd A h시 m분',
		sameDay:'오늘 LT',
		nextDay:'내일 LT',
		nextWeek:'dddd LT',
		lastDay:'어제 LT',
		lastWeek:'지난주 dddd LT',
		future:'%s 후',
        past:'%s 전',
        s:'몇초',
        ss:'%d초',
        m:'일분',
        mm:'%d분',
        h:'한시간',
        hh:'%d시간',
        d:'하루',
        dd:'%d일',
        M:'한달',
        MM:'%d달',
        y:'일년',
        yy:'%d년',
        
        ordinalParse:/\d{1,2}일/,
        ordinal:'%d일',
        meridiemParse:/오전|오후/,
        am:'오전',
        pm:'오후'
};
var passwordJS={
		pwMix:'비밀번호는 9~12자리로 영문자, 숫자, 특수문자 3가지를 혼용하여야 합니다.',
		notPast:'과거에 사용되었던 비밀번호를 사용할 수 없습니다.',
		notAccount:'계정과 동일한 비밀번호를 사용할 수 없습니다.',
		notUp:'비밀번호가 9자리 이상이 아닙니다.',
		notDown:'비밀번호가 12자리 이하가 아닙니다.',
		notCombination:'조합이 일치하지 않습니다.',
		combiMsg1:'조합은 아래와 같습니다.',
		combiMsg2:'1.영문자(A-z)',
		combiMsg3:'2.숫자(0-9)',
		combiMsg4:'3.특수문자(!@#$%^&*()[]\|<>?,./)',
		combiMsg5:'위 3가지 중 3가지 항목 이상을 포함해야 합니다.',
		notContinue:'연속된 문자열을 3자 이상 사용할 수 없습니다.',
		notAsc:'3자리 이상 연속된 오름차순의 문자열을 사용할 수 없습니다.',
		notDesc:'3자리 이상 연속된 내림차순의 문자열을 사용할 수 없습니다.'
};
var slickGridJS={
		searchCnt:'조회건수',
		searchSuccess:'조회건수',
		searching:'데이터를 조회 중 입니다.',
		noData:'데이터가 존재하지 않습니다.',
		exportData:'내보내기',
		excel:'엑셀',
		hancell:'한셀',
		text:'텍스트',
		print:'인쇄',
		listCnt:'목록개수'
};
var xcnuiJS={
		errorCallbackMsg1:'데이터 처리 중 에러가 발생하였습니다.\n다시 시도 후 증상이 동일하면 담당자에게 문의하시기 바랍니다.',
		errorCallbackMsg2:'통신이 원할하지 않습니다.\n다시 시도 후 증상이 동일하면 담당자에게 문의하시기 바랍니다.',
		errorCallbackMsg3:'해당 메시지는 더이상 사용할 수 없습니다.',
		confirm:'확인',
		cancel:'취소',
		prev:'이전',
		next:'다음',
		notUseChar:'사용할 수 없는 특수문자가 포함되어 있습니다.',
		noData:'데이터가 존재하지 않습니다.',
		year:'년',
		hour:'시',
		notEmail:'올바른 E-Mail 형식이 아닙니다.',
		emailMax:'E-Mail 글자 수는 최대 50자까지 가능합니다.',
		previewing:'파일 미리 보기 작업이 진행 중 입니다.\n잠시 후 다시 시도해 보시기 바랍니다.',
		notFileInfo:'파일 정보가 존재하지 않습니다.',
		noDataPeriod:'선택한 기간에 데이터가 없습니다.',
		noDataPrev:'이전 데이터가 없습니다.',
		noDataNext:'다음 데이터가 없습니다.'
};
var folderJS={
		newMsgFolder:'새 메시지 폴더'
};
var contentBodyDivJS={
		thisMsgAllChat:'현재 메시지의 대화 내용을 모두 볼 수 있습니다.',
		allMsgView:'모든 대화 보기',
		chatJoin:'대화방에 참여 하였습니다.',
		chatLeave:'대화방에서 퇴장 하였습니다.',
		backView:'원래대로',
		inputDate:'날짜입력 후 조회됩니다.',
		total:'전체',
		participantInfo:'참여자 정보',
		noAuthority:'권한이 없습니다.'
}
var mul = {
		aaa:'물가마 가마도리'
}