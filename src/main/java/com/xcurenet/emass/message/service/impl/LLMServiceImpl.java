package com.xcurenet.emass.message.service.impl;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.message.service.LLMService;
import com.xcurenet.emass.message.service.LlmVO;
import com.xcurenet.emass.message.service.vo.HostCategoryVO;
import com.xcurenet.emass.message.service.vo.HostDescriptionVO;
import com.xcurenet.emass.message.service.vo.HostVO;
import com.xcurenet.emass.message.service.vo.NationVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONObject;
import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Log4j2
@Service("llmService")
@RequiredArgsConstructor
public class LLMServiceImpl extends XcnAbstractDAO implements LLMService {

	private final Config conf;

	private static final Map<String, String> nationCds = new HashMap<>();
	private static final Map<String, String> nationNms = new HashMap<>();
	private static final Map<String, String> llmURLCategoryInfos = new HashMap<>();
	private static final List<String> llmURLCategorys = new ArrayList<>();

	private void init() {
		if (nationCds.isEmpty()) {
			List<NationVO> nations = getNationList();
			for (NationVO nation : nations) {
				nationCds.put(nation.getNationCd(), null);
				nationNms.put(nation.getNationKor(), nation.getNationCd());
			}
		}

		if (llmURLCategorys.isEmpty()) {
			List<HostCategoryVO> hostCategoryList = getHostCategoryList();
			for (HostCategoryVO hostCategory : hostCategoryList) {
				llmURLCategoryInfos.put(hostCategory.getCategoryNm(), hostCategory.getCategoryCd());
				llmURLCategorys.add(hostCategory.getCategoryNm());
			}
			log.info("LLM URL Categorys : {}", llmURLCategorys.size());
		}
	}

	@Override
	public HostDescriptionVO getHostDescription(String host) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.getHostDescription", host);
	}

	@Override
	public List<HostCategoryVO> getHostCategoryList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.emass.getHostCategoryList");
	}

	@Override
	public List<NationVO> getNationList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.emass.getNationList");
	}

	@Override
	public HostVO getLLMUrlAnalysis(String host) throws IOException {
		init();

		HostVO hostVO = new HostVO();
		hostVO.setHost(host);

		JSONObject param = new JSONObject();
		param.put("model", conf.getLlmModel());
		param.put("prompt", String.format(conf.getLlmQuestion(), host, llmURLCategorys));
		param.put("stream", false);

		Document doc = Jsoup.connect(conf.getLlmUrl()).timeout(conf.getLlmTimeout()).header("Content-Type", "application/json;charset=UTF-8").method(Connection.Method.POST).requestBody(param.toString()).ignoreContentType(true).post();
		parseResponse(Common.nvl(Common.toJSONObject(doc.body().text()).get("response")), hostVO);
		insertHostCategory(hostVO);
		return hostVO;
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

	@Override
	public int insertHostCategory(HostVO hostVO) {
		return update("com.xcurenet.sqlmap.mappers.mysql.emass.insertHostCategory", hostVO);
	}



	private void parseResponse(final String response, HostVO host) {
		log.debug("response:{}", response);
		List<String> answers = Common.toList(response, "\n");
		for (String answer : answers) {
			if (host.getCategoryCd() == null && Common.trimAll(answer).contains("카테고리")) {
				host.setCategoryCd(getCategoryText(getAnswerText(answer)));
			} else if (host.getNationCd() == null && Common.trimAll(answer).contains("사이트국가코드")) {
				host.setNationCd(getNationText(getAnswerText(answer)));
				if (host.getNationCd() == null) host.setNationCd(getNationCdByNam(answer));
			} else if (host.getDesc() == null && Common.trimAll(answer).contains("사이트설명")) {
				host.setDesc(getAnswerText(answer));
			}
		}
		if (host.getNationCd() == null) host.setNationCd(getNationCdByNam(host.getDesc()));
		if (host.getNationCd() == null) host.setNationCd("XX");
		log.info("HostVO : {}", host);
	}

	private String getAnswerText(String answer) {
		return answer.split(":")[1].trim().replaceAll("\n", "").replaceAll("\\*", "").replaceAll("#", "");
	}

	private String getNationText(String answer) {
		String pattern = "[A-Za-z]+";
		Pattern compiledPattern = Pattern.compile(pattern);
		Matcher matcher = compiledPattern.matcher(answer);
		if (matcher.find()) {
			String nation = matcher.group().trim().toUpperCase();
			log.debug("matcher.group().trim() : {}", nation);
			if (nationCds.containsKey(nation)) return nation;
		}
		return null;
	}

	private String getCategoryText(String answer) {
		log.debug("getCategoryText answer : {}", answer);
		String category = llmURLCategoryInfos.get(answer);
		if (category == null) return "99";
		else return category;
	}

	private String getNationCdByNam(String desc) {
		if (desc == null) return null;
		for (String key : nationNms.keySet()) {
			if (desc.contains(key)) return nationNms.get(key);
		}
		return null;
	}



	@Override
	public JSONObject getValueLLMAnalysis(JSONObject requestParam,String type) throws IOException {
		LlmVO llmVO = selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.getLlm", type);
		if (Common.isEmpty(llmVO)) return null;

		JSONObject param = new JSONObject();
		String prompt = llmVO.getLlmPromt();

		String path_prompt = Common.nvl(requestParam.get("path_prompt"));
		String key_prompt = Common.nvl(requestParam.get("key_prompt"));
		String value_prompt = Common.nvl(requestParam.get("value_prompt"));
		String trans_type = Common.nvl(requestParam.get("trans_type"));

		prompt = prompt.replace("{{path_prompt}}", path_prompt)
				.replace("{{trans_type}}", trans_type)
				.replace("{{key_prompt}}", key_prompt)
				.replace("{{value_prompt}}", value_prompt);

		param.put("model", Common.nvl(llmVO.getLlmModel()));
		param.put("prompt", prompt);
		param.put("stream", false);
		Document doc = Jsoup.connect(conf.getLlmUrl()).timeout(conf.getLlmTimeout()).header("Content-Type", "application/json;charset=UTF-8").method(Connection.Method.POST).requestBody(param.toString()).ignoreContentType(true).post();
		return Common.toJSONObject(doc.body().text());
	}


}
