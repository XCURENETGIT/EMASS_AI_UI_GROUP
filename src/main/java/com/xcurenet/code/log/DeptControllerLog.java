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
public class DeptControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void getDeptList(final HttpServletRequest request, AuditRequestVO auditVo) {
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
	
	public void insertDept(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String coCd = Common.nvl(param.get("coCd"));
		String coNm = Common.nvl(param.get("coNm"));
		String deptCd = Common.nvl(param.get("deptCd"));
		String deptNm = Common.nvl(param.get("deptNm"));
		String pDeptNm = Common.nvl(param.get("pDeptNm"));
		String AllLog ="┌"+Prop.propFormat("java.log.add.tab")+": "+Prop.propFormat("common.org.dept")+"┌"+Prop.propFormat("common.org.pdeptnm")+": " +pDeptNm +"┌"+Prop.propFormat("common.org.deptnm")+": "+deptNm +"┌"+Prop.propFormat("common.org.deptcd")+": "+deptCd+"┌"+Prop.propFormat("common.org.conm")+": "+coNm +"┌"+Prop.propFormat("common.org.cocd")+": "+coCd;
		auditVo.setInformation("["+Prop.propFormat("common.msg.add")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void updateDept(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String coCd = Common.nvl(param.get("coCd"));
		String coNm = Common.nvl(param.get("coNm"));
		String deptCd = Common.nvl(param.get("deptCd"));
		String deptNm = Common.nvl(param.get("deptNm"));
		String pDeptNm = Common.nvl(param.get("pDeptNm"));
		String AllLog ="┌"+Prop.propFormat("java.log.modify.tab")+": "+Prop.propFormat("common.org.dept")+"┌"+Prop.propFormat("common.org.pdeptnm")+": " +pDeptNm +""+Prop.propFormat("common.org.deptnm")+": "+deptNm +"┌"+Prop.propFormat("common.org.deptcd")+": "+deptCd+"┌"+Prop.propFormat("common.org.conm")+": "+coNm +"┌"+Prop.propFormat("common.org.cocd")+": "+coCd;
		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void deleteDept(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String deptCd = Common.nvl(param.get("deptCd"));
		String deptNm = Common.nvl(param.get("deptNm"));
		String AllLog ="┌"+Prop.propFormat("java.log.delete.tab")+": "+Prop.propFormat("common.org.dept")+"┌"+Prop.propFormat("common.org.deptnm")+": "+deptNm +"┌"+Prop.propFormat("common.org.deptcd")+": "+deptCd;
		auditVo.setInformation("["+Prop.propFormat("common.msg.delete")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
		
	}
}
