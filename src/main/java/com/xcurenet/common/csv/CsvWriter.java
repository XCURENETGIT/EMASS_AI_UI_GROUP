package com.xcurenet.common.csv;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;
import org.apache.commons.io.IOUtils;

import com.xcurenet.common.util.Common;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class CsvWriter {
	private JSONArray header;

	private JSONArray data;

	private OutputStreamWriter writer;

	private Object[] headers;

	public CsvWriter(final JSONArray header, final JSONArray data, final OutputStreamWriter outputStreamWriter) throws Exception {
		this.header = header;
		this.data = data;
		this.writer = outputStreamWriter;
		headers = new String[header.size()];
		for (int i = 0; i < header.size(); i++) {
			headers[i] = header.getJSONObject(i).getString("title");
		}
		write();
	}

	private void write() throws IOException {
		CSVPrinter printer = null;
		CSVFormat format = CSVFormat.RFC4180;
		try {
			printer = new CSVPrinter(writer, format);
			printer.printRecord(headers);
			for (int i = 0; i < data.size(); i++) {
				JSONObject item = data.getJSONObject(i);
				List<String> record = new ArrayList<String>();
				for (int j = 0; j < header.size(); j++) {
					String key = header.getJSONObject(j).getString("key");
					record.add(Common.nvl(item.get(key)));
				}
				printer.printRecord(record);
			}
		} finally {
			IOUtils.closeQuietly(writer);
			IOUtils.closeQuietly(printer);
		}
	}

	public static void main(String[] args) throws FileNotFoundException {
		Reader in = null;
		try {
			List<String[]> result = new ArrayList<String[]>();

			in = new InputStreamReader(new FileInputStream("C:\\Users\\jochangmin\\Downloads\\xcn_ip.txt"), "EUC-KR");
			final Iterable<CSVRecord> records = CSVFormat.newFormat('|').parse(in);
			for (final CSVRecord record : records) {
				String[] cols = new String[record.size()];
				for (int i = 0; i < record.size(); i++) {
					cols[i] = Common.nvl(record.get(i)).trim();
				}
				result.add(cols);
			}

			for (String[] cols : result) {
				for (String col : cols) {
					System.out.print(col + "\t");
				}
				System.out.println();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(in);
		}
	}
}
