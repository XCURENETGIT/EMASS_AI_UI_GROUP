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
import com.xcurenet.emass.filter.service.DomainFilterService;
import com.xcurenet.emass.filter.service.DomainFilterVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.POLICY_SETUP)
@AuditMenu(Menu.POLICY_NOLOG)
public class DomainFilterController {

	@Resource(name = "domainFilterService")
	public DomainFilterService domainFilterService;

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;

	@RequestMapping(value = "/getDomainFilterList.xcn")
	@Description("도메인 필터 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getDomainFilterList(final HttpServletRequest request, final HttpSession session) throws Exception {

		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String serviceCd = Common.nvl(request.getParameter("serviceCd"));
		return new XcnResponseVO(XcnRspCode.OK, domainFilterService.getDomainFilterList(searchStr, serviceCd));
	}

	@RequestMapping(value = "/insertDomainFilter.xcn")
	@Description("도메인 필터 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertDomainFilter(final HttpServletRequest request, DomainFilterVO filter) throws Exception {
		if (domainFilterService.isDomainExist(filter)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.domain", request, filter.getDomain()));
		} else {
			int rs = domainFilterService.insertDomainFilter(filter);
			makeInfoService.addInfoDomainNoLog();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/updateDomainFilter.xcn")
	@Description("도메인 필터 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateDomainFilter(final HttpServletRequest request, DomainFilterVO filter) throws Exception {
		if (domainFilterService.isDomainExist(filter)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.domain", request, filter.getDomain()));
		} else {
			int rs = domainFilterService.updateDomainFilter(filter);
			makeInfoService.addInfoDomainNoLog();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/deleteDomainFilter.xcn")
	@Description("도메인 필터 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteDomainFilter(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<DomainFilterVO> filters = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			DomainFilterVO filter = (DomainFilterVO) JSONObject.toBean(data.getJSONObject(i), DomainFilterVO.class);
			filters.add(filter);
		}
		if (domainFilterService.deleteDomainFilter(filters) == 1) {
			makeInfoService.addInfoDomainNoLog();
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
		}
	}
}
