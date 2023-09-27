package com.xcurenet.emass.customDashboard.service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

@Component
public class CustomDashboardScheduler {

	@Resource(name = "customDashBoardService")
	private CustomDashBoardService customDashboardService;

	public static Map<String, String> shellCmd(String command) throws Exception {
		Runtime runtime = Runtime.getRuntime();
		Process process = runtime.exec(command);
		InputStream is = process.getInputStream();
		InputStreamReader isr = new InputStreamReader(is);
		BufferedReader br = new BufferedReader(isr);

		String line;
		Map<String, String> map = new HashMap<>();
		while ((line = br.readLine()) != null) {
			if (line.contains("Under replicated blocks")) break;
			if (line.contains("Present Capacity")) map.put("preCap", getValue(line));
			else if (line.contains("DFS Remaining")) map.put("dfsRemain", getValue(line));
			else if (line.contains("DFS Used") && !line.contains("%")) map.put("dfsUsed", getValue(line));
			else if (line.contains("DFS Used%")) map.put("dfsUsedP", getValue(line));
		}
		return map;
	}

	private static String getValue(String str) {
		String tmp = str.replaceAll(" ", "");
		if (tmp.contains("%")) tmp = tmp.substring(tmp.indexOf(":") + 1, tmp.lastIndexOf("%"));
		else tmp = tmp.substring(tmp.indexOf(":") + 1, tmp.indexOf("("));
		return tmp;
	}
}
