package com.xcurenet.emass.filter.web;

import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.common.ipv6.IPv6Address;
import com.xcurenet.common.ipv6.IPv6AddressRange;
import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.filter.service.IpFilterService;
import com.xcurenet.emass.filter.service.IpFilterVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.POLICY_SETUP)
@AuditMenu(Menu.POLICY_NOLOG)
public class IpFilterController {

	@Resource(name = "ipFilterService")
	public IpFilterService ipFilterService;

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;
	
	@Autowired
	private AuditService auditService;

	@RequestMapping(value = "/getIpFilterList.xcn")
	@Description("아이피 필터 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getIpFilterList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String serverIp = Common.nvl(request.getParameter("serverIp"));
		return new XcnResponseVO(XcnRspCode.OK, ipFilterService.getIpFilterList(searchStr, serverIp));
	}
	
	@RequestMapping(value = "/getSelectDeviceList.xcn")
	@Description("선택된 장비 조회")
	@ResponseBody
	public XcnResponseVO getSelectDeviceList(IpFilterVO filter) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, ipFilterService.getSelectDeviceList(filter));
	}

	@RequestMapping(value = "/getIpFilterDevice.xcn")
	@Description("특정 장비에 적용된 아이피 필터 리스트 조회")
	@ResponseBody
	public XcnResponseVO getIpFilterDevice(IpFilterVO filter) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, ipFilterService.getIpFilterDevice(filter));
	}

	@RequestMapping(value = "/insertIpFilter.xcn")
	@Description("아이피 필터 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertIpFilter(final HttpServletRequest request, IpFilterVO filter) throws Exception {
		
		if( Common.nvl( filter.getUserIpAll() ).equals("") ) filter.setUserIpAll("N");
		else {
			if( Config.isIPv6 && Common.nvl( filter.getIpVer(), "4" ).equals("6") ) {
				filter.setUserSIp("0000:0000:0000:0000:0000:0000:0000:0001");
				filter.setUserEIp("FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF");
			} else {
				filter.setUserSIp("0.0.0.1");
				filter.setUserEIp("255.255.255.255");
			}
		}
		if( Common.nvl( filter.getUserPortAll() ).equals("") ) filter.setUserPortAll("N");
		else {
			filter.setUserSPort("1");
			filter.setUserEPort("65535");
		}
		if( Common.nvl( filter.getServerIpAll() ).equals("") ) filter.setServerIpAll("N");
		else {
			if( Config.isIPv6 && Common.nvl( filter.getIpVer(), "4" ).equals("6") ) {
				filter.setServerSIp("0000:0000:0000:0000:0000:0000:0000:0001");
				filter.setServerEIp("FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF");
			} else {
				filter.setServerSIp("0.0.0.1");
				filter.setServerEIp("255.255.255.255");
			}
		}
		if( Common.nvl( filter.getServerPortAll() ).equals("") ) filter.setServerPortAll("N");
		else {
			filter.setServerSPort("1");
			filter.setServerEPort("65535");
		}
		filter.setUseYn("Y");
		
		IpFilterVO nFilter = ipFilterService.getNextIpNoLogSeq();
		filter.setIpLogSeq(nFilter.getIpLogSeq());
		
		if ( !checkIpFilter(filter) || ipFilterService.isIpExist(filter)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert_only", request));
		else {
			JSONArray data = Common.toJSONArray( filter.getDeviceInfo());
			for (int i = 0; i < data.size(); i++) {
				IpFilterVO device = (IpFilterVO) JSONObject.toBean(data.getJSONObject(i), IpFilterVO.class);
				device.setIpLogSeq(nFilter.getIpLogSeq());
				ipFilterService.insertIpFilterDevice(device);
			}
			
			int rs = ipFilterService.insertIpFilter(filter);
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/updateIpFilter.xcn")
	@Description("아이피 필터 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateIpFilter(final HttpServletRequest request, IpFilterVO filter) throws Exception {
		
		if( Common.nvl( filter.getUserIpAll() ).equals("") ) filter.setUserIpAll("N");
		else {
			if( Config.isIPv6 && Common.nvl( filter.getIpVer(), "4" ).equals("6") ) {
				filter.setUserSIp("0000:0000:0000:0000:0000:0000:0000:0001");
				filter.setUserEIp("FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF");
			} else {
				filter.setUserSIp("0.0.0.1");
				filter.setUserEIp("255.255.255.255");
			}
		}
		if( Common.nvl( filter.getUserPortAll() ).equals("") ) filter.setUserPortAll("N");
		else {
			filter.setUserSPort("1");
			filter.setUserEPort("65535");
		}
		if( Common.nvl( filter.getServerIpAll() ).equals("") ) filter.setServerIpAll("N");
		else {
			if( Config.isIPv6 && Common.nvl( filter.getIpVer(), "4" ).equals("6") ) {
				filter.setServerSIp("0000:0000:0000:0000:0000:0000:0000:0001");
				filter.setServerEIp("FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF");
			} else {
				filter.setServerSIp("0.0.0.1");
				filter.setServerEIp("255.255.255.255");
			}
		}
		if( Common.nvl( filter.getServerPortAll() ).equals("") ) filter.setServerPortAll("N");
		else {
			filter.setServerSPort("1");
			filter.setServerEPort("65535");
		}
		filter.setUseYn("Y");
		
		if (!checkIpFilter(filter) || ipFilterService.isIpExist(filter)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert_only", request));
		} else {
			
			ipFilterService.deleteIpFilterDevice(filter);
			
			JSONArray data = Common.toJSONArray( filter.getDeviceInfo());
			for (int i = 0; i < data.size(); i++) {
				IpFilterVO device = (IpFilterVO) JSONObject.toBean(data.getJSONObject(i), IpFilterVO.class);
				device.setIpLogSeq(filter.getIpLogSeq());
				ipFilterService.insertIpFilterDevice(device);
			}
			
			int rs = ipFilterService.updateIpFilter(filter);
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/deleteIpFilter.xcn")
	@Description("아이피 필터 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteIpFilter(final HttpServletRequest request) throws Exception {

		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<IpFilterVO> filters = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			IpFilterVO filter = (IpFilterVO) JSONObject.toBean(data.getJSONObject(i), IpFilterVO.class);
			filters.add(filter);
		}
		if (ipFilterService.deleteIpFilter(filters) == 1) {
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
		}
	}
	
	
	@RequestMapping(value = "/ruleApplyIpFilter.xcn")
	@Description("아이피 필터 장비 적용")
	@ResponseBody
	public XcnResponseVO ruleApplyIpFilter(final HttpServletRequest request) throws Exception {
		JSONArray data = Common.toJSONArray(request.getParameter("devData"));

		
		JSONArray json = ipFilterService.ruleApplyIpFilter( data );
		boolean flag = true;
		String msg = "";
		String info = "";

		
		for (int i = 0; i < json.size(); i++) {
			if( Boolean.valueOf( json.getJSONObject(i).get("success").toString() )) {
				msg += json.getJSONObject(i).get("message").toString() + "\n";
				info += json.getJSONObject(i).get("message").toString() + "┌";
			} else {
				flag = false;
				msg += json.getJSONObject(i).get("message").toString() + "\n";
				info += json.getJSONObject(i).get("message").toString() + "┌";
			}
		}

		AuditRequestVO auditVo = new AuditRequestVO();
		auditVo.setPMenuId(ParentMenu.POLICY_SETUP.getParentMenuId());
		auditVo.setMenuId(Menu.POLICY_NOLOG.getMenuId());
		auditVo.setOperation(Operation.RULE_APPLY.getOperation());
		auditVo.setInformation("["+Prop.propFormat("filterInfo.ruleapply")+"]┌"+info.replaceAll("<span style=\"color: #ff0000;\">", "").replaceAll("</span>", ""));
		auditService.insertAudit(request, auditVo);
		
		if( flag ) {
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage( msg );
		}
		
		/*if( Boolean.valueOf( json.getJSONObject(0).get("success").toString() )) {
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage( json.getJSONObject(0).get("message").toString() );
		}*/
	}
	
	private boolean checkIpFilter(IpFilterVO filter) {
		String userSip = Common.nvl(filter.getUserSIp());
		String userEip = Common.nvl(filter.getUserEIp());
		String serverSip = Common.nvl(filter.getServerSIp());
		String serverEip = Common.nvl(filter.getServerEIp());
		List<IpFilterVO> ipList = new ArrayList<>();
		ipList = ipFilterService.ipCheckList(filter);
		if( ipList.size() > 0 && ipList.get(0) != null && !ipList.isEmpty() ) {
			for (int i = 0; i < ipList.size(); i++) {
				String mapUserSip = Common.nvl(ipList.get(i).getUserSIp());
				String mapUserEip = Common.nvl(ipList.get(i).getUserEIp());
				String mapServerSip = Common.nvl(ipList.get(i).getServerSIp());
				String mapServerEip = Common.nvl(ipList.get(i).getServerEIp());
				
				if ( !mapUserSip.equals("") && getIPversion(userSip).equals("4") && getIPversion(mapUserSip).equals("4") )
				{
					if ( strIpToLong(mapUserSip) >= strIpToLong(userSip) && strIpToLong(mapUserEip) <= strIpToLong(userSip) ) return false;
					if ( strIpToLong(mapUserSip) >= strIpToLong(userEip) && strIpToLong(mapUserEip) <= strIpToLong(userEip) ) return false;
					if ( strIpToLong(userSip) >= strIpToLong(mapUserSip) && strIpToLong(userEip) <= strIpToLong(mapUserSip) ) return false;
					if ( strIpToLong(userSip) >= strIpToLong(mapUserEip) && strIpToLong(userEip) <= strIpToLong(mapUserEip) ) return false;
					if ( strIpToLong(mapServerSip) >= strIpToLong(serverSip) && strIpToLong(mapServerEip) <= strIpToLong(serverSip) ) return false;
					if ( strIpToLong(mapServerSip) >= strIpToLong(serverEip) && strIpToLong(mapServerEip) <= strIpToLong(serverEip) ) return false;
					if ( strIpToLong(serverSip) >= strIpToLong(mapServerSip) && strIpToLong(serverEip) <= strIpToLong(mapServerSip) ) return false;
					if ( strIpToLong(serverSip) >= strIpToLong(mapServerEip) && strIpToLong(serverEip) <= strIpToLong(mapServerEip) ) return false;
				}
				else if ( !mapUserSip.equals("") && getIPversion(userSip).equals("6") && getIPversion(mapUserSip).equals("6") )
				{
					IPv6AddressRange usermapIpRange = IPv6AddressRange.fromFirstAndLast( IPv6Address.fromString( mapUserSip ), IPv6Address.fromString( mapUserEip ) );
					IPv6AddressRange userIpRange = IPv6AddressRange.fromFirstAndLast( IPv6Address.fromString( userSip ), IPv6Address.fromString( userEip ) );
					if ( usermapIpRange.contains( IPv6Address.fromString( userSip ) ) || usermapIpRange.contains( IPv6Address.fromString( userEip ) ) ) return false; 
					if ( userIpRange.contains( IPv6Address.fromString( mapUserSip ) ) || userIpRange.contains( IPv6Address.fromString( mapUserEip ) ) ) return false;
					
					IPv6AddressRange servermapIpRange = IPv6AddressRange.fromFirstAndLast( IPv6Address.fromString( mapServerSip ), IPv6Address.fromString( mapServerEip ) );
					IPv6AddressRange serverIpRange = IPv6AddressRange.fromFirstAndLast( IPv6Address.fromString( serverSip ), IPv6Address.fromString( serverEip ) );
					if ( servermapIpRange.contains( IPv6Address.fromString( serverSip ) ) || servermapIpRange.contains( IPv6Address.fromString( serverEip ) ) ) return false; 
					if ( serverIpRange.contains( IPv6Address.fromString( mapServerSip ) ) || serverIpRange.contains( IPv6Address.fromString( mapServerEip ) ) ) return false;
				}
			}
		}
		return true;
	}
	
	private String getIPversion ( String ip )
	{
		String result = "";
		InetAddress address = null;
		try {
			address = InetAddress.getByName(ip);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (address instanceof Inet6Address) {
			result = "6";
		} else if (address instanceof Inet4Address) {
			result = "4";
		}
		return result;
	}
	
	private long strIpToLong ( String ip )
	{
		InetAddress tmpIp = null;
		try {
			tmpIp = InetAddress.getByName(ip);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		byte[] octets = tmpIp.getAddress();
		long result = 0;
		for (byte octet : octets) {
			result <<= 8;
			result |= octet & 0xff;
		}
		return result;
	}
}
