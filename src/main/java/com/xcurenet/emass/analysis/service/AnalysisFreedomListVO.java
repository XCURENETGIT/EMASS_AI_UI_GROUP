package com.xcurenet.emass.analysis.service;

import java.io.IOException;
import java.util.List;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnFacetsVO;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;

import lombok.Data;

public @Data class AnalysisFreedomListVO extends XcnFacetsVO {

	private List<Buckets> buckets;
	private long totalCount;



	public AnalysisFreedomListVO(SolrEdcMessageVO edc) throws JsonParseException, JsonMappingException, IOException {
		this(edc, 1);
	}

	public AnalysisFreedomListVO(SolrEdcMessageVO edc, int columnCount) throws JsonParseException, JsonMappingException, IOException {
		super(edc, columnCount);

		if(!Common.isEmpty(edc.getFacetData())) {
			buckets = getList(new AnalysisFreedomListVO.Buckets());
			totalCount = buckets.size();
		}
	}

	public static @Data class Buckets extends XcnFacetsVO.Buckets {
		private long sum;
		private long avg;
		private long max;
		private long min;
		private List<AnalysisFreedomListVO.Buckets> buckets;
	}
}
