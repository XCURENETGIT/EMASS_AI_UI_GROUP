package com.xcurenet.interceptor;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.common.listener.ServerListener;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Enumeration;

@Log4j2
@Component
public class LoggerInterceptor extends HandlerInterceptorAdapter {

	private final static String LOG_PRIFIX = "Log";

	@Override
	public boolean preHandle(final HttpServletRequest request, final HttpServletResponse response, Object handler) throws Exception {

		request.setCharacterEncoding(Common.UTF8);
		String url = request.getRequestURI();
		if (url.contains("csvWriter.do") || url.contains("excelWriter.do")) {
			log.info("{}", request.getRequestURI());
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
			StringBuilder _sb = new StringBuilder();
			Enumeration<?> headerNames = request.getHeaderNames();
			while (headerNames.hasMoreElements()) {
				String name = (String) headerNames.nextElement();
				String value = request.getHeader(name);
				_sb.append(name).append(" : ").append(value).append("\t");
			}
			log.info("HEADER {}", _sb.toString());
		}

		if (url.contains(".xcn")) {
			try {
				AuditRequestVO auditVo = ServerListener.getAuditRequest(url);
				if (auditVo != null && auditVo.getOperation() != null) {
					boolean contains = SpringContextUtil.containsBean(auditVo.getClassName() + LOG_PRIFIX);
					if (contains) {
						Object audit = SpringContextUtil.getBean(auditVo.getClassName() + LOG_PRIFIX);
						audit.getClass().getMethod(auditVo.getMethod(), new Class[]{HttpServletRequest.class, AuditRequestVO.class}).invoke(audit, new Object[]{request, auditVo});
					}
				}
			} catch (Exception e) {
				log.error("", e);
			}
		}
		return super.preHandle(request, response, handler);
	}

	@Override
	public void postHandle(final HttpServletRequest request, final HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
	}
}
