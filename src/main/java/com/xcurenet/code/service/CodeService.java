package com.xcurenet.code.service;

import java.util.List;

public interface CodeService {
	public List<CodeVO> getCodeList(final CodeVO code);
	
	public List<CodeVO> getCodeListAll(final CodeVO code);

	public List<CodeVO> getAdminCodeList(final CodeVO code);

}
