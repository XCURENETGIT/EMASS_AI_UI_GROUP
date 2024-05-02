package com.xcurenet.emass.message.service;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
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
@Document(indexName = "edc_*")
public class SolrEdcVO {

	@Id
	@Field(type = FieldType.Text)
	private String msgid;

	public String epmsg_type;

	public String cid;

	public String srcip;

	public int sport;

	public String dstip;

	public int dport;

	public String svc;

	public String svc1;

	public String svc2;

	public String svc3;

	public String svc12;

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

	public int ml_confd_class;
	public String ml_confd_class_label;

	public int ml_confd_feedback = -1;
	public String ml_confd_feedback_label;

	public float ml_confd_prob;

	public long size;

	public long body_size;

	public String usr_id;

	public String usrId;

	public String usr_ip;

	public String userkey;

	public String user;

	public String userid;

	public String name;

	public String subject;

	public String host;

	public String path;

	public String xmsgkey;

	public String sender;

	public String sname;

	public List<String> recvs;

	public List<String> recvs_name;

	public List<String> to;

	public List<String> cc;

	public List<String> bcc;

	public List<String> tname;

	public String cocd;

	public String conm;

	public String suborgcd;

	public String suborgnm;

	public String busicd;

	public String businm;

	public String deptcd;

	public String deptnm;

	public String jikgubcd;

	public String jikgubnm;

	public String ip_cocd;

	public String ip_conm;

	public String ip_busicd;

	public String ip_businm;

	public String ip_deptcd;

	public String ip_deptnm;

	public List<String> allofus;

	public String attached;

	public String direction;

	public String direction_svc;

	public String kwd;

	public List<String> kwds;

	public String inside;

	public String work;

	public List<String> attachname;

	public List<Long> attachsize;

	public List<String> attachhash;

	public List<String> attachtype;

	public int attachcnt;

	public String body_snippet;

	public int pi_total;
	public int pi_FN;
	public int pi_SN;
	public int pi_DN;
	public int pi_CN;
	public int pi_PN;
	public int pi_MN;
	public int pi_AN;
	public int pi_CRN;
	public int pi_SSN;
	public int pi_IMEI;
	public int pi_BRN;
	public int pi_CPN;
	public int pi_MCN;


	public String xrootmtr;

	public String protocol;

	public int ocr_attach_cnt;


//
//	public String referer_url;
//
//	
//	public String referer_url_name;
//
//	
//	public String referer_url_title;
//
//	
//	public String referer_url_desc;

	public String readYn;

	public String ctimeFormat;

	public String svcNm;

	public String svcLv1Nm;

	public String svcLv2Nm;

	public String sizeStr;

	public String bodySizeStr;

	public String attachSizeStr;

	public Long attachSizeSort;

	public String interestUserYn = "N";

	public String interestGroupColor;

	public String senderOrig;

	public String consentNo;

	public List<Map<String, Integer>> srcIpList;
	public String recvsInOutInfo;
	public String recvsStr;
	public String toInOutInfo;
	public String ccInOutInfo;
	public String bccInOutInfo;

	public String title;
	public String content;
	public String confidence;

	public List<Map<String, Object>> overlap;

	public List<Map<String, Object>> checked;

	public String user_str;

	public float score; // 연관도
	public int docCount;

	public int reprocess;

//	public List<Map<String, Integer>> pi_amount;
//	public Map<String, Integer> piMap;
//
//	public Map<String, String> regexpHighlight;

}
