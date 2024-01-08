package com.xcurenet.emass.searchHistory.vo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import javax.annotation.Nullable;


@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Nullable
@JsonIgnoreProperties(ignoreUnknown = true)
@Document(indexName = "ems_search_history_*")
public class SearchHistoryVO {

	@Id
	@Field(type = FieldType.Text)
	private String msgid;

	public String arkimeId;

	public String keyword;

	public String ctime;

	public String ctime_yyyy;

	public String ctime_yyyymm;

	public String ctime_yyyymmdd;

	public String ctime_hh;

	public String ltime;

	private NetworkData network;

	private HttpData http;

	private EmassUserData user;

	private Service service;

	@Data
	@JsonIgnoreProperties(ignoreUnknown = true)
	public static class Service {
		private String svc;
		private String svc1;
		private String svc2;
		private String svc12;
		private String svc3;
		private String desc;
	}

	@Data
	@JsonIgnoreProperties(ignoreUnknown = true)
	public static class NetworkData {
		private String srcIp;
		private int srcPort;
		private String dstIp;
		private int dstPort;
	}

	@Data
	@JsonIgnoreProperties(ignoreUnknown = true)
	public static class HttpData {
		private String host;
		private String url;
	}

	@Data
	@JsonIgnoreProperties(ignoreUnknown = true)
	public static class EmassUserData {
		private String id;
		private String name;
		private String email;
		private String ip;
		private String ipCoCd;
		private String ipCoNm;
		private String ipBusiCd;
		private String ipBusiNm;
		private String ipDeptCd;
		private String ipDeptNm;
		private String coCd;
		private String coNm;
		private String suborgCd;
		private String suborgNm;
		private String busiCd;
		private String busiNm;
		private String deptCd;
		private String deptNm;
		private String jikgubCd;
		private String jikgubNm;
		private String ceo;
		private String inside;
	}
}
