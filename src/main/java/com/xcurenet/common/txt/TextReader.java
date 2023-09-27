package com.xcurenet.common.txt;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

import org.apache.commons.io.IOUtils;

public class TextReader {
	public static final String NEW_LINE = "\r\n";

	public static final String UTF8_BOM = "\uFEFF";

	public String read(String filePath) throws Exception {
		if (filePath == null) {
			throw new Exception("TextReader Reader Error : file path is null");
		}

		BufferedReader br = null;
		StringBuffer _sb = new StringBuffer();
		try {
			File _file = this.getFile(filePath);
			br = new BufferedReader(new FileReader(_file));
			String line = null;
			while ((line = br.readLine()) != null) {
				_sb.append(line).append(NEW_LINE);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(br);
		}
		return removeUTF8BOM(_sb.toString());
	}

	private static String removeUTF8BOM(String s) {
		if (s.startsWith(UTF8_BOM)) {
			s = s.substring(1);
		}
		return s;
	}

	private File getFile(String path) {
		File file = null;
		try {
			file = new File(path);
			if (!file.isFile()) {
				throw new Exception("TextReader Reader Error : file is null  file path is : " + path);
			}
			if (!file.canRead()) {
				throw new Exception("TextReader Reader Error : file is can`t read path is : " + path);
			}
		} catch (Exception e) {
			e.getStackTrace();
		}
		return file;
	}

}
