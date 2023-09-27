package com.xcurenet.emass.statistics.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class SolrEdcStatControllerLog {

	@Autowired
	private AuditService auditService;

	public void getStatList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String xAxis_str = Common.nvl(param.get("xAxis_str"));
		String yAxis = Common.nvl(param.get("yAxis"));
		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		String interGroup = Common.nvl(param.get("interGroup"));
		String detailQuery = Common.nvl(param.get("detailQuery"));
		String interGroupNm = Common.nvl(param.get("interGroupNm"));
		String information = "";
		
		if( Common.isEquals(yAxis, "userid") ) auditVo.setMenuId(Menu.STAT_USER.getMenuId());
		else if( Common.isEquals(yAxis, "user_str") ) auditVo.setMenuId(Menu.STAT_INTEREST.getMenuId());
		else if( Common.isEquals(yAxis, "sender_str") ) auditVo.setMenuId(Menu.STAT_SENDER.getMenuId());
		else if( Common.isEquals(yAxis, "svc") ) auditVo.setMenuId(Menu.STAT_SVC.getMenuId());
		else if( Common.isEquals(yAxis, "kwds") ) auditVo.setMenuId(Menu.STAT_KWD.getMenuId());
		else if( Common.isEquals(yAxis, "attachtype") ) auditVo.setMenuId(Menu.STAT_ATTACHTYPE.getMenuId());
		else if( Common.isEquals(yAxis, "attachname_str") ) auditVo.setMenuId(Menu.STAT_ATTACHNAME.getMenuId());
		else if( Common.isEquals(yAxis, "host_str") ) auditVo.setMenuId(Menu.STAT_URL.getMenuId());
		else if( Common.isEquals(yAxis, "ocr_attach_cnt") ) auditVo.setMenuId(Menu.STAT_OCR.getMenuId());
		
		information += "["+Prop.propFormat("common.msg.search")+"]";
		if( Common.isNotEmpty(interGroup)) information += "┌"+Prop.propFormat("interest.user")+": " + interGroupNm;
		if( Common.isNotEmpty(startDate)) information += "┌"+Prop.propFormat("condition.period")+": " + startDate + " ~ " + endDate;
		if( Common.isNotEmpty(xAxis_str)) information += "┌"+Prop.propFormat("stat.area.stat")+": " + xAxis_str;
		if( Common.isNotEmpty(detailQuery)) information += "┌"+Prop.propFormat("condition.detail")+": " + detailQuery;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void getDetailList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String xAxis_str = Common.nvl(param.get("xAxis_str"));
		String yAxis = Common.nvl(param.get("yAxis"));
		String yAxis_str = "";
		String rowKey = Common.nvl(param.get("rowKey"));
		String colKey = Common.nvl(param.get("colKey"));
		if( Common.isEquals(colKey, "") ) colKey = ""+Prop.propFormat("common.msg.all")+"";
		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		String interGroup = Common.nvl(param.get("interGroup"));
		String interGroupNm = Common.nvl(param.get("interGroupNm"));
		String information = "";
		
		if( Common.isEquals(yAxis, "userid") ) {
			auditVo.setMenuId(Menu.STAT_USER.getMenuId());
			yAxis_str = Prop.propFormat("consent.user");
		}
		else if( Common.isEquals(yAxis, "user_str") ) {
			auditVo.setMenuId(Menu.STAT_INTEREST.getMenuId());
			yAxis_str = Prop.propFormat("interest.user");
		}
		else if( Common.isEquals(yAxis, "sender_str") ) {
			auditVo.setMenuId(Menu.STAT_SENDER.getMenuId());
			yAxis_str = Prop.propFormat("condition.sender");
		}
		else if( Common.isEquals(yAxis, "svc12") ) {
			auditVo.setMenuId(Menu.STAT_SVC.getMenuId());
			yAxis_str = Prop.propFormat("filterInfo.servicetype");
		}
		else if( Common.isEquals(yAxis, "kwds") ) {
			auditVo.setMenuId(Menu.STAT_KWD.getMenuId());
			yAxis_str = Prop.propFormat("condition.keyword");
		}
		else if( Common.isEquals(yAxis, "attachtype") ) {
			auditVo.setMenuId(Menu.STAT_ATTACHTYPE.getMenuId());
			yAxis_str = Prop.propFormat("condition.attach_type");
		}
		else if( Common.isEquals(yAxis, "attachname_str") ) {
			auditVo.setMenuId(Menu.STAT_ATTACHNAME.getMenuId());
			yAxis_str = Prop.propFormat("condition.attach_name");
		}
		else if( Common.isEquals(yAxis, "host_str") ) {
			auditVo.setMenuId(Menu.STAT_URL.getMenuId());
			yAxis_str = "URL";
		}
		else if( Common.isEquals(yAxis, "userid") ) {
			auditVo.setMenuId(Menu.STAT_OCR.getMenuId());
			yAxis_str = "OCR";
		}
		
		information += "["+Prop.propFormat("common.msg.detail.search")+"]";
		//if( Common.isNotEmpty(interGroup)) information += "┌"+Prop.propFormat("interest.user")+": " + interGroupNm;
		if( Common.isNotEmpty(startDate)) information += "┌"+Prop.propFormat("condition.period")+": " + startDate + " ~ " + endDate;
		if( Common.isNotEmpty(rowKey)) information += "┌" + yAxis_str + ": " + rowKey;
		if( Common.isNotEmpty(colKey)) information += "┌" + xAxis_str + ": " + colKey;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void getCheckedStatList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String xAxis_str = Common.nvl(param.get("xAxis_str"));
		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		String detailQuery = Common.nvl(param.get("detailQuery"));
		String information = "";
		
		information += "["+Prop.propFormat("common.msg.search")+"]";
		if( Common.isNotEmpty(startDate)) information += "┌"+Prop.propFormat("condition.period")+": " + startDate + " ~ " + endDate;
		if( Common.isNotEmpty(xAxis_str)) information += "┌"+Prop.propFormat("stat.area.stat")+": " + xAxis_str;
		if( Common.isNotEmpty(detailQuery)) information += "┌"+Prop.propFormat("condition.detail")+": " + detailQuery;
		
		auditVo.setMenuId(Menu.STAT_ADMINREAD.getMenuId());
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void getCheckedDetailList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String xAxis_str = Common.nvl(param.get("xAxis_str"));
		String colKey = Common.nvl(param.get("colKey"));
		if( Common.isEquals(colKey, "") ) colKey = ""+Prop.propFormat("common.msg.all")+"";
		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		String information = "";
		
		information += "["+Prop.propFormat("common.msg.detail.search")+"]";
		if( Common.isNotEmpty(startDate)) information += "┌"+Prop.propFormat("condition.period")+": " + startDate + " ~ " + endDate;
		if( Common.isNotEmpty(colKey)) information += "┌" + xAxis_str + ": " + colKey;
		
		auditVo.setMenuId(Menu.STAT_ADMINREAD.getMenuId());
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void getOcrStatList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String xAxis_str = Common.nvl(param.get("xAxis_str"));
		String yAxis = Common.nvl(param.get("yAxis"));
		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		String information = "";
		
		if( Common.isEquals(yAxis, "ocr_attach_cnt") ) auditVo.setMenuId(Menu.STAT_OCR.getMenuId());
		
		information += "["+Prop.propFormat("common.msg.search")+"]";
		if( Common.isNotEmpty(startDate)) information += "┌"+Prop.propFormat("condition.period")+": " + startDate + " ~ " + endDate;
		if( Common.isNotEmpty(xAxis_str)) information += "┌"+Prop.propFormat("stat.area.stat")+": " + xAxis_str;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void getOcrDetailList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String xAxis_str = Common.nvl(param.get("xAxis_str"));
		String yAxis = Common.nvl(param.get("yAxis"));
		String yAxis_str = "";
		String rowKey = Common.nvl(param.get("rowKey"));
		String colKey = Common.nvl(param.get("colKey"));
		if( Common.isEquals(colKey, "") ) colKey = ""+Prop.propFormat("common.msg.all")+"";
		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		String information = "";
		
		if( Common.isEquals(yAxis, "ocr_attach_cnt") ) {
			auditVo.setMenuId(Menu.STAT_OCR.getMenuId());
			yAxis_str = "OCR";
		}
		
		information += "["+Prop.propFormat("common.msg.detail.search")+"]";
		//if( Common.isNotEmpty(interGroup)) information += "┌"+Prop.propFormat("interest.user")+": " + interGroupNm;
		if( Common.isNotEmpty(startDate)) information += "┌"+Prop.propFormat("condition.period")+": " + startDate + " ~ " + endDate;
		if( Common.isNotEmpty(rowKey)) information += "┌" + yAxis_str + ": " + rowKey;
		if( Common.isNotEmpty(colKey)) information += "┌" + xAxis_str + ": " + colKey;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
}
