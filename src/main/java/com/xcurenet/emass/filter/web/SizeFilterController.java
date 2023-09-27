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
import com.xcurenet.emass.filter.service.SizeFilterService;
import com.xcurenet.emass.filter.service.SizeFilterVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.POLICY_SETUP)
@AuditMenu(Menu.POLICY_NOLOG)
public class SizeFilterController {

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;

	@Resource(name = "sizeFilterService")
	public SizeFilterService sizeFilterService;

	@RequestMapping(value = "/getSizeFilterList.xcn")
	@Description("크기 필터 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getSizeFilterList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String serviceCd = Common.nvl(request.getParameter("serviceCd"));
		return new XcnResponseVO(XcnRspCode.OK, sizeFilterService.getSizeFilterList(serviceCd));
	}

	@RequestMapping(value = "/insertSizeFilter.xcn")
	@Description("크기 필터 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertSizeFilter(final HttpServletRequest request, SizeFilterVO filter) throws Exception {
		if (sizeFilterService.isSizeExist(filter)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.service", request));
		} else {
			int rs = sizeFilterService.insertSizeFilter(filter);
			makeInfoService.addInfoNoLog();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/updateSizeFilter.xcn")
	@Description("크기 필터 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateSizeFilter(SizeFilterVO filter) throws Exception {
		int rs = sizeFilterService.updateSizeFilter(filter);
		makeInfoService.addInfoNoLog();
		return new XcnResponseVO(XcnRspCode.OK, rs);
	}

	@RequestMapping(value = "/deleteSizeFilter.xcn")
	@Description("크기 필터 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteSizeFilter(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<SizeFilterVO> filters = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			SizeFilterVO filter = (SizeFilterVO) JSONObject.toBean(data.getJSONObject(i), SizeFilterVO.class);
			filters.add(filter);
		}
		if (sizeFilterService.deleteSizeFilter(filters) == 1) {
			makeInfoService.addInfoNoLog();
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
		}
	}
}
