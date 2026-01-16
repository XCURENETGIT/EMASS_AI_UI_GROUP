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


		return solrEdcService.getEmassMessage(sq, adminId);

	}
}
