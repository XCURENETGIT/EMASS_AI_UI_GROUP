package com.xcurenet.agent;

import com.xcurenet.common.util.Common;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import java.io.File;
import java.util.Objects;

@Log4j2
@Service
public class DecoderService {

	private static StringBuilder PAC = new StringBuilder();

	private static void header() {
		PAC.append("function FindProxyForURL(url, host) {").append("\n");
		PAC.append("\tlet proxy = \"PROXY 127.0.0.1:8080; DIRECT\";").append("\n");
	}

	private static void tail() {
		PAC.append("\treturn \"DIRECT\";").append("\n");
		PAC.append("}").append("\n");
	}

	private static void appendRule(final String host) {
		PAC.append("\tif(shExpMatch(host, \"").append(host).append("\")) return proxy;").append("\n");
	}

	private static void readXmlFile(File xmlFile) throws Exception {
		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document document = builder.parse(xmlFile);
			XPathFactory xPathFactory = XPathFactory.newInstance();
			XPath xpath = xPathFactory.newXPath();

			NodeList nodeList = (NodeList) xpath.compile("/sitexml/hosts/host").evaluate(document, XPathConstants.NODESET);
			Node largeType = (Node) xpath.compile("/sitexml/largetype").evaluate(document, XPathConstants.NODE);
			for (int i = 0; i < nodeList.getLength(); i++) {
				Node node = nodeList.item(i);
				String pattern = convertToPacPattern(node.getTextContent());
				if (Common.isOrEquals(pattern, "*.*.*.*:*")) continue;
				System.out.println(largeType.getTextContent() + "\t" + xmlFile.getName() + "\t" + pattern);
				appendRule(pattern);
			}
		} catch (Exception e) {
			//log.error("{}", xmlFile, e);
		}
	}

	public static String convertToPacPattern(String regex) {
		regex = regex.replaceAll("\\[\\[.*?]]", "*");
		regex = regex.replaceAll("^\\^", "");
		regex = regex.replaceAll("\\[\\\\S]\\*", "*");
		regex = regex.replaceAll("\\[\\\\s\\\\S]\\*", "*");
		regex = regex.replaceAll("\\[0-9]\\*", "*");
		regex = regex.replaceAll("\\\\d\\+", "*");
		regex = regex.replaceAll("\\[[^]]+]\\*", "*");
		regex = regex.replaceAll("\\\\.", ".");
		regex = regex.replaceAll("\\+", "*");
		regex = regex.replaceAll("\\(.*?\\)", "*");
		regex = regex.replaceAll("\\[\\.]", ".");
		regex = regex.replaceAll("\\[\\.]\\*", "*");
		regex = regex.replaceAll("\\*{2,}", "*");
		if (!regex.startsWith("*") && regex.contains("*")) regex = "*" + regex;
		regex = regex.replaceAll("\\*{2,}", "*");
		return regex;
	}


	public static void main(String[] args) throws Exception {
		header();
		File xmlFile = new File("D:\\las\\http_xml");
		if (xmlFile.exists()) {
			for (File xml : Objects.requireNonNull(xmlFile.listFiles())) {
				if (!xml.getName().endsWith("xml") || xml.getName().equalsIgnoreCase("default.xml")) continue;
				readXmlFile(xml);
			}
		}
		tail();
		System.out.println(PAC);
	}
}
