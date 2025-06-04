package com.xcurenet.emass.keyword.web;

import java.io.File;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.csv.CsvReader;
import com.xcurenet.common.excel.XLSXReader;
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.keyword.service.KeywordImportVO;
import com.xcurenet.emass.keyword.service.KeywordService;
import com.xcurenet.emass.keyword.service.KeywordVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.SETTING)
@AuditMenu(Menu.KEYWORD_MGMT)
@Slf4j
public class KeywordController {

	@Resource(name = "keywordService")
	public KeywordService keywordService;

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;

	@RequestMapping(value = "/getKeywordList.xcn")
	@Description("예약어 리스트 조회(예약어 그룹 SEQ)")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getKeywordList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String searchGroupSeq = Common.nvl(request.getParameter("searchGroupSeq"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, keywordService.getKeywordList(searchGroupSeq, searchStr, offset, limit));
	}

	@RequestMapping(value = "/getKeywordAllList.xcn")
	@Description("예약어 리스트 조회(전체)")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getKeywordAllList() throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, keywordService.getKeywordAllList());
	}

	@RequestMapping(value = "/insertKeyword.xcn")
	@Description("예약어 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertKeyword(final HttpServletRequest request, KeywordVO keyword) throws Exception {
		if (keywordService.isKeywordNameExist(keyword)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.keyword", request, keyword.getKeywordName()));
		}else if (keywordService.CoreKeywordCount() >=20 && Common.isEquals(keywordService.isCoreGroup(keyword.getGroupSeq()),"Y")){
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("keyword.coreKeyword.fulladd", request));
		} else {
			int rs = keywordService.insertKeyword(keyword);
			if (Common.isEquals(keywordService.isCoreGroup(keyword.getGroupSeq()), "Y")){ //핵심 키워드 그룹에서 추가
				makeInfoService.addInfoKeywordCore();
			}
			makeInfoService.addInfoKeyword();

			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/updateKeyword.xcn")
	@Description("예약어 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateKeyword(final HttpServletRequest request, KeywordVO keyword) throws Exception {
		if (keywordService.isKeywordNameExist(keyword)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.keyword", request, keyword.getKeywordName()));
		} else {
			int rs = keywordService.updateKeyword(keyword);
			if (Common.isEquals(keywordService.isCoreGroup(keyword.getGroupSeq()), "Y")){
				makeInfoService.addInfoKeywordCore();
			}
			makeInfoService.addInfoKeyword();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/deleteKeyword.xcn")
	@Description("예약어 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteKeyword(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<KeywordVO> keywords = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			KeywordVO keyword = (KeywordVO) JSONObject.toBean(data.getJSONObject(i), KeywordVO.class);
			keywords.add(keyword);
		}
		String coreCheck = keywordService.isCoreGroup(keywords.get(0).getGroupSeq());
		int rs = keywordService.deleteKeyword(keywords);
		if (Common.isEquals(coreCheck, "Y")){
			makeInfoService.addInfoKeywordCore();
		}
		makeInfoService.addInfoKeyword();
		return new XcnResponseVO(XcnRspCode.OK, rs);
	}


	@Description("룰 구성 요소 upload")
	@RequestMapping(value = "/importKeyword.xcn", method = RequestMethod.POST)
	public void importCfComponent(KeywordImportVO vo, HttpServletResponse response, HttpServletRequest request) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Content-Type", "application/json");

		JSONObject item = new JSONObject();

		//JSONArray array = new JSONArray();
		PrintWriter pw = response.getWriter();

		MultipartFile file = vo.getAttach();
		if (file == null || file.isEmpty()) {
			item.put("success", false);
			item.put("message", Prop.propFormat("keyword.upload.fail") + " <br />" + Prop.propFormat("keyword.upload.nocontent"));
			pw.print(item);
			IOUtils.closeQuietly(pw);
			return;
		}

		String tmp = Config.KEYWORD_TMP;
		Common.mkdirs(tmp);
		File dest = new File(tmp + file.getOriginalFilename());
		if (dest.exists()) {
			dest.delete();

		}

		InputStream is = null;
		try {
			file.transferTo(dest);

			String fileName = dest.getName();
			String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length()).toLowerCase();

			JSONArray jsonList = new JSONArray();

			if(Common.isEquals(fileExt, "csv") || Common.isEquals(fileExt, "txt") || Common.isEquals(fileExt, "text")) {

				CsvReader csvReader  = new CsvReader(dest.getAbsolutePath(), vo.getEncoding(), vo.getSeparator().charAt(0));

				jsonList = csvReader.getList();
			}

			if(Common.isEquals(fileExt, "xlsx")) {

				XLSXReader xlsxReader = new XLSXReader(dest.getAbsolutePath());
				jsonList = xlsxReader.getList();
			}

			log.info("jsonList : {}", jsonList);
			item = keywordService.importKeyword(jsonList);
			makeInfoService.addInfoKeyword();
		} catch (Exception e) {
			e.printStackTrace();
			item.put("success", false);
			item.put("message", Prop.propFormat("keyword.upload.error"));
		} finally {
			if (dest.exists()) {
				dest.delete();
			}
			pw.print(item);
			pw.flush();
			IOUtils.closeQuietly(is);
			IOUtils.closeQuietly(pw);
		}
	}
}
