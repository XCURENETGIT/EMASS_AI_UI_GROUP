package com.xcurenet.owlnest.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

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


@Service("owlnestService")
@Slf4j
public class OwlnestServiceImpl extends XcnAbstractDAO implements OwlnestService {

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
}
