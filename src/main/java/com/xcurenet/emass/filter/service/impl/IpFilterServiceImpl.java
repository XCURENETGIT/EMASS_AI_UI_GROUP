package com.xcurenet.emass.filter.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.snmp.get.GetSnmp;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.filter.service.IpFilterDeviceVO;
import com.xcurenet.emass.filter.service.IpFilterService;
import com.xcurenet.emass.filter.service.IpFilterVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("ipFilterService")
@Slf4j
public class IpFilterServiceImpl extends XcnAbstractDAO implements IpFilterService {

	@Autowired
	private GetSnmp snmp;
	
	private static final String SUCCESS = "success";

	@Override
	public List<IpFilterVO> getIpFilterList(String searchStr, String serverIp) {
		Map<String, Object> param = new HashMap<>();
		param.put("searchStr", searchStr);
		param.put("serverIp", serverIp);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.filter.getIpFilterList", param);
	}

	@Override
	public List<IpFilterDeviceVO> getIpFilterDevice(IpFilterVO filter) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.filter.getIpFilterDevice", filter);
	}

	@Override
	public boolean isIpExist(IpFilterVO filter) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.filter.isIpExist", filter) > 0;
	}

	@Override
	public int insertIpFilter(IpFilterVO filter) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.filter.insertIpFilter", filter);
	}

	@Override
	public int insertIpFilterDevice(IpFilterVO filter) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.filter.insertIpFilterDevice", filter);
	}

	@Override
	public int updateIpFilter(IpFilterVO filter) {
		return update("com.xcurenet.sqlmap.mappers.mysql.filter.updateIpFilter", filter);
	}

	@Override
	public int deleteIpFilterDevice(IpFilterVO filter) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.filter.deleteIpFilterDevice", filter);
	}

	@Override
	public int deleteIpFilter(List<IpFilterVO> filters) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (IpFilterVO filter : filters) {
				delete("com.xcurenet.sqlmap.mappers.mysql.filter.deleteIpFilterDevice", filter);
				delete("com.xcurenet.sqlmap.mappers.mysql.filter.deleteIpFilter", filter);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public IpFilterVO getNextIpNoLogSeq() {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.filter.getNextIpNoLogSeq");
	}

	@Override
	public JSONArray ruleApplyIpFilter(JSONArray data) {

		for (int i = 0; i < data.size(); i++) {
			JSONObject param = data.getJSONObject ( i );
			String deviceIp = Common.nvl(param.get("deviceIp"));
			String deviceNm = Common.nvl(param.get("deviceNm"));
			param.put(SUCCESS, true);
			List<IpFilterVO> list = selectList("com.xcurenet.sqlmap.mappers.mysql.filter.getIpFilterListByDeviceSeq", param );
			if (!snmp.deleteRule(deviceIp)) {
				log.error("룰 정보 초기화 도중 에러 발생 : 장비=" + deviceIp);

				param.put(SUCCESS, false);
			} else {
				Common.sleep(2000); //Rule Table이 지워질때까지 잠시 대기..
				for (int j = 0; j < list.size(); j++) {
					IpFilterVO ipFilter = list.get(j);
					if (!snmp.setFilter(String.valueOf(j), deviceIp, ipFilter)) {
						log.error("ERROR");
						param.put(SUCCESS, false);
						break;
					}
				}
			}
			if ( !snmp.applyDeviceRule( deviceIp ) ) {
				log.error("룰 적용 도중 에러 발생");
				param.put(SUCCESS, false);
				param.put("message", "<span style=\"color: #ff0000;\">" + deviceNm + "(" + deviceIp + ") => " + Prop.propFormat("java.error.rule.fail") + "</span>");
			} else {
				update("com.xcurenet.sqlmap.mappers.mysql.filter.updateDeviceRuleVersion", param); //룰 적용 후 mysql 테이블에 룰 버전 입력
				param.put("message", deviceNm + "(" + deviceIp + ") => " + Prop.propFormat("java.error.rule.success") );
			}
			data.set(i, param);
		}
		return data;
	}

	@Override
	public List<IpFilterVO> getSelectDeviceList(IpFilterVO filter) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.filter.getSelectDeviceList", filter);
	}
	
	@Override
	public List<IpFilterVO> ipCheckList(IpFilterVO filter) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.filter.getIpCheckList", filter);
	}

}
