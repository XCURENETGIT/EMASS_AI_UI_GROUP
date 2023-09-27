package com.xcurenet.common.snmp.service;

import java.util.List;

public interface SnmpTrapService {

	public List<SnmpTrapVO> getSnmpTrapList(final String startDt, final String endDt, final String deviceIp, final String devision, final String eventLevel, final int offset, final int limit);

	public int insertSnmpTrap(SnmpTrapVO trap);
}
