package com.xcurenet.xcnlog.web;

import javax.annotation.Resource;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.xcnlog.service.XcnLogService;
import com.xcurenet.xcnlog.service.XcnLogVO;

@Controller
public class XcnLogController {

	@Resource(name = "xcnLogService")
	public XcnLogService xcnLogService;

	@RequestMapping(value = "/getXcnLogList.xcn")
	@Description("시스템 로그 조회")
	@ResponseBody
	public XcnResponseVO getXcnLogList(final XcnLogVO xcnLog) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, xcnLogService.getXcnLogList(xcnLog));
	}
}
