package com.xcurenet.menu.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.customDashboard.service.CustomDashBoardService;
import com.xcurenet.emass.customDashboard.service.CustomDashboardMenuVO;
import com.xcurenet.menu.service.MenuService;
import com.xcurenet.menu.service.MenuVO;

import net.sf.json.JSONObject;

@Service("menuService")
public class MenuServiceImpl extends XcnAbstractDAO implements MenuService {

	@Resource(name = "customDashBoardService")
	private CustomDashBoardService customDashBoardService;
	
	@Override
	public List<MenuVO> getMenuList(HttpServletRequest request) {
		JSONObject param = Common.getParam(request);
		String adminId = Common.nvl(param.get("_ses_user_id"));
		String adminAuth = Common.nvl(param.get("_ses_user_type"));
		if(Common.isEquals(adminAuth, "C"))adminAuth = "M";
		
		HttpSession session = request.getSession(false);
		return getMenuList(adminId, adminAuth, session);
	}

	@Override
	public List<MenuVO> getMenuList(String adminId, String adminAuth, HttpSession session) {
		Map<String, String> param = new HashMap<>();
		param.put("adminId", adminId);
		param.put("adminAuth", adminAuth);
		List<MenuVO> menus = selectList("com.xcurenet.sqlmap.mappers.mysql.menu.getMenuList", param);
		setMenuLink(menus, session);
		setCustomMenu(menus, session);
		return menus;
	}
	
	private void setCustomMenu(List<MenuVO> menus, HttpSession session) {
		CustomDashboardMenuVO customDashboardMenuVo = new CustomDashboardMenuVO();
		customDashboardMenuVo.setAdminId(Common.getAdminId(session));
		customDashboardMenuVo.setUseYn("Y");
		int mainIdx = -1;
		for(int i=0; i<menus.size(); i++) {
			List<CustomDashboardMenuVO> customList = customDashBoardService.getDashBoardMenuList(customDashboardMenuVo);
			MenuVO menu = menus.get(i);
			if (Common.isEquals(menu.getMenuId(), "DATA_MONITOR")) {
				mainIdx = i;
			}
			
			if (Common.isEquals(menu.getMenuId(), "DASHBOARD")) {
				for(int j=0; j<customList.size(); j++) {
					CustomDashboardMenuVO vo = customList.get(j);
					
					MenuVO customMenu = new MenuVO();
					customMenu.setDefaultName(vo.getMenuName());
					customMenu.setMenuId("DASHBOARD_CUSTOM");
					customMenu.setPId(menu.getMenuId());
					customMenu.setTId(menu.getTId());
					customMenu.setMenuLink("ems/dashboard.do?menuKey="+vo.getMenuKey());
					customMenu.setPkgType("L");
					customMenu.setMenuAuth("S");
					customMenu.setMenuIcon(vo.getMenuIcon());
					customMenu.setMenuUseyn(vo.getUseYn());
					customMenu.setLv1_odr(menu.getLv1_odr());
					customMenu.setLv2_odr(menu.getLv2_odr());
					customMenu.setLv3_odr(Common.nvl(j+1));
					
					menus.add(i+j+1, customMenu);
					
					if( Common.isEquals(vo.getDefaultMenu(), "Y")){
						menu.setMenuLink("ems/dashboard.do?menuKey="+vo.getMenuKey());
						menus.set(i, menu);
						
						if(mainIdx != -1) {
							MenuVO mainMenu = menus.get(mainIdx);
							mainMenu.setMenuLink("ems/dashboard.do?menuKey="+vo.getMenuKey());
							menus.set(mainIdx, mainMenu);
						}
					}
				}
				break;
			}
		}
	}
	
	private String getMenuName(MenuVO menu, HttpSession session) {
		String result = menu.getDefaultName();
		try {
			if(Common.isEmpty(menu.getPId())) {
				result = Prop.propFormat(menu.getMenuId(), Common.getLocale(session));
			} else {
				result = Prop.propFormat(menu.getTId() + "." + menu.getMenuId(), Common.getLocale(session));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	private void setMenuLink(List<MenuVO> menus, HttpSession session) {
		for (int i = 0; i < menus.size(); i++) {
			MenuVO menu = menus.get(i);
			String menuName = getMenuName(menu, session);
			menu.setDefaultName(menuName);
			if (Common.isEmpty(menu.getMenuLink())) {
				for (int j = i; j < menus.size(); j++) {
					MenuVO sMenu = menus.get(j);
					if (Common.isNotEmpty(sMenu.getMenuLink())) {
						menu.setMenuLink(sMenu.getMenuLink());
						break;
					}
				}
			}
			menus.set(i, menu);
		}
	}

}
