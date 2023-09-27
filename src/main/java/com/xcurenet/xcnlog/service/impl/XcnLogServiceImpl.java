package com.xcurenet.xcnlog.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.xcnlog.service.XcnLogService;
import com.xcurenet.xcnlog.service.XcnLogVO;

@Service("xcnLogService")
public class XcnLogServiceImpl extends XcnAbstractDAO implements XcnLogService {

	@Override
	public List<XcnLogVO> getXcnLogList(XcnLogVO xcnLog) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.xcnLog.getXcnLogList", xcnLog);

	}

}
