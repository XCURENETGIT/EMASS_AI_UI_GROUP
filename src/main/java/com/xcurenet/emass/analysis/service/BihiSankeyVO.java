//package com.xcurenet.emass.analysis.service;
//
//import java.io.Serializable;
//import java.util.ArrayList;
//import java.util.Collections;
//import java.util.Comparator;
//import java.util.HashMap;
//import java.util.HashSet;
//import java.util.List;
//import java.util.Map;
//
//import com.xcurenet.common.util.Common;
//import com.xcurenet.emass.message.service.SolrEdcVO;
//
//import lombok.Data;
//
//
//public @Data class BihiSankeyVO implements Serializable {
//
//	private static final long serialVersionUID = 1L;
//
//	private List<BihiNode> nodes;
//	private Map<String, BihiNode> nodeMap;
//
//	private List<Link> links;
//	private int id = 1;
//
//	public void setData(List<SolrEdcVO> modelList) {
////		List<SolrEdcVO> modelList2 = new ArrayList<SolrEdcVO>();
////		for (SolrEdcVO solrEdcVO : modelList) {
////			modelList2.add(solrEdcVO);
////		}
////
////		for (SolrEdcVO solrEdcVO : modelList) {
////			SolrEdcVO solrEdcVO2 = new SolrEdcVO();
////			ModelDataCopy.copy(solrEdcVO, solrEdcVO2);
////			modelList2.add(solrEdcVO2);
////		}
//		List<BihiNode> nodeList = setNode(modelList);
//		Collections.sort(nodeList, new Comparator<BihiNode>() {
//			@Override
//			public int compare(BihiNode arg0, BihiNode arg1) {
//				if(arg0.getParent() == null && arg1.getParent() == null ) {
//					return arg0.getId() > arg1.getId() ? -1 : 1;
//				} else 	if(arg0.getParent() == null) {
//					return -1;
//				} else if(arg1.getParent() == null) {
//					return 1;
//				} else {
//					return arg0.getId() > arg1.getId() ? -1 : 1;
//				}
//			}
//		});
//
//		setNodes(nodeList);
//
//		setLinks(setLink(modelList));
//	}
//
//	private List<BihiNode> setNode(List<SolrEdcVO> modelList) {
//
//		Map<String, BihiNode> nodeMap = new HashMap<>();
//
//		nodeMap = setParent(modelList);
//		nodeMap = setChild(nodeMap, modelList);
//
//		setNodeMap(nodeMap);
//		return new ArrayList<BihiNode>(nodeMap.values());
//	}
//
//	private Map<String, BihiNode> setParent(List<SolrEdcVO> modelList) {
//
//		Map<String, BihiNode> nodeMap = new HashMap<>();
//
//		for (SolrEdcVO model : modelList) {
//			if(model.getSvc().startsWith("M") || model.getSvc().startsWith("W") || model.getSvc().startsWith("EMM")) {
//
//				setParentNodeModel(nodeMap, model.getSender(), id++);
//				if(model.getRecvs() != null) {
//					for (String recvs : model.getRecvs()) {
//						setParentNodeModel(nodeMap, recvs, id++);
//					}
//				}
//			} else {
//				setParentNodeModel(nodeMap, model.getSrcip(), id++);
//				setParentNodeModel(nodeMap, model.getDstip(), id++);
//			}
//			//20건 까지 제한.
//			if(nodeMap.size() >= 10)	break;
//		}
//		return nodeMap;
//	}
//
//	private Map<String, BihiNode> setChild(Map<String, BihiNode> nodeMap, List<SolrEdcVO> modelList) {
//
//		for (SolrEdcVO model : modelList) {
//			String contentsName = ServiceCodeCheck.getContentsName(model);
//
//			if(model.getSvc().startsWith("M") || model.getSvc().startsWith("W") || model.getSvc().startsWith("EMM")) {
//				String type = model.getSender();
//				BihiNode bihiNode = nodeMap.get(type+type);
//
//				if(bihiNode != null) {
//					setNodeModelMap(nodeMap, type, id++, nodeMap.get(type+type).getId(), contentsName);
//				}
//				if(model.getRecvs() != null) {
//					for (String recvs : model.getRecvs()) {
//						bihiNode = nodeMap.get(recvs+recvs);
//						if(bihiNode != null) {
//							setNodeModelMap(nodeMap, recvs, id++, nodeMap.get(recvs+recvs).getId(), contentsName);
//						}
//					}
//				}
//			} else {
//				String type = model.getSrcip();
//				BihiNode bihiNode = nodeMap.get(type+type);
//				if(bihiNode != null) {
//					setNodeModelMap(nodeMap, type, id++, bihiNode.getId(), contentsName);
//					type = model.getDstip();
//					setNodeModelMap(nodeMap, type, id++, bihiNode.getId(), contentsName);
//				}
//			}
//		}
//
//		return nodeMap;
//	}
//
//	private Map<String, BihiNode> setParentNodeModel(Map<String, BihiNode> nodeMap, String type, int id) {
//
//		return setNodeModelMap(nodeMap, type, id, null, type);
//	}
//
//	private Map<String, BihiNode> setNodeModelMap(Map<String, BihiNode> nodeMap, String type, Integer id, Integer parent, String name) {
//
//		String key = type + name;
//		if(!nodeMap.containsKey(key)) {
//			nodeMap.put(key, setNodeModel(type, id, parent, name));
//		}
//
//		return nodeMap;
//	}
//
//	private BihiNode setNodeModel(String type, Integer id, Integer parent, String name) {
//
//		BihiNode node = new BihiNode();
//		node.setType(type);
//		node.setName(name);
//		node.setParent(parent);
//		node.setId(id);
//
//		return node;
//	}
//
//	private List<Link> setLink(List<SolrEdcVO> modelList) {
//
//		List<Link> linkList = new ArrayList<>();
//
//		for (SolrEdcVO model : modelList) {
//			String content = ServiceCodeCheck.getContentsName(model);
//
//			if(model.getSvc().startsWith("M") || model.getSvc().startsWith("W") || model.getSvc().startsWith("EMM")) {
//
//				if(model.getRecvs() != null) {
//					for (String recvs : model.getRecvs()) {
//						if(getNodeMap().get(model.getSender() + content) != null && getNodeMap().get(recvs + content) != null) {
//							linkList.add(setSankeyModel(model, model.getSender() + content, recvs + content));
//						}
//					}
//				}
//			} else {
//				if(getNodeMap().get(model.getSrcip() + content) != null && getNodeMap().get(model.getDstip() + content) != null) {
//					linkList.add(setSankeyModel(model, model.getSrcip() + content, model.getDstip() + content));
//				}
//			}
//		}
//
//		return sankeyModelDuplicationCheck(linkList);
//	}
//
//	private Link setSankeyModel(SolrEdcVO model, String key1, String key2) {
//		Link link = new Link();
//		link.setSource(getNodeMap().get(key1).getId());
//		link.setTarget(getNodeMap().get(key2).getId());
//		link.setValue(model.getSize());
//
//		return link;
//	}
//
//	private List<Link> sankeyModelDuplicationCheck(List<Link> sankeyModelList) {
//
//		Link linkModel = new Link();
//		Map<String, Link> sankeyMap = new HashMap<>();
//
//		for (Link model : sankeyModelList) {
//			String key = new StringBuilder().append(model.getSource()).append("^|^").append(model.getTarget()).toString();
//			if(sankeyMap.isEmpty()) {
//				sankeyMap.put(key, model);
//			} else if(sankeyMap.containsKey(key)) {
//				linkModel = sankeyMap.get(key);
//				linkModel.setValue(linkModel.getValue()+1);
//				sankeyMap.replace(key, linkModel);
//			} else {
//				sankeyMap.put(key, model);
//			}
//		}
//
//		return new ArrayList<Link>(sankeyMap.values());
//	}
//
//	private @Data class BihiNode {
//		private String type;
//		private Integer id;
//		private Integer parent;
//		private String name;
//	}
//
//	private @Data class Link {
//		private int source;
//		private int target;
//		private long value;
//	}
//
//}
