package com.xcurenet.common.util.config;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.common.schedule.service.JobVO;
import com.xcurenet.common.schedule.service.QuartzCronTrigger;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.elasticsearch.ElasticSearchCommon;
import com.xcurenet.config.service.ConfigService;
import com.xcurenet.config.service.ConfigVO;
import com.xcurenet.emass.iprange.service.IpRangeService;
import com.xcurenet.emass.iprange.service.IpRangeVO;
import com.xcurenet.emass.service.service.ServiceGroupService;
import com.xcurenet.emass.service.service.ServiceGroupVO;
import com.xcurenet.emass.service.service.ServiceTypeService;
import com.xcurenet.emass.service.service.ServiceTypeVO;
import com.xcurenet.user.service.PersCodeInfo;
import com.xcurenet.user.service.UserService;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.util.*;
import java.util.stream.Collectors;

@Service("config")
@Slf4j
@Data
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

	private static List<ConfigVO> configs;

	private static List<IpRangeVO> ipRange;

	public static List<ServiceTypeVO> serviceTypes;

	public static List<ServiceTypeVO> serviceTypesAll;

	public static List<ServiceTypeVO> sendMailTypes;

	public static List<ServiceGroupVO> serviceGroups;

	public static List<AuditRequestVO> auditRequest;

	public static List<AdminVO> adminList;

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

	public static List<PersCodeInfo>  busiInfo = new ArrayList<>(); // 사업장

	public static List<PersCodeInfo> deptInfo = new ArrayList<>();  //부서

	public static List<PersCodeInfo>  jikgubInfo = new ArrayList<>(); // 직급

	public static List<PersCodeInfo>  serviceInfo = new ArrayList<>(); // 서비스


	public final static String USER_FORMAT = "message.user.format";

	//db.properties 파일에 정보가 없을때 사용
	public static final String DB_IP = "10.200.10.64";
	public static final String DB_USER = "root";
	public static final String DB_PASSWORD = "root99";

	public static boolean isIPv6 = false;
	public static boolean isOCR = false;

	public static final String RULE_PATH = "/users/emasslth/uacs/rule/rule.dat";
	public static final String RULE_BACKUP_PATH = "/users/emasslth/uacs/rule/backup/";

	public static final String URL_PATH = "/users/emasslth/makeinfo/nolog_url.json";
	public static final String URL_BACKUP_PATH = "/users/emasslth/makeinfo/backup/";

	public static final String DID_PATH = "/users/emasslth/uacs/did/";
	public static final String DID_TMP = "/users/emasslth/uacs/did/tmp/";
	public static final String ADMIN_FILTER_TMP = "/users/emasslth/filter/tmp/";
	public static final String DID_BACKUP = "/users/emasslth/uacs/did/backup/";
	public static final String KEYWORD_TMP = "/users/emasslth/keyword/tmp/";
	public static final String IPRANGE_TMP = "/users/emasslth/iprange/tmp/";
	public static final String IPRANGE_DEPT_TMP = "/users/emasslth/iprangeDept/tmp/";
	public static final String DID_XML = "did.xml";
	public static final String DID_DAT = "did_pattern.dat";

	public static final String PGMS_CONF_PATH = "/users/pgms/tellus/conf/";
	public static final String PGMS_CONF_RULE_PATH = "/users/pgms/tellus/conf/rule/";

	public static final String DECODER_CONF_PATH = "/users/las/conf";

	public static final String MESSAGE_EXPORT_PATH = "/users/emasslth/message/";

	public static final int MESSAGE_EXPORT_USED_RATE = 2;

	public static String DBMS_NAME = "mysql";

	public static Map<String,String> elsFields = new HashMap<>();

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
			if (Common.nvl(service.getServiceCd()).indexOf(svc) > -1) return service.getGroupNm();
		}
		return null;
	}

	public static String getServiceLv12Nm(final String svc) {
		for (ServiceTypeVO service : serviceTypes) {
			if (Common.nvl(service.getServiceCd()).indexOf(svc) > -1) return service.getServiceNm();
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
			if (Common.nvl(service.getServiceCd()).indexOf(svc) > -1) {
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
		if(Common.isEmpty(protocol)) return "";
		if(Common.isEquals(protocol, "h2")){
			return "http/2";
		}else {
			return "http/1";
		}
	}

	public static String getElsConvertField(String field) {
		  String fieldStr = field;
			for(Map.Entry<String, String> map : elsFields.entrySet()){
				if(map.getKey().indexOf(fieldStr) > -1) {
					fieldStr = map.getValue();
					break;
				}
			}
			return fieldStr;
	}

	@SuppressWarnings("static-access")
	@PostConstruct
	@Order(1)
	public void init() {
		springContextUtil.setApplicationContext(applicationContext);

		log.info("[설정정보] LOAD START..");

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

		loadElsFieldMap(); // els 필드 컨버터 jsp -> java


		Locale lo = Locale.forLanguageTag(Config.getString("default.lang", "ko"));
		Locale.setDefault(lo);
		log.info("시스템 언어:{}", lo.getLanguage());

		log.info("[설정정보] LOAD END..");

		log.info("[스케쥴러] LOAD START..");

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

		if(Common.isNotEmpty(Config.getString("api.insa.useyn"))) {
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

		log.info("[스케쥴러] LOAD END..");
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
		log.info("사용자 아이디 정보 Load Start");
		userIds = new HashMap<>();
		List<Map<String, String>> userIds2 = userService.getUserIds();
		log.info("사용자 아이디 정보  Size: {}", userIds2.size());
		for (Map<String, String> userId2 : userIds2) {
			userIds.put(userId2.get("hash_key"), userId2.get("value"));
		}
		log.info("사용자 정보 Load End");
	}

	public void reloadUser() {
		log.info("사용자 정보 Load Start");
		userNames = new HashMap<>();
		List<Map<String, String>> users = userService.getUserNames();
		log.info("사용자 정보 Size: {}", users.size());
		for (Map<String, String> user : users) {
			userNames.put(user.get("hash_key"), user.get("value"));
		}
		log.info("사용자 정보 Load End");
	}

	public void reloadCo() {
		log.info("사용자 회사명 Load Start");
		userCoNms = new HashMap<>();
		List<Map<String, String>> cos = userService.getUserCoNms();
		log.info("사용자 회사명 Size: {}", cos.size());
		for (Map<String, String> co : cos) {
			userCoNms.put(co.get("hash_key"), co.get("value"));
		}
		log.info("사용자 회사명 Load End");
	}

	public void reloadBusi() {
		log.info("사용자 사업장명 Load Start");
		userBusiNms = new HashMap<>();
		List<Map<String, String>> bizs = userService.getUserBusiNms();
		log.info("사용자 사업장명 Size: {}", bizs.size());
		for (Map<String, String> biz : bizs) {
			userBusiNms.put(biz.get("hash_key"), biz.get("value"));
		}
		log.info("사용자 사업장명 Load End");
	}

	

	public void reloadDept() {
		log.info("사용자 부서명 Load Start");
		userDepts = new HashMap<>();
		List<Map<String, String>> depts = userService.getUserDepts();
		log.info("사용자 부서명 Size: {}", depts.size());
		for (Map<String, String> dept : depts) {
			userDepts.put(dept.get("hash_key"), dept.get("value"));
		}
		log.info("사용자 부서명 Load End");
	}

	public void reloadJikgub() {
		log.info("사용자 직급명 Load Start");
		userJikgubs = new HashMap<>();
		List<Map<String, String>> jikgubs = userService.getUserJikgubs();
		log.info("사용자 직급명 Size: {}", jikgubs.size());
		for (Map<String, String> jikgub : jikgubs) {
			userJikgubs.put(jikgub.get("hash_key"), jikgub.get("value"));
		}
		log.info("사용자 직급명 Load End");
	}

	public void reloadEmail() {
		log.info("사용자 Email Load Start");
		userEmails = new HashMap<>();
		List<Map<String, String>> emails = userService.getUserEmails();
		log.info("사용자 Email Size: {}", emails.size());
		for (Map<String, String> email : emails) {
			userEmails.put(email.get("hash_key"), email.get("value"));
		}
		log.info("사용자 Email Load End");
	}

	public void reloadNamebyEmail() {
		log.info("사용자 이름/아이디 Load Start");
		userNamebyEmails = new HashMap<>();
		List<Map<String, String>> emails = userService.getUserNamebyEmail();
		log.info("사용자 이름/아이디 Size: {}", emails.size());
		for (Map<String, String> email : emails) {
			JSONObject obj = new JSONObject();
			obj.put("name", email.get("hash_name"));
			obj.put("id", email.get("hash_id"));
			userNamebyEmails.put(email.get("hash_key"), obj);
		}
		log.info("사용자 이름/아이디 Load End");
	}


	private void reloadCompInfo() {

		List<PersCodeInfo> compInfo =  userService.getCompInfo();
		log.info("회사 코드맵핑정보 Load START");
		log.info("회사  Size: {}", compInfo.size());
		if(null != compInfo || compInfo.size() != 0)  this.compInfo.addAll(compInfo);
		log.info("회사 코드맵핑정보 Load End");
	}

	private void reloadBusiInfo() {
		List<PersCodeInfo> busiInfo =  userService.getBusiInfo();
		log.info("사업장 코드맵핑정보 Load START");
		log.info("사업장  Size: {}", busiInfo.size());
		if(null != busiInfo || busiInfo.size() != 0) this.busiInfo.addAll(busiInfo);
		log.info("사업장 코드맵핑정보 Load End");


	}
	private void reloadDeptInfo() {
		List<PersCodeInfo> deptInfo =  userService.getDeptInfo();
		log.info("부서 코드맵핑정보 Load START");
		log.info("부서  Size: {}", deptInfo.size());
		if(null != deptInfo || deptInfo.size() != 0) this.deptInfo.addAll(deptInfo);
		log.info("부서 코드맵핑정보 Load End");

	}

	private void reloadJikgubInfo() {
		List<PersCodeInfo> jikgubInfo =  userService.getJikgubInfo();
		log.info("직급 코드맵핑정보 Load START");
		log.info("직급  Size: {}", jikgubInfo.size());
		if(null != jikgubInfo || jikgubInfo.size() != 0) this.jikgubInfo.addAll(jikgubInfo);
		log.info("직급 코드맵핑정보 Load End");

	}

	private void reloadServiceInfo() {
		List<PersCodeInfo> serviceInfo =  userService.getServiceInfo();
		log.info("서비스 코드맵핑정보 Load START");
		log.info("서비스  Size: {}", serviceInfo.size());
		if(null != serviceInfo || serviceInfo.size() != 0) this.serviceInfo.addAll(serviceInfo);
		log.info("서비스 코드맵핑정보 Load End");
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

	public static List<IpRangeVO> getIpRange() {
		return ipRange;
	}

	public static void reloadIpRange() {
		IpRangeService ipRangeService = SpringContextUtil.getBean(IpRangeService.class);
		ipRange = ipRangeService.getIpRangeAllList();
	}

	public static String analysisFlag(final String field,final String code) {
		if(ElasticSearchCommon.USER_USERID.equals(field)) return getUserName(code);
		else if(ElasticSearchCommon.USER_COCD.equals(field)) return getCompName(code);
		else if(ElasticSearchCommon.USER_BUSICD.equals(field)) return getBusiName(code);
		else if(ElasticSearchCommon.USER_DEPTCD.equals(field)) return getDeptName(code);
		else if(ElasticSearchCommon.USER_JIKGUBCD.equals(field)) return getJikgubName(code);
		else if(ElasticSearchCommon.SERVICE_SVC.equals(field)) return getServiceName(code);
		else return code;
	}

	public static String getCompName(final String code) {
		String result = compInfo.stream().filter(m -> Common.isEquals(code,m.getCode())).map(m -> m.getName()).collect(Collectors.joining());
		if (Common.isEmpty(result)) result = "none";
		return result;
	}

	public static String getBusiName(final String code) {
		String result = busiInfo.stream().filter(m -> Common.isEquals(code,m.getCode())).map(m -> m.getName()).collect(Collectors.joining());
		if (Common.isEmpty(result)) result = "none";
		return result;
	}

	public static String getDeptName(final String code) {
		String result = deptInfo.stream().filter(m -> Common.isEquals(code,m.getCode())).map(m -> m.getName()).collect(Collectors.joining());
		if (Common.isEmpty(result)) result = "none";
		return result;
	}

	public static String getJikgubName(final String code) {
		String result = jikgubInfo.stream().filter(m -> Common.isEquals(code,m.getCode())).map(m -> m.getName()).collect(Collectors.joining());
		if (Common.isEmpty(result)) result = "none";
		return result;
	}

	public static String getServiceName(final String code) {
		String result = serviceInfo.stream().filter(m -> Common.isEquals(code,m.getCode())).map(m -> m.getName()).collect(Collectors.joining());
		if (Common.isEmpty(result)) result = "none";
		return result;
	}


	public static void loadElsFieldMap(){
		elsFields.put("ctime_hh", "ctime");
		elsFields.put("ctime_yyyymmdd", "ctime");
		elsFields.put("ctime_yyyymm", "ctime");
		elsFields.put("businm", ElasticSearchCommon.USER_BUSICD);
		elsFields.put("conm", ElasticSearchCommon.USER_COCD);
		elsFields.put("deptnm",ElasticSearchCommon.USER_DEPTCD);
		elsFields.put("direction_svc", ElasticSearchCommon.DIRECTIONSVC);
		elsFields.put("jikgubnm,jikgub", ElasticSearchCommon.USER_JIKGUBCD);
	}

}