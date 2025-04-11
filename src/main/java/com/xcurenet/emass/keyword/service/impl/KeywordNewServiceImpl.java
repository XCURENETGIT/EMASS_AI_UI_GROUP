package com.xcurenet.emass.keyword.service.impl;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.MongoUtil;
import com.xcurenet.emass.keyword.service.KeywordNewService;
import com.xcurenet.emass.keyword.service.KeywordsNewVO;
import com.xcurenet.emass.keyword.service.keywordsNew;
import com.xcurenet.user.service.UserService;
import edu.emory.mathcs.backport.java.util.Arrays;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationOperation;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

@Service("keywordNewService")
public class KeywordNewServiceImpl extends XcnAbstractDAO implements KeywordNewService {

	@Autowired
	private MongoUtil mongo;

	@Resource(name = "userService")
	private UserService userService;

	@Autowired
	private KeywordServiceImpl keywordService;

	@Override
	public keywordsNew getKeywordNew(HttpServletRequest request) {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		long offset = Common.nvz(request.getParameter("offset"),0);
		long limit = Common.nvz(request.getParameter("limit"),100);
		List<String> keywordList = Arrays.asList(coreKeyword.split(","));

		if (Common.isEmpty(coreKeyword)) keywordList = keywordService.getCoreKeywordAll();

		String admin =  Common.getAdminId(request);
		List<AdminVO> admins = userService.getBusiAdmin(admin);
		List<String> busicdList = new ArrayList<>();
		for (AdminVO adminVO : admins) {
			busicdList.add(adminVO.getBusiCd());
		}

		Criteria criteria = new Criteria();


		// Handle busicdList
		if (!busicdList.isEmpty()) {
			criteria.and("BUSICD").in(busicdList);
		}

		// Handle keywordList
		criteria.and("KEYWORD").in(keywordList);

		// Handle date range (CTIME)
		if (startDate != null && endDate != null) {
			try {
				String startDtFormatted = startDate.substring(0, 4) + "-" + startDate.substring(4, 6) + "-" + startDate.substring(6) + "T00:00:00.000Z";
				String endDtFormatted = endDate.substring(0, 4) + "-" + endDate.substring(4, 6) + "-" + endDate.substring(6) + "T23:59:59.999Z";

				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
				dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
				Date startDt = dateFormat.parse(startDtFormatted);
				Date endDt = dateFormat.parse(endDtFormatted);

				criteria.and("CTIME").gte(startDt).lte(endDt);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}

		// 2. Create Aggregation stages
		AggregationOperation limitStage = Aggregation.limit(limit);
		AggregationOperation offsetStage = Aggregation.skip(offset);

		Aggregation aggregation = Aggregation.newAggregation(
				Aggregation.match(criteria),  // Match stage with filters
				Aggregation.group("MSGID")
						.first("CTIME").as("ctime")
						.first("HOST").as("host")
						.first("URL").as("url")
						.first("DEPTNM").as("deptnm")
						.first("DEPTCD").as("deptcd")
						.first("BUSICD").as("busicd")
						.first("USER").as("user")
						.first("USERID").as("userId")
						.first("NAME").as("name")
						.first("BUSINM").as("busiNm")
						.first("IPBUSICD").as("IpBusiCd")
						.first("IPBUSINM").as("IpBusiNm")
						.first("SENTENCE").as("sentence")
						.first("MSGID").as("msgId")
						.first("DETECTED").as("detected")
						.addToSet("KEYWORD").as("keywords"),
				offsetStage,
				limitStage,
				Aggregation.sort(Sort.by(Sort.Order.desc("_id")))  // Sort by _id in ascending order
		);

		keywordsNew keywordsNew = new keywordsNew();
		List<KeywordsNewVO> keywordVoList = mongo.selectList(aggregation, KeywordsNewVO.class, "EMS_DETECT_CORE" );
		keywordsNew.setKeywordsNewList(keywordVoList);
		keywordsNew.setTotalCount((long) Common.nvz(mongo.count(new Query(criteria),"EMS_DETECT_CORE")));

		return keywordsNew;
	}
}
