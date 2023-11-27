package com.xcurenet.common.listener;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.common.util.Common;
import lombok.Getter;
import lombok.extern.log4j.Log4j2;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.BeanFactoryUtils;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Description;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Service;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

@Log4j2
@Service
public class ServerListener implements ApplicationListener<ContextRefreshedEvent> {

	@Getter
	private static List<AuditRequestVO> requestMappings;

	@Override
	public void onApplicationEvent(ContextRefreshedEvent ev) {
		//if (ev.getApplicationContext().getParent() == null) return;

		requestMappings = new ArrayList<>();
		Map<String, RequestMappingHandlerMapping> allRequestMappings = BeanFactoryUtils.beansOfTypeIncludingAncestors(ev.getApplicationContext(), RequestMappingHandlerMapping.class, true, false);
		for (RequestMappingHandlerMapping handlerMapping : allRequestMappings.values()) {
			if (handlerMapping != null) {
				Map<RequestMappingInfo, HandlerMethod> map = handlerMapping.getHandlerMethods();
				for (Entry<RequestMappingInfo, HandlerMethod> elem : map.entrySet()) {
					RequestMappingInfo key = elem.getKey();
					HandlerMethod method = elem.getValue();
					// if (Common.isNotEquals(method.getMethod().getReturnType().getSimpleName(),"XcnResponseVO")) continue;
					if (key.getPathPatternsCondition() == null) continue;

					AuditParentMenu pMenu = method.getMethod().getDeclaringClass().getAnnotation(AuditParentMenu.class);
					AuditMenu menu = method.getMethod().getDeclaringClass().getAnnotation(AuditMenu.class);
					AuditOperation operation = method.getMethodAnnotation(AuditOperation.class);
					Description desc = method.getMethodAnnotation(Description.class);
					if (menu == null || pMenu == null) continue;
					String className = method.getMethod().getDeclaringClass().getSimpleName();
					AuditRequestVO vo = new AuditRequestVO();
					vo.setPath(Common.nvl(key.getPathPatternsCondition().getPatterns().toArray()[0]));
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


}
