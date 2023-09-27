package com.xcurenet.emass.message.log;


import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class SolrEdcControllerLog {
	@Autowired
	private AuditService auditService;
	
	private static final String ENTER = "┌";

	public void getList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		auditVo.setInformation(getListAudit(param));
		auditService.insertAudit(request, auditVo);
		/*
		JSONObject param = Common.getParam(request);
		JSONObject filterVal = Common.toJSONObject(param.get("data"));
		StringBuffer info = new StringBuffer();
		
		log.info("param : {}" + param);
		
		info.append("["+Prop.propFormat("java.log.search.msg_list")+"]").append(ENTER);
		try {
			if(Common.isNotEmpty(filterVal.get("folderSeq"))) {
				info.append(Prop.propFormat("filterInfo.messageFolder")).append(" : ").append(Common.nvl(filterVal.get("folderName")));
			}else {
				JSONArray conditions = filterVal.getJSONArray("conditions");
				for (int i = 0; i < conditions.size(); i++) {
					JSONObject condition = conditions.getJSONObject(i);
					
					if( condition.get("reSearch") != null && condition.getBoolean("reSearch") ) info.append("["+Prop.propFormat("java.log.research.condition")+"]").append(ENTER);
					//else info.append("[기본 검색 조건]").append(ENTER);
					if(Common.isNotEmpty(condition.get("searchField"))){
						info.append(Prop.propFormat("condition.field.search")+" : ");
						if(Common.nvl(condition.get("searchField")).indexOf("subject") > -1 ) info.append(Prop.propFormat("condition.subject")+" ");
						if(Common.nvl(condition.get("searchField")).indexOf("body") > -1 ) info.append(Prop.propFormat("condition.body")+" ");
						if(Common.nvl(condition.get("searchField")).indexOf("fileName") > -1 ) info.append(Prop.propFormat("condition.attach_name")+" ");
						if(Common.nvl(condition.get("searchField")).indexOf("attachType") > -1 ) info.append(Prop.propFormat("condition.attach")+" ");
						if(Common.nvl(condition.get("searchField")).indexOf("host_str") > -1 ) info.append("Host ");
						if(Common.nvl(condition.get("searchField")).indexOf("path") > -1 ) info.append("Path ");
						if(Common.nvl(condition.get("searchField")).indexOf("srcip") > -1 ) info.append(Prop.propFormat("condition.source")+"IP ");
						if(Common.nvl(condition.get("searchField")).indexOf("dstip") > -1 ) info.append(Prop.propFormat("condition.destination")+"IP ");
						if(Common.nvl(condition.get("searchField")).indexOf("sender_str") > -1 ) info.append(Prop.propFormat("condition.sender")+" ");
						if(Common.nvl(condition.get("searchField")).indexOf("sname") > -1 ) info.append(Prop.propFormat("condition.sender_name")+" ");
						if(Common.nvl(condition.get("searchField")).indexOf("recvs") > -1 ) info.append(Prop.propFormat("condition.recv")+" ");
						if(Common.nvl(condition.get("searchField")).indexOf("recvs_name") > -1 ) info.append(Prop.propFormat("condition.recv_name")+" ");
						if(Common.nvl(condition.get("searchField")).indexOf("tname") > -1 ) info.append(Prop.propFormat("condition.recv")+"("+Prop.propFormat("condition.to")+") ");
						if(Common.nvl(condition.get("searchField")).indexOf("cname") > -1 ) info.append(Prop.propFormat("condition.recv")+"("+Prop.propFormat("condition.cc")+") ");
						if(Common.nvl(condition.get("searchField")).indexOf("bname") > -1 ) info.append(Prop.propFormat("condition.recv")+"("+Prop.propFormat("condition.bcc")+") ");
						if(Common.nvl(condition.get("searchField")).indexOf("usr_id") > -1 ) info.append(Prop.propFormat("condition.usrid")+" ");
						info.append(ENTER);
					}
					if(Common.isNotEmpty(condition.get("searchStr"))) info.append(Prop.propFormat("condition.search_str")+" : ").append(Common.nvl(condition.get("searchStr"))).append(ENTER);
					
					String startDt = "";
					String endDt =  "";
					if(Common.nvz(condition.get("period")) == 1 && Common.isNotEmpty(condition.get("startDt"))){
						startDt = Common.formatDate3(Common.nvl(condition.get("startDt")));
						endDt = Common.formatDate3(Common.nvl(condition.get("endDt")));
					}else if(Common.nvz(condition.get("period")) == 2 && Common.isNotEmpty(condition.get("startDt"))){
						String now = Common.getCurrentDate();
						startDt = Common.plusDays(now, (Common.nvz(condition.get("startDt")) * -1)) + "000000";
						endDt = Common.plusDays(now, (Common.nvz(condition.get("endDt")) * -1)) + "235959";
					}else if(Common.nvz(condition.get("period")) == 3){
						startDt = Common.formatDate3(Common.nvl(condition.get("startDt")));
						endDt = Common.formatDate3(Common.nvl(condition.get("endDt")));
					}
					if( Common.isNotEmpty(startDt)){
						info.append(Prop.propFormat("condition.period")+" : ").append(startDt).append(" ~ ").append(endDt).append(ENTER);
					}
					if(Common.isNotEmpty(condition.get("ctimeWork"))){
						info.append(Prop.propFormat("condition.ctimework")+" : ");
						if( Common.isEquals(condition.get("ctimeWork"), "W")) info.append(Prop.propFormat("condition.work")).append(ENTER);
						else if( Common.isEquals(condition.get("ctimeWork"), "R")) info.append(Prop.propFormat("condition.notwork")).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("serviceType"))){
						String [] serviceTypes = Common.toArray(Common.nvl(condition.get("serviceType")), ",");
						String serviceNm  = Config.getServiceLv12Nm(serviceTypes[0]);
						String addInfo = "";
						if( serviceTypes.length > 1) addInfo = " "+Prop.propFormat("common.msg.etc_count", serviceTypes.length-1)+".";
						info.append(Prop.propFormat("condition.service")+" : ").append(serviceNm).append(addInfo).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("senders"))) info.append(Prop.propFormat("condition.sender")+" : ").append(Common.nvl(condition.get("senders"))).append(ENTER);
					if(Common.isNotEmpty(condition.get("receivers"))) info.append(Prop.propFormat("condition.recv")+" : ").append(Common.nvl(condition.get("receivers"))).append(ENTER);
					if(Common.isNotEmpty(condition.get("interGroup"))){
						info.append(Prop.propFormat("interest.user")+" : ").append(Common.nvl(condition.get("interGroupName"))).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("receiveSend"))){
						info.append(Prop.propFormat("condition.receive_send")+" : ");
						if( Common.isEquals(condition.get("receiveSend"), "I")) info.append(Prop.propFormat("condition.receive")).append(ENTER);
						else if( Common.isEquals(condition.get("receiveSend"), "O")) info.append(Prop.propFormat("condition.send")).append(ENTER);
					}
					if(Common.isNotEmpty(condition.get("readYn"))){
						info.append(Prop.propFormat("condition.isread")+" : ");
						if( Common.isEquals(condition.get("readYn"), "Y")) info.append(Prop.propFormat("condition.read")).append(ENTER);
						else if( Common.isEquals(condition.get("readYn"), "N")) info.append(Prop.propFormat("condition.unread")).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("busi"))){
						info.append(Prop.propFormat("common.org.busi")+" : ").append(Common.nvl(condition.get("busiStr"))).append(ENTER);
					}
					if(Common.isNotEmpty(condition.get("dept"))){
						info.append(Prop.propFormat("common.org.dept")+" : ").append(Common.nvl(condition.get("deptStr"))).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("attachYn"))){
						info.append(Prop.propFormat("condition.isattached")+" : ");
						if( Common.isEquals(condition.get("attachYn"), "Y")){
							info.append(Prop.propFormat("condition.exist")).append(ENTER);
							if( Common.isNotEmpty(condition.get("attachVal"))){
								info.append(Prop.propFormat("java.log.selected.attach")+" : ").append(Common.nvl(condition.get("attachVal")).replaceAll("\\|", ",")).append(ENTER);
							}
						}
						else if( Common.isEquals(condition.get("attachYn"), "N")) info.append(Prop.propFormat("condition.none")).append(ENTER);
					}
					if(Common.isNotEmpty(condition.get("keywordYn"))){
						info.append(Prop.propFormat("condition.iskeyword")+" : ");
						if( Common.isEquals(condition.get("keywordYn"), "Y")){
							info.append(Prop.propFormat("condition.exist")).append(ENTER);
							if( Common.isNotEmpty(condition.get("keywordVal"))){
								info.append(Prop.propFormat("java.log.selected.regexp")+" : ").append(condition.get("regexpStr")).append(ENTER);
							}
						}else if( Common.isEquals(condition.get("keywordYn"), "N")) info.append(Prop.propFormat("condition.none")).append(ENTER);
					}
					if(Common.isNotEmpty(condition.get("regexpYn"))){
						info.append(Prop.propFormat("condition.regexp.isdetect")+" : ");
						if( Common.isEquals(condition.get("regexpYn"), "Y")){
							info.append(Prop.propFormat("condition.exist")).append(ENTER);
							if( Common.isNotEmpty(condition.get("regexpVal"))){
								info.append(Prop.propFormat("java.log.selected.regexp")+" : ").append(condition.get("regexpStr")).append(ENTER);
							}
						}else if( Common.isEquals(condition.get("regexpYn"), "N")) info.append(Prop.propFormat("condition.none")).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("allOfus"))){
						info.append(Prop.propFormat("condition.allofus")+" : ");
						if( Common.isEquals(condition.get("allOfus"), "IA")) info.append(Prop.propFormat("condition.allofus1")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "EA")) info.append(Prop.propFormat("condition.allofus2")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "PA")) info.append(Prop.propFormat("condition.allofus3")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "IA|EA")) info.append(Prop.propFormat("condition.allofus4")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "EA|PA")) info.append(Prop.propFormat("condition.allofus5")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "IA|PA")) info.append(Prop.propFormat("condition.allofus6")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "IA|IT")) info.append(Prop.propFormat("condition.allofus7")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "ET|EA")) info.append(Prop.propFormat("condition.allofus8")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "PT|PA")) info.append(Prop.propFormat("condition.allofus9")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "IA|ET|IT|EA")) info.append(Prop.propFormat("condition.allofus10")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "IA|IT|PT|PA")) info.append(Prop.propFormat("condition.allofus11")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "ET|EA|PT|PA")) info.append(Prop.propFormat("condition.allofus12")).append(ENTER);
					}
					if(!(Common.isEquals(condition.get("sizeOption"), "L") && Common.nvn(condition.get("sizeStartVal")) == 0)){
						
						if( Common.isEmpty(condition.get("sizeType"))) info.append(Prop.propFormat("condition.size.all")+" : ");
						else if( Common.isEquals(condition.get("sizeType"), "B")) info.append(Prop.propFormat("condition.size.body")+" : ");
						else if( Common.isEquals(condition.get("sizeType"), "A")) info.append(Prop.propFormat("condition.size.attach")+" : ");
						
						if( Common.isEquals(condition.get("sizeOption"), "L")){
							info.append(Common.convertFileSize(Common.nvn(condition.get("sizeStartVal")))).append(" "+Prop.propFormat("condition.over")).append(ENTER);
						}else if( Common.isEquals(condition.get("sizeOption"), "S")){
							info.append(Common.convertFileSize(Common.nvn(condition.get("sizeStartVal")))).append(" "+Prop.propFormat("condition.below")).append(ENTER);
						} else if( Common.isEquals(condition.get("sizeOption"), "B")){
							info.append(Common.convertFileSize(Common.nvn(condition.get("sizeStartVal")))).append(" ~ ").append(Common.convertFileSize(Common.nvn(condition.get("sizeEndVal")))).append(ENTER);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
		*/
	}
	
	public void getListRecommend(final HttpServletRequest request, AuditRequestVO auditVo) {
		/*JSONObject param = Common.getParam(request);
		auditVo.setInformation(getListAudit(param));
		auditService.insertAudit(request, auditVo);*/
	}
	
	public String getListAudit(JSONObject param) {
		JSONObject filterVal = Common.toJSONObject(param.get("data"));
		StringBuffer info = new StringBuffer();
		
		if(Common.isNotEquals(param.get("callType"), "D")) {
			info.append("["+Prop.propFormat("java.log.search.msg_list")+"]").append(ENTER);
		}
		try {
			if(Common.isNotEmpty(filterVal.get("folderSeq"))) {
				info.append(Prop.propFormat("filterInfo.messageFolder")).append(" : ").append(Common.nvl(filterVal.get("folderName"))).append(ENTER);
			}else {
				
				if(Common.isNotEmpty(filterVal.get("filterName"))) {
					info.append(Prop.propFormat("condition.name")).append(" : ").append(Common.nvl(filterVal.get("filterName"))).append(ENTER);
				}
				
				JSONArray conditions = new JSONArray();
			
				if(Common.isEquals(param.get("callType"), "D")) {
					final JSONObject condition = Common.toJSONObject(param.get("searchCondition"));
					conditions = condition.getJSONArray("conditions");
				} else {
					conditions = filterVal.getJSONArray("conditions");
				}
				
				for (int i = 0; i < conditions.size(); i++) {
					JSONObject condition = conditions.getJSONObject(i);
					
					String query = Common.nvl(condition.get("query"));
					if( Common.isNotEmpty(query)) {
						info.append(Prop.propFormat("message.msg.deepsearch")+" : ").append(ENTER).append(query).append(ENTER);
						continue;
					}
					
					
					
					if( condition.get("reSearch") != null && condition.getBoolean("reSearch") ) info.append("["+Prop.propFormat("java.log.research.condition")+"]").append(ENTER);
					if(Common.isNotEmpty(condition.get("searchStr"))) info.append(Prop.propFormat("condition.search_str")+" : ").append(Common.nvl(condition.get("searchStr"))).append(ENTER);
					//else info.append("[기본 검색 조건]").append(ENTER);
					if(Common.isNotEmpty(condition.get("searchField"))){
						info.append(Prop.propFormat("condition.field.search")+" : ");
						if(Common.nvl(condition.get("searchField")).indexOf("subject") > -1 ) info.append(Prop.propFormat("condition.subject")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("body") > -1 ) info.append(Prop.propFormat("condition.body")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("fileName") > -1 ) info.append(Prop.propFormat("condition.attach_name")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("attachType") > -1 ) info.append(Prop.propFormat("condition.attach")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("host_str") > -1 ) info.append("Host ");
						else if(Common.nvl(condition.get("searchField")).indexOf("path") > -1 ) info.append("Path ");
						else if(Common.nvl(condition.get("searchField")).indexOf("srcip") > -1 ) info.append(Prop.propFormat("condition.source")+"IP ");
						else if(Common.nvl(condition.get("searchField")).indexOf("dstip") > -1 ) info.append(Prop.propFormat("condition.destination")+"IP ");
						else if(Common.nvl(condition.get("searchField")).indexOf("sender_str") > -1 ) info.append(Prop.propFormat("condition.sender")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("sname") > -1 ) info.append(Prop.propFormat("condition.sender_name")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("recvs_name") > -1 ) info.append(Prop.propFormat("condition.recv_name")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("recvs") > -1 ) info.append(Prop.propFormat("condition.recv")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("tname") > -1 ) info.append(Prop.propFormat("condition.recv")+"("+Prop.propFormat("condition.to")+") ");
						else if(Common.nvl(condition.get("searchField")).indexOf("cname") > -1 ) info.append(Prop.propFormat("condition.recv")+"("+Prop.propFormat("condition.cc")+") ");
						else if(Common.nvl(condition.get("searchField")).indexOf("bname") > -1 ) info.append(Prop.propFormat("condition.recv")+"("+Prop.propFormat("condition.bcc")+") ");
						else if(Common.nvl(condition.get("searchField")).indexOf("usr_id") > -1 ) info.append(Prop.propFormat("common.msg.account")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("attachname_str") > -1 ) info.append(Prop.propFormat("condition.attach_name")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("attachname") > -1 ) info.append(Prop.propFormat("condition.attach_name")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("ocr_attach") > -1 ) info.append(Prop.propFormat("condition.attach")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("attach") > -1 ) info.append(Prop.propFormat("condition.attach")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("ocr_attach") > -1 ) info.append("OCR ");
						else if(Common.nvl(condition.get("searchField")).indexOf("user_str") > -1 ) info.append(Prop.propFormat("condition.user")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("userid") > -1 ) info.append(Prop.propFormat("condition.user")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("user") > -1 ) info.append(Prop.propFormat("condition.user")+" ");
						else if(Common.nvl(condition.get("searchField")).indexOf("name") > -1 ) info.append(Prop.propFormat("condition.user")+" ");
						
						info.append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("serviceType"))){
						String [] serviceTypes = Common.toArray(Common.nvl(condition.get("serviceType")), ",");
						String serviceNm  = Config.getServiceLv12Nm(serviceTypes[0]);
						String addInfo = "";
						if( serviceTypes.length > 1) addInfo = " "+Prop.propFormat("common.msg.etc_count", serviceTypes.length-1)+".";
						info.append(Prop.propFormat("condition.service")+" : ").append(serviceNm).append(addInfo).append(ENTER);
					}
					
					String startDt = "";
					String endDt =  "";
					if(Common.nvz(condition.get("period")) == 1 && Common.isNotEmpty(condition.get("startDt"))){
						startDt = Common.formatDate3(Common.nvl(condition.get("startDt")));
						endDt = Common.formatDate3(Common.nvl(condition.get("endDt")));
					}else if(Common.nvz(condition.get("period")) == 2 && Common.isNotEmpty(condition.get("startDt"))){
						String now = Common.getCurrentDate();
						startDt = Common.plusDays(now, (Common.nvz(condition.get("startDt")) * -1)) + "000000";
						endDt = Common.plusDays(now, (Common.nvz(condition.get("endDt")) * -1)) + "235959";
					}else if(Common.nvz(condition.get("period")) == 3){
						startDt = Common.formatDate3(Common.nvl(condition.get("startDt")));
						endDt = Common.formatDate3(Common.nvl(condition.get("endDt")));
					}
					if( Common.isNotEmpty(startDt)){
						info.append(Prop.propFormat("condition.period")+" : ").append(startDt).append(" ~ ").append(endDt).append(ENTER);
					}
					if(Common.isNotEmpty(condition.get("ctimeWork"))){
						info.append(Prop.propFormat("condition.ctimework")+" : ");
						if( Common.isEquals(condition.get("ctimeWork"), "W")) info.append(Prop.propFormat("condition.work")).append(ENTER);
						else if( Common.isEquals(condition.get("ctimeWork"), "R")) info.append(Prop.propFormat("condition.notwork")).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("receiveSend"))){
						info.append(Prop.propFormat("condition.receive_send")+" : ");
						if( Common.isEquals(condition.get("receiveSend"), "I")) info.append(Prop.propFormat("condition.receive")).append(ENTER);
						else if( Common.isEquals(condition.get("receiveSend"), "O")) info.append(Prop.propFormat("condition.send")).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("receivers"))) info.append(Prop.propFormat("condition.recv")+ (Common.nvl(condition.get("receivers_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : ").append(Common.nvl(condition.get("receivers"))).append(ENTER);
					
					if(Common.isNotEmpty(condition.get("senders"))) info.append(Prop.propFormat("condition.sender") + (Common.nvl(condition.get("senders_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : ").append(Common.nvl(condition.get("senders"))).append(ENTER);
					
					if(Common.isNotEmpty(condition.get("allOfus"))){
						info.append(Prop.propFormat("condition.allofus")+" : ");
						if( Common.isEquals(condition.get("allOfus"), "IA")) info.append(Prop.propFormat("condition.allofus1")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "EA")) info.append(Prop.propFormat("condition.allofus2")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "PA")) info.append(Prop.propFormat("condition.allofus3")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "IA|EA")) info.append(Prop.propFormat("condition.allofus4")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "EA|PA")) info.append(Prop.propFormat("condition.allofus5")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "IA|PA")) info.append(Prop.propFormat("condition.allofus6")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "IA|IT")) info.append(Prop.propFormat("condition.allofus7")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "ET|EA")) info.append(Prop.propFormat("condition.allofus8")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "PT|PA")) info.append(Prop.propFormat("condition.allofus9")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "IA|ET|IT|EA")) info.append(Prop.propFormat("condition.allofus10")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "IA|IT|PT|PA")) info.append(Prop.propFormat("condition.allofus11")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "ET|EA|PT|PA")) info.append(Prop.propFormat("condition.allofus12")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "SO")) info.append(Prop.propFormat("condition.allofus13")).append(ENTER);
						else if( Common.isEquals(condition.get("allOfus"), "SI")) info.append(Prop.propFormat("condition.allofus14")).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("userGroupSeq"))) {
						info.append(Prop.propFormat("userGroup.navi.title2") + (Common.nvl(condition.get("userGroupSeq_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : ").append(Common.nvl(condition.get("userGroupName"))).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("interGroup"))){
						info.append(Prop.propFormat("interest.user")+ (Common.nvl(condition.get("interGroup_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : ").append(Common.nvl(condition.get("interGroupName"))).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("busi"))){
						info.append(Prop.propFormat("common.org.busi") + (Common.nvl(condition.get("busi_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : ").append(Common.nvl(condition.get("busiStr"))).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("dept"))){
						info.append(Prop.propFormat("common.org.dept") + (Common.nvl(condition.get("dept_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : ").append(Common.nvl(condition.get("deptStr"))).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("readYn"))){
						info.append(Prop.propFormat("condition.isread")+" : ");
						if( Common.isEquals(condition.get("readYn"), "Y")) info.append(Prop.propFormat("condition.read")).append(ENTER);
						else if( Common.isEquals(condition.get("readYn"), "N")) info.append(Prop.propFormat("condition.unread")).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("attachYn"))){
						info.append(Prop.propFormat("condition.isattached")+" : ");
						if( Common.isEquals(condition.get("attachYn"), "Y")){
							info.append(Prop.propFormat("condition.exist")).append(ENTER);
							if( Common.isNotEmpty(condition.get("attachVal"))){
								info.append(Prop.propFormat("java.log.selected.attach") + (Common.nvl(condition.get("attachYn_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : ").append(Common.nvl(condition.get("attachVal")).replaceAll("\\|", ",")).append(ENTER);
							}
						}
						else if( Common.isEquals(condition.get("attachYn"), "N")) info.append(Prop.propFormat("condition.none")).append(ENTER);
					}
					if(Common.isNotEmpty(condition.get("realAttYn"))) {
						info.append(Prop.propFormat("condition.actual.attachment")+" : ");
						if( Common.isEquals(condition.get("realAttYn"), "Y")){
							info.append(Prop.propFormat("condition.onemore")).append(ENTER);
						}else info.append(Prop.propFormat("condition.none")).append(ENTER);
					}
					if(Common.isNotEmpty(condition.get("drmYn"))) {
						info.append("DRM : ");
						if( Common.isEquals(condition.get("drmYn"), "Y")){
							info.append(Prop.propFormat("condition.exist")).append(ENTER);
						}else info.append(Prop.propFormat("condition.none")).append(ENTER);
					}
					if(Common.isNotEmpty(condition.get("keywordYn"))){
						info.append(Prop.propFormat("condition.iskeyword")+" : ");
						if( Common.isEquals(condition.get("keywordYn"), "Y")){
							info.append(Prop.propFormat("condition.exist")).append(ENTER);
							if( Common.isNotEmpty(condition.get("keywordVal"))){
								info.append(Prop.propFormat("java.log.selected.keyword") + (Common.nvl(condition.get("keywordYn_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : ").append(condition.get("keywordStr")).append(ENTER);;
							}
						}else if( Common.isEquals(condition.get("keywordYn"), "N")) info.append(Prop.propFormat("condition.none")).append(ENTER);
					}
					if(Common.isNotEmpty(condition.get("regexpYn"))){
						info.append(Prop.propFormat("condition.regexp.isdetect")+" : ");
						if( Common.isEquals(condition.get("regexpYn"), "Y")){
							info.append(Prop.propFormat("condition.exist")).append(ENTER);
							if( Common.isNotEmpty(condition.get("regexpVal"))){
								info.append(Prop.propFormat("java.log.selected.regexp")+" : ").append(condition.get("regexpStr")).append(ENTER);
							}
						}else if( Common.isEquals(condition.get("regexpYn"), "N")) info.append(Prop.propFormat("condition.none")).append(ENTER);
					}
					
					if(Common.isNotEmpty(condition.get("sctYn"))) {
						info.append(Prop.propFormat("condition.sct") + " : ");
						if( Common.isEquals(condition.get("sctYn"), "Y")){
							info.append(Prop.propFormat("condition.exist")).append(ENTER);
						}else info.append(Prop.propFormat("condition.none")).append(ENTER);
					}
					if(!(Common.isEquals(condition.get("sizeOption"), "L") && Common.isEmpty(condition.get("sizeStartVal")))){
						
						if( Common.isEmpty(condition.get("sizeType"))) info.append(Prop.propFormat("condition.size.all")+" : ");
						else if( Common.isEquals(condition.get("sizeType"), "B")) info.append(Prop.propFormat("condition.size.body")+" : ");
						else if( Common.isEquals(condition.get("sizeType"), "A")) info.append(Prop.propFormat("condition.size.attach")+" : ");
						
						if( Common.isEquals(condition.get("sizeOption"), "L")){
							info.append(Common.convertFileSize(Common.nvl(condition.get("sizeStartVal")))).append(" "+Prop.propFormat("condition.over")).append(ENTER);
						}else if( Common.isEquals(condition.get("sizeOption"), "S")){
							info.append(Common.convertFileSize(Common.nvl(condition.get("sizeStartVal")))).append(" "+Prop.propFormat("condition.below")).append(ENTER);
						} else if( Common.isEquals(condition.get("sizeOption"), "B")){
							info.append(Common.convertFileSize(Common.nvl(condition.get("sizeStartVal")))).append(" ~ ").append(Common.convertFileSize(Common.nvl(condition.get("sizeEndVal")))).append(ENTER);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return info.toString();
	}
}
