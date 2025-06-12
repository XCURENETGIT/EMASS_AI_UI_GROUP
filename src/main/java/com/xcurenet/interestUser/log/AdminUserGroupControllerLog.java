package com.xcurenet.interestUser.log;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class AdminUserGroupControllerLog {

	@Autowired
	private AuditService auditService;


	public void getAdminUserGroupList(final HttpServletRequest request, AuditRequestVO auditVo) throws Exception {
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));

		String information = "[" + Prop.propFormat("condition.interestGroup") + " " + Prop.propFormat("common.msg.search")+"]";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}

	public void insertAdminUserGroup(final HttpServletRequest request, AuditRequestVO auditVo) throws Exception {
		JSONObject param = Common.getParam(request);
		String groupName = Common.nvl(param.get("groupName"));

		String information = "[" + Prop.propFormat("condition.interestGroup") + " " + Prop.propFormat("common.msg.add")+"]";
		if(Common.isNotEmpty(groupName)) information += "┌"+Prop.propFormat("condition.interestGroup")+": " + groupName;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}



}
