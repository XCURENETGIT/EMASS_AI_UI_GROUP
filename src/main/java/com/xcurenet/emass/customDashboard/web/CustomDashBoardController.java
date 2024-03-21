package com.xcurenet.emass.customDashboard.web;


import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.customDashboard.service.CustomDashBoardService;
import com.xcurenet.emass.customDashboard.service.CustomDashboardMenuVO;
import com.xcurenet.emass.customDashboard.service.CustomDashboardVO;
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
@AuditParentMenu(ParentMenu.DASHBOARD)
@AuditMenu(Menu.DASHBOARD)
public class CustomDashBoardController {

	@Resource(name = "customDashBoardService")
	private CustomDashBoardService customDashBoardService;

	@RequestMapping(value = "/getDashBoardList.xcn")
	@Description("Dashboard - 화면 목록 조회")
	@ResponseBody
	public XcnResponseVO getDashBoardList(final CustomDashboardVO customDashboardVo, final HttpSession session) throws Exception {
		customDashboardVo.setAdminId(Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.getDashBoardList(customDashboardVo));
	}
	
	@RequestMapping(value = "/getDefaultDashBoardContentList.xcn")
	@Description("Dashboard - 기본 항목 목록 조회")
	@ResponseBody
	public XcnResponseVO getDefaultDashBoardContentList(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.getDefaultDashBoardContentList());
	}
	
	@RequestMapping(value = "/saveDashBoard.xcn")
	@Description("Dashboard - 항목 추가 및 수정 저장")
	@AuditOperation(Operation.SAVE)
	@ResponseBody
	public XcnResponseVO saveDashBoard(final HttpServletRequest request) throws Exception{
		JSONObject param = Common.getParam(request);
		List<CustomDashboardVO> customDashboardVos = new ArrayList<>();
		JSONArray list = JSONArray.fromObject(Common.nvl(request.getParameter("data")));
		
		if( list.isEmpty()) {
			CustomDashboardVO customDashboardVO = new CustomDashboardVO();
			customDashboardVO.setMenuKey(Common.nvl(param.get("menuKey")));
			return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.deleteDashBoard(customDashboardVO));
		}
		
		for(int i=0; i<list.size(); i++) {
			CustomDashboardVO customDashboardVO= (CustomDashboardVO) JSONObject.toBean(list.getJSONObject(i), CustomDashboardVO.class);
			customDashboardVO.setMenuKey(Common.nvl(param.get("menuKey")));
			customDashboardVos.add(customDashboardVO);
		}
		
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.saveDashBoard(customDashboardVos));
	}
	
	@RequestMapping(value = "/getLoggingDataSetting.xcn")
	@Description("Dashboard - 로깅 데이터 건수 조회")
	@ResponseBody
	public XcnResponseVO getLoggingDataSetting(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.getLoggingDataSetting(session));
	}

	@RequestMapping(value = "/getFileDataSetting.xcn")
	@Description("Dashboard - 로깅 데이터 건수 조회")
	@ResponseBody
	public XcnResponseVO getFileDataSetting(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.getFileDataSetting(session));
	}

	
	@RequestMapping(value = "/getLoggingData.xcn")
	@Description("Dashboard - 로깅 데이터 건수 조회")
	@ResponseBody
	public XcnResponseVO getLoggingData(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.getLoggingData(request, session));
	}
	
	@RequestMapping(value = "/getHdfsData.xcn")
	@Description("Dashboard - 로깅 데이터 용량 조회")
	@ResponseBody
	public XcnResponseVO getHdfsData(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.getHdfsData(request, session));
	}
	
	@RequestMapping(value = "/getDashBoardContentData.xcn")
	@Description("Dashboard - 항목데이터 조회")
	@ResponseBody
	public XcnResponseVO getDashBoardContentData(CustomDashboardVO customDashboardVo, final HttpSession session) throws Exception {
		customDashboardVo.setAdminId(Common.getAdminId(session));
		customDashboardVo = customDashBoardService.getDashBoardContentList(customDashboardVo).get(0);
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.getDashBoardContentData(customDashboardVo));
	}
	
	@RequestMapping(value = "/insertDashBoardDefaultData.xcn")
	@Description("Dashboard - default 셋 등록")
	@ResponseBody
	public XcnResponseVO setDashBoardDefaultData(CustomDashboardVO customDashboardVo, final HttpSession session) throws Exception {
		customDashboardVo.setAdminId(Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.insertDashBoardDefaultData(customDashboardVo));
	}


	@RequestMapping(value = "/isDefaultDashboard.xcn")
	@Description("Dashboard - 디폴트 대시보드 구분")
	@ResponseBody
	public XcnResponseVO isDefaultDashboard(CustomDashboardMenuVO customDashboardMenuVO, final HttpSession session,final HttpServletRequest request) throws Exception {
		JSONObject param = Common.getParam(request);
		customDashboardMenuVO.setAdminId(Common.getAdminId(session));
		customDashboardMenuVO.setMenuKey(Common.nvl(request.getParameter("menuKey")));
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.isDefaultDashboard(customDashboardMenuVO));
	}


	
	@RequestMapping(value = "/saveLoggingData.xcn")
	@Description("Dashboard - default 셋 등록(일별 로깅 데이터)")
	@ResponseBody
	public XcnResponseVO saveLoggingData(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.saveLoggingData(request, session));
	}

	@RequestMapping(value = "/saveFileTopData.xcn")
	@Description("Dashboard - default 셋 등록(Filet top10)")
	@ResponseBody
	public XcnResponseVO saveFileTopData(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.saveFileTopData(request, session));
	}
	
	@RequestMapping(value = "/getFilSizeData.xcn")
	@Description("Dashboard - test 조회")
	@ResponseBody
	public XcnResponseVO getTestData(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.getFileSizeData(request, session));
	}
	
	@RequestMapping(value = "/getFileCount.xcn")
	@Description("Dashboard - test count 조회")
	@ResponseBody
	public XcnResponseVO getTestCount(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.getFileCount(request, session));
	}
	
	@RequestMapping(value = "/checkMonitorDB.xcn")
	@Description("Monitoring Service Check")
	@ResponseBody
	public XcnResponseVO checkMonitorDB(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.checkMonitorDB());
	}
	
}