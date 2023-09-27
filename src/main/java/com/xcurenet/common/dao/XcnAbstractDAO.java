package com.xcurenet.common.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.xcurenet.common.util.SpringContextUtil;

public class XcnAbstractDAO {

	@Autowired
	@Qualifier("basicSqlSession")
	private SqlSession mysqlSession;

	public TransactionManager getTransactionManager() {
		return SpringContextUtil.getBean(TransactionManager.class);
	}

	public int insert(String queryId, Object params) {
		return mysqlSession.insert(queryId, params);
	}

	public int update(String queryId, Object params) {
		return mysqlSession.update(queryId, params);
	}

	public int delete(String queryId, Object params) {
		return mysqlSession.delete(queryId, params);
	}

	public <T> T selectOne(String queryId) {
		return mysqlSession.selectOne(queryId);
	}

	public <T> T selectOne(String queryId, Object params) {
		return mysqlSession.selectOne(queryId, params);
	}

	public <E> List<E> selectList(String queryId) {
		return mysqlSession.selectList(queryId);
	}

	public <E> List<E> selectListMySQL(String queryId, Object params) {
		return mysqlSession.selectList(queryId, params);
	}

	public <E> List<E> selectList(String queryId, Object params) {
		return mysqlSession.selectList(queryId, params);
	}
}
