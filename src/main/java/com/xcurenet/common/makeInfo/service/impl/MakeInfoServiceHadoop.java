package com.xcurenet.common.makeInfo.service.impl;

import java.io.IOException;
import java.util.List;

import com.xcurenet.common.makeInfo.service.InfoVersionVO;
import com.xcurenet.common.util.MongoUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.device.service.DeviceService;
import com.xcurenet.emass.message.component.AttachFile;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Slf4j
@Service
public class MakeInfoServiceHadoop extends XcnAbstractDAO {

	@Autowired
	public DeviceService deviceService;

	@Autowired
	MongoUtil mongoUtil;

	
	public long getTableCurrentVersion(String tableName) {
//		String version = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".makeInfo.getTableCurrentVersion", tableName);
		InfoVersionVO info = mongoUtil.maxValue(tableName, InfoVersionVO.class);
		if( info == null) return 0;
		return info.getVersion();
	}
	
	public long addVersion(String tableName, long version) {
		InfoVersionVO info = new InfoVersionVO();
		info.setVersion(version+1);
		info.setTableName(tableName);
		info.setId("system");
		info.setComments("");
		mongoUtil.insert(info, tableName);
		return 1;
		//return insert("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".makeInfo.addVersion", param);
	}

	
	public int addInfoUser() {
		log.info("[MAKE INFO] User information apply start");
		long version = getTableCurrentVersion("INFO_USER");
		appendData( version, "getInfoUser", "addInfoUser", "INFO_USER");
		addVersion("INFO_USER", version);
		
		version = getTableCurrentVersion("INFO_IP");
		appendData( version, "getInfoIp", "addInfoIp","INFO_IP" );
		addVersion("INFO_IP", version);
		
		version = getTableCurrentVersion("INFO_EMAILADDR");
		JSONObject param = new JSONObject();
		param.put("currentVersion", version);


		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		appendData( param, "getInfoEmailAddr", "addInfoEmailAddr","INFO_EMAILADDR" );
		addVersion("INFO_EMAILADDR", version);

		addInfoRegExp();
		log.info("[MAKE INFO] User information apply end");
		return 0;
	}
	
	public long addInfoDevice() {
		log.info("[MAKE INFO] Device information apply start");

		Long version = getTableCurrentVersion("INFO_DEVICE");
		appendData( version, "getInfoDevice", "addInfoDevice","INFO_DEVICE");
		addVersion("INFO_DEVICE", version);

		log.info("[MAKE INFO] Device information apply end");
		return 0;
	}

	
	public int addInfoHoliday() {
		log.info("[MAKE INFO] Holiday information apply start");

		long version = getTableCurrentVersion("INFO_HOLIDAY");
		appendData( version, "getInfoHoliDay", "addInfoHoliDay","INFO_HOLIDAY");
		addVersion("INFO_HOLIDAY", version);

		log.info("[MAKE INFO] Holiday information apply end");
		return 0;
	}

	
	public int addInfoWorkDay() {
		log.info("[MAKE INFO] WorkDay information apply start");

		long version = getTableCurrentVersion("INFO_WORKDAY");
		appendData( version, "getInfoWorkDay", "addInfoWorkDay","INFO_WORKDAY" );
		addVersion("INFO_WORKDAY", version);

		log.info("[MAKE INFO] WorkDay information apply end");
		return 0;
	}

	
	public int addInfoIpRange() {
		log.info("[MAKE INFO] Busi IpRange information apply start");

		long version = getTableCurrentVersion("INFO_IPRANGE");
		appendData( version, "getInfoIpRange", "addInfoIpRange","INFO_IPRANGE" );
		addVersion("INFO_IPRANGE", version);

		log.info("[MAKE INFO] Busi IpRange information apply end");
		return 0;
	}
	

	public int addInfoIpRangeDept() {
		log.info("[MAKE INFO] Dept IpRange information apply start");

		long version = getTableCurrentVersion("INFO_IPRANGE_DEPT");
		appendData( version, "getInfoIpRangeDept", "addInfoIpRangeDept","INFO_IPRANGE_DEPT" );
		addVersion("INFO_IPRANGE_DEPT", version);

		log.info("[MAKE INFO] Dept IpRange information apply end");
		return 0;
	}

	
	public int addInfoKeyword() {
		log.info("[MAKE INFO] Keyword information apply start");

		long version = getTableCurrentVersion("INFO_KEYWORD");
		appendData( version, "getInfoKeyword", "addInfoKeyword","INFO_KEYWORD" );
		addVersion("INFO_KEYWORD", version);

		log.info("[MAKE INFO] Keyword information apply end");
		return 0;
	}

	
	public int addInfoRegExp() {
		log.info("[MAKE INFO] RegExp information apply start");
		
		long version = getTableCurrentVersion("INFO_PRIVATE");
		appendData( version, "getInfoRegExp", "addInfoRegExp","INFO_PRIVATE" );
		addVersion("INFO_PRIVATE", version);
		
		log.info("[MAKE INFO] RegExp information apply end");
		return 0;
	}

	
	public int addInfoNoLog() {
		log.info("[MAKE INFO] NoLogFilter information apply start");
		
		long version = getTableCurrentVersion("INFO_NOLOG_URL");
		appendData( version, "getInfoNoLogUrl", "addInfoNoLogUrl","INFO_NOLOG_URL" );
		addVersion("INFO_NOLOG_URL", version);
		save(Common.toJSONArray(selectList("com.xcurenet.sqlmap.mappers.mysql.makeInfo.getInfoNoLogUrl")));
		
		version = getTableCurrentVersion("INFO_NOLOG_SUBJECT");
		appendData( version, "getInfoNoLogSubject", "addInfoNoLogSubject","INFO_NOLOG_SUBJECT" );
		addVersion("INFO_NOLOG_SUBJECT", version);
		
		version = getTableCurrentVersion("INFO_NOLOG_SIZE");
		appendData( version, "getInfoNoLogSize", "addInfoNoLogSize","INFO_NOLOG_SIZE" );
		addVersion("INFO_NOLOG_SIZE", version);
		
		version = getTableCurrentVersion("INFO_NOLOG_ID");
		appendData( version, "getInfoNoLogId", "addInfoNoLogId" ,"INFO_NOLOG_ID");
		addVersion("INFO_NOLOG_ID", version);
		
		version = getTableCurrentVersion("INFO_NOLOG_DOMAIN");
		appendData( version, "getInfoNoLogDomain", "addInfoNoLogDomain","INFO_NOLOG_DOMAIN" );
		addVersion("INFO_NOLOG_DOMAIN", version);
		
		log.info("[MAKE INFO] NoLogFilter information apply end");
		return 0;
	}
	
	@SuppressWarnings("unchecked")
	public void save(JSONArray data){
		String filePath = "/info/nolog_url.json";
		try {
			new AttachFile(filePath, null).upload(toJsonString(data));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private <T> String toJsonString(final List<T> data) throws IOException, JsonGenerationException, JsonMappingException {
		ObjectMapper mapper = new ObjectMapper();
		return mapper.writeValueAsString(data);
	}

	public void appendData ( Long currentVersion, String select, String insert, String collectionName)
	{
		long pageSize = 10000;
		JSONObject param = new JSONObject ( );
		param.put ( "pageSize", pageSize );

		long offset = 0;
		while ( true )
		{
			param.put ( "offset", offset );
			//JSONArray data = DBUtils.getList ( select, param );

			//mysql 쿼리를 해야돼서 selectListMySQL을 사용, 쿼리문은 phoenix 쪽에 있으므로 mappers.phoenix.makeInfo로 함

			JSONArray data = Common.toJSONArray(selectListMySQL("com.xcurenet.sqlmap.mappers.mysql.makeInfo." + select, param));
			if ( data.size ( ) == 0 ) break;
			offset += data.size ( );

			try
			{
				long version = Common.nvn ( currentVersion ) + 1;
				//sql = DBUtils.getSqlSession ( DBType.PHOENIX, true );
				for ( int i = 0 ; i < data.size ( ) ; i++ )
				{
					JSONObject obj = data.getJSONObject ( i );
					obj.put ( "VERSION", version );
					//sql.insert ( insert, obj );

					mongoUtil.insert(obj, collectionName);
					//insert("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".makeInfo." + insert, obj);
				}
				if ( data.size ( ) < pageSize ) break;
			}
			finally
			{
				//if ( sql != null ) try{ sql.commit ( ); }catch (Exception e2) { }
				//if ( sql != null ) try{ sql.close ( ); }catch (Exception e2) { }
			}
		}
	}
	public void appendData ( JSONObject param, String select, String insert, String collectionName )
	{
		long pageSize = 10000;
		param.put ( "pageSize", pageSize );

		long offset = 0;
		while ( true )
		{
			param.put ( "offset", offset );
			//JSONArray data = DBUtils.getList ( select, param );

			//mysql 쿼리를 해야돼서 selectListMySQL을 사용, 쿼리문은 phoenix 쪽에 있으므로 mappers.phoenix.makeInfo로 함

			JSONArray data = Common.toJSONArray(selectListMySQL("com.xcurenet.sqlmap.mappers.mysql.makeInfo." + select, param));
			if ( data.size ( ) == 0 ) break;
			offset += data.size ( );

			try
			{
				long version = Common.nvn ( param.get("currentVersion") ) + 1;
				for ( int i = 0 ; i < data.size ( ) ; i++ )
				{
					JSONObject obj = data.getJSONObject ( i );
					obj.put ( "VERSION", version );
					mongoUtil.insert(obj, collectionName);
					//insert("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".makeInfo." + insert, obj);
				}
				if ( data.size ( ) < pageSize ) break;
			}
			finally
			{
			}
		}
	}


	
//	public void appendData ( Long currentVersion, String select, String insert)
//	{
//		long pageSize = 10000;
//		JSONObject param = new JSONObject ( );
//		param.put ( "pageSize", pageSize );
//
//		long offset = 0;
//		while ( true )
//		{
//			param.put ( "offset", offset );
//			//JSONArray data = DBUtils.getList ( select, param );
//
//			//mysql 쿼리를 해야돼서 selectListMySQL을 사용, 쿼리문은 phoenix 쪽에 있으므로 mappers.phoenix.makeInfo로 함
//
//			JSONArray data = Common.toJSONArray(selectListMySQL("com.xcurenet.sqlmap.mappers.mysql.makeInfo." + select, param));
//			if ( data.size ( ) == 0 ) break;
//			offset += data.size ( );
//
//			try
//			{
//				long version = Common.nvn ( currentVersion ) + 1;
//				//sql = DBUtils.getSqlSession ( DBType.PHOENIX, true );
//				for ( int i = 0 ; i < data.size ( ) ; i++ )
//				{
//					JSONObject obj = data.getJSONObject ( i );
//					obj.put ( "VERSION", version );
//					//sql.insert ( insert, obj );
//
//					insert("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".makeInfo." + insert, obj);
//				}
//				if ( data.size ( ) < pageSize ) break;
//			}
//			finally
//			{
//				//if ( sql != null ) try{ sql.commit ( ); }catch (Exception e2) { }
//				//if ( sql != null ) try{ sql.close ( ); }catch (Exception e2) { }
//			}
//		}
//	}
//	public void appendData ( JSONObject param, String select, String insert )
//	{
//		long pageSize = 10000;
//		param.put ( "pageSize", pageSize );
//
//		long offset = 0;
//		while ( true )
//		{
//			param.put ( "offset", offset );
//			//JSONArray data = DBUtils.getList ( select, param );
//
//			//mysql 쿼리를 해야돼서 selectListMySQL을 사용, 쿼리문은 phoenix 쪽에 있으므로 mappers.phoenix.makeInfo로 함
//
//			JSONArray data = Common.toJSONArray(selectListMySQL("com.xcurenet.sqlmap.mappers.mysql.makeInfo." + select, param));
//			if ( data.size ( ) == 0 ) break;
//			offset += data.size ( );
//
//			try
//			{
//				long version = Common.nvn ( param.get("currentVersion") ) + 1;
//				for ( int i = 0 ; i < data.size ( ) ; i++ )
//				{
//					JSONObject obj = data.getJSONObject ( i );
//					obj.put ( "VERSION", version );
//					insert("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".makeInfo." + insert, obj);
//				}
//				if ( data.size ( ) < pageSize ) break;
//			}
//			finally
//			{
//			}
//		}
//	}
}
