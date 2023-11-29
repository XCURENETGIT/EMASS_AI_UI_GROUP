package com.xcurenet.emass.message.newService;

import com.xcurenet.common.ipv6.IPv6Address;
import com.xcurenet.common.ipv6.IPv6AddressRange;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.iprange.service.IpRangeVO;
import com.xcurenet.emass.message.service.EmsRecvVO;
import com.xcurenet.emass.message.vo.emass.els.Emass;
import com.xcurenet.emass.message.vo.emass.els.EmassResponse;
import com.xcurenet.emass.message.vo.emass.els.fields.AttachVo_Els;
import com.xcurenet.emass.message.vo.emass.els.fields.PiVo_Els;
import com.xcurenet.emass.message.vo.emass.mongo.EmassMessage;
import com.xcurenet.emass.message.vo.emass.mongo.fields.*;
import com.xcurenet.interestUser.service.AdminUserGroupVO;
import net.sf.json.JSONObject;
import org.apache.commons.lang.math.NumberUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Value;

import java.io.IOException;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class EmsReDefined {

	@Value("${server.servlet.context-path}")
	private static String contextPath;

	private final static DateTimeFormatter yyyyMMddHHmmss = DateTimeFormat.forPattern("yyyyMMddHHmmss");
	private final static DateTimeFormatter yyyyMMddHHmmss2 = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

	private List<Emass> emass;
	private List<EmassResponse> emassRes = new ArrayList<>();

	private String readYn;

	private String consentNo;

	private Map<String, String> userIds;

	public EmsReDefined(List<Emass> emass, String readYn) {
		this.emass = emass;
		this.readYn = readYn;
	}

	public EmsReDefined(List<Emass> emass, String readYn, String consentNo, List<AdminUserGroupVO> interestUser) {
		this.emass = emass;
		this.readYn = readYn;
		this.consentNo = consentNo;
		this.userIds = new HashMap<>();
		for (int i = 0; i < interestUser.size(); i++) {
			AdminUserGroupVO interestSimpleUserVO = interestUser.get(i);
			if (Common.isNotEmpty(interestSimpleUserVO.getUserId()))
				userIds.put(interestSimpleUserVO.getUserId(), interestSimpleUserVO.getGroupColor());
		}
	}

	/*################## 화면표시용 재빌드 ############################################################## */
	public List<EmassResponse> reDefined(String adminId, List<ConfigAdminVO> conf) throws IOException {
		String bodysnippetVal = "N";
		String summaryVal = "Y";

		/* 나중 구현 예정 */
//		for (int i = 0; i < conf.size(); i++) {
//			if (conf.get(i).getConfId().equals("body.snippet.sum.use")) bodysnippetVal = conf.get(i).getVal();
//			else if (conf.get(i).getConfId().equals("toccbcc.sum.use")) summaryVal = conf.get(i).getVal();
//		}
		EmassResponse emassResponse = null;
		for (int i = 0; i < emass.size(); i++) {
			emassResponse = new EmassResponse();
			Emass ems = emass.get(i);

			/* 첨부파일 관련 ####################### */
			/*  첨부파일 총 크기 계산   */
			Long fileSize = 0L;
			if (!Common.isEmpty(ems.getAttach())) {
				for (AttachVo_Els attach : ems.getAttach()) {
					fileSize = fileSize + attach.getSize();
				}
			}
			String totalAttachFileSize = Common.convertFileSize(fileSize);
			emassResponse.setAttach_sizeStr(totalAttachFileSize);
			emassResponse.setAttachCnt(Common.nvs(ems.getAttachCnt()));
			emassResponse.setAttachExistCnt(Common.nvs(ems.getAttachExistCnt()));
			emassResponse.setAttached(ems.getAttached());


			/* 문서 관련 ####################### */
			emassResponse.setMsgid(Common.nvl(ems.getMsgid()));
			emassResponse.setSize(Common.convertFileSize(ems.getSize()));
			if (!Common.isEmpty(ems.getBody())) {
				emassResponse.setBody_size(ems.getBody().getSize());
				if (bodysnippetVal.equals("Y"))
					emassResponse.setBody_snippet(reBodySnippet(ems.getBody().getSnippet()));
				else emassResponse.setBody_snippet("");
			}


			emassResponse.setCtime(Common.nvl(ems.getCtime()));
			emassResponse.setCtime(ems.getCtime());
			if(!Common.isEmpty(ems.getCtime())){
				emassResponse.setCtimeYYYYMMDD(ems.getCtime().substring(0,8));
				emassResponse.setCtimeYYYYMMDDHH(ems.getCtime());
				emassResponse.setCtimeYYYYMM(ems.getCtime().substring(0,6));
			}

			emassResponse.setDirection(Common.nvl(ems.getDirection()));
			emassResponse.setDirectionSvc(Common.nvl(ems.getDirectionSvc()));
			emassResponse.setAllOfUs(reAllofUs(ems.getAllOfUs(),Common.getLocale()));  // 수신자 구분
			emassResponse.setPi_CN(ems.getPiCN());
			emassResponse.setPi_FN(ems.getPiFN());
			emassResponse.setPi_DN(ems.getPiDN());
			emassResponse.setPiEF(ems.getPiEF());
			emassResponse.setPi_PN(ems.getPiPN());
			emassResponse.setPi_SN(ems.getPiSN());
			emassResponse.setPiTotal(ems.getPiTotal());
			emassResponse.setUsrId(ems.getUsrId());

			emassResponse.setSubject(reSubject(ems));
			emassResponse.setXrootMtr(ems.getXrootMtr());
			emassResponse.setXmsgKey(ems.getXmsgKey());
			emassResponse.setOpinion(ems.getOpinion());
			emassResponse.setXparentMtr(ems.getXparentMtr());

			emassResponse.setPassword(ems.getPassword());
			emassResponse.setSiteAttr(ems.getSiteAttr());
			emassResponse.setSiteCode(ems.getSiteCode());
			emassResponse.setEpHeader(ems.getEpHeader());
			emassResponse.setEpmsgType(ems.getEpmsgType());
			if (!Common.isEmpty(ems.getUser()) && !Common.isEmpty(ems.getNetwork()) && !Common.isEmpty(ems.getService())) {
				emassResponse.setService_svc_Nm(reSvcNm(ems.getService().getSvc(), ems.getNetwork().getProtocol()));
			}

			/* HTTP 관련 ####################### */
			if (!Common.isEmpty(ems.getHttp())) {
				emassResponse.setHttp_path(Common.nvl(ems.getHttp().getPath()));
				emassResponse.setHttp_query(Common.nvl(ems.getHttp().getQuery()));
				emassResponse.setHttp_host(Common.nvl(ems.getHttp().getHost()));
			}

			/* 키워드 관련 ####################### */

			if (!Common.isEmpty(ems.getKwdInfo())) {
				emassResponse.setKwdInfo_kwdsAttach(ems.getKwdInfo().getKwdsAttach());
				emassResponse.setKwdInfo_kwdsAttachNm(ems.getKwdInfo().getKwdsAttachNm());
				emassResponse.setKwdInfo_kwd(ems.getKwdInfo().getKwd());
				emassResponse.setKwdInfo_kwds(ems.getKwdInfo().getKwds());
				emassResponse.setKwdInfo_kwdsBody(ems.getKwdInfo().getKwdsBody());
				emassResponse.setKwdInfo_kwdsSubject(ems.getKwdInfo().getKwdsSubject());
			}

			/* Sender 관련 ####################### */

			if (!Common.isEmpty(ems.getSender())) {
				emassResponse.setSender_alias(ems.getSender().getAlias());
				emassResponse.setSender_id(ems.getSender().getId());
				emassResponse.setSender_userId(ems.getSender().getUserId());
				emassResponse.setSender_name(ems.getSender().getName());
				emassResponse.setSender_email(ems.getSender().getEmail());
				emassResponse.setSender_ip(ems.getSender().getIp());
				emassResponse.setSender_coCd(ems.getSender().getCoCd());
				emassResponse.setSender_coNm(ems.getSender().getCoNm());
				emassResponse.setSender_busiCd(ems.getSender().getBusiCd());
				emassResponse.setSender_busiNm(ems.getSender().getBusiNm());
				emassResponse.setSender_suborgCd(ems.getSender().getSuborgCd());
				emassResponse.setSender_suborgNm(ems.getSender().getSuborgNm());
				emassResponse.setSender_deptCd(ems.getSender().getDeptCd());
				emassResponse.setSender_deptNm(ems.getSender().getDeptNm());
				emassResponse.setSender_jikgubCd(ems.getSender().getJikgubCd());
				emassResponse.setSender_jikgubNm(ems.getSender().getJikgubNm());
				emassResponse.setSender_ceo(ems.getSender().getCeo());
				emassResponse.setSender_inside(ems.getSender().getInside());
			}

			/* RECV 관련 ####################### */

			if (!Common.isEmpty(ems.getRecv())) {
				if (!Common.isEmpty(ems.getRecv().getTo())) {
					List<String> toList = ems.getRecv().getTo().stream().map(m -> m.getId()).collect(Collectors.toList());
					emassResponse.setTo(reToccBcc(toList, summaryVal));
				}
				if (!Common.isEmpty(ems.getRecv().getCc())) {
					List<String> ccList = ems.getRecv().getCc().stream().map(m -> m.getId()).collect(Collectors.toList());
					emassResponse.setCc(reToccBcc(ccList, summaryVal));
				}
				if (!Common.isEmpty(ems.getRecv().getBcc())) {
					List<String> bccList = ems.getRecv().getBcc().stream().map(m -> m.getId()).collect(Collectors.toList());
					emassResponse.setCc(reToccBcc(bccList, summaryVal));
				}

			}

			/* ML 관련 ####################### */

			if (!Common.isEmpty(ems.getMl())) {
				emassResponse.setMl_mlConfdClass(ems.getMl().getMlConfdClass());
				emassResponse.setMl_mlConfdFeedback(ems.getMl().getMlConfdFeedback());
				emassResponse.setMl_mlConfdProb(ems.getMl().getMlConfdProb());
			}

			/* NetWork 관련 ####################### */
			if (!Common.isEmpty(ems.getNetwork())) {
				emassResponse.setNetwork_srcIp(ems.getNetwork().getSrcIp());
				emassResponse.setNetwork_srcPort(ems.getNetwork().getSrcPort());
				emassResponse.setNetwork_dstIp(ems.getNetwork().getDstIp());
				emassResponse.setNetwork_dstPort(ems.getNetwork().getDstPort());
				emassResponse.setNetwork_protocol(ems.getNetwork().getProtocol());
				emassResponse.setNetwork_cid(ems.getNetwork().getCid());
			}

			/* Pi 관련 ####################### */
			if (!Common.isEmpty(ems.getPi())) {
				for (PiVo_Els piVoEls : ems.getPi()) {
					emassResponse.setPi_id(piVoEls.getId());
					emassResponse.setPi_type(piVoEls.getType());
					emassResponse.setPi_attachNm(piVoEls.getAttachNm());
					emassResponse.setPi_kwds(piVoEls.getKwds());
					emassResponse.setPi_amount(piVoEls.getAmount());
				}

			}

			/* Serivce 관련 ####################### */
			if (!Common.isEmpty(ems.getService())) {
				emassResponse.setService_svc(ems.getService().getSvc());
				emassResponse.setService_svc1(ems.getService().getSvc1());
				emassResponse.setService_svc2(ems.getService().getSvc2());
				emassResponse.setService_svc3(ems.getService().getSvc3());
				emassResponse.setService_svc12(ems.getService().getSvc12());

			}

			/* USER 관련 ####################### */
			if (!Common.isEmpty(ems.getUser())) {
				emassResponse.setUser_id(ems.getUser().getId());
				emassResponse.setUser_userId(ems.getUser().getUserId());
				emassResponse.setUser_name(ems.getUser().getName());
				emassResponse.setUser_coCd(ems.getUser().getIpCoCd());
				emassResponse.setUser_coNm(ems.getUser().getIpCoNm());
				emassResponse.setUser_ipBusiNm(ems.getUser().getIpBusiNm());
				emassResponse.setUser_ipBusiCd(ems.getUser().getIpBusiCd());

				emassResponse.setUser_coCd(ems.getUser().getCoCd());
				emassResponse.setUser_coNm(Config.userCoNms.get(ems.getUser().getName()));
				emassResponse.setUser_busiCd(ems.getUser().getBusiCd());
				emassResponse.setUser_busiNm(Config.userBusiNms.get(ems.getUser().getId()));
				emassResponse.setUser_suborgCd(ems.getUser().getSuborgCd());
				emassResponse.setUser_suborgNm(ems.getUser().getSuborgNm());
				emassResponse.setUser_deptNm(Config.userDepts.get(ems.getUser().getId()));
				emassResponse.setUser_deptCd(ems.getUser().getDeptCd());
				emassResponse.setUser_jikgubNm(Config.userJikgubs.get(ems.getUser().getId()));
				emassResponse.setUser_jikgubCd(ems.getUser().getJikgubCd());
				emassResponse.setUser_inside(ems.getUser().getInside());
			}


			/* 스니펫 관련 주석 */

			/* 임시 주석 */
//			ems.setSenderOrig(edc.getSender()); 	// 변환되기전 sender를 가진다.
//			edc.setSender(reSender(Common.nvl(edc.getSender()), Common.nvl(edc.getSname()), Common.nvl(edc.getSrcip()), Common.nvl(edc.getUsr_ip())));


			emassRes.add(i, emassResponse);
		}
		this.emass = null; /* emassRes rebuild 후 기존의 emass 내용 비워줌 */

		return emassRes;
	}

	public static List<Emass> reDefined(List<Emass> emassList, Locale locale) {
		for (int i = 0; i < emassList.size(); i++) {
			Emass ems = emassList.get(i);
			//	ems.setInside(reInside(edc.getInside(), locale));
			ems.setAllOfUs(reAllofUs(ems.getAllOfUs(), locale));
			ems.setDirectionSvc(reDirectionSvc(ems.getDirectionSvc(), locale));
			ems.getMl().setMlConfdClass(Integer.parseInt(reMlConfdClass(ems.getMl().getMlConfdClass(), locale)));
			ems.getMl().setMlConfdFeedback(Integer.parseInt(reMlConfdClass(ems.getMl().getMlConfdFeedback(), locale)));
			emassList.set(i, ems);
		}
		return emassList;

	}

	public static String reMlConfdClass(int ml_confd_class, Locale locale) {
		if (ml_confd_class == 4) return Prop.propFormat("condition.info.class4", locale);
		else if (ml_confd_class == 3) return Prop.propFormat("condition.info.class3", locale);
		else if (ml_confd_class == 2) return Prop.propFormat("condition.info.class2", locale);
		else if (ml_confd_class == 1) return Prop.propFormat("condition.info.class1", locale);
		return Prop.propFormat("common.msg.noinfo", locale);
	}

	public static String reMlConfdFeedback(int ml_confd_feedback, Locale locale) {
		if (ml_confd_feedback == 1234) return Prop.propFormat("condition.info.feedback1234", locale);
		else if (ml_confd_feedback == 0) return Prop.propFormat("condition.info.feedback0", locale);
		else if (ml_confd_feedback == 9) return Prop.propFormat("condition.info.feedback9", locale);
		return "-";
	}

	public static String reInside(String inside, Locale locale) {
		if (Common.isEmpty(inside)) return null;
		if (Common.isEquals(inside, "Y")) return Prop.propFormat("message.msg.in", locale);
		else if (Common.isEquals(inside, "N")) return Prop.propFormat("message.msg.out", locale);
		return inside;
	}

	public static String reDirectionSvc(String direction_svc, Locale locale) {
		if (Common.isEquals(direction_svc, "I")) return Prop.propFormat("condition.receive", locale);
		else if (Common.isEquals(direction_svc, "O")) return Prop.propFormat("condition.send", locale);
		else return "-";
	}

	public static String reAllofUs(String allofus, Locale locale) {
		if (Common.isEmpty(allofus)) return null;
		String result = "";
		if (Common.isEquals(allofus, "IA")) result = Prop.propFormat("condition.allofus1", locale);
		else if (Common.isEquals(allofus, "ET")) result = Prop.propFormat("condition.allofus8", locale);
		else if (Common.isEquals(allofus, "IT")) result = Prop.propFormat("condition.allofus7", locale);
		else if (Common.isEquals(allofus, "EA")) result = Prop.propFormat("condition.allofus2", locale);
		else if (Common.isEquals(allofus, "PT")) result = Prop.propFormat("condition.allofus9", locale);
		else if (Common.isEquals(allofus, "PA")) result = Prop.propFormat("condition.allofus3", locale);
		else if (Common.isEquals(allofus, "SO")) result = Prop.propFormat("condition.allofus13", locale);
		else if (Common.isEquals(allofus, "SI")) result = Prop.propFormat("condition.allofus14", locale);
		return result;
	}


	public static List<String> reAllofUs(List<String> allofus, Locale locale) {
		if (Common.isEmpty(allofus)) return null;

		for (int x = 0; x < allofus.size(); x++) {
			if (Common.isEquals(allofus.get(x), "IA")) allofus.set(x, Prop.propFormat("condition.allofus1", locale));
			else if (Common.isEquals(allofus.get(x), "ET"))
				allofus.set(x, Prop.propFormat("condition.allofus8", locale));
			else if (Common.isEquals(allofus.get(x), "IT"))
				allofus.set(x, Prop.propFormat("condition.allofus7", locale));
			else if (Common.isEquals(allofus.get(x), "EA"))
				allofus.set(x, Prop.propFormat("condition.allofus2", locale));
			else if (Common.isEquals(allofus.get(x), "PT"))
				allofus.set(x, Prop.propFormat("condition.allofus9", locale));
			else if (Common.isEquals(allofus.get(x), "PA"))
				allofus.set(x, Prop.propFormat("condition.allofus3", locale));
			else if (Common.isEquals(allofus.get(x), "SO"))
				allofus.set(x, Prop.propFormat("condition.allofus13", locale));
			else if (Common.isEquals(allofus.get(x), "SI"))
				allofus.set(x, Prop.propFormat("condition.allofus14", locale));
		}

		return allofus;
	}

	public List<String> getSummary(List<String> targets) {
		List<String> tmp = new ArrayList<String>();
		if (targets.size() > 1) {
			tmp.add(targets.get(0).toString() + " " + Prop.propFormat("condition.view.type8") + " " + (targets.size() - 1) + " " + Prop.propFormat("condition.view.type9"));
			return tmp;
		}
		return targets;
	}

	public String checkInOut(List<String> targets) {

		List<IpRangeVO> ipRange = Config.getIpRange();
		String inOutDelimiter = Config.getString("ui.inout.delimiter");
		String[] inOuts = inOutDelimiter.split(",");

		return checkTargetInOut(ipRange, inOuts, targets);
	}

	private String checkTargetInOut(List<IpRangeVO> ipRange, String[] inOuts, List<String> targets) {
		if (targets == null || targets.size() == 0) return "";

		int inCount = 0;
		int outCount = 0;
		for (String target : targets) {
			boolean inflag = false;
			for (String inOut : inOuts) {

				if (Common.isNotEmpty(inOut) && target.matches(".*" + inOut + ".*")) {
					inflag = true;
					break;
				}

			}
			if (!inflag && ((target.split("\\.").length == 4 && NumberUtils.isNumber(target.split("\\.")[3])) || target.split("\\:").length > 2)) {
				inflag = checkIpRange(ipRange, target);
			}

			if (!inflag) outCount++;
			else inCount++;

		}
		return "[" + outCount + "/" + inCount + "]";
	}

	private boolean checkIpRange(List<IpRangeVO> ipRange, String target) {
		boolean result = false;
		String targetIpVersion = Common.getIPversion(target);

		for (IpRangeVO ipRangeVo : ipRange) {
			String startIp = Common.nvl(ipRangeVo.getStartIp());
			String endIp = Common.nvl(ipRangeVo.getEndIp());

			String ipVersion = Common.getIPversion(startIp);

			if (Common.isNotEquals(ipVersion, targetIpVersion)) continue;

			if (Common.isEquals(ipVersion, "4")) {
				long start_ip = Common.strIpToLong(startIp);
				long end_ip = Common.strIpToLong(endIp);
				long target_ip = Common.strIpToLong(target);
				if (start_ip < target_ip && target_ip < end_ip) {
					result = true;
					break;
				}
			} else if (Common.isEquals(ipVersion, "6")) {
				IPv6AddressRange innerIpRange = IPv6AddressRange.fromFirstAndLast(IPv6Address.fromString(startIp), IPv6Address.fromString(endIp));
				if (innerIpRange.contains(IPv6Address.fromString(target))) {
					result = true;
					break;
				}
			}
		}

		return result;
	}

	public String interestUser() {
		return "";
	}

	public String reConm(String conm, String ip_conm) {
		if (ip_conm.length() > 0 && !ip_conm.equals("-")) return ip_conm;
		else return conm;
	}

	public String reBunm(String bunm, String ip_bunm) {
		if (ip_bunm.length() > 0 && !ip_bunm.equals("-")) return ip_bunm;
		else return bunm;
	}

	public static String reSubject(Emass emass) {
		EmassMessage msg = new EmassMessage();
		if (!Common.isEmpty(emass.getSubject())) msg.setSubject((Common.nvl(emass.getSubject())));

		if (!Common.isEmpty(emass.getService())) {
			msg.setSvc(Common.nvl(emass.getService().getSvc()));
		}

		if (!Common.isEmpty(emass.getNetwork())) {
			msg.setNetwork(new NetworkVo_Mgo());
			msg.getNetwork().setSrcIp(Common.nvl(emass.getNetwork().getSrcIp()));
			msg.getNetwork().setDstIp((Common.nvl(emass.getNetwork().getDstIp())));
			msg.getNetwork().setProtocol(Common.nvl(emass.getNetwork().getProtocol()));
		}
		if (!Common.isEmpty(emass.getHttp())) {
			msg.setHttp(new HttpVo_Mgo());
			msg.getHttp().setHost(Common.nvl(emass.getHttp().getHost()));
			msg.getHttp().setPath(Common.nvl(emass.getHttp().getPath()));
		}

		List<AttachVo_Mgo> attachInfo = null;
		if (null != emass.getAttach() && emass.getAttach().size() >= 1) {
			attachInfo = new ArrayList<>();
			AttachVo_Mgo attachInfoProperties = new AttachVo_Mgo();
			for (AttachVo_Els attach : emass.getAttach()) {
				attachInfoProperties.setName(Common.nvl(attach.getName()));
			}
			attachInfo.add(attachInfoProperties);
			msg.setAttach(attachInfo);
		}

		msg.setXrootMtr(Common.nvl(emass.getXrootMtr()));
		return reSubject(msg);
	}

	public static String reSubject(EmassMessage msg) {
		String result = null;
		if (msg == null) result = Prop.propFormat("common.msg.nosubject");
		String subject = Common.nvl(msg.getSubject());
		String svc = "";
		String svc1 = "";
		String srcip = "";
		String dstip = "";
		String host = "";
		String path = "";
		String Xroot_mtr = "";

		if (!Common.isEmpty(msg.getSvc())) {
			svc = Common.nvl(msg.getSvc());
			svc1 = Common.nvl(msg.getSvc()).substring(0, 1);
		} else {
			result = subject;
		}

		if (!Common.isEmpty(msg.getNetwork())) {
			srcip = Common.nvl(msg.getNetwork().getSrcIp());
			dstip = Common.nvl(msg.getNetwork().getDstIp());
		}

		if (!Common.isEmpty(msg.getHttp())) {
			host = Common.nvl(msg.getHttp().getHost());
			path = Common.nvl(msg.getHttp().getPath());
		}

		Xroot_mtr = Common.nvl(msg.getXrootMtr());

		String webPrefix = Common.nvl(contextPath);
		if (subject.length() > 1)
			result = subject.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "'");

		if (Common.isOrEquals(svc1, "F", "Q", "T")) {
			if (Common.isNotEmpty(Xroot_mtr) || Common.isEquals(svc1, "T")) {
				/* 스니펫 주석 */
				// if( svc.lastIndexOf("C") == 3 || svc.lastIndexOf("M") == 3 ) return Common.nvl(msg).replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "'");

				if (svc.lastIndexOf("F") == 3) {
					List<AttachVo_Mgo> list = msg.getAttach();
					if (list != null) {
						/* 스니펫 주석 */
//						if(Common.isNotEmpty(msg.getBody_snippet())) {
//							return String.join(", ", list) +"<br/>"+Common.nvl(msg.getBody_snippet()).replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "'");
//						}
						result = list.stream().map(a -> a.getName()).collect(Collectors.joining(", "));
					} else result = Common.EMPTY;
				} else if (svc.lastIndexOf("J") == 3)
					result = "[" + Prop.propFormat("common.messenger.join.info") + "]";
				else if (svc.lastIndexOf("L") == 3) result = "[" + Prop.propFormat("common.messenger.leave.info") + "]";
				else result = srcip + "->" + dstip;
			} else if (svc.lastIndexOf("GP") > -1 || svc.lastIndexOf("DA") > -1 || svc.lastIndexOf("BI") > -1) {
				/* 스니펫 주석 */
				//		return Common.nvl(msg.getBody_snippet()).replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "'");
				result = "";
			} else {
				return result = srcip + "->" + dstip;
			}
		} else if (Common.isOrEquals(svc1, "U", "X") && Common.isNotEmpty(host))
			result = webPrefix + host + Common.nvl(path);
		else if (Common.isOrEquals(svc1, "X")) result = srcip + "->" + dstip;
		else if (Common.isEquals(svc, "EMF-")) result = "EP-[MAIL] FILE DOWNLOAD";
		else if (Common.isEquals(svc, "EBBF")) result = "EP-[BBS] FILE DOWNLOAD";
		else if (Common.isEquals(svc, "EAAF")) result = "EP-[APP] FILE DOWNLOAD";
		else if (Common.isEmpty(subject)) result = Prop.propFormat("common.msg.nosubject");
		else
			result = subject.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "'");

		return result;
	}

	public String reSender(String sender, String sname, String src_ip, String usr_ip) {
		if (sname.length() > 0 && sender.length() == 0) return sname;
		else if (sname.length() > 0 && sender.length() > 0) return sname + "<" + sender + ">";
		else if (sender.length() > 0) {
			if (usr_ip.length() == 0) return sender;
			else return sender + "<" + usr_ip + ">";
		} else return src_ip;
	}

	public String reRecvInfo(String target) {
		JSONObject obj = Common.toJSONObject(Config.userNamebyEmails.get(target));

		if (obj.isEmpty()) {
			return target;
		}

		return obj.getString("name") + "<" + obj.getString("id") + ">";
	}

	public String reRecvs(List<String> recvs, String summary) {
		String result = checkInOut(recvs);

		for (int i = 0; i < recvs.size(); i++) {
			String target = recvs.get(i);

			if (!(summary.equals("Y") && i > 4)) {
				result += reRecvInfo(target);
			} else {

				result += " " + Prop.propFormat("condition.view.type8") + " " + (recvs.size() - 5) + " " + Prop.propFormat("condition.view.type9");
				return result;

			}

			if (i != (recvs.size() - 1)) result += ",";
		}

		return result;
	}

	public List<String> reToccBcc(List<String> recvs, String summary) {
		String tmpStr = "";

		for (int i = 0; i < recvs.size(); i++) {
			String target = recvs.get(i);

			if (!(summary.equals("Y") && i > 4)) {

				tmpStr = reRecvInfo(target);
				if (Common.isNotEquals(target, tmpStr)) {
					recvs.set(i, tmpStr);
				}

			} else {

				List<String> tmp = new ArrayList<>(recvs.subList(0, 5));
				int lastIdx = tmp.size() - 1;

				tmp.set(lastIdx, tmp.get(lastIdx) + " " + Prop.propFormat("condition.view.type8") + " " + (recvs.size() - 5) + " " + Prop.propFormat("condition.view.type9"));
				return tmp;

			}

		}

		return recvs;
	}

	/*public static String reUser(String id, String ip, String email, String name, String coNm, String busiNm, String subOrgNm, String deptNm, String jikgubNm) {
		StringBuffer result = new StringBuffer();
		if (Common.isEmpty(name)) { // 인사매핑 안된경우
			result.append(id);
			return result.toString();
		} else {
			result.append(name);
			result.append("(");
			if (Common.isNotEmpty(email)) {
				result.append(email);
			} else {
				result.append(ip);
			}
			result.append(")");

			if (Common.isNotEmpty(busiNm) || Common.isNotEmpty(subOrgNm) || Common.isNotEmpty(deptNm) || Common.isNotEmpty(jikgubNm)) {
				result.append("[");
			}

			if (Common.isNotEmpty(busiNm)) {
				result.append("사업장 : " + busiNm).append(",");
			}
			if (Common.isNotEmpty(subOrgNm)) {
				result.append("총괄: " + subOrgNm).append(",");
			}
			if (Common.isNotEmpty(deptNm)) {
				result.append("부서 : " + deptNm).append(",");
			}
			if (Common.isNotEmpty(jikgubNm)) {
				result.append("직급 : " + jikgubNm).append(",");
			}
			if (Common.isNotEmpty(busiNm) || Common.isNotEmpty(subOrgNm) || Common.isNotEmpty(deptNm) || Common.isNotEmpty(jikgubNm)) {
				return result.toString().substring(0, result.toString().length() - 1) + "]";
			} else {
				return result.toString();
			}
		}
	}*/
	public static String reUser(String recvId, String email, String name) {
		StringBuffer sb = new StringBuffer();
		if (Common.isNotEmpty(name)) {
			return sb.append(name).toString();
		}
		if (Common.isNotEmpty(email)) {
			return sb.append(email).toString();
		}
//		if (Common.isNotEmpty(recvId)) {
//			return sb.append(recvId).toString();
//		}
		return "-";
	}

	public static ComProperties_Mgo reUserIp(ComProperties_Mgo u, String srcip, String dstip, String usrip) {
		List<String> ipList = new ArrayList<String>();
		String[] ips = Common.nvl(u.getId()).split(", ");
		for (String ip : ips) {
			if (Common.isEquals(ip, usrip.trim())) ipList.add(ip);
			else if (Common.isEquals(ip, srcip.trim())) ipList.add(ip);
			else if (Common.isEquals(ip, dstip.trim())) ipList.add(ip);
		}
		u.setId(Common.join(ipList, ","));

		return u;
	}

	public static String reUserEmail(EmsRecvVO u, String userEmail) {
		String recvEmail = u.getEMail();
		if (Common.isEmpty(recvEmail)) return recvEmail;

		List<String> emailList = new ArrayList<String>();
		String[] emails = Common.nvl(recvEmail).split(",");

		for (String email : emails) {
			if (Common.isEquals(email, userEmail) && chkEmail(userEmail, emails)) emailList.add(email);
		}

		if (emailList.size() == 0) return emails[0];
		else return Common.join(emailList, ",");
	}

	public static String reUserEmail(EmsRecvVO u) {
		return reUserEmail(u, u.getRecvId());
	}

	private static boolean chkEmail(String userEmail, String[] emails) {
		String pattern2 = "^([0-9a-zA-Z_.-]+)@([0-9a-zA-Z_-]+)(\\.[0-9a-zA-Z_-]+){1,6}$";

		if (Pattern.matches(pattern2, userEmail)) {
			return true;
		} else return false;
	}

	public static String reUser(EmsRecvVO u, String formatval) {
		List<String> etcSeparator = Common.toList("[,<,(,{,],>,),},[[,<<,((,{{,}},>>,)),}},\",\"\",\'\',\"\',\'\"", ",");
		List<String> checkSeparator = Common.toList("\\[\\],\\<\\>,\\(\\),\\{\\}, \"\", \'\', \", \"\', \'\"", ",");

		String[] test = formatval.split("#");
		StringBuffer sb = new StringBuffer();
		int infoIdx = 0;
		int sepaCnt = 0;
		String tmpSeparator = "";
		boolean isEtcSeparator = false;
		for (int i = 0; i < test.length; i++) {

			if (i > 0 && i % 2 == 1) {
				String keyValue = EmsReDefined.reNameInfo(u, test[i]);

				if (Common.isNotEmpty(keyValue)) {
					infoIdx++;
					if (i == 1 || (i - 2 > 0 && Common.isNotEmpty(EmsReDefined.reNameInfo(u, test[i - 2])))) {
						sepaCnt++;
						sb.append(tmpSeparator);
					} else if (i - 2 > 0 && !checkValue(u, test, i)) {
						sepaCnt++;
						sb.append(tmpSeparator);
					} else {
						//sb = new StringBuffer();
					}
				} else if (isEtcSeparator) {
					sepaCnt++;
					sb.append(tmpSeparator);
				}

				sb.append(keyValue);
				if (i == test.length - 2 && (Common.isNotEmpty(keyValue) || etcSeparator.contains(Common.nvl(test[i + 1])))) {
					sb.append(test[i + 1]);
				}
				isEtcSeparator = false;
			}
			if (i % 2 == 0) {
				if (etcSeparator.contains(Common.nvl(test[i]).replaceAll(" ", ""))) {
					isEtcSeparator = true;
				}
				tmpSeparator = test[i];
			}

		}

		String rtnValue = sb.toString();

		for (String check : checkSeparator) {
			rtnValue = rtnValue.replaceAll(check, "");
		}
		if (sepaCnt == 1 && Common.isNotEmpty(rtnValue) && test != null) {
			rtnValue = rtnValue.substring(test[0].length(), rtnValue.length());
		}

		if (infoIdx == 0) {
			if (Common.isEquals(u.getUType(), "U")) return "-";
			else return Common.nvl(u.getRecvId());
		} else {
			return rtnValue;
		}


	}

	public static boolean checkValue(EmsRecvVO u, String[] test, int i) {
		if (i < 2) return true;

		boolean result = Common.isEmpty(EmsReDefined.reNameInfo(u, test[i - 2]));
		if (!result) return result;
		else {
			if (i > 2) {
				result = checkValue(u, test, i - 2);
			}
		}
		return result;
	}

	public static String reNameInfo(EmsRecvVO u, String key) {
		if (Common.isEquals(key, "name")) {
			if (Common.isEquals(u.getUType(), "U")) return Common.nvl(u.getName());
			else return Common.nvl(u.getName(), u.getRecvId());
		} else if (Common.isEquals(key, "deptnm")) return Common.nvl(u.getDeptNm());
		else if (Common.isEquals(key, "jikgubnm")) return Common.nvl(u.getJikgubNm());
		else if (Common.isEquals(key, "email")) {
			if (isValidEmail(u.getRecvId()) && Common.isNotEmpty(u.getName())) {
				return Common.nvl(u.getEMail(), u.getRecvId());
			} else return Common.nvl(u.getEMail());
		} else if (Common.isEquals(key, "businm")) return Common.nvl(u.getBusiNm());
		else if (Common.isEquals(key, "ip")) return Common.nvl(u.getIp());
		else return Common.EMPTY;
	}

	public static String reUser(String userid, String name) {
		StringBuffer sb = new StringBuffer();
		if (Common.isNotEmpty(name)) {
			sb.append(name);
			if (Common.isNotEmpty(userid)) {
				return sb.append("<").append(userid).append(">").toString();
			}
		} else if (Common.isNotEmpty(userid)) {
			sb.append(userid);
		} else {
			sb.append("-");
		}
		return sb.toString();
	}

	private static final String EMAIL_PATTERN =
			"^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
					+ "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";

	private static final Pattern pattern = Pattern.compile(EMAIL_PATTERN);

	public static boolean isValidEmail(String email) {
		return pattern.matcher(email).matches();
	}

	/**
	 * @param user   (ip, email, id) proxy인 경우 proxy 서버 ip
	 * @param name   사용자 이름(인사정보 매핑된 경우, 안되면 없음)
	 * @param usr_id 디코더에서 생성(사용자 계정 아이디)
	 * @param usr_ip Proxy 환경에서 Proxy로 전송되는 실제 사용자 ip
	 * @param sender 발신자
	 * @return name이 있는 경우(name<user, usr_ip, usr_id 중 1개>), name이 없는 경우(user, usr_ip, usr_id)
	 */
//	public String reUser(String user, String name, String usr_id, String usr_ip, String sender) {
//		StringBuffer sb = new StringBuffer();
//		if (Common.isNotEmpty(name)) {
//			sb.append(name);
//			if (Common.isNotEmpty(user)) {
//				return sb.append("<").append(user).append(">").toString();
//			}
//			if (Common.isNotEmpty(usr_ip)) {
//				return sb.append("<").append(usr_ip).append(">").toString();
//			}
//			if (Common.isNotEmpty(usr_id)) {
//				return sb.append("<").append(usr_id).append(">").toString();
//			}
//			return sb.toString();
//		} else {
//			if (Common.isNotEmpty(user)) {
//				return sb.append(user).toString();
//			}
//			if (Common.isNotEmpty(usr_ip)) {
//				return sb.append(usr_ip).toString();
//			}
//			if (Common.isNotEmpty(usr_id)) {
//				return sb.append(usr_id).toString();
//			}
//		}
//		return sender;
//	}
	public String reCtime(String ctime) {
		if (Common.isEmpty(ctime)) return Common.EMPTY;
		return DateTime.parse(ctime, yyyyMMddHHmmss).toString(yyyyMMddHHmmss2);
	}

	public String reSvcNm(String svc, String protocol) {
		if (Common.isEmpty(svc)) return null;

		String protocolNm = Config.getProtocolNm(protocol);
		if (Common.isNotEmpty(protocolNm)) return Config.getServiceLv12Nm(svc) + " [" + protocolNm + "]";
		else return Config.getServiceNm(svc);
	}

	public String reSvcLv1Nm(String svc) {
		if (Common.isEmpty(svc)) return null;
		return Config.getServiceLv1Nm(svc);
	}

	public String reSvcLv2Nm(String svc) {
		if (Common.isEmpty(svc)) return null;
		return Config.getServiceLv2Nm(svc);
	}

	public String reBodySnippet(String body) {
		if (Common.isEmpty(body)) return "-";
		else if (body.length() > 200) return body.substring(0, 200) + "...";
		else return body + "...";
	}

	public String interestUserStar(Emass emass) {
		if (Common.isNotEmpty(emass.getUser().getId()) && Common.isNotEmpty(userIds.get(emass.getUser().getId())))
			return "Y";
		else return "N";
	}

	public String interestUserGroupColor(Emass emass) {
		if (Common.isEmpty(emass.getUser().getId())) return null;
		return Common.nvl(userIds.get(emass.getUser().getId()));
	}

}
