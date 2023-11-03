package com.xcurenet.emass.message.service;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import lombok.ToString;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.beans.DocumentObjectBinder;
import org.apache.solr.client.solrj.response.Group;
import org.apache.solr.client.solrj.response.GroupCommand;
import org.apache.solr.client.solrj.response.GroupResponse;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocumentList;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@ToString
public class MessengerEdcGroupVO {

	private final static DateTimeFormatter yyyyMMddHHmmss = DateTimeFormat.forPattern("yyyyMMddHHmmss");
	private final static DateTimeFormatter yyyyMMddHHmmss2 = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

	private long numFound;

	private List<MessengerGroupVO> groups;
	
	public MessengerEdcGroupVO(final List<MessengerGroupVO> groups) {
		this.groups = groups;
	}

	public MessengerEdcGroupVO(final QueryResponse resp) throws SolrServerException, IOException {
		this(resp, null, false);
	}

	public MessengerEdcGroupVO(final QueryResponse resp, final String adminId) throws SolrServerException, IOException {
		this(resp, null, false);
	}

	public MessengerEdcGroupVO(final QueryResponse resp, final String adminId, final boolean detail) throws SolrServerException, IOException {
		this(resp, null, false, false);
	}
	
	public MessengerEdcGroupVO(QueryResponse resp, final String adminId, final boolean detail, final boolean original) throws SolrServerException, IOException {
		this.groups = new ArrayList<>();
		
		if (resp.getResults() != null) {
			this.numFound = resp.getResults().getNumFound();
			List<SolrEdcVO> emass = resp.getBeans(SolrEdcVO.class);
			for (SolrEdcVO edc : emass) {
				if (detail) {
					this.groups.add(reDefinedDetail(edc, adminId, original));
				} else {
					this.groups.add(reDefined(edc, adminId, 0));
				}
			}
		};

		if (resp.getGroupResponse() != null) {
			GroupResponse gres = resp.getGroupResponse();
			List<GroupCommand> gGroupCommands = gres.getValues();
			if (gGroupCommands.size() > 0) {
				GroupCommand gc = gGroupCommands.get(0);
				List<Group> groups = gc.getValues();
				for (Group group : groups) {
					long msg_cnt = group.getResult().getNumFound();
					SolrDocumentList solrDocs = group.getResult();
					if (solrDocs.size() > 0) {
						this.groups.add(reDefined(new DocumentObjectBinder().getBean(SolrEdcVO.class, solrDocs.get(0)), adminId, msg_cnt));
					}
				}
//				this.numFound = gc.getNGroups();
				this.numFound = getMessengerGroupCnt(resp);
			}
		}
		
	}

	/**
	 * 아이콘 메신저 그룹방 상세보기
	 *
	 * @param edc
	 * @return
	 */
	public static MessengerGroupVO reDefinedDetail(SolrEdcVO edc, String adminId, boolean original) {
		MessengerGroupVO solrGroupVO = new MessengerGroupVO();
		solrGroupVO.setMsgid(edc.getMsgid());
		solrGroupVO.setSvc(edc.getSvc());
		solrGroupVO.setSvc3(edc.getSvc3());
		solrGroupVO.setCtime(reCtime(edc.getCtime()));
		solrGroupVO.setAttached(edc.getAttached());
		if (edc.getAttachname() != null && edc.getAttachname().size() > 0) {
			solrGroupVO.setAttachname(Common.join(edc.getAttachname(), "|"));
			solrGroupVO.setAttachhash(Common.join(edc.getAttachhash(), "|"));
		}
		solrGroupVO.setMessage(getMessageDetail(edc, 0, original));
		solrGroupVO.setTitle(getSender(edc));
		solrGroupVO.setDeptNm(edc.getDeptnm());
		solrGroupVO.setJikgubNm(edc.getJikgubnm());
		solrGroupVO.setSrcip(edc.getSrcip());
		solrGroupVO.setName(edc.getName());
		solrGroupVO.setReadYn("Y");
		solrGroupVO.setUser(edc.getUser());
		solrGroupVO.setSender(edc.getSender());
		solrGroupVO.setUsr_id(edc.getUsr_id());
		return solrGroupVO;
	}

	public static MessengerGroupVO reDefined(SolrEdcVO edc, String adminId, long msg_cnt) {
		MessengerGroupVO solrGroupVO = new MessengerGroupVO();
		solrGroupVO.setMsg_cnt(msg_cnt);
		solrGroupVO.setMsgid(edc.getMsgid());
		solrGroupVO.setSvc(edc.getSvc());
		solrGroupVO.setSvc3(edc.getSvc3());
		solrGroupVO.setCtime(reCtime(edc.getCtime()));
		solrGroupVO.setAttached(edc.getAttached());
		solrGroupVO.setAttachname(Common.join(edc.getAttachname(), ","));
		solrGroupVO.setXrootmtr(edc.getXrootmtr());
		if (edc.getRecvs() != null) solrGroupVO.setUser_cnt(edc.getRecvs().size() + 1);
		else solrGroupVO.setUser_cnt(1);
		solrGroupVO.setMessage(getMessage(edc));
		solrGroupVO.setTitle(getTitle(edc));
		solrGroupVO.setDeptNm(edc.getDeptnm());
		solrGroupVO.setJikgubNm(edc.getJikgubnm());
		solrGroupVO.setSrcip(edc.getSrcip());
		solrGroupVO.setName(edc.getName());
		solrGroupVO.setUser(edc.getUser());
		solrGroupVO.setSender(edc.getSender());
		solrGroupVO.setUsr_id(edc.getUsr_id());
		return solrGroupVO;
	}

	private static String getTitle(SolrEdcVO edc) {
		return edc.getXrootmtr();
		
		/*List<String> recvs = edc.getRecvs();
		List<String> recvNames = edc.getRecvs_name();
		if (recvNames == null) recvNames = new ArrayList<>();
		for (int i = 0; i < recvNames.size(); i++) {
			if (Common.isEmpty(recvNames.get(i))) recvNames.set(i, recvs.get(i));
		}
		recvNames.add(getSender(edc));
		Collections.sort(recvNames);
		List<String> tmp = new ArrayList<>();
		for (int i = 0; i < recvNames.size(); i++) {
			if (i > 1) break;
			tmp.add(recvNames.get(i));
		}
		String result = Common.join(tmp, ", ");
		if (recvNames.size() > 2) {
			result += "...";
		}
		result += " (" + recvNames.size() + Prop.propFormat("eikon.msg.person")+")";
		return result;*/
	}

	private static String getMessage(SolrEdcVO edc) {
		String msg = getMessageDetail(edc, 200, false).replaceAll("\\r", "").replaceAll("\\n", "");
		return getSender(edc) + " : " + msg;
	}

	private static String getMessageDetail(SolrEdcVO edc, int cutLength, boolean original) {
		String result = Common.EMPTY;
		if (Common.isOrEquals(edc.getSvc3(), "C", "M")) {
			String body = Common.nvl(edc.getBody_snippet());
			if( cutLength > 0 && body.length() > cutLength) body = body.substring(0, cutLength);
			result = body;
		}
		else if (Common.isEquals(edc.getSvc3(), "F")) {
			result = Common.join(edc.getAttachname(), "\n");
			//if (Common.isNotEmpty(edc.getBody_snippet())) result += "\n" + edc.getBody_snippet();
		} else if (Common.isEquals(edc.getSvc3(), "J")) result = "["+Prop.propFormat("common.messenger.join")+"]";
		else if (Common.isEquals(edc.getSvc3(), "L")) result = "["+Prop.propFormat("common.messenger.leave")+"]";
		return original ? result : textParser(result);
	}

	private static String getSender(SolrEdcVO edc) {
		//if (Common.isNotEmpty(edc.getName())) return edc.getName();
		if (Common.isNotEmpty(edc.getSname())) return edc.getSname();
		else if (Common.isNotEmpty(edc.getSender())) return edc.getSender();
		return edc.getSrcip();
	}

	private static String reCtime(String ctime) {
		if (Common.isEmpty(ctime)) return Common.EMPTY;
		return DateTime.parse(ctime, yyyyMMddHHmmss).toString(yyyyMMddHHmmss2);
	}

	public long getNumFound() {
		return numFound;
	}

	public void setNumFound(long numFound) {
		this.numFound = numFound;
	}

	public List<MessengerGroupVO> getGroups() {
		return groups;
	}

	public void setGroups(List<MessengerGroupVO> groups) {
		this.groups = groups;
	}
	
	public static String textParser(String text) {
		text = Common.escapeTag(text);
		//style='word-wrap: break-word;white-space: pre-wrap;white-space: -moz-pre-wrap;white-space: -pre-wrap;white-space: -o-pre-wrap;word-break:break-all;font-size:11px;padding:0;margin:0;border:0;background-color: transparent;'
		return "<pre class='ignoreHtmlPre'><code>" + text + "</code></pre>";
	}
	
	private int getMessengerGroupCnt(QueryResponse resp) {
		if(Common.isNotEmpty(resp.getFacetField("xrootmtr"))) {
			return resp.getFacetField("xrootmtr").getValueCount();
		}
		return 0;
	}
}
