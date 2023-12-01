package com.xcurenet.emass.message.service;

import com.xcurenet.emass.message.vo.emass.els.Emass;
import lombok.Data;
import org.elasticsearch.action.search.SearchResponse;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Data
public class MessengerEdcGroupListVO {

	//사용자 수
	private long numFoundUser;

	private List<Emass> groups;

	public MessengerEdcGroupListVO(final SearchResponse searchResponse){
		this.groups = new ArrayList<>();





	}

}
