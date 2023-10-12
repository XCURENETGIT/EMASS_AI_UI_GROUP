package com.xcurenet.emass.analysis.web;

import com.google.gson.Gson;
import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.analysis.service.*;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.solr.client.solrj.SolrServerException;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Locale;

@Controller
@RequestMapping("/analysis")
@Description("데이터 관계 분석")
@AuditParentMenu(ParentMenu.DATA_ANALYSIS)
@AuditMenu(Menu.ANALYSIS_RELATION)
public class AnalysisRelationController {

	@Autowired public AnalysisRelationService analysisRelationService;

	@RequestMapping("/dataRelation.do")
	@Description("분석 - 데이터관계분석 Main")
	public String dataRelation(Locale locale, Model model) {
		model.addAttribute("headerCloseYn","Y");
		return "/analysis/dataRelation";
	}

	@RequestMapping("/dataRelationList.xcn")
	@AuditOperation(Operation.SEARCH)
	@Description("분석 - 데이터관계분석  조건 조회")
	@ResponseBody
	public XcnResponseVO dataRelationList(SearchVO searchVO, HttpSession session) throws IOException, SolrServerException {
		searchVO.setAdminId(Common.getAdminId(session));
		AnalysisRelationListVO vo = analysisRelationService.dataRelationList(searchVO);
		return new XcnResponseVO(XcnRspCode.OK,vo.getBuckets(), vo.getTotalCount());
	}

	@RequestMapping("/dataDetailList.xcn")
	@AuditOperation(Operation.SEARCH)
	@Description("분석 - 데이터관계분석  조건 상세 조회 (timeline, processmap, sankeychart setting")
	@ResponseBody
	public XcnResponseVO dataDetailList(SearchVO searchVO, HttpSession session) throws IOException, SolrServerException {

		searchVO.setAdminId(Common.getAdminId(session));
		List<SolrEdcVO> edcVO = analysisRelationService.dataDetailList(searchVO);
		JSONObject json = new JSONObject();
		json.put("timeline", setTimeline(searchVO.getUnit(), edcVO));
		json.put("processmap", setProcessMap(searchVO.getUnit(), edcVO));
//		json.put("sankey", userBihiSankey(edcVO));
		return new XcnResponseVO(XcnRspCode.OK, json);
	}
	
	@RequestMapping("/dataSelectList.xcn")
	@AuditOperation(Operation.SEARCH)
	@Description("분석 - 데이터관계분석  관계도에서 객체 선택시 해당 객체에 대한 목록 조회")
	@ResponseBody
	public XcnResponseVO dataSelectList(SearchVO searchVO, HttpSession session) throws IOException, SolrServerException {
		searchVO.setAdminId(Common.getAdminId(session));

		String[] name = searchVO.getName().split("<");
		if(name.length > 1) {
			searchVO.setName(name[1].replaceAll(">", ""));
		}
		SolrEdcMessageVO solrVo = analysisRelationService.dataSelectList(searchVO);
		return new XcnResponseVO(XcnRspCode.OK, solrVo, solrVo.getNumFound());
	}

	private JSONArray setTimeline(String unit, List<SolrEdcVO> edcVOList) {
		JSONArray array = new JSONArray();

		int i = 0;
		for (SolrEdcVO edcVO : edcVOList) {
			JSONObject json = new JSONObject();
			json.put("id", i++);
			StringBuilder contents = new StringBuilder();
			contents.append("<a href=\"javascript:openMessageBody('msgBody','").append(edcVO.getMsgid()).append("', '');\">");

			switch(edcVO.getSvc().substring(0, 1)) {
			case "M" :
			case "W" :
				contents.append(getGlyphicon("M")).append(edcVO.getSender());
				if(edcVO.getSname() != null) {
					contents.append("(").append(edcVO.getSname()).append(")");
				}
				contents.append("<div>").append(edcVO.getSubject()).append("</div>");
				break;
			case "C" :
			case "S" :
			case "V" :
			case "Q" :
			case "F" :
			case "Z" :
			case "U" :
				if(edcVO.getHost() != null && !edcVO.getHost().equals("")) {
					contents.append(getGlyphicon("W"));
					contents.append(edcVO.getHost()).append(edcVO.getPath());
				} else if(edcVO.getSubject() != null && !edcVO.getSubject().equals("")) {
					contents.append(getGlyphicon("W"));
					contents.append(edcVO.getSubject());
				}
				break;
			case "E" :
				if(edcVO.getSvc().substring(0, 3).contains("EMM")) {
					contents.append(getGlyphicon("M")).append(edcVO.getSender());
					if(edcVO.getSname() != null) {
						contents.append("(").append(edcVO.getSname()).append(")");
					}
					contents.append("<div>").append(edcVO.getSubject()).append("</div>");
				} else {
					if(edcVO.getHost() != null && !edcVO.getHost().equals("")) {
						contents.append(getGlyphicon("W"));
						contents.append(edcVO.getHost()).append(edcVO.getPath());
					} else if(edcVO.getSubject() != null && !edcVO.getSubject().equals("")) {
						contents.append(getGlyphicon("W"));
						contents.append(edcVO.getSubject());
					}
				}
				break;
			}

			contents.append("</a>");

			json.put("msgid", edcVO.getMsgid());
			json.put("content", contents.toString());
			json.put("start", getTimeFormat(edcVO.getCtime(), "yyyyMMddHHmmss", "yyyy-MM-dd HH:mm:ss"));

			array.add(json);
			if(i > 100) break;
		}

		return array;
	}

	private String getTimeFormat(String time, String beforeFormat, String afterFormat) {
		DateTimeFormatter afterFormatter = DateTimeFormat.forPattern(afterFormat);
		return afterFormatter.print(DateTime.parse(time, DateTimeFormat.forPattern(beforeFormat)));
	}

	private String getGlyphicon(String key) {
		String icon = "";

		switch(key) {
			case "W" :
				icon = "<span class='glyphicon glyphicon-home'></span> ";
				break;
			case "M" :
				icon = "<span class='glyphicon glyphicon-envelope'></span> ";
				break;
		}
		return icon;
	}

	private String setProcessMap(String unit, List<SolrEdcVO> edcVOList) {
		ProcessmapVO processmapVO = new ProcessmapVO();
		processmapVO.setData(unit, edcVOList);

		Gson gson = new Gson();
		return gson.toJson(processmapVO);
	}

	protected String userBihiSankey(List<SolrEdcVO> modelList) {
		BihiSankeyVO sankeyModel = new BihiSankeyVO();
		sankeyModel.setData(modelList);
		Gson gson = new Gson();
		return gson.toJson(sankeyModel);
	}
}

