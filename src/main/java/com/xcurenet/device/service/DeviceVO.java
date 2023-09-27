package com.xcurenet.device.service;

import lombok.Data;
import net.sf.json.JSONObject;

@Data
public class DeviceVO {

	private String deviceSeq;
	private String deviceIp;
	private String deviceNm;
	private String sshId;
	private String sshPw;

	private String comment;
	private String deviceType;
	private String deviceStatus;
	private int ipNoLogApplyVersion;
	private String ipNoLogApplyDate;
	private String uacsRuTime;
	private String uacsRtTime;
	private String uacsRStatus;
	private String uacsMuTime;
	private String uacsMtTime;
	private String uacsMStatus;
	private String ufdbMadeTime;
	private int advanceWarnRate;
	private int seriousWarnRate;
	private int deleteWarnRate;
	private String deviceHostKey;
	private String ruleVersion;
	private String ruleDate;
	private String useYn;
	private String createDt;

	private String currentDeviceStatus;
	private JSONObject currentDevice; // json obj

	private String hddSmsUseYn;
	private String hddNotifyUseYn;
	private String cpuSmsUseYn;
	private String cpuNotifyUseYn;
	private String memSmsUseYn;
	private String memNotifyUseYn;
	private String processSmsUseYn;
	private String processNotifyUseYn;
	private String interfaceSmsUseYn;
	private String interfaceNotifyUseYn;
	private int ruleApplyResult;
	private String ruleApplyMessage;
}
