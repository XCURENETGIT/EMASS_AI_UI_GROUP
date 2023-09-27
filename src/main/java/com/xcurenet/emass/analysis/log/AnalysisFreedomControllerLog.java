package com.xcurenet.emass.analysis.log;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.service.service.ServiceTypeService;

import net.sf.json.JSONObject;

@Component
public class AnalysisFreedomControllerLog {

	@Autowired
	private AuditService auditService;
	@Autowired
	private ServiceTypeService serviceTypeService;

	public void freedomView(final HttpServletRequest request, AuditRequestVO auditVo) {

		String tabIdx = (String)request.getParameter("tabIdx");
		String[] tmpAndOr = request.getParameterValues("andOr"+tabIdx);
		int size = tmpAndOr == null ? 0 : tmpAndOr.length;
		String[] andOr = new String[size+1];
		andOr[0] = "";
		for (int i = 1, j = 0; i < andOr.length; i++, j++) {
			andOr[i] = tmpAndOr[j];
		}

		String[] beforePparen = request.getParameterValues("beforePparen"+tabIdx);
		String[] termsColumn = request.getParameterValues("termsColumn"+tabIdx);
		String[] compare = request.getParameterValues("compare"+tabIdx);
		String[] context = request.getParameterValues("context"+tabIdx);
		String[] startDate = request.getParameterValues("startDate"+tabIdx);
		String[] endDate = request.getParameterValues("endDate"+tabIdx);
		String[] serviceCd = request.getParameterValues("serviceCd"+tabIdx);
		String[] afterPparen = request.getParameterValues("afterPparen"+tabIdx);
		String[] columnData = request.getParameterValues("columnData"+tabIdx);
		String[] groupBy = request.getParameterValues("groupBy"+tabIdx);

		StringBuilder information = new StringBuilder();

		// column 중복 제거.
		List<String> columnList = new ArrayList<String>();
		for(int i = 0; i < columnData.length; i++){
			if(!columnList.contains(columnData[i])) {
				columnList.add(columnData[i]);
			}
		}

		StringBuilder column = new StringBuilder();
		for (String string : columnList) {
			
			/*
			switch(string) {
			
			case "usr_id" :
				column.append(Prop.propFormat("common.org.user"));
				break;
			case "ctime_yyyy" :
				column.append(Prop.propFormat("analysis.freedom.ctime_yyyy"));
				break;
			case "ctime_yyyymm" :
				column.append(Prop.propFormat("analysis.freedom.ctime_yyyymm"));
				break;
			case "ctime_yyyymmdd" :
				column.append(Prop.propFormat("analysis.freedom.ctime_yyyymmdd"));
				break;
			case "ctime_yyyymmddhh" :
				column.append(Prop.propFormat("analysis.freedom.ctime_yyyymmddhh"));
				break;
			case "srcip" :
				column.append(Prop.propFormat("condition.send")+" IP");
				break;
			case "sport" :
				column.append(Prop.propFormat("condition.send")+" PORT");
				break;
			case "dstip" :
				column.append(Prop.propFormat("condition.receive")+" IP");
				break;
			case "dport" :
				column.append(Prop.propFormat("condition.receive")+" PORT");
				break;
			case "svc12" :
				column.append(Prop.propFormat("common.org.servicetype"));
				break;
			case "host_str" :
				column.append("HOST");
				break;
			case "sender_str" :
				column.append(Prop.propFormat("message.msg.from"));
				break;
			case "to" :
				column.append(Prop.propFormat("analysis.freedom.ui.mailto"));
				break;
			case "conm" :
				column.append(Prop.propFormat("common.org.conm"));
				break;
			case "suborgcd" :
				column.append(Prop.propFormat("common.org.suborg"));
				break;
			case "businm" :
				column.append(Prop.propFormat("common.org.busi"));
				break;
			case "deptnm" :
				column.append(Prop.propFormat("common.org.dept"));
				break;
			case "jikgubnm" :
				column.append(Prop.propFormat("common.org.jikgub"));
				break;
			case "attached" :
				column.append(Prop.propFormat("analysis.freedom.ui.isattach"));
				break;
			case "attachname_str" :
				column.append(Prop.propFormat("condition.attach_name"));
				break;
			case "kwds" :
				column.append(Prop.propFormat("keyword.msg.keyword"));
				break;
			
			}
			*/
			column.append(getColumnNm(string));
			column.append(Prop.propFormat("analysis.freedom.type"));
		}

		// groupBy 중복 제거.
		List<String> groupByList = new ArrayList<String>();
		for(int i = 0; i < groupBy.length; i++){
			if(!groupByList.contains(groupBy[i])) {
				groupByList.add(groupBy[i]);
			}
		}

		StringBuilder group = new StringBuilder();
		for (String string : groupByList) {
			group.append(", ");
			switch(string) {
			case "count" :
				group.append(Prop.propFormat("analysis.freedom.totcnt"));
				break;
			case "sum" :
				group.append(Prop.propFormat("analysis.freedom.totbyte.sum"));
				break;
			case "avg" :
				group.append(Prop.propFormat("analysis.freedom.totbyte.avg"));
				break;
			case "max" :
				group.append(Prop.propFormat("analysis.freedom.totbyte.max"));
				break;
			case "min" :
				group.append(Prop.propFormat("analysis.freedom.totbyte.min"));
				break;
			}
		}

		information.append("[").append(column).append(group.substring(2)).append(Prop.propFormat("common.msg.search")+" ]");


		for (int i = 0; i < andOr.length; i++) {

			if(andOr[i].equals("") || andOr[i].equals("and")) {
				information.append("┌");
			}
			information.append(" ").append(andOr[i].toUpperCase()).append(" ");
			information.append(beforePparen[i]);

			if(termsColumn[i].equals("ctime_yyyymmdd")) {
				information.append(Prop.propFormat("condition.period")+": ").append(startDate[i]).append(" ~ ").append(endDate[i]);
			} else if(termsColumn[i].equals("svc")) {
				information.append(Prop.propFormat("common.org.servicetype")+": ").append(Config.getServiceLv12Nm(serviceCd[i]));
			} else {
				if(Common.isNotEmpty(context[i])) {
					information.append("").append(getName(termsColumn[i])).append(" ").append(compare[i]).append(" ").append(context[i]);
				}
			}

			information.append(afterPparen[i]);
		}

		auditVo.setInformation(information.toString());
		auditService.insertAudit(request, auditVo);
	}

	private String getName(String code) {
		String name = "";
		switch(code) {
		case "usr_id" :
			name = Prop.propFormat("common.org.user");
			break;
		case "ctime_yyyymmdd" :
			name = Prop.propFormat("analysis.freedom.ui.collectdate");
			break;
		case "srcip" :
			name = Prop.propFormat("condition.send")+" IP";
			break;
		case "sport" :
			name = Prop.propFormat("condition.send")+" PORT";
			break;
		case "dstip" :
			name = Prop.propFormat("condition.receive")+" IP";
			break;
		case "dport" :
			name = Prop.propFormat("condition.receive")+" PORT";
			break;
		case "svc" :
			name = Prop.propFormat("common.org.servicetype");
			break;
		case "size" :
			name = Prop.propFormat("analysis.freedom.ui.size");
			break;
		case "host_str" :
			name = "URL";
			break;
		case "sender" :
			name = Prop.propFormat("message.msg.from");
			break;
		case "to" :
			name = Prop.propFormat("analysis.freedom.ui.mailto");
			break;
		case "body_snippet" :
			name = Prop.propFormat("condition.body");
			break;
		case "subject" :
			name = Prop.propFormat("analysis.freedom.ui.mailtitle");
			break;
		case "conm" :
			name = Prop.propFormat("common.org.conm");
			break;
		case "suborgcd" :
			name = Prop.propFormat("common.org.suborg");
			break;
		case "businm" :
			name = Prop.propFormat("common.org.busi");
			break;
		case "deptnm" :
			name = Prop.propFormat("common.org.dept");
			break;
		case "jikgubnm" :
			name = Prop.propFormat("common.org.jikgub");
			break;
		case "attached" :
			name = Prop.propFormat("analysis.freedom.ui.isattach");
			break;
		case "attachname_str" :
			name = Prop.propFormat("condition.attach_name");
			break;
		case "attachtype" :
			name = Prop.propFormat("codeInfo.attchext");
			break;
		case "kwds" :
			name = Prop.propFormat("keyword.msg.keyword");
			break;
		}
		return name;
	}
	
	public void selectFreedomMessageList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String querys[] = Common.toArray(Common.nvl(param.get("query")), " && ");
		
		StringBuilder information = new StringBuilder();
		
		information.append("[").append(Prop.propFormat("analysis.relation.listdetailsearch")).append("]").append("┌");
		
		for(String query:querys) {
			String keyValue[] = Common.toArray(query, ":");
			information.append(getColumnNm(keyValue[0])).append(":" + keyValue[1].replaceAll("\"", "")).append("┌");
		}
		auditVo.setInformation(information.toString());
		auditService.insertAudit(request, auditVo);
		
	}
	
	
	public String getColumnNm(String string) {
		String rtn = "";
		switch(string) {
		case "usr_id" :
			rtn = Prop.propFormat("common.org.user");
			break;
		case "ctime_yyyy" :
			rtn = Prop.propFormat("analysis.freedom.ctime_yyyy");
			break;
		case "ctime_yyyymm" :
			rtn = Prop.propFormat("analysis.freedom.ctime_yyyymm");
			break;
		case "ctime_yyyymmdd" :
			rtn = Prop.propFormat("analysis.freedom.ctime_yyyymmdd");
			break;
		case "ctime_yyyymmddhh" :
			rtn = Prop.propFormat("analysis.freedom.ctime_yyyymmddhh");
			break;
		case "srcip" :
			rtn = Prop.propFormat("condition.source")+" IP";
			break;
		case "sport" :
			rtn = Prop.propFormat("condition.source")+" PORT";
			break;
		case "dstip" :
			rtn = Prop.propFormat("condition.receive")+" IP";
			break;
		case "dport" :
			rtn = Prop.propFormat("condition.receive")+" PORT";
			break;
		case "svc12" :
			rtn = Prop.propFormat("common.org.servicetype");
			break;
		case "host_str" :
			rtn = "HOST";
			break;
		case "sender_str" :
			rtn = Prop.propFormat("message.msg.from");
			break;
		case "to" :
			rtn = Prop.propFormat("analysis.freedom.ui.mailto");
			break;
		case "conm" :
			rtn = Prop.propFormat("common.org.conm");
			break;
		case "suborgcd" :
			rtn = Prop.propFormat("common.org.suborg");
			break;
		case "businm" :
			rtn = Prop.propFormat("common.org.busi");
			break;
		case "deptnm" :
			rtn = Prop.propFormat("common.org.dept");
			break;
		case "jikgubnm" :
			rtn = Prop.propFormat("common.org.jikgub");
			break;
		case "attached" :
			rtn = Prop.propFormat("analysis.freedom.ui.isattach");
			break;
		case "attachname_str" :
			rtn = Prop.propFormat("condition.attach_name");
			break;
		case "kwds" :
			rtn = Prop.propFormat("keyword.msg.keyword");
			break;
		}
		return rtn;
	}
	
}

