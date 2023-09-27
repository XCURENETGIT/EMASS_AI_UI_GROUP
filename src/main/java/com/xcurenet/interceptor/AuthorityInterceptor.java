package com.xcurenet.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class AuthorityInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		try {
			if (request.getSession().getAttribute(Common.SESSION_CREDENTIAL) == null) {
				if (request.getRequestURI().indexOf("sessionVerification.xcn") > -1) {
					log.info("AUTO LOGOUT : {} {}", request.getRemoteAddr(), Common.getParam(request));
				}
				log.info("SC_UNAUTHORIZED : {} {} {}", request.getRemoteAddr(), request.getRequestURI(), Common.getParam(request));

				if (isAjax(request)) {
					response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				} else {
					if (request.getRequestURI().indexOf("attach.do") > -1) {
						response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
					} else {
						String ssoType = Config.getString("sso_type");
						if (Common.isEquals(ssoType, "S")) response.sendRedirect(request.getContextPath() + "/loginSSO.do");
						else {
							response.sendRedirect(request.getContextPath() + "/login.do");
						}
					}
				}
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// admin 세션key 존재시 main 페이지 이동
		return true;
	}

	private boolean isAjax(HttpServletRequest request) {
		boolean result = false;
		String[] header = Common.toArray(request.getHeader(Common.HEADER_CHECK), ",");
		if (header == null) return result;
		for (int i = 0; i < header.length; i++) {
			if (Common.isEquals(header[i].trim(), Common.HEADER_AJAX)) {
				result = true;
				break;
			}
		}
		return result;
	}

}
