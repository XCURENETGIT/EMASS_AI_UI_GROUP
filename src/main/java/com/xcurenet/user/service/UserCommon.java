package com.xcurenet.user.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.validator.routines.EmailValidator;
import org.apache.commons.validator.routines.InetAddressValidator;

import com.xcurenet.code.service.BusiService;
import com.xcurenet.code.service.BusiVO;
import com.xcurenet.code.service.CoService;
import com.xcurenet.code.service.CoVO;
import com.xcurenet.code.service.DeptService;
import com.xcurenet.code.service.DeptVO;
import com.xcurenet.code.service.GeneralService;
import com.xcurenet.code.service.GeneralVO;
import com.xcurenet.code.service.JikgubService;
import com.xcurenet.code.service.JikgubVO;
import com.xcurenet.code.service.JikinService;
import com.xcurenet.code.service.JikinVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class UserCommon {

	public int coIdx = 1;
	public int generalIdx = 1;
	public int busiIdx = 1;
	public int deptIdx = 1;
	public int jikgubIdx = 1;
	public int jikinIdx = 1;

	public List<CoVO> newCos;
	public List<GeneralVO> newGeneral;
	public List<BusiVO> newBusi;
	public List<DeptVO> newDept;
	public List<JikgubVO> newJikgub;
	public List<JikinVO> newJikin;

	public Map<String, String> coNmMap;
	public Map<String, String> coMap;
	public Map<String, String> generalMap;
	public Map<String, String> busiMap;
	public Map<String, String> deptMap;
	public Map<String, String> jikgubMap;
	public Map<String, String> jikinMap;
	
	public void orgInfoLoad() {
		newCos = new ArrayList<>();
		newGeneral = new ArrayList<>();
		newBusi = new ArrayList<>();
		newDept = new ArrayList<>();
		newJikgub = new ArrayList<>();
		newJikin = new ArrayList<>();

		coNmMap = getNameMap(SpringContextUtil.getBean(CoService.class));
		coMap = getCodeMap(SpringContextUtil.getBean(CoService.class));
		generalMap = getCodeMap(SpringContextUtil.getBean(GeneralService.class));
		busiMap = getCodeMap(SpringContextUtil.getBean(BusiService.class));
		deptMap = getCodeMap(SpringContextUtil.getBean(DeptService.class));
		jikgubMap = getCodeMap(SpringContextUtil.getBean(JikgubService.class));
		jikinMap = getCodeMap(SpringContextUtil.getBean(JikinService.class));
		
		
	}

	public Map<String, String> getCodeMap(CoService service) {
		List<CoVO> codes = service.getAllCoList();
		if (codes == null) return new HashMap<>();
		Map<String, String> map = new HashMap<>();
		for (CoVO code : codes) {
			map.put(code.getCoNm(), code.getCoCd());
		}
		return map;
	}
	
	public Map<String, String> getNameMap(CoService service) {
		List<CoVO> codes = service.getAllCoList();
		if (codes == null) return new HashMap<>();
		Map<String, String> map = new HashMap<>();
		for (CoVO code : codes) {
			map.put(code.getCoCd(), code.getCoNm());
		}
		return map;
	}

	public Map<String, String> getCodeMap(BusiService service) {
		List<BusiVO> codes = service.getAllBusiList();
		if (codes == null) return new HashMap<>();
		Map<String, String> map = new HashMap<>();
		for (BusiVO code : codes) {
			map.put(code.getCoNm()+ "|" + code.getBusiNm(), code.getBusiCd());
		}
		return map;
	}

	public Map<String, String> getCodeMap(GeneralService service) {
		List<GeneralVO> codes = service.getAllGeneralList();
		if (codes == null) return new HashMap<>();
		Map<String, String> map = new HashMap<>();
		for (GeneralVO code : codes) {
			map.put(code.getCoNm()+ "|" + code.getGeneralNm(), code.getGeneralCd());
		}
		return map;
	}

	public Map<String, String> getCodeMap(DeptService service) {
		List<DeptVO> codes = service.getAllDeptList();
		if (codes == null) return new HashMap<>();
		Map<String, String> map = new HashMap<>();
		for (DeptVO code : codes) {
			map.put(code.getCoNm()+ "|" + code.getDeptNm(), code.getDeptCd());
		}
		return map;
	}

	public Map<String, String> getCodeMap(JikgubService service) {
		List<JikgubVO> codes = service.getAllJikgubList();
		if (codes == null) return new HashMap<>();
		Map<String, String> map = new HashMap<>();
		for (JikgubVO code : codes) {
			map.put(code.getJikgubNm(), code.getJikgubCd());
		}
		return map;
	}

	public Map<String, String> getCodeMap(JikinService service) {
		List<JikinVO> codes = service.getAllJikinList();
		if (codes == null) return new HashMap<>();
		Map<String, String> map = new HashMap<>();
		for (JikinVO code : codes) {
			map.put(code.getJikinNm(), code.getJikinCd());
		}
		return map;
	}
	
	
	public String findBusiNmByIpRange(UserVO user) {
		UserService userService = SpringContextUtil.getBean(UserService.class);
		String str = userService.getBusiNmByIpRange(user);
		if(Common.isEmpty(Common.nvl(str))) str = "";
		return str;
	}
	
	public String findDeptNmByIpRange(UserVO user) {
		UserService userService = SpringContextUtil.getBean(UserService.class);
		String str = userService.getDeptNmByIpRange(user);
		if(Common.isEmpty(Common.nvl(str))) str = "";
		return str;
	}

	public UserVO findUserInfo(UserVO user) {
		if( Common.isEmpty(user.getCoCd()) ) {
			if ( Common.isNotEmpty(coMap.get(user.getCoNm())) ) user.setCoCd(coMap.get(user.getCoNm()));
			else user.setCoCd(getNextCoCd(user.getCoNm()));
		} else if( Common.isEmpty(user.getCoNm()) ) {
			if ( Common.isNotEmpty(coNmMap.get(user.getCoCd())) ) user.setCoNm(coNmMap.get(user.getCoCd()));
			else user.setCoNm(getNextCoNm(user.getCoCd()));
		} else if( Common.isNotEmpty(user.getCoCd()) && Common.isNotEmpty(user.getCoNm()) ){
			if ( Common.isNotEmpty(coNmMap.get(user.getCoCd()))) user.setCoNm(coNmMap.get(user.getCoCd()));
			else {
				CoVO co = new CoVO();
				co.setCoCd(user.getCoCd());
				co.setCoNm(user.getCoNm());
				co.setIsAuto("Y");
				newCos.add(co);
				coMap.put(user.getCoCd(), user.getCoNm());
			}
		}
		
		if( Common.isEmpty(user.getBusiNm()) ) {
			if(Common.isEmpty(user.getBusiCd())) user.setBusiCd("C00-00");
		}
		else {
			if ( Common.isNotEmpty(busiMap.get(user.getCoNm() + "|" + user.getBusiNm())) ) user.setBusiCd(busiMap.get(user.getCoNm() + "|" + user.getBusiNm()));
			else {
				user.setBusiCd(getNextBusiCd(user.getCoNm() + "|" + user.getBusiNm()));
				if (newBusi.size() > 0) newBusi.get(newBusi.size() - 1).setCoCd(user.getCoCd());
			}
		}
		
		if( Common.isEmpty(user.getGeneralNm()) ) {
			if(Common.isEmpty(user.getGeneralCd())) user.setGeneralCd("C00-00");
		}
		else {
			if ( Common.isNotEmpty(generalMap.get(user.getCoNm() + "|" + user.getGeneralNm())) ) user.setGeneralCd(generalMap.get(user.getCoNm() + "|" + user.getGeneralNm()));
			else {
				user.setGeneralCd(getNextGeneralCd(user.getCoNm() + "|" + user.getGeneralNm()));
				if (newGeneral.size() > 0) newGeneral.get(newGeneral.size() - 1).setCoCd(user.getCoCd());
			}
		}

		if( Common.isEmpty(user.getDeptNm()) ) {
			if(Common.isEmpty(user.getDeptCd())) user.setDeptCd("C00-00");
		}
		else {
			if (Common.isNotEmpty(deptMap.get(user.getCoNm() + "|" + user.getDeptNm()))) {
				user.setDeptCd(deptMap.get(user.getCoNm() + "|" + user.getDeptNm()));
			}
			else {
				user.setDeptCd(getNextDeptCd(user.getCoNm() + "|" + user.getDeptNm()));
				if (newDept.size() > 0) {
					newDept.get(newDept.size() - 1).setCoCd(user.getCoCd());
					if(Common.isNotEmpty(user.getPDeptCd())) newDept.get(newDept.size() - 1).setPDeptCd(user.getPDeptCd());
				}
			}
		}

		if( Common.isEmpty(user.getJikinNm()) ) user.setJikinCd("C00-00");
		else if ( Common.isNotEmpty(jikinMap.get(user.getJikinNm())) ) user.setJikinCd(jikinMap.get(user.getJikinNm()));
		else user.setJikinCd(getNextJikinCd(user.getJikinNm()));
		
		if( Common.isEmpty(user.getJikgubNm()) ) user.setJikgubCd("C00-00");
		else if ( Common.isNotEmpty(jikgubMap.get(user.getJikgubNm())) ) user.setJikgubCd(jikgubMap.get(user.getJikgubNm()));
		else user.setJikgubCd(getNextJikgubCd(user.getJikgubNm()));

		user.setIsAuto("Y");

		log.debug(user.toString());
		return user;
	}

	public String getNextCoNm(String val) {
		if (Common.isEmpty(val)) return val;
		CoVO co = new CoVO();
		co.setCoCd(val);
		co.setCoNm(val);
		co.setIsAuto("Y");
		newCos.add(co);
		coMap.put(val, val);
		return val;
	}
	
	public String getNextCoCd(String val) {
		if (Common.isEmpty(val)) return val;
		while (100000 > coIdx) {
			String code = "C-" + Common.lPad(coIdx++, 5, "0");
			boolean exist = coCdExist(code);
			if (!exist) {
				CoVO co = new CoVO();
				co.setCoCd(code);
				co.setCoNm(val);
				co.setIsAuto("Y");
				newCos.add(co);
				coMap.put(val, code);
				return code;
			}
		}
		return null;
	}

	public boolean coCdExist(String code) {
		Set<String> set = coMap.keySet();
		Iterator<String> iterator = set.iterator();
		while (iterator.hasNext()) {
			if (Common.isEquals(code, coMap.get(iterator.next()))) return true;
		}
		return false;
	}

	public String getNextGeneralCd(String val) {
		if (Common.isEmpty(val)) return val;
		while (1000000 > generalIdx) {
			String code = "G-" + Common.lPad(generalIdx++, 6, "0");
			boolean exist = generalCdExist(code);
			if (!exist) {
				GeneralVO vo = new GeneralVO();
				vo.setGeneralCd(code);
				vo.setGeneralNm(val.split("\\|")[1]);
				vo.setIsAuto("Y");
				newGeneral.add(vo);
				generalMap.put(val, code);
				return code;
			}
		}
		return null;
	}

	public boolean generalCdExist(String code) {
		Set<String> set = generalMap.keySet();
		Iterator<String> iterator = set.iterator();
		while (iterator.hasNext()) {
			if (Common.isEquals(code, generalMap.get(iterator.next()))) return true;
		}
		return false;
	}

	public String getNextBusiCd(String val) {
		if (Common.isEmpty(val)) return val;
		while (1000000 > busiIdx) {
			String code = "B-" + Common.lPad(busiIdx++, 6, "0");
			boolean exist = busiCdExist(code);
			if (!exist) {
				BusiVO vo = new BusiVO();
				vo.setBusiCd(code);
				vo.setBusiNm(val.split("\\|")[1]);
				vo.setIsAuto("Y");
				newBusi.add(vo);
				busiMap.put(val, code);
				return code;
			}
		}
		return null;
	}

	public boolean busiCdExist(String code) {
		Set<String> set = busiMap.keySet();
		Iterator<String> iterator = set.iterator();
		while (iterator.hasNext()) {
			if (Common.isEquals(code, busiMap.get(iterator.next()))) return true;
		}
		return false;
	}

	public String getNextDeptCd(String val) {
		if (Common.isEmpty(val)) return val;
		while (1000000 > deptIdx) {
			String code = "D-" + Common.lPad(deptIdx++, 6, "0");
			boolean exist = deptCdExist(code);
			if (!exist) {
				DeptVO vo = new DeptVO();
				vo.setDeptCd(code);
				vo.setDeptNm(val.split("\\|")[1]);
				vo.setIsAuto("Y");
				newDept.add(vo);
				deptMap.put(val, code);
				return code;
			}
		}
		return null;
	}

	public boolean deptCdExist(String code) {
		Set<String> set = deptMap.keySet();
		Iterator<String> iterator = set.iterator();
		while (iterator.hasNext()) {
			if (Common.isEquals(code, deptMap.get(iterator.next()))) return true;
		}
		return false;
	}

	public String getNextJikgubCd(String val) {
		if (Common.isEmpty(val)) return val;
		while (1000000 > jikgubIdx) {
			String code = "J-" + Common.lPad(jikgubIdx++, 6, "0");
			boolean exist = jikgubCdExist(code);
			if (!exist) {
				JikgubVO vo = new JikgubVO();
				vo.setJikgubCd(code);
				vo.setJikgubNm(val);
				vo.setIsAuto("Y");
				newJikgub.add(vo);
				jikgubMap.put(val, code);
				return code;
			}
		}
		return null;
	}

	public boolean jikgubCdExist(String code) {
		Set<String> set = jikgubMap.keySet();
		Iterator<String> iterator = set.iterator();
		while (iterator.hasNext()) {
			if (Common.isEquals(code, jikgubMap.get(iterator.next()))) return true;
		}
		return false;
	}

	public String getNextJikinCd(String val) {
		if (Common.isEmpty(val)) return val;
		while (1000000 > jikinIdx) {
			String code = "K-" + Common.lPad(jikinIdx++, 6, "0");
			boolean exist = jikinCdExist(code);
			if (!exist) {
				JikinVO vo = new JikinVO();
				vo.setJikinCd(code);
				vo.setJikinNm(val);
				vo.setIsAuto("Y");
				newJikin.add(vo);
				jikinMap.put(val, code);
				return code;
			}
		}
		return null;
	}

	public boolean jikinCdExist(String code) {
		Set<String> set = jikinMap.keySet();
		Iterator<String> iterator = set.iterator();
		while (iterator.hasNext()) {
			if (Common.isEquals(code, jikinMap.get(iterator.next()))) return true;
		}
		return false;
	}
	
	public boolean isIpValid(String ip) {
		InetAddressValidator ipchk = new InetAddressValidator();
		return ipchk.isValid(ip);
	}
	
	public boolean isEmailValid(String email) {
		EmailValidator emailchk = EmailValidator.getInstance();
		return emailchk.isValid(email);
	}
}
