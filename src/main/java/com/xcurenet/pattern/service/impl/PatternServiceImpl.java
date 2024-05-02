package com.xcurenet.pattern.service.impl;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.makeInfo.service.InfoVersionVO;
import com.xcurenet.common.makeInfo.service.impl.MakeInfoServiceMysql;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.MongoUtil;
import com.xcurenet.pattern.service.PatternService;
import com.xcurenet.pattern.service.PatternVO;
import com.xcurenet.regexPattern.service.RegexPatternVO;
import org.apache.cxf.wsdl11.SOAPBindingUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("patternService")
public class PatternServiceImpl extends XcnAbstractDAO implements PatternService {

	@Autowired
	public MakeInfoServiceMysql infoServiceMysql;

	@Override
	public List<PatternVO> getPatternService(String searchStr, int offset, int limit) {

		Map<String, Object> param = new HashMap();
		param.put("limit", limit);
		param.put("offset", offset);
		param.put("searchStr", searchStr);


		return selectList("com.xcurenet.sqlmap.mappers.mysql.regexPattern.getPatternList", param);

	}

	@Override
	public boolean isPatternCode(PatternVO patternVO) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.regexPattern.isPatternName", patternVO) > 0;
	}

	@Override
	public void insertPattern(PatternVO patternVO, String adminId) {
		patternVO.setCode(patternVO.getCode().toUpperCase());
		insert("com.xcurenet.sqlmap.mappers.mysql.regexPattern.insertPattern", patternVO);

		infoServiceMysql.addInfoRegExp();

		//MakeInfo
	}

	@Override
	public int deletePattern(List<PatternVO> patternVOS) {
		int result = 0;
		for (PatternVO patternVO : patternVOS) {
			delete("com.xcurenet.sqlmap.mappers.mysql.regexPattern.deletePattern", patternVO);
		}

		infoServiceMysql.addInfoRegExp();
		return result;

	}

	@Override
	public void updatePattern(PatternVO patternVO, String adminId) {
		patternVO.setCode(patternVO.getCode().toUpperCase());
		update("com.xcurenet.sqlmap.mappers.mysql.regexPattern.updatePattern", patternVO);
		infoServiceMysql.addInfoRegExp();
	}
}
