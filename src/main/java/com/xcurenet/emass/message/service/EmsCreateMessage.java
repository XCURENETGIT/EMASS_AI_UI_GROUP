package com.xcurenet.emass.message.service;

import com.xcurenet.common.image.ImageUtils;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.message.web.EmsAttachDownload;
import lombok.extern.log4j.Log4j2;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Log4j2
public class EmsCreateMessage {

	public EmsMessageService emsMessageService;

	public ConfigAdminService configAdminService;

	private final Locale locale;

	public boolean infoFeedbackConf;

	public String infoFeedbackYn;

	public EmsCreateMessage(HttpServletRequest request) {
		this(Common.getLocale(request.getSession()));

		infoFeedbackYn = Common.getInfoFeedbackYn(request.getSession());
		infoFeedbackConf = Config.getBoolean("info.feedback.used");
	}

	public EmsCreateMessage(Locale locale) {
		emsMessageService = SpringContextUtil.getBean(EmsMessageService.class);
		configAdminService = SpringContextUtil.getBean(ConfigAdminService.class);
		this.locale = locale;
	}

	public String getHeaderMessage(String msgId, String body, String print, Locale locale, String firstAdminYn, String adminId, String adminType) {
		return getHeaderMessage(msgId, body, print, locale, firstAdminYn, null, adminId, adminType);
	}

	public String getHeaderMessage(String msgId, String body, String print, Locale locale, String firstAdminYn, MessengerGroupUserVO participants, String adminId, String adminType) {
		try (InputStream is = getClass().getResourceAsStream("../../../files/headerTable.html");
			BufferedReader in = new BufferedReader(new InputStreamReader(is, Common.UTF8));){
			return mappingHeader(msgId, in, body, print, locale, firstAdminYn, participants, adminId, adminType);
		} catch (IOException e) {
			log.error("", e);
		}
		return null;
	}

	private String mappingHeader(String msgId, BufferedReader in, String body, String print, Locale locale, String firstAdminYn, MessengerGroupUserVO participants, String adminId, String adminType) {
		try {
			EmsMessageVO msg = emsMessageService.getEmassMessage(msgId, firstAdminYn, adminType);
			if (msg == null) {
				msg = new EmsMessageVO();
			}

			List<EmsKeywordVO> emsKeywordVOList = null;
			String attachStr = "";
			String fileNameStr = "";
			String subjectStr = "";
			String bodyStr = "";
			StringBuilder userStr = new StringBuilder();
			StringBuilder senderStr = new StringBuilder();
			StringBuilder toStr = new StringBuilder();
			StringBuilder ccStr = new StringBuilder();
			StringBuilder bccStr = new StringBuilder();
			String participantStr = "";
			List<EmsRecvVO> user = new ArrayList<>();
			List<EmsRecvVO> sender = new ArrayList<>();
			List<EmsRecvVO> recvs = new ArrayList<>();
			List<EmsRecvVO> to = new ArrayList<>();
			List<EmsRecvVO> cc = new ArrayList<>();
			List<EmsRecvVO> bcc = new ArrayList<>();



			sender=msg.getSenderList();
			to = msg.getToList();
			cc = msg.getCcList();
			bcc = msg.getBccList();

			String svcnm = Common.nvl(Config.getServiceNm(msg.getSvc()));
			String protocolNm = Config.getProtocolNm(msg.getProtocol());
			if( Common.isNotEmpty(protocolNm)) svcnm += " [" + protocolNm+"]";
			String subject = EmsReDefined.reSubject(msg);
			String ipBusiNm = msg.getIpBusiNm();
			String ipDeptNm = msg.getIpDeptNm();
//			String ipBusiNm = emsMessageService.getIpBusiNm(msg.getIpBusicd());
//			String ipDeptNm = emsMessageService.getIpDeptNm(msg.getIpDeptcd());

			if( participants == null){
				if (Common.isEquals(msg.getKwd(), "Y")) {
					emsKeywordVOList = emsMessageService.getEmassKeyword(msgId);
					for (int i = 0; i < emsKeywordVOList.size(); i++) {
						EmsKeywordVO emsKeywordVO = emsKeywordVOList.get(i);
						String type = emsKeywordVO.getType();
						if (Common.isEquals(type, "A")) attachStr += emsKeywordVO.getKeyword() + ", ";
						else if (Common.isEquals(type, "F")) fileNameStr += emsKeywordVO.getKeyword() + ", ";
						else if (Common.isEquals(type, "S")) subjectStr += emsKeywordVO.getKeyword() + ", ";
						else if (Common.isEquals(type, "B")) bodyStr += emsKeywordVO.getKeyword() + ", ";
					}

					if (!attachStr.isEmpty()) attachStr = attachStr.substring(0, attachStr.length() - 2);
					if (!fileNameStr.isEmpty()) fileNameStr = fileNameStr.substring(0, fileNameStr.length() - 2);
					if (!subjectStr.isEmpty()) subjectStr = subjectStr.substring(0, subjectStr.length() - 2);
					if (!bodyStr.isEmpty()) bodyStr = bodyStr.substring(0, bodyStr.length() - 2);
				}

				List<EmsRecvVO> users = emsMessageService.getEmassUserInfo(msgId);

				for (EmsRecvVO emsRecvVO : users) {
					EmsRecvVO u = EmsReDefined.reUserIp(emsRecvVO, Common.nvl(msg.getSrcIp()), Common.nvl(msg.getDstIp()), Common.nvl(msg.getUsrIp()));
					if (Common.isEquals(u.getUType(), "U")) {
						u.setEMail(EmsReDefined.reUserEmail(emsRecvVO, Common.nvl(msg.getUser())));
						user.add(u);
					} else if (Common.isEquals(u.getUType(), "F")) {
						u.setEMail(EmsReDefined.reUserEmail(emsRecvVO, Common.nvl(msg.getSender())));
						sender.add(u);
					} else if (Common.isEquals(u.getUType(), "T")) {
						u.setEMail(EmsReDefined.reUserEmail(emsRecvVO));
						recvs.add(u);
						to.add(u);
					} else if (Common.isEquals(u.getUType(), "C")) {
						u.setEMail(EmsReDefined.reUserEmail(emsRecvVO));
						recvs.add(u);
						cc.add(u);
					} else if (Common.isEquals(u.getUType(), "B")) {
						u.setEMail(EmsReDefined.reUserEmail(emsRecvVO));
						recvs.add(u);
						bcc.add(u);
					}
				}

			}else{
				for (SolrEdcVO participant : participants.getGroups()) {
					String name = Common.isEmpty(participant.getName()) ? participant.getUsr_id() : participant.getName();
					//participantStr += String.format("%s["+Prop.propFormat("common.org.co", locale)+":%s, "+Prop.propFormat("common.org.busi", locale)+":%s, "+Prop.propFormat("common.org.dept", locale)+":%s, "+Prop.propFormat("common.org.jikgub", locale)+":%s]", name, Common.nvl(participant.getConm()), Common.nvl(participant.getBusinm()), Common.nvl(participant.getDeptnm()), Common.nvl(participant.getJikgubnm())) + Common.EMPTY_LINE;
					if(Common.isNotEmpty(name)) participantStr += name + Common.EMPTY_LINE;
					else participantStr += String.format("%s", participant.getSrcip()) + Common.EMPTY_LINE;
				}
			}

			List<EmsAttachVO> files = emsMessageService.getEmassAttachInfoConsent(msgId, null, adminType);
			boolean hasOcr = false;

			if(Config.isOCR) {
				for (EmsAttachVO file : files) {
					if (Common.isEquals(file.getOcrYn(), "Y")) {
						hasOcr = true;
						break;
					}
				}
			}

			List<EmsPiVO> pattern = emsMessageService.getEmassPattern(msgId);

			ConfigAdminVO configAdminVO = configAdminService.getConfAdmin(Config.USER_FORMAT, adminId);
			if(configAdminVO == null || Common.isEmpty(configAdminVO.getVal())) {
				configAdminVO = new ConfigAdminVO();
				configAdminVO.setVal(Config.getString(Config.USER_FORMAT, "#name#/#email#/#businm#/#deptnm#/#jikgubnm#/#ip#"));
			}
			String formatval = configAdminVO.getVal();
			for (EmsRecvVO u : user) {
				userStr.append(makeUserHtml(u, formatval));
			}

			for (EmsRecvVO u : sender) {
				senderStr.append(makeUserHtml(u, formatval));
			}

			for (EmsRecvVO u : to) {
				toStr.append(makeUserHtml(u, formatval));
				toStr.append("; ");
			}

			for (EmsRecvVO u : cc) {
				ccStr.append(makeUserHtml(u, formatval));
				ccStr.append("; ");
			}

			for (EmsRecvVO u : bcc) {
				bccStr.append(makeUserHtml(u, formatval));
				bccStr.append("; ");
			}

			String[] keys = {"#emass_body_view#", "#emass_subject_keyword#", "#emass_title_srcip#", "#emass_title_date#", "#emass_title_dstip#", "#emass_title_size#",
					"#emass_title_user#", "#emass_title_account#", "#emass_title_from#", "#emass_title_to#", "#emass_title_cc#", "#emass_title_bcc#", "#emass_title_ipBusiNm#","#emass_title_ipDeptNm#",
					"#emass_title_fileinfo#", "#emass_attach_keyword#", "#emass_attachname_keyword#", "#emass_title_pattern#", "#emass_title_bodycontent#",
					"#emass_body_keyword#", "#emass_subject#", "#emass_subject_kwd#", "#emass_svcnm#", "#emass_src_ip#", "#emass_ctime#", "#emass_dst_ip#",
					"#emass_size#", "#emass_usrid#", "#emass_recvs#", "#emass_senders#", "#emass_to#", "#emass_cc#", "#emass_bcc#", "#emass_ipBusiNm#","#emass_ipDeptNm#", "#emass_host#", "#emass_attach_kwd#",
					"#emass_fileName_kwd#", "#emass_file#", "#emass_body_kwd#", "#emass_pattern#","#emass_title_participant#","#emass_participant#","#emass_title_xrootmtr#","#emass_xrootmtr#",
					"emass_title_ocr#", "#emass_ocr#", "#ml_confd_class#", "#ml_confd_feedback#", "#ml_confd_prob#", "#ml_confd_class_bg_color#", "#ml_confd_userid#","#emass_title_epmsg_type#","#emass_epmsg_type#"};

			String[] vals = {Prop.propFormat("OPERATION_MGMT.BODY_VIEW", locale), Prop.propFormat("condition.subject", locale)+" "+Prop.propFormat("bodyview.find.keyword", locale),
					Prop.propFormat("condition.source", locale)+" IP", Prop.propFormat("condition.date", locale), Prop.propFormat("condition.destination", locale)+" IP",
					Prop.propFormat("filterInfo.size", locale), Prop.propFormat("consent.user", locale), Prop.propFormat("common.msg.account", locale),
					Prop.propFormat("condition.from", locale), Prop.propFormat("condition.to", locale), Prop.propFormat("condition.cc", locale),
					Prop.propFormat("condition.bcc", locale), Prop.propFormat("message.actual.business", locale), Prop.propFormat("message.actual.dept", locale), Prop.propFormat("bodyview.file_info", locale), Prop.propFormat("bodyview.attach", locale)+" "+Prop.propFormat("bodyview.find.keyword", locale),
					Prop.propFormat("condition.attach_name", locale)+" "+Prop.propFormat("bodyview.find.keyword", locale), Prop.propFormat("bodyview.info.pattern", locale),
					Prop.propFormat("bodyview.body.content", locale), Prop.propFormat("condition.body", locale)+" "+Prop.propFormat("bodyview.find.keyword", locale),
					subject, subjectStr, svcnm, Common.nvl(msg.getSrcIp()), Common.nvl(msg.getCtime()), Common.nvl(msg.getDstIp()), Common.nvl(Common.convertFileSize(msg.getBodySize())),
					Common.nvl(msg.getUsrId()), userStr.toString(), senderStr.toString(), toStr.toString(), ccStr.toString(), bccStr.toString(), Common.nvl(ipBusiNm),Common.nvl(ipDeptNm), Common.nvl(msg.getHost())+Common.nvl(msg.getPath())+Common.nvl(msg.getQuery()), attachStr, fileNameStr, getFileHtml(files), bodyStr, getPatternHtml(pattern, locale),
					Prop.propFormat("condition.participation", locale), participantStr, Prop.propFormat("condition.xrootmtr", locale), msg.getXRootMtr(),
					Prop.propFormat("bodyview.ocr.preview", locale), getOcrHtml(files, hasOcr), getMlConfdClassStr(msg.getMl_confd_class(), locale), getMlConfdFeedbackStr(msg.getMl_confd_feedback(), locale),
					getMlConfdProbPercent(msg.getMl_confd_prob()), getMlConfdClassBgColor(msg.getMl_confd_class()),getMlConfdUseridStr(msg.getMl_confd_userid()),Prop.propFormat("condition.epmsgType.list", locale) ,Common.nvl(msg.getEpmsgType())};

			String tmp = "";
			StringBuffer result = new StringBuffer();
			while ((tmp = in.readLine()) != null) {
				for (int i = 0; i < keys.length; i++) {
					if (tmp.contains(keys[i])) {
						String start = tmp.substring(0, tmp.indexOf(keys[i]));
						String end = tmp.substring(tmp.indexOf(keys[i]) + keys[i].length());
						tmp = start + vals[i] + end;
					}
				}
				result.append(tmp).append("\n");
			}

			Document header_doc = Jsoup.parse(result.toString());


			if(!(infoFeedbackConf && Common.isEquals(infoFeedbackYn, "Y"))) header_doc.getElementById("msgInfoFeedback").remove();

			if (Common.isNotEquals(print, "Y")) header_doc.getElementById("button_area").remove();
			if (Common.isEmpty(subjectStr)) header_doc.getElementById("subjectKwd").remove();
			if (Common.isEmpty(svcnm)) header_doc.getElementById("svcnm").remove();

			if (to.isEmpty()) header_doc.getElementById("msgTo").remove();
			if (cc.isEmpty()) header_doc.getElementById("msgCc").remove();
			if (bcc.isEmpty()) header_doc.getElementById("msgBcc").remove();
			if (Common.isEmpty(msg.getHost())) header_doc.getElementById("msgHost").remove();

			//대외비 있을때만 출력
			if(Common.isEmpty(msg.getEpmsgType())) header_doc.getElementById("msgEpmsgType").remove();

			if (participants == null){
				header_doc.getElementById("msgParticipant").remove();
				header_doc.getElementById("msgXrootMtr").remove();
			}else{
				header_doc.getElementById("msgAccount").remove();
				header_doc.getElementById("msgFrom").remove();
			}

//			if (isMessengerGroup(msg.getSvc(), msg.getXRootMtr())){
//				header_doc.getElementById("msgSrcIp").remove();
//				header_doc.getElementById("msgDstIp").remove();
//				header_doc.getElementById("msgUserAccount").remove();
//			}
//			else{
				if(null != header_doc.getElementById("msgAccount")) header_doc.getElementById("msgAccount").remove();
//			}

			if (files.isEmpty()) header_doc.getElementById("msgFiles").remove();
			else {
				if (Common.isEmpty(attachStr) && null != header_doc.getElementById("attachKwd")) header_doc.getElementById("attachKwd").remove();
				if (Common.isEmpty(fileNameStr) && null != header_doc.getElementById("fileNameKwd")) header_doc.getElementById("fileNameKwd").remove();
			}

			if(!hasOcr && null != header_doc.getElementById("ocrFiles")) header_doc.getElementById("ocrFiles").remove();

			if (Common.isEmpty(bodyStr)) header_doc.getElementById("bodyKwd").remove();
			if (pattern.isEmpty()) header_doc.getElementById("msgPattern").remove();

			Element bodyArea = header_doc.getElementById("bodyArea");

			if (participants == null && isMessengerGroup(msg.getSvc(), msg.getXRootMtr())){
				if(Common.nvl(msg.getSvc()).indexOf("J") == 3) body = Prop.propFormat("common.messenger.join");
				else if(Common.nvl(msg.getSvc()).indexOf("L") == 3) body = Prop.propFormat("common.messenger.leave");
			}
			bodyArea.html(body);
			return header_doc.html();
		} catch (Exception e) {
			log.info("", e);
		}
		return Common.EMPTY;
	}

	private String getMlConfdClassStr(int ml_confd_class, Locale locale) {
		String str = "";
		if(ml_confd_class == 4) str += Prop.propFormat("condition.info.class4", locale);
		else if(ml_confd_class == 3) str += Prop.propFormat("condition.info.class3", locale);
		else if(ml_confd_class == 2) str += Prop.propFormat("condition.info.class2", locale);
		else if(ml_confd_class == 1) str += Prop.propFormat("condition.info.class1", locale);
		else str += Prop.propFormat("common.msg.noinfo", locale);
		return str;
	}

	private String getMlConfdProbPercent(double ml_confd_prob) {
		if( ml_confd_prob == -1 ) return "";
		else return "(" + Math.floor(ml_confd_prob * 100) + "%)";

	}

	private String getMlConfdFeedbackStr(int ml_confd_feedback, Locale locale) {
		String str = "";
		if(ml_confd_feedback == 1) str += Prop.propFormat("condition.info.feedback1", locale);
		else if(ml_confd_feedback == 2) str += Prop.propFormat("condition.info.feedback2", locale);
		else if(ml_confd_feedback == 3) str += Prop.propFormat("condition.info.feedback3", locale);
		else if(ml_confd_feedback == 4) str += Prop.propFormat("condition.info.feedback4", locale);
		else if(ml_confd_feedback == 0) str += Prop.propFormat("condition.info.feedback0", locale);
		else if(ml_confd_feedback == 9) str += Prop.propFormat("condition.info.feedback9", locale);
		else str += Prop.propFormat("condition.info.nofeedback", locale);
		return str;
	}

	//sk 비밀 문서 관련
	private String getSkMlConfdClassStr(int ml_confd_class, Locale locale) {
		String str = "";
		if(ml_confd_class == 1) str += Prop.propFormat("condition.info.Y", locale);
		else if(ml_confd_class == 0) str += Prop.propFormat("condition.info.N", locale);
		else str += Prop.propFormat("common.msg.noinfo", locale);
		return str;
	}

	private String getMlConfdClassBgColor(int ml_confd_class) {
		if( ml_confd_class == 4 ) return "red";
		else if( ml_confd_class == 3 ) return "orange";
		else if( ml_confd_class == 2 ) return "#2393e1";
		else if( ml_confd_class == 1 ) return "#bbb";
		else return "#ccc";
	}

	private String getMlConfdUseridStr(String ml_confd_userid) {
		if( Common.isEmpty(ml_confd_userid)) return "";
		else return "[ " + ml_confd_userid + " ]";
	}

	private String makeUserHtml(EmsRecvVO u, String formatval) {
		StringBuffer sb = new StringBuffer();
		sb.append("<span class=\"");
		if(Common.isEquals(u.getInSide(), "N") && u.getName()!=null) sb.append("userOutside");
		sb.append("\">");
		sb.append(EmsReDefined.reUser(u, formatval));
		sb.append("</span>");

		return sb.toString();
	}

	private boolean isMessengerGroup(String svc, String xRootMtr){
		if (Common.nvl(svc).startsWith("Q") && Common.isNotEmpty(xRootMtr) ) return true;
		else return false;
	}

	private String getFileHtml(List<EmsAttachVO> files) {
		String resultStr = "";
		resultStr += "<table class=\"subTable02 table-bordered\"> ";
		resultStr += "	<colgroup> ";
		resultStr += "		<col width=\"300\"> ";
		resultStr += "		<col width=\"13%\"> ";
		resultStr += "		<col width=\"20%\"> ";
		resultStr += "	</colgroup>	 ";
		resultStr += "	<tr> ";
		resultStr += "		<th>" + Prop.propFormat("bodyview.file.name", locale) + "</th> ";
		resultStr += "		<th>" + Prop.propFormat("message.msg.attach_size", locale) + "</th> ";
		resultStr += "		<th>" + Prop.propFormat("message.msg.pre_ext", locale) + "</th> ";
		resultStr += "	</tr> ";
		for (int i = 0; i < files.size(); i++) {
			EmsAttachVO file = files.get(i);
			boolean checkExt = false;
			String[] ext = Common.toArray(file.getAttachName(), ".");
			if (ext.length > 1 && Common.isEquals(file.getAttachExt(), ext[ext.length - 1])) checkExt = true;

			resultStr += "	<tr id=\"" + file.getAttachId() + "\" size=\"" + file.getAttachSize() + "\"  class=\"" + (Common.isEmpty(file.getAttachPath()) == true ? "notfound" : "") + " " + (checkExt ? "" : "differentExt") + "\" > ";
			resultStr += "		<td><span class=\"attachName\"><span class=\"glyphicon glyphicon-paperclip\" style=\"padding-right:5px;\"></span>" + file.getAttachName() + "</span></td> ";
			resultStr += "		<td style=\"text-align: right;\">" + Common.convertFileSize(file.getAttachSize()) + "</td> ";
			resultStr += "		<td style=\"text-align: center;\"><span class=\"attachExt\"><span class=\"glyphicon glyphicon-download-alt\"></span>&nbsp;" + file.getAttachExt() + "" + (Common.isEquals(file.getAttachExt(), "unknown") ? "(txt)" : "") + "</span></td> ";
			resultStr += "	</tr> ";
		}
		resultStr += "</table> ";
		return resultStr;
	}

	private String getPatternHtml(List<EmsPiVO> pattern, Locale locale) {
		String resultStr = "";
		resultStr += "<table class=\"subTable02 table-bordered\"> ";
		resultStr += "	<tr> ";
		resultStr += "		<th colspan=\"2\">" + Prop.propFormat("common.msg.separator", locale) + "</th> ";
		resultStr += "		<th colspan=\"2\">"+Prop.propFormat("bodyview.info.detect", locale)+"</th>";
		resultStr += "	</tr> ";
		int pi_Total = 0;
		for (int i = 0; i < pattern.size(); i++) {
			EmsPiVO pi = pattern.get(i);
			String piType = "";
			if (Common.isEquals(pi.getType(), "S")) piType = Prop.propFormat("condition.subject", locale);
			else if (Common.isEquals(pi.getType(), "B")) piType = Prop.propFormat("condition.body", locale);
			else if (Common.isEquals(pi.getType(), "F")) piType = Prop.propFormat("condition.attach_name", locale);
			else if (Common.isEquals(pi.getType(), "A")) piType = Prop.propFormat("consent.attach", locale);
			else piType = Prop.propFormat("DATA_MONITOR.MESSAGE_INFO", locale);
			String piName = "";
			if(pi.getPiid().equals("SN")) piName = Prop.propFormat("bodyview.sn", locale);
			else if(pi.getPiid().equals("CN")) piName = Prop.propFormat("bodyview.cn", locale);
			else if(pi.getPiid().equals("DN")) piName = Prop.propFormat("bodyview.dn", locale);
			else if(pi.getPiid().equals("PN")) piName = Prop.propFormat("bodyview.fn", locale);
			else if(pi.getPiid().equals("FN")) piName = Prop.propFormat("bodyview.pn", locale);
			else if(pi.getPiid().equals("EC")) piName = Prop.propFormat("bodyview.ec", locale);
			else if(pi.getPiid().equals("EF")) piName = Prop.propFormat("bodyview.ef", locale);
			else if(pi.getPiid().equals("ID")) piName = Prop.propFormat("bodyview.id", locale);
			else if (pi.getPiid().equals("DRM")) piName = Prop.propFormat("bodyview.DRM", locale);

			else piName = Prop.propFormat("bodyview.info.pattern", locale);

			resultStr += "	<tr> ";
			if (Common.isEquals(pi.getType(), "A")||Common.isEquals(pi.getType(), "F")) {
				resultStr += "			<td style=\"text-align: left; padding-left:10px !important;\">" + piType + "</td> ";
				resultStr += "			<td style=\"text-align: left;\">" + pi.getAttachName() + "</td> ";
			} else {
				resultStr += "			<td style=\"text-align: left; padding-left:10px !important;\" colspan=\"2\">" + piType + "</td> ";
			}
			resultStr += "		<td style=\"text-align: left;\">" + piName + "</td> ";
			resultStr += "		<td style=\"text-align: right;\">" + pi.getTotal() + "</td> ";
			resultStr += "	</tr>";
			pi_Total += pi.getTotal();
		}
		resultStr += "<tr>";
		resultStr += "<th colspan=\"2\" style=\"text-align: center;\">" + Prop.propFormat("common.msg.all", locale) + "</th>";
		resultStr += "<th colspan=\"2\" style=\"text-align: right;\">" +pi_Total+ "</th>";
		resultStr += "</tr>";
		resultStr += "</table>";
		return resultStr;
	}


	private String getOcrHtml(List<EmsAttachVO> files, boolean hasOcr) throws Exception {
		String resultStr = "";
		EmsAttachDownload attachDown = new EmsAttachDownload();
		if(hasOcr) {
			resultStr += "<table class=\"subTable02 table-bordered\"> ";
			resultStr += "	<colgroup> ";
			resultStr += "		<col width=\"200px\"> ";
			resultStr += "		<col width=\"*\"> ";
			resultStr += "	</colgroup>	 ";
			for (int i = 0; i < files.size(); i++) {
				EmsAttachVO file = files.get(i);
				String base64Image = "";
				try {
					base64Image = ImageUtils.imageResize(attachDown.getAttach(file.getAttachPath(), file.getAttachHarPath()), 200);
				} catch (Exception e) {
					e.printStackTrace();
				}
				if(Common.isEquals(file.getOcrYn(), "Y")) {
					resultStr += "	<tr> ";
					resultStr += "	<th colspan=\"2\">" + file.getAttachName() + "</td> ";
					resultStr += "	</tr> ";
					resultStr += "	<tr> ";
					resultStr += "		<td><img style=\"max-width: 200px\" src=\"data:image/" + file.getAttachExt() + ";base64, "+ base64Image + "\"/></td> ";
					resultStr += "		<td>" + file.getOcrText().replaceAll("\n", "<br>") + "</td> ";
					resultStr += "	</tr> ";
				}
			}
			resultStr += "</table> ";
		}
		return resultStr;
	}
}
