package com.xcurenet.user.service;

import com.xcurenet.common.detect.DetectCharset;
import com.xcurenet.common.util.Common;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.io.output.FileWriterWithEncoding;
import org.joda.time.DateTime;

import java.io.*;

public class InsaFileMerge {

	public File getInsaFile(String path, String originalFileName) {
		if (path.indexOf("*") > -1) {
			String fileParttern = path.substring(path.lastIndexOf("\\") + 1, path.length());
			String dir = path.substring(0, path.lastIndexOf("\\") + 1);
			final String extension = Common.getExtension(fileParttern);
			File _dir = new File(dir);
			File[] insa = _dir.listFiles(new FileFilter() {
				@Override
				public boolean accept(File pathname) {
					if (pathname.isDirectory()) return false;
					if (Common.isEmpty(extension) || Common.isEquals(Common.getExtension(pathname.getName()), extension))
						return true;
					return false;
				}
			});
			File f = newFile(originalFileName);
			mergeFiles(insa, f);
			return f;
		} else {
			File f = newFile(originalFileName);
			try {
				FileUtils.copyFile(new File(path), f);
			} catch (IOException e) {
				e.printStackTrace();
			}
			return f;
		}
	}

	// 하위 호환성을 위한 오버로드 메서드
	public File getInsaFile(String path) {
		String fileName = new File(path).getName();
		return getInsaFile(path, fileName);
	}

	public File newFile(String originalFileName) {
		// 임시 백업 파일 생성
		String tmp = Common.TMP_PATH + "insa" + File.separator;
		Common.mkdirs(tmp);

		String fileName = "default.dat";
		try {
			String fileNameWithoutExt = originalFileName;
			int lastDotIndex = originalFileName.lastIndexOf('.');
			if (lastDotIndex > 0) {
				fileNameWithoutExt = originalFileName.substring(0, lastDotIndex);
			}

			// 파일명_yyyyMMddHHmmss_dat 형식
			fileName = fileNameWithoutExt + "_" + Common.getDateTimeFormat() + ".dat";
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
					if (Common.isEmpty(extension) || Common.isEquals(Common.getExtension(pathname.getName()), extension))
						return true;
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
