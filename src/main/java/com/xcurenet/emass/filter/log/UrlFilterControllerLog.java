package com.xcurenet.emass.filter.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.filter.service.UrlFilterVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class UrlFilterControllerLog {

	@Autowired
	private AuditService auditService;

	public void getUrlFilterList(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String serviceText = Common.nvl(param.get("serviceCd")).equals("") ? "" : Common.nvl(param.get("serviceText"));
		
		auditVo.setInformation("["+Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("common.msg.tab")+": " + Prop.propFormat("filterInfo.subject") + "┌"+Prop.propFormat("filterInfo.servicetype")+": " + serviceText + "┌"+Prop.propFormat("condition.search_str")+": " + searchStr);
		
		auditService.insertAudit(request, auditVo);
	}
	
	public void insertUrlFilter(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String url = Common.nvl(param.get("url"));
		
		auditVo.setInformation("["+Prop.propFormat("common.msg.add")+"]┌"+Prop.propFormat("common.msg.tab")+": " + Prop.propFormat("filterInfo.subject") + "┌URL: " + url);
		
		auditService.insertAudit(request, auditVo);
	}
	
	public void updateUrlFilter(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String url = Common.nvl(param.get("url"));
		
		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]┌"+Prop.propFormat("common.msg.tab")+": " + Prop.propFormat("filterInfo.subject") + "┌URL: " + url);
		
		auditService.insertAudit(request, auditVo);
	}
	
	public void deleteUrlFilter(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String deleteData = Common.nvl(param.get("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		
		for (int i = 0; i < data.size(); i++) {
			UrlFilterVO filter = (UrlFilterVO) JSONObject.toBean(data.getJSONObject(i), UrlFilterVO.class);
			
			auditVo.setInformation("["+Prop.propFormat("common.msg.delete")+"]┌"+Prop.propFormat("common.msg.tab")+": " + Prop.propFormat("filterInfo.subject") + "┌URL: " + filter.getUrl());
			auditService.insertAudit(request, auditVo);
		}
	}
}
