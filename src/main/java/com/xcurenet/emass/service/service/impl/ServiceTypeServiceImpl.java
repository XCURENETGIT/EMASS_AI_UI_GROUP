package com.xcurenet.emass.service.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.service.service.ServiceTypeService;
import com.xcurenet.emass.service.service.ServiceTypeVO;

import net.sf.json.JSONObject;

@Service("serviceTypeService")
public class ServiceTypeServiceImpl extends XcnAbstractDAO implements ServiceTypeService {

	@Override
	public List<ServiceTypeVO> getSendMailServiceList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.service.getSendMailServiceList");
	}
	
	@Override
	public List<ServiceTypeVO> getSendMailServiceListByOption() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.service.getSendMailServiceListByOption");
	}

	@Override
	public List<ServiceTypeVO> getServiceList(String groupCd, String searchStr) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupCd", groupCd);
		param.put("searchStr", searchStr);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.service.getServiceList", param);
	}

	@Override
	public List<ServiceTypeVO> getServiceList(String groupCd) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupCd", groupCd);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.service.getServiceList", param);
	}

	@Override
	public List<ServiceTypeVO> getServiceList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.service.getServiceList", new HashMap<String, Object>());
	}

	@Override
	public List<ServiceTypeVO> getServiceListByAll(String searchStr, String searchUseYn) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("searchUseYn", searchUseYn);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.service.getServiceListByAll", param);
	}

	@Override
	public List<ServiceTypeVO> getServiceListAuth(String adminId) {
		JSONObject param = new JSONObject();
		param.put("adminId", adminId);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.service.getServiceListAuth", param);
	}

	@Override
	public List<ServiceTypeVO> getServiceListAuth(JSONObject param) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.service.getServiceListAuth", param);
	}

	@Override
	public List<ServiceTypeVO> getServiceConfList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.service.getServiceConfList", new HashMap<String, Object>());
	}
	
	public List<ServiceTypeVO> getServiceDeepList(){
		return selectList("com.xcurenet.sqlmap.mappers.mysql.service.getServiceDeepList", new HashMap<String, Object>());
	}

	@Override
	public String getServiceName(String serviceCd) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.service.getServiceName", serviceCd);
	}

	@Override
	public int updateServiceUseYn(ServiceTypeVO service) {
		return update("com.xcurenet.sqlmap.mappers.mysql.service.updateServiceUseYn", service);
	}


}
