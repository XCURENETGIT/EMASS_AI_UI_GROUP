package com.xcurenet.emass.adminFilter.web;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
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
import org.springframework.web.multipart.MultipartFile;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.AuditVO;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.crypto.CryptoUICommon;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.adminFilter.service.AdminFilterService;
import com.xcurenet.emass.adminFilter.service.AdminFilterVO;
import com.xcurenet.emass.adminFilter.service.FilterImportVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Slf4j
@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.MESSAGE_INFO)
public class AdminFilterController {

	@Resource(name = "AdminFilterService")
	public AdminFilterService adminFilterService;
	
	@Autowired
	private AuditService auditService;
	
	private static final String ENTER = "┌";

	@RequestMapping(value = "/getAdminFilterList.xcn")
	@Description("관리자 필터 리스트 조회")
	@ResponseBody
	public XcnResponseVO getAdminFilterList(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String adminId = Common.getAdminId(session);
		
		List<AdminFilterVO> users = adminFilterService.getAdminFilterList(adminId, Common.nvl(param.get("searchStr")), request.getContextPath());
		return new XcnResponseVO(XcnRspCode.OK, users);
	}

	@RequestMapping(value = "/insertAdminFilter.xcn")
	@Description("관리자 필터 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertAdminFilter(final HttpSession session, AdminFilterVO adminFilter) throws Exception {
		adminFilter.setAdminId(Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, adminFilterService.insertAdminFilter(adminFilter));
	}

	@RequestMapping(value = "/updateAdminFilter.xcn")
	@Description("관리자 필터 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateAdminFilter(final HttpSession session, AdminFilterVO adminFilter) throws Exception {
		adminFilter.setAdminId(Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, adminFilterService.updateAdminFilter(adminFilter));
	}

	@RequestMapping(value = "/updateFilterStatus.xcn")
	@Description("관리자 필터 상태 변경")
	@ResponseBody
	public XcnResponseVO updateFilterStatus(final HttpSession session, AdminFilterVO adminFilter) throws Exception {
		adminFilter.setAdminId(Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, adminFilterService.updateFilterStatus(adminFilter));
	}

	@RequestMapping(value = "/deleteAdminFilter.xcn")
	@Description("관리자 필터 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteAdminFilter(final HttpServletRequest request) throws Exception {
		String adminId = Common.getAdminId(request);
		String filterData = Common.nvl(request.getParameter("filterData"));
		JSONArray data = Common.toJSONArray(filterData);
		List<AdminFilterVO> filterVos = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			AdminFilterVO filterVo = (AdminFilterVO) JSONObject.toBean(data.getJSONObject(i), AdminFilterVO.class);
			filterVo.setAdminId(adminId);
			filterVos.add(filterVo);
		}
		adminFilterService.deleteAdminFilter(filterVos);
		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/updateFilterOrder.xcn")
	@Description("관리자 필터 위치 이동")
	@ResponseBody
	public XcnResponseVO updateFilterOrder(final HttpServletRequest request) throws Exception {
		String adminId = Common.getAdminId(request);
		String filterData = Common.nvl(request.getParameter("filterData"));
		JSONArray data = Common.toJSONArray(filterData);

		List<AdminFilterVO> filterVos = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			AdminFilterVO filterVo = (AdminFilterVO) JSONObject.toBean(data.getJSONObject(i), AdminFilterVO.class);
			filterVo.setAdminId(adminId);
			filterVos.add(filterVo);
		}
		adminFilterService.updateFilterOrder(filterVos);
		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/insertAdminFilterData.xcn")
	@Description("관리자 필터 데이터 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertAdminFilterData (final HttpSession session, final HttpServletRequest request) throws Exception {
		String filterData = Common.nvl(request.getParameter("filterData"));
		JSONObject data = Common.toJSONObject(filterData);
		String filterType = Common.nvl(data.get("filterType") );

		AdminFilterVO adminFilter = new AdminFilterVO();
		adminFilter.setAdminId(Common.getAdminId(session));
		adminFilter.setpId( Common.nvz(data.get("p_filter_seq") ) );
		adminFilter.setName( Common.nvl(data.get("filterName") ) );
		adminFilter.setFilterType( filterType );
		adminFilter.setDashboard(Common.nvl(data.get("dashboard")));

		JSONArray conditions = data.getJSONArray("conditions");
		JSONObject condition = conditions.getJSONObject(conditions.size()-1);
		adminFilter.setUserDtCd( Common.nvl(condition.get("period") ) );
		adminFilter.setStartDt(Common.nvl(condition.get("startDt") ));
		adminFilter.setEndDt(Common.nvl(condition.get("endDt") ));
		if( Common.isEquals(filterType, "D")) adminFilter.setConditions( Common.nvl( data.getJSONArray("conditions").toString() ) );
		else {
			JSONArray conditionArr = data.getJSONArray("conditions");
			adminFilter.setConditions( Common.nvl( conditionArr.getJSONObject(0).get("query") ) );
		}

		return new XcnResponseVO(XcnRspCode.OK, adminFilterService.insertAdminFilter(adminFilter));
	}

	@RequestMapping(value = "/updateAdminFilterData.xcn")
	@Description("관리자 필터 데이터 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateAdminFilterData (final HttpSession session, final HttpServletRequest request) throws Exception {
		String filterData = Common.nvl(request.getParameter("filterData"));
		JSONObject data = Common.toJSONObject(filterData);
		String filterType = Common.nvl(data.get("filterType") );

		AdminFilterVO adminFilter = new AdminFilterVO();
		adminFilter.setAdminId(Common.getAdminId(session));


		adminFilter.setId( Common.nvz(data.get("filter_seq") ) );
		adminFilter.setName( Common.nvl(data.get("filterName") ) );
		adminFilter.setFilterType(filterType);
		adminFilter.setDashboard(Common.nvl(data.get("dashboard")));

		JSONArray conditions = data.getJSONArray("conditions");
		JSONObject condition = conditions.getJSONObject(conditions.size()-1);
		adminFilter.setUserDtCd( Common.nvl(condition.get("period") ) );
		adminFilter.setStartDt(Common.nvl(condition.get("startDt") ));
		adminFilter.setEndDt(Common.nvl(condition.get("endDt") ));
		
		if( Common.isEquals(filterType, "D")) adminFilter.setConditions( Common.nvl( data.getJSONArray("conditions").toString() ) );
		else {
			JSONArray conditionArr = data.getJSONArray("conditions");
			adminFilter.setConditions( Common.nvl( conditionArr.getJSONObject(0).get("query") ) );
		}

		return new XcnResponseVO(XcnRspCode.OK, adminFilterService.updateAdminFilter(adminFilter));
	}
	
	@RequestMapping(value = "/exportAdminFilter.xcn")
	@Description("관리자 필터 내보내기")
	@ResponseBody
	public void exportAdminFilter (final HttpSession session, final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		JSONObject param = Common.getParam(request);
		param.put("adminId", Common.getAdminId(session));
		List<AdminFilterVO> adminFilters = adminFilterService.getAdminFilterListForExport(param);
		String data = JSONArray.fromObject(adminFilters).toString();
		if (Common.isEmpty(data)) {
			log.warn("data is empty.");
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			return;
		}
		OutputStream out = null;
		try {
			out = response.getOutputStream();
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setHeader("Connection", "close");

			CryptoUICommon crypto = new CryptoUICommon();
			response.setHeader("Content-Disposition", "attachment; filename=\"" + "adminFilter_"+Common.getCurrentTime("yyyyMMdd_HHmmss")+".flt" + "\"");
			crypto.encrypt(new ByteArrayInputStream(data.getBytes()), out, data.getBytes().length);
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			log.error("file download error.. ");
		} finally {
			IOUtils.closeQuietly(out);
			response.flushBuffer();
			
			StringBuffer info = new StringBuffer();
			info.append("["+Prop.propFormat("filterInfo.export")+"]").append(ENTER);
			//info.append(Prop.propFormat("filterInfo.count")+":").append(adminFilters.size()).append(ENTER);
			
			AdminVO admin = Common.getAdmin(request);
			AuditVO auditVo = new AuditVO();
			auditVo.setAdminId(admin.getAdminId());
			auditVo.setAdminName(admin.getAdminName());
			auditVo.setAdminIp(admin.getLoginIp());
			auditVo.setPMenuId(ParentMenu.DATA_MONITOR.getParentMenuId());
			auditVo.setMenuId(Menu.MESSAGE_INFO.getMenuId());
			auditVo.setOperation(Operation.EXPORT.getOperation());
			auditVo.setInformation(info.toString());
			auditService.insertAudit(auditVo);
		}
	}
	
	@RequestMapping(value = "/importAdminFilter.xcn", method = RequestMethod.POST)
	@Description("관리자 필터 가져오기")
	public void importAdminFilter(FilterImportVO filter, HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Content-Type", "application/json");
		JSONObject item = new JSONObject();
		PrintWriter pw = null;
		List<AdminFilterVO> adminFilters = new ArrayList<AdminFilterVO>();
		try {
			pw = new PrintWriter(response.getWriter());
			
			MultipartFile file = filter.getFile();
			log.info("upload file org name {}", file.getOriginalFilename());
			if (file == null || file.isEmpty()) {
				item.put("success", false);
				item.put("message", Prop.propFormat("java.error.incorrect.filter_upload", request));
			}else{
				File nFile = new File(file.getOriginalFilename());
				file.transferTo(nFile);
				try {
					adminFilters = getAdminFilterData(nFile, Common.getAdminId(request));
				} catch (IOException e) {
					item.put("success", false);
					item.put("message", Prop.propFormat("java.error.incorrect.filter_upload", request));
				}
				
				adminFilterService.setAdminFilterListForImport(adminFilters);
				item.put("success", true);
			}
		} catch (Exception e) {
			e.printStackTrace();
			item.put("success", false);
			item.put("message", e.getMessage());
		} finally {
			pw.print(item);
			pw.flush();
			IOUtils.closeQuietly(pw);
			
			StringBuffer info = new StringBuffer();
			info.append("["+Prop.propFormat("filterInfo.import")+"]").append(ENTER);
			//info.append(Prop.propFormat("filterInfo.count")+":").append(adminFilters.size()).append(ENTER);
			
			AdminVO admin = Common.getAdmin(request);
			AuditVO auditVo = new AuditVO();
			auditVo.setAdminId(admin.getAdminId());
			auditVo.setAdminName(admin.getAdminName());
			auditVo.setAdminIp(admin.getLoginIp());
			auditVo.setPMenuId(ParentMenu.DATA_MONITOR.getParentMenuId());
			auditVo.setMenuId(Menu.MESSAGE_INFO.getMenuId());
			auditVo.setOperation(Operation.IMPORT.getOperation());
			auditVo.setInformation(info.toString());
			auditService.insertAudit(auditVo);
		}
	}
	
	private List<AdminFilterVO> getAdminFilterData(File file, String adminId) throws IOException {
		JSONArray data = new JSONArray();
		InputStream is = null;
		try {
			CryptoUICommon crypto = new CryptoUICommon();
			is = crypto.decrypt(new FileInputStream(file));
			data = Common.toJSONArray(IOUtils.toString(is, Common.UTF8));
		}
		finally{
			IOUtils.closeQuietly(is);
			
		}
		return jsonToFilterList(data, adminId);
	}
	
	private List<AdminFilterVO> jsonToFilterList(JSONArray filters, String adminId){
		List<AdminFilterVO> list = new ArrayList<>();
		for (int i = 0; i < filters.size(); i++) {
			JSONObject obj = filters.getJSONObject(i);
			AdminFilterVO af = new AdminFilterVO();
			af.setId(Common.nvn(obj.get("id")));
			af.setAdminId(adminId);
			af.setpId(Common.nvn(obj.get("pId")));
			af.setName(Common.nvl(obj.get("name")));
			af.setOpen(Common.nvl(obj.get("open")));
			af.setFilterType(Common.nvl(obj.get("filterType")));
			af.setFilterOrder(Common.nvl(obj.get("filterOrder")));
			af.setUserDtCd(Common.nvl(obj.get("userDtCd")));
			af.setStartDt(Common.nvl(obj.get("startDt")));
			af.setEndDt(Common.nvl(obj.get("endDt")));
			af.setConditions(Common.nvl(obj.get("conditions")));
			list.add(af);
		}
		return list;
	}
}
