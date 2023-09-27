package com.xcurenet.common.crypto;

import java.io.File;

import javax.annotation.PostConstruct;

import org.springframework.stereotype.Service;

import com.xcurenet.crypto.Crypto;
import com.xcurenet.interceptor.LoggerInterceptor;

/**
 * 암호화 파일을 복호화 할 키 문자열을 추출하여 보관한다.
 *
 * @author jochangmin
 *
 */

@Service
public class CryptoUIKey extends Thread {

	public static final String keyPath = new File(LoggerInterceptor.class.getResource("").getPath()).getParent() + "/enc/ui.key";

	private static byte[] key = null;

	public static boolean isEncrypt = false;

	@PostConstruct
	public static void loadKey() {
		byte[] key = new byte[32];
		File file = new File(keyPath);
		if (file.exists()) {
			key = Crypto.loadKeyFile(keyPath);
			isEncrypt = true;
		} else {
			isEncrypt = false;
		}
		CryptoUIKey.key = key;
	}

	public static byte[] getKey() {
		return key;
	}
}
