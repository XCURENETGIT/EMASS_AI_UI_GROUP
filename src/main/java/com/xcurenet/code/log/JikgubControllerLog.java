package com.xcurenet.code.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class JikgubControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void getJikgubList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String tab = Common.nvl(param.get("tab"));
		String information = "";
		information += "["+Prop.propFormat("common.msg.search")+"]";
		if(Common.isNotEmpty(tab)) information += "┌"+Prop.propFormat("java.log.search.tab")+": " + tab;
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	public void insertJikgub(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String jikgubCd = Common.nvl(param.get("jikgubCd"));
		String jikgubNm = Common.nvl(param.get("jikgubNm"));
		String AllLog ="┌"+Prop.propFormat("java.log.add.tab")+": "+Prop.propFormat("common.org.jikgub")+"┌"+Prop.propFormat("common.org.jikgubnm")+": "+jikgubNm +"┌"+Prop.propFormat("common.org.jikgubcd")+": "+jikgubCd;
		auditVo.setInformation("["+Prop.propFormat("common.msg.add")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void updateJikgub(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String jikgubCd = Common.nvl(param.get("jikgubCd"));
		String jikgubNm = Common.nvl(param.get("jikgubNm"));
		String AllLog ="┌"+Prop.propFormat("java.log.modify.tab")+": "+Prop.propFormat("common.org.jikgub")+"┌"+Prop.propFormat("common.org.jikgubnm")+": "+jikgubNm +"┌"+Prop.propFormat("common.org.jikgubcd")+": "+jikgubCd;
		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void deleteJikgub(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String jikgubCd = Common.nvl(param.get("jikgubCd"));
		String jikgubNm = Common.nvl(param.get("jikgubNm"));
		String AllLog ="┌"+Prop.propFormat("java.log.delete.tab")+": "+Prop.propFormat("common.org.jikgub")+"┌"+Prop.propFormat("common.org.jikgubnm")+": "+jikgubNm +"┌"+Prop.propFormat("common.org.jikgubcd")+": "+jikgubCd;
		auditVo.setInformation("["+Prop.propFormat("common.msg.delete")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
		
	}
}
