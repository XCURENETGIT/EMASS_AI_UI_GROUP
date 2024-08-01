package com.xcurenet.common.ntp.service;

import net.sf.json.JSONObject;
import org.springframework.stereotype.Service;

@Service("chronyService")
public interface ChronyService{
	public int insert(JSONObject ntpStatus);

	public ChronyVO getChrony();
}
