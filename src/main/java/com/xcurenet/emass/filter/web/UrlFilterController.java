package com.xcurenet.emass.filter.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.filter.service.UrlFilterService;
import com.xcurenet.emass.filter.service.UrlFilterVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.POLICY_SETUP)
@AuditMenu(Menu.POLICY_NOLOG)
public class UrlFilterController {

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;

	@Resource(name = "urlFilterService")
	public UrlFilterService urlFilterService;

	@RequestMapping(value = "/getUrlFilterList.xcn")
	@Description("URL 필터 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getUrlFilterList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		return new XcnResponseVO(XcnRspCode.OK, urlFilterService.getUrlFilterList(searchStr));
	}

	@RequestMapping(value = "/insertUrlFilter.xcn")
	@Description("URL 필터 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertUrlFilter(final HttpServletRequest request, UrlFilterVO filter) throws Exception {
		if (urlFilterService.isUrlExist(filter)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.url", request, filter.getUrl()));
		} else {
			int rs = urlFilterService.insertUrlFilter(filter);
			makeInfoService.addInfoNoLog();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/updateUrlFilter.xcn")
	@Description("URL 필터 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateUrlFilter(final HttpServletRequest request, UrlFilterVO filter) throws Exception {
		if (urlFilterService.isUrlExist(filter)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.url", request, filter.getUrl()));
		} else {
			int rs = urlFilterService.updateUrlFilter(filter);
			makeInfoService.addInfoNoLog();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/deleteUrlFilter.xcn")
	@Description("URL 필터 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteUrlFilter(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<UrlFilterVO> filters = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			UrlFilterVO filter = (UrlFilterVO) JSONObject.toBean(data.getJSONObject(i), UrlFilterVO.class);
			filters.add(filter);
		}
		if (urlFilterService.deleteUrlFilter(filters) == 1) {
			makeInfoService.addInfoNoLog();
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
		}
	}
}
