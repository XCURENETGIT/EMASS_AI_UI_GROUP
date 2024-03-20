package com.xcurenet;

import lombok.extern.log4j.Log4j2;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.io.FileNotFoundException;
import java.io.PrintStream;


@Log4j2
@EnableScheduling
@ServletComponentScan
@EnableAsync
@SpringBootApplication
public class EmassproApplication {

	public static void main(String[] args) throws FileNotFoundException {
		setSystemOutAndErrToLog();
		SpringApplication.run(EmassproApplication.class, args);
	}


	public static void setSystemOutAndErrToLog() {
		System.setOut(createLoggingProxy(System.out));
	}

	public static PrintStream createLoggingProxy(final PrintStream realPrintStream) {
		return new PrintStream(realPrintStream) {
			public void print(final String msg) {
				realPrintStream.print(msg);
				StackTraceElement[] stacks = Thread.currentThread().getStackTrace();
				StackTraceElement stack = null;
				for (int i = 0; i < stacks.length; i++) {
					if (i == 3) {
						stack = stacks[i];
					}
				}
				if (stack != null) {
					log.info("{}", msg);
				}
			}
		};
	}
}