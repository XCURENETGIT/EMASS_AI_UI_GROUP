package com.xcurenet;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;


@EnableScheduling
@ServletComponentScan
@EnableAsync
@SpringBootApplication
public class EmassproApplication {

	public static void main(String[] args) {
		SpringApplication.run(EmassproApplication.class, args);
	}

}

