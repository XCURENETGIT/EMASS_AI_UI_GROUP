//package com.xcurenet.emass.message.web;
//
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//import javax.annotation.Resource;
//
//import org.apache.commons.mail.EmailException;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.context.annotation.Description;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.ResponseBody;
//import org.springframework.web.bind.annotation.RestController;
//import org.springframework.web.client.RestTemplate;
//import org.springframework.web.util.UriComponentsBuilder;
//
//import com.xcurenet.common.util.Common;
//import com.xcurenet.common.util.config.Config;
//import com.xcurenet.common.vo.XcnResponseVO;
//import com.xcurenet.common.vo.XcnRspCode;
//import com.xcurenet.emass.message.service.ApiResponseVO;
//import com.xcurenet.emass.message.service.EmsMessageService;
//import com.xcurenet.emass.reservationAlarm.service.AlarmJob;
//
//import lombok.extern.slf4j.Slf4j;
//
//@RestController
//@RequestMapping(path = "/lth/ml")
//@Slf4j
//public class EmsApiController {
//
//	@Resource(name = "emsMessageService")
//	public EmsMessageService emsMessageService;
//
//	@Autowired
//	private AlarmJob alarmjob;
//
//	RestTemplate restTemplate;
//	String infoHynix = Config.getString("info.hynix.used");
//
//	@RequestMapping(value = "/getMlResultData", produces="application/json; charset=UTF-8")
//	@Description("머신러닝 결과 데이터 받기") //dwmanager에서 보내는 api
//	@ResponseBody
//	public XcnResponseVO getMlResultData(@RequestBody Map<String, String> param) {
//
//		String filePath = param.get("filePath");
//
//		if(Common.isEquals(infoHynix, "true")) {
//			Map<String, List<String>> param1 = emsMessageService.parseJsonFile(filePath);
//			String mailText = "";
//
//			if (param1 != null) {
//				List<String> securityYnList = new ArrayList<String>();
//				securityYnList = param1.get("securityYnList");
//
//				mailText = alarmjob.getAlarmHTMLBody(param1);	//알림메일 메일 템플릿
//
//				try {
//					emsMessageService.sendSecretMail(mailText);
//				} catch (EmailException e) {
//					e.printStackTrace();
//					log.error(e.getMessage());
//				}
//			}else {
//				return new XcnResponseVO(XcnRspCode.OK);
//			}
//		}
//
//		return new XcnResponseVO(XcnRspCode.OK);
//	}
//	@RequestMapping({"/getMlResultDataTest"})
//	  @Description("머신러닝 결과 데이터 받기 테스트")	//lth ui test용 api
//	  public XcnResponseVO getMlResultDataTest(@RequestParam(value = "processId", required = true, defaultValue = "") String procId, @RequestParam(value = "filePath", required = true, defaultValue = "") String filePath) {
//
//		if(Common.isEquals(infoHynix, "true")) {
//			Map<String, List<String>> param1 = emsMessageService.parseJsonFile(filePath);
//			String mailText = "";
//
//			if (param1 != null) {
//				List<String> securityYnList = new ArrayList<String>();
//				securityYnList = param1.get("securityYnList");
//
//				mailText = alarmjob.getAlarmHTMLBody(param1);  //알림메일 메일 템플릿
//
//				try {
//					emsMessageService.sendSecretMail(mailText);
//				} catch (EmailException e) {
//					e.printStackTrace();
//					log.error(e.getMessage());
//				}
//			}else {
//				return new XcnResponseVO(XcnRspCode.OK);
//			}
//		}
//
//		return new XcnResponseVO(XcnRspCode.OK);
//
//	  }
//
//	@RequestMapping("/updateMlFeedback")
//	@Description("머신러닝 피드백 결과 반영 테스트")
//	public XcnResponseVO updateMlFeedback(@RequestParam(value="startTime", required=true, defaultValue="") String startTime, @RequestParam(value="endTime", required=true, defaultValue="") String endTime) {
//		String filePath = emsMessageService.getMlFeedbackData(startTime, endTime);
//
//		Map<String, Object> paraMap = new HashMap<>();
//		paraMap.put("filePath", filePath);
//
//		String confId = "ml.feedback.url";
//		String feedbackUrl = emsMessageService.getMlFeedbackUrl(confId);
//		//String sendUrl = makeGetUrlInfo("http://10.173.51.93:8092/dwmgr/v1.0/ml/feedback", paraMap);
//		String sendUrl = makeGetUrlInfo(feedbackUrl, paraMap);
//		log.info("Send ML Feedback url:{}, JsonfilePath:{}", sendUrl, filePath);
//
//		ApiResponseVO result = restTemplate.getForObject(sendUrl, ApiResponseVO.class);
//		log.info("Send ML Feedback result: {}", result.toString());
//
//		return new XcnResponseVO(XcnRspCode.OK);
//	}
//
//	public static String makeGetUrlInfo(String url, Map<String, Object> urlParam) {
//		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
//
//		for (Map.Entry<String, Object> entry : urlParam.entrySet()) {
//			String key = entry.getKey();
//			Object value = entry.getValue();
//			builder.queryParam(key, value);
//		}
//
//		return builder.toUriString();
//	}
//}
