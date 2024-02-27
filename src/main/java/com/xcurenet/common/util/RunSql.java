//package com.xcurenet.common.util;
//
//
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.core.io.FileSystemResource;
//import org.springframework.core.io.support.EncodedResource;
//import org.springframework.jdbc.datasource.DataSourceUtils;
//import org.springframework.jdbc.datasource.init.ScriptUtils;
//import org.springframework.stereotype.Component;
//
//import javax.annotation.Resource;
//import javax.sql.DataSource;
//import java.sql.Connection;
//
//@Component
//@Slf4j
//public class RunSql {
//
//    @Resource
//    private DataSource dataSource;
//
//
//    public void initData() {
//        execute("classpath*:com/xcurenet/sqlmap/mappers/sql/procedure.sql",true);
//    }
//
//    public boolean execute(String filePath, boolean all) {
//        log.info("SQL : {}", filePath);
//
//        Connection _con = null;
//        try {
//            _con = DataSourceUtils.getConnection(dataSource);
//            _con.setAutoCommit(false);
//            if (all)
//                ScriptUtils.executeSqlScript(_con, new EncodedResource(new FileSystemResource(filePath)), false, false, "--", "^^^ END OF SCRIPT ^^^", "/*", "*/");
//            else ScriptUtils.executeSqlScript(_con, new FileSystemResource(filePath));
//            _con.commit();
//            return true;
//        } catch (Exception e) {
//            rollback(_con);
//            e.printStackTrace();
//        } finally {
//            close(_con);
//        }
//        return false;
//    }
//
//    public void close(Connection con) {
//        if (con != null) {
//            try {
//                con.close();
//            } catch (Exception e2) {
//                e2.printStackTrace();
//            }
//        }
//    }
//
//    public void rollback(Connection con) {
//        if (con != null) {
//            try {
//                con.rollback();
//            } catch (Exception e2) {
//                e2.printStackTrace();
//            }
//        }
//    }
//
//
//}
