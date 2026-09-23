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
import com.xcurenet.code.service.EpmsgTypeService;
import com.xcurenet.code.service.EpmsgTypeVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.CODE_INFO)
public class EpmsgTypeController {

	@Resource(name = "epmsgTypeService")
	public EpmsgTypeService epmsgTypeService;

	@RequestMapping(value = "/getEpmsgTypeList.xcn")
	@Description("KNOX 메일 종류 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getEpmsgTypeList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String searchUseYn = Common.nvl(request.getParameter("searchUseYn"));
		return new XcnResponseVO(XcnRspCode.OK, epmsgTypeService.getEpmsgTypeList(searchStr, searchUseYn));
	}

	@RequestMapping(value = "/getUsedEpmsgTypeList.xcn")
	@Description("사용중인 KNOX 메일 종류 조회 (검색 조건용)")
	@ResponseBody
	public XcnResponseVO getUsedEpmsgTypeList() throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, epmsgTypeService.getUsedEpmsgTypeList());
	}

	@RequestMapping(value = "/getEpmsgTypeNameList.xcn")
	@Description("KNOX 메일 종류 코드/이름 조회 (조건 표시용, 미사용 포함)")
	@ResponseBody
	public XcnResponseVO getEpmsgTypeNameList() throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, epmsgTypeService.getEpmsgTypeList("", ""));
	}

	@RequestMapping(value = "/insertEpmsgType.xcn")
	@Description("KNOX 메일 종류 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertEpmsgType(EpmsgTypeVO epmsgType, HttpSession session) throws Exception {
		normalize(epmsgType);
		if (epmsgTypeService.isEpmsgTypeExist(epmsgType)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("errors.duplicated", Common.getLocale(session), epmsgType.getEpmsgTypeCode()));
		}
		return new XcnResponseVO(XcnRspCode.OK, epmsgTypeService.insertEpmsgType(epmsgType));
	}

	@RequestMapping(value = "/updateEpmsgType.xcn")
	@Description("KNOX 메일 종류 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateEpmsgType(EpmsgTypeVO epmsgType) throws Exception {
		normalize(epmsgType);
		return new XcnResponseVO(XcnRspCode.OK, epmsgTypeService.updateEpmsgType(epmsgType));
	}

	@RequestMapping(value = "/deleteEpmsgType.xcn")
	@Description("KNOX 메일 종류 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteEpmsgType(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<EpmsgTypeVO> epmsgTypes = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			epmsgTypes.add((EpmsgTypeVO) JSONObject.toBean(data.getJSONObject(i), EpmsgTypeVO.class));
		}
		if (epmsgTypeService.deleteEpmsgType(epmsgTypes) > 0) return new XcnResponseVO(XcnRspCode.OK);
		else return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
	}

	/** 색상은 #RRGGBB 형식만 허용, 사용여부는 Y/N 만 허용 */
	private void normalize(EpmsgTypeVO epmsgType) {
		String color = Common.nvl(epmsgType.getEpmsgTypeColor());
		if (!color.matches("^#[0-9a-fA-F]{6}$")) epmsgType.setEpmsgTypeColor("#5376A3");
		if (!"N".equals(epmsgType.getUseYn())) epmsgType.setUseYn("Y");
		epmsgType.setEpmsgTypeCode(Common.nvl(epmsgType.getEpmsgTypeCode()).trim());
	}
}
