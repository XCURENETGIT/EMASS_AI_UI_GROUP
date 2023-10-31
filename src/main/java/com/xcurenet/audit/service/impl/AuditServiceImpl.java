package com.xcurenet.audit.service.impl;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.AuditVO;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.MongoUtil;
import lombok.extern.java.Log;
import lombok.extern.log4j.Log4j2;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

@Log4j2
@Service("auditService")
public class AuditServiceImpl extends XcnAbstractDAO implements AuditService {

	private static final AtomicInteger SEQ = new AtomicInteger();

	private final MongoUtil mongoUtil;

	@Autowired
	public AuditServiceImpl(MongoUtil mongoUtil) {
		this.mongoUtil = mongoUtil;
	}

	public static final String PRODUCT = "EMASSLTH";

	private int getNextSeq() {
		SEQ.compareAndSet(0, 9999);
		return SEQ.getAndDecrement();
	}

	@Override
	public List<AuditVO> getAuditList(Map<String, Object> map) {
		String searchStr = Common.nvl(map.get("searchStr"));
		String startDt = Common.nvl(map.get("startDt"));
		String endDt = Common.nvl(map.get("endDt"));
		String adminId = Common.nvl(map.get("adminId"));
		String pMenuId = Common.nvl(map.get("pMenuId"));
		String menuId = Common.nvl(map.get("menuId"));
		int offset = Common.nvz(map.get("offset"));
		int limit = Common.nvz(map.get("limit"));

		Query query = new Query();
		if (Common.isNotEmpty(searchStr)) query.addCriteria(Criteria.where("information").regex(".*" + searchStr + ".*"));
		if (Common.isNotEmpty(adminId)) query.addCriteria(Criteria.where("adminId").is(adminId));
		if (Common.isNotEmpty(pMenuId)) query.addCriteria(Criteria.where("pMenuId").is(pMenuId));
		if (Common.isNotEmpty(menuId)) query.addCriteria(Criteria.where("menuId").is(menuId));
		if (Common.isNotEmpty(startDt) && Common.isNotEmpty(endDt)) {
			LocalDateTime s = LocalDateTime.parse(startDt + "000000000", DateTimeFormat.forPattern("yyyyMMddHHmmssSSS"));
			LocalDateTime e = LocalDateTime.parse(endDt + "235959999", DateTimeFormat.forPattern("yyyyMMddHHmmssSSS"));
			query.addCriteria(Criteria.where("date").gte(s).lt(e));
		}
		query.with(Sort.by(Sort.Direction.DESC, "date"));
		query.with(PageRequest.of((offset / limit), limit));

		log.info("query : {}", query);
		return mongoUtil.selectList(query, AuditVO.class);
	}

	@Override
	public int insertAudit(AuditVO audit) {
		if (Common.isEmpty(audit.getAdminId())) return 0;

		audit.setSeq(getNextSeq());
		audit.setProduct(PRODUCT);
		audit.setDate(new LocalDateTime().toDateTime(DateTimeZone.UTC));
		mongoUtil.insert(audit, "INFO_AUDIT");
		return 1;
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
