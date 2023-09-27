package com.xcurenet.common.excel;

import java.awt.Color;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.util.List;

import org.apache.poi.common.usermodel.HyperlinkType;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Hyperlink;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.message.service.EmsMessageService;
import com.xcurenet.emass.message.service.SolrEdcVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Slf4j
public class XLSXWriterEMASS {
	private SXSSFWorkbook WB;
	private Sheet ST;
	private static int NEW_ROW_CNT = 0;
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
	private int offset;

	public XLSXWriterEMASS(final String title, final JSONArray header, int offset) {
		this.title = title;
		this.header = header;
		this.offset = offset;
	}

	public XLSXWriterEMASS(final String title, final JSONArray header) {
		this.title = title;
		this.header = header;
		this.offset = 0;
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

	public void appendData(List<SolrEdcVO> data) throws Exception {
		appendData(data, false, false);
	}

	public void appendData(List<SolrEdcVO> data, boolean subjectLink, boolean attachLink) throws Exception {
		for (SolrEdcVO edc : data) {
			int lastRow = ST.getLastRowNum() + 1;
			Row r = ST.createRow(lastRow);
			NEW_ROW_CNT = 0;
			String key = "";
			try {
				for (int j = 0; j < header.size(); j++) {
					JSONObject h = header.getJSONObject(j);
					key = Common.nvl(h.get("key"));

					Object val = null;
					if (Common.isEquals(key, "NUM")) val = offset+ lastRow - HEADER_ROW;
					else val = getPrivateValue(edc, key);

					if (Common.isNotEquals(key, "body") && val == null) continue;
					String str = Common.nvl(val);
					writerOver(str, h ,r, j);
					r = ST.getRow(ST.getLastRowNum() - NEW_ROW_CNT);

					String msgid = edc.getMsgid();
					if (subjectLink && Common.isEquals(key, "subject")) listStyle(r.createCell(j), str, Common.nvl(h.get("align"), "left"), Common.makeFilepath("messages", msgid), HyperlinkType.FILE);
					else if (attachLink && Common.isEquals(key, "attachcnt") && !str.equals("0")) listStyle(r.createCell(j), str, Common.nvl(h.get("align"), "center"), Common.makeFilepath("messages", msgid, "attachs") + "/", HyperlinkType.FILE);
					else if(Common.isEquals(key, "to") ) {
						if(edc.getTo()!=null) {
							List<String> tos = edc.getTo();
							String toStr = getPrivateValue(edc, "toInOutInfo") + Common.join(tos, ", ");
							writerOver(toStr, h ,r, j);
//						listStyle(r.createCell(j), getPrivateValue(edc, "toInOutInfo") + Common.join(tos, ", "), Common.nvl(h.get("align"), "left"));
						}
					} else if(Common.isEquals(key, "cc") ) {
						if(edc.getCc()!=null) {
							List<String> ccs = edc.getCc();
							String ccStr = getPrivateValue(edc, "ccInOutInfo") + Common.join(ccs, ", ");
							writerOver(ccStr, h ,r, j);
//						listStyle(r.createCell(j), getPrivateValue(edc, "ccInOutInfo") + Common.join(ccs, ", "), Common.nvl(h.get("align"), "left"));
						}
					} else if(Common.isEquals(key, "bcc") ) {
						if(edc.getBcc()!=null) {
							List<String> bccs = edc.getBcc();
							String bccStr = getPrivateValue(edc, "bccInOutInfo") + Common.join(bccs, ", ");
							writerOver(bccStr, h ,r, j);
//						listStyle(r.createCell(j), getPrivateValue(edc, "bccInOutInfo") + Common.join(bccs, ", "), Common.nvl(h.get("align"), "left"));
						}
					} else if(Common.isEquals(key, "recvs") ) {
						if(edc.getRecvs()!=null) {
							List<String> recvs = edc.getRecvs();
							String recvStr = getPrivateValue(edc, "recvsInOutInfo") + Common.join(recvs, ", ");
							writerOver(recvStr, h ,r, j);
//						listStyle(r.createCell(j), getPrivateValue(edc, "recvsInOutInfo") + Common.join(recvs, ", "), Common.nvl(h.get("align"), "left"));
						}
					} else if(Common.isEquals(key, "body")){
						EmsMessageService emsMessageService = SpringContextUtil.getBean(EmsMessageService.class);
						str = new String(emsMessageService.getEmassBody(edc.getMsgid(), "", "").getBody());
						writerOver(str, h ,r, j);
					} else {
						writerOver(str, h ,r, j);
					}
				}
			} catch (IllegalArgumentException e) {
				log.info("MsgId : {}, Data to long Field : {}", Common.nvl(edc.getMsgid()), Common.nvl(key));
				throw new Exception(e);
			}
		}
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

	private void writerOver(String txt, JSONObject h, Row r, int j) {
		if(txt.length() > 30000) {
			String tmptxt = txt.substring(0, 30000);

			listStyle(r.createCell(j), tmptxt, Common.nvl(h.get("align"), "left"));
			int stIdx = 30000;
			for(int z=0; z < (txt.length() / 30000); z++) {
				if(NEW_ROW_CNT < (txt.length() / 30000)) {
					r = ST.createRow(ST.getLastRowNum() + 1);
					NEW_ROW_CNT++;
				}
				else r = ST.getRow(ST.getLastRowNum() - NEW_ROW_CNT + z + 1);

				tmptxt = txt.substring(stIdx, (stIdx + 30000) > txt.length() ? txt.length() : (stIdx + 30000));
				stIdx += 30000;

				listStyle(r.createCell(j), tmptxt, Common.nvl(h.get("align"), "left"));

			}
		} else {
			listStyle(r.createCell(j), txt, Common.nvl(h.get("align"), "left"));
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
			//ST.autoSizeColumn(i, true);
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
