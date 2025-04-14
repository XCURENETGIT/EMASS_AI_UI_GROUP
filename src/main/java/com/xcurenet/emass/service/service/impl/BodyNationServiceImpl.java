package com.xcurenet.emass.service.service.impl;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.service.service.BodyNationService;
import com.xcurenet.emass.service.service.BodyNationVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("bodyNationService")
public class BodyNationServiceImpl extends XcnAbstractDAO implements BodyNationService {
	@Override
	public List<BodyNationVO> getBodyNationList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.emass.getBodyNationList");
	}
}
