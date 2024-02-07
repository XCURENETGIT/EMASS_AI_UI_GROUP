package com.xcurenet.common.snmp;

import com.xcurenet.common.util.config.Config;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import net.percederberg.mibble.*;
import net.percederberg.mibble.value.ObjectIdentifierValue;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.snmp4j.CommunityTarget;
import org.snmp4j.PDU;
import org.snmp4j.Snmp;
import org.snmp4j.TransportMapping;
import org.snmp4j.event.ResponseEvent;
import org.snmp4j.mp.SnmpConstants;
import org.snmp4j.smi.*;
import org.snmp4j.transport.DefaultUdpTransportMapping;
import org.snmp4j.util.DefaultPDUFactory;
import org.snmp4j.util.TableEvent;
import org.snmp4j.util.TableUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.Map.Entry;

@Slf4j
@Data
@Service
@Scope("prototype")
public class SnmpUtil {

	@Autowired
	private SnmpMibLoader snmpMibLoader;

	private String host;
	private int port = 7791;
	private int retries = 0;
	private int timeout = 10000;
	private String community = Config.getString("snmpa.community");
	//	private String community = "";
	private int snmpVersion = SnmpConstants.version2c;
	private TransportMapping<?> transport = null;

	/**
	 * get Snmp
	 *
	 * @return
	 */
	public Snmp getSnmp() {
		try {
			if (transport != null && transport.isListening()) transport.close();
			transport = new DefaultUdpTransportMapping();
			transport.listen();
		} catch (Exception e) {
			log.error("SNMP GET TRANSPORT ERROR HOST: {} {}", host, e.getMessage());
		}
		if (transport == null) return null;
		return new Snmp(transport);
	}

	public void close() {
		try {
			if (transport != null && transport.isListening()) {
				transport.close();
			}
		} catch (IOException e) {
			log.error("", e);
		}
	}

	/**
	 * get Target
	 *
	 * @return
	 */
	public CommunityTarget getTarget() {
		CommunityTarget comtarget = new CommunityTarget();
		comtarget.setCommunity(new OctetString(getCommunity()));
		comtarget.setVersion(getSnmpVersion());
		comtarget.setAddress(new UdpAddress(getHost() + "/" + getPort()));
		comtarget.setRetries(getRetries());
		comtarget.setTimeout(getTimeout());
		return comtarget;
	}

	public String getValue(String name, String tmp) {
		return getValue(snmpMibLoader.getOID(name));
	}

	/**
	 * OID to Value String
	 *
	 * @return
	 * @throws Exception
	 */
	public String getValue(String oid) {
		String result = null;
		if (oid == null) return result;

		Snmp _snmp = null;
		try {
			PDU pdu = new PDU();
			pdu.add(new VariableBinding(new OID(oid)));
			pdu.setType(PDU.GET);
			pdu.setRequestID(new Integer32(1));

			_snmp = getSnmp();
			ResponseEvent responseEvent = _snmp.get(pdu, getTarget());
			PDU responsePDU = responseEvent.getResponse();
			if (responsePDU != null) {
				int errorStatus = responsePDU.getErrorStatus();
				if (errorStatus == PDU.noError) {
					Vector<? extends VariableBinding> vbs = responsePDU.getVariableBindings();
					if (!vbs.isEmpty()) {
						VariableBinding vb = vbs.get(0);
						Variable ret = vb.getVariable();
						result = ret.toString();
					}
				}
			}
		} catch (IOException e) {
			log.error("", e);
		} finally {
			if (_snmp != null) try {
				_snmp.close();
			} catch (IOException e) {
				log.error("", e);
			}
		}
		return result;
	}

	/**
	 * getList
	 *
	 * @param oid_list
	 * @param community
	 * @return
	 * @throws Exception
	 * @throws Exception
	 */
	public JSONArray getList(String oid) {
		JSONArray result = new JSONArray();
		if (oid == null) return result;

		OID[] oids = new OID[]{new OID(oid)};
		Snmp _snmp = null;
		try {
			_snmp = getSnmp();
			TableUtils tUtils = new TableUtils(_snmp, new DefaultPDUFactory());
			List<TableEvent> events = tUtils.getTable(getTarget(), oids, null, null);
			for (TableEvent event : events) {
				if (event.isError()) return result;
				JSONObject item = new JSONObject();
				for (VariableBinding vb : event.getColumns()) {
					item.put("OID", vb.getOid().toString());
					item.put("VALUE", vb.getVariable().toString());
				}
				result.add(item);
			}
		} catch (Exception e) {
			log.error("", e);
		} finally {
			if (_snmp != null) try {
				_snmp.close();
			} catch (IOException e) {
				log.error("", e);
			}
		}
		return result;
	}

	/**
	 * load Mib File
	 *
	 * @param file
	 * @return
	 * @throws MibLoaderException
	 * @throws IOException
	 */
	private Mib loadMib(File file) {
		Mib result = null;

		try {
			MibLoader loader = new MibLoader();
			loader.addDir(file.getParentFile());
			result = loader.load(file);
		} catch (IOException | MibLoaderException e) {
			log.error("", e);
		}
		return result;
	}

	/**
	 * search Oid to Mib File
	 *
	 * @param name
	 * @param filePath
	 * @return
	 * @throws IOException
	 * @throws MibLoaderException
	 */
	public String getOid(String name, String filePath) {
		String oid = "";
		Mib mib = loadMib(new File(filePath));
		if (mib == null) return null;
		MibSymbol symbol = mib.getSymbol(name);
		if (symbol instanceof MibValueSymbol) {
			MibValue value = ((MibValueSymbol) symbol).getValue();
			if (value instanceof ObjectIdentifierValue) {
				oid = "." + ((ObjectIdentifierValue) value).toString() + "";
			}
		}
		return oid;
	}

	/**
	 * 테이블 형식으로 변환
	 *
	 * @param fieldMap
	 * @return
	 */
	private JSONArray toList(Map<String, List<String>> fieldMap) {
		JSONArray result = new JSONArray();
		JSONObject item = new JSONObject();
		boolean firstFlag = true;
		for (Entry<String, List<String>> entry : fieldMap.entrySet()) {
			List<String> val = entry.getValue();
			for (int i = 0; i < val.size(); i++) {
				item = new JSONObject();
				if (firstFlag) {
					item.put(entry.getKey(), val.get(i));
					result.add(item);
				} else {
					if (result.size() > i) {
						item = result.getJSONObject(i);
						item.put(entry.getKey(), val.get(i));
						result.set(i, item);
					}
				}
			}
			firstFlag = false;
		}
		return result;
	}

	public JSONArray getTable(String table) {
		return getTable(snmpMibLoader.getOID(table), snmpMibLoader.getTableEntryOid(table));
	}

	/**
	 * 데이터 베이스 형식으로 Row, Col 형식의 배열로 반환한다.
	 *
	 * @param tableOid
	 * @param field
	 * @return
	 */
	public JSONArray getTable(String tableOid, TreeMap<String, String> field) {
		JSONArray result = new JSONArray();
		if (tableOid == null) return result;
		OID[] oids = new OID[]{new OID(tableOid)};
		Snmp _snmp = null;
		try {
			_snmp = getSnmp();
			TableUtils tUtils = new TableUtils(_snmp, new DefaultPDUFactory());
			List<TableEvent> events = tUtils.getTable(getTarget(), oids, null, null);
			List<String> indexList = new ArrayList<String>();
			List<String> values = new ArrayList<String>();

			Map<String, List<String>> fieldMap = new HashMap<String, List<String>>();
			String fieldName = "";
			boolean firstFlag = true;
			for (TableEvent event : events) {
				if (!event.isError()) {
					for (VariableBinding vb : event.getColumns()) {
						String name = findFieldName(vb.getOid(), field);
						if (name == null) continue;
						String fieldOid = snmpMibLoader.getOID(name);
						String index = vb.getOid().format().substring(fieldOid.length());
						if (fieldName.isEmpty()) fieldName = name;
						if (!fieldName.equals(name)) {
							fieldMap.put(fieldName, values);
							fieldName = name;
							values = new ArrayList<String>();
							firstFlag = false;
						}
						values.add(vb.getVariable().toString());
						if (firstFlag) {
							indexList.add(index);
						}
					}
				}
			}
			if (!values.isEmpty()) // 마지막 추가
			{
				fieldMap.put(fieldName, values);
				fieldMap.put("index", indexList);
			}
			result = toList(fieldMap);
		} catch (Exception e) {
			//e.printStackTrace();
		} finally {
			if (_snmp != null) try {
				_snmp.close();
			} catch (IOException e) {
				log.error("", e);
			}
		}
		return result;
	}

	private String findFieldName(OID oid, TreeMap<String, String> field) {
		if (oid == null || oid.size() <= 1) {
			return null;
		}

		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < oid.size() - 1; i++) {
			sb.append(".").append(oid.get(i));
		}
		if (field.get(sb.toString()) == null) {
			return findFieldName(new OID(sb.toString()), field);
		}
		return field.get(sb.toString());
	}

	/**
	 * SNMP SET String
	 *
	 * @param oidStr
	 * @param value
	 * @return
	 */
	public boolean setValue(String oidStr, String value) {
		OID oid = new OID(oidStr);
		Variable var = new OctetString(value);
		VariableBinding varBind = new VariableBinding(oid, var);

		log.warn(String.format("HOST:%s\tOID:%s\t VALUE(string):%s", this.getHost(), oidStr, value));

		return setValue(varBind);
	}

	/**
	 * SNMP SET Integer32
	 *
	 * @param oidStr
	 * @param value
	 * @return
	 */
	public boolean setValue(String oidStr, int value) {
		OID oid = new OID(oidStr);
		Variable var = new Integer32(value);
		VariableBinding varBind = new VariableBinding(oid, var);
		log.warn(String.format("HOST:%s\tOID:%s\t VALUE(integer):%s", this.getHost(), oidStr, value));
		return setValue(varBind);
	}

	/**
	 * SNMP SET
	 *
	 * @param varBind
	 * @return
	 */
	private boolean setValue(VariableBinding varBind) {
		boolean result = false;
		Snmp snmp = null;
		try {
			TransportMapping<?> transport = new DefaultUdpTransportMapping();
			transport.listen();

			PDU pdu = new PDU();
			pdu.add(varBind);
			pdu.setType(PDU.SET);
			pdu.setRequestID(new Integer32(1));

			snmp = new Snmp(transport);
			ResponseEvent response = snmp.set(pdu, getTarget());
			if (response != null) {
				PDU responsePDU = response.getResponse();
				if (responsePDU != null) {
					int errorStatus = responsePDU.getErrorStatus();
					if (errorStatus == PDU.noError) {
						log.warn("SNMP SET SUCCESS : " + varBind);
						result = true;
					} else {
						log.error("SNMP SET FAIL : " + responsePDU.getErrorStatusText());
					}
				}
			}
		} catch (Exception e) {
			log.error("", e);
			result = false;
		} finally {
			if (snmp != null) try {
				snmp.close();
			} catch (Exception e2) {
			}
		}
		return result;
	}

	/**
	 * SNMP %(률) 계산
	 *
	 * @param fileSize
	 * @return
	 */
	public static float convertSnmpVal(int rate) {
		return (float) (Math.round(((float) rate / 100) * 100) / 100.0);
	}
}
