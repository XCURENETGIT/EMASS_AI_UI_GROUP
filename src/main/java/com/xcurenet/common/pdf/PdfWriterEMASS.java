package com.xcurenet.common.pdf;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.util.List;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.xcurenet.common.csv.CsvWriterEMASS;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.message.service.SolrEdcVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;

@Slf4j
public class PdfWriterEMASS {

	private String title;

	private JSONArray header;

	private Document doc;

	private OutputStream out;

	private PdfPTable table;

	private BaseFont baseFont = BaseFont.createFont(this.getClass().getResource("").getPath() + "../../files/font/dotum.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

	public PdfWriterEMASS(final String title, final JSONArray header, final OutputStream out) throws Exception {
		this.title = title;
		this.header = header;
		this.out = out;
		
		init();
	}
	
	private void init() throws Exception {
		open();
		writeHeader();
	}
	
	public void appendData(List<SolrEdcVO> data, int offset) throws Exception{
		Font f2 = new Font(baseFont, 6);
		int index = 1;
		for (SolrEdcVO edc : data) {
			String key = "";
			try {
				for (int j = 0; j < header.size(); j++) {
					key = header.getJSONObject(j).getString("key");
					
					Object val = null;
					if (Common.isEquals(key, "NUM")) val = offset+(index++);
					else if (Common.isEquals(key, "to")) {
						if(edc.getTo()!=null) {
							List<String> tos = edc.getTo();
							val = getPrivateValue(edc, "toInOutInfo") + Common.join(tos, ", ");
						}
					} else if(Common.isEquals(key, "cc") ) {
						if(edc.getCc()!=null) {
							List<String> ccs = edc.getCc();
							val = getPrivateValue(edc, "ccInOutInfo") + Common.join(ccs, ", ");
						}
					} else if(Common.isEquals(key, "bcc") ) {
						if(edc.getBcc()!=null) {
							List<String> bccs = edc.getBcc();
							val = getPrivateValue(edc, "bccInOutInfo") + Common.join(bccs, ", ");
						}
					} else if(Common.isEquals(key, "recvs") ) {
						if(edc.getRecvs()!=null) {
							List<String> recvs = edc.getRecvs();
							val = getPrivateValue(edc, "recvsInOutInfo") + Common.join(recvs, ", ");
						}
					}
					else val = getPrivateValue(edc, key);
					
					PdfPCell cell = new PdfPCell(new Phrase(Common.nvl(val), f2));
					cell.setVerticalAlignment(Paragraph.ALIGN_CENTER);
					table.addCell(cell);
				}
			} catch(Exception e) {
				log.info("MsgId : {}, Data to long Field : {}", Common.nvl(edc.getMsgid()), Common.nvl(key));
				throw new Exception(e);
			}
		}
		doc.add(table);
		
		table = new PdfPTable(header.size());
		table.setWidthPercentage(100);
		float[] widths = new float[header.size()];
		for (int i = 0; i < header.size(); i++) {
			widths[i] = (float) header.getJSONObject(i).getDouble("width");
		}
		table.setWidths(widths);
	}
	
	public void close() throws Exception {
		table = null;
		doc.close();
	}
	
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

	private void open() throws DocumentException {
		doc = new Document(PageSize.A4.rotate(), 30, 30, 30, 30);
		doc.addTitle("Xcurenet PDF Writer " + title);
		doc.addSubject(title);
		doc.addAuthor("Xcurenet All Right Reserved");

		com.itextpdf.text.pdf.PdfWriter.getInstance(doc, out);
		doc.open();
	}

	private void writeHeader() throws Exception {
		Paragraph p = new Paragraph(title, new Font(baseFont, 12, Font.BOLD));
		p.setAlignment(Paragraph.ALIGN_CENTER);
		doc.add(p);

		p = new Paragraph((Prop.propFormat("report.msg.date") + " : " + Common.getCurrentTime()), new Font(baseFont, 7));
		p.setAlignment(Paragraph.ALIGN_RIGHT);
		doc.add(p);
		doc.add(new Phrase("", new Font(baseFont, 1)));

		Font f2 = new Font(baseFont, 6, Font.BOLD);
		table = new PdfPTable(header.size());
		table.setWidthPercentage(100);
		float[] widths = new float[header.size()];
		for (int i = 0; i < header.size(); i++) {
			PdfPCell cell = new PdfPCell(new Phrase(header.getJSONObject(i).getString("title"), f2));
			cell.setHorizontalAlignment(Paragraph.ALIGN_CENTER);
			cell.setVerticalAlignment(Paragraph.ALIGN_CENTER);
			table.addCell(cell);
			widths[i] = (float) header.getJSONObject(i).getDouble("width");
		}
		table.setWidths(widths);
	}

	public static void main(String[] args) throws FileNotFoundException, Exception {
		new PdfWriter("개별 통신 내역", null, null, new FileOutputStream(new File("d://aaaa.pdf")));
	}
}
