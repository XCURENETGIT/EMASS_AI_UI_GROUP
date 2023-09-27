package com.xcurenet.emass.iprange.service;

import java.util.List;
import java.util.Map;

import com.xcurenet.code.service.CoVO;
import com.xcurenet.code.service.DeptVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public interface IpRangeDeptService {

	public List<IpRangeVO> getIpRangeDeptAllList();
	
	public List<IpRangeVO> getIpRangeDeptList(final String searchStr, final String ipSig, final int offset, final int limit);
	
	public List<IpRangeVO> getIpRangeListByDeptcd(final String adminId, final String searchStr, final String ipSig, final String deptCd, final int offset, final int limit);
	
	public String getDeptcdByAdminId(String adminId);
	
	public boolean isDeptIpRangeDeptExist(final IpRangeVO ipRange);

	public int insertIpRangeDept(IpRangeVO ipRange);
	
	public int updateIpRangeDept(IpRangeVO ipRange);

	public int deleteIpRangeDept(List<IpRangeVO> ipRanges);
	
	public int deleteIpRangeDept(CoVO co);
	
	public int deleteIpRangeDept(DeptVO dept);

	public JSONObject importIpRangeDept(JSONArray ipRangeList);
	
	public Map<String, String> ipRangeMap();

}
