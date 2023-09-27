package com.xcurenet.code.service;

import java.util.List;

public interface DeptService {

	public List<DeptVO> getAllDeptList();

	public List<DeptVO> getDeptList(final String searchStr, final int offset, final int limit);

	public List<DeptVO> getDeptListByCo(final String coCd);

	public boolean isDeptNmExist(DeptVO dept);

	public boolean isDeptCdExist(DeptVO dept);

	public int insertDept(DeptVO dept);

	public int updateDept(DeptVO dept);

	public int deleteDept(DeptVO dept);

	public int deleteDeptCo(CoVO co);

}