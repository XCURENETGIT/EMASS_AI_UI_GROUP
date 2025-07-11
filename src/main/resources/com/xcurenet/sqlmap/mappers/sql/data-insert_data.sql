USE
EMASSAI;

INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('session.timeoutSecond', '600', '600', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('password.fail.count', '5', '5', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('default.lang', 'ko', 'ko', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('password.restore.minute', '5', '5', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('password.change.day', '30', '30', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('session.duplication.type', 'N', 'N', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('long.term.unused', '60', '60', NOW());

INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('attach.image.body', 'false', 'false', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('message.epmsg.val', '', '', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('info.feedback.used', 'true', 'true', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('info.feedback.mode', 'D', 'D', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('xml.rpc.port', '9900', '9900', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('xml.rpc.protocol', 'http://', 'http://', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('xml.rpc.context', '/RPC2', '/RPC2', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('xml.rpc.connectionTimeout', '10000', '10000', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('xml.rpc.replyTimeout', '30000', '30000', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('eikon.menu.enable', 'true', 'true', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('ui.ipv6', 'false', 'false', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('ui.ocr', 'false', 'false', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('query.type', 'A', 'A', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('ceo.readyn', 'Y', 'Y', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('body.samsung.tables', 'N', 'N', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('google.otp.used', 'false', 'false', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('recvs.jikgub.use', 'false', 'false', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('message.user.format', '#name#/#email#/#businm#/#deptnm#/#jikgubnm#/#ip#/#sabun#', '#name#/#email#/#businm#/#deptnm#/#jikgubnm#/#ip#/#sabun#', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('system.arch', 'standalone', 'standalone', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('receiver.sender.uppercase', 'N', 'N', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('insa.dept.basepoint', 'F', 'F', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('snmpa.community', 'xcn_lp', 'xcn_lp', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('info.hynix.used', 'false', 'false', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('chrony.server.used', 'true', 'true', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('llm.single', 'false', 'false', NOW());

INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('llm.Vietnam', 'false', 'false', NOW());

INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('dashboard.period', 'T', 'T', NOW());

INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES('private.patterns.ordered', 'AN,CN,DN,FN,MN,PN,SN,BRN,CPN,CRN,DRM,MCN,SSN,IMEI,ID,RS,EC,EF,LTO,LAO,LF', NULL, NOW());

INSERT IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('info.feedback.llm', 'true', 'true', NOW());

INSERT
IGNORE INTO UI_ADMIN
(ADMIN_ID, ADMIN_NAME, ADMIN_PW, ADMIN_EMAIL, ADMIN_HP, PW_CHG_DT, LAST_LOGIN_DT, LAST_LOGIN_IP, STATUS, FIRSTADMIN_YN, ADMIN_TYPE, USE_YN, ACCESS_FAIL_CNT, ACCESS_FAIL_DT, APPROBATOR, INFO_FEEDBACK, COMMENT, CREATE_DT)
VALUES ('sysadmin', '시스템관리자', 'eda0b53f075bae2476ea3bfe093eb3d2181ef515bb8a9727a9f3a6c6ceb6c6ba', '', '', null, null, null, null, 'Y', 'S', 'Y', 0, null, 'Y', 'Y', null, now());


INSERT
IGNORE INTO UI_DASHBOARD (DASH_KEY, DASH_VAL, ORDER_ROW, ORDER_COL, DASH_CLASS, DASH_ICON) VALUES
('device.status1', NULL, 3, 0, 'panel-green', 'fa-tasks'),
('device.status2', NULL, 3, 1, 'panel-green', 'fa-database'),
('file.send', '200', 3, 3, 'panel-primary', 'fa-save'),
('interestUser.mail.count', NULL, 3, 2, 'panel-primary', 'fa-users'),
('interestUser.service.amount', NULL, 2, 1, 'panel-default', NULL),
('keyword.message.count', NULL, 0, 3, 'panel-red', 'fa-font'),
('personal.message.count', NULL, 0, 1, 'panel-primary', 'fa-user'),
('riskBehavior.message.count', NULL, 0, 2, 'panel-red', 'fa-warning'),
('service.logging.count', NULL, 2, 0, 'panel-default', NULL),
('today.logging.status', NULL, 0, 0, 'panel-primary', 'fa-envelope'),
('user.filter1', NULL, 1, 0, 'panel-green', 'fa-star-o'),
('user.filter2', NULL, 1, 1, 'panel-green', 'fa-star-o'),
('user.filter3', NULL, 1, 2, 'panel-green', 'fa-star-o'),
('user.filter4', NULL, 1, 3, 'panel-green', 'fa-star-o')
;


INSERT
IGNORE INTO UI_DASHBOARD_ADMIN( ADMIN_ID, DASH_KEY, DASH_VAL, ORDER_ROW, ORDER_COL, DASH_CLASS, DASH_ICON )
SELECT 'sysadmin', DASH_KEY, DASH_VAL, ORDER_ROW, ORDER_COL, DASH_CLASS, DASH_ICON
FROM UI_DASHBOARD;

/* 서비스 */
-- DELETE FROM UI_SERVICE;
INSERT IGNORE INTO UI_SERVICE (`SERVICECD`, `SERVICENM_LV1`, `SERVICENM_LV2`, `SERVICENM_LV3`, `IN_OUT`, `SORT`, `USE_YN`, `MSGGRPCD`) VALUES
    ('MP3-', '메일', 'POP3', '-', 'I', 1, 'Y', ''),
    ('MSM-', '메일', 'SMTP', '-', 'O', 2, 'Y', ''),
    ('MIM-', '메일', 'IMAP', '-', 'I', 3, 'Y', ''),
    ('WAOR', '웹메일', 'Aol mail', '수신', 'I', 4, 'Y', ''),
    ('WAOS', '웹메일', 'Aol mail', '발신', 'O', 5, 'Y', ''),
    ('WAOT', '웹메일', 'Aol mail', '임시메일', 'O', 6, 'Y', ''),
    ('WNVR', '웹메일', '네이버', '수신', 'I', 7, 'Y', ''),
    ('WNVS', '웹메일', '네이버', '발신', 'O', 8, 'Y', ''),
    ('WNVB', '웹메일', '네이버', '예약메일', 'O', 9, 'Y', ''),
    ('WNVT', '웹메일', '네이버', '임시저장', 'O', 10, 'Y', ''),
    ('WDUR', '웹메일', '다음', '수신', 'I', 11, 'Y', ''),
    ('WDUS', '웹메일', '다음', '발신', 'O', 12, 'Y', ''),
    ('WDUB', '웹메일', '다음', '예약메일', 'O', 13, 'Y', ''),
    ('WDUT', '웹메일', '다음', '임시저장', 'O', 14, 'Y', ''),
    ('WCLR', '웹메일', '천리안', '수신', 'I', 15, 'Y', ''),
    ('WCLS', '웹메일', '천리안', '발신', 'O', 16, 'Y', ''),
    ('WCLB', '웹메일', '천리안', '예약메일', 'O', 17, 'Y', ''),
    ('WCLT', '웹메일', '천리안', '임시저장', 'O', 18, 'Y', ''),
    ('WNTR', '웹메일', '네이트', '수신', 'I', 19, 'Y', ''),
    ('WNTS', '웹메일', '네이트', '발신', 'O', 20, 'Y', ''),
    ('WNTB', '웹메일', '네이트', '예약메일', 'O', 21, 'Y', ''),
    ('WNTT', '웹메일', '네이트', '임시저장', 'O', 22, 'Y', ''),
    ('WKRR', '웹메일', '코리아', '수신', 'I', 23, 'Y', ''),
    ('WKRS', '웹메일', '코리아', '발신', 'O', 24, 'Y', ''),
    ('WKRB', '웹메일', '코리아', '예약메일', 'O', 25, 'Y', ''),
    ('WKRT', '웹메일', '코리아', '임시저장', 'O', 26, 'Y', ''),
    ('WUTR', '웹메일', '유니텔', '수신', 'I', 27, 'Y', ''),
    ('WUTS', '웹메일', '유니텔', '발신', 'O', 28, 'Y', ''),
    ('WUTB', '웹메일', '유니텔', '예약메일', 'O', 29, 'Y', ''),
    ('WUTT', '웹메일', '유니텔', '임시저장', 'O', 30, 'Y', ''),
    ('WYAR', '웹메일', 'Yeah', '수신', 'I', 31, 'Y', ''),
    ('WYAS', '웹메일', 'Yeah', '발신', 'O', 32, 'Y', ''),
    ('WYAT', '웹메일', 'Yeah', '임시저장', 'O', 33, 'Y', ''),
    ('WSNR', '웹메일', 'SINA', '수신', 'I', 34, 'Y', ''),
    ('WSNS', '웹메일', 'SINA', '발신', 'O', 35, 'Y', ''),
    ('WSNB', '웹메일', 'SINA', '예약메일', 'O', 36, 'Y', ''),
    ('WSNT', '웹메일', 'SINA', '임시저장', 'O', 37, 'Y', ''),
    ('WSUR', '웹메일', 'SOHU', '수신', 'I', 38, 'Y', ''),
    ('WSUS', '웹메일', 'SOHU', '발신', 'O', 39, 'Y', ''),
    ('WSUB', '웹메일', 'SOHU', '예약메일', 'O', 40, 'Y', ''),
    ('WSUT', '웹메일', 'SOHU', '임시저장', 'O', 41, 'Y', ''),
    ('WYHR', '웹메일', '야후', '수신', 'I', 42, 'Y', ''),
    ('WYHS', '웹메일', '야후', '발신', 'O', 43, 'Y', ''),
    ('WYHT', '웹메일', '야후', '임시저장', 'O', 44, 'Y', ''),
    ('WGGR', '웹메일', 'Gmail', '수신', 'I', 45, 'Y', ''),
    ('WGGS', '웹메일', 'Gmail', '발신', 'O', 46, 'Y', ''),
    ('WGGT', '웹메일', 'Gmail', '임시저장', 'O', 47, 'Y', ''),
    ('WLVR', '웹메일', 'Outlook.com', '수신', 'I', 48, 'Y', ''),
    ('WLVS', '웹메일', 'Outlook.com', '발신', 'O', 49, 'Y', ''),
    ('WLVT', '웹메일', 'Outlook.com', '임시저장', 'O', 50, 'Y', ''),
    ('WQQR', '웹메일', 'QQ', '수신', 'I', 51, 'Y', ''),
    ('WQQS', '웹메일', 'QQ', '발신', 'O', 52, 'Y', ''),
    ('WQQB', '웹메일', 'QQ', '예약메일', 'O', 53, 'Y', ''),
    ('WQQT', '웹메일', 'QQ', '임시저장', 'O', 54, 'Y', ''),
    ('WOSR', '웹메일', '163', '수신', 'I', 55, 'Y', ''),
    ('WOSS', '웹메일', '163', '발신', 'O', 56, 'Y', ''),
    ('WOSB', '웹메일', '163', '예약메일', 'O', 57, 'Y', ''),
    ('WOST', '웹메일', '163', '임시저장', 'O', 58, 'Y', ''),
    ('WBMR', '웹메일', 'KT비즈메카', '수신', 'I', 59, 'Y', ''),
    ('WBMS', '웹메일', 'KT비즈메카', '발신', 'O', 60, 'Y', ''),
    ('WBMT', '웹메일', 'KT비즈메카', '임시저장', 'O', 61, 'Y', ''),
    ('WOTR', '웹메일', '126', '수신', 'I', 62, 'Y', ''),
    ('WOTS', '웹메일', '126', '발신', 'O', 63, 'Y', ''),
    ('WOTB', '웹메일', '126', '예약메일', 'O', 64, 'Y', ''),
    ('WOTT', '웹메일', '126', '임시저장', 'O', 65, 'Y', ''),
    ('WICR', '웹메일', 'Icloud', '수신', 'I', 66, 'Y', ''),
    ('WICS', '웹메일', 'Icloud', '발신', 'O', 67, 'Y', ''),
    ('WICT', '웹메일', 'Icloud', '임시저장', 'O', 68, 'Y', ''),
    ('WKAR', '웹메일', '카카오메일', '수신', 'I', 69, 'Y', ''),
    ('WKAS', '웹메일', '카카오메일', '발신', 'O', 70, 'Y', ''),
    ('WKAT', '웹메일', '카카오메일', '임시저장', 'O', 71, 'Y', ''),
    ('WYDR', '웹메일', 'Yandex', '수신', 'I', 72, 'Y', ''),
    ('WYDS', '웹메일', 'Yandex', '발신', 'O', 73, 'Y', ''),
    ('WYDT', '웹메일', 'Yandex', '임시저장', 'O', 74, 'Y', ''),
    ('WDOR', '웹메일', 'Dooray', '수신', 'I', 75, 'Y', ''),
    ('WDOS', '웹메일', 'Dooray', '발신', 'O', 76, 'Y', ''),
    ('WDOT', '웹메일', 'Dooray', '임시저장', 'O', 77, 'Y', ''),
    ('WZHS', '웹메일', 'Zoho 메일', '발신', 'O', 78, 'Y', ''),
    ('WZHT', '웹메일', 'Zoho 메일', '임시저장', 'O', 79, 'Y', ''),
    ('WZHR', '웹메일', 'Zoho 메일', '수신', 'O', 80, 'Y', ''),
    ('WRUS', '웹메일', 'Russian Mail', '발신', 'O', 81, 'Y', ''),
    ('WUKR', '웹메일', '기타', '수신', 'I', 82, 'Y', ''),
    ('WUKS', '웹메일', '기타', '발신', 'O', 83, 'Y', ''),
    ('CNVR', '커뮤니티', '네이버 카페', '수신', 'I', 84, 'Y', ''),
    ('CNVS', '커뮤니티', '네이버 카페', '발신', 'O', 85, 'Y', ''),
    ('CNVD', '커뮤니티', '네이버 카페', '댓글', 'O', 86, 'Y', ''),
    ('CNVT', '커뮤니티', '네이버 카페', '임시저장', 'O', 87, 'Y', ''),
    ('CDUR', '커뮤니티', '다음 카페', '수신', 'I', 88, 'Y', ''),
    ('CDUS', '커뮤니티', '다음 카페', '발신', 'O', 89, 'Y', ''),
    ('CDUD', '커뮤니티', '다음 카페', '댓글', 'O', 90, 'Y', ''),
    ('CDUT', '커뮤니티', '다음 카페', '임시저장', 'O', 91, 'Y', ''),
    ('CPPR', '커뮤니티', '뽐뿌 커뮤니케이션', '수신', 'I', 92, 'Y', ''),
    ('CPPS', '커뮤니티', '뽐뿌 커뮤니케이션', '발신', 'O', 93, 'Y', ''),
    ('CPPD', '커뮤니티', '뽐뿌 커뮤니케이션', '댓글', 'O', 94, 'Y', ''),
    ('CCIR', '커뮤니티', '클리앙', '수신', 'I', 95, 'Y', ''),
    ('CCIS', '커뮤니티', '클리앙', '발신', 'O', 96, 'Y', ''),
    ('CCID', '커뮤니티', '클리앙', '댓글', 'O', 97, 'Y', ''),
    ('CDCR', '커뮤니티', '디시인사이드', '수신', 'I', 98, 'Y', ''),
    ('CDCS', '커뮤니티', '디시인사이드', '발신', 'O', 99, 'Y', ''),
    ('CDCD', '커뮤니티', '디시인사이드', '댓글', 'O', 100, 'Y', ''),
    ('CRWR', '커뮤니티', '루리웹', '수신', 'I', 101, 'Y', ''),
    ('CRWS', '커뮤니티', '루리웹', '발신', 'O', 102, 'Y', ''),
    ('CRWD', '커뮤니티', '루리웹', '댓글', 'O', 103, 'Y', ''),
    ('CMLR', '커뮤니티', 'Menlosecurity', '수신', 'I', 104, 'Y', ''),
    ('CMLS', '커뮤니티', 'Menlosecurity', '발신', 'O', 105, 'Y', ''),
    ('CMLD', '커뮤니티', 'Menlosecurity', '댓글', 'O', 106, 'Y', ''),
    ('CMLE', '커뮤니티', 'Menlosecurity', '기타', 'O', 107, 'Y', ''),
    ('CBDS', '커뮤니티', '블라인드', '발신', 'O', 108, 'Y', ''),
    ('CBRS', '커뮤니티', '브런치 스토리', '발신', 'O', 109, 'Y', ''),
    ('CUKR', '커뮤니티', '기타', '수신', 'I', 110, 'Y', ''),
    ('CUKS', '커뮤니티', '기타', '발신', 'O', 111, 'Y', ''),
    ('CUKD', '커뮤니티', '기타', '댓글', 'O', 112, 'Y', ''),
    ('SFBR', '소셜', '페이스북', '수신', 'I', 113, 'Y', ''),
    ('SFBS', '소셜', '페이스북', '발신', 'O', 114, 'Y', ''),
    ('SFBD', '소셜', '페이스북', '댓글', 'O', 115, 'Y', ''),
    ('STWR', '소셜', '트위터', '수신', 'I', 116, 'Y', ''),
    ('STWS', '소셜', '트위터', '발신', 'O', 117, 'Y', ''),
    ('STWD', '소셜', '트위터', '댓글', 'O', 118, 'Y', ''),
    ('SKAR', '소셜', '카카오스토리', '수신', 'I', 119, 'Y', ''),
    ('SKAS', '소셜', '카카오스토리', '발신', 'O', 120, 'Y', ''),
    ('SKAD', '소셜', '카카오스토리', '댓글', 'O', 121, 'Y', ''),
    ('SNVR', '소셜', '네이버 블로그', '수신', 'I', 122, 'Y', ''),
    ('SNVS', '소셜', '네이버 블로그', '발신', 'O', 123, 'Y', ''),
    ('SNVD', '소셜', '네이버 블로그', '댓글', 'O', 124, 'Y', ''),
    ('SNVT', '소셜', '네이버 블로그', '임시저장', 'O', 125, 'Y', ''),
    ('SNVU', '소셜', '네이버 블로그', '수정', 'O', 126, 'Y', ''),
    ('SDUR', '소셜', '다음 블로그', '수신', 'I', 127, 'Y', ''),
    ('SDUS', '소셜', '다음 블로그', '발신', 'O', 128, 'Y', ''),
    ('SDUD', '소셜', '다음 블로그', '댓글', 'O', 129, 'Y', ''),
    ('STSR', '소셜', '티스토리', '수신', 'I', 130, 'Y', ''),
    ('STSS', '소셜', '티스토리', '발신', 'O', 131, 'Y', ''),
    ('STSD', '소셜', '티스토리', '댓글', 'O', 132, 'Y', ''),
    ('STST', '소셜', '티스토리', '임시저장', 'O', 133, 'Y', ''),
    ('STBR', '소셜', '텀블러', '수신', 'I', 134, 'Y', ''),
    ('STBS', '소셜', '텀블러', '발신', 'O', 135, 'Y', ''),
    ('STBD', '소셜', '텀블러', '댓글', 'O', 136, 'Y', ''),
    ('SWBR', '소셜', '웨이보', '수신', 'I', 137, 'Y', ''),
    ('SWBS', '소셜', '웨이보', '발신', 'O', 138, 'Y', ''),
    ('SWBD', '소셜', '웨이보', '댓글', 'O', 139, 'Y', ''),
    ('SLKR', '소셜', '링크드인', '수신', 'I', 140, 'Y', ''),
    ('SLKS', '소셜', '링크드인', '발신', 'O', 141, 'Y', ''),
    ('SLKD', '소셜', '링크드인', '댓글', 'O', 142, 'Y', ''),
    ('SEGR', '소셜', '이글루', '수신', 'I', 143, 'Y', ''),
    ('SEGS', '소셜', '이글루', '발신', 'O', 144, 'Y', ''),
    ('SEGD', '소셜', '이글루', '댓글', 'O', 145, 'Y', ''),
    ('SYMR', '소셜', '야머', '수신', 'I', 146, 'Y', ''),
    ('SYMS', '소셜', '야머', '발신', 'O', 147, 'Y', ''),
    ('SYMD', '소셜', '야머', '댓글', 'O', 148, 'Y', ''),
    ('SYMF', '소셜', '야머', '파일전송', 'O', 149, 'Y', ''),
    ('SNBR', '소셜', '네이버 밴드', '수신', 'I', 150, 'Y', ''),
    ('SNBS', '소셜', '네이버 밴드', '발신', 'O', 151, 'Y', ''),
    ('SNBD', '소셜', '네이버 밴드', '댓글', 'O', 152, 'Y', ''),
    ('SLRR', '소셜', '라이브리', '수신', 'I', 153, 'Y', ''),
    ('SLRS', '소셜', '라이브리', '발신', 'O', 154, 'Y', ''),
    ('SLRD', '소셜', '라이브리', '댓글', 'O', 155, 'Y', ''),
    ('SMER', '소셜', 'Medium', '수신', 'I', 156, 'Y', ''),
    ('SMES', '소셜', 'Medium', '발신', 'O', 157, 'Y', ''),
    ('SMED', '소셜', 'Medium', '댓글', 'O', 158, 'Y', ''),
    ('SISR', '소셜', '인스타그램', '수신', 'I', 159, 'Y', ''),
    ('SISS', '소셜', '인스타그램', '발신', 'O', 160, 'Y', ''),
    ('SISD', '소셜', '인스타그램', '댓글', 'O', 161, 'Y', ''),
    ('SISF', '소셜', '인스타그램', '파일전송', 'O', 162, 'Y', ''),
    ('SSFS', '소셜', 'Salesforce', '발신', 'O', 163, 'Y', ''),
    ('SPIS', '소셜', 'Pinterest', '발신', 'O', 164, 'Y', ''),
    ('STHS', '소셜', 'Threads', '발신', 'O', 165, 'Y', ''),
    ('SBLS', '소셜', '블로거', '발신', 'O', 166, 'Y', ''),
    ('STTS', '소셜', 'Tiktok', '발신', 'O', 167, 'Y', ''),
    ('VDUR', '영상 스트리밍', '다음 TV', '수신', 'I', 168, 'Y', ''),
    ('VDUS', '영상 스트리밍', '다음 TV', '발신', 'O', 169, 'Y', ''),
    ('VPDR', '영상 스트리밍', '판도라 TV', '수신', 'I', 170, 'Y', ''),
    ('VPDS', '영상 스트리밍', '판도라 TV', '발신', 'O', 171, 'Y', ''),
    ('VGMR', '영상 스트리밍', '곰 TV', '수신', 'I', 172, 'Y', ''),
    ('VGMS', '영상 스트리밍', '곰 TV', '발신', 'O', 173, 'Y', ''),
    ('VYTR', '영상 스트리밍', '유튜브', '수신', 'I', 174, 'Y', ''),
    ('VYTS', '영상 스트리밍', '유튜브', '발신', 'O', 175, 'Y', ''),
    ('VYTD', '영상 스트리밍', '유튜브', '댓글', 'O', 176, 'Y', ''),
    ('VNVR', '영상 스트리밍', '네이버 TV캐스트', '수신', 'I', 177, 'Y', ''),
    ('VNVS', '영상 스트리밍', '네이버 TV캐스트', '발신', 'O', 178, 'Y', ''),
    ('QNVC', '메신저', '네이버', '채팅', 'O', 179, 'N', ''),
    ('QNVF', '메신저', '네이버', '파일전송', 'O', 180, 'N', ''),
    ('QNMR', '메신저', '네이버 쪽지', '수신', 'I', 181, 'N', ''),
    ('QNMS', '메신저', '네이버 쪽지', '발신', 'O', 182, 'N', ''),
    ('QDUC', '메신저', '다음', '채팅', 'O', 183, 'N', ''),
    ('QDUF', '메신저', '다음', '파일전송', 'O', 184, 'N', ''),
    ('QDUM', '메신저', '다음', '쪽지', 'O', 185, 'N', ''),
    ('QDSC', '메신저', '대신', '채팅', 'O', 186, 'N', ''),
    ('QDSF', '메신저', '대신', '파일전송', 'O', 187, 'N', ''),
    ('QDSM', '메신저', '대신', '쪽지', 'O', 188, 'N', ''),
    ('QSHC', '메신저', '삼홍사', '채팅', 'O', 189, 'Y', ''),
    ('QSHF', '메신저', '삼홍사', '파일전송', 'O', 190, 'Y', ''),
    ('QSHM', '메신저', '삼홍사', '쪽지', 'O', 191, 'Y', ''),
    ('QDIC', '메신저', '동부생명', '채팅', 'O', 192, 'Y', ''),
    ('QDIF', '메신저', '동부생명', '파일전송', 'O', 193, 'Y', ''),
    ('QDIM', '메신저', '동부생명', '쪽지', 'O', 194, 'Y', ''),
    ('QDFC', '메신저', '동부금융', '채팅', 'O', 195, 'Y', ''),
    ('QDFF', '메신저', '동부금융', '파일전송', 'O', 196, 'Y', ''),
    ('QDFM', '메신저', '동부금융', '쪽지', 'O', 197, 'Y', ''),
    ('QDGC', '메신저', '동국제강', '채팅', 'O', 198, 'Y', ''),
    ('QDGF', '메신저', '동국제강', '파일전송', 'O', 199, 'Y', ''),
    ('QDGM', '메신저', '동국제강', '쪽지', 'O', 200, 'Y', ''),
    ('QFMC', '메신저', '프리본드', '채팅', 'O', 201, 'Y', 'MSG'),
    ('QFMF', '메신저', '프리본드', '파일전송', 'O', 202, 'Y', 'MSG'),
    ('QFMM', '메신저', '프리본드', '쪽지', 'O', 203, 'Y', 'MSG'),
    ('QFMJ', '메신저', '프리본드', '참여', 'O', 204, 'Y', 'MSG'),
    ('QFML', '메신저', '프리본드', '떠남', 'O', 205, 'Y', 'MSG'),
    ('QMCC', '메신저', 'M-채널', '채팅', 'O', 206, 'Y', ''),
    ('QMCF', '메신저', 'M-채널', '파일전송', 'O', 207, 'Y', ''),
    ('QMCM', '메신저', 'M-채널', '쪽지', 'O', 208, 'Y', ''),
    ('QMSC', '메신저', '미쓰리', '채팅', 'O', 209, 'Y', 'MSG'),
    ('QMSF', '메신저', '미쓰리', '파일전송', 'O', 210, 'Y', 'MSG'),
    ('QMSM', '메신저', '미쓰리', '쪽지', 'O', 211, 'Y', 'MSG'),
    ('QMSJ', '메신저', '미쓰리', '참여', 'O', 212, 'Y', 'MSG'),
    ('QMSL', '메신저', '미쓰리', '떠남', 'O', 213, 'Y', 'MSG'),
    ('QNTC', '메신저', '네이트', '채팅', 'O', 214, 'Y', 'MSG'),
    ('QNTF', '메신저', '네이트', '파일전송', 'O', 215, 'Y', 'MSG'),
    ('QNTM', '메신저', '네이트', '쪽지', 'O', 216, 'Y', 'MSG'),
    ('QNTJ', '메신저', '네이트', '참여', 'O', 217, 'Y', 'MSG'),
    ('QNTL', '메신저', '네이트', '떠남', 'O', 218, 'Y', 'MSG'),
    ('QSSC', '메신저', '삼성증권', '채팅', 'O', 219, 'N', ''),
    ('QSSF', '메신저', '삼성증권', '파일전송', 'O', 220, 'N', ''),
    ('QSSM', '메신저', '삼성증권', '쪽지', 'O', 221, 'N', ''),
    ('QSFC', '메신저', '삼성화재', '채팅', 'O', 222, 'Y', ''),
    ('QSFF', '메신저', '삼성화재', '파일전송', 'O', 223, 'Y', ''),
    ('QSFM', '메신저', '삼성화재', '쪽지', 'O', 224, 'Y', ''),
    ('QSFJ', '메신저', '삼성화재', '참여', 'O', 225, 'Y', ''),
    ('QSFL', '메신저', '삼성화재', '떠남', 'O', 226, 'Y', ''),
    ('QSPC', '메신저', 'SK 프라이든', '채팅', 'O', 227, 'Y', ''),
    ('QSPF', '메신저', 'SK 프라이든', '파일전송', 'O', 228, 'Y', ''),
    ('QSPM', '메신저', 'SK 프라이든', '쪽지', 'O', 229, 'Y', ''),
    ('QSPJ', '메신저', 'SK 프라이든', '참여', 'O', 230, 'Y', ''),
    ('QSPL', '메신저', 'SK 프라이든', '떠남', 'O', 231, 'Y', ''),
    ('QSBC', '메신저', 'SK 비즈', '채팅', 'O', 232, 'N', ''),
    ('QSBF', '메신저', 'SK 비즈', '파일전송', 'O', 233, 'N', ''),
    ('QSBM', '메신저', 'SK 비즈', '쪽지', 'O', 234, 'N', ''),
    ('QWJC', '메신저', '웅진', '채팅', 'O', 235, 'Y', ''),
    ('QWJF', '메신저', '웅진', '파일전송', 'O', 236, 'Y', ''),
    ('QWJM', '메신저', '웅진', '쪽지', 'O', 237, 'Y', ''),
    ('QGPC', '메신저', 'ChatGPT', '채팅', 'O', 238, 'Y', ''),
    ('QDAC', '메신저', 'Dall-E', '채팅', 'O', 239, 'Y', ''),
    ('QDAF', '메신저', 'Dall-E', '파일전송', 'O', 240, 'Y', ''),
    ('QCLC', '메신저', '쿨', '채팅', 'O', 241, 'Y', 'MSG'),
    ('QCLF', '메신저', '쿨', '파일전송', 'O', 242, 'Y', 'MSG'),
    ('QCLM', '메신저', '쿨', '쪽지', 'O', 243, 'Y', 'MSG'),
    ('QCLJ', '메신저', '쿨', '참여', 'O', 244, 'Y', 'MSG'),
    ('QCLL', '메신저', '쿨', '떠남', 'O', 245, 'Y', 'MSG'),
    ('QKBC', '메신저', 'K-bond', '채팅', 'O', 246, 'Y', 'MSG'),
    ('QKBF', '메신저', 'K-bond', '파일전송', 'O', 247, 'Y', 'MSG'),
    ('QKBM', '메신저', 'K-bond', '쪽지', 'O', 248, 'Y', 'MSG'),
    ('QKBJ', '메신저', 'K-bond', '참여', 'O', 249, 'Y', 'MSG'),
    ('QKBL', '메신저', 'K-bond', '떠남', 'O', 250, 'Y', 'MSG'),
    ('QEKC', '메신저', '아이콘', '채팅', 'O', 251, 'Y', 'MSG'),
    ('QEKF', '메신저', '아이콘', '파일전송', 'O', 252, 'Y', 'MSG'),
    ('QEKJ', '메신저', '아이콘', '참여', 'O', 253, 'Y', 'MSG'),
    ('QEKL', '메신저', '아이콘', '떠남', 'O', 254, 'Y', 'MSG'),
    ('QEKH', '메신저', '아이콘', '과거 데이터', 'O', 255, 'Y', 'MSG'),
    ('QSLC', '메신저', 'Slack', '채팅', 'O', 256, 'Y', 'MSG'),
    ('QSLF', '메신저', 'Slack', '파일전송', 'O', 257, 'Y', 'MSG'),
    ('QSLJ', '메신저', 'Slack', '참여', 'O', 258, 'Y', 'MSG'),
    ('QSLL', '메신저', 'Slack', '떠남', 'O', 259, 'Y', 'MSG'),
    ('QSYC', '메신저', '신영자산운용', '채팅', 'O', 260, 'Y', 'MSG'),
    ('QSYF', '메신저', '신영자산운용', '파일전송', 'O', 261, 'Y', 'MSG'),
    ('QSYM', '메신저', '신영자산운용', '쪽지', 'O', 262, 'Y', 'MSG'),
    ('QSYJ', '메신저', '신영자산운용', '참여', 'O', 263, 'Y', 'MSG'),
    ('QSYL', '메신저', '신영자산운용', '떠남', 'O', 264, 'Y', 'MSG'),
    ('QFBC', '메신저', '페이스북', '채팅', 'O', 265, 'Y', 'MSG'),
    ('QFBF', '메신저', '페이스북', '파일전송', 'O', 266, 'Y', 'MSG'),
    ('QKMC', '메신저', '삼성KnoxMessenger', '채팅', 'O', 267, 'Y', 'MSG'),
    ('QKMF', '메신저', '삼성KnoxMessenger', '파일전송', 'O', 268, 'Y', 'MSG'),
    ('QKMR', '메신저', '삼성KnoxMessenger', '파일수신', 'I', 269, 'Y', 'MSG'),
    ('QKMW', '메신저', '삼성KnoxMessenger', '전달', 'O', 270, 'Y', 'MSG'),
    ('QKMV', '메신저', '삼성KnoxMessenger', '파일-미리보기', 'O', 271, 'Y', 'MSG'),
    ('QGHC', '메신저', '구글 Hangout', '채팅', 'O', 272, 'Y', 'MSG'),
    ('QGHF', '메신저', '구글 Hangout', '파일전송', 'O', 273, 'Y', 'MSG'),
    ('QGGC', '메신저', '구글 chat', '채팅', 'O', 274, 'Y', 'MSG'),
    ('QGGF', '메신저', '구글 chat', '파일전송', 'O', 275, 'Y', 'MSG'),
    ('QGMC', '메신저', '구글 Meet', '채팅', 'O', 276, 'Y', 'MSG'),
    ('QGBC', '메신저', '구글 Bard', '채팅', 'O', 277, 'Y', 'MSG'),
    ('QBIC', '메신저', 'Microsoft BingAI Chat', '채팅', 'O', 278, 'Y', 'MSG'),
    ('QWTC', '메신저', 'Wrtn', '채팅', 'O', 279, 'Y', ''),
    ('QISC', '메신저', '인스타그램 DM', '채팅', 'O', 280, 'Y', 'MSG'),
    ('QISF', '메신저', '인스타그램 DM', '파일전송', 'O', 281, 'Y', 'MSG'),
    ('QZAC', '메신저', 'Zalo', '채팅', 'O', 282, 'Y', 'MSG'),
    ('QZAF', '메신저', 'Zalo', '파일전송', 'O', 283, 'Y', 'MSG'),
    ('QNBC', '메신저', '네이버 밴드 채팅', '채팅', 'O', 284, 'Y', 'MSG'),
    ('QNBF', '메신저', '네이버 밴드 채팅', '파일전송', 'O', 285, 'Y', 'MSG'),
    ('QDOC', '메신저', 'Dooray app', '채팅', 'O', 286, 'Y', 'MSG'),
    ('QDOF', '메신저', 'Dooray app', '파일전송', 'O', 287, 'Y', 'MSG'),
    ('QUKC', '메신저', '기타', '채팅', 'O', 288, 'Y', 'MSG'),
    ('QUKF', '메신저', '기타', '파일전송', 'O', 289, 'Y', 'MSG'),
    ('QUKM', '메신저', '기타', '쪽지', 'O', 290, 'Y', 'MSG'),
    ('QUKJ', '메신저', '기타', '참여', 'O', 291, 'Y', 'MSG'),
    ('QUKL', '메신저', '기타', '떠남', 'O', 292, 'Y', 'MSG'),
    ('QTAS', '메신저', '네이버 톡톡', '발신', 'O', 293, 'Y', ''),
    ('QTAC', '메신저', '네이버 톡톡', '채팅', 'O', 294, '', ''),
    ('QTAF', '메신저', '네이버 톡톡', '파일전송', 'O', 295, '', ''),
    ('FFTC', '파일전송', 'FTP', 'CMD', 'O', 296, 'Y', ''),
    ('FFTG', '파일전송', 'FTP', 'GET', 'I', 297, 'Y', ''),
    ('FFTP', '파일전송', 'FTP', 'PUT', 'O', 298, 'Y', ''),
    ('FFTL', '파일전송', 'FTP', 'CONNECT', 'O', 299, 'Y', ''),
    ('FZM-', '파일전송', 'Zmodem', '-', 'O', 300, 'Y', ''),
    ('FNVR', '파일전송', '네이버 MYBOX', '수신', 'I', 301, 'Y', ''),
    ('FNVS', '파일전송', '네이버 MYBOX', '발신', 'O', 302, 'Y', ''),
    ('FGGR', '파일전송', '구글 드라이브', '수신', 'I', 303, 'Y', ''),
    ('FGGS', '파일전송', '구글 드라이브', '발신', 'O', 304, 'Y', ''),
    ('FODR', '파일전송', 'OneDrive', '수신', 'I', 305, 'Y', ''),
    ('FODS', '파일전송', 'OneDrive', '발신', 'O', 306, 'Y', ''),
    ('FDBR', '파일전송', 'Dropbox', '수신', 'I', 307, 'Y', ''),
    ('FDBS', '파일전송', 'Dropbox', '발신', 'O', 308, 'Y', ''),
    ('F2NR', '파일전송', '2nd 드라이브', '수신', 'I', 309, 'N', ''),
    ('F2NS', '파일전송', '2nd 드라이브', '발신', 'O', 310, 'N', ''),
    ('FPSR', '파일전송', 'Polarisoffice ', '수신', 'I', 311, 'Y', ''),
    ('FPSS', '파일전송', 'Polarisoffice ', '발신', 'O', 312, 'Y', ''),
    ('FICR', '파일전송', 'Icloud', '수신', 'I', 313, 'Y', ''),
    ('FICS', '파일전송', 'Icloud', '발신', 'O', 314, 'Y', ''),
    ('FYDR', '파일전송', 'Yandex', '수신', 'I', 315, 'Y', ''),
    ('FYDS', '파일전송', 'Yandex', '발신', 'O', 316, 'Y', ''),
    ('FWHR', '파일전송', 'LG 웹하드', '수신', 'I', 317, 'Y', ''),
    ('FWHS', '파일전송', 'LG 웹하드', '발신', 'O', 318, 'Y', ''),
    ('FGIR', '파일전송', 'GitHub', '수신', 'I', 319, 'Y', ''),
    ('FGIS', '파일전송', 'GitHub', '발신', 'O', 320, 'Y', ''),
    ('FDOR', '파일전송', 'Dooray', '수신', 'I', 321, 'Y', ''),
    ('FDOS', '파일전송', 'Dooray', '발신', 'O', 322, 'Y', ''),
    ('FWES', '파일전송', 'Wetransfer', '발신', 'O', 323, 'Y', ''),
    ('FASS', '파일전송', 'AWS S3 bucket', '발신', 'O', 324, 'Y', ''),
    ('FGES', '파일전송', '구글 렌즈', '발신', 'O', 325, 'Y', ''),
    ('FTRS', '파일전송', 'File Transfer.io', '발신', 'O', 326, 'Y', ''),
    ('FCLS', '파일전송', 'pCloud Transfer', '발신', 'O', 327, 'Y', ''),
    ('FMZS', '파일전송', 'M/Z Cloud', '발신', 'O', 328, 'Y', ''),
    ('FMZR', '파일전송', 'M/Z Cloud', '수신', 'O', 329, 'Y', ''),
    ('FUKR', '파일전송', '기타', '수신', 'I', 330, 'Y', ''),
    ('FUKS', '파일전송', '기타', '발신', 'O', 331, 'Y', ''),
    ('FPTS', '파일전송', '구글 포토', '발신', 'O', 332, 'Y', ''),
    ('NENR', '노트', 'EVERNOTE', '수신', 'I', 333, 'Y', ''),
    ('NENS', '노트', 'EVERNOTE', '발신', 'O', 334, 'Y', ''),
    ('NONR', '노트', 'ONENOTE', '수신', 'I', 335, 'Y', ''),
    ('NONS', '노트', 'ONENOTE', '발신', 'O', 336, 'Y', ''),
    ('NLVS', '노트', 'Outlook.com 메모', '발신', 'O', 337, 'Y', ''),
    ('NBTS', '노트', 'BIT.AI', '발신', 'O', 338, 'Y', ''),
    ('NNOS', '노트', 'Notion', '발신', 'O', 339, 'Y', ''),
    ('NGGS', '노트', '구글 docs', '발신', 'O', 340, 'Y', ''),
    ('NGTS', '노트', '구글 tasks', '발신', 'O', 341, 'Y', ''),
    ('NGKS', '노트', '구글 keep', '발신', 'O', 342, 'Y', ''),
    ('NSSR', '노트', '삼성 노트', '수신', 'I', 343, 'Y', ''),
    ('NSSS', '노트', '삼성 노트', '발신', 'O', 344, 'Y', ''),
    ('NNVS', '노트', '네이버 오피스', '발신', 'O', 345, 'Y', ''),
    ('NDBS', '노트', 'Dropbox paper', '발신', 'O', 346, 'Y', ''),
    ('NHCS', '노트', '한컴 오피스', '발신', 'O', 347, 'Y', ''),
    ('NMOS', '노트', 'MS오피스', '발신', 'O', 348, 'Y', ''),
    ('NCDS', '노트', 'Coda', '발신', 'O', 349, 'Y', ''),
    ('NNMR', '노트', '네이버 메모', '수신', 'I', 350, 'Y', ''),
    ('NNMS', '노트', '네이버 메모', '발신', 'O', 351, 'Y', ''),
    ('NCNS', '노트', 'Clova Note', '발신', 'O', 352, 'Y', ''),
    ('NGIS', '노트', 'Github Gist', '발신', 'O', 353, 'Y', ''),
    ('NSNS', '노트', 'SimpleNote', '발신', 'O', 354, 'Y', ''),
    ('NAGS', '노트', 'Agit', '발신', 'O', 355, 'Y', ''),
    ('NPSS', '노트', 'Polaris office', '발신', 'O', 356, 'Y', ''),
    ('NBOS', '노트', 'Box', '발신', 'O', 357, 'Y', ''),
    ('NCKS', '노트', 'ClickUp', '발신', 'O', 358, 'Y', ''),
    ('NGNS', '노트', 'Goodnotes', '발신', 'O', 359, 'Y', ''),
    ('NMNS', '노트', 'Milanote', '발신', 'O', 360, 'Y', ''),
    ('NZQS', '노트', 'zohocliq', '발신', 'O', 361, 'Y', ''),
    ('NMTS', '노트', 'Mentimeter', '발신', 'O', 362, 'Y', ''),
    ('NOOS', '노트', 'Goorm', '발신', 'O', 363, 'Y', ''),
    ('NMIS', '노트', '밀리의서재', '발신', 'O', 364, 'Y', ''),
    ('NUKS', '노트', '기타', '발신', 'O', 365, 'Y', ''),
    ('AGCR', '일정', '구글캘린더일정', '수신', 'I', 366, 'N', ''),
    ('AGCS', '일정', '구글캘린더일정', '발신', 'O', 367, 'Y', ''),
    ('AGLR', '일정', '구글캘린더메일', '수신', 'I', 368, 'N', ''),
    ('AGLS', '일정', '구글캘린더메일', '발신', 'O', 369, 'Y', ''),
    ('ANCS', '일정', '네이버 캘린더', '발신', 'O', 370, 'Y', ''),
    ('ZTN-', '기타 서비스', 'Telnet', '-', 'O', 371, 'Y', ''),
    ('ZXT-', '기타 서비스', 'Xterm', '-', 'O', 372, 'Y', ''),
    ('ZRL-', '기타 서비스', 'R-Login', '-', 'O', 373, 'Y', ''),
    ('ZNP-', '기타 서비스', 'NNTP', '-', 'O', 374, 'Y', ''),
    ('ZPC-', '기타 서비스', 'PC 보안', '-', 'O', 375, 'N', ''),
    ('ZSH-', '기타 서비스', 'SSH', 'SSH 세션 정보', 'O', 376, 'Y', ''),
    ('XX1R', '모니터링_제외', '미분류_타입1', '수신', 'I', 377, 'Y', ''),
    ('XX1S', '모니터링_제외', '미분류_타입1', '발신', 'O', 378, 'Y', ''),
    ('XX2R', '모니터링_제외', '미분류_타입2', '수신', 'I', 379, 'Y', ''),
    ('XX2S', '모니터링_제외', '미분류_타입2', '발신', 'O', 380, 'Y', ''),
    ('XX3R', '모니터링_제외', '미분류_타입3', '수신', 'I', 381, 'Y', ''),
    ('XX3S', '모니터링_제외', '미분류_타입3', '발신', 'O', 382, 'Y', ''),
    ('XU1R', '모니터링_제외', '웹서비스(미분류)_타입1', '수신', 'I', 383, 'Y', ''),
    ('XU1S', '모니터링_제외', '웹서비스(미분류)_타입1', '발신', 'O', 384, 'Y', ''),
    ('XU2R', '모니터링_제외', '웹서비스(미분류)_타입2', '수신', 'I', 385, 'Y', ''),
    ('XU2S', '모니터링_제외', '웹서비스(미분류)_타입2', '발신', 'O', 386, 'Y', ''),
    ('XU3R', '모니터링_제외', '웹서비스(미분류)_타입3', '수신', 'I', 387, 'Y', ''),
    ('XU3S', '모니터링_제외', '웹서비스(미분류)_타입3', '발신', 'O', 388, 'Y', ''),
    ('UWSD', '웹서비스(미분류)', '웹 발신', '첨부 - 문서타입', 'O', 389, 'Y', ''),
    ('UWSE', '웹서비스(미분류)', '웹 발신', '첨부 - 문서아님', 'O', 390, 'Y', ''),
    ('UWSU', '웹서비스(미분류)', '웹 발신', '첨부 없음', 'O', 391, 'Y', ''),
    ('UWSH', '웹서비스(미분류)', '웹 발신', '중요도(상)', 'O', 392, 'Y', ''),
    ('UWSM', '웹서비스(미분류)', '웹 발신', '중요도(중)', 'O', 393, 'Y', ''),
    ('UWSL', '웹서비스(미분류)', '웹 발신', '중요도(하)', 'O', 394, 'Y', ''),
    ('UX1R', '웹서비스(미분류)', '미분류_타입1', '수신', 'I', 395, 'Y', ''),
    ('UX1S', '웹서비스(미분류)', '미분류_타입1', '발신', 'O', 396, 'Y', ''),
    ('UX2R', '웹서비스(미분류)', '미분류_타입2', '수신', 'I', 397, 'Y', ''),
    ('UX2S', '웹서비스(미분류)', '미분류_타입2', '발신', 'O', 398, 'Y', ''),
    ('UX3R', '웹서비스(미분류)', '미분류_타입3', '수신', 'I', 399, 'Y', ''),
    ('UX3S', '웹서비스(미분류)', '미분류_타입3', '발신', 'O', 400, 'Y', ''),
    ('UWRD', '웹서비스(미분류)', '웹 수신', '첨부 - 문서타입', 'I', 401, 'Y', ''),
    ('UWRE', '웹서비스(미분류)', '웹 수신', '첨부 - 문서아님', 'I', 402, 'Y', ''),
    ('UWRU', '웹서비스(미분류)', '웹 수신', '첨부 없음', 'I', 403, 'Y', ''),
    ('BWSD', '웹서비스(업무)', '업무 발신', '첨부 - 문서타입', 'O', 404, 'Y', ''),
    ('BWSE', '웹서비스(업무)', '업무 발신', '첨부 - 문서아님', 'O', 405, 'Y', ''),
    ('BWSU', '웹서비스(업무)', '업무 발신', '첨부 없음', 'O', 406, 'Y', ''),
    ('BWRD', '웹서비스(업무)', '업무 수신', '첨부 - 문서타입', 'I', 407, 'Y', ''),
    ('BWRE', '웹서비스(업무)', '업무 수신', '첨부 - 문서아님', 'I', 408, 'Y', ''),
    ('BWRU', '웹서비스(업무)', '업무 수신', '첨부 없음', 'I', 409, 'Y', ''),
    ('TWEC', '화상회의', 'Webex', '채팅', 'O', 410, 'Y', 'MSG'),
    ('TWEF', '화상회의', 'Webex', '파일전송', 'O', 411, 'Y', 'MSG'),
    ('TWEJ', '화상회의', 'Webex', '참여', 'O', 412, 'Y', 'MSG'),
    ('TWEL', '화상회의', 'Webex', '떠남', 'O', 413, 'Y', 'MSG'),
    ('TZOC', '화상회의', 'Zoom', '채팅', 'O', 414, 'Y', 'MSG'),
    ('TZOF', '화상회의', 'Zoom', '파일전송', 'O', 415, 'Y', 'MSG'),
    ('TZOJ', '화상회의', 'Zoom', '참여', 'O', 416, 'Y', 'MSG'),
    ('TZOL', '화상회의', 'Zoom', '떠남', 'O', 417, 'Y', 'MSG'),
    ('TTMC', '화상회의', 'Teams', '채팅', 'O', 418, 'Y', 'MSG'),
    ('TTMF', '화상회의', 'Teams', '파일전송', 'O', 419, 'Y', 'MSG'),
    ('TTMJ', '화상회의', 'Teams', '참여', 'O', 420, 'Y', 'MSG'),
    ('TTML', '화상회의', 'Teams', '떠남', 'O', 421, 'Y', 'MSG'),
    ('TSKC', '화상회의', 'Skype', '채팅', 'O', 422, 'Y', 'MSG'),
    ('TSKF', '화상회의', 'Skype', '파일전송', 'O', 423, 'Y', 'MSG'),
    ('TSKJ', '화상회의', 'Skype', '참여', 'O', 424, 'Y', 'MSG'),
    ('TSKL', '화상회의', 'Skype', '떠남', 'O', 425, 'Y', 'MSG'),
    ('TJMC', '화상회의', 'JoinME', '채팅', 'O', 426, 'Y', 'MSG'),
    ('TJMF', '화상회의', 'JoinME', '파일전송', 'O', 427, 'Y', 'MSG'),
    ('TAMC', '화상회의', 'Amazon Chime', '채팅', 'O', 428, 'Y', 'MSG'),
    ('TAMF', '화상회의', 'Amazon Chime', '파일전송', 'O', 429, 'Y', 'MSG'),
    ('TBJC', '화상회의', 'BlueJeans', '채팅', 'O', 430, 'Y', 'MSG'),
    ('TTDS', '화상회의', 'Tl;dv', '채팅', 'O', 431, 'Y', 'MSG'),
    ('LNVS', '번역기', '파파고 번역', '발신', 'O', 432, 'Y', ''),
    ('LGGS', '번역기', '구글 번역', '발신', 'O', 433, 'Y', ''),
    ('LGPS', '번역기', '구글 번역 플러그인', '발신', 'O', 434, 'Y', ''),
    ('LDES', '번역기', 'Deepl', '발신', 'O', 435, 'Y', ''),
    ('LBIS', '번역기', 'Bing 번역', '발신', 'O', 436, 'Y', ''),
    ('LYMS', '번역기', 'Yandex 번역', '발신', 'O', 437, 'Y', ''),
    ('LGAS', '번역기', 'Google Cloud Translation Api', '발신', 'O', 438, 'Y', ''),
    ('LFTS', '번역기', 'Flitto', '발신', 'O', 439, 'Y', ''),
    ('LOTS', '번역기', 'O-Translator', '발신', 'O', 440, 'Y', ''),
    ('LUKS', '번역기', '기타', '발신', 'I', 441, 'Y', ''),
    ('IGBS', '생성형 AI', '구글 Gemini', '발신', 'O', 442, 'Y', ''),
    ('IBIS', '생성형 AI', ' Microsoft Copilot', '발신', 'O', 443, 'Y', ''),
    ('IWTS', '생성형 AI', 'Wrtn', '발신', 'O', 444, 'Y', ''),
    ('IGPS', '생성형 AI', 'ChatGPT', '발신', 'O', 445, 'Y', ''),
    ('IDAS', '생성형 AI', 'Dall-E', '발신', 'O', 446, 'Y', ''),
    ('IGCS', '생성형 AI', 'Github Copilot', '발신', 'I', 447, 'Y', ''),
    ('IYCS', '생성형 AI', 'YouChat', '발신', 'I', 448, 'Y', ''),
    ('ICSS', '생성형 AI', 'Chatsonic', '발신', 'I', 449, 'Y', ''),
    ('IRPS', '생성형 AI', 'Replika', '발신', 'I', 450, 'Y', ''),
    ('IPPS', '생성형 AI', 'Perplexity', '발신', 'I', 451, 'Y', ''),
    ('ITCS', '생성형 AI', 'TextCortex', '발신', 'I', 452, 'Y', ''),
    ('IPHS', '생성형 AI', 'Phind', '발신', 'I', 453, 'Y', ''),
    ('IPOS', '생성형 AI', 'Poe', '발신', 'I', 454, 'Y', ''),
    ('IHFS', '생성형 AI', 'Hugging Face', '발신', 'I', 455, 'Y', ''),
    ('ICPS', '생성형 AI', 'Copy.AI', '발신', 'I', 456, 'Y', ''),
    ('IHWS', '생성형 AI', 'HyperWrite', '발신', 'I', 457, 'Y', ''),
    ('IDPS', '생성형 AI', 'DeepAI', '발신', 'I', 458, 'Y', ''),
    ('IACS', '생성형 AI', 'AskCodi', '발신', 'I', 459, 'Y', ''),
    ('INAS', '생성형 AI', 'Native', '발신', 'I', 460, 'Y', ''),
    ('INFS', '생성형 AI', 'NeuroFlash', '발신', 'I', 461, 'Y', ''),
    ('INOS', '생성형 AI', 'Notion AI', '발신', 'I', 462, 'Y', ''),
    ('IMES', '생성형 AI', 'Merlin', '발신', 'I', 463, 'Y', ''),
    ('ICXS', '생성형 AI', 'CLOVA-X', '발신', 'I', 464, 'Y', ''),
    ('IADS', '생성형 AI', 'Adobe AI', '발신', 'I', 465, 'Y', ''),
    ('ICDS', '생성형 AI', 'ClipDrop', '발신', 'I', 466, 'Y', ''),
    ('ISBS', '생성형 AI', 'Stability.Ai', '발신', 'I', 467, 'Y', ''),
    ('IRMS', '생성형 AI', 'Runwayml', '발신', 'I', 468, 'Y', ''),
    ('IGVS', '생성형 AI', 'Google Vertex', '발신', 'I', 469, 'Y', ''),
    ('IGLS', '생성형 AI', 'Google Colab', '발신', 'I', 470, 'Y', ''),
    ('ICWS', '생성형 AI', 'CodeWhisperer', '발신', 'I', 471, 'Y', ''),
    ('IMSS', '생성형 AI', 'Google AI Studio', '발신', 'I', 472, 'Y', ''),
    ('IOCS', '생성형 AI', 'Clova OCR', '발신', 'I', 473, 'Y', ''),
    ('IAOS', '생성형 AI', 'Azure OpenAI', '발신', 'I', 474, 'Y', ''),
    ('ICUS', '생성형 AI', '네이버 CUE:', '발신', 'I', 475, 'Y', ''),
    ('IMJS', '생성형 AI', 'Midjourney', '발신', 'I', 476, 'Y', ''),
    ('ISGR', '생성형 AI', 'slidesGPT', '수신', 'I', 477, 'Y', ''),
    ('ISGS', '생성형 AI', 'SlidesGPT', '발신', 'I', 478, 'Y', ''),
    ('IDMS', '생성형 AI', 'Ai Docmaker', '발신', 'I', 479, 'Y', ''),
    ('IRKS', '생성형 AI', 'Reka AI', '발신', 'I', 480, 'Y', ''),
    ('ICLS', '생성형 AI', 'Claude', '발신', 'I', 481, 'Y', ''),
    ('IDMR', '생성형 AI', 'AI Docmaker Attach', '수신', 'I', 482, 'Y', ''),
    ('IADR', '생성형 AI', 'Adobe firefly login', '수신', 'I', 483, 'Y', ''),
    ('IWDS', '생성형 AI', 'Dream by WOMBO', '발신', 'I', 484, 'Y', ''),
    ('IGAS', '생성형 AI', 'GetImg.AI', '발신', 'I', 485, 'Y', ''),
    ('IWKS', '생성형 AI', 'Wrks.ai', '발신', 'I', 486, 'Y', ''),
    ('IPSS', '생성형 AI', 'Polaris office ai', '발신', 'I', 487, 'Y', ''),
    ('IBGS', '생성형 AI', 'Goover AI', '발신', 'I', 488, 'Y', ''),
    ('IIAS', '생성형 AI', 'iAsk AI', '발신', 'I', 489, 'Y', ''),
    ('ISNS', '생성형 AI', 'Suno AI', '발신', 'I', 490, 'Y', ''),
    ('IPES', '생성형 AI', 'Perchance', '발신', 'I', 491, 'Y', ''),
    ('IPFS', '생성형 AI', 'ChatPDF', '발신', 'I', 492, 'Y', ''),
    ('IXOS', '생성형 AI', 'Exaone', '발신', 'I', 493, 'Y', ''),
    ('ISOR', '생성형 AI', 'Slidesgo', '수신', 'I', 494, 'Y', ''),
    ('ISOS', '생성형 AI', 'Slidesgo', '발신', 'I', 495, 'Y', ''),
    ('IKRS', '생성형 AI', 'KREA', '발신', 'I', 496, 'Y', ''),
    ('ILMS', '생성형 AI', 'GoogleNotebook LM', '발신', 'I', 497, 'Y', ''),
    ('ICCS', '생성형 AI', 'Capcut', '발신', 'I', 498, 'Y', ''),
    ('IMGS', '생성형 AI', 'Magictool', '발신', 'I', 499, 'Y', ''),
    ('IGSS', '생성형 AI', 'Genspark', '발신', 'I', 500, 'Y', ''),
    ('IFES', '생성형 AI', 'felo', '발신', 'I', 501, 'Y', ''),
    ('ITPS', '생성형 AI', 'Tripo3D', '발신', 'I', 502, 'Y', ''),
    ('ITPR', '생성형 AI', 'Tripo3D', '수신', 'I', 503, 'Y', ''),
    ('IELS', '생성형 AI', 'Elevenlabs', '발신', 'I', 504, 'Y', ''),
    ('IELR', '생성형 AI', 'Elevenlabs', '수신', 'I', 505, 'Y', ''),
    ('IGRS', '생성형 AI', 'Grammarly', '발신', 'I', 506, 'Y', ''),
    ('IVRS', '생성형 AI', 'Vrew', '발신', 'I', 507, 'Y', ''),
    ('INIS', '생성형 AI', 'NightCafe', '발신', 'I', 508, 'Y', ''),
    ('ICAS', '생성형 AI', 'CivitAI', '발신', 'I', 509, 'Y', ''),
    ('ILIS', '생성형 AI', 'Liner', '발신', 'I', 510, 'Y', ''),
    ('IBCS', '생성형 AI', 'Bing Image Creator', '발신', 'I', 511, 'Y', ''),
    ('IDSS', '생성형 AI', 'Deepseek', '발신', 'I', 512, 'Y', ''),
    ('IBDS', '생성형 AI', 'Baidu Ai', '발신', 'I', 513, 'Y', ''),
    ('IGIS', '생성형 AI', 'Gemini AI api', '발신', 'I', 514, 'Y', ''),
    ('IDTS', '생성형 AI', '에이닷', '발신', 'I', 515, 'Y', ''),
    ('IQBS', '생성형 AI', 'QuillBot', '발신', 'I', 516, 'Y', ''),
    ('ICHC', '생성형 AI', 'Character.ai', '발신', 'I', 517, 'Y', ''),
    ('ISRS', '생성형 AI', 'Sora/Openai', '발신', 'I', 518, 'Y', ''),
    ('ISRR', '생성형 AI', 'Sora/Openai', '수신', 'O', 519, '', ''),
    ('INNS', '생성형 AI', 'Nano AI', '발신', 'I', 520, 'Y', ''),
    ('IDBS', '생성형 AI', 'Doubao', '발신', 'I', 521, 'Y', ''),
    ('ITYS', '생성형 AI', 'Tongyi', '발신', 'I', 522, 'Y', ''),
    ('IYBS', '생성형 AI', 'Yuanbao', '발신', 'I', 523, 'Y', ''),
    ('IYYS', '생성형 AI', 'Yiyan', '발신', 'I', 524, 'Y', ''),
    ('IKMS', '생성형 AI', 'Kimi', '발신', 'I', 525, 'Y', ''),
    ('IBAS', '생성형 AI', 'Baichuan', '발신', 'I', 526, 'Y', ''),
    ('ITGS', '생성형 AI', 'Tiangong', '발신', 'I', 527, 'Y', ''),
    ('ISDS', '생성형 AI', 'Stable Diffusion', '발신', 'I', 528, 'Y', ''),
    ('IGOS', '생성형 AI', 'Grok', '발신', 'I', 529, 'Y', ''),
    ('ICGS', '생성형 AI', 'ChatGLM', '발신', 'I', 530, 'Y', ''),
    ('INKS', '생성형 AI', 'Napkin AI', '발신', 'I', 531, 'Y', ''),
    ('IBIR', '생성형 AI', 'Microsoft Copilot(Chat)', '수신', 'I', 532, 'Y', ''),
    ('IOOS', '생성형 AI', 'AI Goormee', '발신', 'I', 533, 'Y', ''),
    ('IABS', '생성형 AI', 'Allibee', '발신', 'I', 534, 'Y', ''),
    ('ILXS', '생성형 AI', 'Lexis+', '발신', 'I', 535, 'Y', ''),
    ('ILAS', '생성형 AI', 'SuperLawyer', '발신', 'I', 536, 'Y', ''),
    ('ICOS', '생성형 AI', 'CoCounsel', '발신', 'I', 537, 'Y', ''),
    ('IANS', '생성형 AI', 'Anthropic', '발신', 'I', 538, 'Y', ''),
    ('ISIS', '생성형 AI', 'Sider AI', '발신', 'I', 539, 'Y', ''),
    ('IGMS', '생성형 AI', 'Gamma', '발신', 'I', 540, 'Y', ''),
    ('IGMR', '생성형 AI', 'Gamma', '수신', 'I', 541, 'Y', ''),
    ('ICRS', '생성형 AI', 'Cursor', '발신', 'I', 542, 'Y', ''),
    ('IMAS', '생성형 AI', 'ManusAI', '발신', 'I', 543, 'Y', ''),
    ('IMTS', '생성형 AI', 'Mistral AI', '발신', 'I', 544, 'Y', ''),
    ('ICBS', '생성형 AI', 'Cline', '발신', 'I', 545, 'Y', ''),
    ('IWBS', '생성형 AI', 'Weight & Biases', '발신', 'I', 546, 'Y', ''),
    ('IWBR', '생성형 AI', 'Weight & Biases', '수신', 'I', 547, 'Y', ''),
    ('ILLS', '생성형 AI', 'Lilys AI', '발신', 'I', 548, 'Y', ''),
    ('IUKS', '생성형 AI', '기타', '발신', 'I', 549, 'Y', ''),
    ('IGES', '생성형 AI', 'Gemini Code Assist', '발신', 'O', 550, 'Y', ''),
    ('IOES', '생성형 AI', 'Codex/OpenAI', '발신', 'O', 551, 'Y', ''),
    ('IJLS', '생성형 AI', 'Jules', '발신', 'O', 552, 'Y', ''),
    ('IHVS', '생성형 AI', 'Harvey', '발신', 'O', 553, 'Y', ''),
    ('IXAS', '생성형 AI', 'x.AI', '발신', 'O', 554, '', ''),
    ('ICES', '생성형 AI', 'Cohere', '발신', 'O', 555, '', ''),
    ('PDOS', '프로젝트', 'dooray', '발신', 'O', 556, 'Y', ''),
    ('PGIS', '프로젝트', 'github', '발신', 'O', 557, 'Y', ''),
    ('PGLS', '프로젝트', 'Glassdoor', '발신', 'O', 558, 'Y', ''),
    ('PJDS', '프로젝트', '잔디', '발신', 'O', 559, 'Y', ''),
    ('PITS', '프로젝트', 'Google Issue Tracker', '발신', 'O', 560, 'Y', ''),
    ('EBDR', '그룹웨어', '게시', '수신', 'I', 561, 'Y', ''),
    ('EBD-', '그룹웨어', '게시', '발신', 'O', 562, 'Y', ''),
    ('EBBR', '그룹웨어', '게시판', '수신', 'I', 563, 'Y', ''),
    ('EBBS', '그룹웨어', '게시판', '발신', 'O', 564, 'Y', ''),
    ('EBBF', '그룹웨어', '게시판', '파일수신', 'I', 565, 'Y', ''),
    ('EAAR', '그룹웨어', '결재', '수신', 'I', 566, 'Y', ''),
    ('EAAS', '그룹웨어', '결재', '발신', 'O', 567, 'Y', ''),
    ('EAAG', '그룹웨어', '결재', '통보 - 수신', 'I', 568, 'Y', ''),
    ('EAAP', '그룹웨어', '결재', '통보 - 발신', 'O', 569, 'Y', ''),
    ('EAAF', '그룹웨어', '결재', '파일수신', 'I', 570, 'Y', ''),
    ('EMMR', '그룹웨어', '메일', '그룹웨어 수신', 'I', 571, 'Y', ''),
    ('EMMS', '그룹웨어', '메일', '그룹웨어 발신', 'O', 572, 'Y', ''),
    ('EMMG', '그룹웨어', '메일', 'OWA 수신', 'I', 573, 'Y', ''),
    ('EMMP', '그룹웨어', '메일', 'OWA 발신', 'O', 574, 'Y', ''),
    ('EMMD', '그룹웨어', '메일', 'RPC 수신', 'I', 575, 'Y', ''),
    ('EMMU', '그룹웨어', '메일', 'RPC 발신', 'O', 576, 'Y', ''),
    ('EMMC', '그룹웨어', '메일', '수신', 'I', 577, 'Y', ''),
    ('EMML', '그룹웨어', '메일', '발신', 'O', 578, 'Y', ''),
    ('EMM1', '그룹웨어', '메일', '보안등급1', 'O', 579, 'Y', ''),
    ('EMM2', '그룹웨어', '메일', '보안등급2', 'O', 580, 'Y', ''),
    ('EMM3', '그룹웨어', '메일', '보안등급3', 'O', 581, 'Y', ''),
    ('EMM4', '그룹웨어', '메일', '보안등급4', 'O', 582, 'Y', ''),
    ('EMMA', '그룹웨어', '메일', '임시(자동)', 'O', 583, 'Y', ''),
    ('EMMT', '그룹웨어', '메일', '임시(수동)', 'O', 584, 'Y', ''),
    ('EMMK', '그룹웨어', '메일', 'Outlook - 수신', 'I', 585, 'Y', ''),
    ('EMMO', '그룹웨어', '메일', 'Outlook - 발신', 'O', 586, 'Y', ''),
    ('EMMB', '그룹웨어', '메일', '그룹웨어 예약메일', 'O', 587, 'Y', ''),
    ('EMBR', '그룹웨어', '모바일', '수신', 'I', 588, 'Y', ''),
    ('EMB-', '그룹웨어', '모바일', '발신', 'O', 589, 'Y', ''),
    ('EWSR', '그룹웨어', '웹서비스', '수신', 'I', 590, 'Y', ''),
    ('EWS-', '그룹웨어', '웹서비스', '발신', 'O', 591, 'Y', ''),
    ('EPUR', '그룹웨어', '일반', '수신', 'I', 592, 'Y', ''),
    ('EPU-', '그룹웨어', '일반', '발신', 'O', 593, 'Y', ''),
    ('EAU-', '그룹웨어', '일반(자동전달)', '자동전달', 'O', 594, 'Y', ''),
    ('ESCR', '그룹웨어', '일정 명함', '수신', 'I', 595, 'Y', ''),
    ('ESC-', '그룹웨어', '일정 명함', '발신', 'O', 596, 'Y', ''),
    ('EMF-', '그룹웨어', '파일 다운로드', '-', 'I', 597, 'Y', ''),
    ('EMU-', '그룹웨어', '기타', '', 'O', 598, 'Y', ''),
    ('EMDR', '그룹웨어', '드라이브', '수신', 'I', 599, 'Y', ''),
    ('EMDS', '그룹웨어', '드라이브', '발신', 'O', 600, 'Y', ''),
    ('ECIS', '그룹웨어', 'Samsung cic', '발신', 'O', 601, 'Y', ''),
    ('EMER', '그룹웨어', '메신저', '수신', 'O', 602, 'Y', ''),
    ('EMES', '그룹웨어', '메신저', '발신', 'O', 603, 'Y', ''),
    ('EZQC', '그룹웨어', 'Zohocliq', '채팅', 'O', 604, 'Y', ''),
    ('EZQS', '그룹웨어', 'Zohocliq', '캘린더', 'O', 605, 'Y', ''),
    ('EKWS', '그룹웨어', '카카오워크', '발신', 'O', 606, 'Y', ''),
    ('DCCS', '편집기', 'Clip Champ', '발신', 'O', 607, 'Y', ''),
    ('DFGS', '편집기', 'Figma', '발신', 'O', 608, 'Y', ''),
    ('DOVS', '편집기', 'Overleaf', '발신', 'O', 609, 'Y', ''),
    ('DOVR', '편집기', 'Overleaf', '수신', 'O', 610, 'Y', ''),
    ('DPKS', '편집기', 'Plunker', '발신', 'O', 611, 'Y', ''),
    ('DNWS', '편집기', 'Namu.wiki', '발신', 'O', 612, 'Y', ''),
    ('DWKS', '편집기', 'WikiPedia', '발신', 'O', 613, 'Y', ''),
    ('DAES', '편집기', 'Adobe Express', '발신', 'O', 614, 'Y', ''),
    ('DSMS', '편집기', 'Sketchmon', '발신', 'O', 615, 'Y', ''),
    ('DGSS', '편집기', 'Google Site', '발신', 'O', 616, 'Y', ''),
    ('JBDS', '웹사이트', 'Baidu', '발신', 'O', 617, 'Y', ''),
    ('JANS', '웹사이트', 'Anthropic', '발신', 'O', 618, 'Y', ''),
    ('RGUS', '원격접속', '아파치 과카몰리', '발신', 'O', 619, 'Y', '');



INSERT
IGNORE INTO `UI_FILTER`(`FILTER_SEQ`,`P_FILTER_SEQ`,`FILTER_NM`,`FILTER_TYPE`,`FILTER_ORDER`,`FILTER_OPEN`,`USER_DT_CD`,`START_DT`,`END_DT`,`CONDITIONS`) values (0,-1,'기본제공 - 필터','R',0,null,'','','','');
INSERT
IGNORE INTO `UI_FILTER`(`FILTER_SEQ`,`P_FILTER_SEQ`,`FILTER_NM`,`FILTER_TYPE`,`FILTER_ORDER`,`FILTER_OPEN`,`USER_DT_CD`,`START_DT`,`END_DT`,`CONDITIONS`) values (1000,-1,'사용자 정의 - 필터','U',0,null,'','','','');


INSERT
IGNORE INTO `UI_CO`(`COCD`,`CONM`) values ('C00-00','미분류');
INSERT
IGNORE INTO `UI_BUSI`(`BUSICD`,`BUSINM`,`COCD`) values ('C00-00','미분류','C00-00');
INSERT
IGNORE INTO `UI_GENERAL`(`GENERALCD`,`GENERALNM`,`COCD`) values ('C00-00','미분류','C00-00');
INSERT
IGNORE INTO `UI_DEPT`(`DEPTCD`,`DEPTNM`,`PDEPTCD`,`COCD`) values ('C00-00','미분류','','C00-00');
INSERT
IGNORE INTO `UI_JIKGUB`(`JIKGUBCD`,`JIKGUBNM`) values ('C00-00','미분류');
INSERT
IGNORE INTO `UI_JIKIN`(`JIKINCD`,`JIKINNM`) values ('C00-00','미분류');




/* UI_ATTACH  첨부파일 코드 */

INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('3GP', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('7Z', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('A0', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ACCDA', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ACCDB', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ACCDE', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ACCDT', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ACE', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ADE', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ADP', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('AIF', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('AIFF', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ALZ', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ANI', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ARJ', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ASF', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ASP', 'HTML', 'HTML');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ASV', 'WORD', 'WORD');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ASX', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('AU', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('AVI', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('BAK', 'BACKUP', 'BACKUP');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('BAT', '텍스트', '텍스트');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('BKG', '훈민정음', '훈민정음');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('BMP', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('CAB', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('CAP', '텍스트', '텍스트');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('CDA', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('CELL', '아래한글', '아래한글');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('CFG', '텍스트', '텍스트');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('CGM', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('CLASS', 'JAVA', 'JAVA');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('CMX', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('COM', 'UNKNOWN', 'UNKNOWN');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('CPL', 'UNKNOWN', 'UNKNOWN');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('CSV', '텍스트', '텍스트');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('CUR', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DAT', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DB', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DBF', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DCX', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DDS', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DEB', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DGN', 'CAD', 'CAD');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DLL', 'DLL', 'DLL');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DMG', '이미지굽기', '이미지굽기');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DNG', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DOC', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DOCM', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DOCX', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DOT', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DOTM', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DOTX', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DRV', 'DRIVER', 'DRIVER');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DRW', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DWG', 'CAD', 'CAD');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('DXF', 'CAD', 'CAD');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('EML', 'E-Mail', 'E-Mail');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('EXE', 'UNKNOWN', 'UNKNOWN');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('FLV', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('GIF', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('GUL', '훈민정음', '훈민정음');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('GZ', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('GZIP', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('HAD', 'DB', 'DB');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('HCDT', '아래한글', '아래한글');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('HFT', '아래한글', '아래한글');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('HLP', 'HELP', 'HELP');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('HML', '아래한글', '아래한글');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('HPT', '아래한글', '아래한글');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('HSDT', '아래한글', '아래한글');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('HTHEME', '아래한글', '아래한글');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('HTM', 'HTML', 'HTML');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('HTML', 'HTML', 'HTML');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('HWP', '아래한글', '아래한글');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('HWT', '아래한글', '아래한글');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ICO', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('IFF', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('IMG', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('INF', '텍스트', '텍스트');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('INI', '텍스트', '텍스트');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ISO', '이미지굽기', '이미지굽기');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('JAVA', 'JAVA', 'JAVA');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('JPEG', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('JPG', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('KDC', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('KWP', 'WORD', 'WORD');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('LBM', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('LOG', '텍스트', '텍스트');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('LZH', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('M3U', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('M4A', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MA', '3D Image', '3D Image');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MDA', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MDB', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MDE', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MDZ', 'DB', 'DB');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MID', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MOD', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MOV', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MP1', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MP2', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MP3', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MP4', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MPA', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MPEG', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MPG', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MSG', 'E-Mail', 'E-Mail');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('MYSINGLE', 'E-Mail', 'E-Mail');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('NVRAM', 'VMWARE', 'VMWARE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('NXL', '아래한글', '아래한글');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('NXT', '아래한글', '아래한글');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('OBJ', '3D Image', '3D Image');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ODC', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ODP', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ODS', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ODT', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('OLD', 'BACKUP', 'BACKUP');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('OST', 'E-Mail', 'E-Mail');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PAK', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PCD', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PCT', 'WORD', 'WORD');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PCX', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PDB', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PDF', 'PDF', 'PDF');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PIC', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PKG', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PM', 'WORD', 'WORD');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PNG', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('POT', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('POTM', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('POTX', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PPS', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PPSM', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PPSX', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PPT', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PPTM', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PPTX', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PRN', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PSD', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PSP', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PSPIMAGE', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PST', 'E-Mail', 'E-Mail');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PTF', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('PWZ', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('QT', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('RA', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('RAM', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('RAR', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('RLE', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('RM', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('RPM', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('RTF', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('SAV', '훈민정음', '훈민정음');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('SCR', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('SHOW', '아래한글', '아래한글');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('SIT', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('SITX', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('SRT', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('STL', 'CAD', 'CAD');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('STP', '3D Image', '3D Image');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('SWF', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('TAR', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('test', '3D Image', 'testtest');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('TGA', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('THM', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('TIF', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('TIFF', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('TMP', 'BACKUP', 'BACKUP');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('TOAST', '이미지굽기', '이미지굽기');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('TXT', '텍스트', '텍스트');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('UNKNOWN', 'UNKNOWN', 'UNKNOWN');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('UXDC', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('VHD', '이미지굽기', '이미지굽기');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('VMC', '이미지굽기', '이미지굽기');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('VMDK', 'VMWARE', 'VMWARE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('VMEM', 'VMWARE', 'VMWARE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('VMSD', 'VMWARE', 'VMWARE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('VMSS', 'VMWARE', 'VMWARE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('VMX', 'VMWARE', 'VMWARE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('VMXF', 'VMWARE', 'VMWARE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('VOB', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('VPCBACKUP', '이미지굽기', '이미지굽기');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('WAV', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('WBK', 'BACKUP', 'BACKUP');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('WMA', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('WMF', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('WMV', '동영상', '동영상');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('WPG', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('WRI', '텍스트', '텍스트');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('WRK', '음악', '음악');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('XLA', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('XLAM', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('XLM', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('XLR', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('XLS', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('XLSB', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('XLSM', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('XLSX', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('XLT', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('XLTM', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('XLW', 'MS-OFFICE', 'MS-OFFICE');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('YUV', '그림', '그림');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ZIP', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ZIPX', '압축', '압축');
INSERT
IGNORE INTO UI_ATTACH (ATTACH_TYPE, ATTACH_NAME, ATTACH_DESC) VALUES('ZOO', '압축', '압축');

/* UI_REGEXP */
CALL ALTER_TB( 'UI_REGEXP' , 'CODE_TYPE' , 'ALTER TABLE EMASSAI.UI_REGEXP ADD CODE_TYPE char(1) DEFAULT \'C\' NOT NULL COMMENT \'패턴 코드 타입 N:개인정보 A:이상행위의심 C:사용자 정의\'');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('AN', '주소(도로명, 지번)', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('BRN', '사업자 등록번호', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('CN', '카드번호', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('CPN', '법인 등록번호', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('CRN', '자동차 등록번호', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('DN', '운전면허번호', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('DRM', 'DRM 파일', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('FN', '외국인 등록번호', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('IMEI', 'IMEI', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('MCN', 'MAC 주소', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('MN', '휴대전화번호', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('PN', '여권번호', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('SN', '주민번호', NULL,'N');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('SSN', '사회 보장번호', NULL,'N');


 /* 이상행위의심*/
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('EC', '확장자 변조 파일', NULL,'A');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('EF', '암호화 파일', NULL,'A');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('RS', '수신처 오지정 전송', NULL,'A');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('LTO', '대용량 본문내용 사외발송', NULL,'A');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('LAO', '대용량 첨부파일 사외발송', NULL,'A');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('LF', '대용량 파일 FTP 전송', NULL,'A');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('ID', '송수신자 동일아이디', NULL,'A');

INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('LAOP', '대용량의 동일종류 첨부파일 하루 3회이상 외부전송', NULL,'A');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('FCA', '타국에서 접속', NULL,'A');
INSERT IGNORE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('AOH', '평균 접속 시간대 외의 접속', NULL,'A');





/* UI MENU */
INSERT
IGNORE INTO UI_MENU (`MENU_ID`, `MENU_DEFAULT_NAME`, `P_MENU_ID`, `PKG_TYPE`, `MENU_AUTH`, `MENU_LINK`, `MENU_ICON`, `MENU_ORDER`, `MENU_USEYN`, `MENU_IMG_PATH`)  VALUES
('ANALYSIS_FLUCTUATION', '사용량 증감 분석', 'DATA_ANALYSIS', 'L', 'M', 'analysis/usageCompare.do', 'fa fa-area-chart', 2, 'Y', NULL),
('ANALYSIS_INFO', '개인정보 유출 관계 분석', 'DATA_ANALYSIS', 'L', 'M', 'analysis/infoStat.do', 'fa fa-cube', 6, 'Y', NULL),
('ANALYSIS_SIMILARITY','AI 유사도 분석','DATA_ANALYSIS','L','S','analysis/similarity.do','fa fa-pie-chart',7,'Y',NULL),
('ANALYSIS_CUSTOM','데이터 자유 분석','DATA_ANALYSIS','L','M','analysis/dataFreedom.do','fa fa-cube',3,'Y',NULL),
('ANALYSIS_RELATION', '데이터 관계 분석', 'DATA_ANALYSIS', 'L', 'M', 'analysis/dataRelation.do', 'fa fa-share-alt', 1, 'Y', NULL),
('AUDIT_LOG', '운용자 감사 로그', 'OPERATION_MGMT', 'L', 'S', 'commons/auditLog.do', 'fa fa-pencil-square', 7, 'Y', NULL),
('BUSI_IPRANGE', '사업장 내부 IP 설정', 'ORG', 'L', 'S', 'commons/ipRange.do', 'fa fa-building', 5, 'Y', NULL),
('BUSI_IPRANGE_VIEW', '사업장 내부 IP 확인', 'IPRANGE_VIEW', 'L', 'M', 'commons/ipRangeView.do', 'fa fa-building', 2, 'Y', NULL),
('CODE_INFO', '코드 정보', 'OPERATION_MGMT', 'L', 'S', 'commons/codeInfo.do', 'fa fa-list-ul', 3, 'Y', NULL),
('CONSENT_MGMT', '동의서 관리', 'MONITOR_MGMT', 'L', 'M', 'ems/consent.do', 'fa fa-flask', 5, 'Y', NULL),
('DASHBOARD', '대시보드', NULL, 'L', 'M', 'ems/index.do', 'fa fa-dashboard', 1, 'Y', '/img/ico_gnb_01.png'),
('DASHBOARD_MENU', 'Dashboard 메뉴', 'DASHBOARD', 'L', 'M', 'ems/dashboardMenu.do', 'fa fa-sort-amount-asc', 2, 'Y', NULL),
('DASHBOARD_SETUP', 'Dashboard 관리', 'DASHBOARD', 'L', 'M', 'ems/dashboardSetup.do', 'fa fa-cogs', 3, 'Y', NULL),
('DATA_ANALYSIS', '분석', NULL, 'L', 'M', NULL, 'fa fa-area-chart', 4, 'Y', '/img/ico_gnb_05.png'),
('DATA_MONITOR', '모니터링', NULL, 'L', 'M', NULL, 'glyphicon glyphicon-list-alt', 2, 'Y', '/img/ico_gnb_02.png'),
('DATA_STAT', '통계', NULL, 'L', 'M', '', 'fa fa-area-chart', 5, 'Y', '/img/ico_gnb_04.png'),
('DEPT_IPRANGE', '부서 내부 IP 설정', 'ORG', 'L', 'S', 'commons/ipRangeDept.do', 'fa fa-building', 4, 'Y', NULL),
('DEPT_IPRANGE_VIEW', '부서 내부 IP 확인', 'IPRANGE_VIEW', 'L', 'M', 'commons/ipRangeDeptView.do', 'fa fa-building', 1, 'Y', NULL),
('DEV', '장비 관리', 'OPERATION_MGMT', 'L', 'M', NULL, 'fa fa-desktop', 1, 'Y', NULL),
('DEV_EVENTLOG', '장비 이벤트 로그', 'DEV', 'L', 'M', 'commons/eventLog.do', 'fa fa-bell', 2, 'Y', NULL),
('DEV_INFO', '장비 정보', 'DEV', 'L', 'M', 'commons/deviceInfo.do', 'fa fa-desktop', 1, 'Y', NULL),
('FILETRANSFER_SERVICE', '파일전송 모아보기', 'MESSAGE', 'L', 'M', 'ems/msg/fileTransfer.do', 'fa fa-envelope', 6, 'Y', NULL),
('GENERATIVEAI_SERVICE', '생성형AI 모아보기', 'MESSAGE', 'L', 'M', 'ems/msg/generativeAi.do', 'fa fa-envelope', 4, 'Y', NULL),
('HOLIDAY_BUSI', '사업장 업무일/휴일', 'HOLIDAY_LABEL', 'L', 'S', 'commons/holidayBusiness.do', 'fa fa-calendar-check-o', 1, 'Y', NULL),
('HOLIDAY_LABEL', '업무/휴일 설정', 'POLICY_SETUP', 'L', 'S', '', 'fa fa-calendar', 5, 'Y', NULL),
('HOLIDAY_LEGAL', '법정 공휴일', 'HOLIDAY_LABEL', 'L', 'S', 'commons/holidayLegal.do', 'fa fa-calendar-o', 2, 'Y', NULL),
('INTEREST_USER', '관심 사용자 관리', 'MONITOR_MGMT', 'L', 'M', 'ems/interestUser.do', 'fa fa-male', 1, 'Y', NULL),
('IPRANGE_VIEW', '내부 IP 정보', 'SETTING', 'L', 'M', 'commons/ipRangeDeptView.do', 'fa fa-building', 4, 'Y', NULL),
('KEYWORD_MGMT', '예약 키워드 관리', 'MONITOR_MGMT', 'L', 'M', 'ems/keywordInfo.do', 'fa fa-tasks', 2, 'Y', NULL),
('MESSAGE', '컨텐츠 모니터링', 'DATA_MONITOR', 'L', 'M', '', 'fa fa-envelope', 1, 'Y', NULL),
('MESSAGE_INFO', '메시지 정보', 'MESSAGE', 'L', 'M', 'ems/message.do', 'fa fa-envelope', 1, 'Y', NULL),
('MESSAGE_SERVICE', '메신저 모아보기', 'MESSAGE', 'L', 'M', 'ems/msg/messenger.do', 'fa fa-envelope', 3, 'Y', NULL),
('MONITOR_MGMT', '데이터 설정 관리', 'SETTING', 'L', 'M', 'ems/interestUser.do', 'fa fa-male', 2, 'Y', NULL),
('NOTE_SERVICE', '노트 모아보기', 'MESSAGE', 'L', 'M', 'ems/msg/note.do', 'fa fa-envelope', 5, 'Y', NULL),
('OPERATION_MGMT', '운용 관리', NULL, 'L', 'M', NULL, 'glyphicon glyphicon-th', 7, 'Y', '/img/ico_gnb_07.png'),
('ORG', '조직 관리', 'POLICY_SETUP', 'L', 'S', NULL, 'fa fa-users', 2, 'Y', NULL),
('ORG_MGMT', '조직 관리', 'ORG', 'L', 'S', 'commons/organizationInfo.do', 'fa fa-users', 1, 'Y', NULL),
('POLICY_MGMT', '컨텐츠 미로깅 정책', 'POLICY_SETUP', 'L', 'S', 'uacs/filterInfo.do', 'fa fa-unlink', 1, 'Y', NULL),
('POLICY_PATTERN', '패턴 예외 정책', 'POLICY_MGMT', 'L', 'S', 'uacs/patternExcept.do', 'fa fa-unlink', 2, 'Y', NULL),
('POLICY_NOLOG', '데이터 미로깅 정책', 'POLICY_MGMT', 'L', 'S', 'uacs/filterInfo.do', 'fa fa-unlink', 1, 'Y', NULL),
('POLICY_SETUP', '정책 설정', NULL, 'L', 'S', NULL, 'glyphicon glyphicon-eye-close', 6, 'Y', '/img/ico_gnb_06.png'),
('PATTERN_INFO', '패턴 관리', 'MONITOR_MGMT', 'L', 'M', 'ems/PatternInfo.do', 'fa fa-building', 4, 'Y', NULL),
('RELATION_KEYWORD', '연관 키워드 관리', 'MONITOR_MGMT', 'L', 'M', 'ems/relationKeyword.do', 'fa fa-building', 3, 'Y', NULL),
('DATA_REPORT', '보고서', NULL, 'L', 'M', NULL, 'fa fa-area-chart', 3, 'Y', '/img/ico_gnb_03.png'),
('REPORT_CONTENT', '컨텐츠 보고서', 'DATA_REPORT', 'L', 'M', 'report/contentReport.do', 'glyphicon glyphicon-list-alt', 2, 'Y', NULL),
('RESERVATION', '알림 관리', 'SETTING', 'L', 'M', 'ems/reservationAlarm.do', 'fa fa-building', 3, 'Y', NULL),
('RESERVATION_ALARM', '예약 알림', 'RESERVATION', 'L', 'M', 'ems/reservationAlarm.do', 'fa fa-calendar', 5, 'Y', NULL),
('SEARCH_LOG', '조회이력', 'OPERATION_MGMT', 'L', 'S', 'commons/searchLog.do', 'fa fa-pencil', 6, 'Y', NULL),
('STAT_ADMINREAD', '운용자 열람 통계', 'STAT_CONTENT', 'L', 'M', 'ems/adminReadStat.do', 'fa fa-pie-chart', 9, 'Y', NULL),
('STAT_SERVICEADMINREAD', '서비스 타입 운용자 열람 통계', 'STAT_CONTENT', 'L', 'M', 'ems/serviceAdminReadStat.do', 'fa fa-pie-chart', 12, 'Y', NULL),
('STAT_ATTACHNAME', '첨부 파일명 통계', 'STAT_CONTENT', 'L', 'M', 'ems/attachNameStat.do', 'fa fa-pie-chart', 7, 'Y', NULL),
('STAT_ATTACHTYPE', '첨부 파일 통계', 'STAT_CONTENT', 'L', 'M', 'ems/attachTypeStat.do', 'fa fa-pie-chart', 6, 'Y', NULL),
('STAT_CONTENT', '컨텐츠 통계', 'DATA_STAT', 'L', 'M', 'ems/usersStat.do', 'fa fa-pie-chart', 2, 'Y', NULL),
('STAT_DEVTRAFFIC', '장비 트래픽 통계', 'STAT_TRAFFIC', 'L', 'M', 'ems/trafficStat.do', 'fa fa-pie-chart', 1, 'Y', NULL),
('STAT_INFOTYPE', '정보 분류 통계', 'STAT_CONTENT', 'L', 'M', 'ems/infoTypeStat.do', 'fa fa-pie-chart', 11, 'Y', NULL),
('STAT_INTEREST', '관심 사용자 통계', 'STAT_CONTENT', 'L', 'M', 'ems/interestUserStat.do', 'fa fa-pie-chart', 2, 'Y', NULL),
('STAT_KWD', '예약어 통계', 'STAT_CONTENT', 'L', 'M', 'ems/keywordStat.do', 'fa fa-pie-chart', 5, 'Y', NULL),
('STAT_OCR', 'IMG2TXT(OCR) 처리 현황', 'STAT_CONTENT', 'L', 'M', 'ems/ocrStat.do', 'fa fa-pie-chart', 10, 'Y', NULL),
('STAT_SENDER', '발신자 통계', 'STAT_CONTENT', 'L', 'M', 'ems/senderStat.do', 'fa fa-pie-chart', 3, 'Y', NULL),
('STAT_SVC', '서비스타입 통계', 'STAT_CONTENT', 'L', 'M', 'ems/serviceStat.do', 'fa fa-pie-chart', 4, 'Y', NULL),
('STAT_TRAFFIC', '네트워크 통계', 'DATA_STAT', 'L', 'M', 'ems/trafficStat.do', 'fa fa-pie-chart', 1, 'Y', NULL),
('STAT_URL', 'URL 통계', 'STAT_CONTENT', 'L', 'M', 'ems/hostStat.do', 'fa fa-pie-chart', 8, 'Y', NULL),
('STAT_USER', '사용자 통계', 'STAT_CONTENT', 'L', 'M', 'ems/usersStat.do', 'fa fa-pie-chart', 1, 'Y', NULL),
('USER_GROUP_MGMT', '사용자 그룹', 'ORG', 'L', 'S', 'commons/userGroup.do', 'fa fa-user-circle', 3, 'Y', NULL),
('USER_MGMT', '사용자 관리', 'ORG', 'L', 'S', 'commons/userInfo.do', 'fa fa-user', 2, 'Y', NULL),
('ADMIN_MGMT','운용자 관리','OPERATION_MGMT','L','S','commons/admin.do','fa fa-unlock-alt',4,'Y',NULL),
('STAT_KEYWORDHOST','핵심 기술 키워드 탐지 HOST TOP','STAT_CONTENT','L','S','ems/keywordHost.do','fa fa-pie-chart',14,'Y',NULL),
('STAT_KEYWORDNEW','핵심 기술 키워드 탐지 NEW HOST','STAT_CONTENT','L','S','ems/keywordNew.do','fa fa-pie-chart',15,'Y',NULL),
('STAT_GW_ATTACHTYPE','그룹웨어 첨부 파일 통계','STAT_CONTENT','L','S','ems/gwAttachTypeStat.do','fa fa-pie-chart',18,'Y',NULL),
('STAT_ANOMALY_DETECTION','이상 행위 검출 통계','STAT_CONTENT','L','M','ems/abnlDetect.do','fa fa-pie-chart',17,'Y',NULL),
('STAT_KEYWORDSERVICE','핵심 기술 키워드 탐지 서비스 TOP','STAT_CONTENT','L','M','ems/keywordService.do','fa fa-pie-chart',16,'Y',NULL),
('SETTING', '설정', NULL, 'L', 'M', 'ems/interestUser.do', 'fa fa-male', 8, 'Y', '/img/ico_gnb_08.png');


INSERT IGNORE INTO UI_BODY_NATION(NATION_CD, NATION_NAME, NATION) VALUES
('ES','스페인어','스페인'),
('CN','중국어' , '중국'),
('DK','덴마크어', '덴마크'),
('NL','네덜란드어', '네덜란드'),
('FR','프랑스어', '프랑스'),
('DE','독일어', '독일'),
('GR','그리스어', '그리스'),
('IN','인도어', '인도'),
('ID','인도네시아어', '인도네시아'),
('IE','아일랜드어', '아일랜드'),
('IT','이탈리아어', '이탈리아'),
('JP','일본어', '일본'),
('KR','한국어', '한국'),
('MY','말레이시아어', '말레이시아'),
('NZ','뉴질랜드어', '뉴질랜드'),
('PT','포르투갈어', '포르투갈'),
('RU','러시아어', '러시아'),
('SE','스웨덴어', '스웨덴'),
('PH','필리핀어', '필리핀'),
('TH','태국어', '태국어'),
('TR','터키어', '터키'),
('VN','베트남어', '베트남'),
('GB','영어(UK)', '영국'),
('US','영어(US)', '미국'),
('UN','알수없음', '기타');



/* UI_CUSTOM_DASHBOARD_POSITION_DEFAULT */

INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (1,0,0,3,2,3,2,4,2);
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (2,3,0,3,2,3,2,4,2);
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (3,6,0,3,2,3,2,4,2);
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (4,0,4,8,4,5,4,10,5);
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (5,8,4,4,4,4,4,6,6);
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (6,3,2,3,2,2,2,3,2);
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (7,9,0,3,2,3,2,4,2);
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (8,6,2,3,2,3,2,4,2);
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (9,9,2,3,2,3,2,4,2);
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (10,0,2,3,2,2,2,3,2);


/* UI_EPMSG_TYPE  knox 메일 종류 코드*/
INSERT
IGNORE INTO UI_EPMSG_TYPE (EPMSG_TYPE_CODE, EPMSG_TYPE_NAME, EPMSG_TYPE_COLOR) VALUES('confidential', '대외비', 'orange');
INSERT
IGNORE INTO UI_EPMSG_TYPE (EPMSG_TYPE_CODE, EPMSG_TYPE_NAME, EPMSG_TYPE_COLOR) VALUES('confidential_rcpt', '대외비', 'orange');
INSERT
IGNORE INTO UI_EPMSG_TYPE (EPMSG_TYPE_CODE, EPMSG_TYPE_NAME, EPMSG_TYPE_COLOR) VALUES('confidential_strict', '극비', 'red');
INSERT
IGNORE INTO UI_EPMSG_TYPE (EPMSG_TYPE_CODE, EPMSG_TYPE_NAME, EPMSG_TYPE_COLOR) VALUES('official', '공문', 'green');
INSERT
IGNORE INTO UI_EPMSG_TYPE (EPMSG_TYPE_CODE, EPMSG_TYPE_NAME, EPMSG_TYPE_COLOR) VALUES('personal', '일반', 'black');
INSERT
IGNORE INTO UI_EPMSG_TYPE (EPMSG_TYPE_CODE, EPMSG_TYPE_NAME, EPMSG_TYPE_COLOR) VALUES('prohibit_forward', '재전송금지', 'blue');


INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (1,'패턴(개인정보)메시지','S','unread','total','P','svc1','total','tit01','blueBg','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content ">
				<div class="xcn_maincon panel singleBorder">
					<button type="button" class="customClose">
						<span aria-hidden="true">&times;</span>
					</button>
					<div class="blueBg bornone panel-heading click xcn_maincon_box" data-value="reserved">
						<span class="tit01">패턴(개인정보)메시지</span>
						<p class="rightValue">-<span>건</span><span class="tit13"></span></p>
					</div>
					<div class="panel-footer blueBg">
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","readYn":"","receiveSend":"","ctimeWork":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"Y","regexpVal":"PN%L@1|FN%L@1|DN%L@1|SN%L@1|CN%L@1","regexpStr":"여권번호(1건 이상), 외국인 등록번호(1건 이상), 운전면허번호(1건 이상), 주민번호(1건 이상), 카드번호(1건 이상)","drmYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','미열람/전체','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (2,'패턴(위험행위)메시지','S','unread','total','P','svc1','total','tit02','grayBg','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content ">
				<div class="xcn_maincon panel singleBorder">
					<button type="button" class="customClose">
						<span aria-hidden="true">&times;</span>
					</button>
					<div class="grayBg bornone panel-heading click xcn_maincon_box" data-value="reserved">
						<span class="tit02">패턴(위험행위)메시지</span>
						<p class="rightValue">-<span>건</span><span class="tit13"></span></p>
					</div>
					<div class="panel-footer grayBg">
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"Y","regexpVal":"EC%L@1|EF%L@1|ID%L@1","regexpStr":"확장자 변조 파일(1건 이상),   암호화 파일(1건 이상),   송수신자 동일아이디(1건 이상)","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT (DASH_KEY, DASH_NAME, DASH_TYPE, DASH_MULTI_X, DASH_MULTI_Y, DASH_CHART, DASH_CHART_X, DASH_CHART_Y, DASH_ICON, DASH_COLOR, DASH_HTML, DASH_CONDITION, DASH_COMMENT, USEYN) VALUES(3, '키워드(예약어)', 'S', 'unread', 'total', 'P', 'svc1', 'total', 'tit03', 'purpleBg', '<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content ">
				<div class="xcn_maincon panel singleBorder">
					<button type="button" class="customClose">
						<span aria-hidden="true">&times;</span>
					</button>
					<div class="purpleBg bornone panel-heading click xcn_maincon_box" data-value="reserved">
						<span class="tit03">키워드(예약어)</span>
						<p class="rightValue">-<span>건</span><span class="tit13"></span></p>
					</div>
					<div class="panel-footer purpleBg">
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>', '{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"Y","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}', '', 'Y');

INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (4,'서비스별 데이터 수집건수','C','unread','total','B','svc1','total','tit04','greenBg','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content">
				<div class="panel greenBgBorder">
					<div class="panel-body">
						<div class="row">
							<div class="col-xs-12 text-right">
								<button type="button" class="customClose">
									<span aria-hidden="true">&times;</span>
								</button>
								<div class="dashChartArea" data-chartType="B"
								     style="min-height: 200px;height:100%; width: 100%; margin: 0 auto"></div>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="tit04 pull-left dash-title">서비스별 데이터 수집건수</span>
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","readYn":"","receiveSend":"","ctimeWork":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (5,'외부 메일 발신 서비스 비율','C','unread','total','P','svc1','total','tit05','redBg','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content">
				<div class="panel redBgBorder">
					<div class="panel-body">
						<div class="row">
							<div class="col-xs-12 text-right">
								<button type="button" class="customClose">
									<span aria-hidden="true">&times;</span>
								</button>
								<div class="dashChartArea" data-chartType="P"
								     style="min-height: 200px;height:100%; width: 100%; margin: 0 auto"></div>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="tit05 pull-left dash-title">외부 메일 발신 서비스 비율</span>
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"MP3,MSM,MIM,WNV,WDU,WCL,WNT,WKR,WUT,WNA,WYA,WSN,WSU,WDW,WYH,WGG,WYI,WLV,WQQ,WOS,WOT,WUK,WBM,WPO,EBD,EBB,EAA,EMM,EMB,EWS,EPU,ESC,EMF,EMU","serviceTypeNm":"POP3, SMTP, IMAP, 네이버, 다음, 천리안, 네이트, 코리아, 유니텔, 네띠앙, Yeah, SINA, SOHU, 야후, 구글, 용인시, Live.com, QQ, 163, 126, 기타, KT비즈메카, 우체국, 게시, 게시판, 결재, 메일, 모바일, 웹서비스, 일반, 일정 명함, 파일 다운로드, 기타","infoType":"","infoTypeNm":"정보 분류 전체","feedbackType":"","feedbackTypeNm":"피드백 전체","interGroup":"","interGroupNm":"-관심 사용자 선택-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"Y","startTimeSelect":"00","endDateSelect":"Y","endTimeSelect":"23","senders":"","receivers":"","allOfus":"ET|EA","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","receiveSend":"O","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":0,"sizeEndVal":0,"sizeOption":"L","sizeType":""}','','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (6,'1MB 이상 파일 전송','S','unread','total','P','svc1','total','tit06','yellowBg','
	    <div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content ">
				<div class="xcn_maincon panel singleBorder">
					<button type="button" class="customClose">
						<span aria-hidden="true">&times;</span>
					</button>
					<div class="yellowBg bornone panel-heading click xcn_maincon_box" data-value="reserved">
						<span class="tit06">1MB 이상 파일 전송</span>
						<p class="rightValue">-<span>건</span><span class="tit13"></span></p>
					</div>
					<div class="panel-footer yellowBg">
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"1048576","sizeEndVal":"0","sizeOption":"L","sizeType":"A"}','','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (7,'외부 발신 데이터','S','unread','total','P','svc1','total','tit07','blueBg','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content ">
				<div class="xcn_maincon panel singleBorder">
					<button type="button" class="customClose">
						<span aria-hidden="true">&times;</span>
					</button>
					<div class="blueBg bornone panel-heading click xcn_maincon_box" data-value="reserved">
						<span class="tit07">외부 발신 데이터</span>
						<p class="rightValue">-<span>건</span><span class="tit13"></span></p>
					</div>
					<div class="panel-footer blueBg">
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","readYn":"","receiveSend":"O","ctimeWork":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (8,'비업무시간 데이터','S','unread','total','P','svc1','total','tit08','grayBg','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content ">
				<div class="xcn_maincon panel singleBorder">
					<button type="button" class="customClose">
						<span aria-hidden="true">&times;</span>
					</button>
					<div class="grayBg bornone panel-heading click xcn_maincon_box" data-value="reserved">
						<span class="tit08">비업무시간 데이터</span>
						<p class="rightValue">-<span>건</span><span class="tit13"></span></p>
					</div>
					<div class="panel-footer grayBg">
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","receiveSend":"","ctimeWork":"R","readYn":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (9,'그룹웨어 데이터','S','unread','total','P','svc1','total','tit09','purpleBg','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content ">
				<div class="xcn_maincon panel singleBorder">
					<button type="button" class="customClose">
						<span aria-hidden="true">&times;</span>
					</button>
					<div class="purpleBg bornone panel-heading click xcn_maincon_box" data-value="reserved">
						<span class="tit09">그룹웨어 데이터</span>
						<p class="rightValue">-<span>건</span><span class="tit13"></span></p>
					</div>
					<div class="panel-footer purpleBg">
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"EBD,EBB,EAA,EMM,EMB,EWS,EPU,ESC,EMF,EMU","serviceTypeNm":"게시, 게시판, 결재, 메일, 모바일, 웹서비스, 일반, 일정 명함, 파일 다운로드, 기타","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","readYn":"","receiveSend":"","ctimeWork":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','미열람/전체','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (10,'금일 수집 데이터','S','unread','total','P','svc1','total','tit10','greenBg','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content ">
				<div class="xcn_maincon panel singleBorder">
					<button type="button" class="customClose">
						<span aria-hidden="true">&times;</span>
					</button>
					<div class="greenBg bornone panel-heading click xcn_maincon_box" data-value="reserved">
						<span class="tit10">금일 수집 데이터</span>
						<p class="rightValue">-<span>건</span><span class="tit13"></span></p>
					</div>
					<div class="panel-footer greenBg">
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (11,'수신자 발신자 동일 데이터','S','unread','total','P','svc1','total','tit11','redBg','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content ">
				<div class="xcn_maincon panel singleBorder">
					<button type="button" class="customClose">
						<span aria-hidden="true">&times;</span>
					</button>
					<div class="redBg bornone panel-heading click xcn_maincon_box" data-value="reserved">
						<span class="tit11">수신자 발신자 동일 데이터</span>
						<p class="rightValue">-<span>건</span><span class="tit13"></span></p>
					</div>
					<div class="panel-footer redBg">
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceFieldNm":"검색 영역 전체","serviceType":"","serviceTypeNm":"서비스 전체","infoType":"","infoTypeNm":"정보 분류 전체","feedbackType":"","feedbackTypeNm":"피드백 전체","probType":"","probTypeNm":"판정 확률 전체","interGroup":"","interGroupNm":"-관심 사용자 선택-","userGroupSeq_not":"","userGroupSeq":"","userGroupName":"-사용자 그룹-","interGroup_not":"","epmsgType":"","startDateSelect":"T","endDateSelect":"T","startTimeSelect":"00","endTimeSelect":"23","senders":"","senders_not":"","receive_option":"","receivers":"","receivers_not":"","allOfus":"SO","busi":"","busiNm":"사업장 전체","busi_not":"","dept":"","deptNm":"","dept_not":"","url":"","url_not":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","attachYn_not":"","keywordYn":"","keywordVal":"","keywordStr":"","keywordYn_not":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","realAttYn":"","sctYn":"","sizeStartVal":0,"sizeEndVal":0,"sizeOption":"L","sizeType":""}','','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (12,'첨부파일(MS-OFFICE) 데이터','S','unread','total','P','svc1','total','tit12','yellowBg','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content ">
				<div class="xcn_maincon panel singleBorder">
					<button type="button" class="customClose">
						<span aria-hidden="true">&times;</span>
					</button>
					<div class="yellowBg bornone panel-heading click xcn_maincon_box" data-value="reserved">
						<span class="tit12">첨부파일(MS-OFFICE) 데이터</span>
						<p class="rightValue">-<span>건</span><span class="tit13"></span></p>
					</div>
					<div class="panel-footer yellowBg">
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceFieldNm":"검색 영역 전체","serviceType":"","serviceTypeNm":"서비스 전체","infoType":"","infoTypeNm":"정보 분류 전체","feedbackType":"","feedbackTypeNm":"피드백 전체","probType":"","probTypeNm":"판정 확률 전체","interGroup":"","interGroupNm":"-관심 사용자 선택-","userGroupSeq_not":"","userGroupSeq":"","userGroupName":"-사용자 그룹-","interGroup_not":"","epmsgType":"","startDateSelect":"T","endDateSelect":"T","startTimeSelect":"00","endTimeSelect":"23","senders":"","senders_not":"","receive_option":"","receivers":"","receivers_not":"","allOfus":"","busi":"","busiNm":"사업장 전체","busi_not":"","dept":"","deptNm":"","dept_not":"","url":"","url_not":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"Y","attachVal":"DB|ADE|ADP|DBF|DOC|DOT|MDA|MDB|MDE|ODC|ODP|ODS|ODT|PDB|POT|PPS|PPT|PRN|PTF|PWZ|RTF|XLA|XLM|XLR|XLS|XLT|XLW|DOCM|DOCX|DOTM|DOTX|POTM|POTX|PPSM|PPSX|PPTM|PPTX|UXDC|XLAM|XLSB|XLSM|XLSX|XLTM|ACCDA|ACCDB|ACCDE|ACCDT","attachStr":"MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE, MS-OFFICE","attachYn_not":"","keywordYn":"","keywordVal":"","keywordStr":"","keywordYn_not":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","realAttYn":"","sctYn":"","sizeStartVal":0,"sizeEndVal":0,"sizeOption":"L","sizeType":""}','','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (13,'500GB 이상 파일 크기','C','unread','total','B','svc1','total','tit01','blueBg','
<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content">
				<div class="panel blueBgBorder">
					<div class="panel-body">
						<div class="row">
							<div class="col-xs-12 text-right">
								<button type="button" class="customClose">
									<span aria-hidden="true">&times;</span>
								</button>
								<div class="dashChartArea" data-chartType="B"
								     style="min-height: 200px;height:100%; width: 100%; margin: 0 auto"></div>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="tit01 pull-left dash-title">500GB 이상 파일 크기</span>
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceFieldNm":"검색 영역 전체","serviceType":"","serviceTypeNm":"서비스 전체","infoType":"","infoTypeNm":"정보 분류 전체","feedbackType":"","feedbackTypeNm":"피드백 전체","probType":"","probTypeNm":"판정 확률 전체","interGroup":"","interGroupNm":"-관심 사용자 선택-","userGroupSeq_not":"","userGroupSeq":"","userGroupName":"-사용자 그룹-","interGroup_not":"","epmsgType":"","startDateSelect":"Y","endDateSelect":"Y","startTimeSelect":"00","endTimeSelect":"23","senders":"","senders_not":"","receive_option":"","receivers":"","receivers_not":"","allOfus":"","busi":"","busiNm":"사업장 전체","busi_not":"","dept":"","deptNm":"","dept_not":"","url":"","url_not":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","attachYn_not":"","keywordYn":"","keywordVal":"","keywordStr":"","keywordYn_not":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","realAttYn":"","sctYn":"","sizeStartVal":537096999936,"sizeEndVal":0,"sizeOption":"L","sizeType":"A"}','','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (14,'메일 수집 건수 데이터','S','unread','total','P','svc1','total','tit02','grayBg','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content ">
				<div class="xcn_maincon panel singleBorder">
					<button type="button" class="customClose">
						<span aria-hidden="true">&times;</span>
					</button>
					<div class="grayBg bornone panel-heading click xcn_maincon_box" data-value="reserved">
						<span class="tit02">메일 수집 건수 데이터</span>
						<p class="rightValue">-<span>건</span><span class="tit13"></span></p>
					</div>
					<div class="panel-footer grayBg">
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceFieldNm":"검색 영역 전체","serviceType":"MP3,MSM,MIM","serviceTypeNm":"POP3, SMTP, IMAP","infoType":"","infoTypeNm":"정보 분류 전체","feedbackType":"","feedbackTypeNm":"피드백 전체","probType":"","probTypeNm":"판정 확률 전체","interGroup":"","interGroupNm":"-관심 사용자 선택-","userGroupSeq_not":"","userGroupSeq":"","userGroupName":"-사용자 그룹-","interGroup_not":"","epmsgType":"","startDateSelect":"T","endDateSelect":"T","startTimeSelect":"00","endTimeSelect":"23","senders":"","senders_not":"","receive_option":"","receivers":"","receivers_not":"","allOfus":"","busi":"","busiNm":"사업장 전체","busi_not":"","dept":"","deptNm":"","dept_not":"","url":"","url_not":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","attachYn_not":"","keywordYn":"","keywordVal":"","keywordStr":"","keywordYn_not":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","realAttYn":"","sctYn":"","sizeStartVal":0,"sizeEndVal":0,"sizeOption":"L","sizeType":""}','','Y');
INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (15,'메신저 수집 건수 데이터','S','unread','total','P','svc1','total','tit03','purpleBg','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashMultiLeft="total" data-dashMultiRight="unread"></div>
			<div class="grid-stack-item-content ">
				<div class="xcn_maincon panel singleBorder">
					<button type="button" class="customClose">
						<span aria-hidden="true">&times;</span>
					</button>
					<div class="purpleBg bornone panel-heading click xcn_maincon_box" data-value="reserved">
						<span class="tit03">메신저 수집 건수 데이터</span>
						<p class="rightValue">-<span>건</span><span class="tit13"></span></p>
					</div>
					<div class="panel-footer purpleBg">
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">금일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceFieldNm":"검색 영역 전체","serviceType":"QNV,QNM,QDS,QSH,QDI,QDF,QDG,QFM,QMC,QMS,QNT,QSS,QSF,QSP,QSB,QWJ,QGP,QDA,QCL,QKB,QEK,QSL,QSY,QFB,QKM,QGH,QGG,QGM,QGB,QBI,QWT,QIS,QZA,QUK","serviceTypeNm":"네이버, 네이버 쪽지, 대신, 삼홍사, 동부생명, 동부금융, 동국제강, 프리본드, M-채널, 미쓰리, 네이트, 삼성증권, 삼성화재, SK 프라이든, SK 비즈, 웅진, chatGPT, Dall-E, 쿨, k-bond, 아이콘, Slack, 신영자산운용, 페이스북, 삼성KnoxMessenger, 구글 Hangout, 구글 chat, 구글 Meet, 구글 Gemini, Microsoft BingAI Chat, wrtn, 인스타그램 DM, Zalo, 기타","infoType":"","infoTypeNm":"정보 분류 전체","feedbackType":"","feedbackTypeNm":"피드백 전체","probType":"","probTypeNm":"판정 확률 전체","interGroup":"","interGroupNm":"-관심 사용자 선택-","userGroupSeq_not":"","userGroupSeq":"","userGroupName":"-사용자 그룹-","interGroup_not":"","epmsgType":"","startDateSelect":"T","endDateSelect":"T","startTimeSelect":"00","endTimeSelect":"23","senders":"","senders_not":"","receive_option":"","receivers":"","receivers_not":"","allOfus":"","busi":"","busiNm":"사업장 전체","busi_not":"","dept":"","deptNm":"","dept_not":"","url":"","url_not":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","attachYn_not":"","keywordYn":"","keywordVal":"","keywordStr":"","keywordYn_not":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","realAttYn":"","sctYn":"","sizeStartVal":0,"sizeEndVal":0,"sizeOption":"L","sizeType":""}','','Y');


INSERT INTO UI_CUSTOM_DASHBOARD_MENU(MENU_KEY, MENU_NAME, MENU_ICON, ADMIN_ID, USEYN, DEFAULT_MENU, DEFAULT_DASHBOARD,
                                     UPDATE_DT)
SELECT @ROWNUM:=@ROWNUM+1 AS MENU_KEY,'Default Dashboard','fa fa-laptop',A.ADMIN_ID,'Y','Y','Y',NOW()
FROM (SELECT * FROM UI_ADMIN ORDER BY ADMIN_ID) A, (SELECT @ROWNUM := -1) B
WHERE NOT EXISTS (SELECT * FROM UI_CUSTOM_DASHBOARD_MENU WHERE MENU_KEY=0 );


INSERT
IGNORE INTO UI_CUSTOM_DASHBOARD(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,ADMIN_ID,USEYN)
SELECT DASH_KEY,
       DASH_NAME,
       DASH_TYPE,
       DASH_MULTI_X,
       DASH_MULTI_Y,
       DASH_CHART,
       DASH_CHART_X,
       DASH_CHART_Y,
       DASH_ICON,
       DASH_COLOR,
       DASH_HTML,
       DASH_CONDITION,
       DASH_COMMENT,
       'sysadmin',
       USEYN
FROM UI_CUSTOM_DASHBOARD_DEFAULT;



INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('content.transfer','위에 있는 내용을 한글로 번역해죠','gemma2:27b','상세보기 - 번역');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('content.keyword','위에 내용에서 주제키워드 단어로 10개 추출해죠','gemma2:27b','상세보기 - 키워드요약');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('content.summary','위에 있는 내용을 100자이내로 한글로 요약해죠','gemma2:27b','상세보기 - 내용요약');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('content.analysis','위에 있는 내용은 인터넷 패킷데이터를 텍스트로 표현한거야 이 부분을 분석해서 어떤 서비스 인지 한글로 알려죠','gemma2:27b','상세보기 - 내용분석');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('url.analysis','위에 있는 통신하는 URL 주소가 어떤 서비스인지 간략하게 알려줄수 있어?','gemma2:27b','상세보기 - URL 분석');
