package com.xcurenet.common.rename;

import java.io.File;
import java.io.IOException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class FileRenamePolicy {

	public File rename(File f) throws Exception {
		try {
			if (createNewFile(f)) return f;

			String name = f.getName();
			String body = null;
			String ext = null;

			int dot = name.lastIndexOf(".");
			if (dot != -1) {
				body = name.substring(0, dot);
				ext = name.substring(dot);
			} else {
				body = name;
				ext = "";
			}

			int count = 0;
			while (!createNewFile(f) && count < 9999) {
				count++;
				String newName = body + count + ext;
				f = new File(f.getParent(), newName);
			}
		} catch (Exception e) {
			log.error(" FileRenamePolicy rename Error : ", e);
			throw new Exception("FileRenamePolicy rename Error : " + e.getMessage());
		}
		return f;
	}

	private boolean createNewFile(File f) {
		try {
			return f.createNewFile();
		} catch (IOException e) {
			log.error(" FileRenamePolicy createNewFile Error : ", e);
			return false;
		}
	}
}
