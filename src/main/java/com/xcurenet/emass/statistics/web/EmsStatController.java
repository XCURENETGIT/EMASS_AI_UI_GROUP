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


        return new XcnResponseVO(XcnRspCode.OK, emassIntegrated, (null == emassIntegrated.getPivotData()) ? 0L : emassIntegrated.getTotal());
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

    @RequestMapping(value = "/test_getInfoNetwork.xcn")
    @Description("개인정보 유출 관계 분석 관계도 조회")
    @ResponseBody
    public XcnResponseVO getInfoNetwork(final HttpServletRequest request, final HttpSession session) throws IOException {

        Gson gson = new Gson();
        Map<String,Object> resultParam = Common.getParamMap(request);
        Map<String,Object> searchParam = new HashMap<>();
        if(!Common.isEmpty(resultParam.get("searchParam"))){
            Type type = new TypeToken<Map<String,Object>>(){}.getType();
            searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
            searchParam.put(ElasticSearchCommon.SEARCH_TYPE, ElasticSearchCommon.SEARCH_TYPE_ANALYSIS_DETAIL);
        }
        /*############################################################################*/

        EmassIntegrated emassIntegrated = emsSearchService.getEmassMessage(searchParam, Common.getAdminId(request), null, null);

        return new XcnResponseVO(XcnRspCode.OK,emassIntegrated, emassIntegrated.getTotal());

    /*    String user_str = request.getParameter("user_str");
        String startDate = Common.nvl(request.getParameter("startDate"));
        String endDate = Common.nvl(request.getParameter("endDate"));
        String type = Common.nvl(request.getParameter("type"));
        String piCount = Common.nvl(request.getParameter("piCount"));
        String query = "";
        SolrQuery sq = new SolrQuery();
        query += String.format("+user_str:"+user_str);
        if(!(startDate.equals("") && endDate.equals(""))) {
            query += " +ctime:["+startDate+" TO "+endDate+"] ";
        }
        query += String.format("-pi_total:0");
        if(type.equals("SN")||type.equals("CN")||type.equals("DN")||type.equals("FN")||type.equals("PN")){
            query += String.format(" +(pi_"+type+":["+piCount+" TO *]) ");
        }else{
            query += String.format(" +(pi_SN:["+piCount+" TO *] pi_CN:["+piCount+" TO *] pi_DN:["+piCount+" TO *] pi_FN:["+piCount+" TO *] pi_PN:["+piCount+" TO *]) ");
        }
        System.out.println(query);
        sq.setQuery(query);
        sq.setStart(0);
        sq.setRows(Common.MAX_VALUE);
        sq.setFields("date_hh","date_yyyy","date_yyyymm","date_yyyymmdd","msgid","cid","srcip","sport","dstip","dport","svc","svc1","svc2","svc3","ltime","ctime","ctime_yyyy","ctime_yyyymm","ctime_yyyymmdd","ctime_hh","size","body_size","usr_id","usr_ip","user","userid","name","subject","host","path","xmsgkey","sender","sname","recvs","recvs_name","to","cc","bcc","tname","cocd","conm","suborgcd","suborgnm","busicd","businm","deptcd","deptnm","jikgubcd","jikgubnm","ip_cocd","ip_conm","ip_busicd","ip_businm","allofus","attached","direction","direction_svc","kwd","kwds","inside","work","attachname","attachsize","attachhash","attachtype","attachnameexist","attachcnt","body_snippet","pi_total","read_time","xrootmtr","ocr_attach_cnt","user_str","pi_SN","pi_DN","pi_PN","pi_CN","pi_FN");

        SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(request), "", null);
        return new XcnResponseVO(XcnRspCode.OK, solrVo.getEmass(), solrVo.getNumFound());*/



    }

 /*   @SuppressWarnings({"rawtypes", "unchecked"})
    private static JSONObject bucketsSetting(SimpleOrderedMap<Object> simpleOrderedMap) {
        List<String> column = new ArrayList<>();

        JSONObject json = new JSONObject();
        for(Map.Entry e : simpleOrderedMap) {
            Object value = e.getValue();
            if(column.contains(e.getKey())) {
                json.put("buckets", bucketsSetting((SimpleOrderedMap<Object>)e.getValue()).get("buckets"));
            } else if(value instanceof List) {
                List<SimpleOrderedMap<Object>> simpleOrderedMapList = (List)value;
                JSONArray jsonArray = new JSONArray();
                for (SimpleOrderedMap<Object> simpleOrderedMap2 : simpleOrderedMapList) {
                    jsonArray.add(bucketsSetting(simpleOrderedMap2));
                }
                json.put(e.getKey(), jsonArray);
            } else {
                if(value instanceof String || value instanceof Long || value instanceof Integer) {
                    json.put(e.getKey(), value);
                } else {
                    json.put(e.getKey(), Math.round((Double)value));
                }
            }
        }
        return json;
    }*/

    @RequestMapping(value = "/getInfoStatList.xcn")
    @Description("개인정보 유출 관계 분석 조회")
    @AuditOperation(Operation.SEARCH)
    @ResponseBody
    public XcnResponseVO getInfoStatList(final HttpServletRequest request, final HttpSession session) throws  IOException {

        Gson gson = new Gson();
        Map<String,Object> resultParam = Common.getParamMap(request);
        Map<String,Object> searchParam = new HashMap<>();
        if(!Common.isEmpty(resultParam.get("searchParam"))){
            Type type = new TypeToken<Map<String,Object>>(){}.getType();
            searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
            searchParam.put(ElasticSearchCommon.SEARCH_TYPE, ElasticSearchCommon.SEARCH_TYPE_ANALYSIS);
        }

        /*############################################################################*/

        EmassIntegrated emassIntegrated = setAlltotal(emsSearchService.getEmassMessage(searchParam, Common.getAdminId(request)));

        return new XcnResponseVO(XcnRspCode.OK,emassIntegrated, emassIntegrated.getTotal());



       /* String adminId = Common.nvl(request.getParameter("adminId"));
        if (Common.isEmpty(adminId)) adminId = "*";
        String startDate = Common.nvl(request.getParameter("startDate"));
        String endDate = Common.nvl(request.getParameter("endDate"));
        String detailQuery = Common.nvl(request.getParameter("detailQuery"));
        String piCount = Common.nvl(request.getParameter("piCount"));

        StringBuilder query = new StringBuilder();
        query.append(" +(pi_SN:["+piCount+" TO *] pi_CN:["+piCount+" TO *] pi_DN:["+piCount+" TO *] pi_FN:["+piCount+" TO *] pi_PN:["+piCount+" TO *]) ");
        SolrQuery sq = new SolrQuery();
        sq.setRows(0);
        sq.setParam("json.facet", FACET_QUERY);

        if(Common.isNotEmpty(startDate) && Common.isNotEmpty(endDate)) {
            query.append(String.format("+ctime:[ %s TO %s ] ", startDate, endDate));
        }
        if(Common.isNotEmpty(detailQuery)) {
            query.append(String.format(" %s ", detailQuery));
        }
        sq.setQuery(query.toString());

//		sq.setFacetLimit(limit);
//		sq.setFacetMinCount(1);
        //sq.setFacetSort("count");

        SolrEdcMessageVO solrStatVo = solrEdcService.getEmassMessage(sq, adminId);
        SimpleOrderedMap<Object> facets = solrStatVo.getFacets();
        JSONArray jArray = new JSONArray();
        //System.out.println(facets);
        if(facets != null) {
            SimpleOrderedMap<Object> map = (SimpleOrderedMap<Object>)facets.get("result");
            if(map != null) {
                List<SimpleOrderedMap<Object>> simpleOrderedMapList = (List<SimpleOrderedMap<Object>>)map.get("buckets");
                for (SimpleOrderedMap<Object> simpleOrderedMap : simpleOrderedMapList) {
                    jArray.add(bucketsSetting(simpleOrderedMap));
                }
            }
        }
        int pi_total;
        for (int i = 0; i < jArray.size(); i++) {
            pi_total = Common.nvz(jArray.getJSONObject(i).get("pi_SN")) +  Common.nvz(jArray.getJSONObject(i).get("pi_PN")) +  Common.nvz(jArray.getJSONObject(i).get("pi_DN"))+ Common.nvz(jArray.getJSONObject(i).get("pi_FN"))+ Common.nvz(jArray.getJSONObject(i).get("pi_CN"));
            jArray.getJSONObject(i).put("pi_total", pi_total);
        }
        //System.out.println("solrStatVo: " + jArray);

        return new XcnResponseVO(XcnRspCode.OK, jArray, jArray.size());
        //return new XcnResponseVO(XcnRspCode.OK, solrStatVo, solrStatVo.getNumFound());*/
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
            for(String header : edcMessage.getPivotHeader().keySet()) {
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
