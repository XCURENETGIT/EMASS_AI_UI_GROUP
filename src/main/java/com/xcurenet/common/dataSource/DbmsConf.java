package com.xcurenet.common.dataSource;

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Properties;

import org.apache.commons.io.IOUtils;

import com.xcurenet.common.crypto.CryptoCommon;
import com.xcurenet.common.crypto.CryptoKey;
import com.xcurenet.common.util.Common;
import com.xcurenet.crypto.Crypto;

import lombok.Data;

@Data
public class DbmsConf {

	public static final String DBMS_CONF = "/etc/dbms.conf";

	private String user;

	private String password;

	public DbmsConf() {
		loadDbConfig();
	}

	private void loadDbConfig() {
		FileInputStream in = null;
		Properties prop = new Properties();
		try {
			in = new FileInputStream(DBMS_CONF);
			prop.load(new CryptoCommon().decrypt(in));

			this.setUser(Common.nvl(prop.getProperty("sql.username")));
			this.setPassword(Common.nvl(prop.getProperty("sql.password")));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(in);
			prop.clear();
		}
	}

	public boolean makeDbmsConf(String user, String password) {
		String conf = String.format("sql.username=%s\nsql.password=%s", user, password);
		ByteArrayInputStream in = null;
		FileOutputStream out = null;
		try {
			in = new ByteArrayInputStream(conf.getBytes());
			out = new FileOutputStream(DbmsConf.DBMS_CONF);
			Crypto cr = new Crypto(CryptoKey.getKey(), Crypto.CIPHER.ARIA_128_CBC);
			cr.encrypt(in, out, conf.length());
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			IOUtils.closeQuietly(in);
			IOUtils.closeQuietly(out);
		}
		return true;
	}

	public void restartTomcat() {
		Common.executeCommand("/users/edc/bin/edc restart");
		//Common.sleep(30000);
		/*Common.executeCommandNoWait("/users/apache/bin/shutdown.sh");
		Common.sleep(30000);
		Common.executeCommandNoWait("/users/apache/bin/startup.sh");
		Common.sleep(30000);*/
		//Common.executeCommandNoWait("/users/apache/bin/restart.sh");
		//Common.executeCommand("/users/edc/bin/edc restart");
		//Common.executeCommand("/bin/sh /users/apache/bin/restart.sh");
	}
	
	public static void main(String[] args) {
		String conf = String.format("sql.username=%s\nsql.password=%s", "root", "rudwn@Xcn1234");
		ByteArrayInputStream in = null;
		FileOutputStream out = null;
		try {
			in = new ByteArrayInputStream(conf.getBytes());
			out = new FileOutputStream(DbmsConf.DBMS_CONF);
			Crypto cr = new Crypto(CryptoKey.getKey(), Crypto.CIPHER.ARIA_128_CBC);
			cr.encrypt(in, out, conf.length());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(in);
			IOUtils.closeQuietly(out);
		}
	}
}
