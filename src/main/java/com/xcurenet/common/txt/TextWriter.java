package com.xcurenet.common.txt;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.ServletException;

import com.xcurenet.common.rename.FileRenamePolicy;

public class TextWriter {

	private static final String TMP = "/users/apache/temp/";

	private File _file = null;

	private String keyArray[] = null;

	private String nmArray[] = null;

	private ArrayList<Map<String, String>> _dataList = null;

	private String title = null;

	public TextWriter(String title, ArrayList<Map<String, String>> list, String nmArray[], String keyArray[]) {
		this.title = title;
		this._dataList = list;
		this.nmArray = nmArray;
		this.keyArray = keyArray;
	}

	/**
	 * 텍스트 파일 쓰기 실행..
	 *
	 * @return
	 * @throws Exception
	 */
	public String execute() throws Exception {
		if (!this.createFolder(TMP)) {
			throw new ServletException("TextWriter execute Error : " + TMP);
		}
		String filePath = TMP + "TextTemp.txt";

		this.getFile(filePath); // 저장할 파일

		String textStr = getTitle() + "\n" + getHeader() + "\n" + getContents();
		OutputStream out = new FileOutputStream(_file);
		out.write(textStr.getBytes());
		out.close();

		return _file.getAbsolutePath();
	}

	/**
	 * get Title
	 *
	 * @return
	 */
	public String getTitle() {
		return this.title;
	}

	/**
	 * Text Title
	 *
	 * @return
	 */
	public String getHeader() {
		String result = "";
		for (int i = 0; i < this.nmArray.length; i++) {
			result += this.nmArray[i] + "\t";
		}
		return result;
	}

	/**
	 * 파일에 저장할 내용
	 *
	 * @return
	 */
	public String getContents() {
		StringBuffer _sb = new StringBuffer();
		for (int i = 0; i < _dataList.size(); i++) {
			Map<String, String> _item = _dataList.get(i);
			for (int j = 0; j < this.keyArray.length; j++) {
				_sb.append(_item.get(this.keyArray[j]) + "\t");
			}
			_sb.append("\n");
		}
		return _sb.toString();
	}

	/**
	 * getFile Excel 파일을 생성한다. 파일 생성규칙은 동일한 이름을 가진 파일이 존재하는 경우 파일명+숫자 로 구분하여
	 * 생성한다.
	 *
	 * @param path
	 * @return
	 */
	private void getFile(String path) {
		try {
			_file = new File(path);
			if (_file.isFile()) {
				if (_file.canWrite() && _file.canRead()) {
					_file = new FileRenamePolicy().rename(new File(_file.getAbsolutePath()));
				}
			}
		} catch (Exception e) {
			e.getStackTrace();
		}
	}

	/**
	 * 폴더 생성 텍스트 쓰기 후 임시 저장 공간에 대한 폴더 생성
	 *
	 * @param path
	 * @return
	 * @throws Exception
	 */
	private boolean createFolder(String path) throws Exception {
		boolean flag = false;
		try {
			File _file = new File(path);
			if (!_file.isDirectory()) flag = _file.mkdirs();
			else flag = true;
		} catch (Exception e) {
			throw new Exception(e);
		}
		return flag;
	}
}
