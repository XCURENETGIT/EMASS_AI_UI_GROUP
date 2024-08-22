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
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('message.epmsg.val', 'N', 'N', NOW());
INSERT
IGNORE INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT) VALUES ('info.feedback.used', 'false', 'false', NOW());
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
INSERT
IGNORE INTO UI_SERVICE (`SERVICECD`, `SERVICENM_LV1`, `SERVICENM_LV2`, `SERVICENM_LV3`, `IN_OUT`, `SORT`, `USE_YN`,`MSGGRPCD`)
     VALUES ('MP3-', '메일', 'POP3', '-', 'I', 1, 'Y', ''),
    ('MSM-', '메일', 'SMTP', '-', 'O', 2, 'Y', ''),
    ('MIM-', '메일', 'IMAP', '-', 'I', 3, 'Y', ''),
    ('WNVR', '웹메일', '네이버', '수신', 'I', 4, 'Y', ''),
    ('WNVS', '웹메일', '네이버', '발신', 'O', 5, 'Y', ''),
    ('WNVB', '웹메일', '네이버', '예약메일', 'O', 6, 'Y', ''),
    ('WNVT', '웹메일', '네이버', '임시저장', 'O', 7, 'Y', ''),
    ('WDUR', '웹메일', '다음', '수신', 'I', 8, 'Y', ''),
    ('WDUS', '웹메일', '다음', '발신', 'O', 9, 'Y', ''),
    ('WDUB', '웹메일', '다음', '예약메일', 'O', 10, 'Y', ''),
    ('WDUT', '웹메일', '다음', '임시저장', 'O', 11, 'Y', ''),
    ('WCLR', '웹메일', '천리안', '수신', 'I', 12, 'Y', ''),
    ('WCLS', '웹메일', '천리안', '발신', 'O', 13, 'Y', ''),
    ('WCLB', '웹메일', '천리안', '예약메일', 'O', 14, 'Y', ''),
    ('WCLT', '웹메일', '천리안', '임시저장', 'O', 15, 'Y', ''),
    ('WNTR', '웹메일', '네이트', '수신', 'I', 16, 'Y', ''),
    ('WNTS', '웹메일', '네이트', '발신', 'O', 17, 'Y', ''),
    ('WNTB', '웹메일', '네이트', '예약메일', 'O', 18, 'Y', ''),
    ('WNTT', '웹메일', '네이트', '임시저장', 'O', 19, 'Y', ''),
    ('WKRR', '웹메일', '코리아', '수신', 'I', 20, 'Y', ''),
    ('WKRS', '웹메일', '코리아', '발신', 'O', 21, 'Y', ''),
    ('WKRB', '웹메일', '코리아', '예약메일', 'O', 22, 'Y', ''),
    ('WKRT', '웹메일', '코리아', '임시저장', 'O', 23, 'Y', ''),
    ('WUTR', '웹메일', '유니텔', '수신', 'I', 24, 'Y', ''),
    ('WUTS', '웹메일', '유니텔', '발신', 'O', 25, 'Y', ''),
    ('WUTB', '웹메일', '유니텔', '예약메일', 'O', 26, 'Y', ''),
    ('WUTT', '웹메일', '유니텔', '임시저장', 'O', 27, 'Y', ''),
    ('WYAR', '웹메일', 'Yeah', '수신', 'I', 28, 'Y', ''),
    ('WYAS', '웹메일', 'Yeah', '발신', 'O', 29, 'Y', ''),
    ('WYAT', '웹메일', 'Yeah', '임시저장', 'O', 30, 'Y', ''),
    ('WSNR', '웹메일', 'SINA', '수신', 'I', 31, 'Y', ''),
    ('WSNS', '웹메일', 'SINA', '발신', 'O', 32, 'Y', ''),
    ('WSNB', '웹메일', 'SINA', '예약메일', 'O', 33, 'Y', ''),
    ('WSNT', '웹메일', 'SINA', '임시저장', 'O', 34, 'Y', ''),
    ('WSUR', '웹메일', 'SOHU', '수신', 'I', 35, 'Y', ''),
    ('WSUS', '웹메일', 'SOHU', '발신', 'O', 36, 'Y', ''),
    ('WSUB', '웹메일', 'SOHU', '예약메일', 'O', 37, 'Y', ''),
    ('WSUT', '웹메일', 'SOHU', '임시저장', 'O', 38, 'Y', ''),
    ('WYHR', '웹메일', '야후', '수신', 'I', 39, 'Y', ''),
    ('WYHS', '웹메일', '야후', '발신', 'O', 40, 'Y', ''),
    ('WYHT', '웹메일', '야후', '임시저장', 'O', 41, 'Y', ''),
    ('WGGR', '웹메일', 'Gmail', '수신', 'I', 42, 'Y', ''),
    ('WGGS', '웹메일', 'Gmail', '발신', 'O', 43, 'Y', ''),
    ('WGGT', '웹메일', 'Gmail', '임시저장', 'O', 44, 'Y', ''),
    ('WLVR', '웹메일', 'Outlook.com', '수신', 'I', 45, 'Y', ''),
    ('WLVS', '웹메일', 'Outlook.com', '발신', 'O', 46, 'Y', ''),
    ('WLVT', '웹메일', 'Outlook.com', '임시저장', 'O', 47, 'Y', ''),
    ('WQQR', '웹메일', 'QQ', '수신', 'I', 48, 'Y', ''),
    ('WQQS', '웹메일', 'QQ', '발신', 'O', 49, 'Y', ''),
    ('WQQB', '웹메일', 'QQ', '예약메일', 'O', 50, 'Y', ''),
    ('WQQT', '웹메일', 'QQ', '임시저장', 'O', 51, 'Y', ''),
    ('WOSR', '웹메일', '163', '수신', 'I', 52, 'Y', ''),
    ('WOSS', '웹메일', '163', '발신', 'O', 53, 'Y', ''),
    ('WOSB', '웹메일', '163', '예약메일', 'O', 54, 'Y', ''),
    ('WOST', '웹메일', '163', '임시저장', 'O', 55, 'Y', ''),
    ('WBMR', '웹메일', 'KT비즈메카', '수신', 'I', 56, 'Y', ''),
    ('WBMS', '웹메일', 'KT비즈메카', '발신', 'O', 57, 'Y', ''),
    ('WBMT', '웹메일', 'KT비즈메카', '임시저장', 'O', 58, 'Y', ''),
    ('WOTR', '웹메일', '126', '수신', 'I', 59, 'Y', ''),
    ('WOTS', '웹메일', '126', '발신', 'O', 60, 'Y', ''),
    ('WOTB', '웹메일', '126', '예약메일', 'O', 61, 'Y', ''),
    ('WOTT', '웹메일', '126', '임시저장', 'O', 62, 'Y', ''),
    ('WICR', '웹메일', 'Icloud', '수신', 'I', 63, 'Y', ''),
    ('WICS', '웹메일', 'Icloud', '발신', 'O', 64, 'Y', ''),
    ('WICT', '웹메일', 'Icloud', '임시저장', 'O', 65, 'Y', ''),
    ('WKAR', '웹메일', '카카오메일', '수신', 'I', 66, 'Y', ''),
    ('WKAS', '웹메일', '카카오메일', '발신', 'O', 67, 'Y', ''),
    ('WKAT', '웹메일', '카카오메일', '임시저장', 'O', 68, 'Y', ''),
    ('WYDR', '웹메일', 'yandex', '수신', 'I', 69, 'Y', ''),
    ('WYDS', '웹메일', 'yandex', '발신', 'O', 70, 'Y', ''),
    ('WYDT', '웹메일', 'yandex', '임시저장', 'O', 71, 'Y', ''),
    ('WDOR', '웹메일', 'dooray', '수신', 'I', 72, 'Y', ''),
    ('WDOS', '웹메일', 'dooray', '발신', 'O', 73, 'Y', ''),
    ('WDOT', '웹메일', 'dooray', '임시저장', 'O', 74, 'Y', ''),
    ('WUKR', '웹메일', '기타', '수신', 'I', 75, 'Y', ''),
    ('WUKS', '웹메일', '기타', '발신', 'O', 76, 'Y', ''),
    ('CNVR', '커뮤니티', '네이버 카페', '수신', 'I', 77, 'Y', ''),
    ('CNVS', '커뮤니티', '네이버 카페', '발신', 'O', 78, 'Y', ''),
    ('CNVD', '커뮤니티', '네이버 카페', '댓글', 'O', 79, 'Y', ''),
    ('CNVT', '커뮤니티', '네이버 카페', '임시저장', 'O', 80, 'Y', ''),
    ('CDUR', '커뮤니티', '다음 카페', '수신', 'I', 81, 'Y', ''),
    ('CDUS', '커뮤니티', '다음 카페', '발신', 'O', 82, 'Y', ''),
    ('CDUD', '커뮤니티', '다음 카페', '댓글', 'O', 83, 'Y', ''),
    ('CDUT', '커뮤니티', '다음 카페', '임시저장', 'O', 84, 'Y', ''),
    ('CPPR', '커뮤니티', '뽐뿌 커뮤니케이션', '수신', 'I', 85, 'Y', ''),
    ('CPPS', '커뮤니티', '뽐뿌 커뮤니케이션', '발신', 'O', 86, 'Y', ''),
    ('CPPD', '커뮤니티', '뽐뿌 커뮤니케이션', '댓글', 'O', 87, 'Y', ''),
    ('CCIR', '커뮤니티', '클리앙', '수신', 'I', 88, 'Y', ''),
    ('CCIS', '커뮤니티', '클리앙', '발신', 'O', 89, 'Y', ''),
    ('CCID', '커뮤니티', '클리앙', '댓글', 'O', 90, 'Y', ''),
    ('CDCR', '커뮤니티', '디시인사이드', '수신', 'I', 91, 'Y', ''),
    ('CDCS', '커뮤니티', '디시인사이드', '발신', 'O', 92, 'Y', ''),
    ('CDCD', '커뮤니티', '디시인사이드', '댓글', 'O', 93, 'Y', ''),
    ('CRWR', '커뮤니티', '루리웹', '수신', 'I', 94, 'Y', ''),
    ('CRWS', '커뮤니티', '루리웹', '발신', 'O', 95, 'Y', ''),
    ('CRWD', '커뮤니티', '루리웹', '댓글', 'O', 96, 'Y', ''),
    ('CMLR', '커뮤니티', 'Menlosecurity', '수신', 'I', 97, 'Y', ''),
    ('CMLS', '커뮤니티', 'Menlosecurity', '발신', 'O', 98, 'Y', ''),
    ('CMLD', '커뮤니티', 'Menlosecurity', '댓글', 'O', 99, 'Y', ''),
    ('CMLE', '커뮤니티', 'Menlosecurity', '기타', 'O', 100, 'Y', ''),
    ('CBDS', '커뮤니티', '블라인드', '발신', 'O', 101, 'Y', ''),
    ('CUKR', '커뮤니티', '기타', '수신', 'I', 102, 'Y', ''),
    ('CUKS', '커뮤니티', '기타', '발신', 'O', 103, 'Y', ''),
    ('CUKD', '커뮤니티', '기타', '댓글', 'O', 104, 'Y', ''),
    ('SFBR', '소셜', '페이스북', '수신', 'I', 105, 'Y', ''),
    ('SFBS', '소셜', '페이스북', '발신', 'O', 106, 'Y', ''),
    ('SFBD', '소셜', '페이스북', '댓글', 'O', 107, 'Y', ''),
    ('STWR', '소셜', '트위터', '수신', 'I', 108, 'Y', ''),
    ('STWS', '소셜', '트위터', '발신', 'O', 109, 'Y', ''),
    ('STWD', '소셜', '트위터', '댓글', 'O', 110, 'Y', ''),
    ('SKAR', '소셜', '카카오스토리', '수신', 'I', 111, 'Y', ''),
    ('SKAS', '소셜', '카카오스토리', '발신', 'O', 112, 'Y', ''),
    ('SKAD', '소셜', '카카오스토리', '댓글', 'O', 113, 'Y', ''),
    ('SNVR', '소셜', '네이버 블로그', '수신', 'I', 114, 'Y', ''),
    ('SNVS', '소셜', '네이버 블로그', '발신', 'O', 115, 'Y', ''),
    ('SNVD', '소셜', '네이버 블로그', '댓글', 'O', 116, 'Y', ''),
    ('SNVT', '소셜', '네이버 블로그', '임시저장', 'O', 117, 'Y', ''),
    ('SNVU', '소셜', '네이버 블로그', '수정', 'O', 118, 'Y', ''),
    ('SDUR', '소셜', '다음 블로그', '수신', 'I', 119, 'Y', ''),
    ('SDUS', '소셜', '다음 블로그', '발신', 'O', 120, 'Y', ''),
    ('SDUD', '소셜', '다음 블로그', '댓글', 'O', 121, 'Y', ''),
    ('STSR', '소셜', '티스토리', '수신', 'I', 122, 'Y', ''),
    ('STSS', '소셜', '티스토리', '발신', 'O', 123, 'Y', ''),
    ('STSD', '소셜', '티스토리', '댓글', 'O', 124, 'Y', ''),
    ('STST', '소셜', '티스토리', '임시저장', 'O', 125, 'Y', ''),
    ('STBR', '소셜', '텀블러', '수신', 'I', 126, 'Y', ''),
    ('STBS', '소셜', '텀블러', '발신', 'O', 127, 'Y', ''),
    ('STBD', '소셜', '텀블러', '댓글', 'O', 128, 'Y', ''),
    ('SWBR', '소셜', '웨이보', '수신', 'I', 129, 'Y', ''),
    ('SWBS', '소셜', '웨이보', '발신', 'O', 130, 'Y', ''),
    ('SWBD', '소셜', '웨이보', '댓글', 'O', 131, 'Y', ''),
    ('SLKR', '소셜', '링크드인', '수신', 'I', 132, 'Y', ''),
    ('SLKS', '소셜', '링크드인', '발신', 'O', 133, 'Y', ''),
    ('SLKD', '소셜', '링크드인', '댓글', 'O', 134, 'Y', ''),
    ('SEGR', '소셜', '이글루', '수신', 'I', 135, 'Y', ''),
    ('SEGS', '소셜', '이글루', '발신', 'O', 136, 'Y', ''),
    ('SEGD', '소셜', '이글루', '댓글', 'O', 137, 'Y', ''),
    ('SYMR', '소셜', '야머', '수신', 'I', 138, 'Y', ''),
    ('SYMS', '소셜', '야머', '발신', 'O', 139, 'Y', ''),
    ('SYMD', '소셜', '야머', '댓글', 'O', 140, 'Y', ''),
    ('SYMF', '소셜', '야머', '파일전송', 'O', 141, 'Y', ''),
    ('SNBR', '소셜', '네이버 밴드', '수신', 'I', 142, 'Y', ''),
    ('SNBS', '소셜', '네이버 밴드', '발신', 'O', 143, 'Y', ''),
    ('SNBD', '소셜', '네이버 밴드', '댓글', 'O', 144, 'Y', ''),
    ('SLRR', '소셜', '라이브리', '수신', 'I', 145, 'Y', ''),
    ('SLRS', '소셜', '라이브리', '발신', 'O', 146, 'Y', ''),
    ('SLRD', '소셜', '라이브리', '댓글', 'O', 147, 'Y', ''),
    ('SMER', '소셜', 'medium', '수신', 'I', 148, 'Y', ''),
    ('SMES', '소셜', 'medium', '발신', 'O', 149, 'Y', ''),
    ('SMED', '소셜', 'medium', '댓글', 'O', 150, 'Y', ''),
    ('SISR', '소셜', '인스타그램', '수신', 'I', 151, 'Y', ''),
    ('SISS', '소셜', '인스타그램', '발신', 'O', 152, 'Y', ''),
    ('SISD', '소셜', '인스타그램', '댓글', 'O', 153, 'Y', ''),
    ('SISF', '소셜', '인스타그램', '파일전송', 'O', 154, 'Y', ''),
    ('VDUR', '영상 스트리밍', '다음 TV', '수신', 'I', 155, 'Y', ''),
    ('VDUS', '영상 스트리밍', '다음 TV', '발신', 'O', 156, 'Y', ''),
    ('VPDR', '영상 스트리밍', '판도라 TV', '수신', 'I', 157, 'Y', ''),
    ('VPDS', '영상 스트리밍', '판도라 TV', '발신', 'O', 158, 'Y', ''),
    ('VGMR', '영상 스트리밍', '곰 TV', '수신', 'I', 159, 'Y', ''),
    ('VGMS', '영상 스트리밍', '곰 TV', '발신', 'O', 160, 'Y', ''),
    ('VYTR', '영상 스트리밍', '유튜브', '수신', 'I', 161, 'Y', ''),
    ('VYTS', '영상 스트리밍', '유튜브', '발신', 'O', 162, 'Y', ''),
    ('VYTD', '영상 스트리밍', '유튜브', '댓글', 'O', 163, 'Y', ''),
    ('VNVR', '영상 스트리밍', '네이버 TV캐스트', '수신', 'I', 164, 'Y', ''),
    ('VNVS', '영상 스트리밍', '네이버 TV캐스트', '발신', 'O', 165, 'Y', ''),
    ('QNVC', '메신저', '네이버', '채팅', 'O', 166, 'N', ''),
    ('QNVF', '메신저', '네이버', '파일전송', 'O', 167, 'N', ''),
    ('QNMR', '메신저', '네이버 쪽지', '수신', 'I', 168, 'N', ''),
    ('QNMS', '메신저', '네이버 쪽지', '발신', 'O', 169, 'N', ''),
    ('QDUC', '메신저', '다음', '채팅', 'O', 170, 'N', ''),
    ('QDUF', '메신저', '다음', '파일전송', 'O', 171, 'N', ''),
    ('QDUM', '메신저', '다음', '쪽지', 'O', 172, 'N', ''),
    ('QDSC', '메신저', '대신', '채팅', 'O', 173, 'N', ''),
    ('QDSF', '메신저', '대신', '파일전송', 'O', 174, 'N', ''),
    ('QDSM', '메신저', '대신', '쪽지', 'O', 175, 'N', ''),
    ('QSHC', '메신저', '삼홍사', '채팅', 'O', 176, 'Y', ''),
    ('QSHF', '메신저', '삼홍사', '파일전송', 'O', 177, 'Y', ''),
    ('QSHM', '메신저', '삼홍사', '쪽지', 'O', 178, 'Y', ''),
    ('QDIC', '메신저', '동부생명', '채팅', 'O', 179, 'Y', ''),
    ('QDIF', '메신저', '동부생명', '파일전송', 'O', 180, 'Y', ''),
    ('QDIM', '메신저', '동부생명', '쪽지', 'O', 181, 'Y', ''),
    ('QDFC', '메신저', '동부금융', '채팅', 'O', 182, 'Y', ''),
    ('QDFF', '메신저', '동부금융', '파일전송', 'O', 183, 'Y', ''),
    ('QDFM', '메신저', '동부금융', '쪽지', 'O', 184, 'Y', ''),
    ('QDGC', '메신저', '동국제강', '채팅', 'O', 185, 'Y', ''),
    ('QDGF', '메신저', '동국제강', '파일전송', 'O', 186, 'Y', ''),
    ('QDGM', '메신저', '동국제강', '쪽지', 'O', 187, 'Y', ''),
    ('QFMC', '메신저', '프리본드', '채팅', 'O', 188, 'Y', 'MSG'),
    ('QFMF', '메신저', '프리본드', '파일전송', 'O', 189, 'Y', 'MSG'),
    ('QFMM', '메신저', '프리본드', '쪽지', 'O', 190, 'Y', 'MSG'),
    ('QFMJ', '메신저', '프리본드', '참여', 'O', 191, 'Y', 'MSG'),
    ('QFML', '메신저', '프리본드', '떠남', 'O', 192, 'Y', 'MSG'),
    ('QMCC', '메신저', 'M-채널', '채팅', 'O', 193, 'Y', ''),
    ('QMCF', '메신저', 'M-채널', '파일전송', 'O', 194, 'Y', ''),
    ('QMCM', '메신저', 'M-채널', '쪽지', 'O', 195, 'Y', ''),
    ('QMSC', '메신저', '미쓰리', '채팅', 'O', 196, 'Y', 'MSG'),
    ('QMSF', '메신저', '미쓰리', '파일전송', 'O', 197, 'Y', 'MSG'),
    ('QMSM', '메신저', '미쓰리', '쪽지', 'O', 198, 'Y', 'MSG'),
    ('QMSJ', '메신저', '미쓰리', '참여', 'O', 199, 'Y', 'MSG'),
    ('QMSL', '메신저', '미쓰리', '떠남', 'O', 200, 'Y', 'MSG'),
    ('QNTC', '메신저', '네이트', '채팅', 'O', 201, 'Y', 'MSG'),
    ('QNTF', '메신저', '네이트', '파일전송', 'O', 202, 'Y', 'MSG'),
    ('QNTM', '메신저', '네이트', '쪽지', 'O', 203, 'Y', 'MSG'),
    ('QNTJ', '메신저', '네이트', '참여', 'O', 204, 'Y', 'MSG'),
    ('QNTL', '메신저', '네이트', '떠남', 'O', 205, 'Y', 'MSG'),
    ('QSSC', '메신저', '삼성증권', '채팅', 'O', 206, 'N', ''),
    ('QSSF', '메신저', '삼성증권', '파일전송', 'O', 207, 'N', ''),
    ('QSSM', '메신저', '삼성증권', '쪽지', 'O', 208, 'N', ''),
    ('QSFC', '메신저', '삼성화재', '채팅', 'O', 209, 'Y', ''),
    ('QSFF', '메신저', '삼성화재', '파일전송', 'O', 210, 'Y', ''),
    ('QSFM', '메신저', '삼성화재', '쪽지', 'O', 211, 'Y', ''),
    ('QSFJ', '메신저', '삼성화재', '참여', 'O', 212, 'Y', ''),
    ('QSFL', '메신저', '삼성화재', '떠남', 'O', 213, 'Y', ''),
    ('QSPC', '메신저', 'SK 프라이든', '채팅', 'O', 214, 'Y', ''),
    ('QSPF', '메신저', 'SK 프라이든', '파일전송', 'O', 215, 'Y', ''),
    ('QSPM', '메신저', 'SK 프라이든', '쪽지', 'O', 216, 'Y', ''),
    ('QSPJ', '메신저', 'SK 프라이든', '참여', 'O', 217, 'Y', ''),
    ('QSPL', '메신저', 'SK 프라이든', '떠남', 'O', 218, 'Y', ''),
    ('QSBC', '메신저', 'SK 비즈', '채팅', 'O', 219, 'N', ''),
    ('QSBF', '메신저', 'SK 비즈', '파일전송', 'O', 220, 'N', ''),
    ('QSBM', '메신저', 'SK 비즈', '쪽지', 'O', 221, 'N', ''),
    ('QWJC', '메신저', '웅진', '채팅', 'O', 222, 'Y', ''),
    ('QWJF', '메신저', '웅진', '파일전송', 'O', 223, 'Y', ''),
    ('QWJM', '메신저', '웅진', '쪽지', 'O', 224, 'Y', ''),
    ('QGPC', '메신저', 'chatGPT', '채팅', 'O', 225, 'Y', ''),
    ('QDAC', '메신저', 'Dall-E', '채팅', 'O', 226, 'Y', ''),
    ('QDAF', '메신저', 'Dall-E', '파일전송', 'O', 227, 'Y', ''),
    ('QCLC', '메신저', '쿨', '채팅', 'O', 228, 'Y', 'MSG'),
    ('QCLF', '메신저', '쿨', '파일전송', 'O', 229, 'Y', 'MSG'),
    ('QCLM', '메신저', '쿨', '쪽지', 'O', 230, 'Y', 'MSG'),
    ('QCLJ', '메신저', '쿨', '참여', 'O', 231, 'Y', 'MSG'),
    ('QCLL', '메신저', '쿨', '떠남', 'O', 232, 'Y', 'MSG'),
    ('QKBC', '메신저', 'k-bond', '채팅', 'O', 233, 'Y', 'MSG'),
    ('QKBF', '메신저', 'k-bond', '파일전송', 'O', 234, 'Y', 'MSG'),
    ('QKBM', '메신저', 'k-bond', '쪽지', 'O', 235, 'Y', 'MSG'),
    ('QKBJ', '메신저', 'k-bond', '참여', 'O', 236, 'Y', 'MSG'),
    ('QKBL', '메신저', 'k-bond', '떠남', 'O', 237, 'Y', 'MSG'),
    ('QEKC', '메신저', '아이콘', '채팅', 'O', 238, 'Y', 'MSG'),
    ('QEKF', '메신저', '아이콘', '파일전송', 'O', 239, 'Y', 'MSG'),
    ('QEKJ', '메신저', '아이콘', '참여', 'O', 240, 'Y', 'MSG'),
    ('QEKL', '메신저', '아이콘', '떠남', 'O', 241, 'Y', 'MSG'),
    ('QEKH', '메신저', '아이콘', '과거 데이터', 'O', 242, 'Y', 'MSG'),
    ('QSLC', '메신저', 'Slack', '채팅', 'O', 243, 'Y', 'MSG'),
    ('QSLF', '메신저', 'Slack', '파일전송', 'O', 244, 'Y', 'MSG'),
    ('QSLJ', '메신저', 'Slack', '참여', 'O', 245, 'Y', 'MSG'),
    ('QSLL', '메신저', 'Slack', '떠남', 'O', 246, 'Y', 'MSG'),
    ('QSYC', '메신저', '신영자산운용', '채팅', 'O', 247, 'Y', 'MSG'),
    ('QSYF', '메신저', '신영자산운용', '파일전송', 'O', 248, 'Y', 'MSG'),
    ('QSYM', '메신저', '신영자산운용', '쪽지', 'O', 249, 'Y', 'MSG'),
    ('QSYJ', '메신저', '신영자산운용', '참여', 'O', 250, 'Y', 'MSG'),
    ('QSYL', '메신저', '신영자산운용', '떠남', 'O', 251, 'Y', 'MSG'),
    ('QFBC', '메신저', '페이스북', '채팅', 'O', 252, 'Y', 'MSG'),
    ('QFBF', '메신저', '페이스북', '파일전송', 'O', 253, 'Y', 'MSG'),
    ('QKMC', '메신저', '삼성KnoxMessenger', '채팅', 'O', 254, 'Y', 'MSG'),
    ('QKMF', '메신저', '삼성KnoxMessenger', '파일전송', 'O', 255, 'Y', 'MSG'),
    ('QKMR', '메신저', '삼성KnoxMessenger', '파일수신', 'I', 256, 'Y', 'MSG'),
    ('QKMW', '메신저', '삼성KnoxMessenger', '전달', 'O', 257, 'Y', 'MSG'),
    ('QKMV', '메신저', '삼성KnoxMessenger', '파일-미리보기', 'O', 258, 'Y', 'MSG'),
    ('QGHC', '메신저', '구글 Hangout', '채팅', 'O', 259, 'Y', 'MSG'),
    ('QGHF', '메신저', '구글 Hangout', '파일전송', 'O', 260, 'Y', 'MSG'),
    ('QGGC', '메신저', '구글 chat', '채팅', 'O', 261, 'Y', 'MSG'),
    ('QGGF', '메신저', '구글 chat', '파일전송', 'O', 262, 'Y', 'MSG'),
    ('QGMC', '메신저', '구글 Meet', '채팅', 'O', 263, 'Y', 'MSG'),
    ('QGBC', '메신저', '구글 Bard', '채팅', 'O', 264, 'Y', 'MSG'),
    ('QBIC', '메신저', 'Microsoft BingAI Chat', '채팅', 'O', 265, 'Y', 'MSG'),
    ('QWTC', '메신저', 'wrtn', '채팅', 'O', 266, 'Y', ''),
    ('QISC', '메신저', '인스타그램 DM', '채팅', 'O', 267, 'Y', 'MSG'),
    ('QISF', '메신저', '인스타그램 DM', '파일전송', 'O', 268, 'Y', 'MSG'),
    ('QZAC', '메신저', 'Zalo', '채팅', 'O', 269, 'Y', 'MSG'),
    ('QZAF', '메신저', 'Zalo', '파일전송', 'O', 270, 'Y', 'MSG'),
    ('QNBC', '메신저', '네이버 밴드 채팅', '채팅', 'O', 271, 'Y', 'MSG'),
    ('QNBF', '메신저', '네이버 밴드 채팅', '파일전송', 'O', 272, 'Y', 'MSG'),
    ('QDOC', '메신저', 'Dooray app', '채팅', 'O', 273, 'Y', 'MSG'),
    ('QDOF', '메신저', 'Dooray app', '파일전송', 'O', 274, 'Y', 'MSG'),
    ('QUKC', '메신저', '기타', '채팅', 'O', 275, 'Y', 'MSG'),
    ('QUKF', '메신저', '기타', '파일전송', 'O', 276, 'Y', 'MSG'),
    ('QUKM', '메신저', '기타', '쪽지', 'O', 277, 'Y', 'MSG'),
    ('QUKJ', '메신저', '기타', '참여', 'O', 278, 'Y', 'MSG'),
    ('QUKL', '메신저', '기타', '떠남', 'O', 279, 'Y', 'MSG'),
    ('FFTC', '파일전송', 'FTP', 'CMD', 'O', 280, 'Y', ''),
    ('FFTG', '파일전송', 'FTP', 'GET', 'I', 281, 'Y', ''),
    ('FFTP', '파일전송', 'FTP', 'PUT', 'O', 282, 'Y', ''),
    ('FFTL', '파일전송', 'FTP', 'CONNECT', 'O', 283, 'Y', ''),
    ('FZM-', '파일전송', 'Zmodem', '-', 'O', 284, 'Y', ''),
    ('FNVR', '파일전송', '네이버 MYBOX', '수신', 'I', 285, 'Y', ''),
    ('FNVS', '파일전송', '네이버 MYBOX', '발신', 'O', 286, 'Y', ''),
    ('FGGR', '파일전송', '구글 드라이브', '수신', 'I', 287, 'Y', ''),
    ('FGGS', '파일전송', '구글 드라이브', '발신', 'O', 288, 'Y', ''),
    ('FODR', '파일전송', 'OneDrive', '수신', 'I', 229, 'Y', ''),
    ('FODS', '파일전송', 'OneDrive', '발신', 'O', 290, 'Y', ''),
    ('FDBR', '파일전송', 'Dropbox', '수신', 'I', 291, 'Y', ''),
    ('FDBS', '파일전송', 'Dropbox', '발신', 'O', 292, 'Y', ''),
    ('F2NR', '파일전송', '2nd 드라이브', '수신', 'I', 293, 'N', ''),
    ('F2NS', '파일전송', '2nd 드라이브', '발신', 'O', 294, 'N', ''),
    ('FPSR', '파일전송', 'polarisoffice ', '수신', 'I', 295, 'Y', ''),
    ('FPSS', '파일전송', 'polarisoffice ', '발신', 'O', 296, 'Y', ''),
    ('FICR', '파일전송', 'Icloud', '수신', 'I', 297, 'Y', ''),
    ('FICS', '파일전송', 'Icloud', '발신', 'O', 298, 'Y', ''),
    ('FYDR', '파일전송', 'yandex', '수신', 'I', 299, 'Y', ''),
    ('FYDS', '파일전송', 'yandex', '발신', 'O', 300, 'Y', ''),
    ('FWHR', '파일전송', 'LG 웹하드', '수신', 'I', 301, 'Y', ''),
    ('FWHS', '파일전송', 'LG 웹하드', '발신', 'O', 302, 'Y', ''),
    ('FGIR', '파일전송', 'GitHub', '수신', 'I', 303, 'Y', ''),
    ('FGIS', '파일전송', 'GitHub', '발신', 'O', 304, 'Y', ''),
    ('FDOR', '파일전송', 'dooray', '수신', 'I', 305, 'Y', ''),
    ('FDOS', '파일전송', 'dooray', '발신', 'O', 306, 'Y', ''),
    ('FWES', '파일전송', 'wetransfer', '발신', 'O', 307, 'Y', ''),
    ('FASS', '파일전송', 'AWS S3 bucket', '발신', 'O', 308, 'Y', ''),
    ('FUKR', '파일전송', '기타', '수신', 'I', 309, 'Y', ''),
    ('FUKS', '파일전송', '기타', '발신', 'O', 310, 'Y', ''),
    ('NENR', '노트', 'EVERNOTE', '수신', 'I', 311, 'Y', ''),
    ('NENS', '노트', 'EVERNOTE', '발신', 'O', 312, 'Y', ''),
    ('NONR', '노트', 'ONENOTE', '수신', 'I', 313, 'Y', ''),
    ('NONS', '노트', 'ONENOTE', '발신', 'O', 314, 'Y', ''),
    ('NLVS', '노트', 'Outlook.com 메모', '발신', 'O', 315, 'Y', ''),
    ('NBTS', '노트', 'BIT.AI', '발신', 'O', 316, 'Y', ''),
    ('NNOS', '노트', 'notion', '발신', 'O', 317, 'Y', ''),
    ('NGGS', '노트', '구글 docs', '발신', 'O', 318, 'Y', ''),
    ('NGTS', '노트', '구글 tasks', '발신', 'O', 319, 'Y', ''),
    ('NGKS', '노트', '구글 keep', '발신', 'O', 320, 'Y', ''),
    ('NSSR', '노트', '삼성 노트', '수신', 'I', 321, 'Y', ''),
    ('NSSS', '노트', '삼성 노트', '발신', 'O', 322, 'Y', ''),
    ('NNVS', '노트', '네이버 오피스', '발신', 'O', 323, 'Y', ''),
    ('NDBS', '노트', 'Dropbox paper', '발신', 'O', 324, 'Y', ''),
    ('NHCS', '노트', '한컴 오피스', '발신', 'O', 325, 'Y', ''),
    ('NMOS', '노트', 'MS오피스', '발신', 'O', 326, 'Y', ''),
    ('NCDS', '노트', 'Coda', '발신', 'O', 327, 'Y', ''),
    ('NNMR', '노트', '네이버 메모', '수신', 'I', 328, 'Y', ''),
    ('NNMS', '노트', '네이버 메모', '발신', 'O', 329, 'Y', ''),
    ('NCNS', '노트', 'Clova Note', '발신', 'O', 330, 'Y', ''),
    ('NGIS', '노트', 'Github Gist', '발신', 'O', 331, 'Y', ''),
    ('NSNS', '노트', 'SimpleNote', '발신', 'O', 332, 'Y', ''),
    ('NAGS', '노트', 'Agit', '발신', 'O', 333, 'Y', ''),
    ('NPSS', '노트', 'polaris office', '발신', 'O', 334, 'Y', ''),
    ('NBOS', '노트', 'Box', '발신', 'O', 335, 'Y', ''),
    ('NCKS', '노트', 'ClickUp', '발신', 'O', 336, 'Y', ''),
    ('NUKS', '노트', '기타', '발신', 'O', 337, 'Y', ''),
    ('AGCR', '일정', '구글캘린더일정', '수신', 'I', 338, 'N', ''),
    ('AGCS', '일정', '구글캘린더일정', '발신', 'O', 339, 'Y', ''),
    ('AGLR', '일정', '구글캘린더메일', '수신', 'I', 340, 'N', ''),
    ('AGLS', '일정', '구글캘린더메일', '발신', 'O', 341, 'Y', ''),
    ('ANCS', '일정', '네이버 캘린더', '발신', 'O', 342, 'Y', ''),
    ('ZTN-', '기타 서비스', 'Telnet', '-', 'O', 343, 'Y', ''),
    ('ZXT-', '기타 서비스', 'Xterm', '-', 'O', 344, 'Y', ''),
    ('ZRL-', '기타 서비스', 'R-Login', '-', 'O', 345, 'Y', ''),
    ('ZNP-', '기타 서비스', 'NNTP', '-', 'O', 346, 'Y', ''),
    ('ZPC-', '기타 서비스', 'PC 보안', '-', 'O', 347, 'N', ''),
    ('ZSH-', '기타 서비스', 'SSH', 'SSH 세션 정보', 'O', 348, 'Y', ''),
    ('XX1R', '모니터링_제외', '미분류_타입1', '수신', 'I', 349, 'Y', ''),
    ('XX1S', '모니터링_제외', '미분류_타입1', '발신', 'O', 350, 'Y', ''),
    ('XX2R', '모니터링_제외', '미분류_타입2', '수신', 'I', 351, 'Y', ''),
    ('XX2S', '모니터링_제외', '미분류_타입2', '발신', 'O', 352, 'Y', ''),
    ('XX3R', '모니터링_제외', '미분류_타입3', '수신', 'I', 353, 'Y', ''),
    ('XX3S', '모니터링_제외', '미분류_타입3', '발신', 'O', 354, 'Y', ''),
    ('XU1R', '모니터링_제외', '웹서비스(미분류)_타입1', '수신', 'I', 355, 'Y', ''),
    ('XU1S', '모니터링_제외', '웹서비스(미분류)_타입1', '발신', 'O', 356, 'Y', ''),
    ('XU2R', '모니터링_제외', '웹서비스(미분류)_타입2', '수신', 'I', 357, 'Y', ''),
    ('XU2S', '모니터링_제외', '웹서비스(미분류)_타입2', '발신', 'O', 358, 'Y', ''),
    ('XU3R', '모니터링_제외', '웹서비스(미분류)_타입3', '수신', 'I', 359, 'Y', ''),
    ('XU3S', '모니터링_제외', '웹서비스(미분류)_타입3', '발신', 'O', 360, 'Y', ''),
    ('UWSD', '웹서비스(미분류)', '웹 발신', '첨부 - 문서타입', 'O', 361, 'Y', ''),
    ('UWSE', '웹서비스(미분류)', '웹 발신', '첨부 - 문서아님', 'O', 362, 'Y', ''),
    ('UWSU', '웹서비스(미분류)', '웹 발신', '첨부 없음', 'O', 363, 'Y', ''),
    ('UWSH', '웹서비스(미분류)', '웹 발신', '중요도(상)', 'O', 364, 'Y', ''),
    ('UWSM', '웹서비스(미분류)', '웹 발신', '중요도(중)', 'O', 365, 'Y', ''),
    ('UWSL', '웹서비스(미분류)', '웹 발신', '중요도(하)', 'O', 366, 'Y', ''),
    ('UX1R', '웹서비스(미분류)', '미분류_타입1', '수신', 'I', 367, 'Y', ''),
    ('UX1S', '웹서비스(미분류)', '미분류_타입1', '발신', 'O', 368, 'Y', ''),
    ('UX2R', '웹서비스(미분류)', '미분류_타입2', '수신', 'I', 369, 'Y', ''),
    ('UX2S', '웹서비스(미분류)', '미분류_타입2', '발신', 'O', 370, 'Y', ''),
    ('UX3R', '웹서비스(미분류)', '미분류_타입3', '수신', 'I', 371, 'Y', ''),
    ('UX3S', '웹서비스(미분류)', '미분류_타입3', '발신', 'O', 372, 'Y', ''),
    ('UWRD', '웹서비스(미분류)', '웹 수신', '첨부 - 문서타입', 'I', 373, 'Y', ''),
    ('UWRE', '웹서비스(미분류)', '웹 수신', '첨부 - 문서아님', 'I', 374, 'Y', ''),
    ('UWRU', '웹서비스(미분류)', '웹 수신', '첨부 없음', 'I', 375, 'Y', ''),
    ('BWSD', '웹서비스(업무)', '업무 발신', '첨부 - 문서타입', 'O', 376, 'Y', ''),
    ('BWSE', '웹서비스(업무)', '업무 발신', '첨부 - 문서아님', 'O', 377, 'Y', ''),
    ('BWSU', '웹서비스(업무)', '업무 발신', '첨부 없음', 'O', 378, 'Y', ''),
    ('BWRD', '웹서비스(업무)', '업무 수신', '첨부 - 문서타입', 'I', 379, 'Y', ''),
    ('BWRE', '웹서비스(업무)', '업무 수신', '첨부 - 문서아님', 'I', 380, 'Y', ''),
    ('BWRU', '웹서비스(업무)', '업무 수신', '첨부 없음', 'I', 381, 'Y', ''),
    ('TWEC', '화상회의', 'Webex', '채팅', 'O', 382, 'Y', 'MSG'),
    ('TWEF', '화상회의', 'Webex', '파일전송', 'O', 383, 'Y', 'MSG'),
    ('TWEJ', '화상회의', 'Webex', '참여', 'O', 384, 'Y', 'MSG'),
    ('TWEL', '화상회의', 'Webex', '떠남', 'O', 385, 'Y', 'MSG'),
    ('TZOC', '화상회의', 'Zoom', '채팅', 'O', 386, 'Y', 'MSG'),
    ('TZOF', '화상회의', 'Zoom', '파일전송', 'O', 387, 'Y', 'MSG'),
    ('TZOJ', '화상회의', 'Zoom', '참여', 'O', 388, 'Y', 'MSG'),
    ('TZOL', '화상회의', 'Zoom', '떠남', 'O', 389, 'Y', 'MSG'),
    ('TTMC', '화상회의', 'Teams', '채팅', 'O', 390, 'Y', 'MSG'),
    ('TTMF', '화상회의', 'Teams', '파일전송', 'O', 391, 'Y', 'MSG'),
    ('TTMJ', '화상회의', 'Teams', '참여', 'O', 392, 'Y', 'MSG'),
    ('TTML', '화상회의', 'Teams', '떠남', 'O', 393, 'Y', 'MSG'),
    ('TSKC', '화상회의', 'Skype', '채팅', 'O', 394, 'Y', 'MSG'),
    ('TSKF', '화상회의', 'Skype', '파일전송', 'O', 395, 'Y', 'MSG'),
    ('TSKJ', '화상회의', 'Skype', '참여', 'O', 396, 'Y', 'MSG'),
    ('TSKL', '화상회의', 'Skype', '떠남', 'O', 397, 'Y', 'MSG'),
    ('TJMC', '화상회의', 'JoinME', '채팅', 'O', 398, 'Y', 'MSG'),
    ('TJMF', '화상회의', 'JoinME', '파일전송', 'O', 399, 'Y', 'MSG'),
    ('TAMC', '화상회의', 'Amazon Chime', '채팅', 'O', 400, 'Y', 'MSG'),
    ('TAMF', '화상회의', 'Amazon Chime', '파일전송', 'O', 401, 'Y', 'MSG'),
    ('TBJC', '화상회의', 'BlueJeans', '채팅', 'O', 402, 'Y', 'MSG'),
    ('TTDS', '화상회의', 'tl;dv', '채팅', 'O', 403, 'Y', 'MSG'),
    ('LNVS', '번역기', '파파고 번역', '발신', 'O', 404, 'Y', ''),
    ('LGGS', '번역기', '구글 번역', '발신', 'O', 405, 'Y', ''),
    ('LGPS', '번역기', '구글 번역 플러그인', '발신', 'O', 406, 'Y', ''),
    ('LDES', '번역기', 'Deepl', '발신', 'O', 407, 'Y', ''),
    ('LBIS', '번역기', 'Bing 번역', '발신', 'O', 408, 'Y', ''),
    ('LYMS', '번역기', 'Yandex 번역', '발신', 'O', 409, 'Y', ''),
    ('LUKS', '번역기', '기타', '발신', 'I', 410, 'Y', ''),
    ('IGBS', '생성형 AI', '구글 Gemini', '발신', 'O', 411, 'Y', ''),
    ('IBIS', '생성형 AI', ' Microsoft Copilot', '발신', 'O', 412, 'Y', ''),
    ('IWTS', '생성형 AI', 'wrtn', '발신', 'O', 413, 'Y', ''),
    ('IGPS', '생성형 AI', 'chatGPT', '발신', 'O', 414, 'Y', ''),
    ('IDAS', '생성형 AI', 'Dall-E', '발신', 'O', 415, 'Y', ''),
    ('IGCS', '생성형 AI', 'Github Copilot', '발신', 'I', 416, 'Y', ''),
    ('IYCS', '생성형 AI', 'YouChat', '발신', 'I', 417, 'Y', ''),
    ('ICSS', '생성형 AI', 'Chatsonic', '발신', 'I', 418, 'Y', ''),
    ('IRPS', '생성형 AI', 'replika', '발신', 'I', 419, 'Y', ''),
    ('IPPS', '생성형 AI', 'Perplexity', '발신', 'I', 420, 'Y', ''),
    ('ITCS', '생성형 AI', 'TextCortex', '발신', 'I', 421, 'Y', ''),
    ('IPHS', '생성형 AI', 'Phind', '발신', 'I', 422, 'Y', ''),
    ('IPOS', '생성형 AI', 'Poe', '발신', 'I', 423, 'Y', ''),
    ('IHFS', '생성형 AI', 'Hugging Face', '발신', 'I', 424, 'Y', ''),
    ('ICPS', '생성형 AI', 'Copy.AI', '발신', 'I', 425, 'Y', ''),
    ('IHWS', '생성형 AI', 'HyperWrite', '발신', 'I', 426, 'Y', ''),
    ('IDPS', '생성형 AI', 'DeepAI', '발신', 'I', 427, 'Y', ''),
    ('IACS', '생성형 AI', 'AskCodi', '발신', 'I', 428, 'Y', ''),
    ('INAS', '생성형 AI', 'Native', '발신', 'I', 429, 'Y', ''),
    ('INFS', '생성형 AI', 'NeuroFlash', '발신', 'I', 430, 'Y', ''),
    ('INOS', '생성형 AI', 'Notion AI', '발신', 'I', 431, 'Y', ''),
    ('IMES', '생성형 AI', 'Merlin', '발신', 'I', 432, 'Y', ''),
    ('ICXS', '생성형 AI', 'CLOVA-X', '발신', 'I', 433, 'Y', ''),
    ('IADS', '생성형 AI', 'Adobe AI', '발신', 'I', 434, 'Y', ''),
    ('ICDS', '생성형 AI', 'ClipDrop', '발신', 'I', 435, 'Y', ''),
    ('ISBS', '생성형 AI', 'Stability.Ai', '발신', 'I', 436, 'Y', ''),
    ('IRMS', '생성형 AI', 'Runwayml', '발신', 'I', 437, 'Y', ''),
    ('IGVS', '생성형 AI', 'Google Vertex', '발신', 'I', 438, 'Y', ''),
    ('IGLS', '생성형 AI', 'Google Colab', '발신', 'I', 439, 'Y', ''),
    ('ICWS', '생성형 AI', 'CodeWhisperer', '발신', 'I', 440, 'Y', ''),
    ('IMSS', '생성형 AI', 'MakerSuite', '발신', 'I', 441, 'Y', ''),
    ('IOCS', '생성형 AI', 'Clova OCR', '발신', 'I', 442, 'Y', ''),
    ('IAOS', '생성형 AI', 'Azure OpenAI', '발신', 'I', 443, 'Y', ''),
    ('ICUS', '생성형 AI', '네이버 CUE:', '발신', 'I', 444, 'Y', ''),
    ('IMJS', '생성형 AI', 'Midjourney', '발신', 'I', 445, 'Y', ''),
    ('ISGR', '생성형 AI', 'slidesGPT', '수신', 'I', 446, 'Y', ''),
    ('ISGS', '생성형 AI', 'slidesGPT', '발신', 'I', 447, 'Y', ''),
    ('IDMS', '생성형 AI', 'AiDocmaker', '발신', 'I', 448, 'Y', ''),
    ('IRKS', '생성형 AI', 'Reka AI', '발신', 'I', 449, 'Y', ''),
    ('ICLS', '생성형 AI', 'claude', '발신', 'I', 450, 'Y', ''),
    ('IDMR', '생성형 AI', 'Ai Docker Attach', '수신', 'I', 451, 'Y', ''),
    ('IADR', '생성형 AI', 'Adobe firefly login', '수신', 'I', 452, 'Y', ''),
    ('IWDS', '생성형 AI', 'Dream by WOMBO', '발신', 'I', 453, 'Y', ''),
    ('IGAS', '생성형 AI', 'GetImg.AI', '발신', 'I', 454, 'Y', ''),
    ('IWKS', '생성형 AI', 'wrks.ai', '발신', 'I', 455, 'Y', ''),
    ('IPSS', '생성형 AI', 'polaris office ai', '발신', 'I', 456, 'Y', ''),
    ('IUKS', '생성형 AI', '기타', '발신', 'I', 457, 'Y', ''),
    ('PDOS', '프로젝트', 'dooray', '발신', 'O', 458, 'Y', ''),
    ('PGIS', '프로젝트', 'github', '발신', 'O', 459, 'Y', ''),
    ('PGLS', '프로젝트', 'Glassdoor', '발신', 'O', 460, 'Y', ''),
    ('EBDR', '그룹웨어', '게시', '수신', 'I', 461, 'Y', ''),
    ('EBD-', '그룹웨어', '게시', '발신', 'O', 462, 'Y', ''),
    ('EBBR', '그룹웨어', '게시판', '수신', 'I', 463, 'Y', ''),
    ('EBBS', '그룹웨어', '게시판', '발신', 'O', 464, 'Y', ''),
    ('EBBF', '그룹웨어', '게시판', '파일수신', 'I', 465, 'Y', ''),
    ('EAAR', '그룹웨어', '결재', '수신', 'I', 466, 'Y', ''),
    ('EAAS', '그룹웨어', '결재', '발신', 'O', 467, 'Y', ''),
    ('EAAG', '그룹웨어', '결재', '통보 - 수신', 'I', 468, 'Y', ''),
    ('EAAP', '그룹웨어', '결재', '통보 - 발신', 'O', 469, 'Y', ''),
    ('EAAF', '그룹웨어', '결재', '파일수신', 'I', 470, 'Y', ''),
    ('EMMR', '그룹웨어', '메일', '그룹웨어 수신', 'I', 471, 'Y', ''),
    ('EMMS', '그룹웨어', '메일', '그룹웨어 발신', 'O', 472, 'Y', ''),
    ('EMMG', '그룹웨어', '메일', 'OWA 수신', 'I', 473, 'Y', ''),
    ('EMMP', '그룹웨어', '메일', 'OWA 발신', 'O', 474, 'Y', ''),
    ('EMMD', '그룹웨어', '메일', 'RPC 수신', 'I', 475, 'Y', ''),
    ('EMMU', '그룹웨어', '메일', 'RPC 발신', 'O', 476, 'Y', ''),
    ('EMMC', '그룹웨어', '메일', '수신', 'I', 477, 'Y', ''),
    ('EMML', '그룹웨어', '메일', '발신', 'O', 478, 'Y', ''),
    ('EMM1', '그룹웨어', '메일', '보안등급1', 'O', 479, 'Y', ''),
    ('EMM2', '그룹웨어', '메일', '보안등급2', 'O', 480, 'Y', ''),
    ('EMM3', '그룹웨어', '메일', '보안등급3', 'O', 481, 'Y', ''),
    ('EMM4', '그룹웨어', '메일', '보안등급4', 'O', 482, 'Y', ''),
    ('EMMA', '그룹웨어', '메일', '임시(자동)', 'O', 483, 'Y', ''),
    ('EMMT', '그룹웨어', '메일', '임시(수동)', 'O', 484, 'Y', ''),
    ('EMMK', '그룹웨어', '메일', 'Outlook - 수신', 'I', 485, 'Y', ''),
    ('EMMO', '그룹웨어', '메일', 'Outlook - 발신', 'O', 486, 'Y', ''),
    ('EMMB', '그룹웨어', '메일', '그룹웨어 예약메일', 'O', 487, 'Y', ''),
    ('EMBR', '그룹웨어', '모바일', '수신', 'I', 488, 'Y', ''),
    ('EMB-', '그룹웨어', '모바일', '발신', 'O', 489, 'Y', ''),
    ('EWSR', '그룹웨어', '웹서비스', '수신', 'I', 490, 'Y', ''),
    ('EWS-', '그룹웨어', '웹서비스', '발신', 'O', 491, 'Y', ''),
    ('EPUR', '그룹웨어', '일반', '수신', 'I', 492, 'Y', ''),
    ('EPU-', '그룹웨어', '일반', '발신', 'O', 493, 'Y', ''),
    ('EAU-', '그룹웨어', '일반(자동전달)', '자동전달', 'O', 494, 'Y', ''),
    ('ESCR', '그룹웨어', '일정 명함', '수신', 'I', 495, 'Y', ''),
    ('ESC-', '그룹웨어', '일정 명함', '발신', 'O', 496, 'Y', ''),
    ('EMF-', '그룹웨어', '파일 다운로드', '-', 'I', 497, 'Y', ''),
    ('EMU-', '그룹웨어', '기타', '', 'O', 498, 'Y', ''),
    ('EMDR', '그룹웨어', '드라이브', '수신', 'I', 499, 'Y', ''),
    ('EMDS', '그룹웨어', '드라이브', '발신', 'O', 500, 'Y', ''),
    ('ECIS', '그룹웨어', 'Samsung cic', '발신', 'O', 501, 'Y', ''),
    ('DCCS', '편집기', 'Clip Champ', '발신', 'O', 502, 'Y', ''),
    ('DFGS', '편집기', 'Figma', '발신', 'O', 503, 'Y', '');



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
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('AN', '주소(도로명, 지번)', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('BRN', '사업자 등록번호', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('CN', '카드번호', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('CPN', '법인 등록번호', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('CRN', '자동차 등록번호', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('DN', '운전면허번호', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('DRM', 'DRM 파일', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('EC', '확장자 변조 파일', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('EF', '암호화 파일', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('FN', '외국인 등록번호', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('ID', '송수신자 동일아이디', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('IMEI', 'IMEI', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('MCN', 'MAC 주소', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('MN', '휴대전화번호', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('PN', '여권번호', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('SN', '주민번호', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('SSN', '사회 보장번호', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('RS', '수신처 오지정 전송', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('LTO', '대용량 본문내용 사외발송', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('LAO', '대용량 첨부파일 사외발송', NULL);
INSERT
IGNORE INTO UI_REGEXP (CODE, NAME, REGEX) VALUES('LF', '대용량 파일 FTP 전송', NULL);








/* UI MENU */
INSERT
IGNORE INTO UI_MENU (`MENU_ID`, `MENU_DEFAULT_NAME`, `P_MENU_ID`, `PKG_TYPE`, `MENU_AUTH`, `MENU_LINK`, `MENU_ICON`, `MENU_ORDER`, `MENU_USEYN`, `MENU_IMG_PATH`)  VALUES
('ANALYSIS_FLUCTUATION', '사용량 증감 분석', 'DATA_ANALYSIS', 'L', 'M', 'analysis/usageCompare.do', 'fa fa-area-chart', 2, 'Y', NULL),
('ANALYSIS_INFO', '개인정보 유출 관계 분석', 'DATA_ANALYSIS', 'L', 'M', 'analysis/infoStat.do', 'fa fa-cube', 6, 'Y', NULL),
('ANALYSIS_CUSTOM','데이터 자유 분석','DATA_ANALYSIS','L','M','analysis/dataFreedom.do','fa fa-cube',3,'Y',NULL),
('ANALYSIS_RELATION', '데이터 관계 분석', 'DATA_ANALYSIS', 'L', 'M', 'analysis/dataRelation.do', 'fa fa-share-alt', 1, 'Y', NULL),
('ANALYSIS_SEARCH', '웹 검색어 동향 분석', 'DATA_ANALYSIS', 'L', 'N', 'analysis/searchKeyword.do', 'fa fa-cube', 5, 'N', NULL),
('ANALYSIS_UBA', '사용자 행위 분석', 'DATA_ANALYSIS', 'L', 'M', 'analysis/userBehavior.do', 'fa fa-cube', 4, 'N', NULL),
('AUDIT_LOG', '운용자 감사 로그', 'OPERATION_MGMT', 'L', 'S', 'commons/auditLog.do', 'fa fa-pencil-square', 7, 'Y', NULL),
('BUSI_IPRANGE', '사업장 내부 IP 설정', 'ORG', 'L', 'S', 'commons/ipRange.do', 'fa fa-building', 5, 'Y', NULL),
('BUSI_IPRANGE_VIEW', '사업장 내부 IP 확인', 'IPRANGE_VIEW', 'L', 'M', 'commons/ipRangeView.do', 'fa fa-building', 2, 'Y', NULL),
('CODE_INFO', '코드 정보', 'OPERATION_MGMT', 'L', 'S', 'commons/codeInfo.do', 'fa fa-list-ul', 3, 'Y', NULL),
('CONSENT_MGMT', '동의서 관리', 'MONITOR_MGMT', 'L', 'M', 'ems/consent.do', 'fa fa-flask', 5, 'Y', NULL),
('DASHBOARD', '대시보드', NULL, 'L', 'M', 'ems/index.do', 'fa fa-dashboard', 1, 'Y', '/img/ico_gnb_01.png'),
('DASHBOARD_MENU', 'Dashboard 메뉴', 'DASHBOARD', 'L', 'M', 'ems/dashboardMenu.do', 'fa fa-sort-amount-asc', 2, 'Y', NULL),
('DASHBOARD_SETUP', 'Dashboard 관리', 'DASHBOARD', 'L', 'M', 'ems/dashboardSetup.do', 'fa fa-cogs', 3, 'Y', NULL),
('DATA_ANALYSIS', '분석', NULL, 'L', 'M', NULL, 'fa fa-area-chart', 5, 'Y', '/img/ico_gnb_05.png'),
('DATA_MONITOR', '모니터링', NULL, 'L', 'M', NULL, 'glyphicon glyphicon-list-alt', 2, 'Y', '/img/ico_gnb_02.png'),
('DATA_REPORT', '보고서', NULL, 'L', 'M', NULL, 'fa fa-area-chart', 3, 'Y', '/img/ico_gnb_03.png'),
('DATA_STAT', '통계', NULL, 'L', 'M', '', 'fa fa-area-chart', 4, 'Y', '/img/ico_gnb_04.png'),
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
('IPRANGE_VIEW', '내부 IP 정보', 'DATA_MONITOR', 'L', 'M', 'commons/ipRangeDeptView.do', 'fa fa-building', 4, 'Y', NULL),
('KEYWORD_MGMT', '예약 키워드 관리', 'MONITOR_MGMT', 'L', 'M', 'ems/keywordInfo.do', 'fa fa-tasks', 2, 'Y', NULL),
('MESSAGE', '컨텐츠 모니터링', 'DATA_MONITOR', 'L', 'M', '', 'fa fa-envelope', 1, 'Y', NULL),
('MESSAGE_INFO', '메시지 정보', 'MESSAGE', 'L', 'M', 'ems/message.do', 'fa fa-envelope', 1, 'Y', NULL),
('MESSAGE_SERVICE', '메신저 모아보기', 'MESSAGE', 'L', 'M', 'ems/msg/messenger.do', 'fa fa-envelope', 3, 'Y', NULL),
('MONITOR_MGMT', '데이터 설정 관리', 'DATA_MONITOR', 'L', 'M', 'ems/interestUser.do', 'fa fa-male', 2, 'Y', NULL),
('NOTE_SERVICE', '노트 모아보기', 'MESSAGE', 'L', 'M', 'ems/msg/note.do', 'fa fa-envelope', 5, 'Y', NULL),
('OPERATION_MGMT', '운용 관리', NULL, 'L', 'M', NULL, 'glyphicon glyphicon-th', 7, 'Y', '/img/ico_gnb_07.png'),
('ORG', '조직 관리', 'POLICY_SETUP', 'L', 'S', NULL, 'fa fa-users', 2, 'Y', NULL),
('ORG_MGMT', '조직 관리', 'ORG', 'L', 'S', 'commons/organizationInfo.do', 'fa fa-users', 1, 'Y', NULL),
('POLICY_MGMT', '컨텐츠 미로깅 정책', 'POLICY_SETUP', 'L', 'S', 'uacs/filterInfo.do', 'fa fa-unlink', 1, 'Y', NULL),
('POLICY_NOLOG', '데이터 미로깅 정책', 'POLICY_MGMT', 'L', 'S', 'uacs/filterInfo.do', 'fa fa-unlink', 1, 'Y', NULL),
('POLICY_SETUP', '정책 설정', NULL, 'L', 'S', NULL, 'glyphicon glyphicon-eye-close', 6, 'Y', '/img/ico_gnb_06.png'),
('PATTERN_INFO', '패턴 관리', 'MONITOR_MGMT', 'L', 'M', 'ems/PatternInfo.do', 'fa fa-building', 4, 'Y', NULL),
('RELATION_KEYWORD', '연관 키워드 관리', 'MONITOR_MGMT', 'L', 'M', 'ems/relationKeyword.do', 'fa fa-building', 3, 'Y', NULL),
('REPORT_CONTENT', '컨텐츠 보고서', 'DATA_REPORT', 'L', 'M', 'report/contentReport.do', 'glyphicon glyphicon-list-alt', 2, 'Y', NULL),
('REPORT_DEVICE', '장비 운용 보고서', 'DATA_REPORT', 'L', 'M', 'report/deviceReport.do', 'fa fa-area-chart', 3, 'N', NULL),
('REPORT_TRAFFIC', '트래픽 보고서', 'DATA_REPORT', 'L', 'M', 'report/trafficReport.do', 'fa fa-area-chart', 1, 'N', NULL),
('RESERVATION', '알림 관리', 'DATA_MONITOR', 'L', 'M', 'ems/reservationAlarm.do', 'fa fa-building', 3, 'Y', NULL),
('RESERVATION_ALARM', '예약 알림', 'RESERVATION', 'L', 'M', 'ems/reservationAlarm.do', 'fa fa-calendar', 5, 'Y', NULL),
('SEARCH_LOG', '조회이력', 'OPERATION_MGMT', 'L', 'S', 'commons/searchLog.do', 'fa fa-pencil', 6, 'Y', NULL),
('STAT_ADMINREAD', '운용자 열람 통계', 'STAT_CONTENT', 'L', 'M', 'ems/adminReadStat.do', 'fa fa-pie-chart', 9, 'Y', NULL),
('STAT_SERVICEADMINREAD', '서비스 타입 운용자 열람 통계', 'STAT_CONTENT', 'L', 'M', 'ems/serviceAdminReadStat.do', 'fa fa-pie-chart', 12, 'Y', NULL),
('STAT_ATTACHNAME', '첨부 파일명 통계', 'STAT_CONTENT', 'L', 'M', 'ems/attachNameStat.do', 'fa fa-pie-chart', 7, 'Y', NULL),
('STAT_ATTACHTYPE', '첨부 파일 통계', 'STAT_CONTENT', 'L', 'M', 'ems/attachTypeStat.do', 'fa fa-pie-chart', 6, 'Y', NULL),
('STAT_CONTENT', '컨텐츠 통계', 'DATA_STAT', 'L', 'M', 'ems/usersStat.do', 'fa fa-pie-chart', 2, 'Y', NULL),
('STAT_DEVTRAFFIC', '장비 트래픽 통계', 'STAT_TRAFFIC', 'L', 'M', 'ems/trafficStat.do', 'fa fa-pie-chart', 1, 'Y', NULL),
('STAT_DSTIPTOP', '목적지 IP TOP100', 'STAT_TRAFFIC', 'L', 'M', 'ems/dstIpTop.do', 'fa fa-pie-chart', 2, 'N', NULL),
('STAT_DSTPORTTOP', '목적지 Port TOP100', 'STAT_TRAFFIC', 'L', 'M', 'ems/dstPortTop.do', 'fa fa-pie-chart', 3, 'N', NULL),
('STAT_INFOTYPE', '정보 분류 통계', 'STAT_CONTENT', 'L', 'M', 'ems/infoTypeStat.do', 'fa fa-pie-chart', 11, 'Y', NULL),
('STAT_INTEREST', '관심 사용자 통계', 'STAT_CONTENT', 'L', 'M', 'ems/interestUserStat.do', 'fa fa-pie-chart', 2, 'Y', NULL),
('STAT_IPNONIP', 'IP/non-IP 빈도', 'STAT_TRAFFIC', 'L', 'M', 'ems/ipNonIp.do', 'fa fa-pie-chart', 5, 'N', NULL),
('STAT_KWD', '예약어 통계', 'STAT_CONTENT', 'L', 'M', 'ems/keywordStat.do', 'fa fa-pie-chart', 5, 'Y', NULL),
('STAT_OCR', 'IMG2TXT(OCR) 처리 현황', 'STAT_CONTENT', 'L', 'M', 'ems/ocrStat.do', 'fa fa-pie-chart', 10, 'Y', NULL),
('STAT_SENDER', '발신자 통계', 'STAT_CONTENT', 'L', 'M', 'ems/senderStat.do', 'fa fa-pie-chart', 3, 'Y', NULL),
('STAT_SRCIPTOP', '출발지 IP TOP100', 'STAT_TRAFFIC', 'L', 'M', 'ems/srcIpTop.do', 'fa fa-pie-chart', 4, 'N', NULL),
('STAT_SVC', '서비스타입 통계', 'STAT_CONTENT', 'L', 'M', 'ems/serviceStat.do', 'fa fa-pie-chart', 4, 'Y', NULL),
('STAT_TRAFFIC', '네트워크 통계', 'DATA_STAT', 'L', 'M', 'ems/trafficStat.do', 'fa fa-pie-chart', 1, 'Y', NULL),
('STAT_URL', 'URL 통계', 'STAT_CONTENT', 'L', 'M', 'ems/hostStat.do', 'fa fa-pie-chart', 8, 'Y', NULL),
('STAT_USER', '사용자 통계', 'STAT_CONTENT', 'L', 'M', 'ems/usersStat.do', 'fa fa-pie-chart', 1, 'Y', NULL),
('STAT_WEBTOP', '웹 URL TOP100', 'STAT_TRAFFIC', 'L', 'M', 'ems/webUrlTop.do', 'fa fa-pie-chart', 6, 'N', NULL),
('USER_GROUP_MGMT', '사용자 그룹', 'ORG', 'L', 'S', 'commons/userGroup.do', 'fa fa-user-circle', 3, 'Y', NULL),
('USER_MGMT', '사용자 관리', 'ORG', 'L', 'S', 'commons/userInfo.do', 'fa fa-user', 2, 'Y', NULL),
('ADMIN_MGMT','운용자 관리','OPERATION_MGMT','L','S','commons/admin.do','fa fa-unlock-alt',4,'Y',NULL),
-- ('STAT_KEYWORDHOST','핵심 기술 키워드 탐지 HOST TOP','STAT_CONTENT','L','S','ems/keywordHost.do','fa fa-pie-chart',14,'Y',NULL),
-- ('STAT_KEYWORDNEW','핵심 기술 키워드 탐지 NEW HOST','STAT_CONTENT','L','S','ems/keywordNew.do','fa fa-pie-chart',15,'Y',NULL),
('ADMIN_MGMT','운용자 관리','OPERATION_MGMT','L','S','commons/admin.do','fa fa-unlock-alt',4,'Y',NULL);



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
FROM UI_CUSTOM_DASHBOARD_DEFAULT
