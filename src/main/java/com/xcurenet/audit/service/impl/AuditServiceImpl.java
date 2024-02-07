package com.xcurenet.audit.service.impl;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.AuditVO;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.MongoUtil;
import lombok.extern.log4j.Log4j2;
import org.jetbrains.annotations.NotNull;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.mvel2.ast.Instance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

import static org.apache.http.client.utils.DateUtils.parseDate;

@Log4j2
@Service("auditService")
public class AuditServiceImpl extends XcnAbstractDAO implements AuditService {

	private static final AtomicInteger SEQ = new AtomicInteger();

	private DateTimeFormatter yyyyMMddHHmmssS = DateTimeFormat.forPattern("yyyyMMddHHmmssS");

	private final MongoUtil mongoUtil;

	@Autowired
	public AuditServiceImpl(MongoUtil mongoUtil) {
		this.mongoUtil = mongoUtil;
	}

	public static final String PRODUCT = "EMASSAI";

	private int getNextSeq() {
		SEQ.compareAndSet(0, 9999);
		return SEQ.getAndDecrement();
	}

	public long getAuditListCount(Map<String, Object> param) {
		return mongoUtil.count(getQuery(param, false), AuditVO.class);
	}

	@Override
	public List<AuditVO> getAuditList(Map<String, Object> map) {
		return mongoUtil.selectList(getQuery(map, true), AuditVO.class);
	}

	@NotNull
	private static Query getQuery(Map<String, Object> map, boolean page) {
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
			try {
				String startDtFormatted = startDt.substring(0, 4) + "-" + startDt.substring(4, 6) + "-" + startDt.substring(6);
				String endDtFormatted = endDt.substring(0, 4) + "-" + endDt.substring(4, 6) + "-" + endDt.substring(6);

				startDtFormatted = startDtFormatted + "T00:00:00.000Z";
				endDtFormatted = endDtFormatted + "T23:59:59.999Z";

				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
				dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
				Date sd = dateFormat.parse(startDtFormatted);
				Date ed = dateFormat.parse(endDtFormatted);

				query.addCriteria(Criteria.where("date").gte(sd).lte(ed));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		query.with(Sort.by(Sort.Direction.DESC, "date"));
		if (page) query.with(PageRequest.of((offset / limit), limit));
		return query;
	}


	@Override
	public int insertAudit(AuditVO audit) {
		if (Common.isEmpty(audit.getAdminId())) return 0;
		audit.setSeq(getNextSeq());
		audit.setProduct(PRODUCT);
		audit.setDate(new LocalDateTime().toDateTime(DateTimeZone.UTC));
		audit.setId(String.format("%s_%s_%s", yyyyMMddHHmmssS.print(audit.getDate().getMillis()), audit.getSeq(), audit.getAdminId()));
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
