package com.xcurenet.common.detect;

import java.util.regex.Pattern;

public class DetectHtml {
	public final static String tagStart = "\\<\\w+((\\s+\\w+(\\s*\\=\\s*(?:\".*?\"|'.*?'|[^'\"\\>\\s]+))?)+\\s*|\\s*)\\>";
	public final static String tagEnd = "\\</\\w+\\>";
	public final static String tagSelfClosing = "\\<\\w+((\\s+\\w+(\\s*\\=\\s*(?:\".*?\"|'.*?'|[^'\"\\>\\s]+))?)+\\s*|\\s*)/\\>";
	public final static String htmlEntity = "&[a-zA-Z][a-zA-Z0-9]+;";
	public final static Pattern htmlPattern = Pattern.compile("(" + tagStart + ".*" + tagEnd + ")|(" + tagSelfClosing + ")|(" + htmlEntity + ")", Pattern.DOTALL);

	/**
	 * Will return true if s contains HTML markup tags or entities.
	 *
	 * @param s String to test
	 * @return true if string contains HTML
	 */
	public static boolean isHtml(String s) {
		try {
			if (s != null) {
				return htmlPattern.matcher(s).find();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
}
