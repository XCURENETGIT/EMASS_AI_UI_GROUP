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
public class AnalysisRelationControllerLog {

	@Autowired
	private AuditService auditService;
	
	public void dataRelationList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		StringBuilder information = new StringBuilder();
		information.append("[").append(Prop.propFormat("common.msg.search")).append("]");
		information.append(getSearchValue(param));

		auditVo.setInformation(information.toString());
		auditService.insertAudit(request, auditVo);
	}

	public void dataDetailList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		StringBuilder information = new StringBuilder();
		
		information.append("[").append(Prop.propFormat("analysis.relation.listdetailsearch")).append("]");
		information.append(getSearchValue(param));

		switch(Common.nvl(param.get("unit"))) {
		case "file" :
			information.append("┌").append(Prop.propFormat("consent.attach")).append(": ");
			break;
		case "mailid" :
			information.append("┌").append(Prop.propFormat("analysis.relation.mailid")).append(": ");
			break;
		}
		information.append(Common.nvl(param.get("listData")));

		auditVo.setInformation(information.toString());
		auditService.insertAudit(request, auditVo);

	}

	public void dataSelectList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String name = Common.nvl(param.get("name"));
		String[] nameArray = name.split("<");
		if(nameArray.length > 1) {
			name = nameArray[1].replaceAll(">", "");
		}

		StringBuilder information = new StringBuilder();
		information.append("[").append(Prop.propFormat("analysis.relation.relationselectsearch")).append("]");
		information.append("┌").append(Prop.propFormat("analysis.relation.mailid")).append("(IP): ").append(name);

		auditVo.setInformation(information.toString());
		auditService.insertAudit(request, auditVo);
	}

	private StringBuilder getSearchValue(JSONObject param) {

		String unit = Common.nvl(param.get("unit"));
		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		String title = Common.nvl(param.get("title"));
		String sendUser = Common.nvl(param.get("sendUser"));
		String receiveUser = Common.nvl(param.get("receiveUser"));
		String keyword = Common.nvl(param.get("keyword"));
		String fileSize = Common.nvl(param.get("fileSize"));
		String userSeq = Common.nvl(param.get("userSeqName"));
		StringBuilder information = new StringBuilder();

		switch(unit) {
		case "file" :
			unit = Prop.propFormat("condition.attach_name");
			break;
		case "mailid" :
			unit = Prop.propFormat("analysis.relation.mailid");
			break;
		}

		information.append("┌").append(Prop.propFormat("analysis.relation.unit")).append(": ").append(unit);
		information.append("┌").append(Prop.propFormat("condition.period")).append(": ").append(startDate).append(" ~ ").append(endDate);
		information.append("┌").append(Prop.propFormat("condition.subject")).append(": ").append(title);
		information.append("┌").append(Prop.propFormat("condition.from")).append(": ").append(sendUser);
		information.append("┌").append(Prop.propFormat("condition.to")).append(": ").append(receiveUser);
		information.append("┌").append(Prop.propFormat("dashboard.msg.keyword")).append(": ").append(keyword);
		information.append("┌").append(Prop.propFormat("analysis.relation.attachsize")).append("(MB").append(Prop.propFormat("filterInfo.rangeL")).append("): ").append(fileSize);
		information.append("┌").append(Prop.propFormat("interest.user")).append(": ").append(userSeq);

		return information;
	}
}

