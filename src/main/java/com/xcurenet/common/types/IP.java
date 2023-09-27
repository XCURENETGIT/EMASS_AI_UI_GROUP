package com.xcurenet.common.types;

import java.io.IOException;
import java.io.Serializable;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.util.Arrays;
import java.util.regex.Pattern;

import com.xcurenet.common.util.Common;

public class IP implements Serializable {
	private static final long serialVersionUID = 7377908637131394231L;
	private static final Pattern HEX_REGEX = Pattern.compile("^[0-9a-fA-F]{1,32}$");
	private boolean isIPv6;
	private byte[] addr;
	private String canonicalAddr;
	private String rawAddr;
	private String hexAddr;
	private Long lAddr;

	public IP(String ip) throws IOException {
		if (HEX_REGEX.matcher(ip).find()) {
			byte[] b = Common.toHexToBytes(ip);
			if (b.length < 4) {
				byte[] buf = new byte[4];
				System.arraycopy(b, 0, buf, 4 - b.length, b.length);
				b = buf;
			}
			setInetAddress(InetAddress.getByAddress(b), ip);
		} else {
			setInetAddress(InetAddress.getByName(ip), ip);
		}
	}

	public IP(byte[] ip) throws IOException {
		setInetAddress(InetAddress.getByAddress(ip), Common.toHexString(ip));
	}

	public IP(InetAddress inetAddress) {
		setInetAddress(inetAddress, inetAddress.getHostAddress());
	}

	public static IP create(String ip) throws IOException {
		return Common.isEmpty(ip) ? null : new IP(ip);
	}

	private void setInetAddress(InetAddress inetAddress, String rawAddr) {
		this.isIPv6 = (inetAddress instanceof Inet6Address);
		this.addr = inetAddress.getAddress();
		this.canonicalAddr = inetAddress.getHostAddress();
		this.rawAddr = rawAddr;
	}

	public boolean isIPv4() {
		return !this.isIPv6;
	}

	public boolean isIPv6() {
		return this.isIPv6;
	}

	public String toHexString() {
		if (this.hexAddr == null) {
			this.hexAddr = Common.toHexString(this.addr);
		}
		return this.hexAddr;
	}

	public long toLong() {
		if (this.lAddr == null) {
			if (isIPv6()) {
				throw new RuntimeException("IPv4 address only");
			}
			this.lAddr = Long.valueOf(Common.inet_btol(toBytes()));
		}
		return this.lAddr.longValue();
	}

	public byte[] toBytes() {
		return this.addr;
	}

	public String toCanonicalAddr() {
		return this.canonicalAddr;
	}

	public String toRawAddr() {
		return this.rawAddr;
	}

	@Override
	public String toString() {
		return toRawAddr();
	}

	@Override
	public int hashCode() {
		return Arrays.hashCode(this.addr);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if ((obj == null) || (!(obj instanceof IP))) {
			return false;
		}
		return Arrays.equals(this.addr, ((IP) obj).toBytes());
	}
}