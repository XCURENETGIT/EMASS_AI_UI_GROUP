package com.xcurenet.interestUser.web;

import java.io.File;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.excel.XLSXReader;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.interestUser.service.AdminUserGroupImportVO;
import com.xcurenet.interestUser.service.AdminUserGroupService;
import com.xcurenet.interestUser.service.AdminUserGroupVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Handles requests for the application home page.
 */
@Slf4j
@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.INTEREST_USER)
public class AdminUserGroupController {

	@Resource(name = "adminUserGroupService")
	public AdminUserGroupService adminUserGroupService;

	@RequestMapping(value = "/getAdminUserGroupList.xcn")
	@Description("관심 사용자 그룹 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getAdminUserGroupList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String adminId = Common.getAdminId(request);
		return new XcnResponseVO(XcnRspCode.OK, adminUserGroupService.getAdminUserGroupList(searchStr, adminId));
	}

	@RequestMapping(value = "/insertAdminUserGroup.xcn")
	@Description("관심 사용자 그룹 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertAdminUserGroup(final HttpServletRequest request, AdminUserGroupVO userGroup) throws Exception {
		userGroup.setAdminId(Common.getAdminId(request));
		if (adminUserGroupService.isAdminUserGroupExist(userGroup)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert", request, userGroup.getGroupName()));
		} else {
			int rs = adminUserGroupService.insertAdminUserGroup(userGroup);
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/updateAdminUserGroup.xcn")
	@Description("관심 사용자 그룹 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateAdminUserGroup(AdminUserGroupVO userGroup) throws Exception {
		int rs = adminUserGroupService.updateAdminUserGroup(userGroup);
		return new XcnResponseVO(XcnRspCode.OK, rs);
	}

	@RequestMapping(value = "/deleteAdminUserGroup.xcn")
	@Description("관심 사용자 그룹 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteAdminUserGroup(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, adminUserGroupService.deleteAdminUserGroup(request));
	}

	@RequestMapping(value = "/getAdminUserGroupItemList.xcn")
	@Description("관심 사용자 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getAdminUserGroupItemList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String groupSeq = Common.nvl(request.getParameter("groupSeq"));
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		return new XcnResponseVO(XcnRspCode.OK, adminUserGroupService.getAdminUserGroupItemList(groupSeq, searchStr));
	}
	
	@RequestMapping(value = "/insertAdminTextUploadItem.xcn")
	@Description("관심 사용자 text upload 저장")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertAdminTextUploadItem(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, adminUserGroupService.insertAdminUserGroupItem(request));
	}

	@RequestMapping(value = "/insertAdminUserGroupItem.xcn")
	@Description("관심 사용자 저장")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertAdminUserGroupItem(final HttpServletRequest request, final HttpSession session) throws Exception {
		String duplicatedStr = adminUserGroupService.isAdminUserGroupItemExist(request);
		if (Common.isEmpty(duplicatedStr)) {
			return new XcnResponseVO(XcnRspCode.OK, adminUserGroupService.insertAdminUserGroupItem(request));
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("errors.duplicated", Common.getLocale(session), duplicatedStr));
		}
	}

	@RequestMapping(value = "/deleteAdminUserGroupItem.xcn")
	@Description("관심 사용자 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteAdminUserGroupItem(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, adminUserGroupService.deleteAdminUserGroupItem(request));
	}

	@Description("관심 사용자 업로드")
	@RequestMapping(value = "/importAdminGroupUser.xcn", method = RequestMethod.POST)
	public void importAdminGroupUser(AdminUserGroupImportVO vo, HttpServletResponse response, HttpServletRequest request) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Content-Type", "application/json");
		String adminId = Common.getAdminId(request);

		JSONObject item = new JSONObject();

		PrintWriter pw = response.getWriter();
		MultipartFile file = vo.getAttach();
		if (file == null || file.isEmpty()) {
			item.put("success", false);
			item.put("message", Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("keyword.upload.nocontent"));
			pw.print(item);
			IOUtils.closeQuietly(pw);
			return;
		}

		String tmp = Config.KEYWORD_TMP;
		Common.mkdirs(tmp);
		File dest = new File(tmp + file.getOriginalFilename());
		if (dest.exists()) {
			dest.delete();
		}

		InputStream is = null;
		try {
			file.transferTo(dest);

			String fileName = dest.getName();
			String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length()).toLowerCase();

			List<String> list = new ArrayList<>();
			if (Common.isOrEquals(fileExt, "csv", "txt", "text")) {
				list = FileUtils.readLines(dest, vo.getEncoding());
			}
			if (Common.isOrEquals(fileExt, "xlsx")) {
				XLSXReader xlsxReader = new XLSXReader(dest.getAbsolutePath());
				JSONArray jsonList = xlsxReader.getList();
				for (int i = 0; i < jsonList.size(); i++) {
					JSONObject obj = jsonList.getJSONObject(i);
					list.add(Common.nvl(obj.get("COL0")));
				}
			}
			log.info("upload size : {}", list.size());
			item = adminUserGroupService.importAdminGroupUser(adminId, vo.getImportGroupSeq(), list);
		} catch (Exception e) {
			e.printStackTrace();
			item.put("success", false);
			item.put("message", Prop.propFormat("keyword.upload.error"));
		} finally {
			if (dest.exists()) {
				dest.delete();
			}
			pw.print(item);
			pw.flush();
			IOUtils.closeQuietly(is);
			IOUtils.closeQuietly(pw);
		}
	}
	
	@RequestMapping(value = "/getConAdminUserGroupList.xcn")
	@Description("관심 사용자 그룹 리스트 조회 - 조건 설정 용")
	@ResponseBody
	public XcnResponseVO getConAdminUserGroupList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String itemList = Common.nvl(request.getParameter("itemList"));
		String adminId = Common.getAdminId(request);
		return new XcnResponseVO(XcnRspCode.OK, adminUserGroupService.getConAdminUserGroupList(itemList, adminId));
	}
	
}
