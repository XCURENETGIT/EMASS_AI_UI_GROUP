package com.xcurenet.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.MDC;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.common.listener.ServerListener;
import com.xcurenet.common.parser.useragent.Client;
import com.xcurenet.common.parser.useragent.Parser;
import com.xcurenet.common.util.Common;

@WebFilter(urlPatterns = "/*")
public class SessionFilter implements Filter {

	@Override
	public void init(FilterConfig filterconfig) throws ServletException {
		// TODO Auto-generated method stub

	}

	@Override
	public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterchain) throws IOException, ServletException {

		setMDC(servletRequest);
		filterchain.doFilter(servletRequest, servletResponse);
		clearMDC();
	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
	}

	private void clearMDC() {
		try {
			MDC.clear();
		} catch (Exception e) {
			// TODO: handle exception
		}
	}

	private void setMDC(final ServletRequest servletRequest) {
		try {
			HttpServletRequest request = (HttpServletRequest) servletRequest;
			Parser uaParser = new Parser();
			Client c = uaParser.parse(request.getHeader("User-Agent"));
			String agent = String.format("%s %s", c.userAgent.family, c.userAgent.major);

			MDC.put("adminIp", request.getRemoteAddr() + " " + agent);

			HttpSession session = request.getSession(false);
			if (session != null) {
				AdminVO prsAdminVO = (AdminVO) session.getAttribute(Common.SESSION_CREDENTIAL);
				if (prsAdminVO != null) {
					MDC.put("adminId", prsAdminVO.getAdminId());

					String url = request.getRequestURI();
					AuditRequestVO auditVo = ServerListener.getAuditRequest(url);
					if (auditVo != null) {
						MDC.put("x_menuId", auditVo.getMenuId());
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
