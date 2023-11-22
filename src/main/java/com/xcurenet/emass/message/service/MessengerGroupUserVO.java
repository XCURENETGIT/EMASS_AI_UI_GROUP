//package com.xcurenet.emass.message.service;
//
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//
//import com.xcurenet.common.util.Common;
//
//import lombok.Data;
//import org.elasticsearch.action.search.SearchResponse;
//
//@Data
//public class MessengerGroupUserVO {
//
//	//사용자 수
//	private long numFoundUser;
//
//	private List<SolrEdcVO> groups;
//
//	public MessengerGroupUserVO(final QueryResponse resp) throws  IOException {
//		this.groups = new ArrayList<>();
//
//		Map<String, Integer> queryResult = resp.getFacetQuery();
//		int queryResultCnt = 0;
//		for(Map.Entry<String, Integer> entry : queryResult.entrySet()) {
//			queryResultCnt = entry.getValue();
//		}
//
//		//참여자 출력시 usr_id가 아닌 sender에 적재해야하지만 usr_id 영역으로 사용함
//		NamedList<List<PivotField>> facetPivot = resp.getFacetPivot();
//		if(facetPivot != null) {
//			for(int i=0; i<facetPivot.size(); i++) {
//				List<PivotField> pivotList = facetPivot.getVal(i);
//				for(int j=0; j<pivotList.size(); j++) {
//					PivotField field = pivotList.get(j);
//					String usr_id = Common.nvl(field.getValue());
//					SolrEdcVO vo = new SolrEdcVO();
//					vo.setUsr_id(usr_id);
//
//					List<Map<String, Integer>> srcIpList = new ArrayList<Map<String, Integer>>();
//					List<PivotField> subPivotList = field.getPivot();
//
//
//					for(int k=0; k<subPivotList.size(); k++) {
//						PivotField subField = subPivotList.get(k);
//						String ip = Common.nvl(subField.getValue());
//						int cnt = subField.getCount();
//						Map<String, Integer> ipList = new HashMap<String, Integer>();
//						ipList.put(ip, cnt);
//						srcIpList.add(ipList);
//					}
//					vo.setSrcIpList(srcIpList);
//					groups.add(vo);
//				}
//			}
//		}
//
//		//usr_id가 없는 경우에 ip로 보여주기 위한 작업
//		if(queryResultCnt > 0) {
//			List<FacetField> facetFields = resp.getFacetFields();
//
//			for(FacetField facetField : facetFields) {
//				List<Count> facet_fields = facetField.getValues();
//				SolrEdcVO onlyIp = null;
//				for(Count facet_field : facet_fields) {
//					boolean addFlag = false;
//					String facetIp = facet_field.getName();
//					long facetCnt = facet_field.getCount();
//
//					int size = groups.size();
//					for(int i=0; i<size; i++) {
//						SolrEdcVO edc = groups.get(i);
//						List<Map<String, Integer>> ipList = edc.getSrcIpList();
//						if(ipList == null) {
//							if(Common.isEquals(facetIp, edc.getSrcip()) ) {
//								addFlag = true;
//								continue;
//							}
//						}
//						else {
//							for(Map<String, Integer> map : ipList) {
//								int cnt = Common.nvz(map.get(facetIp));
//								if(facetCnt == cnt) {
//									addFlag = true;
//									break;
//								}
//							}
//						}
//					}
//					if(!addFlag) {
//						onlyIp = new SolrEdcVO();
//						onlyIp.setSrcip(facetIp);
//						groups.add(onlyIp);
//					}
//				}
//			}
//		}
//
//		this.numFoundUser = groups.size();
//
//		//usr_id 기준으로 인사매핑
//		if (resp.getGroupResponse() != null) {
//			GroupResponse gres = resp.getGroupResponse();
//			List<GroupCommand> gGroupCommands = gres.getValues();
//			for(GroupCommand gc : gGroupCommands) {
//				String name = gc.getName();
//				List<Group> userGroups = gc.getValues();
//				for (Group group : userGroups) {
//					SolrDocumentList solrDocs = group.getResult();
//					if (solrDocs.size() > 0) {
//						SolrEdcVO edc = new DocumentObjectBinder().getBean(SolrEdcVO.class, solrDocs.get(0));
//						for (int i=0; i<groups.size(); i++) {
//							SolrEdcVO vo = groups.get(i);
//							if(Common.isOrEquals(name, "srcip", "usr_id") && Common.isEquals(edc.getUsr_id(), vo.getUsr_id())) {
//								vo.setUser(edc.getUser());
//								vo.setConm(edc.getConm());
//								vo.setBusinm(edc.getBusinm());
//								vo.setName(edc.getName());
//								vo.setJikgubnm(edc.getJikgubnm());
//								vo.setSender(edc.getSender());
//								vo.setSname(edc.getSname());
//								this.groups.set(i, vo);
//							}
//							else if(Common.isEquals(name, "sender_str") && Common.isEquals(edc.getSender(), vo.getUsr_id())) {
//								vo.setSender(edc.getSender());
//								vo.setSname(edc.getSname());
//								this.groups.set(i, vo);
//							}
//						}
//					}
//				}
//			}
//		}
//	}
//}
