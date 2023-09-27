package com.xcurenet.common.vo;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class XcnResponseVO {

	private final boolean success;

	private final XcnRspCode code;

	private final Object data;

	private final long total;

	private String message;

	public XcnResponseVO(final XcnRspCode rspCode) {
		this.code = rspCode;
		this.data = new JSONObject();
		this.success = this.code == XcnRspCode.OK ? true : false;
		this.total = 0;
	}

	public XcnResponseVO(final XcnRspCode rspCode, final String data) {
		this.code = rspCode;
		this.data = data;
		this.success = this.code == XcnRspCode.OK ? true : false;
		this.total = 0;
	}

	public XcnResponseVO(final XcnRspCode rspCode, final boolean data) {
		this.code = rspCode;
		this.data = data;
		this.success = this.code == XcnRspCode.OK ? true : false;
		this.total = 0;
	}

	public <T> XcnResponseVO(final XcnRspCode rspCode, final T data) {
		this(rspCode, data, 0);
	}

	public <T> XcnResponseVO(final XcnRspCode rspCode, final T data, final long total) {
		this.code = rspCode;
		this.data = data;
		this.success = this.code == XcnRspCode.OK ? true : false;
		this.total = total;
	}

	public <T> XcnResponseVO(final XcnRspCode rspCode, final JSONArray data) {
		this.code = rspCode;
		this.data = data;
		this.success = this.code == XcnRspCode.OK ? true : false;
		this.total = 0;
	}

	public <T> XcnResponseVO(final XcnRspCode rspCode, final List<T> data) {
		this(rspCode, data, 0);
	}

	public <T> XcnResponseVO(final XcnRspCode rspCode, final List<T> data, final long total) {
		this.code = rspCode;
		this.data = data;
		this.success = this.code == XcnRspCode.OK ? true : false;
		this.total = total;
	}

	public XcnResponseVO setMessage(String message){
		this.message = message;
		return this;
	}

	public boolean isSuccess() {
		return this.success;
	}

	public String getCode() {
		return code.get();
	}

	public Object getData() {
		return data;
	}

	public String getMessage() {
		if (this.code == XcnRspCode.OK_CUSTOM) return this.message;
		else return XcnRspCode.getMessage(this.code);
	}

	public long getTotal() {
		return this.total;
	}

	public XcnResponseVO status(int code, HttpServletResponse response) {
		response.setStatus(code);
		return this;
	}
}