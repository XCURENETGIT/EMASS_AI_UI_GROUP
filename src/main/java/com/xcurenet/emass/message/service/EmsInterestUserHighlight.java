package com.xcurenet.emass.message.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.solr.client.solrj.SolrServerException;

import com.xcurenet.common.util.Common;
import com.xcurenet.interestUser.service.AdminUserGroupVO;

public class EmsInterestUserHighlight {

	private List<SolrEdcVO> emass;
	List<AdminUserGroupVO> interestUser;

	public EmsInterestUserHighlight(List<SolrEdcVO> emass, List<AdminUserGroupVO> interestUser) {
		this.emass = emass;
		this.interestUser = interestUser;
	}

	public List<SolrEdcVO> reDefined() throws SolrServerException, IOException {
		Map<String, String> userIds = new HashMap<>();
		for (int i = 0; i < interestUser.size(); i++) {
			AdminUserGroupVO interestSimpleUserVO = interestUser.get(i);
			if(Common.isNotEmpty(interestSimpleUserVO.getUserId())) userIds.put(interestSimpleUserVO.getUserId(), "Y");
		}
		for (int i = 0; i < emass.size(); i++) {
			SolrEdcVO solrEdcVO = emass.get(i);
			if (Common.isNotEmpty(solrEdcVO.getUserid()) && Common.isNotEmpty(userIds.get(solrEdcVO.getUserid()))) {
				solrEdcVO.setInterestUserYn("Y");
				emass.set(i, solrEdcVO);
				continue;
			}
		}
		return emass;
	}

}
