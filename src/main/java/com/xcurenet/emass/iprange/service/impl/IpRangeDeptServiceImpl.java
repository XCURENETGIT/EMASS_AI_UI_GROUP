package com.xcurenet.emass.iprange.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xcurenet.code.service.CoVO;
import com.xcurenet.code.service.CodeVO;
import com.xcurenet.code.service.DeptService;
import com.xcurenet.code.service.DeptVO;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.exception.XCNException;
import com.xcurenet.common.types.IP;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.iprange.service.IpRangeDeptService;
import com.xcurenet.emass.iprange.service.IpRangeVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("ipRangeDeptService")
@Slf4j
public class IpRangeDeptServiceImpl extends XcnAbstractDAO implements IpRangeDeptService {
	public static final String UTF8_BOM = "\uFEFF";
	public int deptIdx = 1;
	
	@Autowired
	private DeptService deptService;
	
	@Override
	public List<IpRangeVO> getIpRangeDeptAllList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.iprange.getIpRangeDeptList");
	}
	
	@Override
	public List<IpRangeVO> getIpRangeDeptList(final String searchStr, final String ipSig, final int offset, final int limit) {
		Map<String, Object> param = new HashMap<>();
		param.put("searchStr", searchStr);
		param.put("ipSig", ipSig);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.iprange.getIpRangeDeptList", param);
	}
	
	@Override
	public String getDeptcdByAdminId(final String adminId) {
		Map<String, Object> param = new HashMap<>();
		param.put("adminId", adminId);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.iprange.getDeptcdByAdminId", param);
	}
	
	@Override
	public List<IpRangeVO> getIpRangeListByDeptcd(final String adminId, final String searchStr, final String ipSig, final String deptCd, final int offset, final int limit) {
		Map<String, Object> param = new HashMap<>();
		param.put("adminId", adminId);
		param.put("searchStr", searchStr);
		param.put("ipSig", ipSig);
		param.put("deptCd", deptCd);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.iprange.getIpRangeListByDeptcd", param);
	}
	
	
	@Override
	public boolean isDeptIpRangeDeptExist(IpRangeVO ipRange) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.iprange.isDeptIpRangeExist", ipRange) > 0;
	}

	@Override
	public int insertIpRangeDept(IpRangeVO ipRange) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.iprange.insertIpRangeDept", ipRange);
	}
	
	@Override
	public int updateIpRangeDept(IpRangeVO ipRange) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.iprange.updateIpRangeDept", ipRange);
	}

	@Override
	public int deleteIpRangeDept(List<IpRangeVO> ipRanges) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (IpRangeVO ipRange : ipRanges) {
				delete("com.xcurenet.sqlmap.mappers.mysql.iprange.deleteIpRangeDept", ipRange);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int deleteIpRangeDept(CoVO co) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.iprange.deleteIpRangeByCo", co);
	}

	@Override
	public int deleteIpRangeDept(DeptVO dept) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.iprange.deleteIpRangeBydept", dept);
	}

	@Override
	public JSONObject importIpRangeDept(JSONArray ipRangeList, final String adminId) {
		JSONObject result = new JSONObject();
		Map<String, String> ipMap = ipRangeMap();

		log.info(String.valueOf(ipRangeList));

		int errorIdx  = 0;
		int insertCnt = 0;
		boolean duplicate = false;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for(int i=0; i<ipRangeList.size(); i++) {
				errorIdx = i+1;

				JSONObject ipRangeItem = ipRangeList.getJSONObject(i);
				String coNm    = removeUTF8BOM(Common.nvl(ipRangeItem.get("COL0")));
				String pdeptNm  = removeUTF8BOM(Common.nvl(ipRangeItem.get("COL1")));
				String deptNm  = removeUTF8BOM(Common.nvl(ipRangeItem.get("COL2")));
				String startIp = Common.nvl(ipRangeItem.get("COL3"));
				String endIp   = Common.nvl(ipRangeItem.get("COL4"));
				String ipDesc  = Common.nvl(ipRangeItem.get("COL5"));

				IP startIpchk = new IP(startIp);
				IP endIpchk   = new IP(endIp);

				if(Common.isEmpty(coNm) && Common.isEmpty(deptNm) && Common.isEmpty(startIp) & Common.isEmpty(endIp) && Common.isEmpty(ipDesc)) {
					continue;
				}

				log.info("coNm: {}  pdeptNm: {}  deptNm: {}  startIp: {}  endIp: {}  ipDesc: {}", coNm, pdeptNm, deptNm, startIp, endIp,ipDesc);

				if(Common.isEmpty(coNm) || Common.isEmpty(deptNm) || Common.isEmpty(startIp) || Common.isEmpty(endIp)) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("deptIpRange.upload.must") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				}else if(coNm.length() > 20) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("ipRange.upload.coNm.limit") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				}else if(deptNm.length() > 64) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("deptIpRange.upload.deptNm.limit") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				}else if(!(startIpchk.isIPv4() || startIpchk.isIPv6())) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("ipRange.msg.sip.wrong") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				}else if(!(endIpchk.isIPv4() || endIpchk.isIPv6())) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("ipRange.msg.eip.wrong") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				}else if(ipDesc.length() > 500) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("ipRange.upload.desc.limit") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				}else if(startIpchk.toLong() > endIpchk.toLong()) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("ipRange.msg.enter.iprange") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				}

				IpRangeVO ipVo = new IpRangeVO();
				ipVo.setCoNm(coNm);
				ipVo.setPdeptNm(pdeptNm);
				ipVo.setDeptNm(deptNm);
				ipVo.setStartIp(startIp);
				ipVo.setEndIp(endIp);
				ipVo.setComment(ipDesc);
				ipVo.setCreateId(adminId);
				ipVo.setUpdateId(adminId);

				if(isDeptIpRangeDeptExist(ipVo)) {
					duplicate = true;
					log.info("[Upload Ip] Duplicate Data Line :{}", errorIdx);
					continue;
				}

				Map<String, String> param = new HashMap<>();
				param.put("codeName",  ipVo.getCoNm());
				List<CodeVO> coCode = selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeCoListAll", param);
				if(coCode.size() == 0) {
					log.info("This office name doesn't exsit or incorrect. errorLine - {}", errorIdx);
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("ipRange.upload.coNm.exist",errorIdx));
				}else {
					ipVo.setCoCd(coCode.get(0).getCode());
				}

				if(Common.isEmpty(ipVo.getPdeptNm())) { // 파일에 상위부서가 없는 경우 => 상위부서인 경우
					ipVo.setPdeptCd("");
				}else {
					// 상위 부서 존재 체크
					param.clear();
					param.put("codeName",  ipVo.getPdeptNm());
					List<CodeVO> pDeptCode = selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeDeptListAll", param);

					if(pDeptCode.size() == 0) {
						ipVo.setPdeptCd(getDeptCdTmp());
						//상위 부서 등록
						DeptVO pDeptVo = new DeptVO();
						pDeptVo.setDeptCd(ipVo.getPdeptCd());
						pDeptVo.setDeptNm(ipVo.getPdeptNm());
						pDeptVo.setCoCd(ipVo.getCoCd());
						deptService.insertDept(pDeptVo);
					}else {
						ipVo.setPdeptCd(pDeptCode.get(0).getCode());
					}
				}

				//부서 등록
				param.clear();
				param.put("codeName",  ipVo.getDeptNm());
				List<CodeVO> deptCode = selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeDeptListAll", param);

				if(deptCode.size() == 0) {
					ipVo.setDeptCd(getDeptCdTmp());
				}else {
					ipVo.setDeptCd(deptCode.get(0).getCode());
				}

				DeptVO deptVo = new DeptVO();
				deptVo.setPDeptCd(ipVo.getPdeptCd());
				deptVo.setPDeptNm(ipVo.getPdeptNm());
				deptVo.setDeptCd(ipVo.getDeptCd());
				deptVo.setDeptNm(ipVo.getDeptNm());
				deptVo.setCoCd(ipVo.getCoCd());
				deptService.insertDept(deptVo);

				if(ipMap.get(ipVo.getDeptCd() + "@@"+ipVo.getStartIp() + "@@" + ipVo.getEndIp()) == null) {
					insert("com.xcurenet.sqlmap.mappers.mysql.iprange.insertIpRangeDept", ipVo);
					ipMap.put(ipVo.getDeptCd() + "@@"+ipVo.getStartIp() + "@@" + ipVo.getEndIp(),ipVo.getStartIp() + "@@" + ipVo.getEndIp());

					insertCnt++;
				}
			}

			if(insertCnt == 0 && duplicate == false) {
				throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("keyword.upload.nocontent"));
			}else if(insertCnt ==0 && duplicate == true) {
				throw new XCNException(Prop.propFormat("keyword.upload.duplicate"));
			}

			tx.commit();
			result.put("success", true);
		}catch(XCNException e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}catch(Exception e) {
			log.warn("Dept IpRange Import Error {}",e);
			result.put("success", false);
			result.put("message", Prop.propFormat("keyword.upload.error") + " <br />" + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
		}finally {
			tx.end();
		}
		return result;
	}

	private String getDeptCdTmp() {
		String result = "";
		String deptCdTmp = "D-" + Common.lPad(deptIdx++, 6, "0");
		DeptVO vo = new DeptVO();
		vo.setDeptCd(deptCdTmp);
		if(deptService.isDeptCdExist(vo)) {
			result = getDeptCdTmp();
		}else {
			result = deptCdTmp;
		}
		return result;
	}

	@Override
	public Map<String, String> ipRangeMap(){
		List<IpRangeVO> ipList = selectList("com.xcurenet.sqlmap.mappers.mysql.iprange.getIpRangeList");

		if(ipList == null) {
			return new HashMap<>();
		}
		Map<String, String> map = new HashMap<>();
		for(IpRangeVO vo : ipList) {
			map.put(vo.getDeptCd()+ "@@" + vo.getStartIp()+ "@@" + vo.getEndIp(), vo.getStartIp()+ "@@" + vo.getEndIp());
		}
		return map;
	}

	private static String removeUTF8BOM(String s) {
		if (s.startsWith(UTF8_BOM)) {
			s = s.substring(1);
		}
		return s;
	}
}
