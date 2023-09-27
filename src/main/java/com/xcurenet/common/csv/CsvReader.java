package com.xcurenet.common.csv;

import java.io.File;
import java.nio.charset.Charset;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.commons.io.IOUtils;

import com.xcurenet.common.util.Common;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class CsvReader {
	private String path;

	private String encoding;

	private char delimiter;

	public CsvReader(final String path, final String encoding, char field_separator) throws Exception {
		this.path = path;
		this.encoding = encoding;
		this.delimiter = field_separator;
	}

	public JSONArray getList() throws Exception {
		JSONArray result = new JSONArray();
		CSVParser parser = null;
		try {
			CSVFormat f = CSVFormat.newFormat(this.delimiter).withQuote(Character.valueOf('"')).withIgnoreEmptyLines(false).withAllowMissingColumnNames();

			parser = CSVParser.parse(new File(this.path), Charset.forName(this.encoding), f);
			for (final CSVRecord record : parser) {
				JSONObject item = new JSONObject();
				for (int i = 0; i < record.size(); i++) {
					item.put("COL" + i, Common.nvl(record.get(i)).trim());
				}
				result.add(item);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(parser);
		}
		return result;
	}
}
