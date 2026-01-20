package com.xcurenet.emass.message.service;

import com.xcurenet.common.ipv6.IPv6Address;
import com.xcurenet.common.ipv6.IPv6AddressRange;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.iprange.service.IpRangeVO;
import com.xcurenet.interestUser.service.AdminUserGroupVO;
import net.sf.json.JSONObject;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.solr.client.solrj.SolrServerException;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.IOException;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class EmsReDefined {

	private final static DateTimeFormatter yyyyMMddHHmmss = DateTimeFormat.forPattern("yyyyMMddHHmmss");
	private final static DateTimeFormatter yyyyMMddHHmmss2 = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

	private List<SolrEdcVO> emass;

	private String readYn;

	private String consentNo;
	
	private Map<String, String> userIds;
	
	public EmsReDefined(List<SolrEdcVO> emass, String readYn) {
		this.emass = emass;
		this.readYn = readYn;
	}

	public EmsReDefined(List<SolrEdcVO> emass, String readYn, String consentNo, List<AdminUserGroupVO> interestUser) {
		this.emass = emass;
		this.readYn = readYn;
		this.consentNo = consentNo;
		this.userIds = new HashMap<>();
		for (int i = 0; i < interestUser.size(); i++) {
			AdminUserGroupVO interestSimpleUserVO = interestUser.get(i);
			if(Common.isNotEmpty(interestSimpleUserVO.getUserId())) userIds.put(interestSimpleUserVO.getUserId(), interestSimpleUserVO.getGroupColor());
		}
	}

	public List<SolrEdcVO> reDefined(String adminId, List<ConfigAdminVO> conf) throws SolrServerException, IOException {
		String bodysnippetVal = "N";
		String summaryVal = "Y"; 
		for (int i = 0; i < conf.size(); i++) {
			if(conf.get(i).getConfId().equals("body.snippet.sum.use")) bodysnippetVal = conf.get(i).getVal();
			else if(conf.get(i).getConfId().equals("toccbcc.sum.use")) summaryVal = conf.get(i).getVal();
		}
		
		for (int i = 0; i < emass.size(); i++) {
			SolrEdcVO edc = emass.get(i);
			edc.setCtimeFormat(reCtime(edc.getCtime()));
			edc.setSubject(reSubject(edc));
			edc.setConm(reConm(Common.nvl(edc.getConm()), Common.nvl(edc.getIp_conm())));
			edc.setSvcNm(reSvcNm(edc.getSvc(), edc.getProtocol()));
			edc.setSvcLv1Nm(reSvcLv1Nm(edc.getSvc()));
			edc.setSvcLv2Nm(reSvcLv2Nm(edc.getSvc()));
			edc.setDirection_svc(edc.getDirection_svc());
			edc.setSrcip(edc.getSrcip());
			if(bodysnippetVal.equals("Y")) edc.setBody_snippet(reBodySnippet(edc.getBody_snippet()));
			else edc.setBody_snippet("");
			edc.setUser(reUser(Common.nvl(edc.getUserid()), Common.nvl(edc.getName())));
			edc.setSenderOrig(edc.getSender()); 	// 변환되기전 sender를 가진다.
			edc.setSender(reSender(Common.nvl(edc.getSender()), Common.nvl(edc.getSname()), Common.nvl(edc.getSrcip()), Common.nvl(edc.getUsr_ip())));
			edc.setAttachSizeStr(Common.convertFileSize(Common.sum(edc.getAttachsize())));
			edc.setAttachSizeSort(Common.sum(edc.getAttachsize()));
			edc.setSizeStr(Common.convertFileSize(edc.getSize()));
			edc.setBodySizeStr(Common.convertFileSize(edc.getBody_size()));

			edc.setRecvsInOutInfo(checkInoutInfo2(edc.getRecvs_info(), "recvs"));
			edc.setToInOutInfo(checkInoutInfo2(edc.getRecvs_info(), "to"));
			edc.setCcInOutInfo(checkInoutInfo2(edc.getRecvs_info(), "cc"));
			edc.setBccInOutInfo(checkInoutInfo2(edc.getRecvs_info(), "bcc"));
			
			if(Common.isNotEmpty(edc.getRecvs())) {
//				if(summaryVal.equals("Y") && edc.getRecvs().size() > 5) {
//					edc.setRecvsStr(checkInOut(edc.getRecvs()) + edc.getRecvs().get(0).toString() + " " + Prop.propFormat("condition.view.type8") + " " + (edc.getRecvs().size() - 1) + " " + Prop.propFormat("condition.view.type9"));
//				} else {
//					edc.setRecvsStr(checkInOut(edc.getRecvs()) + String.join(",", edc.getRecvs()));
//				}
				edc.setRecvsStr(reRecvs(edc.getRecvs(), summaryVal, edc.getRecvs_info()));
			} else edc.setRecvsStr("");
			
			if(Common.isNotEmpty(edc.getTo())) edc.setTo(reToccBcc(edc.getTo(), summaryVal));
			if(Common.isNotEmpty(edc.getCc())) edc.setCc(reToccBcc(edc.getCc(), summaryVal));
			if(Common.isNotEmpty(edc.getBcc())) edc.setBcc(reToccBcc(edc.getBcc(), summaryVal));
			
			edc.setInterestUserYn(interestUserStar(edc));
			edc.setInterestGroupColor(interestUserGroupColor(edc));
			
			if (Common.isNotEmpty(consentNo)) edc.setConsentNo(consentNo);
			if (Common.isNotEmpty(readYn)) edc.setReadYn(readYn);
			emass.set(i, edc);
		}
		return emass;
	}
	
	public static List<SolrEdcVO> reDefined(List<SolrEdcVO> solrEdcList, Locale locale){
		for (int i = 0; i < solrEdcList.size(); i++) {
			SolrEdcVO edc = solrEdcList.get(i);
			edc.setInside(reInside(edc.getInside(), locale));
			edc.setAllofus(reAllofUs(edc.getAllofus(), locale));
			edc.setDirection_svc(reDirectionSvc(edc.getDirection_svc(), locale));
			edc.setMl_confd_class_label(reMlConfdClass(edc.getMl_confd_class(), locale));
			edc.setMl_confd_feedback_label(reMlConfdFeedback(edc.getMl_confd_feedback(), locale));
			solrEdcList.set(i, edc);
		}
		return solrEdcList;
		
	}
	
	public static String reMlConfdClass(int ml_confd_class, Locale locale) {
		if (ml_confd_class == 4) return Prop.propFormat("condition.info.class4", locale);
		else if (ml_confd_class == 3) return Prop.propFormat("condition.info.class3", locale);
		else if (ml_confd_class == 2) return Prop.propFormat("condition.info.class2", locale);
		else if (ml_confd_class == 1) return Prop.propFormat("condition.info.class1", locale);
		return Prop.propFormat("common.msg.noinfo", locale);
	}
	
	public static String reMlConfdFeedback(int ml_confd_feedback, Locale locale) {
		if(ml_confd_feedback == 1234) return Prop.propFormat("condition.info.feedback1234", locale);
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
		if(Common.isEquals(direction_svc, "I")) return Prop.propFormat("condition.receive", locale);
		else if (Common.isEquals(direction_svc, "O")) return Prop.propFormat("condition.send", locale);
		else return "-";
	}
	
	public static List<String> reAllofUs(List<String> allofus, Locale locale) {
		if(Common.isEmpty(allofus)) return null;
			
		for(int x = 0; x < allofus.size(); x++) {
			if (Common.isEquals(allofus.get(x), "IA")) allofus.set(x, Prop.propFormat("condition.allofus1", locale));
			else if (Common.isEquals(allofus.get(x), "ET")) allofus.set(x, Prop.propFormat("condition.allofus8", locale));
			else if (Common.isEquals(allofus.get(x), "IT")) allofus.set(x, Prop.propFormat("condition.allofus7", locale));
			else if (Common.isEquals(allofus.get(x), "EA")) allofus.set(x, Prop.propFormat("condition.allofus2", locale));
			else if (Common.isEquals(allofus.get(x), "PT")) allofus.set(x, Prop.propFormat("condition.allofus9", locale));
			else if (Common.isEquals(allofus.get(x), "PA")) allofus.set(x, Prop.propFormat("condition.allofus3", locale));
			else if (Common.isEquals(allofus.get(x), "SO")) allofus.set(x, Prop.propFormat("condition.allofus13", locale));
			else if (Common.isEquals(allofus.get(x), "SI")) allofus.set(x, Prop.propFormat("condition.allofus14", locale));
		}
		
		return allofus;
	}
	
	public List<String> getSummary(List<String> targets) {
		List<String> tmp = new ArrayList<String>();
		if(targets.size() > 1) {
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

	public String checkInoutInfo2(Map<String, List<Map<String, Object>>> recvsInfo, String type) {
		if(Common.isEmpty(recvsInfo)) return null;
		int countN = 0;
		int countY = 0;

		String inOutDelimiter = Config.getString("ui.inout.delimiter");
		String[] inOuts = inOutDelimiter.split(",");

		List<Map<String, Object>> recipients = "recvs".equals(type) ? recvsInfo.values().stream().flatMap(List::stream).collect(Collectors.toList()) : recvsInfo.get(type);

		if (recipients != null) {
			for (Map<String, Object> recipient : recipients) {
				String insideValue = (String) recipient.get("inside");
				String id = (String) recipient.get("id");
				boolean inflag = matchesInOuts(id, inOuts);

				if (inflag) countY++;
				else if ("N".equals(insideValue)) countN++;
				else if ("Y".equals(insideValue)) countY++;

			}
		}

		return (countN == 0 && countY == 0) ? null : String.format("[%d/%d]", countN, countY);
	}

	private boolean matchesInOuts(String id, String[] inOuts) {
		for (String inOut : inOuts) {
			if (Common.isNotEmpty(inOut) && id.matches(".*" + inOut + ".*")) {
				return true;
			}
		}
		return false;
	}
	private String checkTargetInOut(List<IpRangeVO> ipRange, String[] inOuts, List<String> targets) {
		if(targets ==null || targets.size() == 0 ) return "";
		
		int inCount = 0;
		int outCount = 0;
		for( String target : targets) {
			boolean inflag = false;
			for(String inOut : inOuts) {
				if(Common.isNotEmpty(inOut) && target.matches(".*" + inOut + ".*")) {
					inflag = true;
					break;
				}
				
			}
			if(!inflag && ( ( target.split("\\.").length == 4 && NumberUtils.isNumber(target.split("\\.")[3]) ) || target.split("\\:").length > 2 )) {
				inflag = checkIpRange(ipRange, target);
			}
			
			if( !inflag) outCount++;
			else inCount++;
			
		}
		return "["+outCount+"/"+inCount+"]";
	}
	
	private boolean checkIpRange(List<IpRangeVO> ipRange, String target) {
		boolean result = false;
		String targetIpVersion = Common.getIPversion(target);
		
		for(IpRangeVO ipRangeVo : ipRange) {
			String startIp = Common.nvl(ipRangeVo.getStartIp());
			String endIp = Common.nvl(ipRangeVo.getEndIp());
			
			String ipVersion = Common.getIPversion(startIp);
			
			if(Common.isNotEquals(ipVersion, targetIpVersion)) continue;
						
			if( Common.isEquals(ipVersion, "4")) {
				long start_ip = Common.strIpToLong(startIp);
				long end_ip = Common.strIpToLong(endIp);
				long target_ip = Common.strIpToLong(target);
				if ( start_ip < target_ip && target_ip < end_ip) {
					result = true;
					break;
				}
			}else if( Common.isEquals(ipVersion, "6")) {
				IPv6AddressRange innerIpRange = IPv6AddressRange.fromFirstAndLast(IPv6Address.fromString(startIp), IPv6Address.fromString(endIp));
				if ( innerIpRange.contains(IPv6Address.fromString(target))) {
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

	public static String reSubject(SolrEdcVO edc) {
		EmsMessageVO msg = new EmsMessageVO();
		msg.setSubject(edc.getSubject());
		msg.setSvc(edc.getSvc());
		msg.setSrcIp(edc.getSrcip());
		msg.setDstIp(edc.getDstip());
		msg.setHost(edc.getHost());
		msg.setPath(edc.getPath());
		msg.setBody_snippet(edc.getBody_snippet());
		msg.setAttachname(edc.getAttachname());
		msg.setXRootMtr(edc.getXrootmtr());
		msg.setProtocol(edc.getProtocol());

		return reSubject(msg);
	}
	public static String reSubject(EmsMessageVO msg) {
		if(msg == null ) return Prop.propFormat("common.msg.nosubject");
		
		String subject = Common.nvl(msg.getSubject());
		String svc = Common.nvl(msg.getSvc());
		if (Common.isEmpty(svc)) return subject;
		String svc1 = Common.nvl(svc).substring(0, 1);
		String srcip = Common.nvl(msg.getSrcIp());
		String dstip = Common.nvl(msg.getDstIp());
		String host = Common.nvl(msg.getHost());
		String path = Common.nvl(msg.getPath());
		String webPrefix = Common.nvl(msg.getWebPrefix());
		if (subject.length() > 1) return subject.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "'");
		if (Common.isOrEquals(svc1, "F", "Q", "T")){
			if( Common.isNotEmpty(msg.getXRootMtr()) || Common.isEquals(svc1, "T")){
				if( svc.lastIndexOf("C") == 3 || svc.lastIndexOf("M") == 3 ) return Common.nvl(msg.getBody_snippet()).replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "'");
				else if( svc.lastIndexOf("F") == 3 ){
					List<String> list = msg.getAttachname();
					if( list != null) {
						if(Common.isNotEmpty(msg.getBody_snippet())) {
							return String.join(", ", list) +"<br/>"+Common.nvl(msg.getBody_snippet()).replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "'");
						}
						else return String.join(", ", list);
					}
					else return Common.EMPTY;
				}
				else if( svc.lastIndexOf("J") == 3 ) return "[" + Prop.propFormat("common.messenger.join.info") + "]";
				else if( svc.lastIndexOf("L") == 3 ) return "[" + Prop.propFormat("common.messenger.leave.info") + "]";
				else return srcip + "->" + dstip;
			}else if(svc.lastIndexOf("GP") > -1 || svc.lastIndexOf("DA") > -1 || svc.lastIndexOf("BI") > -1) {
				return Common.nvl(msg.getBody_snippet()).replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "'");
			}else return srcip + "->" + dstip;
			
		}
		else if (Common.isEquals(svc,"EMEC")) return Common.nvl(msg.getBody_snippet()).replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "'");
		else if (Common.isOrEquals(svc1, "U", "X") && Common.isNotEmpty(host)) return webPrefix + host + Common.nvl(path);
		else if (Common.isOrEquals(svc1, "X")) return srcip + "->" + dstip;
		else if (Common.isEquals(svc, "EMF-")) return "EP-[MAIL] FILE DOWNLOAD";
		else if (Common.isEquals(svc, "EBBF")) return "EP-[BBS] FILE DOWNLOAD";
		else if (Common.isEquals(svc, "EAAF")) return "EP-[APP] FILE DOWNLOAD";
		else if (Common.isEmpty(subject)) return Prop.propFormat("common.msg.nosubject");
		else return subject.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "'");
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
		
		if(obj.isEmpty()) {
			return target;
		}

		return obj.getString("name") + "<" + target + ">";
	}
	
	public String reRecvs(List<String> recvs, String summary, Map<String, List<Map<String, Object>>> recvsInfo) {
		String result = "";
		if (Common.isNotEmpty(recvsInfo)) result = checkInoutInfo2(recvsInfo,"recvs");
		else result = checkInOut(recvs);

		
		for(int i=0; i<recvs.size(); i++) {
			String target = recvs.get(i);
			
			if(!(summary.equals("Y") && i > 4)) {
				result += reRecvInfo(target);
			} else {
				
				result += " " + Prop.propFormat("condition.view.type8") + " " + (recvs.size() - 5) + " " + Prop.propFormat("condition.view.type9");
				return result;
				
			}
			
			if(i != (recvs.size()-1)) result += ",";
		}
		
		return result;
	}
	
	public List<String> reToccBcc(List<String> recvs, String summary) {
		String tmpStr = "";
		
		for(int i=0; i<recvs.size(); i++) {
			String target = recvs.get(i);
				
			if(!(summary.equals("Y") && i > 4)) {
				
				tmpStr = reRecvInfo(target);
				if(Common.isNotEquals(target, tmpStr)) {
					recvs.set(i, tmpStr);
				}
				
			} else {
				
				List<String> tmp = new ArrayList<>(recvs.subList(0, 5));
				int lastIdx = tmp.size()-1;
				
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
	public static String reUser(String recvId, String email, String name ) {
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
	public static EmsRecvVO reUserIp(EmsRecvVO u, String srcip, String dstip, String usrip) {
		List<String> ipList = new ArrayList<String>();
		String [] ips = Common.nvl(u.getIp()).split(", ");
		for(String ip : ips) {
			if(Common.isEquals(ip, usrip.trim())) ipList.add(ip);
			else if(Common.isEquals(ip, srcip.trim())) ipList.add(ip);
			else if(Common.isEquals(ip, dstip.trim())) ipList.add(ip);
		}
		u.setIp(Common.join(ipList, ","));
		
		return u;
	}
	
	public static String reUserEmail(EmsRecvVO u, String userEmail) {
		String recvEmail = u.getEMail();
		if(Common.isEmpty(recvEmail)) return recvEmail;
		
		List<String> emailList = new ArrayList<String>();
		String[] emails = Common.nvl(recvEmail).split(",");
		
		for (String email : emails) {
			if (Common.isEquals(email, userEmail) && chkEmail(userEmail, emails)) emailList.add(email);
		}
		
		if(emailList.size() == 0 ) return emails[0];
		else return Common.join(emailList, ",");
	}
	
	public static String reUserEmail(EmsRecvVO u) {
		return reUserEmail(u, u.getRecvId());
	}
	
	private static boolean chkEmail(String userEmail, String[] emails) {
		String pattern2 = "^([0-9a-zA-Z_.-]+)@([0-9a-zA-Z_-]+)(\\.[0-9a-zA-Z_-]+){1,6}$";
		
		if(Pattern.matches(pattern2, userEmail)) {
			return true;
		} else return false;
	}
	
	public static String reUser(EmsRecvVO u, String formatval) {
		List<String> checkSeparator = Common.toList("\\[\\],\\<\\>,\\(\\),\\{\\}, \"\", \'\', \", \"\', \'\"", ",");

		String [] keys = formatval.split("#");
		StringBuffer sb = new StringBuffer();
		int foundCnt = 0;
		String foundVal = "";
		for(int i=0; i<keys.length; i++) {
			if(i % 2 == 1){
				String keyValue = reNameInfo(u, keys[i]);
				if(Common.isNotEmpty(keyValue) && !keyValue.equals("-")) {
					sb.append(keyValue);
					foundCnt++;
					if(foundCnt == 1) foundVal = keyValue;
				}
			} else {
				sb.append(keys[i]);
			}
		}

		String rtnValue  = sb.toString();

		for(String check : checkSeparator) {
			rtnValue = rtnValue.replaceAll(check, "");
		}

		if(foundCnt == 1){
			return foundVal;
		} else if(foundCnt == 0){
			if(Common.isEquals(u.getUType(), "U")) return "-";
			else return Common.nvl(u.getRecvId());
		} else {
			return rtnValue;
		}
	}
	
	public static boolean checkValue(EmsRecvVO u, String [] test, int i){
		if(i < 2) return true;
		
		boolean result = Common.isEmpty(EmsReDefined.reNameInfo(u, test[i-2]));
		if(!result) return result;
		else{
			if(i>2){
				result = checkValue(u, test, i-2);
			}
		}
		return  result;
	}

	public static String reNameInfo(EmsRecvVO u, String key) {
		if(Common.isEquals(key, "name")) {
			if(Common.isEquals(u.getUType(), "U")) return Common.nvl(u.getName());
			else return Common.nvl(u.getName(),u.getRecvId());
		}
		else if(Common.isEquals(key, "deptnm")) return Common.nvl(u.getDeptNm());
		else if(Common.isEquals(key, "jikgubnm")) return Common.nvl(u.getJikgubNm());
		else if(Common.isEquals(key, "email")) {
			if(isValidEmail(u.getRecvId()) && Common.isNotEmpty(u.getName())) {
				return Common.nvl(u.getEMail(), u.getRecvId());
			}else return Common.nvl(u.getEMail());
		}
		else if(Common.isEquals(key, "businm")) return Common.nvl(u.getBusiNm());
		else if(Common.isEquals(key, "ip")) return Common.nvl(u.getIp());
		else if(Common.isEquals(key, "sabun")) return Common.nvl(u.getSabun());
		else return Common.EMPTY;
	}

	public static String reUser(String userid, String name) {
		StringBuffer sb = new StringBuffer();
		if (Common.isNotEmpty(name)) {
			sb.append(name);
			if (Common.isNotEmpty(userid)) { return sb.append("<").append(userid).append(">").toString(); }
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

	public String reCtime(String ctime) {
		if (Common.isEmpty(ctime)) return Common.EMPTY;
		return DateTime.parse(ctime, yyyyMMddHHmmss).toString(yyyyMMddHHmmss2);
	}

	public String reSvcNm(String svc, String protocol) {
		if (Common.isEmpty(svc)) return null;
		
		String protocolNm = Config.getProtocolNm(protocol);
		if(Common.isNotEmpty(protocolNm)) return Config.getServiceLv12Nm(svc) + " ["+protocolNm + "]";
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
		String cleanBody =	removeHtmlTags(body);
		if (cleanBody.length() > 200) return cleanBody.substring(0, 200) + "...";
		else return cleanBody + "...";
	}

	public  String removeHtmlTags(String input) {
		if (input == null) {
			return null;
		}
		return input.replaceAll("<[^>]*>", "");
	}
	
	public String interestUserStar(SolrEdcVO solrEdcVO) {
		if (Common.isNotEmpty(solrEdcVO.getUserid()) && Common.isNotEmpty(userIds.get(solrEdcVO.getUserid()))) return "Y";
		else return "N";
	}
	
	public String interestUserGroupColor(SolrEdcVO solrEdcVO) {
		if (Common.isEmpty(solrEdcVO.getUserid())) return null;
		return Common.nvl(userIds.get(solrEdcVO.getUserid()));
	}
}
