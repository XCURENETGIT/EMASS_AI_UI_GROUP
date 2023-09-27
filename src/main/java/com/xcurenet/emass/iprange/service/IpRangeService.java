package com.xcurenet.emass.iprange.service;

import java.util.List;

import com.xcurenet.code.service.BusiVO;
import com.xcurenet.code.service.CoVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public interface IpRangeService {

	public List<IpRangeVO> getIpRangeAllList();
	
	public List<IpRangeVO> getIpRangeList(final String searchStr, final String ipSig, final int offset, final int limit);
	
	public List<IpRangeVO> getIpRangeListByBusicd(final String adminId, final String searchStr, final String ipSig, final String busiCd, final int offset, final int limit);
	
	public String getBusicdByAdminId(String adminId);

	public boolean isBusiIpRangeExist(final IpRangeVO ipRange);

	public int insertIpRange(IpRangeVO ipRange);
	
	public int updateIpRange(IpRangeVO ipRange);

	public int deleteIpRange(List<IpRangeVO> ipRanges);
	
	public int deleteIpRange(CoVO co);
	
	public int deleteIpRange(BusiVO busi);

	public JSONObject importIpRange(JSONArray ipRangeList);

}
