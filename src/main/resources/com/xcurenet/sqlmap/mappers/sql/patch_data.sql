USE EMASSPRO;

DELIMITER $$
DROP PROCEDURE IF EXISTS ALTER_TB;
CREATE PROCEDURE `ALTER_TB`(IN my_table varchar(50), IN col_name varchar (50), IN sql_query varchar (200))
BEGIN
    IF (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = my_table AND COLUMN_NAME = col_name)=0 THEN
BEGIN
        SET @ddl = sql_query;
PREPARE STMT FROM @ddl;
EXECUTE STMT;
END;
END IF;
END
$$
DELIMITER ;

CALL ALTER_TB( 'UI_ADMIN' , 'WORK_STATUS' , 'ALTER TABLE UI_ADMIN ADD WORK_STATUS  CHAR(1)  NULL  DEFAULT \'S\' AFTER STATUS');

ALTER TABLE VENUS.UI_REGEXP MODIFY CODE varchar(255);
INSERT IGNORE  INTO UI_REGEXP(CODE, NAME, REGEX ) VALUES ('DRM', 'DRM 파일', null);

ALTER TABLE VENUS.UI_BUSI MODIFY BUSINM varchar(64) NOT NULL COMMENT '사업장 이름';
ALTER TABLE VENUS.UI_DEPT MODIFY DEPTNM varchar(256) NOT NULL COMMENT '부서 이름';
ALTER TABLE VENUS.UI_USER_EMAIL MODIFY USER_ID varchar(250) NOT NULL COMMENT '아이디';
ALTER TABLE VENUS.UI_USER_IP MODIFY USER_ID varchar(250) NOT NULL COMMENT '아이디';
ALTER TABLE VENUS.UI_JIKGUB MODIFY JIKGUBNM varchar(64) NOT NULL COMMENT '직급 이름';
ALTER TABLE VENUS.UI_JIKIN MODIFY JIKINNM varchar(64) NOT NULL COMMENT '재직 이름';
ALTER TABLE VENUS.UI_USERS MODIFY USER_ID varchar(250) NOT NULL COMMENT '아이디';
ALTER TABLE VENUS.UI_CONSENT
    MODIFY USER_ID varchar(50) DEFAULT NULL COMMENT '사용자 아이디',
    MODIFY DEPTNM varchar(60) DEFAULT NULL COMMENT '부서 이름',
    MODIFY CREATE_NAME varchar(50) DEFAULT NULL COMMENT '등록 이름';

CALL ALTER_TB( 'UI_ADMIN' , 'RESIGN_DT' , 'ALTER TABLE VENUS.UI_ADMIN ADD RESIGN_DT datetime DEFAULT NULL  COMMENT \'퇴직\'');
CALL ALTER_TB( 'UI_ADMIN' , 'LEAVE_DT' , 'ALTER TABLE VENUS.UI_ADMIN ADD LEAVE_DT datetime DEFAULT NULL  COMMENT \'휴직\'');
CALL ALTER_TB( 'UI_ADMIN' , 'INFO_FEEDBACK' , 'ALTER TABLE VENUS.UI_ADMIN ADD INFO_FEEDBACK char(1) DEFAULT \'N\' COMMENT \'정보분류 피드백\'');
CALL ALTER_TB( 'UI_DEVICE' , 'DEVICE_SYS_EID' , 'ALTER TABLE VENUS.UI_DEVICE ADD DEVICE_SYS_EID int(11) DEFAULT NULL COMMENT \'장비 EID\'');
CALL ALTER_TB( 'UI_DOMAIN_NOLOG' , 'CREATE_USER' , 'ALTER TABLE VENUS.UI_DOMAIN_NOLOG ADD CREATE_USER varchar(30) DEFAULT NULL COMMENT \'작성자\'');
CALL ALTER_TB( 'UI_ID_NOLOG' , 'CREATE_USER' , 'ALTER TABLE VENUS.UI_ID_NOLOG ADD CREATE_USER varchar(30) DEFAULT NULL COMMENT \'작성자\'');
CALL ALTER_TB( 'UI_IP_NOLOG_DEVICE' , 'FILTER_IDX' , 'ALTER TABLE VENUS.UI_IP_NOLOG_DEVICE ADD FILTER_IDX int(11) unsigned DEFAULT NULL COMMENT \'IP FILTER OID\'');
CALL ALTER_TB( 'UI_IP_NOLOG' , 'CREATE_USER' , 'ALTER TABLE VENUS.UI_IP_NOLOG ADD CREATE_USER varchar(30) DEFAULT NULL COMMENT \'작성자\'');
CALL ALTER_TB( 'UI_SIZE_LOG' , 'CREATE_USER' , 'ALTER TABLE VENUS.UI_SIZE_LOG ADD CREATE_USER varchar(30) DEFAULT NULL COMMENT \'작성자\'');
CALL ALTER_TB( 'UI_SUBJECT_NOLOG' , 'CREATE_USER' , 'ALTER TABLE VENUS.UI_SUBJECT_NOLOG ADD CREATE_USER varchar(30) DEFAULT NULL COMMENT \'작성자\'');
CALL ALTER_TB( 'UI_URL_NOLOG' , 'CREATE_USER' , 'ALTER TABLE VENUS.UI_URL_NOLOG ADD CREATE_USER varchar(30) DEFAULT NULL COMMENT \'작성자\'');
CALL ALTER_TB( 'UI_USERS' , 'SABUN' , 'ALTER TABLE VENUS.UI_USERS ADD SABUN varchar(250) DEFAULT NULL COMMENT \'사번\'');
CALL ALTER_TB( 'UI_USERS' , 'STDT' , 'ALTER TABLE VENUS.UI_USERS ADD STDT date DEFAULT NULL COMMENT \'시작일\'');
CALL ALTER_TB( 'UI_USERS' , 'EDDT' , 'ALTER TABLE VENUS.UI_USERS ADD EDDT date DEFAULT NULL COMMENT \'종료일\'');
CALL ALTER_TB( 'UI_USERS' , 'ASCD' , 'ALTER TABLE VENUS.UI_USERS ADD ASCD varchar(20) DEFAULT NULL COMMENT \'제조번호\'');
CALL ALTER_TB( 'UI_USERS' , 'EMAIL' , 'ALTER TABLE VENUS.UI_USERS ADD EMAIL varchar(120) DEFAULT NULL COMMENT \'이메일\'');
CALL ALTER_TB( 'UI_ALARM' , 'ALARM_WEEK' , 'ALTER TABLE UI_ALARM ADD ALARM_WEEK INT(1) COMMENT \'ALARM 요일(1-월, 2-화, 3-수, 4-목, 5-금, 6-토, 7-일\' AFTER ALARM_CYCLE_VAL');
CALL ALTER_TB( 'UI_ADMIN_USER_GROUP' , 'GROUP_COLOR' , 'ALTER TABLE VENUS.UI_ADMIN_USER_GROUP ADD GROUP_COLOR varchar(7) DEFAULT \'#5376A3\' COMMENT \'그룹 색상\' AFTER GROUP_NAME');

CALL ALTER_TB( 'UI_ADMIN' , 'LOGIN_TYPE' , 'ALTER TABLE VENUS.UI_ADMIN ADD LOGIN_TYPE CHAR(1) DEFAULT \'C\'  COMMENT \'접속 로그인 방식\'');
CALL ALTER_TB( 'UI_DOWNLOAD_BATCH' , 'SKIP_ROWS' , 'ALTER TABLE VENUS.UI_DOWNLOAD_BATCH ADD SKIP_ROWS BIGINT UNSIGNED DEFAULT \'0\' COMMENT \'skip Row\'');
CALL ALTER_TB( 'UI_DOWNLOAD_BATCH' , 'UPDATE_DT' , 'ALTER TABLE VENUS.UI_DOWNLOAD_BATCH ADD UPDATE_DT DATETIME DEFAULT NULL COMMENT \'상태 Update 시간\'');

DROP FUNCTION IF EXISTS xcnenc;
DROP FUNCTION IF EXISTS xcndec;
CREATE FUNCTION xcnenc returns string soname "xcnenc.so";
CREATE FUNCTION xcndec returns string soname "xcnenc.so";

DELIMITER $$
DROP PROCEDURE IF EXISTS UI_SEARCH_KEYWORD_CHANGE_PRIMARY_KEY;
CREATE PROCEDURE UI_SEARCH_KEYWORD_CHANGE_PRIMARY_KEY()
BEGIN
    IF (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UI_SEARCH_KEYWORD' AND COLUMN_NAME = 'SK_SEQ')=0 THEN
      BEGIN
        ALTER TABLE UI_SEARCH_KEYWORD DROP PRIMARY KEY;
        ALTER TABLE UI_SEARCH_KEYWORD ADD COLUMN SK_SEQ INT(11) PRIMARY KEY AUTO_INCREMENT COMMENT '검색어 일련번호' FIRST;
      END;
    END IF;
END
$$
DELIMITER ;
CALL UI_SEARCH_KEYWORD_CHANGE_PRIMARY_KEY();


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
SELECT 'message.user.format', '#name#/#email#/#businm#/#deptnm#/#jikgubnm#/#ip#', '#name#/#email#/#businm#/#deptnm#/#jikgubnm#/#ip#', NOW() FROM DUAL
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

CREATE TABLE IF NOT EXISTS `UI_FOLDER_ADMIN` (
  `FOLDER_SEQ` int(11) NOT NULL COMMENT '사용자 폴더 시퀀스',
  `ADMIN_ID` varchar(50) NOT NULL COMMENT '운용자 아이디',
  `P_FOLDER_SEQ` int(11) DEFAULT NULL COMMENT '상위 사용자 폴더 시퀀스',
  `FOLDER_NM` varchar(128) DEFAULT NULL COMMENT '사용자 폴더/폴더명',
  `FOLDER_TYPE` char(1) DEFAULT NULL COMMENT '사용자 폴더 타입(F: FOLDER, D : USER FOLDER DATA, R: Root, U: User Root)',
  `FOLDER_ORDER` int(11) DEFAULT NULL COMMENT '사용자 폴더 순서(정렬)',
  `FOLDER_OPEN` varchar(5) DEFAULT NULL COMMENT '사용자 폴더 트리 열기/닫기',
  PRIMARY KEY (`FOLDER_SEQ`,`ADMIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='사용자 폴더 카테고리';

CREATE TABLE IF NOT EXISTS `UI_FOLDER_MESSAGE` (
  `FOLDER_SEQ` int(11) NOT NULL COMMENT '사용자 폴더 시퀀스',
  `MSGID` char(100) NOT NULL DEFAULT '' COMMENT '메시지 ID',
  `CONSENT_NO` char(30) DEFAULT NULL COMMENT '동의서 번호',
  PRIMARY KEY (`FOLDER_SEQ`,`MSGID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='사용자 정의 폴더 메시지';

CREATE TABLE IF NOT EXISTS UI_USER_GROUP (
  GROUP_CODE varchar(60) NOT NULL COMMENT '그룹 코드',
  GROUP_NAME varchar(300) DEFAULT NULL COMMENT '그룹명',
  PRIMARY KEY (GROUP_CODE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='사용자 그룹 코드';


CREATE TABLE IF NOT EXISTS UI_USER_GROUP_LIST (
  GROUP_CODE varchar(60) NOT NULL COMMENT '그룹코드',
  LIST_SEQ int(11) NOT NULL DEFAULT '0' COMMENT '그룹코드 목록 일련번호',
  USER_ID varchar(250) NOT NULL COMMENT '사용자 아이디',
  PRIMARY KEY (GROUP_CODE, LIST_SEQ)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='사용자 그룹 목록';

CREATE TABLE IF NOT EXISTS UI_DOWNLOAD_BATCH(
DOWN_SEQ  INT(11)  NOT NULL  AUTO_INCREMENT  COMMENT '다운로드 일련번호',
EXPORT_TYPE  VARCHAR(10)  NOT NULL    COMMENT '내보내기 유형(L:목록,B:본문,A:첨부파일,LB:목록+본문,LBA:목록+본문+첨부파일)',
EXPORT_FILE_EXT  VARCHAR(10)  NOT NULL    COMMENT '내보내기 파일 확장자(xlsx:엑셀,cell:한셀,csv:텍스트,pdf:목록)',
DOWN_VAL  LONGTEXT  NULL    COMMENT '검색조건 값',
ADMIN_ID  VARCHAR(50)  NOT NULL    COMMENT '운용자 ID',
REQ_DT  DATETIME  NULL    COMMENT '요청일',
END_DT  DATETIME  NULL    COMMENT '유효기간',
DOWN_STATUS  INT(11)  NULL  DEFAULT '0'  COMMENT '진행상태',
STATUS_STR  CHAR(1)  NULL    COMMENT '상태값(S:시작,I:진행중,Y:파일생성완료,X:삭제됨,E:오류)',
DOWNFILE_PATH  VARCHAR(500)  NULL    COMMENT '다운로드 파일 경로',
DOWNFILE_SIZE  BIGINT UNSIGNED  NULL    COMMENT '다운로드 파일 크기',
ING_ROWS  BIGINT UNSIGNED  NULL  DEFAULT '0'  COMMENT '진행 중 ROW',
TOTAL_ROWS  BIGINT UNSIGNED  NULL  DEFAULT '0'  COMMENT '전체 ROW',
PRIMARY KEY (DOWN_SEQ)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='다운로드 배치';

CREATE TABLE IF NOT EXISTS UI_MSG_SEARCH_LOG(
	SEARCH_SEQ  INT(11) NOT NULL AUTO_INCREMENT COMMENT '조회 일련번호',
	SEARCH_DT DATETIME NOT NULL COMMENT '조회 일자',
  	SEARCH_TYPE char(1) NOT NULL COMMENT '조회 유형(Y:지정검색, N:미지정 검색)',
	SEARCH_ID  VARCHAR(50)  NOT NULL    COMMENT '조회자 아이디',
	SEARCH_NAME  VARCHAR(50)  NOT NULL    COMMENT '조회자 이름',
	P_FILTER_SEQ  INT(11) COMMENT '상위 필터 시퀀스',
	FILTER_SEQ INT(11) COMMENT '필터 시퀀스',
	FILTER_NM  VARCHAR(128) COMMENT '필터명',
	CONSENT_NO VARCHAR(30)  COMMENT '동의서 번호',
	CONSENT_USER_ID varchar(50) COMMENT '동의서 사용자 아이디',
	CONSENT_NAME varchar(255) COMMENT '동의서 성명',
	CONDITIONS  LONGTEXT  NULL   COMMENT '검색조건 값',
PRIMARY KEY (SEARCH_SEQ)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='조회이력';

CREATE TABLE IF NOT EXISTS UI_HDFS_SIZE(
DATE datetime NOT NULL COMMENT '날짜',
REMAINING varchar(20) DEFAULT NULL COMMENT '남은 용량',
USED varchar(20) DEFAULT NULL COMMENT '사용중인 용량',
TOTAL varchar(20) DEFAULT NULL COMMENT '전체 용량',
USED_PERCENT varchar(20) DEFAULT NULL COMMENT '사용중인 용량 %',
PRIMARY KEY (DATE)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='대시보드 일별 수집 데이터 용량';

CREATE TABLE IF NOT EXISTS UI_HDFS_DIR_SIZE(
DATE datetime NOT NULL COMMENT '날짜',
TOTAL varchar(20) DEFAULT NULL COMMENT '용량',
PRIMARY KEY (DATE)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='대시보드 일별 첨부 용량';

CREATE TABLE IF NOT EXISTS UI_ADMIN_MENU(
ADMIN_ID  VARCHAR(50)  NOT NULL  COMMENT '운용자 아이디',
AUTH_ID  VARCHAR(256)  NOT NULL  COMMENT '권한 ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='운용자 메뉴 권한';

CREATE TABLE IF NOT EXISTS `UI_ADMIN_USER_GROUP` (
  `GROUP_SEQ` int(11) NOT NULL AUTO_INCREMENT,
  `ADMIN_ID` varchar(50) NOT NULL,
  `GROUP_NAME` varchar(60) DEFAULT NULL,
  `GROUP_COLOR` varchar(7) DEFAULT '#5376A3',
  `USE_YN` char(1) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`GROUP_SEQ`,`ADMIN_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='운용자별 사용자 그룹';


CREATE TABLE IF NOT EXISTS `UI_ADMIN_USER_GROUP` (
	GROUP_SEQ	INT(11)		NOT NULL AUTO_INCREMENT,
	ADMIN_ID	VARCHAR(50)	NOT NULL,
	GROUP_NAME	VARCHAR(60)	DEFAULT NULL,
	USE_YN		CHAR(1)		CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`GROUP_SEQ`,`ADMIN_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='운용자별 사용자 그룹';

CREATE TABLE IF NOT EXISTS `UI_ADMIN_USER_GROUP_LIST` (
	GROUP_SEQ	INT(11)			NOT NULL,
	USER_ID		VARCHAR(250)	NOT NULL,
	PRIMARY KEY (`USER_ID`,`GROUP_SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='운용자별 사용자 그룹 사용자 리스트';

CREATE TABLE IF NOT EXISTS `UI_SEARCH_KEYWORD` (
	SK_SEQ		INT(11) NOT NULL AUTO_INCREMENT COMMENT '검색어 일련번호',
	ADMIN_ID	varchar(50) NOT NULL COMMENT '운용자 아이디',
	SEARCH_KEYWORD	varchar(500) NOT NULL COMMENT '검색한 검색어',
	CREATE_DT	datetime DEFAULT NULL COMMENT '생성일',
	PRIMARY KEY (`SK_SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='운용자별 검색어 저장';

CREATE TABLE IF NOT EXISTS UI_CUSTOM_DASHBOARD_SHARE(
DASH_KEY  INT(11)  NOT NULL    COMMENT 'DASHBOARD KEY',
ADMIN_ID  VARCHAR(50)  NOT NULL    COMMENT '운용자 아이디',
P_DASH_KEY  INT(11)  NOT NULL    COMMENT '배포 DASHBOARD KEY',
PRIMARY KEY (DASH_KEY) ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='UI CUSTOM 대시보드 배포';

CREATE TABLE IF NOT EXISTS UI_ADMIN_GENERATE (
ADMIN_ID VARCHAR(50) NOT NULL COMMENT '운용자 아이디',
ADMIN_GENERATE VARCHAR(100) NOT NULL COMMENT '구글 OTP 개인키',
PRIMARY KEY (ADMIN_ID)	) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='운용자별 구글 OTP 개인키';
UPDATE UI_SERVICE SET USE_YN='Y' WHERE USE_YN IS NULL;
DROP TABLE IF EXISTS UI_SERVICE_TMP;
CREATE TABLE IF NOT EXISTS UI_SERVICE_TMP AS SELECT  * FROM  UI_SERVICE;
DELETE FROM UI_SERVICE;
INSERT INTO UI_SERVICE (`SERVICECD`, `SERVICENM_LV1`, `SERVICENM_LV2`, `SERVICENM_LV3`, `IN_OUT`, `SORT`, `USE_YN`, `MSGGRPCD`) VALUES
('MP3-','메일','POP3','-','I',1,'Y',''),
('MSM-','메일','SMTP','-','O',2,'Y',''),
('MIM-','메일','IMAP','-','I',3,'Y',''),
('WNVR','웹메일','네이버','수신','I',4,'Y',''),
('WNVS','웹메일','네이버','발신','O',5,'Y',''),
('WNVB','웹메일','네이버','예약메일','O',6,'Y',''),
('WNVT','웹메일','네이버','임시저장','O',7,'Y',''),
('WDUR','웹메일','다음','수신','I',8,'Y',''),
('WDUS','웹메일','다음','발신','O',9,'Y',''),
('WDUB','웹메일','다음','예약메일','O',10,'Y',''),
('WDUT','웹메일','다음','임시저장','O',11,'Y',''),
('WCLR','웹메일','천리안','수신','I',12,'Y',''),
('WCLS','웹메일','천리안','발신','O',13,'Y',''),
('WCLB','웹메일','천리안','예약메일','O',14,'Y',''),
('WCLT','웹메일','천리안','임시저장','O',15,'Y',''),
('WNTR','웹메일','네이트','수신','I',16,'Y',''),
('WNTS','웹메일','네이트','발신','O',17,'Y',''),
('WNTB','웹메일','네이트','예약메일','O',18,'Y',''),
('WNTT','웹메일','네이트','임시저장','O',19,'Y',''),
('WKRR','웹메일','코리아','수신','I',20,'Y',''),
('WKRS','웹메일','코리아','발신','O',21,'Y',''),
('WKRB','웹메일','코리아','예약메일','O',22,'Y',''),
('WKRT','웹메일','코리아','임시저장','O',23,'Y',''),
('WUTR','웹메일','유니텔','수신','I',24,'Y',''),
('WUTS','웹메일','유니텔','발신','O',25,'Y',''),
('WUTB','웹메일','유니텔','예약메일','O',26,'Y',''),
('WUTT','웹메일','유니텔','임시저장','O',27,'Y',''),
('WYAR','웹메일','Yeah','수신','I',28,'Y',''),
('WYAS','웹메일','Yeah','발신','O',29,'Y',''),
('WYAT','웹메일','Yeah','임시저장','O',30,'Y',''),
('WSNR','웹메일','SINA','수신','I',31,'Y',''),
('WSNS','웹메일','SINA','발신','O',32,'Y',''),
('WSNB','웹메일','SINA','예약메일','O',33,'Y',''),
('WSNT','웹메일','SINA','임시저장','O',34,'Y',''),
('WSUR','웹메일','SOHU','수신','I',35,'Y',''),
('WSUS','웹메일','SOHU','발신','O',36,'Y',''),
('WSUB','웹메일','SOHU','예약메일','O',37,'Y',''),
('WSUT','웹메일','SOHU','임시저장','O',38,'Y',''),
('WYHR','웹메일','야후','수신','I',39,'Y',''),
('WYHS','웹메일','야후','발신','O',40,'Y',''),
('WYHT','웹메일','야후','임시저장','O',41,'Y',''),
('WGGR','웹메일','Gmail','수신','I',42,'Y',''),
('WGGS','웹메일','Gmail','발신','O',43,'Y',''),
('WGGT','웹메일','Gmail','임시저장','O',44,'Y',''),
('WLVR','웹메일','Outlook.com','수신','I',45,'Y',''),
('WLVS','웹메일','Outlook.com','발신','O',46,'Y',''),
('WLVT','웹메일','Outlook.com','임시저장','O',47,'Y',''),
('WQQR','웹메일','QQ','수신','I',48,'Y',''),
('WQQS','웹메일','QQ','발신','O',49,'Y',''),
('WQQB','웹메일','QQ','예약메일','O',50,'Y',''),
('WQQT','웹메일','QQ','임시저장','O',51,'Y',''),
('WOSR','웹메일','163','수신','I',52,'Y',''),
('WOSS','웹메일','163','발신','O',53,'Y',''),
('WOSB','웹메일','163','예약메일','O',54,'Y',''),
('WOST','웹메일','163','임시저장','O',55,'Y',''),
('WBMR','웹메일','KT비즈메카','수신','I',56,'Y',''),
('WBMS','웹메일','KT비즈메카','발신','O',57,'Y',''),
('WBMT','웹메일','KT비즈메카','임시저장','O',58,'Y',''),
('WOTR','웹메일','126','수신','I',59,'Y',''),
('WOTS','웹메일','126','발신','O',60,'Y',''),
('WOTB','웹메일','126','예약메일','O',61,'Y',''),
('WOTT','웹메일','126','임시저장','O',62,'Y',''),
('WICR','웹메일','Icloud','수신','I',63,'Y',''),
('WICS','웹메일','Icloud','발신','O',64,'Y',''),
('WICT','웹메일','Icloud','임시저장','O',65,'Y',''),
('WKAR','웹메일','카카오메일','수신','I',66,'Y',''),
('WKAS','웹메일','카카오메일','발신','O',67,'Y',''),
('WKAT','웹메일','카카오메일','임시저장','O',68,'Y',''),
('WYDR','웹메일','yandex','수신','I',69,'Y',''),
('WYDS','웹메일','yandex','발신','O',70,'Y',''),
('WYDT','웹메일','yandex','임시저장','O',71,'Y',''),
('WDOR','웹메일','dooray','수신','I',72,'Y',''),
('WDOS','웹메일','dooray','발신','O',73,'Y',''),
('WDOT','웹메일','dooray','임시저장','O',74,'Y',''),
('WUKR','웹메일','기타','수신','I',75,'Y',''),
('WUKS','웹메일','기타','발신','O',76,'Y',''),
('CNVR','커뮤니티','네이버 카페','수신','I',77,'Y',''),
('CNVS','커뮤니티','네이버 카페','발신','O',78,'Y',''),
('CNVD','커뮤니티','네이버 카페','댓글','O',79,'Y',''),
('CNVT','커뮤니티','네이버 카페','임시저장','O',80,'Y',''),
('CDUR','커뮤니티','다음 카페','수신','I',81,'Y',''),
('CDUS','커뮤니티','다음 카페','발신','O',82,'Y',''),
('CDUD','커뮤니티','다음 카페','댓글','O',83,'Y',''),
('CDUT','커뮤니티','다음 카페','임시저장','O',84,'Y',''),
('CPPR','커뮤니티','뽐뿌 커뮤니케이션','수신','I',85,'Y',''),
('CPPS','커뮤니티','뽐뿌 커뮤니케이션','발신','O',86,'Y',''),
('CPPD','커뮤니티','뽐뿌 커뮤니케이션','댓글','O',87,'Y',''),
('CCIR','커뮤니티','클리앙','수신','I',88,'Y',''),
('CCIS','커뮤니티','클리앙','발신','O',89,'Y',''),
('CCID','커뮤니티','클리앙','댓글','O',90,'Y',''),
('CDCR','커뮤니티','디시인사이드','수신','I',91,'Y',''),
('CDCS','커뮤니티','디시인사이드','발신','O',92,'Y',''),
('CDCD','커뮤니티','디시인사이드','댓글','O',93,'Y',''),
('CRWR','커뮤니티','루리웹','수신','I',94,'Y',''),
('CRWS','커뮤니티','루리웹','발신','O',95,'Y',''),
('CRWD','커뮤니티','루리웹','댓글','O',96,'Y',''),
('CMLR','커뮤니티','Menlosecurity','수신','I',97,'Y',''),
('CMLS','커뮤니티','Menlosecurity','발신','O',98,'Y',''),
('CMLD','커뮤니티','Menlosecurity','댓글','O',99,'Y',''),
('CMLE','커뮤니티','Menlosecurity','기타','O',100,'Y',''),
('CUKR','커뮤니티','기타','수신','I',101,'Y',''),
('CUKS','커뮤니티','기타','발신','O',102,'Y',''),
('CUKD','커뮤니티','기타','댓글','O',103,'Y',''),
('SFBR','소셜','페이스북','수신','I',104,'Y',''),
('SFBS','소셜','페이스북','발신','O',105,'Y',''),
('SFBD','소셜','페이스북','댓글','O',106,'Y',''),
('STWR','소셜','트위터','수신','I',107,'Y',''),
('STWS','소셜','트위터','발신','O',108,'Y',''),
('STWD','소셜','트위터','댓글','O',109,'Y',''),
('SKAR','소셜','카카오스토리','수신','I',110,'Y',''),
('SKAS','소셜','카카오스토리','발신','O',111,'Y',''),
('SKAD','소셜','카카오스토리','댓글','O',112,'Y',''),
('SNVR','소셜','네이버 블로그','수신','I',113,'Y',''),
('SNVS','소셜','네이버 블로그','발신','O',114,'Y',''),
('SNVD','소셜','네이버 블로그','댓글','O',115,'Y',''),
('SNVT','소셜','네이버 블로그','임시저장','O',116,'Y',''),
('SDUR','소셜','다음 블로그','수신','I',117,'Y',''),
('SDUS','소셜','다음 블로그','발신','O',118,'Y',''),
('SDUD','소셜','다음 블로그','댓글','O',119,'Y',''),
('STSR','소셜','티스토리','수신','I',120,'Y',''),
('STSS','소셜','티스토리','발신','O',121,'Y',''),
('STSD','소셜','티스토리','댓글','O',122,'Y',''),
('STST','소셜','티스토리','임시저장','O',123,'Y',''),
('STBR','소셜','텀블러','수신','I',124,'Y',''),
('STBS','소셜','텀블러','발신','O',125,'Y',''),
('STBD','소셜','텀블러','댓글','O',126,'Y',''),
('SWBR','소셜','웨이보','수신','I',127,'Y',''),
('SWBS','소셜','웨이보','발신','O',128,'Y',''),
('SWBD','소셜','웨이보','댓글','O',129,'Y',''),
('SLKR','소셜','링크드인','수신','I',130,'Y',''),
('SLKS','소셜','링크드인','발신','O',131,'Y',''),
('SLKD','소셜','링크드인','댓글','O',132,'Y',''),
('SEGR','소셜','이글루','수신','I',133,'Y',''),
('SEGS','소셜','이글루','발신','O',134,'Y',''),
('SEGD','소셜','이글루','댓글','O',135,'Y',''),
('SYMR','소셜','야머','수신','I',136,'Y',''),
('SYMS','소셜','야머','발신','O',137,'Y',''),
('SYMD','소셜','야머','댓글','O',138,'Y',''),
('SYMF','소셜','야머','파일전송','O',139,'Y',''),
('SNBR','소셜','네이버 밴드','수신','I',140,'Y',''),
('SNBS','소셜','네이버 밴드','발신','O',141,'Y',''),
('SNBD','소셜','네이버 밴드','댓글','O',142,'Y',''),
('SLRR','소셜','라이브리','수신','I',143,'Y',''),
('SLRS','소셜','라이브리','발신','O',144,'Y',''),
('SLRD','소셜','라이브리','댓글','O',145,'Y',''),
('SMER','소셜','medium','수신','I',146,'Y',''),
('SMES','소셜','medium','발신','O',147,'Y',''),
('SMED','소셜','medium','댓글','O',148,'Y',''),
('SISR','소셜','인스타그램','수신','I',149,'Y',''),
('SISS','소셜','인스타그램','발신','O',150,'Y',''),
('SISD','소셜','인스타그램','댓글','O',151,'Y',''),
('SISF','소셜','인스타그램','파일전송','O',152,'Y',''),
('VDUR','영상 스트리밍','다음 TV','수신','I',153,'Y',''),
('VDUS','영상 스트리밍','다음 TV','발신','O',154,'Y',''),
('VPDR','영상 스트리밍','판도라 TV','수신','I',155,'Y',''),
('VPDS','영상 스트리밍','판도라 TV','발신','O',156,'Y',''),
('VGMR','영상 스트리밍','곰 TV','수신','I',157,'Y',''),
('VGMS','영상 스트리밍','곰 TV','발신','O',158,'Y',''),
('VYTR','영상 스트리밍','유튜브','수신','I',159,'Y',''),
('VYTS','영상 스트리밍','유튜브','발신','O',160,'Y',''),
('VYTD','영상 스트리밍','유튜브','댓글','O',161,'Y',''),
('VNVR','영상 스트리밍','네이버 TV캐스트','수신','I',162,'Y',''),
('VNVS','영상 스트리밍','네이버 TV캐스트','발신','O',163,'Y',''),
('QNVC','메신저','네이버','채팅','O',164,'N',''),
('QNVF','메신저','네이버','파일전송','O',165,'N',''),
('QNMR','메신저','네이버 쪽지','수신','I',166,'N',''),
('QNMS','메신저','네이버 쪽지','발신','O',167,'N',''),
('QDUC','메신저','다음','채팅','O',168,'N',''),
('QDUF','메신저','다음','파일전송','O',169,'N',''),
('QDUM','메신저','다음','쪽지','O',170,'N',''),
('QDSC','메신저','대신','채팅','O',171,'N',''),
('QDSF','메신저','대신','파일전송','O',172,'N',''),
('QDSM','메신저','대신','쪽지','O',173,'N',''),
('QSHC','메신저','삼홍사','채팅','O',174,'Y',''),
('QSHF','메신저','삼홍사','파일전송','O',175,'Y',''),
('QSHM','메신저','삼홍사','쪽지','O',176,'Y',''),
('QDIC','메신저','동부생명','채팅','O',177,'Y',''),
('QDIF','메신저','동부생명','파일전송','O',178,'Y',''),
('QDIM','메신저','동부생명','쪽지','O',179,'Y',''),
('QDFC','메신저','동부금융','채팅','O',180,'Y',''),
('QDFF','메신저','동부금융','파일전송','O',181,'Y',''),
('QDFM','메신저','동부금융','쪽지','O',182,'Y',''),
('QDGC','메신저','동국제강','채팅','O',183,'Y',''),
('QDGF','메신저','동국제강','파일전송','O',184,'Y',''),
('QDGM','메신저','동국제강','쪽지','O',185,'Y',''),
('QFMC','메신저','프리본드','채팅','O',186,'Y','MSG'),
('QFMF','메신저','프리본드','파일전송','O',187,'Y','MSG'),
('QFMM','메신저','프리본드','쪽지','O',188,'Y','MSG'),
('QFMJ','메신저','프리본드','참여','O',189,'Y','MSG'),
('QFML','메신저','프리본드','떠남','O',190,'Y','MSG'),
('QMCC','메신저','M-채널','채팅','O',191,'Y',''),
('QMCF','메신저','M-채널','파일전송','O',192,'Y',''),
('QMCM','메신저','M-채널','쪽지','O',193,'Y',''),
('QMSC','메신저','미쓰리','채팅','O',194,'Y','MSG'),
('QMSF','메신저','미쓰리','파일전송','O',195,'Y','MSG'),
('QMSM','메신저','미쓰리','쪽지','O',196,'Y','MSG'),
('QMSJ','메신저','미쓰리','참여','O',197,'Y','MSG'),
('QMSL','메신저','미쓰리','떠남','O',198,'Y','MSG'),
('QNTC','메신저','네이트','채팅','O',199,'Y','MSG'),
('QNTF','메신저','네이트','파일전송','O',200,'Y','MSG'),
('QNTM','메신저','네이트','쪽지','O',201,'Y','MSG'),
('QNTJ','메신저','네이트','참여','O',202,'Y','MSG'),
('QNTL','메신저','네이트','떠남','O',203,'Y','MSG'),
('QSSC','메신저','삼성증권','채팅','O',204,'N',''),
('QSSF','메신저','삼성증권','파일전송','O',205,'N',''),
('QSSM','메신저','삼성증권','쪽지','O',206,'N',''),
('QSFC','메신저','삼성화재','채팅','O',207,'Y',''),
('QSFF','메신저','삼성화재','파일전송','O',208,'Y',''),
('QSFM','메신저','삼성화재','쪽지','O',209,'Y',''),
('QSFJ','메신저','삼성화재','참여','O',210,'Y',''),
('QSFL','메신저','삼성화재','떠남','O',211,'Y',''),
('QSPC','메신저','SK 프라이든','채팅','O',212,'Y',''),
('QSPF','메신저','SK 프라이든','파일전송','O',213,'Y',''),
('QSPM','메신저','SK 프라이든','쪽지','O',214,'Y',''),
('QSPJ','메신저','SK 프라이든','참여','O',215,'Y',''),
('QSPL','메신저','SK 프라이든','떠남','O',216,'Y',''),
('QSBC','메신저','SK 비즈','채팅','O',217,'N',''),
('QSBF','메신저','SK 비즈','파일전송','O',218,'N',''),
('QSBM','메신저','SK 비즈','쪽지','O',219,'N',''),
('QWJC','메신저','웅진','채팅','O',220,'Y',''),
('QWJF','메신저','웅진','파일전송','O',221,'Y',''),
('QWJM','메신저','웅진','쪽지','O',222,'Y',''),
('QGPC','메신저','chatGPT','채팅','O',223,'Y',''),
('QDAC','메신저','Dall-E','채팅','O',224,'Y',''),
('QDAF','메신저','Dall-E','파일전송','O',225,'Y',''),
('QCLC','메신저','쿨','채팅','O',226,'Y','MSG'),
('QCLF','메신저','쿨','파일전송','O',227,'Y','MSG'),
('QCLM','메신저','쿨','쪽지','O',228,'Y','MSG'),
('QCLJ','메신저','쿨','참여','O',229,'Y','MSG'),
('QCLL','메신저','쿨','떠남','O',230,'Y','MSG'),
('QKBC','메신저','k-bond','채팅','O',231,'Y','MSG'),
('QKBF','메신저','k-bond','파일전송','O',232,'Y','MSG'),
('QKBM','메신저','k-bond','쪽지','O',233,'Y','MSG'),
('QKBJ','메신저','k-bond','참여','O',234,'Y','MSG'),
('QKBL','메신저','k-bond','떠남','O',235,'Y','MSG'),
('QEKC','메신저','아이콘','채팅','O',236,'Y','MSG'),
('QEKF','메신저','아이콘','파일전송','O',237,'Y','MSG'),
('QEKJ','메신저','아이콘','참여','O',238,'Y','MSG'),
('QEKL','메신저','아이콘','떠남','O',239,'Y','MSG'),
('QEKH','메신저','아이콘','과거 데이터','O',240,'Y','MSG'),
('QSLC','메신저','Slack','채팅','O',241,'Y','MSG'),
('QSLF','메신저','Slack','파일전송','O',242,'Y','MSG'),
('QSLJ','메신저','Slack','참여','O',243,'Y','MSG'),
('QSLL','메신저','Slack','떠남','O',244,'Y','MSG'),
('QSYC','메신저','신영자산운용','채팅','O',245,'Y','MSG'),
('QSYF','메신저','신영자산운용','파일전송','O',246,'Y','MSG'),
('QSYM','메신저','신영자산운용','쪽지','O',247,'Y','MSG'),
('QSYJ','메신저','신영자산운용','참여','O',248,'Y','MSG'),
('QSYL','메신저','신영자산운용','떠남','O',249,'Y','MSG'),
('QFBC','메신저','페이스북','채팅','O',250,'Y','MSG'),
('QFBF','메신저','페이스북','파일전송','O',251,'Y','MSG'),
('QKMC','메신저','삼성KnoxMessenger','채팅','O',252,'Y','MSG'),
('QKMF','메신저','삼성KnoxMessenger','파일전송','O',253,'Y','MSG'),
('QKMR','메신저','삼성KnoxMessenger','파일수신','I',254,'Y','MSG'),
('QKMW','메신저','삼성KnoxMessenger','전달','O',255,'Y','MSG'),
('QKMV','메신저','삼성KnoxMessenger','파일-미리보기','O',256,'Y','MSG'),
('QGHC','메신저','구글 Hangout','채팅','O',257,'Y','MSG'),
('QGHF','메신저','구글 Hangout','파일전송','O',258,'Y','MSG'),
('QGGC','메신저','구글 chat','채팅','O',259,'Y','MSG'),
('QGGF','메신저','구글 chat','파일전송','O',260,'Y','MSG'),
('QGMC','메신저','구글 Meet','채팅','O',261,'Y','MSG'),
('QGBC','메신저','구글 Bard','채팅','O',262,'Y','MSG'),
('QBIC','메신저','Microsoft BingAI Chat','채팅','O',263,'Y','MSG'),
('QWTC','메신저','wrtn','채팅','O',264,'Y',''),
('QISC','메신저','인스타그램 DM','채팅','O',265,'Y','MSG'),
('QISF','메신저','인스타그램 DM','파일전송','O',266,'Y','MSG'),
('QZAC','메신저','Zalo','채팅','O',267,'Y','MSG'),
('QZAF','메신저','Zalo','파일전송','O',268,'Y','MSG'),
('QUKC','메신저','기타','채팅','O',269,'Y','MSG'),
('QUKF','메신저','기타','파일전송','O',270,'Y','MSG'),
('QUKM','메신저','기타','쪽지','O',271,'Y','MSG'),
('QUKJ','메신저','기타','참여','O',272,'Y','MSG'),
('QUKL','메신저','기타','떠남','O',273,'Y','MSG'),
('FFTC','파일전송','FTP','CMD','O',274,'Y',''),
('FFTG','파일전송','FTP','GET','I',275,'Y',''),
('FFTP','파일전송','FTP','PUT','O',276,'Y',''),
('FFTL','파일전송','FTP','CONNECT','O',277,'Y',''),
('FZM-','파일전송','Zmodem','-','O',278,'Y',''),
('FNVR','파일전송','네이버 MYBOX','수신','I',279,'Y',''),
('FNVS','파일전송','네이버 MYBOX','발신','O',280,'Y',''),
('FGGR','파일전송','구글 드라이브','수신','I',281,'Y',''),
('FGGS','파일전송','구글 드라이브','발신','O',282,'Y',''),
('FODR','파일전송','OneDrive','수신','I',283,'Y',''),
('FODS','파일전송','OneDrive','발신','O',284,'Y',''),
('FDBR','파일전송','Dropbox','수신','I',285,'Y',''),
('FDBS','파일전송','Dropbox','발신','O',286,'Y',''),
('F2NR','파일전송','2nd 드라이브','수신','I',287,'N',''),
('F2NS','파일전송','2nd 드라이브','발신','O',288,'N',''),
('FPSR','파일전송','polarisoffice ','수신','I',289,'Y',''),
('FPSS','파일전송','polarisoffice ','발신','O',290,'Y',''),
('FICR','파일전송','Icloud','수신','I',291,'Y',''),
('FICS','파일전송','Icloud','발신','O',292,'Y',''),
('FYDR','파일전송','yandex','수신','I',293,'Y',''),
('FYDS','파일전송','yandex','발신','O',294,'Y',''),
('FWHR','파일전송','LG 웹하드','수신','I',295,'Y',''),
('FWHS','파일전송','LG 웹하드','발신','O',296,'Y',''),
('FGIR','파일전송','GitHub','수신','I',297,'Y',''),
('FGIS','파일전송','GitHub','발신','O',298,'Y',''),
('FDOR','파일전송','dooray','수신','I',299,'Y',''),
('FDOS','파일전송','dooray','발신','O',300,'Y',''),
('FWES','파일전송','wetransfer','발신','O',301,'Y',''),
('FUKR','파일전송','기타','수신','I',302,'Y',''),
('FUKS','파일전송','기타','발신','O',303,'Y',''),
('NENR','노트','EVERNOTE','수신','I',304,'Y',''),
('NENS','노트','EVERNOTE','발신','O',305,'Y',''),
('NONR','노트','ONENOTE','수신','I',306,'Y',''),
('NONS','노트','ONENOTE','발신','O',307,'Y',''),
('NLVS','노트','Outlook.com 메모','발신','O',308,'Y',''),
('NBTS','노트','BIT.AI','발신','O',309,'Y',''),
('NNOS','노트','notion','발신','O',310,'Y',''),
('NGGS','노트','구글 docs','발신','O',311,'Y',''),
('NGTS','노트','구글 tasks','발신','O',312,'Y',''),
('NGKS','노트','구글 keep','발신','O',313,'Y',''),
('NSSR','노트','삼성 노트','수신','I',314,'Y',''),
('NSSS','노트','삼성 노트','발신','O',315,'Y',''),
('NNVS','노트','네이버 오피스','발신','O',316,'Y',''),
('NDBS','노트','Dropbox paper','발신','O',317,'Y',''),
('NHCS','노트','한컴 오피스','발신','O',318,'Y',''),
('NMOS','노트','MS오피스','발신','O',319,'Y',''),
('NCDS','노트','Coda','발신','O',320,'Y',''),
('NNMR','노트','네이버 메모','수신','I',321,'Y',''),
('NNMS','노트','네이버 메모','발신','O',322,'Y',''),
('NCNS','노트','Clova Note','발신','O',323,'Y',''),
('NUKS','노트','기타','발신','O',324,'Y',''),
('AGCR','일정','구글캘린더일정','수신','I',325,'N',''),
('AGCS','일정','구글캘린더일정','발신','O',326,'Y',''),
('AGLR','일정','구글캘린더메일','수신','I',327,'N',''),
('AGLS','일정','구글캘린더메일','발신','O',328,'Y',''),
('ZTN-','기타 서비스','Telnet','-','O',329,'Y',''),
('ZXT-','기타 서비스','Xterm','-','O',330,'Y',''),
('ZRL-','기타 서비스','R-Login','-','O',331,'Y',''),
('ZNP-','기타 서비스','NNTP','-','O',332,'Y',''),
('ZPC-','기타 서비스','PC 보안','-','O',333,'N',''),
('ZSH-','기타 서비스','SSH','SSH 세션 정보','O',334,'Y',''),
('XX1R','모니터링_제외','미분류_타입1','수신','I',335,'Y',''),
('XX1S','모니터링_제외','미분류_타입1','발신','O',336,'Y',''),
('XX2R','모니터링_제외','미분류_타입2','수신','I',337,'Y',''),
('XX2S','모니터링_제외','미분류_타입2','발신','O',338,'Y',''),
('XX3R','모니터링_제외','미분류_타입3','수신','I',339,'Y',''),
('XX3S','모니터링_제외','미분류_타입3','발신','O',340,'Y',''),
('XU1R','모니터링_제외','웹서비스(미분류)_타입1','수신','I',341,'Y',''),
('XU1S','모니터링_제외','웹서비스(미분류)_타입1','발신','O',342,'Y',''),
('XU2R','모니터링_제외','웹서비스(미분류)_타입2','수신','I',343,'Y',''),
('XU2S','모니터링_제외','웹서비스(미분류)_타입2','발신','O',344,'Y',''),
('XU3R','모니터링_제외','웹서비스(미분류)_타입3','수신','I',345,'Y',''),
('XU3S','모니터링_제외','웹서비스(미분류)_타입3','발신','O',346,'Y',''),
('UWSD','웹서비스(미분류)','웹 발신','첨부 - 문서타입','O',347,'Y',''),
('UWSE','웹서비스(미분류)','웹 발신','첨부 - 문서아님','O',348,'Y',''),
('UWSU','웹서비스(미분류)','웹 발신','첨부 없음','O',349,'Y',''),
('UWSH','웹서비스(미분류)','웹 발신','중요도(상)','O',350,'Y',''),
('UWSM','웹서비스(미분류)','웹 발신','중요도(중)','O',351,'Y',''),
('UWSL','웹서비스(미분류)','웹 발신','중요도(하)','O',352,'Y',''),
('UX1R','웹서비스(미분류)','미분류_타입1','수신','I',353,'Y',''),
('UX1S','웹서비스(미분류)','미분류_타입1','발신','O',354,'Y',''),
('UX2R','웹서비스(미분류)','미분류_타입2','수신','I',355,'Y',''),
('UX2S','웹서비스(미분류)','미분류_타입2','발신','O',356,'Y',''),
('UX3R','웹서비스(미분류)','미분류_타입3','수신','I',357,'Y',''),
('UX3S','웹서비스(미분류)','미분류_타입3','발신','O',358,'Y',''),
('UWRD','웹서비스(미분류)','웹 수신','첨부 - 문서타입','I',359,'Y',''),
('UWRE','웹서비스(미분류)','웹 수신','첨부 - 문서아님','I',360,'Y',''),
('UWRU','웹서비스(미분류)','웹 수신','첨부 없음','I',361,'Y',''),
('BWSD','웹서비스(업무)','업무 발신','첨부 - 문서타입','O',362,'Y',''),
('BWSE','웹서비스(업무)','업무 발신','첨부 - 문서아님','O',363,'Y',''),
('BWSU','웹서비스(업무)','업무 발신','첨부 없음','O',364,'Y',''),
('BWRD','웹서비스(업무)','업무 수신','첨부 - 문서타입','I',365,'Y',''),
('BWRE','웹서비스(업무)','업무 수신','첨부 - 문서아님','I',366,'Y',''),
('BWRU','웹서비스(업무)','업무 수신','첨부 없음','I',367,'Y',''),
('TWEC','화상회의','Webex','채팅','O',368,'Y','MSG'),
('TWEF','화상회의','Webex','파일전송','O',369,'Y','MSG'),
('TWEJ','화상회의','Webex','참여','O',370,'Y','MSG'),
('TWEL','화상회의','Webex','떠남','O',371,'Y','MSG'),
('TZOC','화상회의','Zoom','채팅','O',372,'Y','MSG'),
('TZOF','화상회의','Zoom','파일전송','O',373,'Y','MSG'),
('TZOJ','화상회의','Zoom','참여','O',374,'Y','MSG'),
('TZOL','화상회의','Zoom','떠남','O',375,'Y','MSG'),
('TTMC','화상회의','Teams','채팅','O',376,'Y','MSG'),
('TTMF','화상회의','Teams','파일전송','O',377,'Y','MSG'),
('TTMJ','화상회의','Teams','참여','O',378,'Y','MSG'),
('TTML','화상회의','Teams','떠남','O',379,'Y','MSG'),
('TSKC','화상회의','Skype','채팅','O',380,'Y','MSG'),
('TSKF','화상회의','Skype','파일전송','O',381,'Y','MSG'),
('TSKJ','화상회의','Skype','참여','O',382,'Y','MSG'),
('TSKL','화상회의','Skype','떠남','O',383,'Y','MSG'),
('TJMC','화상회의','JoinME','채팅','O',384,'Y','MSG'),
('TJMF','화상회의','JoinME','파일전송','O',385,'Y','MSG'),
('TAMC','화상회의','Amazon Chime','채팅','O',386,'Y','MSG'),
('TAMF','화상회의','Amazon Chime','파일전송','O',387,'Y','MSG'),
('TBJC','화상회의','BlueJeans','채팅','O',388,'Y','MSG'),
('TTDS','화상회의','tl;dv','채팅','O',389,'Y','MSG'),
('LNVS','번역기','파파고 번역','발신','O',390,'Y',''),
('LGGS','번역기','구글 번역','발신','O',391,'Y',''),
('LGPS','번역기','구글 번역 플러그인','발신','O',392,'Y',''),
('LDES','번역기','Deepl','발신','O',393,'Y',''),
('LBIS','번역기','Bing 번역','발신','O',394,'Y',''),
('LYMS','번역기','Yandex 번역','발신','O',395,'Y',''),
('LUKS','번역기','기타','발신','I',396,'Y',''),
('IGBS','생성형 AI','구글 Bard','발신','O',397,'Y',''),
('IBIS','생성형 AI','Microsoft BingAI Chat','발신','O',398,'Y',''),
('IWTS','생성형 AI','wrtn','발신','O',399,'Y',''),
('IGPS','생성형 AI','chatGPT','발신','O',400,'Y',''),
('IDAS','생성형 AI','Dall-E','발신','O',401,'Y',''),
('IGCS','생성형 AI','Github Copilot','발신','I',402,'Y',''),
('IYCS','생성형 AI','YouChat','발신','I',403,'Y',''),
('ICSS','생성형 AI','Chatsonic','발신','I',404,'Y',''),
('IRPS','생성형 AI','replika','발신','I',405,'Y',''),
('IPPS','생성형 AI','Perplexity','발신','I',406,'Y',''),
('ITCS','생성형 AI','TextCortex','발신','I',407,'Y',''),
('IPHS','생성형 AI','Phind','발신','I',408,'Y',''),
('IPOS','생성형 AI','Poe','발신','I',409,'Y',''),
('IRMS','생성형 AI','Runwayml','발신','I',410,'Y',''),
('IGVS','생성형 AI','Google Vertex','발신','I',411,'Y',''),
('IGLS','생성형 AI','Google Colab','발신','I',412,'Y',''),
('IADS','생성형 AI','Adobe AI','발신','I',413,'Y',''),
('ICDS','생성형 AI','ClipDrop','발신','I',414,'Y',''),
('ISBS','생성형 AI','Stability.Ai','발신','I',415,'Y',''),
('IHFS','생성형 AI','Hugging Face','발신','I',416,'Y',''),
('ICPS','생성형 AI','Copy.AI','발신','I',417,'Y',''),
('IHWS','생성형 AI','HyperWrite','발신','I',418,'Y',''),
('IDPS','생성형 AI','DeepAI','발신','I',419,'Y',''),
('IACS','생성형 AI','AskCodi','발신','I',420,'Y',''),
('INAS','생성형 AI','Native','발신','I',421,'Y',''),
('INFS','생성형 AI','NeuroFlash','발신','I',422,'Y',''),
('INOS','생성형 AI','Notion AI','발신','I',423,'Y',''),
('IMES','생성형 AI','Merlin','발신','I',424,'Y',''),
('ICXS','생성형 AI','CLOVA-X','발신','I',425,'Y',''),
('ICWS','생성형 AI','CodeWhisperer','발신','I',426,'Y',''),
('IUKS','생성형 AI','기타','발신','I',427,'Y',''),
('PDOS','프로젝트','dooray','발신','O',428,'Y',''),
('PGIS','프로젝트','github','발신','O',429,'Y',''),
('EBDR','그룹웨어','게시','수신','I',430,'Y',''),
('EBD-','그룹웨어','게시','발신','O',431,'Y',''),
('EBBR','그룹웨어','게시판','수신','I',432,'Y',''),
('EBBS','그룹웨어','게시판','발신','O',433,'Y',''),
('EBBF','그룹웨어','게시판','파일수신','I',434,'Y',''),
('EAAR','그룹웨어','결재','수신','I',435,'Y',''),
('EAAS','그룹웨어','결재','발신','O',436,'Y',''),
('EAAG','그룹웨어','결재','통보 - 수신','I',437,'Y',''),
('EAAP','그룹웨어','결재','통보 - 발신','O',438,'Y',''),
('EAAF','그룹웨어','결재','파일수신','I',439,'Y',''),
('EMMR','그룹웨어','메일','그룹웨어 수신','I',440,'Y',''),
('EMMS','그룹웨어','메일','그룹웨어 발신','O',441,'Y',''),
('EMMG','그룹웨어','메일','OWA 수신','I',442,'Y',''),
('EMMP','그룹웨어','메일','OWA 발신','O',443,'Y',''),
('EMMD','그룹웨어','메일','RPC 수신','I',444,'Y',''),
('EMMU','그룹웨어','메일','RPC 발신','O',445,'Y',''),
('EMMC','그룹웨어','메일','수신','I',446,'Y',''),
('EMML','그룹웨어','메일','발신','O',447,'Y',''),
('EMM1','그룹웨어','메일','보안등급1','O',448,'Y',''),
('EMM2','그룹웨어','메일','보안등급2','O',449,'Y',''),
('EMM3','그룹웨어','메일','보안등급3','O',450,'Y',''),
('EMM4','그룹웨어','메일','보안등급4','O',451,'Y',''),
('EMMA','그룹웨어','메일','임시(자동)','O',452,'Y',''),
('EMMT','그룹웨어','메일','임시(수동)','O',453,'Y',''),
('EMMK','그룹웨어','메일','Outlook - 수신','I',454,'Y',''),
('EMMO','그룹웨어','메일','Outlook - 발신','O',455,'Y',''),
('EMMB','그룹웨어','메일','그룹웨어 예약메일','O',456,'Y',''),
('EMBR','그룹웨어','모바일','수신','I',457,'Y',''),
('EMB-','그룹웨어','모바일','발신','O',458,'Y',''),
('EWSR','그룹웨어','웹서비스','수신','I',459,'Y',''),
('EWS-','그룹웨어','웹서비스','발신','O',460,'Y',''),
('EPUR','그룹웨어','일반','수신','I',461,'Y',''),
('EPU-','그룹웨어','일반','발신','O',462,'Y',''),
('ESCR','그룹웨어','일정 명함','수신','I',463,'Y',''),
('ESC-','그룹웨어','일정 명함','발신','O',464,'Y',''),
('EMF-','그룹웨어','파일 다운로드','-','I',465,'Y',''),
('EMU-','그룹웨어','기타','','O',466,'Y',''),
('EMDR','그룹웨어','드라이브','수신','I',467,'Y',''),
('EMDS','그룹웨어','드라이브','발신','O',468,'Y','');


UPDATE UI_SERVICE A SET USE_YN=(SELECT IFNULL(MAX(USE_YN), 'Y') FROM UI_SERVICE_TMP B WHERE A.SERVICECD = B.SERVICECD);
DROP TABLE IF EXISTS UI_SERVICE_TMP;


CREATE TABLE IF NOT EXISTS UI_CEO ( USER_ID VARCHAR(250) NOT NULL COMMENT '사용자 아이디', PRIMARY KEY (USER_ID) ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ceo 정보'
SELECT  USER_ID
FROM    UI_USERS
WHERE   CEO = 'Y';







CREATE TABLE IF NOT EXISTS UI_CUSTOM_DASHBOARD(
DASH_KEY  INT(11)  NOT NULL    COMMENT 'DASHBOARD KEY',
DASH_NAME VARCHAR(100) NOT NULL    COMMENT '항목명',
DASH_TYPE  CHAR(1)  NULL    COMMENT 'DASHBOARD 타입(S:단일 건수, D:복합건수, C:차트, L:리스트)',
DASH_MULTI_X  VARCHAR(30)  NULL    COMMENT '복합건수 왼쪽값',
DASH_MULTI_Y  VARCHAR(30)  NULL    COMMENT '복합건수 오른쪽값',
DASH_CHART  VARCHAR(10)  NULL    COMMENT '차트종류',
DASH_CHART_X  VARCHAR(30)  NULL    COMMENT '차트 값 x축',
DASH_CHART_Y  VARCHAR(30)  NULL    COMMENT '차트 값 y축',
DASH_ICON  VARCHAR(30)  NULL    COMMENT 'DASHBOARD 아이콘 CLASS',
DASH_COLOR  VARCHAR(30)  NULL    COMMENT 'DASHBOARD 색상 CLASS',
DASH_HTML LONGTEXT  NULL    COMMENT 'DASHBOARD HTML 데이터',
DASH_CONDITION  LONGTEXT  NULL    COMMENT 'DASHBOARD 조건',
DASH_COMMENT VARCHAR(100) NULL    COMMENT '항목설명',
ADMIN_ID  VARCHAR(50)  NOT NULL    COMMENT '운용자 아이디',
USEYN  CHAR(1)  NOT NULL     DEFAULT 'N'   COMMENT '사용여부',
PRIMARY KEY (DASH_KEY) ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='UI CUSTOM 대시보드 항목';

CREATE TABLE IF NOT EXISTS UI_CUSTOM_DASHBOARD_DEFAULT(
DASH_KEY  INT(11)  NOT NULL    COMMENT 'DASHBOARD KEY',
DASH_NAME VARCHAR(100) NOT NULL    COMMENT '항목명',
DASH_TYPE  CHAR(1)  NULL    COMMENT 'DASHBOARD 타입(S:단일 건수, D:복합건수, C:차트, L:리스트)',
DASH_MULTI_X  VARCHAR(30)  NULL    COMMENT '복합건수 왼쪽값',
DASH_MULTI_Y  VARCHAR(30)  NULL    COMMENT '복합건수 오른쪽값',
DASH_CHART  VARCHAR(10)  NULL    COMMENT '차트종류',
DASH_CHART_X  VARCHAR(30)  NULL    COMMENT '차트 값 x축',
DASH_CHART_Y  VARCHAR(30)  NULL    COMMENT '차트 값 y축',
DASH_ICON  VARCHAR(30)  NULL    COMMENT 'DASHBOARD 아이콘 CLASS',
DASH_COLOR  VARCHAR(30)  NULL    COMMENT 'DASHBOARD 색상 CLASS',
DASH_HTML LONGTEXT  NULL    COMMENT 'DASHBOARD HTML 데이터',
DASH_CONDITION  LONGTEXT  NULL    COMMENT 'DASHBOARD 조건',
DASH_COMMENT VARCHAR(100) NULL    COMMENT '항목설명',
USEYN  CHAR(1)  NOT NULL     DEFAULT 'N'   COMMENT '사용여부',
PRIMARY KEY (DASH_KEY) ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='UI CUSTOM 대시보드 항목 템플릿';

CREATE TABLE IF NOT EXISTS UI_CUSTOM_DASHBOARD_MENU(
MENU_KEY  INT(11)  NOT NULL    COMMENT '메뉴 KEY',
MENU_NAME VARCHAR(100) NOT NULL    COMMENT '메뉴명',
MENU_ICON  VARCHAR(30)  NULL    COMMENT '메뉴 아이콘 CLASS',
ADMIN_ID  VARCHAR(50)  NOT NULL    COMMENT '운용자 아이디',
USEYN  CHAR(1)  NOT NULL  DEFAULT 'Y'   COMMENT '사용여부',
DEFAULT_MENU  CHAR(1)  NULL    COMMENT '최초 접속 시 접속 메뉴',
UPDATE_DT DATETIME NULL COMMENT '수정 날짜',
PRIMARY KEY (MENU_KEY) ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='UI CUSTOM 대시보드 메뉴';

CREATE TABLE IF NOT EXISTS UI_CUSTOM_DASHBOARD_POSITION(
MENU_KEY  INT(11)  NOT NULL    COMMENT '메뉴 KEY',
DASH_KEY  INT(11)  NOT NULL    COMMENT 'DASHBOARD KEY',
DASH_ID  VARCHAR(50)  NULL    COMMENT 'DASHBOARD ID',
DASH_X INT(2) NOT NULL COMMENT '항목 X값 위치',
DASH_Y INT(2) NOT NULL COMMENT '항목 Y값 위치',
DASH_WIDTH INT(2) NULL COMMENT '항목 넓이',
DASH_HEIGHT INT(2) NULL COMMENT '항목 높이',
DASH_MIN_WIDTH INT(2) NULL COMMENT '항목 최소 넓이',
DASH_MIN_HEIGHT INT(2) NULL COMMENT '항목 최소 높이',
DASH_MAX_WIDTH INT(2) NULL COMMENT '항목 최대 넓이',
DASH_MAX_HEIGHT INT(2) NULL COMMENT '항목 최대 높이',
PRIMARY KEY (MENU_KEY, DASH_KEY, DASH_X, DASH_Y) ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='UI CUSTOM 대시보드 위치';

CREATE TABLE IF NOT EXISTS UI_CUSTOM_DASHBOARD_POSITION_DEFAULT(
POSITION_SEQ  INT(11)  NOT NULL    COMMENT '포지션 SEQ',
DASH_X INT(2) NOT NULL COMMENT '항목 X값 위치',
DASH_Y INT(2) NOT NULL COMMENT '항목 Y값 위치',
DASH_WIDTH INT(2) NULL COMMENT '항목 넓이',
DASH_HEIGHT INT(2) NULL COMMENT '항목 높이',
DASH_MIN_WIDTH INT(2) NULL COMMENT '항목 최소 넓이',
DASH_MIN_HEIGHT INT(2) NULL COMMENT '항목 최소 높이',
DASH_MAX_WIDTH INT(2) NULL COMMENT '항목 최대 넓이',
DASH_MAX_HEIGHT INT(2) NULL COMMENT '항목 최대 높이',
PRIMARY KEY (POSITION_SEQ, DASH_X, DASH_Y) ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='UI CUSTOM 대시보드 위치 템플릿';


CREATE TABLE IF NOT EXISTS UI_MENU (
MENU_ID VARCHAR(50) NOT NULL COMMENT '메뉴 아이디',
MENU_DEFAULT_NAME VARCHAR(128) DEFAULT NULL COMMENT '디폴트 메뉴명(언어 properties 파일에서 못찾을시 사용)',
P_MENU_ID VARCHAR(50) DEFAULT NULL COMMENT '상위메뉴 아이디',
PKG_TYPE CHAR(1) DEFAULT NULL COMMENT '제품타입(L:LT/LTH, C:CF, M:LT/LTH+CF)',
MENU_AUTH CHAR(1) DEFAULT NULL COMMENT '메뉴 권한(S:시스템 운용자, M:모니터링 운용자)',
MENU_LINK VARCHAR(512) DEFAULT NULL COMMENT '메뉴 이동링크',
MENU_ICON VARCHAR(50) DEFAULT NULL COMMENT '메뉴 아이콘 아이디',
MENU_ORDER INT(2) DEFAULT NULL COMMENT '정렬순서',
MENU_USEYN CHAR(1) DEFAULT 'Y' COMMENT '사용여부(Y/N)',
PRIMARY KEY (MENU_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='메뉴 관리';

INSERT IGNORE INTO UI_MENU VALUES ('DATA_MONITOR','데이터 모니터링',NULL,'L','M',NULL,'glyphicon glyphicon-list-alt',1,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('DASHBOARD','Dashboard','DATA_MONITOR','L','M','ems/index.do','fa fa-dashboard',1,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('DASHBOARD_MENU','Dashboard 메뉴','DASHBOARD','L','M','ems/dashboardMenu.do','fa fa-sort-amount-asc',2,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('DASHBOARD_SETUP','Dashboard 관리','DASHBOARD','L','M','ems/dashboardSetup.do','fa fa-cogs',3,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('MESSAGE','메시지','DATA_MONITOR','L','M','','fa fa-envelope',2,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('MESSAGE_INFO','메시지 정보','MESSAGE','L','M','ems/message.do','fa fa-envelope',1,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('DATA_MONITOR.MESSAGE_SERVICE=메신저 모아보기menuArr.push({id:''MESSAGE_SERVICE'',		name:''<s:message code="DATA_MONITOR.MESSAGE_SERVICE"/>'',  		p_id:''DATA_MONITOR''}); //메신저 모아보기','메신저 모아보기','MESSAGE','L','M','ems/msg/messenger.do','fa fa-envelope',3,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('GENERATIVEAI_SERVICE','생성형AI 모아보기','MESSAGE','L','M','ems/msg/generativeAi.do','fa fa-envelope',4,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('NOTE_SERVICE','노트 모아보기','MESSAGE','L','M','ems/msg/note.do','fa fa-envelope',5,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('FILETRANSFER_SERVICE','파일전송 모아보기','MESSAGE','L','M','ems/msg/fileTransfer.do','fa fa-envelope',6,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('INTEREST_USER','관심 사용자 관리','DATA_MONITOR','L','M','ems/interestUser.do','fa fa-male',3,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_REPORT','리포트','DATA_MONITOR','L','M','ems/report.do','fa fa-file-text-o',4,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('RESERVATION_ALARM','예약 알림','DATA_MONITOR','L','M','ems/reservationAlarm.do','fa fa-calendar',5,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('KEYWORD_MGMT','예약어 관리','DATA_MONITOR','L','M','ems/keywordInfo.do','fa fa-tasks',6,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('CONSENT_MGMT','동의서 관리','DATA_MONITOR','L','M','ems/consent.do','fa fa-flask',7,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('BUSI_IPRANGE_VIEW','사업장 내부 IP 확인','DATA_MONITOR','L','M','commons/ipRangeView.do','fa fa-building',8,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('DEPT_IPRANGE_VIEW','부서 내부 IP 확인','DATA_MONITOR','L','M','commons/ipRangeDeptView.do','fa fa-building',9,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('RELATION_KEYWORD','연관 검색어 관리','DATA_MONITOR','L','M','ems/searchWordInfo.do','fa fa-building',10,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('REGEX_PATTERN','정규식 패턴 관리','DATA_MONITOR','L','M','''ems/regexPatternInfo.do','fa fa-building',11,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('DATA_ANALYSIS','통계/분석',NULL,'L','M',NULL,'fa fa-area-chart',2,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('ANALYSIS_RELATION','데이터 관계 분석','DATA_ANALYSIS','L','M','analysis/dataRelation.do','fa fa-share-alt',1,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('ANALYSIS_FLUCTUATION','사용량 증감 분석','DATA_ANALYSIS','L','M','analysis/usageCompare.do','fa fa-area-chart',2,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('ANALYSIS_CUSTOM','데이터 자유 분석','DATA_ANALYSIS','L','M','analysis/dataFreedom.do','fa fa-cube',3,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('ANALYSIS_INFO','개인정보 유출 관계 분석','DATA_ANALYSIS','L','M','analysis/infoStat.do','fa fa-cube',4,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_LABEL','통계','DATA_ANALYSIS','L','M','','fa fa-area-chart',4,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_USER','사용자 통계','STAT_LABEL','L','M','ems/usersStat.do','fa fa-pie-chart',1,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_INTEREST','관심 사용자 통계','STAT_LABEL','L','M','ems/interestUserStat.do','fa fa-pie-chart',2,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_SENDER','발신자 통계','STAT_LABEL','L','M','ems/senderStat.do','fa fa-pie-chart',3,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_SVC','서비스타입 통계','STAT_LABEL','L','M','ems/serviceStat.do','fa fa-pie-chart',4,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_KWD','예약어 통계','STAT_LABEL','L','M','ems/keywordStat.do','fa fa-pie-chart',5,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_ATTACHTYPE','첨부 파일 통계','STAT_LABEL','L','M','ems/attachTypeStat.do','fa fa-pie-chart',6,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_ATTACHNAME','첨부 파일명 통계','STAT_LABEL','L','M','ems/attachNameStat.do','fa fa-pie-chart',7,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_URL','URL 통계','STAT_LABEL','L','M','ems/hostStat.do','fa fa-pie-chart',8,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_ADMINREAD','운용자 열람 통계','STAT_LABEL','L','M','ems/adminReadStat.do','fa fa-pie-chart',9,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_DEVTRAFFIC','장비 트래픽 통계','STAT_LABEL','L','M','ems/trafficStat.do','fa fa-pie-chart',10,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_OCR','OCR 통계','STAT_LABEL','L','M','ems/ocrStat.do','fa fa-pie-chart',11,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('STAT_INFOTYPE','정보 분류 통계','STAT_LABEL','L','M','ems/infoTypeStat.do','fa fa-pie-chart',12,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('POLICY_SETUP','정책 설정',NULL,'L','S',NULL,'glyphicon glyphicon-eye-close',3,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('POLICY_NOLOG','데이터 미로깅 정책','POLICY_SETUP','L','S','uacs/filterInfo.do','fa fa-unlink',1,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('OPERATION_MGMT','운용 관리',NULL,'L','M',NULL,'glyphicon glyphicon-th',4,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('DEV','장비','OPERATION_MGMT','L','M',NULL,'fa fa-desktop',1,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('DEV_INFO','장비 정보','DEV','L','M','commons/deviceInfo.do','fa fa-desktop',1,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('DEV_EVENTLOG','장비 이벤트 로그','DEV','L','M','commons/eventLog.do','fa fa-bell',2,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('ORG','조직','POLICY_SETUP','L','S',NULL,'fa fa-users',3,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('ORG_MGMT','조직 관리','ORG','L','S','commons/organizationInfo.do','fa fa-users',1,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('USER_MGMT','사용자 관리','ORG','L','S','commons/userInfo.do','fa fa-user',2,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('USER_GROUP_MGMT','사용자 그룹','ORG','L','S','commons/userGroup.do','fa fa-user-circle',3,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('BUSI_IPRANGE','사업장 내부 IP 설정','ORG','L','S','commons/ipRange.do','fa fa-building',4,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('DEPT_IPRANGE','부서 내부 IP 설정','ORG','L','S','commons/ipRangeDept.do','fa fa-building',5,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('CODE_INFO','코드 정보','OPERATION_MGMT','L','S','commons/codeInfo.do','fa fa-list-ul',3,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('ADMIN_MGMT','운용자 관리','OPERATION_MGMT','L','S','commons/admin.do','fa fa-unlock-alt',4,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('HOLIDAY_LABEL','업무/휴일 설정','OPERATION_MGMT','L','S','','fa fa-calendar',5,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('HOLIDAY_BUSI','사업장 업무일/휴일','HOLIDAY_LABEL','L','S','commons/holidayBusiness.do','fa fa-calendar-check-o',1,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('HOLIDAY_LEGAL','법정 공휴일','HOLIDAY_LABEL','L','S','commons/holidayLegal.do','fa fa-calendar-o',2,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('SEARCH_LOG','조회이력','OPERATION_MGMT','L','S','commons/searchLog.do','fa fa-pencil',6,'Y');
INSERT IGNORE INTO UI_MENU VALUES ('AUDIT_LOG','운용자 감사 로그','OPERATION_MGMT','L','S','commons/auditLog.do','fa fa-pencil-square',7,'Y');

UPDATE UI_MENU SET MENU_ORDER=3 WHERE MENU_ID='MESSAGE_SERVICE';
UPDATE UI_MENU SET MENU_AUTH='M' WHERE MENU_ID='OPERATION_MGMT';
UPDATE UI_MENU SET MENU_AUTH='M' WHERE MENU_ID='DEV';
UPDATE UI_MENU SET MENU_AUTH='M' WHERE MENU_ID='DEV_INFO';
UPDATE UI_MENU SET MENU_AUTH='M' WHERE MENU_ID='DEV_EVENTLOG';

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

INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (1,'패턴(개인정보)메시지','D','unread','total','P','svc1','total','fa fa-user','panel-primary','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashmultileft="unread" data-dashmultiright="total"></div>
			<div class="grid-stack-item-content">
				<div class="panel panel-primary">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-3" style="padding-right:0;">
								<i class="customClass fa fa-user fa-3x"></i>
							</div>
							<div class="col-xs-9 text-right">
								<button type="button" class="customClose">
									<span aria-hidden="true">×</span>
								</button>
								<div class="position_top35"><span class="leftValue odometerxcn"></span> / <span class="rightValue huge odometerxcn"> </span></div>
								<form method="post" action="/emass/ems/message.do" target="_self">
									<input type="hidden" name="conditionParam">
								</form>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title">패턴(개인정보)메시지</span>
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">당일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","readYn":"","receiveSend":"","ctimeWork":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"Y","regexpVal":"PN%L@1|FN%L@1|DN%L@1|SN%L@1|CN%L@1","regexpStr":"여권번호(1건 이상), 외국인 등록번호(1건 이상), 운전면허번호(1건 이상), 주민번호(1건 이상), 카드번호(1건 이상)","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','미열람/전체','Y');
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (2,'패턴(위험행위)메시지','D','unread','total','P','svc1','total','fa fa-warning','panel-red','
		<div class="grid-stack-item ui-draggable-handle">
			<div class="gridValues" style="display: none;" data-dashmultiright="total" data-dashmultileft="unread"></div>
			<div class="grid-stack-item-content">
				<div class="panel panel-red">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-3" style="padding-right: 0px;">
								<i class="customClass fa fa-warning fa-3x"></i>
							</div>
							<div class="col-xs-9 text-right">
								<button class="customClose" type="button">
									<span aria-hidden="true">×</span>
								</button>
								<div class="position_top35"><span class="leftValue odometerxcn"></span> / <span class="rightValue huge odometerxcn"> </span></div>
								<form action="/emass/ems/message.do" method="post" target="_self">
									<input name="conditionParam" type="hidden">
								</form>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title">패턴(위험행위)메시지</span>
						<div title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59" class="termDtStr">당일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"Y","regexpVal":"EC%L@1|EF%L@1|ID%L@1","regexpStr":"확장자 변조 파일(1건 이상),   암호화 파일(1건 이상),   송수신자 동일아이디(1건 이상)","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','','Y');
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (3,'키워드(예약어)','D','unread','total','P','svc1','total','fa fa-font','panel-red','
		<div class="grid-stack-item ui-draggable-handle">
			<div class="gridValues" style="display: none;" data-dashmultiright="total" data-dashmultileft="unread"></div>
			<div class="grid-stack-item-content">
				<div class="panel panel-red">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-3" style="padding-right: 0px;">
								<i class="customClass fa fa-font fa-3x"></i>
							</div>
							<div class="col-xs-9 text-right">
								<button class="customClose" type="button">
									<span aria-hidden="true">×</span>
								</button>
								<div class="position_top35"><span class="leftValue odometerxcn"></span> / <span class="rightValue huge odometerxcn"> </span></div>
								<form action="/emass/ems/message.do" method="post" target="_self">
									<input name="conditionParam" type="hidden">
								</form>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title">키워드(예약어)</span>
						<div title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59" class="termDtStr">당일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"Y","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','','Y');
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (4,'서비스별 데이터 수집건수','C','unread','total','B','svc1','total','fa fa-bar-chart','panel-white','
		<div class="grid-stack-item ui-draggable-handle">
			<div class="gridValues" style="display: none;" data-dashmultiright="total" data-dashmultileft="unread"></div>
			<div class="grid-stack-item-content">
				<div class="panel panel-white">
					<div class="panel-body">
						<div class="row">
							<div class="col-xs-12 text-right">
								<button class="customClose" type="button">
									<span aria-hidden="true">×</span>
								</button>
								<div class="dashChartArea" style="margin: 0px auto; width: 100%; height: 100%; min-height: 200px;" data-charttype="B"></div>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title"><i class="customClass chartDash fa fa-bar-chart" style="padding-right: 4px; position: relative;"></i>서비스별 데이터 수집건수</span>
						<div title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59" class="termDtStr">당일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","readYn":"","receiveSend":"","ctimeWork":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','','Y');
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (5,'외부 메일 발신 서비스 비율','C','unread','total','P','svc1','total','fa fa-pie-chart','panel-white','
		<div class="grid-stack-item ui-draggable-handle">
			<div class="gridValues" style="display: none;" data-dashmultiright="total" data-dashmultileft="unread"></div>
			<div class="grid-stack-item-content">
				<div class="panel panel-white">
					<div class="panel-body">
						<div class="row">
							<div class="col-xs-12 text-right">
								<button class="customClose" type="button">
									<span aria-hidden="true">×</span>
								</button>
								<div class="dashChartArea" style="margin: 0px auto; width: 100%; height: 100%; min-height: 200px;" data-charttype="P"></div>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title"><i class="customClass chartDash fa fa-pie-chart" style="padding-right: 4px; position: relative;"></i>외부 메일 발신 서비스 비율</span>
						<div title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59" class="termDtStr">당일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"MP3,MSM,MIM,WNV,WDU,WCL,WNT,WKR,WUT,WNA,WYA,WSN,WSU,WDW,WYH,WGG,WYI,WLV,WQQ,WOS,WOT,WUK,WBM,WPO,EBD,EBB,EAA,EMM,EMB,EWS,EPU,ESC,EMF,EMU","serviceTypeNm":"POP3, SMTP, IMAP, 네이버, 다음, 천리안, 네이트, 코리아, 유니텔, 네띠앙, Yeah, SINA, SOHU, 야후, 구글, 용인시, Live.com, QQ, 163, 126, 기타, KT비즈메카, 우체국, 게시, 게시판, 결재, 메일, 모바일, 웹서비스, 일반, 일정 명함, 파일 다운로드, 기타","infoType":"","infoTypeNm":"정보 분류 전체","feedbackType":"","feedbackTypeNm":"피드백 전체","interGroup":"","interGroupNm":"-관심 사용자 선택-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"Y","startTimeSelect":"00","endDateSelect":"Y","endTimeSelect":"23","senders":"","receivers":"","allOfus":"ET|EA","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","receiveSend":"O","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":0,"sizeEndVal":0,"sizeOption":"L","sizeType":""}','','Y');
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (6,'1MB 이상 파일 전송','S','unread','total','P','svc1','total','fa fa-save','panel-primary','
		<div class="grid-stack-item ui-draggable-handle">
			<div class="gridValues" style="display: none;" data-dashmultiright="total" data-dashmultileft="unread"></div>
			<div class="grid-stack-item-content">
				<div class="panel panel-primary">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-2" style="padding-right: 0px;">
								<i class="customClass fa fa-save" style="font-size: 35px;"></i>
							</div>
							<div class="col-xs-10 text-right" style="padding-left: 0px;">
								<button class="customClose" type="button">
									<span aria-hidden="true">×</span>
								</button>
								<div class="position_top35"><span class="rightValue huge odometerxcn"></span></div>
								<form action="/emass/ems/message.do" method="post" target="_self">
									<input name="conditionParam" type="hidden">
								</form>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title">1MB 이상 파일 전송</span>
						<div title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59" class="termDtStr">당일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"1048576","sizeEndVal":"0","sizeOption":"L","sizeType":""}','','Y');
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (7,'외부 발신 데이터','D','unread','total','P','svc1','total','fa fa-envelope','panel-yellow','
		<div class="grid-stack-item ui-draggable-handle">
			<div class="gridValues" style="display: none;" data-dashmultiright="total" data-dashmultileft="unread"></div>
			<div class="grid-stack-item-content">
				<div class="panel panel-yellow">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-3" style="padding-right: 0px;">
								<i class="customClass fa fa-envelope fa-3x"></i>
							</div>
							<div class="col-xs-9 text-right">
								<button class="customClose" type="button">
									<span aria-hidden="true">×</span>
								</button>
								<div class="position_top35"><span class="leftValue odometerxcn"></span> / <span class="rightValue huge odometerxcn"> </span></div>
								<form action="/emass/ems/message.do" method="post" target="_self">
									<input name="conditionParam" type="hidden">
								</form>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title">외부 발신 데이터</span>
						<div title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59" class="termDtStr">당일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","readYn":"","receiveSend":"O","ctimeWork":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','','Y');
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (8,'비업무시간 데이터','D','unread','total','P','svc1','total','fa fa-users','panel-green','
		<div class="grid-stack-item ui-draggable-handle">
			<div class="gridValues" style="display: none;" data-dashmultiright="total" data-dashmultileft="unread"></div>
			<div class="grid-stack-item-content">
				<div class="panel panel-green">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-3" style="padding-right: 0px;">
								<i class="customClass fa fa-users fa-3x"></i>
							</div>
							<div class="col-xs-9 text-right">
								<button class="customClose" type="button">
									<span aria-hidden="true">×</span>
								</button>
								<div class="position_top35"><span class="leftValue odometerxcn"></span> / <span class="rightValue huge odometerxcn"> </span></div>
								<form action="/emass/ems/message.do" method="post" target="_self">
									<input name="conditionParam" type="hidden">
								</form>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title">비업무시간 데이터</span>
						<div title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59" class="termDtStr">당일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","receiveSend":"","ctimeWork":"R","readYn":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','','Y');
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (9,'그룹웨어 데이터','D','unread','total','P','svc1','total','fa fa-area-chart','panel-green','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashmultileft="unread" data-dashmultiright="total"></div>
			<div class="grid-stack-item-content">
				<div class="panel panel-green">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-3" style="padding-right:0;">
								<i class="customClass fa fa-area-chart fa-3x"></i>
							</div>
							<div class="col-xs-9 text-right">
								<button type="button" class="customClose">
									<span aria-hidden="true">×</span>
								</button>
								<div class="position_top35"><span class="leftValue odometerxcn"></span> / <span class="rightValue huge odometerxcn"> </span></div>
								<form method="post" action="/emass/ems/message.do" target="_self">
									<input type="hidden" name="conditionParam">
								</form>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title">그룹웨어 데이터</span>
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">당일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"EBD,EBB,EAA,EMM,EMB,EWS,EPU,ESC,EMF,EMU","serviceTypeNm":"게시, 게시판, 결재, 메일, 모바일, 웹서비스, 일반, 일정 명함, 파일 다운로드, 기타","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","readYn":"","receiveSend":"","ctimeWork":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','미열람/전체','Y');
INSERT IGNORE INTO UI_CUSTOM_DASHBOARD_DEFAULT(DASH_KEY,DASH_NAME,DASH_TYPE,DASH_MULTI_X,DASH_MULTI_Y,DASH_CHART,DASH_CHART_X,DASH_CHART_Y,DASH_ICON,DASH_COLOR,DASH_HTML,DASH_CONDITION,DASH_COMMENT,USEYN) values (10,'금일 수집 데이터','S','unread','total','P','svc1','total','fa fa-envelope','panel-primary','
		<div class="grid-stack-item ui-draggable-handle">
			<div style="display:none;" class="gridValues" data-dashmultileft="unread" data-dashmultiright="total"></div>
			<div class="grid-stack-item-content">
				<div class="panel panel-primary">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-2" style="padding-right:0;">
								<i class="customClass fa fa-envelope" style="font-size:35px;"></i>
							</div>
							<div class="col-xs-10 text-right" style="padding-left:0;">
								<button type="button" class="customClose">
									<span aria-hidden="true">×</span>
								</button>
								<div class="position_top35"><span class="rightValue huge odometerxcn"></span></div>
								<form method="post" action="/emass/ems/message.do" target="_self">
									<input type="hidden" name="conditionParam">
								</form>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<span class="pull-left dash-title">금일 수집 데이터</span>
						<div class="termDtStr" title="2018-01-01 00:00:00 ~ 2018-01-01 23:59:59">당일</div>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>
		</div>
	','{"searchStr":"","searchField":"","serviceType":"","serviceTypeNm":"서비스 전체","interGroup":"","interGroupNm":"-관심 사용자 그룹-","userGroupSeq":"","userGroupName":"-사용자 그룹-","startDateSelect":"T","startTimeSelect":"00","endDateSelect":"T","endTimeSelect":"23","senders":"","receivers":"","allOfus":"","busi":"","busiNm":"사업장 전체","dept":"","deptNm":"","receiveSend":"","ctimeWork":"","readYn":"","attachYn":"","attachVal":"","attachStr":"","keywordYn":"","keywordVal":"","keywordStr":"","regexpYn":"","regexpVal":"","regexpStr":"","drmYn":"","sctYn":"","sizeStartVal":"0","sizeEndVal":"0","sizeOption":"L","sizeType":""}','','Y');
















INSERT INTO UI_CUSTOM_DASHBOARD_MENU(MENU_KEY,MENU_NAME,MENU_ICON,ADMIN_ID,USEYN,DEFAULT_MENU,UPDATE_DT)
SELECT @ROWNUM:=@ROWNUM+1 AS MENU_KEY,'Default Dashboard','fa fa-th',A.ADMIN_ID,'Y','Y',NOW()
FROM (SELECT * FROM UI_ADMIN ORDER BY ADMIN_ID) A, (SELECT @ROWNUM:=-1) B
WHERE NOT EXISTS (SELECT * FROM UI_CUSTOM_DASHBOARD_MENU WHERE MENU_KEY=0 );


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


/*
INSERT INTO `UI_CUSTOM_DASHBOARD_POSITION`(`MENU_KEY`,`DASH_KEY`,`DASH_ID`,`DASH_X`,`DASH_Y`,`DASH_WIDTH`,`DASH_HEIGHT`,`DASH_MIN_WIDTH`,`DASH_MIN_HEIGHT`,`DASH_MAX_WIDTH`,`DASH_MAX_HEIGHT`)
SELECT  MENU_KEY, DASH_KEY, CONCAT(MENU_KEY, '_', DASH_KEY) AS DASH_ID, X.DASH_X, X.DASH_Y, X.DASH_WIDTH, X.DASH_HEIGHT, X.DASH_MIN_WIDTH, X.DASH_MIN_HEIGHT, X.DASH_MAX_WIDTH, X.DASH_MAX_HEIGHT
FROM    (
        SELECT  CASE WHEN @TMP != A.ADMIN_ID THEN @ROWNUM:=1 ELSE @ROWNUM:=@ROWNUM+1 END IDX,
                @TMP:=A.ADMIN_ID,
                DASH_KEY, DASH_NAME, DASH_TYPE, DASH_MULTI_X, DASH_MULTI_Y, DASH_CHART, DASH_CHART_X, DASH_CHART_Y, DASH_ICON, DASH_COLOR, DASH_HTML, DASH_CONDITION, DASH_COMMENT, ADMIN_ID, USEYN
        FROM    VENUS.UI_CUSTOM_DASHBOARD A, (SELECT @ROWNUM:=0) D, (SELECT @TMP:='') T
        ) R, UI_CUSTOM_DASHBOARD_POSITION_DEFAULT X, UI_CUSTOM_DASHBOARD_MENU Y
WHERE   R.IDX = X.POSITION_SEQ
AND     R.ADMIN_ID = Y.ADMIN_ID
AND   (SELECT COUNT(*) FROM UI_CUSTOM_DASHBOARD_POSITION )=0;
*/

CREATE TABLE IF NOT EXISTS `UI_ADMIN_CEO_GROUP` (
	GROUP_CODE  VARCHAR(60) NOT NULL COMMENT '그룹 코드',
	ADMIN_ID	VARCHAR(50)	NOT NULL,
	  PRIMARY KEY (`GROUP_CODE`,`ADMIN_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='운용자별 CEO 사용자 그룹';


CREATE TABLE IF NOT EXISTS UI_DEPT_IPRANGE(
DEPTCD  varchar(20)  NOT NULL    COMMENT '부서 코드',
START_IP  varchar(64)  NOT NULL    COMMENT '시작 아이피',
END_IP  varchar(64)  NOT NULL    COMMENT '끝 아이피',
COMMENT  varchar(500)  NULL    COMMENT '설명',
CREATE_DT  datetime  NULL    COMMENT '생성일',
PRIMARY KEY (DEPTCD, START_IP, END_IP)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='부서 내부 아이피';

/*
CREATE TABLE IF NOT EXISTS UI_ADMIN_DEPT(
ADMIN_ID  VARCHAR(50)  NOT NULL    COMMENT '운용자 아이디',
DEPTCD  VARCHAR(20)  NOT NULL    COMMENT '부서 코드',
SORT  INT(11)  NOT NULL    COMMENT '정렬 순서',
PRIMARY KEY (ADMIN_ID, DEPTCD)     ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='운용자 부서 권한';
*/