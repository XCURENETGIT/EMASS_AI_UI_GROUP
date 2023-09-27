package com.xcurenet.device.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
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
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.device.service.DeviceTrafficStatListVO;
import com.xcurenet.device.service.DeviceTrafficStatService;

import net.sf.json.JSONObject;

/**
 * Handles requests for the application home page.
 */
@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.STAT_DEVTRAFFIC)
public class DeviceTrafficStatController {
	
	@Autowired
	public HttpSession session;

	@Resource(name = "deviceTrafficStatService")
	public DeviceTrafficStatService deviceTrafficStatService;

	@RequestMapping(value = "/getDeviceTrafficStat.xcn")
	@Description("장비 트래픽 통계 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getDeviceTrafficStat(final HttpServletRequest request, final HttpSession session) throws Exception {

		JSONObject param = Common.getParam(request);
		String xAxis = Common.nvl(param.get("xAxis"));
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));

		DeviceTrafficStatListVO vo = new DeviceTrafficStatListVO();
		vo.setHeader(getHeader(request, xAxis, startDt, endDt));
		if (Common.isEquals(xAxis, "H")) {
			vo.setData(deviceTrafficStatService.getTrafficStatList_Hour(startDt, endDt));
		} else if (Common.isEquals(xAxis, "W")) {
			vo.setData(deviceTrafficStatService.getTrafficStatList_Week(startDt, endDt));
		} else if (Common.isEquals(xAxis, "D")) {
			vo.setData(deviceTrafficStatService.getTrafficStatList_Day(startDt, endDt));
		} else if (Common.isEquals(xAxis, "M")) {
			vo.setData(deviceTrafficStatService.getTrafficStatList_Month(startDt, endDt));
		}
		return new XcnResponseVO(XcnRspCode.OK, vo);
	}

	/**
	 * 헤더 조회
	 *
	 * @param xAxis
	 * @param startDt
	 * @param endDt
	 * @return
	 */
	public List<Map<String, String>> getHeader(final HttpServletRequest request, String xAxis, String startDt, String endDt) {
		List<Map<String, String>> header = new ArrayList<>();
		if (Common.isEquals(xAxis, "M")) {
			int months = Common.diffOfMonth(startDt, endDt);
			for (int i = 0; i <= months; i++) {
				Map<String, String> obj = new HashMap<>();
				obj.put("key", Common.formatMonth(Common.plusMonth(startDt, i)));
				obj.put("text", obj.get("key"));
				header.add(obj);
			}
		} else if (Common.isEquals(xAxis, "D")) {
			int days = Common.diffOfDate(startDt, endDt);
			for (int i = 0; i <= days; i++) {
				Map<String, String> obj = new HashMap<>();
				obj.put("key", Common.formatDate(Common.plusDays(startDt, i)));
				obj.put("text", Common.formatDate2(Common.plusDays(startDt, i)));
				header.add(obj);
			}
		} else if (Common.isEquals(xAxis, "W")) {
			String locale="ko";
			System.out.println("Common.getLocale(session).getLanguage() = "+Common.getLocale(session).getLanguage());
			if(Common.isEquals(Common.getLocale(session).getLanguage(), "en")) locale="en";
			for (int i = 0; i < 7; i++) {
				Map<String, String> obj = new HashMap<>();
				obj.put("key", "W_" + i);
				if(Common.isEquals(locale, "ko")) obj.put("text", Common.WEEK_NAME_KR[i]);
				else obj.put("text", Common.WEEK_NAME_EN[i]);
				header.add(obj);
			}
		} else if (Common.isEquals(xAxis, "H")) {
			for (int i = 0; i < 24; i++) {
				Map<String, String> obj = new HashMap<>();
				obj.put("key", Common.lPad(i, 2, "0"));
				obj.put("text", Prop.propFormat("condition.hour", request, Common.lPad(i, 2, "0")));
				header.add(obj);
			}
		}
		return header;
	}

}
