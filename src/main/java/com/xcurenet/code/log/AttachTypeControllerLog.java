package com.xcurenet.code.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class AttachTypeControllerLog {
	
	@Autowired
	private AuditService auditService;

	public void getAttachTypeList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String information = "["+Prop.propFormat("common.msg.search")+"] ┌"+Prop.propFormat("java.log.search.tab")+":"+Prop.propFormat("message.msg.file")+" ";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
		
	}
	public void insertAttachType(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String attachType = Common.nvl(param.get("attachType"));
		String attachName = Common.nvl(param.get("attachName"));
		String attachDesc = Common.nvl(param.get("attachDesc"));
		String information = "";
		information += "["+Prop.propFormat("common.msg.add")+"]";
		if (Common.isNotEmpty(attachName)) information += "┌"+Prop.propFormat("condition.attach_type")+": " + attachName;
		if (Common.isNotEmpty(attachType)) information += "┌"+Prop.propFormat("codeInfo.attchext")+": " + attachType;
		if (Common.isNotEmpty(attachDesc)) information += "┌"+Prop.propFormat("codeInfo.attachcomment")+": " + attachDesc;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	public void deleteAttachType(final HttpServletRequest request, AuditRequestVO auditVo) {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); i++) {
			JSONObject obj = data.getJSONObject(i);
			String attachType = Common.nvl(obj.get("attachType"));
			String attachName = Common.nvl(obj.get("attachName"));
			String attachDesc = Common.nvl(obj.get("attachDesc"));
			String information = "";
			information += "["+Prop.propFormat("common.msg.delete")+"]";
			if (Common.isNotEmpty(attachName)) information += "┌"+Prop.propFormat("condition.attach_type")+": " + attachName;
			if (Common.isNotEmpty(attachType)) information += "┌"+Prop.propFormat("codeInfo.attchext")+": " + attachType;
			if (Common.isNotEmpty(attachDesc)) information += "┌"+Prop.propFormat("codeInfo.attachcomment")+": " + attachDesc;
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
}
