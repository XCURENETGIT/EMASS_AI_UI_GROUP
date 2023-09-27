package com.xcurenet.common.util;

import java.math.BigInteger;
import java.util.Calendar;

public class TimeUtil {

	public static long startTime;

	public static String bigPow(int x, int y) {
		String b = String.valueOf(x);
		BigInteger bi = new BigInteger("1");
		for (int i = 1; i <= y; i++) {
			bi = bi.multiply(new BigInteger(b));
		}
		return bi.toString();
	}

	public static void start() {
		TimeUtil.startTime = System.nanoTime();
	}

	public static String print() {
		long endTime = System.nanoTime();
		double elapsedTime = (endTime - TimeUtil.startTime) / 1000000.0;

		Calendar c = Calendar.getInstance();
		c.setTimeInMillis((long) elapsedTime);
		c.set(Calendar.HOUR_OF_DAY, c.get(Calendar.HOUR_OF_DAY) - 9);

		StringBuffer sb = new StringBuffer();
		if (c.get(Calendar.HOUR_OF_DAY) > 0) sb.append(c.get(Calendar.HOUR_OF_DAY) + "h ");
		if (c.get(Calendar.MINUTE) > 0) sb.append(String.format("%dm ", c.get(Calendar.MINUTE)));
		if (c.get(Calendar.SECOND) > 0) sb.append(String.format("%ds ", c.get(Calendar.SECOND)));
		if (c.get(Calendar.MILLISECOND) > 0) sb.append(String.format("%dms ", c.get(Calendar.MILLISECOND)));
		String us = String.format("%.3fus", elapsedTime);
		sb.append(us.substring(us.indexOf(".") + 1));

		return sb.toString();
	}
}
