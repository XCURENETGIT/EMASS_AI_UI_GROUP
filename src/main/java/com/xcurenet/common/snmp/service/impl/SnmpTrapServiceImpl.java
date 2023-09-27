package com.xcurenet.common.snmp.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.snmp.service.SnmpTrapService;
import com.xcurenet.common.snmp.service.SnmpTrapVO;

@Service("snmpTrapService")
public class SnmpTrapServiceImpl extends XcnAbstractDAO implements SnmpTrapService {

	private static final AtomicInteger SEQ = new AtomicInteger();

	private int getNextSeq() {
		SEQ.compareAndSet(0, 9999);
		return SEQ.getAndDecrement();
	}

	@Override
	public List<SnmpTrapVO> getSnmpTrapList(String startDt, String endDt, String deviceIp, String devision, String eventLevel, int offset, int limit) {
		Map<String, Object> params = new HashMap<>();
		params.put("startDt", startDt);
		params.put("endDt", endDt);
		params.put("deviceIp", deviceIp);
		params.put("devision", devision);
		params.put("eventLevel", eventLevel);
		params.put("offset", offset);
		params.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.snmpTrap.getSnmpTrapList", params);
	}

	@Override
	public int insertSnmpTrap(SnmpTrapVO trap) {
		trap.setSeq(getNextSeq());
		return insert("com.xcurenet.sqlmap.mappers.mysql.snmpTrap.insertSnmpTrap", trap);
	}
}
