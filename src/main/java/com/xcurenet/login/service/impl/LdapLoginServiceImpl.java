package com.xcurenet.login.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.login.service.LdapLoginService;

import ldap.ADUser;
import ldap.LdapMain;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import vo.XcnResponseVO;


@Service("ldapLoginService")
@Slf4j
public class LdapLoginServiceImpl extends XcnAbstractDAO implements LdapLoginService {

	@Override
	public AdminVO loginProcess(String adminId, String adminPw) {
 		log.info("[LDAP] LOGIN CHECK");
		AdminVO adminVO = null;
		String type = Config.getString("cert.type");
		if(Common.isEmpty(type) || Common.isNotEquals(type, "cert")) return adminVO;
		
		String url = Config.getString("cert.ldap.url");
		String port = Config.getString("cert.ldap.port");
		String account = Config.getString("cert.ldap.account");
		String password = Config.getString("cert.ldap.password");
		String dn = Config.getString("cert.ldap.dn");
		String name = Config.getString("cert.ldap.name");
		String bind = Config.getString("cert.ldap.bind");
		String bindAdminId = "";
		String bindAdminName = "";
		String bindAdminEmail = "";
		
		if(Common.isNotEmpty(bind)) {
			String [] bindData = bind.split("\\|");
			if(bindData.length > 2) {
				bindAdminId = bindData[0];
				bindAdminName = bindData[1];
				bindAdminEmail = bindData[2];
			}
		}
		
		Map<String, String> connectionInfo = new HashMap<>();
		connectionInfo.put("url", url);
		connectionInfo.put("port", port);
		connectionInfo.put("account", account);
		connectionInfo.put("password", password);
		connectionInfo.put("dn", dn);
		connectionInfo.put("name", name);
		
		connectionInfo.put("adminId", bindAdminId);
		connectionInfo.put("adminName", bindAdminName);
		connectionInfo.put("adminEmail", bindAdminEmail);
		
		LdapMain ldap = new LdapMain(connectionInfo);
		XcnResponseVO resultVo = ldap.checkAuthentification(adminId, adminPw);
		
		if(resultVo.getData() == null || JSONObject.fromObject(resultVo.getData()).size() == 0) {
			log.info(resultVo.getMessage());
			return adminVO;
		}
		ADUser adUser = (ADUser) JSONObject.toBean(JSONObject.fromObject(resultVo.getData()), ADUser.class);
		log.info(adUser.toString());
 		adminVO = new AdminVO();
		adminVO.setAdminId(adUser.getAdminId());
		adminVO.setAdminPw(Common.sha256(adminPw));
		adminVO.setAdminEmail(adUser.getAdminEmail());
		adminVO.setAdminName(adUser.getAdminName());
		adminVO.setFirstAdminYn("N");
		adminVO.setAdminType("M");
		adminVO.setAdminTypeInfo("M");
		adminVO.setUseYn("Y");
		adminVO.setMenu("DV,DS,DF,DP,LS,BS,AS,WS,CS,LP");
		adminVO.setApprobator("N");
		adminVO.setLoginType("L");
		adminVO.setInfoFeedbackYn("N");
		adminVO.setPwchgDt("99991231");
		
		return adminVO;
	}
}
