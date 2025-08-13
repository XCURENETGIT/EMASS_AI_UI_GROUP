package com.xcurenet.emass.aiDashboard.web;


import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.aiDashboard.service.AiDashboardService;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.io.IOException;

@Controller
@AuditParentMenu(ParentMenu.DASHBOARD)
@AuditMenu(Menu.DASHBOARD_MENU)
@Log4j2
public class AiDashBoardController {

    @Resource(name = "AiDashboardService")
    private AiDashboardService aiDashboardService;

    @RequestMapping(value = "/getAiDashboardStats.xcn", method = RequestMethod.POST)
    @ResponseBody
    public XcnResponseVO getAiDashboardStats() throws IOException {
        return new XcnResponseVO(XcnRspCode.OK,  aiDashboardService.redefined(aiDashboardService.getAiDashboardStats()));
    }

}
