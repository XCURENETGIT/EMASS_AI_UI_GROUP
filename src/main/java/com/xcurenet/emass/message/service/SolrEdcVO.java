package com.xcurenet.emass.message.service;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import javax.annotation.Nullable;
import java.util.List;
import java.util.Map;

@JsonInclude(Include.NON_NULL)
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Nullable
@JsonIgnoreProperties(ignoreUnknown = true)
//@Document(indexName = "edc_*")
public class SolrEdcVO {

    /*********************************************************
     * Message Grid
     *********************************************************/
    @Id
    @Field(type = FieldType.Text)
    private String msgid;

    public String epmsg_type;

    public String interestUserYn = "N";

    public String xrootmtr;

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    public String interestGroupColor;


    public int ml_confd_class;

    public int ml_confd_feedback;

    public float ml_confd_prob;

    public int attachcnt;

    public String inside;

    public String direction_svc;

    public String svcNm;

    public String subject;

    public String ctimeFormat;

    public String user;

    public String businm;

    public String deptnm;

    public String jikgubnm;
    public String sender;

    public String org_sender;

    public List<String> allofus;

    public List<String> recvs;

    public List<String> recvs_name;

    public List<String> to;

    public List<String> cc;

    public List<String> bcc;

    public List<String> tname;

    public String srcip;

    public String dstip;

    public List<String> attachname;

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    public List<String> kwds;

    public String sizeStr;

    public String bodySizeStr;

    public String attachSizeStr;

    public int pi_total;

    public int ocr_attach_cnt;

    public int reprocess;

    public String sabun;

    public Long body_size;

    public Long attachSizeSort;

    public List<Map<String, Integer>> srcIpList;

    public String recvsInOutInfo;

    public String recvsStr;

    public String toInOutInfo;

    public String ccInOutInfo;

    public String bccInOutInfo;

    public String ltime;

    public String ctime;
    public String ctime_yyyy;
    public String ctime_yyyymm;
    public String ctime_yyyymmdd;
    public String ctime_hh;

    public String date_hh;
    public String date_yyyy;
    public String date_yyyymm;
    public String date_yyyymmdd;

    public String detectionKeywordText; //한 메세지에서의 검출 키워드들 (제목,본문,첨부파일명,첨부파일)요약

    public String detectionKeywordType;

    /*********************************************************
     *********************************************************/


    public String svc;

    public String senderId;

    public String svc1;

    public String svc2;

    public String svc3;

    public String svc12;

    public String usrId;

    public String usr_ip;

    public String userkey;

    public String userid;

    public String name;

    private String kwds_subject;

    public String host;

    public String path;

    public String xmsgkey;

    public String sname;

    public String cocd;

    public String conm;

    public String suborgcd;

    public String suborgnm;

    public int attachexistcnt;

    public String busicd;

    public String deptcd;

    public String jikgubcd;

    public String ip_cocd;

    public String ip_conm;

    public String ip_busicd;

    public String ip_businm;

    public String ip_deptcd;

    public String ip_deptnm;


    public String attached;

    public String direction;

    public String kwd;

    public int docCount;


    public String protocol;

    public String readYn;

    public String svcLv1Nm;

    public String svcLv2Nm;

    public String body_language;

    public String senderOrig;

    public String consentNo;

    public String title;

    public List<Map<String, Object>> overlap;

    public String user_str;

    public String confidence;

    //JsonIgnore JSON 리턴 X


    @JsonIgnore
    public String cid;

    @JsonIgnore
    public int sport;

    @JsonIgnore
    public int dport;



    @JsonIgnore
    public String ml_confd_class_label;

    @JsonIgnore
    public String ml_confd_feedback_label;

    @JsonIgnore
    public long size;

    @JsonIgnore
    public String usr_id;


    @JsonIgnore
    public String work;

    @JsonIgnore
    public List<String> attachname_str;

    public List<Long> attachsize;

    @JsonIgnore
    public List<String> attachhash;

    public List<String> attachtype;

    public String body_snippet;

    @JsonIgnore
    public int pi_FN;
    @JsonIgnore
    public int pi_SN;
    @JsonIgnore
    public int pi_DN;
    @JsonIgnore
    public int pi_CN;
    @JsonIgnore
    public int pi_PN;
    @JsonIgnore
    public int pi_MN;
    @JsonIgnore
    public int pi_AN;
    @JsonIgnore
    public int pi_CRN;
    @JsonIgnore
    public int pi_SSN;
    @JsonIgnore
    public int pi_IMEI;
    @JsonIgnore
    public int pi_BRN;
    @JsonIgnore
    public int pi_CPN;
    @JsonIgnore
    public int pi_MCN;

    @JsonIgnore
    public String content;


    @JsonIgnore
    public List<Map<String, Object>> checked;

    @JsonIgnore
    public float score; // 연관도


    @JsonIgnore
    public List<Map<String, Object>> pi_amount;

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    public Map<String, Object> piMap;

    @JsonIgnore
    public Map<String, List<Map<String, Object>>> recvs_info;

    @JsonIgnore
    public Map<String, String> regexpHighlight;

}
