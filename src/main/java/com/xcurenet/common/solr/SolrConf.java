package com.xcurenet.common.solr;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Properties;

import org.apache.commons.io.IOUtils;

import com.xcurenet.common.crypto.CryptoCommon;
import com.xcurenet.common.util.Common;

import lombok.Data;

@Data
public class SolrConf {

	public static final String SOLR_CONF = "/etc/solr.conf";

	private String user;

	private String password;

	public SolrConf() {
		loadDbConfig();
	}

	private void loadDbConfig() {
		if (Common.isWindow()) 
		{
			this.setUser("");
			this.setPassword("");
			return;
		}
		
		FileInputStream in = null;
		Properties prop = new Properties();
		try {
			in = new FileInputStream(SOLR_CONF);
			prop.load(new CryptoCommon().decrypt(in));

			this.setUser(Common.nvl(prop.getProperty("solr.username")));
			this.setPassword(Common.nvl(prop.getProperty("solr.password")));
		} catch(FileNotFoundException e) {
			this.setUser("");
			this.setPassword("");
			return;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(in);
			prop.clear();
		}
	}
	
}
