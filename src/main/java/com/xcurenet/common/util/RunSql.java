package com.xcurenet.common.util;


import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.support.EncodedResource;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.sql.DataSource;
import java.sql.Connection;

@Component
@Slf4j
public class RunSql {

    @Resource
    private DataSource dataSource;

    @Value("${run.createtable}")
    private String runCreateTable;
    @Value("${createTable.path}")
    private String createTablePath;


    @Value("${run.procedure}")
    private String runProcedure;
    @Value("${procedure.path}")
    private String procedurePath;

    @Value("${run.insertData}")
    private String runInsertData;
    @Value("${insertData.path}")
    private String insertDataPath;


    @Value("${run.patchData}")
    private String runPatchData;
    @Value("${patchData.path}")
    private String patchDataPath;


    @Value("${run.enUpdate}")
    private String runEnUpdate;
    @Value("${enUpdate.path}")
    private String enUpdatePath;

    @Value("${run.koUpdate}")
    private String runKoUpdate;
    @Value("${koUpdate.path}")
    private String koUpdatePath;


    private int count = 0;
    public void initData() {

        if(Common.isEquals(runCreateTable, "true")) {
            log.info("createTable.sql 실행");
            execute(createTablePath, false);
            count++;
        }
        if(Common.isEquals(runProcedure, "true")) {
            log.info("procedure.sql 실행");
            execute(procedurePath, true);
            count++;
        }
        if(Common.isEquals(runInsertData, "true")) {
            log.info("insert_data.sql 실행");
            execute(insertDataPath, false);
            count++;
        }
        if (Common.isEquals(runPatchData, "true")) {
            log.info("patch_data.sql 실행");
            execute(patchDataPath, false);
            count++;
        }
        if (Common.isEquals(runEnUpdate, "true")) {
            log.info("Update_Query_en.sql 실행");
            execute(enUpdatePath, false);
            count++;
        }
        if (Common.isEquals(runKoUpdate, "true")) {
            log.info("Update_Query_ko.sql 실행");
            execute(koUpdatePath, false);
            count++;
        }
        log.info(String.format("SQL 실행 :  %s건", count));
    }

    public boolean execute(String filePath, boolean all) {
        log.info("SQL : {}", filePath);

        Connection _con = null;
        try {
            _con = DataSourceUtils.getConnection(dataSource);
            _con.setAutoCommit(false);
            if (all)
                ScriptUtils.executeSqlScript(_con, new EncodedResource(new FileSystemResource(filePath)), false, false, "--", "^^^ END OF SCRIPT ^^^", "/*", "*/");
            else ScriptUtils.executeSqlScript(_con, new FileSystemResource(filePath));
            _con.commit();
            return true;
        } catch (Exception e) {
            rollback(_con);
            e.printStackTrace();
        } finally {
            close(_con);
        }
        return false;
    }

    public void close(Connection con) {
        if (con != null) {
            try {
                con.close();
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
    }

    public void rollback(Connection con) {
        if (con != null) {
            try {
                con.rollback();
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
    }


}
