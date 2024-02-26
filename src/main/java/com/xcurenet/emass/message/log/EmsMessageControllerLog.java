package com.xcurenet.emass.message.log;


import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.message.service.EmsMessageService;
import com.xcurenet.emass.message.service.EmsMessageVO;
import com.xcurenet.emass.message.service.EmsReDefined;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
@Slf4j
public class EmsMessageControllerLog {

	private static final String ENTER = "┌";

	@Autowired
	private AuditService auditService;

	@Autowired
	public EmsMessageService emsMessageService;

	public void emassMailForward(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String xRootMtr = Common.nvl(param.get("xRootMtr"));
		String msgId = Common.nvl(param.get("msgId"));
		String subject = Common.nvl(param.get("subject"));
		String from = Common.nvl(param.get("from"));
		String to = Common.nvl(param.get("to"));
		String cc = Common.nvl(param.get("cc"));

		StringBuffer info = new StringBuffer();
		info.append("["+Prop.propFormat("common.msg.forward_mail")+"]").append(ENTER);
		if( Common.isEmpty(msgId)) info.append(Prop.propFormat("condition.xrootmtr") + " : ").append(xRootMtr).append(ENTER);
		else info.append(""+Prop.propFormat("common.msg.msgid")+" : ").append(msgId).append(ENTER);

		if( Common.isNotEmpty(subject)) info.append(Prop.propFormat("condition.subject") + " : ").append(subject).append(ENTER);
		if( Common.isNotEmpty(from)) info.append(Prop.propFormat("mail.sender") + " : ").append(from).append(ENTER);
		if( Common.isNotEmpty(to)) info.append(Prop.propFormat("condition.to") + " : ").append(to).append(ENTER);
		if( Common.isNotEmpty(cc)) info.append(Prop.propFormat("condition.cc") + " : ").append(cc).append(ENTER);
		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}

	public void emassWarningMail(final HttpServletRequest request, AuditRequestVO auditVo)  {
		JSONObject param = Common.getParam(request);
		String xRootMtr = Common.nvl(param.get("xRootMtr"));
		String msgId = Common.nvl(param.get("msgId"));
		String subject = Common.nvl(param.get("subject"));
		String from = Common.nvl(param.get("from"));
		String to = Common.nvl(param.get("to"));
		String cc = Common.nvl(param.get("cc"));

		StringBuffer info = new StringBuffer();
		info.append("["+Prop.propFormat("common.msg.warning_mail")+"]").append(ENTER);
		if( Common.isEmpty(msgId)) info.append(Prop.propFormat("condition.xrootmtr") + " : ").append(xRootMtr).append(ENTER);
		else info.append(""+Prop.propFormat("common.msg.msgid")+" : ").append(msgId).append(ENTER);

		if( Common.isNotEmpty(subject)) info.append(Prop.propFormat("condition.subject") + " : ").append(subject).append(ENTER);
		if( Common.isNotEmpty(from)) info.append(Prop.propFormat("mail.sender") + " : ").append(from).append(ENTER);
		if( Common.isNotEmpty(to)) info.append(Prop.propFormat("condition.to") + " : ").append(to).append(ENTER);
		if( Common.isNotEmpty(cc)) info.append(Prop.propFormat("condition.cc") + " : ").append(cc).append(ENTER);
		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}




	public void getEmassMessageSaveZip(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String searchType = Common.nvl(param.get("searchType"));
		String exportFileExt = Common.nvl(param.get("exportFileExt"));

		String title = "";
		if( Common.isEquals(searchType, "L")){
			if(Common.isEquals(exportFileExt, "xlsx")) {
				title = Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.excel")+" xlsx)";
			} else if(Common.isEquals(exportFileExt, "cell")) {
				title = Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.hancel")+" cell)";
			}
		} else if( Common.isEquals(searchType, "B")){
			title = Prop.propFormat("condition.body");
		} else if( Common.isEquals(searchType, "A")){
			title = Prop.propFormat("consent.attach");
		} else if( Common.isEquals(searchType, "LB")){
			if(Common.isEquals(exportFileExt, "xlsx")) {
				title = Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.excel")+" xlsx)+" + Prop.propFormat("condition.body");
			} else if(Common.isEquals(exportFileExt, "cell")) {
				title = Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.hancel")+" cell)+" + Prop.propFormat("condition.body");
			}
		} else if( Common.isEquals(searchType, "LBA")){
			if(Common.isEquals(exportFileExt, "xlsx")) {
				title = Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.excel")+" xlsx)+" + Prop.propFormat("condition.body") + "+" +Prop.propFormat("consent.attach");
			} else if(Common.isEquals(exportFileExt, "cell")) {
				title = Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.hancel")+" cell)+" + Prop.propFormat("condition.body")+ "+" +Prop.propFormat("consent.attach");
			}
		}

		StringBuffer info = new StringBuffer();
		info.append("["+Prop.propFormat("common.msg.export")+"]").append(ENTER);
		info.append(title).append(ENTER);

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}

	public void getEmassMessageSavePDF(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String searchType = Common.nvl(param.get("searchType"));

		String title = "";
		if( Common.isEquals(searchType, "L")){
			title = Prop.propFormat("selectCodeAll.list")+" (pdf)";
		} else if( Common.isEquals(searchType, "LB")){
			title = Prop.propFormat("selectCodeAll.list")+" (pdf)+"+ Prop.propFormat("condition.body");
		} else if( Common.isEquals(searchType, "LBA")){
			title = Prop.propFormat("selectCodeAll.list")+" (pdf)+" + Prop.propFormat("condition.body") + "+" +Prop.propFormat("consent.attach");
		}

		StringBuffer info = new StringBuffer();
		info.append("["+Prop.propFormat("common.msg.export")+"]").append(ENTER);
		info.append(title).append(ENTER);

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}

	public void getEmassMessageSaveCSV(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String searchType = Common.nvl(param.get("searchType"));

		String title = "";
		if( Common.isEquals(searchType, "L")){
			title = Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.text")+" csv)";
		} else if( Common.isEquals(searchType, "LB")){
			title = Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.text")+" csv)+" + Prop.propFormat("condition.body");
		} else if( Common.isEquals(searchType, "LBA")){
			title = Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.text")+" csv)+" + Prop.propFormat("condition.body") + "+" +Prop.propFormat("consent.attach");
		}

		StringBuffer info = new StringBuffer();
		info.append("["+Prop.propFormat("common.msg.export")+"]").append(ENTER);
		info.append(title).append(ENTER);

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}


	public void getEmassBodyStr(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String msgId = Common.nvl(param.get("msgId"));

		String menuId = Common.nvl(param.get("menuId"));
		String pMenuId = Common.nvl(param.get("pMenuId"));

		EmsMessageVO msg = emsMessageService.getEmassMessage ( msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));
		String subject = EmsReDefined.reSubject(msg);
		StringBuffer info = new StringBuffer();

		info.append("["+Prop.propFormat("common.msg.view.body")+"]").append(ENTER);
		info.append(""+Prop.propFormat("condition.subject")+" : ").append(subject).append(ENTER);
		info.append(""+Prop.propFormat("common.msg.msgid")+" : ").append(msgId).append(ENTER);

		auditVo.setInformation(info.toString());

		auditVo.setMenuId(menuId);
		auditVo.setPMenuId(pMenuId);
		auditService.insertAudit(request, auditVo);
	}

	public void getEmassBodySaveZip(final HttpServletRequest request, AuditRequestVO auditVo) {
		StringBuffer info = new StringBuffer();
		info.append("["+Prop.propFormat("common.msg.export")+"]").append(ENTER);
		info.append(Prop.propFormat("condition.body")).append(ENTER);

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}

	public void getEmassHeaderDown(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String msgId = Common.nvl(param.get("msgId"));
		EmsMessageVO msg = emsMessageService.getEmassMessage ( msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()) );
		String subject = EmsReDefined.reSubject(msg);
		StringBuffer info = new StringBuffer();

		info.append("["+Prop.propFormat("common.msg.save.header")+"]").append(ENTER);
		info.append(""+Prop.propFormat("condition.subject")+" : ").append(subject).append(ENTER);
		info.append(""+Prop.propFormat("common.msg.msgid")+" : ").append(msgId).append(ENTER);

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}

	public void getEmassOriginalBodyDown(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String msgId = Common.nvl(param.get("msgId"));
		EmsMessageVO msg = emsMessageService.getEmassMessage ( msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()) );
		String subject = EmsReDefined.reSubject(msg);
		StringBuffer info = new StringBuffer();

		info.append("["+Prop.propFormat("common.msg.save.original")+"]").append(ENTER);
		info.append(""+Prop.propFormat("condition.subject")+" : ").append(subject).append(ENTER);
		info.append(""+Prop.propFormat("common.msg.msgid")+" : ").append(msgId).append(ENTER);

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}

	public void downEmassAttachByMsgId(final HttpServletRequest request, AuditRequestVO auditVo) {
		StringBuffer info = new StringBuffer();
		info.append("["+Prop.propFormat("common.msg.export")+"]").append(ENTER);
		info.append(Prop.propFormat("consent.attach")).append(ENTER);

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);

	}

	public void getMessageGroupDetail(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String xRootMtr = Common.nvl(param.get("xRootMtr"));
		StringBuffer info = new StringBuffer();
		info.append("[" + Prop.propFormat("java.log.messenger.group.detail") + "]").append(ENTER);
		info.append(Prop.propFormat("condition.xrootmtr") + " : ").append(xRootMtr).append(ENTER);
		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}

}
