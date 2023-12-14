package com.xcurenet.common.snmp.get;

import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.DecimalFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import com.xcurenet.common.snmp.SnmpMibLoader;
import com.xcurenet.common.snmp.SnmpUtil;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.filter.service.IpFilterVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 수집 장비와 DB서버의 신호를 관리한다. (수집 장비와의 통신은 SNMP로 정의한다.)
 *
 * @author jochangmin
 * @since 2012-11-3
 */
@Service
@Slf4j
@Scope("prototype")
public class GetSnmp {

	@Autowired
	private SnmpMibLoader snmpMibLoader;

	@Autowired
	private SnmpUtil snmpUtil;

	private static final String SNMP_OID_PREFIX = ".0";

	private static final int SNMP_OID_INDEX = 10000;

	private static final int OVERWRITE = 1;

	private static final int DELETE_ALL = 3;

	/**
	 * Device is Connection
	 *
	 * @param ip
	 * @return
	 */
	public boolean isConnection(String ip) {
		snmpUtil.setHost(ip);
		if (snmpUtil.getTable("sysInfoTable").size() == 0) return false;
		else return true;
	}

	public JSONArray getIifTrafficTable(String ip) {
		snmpUtil.setHost(ip);
		return snmpUtil.getTable("iifTrafficTable");
	}

	public JSONObject getDeviceStatus(final String ip) {
		JSONObject result = new JSONObject();
		try {
			snmpUtil.setHost(ip);
			if (!isConnection(ip)) {
				result.put("isConnection", false);
				return result;
			}
			result.put("isConnection", true);

			JSONArray sysInfoTable = snmpUtil.getTable("sysInfoTable");
			JSONArray sysConfigTable = snmpUtil.getTable("sysConfigTable");
			JSONArray cpuInfoTable = snmpUtil.getTable("cpuInfoTable");
			result.put("device", getSystemInfor(sysInfoTable, sysConfigTable, cpuInfoTable));

			JSONArray cpuLoadTable = snmpUtil.getTable("cpuLoadTable");
			JSONArray memInfoTable = snmpUtil.getTable("memInfoTable");
			result.put("cpuMemory", getCpuMemoryLoad(cpuLoadTable, memInfoTable));
			result.put("hdd", getHddInfo(snmpUtil.getTable("hddInfoTable")));
			result.put("process", getProcessInfo(snmpUtil.getTable("procEmassTable")));
			result.put("interface", getNetwork(snmpUtil.getTable("netConfTable")));

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			snmpUtil.close();
		}
		return result;
	}

	public JSONArray getProcessInfo(JSONArray procEmassTable) {
		JSONArray result = new JSONArray();
		for (int i = 0; i < procEmassTable.size(); i++) {
			JSONObject obj = procEmassTable.getJSONObject(i);
			if (Common.nvz(obj.get("procEmassProcCnt")) == 0) continue;
			result.add(obj);
		}
		return result;
	}

	public JSONObject getSystemInfor(JSONArray sysInfoTable, JSONArray sysConfigTable, JSONArray cpuInfoTable) {
		JSONObject result = new JSONObject();
		result.put("sysInfoIpAddr", "-");
		result.put("sysInfoUptime", "-");
		result.put("sysInfoDate", "-");
		result.put("sysInfoHostname", "-");
		result.put("sysConfigOS", "-");
		result.put("cpuInfoModel", "-");

		if (sysInfoTable.size() > 0) {
			JSONObject sysInfo = sysInfoTable.getJSONObject(0);
			result.put("sysInfoIpAddr", Common.nvl(sysInfo.get("sysInfoIpAddr")));
			result.put("sysInfoUptime", Common.nvl(sysInfo.get("sysInfoUptime")));
			result.put("sysInfoDate", Common.nvl(sysInfo.get("sysInfoDate")));
			result.put("sysInfoHostname", Common.nvl(sysInfo.get("sysInfoHostname")));
		}
		if (sysConfigTable.size() > 0) {
			JSONObject sysConfig = sysConfigTable.getJSONObject(0);
			result.put("sysConfigOS", Common.nvl(sysConfig.get("sysConfigOS")));
		}
		if (cpuInfoTable.size() > 0) {
			JSONObject cpuInfo = cpuInfoTable.getJSONObject(0);
			result.put("cpuInfoModel", Common.nvl(cpuInfo.get("cpuInfoModel")));
		}
		return result;
	}

	public JSONObject getCpuMemoryLoad(JSONArray cpuLoadTable, JSONArray memInfoTable) {
		JSONObject result = new JSONObject();
		result.put("cpuLoadUsage", "0");
		result.put("cpuLoadLimit", "0");
		result.put("memInfoTotal", "0 MB");
		result.put("memInfoUsed", "0 MB");
		result.put("memInfoFree", "0 MB");
		result.put("memInfoShared", "0 MB");
		result.put("memInfoCach", "0 MB");
		result.put("memInfoSlab", "0 MB");
		result.put("memInfoUsage", "0");
		result.put("memInfoLimit", "0");

		if (cpuLoadTable.size() > 0) {
			JSONObject cpu = cpuLoadTable.getJSONObject(0);
			result.put("cpuLoadUsage", Common.convertSnmpVal(Common.nvz(cpu.get("cpuLoadUsage"))));
			result.put("cpuLoadLimit", Common.nvz(cpu.get("cpuLoadLimit")));
		}

		if (memInfoTable.size() > 0) {
			JSONObject mem = memInfoTable.getJSONObject(0);
			result.put("memInfoTotal", memory(mem.get("memInfoTotal")));
			result.put("memInfoUsed", memory(mem.get("memInfoUsed")));
			result.put("memInfoFree", memory(mem.get("memInfoFree")));
			result.put("memInfoShared", memory(mem.get("memInfoShared")));
			result.put("memInfoCach", memory(mem.get("memInfoFree")));
			result.put("memInfoSlab", memory(mem.get("memInfoSlab")));
			result.put("memInfoUsage", Common.convertSnmpVal(Common.nvz(mem.get("memInfoUsage"))));
			result.put("memInfoLimit", Common.nvz(mem.get("memInfoLimit")));
		}
		return result;
	}

	public JSONArray getHddInfo(JSONArray hddInfoTable) {
		for (int i = 0; i < hddInfoTable.size(); i++) {
			JSONObject hdd = hddInfoTable.getJSONObject(i);
			hdd.put("hddInfoBlocks", hdd(hdd.get("hddInfoBlocks")));
			hdd.put("hddInfoAvail", hdd(hdd.get("hddInfoAvail")));
			hdd.put("hddInfoUsed", hdd(hdd.get("hddInfoUsed")));
			hdd.put("hddInfoUsage", Common.convertSnmpVal(Common.nvz(hdd.get("hddInfoUsage"))));
			hddInfoTable.set(i, hdd);
		}
		return hddInfoTable;
	}

	public JSONArray getNetwork(JSONArray netConfTable) {
		JSONArray result = new JSONArray();
		for (int i = 0; i < netConfTable.size(); i++) {
			JSONObject net = netConfTable.getJSONObject(i);
			if (Common.isEmpty(net.get("netConfDevice"))) continue;
			net.put("netConfRxByte", rxtx(net.get("netConfRxByte")));
			net.put("netConfTxByte", rxtx(net.get("netConfTxByte")));
			result.add(net);
		}
		return result;
	}

	public static String memory(Object sizez) {
		long size = Common.nvn(sizez);
		if (size <= 0) return "0 MB";
		final String[] units = new String[] {" KB", " MB", " GB", " TB", " PB", " EB", " ZB", " YB"};
		int digitGroups = (int) (Math.log10(size) / Math.log10(1024));
		return new DecimalFormat("#,##0.#").format(size / Math.pow(1024, digitGroups)) + units[digitGroups];
	}

	public static String rxtx(Object sizez) {
		long size = Common.nvn(sizez);
		if (size <= 0) return "0";
		final String[] units = new String[] {" Byte", " KB", " MB", " GB", " TB", " PB", " EB", " ZB", " YB"};
		int digitGroups = (int) (Math.log10(size) / Math.log10(1024));
		return new DecimalFormat("#,##0.#").format(size / Math.pow(1024, digitGroups)) + units[digitGroups];
	}

	public static String hdd(Object sizez) {
		long size = Common.nvn(sizez);
		if (size <= 0) return "0";
		final String[] units = new String[] {" MB", " GB", " TB", " PB", " EB", " ZB", " YB"};
		int digitGroups = (int) (Math.log10(size) / Math.log10(1024));
		return new DecimalFormat("#,##0.#").format(size / Math.pow(1024, digitGroups)) + units[digitGroups];
	}

	/**
	 * Get QoS
	 *
	 * @return
	 */
	public int getQoS(String ip) {
		snmpUtil.setHost(ip);
		JSONArray QoSRuleTable = snmpUtil.getTable("QoSRuleTable");
		if (QoSRuleTable.size() > 0) {
			return Common.nvz(QoSRuleTable.getJSONObject(0).get("qosRuleSpeed"));
		}
		return 0;
	}

	/**
	 * Set QoS
	 *
	 * @return
	 */
	public boolean setQoS(String ip, int qos) {
		snmpUtil.setHost(ip);
		JSONArray QoSRuleTable = snmpUtil.getTable("QoSRuleTable");
		if (QoSRuleTable.size() > 0) {
			return snmpUtil.setValue(snmpMibLoader.getOID("qosRuleSpeed") + "." + QoSRuleTable.getJSONObject(0).get("index"), qos);
		}
		return false;
	}

	/**
	 * Set Process Restart
	 *
	 * @return
	 */
	public boolean setProcessRestart(String ip, int index) {
		log.warn("Process Restart host:{} index:{} ", ip, index);
		snmpUtil.setHost(ip);
		JSONArray procEmassTable = snmpUtil.getTable("procEmassTable");
		if (procEmassTable.size() > 0) {
			return snmpUtil.setValue(snmpMibLoader.getOID("procEmassCommand") + "." + procEmassTable.getJSONObject(index).get("index"), 2);
		}
		return false;
	}

	/**
	 * Set Process Stop
	 *
	 * @return
	 */
	public boolean setProcessStop(String ip, int index) {
		log.warn("Process Stop host:{} index:{} ", ip, index);
		snmpUtil.setHost(ip);
		JSONArray procEmassTable = snmpUtil.getTable("procEmassTable");
		if (procEmassTable.size() > 0) {
			return snmpUtil.setValue(snmpMibLoader.getOID("procEmassCommand") + "." + procEmassTable.getJSONObject(index).get("index"), 1);
		}
		return false;
	}

	/**
	 * Set HDD Alarm
	 *
	 * @return
	 */
	public boolean setHddAlarm(String ip, int index, int hddNotifyLimit, int hddWarnLimit, int hddAlarmLimit) {
		log.warn("Set HDD Alarm host:{} index:{}, hddNotifyLimit:{}, hddWarnLimit:{}, hddAlarmLimit:{}", ip, index, hddNotifyLimit, hddWarnLimit, hddAlarmLimit);
		snmpUtil.setHost(ip);
		JSONArray hddInfoTable = snmpUtil.getTable("hddInfoTable");
		if (hddInfoTable.size() > 0) {

			JSONObject obj = hddInfoTable.getJSONObject(index);

			//hddNotifyLimit 관심 임계치
			//hddWarnLimit   주의 임계치
			//hddAlarmLimit  위험 임계치

			boolean notify = snmpUtil.setValue(snmpMibLoader.getOID("hddNotifyLimit") + "." + obj.get("index"), hddNotifyLimit); 	//관심
			boolean warn = snmpUtil.setValue(snmpMibLoader.getOID("hddWarnLimit") + "." + obj.get("index"), hddWarnLimit);  	 	//주의
			boolean alarm = snmpUtil.setValue(snmpMibLoader.getOID("hddAlarmLimit") + "." + obj.get("index"), hddAlarmLimit);  	//위험

			boolean set = snmpUtil.setValue(snmpMibLoader.getOID("hddSetLimit") + "." + obj.get("index"), hddAlarmLimit-5);
			boolean delete = snmpUtil.setValue(snmpMibLoader.getOID("hddDeleteLimit") + "." + obj.get("index"), hddAlarmLimit); 	//위험 임계치와 삭제 임계치를 같이 사용한다.
			if (set && notify && warn && alarm && delete) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Set CPU Alarm
	 *
	 * @return
	 */
	public boolean setCpuAlarm(String ip, int index, int cpuLoadLimit) {
		log.warn("Set CPU Alarm host:{} index:{}, cpuLoadLimit:{}", ip, index, cpuLoadLimit);
		snmpUtil.setHost(ip);
		JSONArray cpuLoadTable = snmpUtil.getTable("cpuLoadTable");
		if (cpuLoadTable.size() > 0) {

			JSONObject obj = cpuLoadTable.getJSONObject(index);

			boolean warn = snmpUtil.setValue(snmpMibLoader.getOID("cpuLoadLimit") + "." + obj.get("index"), cpuLoadLimit);  	 	//주의

			if (warn) return true;
		}
		return false;
	}
	
	/**
	 * Set Memory Alarm
	 *
	 * @return
	 */
	public boolean setMemoryAlarm(String ip, int index, int memInfoLimit) {
		log.warn("Set Memory Alarm host:{} index:{}, memInfoLimit:{}", ip, index, memInfoLimit);
		snmpUtil.setHost(ip);
		JSONArray memInfoTable = snmpUtil.getTable("memInfoTable");
		if (memInfoTable.size() > 0) {

			JSONObject obj = memInfoTable.getJSONObject(index);

			boolean warn = snmpUtil.setValue(snmpMibLoader.getOID("memInfoLimit") + "." + obj.get("index"), memInfoLimit);  	 	//주의

			if (warn) return true;
		}
		return false;
	}
	
	/**
	 * Set HDD Alarm CC버전용
	 *
	 * @return
	 */
	public boolean setHddAlarmCC(String ip, int hddNotifyLimit, int hddWarnLimit, int hddAlarmLimit) {
		log.warn("Set HDD Alarm CC host:{} hddNotifyLimit:{}, hddWarnLimit:{}, hddAlarmLimit:{}", ip, hddNotifyLimit, hddWarnLimit, hddAlarmLimit);
		snmpUtil.setHost(ip);
		JSONArray hddInfoTable = snmpUtil.getTable("hddInfoTable");
		if (hddInfoTable.size() > 0) {

			for ( int i = 0 ; i < hddInfoTable.size ( ) ; i++ )
			{
				JSONObject obj = hddInfoTable.getJSONObject(i);
				String hddInfoMountDir = obj.getString("hddInfoMountDir").toLowerCase();
				if ( hddInfoMountDir.equals ( "/users" ) )
				{
					String index = obj.getString("index");
					//hddNotifyLimit 관심 임계치
					//hddWarnLimit   주의 임계치
					//hddAlarmLimit  위험 임계치

					boolean notify = snmpUtil.setValue(snmpMibLoader.getOID("hddNotifyLimit") + "." + index, hddNotifyLimit); 	//알림
					boolean warn = snmpUtil.setValue(snmpMibLoader.getOID("hddWarnLimit") + "." + index, hddWarnLimit);  	 	//포화
					boolean alarm = snmpUtil.setValue(snmpMibLoader.getOID("hddAlarmLimit") + "." + index, hddAlarmLimit);  	//삭제

					boolean set = snmpUtil.setValue(snmpMibLoader.getOID("hddSetLimit") + "." + index, hddAlarmLimit-5);
					boolean delete = snmpUtil.setValue(snmpMibLoader.getOID("hddDeleteLimit") + "." + index, hddAlarmLimit); 	//위험 임계치와 삭제 임계치를 같이 사용한다.
					if (set && notify && warn && alarm && delete) {
						return true;
					}
				}
			}
		}
		return false;
	}

	public String getDeviceSysEID(String ip) {
		snmpUtil.setHost(ip);
		String result = null;
		try {
			JSONArray sysInfo = snmpUtil.getTable("sysInfoTable");
			if (sysInfo.size() > 0) {
				result = Common.nvl(sysInfo.getJSONObject(0).get("sysInfoUserId"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public boolean deleteRule(String ip) {
		//log.warn("Set HDD Alarm host:{} index:{}, hddNotifyLimit:{}, hddWarnLimit:{}, hddAlarmLimit:{}", ip, index, hddNotifyLimit, hddWarnLimit, hddAlarmLimit);
		if (Common.isEmpty(ip)) return false;

		//여기서 null 에러 발생
		String sysInfoUserId = getDeviceSysEID(ip);
		if (Common.isEmpty(sysInfoUserId)) return false;
		
		String emdcIpfInfoFileCtrl = snmpMibLoader.getOID("emdcIpfInfoFileCtrl");
		String oidStr = emdcIpfInfoFileCtrl + "." + sysInfoUserId + SNMP_OID_PREFIX;

		log.warn ( "DELETE Device Info IP : " + ip + "  OID : " + oidStr );
		if ( !snmpUtil.setValue ( oidStr, DELETE_ALL ) ) return false;
		
		if ( Config.isIPv6 ) {
			String emdcIpfV6InfoFileCtrl = snmpMibLoader.getOID("emdcIpfV6InfoFileCtrl");
			String oidV6Str = emdcIpfV6InfoFileCtrl + "." + sysInfoUserId + SNMP_OID_PREFIX;
			
			log.warn ( "DELETE Device Info IP : " + ip + " OIDV6 : " + oidV6Str );
			if ( !snmpUtil.setValue ( oidV6Str, DELETE_ALL ) ) return false;
		}

		return true;
	}

	public boolean setFilter(String index, String ip, IpFilterVO ipFilter) {

		if (Common.isEmpty(index)) return false;
		int indexVal = Common.nvz(index);

		String sysInfoUserId = getDeviceSysEID( ip );
		if (Common.isEmpty(sysInfoUserId)) return false;
		int sysInfoUserIdVal = Common.nvz( sysInfoUserId );

		String userIdVal = "." + Common.nvl ( (sysInfoUserIdVal * SNMP_OID_INDEX) + indexVal ) + SNMP_OID_PREFIX;
		
		if (getIPversion(ipFilter.getUserSIp()).equals("4") && getIPversion(ipFilter.getServerSIp()).equals("4")) {

			String oidStr = snmpMibLoader.getOID ( "emdcIpfRuleVersion" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidStr, Common.nvz ( ipFilter.getRuleVersion() ) ) ) return false;
	
			oidStr = snmpMibLoader.getOID ( "emdcIpfRuleSipFrom" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidStr, ipFilter.getUserSIp() ) ) return false;
	
			oidStr = snmpMibLoader.getOID ( "emdcIpfRuleSipTo" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidStr, ipFilter.getUserEIp() ) ) return false;
	
			oidStr = snmpMibLoader.getOID ( "emdcIpfRuleSportFrom" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidStr, Common.nvz ( ipFilter.getUserSPort() ) ) ) return false;
	
			oidStr = snmpMibLoader.getOID ( "emdcIpfRuleSportTo" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidStr, Common.nvz ( ipFilter.getUserEPort() ) ) ) return false;
	
			oidStr = snmpMibLoader.getOID ( "emdcIpfRuleDipFrom" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidStr, ipFilter.getServerSIp() ) ) return false;
	
			oidStr = snmpMibLoader.getOID ( "emdcIpfRuleDipTo" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidStr, ipFilter.getServerEIp() ) ) return false;
	
			oidStr = snmpMibLoader.getOID ( "emdcIpfRuleDportFrom" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidStr, Common.nvz ( ipFilter.getServerSPort() ) ) ) return false;
	
			oidStr = snmpMibLoader.getOID ( "emdcIpfRuleDportTo" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidStr, Common.nvz ( ipFilter.getServerEPort()) ) ) return false;
	
			oidStr = snmpMibLoader.getOID ( "emdcIpfRuleProtocol" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidStr, Common.nvz ( ipFilter.getProtocol() ) ) ) return false;
	
			oidStr = snmpMibLoader.getOID ( "emdcIpfRuleAction" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidStr, Common.nvz ( ipFilter.getAction() ) ) ) return false;
	
			log.warn ( "UPDATE IP Filter Rule OID : " + oidStr );
		} else if (Config.isIPv6 && getIPversion(ipFilter.getUserSIp()).equals("6") && getIPversion(ipFilter.getServerSIp()).equals("6")) {
			String oidV6Str = snmpMibLoader.getOID ( "emdcIpfV6RuleVersion" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidV6Str, Common.nvz ( ipFilter.getRuleVersion() ) ) ) return false;
			
			oidV6Str = snmpMibLoader.getOID ( "emdcIpfV6RuleSipFrom" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidV6Str, ipFilter.getUserSIp() ) ) return false;

			oidV6Str = snmpMibLoader.getOID ( "emdcIpfV6RuleSipTo" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidV6Str, ipFilter.getUserEIp() ) ) return false;

			oidV6Str = snmpMibLoader.getOID ( "emdcIpfV6RuleSportFrom" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidV6Str, Common.nvz ( ipFilter.getUserSPort() ) ) ) return false;

			oidV6Str = snmpMibLoader.getOID ( "emdcIpfV6RuleSportTo" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidV6Str, Common.nvz ( ipFilter.getUserEPort() ) ) ) return false;

			oidV6Str = snmpMibLoader.getOID ( "emdcIpfV6RuleDipFrom" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidV6Str, ipFilter.getServerSIp() ) ) return false;

			oidV6Str = snmpMibLoader.getOID ( "emdcIpfV6RuleDipTo" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidV6Str, ipFilter.getServerEIp() ) ) return false;

			oidV6Str = snmpMibLoader.getOID ( "emdcIpfV6RuleDportFrom" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidV6Str, Common.nvz ( ipFilter.getServerSPort() ) ) ) return false;

			oidV6Str = snmpMibLoader.getOID ( "emdcIpfV6RuleDportTo" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidV6Str, Common.nvz ( ipFilter.getServerEPort() ) ) ) return false;

			oidV6Str = snmpMibLoader.getOID ( "emdcIpfV6RuleProtocol" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidV6Str, Common.nvz ( ipFilter.getProtocol() ) ) ) return false;

			oidV6Str = snmpMibLoader.getOID ( "emdcIpfV6RuleAction" ) + userIdVal;
			if ( !snmpUtil.setValue ( oidV6Str, Common.nvz ( ipFilter.getAction() ) ) ) return false;
			
			log.warn ( "UPDATE IP Filter Rule OID : " + oidV6Str );
		}

		return true;
	}

	public boolean applyDeviceRule(String ip) {

		if (Common.isEmpty(ip)) return false;

		String sysInfoUserId = getDeviceSysEID(ip);
		if (Common.isEmpty(sysInfoUserId)) return false;

		String emdcIpfInfoFileCtrl = snmpMibLoader.getOID("emdcIpfInfoFileCtrl");
		String oidStr = emdcIpfInfoFileCtrl + "." + sysInfoUserId + SNMP_OID_PREFIX;
		if ( !snmpUtil.setValue ( oidStr, OVERWRITE ) ) return false;
		
		if ( Config.isIPv6 ) {
			String emdcIpfV6InfoFileCtrl = snmpMibLoader.getOID("emdcIpfV6InfoFileCtrl");
			String oidV6Str = emdcIpfV6InfoFileCtrl + "." + sysInfoUserId + SNMP_OID_PREFIX;
			if ( !snmpUtil.setValue ( oidV6Str, OVERWRITE ) ) return false;
		}

		return true;
	}

	public String getIPversion ( String ip )
	{
		String result = "";
		InetAddress address = null;
		try {
			address = InetAddress.getByName(ip);
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		if (address instanceof Inet6Address) {
			result = "6";
		} else if (address instanceof Inet4Address) {
			result = "4";
		}
		return result;
	}
}
