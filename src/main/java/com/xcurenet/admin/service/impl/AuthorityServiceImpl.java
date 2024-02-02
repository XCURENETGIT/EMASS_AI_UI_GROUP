package com.xcurenet.admin.service.impl;

import com.xcurenet.admin.service.AuthorityService;
import com.xcurenet.admin.service.AuthorityVO;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.elasticsearch.ElasticSearchCommon;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("authorityService")
public class AuthorityServiceImpl extends XcnAbstractDAO implements AuthorityService {

	@Override
	public List<AuthorityVO> getAdminAuthority(JSONObject param) {


//		param.put("userCoCd", ElasticSearchCommon.USER_COCD); // 회사코드
//		param.put("userIpCoCd",ElasticSearchCommon.USER_IPCOCD); // 회사코드 (SRC_IP)
//		param.put("userBusiCd",ElasticSearchCommon.USER_BUSICD); // 사업장코드
//		param.put("userIpBusiCd",ElasticSearchCommon.USER_IPBUSICD); // 사업장코드  (SRC_IP)
//
//		param.put("svc",ElasticSearchCommon.SERVICE_SVC); //
//		param.put("pi",ElasticSearchCommon.PI); //
//		param.put("userId",ElasticSearchCommon.USER_USE  RID);

		return selectList("com.xcurenet.sqlmap.mappers.mysql.admin.getAdminAuthority", param);
	}
}
