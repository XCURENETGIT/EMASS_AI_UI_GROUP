package com.xcurenet.user.service.samsunglife;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.cxf.jaxws.JaxWsProxyFactoryBean;

import com.samsung.im.ws.fim701.Fim701InData;
import com.samsung.im.ws.fim701.Fim701OutData;
import com.samsung.im.ws.fim701.Fim701Service;
import com.samsung.im.ws.fim701.ReturnVo;
import com.samsung.im.ws.fim711.ApplyningVo;
import com.samsung.im.ws.fim711.ArrayVo;
import com.samsung.im.ws.fim711.Fim711InData;
import com.samsung.im.ws.fim711.Fim711OutData;
import com.samsung.im.ws.fim711.Fim711Service;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class OrgExecute {
	private final String ORG_INFO_SOAP_ADDRESS = "im/services/fim701";
	private final String ORG_DATA_SOAP_ADDRESS = "im/services/fim711";
	private final String ORG_INFO_IFGB = "F-IM-701";
	private final String ORG_DATA_IFGB = "F-IM-711";

	private final String ORG_REQ_LIST = "NAME|CODE|ORG_FULL_PATH|CHNL_PARENT_CD";

	private static String host;
	private static boolean isHttpsBoolean;
	private static String port;
	private static String user;
	private static String pass;

	public OrgExecute() {
		host = Config.getString("api.insa.host");
		port = Config.getString("api.insa.port");
		user = Config.getString("api.insa.user");
		pass = Config.getString("api.insa.password");
		isHttpsBoolean = Config.getBoolean("api.insa.ishttps");

		log.debug("[INSA API ORG INFO] HOST:{}, port:{}, user:{}, pass:{}, isHTTPS:{}", host, port, user, pass, isHttpsBoolean);
	}

	public List<ArrayVo> orgProcessList(Map<String, String> orgMap, Map<String, String> pOrgMap) {
		ReturnVo orgInfo = getOrgInfo();

		int totalPage = Common.nvz(orgInfo.getTotalPage());
		String resultCode = Common.nvl(orgInfo.getRtnCd());
		String resultMsg = Common.nvl(orgInfo.getErrMsg());

		// 에러인경우
		if (Common.isEquals(resultCode, "99")) {
			log.error("[API RESPONSE] resultMsg : {}", resultMsg);
			return null;
		}

		List<ArrayVo> result = new ArrayList<ArrayVo>();
		for (int i = 0; i < totalPage; i++) {
			Fim711OutData out = getOrgData(i+1, ORG_REQ_LIST);
			// 에러인경우
			if (Common.isEquals(out.getReturnVo().getRtnCd(), "99")) {
				log.error("[API RESPONSE] resultMsg : {}", resultMsg);
				return null;
			}

			ArrayVo[] vos = out.getArrayVo();
			for (int j = 0, iend = vos.length; j < iend; j++) {
				ArrayVo vo = vos[j];
				result.add(vo);
				String name = vo.getName();
				if(Common.isNotEmpty(vo.getOrgFullPath()) ) name += "(" + vo.getOrgFullPath() + ")";
				orgMap.put(vo.getCode(), name);

				if (Common.isNotEmpty(vo.getChnlParentCd()) && Common.isNotEquals(vo.getCode(), vo.getChnlParentCd())) pOrgMap.put(vo.getCode(), vo.getChnlParentCd());
				log.debug("[DEPT INFO] code : {}, name : {}, upperCode : {}", vo.getCode(), name, vo.getChnlParentCd());
			}
		}
		log.info("[ORG Result] orgMap.size : {}, pOrgMap.size : {}", orgMap.size(), pOrgMap.size());
		return result;
	}


	// 데이터 총건수 확인(조직)
	private ReturnVo getOrgInfo() {
		Fim701InData in = new Fim701InData();
		com.samsung.im.ws.fim701.ApplyningVo invo = new com.samsung.im.ws.fim701.ApplyningVo();
		invo.setIfGb(ORG_INFO_IFGB);
		invo.setIfTarget("0");
		in.setApplyningVo(invo);
		log.info("[API REQUEST] ifGb : {}, ifTarget : {}", in.getApplyningVo().getIfGb(),
				in.getApplyningVo().getIfTarget());

		Fim701OutData out = create701(Fim701Service.class, ORG_INFO_SOAP_ADDRESS).processData(in);
		ReturnVo result = out.getReturnVo();

		log.info("[API RESPONSE] totalCount : {}, pageBreak : {}, totalPage : {}", result.getTotalCnt(),
				result.getMaxCnt(), result.getTotalPage());

		return result;
	}

	private Fim711OutData getOrgData(int page, String reqList) {
		Fim711InData in = new Fim711InData();
		ApplyningVo invo = new ApplyningVo();
		invo.setIfGb(ORG_DATA_IFGB);
		invo.setIfTarget("0");
		invo.setTotalPage(Common.nvl(page));
		invo.setReqList(reqList);
		in.setApplyningVo(invo);

		log.info("[API REQUEST] ifGb : {}, ifTarget : {}, page : {}, reqList : {}", in.getApplyningVo().getIfGb(),
				in.getApplyningVo().getIfTarget(), invo.getTotalPage(), invo.getReqList());
		Fim711OutData out = create711(Fim711Service.class, ORG_DATA_SOAP_ADDRESS).processData(in);

		return out;

	}

	public static Fim701Service create701(Class<?> serviceInterface, String soapAddress) {
		return (Fim701Service) create(serviceInterface, soapAddress);
	}

	public static Fim711Service create711(Class<?> serviceInterface, String soapAddress) {
		return (Fim711Service) create(serviceInterface, soapAddress);
	}

	public static Object create(Class<?> serviceInterface, String soapAddress) {
		JaxWsProxyFactoryBean client = new JaxWsProxyFactoryBean();
		client.setServiceClass(serviceInterface);
		client.setAddress(getAddress(soapAddress, isHttpsBoolean, host, port));
		client.setUsername(user);
		client.setPassword(pass);
		return client.create();
	}

	public static String getAddress(String soapAddress, boolean isHttpsBoolean, String host, String port) {
		String soapAttr;
		if (soapAddress != null && soapAddress.length() > 0 && soapAddress.startsWith("/")) {
			soapAttr = soapAddress.substring(1); // 앞에 "/(Slash) 제거";
		} else {
			soapAttr = soapAddress;
		}
		return ((!isHttpsBoolean) ? "http://" : "https://") + host
				+ ((port == null || port.equals("")) ? "/" : ":" + port + "/") + soapAttr;
	}
}
