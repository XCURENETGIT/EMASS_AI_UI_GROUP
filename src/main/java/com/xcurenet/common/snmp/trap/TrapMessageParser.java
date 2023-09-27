package com.xcurenet.common.snmp.trap;

import java.util.Vector;

import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.snmp4j.smi.VariableBinding;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Slf4j
public class TrapMessageParser {

	public static final String TRAP_MESSAGE_PREFIX = "|";
	public static final String TRAP_MESSAGE_CPU = "CPU";
	public static final String TRAP_MESSAGE_MEM = "MEM";
	public static final String TRAP_MESSAGE_HDD = "HDD";
	public static final String TRAP_MESSAGE_CLR = "CLR"; // 삭제
	public static final String TRAP_MESSAGE_SVC = "SVC";
	public static final String TRAP_MESSAGE_LINK = "LINK";
	public static final String TRAP_MESSAGE_SNMP = "SNMP";
	public static final String TRAP_MESSAGE_PROC = "PROC";
	public static final String TRAP_MESSAGE_TRA = "TRA";
	public static final String TRAP_MESSAGE_INT = "ITG"; //무결성 훼손
	
	private static DateTimeFormatter yyyyMMddHHmmss = DateTimeFormat.forPattern ( "yyyyMMddHHmmss" );

	private static final int TRAP_BLANK_LINE = 2;
	private int message_total_size = 0;
	private String messageType;
	private Vector<?> vars;
	private String sourceIP;

	public TrapMessageParser(String sourceIP, Vector<?> vars) {
		this.sourceIP = sourceIP;
		this.vars = vars;
		this.init();
	}

	public String getMessageType() {
		return this.messageType;
	}

	public JSONObject messageParser() {
		JSONArray data = new JSONArray();
		for (int i = 0; i < message_total_size; i++) {
			String line = getLine(i);
			if (line == null) continue;

			String[] cols = line.split("\\" + TRAP_MESSAGE_PREFIX);
			if (cols.length > 3) {
				JSONObject item = new JSONObject();
				try {
					if (Common.isEquals(cols[1], TRAP_MESSAGE_CPU)) item = getCPUParser(cols);
					else if (Common.isEquals(cols[1], TRAP_MESSAGE_MEM)) item = getMEMParser(cols);
					else if (Common.isOrEquals(cols[1], TRAP_MESSAGE_HDD, TRAP_MESSAGE_CLR)) item = getHDDCLRParser(cols);
					else if (Common.isEquals(cols[1], TRAP_MESSAGE_SVC)) item = getSVCParser(cols);
					else if (Common.isEquals(cols[1], TRAP_MESSAGE_LINK)) item = getLINKParser(cols);
					else if (Common.isEquals(cols[1], TRAP_MESSAGE_SNMP)) item = getSNMPParser(cols);
					else if (Common.isEquals(cols[1], TRAP_MESSAGE_PROC)) item = getPROCParser(cols);
					else if (Common.isEquals(cols[1], TRAP_MESSAGE_TRA)) item = getTRAParser(cols);
				} catch (Exception e) {
					e.printStackTrace();
				}
				data.add(item);
			}
		}
		log.info("[SNMP TRAP] Message Parser result : " + data);

		JSONObject result = new JSONObject();
		result.put("DEVICE_IP", this.sourceIP);
		result.put("MSG_TYPE", this.messageType);
		result.put("MSG_SIZE", this.message_total_size);
		result.put("MSG_DATA", data);

		return result;
	}

	/**
	 * TRA Message Parser
	 *
	 * @return
	 */
	public JSONObject getTRAParser(String[] cols) {
		JSONObject item = new JSONObject();
		item.put("name", cols[1]);
		item.put("iifTrafficPort", cols[2]);
		item.put("status", cols[3]);
		item.put("ipAddr", cols[4]);
		item.put("master_ip", this.sourceIP);
		item.put("level", (Common.isEquals(item.get("status"), "0") == true ? "I" : "E"));
		return item;
	}

	/**
	 * SNMP Message Parser
	 *
	 * @return
	 */
	public JSONObject getSNMPParser(String[] cols) {
		JSONObject item = new JSONObject();
		item.put("name", cols[1]);
		item.put("status", cols[2]);
		item.put("ipAddr", cols[3]);
		item.put("master_ip", this.sourceIP);
		item.put("level", (Common.isEquals(item.get("status"), "up") == true ? "I" : "E"));
		return item;
	}

	/**
	 * PROC Message Parser
	 *
	 * @return
	 */
	public JSONObject getPROCParser(String[] cols) {
		JSONObject item = new JSONObject();
		item.put("name", cols[1]);
		item.put("module", cols[2]);
		item.put("procEmassProcName", cols[3]);
		item.put("status", cols[4]);
		item.put("ipAddr", cols[5]);
		item.put("master_ip", this.sourceIP);

		String status_level = "";
		if (Common.isEquals(item.get("status"), "0")) status_level = "I"; // 정상
		else if (Common.isEquals(item.get("status"), "2")) status_level = "W"; // 미작동
		else if (Common.isEquals(item.get("status"), "1")) status_level = "E"; // 비정상
		item.put("level", status_level);
		return item;
	}

	/**
	 * CPU Message Parser
	 *
	 * @return
	 */
	public JSONObject getCPUParser(String[] cols) {
		JSONObject item = new JSONObject();
		item.put("name", cols[1]);
		item.put("cpuLoadCpuName", cols[2]);
		item.put("cpuLoadUsage", cols[3]);
		item.put("cpuLoadLimit", cols[4]);
		item.put("ipAddr", cols[6]);
		item.put("master_ip", this.sourceIP);
		item.put("level", "W");
		return item;
	}

	/**
	 * MEM Message Parser
	 *
	 * @return
	 */
	public JSONObject getMEMParser(String[] cols) {
		JSONObject item = new JSONObject();
		item.put("name", cols[1]);
		item.put("memInfoTotal", cols[3]);
		item.put("memInfoUsed", cols[4]);
		item.put("memInfoFree", cols[5]);
		item.put("memInfoShared", cols[6]);
		item.put("memInfoBuff", cols[7]);
		item.put("memInfoCach", cols[8]);
		item.put("memInfoUsage", cols[10]);
		item.put("memInfoLimit", cols[11]);
		item.put("ipAddr", cols[13]);
		item.put("master_ip", this.sourceIP);
		item.put("level", "W");
		return item;
	}

	/**
	 * HDD/CLR Message Parser
	 *
	 * @return
	 */
	public JSONObject getHDDCLRParser(String[] cols) {
		JSONObject item = new JSONObject();
		if (cols[2].equals("hdfs")) {
			item.put("name", cols[1]);
			item.put("hddInfoMountDir", cols[2]);
			item.put("dtDbHdFsStTotal", cols[3]);
			item.put("dtDbHdfsStCapacity", cols[4]);
			item.put("dtDbHdfsStRemining", cols[5]);
			item.put("dtDbHdfsStUsed", cols[6]);
			item.put("dtDbHdfsStUsage", cols[7]);
			item.put("dtDbHdfsStUndRepl", cols[8]);
			item.put("dtDbHdfsStCorrupt", cols[9]);
			item.put("dtDbHdfsStMissing", cols[10]);
			item.put("dtDbHdfsNotiLimit", cols[11]);
			item.put("dtDbHdfsClearLimit", cols[12]);
			item.put("dtDbHdfsSetLimit", cols[13]);
			item.put("dtDbHdfsWarnLimit", cols[14]);
			item.put("dtDbHdfsAlarLimit", cols[15]);
			item.put("status", cols[16]);
			item.put("ipAddr", cols[17]);
		} else {
			item.put("name", cols[1]);
			item.put("hddInfoMountDir", cols[2]);
			item.put("hddInfoBlocks", cols[3]);
			item.put("hddInfoAvail", cols[4]);
			item.put("hddInfoUsed", cols[5]);
			item.put("hddInfoUsage", cols[6]);
			item.put("hddNotifyLimit", cols[7]);
			item.put("hddDeleteLimit", cols[8]);
			item.put("hddSetLimit", cols[9]);
			item.put("hddWarmLimit", cols[10]);
			item.put("hddAlarmLimit", cols[11]);
			item.put("status", cols[12]);
			item.put("ipAddr", cols[13]);
		}
		item.put("master_ip", this.sourceIP);
		String status_level = "I";
		if (Common.isEquals(item.get("status"), "NOTIFY")) status_level = "I";
		else if (Common.isEquals(item.get("status"), "WARN")) status_level = "W";
		else if (Common.isEquals(item.get("status"), "ALARM")) status_level = "E";
		item.put("level", status_level);

		return item;
	}

	/**
	 * SVC Message Parser
	 *
	 * @return
	 */
	public JSONObject getSVCParser(String[] cols) {
		JSONObject item = new JSONObject();
		item.put("name", cols[1]);
		item.put("svcGroupName", cols[2]);
		item.put("svcGroupProcName", cols[3]);
		item.put("status", cols[4]);
		item.put("ipAddr", cols[5]);
		item.put("master_ip", this.sourceIP);
		item.put("level", (Common.isEquals(item.get("status"), "0") == true ? "I" : "E"));
		return item;
	}

	/**
	 * LINK Message Parser
	 *
	 * @return
	 */
	public JSONObject getLINKParser(String[] cols) {
		JSONObject item = new JSONObject();
		item.put("name", cols[1]);
		item.put("iifTrafficPort", cols[2]);
		item.put("iifTrafficState", cols[3]);
		item.put("ipAddr", cols[4]);
		item.put("master_ip", this.sourceIP);
		item.put("level", (Common.isEquals(item.get("iifTrafficState"), "up") == true ? "I" : "E"));
		return item;
	}

	public JSONObject messageRedefined(JSONObject item) {
		String title = "";
		String content = "";
		String trapMessage = Common.nvl(item.get("name"));
		if (Common.isEquals(trapMessage, TRAP_MESSAGE_HDD)) {
			if (Common.isEquals(item.get("hddInfoMountDir"), "hdfs")) {
				title = Prop.propFormat("trap.message.hdfs.title", Common.getLocale());
				content = Prop.propFormat("trap.message.hdfs.content", Common.getLocale(), (item.getInt("dtDbHdfsStUsage") / 100.0));
			} else {
				title = Prop.propFormat("trap.message.hdd.title", Common.getLocale());
				content = Prop.propFormat("trap.message.hdd.content", Common.getLocale(), item.get("hddInfoMountDir"), (item.getInt("hddInfoUsage") / 100.0));
			}
		} else if (Common.isEquals(trapMessage, TRAP_MESSAGE_SVC)) {
			String status = Prop.propFormat("trap.message.svc.status1", Common.getLocale());
			if (Common.isEquals(item.get("status"), "0")) status = Prop.propFormat("trap.message.svc.status0", Common.getLocale());
			title = Prop.propFormat("trap.message.svc.title", Common.getLocale(), status);
			content = Prop.propFormat("trap.message.svc.content", Common.getLocale(), (item.get("svcGroupName") + "_" + item.get("svcGroupProcName")), status);
		} else if (Common.isEquals(trapMessage, TRAP_MESSAGE_PROC)) {
			String status = Prop.propFormat("trap.message.proc.status1", Common.getLocale());
			if (Common.isEquals(item.get("status"), "0")) status = Prop.propFormat("trap.message.proc.status0", Common.getLocale());
			title = Prop.propFormat("trap.message.proc.title", Common.getLocale(), status);
			content = Prop.propFormat("trap.message.proc.content", Common.getLocale(), (item.get("module") + "_" + item.get("procEmassProcName")), status);
		} else if (Common.isEquals(trapMessage, TRAP_MESSAGE_LINK)) {
			title = Prop.propFormat("trap.message.link.title", Common.getLocale(), item.get("iifTrafficState"));
			content = Prop.propFormat("trap.message.link.content", Common.getLocale(), item.get("iifTrafficPort"), item.get("iifTrafficState"));
		} else if (Common.isEquals(trapMessage, TRAP_MESSAGE_SNMP)) {
			title = Prop.propFormat("trap.message.snmp.title", Common.getLocale(), item.get("status"));
			content = Prop.propFormat("trap.message.snmp.content", Common.getLocale(), item.get("status"));
		} else if (Common.isEquals(trapMessage, TRAP_MESSAGE_TRA)) {
			String status = Prop.propFormat("trap.message.tra.status1", Common.getLocale());
			if (Common.isEquals(item.get("status"), "0")) status = Prop.propFormat("trap.message.tra.status0", Common.getLocale());
			title = Prop.propFormat("trap.message.tra.title", Common.getLocale(), item.get("iifTrafficPort"));
			content = Prop.propFormat("trap.message.tra.content", Common.getLocale(), item.get("iifTrafficPort"), status);
		} else if (Common.isEquals(trapMessage, TRAP_MESSAGE_MEM)) {
			title = Prop.propFormat("trap.message.mem.title", Common.getLocale());
			content = Prop.propFormat("trap.message.mem.content", Common.getLocale(), item.getInt("memInfoUsage") / 100.0);
		} else if (Common.isEquals(trapMessage, TRAP_MESSAGE_CPU)) {
			title = Prop.propFormat("trap.message.cpu.title", Common.getLocale());
			content = Prop.propFormat("trap.message.cpu.content", Common.getLocale(), item.getInt("cpuLoadUsage") / 100.0);
		}

		JSONObject result = new JSONObject();
		result.put("deviceIp", item.get("ipAddr"));
		result.put("masterIp", item.get("master_ip"));
		result.put("devision", item.get("name"));
		result.put("eventLevel", item.get("level"));
		result.put("title", title);
		result.put("content", content);
		return result;
	}
	
	/**
	 * 장비의 무결성이 훼손된 경우 메시지
	 * @return
	 */
	public JSONObject getIntegrityMessage( )
	{
		String checkDate = "";
		String deviceName = "";
		JSONArray data = new JSONArray ( );
		for ( int i = 0 ; i < message_total_size ; i++ )
		{
			String line = getLine ( i );
			if ( line == null ) continue;
			if ( i == 0 ) continue;//Message Header

			String[] lines = line.split ( "\\" + TRAP_MESSAGE_PREFIX );
			if ( i == 1 ) //Message Info
			{
				checkDate = yyyyMMddHHmmss.parseDateTime ( lines[0] ).toString ( "yyyy-MM-dd HH:mm:ss" );
				deviceName = lines[1];
				continue;
			}

			JSONObject item = new JSONObject ( );
			item.put ( "moudle", lines[0] );
			item.put ( "path", lines[1] );
			data.add ( item );
		}

		JSONObject result = new JSONObject ( );
		result.put ( "DEVICE_IP", this.sourceIP );
		result.put ( "MSG_TYPE", this.messageType );
		result.put ( "MSG_SIZE", this.message_total_size );
		result.put ( "CHECK_DATE", checkDate );
		result.put ( "DEVICE_HOST", deviceName );
		result.put ( "MSG_DATA", data );
		return result;
	}

	/**
	 * Trap Receiver Debug Code
	 *
	 * @param event
	 */
	private void init() {
		message_total_size = vars.size() - TRAP_BLANK_LINE;
		if (message_total_size > 0) {
			String variable = getLine(0);
			if (variable != null && variable.indexOf(TRAP_MESSAGE_PREFIX) > -1) {
				String[] line = variable.split("\\" + TRAP_MESSAGE_PREFIX);
				if (line.length > 0) this.messageType = line[1];
			}
		}
	}

	private String getLine(int idx) {
		idx = idx + TRAP_BLANK_LINE;
		if (vars.size() > idx) return ((VariableBinding) vars.get(idx)).getVariable().toString().trim();
		else return null;
	}

}
