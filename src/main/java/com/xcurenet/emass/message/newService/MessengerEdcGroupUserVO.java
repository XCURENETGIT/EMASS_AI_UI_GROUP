package com.xcurenet.emass.message.newService;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.xcurenet.emass.message.vo.emass.els.Emass;
import com.xcurenet.emass.message.vo.emass.els.EmassMessenger;
import com.xcurenet.emass.message.vo.emass.els.EmassMessengerUser;
import lombok.Data;
import lombok.ToString;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.search.SearchHit;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Data
@ToString
public class MessengerEdcGroupUserVO {

	//사용자 수
	private long numFoundUser;

	private List<EmassMessengerUser> groups;

	private List<?> emass;

	public MessengerEdcGroupUserVO(final SearchResponse searchResponse)  throws IOException{
		if(searchResponse == null) return;

		List<Emass> result = new ArrayList<>();

		/* response 파싱 */
		SearchHit[] hits = searchResponse.getHits().getHits();
		ObjectMapper mapper = new ObjectMapper();
		for (SearchHit hit : hits) {
			Map<String, Object> map = hit.getSourceAsMap();
			if (map.size() > 0) {
				map.put("msgid", hit.getId());
				result.add(mapper.convertValue(map, Emass.class));
			}
		}
		this.emass = result;

		this.groups = new ArrayList<>();
		this.numFoundUser = searchResponse.getHits().getTotalHits().value;


		if (result.size() > 1){
			for (Emass emass : result){
				this.groups.add(groupUser(emass));
			}
		}


	}

	public static EmassMessengerUser groupUser(Emass emass) {
		EmassMessengerUser emassMessenger = new EmassMessengerUser();

		//sender 이 존재 하였을때 -> usr.id 로 적재!??
		if (emass.getSender() != null){ // sender이 존재 하였을때
			emassMessenger.setSender(emass.getSender().getName());
		}

		// usr_id가 없을 경우 ip로 보여줌
		if (emass.getUsrIp() != null){
			emassMessenger.setUsrIp(emass.getUsrIp());
		}
		//인사 매핑
		if (emass.getUser() != null){
			emassMessenger.setCoNm(emass.getUser().getCoNm());
			emassMessenger.setDeptNm(emass.getUser().getDeptNm());
			emassMessenger.setJikgubNm(emass.getUser().getJikgubNm());
		}

		return emassMessenger;

	}

}
