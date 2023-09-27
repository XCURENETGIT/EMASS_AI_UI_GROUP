package com.xcurenet.code.service;

import java.util.List;

public interface GeneralService {

	public List<GeneralVO> getAllGeneralList();

	public List<GeneralVO> getGeneralList(final String searchStr, final int offset, final int limit);

	public List<GeneralVO> getGeneralListByCo(final String coCd);

	public boolean isGeneralNmExist(GeneralVO general);

	public boolean isGeneralCdExist(GeneralVO general);

	public int insertGeneral(GeneralVO general);

	public int updateGeneral(GeneralVO general);

	public int deleteGeneral(GeneralVO general);

	public int deleteGeneralCo(CoVO co);

}
