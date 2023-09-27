package com.xcurenet.emass.filter.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.filter.service.SizeFilterVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class SizeFilterControllerLog {

	@Autowired
	private AuditService auditService;

	public void getSizeFilterList(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String serviceText = Common.nvl(param.get("serviceCd")).equals("") ? "" : Common.nvl(param.get("serviceText"));
		
		auditVo.setInformation("["+Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("common.msg.tab")+": " + Prop.propFormat("filterInfo.size") + "┌"+Prop.propFormat("filterInfo.servicetype")+": " + serviceText + "┌"+Prop.propFormat("condition.search_str")+": " + searchStr);
		
		auditService.insertAudit(request, auditVo);
	}
	
	public void insertSizeFilter(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String serviceNm = Common.nvl(param.get("serviceNm"));
		String lowSize = Common.nvl(param.get("lowSize"));
		String highSize = Common.nvl(param.get("highSize"));
		String sizeCondition = Common.nvl(param.get("sizeCondition"));
		
		auditVo.setInformation("["+Prop.propFormat("common.msg.add")+"]┌"+Prop.propFormat("common.msg.tab")+": " + Prop.propFormat("filterInfo.size") + "┌"+Prop.propFormat("filterInfo.servicetype")+": " + serviceNm + "┌"+Prop.propFormat("common.msg.message_size")+": " + getSizeText(lowSize, highSize, sizeCondition));
		
		auditService.insertAudit(request, auditVo);
	}
	
	public String getSizeText( String lowSize, String highSize, String sizeCondition ) {
		String str = "";
		
		if( sizeCondition.equals("B") ) str = lowSize + "~" + highSize;
		else if( sizeCondition.equals("L") ) str = lowSize + Prop.propFormat("condition.over");
		else str = lowSize + Prop.propFormat("condition.below");
		
		return str;
	}
	
	public void updateSizeFilter(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String serviceNm = Common.nvl(param.get("serviceNm"));
		String lowSize = Common.nvl(param.get("lowSize"));
		String highSize = Common.nvl(param.get("highSize"));
		String sizeCondition = Common.nvl(param.get("sizeCondition"));
		
		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]┌"+Prop.propFormat("common.msg.tab")+": " + Prop.propFormat("filterInfo.size") + "┌"+Prop.propFormat("filterInfo.servicetype")+": " + serviceNm + "┌"+Prop.propFormat("common.msg.message_size")+": " + getSizeText(lowSize, highSize, sizeCondition));
		
		auditService.insertAudit(request, auditVo);
	}
	
	public void deleteSizeFilter(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String deleteData = Common.nvl(param.get("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		
		for (int i = 0; i < data.size(); i++) {
			SizeFilterVO filter = (SizeFilterVO) JSONObject.toBean(data.getJSONObject(i), SizeFilterVO.class);
			
			auditVo.setInformation("["+Prop.propFormat("common.msg.delete")+"]┌"+Prop.propFormat("common.msg.tab")+": " + Prop.propFormat("filterInfo.size") + "┌"+Prop.propFormat("filterInfo.servicetype")+": [" + filter.getGroupNm() + "]" + filter.getServiceNm() + "┌"+Prop.propFormat("condition.service.code")+": " + filter.getServiceCd() + "┌"+Prop.propFormat("common.msg.message_size")+": " + getSizeText(filter.getLowSize(), filter.getHighSize(), filter.getSizeCondition() ) );
			auditService.insertAudit(request, auditVo);
		}
	}
}
