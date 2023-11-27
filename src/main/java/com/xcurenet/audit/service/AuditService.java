package com.xcurenet.audit.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface AuditService {

	public List<AuditVO> getAuditList(Map<String, Object> param);

	public long getAuditListCount(Map<String, Object> param);

	public int insertAudit(AuditVO audit);

	public int insertAudit(final HttpServletRequest request, AuditRequestVO auditVo);
}
