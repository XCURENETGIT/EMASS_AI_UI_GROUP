package com.xcurenet.recommend.log;


import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class SimilarityControllerLog {

	@Autowired
	private AuditService auditService;

	public void getSimilarity(final HttpServletRequest request, AuditRequestVO auditVo)  {

		JSONObject param = Common.getParam(request);
		JSONObject filterVal = Common.toJSONObject(param.get("data"));
		StringBuffer info = new StringBuffer();

		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		int percent = Common.nvz(request.getParameter("percent"));
		String similarityText = Common.nvl(param.get("similarityText"));
		String tab = Common.nvl(param.get("tab"));



		info.append("[").append(Prop.propFormat("common.msg.search")).append("]");
		info.append("┌").append(Prop.propFormat("condition.period")).append(": ").append(startDate).append(" ~ ").append(endDate);
		info.append("┌").append(Prop.propFormat("condition.info.similarity")).append(": ").append(percent).append("%~");
		info.append("┌").append(Prop.propFormat("condition.info.similarity")).append(Prop.propFormat("similarityText.text.type")).append(": ").append(similarityText);

		if (Common.isEmpty(tab) || Common.isEquals(tab, "allTab")){
			info.append("┌").append(Prop.propFormat("java.log.type.search")).append(": ").append(Prop.propFormat("common.msg.all"));
		}
		else if (Common.isEquals(tab, "subjectTab")){
			info.append("┌").append(Prop.propFormat("java.log.type.search")).append(": ").append(Prop.propFormat("filterInfo.subject"));
		}
		else if (Common.isEquals(tab, "bodyTab")){
			info.append("┌").append(Prop.propFormat("java.log.type.search")).append(": ").append(Prop.propFormat("condition.body"));
		}else if (Common.isEquals(tab, "fileTab")){
			info.append("┌").append(Prop.propFormat("java.log.type.search")).append(": ").append(Prop.propFormat("condition.attach"));
		}


		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);

	}

}
