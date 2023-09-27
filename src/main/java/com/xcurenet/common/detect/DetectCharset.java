package com.xcurenet.common.detect;

import java.io.File;
import java.io.InputStream;

import org.apache.commons.io.FileUtils;
import org.apache.tika.parser.txt.CharsetDetector;
import org.apache.tika.parser.txt.CharsetMatch;

import com.xcurenet.common.util.Common;

public class DetectCharset {

	private static final int MINIMUM_CONFIDENCE_RATE = 50;

	public static String getCharset(InputStream is) {
		return getCharset(is, MINIMUM_CONFIDENCE_RATE);
	}

	public static String getCharset(final String path) {
		String charset = getCharset(new File(path));
		if (charset != null) {
			return charset;
		}
		return Common.UTF8;
	}

	public static String getCharset(File file) {
		String charset = null;
		try {
			charset = getCharset(FileUtils.readFileToByteArray(file));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return charset;
	}

	public static String getCharset(InputStream is, int confidenceRate) {
		String charset = null;
		try {
			CharsetDetector detector = new CharsetDetector();
			detector.setText(is);
			CharsetMatch cm = detector.detect();
			if (cm != null) {
				int confidence = cm.getConfidence();
				if (confidence > confidenceRate) {
					charset = cm.getName();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return charset;
	}

	public static String getCharset(byte[] is) {
		return getCharset(is, MINIMUM_CONFIDENCE_RATE);
	}

	public static String getCharset(byte[] is, int confidenceRate) {
		if (is == null)
			return null;
		String charset = null;
		try {
			CharsetDetector detector = new CharsetDetector();
			detector.setText(is);
			CharsetMatch cm = detector.detect();
			if (cm != null) {
				int confidence = cm.getConfidence();
				if (confidence > confidenceRate) {
					charset = cm.getName();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return charset;
	}
}
