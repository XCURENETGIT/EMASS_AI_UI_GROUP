package com.xcurenet.owlnest.service;

import java.util.List;
import java.util.Map;

import lombok.Data;

@Data
public class OwlnestResultVO {
	private Map<String, ParaphraserMessageVO> paraphraserMessageVOData; //<msgId, data>
	private List<String> msgIds;
}