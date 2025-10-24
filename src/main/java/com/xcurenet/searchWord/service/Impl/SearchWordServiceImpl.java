package com.xcurenet.searchWord.service.Impl;


import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.searchWord.service.SearchWordService;
import com.xcurenet.searchWord.service.SearchWordVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.*;

@Slf4j
@Service("searchWordService")
public class SearchWordServiceImpl extends XcnAbstractDAO implements SearchWordService {
	@Override
	public List<SearchWordVO> getSearchWord(int offset, int limit, String searchStr) {
		Map<String, Object> param = new HashMap();
		param.put("limit", limit);
		param.put("offset", offset);
		param.put("searchStr", searchStr);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.searchWord.getSearchWordList", param);
	}

	@Override
	public int insertSearchWord(SearchWordVO searchWordVO) {
		insert("com.xcurenet.sqlmap.mappers.mysql.searchWord.insertSearchWord", searchWordVO);
		searchWordVO.setKeywordId(findSearchWordNum(searchWordVO));

		// 기존 : 한 row에 배열로 저장 -> relationWord를 개별 row로 저장
		String relationWord = searchWordVO.getRelationWord();
		if (relationWord != null && !relationWord.isEmpty()) {
			String[] keywords = relationWord.split(",");
			int keywordId = searchWordVO.getKeywordId();

			// 기존 연관키워드 조회
			List<String> existingRelwords = selectList("com.xcurenet.sqlmap.mappers.mysql.searchWord.getKeywordRelListByRelId", keywordId);
			Set<String> existingSet = new HashSet<>(existingRelwords);

			int insertedCount = 0;
			for (String keyword : keywords) {
				String trimmedKeyword = keyword.trim();

				if (!existingSet.contains(trimmedKeyword)) {
					SearchWordVO relVO = new SearchWordVO();
					relVO.setKeywordId(searchWordVO.getKeywordId());
					relVO.setRelationWord(trimmedKeyword);
					relVO.setSearchWordRelaNumber(searchWordVO.getSearchWordRelaNumber());
					insert("com.xcurenet.sqlmap.mappers.mysql.searchWord.insertSearchRelWord", relVO);
					insertedCount++;
				} else {
					log.debug("[insertSearchWord] duplicate skipped: KEYWORD_ID={}, KEYWORD_REL={}",
							keywordId, trimmedKeyword);
				}
			}
			return insertedCount;
		}
		return 0;
	}

	@Override
	public boolean isSearchWord(SearchWordVO searchWordVO) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.searchWord.isSearchWordExist", searchWordVO) > 0;
	}

	@Override
	public int insertRelSearchWord(SearchWordVO searchWordVO) {
		searchWordVO.setKeywordId(findSearchWordNum(searchWordVO));
		int keywordId = searchWordVO.getKeywordId();

		String relationWord = searchWordVO.getRelationWord();
		if (relationWord != null && !relationWord.isEmpty()) {
			String[] keywords = relationWord.split(",");

			// 기존 연관키워드 조회
			List<String> existingRelwords = selectList("com.xcurenet.sqlmap.mappers.mysql.searchWord.getKeywordRelListByRelId", keywordId);
			Set<String> existingSet = new HashSet<>(existingRelwords);

			int insertedCount = 0;
			for (String keyword : keywords) {
				String trimmedKeyword = keyword.trim();

				if (!existingSet.contains(trimmedKeyword)) {
					SearchWordVO relVO = new SearchWordVO();
					relVO.setKeywordId(keywordId);
					relVO.setRelationWord(trimmedKeyword);
					relVO.setSearchWordRelaNumber(searchWordVO.getSearchWordRelaNumber());
					insert("com.xcurenet.sqlmap.mappers.mysql.searchWord.insertSearchRelWord", relVO);
					insertedCount++;
				} else {
					log.debug("[insertRelSearchWord] duplicate skipped: KEYWORD_ID={}, KEYWORD_REL={}",
							keywordId, trimmedKeyword);
				}
			}
			return insertedCount;
		}
		return 0;
	}

	@Override
	public int tableIsExist() {
		int one = (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.searchWord.tableIsExist1");
		int two = (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.searchWord.tableIsExist2");
		return one + two;
	}

	@Override
	public int tableNum() {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.searchWord.tableNum");
	}

	public int findSearchWordNum(SearchWordVO searchWordVO) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.searchWord.getSearchWordNum", searchWordVO);
	}

	@Override
	public int deleteSearchWord(List<SearchWordVO> searchWords) {
		int result = 0;
		for (SearchWordVO searchWordVO : searchWords) {
			// 연관키워드 먼저 삭제
			int deletedRelCount = delete("com.xcurenet.sqlmap.mappers.mysql.searchWord.deleteSearchReNum", searchWordVO);
			// 키워드 삭제
			int deletedKeywordCount = delete("com.xcurenet.sqlmap.mappers.mysql.searchWord.deleteSearchWord", searchWordVO);
		}
		return result;
	}

	@Override
	public int updateSearchWord(SearchWordVO searchWordVO) {
		return update("com.xcurenet.sqlmap.mappers.mysql.searchWord.updateSearchWord", searchWordVO);
	}

	@Override
	public int deleteSearchRelWord(List<SearchWordVO> searchWords, int keywordId) {
		int result = 0;
		for (SearchWordVO searchWordVO : searchWords) {
			// NUM 필드에서 가져옴 (1-based index = 화면 순서)
			int relationNum = searchWordVO.getNUM();

			// 개별 row 또는 콤마 구분 방식 확인
			List<String> keywordList = selectList("com.xcurenet.sqlmap.mappers.mysql.searchWord.getKeywordRelListByRelId", keywordId);

			if (keywordList != null && keywordList.size() > 1) {
				// 1. 개별 row 저장 - 신규 등록 데이터
				int indexToRemove = relationNum - 1;  // 1-based → 0-based

				if (indexToRemove >= 0 && indexToRemove < keywordList.size()) {
					String keywordToDelete = keywordList.get(indexToRemove);
					Map<String, Object> deleteMap = new HashMap<>();
					deleteMap.put("keywordId", keywordId);
					deleteMap.put("keyword", keywordToDelete);
					delete("com.xcurenet.sqlmap.mappers.mysql.searchWord.deleteSearchRelByKeyword", deleteMap);
					result++;
				}
			} else {
				// 2. 콤마로 구분된 데이터 - 기존 등록 데이터
				String currentKeywordRel = selectOne("com.xcurenet.sqlmap.mappers.mysql.searchWord.getKeywordRelValue", keywordId);

				if (currentKeywordRel != null && !currentKeywordRel.isEmpty() && currentKeywordRel.contains(",")) {
					String[] values = currentKeywordRel.split(",");
					int indexToRemove = relationNum - 1;

					if (indexToRemove >= 0 && indexToRemove < values.length) {
						// 삭제할 값을 제외하고 새로운 문자열 생성
						StringBuilder newKeywordRel = new StringBuilder();
						for (int i = 0; i < values.length; i++) {
							if (i != indexToRemove) {
								if (newKeywordRel.length() > 0) {
									newKeywordRel.append(",");
								}
								newKeywordRel.append(values[i].trim());
							}
						}

						// DB 업데이트
						Map<String, Object> updateMap = new HashMap<>();
						updateMap.put("keywordId", keywordId);
						updateMap.put("newKeywordRel", newKeywordRel.toString());
						update("com.xcurenet.sqlmap.mappers.mysql.searchWord.updateKeywordRelValue", updateMap);
						result++;
					}
				}
			}
		}
		return result;
	}

	/**
	 * 키워드 ID 맵 생성
	 */
	private Map<String, Integer> getKeywordIdMap(List<SearchWordVO> keywords) {
		if (keywords.isEmpty()) {
			return new HashMap<>();
		}

		Map<String, Integer> idMap = new HashMap<>();
		List<Map<String, Object>> idList = selectList(
				"com.xcurenet.sqlmap.mappers.mysql.searchWord.getSearchWordIds", keywords);

		for (Map<String, Object> item : idList) {
			String keyword = (String) item.get("searchWord");
			Integer keywordId = (Integer) item.get("keywordId");
			idMap.put(keyword, keywordId);
		}

		return idMap;
	}

	/**
	 * 기존 연관키워드 조회 (중복 체크)
	 */
	private Set<String> getExistingRelationWords(Collection<Integer> keywordIds) {
		if (keywordIds.isEmpty()) {
			return new HashSet<>();
		}

		Set<String> existingSet = new HashSet<>();
		Map<String, Object> params = new HashMap<>();
		params.put("keywordIds", new ArrayList<>(keywordIds));

		List<Map<String, Object>> existingList = selectList(
				"com.xcurenet.sqlmap.mappers.mysql.searchWord.getExistingRelWords", params);

		for (Map<String, Object> item : existingList) {
			Integer keywordId = (Integer) item.get("keywordId");
			String keywordRel = (String) item.get("keywordRel");
			existingSet.add(keywordId + "|" + keywordRel);
		}

		return existingSet;
	}

	@Override
	public Map<String, Object> importSearchWordBatch(List<String> dataLines) {
		Map<String, Object> result = new HashMap<>();

		int successCount = 0;
		int errorCount = 0;

		try {

			//키워드 파싱
			List<SearchWordVO> allKeywords = new ArrayList<>();
			List<SearchWordVO> relationWords = new ArrayList<>();

			for (int i = 0; i < dataLines.size(); i++) {
				String line = dataLines.get(i).trim();
				if (line.isEmpty()) continue;

				try {
					String[] parts = line.split("\\|");
					if (parts.length != 3) {
						errorCount++;
						continue;
					}

					String keyword = parts[0].trim();
					String relationWordsStr = parts[1].trim();
					String weightStr = parts[2].trim();

					if (keyword.isEmpty()) {
						errorCount++;
						continue;
					}

					float weight;
					try {
						weight = Float.parseFloat(weightStr);
						if (weight >= 1.0f) {
							errorCount++;
							continue;
						}
					} catch (NumberFormatException e) {
						errorCount++;
						continue;
					}

					SearchWordVO keywordVO = new SearchWordVO();
					keywordVO.setSearchWord(keyword);
					allKeywords.add(keywordVO);

					// 연관키워드 처리
					if (!relationWordsStr.isEmpty()) {
						String[] relWords = relationWordsStr.split(",");
						for (String relWord : relWords) {
							relWord = relWord.trim();
							if (!relWord.isEmpty()) {
								SearchWordVO relVO = new SearchWordVO();
								relVO.setSearchWord(keyword);  // 부모 키워드
								relVO.setRelationWord(relWord);
								relVO.setSearchWordRelaNumber(weight);
								relationWords.add(relVO);
							}
						}
					}

				} catch (Exception e) {
					errorCount++;
					log.error("[Keyword Batch] line {} failed: {}", i + 1, line, e);
				}
			}

			log.info("[Keyword Batch] parsed - keyword: {}, relKeyword: {}, failed: {}",
					allKeywords.size(), relationWords.size(), errorCount);

			// 키워드 중복 체크 및 신규 키워드 분리
			List<SearchWordVO> newKeywords = new ArrayList<>();
			List<SearchWordVO> existingKeywords = new ArrayList<>();

			for (SearchWordVO vo : allKeywords) {
				if (isSearchWord(vo)) {
					existingKeywords.add(vo);
				} else {
					newKeywords.add(vo);
				}
			}

			log.info("[Keyword Batch] keyword - new: {}, duplicate: {}", newKeywords.size(), existingKeywords.size());

			// 신규 키워드 추가
			if (!newKeywords.isEmpty()) {
				insert("com.xcurenet.sqlmap.mappers.mysql.searchWord.insertSearchWordBatch", newKeywords);
				log.info("[Keyword Batch] new keyword {} added", newKeywords.size());
			}

			// 모든 키워드의 ID 조회
			List<SearchWordVO> allKeywordsForId = new ArrayList<>();
			allKeywordsForId.addAll(newKeywords);
			allKeywordsForId.addAll(existingKeywords);

			Map<String, Integer> keywordIdMap = getKeywordIdMap(allKeywordsForId);

			// 연관키워드에 KEYWORD_ID 설정
			for (SearchWordVO relVO : relationWords) {
				Integer keywordId = keywordIdMap.get(relVO.getSearchWord());
				if (keywordId != null) {
					relVO.setKeywordId(keywordId);
				} else {
					log.warn("[Keyword Batch] can't find keyword Id: {}", relVO.getSearchWord());
					errorCount++;
				}
			}

			// 기존 연관키워드 조회
			Set<String> existingRelSet = getExistingRelationWords(keywordIdMap.values());

			// 중복 아닌 것만 필터링
			List<SearchWordVO> newRelWords = new ArrayList<>();
			int duplicateCount = 0;

			for (SearchWordVO relVO : relationWords) {
				if (relVO.getKeywordId() == 0) {
					continue;
				}

				String key = relVO.getKeywordId() + "|" + relVO.getRelationWord();
				if (!existingRelSet.contains(key)) {
					newRelWords.add(relVO);
				} else {
					duplicateCount++;
					log.debug("[Keyword Batch] duplicated keyword skipped: {} - {}", relVO.getKeywordId(), relVO.getRelationWord());
				}
			}

			// 중복 아닌 연관키워드만 배치 등록
			if (!newRelWords.isEmpty()) {
				insert("com.xcurenet.sqlmap.mappers.mysql.searchWord.insertSearchRelWordBatch", newRelWords);
				log.info("[Keyword Batch] relkeyword {} added ({} duplicate skipped)", newRelWords.size(), duplicateCount);
			}

			successCount = newKeywords.size() + newRelWords.size();
			result.put("success", true);
			result.put("message", "WordBatch completed");
			result.put("totalLines", dataLines.size());
			result.put("successCount", successCount);
			result.put("errorCount", errorCount);
			result.put("newKeywords", newKeywords.size());
			result.put("newRelationWords", newRelWords.size());
			result.put("duplicateRelationWords", duplicateCount);

		} catch (Exception e) {
			log.error("[Keyword Batch] failed", e);
			result.put("success", false);
			result.put("errorCount", errorCount);
		}

		return result;
	}

}