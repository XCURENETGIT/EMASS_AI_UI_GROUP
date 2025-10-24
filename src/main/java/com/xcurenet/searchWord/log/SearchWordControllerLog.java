package com.xcurenet.searchWord.log;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;;
import com.xcurenet.searchWord.service.SearchWordService;
import com.xcurenet.searchWord.service.SearchWordVO;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Component
public class SearchWordControllerLog {
	@Resource(name = "searchWordService")
	public SearchWordService searchWordService;

	@Autowired
	private AuditService auditService;


	public void getSearchWord(final HttpServletRequest request,  AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(request.getParameter(""));
		String information = "";

		information += "[" + Prop.propFormat("condition.relationKeyword") + " " + Prop.propFormat("common.msg.search") + "]";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}

	public void insertSearchWord(final HttpServletRequest request,  AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String searchWord = Common.nvl(param.get("searchWord"));
		String relationSearchWord = Common.nvl(param.get("relationWord"));
		String information = "";
		information += "["+Prop.propFormat("common.msg.add")+"]";
		if(Common.isNotEmpty(searchWord))information += "┌"+Prop.propFormat("searchKeyword.searchKeyword")+": " + searchWord;
		if(Common.isNotEmpty(relationSearchWord))information += "┌"+Prop.propFormat("condition.relationKeyword")+": " + relationSearchWord;

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}

	public void updateSearchWord(final HttpServletRequest request,  AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);

		String searchWord = Common.nvl(param.get("searchWord"));
		int keywordId = Integer.parseInt(Common.nvl(param.get("keywordId")));
		SearchWordVO searchWordVO = new SearchWordVO();
		searchWordVO.setSearchWord(searchWord);
		searchWordVO.setKeywordId(keywordId);
		String information = "";

		if (!searchWordService.isSearchWord(searchWordVO)){
			information += "["+Prop.propFormat("common.msg.modify")+"]";
			if(Common.isNotEmpty(searchWord))information += "┌"+Prop.propFormat("searchKeyword.searchKeyword")+": " + searchWord;
		}

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}


	public void deleteSearchWord(final HttpServletRequest request, AuditRequestVO auditVo){
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		String information = "";
		information += "["+Prop.propFormat("common.msg.delete")+"]";
		information += "┌"+Prop.propFormat("searchKeyword.searchKeyword")+": " + deleteData;

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}

	public void deleteSearchRelaWord(final HttpServletRequest request, AuditRequestVO auditVo){
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		String keywordId = Common.nvl(request.getParameter("keywordId"));
		String information = "";
		information += "["+Prop.propFormat("condition.relationKeyword")+" "+Prop.propFormat("common.msg.delete")+"]";
		information += "┌"+Prop.propFormat("searchKeyword.searchKeyword")+" ID: " + keywordId;
		information += "┌"+Prop.propFormat("condition.relationKeyword")+": " + deleteData;

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}

	public void importSearchWordBatch(final HttpServletRequest request, AuditRequestVO auditVo){
		String information = "";
		information += "["+Prop.propFormat("searchKeyword.searchKeyword")+" 일괄 등록]";

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}


}
