package com.xcurenet.common.event;

import java.io.Serializable;

import lombok.Data;

@Data
public class Stock implements Serializable {
	private static final long serialVersionUID = 1L;

	private String code;
	private String name;
	private int nowToday = 0;
	private int oldPrice = -1;
	private String html;
	private String rate;
}
