package com.xcurenet.common.url;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Callable;

import org.jsoup.Connection.Method;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import com.xcurenet.common.util.Common;

public class URLInformation implements Callable<URLInformation> {
	private String url;
	private Document doc;
	private String msgId;
	private String cookie;

	public URLInformation(final Map<String, String> referer, final String msgId) throws IOException {
		if (referer != null) {
			this.url = referer.get("referer");
			this.cookie = referer.get("cookie");
		}

		this.msgId = msgId;
	}

	@Override
	public URLInformation call() throws Exception {
		loadUrl();
		return this;
	}

	private Map<String,String> getCookie(){
		if (this.cookie == null) return new HashMap<>();

		Map<String,String> result = new HashMap<>();
		String[] cookies = Common.toArray(this.cookie, ";");
		for (String cookieItem : cookies) {
			String[] item = Common.toArray(cookieItem, "=");
			result.put(item[0], item[1]);
		}
		return result;
	}

	private void loadUrl() throws IOException {
		try {
			this.doc = Jsoup.connect(url).method(Method.GET).header("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko").ignoreContentType(true).ignoreHttpErrors(true).cookies(getCookie()).referrer(url).get();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String getSiteName() {
		return doc.select("meta[property=og:site_name]").attr("content");
	}

	public String getSiteImage() {
		return doc.select("meta[property=og:image]").attr("content");
	}

	public byte[] getSiteImageFile() throws IOException {
		String img = getSiteImage();
		if (img == null) return null;
		return Jsoup.connect(img).method(Method.GET).header("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko").ignoreContentType(true).execute().bodyAsBytes();
	}

	public String getTitle() {
		return doc.title();
	}

	public String getSubject() {
		return doc.title();
	}

	public String getDescription() {
		return doc.select("meta[name=description]").attr("content");
	}

	public String getUrl() {
		return url;
	}

	public String getMsgId() {
		return msgId;
	}

	public Document getDocument() {
		return doc;
	}

	//	public static void main(String[] args) throws IOException {
	//
	//		TimeUtil.start();
	//		String url = "http://www.msn.com/ko-kr/news/national/%EB%85%B8%ED%9A%8C%EC%B0%AC-%E9%9D%91%EC%98%A4%EC%B0%AC-%EB%8C%80%EB%8B%A8%ED%9E%88-%EC%86%94%EC%A7%81%ED%95%9C-%EB%8C%80%ED%99%94-%EB%82%98%EB%88%A0/ar-BBBipdj?li=AA5a79&ocid=spartandhp";
	//		URLInformation ui = new URLInformation(url);
	//		System.out.println(ui.getTitle());
	//		System.out.println(ui.getSiteName());
	//		System.out.println(ui.getSiteImage());
	//		System.out.println(ui.getDescription());
	//		byte[] img = ui.getSiteImageFile();
	//		ByteArrayInputStream in = new ByteArrayInputStream(img);
	//		FileOutputStream out = new FileOutputStream(new File("/users/site_img.jpg"));
	//		IOUtils.copy(in, out);
	//		IOUtils.closeQuietly(in);
	//		IOUtils.closeQuietly(out);
	//		System.out.println(TimeUtil.print());
	//	}
}
