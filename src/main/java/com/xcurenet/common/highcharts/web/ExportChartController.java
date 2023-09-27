package com.xcurenet.common.highcharts.web;

import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.common.util.Common;

@Controller
public class ExportChartController {

	@RequestMapping(value = "/exportChart.xcn")
	@Description("highcharts 내보내기")
	@ResponseBody
	public void exportChart(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		try {
			Map<String, Object> _mp = Common.getParamMap(request);
			String type = Common.nvl(_mp.get("type"));
			String svg = Common.nvl(_mp.get("svg"));
			String filename = Common.nvl(_mp.get("filename"));
			if (filename.isEmpty()) {
				filename = "ExportChart";
			}
			ServletOutputStream out = response.getOutputStream();

			type = "svg";
			String ext = "svg";
			response.setHeader("Content-disposition", "attachment; filename=" + filename + "." + ext);
			response.setHeader("Content-type", type);
			out.write(svg.getBytes());

//			String ext = "";
//			Transcoder transcoder = null;
//			ServletOutputStream out = response.getOutputStream();
//			if (!type.equals("image/svg+xml")) {
//				InputStream svgInputStream = new ByteArrayInputStream(svg.getBytes());
//				if (type.equals("image/jpeg")) {
//					ext = "jpg";
//					transcoder = new JPEGTranscoder();
//				} else if (type.equals("application/pdf")) {
//					ext = "pdf";
//					// transcoder = new PDFTranscoder();
//				} else {
//					ext = "png";
//					 transcoder = new PNGTranscoder();
//				}
//
//				response.setHeader("Content-disposition", "attachment; filename=" + filename + "." + ext);
//				response.setHeader("Content-type", type);
//
//				try {
//					new SVGExport().setInputAsString(svg).setOutput(out).setTranscoder(Format.PNG).transcode();
//					//TranscoderInput tInput = new TranscoderInput(svgInputStream);
//					//TranscoderOutput lOutput = new TranscoderOutput(out);
//					//transcoder.transcode(tInput, lOutput);
//				} catch (DOMException e) {
//					// not suport error..
//				}
//			} else {
//				ext = "svg";
//				response.setHeader("Content-disposition", "attachment; filename=" + filename + "." + ext);
//				response.setHeader("Content-type", type);
//				out.write(svg.getBytes());
//			}
			out.flush();
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
