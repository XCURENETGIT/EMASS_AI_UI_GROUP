package com.xcurenet.regexPattern.service.Impl;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.message.service.SolrEdcVO;
import com.xcurenet.regexPattern.service.RegexPatternService;
import com.xcurenet.regexPattern.service.RegexPatternVO;
import org.apache.poi.ss.formula.functions.T;
import org.elasticsearch.index.query.QueryBuilders;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.IndexOperations;
import org.springframework.data.elasticsearch.core.SearchHit;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.core.mapping.IndexCoordinates;
import org.springframework.data.elasticsearch.core.query.NativeSearchQueryBuilder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("regexPatternService")
public class RegexPatternServiceImpl extends XcnAbstractDAO implements RegexPatternService {

	@Autowired
	@Qualifier("elasticsearchTemplate")
	private ElasticsearchOperations operation;


	@Override
	public int insertRegexPattern(RegexPatternVO regexPattern) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.regexPattern.insertRegexPattern", regexPattern);
	}

	@Override
	public List<RegexPatternVO> getRegexPatternList(String searchStr,int offset,int limit) {
		Map<String, Object> param = new HashMap();
		param.put("limit", limit);
		param.put("offset", offset);
		param.put("searchStr", searchStr);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.regexPattern.getRegexPatternList", param);
	}

	@Override
	public int deleteRegexPattern(List<RegexPatternVO> regexPatterns) {
		int result = 0;

		for (RegexPatternVO regexPatternVO : regexPatterns) {
			delete("com.xcurenet.sqlmap.mappers.mysql.regexPattern.deleteRegexPattern", regexPatternVO);
		}
		return result;
	}

	@Override
	public int updateRegexPattern(RegexPatternVO regexPattern) {
		return update("com.xcurenet.sqlmap.mappers.mysql.regexPattern.updateRegex", regexPattern);
	}

	@Override
	public boolean checkRegexp(RegexPatternVO regexPattern) {
		boolean result = true;
		try{
			org.springframework.data.elasticsearch.core.query.Query searchQuery = new NativeSearchQueryBuilder().withQuery(QueryBuilders.regexpQuery("regExp",regexPattern.getRegexPattern())).withSorts().build();
			IndexOperations indexoperations = operation.indexOps(IndexCoordinates.of("edc_w_*"));
			SearchHits solrEdcVO = operation.search(searchQuery, SolrEdcVO.class, indexoperations.getIndexCoordinates());
			List<SearchHit<T>> searchHits = solrEdcVO.getSearchHits();
			searchHits.size();
		}catch (Exception e){
			result = false;
		}
		return result;
	}

	@Override
	public boolean isRegexPatternName(RegexPatternVO regexPattern) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.regexPattern.isRegexPatternName", regexPattern) > 0;
	}

}
