package com.xcurenet.emass.message.vo.emass;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.xcurenet.emass.message.vo.emass.fields.Attach;
import com.xcurenet.emass.message.vo.emass.fields.MailProperties;
import com.xcurenet.emass.message.vo.emass.fields.PiProperties;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class EmassResponse {

    private String allofus;
    private String allofusStr;
    private String attachSizeStr;
    private List<Attach> attach;
    private int attachcnt;
    private int attachexistcnt;

    /* body */
    private long body_size;
    private String body_sizeStr;
    private String body_snippet;
    private String body_text;

    private String ctime;
    private String direction;
    private String direction_svc;
    private String filePath;

    /* html */
    private String html_path;

    /* http */
    private String http_path;
    private String http_query;
    private String http_host;

    /* kwd_info */
    private boolean kwd;
    private String kwd_attach;
    private String kwd_attachname;
    private String kwd_kwds;
    private String kwd_body;
    private String kwd_subject;

    private String ltime;

    private String mail_sender_alias;
    private String mail_sender_id;
    private String mail_sender_name;
    private String mail_sender_email;
    private String mail_sender_mail;
    private String mail_sender_key;

    private List<MailProperties> mail_to;
    private List<MailProperties> mail_cc;
    private List<MailProperties> mail_bcc;

    /* ml */
    private int ml_confd_class;
    private String ml_confd_class_Str;
    private int ml_confd_feedback;
    private String ml_confd_feedback_Str;
    private float ml_confd_prob;

    private String msgid;

    /* network */
    private int network_dport;
    private String network_protocol;
    private String network_srcip;
    private String network_dstip;
    private int network_sport;
    private String network_cid;

    private String opinion;
    private String opinoion;
    private String password;

    /* pi */
    private List<PiProperties> pi_codes;
    private int pi_total;


    private String service_svc;
    private String service_svc1;
    private String service_svc2;
    private String service_svc3;
    private String service_svc12;

    private String service_svcNm;
    private String service_svcLv1Nm;
    private String service_svcLv2Nm;


    private long size;
    private String sizeStr;
    private String subject;

    /* user_*/
    private String user_busicd;
    private String user_businm;
    private String user_ceo;
    private String user_cocd;
    private String user_conm;
    private String user_deptcd;
    private String user_deptnm;
    private String user_email;
    private String user_id;
    private String user_ip;
    private String user_ip_busicd;
    private String user_ip_businm;
    private String user_ip_cocd;
    private String user_ip_conm;
    private String user_jikgubcd;
    private String user_jikgubnm;
    private String user_key;
    private String user_name;
    private String user_suborgcd;
    private String user_suborgnm;
    private Long user_week;
    private String user_work;

    private String xmsgkey;
    private String xparentmtr;
    private String xrootmtr;

    public String interestUserYn = "N";
    public String interestGroupColor;
    public String consentNo;
    public String readYn;

}
