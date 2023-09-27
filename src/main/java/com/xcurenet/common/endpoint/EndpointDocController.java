package com.xcurenet.common.endpoint;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.common.util.Common;

@Controller
public class EndpointDocController {
	@Autowired
	private RequestMappingHandlerMapping requestMappingHandlerMapping;

	@RequestMapping(value = "/endPoints")
	public String getEndPointsInView(Model model) {
		List<Map<String, String>> pages = new ArrayList<Map<String, String>>();
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		Map<RequestMappingInfo, HandlerMethod> map = requestMappingHandlerMapping.getHandlerMethods();
		for (Entry<RequestMappingInfo, HandlerMethod> elem : map.entrySet()) {
			RequestMappingInfo key = elem.getKey();
			HandlerMethod method = elem.getValue();

			Map<String, String> item = new HashMap<String, String>();
			item.put("path", Common.nvl(key.getPatternsCondition().getPatterns().toArray()[0]));
			item.put("cls", method.getMethod().getDeclaringClass().getSimpleName());
			item.put("method", method.getMethod().getName());

			AuditMenu auditMenu = method.getMethod().getDeclaringClass().getAnnotation(AuditMenu.class);
			if (auditMenu != null) {
				item.put("menuId", auditMenu.value().getMenuId());
			}

			AuditOperation operation = method.getMethodAnnotation(AuditOperation.class);
			if (operation != null) {
				item.put("operation", operation.value().getOperation());
			}

			Description desc = method.getMethodAnnotation(Description.class);
			if (desc != null) {
				item.put("desc", desc.value());
			}


			StringBuffer sb = new StringBuffer();
			for (MethodParameter param : method.getMethodParameters()) {
				sb.append(param.getParameterType().getSimpleName()).append(", ");
			}
			if (sb.toString().length() > 0) {
				item.put("param", sb.toString().substring(0, sb.toString().length() - 2));
			} else {
				item.put("param", "");
			}
			item.put("rtn", Common.nvl(method.getMethod().getReturnType().getSimpleName()));
			if (Common.isEquals(item.get("rtn"), "XcnResponseVO")) {
				result.add(item);
			} else {
				pages.add(item);
			}
		}
		model.addAttribute("endPoints", result);
		model.addAttribute("pages", pages);
		return "/endPoints";
	}
}