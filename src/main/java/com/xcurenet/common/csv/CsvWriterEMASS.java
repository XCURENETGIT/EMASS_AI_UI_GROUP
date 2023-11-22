package com.xcurenet.common.csv;

import com.xcurenet.common.util.Common;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;
import org.apache.commons.io.IOUtils;

import java.io.*;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

@Slf4j
public class CsvWriterEMASS {
	private JSONArray header;

	private OutputStreamWriter writer;

	private Object[] headers;
	
	private CSVPrinter printer = null;

	public CsvWriterEMASS(final JSONArray header, final OutputStreamWriter outputStreamWriter) throws Exception {
		this.header = header;
		this.writer = outputStreamWriter;
		headers = new String[header.size()];
		for (int i = 0; i < header.size(); i++) {
			headers[i] = header.getJSONObject(i).getString("title");
		}
		write();
	}

	private void write() throws Exception {
		printer = new CSVPrinter(writer, CSVFormat.RFC4180);
		printer.printRecord(headers);
	}
	
	public void close() {
		IOUtils.closeQuietly(printer);
		IOUtils.closeQuietly(writer);
	}
	
//	public void appendData(List<SolrEdcVO> data, int offset) throws Exception {
//		int index = 1;
//		for (SolrEdcVO edc : data) {
//			List<String> record = new ArrayList<String>();
//			String key = "";
//			try {
//				for (int j = 0; j < header.size(); j++) {
//					JSONObject h = header.getJSONObject(j);
//					key = Common.nvl(h.get("key"));
//
//					Object val = null;
//					if (Common.isEquals(key, "NUM")) val = offset+(index++);
//					else if (Common.isEquals(key, "to")) {
//						if(edc.getTo()!=null) {
//							List<String> tos = edc.getTo();
//							val = getPrivateValue(edc, "toInOutInfo") + Common.join(tos, ", ");
//						}
//					} else if(Common.isEquals(key, "cc") ) {
//						if(edc.getCc()!=null) {
//							List<String> ccs = edc.getCc();
//							val = getPrivateValue(edc, "ccInOutInfo") + Common.join(ccs, ", ");
//						}
//					} else if(Common.isEquals(key, "bcc") ) {
//						if(edc.getBcc()!=null) {
//							List<String> bccs = edc.getBcc();
//							val = getPrivateValue(edc, "bccInOutInfo") + Common.join(bccs, ", ");
//						}
//					} else if(Common.isEquals(key, "recvs") ) {
//						if(edc.getRecvs()!=null) {
//							List<String> recvs = edc.getRecvs();
//							val = getPrivateValue(edc, "recvsInOutInfo") + Common.join(recvs, ", ");
//						}
//					}
//					else val = getPrivateValue(edc, key);
//
//					record.add(Common.nvl(val));
//				}
//				printer.printRecord(record);
//			} catch(Exception e) {
//				log.info("MsgId : {}, Data to long Field : {}", Common.nvl(edc.getMsgid()), Common.nvl(key));
//				throw new Exception(e);
//			}
//		}
//		printer.flush();
//	}
	
	@SuppressWarnings("unchecked")
	private Object getPrivateValue(Object clazz, String f) throws Exception {
		try {
			Field field = clazz.getClass().getDeclaredField(f);
			field.setAccessible(true);
			Object result = field.get(clazz);
			if(result.getClass().getName().indexOf("ArrayList") > -1) {
				return Common.joinObject((List<Object>) result, ", ");
			}else return result;
		} catch (Exception e) {
			return null;
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
