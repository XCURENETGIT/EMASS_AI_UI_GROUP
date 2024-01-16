package com.xcurenet.common.pdf;

import java.awt.*;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStream;

import com.itextpdf.text.*;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import org.apache.commons.io.IOUtils;

import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class PdfWriter {

	private String title;

	private JSONArray header;

	private JSONArray data;

	private Document doc;

	private FileOutputStream out;

	private OutputStream out2;

	private PdfPTable table;

	private String reportDate;
	private String searchDate;
	private String html;
	private String check;

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


	public PdfWriter(final String title,final  String reportDate,final String searchDate, final String html, final String check, final FileOutputStream out) throws Exception {

		this.title = title;
		this.reportDate = reportDate;
		this.searchDate = searchDate;
		this.html = html;
		this.check = check;
		this.out = out;

		try {
		/*	Document doc = new Document(PageSize.A4);*/
			open_re();
			writePage();
			doc.newPage();
			write_reData();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			doc.close();
			IOUtils.closeQuietly(out);
		}
	}

/*	private static void createTable(Document document, String html) throws DocumentException {
		int tableCount = 0;
		org.jsoup.nodes.Document doc = Jsoup.parse(html);

		for (Element table : doc.select(".subTable")) {
			tableCount++;
			if (tableCount == 1) {
				document.add(new Phrase(tableCount + ". " + table.attr("name"), new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD)));
			} else {
				document.add(new Phrase("\n" + tableCount + ". " + table.attr("name"), new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD)));
			}

			PdfPTable pdfPTable = new PdfPTable(3); // Adjust the number of columns as needed
			pdfPTable.setWidthPercentage(100);

			for (Element row : table.select("tr")) {
				Elements ths = row.select("th");
				for (Element element : ths) {
					PdfPCell cell = new PdfPCell(new Phrase(element.text(), new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD)));
					cell.setHorizontalAlignment(Element.ALIGN_CENTER);
					cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
					cell.setBackgroundColor(BaseColor.LIGHT_GRAY); // Adjust the color as needed
					pdfPTable.addCell(cell);
				}

				Elements tds = row.select("td");
				for (Element element : tds) {
					PdfPCell cell = new PdfPCell(new Phrase(element.text(), new Font(Font.FontFamily.HELVETICA, 10)));
					cell.setHorizontalAlignment(Element.ALIGN_CENTER);
					cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
					pdfPTable.addCell(cell);
				}
			}
			document.add(pdfPTable);
		}
	}*/



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



	private void write_reData() {
		org.jsoup.nodes.Document jsoupDoc = Jsoup.parse(html);

		Elements tables = jsoupDoc.select(".subTable");

		for (Element table : tables) {
			try {
				// Extract title from h3 tag
				String title = table.parent().select("h3").text();
				if (!title.isEmpty()) {
					doc.add(new Paragraph(title));
				}

				PdfPTable pdfTable = new PdfPTable(table.select("tr").first().select("th, td").size());

				// Populate the PdfPTable with content from the HTML table
				for (Element row : table.select("tr")) {
					for (Element cell : row.select("th")) {
						PdfPCell pdfCell = new PdfPCell(new Paragraph(cell.text()));
						pdfTable.addCell(pdfCell);
					}

					for (Element cell : row.select("td")) {
						PdfPCell pdfCell = new PdfPCell(new Paragraph(cell.text()));
						pdfTable.addCell(pdfCell);
					}
				}

				// Add the PdfPTable to the PDF document
				doc.add(pdfTable);

				// 페이지 간격
				doc.newPage();

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	private void close() throws DocumentException {
		doc.add(table);
		doc.close();
		IOUtils.closeQuietly(out);
	}

	private void open_re() throws DocumentException {
		doc = new Document(PageSize.A4);
		doc.addTitle("Xcurenet PDF Writer " + title);
		doc.addSubject(title);
		doc.addAuthor("Xcurenet All Right Reserved");

		com.itextpdf.text.pdf.PdfWriter.getInstance(doc, out);
		doc.open();
	}

	private void open() throws DocumentException {
		doc = new Document(PageSize.A4.rotate(), 30, 30, 30, 30);
		doc.addTitle("Xcurenet PDF Writer " + title);
		doc.addSubject(title);
		doc.addAuthor("Xcurenet All Right Reserved");

		com.itextpdf.text.pdf.PdfWriter.getInstance(doc, out);
		doc.open();
	}

	private void writePage() throws Exception {
		Paragraph reportDate2 = new Paragraph(reportDate, new Font(baseFont, 12, Font.BOLD));
		reportDate2.setSpacingAfter(160);
		doc.add(reportDate2);

		Image img2 = Image.getInstance("src/main/resources/static/img/login_bi.png");
		/*img1.scaleAbsolute(30, 30);*/
		img2.scaleAbsolute(40, 40);
		Paragraph emassPro  = new Paragraph();
		emassPro.add(new Chunk(img2, 0, 0));
		emassPro.add(new Chunk("EMASSPRO", new Font(baseFont, 15, Font.NORMAL)));

		doc.add(emassPro);


		// subTitle과 title을 각각의 Paragraph로 묶음

		Paragraph title = new Paragraph("컨텐츠 현황보고서", new Font(baseFont, 50, Font.BOLDITALIC, new BaseColor(0, 102, 204)));
		title.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
		title.setSpacingAfter(20);
		doc.add(title);

		// A4 용지 맨 아래에 기간과 searchDate 추가
		Paragraph period = new Paragraph( searchDate, new Font(baseFont, 12, Font.NORMAL));
		period.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
		period.setSpacingBefore(doc.getPageSize().getHeight() * 0.02f ); // 적절한 간격 조절
		doc.add(period);

		Paragraph company= new Paragraph("엑스큐어넷",new Font(baseFont, 12, Font.BOLD));
		company.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
		doc.add(company);
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
