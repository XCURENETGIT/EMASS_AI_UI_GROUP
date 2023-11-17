package com.xcurenet.emass.message.vo.emass.els;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.xcurenet.emass.message.vo.emass.els.fields.*;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable

/***
 *  elastic search Db -> App server 받아오기 위한 Vo
 *  Emass
 */
public class Emass {

	@JsonProperty("key")
	private String	key;//	엘라스틱서치 아이디
	@JsonProperty("ltime")
	private String	ltime;	//로깅타임
	@JsonProperty("ctime")
	private String	ctime;	//캡쳐타임
	@JsonProperty("ctimeYYYY")
	private String	ctimeYYYY;	//ctime 연도
	@JsonProperty("ctimeYYYYMM")
	private String	ctimeYYYYMM;//	ctime 연월
	@JsonProperty("ctimeYYYYMMDD")
	private String	ctimeYYYYMMDD;	//ctime 연월일
	@JsonProperty("ctimeYYYYMMDDHH")
	private String	ctimeYYYYMMDDHH;//	ctime 연월일시
	@JsonProperty("ctimeHH")
	private String	ctimeHH;//	ctime 시간
	@JsonProperty("subject")
	private String	subject;//	제목
	@JsonProperty("attached")
	private String	attached;//	첨부 존재 유무
	@JsonProperty("attachExistCnt")
	private int	attachExistCnt;	//첨부 존재 개수
	@JsonProperty("attachCnt")
	private int	attachCnt;	//첨부파일 개수
	@JsonProperty("size")
	private int	size;//	전체사이즈
	@JsonProperty("allOfUs")
	private String	allOfUs;//	수신자 소속여부
	@JsonProperty("directionSvc")
	private String	directionSvc;//	서비스타입으로 방향성 구분 (I/O)
	@JsonProperty("direction")
	private String	direction;	//Inbound, Outbound (I/O)
	@JsonProperty("xrootMtr")
	private String	xrootMtr;//	원본의 답신/전달 메일에 부여되는 원본 ID
	@JsonProperty("xmsgKey")
	private String	xmsgKey;//	메시지 키값
	@JsonProperty("xparentMtr")
	private String	xparentMtr;	//ParentMTR (마이싱글)
	@JsonProperty("password")
	private String	password;//	비밀번호
	@JsonProperty("siteAttr")
	private String	siteAttr;//	DIP 속성이 있을 경우 DIP로 사업장 맵핑
	@JsonProperty("siteCode")
	private String	siteCode;//	사업장 코드 매핑용도
	@JsonProperty("epmsgType")
	private String	epmsgType;	//녹스(대외비 구분값)
	@JsonProperty("epHeader")
	private String	epHeader;//	서비스타입 유추를 위한 필드
	@JsonProperty("usrId")
	private String	usrId;	//사용자구분 아이디
	@JsonProperty("usrIp")
	private String	usrIp;	//사용자구분 아이피
	@JsonProperty("opinion")
	private String	opinion;//	상신의견(EP)

	@JsonProperty("piTotal")
	private int	piTotal;//	패턴 전체 검출 건수
	@JsonProperty("piDRM")
	private int	piDRM;//	패턴(DRM) 검출 건수
	@JsonProperty("piID")
	private int	piID;//	패턴(송수신동일아이디) 검출 건수
	@JsonProperty("piEF")
	private int	piEF;//	패턴(암호화파일) 검출 건수
	@JsonProperty("piPN")
	private int	piPN;//	패턴(여권번호) 검출 건수
	@JsonProperty("piDN")
	private int	piDN;//	패턴(운전면허번호) 검출 건수
	@JsonProperty("piSN")
	private int	piSN;//	패턴(주민번호) 검출 건수
	@JsonProperty("piCN")
	private int	piCN;//	패턴(카드번호) 검출 건수
	@JsonProperty("piEC")
	private int	piEC;//	패턴(확장자변조) 검출 건수


	@JsonProperty("service")
	private ServiceVo_Els service; // 서비스

	@JsonProperty("body")
	private BodyVo_Els body; //body

	@JsonProperty("network")
	private NetworkVo_Els network; // network

	@JsonProperty("attach")
	private List<AttachVo_Els> attach; // attach

	@JsonProperty("kwdInfo")
	private KwdVo_Els kwdInfo; // kwdInfo

	@JsonProperty("http")
	private HttpVo_Els http; // http

	@JsonProperty("pi")
	//private PiVo_Els pi; // pi
	private List<PiVo_Els> pi;

	@JsonProperty("user")
	private UserVo_Els user; // user

	@JsonProperty("day")
	private DayVo_Els day; // day

	@JsonProperty("ocr")
	private OcrVo_Els ocr; // ocr

	@JsonProperty("ml")
	private MlVo_Els ml; // ml

	@JsonProperty("sender")
	private ComProperties_Els sender; // sender

	@JsonProperty("recv")
	private RecvVo_Els recv; // recv

	@JsonProperty("checked")
	private CheckedVo_Els checked; // checked

}
