package com.xcurenet.common.parser.mime;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;
import org.apache.james.mime4j.dom.BinaryBody;
import org.apache.james.mime4j.dom.Body;
import org.apache.james.mime4j.dom.Entity;
import org.apache.james.mime4j.dom.Message;
import org.apache.james.mime4j.dom.Multipart;
import org.apache.james.mime4j.dom.TextBody;
import org.apache.james.mime4j.dom.field.ContentDispositionField;
import org.apache.james.mime4j.dom.field.ContentIdField;
import org.apache.james.mime4j.dom.field.ContentTransferEncodingField;
import org.apache.james.mime4j.dom.field.ContentTypeField;
import org.apache.james.mime4j.message.DefaultMessageBuilder;
import org.apache.james.mime4j.message.MessageImpl;
import org.apache.james.mime4j.stream.MimeConfig;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;
import org.jsoup.select.Elements;

import com.xcurenet.common.detect.DetectCharset;
import com.xcurenet.common.util.Common;

import lombok.extern.slf4j.Slf4j;
import net.fortuna.ical4j.data.CalendarBuilder;
import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.ComponentList;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.property.Description;
import net.fortuna.ical4j.util.CompatibilityHints;

@Slf4j
public class MimeParser {

	private static final String DEFAULT_CHARSET = "EUC-KR";

	private List<MimeVo> mimeVos = new ArrayList<MimeVo>();

	private String userCharset;

	private MimeVo mimeBodyVo;

	public MimeParser(byte[] buf) {
		this(buf, null);
	}

	public MimeParser(byte[] buf, String userCharset) {
		this(new ByteArrayInputStream(buf), userCharset);
	}

	public MimeParser(InputStream in) {
		this(in, null);
	}

	public MimeParser(InputStream in, String userCharset) {
		if (Common.isNotEmpty(userCharset)) log.info("user choice charset {}", userCharset);
		this.userCharset = userCharset;
		mimeBodyVo = new MimeVo();
		try {
			loadBody(in);
			mimeBodyVo = getBodyPart();
		} catch (Exception e) {
			e.printStackTrace();
			mimeBodyVo.setBody(new ByteArrayInputStream("No Content".getBytes()));
			mimeBodyVo.setCharset(Common.UTF8);
			mimeBodyVo.setContentType("text/html");
		} finally {
			release();
			IOUtils.closeQuietly(in);
		}
	}

	private void release() {
		for (MimeVo mimeVo : mimeVos) {
			IOUtils.closeQuietly(mimeVo.getBody());
		}
	}

	public static byte[] readFully(InputStream input) throws IOException {
		byte[] buffer = new byte[8192];
		int bytesRead;
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		while ((bytesRead = input.read(buffer)) != -1) {
			output.write(buffer, 0, bytesRead);
		}
		return output.toByteArray();
	}

	public static void main(String[] args) throws Exception {
		//File _eml = new File("Z:\\07_사이트 이슈\\02_삼성전자\\K_20160202111430.989_EM-_0a71b135_cbfee3c8_c180_0050_00ba31e8.eml");
		File _eml = new File("C:\\mulgama\\20181022120158.ORGL7V6FUFI2U35NNL35KMPEFCUDBOCJ.eml");
		FileInputStream in = new FileInputStream(_eml);
		MimeParser mimeParser = new MimeParser(in);
		MimeVo mimeVo = mimeParser.getMimeBodyVo();
		FileOutputStream out = new FileOutputStream(_eml.getAbsolutePath() + "_new.html");
		IOUtils.copy(mimeVo.getBody(), out);
		IOUtils.closeQuietly(out);
	}



	private String getCharsetByRanking(MimeVo mimeVo) {
		if (Common.isNotEmpty(this.userCharset)) return this.userCharset;

		String charset = DetectCharset.getCharset(mimeVo.getBody());
		if (charset != null) return charset;

		if (mimeVo.getCharset() != null) return mimeVo.getCharset();
		return DEFAULT_CHARSET;
	}

	private MimeVo getBodyPart() {
		int bodyIndex = 0;
		log.debug("mime parts size {}", mimeVos.size());
		for (int i = 0; i < mimeVos.size(); i++) {
			MimeVo mimeVo = mimeVos.get(i);
			if (Common.isEquals(mimeVo.getContentType(), "text/html") && Common.isNotEquals(mimeVo.getDisposition(), "attachment")) {
				bodyIndex = i;
				break;
			} else if (Common.isEquals(mimeVo.getContentType(), "text/plain") && Common.isNotEquals(mimeVo.getDisposition(), "attachment")) {
				bodyIndex = i;
			}
		}
		MimeVo mimeVo = mimeVos.get(bodyIndex);
		if (Common.isEquals(mimeVo.getDisposition(), "attachment")) {
			mimeVo.setBody(new ByteArrayInputStream("\n".getBytes()));
		} else {
			mimeVo.setBody(getBody(mimeVo));
		}
		return mimeVo;
	}

	private void loadBody(final InputStream in) throws Exception {
		MimeConfig config = new MimeConfig();
		config.setMaxLineLen(Integer.MAX_VALUE);
		config.setMaxHeaderCount(Integer.MAX_VALUE);

		DefaultMessageBuilder dmb = new DefaultMessageBuilder();
		dmb.setMimeEntityConfig(config);

		Message message = dmb.parseMessage(in);
		load(message.getBody());
	}

	private void load(Body body) throws Exception {
		MimeVo mimeVo = new MimeVo();
		if (body instanceof Multipart) {
			Multipart multi = (Multipart) body;
			String preamble = multi.getPreamble();
			if (Common.isNotEmpty(preamble)) {
				MimeConfig config = new MimeConfig();
				config.setMaxLineLen(Integer.MAX_VALUE);
				config.setMaxHeaderCount(Integer.MAX_VALUE);
				DefaultMessageBuilder dmb = new DefaultMessageBuilder();
				dmb.setMimeEntityConfig(config);
				Message message = dmb.parseMessage(new ByteArrayInputStream(preamble.getBytes()));
				load(message.getBody());
			}
			for (Entity partx : multi.getBodyParts()) {
				load(partx.getBody());
			}
		} else if ((body instanceof MessageImpl)) {
			load(((MessageImpl) body).getBody());
		} else {
			mimeVo.setCharset(getCharset(body));
			mimeVo.setContentType(getContentType(body));
			mimeVo.setContentId(getContentId(body));
			mimeVo.setDisposition(getContentDisposition(body));
			mimeVo.setContentTransferEncoding(getContentTransferEncoding(body));
			if ((body instanceof BinaryBody)) {
				mimeVo.setBody(((BinaryBody) body).getInputStream());
				mimeVo.setBodyType("BINARY");
			} else {
				mimeVo.setBody(((TextBody) body).getInputStream());
				mimeVo.setBodyType("TEXT");
			}
		}
		if (mimeVo.getBody() != null) {
			mimeVos.add(mimeVo);
		}
	}

	private String getContentTransferEncoding(Body body) {
		try {
			ContentTransferEncodingField field = (ContentTransferEncodingField) body.getParent().getHeader().getField("Content-Transfer-Encoding");
			if (field != null) return field.getEncoding();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return Common.EMPTY;
	}

	/**
	 * getContentType
	 *
	 * @param body
	 * @return
	 */
	private String getContentType(Body body) {
		try {
			ContentTypeField field = (ContentTypeField) body.getParent().getHeader().getField("Content-Type");
			if (field != null) return field.getMimeType();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return Common.EMPTY;
	}

	/**
	 * getContentType
	 *
	 * @param body
	 * @return
	 */
	private String getContentId(Body body) {
		try {
			ContentIdField field = (ContentIdField) body.getParent().getHeader().getField("Content-ID");
			if (field != null) return field.getId().replaceAll("<", "").replaceAll(">", "");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return Common.EMPTY;
	}

	/**
	 * getContentType
	 *
	 * @param body
	 * @return
	 */
	private String getContentDisposition(Body body) {
		try {
			ContentDispositionField field = (ContentDispositionField) body.getParent().getHeader().getField("Content-Disposition");
			if (field != null) return field.getDispositionType();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return Common.EMPTY;
	}

	private String getCharset(Body body) {
		String charset = null;
		try {
			ContentTypeField field = (ContentTypeField) body.getParent().getHeader().getField("Content-Type");
			if (field != null) charset = field.getCharset();
			if (charset == null) {
				if ( Common.isEquals(getContentType(body), "text/html")) {
					if (body instanceof TextBody) {
						charset = getCharset(((TextBody) body).getInputStream());
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (Common.isOrEquals(charset, "&quot", "unicode", "cp-850")) charset = DEFAULT_CHARSET;
		return charset;
	}

	private String getCharset(InputStream is) {
		String charset = null;
		try {
			Document doc = Jsoup.parse(is, Common.UTF8, "");
			Elements elements = doc.getElementsByTag("meta");
			for (int i = 0; i < elements.size(); i++) {
				Node nd = elements.get(i);
				if (nd.attr("content").split(";").length >= 2) charset = nd.attr("content").split(";")[1].trim().replace("charset=", "");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(is);
		}
		return charset;
	}

	/**
	 * Text Body html tag remove
	 *
	 * @param is
	 * @param charset
	 * @param mimeType
	 * @return
	 * @throws IOException
	 */
	private InputStream getBody(MimeVo mimeVo) {
		InputStream result = null;
		try {
			log.debug("mime body contentType {}", mimeVo.getContentType());
			String charset = getCharsetByRanking(mimeVo);
			if (Common.isEquals(mimeVo.getContentType(), "text/calendar")) {
				CompatibilityHints.setHintEnabled(CompatibilityHints.KEY_NOTES_COMPATIBILITY, true);
				CompatibilityHints.setHintEnabled(CompatibilityHints.KEY_OUTLOOK_COMPATIBILITY, true);
				CompatibilityHints.setHintEnabled(CompatibilityHints.KEY_RELAXED_PARSING, true);
				CompatibilityHints.setHintEnabled(CompatibilityHints.KEY_RELAXED_VALIDATION, true);
				CompatibilityHints.setHintEnabled(CompatibilityHints.KEY_RELAXED_UNFOLDING, true);
				CalendarBuilder builder = new CalendarBuilder();
				Calendar calendar = builder.build(mimeVo.getBody());
				ComponentList list = calendar.getComponents(Component.VEVENT);
				if (list.size() > 0) {
					VEvent vEvent = (VEvent) list.get(0);
					result = new ByteArrayInputStream(getCalendarBody(vEvent, charset).getBytes(charset));
				}
			} else {
				Document doc = Jsoup.parse(mimeVo.getBody(), charset, "");
				mimeVo.getBody().reset();
				removeComments(doc);
				if (Common.isEquals(mimeVo.getContentType(), "text/html")) {
					Elements els = doc.getElementsByTag("img");
					for (int i = 0; i < els.size(); i++) {
						Element el = els.get(i);
						String cid = el.attr("src").replaceAll("cid:", "");
						for (int j = 0; j < mimeVos.size(); j++) {
							MimeVo obj = mimeVos.get(j);
							if (Common.isEquals(obj.getContentId(), cid)) {
								obj.getBody().mark(0);
								el.attr("src", "data:" + obj.getContentType() + ";" + obj.getContentTransferEncoding() + "," + encodeBase64String(obj.getBody()));
								obj.getBody().reset();
								break;
							}
						}
					}
					result = new ByteArrayInputStream(doc.html().getBytes(charset));
				} else {
					String str = toString(mimeVo.getBody(), charset);
					if(Common.isEmpty(str)) str = "No Content";
					String text = "<pre>" + str + "</pre>";
					result = new ByteArrayInputStream(text.getBytes(charset));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	private static void removeComments(Node node) {
		for (int i = 0; i < node.childNodes().size();) {
			Node child = node.childNode(i);
			if (child.nodeName().equals("#comment")) child.remove();
			else {
				removeComments(child);
				i++;
			}
		}
	}

	public String getCalendarBody(VEvent vEvent, String charset) {
		String location = "-";
		if (vEvent.getLocation() != null) location = vEvent.getLocation().getValue();

		String content = "-";
		Description desc = vEvent.getDescription();
		Property altDesc = vEvent.getProperty("X-ALT-DESC");
		if (altDesc != null) content = altDesc.getValue();
		else if (desc != null) content = desc.getValue();

		Document doc = Jsoup.parse(content);
		doc.head().appendElement("meta").attr("http-equiv", "Content-Type").attr("content", "text/html; charset=" + charset);
		String body = doc.getElementsByTag("body").html();

		StringBuffer _body = new StringBuffer();
		_body.append("<div style='border:0px solid #eeeeee;padding:5px;'>");
		_body.append("<table style='border: #e2e2e2 1px solid;line-height: 18px; margin: 1px 0px; width: 100%; font-family: 돋움,dotum; font-size: 13px; border-top: #a8adbe 1px solid' border=0 cellspacing=0 summary='Calendar Summary' cellpadding=0>");
		_body.append("<colgroup><col style='width: 110px'></col><col style='*'></col> </colgroup>");
		_body.append("<tr><th style='border-bottom: #e2e2e2 1px solid; padding-bottom: 4px; background-color: #f1f2f4; padding-left: 14px; color: #3d486f; font-size: 12px; padding-top: 6px'>Location</th>");
		_body.append("<td style='border-bottom: #e2e2e2 1px solid; padding-bottom: 4px; padding-left: 10px; padding-top: 6px'>" + location + "</td></tr>");
		_body.append("<tr><td colspan='2' style='padding-bottom: 4px; padding-left: 10px; padding-top: 6px;height:120px;'>");
		_body.append(body);
		_body.append("</td></tr>");
		_body.append("</table>");
		_body.append("</div>");
		doc.getElementsByTag("body").html(_body.toString());
		return doc.html();
	}

	public static String encodeBase64String(InputStream is) throws Exception {
		return Base64.encodeBase64String(IOUtils.toByteArray(is));
	}

	public String toString(InputStream is, String encoding) throws Exception {
		return IOUtils.toString(is, encoding);
	}

	public MimeVo getMimeBodyVo() {
		return mimeBodyVo;
	}

	public void setMimeBodyVo(MimeVo mimeBodyVo) {
		this.mimeBodyVo = mimeBodyVo;
	}
}
