package com.xcurenet.emass.analysis.service;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnFacetsVO;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import lombok.Data;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public @Data class AnalysisRelationListVO extends XcnFacetsVO {

	private List<Buckets> buckets;
	private long totalCount;

	public AnalysisRelationListVO(SolrEdcMessageVO edc) throws JsonParseException, JsonMappingException, IOException {
		this(edc, 1);
	}

	public AnalysisRelationListVO(SolrEdcMessageVO edc, int columnCount) throws JsonParseException, JsonMappingException, IOException {
		super(edc, columnCount);
		totalCount = 0;

		if(!Common.isEmpty(edc.getPivotData())){
			List<Map<String, Object>>  resultList  = edc.getPivotData();
			buckets = getList(new AnalysisRelationListVO.Buckets());

		}


	}

	public static @Data class Buckets extends XcnFacetsVO.Buckets {
		private long size;
	}
}
