package com.xcurenet.searchWord.web;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.excel.XLSXReader;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.searchWord.service.SearchRelaWordVO;
import com.xcurenet.searchWord.service.SearchWordService;
import com.xcurenet.searchWord.service.SearchWordVO;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.io.FileUtils;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Controller
@AuditParentMenu(ParentMenu.SETTING)
@AuditMenu(Menu.RELATION_KEYWORD)
@Slf4j
public class SearchWordController {

    @Resource(name = "searchWordService")
    public SearchWordService searchWordService;

    @RequestMapping(value = "/getSearchWord.xcn")
    @Description("키워드 리스트 조회")
    @AuditOperation(Operation.SEARCH)
    @ResponseBody
    public XcnResponseVO getSearchWord(final HttpServletRequest request, final HttpSession httpSession) {
        String searchStr = Common.nvl(request.getParameter("searchStr"));
        int offset = Common.nvz(request.getParameter("offset"));
        int limit = Common.nvz(request.getParameter("limit"));
        return new XcnResponseVO(XcnRspCode.OK, searchWordService.getSearchWord(offset, limit, searchStr));
    }

    @RequestMapping(value = "/insertSearchWord.xcn")
    @Description("검색키워드 등록")
    @AuditOperation(Operation.INSERT)
    @ResponseBody
    public XcnResponseVO insertSearchWord(final HttpServletRequest request, SearchWordVO searchWordVO) {
        if (searchWordService.isSearchWord(searchWordVO)) {
            return new XcnResponseVO(XcnRspCode.OK, searchWordService.insertRelSearchWord(searchWordVO));
        }
        return new XcnResponseVO(XcnRspCode.OK, searchWordService.insertSearchWord(searchWordVO));
    }

    @RequestMapping(value = "/updateSearchWord.xcn")
    @Description("검색키워드 수정")
    @AuditOperation(Operation.UPDATE)
    @ResponseBody
    public XcnResponseVO updateSearchWord(final HttpServletRequest request, SearchWordVO searchWordVO) {
        if (searchWordService.isSearchWord(searchWordVO)) {
            return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.searchKeyword", request, searchWordVO.getSearchWord()));
        }
        return new XcnResponseVO(XcnRspCode.OK, searchWordService.updateSearchWord(searchWordVO));
    }

    @RequestMapping(value = "/deleteSearchWord.xcn")
    @Description("검색 키워드 삭제")
    @AuditOperation(Operation.DELETE)
    @ResponseBody
    public XcnResponseVO deleteSearchWord(final HttpServletRequest request) throws Exception {
        String deleteData = Common.nvl(request.getParameter("deleteData"));
        JSONArray data = Common.toJSONArray(deleteData);
        List<SearchWordVO> searchWords = new ArrayList<>();
        for (int i = 0; i < data.size(); i++) {
            SearchWordVO searchWordVO = (SearchWordVO) JSONObject.toBean(data.getJSONObject(i), SearchWordVO.class);
            searchWords.add(searchWordVO);
        }
        return new XcnResponseVO(XcnRspCode.OK, searchWordService.deleteSearchWord(searchWords));

    }

    @RequestMapping(value = "/deleteSearchRelaWord.xcn")
    @Description("연관 키워드 삭제")
    @AuditOperation(Operation.DELETE)
    @ResponseBody
    public XcnResponseVO deleteSearchRelaWord(final HttpServletRequest request) throws Exception {
        String deleteData = Common.nvl(request.getParameter("deleteData"));
        int keywordId = Integer.parseInt(Common.nvl(request.getParameter("keywordId")));
        JSONArray data = Common.toJSONArray(deleteData);
        List<SearchWordVO> searchWords = new ArrayList<>();
        for (int i = 0; i < data.size(); i++) {
            SearchWordVO searchWordVO = (SearchWordVO) JSONObject.toBean(data.getJSONObject(i), SearchWordVO.class);
            searchWords.add(searchWordVO);
        }
        return new XcnResponseVO(XcnRspCode.OK, searchWordService.deleteSearchRelWord(searchWords, keywordId));
    }


    @RequestMapping(value = "/importSearchWordBatch.xcn", method = RequestMethod.POST)
    @Description("키워드 파일 일괄 등록")
    @AuditOperation(Operation.INSERT)
    @ResponseBody
    public XcnResponseVO importSearchWordBatch(SearchRelaWordVO vo, HttpServletRequest request) {
        File dest = null;

        try {
            MultipartFile file = vo.getAttach();
            if (file == null || file.isEmpty()) {
                return new XcnResponseVO(XcnRspCode.OK).setMessage(Prop.propFormat("keyword.batch.upload.nofile"));
            }

            String fileName = file.getOriginalFilename();
            String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

            if (!Arrays.asList("csv", "txt", "xlsx").contains(fileExt)) {
                return new XcnResponseVO(XcnRspCode.OK).setMessage(Prop.propFormat("keyword.batch.upload.invalid.ext"));
            }

            log.info("[Keyword Batch] file: {}, format: {}", fileName, fileExt);

            String tmp = "Config.RELKEYWORD_TMP";

            Common.mkdirs(tmp);

            String tempFileName = System.currentTimeMillis() + "_" + fileName;
            dest = new File(tmp, tempFileName);

            if (dest.exists()) {
                dest.delete();
            }

            file.transferTo(dest);
            log.info("[Keyword Batch] temp file saved: {}", dest.getAbsolutePath());

            List<String> dataLines = new ArrayList<>();

            if (Common.isOrEquals(fileExt, "csv", "txt")) {
                dataLines = FileUtils.readLines(dest, Common.UTF8);
            } else if (Common.isOrEquals(fileExt, "xlsx")) {
                XLSXReader xlsxReader = new XLSXReader(dest.getAbsolutePath());
                JSONArray jsonList = xlsxReader.getList();

                for (int i = 0; i < jsonList.size(); i++) {
                    JSONObject obj = jsonList.getJSONObject(i);

                    String keyword = Common.nvl(obj.get("COL0")).trim();
                    String relationWords = Common.nvl(obj.get("COL1")).trim();
                    String weight = Common.nvl(obj.get("COL2")).trim();

                    if (!keyword.isEmpty()) {
                        String line = keyword + "|" + relationWords + "|" + weight;
                        dataLines.add(line);
                    }
                }
            }

            if (dataLines.isEmpty()) {
                return new XcnResponseVO(XcnRspCode.OK).setMessage(Prop.propFormat("keyword.batch.upload.emptyfile"));
            }

            log.info("[Keyword Batch] read lines: {}", dataLines.size());

            Map<String, Object> result = searchWordService.importSearchWordBatch(dataLines);

            return new XcnResponseVO(XcnRspCode.OK, result);

        } catch (Exception e) {
            log.error("[Keyword Batch] fail", e);
            return new XcnResponseVO(XcnRspCode.OK).setMessage(Prop.propFormat("keyword.batch.upload.error", e.getMessage()));
        } finally {
            if (dest != null && dest.exists()) {
                dest.delete();
                log.debug("[Keyword Batch] temp file deleted: {}", dest.getAbsolutePath());
            }
        }
    }

}
