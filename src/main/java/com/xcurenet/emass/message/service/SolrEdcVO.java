//package com.xcurenet.emass.message.service;
//
//import java.util.List;
//import java.util.Map;
//
//
//import com.fasterxml.jackson.annotation.JsonInclude;
//import com.fasterxml.jackson.annotation.JsonInclude.Include;
//
//import lombok.Data;
//import net.sf.json.JSONArray;
//
//@JsonInclude(Include.NON_NULL)
//@Data
//public class SolrEdcVO {
//	@Field
//	public String msgid;
//	@Field
//	public String epmsg_type;
//	@Field
//	public String cid;
//	@Field
//	public String srcip;
//	@Field
//	public int sport;
//	@Field
//	public String dstip;
//	@Field
//	public int dport;
//	@Field
//	public String svc;
//	@Field
//	public String svc1;
//	@Field
//	public String svc2;
//	@Field
//	public String svc3;
//	@Field
//	public String ltime;
//	@Field
//	public String ctime;
//	@Field
//	public String ctime_yyyy;
//	@Field
//	public String ctime_yyyymm;
//	@Field
//	public String ctime_yyyymmdd;
//	@Field
//	public String ctime_hh;
//	@Field
//	public String date_hh;
//	@Field
//	public String date_yyyy;
//	@Field
//	public String date_yyyymm;
//	@Field
//	public String date_yyyymmdd;
//	@Field
//	public int ml_confd_class;
//	public String ml_confd_class_label;
//	@Field
//	public int ml_confd_feedback = -1;
//	public String ml_confd_feedback_label;
//	@Field
//	public float ml_confd_prob;
//	@Field
//	public long size;
//	@Field
//	public long body_size;
//	@Field
//	public String usr_id;
//	@Field
//	public String usr_ip;
//	@Field
//	public String user;
//	@Field
//	public String userid;
//	@Field
//	public String name;
//	@Field
//	public String subject;
//	@Field
//	public String host;
//	@Field
//	public String path;
//	@Field
//	public String xmsgkey;
//	@Field
//	public String sender;
//	@Field
//	public String sname;
//	@Field
//	public List<String> recvs;
//	@Field
//	public List<String> recvs_name;
//	@Field
//	public List<String> to;
//	@Field
//	public List<String> cc;
//	@Field
//	public List<String> bcc;
//	@Field
//	public List<String> tname;
//	@Field
//	public String cocd;
//	@Field
//	public String conm;
//	@Field
//	public String suborgcd;
//	@Field
//	public String suborgnm;
//	@Field
//	public String busicd;
//	@Field
//	public String businm;
//	@Field
//	public String deptcd;
//	@Field
//	public String deptnm;
//	@Field
//	public String jikgubcd;
//	@Field
//	public String jikgubnm;
//	@Field
//	public String ip_cocd;
//	@Field
//	public String ip_conm;
//	@Field
//	public String ip_busicd;
//	@Field
//	public String ip_businm;
//	@Field
//	public String ip_deptcd;
//	@Field
//	public String ip_deptnm;
//	@Field
//	public List<String> allofus;
//	@Field
//	public String attached;
//	@Field
//	public String direction;
//	@Field
//	public String direction_svc;
//	@Field
//	public String kwd;
//	@Field
//	public List<String> kwds;
//	@Field
//	public String inside;
//	@Field
//	public String work;
//	@Field
//	public List<String> attachname;
//	@Field
//	public List<Long> attachsize;
//	@Field
//	public List<String> attachhash;
//	@Field
//	public List<String> attachtype;
//	@Field
//	public int attachcnt;
//	@Field
//	public String body_snippet;
//	@Field
//	public int pi_total;
//
//	@Field
//	public String xrootmtr;
//	@Field
//	public String protocol;
////	@Field
////	public String referer_url;
////
////	@Field
////	public String referer_url_name;
////
////	@Field
////	public String referer_url_title;
////
////	@Field
////	public String referer_url_desc;
//
//	public String readYn;
//
//	public String ctimeFormat;
//
//	public String svcNm;
//
//	public String svcLv1Nm;
//
//	public String svcLv2Nm;
//
//	public String sizeStr;
//
//	public String bodySizeStr;
//
//	public String attachSizeStr;
//
//	public Long attachSizeSort;
//
//	public String interestUserYn = "N";
//
//	public String interestGroupColor;
//
//	public String senderOrig;
//
//	public String consentNo;
//
//	public List<Map<String, Integer>> srcIpList;
//
//	@Field
//	public int ocr_attach_cnt;
//
//	public String recvsInOutInfo;
//	public String recvsStr;
//	public String toInOutInfo;
//	public String ccInOutInfo;
//	public String bccInOutInfo;
//
//	public String title;
//	public String content;
//	public String confidence;
//
//	public List<Map<String,Object>> overlap;
//}
