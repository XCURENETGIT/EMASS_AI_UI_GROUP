package com.xcurenet.emass.service.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class ServiceTypeControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void getServiceListByAll(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String searchUseYn = Common.nvl(param.get("searchUseYn"));
		String searchUseYnStr = "";
		if(Common.isEquals(searchUseYn,"")) searchUseYnStr = Prop.propFormat("common.msg.all");
		else if(Common.isEquals(searchUseYn,"Y")) searchUseYnStr = Prop.propFormat("common.msg.use");
		else if(Common.isEquals(searchUseYn,"N")) searchUseYnStr = Prop.propFormat("common.msg.unuse");
		String information = "["+Prop.propFormat("common.msg.search")+"] ┌"+Prop.propFormat("java.log.search.tab")+":"+Prop.propFormat("condition.service")+" ";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		information += "┌"+Prop.propFormat("common.msg.useyn")+": " + searchUseYnStr;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void updateServiceUseYn(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String serviceNm = Common.nvl(param.get("serviceNm"));
		String useYn = Common.nvl(param.get("useYn"));
		String useYnStr = "";
		if(Common.isEquals(useYn,"Y")) useYnStr = Prop.propFormat("common.msg.use");
		else if(Common.isEquals(useYn,"N")) useYnStr = Prop.propFormat("common.msg.unuse");
		String information = "["+Prop.propFormat("common.msg.modify")+"]";
		information += "┌"+Prop.propFormat("filterInfo.service")+": " + serviceNm;
		information += "┌"+Prop.propFormat("common.msg.useyn")+": " + useYnStr;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
}
