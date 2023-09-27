package com.xcurenet.common.schedule.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.common.schedule.service.JobVO;
import com.xcurenet.common.schedule.service.QuartzCronTrigger;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

@Controller
public class QuartzController {

	@Autowired
	private QuartzCronTrigger trigger;

	@RequestMapping(value = "/putJob.xcn")
	@Description("스케쥴 등록")
	@ResponseBody
	public XcnResponseVO putJob(final HttpServletRequest request, final JobVO job) throws Exception {
		if (Common.isEmpty(job.getJobId())) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.empty.insert_schedule.jobid", request));
		} else if (Common.isEmpty(job.getCronExp())) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.empty.schedule", request));
		} else if (job.getJobClass() == null) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.notfound.target", request));
		}
		try {
			trigger.putJob(job.getJobId(), SpringContextUtil.getBean(job.getJobClass()).getClass(), job.getCronExp(), job.getDescription());
		} catch (Exception e) {
			e.printStackTrace();
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.insert_fail.schedule", request));
		}
		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/runJob.xcn")
	@Description("스케쥴 JOB 실행")
	@ResponseBody
	public XcnResponseVO runJob(final HttpServletRequest request, final JobVO job) throws Exception {
		if (Common.isEmpty(job.getJobId())) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.empty.execute_schedule.jobid", request));
		}
		String rtMsg = QuartzCronTrigger.runJob(job);
		if(Common.isEmpty(rtMsg)) return new XcnResponseVO(XcnRspCode.OK);
		else {
			if(Common.isEquals(rtMsg, "00")){
				rtMsg = Prop.propFormat("java.error.notfound.jobid", request);
			}else if(Common.isEquals(rtMsg, "01")){
				rtMsg = Prop.propFormat("java.error.exception", request);
			}
			
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.execute_fail.schedule", request)+"\n" + rtMsg);
		}
	}

	@RequestMapping(value = "/deleteJob.xcn")
	@Description("스케쥴 제거")
	@ResponseBody
	public XcnResponseVO deleteJob(final HttpServletRequest request, final JobVO job) throws Exception {
		if (Common.isEmpty(job.getJobId())) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.empty.delete_schedule.jobid", request));
		}
		try {
			QuartzCronTrigger.deleteJob(job.getJobId());
		} catch (Exception e) {
			e.printStackTrace();
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete_fail.schedule", request));
		}
		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/getJobList.xcn")
	@Description("스케쥴 목록 조회")
	@ResponseBody
	public XcnResponseVO getJobList(final HttpServletRequest request) throws Exception {
		try {
			return new XcnResponseVO(XcnRspCode.OK, trigger.getJobList());
		} catch (Exception e) {
			e.printStackTrace();
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.select_fail.schedule", request));
		}
	}
}
