package com.xcurenet.emass.filter.log;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.filter.service.PatternExceptVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class PatternExceptControllerLog {
	@Autowired
	private AuditService auditService;

	public void getPatternExceptList(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String regex = Common.nvl(param.get("regex")).equals("") ? "" : Common.nvl(param.get("regex"));

		auditVo.setInformation("["+ Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("common.msg.tab")+": " + Prop.propFormat("common.msg.regexp") + "┌"+Prop.propFormat("bodyview.info.pattern")+": " + regex + "┌"+Prop.propFormat("condition.search_str")+": " + searchStr);

		auditService.insertAudit(request, auditVo);
	}

	public void insertPatternExcept(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String regex =Common.nvl(param.get("regex"));
		String pattern = Common.nvl(param.get("pattern"));

		auditVo.setInformation("["+Prop.propFormat("common.msg.add")+"]┌"+Prop.propFormat("common.msg.tab")+": " + Prop.propFormat("common.msg.regexp") + "┌"+ Prop.propFormat("bodyview.info.pattern") +": " + regex+ "┌"+ Prop.propFormat("patternExpect.pattern.info") +": " +pattern);

		auditService.insertAudit(request, auditVo);
	}

	public void updatePatternExcept(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String regex =Common.nvl(param.get("regex"));
		String pattern = Common.nvl(param.get("pattern"));

		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]┌"+Prop.propFormat("common.msg.tab")+": " + Prop.propFormat("common.msg.regexp") + "┌"+  Prop.propFormat("bodyview.info.pattern")+": "  +  regex+ "┌"+ Prop.propFormat("patternExpect.pattern.info") +": " +pattern);

		auditService.insertAudit(request, auditVo);
	}

	public void deletePatternExcept(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String deleteData = Common.nvl(param.get("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);

		for (int i = 0; i < data.size(); i++) {
			PatternExceptVO filter = (PatternExceptVO) JSONObject.toBean(data.getJSONObject(i), PatternExceptVO.class);

			auditVo.setInformation("["+Prop.propFormat("common.msg.delete")+"]┌"+Prop.propFormat("common.msg.tab")+": " + Prop.propFormat("common.msg.regexp")  + "┌"+  Prop.propFormat("bodyview.info.pattern") +": " + filter.getPrivateType()+ "┌"+ Prop.propFormat("patternExpect.pattern.info") +": " + filter.getPattern());
			auditService.insertAudit(request, auditVo);
		}
	}
}
