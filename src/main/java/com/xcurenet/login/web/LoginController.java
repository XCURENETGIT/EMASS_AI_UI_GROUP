package com.xcurenet.login.web;

import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.RSAPublicKeySpec;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.xcurenet.common.mail.MailInfo;
import com.xcurenet.common.mail.MailSend;
import com.xcurenet.login.MailService;
import lombok.RequiredArgsConstructor;
import org.apache.commons.codec.binary.Base32;
import org.apache.commons.mail.HtmlEmail;
import org.apache.tomcat.util.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.AuditVO;
import com.xcurenet.common.ntp.NtpScheduler;
import com.xcurenet.common.session.SessionManagement;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.customDashboard.service.CustomDashBoardService;
import com.xcurenet.emass.customDashboard.service.CustomDashboardMenuVO;
import com.xcurenet.emass.dashboard.service.DashBoardService;
import com.xcurenet.emass.dashboard.service.DashboardVO;
import com.xcurenet.login.service.LdapLoginService;
import com.xcurenet.login.service.LockRelease;
import com.xcurenet.login.service.LoginVO;
import com.xcurenet.onelogin.saml2.SamlSSOAuth;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;


/**
 * Handles requests for the application home page.
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class LoginController {

	/*	private final JavaMailSender javaMailSender;*/

	private static String RSA_WEB_KEY = "_RSA_WEB_Key_";

	private static String RSA_INSTANCE = "RSA";

	@Resource(name = "adminService")
	public AdminService adminService;

	@Resource(name = "ldapLoginService")
	private LdapLoginService ldapLoginService;

	@Autowired
	public SessionManagement sessionManagement;

	@Resource(name = "auditService")
	public AuditService auditService;

	@Autowired
	public ConfigAdminService configAdminService;

	@Resource(name = "dashBoardService")
	private DashBoardService dashBoardService;

	@Resource(name = "customDashBoardService")
	private CustomDashBoardService customDashBoardService;

	@Autowired
	private NtpScheduler ntpScheduler;

	@Autowired
	private final MailService mailService;

	@Description("본인확인 메일 전송")
	@ResponseBody
	@RequestMapping(value = "/mailSend.xcn")
	public XcnResponseVO sendMail(LoginVO login, final HttpServletRequest request, final HttpSession session) throws Exception {
		PrivateKey privateKey = (PrivateKey) session.getAttribute(LoginController.RSA_WEB_KEY);

		String loginId = decryptRsa(privateKey, login.getUserId());
		login.setUserId(loginId);


		AuditVO audit = new AuditVO();
		audit.setAdminIp(request.getRemoteAddr());
		audit.setPMenuId("SYSTEM");
		audit.setMenuId("CONNECTION");
		audit.setOperation("LOGIN");


		AdminVO admin = adminService.getAdmin(login.getUserId());

		String mail = adminService.getAdmin(admin.getAdminId()).getAdminEmail();



		int number = mailService.sendMail(mail);

		if(number == -1){
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM,"MAILNOCHECK");
		}
	else {
			String num = "" + number;

			session.setAttribute("number", number);

			return new XcnResponseVO(XcnRspCode.OK, num);
		}

	}
	@Description("인증코드 세션 삭제")
	@ResponseBody
	@RequestMapping("/deleteSession.xcn")
	public XcnResponseVO deleteSession(LoginVO login, final HttpServletRequest request, final HttpSession session) throws Exception {
		AdminVO admin = adminService.getAdmin(login.getUserId());
		session.setAttribute(Common.SESSION_CREDENTIAL, admin);
		session.removeAttribute("number");
		return new XcnResponseVO(XcnRspCode.OK);
	}



	@Description("관리자 접속가능 변경")
	@ResponseBody
	@RequestMapping("/updateStatus.xcn")
	public XcnResponseVO statusUpdate(LoginVO login, final HttpServletRequest request, final HttpSession session) throws Exception {

		String title = "";
		login.setUserId(login.getUserId());
		String number1= request.getParameter("number1");

		AdminVO admin = adminService.getAdmin(login.getUserId());

		session.setAttribute(Common.SESSION_CREDENTIAL, admin);

		if (number1 != null&&number1.equals(Common.nvl(session.getAttribute("number")))) {
			adminService.updateAdminStatusOK(login.getUserId()); //인증에 성공한 경우
			//return setLoginEnv(request, session, admin, audit);
			return new XcnResponseVO(XcnRspCode.OK,"SUCCESS").setMessage(Prop.propFormat("인증에 성공했습니다."));
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "FAIL").setMessage(Prop.propFormat("코드가 틀렸습니다"));
		/*else{
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("코드가 틀렸습니다"));
		}
*/
		}
	}


	@RequestMapping(value = "/getRSAKey.xcn")
	@ResponseBody
	public XcnResponseVO getRSAKey(HttpSession session, final HttpServletRequest request) throws NoSuchAlgorithmException, InvalidKeySpecException {

		KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
		generator.initialize(2048);

		KeyPair keyPair = generator.genKeyPair();
		KeyFactory keyFactory = KeyFactory.getInstance("RSA");

		PublicKey publicKey = keyPair.getPublic();
		PrivateKey privateKey = keyPair.getPrivate();

		// 세션에 공개키의 문자열을 키로하여 개인키를 저장한다.
		session.setAttribute("_RSA_WEB_Key_", privateKey);

		// 공개키를 문자열로 변환하여 JavaScript RSA 라이브러리 넘겨준다.
		RSAPublicKeySpec publicSpec = keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);

		String publicKeyModulus = publicSpec.getModulus().toString(16);
		String publicKeyExponent = publicSpec.getPublicExponent().toString(16);

		JSONObject result = new JSONObject();
		result.put("publicKeyModulus", publicKeyModulus);
		result.put("publicKeyExponent", publicKeyExponent);
		return new XcnResponseVO(XcnRspCode.OK, result);
	}

	@RequestMapping(value = "/logout.xcn")
	@Description("로그아웃 처리 프로세스")
	@ResponseBody
	public XcnResponseVO logout(final HttpServletRequest request, final HttpServletResponse response, final HttpSession session) throws Exception {
		AdminVO admin = Common.getAdmin(request);
		AuditVO audit = new AuditVO();
		audit.setAdminIp(admin.getLoginIp());
		audit.setPMenuId("SYSTEM");
		audit.setMenuId("CONNECTION");
		audit.setOperation("LOGOUT");
		audit.setAdminId(admin.getAdminId());
		audit.setAdminName(admin.getAdminName());
		audit.setInformation(Prop.propFormat("logout.success.access"));
		auditService.insertAudit(audit);
		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/logoutSSOProcess.do")
	@Description("SSO 로그아웃 처리 프로세스")
	@ResponseBody
	public void logoutSSOProcess(final LoginVO login, final HttpServletRequest request, final HttpServletResponse response, final HttpSession session) throws Exception {
		XcnResponseVO vo = logout(request, response, session);
		if (vo.isSuccess()) response.sendRedirect(request.getContextPath() + "/logout.do");
		else response.sendRedirect(request.getContextPath() + "/error.do");
	}

	@RequestMapping(value = "/loginSSOProcess.do")
	@Description("SSO 로그인 처리 프로세스")
	@ResponseBody
	public void loginSSOProcess(final LoginVO login, final HttpServletRequest request, final HttpServletResponse response, final HttpSession session) throws Exception {
		XcnResponseVO vo = loginProcess(login, request, response, session);
		if (vo.isSuccess()) response.sendRedirect(request.getContextPath() + "/index.do");
		else if (Common.isEquals(vo.getCode(), XcnRspCode.OK_CUSTOM.get())) {
			request.getSession().setAttribute("message", vo.getMessage());
			response.sendRedirect(request.getContextPath() + "/loginAuth.do");
		} else response.sendRedirect(request.getContextPath() + "/error.do");
	}

	@RequestMapping(value = "/loginProcess.xcn")
	@Description("로그인 처리 프로세스")
	@ResponseBody
	public XcnResponseVO loginProcess(LoginVO login, final HttpServletRequest request, final HttpServletResponse response, final HttpSession session) throws Exception {
		log.info("*************로그인 테스트");

		AuditVO audit = new AuditVO();
		audit.setAdminIp(request.getRemoteAddr());
		audit.setPMenuId("SYSTEM");
		audit.setMenuId("CONNECTION");
		audit.setOperation("LOGIN");

		String msg = "";

		PrivateKey privateKey = (PrivateKey) session.getAttribute(LoginController.RSA_WEB_KEY);
		String loginId = "";
		String loginPw = "";

		String sso_type = Config.getString("sso_type");
		if (Common.isEmpty(login.getUserId()) && Common.isEquals(sso_type, "S")) {
			SamlSSOAuth auth = new SamlSSOAuth(request, response);
			// processing ADFS authentication result.
			auth.processResponse();
			if (!auth.isAuthenticated()) {
				return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "NOT_AUTHENTICATED").setMessage(Prop.propFormat("login.fail.access"));
			}
			login = ssoLoginProcess(request, auth);
		} else {
			loginId = decryptRsa(privateKey, login.getUserId());
			loginPw = decryptRsa(privateKey, login.getUserPw());
			login.setUserId(loginId);
			login.setUserPw(Common.sha256(loginPw));
		}

		if (Common.isEmpty(login.getUserId())) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "ID_REQUIRED").setMessage(Prop.propFormat("login.require.id"));
		}
		if (Common.isEmpty(login.getUserPw()) && Common.isNotEquals(login.getLoginType(), "S")) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "PW_REQUIRED").setMessage(Prop.propFormat("login.require.password"));
		}

		AdminVO admin = adminService.getAdmin(login.getUserId());

		//최초 ldap 인증 확인
		boolean firstLoginCheckFlag = false;
		if (admin == null && Common.isNotEquals(login.getLoginType(), "S")) {
			admin = ldapLoginService.loginProcess(loginId, loginPw);
			if (admin != null && Common.isNotEmpty(admin.getAdminId()) && !adminService.isAdminIdExist(admin)) {
				admin.setAdminPw(Common.EMPTY);
				adminService.insertAdmin(admin);
			}
			firstLoginCheckFlag = true;
		}

		if (admin == null) {
			msg = Prop.propFormat("login.fail") + "(" + login.getUserId() + ")";
			audit.setAdminId(login.getUserId());
			audit.setInformation(msg);
			log.info("[LOGIN FAIL] AUDIT : {}", audit);
			auditService.insertAudit(audit);
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "CORRECT_USER").setMessage(msg);
		} else {
			audit.setAdminId(login.getUserId());
			audit.setAdminName(admin.getAdminName());
		}

		//ldap 인증 로그인
		if (Common.isEquals(admin.getLoginType(), "L")) {
			AdminVO adminVo = admin;
			if (!firstLoginCheckFlag) adminVo = ldapLoginService.loginProcess(loginId, loginPw);

			if (adminVo == null) {
				msg = Prop.propFormat("login.fail") + "(" + login.getUserId() + ")";
				audit.setAdminId(login.getUserId());
				audit.setInformation(msg);
				auditService.insertAudit(audit);
				return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "CORRECT_USER").setMessage(msg);
			} else {
				admin.setAdminPw(Common.sha256(loginPw));
				admin.setAdminEmail(adminVo.getAdminEmail());
				admin.setAdminName(adminVo.getAdminName());
				admin.setLoginType("L");
				admin.setPwchgDt("99991231");
			}
		} else if (Common.isEquals(admin.getLoginType(), "S")) { //SSO 인증 로그인

		}

		admin.setLoginType(login.getLoginType());

		if (Common.isEquals(admin.getStatus(), "L")) {
			msg = Prop.propFormat("login.longterm.unuse");
			audit.setInformation(msg);
			auditService.insertAudit(audit);
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "USER_LOCK").setMessage(msg);
		}

		if (Common.isNotEmpty(admin.getAccessIp())) {
			boolean flag = false;
			String[] ips = Common.toArray(admin.getAccessIp(), ",");
			for (String ip : ips) {
				if (Common.isEquals(ip, request.getRemoteAddr())) {
					flag = true;
					break;
				}
			}
			if (!flag) {
				msg = Prop.propFormat("login.wrong.pc");
				audit.setInformation(msg);
				auditService.insertAudit(audit);
				return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "PC_PERMISSION").setMessage(msg);
			}
		}

		int passwordFailCount = Config.getInt("password.fail.count");
		if (admin.getAccessFailCnt() >= passwordFailCount) {
			msg = Prop.propFormat("login.block.failcount") + "(" + login.getUserId() + ")";
			audit.setAdminName("");
			audit.setInformation(msg);
			auditService.insertAudit(audit);
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "PW_EXCESS").setMessage(msg);
		}

		if (Common.isNotEquals(admin.getAdminPw(), login.getUserPw())) {
			admin.setAccessFailCnt(admin.getAccessFailCnt() + 1);
			adminService.updateUserPasswordWrongCount(admin);
			if (admin.getAccessFailCnt() >= passwordFailCount) {
				LockRelease lock = new LockRelease();
				lock.setAdmin(admin);
				lock.setAdminService(adminService);
				lock.start();
				msg = Prop.propFormat("login.block.failcount") + "(" + login.getUserId() + ")";
				audit.setAdminName("");
				audit.setInformation(msg);

				log.info("[LOGIN FAIL] AUDIT : {}", audit);
				auditService.insertAudit(audit);
				return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "PW_EXCESS").setMessage(msg);
			}

			msg = Prop.propFormat("login.fail") + "(" + login.getUserId() + ")";
			audit.setAdminName("");
			audit.setInformation(msg);
			auditService.insertAudit(audit);
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "CORRECT_USER").setMessage(msg);
		}
		if (Common.isEquals(admin.getUseYn(), "N")) {
			msg = Prop.propFormat("login.cannotuse.id") + "(" + login.getUserId() + ")";
			audit.setAdminName("");
			audit.setInformation(msg);
			auditService.insertAudit(audit);
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "NOTUSED_USER").setMessage(msg);
		}
		/*if (Common.isEmpty(admin.getPwchgDt())) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "PW_CHANGE").setMessage(Prop.propFormat("login.first.access"));
		}*/

		int passwordChangeDay = Config.getInt("password.change.day");
		if (passwordChangeDay <= admin.getPasswordChangeDay()) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "PW_EXPIRED").setMessage(Prop.propFormat("login.expired.password"));
		}

		/**
		 * 구글 OTP 인증
		 */
		if (Common.isEquals(Config.getString("google.otp.used"), "true")) {
			JSONObject re = new JSONObject();

			String adminGenerate = adminService.getAdminGenerate(admin.getAdminId());
			if (Common.isEmpty(adminGenerate)) {
				re = generate(admin.getAdminName());
				return new XcnResponseVO(XcnRspCode.OK, re);
			} else {
				re.put("secretKey", Common.toString(Base64.decodeBase64(adminGenerate)));
				return new XcnResponseVO(XcnRspCode.OK, re);
			}
		}

		return setLoginEnv(request, session, admin, audit);

	}

	private XcnResponseVO setLoginEnv(final HttpServletRequest request, final HttpSession session, AdminVO admin, AuditVO audit) {

		String type = Config.getString("session.duplication.type");
		///SessionManagement sessionManagement = new SessionManagement();
		boolean isExist = false;

		try {
			isExist = sessionManagement.isExistId(admin.getAdminId());
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (isExist && Common.isEquals(type, "A")) {
			sessionManagement.logoutAdminId(request, admin.getAdminId(), request.getRemoteAddr());
		} else if (isExist && Common.isEquals(type, "B")) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "ALREADY_LOGIN").setMessage(Prop.propFormat("login.alreay.access"));
		}

		ConfigAdminVO vo = configAdminService.getConfAdmin("language", admin.getAdminId());
		if (vo != null && Common.isNotEmpty(vo.getVal())) {
			Locale lo = Locale.forLanguageTag(vo.getVal());
			if (lo != null) {
				session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, lo);
			}
		}

		List<DashboardVO> dashboardVo = dashBoardService.getDashBoardConfigs(admin.getAdminId());
		if (dashboardVo.size() == 0) {
			adminService.insertAdminDashBoardConf(admin);
		}

		String msgLastLoginIp = Common.nvl(admin.getLastLoginIp(), "-");
		admin.setLoginIp(request.getRemoteAddr());
		admin.setLastLoginIp(request.getRemoteAddr());

		String authMenu = Common.nvl(adminService.getAdminMenu(admin.getAdminId()));
		if (Common.isEmpty(authMenu)) {
			admin.setMenu("DV,DS,DF,DP,LS,BS,AS,WS,CS,LP");
			adminService.insertAdminMenu(admin);
			authMenu = admin.getMenu();
		}
		if (Common.isEquals(authMenu, "DV,DS,DF,DP,LS,BS,AS,WS,CS,LP")) authMenu = "ALL";
		admin.setMenu(authMenu);

		sessionManagement.createSession(request, admin);
		adminService.updateUserLoginOK(admin);
		JSONObject obj = new JSONObject();
		obj.put("adminName", admin.getAdminName());
		obj.put("pwchgDt", admin.getPwchgDt());
		obj.put("firstAdminYn", admin.getFirstAdminYn());

		String loginMsg = "";
		loginMsg += "\n";
		loginMsg += "\n";
		loginMsg += "         *****  " + Prop.propFormat("login.use.info", Common.getLocale(session), admin.getAdminName()) + "  *****";
		loginMsg += "\n";
		loginMsg += "\n";
		loginMsg += Prop.propFormat("login.lastlogin.date", Common.getLocale(session)) + " : " + Common.nvl(admin.getLastLoginDt(), "-") + "\n";
		loginMsg += Prop.propFormat("login.lastlogin.ip", Common.getLocale(session)) + " : " + msgLastLoginIp + "\n";
		loginMsg += "\n";
		loginMsg += Prop.propFormat("login.currentlogin.date", Common.getLocale(session)) + " : " + Common.nvl(Common.getTime(), "-") + "\n";
		loginMsg += Prop.propFormat("login.currentlogin.ip", Common.getLocale(session)) + " : " + Common.nvl(request.getRemoteAddr(), "-") + "\n";

		JSONObject ntpStatus = ntpScheduler.getNtpStatus();
		loginMsg += "\n";
		loginMsg += "\n";
		loginMsg += "         *****  " + Prop.propFormat("trap.message.ntp", Common.getLocale(session)) + "  *****";
		loginMsg += "\n";
		loginMsg += "\n";
		loginMsg += Prop.propFormat("trap.message.ntp.server", Common.getLocale(session)) + " : " + ntpStatus.getString("ntpServer") + "\n";

		if (Common.isEquals(ntpStatus.getString("status"), "sync")) {
			loginMsg += Prop.propFormat("trap.message.ntp.sync.msg", Common.getLocale(session)) + " : " + Prop.propFormat("trap.message.ntp.sync", Common.getLocale(session)) + "\n";
		} else if (Common.isEquals(ntpStatus.getString("status"), "unsync")) {
			loginMsg += Prop.propFormat("trap.message.ntp.sync.msg", Common.getLocale(session)) + " : " + Prop.propFormat("trap.message.ntp.unsync", Common.getLocale(session)) + "\n";
		} else {
			loginMsg += Prop.propFormat("trap.message.ntp.sync.msg", Common.getLocale(session)) + " : " + Prop.propFormat("trap.message.ntp.unconnect", Common.getLocale(session)) + "\n";
		}

		obj.put("welcomeInfo", loginMsg);

		CustomDashboardMenuVO dashVo = new CustomDashboardMenuVO();
		dashVo.setAdminId(admin.getAdminId());
		dashVo.setDefaultMenu("Y");
		List<CustomDashboardMenuVO> menuList = customDashBoardService.getDashBoardMenuList(dashVo);
		if (menuList.size() > 0) obj.put("menuKey", menuList.get(0).getMenuKey());

		audit.setInformation(Prop.propFormat("login.success.access"));
		auditService.insertAudit(audit);

		return new XcnResponseVO(XcnRspCode.OK, obj);
	}

	@RequestMapping(value = "/updateAdminInfo.xcn")
	@Description("최초 운용자 수정")
	@ResponseBody
	public XcnResponseVO updateAdminInfo(final HttpServletRequest request, final AdminVO admin) throws Exception {
		admin.setOldId(Common.getAdminId(request));
		return new XcnResponseVO(XcnRspCode.OK, adminService.updateAdminInfo(admin));
	}

	@RequestMapping(value = "/getAllIpMacList.xcn")
	@Description("system IP 목록")
	@ResponseBody
	public XcnResponseVO getAllIpMacList(final HttpServletRequest request) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, adminService.getAllIpMacList());
	}

	@RequestMapping(value = "/secretKeySave.xcn")
	@Description("구글 OTP 계정 저장")
	@ResponseBody
	public XcnResponseVO secretKeySave(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = request.getParameter("userId");
		String secretKey = request.getParameter("secretKey");
		String pinCode = request.getParameter("pinCode");
		String firstOTP = request.getParameter("firstOTP");

		PrivateKey privateKey = (PrivateKey) session.getAttribute(LoginController.RSA_WEB_KEY);

		String loginId = decryptRsa(privateKey, adminId);
		String loginCode = decryptRsa(privateKey, pinCode);
		String loginSecreKey = decryptRsa(privateKey, secretKey);

		AuditVO audit = new AuditVO();
		audit.setAdminIp(request.getRemoteAddr());
		audit.setPMenuId("SYSTEM");
		audit.setMenuId("CONNECTION");
		audit.setOperation("LOGIN");
		audit.setAdminId(loginId);

		if (!checkCode(loginCode, loginSecreKey)) {
			String msg = Prop.propFormat("login.google.otp.pincode.error") + "(" + adminId + ")";
			audit.setAdminName("");
			audit.setInformation(msg);
			auditService.insertAudit(audit);
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("login.google.otp.pincode.errorMsg"));
		}

		if (Common.isEquals(firstOTP, "true")) {
			byte[] encSecretKey = loginSecreKey.getBytes();
			adminService.insertAdminGenerate(loginId, Base64.encodeBase64String(encSecretKey));
		}

		AdminVO admin = adminService.getAdmin(loginId);

		audit.setAdminName(admin.getAdminName());

		return setLoginEnv(request, session, admin, audit);
	}

	@RequestMapping(value = "/reloadGoogleOTP.xcn")
	@Description("구글 OTP 개인키 재발급")
	@ResponseBody
	public XcnResponseVO reloadGoogleOTP(LoginVO login, final HttpServletRequest request, final HttpSession session) throws Exception {
		PrivateKey privateKey = (PrivateKey) session.getAttribute(LoginController.RSA_WEB_KEY);

		String loginId = decryptRsa(privateKey, login.getUserId());
		login.setUserId(loginId);

		AuditVO audit = new AuditVO();
		audit.setAdminIp(request.getRemoteAddr());
		audit.setPMenuId("SYSTEM");
		audit.setMenuId("CONNECTION");
		audit.setOperation("LOGIN");

		AdminVO admin = adminService.getAdmin(login.getUserId());

		adminService.deleteAdminGenerate(admin.getAdminId());
		JSONObject obj = new JSONObject();
		obj = generate(admin.getAdminName());

		audit.setAdminId(login.getUserId());
		audit.setAdminName(admin.getAdminName());
		audit.setInformation(Prop.propFormat("login.google.otp.reload"));
		auditService.insertAudit(audit);

		return new XcnResponseVO(XcnRspCode.OK, obj);
	}

	private String decryptRsa(PrivateKey privateKey, String securedValue) throws Exception {
		Cipher cipher = Cipher.getInstance(LoginController.RSA_INSTANCE);
		byte[] encryptedBytes = hexToByteArray(securedValue);
		cipher.init(Cipher.DECRYPT_MODE, privateKey);
		byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
		String decryptedValue = new String(decryptedBytes, Common.UTF8);
		return decryptedValue;
	}

	/**
	 * 16진 문자열을 byte 배열로 변환한다.
	 *
	 * @param hex
	 * @return
	 */
	public static byte[] hexToByteArray(String hex) {
		if (hex == null || hex.length() % 2 != 0) {
			return new byte[]{};
		}

		byte[] bytes = new byte[hex.length() / 2];
		for (int i = 0; i < hex.length(); i += 2) {
			byte value = (byte) Integer.parseInt(hex.substring(i, i + 2), 16);
			bytes[(int) Math.floor(i / 2)] = value;
		}
		return bytes;
	}

	public LoginVO ssoLoginProcess(HttpServletRequest request, SamlSSOAuth auth) {
		AdminVO admin = new AdminVO();

		Map<String, List<String>> attributes = auth.getAttributes();
		Collection<String> keys = attributes.keySet();

		if (attributes.size() == 0) {
			String nameId = auth.getNameId();
			if (Common.isEmpty(nameId)) nameId = Common.nvl(request.getSession().getAttribute("uid"));
			admin.setAdminId(nameId);
			admin.setAdminName("");
			log.info("[SSO] Login NameId : {}, session nameId : {}", auth.getNameId(), Common.nvl(request.getSession().getAttribute("uid")));
		}

		for (String name : keys) {
			log.info("[SSO] key : {}, value : {}", name, attributes.get(name).get(0));
			if (name.contains("uid")) {
				List<String> values = attributes.get(name);
				admin.setAdminId(values.get(0));
			}

			if (name.contains("cn")) {
				List<String> values = attributes.get(name);
				admin.setAdminName(values.get(0));
			}

			if (name.contains("mail")) {
				List<String> values = attributes.get(name);
				admin.setAdminEmail(values.get(0));
			}
		}

		// sso연계를 통해서 최초 로그인인 경우 신규로 등록함
		if (Common.isNotEmpty(admin.getAdminId()) && !adminService.isAdminIdExist(admin)) {
			if (Common.isEmpty(Config.getString("sso_authorization"))) {
				admin.setAdminPw(Common.EMPTY);
				admin.setFirstAdminYn("N");
				admin.setAdminType("M");
				admin.setAdminTypeInfo("M");
				admin.setUseYn("Y");
				admin.setMenu("DV,DS,DF,DP,LS,BS,AS,WS,CS,LP");
				admin.setApprobator("N");
				admin.setLoginType("S");
				admin.setInfoFeedbackYn("N");
				admin.setPwchgDt("99991231");
				adminService.insertAdmin(admin);
			}
		}
		if (adminService.isAdminIdExist(admin)) adminService.insertAdminCheck(admin);

		LoginVO result = new LoginVO();
		result.setUserId(admin.getAdminId());
		result.setLoginType("S");

		return result;
	}

	/**
	 * 구글 OTP - 최초 로그인 시 OTP 계정 생성에 필요한
	 * QR코드 및 개인키 생성
	 *
	 * @param userName 운용자 ID
	 * @param domain   운용자 email의 도메인
	 * @return
	 */
	private JSONObject generate(String userName) {
		JSONObject result = new JSONObject();
		byte[] buffer = new byte[5 + 5 * 5];
		new Random().nextBytes(buffer);
		Base32 codec = new Base32();
		byte[] secretKey = Arrays.copyOf(buffer, 10);
		byte[] bEncodedKey = codec.encode(secretKey);

		String encodedKey = new String(bEncodedKey);
		String url = getQRcodeURL(userName, encodedKey);

		result.put("secretKey", encodedKey);
		result.put("qrCodeURL", url);

		return result;
	}

	/**
	 * 구글 OTP - QR코드 생성
	 *
	 * @param userName  운용자 ID
	 * @param domain    운용자 email의 도메인
	 * @param encodeKey 구글 OTP 개인키
	 * @return
	 */
	private String getQRcodeURL(String userName, String encodeKey) {
		String orig = "http://chart.apis.google.com/chart?cht=qr&chs=100x100&chl=otpauth://totp/%s%%3Fsecret%%3D%s&chld=H|0";
		return String.format(orig, userName, encodeKey);
	}

	/**
	 * 구글 OTP - 입력한 코드 확인
	 *
	 * @param inCode     입력 코드
	 * @param secretCode 개인키
	 * @return
	 */
	private boolean checkCode(String inCode, String secretCode) {
		long otpnum = Integer.parseInt(inCode); //google OTP 앱에 표시되는 번호
		long delay = new Date().getTime() / 30000; //google OTP 앱 번호의 주기 (30초)
		boolean re = false;

		try {
			Base32 codec = new Base32();
			byte[] decodedKey = codec.decode(secretCode);
			int window = 3;
			for (int i = -window; i <= window; ++i) {
				long hash = verify_code(decodedKey, delay + i);
				if (hash == otpnum) {
					re = true;
					break;
				}
			}
		} catch (InvalidKeyException | NoSuchAlgorithmException e) {
			e.printStackTrace();
		}

		return re;
	}

	/**
	 * 구글 OTP - OTP Key 검증
	 *
	 * @param key
	 * @param t
	 * @return
	 * @throws NoSuchAlgorithmException
	 * @throws InvalidKeyException
	 */
	private int verify_code(byte[] key, long t) throws NoSuchAlgorithmException, InvalidKeyException {
		byte[] data = new byte[8];
		long value = t;

		for (int i = 8; i-- > 0; value >>>= 8) {
			data[i] = (byte) value;
		}

		SecretKeySpec signKey = new SecretKeySpec(key, "HmacSHA1");
		Mac mac = Mac.getInstance("HmacSHA1");
		mac.init(signKey);
		byte[] hash = mac.doFinal(data);

		int offset = hash[20 - 1] & 0xF;

		long truncateHash = 0;
		for (int i = 0; i < 4; ++i) {
			truncateHash <<= 8;
			truncateHash |= (hash[offset + i] & 0xFF);
		}

		truncateHash &= 0x7FFFFFFF;
		truncateHash %= 1000000;

		return (int) truncateHash;
	}

}


