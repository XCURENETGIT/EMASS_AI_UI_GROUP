package com.xcurenet.emass.iprange.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.xcurenet.common.util.config.Config;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xcurenet.code.service.BusiService;
import com.xcurenet.code.service.BusiVO;
import com.xcurenet.code.service.CoVO;
import com.xcurenet.code.service.CodeVO;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.exception.XCNException;
import com.xcurenet.common.types.IP;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.iprange.service.IpRangeService;
import com.xcurenet.emass.iprange.service.IpRangeVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("ipRangeService")
@Slf4j
public class IpRangeServiceImpl extends XcnAbstractDAO implements IpRangeService {

	@Autowired
	private BusiService busiService;
	
	public static final String UTF8_BOM = "\uFEFF";
	public int busiIdx = 1;
	
	@Override
	public List<IpRangeVO> getIpRangeAllList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.iprange.getIpRangeList");
	}
	
	@Override
	public List<IpRangeVO> getIpRangeList(final String searchStr, final String ipSig, final int offset, final int limit) {
		Map<String, Object> param = new HashMap<>();
		param.put("searchStr", searchStr);
		param.put("ipSig", ipSig);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.iprange.getIpRangeList", param);
	}
	
	@Override
	public List<IpRangeVO> getIpRangeListByBusicd(final String adminId, final String searchStr, final String ipSig, final String busiCd, final int offset, final int limit) {
		Map<String, Object> param = new HashMap<>();
		param.put("adminId", adminId);
		param.put("searchStr", searchStr);
		param.put("ipSig", ipSig);
		param.put("busiCd", busiCd);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.iprange.getIpRangeListByBusicd", param);
	}
	
	@Override
	public String getBusicdByAdminId(final String adminId) {
		Map<String, Object> param = new HashMap<>();
		param.put("adminId", adminId);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.iprange.getBusicdByAdminId", param);
	}

	@Override
	public boolean isBusiIpRangeExist(IpRangeVO ipRange) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.iprange.isBusiIpRangeExist", ipRange) > 0;
	}

	@Override
	public int insertIpRange(IpRangeVO ipRange) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.iprange.insertIpRange", ipRange);
	}
	
	@Override
	public int updateIpRange(IpRangeVO ipRange) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.iprange.updateIpRange", ipRange);
	}

	@Override
	public int deleteIpRange(List<IpRangeVO> ipRanges) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (IpRangeVO ipRange : ipRanges) {
				delete("com.xcurenet.sqlmap.mappers.mysql.iprange.deleteIpRange", ipRange);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int deleteIpRange(CoVO co) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.iprange.deleteIpRangeByCo", co);
	}

	@Override
	public int deleteIpRange(BusiVO busi) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.iprange.deleteIpRangeByBusi", busi);
	}

	@Override
	public JSONObject importIpRange(JSONArray ipRangeList, final String adminId) {
		JSONObject result = new JSONObject();
		Map<String, String> ipMap = ipRangeMap();

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
				String busiNm  = removeUTF8BOM(Common.nvl(ipRangeItem.get("COL1")));
				String startIp = Common.nvl(ipRangeItem.get("COL2"));
				String endIp   = Common.nvl(ipRangeItem.get("COL3"));
				String country   = Common.nvl(ipRangeItem.get("COL4"));
				String ipDesc  = Common.nvl(ipRangeItem.get("COL5"));

				IP startIpchk = new IP(startIp);
				IP endIpchk   = new IP(endIp);

				if(Common.isEmpty(coNm) && Common.isEmpty(busiNm) && Common.isEmpty(startIp) & Common.isEmpty(endIp) && Common.isEmpty(ipDesc)) {
					continue;
				}

				log.info("coNm : {} busiNm:{}  startIp:{}  endIp:{} country:{} ipDesc: {}", coNm, busiNm, startIp, endIp, country, ipDesc);

				if(Common.isEmpty(coNm) || Common.isEmpty(busiNm) || Common.isEmpty(startIp) || Common.isEmpty(endIp) || Common.isEmpty(country)) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("ipRange.upload.must") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				}else if(coNm.length() > 20) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("ipRange.upload.coNm.limit") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				}else if(busiNm.length() > 64) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("ipRange.upload.busiNm.limit") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
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
				ipVo.setBusiNm(busiNm);
				ipVo.setStartIp(startIp);
				ipVo.setEndIp(endIp);
				ipVo.setComment(ipDesc);
				ipVo.setCreateId(adminId);
				ipVo.setUpdateId(adminId);

				if(isBusiIpRangeExist(ipVo)) {
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

				if (Config.getNationCd(country) != null ) ipVo.setCountry(Config.getNationCd(country));
				else ipVo.setCountry("KR");

				param.clear();
				param.put("codeName",  ipVo.getBusiNm());

				List<CodeVO> code = selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeBusiListAll", param);
				if(code.size() == 0) {
					//사업장 등록
					ipVo.setBusiCd(getBusiCdTmp());
					BusiVO vo = new BusiVO();
					vo.setBusiCd(ipVo.getBusiCd());
					vo.setBusiNm(ipVo.getBusiNm());
					vo.setCoCd(ipVo.getCoCd());
					busiService.insertBusi(vo);

				}else {
					ipVo.setBusiCd(code.get(0).getCode());
				}

				if(ipMap.get(ipVo.getBusiCd() + "@@"+ipVo.getStartIp() + "@@" + ipVo.getEndIp()) == null) {
					insert("com.xcurenet.sqlmap.mappers.mysql.iprange.insertIpRange", ipVo);
					ipMap.put(ipVo.getBusiCd() + "@@"+ipVo.getStartIp() + "@@" + ipVo.getEndIp(),ipVo.getStartIp() + "@@" + ipVo.getEndIp());

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
			log.warn("ipRange import error {}",e);
			result.put("success", false);
			result.put("message", Prop.propFormat("keyword.upload.error") + " <br />" + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
		}finally {
			tx.end();
		}
		return result;
	}

	private String getBusiCdTmp() {
		String result = "";
		String busiCdTmp = "B-" + Common.lPad(busiIdx++, 6, "0");
		BusiVO vo = new BusiVO();
		vo.setBusiCd(busiCdTmp);
		if(busiService.isBusiCdExist(vo)) {
			result = getBusiCdTmp();
		}else {
			result = busiCdTmp;
		}
		return result;
	}

	private Map<String, String> ipRangeMap(){
		List<IpRangeVO> ipList = selectList("com.xcurenet.sqlmap.mappers.mysql.iprange.getIpRangeList");

		if(ipList == null) {
			return new HashMap<>();
		}
		Map<String, String> map = new HashMap<>();
		for(IpRangeVO vo : ipList) {
			map.put(vo.getBusiCd() + "@@" + vo.getStartIp()+ "@@" + vo.getEndIp(), vo.getStartIp()+ "@@" + vo.getEndIp());
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
