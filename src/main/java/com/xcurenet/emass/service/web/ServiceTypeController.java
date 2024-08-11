package com.xcurenet.emass.service.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.xcurenet.emass.filter.service.SizeFilterVO;
import net.sf.json.JSONArray;
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
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.service.service.ServiceGroupService;
import com.xcurenet.emass.service.service.ServiceGroupVO;
import com.xcurenet.emass.service.service.ServiceTypeService;
import com.xcurenet.emass.service.service.ServiceTypeVO;

import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.CODE_INFO)
public class ServiceTypeController {

	@Resource(name = "serviceTypeService")
	public ServiceTypeService serviceTypeService;
	@Resource(name = "serviceGroupService")
	public ServiceGroupService serviceGroupService;

	@RequestMapping(value = "/getSendMailServiceListByOption.xcn")
	@Description("서비스 타입 (발신 메일) ")
	@ResponseBody
	public XcnResponseVO getSendMailServiceListByOption(final HttpServletRequest request, final HttpSession session) throws Exception {
		List<ServiceTypeVO> service = serviceTypeService.getSendMailServiceListByOption();
		return new XcnResponseVO(XcnRspCode.OK, service, service.size());
	}
	
	@RequestMapping(value = "/getServiceList.xcn")
	@Description("서비스 타입 리스트 조회(그룹코드, 검색어)")
	@ResponseBody
	public XcnResponseVO getServiceList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String groupCd = Common.nvl(request.getParameter("groupCd"));
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		List<ServiceTypeVO> service = serviceTypeService.getServiceList(groupCd, searchStr);
		return new XcnResponseVO(XcnRspCode.OK, service, service.size());
	}

	@RequestMapping(value = "/getServiceListByGroupCd.xcn")
	@Description("서비스 타입 리스트 조회(그룹코드)")
	@ResponseBody
	public XcnResponseVO getServiceListByGroupCd(final HttpServletRequest request, final HttpSession session) throws Exception {
		String groupCd = Common.nvl(request.getParameter("groupCd"));
		List<ServiceTypeVO> service = serviceTypeService.getServiceList(groupCd);
		return new XcnResponseVO(XcnRspCode.OK, service, service.size());
	}

	@RequestMapping(value = "/getServiceListByAll.xcn")
	@Description("서비스 타입 리스트 조회(전체)")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getServiceListByAll(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String searchUseYn = Common.nvl(request.getParameter("searchUseYn"));
		List<ServiceTypeVO> service = serviceTypeService.getServiceListByAll(searchStr, searchUseYn);
		return new XcnResponseVO(XcnRspCode.OK, service, service.size());
	}
	
	@RequestMapping(value = "/getServiceListByAuth.xcn")
	@Description("서비스 타입 리스트 조회(권한)")
	@ResponseBody
	public XcnResponseVO getServiceListByAuth(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		param.put("adminId", Common.getAdminId(request));
		List<ServiceTypeVO> service = serviceTypeService.getServiceListAuth(param);
		return new XcnResponseVO(XcnRspCode.OK, service, service.size());
	}
	
	//추후 검색어 파라미터 처리해야함
	@RequestMapping(value = "/getServiceGroupList.xcn")
	@Description("서비스 그룹 리스트 조회()")
	@ResponseBody
	public XcnResponseVO getServiceGroupList(final HttpServletRequest request, final HttpSession session) throws Exception {
		List<ServiceGroupVO> service = serviceGroupService.getServiceGroupList();
		return new XcnResponseVO(XcnRspCode.OK, service, service.size());
	}
	
	@RequestMapping(value = "/updateServiceUseYn.xcn")
	@Description("서비스 타입 사용 여부 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateServiceUseYn(ServiceTypeVO service) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, serviceTypeService.updateServiceUseYn(service));
	}

	@RequestMapping(value = "/updateServiceListUseYn.xcn")
	@Description("서비스 타입 사용 여부 수정")
	@ResponseBody
	public XcnResponseVO updateServiceListUseYn(final HttpServletRequest request, final HttpSession session) throws Exception {
		String serviceData = Common.nvl(request.getParameter("serviceData"));
		String type = Common.nvl(request.getParameter("type"));
		JSONArray dataList = Common.toJSONArray(serviceData);
		List<ServiceTypeVO> service = new ArrayList<>();
		for (int i = 0; i< dataList.size(); i++){
			ServiceTypeVO serviceTypeVO = (ServiceTypeVO) JSONObject.toBean(dataList.getJSONObject(i), ServiceTypeVO.class);
			serviceTypeVO.setUseYn(type);
			System.out.println(serviceTypeVO);
			serviceTypeService.updateServiceUseYn(serviceTypeVO);
		}
		return new XcnResponseVO(XcnRspCode.OK);
	}

}
