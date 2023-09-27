package com.xcurenet.common.makeInfo.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.annotation.Description;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.USER_MGMT)
public class MakeInfoController {

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;
	
	@RequestMapping(value = "/makeInfo", method = RequestMethod.GET)
	@Description("인사 연동 외부 조회")
	@ResponseStatus(value = HttpStatus.OK)
	public ResponseEntity<Object> makeInfo(final HttpServletRequest request) throws Exception {
		log.info("start make info.");
		try {
			makeInfoService.addInfoUser();
			makeInfoService.addInfoDevice();
			makeInfoService.addInfoHoliday();
			makeInfoService.addInfoWorkDay();
			makeInfoService.addInfoIpRange();
			makeInfoService.addInfoKeyword();
			makeInfoService.addInfoRegExp();
			makeInfoService.addInfoNoLog();
			log.info("end make info. (success)");
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<Object>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return new ResponseEntity<Object>(HttpStatus.OK);
	}

	@RequestMapping(value = "/makeInfoUser")
	@Description("MAKE INFO USER")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO makeInfoUser(final HttpServletRequest request) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, makeInfoService.addInfoUser());
	}

	@RequestMapping(value = "/makeInfoDevice")
	@Description("MAKE INFO DEVICE")
	@ResponseBody
	public XcnResponseVO makeInfoDevice(final HttpServletRequest request) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, makeInfoService.addInfoDevice());
	}

	@RequestMapping(value = "/makeInfoHoliday")
	@Description("MAKE INFO HOLIDAY")
	@ResponseBody
	public XcnResponseVO makeInfoHoliday(final HttpServletRequest request) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, makeInfoService.addInfoHoliday());
	}

	@RequestMapping(value = "/makeInfoWorkDay")
	@Description("MAKE INFO WORKDAY")
	@ResponseBody
	public XcnResponseVO makeInfoWorkDay(final HttpServletRequest request) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, makeInfoService.addInfoWorkDay());
	}

	@RequestMapping(value = "/makeInfoIpRange")
	@Description("MAKE INFO IPRANGE")
	@ResponseBody
	public XcnResponseVO makeInfoIpRange(final HttpServletRequest request) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, makeInfoService.addInfoIpRange());
	}

	@RequestMapping(value = "/makeInfoKeyword")
	@Description("MAKE INFO KEYWORD")
	@ResponseBody
	public XcnResponseVO makeInfoKeyword(final HttpServletRequest request) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, makeInfoService.addInfoKeyword());
	}

	@RequestMapping(value = "/makeInfoRegExp")
	@Description("MAKE INFO REGEXP")
	@ResponseBody
	public XcnResponseVO makeInfoRegExp(final HttpServletRequest request) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, makeInfoService.addInfoRegExp());
	}

	@RequestMapping(value = "/makeInfoNoLog")
	@Description("MAKE INFO REGEXP")
	@ResponseBody
	public XcnResponseVO makeInfoNoLog(final HttpServletRequest request) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, makeInfoService.addInfoNoLog());
	}
}
