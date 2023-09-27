package com.xcurenet.code.service;

import java.util.List;


public interface AttachTypeService {

	public List<AttachTypeVO> getAttachType( );
	
	public List<AttachTypeVO> getAttachTypeList(final String searchStr);

	public int getAttachTypeListTotal(final String searchStr, final int offset, final int limit);

	public boolean isAttachTypeExist(AttachTypeVO attach);

	public int insertAttachType(AttachTypeVO attach);

	public int updateAttachType(AttachTypeVO attach);

	public int deleteAttachType(List<AttachTypeVO> attachs);
}
