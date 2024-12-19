package com.xcurenet.user.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.io.output.FileWriterWithEncoding;
import org.joda.time.DateTime;

import com.xcurenet.common.detect.DetectCharset;
import com.xcurenet.common.util.Common;

public class InsaFileMerge {

	public File getInsaFile(String path) {
		if (path.indexOf("*") > -1) {
			String fileParttern = path.substring(path.lastIndexOf("\\") + 1, path.length());
			String dir = path.substring(0, path.lastIndexOf("\\") + 1);
			final String extension = Common.getExtension(fileParttern);
			File _dir = new File(dir);
			File[] insa = _dir.listFiles(new FileFilter() {
				@Override
				public boolean accept(File pathname) {
					if (pathname.isDirectory()) return false;
					if (Common.isEmpty(extension) || Common.isEquals(Common.getExtension(pathname.getName()), extension)) return true;
					return false;
				}
			});
			File f = newFile();
			mergeFiles(insa, f);
			return f;
		} else {
			File f = newFile();
			try {
				FileUtils.copyFile(new File(path), f);
			} catch (IOException e) {
				e.printStackTrace();
			}
			return f;
		}
	}

	public File newFile() {
		String tmp = Common.TMP_PATH + "insa"+File.separator;
		Common.mkdirs(tmp);
		String fileName = "default.dat";
		try {
			fileName = Common.getDateTimeFormat() + ".dat";
		} catch (Exception e) {
			e.printStackTrace();
		}
		File f = new File(tmp + fileName);
		if (f.exists()) f.delete();
		return f;
	}

	public void backupFile(String path) throws IOException {
		if (path.indexOf("*") > -1) {
			String fileParttern = path.substring(path.lastIndexOf("\\") + 1, path.length());
			String dir = path.substring(0, path.lastIndexOf("\\") + 1);
			final String extension = Common.getExtension(fileParttern);
			File _dir = new File(dir);
			File[] insa = _dir.listFiles(new FileFilter() {
				@Override
				public boolean accept(File pathname) {
					if (pathname.isDirectory()) return false;
					if (Common.isEmpty(extension) || Common.isEquals(Common.getExtension(pathname.getName()), extension)) return true;
					return false;
				}
			});
			for (File src : insa) {
				FileUtils.moveFile(src, getBackupFile(src));
			}
		} else {
			File src = new File(path);
			FileUtils.moveFile(src, getBackupFile(src));
		}
	}
	private File getBackupFile(File src) {
		return new File(src.getParent() + File.separatorChar + "backup" + File.separatorChar + src.getName() + "." + new DateTime().toString("yyyyMMddHHmmss"));
	}

	public static void mergeFiles(File[] files, File mergedFile) {
		FileWriterWithEncoding fstream = null;
		BufferedWriter out = null;
		try {
			fstream = new FileWriterWithEncoding(mergedFile, Common.UTF8, true);
			out = new BufferedWriter(fstream);
		} catch (IOException e1) {
			e1.printStackTrace();
		}

		for (File f : files) {
			FileInputStream fis = null;
			try {
				fis = new FileInputStream(f);
				BufferedReader in = new BufferedReader(new InputStreamReader(fis, DetectCharset.getCharset(f)));
				String aLine;
				while ((aLine = in.readLine()) != null) {
					out.write(aLine);
					out.newLine();
				}
				in.close();
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				IOUtils.closeQuietly(fis);
			}
		}
		IOUtils.closeQuietly(out);
	}
}
