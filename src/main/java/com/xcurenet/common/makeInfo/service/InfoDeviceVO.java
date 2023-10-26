package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoDeviceVO {

	private int VERSION;
	private String EID;
	private String NAME;
	private String IP;
}
