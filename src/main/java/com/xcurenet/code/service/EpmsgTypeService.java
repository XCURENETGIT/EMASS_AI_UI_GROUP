package com.xcurenet.code.service;

import java.util.List;

public interface EpmsgTypeService {

	public List<EpmsgTypeVO> getEpmsgTypeList(final String searchStr, final String searchUseYn);

	public List<EpmsgTypeVO> getUsedEpmsgTypeList();

	public boolean isEpmsgTypeExist(EpmsgTypeVO epmsgType);

	public int insertEpmsgType(EpmsgTypeVO epmsgType);

	public int updateEpmsgType(EpmsgTypeVO epmsgType);

	public int deleteEpmsgType(List<EpmsgTypeVO> epmsgTypes);
}
