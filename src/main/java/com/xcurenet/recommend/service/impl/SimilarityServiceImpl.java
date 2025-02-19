package com.xcurenet.recommend.service.impl;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.recommend.service.SimilarityService;
import net.sf.json.JSONObject;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Service("similarityService")
public class SimilarityServiceImpl extends XcnAbstractDAO implements SimilarityService {

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	public static String recommendFields = "msgid,reprocess," +
			"date_yyyy,date_yyyymm,date_yyyymmdd," +
			"ml_confd_class,ml_confd_feedback,ml_confd_prob," +
			"cid,srcip,sport,dstip,dport,svc1,svc2,svc3," +
			"ltime,ctime,ctime_yyyy,ctime_yyyymm,ctime_yyyymmdd,ctime_hh," +
			"size,body_size,usrId,usr_ip,userkey,user,userid,name,subject,host,path,xmsgkey,sender,sname,recvs,recvs_name,to,cc,bcc,tname,cocd,conm,suborgcd,suborgnm,busicd,businm,deptcd,deptnm,jikgubcd,jikgubnm," +
			"ip_cocd,ip_conm,ip_busicd,ip_businm,ip_deptcd,ip_deptnm," +
			"allofus,attach,attached,attachname_str,direction,direction_svc,kwd,kwds,inside,work,attachname,attachname_str,attachsize,attachhash,attachtype,attachcnt,pi_total,read_time,xrootmtr,protocol,epmsg_type,user_str," +
			"pi_amount.*,_score,body" +
			"svc12,checked,kwds_subject,sabun,attachexistcnt,svc:0.1";

	@Override
	public SolrEdcMessageVO getSimilarity(HttpServletRequest request) throws SolrServerException, IOException {
		JSONObject param = Common.getParam(request);

		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		String similarityText = Common.nvl(param.get("similarityText"));
		String tab = Common.nvl(param.get("tab"));
		String minTermFreq = Common.nvl(param.get("minTermFreq"));
		String minDocFreq = Common.nvl(param.get("minDocFreq"));
		String maxDocFreq = Common.nvl(param.get("maxDocFreq"));
		String adminId = Common.getAdminId(request);

		String[] text = similarityText.split(",");
		String query = String.format("+ctime:[%s TO %s] ", startDate, endDate);

		SolrQuery sq = new SolrQuery();

		if (Common.isEmpty(tab) || Common.isEquals(tab, "allTab")){
			sq.addMoreLikeThisField("subject").addMoreLikeThisField("body").addMoreLikeThisField("attach");
			query += String.format("+body_size:[%s TO *] ", 1);
		}
		else if (Common.isEquals(tab, "subjectTab")) sq.addMoreLikeThisField("subject");
		else if (Common.isEquals(tab, "bodyTab")){
			sq.addMoreLikeThisField("body");
			query += String.format("+body_size:[%s TO *] ", 1);
		}
		else if (Common.isEquals(tab, "fileTab")) sq.addMoreLikeThisField("attach");




		sq.setStart(0);
		sq.setRows(300);
		sq.setMoreLikeThis(true);

		sq.setQuery(query);
		sq.setParam("indics", "edc_w_*");
		sq.setSort("_score", SolrQuery.ORDER.desc);
		sq.setParam("text", text);
		sq.setParam("minTermFreq", minTermFreq);
		sq.setParam("minDocFreq", minDocFreq);
		sq.setParam("maxDocFreq", maxDocFreq);

		sq.setParam("qf",recommendFields);

		return solrEdcService.getEmassMessage(sq, adminId);

	}
}
