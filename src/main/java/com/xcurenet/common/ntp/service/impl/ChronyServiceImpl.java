package com.xcurenet.common.ntp.service.impl;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.ntp.service.ChronyService;
import com.xcurenet.common.ntp.service.ChronyVO;
import com.xcurenet.common.util.Common;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service("chronyService")
public class ChronyServiceImpl extends XcnAbstractDAO implements ChronyService {
	@Override
	public int insert(JSONObject ntpStatus) {
		deleteChrony(); //한달 지난 데이터 삭제
		ChronyVO chronyVO = new ChronyVO();
		String status = ntpStatus.getString("status");

		if (!ntpStatus.get("ntpServer").equals("") && (Common.isEquals(status, "sync") || Common.isEquals(status, "unsync"))) chronyVO.setNtpServer(ntpStatus.getString("ntpServer"));

		if (Common.isEquals(status, "sync") || Common.isEquals(status, "unsync")) chronyVO.setStatus(status);
		else chronyVO.setStatus("unconnect");

		return insert("com.xcurenet.sqlmap.mappers.mysql.emass.insertChrony", chronyVO);
	}

	public int deleteChrony(){
		return delete("com.xcurenet.sqlmap.mappers.mysql.emass.deleteChrony", null);
	}


	@Override
	public ChronyVO getChrony() {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.selectChrony");
	}
}
