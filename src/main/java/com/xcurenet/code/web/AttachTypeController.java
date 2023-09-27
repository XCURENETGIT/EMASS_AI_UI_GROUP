package com.xcurenet.code.web;

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
import com.xcurenet.code.service.AttachTypeService;
import com.xcurenet.code.service.AttachTypeVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.CODE_INFO)
public class AttachTypeController {

	@Resource(name = "attachTypeService")
	public AttachTypeService attachTypeService;

	@RequestMapping(value = "/getAttachType.xcn")
	@Description("첨부파일 타입 조회")
	@ResponseBody
	public XcnResponseVO getAttachType(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, attachTypeService.getAttachType());
	}
	
	@RequestMapping(value = "/getAttachTypeList.xcn")
	@Description("첨부파일 타입 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getAttachTypeList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		return new XcnResponseVO(XcnRspCode.OK, attachTypeService.getAttachTypeList(searchStr));
	}

	@RequestMapping(value = "/insertAttachType.xcn")
	@Description("첨부파일 타입 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertAttachType(AttachTypeVO attach, HttpSession session) throws Exception {
		if (attachTypeService.isAttachTypeExist(attach)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("errors.duplicated", Common.getLocale(session), attach.getAttachType()));
		} else {
			return new XcnResponseVO(XcnRspCode.OK, attachTypeService.insertAttachType(attach));
		}
	}

	@RequestMapping(value = "/updateAttachType.xcn")
	@Description("첨부파일 타입 수정")
	@ResponseBody
	public XcnResponseVO updateAttachType(AttachTypeVO attach) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, attachTypeService.updateAttachType(attach));
	}

	@RequestMapping(value = "/deleteAttachType.xcn")
	@Description("첨부파일 타입 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteAttachType(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<AttachTypeVO> attachs = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			AttachTypeVO attach = (AttachTypeVO) JSONObject.toBean(data.getJSONObject(i), AttachTypeVO.class);
			attachs.add(attach);
		}
		if (attachTypeService.deleteAttachType(attachs) == 1) return new XcnResponseVO(XcnRspCode.OK);
		else return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
		/*return new XcnResponseVO(XcnRspCode.OK, attachTypeService.deleteAttachType(attachs));*/
	}
}
