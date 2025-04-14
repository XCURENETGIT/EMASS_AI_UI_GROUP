package com.xcurenet.emass.service.web;

import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.service.service.BodyNationService;
import com.xcurenet.emass.service.service.BodyNationVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

@Controller
public class BodyNationController {

	@Resource(name = "bodyNationService")
	public BodyNationService bodyNationService;

	@RequestMapping(value = "/getCountryOptions.xcn")
	@ResponseBody
	public XcnResponseVO getCountryOptions()  {
		List<BodyNationVO> service = bodyNationService.getBodyNationList();
		return new XcnResponseVO(XcnRspCode.OK, service, service.size());
	}
}
