package com.xcurenet.common.pdf;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.io.IOUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStream;

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

	private BaseFont baseFont = BaseFont.createFont(this.getClass().getResource("").getPath() + pathReplace("../../files/font/dotum.ttf"), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
	private BaseFont baseFont9 = BaseFont.createFont(this.getClass().getResource("").getPath() + pathReplace("../../files/font/Pretendard-Black.ttf"), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
	private BaseFont baseFont8 = BaseFont.createFont(this.getClass().getResource("").getPath() + pathReplace("../../files/font/Pretendard-Bold.ttf"), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
	private BaseFont baseFont7 = BaseFont.createFont(this.getClass().getResource("").getPath() + pathReplace("../../files/font/Pretendard-Medium.ttf"), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
	private BaseFont baseFont6 = BaseFont.createFont(this.getClass().getResource("").getPath() + pathReplace("../../files/font/Pretendard-Regular.ttf"), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
	private BaseFont baseFont5 = BaseFont.createFont(this.getClass().getResource("").getPath() + pathReplace("../../files/font/Pretendard-SemiBold.ttf"), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
	private BaseFont baseFont4 = BaseFont.createFont(this.getClass().getResource("").getPath() + pathReplace("../../files/font/Pretendard-Light.ttf"), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
	private BaseFont baseFont3 = BaseFont.createFont(this.getClass().getResource("").getPath() + pathReplace("../../files/font/Pretendard-ExtraLight.ttf"), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
	private BaseFont baseFont2 = BaseFont.createFont(this.getClass().getResource("").getPath() + pathReplace("../../files/font/Pretendard-Thin.ttf"), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

	Font font2 = FontFactory.getFont(pathReplace("path/to/Pretendard-Black.subset.woff2"), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

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
		Font font = new Font(baseFont3, Font.DEFAULTSIZE, Font.NORMAL);
		Font font2 = new Font(baseFont4, Font.DEFAULTSIZE, Font.NORMAL);

		for (Element table : tables) {
			try {
				String title = table.attr("name");
				PdfPCell titleCell = new PdfPCell(new Phrase(title, new Font(baseFont3, 15, Font.BOLD, BaseColor.BLACK)));
				titleCell.setColspan(table.select("tr").first().select("th, td").size());
				titleCell.setBackgroundColor(new BaseColor(238, 239, 242));
				float cellHeight = 30f;
				titleCell.setFixedHeight(cellHeight);

				PdfPTable titleTable = new PdfPTable(1);
				titleTable.setWidthPercentage(100);
				titleTable.addCell(titleCell);

				doc.add(titleTable);
				doc.add(Chunk.NEWLINE);

				PdfPTable pdfTable = new PdfPTable(table.select("tr").first().select("th, td").size());
				pdfTable.setWidthPercentage(100);

				boolean isEvenRow = false;

				for (Element row : table.select("tr")) {
					Elements headerCells = row.select("th");
					Elements dataCells = row.select("td");

					for (Element headerCell : headerCells) {
						PdfPCell pdfCell = new PdfPCell(new Phrase(headerCell.text(), font2));

						// Set background color for all th cells
						pdfCell.setBackgroundColor(new BaseColor(238, 239, 242)); // #EEEFF2

						pdfTable.addCell(pdfCell);
					}

					for (Element dataCell : dataCells) {
						PdfPCell pdfCell = new PdfPCell(new Phrase(dataCell.text(), font));

						// Set background color for even rows
						if (isEvenRow) {
							pdfCell.setBackgroundColor(new BaseColor(248, 248, 248)); // #f8f8f8
						}

						pdfTable.addCell(pdfCell);
					}

					// Toggle the flag for even rows
					isEvenRow = !isEvenRow;
				}

				// Add the PdfPTable to the PDF document
				doc.add(pdfTable);

				// Add space between tables
				doc.add(Chunk.NEWLINE);
				doc.add(Chunk.NEWLINE);

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
		Paragraph reportDate2 = new Paragraph(reportDate, new Font(baseFont2, 12, Font.BOLD));
		reportDate2.setSpacingAfter(160);
		doc.add(reportDate2);

		Image img2 = Image.getInstance(pathReplace("src/main/resources/static/img/login_bi.png"));
		/*img1.scaleAbsolute(30, 30);*/
		img2.scaleAbsolute(40, 40);
		Paragraph emassPro  = new Paragraph();
		emassPro.add(new Chunk(img2, 0, 0));
		emassPro.add(new Chunk("EMASS AI", new Font(baseFont5, 15, Font.NORMAL)));

		doc.add(emassPro);

		Paragraph title = new Paragraph("컨텐츠 현황보고서", new Font(baseFont8, 50, Font.BOLD, new BaseColor(0, 102, 204)));
		title.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
		title.setSpacingAfter(20);
		doc.add(title);

		// A4 용지 맨 아래에 기간과 searchDate 추가
		Paragraph period = new Paragraph( searchDate, new Font(baseFont6, 12, Font.NORMAL));
		period.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
		period.setSpacingBefore(doc.getPageSize().getHeight() * 0.02f ); // 적절한 간격 조절
		doc.add(period);

		emptyLine(20);

		Paragraph company = new Paragraph("COPYRIGHT© XCURENET. ALL RIGHTS RESERVED.", new Font(baseFont3, 10, Font.BOLD));
		company.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
		doc.add(company);
	}

	private void emptyLine(int rine) throws DocumentException {
		for (int i = 0; i < rine; i++) {
			doc.add(new Paragraph(" ", new Font(baseFont2, 12, Font.BOLD)));
		}
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

	public String pathReplace(String str){
		return str.replaceAll("//",File.separator);
	}
}
