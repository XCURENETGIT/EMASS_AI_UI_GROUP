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


    /* 자동연동 IS_AUTO 추가건 */
CALL ALTER_TB( 'UI_CO' , 'IS_AUTO' , 'ALTER TABLE EMASSAI.UI_CO ADD IS_AUTO varchar(4) DEFAULT NULL COMMENT \'자동추가:Y, 수동추가:N\'');
CALL ALTER_TB( 'UI_BUSI' , 'IS_AUTO' , 'ALTER TABLE EMASSAI.UI_BUSI ADD IS_AUTO varchar(4) DEFAULT NULL COMMENT \'자동추가:Y, 수동추가:N\'');
CALL ALTER_TB( 'UI_GENERAL' , 'IS_AUTO' , 'ALTER TABLE EMASSAI.UI_GENERAL ADD IS_AUTO varchar(4) DEFAULT NULL COMMENT \'자동추가:Y, 수동추가:N\'');
CALL ALTER_TB( 'UI_DEPT' , 'IS_AUTO' , 'ALTER TABLE EMASSAI.UI_DEPT ADD IS_AUTO varchar(4) DEFAULT NULL COMMENT \'자동추가:Y, 수동추가:N\'');
CALL ALTER_TB( 'UI_JIKGUB' , 'IS_AUTO' , 'ALTER TABLE EMASSAI.UI_JIKGUB ADD IS_AUTO varchar(4) DEFAULT NULL COMMENT \'자동추가:Y, 수동추가:N\'');
CALL ALTER_TB( 'UI_JIKIN' , 'IS_AUTO' , 'ALTER TABLE EMASSAI.UI_JIKIN ADD IS_AUTO varchar(4) DEFAULT NULL COMMENT \'자동추가:Y, 수동추가:N\'');
CALL ALTER_TB( 'UI_USER_IP' , 'IS_AUTO' , 'ALTER TABLE EMASSAI.UI_USER_IP ADD IS_AUTO varchar(4) DEFAULT NULL COMMENT \'자동추가:Y, 수동추가:N\'');
CALL ALTER_TB( 'UI_USER_EMAIL' , 'IS_AUTO' , 'ALTER TABLE EMASSAI.UI_USER_EMAIL ADD IS_AUTO varchar(4) DEFAULT NULL COMMENT \'자동추가:Y, 수동추가:N\'');
CALL ALTER_TB( 'UI_USERS' , 'IS_AUTO' , 'ALTER TABLE EMASSAI.UI_USERS ADD IS_AUTO varchar(4) DEFAULT NULL COMMENT \'자동추가:Y, 수동추가:N\'');

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
CALL ALTER_TB( 'UI_KEYWORD_NOLOG' , 'UPDATE_DT' , 'ALTER TABLE EMASSAI.UI_KEYWORD_NOLOG ADD UPDATE_DT DATETIME NULL COMMENT \'수정일\'');
CALL ALTER_TB( 'UI_KEYWORD_NOLOG' , 'UPDATE_ID' , 'ALTER TABLE EMASSAI.UI_KEYWORD_NOLOG ADD UPDATE_ID VARCHAR(50) NULL COMMENT \'수정 운용자 아이디\'');
CALL ALTER_TB( 'UI_DOWNLOAD_BATCH' , 'SKIP_TEXT' , 'ALTER TABLE EMASSAI.UI_DOWNLOAD_BATCH ADD SKIP_TEXT LONGTEXT NULL COMMENT \'skip 사유\'');
CALL ALTER_TB( 'UI_BUSI_IPRANGE' , 'COUNTRY' , 'ALTER TABLE EMASSAI.UI_BUSI_IPRANGE ADD COUNTRY varchar(30) DEFAULT \'KR\'  COMMENT \'국가코드\'');
CALL ALTER_TB( 'UI_KEYWORD_GROUP' , 'CORE_YN' , 'ALTER TABLE EMASSAI.UI_KEYWORD_GROUP ADD CORE_YN char(1) DEFAULT \'N\' COMMENT \'핵심 예약어 그룹 유무\'');

CALL ALTER_TB( 'UI_REGEXP' , 'ENABLE' , 'ALTER TABLE EMASSAI.UI_REGEXP ADD ENABLE char(1) DEFAULT \'Y\' COMMENT \'패턴 사용 여부 Y:사용, N:사용안함\'');
CALL ALTER_TB( 'UI_REGEXP' , 'CODE_TYPE' , 'ALTER TABLE EMASSAI.UI_REGEXP ADD CODE_TYPE char(1) DEFAULT \'C\' NOT NULL COMMENT \'패턴 코드 타입 N:개인정보 A:이상행위의심 C:사용자 정의\'');

CALL ALTER_TB( 'UI_ALARM_LOG' , 'SEARCH_FIELD' , 'ALTER TABLE EMASSAI.UI_ALARM_LOG ADD SEARCH_FIELD LONGTEXT DEFAULT NULL COMMENT \'검색 필드\'');

/*DROP FUNCTION IF EXISTS xcnenc;
DROP FUNCTION IF EXISTS xcndec;
CREATE FUNCTION xcnenc returns string soname "xcnenc.so";
CREATE FUNCTION xcndec returns string soname "xcnenc.so";*/

CREATE TABLE IF NOT EXISTS UI_BODY_NATION (
    NATION_CD VARCHAR(2) NOT NULL COMMENT '국가 코드',
    NATION_NAME VARCHAR(120) NOT NULL COMMENT '국가 언어',
    NATION VARCHAR(120) NOT NULL COMMENT '국가 이름',
PRIMARY KEY (NATION_CD)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='본문 언어 탐지';

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
SELECT 'info.feedback.used', 'true', 'true', NOW() FROM DUAL
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

INSERT INTO UI_CONF (CONF_ID, VAL, DEFAULT_VAL, UPDATE_DT)
SELECT 'sender.receiver.asta', 'false', 'false', NOW() FROM DUAL
WHERE NOT EXISTS (SELECT * FROM UI_CONF WHERE CONF_ID='sender.receiver.asta');


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
('WZHR', '웹메일', 'Zoho 메일', '수신', 'I', 80, 'Y', ''),
('WRUS', '웹메일', 'Russian Mail', '발신', 'O', 81, 'Y', ''),
('WUKR', '웹메일', '기타', '수신', 'I', 82, 'Y', ''),
('WUKS', '웹메일', '기타', '발신', 'O', 83, 'Y', ''),
('WSES', '웹메일', 'AWS SES Mail', '발신', 'O', 84, 'Y', ''),
('WGSS', '웹메일', 'Genspark', '발신', 'O', 85, 'Y', ''),
('WGST', '웹메일', 'Genspark', '임시저장', 'O', 86, 'Y', ''),
('WUKB', '웹메일', '기타 예약메일', '발신', 'O', 87, 'Y', ''),
('WUKT', '웹메일', '임시저장', '발신', 'O', 88, 'Y', ''),
('CNVR', '커뮤니티', '네이버 카페', '수신', 'I', 89, 'Y', ''),
('CNVS', '커뮤니티', '네이버 카페', '발신', 'O', 90, 'Y', ''),
('CNVD', '커뮤니티', '네이버 카페', '댓글', 'O', 91, 'Y', ''),
('CNVT', '커뮤니티', '네이버 카페', '임시저장', 'O', 92, 'Y', ''),
('CNVU', '커뮤니티', '네이버 카페', '수정', 'O', 93, 'Y', ''),
('CDUR', '커뮤니티', '다음 카페', '수신', 'I', 94, 'Y', ''),
('CDUS', '커뮤니티', '다음 카페', '발신', 'O', 95, 'Y', ''),
('CDUD', '커뮤니티', '다음 카페', '댓글', 'O', 96, 'Y', ''),
('CDUT', '커뮤니티', '다음 카페', '임시저장', 'O', 97, 'Y', ''),
('CPPR', '커뮤니티', '뽐뿌 커뮤니케이션', '수신', 'I', 98, 'Y', ''),
('CPPS', '커뮤니티', '뽐뿌 커뮤니케이션', '발신', 'O', 99, 'Y', ''),
('CPPD', '커뮤니티', '뽐뿌 커뮤니케이션', '댓글', 'O', 100, 'Y', ''),
('CCIR', '커뮤니티', '클리앙', '수신', 'I', 101, 'Y', ''),
('CCIS', '커뮤니티', '클리앙', '발신', 'O', 102, 'Y', ''),
('CCID', '커뮤니티', '클리앙', '댓글', 'O', 103, 'Y', ''),
('CDCR', '커뮤니티', '디시인사이드', '수신', 'I', 104, 'Y', ''),
('CDCS', '커뮤니티', '디시인사이드', '발신', 'O', 105, 'Y', ''),
('CDCD', '커뮤니티', '디시인사이드', '댓글', 'O', 106, 'Y', ''),
('CRWR', '커뮤니티', '루리웹', '수신', 'I', 107, 'Y', ''),
('CRWS', '커뮤니티', '루리웹', '발신', 'O', 108, 'Y', ''),
('CRWD', '커뮤니티', '루리웹', '댓글', 'O', 109, 'Y', ''),
('CMLR', '커뮤니티', 'Menlosecurity', '수신', 'I', 110, 'Y', ''),
('CMLS', '커뮤니티', 'Menlosecurity', '발신', 'O', 111, 'Y', ''),
('CMLD', '커뮤니티', 'Menlosecurity', '댓글', 'O', 112, 'Y', ''),
('CMLE', '커뮤니티', 'Menlosecurity', '기타', 'O', 113, 'Y', ''),
('CBDS', '커뮤니티', '블라인드', '발신', 'O', 114, 'Y', ''),
('CBRS', '커뮤니티', '브런치 스토리', '발신', 'O', 115, 'Y', ''),
('CUKR', '커뮤니티', '기타', '수신', 'I', 116, 'Y', ''),
('CUKS', '커뮤니티', '기타', '발신', 'O', 117, 'Y', ''),
('CUKD', '커뮤니티', '기타', '댓글', 'O', 118, 'Y', ''),
('SFBR', '소셜', '페이스북', '수신', 'I', 119, 'Y', ''),
('SFBS', '소셜', '페이스북', '발신', 'O', 120, 'Y', ''),
('SFBD', '소셜', '페이스북', '댓글', 'O', 121, 'Y', ''),
('STWR', '소셜', '트위터', '수신', 'I', 122, 'Y', ''),
('STWS', '소셜', '트위터', '발신', 'O', 123, 'Y', ''),
('STWD', '소셜', '트위터', '댓글', 'O', 124, 'Y', ''),
('SKAR', '소셜', '카카오스토리', '수신', 'I', 125, 'Y', ''),
('SKAS', '소셜', '카카오스토리', '발신', 'O', 126, 'Y', ''),
('SKAD', '소셜', '카카오스토리', '댓글', 'O', 127, 'Y', ''),
('SNVR', '소셜', '네이버 블로그', '수신', 'I', 128, 'Y', ''),
('SNVS', '소셜', '네이버 블로그', '발신', 'O', 129, 'Y', ''),
('SNVD', '소셜', '네이버 블로그', '댓글', 'O', 130, 'Y', ''),
('SNVT', '소셜', '네이버 블로그', '임시저장', 'O', 131, 'Y', ''),
('SNVU', '소셜', '네이버 블로그', '수정', 'O', 132, 'Y', ''),
('SDUR', '소셜', '다음 블로그', '수신', 'I', 133, 'Y', ''),
('SDUS', '소셜', '다음 블로그', '발신', 'O', 134, 'Y', ''),
('SDUD', '소셜', '다음 블로그', '댓글', 'O', 135, 'Y', ''),
('STSR', '소셜', '티스토리', '수신', 'I', 136, 'Y', ''),
('STSS', '소셜', '티스토리', '발신', 'O', 137, 'Y', ''),
('STSD', '소셜', '티스토리', '댓글', 'O', 138, 'Y', ''),
('STST', '소셜', '티스토리', '임시저장', 'O', 139, 'Y', ''),
('STBR', '소셜', '텀블러', '수신', 'I', 140, 'Y', ''),
('STBS', '소셜', '텀블러', '발신', 'O', 141, 'Y', ''),
('STBD', '소셜', '텀블러', '댓글', 'O', 142, 'Y', ''),
('SWBR', '소셜', '웨이보', '수신', 'I', 143, 'Y', ''),
('SWBS', '소셜', '웨이보', '발신', 'O', 144, 'Y', ''),
('SWBD', '소셜', '웨이보', '댓글', 'O', 145, 'Y', ''),
('SLKR', '소셜', '링크드인', '수신', 'I', 146, 'Y', ''),
('SLKS', '소셜', '링크드인', '발신', 'O', 147, 'Y', ''),
('SLKD', '소셜', '링크드인', '댓글', 'O', 148, 'Y', ''),
('SEGR', '소셜', '이글루', '수신', 'I', 149, 'Y', ''),
('SEGS', '소셜', '이글루', '발신', 'O', 150, 'Y', ''),
('SEGD', '소셜', '이글루', '댓글', 'O', 151, 'Y', ''),
('SYMR', '소셜', '야머', '수신', 'I', 152, 'Y', ''),
('SYMS', '소셜', '야머', '발신', 'O', 153, 'Y', ''),
('SYMD', '소셜', '야머', '댓글', 'O', 154, 'Y', ''),
('SYMF', '소셜', '야머', '파일전송', 'O', 155, 'Y', ''),
('SNBR', '소셜', '네이버 밴드', '수신', 'I', 156, 'Y', ''),
('SNBS', '소셜', '네이버 밴드', '발신', 'O', 157, 'Y', ''),
('SNBD', '소셜', '네이버 밴드', '댓글', 'O', 158, 'Y', ''),
('SLRR', '소셜', '라이브리', '수신', 'I', 159, 'Y', ''),
('SLRS', '소셜', '라이브리', '발신', 'O', 160, 'Y', ''),
('SLRD', '소셜', '라이브리', '댓글', 'O', 161, 'Y', ''),
('SMER', '소셜', 'Medium', '수신', 'I', 162, 'Y', ''),
('SMES', '소셜', 'Medium', '발신', 'O', 163, 'Y', ''),
('SMED', '소셜', 'Medium', '댓글', 'O', 164, 'Y', ''),
('SISR', '소셜', '인스타그램', '수신', 'I', 165, 'Y', ''),
('SISS', '소셜', '인스타그램', '발신', 'O', 166, 'Y', ''),
('SISD', '소셜', '인스타그램', '댓글', 'O', 167, 'Y', ''),
('SISF', '소셜', '인스타그램', '파일전송', 'O', 168, 'Y', ''),
('SSFS', '소셜', 'Salesforce', '발신', 'O', 169, 'Y', ''),
('SPIS', '소셜', 'Pinterest', '발신', 'O', 170, 'Y', ''),
('STHS', '소셜', 'Threads', '발신', 'O', 171, 'Y', ''),
('SBLS', '소셜', '블로거', '발신', 'O', 172, 'Y', ''),
('STTS', '소셜', 'Tiktok', '발신', 'O', 173, 'Y', ''),
('VDUR', '영상 스트리밍', '다음 TV', '수신', 'I', 174, 'Y', ''),
('VDUS', '영상 스트리밍', '다음 TV', '발신', 'O', 175, 'Y', ''),
('VPDR', '영상 스트리밍', '판도라 TV', '수신', 'I', 176, 'Y', ''),
('VPDS', '영상 스트리밍', '판도라 TV', '발신', 'O', 177, 'Y', ''),
('VGMR', '영상 스트리밍', '곰 TV', '수신', 'I', 178, 'Y', ''),
('VGMS', '영상 스트리밍', '곰 TV', '발신', 'O', 179, 'Y', ''),
('VYTR', '영상 스트리밍', '유튜브', '수신', 'I', 180, 'Y', ''),
('VYTS', '영상 스트리밍', '유튜브', '발신', 'O', 181, 'Y', ''),
('VYTD', '영상 스트리밍', '유튜브', '댓글', 'O', 182, 'Y', ''),
('VNVR', '영상 스트리밍', '네이버 TV캐스트', '수신', 'I', 183, 'Y', ''),
('VNVS', '영상 스트리밍', '네이버 TV캐스트', '발신', 'O', 184, 'Y', ''),
('QNVC', '메신저', '네이버', '채팅', 'O', 185, 'N', ''),
('QNVF', '메신저', '네이버', '파일전송', 'O', 186, 'N', ''),
('QNMR', '메신저', '네이버 쪽지', '수신', 'I', 187, 'N', ''),
('QNMS', '메신저', '네이버 쪽지', '발신', 'O', 188, 'N', ''),
('QDUC', '메신저', '다음', '채팅', 'O', 189, 'N', ''),
('QDUF', '메신저', '다음', '파일전송', 'O', 190, 'N', ''),
('QDUM', '메신저', '다음', '쪽지', 'O', 191, 'N', ''),
('QDSC', '메신저', '대신', '채팅', 'O', 192, 'N', ''),
('QDSF', '메신저', '대신', '파일전송', 'O', 193, 'N', ''),
('QDSM', '메신저', '대신', '쪽지', 'O', 194, 'N', ''),
('QSHC', '메신저', '삼홍사', '채팅', 'O', 195, 'Y', ''),
('QSHF', '메신저', '삼홍사', '파일전송', 'O', 196, 'Y', ''),
('QSHM', '메신저', '삼홍사', '쪽지', 'O', 197, 'Y', ''),
('QDIC', '메신저', '동부생명', '채팅', 'O', 198, 'Y', ''),
('QDIF', '메신저', '동부생명', '파일전송', 'O', 199, 'Y', ''),
('QDIM', '메신저', '동부생명', '쪽지', 'O', 200, 'Y', ''),
('QDFC', '메신저', '동부금융', '채팅', 'O', 201, 'Y', ''),
('QDFF', '메신저', '동부금융', '파일전송', 'O', 202, 'Y', ''),
('QDFM', '메신저', '동부금융', '쪽지', 'O', 203, 'Y', ''),
('QDGC', '메신저', '동국제강', '채팅', 'O', 204, 'Y', ''),
('QDGF', '메신저', '동국제강', '파일전송', 'O', 205, 'Y', ''),
('QDGM', '메신저', '동국제강', '쪽지', 'O', 206, 'Y', ''),
('QFMC', '메신저', '프리본드', '채팅', 'O', 207, 'Y', 'MSG'),
('QFMF', '메신저', '프리본드', '파일전송', 'O', 208, 'Y', 'MSG'),
('QFMM', '메신저', '프리본드', '쪽지', 'O', 209, 'Y', 'MSG'),
('QFMJ', '메신저', '프리본드', '참여', 'O', 210, 'Y', 'MSG'),
('QFML', '메신저', '프리본드', '떠남', 'O', 211, 'Y', 'MSG'),
('QMCC', '메신저', 'M-채널', '채팅', 'O', 212, 'Y', ''),
('QMCF', '메신저', 'M-채널', '파일전송', 'O', 213, 'Y', ''),
('QMCM', '메신저', 'M-채널', '쪽지', 'O', 214, 'Y', ''),
('QMSC', '메신저', '미쓰리', '채팅', 'O', 215, 'Y', 'MSG'),
('QMSF', '메신저', '미쓰리', '파일전송', 'O', 216, 'Y', 'MSG'),
('QMSM', '메신저', '미쓰리', '쪽지', 'O', 217, 'Y', 'MSG'),
('QMSJ', '메신저', '미쓰리', '참여', 'O', 218, 'Y', 'MSG'),
('QMSL', '메신저', '미쓰리', '떠남', 'O', 219, 'Y', 'MSG'),
('QNTC', '메신저', '네이트', '채팅', 'O', 220, 'Y', 'MSG'),
('QNTF', '메신저', '네이트', '파일전송', 'O', 221, 'Y', 'MSG'),
('QNTM', '메신저', '네이트', '쪽지', 'O', 222, 'Y', 'MSG'),
('QNTJ', '메신저', '네이트', '참여', 'O', 223, 'Y', 'MSG'),
('QNTL', '메신저', '네이트', '떠남', 'O', 224, 'Y', 'MSG'),
('QSSC', '메신저', '삼성증권', '채팅', 'O', 225, 'N', ''),
('QSSF', '메신저', '삼성증권', '파일전송', 'O', 226, 'N', ''),
('QSSM', '메신저', '삼성증권', '쪽지', 'O', 227, 'N', ''),
('QSFC', '메신저', '삼성화재', '채팅', 'O', 228, 'Y', ''),
('QSFF', '메신저', '삼성화재', '파일전송', 'O', 229, 'Y', ''),
('QSFM', '메신저', '삼성화재', '쪽지', 'O', 230, 'Y', ''),
('QSFJ', '메신저', '삼성화재', '참여', 'O', 231, 'Y', ''),
('QSFL', '메신저', '삼성화재', '떠남', 'O', 232, 'Y', ''),
('QSPC', '메신저', 'SK 프라이든', '채팅', 'O', 233, 'Y', ''),
('QSPF', '메신저', 'SK 프라이든', '파일전송', 'O', 234, 'Y', ''),
('QSPM', '메신저', 'SK 프라이든', '쪽지', 'O', 235, 'Y', ''),
('QSPJ', '메신저', 'SK 프라이든', '참여', 'O', 236, 'Y', ''),
('QSPL', '메신저', 'SK 프라이든', '떠남', 'O', 237, 'Y', ''),
('QSBC', '메신저', 'SK 비즈', '채팅', 'O', 238, 'N', ''),
('QSBF', '메신저', 'SK 비즈', '파일전송', 'O', 239, 'N', ''),
('QSBM', '메신저', 'SK 비즈', '쪽지', 'O', 240, 'N', ''),
('QWJC', '메신저', '웅진', '채팅', 'O', 241, 'Y', ''),
('QWJF', '메신저', '웅진', '파일전송', 'O', 242, 'Y', ''),
('QWJM', '메신저', '웅진', '쪽지', 'O', 243, 'Y', ''),
('QGPC', '메신저', 'ChatGPT', '채팅', 'O', 244, 'Y', ''),
('QDAC', '메신저', 'Dall-E', '채팅', 'O', 245, 'Y', ''),
('QDAF', '메신저', 'Dall-E', '파일전송', 'O', 246, 'Y', ''),
('QCLC', '메신저', '쿨', '채팅', 'O', 247, 'Y', 'MSG'),
('QCLF', '메신저', '쿨', '파일전송', 'O', 248, 'Y', 'MSG'),
('QCLM', '메신저', '쿨', '쪽지', 'O', 249, 'Y', 'MSG'),
('QCLJ', '메신저', '쿨', '참여', 'O', 250, 'Y', 'MSG'),
('QCLL', '메신저', '쿨', '떠남', 'O', 251, 'Y', 'MSG'),
('QKBC', '메신저', 'K-bond', '채팅', 'O', 252, 'Y', 'MSG'),
('QKBF', '메신저', 'K-bond', '파일전송', 'O', 253, 'Y', 'MSG'),
('QKBM', '메신저', 'K-bond', '쪽지', 'O', 254, 'Y', 'MSG'),
('QKBJ', '메신저', 'K-bond', '참여', 'O', 255, 'Y', 'MSG'),
('QKBL', '메신저', 'K-bond', '떠남', 'O', 256, 'Y', 'MSG'),
('QEKC', '메신저', '아이콘', '채팅', 'O', 257, 'Y', 'MSG'),
('QEKF', '메신저', '아이콘', '파일전송', 'O', 258, 'Y', 'MSG'),
('QEKJ', '메신저', '아이콘', '참여', 'O', 259, 'Y', 'MSG'),
('QEKL', '메신저', '아이콘', '떠남', 'O', 260, 'Y', 'MSG'),
('QEKH', '메신저', '아이콘', '과거 데이터', 'O', 261, 'Y', 'MSG'),
('QSLC', '메신저', 'Slack', '채팅', 'O', 262, 'Y', 'MSG'),
('QSLF', '메신저', 'Slack', '파일전송', 'O', 263, 'Y', 'MSG'),
('QSLJ', '메신저', 'Slack', '참여', 'O', 264, 'Y', 'MSG'),
('QSLL', '메신저', 'Slack', '떠남', 'O', 265, 'Y', 'MSG'),
('QSYC', '메신저', '신영자산운용', '채팅', 'O', 266, 'Y', 'MSG'),
('QSYF', '메신저', '신영자산운용', '파일전송', 'O', 267, 'Y', 'MSG'),
('QSYM', '메신저', '신영자산운용', '쪽지', 'O', 268, 'Y', 'MSG'),
('QSYJ', '메신저', '신영자산운용', '참여', 'O', 269, 'Y', 'MSG'),
('QSYL', '메신저', '신영자산운용', '떠남', 'O', 270, 'Y', 'MSG'),
('QFBC', '메신저', '페이스북', '채팅', 'O', 271, 'Y', 'MSG'),
('QFBF', '메신저', '페이스북', '파일전송', 'O', 272, 'Y', 'MSG'),
('QKMC', '메신저', '삼성KnoxMessenger', '채팅', 'O', 273, 'Y', 'MSG'),
('QKMF', '메신저', '삼성KnoxMessenger', '파일전송', 'O', 274, 'Y', 'MSG'),
('QKMR', '메신저', '삼성KnoxMessenger', '파일수신', 'I', 275, 'Y', 'MSG'),
('QKMW', '메신저', '삼성KnoxMessenger', '전달', 'O', 276, 'Y', 'MSG'),
('QKMV', '메신저', '삼성KnoxMessenger', '파일-미리보기', 'O', 277, 'Y', 'MSG'),
('QGHC', '메신저', '구글 Hangout', '채팅', 'O', 278, 'Y', 'MSG'),
('QGHF', '메신저', '구글 Hangout', '파일전송', 'O', 279, 'Y', 'MSG'),
('QGGC', '메신저', '구글 chat', '채팅', 'O', 280, 'Y', 'MSG'),
('QGGF', '메신저', '구글 chat', '파일전송', 'O', 281, 'Y', 'MSG'),
('QGMC', '메신저', '구글 Meet', '채팅', 'O', 282, 'Y', 'MSG'),
('QGBC', '메신저', '구글 Bard', '채팅', 'O', 283, 'Y', 'MSG'),
('QBIC', '메신저', 'Microsoft BingAI Chat', '채팅', 'O', 284, 'Y', 'MSG'),
('QWTC', '메신저', 'Wrtn', '채팅', 'O', 285, 'Y', ''),
('QISC', '메신저', '인스타그램 DM', '채팅', 'O', 286, 'Y', 'MSG'),
('QISF', '메신저', '인스타그램 DM', '파일전송', 'O', 287, 'Y', 'MSG'),
('QZAC', '메신저', 'Zalo', '채팅', 'O', 288, 'Y', 'MSG'),
('QZAF', '메신저', 'Zalo', '파일전송', 'O', 289, 'Y', 'MSG'),
('QNBC', '메신저', '네이버 밴드 채팅', '채팅', 'O', 290, 'Y', 'MSG'),
('QNBF', '메신저', '네이버 밴드 채팅', '파일전송', 'O', 291, 'Y', 'MSG'),
('QDOC', '메신저', 'Dooray app', '채팅', 'O', 292, 'Y', 'MSG'),
('QDOF', '메신저', 'Dooray app', '파일전송', 'O', 293, 'Y', 'MSG'),
('QUKC', '메신저', '기타', '채팅', 'O', 294, 'Y', 'MSG'),
('QUKF', '메신저', '기타', '파일전송', 'O', 295, 'Y', 'MSG'),
('QUKM', '메신저', '기타', '쪽지', 'O', 296, 'Y', 'MSG'),
('QUKJ', '메신저', '기타', '참여', 'O', 297, 'Y', 'MSG'),
('QUKL', '메신저', '기타', '떠남', 'O', 298, 'Y', 'MSG'),
('QTAS', '메신저', '네이버 톡톡', '발신', 'O', 299, 'Y', ''),
('QTAC', '메신저', '네이버 톡톡', '채팅', 'O', 300, 'Y', ''),
('QTAF', '메신저', '네이버 톡톡', '파일전송', 'O', 301, 'Y', ''),
('QTAR', '메신저', '네이버 톡톡', '수신', 'I', 302, 'Y', ''),
('QDCC', '메신저', 'Discord', '채팅', 'O', 303, 'Y', ''),
('QDCF', '메신저', 'Discord', '첨부파일', 'O', 304, 'Y', ''),
('QGSC', '메신저', 'Genspark', '채팅', 'O', 305, 'Y', ''),
('QOTC', '메신저', '네이버 오픈톡', '채팅', 'O', 306, 'Y', ''),
('QOTF', '메신저', '네이버 오픈톡', '파일전송', 'O', 307, 'Y', ''),
('FFTC', '파일전송', 'FTP', 'CMD', 'O', 308, 'Y', ''),
('FFTG', '파일전송', 'FTP', 'GET', 'I', 309, 'Y', ''),
('FFTP', '파일전송', 'FTP', 'PUT', 'O', 310, 'Y', ''),
('FFTL', '파일전송', 'FTP', 'CONNECT', 'O', 311, 'Y', ''),
('FZM-', '파일전송', 'Zmodem', '-', 'O', 312, 'Y', ''),
('FNVR', '파일전송', '네이버 MYBOX', '수신', 'I', 313, 'Y', ''),
('FNVS', '파일전송', '네이버 MYBOX', '발신', 'O', 314, 'Y', ''),
('FGGR', '파일전송', '구글 드라이브', '수신', 'I', 315, 'Y', ''),
('FGGS', '파일전송', '구글 드라이브', '발신', 'O', 316, 'Y', ''),
('FODR', '파일전송', 'OneDrive', '수신', 'I', 317, 'Y', ''),
('FODS', '파일전송', 'OneDrive', '발신', 'O', 318, 'Y', ''),
('FDBR', '파일전송', 'Dropbox', '수신', 'I', 319, 'Y', ''),
('FDBS', '파일전송', 'Dropbox', '발신', 'O', 320, 'Y', ''),
('F2NR', '파일전송', '2nd 드라이브', '수신', 'I', 321, 'N', ''),
('F2NS', '파일전송', '2nd 드라이브', '발신', 'O', 322, 'N', ''),
('FPSR', '파일전송', 'Polarisoffice ', '수신', 'I', 323, 'Y', ''),
('FICR', '파일전송', 'Icloud', '수신', 'I', 324, 'Y', ''),
('FICS', '파일전송', 'Icloud', '발신', 'O', 325, 'Y', ''),
('FYDR', '파일전송', 'Yandex', '수신', 'I', 326, 'Y', ''),
('FYDS', '파일전송', 'Yandex', '발신', 'O', 327, 'Y', ''),
('FWHR', '파일전송', 'LG 웹하드', '수신', 'I', 328, 'Y', ''),
('FWHS', '파일전송', 'LG 웹하드', '발신', 'O', 329, 'Y', ''),
('FGIR', '파일전송', 'GitHub', '수신', 'I', 330, 'Y', ''),
('FGIS', '파일전송', 'GitHub', '발신', 'O', 331, 'Y', ''),
('FDOR', '파일전송', 'Dooray', '수신', 'I', 332, 'Y', ''),
('FDOS', '파일전송', 'Dooray', '발신', 'O', 333, 'Y', ''),
('FWES', '파일전송', 'Wetransfer', '발신', 'O', 334, 'Y', ''),
('FASS', '파일전송', 'AWS S3 bucket', '발신', 'O', 335, 'Y', ''),
('FGES', '파일전송', '구글 렌즈', '발신', 'O', 336, 'Y', ''),
('FTRS', '파일전송', 'File Transfer.io', '발신', 'O', 337, 'Y', ''),
('FCLS', '파일전송', 'pCloud Transfer', '발신', 'O', 338, 'Y', ''),
('FMZS', '파일전송', 'M/Z Cloud', '발신', 'O', 339, 'Y', ''),
('FMZR', '파일전송', 'M/Z Cloud', '수신', 'I', 340, 'Y', ''),
('FUKR', '파일전송', '기타', '수신', 'I', 341, 'Y', ''),
('FUKS', '파일전송', '기타', '발신', 'O', 342, 'Y', ''),
('FPTS', '파일전송', '구글 포토', '발신', 'O', 343, 'Y', ''),
('FAZS', '파일전송', 'Azure Blob Storage', '발신', 'O', 344, 'Y', ''),
('FCTS', '파일전송', 'Cow Transfer', '발신', 'O', 345, 'Y', ''),
('FGCS', '파일전송', '구글 클라우드 스토리지', '발신', 'O', 346, 'Y', ''),
('FSVS', '파일전송', 'Tortoise SVN', '발신', 'O', 347, 'Y', ''),
('FTFS', '파일전송', 'AWS Transfer Family', '발신', 'O', 348, 'Y', ''),
('FADS', '파일전송', 'Autodesk', '발신', 'O', 349, 'Y', ''),
('NPPS', '노트', 'polarisoffice', '발신', 'O', 350, 'Y', ''),
('NENR', '노트', 'EVERNOTE', '수신', 'I', 351, 'Y', ''),
('NENS', '노트', 'EVERNOTE', '발신', 'O', 352, 'Y', ''),
('NONR', '노트', 'ONENOTE', '수신', 'I', 353, 'Y', ''),
('NONS', '노트', 'ONENOTE', '발신', 'O', 354, 'Y', ''),
('NLVS', '노트', 'Outlook.com 메모', '발신', 'O', 355, 'Y', ''),
('NBTS', '노트', 'BIT.AI', '발신', 'O', 356, 'Y', ''),
('NNOS', '노트', 'Notion', '발신', 'O', 357, 'Y', ''),
('NGGS', '노트', '구글 docs', '발신', 'O', 358, 'Y', ''),
('NGTS', '노트', '구글 tasks', '발신', 'O', 359, 'Y', ''),
('NGKS', '노트', '구글 keep', '발신', 'O', 360, 'Y', ''),
('NSSR', '노트', '삼성 노트', '수신', 'I', 361, 'Y', ''),
('NSSS', '노트', '삼성 노트', '발신', 'O', 362, 'Y', ''),
('NNVS', '노트', '네이버 오피스', '발신', 'O', 363, 'Y', ''),
('NDBS', '노트', 'Dropbox paper', '발신', 'O', 364, 'Y', ''),
('NHCS', '노트', '한컴 오피스', '발신', 'O', 365, 'Y', ''),
('NMOS', '노트', 'MS오피스', '발신', 'O', 366, 'Y', ''),
('NCDS', '노트', 'Coda', '발신', 'O', 367, 'Y', ''),
('NNMR', '노트', '네이버 메모', '수신', 'I', 368, 'Y', ''),
('NNMS', '노트', '네이버 메모', '발신', 'O', 369, 'Y', ''),
('NCNS', '노트', 'Clova Note', '발신', 'O', 370, 'Y', ''),
('NGIS', '노트', 'Github Gist', '발신', 'O', 371, 'Y', ''),
('NSNS', '노트', 'SimpleNote', '발신', 'O', 372, 'Y', ''),
('NAGS', '노트', 'Agit', '발신', 'O', 373, 'Y', ''),
('NPSS', '노트', 'Polaris office', '발신', 'O', 374, 'Y', ''),
('NBOS', '노트', 'Box', '발신', 'O', 375, 'Y', ''),
('NCKS', '노트', 'ClickUp', '발신', 'O', 376, 'Y', ''),
('NGNS', '노트', 'Goodnotes', '발신', 'O', 377, 'Y', ''),
('NMNS', '노트', 'Milanote', '발신', 'O', 378, 'Y', ''),
('NZQS', '노트', 'zohocliq', '발신', 'O', 379, 'Y', ''),
('NMTS', '노트', 'Mentimeter', '발신', 'O', 380, 'Y', ''),
('NOOS', '노트', 'Goorm', '발신', 'O', 381, 'Y', ''),
('NMIS', '노트', '밀리의서재', '발신', 'O', 382, 'Y', ''),
('NUKS', '노트', '기타', '발신', 'O', 383, 'Y', ''),
('NCRS', '노트', 'Craft', '발신', 'O', 384, 'Y', ''),
('AGCR', '일정', '구글캘린더일정', '수신', 'I', 385, 'N', ''),
('AGCS', '일정', '구글캘린더일정', '발신', 'O', 386, 'Y', ''),
('AGLR', '일정', '구글캘린더메일', '수신', 'I', 387, 'N', ''),
('AGLS', '일정', '구글캘린더메일', '발신', 'O', 388, 'Y', ''),
('ANCS', '일정', '네이버 캘린더', '발신', 'O', 389, 'Y', ''),
('ZTN-', '기타 서비스', 'Telnet', '-', 'O', 390, 'Y', ''),
('ZXT-', '기타 서비스', 'Xterm', '-', 'O', 391, 'Y', ''),
('ZRL-', '기타 서비스', 'R-Login', '-', 'O', 392, 'Y', ''),
('ZNP-', '기타 서비스', 'NNTP', '-', 'O', 393, 'Y', ''),
('ZPC-', '기타 서비스', 'PC 보안', '-', 'O', 394, 'N', ''),
('ZSH-', '기타 서비스', 'SSH', 'SSH 세션 정보', 'O', 395, 'Y', ''),
('XX1R', '모니터링_제외', '미분류_타입1', '수신', 'I', 396, 'Y', ''),
('XX1S', '모니터링_제외', '미분류_타입1', '발신', 'O', 397, 'Y', ''),
('XX2R', '모니터링_제외', '미분류_타입2', '수신', 'I', 398, 'Y', ''),
('XX2S', '모니터링_제외', '미분류_타입2', '발신', 'O', 399, 'Y', ''),
('XX3R', '모니터링_제외', '미분류_타입3', '수신', 'I', 400, 'Y', ''),
('XX3S', '모니터링_제외', '미분류_타입3', '발신', 'O', 401, 'Y', ''),
('XU1R', '모니터링_제외', '웹서비스(미분류)_타입1', '수신', 'I', 402, 'Y', ''),
('XU1S', '모니터링_제외', '웹서비스(미분류)_타입1', '발신', 'O', 403, 'Y', ''),
('XU2R', '모니터링_제외', '웹서비스(미분류)_타입2', '수신', 'I', 404, 'Y', ''),
('XU2S', '모니터링_제외', '웹서비스(미분류)_타입2', '발신', 'O', 405, 'Y', ''),
('XU3R', '모니터링_제외', '웹서비스(미분류)_타입3', '수신', 'I', 406, 'Y', ''),
('XU3S', '모니터링_제외', '웹서비스(미분류)_타입3', '발신', 'O', 407, 'Y', ''),
('XU4R', '모니터링_제외', '필수 로깅', '수신', 'I', 408, 'Y', ''),
('XU4S', '모니터링_제외', '필수 로깅', '발신', 'O', 409, 'Y', ''),
('UWSD', '웹서비스(미분류)', '웹 발신', '첨부 - 문서타입', 'O', 410, 'Y', ''),
('UWSE', '웹서비스(미분류)', '웹 발신', '첨부 - 문서아님', 'O', 411, 'Y', ''),
('UWSU', '웹서비스(미분류)', '웹 발신', '첨부 없음', 'O', 412, 'Y', ''),
('UWSH', '웹서비스(미분류)', '웹 발신', '중요도(상)', 'O', 413, 'Y', ''),
('UWSM', '웹서비스(미분류)', '웹 발신', '중요도(중)', 'O', 414, 'Y', ''),
('UWSL', '웹서비스(미분류)', '웹 발신', '중요도(하)', 'O', 415, 'Y', ''),
('UX1R', '웹서비스(미분류)', '미분류_타입1', '수신', 'I', 416, 'Y', ''),
('UX1S', '웹서비스(미분류)', '미분류_타입1', '발신', 'O', 417, 'Y', ''),
('UX2R', '웹서비스(미분류)', '미분류_타입2', '수신', 'I', 418, 'Y', ''),
('UX2S', '웹서비스(미분류)', '미분류_타입2', '발신', 'O', 419, 'Y', ''),
('UX3R', '웹서비스(미분류)', '미분류_타입3', '수신', 'I', 420, 'Y', ''),
('UX3S', '웹서비스(미분류)', '미분류_타입3', '발신', 'O', 421, 'Y', ''),
('UWRD', '웹서비스(미분류)', '웹 수신', '첨부 - 문서타입', 'I', 422, 'Y', ''),
('UWRE', '웹서비스(미분류)', '웹 수신', '첨부 - 문서아님', 'I', 423, 'Y', ''),
('UWRU', '웹서비스(미분류)', '웹 수신', '첨부 없음', 'I', 424, 'Y', ''),
('BWSD', '웹서비스(업무)', '업무 발신', '첨부 - 문서타입', 'O', 425, 'Y', ''),
('BWSE', '웹서비스(업무)', '업무 발신', '첨부 - 문서아님', 'O', 426, 'Y', ''),
('BWSU', '웹서비스(업무)', '업무 발신', '첨부 없음', 'O', 427, 'Y', ''),
('BWRD', '웹서비스(업무)', '업무 수신', '첨부 - 문서타입', 'I', 428, 'Y', ''),
('BWRE', '웹서비스(업무)', '업무 수신', '첨부 - 문서아님', 'I', 429, 'Y', ''),
('BWRU', '웹서비스(업무)', '업무 수신', '첨부 없음', 'I', 430, 'Y', ''),
('TWEC', '화상회의', 'Webex', '채팅', 'O', 431, 'Y', 'MSG'),
('TWEF', '화상회의', 'Webex', '파일전송', 'O', 432, 'Y', 'MSG'),
('TWEJ', '화상회의', 'Webex', '참여', 'O', 433, 'Y', 'MSG'),
('TWEL', '화상회의', 'Webex', '떠남', 'O', 434, 'Y', 'MSG'),
('TZOC', '화상회의', 'Zoom', '채팅', 'O', 435, 'Y', 'MSG'),
('TZOF', '화상회의', 'Zoom', '파일전송', 'O', 436, 'Y', 'MSG'),
('TZOJ', '화상회의', 'Zoom', '참여', 'O', 437, 'Y', 'MSG'),
('TZOL', '화상회의', 'Zoom', '떠남', 'O', 438, 'Y', 'MSG'),
('TTMC', '화상회의', 'Teams', '채팅', 'O', 439, 'Y', 'MSG'),
('TTMF', '화상회의', 'Teams', '파일전송', 'O', 440, 'Y', 'MSG'),
('TTMJ', '화상회의', 'Teams', '참여', 'O', 441, 'Y', 'MSG'),
('TTML', '화상회의', 'Teams', '떠남', 'O', 442, 'Y', 'MSG'),
('TSKC', '화상회의', 'Skype', '채팅', 'O', 443, 'Y', 'MSG'),
('TSKF', '화상회의', 'Skype', '파일전송', 'O', 444, 'Y', 'MSG'),
('TSKJ', '화상회의', 'Skype', '참여', 'O', 445, 'Y', 'MSG'),
('TSKL', '화상회의', 'Skype', '떠남', 'O', 446, 'Y', 'MSG'),
('TJMC', '화상회의', 'JoinME', '채팅', 'O', 447, 'Y', 'MSG'),
('TJMF', '화상회의', 'JoinME', '파일전송', 'O', 448, 'Y', 'MSG'),
('TAMC', '화상회의', 'Amazon Chime', '채팅', 'O', 449, 'Y', 'MSG'),
('TAMF', '화상회의', 'Amazon Chime', '파일전송', 'O', 450, 'Y', 'MSG'),
('TBJC', '화상회의', 'BlueJeans', '채팅', 'O', 451, 'Y', 'MSG'),
('TTDS', '화상회의', 'Tl;dv', '채팅', 'O', 452, 'Y', 'MSG'),
('LNVS', '번역기', '파파고 번역', '발신', 'O', 453, 'Y', ''),
('LGGS', '번역기', '구글 번역', '발신', 'O', 454, 'Y', ''),
('LGPS', '번역기', '구글 번역 플러그인', '발신', 'O', 455, 'Y', ''),
('LDES', '번역기', 'Deepl', '발신', 'O', 456, 'Y', ''),
('LBIS', '번역기', 'Bing 번역', '발신', 'O', 457, 'Y', ''),
('LYMS', '번역기', 'Yandex 번역', '발신', 'O', 458, 'Y', ''),
('LGAS', '번역기', 'Google Cloud Translation Api', '발신', 'O', 459, 'Y', ''),
('LFTS', '번역기', 'Flitto', '발신', 'O', 460, 'Y', ''),
('LOTS', '번역기', 'O-Translator', '발신', 'O', 461, 'Y', ''),
('LUKS', '번역기', '기타', '발신', 'O', 462, 'Y', ''),
('LTRS', '번역기', 'Translate', '발신', 'O', 463, 'Y', ''),
('LODS', '번역기', 'onlinedoctranslator', '발신', 'O', 464, 'Y', ''),
('IGBS', '생성형 AI', '구글 Gemini', '발신', 'O', 465, 'Y', ''),
('IGBR', '생성형 AI', '구글 Gemini', '수신', 'I', 466, 'Y', ''),
('IBIS', '생성형 AI', ' Microsoft Copilot', '발신', 'O', 467, 'Y', ''),
('IWTS', '생성형 AI', 'Wrtn', '발신', 'O', 468, 'Y', ''),
('IGPS', '생성형 AI', 'ChatGPT', '발신', 'O', 469, 'Y', ''),
('IGPR', '생성형 AI', 'ChatGPT', '수신', 'I', 470, 'Y', ''),
('IDAS', '생성형 AI', 'Dall-E', '발신', 'O', 471, 'Y', ''),
('IGCS', '생성형 AI', 'Github Copilot', '발신', 'O', 472, 'Y', ''),
('IGCR', '생성형 AI', 'Github Copilot', '수신', 'I', 473, 'Y', ''),
('IYCS', '생성형 AI', 'YouChat', '발신', 'O', 474, 'Y', ''),
('ICSS', '생성형 AI', 'Chatsonic', '발신', 'O', 475, 'Y', ''),
('IRPS', '생성형 AI', 'Replika', '발신', 'O', 476, 'Y', ''),
('IPPS', '생성형 AI', 'Perplexity', '발신', 'O', 477, 'Y', ''),
('IPPR', '생성형 AI', 'Perplexity', '수신', 'I', 478, 'Y', ''),
('ITCS', '생성형 AI', 'TextCortex', '발신', 'O', 479, 'Y', ''),
('IPHS', '생성형 AI', 'Phind', '발신', 'O', 480, 'Y', ''),
('IPOS', '생성형 AI', 'Poe', '발신', 'O', 481, 'Y', ''),
('IHFS', '생성형 AI', 'Hugging Face', '발신', 'O', 482, 'Y', ''),
('IHFR', '생성형 AI', 'Hugging Face', '수신', 'I', 483, 'Y', ''),
('ICPS', '생성형 AI', 'Copy.AI', '발신', 'O', 484, 'Y', ''),
('IHWS', '생성형 AI', 'HyperWrite', '발신', 'O', 485, 'Y', ''),
('IDPS', '생성형 AI', 'DeepAI', '발신', 'O', 486, 'Y', ''),
('IACS', '생성형 AI', 'AskCodi', '발신', 'O', 487, 'Y', ''),
('IACR', '생성형 AI', 'AskCodi', '수신', 'I', 488, 'Y', ''),
('INAS', '생성형 AI', 'Native', '발신', 'O', 489, 'Y', ''),
('INFS', '생성형 AI', 'NeuroFlash', '발신', 'O', 490, 'Y', ''),
('INOS', '생성형 AI', 'Notion AI', '발신', 'O', 491, 'Y', ''),
('INOR', '생성형 AI', 'Notion AI', '수신', 'I', 492, 'Y', ''),
('IMES', '생성형 AI', 'Merlin', '발신', 'O', 493, 'Y', ''),
('IMER', '생성형 AI', 'Merlin', '수신', 'O', 494, 'Y', ''),
('ICXS', '생성형 AI', 'CLOVA-X', '발신', 'O', 495, 'Y', ''),
('IADS', '생성형 AI', 'Adobe AI', '발신', 'O', 496, 'Y', ''),
('ICDS', '생성형 AI', 'ClipDrop', '발신', 'O', 497, 'Y', ''),
('ISBS', '생성형 AI', 'Stability.Ai', '발신', 'O', 498, 'Y', ''),
('IRMS', '생성형 AI', 'Runwayml', '발신', 'O', 499, 'Y', ''),
('IGVS', '생성형 AI', 'Google Vertex', '발신', 'O', 500, 'Y', ''),
('IGVR', '생성형 AI', 'Google Vertex', '수신', 'I', 501, 'Y', ''),
('IGLS', '생성형 AI', 'Google Colab', '발신', 'O', 502, 'Y', ''),
('ICWS', '생성형 AI', 'CodeWhisperer', '발신', 'O', 503, 'Y', ''),
('IMSS', '생성형 AI', 'Google AI Studio', '발신', 'O', 504, 'Y', ''),
('IOCS', '생성형 AI', 'Clova OCR', '발신', 'O', 505, 'Y', ''),
('IAOS', '생성형 AI', 'Azure OpenAI', '발신', 'O', 506, 'Y', ''),
('IAOR', '생성형 AI', 'Azure OpenAI', '수신', 'I', 507, 'Y', ''),
('ICUS', '생성형 AI', '네이버 CUE:', '발신', 'O', 508, 'Y', ''),
('IMJS', '생성형 AI', 'Midjourney', '발신', 'O', 509, 'Y', ''),
('ISGR', '생성형 AI', 'slidesGPT', '수신', 'I', 510, 'Y', ''),
('ISGS', '생성형 AI', 'SlidesGPT', '발신', 'O', 511, 'Y', ''),
('IDMS', '생성형 AI', 'Ai Docmaker', '발신', 'O', 512, 'Y', ''),
('IRKS', '생성형 AI', 'Reka AI', '발신', 'O', 513, 'Y', ''),
('IRKR', '생성형 AI', 'Reka AI', '수신', 'O', 514, 'Y', ''),
('ICLS', '생성형 AI', 'Claude', '발신', 'O', 515, 'Y', ''),
('ICLR', '생성형 AI', 'Claude', '수신', 'I', 516, 'Y', ''),
('ICLQ', '생성형 AI', 'Claude', '발신', 'O', 517, 'Y', ''),
('IDMR', '생성형 AI', 'AI Docmaker Attach', '수신', 'I', 518, 'Y', ''),
('IADR', '생성형 AI', 'Adobe firefly login', '수신', 'I', 519, 'Y', ''),
('IWDS', '생성형 AI', 'Dream by WOMBO', '발신', 'O', 520, 'Y', ''),
('IGAS', '생성형 AI', 'GetImg.AI', '발신', 'O', 521, 'Y', ''),
('IWKS', '생성형 AI', 'Wrks.ai', '발신', 'O', 522, 'Y', ''),
('IPSS', '생성형 AI', 'Polaris office ai', '발신', 'O', 523, 'Y', ''),
('IBGS', '생성형 AI', 'Goover AI', '발신', 'O', 524, 'Y', ''),
('IIAS', '생성형 AI', 'iAsk AI', '발신', 'O', 525, 'Y', ''),
('ISNS', '생성형 AI', 'Suno AI', '발신', 'O', 526, 'Y', ''),
('IPES', '생성형 AI', 'Perchance', '발신', 'O', 527, 'Y', ''),
('IPER', '생성형 AI', 'Perchance', '수신', 'I', 528, 'Y', ''),
('IPFS', '생성형 AI', 'ChatPDF', '발신', 'O', 529, 'Y', ''),
('IXOS', '생성형 AI', 'Exaone', '발신', 'O', 530, 'Y', ''),
('IXOR', '생성형 AI', 'Exaone', '수신', 'I', 531, 'Y', ''),
('ISOR', '생성형 AI', 'Slidesgo', '수신', 'I', 532, 'Y', ''),
('ISOS', '생성형 AI', 'Slidesgo', '발신', 'O', 533, 'Y', ''),
('IKRS', '생성형 AI', 'KREA', '발신', 'O', 534, 'Y', ''),
('ILMS', '생성형 AI', 'GoogleNotebook LM', '발신', 'O', 535, 'Y', ''),
('ICCS', '생성형 AI', 'Capcut', '발신', 'O', 536, 'Y', ''),
('IMGS', '생성형 AI', 'Magictool', '발신', 'O', 537, 'Y', ''),
('IGSS', '생성형 AI', 'Genspark', '발신', 'O', 538, 'Y', ''),
('IGSR', '생성형 AI', 'Genspark', '수신', 'I', 539, 'Y', ''),
('IFES', '생성형 AI', 'felo', '발신', 'O', 540, 'Y', ''),
('ITPS', '생성형 AI', 'Tripo3D', '발신', 'O', 541, 'Y', ''),
('ITPR', '생성형 AI', 'Tripo3D', '수신', 'I', 542, 'Y', ''),
('IELS', '생성형 AI', 'Elevenlabs', '발신', 'O', 543, 'Y', ''),
('IELR', '생성형 AI', 'Elevenlabs', '수신', 'I', 544, 'Y', ''),
('IGRS', '생성형 AI', 'Grammarly', '발신', 'O', 545, 'Y', ''),
('IVRS', '생성형 AI', 'Vrew', '발신', 'O', 546, 'Y', ''),
('INIS', '생성형 AI', 'NightCafe', '발신', 'O', 547, 'Y', ''),
('ICAS', '생성형 AI', 'CivitAI', '발신', 'O', 548, 'Y', ''),
('ILIS', '생성형 AI', 'Liner', '발신', 'O', 549, 'Y', ''),
('IBCS', '생성형 AI', 'Bing Image Creator', '발신', 'O', 550, 'Y', ''),
('IDSS', '생성형 AI', 'Deepseek', '발신', 'O', 551, 'Y', ''),
('IBDS', '생성형 AI', 'Baidu Ai', '발신', 'O', 552, 'Y', ''),
('IGIS', '생성형 AI', 'Gemini AI api', '발신', 'O', 553, 'Y', ''),
('IGIR', '생성형 AI', 'Gemini AI api', '수신', 'I', 554, 'Y', ''),
('IDTS', '생성형 AI', '에이닷', '발신', 'O', 555, 'Y', ''),
('IDTR', '생성형 AI', '에이닷', '수신', 'I', 556, 'Y', ''),
('IQBS', '생성형 AI', 'QuillBot', '발신', 'O', 557, 'Y', ''),
('ICHS', '생성형 AI', 'Character ai', '발신', 'O', 558, 'Y', ''),
('ISRS', '생성형 AI', 'Sora/Openai', '발신', 'O', 559, 'Y', ''),
('ISRR', '생성형 AI', 'Sora/Openai', '수신', 'I', 560, 'Y', ''),
('INNS', '생성형 AI', 'Nano AI', '발신', 'O', 561, 'Y', ''),
('IDBS', '생성형 AI', 'Doubao', '발신', 'O', 562, 'Y', ''),
('ITYS', '생성형 AI', 'Tongyi', '발신', 'O', 563, 'Y', ''),
('IYBS', '생성형 AI', 'Yuanbao', '발신', 'O', 564, 'Y', ''),
('IYYS', '생성형 AI', 'Yiyan', '발신', 'O', 565, 'Y', ''),
('IKMS', '생성형 AI', 'Kimi', '발신', 'O', 566, 'Y', ''),
('IBAS', '생성형 AI', 'Baichuan', '발신', 'O', 567, 'Y', ''),
('ITGS', '생성형 AI', 'Tiangong', '발신', 'O', 568, 'Y', ''),
('ISDS', '생성형 AI', 'Stable Diffusion', '발신', 'O', 569, 'Y', ''),
('IGOS', '생성형 AI', 'Grok', '발신', 'O', 570, 'Y', ''),
('IGOR', '생성형 AI', 'Grok', '수신', 'O', 571, 'Y', ''),
('ICGS', '생성형 AI', 'ChatGLM', '발신', 'O', 572, 'Y', ''),
('INKS', '생성형 AI', 'Napkin AI', '발신', 'O', 573, 'Y', ''),
('IBIR', '생성형 AI', 'Microsoft Copilot', '수신', 'I', 574, 'Y', ''),
('IOOS', '생성형 AI', 'AI Goormee', '발신', 'O', 575, 'Y', ''),
('IABS', '생성형 AI', 'Allibee', '발신', 'O', 576, 'Y', ''),
('ILXS', '생성형 AI', 'Lexis+', '발신', 'O', 577, 'Y', ''),
('ILAS', '생성형 AI', 'SuperLawyer', '발신', 'O', 578, 'Y', ''),
('ICOS', '생성형 AI', 'CoCounsel', '발신', 'O', 579, 'Y', ''),
('IANS', '생성형 AI', 'Anthropic', '발신', 'O', 580, 'Y', ''),
('IANR', '생성형 AI', 'Anthropic', '수신', 'I', 581, 'Y', ''),
('ISIS', '생성형 AI', 'Sider AI', '발신', 'O', 582, 'Y', ''),
('IGMS', '생성형 AI', 'Gamma', '발신', 'O', 583, 'Y', ''),
('IGMR', '생성형 AI', 'Gamma', '수신', 'I', 584, 'Y', ''),
('ICRS', '생성형 AI', 'Cursor', '발신', 'O', 585, 'Y', ''),
('ICRR', '생성형 AI', 'Cursor', '수신', 'O', 586, 'Y', ''),
('IMAS', '생성형 AI', 'ManusAI', '발신', 'O', 587, 'Y', ''),
('IMTS', '생성형 AI', 'Mistral AI', '발신', 'O', 588, 'Y', ''),
('ICBS', '생성형 AI', 'Cline', '발신', 'O', 589, 'Y', ''),
('IWBS', '생성형 AI', 'Weight & Biases', '발신', 'O', 590, 'Y', ''),
('IWBR', '생성형 AI', 'Weight & Biases', '수신', 'I', 591, 'Y', ''),
('ILLS', '생성형 AI', 'Lilys AI', '발신', 'O', 592, 'Y', ''),
('IUKS', '생성형 AI', '기타', '발신', 'O', 593, 'Y', ''),
('IGES', '생성형 AI', 'Gemini Code Assist', '발신', 'O', 594, 'Y', ''),
('IGER', '생성형 AI', 'Gemini Code Assist', '수신', 'I', 595, 'Y', ''),
('IOES', '생성형 AI', 'Codex/OpenAI', '발신', 'O', 596, 'Y', ''),
('IOER', '생성형 AI', 'Codex/OpenAI', '수신', 'I', 597, 'Y', ''),
('IJLS', '생성형 AI', 'Jules', '발신', 'O', 598, 'Y', ''),
('IHVS', '생성형 AI', 'Harvey', '발신', 'O', 599, 'Y', ''),
('IXAS', '생성형 AI', 'x.AI', '발신', 'O', 600, 'Y', ''),
('ICES', '생성형 AI', 'Cohere', '발신', 'O', 601, 'Y', ''),
('IWTR', '생성형 AI', 'wrtn', '수신', 'I', 602, 'Y', ''),
('ICHR', '생성형 AI', 'Character ai', '수신', 'I', 603, 'Y', ''),
('IOWR', '생성형 AI', 'Open WebUi', '수신', 'I', 604, 'Y', ''),
('IOWS', '생성형 AI', 'Open WebUi', '발신', 'O', 605, 'Y', ''),
('ISKS', '생성형 AI', 'Skywork', '발신', 'O', 606, 'Y', ''),
('IVES', '생성형 AI', 'Veo3', '발신', 'O', 607, 'Y', ''),
('IGTS', '생성형 AI', 'Gptoss', '발신', 'O', 608, 'Y', ''),
('ILRS', '생성형 AI', 'LMArena', '발신', 'O', 609, 'Y', ''),
('ILRR', '생성형 AI', 'LMArena', '수신', 'I', 610, 'Y', ''),
('IASS', '생성형 AI', 'Chat & Ask AI', '발신', 'O', 611, 'Y', ''),
('IASR', '생성형 AI', 'Chat & Ask AI', '수신', 'I', 612, 'Y', ''),
('IARR', '생성형 AI', 'Android Studio', '수신', 'O', 613, 'Y', ''),
('IARS', '생성형 AI', 'Android Studio', '발신', 'O', 614, 'Y', ''),
('IORR', '생성형 AI', 'Open Router', '수신', 'O', 615, 'Y', ''),
('IORS', '생성형 AI', 'Open Router', '발신', 'O', 616, 'Y', ''),
('IAMS', '생성형 AI', '구글 AI 모드', '발신', 'O', 617, 'Y', ''),
('IAMR', '생성형 AI', '구글 AI 모드', '수신', 'O', 618, 'Y', ''),
('ITIS', '생성형 AI', 'Timely GPT', '발신', 'O', 619, 'Y', ''),
('ITIR', '생성형 AI', 'Timely GPT', '수신', 'O', 620, 'Y', ''),
('IOTS', '생성형 AI', 'Otter.ai', '발신', 'O', 621, 'Y', ''),
('IOTR', '생성형 AI', 'Otter.ai', '수신', 'O', 622, 'Y', ''),
('IAGS', '생성형 AI', 'Gemini Enterprise', '발신', 'O', 623, 'Y', ''),
('IAGR', '생성형 AI', 'Gemini Enterprise', '수신', 'I', 624, 'Y', ''),
('ISPS', '생성형 AI', 'Soda Pdf', '발신', 'O', 625, 'Y', ''),
('ISPR', '생성형 AI', 'Soda Pdf', '수신', 'I', 626, 'Y', ''),
('IFPS', '생성형 AI', 'FreePik', '발신', 'O', 627, 'Y', ''),
('IFPR', '생성형 AI', 'FreePik', '수신', 'I', 628, 'Y', ''),
('ITOS', '생성형 AI', 'Tigris AI+', '발신', 'O', 629, 'Y', ''),
('IATS', '생성형 AI', 'Antigravity', '발신', 'O', 630, 'Y', ''),
('IATR', '생성형 AI', 'Antigravity', '수신', 'I', 631, 'Y', ''),
('IODS', '생성형 AI', 'OpenCode AI', '발신', 'O', 632, 'Y', ''),
('IODR', '생성형 AI', 'OpenCode AI', '수신', 'I', 633, 'Y', ''),
('ITNS', '생성형 AI', 'Tunee AI', '발신', 'O', 634, 'Y', ''),
('ITNR', '생성형 AI', 'Tunee AI', '수신', 'I', 635, 'Y', ''),
('IWES', '생성형 AI', 'WeeAI', '발신', 'O', 636, 'Y', ''),
('IWER', '생성형 AI', 'WeeAI', '수신', 'I', 637, 'Y', ''),
('IHAS', '생성형 AI', 'Hailuo AI', '발신', 'O', 638, 'Y', ''),
('IHAR', '생성형 AI', 'Hailuo AI', '수신', 'I', 639, 'Y', ''),
('IHIS', '생성형 AI', 'Higgsfield', '발신', 'O', 640, 'Y', ''),
('IKLS', '생성형 AI', 'Kling AI', '발신', 'O', 641, 'Y', ''),
('IKLR', '생성형 AI', 'Kling AI', '수신', 'I', 642, 'Y', ''),
('IOAS', '생성형 AI', 'OpenAI API', '발신', 'O', 643, 'Y', ''),
('IOAR', '생성형 AI', 'OpenAI API', '수신', 'I', 644, 'Y', ''),
('ICKS', '생성형 AI', 'CudekAI', '발신', 'O', 645, 'Y', ''),
('ICKR', '생성형 AI', 'CudekAI', '수신', 'I', 646, 'Y', ''),
('IAKS', '생성형 AI', 'Amazonbedrock', '발신', 'O', 647, 'Y', ''),
('IAKR', '생성형 AI', 'Amazonbedrock', '수신', 'I', 648, 'Y', ''),
('IBIQ', '생성형 AI', 'Microsoft Copilot', '발신', 'O', 649, 'Y', ''),
('IBIZ', '생성형 AI', 'Microsoft Copilot', '수신', 'I', 650, 'Y', ''),
('IINS', '생성형 AI', 'IN7', '발신', 'O', 651, 'Y', ''),
('IINR', '생성형 AI', 'IN7', '수신', 'I', 652, 'Y', ''),
('IINQ', '생성형 AI', 'IN7', '발신', 'O', 653, 'Y', ''),
('IGXS', '생성형 AI', 'Google Labs', '발신', 'O', 654, 'Y', ''),
('IGXR', '생성형 AI', 'Google Labs', '수신', 'I', 655, 'Y', ''),
('IDCS', '생성형 AI', 'Claude Console', '발신', 'O', 656, 'Y', ''),
('IDCR', '생성형 AI', 'Claude Console', '수신', 'I', 657, 'Y', ''),
('IDCQ', '생성형 AI', 'Claude Console', '발신', 'O', 658, 'Y', ''),
('IPZS', '생성형 AI', 'Pulze', '발신', 'O', 659, 'Y', ''),
('IPZQ', '생성형 AI', 'Pulze', '발신', 'O', 660, 'Y', ''),
('IMSR', '생성형 AI', 'Google Ai Studio', '수신', 'I', 661, 'Y', ''),
('ILMR', '생성형 AI', 'Google Notebook LM', '수신', 'I', 662, 'Y', ''),
('PDOS', '프로젝트', 'dooray', '발신', 'O', 663, 'Y', ''),
('PGIS', '프로젝트', 'github', '발신', 'O', 664, 'Y', ''),
('PGLS', '프로젝트', 'Glassdoor', '발신', 'O', 665, 'Y', ''),
('PJDS', '프로젝트', '잔디', '발신', 'O', 666, 'Y', ''),
('PITS', '프로젝트', 'Google Issue Tracker', '발신', 'O', 667, 'Y', ''),
('EBDR', '그룹웨어', '게시', '수신', 'I', 668, 'Y', ''),
('EBD-', '그룹웨어', '게시', '발신', 'O', 669, 'Y', ''),
('EBBR', '그룹웨어', '게시판', '수신', 'I', 670, 'Y', ''),
('EBBS', '그룹웨어', '게시판', '발신', 'O', 671, 'Y', ''),
('EBBF', '그룹웨어', '게시판', '파일수신', 'I', 672, 'Y', ''),
('EAAR', '그룹웨어', '결재', '수신', 'I', 673, 'Y', ''),
('EAAS', '그룹웨어', '결재', '발신', 'O', 674, 'Y', ''),
('EAAG', '그룹웨어', '결재', '통보 - 수신', 'I', 675, 'Y', ''),
('EAAP', '그룹웨어', '결재', '통보 - 발신', 'O', 676, 'Y', ''),
('EAAF', '그룹웨어', '결재', '파일수신', 'I', 677, 'Y', ''),
('EMMR', '그룹웨어', '메일', '그룹웨어 수신', 'I', 678, 'Y', ''),
('EMMS', '그룹웨어', '메일', '그룹웨어 발신', 'O', 679, 'Y', ''),
('EMMG', '그룹웨어', '메일', 'OWA 수신', 'I', 680, 'Y', ''),
('EMMP', '그룹웨어', '메일', 'OWA 발신', 'O', 681, 'Y', ''),
('EMMD', '그룹웨어', '메일', 'RPC 수신', 'I', 682, 'Y', ''),
('EMMU', '그룹웨어', '메일', 'RPC 발신', 'O', 683, 'Y', ''),
('EMMC', '그룹웨어', '메일', '수신', 'I', 684, 'Y', ''),
('EMML', '그룹웨어', '메일', '발신', 'O', 685, 'Y', ''),
('EMM1', '그룹웨어', '메일', '보안등급1', 'O', 686, 'Y', ''),
('EMM2', '그룹웨어', '메일', '보안등급2', 'O', 687, 'Y', ''),
('EMM3', '그룹웨어', '메일', '보안등급3', 'O', 688, 'Y', ''),
('EMM4', '그룹웨어', '메일', '보안등급4', 'O', 689, 'Y', ''),
('EMMA', '그룹웨어', '메일', '임시(자동)', 'O', 690, 'Y', ''),
('EMMT', '그룹웨어', '메일', '임시(수동)', 'O', 691, 'Y', ''),
('EMMK', '그룹웨어', '메일', 'Outlook - 수신', 'I', 692, 'Y', ''),
('EMMO', '그룹웨어', '메일', 'Outlook - 발신', 'O', 693, 'Y', ''),
('EMMB', '그룹웨어', '메일', '그룹웨어 예약메일', 'O', 694, 'Y', ''),
('EMBR', '그룹웨어', '모바일', '수신', 'I', 695, 'Y', ''),
('EMB-', '그룹웨어', '모바일', '발신', 'O', 696, 'Y', ''),
('EWSR', '그룹웨어', '웹서비스', '수신', 'I', 697, 'Y', ''),
('EWS-', '그룹웨어', '웹서비스', '발신', 'O', 698, 'Y', ''),
('EPUR', '그룹웨어', '일반', '수신', 'I', 699, 'Y', ''),
('EPU-', '그룹웨어', '일반', '발신', 'O', 700, 'Y', ''),
('EAU-', '그룹웨어', '일반(자동전달)', '자동전달', 'O', 701, 'Y', ''),
('ESCR', '그룹웨어', '일정 명함', '수신', 'I', 702, 'Y', ''),
('ESC-', '그룹웨어', '일정 명함', '발신', 'O', 703, 'Y', ''),
('EMF-', '그룹웨어', '파일 다운로드', '-', 'I', 704, 'Y', ''),
('EMU-', '그룹웨어', '기타', '', 'O', 705, 'Y', ''),
('EMDR', '그룹웨어', '드라이브', '수신', 'I', 706, 'Y', ''),
('EMDS', '그룹웨어', '드라이브', '발신', 'O', 707, 'Y', ''),
('ECIS', '그룹웨어', 'Samsung cic', '발신', 'O', 708, 'Y', ''),
('EMER', '그룹웨어', '메신저', '수신', 'I', 709, 'Y', ''),
('EMES', '그룹웨어', '메신저', '발신', 'O', 710, 'Y', ''),
('EMEC', '그룹웨어', '메신저', '채팅', 'O', 711, 'Y', 'MSG'),
('EZQC', '그룹웨어', 'Zohocliq', '채팅', 'O', 712, 'Y', ''),
('EZQS', '그룹웨어', 'Zohocliq', '캘린더', 'O', 713, 'Y', ''),
('EKWS', '그룹웨어', '카카오워크', '발신', 'O', 714, 'Y', ''),
('ECAS', '그룹웨어', '일정', '발신', 'O', 715, 'Y', ''),
('ETOS', '그룹웨어', 'Tigris', '기타', 'O', 716, 'Y', ''),
('ETOC', '그룹웨어', 'Tigris', '메신저', 'O', 717, 'Y', ''),
('ETOD', '그룹웨어', 'Tigris', '드라이브', 'O', 718, 'Y', ''),
('ETOA', '그룹웨어', 'Tigris', '결재', 'O', 719, 'Y', ''),
('DCCS', '편집기', 'Clip Champ', '발신', 'O', 720, 'Y', ''),
('DFGS', '편집기', 'Figma', '발신', 'O', 721, 'Y', ''),
('DOVS', '편집기', 'Overleaf', '발신', 'O', 722, 'Y', ''),
('DOVR', '편집기', 'Overleaf', '수신', 'I', 723, 'Y', ''),
('DPKS', '편집기', 'Plunker', '발신', 'O', 724, 'Y', ''),
('DNWS', '편집기', 'Namu.wiki', '발신', 'O', 725, 'Y', ''),
('DWKS', '편집기', 'WikiPedia', '발신', 'O', 726, 'Y', ''),
('DAES', '편집기', 'Adobe Express', '발신', 'O', 727, 'Y', ''),
('DSMS', '편집기', 'Sketchmon', '발신', 'O', 728, 'Y', ''),
('DGSS', '편집기', 'Google Site', '발신', 'O', 729, 'Y', ''),
('DCVS', '편집기', 'Canva', '발신', 'O', 730, 'Y', ''),
('DMBS', '편집기', '망고보드', '발신', 'O', 731, 'Y', ''),
('DMTS', '편집기', '망고툰', '발신', 'O', 732, 'Y', ''),
('JBDS', '웹사이트', 'Baidu', '발신', 'O', 733, 'Y', ''),
('JANS', '웹사이트', 'Anthropic', '발신', 'O', 734, 'Y', ''),
('JKAS', '웹사이트', 'Kaggle', '발신', 'O', 735, 'Y', ''),
('JJPS', '웹사이트', 'justpaste.it', '발신', 'O', 736, 'Y', ''),
('JPBS', '웹사이트', 'pastebin.com', '발신', 'O', 737, 'Y', ''),
('JNNS', '웹사이트', 'n8n', '발신', 'O', 738, 'Y', ''),
('JGHS', '웹사이트', 'Google cloud console', '발신', 'O', 739, 'Y', ''),
('JALS', '웹사이트', 'AnessLab', '발신', 'O', 740, 'Y', ''),
('JCCS', '웹사이트', 'CMCC [GUI-AGENT]', '발신', 'O', 741, 'Y', ''),
('JOTS', '웹사이트', 'Otter.ai', '발신', 'O', 742, 'Y', ''),
('JMLS', '웹사이트', 'Menlosecurity', '발신', 'O', 743, 'Y', ''),
('JHFS', '웹사이트', 'Hugging Face', '발신', 'O', 744, 'Y', ''),
('JSNS', '웹사이트', 'AWS SNS', '발신', 'O', 745, 'Y', ''),
('JAGS', '웹사이트', 'AWS API Gateway', '발신', 'O', 746, 'Y', ''),
('JASS', '웹사이트', 'AWS SSM', '발신', 'O', 747, 'Y', ''),
('RGUS', '원격접속', '아파치 과카몰리', '발신', 'O', 748, 'Y', ''),
('RGUR', '원격접속', '아파치 과카몰리', '수신', 'I', 749, 'Y', ''),
('KAAR', '웹서비스(분류)', '웹 수신', '수신', 'I', 750, 'Y', ''),
('KAAS', '웹서비스(분류)', '웹 발신', '발신', 'O', 751, 'Y', '');

UPDATE UI_SERVICE
SET USE_YN = 'Y'
WHERE USE_YN = '';

UPDATE UI_SERVICE
SET SERVICENM_LV2 = 'Microsoft Copilot'
WHERE SERVICECD = 'IBIS';

DELETE FROM UI_SERVICE
WHERE SERVICECD = 'ITMS';

/* UI MENU */
DELETE FROM UI_MENU;
INSERT INTO UI_MENU (`MENU_ID`, `MENU_DEFAULT_NAME`, `P_MENU_ID`, `PKG_TYPE`, `MENU_AUTH`, `MENU_LINK`, `MENU_ICON`, `MENU_ORDER`, `MENU_USEYN`, `MENU_IMG_PATH`)  VALUES
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


UPDATE UI_CONF
SET VAL = '' , DEFAULT_VAL=''
WHERE CONF_ID='message.epmsg.val' AND DEFAULT_VAL = 'N';

UPDATE UI_CONF
SET VAL = 'true' , DEFAULT_VAL='true'
WHERE CONF_ID='info.feedback.used' AND DEFAULT_VAL = 'false';


REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('AN', '주소(도로명, 지번)', NULL,'N');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('BRN', '사업자 등록번호', NULL,'N');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('CN', '카드번호', NULL,'N');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('CPN', '법인 등록번호', NULL,'N');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('CRN', '자동차 등록번호', NULL,'N');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('DN', '운전면허번호', NULL,'N');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('DRM', 'DRM 파일', NULL,'A');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('FN', '외국인 등록번호', NULL,'N');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('IMEI', 'IMEI', NULL,'N');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('MCN', 'MAC 주소', NULL,'N');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('MN', '휴대전화번호', NULL,'N');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('PN', '여권번호', NULL,'N');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('SN', '주민번호', NULL,'N');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('SSN', '사회 보장번호', NULL,'N');


/* 이상행위의심*/
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('ID', '송수신자 동일아이디', NULL,'A');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('RS', '수신처 오지정 전송', NULL,'A');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('EC', '확장자 변조 파일', NULL,'A');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('EF', '암호화 파일', NULL,'A');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('LTO', '대용량 본문내용 사외발송', NULL,'A');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('LAO', '대용량 첨부파일 사외발송', NULL,'A');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('LF', '대용량 파일 FTP 전송', NULL,'A');

REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('LAOP', '대용량의 동일종류 첨부파일 하루 3회이상 외부전송', NULL,'A');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('FCA', '타국에서 접속', NULL,'A');
REPLACE INTO UI_REGEXP (CODE, NAME, REGEX,CODE_TYPE) VALUES('AOH', '평균 접속 시간대 외의 접속', NULL,'A');


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

CREATE TABLE IF NOT EXISTS UI_PATTERN_EXCEPT(
    PATTERN_LOG_SEQ  INT(11)  NOT NULL    COMMENT '패턴 예외처리 일련번호',
    PRIVATETYPE  VARCHAR(128)  NOT NULL    COMMENT '패턴종류',
    PATTERN  VARCHAR(128)  NOT NULL    COMMENT '해당 값',
    CREATE_USER varchar(30) DEFAULT NULL COMMENT '작성자',
    CREATE_DT  DATETIME  NULL    COMMENT '작성일',
    USE_YN  CHAR(1)  NOT NULL  DEFAULT 'Y'  COMMENT '사용 여부(Y:사용, N:사용안함(삭제) )',
    PRIMARY KEY (PATTERN_LOG_SEQ)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='패턴 예외 정책';

INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('content.transfer','위에 있는 내용을 한글로 번역해죠','qwen2.5:1.5b','상세보기 - 번역');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('content.keyword','위에 내용에서 주제키워드 단어로 10개 추출해죠','qwen2.5:1.5b','상세보기 - 키워드요약');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('content.summary','위에 있는 내용을 100자이내로 한글로 요약해죠','qwen2.5:1.5b','상세보기 - 내용요약');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('content.analysis','위에 있는 내용은 인터넷 패킷데이터를 텍스트로 표현한거야 이 부분을 분석해서 어떤 서비스 인지 한글로 알려죠','qwen2.5:1.5b','상세보기 - 내용분석');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('url.analysis','위에 있는 통신하는 URL 주소가 어떤 서비스인지 간략하게 알려줄수 있어?','qwen2.5:1.5b','상세보기 - URL 분석');
INSERT IGNORE INTO UI_LLM(LLM_CONF,LLM_PROMPT,LLM_MODEL,LLM_CONTENT) VALUES ('value.analysis','분석 요청을 할게 {{path_prompt}}  <- 주소에서  {{trans_type}}  타입으로 전송된 데이터인데 데이터 형식은 {{key_prompt}}:{{value_prompt}} 이렇게돼  해당 내용이 무슨 기능인지 확인해줘 그리고 해당 내용의 보안취약점도 분석해서 짧게 요약해줘','qwen2.5:1.5b','값 분석');


UPDATE UI_LLM SET LLM_MODEL = 'qwen2.5:1.5b' WHERE LLM_MODEL='gemma2:27b';

UPDATE UI_DEVICE SET DEVICE_TYPE = 'C' WHERE DEVICE_TYPE = 'A';