package com.xcurenet.emass.message.service;


import com.xcurenet.emass.message.service.vo.HostCategoryVO;
import com.xcurenet.emass.message.service.vo.HostDescriptionVO;
import com.xcurenet.emass.message.service.vo.HostVO;
import com.xcurenet.emass.message.service.vo.NationVO;
import net.sf.json.JSONObject;

import java.io.IOException;
import java.util.List;

public interface LLMService {

	HostDescriptionVO getHostDescription(String host);

	List<NationVO> getNationList();

	List<HostCategoryVO> getHostCategoryList();

	HostVO getLLMUrlAnalysis(final String host) throws IOException;

	JSONObject getLLMAnalysis(final String chat, final String type) throws IOException;

	int insertHostCategory(final HostVO hostVO);

	JSONObject getValueLLMAnalysis(final JSONObject requestParam,final String type) throws IOException;
}

