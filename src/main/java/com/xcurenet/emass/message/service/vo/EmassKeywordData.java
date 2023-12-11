package com.xcurenet.emass.message.service.vo;

import lombok.Data;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.HashSet;
import java.util.Set;

@Data
@ToString
public class EmassKeywordData {

	@Field("kwd")
	private String kwd;
	
	@Field("kwds")
	private Set<String> kwds = new HashSet<>();
	
	@Field("kwdsAttachNm")
	private Set<String> kwdsAttachNm = new HashSet<>();
	
	@Field("kwdsAttach")
	private Set<String> kwdsAttach = new HashSet<>();
	
	@Field("kwdsBody")
	private Set<String> kwdsBody = new HashSet<>();
	
	@Field("kwdsSubject")
	private Set<String> kwdsSubject = new HashSet<>();
}
