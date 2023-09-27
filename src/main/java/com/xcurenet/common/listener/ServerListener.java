package com.xcurenet.common.listener;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.BeanFactoryUtils;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Description;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Service;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.common.util.Common;

@Service
public class ServerListener implements ApplicationListener<ApplicationEvent> {

	private static List<AuditRequestVO> requestMappings;

	@Override
	public void onApplicationEvent(ApplicationEvent event) {
		if (event instanceof ContextRefreshedEvent) {
			ContextRefreshedEvent ev = (ContextRefreshedEvent) event;
			if (ev.getApplicationContext().getParent() == null) return;

			requestMappings = new ArrayList<>();
			Map<String, RequestMappingHandlerMapping> allRequestMappings = BeanFactoryUtils.beansOfTypeIncludingAncestors(ev.getApplicationContext(), RequestMappingHandlerMapping.class, true, false);
			for (RequestMappingHandlerMapping handlerMapping : allRequestMappings.values()) {
				if (handlerMapping instanceof RequestMappingHandlerMapping) {
					Map<RequestMappingInfo, HandlerMethod> map = handlerMapping.getHandlerMethods();
					for (Entry<RequestMappingInfo, HandlerMethod> elem : map.entrySet()) {
						RequestMappingInfo key = elem.getKey();
						HandlerMethod method = elem.getValue();
						// if (Common.isNotEquals(method.getMethod().getReturnType().getSimpleName(),
						// "XcnResponseVO")) continue;

						AuditParentMenu pMenu = method.getMethod().getDeclaringClass().getAnnotation(AuditParentMenu.class);
						AuditMenu menu = method.getMethod().getDeclaringClass().getAnnotation(AuditMenu.class);
						AuditOperation operation = method.getMethodAnnotation(AuditOperation.class);
						Description desc = method.getMethodAnnotation(Description.class);
						if (menu == null || pMenu == null) continue;
						String className = method.getMethod().getDeclaringClass().getSimpleName();
						AuditRequestVO vo = new AuditRequestVO();
						vo.setPath(Common.nvl(key.getPatternsCondition().getPatterns().toArray()[0]));
						vo.setClassName(className.substring(0, 1).toLowerCase() + className.substring(1));
						vo.setMethod(method.getMethod().getName());
						vo.setMenuId(menu.value().getMenuId());
						vo.setPMenuId(pMenu.value().getParentMenuId());
						if (operation != null) vo.setOperation(operation.value().getOperation());
						if (desc != null) vo.setDesc(desc.value());
						requestMappings.add(vo);
					}
				}
			}

		}
	}

	public static AuditRequestVO getAuditRequest(String url) {
		if (requestMappings == null) return null;
		for (AuditRequestVO vo : requestMappings) {
			if (url.contains(vo.getPath())) {
				return vo;
			}
		}
		return null;
	}

	public static Boolean containsUrl(String url) {
		if (requestMappings == null) return null;
		for (AuditRequestVO vo : requestMappings) {
			if (url.contains(vo.getPath())) {
				return true;
			}
		}
		return false;
	}

	public static List<AuditRequestVO> getRequestMappings() {
		return requestMappings;
	}

}
