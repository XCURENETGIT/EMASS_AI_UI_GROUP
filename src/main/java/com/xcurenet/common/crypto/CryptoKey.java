package com.xcurenet.common.crypto;

import java.io.File;

import org.springframework.stereotype.Service;

import com.xcurenet.crypto.Crypto;

import lombok.extern.slf4j.Slf4j;

/**
 * 암호화 파일을 복호화 할 키 문자열을 추출하여 보관한다.
 *
 * @author jochangmin
 *
 */

@Service
@Slf4j
public class CryptoKey {

	public static final String keyPath = "/etc/xcnkey";

	private static byte[] key = null;

	public static boolean isEncrypt = false;

	static {
		loadKey();
	}

	public static void loadKey() {
		if (key != null) return;
		byte[] key = new byte[32];
		File file = new File(keyPath);
		if (file.exists()) {
			log.info("[파일 암호화] 사용 모드");
			key = Crypto.loadKeyFile(keyPath);
			if (key == null) {
				log.error("[파일 암호화] Invaild key file " + keyPath);
			}
			isEncrypt = true;
		} else {
			log.info("[파일 암호화] 미사용 모드");
			isEncrypt = false;
		}
		CryptoKey.key = key;
	}

	public static byte[] getKey() {
		return key;
	}
}
