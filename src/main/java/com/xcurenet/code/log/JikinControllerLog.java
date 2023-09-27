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
public class JikinControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void getJikinList(final HttpServletRequest request, AuditRequestVO auditVo) {
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
	public void insertJikin(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String jikinCd = Common.nvl(param.get("jikinCd"));
		String jikinNm = Common.nvl(param.get("jikinNm"));
		String AllLog ="┌"+Prop.propFormat("java.log.add.tab")+": "+Prop.propFormat("common.org.jikin")+"┌"+Prop.propFormat("common.org.jikinnm")+": "+jikinNm +"┌"+Prop.propFormat("common.org.jikincd")+": "+jikinCd;
		auditVo.setInformation("["+Prop.propFormat("common.msg.add")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void updateJikin(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String jikinCd = Common.nvl(param.get("jikinCd"));
		String jikinNm = Common.nvl(param.get("jikinNm"));
		String AllLog ="┌"+Prop.propFormat("java.log.modify.tab")+": "+Prop.propFormat("common.org.jikin")+"┌"+Prop.propFormat("common.org.jikinnm")+": "+jikinNm +"┌"+Prop.propFormat("common.org.jikincd")+": "+jikinCd;
		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void deleteJikin(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String jikinCd = Common.nvl(param.get("jikinCd"));
		String jikinNm = Common.nvl(param.get("jikinNm"));
		String AllLog ="┌"+Prop.propFormat("java.log.delete.tab")+": "+Prop.propFormat("common.org.jikin")+"┌"+Prop.propFormat("common.org.jikinnm")+": "+jikinNm +"┌"+Prop.propFormat("common.org.jikincd")+": "+jikinCd;
		auditVo.setInformation("["+Prop.propFormat("common.msg.delete")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
		
	}
}
