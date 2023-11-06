package com.xcurenet.emass.message.vo.emass.els;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.xcurenet.emass.message.vo.emass.els.fields.HttpVo_Els;
import com.xcurenet.emass.message.vo.emass.els.fields.NetworkVo_Els;
import com.xcurenet.emass.message.vo.emass.els.fields.ServiceVo_Els;
import com.xcurenet.emass.message.vo.emass.els.fields.UserVo_Els;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.Date;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable

/***
 *  elastic search Db -> App server 받아오기 위한 Vo
 *  조회 기록 
 */
public class EmassHistory {

    private String	_id;//	메시지 아이디
    private Date ltime;	//로깅타임
    private Date	ctime;	//캡쳐타임
    private String	ctime_yyyy;	//캡쳐타임_년
    private String	ctime_yyyymm;//	캡쳐타임_년월
    private String	ctime_yyyymmdd; //캡쳐타임_년월일
    private String	ctime_yyyymmddhh;//	캡쳐타임_년월일시
    private String	keyword;    //	검색 키워드

    private ServiceVo_Els service;
    private NetworkVo_Els network;
    private HttpVo_Els http;
    private UserVo_Els user;

}
