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
public class EpmsgTypeControllerLog {

	@Autowired
	private AuditService auditService;

	public void getEpmsgTypeList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String information = "[" + Prop.propFormat("common.msg.search") + "] ┌" + Prop.propFormat("java.log.search.tab") + ":" + Prop.propFormat("condition.epmsgType.list") + " ";
		if (Common.isNotEmpty(searchStr)) information += "┌" + Prop.propFormat("condition.search_str") + ": " + searchStr;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}

	public void insertEpmsgType(final HttpServletRequest request, AuditRequestVO auditVo) {
		auditVo.setInformation(makeInformation(Prop.propFormat("common.msg.add"), Common.getParam(request)));
		auditService.insertAudit(request, auditVo);
	}

	public void updateEpmsgType(final HttpServletRequest request, AuditRequestVO auditVo) {
		auditVo.setInformation(makeInformation(Prop.propFormat("common.msg.modify"), Common.getParam(request)));
		auditService.insertAudit(request, auditVo);
	}

	public void deleteEpmsgType(final HttpServletRequest request, AuditRequestVO auditVo) {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); i++) {
			auditVo.setInformation(makeInformation(Prop.propFormat("common.msg.delete"), data.getJSONObject(i)));
			auditService.insertAudit(request, auditVo);
		}
	}

	private String makeInformation(String action, JSONObject obj) {
		String code = Common.nvl(obj.get("epmsgTypeCode"));
		String name = Common.nvl(obj.get("epmsgTypeName"));
		String color = Common.nvl(obj.get("epmsgTypeColor"));
		String field = Common.nvl(obj.get("epmsgTypeField"));
		String useYn = Common.nvl(obj.get("useYn"));
		String information = "[" + action + "]";
		if (Common.isNotEmpty(code)) information += "┌" + Prop.propFormat("codeInfo.epmsg.type.code") + ": " + code;
		if (Common.isNotEmpty(name)) information += "┌" + Prop.propFormat("codeInfo.epmsg.type.name") + ": " + name;
		if (Common.isNotEmpty(color)) information += "┌" + Prop.propFormat("codeInfo.epmsg.type.color") + ": " + color;
		if (Common.isNotEmpty(field)) information += "┌" + Prop.propFormat("codeInfo.epmsg.type.field") + ": " + field;
		if (Common.isNotEmpty(useYn)) information += "┌" + Prop.propFormat("common.msg.useyn") + ": " + useYn;
		return information;
	}
}
