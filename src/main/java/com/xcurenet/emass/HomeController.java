package com.xcurenet.emass;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.onelogin.saml2.SamlSSOAuth;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Locale;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	@Autowired
	public AdminService adminService;

	@Autowired
	private HttpSession httpSession;

	@Resource(name = "auditService")
	public AuditService auditService;

	@Resource(name = "configAdminService")
	public ConfigAdminService configAdminService;

	@RequestMapping(value = "/error.do", method = RequestMethod.GET)
	@Description("에러 페이지")
	public String error(final HttpSession session, final HttpServletRequest request, @RequestParam(required = false) String locale) {
		return "/commons/error";
	}


	@RequestMapping(value = "/blank.do", method = RequestMethod.GET)
	@Description("에러 페이지")
	public String blank(final HttpSession session, final HttpServletRequest request, @RequestParam(required = false) String locale) {
		return "/commons/blank";
	}


	@RequestMapping(value = "/print.do", method = RequestMethod.GET)
	@Description("인쇄 페이지")
	public String print(final HttpSession session, final HttpServletRequest request, @RequestParam(required = false) String locale) {
		return "/print-grid";
	}

	@RequestMapping(value = "/changeLocale", method = RequestMethod.GET)
	@Description("언어 변경 후 호출 페이지")
	public String changeLocale(final HttpSession session, final HttpServletRequest request, @RequestParam(required = false) String locale) {
		Locale lo = null;
		if (locale.matches("en")) {
			lo = Locale.ENGLISH;
		} else if (locale.matches("ko")) {
			lo = Locale.KOREAN;
		} else {
			locale = "ko";
			lo = Locale.KOREAN;
		}
		ConfigAdminVO conf = new ConfigAdminVO();
		conf.setAdminId(Common.getAdminId(request));
		conf.setConfId("language");
		conf.setVal(locale);
		configAdminService.setConfAdmin(conf);
		session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, lo);
		String redirectURL = "redirect:" + request.getHeader("referer");
		return redirectURL;
	}

	@RequestMapping(value = "/", method = RequestMethod.GET)
	@Description("메인 페이지")
	public String root(Locale locale, Model model) {
		return "/emass/dashboard";
	}

	@RequestMapping(value = "/index.do")
	@Description("DashBoard 페이지")
	public String index(Locale locale, Model model) {
		model.addAttribute("headerYn","N");
		return "/emass/dashboard";
	}

	@RequestMapping(value = "/ems/contentList.do", method = RequestMethod.GET)
	@Description("목록 페이지")
	public String contentList(Locale locale, Model model) {
		return "/emass/message/contentList";
	}

	@RequestMapping(value = "/ems/contentListUnknown.do", method = RequestMethod.GET)
	@Description("목록 페이지")
	public String contentListUnknown(Locale locale, Model model) {
		return "/emass/message/contentListUnknown";
	}

	@RequestMapping(value = "/ems/dashboardSetup.do", method = RequestMethod.GET)
	@Description("dashboard Setup 페이지")
	public String dashboardSetup(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/dashboardSetup";
	}

	@RequestMapping(value = "/ems/dashboardMenu.do", method = RequestMethod.GET)
	@Description("dashboard 메뉴 페이지")
	public String dashboardMenu(Locale locale, Model model) {
		return "/emass/dashboardMenu";
	}

	@RequestMapping(value = "/ems/index.do")
	@Description("DashBoard 페이지")
	public String index2(Locale locale, Model model) {
		return "/emass/dashboard";
	}


	@RequestMapping(value = "/login.do", method = RequestMethod.GET)
	@Description("로그인 페이지")
	public String login(Locale locale, Model model, final HttpServletResponse response, final HttpServletRequest request, final HttpSession session) throws Exception {

		return "/login";
	}

	@RequestMapping(value = "/logout.do", method = RequestMethod.GET)
	@Description("로그아웃 페이지")
	public String logout(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		if (session != null) {
			session.removeAttribute(Common.SESSION_CREDENTIAL);
		}

		return "redirect:login.do";
	}

	@RequestMapping(value = "/loginSSO.do")
	@Description("로그인 페이지")
	public String loginSSO(Locale locale, Model model, final HttpServletResponse response, final HttpServletRequest request, final HttpSession session) throws Exception {
		return "/loginSSO";
	}

	@RequestMapping(value = "/loginAuth.do")
	@Description("SSO 로그인 실패 페이지")
	public String loginAuth(Locale locale, Model model, final HttpServletResponse response, final HttpServletRequest request, final HttpSession session) throws Exception {
		return "/loginAuth";
	}

	@RequestMapping(value = "/logoutSSO.do")
	@Description("로그아웃 성공 페이지")
	public void logoutSSO(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		AdminVO admin = Common.getAdmin(request);
		if(Common.isEquals(admin.getLoginType(), "S")) {
			SamlSSOAuth auth = null;
			try {
				auth = new SamlSSOAuth(request, response);
				auth.logout("/logoutSSOProcess.do", Common.nvl(session.getAttribute("uid")), Common.nvl(session.getAttribute("sessionIndex")), false,
						Common.nvl(session.getAttribute("nameidFormat")), false);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	@RequestMapping(value = "/commons/deviceInfo.do", method = RequestMethod.GET)
	@Description("장비 정보 페이지")
	public String deviceInfo(Locale locale, Model model) {
		return "/commons/deviceInfoMysql";
	}

	@RequestMapping(value = "/commons/deviceInfoDetail.do", method = RequestMethod.GET)
	@Description("장비 정보 상세보기 페이지")
	public String hadoopDeviceInfo(Locale locale, Model model) {
		if (Common.isOrEquals(Common.getAdminType(httpSession), "S", "M", "C")) {
			model.addAttribute("headerYn","N");
			return "/commons/deviceInfoDetailMysql";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/deviceInfoDetailHadoop.do", method = RequestMethod.GET)
	@Description("장비 정보(Hadoop) 상세보기 페이지")
	public String hadoopDeviceInfoHadoop(Locale locale, Model model) {
		if (Common.isOrEquals(Common.getAdminType(httpSession), "S", "M", "C")) {
			model.addAttribute("headerYn","N");
			return "/commons/deviceInfoDetailHadoop";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/organizationInfo.do", method = RequestMethod.GET)
	@Description("조직 코드관리 페이지")
	public String organizationInfo(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/commons/organizationInfo";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/codeInfo.do", method = RequestMethod.GET)
	@Description("코드정보 페이지")
	public String codeInfo(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/commons/codeInfo";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/userInfo.do", method = RequestMethod.GET)
	@Description("사용자 관리 페이지")
	public String usersInfo(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/commons/userInfo";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/userGroup.do", method = RequestMethod.GET)
	@Description("사용자 그룹 관리 페이지")
	public String userGroup(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/commons/userGroup";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/ipRange.do", method = RequestMethod.GET)
	@Description("사업장 내부 IP 설정 페이지")
	public String ipRange(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/commons/ipRange";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/ipRangeDept.do", method = RequestMethod.GET)
	@Description("사업장 내부 IP 설정 페이지")
	public String ipRangeDept(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/commons/ipRangeDept";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/ipRangeView.do", method = RequestMethod.GET)
	@Description("사업장 내부 IP 확인 페이지")
	public String ipRangeView(Locale locale, Model model) {
		return "/commons/ipRangeView";
	}

	@RequestMapping(value = "/commons/ipRangeDeptView.do", method = RequestMethod.GET)
	@Description("부서 내부 IP 확인 페이지")
	public String ipRangeDeptView(Locale locale, Model model) {
		return "/commons/ipRangeDeptView";
	}

	@RequestMapping(value = "/commons/auditLog.do", method = RequestMethod.GET)
	@Description("감사로그 페이지")
	public String auditLog(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			model.addAttribute("headerYn","Y");
			return "/commons/auditLog";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/holidayBusiness.do", method = RequestMethod.GET)
	@Description("사업장 휴일 페이지")
	public String holidayBusiness(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/commons/holidayBusiness";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/holidayLegal.do", method = RequestMethod.GET)
	@Description("법정 공휴일 페이지")
	public String holidayLegal(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/commons/holidayLegal";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/eventLog.do", method = RequestMethod.GET)
	@Description("SNMP TRAP 로그 페이지")
	public String eventLog(Locale locale, Model model) {
		if (Common.isOrEquals(Common.getAdminType(httpSession), "S", "M", "C")) {
			model.addAttribute("headerYn","Y");
			return "/commons/eventLog";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/admin.do", method = RequestMethod.GET)
	@Description("운용자 관리 페이지")
	public String admin(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/commons/admin";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/json.do", method = RequestMethod.GET)
	@Description("JSON Viewer")
	public String json(Locale locale, Model model) {
		return "/commons/json";
	}

	/**
	 * Message Information
	 *
	 * @param locale
	 * @param model
	 * @return
	 */

	@RequestMapping(value = "/ems/message.do")
	@Description("EDC 메시지 검색 페이지(전체)")
	public String message(Locale locale, Model model) {
		return "/emass/message/messageNewN";
	}

	@RequestMapping(value = "/ems/monitorMessage.do")
	@Description("EDC 메시지 검색 페이지(모니터링)")
	public String monitorMessage(Locale locale, Model model) {
		return "/emass/message/monitorMessage";
	}

	@RequestMapping(value = "/ems/messageUnknown.do")
	@Description("EDC 메시지 검색 페이지(전체)")
	public String messageUnknown(Locale locale, Model model) {
		return "/emass/message/messageUnknown";
	}

	@RequestMapping(value = "/ems/messageFolder.do")
	@Description("EDC 메시지 검색 페이지(전체)")
	public String messageFolder(Locale locale, Model model) {
		return "/emass/message/messageFolder.popup";
	}

	@RequestMapping(value = "/ems/msg/messenger.do", method = RequestMethod.GET)
	@Description("메시징")
	public String messenger(Locale locale, Model model) {
		model.addAttribute("headerYn","N");
		return "/emass/message/msg/messenger";
	}

	@RequestMapping(value = "/ems/msg/messengerdo", method = RequestMethod.GET)
	@Description("메시징")
	public String messenger_test(Locale locale, Model model) {
		model.addAttribute("headerYn","N");
		return "/emass/message/msg/messenger";
	}

	@RequestMapping(value = "/ems/msg/generativeAi.do", method = RequestMethod.GET)
	@Description("생성형ai ")
	public String generativeAi(Locale locale, Model model) {
		model.addAttribute("headerYn","N");
		return "/emass/message/msg/GenerativeAi";
	}

	@RequestMapping(value = "/ems/msg/note.do", method = RequestMethod.GET)
	@Description("테스트")
	public String note(Locale locale, Model model) {
		model.addAttribute("headerYn","N");
		return "/emass/message/msg/note";
	}

	@RequestMapping(value = "/ems/msg/fileTransfer.do", method = RequestMethod.GET)
	@Description("테스트")
	public String test(Locale locale, Model model) {
		model.addAttribute("headerYn","N");
		return "/emass/message/msg/fileTransfer";
	}
	@RequestMapping(value = "/ems/contentBody.do", method = RequestMethod.GET)
	@Description("본문 페이지")
	public String contentBody(Locale locale, Model model) {
		return "/emass/message/contentBody";
	}
	@RequestMapping(value = "/ems/contentBodyNew.do", method = RequestMethod.GET)
	@Description("본문 페이지")
	public String contentBodyNew(Locale locale, Model model) {
		return "/emass/message/contentBodyNew";
	}

	@RequestMapping(value = "/ems/contentBodyUnknown.do", method = RequestMethod.GET)
	@Description("본문 페이지")
	public String contentBodyUnknown(Locale locale, Model model) {
		return "/emass/message/contentBodyUnknown";
	}

	@RequestMapping(value = "/ems/mailFoward.do", method = RequestMethod.GET)
	@Description("메일 전달 페이지")
	public String mailFoward(Locale locale, Model model) {
		return "/emass/message/mailFoward.popup";
	}

	@RequestMapping(value = "/ems/warningMail.do", method = RequestMethod.GET)
	@Description("경고 메일 페이지")
	public String warningMail(Locale locale, Model model) {
		return "/emass/message/warningMail.popup";
	}

	@RequestMapping(value = "/ems/domainInfo.do", method = RequestMethod.GET)
	@Description("도메인 정보 페이지")
	public String domainInfo(Locale locale, Model model) {
		return "/emass/message/domainInfo.popup";
	}

	@RequestMapping(value = "/ems/attachText.do", method = RequestMethod.GET)
	@Description("첨부파일 내용 보기 페이지")
	public String attachText(Locale locale, Model model) {
		return "/emass/message/attachText.popup";
	}

	@RequestMapping(value = "/ems/originalText.do", method = RequestMethod.GET)
	@Description("원문/헤더 내용 보기 페이지")
	public String originalText(Locale locale, Model model) {
		return "/emass/message/originalText.popup";
	}

	@RequestMapping(value = "/ems/fileInfoPop.do", method = RequestMethod.GET)
	@Description("첨부파일 정보 보기 페이지")
	public String fileInfo(Locale locale, Model model) {
		return "/emass/message/fileInfoPop.popup";
	}

	@RequestMapping(value = "/ems/participantFileInfoPop.do", method = RequestMethod.GET)
	@Description("참여자 정보 첨부파일 보기 페이지")
	public String participantFileInfoPop(Locale locale, Model model) {
		return "/emass/message/participantFileInfoPop.popup";
	}

	@RequestMapping(value = "/ems/interestUserInfoPop.do", method = RequestMethod.GET)
	@Description("관심 사용자 정보 보기 페이지")
	public String interestUserInfoPop(Locale locale, Model model) {
		return "/emass/message/interestUserInfoPop.popup";
	}

	@RequestMapping(value = "/ems/userInfoPop.do", method = RequestMethod.GET)
	@Description("사용자(수신자) 정보 보기 페이지")
	public String userInfo(Locale locale, Model model) {
		return "/emass/message/userInfoPop.popup";
	}

	@RequestMapping(value = "/ems/userGroupInfoPop.do", method = RequestMethod.GET)
	@Description("참여자 정보 보기 페이지(그룹방)")
	public String userGroupInfo(Locale locale, Model model) {
		return "/emass/message/userGroupInfoPop";
	}

	@RequestMapping(value = "/ems/regexpInfoPop.do", method = RequestMethod.GET)
	@Description("패턴 정보 보기 페이지")
	public String regexpInfo(Locale locale, Model model) {
		return "/emass/message/regexpInfoPop.popup";
	}

	@RequestMapping(value = "/ems/overlapInfoPop.do")
	@Description("중복 메시지 전체 보기 페이지")
	public String overlapInfoPop(Locale locale, Model model) {
		return "/emass/message/overlapInfoPop.popup";
	}

	@RequestMapping(value = "/ems/participantInfoPop.do", method = RequestMethod.GET)
	@Description("메신저 참여자 정보 보기 페이지")
	public String participantInfoPop(Locale locale, Model model) {
		return "/emass/message/participantInfoPop.popup";
	}

	/**
	 * usersStat JSP.
	 */
	@RequestMapping(value = "/ems/usersStat.do", method = RequestMethod.GET)
	@Description("사용자 통계 페이지")
	public String usersStat(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/usersStat";
	}

	/**
	 * usersStat JSP.
	 */
	@RequestMapping(value = "/ems/dstIpTop.do", method = RequestMethod.GET)
	@Description("목적지 IP 통계")
	public String dstIpTop(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/dstIpTop";
	}


	/**
	 * usersStat JSP.
	 */
	@RequestMapping(value = "/ems/dstPortTop.do", method = RequestMethod.GET)
	@Description("목적지 Port 통계")
	public String dstPortTop(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/dstPortTop";
	}

	/**
	 * usersStat JSP.
	 */
	@RequestMapping(value = "/ems/srcIpTop.do", method = RequestMethod.GET)
	@Description("출발지 IP 통계")
	public String srcIpTop(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/srcIpTop";
	}

	/**
	 * usersStat JSP.
	 */
	@RequestMapping(value = "/ems/webUrlTop.do", method = RequestMethod.GET)
	@Description("WEB URL TOP 통계")
	public String webUrlTop(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/webUrlTop";
	}


	/**
	 * usersStat JSP.
	 */
	@RequestMapping(value = "/ems/ipNonIp.do", method = RequestMethod.GET)
	@Description("IP / None IP 통계")
	public String ipNonIp(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/ipNonIp";
	}


	@RequestMapping(value = "/analysis/usageCompare.do", method = RequestMethod.GET)
	@Description("사용량 즌감 분석")
	public String userCompare(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/analysis/usageCompare";
	}

	@RequestMapping(value = "/analysis/userBehavior.do", method = RequestMethod.GET)
	@Description("사용자 행위 분석")
	public String userBehavior(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/analysis/userBehavior";
	}

	@RequestMapping(value = "/analysis/searchKeyword.do", method = RequestMethod.GET)
	@Description("웹 검색어 분석")
	public String searchKeyword(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/analysis/searchKeyword";
	}



	/**
	 * interestUserStat JSP.
	 */
	@RequestMapping(value = "/ems/interestUserStat.do", method = RequestMethod.GET)
	@Description("관심 사용자 통계 페이지")
	public String interestUserStat(Locale locale, Model model) {

		model.addAttribute("headerYn","Y");

		return "/emass/statistics/interestUserStat";
	}

	/**
	 * attachNameStat JSP.
	 */
	@RequestMapping(value = "/ems/attachNameStat.do", method = RequestMethod.GET)
	@Description("첨부파일명 통계 페이지")
	public String attachNameStat(Locale locale, Model model) {

		model.addAttribute("headerYn","Y");
		return "/emass/statistics/attachNameStat";
	}

	/**
	 * attachTypeStat JSP.
	 */
	@RequestMapping(value = "/ems/attachTypeStat.do", method = RequestMethod.GET)
	@Description("첨부파일 타입 통계 페이지")
	public String attachTypeStat(Locale locale, Model model) {

		model.addAttribute("headerYn","Y");
		return "/emass/statistics/attachTypeStat";
	}

	/**
	 * hostStat JSP.
	 */
	@RequestMapping(value = "/ems/hostStat.do", method = RequestMethod.GET)
	@Description("URL 통계 페이지")
	public String hostStat(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/hostStat";
	}

	/**
	 * keywordStat JSP.
	 */
	@RequestMapping(value = "/ems/keywordStat.do", method = RequestMethod.GET)
	@Description("예약어 통계 페이지")
	public String keywordStat(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/keywordStat";
	}

	/**
	 * senderStat JSP.
	 */
	@RequestMapping(value = "/ems/senderStat.do", method = RequestMethod.GET)
	@Description("발신자 통계 페이지")
	public String senderStat(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/senderStat";
	}

	/**
	 * serviceStat JSP.
	 */
	@RequestMapping(value = "/ems/serviceStat.do", method = RequestMethod.GET)
	@Description("서비스타입 통계 페이지")
	public String serviceStat(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/serviceStat";
	}

	/**
	 * adminReadStat JSP.
	 */
	@RequestMapping(value = "/ems/adminReadStat.do", method = RequestMethod.GET)
	@Description("관리자 열람 통계 페이지")
	public String adminReadStat(Locale locale, Model model) {

		model.addAttribute("headerYn","Y");
		return "/emass/statistics/adminReadStat";
	}

	/**
	 * manualStat JSP.
	 */
	@RequestMapping(value = "/ems/manualStat.do", method = RequestMethod.GET)
	@Description("사용자 정의 통계 페이지")
	public String manualStat(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/manualStat";
	}

	/**
	 * trafficStat JSP.
	 */
	@RequestMapping(value = "/ems/trafficStat.do", method = RequestMethod.GET)
	@Description("장비 트래픽 통계 페이지")
	public String trafficStat(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");

		return "/emass/statistics/trafficStat";
	}

	/**
	 * ocrStat JSP.
	 */
	@RequestMapping(value = "/ems/ocrStat.do", method = RequestMethod.GET)
	@Description("OCR 통계 페이지")
	public String ocrStat(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/ocrStat";
	}

	/**
	 * infoTypeStat JSP.
	 */
	@RequestMapping(value = "/ems/infoTypeStat.do", method = RequestMethod.GET)
	@Description("정보 분류 통계 페이지")
	public String infoTypeStat(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/statistics/infoTypeStat";
	}


	/**
	 * infoStat JSP.
	 */
	@RequestMapping(value = "/analysis/infoStat.do", method = RequestMethod.GET)
	@Description("개인정보 관계 분석 페이지")
	public String infoStat(Locale locale, Model model) {
		return "/emass/statistics/infoStat";
	}


	/**
	 * interestUser JSP.
	 */
	@RequestMapping(value = "/ems/interestUser.do", method = RequestMethod.GET)
	@Description("관심 사용자 관리 페이지")
	public String interestUser(Locale locale, Model model) {

		model.addAttribute("headerYn","Y");
		return "/emass/interestUser/interestUser";
	}

	/**
	 * interestUser JSP.
	 */
	@RequestMapping(value = "/ems/interestUserProfile.do", method = RequestMethod.GET)
	@Description("관심 사용자 관리 페이지")
	public String interestUserProfile(Locale locale, Model model) {

		model.addAttribute("headerYn","Y");
		return "/emass/interestUser/interestUserProfile";
	}

	/**
	 * interestUser JSP.
	 */
	@RequestMapping(value = "/ems/selectInterestUser.do")
	@Description("관심 사용자 관리 페이지")
	public String selectInterestUser(Locale locale, Model model) {
		return "/emass/interestUser/selectInterestUser";
	}

	/**
	 * block Page select Code JSP.
	 */
	@RequestMapping(value = "/commons/selectCodeSingle.do")
	@Description("코드 선택 페이지")
	public String selectCodeSingle(Locale locale, Model model) {

		model.addAttribute("headerYn","N");
		return "/commons/selectCodeSingle.popup";
	}

	/**
	 * report JSP.
	 */
	@RequestMapping(value = "/report/contentReport.do", method = RequestMethod.GET)
	@Description("리포트 페이지")
	public String report(Locale locale, Model model) {
		return "/emass/report/report";
	}

	/**
	 * report JSP.
	 */
	@RequestMapping(value = "/report/trafficReport.do", method = RequestMethod.GET)
	@Description("트래픽 리포트 페이지")
	public String trafficReport(Locale locale, Model model) {
		return "/emass/report/trafficReport";
	}

	/**
	 * report JSP.
	 */
	@RequestMapping(value = "/report/deviceReport.do", method = RequestMethod.GET)
	@Description("장비 운용 보고서 페이지")
	public String deviceReport(Locale locale, Model model) {
		return "/emass/report/deviceReport";
	}


	/**
	 * reservationAlarm JSP.
	 */
	@RequestMapping(value = "/ems/reservationAlarm.do", method = RequestMethod.GET)
	@Description("예약 알람 페이지")
	public String reservationAlarm(Locale locale, Model model) {
		return "/emass/reservationAlarm/reservationAlarm";
	}

	/**
	 * mailSearchPop JSP.
	 */
	@RequestMapping(value = "/ems/mailSearchPop.do", method = RequestMethod.GET)
	@Description("예약 알람 - 메일 수신자 팝업 페이지")
	public String mailSearchPop(Locale locale, Model model) {
		return "/emass/reservationAlarm/mailSearchPop.popup";
	}

	/**
	 * mailForm JSP.
	 */
	@RequestMapping(value = "/ems/mailForm.do", method = RequestMethod.GET)
	@Description("예약 알람 - 메일 서식 관리 페이지")
	public String mailForm(Locale locale, Model model) {
		model.addAttribute("headerYn","N");
		return "/emass/reservationAlarm/mailForm.popup";
	}

	/**
	 * mailFormSelectPop JSP.
	 */
	@RequestMapping(value = "/ems/mailFormSelectPop.do", method = RequestMethod.GET)
	@Description("예약 알람 - 메일 서식 선택 페이지")
	public String mailFormSelectPop(Locale locale, Model model) {
		return "/emass/reservationAlarm/mailFormSelectPop.popup";
	}

	/**
	 * detailConditionPop JSP.
	 */
	@RequestMapping(value = "/ems/detailConditionPop.do", method = RequestMethod.GET)
	@Description("예약 알람 - 조건 선택 페이지")
	public String detailConditionPop(Locale locale, Model model) {
		return "/emass/reservationAlarm/detailConditionPop.popup";
	}

	@RequestMapping(value = "/ems/keywordInfo.do", method = RequestMethod.GET)
	public String keywordInfo(Locale locale, Model model) {
		return "/emass/keyword/keywordInfo";
	}

	@RequestMapping(value = "/ems/regexPatternInfo.do", method = RequestMethod.GET)
	public String regexPatternInfo(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/regexPattern/regexPatternInfo";
	}

	@RequestMapping(value = "/ems/relationKeyword.do", method = RequestMethod.GET)
	public String searchWordInfo(Locale locale, Model model){
		model.addAttribute("headerYn","Y");
		return "/emass/relationKeyword/RelationKeyword";
	}

	@RequestMapping(value = "/ems/recommend.do", method = RequestMethod.GET)
	public String recommend(Locale locale, Model model) {
		return "/emass/message/recommend.popup";
	}

	@RequestMapping(value = "/ems/alarmLogPop.do", method = RequestMethod.GET)
	public String alarmLogPop(Locale locale, Model model) {
		return "/emass/message/alarmLogPop.popup";
	}

	@RequestMapping(value = "/uacs/filterInfo.do", method = RequestMethod.GET)
	public String filterInfo(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			model.addAttribute("headerYn","Y");
			return "/uacs/filter/filterInfo";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/uacs/selectDevStatus.do")
	public String selectDevStatus(Locale locale, Model model) {
		model.addAttribute("headerYn","N");
		return "/uacs/filter/selectDevStatus.popup";
	}

	@RequestMapping(value = "/uacs/didBlock.do", method = RequestMethod.GET)
	public String didBlock(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/uacs/blockPolicy/didBlock";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/uacs/urlIpBlock.do", method = RequestMethod.GET)
	public String urlIpBlock(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/uacs/blockPolicy/urlIpBlock";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/uacs/blockHistoryNonBusi.do", method = RequestMethod.GET)
	@Description("비업무 서비스 차단 내역")
	public String blockHistoryNonBusi(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/uacs/blockHistory/blockHistoryNonBusi";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/uacs/blockHistoryUrl.do", method = RequestMethod.GET)
	@Description("URL 차단 내역")
	public String blockHistoryUrl(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/uacs/blockHistory/blockHistoryUrl";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/uacs/blockHistoryIp.do", method = RequestMethod.GET)
	@Description("IP 차단 내역")
	public String blockHistoryIp(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/uacs/blockHistory/blockHistoryIp";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/selectCode.do")
	@Description("코드 선택 페이지")
	public String selectCode(Locale locale, Model model) {
		return "/commons/selectCode.popup";
	}
	@RequestMapping(value = "/commons/selectCodeAll.do")
	@Description("코드 선택 페이지")
	public String selectCodeAll(Locale locale, Model model) {
		return "/commons/selectCodeAll.popup"; //
	}
	@RequestMapping(value = "/commons/selectAdmin.do")
	@Description("Admin 선택 페이지")
	public String selectAdmin(Locale locale, Model model) {
		return "/commons/selectAdmin";
	}

	@RequestMapping(value = "/commons/xcnLog.do", method = RequestMethod.GET)
	@Description("CC인증 관련 시스템 로그")
	public String xcnLog(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/commons/xcnLog";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/ems/consent.do", method = RequestMethod.GET)
	@Description("동의서 관리")
	public String consent(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/consent/consent";
	}

	@RequestMapping(value = "/ems/selectConsent.do", method = RequestMethod.GET)
	@Description("동의서 선택")
	public String consentPop(Locale locale, Model model) {
		return "/emass/consent/selectConsent";
	}

	@RequestMapping(value = "/uacs/didUpload.do", method = RequestMethod.GET)
	@Description("DID 패턴 업데이트")
	public String didUpload(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/uacs/didUpload";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/scheduler.do", method = RequestMethod.GET)
	@Description("SCHEDULER")
	public String scheduler(Locale locale, Model model) {
		if (Common.isEquals(Common.getAdminType(httpSession), "S")) {
			return "/commons/scheduler";
		} else {
			return "/emass/dashboard";
		}
	}

	@RequestMapping(value = "/commons/downList.do", method = RequestMethod.GET)
	@Description("DOWNLOADLIST")
	public String downlist(Locale locale, Model model) {
		return "/commons/downInfo.popup";
	}

	@RequestMapping(value = "/commons/queryMake.do", method = RequestMethod.GET)
	@Description("MAKE QUERY")
	public String queryMake(Locale locale, Model model) {
		return "/commons/queryMake.popup";
	}

	@RequestMapping(value = "/ems/messageNew.do")
	@Description("EDC 메시지 검색 페이지(전체) - 신규")
	public String messageNew(Locale locale, Model model) {
		return "/emass/message/messageNew";
	}

	@RequestMapping(value = "/ems/messageNewN.do")
	@Description("EDC 메시지 검색 페이지(전체) - 신규")
	public String messageNewN(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/emass/message/messageNewN";
	}

	@RequestMapping(value = "/ems/imgFullsize.do")
	@Description("첨부 이미지 전체크기 보기")
	public String imgFullsize(Locale locale, Model model) {
		return "/emass/message/imageFullSize.popup";
	}






	@RequestMapping(value = "/ems/attachCntStat.do")
	@Description("전체 첨부파일 건수")
	public String attachCntStat(Locale locale, Model model) {
		return "/emass/aihr/attachCntStat";
	}

	@RequestMapping(value = "/ems/attachOutCntStat.do")
	@Description("외부 전송 확장자 첨부 건수")
	public String attachOutCntStat(Locale locale, Model model) {
		return "/emass/aihr/attachOutCntStat";
	}

	@RequestMapping(value = "/ems/attachOutCntNonworkStat.do")
	@Description("외부 전송 확장자 첨부 건수(비업무 시간)")
	public String attachOutCntNonworkStat(Locale locale, Model model) {
		return "/emass/aihr/attachOutCntNonworkStat";
	}

	@RequestMapping(value = "/ems/attachOutCntUserStat.do")
	@Description("외부 전송 사용자 Top10")
	public String attachOutCntUserStat(Locale locale, Model model) {
		return "/emass/aihr/attachOutCntUserStat";
	}

	@RequestMapping(value = "/ems/attachOutCntDeptStat.do")
	@Description("외부 전송 부서 Top10")
	public String attachOutCntDeptStat(Locale locale, Model model) {
		return "/emass/aihr/attachOutCntDeptStat";
	}

	@RequestMapping(value = "/ems/attachOutCntUserNonworkStat.do")
	@Description("외부 전송 사용자 Top10(비업무 시간)")
	public String attachOutCntUserNonworkStat(Locale locale, Model model) {
		return "/emass/aihr/attachOutCntUserNonworkStat";
	}

	@RequestMapping(value = "/ems/attachOutCntDeptNonworkStat.do")
	@Description("외부 전송 부서 Top10(비업무 시간)")
	public String attachOutCntDeptNonworkStat(Locale locale, Model model) {
		return "/emass/aihr/attachOutCntDeptNonworkStat";
	}






	@RequestMapping(value = "/ems/attachInCntStat.do")
	@Description("내부 전송 확장자 첨부 건수")
	public String attachInCntStat(Locale locale, Model model) {
		return "/emass/aihr/attachInCntStat";
	}

	@RequestMapping(value = "/ems/attachInCntNonworkStat.do")
	@Description("내부 전송 확장자 첨부 건수(비업무 시간)")
	public String attachInCntNonworkStat(Locale locale, Model model) {
		return "/emass/aihr/attachInCntNonworkStat";
	}

	@RequestMapping(value = "/ems/attachInCntUserStat.do")
	@Description("내부 전송 사용자 Top10")
	public String attachInCntUserStat(Locale locale, Model model) {
		return "/emass/aihr/attachInCntUserStat";
	}

	@RequestMapping(value = "/ems/attachInCntDeptStat.do")
	@Description("내부 전송 부서 Top10")
	public String attachInCntDeptStat(Locale locale, Model model) {
		return "/emass/aihr/attachInCntDeptStat";
	}

	@RequestMapping(value = "/ems/attachInCntUserNonworkStat.do")
	@Description("내부 전송 사용자 Top10(비업무 시간)")
	public String attachInCntUserNonworkStat(Locale locale, Model model) {
		return "/emass/aihr/attachInCntUserNonworkStat";
		
	}

	@RequestMapping(value = "/ems/attachInCntDeptNonworkStat.do")
	@Description("내부 전송 부서 Top10(비업무 시간)")
	public String attachInCntDeptNonworkStat(Locale locale, Model model) {
		return "/emass/aihr/attachInCntDeptNonworkStat";
	}

}