package com.xcurenet.common.excel;

import java.io.File;
import java.io.FileInputStream;

import org.apache.commons.io.IOUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class XLSXReader {

	private String xlsPath = null;

	public XLSXReader(final String xlsPath) {
		this.xlsPath = xlsPath;
	}

	public static void main(String[] args) throws Exception {
		XLSXReader x = new XLSXReader("c://aa.xlsx");
		JSONArray list = x.getList();
		for (int i = 0; i < list.size(); i++) {
			System.out.println(list.getJSONObject(i));
		}
	}

	public File isValid() throws Exception {
		File _file = new File(this.xlsPath);
		if (_file == null || !_file.isFile()) {
			throw new Exception(Prop.propFormat("java.error.file") + " : " + this.xlsPath);
		}
		return _file;
	}

	public String getExtension(final String fileStr) {
		return fileStr.substring(fileStr.lastIndexOf(".") + 1, fileStr.length());
	}

	public int isExtension() throws Exception {
		File _file = this.isValid();

		String type = this.getExtension(_file.getName()).toLowerCase();
		if (type.equals("xls")) return 2003;
		else if (type.equals("xlsx")) return 2010;
		else return 0;
	}

	public JSONArray getList() throws Exception {

		JSONArray result = new JSONArray();
		File _file = null;
		FileInputStream _fis = null;
		XSSFWorkbook workBook = null;
		XSSFSheet sheet = null;
		try {
			_file = new File(this.xlsPath);

			XSSFRow row = null;
			XSSFCell cell = null;

			_fis = new FileInputStream(_file);
			workBook = new XSSFWorkbook(_fis);

			sheet = workBook.getSheetAt(0);
			int rows = sheet.getPhysicalNumberOfRows();
			for (int r = 0; r < rows; r++) {
				JSONObject item = new JSONObject();

				row = sheet.getRow(r);
				if (row == null) continue;
				int cells = row.getLastCellNum();
				for (short c = 0; c < cells; c++) {
					cell = row.getCell(c);
					if (cell == null) continue;
					switch (cell.getCellType()) {
						case 0:
							item.put("COL" + c, Common.nvl(cell.getNumericCellValue()).trim());
							break;
						case 1:
							item.put("COL" + c, Common.nvl(cell.getStringCellValue()).trim());
							break;
						case Cell.CELL_TYPE_FORMULA:
							item.put("COL" + c, cell.getCellFormula());
							break;
						default:
							item.put("COL" + c, "");
					}
					cell = null;
				}
				result.add(item);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception(e.getMessage());
		} finally {
			if (workBook != null) workBook.close();
			IOUtils.closeQuietly(_fis);
		}
		return result;
	}

	/**
	 * Excel Read to Array List
	 *
	 * @return
	 * @throws Exception
	 */
	public String getExcelToString() throws Exception {

		StringBuffer result = new StringBuffer();
		File _file = null;
		FileInputStream _fis = null;
		XSSFWorkbook workBook = null;
		XSSFSheet sheet = null;
		String prefix = "\t";

		try {
			_file = new File(this.xlsPath);

			XSSFRow row = null;
			XSSFCell cell = null;

			_fis = new FileInputStream(_file);
			workBook = new XSSFWorkbook(_fis);

			sheet = workBook.getSheetAt(0);
			int rows = sheet.getPhysicalNumberOfRows();
			for (int r = 0; r < rows; r++) {
				row = sheet.getRow(r);
				if (row == null) continue;
				int cells = row.getPhysicalNumberOfCells();
				for (short c = 0; c < cells; c++) {
					cell = row.getCell(c);

					if (cell == null) continue;

					switch (cell.getCellType()) {
						case 0:
							result.append(String.valueOf(cell.getNumericCellValue()) + prefix);
							break;
						case 1:
							result.append(cell.getStringCellValue() + prefix);
							break;
						case Cell.CELL_TYPE_FORMULA:
							result.append(cell.getCellFormula() + prefix);
							break;
						default:
							result.append("" + prefix);
					}
				}
				result.append("\n");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(_fis);
		}
		return result.toString();
	}
}
