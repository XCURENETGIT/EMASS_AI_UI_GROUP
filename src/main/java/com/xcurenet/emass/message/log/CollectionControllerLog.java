package com.xcurenet.emass.message.log;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.code.service.CodeVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.message.service.EmsMessageService;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;


@Component
@Slf4j
public class CollectionControllerLog {

	@Autowired
	private AuditService auditService;

	@Autowired
	private EmsMessageService emsMessageService;

	private static final String ENTER = "┌";


	public void getCollectionGroupList(final HttpServletRequest request, AuditRequestVO auditVo) {


		JSONObject param = Common.getParam(request);
		JSONObject filterVal = Common.toJSONObject(param.get("data"));
		StringBuffer info = new StringBuffer();
		if (Common.nvl(param.get("type")).equals("G")) {
			auditVo.setMenuId("GENERATIVEAI_SERVICE");
			info.append("[" + Prop.propFormat("java.log.generative.group.search") + "]").append(ENTER);
		}else {
			auditVo.setMenuId("NOTE_SERVICE");
			info.append("[" + Prop.propFormat("java.log.note.group.search") + "]").append(ENTER);
		}
		try {
			JSONArray conditions = filterVal.getJSONArray("conditions");
			for (int i = 0; i < conditions.size(); i++) {
				JSONObject condition = conditions.getJSONObject(i);

				if (Common.isNotEmpty(condition.get("serviceType"))) {
					List<CodeVO> messenger=new ArrayList<>();
					if (Common.nvl(param.get("type")).equals("G")) {
						 messenger = emsMessageService.getGenerativeList();
					}
					else{
						 messenger = emsMessageService.getNoteList();
					}

					String[] serviceTypes = Common.toArray(Common.nvl(condition.get("serviceType")), ",");

					if (messenger.size() != serviceTypes.length) {
						String serviceNm = Config.getServiceLv12Nm(serviceTypes[0]);
						String addInfo = "";
						if (serviceTypes.length > 1)
							addInfo = " " + Prop.propFormat("common.msg.etc_count", serviceTypes.length - 1) + ".";
						info.append(Prop.propFormat("condition.service") + " : ").append(serviceNm).append(addInfo).append(ENTER);
					}
				}

				if (Common.isNotEmpty(condition.get("searchStr")))
					info.append(Prop.propFormat("condition.search_str") + " : ").append(Common.nvl(condition.get("searchStr"))).append(ENTER);

				String startDt = Common.formatDate3(Common.nvl(condition.get("startDt") + "000000"));
				String endDt = Common.formatDate3(Common.nvl(condition.get("endDt")));
				info.append(Prop.propFormat("condition.period") + " : ").append(startDt).append(" ~ ").append(endDt).append(ENTER);

				if (Common.isNotEmpty(condition.get("senders")))
					info.append(Prop.propFormat("condition.participation") + " : ").append(Common.nvl(condition.get("senders"))).append(ENTER);

				if (Common.isNotEmpty(condition.get("busi"))) {
					info.append(Prop.propFormat("common.org.busi") + " : ").append(Common.nvl(condition.get("busiStr"))).append(ENTER);
				}
				if (Common.isNotEmpty(condition.get("dept"))) {
					info.append(Prop.propFormat("common.org.dept") + " : ").append(Common.nvl(condition.get("deptStr"))).append(ENTER);
				}

				if (Common.isNotEmpty(condition.get("attachYn"))) {
					info.append(Prop.propFormat("condition.isattached") + " : ");
					if (Common.isEquals(condition.get("attachYn"), "Y")) {
						info.append(Prop.propFormat("condition.exist")).append(ENTER);
						if (Common.isNotEmpty(condition.get("attachVal"))) {
							info.append(Prop.propFormat("java.log.selected.attach") + " : ").append(Common.nvl(condition.get("attachVal")).replaceAll("\\|", ",")).append(ENTER);
						}
					} else if (Common.isEquals(condition.get("attachYn"), "N"))
						info.append(Prop.propFormat("condition.none")).append(ENTER);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		auditVo.setInformation(info.toString());

		auditService.insertAudit(request, auditVo);
	}

	public void getFileMessageList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		JSONObject filterVal = Common.toJSONObject(param.get("data"));
		StringBuffer info = new StringBuffer();
		auditVo.setMenuId("FILETRANSFER_SERVICE");

			info.append("[" + Prop.propFormat("java.log.file.group.search") + "]").append(ENTER);
		try {
			JSONArray conditions = filterVal.getJSONArray("conditions");
			for (int i = 0; i < conditions.size(); i++) {
				JSONObject condition = conditions.getJSONObject(i);

				if (Common.isNotEmpty(condition.get("serviceType"))) {
					List<CodeVO> messenger= emsMessageService.getFileServiceList();

					String[] serviceTypes = Common.toArray(Common.nvl(condition.get("serviceType")), ",");

					if (messenger.size() != serviceTypes.length) {
						String serviceNm = Config.getServiceLv12Nm(serviceTypes[0]);
						String addInfo = "";
						if (serviceTypes.length > 1)
							addInfo = " " + Prop.propFormat("common.msg.etc_count", serviceTypes.length - 1) + ".";
						info.append(Prop.propFormat("condition.service") + " : ").append(serviceNm).append(addInfo).append(ENTER);
					}
				}

				if (Common.isNotEmpty(condition.get("searchStr")))
					info.append(Prop.propFormat("condition.search_str") + " : ").append(Common.nvl(condition.get("searchStr"))).append(ENTER);

				String startDt = Common.formatDate3(Common.nvl(condition.get("startDt") + "000000"));
				String endDt = Common.formatDate3(Common.nvl(condition.get("endDt")));
				info.append(Prop.propFormat("condition.period") + " : ").append(startDt).append(" ~ ").append(endDt).append(ENTER);

				if (Common.isNotEmpty(condition.get("senders")))
					info.append(Prop.propFormat("condition.participation") + " : ").append(Common.nvl(condition.get("senders"))).append(ENTER);

				if (Common.isNotEmpty(condition.get("busi"))) {
					info.append(Prop.propFormat("common.org.busi") + " : ").append(Common.nvl(condition.get("busiStr"))).append(ENTER);
				}
				if (Common.isNotEmpty(condition.get("dept"))) {
					info.append(Prop.propFormat("common.org.dept") + " : ").append(Common.nvl(condition.get("deptStr"))).append(ENTER);
				}

				if (Common.isNotEmpty(condition.get("attachYn"))) {
					info.append(Prop.propFormat("condition.isattached") + " : ");
					if (Common.isEquals(condition.get("attachYn"), "Y")) {
						info.append(Prop.propFormat("condition.exist")).append(ENTER);
						if (Common.isNotEmpty(condition.get("attachVal"))) {
							info.append(Prop.propFormat("java.log.selected.attach") + " : ").append(Common.nvl(condition.get("attachVal")).replaceAll("\\|", ",")).append(ENTER);
						}
					} else if (Common.isEquals(condition.get("attachYn"), "N"))
						info.append(Prop.propFormat("condition.none")).append(ENTER);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}


	public void getGenerativeMessage(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String userid = Common.nvl(param.get("userid"));
		StringBuffer info = new StringBuffer();
		if (Common.nvl(param.get("type")).equals("G")) {
			auditVo.setMenuId("GENERATIVEAI_SERVICE");
			info.append("[" + Prop.propFormat("java.log.generative.group.detail") + "]").append(ENTER);
		}else{
			auditVo.setMenuId("NOTE_SERVICE");
			info.append("[" + Prop.propFormat("java.log.note.group.detail") + "]").append(ENTER);
		}
		info.append(Prop.propFormat("condition.userid") + " : ").append(userid).append(ENTER);
		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}

	public void getGenerativeGroupDetailSearch(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		JSONObject filterVal = Common.toJSONObject(param.get("data"));
		String userid = Common.nvl(param.get("userid"));
		StringBuffer info = new StringBuffer();
		if (Common.nvl(param.get("type")).equals("G")) {
			auditVo.setMenuId("GENERATIVEAI_SERVICE");
			info.append("[" + Prop.propFormat("java.log.generative.group.msg.search") + "]").append(ENTER);
		}else{
			auditVo.setMenuId("NOTE_SERVICE");
			info.append("[" + Prop.propFormat("java.log.note.group.msg.search") + "]").append(ENTER);
		}
		info.append(Prop.propFormat("condition.userid") + " : ").append(userid).append(ENTER);
		try {
			JSONArray conditions = filterVal.getJSONArray("conditions");
			for (int i = 0; i < conditions.size(); i++) {
				JSONObject condition = conditions.getJSONObject(i);

				if (Common.isNotEmpty(condition.get("searchStr"))) info.append(Prop.propFormat("condition.search_str") + " : ").append(Common.nvl(condition.get("searchStr"))).append(ENTER);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}

	public void getCollectionrGroupTextExport(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String userid = Common.nvl(param.get("userid"));

		StringBuffer info = new StringBuffer();if (Common.nvl(param.get("type")).equals("G")) {
			auditVo.setMenuId("GENERATIVEAI_SERVICE");
			info.append("[" + Prop.propFormat("java.log.generative.export") + "]").append(ENTER);
		}else{
			auditVo.setMenuId("NOTE_SERVICE");
			info.append("[" + Prop.propFormat("java.log.note.export") + "]").append(ENTER);
		}
		info.append(Prop.propFormat("condition.userid") + " : ").append(userid).append(ENTER);

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}

	public void getCollectionGroupAllExport(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String userid = Common.nvl(param.get("userid"));

		StringBuffer info = new StringBuffer();
		if (Common.nvl(param.get("type")).equals("G")) {
			auditVo.setMenuId("GENERATIVEAI_SERVICE");
			info.append("[" + Prop.propFormat("java.log.generative.export") + "]").append(ENTER);
		}
		else{
			auditVo.setMenuId("NOTE_SERVICE");
			info.append("[" + Prop.propFormat("java.log.note.export") + "]").append(ENTER);
		}
		info.append(Prop.propFormat("condition.userid") + " : ").append(userid).append(ENTER);

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}



}
