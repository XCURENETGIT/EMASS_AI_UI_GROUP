package com.xcurenet.common.excel;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.poi.common.usermodel.HyperlinkType;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;

import java.awt.Color;
import java.io.IOException;
import java.io.OutputStream;

public class XLSXWriterAppender {
	private SXSSFWorkbook WB;
	private Sheet ST;
	private final static int TITLE_ROW = 1;
	private final static int DATE_ROW = 3;
	private final static int HEADER_ROW = 4;
	private final static short TITLE_SIZE = 25;
	private final static short HEADER_SIZE = 10;
	private final static String FONT_NAME = "dotum";

	private XSSFCellStyle left_style;
	private XSSFCellStyle center_style;
	private XSSFCellStyle right_style;
	private XSSFCellStyle link_left_style;
	private XSSFCellStyle link_center_style;

	private JSONArray header;
	private String title;

	public XLSXWriterAppender(final String title, final JSONArray header) {
		this.title = title;
		this.header = header;
	}

	public void init() throws Exception {
		WB = new SXSSFWorkbook(200);
		WB.setCompressTempFiles(false);
		ST = WB.createSheet();

		init_style();

		createTitle(title);

		createDate();

		header();
	}

	public void appendData(JSONArray data) throws Exception {
		appendData(data, false, false);
	}

	public void appendData(JSONArray data, boolean subjectLink, boolean attachLink) throws Exception {
		for (int i = 0; i < data.size(); i++) {
			Row r = ST.createRow(ST.getLastRowNum() + 1);
			JSONObject obj = data.getJSONObject(i);
			for (int j = 0; j < header.size(); j++) {
				JSONObject h = header.getJSONObject(j);
				String txt = Common.nvl(obj.get(Common.nvl(h.get("key"))));
				String align = Common.nvl(h.get("align"), "left");
				if (Common.isEquals(h.get("type"), "LINK")) {
					String link = Common.nvl(obj.get(Common.nvl(h.get("key")) + "_LINK"));
					if (Common.isEmpty(link)) listStyle(r.createCell(j), txt, align);
					else listStyle(r.createCell(j), txt, align, link, HyperlinkType.FILE);
				} else {
					listStyle(r.createCell(j), txt, align);
				}
			}
		}
	}

	public void write(OutputStream out) {
		try {
			WB.write(out);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			WB.dispose();
			WB = null;
			ST = null;
		}
	}

	private Cell listStyle(Cell cell, String msg, String alignMsg) {
		if (Common.isEquals(alignMsg, "center")) setAlign(cell, HorizontalAlignment.CENTER);
		else if (Common.isEquals(alignMsg, "right")) setAlign(cell, HorizontalAlignment.RIGHT);
		else setAlign(cell, HorizontalAlignment.LEFT);
		cell.setCellValue(msg);
		return cell;
	}

	private Cell listStyle(Cell cell, String msg, String alignMsg, String path, HyperlinkType type) {
		cell = listStyle(cell, msg, alignMsg);
		cell.setHyperlink(getHyperlink(path, type));
		if (Common.isEquals(alignMsg, "center")) cell.setCellStyle(link_center_style);
		else if (Common.isEquals(alignMsg, "left")) cell.setCellStyle(link_left_style);
		return cell;
	}

	private Hyperlink getHyperlink(String path, HyperlinkType type) {
		Hyperlink link = WB.getCreationHelper().createHyperlink(type);
		link.setAddress(path);
		return link;
	}

	private void setAlign(Cell cell, HorizontalAlignment align) {
		if (HorizontalAlignment.LEFT == align && cell.getHyperlink() == null) cell.setCellStyle(left_style);
		else if (HorizontalAlignment.CENTER == align && cell.getHyperlink() == null) cell.setCellStyle(center_style);
		else if (HorizontalAlignment.RIGHT == align && cell.getHyperlink() == null) cell.setCellStyle(right_style);
		else if (HorizontalAlignment.LEFT == align && cell.getHyperlink() != null) cell.setCellStyle(link_left_style);
		else if (HorizontalAlignment.CENTER == align && cell.getHyperlink() != null) cell.setCellStyle(link_center_style);
	}

	private void createTitle(String msg) {
		ST.addMergedRegion(new CellRangeAddress(TITLE_ROW, TITLE_ROW, 0, header.size() - 1));
		Row h = ST.createRow(TITLE_ROW);
		h.setHeightInPoints(TITLE_SIZE);
		styleTitle(h.createCell(0), msg, true, (short) 15, HorizontalAlignment.CENTER, Color.decode("#457BC4"));
	}

	private void createDate() {
		try {
			Row h = ST.createRow(DATE_ROW);
			ST.addMergedRegion(new CellRangeAddress(DATE_ROW, DATE_ROW, 0, header.size() - 1));
			h.setHeightInPoints(HEADER_SIZE);
			style(h.createCell(0), (Prop.propFormat("report.msg.date") + " : " + Common.getCurrentTime()), true, (short) 10, HorizontalAlignment.RIGHT, null, false);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void header() {
		Row h = ST.createRow(HEADER_ROW);
		for (int i = 0; i < header.size(); i++) {
			JSONObject obj = header.getJSONObject(i);
			int width = Common.nvz(obj.get("width"));
			String title = Common.nvl(obj.get("title"));
			ST.setColumnWidth(i, calculateColWidth(width));
			// ST.autoSizeColumn(i, true);
			if (ST.getColumnWidth(i) > 20000) ST.setColumnWidth(i, 20000);
			if (ST.getColumnWidth(i) <= 800) ST.setColumnWidth(i, 800);

			style(h.createCell((short) i), title, true, HEADER_SIZE, HorizontalAlignment.CENTER, Color.decode("#D9D9D9"), true);
			ST.createFreezePane(0, HEADER_ROW + 1);
		}
	}

	private static int calculateColWidth(int width) {
		if (width > 254) return 65280;
		if (width > 1) {
			int floor = (int) (Math.floor(((double) width) / 5));
			int factor = (30 * floor);
			int value = factor + ((width - 1) * 30);
			return value;
		} else {
			return 450;
		}
	}

	private Cell styleTitle(Cell cell, String msg, boolean bold, short size, HorizontalAlignment align, Color bg) {
		XSSFCellStyle style = (XSSFCellStyle) WB.createCellStyle();

		style.setAlignment(align);
		style.setVerticalAlignment(VerticalAlignment.CENTER);

		Font font = WB.createFont();
		if (bold) {
			font.setBold(true);
		} else {
			font.setBold(false);
		}
		font.setFontHeightInPoints(size);
		font.setFontName(FONT_NAME);
		font.setColor(HSSFColor.WHITE.index);

		if (bg != null) {
			style.setFillForegroundColor(new XSSFColor(bg));
			style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		}

		if (cell.getHyperlink() != null) {
			font.setUnderline(Font.U_SINGLE);
			font.setColor(IndexedColors.BLUE.getIndex());
		}
		CreationHelper createHelper = WB.getCreationHelper();
		cell.setCellValue(createHelper.createRichTextString(msg));
		style.setWrapText(true);
		style.setFont(font);
		cell.setCellStyle(style);
		return cell;
	}

	private Cell style(Cell cell, String msg, boolean bold, short size, HorizontalAlignment align, Color bg, boolean border) {
		XSSFCellStyle style = (XSSFCellStyle) WB.createCellStyle();

		style.setAlignment(align);
		style.setVerticalAlignment(VerticalAlignment.CENTER);

		Font font = WB.createFont();
		if (bold) font.setBold(true);
		else font.setBold(false);

		font.setFontHeightInPoints(size);
		font.setFontName(FONT_NAME);
		if (bg != null) {
			style.setFillForegroundColor(new XSSFColor(bg));
			style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		}
		if (border) {
			style.setBorderBottom(BorderStyle.THIN);
			style.setBottomBorderColor(new XSSFColor(Color.BLACK));
			style.setBorderLeft(BorderStyle.THIN);
			style.setLeftBorderColor(new XSSFColor(Color.BLACK));
			style.setBorderRight(BorderStyle.THIN);
			style.setRightBorderColor(new XSSFColor(Color.BLACK));
			style.setBorderTop(BorderStyle.THIN);
			style.setTopBorderColor(new XSSFColor(Color.BLACK));
		}
		if (cell.getHyperlink() != null) {
			font.setUnderline(Font.U_SINGLE);
			font.setColor(IndexedColors.BLUE.getIndex());
		}
		CreationHelper createHelper = WB.getCreationHelper();
		cell.setCellValue(createHelper.createRichTextString(msg));
		style.setWrapText(true);
		style.setFont(font);
		cell.setCellStyle(style);
		return cell;
	}

	private void init_style() {
		left_style = (XSSFCellStyle) WB.createCellStyle();
		center_style = (XSSFCellStyle) WB.createCellStyle();
		right_style = (XSSFCellStyle) WB.createCellStyle();
		link_left_style = (XSSFCellStyle) WB.createCellStyle();
		link_center_style = (XSSFCellStyle) WB.createCellStyle();

		Font left_font = WB.createFont();
		left_font.setFontHeightInPoints(HEADER_SIZE);
		left_font.setFontName(FONT_NAME);
		left_style.setAlignment(HorizontalAlignment.LEFT);
		left_style.setVerticalAlignment(VerticalAlignment.CENTER);
		left_style.setWrapText(true);
		left_style.setFont(left_font);

		Font center_font = WB.createFont();
		center_font.setFontHeightInPoints(HEADER_SIZE);
		center_font.setFontName(FONT_NAME);
		center_style.setAlignment(HorizontalAlignment.CENTER);
		center_style.setVerticalAlignment(VerticalAlignment.CENTER);
		center_style.setWrapText(true);
		center_style.setFont(center_font);

		Font right_font = WB.createFont();
		right_font.setFontHeightInPoints(HEADER_SIZE);
		right_font.setFontName(FONT_NAME);
		right_style.setAlignment(HorizontalAlignment.RIGHT);
		right_style.setVerticalAlignment(VerticalAlignment.CENTER);
		right_style.setWrapText(true);
		right_style.setFont(right_font);

		Font link_left_font = WB.createFont();
		link_left_font.setFontHeightInPoints(HEADER_SIZE);
		link_left_font.setFontName(FONT_NAME);
		link_left_font.setUnderline(Font.U_SINGLE);
		link_left_font.setColor(IndexedColors.BLUE.getIndex());
		link_left_style.setAlignment(HorizontalAlignment.LEFT);
		link_left_style.setVerticalAlignment(VerticalAlignment.CENTER);
		link_left_style.setWrapText(true);
		link_left_style.setFont(link_left_font);

		Font link_center_font = WB.createFont();
		link_center_font.setFontHeightInPoints(HEADER_SIZE);
		link_center_font.setFontName(FONT_NAME);
		link_center_font.setUnderline(Font.U_SINGLE);
		link_center_font.setColor(IndexedColors.BLUE.getIndex());
		link_center_style.setAlignment(HorizontalAlignment.CENTER);
		link_center_style.setVerticalAlignment(VerticalAlignment.CENTER);
		link_center_style.setWrapText(true);
		link_center_style.setFont(link_center_font);
	}
}
