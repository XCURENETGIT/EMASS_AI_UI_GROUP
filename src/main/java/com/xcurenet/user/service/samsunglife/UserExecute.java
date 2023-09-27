package com.xcurenet.user.service.samsunglife;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.cxf.jaxws.JaxWsProxyFactoryBean;

import com.samsung.im.ws.fim702.Fim702InData;
import com.samsung.im.ws.fim702.Fim702OutData;
import com.samsung.im.ws.fim702.Fim702Service;
import com.samsung.im.ws.fim702.ReturnVo;
import com.samsung.im.ws.fim712.ApplyningVo;
import com.samsung.im.ws.fim712.ArrayVo;
import com.samsung.im.ws.fim712.Fim712InData;
import com.samsung.im.ws.fim712.Fim712OutData;
import com.samsung.im.ws.fim712.Fim712Service;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class UserExecute {
	private final String USER_INFO_SOAP_ADDRESS = "im/services/fim702";
	private final String USER_DATA_SOAP_ADDRESS = "im/services/fim712";
	private final String USER_INFO_IFGB = "F-IM-702";
	private final String USER_DATA_IFGB = "F-IM-712";

	private final String USER_REQ_LIST = "NAME|CODE|USER_TP|USER_TPNM|EMAIL|HIRED_DT|DPT_CD|REST_FLAG|REST_DT|PC_IP_1|PC_IP_2|PC_IP_3|PC_IP_4|PC_IP_5|OUT_EMAIL|SG_ID|SG_EMAIL|SG_DTY_NAME|SG_POSIT_ID|SG_POSIT_NAME";

	private static String host;
	private static boolean isHttpsBoolean;
	private static String port;
	private static String user;
	private static String pass;
	
	public UserExecute() {
		host = Config.getString("api.insa.host");
		port = Config.getString("api.insa.port");
		user = Config.getString("api.insa.user");
		pass = Config.getString("api.insa.password");
		isHttpsBoolean = Config.getBoolean("api.insa.ishttps");
		
		log.debug("[INSA API USER INFO] HOST:{}, port:{}, user:{}, pass:{}, isHTTPS:{}", host, port, user, pass, isHttpsBoolean);
	}
	
	
	public List<ArrayVo> executeInsa(Map<String, String> orgMap, Map<String, String> pOrgMap){
		log.info("[Map Size] orgMap_size : {}, pOrgMap_size : {}", orgMap.size(), pOrgMap.size());
		ReturnVo userInfo = getUserInfo();

		int totalPage = Common.nvz(userInfo.getTotalPage());
		String resultCode = Common.nvl(userInfo.getRtnCd());
		String resultMsg = Common.nvl(userInfo.getErrMsg());

		// 에러인경우
		if (Common.isEquals(resultCode, "99")) {
			log.error("[API RESPONSE] resultMsg : {}", resultMsg);
			return null;
		}

		List<ArrayVo> result = new ArrayList<ArrayVo>();
		int addCnt = 0;
		int filterCnt = 0;
		int addtionalDeptCnt = 0;
		for (int i = 0; i < totalPage; i++) {
			Fim712OutData out = getUserData(i+1, USER_REQ_LIST);
			// 에러인경우
			if (Common.isEquals(out.getReturnVo().getRtnCd(), "99")) {
				log.error("[API RESPONSE] resultMsg : {}", resultMsg);
				return null;
			}

			ArrayVo[] vos = out.getArrayVo();
			
			for (int j = 0, iend = vos.length; j < iend; j++) {
				ArrayVo vo = vos[j];
				if(Common.isEmpty(vo.getSgId())) {
					filterCnt++;
					continue; //마이싱글 아이디가 없는 경우 필터링한다.
				}
				result.add(vo);
				log.debug("[result] code : {}, name : {}, dpt_cd : {}, sg_id : {}", vo.getCode(), vo.getName(), vo.getDptCd(), vo.getSgId()); //테스트 소스
				addCnt++;
				
				if(Common.isEmpty(orgMap.get(vo.getSgUpdptCd()))){
					orgMap.put(vo.getSgUpdptCd(), vo.getSgUpdptName());
					addtionalDeptCnt++;
				}
			}
			log.info("[API RESPONSE] TOTAL : {}, FILTER : {}, VO_COUNT : {}, additionalDeptCnt : {}", vos.length, filterCnt, addCnt, addtionalDeptCnt);
			
			//if(result.size() > 0 ) break; //테스트 소스
		}

		return result;
	}
	
	// 데이터 총건수 확인(사용자)
	private ReturnVo getUserInfo() {
		Fim702InData in = new Fim702InData();
		com.samsung.im.ws.fim702.ApplyningVo invo = new com.samsung.im.ws.fim702.ApplyningVo();
		invo.setIfGb(USER_INFO_IFGB);
		invo.setIfTarget("00");
		in.setApplyningVo(invo);
		log.info("[API REQUEST] ifGb : {}, ifTarget : {}", in.getApplyningVo().getIfGb(),
				in.getApplyningVo().getIfTarget());

		Fim702OutData out = ((Fim702Service) create702(Fim702Service.class, USER_INFO_SOAP_ADDRESS)).processData(in);
		ReturnVo result = out.getReturnVo();

		log.info("[API RESPONSE] totalCount : {}, pageBreak : {}, totalPage : {}", result.getTotalCnt(),
				result.getMaxCnt(), result.getTotalPage());

		return result;
	}

	private Fim712OutData getUserData(int page, String reqList) {
		Fim712InData in = new Fim712InData();
		ApplyningVo invo = new ApplyningVo();
		invo.setIfGb(USER_DATA_IFGB);
		invo.setIfTarget("00");
		invo.setTotalPage(Common.nvl(page));
		invo.setReqList(reqList);
		in.setApplyningVo(invo);

		log.info("[API REQUEST] ifGb : {}, ifTarget : {}, page : {}", in.getApplyningVo().getIfGb(),
				in.getApplyningVo().getIfTarget(), invo.getTotalPage());
		Fim712OutData out = ((Fim712Service) create712(Fim712Service.class, USER_DATA_SOAP_ADDRESS)).processData(in);

		return out;

	}

	public static Fim702Service create702(Class<?> serviceInterface, String soapAddress) {
		return (Fim702Service) create(serviceInterface, soapAddress);
	}

	public static Fim712Service create712(Class<?> serviceInterface, String soapAddress) {
		return (Fim712Service) create(serviceInterface, soapAddress);
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
