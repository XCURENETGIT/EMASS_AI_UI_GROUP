package com.xcurenet;

import com.xcurenet.common.util.RunSql;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

import javax.annotation.Resource;


@EnableScheduling
@ServletComponentScan
@EnableAsync
@SpringBootApplication
public class EmassproApplication implements CommandLineRunner {

	@Resource
	RunSql runSql;

	public static void main(String[] args) {
		SpringApplication.run(EmassproApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {
		runSql.initData();
	}
}

