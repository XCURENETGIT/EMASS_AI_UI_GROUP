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
public class GeneralControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void getGeneralList(final HttpServletRequest request, AuditRequestVO auditVo) {
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
	
	public void insertGeneral(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String generalCd = Common.nvl(param.get("generalCd"));
		String generalNm = Common.nvl(param.get("generalNm"));
		String coCd = Common.nvl(param.get("coCd"));
		String coNm = Common.nvl(param.get("coNm"));
		String AllLog ="┌"+Prop.propFormat("java.log.add.tab")+": "+Prop.propFormat("common.org.general")+"┌"+Prop.propFormat("common.org.generalnm")+": "+generalNm +"┌"+Prop.propFormat("common.org.generalcd")+": "+generalCd+"┌"+Prop.propFormat("common.org.conm")+": "+coNm +"┌"+Prop.propFormat("common.org.cocd")+": "+coCd;
		auditVo.setInformation("["+Prop.propFormat("common.msg.add")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void updateGeneral(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String generalCd = Common.nvl(param.get("generalCd"));
		String generalNm = Common.nvl(param.get("generalNm"));
		String coCd = Common.nvl(param.get("coCd"));
		String coNm = Common.nvl(param.get("coNm"));
		String AllLog ="┌"+Prop.propFormat("java.log.modify.tab")+": "+Prop.propFormat("common.org.general")+"┌"+Prop.propFormat("common.org.generalnm")+": "+generalNm +"┌"+Prop.propFormat("common.org.generalcd")+": "+generalCd+"┌"+Prop.propFormat("common.org.conm")+": "+coNm +"┌"+Prop.propFormat("common.org.cocd")+": "+coCd;
		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void deleteGeneral(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String generalCd = Common.nvl(param.get("generalCd"));
		String generalNm = Common.nvl(param.get("generalNm"));
		String AllLog ="┌"+Prop.propFormat("java.log.delete.tab")+": "+Prop.propFormat("common.org.general")+"┌"+Prop.propFormat("common.org.generalnm")+": "+generalNm +"┌"+Prop.propFormat("common.org.generalcd")+": "+generalCd;
		auditVo.setInformation("["+Prop.propFormat("common.msg.delete")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
		
	}
}
