package com.xcurenet.common.ftp;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Vector;

import org.apache.commons.io.IOUtils;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpATTRS;
import com.jcraft.jsch.SftpException;

import lombok.extern.slf4j.Slf4j;

/**
 * 서버와 연결하여 파일을 업로드하고, 다운로드한다.
 */
@Slf4j
public class SFTPUtil {
	public Session session = null;

	public Channel channel = null;

	private ChannelSftp channelSftp = null;

	private final static int TIME_OUT = 1000 * 60 * 30;

	/**
	 * 서버와 연결에 필요한 값들을 가져와 초기화 시킴
	 *
	 * @param host 서버 주소
	 * @param userName 접속에 사용될 아이디
	 *
	 * @param password 비밀번호
	 * @param port 포트번호
	 * @throws JSchException
	 */
	public void init(String host, String userName, String password, int port) throws JSchException {
		JSch jsch = new JSch();
		session = jsch.getSession(userName, host, port);
		session.setTimeout(TIME_OUT);
		session.setPassword(password);

		java.util.Properties config = new java.util.Properties();
		config.put("StrictHostKeyChecking", "no");
		session.setConfig(config);
		session.connect();

		channel = session.openChannel("sftp");
		channel.connect();
		channelSftp = (ChannelSftp) channel;
	}

	/**
	 * 인자로 받은 경로의 파일 리스트를 리턴한다.
	 *
	 * @param path
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Vector<ChannelSftp.LsEntry> getFileList(String path) {
		Vector<ChannelSftp.LsEntry> list = null;
		try {
			channelSftp.cd(path);
			list = channelSftp.ls(".");
		} catch (SftpException e) {
			e.printStackTrace();
			return null;
		}
		return list;
	}

	/**
	 * 인자로 받은 경로의 파일 리스트를 리턴한다.
	 *
	 * @param path
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Vector<ChannelSftp.LsEntry> getFileOrderList(String path) {
		Vector<ChannelSftp.LsEntry> list = null;
		try {
			channelSftp.cd(path);
			list = channelSftp.ls(".");
		} catch (SftpException e) {
			e.printStackTrace();
			return null;
		}
		return list;
	}

	public void rm(String path) {
		try {
			channelSftp.rm(path);
		} catch (SftpException e) {
			e.printStackTrace();
		}
	}

	public void rmdir(String path) {
		try {
			channelSftp.rmdir(path);
		} catch (SftpException e) {
			e.printStackTrace();
		}
	}

	public void rename(String oldpath, String newpath) {
		try {
			channelSftp.rename(oldpath, newpath);
		} catch (SftpException e) {
			e.printStackTrace();
		}
	}

	public void mkdir(String path) {
		try {
			channelSftp.ls(path);
		} catch (Exception e) {
			try {
				channelSftp.mkdir(path);
			} catch (SftpException e1) {
				e1.printStackTrace();
			}
		}
	}

	/**
	 * 하나의 파일을 업로드 한다.
	 *
	 * @param dir 저장시킬 주소(서버)
	 * @param file 저장할 파일
	 * @throws FileNotFoundException
	 */
	public void upload(String dir, File file) throws FileNotFoundException {
		upload(dir, file.getName(), new FileInputStream(file));
	}

	/**
	 * 하나의 파일을 업로드 한다.
	 *
	 * @param dir 저장시킬 주소(서버)
	 * @param file 저장할 파일
	 * @throws FileNotFoundException
	 */
	public void upload(String dir, String name, File file) throws FileNotFoundException {
		upload(dir, name, new FileInputStream(file));
	}

	public void upload(String dir, String name, InputStream in) {
		try {
			channelSftp.cd(dir);
			channelSftp.put(in, name);
		} catch (SftpException e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(in);
		}
	}

	/**
	 * 하나의 파일을 다운로드 한다.
	 *
	 * @param dir 저장할 경로(서버)
	 * @param downloadFileName 다운로드할 파일
	 * @param path 저장될 공간
	 */
	public void download(String dir, String downloadFileName, String path) {
		InputStream in = null;
		FileOutputStream out = null;
		try {
			in = download(dir, downloadFileName);
			out = new FileOutputStream(new File(path));
			IOUtils.copyLarge(in, out);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(out);
			IOUtils.closeQuietly(in);
		}
	}

	public InputStream download(String dir, String downloadFileName) {
		try {
			channelSftp.cd(dir);
			return channelSftp.get(downloadFileName);
		} catch (SftpException e) {
			e.printStackTrace();
		}
		return null;
	}


	public String getCommand(String command) {
		StringBuilder result = new StringBuilder();
		InputStream in = null;
		try {
			channel = session.openChannel("exec");
			((ChannelExec) channel).setCommand(command);
			channel.setInputStream(null);
			((ChannelExec) channel).setErrStream(System.err);

			in = channel.getInputStream();
			channel.connect();
			byte[] tmp = new byte[1024];
			while (true) {
				while (in.available() > 0) {
					int i = in.read(tmp, 0, 1024);
					if (i < 0) break;
					result.append(new String(tmp, 0, i)).append("\n");
				}
				if (channel.isClosed()) {
					if (in.available() > 0) continue;
					log.info("exit-status: " + channel.getExitStatus());
					break;
				}

				try {
					Thread.sleep(100);
				} catch (Exception ee) {
				}
			}
		} catch (JSchException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(in);
		}
		return result.toString();
	}

	public void setCommand(String command) {
		try {
			channel = session.openChannel("exec");
			((ChannelExec) channel).setCommand(command);
			channel.setInputStream(null);
			((ChannelExec) channel).setErrStream(System.err);

			InputStream in = channel.getInputStream();
			channel.connect();
			byte[] tmp = new byte[1024];
			while (true) {
				while (in.available() > 0) {
					int i = in.read(tmp, 0, 1024);
					if (i < 0) break;
					log.info(new String(tmp, 0, i));
				}
				if (channel.isClosed()) {
					if (in.available() > 0) continue;
					log.info("exit-status: " + channel.getExitStatus());
					break;
				}

				try {
					Thread.sleep(100);
				} catch (Exception ee) {
				}
			}
			IOUtils.closeQuietly(in);
		} catch (JSchException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public long getFileSize(String dir, String downloadFileName) {
		SftpATTRS fileInfo = null;
		try {
			channelSftp.cd(dir);
			fileInfo = channelSftp.lstat(downloadFileName);
			return fileInfo.getSize();
		} catch (SftpException e) {
			e.printStackTrace();
		}
		return -1L;
	}

	/**
	 * 서버와의 연결을 끊는다.
	 */
	public void disconnection() {
		if (channel != null) {
			channelSftp.quit();
			channelSftp.exit();
			channel.disconnect();
			session.disconnect();
		}
	}

	public boolean isConnected() {
		return channelSftp.isConnected();
	}

	public static void main(String[] args) {
		SFTPUtil util = new SFTPUtil();
		InputStream in = null;
		FileOutputStream out = null;
		String dir = "/users/apache/logs/";
		String downloadFileName = "catalina.out";

		// long start_size = 1048576;
		try {
			util.init("15.1.3.89", "root111", "root99", 22);
			System.out.println("conn success..");

			util.setCommand("tail -f " + dir + downloadFileName);

			// for ( int i = 0 ; i < 1000 ; i++ )
			// {
			// long file_size = util.getFileSize ( dir , downloadFileName );
			// System.out.println (file_size);
			// Thread.sleep ( 100 );
			// }

			// TimeUtil.start ( );
			// long file_size = util.getFileSize ( dir , downloadFileName );
			//
			// in = util.download ( dir, downloadFileName );
			// if( start_size > file_size ) start_size = file_size;
			// else start_size = file_size-start_size;
			// in.skip ( start_size );
			//
			// out = new FileOutputStream ( new File (
			// "/users/apache/tmp/catalina.out" ) );
			// IOUtils.copyLarge ( in, out );
			// System.out.println ( TimeUtil.print ( ) );
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(out);
			IOUtils.closeQuietly(in);
			util.disconnection();
		}
	}
}
