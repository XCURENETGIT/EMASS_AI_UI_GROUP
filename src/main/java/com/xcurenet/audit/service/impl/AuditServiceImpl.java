package com.xcurenet.audit.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.servlet.http.HttpServletRequest;

import com.xcurenet.common.util.MongoUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.AuditVO;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;

@Service("auditService")
public class AuditServiceImpl extends XcnAbstractDAO implements AuditService {

	private static final AtomicInteger SEQ = new AtomicInteger();

	@Autowired
	MongoUtil mongoUtil;

	public static List<AuditRequestVO> auditRequests;
	public static final String PRODUCT = "EMASSLTH";

	// @Autowired(required = false)
	// private RequestMappingHandlerMapping requestMappingHandlerMapping;

	private int getNextSeq() {
		SEQ.compareAndSet(0, 9999);
		return SEQ.getAndDecrement();
	}

	@Override
	public List<AuditVO> getAuditList(String startDt, String endDt, String adminId, String pMenuId, String menuId, String operation, String adminId2, String firstAdminYn, String adminType, String searchStr, String pDate, String pAdminId, int pSeq, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("startDt", startDt);
		param.put("endDt", endDt);
		param.put("adminId", adminId);
		param.put("pMenuId", pMenuId);
		param.put("menuId", menuId);
		param.put("operation", operation);
		param.put("adminId2", adminId2);
		param.put("firstAdminYn", firstAdminYn);
		param.put("adminType", adminType);
		param.put("searchStr", searchStr);
		param.put("pDate", pDate);
		param.put("pAdminId", pAdminId);
		param.put("pSeq", pSeq);
		param.put("offset", offset);
		param.put("limit", limit);
		param.put("product", PRODUCT);
		return selectList("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".audit.getAuditList", param);


	}

	@Override
	public int insertAudit(AuditVO audit) {
		if (Common.isEmpty(audit.getAdminId())) return 0;
		String currentDate = "";
		try {
			currentDate = Common.getCurrentTime("yyyy-MM-dd HH:mm:ss");
		} catch (Exception e) {
			// TODO: handle exception
		}

		audit.setSeq(getNextSeq());
		audit.setProduct(PRODUCT);
		audit.setDate(currentDate);

		mongoUtil.insert(audit,"info_audit");

		return 1;
		//return insert("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".audit.insertAudit", audit);
	}

	@Override
	public int insertAudit(HttpServletRequest request, AuditRequestVO auditVo) {
		AdminVO admin = Common.getAdmin(request);
		AuditVO audit = new AuditVO();
		audit.setAdminId(admin.getAdminId());
		audit.setAdminName(admin.getAdminName());
		audit.setOperation(auditVo.getOperation());
		audit.setAdminIp(admin.getLoginIp());
		audit.setMenuId(auditVo.getMenuId());
		audit.setPMenuId(auditVo.getPMenuId());
		audit.setInformation(auditVo.getInformation());
		return insertAudit(audit);
	}
}
