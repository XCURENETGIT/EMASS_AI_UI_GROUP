package com.xcurenet.emass.keyword.log;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.keyword.service.KeywordService;
import com.xcurenet.emass.keyword.service.KeywordVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class KeywordControllerLog {

	@Autowired
	private AuditService auditService;
	
	@Resource(name = "keywordService")
	public KeywordService keywordService;

	public void getKeywordList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String searchGroupName = Common.nvl(param.get("searchGroupName"));
		String information = "";
		
		information += "[" + Prop.propFormat("keyword.msg.keyword") + " " + Prop.propFormat("common.msg.search") + "]";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		if(Common.isNotEmpty(searchGroupName)) information += "┌"+Prop.propFormat("java.log.searchgroup.name")+": " + searchGroupName;

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}	
	
	public void insertKeyword(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String keywordGroupName = Common.nvl(param.get("groupName"));
		String keywordName = Common.nvl(param.get("keywordName"));
		String keywordDesc = Common.nvl(param.get("keywordDesc"));
		String information = "";
		
		KeywordVO keyword = new KeywordVO();
		keyword.setKeywordName(keywordName);
		if (!keywordService.isKeywordNameExist(keyword)) {
			information += "["+Prop.propFormat("common.msg.add")+"]";
			if(Common.isNotEmpty(keywordGroupName))information += "┌"+Prop.propFormat("keyword.msg.part_name")+": " + keywordGroupName;
			if(Common.isNotEmpty(keywordName))information += "┌"+Prop.propFormat("keyword.msg.keyword")+": " + keywordName;
			if(Common.isNotEmpty(keywordDesc))information += "┌"+Prop.propFormat("keyword.msg.comment")+": " + keywordDesc;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
	
	public void updateKeyword(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String keywordGroupName = Common.nvl(param.get("groupName"));
		String keywordName = Common.nvl(param.get("keywordName"));
		String keywordDesc = Common.nvl(param.get("keywordDesc"));
		String information = "";

		KeywordVO keyword = new KeywordVO();
		keyword.setKeywordName(keywordName);
		if (!keywordService.isKeywordNameExist(keyword)) {
			information += "["+Prop.propFormat("common.msg.modify")+"]";
			if(Common.isNotEmpty(keywordGroupName))information += "┌"+Prop.propFormat("keyword.msg.part_name")+": " + keywordGroupName;
			if(Common.isNotEmpty(keywordName))information += "┌"+Prop.propFormat("keyword.msg.keyword")+": " + keywordName;
			if(Common.isNotEmpty(keywordDesc))information += "┌"+Prop.propFormat("keyword.msg.comment")+": " + keywordDesc;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
	
	public void deleteKeyword(final HttpServletRequest request, AuditRequestVO auditVo) {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); i++) {
			JSONObject obj = data.getJSONObject(i);
			String keywordGroupName = Common.nvl(obj.get("groupName"));
			String keywordName = Common.nvl(obj.get("keywordName"));
			String keywordDesc = Common.nvl(obj.get("keywordDesc"));
			String information = "";

			information += "["+Prop.propFormat("common.msg.delete")+"]";
			if(Common.isNotEmpty(keywordGroupName))information += "┌"+Prop.propFormat("keyword.msg.part_name")+": " + keywordGroupName;
			if(Common.isNotEmpty(keywordName))information += "┌"+Prop.propFormat("keyword.msg.keyword")+": " + keywordName;
			if(Common.isNotEmpty(keywordDesc))information += "┌"+Prop.propFormat("keyword.msg.comment")+": " + keywordDesc;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
}
