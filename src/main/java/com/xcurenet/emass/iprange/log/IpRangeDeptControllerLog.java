package com.xcurenet.emass.iprange.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class IpRangeDeptControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void getIpRangeList(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String adminId = Common.nvl(param.get("adminId"));

		String information = "["+Prop.propFormat("common.msg.search")+"]";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		auditVo.setInformation(information);
		if(Common.isNotEmpty(adminId)){
			auditVo.setPMenuId(ParentMenu.DATA_MONITOR.getParentMenuId());
			auditVo.setMenuId(Menu.DEPT_IPRANGE_VIEW.getMenuId());
		}
		auditService.insertAudit(request, auditVo);
	}
	public void insertIpRange(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String pdeptNm = Common.nvl(param.get("pdeptNm"));
		String deptNm = Common.nvl(param.get("deptNm"));
		String startIp = Common.nvl(param.get("startIp"));
		String endIp = Common.nvl(param.get("endIp"));
		String comment = Common.nvl(param.get("comment"));
		String AllLog = "┌"+Prop.propFormat("common.org.pdeptnm")+":"+pdeptNm+"┌"+Prop.propFormat("common.org.deptnm")+": " + deptNm + "┌"+Prop.propFormat("common.msg.start")+"IP: " + startIp +"┌"+Prop.propFormat("common.msg.end")+"IP: " + endIp+"┌"+Prop.propFormat("common.msg.comment")+": " +comment;
		auditVo.setInformation("["+Prop.propFormat("common.msg.add")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void updateIpRange(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String pdeptNm = Common.nvl(param.get("pdeptNm"));
		String deptNm = Common.nvl(param.get("deptNm"));
		String startIp = Common.nvl(param.get("startIp"));
		String endIp = Common.nvl(param.get("endIp"));
		String comment = Common.nvl(param.get("comment"));
		String AllLog = "┌"+Prop.propFormat("common.org.pdeptnm")+":"+pdeptNm+"┌"+Prop.propFormat("common.org.deptnm")+": " + deptNm + "┌"+Prop.propFormat("common.msg.start")+"IP: " + startIp +"┌"+Prop.propFormat("common.msg.end")+"IP: " + endIp+"┌"+Prop.propFormat("common.msg.comment")+": " +comment;
		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void deleteIpRange(final HttpServletRequest request, AuditRequestVO auditVo) {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		String pdeptNm = "";
		String deptNm  = "" ;
		String startIp = "" ;
		String endIp   = "" ;
		for (int i = 0; i < data.size(); ++i) {
		    JSONObject deptIp = data.getJSONObject(i);
		    pdeptNm = Common.nvl(deptIp.getString("pdeptNm"));
		    deptNm  = Common.nvl(deptIp.getString("deptNm"));
		    startIp = Common.nvl(deptIp.getString("startIp"));
		    endIp   = Common.nvl(deptIp.getString("endIp"));
		    String AllLog = "┌"+Prop.propFormat("common.org.pdeptnm")+":"+pdeptNm+"┌"+Prop.propFormat("common.org.deptnm")+": " + deptNm + "┌"+Prop.propFormat("common.msg.start")+"IP: " + startIp +"┌"+Prop.propFormat("common.msg.end")+"IP: " + endIp;
			auditVo.setInformation("["+Prop.propFormat("common.msg.delete")+"]" + AllLog);
			auditService.insertAudit(request, auditVo);
		}
	}
}
