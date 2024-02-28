package com.xcurenet.common.util.config;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.common.schedule.service.JobVO;
import com.xcurenet.common.schedule.service.QuartzCronTrigger;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.config.service.ConfigService;
import com.xcurenet.config.service.ConfigVO;
import com.xcurenet.config.service.impl.ConfigServiceImpl;
import com.xcurenet.emass.iprange.service.IpRangeService;
import com.xcurenet.emass.iprange.service.IpRangeVO;
import com.xcurenet.emass.service.service.ServiceGroupService;
import com.xcurenet.emass.service.service.ServiceGroupVO;
import com.xcurenet.emass.service.service.ServiceTypeService;
import com.xcurenet.emass.service.service.ServiceTypeVO;
import com.xcurenet.searchWord.service.SearchWordService;
import com.xcurenet.searchWord.service.SearchWordVO;
import com.xcurenet.user.service.PersCodeInfo;
import com.xcurenet.user.service.UserService;
import lombok.Data;
import lombok.Getter;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.support.EncodedResource;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.sql.DataSource;
import java.io.File;
import java.sql.Connection;
import java.util.*;
import java.util.stream.Collectors;

@Log4j2
@Data
@Service("config")
public class Config {

	@Autowired
	private ApplicationContext applicationContext;

	@Autowired
	private SpringContextUtil springContextUtil;

	@Autowired
	private QuartzCronTrigger trigger;

	@Resource(name = "configService")
	public ConfigService configService;

	@Resource(name = "serviceTypeService")
	public ServiceTypeService serviceTypeService;

	@Resource(name = "serviceGroupService")
	public ServiceGroupService serviceGroupService;

	@Resource(name = "adminService")
	public AdminService adminService;

	@Autowired
	public UserService userService;

	@Autowired
	private DataSource dataSource;

	@Autowired
	private SearchWordService searchWordService;

	private static List<ConfigVO> configs;

	@Getter
	private static List<IpRangeVO> ipRange;

	public static List<ServiceTypeVO> serviceTypes;

	public static List<ServiceTypeVO> serviceTypesAll;

	public static List<ServiceTypeVO> sendMailTypes;

	public static List<ServiceGroupVO> serviceGroups;

	public static List<AuditRequestVO> auditRequest;

	public static List<AdminVO> adminList;

	public static final String[] PRIVATE_SVC = {"pi_SN", "pi_PN", "pi_DN", "pi_FN", "pi_CN", "pi_MN", "pi_AN", "pi_CRN", "pi_SSN", "pi_IMEI", "pi_BRN", "pi_CPN", "pi_MCN"};

	public static String[] colors = {"#7cb5ec", "#c9cbf6", "#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1", "#B5CA92", "#a7efff", "#B8B8BA", "#FFB2F5", "#47C83E", "#fee79f", "#8bc4bf", "#bf4444", "#7CB823", "#19D4FF", "#097500"};

	public static Map<String, String> userIds; //(key : ip, email, id) (value: 이름) 통계 이름 추출 용도

	public static Map<String, String> userNames; //(key : ip, email, id) (value: 이름) 통계 이름 추출 용도

	public static Map<String, String> userCoNms; //(key : id) (value: 이름) 통계 이름 추출 용도

	public static Map<String, String> userBusiNms; //(key : id) (value: 이름) 통계 이름 추출 용도


	public static Map<String, String> userDepts; //(key : id) (value: 이름) 통계 이름 추출 용도

	public static Map<String, String> userJikgubs; //(key : id) (value: 이름) 통계 이름 추출 용도

	public static Map<String, String> userEmails; //(key : id) (value: 이름) 통계 이름 추출 용도

	public static Map<String, Object> userNamebyEmails; //(key : id) (value: 이름) 통계 이름 추출 용도


	/***
	 *  key : code , value : name
	 */

	public static List<PersCodeInfo> compInfo = new ArrayList<>(); // 회사

	public static List<PersCodeInfo> busiInfo = new ArrayList<>(); // 사업장

	public static List<PersCodeInfo> deptInfo = new ArrayList<>();  //부서

	public static List<PersCodeInfo> jikgubInfo = new ArrayList<>(); // 직급

	public static List<PersCodeInfo> serviceInfo = new ArrayList<>(); // 서비스


	public final static String USER_FORMAT = "message.user.format";

	//db.properties 파일에 정보가 없을때 사용
	public static final String DB_IP = "10.200.10.64";
	public static final String DB_USER = "root";
	public static final String DB_PASSWORD = "root99";

	public static boolean isIPv6 = false;
	public static boolean isOCR = false;

	public static final String RULE_PATH = "/users/emassai/uacs/rule/rule.dat";
	public static final String RULE_BACKUP_PATH = "/users/emassai/uacs/rule/backup/";

	public static final String URL_PATH = "/users/emassai/makeinfo/nolog_url.json";
	public static final String URL_BACKUP_PATH = "/users/emassai/makeinfo/backup/";

	public static final String DID_PATH = "/users/emassai/uacs/did/";
	public static final String DID_TMP = "/users/emassai/uacs/did/tmp/";
	public static final String ADMIN_FILTER_TMP = "/users/emassai/filter/tmp/";
	public static final String DID_BACKUP = "/users/emassai/uacs/did/backup/";
	public static final String KEYWORD_TMP = "/users/emassai/keyword/tmp/";
	public static final String IPRANGE_TMP = "/users/emassai/iprange/tmp/";
	public static final String IPRANGE_DEPT_TMP = "/users/emassai/iprangeDept/tmp/";
	public static final String DID_XML = "did.xml";
	public static final String DID_DAT = "did_pattern.dat";

	public static final String PGMS_CONF_PATH = "/users/pgms/tellus/conf/";
	public static final String PGMS_CONF_RULE_PATH = "/users/pgms/tellus/conf/rule/";

	public static final String DECODER_CONF_PATH = "/users/las/conf";

	public static final String MESSAGE_EXPORT_PATH = "/users/emassai/message/";

	public static final int MESSAGE_EXPORT_USED_RATE = 2;

	public static String DBMS_NAME = "mysql";

	public static String CURRENT_LANGUAGE = "ko";

	public static Map<String, String> elsFields = new HashMap<>();


	public static ServiceGroupVO getServiceGroup(final String groupCd) {
		for (ServiceGroupVO service : serviceGroups) {
			if (Common.isEquals(service.getGroupCd(), groupCd)) return service;
		}
		return null;
	}

	public static String getServiceGroupNm(final String groupCd) {
		for (ServiceGroupVO service : serviceGroups) {
			if (Common.isEquals(service.getGroupCd(), groupCd)) return service.getGroupNm();
		}
		return null;
	}

	public static ServiceTypeVO getService(final String svc) {
		for (ServiceTypeVO service : serviceTypes) {
			if (Common.isEquals(service.getServiceCd(), svc)) return service;
		}
		return null;
	}

	public static String getServiceNm(final String svc) {
		for (ServiceTypeVO service : serviceTypes) {
			if (Common.isEquals(service.getServiceCd(), svc)) {
				return service.getServiceNm();
			}
		}
		return null;
	}

	public static String getServiceLv12GroupNm(final String svc) {
		for (ServiceTypeVO service : serviceTypes) {
			if (Common.nvl(service.getServiceCd()).contains(svc)) return service.getGroupNm();
		}
		return null;
	}

	public static String getServiceLv12Nm(final String svc) {
		for (ServiceTypeVO service : serviceTypes) {
			if (Common.nvl(service.getServiceCd()).contains(svc)) return service.getServiceNm();
		}
		return null;
	}


	public static String getServiceLv1Nm(final String svc) {
		for (ServiceTypeVO service : serviceTypes) {
			if (Common.isEquals(service.getServiceCd(), svc)) return service.getServiceLv1Nm();
		}
		return null;
	}

	public static String getServiceLv2Nm(final String svc) {
		for (ServiceTypeVO service : serviceTypes) {
			if (Common.isEquals(service.getServiceCd(), svc)) return service.getServiceLv2Nm();
		}
		return null;
	}

	public static String getServiceDeepNm(final String svc) {
		for (ServiceTypeVO service : serviceTypesAll) {
			if (Common.nvl(service.getServiceCd()).contains(svc)) {
				return service.getServiceNm();
			}
		}
		return null;
	}

	public static String getFirstAdminYn(final String adminId) {
		for (AdminVO service : adminList) {
			if (Common.isEquals(service.getAdminId(), adminId)) return service.getFirstAdminYn();
		}
		return null;
	}

	public static String getString(final String key) {
		return getString(key, Common.EMPTY);
	}

	public static String getString(final String key, final String defaultVal) {
		for (ConfigVO conf : configs) {
			if (Common.isEquals(conf.getConfId(), key)) return Common.nvl(conf.getVal(), defaultVal);
		}
		return defaultVal;
	}

	public static String getProtocolNm(final String protocol) {
		if (Common.isEmpty(protocol)) return "";
		if (Common.isEquals(protocol, "h2")) {
			return "http/2";
		} else {
			return "http/1";
		}
	}

	public static String getElsConvertField(String field) {
		String fieldStr = field;
		for (Map.Entry<String, String> map : elsFields.entrySet()) {
			if (map.getKey().contains(fieldStr)) {
				fieldStr = map.getValue();
				break;
			}
		}
		return fieldStr;
	}

	public boolean execute(String filePath, boolean all) {
		log.info("SQL : {}", filePath);
		if (Common.isWindow()) filePath = new File(new File(ConfigServiceImpl.class.getResource("").getPath()).getParentFile().getParentFile().getParent() + filePath).getAbsolutePath();
		Connection _con = null;
		try {
			_con = DataSourceUtils.getConnection(dataSource);
			_con.setAutoCommit(false);
			if (all) ScriptUtils.executeSqlScript(_con, new EncodedResource(new FileSystemResource(filePath)), false, false, "--", "^^^ END OF SCRIPT ^^^", "/*", "*/");
			else ScriptUtils.executeSqlScript(_con, new FileSystemResource(filePath));
			_con.commit();
			return true;
		} catch (Exception e) {
			rollback(_con);
			e.printStackTrace();
		} finally {
			close(_con);
		}
		return false;
	}
	public void close(Connection con){
		if (con != null) {
			try {
				con.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	public void rollback(Connection con){
		if (con != null) {
			try {
				con.rollback();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

	@Order(1)
	@PostConstruct
	public void init() {
		springContextUtil.setApplicationContext(applicationContext);

		String sqlPath = "/sqlmap/mappers/sql/";
		if (!Common.isWindow()) sqlPath = "/users/emassai/conf/";


		/* 연관 키워드 관련 */
		List<SearchWordVO> searchWords = searchWordService.getSearchWord(0, 1, "");
		if (searchWords.isEmpty()) {
			execute(sqlPath + "xcn_keyword.sql", false);
			execute(sqlPath + "xcn_keyword_rel.sql", false);
		}


		log.info("[CONFIG] LOAD START..");


		configs = configService.getConfList();

		reloadIpRange();

		isIPv6 = Config.getBoolean("ui.ipv6");
		log.info("[IPv6 USE] " + isIPv6);

		isOCR = Config.getBoolean("ui.ocr");
		log.info("[OCR USE] " + isOCR);

		serviceTypes = serviceTypeService.getServiceConfList();

		serviceTypesAll = serviceTypeService.getServiceDeepList();

		serviceGroups = serviceGroupService.getServiceGroupList();

		sendMailTypes = serviceTypeService.getSendMailServiceList();

		adminList = adminService.getAdminList();

		reloadUserId();

		reloadUser();

		reloadCo();

		reloadBusi();

		reloadDept();

		reloadJikgub();

		reloadEmail();

		reloadNamebyEmail();

		reloadCompInfo();

		reloadBusi();

		reloadDeptInfo();

		reloadJikgubInfo();

		reloadServiceInfo();

//		loadElsFieldMap(); // els 필드 컨버터 jsp -> java


		Locale lo = Locale.forLanguageTag(Config.getString("default.lang", "ko"));
		Locale.setDefault(lo);


		if(!Common.isEquals(lo.getLanguage(),CURRENT_LANGUAGE)) {
			if (Common.isEquals(lo.getLanguage(), "ko")) execute(sqlPath + "Update_Query_ko.sql", false);
			else execute(sqlPath + "Update_Query_en.sql", false);
		}

		CURRENT_LANGUAGE = lo.getLanguage();

		log.info("시스템 언어:{}", lo.getLanguage());

		log.info("[CONFIG] LOAD END..");

		log.info("[SCHEDULER] LOAD START..");

		//SCHEDULE_INSA_LOAD
		JobVO job = new JobVO();
		job.setJobId("SCHEDULE_INSA_LOAD");
		job.setJobClass("userJob");
		job.setCronExp(getString("insa.schedule"));
		job.setDescription("인사 연동 스케쥴러");

		if (Common.isNotEmpty(job.getCronExp()) && Common.isNotEmpty(job.getJobClass())) {
			if (Common.isEquals(getString("insa.auto"), "Y")) {
				trigger.putJob(job.getJobId(), SpringContextUtil.getBean(job.getJobClass()).getClass(), job.getCronExp(), job.getDescription());
			} else {
				trigger.deleteJob(job.getJobId());
			}
		}

		//SCHEDULE_INSA_LOAD
		JobVO deptjob = new JobVO();
		deptjob.setJobId("SCHEDULE_DEPT_LOAD");
		deptjob.setJobClass("deptRangeJob");
		deptjob.setCronExp(getString("dept.schedule"));
		deptjob.setDescription("부서 내부 IP 스케쥴러");

		if (Common.isNotEmpty(deptjob.getCronExp()) && Common.isNotEmpty(deptjob.getJobClass())) {
			if (Common.isEquals(getString("dept.auto"), "Y")) {
				trigger.putJob(deptjob.getJobId(), SpringContextUtil.getBean(deptjob.getJobClass()).getClass(), deptjob.getCronExp(), deptjob.getDescription());
			} else {
				trigger.deleteJob(deptjob.getJobId());
			}
		}

		if (Common.isNotEmpty(Config.getString("api.insa.useyn"))) {
			JobVO apiUserJob = new JobVO();
			apiUserJob.setJobId("SCHEDULE_INSA_API_LOAD");
			apiUserJob.setJobClass("userInsaJob");
			apiUserJob.setCronExp("0 0 1 * * ?");
			apiUserJob.setDescription("인사 연동 스케쥴러(API)"); //삼성생명 인사연동 스케줄러
			trigger.putJob(apiUserJob.getJobId(), SpringContextUtil.getBean(apiUserJob.getJobClass()).getClass(), apiUserJob.getCronExp(), apiUserJob.getDescription());
		}

		JobVO longTermUnusedJob = new JobVO();
		longTermUnusedJob.setJobId("SCHEDULE_LONG_TERM_UNUSED_STATUS");
		longTermUnusedJob.setJobClass("longTermUnusedJob");
		longTermUnusedJob.setCronExp("0 0 1 * * ?");
		longTermUnusedJob.setDescription("장기 미사용 운용자 상태 업데이트");
		if (Common.isNotEmpty(longTermUnusedJob.getCronExp()) && Common.isNotEmpty(longTermUnusedJob.getJobClass())) {
			trigger.putJob(longTermUnusedJob.getJobId(), SpringContextUtil.getBean(longTermUnusedJob.getJobClass()).getClass(), longTermUnusedJob.getCronExp(), longTermUnusedJob.getDescription());
		}
		QuartzCronTrigger.runJob(longTermUnusedJob);

		JobVO exportFileDelJob = new JobVO();
		exportFileDelJob.setJobId("SCHEDULE_EXPORT_DOWNLOAD_FILE_DELETE");
		exportFileDelJob.setJobClass("downloadDelJob");
		exportFileDelJob.setCronExp("0 0 1 * * ?");
		exportFileDelJob.setDescription("Export File Expire");
		trigger.putJob(exportFileDelJob.getJobId(), SpringContextUtil.getBean(exportFileDelJob.getJobClass()).getClass(), exportFileDelJob.getCronExp(), exportFileDelJob.getDescription());

		log.info("[SCHEDULER] LOAD END..");
	}


	public static int getInt(final String key) {
		return getInt(key, 0);
	}

	public static int getInt(final String key, final int defaultVal) {
		return Common.nvz(getString(key), defaultVal);
	}

	public static boolean getBoolean(final String key) {
		String val = getString(key);
		if (Common.isEquals(val, "true")) return true;
		else return false;
	}

	public static long getLong(final String key) {
		return getLong(key, 0);
	}

	public static long getLong(final String key, final long defaultVal) {
		return Common.nvn(getString(key), defaultVal);
	}

	public void reload() {
		init();
	}

	public void reloadUserId() {
		userIds = new HashMap<>();
		List<Map<String, String>> userIds2 = userService.getUserIds();
		for (Map<String, String> userId2 : userIds2) {
			userIds.put(userId2.get("hash_key"), userId2.get("value"));
		}
		log.info("사용자 아이디 : {}", userIds.size());
	}

	public void reloadUser() {
		userNames = new HashMap<>();
		List<Map<String, String>> users = userService.getUserNames();
		for (Map<String, String> user : users) {
			userNames.put(user.get("hash_key"), user.get("value"));
		}
		log.info("사용자 이름 : {}", users.size());
	}

	public void reloadCo() {
		userCoNms = new HashMap<>();
		List<Map<String, String>> cos = userService.getUserCoNms();

		for (Map<String, String> co : cos) {
			userCoNms.put(co.get("hash_key"), co.get("value"));
		}
		log.info("사용자 회사명 : {}", cos.size());
	}

	public void reloadBusi() {
		userBusiNms = new HashMap<>();
		List<Map<String, String>> bizs = userService.getUserBusiNms();
		for (Map<String, String> biz : bizs) {
			userBusiNms.put(biz.get("hash_key"), biz.get("value"));
		}
		log.info("사용자 사업장 : {}", bizs.size());
	}


	public void reloadDept() {
		userDepts = new HashMap<>();
		List<Map<String, String>> depts = userService.getUserDepts();
		for (Map<String, String> dept : depts) {
			userDepts.put(dept.get("hash_key"), dept.get("value"));
		}
		log.info("사용자 부서 : {}", depts.size());
	}

	public void reloadJikgub() {
		userJikgubs = new HashMap<>();
		List<Map<String, String>> jikgubs = userService.getUserJikgubs();
		for (Map<String, String> jikgub : jikgubs) {
			userJikgubs.put(jikgub.get("hash_key"), jikgub.get("value"));
		}
		log.info("사용자 직급 : {}", jikgubs.size());
	}

	public void reloadEmail() {
		userEmails = new HashMap<>();
		List<Map<String, String>> emails = userService.getUserEmails();
		for (Map<String, String> email : emails) {
			userEmails.put(email.get("hash_key"), email.get("value"));
		}
		log.info("사용자 Email : {}", emails.size());
	}

	public void reloadNamebyEmail() {
		userNamebyEmails = new HashMap<>();
		List<Map<String, String>> emails = userService.getUserNamebyEmail();
		for (Map<String, String> email : emails) {
			JSONObject obj = new JSONObject();
			obj.put("name", email.get("hash_name"));
			obj.put("id", email.get("hash_id"));
			userNamebyEmails.put(email.get("hash_key"), obj);
		}
		log.info("사용자 이름/아이디 : {}", emails.size());
	}


	private void reloadCompInfo() {
		List<PersCodeInfo> compInfo = userService.getCompInfo();
		Config.compInfo.addAll(compInfo);
		log.info("회사 : {}", compInfo.size());
	}

	private void reloadBusiInfo() {
		List<PersCodeInfo> busiInfo = userService.getBusiInfo();
		Config.busiInfo.addAll(busiInfo);
		log.info("사업장 : {}", busiInfo.size());
	}

	private void reloadDeptInfo() {
		List<PersCodeInfo> deptInfo = userService.getDeptInfo();
		Config.deptInfo.addAll(deptInfo);
		log.info("부서 : {}", deptInfo.size());
	}

	private void reloadJikgubInfo() {
		List<PersCodeInfo> jikgubInfo = userService.getJikgubInfo();
		Config.jikgubInfo.addAll(jikgubInfo);
		log.info("직급 : {}", jikgubInfo.size());

	}

	private void reloadServiceInfo() {
		List<PersCodeInfo> serviceInfo = userService.getServiceInfo();
		Config.serviceInfo.addAll(serviceInfo);
		log.info("서비스 : {}", serviceInfo.size());
	}

	public static String getUserId(final String userKey) {
		return Common.nvl(userIds.get(userKey.toLowerCase()));
	}

	public static String getUserName(final String userKey) {
		return Common.nvl(userNames.get(userKey.toLowerCase()));
	}

	public static String getUserConm(final String userKey) {
		return Common.nvl(userCoNms.get(userKey.toLowerCase()));
	}

	public static String getUserDeptnm(final String userKey) {
		return Common.nvl(userDepts.get(userKey.toLowerCase()));
	}

	public static String getUserBusiNm(final String userKey) {
		return Common.nvl(userBusiNms.get(userKey.toLowerCase()));
	}

	public static String getUserJikgubnm(final String userKey) {
		return Common.nvl(userJikgubs.get(userKey.toLowerCase()));
	}

	public static String getUserEmail(final String userKey) {
		return Common.nvl(userEmails.get(userKey.toLowerCase()));
	}

	public static void reloadIpRange() {
		IpRangeService ipRangeService = SpringContextUtil.getBean(IpRangeService.class);
		ipRange = ipRangeService.getIpRangeAllList();
	}

//	public static String analysisFlag(final String field, final String code) {
//		if (ElasticSearchCommon.USER_USERID.equals(field)) return getUserName(code);
//		else if (ElasticSearchCommon.USER_COCD.equals(field)) return getCompName(code);
//		else if (ElasticSearchCommon.USER_BUSICD.equals(field)) return getBusiName(code);
//		else if (ElasticSearchCommon.USER_DEPTCD.equals(field)) return getDeptName(code);
//		else if (ElasticSearchCommon.USER_JIKGUBCD.equals(field)) return getJikgubName(code);
//		else if (ElasticSearchCommon.SERVICE_SVC.equals(field)) return getServiceName(code);
//		else return code;
//	}

	public static String getCompName(final String code) {
		String result = compInfo.stream().filter(m -> Common.isEquals(code, m.getCode())).map(m -> m.getName()).collect(Collectors.joining());
		if (Common.isEmpty(result)) result = "none";
		return result;
	}

	public static String getBusiName(final String code) {
		String result = busiInfo.stream().filter(m -> Common.isEquals(code, m.getCode())).map(m -> m.getName()).collect(Collectors.joining());
		if (Common.isEmpty(result)) result = "none";
		return result;
	}

	public static String getDeptName(final String code) {
		String result = deptInfo.stream().filter(m -> Common.isEquals(code, m.getCode())).map(m -> m.getName()).collect(Collectors.joining());
		if (Common.isEmpty(result)) result = "none";
		return result;
	}

	public static String getJikgubName(final String code) {
		String result = jikgubInfo.stream().filter(m -> Common.isEquals(code, m.getCode())).map(m -> m.getName()).collect(Collectors.joining());
		if (Common.isEmpty(result)) result = "none";
		return result;
	}

	public static String getServiceName(final String code) {
		String result = serviceInfo.stream().filter(m -> Common.isEquals(code, m.getCode())).map(m -> m.getName()).collect(Collectors.joining());
		if (Common.isEmpty(result)) result = "none";
		return result;
	}

//	public static void loadElsFieldMap() {
//		elsFields.put("ctime_hh", "ctime");
//		elsFields.put("ctime_yyyymmdd", "ctime");
//		elsFields.put("ctime_yyyymm", "ctime");
//		elsFields.put("businm", ElasticSearchCommon.USER_BUSICD);
//		elsFields.put("conm", ElasticSearchCommon.USER_COCD);
//		elsFields.put("deptnm", ElasticSearchCommon.USER_DEPTCD);
//		elsFields.put("direction_svc", ElasticSearchCommon.DIRECTIONSVC);
//		elsFields.put("jikgubnm,jikgub", ElasticSearchCommon.USER_JIKGUBCD);
//	}

}