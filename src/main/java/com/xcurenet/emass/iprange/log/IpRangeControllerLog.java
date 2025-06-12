package com.xcurenet.emass.iprange.log;

import javax.servlet.http.HttpServletRequest;

import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.ParentMenu;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class IpRangeControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void getIpRangeList(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		
		String information = "["+Prop.propFormat("common.msg.search")+"]";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}

	public void getIpRangeListByBusicd(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));

		String information = "["+Prop.propFormat("common.msg.search")+"]";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		auditVo.setInformation(information);
		auditVo.setPMenuId(ParentMenu.SETTING.getParentMenuId());
		auditVo.setMenuId(Menu.BUSI_IPRANGE_VIEW.getMenuId());
		auditService.insertAudit(request, auditVo);
	}

	public void insertIpRange(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String busiNm = Common.nvl(param.get("busiNm"));
		String startIp = Common.nvl(param.get("startIp"));
		String endIp = Common.nvl(param.get("endIp"));
		String comment = Common.nvl(param.get("comment"));
		String AllLog = "┌"+Prop.propFormat("common.org.businm")+": " + busiNm + "┌"+Prop.propFormat("common.msg.start")+"IP: " + startIp +"┌"+Prop.propFormat("common.msg.end")+"IP: " + endIp+"┌"+Prop.propFormat("common.msg.comment")+": " +comment;
		auditVo.setInformation("["+Prop.propFormat("common.msg.add")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void updateIpRange(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String busiNm = Common.nvl(param.get("busiNm"));
		String startIp = Common.nvl(param.get("startIp"));
		String endIp = Common.nvl(param.get("endIp"));
		String comment = Common.nvl(param.get("comment"));
		String AllLog = "┌"+Prop.propFormat("common.org.businm")+": " + busiNm + "┌"+Prop.propFormat("common.msg.start")+"IP: " + startIp +"┌"+Prop.propFormat("common.msg.end")+"IP: " + endIp+"┌"+Prop.propFormat("common.msg.comment")+": " +comment;
		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void deleteIpRange(final HttpServletRequest request, AuditRequestVO auditVo) {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		String busiNm ="" ;
		String startIp ="" ;
		String endIp ="" ;
		for (int i = 0; i < data.size(); ++i) {
		    JSONObject busiIp = data.getJSONObject(i);
		    busiNm = busiIp.getString("busiNm");
		    startIp = busiIp.getString("startIp");
		    endIp = busiIp.getString("endIp");
		    String AllLog = "┌"+Prop.propFormat("common.org.businm")+": " + busiNm + "┌"+Prop.propFormat("common.msg.start")+"IP: " + startIp +"┌"+Prop.propFormat("common.msg.end")+"IP: " + endIp;
			auditVo.setInformation("["+Prop.propFormat("common.msg.delete")+"]" + AllLog);
			auditService.insertAudit(request, auditVo);
		}
	}
}
