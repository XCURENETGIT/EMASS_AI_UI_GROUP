package com.xcurenet.user.service.samsunglife;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.stereotype.Component;

import com.initech.safedb.SimpleSafeDB;
import com.initech.safedb.common.SafeDBException;
import com.samsung.im.ws.fim712.ArrayVo;
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.user.service.UserCommon;
import com.xcurenet.user.service.UserService;
import com.xcurenet.user.service.UserVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
/**
 * 삼성생명 API 인사연동 전용
 * @author WoongNae
 *
 */
public class UserInsaJob extends UserCommon implements Job {

	public Map<String, String> orgMap;
	public Map<String, String> pOrgMap;
	
	private SimpleSafeDB ssdb;

	public boolean insaJobInit() {
		orgInfoLoad();
		
		orgMap = new HashMap<String, String>();
		pOrgMap = new HashMap<String, String>();
		
		try {
			ssdb = SimpleSafeDB.getInstance();
			if(ssdb.login()) {
				log.info("[INSA API SafeDB] SafeDB Login Success...");
				return true;
			}
			else return false;
		} catch (SafeDBException e) {
			e.printStackTrace();
		}
		
		return false;
	}

	@Override
	public void execute(JobExecutionContext jobexecutioncontext) throws JobExecutionException {
		log.info("[INSA API IMPORT] insa api import start....");
		
		if(!insaJobInit()) {
			log.info("[INSA API SafeDB] SimpleSafeDB login fail...");
			return;
		}
		try {
			new OrgExecute().orgProcessList(orgMap, pOrgMap); 
			
			UserExecute userExecute = new UserExecute();
			List<ArrayVo> userList = userExecute.executeInsa(orgMap, pOrgMap);
			executeUser(userList);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			log.info("[INSA API AUTO IMPORT] insa db auto import duration {}", TimeUtil.print());
		}
	}
	
	
	public void executeUser(List<ArrayVo> userList) throws Exception {
		TimeUtil.start();
		if(userList == null) {
			log.info("[USER INSA API LOAD] User List is null...");
			return;
		}
		
		List<UserVO> users = new ArrayList<>();
		for(int i=0; i<userList.size(); i++) {
			ArrayVo vo = userList.get(i);
			UserVO user = findUserInfo(getUser(vo));
			if (Common.isEmpty(user.getUserId())) log.warn("[USER INSA API LOAD] user info load fail user id is null {}", vo.toString());
			else if (Common.isEmpty(user.getUserNm())) log.warn("[USER INSA API LOAD] user info load fail user name is null {}", vo.toString());
			else if (Common.isEmpty(user.getUserEmail()) && Common.isEmpty(user.getUserIp())) log.warn("[USER INSA API LOAD] user info load fail user email user ip is null {}", vo.toString());
			else users.add(user);
		}
		
		log.info("[USER INSA API LOAD] user info load end total:{}", users.size());
		log.info("[USER INSA API LOAD] Org Insert new cocd:{}", newCos.size());
		log.info("[USER INSA API LOAD] Org Insert new General:{}", newGeneral.size());
		log.info("[USER INSA API LOAD] Org Insert new Busi:{}", newBusi.size());
		log.info("[USER INSA API LOAD] Org Insert new Dept:{}", newDept.size());
		log.info("[USER INSA API LOAD] Org Insert new Jikgub:{}", newJikgub.size());
		log.info("[USER INSA API LOAD] Org Insert new Jikin:{}", newJikin.size());
		
		UserService userService = SpringContextUtil.getBean(UserService.class);
	
		log.info("[USER INSA API LOAD] Org Insert Start : {}", Common.getDateTime(System.currentTimeMillis()));
		boolean result = userService.scheduleUser(users, newCos, newGeneral, newBusi, newDept, newJikgub, newJikin);
		log.info("[USER INSA API LOAD] Org Insert end : {}", Common.getDateTime(System.currentTimeMillis()));
		if (result) {
			log.info("[INSA API AUTO IMPORT] insa db auto import success");
			log.info("[MAKE INFO] update make info user data start");
			MakeInfoService makeInfo = SpringContextUtil.getBean(MakeInfoService.class);
			makeInfo.addInfoUser();
			log.info("[MAKE INFO] update make info user data end");
		} else {
			log.warn("[INSA API AUTO IMPORT] insa db auto import fail");
		}
	}

	private String findTopOrgCode(String code) {
		if(Common.isEmpty(code)) return Common.EMPTY;
		
		String upCode = pOrgMap.get(code);
		if(Common.isNotEmpty(upCode) && Common.isNotEquals(code, upCode)) return findTopOrgCode(upCode);
		else return code;
	}

	//삼성생명 전용
	private UserVO getUser(ArrayVo vo) {
		UserVO user = new UserVO();
		user.setUserId(Common.nvl(vo.getCode()));
		user.setUserNm(Common.nvl(vo.getName()));
		user.setUserEmail(getEmail(vo));
		user.setUserIp(getIpAddr(vo));
		
		String dpt_cd = Common.nvl(vo.getDptCd());
		user.setDeptCd(Common.nvl(dpt_cd));
		user.setDeptNm(Common.nvl(orgMap.get(dpt_cd)));
		
		String p_dpt_cd = pOrgMap.get(dpt_cd);
		user.setPDeptCd(Common.nvl(p_dpt_cd));
		user.setPDeptNm(Common.nvl(orgMap.get(p_dpt_cd)));
		
		String cocd = Common.nvl(vo.getSgComCd());
		if(Common.isNotEmpty(cocd)){
			user.setCoCd(cocd);
			user.setCoNm(Common.nvl(vo.getSgComName()));
		}else{
			user.setCoCd("E11");
			user.setCoNm("삼성생명");
		}
		
		String top_cd = findTopOrgCode(dpt_cd);
		user.setBusiCd(Common.nvl(top_cd));
		user.setBusiNm(Common.nvl(orgMap.get(top_cd)));
		
		user.setJikgubCd(Common.nvl(vo.getSgPositId()));
		user.setJikgubNm(Common.nvl(vo.getSgPositName()));
		
		if(Common.isEquals(vo.getRestFlag(), "G")){
			user.setJikinNm("휴직");
		}else if(Common.isEquals(vo.getRestFlag(), "D")){
			user.setJikinNm("퇴직");
		}else {
			user.setJikinNm("재직");
		}
				
		
		log.info("[USER] ID : {}, name : {}, busicd : {}, businm: {}", Common.nvl(vo.getCode()), Common.nvl(vo.getName()), user.getBusiCd(), user.getBusiNm());
		return user;
	}
	
	private String getEmail(ArrayVo vo) {
		List<String> result = new ArrayList<String>();
		String email = decriptAria(Common.nvl(vo.getEmail()));
		String sg_email = decriptAria(Common.nvl(vo.getSgEmail()));
		String out_email = decriptAria(Common.nvl(vo.getOutEmail()));
		if (Common.isNotEmpty(email))
			result.add(email);
		if (Common.isNotEmpty(sg_email) && !result.contains(sg_email))
			result.add(sg_email);
		if (Common.isNotEmpty(out_email) && !result.contains(out_email))
			result.add(out_email);

		return Common.join(result, ",");
	}
	
	public static void main(String[] args) {
		System.out.println(Common.isValidIPV4("1.1.1.12334"));
	}
	
	private String getIpAddr(ArrayVo vo) {
		List<String> result = new ArrayList<String>();
		String ip1 = Common.nvl(vo.getPcIp1());
		String ip2 = Common.nvl(vo.getPcIp2());
		String ip3 = Common.nvl(vo.getPcIp3());
		String ip4 = Common.nvl(vo.getPcIp4());
		String ip5 = Common.nvl(vo.getPcIp5());
		if (Common.isNotEmpty(ip1) && Common.isValidIPV4(ip1))
			result.add(ip1);
		if (Common.isNotEmpty(ip2) && Common.isValidIPV4(ip2) && !result.contains(ip2))
			result.add(ip2);
		if (Common.isNotEmpty(ip3) && Common.isValidIPV4(ip3) && !result.contains(ip3))
			result.add(ip3);
		if (Common.isNotEmpty(ip4) && Common.isValidIPV4(ip4) && !result.contains(ip4))
			result.add(ip4);
		if (Common.isNotEmpty(ip5) && Common.isValidIPV4(ip5) && !result.contains(ip5))
			result.add(ip5);
		
		return Common.join(result, ",");
	}
	private String decriptAria(String enc_value) {
		String safedbuserid = "SAFEPOLICY";
		String tablename = "POLICY.POLICY_TB";
		String columnname = "EMAIL_ADDR_ENCR";
		if(Common.isEmpty(enc_value)) return Common.EMPTY;
		
		try {
			if (ssdb.login()) {
				byte[] decryptedData = ssdb.decrypt(safedbuserid, tablename, columnname, enc_value.getBytes());
				String resultEmail = new String(decryptedData);
				log.debug("EMAIL encrypt : {}, Email decrypt : {}", enc_value, resultEmail);
				return resultEmail;
			} else {
				System.out.println("non");
				return enc_value;
			}
		} catch (SafeDBException e) {
			e.printStackTrace();
		}
		return null;
	}
}
