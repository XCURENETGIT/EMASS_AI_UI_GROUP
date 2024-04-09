package com.xcurenet.owlnest.service.impl;

import com.owlnest.test.paraphraserClient;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.owlnest.service.OwlnestResultVO;
import com.xcurenet.owlnest.service.OwlnestService;
import com.xcurenet.owlnest.service.ParaphraserMessageVO;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Service;

import java.util.*;


@Service("owlnestService")
@Slf4j
public class OwlnestServiceImpl extends XcnAbstractDAO implements OwlnestService {

	private String[] INEQUALITY_SIGN = {"+","-","|"};
	private static final String OR_PREFIX = " ";
	private static final String SPECIAL_CHAR = "*";


	@Override
	public OwlnestResultVO getParaphraserData(String msgId, String targetDate) {
		String output = getParaphraser(msgId, targetDate);

		if (Common.isEmpty(output)) return null;

		OwlnestResultVO result = new OwlnestResultVO();

		Map<String, ParaphraserMessageVO> paraphraserMessageVOData = new HashMap<String, ParaphraserMessageVO>();
		List<String> msgIds = new ArrayList<String>();

		JSONObject data = Common.toJSONObject(output);
		JSONArray list = data.getJSONArray("related_items");

		for(int i=0; i<list.size(); i++) {
			JSONObject obj = list.getJSONObject(i);

			ParaphraserMessageVO vo = new ParaphraserMessageVO();
			vo.setMsgId(Common.nvl(obj.get("msg_id")));
			vo.setTitle(Common.decodeUnicode(Common.nvl(obj.get("title"))));
			vo.setContent(Common.decodeUnicode(Common.nvl(obj.get("content"))));
			vo.setConfidence(Common.nvl(obj.get("confidence")));

			paraphraserMessageVOData.put(vo.getMsgId(), vo);
			msgIds.add(vo.getMsgId());
		}

		//81번 장비 대응 테스트용 소스
		/*for (int i = 0; i < 2; i++) {
			JSONObject obj = list.getJSONObject(i);
			
			if(i == 0) {
				ParaphraserMessageVO vo = new ParaphraserMessageVO();
				vo.setMsgId("20201105161236.KWN45E4BG6OZP6HEP3VZWK7UHV3GEF4L");
				vo.setTitle(Common.decodeUnicode(obj.getString("title")));
				vo.setContent(Common.decodeUnicode(obj.getString("content")));
				vo.setConfidence(obj.getString("confidence"));
				
				paraphraserMessageVOData.put(vo.getMsgId(), vo);
				msgIds.add(vo.getMsgId());
			} else if(i == 1) {
				ParaphraserMessageVO vo = new ParaphraserMessageVO();
				vo.setMsgId("20201105161326.HSQZ2YJSKBUWEJR37PBNJFZ3RSMQQ6A2");
				vo.setTitle(Common.decodeUnicode(obj.getString("title")));
				vo.setContent(Common.decodeUnicode(obj.getString("content")));
				vo.setConfidence(obj.getString("confidence"));
				
				paraphraserMessageVOData.put(vo.getMsgId(), vo);
				msgIds.add(vo.getMsgId());
			}
		}*/

		result.setMsgIds(msgIds);
		result.setParaphraserMessageVOData(paraphraserMessageVOData);
		log.info("[getparaphraserData] size : {}", Common.nvl(msgIds.size()));

		return result;
	}

	private String getParaphraser(String msgId, String targetDate) {
		String ip = Config.getString("owlnest.ip", "143.248.208.76");
		int port = Config.getInt("owlnest.port", 10005);

		String output = "";

		try {
			log.info("[owlnest] ip : {}, port : {}, msgId : {}, targetDate : {}", ip, port, msgId, targetDate);
			output = paraphraserClient.runParaphraser(ip, port, targetDate, msgId);
		} catch (Throwable e) {
			e.printStackTrace();
		}
		return output;
	}




	public String getSearchQuery(String query) {
		if( query.startsWith("|")) query = query.substring(1);

		query = specialCharsValid(query);
		query = getTempQuery(query);
		// 특수문자 처리
		query = specialCharsCheck(query);
		StringBuilder sb = new StringBuilder();
		if (!query.contains("|") && !query.contains("+") && !query.contains("-") & !query.contains(" ")) {
			StringBuilder queryStr = new StringBuilder();
			String[] terms = query.split(" ");
			for (String term : terms) {
				/*특수문자 처리*/
				queryStr.append(appendSpecialchar(term)).append(" ");
			}
			sb.append(queryStr.toString().trim().replaceAll(" ", " ").replaceAll("__", " "));
		} else {
			StringBuilder querySb = new StringBuilder();
			String[] terms = query.split(" ");
			for (int i = 0; i < terms.length; i++) {
				if (terms[i].equals("|")) {
					terms[i] = OR_PREFIX;
				}else {
					terms[i] = ("\"").concat(terms[i]).concat("\"");
				}

				querySb.append(appendSpecialchar(terms[i])).append(" ");
			}
			sb.append(querySb.toString().trim().replaceAll(" ", " ").replaceAll("__", " "));
		}

		String result = sb.toString().replace(OR_PREFIX, " ").replace("__", " ").replace("  ", " ").trim();

		// 연산자 처리
		result = inequalitySignProc(result);
		return result;
	}


	public String specialCharsValid(String str){
		String result = str;
		if(result.indexOf("/") > -1) {
			if(result.indexOf("/") == result.lastIndexOf("/")) result =  result.replace(result, ("\"").concat(result).concat( "\""));
		}
		result = result.replaceAll("([+])\\1+","+").replaceAll("([|])\\1+","|").replaceAll("(-)\\1+","-"); // 연속2개입력시

		return result;
	}

	public String specialCharsCheck(String str){
		String result = str;
		/* 특수문자 처리 */
		result  =  result.replaceAll("[[\\\\]=/&:><!^~*/[\"]\\[\\]\\(\\)\\{\\}]", "\\\\"+"$0");
		return result;
	}


	public String inequalitySignProc(String str) {
		String result = str;
		StringBuilder tempSb = new StringBuilder();
		tempSb.append(result);

		int idx = 0;
		char[] chars =  result.toCharArray();
		for(char c : chars) {
			if( Arrays.stream(INEQUALITY_SIGN).filter(s -> s.equals(String.valueOf(c))).count() > 0) {
				if(idx+1 == chars.length) {
					tempSb.setCharAt(idx,' ');
				}else {
					String cstr = String.valueOf(chars[idx+1]);
					if(String.valueOf(chars[idx+1]).equals(" ") ||  Arrays.stream(INEQUALITY_SIGN).filter(s -> s.equals(String.valueOf(cstr))).count() > 0) {
						tempSb.setCharAt(idx,' ');
					}
				}
			}
			idx++;
		}

		return tempSb.toString();
	}

	public String appendSpecialchar(String str) {
		if (Common.isEmpty(str.trim())) return str;
		else if (str.endsWith(SPECIAL_CHAR)) return str;
		else if (str.endsWith(OR_PREFIX)) return str;
		else if (str.endsWith("\"")) return str;
		else {
//			for (String item : SPECIALCHARS) {
//				if (str.contains(item)) {
//					str = str.replaceAll(item, "");
//				}
//			}
			return str;
		}
	}

	@Override
	public String getTempQuery(String query) {
		StringBuilder result = new StringBuilder();
		StringBuilder tmp = new StringBuilder();
		for (int i = 0; i < query.length(); i++) {
			char q = query.charAt(i);
			if (q == '|') {
				if (!Character.isWhitespace(query.charAt(i - 1))) {
					tmp.append(" ");
				}
				tmp.append(q).append(" ");
			} else {
				tmp.append(q);
			}
		}
		query = tmp.toString();
		query = query.replaceAll("( )+", " ");
		String[] terms = query.split(" ");
		for (int i = 0; i < terms.length; i++) {
			String t = terms[i].trim();
			result.append(" ").append(t);
			if (t.indexOf("\"") > -1 && !t.endsWith("\"")) {
				for (int j = i + 1; j < terms.length; j++) {
					String tx = terms[j].trim();
					result.append("__").append(terms[j].trim());
					i++;
					if (tx.endsWith("\"")) break;
				}
			}
		}
		return result.toString().trim();
	}
}
