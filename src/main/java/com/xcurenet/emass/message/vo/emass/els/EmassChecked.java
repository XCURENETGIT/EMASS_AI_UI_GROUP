package com.xcurenet.emass.message.vo.emass.els;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable

/***
 *  elastic search Db -> App server 받아오기 위한 Vo
 *  조회 기록
 */
public class EmassChecked {
    private String	_id;//	doc 아이디
    private String  ltime;	//로깅타임
    private String	ctime;	//캡쳐타임
    private String	ctime_yyyy;	//캡쳐타임_년
    private String	ctime_yyyymm;//	캡쳐타임_년월
    private String	ctime_yyyymmdd; //캡쳐타임_년월일
    private String	ctime_yyyymmddhh;//	캡쳐타임_년월일시
    private String  ctime_hh ;
    private String	keyword;    //	검색 키워드

    private String user_id; // 유저 아이디
    private String user_busiCd;  // 사업장 코드
    private String user_ipBusiCd; // 사업장 코드 (SRC_IP)
    private String service_svc; // 서비스타입
}
