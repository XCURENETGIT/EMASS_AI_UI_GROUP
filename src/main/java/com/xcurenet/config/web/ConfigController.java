package com.xcurenet.config.web;

import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.sms.SmsSender;
import com.xcurenet.common.sms.SmsType;
import com.xcurenet.common.sms.SmsVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.config.service.ConfigService;
import com.xcurenet.config.service.ConfigVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.USER_MGMT)
public class ConfigController {

	@Resource(name = "configService")
	public ConfigService configService;

	@Resource(name = "smsSender")
	public SmsSender smsSender;
	
	
	
	@Resource(name = "config")
	public Config config;

	@RequestMapping(value = "/getConfList.xcn")
	@Description("환경 설정 리스트 조회")
	@ResponseBody
	public XcnResponseVO getConfList(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, configService.getConfList());
	}

	@RequestMapping(value = "/getConfById.xcn")
	@Description("환경 설정 조회")
	@ResponseBody
	public XcnResponseVO getConfById(final HttpServletRequest request, final HttpSession session) throws Exception {
		String confId = Common.nvl(Common.getParam(request).get("confId"));
		return new XcnResponseVO(XcnRspCode.OK, configService.getConf(confId));
	}



	@RequestMapping(value = "/setConf.xcn")
	@Description("환경 설정 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO setConf(final HttpServletRequest request) throws Exception {
		if(saveConf(request)) {
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.change.language", request));
		}
	}
	
	@RequestMapping(value = "/mailConfTest.xcn")
	@Description("환경 설정 수정 후 메일 발송")
	//@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO mailConfTest(final HttpServletRequest request) throws Exception {
		JSONObject param = Common.getParam(request);
		if(saveConf(request)) {
			configService.mailConfTest(param.getString("testMailId"), request);
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.change.language", request));
		}
	}
	
	@RequestMapping(value = "/smsConfTest.xcn")
	@Description("환경 설정 수정 후 SMS 발송")
	//@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO smsConfTest(final HttpServletRequest request) throws Exception {
		JSONObject param = Common.getParam(request);
		if(saveConf(request)) {
			//configService.smsConfTest(param.getString("testPhoneNo"), request);
			SmsVO sms = new SmsVO();
			sms.setReceiver(param.getString("testPhoneNo"));
			sms.setContent(Prop.propFormat("setup.sms.test.content", Common.getLocale(request.getSession())));
			sms.setSmsType(SmsType.ADMIN_ALERT);
			
			//log.info("SmsVO : {}" + sms);
			smsSender.sendSms(sms);
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.change.language", request));
		}
	}
	
	private boolean saveConf (final HttpServletRequest request) throws Exception {
		JSONObject param = Common.getParam(request);
		JSONArray confs = Common.toJSONArray(param.get("data"));
		String oldLang = Config.getString("default.lang");
		boolean update_result = true;
		for (int i = 0; i < confs.size(); i++) {
			ConfigVO conf = (ConfigVO) JSONObject.toBean(confs.getJSONObject(i), ConfigVO.class);
			if( Common.isEquals(conf.getConfId(), "default.lang") && Common.isNotEquals(conf.getVal(), oldLang) ){
				update_result = configService.execute(conf);
			}
		}
		if( update_result){
			for (int i = 0; i < confs.size(); i++) {
				ConfigVO conf = (ConfigVO) JSONObject.toBean(confs.getJSONObject(i), ConfigVO.class);
				configService.setConf(conf);
			}
			config.reload();
			return true;
		}
		else{
			return false;
		}
	}
	


	@RequestMapping(value = "/conf.do")
	@Description("환경 설정 페이지")
	public String login(Locale locale, Model model, final HttpServletRequest request) {
		AdminVO admin = Common.getAdmin(request);
		if (Common.isEquals(admin.getFirstAdminYn(), "Y")) {
			return "conf";
		} else {
			return "/emass/index";
		}
	}
}
