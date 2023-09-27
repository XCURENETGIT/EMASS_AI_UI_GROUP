package com.xcurenet.common.csv;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;

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
import com.xcurenet.common.rename.FileRenamePolicy;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

import net.sf.json.JSONArray;

@Controller
public class CsvController {
	
	@Autowired
	private AuditService auditService;
	
	private static final String ENTER = "┌";
	
	@RequestMapping(value = "/utils/csvWriter.do", method = RequestMethod.POST)
	@Description("CSV Writer 호출")
	@ResponseBody
	public XcnResponseVO xlsxWriter(final HttpServletRequest request, final HttpSession session) {
		String header = Common.nvl(request.getParameter("header"));
		String body = Common.nvl(request.getParameter("body"));
		String pMenuId = Common.nvl(request.getParameter("pMenuId"));
		String menuId = Common.nvl(request.getParameter("menuId"));
		JSONArray headerArray = Common.toJSONArray(header);
		JSONArray bodyArray = Common.toJSONArray(body);
		try {
			String dt = Common.getCurrentDate();
			Common.mkdirs(Common.TMP_PATH + dt);
			File file = new FileRenamePolicy().rename(new File(Common.TMP_PATH + dt + "/export_csv_" + Common.getCurrentTime("yyyyMMdd_HHmmss") + ".csv"));

			new CsvWriter(headerArray, bodyArray, new OutputStreamWriter(new FileOutputStream(file), Charset.forName("EUC-KR")));
			
			AuditRequestVO auditVo = new AuditRequestVO();
			auditVo.setPMenuId( pMenuId );
			auditVo.setMenuId( menuId );
			auditVo.setOperation("DOWNLOAD");
			StringBuffer info = new StringBuffer();
			info.append("["+Prop.propFormat("common.msg.export")+"]").append(ENTER);
			info.append(Prop.propFormat("selectCodeAll.list")+" ("+Prop.propFormat("common.msg.text")+" csv)");

			auditVo.setInformation(info.toString());
			auditService.insertAudit(request, auditVo);
			return new XcnResponseVO(XcnRspCode.OK, file.getAbsolutePath());
		} catch (Exception e) {
			e.printStackTrace();
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert", request));
		}
	}

	@RequestMapping(value = "/utils/csvDown.do")
	@Description("CSV DownLoad 페이지")
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
}
