package com.xcurenet.emass.keyword.log;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.keyword.service.KeywordGroupService;
import com.xcurenet.emass.keyword.service.KeywordGroupVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class KeywordGroupControllerLog {

	@Autowired
	private AuditService auditService;
	
	@Resource(name = "keywordGroupService")
	public KeywordGroupService keywordGroupService;

	public void getKeywordGroupList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String information = "";
		
		information += "["+Prop.propFormat("keyword.msg.part_name") + " " + Prop.propFormat("common.msg.search")+"]";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void insertKeywordGroup(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String groupName = Common.nvl(param.get("groupName"));
		String useYn = Prop.propFormat("common.msg.use");
		if(Common.isEquals(Common.nvl(param.get("useYn")),"N")) useYn = Prop.propFormat("common.msg.unuse");
		String information = "";
		
		KeywordGroupVO group = new KeywordGroupVO();
		group.setGroupName(groupName);
		if (!keywordGroupService.isGroupNameExist(group)) {
			information += "["+Prop.propFormat("common.msg.add")+"]";
			if(Common.isNotEmpty(groupName))information += "┌"+Prop.propFormat("keyword.msg.part_name")+": " + groupName;
			if(Common.isNotEmpty(useYn))information += "┌"+Prop.propFormat("common.msg.useyn")+": " + useYn;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
	
	public void updateKeywordGroup(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String groupName = Common.nvl(param.get("groupName"));
		String useYn = Prop.propFormat("common.msg.use");
		if(Common.isEquals(Common.nvl(param.get("useYn")),"N")) useYn = Prop.propFormat("common.msg.unuse");
		String information = "";

		KeywordGroupVO group = new KeywordGroupVO();
		group.setGroupName(groupName);
		if (!keywordGroupService.isGroupNameExist(group)) {
			information += "["+Prop.propFormat("common.msg.modify")+"]";
			if(Common.isNotEmpty(groupName))information += "┌"+Prop.propFormat("keyword.msg.part_name")+": " + groupName;
			if(Common.isNotEmpty(useYn))information += "┌"+Prop.propFormat("common.msg.useyn")+": " + useYn;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
	
	public void deleteKeywordGroup(final HttpServletRequest request, AuditRequestVO auditVo) {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); i++) {
			JSONObject obj = data.getJSONObject(i);
			String groupName = Common.nvl(obj.get("groupName"));
			String useYn = Prop.propFormat("common.msg.use");
			if(Common.isEquals(Common.nvl(obj.get("useYn")),"N")) useYn = Prop.propFormat("common.msg.unuse");
			String information = "";

			information += "["+Prop.propFormat("common.msg.delete")+"]";
			if(Common.isNotEmpty(groupName))information += "┌"+Prop.propFormat("keyword.msg.part_name")+": " + groupName;
			if(Common.isNotEmpty(useYn))information += "┌"+Prop.propFormat("common.msg.useyn")+": " + useYn;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
}
