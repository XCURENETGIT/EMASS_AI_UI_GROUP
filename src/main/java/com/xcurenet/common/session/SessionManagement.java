package com.xcurenet.common.session;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.concurrent.ConcurrentTaskScheduler;
import org.springframework.stereotype.Controller;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.AuditVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class SessionManagement {

	private static List<HttpSession> sessions = new ArrayList<>();
	private static String contextPath;

	@Autowired
	private SimpMessagingTemplate template;

	@Resource(name = "auditService")
	public AuditService auditService;

	private TaskScheduler scheduler = new ConcurrentTaskScheduler();

	public void createSession(HttpServletRequest request, AdminVO adminVo) {
		HttpSession session = request.getSession(true);
		adminVo.setAliveTime(System.currentTimeMillis());
		session.setAttribute(Common.SESSION_CREDENTIAL, adminVo);
		session.setAttribute("sessionTimeoutSecond", Config.getInt("session.timeoutSecond"));
		session.setAttribute("sessionLastLoginDt", Common.nvl(Common.getTime()));
		
		session.setMaxInactiveInterval(Config.getInt("session.timeoutSecond") + 600);

		if (!isExistSession(session)) {
			sessions.add(session);
		}

		contextPath = request.getContextPath();
	}

	public void removeSession(HttpSession session) {
		if (session != null) {
			session.removeAttribute(Common.SESSION_CREDENTIAL);
			session.invalidate();
		}
	}

	public boolean isExistSession(final HttpSession ss) {
		for (HttpSession session : sessions) {
			if (session.getId().equals(ss.getId())) return true;
		}
		return false;
	}

	public boolean isExistId(final String adminId) {
		for (HttpSession session : sessions) {
			AdminVO admin = null; 
			try{
				admin = (AdminVO) session.getAttribute(Common.SESSION_CREDENTIAL);
			}catch(IllegalStateException e){
				
			}
			if (admin == null) continue;
			if (Common.isEquals(admin.getAdminId(), adminId)) return true;
		}
		return false;
	}

	public boolean setAliveTime(final String sessionId) {
		for (HttpSession session : sessions) {
			AdminVO admin = (AdminVO) session.getAttribute(Common.SESSION_CREDENTIAL);
			if (admin == null) continue;
			if (Common.isEquals(session.getId(), sessionId)) {
				admin.setAliveTime(System.currentTimeMillis());
			}
		}
		return false;
	}

	@Description("특정 아이디 강제 로그아웃")
	public void logoutAdminId(final HttpServletRequest request, final String adminId, final String loginIp) {
		for (int i = sessions.size() - 1; i >= 0; i--) {
			HttpSession session = sessions.get(i);
			AdminVO admin = (AdminVO) session.getAttribute(Common.SESSION_CREDENTIAL);
			if (admin == null) continue;
			if (Common.isEquals(admin.getAdminId(), adminId)) {
				log.info("Admin Logout {}", admin.getAdminName());
				String sessionId = session.getId();

				AuditVO audit = new AuditVO();
				audit.setAdminIp(admin.getLoginIp());
				audit.setPMenuId("SYSTEM");
				audit.setMenuId("CONNECTION");
				audit.setOperation("LOGOUT");
				audit.setAdminId(admin.getAdminId());
				audit.setAdminName(admin.getAdminName());
				audit.setInformation(Prop.propFormat("java.message.diff_session.login", loginIp));
				auditService.insertAudit(audit);
				template.convertAndSendToUser(sessionId, "/logout", "ui.alertMsg('" + Prop.propFormat("java.message.diff_session.login", request, loginIp) + "', function(){location.replace('" + contextPath + "/logout.do')}, 3000); ");

				removeSession(session);
				sessions.remove(i);
			}
		}
	}

	@PostConstruct
	@Description("일정 시간동안 사용하지 않는 경우 로그아웃 처리")
	private void broadcastTimePeriodically() {
		scheduler.scheduleWithFixedDelay(new Runnable() {
			@Override
			public void run() {
				int timeOut = Config.getInt("session.timeoutSecond") * 1000;
				for (int i = sessions.size() - 1; i >= 0; i--) {
					HttpSession session = sessions.get(i);
					AdminVO admin = null;
					try {
						admin = (AdminVO) session.getAttribute(Common.SESSION_CREDENTIAL);
						if (admin == null) {
							String sessionId = session.getId();
							sessions.remove(i);
							template.convertAndSendToUser(sessionId, "/logout", "location.replace('" + contextPath + "/logout.do') ");
						} else {
							long term = System.currentTimeMillis() - session.getLastAccessedTime();
							if (term < timeOut) continue;
							log.info("Admin Logout {}", admin.getAdminName());
							String sessionId = session.getId();

							AuditVO audit = new AuditVO();
							audit.setAdminIp(admin.getLoginIp());
							audit.setPMenuId("SYSTEM");
							audit.setMenuId("CONNECTION");
							audit.setOperation("LOGOUT");
							audit.setAdminId(admin.getAdminId());
							audit.setAdminName(admin.getAdminName());
							audit.setInformation(Prop.propFormat("java.message.longtime.logout"));
							auditService.insertAudit(audit);
							template.convertAndSendToUser(sessionId, "/logout", "ui.alertMsg('" + Prop.propFormat("java.message.longtime.logout", session) + "', function(){location.replace('" + contextPath + "/logout.do')}, 3000); ");

							removeSession(session);
							sessions.remove(i);
						}
					} catch (Exception e) {
						//e.printStackTrace();
						sessions.remove(i);
					}
				}
			}
		}, 3000);
	}

//	@PostConstruct
//	@Description("브라우저 강제 종료 및 다른 도메인으로 이동 시 로그아웃 처리")
//	private void browserAliveCheck() {
//		scheduler.scheduleWithFixedDelay(new Runnable() {
//			@Override
//			public void run() {
//				for (int i = sessions.size() - 1; i >= 0; i--) {
//					HttpSession session = sessions.get(i);
//					AdminVO admin = null;
//					try {
//						admin = (AdminVO) session.getAttribute(Common.SESSION_CREDENTIAL);
//						if (admin == null) continue;
//						long term = (System.currentTimeMillis() - admin.getAliveTime()) / 1000;
//						if (term >= 30) {
//							log.info("Admin Logout {}", admin.getAdminName());
//							removeSession(session);
//							sessions.remove(i);
//						}
//					} catch (Exception e) {
//						sessions.remove(i);
//					}
//				}
//			}
//		}, 5000);
//	}

	@MessageMapping("/browserAlive")
	public void browserAlive(final String sessionId) {
		setAliveTime(sessionId);
	}
}
