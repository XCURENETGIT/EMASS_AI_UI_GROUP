package com.xcurenet.emass.service.service;

import java.util.List;

import net.sf.json.JSONObject;

public interface ServiceTypeService {

	public List<ServiceTypeVO> getSendMailServiceList();
	
	public List<ServiceTypeVO> getSendMailServiceListByOption();

	public List<ServiceTypeVO> getServiceList(final String groupCd, final String searchStr);

	public List<ServiceTypeVO> getServiceList(final String groupCd);

	public List<ServiceTypeVO> getServiceList();

	public List<ServiceTypeVO> getServiceListByAll(final String searchStr, final String searchUseYn);

	public List<ServiceTypeVO> getServiceListAuth(final String adminId);

	public List<ServiceTypeVO> getServiceListAuth(final JSONObject param);

	public List<ServiceTypeVO> getServiceConfList();
	
	public List<ServiceTypeVO> getServiceDeepList();
	
	public String getServiceName(String sercviceCd);

	public int updateServiceUseYn(ServiceTypeVO service);


	public List<ServiceTypeVO> getServiceListForHostPage(String adminId);

	public List<ServiceTypeVO> getAIService();
}
