package com.xcurenet.emass.keyword.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.xcurenet.emass.keyword.service.KeywordService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.keyword.service.KeywordGroupService;
import com.xcurenet.emass.keyword.service.KeywordGroupVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Slf4j
@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.KEYWORD_MGMT)
public class KeywordGroupController {

	@Resource(name = "keywordGroupService")
	public KeywordGroupService keywordGroupService;

	@Resource(name = "keywordService")
	public KeywordService keywordService;
	
	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;

	@RequestMapping(value = "/getKeywordGroupList.xcn")
	@Description("예약어 그룹 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getKeywordGroupList(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, keywordGroupService.getKeywordGroupList(Common.getParam(request)));
	}

	@RequestMapping(value = "/insertKeywordGroup.xcn")
	@Description("예약어 그룹 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertKeywordGroup(final HttpServletRequest request, KeywordGroupVO group) throws Exception {
		if (keywordGroupService.isGroupNameExist(group)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.keywordGroup", request, group.getGroupName()));
		else return new XcnResponseVO(XcnRspCode.OK, keywordGroupService.insertKeywordGroup(group));
	}

	@RequestMapping(value = "/updateKeywordGroup.xcn")
	@Description("예약어 그룹 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateKeywordGroup(final HttpServletRequest request, KeywordGroupVO group) throws Exception {
		if (keywordGroupService.isGroupNameExist(group)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.keywordGroup", request, group.getGroupName()));
		else if (Common.isEquals(group.getCoreYn(),"Y") && ((keywordService.CoreKeywordCount() + keywordService.GroupKeywordCount(group)) > 20)){
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("keyword.coreKeyword.fulladd", request));
		}
		else {
			int rs = keywordGroupService.updateKeywordGroup(group);
			makeInfoService.addInfoKeyword();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/deleteKeywordGroup.xcn")
	@Description("예약어 그룹 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteKeywordGroup(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<KeywordGroupVO> groups = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			KeywordGroupVO group = (KeywordGroupVO) JSONObject.toBean(data.getJSONObject(i), KeywordGroupVO.class);
			groups.add(group);
		}
//		String coreCheck = keywordService.isCoreGroup(groups.get(0).getGroupSeq());
		if (keywordGroupService.deleteKeywordGroup(groups) == 1) {
			makeInfoService.addInfoKeyword();
			return new XcnResponseVO(XcnRspCode.OK);
		}
		else return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
	}
}
