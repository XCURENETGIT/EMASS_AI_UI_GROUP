package com.xcurenet.emass.message.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.message.vo.emass.els.Emass;
import com.xcurenet.emass.message.vo.emass.els.EmassMessenger;
import lombok.ToString;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.search.SearchHit;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@ToString
public class MessengerEdcGroupVO {

	private final static DateTimeFormatter yyyyMMddHHmmss = DateTimeFormat.forPattern("yyyyMMddHHmmss");
	private final static DateTimeFormatter yyyyMMddHHmmss2 = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

	private long numFound;

	private List<EmassMessenger> groups;

	public MessengerEdcGroupVO(final List<EmassMessenger> groups) {
		this.groups = groups;
	}


	public MessengerEdcGroupVO(final SearchResponse  searchResponse, final String adminId) throws  IOException {
		this(searchResponse, null, false);
	}

	public MessengerEdcGroupVO(final SearchResponse  searchResponse, final String adminId, final boolean detail) throws  IOException {
		this(searchResponse, null, false, false);
	}


	public MessengerEdcGroupVO(final SearchResponse  searchResponse , final String adminId, final boolean detail, final boolean original) throws IOException {
		if(searchResponse == null) return;

		/* response 파싱 */
		List<Emass> result = new ArrayList<>();
		SearchHit[] hits = searchResponse.getHits().getHits();
		ObjectMapper mapper = new ObjectMapper();
		for (SearchHit hit : hits) {
			Map<String, Object> map = hit.getSourceAsMap();
			if (map.size() > 0) {
				map.put("_id",hit.getId());
				result.add(mapper.convertValue(map, Emass.class));
			}
		}

		this.groups = new ArrayList<>();
		this.numFound = searchResponse.getHits().getHits().length;

		if(result.size() >= 1){
			for(Emass ems : result) {
				if (detail) {
					this.groups.add(reDefinedDetail(ems, adminId, original));
				} else {
					this.groups.add(reDefined(ems, adminId, 0));
				}
			}
		}

		/* 분석 필요*/
//		if (resp.getGroupResponse() != null) {
//			GroupResponse gres = resp.getGroupResponse();
//			List<GroupCommand> gGroupCommands = gres.getValues();
//			if (gGroupCommands.size() > 0) {
//				GroupCommand gc = gGroupCommands.get(0);
//				List<Group> groups = gc.getValues();
//				for (Group group : groups) {
//					long msg_cnt = group.getResult().getNumFound();
//					SolrDocumentList solrDocs = group.getResult();
//					if (solrDocs.size() > 0) {
//						this.groups.add(reDefined(new DocumentObjectBinder().getBean(SolrEdcVO.class, solrDocs.get(0)), adminId, msg_cnt));
//					}
//				}
////				this.numFound = gc.getNGroups();
//				this.numFound = getMessengerGroupCnt(resp);
//			}
//		}


	}

	/**
	 * 아이콘 메신저 그룹방 상세보기
	 *
	 * @param edc
	 * @return
	 */
	public static EmassMessenger reDefinedDetail(Emass emass, String adminId, boolean original) {
		EmassMessenger emassMessenger = new EmassMessenger();
		emassMessenger.setMsgid(emass.getMsgid());
		if(emass.getService() != null){
			emassMessenger.setSvc(Common.nvl(emass.getService().getSvc()));
			emassMessenger.setSvc3(Common.nvl(emass.getService().getSvc3()));
		}
		emassMessenger.setCtime(reCtime(Common.nvl(emass.getCtime())));
		emassMessenger.setAttached(emass.getAttached());

		if(emass.getAttach() != null){
			emassMessenger.setAttachname(emass.getAttach().stream().map(m -> m.getName()).collect(Collectors.joining("|")));
			emassMessenger.setAttachhash(emass.getAttach().stream().map(m -> m.getHash()).collect(Collectors.joining("|")));
		}

		emassMessenger.setMessage(getMessageDetail(emass, 0, original));
		emassMessenger.setTitle(getSender(emass));

		if(emass.getUser() != null) {
			emassMessenger.setUser_name(emass.getUser().getName());
			emassMessenger.setDeptNm(emass.getUser().getDeptNm());
			emassMessenger.setJikgubNm(emass.getUser().getJikgubNm());
			emassMessenger.setUsr_id(emass.getUser().getId());
		}

		if(emass.getBody() != null) {
			emassMessenger.setBody_snippet(emass.getBody().getSnippet());
			emassMessenger.setBody_text(emass.getBody().getText());
		}
		if(emass.getSender() != null) {
			emassMessenger.setSender(emass.getSender().getName());
		}
		if(emass.getNetwork() != null) {
			emassMessenger.setSrcip(emass.getNetwork().getSrcIp());
		}


		emassMessenger.setReadYn("Y");


		return emassMessenger;
	}

	public static EmassMessenger reDefined(Emass emass, String adminId, long msg_cnt) {
		EmassMessenger emassMessenger = new EmassMessenger();
		emassMessenger.setMsg_cnt(msg_cnt);
		emassMessenger.setMsgid(emass.getMsgid());
		if(emass.getService() != null){
			emassMessenger.setSvc(Common.nvl(emass.getService().getSvc()));
			emassMessenger.setSvc3(Common.nvl(emass.getService().getSvc3()));
		}

		emassMessenger.setCtime(reCtime(Common.nvl(emass.getCtime())));
		emassMessenger.setAttached(emass.getAttached());
		if(emass.getAttach() != null){
			emassMessenger.setAttachname(emass.getAttach().stream().map(m -> m.getName()).collect(Collectors.joining(",")));
			emassMessenger.setAttachhash(emass.getAttach().stream().map(m -> m.getHash()).collect(Collectors.joining(",")));
		}

		emassMessenger.setXrootmtr(emass.getXrootMtr());

		int total_recvs = 0;
		if (emass.getRecv() != null){
			if(emass.getRecv().getTo() != null) total_recvs = total_recvs + emass.getRecv().getTo().size() + 1;
			if(emass.getRecv().getCc() != null) total_recvs = total_recvs + emass.getRecv().getCc().size() + 1;
			if(emass.getRecv().getBcc() != null) total_recvs = total_recvs + emass.getRecv().getBcc().size() + 1;
			emassMessenger.setUser_cnt(total_recvs);
		}else{
			emassMessenger.setUser_cnt(1);
		}

		emassMessenger.setMessage(getMessage(emass));
		emassMessenger.setTitle(emass.getXrootMtr());

		if(emass.getUser() != null) {
			emassMessenger.setUser_name(emass.getUser().getName());
			emassMessenger.setDeptNm(emass.getUser().getDeptNm());
			emassMessenger.setJikgubNm(emass.getUser().getJikgubNm());
			emassMessenger.setUsr_id(emass.getUser().getId());
		}

		if(emass.getBody() != null) {
			emassMessenger.setBody_snippet(emass.getBody().getSnippet());
			emassMessenger.setBody_text(emass.getBody().getText());
		}
		if(emass.getSender() != null) {
			emassMessenger.setSender(emass.getSender().getName());
		}
		if(emass.getNetwork() != null) {
			emassMessenger.setSrcip(emass.getNetwork().getSrcIp());
		}

		return emassMessenger;
	}

//	private static String getTitle(SolrEdcVO edc) {
//		return edc.getXrootmtr();
//
//		/*List<String> recvs = edc.getRecvs();
//		List<String> recvNames = edc.getRecvs_name();
//		if (recvNames == null) recvNames = new ArrayList<>();
//		for (int i = 0; i < recvNames.size(); i++) {
//			if (Common.isEmpty(recvNames.get(i))) recvNames.set(i, recvs.get(i));
//		}
//		recvNames.add(getSender(edc));
//		Collections.sort(recvNames);
//		List<String> tmp = new ArrayList<>();
//		for (int i = 0; i < recvNames.size(); i++) {
//			if (i > 1) break;
//			tmp.add(recvNames.get(i));
//		}
//		String result = Common.join(tmp, ", ");
//		if (recvNames.size() > 2) {
//			result += "...";
//		}
//		result += " (" + recvNames.size() + Prop.propFormat("eikon.msg.person")+")";
//		return result;*/
//	}

	private static String getMessage(Emass ems) {
		String msg = getMessageDetail(ems, 200, false).replaceAll("\\r", "").replaceAll("\\n", "");
		return getSender(ems) + " : " + msg;
	}

	private static String getMessageDetail(Emass ems, int cutLength, boolean original) {
		String result = Common.EMPTY;
		if(ems.getService() != null) {
			if (Common.isOrEquals(ems.getService().getSvc3(), "C", "M")) {
				String body = Common.nvl(ems.getBody().getSnippet());
				if (cutLength > 0 && body.length() > cutLength) body = body.substring(0, cutLength);
				result = body;
			} else if (Common.isEquals(ems.getService().getSvc3(), "F")) {
				if( ems.getAttach() != null) {
					result = ems.getAttach().stream().map(m -> m.getName()).collect(Collectors.joining("\n"));
				}
				//if (Common.isNotEmpty(edc.getBody_snippet())) result += "\n" + edc.getBody_snippet();
			} else if (Common.isEquals(ems.getService().getSvc3(), "J"))
				result = "[" + Prop.propFormat("common.messenger.join") + "]";
			else if (Common.isEquals(ems.getService().getSvc3(), "L"))
				result = "[" + Prop.propFormat("common.messenger.leave") + "]";
		}
		return original ? result : textParser(result);
	}

	private static String getSender(Emass emass) {
		//if (Common.isNotEmpty(edc.getName())) return edc.getName();
		if (Common.isNotEmpty(emass.getSender())) return emass.getSender().getName();
		else if(Common.isNotEmpty(emass.getNetwork())) return emass.getNetwork().getSrcIp();
		else return null;
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

	public List<EmassMessenger> getGroups() {
		return groups;
	}

	public void setGroups(List<EmassMessenger> groups) {
		this.groups = groups;
	}

	public static String textParser(String text) {
		text = Common.escapeTag(text);
		//style='word-wrap: break-word;white-space: pre-wrap;white-space: -moz-pre-wrap;white-space: -pre-wrap;white-space: -o-pre-wrap;word-break:break-all;font-size:11px;padding:0;margin:0;border:0;background-color: transparent;'
		return "<pre class='ignoreHtmlPre'><code>" + text + "</code></pre>";
	}




}
