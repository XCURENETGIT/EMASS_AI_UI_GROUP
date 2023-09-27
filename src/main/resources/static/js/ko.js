//! moment.js locale configuration
//! locale : korean (ko)
//!
//! authors
//!
//! - Kyungwook, Park : https://github.com/kyungw00k
//! - Jeeeyul Lee <jeeeyul@gmail.com>

;(function (global, factory) {
   typeof exports === 'object' && typeof module !== 'undefined'
       && typeof require === 'function' ? factory(require('../moment')) :
   typeof define === 'function' && define.amd ? define(['moment'], factory) :
   factory(global.moment)
}(this, function (moment) { 'use strict';


    var ko = moment.defineLocale('ko', {
        months : languageJS.months.split('_'),
        monthsShort : languageJS.monthsShort.split('_'),
        weekdays : languageJS.weekdays.split('_'),
        weekdaysShort : languageJS.weekdaysShort.split('_'),
        weekdaysMin : languageJS.weekdaysMin.split('_'),
        longDateFormat : {
            LT : languageJS.LT,
            LTS : languageJS.LTS,
            L : 'YYYY.MM.DD',
            LL : languageJS.LL,
            LLL : languageJS.LLL,
            LLLL : languageJS.LLLL
        },
        calendar : {
            sameDay : languageJS.sameDay,
            nextDay : languageJS.nextDay,
            nextWeek : languageJS.nextWeek,
            lastDay : languageJS.lastDay,
            lastWeek : languageJS.lastWeek,
            sameElse : 'L'
        },
        relativeTime : {
            future : languageJS.future,
            past : languageJS.past,
            s : languageJS.s,
            ss : languageJS.ss,
            m : languageJS.m,
            mm : languageJS.mm,
            h : languageJS.h,
            hh : languageJS.hh,
            d : languageJS.h,
            dd : languageJS.dd,
            M : languageJS.M,
            MM : languageJS.MM,
            y : languageJS.y,
            yy : languageJS.yy
        },
        ordinalParse : languageJS.ordinalParse,
        ordinal : languageJS.ordinal,
        meridiemParse : languageJS.meridiemParse,
        isPM : function (token) {
            return token === languageJS.pm;
        },
        meridiem : function (hour, minute, isUpper) {
            return hour < 12 ? languageJS.am : languageJS.pm;
        }
    });

    return ko;

}));