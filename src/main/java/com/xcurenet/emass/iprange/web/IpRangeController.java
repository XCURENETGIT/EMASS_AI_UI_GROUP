package com.xcurenet.emass.iprange.web;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.*;
import com.xcurenet.common.csv.CsvReader;
import com.xcurenet.common.excel.XLSXReader;
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.iprange.service.IpRangeService;
import com.xcurenet.emass.iprange.service.IpRangeVO;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.compress.utils.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.BUSI_IPRANGE)
public class IpRangeController {

	@Resource(name = "ipRangeService")
	public IpRangeService ipRangeService;

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;
	
	@Autowired
	private AuditService auditService;

	@RequestMapping(value = "/getIpRangeList.xcn")
	@Description("사업장별 IP Range 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getIpRangeList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String ipSig = Common.nvl(request.getParameter("ipSig"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, ipRangeService.getIpRangeList(searchStr, ipSig, offset, limit));
	}
	
	@RequestMapping(value = "/getIpRangeListByBusicd.xcn")
	@Description("운용자별 사업장 권한에 따른 IP Range 리스트 조회")
	@ResponseBody
	public XcnResponseVO getIpRangeListByBusicd(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String adminId = Common.nvl(request.getParameter("adminId"));
		String ipSig = Common.nvl(request.getParameter("ipSig"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		String busiCd = ipRangeService.getBusicdByAdminId(adminId);
		return new XcnResponseVO(XcnRspCode.OK, ipRangeService.getIpRangeListByBusicd(adminId, searchStr, ipSig, busiCd, offset, limit));
	}

	@RequestMapping(value = "/insertIpRange.xcn")
	@Description("사업장별 IP Range 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertIpRange(final HttpServletRequest request, IpRangeVO ipRange) throws Exception {
		if (ipRangeService.isBusiIpRangeExist(ipRange)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.ip", request, ipRange.getStartIp() + " ~ " + ipRange.getEndIp()));
		} else {
			int rs = ipRangeService.insertIpRange(ipRange);
			makeInfoService.addInfoIpRange();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}
	@RequestMapping(value = "/updateIpRange.xcn")
	@Description("사업장별 IP Range 등록")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateIpRange(final HttpServletRequest request, IpRangeVO ipRange) throws Exception {
		if(Common.isEquals(ipRange.getStartIp(), ipRange.getOrgStartIp()) && Common.isEquals(ipRange.getEndIp(), ipRange.getOrgEndIp())){
			int rs = ipRangeService.updateIpRange(ipRange);
			makeInfoService.addInfoIpRange();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}else{
			if (ipRangeService.isBusiIpRangeExist(ipRange)) {
				return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.ip", request, ipRange.getStartIp() + " ~ " + ipRange.getEndIp()));
			} else {
				int rs = ipRangeService.updateIpRange(ipRange);
				makeInfoService.addInfoIpRange();
				return new XcnResponseVO(XcnRspCode.OK, rs);
			}
		}
	}

	@RequestMapping(value = "/deleteIpRange.xcn")
	@Description("사업장별 IP Range 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteIpRange(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<IpRangeVO> ipRanges = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			IpRangeVO ipRange = (IpRangeVO) JSONObject.toBean(data.getJSONObject(i), IpRangeVO.class);
			ipRanges.add(ipRange);
		}
		if (ipRangeService.deleteIpRange(ipRanges) == 1) {
			makeInfoService.addInfoIpRange();
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
		}
	}
	
	@Description("사업장 내부 IP upload")
	@RequestMapping(value = "/importIprange.xcn", method = RequestMethod.POST)
	public void importIprange(IpRangeVO vo, HttpServletResponse response, HttpServletRequest request) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Content-Type", "application/json");
		
		JSONObject item    = new JSONObject();
		PrintWriter pw     = response.getWriter();
		MultipartFile file = vo.getAttach();
		
		if(file == null || file.isEmpty()) {
			item.put("success", false);
			item.put("message", Prop.propFormat("keyword.upload.fail" + " <br/>" + Prop.propFormat("keyword.upload.nocontent")));
			pw.print(item);
			IOUtils.closeQuietly(pw);
			return;
		}
		
		String tmp = Config.IPRANGE_TMP;
		Common.mkdirs(tmp);
		
		File dest = new File(tmp + file.getOriginalFilename());
		if(dest.exists()) {
			dest.delete();
		}
		
		InputStream is = null;
		try {
			file.transferTo(dest);
			
			String fileName = dest.getName();
			String fileExt  = fileName.substring(fileName.lastIndexOf(".") +1, fileName.length()).toLowerCase();
			JSONArray jsonList = new JSONArray();

			if(Common.isEquals("csv", fileExt) || Common.isEquals("txt", fileExt)|| Common.isEquals("text", fileExt)) {
				CsvReader csvReader = new CsvReader(dest.getAbsolutePath(), vo.getEncoding(), vo.getSeparator().charAt(0));
				jsonList = csvReader.getList();
			}
			
			if(Common.isEquals("xlsx", fileExt)) {
				XLSXReader xlsxReader = new XLSXReader(dest.getAbsolutePath());
				jsonList = xlsxReader.getList();
			}
			
			log.info("jsonList : {} ",jsonList);
			item = ipRangeService.importIpRange(jsonList, Common.getAdminId(request));
			makeInfoService.addInfoIpRange();
			
			AuditRequestVO auditVo = new AuditRequestVO();
			StringBuffer info = new StringBuffer();
			info.append("["+Prop.propFormat("ipRange.set.iprange")+" - "+Prop.propFormat("auditLog.oper.UPLOAD")+"]").append("┌");
			
			auditVo.setPMenuId( ParentMenu.OPERATION_MGMT.getParentMenuId() );
			auditVo.setMenuId( Menu.BUSI_IPRANGE.getMenuId() );
			auditVo.setOperation(Operation.UPLOAD.getOperation());
			auditVo.setInformation(info.toString());
			auditService.insertAudit(request, auditVo);
			
		}catch(Exception e) {
			e.printStackTrace();
			item.put("success", false);
			item.put("message", Prop.propFormat("keyword.upload.error"));
		}finally {
			if (dest.exists()) {
				dest.delete();
			}
			pw.print(item);
			pw.flush();
			IOUtils.closeQuietly(is);
			IOUtils.closeQuietly(pw);
		}
	}
}
