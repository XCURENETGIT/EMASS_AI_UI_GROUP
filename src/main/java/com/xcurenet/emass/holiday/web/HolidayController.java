package com.xcurenet.emass.holiday.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import com.xcurenet.emass.holiday.service.HolidayService;
import com.xcurenet.emass.holiday.service.HolidayVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.POLICY_SETUP)
@AuditMenu(Menu.HOLIDAY_BUSI)
public class HolidayController {

	@Resource(name = "holidayService")
	public HolidayService holidaysService;

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;

	@RequestMapping(value = "/getHolidayList.xcn")
	@Description("사업장별 휴일 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getHolidayList(final HttpServletRequest request) throws Exception {
		String busiCd = Common.nvl(request.getParameter("busiCd"));
		String year = Common.nvl(request.getParameter("year"));
		return new XcnResponseVO(XcnRspCode.OK, holidaysService.getHolidayList(busiCd, year));
	}

	@RequestMapping(value = "/insertHoliday.xcn")
	@Description("사업장별 휴일 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertHoliday(final HttpServletRequest request, final HolidayVO holiday) throws Exception {
		if (holidaysService.isHolidayExist(holiday)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert_only", request));
		}
		int rs = holidaysService.insertHoliday(holiday);
		makeInfoService.addInfoHoliday();
		return new XcnResponseVO(XcnRspCode.OK, rs);
	}

	@RequestMapping(value = "/updateHoliday.xcn")
	@Description("사업장별 휴일 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateHoliday(final HolidayVO holiday) throws Exception {
		int rs = holidaysService.updateHoliday(holiday);
		makeInfoService.addInfoHoliday();
		return new XcnResponseVO(XcnRspCode.OK, rs);
	}

	@RequestMapping(value = "/deleteHoliday.xcn")
	@Description("사업장별 휴일 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteHoliday(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); i++) {
			HolidayVO holiday = (HolidayVO) JSONObject.toBean(data.getJSONObject(i), HolidayVO.class);
			holidaysService.deleteHoliday(holiday);
		}
		makeInfoService.addInfoHoliday();
		return new XcnResponseVO(XcnRspCode.OK);
	}

}
