package com.xcurenet.interceptor;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.common.listener.ServerListener;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;

@Slf4j
@Component
public class LoggerInterceptor implements HandlerInterceptor {

	private final static String LOG_PRIFIX = "Log";

	@Override
	public boolean preHandle(final HttpServletRequest request, final HttpServletResponse response, Object handler) throws Exception {

		request.setCharacterEncoding(Common.UTF8);
		String url = request.getRequestURI();

		if (url.endsWith(".css") || url.endsWith(".js") || url.endsWith(".png") || url.endsWith(".svg")) {
			return false;
		}

		if (url.indexOf("csvWriter.vns") > -1 || url.indexOf("excelWriter.vns") > -1) {
			log.info("{} {}", request.getRequestURI());
		} else {
			JSONObject param = Common.getParam(request);

			param.remove("body"); // 로그 출력 시 방대한 로그는 제외.
			param.remove("_ses_user_id");
			param.remove("_ses_user_name");
			param.remove("_ses_user_ip");
			param.remove("_ses_user_type");
			log.info("{} {} {}", request.getMethod(), request.getRequestURI(), param);
		}

		if (log.isDebugEnabled()) {
			StringBuffer _sb = new StringBuffer();
			Enumeration<?> headerNames = request.getHeaderNames();
			while (headerNames.hasMoreElements()) {
				String name = (String) headerNames.nextElement();
				String value = request.getHeader(name);
				_sb.append(name).append(" : ").append(value).append("\t");
			}
			log.info("HEADER {}", _sb.toString());
		}

		if (!(url.endsWith(".css") || url.endsWith(".js") || url.endsWith(".png") || url.endsWith(".svg"))) {
			try {
				AuditRequestVO auditVo = ServerListener.getAuditRequest(url.replaceFirst(request.getContextPath(), ""));
				if (auditVo != null) {
					String first = auditVo.getClassName().substring(0, 1);
					String remain = auditVo.getClassName().substring(1);
					String className = first.toLowerCase() + remain + LOG_PRIFIX;
					boolean contains = SpringContextUtil.containsBean(className);
					if (contains) {
						Object audit = SpringContextUtil.getBean(className);
						audit.getClass().getMethod(auditVo.getMethod(), new Class[] { HttpServletRequest.class, AuditRequestVO.class }).invoke(audit, new Object[] { request, auditVo });
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return true;
	}

	@Override
	public void postHandle(final HttpServletRequest request, final HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
	}
}
