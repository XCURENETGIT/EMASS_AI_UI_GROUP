package com.xcurenet.emass.filter.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.filter.service.IpFilterVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class IpFilterControllerLog {

	@Autowired
	private AuditService auditService;

	private final String ENTER = "┌";
	
	public void getIpFilterList(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		
		auditVo.setInformation("["+Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("common.msg.tab")+": IP┌"+Prop.propFormat("condition.search_str")+": " + searchStr);
		
		auditService.insertAudit(request, auditVo);
	}
	
	public void insertIpFilter(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		
		String userIpAll = Common.nvl(param.get("userIpAll"));
		String userSIp = Common.nvl(param.get("userSIp"));
		String userEIp = Common.nvl(param.get("userEIp"));
		String userPortAll = Common.nvl(param.get("userPortAll"));
		String userSPort = Common.nvl(param.get("userSPort"));
		String userEPort = Common.nvl(param.get("userEPort"));
		String serverIpAll = Common.nvl(param.get("serverIpAll"));
		String serverSIp = Common.nvl(param.get("serverSIp"));
		String serverEIp = Common.nvl(param.get("serverEIp"));
		String serverPortAll = Common.nvl(param.get("serverPortAll"));
		String serverSPort = Common.nvl(param.get("serverSPort"));
		String serverEPort = Common.nvl(param.get("serverEPort"));
		String comment = Common.nvl(param.get("comment"));
		
		StringBuffer info = new StringBuffer();
		info.append("["+Prop.propFormat("common.msg.add")+"]").append(ENTER);
		info.append(Prop.propFormat("common.msg.tab")+": IP").append(ENTER);
		if( Common.isEmpty(userIpAll) ) info.append(Prop.propFormat("filterInfo.userip")+": " + userSIp + " ~ "+ userEIp).append(ENTER);
		else info.append(Prop.propFormat("filterInfo.userip")+": " + Prop.propFormat("common.msg.all")).append(ENTER);
		if( Common.isEmpty(userPortAll) ) info.append(Prop.propFormat("filterInfo.userport")+": " + userSPort + " ~ "+ userEPort).append(ENTER);
		else info.append(Prop.propFormat("filterInfo.userport")+": " + Prop.propFormat("common.msg.all")).append(ENTER);
		if( Common.isEmpty(serverIpAll) ) info.append(Prop.propFormat("filterInfo.serverip")+": " + serverSIp + " ~ "+ serverEIp).append(ENTER);
		else info.append(Prop.propFormat("filterInfo.serverip")+": " + Prop.propFormat("common.msg.all")).append(ENTER);
		if( Common.isEmpty(serverPortAll) ) info.append(Prop.propFormat("filterInfo.serverport")+": " + serverSPort + " ~ "+ serverEPort).append(ENTER);
		else info.append(Prop.propFormat("filterInfo.serverport")+": " + Prop.propFormat("common.msg.all"));
		info.append(Prop.propFormat("filterInfo.comment")+": " + comment);
		
		JSONArray data = Common.toJSONArray( param.get("deviceInfo"));
		if(data.size() > 0){
			info.append(ENTER).append(ENTER);
			info.append("["+Prop.propFormat("filterInfo.applydevice")+"]").append(ENTER);
			for (int i = 0; i < data.size(); i++) {
				JSONObject obj=data.getJSONObject(i);
				info.append(Prop.propFormat("filterInfo.dev.ip")+": " + Common.nvl(obj.get("code"))).append(ENTER);
				info.append(Prop.propFormat("filterInfo.dev.name")+": " + Common.nvl(obj.get("codeName")));
				
				if( i != data.size()-1) info.append(ENTER);
			}
		}

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}
	
	public void updateIpFilter(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		
		String userIpAll = Common.nvl(param.get("userIpAll"));
		String userSIp = Common.nvl(param.get("userSIp"));
		String userEIp = Common.nvl(param.get("userEIp"));
		String userPortAll = Common.nvl(param.get("userPortAll"));
		String userSPort = Common.nvl(param.get("userSPort"));
		String userEPort = Common.nvl(param.get("userEPort"));
		String serverIpAll = Common.nvl(param.get("serverIpAll"));
		String serverSIp = Common.nvl(param.get("serverSIp"));
		String serverEIp = Common.nvl(param.get("serverEIp"));
		String serverPortAll = Common.nvl(param.get("serverPortAll"));
		String serverSPort = Common.nvl(param.get("serverSPort"));
		String serverEPort = Common.nvl(param.get("serverEPort"));
		String comment = Common.nvl(param.get("comment"));
		
		StringBuffer info = new StringBuffer();
		info.append("["+Prop.propFormat("common.msg.add")+"]").append(ENTER);
		info.append(Prop.propFormat("common.msg.tab")+": IP").append(ENTER);
		if( Common.isEmpty(userIpAll) ) info.append(Prop.propFormat("filterInfo.userip")+": " + userSIp + " ~ "+ userEIp).append(ENTER);
		else info.append(Prop.propFormat("filterInfo.userip")+": " + Prop.propFormat("common.msg.all")).append(ENTER);
		if( Common.isEmpty(userPortAll) ) info.append(Prop.propFormat("filterInfo.userport")+": " + userSPort + " ~ "+ userEPort).append(ENTER);
		else info.append(Prop.propFormat("filterInfo.userport")+": " + Prop.propFormat("common.msg.all")).append(ENTER);
		if( Common.isEmpty(serverIpAll) ) info.append(Prop.propFormat("filterInfo.serverip")+": " + serverSIp + " ~ "+ serverEIp).append(ENTER);
		else info.append(Prop.propFormat("filterInfo.serverip")+": " + Prop.propFormat("common.msg.all")).append(ENTER);
		if( Common.isEmpty(serverPortAll) ) info.append(Prop.propFormat("filterInfo.serverport")+": " + serverSPort + " ~ "+ serverEPort).append(ENTER);
		else info.append(Prop.propFormat("filterInfo.serverport")+": " + Prop.propFormat("common.msg.all"));
		info.append(Prop.propFormat("filterInfo.comment")+": " + comment);
		
		JSONArray data = Common.toJSONArray( param.get("deviceInfo"));
		if(data.size() > 0){
			info.append(ENTER).append(ENTER);
			info.append("["+Prop.propFormat("filterInfo.applydevice")+"]").append(ENTER);
			for (int i = 0; i < data.size(); i++) {
				JSONObject obj=data.getJSONObject(i);
				info.append(Prop.propFormat("filterInfo.dev.ip")+": " + Common.nvl(obj.get("code"))).append(ENTER);
				info.append(Prop.propFormat("filterInfo.dev.name")+": " + Common.nvl(obj.get("codeName")));
				
				if( i != data.size()-1) info.append(ENTER);
			}
		}
		
		auditVo.setInformation(info.toString());
		
		auditService.insertAudit(request, auditVo);
	}
	
	public void deleteIpFilter(final HttpServletRequest request, AuditRequestVO auditVo) {

		JSONObject param = Common.getParam(request);
		String deleteData = Common.nvl(param.get("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		
		StringBuffer info = new StringBuffer();
		info.append("["+Prop.propFormat("common.msg.delete")+"]").append(ENTER);
		info.append(Prop.propFormat("common.msg.tab")+": IP").append(ENTER);
		for (int i = 0; i < data.size(); i++) {
			IpFilterVO filter = (IpFilterVO) JSONObject.toBean(data.getJSONObject(i), IpFilterVO.class);
			
			if( Common.isEmpty(filter.getUserIpAll()) ) info.append(Prop.propFormat("filterInfo.userip")+": " +  filter.getUserSIp() + " ~ "+ filter.getUserEIp()).append(ENTER);
			else info.append(Prop.propFormat("filterInfo.userip")+": " + Prop.propFormat("common.msg.all")).append(ENTER);
			if( Common.isEmpty(filter.getUserPortAll()) ) info.append(Prop.propFormat("filterInfo.userport")+": " + filter.getUserSPort() + " ~ "+ filter.getUserEPort()).append(ENTER);
			else info.append(Prop.propFormat("filterInfo.userport")+": " + Prop.propFormat("common.msg.all")).append(ENTER);
			if( Common.isEmpty(filter.getServerIpAll()) ) info.append(Prop.propFormat("filterInfo.serverip")+": " + filter.getServerSIp() + " ~ "+ filter.getServerEIp()).append(ENTER);
			else info.append(Prop.propFormat("filterInfo.serverip")+": " + Prop.propFormat("common.msg.all")).append(ENTER);
			if( Common.isEmpty(filter.getServerPortAll()) ) info.append(Prop.propFormat("filterInfo.serverport")+": " + filter.getServerSPort() + " ~ "+ filter.getServerEPort()).append(ENTER);
			else info.append(Prop.propFormat("filterInfo.serverport")+": " + Prop.propFormat("common.msg.all"));
			
		}
		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}
}
