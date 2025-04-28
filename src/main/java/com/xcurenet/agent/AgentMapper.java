package com.xcurenet.agent;

import net.sf.json.JSONObject;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface AgentMapper {

	String getUserIdByEmail(AuthInfo info);

	String getUserIdByAgentId(AuthInfo info);

	void updateAgentStatus(StatusInfo info);

	Map<String, Object> getAgentStatusSummary();

	List<StatusInfo> getAgentStatus(final StatusInfo searchStr);

	List<StatusInfo> getOffLineAgent();

	void statusChange();

	List<PolicyInfo> getDefaultPolicy(final String searchStr);

	List<PolicyInfo> getPolicyList(final String agentId);

	void updatePolicy(PolicyInfo policyInfo);

	List<AgentServiceInfo> getAgentService(final JSONObject param);

	void applyAgentService(final JSONObject param);

	void initAgentDefaultPolicy();

	Map<String, Object> getProxyURL();

	List<String> getProxyHosts();
}