package com.xcurenet.emass.statistics.web;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.elasticsearch.ElasticSearchCommon;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.message.newService.EmsSearchService;
import com.xcurenet.emass.message.vo.emass.EmassIntegrated;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@AuditParentMenu(ParentMenu.DATA_ANALYSIS)
@AuditMenu(Menu.STAT_USER)
public class EmsStatController {

    @Resource
    EmsSearchService emsSearchService;

    @RequestMapping(value = "/getStatList.xcn")
    @Description("통계 리스트 조회")
    @AuditOperation(Operation.SEARCH)
    @ResponseBody
    public XcnResponseVO getStatList(final HttpServletRequest request, final HttpSession session) throws IOException {
        /*############################  search param 정의 ############################*/
        Gson gson = new Gson();
        Map<String,Object> resultParam = Common.getParamMap(request);
        Map<String,Object> searchParam = new HashMap<>();
        if(!Common.isEmpty(resultParam.get("searchParam"))){
            Type type = new TypeToken<Map<String,Object>>(){}.getType();
            searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
            searchParam.put(ElasticSearchCommon.SEARCH_TYPE, ElasticSearchCommon.SEARCH_TYPE_STATISTIC);
        }
        /* 계산 (조건문) */
        EmassIntegrated emassIntegrated = setAlltotal(emsSearchService.getEmassMessage(searchParam, Common.getAdminId(request)));

        return new XcnResponseVO(XcnRspCode.OK, emassIntegrated, emassIntegrated.getTotal());
    }



    @RequestMapping(value = "/getStatDetailList.xcn")
    @Description("통계 리스트 상세 조회")
    @AuditOperation(Operation.SEARCH)
    @ResponseBody
    public XcnResponseVO getDetailList(final HttpServletRequest request, final HttpSession session) throws IOException {
        /*############################  search param 정의 ############################*/
        Gson gson = new Gson();
        Map<String,Object> resultParam = Common.getParamMap(request);
        Map<String,Object> searchParam = new HashMap<>();
        if(!Common.isEmpty(resultParam.get("searchParam"))){
            Type type = new TypeToken<Map<String,Object>>(){}.getType();
            searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
            searchParam.put(ElasticSearchCommon.SEARCH_TYPE, ElasticSearchCommon.SEARCH_TYPE_STATISTIC);
        }
        /*############################################################################*/

        EmassIntegrated emassIntegrated = emsSearchService.getEmassMessage(searchParam, Common.getAdminId(request), null, null);

        return new XcnResponseVO(XcnRspCode.OK,emassIntegrated, emassIntegrated.getTotal());
    }





    /*
     * Pivot Data 합계 구한 후 그 결과를
     * EmassIntegrated 의 Pivot Data 로 추가
     */
    private EmassIntegrated setAlltotal(EmassIntegrated edcMessage) {
        List<Map<String, Object>> resultData = edcMessage.getPivotData();
        Map<String, Object> totalItem = new HashMap<>();
        long allTotal = 0;

        for(Map<String, Object> datas : resultData) {
            allTotal = allTotal + Common.nvz(datas.get("total"));
            for(String header : edcMessage.getPivotHeader()) {
                totalItem.put(Common.nvl(header), Common.nvz(totalItem.get(header)) + Common.nvz(datas.get(header)));
            }
        }

        totalItem.put("total", allTotal);
        totalItem.put("NUM", Prop.propFormat("bodyview.total"));
        resultData.add(totalItem);
        edcMessage.setPivotData(resultData);
        return edcMessage;
    }




}
