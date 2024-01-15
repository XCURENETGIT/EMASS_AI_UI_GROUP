package com.xcurenet.emass.analysis.service;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.message.service.SolrEdcVO;
import lombok.Data;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import java.io.Serializable;
import java.util.*;

public @Data class ProcessmapVO implements Serializable {

	private static final long serialVersionUID = 1L;

	private static final String DEPENDS = "depends";
	private static final String DEPENDED_ON_BY = "dependedOnBy";
	private static final String TYPE = "type";
	private static final String NAME = "name";
	private static final String TIME = "time";
	private static final String IP = "ip";
	private static final String SVC_NONAME = "unknown";

	private int linkSize;
	private boolean isOver;

	private String config;

	private String links;

	private final String USER = "User";

	public void setData(String unit, List<SolrEdcVO> modelList) {

		for (SolrEdcVO solrEdcVO : modelList) {
			solrEdcVO.setSvcLv1Nm(Common.isEmpty(solrEdcVO.getSvcLv1Nm()) ? SVC_NONAME : solrEdcVO.getSvcLv1Nm());
		}
		setLinks(setLink(modelList).toString());
		JSONObject json = getDefaultData();
		setConfig(setNode(json, modelList).toString());
	}

	private JSONObject getDefaultData() {

		JSONObject jsonLabelPadding = new JSONObject();
		jsonLabelPadding.put("left", 3);
		jsonLabelPadding.put("right", 3);
		jsonLabelPadding.put("top", 2);
		jsonLabelPadding.put("bottom", 2);
		JSONArray jsonArrayLabelPadding = new JSONArray();
		jsonArrayLabelPadding.add(jsonLabelPadding);

		JSONObject jsonLabelMargin = new JSONObject();
		jsonLabelMargin.put("left", 3);
		jsonLabelMargin.put("right", 3);
		jsonLabelMargin.put("top", 2);
		jsonLabelMargin.put("bottom", 2);
		JSONArray jsonArrayLabelMargin = new JSONArray();
		jsonArrayLabelMargin.add(jsonLabelMargin);

		int linkDistance = 1000;
		if (linkSize < 3) {
			linkDistance = 1000;
		} else if (linkSize > 2 && linkSize < 15) {
			linkDistance = 800;
		} else if (linkSize > 14 && linkSize < 20) {
			linkDistance = 500;
		} else {
			linkDistance = 300;
		}
		JSONObject jsonGraph = new JSONObject();
		jsonGraph.put("linkDistance", linkDistance);
		jsonGraph.put("charge", -400);
		jsonGraph.put("height", 500);
		jsonGraph.put("width", 1100);
		jsonGraph.put("numColors", 180);
		jsonGraph.put("labelPadding", jsonLabelPadding);
		jsonGraph.put("labelMargin", jsonLabelMargin);
		jsonGraph.put("ticksWithoutCollisions", 50);

		JSONObject json = new JSONObject();
		json.put("title", "");
		json.put("graph", jsonGraph);

		return json;
	}

	private JSONObject setNode(JSONObject json, List<SolrEdcVO> modelList) {

		List<String> typeList = new ArrayList<>();

		for (SolrEdcVO model : modelList) {
			String svcNm = SVC_NONAME;
			if (model.getSvc().startsWith("Q")) {
				svcNm = Config.getServiceLv2Nm(model.getSvc());
			} else {
				svcNm =  model.getSvc();
			}
			if (!typeList.contains(svcNm)) {
				typeList.add(svcNm);
			}
		}

		typeList = new ArrayList<>(new HashSet<String>(typeList));

		JSONObject jsonType = new JSONObject();

		JSONArray jsonConstraint = new JSONArray();
		int groupCount = typeList.size() > 0 ? linkSize / typeList.size() / 10 : 0;
		groupCount = groupCount > 4 ? 4 : groupCount;
		int x = 5, y = 1 + groupCount;

		for (String type : typeList) {
			jsonType.put(type, setType(type));
			jsonConstraint.add(setConstraint(type, TYPE, x, y, typeList.size()));
			x += 2;
			if (x > 10) {
				x = 2;
				y += 2;
			}
		}

		double strength = 0.35;
		for (String type : typeList) {
			jsonConstraint.add(setStrength(type, strength));
			strength += 0.35;
		}

		json.put("types", jsonType);
		json.put("constraints", jsonConstraint);

		return json;
	}

	private JSONObject setType(String type) {

		JSONObject jsonTypeDetail = new JSONObject();
		jsonTypeDetail.put("short", type);
		jsonTypeDetail.put("long", type);

		return jsonTypeDetail;
	}

	private JSONObject setConstraint(String name, String has, double x, double y, int typeCount) {

		JSONObject jsonHas = new JSONObject();
		jsonHas.put(has, name);
		JSONObject jsonTypeDetail = new JSONObject();
		jsonTypeDetail.put("has", jsonHas);
		jsonTypeDetail.put(TYPE, "position");
		jsonTypeDetail.put("x", x / 10);
		jsonTypeDetail.put("y", y / 10);

		double weight = typeCount / this.linkSize;
		weight = this.linkSize < 8 ? 0.7 : (typeCount == 1 && this.linkSize < 20 ? 0.5 : weight);
		jsonTypeDetail.put("weight", weight);

		return jsonTypeDetail;
	}

	private JSONObject setStrength(String type, double strength) {

		JSONObject jsonHas = new JSONObject();
		jsonHas.put(TYPE, type);
		JSONObject jsonTypeDetail = new JSONObject();
		jsonTypeDetail.put("has", jsonHas);
		jsonTypeDetail.put(TYPE, "linkStrength");
		jsonTypeDetail.put("strength", strength);

		return jsonTypeDetail;
	}

	private JSONObject setLink(List<SolrEdcVO> modelList) {

		JSONObject jsonLinks = new JSONObject();

		for (int i = 0; i < modelList.size(); i++) {
			SolrEdcVO model = modelList.get(i);

			if (model.getSvc().startsWith("M") || model.getSvc().startsWith("W") || model.getSvc().startsWith("EMM")) {

				addJsonLinks(jsonLinks, model.getSrcip(), model.getSvcLv1Nm(), nameMake(model.getSrcip()), model.getCtime(), null, null, model.getRecvs());
				if (model.getRecvs() != null) {
					for (String recvs : model.getRecvs()) {
						addJsonLinks(jsonLinks, recvs, model.getSvcLv1Nm(), recvs, model.getCtime(), model.getSenderOrig(), null, null);
					}
				}
			} else if (model.getSvc().startsWith("Q")) {
				String svc2Nm = Config.getServiceLv2Nm(model.getSvc());
				if (Common.isEmpty(svc2Nm)) {
					svc2Nm = SVC_NONAME;
				}
				addJsonLinks(jsonLinks, model.getSrcip(), svc2Nm, nameMake(model.getSrcip()), model.getCtime(), null, null, model.getRecvs());
				if (model.getRecvs() != null) {
					for (String recvs : model.getRecvs()) {
						addJsonLinks(jsonLinks, recvs, svc2Nm, recvs, model.getCtime(), model.getSenderOrig(), null, null);
					}
				}
			} else {
				addJsonLinks(jsonLinks, model.getSrcip(), model.getSvcLv1Nm(),nameMake(model.getSrcip()), model.getCtime(), null, model.getDstip(), null);
				addJsonLinks(jsonLinks, model.getDstip(), model.getSvcLv1Nm(), (!("").equals(Config.getUserId(model.getDstip())) ? nameMake(model.getDstip()) : model.getSvcNm()), model.getCtime(), model.getSrcip(), null, null);
			}
			// 100개까지 제한.
			if (jsonLinks.size() >= 100) {
				this.isOver = true;
				break;
			}
		}

		this.linkSize = jsonLinks.size();

		return setLinkDocs(jsonLinks);
	}

	private String nameMake(String ip) {
		String result = "";
		String id =  Config.getUserId(ip);
		if(!("").equals(id)) {
			String name = Config.getUserName(id);
			String jikgubnm = Config.getUserJikgubnm(id);
			String deptnm = Config.getUserDeptnm(id);
		    result = name.concat("/").concat(jikgubnm).concat("/").concat(deptnm).concat("<").concat(id).concat(">");
		}
		return result;
	}

	private JSONObject addJsonLinks(JSONObject jsonLinks, String key, String type, String name, String time, String depend, String dependOnByDstIp, List<String> dependOnByRecvs) {
		if (jsonLinks.has(key)) {
			addDepend(jsonLinks, key, DEPENDS, depend);
			addDepend(jsonLinks, key, DEPENDED_ON_BY, dependOnByDstIp);
		} else {
			jsonLinks.put(key, setData(type, name, time, depend, dependOnByDstIp,key));
		}

		if (dependOnByRecvs != null) {
			for (String value : dependOnByRecvs) {
				addDepend(jsonLinks, key, DEPENDED_ON_BY, value);
			}
		}
		return jsonLinks;
	}

	private JSONObject addDepend(JSONObject jsonLinks, String key, String type, String value) {

		JSONObject jsonValue = (JSONObject) jsonLinks.get(key);
		if (key.equals(value)) {
			jsonValue.put("mySelf", "Y"); // 자신에게 보낸 메일 체크
		} else {
			if (Common.isEmpty(jsonValue.get("mySelf"))) {
				jsonValue.put("mySelf", "N");
			}
			if (value != null) {
				JSONArray depends = (JSONArray) jsonValue.get(type);
				if (!depends.contains(value)) {
					depends.add(value);
				}
				jsonValue.put(type, depends);
			}
		}

		return jsonLinks;
	}

	public List<String> getKey(JSONObject jsonLinks, String key) {
		List<String> keyList = new ArrayList<String>();
		if (jsonLinks.containsKey(key)) {
			keyList.add(key);
		}
		return keyList;
	}

	public JSONObject setUserDepend(JSONObject json, Map<String, List<String>> dependedOnByMap) {

		@SuppressWarnings("unchecked")
		Iterator<String> it = json.keys();
		while (it.hasNext()) {
			String key = it.next();

			JSONObject dataJson = (JSONObject) json.get(key);
			if (dependedOnByMap.containsKey(dataJson.get(NAME))) {
				JSONArray dependedOnBy = (JSONArray) dataJson.get(DEPENDS);
				List<String> dependedOnByList = dependedOnByMap.get(dataJson.get(NAME));
				for (String string : dependedOnByList) {
					dependedOnBy.add(string);
				}
				dataJson.put(DEPENDS, dependedOnBy);
				json.put(key, dataJson);
			}
		}

		return json;
	}

	public JSONArray addDepend(String content, JSONArray strings) {
		if (Common.isEmpty(content) && !strings.contains(content)) {
			strings.add(content);
		}
		return strings;
	}

	public JSONObject setData(String type, String name, String time) {
		return setData(type, name, time, null, null,null);
	}

	private JSONObject setData(String type, String name, String time, String depend, String dependedOnBy,String ip) {
		JSONObject json = new JSONObject();

		json.put(TYPE, type);
		json.put(NAME, name);
		json.put(TIME, time);
		json.put(IP, ip);

		if (Common.isEquals(name, depend)) {
			json.put(DEPENDS, new ArrayList<String>());
		} else {
			if (Common.isEmpty(depend)) {
				json.put(DEPENDS, new ArrayList<String>());
			} else {
				JSONArray dependList = new JSONArray();
				dependList.add(depend);
				json.put(DEPENDS, dependList);
			}
		}

		if (Common.isEquals(name, dependedOnBy)) {
			json.put(DEPENDED_ON_BY, new ArrayList<String>());
		} else {
			if (Common.isEmpty(dependedOnBy)) {
				json.put(DEPENDED_ON_BY, new ArrayList<String>());
			} else {
				JSONArray dependedList = new JSONArray();
				dependedList.add(dependedOnBy);
				json.put(DEPENDED_ON_BY, dependedList);
			}
		}

		return json;
	}

	private JSONObject setLinkDocs(JSONObject json) {
		@SuppressWarnings("unchecked")
		Iterator<String> iter = json.keys();
		while (iter.hasNext()) {
			String key = iter.next();

			JSONObject dataJson = (JSONObject) json.get(key);
			String type = (String) dataJson.get(TYPE);
			String name = (String) dataJson.get(NAME);
			JSONArray depends = (JSONArray) dataJson.get(DEPENDS);
			JSONArray dependedOnBy = (JSONArray) dataJson.get(DEPENDED_ON_BY);

			StringBuilder sb = new StringBuilder();
			sb.append(getHtmlHeader(type, name)).append(getHtmlDepend(depends)).append(getHtmlDependedOnBy(dependedOnBy));
			dataJson.put("docs", "");

			json.put(key, dataJson);
		}

		return json;
	}

	private StringBuilder getHtmlHeader(String type, String name) {
		StringBuilder sb = new StringBuilder();
		sb.append("<h2>").append(name).append(" <em>").append(type).append("</em></h2> ");

		return sb;
	}

	private StringBuilder getHtmlDepend(JSONArray depends) {
		StringBuilder sb = new StringBuilder();

		if (depends == null || depends.isEmpty()) {
			sb.append("<h3>Before on by <em>(none)</em></h3>");
		} else {
			sb.append(" <h3>Before on</h3> <ul>");

			@SuppressWarnings("unchecked")
			Iterator<Object> iter = depends.iterator();
			while (iter.hasNext()) {
				Object depend = iter.next();
				sb.append(" <li><a href='#obj-").append((depend instanceof String ? ((String) depend).replaceAll(" ", "-") : depend)).append("' class='select-object' data-name='").append(depend).append("'>").append(depend).append("</a></li>");
			}
			sb.append(" </ul>");
		}

		return sb;
	}

	private StringBuilder getHtmlDependedOnBy(JSONArray dependedOnBy) {
		StringBuilder sb = new StringBuilder();
		if (dependedOnBy == null || dependedOnBy.isEmpty()) {
			sb.append("<h3>Next on by <em>(none)</em></h3>");
		} else {
			sb.append(" <h3>Next on by</h3> <ul>");

			@SuppressWarnings("unchecked")
			Iterator<Object> iter = dependedOnBy.iterator();
			while (iter.hasNext()) {
				Object depend = iter.next();
				sb.append(" <li><a href='#obj-").append((depend instanceof String ? ((String) depend).replaceAll(" ", "-") : depend)).append("' class='select-object' data-name='").append(depend).append("'>").append(depend).append("</a></li>");
			}
			sb.append(" </ul>");
		}

		return sb;
	}
}
