package com.xcurenet.emass.adminFilter.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.adminFilter.web.AdminFilterController;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Slf4j
@Component
public class AdminFilterControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	private String getStr(JSONArray con, String key) {
		if( con != null ) return con.getJSONObject(0).get(key).toString();
		else return "";
	}
	
	public void insertAdminFilter(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String filterData = Common.nvl(param.get("filterData"));
		JSONObject data = Common.toJSONObject(filterData);
		
		String filterName = Common.nvl(data.get("filterName") );

		String AllLog = "";
		AllLog += "[" + Prop.propFormat("condition.save") + "] insertAdminFilter ";
		AllLog += "┌" + Prop.propFormat("condition.name") + " : " + filterName;
		
		auditVo.setInformation(AllLog);
		auditService.insertAudit(request, auditVo);
	}
	
	public void updateAdminFilter(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String filterData = Common.nvl(param.get("filterData"));
		JSONObject data = Common.toJSONObject(filterData);
		
		String filterName = Common.nvl(data.get("filterName") );

		String AllLog = "";
		AllLog += "[" + Prop.propFormat("condition.save") + "] updateAdminFilter ";
		AllLog += "┌" + Prop.propFormat("condition.name") + " : " + filterName;
		
		auditVo.setInformation(AllLog);
		auditService.insertAudit(request, auditVo);
	}

	public void deleteAdminFilter(final HttpServletRequest request, AuditRequestVO auditVo){
		
	}
	
	public void insertAdminFilterData(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String filterData = Common.nvl(param.get("filterData"));
		JSONObject data = Common.toJSONObject(filterData);
		
		String filterType = Common.nvl(data.get("filterType") );
		String filterName = Common.nvl(data.get("filterName") );

		String AllLog = "";
		AllLog += "[" + Prop.propFormat("condition.save") + "]";
		
		JSONArray con = data.getJSONArray("conditions");
		if( Common.isEquals(filterType, "D")) {
			AllLog += "┌" + Prop.propFormat("condition.name") + " : " + filterName;
			
			if(Common.isNotEmpty(getStr(con,"searchStr"))) AllLog += "┌" + Prop.propFormat("condition.search_str") + " : " + getStr(con,"searchStr");
			if(Common.isNotEmpty(getStr(con,"searchField"))){
				AllLog += "┌" + Prop.propFormat("condition.field.search")+" : ";
				if(Common.nvl(getStr(con,"searchField")).indexOf("subject") > -1 ) AllLog += Prop.propFormat("condition.subject")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("body") > -1 ) AllLog += Prop.propFormat("condition.body")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("fileName") > -1 ) AllLog += Prop.propFormat("condition.attach_name")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("attachType") > -1 ) AllLog += Prop.propFormat("condition.attach")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("host_str") > -1 ) AllLog += "Host ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("path") > -1 ) AllLog += "Path ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("srcip") > -1 ) AllLog += Prop.propFormat("condition.source")+"IP ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("dstip") > -1 ) AllLog += Prop.propFormat("condition.destination")+"IP ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("sender_str") > -1 ) AllLog += Prop.propFormat("condition.sender")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("sname") > -1 ) AllLog += Prop.propFormat("condition.sender_name")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("recvs_name") > -1 ) AllLog += Prop.propFormat("condition.recv_name")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("recvs") > -1 ) AllLog += Prop.propFormat("condition.recv")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("tname") > -1 ) AllLog += Prop.propFormat("condition.recv")+"("+Prop.propFormat("condition.to")+") ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("cname") > -1 ) AllLog += Prop.propFormat("condition.recv")+"("+Prop.propFormat("condition.cc")+") ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("bname") > -1 ) AllLog += Prop.propFormat("condition.recv")+"("+Prop.propFormat("condition.bcc")+") ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("usr_id") > -1 ) AllLog += Prop.propFormat("common.msg.account")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("attachname_str") > -1 ) AllLog += Prop.propFormat("condition.attach_name")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("attachname") > -1 ) AllLog += Prop.propFormat("condition.attach_name")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("ocr_attach") > -1 ) AllLog += Prop.propFormat("condition.attach")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("attach") > -1 ) AllLog += Prop.propFormat("condition.attach")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("ocr_attach") > -1 ) AllLog += "OCR ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("user_str") > -1 ) AllLog += Prop.propFormat("condition.user")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("userid") > -1 ) AllLog += Prop.propFormat("condition.user")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("user") > -1 ) AllLog += Prop.propFormat("condition.user")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("name") > -1 ) AllLog += Prop.propFormat("condition.user")+" ";
			}
			
			if(Common.isNotEmpty(getStr(con,"serviceType"))){
				String [] serviceTypes = Common.toArray(Common.nvl(getStr(con,"serviceType")), ",");
				String serviceNm  = Config.getServiceLv12Nm(serviceTypes[0]);
				String addInfo = "";
				if( serviceTypes.length > 1) addInfo = " "+Prop.propFormat("common.msg.etc_count", serviceTypes.length-1)+".";
				AllLog += "┌" + Prop.propFormat("condition.service") + " : " +  serviceNm + addInfo;
			}
			
			if(Common.isNotEmpty(getStr(con,"receiveSend"))){
				AllLog += "┌" + Prop.propFormat("condition.receive_send")+" : ";
				if( Common.isEquals(getStr(con,"receiveSend"), "I")) AllLog += Prop.propFormat("condition.receive");
				else if( Common.isEquals(getStr(con,"receiveSend"), "O")) AllLog += Prop.propFormat("condition.send");
			}
			
			String startDt = "";
			String endDt =  "";
			if(Common.nvz(getStr(con,"period")) == 1 && Common.isNotEmpty(getStr(con,"startDt"))){
				try {
					startDt = Common.formatDate3(Common.nvl(getStr(con,"startDt")));
				} catch (Exception e) {
					e.printStackTrace();
				}
				try {
					endDt = Common.formatDate3(Common.nvl(getStr(con,"endDt")));
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(Common.nvz(getStr(con,"period")) == 2 && Common.isNotEmpty(getStr(con,"startDt"))){
				try {
					String now = Common.getCurrentDate();
					startDt = Common.formatDate3(Common.plusDays(now, (Common.nvz(getStr(con,"startDt")) * -1)) + "000000");
					endDt = Common.formatDate3(Common.plusDays(now, (Common.nvz(getStr(con,"endDt")) * -1)) + "235959");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(Common.nvz(getStr(con,"period")) == 3){
				try {
					startDt = Common.formatDate3(Common.nvl(getStr(con,"startDt")));
				} catch (Exception e) {
					e.printStackTrace();
				}
				try {
					endDt = Common.formatDate3(Common.nvl(getStr(con,"endDt")));
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			if( Common.isNotEmpty(startDt)){
				AllLog += "┌" + Prop.propFormat("condition.period") + " : " + startDt + " ~ " + endDt;
			}
			if(Common.isNotEmpty(getStr(con,"ctimeWork"))){
				AllLog += "┌" + Prop.propFormat("condition.ctimework") + " : ";
				if( Common.isEquals(getStr(con,"ctimeWork"), "W")) AllLog += Prop.propFormat("condition.work");
				else if( Common.isEquals(getStr(con,"ctimeWork"), "R")) AllLog += Prop.propFormat("condition.notwork");
			}
			
			if(Common.isNotEmpty(getStr(con,"receivers"))) AllLog += "┌" + Prop.propFormat("condition.recv")+ (Common.nvl(getStr(con,"receivers_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"receivers"));
			if(Common.isNotEmpty(getStr(con,"senders"))) AllLog += "┌" + Prop.propFormat("condition.sender") + (Common.nvl(getStr(con,"senders_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"senders"));
			
			if(Common.isNotEmpty(getStr(con,"allOfus"))){
				AllLog += "┌" + Prop.propFormat("condition.allofus")+" : ";
				if( Common.isEquals(getStr(con,"allOfus"), "IA")) AllLog += Prop.propFormat("condition.allofus1");
				else if( Common.isEquals(getStr(con,"allOfus"), "EA")) AllLog += Prop.propFormat("condition.allofus2");
				else if( Common.isEquals(getStr(con,"allOfus"), "PA")) AllLog += Prop.propFormat("condition.allofus3");
				else if( Common.isEquals(getStr(con,"allOfus"), "IA|EA")) AllLog += Prop.propFormat("condition.allofus4");
				else if( Common.isEquals(getStr(con,"allOfus"), "EA|PA")) AllLog += Prop.propFormat("condition.allofus5");
				else if( Common.isEquals(getStr(con,"allOfus"), "IA|PA")) AllLog += Prop.propFormat("condition.allofus6");
				else if( Common.isEquals(getStr(con,"allOfus"), "IA|IT")) AllLog += Prop.propFormat("condition.allofus7");
				else if( Common.isEquals(getStr(con,"allOfus"), "ET|EA")) AllLog += Prop.propFormat("condition.allofus8");
				else if( Common.isEquals(getStr(con,"allOfus"), "PT|PA")) AllLog += Prop.propFormat("condition.allofus9");
				else if( Common.isEquals(getStr(con,"allOfus"), "IA|ET|IT|EA")) AllLog += Prop.propFormat("condition.allofus10");
				else if( Common.isEquals(getStr(con,"allOfus"), "IA|IT|PT|PA")) AllLog += Prop.propFormat("condition.allofus11");
				else if( Common.isEquals(getStr(con,"allOfus"), "ET|EA|PT|PA")) AllLog += Prop.propFormat("condition.allofus12");
				else if( Common.isEquals(getStr(con,"allOfus"), "SO")) AllLog += Prop.propFormat("condition.allofus13");
				else if( Common.isEquals(getStr(con,"allOfus"), "SI")) AllLog += Prop.propFormat("condition.allofus14");
			}
			
			if(Common.isNotEmpty(getStr(con,"userGroupSeq"))) {
				AllLog += "┌" + Prop.propFormat("userGroup.navi.title2") + (Common.nvl(getStr(con,"userGroupSeq_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"userGroupName"));
			}
			
			if(Common.isNotEmpty(getStr(con,"interGroup"))){
				AllLog += "┌" + Prop.propFormat("interest.user")+ (Common.nvl(getStr(con,"interGroup_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"interGroupName"));
			}
			
			if(Common.isNotEmpty(getStr(con,"busi"))){
				AllLog += "┌" + Prop.propFormat("common.org.busi") + (Common.nvl(getStr(con,"busi_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"busiStr"));
			}
			
			if(Common.isNotEmpty(getStr(con,"dept"))){
				AllLog += "┌" + Prop.propFormat("common.org.dept") + (Common.nvl(getStr(con,"dept_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"deptStr"));
			}
			
			if(Common.isNotEmpty(getStr(con,"readYn"))){
				AllLog += "┌" + Prop.propFormat("condition.isread")+" : ";
				if( Common.isEquals(getStr(con,"readYn"), "Y")) AllLog += Prop.propFormat("condition.read");
				else if( Common.isEquals(getStr(con,"readYn"), "N")) AllLog += Prop.propFormat("condition.unread");
			}
			
			if(Common.isNotEmpty(getStr(con,"attachYn"))){
				AllLog += "┌" + Prop.propFormat("condition.isattached")+" : ";
				if( Common.isEquals(getStr(con,"attachYn"), "Y")){
					AllLog += Prop.propFormat("condition.exist");
					if( Common.isNotEmpty(getStr(con,"attachVal"))){
						AllLog += "┌" + Prop.propFormat("java.log.selected.attach") + (Common.nvl(getStr(con,"attachYn_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"attachVal")).replaceAll("\\|", ",");
					}
				}
				else if( Common.isEquals(getStr(con,"attachYn"), "N")) AllLog += Prop.propFormat("condition.none");
			}
			
			if(Common.isNotEmpty(getStr(con,"realAttYn"))) {
				AllLog += "┌" + Prop.propFormat("condition.actual.attachment")+" : ";
				if( Common.isEquals(getStr(con,"realAttYn"), "Y")){
					AllLog += "┌" + Prop.propFormat("condition.onemore");
				} else AllLog += Prop.propFormat("condition.none");
			}
			
			if(Common.isNotEmpty(getStr(con,"drmYn"))) {
				AllLog += "┌" + "DRM : ";
				if( Common.isEquals(getStr(con,"drmYn"), "Y")){
					AllLog += "┌" + Prop.propFormat("condition.exist");
				} else AllLog += Prop.propFormat("condition.none");
			}
			
			if(Common.isNotEmpty(getStr(con,"keywordYn"))){
				AllLog += "┌" + Prop.propFormat("condition.iskeyword")+" : ";
				if( Common.isEquals(getStr(con,"keywordYn"), "Y")){
					AllLog += Prop.propFormat("condition.exist");
					if( Common.isNotEmpty(getStr(con,"keywordVal"))){
						AllLog += "┌" + Prop.propFormat("java.log.selected.keyword") + (Common.nvl(getStr(con,"keywordYn_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + getStr(con,"keywordStr");
					}
				}else if( Common.isEquals(getStr(con,"keywordYn"), "N")) AllLog += Prop.propFormat("condition.none");
			}
			
			if(Common.isNotEmpty(getStr(con,"regexpYn"))){
				AllLog += "┌" + Prop.propFormat("condition.regexp.isdetect")+" : ";
				if( Common.isEquals(getStr(con,"regexpYn"), "Y")){
					AllLog += Prop.propFormat("condition.exist");
					if( Common.isNotEmpty(getStr(con,"regexpVal"))){
						AllLog += "┌" + Prop.propFormat("java.log.selected.regexp")+" : " + getStr(con,"regexpStr");
					}
				}else if( Common.isEquals(getStr(con,"regexpYn"), "N")) AllLog += Prop.propFormat("condition.none");
			}
			
			if(!(Common.isEquals(getStr(con,"sizeOption"), "L") && Common.nvn(getStr(con,"sizeStartVal")) == 0)){
				
				if( Common.isEmpty(getStr(con,"sizeType"))) AllLog += "┌" + Prop.propFormat("condition.size.all")+" : ";
				else if( Common.isEquals(getStr(con,"sizeType"), "B")) AllLog += "┌" + Prop.propFormat("condition.size.body")+" : ";
				else if( Common.isEquals(getStr(con,"sizeType"), "A")) AllLog += "┌" + Prop.propFormat("condition.size.attach")+" : ";
				
				if( Common.isEquals(getStr(con,"sizeOption"), "L")){
					AllLog += Common.convertFileSize(Common.nvn(getStr(con,"sizeStartVal"))) + " " + Prop.propFormat("condition.over");
				}else if( Common.isEquals(getStr(con,"sizeOption"), "S")){
					AllLog += Common.convertFileSize(Common.nvn(getStr(con,"sizeStartVal"))) + " " + Prop.propFormat("condition.below");
				} else if( Common.isEquals(getStr(con,"sizeOption"), "B")){
					AllLog += Common.convertFileSize(Common.nvn(getStr(con,"sizeStartVal"))) + " ~ " + Common.convertFileSize(Common.nvn(getStr(con,"sizeEndVal")));
				}
			}
		} else {
			String query = Common.nvl( con.getJSONObject(0).get("query") );
			AllLog += "┌" + "filterName: " + filterName;
			AllLog += "┌" + "query: " + query;
		}
		
		auditVo.setInformation(AllLog);
		auditService.insertAudit(request, auditVo);
	}
	
	public void updateAdminFilterData(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String filterData = Common.nvl(param.get("filterData"));
		JSONObject data = Common.toJSONObject(filterData);
		
		String filterType = Common.nvl(data.get("filterType") );
		String filterName = Common.nvl(data.get("filterName") );

		String AllLog = "";
		AllLog += "[" + Prop.propFormat("condition.save") + "]";
		
		JSONArray con = data.getJSONArray("conditions");
		if( Common.isEquals(filterType, "D")) {
			AllLog += "┌" + Prop.propFormat("condition.name") + " : " + filterName;
			
			if(Common.isNotEmpty(getStr(con,"searchStr"))) AllLog += "┌" + Prop.propFormat("condition.search_str") + " : " + getStr(con,"searchStr");
			if(Common.isNotEmpty(getStr(con,"searchField"))){
				AllLog += "┌" + Prop.propFormat("condition.field.search")+" : ";
				if(Common.nvl(getStr(con,"searchField")).indexOf("subject") > -1 ) AllLog += Prop.propFormat("condition.subject")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("body") > -1 ) AllLog += Prop.propFormat("condition.body")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("fileName") > -1 ) AllLog += Prop.propFormat("condition.attach_name")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("attachType") > -1 ) AllLog += Prop.propFormat("condition.attach")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("host_str") > -1 ) AllLog += "Host ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("path") > -1 ) AllLog += "Path ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("srcip") > -1 ) AllLog += Prop.propFormat("condition.source")+"IP ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("dstip") > -1 ) AllLog += Prop.propFormat("condition.destination")+"IP ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("sender_str") > -1 ) AllLog += Prop.propFormat("condition.sender")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("sname") > -1 ) AllLog += Prop.propFormat("condition.sender_name")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("recvs_name") > -1 ) AllLog += Prop.propFormat("condition.recv_name")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("recvs") > -1 ) AllLog += Prop.propFormat("condition.recv")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("tname") > -1 ) AllLog += Prop.propFormat("condition.recv")+"("+Prop.propFormat("condition.to")+") ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("cname") > -1 ) AllLog += Prop.propFormat("condition.recv")+"("+Prop.propFormat("condition.cc")+") ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("bname") > -1 ) AllLog += Prop.propFormat("condition.recv")+"("+Prop.propFormat("condition.bcc")+") ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("usr_id") > -1 ) AllLog += Prop.propFormat("common.msg.account")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("attachname_str") > -1 ) AllLog += Prop.propFormat("condition.attach_name")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("attachname") > -1 ) AllLog += Prop.propFormat("condition.attach_name")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("ocr_attach") > -1 ) AllLog += Prop.propFormat("condition.attach")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("attach") > -1 ) AllLog += Prop.propFormat("condition.attach")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("ocr_attach") > -1 ) AllLog += "OCR ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("user_str") > -1 ) AllLog += Prop.propFormat("condition.user")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("userid") > -1 ) AllLog += Prop.propFormat("condition.user")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("user") > -1 ) AllLog += Prop.propFormat("condition.user")+" ";
				else if(Common.nvl(getStr(con,"searchField")).indexOf("name") > -1 ) AllLog += Prop.propFormat("condition.user")+" ";
			}
			
			if(Common.isNotEmpty(getStr(con,"serviceType"))){
				String [] serviceTypes = Common.toArray(Common.nvl(getStr(con,"serviceType")), ",");
				String serviceNm  = Config.getServiceLv12Nm(serviceTypes[0]);
				String addInfo = "";
				if( serviceTypes.length > 1) addInfo = " "+Prop.propFormat("common.msg.etc_count", serviceTypes.length-1)+".";
				AllLog += "┌" + Prop.propFormat("condition.service") + " : " +  serviceNm + addInfo;
			}
			
			if(Common.isNotEmpty(getStr(con,"receiveSend"))){
				AllLog += "┌" + Prop.propFormat("condition.receive_send")+" : ";
				if( Common.isEquals(getStr(con,"receiveSend"), "I")) AllLog += Prop.propFormat("condition.receive");
				else if( Common.isEquals(getStr(con,"receiveSend"), "O")) AllLog += Prop.propFormat("condition.send");
			}
			
			String startDt = "";
			String endDt =  "";
			if(Common.nvz(getStr(con,"period")) == 1 && Common.isNotEmpty(getStr(con,"startDt"))){
				try {
					startDt = Common.formatDate3(Common.nvl(getStr(con,"startDt")));
				} catch (Exception e) {
					e.printStackTrace();
				}
				try {
					endDt = Common.formatDate3(Common.nvl(getStr(con,"endDt")));
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(Common.nvz(getStr(con,"period")) == 2 && Common.isNotEmpty(getStr(con,"startDt"))){
				try {
					String now = Common.getCurrentDate();
					startDt = Common.plusDays(now, (Common.nvz(getStr(con,"startDt")) * -1)) + "000000";
					endDt = Common.plusDays(now, (Common.nvz(getStr(con,"endDt")) * -1)) + "235959";
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(Common.nvz(getStr(con,"period")) == 3){
				try {
					startDt = Common.formatDate3(Common.nvl(getStr(con,"startDt")));
				} catch (Exception e) {
					e.printStackTrace();
				}
				try {
					endDt = Common.formatDate3(Common.nvl(getStr(con,"endDt")));
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			if( Common.isNotEmpty(startDt)){
				AllLog += "┌" + Prop.propFormat("condition.period") + " : " + startDt + " ~ " + endDt;
			}
			if(Common.isNotEmpty(getStr(con,"ctimeWork"))){
				AllLog += "┌" + Prop.propFormat("condition.ctimework") + " : ";
				if( Common.isEquals(getStr(con,"ctimeWork"), "W")) AllLog += Prop.propFormat("condition.work");
				else if( Common.isEquals(getStr(con,"ctimeWork"), "R")) AllLog += Prop.propFormat("condition.notwork");
			}
			
			if(Common.isNotEmpty(getStr(con,"receivers"))) AllLog += "┌" + Prop.propFormat("condition.recv")+ (Common.nvl(getStr(con,"receivers_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"receivers"));
			if(Common.isNotEmpty(getStr(con,"senders"))) AllLog += "┌" + Prop.propFormat("condition.sender") + (Common.nvl(getStr(con,"senders_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"senders"));
			
			if(Common.isNotEmpty(getStr(con,"allOfus"))){
				AllLog += "┌" + Prop.propFormat("condition.allofus")+" : ";
				if( Common.isEquals(getStr(con,"allOfus"), "IA")) AllLog += Prop.propFormat("condition.allofus1");
				else if( Common.isEquals(getStr(con,"allOfus"), "EA")) AllLog += Prop.propFormat("condition.allofus2");
				else if( Common.isEquals(getStr(con,"allOfus"), "PA")) AllLog += Prop.propFormat("condition.allofus3");
				else if( Common.isEquals(getStr(con,"allOfus"), "IA|EA")) AllLog += Prop.propFormat("condition.allofus4");
				else if( Common.isEquals(getStr(con,"allOfus"), "EA|PA")) AllLog += Prop.propFormat("condition.allofus5");
				else if( Common.isEquals(getStr(con,"allOfus"), "IA|PA")) AllLog += Prop.propFormat("condition.allofus6");
				else if( Common.isEquals(getStr(con,"allOfus"), "IA|IT")) AllLog += Prop.propFormat("condition.allofus7");
				else if( Common.isEquals(getStr(con,"allOfus"), "ET|EA")) AllLog += Prop.propFormat("condition.allofus8");
				else if( Common.isEquals(getStr(con,"allOfus"), "PT|PA")) AllLog += Prop.propFormat("condition.allofus9");
				else if( Common.isEquals(getStr(con,"allOfus"), "IA|ET|IT|EA")) AllLog += Prop.propFormat("condition.allofus10");
				else if( Common.isEquals(getStr(con,"allOfus"), "IA|IT|PT|PA")) AllLog += Prop.propFormat("condition.allofus11");
				else if( Common.isEquals(getStr(con,"allOfus"), "ET|EA|PT|PA")) AllLog += Prop.propFormat("condition.allofus12");
				else if( Common.isEquals(getStr(con,"allOfus"), "SO")) AllLog += Prop.propFormat("condition.allofus13");
				else if( Common.isEquals(getStr(con,"allOfus"), "SI")) AllLog += Prop.propFormat("condition.allofus14");
			}
			
			if(Common.isNotEmpty(getStr(con,"userGroupSeq"))) {
				AllLog += "┌" + Prop.propFormat("userGroup.navi.title2") + (Common.nvl(getStr(con,"userGroupSeq_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"userGroupName"));
			}
			
			if(Common.isNotEmpty(getStr(con,"interGroup"))){
				AllLog += "┌" + Prop.propFormat("interest.user")+ (Common.nvl(getStr(con,"interGroup_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"interGroupName"));
			}
			
			if(Common.isNotEmpty(getStr(con,"busi"))){
				AllLog += "┌" + Prop.propFormat("common.org.busi") + (Common.nvl(getStr(con,"busi_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"busiStr"));
			}
			
			if(Common.isNotEmpty(getStr(con,"dept"))){
				AllLog += "┌" + Prop.propFormat("common.org.dept") + (Common.nvl(getStr(con,"dept_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"deptStr"));
			}
			
			if(Common.isNotEmpty(getStr(con,"readYn"))){
				AllLog += "┌" + Prop.propFormat("condition.isread")+" : ";
				if( Common.isEquals(getStr(con,"readYn"), "Y")) AllLog += Prop.propFormat("condition.read");
				else if( Common.isEquals(getStr(con,"readYn"), "N")) AllLog += Prop.propFormat("condition.unread");
			}
			
			if(Common.isNotEmpty(getStr(con,"attachYn"))){
				AllLog += "┌" + Prop.propFormat("condition.isattached")+" : ";
				if( Common.isEquals(getStr(con,"attachYn"), "Y")){
					AllLog += Prop.propFormat("condition.exist");
					if( Common.isNotEmpty(getStr(con,"attachVal"))){
						AllLog += "┌" + Prop.propFormat("java.log.selected.attach") + (Common.nvl(getStr(con,"attachYn_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + Common.nvl(getStr(con,"attachVal")).replaceAll("\\|", ",");
					}
				}
				else if( Common.isEquals(getStr(con,"attachYn"), "N")) AllLog += Prop.propFormat("condition.none");
			}

			if(Common.isNotEmpty(getStr(con,"realAttYn"))) {
				AllLog += "┌" + Prop.propFormat("condition.actual.attachment")+" : ";
				if( Common.isEquals(getStr(con,"realAttYn"), "Y")){
					AllLog += "┌" + Prop.propFormat("condition.onemore");
				} else AllLog += Prop.propFormat("condition.none");
			}
			
			if(Common.isNotEmpty(getStr(con,"drmYn"))) {
				AllLog += "┌" + "DRM : ";
				if( Common.isEquals(getStr(con,"drmYn"), "Y")){
					AllLog += "┌" + Prop.propFormat("condition.exist");
				} else AllLog += Prop.propFormat("condition.none");
			}
			
			if(Common.isNotEmpty(getStr(con,"keywordYn"))){
				AllLog += "┌" + Prop.propFormat("condition.iskeyword")+" : ";
				if( Common.isEquals(getStr(con,"keywordYn"), "Y")){
					AllLog += Prop.propFormat("condition.exist");
					if( Common.isNotEmpty(getStr(con,"keywordVal"))){
						AllLog += "┌" + Prop.propFormat("java.log.selected.keyword") + (Common.nvl(getStr(con,"keywordYn_not")).equals("Y") ? "(" + Prop.propFormat("query.make.except") + ")" : "") + " : " + getStr(con,"keywordStr");
					}
				}else if( Common.isEquals(getStr(con,"keywordYn"), "N")) AllLog += Prop.propFormat("condition.none");
			}
			
			if(Common.isNotEmpty(getStr(con,"regexpYn"))){
				AllLog += "┌" + Prop.propFormat("condition.regexp.isdetect")+" : ";
				if( Common.isEquals(getStr(con,"regexpYn"), "Y")){
					AllLog += Prop.propFormat("condition.exist");
					if( Common.isNotEmpty(getStr(con,"regexpVal"))){
						AllLog += "┌" + Prop.propFormat("java.log.selected.regexp")+" : " + getStr(con,"regexpStr");
					}
				}else if( Common.isEquals(getStr(con,"regexpYn"), "N")) AllLog += Prop.propFormat("condition.none");
			}
			
			if(!(Common.isEquals(getStr(con,"sizeOption"), "L") && Common.nvn(getStr(con,"sizeStartVal")) == 0)){
				
				if( Common.isEmpty(getStr(con,"sizeType"))) AllLog += "┌" + Prop.propFormat("condition.size.all")+" : ";
				else if( Common.isEquals(getStr(con,"sizeType"), "B")) AllLog += "┌" + Prop.propFormat("condition.size.body")+" : ";
				else if( Common.isEquals(getStr(con,"sizeType"), "A")) AllLog += "┌" + Prop.propFormat("condition.size.attach")+" : ";
				
				if( Common.isEquals(getStr(con,"sizeOption"), "L")){
					AllLog += Common.convertFileSize(Common.nvn(getStr(con,"sizeStartVal"))) + " " + Prop.propFormat("condition.over");
				}else if( Common.isEquals(getStr(con,"sizeOption"), "S")){
					AllLog += Common.convertFileSize(Common.nvn(getStr(con,"sizeStartVal"))) + " " + Prop.propFormat("condition.below");
				} else if( Common.isEquals(getStr(con,"sizeOption"), "B")){
					AllLog += Common.convertFileSize(Common.nvn(getStr(con,"sizeStartVal"))) + " ~ " + Common.convertFileSize(Common.nvn(getStr(con,"sizeEndVal")));
				}
			}
		} else {
			String query = Common.nvl( con.getJSONObject(0).get("query") );
			AllLog += "┌" + "filterName: " + filterName;
			AllLog += "┌" + "query: " + query;
		}
		
		auditVo.setInformation(AllLog);
		auditService.insertAudit(request, auditVo);
	}
}
