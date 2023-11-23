package com.xcurenet.emass.message.vo.emass.els;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.Date;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
/***
 *   App server -> client 표시위한 재가공 Vo
 */
public class EmassResponse {

	private String	msgid; //	엘라스틱서치 아이디
	private String	ltime; //	로깅타임
	private String	ctime; //	캡쳐타임
	private String	ctimeYYYY; //	ctime 연도
	private String	ctimeYYYYMM; //	ctime 연월
	private String	ctimeYYYYMMDD; //	ctime 연월일
	private String	ctimeYYYYMMDDHH; //	ctime 연월일시
	private String	ctimeHH; //	ctime 시간
	private String	subject; //	제목
	private String	attached; //	첨부 존재 유무
	private int	attachExistCnt; //	첨부 존재 개수
	private int	attachCnt; //	첨부파일 개수
	private String	size; //	전체사이즈
	private String	allOfUs; //	수신자 소속여부
	private String	directionSvc; //	서비스타입으로 방향성 구분 (I/O)
	private String	direction; //	Inbound, Outbound (I/O)
	private String	xrootMtr; //	원본의 답신/전달 메일에 부여되는 원본 ID
	private String	xmsgKey; //	메시지 키값
	private String	xparentMtr; //	ParentMTR (마이싱글)
	private String	password; //	비밀번호
	private String	siteAttr; //	DIP 속성이 있을 경우 DIP로 사업장 맵핑
	private String	siteCode; //	사업장 코드 매핑용도
	private String	epmsgType; //	녹스(대외비 구분값)
	private String	epHeader; //	서비스타입 유추를 위한 필드
	private String	usrId; //	사용자구분 아이디
	private String	usrIp; //	사용자구분 아이피
	private String	opinion; //	상신의견(EP)

	private int	piTotal; //	패턴 전체 검출 건수
	private int	piDRM; //	패턴(DRM) 검출 건수
	private int	piID; //	패턴(송수신동일아이디) 검출 건수
	private int	piEF; //	패턴(암호화파일) 검출 건수
	private int	pi_PN; //	패턴(여권번호) 검출 건수
	private int	pi_DN; //	패턴(운전면허번호) 검출 건수
	private int	pi_SN; //	패턴(주민번호) 검출 건수
	private int	pi_CN; //	패턴(카드번호) 검출 건수
	private int	pi_EC; //	패턴(확장자변조) 검출 건수
	private int	pi_FN;


	/* ######## service ######################################################################################################################*/
	private String	service_svc;  //서비스타입
	private String	service_svc1;  //서비스타입 대분류
	private String	service_svc12;  //서비스타입 대중분류
	private String	service_svc2;  //서비스타입 중분류
	private String	service_svc3;  //서비스타입 소분류

	private String	service_svc_Nm;  //서비스명


	/* ######## body ######################################################################################################################*/
	private int	    body_size; //	본문 사이즈
	private String	body_path; //	본문(원본) 경로
	private String	body_snippet; //	본문 요약
	private String	body_text; //	본문(텍스트) 내용


	/* ######## netWork  ######################################################################################################################*/

	private String	network_srcIp;//	발신자 IP
	private int	network_srcPort;//	발신자 PORT
	private String	network_dstIp;//	목적지 IP
	private int	network_dstPort;//	목적지 PORT
	private String	network_protocol;//	프토토콜
	private String	network_cid;//	세션ID


	/* ######## attach  ######################################################################################################################*/
	private String	attach_id; //	첨부파일 ID
	private String	attach_name; //	첨부파일 이름
	private String	attach_text; //	첨부파일(텍스트) 내용
	private int 	attach_size; //	첨부파일 사이즈
	private String	attach_ext; //	첨부파일 확장자
	private String	attach_hash; //	첨부파일 해시

	private String	attach_sizeStr;   //	첨부파일 사이즈 Str

	/* ------ kwd -------*/
	private List	kwdInfo_kwdsAttach;  //	예약어(첨부내용)
	private List	kwdInfo_kwdsAttachNm;  //	예약어(첨부파일명)
	private String	kwdInfo_kwd;  //	예약어 검출 유무
	private List	kwdInfo_kwds;  //	전체 검출 예약어
	private List	kwdInfo_kwdsBody;  //	예약어(본문)
	private List	kwdInfo_kwdsSubject;  //	에약어(제목)

	/* ------ http -------*/
	private String	http_path;  //	URL PATH
	private String	http_query;  //	URL 쿼리
	private String	http_host;  //	HOST


	/* ------ pi -------*/
	private String	pi_id; //	패턴 탐지 아이디 (EC, ID, EF, PN, FN, DN…)
	private String	pi_type; //
	private String	pi_attachNm; //	탐지 첨부명
	private List	pi_kwds; //	탐지 키워드
	private int	    pi_amount; //	탐지 건수


	/* ------ user -------*/
	private String	user_id; //	사용자 ID
	private String	user_userId; //	사용자 ID
	private String	user_name; //	사용자 이름
	private String	user_ipCoCd; //	회사코드 IP기준
	private String	user_ipCoNm; //	회사명 IP기준
	private String	user_ipBusiCd; //	사업장코드 IP기준
	private String	user_ipBusiNm; //	사명장명 IP기준
	private String	user_ipDeptCd; //	부서코드 IP기준
	private String	user_ipDeptNm; //	부서명 IP기준
	private String	user_coCd; //	회사코드
	private String	user_coNm; //	회사명
	private String	user_busiCd; //	사업장 코드
	private String	user_busiNm; //
	private String	user_suborgCd; //	총괄코드
	private String	user_suborgNm; //	총괄명
	private String	user_deptCd; //	부서코드
	private String	user_deptNm; //	부서명
	private String	user_jikgubCd; //	직급코드
	private String	user_jikgubNm; //	직급명
	private String	user_ceo; //	CEO 여부
	private String	user_inside; //	내부/외부 구분



	/* ------ day -------*/
	private int	day_week;	//몇주차
	private boolean	day_work;	//업무시간 여부

	/* ------ ocr -------*/
	private int	ocr_attachCnt;	//첨부 개수
	private String	ocr_attach;	//첨부 개수

	/* ------ ml -------*/
	private int	ml_mlConfdClass;	 //인덱스 값
	private int	ml_mlConfdFeedback;	 //인덱스 피드백
	private float	ml_mlConfdProb;	 //인덱스 결과 확률

	/* ------ sender  -------*/
	private String	sender_alias;  //	발신자 별칭
	private String	sender_id;  //	발신자 ID
	private String	sender_userId;  //	발신자 아이디(인사연동)
	private String	sender_name;  //	발신자 이름(인사연동)
	private String	sender_email;  //	발신자 이메일 (인사연동)
	private String	sender_ip;  //	수신자 아이피
	private String	sender_coCd;  //	회사코드
	private String	sender_coNm;  //	회사명
	private String	sender_busiCd;  //	사업장 코드
	private String	sender_busiNm;  //	사업장명
	private String	sender_suborgCd;  //	총괄코드
	private String	sender_suborgNm;  //	총괄명
	private String	sender_deptCd;  //	부서코드
	private String	sender_deptNm;  //	부서명
	private String	sender_jikgubCd;  //	직급코드
	private String	sender_jikgubNm;  //	직급명
	private String	sender_ceo;  //	CEO 여부
	private String	sender_inside;  //	내부/외부 구분

	private List<String> to; // 수신자
	private List<String> cc; // 참조자
	private List<String> bcc; // 비밀참조자

	private String	checked_readId; //	메시지 개봉 운용자 아이디
	private Date checked_readDate; //	메시지 개봉 운용자 아이디
	private String	checked_readDateHH; //	메시지 개봉 시간
	private String	checked_readDateYYYY; //	메시지 개봉 년
	private String	checked_readDateYYYYMM; //	메시지 개봉 년월
	private String	checked_readDateYYYYMMDD; //	메시지 개봉 년월일

}
