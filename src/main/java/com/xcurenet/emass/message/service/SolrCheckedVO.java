package com.xcurenet.emass.message.service;

import org.apache.solr.client.solrj.beans.Field;

import lombok.Data;
@Data
public class SolrCheckedVO {

	@Field
	public String id;

	@Field
	public String key;

	@Field
	public String msgid;
	
	@Field
	public String date_hh;
	
	@Field
	public String date_yyyy;
	
	@Field
	public String date_yyyymm;
	
	@Field
	public String date_yyyymmdd;

	@Field
	public String ctime;
	
	@Field
	public String ctime_hh;
	
	@Field
	public String ctime_yyyy;
	
	@Field
	public String ctime_yyyymm;
	
	@Field
	public String ctime_yyyymmdd;

	@Field
	public String busicd;
	
	@Field
	public String ip_busicd;

	@Field
	public String date;

	@Field
	public String svc;

}
