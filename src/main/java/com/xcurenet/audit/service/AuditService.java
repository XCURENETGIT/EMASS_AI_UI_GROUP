package com.xcurenet.audit.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

public interface AuditService {

	public List<AuditVO> getAuditList(final String startDt, final String endDt, final String adminId, final String pMenuId, final String menuId, final String operation, String adminId2, String firstAdminYn, String adminType, String searchStr, String pDate, String pAdminId, int pSeq, final int offset, final int limit);

	public int insertAudit(AuditVO audit);

	public int insertAudit(final HttpServletRequest request, AuditRequestVO auditVo);
}
