package com.xcurenet.common.pdf;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.StringReader;
import java.nio.charset.Charset;

import org.apache.commons.io.IOUtils;

import com.itextpdf.text.Document;
import com.itextpdf.text.PageSize;
import com.itextpdf.tool.xml.XMLWorker;
import com.itextpdf.tool.xml.XMLWorkerFontProvider;
import com.itextpdf.tool.xml.XMLWorkerHelper;
import com.itextpdf.tool.xml.css.CssFile;
import com.itextpdf.tool.xml.css.StyleAttrCSSResolver;
import com.itextpdf.tool.xml.html.CssAppliers;
import com.itextpdf.tool.xml.html.CssAppliersImpl;
import com.itextpdf.tool.xml.html.Tags;
import com.itextpdf.tool.xml.parser.XMLParser;
import com.itextpdf.tool.xml.pipeline.css.CSSResolver;
import com.itextpdf.tool.xml.pipeline.css.CssResolverPipeline;
import com.itextpdf.tool.xml.pipeline.end.PdfWriterPipeline;
import com.itextpdf.tool.xml.pipeline.html.HtmlPipeline;
import com.itextpdf.tool.xml.pipeline.html.HtmlPipelineContext;
import com.xcurenet.common.txt.TextReader;

public class HtmlConvertPdfWriter {

	private String htmlStr;
	private FileOutputStream out;
	private final String font = this.getClass().getResource("").getPath() + "../../files/font/dotum.ttf";
	private final String css = this.getClass().getResource("").getPath() + "../../files/css/pdf.css";

	public HtmlConvertPdfWriter(final String htmlStr, final FileOutputStream out) throws Exception {
		this.htmlStr = htmlStr;
		this.out = out;
		writeData();

	}

	public void writeData() throws Exception {
		Document document = new Document(PageSize.A4, 50, 50, 50, 50);

		com.itextpdf.text.pdf.PdfWriter writer = com.itextpdf.text.pdf.PdfWriter.getInstance(document, out);
		writer.setInitialLeading(12.5f);

		document.open();

		CSSResolver cssResolver = new StyleAttrCSSResolver();
		CssFile cssFile = XMLWorkerHelper.getCSS(new FileInputStream(css));
		cssResolver.addCss(cssFile);

		XMLWorkerFontProvider fontProvider = new XMLWorkerFontProvider(XMLWorkerFontProvider.DONTLOOKFORFONTS);
		fontProvider.register(font, "dotum");
		CssAppliers cssAppliers = new CssAppliersImpl(fontProvider);

		HtmlPipelineContext htmlContext = new HtmlPipelineContext(cssAppliers);
		htmlContext.setTagFactory(Tags.getHtmlTagProcessorFactory());

		// Pipelines
		PdfWriterPipeline pdf = new PdfWriterPipeline(document, writer);
		HtmlPipeline html = new HtmlPipeline(htmlContext, pdf);
		CssResolverPipeline css = new CssResolverPipeline(cssResolver, html);

		XMLWorker worker = new XMLWorker(css, true);
		XMLParser xmlParser = new XMLParser(worker, Charset.forName("UTF-8"));

		StringReader strReader = new StringReader(htmlStr);
		xmlParser.parse(strReader);
		document.close();
		writer.close();

		IOUtils.closeQuietly(out);
	}

	public static void main(String[] args) throws Exception {

		TextReader r = new TextReader();
		String html = r.read("C:\\Users\\jochangmin\\Downloads\\20161028165636.OFBU5FOO67YF25Y2KOP25VDBV257LUC4.html");
		FileOutputStream out = new FileOutputStream("d:/xcn.pdf");
		new HtmlConvertPdfWriter(html, out);
		IOUtils.closeQuietly(out);
	}
}



























