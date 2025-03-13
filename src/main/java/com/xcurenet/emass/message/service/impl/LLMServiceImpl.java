package com.xcurenet.emass.message.service.impl;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.message.service.HostDescriptionVO;
import com.xcurenet.emass.message.service.LLMService;
import com.xcurenet.emass.message.service.LlmVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONObject;
import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Log4j2
@Service("llmService")
@RequiredArgsConstructor
public class LLMServiceImpl extends XcnAbstractDAO implements LLMService {

	private final Config conf;


	@Override
	public HostDescriptionVO getHostDescription(String host) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.getHostDescription", host);
	}

	@Override
	public JSONObject getLLMAnalysis(String chat, String type) throws IOException {
		JSONObject param = new JSONObject();

		LlmVO llmVO = selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.getLlm", type);

		if (Common.isEmpty(llmVO)) return null;

		param.put("model", llmVO.getLlmModel());
		param.put("prompt", chat+llmVO.getLlmPromt());
		param.put("stream", false);

		Document doc = Jsoup.connect(conf.getLlmUrl()).timeout(conf.getLlmTimeout()).header("Content-Type", "application/json;charset=UTF-8").method(Connection.Method.POST).requestBody(param.toString()).ignoreContentType(true).post();
		log.debug("llm response : {}", doc.body().text());
		return Common.toJSONObject(doc.body().text());
	}


}
