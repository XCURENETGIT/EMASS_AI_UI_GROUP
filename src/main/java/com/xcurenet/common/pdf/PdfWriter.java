package com.xcurenet.common.pdf;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

import org.apache.commons.io.IOUtils;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class PdfWriter {

	private String title;

	private JSONArray header;

	private JSONArray data;

	private Document doc;

	private FileOutputStream out;

	private PdfPTable table;

	private BaseFont baseFont = BaseFont.createFont(this.getClass().getResource("").getPath() + "../../files/font/dotum.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

	public PdfWriter(final String title, final JSONArray header, final JSONArray data, final FileOutputStream out) throws Exception {
		this.title = title;
		this.header = header;
		this.data = data;
		this.out = out;

		try {
			open();
			writeHeader();
			writeData();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
	}

	private void writeData() {
		Font f2 = new Font(baseFont, 6);
		for (int i = 0; i < data.size(); i++) {
			JSONObject item = data.getJSONObject(i);
			for (int j = 0; j < header.size(); j++) {
				String key = header.getJSONObject(j).getString("key");
				PdfPCell cell = new PdfPCell(new Phrase(Common.nvl(item.get(key)), f2));
				cell.setVerticalAlignment(Paragraph.ALIGN_CENTER);
				table.addCell(cell);
			}
		}
	}

	private void close() throws DocumentException {
		doc.add(table);
		doc.close();
		IOUtils.closeQuietly(out);
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
