USE EMASSAI;


CREATE TABLE IF NOT EXISTS UI_MAIL_NOLOG(
    MAIL_LOG_SEQ  INT(11)  NOT NULL    COMMENT 'MAIL 미로깅 일련번호',
    MAIL  VARCHAR(128)  NOT NULL    COMMENT 'MAIL',
    CREATE_USER varchar(30) DEFAULT NULL COMMENT '작성자',
    CREATE_DT  DATETIME  NULL    COMMENT '작성일',
    USE_YN  CHAR(1)  NOT NULL  DEFAULT 'Y'  COMMENT '사용 여부(Y:사용, N:사용안함(삭제) )',
    PRIMARY KEY (MAIL_LOG_SEQ)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='MAIL 미로깅';

CREATE TABLE IF NOT EXISTS EMS_HOST(
     HOST varchar(256) NOT NULL COMMENT '호스트 정보',
    SCHEME varchar(12) NULL COMMENT 'SCHEME 정보',
    PORT INT(12) NULL COMMENT 'SCHEME 정보',
    CATEGORY_CD INT(2) NULL COMMENT '카테고리 코드',
    NATION_CD varchar(2) NULL COMMENT '국가 코드',
    DESCRIPTION TEXT NULL COMMENT '호스트 설명',
    PROCESS_YN varchar(1) DEFAULT 'N' NULL COMMENT '카테고리 탐지 여부',
    CREATE_DT datetime null comment '등록일',
    `TYPE` varchar(1) default 'D' null COMMENT 'D:기본제공, C:고객사',
    PRIMARY KEY (HOST)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='미분류 HOST';


CREATE TABLE IF NOT EXISTS EMS_HOST_CATEGORY(
                                                CATEGORY_CD int(2) NOT NULL COMMENT 'HOST 카테고리 코드',
    CATEGORY_NM varchar(120) NULL comment 'HOST 카테고리 명',
    PRIMARY KEY (CATEGORY_CD)  )  ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='미분류 카테고리 분류';

CREATE TABLE IF NOT EXISTS EMS_NATION(
                                         NATION_CD varchar(2) NOT NULL COMMENT '국가 코드',
    NATION_ENG varchar(120) NULL comment '국가명 (영어)',
    NATION_KOR varchar(120) NULL comment '국가명 (한글)',
    PRIMARY KEY (NATION_CD)  )  ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='미분류 국가 코드';

-- CREATE TABLE IF NOT EXISTS HOST_INFO (
--     host VARCHAR(255) NOT NULL COMMENT 'host 이름',
--     description TEXT  NULL COMMENT 'host 설명',
--     PRIMARY KEY (host)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='미분류 host 설명';
--
-- CREATE TABLE IF NOT EXISTS HOST_CATEGORY (
--     host VARCHAR(255) NOT NULL COMMENT 'host 이름',
--     description TEXT  NULL COMMENT 'host 설명',
--     PRIMARY KEY (host)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='미분류 host 설명';



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
SELECT 'query.type.dept', 'A', 'A', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='query.type.dept');

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

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'llm.Vietnam', 'false', 'false', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='llm.Vietnam');

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'dashboard.period', 'T', 'T', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='dashboard.period');


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
INSERT IGNORE INTO UI_SERVICE (`SERVICECD`, `SERVICENM_LV1`, `SERVICENM_LV2`, `SERVICENM_LV3`, `IN_OUT`, `SORT`, `USE_YN`, `MSGGRPCD`)
VALUES ('MP3-', '메일', 'POP3', '-', 'I', 1, 'Y', ''),
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
       ('WUKR', '웹메일', '기타', '수신', 'I', 81, 'Y', ''),
       ('WUKS', '웹메일', '기타', '발신', 'O', 82, 'Y', ''),
       ('CNVR', '커뮤니티', '네이버 카페', '수신', 'I', 83, 'Y', ''),
       ('CNVS', '커뮤니티', '네이버 카페', '발신', 'O', 84, 'Y', ''),
       ('CNVD', '커뮤니티', '네이버 카페', '댓글', 'O', 85, 'Y', ''),
       ('CNVT', '커뮤니티', '네이버 카페', '임시저장', 'O', 86, 'Y', ''),
       ('CDUR', '커뮤니티', '다음 카페', '수신', 'I', 87, 'Y', ''),
       ('CDUS', '커뮤니티', '다음 카페', '발신', 'O', 88, 'Y', ''),
       ('CDUD', '커뮤니티', '다음 카페', '댓글', 'O', 89, 'Y', ''),
       ('CDUT', '커뮤니티', '다음 카페', '임시저장', 'O', 90, 'Y', ''),
       ('CPPR', '커뮤니티', '뽐뿌 커뮤니케이션', '수신', 'I', 91, 'Y', ''),
       ('CPPS', '커뮤니티', '뽐뿌 커뮤니케이션', '발신', 'O', 92, 'Y', ''),
       ('CPPD', '커뮤니티', '뽐뿌 커뮤니케이션', '댓글', 'O', 93, 'Y', ''),
       ('CCIR', '커뮤니티', '클리앙', '수신', 'I', 94, 'Y', ''),
       ('CCIS', '커뮤니티', '클리앙', '발신', 'O', 95, 'Y', ''),
       ('CCID', '커뮤니티', '클리앙', '댓글', 'O', 96, 'Y', ''),
       ('CDCR', '커뮤니티', '디시인사이드', '수신', 'I', 97, 'Y', ''),
       ('CDCS', '커뮤니티', '디시인사이드', '발신', 'O', 98, 'Y', ''),
       ('CDCD', '커뮤니티', '디시인사이드', '댓글', 'O', 99, 'Y', ''),
       ('CRWR', '커뮤니티', '루리웹', '수신', 'I', 100, 'Y', ''),
       ('CRWS', '커뮤니티', '루리웹', '발신', 'O', 101, 'Y', ''),
       ('CRWD', '커뮤니티', '루리웹', '댓글', 'O', 102, 'Y', ''),
       ('CMLR', '커뮤니티', 'Menlosecurity', '수신', 'I', 103, 'Y', ''),
       ('CMLS', '커뮤니티', 'Menlosecurity', '발신', 'O', 104, 'Y', ''),
       ('CMLD', '커뮤니티', 'Menlosecurity', '댓글', 'O', 105, 'Y', ''),
       ('CMLE', '커뮤니티', 'Menlosecurity', '기타', 'O', 106, 'Y', ''),
       ('CBDS', '커뮤니티', '블라인드', '발신', 'O', 107, 'Y', ''),
       ('CUKR', '커뮤니티', '기타', '수신', 'I', 108, 'Y', ''),
       ('CUKS', '커뮤니티', '기타', '발신', 'O', 109, 'Y', ''),
       ('CUKD', '커뮤니티', '기타', '댓글', 'O', 110, 'Y', ''),
       ('SFBR', '소셜', '페이스북', '수신', 'I', 111, 'Y', ''),
       ('SFBS', '소셜', '페이스북', '발신', 'O', 112, 'Y', ''),
       ('SFBD', '소셜', '페이스북', '댓글', 'O', 113, 'Y', ''),
       ('STWR', '소셜', '트위터', '수신', 'I', 114, 'Y', ''),
       ('STWS', '소셜', '트위터', '발신', 'O', 115, 'Y', ''),
       ('STWD', '소셜', '트위터', '댓글', 'O', 116, 'Y', ''),
       ('SKAR', '소셜', '카카오스토리', '수신', 'I', 117, 'Y', ''),
       ('SKAS', '소셜', '카카오스토리', '발신', 'O', 118, 'Y', ''),
       ('SKAD', '소셜', '카카오스토리', '댓글', 'O', 119, 'Y', ''),
       ('SNVR', '소셜', '네이버 블로그', '수신', 'I', 120, 'Y', ''),
       ('SNVS', '소셜', '네이버 블로그', '발신', 'O', 121, 'Y', ''),
       ('SNVD', '소셜', '네이버 블로그', '댓글', 'O', 122, 'Y', ''),
       ('SNVT', '소셜', '네이버 블로그', '임시저장', 'O', 123, 'Y', ''),
       ('SNVU', '소셜', '네이버 블로그', '수정', 'O', 124, 'Y', ''),
       ('SDUR', '소셜', '다음 블로그', '수신', 'I', 125, 'Y', ''),
       ('SDUS', '소셜', '다음 블로그', '발신', 'O', 126, 'Y', ''),
       ('SDUD', '소셜', '다음 블로그', '댓글', 'O', 127, 'Y', ''),
       ('STSR', '소셜', '티스토리', '수신', 'I', 128, 'Y', ''),
       ('STSS', '소셜', '티스토리', '발신', 'O', 129, 'Y', ''),
       ('STSD', '소셜', '티스토리', '댓글', 'O', 130, 'Y', ''),
       ('STST', '소셜', '티스토리', '임시저장', 'O', 131, 'Y', ''),
       ('STBR', '소셜', '텀블러', '수신', 'I', 132, 'Y', ''),
       ('STBS', '소셜', '텀블러', '발신', 'O', 133, 'Y', ''),
       ('STBD', '소셜', '텀블러', '댓글', 'O', 134, 'Y', ''),
       ('SWBR', '소셜', '웨이보', '수신', 'I', 135, 'Y', ''),
       ('SWBS', '소셜', '웨이보', '발신', 'O', 136, 'Y', ''),
       ('SWBD', '소셜', '웨이보', '댓글', 'O', 137, 'Y', ''),
       ('SLKR', '소셜', '링크드인', '수신', 'I', 138, 'Y', ''),
       ('SLKS', '소셜', '링크드인', '발신', 'O', 139, 'Y', ''),
       ('SLKD', '소셜', '링크드인', '댓글', 'O', 140, 'Y', ''),
       ('SEGR', '소셜', '이글루', '수신', 'I', 141, 'Y', ''),
       ('SEGS', '소셜', '이글루', '발신', 'O', 142, 'Y', ''),
       ('SEGD', '소셜', '이글루', '댓글', 'O', 143, 'Y', ''),
       ('SYMR', '소셜', '야머', '수신', 'I', 144, 'Y', ''),
       ('SYMS', '소셜', '야머', '발신', 'O', 145, 'Y', ''),
       ('SYMD', '소셜', '야머', '댓글', 'O', 146, 'Y', ''),
       ('SYMF', '소셜', '야머', '파일전송', 'O', 147, 'Y', ''),
       ('SNBR', '소셜', '네이버 밴드', '수신', 'I', 148, 'Y', ''),
       ('SNBS', '소셜', '네이버 밴드', '발신', 'O', 149, 'Y', ''),
       ('SNBD', '소셜', '네이버 밴드', '댓글', 'O', 150, 'Y', ''),
       ('SLRR', '소셜', '라이브리', '수신', 'I', 151, 'Y', ''),
       ('SLRS', '소셜', '라이브리', '발신', 'O', 152, 'Y', ''),
       ('SLRD', '소셜', '라이브리', '댓글', 'O', 153, 'Y', ''),
       ('SMER', '소셜', 'Medium', '수신', 'I', 154, 'Y', ''),
       ('SMES', '소셜', 'Medium', '발신', 'O', 155, 'Y', ''),
       ('SMED', '소셜', 'Medium', '댓글', 'O', 156, 'Y', ''),
       ('SISR', '소셜', '인스타그램', '수신', 'I', 157, 'Y', ''),
       ('SISS', '소셜', '인스타그램', '발신', 'O', 158, 'Y', ''),
       ('SISD', '소셜', '인스타그램', '댓글', 'O', 159, 'Y', ''),
       ('SISF', '소셜', '인스타그램', '파일전송', 'O', 160, 'Y', ''),
       ('SSFS', '소셜', 'Salesforce', '발신', 'O', 161, 'Y', ''),
       ('VDUR', '영상 스트리밍', '다음 TV', '수신', 'I', 162, 'Y', ''),
       ('VDUS', '영상 스트리밍', '다음 TV', '발신', 'O', 163, 'Y', ''),
       ('VPDR', '영상 스트리밍', '판도라 TV', '수신', 'I', 164, 'Y', ''),
       ('VPDS', '영상 스트리밍', '판도라 TV', '발신', 'O', 165, 'Y', ''),
       ('VGMR', '영상 스트리밍', '곰 TV', '수신', 'I', 166, 'Y', ''),
       ('VGMS', '영상 스트리밍', '곰 TV', '발신', 'O', 167, 'Y', ''),
       ('VYTR', '영상 스트리밍', '유튜브', '수신', 'I', 168, 'Y', ''),
       ('VYTS', '영상 스트리밍', '유튜브', '발신', 'O', 169, 'Y', ''),
       ('VYTD', '영상 스트리밍', '유튜브', '댓글', 'O', 170, 'Y', ''),
       ('VNVR', '영상 스트리밍', '네이버 TV캐스트', '수신', 'I', 171, 'Y', ''),
       ('VNVS', '영상 스트리밍', '네이버 TV캐스트', '발신', 'O', 172, 'Y', ''),
       ('QNVC', '메신저', '네이버', '채팅', 'O', 173, 'N', ''),
       ('QNVF', '메신저', '네이버', '파일전송', 'O', 174, 'N', ''),
       ('QNMR', '메신저', '네이버 쪽지', '수신', 'I', 175, 'N', ''),
       ('QNMS', '메신저', '네이버 쪽지', '발신', 'O', 176, 'N', ''),
       ('QDUC', '메신저', '다음', '채팅', 'O', 177, 'N', ''),
       ('QDUF', '메신저', '다음', '파일전송', 'O', 178, 'N', ''),
       ('QDUM', '메신저', '다음', '쪽지', 'O', 179, 'N', ''),
       ('QDSC', '메신저', '대신', '채팅', 'O', 180, 'N', ''),
       ('QDSF', '메신저', '대신', '파일전송', 'O', 181, 'N', ''),
       ('QDSM', '메신저', '대신', '쪽지', 'O', 182, 'N', ''),
       ('QSHC', '메신저', '삼홍사', '채팅', 'O', 183, 'Y', ''),
       ('QSHF', '메신저', '삼홍사', '파일전송', 'O', 184, 'Y', ''),
       ('QSHM', '메신저', '삼홍사', '쪽지', 'O', 185, 'Y', ''),
       ('QDIC', '메신저', '동부생명', '채팅', 'O', 186, 'Y', ''),
       ('QDIF', '메신저', '동부생명', '파일전송', 'O', 187, 'Y', ''),
       ('QDIM', '메신저', '동부생명', '쪽지', 'O', 188, 'Y', ''),
       ('QDFC', '메신저', '동부금융', '채팅', 'O', 189, 'Y', ''),
       ('QDFF', '메신저', '동부금융', '파일전송', 'O', 190, 'Y', ''),
       ('QDFM', '메신저', '동부금융', '쪽지', 'O', 191, 'Y', ''),
       ('QDGC', '메신저', '동국제강', '채팅', 'O', 192, 'Y', ''),
       ('QDGF', '메신저', '동국제강', '파일전송', 'O', 193, 'Y', ''),
       ('QDGM', '메신저', '동국제강', '쪽지', 'O', 194, 'Y', ''),
       ('QFMC', '메신저', '프리본드', '채팅', 'O', 195, 'Y', 'MSG'),
       ('QFMF', '메신저', '프리본드', '파일전송', 'O', 196, 'Y', 'MSG'),
       ('QFMM', '메신저', '프리본드', '쪽지', 'O', 197, 'Y', 'MSG'),
       ('QFMJ', '메신저', '프리본드', '참여', 'O', 198, 'Y', 'MSG'),
       ('QFML', '메신저', '프리본드', '떠남', 'O', 199, 'Y', 'MSG'),
       ('QMCC', '메신저', 'M-채널', '채팅', 'O', 200, 'Y', ''),
       ('QMCF', '메신저', 'M-채널', '파일전송', 'O', 201, 'Y', ''),
       ('QMCM', '메신저', 'M-채널', '쪽지', 'O', 202, 'Y', ''),
       ('QMSC', '메신저', '미쓰리', '채팅', 'O', 203, 'Y', 'MSG'),
       ('QMSF', '메신저', '미쓰리', '파일전송', 'O', 204, 'Y', 'MSG'),
       ('QMSM', '메신저', '미쓰리', '쪽지', 'O', 205, 'Y', 'MSG'),
       ('QMSJ', '메신저', '미쓰리', '참여', 'O', 206, 'Y', 'MSG'),
       ('QMSL', '메신저', '미쓰리', '떠남', 'O', 207, 'Y', 'MSG'),
       ('QNTC', '메신저', '네이트', '채팅', 'O', 208, 'Y', 'MSG'),
       ('QNTF', '메신저', '네이트', '파일전송', 'O', 209, 'Y', 'MSG'),
       ('QNTM', '메신저', '네이트', '쪽지', 'O', 210, 'Y', 'MSG'),
       ('QNTJ', '메신저', '네이트', '참여', 'O', 211, 'Y', 'MSG'),
       ('QNTL', '메신저', '네이트', '떠남', 'O', 212, 'Y', 'MSG'),
       ('QSSC', '메신저', '삼성증권', '채팅', 'O', 213, 'N', ''),
       ('QSSF', '메신저', '삼성증권', '파일전송', 'O', 214, 'N', ''),
       ('QSSM', '메신저', '삼성증권', '쪽지', 'O', 215, 'N', ''),
       ('QSFC', '메신저', '삼성화재', '채팅', 'O', 216, 'Y', ''),
       ('QSFF', '메신저', '삼성화재', '파일전송', 'O', 217, 'Y', ''),
       ('QSFM', '메신저', '삼성화재', '쪽지', 'O', 218, 'Y', ''),
       ('QSFJ', '메신저', '삼성화재', '참여', 'O', 219, 'Y', ''),
       ('QSFL', '메신저', '삼성화재', '떠남', 'O', 220, 'Y', ''),
       ('QSPC', '메신저', 'SK 프라이든', '채팅', 'O', 221, 'Y', ''),
       ('QSPF', '메신저', 'SK 프라이든', '파일전송', 'O', 222, 'Y', ''),
       ('QSPM', '메신저', 'SK 프라이든', '쪽지', 'O', 223, 'Y', ''),
       ('QSPJ', '메신저', 'SK 프라이든', '참여', 'O', 224, 'Y', ''),
       ('QSPL', '메신저', 'SK 프라이든', '떠남', 'O', 225, 'Y', ''),
       ('QSBC', '메신저', 'SK 비즈', '채팅', 'O', 226, 'N', ''),
       ('QSBF', '메신저', 'SK 비즈', '파일전송', 'O', 227, 'N', ''),
       ('QSBM', '메신저', 'SK 비즈', '쪽지', 'O', 228, 'N', ''),
       ('QWJC', '메신저', '웅진', '채팅', 'O', 229, 'Y', ''),
       ('QWJF', '메신저', '웅진', '파일전송', 'O', 230, 'Y', ''),
       ('QWJM', '메신저', '웅진', '쪽지', 'O', 231, 'Y', ''),
       ('QGPC', '메신저', 'ChatGPT', '채팅', 'O', 232, 'Y', ''),
       ('QDAC', '메신저', 'Dall-E', '채팅', 'O', 233, 'Y', ''),
       ('QDAF', '메신저', 'Dall-E', '파일전송', 'O', 234, 'Y', ''),
       ('QCLC', '메신저', '쿨', '채팅', 'O', 235, 'Y', 'MSG'),
       ('QCLF', '메신저', '쿨', '파일전송', 'O', 236, 'Y', 'MSG'),
       ('QCLM', '메신저', '쿨', '쪽지', 'O', 237, 'Y', 'MSG'),
       ('QCLJ', '메신저', '쿨', '참여', 'O', 238, 'Y', 'MSG'),
       ('QCLL', '메신저', '쿨', '떠남', 'O', 239, 'Y', 'MSG'),
       ('QKBC', '메신저', 'K-bond', '채팅', 'O', 240, 'Y', 'MSG'),
       ('QKBF', '메신저', 'K-bond', '파일전송', 'O', 241, 'Y', 'MSG'),
       ('QKBM', '메신저', 'K-bond', '쪽지', 'O', 242, 'Y', 'MSG'),
       ('QKBJ', '메신저', 'K-bond', '참여', 'O', 243, 'Y', 'MSG'),
       ('QKBL', '메신저', 'K-bond', '떠남', 'O', 244, 'Y', 'MSG'),
       ('QEKC', '메신저', '아이콘', '채팅', 'O', 245, 'Y', 'MSG'),
       ('QEKF', '메신저', '아이콘', '파일전송', 'O', 246, 'Y', 'MSG'),
       ('QEKJ', '메신저', '아이콘', '참여', 'O', 247, 'Y', 'MSG'),
       ('QEKL', '메신저', '아이콘', '떠남', 'O', 248, 'Y', 'MSG'),
       ('QEKH', '메신저', '아이콘', '과거 데이터', 'O', 249, 'Y', 'MSG'),
       ('QSLC', '메신저', 'Slack', '채팅', 'O', 250, 'Y', 'MSG'),
       ('QSLF', '메신저', 'Slack', '파일전송', 'O', 251, 'Y', 'MSG'),
       ('QSLJ', '메신저', 'Slack', '참여', 'O', 252, 'Y', 'MSG'),
       ('QSLL', '메신저', 'Slack', '떠남', 'O', 253, 'Y', 'MSG'),
       ('QSYC', '메신저', '신영자산운용', '채팅', 'O', 254, 'Y', 'MSG'),
       ('QSYF', '메신저', '신영자산운용', '파일전송', 'O', 255, 'Y', 'MSG'),
       ('QSYM', '메신저', '신영자산운용', '쪽지', 'O', 256, 'Y', 'MSG'),
       ('QSYJ', '메신저', '신영자산운용', '참여', 'O', 257, 'Y', 'MSG'),
       ('QSYL', '메신저', '신영자산운용', '떠남', 'O', 258, 'Y', 'MSG'),
       ('QFBC', '메신저', '페이스북', '채팅', 'O', 259, 'Y', 'MSG'),
       ('QFBF', '메신저', '페이스북', '파일전송', 'O', 260, 'Y', 'MSG'),
       ('QKMC', '메신저', '삼성KnoxMessenger', '채팅', 'O', 261, 'Y', 'MSG'),
       ('QKMF', '메신저', '삼성KnoxMessenger', '파일전송', 'O', 262, 'Y', 'MSG'),
       ('QKMR', '메신저', '삼성KnoxMessenger', '파일수신', 'I', 263, 'Y', 'MSG'),
       ('QKMW', '메신저', '삼성KnoxMessenger', '전달', 'O', 264, 'Y', 'MSG'),
       ('QKMV', '메신저', '삼성KnoxMessenger', '파일-미리보기', 'O', 265, 'Y', 'MSG'),
       ('QGHC', '메신저', '구글 Hangout', '채팅', 'O', 266, 'Y', 'MSG'),
       ('QGHF', '메신저', '구글 Hangout', '파일전송', 'O', 267, 'Y', 'MSG'),
       ('QGGC', '메신저', '구글 chat', '채팅', 'O', 268, 'Y', 'MSG'),
       ('QGGF', '메신저', '구글 chat', '파일전송', 'O', 269, 'Y', 'MSG'),
       ('QGMC', '메신저', '구글 Meet', '채팅', 'O', 270, 'Y', 'MSG'),
       ('QGBC', '메신저', '구글 Bard', '채팅', 'O', 271, 'Y', 'MSG'),
       ('QBIC', '메신저', 'Microsoft BingAI Chat', '채팅', 'O', 272, 'Y', 'MSG'),
       ('QWTC', '메신저', 'Wrtn', '채팅', 'O', 273, 'Y', ''),
       ('QISC', '메신저', '인스타그램 DM', '채팅', 'O', 274, 'Y', 'MSG'),
       ('QISF', '메신저', '인스타그램 DM', '파일전송', 'O', 275, 'Y', 'MSG'),
       ('QZAC', '메신저', 'Zalo', '채팅', 'O', 276, 'Y', 'MSG'),
       ('QZAF', '메신저', 'Zalo', '파일전송', 'O', 277, 'Y', 'MSG'),
       ('QNBC', '메신저', '네이버 밴드 채팅', '채팅', 'O', 278, 'Y', 'MSG'),
       ('QNBF', '메신저', '네이버 밴드 채팅', '파일전송', 'O', 279, 'Y', 'MSG'),
       ('QDOC', '메신저', 'Dooray app', '채팅', 'O', 280, 'Y', 'MSG'),
       ('QDOF', '메신저', 'Dooray app', '파일전송', 'O', 281, 'Y', 'MSG'),
       ('QUKC', '메신저', '기타', '채팅', 'O', 282, 'Y', 'MSG'),
       ('QUKF', '메신저', '기타', '파일전송', 'O', 283, 'Y', 'MSG'),
       ('QUKM', '메신저', '기타', '쪽지', 'O', 284, 'Y', 'MSG'),
       ('QUKJ', '메신저', '기타', '참여', 'O', 285, 'Y', 'MSG'),
       ('QUKL', '메신저', '기타', '떠남', 'O', 286, 'Y', 'MSG'),
       ('FFTC', '파일전송', 'FTP', 'CMD', 'O', 287, 'Y', ''),
       ('FFTG', '파일전송', 'FTP', 'GET', 'I', 288, 'Y', ''),
       ('FFTP', '파일전송', 'FTP', 'PUT', 'O', 289, 'Y', ''),
       ('FFTL', '파일전송', 'FTP', 'CONNECT', 'O', 290, 'Y', ''),
       ('FZM-', '파일전송', 'Zmodem', '-', 'O', 291, 'Y', ''),
       ('FNVR', '파일전송', '네이버 MYBOX', '수신', 'I', 292, 'Y', ''),
       ('FNVS', '파일전송', '네이버 MYBOX', '발신', 'O', 293, 'Y', ''),
       ('FGGR', '파일전송', '구글 드라이브', '수신', 'I', 294, 'Y', ''),
       ('FGGS', '파일전송', '구글 드라이브', '발신', 'O', 295, 'Y', ''),
       ('FODR', '파일전송', 'OneDrive', '수신', 'I', 296, 'Y', ''),
       ('FODS', '파일전송', 'OneDrive', '발신', 'O', 297, 'Y', ''),
       ('FDBR', '파일전송', 'Dropbox', '수신', 'I', 298, 'Y', ''),
       ('FDBS', '파일전송', 'Dropbox', '발신', 'O', 299, 'Y', ''),
       ('F2NR', '파일전송', '2nd 드라이브', '수신', 'I', 300, 'N', ''),
       ('F2NS', '파일전송', '2nd 드라이브', '발신', 'O', 301, 'N', ''),
       ('FPSR', '파일전송', 'Polarisoffice ', '수신', 'I', 302, 'Y', ''),
       ('FPSS', '파일전송', 'Polarisoffice ', '발신', 'O', 303, 'Y', ''),
       ('FICR', '파일전송', 'Icloud', '수신', 'I', 304, 'Y', ''),
       ('FICS', '파일전송', 'Icloud', '발신', 'O', 305, 'Y', ''),
       ('FYDR', '파일전송', 'Yandex', '수신', 'I', 306, 'Y', ''),
       ('FYDS', '파일전송', 'Yandex', '발신', 'O', 307, 'Y', ''),
       ('FWHR', '파일전송', 'LG 웹하드', '수신', 'I', 308, 'Y', ''),
       ('FWHS', '파일전송', 'LG 웹하드', '발신', 'O', 309, 'Y', ''),
       ('FGIR', '파일전송', 'GitHub', '수신', 'I', 310, 'Y', ''),
       ('FGIS', '파일전송', 'GitHub', '발신', 'O', 311, 'Y', ''),
       ('FDOR', '파일전송', 'Dooray', '수신', 'I', 312, 'Y', ''),
       ('FDOS', '파일전송', 'Dooray', '발신', 'O', 313, 'Y', ''),
       ('FWES', '파일전송', 'Wetransfer', '발신', 'O', 314, 'Y', ''),
       ('FASS', '파일전송', 'AWS S3 bucket', '발신', 'O', 315, 'Y', ''),
       ('FGES', '파일전송', '구글 렌즈', '발신', 'O', 316, 'Y', ''),
       ('FTRS', '파일전송', 'File Transfer.io', '발신', 'O', 317, 'Y', ''),
       ('FCLS', '파일전송', 'pCloud Transfer', '발신', 'O', 318, 'Y', ''),
       ('FMZS', '파일전송', 'M/Z Cloud', '발신', 'O', 319, 'Y', ''),
       ('FMZR', '파일전송', 'M/Z Cloud', '수신', 'O', 320, 'Y', ''),
       ('FUKR', '파일전송', '기타', '수신', 'I', 321, 'Y', ''),
       ('FUKS', '파일전송', '기타', '발신', 'O', 322, 'Y', ''),
       ('NENR', '노트', 'EVERNOTE', '수신', 'I', 323, 'Y', ''),
       ('NENS', '노트', 'EVERNOTE', '발신', 'O', 324, 'Y', ''),
       ('NONR', '노트', 'ONENOTE', '수신', 'I', 325, 'Y', ''),
       ('NONS', '노트', 'ONENOTE', '발신', 'O', 326, 'Y', ''),
       ('NLVS', '노트', 'Outlook.com 메모', '발신', 'O', 327, 'Y', ''),
       ('NBTS', '노트', 'BIT.AI', '발신', 'O', 328, 'Y', ''),
       ('NNOS', '노트', 'Notion', '발신', 'O', 329, 'Y', ''),
       ('NGGS', '노트', '구글 docs', '발신', 'O', 330, 'Y', ''),
       ('NGTS', '노트', '구글 tasks', '발신', 'O', 331, 'Y', ''),
       ('NGKS', '노트', '구글 keep', '발신', 'O', 332, 'Y', ''),
       ('NSSR', '노트', '삼성 노트', '수신', 'I', 333, 'Y', ''),
       ('NSSS', '노트', '삼성 노트', '발신', 'O', 334, 'Y', ''),
       ('NNVS', '노트', '네이버 오피스', '발신', 'O', 335, 'Y', ''),
       ('NDBS', '노트', 'Dropbox paper', '발신', 'O', 336, 'Y', ''),
       ('NHCS', '노트', '한컴 오피스', '발신', 'O', 337, 'Y', ''),
       ('NMOS', '노트', 'MS오피스', '발신', 'O', 338, 'Y', ''),
       ('NCDS', '노트', 'Coda', '발신', 'O', 339, 'Y', ''),
       ('NNMR', '노트', '네이버 메모', '수신', 'I', 340, 'Y', ''),
       ('NNMS', '노트', '네이버 메모', '발신', 'O', 341, 'Y', ''),
       ('NCNS', '노트', 'Clova Note', '발신', 'O', 342, 'Y', ''),
       ('NGIS', '노트', 'Github Gist', '발신', 'O', 343, 'Y', ''),
       ('NSNS', '노트', 'SimpleNote', '발신', 'O', 344, 'Y', ''),
       ('NAGS', '노트', 'Agit', '발신', 'O', 345, 'Y', ''),
       ('NPSS', '노트', 'Polaris office', '발신', 'O', 346, 'Y', ''),
       ('NBOS', '노트', 'Box', '발신', 'O', 347, 'Y', ''),
       ('NCKS', '노트', 'ClickUp', '발신', 'O', 348, 'Y', ''),
       ('NGNS', '노트', 'Goodnotes', '발신', 'O', 349, 'Y', ''),
       ('NMNS', '노트', 'Milanote', '발신', 'O', 350, 'Y', ''),
       ('NZQS', '노트', 'zohocliq', '발신', 'O', 351, 'Y', ''),
       ('NMTS', '노트', 'Mentimeter', '발신', 'O', 352, 'Y', ''),
       ('NUKS', '노트', '기타', '발신', 'O', 353, 'Y', ''),
       ('AGCR', '일정', '구글캘린더일정', '수신', 'I', 354, 'N', ''),
       ('AGCS', '일정', '구글캘린더일정', '발신', 'O', 355, 'Y', ''),
       ('AGLR', '일정', '구글캘린더메일', '수신', 'I', 356, 'N', ''),
       ('AGLS', '일정', '구글캘린더메일', '발신', 'O', 357, 'Y', ''),
       ('ANCS', '일정', '네이버 캘린더', '발신', 'O', 358, 'Y', ''),
       ('ZTN-', '기타 서비스', 'Telnet', '-', 'O', 359, 'Y', ''),
       ('ZXT-', '기타 서비스', 'Xterm', '-', 'O', 360, 'Y', ''),
       ('ZRL-', '기타 서비스', 'R-Login', '-', 'O', 361, 'Y', ''),
       ('ZNP-', '기타 서비스', 'NNTP', '-', 'O', 362, 'Y', ''),
       ('ZPC-', '기타 서비스', 'PC 보안', '-', 'O', 363, 'N', ''),
       ('ZSH-', '기타 서비스', 'SSH', 'SSH 세션 정보', 'O', 364, 'Y', ''),
       ('XX1R', '모니터링_제외', '미분류_타입1', '수신', 'I', 365, 'Y', ''),
       ('XX1S', '모니터링_제외', '미분류_타입1', '발신', 'O', 366, 'Y', ''),
       ('XX2R', '모니터링_제외', '미분류_타입2', '수신', 'I', 367, 'Y', ''),
       ('XX2S', '모니터링_제외', '미분류_타입2', '발신', 'O', 368, 'Y', ''),
       ('XX3R', '모니터링_제외', '미분류_타입3', '수신', 'I', 369, 'Y', ''),
       ('XX3S', '모니터링_제외', '미분류_타입3', '발신', 'O', 370, 'Y', ''),
       ('XU1R', '모니터링_제외', '웹서비스(미분류)_타입1', '수신', 'I', 371, 'Y', ''),
       ('XU1S', '모니터링_제외', '웹서비스(미분류)_타입1', '발신', 'O', 372, 'Y', ''),
       ('XU2R', '모니터링_제외', '웹서비스(미분류)_타입2', '수신', 'I', 373, 'Y', ''),
       ('XU2S', '모니터링_제외', '웹서비스(미분류)_타입2', '발신', 'O', 374, 'Y', ''),
       ('XU3R', '모니터링_제외', '웹서비스(미분류)_타입3', '수신', 'I', 375, 'Y', ''),
       ('XU3S', '모니터링_제외', '웹서비스(미분류)_타입3', '발신', 'O', 376, 'Y', ''),
       ('UWSD', '웹서비스(미분류)', '웹 발신', '첨부 - 문서타입', 'O', 377, 'Y', ''),
       ('UWSE', '웹서비스(미분류)', '웹 발신', '첨부 - 문서아님', 'O', 378, 'Y', ''),
       ('UWSU', '웹서비스(미분류)', '웹 발신', '첨부 없음', 'O', 379, 'Y', ''),
       ('UWSH', '웹서비스(미분류)', '웹 발신', '중요도(상)', 'O', 380, 'Y', ''),
       ('UWSM', '웹서비스(미분류)', '웹 발신', '중요도(중)', 'O', 381, 'Y', ''),
       ('UWSL', '웹서비스(미분류)', '웹 발신', '중요도(하)', 'O', 382, 'Y', ''),
       ('UX1R', '웹서비스(미분류)', '미분류_타입1', '수신', 'I', 383, 'Y', ''),
       ('UX1S', '웹서비스(미분류)', '미분류_타입1', '발신', 'O', 384, 'Y', ''),
       ('UX2R', '웹서비스(미분류)', '미분류_타입2', '수신', 'I', 385, 'Y', ''),
       ('UX2S', '웹서비스(미분류)', '미분류_타입2', '발신', 'O', 386, 'Y', ''),
       ('UX3R', '웹서비스(미분류)', '미분류_타입3', '수신', 'I', 387, 'Y', ''),
       ('UX3S', '웹서비스(미분류)', '미분류_타입3', '발신', 'O', 388, 'Y', ''),
       ('UWRD', '웹서비스(미분류)', '웹 수신', '첨부 - 문서타입', 'I', 389, 'Y', ''),
       ('UWRE', '웹서비스(미분류)', '웹 수신', '첨부 - 문서아님', 'I', 390, 'Y', ''),
       ('UWRU', '웹서비스(미분류)', '웹 수신', '첨부 없음', 'I', 391, 'Y', ''),
       ('BWSD', '웹서비스(업무)', '업무 발신', '첨부 - 문서타입', 'O', 392, 'Y', ''),
       ('BWSE', '웹서비스(업무)', '업무 발신', '첨부 - 문서아님', 'O', 393, 'Y', ''),
       ('BWSU', '웹서비스(업무)', '업무 발신', '첨부 없음', 'O', 394, 'Y', ''),
       ('BWRD', '웹서비스(업무)', '업무 수신', '첨부 - 문서타입', 'I', 395, 'Y', ''),
       ('BWRE', '웹서비스(업무)', '업무 수신', '첨부 - 문서아님', 'I', 396, 'Y', ''),
       ('BWRU', '웹서비스(업무)', '업무 수신', '첨부 없음', 'I', 397, 'Y', ''),
       ('TWEC', '화상회의', 'Webex', '채팅', 'O', 398, 'Y', 'MSG'),
       ('TWEF', '화상회의', 'Webex', '파일전송', 'O', 399, 'Y', 'MSG'),
       ('TWEJ', '화상회의', 'Webex', '참여', 'O', 400, 'Y', 'MSG'),
       ('TWEL', '화상회의', 'Webex', '떠남', 'O', 401, 'Y', 'MSG'),
       ('TZOC', '화상회의', 'Zoom', '채팅', 'O', 402, 'Y', 'MSG'),
       ('TZOF', '화상회의', 'Zoom', '파일전송', 'O', 403, 'Y', 'MSG'),
       ('TZOJ', '화상회의', 'Zoom', '참여', 'O', 404, 'Y', 'MSG'),
       ('TZOL', '화상회의', 'Zoom', '떠남', 'O', 405, 'Y', 'MSG'),
       ('TTMC', '화상회의', 'Teams', '채팅', 'O', 406, 'Y', 'MSG'),
       ('TTMF', '화상회의', 'Teams', '파일전송', 'O', 407, 'Y', 'MSG'),
       ('TTMJ', '화상회의', 'Teams', '참여', 'O', 408, 'Y', 'MSG'),
       ('TTML', '화상회의', 'Teams', '떠남', 'O', 409, 'Y', 'MSG'),
       ('TSKC', '화상회의', 'Skype', '채팅', 'O', 410, 'Y', 'MSG'),
       ('TSKF', '화상회의', 'Skype', '파일전송', 'O', 411, 'Y', 'MSG'),
       ('TSKJ', '화상회의', 'Skype', '참여', 'O', 412, 'Y', 'MSG'),
       ('TSKL', '화상회의', 'Skype', '떠남', 'O', 413, 'Y', 'MSG'),
       ('TJMC', '화상회의', 'JoinME', '채팅', 'O', 414, 'Y', 'MSG'),
       ('TJMF', '화상회의', 'JoinME', '파일전송', 'O', 415, 'Y', 'MSG'),
       ('TAMC', '화상회의', 'Amazon Chime', '채팅', 'O', 416, 'Y', 'MSG'),
       ('TAMF', '화상회의', 'Amazon Chime', '파일전송', 'O', 417, 'Y', 'MSG'),
       ('TBJC', '화상회의', 'BlueJeans', '채팅', 'O', 418, 'Y', 'MSG'),
       ('TTDS', '화상회의', 'Tl;dv', '채팅', 'O', 419, 'Y', 'MSG'),
       ('LNVS', '번역기', '파파고 번역', '발신', 'O', 420, 'Y', ''),
       ('LGGS', '번역기', '구글 번역', '발신', 'O', 421, 'Y', ''),
       ('LGPS', '번역기', '구글 번역 플러그인', '발신', 'O', 422, 'Y', ''),
       ('LDES', '번역기', 'Deepl', '발신', 'O', 423, 'Y', ''),
       ('LBIS', '번역기', 'Bing 번역', '발신', 'O', 424, 'Y', ''),
       ('LYMS', '번역기', 'Yandex 번역', '발신', 'O', 425, 'Y', ''),
       ('LUKS', '번역기', '기타', '발신', 'I', 426, 'Y', ''),
       ('IGBS', '생성형 AI', '구글 Gemini', '발신', 'O', 427, 'Y', ''),
       ('IBIS', '생성형 AI', ' Microsoft Copilot', '발신', 'O', 428, 'Y', ''),
       ('IWTS', '생성형 AI', 'Wrtn', '발신', 'O', 429, 'Y', ''),
       ('IGPS', '생성형 AI', 'ChatGPT', '발신', 'O', 430, 'Y', ''),
       ('IDAS', '생성형 AI', 'Dall-E', '발신', 'O', 431, 'Y', ''),
       ('IGCS', '생성형 AI', 'Github Copilot', '발신', 'I', 432, 'Y', ''),
       ('IYCS', '생성형 AI', 'YouChat', '발신', 'I', 433, 'Y', ''),
       ('ICSS', '생성형 AI', 'Chatsonic', '발신', 'I', 434, 'Y', ''),
       ('IRPS', '생성형 AI', 'Replika', '발신', 'I', 435, 'Y', ''),
       ('IPPS', '생성형 AI', 'Perplexity', '발신', 'I', 436, 'Y', ''),
       ('ITCS', '생성형 AI', 'TextCortex', '발신', 'I', 437, 'Y', ''),
       ('IPHS', '생성형 AI', 'Phind', '발신', 'I', 438, 'Y', ''),
       ('IPOS', '생성형 AI', 'Poe', '발신', 'I', 439, 'Y', ''),
       ('IHFS', '생성형 AI', 'Hugging Face', '발신', 'I', 440, 'Y', ''),
       ('ICPS', '생성형 AI', 'Copy.AI', '발신', 'I', 441, 'Y', ''),
       ('IHWS', '생성형 AI', 'HyperWrite', '발신', 'I', 442, 'Y', ''),
       ('IDPS', '생성형 AI', 'DeepAI', '발신', 'I', 443, 'Y', ''),
       ('IACS', '생성형 AI', 'AskCodi', '발신', 'I', 444, 'Y', ''),
       ('INAS', '생성형 AI', 'Native', '발신', 'I', 445, 'Y', ''),
       ('INFS', '생성형 AI', 'NeuroFlash', '발신', 'I', 446, 'Y', ''),
       ('INOS', '생성형 AI', 'Notion AI', '발신', 'I', 447, 'Y', ''),
       ('IMES', '생성형 AI', 'Merlin', '발신', 'I', 448, 'Y', ''),
       ('ICXS', '생성형 AI', 'CLOVA-X', '발신', 'I', 449, 'Y', ''),
       ('IADS', '생성형 AI', 'Adobe AI', '발신', 'I', 450, 'Y', ''),
       ('ICDS', '생성형 AI', 'ClipDrop', '발신', 'I', 451, 'Y', ''),
       ('ISBS', '생성형 AI', 'Stability.Ai', '발신', 'I', 452, 'Y', ''),
       ('IRMS', '생성형 AI', 'Runwayml', '발신', 'I', 453, 'Y', ''),
       ('IGVS', '생성형 AI', 'Google Vertex', '발신', 'I', 454, 'Y', ''),
       ('IGLS', '생성형 AI', 'Google Colab', '발신', 'I', 455, 'Y', ''),
       ('ICWS', '생성형 AI', 'CodeWhisperer', '발신', 'I', 456, 'Y', ''),
       ('IMSS', '생성형 AI', 'MakerSuite', '발신', 'I', 457, 'Y', ''),
       ('IOCS', '생성형 AI', 'Clova OCR', '발신', 'I', 458, 'Y', ''),
       ('IAOS', '생성형 AI', 'Azure OpenAI', '발신', 'I', 459, 'Y', ''),
       ('ICUS', '생성형 AI', '네이버 CUE:', '발신', 'I', 460, 'Y', ''),
       ('IMJS', '생성형 AI', 'Midjourney', '발신', 'I', 461, 'Y', ''),
       ('ISGR', '생성형 AI', 'slidesGPT', '수신', 'I', 462, 'Y', ''),
       ('ISGS', '생성형 AI', 'SlidesGPT', '발신', 'I', 463, 'Y', ''),
       ('IDMS', '생성형 AI', 'Ai Docmaker', '발신', 'I', 464, 'Y', ''),
       ('IRKS', '생성형 AI', 'Reka AI', '발신', 'I', 465, 'Y', ''),
       ('ICLS', '생성형 AI', 'Claude', '발신', 'I', 466, 'Y', ''),
       ('IDMR', '생성형 AI', 'Ai Docmaker', '수신', 'I', 467, 'Y', ''),
       ('IADR', '생성형 AI', 'Adobe AI', '수신', 'I', 468, 'Y', ''),
       ('IWDS', '생성형 AI', 'Dream by WOMBO', '발신', 'I', 469, 'Y', ''),
       ('IGAS', '생성형 AI', 'GetImg.AI', '발신', 'I', 470, 'Y', ''),
       ('IWKS', '생성형 AI', 'Wrks.ai', '발신', 'I', 471, 'Y', ''),
       ('IPSS', '생성형 AI', 'Polaris office ai', '발신', 'I', 472, 'Y', ''),
       ('IBGS', '생성형 AI', 'Goover AI', '발신', 'I', 473, 'Y', ''),
       ('IIAS', '생성형 AI', 'iAsk AI', '발신', 'I', 474, 'Y', ''),
       ('ISNS', '생성형 AI', 'Suno AI', '발신', 'I', 475, 'Y', ''),
       ('IPES', '생성형 AI', 'Perchance', '발신', 'I', 476, 'Y', ''),
       ('IPFS', '생성형 AI', 'ChatPDF', '발신', 'I', 477, 'Y', ''),
       ('IXOS', '생성형 AI', 'Exaone', '발신', 'I', 478, 'Y', ''),
       ('ISOR', '생성형 AI', 'Slidesgo', '수신', 'I', 479, 'Y', ''),
       ('ISOS', '생성형 AI', 'Slidesgo', '발신', 'I', 480, 'Y', ''),
       ('IKRS', '생성형 AI', 'KREA', '발신', 'I', 481, 'Y', ''),
       ('ILMS', '생성형 AI', 'GoogleNotebook LM', '발신', 'I', 482, 'Y', ''),
       ('ICCS', '생성형 AI', 'Capcut', '발신', 'I', 483, 'Y', ''),
       ('IMGS', '생성형 AI', 'Magictool', '발신', 'I', 484, 'Y', ''),
       ('IGSS', '생성형 AI', 'Genspark', '발신', 'I', 485, 'Y', ''),
       ('IFES', '생성형 AI', 'felo', '발신', 'I', 486, 'Y', ''),
       ('ITPS', '생성형 AI', 'Tripo3D', '발신', 'I', 487, 'Y', ''),
       ('ITPR', '생성형 AI', 'Tripo3D', '수신', 'I', 488, 'Y', ''),
       ('IELS', '생성형 AI', 'Elevenlabs', '발신', 'I', 489, 'Y', ''),
       ('IELR', '생성형 AI', 'Elevenlabs', '수신', 'I', 490, 'Y', ''),
       ('IGRS', '생성형 AI', 'Grammarly', '발신', 'I', 491, 'Y', ''),
       ('IVRS', '생성형 AI', 'Vrew', '발신', 'I', 492, 'Y', ''),
       ('INIS', '생성형 AI', 'NightCafe', '발신', 'I', 493, 'Y', ''),
       ('ICAS', '생성형 AI', 'CivitAI', '발신', 'I', 494, 'Y', ''),
       ('ILIS', '생성형 AI', 'Liner', '발신', 'I', 495, 'Y', ''),
       ('IBCS', '생성형 AI', 'Bing Image Creator', '발신', 'I', 496, 'Y', ''),
       ('IDSS', '생성형 AI', 'Deepseek', '발신', 'I', 497, 'Y', ''),
       ('IBDS', '생성형 AI', 'Baidu Ai', '발신', 'I', 498, 'Y', ''),
       ('IGIS', '생성형 AI', 'Gemini AI api', '발신', 'I', 499, 'Y', ''),
       ('IDTS', '생성형 AI', '에이닷', '발신', 'I', 500, 'Y', ''),
       ('IQBS', '생성형 AI', 'QuillBot', '발신', 'I', 501, 'Y', ''),
       ('ICHC', '생성형 AI', 'Character.ai', '발신', 'I', 502, 'Y', ''),
       ('ISRS', '생성형 AI', 'Sora/Openai', '발신', 'I', 503, 'Y', ''),
       ('INNS', '생성형 AI', 'Nano AI', '발신', 'I', 504, 'Y', ''),
       ('IDBS', '생성형 AI', 'Doubao', '발신', 'I', 505, 'Y', ''),
       ('IUKS', '생성형 AI', '기타', '발신', 'I', 506, 'Y', ''),
       ('PDOS', '프로젝트', 'dooray', '발신', 'O', 507, 'Y', ''),
       ('PGIS', '프로젝트', 'github', '발신', 'O', 508, 'Y', ''),
       ('PGLS', '프로젝트', 'Glassdoor', '발신', 'O', 509, 'Y', ''),
       ('EBDR', '그룹웨어', '게시', '수신', 'I', 510, 'Y', ''),
       ('EBD-', '그룹웨어', '게시', '발신', 'O', 511, 'Y', ''),
       ('EBBR', '그룹웨어', '게시판', '수신', 'I', 512, 'Y', ''),
       ('EBBS', '그룹웨어', '게시판', '발신', 'O', 513, 'Y', ''),
       ('EBBF', '그룹웨어', '게시판', '파일수신', 'I', 514, 'Y', ''),
       ('EAAR', '그룹웨어', '결재', '수신', 'I', 515, 'Y', ''),
       ('EAAS', '그룹웨어', '결재', '발신', 'O', 516, 'Y', ''),
       ('EAAG', '그룹웨어', '결재', '통보 - 수신', 'I', 517, 'Y', ''),
       ('EAAP', '그룹웨어', '결재', '통보 - 발신', 'O', 518, 'Y', ''),
       ('EAAF', '그룹웨어', '결재', '파일수신', 'I', 519, 'Y', ''),
       ('EMMR', '그룹웨어', '메일', '그룹웨어 수신', 'I', 520, 'Y', ''),
       ('EMMS', '그룹웨어', '메일', '그룹웨어 발신', 'O', 521, 'Y', ''),
       ('EMMG', '그룹웨어', '메일', 'OWA 수신', 'I', 522, 'Y', ''),
       ('EMMP', '그룹웨어', '메일', 'OWA 발신', 'O', 523, 'Y', ''),
       ('EMMD', '그룹웨어', '메일', 'RPC 수신', 'I', 524, 'Y', ''),
       ('EMMU', '그룹웨어', '메일', 'RPC 발신', 'O', 525, 'Y', ''),
       ('EMMC', '그룹웨어', '메일', '수신', 'I', 526, 'Y', ''),
       ('EMML', '그룹웨어', '메일', '발신', 'O', 527, 'Y', ''),
       ('EMM1', '그룹웨어', '메일', '보안등급1', 'O', 528, 'Y', ''),
       ('EMM2', '그룹웨어', '메일', '보안등급2', 'O', 529, 'Y', ''),
       ('EMM3', '그룹웨어', '메일', '보안등급3', 'O', 530, 'Y', ''),
       ('EMM4', '그룹웨어', '메일', '보안등급4', 'O', 531, 'Y', ''),
       ('EMMA', '그룹웨어', '메일', '임시(자동)', 'O', 532, 'Y', ''),
       ('EMMT', '그룹웨어', '메일', '임시(수동)', 'O', 533, 'Y', ''),
       ('EMMK', '그룹웨어', '메일', 'Outlook - 수신', 'I', 534, 'Y', ''),
       ('EMMO', '그룹웨어', '메일', 'Outlook - 발신', 'O', 535, 'Y', ''),
       ('EMMB', '그룹웨어', '메일', '그룹웨어 예약메일', 'O', 536, 'Y', ''),
       ('EMBR', '그룹웨어', '모바일', '수신', 'I', 537, 'Y', ''),
       ('EMB-', '그룹웨어', '모바일', '발신', 'O', 538, 'Y', ''),
       ('EWSR', '그룹웨어', '웹서비스', '수신', 'I', 539, 'Y', ''),
       ('EWS-', '그룹웨어', '웹서비스', '발신', 'O', 540, 'Y', ''),
       ('EPUR', '그룹웨어', '일반', '수신', 'I', 541, 'Y', ''),
       ('EPU-', '그룹웨어', '일반', '발신', 'O', 542, 'Y', ''),
       ('EAU-', '그룹웨어', '일반(자동전달)', '자동전달', 'O', 543, 'Y', ''),
       ('ESCR', '그룹웨어', '일정 명함', '수신', 'I', 544, 'Y', ''),
       ('ESC-', '그룹웨어', '일정 명함', '발신', 'O', 545, 'Y', ''),
       ('EMF-', '그룹웨어', '파일 다운로드', '-', 'I', 546, 'Y', ''),
       ('EMU-', '그룹웨어', '기타', '', 'O', 547, 'Y', ''),
       ('EMDR', '그룹웨어', '드라이브', '수신', 'I', 548, 'Y', ''),
       ('EMDS', '그룹웨어', '드라이브', '발신', 'O', 549, 'Y', ''),
       ('ECIS', '그룹웨어', 'Samsung cic', '발신', 'O', 550, 'Y', ''),
       ('EMER', '그룹웨어', '메신저', '수신', 'O', 551, 'Y', ''),
       ('EMES', '그룹웨어', '메신저', '발신', 'O', 552, 'Y', ''),
       ('EZQC', '그룹웨어', 'Zohocliq', '채팅', 'O', 553, 'Y', ''),
       ('EZQS', '그룹웨어', 'Zohocliq', '캘린더', 'O', 554, 'Y', ''),
       ('DCCS', '편집기', 'Clip Champ', '발신', 'O', 555, 'Y', ''),
       ('DFGS', '편집기', 'Figma', '발신', 'O', 556, 'Y', ''),
       ('DOVS', '편집기', 'Overleaf', '발신', 'O', 557, 'Y', ''),
       ('DOVR', '편집기', 'Overleaf', '수신', 'O', 558, 'Y', ''),
       ('DPKS', '편집기', 'Plunker', '발신', 'O', 559, 'Y', ''),
       ('DNWS', '편집기', 'Namu.wiki', '발신', 'O', 560, 'Y', ''),
       ('DWKS', '편집기', 'WikiPedia', '발신', 'O', 561, 'Y', ''),
       ('JBDS', '웹사이트', 'Baidu', '발신', 'O', 562, 'Y', '');


UPDATE UI_SERVICE
SET SERVICENM_LV2 = 'Microsoft Copilot'
WHERE SERVICECD = 'IBIS';


/* UI MENU */
DELETE FROM UI_MENU;
INSERT INTO UI_MENU (`MENU_ID`, `MENU_DEFAULT_NAME`, `P_MENU_ID`, `PKG_TYPE`, `MENU_AUTH`, `MENU_LINK`, `MENU_ICON`, `MENU_ORDER`, `MENU_USEYN`, `MENU_IMG_PATH`)  VALUES
('ANALYSIS_FLUCTUATION', '사용량 증감 분석', 'DATA_ANALYSIS', 'L', 'M', 'analysis/usageCompare.do', 'fa fa-area-chart', 2, 'Y', NULL),
('ANALYSIS_INFO', '개인정보 유출 관계 분석', 'DATA_ANALYSIS', 'L', 'M', 'analysis/infoStat.do', 'fa fa-cube', 6, 'Y', NULL),
('ANALYSIS_SIMILARITY','AI 유사도 분석','DATA_ANALYSIS','L','S','analysis/similarity.do','fa fa-pie-chart',7,'Y',NULL),
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
('POLICY_PATTERN', '패턴 예외 정책', 'POLICY_MGMT', 'L', 'S', 'uacs/patternExcept.do', 'fa fa-unlink', 2, 'Y', NULL),
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
('STAT_GW_ATTACHTYPE','그룹웨어 첨부 파일 통계','STAT_CONTENT','L','S','ems/gwAttachTypeStat.do','fa fa-pie-chart',16,'Y',NULL),
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

CREATE TABLE IF NOT EXISTS UI_LLM(
    LLM_CONF VARCHAR(100) NOT NULL COMMENT 'LLM 위치',
    LLM_PROMPT VARCHAR(256) NOT NULL COMMENT 'LLM 프롬프트',
    LLM_MODEL VARCHAR(256) NOT NULL COMMENT 'LLM MODEL',
    LLM_CONTENT VARCHAR(256) NOT NULL COMMENT 'LLM CONTENT',
    PRIMARY KEY (LLM_CONF)	) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='LLM 질문 프롬포트, 모델 설정';

INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('content.transfer','위에 있는 내용을 한글로 번역해죠','gemma2:27b','상세보기 - 번역');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('content.keyword','위에 내용에서 주제키워드 단어로 10개 추출해죠','gemma2:27b','상세보기 - 키워드요약');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('content.summary','위에 있는 내용을 100자이내로 한글로 요약해죠','gemma2:27b','상세보기 - 내용요약');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('content.analysis','위에 있는 내용은 인터넷 패킷데이터를 텍스트로 표현한거야 이 부분을 분석해서 어떤 서비스 인지 한글로 알려죠','gemma2:27b','상세보기 - 내용분석');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('url.analysis','위에 있는 통신하는 URL 주소가 어떤 서비스인지 간략하게 알려줄수 있어?','gemma2:27b','상세보기 - URL 분석');