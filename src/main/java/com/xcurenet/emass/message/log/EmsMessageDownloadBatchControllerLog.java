package com.xcurenet.emass.message.log;


import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class EmsMessageDownloadBatchControllerLog {
	
	private static final String ENTER = "┌";
	
	@Autowired
	private AuditService auditService;
	
	@Autowired
	public SolrEdcControllerLog solrEdcControllerLog;

	
	
	public void getEmassMessageSaveBatchZip(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		
		final String searchType = Common.nvl(param.get("searchType"));
		final String exportFileExt = Common.nvl(param.get("exportFileExt"), "xlsx");
		
		//param.put("callType", "D");
		
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
		info.append("["+Prop.propFormat("common.msg.export")+Prop.propFormat("download.msg.search.count")+"]").append(ENTER);
		info.append(title);
		//info.append(solrEdcControllerLog.getListAudit(param));
		
		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}
	
	public void getEmassMessageSaveBatchPDF(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		
		final String searchType = Common.nvl(param.get("searchType"));
		
		//param.put("callType", "D");
		
		String title = "";
		if( Common.isEquals(searchType, "L")){ 
			title = Prop.propFormat("selectCodeAll.list")+" (pdf)";
		} else if( Common.isEquals(searchType, "LB")){ 
			title = Prop.propFormat("selectCodeAll.list")+" (pdf)+"+ Prop.propFormat("condition.body");
		} else if( Common.isEquals(searchType, "LBA")){ 
			title = Prop.propFormat("selectCodeAll.list")+" (pdf)+" + Prop.propFormat("condition.body") + "+" +Prop.propFormat("consent.attach"); 
		}
		
		StringBuffer info = new StringBuffer();
		info.append("["+Prop.propFormat("common.msg.export")+Prop.propFormat("download.msg.search.count")+"]").append(ENTER);
		info.append(title);
		//info.append(solrEdcControllerLog.getListAudit(param));
		
		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}
	
	public void getEmassMessageSaveBatchCSV(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		
		final String searchType = Common.nvl(param.get("searchType"));
		
		//param.put("callType", "D");
		
		String title = "";
		if( Common.isEquals(searchType, "L")){ 
			title = Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.text")+" csv)";
		} else if( Common.isEquals(searchType, "LB")){ 
			title = Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.text")+" csv)+" + Prop.propFormat("condition.body");
		} else if( Common.isEquals(searchType, "LBA")){ 
			title = Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.text")+" csv)+" + Prop.propFormat("condition.body") + "+" +Prop.propFormat("consent.attach"); 
		}
		
		StringBuffer info = new StringBuffer();
		info.append("["+Prop.propFormat("common.msg.export")+Prop.propFormat("download.msg.search.count")+"]").append(ENTER);
		info.append(title);
		//info.append(solrEdcControllerLog.getListAudit(param));
		
		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}
	
}
