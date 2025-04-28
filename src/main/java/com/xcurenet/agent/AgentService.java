package com.xcurenet.agent;


import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Log4j2
@Service
@RequiredArgsConstructor
public class AgentService {

	private final AgentMapper mapper;

	public String getUserIdByEmail(final AuthInfo info) {
		return mapper.getUserIdByEmail(info);
	}

	public String getUserIdByAgentId(final AuthInfo info) {
		return mapper.getUserIdByAgentId(info);
	}

	public List<StatusInfo> getOffLineAgent() {
		return mapper.getOffLineAgent();
	}

	public void statusChange() {
		mapper.statusChange();
	}

	public void updateAgentStatus(final StatusInfo info) {
		mapper.updateAgentStatus(info);
	}

	public Map<String, Object> getAgentStatusSummary() {
		return mapper.getAgentStatusSummary();
	}

	public List<StatusInfo> getAgentStatus(final StatusInfo info) {
		return mapper.getAgentStatus(info);
	}

	public List<PolicyInfo> getDefaultPolicy(final String searchStr) {
		return mapper.getDefaultPolicy(searchStr);
	}

	public List<PolicyInfo> getPolicyList(final String agentId) {
		return mapper.getPolicyList(agentId);
	}

	public void updatePolicy(PolicyInfo policyInfo) {
		mapper.updatePolicy(policyInfo);
	}

	public void initAgentDefaultPolicy() {
		mapper.initAgentDefaultPolicy();
	}

	public List<AgentServiceInfo> getAgentService(final JSONObject param) {
		return mapper.getAgentService(param);
	}

	public void applyAgentService(final JSONObject param) {
		mapper.applyAgentService(param);
	}

	public Map<String, Object> getProxyURL() {
		return mapper.getProxyURL();
	}

	public List<String> getProxyHosts() {
		return mapper.getProxyHosts();
	}

	public ObjectNode convertPolicyListToJson(List<PolicyInfo> policies) {
		if (policies == null) return null;
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode rootNode = mapper.createObjectNode();
		for (PolicyInfo policy : policies) {
			String[] path = policy.getConfId().split("\\.");
			ObjectNode currentNode = rootNode;
			for (int i = 0; i < path.length - 1; i++) {
				String key = path[i];
				if (!currentNode.has(key) || !currentNode.get(key).isObject()) {
					currentNode.set(key, mapper.createObjectNode());
				}
				currentNode = (ObjectNode) currentNode.get(key);
			}

			String finalKey = path[path.length - 1];
			String value = policy.getConfVal();
			try {
				if (value != null && value.trim().startsWith("[") && value.trim().endsWith("]")) {
					JsonNode arrayNode = mapper.readTree(value);
					currentNode.set(finalKey, arrayNode);
				} else if ("true".equalsIgnoreCase(value) || "false".equalsIgnoreCase(value)) {
					currentNode.put(finalKey, Boolean.parseBoolean(value));
				} else {
					try {
						assert value != null;
						currentNode.put(finalKey, Integer.parseInt(value));
					} catch (NumberFormatException e) {
						currentNode.put(finalKey, value);
					}
				}
			} catch (Exception e) {
				currentNode.put(finalKey, value);
			}
		}
		return rootNode;
	}
}
