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
import com.xcurenet.emass.filter.service.IdFilterService;
import com.xcurenet.emass.filter.service.IdFilterVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.POLICY_SETUP)
@AuditMenu(Menu.POLICY_NOLOG)
public class IdFilterController {

	@Resource(name = "idFilterService")
	public IdFilterService idFilterService;

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;

	@RequestMapping(value = "/getIdFilterList.xcn")
	@Description("아이디 필터 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getIdFilterList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String serviceCd = Common.nvl(request.getParameter("serviceCd"));
		return new XcnResponseVO(XcnRspCode.OK, idFilterService.getIdFilterList(searchStr, serviceCd));
	}

	@RequestMapping(value = "/insertIdFilter.xcn")
	@Description("아이디 필터 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertIdFilter(final HttpServletRequest request, IdFilterVO filter) throws Exception {
		if (idFilterService.isServiceCdCountExceeded(filter.getServiceCd())) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("id.select.service", request));
		}
		if (idFilterService.isIdExist(filter)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert", request, filter.getUserId()));
		} else {
			int rs = idFilterService.insertIdFilter(filter);
			makeInfoService.addInfoIdNoLog();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/updateIdFilter.xcn")
	@Description("아이디 필터 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateIdFilter(final HttpServletRequest request, IdFilterVO filter) throws Exception {
		if (idFilterService.isServiceCdCountExceeded(filter.getServiceCd())) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("id.select.service", request));
		}
		if (idFilterService.isIdExist(filter)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert", request, filter.getUserId()));
		} else {
			int rs = idFilterService.updateIdFilter(filter);
			makeInfoService.addInfoIdNoLog();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/deleteIdFilter.xcn")
	@Description("아이디 필터 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteIdFilter(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<IdFilterVO> filters = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			IdFilterVO filter = (IdFilterVO) JSONObject.toBean(data.getJSONObject(i), IdFilterVO.class);
			filters.add(filter);
		}
		if (idFilterService.deleteIdFilter(filters) == 1) {
			makeInfoService.addInfoIdNoLog();
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
		}
	}
}
