package com.xcurenet.emass.keyword.web;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.keyword.service.KeywordNewService;
import com.xcurenet.emass.keyword.service.keywordsNew;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Controller
@AuditParentMenu(ParentMenu.DATA_STAT)
@AuditMenu(Menu.STAT_KEYWORDNEW)
public class KeywordNewController {

	@Resource(name = "keywordNewService")
	private KeywordNewService keywordNewService ;

	@RequestMapping(value = "/getKeywordNew.xcn")
	@Description("핵심 기술 키워드 탐지 NEW HOST 10")
	@ResponseBody
	@AuditOperation(Operation.SEARCH)
	public XcnResponseVO getKeywordNew(final HttpServletRequest request) {
		keywordsNew keywords = keywordNewService.getKeywordNew(request);
		return new XcnResponseVO(XcnRspCode.OK, keywords.getKeywordsNewList(),keywords.getTotalCount());
	}


}
