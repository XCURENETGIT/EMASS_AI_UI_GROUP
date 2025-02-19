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
       ('WNVR', '웹메일', '네이버', '수신', 'I', 6, 'Y', ''),
       ('WNVS', '웹메일', '네이버', '발신', 'O', 7, 'Y', ''),
       ('WNVB', '웹메일', '네이버', '예약메일', 'O', 8, 'Y', ''),
       ('WNVT', '웹메일', '네이버', '임시저장', 'O', 9, 'Y', ''),
       ('WDUR', '웹메일', '다음', '수신', 'I', 10, 'Y', ''),
       ('WDUS', '웹메일', '다음', '발신', 'O', 11, 'Y', ''),
       ('WDUB', '웹메일', '다음', '예약메일', 'O', 12, 'Y', ''),
       ('WDUT', '웹메일', '다음', '임시저장', 'O', 13, 'Y', ''),
       ('WCLR', '웹메일', '천리안', '수신', 'I', 14, 'Y', ''),
       ('WCLS', '웹메일', '천리안', '발신', 'O', 15, 'Y', ''),
       ('WCLB', '웹메일', '천리안', '예약메일', 'O', 16, 'Y', ''),
       ('WCLT', '웹메일', '천리안', '임시저장', 'O', 17, 'Y', ''),
       ('WNTR', '웹메일', '네이트', '수신', 'I', 18, 'Y', ''),
       ('WNTS', '웹메일', '네이트', '발신', 'O', 19, 'Y', ''),
       ('WNTB', '웹메일', '네이트', '예약메일', 'O', 20, 'Y', ''),
       ('WNTT', '웹메일', '네이트', '임시저장', 'O', 21, 'Y', ''),
       ('WKRR', '웹메일', '코리아', '수신', 'I', 22, 'Y', ''),
       ('WKRS', '웹메일', '코리아', '발신', 'O', 23, 'Y', ''),
       ('WKRB', '웹메일', '코리아', '예약메일', 'O', 24, 'Y', ''),
       ('WKRT', '웹메일', '코리아', '임시저장', 'O', 25, 'Y', ''),
       ('WUTR', '웹메일', '유니텔', '수신', 'I', 26, 'Y', ''),
       ('WUTS', '웹메일', '유니텔', '발신', 'O', 27, 'Y', ''),
       ('WUTB', '웹메일', '유니텔', '예약메일', 'O', 28, 'Y', ''),
       ('WUTT', '웹메일', '유니텔', '임시저장', 'O', 29, 'Y', ''),
       ('WYAR', '웹메일', 'Yeah', '수신', 'I', 30, 'Y', ''),
       ('WYAS', '웹메일', 'Yeah', '발신', 'O', 31, 'Y', ''),
       ('WYAT', '웹메일', 'Yeah', '임시저장', 'O', 32, 'Y', ''),
       ('WSNR', '웹메일', 'SINA', '수신', 'I', 33, 'Y', ''),
       ('WSNS', '웹메일', 'SINA', '발신', 'O', 34, 'Y', ''),
       ('WSNB', '웹메일', 'SINA', '예약메일', 'O', 35, 'Y', ''),
       ('WSNT', '웹메일', 'SINA', '임시저장', 'O', 36, 'Y', ''),
       ('WSUR', '웹메일', 'SOHU', '수신', 'I', 37, 'Y', ''),
       ('WSUS', '웹메일', 'SOHU', '발신', 'O', 38, 'Y', ''),
       ('WSUB', '웹메일', 'SOHU', '예약메일', 'O', 39, 'Y', ''),
       ('WSUT', '웹메일', 'SOHU', '임시저장', 'O', 40, 'Y', ''),
       ('WYHR', '웹메일', '야후', '수신', 'I', 41, 'Y', ''),
       ('WYHS', '웹메일', '야후', '발신', 'O', 42, 'Y', ''),
       ('WYHT', '웹메일', '야후', '임시저장', 'O', 43, 'Y', ''),
       ('WGGR', '웹메일', 'Gmail', '수신', 'I', 44, 'Y', ''),
       ('WGGS', '웹메일', 'Gmail', '발신', 'O', 45, 'Y', ''),
       ('WGGT', '웹메일', 'Gmail', '임시저장', 'O', 46, 'Y', ''),
       ('WLVR', '웹메일', 'Outlook.com', '수신', 'I', 47, 'Y', ''),
       ('WLVS', '웹메일', 'Outlook.com', '발신', 'O', 48, 'Y', ''),
       ('WLVT', '웹메일', 'Outlook.com', '임시저장', 'O', 49, 'Y', ''),
       ('WQQR', '웹메일', 'QQ', '수신', 'I', 50, 'Y', ''),
       ('WQQS', '웹메일', 'QQ', '발신', 'O', 51, 'Y', ''),
       ('WQQB', '웹메일', 'QQ', '예약메일', 'O', 52, 'Y', ''),
       ('WQQT', '웹메일', 'QQ', '임시저장', 'O', 53, 'Y', ''),
       ('WOSR', '웹메일', '163', '수신', 'I', 54, 'Y', ''),
       ('WOSS', '웹메일', '163', '발신', 'O', 55, 'Y', ''),
       ('WOSB', '웹메일', '163', '예약메일', 'O', 56, 'Y', ''),
       ('WOST', '웹메일', '163', '임시저장', 'O', 57, 'Y', ''),
       ('WBMR', '웹메일', 'KT비즈메카', '수신', 'I', 58, 'Y', ''),
       ('WBMS', '웹메일', 'KT비즈메카', '발신', 'O', 59, 'Y', ''),
       ('WBMT', '웹메일', 'KT비즈메카', '임시저장', 'O', 60, 'Y', ''),
       ('WOTR', '웹메일', '126', '수신', 'I', 61, 'Y', ''),
       ('WOTS', '웹메일', '126', '발신', 'O', 62, 'Y', ''),
       ('WOTB', '웹메일', '126', '예약메일', 'O', 63, 'Y', ''),
       ('WOTT', '웹메일', '126', '임시저장', 'O', 64, 'Y', ''),
       ('WICR', '웹메일', 'Icloud', '수신', 'I', 65, 'Y', ''),
       ('WICS', '웹메일', 'Icloud', '발신', 'O', 66, 'Y', ''),
       ('WICT', '웹메일', 'Icloud', '임시저장', 'O', 67, 'Y', ''),
       ('WKAR', '웹메일', '카카오메일', '수신', 'I', 68, 'Y', ''),
       ('WKAS', '웹메일', '카카오메일', '발신', 'O', 69, 'Y', ''),
       ('WKAT', '웹메일', '카카오메일', '임시저장', 'O', 70, 'Y', ''),
       ('WYDR', '웹메일', 'Yandex', '수신', 'I', 71, 'Y', ''),
       ('WYDS', '웹메일', 'Yandex', '발신', 'O', 72, 'Y', ''),
       ('WYDT', '웹메일', 'Yandex', '임시저장', 'O', 73, 'Y', ''),
       ('WDOR', '웹메일', 'Dooray', '수신', 'I', 74, 'Y', ''),
       ('WDOS', '웹메일', 'Dooray', '발신', 'O', 75, 'Y', ''),
       ('WDOT', '웹메일', 'Dooray', '임시저장', 'O', 76, 'Y', ''),
       ('WZHS', '웹메일', 'Zoho 메일', '발신', 'O', 77, 'Y', ''),
       ('WUKR', '웹메일', '기타', '수신', 'I', 78, 'Y', ''),
       ('WUKS', '웹메일', '기타', '발신', 'O', 79, 'Y', ''),
       ('CNVR', '커뮤니티', '네이버 카페', '수신', 'I', 80, 'Y', ''),
       ('CNVS', '커뮤니티', '네이버 카페', '발신', 'O', 81, 'Y', ''),
       ('CNVD', '커뮤니티', '네이버 카페', '댓글', 'O', 82, 'Y', ''),
       ('CNVT', '커뮤니티', '네이버 카페', '임시저장', 'O', 83, 'Y', ''),
       ('CDUR', '커뮤니티', '다음 카페', '수신', 'I', 84, 'Y', ''),
       ('CDUS', '커뮤니티', '다음 카페', '발신', 'O', 85, 'Y', ''),
       ('CDUD', '커뮤니티', '다음 카페', '댓글', 'O', 86, 'Y', ''),
       ('CDUT', '커뮤니티', '다음 카페', '임시저장', 'O', 87, 'Y', ''),
       ('CPPR', '커뮤니티', '뽐뿌 커뮤니케이션', '수신', 'I', 88, 'Y', ''),
       ('CPPS', '커뮤니티', '뽐뿌 커뮤니케이션', '발신', 'O', 89, 'Y', ''),
       ('CPPD', '커뮤니티', '뽐뿌 커뮤니케이션', '댓글', 'O', 90, 'Y', ''),
       ('CCIR', '커뮤니티', '클리앙', '수신', 'I', 91, 'Y', ''),
       ('CCIS', '커뮤니티', '클리앙', '발신', 'O', 92, 'Y', ''),
       ('CCID', '커뮤니티', '클리앙', '댓글', 'O', 93, 'Y', ''),
       ('CDCR', '커뮤니티', '디시인사이드', '수신', 'I', 94, 'Y', ''),
       ('CDCS', '커뮤니티', '디시인사이드', '발신', 'O', 95, 'Y', ''),
       ('CDCD', '커뮤니티', '디시인사이드', '댓글', 'O', 96, 'Y', ''),
       ('CRWR', '커뮤니티', '루리웹', '수신', 'I', 97, 'Y', ''),
       ('CRWS', '커뮤니티', '루리웹', '발신', 'O', 98, 'Y', ''),
       ('CRWD', '커뮤니티', '루리웹', '댓글', 'O', 99, 'Y', ''),
       ('CMLR', '커뮤니티', 'Menlosecurity', '수신', 'I', 100, 'Y', ''),
       ('CMLS', '커뮤니티', 'Menlosecurity', '발신', 'O', 101, 'Y', ''),
       ('CMLD', '커뮤니티', 'Menlosecurity', '댓글', 'O', 102, 'Y', ''),
       ('CMLE', '커뮤니티', 'Menlosecurity', '기타', 'O', 103, 'Y', ''),
       ('CBDS', '커뮤니티', '블라인드', '발신', 'O', 104, 'Y', ''),
       ('CUKR', '커뮤니티', '기타', '수신', 'I', 105, 'Y', ''),
       ('CUKS', '커뮤니티', '기타', '발신', 'O', 106, 'Y', ''),
       ('CUKD', '커뮤니티', '기타', '댓글', 'O', 107, 'Y', ''),
       ('SFBR', '소셜', '페이스북', '수신', 'I', 108, 'Y', ''),
       ('SFBS', '소셜', '페이스북', '발신', 'O', 109, 'Y', ''),
       ('SFBD', '소셜', '페이스북', '댓글', 'O', 110, 'Y', ''),
       ('STWR', '소셜', '트위터', '수신', 'I', 111, 'Y', ''),
       ('STWS', '소셜', '트위터', '발신', 'O', 112, 'Y', ''),
       ('STWD', '소셜', '트위터', '댓글', 'O', 113, 'Y', ''),
       ('SKAR', '소셜', '카카오스토리', '수신', 'I', 114, 'Y', ''),
       ('SKAS', '소셜', '카카오스토리', '발신', 'O', 115, 'Y', ''),
       ('SKAD', '소셜', '카카오스토리', '댓글', 'O', 116, 'Y', ''),
       ('SNVR', '소셜', '네이버 블로그', '수신', 'I', 117, 'Y', ''),
       ('SNVS', '소셜', '네이버 블로그', '발신', 'O', 118, 'Y', ''),
       ('SNVD', '소셜', '네이버 블로그', '댓글', 'O', 119, 'Y', ''),
       ('SNVT', '소셜', '네이버 블로그', '임시저장', 'O', 120, 'Y', ''),
       ('SNVU', '소셜', '네이버 블로그', '수정', 'O', 121, 'Y', ''),
       ('SDUR', '소셜', '다음 블로그', '수신', 'I', 122, 'Y', ''),
       ('SDUS', '소셜', '다음 블로그', '발신', 'O', 123, 'Y', ''),
       ('SDUD', '소셜', '다음 블로그', '댓글', 'O', 124, 'Y', ''),
       ('STSR', '소셜', '티스토리', '수신', 'I', 125, 'Y', ''),
       ('STSS', '소셜', '티스토리', '발신', 'O', 126, 'Y', ''),
       ('STSD', '소셜', '티스토리', '댓글', 'O', 127, 'Y', ''),
       ('STST', '소셜', '티스토리', '임시저장', 'O', 128, 'Y', ''),
       ('STBR', '소셜', '텀블러', '수신', 'I', 129, 'Y', ''),
       ('STBS', '소셜', '텀블러', '발신', 'O', 130, 'Y', ''),
       ('STBD', '소셜', '텀블러', '댓글', 'O', 131, 'Y', ''),
       ('SWBR', '소셜', '웨이보', '수신', 'I', 132, 'Y', ''),
       ('SWBS', '소셜', '웨이보', '발신', 'O', 133, 'Y', ''),
       ('SWBD', '소셜', '웨이보', '댓글', 'O', 134, 'Y', ''),
       ('SLKR', '소셜', '링크드인', '수신', 'I', 135, 'Y', ''),
       ('SLKS', '소셜', '링크드인', '발신', 'O', 136, 'Y', ''),
       ('SLKD', '소셜', '링크드인', '댓글', 'O', 137, 'Y', ''),
       ('SEGR', '소셜', '이글루', '수신', 'I', 138, 'Y', ''),
       ('SEGS', '소셜', '이글루', '발신', 'O', 139, 'Y', ''),
       ('SEGD', '소셜', '이글루', '댓글', 'O', 140, 'Y', ''),
       ('SYMR', '소셜', '야머', '수신', 'I', 141, 'Y', ''),
       ('SYMS', '소셜', '야머', '발신', 'O', 142, 'Y', ''),
       ('SYMD', '소셜', '야머', '댓글', 'O', 143, 'Y', ''),
       ('SYMF', '소셜', '야머', '파일전송', 'O', 144, 'Y', ''),
       ('SNBR', '소셜', '네이버 밴드', '수신', 'I', 145, 'Y', ''),
       ('SNBS', '소셜', '네이버 밴드', '발신', 'O', 146, 'Y', ''),
       ('SNBD', '소셜', '네이버 밴드', '댓글', 'O', 147, 'Y', ''),
       ('SLRR', '소셜', '라이브리', '수신', 'I', 148, 'Y', ''),
       ('SLRS', '소셜', '라이브리', '발신', 'O', 149, 'Y', ''),
       ('SLRD', '소셜', '라이브리', '댓글', 'O', 150, 'Y', ''),
       ('SMER', '소셜', 'Medium', '수신', 'I', 151, 'Y', ''),
       ('SMES', '소셜', 'Medium', '발신', 'O', 152, 'Y', ''),
       ('SMED', '소셜', 'Medium', '댓글', 'O', 153, 'Y', ''),
       ('SISR', '소셜', '인스타그램', '수신', 'I', 154, 'Y', ''),
       ('SISS', '소셜', '인스타그램', '발신', 'O', 155, 'Y', ''),
       ('SISD', '소셜', '인스타그램', '댓글', 'O', 156, 'Y', ''),
       ('SISF', '소셜', '인스타그램', '파일전송', 'O', 157, 'Y', ''),
       ('SSFS', '소셜', 'Salesforce', '발신', 'O', 158, 'Y', ''),
       ('VDUR', '영상 스트리밍', '다음 TV', '수신', 'I', 159, 'Y', ''),
       ('VDUS', '영상 스트리밍', '다음 TV', '발신', 'O', 160, 'Y', ''),
       ('VPDR', '영상 스트리밍', '판도라 TV', '수신', 'I', 161, 'Y', ''),
       ('VPDS', '영상 스트리밍', '판도라 TV', '발신', 'O', 162, 'Y', ''),
       ('VGMR', '영상 스트리밍', '곰 TV', '수신', 'I', 163, 'Y', ''),
       ('VGMS', '영상 스트리밍', '곰 TV', '발신', 'O', 164, 'Y', ''),
       ('VYTR', '영상 스트리밍', '유튜브', '수신', 'I', 165, 'Y', ''),
       ('VYTS', '영상 스트리밍', '유튜브', '발신', 'O', 166, 'Y', ''),
       ('VYTD', '영상 스트리밍', '유튜브', '댓글', 'O', 167, 'Y', ''),
       ('VNVR', '영상 스트리밍', '네이버 TV캐스트', '수신', 'I', 168, 'Y', ''),
       ('VNVS', '영상 스트리밍', '네이버 TV캐스트', '발신', 'O', 169, 'Y', ''),
       ('QNVC', '메신저', '네이버', '채팅', 'O', 170, 'N', ''),
       ('QNVF', '메신저', '네이버', '파일전송', 'O', 171, 'N', ''),
       ('QNMR', '메신저', '네이버 쪽지', '수신', 'I', 172, 'N', ''),
       ('QNMS', '메신저', '네이버 쪽지', '발신', 'O', 173, 'N', ''),
       ('QDUC', '메신저', '다음', '채팅', 'O', 174, 'N', ''),
       ('QDUF', '메신저', '다음', '파일전송', 'O', 175, 'N', ''),
       ('QDUM', '메신저', '다음', '쪽지', 'O', 176, 'N', ''),
       ('QDSC', '메신저', '대신', '채팅', 'O', 177, 'N', ''),
       ('QDSF', '메신저', '대신', '파일전송', 'O', 178, 'N', ''),
       ('QDSM', '메신저', '대신', '쪽지', 'O', 179, 'N', ''),
       ('QSHC', '메신저', '삼홍사', '채팅', 'O', 180, 'Y', ''),
       ('QSHF', '메신저', '삼홍사', '파일전송', 'O', 181, 'Y', ''),
       ('QSHM', '메신저', '삼홍사', '쪽지', 'O', 182, 'Y', ''),
       ('QDIC', '메신저', '동부생명', '채팅', 'O', 183, 'Y', ''),
       ('QDIF', '메신저', '동부생명', '파일전송', 'O', 184, 'Y', ''),
       ('QDIM', '메신저', '동부생명', '쪽지', 'O', 185, 'Y', ''),
       ('QDFC', '메신저', '동부금융', '채팅', 'O', 186, 'Y', ''),
       ('QDFF', '메신저', '동부금융', '파일전송', 'O', 187, 'Y', ''),
       ('QDFM', '메신저', '동부금융', '쪽지', 'O', 188, 'Y', ''),
       ('QDGC', '메신저', '동국제강', '채팅', 'O', 189, 'Y', ''),
       ('QDGF', '메신저', '동국제강', '파일전송', 'O', 190, 'Y', ''),
       ('QDGM', '메신저', '동국제강', '쪽지', 'O', 191, 'Y', ''),
       ('QFMC', '메신저', '프리본드', '채팅', 'O', 192, 'Y', 'MSG'),
       ('QFMF', '메신저', '프리본드', '파일전송', 'O', 193, 'Y', 'MSG'),
       ('QFMM', '메신저', '프리본드', '쪽지', 'O', 194, 'Y', 'MSG'),
       ('QFMJ', '메신저', '프리본드', '참여', 'O', 195, 'Y', 'MSG'),
       ('QFML', '메신저', '프리본드', '떠남', 'O', 196, 'Y', 'MSG'),
       ('QMCC', '메신저', 'M-채널', '채팅', 'O', 197, 'Y', ''),
       ('QMCF', '메신저', 'M-채널', '파일전송', 'O', 198, 'Y', ''),
       ('QMCM', '메신저', 'M-채널', '쪽지', 'O', 199, 'Y', ''),
       ('QMSC', '메신저', '미쓰리', '채팅', 'O', 200, 'Y', 'MSG'),
       ('QMSF', '메신저', '미쓰리', '파일전송', 'O', 201, 'Y', 'MSG'),
       ('QMSM', '메신저', '미쓰리', '쪽지', 'O', 202, 'Y', 'MSG'),
       ('QMSJ', '메신저', '미쓰리', '참여', 'O', 203, 'Y', 'MSG'),
       ('QMSL', '메신저', '미쓰리', '떠남', 'O', 204, 'Y', 'MSG'),
       ('QNTC', '메신저', '네이트', '채팅', 'O', 205, 'Y', 'MSG'),
       ('QNTF', '메신저', '네이트', '파일전송', 'O', 206, 'Y', 'MSG'),
       ('QNTM', '메신저', '네이트', '쪽지', 'O', 207, 'Y', 'MSG'),
       ('QNTJ', '메신저', '네이트', '참여', 'O', 208, 'Y', 'MSG'),
       ('QNTL', '메신저', '네이트', '떠남', 'O', 209, 'Y', 'MSG'),
       ('QSSC', '메신저', '삼성증권', '채팅', 'O', 210, 'N', ''),
       ('QSSF', '메신저', '삼성증권', '파일전송', 'O', 211, 'N', ''),
       ('QSSM', '메신저', '삼성증권', '쪽지', 'O', 212, 'N', ''),
       ('QSFC', '메신저', '삼성화재', '채팅', 'O', 213, 'Y', ''),
       ('QSFF', '메신저', '삼성화재', '파일전송', 'O', 214, 'Y', ''),
       ('QSFM', '메신저', '삼성화재', '쪽지', 'O', 215, 'Y', ''),
       ('QSFJ', '메신저', '삼성화재', '참여', 'O', 216, 'Y', ''),
       ('QSFL', '메신저', '삼성화재', '떠남', 'O', 217, 'Y', ''),
       ('QSPC', '메신저', 'SK 프라이든', '채팅', 'O', 218, 'Y', ''),
       ('QSPF', '메신저', 'SK 프라이든', '파일전송', 'O', 219, 'Y', ''),
       ('QSPM', '메신저', 'SK 프라이든', '쪽지', 'O', 220, 'Y', ''),
       ('QSPJ', '메신저', 'SK 프라이든', '참여', 'O', 221, 'Y', ''),
       ('QSPL', '메신저', 'SK 프라이든', '떠남', 'O', 222, 'Y', ''),
       ('QSBC', '메신저', 'SK 비즈', '채팅', 'O', 223, 'N', ''),
       ('QSBF', '메신저', 'SK 비즈', '파일전송', 'O', 224, 'N', ''),
       ('QSBM', '메신저', 'SK 비즈', '쪽지', 'O', 225, 'N', ''),
       ('QWJC', '메신저', '웅진', '채팅', 'O', 226, 'Y', ''),
       ('QWJF', '메신저', '웅진', '파일전송', 'O', 227, 'Y', ''),
       ('QWJM', '메신저', '웅진', '쪽지', 'O', 228, 'Y', ''),
       ('QGPC', '메신저', 'ChatGPT', '채팅', 'O', 229, 'Y', ''),
       ('QDAC', '메신저', 'Dall-E', '채팅', 'O', 230, 'Y', ''),
       ('QDAF', '메신저', 'Dall-E', '파일전송', 'O', 231, 'Y', ''),
       ('QCLC', '메신저', '쿨', '채팅', 'O', 232, 'Y', 'MSG'),
       ('QCLF', '메신저', '쿨', '파일전송', 'O', 233, 'Y', 'MSG'),
       ('QCLM', '메신저', '쿨', '쪽지', 'O', 234, 'Y', 'MSG'),
       ('QCLJ', '메신저', '쿨', '참여', 'O', 235, 'Y', 'MSG'),
       ('QCLL', '메신저', '쿨', '떠남', 'O', 236, 'Y', 'MSG'),
       ('QKBC', '메신저', 'K-bond', '채팅', 'O', 237, 'Y', 'MSG'),
       ('QKBF', '메신저', 'K-bond', '파일전송', 'O', 238, 'Y', 'MSG'),
       ('QKBM', '메신저', 'K-bond', '쪽지', 'O', 239, 'Y', 'MSG'),
       ('QKBJ', '메신저', 'K-bond', '참여', 'O', 240, 'Y', 'MSG'),
       ('QKBL', '메신저', 'K-bond', '떠남', 'O', 241, 'Y', 'MSG'),
       ('QEKC', '메신저', '아이콘', '채팅', 'O', 242, 'Y', 'MSG'),
       ('QEKF', '메신저', '아이콘', '파일전송', 'O', 243, 'Y', 'MSG'),
       ('QEKJ', '메신저', '아이콘', '참여', 'O', 244, 'Y', 'MSG'),
       ('QEKL', '메신저', '아이콘', '떠남', 'O', 245, 'Y', 'MSG'),
       ('QEKH', '메신저', '아이콘', '과거 데이터', 'O', 246, 'Y', 'MSG'),
       ('QSLC', '메신저', 'Slack', '채팅', 'O', 247, 'Y', 'MSG'),
       ('QSLF', '메신저', 'Slack', '파일전송', 'O', 248, 'Y', 'MSG'),
       ('QSLJ', '메신저', 'Slack', '참여', 'O', 249, 'Y', 'MSG'),
       ('QSLL', '메신저', 'Slack', '떠남', 'O', 250, 'Y', 'MSG'),
       ('QSYC', '메신저', '신영자산운용', '채팅', 'O', 251, 'Y', 'MSG'),
       ('QSYF', '메신저', '신영자산운용', '파일전송', 'O', 252, 'Y', 'MSG'),
       ('QSYM', '메신저', '신영자산운용', '쪽지', 'O', 253, 'Y', 'MSG'),
       ('QSYJ', '메신저', '신영자산운용', '참여', 'O', 254, 'Y', 'MSG'),
       ('QSYL', '메신저', '신영자산운용', '떠남', 'O', 255, 'Y', 'MSG'),
       ('QFBC', '메신저', '페이스북', '채팅', 'O', 256, 'Y', 'MSG'),
       ('QFBF', '메신저', '페이스북', '파일전송', 'O', 257, 'Y', 'MSG'),
       ('QKMC', '메신저', '삼성KnoxMessenger', '채팅', 'O', 258, 'Y', 'MSG'),
       ('QKMF', '메신저', '삼성KnoxMessenger', '파일전송', 'O', 259, 'Y', 'MSG'),
       ('QKMR', '메신저', '삼성KnoxMessenger', '파일수신', 'I', 260, 'Y', 'MSG'),
       ('QKMW', '메신저', '삼성KnoxMessenger', '전달', 'O', 261, 'Y', 'MSG'),
       ('QKMV', '메신저', '삼성KnoxMessenger', '파일-미리보기', 'O', 262, 'Y', 'MSG'),
       ('QGHC', '메신저', '구글 Hangout', '채팅', 'O', 263, 'Y', 'MSG'),
       ('QGHF', '메신저', '구글 Hangout', '파일전송', 'O', 264, 'Y', 'MSG'),
       ('QGGC', '메신저', '구글 chat', '채팅', 'O', 265, 'Y', 'MSG'),
       ('QGGF', '메신저', '구글 chat', '파일전송', 'O', 266, 'Y', 'MSG'),
       ('QGMC', '메신저', '구글 Meet', '채팅', 'O', 267, 'Y', 'MSG'),
       ('QGBC', '메신저', '구글 Bard', '채팅', 'O', 268, 'Y', 'MSG'),
       ('QBIC', '메신저', 'Microsoft BingAI Chat', '채팅', 'O', 269, 'Y', 'MSG'),
       ('QWTC', '메신저', 'Wrtn', '채팅', 'O', 270, 'Y', ''),
       ('QISC', '메신저', '인스타그램 DM', '채팅', 'O', 271, 'Y', 'MSG'),
       ('QISF', '메신저', '인스타그램 DM', '파일전송', 'O', 272, 'Y', 'MSG'),
       ('QZAC', '메신저', 'Zalo', '채팅', 'O', 273, 'Y', 'MSG'),
       ('QZAF', '메신저', 'Zalo', '파일전송', 'O', 274, 'Y', 'MSG'),
       ('QNBC', '메신저', '네이버 밴드 채팅', '채팅', 'O', 275, 'Y', 'MSG'),
       ('QNBF', '메신저', '네이버 밴드 채팅', '파일전송', 'O', 276, 'Y', 'MSG'),
       ('QDOC', '메신저', 'Dooray app', '채팅', 'O', 277, 'Y', 'MSG'),
       ('QDOF', '메신저', 'Dooray app', '파일전송', 'O', 278, 'Y', 'MSG'),
       ('QUKC', '메신저', '기타', '채팅', 'O', 279, 'Y', 'MSG'),
       ('QUKF', '메신저', '기타', '파일전송', 'O', 280, 'Y', 'MSG'),
       ('QUKM', '메신저', '기타', '쪽지', 'O', 281, 'Y', 'MSG'),
       ('QUKJ', '메신저', '기타', '참여', 'O', 282, 'Y', 'MSG'),
       ('QUKL', '메신저', '기타', '떠남', 'O', 283, 'Y', 'MSG'),
       ('FFTC', '파일전송', 'FTP', 'CMD', 'O', 284, 'Y', ''),
       ('FFTG', '파일전송', 'FTP', 'GET', 'I', 285, 'Y', ''),
       ('FFTP', '파일전송', 'FTP', 'PUT', 'O', 286, 'Y', ''),
       ('FFTL', '파일전송', 'FTP', 'CONNECT', 'O', 287, 'Y', ''),
       ('FZM-', '파일전송', 'Zmodem', '-', 'O', 288, 'Y', ''),
       ('FNVR', '파일전송', '네이버 MYBOX', '수신', 'I', 289, 'Y', ''),
       ('FNVS', '파일전송', '네이버 MYBOX', '발신', 'O', 290, 'Y', ''),
       ('FGGR', '파일전송', '구글 드라이브', '수신', 'I', 291, 'Y', ''),
       ('FGGS', '파일전송', '구글 드라이브', '발신', 'O', 292, 'Y', ''),
       ('FODR', '파일전송', 'OneDrive', '수신', 'I', 293, 'Y', ''),
       ('FODS', '파일전송', 'OneDrive', '발신', 'O', 294, 'Y', ''),
       ('FDBR', '파일전송', 'Dropbox', '수신', 'I', 295, 'Y', ''),
       ('FDBS', '파일전송', 'Dropbox', '발신', 'O', 296, 'Y', ''),
       ('F2NR', '파일전송', '2nd 드라이브', '수신', 'I', 297, 'N', ''),
       ('F2NS', '파일전송', '2nd 드라이브', '발신', 'O', 298, 'N', ''),
       ('FPSR', '파일전송', 'Polarisoffice ', '수신', 'I', 299, 'Y', ''),
       ('FPSS', '파일전송', 'Polarisoffice ', '발신', 'O', 300, 'Y', ''),
       ('FICR', '파일전송', 'Icloud', '수신', 'I', 301, 'Y', ''),
       ('FICS', '파일전송', 'Icloud', '발신', 'O', 302, 'Y', ''),
       ('FYDR', '파일전송', 'Yandex', '수신', 'I', 303, 'Y', ''),
       ('FYDS', '파일전송', 'Yandex', '발신', 'O', 304, 'Y', ''),
       ('FWHR', '파일전송', 'LG 웹하드', '수신', 'I', 305, 'Y', ''),
       ('FWHS', '파일전송', 'LG 웹하드', '발신', 'O', 306, 'Y', ''),
       ('FGIR', '파일전송', 'GitHub', '수신', 'I', 307, 'Y', ''),
       ('FGIS', '파일전송', 'GitHub', '발신', 'O', 308, 'Y', ''),
       ('FDOR', '파일전송', 'Dooray', '수신', 'I', 309, 'Y', ''),
       ('FDOS', '파일전송', 'Dooray', '발신', 'O', 310, 'Y', ''),
       ('FWES', '파일전송', 'Wetransfer', '발신', 'O', 311, 'Y', ''),
       ('FASS', '파일전송', 'AWS S3 bucket', '발신', 'O', 312, 'Y', ''),
       ('FGES', '파일전송', '구글 렌즈', '발신', 'O', 313, 'Y', ''),
       ('FTRS', '파일전송', 'File Transfer.io', '발신', 'O', 314, 'Y', ''),
       ('FCLS', '파일전송', 'pCloud Transfer', '발신', 'O', 315, 'Y', ''),
       ('FUKR', '파일전송', '기타', '수신', 'I', 316, 'Y', ''),
       ('FUKS', '파일전송', '기타', '발신', 'O', 317, 'Y', ''),
       ('NENR', '노트', 'EVERNOTE', '수신', 'I', 318, 'Y', ''),
       ('NENS', '노트', 'EVERNOTE', '발신', 'O', 319, 'Y', ''),
       ('NONR', '노트', 'ONENOTE', '수신', 'I', 320, 'Y', ''),
       ('NONS', '노트', 'ONENOTE', '발신', 'O', 321, 'Y', ''),
       ('NLVS', '노트', 'Outlook.com 메모', '발신', 'O', 322, 'Y', ''),
       ('NBTS', '노트', 'BIT.AI', '발신', 'O', 323, 'Y', ''),
       ('NNOS', '노트', 'Notion', '발신', 'O', 324, 'Y', ''),
       ('NGGS', '노트', '구글 docs', '발신', 'O', 325, 'Y', ''),
       ('NGTS', '노트', '구글 tasks', '발신', 'O', 326, 'Y', ''),
       ('NGKS', '노트', '구글 keep', '발신', 'O', 327, 'Y', ''),
       ('NSSR', '노트', '삼성 노트', '수신', 'I', 328, 'Y', ''),
       ('NSSS', '노트', '삼성 노트', '발신', 'O', 329, 'Y', ''),
       ('NNVS', '노트', '네이버 오피스', '발신', 'O', 330, 'Y', ''),
       ('NDBS', '노트', 'Dropbox paper', '발신', 'O', 331, 'Y', ''),
       ('NHCS', '노트', '한컴 오피스', '발신', 'O', 332, 'Y', ''),
       ('NMOS', '노트', 'MS오피스', '발신', 'O', 333, 'Y', ''),
       ('NCDS', '노트', 'Coda', '발신', 'O', 334, 'Y', ''),
       ('NNMR', '노트', '네이버 메모', '수신', 'I', 335, 'Y', ''),
       ('NNMS', '노트', '네이버 메모', '발신', 'O', 336, 'Y', ''),
       ('NCNS', '노트', 'Clova Note', '발신', 'O', 337, 'Y', ''),
       ('NGIS', '노트', 'Github Gist', '발신', 'O', 338, 'Y', ''),
       ('NSNS', '노트', 'SimpleNote', '발신', 'O', 339, 'Y', ''),
       ('NAGS', '노트', 'Agit', '발신', 'O', 340, 'Y', ''),
       ('NPSS', '노트', 'Polaris office', '발신', 'O', 341, 'Y', ''),
       ('NBOS', '노트', 'Box', '발신', 'O', 342, 'Y', ''),
       ('NCKS', '노트', 'ClickUp', '발신', 'O', 343, 'Y', ''),
       ('NGNS', '노트', 'Goodnotes', '발신', 'O', 344, 'Y', ''),
       ('NMNS', '노트', 'Milanote', '발신', 'O', 345, 'Y', ''),
       ('NZQS', '노트', 'zohocliq', '발신', 'O', 346, 'Y', ''),
       ('NUKS', '노트', '기타', '발신', 'O', 347, 'Y', ''),
       ('AGCR', '일정', '구글캘린더일정', '수신', 'I', 348, 'N', ''),
       ('AGCS', '일정', '구글캘린더일정', '발신', 'O', 349, 'Y', ''),
       ('AGLR', '일정', '구글캘린더메일', '수신', 'I', 350, 'N', ''),
       ('AGLS', '일정', '구글캘린더메일', '발신', 'O', 351, 'Y', ''),
       ('ANCS', '일정', '네이버 캘린더', '발신', 'O', 352, 'Y', ''),
       ('ZTN-', '기타 서비스', 'Telnet', '-', 'O', 353, 'Y', ''),
       ('ZXT-', '기타 서비스', 'Xterm', '-', 'O', 354, 'Y', ''),
       ('ZRL-', '기타 서비스', 'R-Login', '-', 'O', 355, 'Y', ''),
       ('ZNP-', '기타 서비스', 'NNTP', '-', 'O', 356, 'Y', ''),
       ('ZPC-', '기타 서비스', 'PC 보안', '-', 'O', 357, 'N', ''),
       ('ZSH-', '기타 서비스', 'SSH', 'SSH 세션 정보', 'O', 358, 'Y', ''),
       ('XX1R', '모니터링_제외', '미분류_타입1', '수신', 'I', 359, 'Y', ''),
       ('XX1S', '모니터링_제외', '미분류_타입1', '발신', 'O', 360, 'Y', ''),
       ('XX2R', '모니터링_제외', '미분류_타입2', '수신', 'I', 361, 'Y', ''),
       ('XX2S', '모니터링_제외', '미분류_타입2', '발신', 'O', 362, 'Y', ''),
       ('XX3R', '모니터링_제외', '미분류_타입3', '수신', 'I', 363, 'Y', ''),
       ('XX3S', '모니터링_제외', '미분류_타입3', '발신', 'O', 364, 'Y', ''),
       ('XU1R', '모니터링_제외', '웹서비스(미분류)_타입1', '수신', 'I', 365, 'Y', ''),
       ('XU1S', '모니터링_제외', '웹서비스(미분류)_타입1', '발신', 'O', 366, 'Y', ''),
       ('XU2R', '모니터링_제외', '웹서비스(미분류)_타입2', '수신', 'I', 367, 'Y', ''),
       ('XU2S', '모니터링_제외', '웹서비스(미분류)_타입2', '발신', 'O', 368, 'Y', ''),
       ('XU3R', '모니터링_제외', '웹서비스(미분류)_타입3', '수신', 'I', 369, 'Y', ''),
       ('XU3S', '모니터링_제외', '웹서비스(미분류)_타입3', '발신', 'O', 370, 'Y', ''),
       ('UWSD', '웹서비스(미분류)', '웹 발신', '첨부 - 문서타입', 'O', 371, 'Y', ''),
       ('UWSE', '웹서비스(미분류)', '웹 발신', '첨부 - 문서아님', 'O', 372, 'Y', ''),
       ('UWSU', '웹서비스(미분류)', '웹 발신', '첨부 없음', 'O', 373, 'Y', ''),
       ('UWSH', '웹서비스(미분류)', '웹 발신', '중요도(상)', 'O', 374, 'Y', ''),
       ('UWSM', '웹서비스(미분류)', '웹 발신', '중요도(중)', 'O', 375, 'Y', ''),
       ('UWSL', '웹서비스(미분류)', '웹 발신', '중요도(하)', 'O', 376, 'Y', ''),
       ('UX1R', '웹서비스(미분류)', '미분류_타입1', '수신', 'I', 377, 'Y', ''),
       ('UX1S', '웹서비스(미분류)', '미분류_타입1', '발신', 'O', 378, 'Y', ''),
       ('UX2R', '웹서비스(미분류)', '미분류_타입2', '수신', 'I', 379, 'Y', ''),
       ('UX2S', '웹서비스(미분류)', '미분류_타입2', '발신', 'O', 380, 'Y', ''),
       ('UX3R', '웹서비스(미분류)', '미분류_타입3', '수신', 'I', 381, 'Y', ''),
       ('UX3S', '웹서비스(미분류)', '미분류_타입3', '발신', 'O', 382, 'Y', ''),
       ('UWRD', '웹서비스(미분류)', '웹 수신', '첨부 - 문서타입', 'I', 383, 'Y', ''),
       ('UWRE', '웹서비스(미분류)', '웹 수신', '첨부 - 문서아님', 'I', 384, 'Y', ''),
       ('UWRU', '웹서비스(미분류)', '웹 수신', '첨부 없음', 'I', 385, 'Y', ''),
       ('BWSD', '웹서비스(업무)', '업무 발신', '첨부 - 문서타입', 'O', 386, 'Y', ''),
       ('BWSE', '웹서비스(업무)', '업무 발신', '첨부 - 문서아님', 'O', 387, 'Y', ''),
       ('BWSU', '웹서비스(업무)', '업무 발신', '첨부 없음', 'O', 388, 'Y', ''),
       ('BWRD', '웹서비스(업무)', '업무 수신', '첨부 - 문서타입', 'I', 389, 'Y', ''),
       ('BWRE', '웹서비스(업무)', '업무 수신', '첨부 - 문서아님', 'I', 390, 'Y', ''),
       ('BWRU', '웹서비스(업무)', '업무 수신', '첨부 없음', 'I', 391, 'Y', ''),
       ('TWEC', '화상회의', 'Webex', '채팅', 'O', 392, 'Y', 'MSG'),
       ('TWEF', '화상회의', 'Webex', '파일전송', 'O', 393, 'Y', 'MSG'),
       ('TWEJ', '화상회의', 'Webex', '참여', 'O', 394, 'Y', 'MSG'),
       ('TWEL', '화상회의', 'Webex', '떠남', 'O', 395, 'Y', 'MSG'),
       ('TZOC', '화상회의', 'Zoom', '채팅', 'O', 396, 'Y', 'MSG'),
       ('TZOF', '화상회의', 'Zoom', '파일전송', 'O', 397, 'Y', 'MSG'),
       ('TZOJ', '화상회의', 'Zoom', '참여', 'O', 398, 'Y', 'MSG'),
       ('TZOL', '화상회의', 'Zoom', '떠남', 'O', 399, 'Y', 'MSG'),
       ('TTMC', '화상회의', 'Teams', '채팅', 'O', 400, 'Y', 'MSG'),
       ('TTMF', '화상회의', 'Teams', '파일전송', 'O', 401, 'Y', 'MSG'),
       ('TTMJ', '화상회의', 'Teams', '참여', 'O', 402, 'Y', 'MSG'),
       ('TTML', '화상회의', 'Teams', '떠남', 'O', 403, 'Y', 'MSG'),
       ('TSKC', '화상회의', 'Skype', '채팅', 'O', 404, 'Y', 'MSG'),
       ('TSKF', '화상회의', 'Skype', '파일전송', 'O', 405, 'Y', 'MSG'),
       ('TSKJ', '화상회의', 'Skype', '참여', 'O', 406, 'Y', 'MSG'),
       ('TSKL', '화상회의', 'Skype', '떠남', 'O', 407, 'Y', 'MSG'),
       ('TJMC', '화상회의', 'JoinME', '채팅', 'O', 408, 'Y', 'MSG'),
       ('TJMF', '화상회의', 'JoinME', '파일전송', 'O', 409, 'Y', 'MSG'),
       ('TAMC', '화상회의', 'Amazon Chime', '채팅', 'O', 410, 'Y', 'MSG'),
       ('TAMF', '화상회의', 'Amazon Chime', '파일전송', 'O', 411, 'Y', 'MSG'),
       ('TBJC', '화상회의', 'BlueJeans', '채팅', 'O', 412, 'Y', 'MSG'),
       ('TTDS', '화상회의', 'Tl;dv', '채팅', 'O', 413, 'Y', 'MSG'),
       ('LNVS', '번역기', '파파고 번역', '발신', 'O', 414, 'Y', ''),
       ('LGGS', '번역기', '구글 번역', '발신', 'O', 415, 'Y', ''),
       ('LGPS', '번역기', '구글 번역 플러그인', '발신', 'O', 416, 'Y', ''),
       ('LDES', '번역기', 'Deepl', '발신', 'O', 417, 'Y', ''),
       ('LBIS', '번역기', 'Bing 번역', '발신', 'O', 418, 'Y', ''),
       ('LYMS', '번역기', 'Yandex 번역', '발신', 'O', 419, 'Y', ''),
       ('LUKS', '번역기', '기타', '발신', 'I', 420, 'Y', ''),
       ('IGBS', '생성형 AI', '구글 Gemini', '발신', 'O', 421, 'Y', ''),
       ('IBIS', '생성형 AI', ' Microsoft Copilot', '발신', 'O', 422, 'Y', ''),
       ('IWTS', '생성형 AI', 'Wrtn', '발신', 'O', 423, 'Y', ''),
       ('IGPS', '생성형 AI', 'ChatGPT', '발신', 'O', 424, 'Y', ''),
       ('IDAS', '생성형 AI', 'Dall-E', '발신', 'O', 425, 'Y', ''),
       ('IGCS', '생성형 AI', 'Github Copilot', '발신', 'I', 426, 'Y', ''),
       ('IYCS', '생성형 AI', 'YouChat', '발신', 'I', 427, 'Y', ''),
       ('ICSS', '생성형 AI', 'Chatsonic', '발신', 'I', 428, 'Y', ''),
       ('IRPS', '생성형 AI', 'Replika', '발신', 'I', 429, 'Y', ''),
       ('IPPS', '생성형 AI', 'Perplexity', '발신', 'I', 430, 'Y', ''),
       ('ITCS', '생성형 AI', 'TextCortex', '발신', 'I', 431, 'Y', ''),
       ('IPHS', '생성형 AI', 'Phind', '발신', 'I', 432, 'Y', ''),
       ('IPOS', '생성형 AI', 'Poe', '발신', 'I', 433, 'Y', ''),
       ('IHFS', '생성형 AI', 'Hugging Face', '발신', 'I', 434, 'Y', ''),
       ('ICPS', '생성형 AI', 'Copy.AI', '발신', 'I', 435, 'Y', ''),
       ('IHWS', '생성형 AI', 'HyperWrite', '발신', 'I', 436, 'Y', ''),
       ('IDPS', '생성형 AI', 'DeepAI', '발신', 'I', 437, 'Y', ''),
       ('IACS', '생성형 AI', 'AskCodi', '발신', 'I', 438, 'Y', ''),
       ('INAS', '생성형 AI', 'Native', '발신', 'I', 439, 'Y', ''),
       ('INFS', '생성형 AI', 'NeuroFlash', '발신', 'I', 440, 'Y', ''),
       ('INOS', '생성형 AI', 'Notion AI', '발신', 'I', 441, 'Y', ''),
       ('IMES', '생성형 AI', 'Merlin', '발신', 'I', 442, 'Y', ''),
       ('ICXS', '생성형 AI', 'CLOVA-X', '발신', 'I', 443, 'Y', ''),
       ('IADS', '생성형 AI', 'Adobe AI', '발신', 'I', 444, 'Y', ''),
       ('ICDS', '생성형 AI', 'ClipDrop', '발신', 'I', 445, 'Y', ''),
       ('ISBS', '생성형 AI', 'Stability.Ai', '발신', 'I', 446, 'Y', ''),
       ('IRMS', '생성형 AI', 'Runwayml', '발신', 'I', 447, 'Y', ''),
       ('IGVS', '생성형 AI', 'Google Vertex', '발신', 'I', 448, 'Y', ''),
       ('IGLS', '생성형 AI', 'Google Colab', '발신', 'I', 449, 'Y', ''),
       ('ICWS', '생성형 AI', 'CodeWhisperer', '발신', 'I', 450, 'Y', ''),
       ('IMSS', '생성형 AI', 'MakerSuite', '발신', 'I', 451, 'Y', ''),
       ('IOCS', '생성형 AI', 'Clova OCR', '발신', 'I', 452, 'Y', ''),
       ('IAOS', '생성형 AI', 'Azure OpenAI', '발신', 'I', 453, 'Y', ''),
       ('ICUS', '생성형 AI', '네이버 CUE:', '발신', 'I', 454, 'Y', ''),
       ('IMJS', '생성형 AI', 'Midjourney', '발신', 'I', 455, 'Y', ''),
       ('ISGR', '생성형 AI', 'slidesGPT', '수신', 'I', 456, 'Y', ''),
       ('ISGS', '생성형 AI', 'SlidesGPT', '발신', 'I', 457, 'Y', ''),
       ('IDMS', '생성형 AI', 'AiDocmaker', '발신', 'I', 458, 'Y', ''),
       ('IRKS', '생성형 AI', 'Reka AI', '발신', 'I', 459, 'Y', ''),
       ('ICLS', '생성형 AI', 'Claude', '발신', 'I', 460, 'Y', ''),
       ('IDMR', '생성형 AI', 'Ai Docker Attach', '수신', 'I', 461, 'Y', ''),
       ('IADR', '생성형 AI', 'Adobe firefly login', '수신', 'I', 462, 'Y', ''),
       ('IWDS', '생성형 AI', 'Dream by WOMBO', '발신', 'I', 463, 'Y', ''),
       ('IGAS', '생성형 AI', 'GetImg.AI', '발신', 'I', 464, 'Y', ''),
       ('IWKS', '생성형 AI', 'Wrks.ai', '발신', 'I', 465, 'Y', ''),
       ('IPSS', '생성형 AI', 'Polaris office ai', '발신', 'I', 466, 'Y', ''),
       ('IBGS', '생성형 AI', 'Goover AI', '발신', 'I', 467, 'Y', ''),
       ('IIAS', '생성형 AI', 'iAsk AI', '발신', 'I', 468, 'Y', ''),
       ('ISNS', '생성형 AI', 'Suno AI', '발신', 'I', 469, 'Y', ''),
       ('IPES', '생성형 AI', 'Perchance', '발신', 'I', 470, 'Y', ''),
       ('IPFS', '생성형 AI', 'ChatPDF', '발신', 'I', 471, 'Y', ''),
       ('IXOS', '생성형 AI', 'Exaone', '발신', 'I', 472, 'Y', ''),
       ('ISOR', '생성형 AI', 'Slidesgo', '수신', 'I', 473, 'Y', ''),
       ('ISOS', '생성형 AI', 'Slidesgo', '발신', 'I', 474, 'Y', ''),
       ('IKRS', '생성형 AI', 'KREA', '발신', 'I', 475, 'Y', ''),
       ('ILMS', '생성형 AI', 'GoogleNotebook LM', '발신', 'I', 476, 'Y', ''),
       ('ICCS', '생성형 AI', 'Capcut', '발신', 'I', 477, 'Y', ''),
       ('IMGS', '생성형 AI', 'Magictool', '발신', 'I', 478, 'Y', ''),
       ('IGSS', '생성형 AI', 'Genspark', '발신', 'I', 479, 'Y', ''),
       ('IFES', '생성형 AI', 'felo', '발신', 'I', 480, 'Y', ''),
       ('ITPS', '생성형 AI', 'Tripo3D', '발신', 'I', 481, 'Y', ''),
       ('ITPR', '생성형 AI', 'Tripo3D', '수신', 'I', 482, 'Y', ''),
       ('IELS', '생성형 AI', 'Elevenlabs', '발신', 'I', 483, 'Y', ''),
       ('IELR', '생성형 AI', 'Elevenlabs', '수신', 'I', 484, 'Y', ''),
       ('IGRS', '생성형 AI', 'Grammarly', '발신', 'I', 485, 'Y', ''),
       ('IVRS', '생성형 AI', 'Vrew', '발신', 'I', 486, 'Y', ''),
       ('IUKS', '생성형 AI', '기타', '발신', 'I', 487, 'Y', ''),
       ('PDOS', '프로젝트', 'dooray', '발신', 'O', 488, 'Y', ''),
       ('PGIS', '프로젝트', 'github', '발신', 'O', 489, 'Y', ''),
       ('PGLS', '프로젝트', 'Glassdoor', '발신', 'O', 490, 'Y', ''),
       ('EBDR', '그룹웨어', '게시', '수신', 'I', 491, 'Y', ''),
       ('EBD-', '그룹웨어', '게시', '발신', 'O', 492, 'Y', ''),
       ('EBBR', '그룹웨어', '게시판', '수신', 'I', 493, 'Y', ''),
       ('EBBS', '그룹웨어', '게시판', '발신', 'O', 494, 'Y', ''),
       ('EBBF', '그룹웨어', '게시판', '파일수신', 'I', 495, 'Y', ''),
       ('EAAR', '그룹웨어', '결재', '수신', 'I', 496, 'Y', ''),
       ('EAAS', '그룹웨어', '결재', '발신', 'O', 497, 'Y', ''),
       ('EAAG', '그룹웨어', '결재', '통보 - 수신', 'I', 498, 'Y', ''),
       ('EAAP', '그룹웨어', '결재', '통보 - 발신', 'O', 499, 'Y', ''),
       ('EAAF', '그룹웨어', '결재', '파일수신', 'I', 500, 'Y', ''),
       ('EMMR', '그룹웨어', '메일', '그룹웨어 수신', 'I', 501, 'Y', ''),
       ('EMMS', '그룹웨어', '메일', '그룹웨어 발신', 'O', 502, 'Y', ''),
       ('EMMG', '그룹웨어', '메일', 'OWA 수신', 'I', 503, 'Y', ''),
       ('EMMP', '그룹웨어', '메일', 'OWA 발신', 'O', 504, 'Y', ''),
       ('EMMD', '그룹웨어', '메일', 'RPC 수신', 'I', 505, 'Y', ''),
       ('EMMU', '그룹웨어', '메일', 'RPC 발신', 'O', 506, 'Y', ''),
       ('EMMC', '그룹웨어', '메일', '수신', 'I', 507, 'Y', ''),
       ('EMML', '그룹웨어', '메일', '발신', 'O', 508, 'Y', ''),
       ('EMM1', '그룹웨어', '메일', '보안등급1', 'O', 509, 'Y', ''),
       ('EMM2', '그룹웨어', '메일', '보안등급2', 'O', 510, 'Y', ''),
       ('EMM3', '그룹웨어', '메일', '보안등급3', 'O', 511, 'Y', ''),
       ('EMM4', '그룹웨어', '메일', '보안등급4', 'O', 512, 'Y', ''),
       ('EMMA', '그룹웨어', '메일', '임시(자동)', 'O', 513, 'Y', ''),
       ('EMMT', '그룹웨어', '메일', '임시(수동)', 'O', 514, 'Y', ''),
       ('EMMK', '그룹웨어', '메일', 'Outlook - 수신', 'I', 515, 'Y', ''),
       ('EMMO', '그룹웨어', '메일', 'Outlook - 발신', 'O', 516, 'Y', ''),
       ('EMMB', '그룹웨어', '메일', '그룹웨어 예약메일', 'O', 517, 'Y', ''),
       ('EMBR', '그룹웨어', '모바일', '수신', 'I', 518, 'Y', ''),
       ('EMB-', '그룹웨어', '모바일', '발신', 'O', 519, 'Y', ''),
       ('EWSR', '그룹웨어', '웹서비스', '수신', 'I', 520, 'Y', ''),
       ('EWS-', '그룹웨어', '웹서비스', '발신', 'O', 521, 'Y', ''),
       ('EPUR', '그룹웨어', '일반', '수신', 'I', 522, 'Y', ''),
       ('EPU-', '그룹웨어', '일반', '발신', 'O', 523, 'Y', ''),
       ('EAU-', '그룹웨어', '일반(자동전달)', '자동전달', 'O', 524, 'Y', ''),
       ('ESCR', '그룹웨어', '일정 명함', '수신', 'I', 525, 'Y', ''),
       ('ESC-', '그룹웨어', '일정 명함', '발신', 'O', 526, 'Y', ''),
       ('EMF-', '그룹웨어', '파일 다운로드', '-', 'I', 527, 'Y', ''),
       ('EMU-', '그룹웨어', '기타', '', 'O', 528, 'Y', ''),
       ('EMDR', '그룹웨어', '드라이브', '수신', 'I', 529, 'Y', ''),
       ('EMDS', '그룹웨어', '드라이브', '발신', 'O', 530, 'Y', ''),
       ('ECIS', '그룹웨어', 'Samsung cic', '발신', 'O', 531, 'Y', ''),
       ('EMER', '그룹웨어', '메신저', '수신', 'O', 532, 'Y', ''),
       ('EMES', '그룹웨어', '메신저', '발신', 'O', 533, 'Y', ''),
       ('EZQC', '그룹웨어', 'Zohocliq', '채팅', 'O', 534, 'Y', ''),
       ('EZQS', '그룹웨어', 'Zohocliq', '캘린더', 'O', 535, 'Y', ''),
       ('DCCS', '편집기', 'Clip Champ', '발신', 'O', 536, 'Y', ''),
       ('DFGS', '편집기', 'Figma', '발신', 'O', 537, 'Y', ''),
       ('DOVS', '편집기', 'Overleaf', '발신', 'O', 538, 'Y', ''),
       ('DOVR', '편집기', 'Overleaf', '수신', 'O', 539, 'Y', ''),
       ('DPKS', '편집기', 'Plunker', '발신', 'O', 540, 'Y', ''),
       ('DNWS', '편집기', 'Namu.wiki', '발신', 'O', 541, 'Y', ''),
       ('DWKS', '편집기', 'WikiPedia', '발신', 'O', 542, 'Y', '');


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

