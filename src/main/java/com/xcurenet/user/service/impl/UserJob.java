package com.xcurenet.user.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.io.FileUtils;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.stereotype.Component;

import com.xcurenet.common.csv.CsvReader;
import com.xcurenet.common.detect.DetectCharset;
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.user.service.InsaFileMerge;
import com.xcurenet.user.service.UserCommon;
import com.xcurenet.user.service.UserService;
import com.xcurenet.user.service.UserVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Slf4j
@Component
public class UserJob extends UserCommon implements Job {
	// 처리된 이메일 저장 (파일 간 중복 방지용)
	private Set<String> processedEmails = new HashSet<>();

	public static void main(String[] args) {
		/*ApplicationContext context = new ClassPathXmlApplicationContext("com/spring/context-*.xml");
		try {
			UserJob sc = (UserJob) context.getBean("userJob");
			sc.execute(null);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			((ConfigurableApplicationContext) context).close();
			System.exit(1);
		}*/
		String val = "255.255.255.255";
		String ipval = Common.ipDelZero(val);
		if(new UserJob().isIpValid(ipval)) {
			System.out.println("OK");
		} else {
			System.out.println("[USER INSA IP ADDRESS] It does not fit the ip format. : " + val);
		}
	}

	@Override
	public void execute(JobExecutionContext jobexecutioncontext) throws JobExecutionException {
		TimeUtil.start();
		try {
			String auto = Config.getString("insa.auto");
			String basepoint = Config.getString("insa.basepoint");
			String deptBasepoint = Config.getString("insa.dept.basepoint");
			String path = Config.getString("insa.path");
			String delimiter = Config.getString("insa.sepa");
			String colStr = Config.getString("insa.cols");
			colStr = colStr.replaceAll("\\\\", "");

			JSONArray confCols = Common.toJSONArray(colStr);
			log.info("[INSA AUTO IMPORT] insa db auto import start....");
			log.info("[INSA AUTO IMPORT] init config auto:{} path:{} delimiter:{} cols:{}", auto, path, delimiter, confCols);

			if (Common.isNotEquals(auto, "Y")) return;
			if (Common.isEmpty(path)) return;
			if (Common.isEmpty(delimiter)) return;
			if (confCols.size() == 0) return;

			InsaFileMerge fileMerge = new InsaFileMerge();

			String[] paths = path.split(",");

			log.info("[INSA AUTO IMPORT] file paths: {}", paths.length);

			orgInfoLoad();

			// 이메일 중복 체크를 위한 Set 초기화
			processedEmails.clear();

			// 파일별 개별 처리
			for (int i = 0; i < paths.length; i++) {
				String singlePath = paths[i].trim();
				if (Common.isEmpty(singlePath)) continue;

				// 첫 번째 파일(index 0)은 기존 파일
				boolean isFirstFile = (i == 0);
				processSingleFile(singlePath, confCols, basepoint, deptBasepoint, delimiter, fileMerge, isFirstFile);
			}

			// 모든 파일 처리 완료 후 MakeInfo 업데이트
			log.info("[MAKE INFO] update make info user data start");
			MakeInfoService makeInfo = SpringContextUtil.getBean(MakeInfoService.class);
			makeInfo.addInfoUser();
			log.info("[MAKE INFO] update make info user data end");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			log.info("[INSA AUTO IMPORT] insa db auto import duration {}", TimeUtil.print());
		}
	}

	private void processSingleFile(String singlePath, JSONArray confCols, String basepoint, String deptBasepoint, String delimiter, InsaFileMerge fileMerge, boolean isFirstFile) {
		try {
			File originalFile = new File(singlePath);
			String originalFileName = originalFile.getName();
			// 파일 처리
			File insaFile;
			insaFile = fileMerge.getInsaFile(singlePath, originalFileName);

			JSONArray insas = readerInsa(insaFile.getAbsolutePath(), delimiter);

			List<UserVO> users = new ArrayList<>();
			for (int i = 0, s = insas.size(); i < s; i++) {
				JSONObject insa = insas.getJSONObject(i);
				UserVO user = findUserInfo(getUser(confCols, insa, basepoint, deptBasepoint));

				// 두 번째 파일부터 이메일 중복 체크
				if (!isFirstFile && Common.isNotEmpty(user.getUserEmail())) {
					if (processedEmails.contains(user.getUserEmail())) {
						log.info("[USER INSA LOAD] duplicate email skipped: {}", user.getUserEmail());
						continue;
					}
				}
				if (Common.isEmpty(user.getUserId()))
					log.warn("[USER INSA LOAD] user info load fail user id is null {}", insa);
				else if (Common.isEmpty(user.getUserNm()))
					log.warn("[USER INSA LOAD] user info load fail user name is null {}", insa);
				else if (Common.isEmpty(user.getUserEmail()) && Common.isEmpty(user.getUserIp()))
					log.warn("[USER INSA LOAD] user info load fail user email user ip is null {}", insa);
				else {
					users.add(user);
					// 등록 성공한 사용자의 이메일 저장 (모든 파일에서)
					if (Common.isNotEmpty(user.getUserEmail())) {
						processedEmails.add(user.getUserEmail());
					}
				}
			}
			log.info("[USER INSA LOAD] user info load end total:{}", users.size());
			log.info("[USER INSA LOAD] Org Insert new cocd:{}", newCos.size());
			log.info("[USER INSA LOAD] Org Insert new General:{}", newGeneral.size());
			log.info("[USER INSA LOAD] Org Insert new Busi:{}", newBusi.size());
			log.info("[USER INSA LOAD] Org Insert new Dept:{}", newDept.size());
			log.info("[USER INSA LOAD] Org Insert new Jikgub:{}", newJikgub.size());
			log.info("[USER INSA LOAD] Org Insert new Jikin:{}", newJikin.size());


			// DB 업데이트 (파일별 개별 처리)
			if (users.size() > 0) {
				UserService userService = SpringContextUtil.getBean(UserService.class);

				log.info("[USER INSA LOAD] Org Insert Start : {} (first file: {})", Common.getDateTime(System.currentTimeMillis()), isFirstFile);
				boolean result = userService.scheduleUser(users, newCos, newGeneral, newBusi, newDept, newJikgub, newJikin, isFirstFile);
				log.info("[USER INSA LOAD] Org Insert end : {}", Common.getDateTime(System.currentTimeMillis()));

				if (result) {
					try {
						String backup = originalFile.getParent() + File.separator + "backup" + File.separator;
						Common.mkdirs(backup);
						log.info("[INSA AUTO IMPORT] backup root: {}", backup);


						String timestamp = Common.getDateTimeFormat();

						// 확장자 제거하고 파일명 생성
						String fileNameWithoutExt = originalFileName;
						int lastDotIndex = originalFileName.lastIndexOf('.');
						if (lastDotIndex > 0) {
							fileNameWithoutExt = originalFileName.substring(0, lastDotIndex);
						}

						// 백업 파일명: 파일명_yyyyMMddHHmmss.dat
						String backupFileName = fileNameWithoutExt + "_" + timestamp + ".dat";
						File dst = new File(backup + backupFileName);
						log.info("[INSA AUTO IMPORT] backup file: {}", dst.getAbsolutePath());

						//파일 경로로 이동
						FileUtils.moveFile(originalFile, dst);
						log.info("[INSA AUTO IMPORT] insa db auto import success");
					} catch (Exception e) {
						log.error("[INSA AUTO IMPORT] insa db auto import fail");
					}

					log.info("[INSA AUTO IMPORT] update make info user data end");
				} else {
					log.warn("[INSA AUTO IMPORT] insa db auto import fail");
				}
			}
		} catch (Exception e) {
			log.error("[INSA AUTO IMPORT] error occurred: {}", singlePath, e);
		}
	}

	public JSONArray readerInsa(final String path, final String delimiter) throws Exception {
		CsvReader reader = new CsvReader(path, DetectCharset.getCharset(path), delimiter.charAt(0));
		return reader.getList();

	}

	private UserVO getUser(JSONArray confCols, JSONObject insa, String basepoint, String deptBasepoint) {
		UserVO user = new UserVO();
		for (int j = 0, t = confCols.size(); j < t; j++) {
			String userAttr = Common.nvl(confCols.get(j));
			if (Common.isEmpty(userAttr)) continue;

			String val = Common.nvl(insa.get("COL" + j));
			if (Common.isEquals(userAttr, "userId")) {
				user.setUserId(val);
			} else if (Common.isEquals(userAttr, "userNm")) {
				user.setUserNm(val);
			} else if (Common.isEquals(userAttr, "coCd")) {
				user.setCoCd(val);
			} else if (Common.isEquals(userAttr, "coNm")) {
				user.setCoNm(val);
			} else if (Common.isEquals(userAttr, "busiNm")) {
				if(Common.isEquals(basepoint, "F")) {
					user.setBusiNm(val);
				}
			} else if (Common.isEquals(userAttr, "generalNm")) {
				user.setGeneralNm(val);
			}else if (Common.isEquals(userAttr,"sabun")){
				user.setSabun(val);
			} else if (Common.isEquals(userAttr, "deptNm")) {
				if(Common.isEquals(deptBasepoint, "F")) {
					user.setDeptNm(val);
					//회사명 + 회사 코드 없을 경우 회사 미분류로 자동 설정
					if (Common.isEmpty(user.getCoCd()) && Common.isEmpty(user.getCoNm())) user.setCoCd("C00-00");
				}
			} else if (Common.isEquals(userAttr, "jikinNm")) {
				user.setJikinNm(val);
			} else if (Common.isEquals(userAttr, "jikgubNm")) {
				user.setJikgubNm(val);
			} else if (Common.isEquals(userAttr, "userEmail")) {
				String email = Common.nvl(user.getUserEmail());
				if (Common.isNotEmpty(val) && !isEmailValid(val)) {
					log.warn("[USER INSA EMAIL] It does not fit the email format. {}", val);
					continue;
				}
				if (Common.isEmpty(email)) user.setUserEmail(val);
				else user.setUserEmail(email += "," + val);	
			} else if (Common.isEquals(userAttr, "userIp")) {
				String ipval = Common.ipDelZero(val);
				if(isIpValid(ipval)) {
					String ip = Common.nvl(user.getUserIp());
					if (Common.isEmpty(ip)) user.setUserIp(ipval);
					else user.setUserIp(ip += "," + ipval);
					
					if(basepoint.equals("I")) user.setBusiNm(findBusiNmByIpRange(user));
					if(deptBasepoint.equals("I")) user.setDeptNm(findDeptNmByIpRange(user));
				} else {
					log.warn("[USER INSA IP ADDRESS] It does not fit the ip format. {}", val);
				}
			}
		}
		return user;
	}
}
