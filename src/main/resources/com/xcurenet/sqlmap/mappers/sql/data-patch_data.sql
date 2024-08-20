USE EMASSAI;


CREATE TABLE IF NOT EXISTS UI_MAIL_NOLOG(
    MAIL_LOG_SEQ  INT(11)  NOT NULL    COMMENT 'MAIL 미로깅 일련번호',
    MAIL  VARCHAR(128)  NOT NULL    COMMENT 'MAIL',
    CREATE_USER varchar(30) DEFAULT NULL COMMENT '작성자',
    CREATE_DT  DATETIME  NULL    COMMENT '작성일',
    USE_YN  CHAR(1)  NOT NULL  DEFAULT 'Y'  COMMENT '사용 여부(Y:사용, N:사용안함(삭제) )',
    PRIMARY KEY (MAIL_LOG_SEQ)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='MAIL 미로깅';


CREATE TABLE IF NOT EXISTS HOST_INFO (
    host VARCHAR(255) NOT NULL COMMENT 'host 이름',
    description TEXT  NULL COMMENT 'host 설명',
    PRIMARY KEY (host)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='미분류 host 설명';

CREATE TABLE IF NOT EXISTS HOST_CATEGORY (
    host VARCHAR(255) NOT NULL COMMENT 'host 이름',
    description TEXT  NULL COMMENT 'host 설명',
    PRIMARY KEY (host)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='미분류 host 설명';



CALL ALTER_TB( 'UI_ADMIN' , 'WORK_STATUS' , 'ALTER TABLE UI_ADMIN ADD WORK_STATUS  CHAR(1)  NULL  DEFAULT \'S\' AFTER STATUS');
CALL ALTER_TB('UI_ADMIN', 'INSIDE', 'ALTER TABLE EMASSAI.UI_ADMIN ADD INSIDE  varchar(1) DEFAULT \'N\'   COMMENT \'내부데이터\'');
CALL ALTER_TB( 'UI_ADMIN' , 'RESIGN_DT' , 'ALTER TABLE EMASSAI.UI_ADMIN ADD RESIGN_DT datetime DEFAULT NULL  COMMENT \'퇴직\'');
CALL ALTER_TB( 'UI_ADMIN' , 'LEAVE_DT' , 'ALTER TABLE EMASSAI.UI_ADMIN ADD LEAVE_DT datetime DEFAULT NULL  COMMENT \'휴직\'');
CALL ALTER_TB( 'UI_ADMIN' , 'INFO_FEEDBACK' , 'ALTER TABLE EMASSAI.UI_ADMIN ADD INFO_FEEDBACK char(1) DEFAULT \'N\' COMMENT \'정보분류 피드백\'');
CALL ALTER_TB( 'UI_DEVICE' , 'DEVICE_SYS_EID' , 'ALTER TABLE EMASSAI.UI_DEVICE ADD DEVICE_SYS_EID int(11) DEFAULT NULL COMMENT \'장비 EID\'');
CALL ALTER_TB( 'UI_DOMAIN_NOLOG' , 'CREATE_USER' , 'ALTER TABLE EMASSAI.UI_DOMAIN_NOLOG ADD CREATE_USER varchar(30) DEFAULT NULL COMMENT \'작성자\'');
CALL ALTER_TB( 'UI_ID_NOLOG' , 'CREATE_USER' , 'ALTER TABLE EMASSAI.UI_ID_NOLOG ADD CREATE_USER varchar(30) DEFAULT NULL COMMENT \'작성자\'');
CALL ALTER_TB( 'UI_IP_NOLOG_DEVICE' , 'FILTER_IDX' , 'ALTER TABLE EMASSAI.UI_IP_NOLOG_DEVICE ADD FILTER_IDX int(11) unsigned DEFAULT NULL COMMENT \'IP FILTER OID\'');
CALL ALTER_TB( 'UI_IP_NOLOG' , 'CREATE_USER' , 'ALTER TABLE EMASSAI.UI_IP_NOLOG ADD CREATE_USER varchar(30) DEFAULT NULL COMMENT \'작성자\'');
CALL ALTER_TB( 'UI_SIZE_LOG' , 'CREATE_USER' , 'ALTER TABLE EMASSAI.UI_SIZE_LOG ADD CREATE_USER varchar(30) DEFAULT NULL COMMENT \'작성자\'');
CALL ALTER_TB( 'UI_SUBJECT_NOLOG' , 'CREATE_USER' , 'ALTER TABLE EMASSAI.UI_SUBJECT_NOLOG ADD CREATE_USER varchar(30) DEFAULT NULL COMMENT \'작성자\'');
CALL ALTER_TB( 'UI_URL_NOLOG' , 'CREATE_USER' , 'ALTER TABLE EMASSAI.UI_URL_NOLOG ADD CREATE_USER varchar(30) DEFAULT NULL COMMENT \'작성자\'');
CALL ALTER_TB( 'UI_USERS' , 'SABUN' , 'ALTER TABLE EMASSAI.UI_USERS ADD SABUN varchar(250) DEFAULT NULL COMMENT \'사번\'');
CALL ALTER_TB( 'UI_USERS' , 'STDT' , 'ALTER TABLE EMASSAI.UI_USERS ADD STDT date DEFAULT NULL COMMENT \'시작일\'');
CALL ALTER_TB( 'UI_USERS' , 'EDDT' , 'ALTER TABLE EMASSAI.UI_USERS ADD EDDT date DEFAULT NULL COMMENT \'종료일\'');
CALL ALTER_TB( 'UI_USERS' , 'ASCD' , 'ALTER TABLE EMASSAI.UI_USERS ADD ASCD varchar(20) DEFAULT NULL COMMENT \'제조번호\'');
CALL ALTER_TB( 'UI_USERS' , 'EMAIL' , 'ALTER TABLE EMASSAI.UI_USERS ADD EMAIL varchar(120) DEFAULT NULL COMMENT \'이메일\'');
CALL ALTER_TB( 'UI_ALARM' , 'ALARM_WEEK' , 'ALTER TABLE UI_ALARM ADD ALARM_WEEK INT(1) COMMENT \'ALARM 요일(1-월, 2-화, 3-수, 4-목, 5-금, 6-토, 7-일\' AFTER ALARM_CYCLE_VAL');
CALL ALTER_TB( 'UI_ADMIN_USER_GROUP' , 'GROUP_COLOR' , 'ALTER TABLE EMASSAI.UI_ADMIN_USER_GROUP ADD GROUP_COLOR varchar(7) DEFAULT \'#5376A3\' COMMENT \'그룹 색상\' AFTER GROUP_NAME');
CALL ALTER_TB( 'UI_ADMIN' , 'LOGIN_TYPE' , 'ALTER TABLE EMASSAI.UI_ADMIN ADD LOGIN_TYPE CHAR(1) DEFAULT \'C\'  COMMENT \'접속 로그인 방식\'');
CALL ALTER_TB( 'UI_DOWNLOAD_BATCH' , 'SKIP_ROWS' , 'ALTER TABLE EMASSAI.UI_DOWNLOAD_BATCH ADD SKIP_ROWS BIGINT UNSIGNED DEFAULT \'0\' COMMENT \'skip Row\'');
CALL ALTER_TB( 'UI_DOWNLOAD_BATCH' , 'UPDATE_DT' , 'ALTER TABLE EMASSAI.UI_DOWNLOAD_BATCH ADD UPDATE_DT DATETIME DEFAULT NULL COMMENT \'상태 Update 시간\'');

CALL ALTER_TB( 'UI_BUSI_IPRANGE' , 'CREATE_ID' , 'ALTER TABLE EMASSAI.UI_BUSI_IPRANGE ADD CREATE_ID VARCHAR(50) NULL COMMENT \'생성 운용자 아이디\'');
CALL ALTER_TB( 'UI_BUSI_IPRANGE' , 'UPDATE_DT' , 'ALTER TABLE EMASSAI.UI_BUSI_IPRANGE ADD UPDATE_DT DATETIME NULL COMMENT \'수정일\'');
CALL ALTER_TB( 'UI_BUSI_IPRANGE' , 'UPDATE_ID' , 'ALTER TABLE EMASSAI.UI_BUSI_IPRANGE ADD UPDATE_ID VARCHAR(50) NULL COMMENT \'수정 운용자 아이디\'');

CALL ALTER_TB( 'UI_DEPT_IPRANGE' , 'CREATE_ID' , 'ALTER TABLE EMASSAI.UI_DEPT_IPRANGE ADD CREATE_ID VARCHAR(50) NULL COMMENT \'생성 운용자 아이디\'');
CALL ALTER_TB( 'UI_DEPT_IPRANGE' , 'UPDATE_DT' , 'ALTER TABLE EMASSAI.UI_DEPT_IPRANGE ADD UPDATE_DT DATETIME NULL COMMENT \'수정일\'');
CALL ALTER_TB( 'UI_DEPT_IPRANGE' , 'UPDATE_ID' , 'ALTER TABLE EMASSAI.UI_DEPT_IPRANGE ADD UPDATE_ID VARCHAR(50) NULL COMMENT \'수정 운용자 아이디\'');

CALL ALTER_TB( 'UI_ID_NOLOG' , 'UPDATE_DT' , 'ALTER TABLE EMASSAI.UI_ID_NOLOG ADD UPDATE_DT DATETIME NULL COMMENT \'수정일\'');
CALL ALTER_TB( 'UI_ID_NOLOG' , 'UPDATE_ID' , 'ALTER TABLE EMASSAI.UI_ID_NOLOG ADD UPDATE_ID VARCHAR(50) NULL COMMENT \'수정 운용자 아이디\'');
CALL ALTER_TB( 'UI_DOMAIN_NOLOG' , 'UPDATE_DT' , 'ALTER TABLE EMASSAI.UI_DOMAIN_NOLOG ADD UPDATE_DT DATETIME NULL COMMENT \'수정일\'');
CALL ALTER_TB( 'UI_DOMAIN_NOLOG' , 'UPDATE_ID' , 'ALTER TABLE EMASSAI.UI_DOMAIN_NOLOG ADD UPDATE_ID VARCHAR(50) NULL COMMENT \'수정 운용자 아이디\'');
CALL ALTER_TB( 'UI_IP_NOLOG' , 'UPDATE_DT' , 'ALTER TABLE EMASSAI.UI_IP_NOLOG ADD UPDATE_DT DATETIME NULL COMMENT \'수정일\'');
CALL ALTER_TB( 'UI_IP_NOLOG' , 'UPDATE_ID' , 'ALTER TABLE EMASSAI.UI_IP_NOLOG ADD UPDATE_ID VARCHAR(50) NULL COMMENT \'수정 운용자 아이디\'');
CALL ALTER_TB( 'UI_URL_NOLOG' , 'UPDATE_DT' , 'ALTER TABLE EMASSAI.UI_URL_NOLOG ADD UPDATE_DT DATETIME NULL COMMENT \'수정일\'');
CALL ALTER_TB( 'UI_URL_NOLOG' , 'UPDATE_ID' , 'ALTER TABLE EMASSAI.UI_URL_NOLOG ADD UPDATE_ID VARCHAR(50) NULL COMMENT \'수정 운용자 아이디\'');
CALL ALTER_TB( 'UI_SUBJECT_NOLOG' , 'UPDATE_DT' , 'ALTER TABLE EMASSAI.UI_SUBJECT_NOLOG ADD UPDATE_DT DATETIME NULL COMMENT \'수정일\'');
CALL ALTER_TB( 'UI_SUBJECT_NOLOG' , 'UPDATE_ID' , 'ALTER TABLE EMASSAI.UI_SUBJECT_NOLOG ADD UPDATE_ID VARCHAR(50) NULL COMMENT \'수정 운용자 아이디\'');
CALL ALTER_TB( 'UI_SIZE_LOG' , 'UPDATE_DT' , 'ALTER TABLE EMASSAI.UI_SIZE_LOG ADD UPDATE_DT DATETIME NULL COMMENT \'수정일\'');
CALL ALTER_TB( 'UI_SIZE_LOG' , 'UPDATE_ID' , 'ALTER TABLE EMASSAI.UI_SIZE_LOG ADD UPDATE_ID VARCHAR(50) NULL COMMENT \'수정 운용자 아이디\'');
CALL ALTER_TB( 'UI_DOWNLOAD_BATCH' , 'SKIP_TEXT' , 'ALTER TABLE EMASSAI.UI_DOWNLOAD_BATCH ADD SKIP_TEXT LONGTEXT NULL COMMENT \'skip 사유\'');

CALL ALTER_TB( 'UI_KEYWORD_GROUP' , 'CORE_YN' , 'ALTER TABLE EMASSAI.UI_KEYWORD_GROUP ADD CORE_YN char(1) DEFAULT \'N\' COMMENT \'핵심 예약어 그룹 유무\'');
/*DROP FUNCTION IF EXISTS xcnenc;
DROP FUNCTION IF EXISTS xcndec;
CREATE FUNCTION xcnenc returns string soname "xcnenc.so";
CREATE FUNCTION xcndec returns string soname "xcnenc.so";*/


INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'query.type', 'A', 'A', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='query.type');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'ceo.readyn', 'Y', 'Y', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='ceo.readyn');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'attach.image.body', 'false', 'false', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='attach.image.body');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'message.epmsg.val', 'N', 'N', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='message.epmsg.val');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'message.user.format', '#name#/#email#/#businm#/#deptnm#/#jikgubnm#/#ip#/#sabun#', '#name#/#email#/#businm#/#deptnm#/#jikgubnm#/#ip#/#sabun#', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='message.user.format');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'info.feedback.used', 'false', 'false', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='info.feedback.used');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'info.hynix.used', 'false', 'false', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='info.hynix.used');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'info.feedback.mode', 'D', 'D', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='info.feedback.mode');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'body.samsung.tables', 'N', 'N', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='body.samsung.tables');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'google.otp.used', 'false', 'false', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='google.otp.used');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'recvs.jikgub.use', 'false', 'false', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='recvs.jikgub.use');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'system.arch', 'standalone', 'standalone', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='system.arch');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'receiver.sender.uppercase', 'N', 'N', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='receiver.sender.uppercase');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'insa.dept.basepoint', 'F', 'F', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='insa.dept.basepoint');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'snmpa.community', 'xcn_lp', 'xcn_lp', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='snmpa.community');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'chrony.server.used', 'true', 'true', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='chrony.server.used');



INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'llm.single', 'false', 'false', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='llm.single');


CREATE TABLE IF NOT EXISTS `UI_USER_ACCOUNT` (
  `USER_ID` varchar(250) NOT NULL,
  `SERVICECD` char(3) NOT NULL,
  `ACCOUNT` varchar(250) NOT NULL,
  PRIMARY KEY (`USER_ID`,`SERVICECD`,`ACCOUNT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS UI_CHRONY(
    CHRONY_SEQ INT(11) NOT NULL AUTO_INCREMENT COMMENT '크로니 기본키',
    CHRONY_STATUS VARCHAR(30) NOT NULL COMMENT '크로니 상태',
    CHRONY_SERVER VARCHAR(50) NULL COMMENT '크로니 이름',
    CORNY_DATATIME DATETIME  NULL COMMENT '크로니 등록 시간',
    PRIMARY KEY (CHRONY_SEQ)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='크로니 서버 상태 저장';


/* 서비스 */
-- DELETE FROM UI_SERVICE;
INSERT IGNORE INTO UI_SERVICE (`SERVICECD`, `SERVICENM_LV1`, `SERVICENM_LV2`, `SERVICENM_LV3`, `IN_OUT`, `SORT`, `USE_YN`, `MSGGRPCD`)  VALUES ('MP3-', '메일', 'POP3', '-', 'I', 1, 'Y', ''),
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
    ('WYDR', '웹메일', 'Yandex', '수신', 'I', 69, 'Y', ''),
    ('WYDS', '웹메일', 'Yandex', '발신', 'O', 70, 'Y', ''),
    ('WYDT', '웹메일', 'Yandex', '임시저장', 'O', 71, 'Y', ''),
    ('WDOR', '웹메일', 'Dooray', '수신', 'I', 72, 'Y', ''),
    ('WDOS', '웹메일', 'Dooray', '발신', 'O', 73, 'Y', ''),
    ('WDOT', '웹메일', 'Dooray', '임시저장', 'O', 74, 'Y', ''),
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
    ('CUKR', '커뮤니티', '기타', '수신', 'I', 101, 'Y', ''),
    ('CUKS', '커뮤니티', '기타', '발신', 'O', 102, 'Y', ''),
    ('CUKD', '커뮤니티', '기타', '댓글', 'O', 103, 'Y', ''),
    ('SFBR', '소셜', '페이스북', '수신', 'I', 104, 'Y', ''),
    ('SFBS', '소셜', '페이스북', '발신', 'O', 105, 'Y', ''),
    ('SFBD', '소셜', '페이스북', '댓글', 'O', 106, 'Y', ''),
    ('STWR', '소셜', '트위터', '수신', 'I', 107, 'Y', ''),
    ('STWS', '소셜', '트위터', '발신', 'O', 108, 'Y', ''),
    ('STWD', '소셜', '트위터', '댓글', 'O', 109, 'Y', ''),
    ('SKAR', '소셜', '카카오스토리', '수신', 'I', 110, 'Y', ''),
    ('SKAS', '소셜', '카카오스토리', '발신', 'O', 111, 'Y', ''),
    ('SKAD', '소셜', '카카오스토리', '댓글', 'O', 112, 'Y', ''),
    ('SNVR', '소셜', '네이버 블로그', '수신', 'I', 113, 'Y', ''),
    ('SNVS', '소셜', '네이버 블로그', '발신', 'O', 114, 'Y', ''),
    ('SNVD', '소셜', '네이버 블로그', '댓글', 'O', 115, 'Y', ''),
    ('SNVT', '소셜', '네이버 블로그', '임시저장', 'O', 116, 'Y', ''),
    ('SNVU', '소셜', '네이버 블로그', '수정', 'O', 117, 'Y', ''),
    ('SDUR', '소셜', '다음 블로그', '수신', 'I', 118, 'Y', ''),
    ('SDUS', '소셜', '다음 블로그', '발신', 'O', 119, 'Y', ''),
    ('SDUD', '소셜', '다음 블로그', '댓글', 'O', 120, 'Y', ''),
    ('STSR', '소셜', '티스토리', '수신', 'I', 121, 'Y', ''),
    ('STSS', '소셜', '티스토리', '발신', 'O', 122, 'Y', ''),
    ('STSD', '소셜', '티스토리', '댓글', 'O', 123, 'Y', ''),
    ('STST', '소셜', '티스토리', '임시저장', 'O', 124, 'Y', ''),
    ('STBR', '소셜', '텀블러', '수신', 'I', 125, 'Y', ''),
    ('STBS', '소셜', '텀블러', '발신', 'O', 126, 'Y', ''),
    ('STBD', '소셜', '텀블러', '댓글', 'O', 127, 'Y', ''),
    ('SWBR', '소셜', '웨이보', '수신', 'I', 128, 'Y', ''),
    ('SWBS', '소셜', '웨이보', '발신', 'O', 129, 'Y', ''),
    ('SWBD', '소셜', '웨이보', '댓글', 'O', 130, 'Y', ''),
    ('SLKR', '소셜', '링크드인', '수신', 'I', 131, 'Y', ''),
    ('SLKS', '소셜', '링크드인', '발신', 'O', 132, 'Y', ''),
    ('SLKD', '소셜', '링크드인', '댓글', 'O', 133, 'Y', ''),
    ('SEGR', '소셜', '이글루', '수신', 'I', 134, 'Y', ''),
    ('SEGS', '소셜', '이글루', '발신', 'O', 135, 'Y', ''),
    ('SEGD', '소셜', '이글루', '댓글', 'O', 136, 'Y', ''),
    ('SYMR', '소셜', '야머', '수신', 'I', 137, 'Y', ''),
    ('SYMS', '소셜', '야머', '발신', 'O', 138, 'Y', ''),
    ('SYMD', '소셜', '야머', '댓글', 'O', 139, 'Y', ''),
    ('SYMF', '소셜', '야머', '파일전송', 'O', 140, 'Y', ''),
    ('SNBR', '소셜', '네이버 밴드', '수신', 'I', 141, 'Y', ''),
    ('SNBS', '소셜', '네이버 밴드', '발신', 'O', 142, 'Y', ''),
    ('SNBD', '소셜', '네이버 밴드', '댓글', 'O', 143, 'Y', ''),
    ('SLRR', '소셜', '라이브리', '수신', 'I', 144, 'Y', ''),
    ('SLRS', '소셜', '라이브리', '발신', 'O', 145, 'Y', ''),
    ('SLRD', '소셜', '라이브리', '댓글', 'O', 146, 'Y', ''),
    ('SMER', '소셜', 'Medium', '수신', 'I', 147, 'Y', ''),
    ('SMES', '소셜', 'Medium', '발신', 'O', 148, 'Y', ''),
    ('SMED', '소셜', 'MedMediumium', '댓글', 'O', 149, 'Y', ''),
    ('SISR', '소셜', '인스타그램', '수신', 'I', 150, 'Y', ''),
    ('SISS', '소셜', '인스타그램', '발신', 'O', 151, 'Y', ''),
    ('SISD', '소셜', '인스타그램', '댓글', 'O', 152, 'Y', ''),
    ('SISF', '소셜', '인스타그램', '파일전송', 'O', 153, 'Y', ''),
    ('VDUR', '영상 스트리밍', '다음 TV', '수신', 'I', 154, 'Y', ''),
    ('VDUS', '영상 스트리밍', '다음 TV', '발신', 'O', 155, 'Y', ''),
    ('VPDR', '영상 스트리밍', '판도라 TV', '수신', 'I', 156, 'Y', ''),
    ('VPDS', '영상 스트리밍', '판도라 TV', '발신', 'O', 157, 'Y', ''),
    ('VGMR', '영상 스트리밍', '곰 TV', '수신', 'I', 158, 'Y', ''),
    ('VGMS', '영상 스트리밍', '곰 TV', '발신', 'O', 159, 'Y', ''),
    ('VYTR', '영상 스트리밍', '유튜브', '수신', 'I', 160, 'Y', ''),
    ('VYTS', '영상 스트리밍', '유튜브', '발신', 'O', 161, 'Y', ''),
    ('VYTD', '영상 스트리밍', '유튜브', '댓글', 'O', 162, 'Y', ''),
    ('VNVR', '영상 스트리밍', '네이버 TV캐스트', '수신', 'I', 163, 'Y', ''),
    ('VNVS', '영상 스트리밍', '네이버 TV캐스트', '발신', 'O', 164, 'Y', ''),
    ('QNVC', '메신저', '네이버', '채팅', 'O', 165, 'N', ''),
    ('QNVF', '메신저', '네이버', '파일전송', 'O', 166, 'N', ''),
    ('QNMR', '메신저', '네이버 쪽지', '수신', 'I', 167, 'N', ''),
    ('QNMS', '메신저', '네이버 쪽지', '발신', 'O', 168, 'N', ''),
    ('QDUC', '메신저', '다음', '채팅', 'O', 169, 'N', ''),
    ('QDUF', '메신저', '다음', '파일전송', 'O', 170, 'N', ''),
    ('QDUM', '메신저', '다음', '쪽지', 'O', 171, 'N', ''),
    ('QDSC', '메신저', '대신', '채팅', 'O', 172, 'N', ''),
    ('QDSF', '메신저', '대신', '파일전송', 'O', 173, 'N', ''),
    ('QDSM', '메신저', '대신', '쪽지', 'O', 174, 'N', ''),
    ('QSHC', '메신저', '삼홍사', '채팅', 'O', 175, 'Y', ''),
    ('QSHF', '메신저', '삼홍사', '파일전송', 'O', 176, 'Y', ''),
    ('QSHM', '메신저', '삼홍사', '쪽지', 'O', 177, 'Y', ''),
    ('QDIC', '메신저', '동부생명', '채팅', 'O', 178, 'Y', ''),
    ('QDIF', '메신저', '동부생명', '파일전송', 'O', 179, 'Y', ''),
    ('QDIM', '메신저', '동부생명', '쪽지', 'O', 180, 'Y', ''),
    ('QDFC', '메신저', '동부금융', '채팅', 'O', 181, 'Y', ''),
    ('QDFF', '메신저', '동부금융', '파일전송', 'O', 182, 'Y', ''),
    ('QDFM', '메신저', '동부금융', '쪽지', 'O', 183, 'Y', ''),
    ('QDGC', '메신저', '동국제강', '채팅', 'O', 184, 'Y', ''),
    ('QDGF', '메신저', '동국제강', '파일전송', 'O', 185, 'Y', ''),
    ('QDGM', '메신저', '동국제강', '쪽지', 'O', 186, 'Y', ''),
    ('QFMC', '메신저', '프리본드', '채팅', 'O', 187, 'Y', 'MSG'),
    ('QFMF', '메신저', '프리본드', '파일전송', 'O', 188, 'Y', 'MSG'),
    ('QFMM', '메신저', '프리본드', '쪽지', 'O', 189, 'Y', 'MSG'),
    ('QFMJ', '메신저', '프리본드', '참여', 'O', 190, 'Y', 'MSG'),
    ('QFML', '메신저', '프리본드', '떠남', 'O', 191, 'Y', 'MSG'),
    ('QMCC', '메신저', 'M-채널', '채팅', 'O', 192, 'Y', ''),
    ('QMCF', '메신저', 'M-채널', '파일전송', 'O', 193, 'Y', ''),
    ('QMCM', '메신저', 'M-채널', '쪽지', 'O', 194, 'Y', ''),
    ('QMSC', '메신저', '미쓰리', '채팅', 'O', 195, 'Y', 'MSG'),
    ('QMSF', '메신저', '미쓰리', '파일전송', 'O', 196, 'Y', 'MSG'),
    ('QMSM', '메신저', '미쓰리', '쪽지', 'O', 197, 'Y', 'MSG'),
    ('QMSJ', '메신저', '미쓰리', '참여', 'O', 198, 'Y', 'MSG'),
    ('QMSL', '메신저', '미쓰리', '떠남', 'O', 199, 'Y', 'MSG'),
    ('QNTC', '메신저', '네이트', '채팅', 'O', 200, 'Y', 'MSG'),
    ('QNTF', '메신저', '네이트', '파일전송', 'O', 201, 'Y', 'MSG'),
    ('QNTM', '메신저', '네이트', '쪽지', 'O', 202, 'Y', 'MSG'),
    ('QNTJ', '메신저', '네이트', '참여', 'O', 203, 'Y', 'MSG'),
    ('QNTL', '메신저', '네이트', '떠남', 'O', 204, 'Y', 'MSG'),
    ('QSSC', '메신저', '삼성증권', '채팅', 'O', 205, 'N', ''),
    ('QSSF', '메신저', '삼성증권', '파일전송', 'O', 206, 'N', ''),
    ('QSSM', '메신저', '삼성증권', '쪽지', 'O', 207, 'N', ''),
    ('QSFC', '메신저', '삼성화재', '채팅', 'O', 208, 'Y', ''),
    ('QSFF', '메신저', '삼성화재', '파일전송', 'O', 209, 'Y', ''),
    ('QSFM', '메신저', '삼성화재', '쪽지', 'O', 210, 'Y', ''),
    ('QSFJ', '메신저', '삼성화재', '참여', 'O', 211, 'Y', ''),
    ('QSFL', '메신저', '삼성화재', '떠남', 'O', 212, 'Y', ''),
    ('QSPC', '메신저', 'SK 프라이든', '채팅', 'O', 213, 'Y', ''),
    ('QSPF', '메신저', 'SK 프라이든', '파일전송', 'O', 214, 'Y', ''),
    ('QSPM', '메신저', 'SK 프라이든', '쪽지', 'O', 215, 'Y', ''),
    ('QSPJ', '메신저', 'SK 프라이든', '참여', 'O', 216, 'Y', ''),
    ('QSPL', '메신저', 'SK 프라이든', '떠남', 'O', 217, 'Y', ''),
    ('QSBC', '메신저', 'SK 비즈', '채팅', 'O', 218, 'N', ''),
    ('QSBF', '메신저', 'SK 비즈', '파일전송', 'O', 219, 'N', ''),
    ('QSBM', '메신저', 'SK 비즈', '쪽지', 'O', 220, 'N', ''),
    ('QWJC', '메신저', '웅진', '채팅', 'O', 221, 'Y', ''),
    ('QWJF', '메신저', '웅진', '파일전송', 'O', 222, 'Y', ''),
    ('QWJM', '메신저', '웅진', '쪽지', 'O', 223, 'Y', ''),
    ('QGPC', '메신저', 'ChatGPT', '채팅', 'O', 224, 'Y', ''),
    ('QDAC', '메신저', 'Dall-E', '채팅', 'O', 225, 'Y', ''),
    ('QDAF', '메신저', 'Dall-E', '파일전송', 'O', 226, 'Y', ''),
    ('QCLC', '메신저', '쿨', '채팅', 'O', 227, 'Y', 'MSG'),
    ('QCLF', '메신저', '쿨', '파일전송', 'O', 228, 'Y', 'MSG'),
    ('QCLM', '메신저', '쿨', '쪽지', 'O', 229, 'Y', 'MSG'),
    ('QCLJ', '메신저', '쿨', '참여', 'O', 230, 'Y', 'MSG'),
    ('QCLL', '메신저', '쿨', '떠남', 'O', 231, 'Y', 'MSG'),
    ('QKBC', '메신저', 'k-bond', '채팅', 'O', 232, 'Y', 'MSG'),
    ('QKBF', '메신저', 'k-bond', '파일전송', 'O', 233, 'Y', 'MSG'),
    ('QKBM', '메신저', 'k-bond', '쪽지', 'O', 234, 'Y', 'MSG'),
    ('QKBJ', '메신저', 'k-bond', '참여', 'O', 235, 'Y', 'MSG'),
    ('QKBL', '메신저', 'k-bond', '떠남', 'O', 236, 'Y', 'MSG'),
    ('QEKC', '메신저', '아이콘', '채팅', 'O', 237, 'Y', 'MSG'),
    ('QEKF', '메신저', '아이콘', '파일전송', 'O', 238, 'Y', 'MSG'),
    ('QEKJ', '메신저', '아이콘', '참여', 'O', 239, 'Y', 'MSG'),
    ('QEKL', '메신저', '아이콘', '떠남', 'O', 240, 'Y', 'MSG'),
    ('QEKH', '메신저', '아이콘', '과거 데이터', 'O', 241, 'Y', 'MSG'),
    ('QSLC', '메신저', 'Slack', '채팅', 'O', 242, 'Y', 'MSG'),
    ('QSLF', '메신저', 'Slack', '파일전송', 'O', 243, 'Y', 'MSG'),
    ('QSLJ', '메신저', 'Slack', '참여', 'O', 244, 'Y', 'MSG'),
    ('QSLL', '메신저', 'Slack', '떠남', 'O', 245, 'Y', 'MSG'),
    ('QSYC', '메신저', '신영자산운용', '채팅', 'O', 246, 'Y', 'MSG'),
    ('QSYF', '메신저', '신영자산운용', '파일전송', 'O', 247, 'Y', 'MSG'),
    ('QSYM', '메신저', '신영자산운용', '쪽지', 'O', 248, 'Y', 'MSG'),
    ('QSYJ', '메신저', '신영자산운용', '참여', 'O', 249, 'Y', 'MSG'),
    ('QSYL', '메신저', '신영자산운용', '떠남', 'O', 250, 'Y', 'MSG'),
    ('QFBC', '메신저', '페이스북', '채팅', 'O', 251, 'Y', 'MSG'),
    ('QFBF', '메신저', '페이스북', '파일전송', 'O', 252, 'Y', 'MSG'),
    ('QKMC', '메신저', '삼성KnoxMessenger', '채팅', 'O', 253, 'Y', 'MSG'),
    ('QKMF', '메신저', '삼성KnoxMessenger', '파일전송', 'O', 254, 'Y', 'MSG'),
    ('QKMR', '메신저', '삼성KnoxMessenger', '파일수신', 'I', 255, 'Y', 'MSG'),
    ('QKMW', '메신저', '삼성KnoxMessenger', '전달', 'O', 256, 'Y', 'MSG'),
    ('QKMV', '메신저', '삼성KnoxMessenger', '파일-미리보기', 'O', 257, 'Y', 'MSG'),
    ('QGHC', '메신저', '구글 Hangout', '채팅', 'O', 258, 'Y', 'MSG'),
    ('QGHF', '메신저', '구글 Hangout', '파일전송', 'O', 259, 'Y', 'MSG'),
    ('QGGC', '메신저', '구글 chat', '채팅', 'O', 260, 'Y', 'MSG'),
    ('QGGF', '메신저', '구글 chat', '파일전송', 'O', 261, 'Y', 'MSG'),
    ('QGMC', '메신저', '구글 Meet', '채팅', 'O', 262, 'Y', 'MSG'),
    ('QGBC', '메신저', '구글 Bard', '채팅', 'O', 263, 'Y', 'MSG'),
    ('QBIC', '메신저', 'Microsoft BingAI Chat', '채팅', 'O', 264, 'Y', 'MSG'),
    ('QWTC', '메신저', 'Wrtn', '채팅', 'O', 265, 'Y', ''),
    ('QISC', '메신저', '인스타그램 DM', '채팅', 'O', 266, 'Y', 'MSG'),
    ('QISF', '메신저', '인스타그램 DM', '파일전송', 'O', 267, 'Y', 'MSG'),
    ('QZAC', '메신저', 'Zalo', '채팅', 'O', 268, 'Y', 'MSG'),
    ('QZAF', '메신저', 'Zalo', '파일전송', 'O', 269, 'Y', 'MSG'),
    ('QNBC', '메신저', '네이버 밴드 채팅', '채팅', 'O', 270, 'Y', 'MSG'),
    ('QNBF', '메신저', '네이버 밴드 채팅', '파일전송', 'O', 271, 'Y', 'MSG'),
    ('QUKC', '메신저', '기타', '채팅', 'O', 272, 'Y', 'MSG'),
    ('QUKF', '메신저', '기타', '파일전송', 'O', 273, 'Y', 'MSG'),
    ('QUKM', '메신저', '기타', '쪽지', 'O', 274, 'Y', 'MSG'),
    ('QUKJ', '메신저', '기타', '참여', 'O', 275, 'Y', 'MSG'),
    ('QUKL', '메신저', '기타', '떠남', 'O', 276, 'Y', 'MSG'),
    ('FFTC', '파일전송', 'FTP', 'CMD', 'O', 277, 'Y', ''),
    ('FFTG', '파일전송', 'FTP', 'GET', 'I', 278, 'Y', ''),
    ('FFTP', '파일전송', 'FTP', 'PUT', 'O', 279, 'Y', ''),
    ('FFTL', '파일전송', 'FTP', 'CONNECT', 'O', 280, 'Y', ''),
    ('FZM-', '파일전송', 'Zmodem', '-', 'O', 281, 'Y', ''),
    ('FNVR', '파일전송', '네이버 MYBOX', '수신', 'I', 282, 'Y', ''),
    ('FNVS', '파일전송', '네이버 MYBOX', '발신', 'O', 283, 'Y', ''),
    ('FGGR', '파일전송', '구글 드라이브', '수신', 'I', 284, 'Y', ''),
    ('FGGS', '파일전송', '구글 드라이브', '발신', 'O', 285, 'Y', ''),
    ('FODR', '파일전송', 'OneDrive', '수신', 'I', 286, 'Y', ''),
    ('FODS', '파일전송', 'OneDrive', '발신', 'O', 287, 'Y', ''),
    ('FDBR', '파일전송', 'Dropbox', '수신', 'I', 288, 'Y', ''),
    ('FDBS', '파일전송', 'Dropbox', '발신', 'O', 289, 'Y', ''),
    ('F2NR', '파일전송', '2nd 드라이브', '수신', 'I', 290, 'N', ''),
    ('F2NS', '파일전송', '2nd 드라이브', '발신', 'O', 291, 'N', ''),
    ('FPSR', '파일전송', 'Polarisoffice ', '수신', 'I', 292, 'Y', ''),
    ('FPSS', '파일전송', 'Polarisoffice ', '발신', 'O', 293, 'Y', ''),
    ('FICR', '파일전송', 'Icloud', '수신', 'I', 294, 'Y', ''),
    ('FICS', '파일전송', 'Icloud', '발신', 'O', 295, 'Y', ''),
    ('FYDR', '파일전송', 'Yandex', '수신', 'I', 296, 'Y', ''),
    ('FYDS', '파일전송', 'Yandex', '발신', 'O', 297, 'Y', ''),
    ('FWHR', '파일전송', 'LG 웹하드', '수신', 'I', 298, 'Y', ''),
    ('FWHS', '파일전송', 'LG 웹하드', '발신', 'O', 299, 'Y', ''),
    ('FGIR', '파일전송', 'GitHub', '수신', 'I', 300, 'Y', ''),
    ('FGIS', '파일전송', 'GitHub', '발신', 'O', 301, 'Y', ''),
    ('FDOR', '파일전송', 'Dooray', '수신', 'I', 302, 'Y', ''),
    ('FDOS', '파일전송', 'Dooray', '발신', 'O', 303, 'Y', ''),
    ('FWES', '파일전송', 'Wetransfer', '발신', 'O', 304, 'Y', ''),
    ('FUKR', '파일전송', '기타', '수신', 'I', 305, 'Y', ''),
    ('FUKS', '파일전송', '기타', '발신', 'O', 306, 'Y', ''),
    ('NENR', '노트', 'EVERNOTE', '수신', 'I', 307, 'Y', ''),
    ('NENS', '노트', 'EVERNOTE', '발신', 'O', 308, 'Y', ''),
    ('NONR', '노트', 'ONENOTE', '수신', 'I', 309, 'Y', ''),
    ('NONS', '노트', 'ONENOTE', '발신', 'O', 310, 'Y', ''),
    ('NLVS', '노트', 'Outlook.com 메모', '발신', 'O', 311, 'Y', ''),
    ('NBTS', '노트', 'BIT.AI', '발신', 'O', 312, 'Y', ''),
    ('NNOS', '노트', 'Notion', '발신', 'O', 313, 'Y', ''),
    ('NGGS', '노트', '구글 docs', '발신', 'O', 314, 'Y', ''),
    ('NGTS', '노트', '구글 tasks', '발신', 'O', 315, 'Y', ''),
    ('NGKS', '노트', '구글 keep', '발신', 'O', 316, 'Y', ''),
    ('NSSR', '노트', '삼성 노트', '수신', 'I', 317, 'Y', ''),
    ('NSSS', '노트', '삼성 노트', '발신', 'O', 318, 'Y', ''),
    ('NNVS', '노트', '네이버 오피스', '발신', 'O', 319, 'Y', ''),
    ('NDBS', '노트', 'Dropbox paper', '발신', 'O', 320, 'Y', ''),
    ('NHCS', '노트', '한컴 오피스', '발신', 'O', 321, 'Y', ''),
    ('NMOS', '노트', 'MS오피스', '발신', 'O', 322, 'Y', ''),
    ('NCDS', '노트', 'Coda', '발신', 'O', 323, 'Y', ''),
    ('NNMR', '노트', '네이버 메모', '수신', 'I', 324, 'Y', ''),
    ('NNMS', '노트', '네이버 메모', '발신', 'O', 325, 'Y', ''),
    ('NCNS', '노트', 'Clova Note', '발신', 'O', 326, 'Y', ''),
    ('NGIS', '노트', 'Github Gist', '발신', 'O', 327, 'Y', ''),
    ('NSNS', '노트', 'SimpleNote', '발신', 'O', 328, 'Y', ''),
    ('NAGS', '노트', 'Agit', '발신', 'O', 329, 'Y', ''),
    ('NUKS', '노트', '기타', '발신', 'O', 330, 'Y', ''),
    ('AGCR', '일정', '구글캘린더일정', '수신', 'I', 331, 'N', ''),
    ('AGCS', '일정', '구글캘린더일정', '발신', 'O', 332, 'Y', ''),
    ('AGLR', '일정', '구글캘린더메일', '수신', 'I', 333, 'N', ''),
    ('AGLS', '일정', '구글캘린더메일', '발신', 'O', 334, 'Y', ''),
    ('ANCS', '일정', '네이버 캘린더', '발신', 'O', 335, 'Y', ''),
    ('ZTN-', '기타 서비스', 'Telnet', '-', 'O', 336, 'Y', ''),
    ('ZXT-', '기타 서비스', 'Xterm', '-', 'O', 337, 'Y', ''),
    ('ZRL-', '기타 서비스', 'R-Login', '-', 'O', 338, 'Y', ''),
    ('ZNP-', '기타 서비스', 'NNTP', '-', 'O', 339, 'Y', ''),
    ('ZPC-', '기타 서비스', 'PC 보안', '-', 'O', 340, 'N', ''),
    ('ZSH-', '기타 서비스', 'SSH', 'SSH 세션 정보', 'O', 341, 'Y', ''),
    ('XX1R', '모니터링_제외', '미분류_타입1', '수신', 'I', 342, 'Y', ''),
    ('XX1S', '모니터링_제외', '미분류_타입1', '발신', 'O', 343, 'Y', ''),
    ('XX2R', '모니터링_제외', '미분류_타입2', '수신', 'I', 344, 'Y', ''),
    ('XX2S', '모니터링_제외', '미분류_타입2', '발신', 'O', 345, 'Y', ''),
    ('XX3R', '모니터링_제외', '미분류_타입3', '수신', 'I', 346, 'Y', ''),
    ('XX3S', '모니터링_제외', '미분류_타입3', '발신', 'O', 347, 'Y', ''),
    ('XU1R', '모니터링_제외', '웹서비스(미분류)_타입1', '수신', 'I', 348, 'Y', ''),
    ('XU1S', '모니터링_제외', '웹서비스(미분류)_타입1', '발신', 'O', 349, 'Y', ''),
    ('XU2R', '모니터링_제외', '웹서비스(미분류)_타입2', '수신', 'I', 350, 'Y', ''),
    ('XU2S', '모니터링_제외', '웹서비스(미분류)_타입2', '발신', 'O', 351, 'Y', ''),
    ('XU3R', '모니터링_제외', '웹서비스(미분류)_타입3', '수신', 'I', 352, 'Y', ''),
    ('XU3S', '모니터링_제외', '웹서비스(미분류)_타입3', '발신', 'O', 353, 'Y', ''),
    ('UWSD', '웹서비스(미분류)', '웹 발신', '첨부 - 문서타입', 'O', 354, 'Y', ''),
    ('UWSE', '웹서비스(미분류)', '웹 발신', '첨부 - 문서아님', 'O', 355, 'Y', ''),
    ('UWSU', '웹서비스(미분류)', '웹 발신', '첨부 없음', 'O', 356, 'Y', ''),
    ('UWSH', '웹서비스(미분류)', '웹 발신', '중요도(상)', 'O', 357, 'Y', ''),
    ('UWSM', '웹서비스(미분류)', '웹 발신', '중요도(중)', 'O', 358, 'Y', ''),
    ('UWSL', '웹서비스(미분류)', '웹 발신', '중요도(하)', 'O', 359, 'Y', ''),
    ('UX1R', '웹서비스(미분류)', '미분류_타입1', '수신', 'I', 360, 'Y', ''),
    ('UX1S', '웹서비스(미분류)', '미분류_타입1', '발신', 'O', 361, 'Y', ''),
    ('UX2R', '웹서비스(미분류)', '미분류_타입2', '수신', 'I', 362, 'Y', ''),
    ('UX2S', '웹서비스(미분류)', '미분류_타입2', '발신', 'O', 363, 'Y', ''),
    ('UX3R', '웹서비스(미분류)', '미분류_타입3', '수신', 'I', 364, 'Y', ''),
    ('UX3S', '웹서비스(미분류)', '미분류_타입3', '발신', 'O', 365, 'Y', ''),
    ('UWRD', '웹서비스(미분류)', '웹 수신', '첨부 - 문서타입', 'I', 366, 'Y', ''),
    ('UWRE', '웹서비스(미분류)', '웹 수신', '첨부 - 문서아님', 'I', 367, 'Y', ''),
    ('UWRU', '웹서비스(미분류)', '웹 수신', '첨부 없음', 'I', 368, 'Y', ''),
    ('BWSD', '웹서비스(업무)', '업무 발신', '첨부 - 문서타입', 'O', 369, 'Y', ''),
    ('BWSE', '웹서비스(업무)', '업무 발신', '첨부 - 문서아님', 'O', 370, 'Y', ''),
    ('BWSU', '웹서비스(업무)', '업무 발신', '첨부 없음', 'O', 371, 'Y', ''),
    ('BWRD', '웹서비스(업무)', '업무 수신', '첨부 - 문서타입', 'I', 372, 'Y', ''),
    ('BWRE', '웹서비스(업무)', '업무 수신', '첨부 - 문서아님', 'I', 373, 'Y', ''),
    ('BWRU', '웹서비스(업무)', '업무 수신', '첨부 없음', 'I', 374, 'Y', ''),
    ('TWEC', '화상회의', 'Webex', '채팅', 'O', 375, 'Y', 'MSG'),
    ('TWEF', '화상회의', 'Webex', '파일전송', 'O', 376, 'Y', 'MSG'),
    ('TWEJ', '화상회의', 'Webex', '참여', 'O', 377, 'Y', 'MSG'),
    ('TWEL', '화상회의', 'Webex', '떠남', 'O', 378, 'Y', 'MSG'),
    ('TZOC', '화상회의', 'Zoom', '채팅', 'O', 379, 'Y', 'MSG'),
    ('TZOF', '화상회의', 'Zoom', '파일전송', 'O', 380, 'Y', 'MSG'),
    ('TZOJ', '화상회의', 'Zoom', '참여', 'O', 381, 'Y', 'MSG'),
    ('TZOL', '화상회의', 'Zoom', '떠남', 'O', 382, 'Y', 'MSG'),
    ('TTMC', '화상회의', 'Teams', '채팅', 'O', 383, 'Y', 'MSG'),
    ('TTMF', '화상회의', 'Teams', '파일전송', 'O', 384, 'Y', 'MSG'),
    ('TTMJ', '화상회의', 'Teams', '참여', 'O', 385, 'Y', 'MSG'),
    ('TTML', '화상회의', 'Teams', '떠남', 'O', 386, 'Y', 'MSG'),
    ('TSKC', '화상회의', 'Skype', '채팅', 'O', 387, 'Y', 'MSG'),
    ('TSKF', '화상회의', 'Skype', '파일전송', 'O', 388, 'Y', 'MSG'),
    ('TSKJ', '화상회의', 'Skype', '참여', 'O', 389, 'Y', 'MSG'),
    ('TSKL', '화상회의', 'Skype', '떠남', 'O', 390, 'Y', 'MSG'),
    ('TJMC', '화상회의', 'JoinME', '채팅', 'O', 391, 'Y', 'MSG'),
    ('TJMF', '화상회의', 'JoinME', '파일전송', 'O', 392, 'Y', 'MSG'),
    ('TAMC', '화상회의', 'Amazon Chime', '채팅', 'O', 393, 'Y', 'MSG'),
    ('TAMF', '화상회의', 'Amazon Chime', '파일전송', 'O', 394, 'Y', 'MSG'),
    ('TBJC', '화상회의', 'BlueJeans', '채팅', 'O', 395, 'Y', 'MSG'),
    ('TTDS', '화상회의', 'tl;dv', '채팅', 'O', 396, 'Y', 'MSG'),
    ('LNVS', '번역기', '파파고 번역', '발신', 'O', 397, 'Y', ''),
    ('LGGS', '번역기', '구글 번역', '발신', 'O', 398, 'Y', ''),
    ('LGPS', '번역기', '구글 번역 플러그인', '발신', 'O', 399, 'Y', ''),
    ('LDES', '번역기', 'Deepl', '발신', 'O', 400, 'Y', ''),
    ('LBIS', '번역기', 'Bing 번역', '발신', 'O', 401, 'Y', ''),
    ('LYMS', '번역기', 'Yandex 번역', '발신', 'O', 402, 'Y', ''),
    ('LUKS', '번역기', '기타', '발신', 'I', 403, 'Y', ''),
    ('IGBS', '생성형 AI', '구글 Gemini', '발신', 'O', 404, 'Y', ''),
    ('IBIS', '생성형 AI', 'Microsoft Copilot', '발신', 'O', 405, 'Y', ''),
    ('IWTS', '생성형 AI', 'Wrtn', '발신', 'O', 406, 'Y', ''),
    ('IGPS', '생성형 AI', 'ChatGPT', '발신', 'O', 407, 'Y', ''),
    ('IDAS', '생성형 AI', 'Dall-E', '발신', 'O', 408, 'Y', ''),
    ('IGCS', '생성형 AI', 'Github Copilot', '발신', 'I', 409, 'Y', ''),
    ('IYCS', '생성형 AI', 'YouChat', '발신', 'I', 410, 'Y', ''),
    ('ICSS', '생성형 AI', 'Chatsonic', '발신', 'I', 411, 'Y', ''),
    ('IRPS', '생성형 AI', 'Replika', '발신', 'I', 412, 'Y', ''),
    ('IPPS', '생성형 AI', 'Perplexity', '발신', 'I', 413, 'Y', ''),
    ('ITCS', '생성형 AI', 'TextCortex', '발신', 'I', 414, 'Y', ''),
    ('IPHS', '생성형 AI', 'Phind', '발신', 'I', 415, 'Y', ''),
    ('IPOS', '생성형 AI', 'Poe', '발신', 'I', 416, 'Y', ''),
    ('IHFS', '생성형 AI', 'Hugging Face', '발신', 'I', 417, 'Y', ''),
    ('ICPS', '생성형 AI', 'Copy.AI', '발신', 'I', 418, 'Y', ''),
    ('IHWS', '생성형 AI', 'HyperWrite', '발신', 'I', 419, 'Y', ''),
    ('IDPS', '생성형 AI', 'DeepAI', '발신', 'I', 420, 'Y', ''),
    ('IACS', '생성형 AI', 'AskCodi', '발신', 'I', 421, 'Y', ''),
    ('INAS', '생성형 AI', 'Native', '발신', 'I', 422, 'Y', ''),
    ('INFS', '생성형 AI', 'NeuroFlash', '발신', 'I', 423, 'Y', ''),
    ('INOS', '생성형 AI', 'Notion AI', '발신', 'I', 424, 'Y', ''),
    ('IMES', '생성형 AI', 'Merlin', '발신', 'I', 425, 'Y', ''),
    ('ICXS', '생성형 AI', 'CLOVA-X', '발신', 'I', 426, 'Y', ''),
    ('IADS', '생성형 AI', 'Adobe AI', '발신', 'I', 427, 'Y', ''),
    ('ICDS', '생성형 AI', 'ClipDrop', '발신', 'I', 428, 'Y', ''),
    ('ISBS', '생성형 AI', 'Stability.Ai', '발신', 'I', 429, 'Y', ''),
    ('IRMS', '생성형 AI', 'Runwayml', '발신', 'I', 430, 'Y', ''),
    ('IGVS', '생성형 AI', 'Google Vertex', '발신', 'I', 431, 'Y', ''),
    ('IGLS', '생성형 AI', 'Google Colab', '발신', 'I', 432, 'Y', ''),
    ('ICWS', '생성형 AI', 'CodeWhisperer', '발신', 'I', 433, 'Y', ''),
    ('IMSS', '생성형 AI', 'MakerSuite', '발신', 'I', 434, 'Y', ''),
    ('IOCS', '생성형 AI', 'Clova OCR', '발신', 'I', 435, 'Y', ''),
    ('IAOS', '생성형 AI', 'Azure OpenAI', '발신', 'I', 436, 'Y', ''),
    ('ICUS', '생성형 AI', '네이버 CUE:', '발신', 'I', 437, 'Y', ''),
    ('IMJS', '생성형 AI', 'Midjourney', '발신', 'I', 438, 'Y', ''),
    ('ISGR', '생성형 AI', 'slidesGPT', '수신', 'I', 439, 'Y', ''),
    ('ISGS', '생성형 AI', 'slidesGPT', '발신', 'I', 440, 'Y', ''),
    ('IDMS', '생성형 AI', 'AiDocmaker', '발신', 'I', 441, 'Y', ''),
    ('IRKS', '생성형 AI', 'Reka AI', '발신', 'I', 442, 'Y', ''),
    ('ICLS', '생성형 AI', 'Claude', '발신', 'I', 443, 'Y', ''),
    ('IDMR', '생성형 AI', 'Ai Docker Attach', '수신', 'I', 444, 'Y', ''),
    ('IADR', '생성형 AI', 'Adobe firefly login', '수신', 'I', 445, 'Y', ''),
    ('IWDS', '생성형 AI', 'Dream by WOMBO', '수신', 'I', 446, 'Y', ''),
    ('IGAS', '생성형 AI', 'GetImg.AI', '수신', 'I', 447, 'Y', ''),
    ('IUKS', '생성형 AI', '기타', '발신', 'I', 448, 'Y', ''),
    ('PDOS', '프로젝트', 'Dooray', '발신', 'O', 449, 'Y', ''),
    ('PGIS', '프로젝트', 'Github', '발신', 'O', 450, 'Y', ''),
    ('PGLS', '프로젝트', 'Glassdoor', '발신', 'O', 451, 'Y', ''),
    ('EBDR', '그룹웨어', '게시', '수신', 'I', 452, 'Y', ''),
    ('EBD-', '그룹웨어', '게시', '발신', 'O', 453, 'Y', ''),
    ('EBBR', '그룹웨어', '게시판', '수신', 'I', 454, 'Y', ''),
    ('EBBS', '그룹웨어', '게시판', '발신', 'O', 455, 'Y', ''),
    ('EBBF', '그룹웨어', '게시판', '파일수신', 'I', 456, 'Y', ''),
    ('EAAR', '그룹웨어', '결재', '수신', 'I', 457, 'Y', ''),
    ('EAAS', '그룹웨어', '결재', '발신', 'O', 458, 'Y', ''),
    ('EAAG', '그룹웨어', '결재', '통보 - 수신', 'I', 459, 'Y', ''),
    ('EAAP', '그룹웨어', '결재', '통보 - 발신', 'O', 460, 'Y', ''),
    ('EAAF', '그룹웨어', '결재', '파일수신', 'I', 461, 'Y', ''),
    ('EMMR', '그룹웨어', '메일', '그룹웨어 수신', 'I', 462, 'Y', ''),
    ('EMMS', '그룹웨어', '메일', '그룹웨어 발신', 'O', 463, 'Y', ''),
    ('EMMG', '그룹웨어', '메일', 'OWA 수신', 'I', 464, 'Y', ''),
    ('EMMP', '그룹웨어', '메일', 'OWA 발신', 'O', 465, 'Y', ''),
    ('EMMD', '그룹웨어', '메일', 'RPC 수신', 'I', 466, 'Y', ''),
    ('EMMU', '그룹웨어', '메일', 'RPC 발신', 'O', 467, 'Y', ''),
    ('EMMC', '그룹웨어', '메일', '수신', 'I', 468, 'Y', ''),
    ('EMML', '그룹웨어', '메일', '발신', 'O', 469, 'Y', ''),
    ('EMM1', '그룹웨어', '메일', '보안등급1', 'O', 470, 'Y', ''),
    ('EMM2', '그룹웨어', '메일', '보안등급2', 'O', 471, 'Y', ''),
    ('EMM3', '그룹웨어', '메일', '보안등급3', 'O', 472, 'Y', ''),
    ('EMM4', '그룹웨어', '메일', '보안등급4', 'O', 473, 'Y', ''),
    ('EMMA', '그룹웨어', '메일', '임시(자동)', 'O', 474, 'Y', ''),
    ('EMMT', '그룹웨어', '메일', '임시(수동)', 'O', 475, 'Y', ''),
    ('EMMK', '그룹웨어', '메일', 'Outlook - 수신', 'I', 476, 'Y', ''),
    ('EMMO', '그룹웨어', '메일', 'Outlook - 발신', 'O', 477, 'Y', ''),
    ('EMMB', '그룹웨어', '메일', '그룹웨어 예약메일', 'O', 478, 'Y', ''),
    ('EMBR', '그룹웨어', '모바일', '수신', 'I', 479, 'Y', ''),
    ('EMB-', '그룹웨어', '모바일', '발신', 'O', 480, 'Y', ''),
    ('EWSR', '그룹웨어', '웹서비스', '수신', 'I', 481, 'Y', ''),
    ('EWS-', '그룹웨어', '웹서비스', '발신', 'O', 482, 'Y', ''),
    ('EPUR', '그룹웨어', '일반', '수신', 'I', 483, 'Y', ''),
    ('EPU-', '그룹웨어', '일반', '발신', 'O', 484, 'Y', ''),
    ('ESCR', '그룹웨어', '일정 명함', '수신', 'I', 485, 'Y', ''),
    ('ESC-', '그룹웨어', '일정 명함', '발신', 'O', 486, 'Y', ''),
    ('EMF-', '그룹웨어', '파일 다운로드', '-', 'I', 487, 'Y', ''),
    ('EMU-', '그룹웨어', '기타', '', 'O', 488, 'Y', ''),
    ('EMDR', '그룹웨어', '드라이브', '수신', 'I', 489, 'Y', ''),
    ('EMDS', '그룹웨어', '드라이브', '발신', 'O', 490, 'Y', ''),
    ('ECIS', '그룹웨어', 'Samsung cic', '발신', 'O', 491, 'Y', ''),
    ('DCCS', '편집기', 'Clip Champ', '발신', 'O', 492, 'Y', ''),
    ('DFGS', '편집기', 'Figma', '발신', 'O', 493, 'Y', '');

UPDATE UI_SERVICE
SET SERVICENM_LV2 = 'Microsoft Copilot'
WHERE SERVICECD = 'IBIS';


/* UI MENU */
DELETE FROM UI_MENU;
INSERT INTO UI_MENU (`MENU_ID`, `MENU_DEFAULT_NAME`, `P_MENU_ID`, `PKG_TYPE`, `MENU_AUTH`, `MENU_LINK`, `MENU_ICON`, `MENU_ORDER`, `MENU_USEYN`, `MENU_IMG_PATH`)  VALUES
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
('STAT_KEYWORDHOST','핵심 기술 키워드 탐지 HOST TOP','STAT_CONTENT','L','S','ems/keywordHost.do','fa fa-pie-chart',14,'Y',NULL),
('STAT_KEYWORDNEW','핵심 기술 키워드 탐지 NEW HOST','STAT_CONTENT','L','S','ems/keywordNew.do','fa fa-pie-chart',15,'Y',NULL),
('ADMIN_MGMT','운용자 관리','OPERATION_MGMT','L','S','commons/admin.do','fa fa-unlock-alt',4,'Y',NULL);


DELETE FROM UI_CUSTOM_DASHBOARD_POSITION_DEFAULT;
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (1,0,0,3,2,3,2,4,2);
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (2,3,0,3,2,3,2,4,2);
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (3,6,0,3,2,3,2,4,2);
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (4,0,4,8,4,5,4,10,5);
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (5,8,4,4,4,4,4,6,6);
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (6,3,2,3,2,2,2,3,2);
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (7,9,0,3,2,3,2,4,2);
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (8,6,2,3,2,3,2,4,2);
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (9,9,2,3,2,3,2,4,2);
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(POSITION_SEQ,DASH_X,DASH_Y,DASH_WIDTH,DASH_HEIGHT,DASH_MIN_WIDTH,DASH_MIN_HEIGHT,DASH_MAX_WIDTH,DASH_MAX_HEIGHT) VALUES (10,0,2,3,2,2,2,3,2);




INSERT INTO UI_CUSTOM_DASHBOARD(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,ADMIN_ID,USEYN)
SELECT @ROWNUM:=@ROWNUM+1 AS DASH_KEY, C.DASH_NAME,C.DASH_TYPE,C.DASH_MULTI_X,C.DASH_MULTI_Y,C.DASH_CHART,C.DASH_CHART_X,C.DASH_CHART_Y,C.DASH_ICON,
C.DASH_COLOR,C.DASH_HTML,C.DASH_CONDITION,C.DASH_COMMENT,C.ADMIN_ID,C.USEYN
FROM (
SELECT A.DASH_NAME,A.DASH_TYPE,A.DASH_MULTI_X,A.DASH_MULTI_Y,A.DASH_CHART,A.DASH_CHART_X,A.DASH_CHART_Y,A.DASH_ICON,
A.DASH_COLOR,A.DASH_HTML,A.DASH_CONDITION,A.DASH_COMMENT,B.ADMIN_ID,A.USEYN
FROM UI_CUSTOM_DASHBOARD_DEFAULT A, UI_ADMIN B
ORDER BY B.ADMIN_ID
) C, (SELECT @ROWNUM:=0) D
WHERE (SELECT COUNT(*) FROM UI_CUSTOM_DASHBOARD )=0;

CREATE TABLE IF NOT EXISTS UI_DOWNLOAD_BATCH_MESSENGER(
    DOWN_SEQ  INT(11)  NOT NULL  AUTO_INCREMENT  COMMENT '다운로드 일련번호',
    DOWN_VAL  LONGTEXT  NULL    COMMENT '검색조건 값',
    ADMIN_ID  VARCHAR(50)  NOT NULL    COMMENT '운용자 ID',
    REQ_DT  DATETIME  NULL    COMMENT '요청일',
    END_DT  DATETIME  NULL    COMMENT '유효기간',
    DOWN_STATUS  INT(11)  NULL  DEFAULT '0'  COMMENT '진행상태',
    STATUS_STR  CHAR(1)  NULL    COMMENT '상태값(S:시작,I:진행중,Y:파일생성완료,X:삭제됨,E:오류)',
    DOWNFILE_PATH  VARCHAR(500)  NULL    COMMENT '다운로드 파일 경로',
    DOWNFILE_SIZE  BIGINT UNSIGNED  NULL    COMMENT '다운로드 파일 크기',
    PRIMARY KEY (DOWN_SEQ)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='다운로드 배치';

