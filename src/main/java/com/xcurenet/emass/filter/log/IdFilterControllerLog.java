package com.xcurenet.emass.filter.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.filter.service.IdFilterVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class IdFilterControllerLog {

	@Autowired
	private AuditService auditService;

	public void getIdFilterList(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String serviceText = Common.nvl(param.get("serviceCd")).equals("") ? "" : Common.nvl(param.get("serviceText"));
		
		auditVo.setInformation("["+Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("common.msg.tab")+": ID┌"+Prop.propFormat("filterInfo.servicetype")+": " + serviceText + "┌"+Prop.propFormat("condition.search_str")+": " + searchStr);
		
		auditService.insertAudit(request, auditVo);
	}
	
	public void insertIdFilter(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String userId = Common.nvl(param.get("userId"));
		String serviceNm = Common.nvl(param.get("serviceNm"));
		
		auditVo.setInformation("["+Prop.propFormat("common.msg.add")+"]┌"+Prop.propFormat("common.msg.tab")+": ID┌ID: " + userId + "┌"+Prop.propFormat("filterInfo.servicetype")+": " + serviceNm);
		
		auditService.insertAudit(request, auditVo);
	}
	
	public void updateIdFilter(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String userId = Common.nvl(param.get("userId"));
		String serviceNm = Common.nvl(param.get("serviceNm"));
		
		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]┌"+Prop.propFormat("common.msg.tab")+": ID┌ID: " + userId + "┌"+Prop.propFormat("filterInfo.servicetype")+": " + serviceNm);
		
		auditService.insertAudit(request, auditVo);
	}
	
	public void deleteIdFilter(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String deleteData = Common.nvl(param.get("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		
		for (int i = 0; i < data.size(); i++) {
			IdFilterVO filter = (IdFilterVO) JSONObject.toBean(data.getJSONObject(i), IdFilterVO.class);
			
			auditVo.setInformation("["+Prop.propFormat("common.msg.delete")+"]┌"+Prop.propFormat("common.msg.tab")+": ID┌ID: " + filter.getUserId() + "┌"+Prop.propFormat("filterInfo.servicetype")+": [" + filter.getGroupNm() + "]" + filter.getServiceNm() + "┌"+Prop.propFormat("condition.service.code")+": " + filter.getServiceCd());
			auditService.insertAudit(request, auditVo);
		}
	}
}
