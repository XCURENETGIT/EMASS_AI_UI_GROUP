package com.xcurenet.emass.keyword.log;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class KeywordHostControllerLog {

	@Autowired
	private AuditService auditService;

	public void getKeywordHost(final HttpServletRequest request, AuditRequestVO auditVo){
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));

		StringBuffer info = new StringBuffer();

		info.append("[").append("HOST TOP 10 ").append(Prop.propFormat("common.msg.search")).append("]");
		info.append("┌").append(Prop.propFormat("condition.period")).append(": ").append(startDate).append(" ~ ").append(endDate);
		info.append("┌").append(Prop.propFormat("keyword.msg.coreKeyword")).append(": ").append(coreKeyword);


		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);

	}

	public void getKeywordUrl(final HttpServletRequest request, AuditRequestVO auditVo){

		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		String hosts = Common.nvl(request.getParameter("hosts"));

		StringBuffer info = new StringBuffer();

		info.append("[").append("PATH TOP 20 ").append(Prop.propFormat("common.msg.search")).append("]");
		info.append("┌").append(Prop.propFormat("condition.period")).append(": ").append(startDate).append(" ~ ").append(endDate);
		info.append("┌").append(Prop.propFormat("keyword.msg.coreKeyword")).append(": ").append(coreKeyword);
		info.append("┌").append("HOST").append(": ").append(hosts);


		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);


	}

	public void getKeywordDetail(final HttpServletRequest request, AuditRequestVO auditVo){

		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		String hosts = Common.nvl(request.getParameter("hosts"));
		String paths = Common.nvl(request.getParameter("paths"));

		StringBuffer info = new StringBuffer();

		info.append("[").append(Prop.propFormat("DATA_ANALYSIS.STAT_KEYWORD_TOP")).append(Prop.propFormat("common.msg.search")).append("]");
		info.append("┌").append(Prop.propFormat("condition.period")).append(": ").append(startDate).append(" ~ ").append(endDate);
		info.append("┌").append(Prop.propFormat("keyword.msg.coreKeyword")).append(": ").append(coreKeyword);
		info.append("┌").append("HOSTS").append(": ").append(hosts);
		info.append("┌").append("PATH").append(": ").append(paths);


		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}

	public void getKeywordDetailData(final HttpServletRequest request, AuditRequestVO auditVo){

		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		String hosts = Common.nvl(request.getParameter("hosts"));
		String paths = Common.nvl(request.getParameter("paths"));

		StringBuffer info = new StringBuffer();

		info.append("[").append(Prop.propFormat("DATA_ANALYSIS.STAT_KEYWORD_DETAIL_TOP")).append(Prop.propFormat("common.msg.search")).append("]");
		info.append("┌").append(Prop.propFormat("condition.period")).append(": ").append(startDate).append(" ~ ").append(endDate);
		info.append("┌").append(Prop.propFormat("keyword.msg.coreKeyword")).append(": ").append(coreKeyword);
		info.append("┌").append("HOSTS").append(": ").append(hosts);
		info.append("┌").append("PATH").append(": ").append(paths);


		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}


}
