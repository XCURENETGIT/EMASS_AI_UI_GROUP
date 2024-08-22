package com.xcurenet.emass.keyword.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.exception.XCNException;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.keyword.service.KeywordGroupVO;
import com.xcurenet.emass.keyword.service.KeywordService;
import com.xcurenet.emass.keyword.service.KeywordVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("keywordService")
@Slf4j
public class KeywordServiceImpl extends XcnAbstractDAO implements KeywordService {

	public static final String UTF8_BOM = "\uFEFF";

	@Override
	public List<KeywordVO> getKeywordList(String searchGroupSeq, String searchStr, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchGroupSeq", searchGroupSeq);
		param.put("searchStr", searchStr);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.keyword.getKeywordList", param);
	}

	@Override
	public List<KeywordVO> getKeywordAllList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.keyword.getKeywordAllList");
	}

	@Override
	public int insertKeyword(KeywordVO keyword) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.keyword.insertKeyword", keyword);
	}

	@Override
	public int updateKeyword(KeywordVO keyword) {
		return update("com.xcurenet.sqlmap.mappers.mysql.keyword.updateKeyword", keyword);
	}

	@Override
	public int deleteKeyword(List<KeywordVO> keywords) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (KeywordVO keyword : keywords) {
				delete("com.xcurenet.sqlmap.mappers.mysql.keyword.deleteKeyword", keyword);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public boolean isKeywordNameExist(KeywordVO keyword) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.keyword.isKeywordNameExist", keyword) > 0;
	}

	private static String removeUTF8BOM(String s) {
		if (s.startsWith(UTF8_BOM)) {
			s = s.substring(1);
		}
		return s;
	}

	@Override
	public JSONObject importKeyword(JSONArray keywordList) {

		JSONObject result = new JSONObject();
		Map<String, String> groupMap = keywordGroupMap();
		Map<String, String> keyMap = keywordMap();

		int errorIdx = 0;
		int insertCnt = 0;
		boolean duplicate = false;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (int i = 0; i < keywordList.size(); i++) {
				errorIdx = i + 1;

				JSONObject keywordItem = keywordList.getJSONObject(i);
				String groupName = removeUTF8BOM(Common.nvl(keywordItem.get("COL0")));
				String keywordName = Common.nvl(keywordItem.get("COL1"));
				String keywordDesc = Common.nvl(keywordItem.get("COL2"));
				if (Common.isEmpty(groupName) && Common.isEmpty(keywordName) && Common.isEmpty(keywordDesc)) continue;

				log.info("groupName:{}  keywordName:{}  keywordDesc:{}", groupName, keywordName, keywordDesc);

				if (Common.isEmpty(groupName) || Common.isEmpty(keywordName)) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("keyword.upload.must") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				} else if (groupName.length() > 60) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("keyword.upload.part.limit") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				} else if (keywordName.length() > 60) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("keyword.upload.keyword.limit") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				} else if (keywordDesc.length() > 1024) {
					throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("keyword.upload.desc.limit") + " " + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
				}

				KeywordVO keyword = new KeywordVO();
				keyword.setGroupName(groupName);
				keyword.setKeywordName(keywordName);
				keyword.setKeywordDesc(keywordDesc);

				if (isKeywordNameExist(keyword)) {
					duplicate = true;
					continue;
				}

				if (groupMap.get(groupName) != null) {
					keyword.setGroupSeq(groupMap.get(groupName));
				} else {
					KeywordGroupVO keywordGroup = selectOne("com.xcurenet.sqlmap.mappers.mysql.keyword.getNextKeywordGroupSeq");
					keywordGroup.setGroupName(groupName);
					keyword.setGroupSeq(keywordGroup.getGroupSeq());
					insert("com.xcurenet.sqlmap.mappers.mysql.keyword.insertKeywordGroupImport", keywordGroup);
					groupMap.put(groupName, keywordGroup.getGroupSeq());
				}

				if (keyMap.get(keyword.getGroupSeq() + "@@" + keywordName) == null) {
					insert("com.xcurenet.sqlmap.mappers.mysql.keyword.insertKeyword", keyword);
					keyMap.put(keyword.getGroupSeq() + "@@" + keyword.getKeywordName(), keyword.getKeywordName());

					insertCnt++;
				}
			}
			if (insertCnt == 0 && duplicate == false) {
				throw new XCNException(Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("keyword.upload.nocontent"));
			} if (insertCnt == 0 && duplicate == true) {
				throw new XCNException(Prop.propFormat("keyword.upload.duplicate"));
			}
			tx.commit();
			result.put("success", true);

		} catch (XCNException e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		} catch (Exception e) {
			log.warn("keyword import error:{}", e);
			result.put("success", false);
			result.put("message", Prop.propFormat("keyword.upload.error") + " <br />" + Prop.propFormat("keyword.upload.errline") + " : " + errorIdx);
		} finally {
			tx.end();
		}
		return result;
	}

	private Map<String, String> keywordGroupMap() {
		List<KeywordGroupVO> groupList = selectList("com.xcurenet.sqlmap.mappers.mysql.keyword.getKeywordGroupList", null);

		if (groupList == null) return new HashMap<>();
		Map<String, String> map = new HashMap<>();
		for (KeywordGroupVO group : groupList) {
			map.put(group.getGroupName(), group.getGroupSeq());
		}
		return map;
	}

	private Map<String, String> keywordMap() {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("exitUserYn", "Y");
		List<KeywordVO> keywordList = selectList("com.xcurenet.sqlmap.mappers.mysql.keyword.getKeywordAllList", param);

		if (keywordList == null) return new HashMap<>();
		Map<String, String> map = new HashMap<>();
		for (KeywordVO keyword : keywordList) {
			map.put(keyword.getGroupSeq() + "@@" + keyword.getKeywordName(), keyword.getKeywordName());
		}
		return map;
	}
}
