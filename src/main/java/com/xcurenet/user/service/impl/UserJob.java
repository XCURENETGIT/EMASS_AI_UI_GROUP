package com.xcurenet.user.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

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
			File insaFile = fileMerge.getInsaFile(path);
			if (!insaFile.exists()) {
				log.warn("[INSA AUTO IMPORT] FILE NOT FOUND..PATH : {}" + insaFile);
				return;
			}

			JSONArray insas = readerInsa(insaFile.getAbsolutePath(), delimiter);
			orgInfoLoad();

			List<UserVO> users = new ArrayList<>();
			for (int i = 0, s = insas.size(); i < s; i++) {
				JSONObject insa = insas.getJSONObject(i);
				UserVO user = findUserInfo(getUser(confCols, insa, basepoint, deptBasepoint));
				if (Common.isEmpty(user.getUserId())) log.warn("[USER INSA LOAD] user info load fail user id is null {}", insa);
				else if (Common.isEmpty(user.getUserNm())) log.warn("[USER INSA LOAD] user info load fail user name is null {}", insa);
				else if (Common.isEmpty(user.getUserEmail()) && Common.isEmpty(user.getUserIp())) log.warn("[USER INSA LOAD] user info load fail user email user ip is null {}", insa);
				else users.add(user);
			}
			log.info("[USER INSA LOAD] user info load end total:{}", users.size());
			log.info("[USER INSA LOAD] Org Insert new cocd:{}", newCos.size());
			log.info("[USER INSA LOAD] Org Insert new General:{}", newGeneral.size());
			log.info("[USER INSA LOAD] Org Insert new Busi:{}", newBusi.size());
			log.info("[USER INSA LOAD] Org Insert new Dept:{}", newDept.size());
			log.info("[USER INSA LOAD] Org Insert new Jikgub:{}", newJikgub.size());
			log.info("[USER INSA LOAD] Org Insert new Jikin:{}", newJikin.size());

			UserService userService = SpringContextUtil.getBean(UserService.class);

			log.info("[USER INSA LOAD] Org Insert Start : {}", Common.getDateTime(System.currentTimeMillis()));
			boolean result = userService.scheduleUser(users, newCos, newGeneral, newBusi, newDept, newJikgub, newJikin);
			log.info("[USER INSA LOAD] Org Insert end : {}", Common.getDateTime(System.currentTimeMillis()));
			if (result) {
				String backup = insaFile.getParent() + File.separator + "backup" + File.separator;
				Common.mkdirs(backup);
				File dst = new File(backup + insaFile.getName());
				try {
					FileUtils.moveFile(insaFile, dst);
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				fileMerge.backupFile(path);

				log.info("[INSA AUTO IMPORT] insa db auto import success");

				log.info("[MAKE INFO] update make info user data start");
				MakeInfoService makeInfo = SpringContextUtil.getBean(MakeInfoService.class);
				makeInfo.addInfoUser();
				log.info("[MAKE INFO] update make info user data end");
			} else {
				log.warn("[INSA AUTO IMPORT] insa db auto import fail");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			log.info("[INSA AUTO IMPORT] insa db auto import duration {}", TimeUtil.print());
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
			} else if (Common.isEquals(userAttr, "deptNm")) {
				if(Common.isEquals(deptBasepoint, "F")) {
					user.setDeptNm(val);
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
