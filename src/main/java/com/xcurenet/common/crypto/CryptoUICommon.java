package com.xcurenet.common.crypto;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.commons.io.IOUtils;

import com.xcurenet.common.util.Common;
import com.xcurenet.crypto.Crypto;
import com.xcurenet.crypto.CryptoInputStream;

public class CryptoUICommon {

	public static final int CRYPTO_MODE = Crypto.AES_256_ECB;

	public static void main(String[] args) throws Exception {
		CryptoUICommon cy = new CryptoUICommon();
		CryptoUIKey.loadKey();

		FileOutputStream out = new FileOutputStream(new File("d:/sysadmin_filter_20160809_133645.dec"));
		IOUtils.copy(cy.decrypt(new FileInputStream(new File("d:/sysadmin_filter_20160809_133645"))), out);
	}

	public byte[] encrypt(File file, OutputStream out) {
		byte[] result = null;
		FileInputStream is = null;
		try {
			is = new FileInputStream(file);
			result = new Crypto(CryptoUIKey.getKey(), CRYPTO_MODE).encrypt(is, out, file.length());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(is);
		}
		return result;
	}

	public byte[] encrypt(InputStream is, OutputStream out, long len) {
		byte[] result = null;
		try {
			result = new Crypto(CryptoUIKey.getKey(), Crypto.ARIA_128_CBC).encrypt(is, out, len );
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(is);
		}
		return result;
	}

	public long getLength(InputStream is) {
		if (is == null) return -1;
		CryptoInputStream in = null;
		try {
			in = new CryptoInputStream(new Crypto(CryptoUIKey.getKey(), CRYPTO_MODE), is);
			return in.getLength();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(in);
		}
		return -1;
	}

	public InputStream decrypt(InputStream is) {
		if (is == null) { return null; }
		try {
			return new CryptoInputStream(new Crypto(CryptoUIKey.getKey(), CRYPTO_MODE), is);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return is;
	}

	public static boolean isEncryptedFile(InputStream in) {
		if (in == null) return false;
		try {
			return Crypto.isEncryptedFile(in);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public byte[] decrypt(byte[] val) {
		if (val == null || val.length == 0) { return new byte[0]; }
		try {
			Crypto crypto = new Crypto(CryptoUIKey.getKey(), CRYPTO_MODE);
			byte[] decrypt = crypto.decrypt(val, 0, val.length);
			if (decrypt != null) { return decrypt; }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return val;
	}

	public String hash(byte[] val) {
		if (val == null || val.length == 0) { return Common.EMPTY; }

		ByteArrayInputStream in = null;
		try {
			in = new ByteArrayInputStream(val);
			return Common.toHexString(Crypto.makeIntegrityHash(CryptoUIKey.getKey(), in));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(in);
		}
		return Common.EMPTY;
	}
}
