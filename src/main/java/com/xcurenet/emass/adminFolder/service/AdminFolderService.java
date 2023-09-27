package com.xcurenet.emass.adminFolder.service;

import java.util.List;

import net.sf.json.JSONObject;

public interface AdminFolderService {

	public List<AdminFolderVO> getAdminFolderList(final String adminId, final String searchStr, final String contextPath);
	
	public List<AdminFolderVO> getAdminFolderListForExport(final JSONObject param);
	
	public int setAdminFolderListForImport(final List<AdminFolderVO> folderVos);

	public AdminFolderVO getAdminFolder(final long folderSeq);

	public long getNextAdminFolderId();

	public int insertAdminFolder(AdminFolderVO AdminFolder);

	public int updateAdminFolder(AdminFolderVO AdminFolder);

	public int updateFolderStatus(AdminFolderVO AdminFolder);

	public int deleteAdminFolder(final List<AdminFolderVO> folderVos);

	public int updateFolderOrder(final List<AdminFolderVO> folderVos);
	
	public int insertUserFolderMessage(final AdminFolderMessageVO list);
	
	public int getUserFolderMessageTotal(final AdminFolderMessageVO list);
	
	public List<AdminFolderMessageVO> getUserFolderMessage(final AdminFolderMessageVO list);
	
	public int deleteUserFolderMessage(final AdminFolderMessageVO list);
	
	public int updateUserFolderMessage(final AdminFolderMessageVO list);
	
	public List<AdminFolderMessageVO> getAdminFolderMessage(final AdminFolderMessageVO list);
}
