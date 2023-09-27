package com.xcurenet.emass.adminFolder.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.adminFolder.service.AdminFolderMessageVO;
import com.xcurenet.emass.adminFolder.service.AdminFolderService;
import com.xcurenet.emass.adminFolder.service.AdminFolderVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;

@Slf4j
@Service("adminFolderService")
public class AdminFolderServiceImpl extends XcnAbstractDAO implements AdminFolderService {

	@Override
	public List<AdminFolderVO> getAdminFolderList(String adminId, String searchStr, String contextPath) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("adminId", adminId);
		param.put("searchStr", searchStr);
		param.put("contextPath", contextPath);
		param.put("headerName", Prop.propFormat("filterInfo.headerName"));
		
		return selectList("com.xcurenet.sqlmap.mappers.mysql.adminFolder.getAdminFolderList", param);
	}

	@Override
	public List<AdminFolderVO> getAdminFolderListForExport(JSONObject param) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.adminFolder.getAdminFolderListForExport", param);
	}

	@Override
	public int setAdminFolderListForImport(List<AdminFolderVO> folderVos) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		Map<Long, Long> ids = new HashMap<Long, Long>();
		try {
			tx.start();
			long nextId = getNextAdminFolderId();
			for (int i = 0; i < folderVos.size(); i++) {
				AdminFolderVO adminFolder = folderVos.get(i);
				long newId = nextId+i;
				long oldId = adminFolder.getId();
				long oldPId = adminFolder.getpId();
				ids.put(oldId, newId);
				
				long newPId = Common.isEmpty(ids.get(oldPId)) ? 1000 : ids.get(adminFolder.getpId());
				
				adminFolder.setId(newId);
				adminFolder.setpId(newPId);
				result = insert("com.xcurenet.sqlmap.mappers.mysql.adminFolder.insertAdminFolder", adminFolder);
			}
			
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}
	
	@Override
	public AdminFolderVO getAdminFolder(long folderSeq) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.adminFolder.getAdminFolder", folderSeq);
	}

	@Override
	public int insertAdminFolder(AdminFolderVO adminFolder) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			adminFolder.setId(getNextAdminFolderId());
			result = insert("com.xcurenet.sqlmap.mappers.mysql.adminFolder.insertAdminFolder", adminFolder);
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int updateAdminFolder(AdminFolderVO adminFolder) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			result = update("com.xcurenet.sqlmap.mappers.mysql.adminFolder.updateAdminFolder", adminFolder);
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int updateFolderStatus(AdminFolderVO AdminFolder) {
		return update("com.xcurenet.sqlmap.mappers.mysql.adminFolder.updateFolderStatus", AdminFolder);
	}

	@Override
	public int deleteAdminFolder(List<AdminFolderVO> folderVos) {
		int rs = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (AdminFolderVO adminFolder : folderVos) {
				//if (Common.isEquals(adminFolder.getFolderType(), "D")) {
					/*AdminFolderMessageVO params = new AdminFolderMessageVO();
					params.setFolderSeq(Common.nvl(adminFolder.getId()));
					AdminFolderMessageVO deleteData = selectOne("com.xcurenet.sqlmap.mappers.mysql.adminFolder.getFolderMessageIds", params);
					if (deleteData != null) {
						String msgId = deleteData.getMsgId();
						if (Common.isNotEmpty(msgId)) {
							String[] msgIds = msgId.split(",");
							log.info("DELETE FOLDER MESSAGE folderSeq : {}, size : {}", deleteData.getFolderSeq(), msgIds.length);
							solrCheckedService.removeSolrData(msgIds, "favorite_id", adminFolder.getAdminId() + "_" + deleteData.getFolderSeq());
							delete("com.xcurenet.sqlmap.mappers.mysql.adminFolder.deleteFolderMessageStatus", adminFolder);
						}
					}*/
				//}
				delete("com.xcurenet.sqlmap.mappers.mysql.adminFolder.deleteFolderMessageStatus", adminFolder);
				rs += delete("com.xcurenet.sqlmap.mappers.mysql.adminFolder.deleteFolderStatus", adminFolder);
			}
			tx.commit();
		}finally {
			tx.end();
		}
		return rs;
	}

	@Override
	public int updateFolderOrder(List<AdminFolderVO> folderVos) {
		int rs = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (AdminFolderVO folderVo : folderVos) {
				rs += update("com.xcurenet.sqlmap.mappers.mysql.adminFolder.updateFolderOrder", folderVo);
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return rs;
	}

	@Override
	public long getNextAdminFolderId() {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.adminFolder.getNextAdminFolderId");
	}
	
	@Override
	public int getUserFolderMessageTotal(AdminFolderMessageVO list) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.adminFolder.getFolderMessageTotal", list);
	}
	
	@Override
	public List<AdminFolderMessageVO> getUserFolderMessage(AdminFolderMessageVO list) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.adminFolder.getFolderMessage", list);
	}

	@Override
	public int insertUserFolderMessage(AdminFolderMessageVO list) {
		//String [] msgIds = list.getMsgIds();
		//solrCheckedService.addSolrData(msgIds, "favorite_id", list.getAdminId() + "_"+list.getFolderSeq());
		
		return insert("com.xcurenet.sqlmap.mappers.mysql.adminFolder.insertFolderMessage", list);
	}

	@Override
	public int deleteUserFolderMessage(AdminFolderMessageVO list) {
		//String [] msgIds = list.getMsgIds();
		//solrCheckedService.removeSolrData(msgIds, "favorite_id", list.getAdminId() + "_"+list.getFolderSeq());
		
		return insert("com.xcurenet.sqlmap.mappers.mysql.adminFolder.deleteFolderMessage", list);
	}
	
	@Override
	public int updateUserFolderMessage(AdminFolderMessageVO list) {
		//String [] msgIds = list.getMsgIds();
		//solrCheckedService.removeSolrData(msgIds, "favorite_id", list.getAdminId() + "_"+list.getFolderSeq());
		return insert("com.xcurenet.sqlmap.mappers.mysql.adminFolder.updateFolderMessage", list);
	}
	
	@Override
	public List<AdminFolderMessageVO> getAdminFolderMessage(AdminFolderMessageVO list) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.adminFolder.getAdminFolderMessage", list);
	}
}
