package com.xcurenet.emass.dashboard.service.impl;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.adminFilter.service.AdminFilterVO;
import com.xcurenet.emass.dashboard.service.DashBoardService;
import com.xcurenet.emass.dashboard.service.DashboardVO;
import com.xcurenet.emass.dashboard.service.FileSendVO;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service("dashBoardService")
public class DashBoardServiceImpl extends XcnAbstractDAO implements DashBoardService {

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	@Override
	public List<DashboardVO> getDashBoardConfigs(final String adminId) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.dashboard.getDashBoardConfigs", adminId);
	}

	@Override
	public DashboardVO getDashBoardConfig(final String adminId, final String dashKey) {
		Map<String, String> params = new HashMap<>();
		params.put("adminId", adminId);
		params.put("dashKey", dashKey);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.dashboard.getDashBoardConfig", params);
	}

	@Override
	public int saveDashBoardConfig(DashboardVO dashboardVO) {
		return update("com.xcurenet.sqlmap.mappers.mysql.dashboard.saveDashBoardConfig", dashboardVO);
	}

//	@Override
//	public FileSendVO getFileSend(FileSendVO fileSendVO) throws IOException, SolrServerException {
//		FileSendVO result = new FileSendVO();
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery(String.format("+attachsize:[%s TO *] +ctime:[%s TO %s]", (fileSendVO.getFileSize() * 1024 * 1024), fileSendVO.getStartDt(), fileSendVO.getEndDt()));
//		sq.setRows(0);
//		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, fileSendVO.getAdminId());
//		result.setTotal(Config.getBoolean("ui.dashboard.abbreviation") ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
//
//		return result;
//	}

//	@Override
//	public long getAdminFilterAmount(AdminFilterVO filter) throws Exception {
//		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
//		SolrQuery sq = solrCreateQuery.createFilterQuery(filter);
//		sq.setRows(0);
//		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, filter.getAdminId());
//		return edc.getNumFound();
//	}

	@Override
	public int initDashBoardConfig(DashboardVO dashboard) {
		return update("com.xcurenet.sqlmap.mappers.mysql.dashboard.initDashBoardConfig", dashboard);
	}

    @Override
    public FileSendVO getFileSend(FileSendVO fileSendVO) throws IOException, SolrServerException {
	    FileSendVO result = new FileSendVO();
	    SolrQuery sq = new SolrQuery();
	    sq.setQuery(String.format("+attachsize:[%s TO *] +ctime:[%s TO %s]", (fileSendVO.getFileSize() * 1024 * 1024), fileSendVO.getStartDt(), fileSendVO.getEndDt()));
	    sq.setRows(0);
	    SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, fileSendVO.getAdminId());
	    result.setTotal(Config.getBoolean("ui.dashboard.abbreviation") ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));

	    return result;
    }

    @Override
    public long getAdminFilterAmount(AdminFilterVO adminFilterVo) throws Exception {
        return 0;
    }
}
