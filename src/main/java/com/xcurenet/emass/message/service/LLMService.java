package com.xcurenet.emass.message.service;


import net.sf.json.JSONObject;

import java.io.IOException;

public interface LLMService {

	HostDescriptionVO getHostDescription(String host);

	JSONObject getLLMAnalysis(final String chat, final String type) throws IOException;
}

