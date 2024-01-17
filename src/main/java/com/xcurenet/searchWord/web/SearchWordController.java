package com.xcurenet.searchWord.web;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.searchWord.service.SearchWordService;
import com.xcurenet.searchWord.service.SearchWordVO;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.RELATION_KEYWORD)
@Slf4j
public class SearchWordController {

	@Resource(name = "searchWordService")
	public SearchWordService searchWordService;

	@RequestMapping(value = "/getSearchWord.xcn")
	@Description("키워드 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getSearchWord(final HttpServletRequest request, final HttpSession httpSession){
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, searchWordService.getSearchWord(offset, limit, searchStr));
	}

	@RequestMapping(value = "/insertSearchWord.xcn")
	@Description("검색키워드 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertSearchWord(final HttpServletRequest request, SearchWordVO searchWordVO){
		if (searchWordService.isSearchWord(searchWordVO)){
			return new XcnResponseVO(XcnRspCode.OK, searchWordService.insertRelSearchWord(searchWordVO));
		}
		return new XcnResponseVO(XcnRspCode.OK, searchWordService.insertSearchWord(searchWordVO));
	}

	@RequestMapping(value = "/updateSearchWord.xcn")
	@Description("검색키워드 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateSearchWord(final HttpServletRequest request, SearchWordVO searchWordVO){
		if (searchWordService.isSearchWord(searchWordVO)){
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.searchKeyword", request, searchWordVO.getSearchWord()));
		}
		return new XcnResponseVO(XcnRspCode.OK, searchWordService.updateSearchWord(searchWordVO));
	}

	@RequestMapping(value = "/deleteSearchWord.xcn")
	@Description("검색 키워드 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteSearchWord(final HttpServletRequest request) throws Exception{
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<SearchWordVO> searchWords = new ArrayList<>();
		for (int i = 0; i<data.size(); i++){
			SearchWordVO searchWordVO =(SearchWordVO) JSONObject.toBean(data.getJSONObject(i), SearchWordVO.class);
			searchWords.add(searchWordVO);
		}
		return new XcnResponseVO(XcnRspCode.OK, searchWordService.deleteSearchWord(searchWords));

	}

	@RequestMapping(value = "/deleteSearchRelaWord.xcn")
	@Description("연관 키워드 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteSearchRelaWord(final HttpServletRequest request) throws Exception{
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		int keywordId = Integer.parseInt(Common.nvl(request.getParameter("keywordId")));
		JSONArray data = Common.toJSONArray(deleteData);
		List<SearchWordVO> searchWords = new ArrayList<>();
		for (int i = 0; i<data.size(); i++){
			SearchWordVO searchWordVO =(SearchWordVO) JSONObject.toBean(data.getJSONObject(i), SearchWordVO.class);
			searchWords.add(searchWordVO);
		}
		return new XcnResponseVO(XcnRspCode.OK, searchWordService.deleteSearchRelWord(searchWords, keywordId));
	}

}
