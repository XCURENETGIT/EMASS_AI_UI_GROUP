package com.xcurenet.emass.filter.service;

import java.util.List;

import net.sf.json.JSONArray;

public interface IpFilterService {

	public List<IpFilterVO> getIpFilterList(final String searchStr, final String serverIp);

	public List<IpFilterDeviceVO> getIpFilterDevice(IpFilterVO filter);

	public boolean isIpExist(IpFilterVO filter);

	public IpFilterVO getNextIpNoLogSeq();

	public int insertIpFilter(IpFilterVO filter);
	
	public int insertIpFilterDevice(IpFilterVO filter);
	
	public int updateIpFilter(IpFilterVO filter);
	
	public int deleteIpFilterDevice(IpFilterVO filter);

	public int deleteIpFilter(List<IpFilterVO> filters);
	
	public List<IpFilterVO> getSelectDeviceList(IpFilterVO filter);
	
	public JSONArray ruleApplyIpFilter(JSONArray data);
	
	public List<IpFilterVO> ipCheckList(IpFilterVO filter);
	
}
