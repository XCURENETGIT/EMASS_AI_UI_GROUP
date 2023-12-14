package com.xcurenet.device.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.device.service.DeviceService;
import com.xcurenet.device.service.DeviceVO;

@Service("deviceService")
public class DeviceServiceImpl extends XcnAbstractDAO implements DeviceService {

	@Override
	public List<DeviceVO> getDeviceList(String searchStr, final String deviceType, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("deviceType", deviceType);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.device.getDeviceList", param);
	}
	
	@Override
	public List<DeviceVO> getCollectionDevice(String searchStr) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
//		param.put("offset", offset);
//		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.device.getCollectionDevice", param);
	}

	@Override
	public List<DeviceVO> getCollectionDevice() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.device.getCollectionDevice");
	}

	@Override
	public DeviceVO getDeviceInfo(String deviceSeq) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("deviceSeq", deviceSeq);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.device.getDeviceInfo", param);
	}

	@Override
	public boolean isDeviceIpExist(DeviceVO device) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.device.isDeviceIpExist", device) > 0;
	}

	@Override
	public int insertDevice(DeviceVO device) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.device.insertDevice", device);
	}

	@Override
	public int updateDevice(DeviceVO device) {
		return update("com.xcurenet.sqlmap.mappers.mysql.device.updateDevice", device);
	}

	@Override
	public int deleteDevice(DeviceVO device) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.device.deleteDevice", device);
	}

	@Override
	public DeviceVO getDeviceByIp(String deviceIp) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.device.getDeviceByIp", deviceIp);
	}

	@Override
	public int updateDeviceHostKey(DeviceVO device) {
		return update("com.xcurenet.sqlmap.mappers.mysql.device.updateDeviceHostKey", device);
	}

	@Override
	public int updateDeviceRuTime(DeviceVO device) {
		return update("com.xcurenet.sqlmap.mappers.mysql.device.updateDeviceRuTime", device);
	}

	@Override
	public int updateDeviceRtTime(DeviceVO device) {
		return update("com.xcurenet.sqlmap.mappers.mysql.device.updateDeviceRtTime", device);
	}

	@Override
	public int updateDeviceRStatus(DeviceVO device) {
		return update("com.xcurenet.sqlmap.mappers.mysql.device.updateDeviceRStatus", device);
	}

	@Override
	public int updateDeviceMtTime(DeviceVO device) {
		return update("com.xcurenet.sqlmap.mappers.mysql.device.updateDeviceMtTime", device);
	}

	@Override
	public int updateDeviceMuTime(DeviceVO device) {
		return update("com.xcurenet.sqlmap.mappers.mysql.device.updateDeviceMuTime", device);
	}

	@Override
	public int updateDeviceMStatus(DeviceVO device) {
		return update("com.xcurenet.sqlmap.mappers.mysql.device.updateDeviceMStatus", device);
	}

}
