package com.xcurenet.owlnest.service;

public interface OwlnestService {

	public OwlnestResultVO getParaphraserData(final String msgId, final String targetDate);

	public String getSearchQuery(String query);

	public String specialCharsValid(String str);

	public String specialCharsCheck(String str);

	public String inequalitySignProc(String str);

	public String appendSpecialchar(String str);

	public String getTempQuery(String query);

}


