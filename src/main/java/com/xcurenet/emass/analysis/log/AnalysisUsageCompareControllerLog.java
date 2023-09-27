package com.xcurenet.emass.analysis.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class AnalysisUsageCompareControllerLog {

	@Autowired
	private AuditService auditService;

	public void selectUsageChart(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		auditVo.setInformation(getSearchValue(param).toString());
		auditService.insertAudit(request, auditVo);
	}

	public void selectUsageList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String date = Common.nvl(param.get("date"));
		String itemName = Common.nvl(param.get("itemName"));
		StringBuilder information = new StringBuilder();

		information.append("[").append(Prop.propFormat("analysis.usagecompare.graphselectsearch")).append("]");
		information.append("┌").append(Prop.propFormat("analysis.usagecompare.searchitem")).append(": ").append(itemName);
		information.append("┌").append(Prop.propFormat("common.date")).append(": ").append(date);

		auditVo.setInformation(information.toString());
		auditService.insertAudit(request, auditVo);
	}

	public void selectDetailList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String date = Common.nvl(param.get("date"));
		String item = Common.nvl(param.get("item"));
		String keyword = Common.nvl(param.get("keyword"));
		StringBuilder information = new StringBuilder();
		
		information.append("[").append(Prop.propFormat("analysis.usagecompare.userdetaillistsearch")).append("]");
		information.append("┌").append(Prop.propFormat("common.date")).append(": ").append(date);
		
		switch(item) {
		case "fileSize" :
			information.append("┌").append(Prop.propFormat("condition.attach_name")).append(": ").append(keyword);
			break;
		case "outMail" :
		case "inMail" :
		information.append("┌").append(Prop.propFormat("condition.from")).append(": ").append(keyword);
			break;
		case "ftp" :
		case "totalSize" :
		information.append("┌").append(Prop.propFormat("condition.source")).append(": ").append(keyword);
			break;
		}

		auditVo.setInformation(information.toString());
		auditService.insertAudit(request, auditVo);

	}

	private StringBuilder getSearchValue(JSONObject param) {

		String unit = Common.nvl(param.get("unit"));
		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		String itemName = Common.nvl(param.get("itemName"));
		StringBuilder information = new StringBuilder();

		switch(unit) {
		case "t" :
			unit = Prop.propFormat("analysis.usagecompare.timeunit");
			break;
		case "d" :
			unit = Prop.propFormat("analysis.usagecompare.dayunit");
			break;
		case "w" :
			unit = Prop.propFormat("analysis.usagecompare.weekunit");
			break;
		case "m" :
			unit = Prop.propFormat("analysis.usagecompare.monthunit");
			break;
		}

		information.append("[").append(Prop.propFormat("common.msg.search")).append("]");
		information.append("┌").append(Prop.propFormat("analysis.usagecompare.groupunit")).append(": ").append(unit);
		information.append("┌").append(Prop.propFormat("analysis.usagecompare.searchitem")).append(": ").append(itemName);
		information.append("┌").append(Prop.propFormat("condition.period")).append(": ").append(startDate).append(" ~ ").append(endDate);

		return information;
	}

}

