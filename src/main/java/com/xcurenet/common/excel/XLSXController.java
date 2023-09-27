package com.xcurenet.common.excel;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.common.rename.FileRenamePolicy;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

import net.sf.json.JSONArray;

@Controller
public class XLSXController {

	@Autowired
	private AuditService auditService;

	private static final String ENTER = "┌";
	
	@RequestMapping(value = "/utils/xlsxWriter.do")
	@Description("XLSX Writer 호출")
	@ResponseBody
	public XcnResponseVO xlsxWriter(final HttpServletRequest request, final HttpSession session) {
		String title = Common.nvl(request.getParameter("title"));
		String header = Common.nvl(request.getParameter("header"));
		String body = Common.nvl(request.getParameter("body"));
		String pMenuId = Common.nvl(request.getParameter("pMenuId"));
		String menuId = Common.nvl(request.getParameter("menuId"));
		JSONArray headerArray = Common.toJSONArray(header);
		JSONArray bodyArray = Common.toJSONArray(body);

		try {
			String dt = Common.getCurrentDate();
			Common.mkdirs(Common.TMP_PATH + dt);
			File file = new FileRenamePolicy().rename(new File(Common.TMP_PATH + dt + "/export_excel_" + Common.getCurrentTime("yyyyMMdd_HHmmss") + ".xlsx"));
			XLSXWriter xlsx = new XLSXWriter(title, headerArray, bodyArray, new FileOutputStream(file));
			xlsx.execute();

			if (Common.isNotEmpty(menuId)) {
				AuditRequestVO auditVo = new AuditRequestVO();
				auditVo.setPMenuId(pMenuId);
				auditVo.setMenuId(menuId);
				auditVo.setOperation(Operation.DOWNLOAD.getOperation());
				auditVo.setInformation(Prop.propFormat("java.download.excel"));
				
				StringBuffer info = new StringBuffer();
				info.append("["+Prop.propFormat("common.msg.export")+"]").append(ENTER);
				info.append(Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.excel")+" xlsx)");

				auditVo.setInformation(info.toString());
				auditService.insertAudit(request, auditVo);
			}
			return new XcnResponseVO(XcnRspCode.OK, file.getAbsolutePath());
		} catch (Exception e) {
			e.printStackTrace();
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.create.excel", request));
		}
	}


	@RequestMapping(value = "/utils/cellWriter.do")
	@Description("CELL Writer 호출")
	@ResponseBody
	public XcnResponseVO cellWriter(final HttpServletRequest request, final HttpSession session) {
		String title = Common.nvl(request.getParameter("title"));
		String header = Common.nvl(request.getParameter("header"));
		String body = Common.nvl(request.getParameter("body"));
		String pMenuId = Common.nvl(request.getParameter("pMenuId"));
		String menuId = Common.nvl(request.getParameter("menuId"));
		JSONArray headerArray = Common.toJSONArray(header);
		JSONArray bodyArray = Common.toJSONArray(body);

		try {
			String dt = Common.getCurrentDate();
			Common.mkdirs(Common.TMP_PATH + dt);
			File file = new FileRenamePolicy().rename(new File(Common.TMP_PATH + dt + "/export_hancel_" + Common.getCurrentTime("yyyyMMdd_HHmmss") + ".cell"));
			XLSXWriter xlsx = new XLSXWriter(title, headerArray, bodyArray, new FileOutputStream(file));
			xlsx.execute();

			if (Common.isNotEmpty(menuId)) {
				AuditRequestVO auditVo = new AuditRequestVO();
				auditVo.setPMenuId(pMenuId);
				auditVo.setMenuId(menuId);
				auditVo.setOperation(Operation.DOWNLOAD.getOperation());
				StringBuffer info = new StringBuffer();
				info.append("["+Prop.propFormat("common.msg.export")+"]").append(ENTER);
				info.append(Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.hancel")+" cell)");

				auditVo.setInformation(info.toString());
				auditService.insertAudit(request, auditVo);
			}
			return new XcnResponseVO(XcnRspCode.OK, file.getAbsolutePath());
		} catch (Exception e) {
			e.printStackTrace();
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.create.cell", request));
		}
	}

	@RequestMapping(value = "/utils/xlsxDown.do")
	@Description("XLSX DownLoad 페이지")
	public void xlsxDown(final HttpServletRequest request, final HttpSession session, final HttpServletResponse response) {
		String path = Common.nvl(request.getParameter("path"));
		response.setHeader("Cache-control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Connection", "close");

		File file = null;
		FileInputStream in = null;
		OutputStream out = null;
		try {
			response.addCookie(new Cookie("fileDownload", "true"));
			file = new File(path);
			if (file != null && file.exists()) {
				response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
				if (file.length() <= Integer.MAX_VALUE) response.setContentLength((int) file.length());
				in = new FileInputStream(file);
				out = response.getOutputStream();
				IOUtils.copyLarge(in, out);
				response.setStatus(HttpServletResponse.SC_OK);
			} else {
				response.sendError(HttpServletResponse.SC_NOT_FOUND, Prop.propFormat("java.error.filenotfound", request));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(in);
			IOUtils.closeQuietly(out);
			if (file != null && file.exists()) file.delete();
		}
	}

	@RequestMapping(value = "/utils/ReportXlsxWriter.do", method = RequestMethod.POST)
	@Description("XLSX Writer 호출")
	@ResponseBody
	public XcnResponseVO ReportXlsxWriter(final HttpServletRequest request, final HttpSession session) {
		String title = Common.nvl(request.getParameter("title"));
		String html = Common.nvl(request.getParameter("html"));
		String check = Common.nvl(request.getParameter("check"));
		String reportDate = Common.nvl(request.getParameter("reportDate"));
		String searchDate = Common.nvl(request.getParameter("searchDate"));
		String pMenuId = Common.nvl(request.getParameter("pMenuId"));
		String menuId = Common.nvl(request.getParameter("menuId"));
		try {
			String dt = Common.getCurrentDate();
			Common.mkdirs(Common.TMP_PATH + dt);
			File file = new FileRenamePolicy().rename(new File(Common.TMP_PATH + dt + "/export_excel_" + Common.getCurrentTime("yyyyMMdd_HHmmss") + ".xlsx"));
			HTMLtoXLSXWriter xlsx = new HTMLtoXLSXWriter(title, reportDate, searchDate, html, check, new FileOutputStream(file));
			xlsx.execute();
			if (Common.isNotEmpty(menuId)) {
				AuditRequestVO auditVo = new AuditRequestVO();
				auditVo.setPMenuId(pMenuId);
				auditVo.setMenuId(menuId);
				auditVo.setOperation(Operation.DOWNLOAD.getOperation());
				auditVo.setInformation(Prop.propFormat("java.download.excel"));
				auditService.insertAudit(request, auditVo);
			}
			return new XcnResponseVO(XcnRspCode.OK, file.getAbsolutePath());
		} catch (Exception e) {
			e.printStackTrace();
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.create.excel", request));
		}
	}
}
