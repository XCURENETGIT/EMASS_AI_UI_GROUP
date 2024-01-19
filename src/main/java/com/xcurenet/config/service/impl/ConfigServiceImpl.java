package com.xcurenet.config.service.impl;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.apache.commons.io.IOUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.mail.MailInfo;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.config.service.ConfigService;
import com.xcurenet.config.service.ConfigVO;

@Service("configService")
public class ConfigServiceImpl extends XcnAbstractDAO implements ConfigService {

	@Autowired
	private DataSource dataSource;

	@Override
	public List<ConfigVO> getConfList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.config.getConfigList");
	}

	@Override
	public ConfigVO getConf(final String confId) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.config.getConf", confId);
	}

	@Override
	public int setConf(final ConfigVO conf) {
		if ((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.config.isConfIdIdExist", conf) > 0) {
			return update("com.xcurenet.sqlmap.mappers.mysql.config.updateConfig", conf);
		} else {
			return update("com.xcurenet.sqlmap.mappers.mysql.config.insertConfig", conf);
		}
	}
	
	public void rollback(Connection con){
		if (con != null) {
			try {
				con.rollback();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	
	public void close(Connection con){
		if (con != null) {
			try {
				con.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

	@Override
	public boolean execute(ConfigVO conf) {

		String sqlPath = "/sqlmap/mappers/sql/";
		if (!Common.isWindow()) sqlPath = "/users/emassai/conf/";

		String filePath = String.format(sqlPath + "Update_Query_%s.sql", conf.getVal());
		if (Common.isWindow()) filePath = new File(new File(ConfigServiceImpl.class.getResource("").getPath()).getParentFile().getParentFile().getParent() + filePath).getAbsolutePath();
		Connection _con = null;
		try {
			 _con = DataSourceUtils.getConnection(dataSource);
			_con.setAutoCommit(false);
			ScriptUtils.executeSqlScript(_con, new FileSystemResource(filePath));
			_con.commit();
			return true;
		} catch (Exception e) {
			rollback(_con);
			e.printStackTrace();
		} finally {
			close(_con);
		}
		return false;
	}
	
	public void mailConfTest(String mail, HttpServletRequest request) throws Exception {
		String bodyStr = Prop.propFormat("setup.mail.test.content", Common.getLocale(request.getSession()));
		Document bodyDoc = Jsoup.parse(bodyStr);
		
		DateTimeFormatter yyyy_MM_dd = DateTimeFormat.forPattern("yyyy-MM-dd");
		
    	String nowTime = yyyy_MM_dd.print(DateTime.now()).toString();
		String directory = MailInfo.ALARM_PATH + nowTime + MailInfo.SLASH;
		Common.mkdirs(directory + MailInfo.SUCCESS);

		String name = Common.getNextID();
		
		String info = directory + name + ".info";
		String body = directory + name + ".body";

		StringBuffer infoSb = new StringBuffer();
		infoSb.append("SUBJECT : ").append(Prop.propFormat("setup.mail.test.subject", Common.getLocale(request.getSession()))).append(MailInfo.ENTER);
		infoSb.append("FROM : ").append(Config.getString("system.mail.addr")).append(MailInfo.ENTER);
		infoSb.append("TO : ").append(mail).append(MailInfo.ENTER);
		infoSb.append("BODY : ").append(body).append(MailInfo.ENTER);
		
		createInfo(bodyDoc.html(), body);
		createInfo(infoSb.toString(), info);
	}
	
	public void createInfo(String content, String path) throws Exception {
		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path), Common.UTF8));
			bw.write(content);
			bw.flush();
		} finally {
			IOUtils.closeQuietly(bw);
		}
	}
}
