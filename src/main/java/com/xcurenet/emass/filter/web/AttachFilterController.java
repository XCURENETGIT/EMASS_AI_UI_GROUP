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
import com.xcurenet.emass.filter.service.AttachFilterService;
import com.xcurenet.emass.filter.service.AttachFilterVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.POLICY_SETUP)
@AuditMenu(Menu.POLICY_NOLOG)
public class AttachFilterController {

	@Resource(name = "attachFilterService")
	public AttachFilterService attachFilterService;

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;

	@RequestMapping(value = "/getAttachFilterList.xcn")
	@Description("첨부파일 필터 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getAttachFilterList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String serviceCd = Common.nvl(request.getParameter("serviceCd"));
		return new XcnResponseVO(XcnRspCode.OK, attachFilterService.getAttachFilterList(searchStr, serviceCd));
	}

	@RequestMapping(value = "/insertAttachFilter.xcn")
	@Description("첨부파일 필터 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertAttachFilter(final HttpServletRequest request, AttachFilterVO filter) throws Exception {
		if (attachFilterService.isAttachExist(filter)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.subject", request, filter.getAttach()));
		} else {
			int rs = attachFilterService.insertAttachFilter(filter);
			makeInfoService.addInfoNoLog();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/updateAttachFilter.xcn")
	@Description("첨부파일 필터 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateAttachFilter(final HttpServletRequest request, AttachFilterVO filter) throws Exception {
		if (attachFilterService.isAttachExist(filter)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.subject", request, filter.getAttach()));
		} else {
			int rs = attachFilterService.updateAttachFilter(filter);
			makeInfoService.addInfoNoLog();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/deleteAttachFilter.xcn")
	@Description("첨부파일 필터 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteAttachFilter(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<AttachFilterVO> filters = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			AttachFilterVO filter = (AttachFilterVO) JSONObject.toBean(data.getJSONObject(i), AttachFilterVO.class);
			filters.add(filter);
		}
		if (attachFilterService.deleteAttachFilter(filters) == 1) {
			makeInfoService.addInfoNoLog();
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
		}
	}
}
