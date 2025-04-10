package com.xcurenet.emass.keyword.log;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class KeywordServiceControllerLog {

	@Autowired
	private AuditService auditService;

	public void getKeywordService(final HttpServletRequest request, AuditRequestVO auditVo){
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		if (Common.isEmpty(coreKeyword)) coreKeyword = Prop.propFormat("DATA_ANALYSIS.STAT_WORD_ALL");


		StringBuffer info = new StringBuffer();

		info.append("[").append(Prop.propFormat("filterInfo.service")).append(Prop.propFormat("common.msg.search")).append("]");
		info.append("┌").append(Prop.propFormat("condition.period")).append(": ").append(startDate).append(" ~ ").append(endDate);
		info.append("┌").append(Prop.propFormat("keyword.msg.coreKeyword")).append(": ").append(coreKeyword);


		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);

	}

	public void getKeywordServiceDetail(final HttpServletRequest request, AuditRequestVO auditVo){
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		if (Common.isEmpty(coreKeyword)) coreKeyword = Prop.propFormat("DATA_ANALYSIS.STAT_WORD_ALL");
		String svc = Common.nvl(request.getParameter("svc"));
		if (Common.isEmpty(svc)) coreKeyword = Prop.propFormat("DATA_ANALYSIS.STAT_WORD_ALL");

		StringBuffer info = new StringBuffer();

		info.append("[").append(Prop.propFormat("condition.info.detail")).append(Prop.propFormat("filterInfo.service")).append(" TOP 20").append(Prop.propFormat("common.msg.search")).append("]");
		info.append("┌").append(Prop.propFormat("condition.period")).append(": ").append(startDate).append(" ~ ").append(endDate);
		info.append("┌").append(Prop.propFormat("keyword.msg.coreKeyword")).append(": ").append(coreKeyword);
		info.append("┌").append(Prop.propFormat("filterInfo.service")).append(": ");
		info.append(String.join(",", svc.split(",")));

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);


	}

	public void getServiceKeyword(final HttpServletRequest request, AuditRequestVO auditVo){
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		if (Common.isEmpty(coreKeyword)) coreKeyword = Prop.propFormat("DATA_ANALYSIS.STAT_WORD_ALL");
		String svc = Common.nvl(request.getParameter("svc"));
		if (Common.isEmpty(svc)) svc = Prop.propFormat("DATA_ANALYSIS.STAT_WORD_ALL");
		String svc12 = Common.nvl(request.getParameter("svc12"));
		if (Common.isEmpty(svc12)) svc12 = Prop.propFormat("DATA_ANALYSIS.STAT_WORD_ALL");

		StringBuffer info = new StringBuffer();

		info.append("[").append(Prop.propFormat("DATA_ANALYSIS.STAT_WORD_KEYWORD")).append(" TOP 20").append(Prop.propFormat("common.msg.search")).append("]");
		info.append("┌").append(Prop.propFormat("condition.period")).append(": ").append(startDate).append(" ~ ").append(endDate);
		info.append("┌").append(Prop.propFormat("keyword.msg.coreKeyword")).append(": ").append(coreKeyword);
		info.append("┌").append(Prop.propFormat("filterInfo.service")).append(": ");
		info.append(String.join(",", svc.split(",")));

		info.append("┌").append(Prop.propFormat("condition.info.detail")).append(Prop.propFormat("DATA_ANALYSIS.STAT_WORD_KEYWORD")).append(": ");
		info.append(String.join(",", svc12.split(",")));

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);


	}

	public void getServiceKeywordDtail(final HttpServletRequest request, AuditRequestVO auditVo){
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		if (Common.isEmpty(coreKeyword)) coreKeyword = Prop.propFormat("DATA_ANALYSIS.STAT_WORD_ALL");
		String svc = Common.nvl(request.getParameter("svc"));
		if (Common.isEmpty(svc)) svc = Prop.propFormat("DATA_ANALYSIS.STAT_WORD_ALL");
		String svc12 = Common.nvl(request.getParameter("svc12"));
		if (Common.isEmpty(svc12)) svc12 = Prop.propFormat("DATA_ANALYSIS.STAT_WORD_ALL");

		StringBuffer info = new StringBuffer();

		info.append("[").append(Prop.propFormat("DATA_ANALYSIS.STAT_KEYWORD_DETAIL_TOP")).append(" TOP 20").append(Prop.propFormat("common.msg.search")).append("]");
		info.append("┌").append(Prop.propFormat("condition.period")).append(": ").append(startDate).append(" ~ ").append(endDate);
		info.append("┌").append(Prop.propFormat("keyword.msg.coreKeyword")).append(": ").append(coreKeyword);
		info.append("┌").append(Prop.propFormat("filterInfo.service")).append(": ");
		info.append(String.join(",", svc.split(",")));

		info.append("┌").append(Prop.propFormat("condition.info.detail")).append(Prop.propFormat("DATA_ANALYSIS.STAT_WORD_KEYWORD")).append(": ");
		info.append(String.join(",", svc12.split(",")));

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);


	}


}
